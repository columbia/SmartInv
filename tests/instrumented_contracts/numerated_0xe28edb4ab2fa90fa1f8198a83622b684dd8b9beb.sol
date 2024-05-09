1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
15 library Counters {
16     struct Counter {
17         // This variable should never be directly accessed by users of the library: interactions must be restricted to
18         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
19         // this feature: see https://github.com/ethereum/solidity/issues/4637
20         uint256 _value; // default: 0
21     }
22 
23     function current(Counter storage counter) internal view returns (uint256) {
24         return counter._value;
25     }
26 
27     function increment(Counter storage counter) internal {
28         unchecked {
29             counter._value += 1;
30         }
31     }
32 
33     function decrement(Counter storage counter) internal {
34         uint256 value = counter._value;
35         require(value > 0, "Counter: decrement overflow");
36         unchecked {
37             counter._value = value - 1;
38         }
39     }
40 
41     function reset(Counter storage counter) internal {
42         counter._value = 0;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
47 
48 
49 
50 pragma solidity ^0.8.0;
51 
52 // CAUTION
53 // This version of SafeMath should only be used with Solidity 0.8 or later,
54 // because it relies on the compiler's built in overflow checks.
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations.
58  *
59  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
60  * now has built in overflow checking.
61  */
62 library SafeMath {
63     /**
64      * @dev Returns the addition of two unsigned integers, with an overflow flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             uint256 c = a + b;
71             if (c < a) return (false, 0);
72             return (true, c);
73         }
74     }
75 
76     /**
77      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
78      *
79      * _Available since v3.4._
80      */
81     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             if (b > a) return (false, 0);
84             return (true, a - b);
85         }
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
90      *
91      * _Available since v3.4._
92      */
93     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         unchecked {
95             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96             // benefit is lost if 'b' is also tested.
97             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
98             if (a == 0) return (true, 0);
99             uint256 c = a * b;
100             if (c / a != b) return (false, 0);
101             return (true, c);
102         }
103     }
104 
105     /**
106      * @dev Returns the division of two unsigned integers, with a division by zero flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b == 0) return (false, 0);
113             return (true, a / b);
114         }
115     }
116 
117     /**
118      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
119      *
120      * _Available since v3.4._
121      */
122     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b == 0) return (false, 0);
125             return (true, a % b);
126         }
127     }
128 
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a + b;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a - b;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a * b;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers, reverting on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator.
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return a / b;
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
187      * reverting when dividing by zero.
188      *
189      * Counterpart to Solidity's `%` operator. This function uses a `revert`
190      * opcode (which leaves remaining gas untouched) while Solidity uses an
191      * invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a % b;
199     }
200 
201     /**
202      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
203      * overflow (when the result is negative).
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {trySub}.
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b <= a, errorMessage);
221             return a - b;
222         }
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         unchecked {
243             require(b > 0, errorMessage);
244             return a / b;
245         }
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * reverting with custom message when dividing by zero.
251      *
252      * CAUTION: This function is deprecated because it requires allocating memory for the error
253      * message unnecessarily. For custom revert reasons use {tryMod}.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         unchecked {
269             require(b > 0, errorMessage);
270             return a % b;
271         }
272     }
273 }
274 
275 // File: @openzeppelin/contracts/utils/Context.sol
276 
277 
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Provides information about the current execution context, including the
283  * sender of the transaction and its data. While these are generally available
284  * via msg.sender and msg.data, they should not be accessed in such a direct
285  * manner, since when dealing with meta-transactions the account sending and
286  * paying for execution may not be the actual sender (as far as an application
287  * is concerned).
288  *
289  * This contract is only required for intermediate, library-like contracts.
290  */
291 abstract contract Context {
292     function _msgSender() internal view virtual returns (address) {
293         return msg.sender;
294     }
295 
296     function _msgData() internal view virtual returns (bytes calldata) {
297         return msg.data;
298     }
299 }
300 // File: @openzeppelin/contracts/access/Ownable.sol
301 
302 
303 
304 pragma solidity ^0.8.0;
305 
306 
307 /**
308  * @dev Contract module which provides a basic access control mechanism, where
309  * there is an account (an owner) that can be granted exclusive access to
310  * specific functions.
311  *
312  * By default, the owner account will be the one that deploys the contract. This
313  * can later be changed with {transferOwnership}.
314  *
315  * This module is used through inheritance. It will make available the modifier
316  * `onlyOwner`, which can be applied to your functions to restrict their use to
317  * the owner.
318  */
319 abstract contract Ownable is Context {
320     address private _owner;
321 
322     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
323 
324     /**
325      * @dev Initializes the contract setting the deployer as the initial owner.
326      */
327     constructor() {
328         _setOwner(_msgSender());
329     }
330 
331     /**
332      * @dev Returns the address of the current owner.
333      */
334     function owner() public view virtual returns (address) {
335         return _owner;
336     }
337 
338     /**
339      * @dev Throws if called by any account other than the owner.
340      */
341     modifier onlyOwner() {
342         require(owner() == _msgSender(), "Ownable: caller is not the owner");
343         _;
344     }
345 
346     /**
347      * @dev Leaves the contract without owner. It will not be possible to call
348      * `onlyOwner` functions anymore. Can only be called by the current owner.
349      *
350      * NOTE: Renouncing ownership will leave the contract without an owner,
351      * thereby removing any functionality that is only available to the owner.
352      */
353     function renounceOwnership() public virtual onlyOwner {
354         _setOwner(address(0));
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Can only be called by the current owner.
360      */
361     function transferOwnership(address newOwner) public virtual onlyOwner {
362         require(newOwner != address(0), "Ownable: new owner is the zero address");
363         _setOwner(newOwner);
364     }
365 
366     function _setOwner(address newOwner) private {
367         address oldOwner = _owner;
368         _owner = newOwner;
369         emit OwnershipTransferred(oldOwner, newOwner);
370     }
371 }
372 
373 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
374 
375 
376 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
377 
378 
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Interface of the ERC165 standard, as defined in the
384  * https://eips.ethereum.org/EIPS/eip-165[EIP].
385  *
386  * Implementers can declare support of contract interfaces, which can then be
387  * queried by others ({ERC165Checker}).
388  *
389  * For an implementation, see {ERC165}.
390  */
391 interface IERC165 {
392     /**
393      * @dev Returns true if this contract implements the interface defined by
394      * `interfaceId`. See the corresponding
395      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
396      * to learn more about how these ids are created.
397      *
398      * This function call must use less than 30 000 gas.
399      */
400     function supportsInterface(bytes4 interfaceId) external view returns (bool);
401 }
402 
403 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
404 
405 
406 
407 
408 
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @dev Implementation of the {IERC165} interface.
415  *
416  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
417  * for the additional interface id that will be supported. For example:
418  *
419  * ```solidity
420  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
422  * }
423  * ```
424  *
425  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
426  */
427 abstract contract ERC165 is IERC165 {
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         return interfaceId == type(IERC165).interfaceId;
433     }
434 }
435 
436 // File: @openzeppelin/contracts/utils/Strings.sol
437 
438 
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev String operations.
444  */
445 library Strings {
446     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
447 
448     /**
449      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
450      */
451     function toString(uint256 value) internal pure returns (string memory) {
452         // Inspired by OraclizeAPI's implementation - MIT licence
453         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
454 
455         if (value == 0) {
456             return "0";
457         }
458         uint256 temp = value;
459         uint256 digits;
460         while (temp != 0) {
461             digits++;
462             temp /= 10;
463         }
464         bytes memory buffer = new bytes(digits);
465         while (value != 0) {
466             digits -= 1;
467             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
468             value /= 10;
469         }
470         return string(buffer);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
475      */
476     function toHexString(uint256 value) internal pure returns (string memory) {
477         if (value == 0) {
478             return "0x00";
479         }
480         uint256 temp = value;
481         uint256 length = 0;
482         while (temp != 0) {
483             length++;
484             temp >>= 8;
485         }
486         return toHexString(value, length);
487     }
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
491      */
492     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
493         bytes memory buffer = new bytes(2 * length + 2);
494         buffer[0] = "0";
495         buffer[1] = "x";
496         for (uint256 i = 2 * length + 1; i > 1; --i) {
497             buffer[i] = _HEX_SYMBOLS[value & 0xf];
498             value >>= 4;
499         }
500         require(value == 0, "Strings: hex length insufficient");
501         return string(buffer);
502     }
503 }
504 
505 
506 // File: @openzeppelin/contracts/utils/Address.sol
507 
508 
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Collection of functions related to the address type
514  */
515 library Address {
516     /**
517      * @dev Returns true if `account` is a contract.
518      *
519      * [IMPORTANT]
520      * ====
521      * It is unsafe to assume that an address for which this function returns
522      * false is an externally-owned account (EOA) and not a contract.
523      *
524      * Among others, `isContract` will return false for the following
525      * types of addresses:
526      *
527      *  - an externally-owned account
528      *  - a contract in construction
529      *  - an address where a contract will be created
530      *  - an address where a contract lived, but was destroyed
531      * ====
532      */
533     function isContract(address account) internal view returns (bool) {
534         // This method relies on extcodesize, which returns 0 for contracts in
535         // construction, since the code is only stored at the end of the
536         // constructor execution.
537 
538         uint256 size;
539         assembly {
540             size := extcodesize(account)
541         }
542         return size > 0;
543     }
544 
545     /**
546      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
547      * `recipient`, forwarding all available gas and reverting on errors.
548      *
549      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
550      * of certain opcodes, possibly making contracts go over the 2300 gas limit
551      * imposed by `transfer`, making them unable to receive funds via
552      * `transfer`. {sendValue} removes this limitation.
553      *
554      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
555      *
556      * IMPORTANT: because control is transferred to `recipient`, care must be
557      * taken to not create reentrancy vulnerabilities. Consider using
558      * {ReentrancyGuard} or the
559      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
560      */
561     function sendValue(address payable recipient, uint256 amount) internal {
562         require(address(this).balance >= amount, "Address: insufficient balance");
563 
564         (bool success, ) = recipient.call{value: amount}("");
565         require(success, "Address: unable to send value, recipient may have reverted");
566     }
567 
568     /**
569      * @dev Performs a Solidity function call using a low level `call`. A
570      * plain `call` is an unsafe replacement for a function call: use this
571      * function instead.
572      *
573      * If `target` reverts with a revert reason, it is bubbled up by this
574      * function (like regular Solidity function calls).
575      *
576      * Returns the raw returned data. To convert to the expected return value,
577      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
578      *
579      * Requirements:
580      *
581      * - `target` must be a contract.
582      * - calling `target` with `data` must not revert.
583      *
584      * _Available since v3.1._
585      */
586     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionCall(target, data, "Address: low-level call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
592      * `errorMessage` as a fallback revert reason when `target` reverts.
593      *
594      * _Available since v3.1._
595      */
596     function functionCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         return functionCallWithValue(target, data, 0, errorMessage);
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
606      * but also transferring `value` wei to `target`.
607      *
608      * Requirements:
609      *
610      * - the calling contract must have an ETH balance of at least `value`.
611      * - the called Solidity function must be `payable`.
612      *
613      * _Available since v3.1._
614      */
615     function functionCallWithValue(
616         address target,
617         bytes memory data,
618         uint256 value
619     ) internal returns (bytes memory) {
620         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
625      * with `errorMessage` as a fallback revert reason when `target` reverts.
626      *
627      * _Available since v3.1._
628      */
629     function functionCallWithValue(
630         address target,
631         bytes memory data,
632         uint256 value,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(address(this).balance >= value, "Address: insufficient balance for call");
636         require(isContract(target), "Address: call to non-contract");
637 
638         (bool success, bytes memory returndata) = target.call{value: value}(data);
639         return verifyCallResult(success, returndata, errorMessage);
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644      * but performing a static call.
645      *
646      * _Available since v3.3._
647      */
648     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
649         return functionStaticCall(target, data, "Address: low-level static call failed");
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
654      * but performing a static call.
655      *
656      * _Available since v3.3._
657      */
658     function functionStaticCall(
659         address target,
660         bytes memory data,
661         string memory errorMessage
662     ) internal view returns (bytes memory) {
663         require(isContract(target), "Address: static call to non-contract");
664 
665         (bool success, bytes memory returndata) = target.staticcall(data);
666         return verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.4._
674      */
675     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
676         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
681      * but performing a delegate call.
682      *
683      * _Available since v3.4._
684      */
685     function functionDelegateCall(
686         address target,
687         bytes memory data,
688         string memory errorMessage
689     ) internal returns (bytes memory) {
690         require(isContract(target), "Address: delegate call to non-contract");
691 
692         (bool success, bytes memory returndata) = target.delegatecall(data);
693         return verifyCallResult(success, returndata, errorMessage);
694     }
695 
696     /**
697      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
698      * revert reason using the provided one.
699      *
700      * _Available since v4.3._
701      */
702     function verifyCallResult(
703         bool success,
704         bytes memory returndata,
705         string memory errorMessage
706     ) internal pure returns (bytes memory) {
707         if (success) {
708             return returndata;
709         } else {
710             // Look for revert reason and bubble it up if present
711             if (returndata.length > 0) {
712                 // The easiest way to bubble the revert reason is using memory via assembly
713 
714                 assembly {
715                     let returndata_size := mload(returndata)
716                     revert(add(32, returndata), returndata_size)
717                 }
718             } else {
719                 revert(errorMessage);
720             }
721         }
722     }
723 }
724 
725 
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @title ERC721 token receiver interface
731  * @dev Interface for any contract that wants to support safeTransfers
732  * from ERC721 asset contracts.
733  */
734 interface IERC721Receiver {
735     /**
736      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
737      * by `operator` from `from`, this function is called.
738      *
739      * It must return its Solidity selector to confirm the token transfer.
740      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
741      *
742      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
743      */
744     function onERC721Received(
745         address operator,
746         address from,
747         uint256 tokenId,
748         bytes calldata data
749     ) external returns (bytes4);
750 }
751 
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @dev Required interface of an ERC721 compliant contract.
758  */
759 interface IERC721 is IERC165 {
760     /**
761      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
762      */
763     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
764 
765     /**
766      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
767      */
768     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
769 
770     /**
771      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
772      */
773     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
774 
775     /**
776      * @dev Returns the number of tokens in ``owner``'s account.
777      */
778     function balanceOf(address owner) external view returns (uint256 balance);
779 
780     /**
781      * @dev Returns the owner of the `tokenId` token.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function ownerOf(uint256 tokenId) external view returns (address owner);
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) external;
808 
809     /**
810      * @dev Transfers `tokenId` token from `from` to `to`.
811      *
812      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
820      *
821      * Emits a {Transfer} event.
822      */
823     function transferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) external;
828 
829     /**
830      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
831      * The approval is cleared when the token is transferred.
832      *
833      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
834      *
835      * Requirements:
836      *
837      * - The caller must own the token or be an approved operator.
838      * - `tokenId` must exist.
839      *
840      * Emits an {Approval} event.
841      */
842     function approve(address to, uint256 tokenId) external;
843 
844     /**
845      * @dev Returns the account approved for `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function getApproved(uint256 tokenId) external view returns (address operator);
852 
853     /**
854      * @dev Approve or remove `operator` as an operator for the caller.
855      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
856      *
857      * Requirements:
858      *
859      * - The `operator` cannot be the caller.
860      *
861      * Emits an {ApprovalForAll} event.
862      */
863     function setApprovalForAll(address operator, bool _approved) external;
864 
865     /**
866      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
867      *
868      * See {setApprovalForAll}
869      */
870     function isApprovedForAll(address owner, address operator) external view returns (bool);
871 
872     /**
873      * @dev Safely transfers `tokenId` token from `from` to `to`.
874      *
875      * Requirements:
876      *
877      * - `from` cannot be the zero address.
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must exist and be owned by `from`.
880      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes calldata data
890     ) external;
891 }
892 
893 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
894 
895 
896 
897 pragma solidity ^0.8.0;
898 
899 
900 
901 
902 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
903 
904 
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
911  * @dev See https://eips.ethereum.org/EIPS/eip-721
912  */
913 interface IERC721Metadata is IERC721 {
914     /**
915      * @dev Returns the token collection name.
916      */
917     function name() external view returns (string memory);
918 
919     /**
920      * @dev Returns the token collection symbol.
921      */
922     function symbol() external view returns (string memory);
923 
924     /**
925      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
926      */
927     function tokenURI(uint256 tokenId) external view returns (string memory);
928 }
929 
930 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
931 
932 
933 
934 
935 
936 /**
937  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
938  * the Metadata extension, but not including the Enumerable extension, which is available separately as
939  * {ERC721Enumerable}.
940  */
941 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
942     using Address for address;
943     using Strings for uint256;
944 
945     // Token name
946     string private _name;
947 
948     // Token symbol
949     string private _symbol;
950 
951     // Mapping from token ID to owner address
952     mapping(uint256 => address) private _owners;
953 
954     // Mapping owner address to token count
955     mapping(address => uint256) private _balances;
956 
957     // Mapping from token ID to approved address
958     mapping(uint256 => address) private _tokenApprovals;
959 
960     // Mapping from owner to operator approvals
961     mapping(address => mapping(address => bool)) private _operatorApprovals;
962 
963     /**
964      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
965      */
966     constructor(string memory name_, string memory symbol_) {
967         _name = name_;
968         _symbol = symbol_;
969     }
970 
971     /**
972      * @dev See {IERC165-supportsInterface}.
973      */
974     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
975         return
976             interfaceId == type(IERC721).interfaceId ||
977             interfaceId == type(IERC721Metadata).interfaceId ||
978             super.supportsInterface(interfaceId);
979     }
980 
981     /**
982      * @dev See {IERC721-balanceOf}.
983      */
984     function balanceOf(address owner) public view virtual override returns (uint256) {
985         require(owner != address(0), "ERC721: balance query for the zero address");
986         return _balances[owner];
987     }
988 
989     /**
990      * @dev See {IERC721-ownerOf}.
991      */
992     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
993         address owner = _owners[tokenId];
994         require(owner != address(0), "ERC721: owner query for nonexistent token");
995         return owner;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-name}.
1000      */
1001     function name() public view virtual override returns (string memory) {
1002         return _name;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-symbol}.
1007      */
1008     function symbol() public view virtual override returns (string memory) {
1009         return _symbol;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-tokenURI}.
1014      */
1015     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1016         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1017 
1018         string memory baseURI = _baseURI();
1019         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1020     }
1021 
1022     /**
1023      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1024      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1025      * by default, can be overriden in child contracts.
1026      */
1027     function _baseURI() internal view virtual returns (string memory) {
1028         return "";
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-approve}.
1033      */
1034     function approve(address to, uint256 tokenId) public virtual override {
1035         address owner = ERC721.ownerOf(tokenId);
1036         require(to != owner, "ERC721: approval to current owner");
1037 
1038         require(
1039             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1040             "ERC721: approve caller is not owner nor approved for all"
1041         );
1042 
1043         _approve(to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1050         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1051 
1052         return _tokenApprovals[tokenId];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-setApprovalForAll}.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public virtual override {
1059         require(operator != _msgSender(), "ERC721: approve to caller");
1060 
1061         _operatorApprovals[_msgSender()][operator] = approved;
1062         emit ApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         //solhint-disable-next-line max-line-length
1081         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1082 
1083         _transfer(from, to, tokenId);
1084     }
1085 
1086     /**
1087      * @dev See {IERC721-safeTransferFrom}.
1088      */
1089     function safeTransferFrom(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) public virtual override {
1094         safeTransferFrom(from, to, tokenId, "");
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-safeTransferFrom}.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) public virtual override {
1106         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1107         _safeTransfer(from, to, tokenId, _data);
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1113      *
1114      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1115      *
1116      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1117      * implement alternative mechanisms to perform token transfer, such as signature-based.
1118      *
1119      * Requirements:
1120      *
1121      * - `from` cannot be the zero address.
1122      * - `to` cannot be the zero address.
1123      * - `tokenId` token must exist and be owned by `from`.
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _safeTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) internal virtual {
1134         _transfer(from, to, tokenId);
1135         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1136     }
1137 
1138     /**
1139      * @dev Returns whether `tokenId` exists.
1140      *
1141      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1142      *
1143      * Tokens start existing when they are minted (`_mint`),
1144      * and stop existing when they are burned (`_burn`).
1145      */
1146     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1147         return _owners[tokenId] != address(0);
1148     }
1149 
1150     /**
1151      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      */
1157     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1158         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1159         address owner = ERC721.ownerOf(tokenId);
1160         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1161     }
1162 
1163     /**
1164      * @dev Safely mints `tokenId` and transfers it to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must not exist.
1169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(address to, uint256 tokenId) internal virtual {
1174         _safeMint(to, tokenId, "");
1175     }
1176 
1177     /**
1178      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1179      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1180      */
1181     function _safeMint(
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) internal virtual {
1186         _mint(to, tokenId);
1187         require(
1188             _checkOnERC721Received(address(0), to, tokenId, _data),
1189             "ERC721: transfer to non ERC721Receiver implementer"
1190         );
1191     }
1192 
1193     /**
1194      * @dev Mints `tokenId` and transfers it to `to`.
1195      *
1196      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must not exist.
1201      * - `to` cannot be the zero address.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _mint(address to, uint256 tokenId) internal virtual {
1206         require(to != address(0), "ERC721: mint to the zero address");
1207         require(!_exists(tokenId), "ERC721: token already minted");
1208 
1209         _beforeTokenTransfer(address(0), to, tokenId);
1210 
1211         _balances[to] += 1;
1212         _owners[tokenId] = to;
1213 
1214         emit Transfer(address(0), to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Destroys `tokenId`.
1219      * The approval is cleared when the token is burned.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must exist.
1224      *
1225      * Emits a {Transfer} event.
1226      */
1227     function _burn(uint256 tokenId) internal virtual {
1228         address owner = ERC721.ownerOf(tokenId);
1229 
1230         _beforeTokenTransfer(owner, address(0), tokenId);
1231 
1232         // Clear approvals
1233         _approve(address(0), tokenId);
1234 
1235         _balances[owner] -= 1;
1236         delete _owners[tokenId];
1237 
1238         emit Transfer(owner, address(0), tokenId);
1239     }
1240 
1241     /**
1242      * @dev Transfers `tokenId` from `from` to `to`.
1243      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1244      *
1245      * Requirements:
1246      *
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must be owned by `from`.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _transfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) internal virtual {
1257         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1258         require(to != address(0), "ERC721: transfer to the zero address");
1259 
1260         _beforeTokenTransfer(from, to, tokenId);
1261 
1262         // Clear approvals from the previous owner
1263         _approve(address(0), tokenId);
1264 
1265         _balances[from] -= 1;
1266         _balances[to] += 1;
1267         _owners[tokenId] = to;
1268 
1269         emit Transfer(from, to, tokenId);
1270     }
1271 
1272     /**
1273      * @dev Approve `to` to operate on `tokenId`
1274      *
1275      * Emits a {Approval} event.
1276      */
1277     function _approve(address to, uint256 tokenId) internal virtual {
1278         _tokenApprovals[tokenId] = to;
1279         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1284      * The call is not executed if the target address is not a contract.
1285      *
1286      * @param from address representing the previous owner of the given token ID
1287      * @param to target address that will receive the tokens
1288      * @param tokenId uint256 ID of the token to be transferred
1289      * @param _data bytes optional data to send along with the call
1290      * @return bool whether the call correctly returned the expected magic value
1291      */
1292     function _checkOnERC721Received(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory _data
1297     ) private returns (bool) {
1298         if (to.isContract()) {
1299             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1300                 return retval == IERC721Receiver.onERC721Received.selector;
1301             } catch (bytes memory reason) {
1302                 if (reason.length == 0) {
1303                     revert("ERC721: transfer to non ERC721Receiver implementer");
1304                 } else {
1305                     assembly {
1306                         revert(add(32, reason), mload(reason))
1307                     }
1308                 }
1309             }
1310         } else {
1311             return true;
1312         }
1313     }
1314 
1315     /**
1316      * @dev Hook that is called before any token transfer. This includes minting
1317      * and burning.
1318      *
1319      * Calling conditions:
1320      *
1321      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1322      * transferred to `to`.
1323      * - When `from` is zero, `tokenId` will be minted for `to`.
1324      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1325      * - `from` and `to` are never both zero.
1326      *
1327      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1328      */
1329     function _beforeTokenTransfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual {}
1334 }
1335 
1336 // File: contracts/EverydayApes.sol
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 
1341 
1342 /**
1343  * @title ERC721 Burnable Token
1344  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1345  */
1346 abstract contract ERC721Burnable is Context, ERC721 {
1347     /**
1348      * @dev Burns `tokenId`. See {ERC721-_burn}.
1349      *
1350      * Requirements:
1351      *
1352      * - The caller must own `tokenId` or be an approved operator.
1353      */
1354     function burn(uint256 tokenId) public virtual {
1355         //solhint-disable-next-line max-line-length
1356         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1357         _burn(tokenId);
1358     }
1359 }
1360 
1361 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1362 
1363 
1364 
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 
1369 /**
1370  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1371  * @dev See https://eips.ethereum.org/EIPS/eip-721
1372  */
1373 interface IERC721Enumerable is IERC721 {
1374     /**
1375      * @dev Returns the total amount of tokens stored by the contract.
1376      */
1377     function totalSupply() external view returns (uint256);
1378 
1379     /**
1380      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1381      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1382      */
1383     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1384 
1385     /**
1386      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1387      * Use along with {totalSupply} to enumerate all tokens.
1388      */
1389     function tokenByIndex(uint256 index) external view returns (uint256);
1390 }
1391 
1392 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1393 
1394 
1395 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1396 
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 
1401 
1402 /**
1403  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1404  * enumerability of all the token ids in the contract as well as all token ids owned by each
1405  * account.
1406  */
1407 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1408     // Mapping from owner to list of owned token IDs
1409     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1410 
1411     // Mapping from token ID to index of the owner tokens list
1412     mapping(uint256 => uint256) private _ownedTokensIndex;
1413 
1414     // Array with all token ids, used for enumeration
1415     uint256[] private _allTokens;
1416 
1417     // Mapping from token id to position in the allTokens array
1418     mapping(uint256 => uint256) private _allTokensIndex;
1419 
1420     /**
1421      * @dev See {IERC165-supportsInterface}.
1422      */
1423     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1424         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1425     }
1426 
1427     /**
1428      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1429      */
1430     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1431         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1432         return _ownedTokens[owner][index];
1433     }
1434 
1435     /**
1436      * @dev See {IERC721Enumerable-totalSupply}.
1437      */
1438     function totalSupply() public view virtual override returns (uint256) {
1439         return _allTokens.length;
1440     }
1441 
1442     /**
1443      * @dev See {IERC721Enumerable-tokenByIndex}.
1444      */
1445     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1446         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1447         return _allTokens[index];
1448     }
1449 
1450     /**
1451      * @dev Hook that is called before any token transfer. This includes minting
1452      * and burning.
1453      *
1454      * Calling conditions:
1455      *
1456      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1457      * transferred to `to`.
1458      * - When `from` is zero, `tokenId` will be minted for `to`.
1459      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1460      * - `from` cannot be the zero address.
1461      * - `to` cannot be the zero address.
1462      *
1463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1464      */
1465     function _beforeTokenTransfer(
1466         address from,
1467         address to,
1468         uint256 tokenId
1469     ) internal virtual override {
1470         super._beforeTokenTransfer(from, to, tokenId);
1471 
1472         if (from == address(0)) {
1473             _addTokenToAllTokensEnumeration(tokenId);
1474         } else if (from != to) {
1475             _removeTokenFromOwnerEnumeration(from, tokenId);
1476         }
1477         if (to == address(0)) {
1478             _removeTokenFromAllTokensEnumeration(tokenId);
1479         } else if (to != from) {
1480             _addTokenToOwnerEnumeration(to, tokenId);
1481         }
1482     }
1483 
1484     /**
1485      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1486      * @param to address representing the new owner of the given token ID
1487      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1488      */
1489     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1490         uint256 length = ERC721.balanceOf(to);
1491         _ownedTokens[to][length] = tokenId;
1492         _ownedTokensIndex[tokenId] = length;
1493     }
1494 
1495     /**
1496      * @dev Private function to add a token to this extension's token tracking data structures.
1497      * @param tokenId uint256 ID of the token to be added to the tokens list
1498      */
1499     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1500         _allTokensIndex[tokenId] = _allTokens.length;
1501         _allTokens.push(tokenId);
1502     }
1503 
1504     /**
1505      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1506      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1507      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1508      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1509      * @param from address representing the previous owner of the given token ID
1510      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1511      */
1512     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1513         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1514         // then delete the last slot (swap and pop).
1515 
1516         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1517         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1518 
1519         // When the token to delete is the last token, the swap operation is unnecessary
1520         if (tokenIndex != lastTokenIndex) {
1521             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1522 
1523             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1524             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1525         }
1526 
1527         // This also deletes the contents at the last position of the array
1528         delete _ownedTokensIndex[tokenId];
1529         delete _ownedTokens[from][lastTokenIndex];
1530     }
1531 
1532     /**
1533      * @dev Private function to remove a token from this extension's token tracking data structures.
1534      * This has O(1) time complexity, but alters the order of the _allTokens array.
1535      * @param tokenId uint256 ID of the token to be removed from the tokens list
1536      */
1537     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1538         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1539         // then delete the last slot (swap and pop).
1540 
1541         uint256 lastTokenIndex = _allTokens.length - 1;
1542         uint256 tokenIndex = _allTokensIndex[tokenId];
1543 
1544         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1545         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1546         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1547         uint256 lastTokenId = _allTokens[lastTokenIndex];
1548 
1549         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1550         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1551 
1552         // This also deletes the contents at the last position of the array
1553         delete _allTokensIndex[tokenId];
1554         _allTokens.pop();
1555     }
1556 }
1557 
1558 
1559 pragma solidity ^0.8.0;
1560 
1561 
1562 
1563 
1564 
1565 
1566 contract CurrencyCats is ERC721Enumerable, Ownable {
1567     using SafeMath for uint256;
1568     using Counters for Counters.Counter;
1569     using Strings for uint256;
1570     Counters.Counter private _tokenIds;
1571 
1572     string public baseTokenURI;
1573     uint256 public cost = 0.025 ether;
1574     uint256 public maxSupply = 9933;
1575     uint256 public maxMintAmount = 20;
1576     uint256 public freeMintSupply = 500;
1577     uint256 public freeMaxMintAmount = 1;
1578     bool public paused = false;
1579 
1580     event CreateCat(uint256 indexed id);
1581 
1582     constructor() public ERC721("CurrencyCats", "CC") {
1583         pause(true);
1584     }
1585     
1586     
1587     function reserveMint() public onlyOwner {        
1588         mint(msg.sender, 100);
1589     }
1590 
1591     function _totalSupply() internal view returns (uint) {
1592         return _tokenIds.current();
1593     }
1594 
1595     function totalMint() public view returns (uint256) {
1596         return _totalSupply();
1597     }
1598 
1599     function mint(address _to, uint256 _mintAmount) public payable {
1600         uint256 supply = _totalSupply();
1601         
1602         require(_mintAmount > 0);
1603         require(supply + _mintAmount <= maxSupply, "Sale Ended");
1604         
1605 
1606         if (msg.sender != owner()) {
1607             require(!paused, "Sale must be active");
1608             require(_mintAmount <= maxMintAmount, "Exceeds max mint amount");
1609             if (supply < freeMintSupply)
1610             {
1611                 require(supply + _mintAmount <= freeMintSupply, "Free mint over");
1612                 require(_mintAmount <= freeMaxMintAmount, "Exceeds free mint amount");    
1613             }
1614             else
1615             {
1616                 require(msg.value >= cost * _mintAmount, "Not enough ETH (Free mint over)");
1617             }
1618         }
1619 
1620         for (uint256 i = 0; i < _mintAmount; i++) {
1621             _mintAnElement(_to);
1622         }
1623     }
1624     
1625     function getFreeMintSupply() public view returns (uint256) {
1626         return freeMintSupply;
1627     }
1628     
1629     function getFreeMaxMintAmount() public view returns (uint256) {
1630         return freeMaxMintAmount;
1631     }
1632 
1633     function _mintAnElement(address _to) private {
1634         uint id = _totalSupply();
1635         _tokenIds.increment();
1636         _safeMint(_to, id);
1637         emit CreateCat(id);
1638     }
1639 
1640     function _baseURI() internal view virtual override returns (string memory) {
1641         return baseTokenURI;
1642     }
1643 
1644     function setBaseURI(string memory baseURI) public onlyOwner {
1645         baseTokenURI = baseURI;
1646     }
1647 
1648     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1649         uint256 tokenCount = balanceOf(_owner);
1650 
1651         uint256[] memory tokensId = new uint256[](tokenCount);
1652         for (uint256 i = 0; i < tokenCount; i++) {
1653             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1654         }
1655 
1656         return tokensId;
1657     }
1658 
1659     function pause(bool _state) public onlyOwner {
1660         paused = _state;
1661     }
1662 
1663 
1664     function setCost(uint256 _newCost) public onlyOwner() {
1665             cost = _newCost;
1666     }
1667 
1668     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1669         maxMintAmount = _newmaxMintAmount;
1670     }
1671 
1672     function withdraw() public payable onlyOwner {
1673         require(payable(msg.sender).send(address(this).balance));
1674     }
1675     
1676     function setFreeMintSupply(uint256 _newFreeMintSupply) public onlyOwner() {
1677         freeMintSupply = _newFreeMintSupply;
1678     }
1679     
1680     function setFreeMaxMintAmount(uint256 _newMaxFreeMintAmount) public onlyOwner() {
1681         freeMaxMintAmount = _newMaxFreeMintAmount;
1682     }
1683     
1684     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner() {
1685         maxSupply = _newMaxSupply;
1686     }
1687 
1688 }