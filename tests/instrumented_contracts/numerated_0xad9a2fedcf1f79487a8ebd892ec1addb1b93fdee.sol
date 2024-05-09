1 //Metti Ape is a fine art NFT collection from artist Pumpametti juxtaposing the ape culture through contemporary art perspectives. 
2 
3 //Not affiliated with Bored Ape Yacht Club nor Yuga Labs. 
4 
5 //Art collection preview: https://twitter.com/pumpametti/status/1479980326978002951
6 
7 //Total 10000 Metti Apes available. 
8 
9 //VIP reserved free mint for Pumpametti collectors, 300 Metti Apes available. 
10 
11 //First-come-frist-serve mint for Pettametti/Standametti/MettiLandscape/BAYC collectors, 9700 Metti Apes available. 
12 
13 //The mint cost is 0.02 ETH per Metti Ape, max 20 Metti Apes per transaction.
14 
15 //For Pumpametti collectors please select "PumpaFirstChoiceVIPMint".
16 
17 //For Pettametti collectors please select "PettaVernissageMint".
18 
19 //For Standametti collectors please select "StandaPrivateMint".
20 
21 //For MettiLandscape collectors please select 'LandscapePrivateMint".
22 
23 //For Bored Ape Yacht Club (BAYC) collectors please select "BAYCEliteMint".
24 
25 //You have to own a Metti artwork or a BAYC to mint a Metti Ape.
26 
27 //Only mint from contract, you can find detailed minting instruction on Pumpametti website.
28 
29 //https://www.pumpametti.com/metti-ape
30 
31 //https://opensea.io/collection/metti-ape
32 
33 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 // CAUTION
41 // This version of SafeMath should only be used with Solidity 0.8 or later,
42 // because it relies on the compiler's built in overflow checks.
43 
44 /**
45  * @dev Wrappers over Solidity's arithmetic operations.
46  *
47  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
48  * now has built in overflow checking.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, with an overflow flag.
53      *
54      * _Available since v3.4._
55      */
56     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             uint256 c = a + b;
59             if (c < a) return (false, 0);
60             return (true, c);
61         }
62     }
63 
64     /**
65      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
66      *
67      * _Available since v3.4._
68      */
69     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {
71             if (b > a) return (false, 0);
72             return (true, a - b);
73         }
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
78      *
79      * _Available since v3.4._
80      */
81     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84             // benefit is lost if 'b' is also tested.
85             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86             if (a == 0) return (true, 0);
87             uint256 c = a * b;
88             if (c / a != b) return (false, 0);
89             return (true, c);
90         }
91     }
92 
93     /**
94      * @dev Returns the division of two unsigned integers, with a division by zero flag.
95      *
96      * _Available since v3.4._
97      */
98     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
99         unchecked {
100             if (b == 0) return (false, 0);
101             return (true, a / b);
102         }
103     }
104 
105     /**
106      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b == 0) return (false, 0);
113             return (true, a % b);
114         }
115     }
116 
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a + b;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a - b;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a * b;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers, reverting on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator.
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         return a / b;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * reverting when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         return a % b;
187     }
188 
189     /**
190      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
191      * overflow (when the result is negative).
192      *
193      * CAUTION: This function is deprecated because it requires allocating memory for the error
194      * message unnecessarily. For custom revert reasons use {trySub}.
195      *
196      * Counterpart to Solidity's `-` operator.
197      *
198      * Requirements:
199      *
200      * - Subtraction cannot overflow.
201      */
202     function sub(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b <= a, errorMessage);
209             return a - b;
210         }
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a / b;
233         }
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * reverting with custom message when dividing by zero.
239      *
240      * CAUTION: This function is deprecated because it requires allocating memory for the error
241      * message unnecessarily. For custom revert reasons use {tryMod}.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(
252         uint256 a,
253         uint256 b,
254         string memory errorMessage
255     ) internal pure returns (uint256) {
256         unchecked {
257             require(b > 0, errorMessage);
258             return a % b;
259         }
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Strings.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @dev String operations.
272  */
273 library Strings {
274     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
278      */
279     function toString(uint256 value) internal pure returns (string memory) {
280         // Inspired by OraclizeAPI's implementation - MIT licence
281         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
282 
283         if (value == 0) {
284             return "0";
285         }
286         uint256 temp = value;
287         uint256 digits;
288         while (temp != 0) {
289             digits++;
290             temp /= 10;
291         }
292         bytes memory buffer = new bytes(digits);
293         while (value != 0) {
294             digits -= 1;
295             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
296             value /= 10;
297         }
298         return string(buffer);
299     }
300 
301     /**
302      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
303      */
304     function toHexString(uint256 value) internal pure returns (string memory) {
305         if (value == 0) {
306             return "0x00";
307         }
308         uint256 temp = value;
309         uint256 length = 0;
310         while (temp != 0) {
311             length++;
312             temp >>= 8;
313         }
314         return toHexString(value, length);
315     }
316 
317     /**
318      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
319      */
320     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
321         bytes memory buffer = new bytes(2 * length + 2);
322         buffer[0] = "0";
323         buffer[1] = "x";
324         for (uint256 i = 2 * length + 1; i > 1; --i) {
325             buffer[i] = _HEX_SYMBOLS[value & 0xf];
326             value >>= 4;
327         }
328         require(value == 0, "Strings: hex length insufficient");
329         return string(buffer);
330     }
331 }
332 
333 // File: @openzeppelin/contracts/utils/Context.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Provides information about the current execution context, including the
342  * sender of the transaction and its data. While these are generally available
343  * via msg.sender and msg.data, they should not be accessed in such a direct
344  * manner, since when dealing with meta-transactions the account sending and
345  * paying for execution may not be the actual sender (as far as an application
346  * is concerned).
347  *
348  * This contract is only required for intermediate, library-like contracts.
349  */
350 abstract contract Context {
351     function _msgSender() internal view virtual returns (address) {
352         return msg.sender;
353     }
354 
355     function _msgData() internal view virtual returns (bytes calldata) {
356         return msg.data;
357     }
358 }
359 
360 // File: @openzeppelin/contracts/access/Ownable.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Contract module which provides a basic access control mechanism, where
370  * there is an account (an owner) that can be granted exclusive access to
371  * specific functions.
372  *
373  * By default, the owner account will be the one that deploys the contract. This
374  * can later be changed with {transferOwnership}.
375  *
376  * This module is used through inheritance. It will make available the modifier
377  * `onlyOwner`, which can be applied to your functions to restrict their use to
378  * the owner.
379  */
380 abstract contract Ownable is Context {
381     address private _owner;
382 
383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385     /**
386      * @dev Initializes the contract setting the deployer as the initial owner.
387      */
388     constructor() {
389         _transferOwnership(_msgSender());
390     }
391 
392     /**
393      * @dev Returns the address of the current owner.
394      */
395     function owner() public view virtual returns (address) {
396         return _owner;
397     }
398 
399     /**
400      * @dev Throws if called by any account other than the owner.
401      */
402     modifier onlyOwner() {
403         require(owner() == _msgSender(), "Ownable: caller is not the owner");
404         _;
405     }
406 
407     /**
408      * @dev Leaves the contract without owner. It will not be possible to call
409      * `onlyOwner` functions anymore. Can only be called by the current owner.
410      *
411      * NOTE: Renouncing ownership will leave the contract without an owner,
412      * thereby removing any functionality that is only available to the owner.
413      */
414     function renounceOwnership() public virtual onlyOwner {
415         _transferOwnership(address(0));
416     }
417 
418     /**
419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
420      * Can only be called by the current owner.
421      */
422     function transferOwnership(address newOwner) public virtual onlyOwner {
423         require(newOwner != address(0), "Ownable: new owner is the zero address");
424         _transferOwnership(newOwner);
425     }
426 
427     /**
428      * @dev Transfers ownership of the contract to a new account (`newOwner`).
429      * Internal function without access restriction.
430      */
431     function _transferOwnership(address newOwner) internal virtual {
432         address oldOwner = _owner;
433         _owner = newOwner;
434         emit OwnershipTransferred(oldOwner, newOwner);
435     }
436 }
437 
438 // File: @openzeppelin/contracts/utils/Address.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Collection of functions related to the address type
447  */
448 library Address {
449     /**
450      * @dev Returns true if `account` is a contract.
451      *
452      * [IMPORTANT]
453      * ====
454      * It is unsafe to assume that an address for which this function returns
455      * false is an externally-owned account (EOA) and not a contract.
456      *
457      * Among others, `isContract` will return false for the following
458      * types of addresses:
459      *
460      *  - an externally-owned account
461      *  - a contract in construction
462      *  - an address where a contract will be created
463      *  - an address where a contract lived, but was destroyed
464      * ====
465      */
466     function isContract(address account) internal view returns (bool) {
467         // This method relies on extcodesize, which returns 0 for contracts in
468         // construction, since the code is only stored at the end of the
469         // constructor execution.
470 
471         uint256 size;
472         assembly {
473             size := extcodesize(account)
474         }
475         return size > 0;
476     }
477 
478     /**
479      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
480      * `recipient`, forwarding all available gas and reverting on errors.
481      *
482      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
483      * of certain opcodes, possibly making contracts go over the 2300 gas limit
484      * imposed by `transfer`, making them unable to receive funds via
485      * `transfer`. {sendValue} removes this limitation.
486      *
487      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
488      *
489      * IMPORTANT: because control is transferred to `recipient`, care must be
490      * taken to not create reentrancy vulnerabilities. Consider using
491      * {ReentrancyGuard} or the
492      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
493      */
494     function sendValue(address payable recipient, uint256 amount) internal {
495         require(address(this).balance >= amount, "Address: insufficient balance");
496 
497         (bool success, ) = recipient.call{value: amount}("");
498         require(success, "Address: unable to send value, recipient may have reverted");
499     }
500 
501     /**
502      * @dev Performs a Solidity function call using a low level `call`. A
503      * plain `call` is an unsafe replacement for a function call: use this
504      * function instead.
505      *
506      * If `target` reverts with a revert reason, it is bubbled up by this
507      * function (like regular Solidity function calls).
508      *
509      * Returns the raw returned data. To convert to the expected return value,
510      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
511      *
512      * Requirements:
513      *
514      * - `target` must be a contract.
515      * - calling `target` with `data` must not revert.
516      *
517      * _Available since v3.1._
518      */
519     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
520         return functionCall(target, data, "Address: low-level call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
525      * `errorMessage` as a fallback revert reason when `target` reverts.
526      *
527      * _Available since v3.1._
528      */
529     function functionCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, 0, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but also transferring `value` wei to `target`.
540      *
541      * Requirements:
542      *
543      * - the calling contract must have an ETH balance of at least `value`.
544      * - the called Solidity function must be `payable`.
545      *
546      * _Available since v3.1._
547      */
548     function functionCallWithValue(
549         address target,
550         bytes memory data,
551         uint256 value
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
558      * with `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(
563         address target,
564         bytes memory data,
565         uint256 value,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         require(address(this).balance >= value, "Address: insufficient balance for call");
569         require(isContract(target), "Address: call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.call{value: value}(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a static call.
578      *
579      * _Available since v3.3._
580      */
581     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
582         return functionStaticCall(target, data, "Address: low-level static call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a static call.
588      *
589      * _Available since v3.3._
590      */
591     function functionStaticCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal view returns (bytes memory) {
596         require(isContract(target), "Address: static call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.staticcall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
609         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(
619         address target,
620         bytes memory data,
621         string memory errorMessage
622     ) internal returns (bytes memory) {
623         require(isContract(target), "Address: delegate call to non-contract");
624 
625         (bool success, bytes memory returndata) = target.delegatecall(data);
626         return verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
631      * revert reason using the provided one.
632      *
633      * _Available since v4.3._
634      */
635     function verifyCallResult(
636         bool success,
637         bytes memory returndata,
638         string memory errorMessage
639     ) internal pure returns (bytes memory) {
640         if (success) {
641             return returndata;
642         } else {
643             // Look for revert reason and bubble it up if present
644             if (returndata.length > 0) {
645                 // The easiest way to bubble the revert reason is using memory via assembly
646 
647                 assembly {
648                     let returndata_size := mload(returndata)
649                     revert(add(32, returndata), returndata_size)
650                 }
651             } else {
652                 revert(errorMessage);
653             }
654         }
655     }
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @title ERC721 token receiver interface
667  * @dev Interface for any contract that wants to support safeTransfers
668  * from ERC721 asset contracts.
669  */
670 interface IERC721Receiver {
671     /**
672      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
673      * by `operator` from `from`, this function is called.
674      *
675      * It must return its Solidity selector to confirm the token transfer.
676      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
677      *
678      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
679      */
680     function onERC721Received(
681         address operator,
682         address from,
683         uint256 tokenId,
684         bytes calldata data
685     ) external returns (bytes4);
686 }
687 
688 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Interface of the ERC165 standard, as defined in the
697  * https://eips.ethereum.org/EIPS/eip-165[EIP].
698  *
699  * Implementers can declare support of contract interfaces, which can then be
700  * queried by others ({ERC165Checker}).
701  *
702  * For an implementation, see {ERC165}.
703  */
704 interface IERC165 {
705     /**
706      * @dev Returns true if this contract implements the interface defined by
707      * `interfaceId`. See the corresponding
708      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
709      * to learn more about how these ids are created.
710      *
711      * This function call must use less than 30 000 gas.
712      */
713     function supportsInterface(bytes4 interfaceId) external view returns (bool);
714 }
715 
716 // File: @openzeppelin/contracts/interfaces/IERC165.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Interface for the NFT Royalty Standard
734  */
735 interface IERC2981 is IERC165 {
736     /**
737      * @dev Called with the sale price to determine how much royalty is owed and to whom.
738      * @param tokenId - the NFT asset queried for royalty information
739      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
740      * @return receiver - address of who should be sent the royalty payment
741      * @return royaltyAmount - the royalty payment amount for `salePrice`
742      */
743     function royaltyInfo(uint256 tokenId, uint256 salePrice)
744         external
745         view
746         returns (address receiver, uint256 royaltyAmount);
747 }
748 
749 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @dev Implementation of the {IERC165} interface.
759  *
760  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
761  * for the additional interface id that will be supported. For example:
762  *
763  * ```solidity
764  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
765  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
766  * }
767  * ```
768  *
769  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
770  */
771 abstract contract ERC165 is IERC165 {
772     /**
773      * @dev See {IERC165-supportsInterface}.
774      */
775     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
776         return interfaceId == type(IERC165).interfaceId;
777     }
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
781 
782 
783 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 
788 /**
789  * @dev Required interface of an ERC721 compliant contract.
790  */
791 interface IERC721 is IERC165 {
792     /**
793      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
794      */
795     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
796 
797     /**
798      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
799      */
800     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
801 
802     /**
803      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
804      */
805     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
806 
807     /**
808      * @dev Returns the number of tokens in ``owner``'s account.
809      */
810     function balanceOf(address owner) external view returns (uint256 balance);
811 
812     /**
813      * @dev Returns the owner of the `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function ownerOf(uint256 tokenId) external view returns (address owner);
820 
821     /**
822      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
823      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must exist and be owned by `from`.
830      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) external;
840 
841     /**
842      * @dev Transfers `tokenId` token from `from` to `to`.
843      *
844      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must be owned by `from`.
851      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
852      *
853      * Emits a {Transfer} event.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) external;
860 
861     /**
862      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
863      * The approval is cleared when the token is transferred.
864      *
865      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
866      *
867      * Requirements:
868      *
869      * - The caller must own the token or be an approved operator.
870      * - `tokenId` must exist.
871      *
872      * Emits an {Approval} event.
873      */
874     function approve(address to, uint256 tokenId) external;
875 
876     /**
877      * @dev Returns the account approved for `tokenId` token.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      */
883     function getApproved(uint256 tokenId) external view returns (address operator);
884 
885     /**
886      * @dev Approve or remove `operator` as an operator for the caller.
887      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
888      *
889      * Requirements:
890      *
891      * - The `operator` cannot be the caller.
892      *
893      * Emits an {ApprovalForAll} event.
894      */
895     function setApprovalForAll(address operator, bool _approved) external;
896 
897     /**
898      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
899      *
900      * See {setApprovalForAll}
901      */
902     function isApprovedForAll(address owner, address operator) external view returns (bool);
903 
904     /**
905      * @dev Safely transfers `tokenId` token from `from` to `to`.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes calldata data
922     ) external;
923 }
924 
925 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
926 
927 
928 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
929 
930 pragma solidity ^0.8.0;
931 
932 
933 /**
934  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
935  * @dev See https://eips.ethereum.org/EIPS/eip-721
936  */
937 interface IERC721Enumerable is IERC721 {
938     /**
939      * @dev Returns the total amount of tokens stored by the contract.
940      */
941     function totalSupply() external view returns (uint256);
942 
943     /**
944      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
945      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
946      */
947     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
948 
949     /**
950      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
951      * Use along with {totalSupply} to enumerate all tokens.
952      */
953     function tokenByIndex(uint256 index) external view returns (uint256);
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
957 
958 
959 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 
964 /**
965  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
966  * @dev See https://eips.ethereum.org/EIPS/eip-721
967  */
968 interface IERC721Metadata is IERC721 {
969     /**
970      * @dev Returns the token collection name.
971      */
972     function name() external view returns (string memory);
973 
974     /**
975      * @dev Returns the token collection symbol.
976      */
977     function symbol() external view returns (string memory);
978 
979     /**
980      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
981      */
982     function tokenURI(uint256 tokenId) external view returns (string memory);
983 }
984 
985 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
986 
987 
988 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
989 
990 pragma solidity ^0.8.0;
991 
992 
993 
994 
995 
996 
997 
998 
999 /**
1000  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1001  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1002  * {ERC721Enumerable}.
1003  */
1004 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1005     using Address for address;
1006     using Strings for uint256;
1007 
1008     // Token name
1009     string private _name;
1010 
1011     // Token symbol
1012     string private _symbol;
1013 
1014     // Mapping from token ID to owner address
1015     mapping(uint256 => address) private _owners;
1016 
1017     // Mapping owner address to token count
1018     mapping(address => uint256) private _balances;
1019 
1020     // Mapping from token ID to approved address
1021     mapping(uint256 => address) private _tokenApprovals;
1022 
1023     // Mapping from owner to operator approvals
1024     mapping(address => mapping(address => bool)) private _operatorApprovals;
1025 
1026     /**
1027      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1028      */
1029     constructor(string memory name_, string memory symbol_) {
1030         _name = name_;
1031         _symbol = symbol_;
1032     }
1033 
1034     /**
1035      * @dev See {IERC165-supportsInterface}.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1038         return
1039             interfaceId == type(IERC721).interfaceId ||
1040             interfaceId == type(IERC721Metadata).interfaceId ||
1041             super.supportsInterface(interfaceId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-balanceOf}.
1046      */
1047     function balanceOf(address owner) public view virtual override returns (uint256) {
1048         require(owner != address(0), "ERC721: balance query for the zero address");
1049         return _balances[owner];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-ownerOf}.
1054      */
1055     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1056         address owner = _owners[tokenId];
1057         require(owner != address(0), "ERC721: owner query for nonexistent token");
1058         return owner;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-name}.
1063      */
1064     function name() public view virtual override returns (string memory) {
1065         return _name;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-symbol}.
1070      */
1071     function symbol() public view virtual override returns (string memory) {
1072         return _symbol;
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Metadata-tokenURI}.
1077      */
1078     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1079         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1080 
1081         string memory baseURI = _baseURI();
1082         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1083     }
1084 
1085     /**
1086      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1087      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1088      * by default, can be overriden in child contracts.
1089      */
1090     function _baseURI() internal view virtual returns (string memory) {
1091         return "";
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-approve}.
1096      */
1097     function approve(address to, uint256 tokenId) public virtual override {
1098         address owner = ERC721.ownerOf(tokenId);
1099         require(to != owner, "ERC721: approval to current owner");
1100 
1101         require(
1102             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1103             "ERC721: approve caller is not owner nor approved for all"
1104         );
1105 
1106         _approve(to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev See {IERC721-getApproved}.
1111      */
1112     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1113         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1114 
1115         return _tokenApprovals[tokenId];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-setApprovalForAll}.
1120      */
1121     function setApprovalForAll(address operator, bool approved) public virtual override {
1122         _setApprovalForAll(_msgSender(), operator, approved);
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-isApprovedForAll}.
1127      */
1128     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1129         return _operatorApprovals[owner][operator];
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-transferFrom}.
1134      */
1135     function transferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public virtual override {
1140         //solhint-disable-next-line max-line-length
1141         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1142 
1143         _transfer(from, to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-safeTransferFrom}.
1148      */
1149     function safeTransferFrom(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) public virtual override {
1154         safeTransferFrom(from, to, tokenId, "");
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-safeTransferFrom}.
1159      */
1160     function safeTransferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId,
1164         bytes memory _data
1165     ) public virtual override {
1166         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1167         _safeTransfer(from, to, tokenId, _data);
1168     }
1169 
1170     /**
1171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1173      *
1174      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1175      *
1176      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1177      * implement alternative mechanisms to perform token transfer, such as signature-based.
1178      *
1179      * Requirements:
1180      *
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must exist and be owned by `from`.
1184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _safeTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId,
1192         bytes memory _data
1193     ) internal virtual {
1194         _transfer(from, to, tokenId);
1195         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1196     }
1197 
1198     /**
1199      * @dev Returns whether `tokenId` exists.
1200      *
1201      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1202      *
1203      * Tokens start existing when they are minted (`_mint`),
1204      * and stop existing when they are burned (`_burn`).
1205      */
1206     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1207         return _owners[tokenId] != address(0);
1208     }
1209 
1210     /**
1211      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      */
1217     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1218         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1219         address owner = ERC721.ownerOf(tokenId);
1220         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1221     }
1222 
1223     /**
1224      * @dev Safely mints `tokenId` and transfers it to `to`.
1225      *
1226      * Requirements:
1227      *
1228      * - `tokenId` must not exist.
1229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _safeMint(address to, uint256 tokenId) internal virtual {
1234         _safeMint(to, tokenId, "");
1235     }
1236 
1237     /**
1238      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1239      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1240      */
1241     function _safeMint(
1242         address to,
1243         uint256 tokenId,
1244         bytes memory _data
1245     ) internal virtual {
1246         _mint(to, tokenId);
1247         require(
1248             _checkOnERC721Received(address(0), to, tokenId, _data),
1249             "ERC721: transfer to non ERC721Receiver implementer"
1250         );
1251     }
1252 
1253     /**
1254      * @dev Mints `tokenId` and transfers it to `to`.
1255      *
1256      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1257      *
1258      * Requirements:
1259      *
1260      * - `tokenId` must not exist.
1261      * - `to` cannot be the zero address.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _mint(address to, uint256 tokenId) internal virtual {
1266         require(to != address(0), "ERC721: mint to the zero address");
1267         require(!_exists(tokenId), "ERC721: token already minted");
1268 
1269         _beforeTokenTransfer(address(0), to, tokenId);
1270 
1271         _balances[to] += 1;
1272         _owners[tokenId] = to;
1273 
1274         emit Transfer(address(0), to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Destroys `tokenId`.
1279      * The approval is cleared when the token is burned.
1280      *
1281      * Requirements:
1282      *
1283      * - `tokenId` must exist.
1284      *
1285      * Emits a {Transfer} event.
1286      */
1287     function _burn(uint256 tokenId) internal virtual {
1288         address owner = ERC721.ownerOf(tokenId);
1289 
1290         _beforeTokenTransfer(owner, address(0), tokenId);
1291 
1292         // Clear approvals
1293         _approve(address(0), tokenId);
1294 
1295         _balances[owner] -= 1;
1296         delete _owners[tokenId];
1297 
1298         emit Transfer(owner, address(0), tokenId);
1299     }
1300 
1301     /**
1302      * @dev Transfers `tokenId` from `from` to `to`.
1303      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1304      *
1305      * Requirements:
1306      *
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must be owned by `from`.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) internal virtual {
1317         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1318         require(to != address(0), "ERC721: transfer to the zero address");
1319 
1320         _beforeTokenTransfer(from, to, tokenId);
1321 
1322         // Clear approvals from the previous owner
1323         _approve(address(0), tokenId);
1324 
1325         _balances[from] -= 1;
1326         _balances[to] += 1;
1327         _owners[tokenId] = to;
1328 
1329         emit Transfer(from, to, tokenId);
1330     }
1331 
1332     /**
1333      * @dev Approve `to` to operate on `tokenId`
1334      *
1335      * Emits a {Approval} event.
1336      */
1337     function _approve(address to, uint256 tokenId) internal virtual {
1338         _tokenApprovals[tokenId] = to;
1339         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev Approve `operator` to operate on all of `owner` tokens
1344      *
1345      * Emits a {ApprovalForAll} event.
1346      */
1347     function _setApprovalForAll(
1348         address owner,
1349         address operator,
1350         bool approved
1351     ) internal virtual {
1352         require(owner != operator, "ERC721: approve to caller");
1353         _operatorApprovals[owner][operator] = approved;
1354         emit ApprovalForAll(owner, operator, approved);
1355     }
1356 
1357     /**
1358      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1359      * The call is not executed if the target address is not a contract.
1360      *
1361      * @param from address representing the previous owner of the given token ID
1362      * @param to target address that will receive the tokens
1363      * @param tokenId uint256 ID of the token to be transferred
1364      * @param _data bytes optional data to send along with the call
1365      * @return bool whether the call correctly returned the expected magic value
1366      */
1367     function _checkOnERC721Received(
1368         address from,
1369         address to,
1370         uint256 tokenId,
1371         bytes memory _data
1372     ) private returns (bool) {
1373         if (to.isContract()) {
1374             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1375                 return retval == IERC721Receiver.onERC721Received.selector;
1376             } catch (bytes memory reason) {
1377                 if (reason.length == 0) {
1378                     revert("ERC721: transfer to non ERC721Receiver implementer");
1379                 } else {
1380                     assembly {
1381                         revert(add(32, reason), mload(reason))
1382                     }
1383                 }
1384             }
1385         } else {
1386             return true;
1387         }
1388     }
1389 
1390     /**
1391      * @dev Hook that is called before any token transfer. This includes minting
1392      * and burning.
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` will be minted for `to`.
1399      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1400      * - `from` and `to` are never both zero.
1401      *
1402      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1403      */
1404     function _beforeTokenTransfer(
1405         address from,
1406         address to,
1407         uint256 tokenId
1408     ) internal virtual {}
1409 }
1410 
1411 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1412 
1413 
1414 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 
1419 
1420 /**
1421  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1422  * enumerability of all the token ids in the contract as well as all token ids owned by each
1423  * account.
1424  */
1425 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1426     // Mapping from owner to list of owned token IDs
1427     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1428 
1429     // Mapping from token ID to index of the owner tokens list
1430     mapping(uint256 => uint256) private _ownedTokensIndex;
1431 
1432     // Array with all token ids, used for enumeration
1433     uint256[] private _allTokens;
1434 
1435     // Mapping from token id to position in the allTokens array
1436     mapping(uint256 => uint256) private _allTokensIndex;
1437 
1438     /**
1439      * @dev See {IERC165-supportsInterface}.
1440      */
1441     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1442         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1443     }
1444 
1445     /**
1446      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1447      */
1448     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1449         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1450         return _ownedTokens[owner][index];
1451     }
1452 
1453     /**
1454      * @dev See {IERC721Enumerable-totalSupply}.
1455      */
1456     function totalSupply() public view virtual override returns (uint256) {
1457         return _allTokens.length;
1458     }
1459 
1460     /**
1461      * @dev See {IERC721Enumerable-tokenByIndex}.
1462      */
1463     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1464         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1465         return _allTokens[index];
1466     }
1467 
1468     /**
1469      * @dev Hook that is called before any token transfer. This includes minting
1470      * and burning.
1471      *
1472      * Calling conditions:
1473      *
1474      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1475      * transferred to `to`.
1476      * - When `from` is zero, `tokenId` will be minted for `to`.
1477      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1478      * - `from` cannot be the zero address.
1479      * - `to` cannot be the zero address.
1480      *
1481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1482      */
1483     function _beforeTokenTransfer(
1484         address from,
1485         address to,
1486         uint256 tokenId
1487     ) internal virtual override {
1488         super._beforeTokenTransfer(from, to, tokenId);
1489 
1490         if (from == address(0)) {
1491             _addTokenToAllTokensEnumeration(tokenId);
1492         } else if (from != to) {
1493             _removeTokenFromOwnerEnumeration(from, tokenId);
1494         }
1495         if (to == address(0)) {
1496             _removeTokenFromAllTokensEnumeration(tokenId);
1497         } else if (to != from) {
1498             _addTokenToOwnerEnumeration(to, tokenId);
1499         }
1500     }
1501 
1502     /**
1503      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1504      * @param to address representing the new owner of the given token ID
1505      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1506      */
1507     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1508         uint256 length = ERC721.balanceOf(to);
1509         _ownedTokens[to][length] = tokenId;
1510         _ownedTokensIndex[tokenId] = length;
1511     }
1512 
1513     /**
1514      * @dev Private function to add a token to this extension's token tracking data structures.
1515      * @param tokenId uint256 ID of the token to be added to the tokens list
1516      */
1517     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1518         _allTokensIndex[tokenId] = _allTokens.length;
1519         _allTokens.push(tokenId);
1520     }
1521 
1522     /**
1523      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1524      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1525      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1526      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1527      * @param from address representing the previous owner of the given token ID
1528      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1529      */
1530     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1531         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1532         // then delete the last slot (swap and pop).
1533 
1534         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1535         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1536 
1537         // When the token to delete is the last token, the swap operation is unnecessary
1538         if (tokenIndex != lastTokenIndex) {
1539             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1540 
1541             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1542             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1543         }
1544 
1545         // This also deletes the contents at the last position of the array
1546         delete _ownedTokensIndex[tokenId];
1547         delete _ownedTokens[from][lastTokenIndex];
1548     }
1549 
1550     /**
1551      * @dev Private function to remove a token from this extension's token tracking data structures.
1552      * This has O(1) time complexity, but alters the order of the _allTokens array.
1553      * @param tokenId uint256 ID of the token to be removed from the tokens list
1554      */
1555     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1556         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1557         // then delete the last slot (swap and pop).
1558 
1559         uint256 lastTokenIndex = _allTokens.length - 1;
1560         uint256 tokenIndex = _allTokensIndex[tokenId];
1561 
1562         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1563         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1564         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1565         uint256 lastTokenId = _allTokens[lastTokenIndex];
1566 
1567         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1568         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1569 
1570         // This also deletes the contents at the last position of the array
1571         delete _allTokensIndex[tokenId];
1572         _allTokens.pop();
1573     }
1574 }
1575 
1576 // File: contracts/MettiApe.sol
1577 
1578 
1579 //Metti Ape is a fine art NFT collection from artist Pumpametti juxtaposing the ape culture through contemporary art perspectives. 
1580 
1581 //Not affiliated with Bored Ape Yacht Club nor Yuga Labs. 
1582 
1583 //Art collection preview: https://twitter.com/pumpametti
1584 
1585 //Total 10000 Metti Apes available. 
1586 
1587 //VIP reserved free mint for Pumpametti collectors, 300 Metti Apes available. 
1588 
1589 //First-come-frist-serve mint for Pettametti/Standametti/MettiLandscape/BAYC collectors, 9700 Metti Apes available. 
1590 
1591 //The mint cost is 0.02 ETH per Metti Ape, max 20 Metti Apes per transaction.
1592 
1593 //For Pumpametti collectors please select "PumpaFirstChoiceVIPMint".
1594 
1595 //For Pettametti collectors please select "PettaVernissageMint".
1596 
1597 //For Standametti collectors please select "StandaPrivateMint".
1598 
1599 //For MettiLandscape collectors please select 'LandscapePrivateMint".
1600 
1601 //For Bored Ape Yacht Club (BAYC) collectors please select "BAYCEliteMint".
1602 
1603 //You have to own a Metti artwork or a BAYC to mint a Metti Ape.
1604 
1605 //Only mint from contract, you can find detailed minting instruction on Pumpametti website.
1606 
1607 //https://www.pumpametti.com/metti-ape
1608 
1609 //https://opensea.io/collection/metti-ape
1610 
1611 
1612 //SPDX-License-Identifier: MIT
1613 
1614 pragma solidity ^0.8.0;
1615 
1616 interface PumpaInterface {
1617     function ownerOf(uint256 tokenId) external view returns (address owner);
1618     function balanceOf(address owner) external view returns (uint256 balance);
1619     function tokenOfOwnerByIndex(address owner, uint256 index)
1620         external
1621         view
1622         returns (uint256 tokenId);
1623 }
1624 
1625 interface BAYCInterface {
1626     function ownerOf(uint256 tokenId) external view returns (address owner);
1627     function balanceOf(address owner) external view returns (uint256 balance);
1628     function tokenOfOwnerByIndex(address owner, uint256 index)
1629         external
1630         view
1631         returns (uint256 tokenId);
1632 }
1633 
1634 interface PettaInterface {
1635     function ownerOf(uint256 tokenId) external view returns (address owner);
1636     function balanceOf(address owner) external view returns (uint256 balance);
1637     function tokenOfOwnerByIndex(address owner, uint256 index)
1638         external
1639         view
1640         returns (uint256 tokenId);
1641 }
1642 
1643 interface StandaInterface {
1644     function ownerOf(uint256 tokenId) external view returns (address owner);
1645     function balanceOf(address owner) external view returns (uint256 balance);
1646     function tokenOfOwnerByIndex(address owner, uint256 index)
1647         external
1648         view
1649         returns (uint256 tokenId);
1650 }
1651 
1652 interface LandscapeInterface {
1653     function ownerOf(uint256 tokenId) external view returns (address owner);
1654     function balanceOf(address owner) external view returns (uint256 balance);
1655     function tokenOfOwnerByIndex(address owner, uint256 index)
1656         external
1657         view
1658         returns (uint256 tokenId);
1659 }
1660 
1661 
1662 
1663 
1664 
1665 
1666 contract MettiApe is ERC721Enumerable, Ownable, IERC2981 {
1667   using Strings for uint256;
1668   using SafeMath for uint256;
1669  
1670   string public baseURI;
1671   string public baseExtension = ".json";
1672   string public notRevealedUri;
1673   uint256 public cost = 0.02 ether;
1674   uint256 public maxPumpaSupply = 300;
1675   uint256 public maxPettaStandaLandscapeBAYCSupply = 9700;
1676   uint256 public maxMintAmount = 20;
1677   bool public paused = false;
1678   bool public revealed = false;
1679   
1680   uint16 internal royalty = 700; // base 10000, 7%
1681   uint16 public constant BASE = 10000;
1682 
1683   address public PumpaAddress = 0x09646c5c1e42ede848A57d6542382C32f2877164;
1684   PumpaInterface PumpaContract = PumpaInterface(PumpaAddress);
1685   uint public PumpaOwnersSupplyMinted = 0;
1686   uint public PettaStandaLandscapeBAYCSupplyMinted = 0;
1687 
1688   address public PettaAddress = 0x52474FBF6b678a280d0C69F2314d6d95548b3DAF;
1689   PettaInterface PettaContract = PettaInterface(PettaAddress);
1690 
1691   address public StandaAddress = 0xFC6Bc5D50912354e89bAd4daBf053Bca2d7Cd817;
1692   StandaInterface StandaContract = StandaInterface(StandaAddress);
1693 
1694   address public LandscapeAddress = 0x6067E1963Fe613609eE61E93588E4736Cbfc7800;
1695   LandscapeInterface LandscapeContract = LandscapeInterface(LandscapeAddress);
1696 
1697   address public BAYCAddress = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
1698   BAYCInterface BAYCContract = BAYCInterface(BAYCAddress);
1699 
1700   constructor( 
1701     string memory _initBaseURI,
1702     string memory _initNotRevealedUri
1703   ) ERC721("MettiApe", "METTIAPE") {
1704     setBaseURI(_initBaseURI);
1705     setNotRevealedURI(_initNotRevealedUri);
1706   }
1707 
1708   // internal
1709   function _baseURI() internal view virtual override returns (string memory) {
1710     return baseURI;
1711   }
1712 
1713   function PumpaFirstChoiceVIPMint(uint PumpaId) public payable {
1714     require(PumpaId > 0 && PumpaId <= 300, "Token ID invalid");
1715     require(PumpaContract.ownerOf(PumpaId) == msg.sender, "Not the owner of this Pumpa");
1716 
1717     _safeMint(msg.sender, PumpaId);
1718   }
1719 
1720   function PettaVernissageMint(uint PettaId, uint _mintAmount) public payable {
1721     require(PettaContract.ownerOf(PettaId) == msg.sender, "Not the owner of this Petta");
1722     require(msg.value >= 0.02 ether * _mintAmount);
1723     require(!paused);
1724     require(_mintAmount > 0);
1725     require(_mintAmount <= maxMintAmount);
1726     require(PettaStandaLandscapeBAYCSupplyMinted + _mintAmount <= maxPettaStandaLandscapeBAYCSupply, "No more PettaStandaLandscapeBAYC supply left");
1727 
1728     for (uint256 i = 1; i <= _mintAmount; i++) {
1729       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeBAYCSupplyMinted + i);
1730     }
1731     PettaStandaLandscapeBAYCSupplyMinted = PettaStandaLandscapeBAYCSupplyMinted + _mintAmount;
1732 }
1733 
1734   function StandaPrivateMint(uint StandaId, uint _mintAmount) public payable {
1735     require(StandaContract.ownerOf(StandaId) == msg.sender, "Not the owner of this Standa");
1736     require(msg.value >= 0.02 ether * _mintAmount);
1737     require(!paused);
1738     require(_mintAmount > 0);
1739     require(_mintAmount <= maxMintAmount);
1740     require(PettaStandaLandscapeBAYCSupplyMinted + _mintAmount <= maxPettaStandaLandscapeBAYCSupply, "No more PettaStandaLandscapeBAYC supply left");
1741 
1742     for (uint256 i = 1; i <= _mintAmount; i++) {
1743       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeBAYCSupplyMinted + i);
1744     }
1745     PettaStandaLandscapeBAYCSupplyMinted = PettaStandaLandscapeBAYCSupplyMinted + _mintAmount;
1746   }
1747 
1748   function LandscapePrivateMint(uint LandscapeId, uint _mintAmount) public payable {
1749     require(LandscapeContract.ownerOf(LandscapeId) == msg.sender, "Not the owner of this Landscape");
1750     require(msg.value >= 0.02 ether * _mintAmount);
1751     require(!paused);
1752     require(_mintAmount > 0);
1753     require(_mintAmount <= maxMintAmount);
1754     require(PettaStandaLandscapeBAYCSupplyMinted + _mintAmount <= maxPettaStandaLandscapeBAYCSupply, "No more PettaStandaLandscapeBAYC supply left");
1755 
1756     for (uint256 i = 1; i <= _mintAmount; i++) {
1757       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeBAYCSupplyMinted + i);
1758     }
1759     PettaStandaLandscapeBAYCSupplyMinted = PettaStandaLandscapeBAYCSupplyMinted + _mintAmount;
1760   }
1761 
1762   function BAYCEliteMint(uint BAYCId, uint _mintAmount) public payable {
1763     require(BAYCContract.ownerOf(BAYCId) == msg.sender, "Not the owner of this BAYC");
1764     require(msg.value >= 0.02 ether * _mintAmount);
1765     require(!paused);
1766     require(_mintAmount > 0);
1767     require(_mintAmount <= maxMintAmount);
1768     require(PettaStandaLandscapeBAYCSupplyMinted + _mintAmount <= maxPettaStandaLandscapeBAYCSupply, "No more PettaStandaLandscapeBAYC supply left");
1769 
1770     for (uint256 i = 1; i <= _mintAmount; i++) {
1771       _safeMint(msg.sender, maxPumpaSupply + PettaStandaLandscapeBAYCSupplyMinted + i);
1772     }
1773     PettaStandaLandscapeBAYCSupplyMinted = PettaStandaLandscapeBAYCSupplyMinted + _mintAmount;
1774   }
1775 
1776   function tokenURI(uint256 tokenId)
1777     public
1778     view
1779     virtual
1780     override
1781     returns (string memory)
1782   {
1783     require(
1784       _exists(tokenId),
1785       "ERC721Metadata: URI query for nonexistent token"
1786     );
1787     
1788     if(revealed == false) {
1789         return notRevealedUri;
1790     }
1791 
1792     string memory currentBaseURI = _baseURI();
1793     return bytes(currentBaseURI).length > 0
1794         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1795         : "";
1796   }
1797   
1798   //onlyOwner
1799   
1800   function reveal() public onlyOwner {
1801       revealed = true;
1802   }
1803   
1804   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1805     baseURI = _newBaseURI;
1806   }
1807 
1808   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1809     baseExtension = _newBaseExtension;
1810   }
1811   
1812   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1813     notRevealedUri = _notRevealedURI;
1814   }
1815 
1816   function pause(bool _state) public onlyOwner {
1817     paused = _state;
1818   }
1819   
1820   function royaltyInfo(uint256, uint256 _salePrice)
1821         external
1822         view
1823         override
1824         returns (address receiver, uint256 royaltyAmount)
1825     {
1826         return (address(this), (_salePrice * royalty) / BASE);
1827     }
1828 
1829   function setRoyalty(uint16 _royalty) public virtual onlyOwner {
1830         require(_royalty >= 0 && _royalty <= 1000, 'Royalty must be between 0% and 10%.');
1831 
1832         royalty = _royalty;
1833     }
1834 
1835   function withdraw() public payable onlyOwner {
1836     require(payable(msg.sender).send(address(this).balance));
1837   }
1838   
1839 }