1 // Sources flattened with hardhat v2.5.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 
73 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
74 
75 
76 
77 pragma solidity ^0.8.0;
78 
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 
100 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _setOwner(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _setOwner(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _setOwner(newOwner);
163     }
164 
165     function _setOwner(address newOwner) private {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 
173 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
174 
175 
176 
177 pragma solidity ^0.8.0;
178 
179 // CAUTION
180 // This version of SafeMath should only be used with Solidity 0.8 or later,
181 // because it relies on the compiler's built in overflow checks.
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations.
185  *
186  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
187  * now has built in overflow checking.
188  */
189 library SafeMath {
190     /**
191      * @dev Returns the addition of two unsigned integers, with an overflow flag.
192      *
193      * _Available since v3.4._
194      */
195     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
196         unchecked {
197             uint256 c = a + b;
198             if (c < a) return (false, 0);
199             return (true, c);
200         }
201     }
202 
203     /**
204      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
205      *
206      * _Available since v3.4._
207      */
208     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         unchecked {
210             if (b > a) return (false, 0);
211             return (true, a - b);
212         }
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223             // benefit is lost if 'b' is also tested.
224             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225             if (a == 0) return (true, 0);
226             uint256 c = a * b;
227             if (c / a != b) return (false, 0);
228             return (true, c);
229         }
230     }
231 
232     /**
233      * @dev Returns the division of two unsigned integers, with a division by zero flag.
234      *
235      * _Available since v3.4._
236      */
237     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
238         unchecked {
239             if (b == 0) return (false, 0);
240             return (true, a / b);
241         }
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
246      *
247      * _Available since v3.4._
248      */
249     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b == 0) return (false, 0);
252             return (true, a % b);
253         }
254     }
255 
256     /**
257      * @dev Returns the addition of two unsigned integers, reverting on
258      * overflow.
259      *
260      * Counterpart to Solidity's `+` operator.
261      *
262      * Requirements:
263      *
264      * - Addition cannot overflow.
265      */
266     function add(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a + b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting on
272      * overflow (when the result is negative).
273      *
274      * Counterpart to Solidity's `-` operator.
275      *
276      * Requirements:
277      *
278      * - Subtraction cannot overflow.
279      */
280     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the multiplication of two unsigned integers, reverting on
286      * overflow.
287      *
288      * Counterpart to Solidity's `*` operator.
289      *
290      * Requirements:
291      *
292      * - Multiplication cannot overflow.
293      */
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a * b;
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers, reverting on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator.
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a / b;
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * reverting when dividing by zero.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a % b;
326     }
327 
328     /**
329      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
330      * overflow (when the result is negative).
331      *
332      * CAUTION: This function is deprecated because it requires allocating memory for the error
333      * message unnecessarily. For custom revert reasons use {trySub}.
334      *
335      * Counterpart to Solidity's `-` operator.
336      *
337      * Requirements:
338      *
339      * - Subtraction cannot overflow.
340      */
341     function sub(
342         uint256 a,
343         uint256 b,
344         string memory errorMessage
345     ) internal pure returns (uint256) {
346         unchecked {
347             require(b <= a, errorMessage);
348             return a - b;
349         }
350     }
351 
352     /**
353      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
354      * division by zero. The result is rounded towards zero.
355      *
356      * Counterpart to Solidity's `/` operator. Note: this function uses a
357      * `revert` opcode (which leaves remaining gas untouched) while Solidity
358      * uses an invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      *
362      * - The divisor cannot be zero.
363      */
364     function div(
365         uint256 a,
366         uint256 b,
367         string memory errorMessage
368     ) internal pure returns (uint256) {
369         unchecked {
370             require(b > 0, errorMessage);
371             return a / b;
372         }
373     }
374 
375     /**
376      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
377      * reverting with custom message when dividing by zero.
378      *
379      * CAUTION: This function is deprecated because it requires allocating memory for the error
380      * message unnecessarily. For custom revert reasons use {tryMod}.
381      *
382      * Counterpart to Solidity's `%` operator. This function uses a `revert`
383      * opcode (which leaves remaining gas untouched) while Solidity uses an
384      * invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function mod(
391         uint256 a,
392         uint256 b,
393         string memory errorMessage
394     ) internal pure returns (uint256) {
395         unchecked {
396             require(b > 0, errorMessage);
397             return a % b;
398         }
399     }
400 }
401 
402 
403 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
404 
405 
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Interface of the ERC165 standard, as defined in the
411  * https://eips.ethereum.org/EIPS/eip-165[EIP].
412  *
413  * Implementers can declare support of contract interfaces, which can then be
414  * queried by others ({ERC165Checker}).
415  *
416  * For an implementation, see {ERC165}.
417  */
418 interface IERC165 {
419     /**
420      * @dev Returns true if this contract implements the interface defined by
421      * `interfaceId`. See the corresponding
422      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
423      * to learn more about how these ids are created.
424      *
425      * This function call must use less than 30 000 gas.
426      */
427     function supportsInterface(bytes4 interfaceId) external view returns (bool);
428 }
429 
430 
431 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
432 
433 
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Required interface of an ERC721 compliant contract.
439  */
440 interface IERC721 is IERC165 {
441     /**
442      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
443      */
444     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
445 
446     /**
447      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
448      */
449     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
450 
451     /**
452      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
453      */
454     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
455 
456     /**
457      * @dev Returns the number of tokens in ``owner``'s account.
458      */
459     function balanceOf(address owner) external view returns (uint256 balance);
460 
461     /**
462      * @dev Returns the owner of the `tokenId` token.
463      *
464      * Requirements:
465      *
466      * - `tokenId` must exist.
467      */
468     function ownerOf(uint256 tokenId) external view returns (address owner);
469 
470     /**
471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
473      *
474      * Requirements:
475      *
476      * - `from` cannot be the zero address.
477      * - `to` cannot be the zero address.
478      * - `tokenId` token must exist and be owned by `from`.
479      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
481      *
482      * Emits a {Transfer} event.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Transfers `tokenId` token from `from` to `to`.
492      *
493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
494      *
495      * Requirements:
496      *
497      * - `from` cannot be the zero address.
498      * - `to` cannot be the zero address.
499      * - `tokenId` token must be owned by `from`.
500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
501      *
502      * Emits a {Transfer} event.
503      */
504     function transferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Returns the account approved for `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function getApproved(uint256 tokenId) external view returns (address operator);
533 
534     /**
535      * @dev Approve or remove `operator` as an operator for the caller.
536      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     /**
554      * @dev Safely transfers `tokenId` token from `from` to `to`.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must exist and be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563      *
564      * Emits a {Transfer} event.
565      */
566     function safeTransferFrom(
567         address from,
568         address to,
569         uint256 tokenId,
570         bytes calldata data
571     ) external;
572 }
573 
574 
575 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @title ERC721 token receiver interface
583  * @dev Interface for any contract that wants to support safeTransfers
584  * from ERC721 asset contracts.
585  */
586 interface IERC721Receiver {
587     /**
588      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
589      * by `operator` from `from`, this function is called.
590      *
591      * It must return its Solidity selector to confirm the token transfer.
592      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
593      *
594      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
595      */
596     function onERC721Received(
597         address operator,
598         address from,
599         uint256 tokenId,
600         bytes calldata data
601     ) external returns (bytes4);
602 }
603 
604 
605 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
606 
607 
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
613  * @dev See https://eips.ethereum.org/EIPS/eip-721
614  */
615 interface IERC721Metadata is IERC721 {
616     /**
617      * @dev Returns the token collection name.
618      */
619     function name() external view returns (string memory);
620 
621     /**
622      * @dev Returns the token collection symbol.
623      */
624     function symbol() external view returns (string memory);
625 
626     /**
627      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
628      */
629     function tokenURI(uint256 tokenId) external view returns (string memory);
630 }
631 
632 
633 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
634 
635 
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Collection of functions related to the address type
641  */
642 library Address {
643     /**
644      * @dev Returns true if `account` is a contract.
645      *
646      * [IMPORTANT]
647      * ====
648      * It is unsafe to assume that an address for which this function returns
649      * false is an externally-owned account (EOA) and not a contract.
650      *
651      * Among others, `isContract` will return false for the following
652      * types of addresses:
653      *
654      *  - an externally-owned account
655      *  - a contract in construction
656      *  - an address where a contract will be created
657      *  - an address where a contract lived, but was destroyed
658      * ====
659      */
660     function isContract(address account) internal view returns (bool) {
661         // This method relies on extcodesize, which returns 0 for contracts in
662         // construction, since the code is only stored at the end of the
663         // constructor execution.
664 
665         uint256 size;
666         assembly {
667             size := extcodesize(account)
668         }
669         return size > 0;
670     }
671 
672     /**
673      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
674      * `recipient`, forwarding all available gas and reverting on errors.
675      *
676      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
677      * of certain opcodes, possibly making contracts go over the 2300 gas limit
678      * imposed by `transfer`, making them unable to receive funds via
679      * `transfer`. {sendValue} removes this limitation.
680      *
681      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
682      *
683      * IMPORTANT: because control is transferred to `recipient`, care must be
684      * taken to not create reentrancy vulnerabilities. Consider using
685      * {ReentrancyGuard} or the
686      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
687      */
688     function sendValue(address payable recipient, uint256 amount) internal {
689         require(address(this).balance >= amount, "Address: insufficient balance");
690 
691         (bool success, ) = recipient.call{value: amount}("");
692         require(success, "Address: unable to send value, recipient may have reverted");
693     }
694 
695     /**
696      * @dev Performs a Solidity function call using a low level `call`. A
697      * plain `call` is an unsafe replacement for a function call: use this
698      * function instead.
699      *
700      * If `target` reverts with a revert reason, it is bubbled up by this
701      * function (like regular Solidity function calls).
702      *
703      * Returns the raw returned data. To convert to the expected return value,
704      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
705      *
706      * Requirements:
707      *
708      * - `target` must be a contract.
709      * - calling `target` with `data` must not revert.
710      *
711      * _Available since v3.1._
712      */
713     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
714         return functionCall(target, data, "Address: low-level call failed");
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
719      * `errorMessage` as a fallback revert reason when `target` reverts.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(
724         address target,
725         bytes memory data,
726         string memory errorMessage
727     ) internal returns (bytes memory) {
728         return functionCallWithValue(target, data, 0, errorMessage);
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
733      * but also transferring `value` wei to `target`.
734      *
735      * Requirements:
736      *
737      * - the calling contract must have an ETH balance of at least `value`.
738      * - the called Solidity function must be `payable`.
739      *
740      * _Available since v3.1._
741      */
742     function functionCallWithValue(
743         address target,
744         bytes memory data,
745         uint256 value
746     ) internal returns (bytes memory) {
747         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
752      * with `errorMessage` as a fallback revert reason when `target` reverts.
753      *
754      * _Available since v3.1._
755      */
756     function functionCallWithValue(
757         address target,
758         bytes memory data,
759         uint256 value,
760         string memory errorMessage
761     ) internal returns (bytes memory) {
762         require(address(this).balance >= value, "Address: insufficient balance for call");
763         require(isContract(target), "Address: call to non-contract");
764 
765         (bool success, bytes memory returndata) = target.call{value: value}(data);
766         return _verifyCallResult(success, returndata, errorMessage);
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
771      * but performing a static call.
772      *
773      * _Available since v3.3._
774      */
775     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
776         return functionStaticCall(target, data, "Address: low-level static call failed");
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(
786         address target,
787         bytes memory data,
788         string memory errorMessage
789     ) internal view returns (bytes memory) {
790         require(isContract(target), "Address: static call to non-contract");
791 
792         (bool success, bytes memory returndata) = target.staticcall(data);
793         return _verifyCallResult(success, returndata, errorMessage);
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
798      * but performing a delegate call.
799      *
800      * _Available since v3.4._
801      */
802     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
803         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(
813         address target,
814         bytes memory data,
815         string memory errorMessage
816     ) internal returns (bytes memory) {
817         require(isContract(target), "Address: delegate call to non-contract");
818 
819         (bool success, bytes memory returndata) = target.delegatecall(data);
820         return _verifyCallResult(success, returndata, errorMessage);
821     }
822 
823     function _verifyCallResult(
824         bool success,
825         bytes memory returndata,
826         string memory errorMessage
827     ) private pure returns (bytes memory) {
828         if (success) {
829             return returndata;
830         } else {
831             // Look for revert reason and bubble it up if present
832             if (returndata.length > 0) {
833                 // The easiest way to bubble the revert reason is using memory via assembly
834 
835                 assembly {
836                     let returndata_size := mload(returndata)
837                     revert(add(32, returndata), returndata_size)
838                 }
839             } else {
840                 revert(errorMessage);
841             }
842         }
843     }
844 }
845 
846 
847 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
848 
849 
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Implementation of the {IERC165} interface.
855  *
856  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
857  * for the additional interface id that will be supported. For example:
858  *
859  * ```solidity
860  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
861  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
862  * }
863  * ```
864  *
865  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
866  */
867 abstract contract ERC165 is IERC165 {
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
872         return interfaceId == type(IERC165).interfaceId;
873     }
874 }
875 
876 
877 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
878 
879 
880 
881 pragma solidity ^0.8.0;
882 
883 
884 
885 
886 
887 
888 
889 /**
890  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
891  * the Metadata extension, but not including the Enumerable extension, which is available separately as
892  * {ERC721Enumerable}.
893  */
894 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
895     using Address for address;
896     using Strings for uint256;
897 
898     // Token name
899     string private _name;
900 
901     // Token symbol
902     string private _symbol;
903 
904     // Mapping from token ID to owner address
905     mapping(uint256 => address) private _owners;
906 
907     // Mapping owner address to token count
908     mapping(address => uint256) private _balances;
909 
910     // Mapping from token ID to approved address
911     mapping(uint256 => address) private _tokenApprovals;
912 
913     // Mapping from owner to operator approvals
914     mapping(address => mapping(address => bool)) private _operatorApprovals;
915 
916     /**
917      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
918      */
919     constructor(string memory name_, string memory symbol_) {
920         _name = name_;
921         _symbol = symbol_;
922     }
923 
924     /**
925      * @dev See {IERC165-supportsInterface}.
926      */
927     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
928         return
929             interfaceId == type(IERC721).interfaceId ||
930             interfaceId == type(IERC721Metadata).interfaceId ||
931             super.supportsInterface(interfaceId);
932     }
933 
934     /**
935      * @dev See {IERC721-balanceOf}.
936      */
937     function balanceOf(address owner) public view virtual override returns (uint256) {
938         require(owner != address(0), "ERC721: balance query for the zero address");
939         return _balances[owner];
940     }
941 
942     /**
943      * @dev See {IERC721-ownerOf}.
944      */
945     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
946         address owner = _owners[tokenId];
947         require(owner != address(0), "ERC721: owner query for nonexistent token");
948         return owner;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-name}.
953      */
954     function name() public view virtual override returns (string memory) {
955         return _name;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-symbol}.
960      */
961     function symbol() public view virtual override returns (string memory) {
962         return _symbol;
963     }
964 
965     /**
966      * @dev See {IERC721Metadata-tokenURI}.
967      */
968     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
969         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
970 
971         string memory baseURI = _baseURI();
972         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
973     }
974 
975     /**
976      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
977      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
978      * by default, can be overriden in child contracts.
979      */
980     function _baseURI() internal view virtual returns (string memory) {
981         return "";
982     }
983 
984     /**
985      * @dev See {IERC721-approve}.
986      */
987     function approve(address to, uint256 tokenId) public virtual override {
988         address owner = ERC721.ownerOf(tokenId);
989         require(to != owner, "ERC721: approval to current owner");
990 
991         require(
992             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
993             "ERC721: approve caller is not owner nor approved for all"
994         );
995 
996         _approve(to, tokenId);
997     }
998 
999     /**
1000      * @dev See {IERC721-getApproved}.
1001      */
1002     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1003         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved) public virtual override {
1012         require(operator != _msgSender(), "ERC721: approve to caller");
1013 
1014         _operatorApprovals[_msgSender()][operator] = approved;
1015         emit ApprovalForAll(_msgSender(), operator, approved);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-isApprovedForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1022         return _operatorApprovals[owner][operator];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-transferFrom}.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         //solhint-disable-next-line max-line-length
1034         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1035 
1036         _transfer(from, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         safeTransferFrom(from, to, tokenId, "");
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) public virtual override {
1059         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1060         _safeTransfer(from, to, tokenId, _data);
1061     }
1062 
1063     /**
1064      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1065      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1066      *
1067      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1068      *
1069      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1070      * implement alternative mechanisms to perform token transfer, such as signature-based.
1071      *
1072      * Requirements:
1073      *
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      * - `tokenId` token must exist and be owned by `from`.
1077      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _safeTransfer(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) internal virtual {
1087         _transfer(from, to, tokenId);
1088         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1089     }
1090 
1091     /**
1092      * @dev Returns whether `tokenId` exists.
1093      *
1094      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1095      *
1096      * Tokens start existing when they are minted (`_mint`),
1097      * and stop existing when they are burned (`_burn`).
1098      */
1099     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1100         return _owners[tokenId] != address(0);
1101     }
1102 
1103     /**
1104      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1105      *
1106      * Requirements:
1107      *
1108      * - `tokenId` must exist.
1109      */
1110     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1111         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1112         address owner = ERC721.ownerOf(tokenId);
1113         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1114     }
1115 
1116     /**
1117      * @dev Safely mints `tokenId` and transfers it to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must not exist.
1122      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _safeMint(address to, uint256 tokenId) internal virtual {
1127         _safeMint(to, tokenId, "");
1128     }
1129 
1130     /**
1131      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1132      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1133      */
1134     function _safeMint(
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) internal virtual {
1139         _mint(to, tokenId);
1140         require(
1141             _checkOnERC721Received(address(0), to, tokenId, _data),
1142             "ERC721: transfer to non ERC721Receiver implementer"
1143         );
1144     }
1145 
1146     /**
1147      * @dev Mints `tokenId` and transfers it to `to`.
1148      *
1149      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1150      *
1151      * Requirements:
1152      *
1153      * - `tokenId` must not exist.
1154      * - `to` cannot be the zero address.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _mint(address to, uint256 tokenId) internal virtual {
1159         require(to != address(0), "ERC721: mint to the zero address");
1160         require(!_exists(tokenId), "ERC721: token already minted");
1161 
1162         _beforeTokenTransfer(address(0), to, tokenId);
1163 
1164         _balances[to] += 1;
1165         _owners[tokenId] = to;
1166 
1167         emit Transfer(address(0), to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev Destroys `tokenId`.
1172      * The approval is cleared when the token is burned.
1173      *
1174      * Requirements:
1175      *
1176      * - `tokenId` must exist.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _burn(uint256 tokenId) internal virtual {
1181         address owner = ERC721.ownerOf(tokenId);
1182 
1183         _beforeTokenTransfer(owner, address(0), tokenId);
1184 
1185         // Clear approvals
1186         _approve(address(0), tokenId);
1187 
1188         _balances[owner] -= 1;
1189         delete _owners[tokenId];
1190 
1191         emit Transfer(owner, address(0), tokenId);
1192     }
1193 
1194     /**
1195      * @dev Transfers `tokenId` from `from` to `to`.
1196      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1197      *
1198      * Requirements:
1199      *
1200      * - `to` cannot be the zero address.
1201      * - `tokenId` token must be owned by `from`.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _transfer(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) internal virtual {
1210         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1211         require(to != address(0), "ERC721: transfer to the zero address");
1212 
1213         _beforeTokenTransfer(from, to, tokenId);
1214 
1215         // Clear approvals from the previous owner
1216         _approve(address(0), tokenId);
1217 
1218         _balances[from] -= 1;
1219         _balances[to] += 1;
1220         _owners[tokenId] = to;
1221 
1222         emit Transfer(from, to, tokenId);
1223     }
1224 
1225     /**
1226      * @dev Approve `to` to operate on `tokenId`
1227      *
1228      * Emits a {Approval} event.
1229      */
1230     function _approve(address to, uint256 tokenId) internal virtual {
1231         _tokenApprovals[tokenId] = to;
1232         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1233     }
1234 
1235     /**
1236      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1237      * The call is not executed if the target address is not a contract.
1238      *
1239      * @param from address representing the previous owner of the given token ID
1240      * @param to target address that will receive the tokens
1241      * @param tokenId uint256 ID of the token to be transferred
1242      * @param _data bytes optional data to send along with the call
1243      * @return bool whether the call correctly returned the expected magic value
1244      */
1245     function _checkOnERC721Received(
1246         address from,
1247         address to,
1248         uint256 tokenId,
1249         bytes memory _data
1250     ) private returns (bool) {
1251         if (to.isContract()) {
1252             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1253                 return retval == IERC721Receiver(to).onERC721Received.selector;
1254             } catch (bytes memory reason) {
1255                 if (reason.length == 0) {
1256                     revert("ERC721: transfer to non ERC721Receiver implementer");
1257                 } else {
1258                     assembly {
1259                         revert(add(32, reason), mload(reason))
1260                     }
1261                 }
1262             }
1263         } else {
1264             return true;
1265         }
1266     }
1267 
1268     /**
1269      * @dev Hook that is called before any token transfer. This includes minting
1270      * and burning.
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` will be minted for `to`.
1277      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1278      * - `from` and `to` are never both zero.
1279      *
1280      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1281      */
1282     function _beforeTokenTransfer(
1283         address from,
1284         address to,
1285         uint256 tokenId
1286     ) internal virtual {}
1287 }
1288 
1289 
1290 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1291 
1292 
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 /**
1297  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1298  * @dev See https://eips.ethereum.org/EIPS/eip-721
1299  */
1300 interface IERC721Enumerable is IERC721 {
1301     /**
1302      * @dev Returns the total amount of tokens stored by the contract.
1303      */
1304     function totalSupply() external view returns (uint256);
1305 
1306     /**
1307      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1308      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1309      */
1310     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1311 
1312     /**
1313      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1314      * Use along with {totalSupply} to enumerate all tokens.
1315      */
1316     function tokenByIndex(uint256 index) external view returns (uint256);
1317 }
1318 
1319 
1320 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1321 
1322 
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 
1327 /**
1328  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1329  * enumerability of all the token ids in the contract as well as all token ids owned by each
1330  * account.
1331  */
1332 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1333     // Mapping from owner to list of owned token IDs
1334     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1335 
1336     // Mapping from token ID to index of the owner tokens list
1337     mapping(uint256 => uint256) private _ownedTokensIndex;
1338 
1339     // Array with all token ids, used for enumeration
1340     uint256[] private _allTokens;
1341 
1342     // Mapping from token id to position in the allTokens array
1343     mapping(uint256 => uint256) private _allTokensIndex;
1344 
1345     /**
1346      * @dev See {IERC165-supportsInterface}.
1347      */
1348     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1349         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1354      */
1355     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1356         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1357         return _ownedTokens[owner][index];
1358     }
1359 
1360     /**
1361      * @dev See {IERC721Enumerable-totalSupply}.
1362      */
1363     function totalSupply() public view virtual override returns (uint256) {
1364         return _allTokens.length;
1365     }
1366 
1367     /**
1368      * @dev See {IERC721Enumerable-tokenByIndex}.
1369      */
1370     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1371         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1372         return _allTokens[index];
1373     }
1374 
1375     /**
1376      * @dev Hook that is called before any token transfer. This includes minting
1377      * and burning.
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` will be minted for `to`.
1384      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1385      * - `from` cannot be the zero address.
1386      * - `to` cannot be the zero address.
1387      *
1388      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1389      */
1390     function _beforeTokenTransfer(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) internal virtual override {
1395         super._beforeTokenTransfer(from, to, tokenId);
1396 
1397         if (from == address(0)) {
1398             _addTokenToAllTokensEnumeration(tokenId);
1399         } else if (from != to) {
1400             _removeTokenFromOwnerEnumeration(from, tokenId);
1401         }
1402         if (to == address(0)) {
1403             _removeTokenFromAllTokensEnumeration(tokenId);
1404         } else if (to != from) {
1405             _addTokenToOwnerEnumeration(to, tokenId);
1406         }
1407     }
1408 
1409     /**
1410      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1411      * @param to address representing the new owner of the given token ID
1412      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1413      */
1414     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1415         uint256 length = ERC721.balanceOf(to);
1416         _ownedTokens[to][length] = tokenId;
1417         _ownedTokensIndex[tokenId] = length;
1418     }
1419 
1420     /**
1421      * @dev Private function to add a token to this extension's token tracking data structures.
1422      * @param tokenId uint256 ID of the token to be added to the tokens list
1423      */
1424     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1425         _allTokensIndex[tokenId] = _allTokens.length;
1426         _allTokens.push(tokenId);
1427     }
1428 
1429     /**
1430      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1431      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1432      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1433      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1434      * @param from address representing the previous owner of the given token ID
1435      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1436      */
1437     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1438         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1439         // then delete the last slot (swap and pop).
1440 
1441         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1442         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1443 
1444         // When the token to delete is the last token, the swap operation is unnecessary
1445         if (tokenIndex != lastTokenIndex) {
1446             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1447 
1448             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1449             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1450         }
1451 
1452         // This also deletes the contents at the last position of the array
1453         delete _ownedTokensIndex[tokenId];
1454         delete _ownedTokens[from][lastTokenIndex];
1455     }
1456 
1457     /**
1458      * @dev Private function to remove a token from this extension's token tracking data structures.
1459      * This has O(1) time complexity, but alters the order of the _allTokens array.
1460      * @param tokenId uint256 ID of the token to be removed from the tokens list
1461      */
1462     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1463         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1464         // then delete the last slot (swap and pop).
1465 
1466         uint256 lastTokenIndex = _allTokens.length - 1;
1467         uint256 tokenIndex = _allTokensIndex[tokenId];
1468 
1469         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1470         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1471         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1472         uint256 lastTokenId = _allTokens[lastTokenIndex];
1473 
1474         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1475         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1476 
1477         // This also deletes the contents at the last position of the array
1478         delete _allTokensIndex[tokenId];
1479         _allTokens.pop();
1480     }
1481 }
1482 
1483 
1484 // File contracts/Chibi.sol
1485 
1486 pragma solidity ^0.8.0;
1487 
1488 
1489 
1490 
1491 contract Chibi is ERC721Enumerable, Ownable {
1492     uint256 public constant TOTAL_CHIBI_AMOUNT = 5555;
1493     uint256 public constant MAX_PURCHASE = 10;
1494     uint256 public price = 55000000000000000;
1495 
1496     bool public isSaleOpen = false;
1497     string internal _baseTokenURI;
1498 
1499     using Strings for uint256;
1500 
1501     constructor(string memory baseURI) ERC721("chibilegends", "Chibi")  {
1502         changeBaseURI(baseURI);
1503     }
1504 
1505     /**
1506      **  Modifiers
1507      */ 
1508     modifier mintingIsAvailable{
1509         require(totalSupply() < TOTAL_CHIBI_AMOUNT, "No Chibi left to mint.");
1510         _;
1511     }
1512 
1513     /**
1514      **  onlyOwner functions
1515      */     
1516     function getBaseURI() public onlyOwner view returns (string memory) {
1517         return _baseURI();
1518     }
1519 
1520     function changeBaseURI(string memory baseURI) public onlyOwner {
1521         _baseTokenURI = baseURI;
1522     }
1523 
1524     function changePrice(uint _price) public onlyOwner {
1525         price = _price;
1526     }
1527 
1528     function changeSaleOpen(bool _open) public onlyOwner {
1529         isSaleOpen = _open;
1530     }
1531 
1532     function withdrawAll() public payable onlyOwner {
1533         require(payable(_msgSender()).send(address(this).balance));
1534     }
1535 
1536     /**
1537      **  Public functions
1538      */ 
1539     function mintChibi(uint256 qty) public payable mintingIsAvailable {
1540         if(msg.sender != owner()){
1541             require(isSaleOpen, "Sale is not open.");
1542         }
1543         require(totalSupply() < TOTAL_CHIBI_AMOUNT, "All Chibis are minted.");
1544         require(qty <= MAX_PURCHASE, "Buying too many per transaction.");
1545         require(SafeMath.add(totalSupply(), qty) <= TOTAL_CHIBI_AMOUNT, "Going over 5555 chibi with the purchase.");
1546         require(msg.value >= _getPrice(qty), "Invalid price.");
1547 
1548         for(uint256 i = 0; i < qty; i++) {
1549             _safeMint(msg.sender, totalSupply());
1550         }
1551     }
1552 
1553     function _baseURI() internal view virtual override returns (string memory) {
1554         return _baseTokenURI;
1555     }
1556 
1557     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1558         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1559 
1560         string memory baseURI = _baseURI();
1561         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")) : "";
1562     }
1563 
1564     /**
1565      **  Internal functions
1566      */ 
1567     function _getPrice(uint256 qty) internal view returns (uint256) {
1568         return price * qty;
1569     }
1570 }