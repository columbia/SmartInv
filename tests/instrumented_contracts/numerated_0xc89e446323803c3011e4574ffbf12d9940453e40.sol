1 // SPDX-License-Identifier: MIT
2 /** 
3  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
4 */
5             
6 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
7 
8 pragma solidity ^0.8.0;
9 
10 contract Initializable {
11     bool inited = false;
12 
13     modifier initializer() {
14         require(!inited, "already inited");
15         _;
16         inited = true;
17     }
18 }
19 
20 
21 
22 
23 /** 
24  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
25 */
26             
27 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
28 
29 pragma solidity ^0.8.0;
30 
31 ////import {Initializable} from "./Initializable.sol";
32 
33 contract EIP712Base is Initializable {
34     struct EIP712Domain {
35         string name;
36         string version;
37         address verifyingContract;
38         bytes32 salt;
39     }
40 
41     string constant public ERC712_VERSION = "1";
42 
43     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
44         bytes(
45             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
46         )
47     );
48     bytes32 internal domainSeperator;
49 
50     // supposed to be called once while initializing.
51     // one of the contracts that inherits this contract follows proxy pattern
52     // so it is not possible to do this in a constructor
53     function _initializeEIP712(
54         string memory name
55     )
56         internal
57         initializer
58     {
59         _setDomainSeperator(name);
60     }
61 
62     function _setDomainSeperator(string memory name) internal {
63         domainSeperator = keccak256(
64             abi.encode(
65                 EIP712_DOMAIN_TYPEHASH,
66                 keccak256(bytes(name)),
67                 keccak256(bytes(ERC712_VERSION)),
68                 address(this),
69                 bytes32(getChainId())
70             )
71         );
72     }
73 
74     function getDomainSeperator() public view returns (bytes32) {
75         return domainSeperator;
76     }
77 
78     function getChainId() public view returns (uint256) {
79         uint256 id;
80         assembly {
81             id := chainid()
82         }
83         return id;
84     }
85 
86     /**
87      * Accept message hash and returns hash message in EIP712 compatible form
88      * So that it can be used to recover signer from signature signed using EIP712 formatted data
89      * https://eips.ethereum.org/EIPS/eip-712
90      * "\\x19" makes the encoding deterministic
91      * "\\x01" is the version byte to make it compatible to EIP-191
92      */
93     function toTypedMessageHash(bytes32 messageHash)
94         internal
95         view
96         returns (bytes32)
97     {
98         return
99             keccak256(
100                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
101             );
102     }
103 }
104 
105 
106 
107 /** 
108  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
109 */
110             
111 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
112 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 // CAUTION
117 // This version of SafeMath should only be used with Solidity 0.8 or later,
118 // because it relies on the compiler's built in overflow checks.
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations.
122  *
123  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
124  * now has built in overflow checking.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, with an overflow flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             uint256 c = a + b;
135             if (c < a) return (false, 0);
136             return (true, c);
137         }
138     }
139 
140     /**
141      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
142      *
143      * _Available since v3.4._
144      */
145     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b > a) return (false, 0);
148             return (true, a - b);
149         }
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         unchecked {
159             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160             // benefit is lost if 'b' is also tested.
161             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162             if (a == 0) return (true, 0);
163             uint256 c = a * b;
164             if (c / a != b) return (false, 0);
165             return (true, c);
166         }
167     }
168 
169     /**
170      * @dev Returns the division of two unsigned integers, with a division by zero flag.
171      *
172      * _Available since v3.4._
173      */
174     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a / b);
178         }
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         unchecked {
188             if (b == 0) return (false, 0);
189             return (true, a % b);
190         }
191     }
192 
193     /**
194      * @dev Returns the addition of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `+` operator.
198      *
199      * Requirements:
200      *
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a + b;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a - b;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a * b;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator.
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(uint256 a, uint256 b) internal pure returns (uint256) {
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return a % b;
263     }
264 
265     /**
266      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
267      * overflow (when the result is negative).
268      *
269      * CAUTION: This function is deprecated because it requires allocating memory for the error
270      * message unnecessarily. For custom revert reasons use {trySub}.
271      *
272      * Counterpart to Solidity's `-` operator.
273      *
274      * Requirements:
275      *
276      * - Subtraction cannot overflow.
277      */
278     function sub(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b <= a, errorMessage);
285             return a - b;
286         }
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(
302         uint256 a,
303         uint256 b,
304         string memory errorMessage
305     ) internal pure returns (uint256) {
306         unchecked {
307             require(b > 0, errorMessage);
308             return a / b;
309         }
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * reverting with custom message when dividing by zero.
315      *
316      * CAUTION: This function is deprecated because it requires allocating memory for the error
317      * message unnecessarily. For custom revert reasons use {tryMod}.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(
328         uint256 a,
329         uint256 b,
330         string memory errorMessage
331     ) internal pure returns (uint256) {
332         unchecked {
333             require(b > 0, errorMessage);
334             return a % b;
335         }
336     }
337 }
338 
339 
340 
341 
342 /** 
343  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
344 */
345             
346 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
347 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes calldata) {
367         return msg.data;
368     }
369 }
370 
371 
372 
373 
374 /** 
375  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
376 */
377             
378 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
379 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 /**
384  * @dev Interface of the ERC165 standard, as defined in the
385  * https://eips.ethereum.org/EIPS/eip-165[EIP].
386  *
387  * Implementers can declare support of contract interfaces, which can then be
388  * queried by others ({ERC165Checker}).
389  *
390  * For an implementation, see {ERC165}.
391  */
392 interface IERC165 {
393     /**
394      * @dev Returns true if this contract implements the interface defined by
395      * `interfaceId`. See the corresponding
396      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
397      * to learn more about how these ids are created.
398      *
399      * This function call must use less than 30 000 gas.
400      */
401     function supportsInterface(bytes4 interfaceId) external view returns (bool);
402 }
403 
404 
405 
406 
407 /** 
408  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
409 */
410             
411 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
412 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 ////import "../../utils/introspection/IERC165.sol";
417 
418 /**
419  * @dev Required interface of an ERC721 compliant contract.
420  */
421 interface IERC721 is IERC165 {
422     /**
423      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
426 
427     /**
428      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
429      */
430     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
431 
432     /**
433      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
434      */
435     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
436 
437     /**
438      * @dev Returns the number of tokens in ``owner``'s account.
439      */
440     function balanceOf(address owner) external view returns (uint256 balance);
441 
442     /**
443      * @dev Returns the owner of the `tokenId` token.
444      *
445      * Requirements:
446      *
447      * - `tokenId` must exist.
448      */
449     function ownerOf(uint256 tokenId) external view returns (address owner);
450 
451     /**
452      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
453      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId
469     ) external;
470 
471     /**
472      * @dev Transfers `tokenId` token from `from` to `to`.
473      *
474      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must be owned by `from`.
481      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(
486         address from,
487         address to,
488         uint256 tokenId
489     ) external;
490 
491     /**
492      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
493      * The approval is cleared when the token is transferred.
494      *
495      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
496      *
497      * Requirements:
498      *
499      * - The caller must own the token or be an approved operator.
500      * - `tokenId` must exist.
501      *
502      * Emits an {Approval} event.
503      */
504     function approve(address to, uint256 tokenId) external;
505 
506     /**
507      * @dev Returns the account approved for `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function getApproved(uint256 tokenId) external view returns (address operator);
514 
515     /**
516      * @dev Approve or remove `operator` as an operator for the caller.
517      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
518      *
519      * Requirements:
520      *
521      * - The `operator` cannot be the caller.
522      *
523      * Emits an {ApprovalForAll} event.
524      */
525     function setApprovalForAll(address operator, bool _approved) external;
526 
527     /**
528      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
529      *
530      * See {setApprovalForAll}
531      */
532     function isApprovedForAll(address owner, address operator) external view returns (bool);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`.
536      *
537      * Requirements:
538      *
539      * - `from` cannot be the zero address.
540      * - `to` cannot be the zero address.
541      * - `tokenId` token must exist and be owned by `from`.
542      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
543      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
544      *
545      * Emits a {Transfer} event.
546      */
547     function safeTransferFrom(
548         address from,
549         address to,
550         uint256 tokenId,
551         bytes calldata data
552     ) external;
553 }
554 
555 
556 
557 
558 /** 
559  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
560 */
561             
562 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 ////import "./IERC165.sol";
568 
569 /**
570  * @dev Implementation of the {IERC165} interface.
571  *
572  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
573  * for the additional interface id that will be supported. For example:
574  *
575  * ```solidity
576  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
578  * }
579  * ```
580  *
581  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
582  */
583 abstract contract ERC165 is IERC165 {
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         return interfaceId == type(IERC165).interfaceId;
589     }
590 }
591 
592 
593 
594 
595 /** 
596  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
597 */
598             
599 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
600 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev String operations.
606  */
607 library Strings {
608     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
612      */
613     function toString(uint256 value) internal pure returns (string memory) {
614         // Inspired by OraclizeAPI's implementation - MIT licence
615         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
616 
617         if (value == 0) {
618             return "0";
619         }
620         uint256 temp = value;
621         uint256 digits;
622         while (temp != 0) {
623             digits++;
624             temp /= 10;
625         }
626         bytes memory buffer = new bytes(digits);
627         while (value != 0) {
628             digits -= 1;
629             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
630             value /= 10;
631         }
632         return string(buffer);
633     }
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
637      */
638     function toHexString(uint256 value) internal pure returns (string memory) {
639         if (value == 0) {
640             return "0x00";
641         }
642         uint256 temp = value;
643         uint256 length = 0;
644         while (temp != 0) {
645             length++;
646             temp >>= 8;
647         }
648         return toHexString(value, length);
649     }
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
653      */
654     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
655         bytes memory buffer = new bytes(2 * length + 2);
656         buffer[0] = "0";
657         buffer[1] = "x";
658         for (uint256 i = 2 * length + 1; i > 1; --i) {
659             buffer[i] = _HEX_SYMBOLS[value & 0xf];
660             value >>= 4;
661         }
662         require(value == 0, "Strings: hex length insufficient");
663         return string(buffer);
664     }
665 }
666 
667 
668 
669 
670 /** 
671  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
672 */
673             
674 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
675 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @dev Collection of functions related to the address type
681  */
682 library Address {
683     /**
684      * @dev Returns true if `account` is a contract.
685      *
686      * [////IMPORTANT]
687      * ====
688      * It is unsafe to assume that an address for which this function returns
689      * false is an externally-owned account (EOA) and not a contract.
690      *
691      * Among others, `isContract` will return false for the following
692      * types of addresses:
693      *
694      *  - an externally-owned account
695      *  - a contract in construction
696      *  - an address where a contract will be created
697      *  - an address where a contract lived, but was destroyed
698      * ====
699      */
700     function isContract(address account) internal view returns (bool) {
701         // This method relies on extcodesize, which returns 0 for contracts in
702         // construction, since the code is only stored at the end of the
703         // constructor execution.
704 
705         uint256 size;
706         assembly {
707             size := extcodesize(account)
708         }
709         return size > 0;
710     }
711 
712     /**
713      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
714      * `recipient`, forwarding all available gas and reverting on errors.
715      *
716      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
717      * of certain opcodes, possibly making contracts go over the 2300 gas limit
718      * imposed by `transfer`, making them unable to receive funds via
719      * `transfer`. {sendValue} removes this limitation.
720      *
721      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
722      *
723      * ////IMPORTANT: because control is transferred to `recipient`, care must be
724      * taken to not create reentrancy vulnerabilities. Consider using
725      * {ReentrancyGuard} or the
726      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
727      */
728     function sendValue(address payable recipient, uint256 amount) internal {
729         require(address(this).balance >= amount, "Address: insufficient balance");
730 
731         (bool success, ) = recipient.call{value: amount}("");
732         require(success, "Address: unable to send value, recipient may have reverted");
733     }
734 
735     /**
736      * @dev Performs a Solidity function call using a low level `call`. A
737      * plain `call` is an unsafe replacement for a function call: use this
738      * function instead.
739      *
740      * If `target` reverts with a revert reason, it is bubbled up by this
741      * function (like regular Solidity function calls).
742      *
743      * Returns the raw returned data. To convert to the expected return value,
744      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
745      *
746      * Requirements:
747      *
748      * - `target` must be a contract.
749      * - calling `target` with `data` must not revert.
750      *
751      * _Available since v3.1._
752      */
753     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
754         return functionCall(target, data, "Address: low-level call failed");
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
759      * `errorMessage` as a fallback revert reason when `target` reverts.
760      *
761      * _Available since v3.1._
762      */
763     function functionCall(
764         address target,
765         bytes memory data,
766         string memory errorMessage
767     ) internal returns (bytes memory) {
768         return functionCallWithValue(target, data, 0, errorMessage);
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
773      * but also transferring `value` wei to `target`.
774      *
775      * Requirements:
776      *
777      * - the calling contract must have an ETH balance of at least `value`.
778      * - the called Solidity function must be `payable`.
779      *
780      * _Available since v3.1._
781      */
782     function functionCallWithValue(
783         address target,
784         bytes memory data,
785         uint256 value
786     ) internal returns (bytes memory) {
787         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
792      * with `errorMessage` as a fallback revert reason when `target` reverts.
793      *
794      * _Available since v3.1._
795      */
796     function functionCallWithValue(
797         address target,
798         bytes memory data,
799         uint256 value,
800         string memory errorMessage
801     ) internal returns (bytes memory) {
802         require(address(this).balance >= value, "Address: insufficient balance for call");
803         require(isContract(target), "Address: call to non-contract");
804 
805         (bool success, bytes memory returndata) = target.call{value: value}(data);
806         return verifyCallResult(success, returndata, errorMessage);
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
811      * but performing a static call.
812      *
813      * _Available since v3.3._
814      */
815     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
816         return functionStaticCall(target, data, "Address: low-level static call failed");
817     }
818 
819     /**
820      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
821      * but performing a static call.
822      *
823      * _Available since v3.3._
824      */
825     function functionStaticCall(
826         address target,
827         bytes memory data,
828         string memory errorMessage
829     ) internal view returns (bytes memory) {
830         require(isContract(target), "Address: static call to non-contract");
831 
832         (bool success, bytes memory returndata) = target.staticcall(data);
833         return verifyCallResult(success, returndata, errorMessage);
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
838      * but performing a delegate call.
839      *
840      * _Available since v3.4._
841      */
842     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
843         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
844     }
845 
846     /**
847      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
848      * but performing a delegate call.
849      *
850      * _Available since v3.4._
851      */
852     function functionDelegateCall(
853         address target,
854         bytes memory data,
855         string memory errorMessage
856     ) internal returns (bytes memory) {
857         require(isContract(target), "Address: delegate call to non-contract");
858 
859         (bool success, bytes memory returndata) = target.delegatecall(data);
860         return verifyCallResult(success, returndata, errorMessage);
861     }
862 
863     /**
864      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
865      * revert reason using the provided one.
866      *
867      * _Available since v4.3._
868      */
869     function verifyCallResult(
870         bool success,
871         bytes memory returndata,
872         string memory errorMessage
873     ) internal pure returns (bytes memory) {
874         if (success) {
875             return returndata;
876         } else {
877             // Look for revert reason and bubble it up if present
878             if (returndata.length > 0) {
879                 // The easiest way to bubble the revert reason is using memory via assembly
880 
881                 assembly {
882                     let returndata_size := mload(returndata)
883                     revert(add(32, returndata), returndata_size)
884                 }
885             } else {
886                 revert(errorMessage);
887             }
888         }
889     }
890 }
891 
892 
893 
894 
895 /** 
896  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
897 */
898             
899 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
900 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 ////import "../IERC721.sol";
905 
906 /**
907  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
908  * @dev See https://eips.ethereum.org/EIPS/eip-721
909  */
910 interface IERC721Metadata is IERC721 {
911     /**
912      * @dev Returns the token collection name.
913      */
914     function name() external view returns (string memory);
915 
916     /**
917      * @dev Returns the token collection symbol.
918      */
919     function symbol() external view returns (string memory);
920 
921     /**
922      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
923      */
924     function tokenURI(uint256 tokenId) external view returns (string memory);
925 }
926 
927 
928 
929 
930 /** 
931  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
932 */
933             
934 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
935 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 /**
940  * @title ERC721 token receiver interface
941  * @dev Interface for any contract that wants to support safeTransfers
942  * from ERC721 asset contracts.
943  */
944 interface IERC721Receiver {
945     /**
946      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
947      * by `operator` from `from`, this function is called.
948      *
949      * It must return its Solidity selector to confirm the token transfer.
950      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
951      *
952      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
953      */
954     function onERC721Received(
955         address operator,
956         address from,
957         uint256 tokenId,
958         bytes calldata data
959     ) external returns (bytes4);
960 }
961 
962 
963 
964 
965 /** 
966  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
967 */
968             
969 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
970 
971 pragma solidity ^0.8.0;
972 
973 ////import {SafeMath} from  "@openzeppelin/contracts/utils/math/SafeMath.sol";
974 ////import {EIP712Base} from "./EIP712Base.sol";
975 
976 contract NativeMetaTransaction is EIP712Base {
977     using SafeMath for uint256;
978     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
979         bytes(
980             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
981         )
982     );
983     event MetaTransactionExecuted(
984         address userAddress,
985         address payable relayerAddress,
986         bytes functionSignature
987     );
988     mapping(address => uint256) nonces;
989 
990     /*
991      * Meta transaction structure.
992      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
993      * He should call the desired function directly in that case.
994      */
995     struct MetaTransaction {
996         uint256 nonce;
997         address from;
998         bytes functionSignature;
999     }
1000 
1001     function executeMetaTransaction(
1002         address userAddress,
1003         bytes memory functionSignature,
1004         bytes32 sigR,
1005         bytes32 sigS,
1006         uint8 sigV
1007     ) public payable returns (bytes memory) {
1008         MetaTransaction memory metaTx = MetaTransaction({
1009             nonce: nonces[userAddress],
1010             from: userAddress,
1011             functionSignature: functionSignature
1012         });
1013 
1014         require(
1015             verify(userAddress, metaTx, sigR, sigS, sigV),
1016             "Signer and signature do not match"
1017         );
1018 
1019         // increase nonce for user (to avoid re-use)
1020         nonces[userAddress] = nonces[userAddress].add(1);
1021 
1022         emit MetaTransactionExecuted(
1023             userAddress,
1024             payable(msg.sender),
1025             functionSignature
1026         );
1027 
1028         // Append userAddress and relayer address at the end to extract it from calling context
1029         (bool success, bytes memory returnData) = address(this).call(
1030             abi.encodePacked(functionSignature, userAddress)
1031         );
1032         require(success, "Function call not successful");
1033 
1034         return returnData;
1035     }
1036 
1037     function hashMetaTransaction(MetaTransaction memory metaTx)
1038         internal
1039         pure
1040         returns (bytes32)
1041     {
1042         return
1043             keccak256(
1044                 abi.encode(
1045                     META_TRANSACTION_TYPEHASH,
1046                     metaTx.nonce,
1047                     metaTx.from,
1048                     keccak256(metaTx.functionSignature)
1049                 )
1050             );
1051     }
1052 
1053     function getNonce(address user) public view returns (uint256 nonce) {
1054         nonce = nonces[user];
1055     }
1056 
1057     function verify(
1058         address signer,
1059         MetaTransaction memory metaTx,
1060         bytes32 sigR,
1061         bytes32 sigS,
1062         uint8 sigV
1063     ) internal view returns (bool) {
1064         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1065         return
1066             signer ==
1067             ecrecover(
1068                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1069                 sigV,
1070                 sigR,
1071                 sigS
1072             );
1073     }
1074 }
1075 
1076 
1077 
1078 
1079 /** 
1080  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1081 */
1082             
1083 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 abstract contract ContextMixin {
1088     function msgSender()
1089         internal
1090         view
1091         returns (address payable sender)
1092     {
1093         if (msg.sender == address(this)) {
1094             bytes memory array = msg.data;
1095             uint256 index = msg.data.length;
1096             assembly {
1097                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1098                 sender := and(
1099                     mload(add(array, index)),
1100                     0xffffffffffffffffffffffffffffffffffffffff
1101                 )
1102             }
1103         } else {
1104             sender = payable(msg.sender);
1105         }
1106         return sender;
1107     }
1108 }
1109 
1110 
1111 
1112 
1113 /** 
1114  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1115 */
1116             
1117 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1118 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 /**
1123  * @title Counters
1124  * @author Matt Condon (@shrugs)
1125  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1126  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1127  *
1128  * Include with `using Counters for Counters.Counter;`
1129  */
1130 library Counters {
1131     struct Counter {
1132         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1133         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1134         // this feature: see https://github.com/ethereum/solidity/issues/4637
1135         uint256 _value; // default: 0
1136     }
1137 
1138     function current(Counter storage counter) internal view returns (uint256) {
1139         return counter._value;
1140     }
1141 
1142     function increment(Counter storage counter) internal {
1143         unchecked {
1144             counter._value += 1;
1145         }
1146     }
1147 
1148     function decrement(Counter storage counter) internal {
1149         uint256 value = counter._value;
1150         require(value > 0, "Counter: decrement overflow");
1151         unchecked {
1152             counter._value = value - 1;
1153         }
1154     }
1155 
1156     function reset(Counter storage counter) internal {
1157         counter._value = 0;
1158     }
1159 }
1160 
1161 
1162 
1163 
1164 /** 
1165  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1166 */
1167             
1168 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1169 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1170 
1171 pragma solidity ^0.8.0;
1172 
1173 ////import "../utils/Context.sol";
1174 
1175 /**
1176  * @dev Contract module which allows children to implement an emergency stop
1177  * mechanism that can be triggered by an authorized account.
1178  *
1179  * This module is used through inheritance. It will make available the
1180  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1181  * the functions of your contract. Note that they will not be pausable by
1182  * simply including this module, only once the modifiers are put in place.
1183  */
1184 abstract contract Pausable is Context {
1185     /**
1186      * @dev Emitted when the pause is triggered by `account`.
1187      */
1188     event Paused(address account);
1189 
1190     /**
1191      * @dev Emitted when the pause is lifted by `account`.
1192      */
1193     event Unpaused(address account);
1194 
1195     bool private _paused;
1196 
1197     /**
1198      * @dev Initializes the contract in unpaused state.
1199      */
1200     constructor() {
1201         _paused = false;
1202     }
1203 
1204     /**
1205      * @dev Returns true if the contract is paused, and false otherwise.
1206      */
1207     function paused() public view virtual returns (bool) {
1208         return _paused;
1209     }
1210 
1211     /**
1212      * @dev Modifier to make a function callable only when the contract is not paused.
1213      *
1214      * Requirements:
1215      *
1216      * - The contract must not be paused.
1217      */
1218     modifier whenNotPaused() {
1219         require(!paused(), "Pausable: paused");
1220         _;
1221     }
1222 
1223     /**
1224      * @dev Modifier to make a function callable only when the contract is paused.
1225      *
1226      * Requirements:
1227      *
1228      * - The contract must be paused.
1229      */
1230     modifier whenPaused() {
1231         require(paused(), "Pausable: not paused");
1232         _;
1233     }
1234 
1235     /**
1236      * @dev Triggers stopped state.
1237      *
1238      * Requirements:
1239      *
1240      * - The contract must not be paused.
1241      */
1242     function _pause() internal virtual whenNotPaused {
1243         _paused = true;
1244         emit Paused(_msgSender());
1245     }
1246 
1247     /**
1248      * @dev Returns to normal state.
1249      *
1250      * Requirements:
1251      *
1252      * - The contract must be paused.
1253      */
1254     function _unpause() internal virtual whenPaused {
1255         _paused = false;
1256         emit Unpaused(_msgSender());
1257     }
1258 }
1259 
1260 
1261 
1262 
1263 /** 
1264  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1265 */
1266             
1267 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1268 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 ////import "../utils/Context.sol";
1273 
1274 /**
1275  * @dev Contract module which provides a basic access control mechanism, where
1276  * there is an account (an owner) that can be granted exclusive access to
1277  * specific functions.
1278  *
1279  * By default, the owner account will be the one that deploys the contract. This
1280  * can later be changed with {transferOwnership}.
1281  *
1282  * This module is used through inheritance. It will make available the modifier
1283  * `onlyOwner`, which can be applied to your functions to restrict their use to
1284  * the owner.
1285  */
1286 abstract contract Ownable is Context {
1287     address private _owner;
1288 
1289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1290 
1291     /**
1292      * @dev Initializes the contract setting the deployer as the initial owner.
1293      */
1294     constructor() {
1295         _transferOwnership(_msgSender());
1296     }
1297 
1298     /**
1299      * @dev Returns the address of the current owner.
1300      */
1301     function owner() public view virtual returns (address) {
1302         return _owner;
1303     }
1304 
1305     /**
1306      * @dev Throws if called by any account other than the owner.
1307      */
1308     modifier onlyOwner() {
1309         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1310         _;
1311     }
1312 
1313     /**
1314      * @dev Leaves the contract without owner. It will not be possible to call
1315      * `onlyOwner` functions anymore. Can only be called by the current owner.
1316      *
1317      * NOTE: Renouncing ownership will leave the contract without an owner,
1318      * thereby removing any functionality that is only available to the owner.
1319      */
1320     function renounceOwnership() public virtual onlyOwner {
1321         _transferOwnership(address(0));
1322     }
1323 
1324     /**
1325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1326      * Can only be called by the current owner.
1327      */
1328     function transferOwnership(address newOwner) public virtual onlyOwner {
1329         require(newOwner != address(0), "Ownable: new owner is the zero address");
1330         _transferOwnership(newOwner);
1331     }
1332 
1333     /**
1334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1335      * Internal function without access restriction.
1336      */
1337     function _transferOwnership(address newOwner) internal virtual {
1338         address oldOwner = _owner;
1339         _owner = newOwner;
1340         emit OwnershipTransferred(oldOwner, newOwner);
1341     }
1342 }
1343 
1344 
1345 
1346 
1347 /** 
1348  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1349 */
1350             
1351 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1353 
1354 pragma solidity ^0.8.0;
1355 
1356 ////import "./IERC721.sol";
1357 ////import "./IERC721Receiver.sol";
1358 ////import "./extensions/IERC721Metadata.sol";
1359 ////import "../../utils/Address.sol";
1360 ////import "../../utils/Context.sol";
1361 ////import "../../utils/Strings.sol";
1362 ////import "../../utils/introspection/ERC165.sol";
1363 
1364 /**
1365  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1366  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1367  * {ERC721Enumerable}.
1368  */
1369 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1370     using Address for address;
1371     using Strings for uint256;
1372 
1373     // Token name
1374     string private _name;
1375 
1376     // Token symbol
1377     string private _symbol;
1378 
1379     // Mapping from token ID to owner address
1380     mapping(uint256 => address) private _owners;
1381 
1382     // Mapping owner address to token count
1383     mapping(address => uint256) private _balances;
1384 
1385     // Mapping from token ID to approved address
1386     mapping(uint256 => address) private _tokenApprovals;
1387 
1388     // Mapping from owner to operator approvals
1389     mapping(address => mapping(address => bool)) private _operatorApprovals;
1390 
1391     /**
1392      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1393      */
1394     constructor(string memory name_, string memory symbol_) {
1395         _name = name_;
1396         _symbol = symbol_;
1397     }
1398 
1399     /**
1400      * @dev See {IERC165-supportsInterface}.
1401      */
1402     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1403         return
1404             interfaceId == type(IERC721).interfaceId ||
1405             interfaceId == type(IERC721Metadata).interfaceId ||
1406             super.supportsInterface(interfaceId);
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-balanceOf}.
1411      */
1412     function balanceOf(address owner) public view virtual override returns (uint256) {
1413         require(owner != address(0), "ERC721: balance query for the zero address");
1414         return _balances[owner];
1415     }
1416 
1417     /**
1418      * @dev See {IERC721-ownerOf}.
1419      */
1420     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1421         address owner = _owners[tokenId];
1422         require(owner != address(0), "ERC721: owner query for nonexistent token");
1423         return owner;
1424     }
1425 
1426     /**
1427      * @dev See {IERC721Metadata-name}.
1428      */
1429     function name() public view virtual override returns (string memory) {
1430         return _name;
1431     }
1432 
1433     /**
1434      * @dev See {IERC721Metadata-symbol}.
1435      */
1436     function symbol() public view virtual override returns (string memory) {
1437         return _symbol;
1438     }
1439 
1440     /**
1441      * @dev See {IERC721Metadata-tokenURI}.
1442      */
1443     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1444         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1445 
1446         string memory baseURI = _baseURI();
1447         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1448     }
1449 
1450     /**
1451      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1452      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1453      * by default, can be overriden in child contracts.
1454      */
1455     function _baseURI() internal view virtual returns (string memory) {
1456         return "";
1457     }
1458 
1459     /**
1460      * @dev See {IERC721-approve}.
1461      */
1462     function approve(address to, uint256 tokenId) public virtual override {
1463         address owner = ERC721.ownerOf(tokenId);
1464         require(to != owner, "ERC721: approval to current owner");
1465 
1466         require(
1467             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1468             "ERC721: approve caller is not owner nor approved for all"
1469         );
1470 
1471         _approve(to, tokenId);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-getApproved}.
1476      */
1477     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1478         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1479 
1480         return _tokenApprovals[tokenId];
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-setApprovalForAll}.
1485      */
1486     function setApprovalForAll(address operator, bool approved) public virtual override {
1487         _setApprovalForAll(_msgSender(), operator, approved);
1488     }
1489 
1490     /**
1491      * @dev See {IERC721-isApprovedForAll}.
1492      */
1493     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1494         return _operatorApprovals[owner][operator];
1495     }
1496 
1497     /**
1498      * @dev See {IERC721-transferFrom}.
1499      */
1500     function transferFrom(
1501         address from,
1502         address to,
1503         uint256 tokenId
1504     ) public virtual override {
1505         //solhint-disable-next-line max-line-length
1506         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1507 
1508         _transfer(from, to, tokenId);
1509     }
1510 
1511     /**
1512      * @dev See {IERC721-safeTransferFrom}.
1513      */
1514     function safeTransferFrom(
1515         address from,
1516         address to,
1517         uint256 tokenId
1518     ) public virtual override {
1519         safeTransferFrom(from, to, tokenId, "");
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-safeTransferFrom}.
1524      */
1525     function safeTransferFrom(
1526         address from,
1527         address to,
1528         uint256 tokenId,
1529         bytes memory _data
1530     ) public virtual override {
1531         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1532         _safeTransfer(from, to, tokenId, _data);
1533     }
1534 
1535     /**
1536      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1537      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1538      *
1539      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1540      *
1541      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1542      * implement alternative mechanisms to perform token transfer, such as signature-based.
1543      *
1544      * Requirements:
1545      *
1546      * - `from` cannot be the zero address.
1547      * - `to` cannot be the zero address.
1548      * - `tokenId` token must exist and be owned by `from`.
1549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1550      *
1551      * Emits a {Transfer} event.
1552      */
1553     function _safeTransfer(
1554         address from,
1555         address to,
1556         uint256 tokenId,
1557         bytes memory _data
1558     ) internal virtual {
1559         _transfer(from, to, tokenId);
1560         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1561     }
1562 
1563     /**
1564      * @dev Returns whether `tokenId` exists.
1565      *
1566      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1567      *
1568      * Tokens start existing when they are minted (`_mint`),
1569      * and stop existing when they are burned (`_burn`).
1570      */
1571     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1572         return _owners[tokenId] != address(0);
1573     }
1574 
1575     /**
1576      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1577      *
1578      * Requirements:
1579      *
1580      * - `tokenId` must exist.
1581      */
1582     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1583         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1584         address owner = ERC721.ownerOf(tokenId);
1585         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1586     }
1587 
1588     /**
1589      * @dev Safely mints `tokenId` and transfers it to `to`.
1590      *
1591      * Requirements:
1592      *
1593      * - `tokenId` must not exist.
1594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1595      *
1596      * Emits a {Transfer} event.
1597      */
1598     function _safeMint(address to, uint256 tokenId) internal virtual {
1599         _safeMint(to, tokenId, "");
1600     }
1601 
1602     /**
1603      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1604      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1605      */
1606     function _safeMint(
1607         address to,
1608         uint256 tokenId,
1609         bytes memory _data
1610     ) internal virtual {
1611         _mint(to, tokenId);
1612         require(
1613             _checkOnERC721Received(address(0), to, tokenId, _data),
1614             "ERC721: transfer to non ERC721Receiver implementer"
1615         );
1616     }
1617 
1618     /**
1619      * @dev Mints `tokenId` and transfers it to `to`.
1620      *
1621      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1622      *
1623      * Requirements:
1624      *
1625      * - `tokenId` must not exist.
1626      * - `to` cannot be the zero address.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _mint(address to, uint256 tokenId) internal virtual {
1631         require(to != address(0), "ERC721: mint to the zero address");
1632         require(!_exists(tokenId), "ERC721: token already minted");
1633 
1634         _beforeTokenTransfer(address(0), to, tokenId);
1635 
1636         _balances[to] += 1;
1637         _owners[tokenId] = to;
1638 
1639         emit Transfer(address(0), to, tokenId);
1640     }
1641 
1642     /**
1643      * @dev Destroys `tokenId`.
1644      * The approval is cleared when the token is burned.
1645      *
1646      * Requirements:
1647      *
1648      * - `tokenId` must exist.
1649      *
1650      * Emits a {Transfer} event.
1651      */
1652     function _burn(uint256 tokenId) internal virtual {
1653         address owner = ERC721.ownerOf(tokenId);
1654 
1655         _beforeTokenTransfer(owner, address(0), tokenId);
1656 
1657         // Clear approvals
1658         _approve(address(0), tokenId);
1659 
1660         _balances[owner] -= 1;
1661         delete _owners[tokenId];
1662 
1663         emit Transfer(owner, address(0), tokenId);
1664     }
1665 
1666     /**
1667      * @dev Transfers `tokenId` from `from` to `to`.
1668      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1669      *
1670      * Requirements:
1671      *
1672      * - `to` cannot be the zero address.
1673      * - `tokenId` token must be owned by `from`.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _transfer(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) internal virtual {
1682         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1683         require(to != address(0), "ERC721: transfer to the zero address");
1684 
1685         _beforeTokenTransfer(from, to, tokenId);
1686 
1687         // Clear approvals from the previous owner
1688         _approve(address(0), tokenId);
1689 
1690         _balances[from] -= 1;
1691         _balances[to] += 1;
1692         _owners[tokenId] = to;
1693 
1694         emit Transfer(from, to, tokenId);
1695     }
1696 
1697     /**
1698      * @dev Approve `to` to operate on `tokenId`
1699      *
1700      * Emits a {Approval} event.
1701      */
1702     function _approve(address to, uint256 tokenId) internal virtual {
1703         _tokenApprovals[tokenId] = to;
1704         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1705     }
1706 
1707     /**
1708      * @dev Approve `operator` to operate on all of `owner` tokens
1709      *
1710      * Emits a {ApprovalForAll} event.
1711      */
1712     function _setApprovalForAll(
1713         address owner,
1714         address operator,
1715         bool approved
1716     ) internal virtual {
1717         require(owner != operator, "ERC721: approve to caller");
1718         _operatorApprovals[owner][operator] = approved;
1719         emit ApprovalForAll(owner, operator, approved);
1720     }
1721 
1722     /**
1723      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1724      * The call is not executed if the target address is not a contract.
1725      *
1726      * @param from address representing the previous owner of the given token ID
1727      * @param to target address that will receive the tokens
1728      * @param tokenId uint256 ID of the token to be transferred
1729      * @param _data bytes optional data to send along with the call
1730      * @return bool whether the call correctly returned the expected magic value
1731      */
1732     function _checkOnERC721Received(
1733         address from,
1734         address to,
1735         uint256 tokenId,
1736         bytes memory _data
1737     ) private returns (bool) {
1738         if (to.isContract()) {
1739             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1740                 return retval == IERC721Receiver.onERC721Received.selector;
1741             } catch (bytes memory reason) {
1742                 if (reason.length == 0) {
1743                     revert("ERC721: transfer to non ERC721Receiver implementer");
1744                 } else {
1745                     assembly {
1746                         revert(add(32, reason), mload(reason))
1747                     }
1748                 }
1749             }
1750         } else {
1751             return true;
1752         }
1753     }
1754 
1755     /**
1756      * @dev Hook that is called before any token transfer. This includes minting
1757      * and burning.
1758      *
1759      * Calling conditions:
1760      *
1761      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1762      * transferred to `to`.
1763      * - When `from` is zero, `tokenId` will be minted for `to`.
1764      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1765      * - `from` and `to` are never both zero.
1766      *
1767      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1768      */
1769     function _beforeTokenTransfer(
1770         address from,
1771         address to,
1772         uint256 tokenId
1773     ) internal virtual {}
1774 }
1775 
1776 
1777 
1778 
1779 /** 
1780  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1781 */
1782             
1783 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1784 
1785 pragma solidity ^0.8.0;
1786 
1787 ////import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1788 ////import "@openzeppelin/contracts/access/Ownable.sol";
1789 ////import "@openzeppelin/contracts/security/Pausable.sol";
1790 ////import "@openzeppelin/contracts/utils/Counters.sol";
1791 ////import "@openzeppelin/contracts/utils/Strings.sol";
1792 ////import "@openzeppelin/contracts/utils/math/SafeMath.sol";
1793 
1794 ////import "./common/meta-transactions/ContextMixin.sol";
1795 ////import "./common/meta-transactions/NativeMetaTransaction.sol";
1796 
1797 contract OwnableDelegateProxy {}
1798 
1799 /**
1800  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1801  */
1802 contract ProxyRegistry {
1803     mapping(address => OwnableDelegateProxy) public proxies;
1804 }
1805 
1806 /**
1807  * @title ERC721Tradable
1808  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1809  */
1810 // abstract contract ERC721Tradable is ERC721, ContextMixin, NativeMetaTransaction, Ownable, Pausable {
1811 abstract contract ERC721Tradable is Pausable, Ownable, NativeMetaTransaction, ContextMixin, ERC721 {
1812     using SafeMath for uint256;
1813     using Counters for Counters.Counter;
1814 
1815     /**
1816      * We rely on the OZ Counter util to keep track of the next available ID.
1817      * We track the nextTokenId instead of the currentTokenId to save users on gas costs. 
1818      * Read more about it here: https://shiny.mirror.xyz/OUampBbIz9ebEicfGnQf5At_ReMHlZy0tB4glb9xQ0E
1819      */ 
1820     Counters.Counter internal _nextTokenId;
1821     address proxyRegistryAddress;
1822 
1823     constructor(
1824         string memory _name,
1825         string memory _symbol,
1826         address _proxyRegistryAddress
1827     ) ERC721(_name, _symbol) {
1828         proxyRegistryAddress = _proxyRegistryAddress;
1829         // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
1830         _nextTokenId.increment();
1831         _initializeEIP712(_name);
1832     }
1833 
1834     function tokenCurrent() internal view returns (uint256) {
1835         return _nextTokenId.current();
1836     }
1837 
1838     function tokenNext() internal {
1839         _nextTokenId.increment();
1840     }
1841 
1842     /* This is a failsafe in case OpenSea ever changes their proxyRegistry address we will be able to update it. */
1843     function updateProxyRegistryAddress(address addr) public onlyOwner {
1844         proxyRegistryAddress = addr;
1845     }
1846 
1847     /**
1848      * @dev Mints a token to an address with a tokenURI.
1849      * @param _to address of the future owner of the token
1850      */
1851     function mintTo(address _to) public onlyOwner {
1852         uint256 currentTokenId = _nextTokenId.current();
1853         _nextTokenId.increment();
1854         _safeMint(_to, currentTokenId);
1855     }
1856 
1857     /**
1858         @dev Returns the total tokens minted so far.
1859         1 is always subtracted from the Counter since it tracks the next available tokenId.
1860      */
1861     function totalSupply() public view returns (uint256) {
1862         return _nextTokenId.current() - 1;
1863     }
1864 
1865     function baseTokenURI() virtual public view returns (string memory);
1866 
1867     function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1868         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1869     }
1870 
1871     /**
1872      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1873      */
1874     function isApprovedForAll(address owner, address operator)
1875         override
1876         public
1877         view
1878         returns (bool)
1879     {
1880         // Whitelist OpenSea proxy contract for easy trading.
1881         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1882         if (address(proxyRegistry.proxies(owner)) == operator) {
1883             return true;
1884         }
1885 
1886         return super.isApprovedForAll(owner, operator);
1887     }
1888 
1889     /**
1890      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1891      */
1892     function _msgSender()
1893         internal
1894         override
1895         view
1896         returns (address sender)
1897     {
1898         return ContextMixin.msgSender();
1899     }
1900 }
1901 
1902 
1903 /** 
1904  *  SourceUnit: c:\www\seekers-contracts\contracts\Seekers Relic Day Zero.sol
1905 */
1906 
1907 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1908 pragma solidity ^0.8.2;
1909 
1910 ////import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1911 ////import "./ERC721Tradable.sol";
1912 
1913 /// @custom:security-contact info@innovatar.io
1914 contract SeekersRelicDayZero is ERC721Tradable {
1915 
1916     // Base URI
1917     string private _baseTokenURI = "";
1918 
1919     uint16 public constant MAX_RELICS = 1000;
1920     uint8 public constant MAX_PUBLIC_MINT = 3;
1921 
1922     bool public publicMintActive = false;
1923     bool public burnToFlowActive = false;
1924 
1925     mapping(bytes32 => bytes32) private burnlist;
1926 
1927     // End custom non-Zeppelin variables.
1928 
1929     constructor(address _proxyRegistryAddress) 
1930 			ERC721Tradable(
1931 				"Seekers Day Zero",
1932 				"SDZR",
1933 				_proxyRegistryAddress
1934 			) 
1935     {
1936         pause(); // nothing public can happen until the owner unpauses.
1937     }
1938 
1939     /**
1940         Custom modifiers
1941     */
1942 
1943     /**
1944      * Ensure the public mint is active.
1945      */
1946     modifier publicMintIsActive() {
1947         require(publicMintActive,"SeekersRelicDayZero: public mint is not active");
1948         _;
1949     }
1950 
1951     /**
1952      * Ensure the burn is active.
1953      */
1954     modifier burnToFlowIsActive() {
1955         require(burnToFlowActive,"SeekersRelicDayZero: burn-to-Flow is not active");
1956         _;
1957     }
1958 
1959     // End custom modifiers.
1960 
1961     /** 
1962         Custom non-Zeppelin functions:
1963     */
1964 
1965     /**
1966      * The relic may be burned to mint it on the Flow blockchain. The sigHash
1967      * must be generated at seekersnft.io or it will be invalid when checked,
1968      * preventing the relic from being minted on Flow. Don't call this
1969      * function directly or you will lose your relic.
1970      */
1971     function burnToFlow(uint16 tokenId, bytes32 sigHash) public whenNotPaused burnToFlowIsActive {
1972         //solhint-disable-next-line max-line-length
1973         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1974         require(sigHash != bytes32(0),"SeekersRelicDayZero: sigHash must not be empty!");
1975         bytes32 k = keccak256(abi.encode(_msgSender(),tokenId));
1976         burnlist[k] = sigHash;
1977         _burn(tokenId);
1978     }
1979 
1980     /**
1981      * Retrieve a burned relic sigHash for validation.
1982      */
1983     function getBurnSigHash(address tokenOwner, uint16 tokenId) public view returns (bytes32) {
1984         bytes32 k = keccak256(abi.encode(tokenOwner,tokenId));
1985         return burnlist[k];
1986     }
1987 
1988     function setBaseURI(string memory baseURI_) public onlyOwner {
1989        _baseTokenURI = baseURI_; 
1990     }
1991 
1992     function _baseURI() internal view override returns (string memory) {
1993         return _baseTokenURI;
1994     }
1995 
1996     function baseTokenURI() public view override returns (string memory) {
1997         return _baseURI();
1998     }
1999 
2000     /**
2001      * Shows how many Relics are left to mint.
2002      */
2003     function checkAvailableRelics() public view returns (uint256) {
2004         return MAX_RELICS + 1 - tokenCurrent();
2005     }
2006 
2007     /**
2008      * Shows how many Relics have been minted. Does not subtract burned Relics.
2009      */
2010     function checkMintedRelics() public view returns (uint256) {
2011         return tokenCurrent() - 1;
2012     }
2013 
2014     /**
2015      * Activate public mint.
2016      */
2017     function activatePublicMint() public onlyOwner {
2018         publicMintActive = true;
2019     }
2020 
2021     /**
2022      * Deactivate public mint.
2023      */
2024     function deactivatePublicMint() public onlyOwner {
2025         publicMintActive = false;
2026     }
2027 
2028     /**
2029      * Activate burn.
2030      */
2031     function activateBurnToFlow() public onlyOwner {
2032         burnToFlowActive = true;
2033     }
2034 
2035     /**
2036      * Deactivate burn.
2037      */
2038     function deactivateBurnToFlow() public onlyOwner {
2039         burnToFlowActive= false;
2040     }
2041 
2042     /**
2043       * Send a list of addresses and mint <amount> to each one.
2044       */
2045     function airdrop(address[] calldata addresses, uint8 amount) public onlyOwner whenNotPaused {
2046         for (uint256 i = 0; i < addresses.length; i++) {
2047             _mintMultiple(addresses[i], amount);
2048         }
2049     }
2050 
2051     /**
2052      * Allow public to mint.
2053      */
2054     function publicMintMultiple(uint8 quantity) public payable whenNotPaused publicMintIsActive {
2055         require(balanceOf(_msgSender()) + quantity <= MAX_PUBLIC_MINT,"SeekersRelicDayZero: not allowed to mint more than account allowance");
2056 
2057         _mintMultiple(_msgSender(), quantity);
2058     }
2059 
2060     function _mintMultiple(address to, uint8 quantity) internal whenNotPaused {
2061         // quantity must be positive
2062         require(quantity > 0,"SeekersRelicDayZero: quantity must be positive");
2063 
2064         //  inventoryAvailable check
2065         require(MAX_RELICS >= tokenCurrent() + quantity - 1,"SeekersRelicDayZero: not enough Relics left to mint multiple!");
2066 
2067         for (uint256 i = 0; i < quantity; i++) {
2068             uint256 tokenId = tokenCurrent();
2069             tokenNext();
2070             _safeMint(to, tokenId);
2071         }
2072     }
2073 
2074     /**
2075      * Check ETH balance (onlyOwner).
2076      */
2077     function checkBalance() public view onlyOwner returns (uint256) {
2078         uint256 balance = address(this).balance;
2079         return balance;
2080     }
2081 
2082     /**
2083      * Withdraw ETH (onlyOwner).
2084      */
2085     function withdraw() public onlyOwner {
2086         uint balance = address(this).balance;
2087         payable(_msgSender()).transfer(balance);
2088     }
2089 
2090     /**
2091      * This is for the contract owner to mint (reserve) multiple Relics for free.
2092      * _safeMint prevents minting to the zero address.
2093      */
2094     function ownerMintMultiple(address to, uint8 quantity) public onlyOwner {
2095         _mintMultiple(to, quantity);
2096     }
2097 
2098     // End custom non-Zeppelin functions.
2099 
2100     function pause() public onlyOwner {
2101         _pause();
2102     }
2103 
2104     function unpause() public onlyOwner {
2105         _unpause();
2106     }
2107 
2108 }