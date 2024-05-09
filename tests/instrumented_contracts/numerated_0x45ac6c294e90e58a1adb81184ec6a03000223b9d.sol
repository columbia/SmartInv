1 //   $$$$$$\  $$\                           $$\ $$\                 $$$$$$$$\ 
2 //  $$  __$$\ $$ |                          $$ |$$ |                \____$$  |
3 //  $$ /  \__|$$ | $$$$$$\   $$$$$$\   $$$$$$$ |$$ | $$$$$$\            $$  / 
4 //  $$ |      $$ |$$  __$$\ $$  __$$\ $$  __$$ |$$ |$$  __$$\          $$  /  
5 //  $$ |      $$ |$$ /  $$ |$$ /  $$ |$$ /  $$ |$$ |$$$$$$$$ |        $$  /   
6 //  $$ |  $$\ $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |$$   ____|       $$  /    
7 //  \$$$$$$  |$$ |\$$$$$$  |\$$$$$$  |\$$$$$$$ |$$ |\$$$$$$$\       $$$$$$$$\ 
8  // \______/ \__| \______/  \______/  \_______|\__| \_______|      \________|
9 
10 // @title Cloodle-Z
11 /// @notice https://www.cloodlez.com/ https://twitter.com/CloodlesNFT
12 
13 
14 
15 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
16 
17 // SPDX-License-Identifier: MIT
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev These functions deal with verification of Merkle Trees proofs.
25  *
26  * The proofs can be generated using the JavaScript library
27  * https://github.com/miguelmota/merkletreejs[merkletreejs].
28  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
29  *
30  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
31  */
32 library MerkleProof {
33     /**
34      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
35      * defined by `root`. For this, a `proof` must be provided, containing
36      * sibling hashes on the branch from the leaf to the root of the tree. Each
37      * pair of leaves and each pair of pre-images are assumed to be sorted.
38      */
39     function verify(
40         bytes32[] memory proof,
41         bytes32 root,
42         bytes32 leaf
43     ) internal pure returns (bool) {
44         return processProof(proof, leaf) == root;
45     }
46 
47     /**
48      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
49      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
50      * hash matches the root of the tree. When processing the proof, the pairs
51      * of leafs & pre-images are assumed to be sorted.
52      *
53      * _Available since v4.4._
54      */
55     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
56         bytes32 computedHash = leaf;
57         for (uint256 i = 0; i < proof.length; i++) {
58             bytes32 proofElement = proof[i];
59             if (computedHash <= proofElement) {
60                 // Hash(current computed hash + current element of the proof)
61                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
62             } else {
63                 // Hash(current element of the proof + current computed hash)
64                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
65             }
66         }
67         return computedHash;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 // CAUTION
79 // This version of SafeMath should only be used with Solidity 0.8 or later,
80 // because it relies on the compiler's built in overflow checks.
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations.
84  *
85  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
86  * now has built in overflow checking.
87  */
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, with an overflow flag.
91      *
92      * _Available since v3.4._
93      */
94     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96             uint256 c = a + b;
97             if (c < a) return (false, 0);
98             return (true, c);
99         }
100     }
101 
102     /**
103      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         unchecked {
109             if (b > a) return (false, 0);
110             return (true, a - b);
111         }
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122             // benefit is lost if 'b' is also tested.
123             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
124             if (a == 0) return (true, 0);
125             uint256 c = a * b;
126             if (c / a != b) return (false, 0);
127             return (true, c);
128         }
129     }
130 
131     /**
132      * @dev Returns the division of two unsigned integers, with a division by zero flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             if (b == 0) return (false, 0);
139             return (true, a / b);
140         }
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         unchecked {
150             if (b == 0) return (false, 0);
151             return (true, a % b);
152         }
153     }
154 
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      *
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         return a + b;
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a - b;
181     }
182 
183     /**
184      * @dev Returns the multiplication of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `*` operator.
188      *
189      * Requirements:
190      *
191      * - Multiplication cannot overflow.
192      */
193     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a * b;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers, reverting on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator.
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a / b;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * reverting when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a % b;
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229      * overflow (when the result is negative).
230      *
231      * CAUTION: This function is deprecated because it requires allocating memory for the error
232      * message unnecessarily. For custom revert reasons use {trySub}.
233      *
234      * Counterpart to Solidity's `-` operator.
235      *
236      * Requirements:
237      *
238      * - Subtraction cannot overflow.
239      */
240     function sub(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b <= a, errorMessage);
247             return a - b;
248         }
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         unchecked {
269             require(b > 0, errorMessage);
270             return a / b;
271         }
272     }
273 
274     /**
275      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
276      * reverting with custom message when dividing by zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryMod}.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function mod(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a % b;
297         }
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Strings.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 /**
309  * @dev String operations.
310  */
311 library Strings {
312     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
313 
314     /**
315      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
316      */
317     function toString(uint256 value) internal pure returns (string memory) {
318         // Inspired by OraclizeAPI's implementation - MIT licence
319         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
320 
321         if (value == 0) {
322             return "0";
323         }
324         uint256 temp = value;
325         uint256 digits;
326         while (temp != 0) {
327             digits++;
328             temp /= 10;
329         }
330         bytes memory buffer = new bytes(digits);
331         while (value != 0) {
332             digits -= 1;
333             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
334             value /= 10;
335         }
336         return string(buffer);
337     }
338 
339     /**
340      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
341      */
342     function toHexString(uint256 value) internal pure returns (string memory) {
343         if (value == 0) {
344             return "0x00";
345         }
346         uint256 temp = value;
347         uint256 length = 0;
348         while (temp != 0) {
349             length++;
350             temp >>= 8;
351         }
352         return toHexString(value, length);
353     }
354 
355     /**
356      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
357      */
358     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
359         bytes memory buffer = new bytes(2 * length + 2);
360         buffer[0] = "0";
361         buffer[1] = "x";
362         for (uint256 i = 2 * length + 1; i > 1; --i) {
363             buffer[i] = _HEX_SYMBOLS[value & 0xf];
364             value >>= 4;
365         }
366         require(value == 0, "Strings: hex length insufficient");
367         return string(buffer);
368     }
369 }
370 
371 // File: @openzeppelin/contracts/utils/Context.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Provides information about the current execution context, including the
380  * sender of the transaction and its data. While these are generally available
381  * via msg.sender and msg.data, they should not be accessed in such a direct
382  * manner, since when dealing with meta-transactions the account sending and
383  * paying for execution may not be the actual sender (as far as an application
384  * is concerned).
385  *
386  * This contract is only required for intermediate, library-like contracts.
387  */
388 abstract contract Context {
389     function _msgSender() internal view virtual returns (address) {
390         return msg.sender;
391     }
392 
393     function _msgData() internal view virtual returns (bytes calldata) {
394         return msg.data;
395     }
396 }
397 
398 // File: @openzeppelin/contracts/access/Ownable.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 
406 /**
407  * @dev Contract module which provides a basic access control mechanism, where
408  * there is an account (an owner) that can be granted exclusive access to
409  * specific functions.
410  *
411  * By default, the owner account will be the one that deploys the contract. This
412  * can later be changed with {transferOwnership}.
413  *
414  * This module is used through inheritance. It will make available the modifier
415  * `onlyOwner`, which can be applied to your functions to restrict their use to
416  * the owner.
417  */
418 abstract contract Ownable is Context {
419     address private _owner;
420 
421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423     /**
424      * @dev Initializes the contract setting the deployer as the initial owner.
425      */
426     constructor() {
427         _transferOwnership(_msgSender());
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view virtual returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(owner() == _msgSender(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445     /**
446      * @dev Leaves the contract without owner. It will not be possible to call
447      * `onlyOwner` functions anymore. Can only be called by the current owner.
448      *
449      * NOTE: Renouncing ownership will leave the contract without an owner,
450      * thereby removing any functionality that is only available to the owner.
451      */
452     function renounceOwnership() public virtual onlyOwner {
453         _transferOwnership(address(0));
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public virtual onlyOwner {
461         require(newOwner != address(0), "Ownable: new owner is the zero address");
462         _transferOwnership(newOwner);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Internal function without access restriction.
468      */
469     function _transferOwnership(address newOwner) internal virtual {
470         address oldOwner = _owner;
471         _owner = newOwner;
472         emit OwnershipTransferred(oldOwner, newOwner);
473     }
474 }
475 
476 // File: @openzeppelin/contracts/utils/Address.sol
477 
478 
479 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Collection of functions related to the address type
485  */
486 library Address {
487     /**
488      * @dev Returns true if `account` is a contract.
489      *
490      * [IMPORTANT]
491      * ====
492      * It is unsafe to assume that an address for which this function returns
493      * false is an externally-owned account (EOA) and not a contract.
494      *
495      * Among others, `isContract` will return false for the following
496      * types of addresses:
497      *
498      *  - an externally-owned account
499      *  - a contract in construction
500      *  - an address where a contract will be created
501      *  - an address where a contract lived, but was destroyed
502      * ====
503      */
504     function isContract(address account) internal view returns (bool) {
505         // This method relies on extcodesize, which returns 0 for contracts in
506         // construction, since the code is only stored at the end of the
507         // constructor execution.
508 
509         uint256 size;
510         assembly {
511             size := extcodesize(account)
512         }
513         return size > 0;
514     }
515 
516     /**
517      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
518      * `recipient`, forwarding all available gas and reverting on errors.
519      *
520      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
521      * of certain opcodes, possibly making contracts go over the 2300 gas limit
522      * imposed by `transfer`, making them unable to receive funds via
523      * `transfer`. {sendValue} removes this limitation.
524      *
525      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
526      *
527      * IMPORTANT: because control is transferred to `recipient`, care must be
528      * taken to not create reentrancy vulnerabilities. Consider using
529      * {ReentrancyGuard} or the
530      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
531      */
532     function sendValue(address payable recipient, uint256 amount) internal {
533         require(address(this).balance >= amount, "Address: insufficient balance");
534 
535         (bool success, ) = recipient.call{value: amount}("");
536         require(success, "Address: unable to send value, recipient may have reverted");
537     }
538 
539     /**
540      * @dev Performs a Solidity function call using a low level `call`. A
541      * plain `call` is an unsafe replacement for a function call: use this
542      * function instead.
543      *
544      * If `target` reverts with a revert reason, it is bubbled up by this
545      * function (like regular Solidity function calls).
546      *
547      * Returns the raw returned data. To convert to the expected return value,
548      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
549      *
550      * Requirements:
551      *
552      * - `target` must be a contract.
553      * - calling `target` with `data` must not revert.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
558         return functionCall(target, data, "Address: low-level call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
563      * `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, 0, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but also transferring `value` wei to `target`.
578      *
579      * Requirements:
580      *
581      * - the calling contract must have an ETH balance of at least `value`.
582      * - the called Solidity function must be `payable`.
583      *
584      * _Available since v3.1._
585      */
586     function functionCallWithValue(
587         address target,
588         bytes memory data,
589         uint256 value
590     ) internal returns (bytes memory) {
591         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
596      * with `errorMessage` as a fallback revert reason when `target` reverts.
597      *
598      * _Available since v3.1._
599      */
600     function functionCallWithValue(
601         address target,
602         bytes memory data,
603         uint256 value,
604         string memory errorMessage
605     ) internal returns (bytes memory) {
606         require(address(this).balance >= value, "Address: insufficient balance for call");
607         require(isContract(target), "Address: call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.call{value: value}(data);
610         return verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a static call.
616      *
617      * _Available since v3.3._
618      */
619     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
620         return functionStaticCall(target, data, "Address: low-level static call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a static call.
626      *
627      * _Available since v3.3._
628      */
629     function functionStaticCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal view returns (bytes memory) {
634         require(isContract(target), "Address: static call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.staticcall(data);
637         return verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
642      * but performing a delegate call.
643      *
644      * _Available since v3.4._
645      */
646     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
647         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
652      * but performing a delegate call.
653      *
654      * _Available since v3.4._
655      */
656     function functionDelegateCall(
657         address target,
658         bytes memory data,
659         string memory errorMessage
660     ) internal returns (bytes memory) {
661         require(isContract(target), "Address: delegate call to non-contract");
662 
663         (bool success, bytes memory returndata) = target.delegatecall(data);
664         return verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
669      * revert reason using the provided one.
670      *
671      * _Available since v4.3._
672      */
673     function verifyCallResult(
674         bool success,
675         bytes memory returndata,
676         string memory errorMessage
677     ) internal pure returns (bytes memory) {
678         if (success) {
679             return returndata;
680         } else {
681             // Look for revert reason and bubble it up if present
682             if (returndata.length > 0) {
683                 // The easiest way to bubble the revert reason is using memory via assembly
684 
685                 assembly {
686                     let returndata_size := mload(returndata)
687                     revert(add(32, returndata), returndata_size)
688                 }
689             } else {
690                 revert(errorMessage);
691             }
692         }
693     }
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @title ERC721 token receiver interface
705  * @dev Interface for any contract that wants to support safeTransfers
706  * from ERC721 asset contracts.
707  */
708 interface IERC721Receiver {
709     /**
710      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
711      * by `operator` from `from`, this function is called.
712      *
713      * It must return its Solidity selector to confirm the token transfer.
714      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
715      *
716      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
717      */
718     function onERC721Received(
719         address operator,
720         address from,
721         uint256 tokenId,
722         bytes calldata data
723     ) external returns (bytes4);
724 }
725 
726 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev Interface of the ERC165 standard, as defined in the
735  * https://eips.ethereum.org/EIPS/eip-165[EIP].
736  *
737  * Implementers can declare support of contract interfaces, which can then be
738  * queried by others ({ERC165Checker}).
739  *
740  * For an implementation, see {ERC165}.
741  */
742 interface IERC165 {
743     /**
744      * @dev Returns true if this contract implements the interface defined by
745      * `interfaceId`. See the corresponding
746      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
747      * to learn more about how these ids are created.
748      *
749      * This function call must use less than 30 000 gas.
750      */
751     function supportsInterface(bytes4 interfaceId) external view returns (bool);
752 }
753 
754 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @dev Implementation of the {IERC165} interface.
764  *
765  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
766  * for the additional interface id that will be supported. For example:
767  *
768  * ```solidity
769  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
771  * }
772  * ```
773  *
774  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
775  */
776 abstract contract ERC165 is IERC165 {
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
781         return interfaceId == type(IERC165).interfaceId;
782     }
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @dev Required interface of an ERC721 compliant contract.
795  */
796 interface IERC721 is IERC165 {
797     /**
798      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
799      */
800     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
801 
802     /**
803      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
804      */
805     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
806 
807     /**
808      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
809      */
810     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
811 
812     /**
813      * @dev Returns the number of tokens in ``owner``'s account.
814      */
815     function balanceOf(address owner) external view returns (uint256 balance);
816 
817     /**
818      * @dev Returns the owner of the `tokenId` token.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function ownerOf(uint256 tokenId) external view returns (address owner);
825 
826     /**
827      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
828      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) external;
845 
846     /**
847      * @dev Transfers `tokenId` token from `from` to `to`.
848      *
849      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
850      *
851      * Requirements:
852      *
853      * - `from` cannot be the zero address.
854      * - `to` cannot be the zero address.
855      * - `tokenId` token must be owned by `from`.
856      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
857      *
858      * Emits a {Transfer} event.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) external;
865 
866     /**
867      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
868      * The approval is cleared when the token is transferred.
869      *
870      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
871      *
872      * Requirements:
873      *
874      * - The caller must own the token or be an approved operator.
875      * - `tokenId` must exist.
876      *
877      * Emits an {Approval} event.
878      */
879     function approve(address to, uint256 tokenId) external;
880 
881     /**
882      * @dev Returns the account approved for `tokenId` token.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function getApproved(uint256 tokenId) external view returns (address operator);
889 
890     /**
891      * @dev Approve or remove `operator` as an operator for the caller.
892      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
893      *
894      * Requirements:
895      *
896      * - The `operator` cannot be the caller.
897      *
898      * Emits an {ApprovalForAll} event.
899      */
900     function setApprovalForAll(address operator, bool _approved) external;
901 
902     /**
903      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
904      *
905      * See {setApprovalForAll}
906      */
907     function isApprovedForAll(address owner, address operator) external view returns (bool);
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes calldata data
927     ) external;
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
931 
932 
933 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 /**
939  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
940  * @dev See https://eips.ethereum.org/EIPS/eip-721
941  */
942 interface IERC721Enumerable is IERC721 {
943     /**
944      * @dev Returns the total amount of tokens stored by the contract.
945      */
946     function totalSupply() external view returns (uint256);
947 
948     /**
949      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
950      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
951      */
952     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
953 
954     /**
955      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
956      * Use along with {totalSupply} to enumerate all tokens.
957      */
958     function tokenByIndex(uint256 index) external view returns (uint256);
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
962 
963 
964 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
971  * @dev See https://eips.ethereum.org/EIPS/eip-721
972  */
973 interface IERC721Metadata is IERC721 {
974     /**
975      * @dev Returns the token collection name.
976      */
977     function name() external view returns (string memory);
978 
979     /**
980      * @dev Returns the token collection symbol.
981      */
982     function symbol() external view returns (string memory);
983 
984     /**
985      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
986      */
987     function tokenURI(uint256 tokenId) external view returns (string memory);
988 }
989 
990 // File: contracts/ERC721A.sol
991 
992 
993 // Creators: locationtba.eth, 2pmflow.eth
994 
995 pragma solidity ^0.8.10;
996 
997 
998 
999 
1000 
1001 
1002 
1003 
1004 
1005 /**
1006  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1007  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1008  *
1009  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1010  *
1011  * Does not support burning tokens to address(0).
1012  */
1013 contract ERC721A is
1014   Context,
1015   ERC165,
1016   IERC721,
1017   IERC721Metadata,
1018   IERC721Enumerable
1019 {
1020   using Address for address;
1021   using Strings for uint256;
1022 
1023   struct TokenOwnership {
1024     address addr;
1025     uint64 startTimestamp;
1026   }
1027 
1028   struct AddressData {
1029     uint128 balance;
1030     uint128 numberMinted;
1031   }
1032 
1033   uint256 private currentIndex = 0;
1034 
1035   uint256 public immutable maxBatchSize;
1036 
1037   // Token name
1038   string private _name;
1039 
1040   // Token symbol
1041   string private _symbol;
1042 
1043   // Mapping from token ID to ownership details
1044   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1045   mapping(uint256 => TokenOwnership) private _ownerships;
1046 
1047   // Mapping owner address to address data
1048   mapping(address => AddressData) private _addressData;
1049 
1050   // Mapping from token ID to approved address
1051   mapping(uint256 => address) private _tokenApprovals;
1052 
1053   // Mapping from owner to operator approvals
1054   mapping(address => mapping(address => bool)) private _operatorApprovals;
1055 
1056   /**
1057    * @dev
1058    * `maxBatchSize` refers to how much a minter can mint at a time.
1059    */
1060   constructor(
1061     string memory name_,
1062     string memory symbol_,
1063     uint256 maxBatchSize_
1064   ) {
1065     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1066     _name = name_;
1067     _symbol = symbol_;
1068     maxBatchSize = maxBatchSize_;
1069   }
1070 
1071   /**
1072    * @dev See {IERC721Enumerable-totalSupply}.
1073    */
1074   function totalSupply() public view override returns (uint256) {
1075     return currentIndex;
1076   }
1077 
1078   /**
1079    * @dev See {IERC721Enumerable-tokenByIndex}.
1080    */
1081   function tokenByIndex(uint256 index) public view override returns (uint256) {
1082     require(index < totalSupply(), "ERC721A: global index out of bounds");
1083     return index;
1084   }
1085 
1086   /**
1087    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1088    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1089    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1090    */
1091   function tokenOfOwnerByIndex(address owner, uint256 index)
1092     public
1093     view
1094     override
1095     returns (uint256)
1096   {
1097     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1098     uint256 numMintedSoFar = totalSupply();
1099     uint256 tokenIdsIdx = 0;
1100     address currOwnershipAddr = address(0);
1101     for (uint256 i = 0; i < numMintedSoFar; i++) {
1102       TokenOwnership memory ownership = _ownerships[i];
1103       if (ownership.addr != address(0)) {
1104         currOwnershipAddr = ownership.addr;
1105       }
1106       if (currOwnershipAddr == owner) {
1107         if (tokenIdsIdx == index) {
1108           return i;
1109         }
1110         tokenIdsIdx++;
1111       }
1112     }
1113     revert("ERC721A: unable to get token of owner by index");
1114   }
1115 
1116   /**
1117    * @dev See {IERC165-supportsInterface}.
1118    */
1119   function supportsInterface(bytes4 interfaceId)
1120     public
1121     view
1122     virtual
1123     override(ERC165, IERC165)
1124     returns (bool)
1125   {
1126     return
1127       interfaceId == type(IERC721).interfaceId ||
1128       interfaceId == type(IERC721Metadata).interfaceId ||
1129       interfaceId == type(IERC721Enumerable).interfaceId ||
1130       super.supportsInterface(interfaceId);
1131   }
1132 
1133   /**
1134    * @dev See {IERC721-balanceOf}.
1135    */
1136   function balanceOf(address owner) public view override returns (uint256) {
1137     require(owner != address(0), "ERC721A: balance query for the zero address");
1138     return uint256(_addressData[owner].balance);
1139   }
1140 
1141   function _numberMinted(address owner) internal view returns (uint256) {
1142     require(
1143       owner != address(0),
1144       "ERC721A: number minted query for the zero address"
1145     );
1146     return uint256(_addressData[owner].numberMinted);
1147   }
1148 
1149   function ownershipOf(uint256 tokenId)
1150     internal
1151     view
1152     returns (TokenOwnership memory)
1153   {
1154     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1155 
1156     uint256 lowestTokenToCheck;
1157     if (tokenId >= maxBatchSize) {
1158       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1159     }
1160 
1161     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1162       TokenOwnership memory ownership = _ownerships[curr];
1163       if (ownership.addr != address(0)) {
1164         return ownership;
1165       }
1166     }
1167 
1168     revert("ERC721A: unable to determine the owner of token");
1169   }
1170 
1171   /**
1172    * @dev See {IERC721-ownerOf}.
1173    */
1174   function ownerOf(uint256 tokenId) public view override returns (address) {
1175     return ownershipOf(tokenId).addr;
1176   }
1177 
1178   /**
1179    * @dev See {IERC721Metadata-name}.
1180    */
1181   function name() public view virtual override returns (string memory) {
1182     return _name;
1183   }
1184 
1185   /**
1186    * @dev See {IERC721Metadata-symbol}.
1187    */
1188   function symbol() public view virtual override returns (string memory) {
1189     return _symbol;
1190   }
1191 
1192   /**
1193    * @dev See {IERC721Metadata-tokenURI}.
1194    */
1195   function tokenURI(uint256 tokenId)
1196     public
1197     view
1198     virtual
1199     override
1200     returns (string memory)
1201   {
1202     require(
1203       _exists(tokenId),
1204       "ERC721Metadata: URI query for nonexistent token"
1205     );
1206 
1207     string memory baseURI = _baseURI();
1208     return
1209       bytes(baseURI).length > 0
1210         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1211         : "";
1212   }
1213 
1214   /**
1215    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1216    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1217    * by default, can be overriden in child contracts.
1218    */
1219   function _baseURI() internal view virtual returns (string memory) {
1220     return "";
1221   }
1222 
1223   /**
1224    * @dev See {IERC721-approve}.
1225    */
1226   function approve(address to, uint256 tokenId) public override {
1227     address owner = ERC721A.ownerOf(tokenId);
1228     require(to != owner, "ERC721A: approval to current owner");
1229 
1230     require(
1231       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1232       "ERC721A: approve caller is not owner nor approved for all"
1233     );
1234 
1235     _approve(to, tokenId, owner);
1236   }
1237 
1238   /**
1239    * @dev See {IERC721-getApproved}.
1240    */
1241   function getApproved(uint256 tokenId) public view override returns (address) {
1242     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1243 
1244     return _tokenApprovals[tokenId];
1245   }
1246 
1247   /**
1248    * @dev See {IERC721-setApprovalForAll}.
1249    */
1250   function setApprovalForAll(address operator, bool approved) public override {
1251     require(operator != _msgSender(), "ERC721A: approve to caller");
1252 
1253     _operatorApprovals[_msgSender()][operator] = approved;
1254     emit ApprovalForAll(_msgSender(), operator, approved);
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-isApprovedForAll}.
1259    */
1260   function isApprovedForAll(address owner, address operator)
1261     public
1262     view
1263     virtual
1264     override
1265     returns (bool)
1266   {
1267     return _operatorApprovals[owner][operator];
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-transferFrom}.
1272    */
1273   function transferFrom(
1274     address from,
1275     address to,
1276     uint256 tokenId
1277   ) public override {
1278     _transfer(from, to, tokenId);
1279   }
1280 
1281   /**
1282    * @dev See {IERC721-safeTransferFrom}.
1283    */
1284   function safeTransferFrom(
1285     address from,
1286     address to,
1287     uint256 tokenId
1288   ) public override {
1289     safeTransferFrom(from, to, tokenId, "");
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-safeTransferFrom}.
1294    */
1295   function safeTransferFrom(
1296     address from,
1297     address to,
1298     uint256 tokenId,
1299     bytes memory _data
1300   ) public override {
1301     _transfer(from, to, tokenId);
1302     require(
1303       _checkOnERC721Received(from, to, tokenId, _data),
1304       "ERC721A: transfer to non ERC721Receiver implementer"
1305     );
1306   }
1307 
1308   /**
1309    * @dev Returns whether `tokenId` exists.
1310    *
1311    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1312    *
1313    * Tokens start existing when they are minted (`_mint`),
1314    */
1315   function _exists(uint256 tokenId) internal view returns (bool) {
1316     return tokenId < currentIndex;
1317   }
1318 
1319   function _safeMint(address to, uint256 quantity) internal {
1320     _safeMint(to, quantity, "");
1321   }
1322 
1323   /**
1324    * @dev Mints `quantity` tokens and transfers them to `to`.
1325    *
1326    * Requirements:
1327    *
1328    * - `to` cannot be the zero address.
1329    * - `quantity` cannot be larger than the max batch size.
1330    *
1331    * Emits a {Transfer} event.
1332    */
1333   function _safeMint(
1334     address to,
1335     uint256 quantity,
1336     bytes memory _data
1337   ) internal {
1338     uint256 startTokenId = currentIndex;
1339     require(to != address(0), "ERC721A: mint to the zero address");
1340     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1341     require(!_exists(startTokenId), "ERC721A: token already minted");
1342     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1343 
1344     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1345 
1346     AddressData memory addressData = _addressData[to];
1347     _addressData[to] = AddressData(
1348       addressData.balance + uint128(quantity),
1349       addressData.numberMinted + uint128(quantity)
1350     );
1351     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1352 
1353     uint256 updatedIndex = startTokenId;
1354 
1355     for (uint256 i = 0; i < quantity; i++) {
1356       emit Transfer(address(0), to, updatedIndex);
1357       require(
1358         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1359         "ERC721A: transfer to non ERC721Receiver implementer"
1360       );
1361       updatedIndex++;
1362     }
1363 
1364     currentIndex = updatedIndex;
1365     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1366   }
1367 
1368   /**
1369    * @dev Transfers `tokenId` from `from` to `to`.
1370    *
1371    * Requirements:
1372    *
1373    * - `to` cannot be the zero address.
1374    * - `tokenId` token must be owned by `from`.
1375    *
1376    * Emits a {Transfer} event.
1377    */
1378   function _transfer(
1379     address from,
1380     address to,
1381     uint256 tokenId
1382   ) private {
1383     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1384 
1385     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1386       getApproved(tokenId) == _msgSender() ||
1387       isApprovedForAll(prevOwnership.addr, _msgSender()));
1388 
1389     require(
1390       isApprovedOrOwner,
1391       "ERC721A: transfer caller is not owner nor approved"
1392     );
1393 
1394     require(
1395       prevOwnership.addr == from,
1396       "ERC721A: transfer from incorrect owner"
1397     );
1398     require(to != address(0), "ERC721A: transfer to the zero address");
1399 
1400     _beforeTokenTransfers(from, to, tokenId, 1);
1401 
1402     // Clear approvals from the previous owner
1403     _approve(address(0), tokenId, prevOwnership.addr);
1404 
1405     _addressData[from].balance -= 1;
1406     _addressData[to].balance += 1;
1407     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1408 
1409     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1410     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1411     uint256 nextTokenId = tokenId + 1;
1412     if (_ownerships[nextTokenId].addr == address(0)) {
1413       if (_exists(nextTokenId)) {
1414         _ownerships[nextTokenId] = TokenOwnership(
1415           prevOwnership.addr,
1416           prevOwnership.startTimestamp
1417         );
1418       }
1419     }
1420 
1421     emit Transfer(from, to, tokenId);
1422     _afterTokenTransfers(from, to, tokenId, 1);
1423   }
1424 
1425   /**
1426    * @dev Approve `to` to operate on `tokenId`
1427    *
1428    * Emits a {Approval} event.
1429    */
1430   function _approve(
1431     address to,
1432     uint256 tokenId,
1433     address owner
1434   ) private {
1435     _tokenApprovals[tokenId] = to;
1436     emit Approval(owner, to, tokenId);
1437   }
1438 
1439   uint256 public nextOwnerToExplicitlySet = 0;
1440 
1441   /**
1442    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1443    */
1444   function _setOwnersExplicit(uint256 quantity) internal {
1445     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1446     require(quantity > 0, "quantity must be nonzero");
1447     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1448     if (endIndex > currentIndex - 1) {
1449       endIndex = currentIndex - 1;
1450     }
1451     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1452     require(_exists(endIndex), "not enough minted yet for this cleanup");
1453     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1454       if (_ownerships[i].addr == address(0)) {
1455         TokenOwnership memory ownership = ownershipOf(i);
1456         _ownerships[i] = TokenOwnership(
1457           ownership.addr,
1458           ownership.startTimestamp
1459         );
1460       }
1461     }
1462     nextOwnerToExplicitlySet = endIndex + 1;
1463   }
1464 
1465   /**
1466    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1467    * The call is not executed if the target address is not a contract.
1468    *
1469    * @param from address representing the previous owner of the given token ID
1470    * @param to target address that will receive the tokens
1471    * @param tokenId uint256 ID of the token to be transferred
1472    * @param _data bytes optional data to send along with the call
1473    * @return bool whether the call correctly returned the expected magic value
1474    */
1475   function _checkOnERC721Received(
1476     address from,
1477     address to,
1478     uint256 tokenId,
1479     bytes memory _data
1480   ) private returns (bool) {
1481     if (to.isContract()) {
1482       try
1483         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1484       returns (bytes4 retval) {
1485         return retval == IERC721Receiver(to).onERC721Received.selector;
1486       } catch (bytes memory reason) {
1487         if (reason.length == 0) {
1488           revert("ERC721A: transfer to non ERC721Receiver implementer");
1489         } else {
1490           assembly {
1491             revert(add(32, reason), mload(reason))
1492           }
1493         }
1494       }
1495     } else {
1496       return true;
1497     }
1498   }
1499 
1500   /**
1501    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1502    *
1503    * startTokenId - the first token id to be transferred
1504    * quantity - the amount to be transferred
1505    *
1506    * Calling conditions:
1507    *
1508    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1509    * transferred to `to`.
1510    * - When `from` is zero, `tokenId` will be minted for `to`.
1511    */
1512   function _beforeTokenTransfers(
1513     address from,
1514     address to,
1515     uint256 startTokenId,
1516     uint256 quantity
1517   ) internal virtual {}
1518 
1519   /**
1520    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1521    * minting.
1522    *
1523    * startTokenId - the first token id to be transferred
1524    * quantity - the amount to be transferred
1525    *
1526    * Calling conditions:
1527    *
1528    * - when `from` and `to` are both non-zero.
1529    * - `from` and `to` are never both zero.
1530    */
1531   function _afterTokenTransfers(
1532     address from,
1533     address to,
1534     uint256 startTokenId,
1535     uint256 quantity
1536   ) internal virtual {}
1537 }
1538 // File: contracts/merk.sol
1539 
1540 
1541 
1542 pragma solidity ^0.8.10;
1543 
1544 
1545 
1546 contract CloodleZ is ERC721A, Ownable {
1547     using SafeMath for uint256;
1548     using Strings for uint256;
1549 
1550     uint256 public constant MAX_TOKENS = 8888;
1551     uint256 public constant MAX_PER_MINT = 20;
1552     address public constant w1 = 0x94a1801b341Df84DE851c3383f2103d182864b65;
1553     address public constant w2 = 0xe640A158aA4D8681b5BC3bd41113173DA47b1593;
1554     address public constant w3 = 0x49B3Cb75b94E06b246d928f691709A7C81633282;
1555 
1556     uint256 public price = 0.079 ether;
1557     uint256 public pricePresale = 0.069 ether;
1558   
1559     
1560 
1561     bool public isRevealed = false;
1562     bool public publicSaleStarted = false;
1563     bool public presaleStarted = false;
1564     mapping(address => uint256) private _presaleMints;
1565     uint256 public presaleMaxPerWallet = 7;
1566 
1567     string public baseURI = "";
1568     bytes32 public merkleRoot = 0x7e54fbd956181ad3b1bf2e50e51823fb9f3648bfcb72660826f905dfc2250bae;
1569 
1570     constructor() ERC721A("CloodleZ", "CZ", 20) {
1571     }
1572 
1573     function togglePresaleStarted() external onlyOwner {
1574         presaleStarted = !presaleStarted;
1575     }
1576 
1577     function togglePublicSaleStarted() external onlyOwner {
1578         publicSaleStarted = !publicSaleStarted;
1579     }
1580 
1581     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1582         baseURI = _newBaseURI;
1583     }
1584     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1585         merkleRoot = _merkleRoot;
1586     }
1587 
1588     function setPrice(uint256 _newPrice) external onlyOwner {
1589         price = _newPrice * (1 ether);
1590     }
1591 
1592     function setPricePresale(uint256 _newPrice) external onlyOwner {
1593         pricePresale = _newPrice * (1 ether);
1594     }
1595 
1596     function toggleReveal() external onlyOwner {
1597         isRevealed = !isRevealed;
1598     }
1599 
1600     function _baseURI() internal view override returns (string memory) {
1601         return baseURI;
1602     }
1603 
1604     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1605         if (isRevealed) {
1606             return super.tokenURI(tokenId);
1607         } else {
1608             return
1609                 string(abi.encodePacked("https://gateway.pinata.cloud/ipfs/QmVcjnU8QiGyL6hm5Yb5uwXAmhcizLao3GnmbAqsPD5iqt/", tokenId.toString()));
1610         }
1611     }
1612 
1613     /// Set number of maximum presale mints a wallet can have
1614     /// @param _newPresaleMaxPerWallet value to set
1615     function setPresaleMaxPerWallet(uint256 _newPresaleMaxPerWallet) external onlyOwner {
1616         presaleMaxPerWallet = _newPresaleMaxPerWallet;
1617     }
1618 
1619     /// Presale mint function
1620     /// @param tokens number of tokens to mint
1621     /// @param merkleProof Merkle Tree proof
1622     /// @dev reverts if any of the presale preconditions aren't satisfied
1623     function mintPresale(uint256 tokens, bytes32[] calldata merkleProof) external payable {
1624         require(presaleStarted, "X: Presale has not started");
1625         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "X: You are not eligible for the presale");
1626         require(_presaleMints[_msgSender()] + tokens <= presaleMaxPerWallet, "X: Presale limit for this wallet reached");
1627         require(tokens <= MAX_PER_MINT, "X: Cannot purchase this many tokens in a transaction");
1628         require(totalSupply() + tokens <= MAX_TOKENS, "X: Minting would exceed max supply");
1629         require(tokens > 0, "X: Must mint at least one token");
1630         require(pricePresale * tokens == msg.value, "X: ETH amount is incorrect");
1631 
1632         _safeMint(_msgSender(), tokens);
1633         _presaleMints[_msgSender()] += tokens;
1634     }
1635 
1636     /// Public Sale mint function
1637     /// @param tokens number of tokens to mint
1638     /// @dev reverts if any of the public sale preconditions aren't satisfied
1639     function mint(uint256 tokens) external payable {
1640         require(publicSaleStarted, "X: Public sale has not started");
1641         require(tokens <= MAX_PER_MINT, "X: Cannot purchase this many tokens in a transaction");
1642         require(totalSupply() + tokens <= MAX_TOKENS, "X: Minting would exceed max supply");
1643         require(tokens > 0, "X: Must mint at least one token");
1644         require(price * tokens == msg.value, "X: ETH amount is incorrect");
1645 
1646         _safeMint(_msgSender(), tokens);
1647     }
1648 
1649     /// Owner only mint function
1650     /// Does not require eth
1651     /// @param to address of the recepient
1652     /// @param tokens number of tokens to mint
1653     /// @dev reverts if any of the preconditions aren't satisfied
1654     function ownerMint(address to, uint256 tokens) external onlyOwner {
1655         require(totalSupply() + tokens <= MAX_TOKENS, "X: Minting would exceed max supply");
1656         require(tokens > 0, "X: Must mint at least one token");
1657 
1658         _safeMint(to, tokens);
1659     }
1660 
1661     /// Distribute funds to wallets
1662     function withdrawAll() public onlyOwner {
1663         uint256 balance = address(this).balance;
1664         require(balance > 0, "X: Insufficent balance");
1665         _widthdraw(w3, ((balance * 1) / 3));
1666         _widthdraw(w2, ((balance * 1) / 3));
1667         _widthdraw(w1, ((balance * 1) / 3));
1668     }
1669 
1670     function _widthdraw(address _address, uint256 _amount) private {
1671         (bool success, ) = _address.call{value: _amount}("");
1672         require(success, "X: Failed to widthdraw Ether");
1673     }
1674 
1675 }