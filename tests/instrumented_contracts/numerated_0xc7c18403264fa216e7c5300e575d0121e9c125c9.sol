1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // This method relies on extcodesize, which returns 0 for contracts in
29         // construction, since the code is only stored at the end of the
30         // constructor execution.
31 
32         uint256 size;
33         assembly {
34             size := extcodesize(account)
35         }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         (bool success, ) = recipient.call{value: amount}("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain `call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81         return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
119      * with `errorMessage` as a fallback revert reason when `target` reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{value: value}(data);
133         return verifyCallResult(success, returndata, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal view returns (bytes memory) {
157         require(isContract(target), "Address: static call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.staticcall(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         require(isContract(target), "Address: delegate call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.delegatecall(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
192      * revert reason using the provided one.
193      *
194      * _Available since v4.3._
195      */
196     function verifyCallResult(
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal pure returns (bytes memory) {
201         if (success) {
202             return returndata;
203         } else {
204             // Look for revert reason and bubble it up if present
205             if (returndata.length > 0) {
206                 // The easiest way to bubble the revert reason is using memory via assembly
207 
208                 assembly {
209                     let returndata_size := mload(returndata)
210                     revert(add(32, returndata), returndata_size)
211                 }
212             } else {
213                 revert(errorMessage);
214             }
215         }
216     }
217 }
218 
219 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes calldata) {
239         return msg.data;
240     }
241 }
242 
243 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @title Counters
249  * @author Matt Condon (@shrugs)
250  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
251  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
252  *
253  * Include with `using Counters for Counters.Counter;`
254  */
255 library Counters {
256     struct Counter {
257         // This variable should never be directly accessed by users of the library: interactions must be restricted to
258         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
259         // this feature: see https://github.com/ethereum/solidity/issues/4637
260         uint256 _value; // default: 0
261     }
262 
263     function current(Counter storage counter) internal view returns (uint256) {
264         return counter._value;
265     }
266 
267     function increment(Counter storage counter) internal {
268         unchecked {
269             counter._value += 1;
270         }
271     }
272 
273     function decrement(Counter storage counter) internal {
274         uint256 value = counter._value;
275         require(value > 0, "Counter: decrement overflow");
276         unchecked {
277             counter._value = value - 1;
278         }
279     }
280 
281     function reset(Counter storage counter) internal {
282         counter._value = 0;
283     }
284 }
285 
286 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Interface of the ERC165 standard, as defined in the
292  * https://eips.ethereum.org/EIPS/eip-165[EIP].
293  *
294  * Implementers can declare support of contract interfaces, which can then be
295  * queried by others ({ERC165Checker}).
296  *
297  * For an implementation, see {ERC165}.
298  */
299 interface IERC165 {
300     /**
301      * @dev Returns true if this contract implements the interface defined by
302      * `interfaceId`. See the corresponding
303      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
304      * to learn more about how these ids are created.
305      *
306      * This function call must use less than 30 000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) external view returns (bool);
309 }
310 
311 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Implementation of the {IERC165} interface.
317  *
318  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
319  * for the additional interface id that will be supported. For example:
320  *
321  * ```solidity
322  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
323  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
324  * }
325  * ```
326  *
327  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
328  */
329 abstract contract ERC165 is IERC165 {
330     /**
331      * @dev See {IERC165-supportsInterface}.
332      */
333     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
334         return interfaceId == type(IERC165).interfaceId;
335     }
336 }
337 
338 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @title ERC721 token receiver interface
344  * @dev Interface for any contract that wants to support safeTransfers
345  * from ERC721 asset contracts.
346  */
347 interface IERC721Receiver {
348     /**
349      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
350      * by `operator` from `from`, this function is called.
351      *
352      * It must return its Solidity selector to confirm the token transfer.
353      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
354      *
355      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
356      */
357     function onERC721Received(
358         address operator,
359         address from,
360         uint256 tokenId,
361         bytes calldata data
362     ) external returns (bytes4);
363 }
364 
365 
366 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Contract module which provides a basic access control mechanism, where
372  * there is an account (an owner) that can be granted exclusive access to
373  * specific functions.
374  *
375  * By default, the owner account will be the one that deploys the contract. This
376  * can later be changed with {transferOwnership}.
377  *
378  * This module is used through inheritance. It will make available the modifier
379  * `onlyOwner`, which can be applied to your functions to restrict their use to
380  * the owner.
381  */
382 abstract contract Ownable is Context {
383     address private _owner;
384 
385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387     /**
388      * @dev Initializes the contract setting the deployer as the initial owner.
389      */
390     constructor() {
391         _transferOwnership(_msgSender());
392     }
393 
394     /**
395      * @dev Returns the address of the current owner.
396      */
397     function owner() public view virtual returns (address) {
398         return _owner;
399     }
400 
401     /**
402      * @dev Throws if called by any account other than the owner.
403      */
404     modifier onlyOwner() {
405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
406         _;
407     }
408 
409     /**
410      * @dev Leaves the contract without owner. It will not be possible to call
411      * `onlyOwner` functions anymore. Can only be called by the current owner.
412      *
413      * NOTE: Renouncing ownership will leave the contract without an owner,
414      * thereby removing any functionality that is only available to the owner.
415      */
416     function renounceOwnership() public virtual onlyOwner {
417         _transferOwnership(address(0));
418     }
419 
420     /**
421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
422      * Can only be called by the current owner.
423      */
424     function transferOwnership(address newOwner) public virtual onlyOwner {
425         require(newOwner != address(0), "Ownable: new owner is the zero address");
426         _transferOwnership(newOwner);
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Internal function without access restriction.
432      */
433     function _transferOwnership(address newOwner) internal virtual {
434         address oldOwner = _owner;
435         _owner = newOwner;
436         emit OwnershipTransferred(oldOwner, newOwner);
437     }
438 }
439 
440 
441 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 // CAUTION
446 // This version of SafeMath should only be used with Solidity 0.8 or later,
447 // because it relies on the compiler's built in overflow checks.
448 
449 /**
450  * @dev Wrappers over Solidity's arithmetic operations.
451  *
452  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
453  * now has built in overflow checking.
454  */
455 library SafeMath {
456     /**
457      * @dev Returns the addition of two unsigned integers, with an overflow flag.
458      *
459      * _Available since v3.4._
460      */
461     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
462         unchecked {
463             uint256 c = a + b;
464             if (c < a) return (false, 0);
465             return (true, c);
466         }
467     }
468 
469     /**
470      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
471      *
472      * _Available since v3.4._
473      */
474     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
475         unchecked {
476             if (b > a) return (false, 0);
477             return (true, a - b);
478         }
479     }
480 
481     /**
482      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
483      *
484      * _Available since v3.4._
485      */
486     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
487         unchecked {
488             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
489             // benefit is lost if 'b' is also tested.
490             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
491             if (a == 0) return (true, 0);
492             uint256 c = a * b;
493             if (c / a != b) return (false, 0);
494             return (true, c);
495         }
496     }
497 
498     /**
499      * @dev Returns the division of two unsigned integers, with a division by zero flag.
500      *
501      * _Available since v3.4._
502      */
503     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
504         unchecked {
505             if (b == 0) return (false, 0);
506             return (true, a / b);
507         }
508     }
509 
510     /**
511      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
512      *
513      * _Available since v3.4._
514      */
515     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
516         unchecked {
517             if (b == 0) return (false, 0);
518             return (true, a % b);
519         }
520     }
521 
522     /**
523      * @dev Returns the addition of two unsigned integers, reverting on
524      * overflow.
525      *
526      * Counterpart to Solidity's `+` operator.
527      *
528      * Requirements:
529      *
530      * - Addition cannot overflow.
531      */
532     function add(uint256 a, uint256 b) internal pure returns (uint256) {
533         return a + b;
534     }
535 
536     /**
537      * @dev Returns the subtraction of two unsigned integers, reverting on
538      * overflow (when the result is negative).
539      *
540      * Counterpart to Solidity's `-` operator.
541      *
542      * Requirements:
543      *
544      * - Subtraction cannot overflow.
545      */
546     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
547         return a - b;
548     }
549 
550     /**
551      * @dev Returns the multiplication of two unsigned integers, reverting on
552      * overflow.
553      *
554      * Counterpart to Solidity's `*` operator.
555      *
556      * Requirements:
557      *
558      * - Multiplication cannot overflow.
559      */
560     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
561         return a * b;
562     }
563 
564     /**
565      * @dev Returns the integer division of two unsigned integers, reverting on
566      * division by zero. The result is rounded towards zero.
567      *
568      * Counterpart to Solidity's `/` operator.
569      *
570      * Requirements:
571      *
572      * - The divisor cannot be zero.
573      */
574     function div(uint256 a, uint256 b) internal pure returns (uint256) {
575         return a / b;
576     }
577 
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
580      * reverting when dividing by zero.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      *
588      * - The divisor cannot be zero.
589      */
590     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
591         return a % b;
592     }
593 
594     /**
595      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
596      * overflow (when the result is negative).
597      *
598      * CAUTION: This function is deprecated because it requires allocating memory for the error
599      * message unnecessarily. For custom revert reasons use {trySub}.
600      *
601      * Counterpart to Solidity's `-` operator.
602      *
603      * Requirements:
604      *
605      * - Subtraction cannot overflow.
606      */
607     function sub(
608         uint256 a,
609         uint256 b,
610         string memory errorMessage
611     ) internal pure returns (uint256) {
612         unchecked {
613             require(b <= a, errorMessage);
614             return a - b;
615         }
616     }
617 
618     /**
619      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
620      * division by zero. The result is rounded towards zero.
621      *
622      * Counterpart to Solidity's `/` operator. Note: this function uses a
623      * `revert` opcode (which leaves remaining gas untouched) while Solidity
624      * uses an invalid opcode to revert (consuming all remaining gas).
625      *
626      * Requirements:
627      *
628      * - The divisor cannot be zero.
629      */
630     function div(
631         uint256 a,
632         uint256 b,
633         string memory errorMessage
634     ) internal pure returns (uint256) {
635         unchecked {
636             require(b > 0, errorMessage);
637             return a / b;
638         }
639     }
640 
641     /**
642      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
643      * reverting with custom message when dividing by zero.
644      *
645      * CAUTION: This function is deprecated because it requires allocating memory for the error
646      * message unnecessarily. For custom revert reasons use {tryMod}.
647      *
648      * Counterpart to Solidity's `%` operator. This function uses a `revert`
649      * opcode (which leaves remaining gas untouched) while Solidity uses an
650      * invalid opcode to revert (consuming all remaining gas).
651      *
652      * Requirements:
653      *
654      * - The divisor cannot be zero.
655      */
656     function mod(
657         uint256 a,
658         uint256 b,
659         string memory errorMessage
660     ) internal pure returns (uint256) {
661         unchecked {
662             require(b > 0, errorMessage);
663             return a % b;
664         }
665     }
666 }
667 
668 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev String operations.
674  */
675 library Strings {
676     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
677 
678     /**
679      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
680      */
681     function toString(uint256 value) internal pure returns (string memory) {
682         // Inspired by OraclizeAPI's implementation - MIT licence
683         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
684 
685         if (value == 0) {
686             return "0";
687         }
688         uint256 temp = value;
689         uint256 digits;
690         while (temp != 0) {
691             digits++;
692             temp /= 10;
693         }
694         bytes memory buffer = new bytes(digits);
695         while (value != 0) {
696             digits -= 1;
697             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
698             value /= 10;
699         }
700         return string(buffer);
701     }
702 
703     /**
704      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
705      */
706     function toHexString(uint256 value) internal pure returns (string memory) {
707         if (value == 0) {
708             return "0x00";
709         }
710         uint256 temp = value;
711         uint256 length = 0;
712         while (temp != 0) {
713             length++;
714             temp >>= 8;
715         }
716         return toHexString(value, length);
717     }
718 
719     /**
720      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
721      */
722     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
723         bytes memory buffer = new bytes(2 * length + 2);
724         buffer[0] = "0";
725         buffer[1] = "x";
726         for (uint256 i = 2 * length + 1; i > 1; --i) {
727             buffer[i] = _HEX_SYMBOLS[value & 0xf];
728             value >>= 4;
729         }
730         require(value == 0, "Strings: hex length insufficient");
731         return string(buffer);
732     }
733 }
734 
735 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
736 
737 pragma solidity ^0.8.0;
738 
739 /**
740  * @dev Required interface of an ERC721 compliant contract.
741  */
742 interface IERC721 is IERC165 {
743     /**
744      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
745      */
746     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
747 
748     /**
749      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
750      */
751     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
752 
753     /**
754      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
755      */
756     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
757 
758     /**
759      * @dev Returns the number of tokens in ``owner``'s account.
760      */
761     function balanceOf(address owner) external view returns (uint256 balance);
762 
763     /**
764      * @dev Returns the owner of the `tokenId` token.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must exist.
769      */
770     function ownerOf(uint256 tokenId) external view returns (address owner);
771 
772     /**
773      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
774      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
782      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
783      *
784      * Emits a {Transfer} event.
785      */
786     function safeTransferFrom(
787         address from,
788         address to,
789         uint256 tokenId
790     ) external;
791 
792     /**
793      * @dev Transfers `tokenId` token from `from` to `to`.
794      *
795      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
796      *
797      * Requirements:
798      *
799      * - `from` cannot be the zero address.
800      * - `to` cannot be the zero address.
801      * - `tokenId` token must be owned by `from`.
802      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
803      *
804      * Emits a {Transfer} event.
805      */
806     function transferFrom(
807         address from,
808         address to,
809         uint256 tokenId
810     ) external;
811 
812     /**
813      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
814      * The approval is cleared when the token is transferred.
815      *
816      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
817      *
818      * Requirements:
819      *
820      * - The caller must own the token or be an approved operator.
821      * - `tokenId` must exist.
822      *
823      * Emits an {Approval} event.
824      */
825     function approve(address to, uint256 tokenId) external;
826 
827     /**
828      * @dev Returns the account approved for `tokenId` token.
829      *
830      * Requirements:
831      *
832      * - `tokenId` must exist.
833      */
834     function getApproved(uint256 tokenId) external view returns (address operator);
835 
836     /**
837      * @dev Approve or remove `operator` as an operator for the caller.
838      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
839      *
840      * Requirements:
841      *
842      * - The `operator` cannot be the caller.
843      *
844      * Emits an {ApprovalForAll} event.
845      */
846     function setApprovalForAll(address operator, bool _approved) external;
847 
848     /**
849      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
850      *
851      * See {setApprovalForAll}
852      */
853     function isApprovedForAll(address owner, address operator) external view returns (bool);
854 
855     /**
856      * @dev Safely transfers `tokenId` token from `from` to `to`.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must exist and be owned by `from`.
863      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
864      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
865      *
866      * Emits a {Transfer} event.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes calldata data
873     ) external;
874 }
875 
876 
877 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
878 
879 pragma solidity ^0.8.0;
880 
881 /**
882  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
883  * @dev See https://eips.ethereum.org/EIPS/eip-721
884  */
885 interface IERC721Metadata is IERC721 {
886     /**
887      * @dev Returns the token collection name.
888      */
889     function name() external view returns (string memory);
890 
891     /**
892      * @dev Returns the token collection symbol.
893      */
894     function symbol() external view returns (string memory);
895 
896     /**
897      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
898      */
899     function tokenURI(uint256 tokenId) external view returns (string memory);
900 }
901 
902 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
908  * the Metadata extension, but not including the Enumerable extension, which is available separately as
909  * {ERC721Enumerable}.
910  */
911 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
912     using Address for address;
913     using Strings for uint256;
914 
915     // Token name
916     string private _name;
917 
918     // Token symbol
919     string private _symbol;
920 
921     // Mapping from token ID to owner address
922     mapping(uint256 => address) private _owners;
923 
924     // Mapping owner address to token count
925     mapping(address => uint256) private _balances;
926 
927     // Mapping from token ID to approved address
928     mapping(uint256 => address) private _tokenApprovals;
929 
930     // Mapping from owner to operator approvals
931     mapping(address => mapping(address => bool)) private _operatorApprovals;
932 
933     /**
934      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
935      */
936     constructor(string memory name_, string memory symbol_) {
937         _name = name_;
938         _symbol = symbol_;
939     }
940 
941     /**
942      * @dev See {IERC165-supportsInterface}.
943      */
944     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
945         return
946             interfaceId == type(IERC721).interfaceId ||
947             interfaceId == type(IERC721Metadata).interfaceId ||
948             super.supportsInterface(interfaceId);
949     }
950 
951     /**
952      * @dev See {IERC721-balanceOf}.
953      */
954     function balanceOf(address owner) public view virtual override returns (uint256) {
955         require(owner != address(0), "ERC721: balance query for the zero address");
956         return _balances[owner];
957     }
958 
959     /**
960      * @dev See {IERC721-ownerOf}.
961      */
962     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
963         address owner = _owners[tokenId];
964         require(owner != address(0), "ERC721: owner query for nonexistent token");
965         return owner;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-name}.
970      */
971     function name() public view virtual override returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-symbol}.
977      */
978     function symbol() public view virtual override returns (string memory) {
979         return _symbol;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-tokenURI}.
984      */
985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
986         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
987 
988         string memory baseURI = _baseURI();
989         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
990     }
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, can be overriden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return "";
999     }
1000 
1001     /**
1002      * @dev See {IERC721-approve}.
1003      */
1004     function approve(address to, uint256 tokenId) public virtual override {
1005         address owner = ERC721.ownerOf(tokenId);
1006         require(to != owner, "ERC721: approval to current owner");
1007 
1008         require(
1009             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1010             "ERC721: approve caller is not owner nor approved for all"
1011         );
1012 
1013         _approve(to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-getApproved}.
1018      */
1019     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1020         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1021 
1022         return _tokenApprovals[tokenId];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-setApprovalForAll}.
1027      */
1028     function setApprovalForAll(address operator, bool approved) public virtual override {
1029         _setApprovalForAll(_msgSender(), operator, approved);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-isApprovedForAll}.
1034      */
1035     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1036         return _operatorApprovals[owner][operator];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-transferFrom}.
1041      */
1042     function transferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         //solhint-disable-next-line max-line-length
1048         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1049 
1050         _transfer(from, to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) public virtual override {
1061         safeTransferFrom(from, to, tokenId, "");
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-safeTransferFrom}.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) public virtual override {
1073         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1074         _safeTransfer(from, to, tokenId, _data);
1075     }
1076 
1077     /**
1078      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1079      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1080      *
1081      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1082      *
1083      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1084      * implement alternative mechanisms to perform token transfer, such as signature-based.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must exist and be owned by `from`.
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _safeTransfer(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes memory _data
1100     ) internal virtual {
1101         _transfer(from, to, tokenId);
1102         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1103     }
1104 
1105     /**
1106      * @dev Returns whether `tokenId` exists.
1107      *
1108      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1109      *
1110      * Tokens start existing when they are minted (`_mint`),
1111      * and stop existing when they are burned (`_burn`).
1112      */
1113     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1114         return _owners[tokenId] != address(0);
1115     }
1116 
1117     /**
1118      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1119      *
1120      * Requirements:
1121      *
1122      * - `tokenId` must exist.
1123      */
1124     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1125         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1126         address owner = ERC721.ownerOf(tokenId);
1127         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1128     }
1129 
1130     /**
1131      * @dev Safely mints `tokenId` and transfers it to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `tokenId` must not exist.
1136      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _safeMint(address to, uint256 tokenId) internal virtual {
1141         _safeMint(to, tokenId, "");
1142     }
1143 
1144     /**
1145      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1146      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1147      */
1148     function _safeMint(
1149         address to,
1150         uint256 tokenId,
1151         bytes memory _data
1152     ) internal virtual {
1153         _mint(to, tokenId);
1154         require(
1155             _checkOnERC721Received(address(0), to, tokenId, _data),
1156             "ERC721: transfer to non ERC721Receiver implementer"
1157         );
1158     }
1159 
1160     /**
1161      * @dev Mints `tokenId` and transfers it to `to`.
1162      *
1163      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must not exist.
1168      * - `to` cannot be the zero address.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _mint(address to, uint256 tokenId) internal virtual {
1173         require(to != address(0), "ERC721: mint to the zero address");
1174         require(!_exists(tokenId), "ERC721: token already minted");
1175 
1176         _beforeTokenTransfer(address(0), to, tokenId);
1177 
1178         _balances[to] += 1;
1179         _owners[tokenId] = to;
1180 
1181         emit Transfer(address(0), to, tokenId);
1182     }
1183 
1184     /**
1185      * @dev Destroys `tokenId`.
1186      * The approval is cleared when the token is burned.
1187      *
1188      * Requirements:
1189      *
1190      * - `tokenId` must exist.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _burn(uint256 tokenId) internal virtual {
1195         address owner = ERC721.ownerOf(tokenId);
1196 
1197         _beforeTokenTransfer(owner, address(0), tokenId);
1198 
1199         // Clear approvals
1200         _approve(address(0), tokenId);
1201 
1202         _balances[owner] -= 1;
1203         delete _owners[tokenId];
1204 
1205         emit Transfer(owner, address(0), tokenId);
1206     }
1207 
1208     /**
1209      * @dev Transfers `tokenId` from `from` to `to`.
1210      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `tokenId` token must be owned by `from`.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _transfer(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) internal virtual {
1224         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1225         require(to != address(0), "ERC721: transfer to the zero address");
1226 
1227         _beforeTokenTransfer(from, to, tokenId);
1228 
1229         // Clear approvals from the previous owner
1230         _approve(address(0), tokenId);
1231 
1232         _balances[from] -= 1;
1233         _balances[to] += 1;
1234         _owners[tokenId] = to;
1235 
1236         emit Transfer(from, to, tokenId);
1237     }
1238 
1239     /**
1240      * @dev Approve `to` to operate on `tokenId`
1241      *
1242      * Emits a {Approval} event.
1243      */
1244     function _approve(address to, uint256 tokenId) internal virtual {
1245         _tokenApprovals[tokenId] = to;
1246         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1247     }
1248 
1249     /**
1250      * @dev Approve `operator` to operate on all of `owner` tokens
1251      *
1252      * Emits a {ApprovalForAll} event.
1253      */
1254     function _setApprovalForAll(
1255         address owner,
1256         address operator,
1257         bool approved
1258     ) internal virtual {
1259         require(owner != operator, "ERC721: approve to caller");
1260         _operatorApprovals[owner][operator] = approved;
1261         emit ApprovalForAll(owner, operator, approved);
1262     }
1263 
1264     /**
1265      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1266      * The call is not executed if the target address is not a contract.
1267      *
1268      * @param from address representing the previous owner of the given token ID
1269      * @param to target address that will receive the tokens
1270      * @param tokenId uint256 ID of the token to be transferred
1271      * @param _data bytes optional data to send along with the call
1272      * @return bool whether the call correctly returned the expected magic value
1273      */
1274     function _checkOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) private returns (bool) {
1280         if (to.isContract()) {
1281             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1282                 return retval == IERC721Receiver.onERC721Received.selector;
1283             } catch (bytes memory reason) {
1284                 if (reason.length == 0) {
1285                     revert("ERC721: transfer to non ERC721Receiver implementer");
1286                 } else {
1287                     assembly {
1288                         revert(add(32, reason), mload(reason))
1289                     }
1290                 }
1291             }
1292         } else {
1293             return true;
1294         }
1295     }
1296 
1297     /**
1298      * @dev Hook that is called before any token transfer. This includes minting
1299      * and burning.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1307      * - `from` and `to` are never both zero.
1308      *
1309      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1310      */
1311     function _beforeTokenTransfer(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) internal virtual {}
1316 }
1317 
1318 pragma solidity ^0.8.10;
1319 
1320 /*
1321 █▀▄▀█ █▀█ █▀█ █▄░█ █▀   █▀█ █▀▀   █▀▄▀█ ▄▀█ █▀█ █▀
1322 █░▀░█ █▄█ █▄█ █░▀█ ▄█   █▄█ █▀░   █░▀░█ █▀█ █▀▄ ▄█
1323 */
1324 
1325 contract TheFatedRenegadesNFT is ERC721, Ownable {
1326     using SafeMath for uint256;
1327     using Address for address;
1328     using Strings for uint256;
1329     using Counters for Counters.Counter;
1330 
1331     uint256 public constant TICKET_PRICE = 50000000000000000; //0.05 ETH
1332 
1333     uint256 public constant MAX_TICKET_PER_MINT = 8;
1334 
1335     uint256 public constant MAX_TICKET_PER_WALLET = 24;
1336 
1337     uint256 public startingIndexBlock;
1338 
1339     uint256 public startingIndex;
1340 
1341     uint256 public maxTicketSupply;
1342 
1343     uint256 public revealTimestamp;
1344 
1345     bool public saleIsActive = false;
1346 
1347     string public provenanceHash = "";
1348 
1349     Counters.Counter private _tokenIdCounter;
1350 
1351     string private _baseTokenURI;
1352 
1353     constructor(
1354         string memory name,
1355         string memory symbol,
1356         uint256 maxNftSupply,
1357         uint256 saleStart
1358     ) ERC721(name, symbol) {
1359         maxTicketSupply = maxNftSupply;
1360         revealTimestamp = saleStart;
1361     }
1362 
1363     function withdraw() public onlyOwner {
1364         uint256 balance = address(this).balance;
1365         payable(msg.sender).transfer(balance);
1366     }
1367 
1368     function reserveTickets(uint256 reserveAmount) public onlyOwner {
1369         require(
1370             _tokenIdCounter.current().add(reserveAmount) <= maxTicketSupply,
1371             "Reserve would exceed max supply of tickets"
1372         );
1373 
1374         for (uint256 i = 0; i < reserveAmount; i++) {
1375             _safeMint(msg.sender, _tokenIdCounter.current());
1376             _tokenIdCounter.increment();
1377         }
1378     }
1379 
1380     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1381         revealTimestamp = revealTimeStamp;
1382     }
1383 
1384     function setProvenanceHash(string memory _provenanceHash) public onlyOwner {
1385         provenanceHash = _provenanceHash;
1386     }
1387 
1388     function setBaseURI(string memory baseURI) public onlyOwner {
1389         _baseTokenURI = baseURI;
1390     }
1391 
1392     function flipSaleState() public onlyOwner {
1393         saleIsActive = !saleIsActive;
1394     }
1395 
1396     function emergencySetStartingIndexBlock() public onlyOwner {
1397         require(startingIndex == 0, "Starting index is already set");
1398 
1399         startingIndexBlock = block.number;
1400     }
1401 
1402     function mintTicket(uint256 numberOfTokens) public payable {
1403         require(saleIsActive, "Sale must be active to mint");
1404         require(numberOfTokens > 0, "Must mint at least one ticket");
1405         require(
1406             _tokenIdCounter.current().add(numberOfTokens) <= maxTicketSupply,
1407             "Purchase would exceed max supply of tickets"
1408         );
1409         require(
1410             numberOfTokens <= MAX_TICKET_PER_MINT,
1411             "Requested number exceeds the maximum (8 per transaction)"
1412         );
1413         require(
1414             TICKET_PRICE.mul(numberOfTokens) <= msg.value,
1415             "Ether value sent is not correct"
1416         );
1417 
1418         uint256 _balance = balanceOf(msg.sender);
1419         require(
1420             _balance.add(numberOfTokens) <= MAX_TICKET_PER_WALLET,
1421             "Purchase exceed max of overall tokens per wallet (24)"
1422         );
1423 
1424         for (uint256 i = 0; i < numberOfTokens; i++) {
1425             uint256 mintIndex = _tokenIdCounter.current();
1426 
1427             _safeMint(msg.sender, mintIndex);
1428             _tokenIdCounter.increment();
1429         }
1430 
1431         // If we haven't set the starting index and this is either
1432         // 1) the last saleable token or 2) the first token to be sold after
1433         // the end of pre-sale, set the starting index block
1434         if (
1435             startingIndexBlock == 0 &&
1436             (_tokenIdCounter.current() == maxTicketSupply ||
1437                 block.timestamp >= revealTimestamp)
1438         ) {
1439             startingIndexBlock = block.number;
1440         }
1441     }
1442 
1443     function setStartingIndex() public {
1444         require(startingIndex == 0, "Starting index is already set");
1445         require(startingIndexBlock != 0, "Starting index block must be set");
1446 
1447         startingIndex =
1448             uint256(blockhash(startingIndexBlock)) %
1449             maxTicketSupply;
1450 
1451         // Just a sanity case in the worst case if this function is called late
1452         //(EVM only stores last 256 block hashes)
1453         if (block.number.sub(startingIndexBlock) > 255) {
1454             startingIndex =
1455                 uint256(blockhash(block.number - 1)) %
1456                 maxTicketSupply;
1457         }
1458         // Prevent default sequence
1459         if (startingIndex == 0) {
1460             startingIndex = startingIndex.add(1);
1461         }
1462     }
1463 
1464     function getStartingIndex() public view returns (uint256) {
1465         return startingIndex;
1466     }
1467 
1468     function tokensMinted() public view returns (uint256) {
1469         return _tokenIdCounter.current();
1470     }
1471 
1472     function totalSupply() public view returns (uint256) {
1473         return maxTicketSupply;
1474     }
1475 
1476     function getTicketsByOnwer(address _owner)
1477         external
1478         view
1479         returns (uint256[] memory)
1480     {
1481         uint256 tokenCount = balanceOf(_owner);
1482         if (tokenCount == 0) {
1483             return new uint256[](0);
1484         } else {
1485             uint256[] memory tokenList = new uint256[](tokenCount);
1486             uint256 totalTickets = _tokenIdCounter.current();
1487             uint256 index;
1488             uint256 j = 0;
1489             for (index = 0; index < totalTickets; index++) {
1490                 if (_owner == ownerOf(index)) {
1491                     tokenList[j] = index;
1492                     j++;
1493                 }
1494             }
1495             return tokenList;
1496         }
1497     }
1498 
1499     function getListOfOwners() external view returns (address[] memory) {
1500         uint256 totalTickets = _tokenIdCounter.current();
1501 
1502         if (totalTickets == 0) {
1503             return new address[](0);
1504         }
1505 
1506         address[] memory ownerList = new address[](totalTickets);
1507 
1508         for (uint256 i = 0; i < totalTickets; i++) {
1509             ownerList[i] = ownerOf(i);
1510         }
1511 
1512         return ownerList;
1513     }
1514 
1515     function tokenURI(uint256 tokenId)
1516         public
1517         view
1518         virtual
1519         override
1520         returns (string memory)
1521     {
1522         require(
1523             _exists(tokenId),
1524             "ERC721Metadata: URI query for nonexistent token"
1525         );
1526 
1527         string memory currentBaseURI = _baseURI();
1528         return
1529             bytes(currentBaseURI).length > 0
1530                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1531                 : "https://bafybeidiwwne7pkqbifjfyrynzmemkk5dpuf3yyylf7vj6j4iixwraomje.ipfs.infura-ipfs.io/";
1532     }
1533 
1534     function _baseURI() internal view virtual override returns (string memory) {
1535         return _baseTokenURI;
1536     }
1537 }