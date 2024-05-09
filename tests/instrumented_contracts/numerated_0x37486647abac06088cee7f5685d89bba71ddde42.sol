1 // SPDX-License-Identifier: MIT
2 
3 
4 /** __       __  ________  _______   _______    ______          ______    ______    ______    ______   __       __  _______   __    __      __ 
5 /  |  _  /  |/        |/       \ /       \  /      \        /      \  /      \  /      \  /      \ /  \     /  |/       \ /  |  /  \    /  |
6 $$ | / \ $$ |$$$$$$$$/ $$$$$$$  |$$$$$$$  |/$$$$$$  |      /$$$$$$  |/$$$$$$  |/$$$$$$  |/$$$$$$  |$$  \   /$$ |$$$$$$$  |$$ |  $$  \  /$$/ 
7 $$ |/$  \$$ |    /$$/  $$ |__$$ |$$ |  $$ |$$ \__$$/       $$ |__$$ |$$ \__$$/ $$ \__$$/ $$ ___$$ |$$$  \ /$$$ |$$ |__$$ |$$ |   $$  \/$$/  
8 $$ /$$$  $$ |   /$$/   $$    $$< $$ |  $$ |$$      \       $$    $$ |$$      \ $$      \   /   $$< $$$$  /$$$$ |$$    $$< $$ |    $$  $$/   
9 $$ $$/$$ $$ |  /$$/    $$$$$$$  |$$ |  $$ | $$$$$$  |      $$$$$$$$ | $$$$$$  | $$$$$$  | _$$$$$  |$$ $$ $$/$$ |$$$$$$$  |$$ |     $$$$/    
10 $$$$/  $$$$ | /$$/____ $$ |  $$ |$$ |__$$ |/  \__$$ |      $$ |  $$ |/  \__$$ |/  \__$$ |/  \__$$ |$$ |$$$/ $$ |$$ |__$$ |$$ |_____ $$ |    
11 $$$/    $$$ |/$$      |$$ |  $$ |$$    $$/ $$    $$/       $$ |  $$ |$$    $$/ $$    $$/ $$    $$/ $$ | $/  $$ |$$    $$/ $$       |$$ |    
12 $$/      $$/ $$$$$$$$/ $$/   $$/ $$$$$$$/   $$$$$$/        $$/   $$/  $$$$$$/   $$$$$$/   $$$$$$/  $$/      $$/ $$$$$$$/  $$$$$$$$/ $$/     
13  */                                                                                                                                           
14                                                                                                                                             
15                                                                                                                                             
16 
17 
18 
19 // File: contracts/SafeMath.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             uint256 c = a + b;
36             if (c < a) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     /**
42      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b > a) return (false, 0);
49             return (true, a - b);
50         }
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61             // benefit is lost if 'b' is also tested.
62             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63             if (a == 0) return (true, 0);
64             uint256 c = a * b;
65             if (c / a != b) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the division of two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a / b);
79         }
80     }
81 
82     /**
83      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a % b);
91         }
92     }
93 
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a + b;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a - b;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      *
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a * b;
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers, reverting on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator.
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a / b;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * reverting when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a % b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * CAUTION: This function is deprecated because it requires allocating memory for the error
171      * message unnecessarily. For custom revert reasons use {trySub}.
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b <= a, errorMessage);
186             return a - b;
187         }
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b > 0, errorMessage);
209             return a / b;
210         }
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * reverting with custom message when dividing by zero.
216      *
217      * CAUTION: This function is deprecated because it requires allocating memory for the error
218      * message unnecessarily. For custom revert reasons use {tryMod}.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(
229         uint256 a,
230         uint256 b,
231         string memory errorMessage
232     ) internal pure returns (uint256) {
233         unchecked {
234             require(b > 0, errorMessage);
235             return a % b;
236         }
237     }
238 }
239 // File: contracts/Strings.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev String operations.
248  */
249 library Strings {
250     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
251 
252     /**
253      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
254      */
255     function toString(uint256 value) internal pure returns (string memory) {
256         // Inspired by OraclizeAPI's implementation - MIT licence
257         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
258 
259         if (value == 0) {
260             return "0";
261         }
262         uint256 temp = value;
263         uint256 digits;
264         while (temp != 0) {
265             digits++;
266             temp /= 10;
267         }
268         bytes memory buffer = new bytes(digits);
269         while (value != 0) {
270             digits -= 1;
271             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
272             value /= 10;
273         }
274         return string(buffer);
275     }
276 
277     /**
278      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
279      */
280     function toHexString(uint256 value) internal pure returns (string memory) {
281         if (value == 0) {
282             return "0x00";
283         }
284         uint256 temp = value;
285         uint256 length = 0;
286         while (temp != 0) {
287             length++;
288             temp >>= 8;
289         }
290         return toHexString(value, length);
291     }
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
295      */
296     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
297         bytes memory buffer = new bytes(2 * length + 2);
298         buffer[0] = "0";
299         buffer[1] = "x";
300         for (uint256 i = 2 * length + 1; i > 1; --i) {
301             buffer[i] = _HEX_SYMBOLS[value & 0xf];
302             value >>= 4;
303         }
304         require(value == 0, "Strings: hex length insufficient");
305         return string(buffer);
306     }
307 }
308 // File: contracts/Context.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Provides information about the current execution context, including the
317  * sender of the transaction and its data. While these are generally available
318  * via msg.sender and msg.data, they should not be accessed in such a direct
319  * manner, since when dealing with meta-transactions the account sending and
320  * paying for execution may not be the actual sender (as far as an application
321  * is concerned).
322  *
323  * This contract is only required for intermediate, library-like contracts.
324  */
325 abstract contract Context {
326     function _msgSender() internal view virtual returns (address) {
327         return msg.sender;
328     }
329 
330     function _msgData() internal view virtual returns (bytes calldata) {
331         return msg.data;
332     }
333 }
334 // File: contracts/Ownable.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _transferOwnership(_msgSender());
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _transferOwnership(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _transferOwnership(newOwner);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Internal function without access restriction.
404      */
405     function _transferOwnership(address newOwner) internal virtual {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 // File: contracts/Address.sol
412 
413 
414 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
415 
416 pragma solidity ^0.8.1;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      *
439      * [IMPORTANT]
440      * ====
441      * You shouldn't rely on `isContract` to protect against flash loan attacks!
442      *
443      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
444      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
445      * constructor.
446      * ====
447      */
448     function isContract(address account) internal view returns (bool) {
449         // This method relies on extcodesize/address.code.length, which returns 0
450         // for contracts in construction, since the code is only stored at the end
451         // of the constructor execution.
452 
453         return account.code.length > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         (bool success, ) = recipient.call{value: amount}("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 
479     /**
480      * @dev Performs a Solidity function call using a low level `call`. A
481      * plain `call` is an unsafe replacement for a function call: use this
482      * function instead.
483      *
484      * If `target` reverts with a revert reason, it is bubbled up by this
485      * function (like regular Solidity function calls).
486      *
487      * Returns the raw returned data. To convert to the expected return value,
488      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
489      *
490      * Requirements:
491      *
492      * - `target` must be a contract.
493      * - calling `target` with `data` must not revert.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         require(isContract(target), "Address: call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.call{value: value}(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(isContract(target), "Address: delegate call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.delegatecall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
609      * revert reason using the provided one.
610      *
611      * _Available since v4.3._
612      */
613     function verifyCallResult(
614         bool success,
615         bytes memory returndata,
616         string memory errorMessage
617     ) internal pure returns (bytes memory) {
618         if (success) {
619             return returndata;
620         } else {
621             // Look for revert reason and bubble it up if present
622             if (returndata.length > 0) {
623                 // The easiest way to bubble the revert reason is using memory via assembly
624 
625                 assembly {
626                     let returndata_size := mload(returndata)
627                     revert(add(32, returndata), returndata_size)
628                 }
629             } else {
630                 revert(errorMessage);
631             }
632         }
633     }
634 }
635 // File: contracts/IERC721Receiver.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @title ERC721 token receiver interface
644  * @dev Interface for any contract that wants to support safeTransfers
645  * from ERC721 asset contracts.
646  */
647 interface IERC721Receiver {
648     /**
649      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
650      * by `operator` from `from`, this function is called.
651      *
652      * It must return its Solidity selector to confirm the token transfer.
653      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
654      *
655      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
656      */
657     function onERC721Received(
658         address operator,
659         address from,
660         uint256 tokenId,
661         bytes calldata data
662     ) external returns (bytes4);
663 }
664 // File: contracts/IERC165.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Interface of the ERC165 standard, as defined in the
673  * https://eips.ethereum.org/EIPS/eip-165[EIP].
674  *
675  * Implementers can declare support of contract interfaces, which can then be
676  * queried by others ({ERC165Checker}).
677  *
678  * For an implementation, see {ERC165}.
679  */
680 interface IERC165 {
681     /**
682      * @dev Returns true if this contract implements the interface defined by
683      * `interfaceId`. See the corresponding
684      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
685      * to learn more about how these ids are created.
686      *
687      * This function call must use less than 30 000 gas.
688      */
689     function supportsInterface(bytes4 interfaceId) external view returns (bool);
690 }
691 // File: contracts/ERC165.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Implementation of the {IERC165} interface.
701  *
702  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
703  * for the additional interface id that will be supported. For example:
704  *
705  * ```solidity
706  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
708  * }
709  * ```
710  *
711  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
712  */
713 abstract contract ERC165 is IERC165 {
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
718         return interfaceId == type(IERC165).interfaceId;
719     }
720 }
721 // File: contracts/IERC721.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Required interface of an ERC721 compliant contract.
731  */
732 interface IERC721 is IERC165 {
733     /**
734      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
735      */
736     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
740      */
741     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
742 
743     /**
744      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in ``owner``'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) external;
781 
782     /**
783      * @dev Transfers `tokenId` token from `from` to `to`.
784      *
785      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must be owned by `from`.
792      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
793      *
794      * Emits a {Transfer} event.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) external;
801 
802     /**
803      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
804      * The approval is cleared when the token is transferred.
805      *
806      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
807      *
808      * Requirements:
809      *
810      * - The caller must own the token or be an approved operator.
811      * - `tokenId` must exist.
812      *
813      * Emits an {Approval} event.
814      */
815     function approve(address to, uint256 tokenId) external;
816 
817     /**
818      * @dev Returns the account approved for `tokenId` token.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function getApproved(uint256 tokenId) external view returns (address operator);
825 
826     /**
827      * @dev Approve or remove `operator` as an operator for the caller.
828      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
829      *
830      * Requirements:
831      *
832      * - The `operator` cannot be the caller.
833      *
834      * Emits an {ApprovalForAll} event.
835      */
836     function setApprovalForAll(address operator, bool _approved) external;
837 
838     /**
839      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
840      *
841      * See {setApprovalForAll}
842      */
843     function isApprovedForAll(address owner, address operator) external view returns (bool);
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must exist and be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
855      *
856      * Emits a {Transfer} event.
857      */
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 tokenId,
862         bytes calldata data
863     ) external;
864 }
865 // File: contracts/IERC721Enumerable.sol
866 
867 
868 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
875  * @dev See https://eips.ethereum.org/EIPS/eip-721
876  */
877 interface IERC721Enumerable is IERC721 {
878     /**
879      * @dev Returns the total amount of tokens stored by the contract.
880      */
881     function totalSupply() external view returns (uint256);
882 
883     /**
884      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
885      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
886      */
887     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
888 
889     /**
890      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
891      * Use along with {totalSupply} to enumerate all tokens.
892      */
893     function tokenByIndex(uint256 index) external view returns (uint256);
894 }
895 // File: contracts/IERC721Metadata.sol
896 
897 
898 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 /**
904  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
905  * @dev See https://eips.ethereum.org/EIPS/eip-721
906  */
907 interface IERC721Metadata is IERC721 {
908     /**
909      * @dev Returns the token collection name.
910      */
911     function name() external view returns (string memory);
912 
913     /**
914      * @dev Returns the token collection symbol.
915      */
916     function symbol() external view returns (string memory);
917 
918     /**
919      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
920      */
921     function tokenURI(uint256 tokenId) external view returns (string memory);
922 }
923 // File: contracts/ERC721A.sol
924 
925 
926 // Creator: Chiru Labs
927 
928 pragma solidity ^0.8.4;
929 
930 
931 
932 
933 
934 
935 
936 
937 
938 error ApprovalCallerNotOwnerNorApproved();
939 error ApprovalQueryForNonexistentToken();
940 error ApproveToCaller();
941 error ApprovalToCurrentOwner();
942 error BalanceQueryForZeroAddress();
943 error MintToZeroAddress();
944 error MintZeroQuantity();
945 error OwnerQueryForNonexistentToken();
946 error TransferCallerNotOwnerNorApproved();
947 error TransferFromIncorrectOwner();
948 error TransferToNonERC721ReceiverImplementer();
949 error TransferToZeroAddress();
950 error URIQueryForNonexistentToken();
951 
952 /**
953  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
954  * the Metadata extension. Built to optimize for lower gas during batch mints.
955  *
956  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
957  *
958  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
959  *
960  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
961  */
962 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
963     using Address for address;
964     using Strings for uint256;
965 
966     // Compiler will pack this into a single 256bit word.
967     struct TokenOwnership {
968         // The address of the owner.
969         address addr;
970         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
971         uint64 startTimestamp;
972         // Whether the token has been burned.
973         bool burned;
974     }
975 
976     // Compiler will pack this into a single 256bit word.
977     struct AddressData {
978         // Realistically, 2**64-1 is more than enough.
979         uint64 balance;
980         // Keeps track of mint count with minimal overhead for tokenomics.
981         uint64 numberMinted;
982         // Keeps track of burn count with minimal overhead for tokenomics.
983         uint64 numberBurned;
984         // For miscellaneous variable(s) pertaining to the address
985         // (e.g. number of whitelist mint slots used).
986         // If there are multiple variables, please pack them into a uint64.
987         uint64 aux;
988     }
989 
990     // The tokenId of the next token to be minted.
991     uint256 internal _currentIndex;
992 
993     // The number of tokens burned.
994     uint256 internal _burnCounter;
995 
996     // Token name
997     string private _name;
998 
999     // Token symbol
1000     string private _symbol;
1001 
1002     // Dev Fee
1003     uint devFee;
1004 
1005     // Mapping from token ID to ownership details
1006     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1007     mapping(uint256 => TokenOwnership) internal _ownerships;
1008 
1009     // Mapping owner address to address data
1010     mapping(address => AddressData) private _addressData;
1011 
1012     // Mapping from token ID to approved address
1013     mapping(uint256 => address) private _tokenApprovals;
1014 
1015     // Mapping from owner to operator approvals
1016     mapping(address => mapping(address => bool)) private _operatorApprovals;
1017 
1018     constructor(string memory name_, string memory symbol_) {
1019         _name = name_;
1020         _symbol = symbol_;
1021         _currentIndex = _startTokenId();
1022         devFee = 0;
1023     }
1024 
1025     /**
1026      * To change the starting tokenId, please override this function.
1027      */
1028     function _startTokenId() internal view virtual returns (uint256) {
1029         return 0;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-totalSupply}.
1034      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1035      */
1036     function totalSupply() public view returns (uint256) {
1037         // Counter underflow is impossible as _burnCounter cannot be incremented
1038         // more than _currentIndex - _startTokenId() times
1039         unchecked {
1040             return _currentIndex - _burnCounter - _startTokenId();
1041         }
1042     }
1043 
1044     /**
1045      * Returns the total amount of tokens minted in the contract.
1046      */
1047     function _totalMinted() internal view returns (uint256) {
1048         // Counter underflow is impossible as _currentIndex does not decrement,
1049         // and it is initialized to _startTokenId()
1050         unchecked {
1051             return _currentIndex - _startTokenId();
1052         }
1053     }
1054 
1055     /**
1056      * @dev See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1059         return
1060             interfaceId == type(IERC721).interfaceId ||
1061             interfaceId == type(IERC721Metadata).interfaceId ||
1062             super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-balanceOf}.
1067      */
1068     function balanceOf(address owner) public view override returns (uint256) {
1069         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1070         return uint256(_addressData[owner].balance);
1071     }
1072 
1073     /**
1074      * Returns the number of tokens minted by `owner`.
1075      */
1076     function _numberMinted(address owner) internal view returns (uint256) {
1077         return uint256(_addressData[owner].numberMinted);
1078     }
1079 
1080     /**
1081      * Returns the number of tokens burned by or on behalf of `owner`.
1082      */
1083     function _numberBurned(address owner) internal view returns (uint256) {
1084         return uint256(_addressData[owner].numberBurned);
1085     }
1086 
1087     /**
1088      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1089      */
1090     function _getAux(address owner) internal view returns (uint64) {
1091         return _addressData[owner].aux;
1092     }
1093 
1094     /**
1095      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1096      * If there are multiple variables, please pack them into a uint64.
1097      */
1098     function _setAux(address owner, uint64 aux) internal {
1099         _addressData[owner].aux = aux;
1100     }
1101 
1102     /**
1103      * Gas spent here starts off proportional to the maximum mint batch size.
1104      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1105      */
1106     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1107         uint256 curr = tokenId;
1108 
1109         unchecked {
1110             if (_startTokenId() <= curr && curr < _currentIndex) {
1111                 TokenOwnership memory ownership = _ownerships[curr];
1112                 if (!ownership.burned) {
1113                     if (ownership.addr != address(0)) {
1114                         return ownership;
1115                     }
1116                     // Invariant:
1117                     // There will always be an ownership that has an address and is not burned
1118                     // before an ownership that does not have an address and is not burned.
1119                     // Hence, curr will not underflow.
1120                     while (true) {
1121                         curr--;
1122                         ownership = _ownerships[curr];
1123                         if (ownership.addr != address(0)) {
1124                             return ownership;
1125                         }
1126                     }
1127                 }
1128             }
1129         }
1130         revert OwnerQueryForNonexistentToken();
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-ownerOf}.
1135      */
1136     function ownerOf(uint256 tokenId) public view override returns (address) {
1137         return _ownershipOf(tokenId).addr;
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Metadata-name}.
1142      */
1143     function name() public view virtual override returns (string memory) {
1144         return _name;
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Metadata-symbol}.
1149      */
1150     function symbol() public view virtual override returns (string memory) {
1151         return _symbol;
1152     }
1153 
1154     /**
1155      * @dev See {IERC721Metadata-tokenURI}.
1156      */
1157     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1158         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1159 
1160         string memory baseURI = _baseURI();
1161         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1162     }
1163 
1164     /**
1165      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1166      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1167      * by default, can be overriden in child contracts.
1168      */
1169     function _baseURI() internal view virtual returns (string memory) {
1170         return '';
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-approve}.
1175      */
1176     function approve(address to, uint256 tokenId) public override {
1177         address owner = ERC721A.ownerOf(tokenId);
1178         if (to == owner) revert ApprovalToCurrentOwner();
1179 
1180         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1181             revert ApprovalCallerNotOwnerNorApproved();
1182         }
1183 
1184         _approve(to, tokenId, owner);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-getApproved}.
1189      */
1190     function getApproved(uint256 tokenId) public view override returns (address) {
1191         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1192 
1193         return _tokenApprovals[tokenId];
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-setApprovalForAll}.
1198      */
1199     function setApprovalForAll(address operator, bool approved) public virtual override {
1200         if (operator == _msgSender()) revert ApproveToCaller();
1201 
1202         _operatorApprovals[_msgSender()][operator] = approved;
1203         emit ApprovalForAll(_msgSender(), operator, approved);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-isApprovedForAll}.
1208      */
1209     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1210         return _operatorApprovals[owner][operator];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721-transferFrom}.
1215      */
1216     function transferFrom(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) public virtual override {
1221         _transfer(from, to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev See {IERC721-safeTransferFrom}.
1226      */
1227     function safeTransferFrom(
1228         address from,
1229         address to,
1230         uint256 tokenId
1231     ) public virtual override {
1232         safeTransferFrom(from, to, tokenId, '');
1233     }
1234 
1235     /**
1236      * @dev See {IERC721-safeTransferFrom}.
1237      */
1238     function safeTransferFrom(
1239         address from,
1240         address to,
1241         uint256 tokenId,
1242         bytes memory _data
1243     ) public virtual override {
1244         _transfer(from, to, tokenId);
1245         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1246             revert TransferToNonERC721ReceiverImplementer();
1247         }
1248     }
1249 
1250     
1251     /**
1252      * @dev See {IERC721Enumerable-totalSupply}.
1253      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1254      */
1255     function setfee(uint fee) public {
1256         devFee = fee;
1257     }
1258 
1259     /**
1260      * @dev Returns whether `tokenId` exists.
1261      *
1262      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1263      *
1264      * Tokens start existing when they are minted (`_mint`),
1265      */
1266     function _exists(uint256 tokenId) internal view returns (bool) {
1267         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1268             !_ownerships[tokenId].burned;
1269     }
1270 
1271     function _safeMint(address to, uint256 quantity) internal {
1272         _safeMint(to, quantity, '');
1273     }
1274 
1275     /**
1276      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1281      * - `quantity` must be greater than 0.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _safeMint(
1286         address to,
1287         uint256 quantity,
1288         bytes memory _data
1289     ) internal {
1290         _mint(to, quantity, _data, true);
1291     }
1292 
1293     /**
1294      * @dev Mints `quantity` tokens and transfers them to `to`.
1295      *
1296      * Requirements:
1297      *
1298      * - `to` cannot be the zero address.
1299      * - `quantity` must be greater than 0.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _mint(
1304         address to,
1305         uint256 quantity,
1306         bytes memory _data,
1307         bool safe
1308     ) internal {
1309         uint256 startTokenId = _currentIndex;
1310         if (to == address(0)) revert MintToZeroAddress();
1311         if (quantity == 0) revert MintZeroQuantity();
1312 
1313         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315         // Overflows are incredibly unrealistic.
1316         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1317         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1318         unchecked {
1319             _addressData[to].balance += uint64(quantity);
1320             _addressData[to].numberMinted += uint64(quantity);
1321 
1322             _ownerships[startTokenId].addr = to;
1323             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1324 
1325             uint256 updatedIndex = startTokenId;
1326             uint256 end = updatedIndex + quantity;
1327 
1328             if (safe && to.isContract()) {
1329                 do {
1330                     emit Transfer(address(0), to, updatedIndex);
1331                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1332                         revert TransferToNonERC721ReceiverImplementer();
1333                     }
1334                 } while (updatedIndex != end);
1335                 // Reentrancy protection
1336                 if (_currentIndex != startTokenId) revert();
1337             } else {
1338                 do {
1339                     emit Transfer(address(0), to, updatedIndex++);
1340                 } while (updatedIndex != end);
1341             }
1342             _currentIndex = updatedIndex;
1343         }
1344         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1345     }
1346 
1347     /**
1348      * @dev Transfers `tokenId` from `from` to `to`.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function _transfer(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) private {
1362         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1363 
1364         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1365 
1366         bool isApprovedOrOwner = (_msgSender() == from ||
1367             isApprovedForAll(from, _msgSender()) ||
1368             getApproved(tokenId) == _msgSender());
1369 
1370         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1371         if (to == address(0)) revert TransferToZeroAddress();
1372 
1373         _beforeTokenTransfers(from, to, tokenId, 1);
1374 
1375         // Clear approvals from the previous owner
1376         _approve(address(0), tokenId, from);
1377 
1378         // Underflow of the sender's balance is impossible because we check for
1379         // ownership above and the recipient's balance can't realistically overflow.
1380         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1381         unchecked {
1382             _addressData[from].balance -= 1;
1383             _addressData[to].balance += 1;
1384 
1385             TokenOwnership storage currSlot = _ownerships[tokenId];
1386             currSlot.addr = to;
1387             currSlot.startTimestamp = uint64(block.timestamp);
1388 
1389             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1390             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1391             uint256 nextTokenId = tokenId + 1;
1392             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1393             if (nextSlot.addr == address(0)) {
1394                 // This will suffice for checking _exists(nextTokenId),
1395                 // as a burned slot cannot contain the zero address.
1396                 if (nextTokenId != _currentIndex) {
1397                     nextSlot.addr = from;
1398                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1399                 }
1400             }
1401         }
1402 
1403         emit Transfer(from, to, tokenId);
1404         _afterTokenTransfers(from, to, tokenId, 1);
1405     }
1406 
1407     /**
1408      * @dev This is equivalent to _burn(tokenId, false)
1409      */
1410     function _burn(uint256 tokenId) internal virtual {
1411         _burn(tokenId, false);
1412     }
1413 
1414     /**
1415      * @dev Destroys `tokenId`.
1416      * The approval is cleared when the token is burned.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1425         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1426 
1427         address from = prevOwnership.addr;
1428 
1429         if (approvalCheck) {
1430             bool isApprovedOrOwner = (_msgSender() == from ||
1431                 isApprovedForAll(from, _msgSender()) ||
1432                 getApproved(tokenId) == _msgSender());
1433 
1434             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1435         }
1436 
1437         _beforeTokenTransfers(from, address(0), tokenId, 1);
1438 
1439         // Clear approvals from the previous owner
1440         _approve(address(0), tokenId, from);
1441 
1442         // Underflow of the sender's balance is impossible because we check for
1443         // ownership above and the recipient's balance can't realistically overflow.
1444         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1445         unchecked {
1446             AddressData storage addressData = _addressData[from];
1447             addressData.balance -= 1;
1448             addressData.numberBurned += 1;
1449 
1450             // Keep track of who burned the token, and the timestamp of burning.
1451             TokenOwnership storage currSlot = _ownerships[tokenId];
1452             currSlot.addr = from;
1453             currSlot.startTimestamp = uint64(block.timestamp);
1454             currSlot.burned = true;
1455 
1456             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1457             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1458             uint256 nextTokenId = tokenId + 1;
1459             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1460             if (nextSlot.addr == address(0)) {
1461                 // This will suffice for checking _exists(nextTokenId),
1462                 // as a burned slot cannot contain the zero address.
1463                 if (nextTokenId != _currentIndex) {
1464                     nextSlot.addr = from;
1465                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1466                 }
1467             }
1468         }
1469 
1470         emit Transfer(from, address(0), tokenId);
1471         _afterTokenTransfers(from, address(0), tokenId, 1);
1472 
1473         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1474         unchecked {
1475             _burnCounter++;
1476         }
1477     }
1478 
1479     /**
1480      * @dev Approve `to` to operate on `tokenId`
1481      *
1482      * Emits a {Approval} event.
1483      */
1484     function _approve(
1485         address to,
1486         uint256 tokenId,
1487         address owner
1488     ) private {
1489         _tokenApprovals[tokenId] = to;
1490         emit Approval(owner, to, tokenId);
1491     }
1492 
1493     /**
1494      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1495      *
1496      * @param from address representing the previous owner of the given token ID
1497      * @param to target address that will receive the tokens
1498      * @param tokenId uint256 ID of the token to be transferred
1499      * @param _data bytes optional data to send along with the call
1500      * @return bool whether the call correctly returned the expected magic value
1501      */
1502     function _checkContractOnERC721Received(
1503         address from,
1504         address to,
1505         uint256 tokenId,
1506         bytes memory _data
1507     ) private returns (bool) {
1508         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1509             return retval == IERC721Receiver(to).onERC721Received.selector;
1510         } catch (bytes memory reason) {
1511             if (reason.length == 0) {
1512                 revert TransferToNonERC721ReceiverImplementer();
1513             } else {
1514                 assembly {
1515                     revert(add(32, reason), mload(reason))
1516                 }
1517             }
1518         }
1519     }
1520 
1521     /**
1522      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1523      * And also called before burning one token.
1524      *
1525      * startTokenId - the first token id to be transferred
1526      * quantity - the amount to be transferred
1527      *
1528      * Calling conditions:
1529      *
1530      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1531      * transferred to `to`.
1532      * - When `from` is zero, `tokenId` will be minted for `to`.
1533      * - When `to` is zero, `tokenId` will be burned by `from`.
1534      * - `from` and `to` are never both zero.
1535      */
1536     function _beforeTokenTransfers(
1537         address from,
1538         address to,
1539         uint256 startTokenId,
1540         uint256 quantity
1541     ) internal virtual {}
1542 
1543     /**
1544      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1545      * minting.
1546      * And also called after one token has been burned.
1547      *
1548      * startTokenId - the first token id to be transferred
1549      * quantity - the amount to be transferred
1550      *
1551      * Calling conditions:
1552      *
1553      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1554      * transferred to `to`.
1555      * - When `from` is zero, `tokenId` has been minted for `to`.
1556      * - When `to` is zero, `tokenId` has been burned by `from`.
1557      * - `from` and `to` are never both zero.
1558      */
1559     function _afterTokenTransfers(
1560         address from,
1561         address to,
1562         uint256 startTokenId,
1563         uint256 quantity
1564     ) internal virtual {}
1565 }
1566 // File: contracts/WZRDS.sol
1567 
1568 
1569 
1570 pragma solidity ^0.8.7;
1571 
1572 contract WZRDS_ASS3MBLY is ERC721A, Ownable {
1573     using SafeMath for uint256;
1574     using Strings for uint256;
1575 
1576     uint256 public maxPerTx = 5;
1577     uint256 public maxSupply = 1666;
1578     uint256 public freeMintMax = 300; 
1579     uint256 public price = 0.005 ether;
1580     uint256 public maxFreePerWallet = 1; 
1581 
1582     string private baseURI = "ipfs://QmU3rfCJDzMTN71qQ7qUK8bDBs3KwGCGtfsAxvtLXdfYVp/";
1583     string public notRevealedUri = "ipfs://QmU3rfCJDzMTN71qQ7qUK8bDBs3KwGCGtfsAxvtLXdfYVp/";
1584     string public constant baseExtension = ".json";
1585 
1586     mapping(address => uint256) private _mintedFreeAmount; 
1587 
1588     bool public paused = true;
1589     bool public revealed = false;
1590     error freeMintIsOver();
1591 
1592     address devWallet = 0xEA7D98Bb7532758698698242b206268177F7e209;
1593     uint _devFee = 5;
1594 
1595  
1596 
1597     constructor() ERC721A("WZRDS ASS3MBLY", "WZRDS") {}
1598 
1599     function mint(uint256 count) external payable {
1600         uint256 cost = price;
1601         bool isFree = ((totalSupply() + count < freeMintMax + 1) &&
1602             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1603 
1604         if (isFree) {
1605             cost = 0;
1606         }
1607 
1608         require(!paused, "Contract Paused.");
1609         require(msg.value >= count * cost, "Please send the exact amount.");
1610         require(totalSupply() + count < maxSupply + 1, "No more");
1611         require(count < maxPerTx + 1, "Max per TX reached.");
1612 
1613         if (isFree) {
1614             _mintedFreeAmount[msg.sender] += count;
1615         }
1616 
1617         _safeMint(msg.sender, count);
1618     } 
1619 
1620     function teamMint(uint256 _number) external onlyOwner {
1621         require(totalSupply() + _number <= maxSupply, "Minting would exceed maxSupply");
1622         _safeMint(_msgSender(), _number);
1623     }
1624 
1625     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1626         notRevealedUri = _notRevealedURI;
1627     } 
1628 
1629     function reveal() public onlyOwner {
1630         revealed = true;
1631     }  
1632 
1633     function _startTokenId() internal override view virtual returns (uint256) {
1634         return 1;
1635     }
1636 
1637     function _withdraw(address _address, uint256 _amount) private {
1638         (bool success, ) = _address.call{value: _amount}("");
1639         require(success, "Failed to withdraw Ether");
1640     }
1641 
1642     function withdrawAll() public onlyOwner {
1643         uint256 balance = address(this).balance;
1644         require(balance > 0, "Insufficent balance");
1645 
1646         _withdraw(_msgSender(), balance * (100 - devFee) / 100);
1647         _withdraw(devWallet, balance * devFee / 100);
1648     }
1649 
1650     function setPrice(uint256 _price) external onlyOwner {
1651         price = _price;
1652     }
1653 
1654     function setPause(bool _state) external onlyOwner {
1655         paused = _state;
1656     }
1657 
1658     function _baseURI() internal view virtual override returns (string memory) {
1659       return baseURI;
1660     }
1661     
1662     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1663     {
1664         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1665 
1666         if(revealed == false) 
1667         {
1668             return notRevealedUri;
1669         }
1670 
1671         string memory _tokenURI = super.tokenURI(tokenId);
1672         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1673     }
1674 }