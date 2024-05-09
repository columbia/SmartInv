1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/Counters.sol
231 
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title Counters
238  * @author Matt Condon (@shrugs)
239  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
240  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
241  *
242  * Include with `using Counters for Counters.Counter;`
243  */
244 library Counters {
245     struct Counter {
246         // This variable should never be directly accessed by users of the library: interactions must be restricted to
247         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
248         // this feature: see https://github.com/ethereum/solidity/issues/4637
249         uint256 _value; // default: 0
250     }
251 
252     function current(Counter storage counter) internal view returns (uint256) {
253         return counter._value;
254     }
255 
256     function increment(Counter storage counter) internal {
257         unchecked {
258             counter._value += 1;
259         }
260     }
261 
262     function decrement(Counter storage counter) internal {
263         uint256 value = counter._value;
264         require(value > 0, "Counter: decrement overflow");
265         unchecked {
266             counter._value = value - 1;
267         }
268     }
269 
270     function reset(Counter storage counter) internal {
271         counter._value = 0;
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Strings.sol
276 
277 
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev String operations.
283  */
284 library Strings {
285     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
289      */
290     function toString(uint256 value) internal pure returns (string memory) {
291         // Inspired by OraclizeAPI's implementation - MIT licence
292         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
293 
294         if (value == 0) {
295             return "0";
296         }
297         uint256 temp = value;
298         uint256 digits;
299         while (temp != 0) {
300             digits++;
301             temp /= 10;
302         }
303         bytes memory buffer = new bytes(digits);
304         while (value != 0) {
305             digits -= 1;
306             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
307             value /= 10;
308         }
309         return string(buffer);
310     }
311 
312     /**
313      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
314      */
315     function toHexString(uint256 value) internal pure returns (string memory) {
316         if (value == 0) {
317             return "0x00";
318         }
319         uint256 temp = value;
320         uint256 length = 0;
321         while (temp != 0) {
322             length++;
323             temp >>= 8;
324         }
325         return toHexString(value, length);
326     }
327 
328     /**
329      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
330      */
331     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
332         bytes memory buffer = new bytes(2 * length + 2);
333         buffer[0] = "0";
334         buffer[1] = "x";
335         for (uint256 i = 2 * length + 1; i > 1; --i) {
336             buffer[i] = _HEX_SYMBOLS[value & 0xf];
337             value >>= 4;
338         }
339         require(value == 0, "Strings: hex length insufficient");
340         return string(buffer);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Context.sol
345 
346 
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Provides information about the current execution context, including the
352  * sender of the transaction and its data. While these are generally available
353  * via msg.sender and msg.data, they should not be accessed in such a direct
354  * manner, since when dealing with meta-transactions the account sending and
355  * paying for execution may not be the actual sender (as far as an application
356  * is concerned).
357  *
358  * This contract is only required for intermediate, library-like contracts.
359  */
360 abstract contract Context {
361     function _msgSender() internal view virtual returns (address) {
362         return msg.sender;
363     }
364 
365     function _msgData() internal view virtual returns (bytes calldata) {
366         return msg.data;
367     }
368 }
369 
370 // File: @openzeppelin/contracts/access/Ownable.sol
371 
372 
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev Contract module which provides a basic access control mechanism, where
379  * there is an account (an owner) that can be granted exclusive access to
380  * specific functions.
381  *
382  * By default, the owner account will be the one that deploys the contract. This
383  * can later be changed with {transferOwnership}.
384  *
385  * This module is used through inheritance. It will make available the modifier
386  * `onlyOwner`, which can be applied to your functions to restrict their use to
387  * the owner.
388  */
389 abstract contract Ownable is Context {
390     address private _owner;
391 
392     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
393 
394     /**
395      * @dev Initializes the contract setting the deployer as the initial owner.
396      */
397     constructor() {
398         _setOwner(_msgSender());
399     }
400 
401     /**
402      * @dev Returns the address of the current owner.
403      */
404     function owner() public view virtual returns (address) {
405         return _owner;
406     }
407 
408     /**
409      * @dev Throws if called by any account other than the owner.
410      */
411     modifier onlyOwner() {
412         require(owner() == _msgSender(), "Ownable: caller is not the owner");
413         _;
414     }
415 
416     /**
417      * @dev Leaves the contract without owner. It will not be possible to call
418      * `onlyOwner` functions anymore. Can only be called by the current owner.
419      *
420      * NOTE: Renouncing ownership will leave the contract without an owner,
421      * thereby removing any functionality that is only available to the owner.
422      */
423     function renounceOwnership() public virtual onlyOwner {
424         _setOwner(address(0));
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Can only be called by the current owner.
430      */
431     function transferOwnership(address newOwner) public virtual onlyOwner {
432         require(newOwner != address(0), "Ownable: new owner is the zero address");
433         _setOwner(newOwner);
434     }
435 
436     function _setOwner(address newOwner) private {
437         address oldOwner = _owner;
438         _owner = newOwner;
439         emit OwnershipTransferred(oldOwner, newOwner);
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/Address.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Collection of functions related to the address type
451  */
452 library Address {
453     /**
454      * @dev Returns true if `account` is a contract.
455      *
456      * [IMPORTANT]
457      * ====
458      * It is unsafe to assume that an address for which this function returns
459      * false is an externally-owned account (EOA) and not a contract.
460      *
461      * Among others, `isContract` will return false for the following
462      * types of addresses:
463      *
464      *  - an externally-owned account
465      *  - a contract in construction
466      *  - an address where a contract will be created
467      *  - an address where a contract lived, but was destroyed
468      * ====
469      */
470     function isContract(address account) internal view returns (bool) {
471         // This method relies on extcodesize, which returns 0 for contracts in
472         // construction, since the code is only stored at the end of the
473         // constructor execution.
474 
475         uint256 size;
476         assembly {
477             size := extcodesize(account)
478         }
479         return size > 0;
480     }
481 
482     /**
483      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
484      * `recipient`, forwarding all available gas and reverting on errors.
485      *
486      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
487      * of certain opcodes, possibly making contracts go over the 2300 gas limit
488      * imposed by `transfer`, making them unable to receive funds via
489      * `transfer`. {sendValue} removes this limitation.
490      *
491      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
492      *
493      * IMPORTANT: because control is transferred to `recipient`, care must be
494      * taken to not create reentrancy vulnerabilities. Consider using
495      * {ReentrancyGuard} or the
496      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
497      */
498     function sendValue(address payable recipient, uint256 amount) internal {
499         require(address(this).balance >= amount, "Address: insufficient balance");
500 
501         (bool success, ) = recipient.call{value: amount}("");
502         require(success, "Address: unable to send value, recipient may have reverted");
503     }
504 
505     /**
506      * @dev Performs a Solidity function call using a low level `call`. A
507      * plain `call` is an unsafe replacement for a function call: use this
508      * function instead.
509      *
510      * If `target` reverts with a revert reason, it is bubbled up by this
511      * function (like regular Solidity function calls).
512      *
513      * Returns the raw returned data. To convert to the expected return value,
514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
515      *
516      * Requirements:
517      *
518      * - `target` must be a contract.
519      * - calling `target` with `data` must not revert.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionCall(target, data, "Address: low-level call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
529      * `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, 0, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but also transferring `value` wei to `target`.
544      *
545      * Requirements:
546      *
547      * - the calling contract must have an ETH balance of at least `value`.
548      * - the called Solidity function must be `payable`.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value
556     ) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
562      * with `errorMessage` as a fallback revert reason when `target` reverts.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(
567         address target,
568         bytes memory data,
569         uint256 value,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         require(isContract(target), "Address: call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.call{value: value}(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
586         return functionStaticCall(target, data, "Address: low-level static call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a static call.
592      *
593      * _Available since v3.3._
594      */
595     function functionStaticCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal view returns (bytes memory) {
600         require(isContract(target), "Address: static call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.staticcall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but performing a delegate call.
609      *
610      * _Available since v3.4._
611      */
612     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
618      * but performing a delegate call.
619      *
620      * _Available since v3.4._
621      */
622     function functionDelegateCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628 
629         (bool success, bytes memory returndata) = target.delegatecall(data);
630         return verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     /**
634      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
635      * revert reason using the provided one.
636      *
637      * _Available since v4.3._
638      */
639     function verifyCallResult(
640         bool success,
641         bytes memory returndata,
642         string memory errorMessage
643     ) internal pure returns (bytes memory) {
644         if (success) {
645             return returndata;
646         } else {
647             // Look for revert reason and bubble it up if present
648             if (returndata.length > 0) {
649                 // The easiest way to bubble the revert reason is using memory via assembly
650 
651                 assembly {
652                     let returndata_size := mload(returndata)
653                     revert(add(32, returndata), returndata_size)
654                 }
655             } else {
656                 revert(errorMessage);
657             }
658         }
659     }
660 }
661 
662 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
663 
664 
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @title ERC721 token receiver interface
670  * @dev Interface for any contract that wants to support safeTransfers
671  * from ERC721 asset contracts.
672  */
673 interface IERC721Receiver {
674     /**
675      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
676      * by `operator` from `from`, this function is called.
677      *
678      * It must return its Solidity selector to confirm the token transfer.
679      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
680      *
681      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
682      */
683     function onERC721Received(
684         address operator,
685         address from,
686         uint256 tokenId,
687         bytes calldata data
688     ) external returns (bytes4);
689 }
690 
691 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
692 
693 
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @dev Interface of the ERC165 standard, as defined in the
699  * https://eips.ethereum.org/EIPS/eip-165[EIP].
700  *
701  * Implementers can declare support of contract interfaces, which can then be
702  * queried by others ({ERC165Checker}).
703  *
704  * For an implementation, see {ERC165}.
705  */
706 interface IERC165 {
707     /**
708      * @dev Returns true if this contract implements the interface defined by
709      * `interfaceId`. See the corresponding
710      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
711      * to learn more about how these ids are created.
712      *
713      * This function call must use less than 30 000 gas.
714      */
715     function supportsInterface(bytes4 interfaceId) external view returns (bool);
716 }
717 
718 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
719 
720 
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @dev Implementation of the {IERC165} interface.
727  *
728  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
729  * for the additional interface id that will be supported. For example:
730  *
731  * ```solidity
732  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
733  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
734  * }
735  * ```
736  *
737  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
738  */
739 abstract contract ERC165 is IERC165 {
740     /**
741      * @dev See {IERC165-supportsInterface}.
742      */
743     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
744         return interfaceId == type(IERC165).interfaceId;
745     }
746 }
747 
748 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
749 
750 
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @dev Required interface of an ERC721 compliant contract.
757  */
758 interface IERC721 is IERC165 {
759     /**
760      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
761      */
762     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
763 
764     /**
765      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
766      */
767     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
768 
769     /**
770      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
771      */
772     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
773 
774     /**
775      * @dev Returns the number of tokens in ``owner``'s account.
776      */
777     function balanceOf(address owner) external view returns (uint256 balance);
778 
779     /**
780      * @dev Returns the owner of the `tokenId` token.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function ownerOf(uint256 tokenId) external view returns (address owner);
787 
788     /**
789      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
790      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
791      *
792      * Requirements:
793      *
794      * - `from` cannot be the zero address.
795      * - `to` cannot be the zero address.
796      * - `tokenId` token must exist and be owned by `from`.
797      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) external;
807 
808     /**
809      * @dev Transfers `tokenId` token from `from` to `to`.
810      *
811      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must be owned by `from`.
818      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external;
827 
828     /**
829      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
830      * The approval is cleared when the token is transferred.
831      *
832      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
833      *
834      * Requirements:
835      *
836      * - The caller must own the token or be an approved operator.
837      * - `tokenId` must exist.
838      *
839      * Emits an {Approval} event.
840      */
841     function approve(address to, uint256 tokenId) external;
842 
843     /**
844      * @dev Returns the account approved for `tokenId` token.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function getApproved(uint256 tokenId) external view returns (address operator);
851 
852     /**
853      * @dev Approve or remove `operator` as an operator for the caller.
854      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
855      *
856      * Requirements:
857      *
858      * - The `operator` cannot be the caller.
859      *
860      * Emits an {ApprovalForAll} event.
861      */
862     function setApprovalForAll(address operator, bool _approved) external;
863 
864     /**
865      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
866      *
867      * See {setApprovalForAll}
868      */
869     function isApprovedForAll(address owner, address operator) external view returns (bool);
870 
871     /**
872      * @dev Safely transfers `tokenId` token from `from` to `to`.
873      *
874      * Requirements:
875      *
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must exist and be owned by `from`.
879      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes calldata data
889     ) external;
890 }
891 
892 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
893 
894 
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
901  * @dev See https://eips.ethereum.org/EIPS/eip-721
902  */
903 interface IERC721Enumerable is IERC721 {
904     /**
905      * @dev Returns the total amount of tokens stored by the contract.
906      */
907     function totalSupply() external view returns (uint256);
908 
909     /**
910      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
911      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
914 
915     /**
916      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
917      * Use along with {totalSupply} to enumerate all tokens.
918      */
919     function tokenByIndex(uint256 index) external view returns (uint256);
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
923 
924 
925 
926 pragma solidity ^0.8.0;
927 
928 
929 /**
930  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
931  * @dev See https://eips.ethereum.org/EIPS/eip-721
932  */
933 interface IERC721Metadata is IERC721 {
934     /**
935      * @dev Returns the token collection name.
936      */
937     function name() external view returns (string memory);
938 
939     /**
940      * @dev Returns the token collection symbol.
941      */
942     function symbol() external view returns (string memory);
943 
944     /**
945      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
946      */
947     function tokenURI(uint256 tokenId) external view returns (string memory);
948 }
949 
950 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
951 
952 
953 
954 pragma solidity ^0.8.0;
955 
956 
957 
958 
959 
960 
961 
962 
963 /**
964  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
965  * the Metadata extension, but not including the Enumerable extension, which is available separately as
966  * {ERC721Enumerable}.
967  */
968 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
969     using Address for address;
970     using Strings for uint256;
971 
972     // Token name
973     string private _name;
974 
975     // Token symbol
976     string private _symbol;
977 
978     // Mapping from token ID to owner address
979     mapping(uint256 => address) private _owners;
980 
981     // Mapping owner address to token count
982     mapping(address => uint256) private _balances;
983 
984     // Mapping from token ID to approved address
985     mapping(uint256 => address) private _tokenApprovals;
986 
987     // Mapping from owner to operator approvals
988     mapping(address => mapping(address => bool)) private _operatorApprovals;
989 
990     /**
991      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
992      */
993     constructor(string memory name_, string memory symbol_) {
994         _name = name_;
995         _symbol = symbol_;
996     }
997 
998     /**
999      * @dev See {IERC165-supportsInterface}.
1000      */
1001     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1002         return
1003             interfaceId == type(IERC721).interfaceId ||
1004             interfaceId == type(IERC721Metadata).interfaceId ||
1005             super.supportsInterface(interfaceId);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-balanceOf}.
1010      */
1011     function balanceOf(address owner) public view virtual override returns (uint256) {
1012         require(owner != address(0), "ERC721: balance query for the zero address");
1013         return _balances[owner];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-ownerOf}.
1018      */
1019     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1020         address owner = _owners[tokenId];
1021         require(owner != address(0), "ERC721: owner query for nonexistent token");
1022         return owner;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-name}.
1027      */
1028     function name() public view virtual override returns (string memory) {
1029         return _name;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Metadata-symbol}.
1034      */
1035     function symbol() public view virtual override returns (string memory) {
1036         return _symbol;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Metadata-tokenURI}.
1041      */
1042     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1043         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1044 
1045         string memory baseURI = _baseURI();
1046         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1047     }
1048 
1049     /**
1050      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1051      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1052      * by default, can be overriden in child contracts.
1053      */
1054     function _baseURI() internal view virtual returns (string memory) {
1055         return "";
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-approve}.
1060      */
1061     function approve(address to, uint256 tokenId) public virtual override {
1062         address owner = ERC721.ownerOf(tokenId);
1063         require(to != owner, "ERC721: approval to current owner");
1064 
1065         require(
1066             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1067             "ERC721: approve caller is not owner nor approved for all"
1068         );
1069 
1070         _approve(to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-getApproved}.
1075      */
1076     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1077         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1078 
1079         return _tokenApprovals[tokenId];
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-setApprovalForAll}.
1084      */
1085     function setApprovalForAll(address operator, bool approved) public virtual override {
1086         require(operator != _msgSender(), "ERC721: approve to caller");
1087 
1088         _operatorApprovals[_msgSender()][operator] = approved;
1089         emit ApprovalForAll(_msgSender(), operator, approved);
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-isApprovedForAll}.
1094      */
1095     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-transferFrom}.
1101      */
1102     function transferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         //solhint-disable-next-line max-line-length
1108         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1109 
1110         _transfer(from, to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-safeTransferFrom}.
1115      */
1116     function safeTransferFrom(
1117         address from,
1118         address to,
1119         uint256 tokenId
1120     ) public virtual override {
1121         safeTransferFrom(from, to, tokenId, "");
1122     }
1123 
1124     /**
1125      * @dev See {IERC721-safeTransferFrom}.
1126      */
1127     function safeTransferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) public virtual override {
1133         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1134         _safeTransfer(from, to, tokenId, _data);
1135     }
1136 
1137     /**
1138      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1139      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1140      *
1141      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1142      *
1143      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1144      * implement alternative mechanisms to perform token transfer, such as signature-based.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must exist and be owned by `from`.
1151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeTransfer(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) internal virtual {
1161         _transfer(from, to, tokenId);
1162         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1163     }
1164 
1165     /**
1166      * @dev Returns whether `tokenId` exists.
1167      *
1168      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1169      *
1170      * Tokens start existing when they are minted (`_mint`),
1171      * and stop existing when they are burned (`_burn`).
1172      */
1173     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1174         return _owners[tokenId] != address(0);
1175     }
1176 
1177     /**
1178      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must exist.
1183      */
1184     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1185         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1186         address owner = ERC721.ownerOf(tokenId);
1187         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1188     }
1189 
1190     /**
1191      * @dev Safely mints `tokenId` and transfers it to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - `tokenId` must not exist.
1196      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _safeMint(address to, uint256 tokenId) internal virtual {
1201         _safeMint(to, tokenId, "");
1202     }
1203 
1204     /**
1205      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1206      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1207      */
1208     function _safeMint(
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) internal virtual {
1213         _mint(to, tokenId);
1214         require(
1215             _checkOnERC721Received(address(0), to, tokenId, _data),
1216             "ERC721: transfer to non ERC721Receiver implementer"
1217         );
1218     }
1219 
1220     /**
1221      * @dev Mints `tokenId` and transfers it to `to`.
1222      *
1223      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must not exist.
1228      * - `to` cannot be the zero address.
1229      *
1230      * Emits a {Transfer} event.
1231      */
1232     function _mint(address to, uint256 tokenId) internal virtual {
1233         require(to != address(0), "ERC721: mint to the zero address");
1234         require(!_exists(tokenId), "ERC721: token already minted");
1235 
1236         _beforeTokenTransfer(address(0), to, tokenId);
1237 
1238         _balances[to] += 1;
1239         _owners[tokenId] = to;
1240 
1241         emit Transfer(address(0), to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId) internal virtual {
1255         address owner = ERC721.ownerOf(tokenId);
1256 
1257         _beforeTokenTransfer(owner, address(0), tokenId);
1258 
1259         // Clear approvals
1260         _approve(address(0), tokenId);
1261 
1262         _balances[owner] -= 1;
1263         delete _owners[tokenId];
1264 
1265         emit Transfer(owner, address(0), tokenId);
1266     }
1267 
1268     /**
1269      * @dev Transfers `tokenId` from `from` to `to`.
1270      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1271      *
1272      * Requirements:
1273      *
1274      * - `to` cannot be the zero address.
1275      * - `tokenId` token must be owned by `from`.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _transfer(
1280         address from,
1281         address to,
1282         uint256 tokenId
1283     ) internal virtual {
1284         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1285         require(to != address(0), "ERC721: transfer to the zero address");
1286 
1287         _beforeTokenTransfer(from, to, tokenId);
1288 
1289         // Clear approvals from the previous owner
1290         _approve(address(0), tokenId);
1291 
1292         _balances[from] -= 1;
1293         _balances[to] += 1;
1294         _owners[tokenId] = to;
1295 
1296         emit Transfer(from, to, tokenId);
1297     }
1298 
1299     /**
1300      * @dev Approve `to` to operate on `tokenId`
1301      *
1302      * Emits a {Approval} event.
1303      */
1304     function _approve(address to, uint256 tokenId) internal virtual {
1305         _tokenApprovals[tokenId] = to;
1306         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1311      * The call is not executed if the target address is not a contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         if (to.isContract()) {
1326             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1327                 return retval == IERC721Receiver.onERC721Received.selector;
1328             } catch (bytes memory reason) {
1329                 if (reason.length == 0) {
1330                     revert("ERC721: transfer to non ERC721Receiver implementer");
1331                 } else {
1332                     assembly {
1333                         revert(add(32, reason), mload(reason))
1334                     }
1335                 }
1336             }
1337         } else {
1338             return true;
1339         }
1340     }
1341 
1342     /**
1343      * @dev Hook that is called before any token transfer. This includes minting
1344      * and burning.
1345      *
1346      * Calling conditions:
1347      *
1348      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1349      * transferred to `to`.
1350      * - When `from` is zero, `tokenId` will be minted for `to`.
1351      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1352      * - `from` and `to` are never both zero.
1353      *
1354      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1355      */
1356     function _beforeTokenTransfer(
1357         address from,
1358         address to,
1359         uint256 tokenId
1360     ) internal virtual {}
1361 }
1362 
1363 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1364 
1365 
1366 
1367 pragma solidity ^0.8.0;
1368 
1369 
1370 
1371 /**
1372  * @title ERC721 Burnable Token
1373  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1374  */
1375 abstract contract ERC721Burnable is Context, ERC721 {
1376     /**
1377      * @dev Burns `tokenId`. See {ERC721-_burn}.
1378      *
1379      * Requirements:
1380      *
1381      * - The caller must own `tokenId` or be an approved operator.
1382      */
1383     function burn(uint256 tokenId) public virtual {
1384         //solhint-disable-next-line max-line-length
1385         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1386         _burn(tokenId);
1387     }
1388 }
1389 
1390 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1391 
1392 
1393 
1394 pragma solidity ^0.8.0;
1395 
1396 
1397 /**
1398  * @dev ERC721 token with storage based token URI management.
1399  */
1400 abstract contract ERC721URIStorage is ERC721 {
1401     using Strings for uint256;
1402 
1403     // Optional mapping for token URIs
1404     mapping(uint256 => string) private _tokenURIs;
1405 
1406     /**
1407      * @dev See {IERC721Metadata-tokenURI}.
1408      */
1409     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1410         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1411 
1412         string memory _tokenURI = _tokenURIs[tokenId];
1413         string memory base = _baseURI();
1414 
1415         // If there is no base URI, return the token URI.
1416         if (bytes(base).length == 0) {
1417             return _tokenURI;
1418         }
1419         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1420         if (bytes(_tokenURI).length > 0) {
1421             return string(abi.encodePacked(base, _tokenURI));
1422         }
1423 
1424         return super.tokenURI(tokenId);
1425     }
1426 
1427     /**
1428      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must exist.
1433      */
1434     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1435         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1436         _tokenURIs[tokenId] = _tokenURI;
1437     }
1438 
1439     /**
1440      * @dev Destroys `tokenId`.
1441      * The approval is cleared when the token is burned.
1442      *
1443      * Requirements:
1444      *
1445      * - `tokenId` must exist.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function _burn(uint256 tokenId) internal virtual override {
1450         super._burn(tokenId);
1451 
1452         if (bytes(_tokenURIs[tokenId]).length != 0) {
1453             delete _tokenURIs[tokenId];
1454         }
1455     }
1456 }
1457 
1458 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1459 
1460 
1461 
1462 pragma solidity ^0.8.0;
1463 
1464 
1465 
1466 /**
1467  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1468  * enumerability of all the token ids in the contract as well as all token ids owned by each
1469  * account.
1470  */
1471 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1472     // Mapping from owner to list of owned token IDs
1473     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1474 
1475     // Mapping from token ID to index of the owner tokens list
1476     mapping(uint256 => uint256) private _ownedTokensIndex;
1477 
1478     // Array with all token ids, used for enumeration
1479     uint256[] private _allTokens;
1480 
1481     // Mapping from token id to position in the allTokens array
1482     mapping(uint256 => uint256) private _allTokensIndex;
1483 
1484     /**
1485      * @dev See {IERC165-supportsInterface}.
1486      */
1487     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1488         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1493      */
1494     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1495         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1496         return _ownedTokens[owner][index];
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Enumerable-totalSupply}.
1501      */
1502     function totalSupply() public view virtual override returns (uint256) {
1503         return _allTokens.length;
1504     }
1505 
1506     /**
1507      * @dev See {IERC721Enumerable-tokenByIndex}.
1508      */
1509     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1510         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1511         return _allTokens[index];
1512     }
1513 
1514     /**
1515      * @dev Hook that is called before any token transfer. This includes minting
1516      * and burning.
1517      *
1518      * Calling conditions:
1519      *
1520      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1521      * transferred to `to`.
1522      * - When `from` is zero, `tokenId` will be minted for `to`.
1523      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1524      * - `from` cannot be the zero address.
1525      * - `to` cannot be the zero address.
1526      *
1527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1528      */
1529     function _beforeTokenTransfer(
1530         address from,
1531         address to,
1532         uint256 tokenId
1533     ) internal virtual override {
1534         super._beforeTokenTransfer(from, to, tokenId);
1535 
1536         if (from == address(0)) {
1537             _addTokenToAllTokensEnumeration(tokenId);
1538         } else if (from != to) {
1539             _removeTokenFromOwnerEnumeration(from, tokenId);
1540         }
1541         if (to == address(0)) {
1542             _removeTokenFromAllTokensEnumeration(tokenId);
1543         } else if (to != from) {
1544             _addTokenToOwnerEnumeration(to, tokenId);
1545         }
1546     }
1547 
1548     /**
1549      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1550      * @param to address representing the new owner of the given token ID
1551      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1552      */
1553     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1554         uint256 length = ERC721.balanceOf(to);
1555         _ownedTokens[to][length] = tokenId;
1556         _ownedTokensIndex[tokenId] = length;
1557     }
1558 
1559     /**
1560      * @dev Private function to add a token to this extension's token tracking data structures.
1561      * @param tokenId uint256 ID of the token to be added to the tokens list
1562      */
1563     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1564         _allTokensIndex[tokenId] = _allTokens.length;
1565         _allTokens.push(tokenId);
1566     }
1567 
1568     /**
1569      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1570      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1571      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1572      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1573      * @param from address representing the previous owner of the given token ID
1574      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1575      */
1576     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1577         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1578         // then delete the last slot (swap and pop).
1579 
1580         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1581         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1582 
1583         // When the token to delete is the last token, the swap operation is unnecessary
1584         if (tokenIndex != lastTokenIndex) {
1585             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1586 
1587             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1588             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1589         }
1590 
1591         // This also deletes the contents at the last position of the array
1592         delete _ownedTokensIndex[tokenId];
1593         delete _ownedTokens[from][lastTokenIndex];
1594     }
1595 
1596     /**
1597      * @dev Private function to remove a token from this extension's token tracking data structures.
1598      * This has O(1) time complexity, but alters the order of the _allTokens array.
1599      * @param tokenId uint256 ID of the token to be removed from the tokens list
1600      */
1601     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1602         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1603         // then delete the last slot (swap and pop).
1604 
1605         uint256 lastTokenIndex = _allTokens.length - 1;
1606         uint256 tokenIndex = _allTokensIndex[tokenId];
1607 
1608         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1609         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1610         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1611         uint256 lastTokenId = _allTokens[lastTokenIndex];
1612 
1613         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1614         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1615 
1616         // This also deletes the contents at the last position of the array
1617         delete _allTokensIndex[tokenId];
1618         _allTokens.pop();
1619     }
1620 }
1621 
1622 // File: contracts/JustSteak.sol
1623 
1624 
1625 // @author: @0x1337_BEEF
1626 
1627 //          B E E F J U S T B E E F J U S T S O M E 1 3 3 7 B E E F
1628 // <pls accept this as my attempt for cool & very hip minmalistic pixel art>
1629 
1630 // Feel free to use this project or build upon it - Just mention us if you can!
1631 // The contract has getSteak(), isCooked(), isPrepared(), isEaten() to interface with your future project!
1632 // We'd love to work with you, we're looking for someone to eat us and you're looking for something fun to do
1633 // Should be gas less to list on OpenSea, happy collecting! :D
1634 
1635 pragma solidity ^0.8.4;
1636 
1637 
1638 
1639 
1640 
1641 
1642 
1643 
1644 abstract contract ContextMixin {
1645     function msgSender() internal view returns (address payable sender) {
1646         if (msg.sender == address(this)) {
1647             bytes memory array = msg.data;
1648             uint256 index = msg.data.length;
1649             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1650             assembly { sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff) }
1651         } else {
1652             sender = payable(msg.sender);
1653         }
1654         return sender;
1655     }
1656 }
1657 
1658 contract Initializable {
1659     bool inited = false;
1660     modifier initializer() {
1661         require(!inited, "already inited");
1662         _;
1663         inited = true;
1664     }
1665 }
1666 
1667 contract EIP712Base is Initializable {
1668     struct EIP712Domain {
1669         string name;
1670         string version;
1671         address verifyingContract;
1672         bytes32 salt;
1673     }
1674 
1675     string constant public ERC712_VERSION = "1";
1676 
1677     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1678         bytes(
1679             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1680         )
1681     );
1682     bytes32 internal domainSeperator;
1683 
1684     // supposed to be called once while initializing.
1685     // one of the contracts that inherits this contract follows proxy pattern
1686     // so it is not possible to do this in a constructor
1687     function _initializeEIP712(
1688         string memory name
1689     )
1690         internal
1691         initializer
1692     {
1693         _setDomainSeperator(name);
1694     }
1695 
1696     function _setDomainSeperator(string memory name) internal {
1697         domainSeperator = keccak256(
1698             abi.encode(
1699                 EIP712_DOMAIN_TYPEHASH,
1700                 keccak256(bytes(name)),
1701                 keccak256(bytes(ERC712_VERSION)),
1702                 address(this),
1703                 bytes32(getChainId())
1704             )
1705         );
1706     }
1707 
1708     function getDomainSeperator() public view returns (bytes32) {
1709         return domainSeperator;
1710     }
1711 
1712     function getChainId() public view returns (uint256) {
1713         uint256 id;
1714         assembly {
1715             id := chainid()
1716         }
1717         return id;
1718     }
1719 
1720     /**
1721      * Accept message hash and returns hash message in EIP712 compatible form
1722      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1723      * https://eips.ethereum.org/EIPS/eip-712
1724      * "\\x19" makes the encoding deterministic
1725      * "\\x01" is the version byte to make it compatible to EIP-191
1726      */
1727     function toTypedMessageHash(bytes32 messageHash)
1728         internal
1729         view
1730         returns (bytes32)
1731     {
1732         return
1733             keccak256(
1734                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1735             );
1736     }
1737 }
1738 
1739 contract NativeMetaTransaction is EIP712Base {
1740     using SafeMath for uint256;
1741     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1742         bytes(
1743             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1744         )
1745     );
1746     event MetaTransactionExecuted(
1747         address userAddress,
1748         address payable relayerAddress,
1749         bytes functionSignature
1750     );
1751     mapping(address => uint256) nonces;
1752 
1753     /*
1754      * Meta transaction structure.
1755      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1756      * He should call the desired function directly in that case.
1757      */
1758     struct MetaTransaction {
1759         uint256 nonce;
1760         address from;
1761         bytes functionSignature;
1762     }
1763 
1764     function executeMetaTransaction(
1765         address userAddress,
1766         bytes memory functionSignature,
1767         bytes32 sigR,
1768         bytes32 sigS,
1769         uint8 sigV
1770     ) public payable returns (bytes memory) {
1771         MetaTransaction memory metaTx = MetaTransaction({
1772             nonce: nonces[userAddress],
1773             from: userAddress,
1774             functionSignature: functionSignature
1775         });
1776 
1777         require(
1778             verify(userAddress, metaTx, sigR, sigS, sigV),
1779             "Signer and signature do not match"
1780         );
1781 
1782         // increase nonce for user (to avoid re-use)
1783         nonces[userAddress] = nonces[userAddress].add(1);
1784 
1785         emit MetaTransactionExecuted(
1786             userAddress,
1787             payable(msg.sender),
1788             functionSignature
1789         );
1790 
1791         // Append userAddress and relayer address at the end to extract it from calling context
1792         (bool success, bytes memory returnData) = address(this).call(
1793             abi.encodePacked(functionSignature, userAddress)
1794         );
1795         require(success, "Function call not successful");
1796 
1797         return returnData;
1798     }
1799 
1800     function hashMetaTransaction(MetaTransaction memory metaTx)
1801         internal
1802         pure
1803         returns (bytes32)
1804     {
1805         return
1806             keccak256(
1807                 abi.encode(
1808                     META_TRANSACTION_TYPEHASH,
1809                     metaTx.nonce,
1810                     metaTx.from,
1811                     keccak256(metaTx.functionSignature)
1812                 )
1813             );
1814     }
1815 
1816     function getNonce(address user) public view returns (uint256 nonce) {
1817         nonce = nonces[user];
1818     }
1819 
1820     function verify(
1821         address signer,
1822         MetaTransaction memory metaTx,
1823         bytes32 sigR,
1824         bytes32 sigS,
1825         uint8 sigV
1826     ) internal view returns (bool) {
1827         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1828         return
1829             signer ==
1830             ecrecover(
1831                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1832                 sigV,
1833                 sigR,
1834                 sigS
1835             );
1836     }
1837 }
1838 
1839 contract OwnableDelegateProxy {}
1840 
1841 contract ProxyRegistry {
1842     mapping(address => OwnableDelegateProxy) public proxies;
1843 }
1844 
1845 abstract contract ERC721Tradable is ContextMixin, ERC721Enumerable, NativeMetaTransaction, ERC721URIStorage, Ownable, ERC721Burnable {
1846     using SafeMath for uint;
1847     using Counters for Counters.Counter;
1848     //Has to be the first variable to recieve address
1849     address proxyRegistryAddress;
1850 
1851     Counters.Counter private _tokenIdCounter;
1852 
1853     //Trying something new, please no DMCA or crap, reachout first thanks!
1854     string constant ArtLicense = "All rights reserved to token owner";
1855     address constant publicKey = 0x045BF88F67846F6C06DF5cf4895de431522d2189;
1856 
1857     //Steakonomics 101
1858     uint public constant maxSteaks = 1337; //Minimum expected owner count = 430
1859     uint public constant maxReserve = 13; //Dev, Marketing & Community Reserve
1860     uint public constant steakPrice = 0.15 ether; //Age like milk or silk, time shall tell, oki i kno that no make no sense
1861     
1862     //Steakology 200
1863     uint public cookingEnabled = 0;
1864     uint public preparingEnabled = 0;
1865     uint public eatingEnabled = 0;
1866     uint public burnEnabled = 0;
1867 
1868     //Set after minting is complete so other projects can interface with it
1869     mapping (uint => string) public steak;
1870 
1871     //Roadmap enablers
1872     mapping (uint => uint) public cooked;
1873     mapping (uint => uint) public prepared;
1874     mapping (uint => uint) public eaten;   
1875 
1876     //Track how many Steaks a Steakling has couped up
1877     mapping (address => uint) public userMinted;  
1878     uint public maxMintsPerWallet = 0;
1879 
1880     constructor(string memory _name, string memory _symbol, address _proxyRegistryAddress) ERC721(_name, _symbol) {
1881         proxyRegistryAddress = _proxyRegistryAddress;
1882         _initializeEIP712(_name);
1883     }
1884 
1885     function baseTokenURI() virtual public view returns (string memory);
1886 
1887     function tokenURI(uint256 _tokenId) override(ERC721, ERC721URIStorage) public view returns (string memory) {
1888         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1889     }
1890 
1891     /**
1892      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1893      */
1894     function isApprovedForAll(address owner, address operator) override public view returns (bool) {
1895         // Whitelist OpenSea proxy contract for easy trading.
1896         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1897         if (address(proxyRegistry.proxies(owner)) == operator) {
1898             return true;
1899         }
1900         return super.isApprovedForAll(owner, operator);
1901     }
1902 
1903     /**
1904      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1905      */
1906     function _msgSender() internal override view returns (address sender) {
1907         return ContextMixin.msgSender();
1908     }
1909 
1910     function mintX(address to, uint amount) private {
1911         for(uint i = 0; i < amount; i++){
1912             _tokenIdCounter.increment();
1913             _safeMint(to, _tokenIdCounter.current());
1914             userMinted[to] += 1;
1915         }
1916     }
1917 
1918     //To ensure only proper Steak.wtf transactions get through for whitelisting purposes
1919     function mint(uint amount, uint8 v, bytes32 r, bytes32 s, bytes32 salt) public payable {
1920         uint total = totalSupply();
1921         address dearestSteakOwner = _msgSender();
1922         require(maxMintsPerWallet != 0, "Shops closed!");
1923         require(total + amount <= maxSteaks, "Not that many steaks left!");
1924         require(userMinted[dearestSteakOwner] + amount <= maxMintsPerWallet, "Leave some for the rest!");
1925         require(msg.value >= steakPrice.mul(amount), "Not enuf moulah! NGMI");
1926         require(publicKey == ecrecover(salt, v, r, s), "Unverified");
1927         mintX(dearestSteakOwner, amount);
1928     }
1929 
1930     function reserve(address to, uint amount) public onlyOwner {
1931         require(userMinted[to] + amount <= maxReserve, "Exceeding reserve max!");
1932         uint total = totalSupply();
1933         require(total + amount <= maxSteaks, "Not that many steaks left!");
1934         mintX(to, amount);
1935     }
1936 
1937     //Token Sale
1938     function setSaleState(uint stateValue) public onlyOwner {
1939         require(stateValue < 5, "Capped to 4!");
1940         maxMintsPerWallet = stateValue;
1941     }
1942 
1943     function cook(uint tokenId) public {
1944         require(_isApprovedOrOwner(_msgSender(), tokenId), "Can't cook what's not yours!");
1945         require(cooked[tokenId] == 0, "Already cooked!");
1946         require(cookingEnabled == 1, "Cooking expansion not enabled!");
1947         cooked[tokenId] = 1;
1948     }
1949     
1950     function prepare(uint tokenId)  public {
1951         require(_isApprovedOrOwner(_msgSender(), tokenId), "Can't prepare what's not yours!");
1952         require(prepared[tokenId] == 0, "Already prepared!");
1953         require(preparingEnabled == 1, "Preparing expansion not enabled!");
1954         prepared[tokenId] = 1;
1955     }
1956 
1957     function eat(uint tokenId)  public {
1958         require(_isApprovedOrOwner(_msgSender(), tokenId), "Can't eat what's not yours!");
1959         require(eaten[tokenId] == 0, "Already eaten!");
1960         require(eatingEnabled == 1, "Eating expansion not enabled!");
1961         eaten[tokenId] = 1;
1962         if (burnEnabled == 1) {
1963             super._burn(tokenId);
1964         }
1965     } 
1966 
1967     //Enable cooking for all, be careful to not burn stuff
1968     function toggleCooking() public onlyOwner {
1969         cookingEnabled = flip(cookingEnabled);
1970     }
1971 
1972     function togglePreparing() public onlyOwner {
1973         preparingEnabled = flip(preparingEnabled);
1974     }
1975 
1976     function toggleEating() public onlyOwner {
1977         eatingEnabled = flip(eatingEnabled);
1978     }
1979 
1980     function toggleBurning() public onlyOwner {
1981         burnEnabled = flip(burnEnabled);
1982     }
1983 
1984     function flip(uint varToFlip) internal pure returns (uint) {
1985         if (varToFlip == 1) {
1986             return 0;
1987         }
1988         return 1;
1989     }
1990 
1991     function setSteakDetails (uint[] memory steakIDs, string[] memory steakDeets) public onlyOwner {
1992         for (uint i = 0; i < steakIDs.length; i++) {
1993             steak[steakIDs[i]] = steakDeets[i];
1994         }
1995     }
1996     
1997     function withdrawAll() public onlyOwner {
1998         uint balance = address(this).balance;
1999         require(balance > 0, "Address: Zero balance");
2000         address safetyAddress = 0x86068B3973644D44eFFBd82a098875349610FB21;
2001         //Hack me once, shame on you!
2002         (bool success1, ) = safetyAddress.call{value: balance.mul(20).div(100)}("");
2003         require(success1, "Transfer 1 failiure!");
2004         //Hack me twice, shame on me!
2005         (bool success2, ) = msg.sender.call{value: address(this).balance}("");
2006         require(success2, "Transfer 2 failiure!");
2007     }
2008 
2009     function _beforeTokenTransfer(address from, address to, uint tokenId) internal override(ERC721, ERC721Enumerable) {
2010         super._beforeTokenTransfer(from, to, tokenId);
2011     }
2012 
2013     function _burn(uint tokenId) internal override(ERC721, ERC721URIStorage) onlyOwner {
2014         super._burn(tokenId);
2015     }
2016 
2017     //VIEWS:
2018 
2019     //This is here for your project to use! Returns name of steak cut
2020     function getSteak(uint tokenId) public view returns (string memory) {
2021         return steak[tokenId];
2022     }
2023     
2024     //Same thing with this one! Returns whether or not the steak is cooked
2025     function isCooked(uint tokenId) public view returns (uint) {
2026         return cooked[tokenId];
2027     }
2028     
2029     //Also this one! Returns whether the steak has been prepared or not
2030     function isPrepared(uint tokenId) public view returns (uint) {
2031         return prepared[tokenId];
2032     }
2033 
2034     //Your project could have eaten this one! Don't be shy reach out! PFPs enjoying delicious steaks sounds fun!
2035     function isEaten(uint tokenId) public view returns (uint) {
2036         return eaten[tokenId];
2037     }
2038 
2039     //Get all steaks owned by address
2040     function steaksByOwner(address _owner) public view returns (uint[] memory) {
2041         uint tokenCount = balanceOf(_owner);
2042         uint[] memory steakIds = new uint[](tokenCount);
2043         for (uint i = 0; i < tokenCount; i++) {
2044             steakIds[i] = tokenOfOwnerByIndex(_owner, i);
2045         }
2046         return steakIds;
2047     }
2048 
2049     //Get all steaks owned by your lovely address good ser!
2050     function showMeMyYummies() external view returns (uint[] memory) {
2051         return steaksByOwner(_msgSender());
2052     }
2053 
2054     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
2055         return super.supportsInterface(interfaceId);
2056     }
2057 }
2058 
2059 
2060 contract Steak is ERC721Tradable {
2061     //address constant OpenSeaProxy = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
2062 
2063 
2064     constructor(address _proxyRegistryAddress) ERC721Tradable("Steak", "STEAKS", _proxyRegistryAddress) { }
2065 
2066     //API to be migrated after minting => IPFS/ARWEAVE
2067     string public baseTokenURIs = "https://www.steak.wtf/api/metadata/";
2068 
2069     function setBaseURI(string memory baseURI) public onlyOwner {
2070         baseTokenURIs = baseURI;
2071     }
2072 
2073     function baseTokenURI() override public view returns (string memory) {
2074         return baseTokenURIs;
2075     }
2076 
2077     function _baseURI() internal view virtual override returns (string memory) {
2078         return baseTokenURIs;
2079     }
2080 
2081 }