1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity >=0.7.0 <0.9.0;
3 
4 interface IERC165 {
5     /**
6      * @dev Returns true if this contract implements the interface defined by
7      * `interfaceId`. See the corresponding
8      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
9      * to learn more about how these ids are created.
10      *
11      * This function call must use less than 30 000 gas.
12      */
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 
16 library Strings {
17     bytes16 private constant alphabet = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = alphabet[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 
75 }
76 
77 library Address {
78     /**
79      * @dev Returns true if `account` is a contract.
80      *
81      * [IMPORTANT]
82      * ====
83      * It is unsafe to assume that an address for which this function returns
84      * false is an externally-owned account (EOA) and not a contract.
85      *
86      * Among others, `isContract` will return false for the following
87      * types of addresses:
88      *
89      *  - an externally-owned account
90      *  - a contract in construction
91      *  - an address where a contract will be created
92      *  - an address where a contract lived, but was destroyed
93      * ====
94      */
95     function isContract(address account) internal view returns (bool) {
96         // This method relies on extcodesize, which returns 0 for contracts in
97         // construction, since the code is only stored at the end of the
98         // constructor execution.
99 
100         uint256 size;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { size := extcodesize(account) }
103         return size > 0;
104     }
105 
106     /**
107      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
108      * `recipient`, forwarding all available gas and reverting on errors.
109      *
110      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
111      * of certain opcodes, possibly making contracts go over the 2300 gas limit
112      * imposed by `transfer`, making them unable to receive funds via
113      * `transfer`. {sendValue} removes this limitation.
114      *
115      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
116      *
117      * IMPORTANT: because control is transferred to `recipient`, care must be
118      * taken to not create reentrancy vulnerabilities. Consider using
119      * {ReentrancyGuard} or the
120      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
121      */
122     function sendValue(address payable recipient, uint256 amount) internal {
123         require(address(this).balance >= amount, "Address: insufficient balance");
124 
125         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
126         (bool success, ) = recipient.call{ value: amount }("");
127         require(success, "Address: unable to send value, recipient may have reverted");
128     }
129 
130     /**
131      * @dev Performs a Solidity function call using a low level `call`. A
132      * plain`call` is an unsafe replacement for a function call: use this
133      * function instead.
134      *
135      * If `target` reverts with a revert reason, it is bubbled up by this
136      * function (like regular Solidity function calls).
137      *
138      * Returns the raw returned data. To convert to the expected return value,
139      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
140      *
141      * Requirements:
142      *
143      * - `target` must be a contract.
144      * - calling `target` with `data` must not revert.
145      *
146      * _Available since v3.1._
147      */
148     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
149       return functionCall(target, data, "Address: low-level call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
154      * `errorMessage` as a fallback revert reason when `target` reverts.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
164      * but also transferring `value` wei to `target`.
165      *
166      * Requirements:
167      *
168      * - the calling contract must have an ETH balance of at least `value`.
169      * - the called Solidity function must be `payable`.
170      *
171      * _Available since v3.1._
172      */
173     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
179      * with `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
184         require(address(this).balance >= value, "Address: insufficient balance for call");
185         require(isContract(target), "Address: call to non-contract");
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = target.call{ value: value }(data);
189         return _verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
194      * but performing a static call.
195      *
196      * _Available since v3.3._
197      */
198     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
199         return functionStaticCall(target, data, "Address: low-level static call failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
204      * but performing a static call.
205      *
206      * _Available since v3.3._
207      */
208     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
209         require(isContract(target), "Address: static call to non-contract");
210 
211         // solhint-disable-next-line avoid-low-level-calls
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return _verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a delegate call.
219      *
220      * _Available since v3.4._
221      */
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a delegate call.
229      *
230      * _Available since v3.4._
231      */
232     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
233         require(isContract(target), "Address: delegate call to non-contract");
234 
235         // solhint-disable-next-line avoid-low-level-calls
236         (bool success, bytes memory returndata) = target.delegatecall(data);
237         return _verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 // solhint-disable-next-line no-inline-assembly
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259 
260 abstract contract ERC165 is IERC165 {
261     /**
262      * @dev See {IERC165-supportsInterface}.
263      */
264     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
265         return interfaceId == type(IERC165).interfaceId;
266     }
267 }
268 
269 /**
270  * @dev Required interface of an ERC721 compliant contract.
271  */
272 interface IERC721 is IERC165 {
273     /**
274      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
275      */
276     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
277 
278     /**
279      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
280      */
281     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
282 
283     /**
284      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
285      */
286     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
287 
288     /**
289      * @dev Returns the number of tokens in ``owner``'s account.
290      */
291     function balanceOf(address owner) external view returns (uint256 balance);
292 
293     /**
294      * @dev Returns the owner of the `tokenId` token.
295      *
296      * Requirements:
297      *
298      * - `tokenId` must exist.
299      */
300     function ownerOf(uint256 tokenId) external view returns (address owner);
301 
302     /**
303      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
304      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
305      *
306      * Requirements:
307      *
308      * - `from` cannot be the zero address.
309      * - `to` cannot be the zero address.
310      * - `tokenId` token must exist and be owned by `from`.
311      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
312      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
313      *
314      * Emits a {Transfer} event.
315      */
316     function safeTransferFrom(address from, address to, uint256 tokenId) external;
317 
318     /**
319      * @dev Transfers `tokenId` token from `from` to `to`.
320      *
321      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
322      *
323      * Requirements:
324      *
325      * - `from` cannot be the zero address.
326      * - `to` cannot be the zero address.
327      * - `tokenId` token must be owned by `from`.
328      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
329      *
330      * Emits a {Transfer} event.
331      */
332     function transferFrom(address from, address to, uint256 tokenId) external;
333 
334     /**
335      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
336      * The approval is cleared when the token is transferred.
337      *
338      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
339      *
340      * Requirements:
341      *
342      * - The caller must own the token or be an approved operator.
343      * - `tokenId` must exist.
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address to, uint256 tokenId) external;
348 
349     /**
350      * @dev Returns the account approved for `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function getApproved(uint256 tokenId) external view returns (address operator);
357 
358     /**
359      * @dev Approve or remove `operator` as an operator for the caller.
360      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
361      *
362      * Requirements:
363      *
364      * - The `operator` cannot be the caller.
365      *
366      * Emits an {ApprovalForAll} event.
367      */
368     function setApprovalForAll(address operator, bool _approved) external;
369 
370     /**
371      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
372      *
373      * See {setApprovalForAll}
374      */
375     function isApprovedForAll(address owner, address operator) external view returns (bool);
376 
377     /**
378       * @dev Safely transfers `tokenId` token from `from` to `to`.
379       *
380       * Requirements:
381       *
382       * - `from` cannot be the zero address.
383       * - `to` cannot be the zero address.
384       * - `tokenId` token must exist and be owned by `from`.
385       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
386       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387       *
388       * Emits a {Transfer} event.
389       */
390     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
391 }
392 
393 interface IERC721Receiver {
394     /**
395      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
396      * by `operator` from `from`, this function is called.
397      *
398      * It must return its Solidity selector to confirm the token transfer.
399      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
400      *
401      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
402      */
403     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
404 }
405 
406 interface IERC721Metadata is IERC721 {
407 
408     /**
409      * @dev Returns the token collection name.
410      */
411     function name() external view returns (string memory);
412 
413     /**
414      * @dev Returns the token collection symbol.
415      */
416     function symbol() external view returns (string memory);
417 
418     /**
419      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
420      */
421     function tokenURI(uint256 tokenId) external view returns (string memory);
422 }
423 
424 /*
425  * @dev Provides information about the current execution context, including the
426  * sender of the transaction and its data. While these are generally available
427  * via msg.sender and msg.data, they should not be accessed in such a direct
428  * manner, since when dealing with meta-transactions the account sending and
429  * paying for execution may not be the actual sender (as far as an application
430  * is concerned).
431  *
432  * This contract is only required for intermediate, library-like contracts.
433  */
434 abstract contract Context {
435     function _msgSender() internal view virtual returns (address) {
436         return msg.sender;
437     }
438 
439     function _msgData() internal view virtual returns (bytes calldata) {
440         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
441         return msg.data;
442     }
443 }
444 
445 /**
446  * @dev Contract module which provides a basic access control mechanism, where
447  * there is an account (an owner) that can be granted exclusive access to
448  * specific functions.
449  *
450  * By default, the owner account will be the one that deploys the contract. This
451  * can later be changed with {transferOwnership}.
452  *
453  * This module is used through inheritance. It will make available the modifier
454  * `onlyOwner`, which can be applied to your functions to restrict their use to
455  * the owner.
456  */
457 abstract contract Ownable is Context {
458     address private _owner;
459 
460     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
461 
462     /**
463      * @dev Initializes the contract setting the deployer as the initial owner.
464      */
465     constructor () {
466         address msgSender = _msgSender();
467         _owner = msgSender;
468         emit OwnershipTransferred(address(0), msgSender);
469     }
470 
471     /**
472      * @dev Returns the address of the current owner.
473      */
474     function owner() public view virtual returns (address) {
475         return _owner;
476     }
477 
478     /**
479      * @dev Throws if called by any account other than the owner.
480      */
481     modifier onlyOwner() {
482         require(owner() == _msgSender(), "Ownable: caller is not the owner");
483         _;
484     }
485 
486     /**
487      * @dev Leaves the contract without owner. It will not be possible to call
488      * `onlyOwner` functions anymore. Can only be called by the current owner.
489      *
490      * NOTE: Renouncing ownership will leave the contract without an owner,
491      * thereby removing any functionality that is only available to the owner.
492      */
493     function renounceOwnership() public virtual onlyOwner {
494         emit OwnershipTransferred(_owner, address(0));
495         _owner = address(0);
496     }
497 
498     /**
499      * @dev Transfers ownership of the contract to a new account (`newOwner`).
500      * Can only be called by the current owner.
501      */
502     function transferOwnership(address newOwner) public virtual onlyOwner {
503         require(newOwner != address(0), "Ownable: new owner is the zero address");
504         emit OwnershipTransferred(_owner, newOwner);
505         _owner = newOwner;
506     }
507 }
508 
509 // CAUTION
510 // This version of SafeMath should only be used with Solidity 0.8 or later,
511 // because it relies on the compiler's built in overflow checks.
512 
513 /**
514  * @dev Wrappers over Solidity's arithmetic operations.
515  *
516  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
517  * now has built in overflow checking.
518  */
519 library SafeMath {
520     /**
521      * @dev Returns the addition of two unsigned integers, with an overflow flag.
522      *
523      * _Available since v3.4._
524      */
525     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
526         unchecked {
527             uint256 c = a + b;
528             if (c < a) return (false, 0);
529             return (true, c);
530         }
531     }
532 
533     /**
534      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
535      *
536      * _Available since v3.4._
537      */
538     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
539         unchecked {
540             if (b > a) return (false, 0);
541             return (true, a - b);
542         }
543     }
544 
545     /**
546      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
547      *
548      * _Available since v3.4._
549      */
550     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
551         unchecked {
552             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
553             // benefit is lost if 'b' is also tested.
554             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
555             if (a == 0) return (true, 0);
556             uint256 c = a * b;
557             if (c / a != b) return (false, 0);
558             return (true, c);
559         }
560     }
561 
562     /**
563      * @dev Returns the division of two unsigned integers, with a division by zero flag.
564      *
565      * _Available since v3.4._
566      */
567     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
568         unchecked {
569             if (b == 0) return (false, 0);
570             return (true, a / b);
571         }
572     }
573 
574     /**
575      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
576      *
577      * _Available since v3.4._
578      */
579     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             if (b == 0) return (false, 0);
582             return (true, a % b);
583         }
584     }
585 
586     /**
587      * @dev Returns the addition of two unsigned integers, reverting on
588      * overflow.
589      *
590      * Counterpart to Solidity's `+` operator.
591      *
592      * Requirements:
593      *
594      * - Addition cannot overflow.
595      */
596     function add(uint256 a, uint256 b) internal pure returns (uint256) {
597         return a + b;
598     }
599 
600     /**
601      * @dev Returns the subtraction of two unsigned integers, reverting on
602      * overflow (when the result is negative).
603      *
604      * Counterpart to Solidity's `-` operator.
605      *
606      * Requirements:
607      *
608      * - Subtraction cannot overflow.
609      */
610     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
611         return a - b;
612     }
613 
614     /**
615      * @dev Returns the multiplication of two unsigned integers, reverting on
616      * overflow.
617      *
618      * Counterpart to Solidity's `*` operator.
619      *
620      * Requirements:
621      *
622      * - Multiplication cannot overflow.
623      */
624     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
625         return a * b;
626     }
627 
628     /**
629      * @dev Returns the integer division of two unsigned integers, reverting on
630      * division by zero. The result is rounded towards zero.
631      *
632      * Counterpart to Solidity's `/` operator.
633      *
634      * Requirements:
635      *
636      * - The divisor cannot be zero.
637      */
638     function div(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a / b;
640     }
641 
642     /**
643      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
644      * reverting when dividing by zero.
645      *
646      * Counterpart to Solidity's `%` operator. This function uses a `revert`
647      * opcode (which leaves remaining gas untouched) while Solidity uses an
648      * invalid opcode to revert (consuming all remaining gas).
649      *
650      * Requirements:
651      *
652      * - The divisor cannot be zero.
653      */
654     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
655         return a % b;
656     }
657 
658     /**
659      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
660      * overflow (when the result is negative).
661      *
662      * CAUTION: This function is deprecated because it requires allocating memory for the error
663      * message unnecessarily. For custom revert reasons use {trySub}.
664      *
665      * Counterpart to Solidity's `-` operator.
666      *
667      * Requirements:
668      *
669      * - Subtraction cannot overflow.
670      */
671     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
672         unchecked {
673             require(b <= a, errorMessage);
674             return a - b;
675         }
676     }
677 
678     /**
679      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
680      * division by zero. The result is rounded towards zero.
681      *
682      * Counterpart to Solidity's `%` operator. This function uses a `revert`
683      * opcode (which leaves remaining gas untouched) while Solidity uses an
684      * invalid opcode to revert (consuming all remaining gas).
685      *
686      * Counterpart to Solidity's `/` operator. Note: this function uses a
687      * `revert` opcode (which leaves remaining gas untouched) while Solidity
688      * uses an invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         unchecked {
696             require(b > 0, errorMessage);
697             return a / b;
698         }
699     }
700 
701     /**
702      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
703      * reverting with custom message when dividing by zero.
704      *
705      * CAUTION: This function is deprecated because it requires allocating memory for the error
706      * message unnecessarily. For custom revert reasons use {tryMod}.
707      *
708      * Counterpart to Solidity's `%` operator. This function uses a `revert`
709      * opcode (which leaves remaining gas untouched) while Solidity uses an
710      * invalid opcode to revert (consuming all remaining gas).
711      *
712      * Requirements:
713      *
714      * - The divisor cannot be zero.
715      */
716     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
717         unchecked {
718             require(b > 0, errorMessage);
719             return a % b;
720         }
721     }
722 }
723 
724 interface IERC721Enumerable is IERC721 {
725 
726     /**
727      * @dev Returns the total amount of tokens stored by the contract.
728      */
729     function totalSupply() external view returns (uint256);
730 
731     /**
732      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
733      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
734      */
735     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
736 
737     /**
738      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
739      * Use along with {totalSupply} to enumerate all tokens.
740      */
741     function tokenByIndex(uint256 index) external view returns (uint256);
742 }
743 
744 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
745     using Address for address;
746     using Strings for uint256;
747 
748     // Token name
749     string private _name;
750 
751     // Token symbol
752     string private _symbol;
753 
754     // Mapping from token ID to owner address
755     mapping (uint256 => address) private _owners;
756 
757     // Mapping owner address to token count
758     mapping (address => uint256) private _balances;
759 
760     // Mapping from token ID to approved address
761     mapping (uint256 => address) private _tokenApprovals;
762 
763     // Mapping from owner to operator approvals
764     mapping (address => mapping (address => bool)) private _operatorApprovals;
765 
766     /**
767      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
768      */
769     constructor (string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
778         return interfaceId == type(IERC721).interfaceId
779             || interfaceId == type(IERC721Metadata).interfaceId
780             || super.supportsInterface(interfaceId);
781     }
782 
783     /**
784      * @dev See {IERC721-balanceOf}.
785      */
786     function balanceOf(address owner) public view virtual override returns (uint256) {
787         require(owner != address(0), "ERC721: balance query for the zero address");
788         return _balances[owner];
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
795         address owner = _owners[tokenId];
796         require(owner != address(0), "ERC721: owner query for nonexistent token");
797         return owner;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-name}.
802      */
803     function name() public view virtual override returns (string memory) {
804         return _name;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-symbol}.
809      */
810     function symbol() public view virtual override returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-tokenURI}.
816      */
817     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
818         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
819 
820         string memory baseURI = _baseURI();
821         return bytes(baseURI).length > 0
822             ? string(abi.encodePacked(baseURI, tokenId.toString()))
823             : '';
824     }
825 
826     /**
827      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
828      * in child contracts.
829      */
830     function _baseURI() internal view virtual returns (string memory) {
831         return "";
832     }
833 
834     /**
835      * @dev See {IERC721-approve}.
836      */
837     function approve(address to, uint256 tokenId) public virtual override {
838         address owner = ERC721.ownerOf(tokenId);
839         require(to != owner, "ERC721: approval to current owner");
840 
841         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
842             "ERC721: approve caller is not owner nor approved for all"
843         );
844 
845         _approve(to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-getApproved}.
850      */
851     function getApproved(uint256 tokenId) public view virtual override returns (address) {
852         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
853 
854         return _tokenApprovals[tokenId];
855     }
856 
857     /**
858      * @dev See {IERC721-setApprovalForAll}.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         require(operator != _msgSender(), "ERC721: approve to caller");
862 
863         _operatorApprovals[_msgSender()][operator] = approved;
864         emit ApprovalForAll(_msgSender(), operator, approved);
865     }
866 
867     /**
868      * @dev See {IERC721-isApprovedForAll}.
869      */
870     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
871         return _operatorApprovals[owner][operator];
872     }
873 
874     /**
875      * @dev See {IERC721-transferFrom}.
876      */
877     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
878         //solhint-disable-next-line max-line-length
879         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
880 
881         _transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
888         safeTransferFrom(from, to, tokenId, "");
889     }
890 
891     /**
892      * @dev See {IERC721-safeTransferFrom}.
893      */
894     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
895         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
896         _safeTransfer(from, to, tokenId, _data);
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
901      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
902      *
903      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
904      *
905      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
906      * implement alternative mechanisms to perform token transfer, such as signature-based.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
918         _transfer(from, to, tokenId);
919         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      * and stop existing when they are burned (`_burn`).
929      */
930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
931         return _owners[tokenId] != address(0);
932     }
933 
934     /**
935      * @dev Returns whether `spender` is allowed to manage `tokenId`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must exist.
940      */
941     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
942         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
966         _mint(to, tokenId);
967         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
968     }
969 
970     /**
971      * @dev Mints `tokenId` and transfers it to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
974      *
975      * Requirements:
976      *
977      * - `tokenId` must not exist.
978      * - `to` cannot be the zero address.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(address to, uint256 tokenId) internal virtual {
983         require(to != address(0), "ERC721: mint to the zero address");
984         require(!_exists(tokenId), "ERC721: token already minted");
985 
986         _beforeTokenTransfer(address(0), to, tokenId);
987 
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1030         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1031         require(to != address(0), "ERC721: transfer to the zero address");
1032 
1033         _beforeTokenTransfer(from, to, tokenId);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId);
1037 
1038         _balances[from] -= 1;
1039         _balances[to] += 1;
1040         _owners[tokenId] = to;
1041 
1042         emit Transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Approve `to` to operate on `tokenId`
1047      *
1048      * Emits a {Approval} event.
1049      */
1050     function _approve(address to, uint256 tokenId) internal virtual {
1051         _tokenApprovals[tokenId] = to;
1052         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057      * The call is not executed if the target address is not a contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1066         private returns (bool)
1067     {
1068         if (to.isContract()) {
1069             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1070                 return retval == IERC721Receiver(to).onERC721Received.selector;
1071             } catch (bytes memory reason) {
1072                 if (reason.length == 0) {
1073                     revert("ERC721: transfer to non ERC721Receiver implementer");
1074                 } else {
1075                     // solhint-disable-next-line no-inline-assembly
1076                     assembly {
1077                         revert(add(32, reason), mload(reason))
1078                     }
1079                 }
1080             }
1081         } else {
1082             return true;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before any token transfer. This includes minting
1088      * and burning.
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1096      * - `from` cannot be the zero address.
1097      * - `to` cannot be the zero address.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1102 }
1103 
1104 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1105     // Mapping from owner to list of owned token IDs
1106     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1107 
1108     // Mapping from token ID to index of the owner tokens list
1109     mapping(uint256 => uint256) private _ownedTokensIndex;
1110 
1111     // Array with all token ids, used for enumeration
1112     uint256[] private _allTokens;
1113 
1114     // Mapping from token id to position in the allTokens array
1115     mapping(uint256 => uint256) private _allTokensIndex;
1116 
1117     /**
1118      * @dev See {IERC165-supportsInterface}.
1119      */
1120     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1121         return interfaceId == type(IERC721Enumerable).interfaceId
1122             || super.supportsInterface(interfaceId);
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1127      */
1128     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1129         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1130         return _ownedTokens[owner][index];
1131     }
1132 
1133     /**
1134      * @dev See {IERC721Enumerable-totalSupply}.
1135      */
1136     function totalSupply() public view virtual override returns (uint256) {
1137         return _allTokens.length;
1138     }
1139 
1140     /**
1141      * @dev See {IERC721Enumerable-tokenByIndex}.
1142      */
1143     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1144         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1145         return _allTokens[index];
1146     }
1147 
1148     /**
1149      * @dev Hook that is called before any token transfer. This includes minting
1150      * and burning.
1151      *
1152      * Calling conditions:
1153      *
1154      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1155      * transferred to `to`.
1156      * - When `from` is zero, `tokenId` will be minted for `to`.
1157      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1158      * - `from` cannot be the zero address.
1159      * - `to` cannot be the zero address.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1164         super._beforeTokenTransfer(from, to, tokenId);
1165 
1166         if (from == address(0)) {
1167             _addTokenToAllTokensEnumeration(tokenId);
1168         } else if (from != to) {
1169             _removeTokenFromOwnerEnumeration(from, tokenId);
1170         }
1171         if (to == address(0)) {
1172             _removeTokenFromAllTokensEnumeration(tokenId);
1173         } else if (to != from) {
1174             _addTokenToOwnerEnumeration(to, tokenId);
1175         }
1176     }
1177 
1178     /**
1179      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1180      * @param to address representing the new owner of the given token ID
1181      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1182      */
1183     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1184         uint256 length = ERC721.balanceOf(to);
1185         _ownedTokens[to][length] = tokenId;
1186         _ownedTokensIndex[tokenId] = length;
1187     }
1188 
1189     /**
1190      * @dev Private function to add a token to this extension's token tracking data structures.
1191      * @param tokenId uint256 ID of the token to be added to the tokens list
1192      */
1193     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1194         _allTokensIndex[tokenId] = _allTokens.length;
1195         _allTokens.push(tokenId);
1196     }
1197 
1198     /**
1199      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1200      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1201      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1202      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1203      * @param from address representing the previous owner of the given token ID
1204      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1205      */
1206     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1207         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1208         // then delete the last slot (swap and pop).
1209 
1210         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1211         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1212 
1213         // When the token to delete is the last token, the swap operation is unnecessary
1214         if (tokenIndex != lastTokenIndex) {
1215             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1216 
1217             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1218             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1219         }
1220 
1221         // This also deletes the contents at the last position of the array
1222         delete _ownedTokensIndex[tokenId];
1223         delete _ownedTokens[from][lastTokenIndex];
1224     }
1225 
1226     /**
1227      * @dev Private function to remove a token from this extension's token tracking data structures.
1228      * This has O(1) time complexity, but alters the order of the _allTokens array.
1229      * @param tokenId uint256 ID of the token to be removed from the tokens list
1230      */
1231     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1232         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1233         // then delete the last slot (swap and pop).
1234 
1235         uint256 lastTokenIndex = _allTokens.length - 1;
1236         uint256 tokenIndex = _allTokensIndex[tokenId];
1237 
1238         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1239         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1240         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1241         uint256 lastTokenId = _allTokens[lastTokenIndex];
1242 
1243         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1244         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1245 
1246         // This also deletes the contents at the last position of the array
1247         delete _allTokensIndex[tokenId];
1248         _allTokens.pop();
1249     }
1250 }
1251 
1252 
1253 
1254 
1255 contract SecretSocietyofOddFellows is ERC721Enumerable, Ownable {
1256   using Strings for uint256;
1257   using SafeMath for uint256;
1258   string private baseURI;
1259   address public collaborator;
1260   bool public isSaleStarted=false;
1261   string public notRevealedUri;
1262   uint256 public preSaleCost = 0.07 ether;
1263   uint256 public generalSaleCost = 0.08 ether;
1264   uint256 public maxSupply = 10011;
1265   uint256 public nftPerAddressLimitOnPreSale = 25;
1266   uint256 public nftPerAddressLimitOnGeneralSale = 25;
1267   bool public paused = false;
1268   bool public revealed = false;
1269   uint256 public generalSaleTime;
1270   mapping(address => uint256) public addressMintedPresaleBalance;
1271   mapping(address => uint256) public addressMintedGeneralsaleeBalance;
1272 
1273 
1274   constructor(
1275     string memory _name,
1276     string memory _symbol,
1277     string memory _initBaseURI,
1278     string memory _initNotRevealedUri,
1279     address _collaborator
1280   ) ERC721(_name, _symbol) payable{
1281     setBaseURI(_initBaseURI);
1282     setNotRevealedURI(_initNotRevealedUri);
1283     collaborator = _collaborator;
1284   }
1285 
1286   // internal
1287   function _baseURI() internal view virtual override returns (string memory) {
1288     return baseURI;
1289   }
1290 
1291 
1292     function mintAsOwner(uint _mintAmount) public {
1293         if(collaborator != msg.sender && owner() != msg.sender) revert("Caller is not the owner or collaborator");
1294         uint256 supply = totalSupply();
1295         require(supply + _mintAmount <= maxSupply, "Exceeds maximum Originators supply");
1296         
1297         for (uint256 i = 1; i <= _mintAmount; i++) {
1298             _safeMint(msg.sender, supply + i);
1299         }
1300     }
1301 
1302     function mint(uint _mintAmount) public payable {
1303         require(isSaleStarted,"sale is not started");
1304         require(!paused, "the contract is paused");
1305         uint256 supply = totalSupply();
1306         require(supply + _mintAmount <= maxSupply, "Exceeds maximum Originators supply");       
1307         
1308         if(block.timestamp < generalSaleTime) {
1309             require(msg.value >= preSaleCost * _mintAmount, "Insufficient funds");
1310             uint256 ownerMintedCount = addressMintedPresaleBalance[msg.sender];
1311             require(ownerMintedCount + _mintAmount <= nftPerAddressLimitOnPreSale, "Max NFTs per address exceeded for pre-sale.");
1312             for (uint256 i = 1; i <= _mintAmount; i++) {
1313                 addressMintedPresaleBalance[msg.sender]++;
1314                 _safeMint(msg.sender, supply + i);
1315             }
1316         }
1317         else{
1318             
1319             uint256 ownerMintedCount = addressMintedGeneralsaleeBalance[msg.sender];
1320             require(msg.value >= generalSaleCost * _mintAmount, "Insufficient funds");
1321             require(ownerMintedCount + _mintAmount <= nftPerAddressLimitOnGeneralSale, "Max NFTs per address exceeded for general-sale.");
1322             for (uint256 i = 1; i <= _mintAmount; i++) {
1323                 addressMintedGeneralsaleeBalance[msg.sender]++;
1324                 _safeMint(msg.sender, supply + i);
1325             }
1326         }
1327     }
1328 
1329   function walletOfOwner(address _owner) public view returns (uint256[] memory){
1330     uint256 ownerTokenCount = balanceOf(_owner);
1331     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1332     for (uint256 i; i < ownerTokenCount; i++) {
1333       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1334     }
1335     return tokenIds;
1336   }
1337 
1338   function getMintFees(uint _mintAmount) public view returns(uint256) {
1339         if(block.timestamp < generalSaleTime) {
1340             return preSaleCost * _mintAmount;
1341         }else{
1342             return generalSaleCost * _mintAmount;
1343         }
1344   }
1345     
1346   function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
1347       
1348     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1349     
1350     if(revealed == false) {
1351         return string(abi.encodePacked(notRevealedUri, tokenId.toString()));
1352     }
1353 
1354     string memory currentBaseURI = _baseURI();
1355     return string(abi.encodePacked(currentBaseURI, tokenId.toString()));
1356   }
1357 
1358   function  getMintedCount(address user) public view returns(uint256) {
1359       return addressMintedGeneralsaleeBalance[user].add(addressMintedPresaleBalance[user]);
1360   }
1361 
1362   function reveal(bool _reveal) public onlyOwner {
1363       revealed = _reveal;
1364   }
1365   
1366   function startPresale() public onlyOwner {
1367       isSaleStarted = true;
1368       generalSaleTime = block.timestamp + 72 hours;
1369   }
1370   
1371   function stopPresale() public onlyOwner {
1372       isSaleStarted=false;
1373       generalSaleTime = 0;
1374   }
1375 
1376   function startGeneralsale() public onlyOwner {
1377       isSaleStarted = true;
1378   }
1379 
1380 
1381   function stopGeneralsale() public onlyOwner {
1382       isSaleStarted = false;
1383   }
1384   
1385   function setGeneralSaleNftcount(uint256 _limit) public onlyOwner {
1386      nftPerAddressLimitOnGeneralSale = _limit;
1387   }
1388   
1389   function setPreSaleNftcount(uint256 _limit) public onlyOwner {
1390     nftPerAddressLimitOnPreSale = _limit;
1391   }
1392   
1393   function setGeneralSaleCost(uint256 _newCost) public onlyOwner {
1394     generalSaleCost = _newCost;
1395   }
1396 
1397   function setPresaleCost(uint256 _newCost) public onlyOwner {
1398     preSaleCost = _newCost;
1399   }
1400 
1401 
1402   function setCollaborator(address _collaborator) public onlyOwner {
1403     collaborator = _collaborator;
1404   }
1405 
1406 
1407 
1408   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1409     baseURI = _newBaseURI;
1410   }
1411 
1412   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1413     notRevealedUri = _notRevealedURI;
1414   }
1415   
1416   function pause(bool _state) public onlyOwner {
1417     paused = _state;
1418   }
1419   
1420   function withdraw() public onlyOwner {
1421         uint balance = address(this).balance;
1422         payable(msg.sender).transfer(balance);
1423     }
1424 }