1 // File: contracts/IMadApesArmoryToken.sol
2 
3 
4 
5 pragma solidity 0.8.7;
6 
7 interface IMadApesArmoryToken {
8     function balanceOf(address account, uint256 id) external view returns (uint256 balance);
9     function burnOilForAddress(uint256 typeId, address burnTokenAddress, uint256 quantity) external;
10 }
11 // File: contracts/IAcidApesToken.sol
12 
13 
14 
15 pragma solidity 0.8.7;
16 
17 interface IAcidApesToken {
18   function balanceOf(address owner) external view returns (uint256 balance);
19   function ownerOf(uint256 tokenId) external view returns (address owner);
20   function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
21   function totalSupply() external view returns (uint256);
22   function walletOfOwner(address owner) external view returns (uint256[] memory tokenIds);
23 }
24 
25 
26 
27 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
28 
29 
30 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 // CAUTION
35 // This version of SafeMath should only be used with Solidity 0.8 or later,
36 // because it relies on the compiler's built in overflow checks.
37 
38 /**
39  * @dev Wrappers over Solidity's arithmetic operations.
40  *
41  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
42  * now has built in overflow checking.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             uint256 c = a + b;
53             if (c < a) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b > a) return (false, 0);
66             return (true, a - b);
67         }
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78             // benefit is lost if 'b' is also tested.
79             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80             if (a == 0) return (true, 0);
81             uint256 c = a * b;
82             if (c / a != b) return (false, 0);
83             return (true, c);
84         }
85     }
86 
87     /**
88      * @dev Returns the division of two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b == 0) return (false, 0);
95             return (true, a / b);
96         }
97     }
98 
99     /**
100      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b == 0) return (false, 0);
107             return (true, a % b);
108         }
109     }
110 
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a + b;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a - b;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a * b;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers, reverting on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator.
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a / b;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * reverting when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a % b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {trySub}.
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b <= a, errorMessage);
203             return a - b;
204         }
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a / b;
227         }
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting with custom message when dividing by zero.
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {tryMod}.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         unchecked {
251             require(b > 0, errorMessage);
252             return a % b;
253         }
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Strings.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev String operations.
266  */
267 library Strings {
268     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
272      */
273     function toString(uint256 value) internal pure returns (string memory) {
274         // Inspired by OraclizeAPI's implementation - MIT licence
275         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
276 
277         if (value == 0) {
278             return "0";
279         }
280         uint256 temp = value;
281         uint256 digits;
282         while (temp != 0) {
283             digits++;
284             temp /= 10;
285         }
286         bytes memory buffer = new bytes(digits);
287         while (value != 0) {
288             digits -= 1;
289             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
290             value /= 10;
291         }
292         return string(buffer);
293     }
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
297      */
298     function toHexString(uint256 value) internal pure returns (string memory) {
299         if (value == 0) {
300             return "0x00";
301         }
302         uint256 temp = value;
303         uint256 length = 0;
304         while (temp != 0) {
305             length++;
306             temp >>= 8;
307         }
308         return toHexString(value, length);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
313      */
314     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
315         bytes memory buffer = new bytes(2 * length + 2);
316         buffer[0] = "0";
317         buffer[1] = "x";
318         for (uint256 i = 2 * length + 1; i > 1; --i) {
319             buffer[i] = _HEX_SYMBOLS[value & 0xf];
320             value >>= 4;
321         }
322         require(value == 0, "Strings: hex length insufficient");
323         return string(buffer);
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Context.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Provides information about the current execution context, including the
336  * sender of the transaction and its data. While these are generally available
337  * via msg.sender and msg.data, they should not be accessed in such a direct
338  * manner, since when dealing with meta-transactions the account sending and
339  * paying for execution may not be the actual sender (as far as an application
340  * is concerned).
341  *
342  * This contract is only required for intermediate, library-like contracts.
343  */
344 abstract contract Context {
345     function _msgSender() internal view virtual returns (address) {
346         return msg.sender;
347     }
348 
349     function _msgData() internal view virtual returns (bytes calldata) {
350         return msg.data;
351     }
352 }
353 
354 // File: @openzeppelin/contracts/access/Ownable.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Contract module which provides a basic access control mechanism, where
364  * there is an account (an owner) that can be granted exclusive access to
365  * specific functions.
366  *
367  * By default, the owner account will be the one that deploys the contract. This
368  * can later be changed with {transferOwnership}.
369  *
370  * This module is used through inheritance. It will make available the modifier
371  * `onlyOwner`, which can be applied to your functions to restrict their use to
372  * the owner.
373  */
374 abstract contract Ownable is Context {
375     address private _owner;
376 
377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379     /**
380      * @dev Initializes the contract setting the deployer as the initial owner.
381      */
382     constructor() {
383         _transferOwnership(_msgSender());
384     }
385 
386     /**
387      * @dev Returns the address of the current owner.
388      */
389     function owner() public view virtual returns (address) {
390         return _owner;
391     }
392 
393     /**
394      * @dev Throws if called by any account other than the owner.
395      */
396     modifier onlyOwner() {
397         require(owner() == _msgSender(), "Ownable: caller is not the owner");
398         _;
399     }
400 
401     /**
402      * @dev Leaves the contract without owner. It will not be possible to call
403      * `onlyOwner` functions anymore. Can only be called by the current owner.
404      *
405      * NOTE: Renouncing ownership will leave the contract without an owner,
406      * thereby removing any functionality that is only available to the owner.
407      */
408     function renounceOwnership() public virtual onlyOwner {
409         _transferOwnership(address(0));
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Can only be called by the current owner.
415      */
416     function transferOwnership(address newOwner) public virtual onlyOwner {
417         require(newOwner != address(0), "Ownable: new owner is the zero address");
418         _transferOwnership(newOwner);
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Internal function without access restriction.
424      */
425     function _transferOwnership(address newOwner) internal virtual {
426         address oldOwner = _owner;
427         _owner = newOwner;
428         emit OwnershipTransferred(oldOwner, newOwner);
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Address.sol
433 
434 
435 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
436 
437 pragma solidity ^0.8.1;
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      *
460      * [IMPORTANT]
461      * ====
462      * You shouldn't rely on `isContract` to protect against flash loan attacks!
463      *
464      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
465      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
466      * constructor.
467      * ====
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize/address.code.length, which returns 0
471         // for contracts in construction, since the code is only stored at the end
472         // of the constructor execution.
473 
474         return account.code.length > 0;
475     }
476 
477     /**
478      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
479      * `recipient`, forwarding all available gas and reverting on errors.
480      *
481      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
482      * of certain opcodes, possibly making contracts go over the 2300 gas limit
483      * imposed by `transfer`, making them unable to receive funds via
484      * `transfer`. {sendValue} removes this limitation.
485      *
486      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
487      *
488      * IMPORTANT: because control is transferred to `recipient`, care must be
489      * taken to not create reentrancy vulnerabilities. Consider using
490      * {ReentrancyGuard} or the
491      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
492      */
493     function sendValue(address payable recipient, uint256 amount) internal {
494         require(address(this).balance >= amount, "Address: insufficient balance");
495 
496         (bool success, ) = recipient.call{value: amount}("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 
500     /**
501      * @dev Performs a Solidity function call using a low level `call`. A
502      * plain `call` is an unsafe replacement for a function call: use this
503      * function instead.
504      *
505      * If `target` reverts with a revert reason, it is bubbled up by this
506      * function (like regular Solidity function calls).
507      *
508      * Returns the raw returned data. To convert to the expected return value,
509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
510      *
511      * Requirements:
512      *
513      * - `target` must be a contract.
514      * - calling `target` with `data` must not revert.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionCall(target, data, "Address: low-level call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
524      * `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, 0, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but also transferring `value` wei to `target`.
539      *
540      * Requirements:
541      *
542      * - the calling contract must have an ETH balance of at least `value`.
543      * - the called Solidity function must be `payable`.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(address(this).balance >= value, "Address: insufficient balance for call");
568         require(isContract(target), "Address: call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.call{value: value}(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a static call.
577      *
578      * _Available since v3.3._
579      */
580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
581         return functionStaticCall(target, data, "Address: low-level static call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.staticcall(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.4._
606      */
607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
630      * revert reason using the provided one.
631      *
632      * _Available since v4.3._
633      */
634     function verifyCallResult(
635         bool success,
636         bytes memory returndata,
637         string memory errorMessage
638     ) internal pure returns (bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645 
646                 assembly {
647                     let returndata_size := mload(returndata)
648                     revert(add(32, returndata), returndata_size)
649                 }
650             } else {
651                 revert(errorMessage);
652             }
653         }
654     }
655 }
656 
657 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
658 
659 
660 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title ERC721 token receiver interface
666  * @dev Interface for any contract that wants to support safeTransfers
667  * from ERC721 asset contracts.
668  */
669 interface IERC721Receiver {
670     /**
671      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
672      * by `operator` from `from`, this function is called.
673      *
674      * It must return its Solidity selector to confirm the token transfer.
675      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
676      *
677      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
678      */
679     function onERC721Received(
680         address operator,
681         address from,
682         uint256 tokenId,
683         bytes calldata data
684     ) external returns (bytes4);
685 }
686 
687 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Interface of the ERC165 standard, as defined in the
696  * https://eips.ethereum.org/EIPS/eip-165[EIP].
697  *
698  * Implementers can declare support of contract interfaces, which can then be
699  * queried by others ({ERC165Checker}).
700  *
701  * For an implementation, see {ERC165}.
702  */
703 interface IERC165 {
704     /**
705      * @dev Returns true if this contract implements the interface defined by
706      * `interfaceId`. See the corresponding
707      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
708      * to learn more about how these ids are created.
709      *
710      * This function call must use less than 30 000 gas.
711      */
712     function supportsInterface(bytes4 interfaceId) external view returns (bool);
713 }
714 
715 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Implementation of the {IERC165} interface.
725  *
726  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
727  * for the additional interface id that will be supported. For example:
728  *
729  * ```solidity
730  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
732  * }
733  * ```
734  *
735  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
736  */
737 abstract contract ERC165 is IERC165 {
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742         return interfaceId == type(IERC165).interfaceId;
743     }
744 }
745 
746 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
747 
748 
749 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 
754 /**
755  * @dev Required interface of an ERC721 compliant contract.
756  */
757 interface IERC721 is IERC165 {
758     /**
759      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
760      */
761     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
762 
763     /**
764      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
765      */
766     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
767 
768     /**
769      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
770      */
771     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
772 
773     /**
774      * @dev Returns the number of tokens in ``owner``'s account.
775      */
776     function balanceOf(address owner) external view returns (uint256 balance);
777 
778     /**
779      * @dev Returns the owner of the `tokenId` token.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function ownerOf(uint256 tokenId) external view returns (address owner);
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`.
789      *
790      * Requirements:
791      *
792      * - `from` cannot be the zero address.
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must exist and be owned by `from`.
795      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
796      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
797      *
798      * Emits a {Transfer} event.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes calldata data
805     ) external;
806 
807     /**
808      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
809      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
810      *
811      * Requirements:
812      *
813      * - `from` cannot be the zero address.
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must exist and be owned by `from`.
816      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
817      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) external;
826 
827     /**
828      * @dev Transfers `tokenId` token from `from` to `to`.
829      *
830      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
838      *
839      * Emits a {Transfer} event.
840      */
841     function transferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) external;
846 
847     /**
848      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
849      * The approval is cleared when the token is transferred.
850      *
851      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
852      *
853      * Requirements:
854      *
855      * - The caller must own the token or be an approved operator.
856      * - `tokenId` must exist.
857      *
858      * Emits an {Approval} event.
859      */
860     function approve(address to, uint256 tokenId) external;
861 
862     /**
863      * @dev Approve or remove `operator` as an operator for the caller.
864      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
865      *
866      * Requirements:
867      *
868      * - The `operator` cannot be the caller.
869      *
870      * Emits an {ApprovalForAll} event.
871      */
872     function setApprovalForAll(address operator, bool _approved) external;
873 
874     /**
875      * @dev Returns the account approved for `tokenId` token.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      */
881     function getApproved(uint256 tokenId) external view returns (address operator);
882 
883     /**
884      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
885      *
886      * See {setApprovalForAll}
887      */
888     function isApprovedForAll(address owner, address operator) external view returns (bool);
889 }
890 
891 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
892 
893 
894 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
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
913     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
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
925 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
932  * @dev See https://eips.ethereum.org/EIPS/eip-721
933  */
934 interface IERC721Metadata is IERC721 {
935     /**
936      * @dev Returns the token collection name.
937      */
938     function name() external view returns (string memory);
939 
940     /**
941      * @dev Returns the token collection symbol.
942      */
943     function symbol() external view returns (string memory);
944 
945     /**
946      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
947      */
948     function tokenURI(uint256 tokenId) external view returns (string memory);
949 }
950 
951 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
952 
953 
954 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 
960 
961 
962 
963 
964 
965 /**
966  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
967  * the Metadata extension, but not including the Enumerable extension, which is available separately as
968  * {ERC721Enumerable}.
969  */
970 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
971     using Address for address;
972     using Strings for uint256;
973 
974     // Token name
975     string private _name;
976 
977     // Token symbol
978     string private _symbol;
979 
980     // Mapping from token ID to owner address
981     mapping(uint256 => address) private _owners;
982 
983     // Mapping owner address to token count
984     mapping(address => uint256) private _balances;
985 
986     // Mapping from token ID to approved address
987     mapping(uint256 => address) private _tokenApprovals;
988 
989     // Mapping from owner to operator approvals
990     mapping(address => mapping(address => bool)) private _operatorApprovals;
991 
992     /**
993      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
994      */
995     constructor(string memory name_, string memory symbol_) {
996         _name = name_;
997         _symbol = symbol_;
998     }
999 
1000     /**
1001      * @dev See {IERC165-supportsInterface}.
1002      */
1003     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1004         return
1005             interfaceId == type(IERC721).interfaceId ||
1006             interfaceId == type(IERC721Metadata).interfaceId ||
1007             super.supportsInterface(interfaceId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-balanceOf}.
1012      */
1013     function balanceOf(address owner) public view virtual override returns (uint256) {
1014         require(owner != address(0), "ERC721: balance query for the zero address");
1015         return _balances[owner];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-ownerOf}.
1020      */
1021     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1022         address owner = _owners[tokenId];
1023         require(owner != address(0), "ERC721: owner query for nonexistent token");
1024         return owner;
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Metadata-name}.
1029      */
1030     function name() public view virtual override returns (string memory) {
1031         return _name;
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Metadata-symbol}.
1036      */
1037     function symbol() public view virtual override returns (string memory) {
1038         return _symbol;
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Metadata-tokenURI}.
1043      */
1044     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1045         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1046 
1047         string memory baseURI = _baseURI();
1048         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1049     }
1050 
1051     /**
1052      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1053      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1054      * by default, can be overridden in child contracts.
1055      */
1056     function _baseURI() internal view virtual returns (string memory) {
1057         return "";
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-approve}.
1062      */
1063     function approve(address to, uint256 tokenId) public virtual override {
1064         address owner = ERC721.ownerOf(tokenId);
1065         require(to != owner, "ERC721: approval to current owner");
1066 
1067         require(
1068             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1069             "ERC721: approve caller is not owner nor approved for all"
1070         );
1071 
1072         _approve(to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-getApproved}.
1077      */
1078     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1079         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1080 
1081         return _tokenApprovals[tokenId];
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-setApprovalForAll}.
1086      */
1087     function setApprovalForAll(address operator, bool approved) public virtual override {
1088         _setApprovalForAll(_msgSender(), operator, approved);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-isApprovedForAll}.
1093      */
1094     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1095         return _operatorApprovals[owner][operator];
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-transferFrom}.
1100      */
1101     function transferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) public virtual override {
1106         //solhint-disable-next-line max-line-length
1107         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1108 
1109         _transfer(from, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-safeTransferFrom}.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId
1119     ) public virtual override {
1120         safeTransferFrom(from, to, tokenId, "");
1121     }
1122 
1123     /**
1124      * @dev See {IERC721-safeTransferFrom}.
1125      */
1126     function safeTransferFrom(
1127         address from,
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) public virtual override {
1132         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1133         _safeTransfer(from, to, tokenId, _data);
1134     }
1135 
1136     /**
1137      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1138      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1139      *
1140      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1141      *
1142      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1143      * implement alternative mechanisms to perform token transfer, such as signature-based.
1144      *
1145      * Requirements:
1146      *
1147      * - `from` cannot be the zero address.
1148      * - `to` cannot be the zero address.
1149      * - `tokenId` token must exist and be owned by `from`.
1150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _safeTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId,
1158         bytes memory _data
1159     ) internal virtual {
1160         _transfer(from, to, tokenId);
1161         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1162     }
1163 
1164     /**
1165      * @dev Returns whether `tokenId` exists.
1166      *
1167      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1168      *
1169      * Tokens start existing when they are minted (`_mint`),
1170      * and stop existing when they are burned (`_burn`).
1171      */
1172     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1173         return _owners[tokenId] != address(0);
1174     }
1175 
1176     /**
1177      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1178      *
1179      * Requirements:
1180      *
1181      * - `tokenId` must exist.
1182      */
1183     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1184         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1185         address owner = ERC721.ownerOf(tokenId);
1186         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1187     }
1188 
1189     /**
1190      * @dev Safely mints `tokenId` and transfers it to `to`.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must not exist.
1195      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _safeMint(address to, uint256 tokenId) internal virtual {
1200         _safeMint(to, tokenId, "");
1201     }
1202 
1203     /**
1204      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1205      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1206      */
1207     function _safeMint(
1208         address to,
1209         uint256 tokenId,
1210         bytes memory _data
1211     ) internal virtual {
1212         _mint(to, tokenId);
1213         require(
1214             _checkOnERC721Received(address(0), to, tokenId, _data),
1215             "ERC721: transfer to non ERC721Receiver implementer"
1216         );
1217     }
1218 
1219     /**
1220      * @dev Mints `tokenId` and transfers it to `to`.
1221      *
1222      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must not exist.
1227      * - `to` cannot be the zero address.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _mint(address to, uint256 tokenId) internal virtual {
1232         require(to != address(0), "ERC721: mint to the zero address");
1233         require(!_exists(tokenId), "ERC721: token already minted");
1234 
1235         _beforeTokenTransfer(address(0), to, tokenId);
1236 
1237         _balances[to] += 1;
1238         _owners[tokenId] = to;
1239 
1240         emit Transfer(address(0), to, tokenId);
1241 
1242         _afterTokenTransfer(address(0), to, tokenId);
1243     }
1244 
1245     /**
1246      * @dev Destroys `tokenId`.
1247      * The approval is cleared when the token is burned.
1248      *
1249      * Requirements:
1250      *
1251      * - `tokenId` must exist.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _burn(uint256 tokenId) internal virtual {
1256         address owner = ERC721.ownerOf(tokenId);
1257 
1258         _beforeTokenTransfer(owner, address(0), tokenId);
1259 
1260         // Clear approvals
1261         _approve(address(0), tokenId);
1262 
1263         _balances[owner] -= 1;
1264         delete _owners[tokenId];
1265 
1266         emit Transfer(owner, address(0), tokenId);
1267 
1268         _afterTokenTransfer(owner, address(0), tokenId);
1269     }
1270 
1271     /**
1272      * @dev Transfers `tokenId` from `from` to `to`.
1273      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1274      *
1275      * Requirements:
1276      *
1277      * - `to` cannot be the zero address.
1278      * - `tokenId` token must be owned by `from`.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _transfer(
1283         address from,
1284         address to,
1285         uint256 tokenId
1286     ) internal virtual {
1287         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1288         require(to != address(0), "ERC721: transfer to the zero address");
1289 
1290         _beforeTokenTransfer(from, to, tokenId);
1291 
1292         // Clear approvals from the previous owner
1293         _approve(address(0), tokenId);
1294 
1295         _balances[from] -= 1;
1296         _balances[to] += 1;
1297         _owners[tokenId] = to;
1298 
1299         emit Transfer(from, to, tokenId);
1300 
1301         _afterTokenTransfer(from, to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev Approve `to` to operate on `tokenId`
1306      *
1307      * Emits a {Approval} event.
1308      */
1309     function _approve(address to, uint256 tokenId) internal virtual {
1310         _tokenApprovals[tokenId] = to;
1311         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1312     }
1313 
1314     /**
1315      * @dev Approve `operator` to operate on all of `owner` tokens
1316      *
1317      * Emits a {ApprovalForAll} event.
1318      */
1319     function _setApprovalForAll(
1320         address owner,
1321         address operator,
1322         bool approved
1323     ) internal virtual {
1324         require(owner != operator, "ERC721: approve to caller");
1325         _operatorApprovals[owner][operator] = approved;
1326         emit ApprovalForAll(owner, operator, approved);
1327     }
1328 
1329     /**
1330      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1331      * The call is not executed if the target address is not a contract.
1332      *
1333      * @param from address representing the previous owner of the given token ID
1334      * @param to target address that will receive the tokens
1335      * @param tokenId uint256 ID of the token to be transferred
1336      * @param _data bytes optional data to send along with the call
1337      * @return bool whether the call correctly returned the expected magic value
1338      */
1339     function _checkOnERC721Received(
1340         address from,
1341         address to,
1342         uint256 tokenId,
1343         bytes memory _data
1344     ) private returns (bool) {
1345         if (to.isContract()) {
1346             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1347                 return retval == IERC721Receiver.onERC721Received.selector;
1348             } catch (bytes memory reason) {
1349                 if (reason.length == 0) {
1350                     revert("ERC721: transfer to non ERC721Receiver implementer");
1351                 } else {
1352                     assembly {
1353                         revert(add(32, reason), mload(reason))
1354                     }
1355                 }
1356             }
1357         } else {
1358             return true;
1359         }
1360     }
1361 
1362     /**
1363      * @dev Hook that is called before any token transfer. This includes minting
1364      * and burning.
1365      *
1366      * Calling conditions:
1367      *
1368      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1369      * transferred to `to`.
1370      * - When `from` is zero, `tokenId` will be minted for `to`.
1371      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1372      * - `from` and `to` are never both zero.
1373      *
1374      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1375      */
1376     function _beforeTokenTransfer(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) internal virtual {}
1381 
1382     /**
1383      * @dev Hook that is called after any transfer of tokens. This includes
1384      * minting and burning.
1385      *
1386      * Calling conditions:
1387      *
1388      * - when `from` and `to` are both non-zero.
1389      * - `from` and `to` are never both zero.
1390      *
1391      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1392      */
1393     function _afterTokenTransfer(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) internal virtual {}
1398 }
1399 
1400 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1401 
1402 
1403 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1404 
1405 pragma solidity ^0.8.0;
1406 
1407 
1408 
1409 /**
1410  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1411  * enumerability of all the token ids in the contract as well as all token ids owned by each
1412  * account.
1413  */
1414 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1415     // Mapping from owner to list of owned token IDs
1416     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1417 
1418     // Mapping from token ID to index of the owner tokens list
1419     mapping(uint256 => uint256) private _ownedTokensIndex;
1420 
1421     // Array with all token ids, used for enumeration
1422     uint256[] private _allTokens;
1423 
1424     // Mapping from token id to position in the allTokens array
1425     mapping(uint256 => uint256) private _allTokensIndex;
1426 
1427     /**
1428      * @dev See {IERC165-supportsInterface}.
1429      */
1430     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1431         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1432     }
1433 
1434     /**
1435      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1436      */
1437     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1438         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1439         return _ownedTokens[owner][index];
1440     }
1441 
1442     /**
1443      * @dev See {IERC721Enumerable-totalSupply}.
1444      */
1445     function totalSupply() public view virtual override returns (uint256) {
1446         return _allTokens.length;
1447     }
1448 
1449     /**
1450      * @dev See {IERC721Enumerable-tokenByIndex}.
1451      */
1452     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1453         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1454         return _allTokens[index];
1455     }
1456 
1457     /**
1458      * @dev Hook that is called before any token transfer. This includes minting
1459      * and burning.
1460      *
1461      * Calling conditions:
1462      *
1463      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1464      * transferred to `to`.
1465      * - When `from` is zero, `tokenId` will be minted for `to`.
1466      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1467      * - `from` cannot be the zero address.
1468      * - `to` cannot be the zero address.
1469      *
1470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1471      */
1472     function _beforeTokenTransfer(
1473         address from,
1474         address to,
1475         uint256 tokenId
1476     ) internal virtual override {
1477         super._beforeTokenTransfer(from, to, tokenId);
1478 
1479         if (from == address(0)) {
1480             _addTokenToAllTokensEnumeration(tokenId);
1481         } else if (from != to) {
1482             _removeTokenFromOwnerEnumeration(from, tokenId);
1483         }
1484         if (to == address(0)) {
1485             _removeTokenFromAllTokensEnumeration(tokenId);
1486         } else if (to != from) {
1487             _addTokenToOwnerEnumeration(to, tokenId);
1488         }
1489     }
1490 
1491     /**
1492      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1493      * @param to address representing the new owner of the given token ID
1494      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1495      */
1496     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1497         uint256 length = ERC721.balanceOf(to);
1498         _ownedTokens[to][length] = tokenId;
1499         _ownedTokensIndex[tokenId] = length;
1500     }
1501 
1502     /**
1503      * @dev Private function to add a token to this extension's token tracking data structures.
1504      * @param tokenId uint256 ID of the token to be added to the tokens list
1505      */
1506     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1507         _allTokensIndex[tokenId] = _allTokens.length;
1508         _allTokens.push(tokenId);
1509     }
1510 
1511     /**
1512      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1513      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1514      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1515      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1516      * @param from address representing the previous owner of the given token ID
1517      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1518      */
1519     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1520         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1521         // then delete the last slot (swap and pop).
1522 
1523         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1524         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1525 
1526         // When the token to delete is the last token, the swap operation is unnecessary
1527         if (tokenIndex != lastTokenIndex) {
1528             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1529 
1530             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1531             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1532         }
1533 
1534         // This also deletes the contents at the last position of the array
1535         delete _ownedTokensIndex[tokenId];
1536         delete _ownedTokens[from][lastTokenIndex];
1537     }
1538 
1539     /**
1540      * @dev Private function to remove a token from this extension's token tracking data structures.
1541      * This has O(1) time complexity, but alters the order of the _allTokens array.
1542      * @param tokenId uint256 ID of the token to be removed from the tokens list
1543      */
1544     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1545         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1546         // then delete the last slot (swap and pop).
1547 
1548         uint256 lastTokenIndex = _allTokens.length - 1;
1549         uint256 tokenIndex = _allTokensIndex[tokenId];
1550 
1551         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1552         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1553         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1554         uint256 lastTokenId = _allTokens[lastTokenIndex];
1555 
1556         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1557         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1558 
1559         // This also deletes the contents at the last position of the array
1560         delete _allTokensIndex[tokenId];
1561         _allTokens.pop();
1562     }
1563 }
1564 
1565 // File: contracts/MadApes.sol
1566 
1567 
1568 
1569 pragma solidity 0.8.7;
1570 
1571 
1572 
1573 
1574 
1575 
1576 contract MadApes is ERC721Enumerable, Ownable {
1577 
1578     using SafeMath for uint256;
1579     
1580     string public baseTokenURI;
1581 
1582     bool public holderMintActive;
1583 
1584     uint256 public constant RESERVED_FOR_AA = 1778;
1585     uint256 public price = 0 ether;
1586     uint256 public saleState = 0;  // 0 = paused, 1 = live
1587     uint256 public max_apes = 5555;
1588     uint256 public nonreserved_minted_tokens = 0;
1589     uint256 public reserved_amount = 500;
1590     uint256 public purchase_limit = 5;
1591 
1592     // withdraw address
1593     address public a1 = 0x5fcBB68EA092afcEF6e52B1a417F1867cE70d090;// Mad Apes Deployer
1594 
1595     //AA contract address
1596     address public aa_contract = 0x92b1289Ee1c70cB2e51fA63A448cEeF2734ec6FF; //main net - 0x92b1289Ee1c70cB2e51fA63A448cEeF2734ec6FF
1597 
1598     //MadApesArmory contract address
1599     address public maa_contract = 0xb2C939Ba03C8C533727F955df53A2409Bc3268B4;
1600 
1601     //constructor
1602     constructor(string memory _baseTokenURI) ERC721("MadApes","MAD") {
1603         baseTokenURI = _baseTokenURI;
1604     }    
1605 
1606     //mint functions
1607     function mintApes(uint256 num) public payable {
1608         require( msg.value >= price * num,  "Ether sent is insufficient");
1609         _mintApes(num);
1610     }
1611 
1612     //private function
1613     function _mintApes(uint256 num) private {
1614         uint256 mintedTokens = nonreserved_minted_tokens;
1615         require( saleState > 0,             "Main sale is not active" );
1616         require( num <= purchase_limit,     "Requested mints exceed maximum" );
1617         require((nonreserved_minted_tokens + num) <= (max_apes - RESERVED_FOR_AA - reserved_amount), "Requested mints exceed remaining supply");
1618         
1619         nonreserved_minted_tokens = nonreserved_minted_tokens + num;
1620         for(uint256 i; i < num; i++){
1621             _safeMint( msg.sender, mintedTokens + i + RESERVED_FOR_AA);
1622         }
1623     }
1624 
1625     function upgradeToken(uint256 _tokenId) public {
1626         uint256 level;
1627         //check that they own token
1628         require( msg.sender  == ownerOf(_tokenId), "You must own the Mad Ape to upgrade it");
1629         
1630         //determine token level
1631         level = (_tokenId / max_apes) + 1;
1632         require(level <= 3, "Your token is fully upgraded");
1633 
1634          //ensure they own the oil to get to next level
1635         if (level == 1 && _tokenId >= RESERVED_FOR_AA ) {
1636             require( balanceOfArmoryOwner(msg.sender,0) >= 2, "You must own at least two consumables of this type");
1637         } else if (level == 2) {
1638             require( balanceOfArmoryOwner(msg.sender,0) >= 4, "You must own at least four consumables of this type");
1639         } else if (level == 3) {
1640             require( balanceOfArmoryOwner(msg.sender,0) >= 6, "You must own at least six consumables of this type");
1641         }
1642 
1643          //ensure corresponding token in appopriate range doesn't already exist
1644         require(!_exists(_tokenId + max_apes), "This token has already been upgraded");
1645 
1646         // allow free level 1 upgrade for AA holders
1647         if ( !(level == 1 && _tokenId < RESERVED_FOR_AA)) { 
1648             //burn oil to get next level
1649             burnOilForAddress(0,msg.sender,level*2);
1650         }
1651 
1652         //mint corresponding token in appropriate range
1653         _safeMint(msg.sender, _tokenId + max_apes);  
1654     }
1655 
1656     //free mint for AA holders
1657     function holderMint(uint256 _tokenId) public {
1658         require( holderMintActive, "Mad Apes grant period has ended");
1659         //check sender owns Acid Apes token
1660         require(msg.sender == ownerOfAcidApes(_tokenId), "Must own corresponding Acid Apes token for holder mint");
1661         //confirm corresponding mad token doesn't exist
1662         require(!_exists(_tokenId), "Mad Ape token already exists");
1663         
1664         _safeMint( msg.sender, _tokenId);
1665     }
1666 
1667     //mint all available claims for AA holders
1668     function holderMintAll() public {
1669 
1670     //get array for all acid apes tokens owned
1671     //iterate over the list
1672     //check if corresponding mad token doesn't exist
1673     //increment supply and mint mad ape 
1674 
1675         uint256[] memory ownedTokens = walletOfAAOwner(msg.sender);
1676 
1677         for(uint256 i; i < ownedTokens.length; i++)
1678         {
1679             uint256 _curToken = ownedTokens[i];
1680             //token exist in Mad Apes? If yes, continue. If no, then call holderMint
1681             if( _exists(_curToken) )
1682             {
1683                 continue;
1684             }
1685             else
1686             {     
1687                 holderMint(_curToken);
1688             }
1689         }
1690     }
1691 
1692     //views
1693 
1694     //override so openzeppelin tokenURI() can utilize the baseTokenURI we set
1695     function _baseURI() internal view virtual override returns (string memory) {
1696         return baseTokenURI;
1697     }
1698 
1699     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1700         uint256 tokenCount = balanceOf(_owner);
1701 
1702         uint256[] memory tokensId = new uint256[](tokenCount);
1703         for(uint256 i; i < tokenCount; i++){
1704             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1705         }
1706         return tokensId;
1707     }
1708 
1709     function walletOfAAOwner(address _owner) public view returns (uint256[] memory) {
1710         IAcidApesToken acidApes = IAcidApesToken(aa_contract);
1711         return acidApes.walletOfOwner(_owner);
1712     }
1713 
1714     function ownerOfAcidApes(uint256 _tokenId) public view returns (address) {
1715         IAcidApesToken acidApes = IAcidApesToken(aa_contract);
1716         return acidApes.ownerOf(_tokenId);
1717     }
1718 
1719     function balanceOfArmoryOwner(address _owner, uint256 _id) public view returns (uint256) {
1720         IMadApesArmoryToken maa = IMadApesArmoryToken(maa_contract);
1721         return maa.balanceOf(_owner,_id);
1722     }
1723 
1724     function burnOilForAddress(uint256 _typeId, address _burnTokenAddress, uint256 quantity) private {
1725         IMadApesArmoryToken maa = IMadApesArmoryToken(maa_contract);
1726         maa.burnOilForAddress(_typeId, _burnTokenAddress, quantity);
1727     }
1728 
1729     function exists(uint256 _tokenId) public view returns (bool) {
1730         return _exists(_tokenId);
1731     }
1732 
1733 
1734     //setters
1735 
1736     function setBaseURI(string memory _baseTokenURI) public onlyOwner {
1737         baseTokenURI = _baseTokenURI;
1738     }
1739 
1740     function setHolderMintActive(bool _holderMintActive) public onlyOwner {
1741         holderMintActive = _holderMintActive;
1742     }
1743 
1744     function setPrice(uint256 _newPrice) public onlyOwner() {
1745         price = _newPrice;
1746     }
1747 
1748     function setMaxApes(uint256 _newMax) public onlyOwner{
1749         max_apes = _newMax;
1750     }
1751             
1752     // 0 = paused, 1 = live 
1753     function setSaleState(uint256 _saleState) public onlyOwner {
1754         saleState = _saleState;
1755     }
1756 
1757     function setPurchaseLimit(uint256 _newLimit) public onlyOwner{
1758         purchase_limit = _newLimit;
1759     }
1760 
1761     function setWithdrawAddress(address _a) public onlyOwner {
1762         a1 = _a;
1763     }
1764 
1765     function setAAContractAddress(address _a) public onlyOwner {
1766         aa_contract = _a;
1767     }
1768 
1769     function setMAAContractAddress(address _a) public onlyOwner {
1770         maa_contract = _a;
1771     }
1772 
1773     function setNonReservedMintedTokens(uint256 _reservedTokens) public onlyOwner {
1774         nonreserved_minted_tokens = _reservedTokens;
1775     }
1776 
1777     function setReservedAmount(uint256 _reservedAmount) public onlyOwner {
1778         reserved_amount = _reservedAmount;
1779     }
1780 
1781     //utils
1782     
1783     function giveAway(address _to, uint256 _count) external onlyOwner() {
1784         uint256 mintedTokens = nonreserved_minted_tokens;
1785         require((nonreserved_minted_tokens + _count) <= (max_apes - RESERVED_FOR_AA), "Requested mints exceed remaining supply");
1786         
1787         nonreserved_minted_tokens = nonreserved_minted_tokens + _count;
1788         for(uint256 i; i < _count; i++){
1789             _safeMint( _to, mintedTokens + i + RESERVED_FOR_AA);
1790         }
1791     }
1792 
1793     function withdrawBalance() public payable onlyOwner {
1794         uint256 _payment = address(this).balance;
1795         
1796         (bool success, ) = payable(a1).call{value: _payment}("");
1797         require(success, "Transfer failed to a1.");
1798 
1799     }
1800 }