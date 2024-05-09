1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (b > a) return (false, 0);
37             return (true, a - b);
38         }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49             // benefit is lost if 'b' is also tested.
50             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51             if (a == 0) return (true, 0);
52             uint256 c = a * b;
53             if (c / a != b) return (false, 0);
54             return (true, c);
55         }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (b == 0) return (false, 0);
66             return (true, a / b);
67         }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a % b);
79         }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         unchecked {
169             require(b <= a, errorMessage);
170             return a - b;
171         }
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         unchecked {
192             require(b > 0, errorMessage);
193             return a / b;
194         }
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         unchecked {
214             require(b > 0, errorMessage);
215             return a % b;
216         }
217     }
218 }
219 
220 // File: @openzeppelin/contracts/utils/Context.sol
221 
222 //
223 
224 pragma solidity ^0.8.0;
225 
226 /*
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
248 
249 //
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @dev Interface of the ERC165 standard, as defined in the
255  * https://eips.ethereum.org/EIPS/eip-165[EIP].
256  *
257  * Implementers can declare support of contract interfaces, which can then be
258  * queried by others ({ERC165Checker}).
259  *
260  * For an implementation, see {ERC165}.
261  */
262 interface IERC165 {
263     /**
264      * @dev Returns true if this contract implements the interface defined by
265      * `interfaceId`. See the corresponding
266      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
267      * to learn more about how these ids are created.
268      *
269      * This function call must use less than 30 000 gas.
270      */
271     function supportsInterface(bytes4 interfaceId) external view returns (bool);
272 }
273 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
274 
275 //
276 
277 pragma solidity ^0.8.0;
278 
279 
280 /**
281  * @dev Required interface of an ERC721 compliant contract.
282  */
283 interface IERC721 is IERC165 {
284     /**
285      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
286      */
287     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
288 
289     /**
290      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
291      */
292     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
293 
294     /**
295      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
296      */
297     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
298 
299     /**
300      * @dev Returns the number of tokens in ``owner``'s account.
301      */
302     function balanceOf(address owner) external view returns (uint256 balance);
303 
304     /**
305      * @dev Returns the owner of the `tokenId` token.
306      *
307      * Requirements:
308      *
309      * - `tokenId` must exist.
310      */
311     function ownerOf(uint256 tokenId) external view returns (address owner);
312 
313     /**
314      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
315      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must exist and be owned by `from`.
322      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
323      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
324      *
325      * Emits a {Transfer} event.
326      */
327     function safeTransferFrom(address from, address to, uint256 tokenId) external;
328 
329     /**
330      * @dev Transfers `tokenId` token from `from` to `to`.
331      *
332      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
333      *
334      * Requirements:
335      *
336      * - `from` cannot be the zero address.
337      * - `to` cannot be the zero address.
338      * - `tokenId` token must be owned by `from`.
339      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
340      *
341      * Emits a {Transfer} event.
342      */
343     function transferFrom(address from, address to, uint256 tokenId) external;
344 
345     /**
346      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
347      * The approval is cleared when the token is transferred.
348      *
349      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
350      *
351      * Requirements:
352      *
353      * - The caller must own the token or be an approved operator.
354      * - `tokenId` must exist.
355      *
356      * Emits an {Approval} event.
357      */
358     function approve(address to, uint256 tokenId) external;
359 
360     /**
361      * @dev Returns the account approved for `tokenId` token.
362      *
363      * Requirements:
364      *
365      * - `tokenId` must exist.
366      */
367     function getApproved(uint256 tokenId) external view returns (address operator);
368 
369     /**
370      * @dev Approve or remove `operator` as an operator for the caller.
371      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
372      *
373      * Requirements:
374      *
375      * - The `operator` cannot be the caller.
376      *
377      * Emits an {ApprovalForAll} event.
378      */
379     function setApprovalForAll(address operator, bool _approved) external;
380 
381     /**
382      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
383      *
384      * See {setApprovalForAll}
385      */
386     function isApprovedForAll(address owner, address operator) external view returns (bool);
387 
388     /**
389       * @dev Safely transfers `tokenId` token from `from` to `to`.
390       *
391       * Requirements:
392       *
393       * - `from` cannot be the zero address.
394       * - `to` cannot be the zero address.
395       * - `tokenId` token must exist and be owned by `from`.
396       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
397       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398       *
399       * Emits a {Transfer} event.
400       */
401     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
402 }
403 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
404 
405 //
406 
407 pragma solidity ^0.8.0;
408 
409 
410 /**
411  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
412  * @dev See https://eips.ethereum.org/EIPS/eip-721
413  */
414 interface IERC721Enumerable is IERC721 {
415 
416     /**
417      * @dev Returns the total amount of tokens stored by the contract.
418      */
419     function totalSupply() external view returns (uint256);
420 
421     /**
422      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
423      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
424      */
425     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
426 
427     /**
428      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
429      * Use along with {totalSupply} to enumerate all tokens.
430      */
431     function tokenByIndex(uint256 index) external view returns (uint256);
432 }
433 
434 
435 // File: @openzeppelin/contracts/access/Ownable.sol
436 
437 //
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Contract module which provides a basic access control mechanism, where
443  * there is an account (an owner) that can be granted exclusive access to
444  * specific functions.
445  *
446  * By default, the owner account will be the one that deploys the contract. This
447  * can later be changed with {transferOwnership}.
448  *
449  * This module is used through inheritance. It will make available the modifier
450  * `onlyOwner`, which can be applied to your functions to restrict their use to
451  * the owner.
452  */
453 abstract contract Ownable is Context {
454     address private _owner;
455 
456     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
457 
458     /**
459      * @dev Initializes the contract setting the deployer as the initial owner.
460      */
461     constructor () {
462         address msgSender = _msgSender();
463         _owner = msgSender;
464         emit OwnershipTransferred(address(0), msgSender);
465     }
466 
467     /**
468      * @dev Returns the address of the current owner.
469      */
470     function owner() public view virtual returns (address) {
471         return _owner;
472     }
473 
474     /**
475      * @dev Throws if called by any account other than the owner.
476      */
477     modifier onlyOwner() {
478         require(owner() == _msgSender(), "Ownable: caller is not the owner");
479         _;
480     }
481 
482     /**
483      * @dev Leaves the contract without owner. It will not be possible to call
484      * `onlyOwner` functions anymore. Can only be called by the current owner.
485      *
486      * NOTE: Renouncing ownership will leave the contract without an owner,
487      * thereby removing any functionality that is only available to the owner.
488      */
489     function renounceOwnership() public virtual onlyOwner {
490         emit OwnershipTransferred(_owner, address(0));
491         _owner = address(0);
492     }
493 
494     /**
495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
496      * Can only be called by the current owner.
497      */
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(newOwner != address(0), "Ownable: new owner is the zero address");
500         emit OwnershipTransferred(_owner, newOwner);
501         _owner = newOwner;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
506 
507 //
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Strings.sol
536 
537 //
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant alphabet = "0123456789abcdef";
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         // Inspired by OraclizeAPI's implementation - MIT licence
552         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
553 
554         if (value == 0) {
555             return "0";
556         }
557         uint256 temp = value;
558         uint256 digits;
559         while (temp != 0) {
560             digits++;
561             temp /= 10;
562         }
563         bytes memory buffer = new bytes(digits);
564         while (value != 0) {
565             digits -= 1;
566             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
567             value /= 10;
568         }
569         return string(buffer);
570     }
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         if (value == 0) {
577             return "0x00";
578         }
579         uint256 temp = value;
580         uint256 length = 0;
581         while (temp != 0) {
582             length++;
583             temp >>= 8;
584         }
585         return toHexString(value, length);
586     }
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
590      */
591     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
592         bytes memory buffer = new bytes(2 * length + 2);
593         buffer[0] = "0";
594         buffer[1] = "x";
595         for (uint256 i = 2 * length + 1; i > 1; --i) {
596             buffer[i] = alphabet[value & 0xf];
597             value >>= 4;
598         }
599         require(value == 0, "Strings: hex length insufficient");
600         return string(buffer);
601     }
602 
603 }
604 
605 // File: @openzeppelin/contracts/utils/Address.sol
606 
607 //
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Collection of functions related to the address type
613  */
614 library Address {
615     /**
616      * @dev Returns true if `account` is a contract.
617      *
618      * [IMPORTANT]
619      * ====
620      * It is unsafe to assume that an address for which this function returns
621      * false is an externally-owned account (EOA) and not a contract.
622      *
623      * Among others, `isContract` will return false for the following
624      * types of addresses:
625      *
626      *  - an externally-owned account
627      *  - a contract in construction
628      *  - an address where a contract will be created
629      *  - an address where a contract lived, but was destroyed
630      * ====
631      */
632     function isContract(address account) internal view returns (bool) {
633         // This method relies on extcodesize, which returns 0 for contracts in
634         // construction, since the code is only stored at the end of the
635         // constructor execution.
636 
637         uint256 size;
638         // solhint-disable-next-line no-inline-assembly
639         assembly { size := extcodesize(account) }
640         return size > 0;
641     }
642 
643     /**
644      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
645      * `recipient`, forwarding all available gas and reverting on errors.
646      *
647      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
648      * of certain opcodes, possibly making contracts go over the 2300 gas limit
649      * imposed by `transfer`, making them unable to receive funds via
650      * `transfer`. {sendValue} removes this limitation.
651      *
652      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
653      *
654      * IMPORTANT: because control is transferred to `recipient`, care must be
655      * taken to not create reentrancy vulnerabilities. Consider using
656      * {ReentrancyGuard} or the
657      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
658      */
659     function sendValue(address payable recipient, uint256 amount) internal {
660         require(address(this).balance >= amount, "Address: insufficient balance");
661 
662         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
663         (bool success, ) = recipient.call{ value: amount }("");
664         require(success, "Address: unable to send value, recipient may have reverted");
665     }
666 
667     /**
668      * @dev Performs a Solidity function call using a low level `call`. A
669      * plain`call` is an unsafe replacement for a function call: use this
670      * function instead.
671      *
672      * If `target` reverts with a revert reason, it is bubbled up by this
673      * function (like regular Solidity function calls).
674      *
675      * Returns the raw returned data. To convert to the expected return value,
676      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
677      *
678      * Requirements:
679      *
680      * - `target` must be a contract.
681      * - calling `target` with `data` must not revert.
682      *
683      * _Available since v3.1._
684      */
685     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
686       return functionCall(target, data, "Address: low-level call failed");
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
691      * `errorMessage` as a fallback revert reason when `target` reverts.
692      *
693      * _Available since v3.1._
694      */
695     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
696         return functionCallWithValue(target, data, 0, errorMessage);
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
701      * but also transferring `value` wei to `target`.
702      *
703      * Requirements:
704      *
705      * - the calling contract must have an ETH balance of at least `value`.
706      * - the called Solidity function must be `payable`.
707      *
708      * _Available since v3.1._
709      */
710     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
711         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
716      * with `errorMessage` as a fallback revert reason when `target` reverts.
717      *
718      * _Available since v3.1._
719      */
720     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
721         require(address(this).balance >= value, "Address: insufficient balance for call");
722         require(isContract(target), "Address: call to non-contract");
723 
724         // solhint-disable-next-line avoid-low-level-calls
725         (bool success, bytes memory returndata) = target.call{ value: value }(data);
726         return _verifyCallResult(success, returndata, errorMessage);
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
731      * but performing a static call.
732      *
733      * _Available since v3.3._
734      */
735     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
736         return functionStaticCall(target, data, "Address: low-level static call failed");
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
741      * but performing a static call.
742      *
743      * _Available since v3.3._
744      */
745     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
746         require(isContract(target), "Address: static call to non-contract");
747 
748         // solhint-disable-next-line avoid-low-level-calls
749         (bool success, bytes memory returndata) = target.staticcall(data);
750         return _verifyCallResult(success, returndata, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but performing a delegate call.
756      *
757      * _Available since v3.4._
758      */
759     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
760         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
765      * but performing a delegate call.
766      *
767      * _Available since v3.4._
768      */
769     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
770         require(isContract(target), "Address: delegate call to non-contract");
771 
772         // solhint-disable-next-line avoid-low-level-calls
773         (bool success, bytes memory returndata) = target.delegatecall(data);
774         return _verifyCallResult(success, returndata, errorMessage);
775     }
776 
777     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
778         if (success) {
779             return returndata;
780         } else {
781             // Look for revert reason and bubble it up if present
782             if (returndata.length > 0) {
783                 // The easiest way to bubble the revert reason is using memory via assembly
784 
785                 // solhint-disable-next-line no-inline-assembly
786                 assembly {
787                     let returndata_size := mload(returndata)
788                     revert(add(32, returndata), returndata_size)
789                 }
790             } else {
791                 revert(errorMessage);
792             }
793         }
794     }
795 }
796 
797 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
798 
799 //
800 
801 pragma solidity ^0.8.0;
802 
803 
804 /**
805  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
806  * @dev See https://eips.ethereum.org/EIPS/eip-721
807  */
808 interface IERC721Metadata is IERC721 {
809 
810     /**
811      * @dev Returns the token collection name.
812      */
813     function name() external view returns (string memory);
814 
815     /**
816      * @dev Returns the token collection symbol.
817      */
818     function symbol() external view returns (string memory);
819 
820     /**
821      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
822      */
823     function tokenURI(uint256 tokenId) external view returns (string memory);
824 }
825 
826 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
827 
828 //
829 
830 pragma solidity ^0.8.0;
831 
832 /**
833  * @title ERC721 token receiver interface
834  * @dev Interface for any contract that wants to support safeTransfers
835  * from ERC721 asset contracts.
836  */
837 interface IERC721Receiver {
838     /**
839      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
840      * by `operator` from `from`, this function is called.
841      *
842      * It must return its Solidity selector to confirm the token transfer.
843      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
844      *
845      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
846      */
847     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
848 }
849 
850 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
851 
852 //
853 
854 pragma solidity ^0.8.0;
855 
856 
857 
858 
859 
860 
861 
862 
863 
864 /**
865  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
866  * the Metadata extension, but not including the Enumerable extension, which is available separately as
867  * {ERC721Enumerable}.
868  */
869 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
870     using Address for address;
871     using Strings for uint256;
872 
873     // Token name
874     string private _name;
875 
876     // Token symbol
877     string private _symbol;
878 
879     // Mapping from token ID to owner address
880     mapping (uint256 => address) private _owners;
881 
882     // Mapping owner address to token count
883     mapping (address => uint256) private _balances;
884 
885     // Mapping from token ID to approved address
886     mapping (uint256 => address) private _tokenApprovals;
887 
888     // Mapping from owner to operator approvals
889     mapping (address => mapping (address => bool)) private _operatorApprovals;
890 
891     /**
892      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
893      */
894     constructor (string memory name_, string memory symbol_) {
895         _name = name_;
896         _symbol = symbol_;
897     }
898 
899     /**
900      * @dev See {IERC165-supportsInterface}.
901      */
902     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
903         return interfaceId == type(IERC721).interfaceId
904             || interfaceId == type(IERC721Metadata).interfaceId
905             || super.supportsInterface(interfaceId);
906     }
907 
908     /**
909      * @dev See {IERC721-balanceOf}.
910      */
911     function balanceOf(address owner) public view virtual override returns (uint256) {
912         require(owner != address(0), "ERC721: balance query for the zero address");
913         return _balances[owner];
914     }
915 
916     /**
917      * @dev See {IERC721-ownerOf}.
918      */
919     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
920         address owner = _owners[tokenId];
921         require(owner != address(0), "ERC721: owner query for nonexistent token");
922         return owner;
923     }
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-tokenURI}.
941      */
942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
943         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
944 
945         string memory baseURI = _baseURI();
946         return bytes(baseURI).length > 0
947             ? string(abi.encodePacked(baseURI, tokenId.toString()))
948             : '';
949     }
950 
951     /**
952      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
953      * in child contracts.
954      */
955     function _baseURI() internal view virtual returns (string memory) {
956         return "";
957     }
958 
959     /**
960      * @dev See {IERC721-approve}.
961      */
962     function approve(address to, uint256 tokenId) public virtual override {
963         address owner = ERC721.ownerOf(tokenId);
964         require(to != owner, "ERC721: approval to current owner");
965 
966         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
967             "ERC721: approve caller is not owner nor approved for all"
968         );
969 
970         _approve(to, tokenId);
971     }
972 
973     /**
974      * @dev See {IERC721-getApproved}.
975      */
976     function getApproved(uint256 tokenId) public view virtual override returns (address) {
977         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
978 
979         return _tokenApprovals[tokenId];
980     }
981 
982     /**
983      * @dev See {IERC721-setApprovalForAll}.
984      */
985     function setApprovalForAll(address operator, bool approved) public virtual override {
986         require(operator != _msgSender(), "ERC721: approve to caller");
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1003         //solhint-disable-next-line max-line-length
1004         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1005 
1006         _transfer(from, to, tokenId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-safeTransferFrom}.
1011      */
1012     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1013         safeTransferFrom(from, to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1020         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1021         _safeTransfer(from, to, tokenId, _data);
1022     }
1023 
1024     /**
1025      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1026      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1027      *
1028      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1029      *
1030      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1031      * implement alternative mechanisms to perform token transfer, such as signature-based.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must exist and be owned by `from`.
1038      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1043         _transfer(from, to, tokenId);
1044         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      * and stop existing when they are burned (`_burn`).
1054      */
1055     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1056         return _owners[tokenId] != address(0);
1057     }
1058 
1059     /**
1060      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1067         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1068         address owner = ERC721.ownerOf(tokenId);
1069         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1070     }
1071 
1072     /**
1073      * @dev Safely mints `tokenId` and transfers it to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must not exist.
1078      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _safeMint(address to, uint256 tokenId) internal virtual {
1083         _safeMint(to, tokenId, "");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1088      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1089      */
1090     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1091         _mint(to, tokenId);
1092         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1093     }
1094 
1095     /**
1096      * @dev Mints `tokenId` and transfers it to `to`.
1097      *
1098      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1099      *
1100      * Requirements:
1101      *
1102      * - `tokenId` must not exist.
1103      * - `to` cannot be the zero address.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _mint(address to, uint256 tokenId) internal virtual {
1108         require(to != address(0), "ERC721: mint to the zero address");
1109         require(!_exists(tokenId), "ERC721: token already minted");
1110 
1111         _beforeTokenTransfer(address(0), to, tokenId);
1112 
1113         _balances[to] += 1;
1114         _owners[tokenId] = to;
1115 
1116         emit Transfer(address(0), to, tokenId);
1117     }
1118 
1119     /**
1120      * @dev Destroys `tokenId`.
1121      * The approval is cleared when the token is burned.
1122      *
1123      * Requirements:
1124      *
1125      * - `tokenId` must exist.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _burn(uint256 tokenId) internal virtual {
1130         address owner = ERC721.ownerOf(tokenId);
1131 
1132         _beforeTokenTransfer(owner, address(0), tokenId);
1133 
1134         // Clear approvals
1135         _approve(address(0), tokenId);
1136 
1137         _balances[owner] -= 1;
1138         delete _owners[tokenId];
1139 
1140         emit Transfer(owner, address(0), tokenId);
1141     }
1142 
1143     /**
1144      * @dev Transfers `tokenId` from `from` to `to`.
1145      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must be owned by `from`.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1155         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1156         require(to != address(0), "ERC721: transfer to the zero address");
1157 
1158         _beforeTokenTransfer(from, to, tokenId);
1159 
1160         // Clear approvals from the previous owner
1161         _approve(address(0), tokenId);
1162 
1163         _balances[from] -= 1;
1164         _balances[to] += 1;
1165         _owners[tokenId] = to;
1166 
1167         emit Transfer(from, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev Approve `to` to operate on `tokenId`
1172      *
1173      * Emits a {Approval} event.
1174      */
1175     function _approve(address to, uint256 tokenId) internal virtual {
1176         _tokenApprovals[tokenId] = to;
1177         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1182      * The call is not executed if the target address is not a contract.
1183      *
1184      * @param from address representing the previous owner of the given token ID
1185      * @param to target address that will receive the tokens
1186      * @param tokenId uint256 ID of the token to be transferred
1187      * @param _data bytes optional data to send along with the call
1188      * @return bool whether the call correctly returned the expected magic value
1189      */
1190     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1191         private returns (bool)
1192     {
1193         if (to.isContract()) {
1194             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1195                 return retval == IERC721Receiver(to).onERC721Received.selector;
1196             } catch (bytes memory reason) {
1197                 if (reason.length == 0) {
1198                     revert("ERC721: transfer to non ERC721Receiver implementer");
1199                 } else {
1200                     // solhint-disable-next-line no-inline-assembly
1201                     assembly {
1202                         revert(add(32, reason), mload(reason))
1203                     }
1204                 }
1205             }
1206         } else {
1207             return true;
1208         }
1209     }
1210 
1211     /**
1212      * @dev Hook that is called before any token transfer. This includes minting
1213      * and burning.
1214      *
1215      * Calling conditions:
1216      *
1217      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1218      * transferred to `to`.
1219      * - When `from` is zero, `tokenId` will be minted for `to`.
1220      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1221      * - `from` cannot be the zero address.
1222      * - `to` cannot be the zero address.
1223      *
1224      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1225      */
1226     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1227 }
1228 
1229 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1230 
1231 //
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 
1236 
1237 /**
1238  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1239  * enumerability of all the token ids in the contract as well as all token ids owned by each
1240  * account.
1241  */
1242 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1243     // Mapping from owner to list of owned token IDs
1244     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1245 
1246     // Mapping from token ID to index of the owner tokens list
1247     mapping(uint256 => uint256) private _ownedTokensIndex;
1248 
1249     // Array with all token ids, used for enumeration
1250     uint256[] private _allTokens;
1251 
1252     // Mapping from token id to position in the allTokens array
1253     mapping(uint256 => uint256) private _allTokensIndex;
1254 
1255     /**
1256      * @dev See {IERC165-supportsInterface}.
1257      */
1258     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1259         return interfaceId == type(IERC721Enumerable).interfaceId
1260             || super.supportsInterface(interfaceId);
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1265      */
1266     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1267         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1268         return _ownedTokens[owner][index];
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Enumerable-totalSupply}.
1273      */
1274     function totalSupply() public view virtual override returns (uint256) {
1275         return _allTokens.length;
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-tokenByIndex}.
1280      */
1281     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1282         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1283         return _allTokens[index];
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before any token transfer. This includes minting
1288      * and burning.
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      *
1299      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1300      */
1301     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1302         super._beforeTokenTransfer(from, to, tokenId);
1303 
1304         if (from == address(0)) {
1305             _addTokenToAllTokensEnumeration(tokenId);
1306         } else if (from != to) {
1307             _removeTokenFromOwnerEnumeration(from, tokenId);
1308         }
1309         if (to == address(0)) {
1310             _removeTokenFromAllTokensEnumeration(tokenId);
1311         } else if (to != from) {
1312             _addTokenToOwnerEnumeration(to, tokenId);
1313         }
1314     }
1315 
1316     /**
1317      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1318      * @param to address representing the new owner of the given token ID
1319      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1320      */
1321     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1322         uint256 length = ERC721.balanceOf(to);
1323         _ownedTokens[to][length] = tokenId;
1324         _ownedTokensIndex[tokenId] = length;
1325     }
1326 
1327     /**
1328      * @dev Private function to add a token to this extension's token tracking data structures.
1329      * @param tokenId uint256 ID of the token to be added to the tokens list
1330      */
1331     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1332         _allTokensIndex[tokenId] = _allTokens.length;
1333         _allTokens.push(tokenId);
1334     }
1335 
1336     /**
1337      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1338      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1339      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1340      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1341      * @param from address representing the previous owner of the given token ID
1342      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1343      */
1344     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1345         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1346         // then delete the last slot (swap and pop).
1347 
1348         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1349         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1350 
1351         // When the token to delete is the last token, the swap operation is unnecessary
1352         if (tokenIndex != lastTokenIndex) {
1353             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1354 
1355             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1356             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1357         }
1358 
1359         // This also deletes the contents at the last position of the array
1360         delete _ownedTokensIndex[tokenId];
1361         delete _ownedTokens[from][lastTokenIndex];
1362     }
1363 
1364     /**
1365      * @dev Private function to remove a token from this extension's token tracking data structures.
1366      * This has O(1) time complexity, but alters the order of the _allTokens array.
1367      * @param tokenId uint256 ID of the token to be removed from the tokens list
1368      */
1369     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1370         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1371         // then delete the last slot (swap and pop).
1372 
1373         uint256 lastTokenIndex = _allTokens.length - 1;
1374         uint256 tokenIndex = _allTokensIndex[tokenId];
1375 
1376         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1377         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1378         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1379         uint256 lastTokenId = _allTokens[lastTokenIndex];
1380 
1381         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1382         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1383 
1384         // This also deletes the contents at the last position of the array
1385         delete _allTokensIndex[tokenId];
1386         _allTokens.pop();
1387     }
1388 }
1389 
1390 // File: contracts/HashScapes.sol
1391 
1392 pragma solidity ^0.8.0;
1393 
1394 contract HashScapes is ERC721Enumerable, Ownable {
1395     using SafeMath for uint256;
1396     struct CoinBalance {
1397         uint256 balance;
1398         uint256 dividend;
1399         uint256 lastTimestamp;
1400     }
1401 
1402     uint public constant MAX_HASHSCAPES = 7777;
1403     uint public constant NUMBER_RESERVED = 25;
1404     uint public constant PRICE = 20000000000000000; // 0.02 ETH each
1405     string public METADATA_PROVENANCE_HASH = "";
1406 
1407     string public baseURI = "";
1408     uint private curIndex = NUMBER_RESERVED.add(1);
1409     bool public hasSaleStarted = false;
1410     mapping(uint => CoinBalance) private bankerBalances; // mapping of HashScapes IDs to their "Coin Balance"
1411 
1412     constructor() ERC721("HashScapes","HASHSCAPES")  {
1413     }
1414     
1415     /** HASHSCAPES BALANCE */
1416     
1417     /** Each HashScape is initialized with a balance of 0
1418      * and dividend rate of 10. This means the HashScape's
1419      * balance increases at a base rate of 10/day. */
1420     function initializeCoinBalance(uint id) private {
1421         bankerBalances[id] = CoinBalance(0, 10, block.timestamp);
1422     }
1423     
1424     function getCoinBalance(uint id) public view returns (uint256) {
1425         /* Note on `bankerBalances[id].dividend >= 10`: The
1426         * `dividend` is initialized at 10, and it can never
1427         * be decreased. Therefore, `dividend < 10` means
1428         * the HashScape has not been minted yet. */
1429         require(bankerBalances[id].dividend >= 10, "That HashScape has not been minted yet.");
1430         CoinBalance storage coinBalance = bankerBalances[id];
1431         /* `lastTimestamp` is a variable that serves to cache
1432         * the HashScape's value. This is to save on gas--this
1433         * function will return to correct balance without
1434         * having to update the `balance` until necessary. */
1435         return coinBalance.balance.add(coinBalance.dividend.mul(block.timestamp.sub(coinBalance.lastTimestamp)).div(86400)); // 86400 seconds is 1 day.
1436     }
1437     
1438     /** Each HashScape's dividend is initialized at 10/day.
1439      * However, one can spend 0.003 ETH to upgrade it.
1440      * This way, certain HashScapes can accumulate balance
1441      * quicker. */
1442     function upgradeCoinDividend(uint id, uint256 amount) public payable {
1443         require(bankerBalances[id].dividend >= 10, "That HashScape has not been minted yet.");
1444         require(msg.value >= amount.mul(3000000000000000)); // 0.003 ETH
1445         CoinBalance storage coinBalance = bankerBalances[id];
1446         /* `getCoinBalance` must be used to retrieve the
1447         * live balance. Then, this must be updated to
1448         * ensure it will work the next time it is called.
1449         * As mentioned earlier, `lastTimestamp` serves
1450         * as a cached value to minimize gas usage. Thus,
1451         * it must also be updated. */
1452         coinBalance.balance = getCoinBalance(id);
1453         coinBalance.lastTimestamp = block.timestamp;
1454         coinBalance.dividend = coinBalance.dividend.add(amount);
1455     }
1456     
1457     /** This function takes in an array of HashScape IDs
1458      * and an array of balances to spend from them. Thus,
1459      * there must be no duplicate IDs and the arrays should
1460      * be of equal length. It is important to note that
1461      * the owner's ability to select WHICH HashScapes to
1462      * spend balance from is crucial to maintain their
1463      * value. btw DM frosty on Discord for a special role :) */
1464     function spendCoinBalance(uint[] memory hashscapeIds, uint256[] memory amountToSpend) public returns (uint256) {
1465         require(hashscapeIds.length == amountToSpend.length, "You must provide a 1-to-1 relationship of balance amounts to spend from your HashScapes.");
1466         require(!checkDuplicates(hashscapeIds), "You may not buy from the same coin per transaction.");
1467         require(hashscapeIds.length <= 10, "You can only spend from 10 HashScapes at a time.");
1468         uint256 totalSpent = 0;
1469         // Loop through first to make sure the owner actually owns all their HashScapes and has enough balance in them.
1470         for (uint i = 0; i < hashscapeIds.length; i++) {
1471             uint id = hashscapeIds[i];
1472             uint256 amount = amountToSpend[i];
1473             require(msg.sender == ownerOf(id), "You do not own the HashScapes you specified.");
1474             require(getCoinBalance(id) >= amount, "Insufficient HashScapes balance.");
1475         }
1476         // See `upgradeCoinDividend` comments for explanation on why the HashScapes' balances and `lastTimestamp` are updated.
1477         for (uint i = 0; i < hashscapeIds.length; i++) {
1478             uint id = hashscapeIds[i];
1479             uint amount = amountToSpend[i];
1480             CoinBalance storage coinBalance = bankerBalances[id];
1481             coinBalance.balance = getCoinBalance(id).sub(amount);
1482             coinBalance.lastTimestamp = block.timestamp;
1483             totalSpent = totalSpent.add(amount);
1484         }
1485         // The total balance that was spent is returned, so it can be used with future apps and integrations.
1486         return totalSpent;
1487     }
1488     
1489     /** O(n^2) algorithm to check for duplicate integers
1490      * in an array. For small input (in this case, <= 10),
1491      * the algorithm is good. Thus, gas is not wasted. */
1492     function checkDuplicates(uint[] memory arr) private pure returns (bool) {
1493         for (uint i = 0; i < arr.length; i++) {
1494             for (uint j = i + 1; j < arr.length; j++) {
1495                 if (arr[i] == arr[j]) {
1496                     return true;
1497                 }
1498             }
1499         }
1500         return false;
1501     }
1502     
1503     /** NFT */
1504     
1505     function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
1506         uint256 tokenCount = balanceOf(_owner);
1507         if (tokenCount == 0) {
1508             return new uint256[](0);
1509         } else {
1510             uint256[] memory result = new uint256[](tokenCount);
1511             uint256 index;
1512             for (index = 0; index < tokenCount; index++) {
1513                 result[index] = tokenOfOwnerByIndex(_owner, index);
1514             }
1515             return result;
1516         }
1517     }
1518 
1519     function buyHashScape(uint256 numHashScapes) public payable {
1520         require(hasSaleStarted, "Sale is not active.");
1521         require(totalSupply() < MAX_HASHSCAPES, "Sale has ended.");
1522         require(numHashScapes > 0 && numHashScapes <= 40, "You can buy a maximum of 40 HashScapes at a time.");
1523         require(totalSupply().add(numHashScapes) <= MAX_HASHSCAPES, "All HashScapes have been sold!");
1524         require(msg.value >= numHashScapes.mul(PRICE), "Insufficient ETH funds.");
1525         for (uint i = 0; i < numHashScapes; i++) {
1526             _safeMint(msg.sender, curIndex);
1527             initializeCoinBalance(curIndex);
1528             adjustIndex();
1529         }
1530     }
1531 
1532     // Skip % 1111 == 0 since they are reserved
1533     function adjustIndex() private {
1534         curIndex++;
1535         if (curIndex % 1111 == 0) {
1536             curIndex++;
1537         }
1538     }
1539 
1540     function getCurrentIndex() public view returns (uint) {
1541         return curIndex;
1542     }
1543 
1544     function setProvenanceHash(string memory _hash) public onlyOwner {
1545         METADATA_PROVENANCE_HASH = _hash;
1546     }
1547 
1548     function setBaseURI(string memory newBaseURI) public onlyOwner {
1549         baseURI = newBaseURI;
1550     }
1551 
1552     function _baseURI() internal view virtual override returns (string memory) {
1553         return getBaseURI();
1554     }
1555     
1556     function getBaseURI() public view returns (string memory) {
1557         return baseURI;
1558     }
1559 
1560     function flipSaleState() public onlyOwner {
1561         hasSaleStarted = !hasSaleStarted;
1562     }
1563 
1564     function withdrawAll() public payable onlyOwner {
1565         require(payable(msg.sender).send(address(this).balance));
1566     }
1567 
1568     function reserve() public onlyOwner {
1569         // Reserve first `NUMBER_RESERVED` HashScapes and all those `INDEX % 1111 == 0` for charity event.
1570         for (uint i = 1; i <= NUMBER_RESERVED; i++) {
1571             initializeCoinBalance(i);
1572             _safeMint(owner(), i);
1573         }
1574         for (uint i = 1111; i <= MAX_HASHSCAPES; i += 1111) {
1575             initializeCoinBalance(i);
1576             _safeMint(owner(), i);
1577         }
1578     }
1579 
1580     function reserveCur() public onlyOwner {
1581         require(totalSupply() < MAX_HASHSCAPES, "Sale has already ended");
1582         initializeCoinBalance(curIndex);
1583         _safeMint(owner(), curIndex);
1584         adjustIndex();
1585     }
1586 }