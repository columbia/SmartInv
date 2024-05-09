1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // CAUTION
5 // This version of SafeMath should only be used with Solidity 0.8 or later,
6 // because it relies on the compiler's built in overflow checks.
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations.
10  *
11  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
12  * now has built in overflow checking.
13  */
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, with an overflow flag.
17      *
18      * _Available since v3.4._
19      */
20     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     /**
29      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48             // benefit is lost if 'b' is also tested.
49             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50             if (a == 0) return (true, 0);
51             uint256 c = a * b;
52             if (c / a != b) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b == 0) return (false, 0);
65             return (true, a / b);
66         }
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a % b);
78         }
79     }
80 
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a + b;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a - b;
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      *
117      * - Multiplication cannot overflow.
118      */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a * b;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator.
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a / b;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * reverting when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a % b;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * CAUTION: This function is deprecated because it requires allocating memory for the error
158      * message unnecessarily. For custom revert reasons use {trySub}.
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(
167         uint256 a,
168         uint256 b,
169         string memory errorMessage
170     ) internal pure returns (uint256) {
171         unchecked {
172             require(b <= a, errorMessage);
173             return a - b;
174         }
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(
190         uint256 a,
191         uint256 b,
192         string memory errorMessage
193     ) internal pure returns (uint256) {
194         unchecked {
195             require(b > 0, errorMessage);
196             return a / b;
197         }
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * reverting with custom message when dividing by zero.
203      *
204      * CAUTION: This function is deprecated because it requires allocating memory for the error
205      * message unnecessarily. For custom revert reasons use {tryMod}.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(
216         uint256 a,
217         uint256 b,
218         string memory errorMessage
219     ) internal pure returns (uint256) {
220         unchecked {
221             require(b > 0, errorMessage);
222             return a % b;
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Interface of the ERC20 standard as defined in the EIP.
236  */
237 interface IERC20 {
238     /**
239      * @dev Emitted when `value` tokens are moved from one account (`from`) to
240      * another (`to`).
241      *
242      * Note that `value` may be zero.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 value);
245 
246     /**
247      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
248      * a call to {approve}. `value` is the new allowance.
249      */
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251 
252     /**
253      * @dev Returns the amount of tokens in existence.
254      */
255     function totalSupply() external view returns (uint256);
256 
257     /**
258      * @dev Returns the amount of tokens owned by `account`.
259      */
260     function balanceOf(address account) external view returns (uint256);
261 
262     /**
263      * @dev Moves `amount` tokens from the caller's account to `to`.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transfer(address to, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Returns the remaining number of tokens that `spender` will be
273      * allowed to spend on behalf of `owner` through {transferFrom}. This is
274      * zero by default.
275      *
276      * This value changes when {approve} or {transferFrom} are called.
277      */
278     function allowance(address owner, address spender) external view returns (uint256);
279 
280     /**
281      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * IMPORTANT: Beware that changing an allowance with this method brings the risk
286      * that someone may use both the old and the new allowance by unfortunate
287      * transaction ordering. One possible solution to mitigate this race
288      * condition is to first reduce the spender's allowance to 0 and set the
289      * desired value afterwards:
290      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291      *
292      * Emits an {Approval} event.
293      */
294     function approve(address spender, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Moves `amount` tokens from `from` to `to` using the
298      * allowance mechanism. `amount` is then deducted from the caller's
299      * allowance.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transferFrom(
306         address from,
307         address to,
308         uint256 amount
309     ) external returns (bool);
310 }
311 
312 // File: contracts/synthesisNFT.sol
313 
314 
315 pragma solidity ^0.8.0;
316 
317 
318 
319 interface IERC721Receiver {
320     /**
321      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
322      * by `operator` from `from`, this function is called.
323      *
324      * It must return its Solidity selector to confirm the token transfer.
325      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
326      *
327      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
328      */
329     function onERC721Received(
330         address operator,
331         address from,
332         uint256 tokenId,
333         bytes calldata data
334     ) external returns (bytes4);
335 }
336 
337 
338 interface IERC165 {
339     /**
340      * @dev Returns true if this contract implements the interface defined by
341      * `interfaceId`. See the corresponding
342      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
343      * to learn more about how these ids are created.
344      *
345      * This function call must use less than 30 000 gas.
346      */
347     function supportsInterface(bytes4 interfaceId) external view returns (bool);
348 }
349 
350 abstract contract ERC165 is IERC165 {
351     /**
352      * @dev See {IERC165-supportsInterface}.
353      */
354     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
355         return interfaceId == type(IERC165).interfaceId;
356     }
357 }
358 
359 interface IERC721 is IERC165 {
360     /**
361      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
362      */
363     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
364 
365     /**
366      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
367      */
368     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
369 
370     /**
371      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
372      */
373     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
374 
375     /**
376      * @dev Returns the number of tokens in ``owner``'s account.
377      */
378     function balanceOf(address owner) external view returns (uint256 balance);
379 
380     /**
381      * @dev Returns the owner of the `tokenId` token.
382      *
383      * Requirements:
384      *
385      * - `tokenId` must exist.
386      */
387     function ownerOf(uint256 tokenId) external view returns (address owner);
388 
389     /**
390      * @dev Safely transfers `tokenId` token from `from` to `to`.
391      *
392      * Requirements:
393      *
394      * - `from` cannot be the zero address.
395      * - `to` cannot be the zero address.
396      * - `tokenId` token must exist and be owned by `from`.
397      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
398      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
399      *
400      * Emits a {Transfer} event.
401      */
402     function safeTransferFrom(
403         address from,
404         address to,
405         uint256 tokenId,
406         bytes calldata data
407     ) external;
408 
409     /**
410      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
411      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
412      *
413      * Requirements:
414      *
415      * - `from` cannot be the zero address.
416      * - `to` cannot be the zero address.
417      * - `tokenId` token must exist and be owned by `from`.
418      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
419      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
420      *
421      * Emits a {Transfer} event.
422      */
423     function safeTransferFrom(
424         address from,
425         address to,
426         uint256 tokenId
427     ) external;
428 
429     /**
430      * @dev Transfers `tokenId` token from `from` to `to`.
431      *
432      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must be owned by `from`.
439      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
440      *
441      * Emits a {Transfer} event.
442      */
443     function transferFrom(
444         address from,
445         address to,
446         uint256 tokenId
447     ) external;
448 
449     /**
450      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
451      * The approval is cleared when the token is transferred.
452      *
453      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
454      *
455      * Requirements:
456      *
457      * - The caller must own the token or be an approved operator.
458      * - `tokenId` must exist.
459      *
460      * Emits an {Approval} event.
461      */
462     function approve(address to, uint256 tokenId) external;
463 
464     /**
465      * @dev Approve or remove `operator` as an operator for the caller.
466      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
487      *
488      * See {setApprovalForAll}
489      */
490     function isApprovedForAll(address owner, address operator) external view returns (bool);
491 }
492 
493 interface IERC721Metadata is IERC721 {
494     /**
495      * @dev Returns the token collection name.
496      */
497     function name() external view returns (string memory);
498 
499     /**
500      * @dev Returns the token collection symbol.
501      */
502     function symbol() external view returns (string memory);
503 
504     /**
505      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
506      */
507     function tokenURI(uint256 tokenId) external view returns (string memory);
508 }
509 
510 library Strings {
511     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
512 
513     /**
514      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
515      */
516     function toString(uint256 value) internal pure returns (string memory) {
517         // Inspired by OraclizeAPI's implementation - MIT licence
518         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
519 
520         if (value == 0) {
521             return "0";
522         }
523         uint256 temp = value;
524         uint256 digits;
525         while (temp != 0) {
526             digits++;
527             temp /= 10;
528         }
529         bytes memory buffer = new bytes(digits);
530         while (value != 0) {
531             digits -= 1;
532             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
533             value /= 10;
534         }
535         return string(buffer);
536     }
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
540      */
541     function toHexString(uint256 value) internal pure returns (string memory) {
542         if (value == 0) {
543             return "0x00";
544         }
545         uint256 temp = value;
546         uint256 length = 0;
547         while (temp != 0) {
548             length++;
549             temp >>= 8;
550         }
551         return toHexString(value, length);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
556      */
557     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
558         bytes memory buffer = new bytes(2 * length + 2);
559         buffer[0] = "0";
560         buffer[1] = "x";
561         for (uint256 i = 2 * length + 1; i > 1; --i) {
562             buffer[i] = _HEX_SYMBOLS[value & 0xf];
563             value >>= 4;
564         }
565         require(value == 0, "Strings: hex length insufficient");
566         return string(buffer);
567     }
568 }
569 
570 
571 abstract contract Context {
572     function _msgSender() internal view virtual returns (address) {
573         return msg.sender;
574     }
575 
576     function _msgData() internal view virtual returns (bytes calldata) {
577         return msg.data;
578     }
579 }
580 
581 
582 abstract contract Ownable is Context {
583     address private _owner;
584 
585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
586 
587     /**
588      * @dev Initializes the contract setting the deployer as the initial owner.
589      */
590     constructor() {
591         _transferOwnership(_msgSender());
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view virtual returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(owner() == _msgSender(), "Ownable: caller is not the owner");
606         _;
607     }
608 
609     /**
610      * @dev Leaves the contract without owner. It will not be possible to call
611      * `onlyOwner` functions anymore. Can only be called by the current owner.
612      *
613      * NOTE: Renouncing ownership will leave the contract without an owner,
614      * thereby removing any functionality that is only available to the owner.
615      */
616     function renounceOwnership() public virtual onlyOwner {
617         _transferOwnership(address(0));
618     }
619 
620     /**
621      * @dev Transfers ownership of the contract to a new account (`newOwner`).
622      * Can only be called by the current owner.
623      */
624     function transferOwnership(address newOwner) public virtual onlyOwner {
625         require(newOwner != address(0), "Ownable: new owner is the zero address");
626         _transferOwnership(newOwner);
627     }
628 
629     /**
630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
631      * Internal function without access restriction.
632      */
633     function _transferOwnership(address newOwner) internal virtual {
634         address oldOwner = _owner;
635         _owner = newOwner;
636         emit OwnershipTransferred(oldOwner, newOwner);
637     }
638 }
639 
640 library Address {
641     /**
642      * @dev Returns true if `account` is a contract.
643      *
644      * [IMPORTANT]
645      * ====
646      * It is unsafe to assume that an address for which this function returns
647      * false is an externally-owned account (EOA) and not a contract.
648      *
649      * Among others, `isContract` will return false for the following
650      * types of addresses:
651      *
652      *  - an externally-owned account
653      *  - a contract in construction
654      *  - an address where a contract will be created
655      *  - an address where a contract lived, but was destroyed
656      * ====
657      *
658      * [IMPORTANT]
659      * ====
660      * You shouldn't rely on `isContract` to protect against flash loan attacks!
661      *
662      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
663      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
664      * constructor.
665      * ====
666      */
667     function isContract(address account) internal view returns (bool) {
668         // This method relies on extcodesize/address.code.length, which returns 0
669         // for contracts in construction, since the code is only stored at the end
670         // of the constructor execution.
671 
672         return account.code.length > 0;
673     }
674 
675     /**
676      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
677      * `recipient`, forwarding all available gas and reverting on errors.
678      *
679      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
680      * of certain opcodes, possibly making contracts go over the 2300 gas limit
681      * imposed by `transfer`, making them unable to receive funds via
682      * `transfer`. {sendValue} removes this limitation.
683      *
684      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
685      *
686      * IMPORTANT: because control is transferred to `recipient`, care must be
687      * taken to not create reentrancy vulnerabilities. Consider using
688      * {ReentrancyGuard} or the
689      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
690      */
691     function sendValue(address payable recipient, uint256 amount) internal {
692         require(address(this).balance >= amount, "Address: insufficient balance");
693 
694         (bool success, ) = recipient.call{value: amount}("");
695         require(success, "Address: unable to send value, recipient may have reverted");
696     }
697 
698     /**
699      * @dev Performs a Solidity function call using a low level `call`. A
700      * plain `call` is an unsafe replacement for a function call: use this
701      * function instead.
702      *
703      * If `target` reverts with a revert reason, it is bubbled up by this
704      * function (like regular Solidity function calls).
705      *
706      * Returns the raw returned data. To convert to the expected return value,
707      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
708      *
709      * Requirements:
710      *
711      * - `target` must be a contract.
712      * - calling `target` with `data` must not revert.
713      *
714      * _Available since v3.1._
715      */
716     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
717         return functionCall(target, data, "Address: low-level call failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
722      * `errorMessage` as a fallback revert reason when `target` reverts.
723      *
724      * _Available since v3.1._
725      */
726     function functionCall(
727         address target,
728         bytes memory data,
729         string memory errorMessage
730     ) internal returns (bytes memory) {
731         return functionCallWithValue(target, data, 0, errorMessage);
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
736      * but also transferring `value` wei to `target`.
737      *
738      * Requirements:
739      *
740      * - the calling contract must have an ETH balance of at least `value`.
741      * - the called Solidity function must be `payable`.
742      *
743      * _Available since v3.1._
744      */
745     function functionCallWithValue(
746         address target,
747         bytes memory data,
748         uint256 value
749     ) internal returns (bytes memory) {
750         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
755      * with `errorMessage` as a fallback revert reason when `target` reverts.
756      *
757      * _Available since v3.1._
758      */
759     function functionCallWithValue(
760         address target,
761         bytes memory data,
762         uint256 value,
763         string memory errorMessage
764     ) internal returns (bytes memory) {
765         require(address(this).balance >= value, "Address: insufficient balance for call");
766         require(isContract(target), "Address: call to non-contract");
767 
768         (bool success, bytes memory returndata) = target.call{value: value}(data);
769         return verifyCallResult(success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
779         return functionStaticCall(target, data, "Address: low-level static call failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
784      * but performing a static call.
785      *
786      * _Available since v3.3._
787      */
788     function functionStaticCall(
789         address target,
790         bytes memory data,
791         string memory errorMessage
792     ) internal view returns (bytes memory) {
793         require(isContract(target), "Address: static call to non-contract");
794 
795         (bool success, bytes memory returndata) = target.staticcall(data);
796         return verifyCallResult(success, returndata, errorMessage);
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
801      * but performing a delegate call.
802      *
803      * _Available since v3.4._
804      */
805     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
806         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
811      * but performing a delegate call.
812      *
813      * _Available since v3.4._
814      */
815     function functionDelegateCall(
816         address target,
817         bytes memory data,
818         string memory errorMessage
819     ) internal returns (bytes memory) {
820         require(isContract(target), "Address: delegate call to non-contract");
821 
822         (bool success, bytes memory returndata) = target.delegatecall(data);
823         return verifyCallResult(success, returndata, errorMessage);
824     }
825 
826     /**
827      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
828      * revert reason using the provided one.
829      *
830      * _Available since v4.3._
831      */
832     function verifyCallResult(
833         bool success,
834         bytes memory returndata,
835         string memory errorMessage
836     ) internal pure returns (bytes memory) {
837         if (success) {
838             return returndata;
839         } else {
840             // Look for revert reason and bubble it up if present
841             if (returndata.length > 0) {
842                 // The easiest way to bubble the revert reason is using memory via assembly
843 
844                 assembly {
845                     let returndata_size := mload(returndata)
846                     revert(add(32, returndata), returndata_size)
847                 }
848             } else {
849                 revert(errorMessage);
850             }
851         }
852     }
853 }
854 
855 
856 interface IERC721A is IERC721, IERC721Metadata {
857     /**
858      * The caller must own the token or be an approved operator.
859      */
860     error ApprovalCallerNotOwnerNorApproved();
861 
862     /**
863      * The token does not exist.
864      */
865     error ApprovalQueryForNonexistentToken();
866 
867     /**
868      * The caller cannot approve to their own address.
869      */
870     error ApproveToCaller();
871 
872     /**
873      * The caller cannot approve to the current owner.
874      */
875     error ApprovalToCurrentOwner();
876 
877     /**
878      * Cannot query the balance for the zero address.
879      */
880     error BalanceQueryForZeroAddress();
881 
882     /**
883      * Cannot mint to the zero address.
884      */
885     error MintToZeroAddress();
886 
887     /**
888      * The quantity of tokens minted must be more than zero.
889      */
890     error MintZeroQuantity();
891 
892     /**
893      * The token does not exist.
894      */
895     error OwnerQueryForNonexistentToken();
896 
897     /**
898      * The caller must own the token or be an approved operator.
899      */
900     error TransferCallerNotOwnerNorApproved();
901 
902     /**
903      * The token must be owned by `from`.
904      */
905     error TransferFromIncorrectOwner();
906 
907     /**
908      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
909      */
910     error TransferToNonERC721ReceiverImplementer();
911 
912     /**
913      * Cannot transfer to the zero address.
914      */
915     error TransferToZeroAddress();
916 
917     /**
918      * The token does not exist.
919      */
920     error URIQueryForNonexistentToken();
921 
922     // Compiler will pack this into a single 256bit word.
923     struct TokenOwnership {
924         // The address of the owner.
925         address addr;
926         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
927         uint64 startTimestamp;
928         // Whether the token has been burned.
929         bool burned;
930     }
931 
932     // Compiler will pack this into a single 256bit word.
933     struct AddressData {
934         // Realistically, 2**64-1 is more than enough.
935         uint64 balance;
936         // Keeps track of mint count with minimal overhead for tokenomics.
937         uint64 numberMinted;
938         // Keeps track of burn count with minimal overhead for tokenomics.
939         uint64 numberBurned;
940         // For miscellaneous variable(s) pertaining to the address
941         // (e.g. number of whitelist mint slots used).
942         // If there are multiple variables, please pack them into a uint64.
943         uint64 aux;
944     }
945 
946     /**
947      * @dev Returns the total amount of tokens stored by the contract.
948      * 
949      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
950      */
951     function totalSupply() external view returns (uint256);
952 }
953 
954 contract ERC721A is Context, ERC165, IERC721A {
955     using Address for address;
956     using Strings for uint256;
957 
958     // The tokenId of the next token to be minted.
959     uint256 internal _currentIndex;
960 
961     // The number of tokens burned.
962     uint256 internal _burnCounter;
963 
964     // Token name
965     string private _name;
966 
967     // Token symbol
968     string private _symbol;
969 
970     // Mapping from token ID to ownership details
971     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
972     mapping(uint256 => TokenOwnership) internal _ownerships;
973 
974     // Mapping owner address to address data
975     mapping(address => AddressData) private _addressData;
976 
977     // Mapping from token ID to approved address
978     mapping(uint256 => address) private _tokenApprovals;
979 
980     // Mapping from owner to operator approvals
981     mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983     constructor(string memory name_, string memory symbol_) {
984         _name = name_;
985         _symbol = symbol_;
986         _currentIndex = _startTokenId();
987     }
988 
989     /**
990      * To change the starting tokenId, please override this function.
991      */
992     function _startTokenId() internal view virtual returns (uint256) {
993         return 0;
994     }
995 
996     /**
997      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
998      */
999     function totalSupply() public view override returns (uint256) {
1000         // Counter underflow is impossible as _burnCounter cannot be incremented
1001         // more than _currentIndex - _startTokenId() times
1002         unchecked {
1003             return _currentIndex - _burnCounter - _startTokenId();
1004         }
1005     }
1006 
1007     /**
1008      * Returns the total amount of tokens minted in the contract.
1009      */
1010     function _totalMinted() internal view returns (uint256) {
1011         // Counter underflow is impossible as _currentIndex does not decrement,
1012         // and it is initialized to _startTokenId()
1013         unchecked {
1014             return _currentIndex - _startTokenId();
1015         }
1016     }
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1022         return
1023             interfaceId == type(IERC721).interfaceId ||
1024             interfaceId == type(IERC721Metadata).interfaceId ||
1025             super.supportsInterface(interfaceId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-balanceOf}.
1030      */
1031     function balanceOf(address owner) public view override returns (uint256) {
1032         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1033         return uint256(_addressData[owner].balance);
1034     }
1035 
1036     /**
1037      * Returns the number of tokens minted by `owner`.
1038      */
1039     function _numberMinted(address owner) internal view returns (uint256) {
1040         return uint256(_addressData[owner].numberMinted);
1041     }
1042 
1043     /**
1044      * Returns the number of tokens burned by or on behalf of `owner`.
1045      */
1046     function _numberBurned(address owner) internal view returns (uint256) {
1047         return uint256(_addressData[owner].numberBurned);
1048     }
1049 
1050     /**
1051      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1052      */
1053     function _getAux(address owner) internal view returns (uint64) {
1054         return _addressData[owner].aux;
1055     }
1056 
1057     /**
1058      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1059      * If there are multiple variables, please pack them into a uint64.
1060      */
1061     function _setAux(address owner, uint64 aux) internal {
1062         _addressData[owner].aux = aux;
1063     }
1064 
1065     /**
1066      * Gas spent here starts off proportional to the maximum mint batch size.
1067      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1068      */
1069     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1070         uint256 curr = tokenId;
1071 
1072         unchecked {
1073             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1074                 TokenOwnership memory ownership = _ownerships[curr];
1075                 if (!ownership.burned) {
1076                     if (ownership.addr != address(0)) {
1077                         return ownership;
1078                     }
1079                     // Invariant:
1080                     // There will always be an ownership that has an address and is not burned
1081                     // before an ownership that does not have an address and is not burned.
1082                     // Hence, curr will not underflow.
1083                     while (true) {
1084                         curr--;
1085                         ownership = _ownerships[curr];
1086                         if (ownership.addr != address(0)) {
1087                             return ownership;
1088                         }
1089                     }
1090                 }
1091             }
1092         }
1093         revert OwnerQueryForNonexistentToken();
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-ownerOf}.
1098      */
1099     function ownerOf(uint256 tokenId) public view override returns (address) {
1100         return _ownershipOf(tokenId).addr;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Metadata-name}.
1105      */
1106     function name() public view virtual override returns (string memory) {
1107         return _name;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Metadata-symbol}.
1112      */
1113     function symbol() public view virtual override returns (string memory) {
1114         return _symbol;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Metadata-tokenURI}.
1119      */
1120     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1121         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1122 
1123         string memory baseURI = _baseURI();
1124         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1125     }
1126 
1127     /**
1128      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1129      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1130      * by default, can be overriden in child contracts.
1131      */
1132     function _baseURI() internal view virtual returns (string memory) {
1133         return '';
1134     }
1135 
1136     /**
1137      * @dev See {IERC721-approve}.
1138      */
1139     function approve(address to, uint256 tokenId) public override {
1140         address owner = ERC721A.ownerOf(tokenId);
1141         if (to == owner) revert ApprovalToCurrentOwner();
1142 
1143         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1144             revert ApprovalCallerNotOwnerNorApproved();
1145         }
1146 
1147         _approve(to, tokenId, owner);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-getApproved}.
1152      */
1153     function getApproved(uint256 tokenId) public view override returns (address) {
1154         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1155 
1156         return _tokenApprovals[tokenId];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-setApprovalForAll}.
1161      */
1162     function setApprovalForAll(address operator, bool approved) public virtual override {
1163         if (operator == _msgSender()) revert ApproveToCaller();
1164 
1165         _operatorApprovals[_msgSender()][operator] = approved;
1166         emit ApprovalForAll(_msgSender(), operator, approved);
1167     }
1168 
1169     /**
1170      * @dev See {IERC721-isApprovedForAll}.
1171      */
1172     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1173         return _operatorApprovals[owner][operator];
1174     }
1175 
1176     /**
1177      * @dev See {IERC721-transferFrom}.
1178      */
1179     function transferFrom(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) public virtual override {
1184         _transfer(from, to, tokenId);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-safeTransferFrom}.
1189      */
1190     function safeTransferFrom(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) public virtual override {
1195         safeTransferFrom(from, to, tokenId, '');
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-safeTransferFrom}.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) public virtual override {
1207         _transfer(from, to, tokenId);
1208         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1209             revert TransferToNonERC721ReceiverImplementer();
1210         }
1211     }
1212 
1213     /**
1214      * @dev Returns whether `tokenId` exists.
1215      *
1216      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1217      *
1218      * Tokens start existing when they are minted (`_mint`),
1219      */
1220     function _exists(uint256 tokenId) internal view returns (bool) {
1221         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1222     }
1223 
1224     /**
1225      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1226      */
1227     function _safeMint(address to, uint256 quantity) internal {
1228         _safeMint(to, quantity, '');
1229     }
1230 
1231     /**
1232      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1233      *
1234      * Requirements:
1235      *
1236      * - If `to` refers to a smart contract, it must implement
1237      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1238      * - `quantity` must be greater than 0.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _safeMint(
1243         address to,
1244         uint256 quantity,
1245         bytes memory _data
1246     ) internal {
1247         uint256 startTokenId = _currentIndex;
1248         if (to == address(0)) revert MintToZeroAddress();
1249         if (quantity == 0) revert MintZeroQuantity();
1250 
1251         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1252 
1253         // Overflows are incredibly unrealistic.
1254         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1255         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1256         unchecked {
1257             _addressData[to].balance += uint64(quantity);
1258             _addressData[to].numberMinted += uint64(quantity);
1259 
1260             _ownerships[startTokenId].addr = to;
1261             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1262 
1263             uint256 updatedIndex = startTokenId;
1264             uint256 end = updatedIndex + quantity;
1265 
1266             if (to.isContract()) {
1267                 do {
1268                     emit Transfer(address(0), to, updatedIndex);
1269                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1270                         revert TransferToNonERC721ReceiverImplementer();
1271                     }
1272                 } while (updatedIndex < end);
1273                 // Reentrancy protection
1274                 if (_currentIndex != startTokenId) revert();
1275             } else {
1276                 do {
1277                     emit Transfer(address(0), to, updatedIndex++);
1278                 } while (updatedIndex < end);
1279             }
1280             _currentIndex = updatedIndex;
1281         }
1282         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1283     }
1284 
1285     /**
1286      * @dev Mints `quantity` tokens and transfers them to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `to` cannot be the zero address.
1291      * - `quantity` must be greater than 0.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _mint(address to, uint256 quantity) internal {
1296         uint256 startTokenId = _currentIndex;
1297         if (to == address(0)) revert MintToZeroAddress();
1298         if (quantity == 0) revert MintZeroQuantity();
1299 
1300         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1301 
1302         // Overflows are incredibly unrealistic.
1303         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1304         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1305         unchecked {
1306             _addressData[to].balance += uint64(quantity);
1307             _addressData[to].numberMinted += uint64(quantity);
1308 
1309             _ownerships[startTokenId].addr = to;
1310             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1311 
1312             uint256 updatedIndex = startTokenId;
1313             uint256 end = updatedIndex + quantity;
1314 
1315             do {
1316                 emit Transfer(address(0), to, updatedIndex++);
1317             } while (updatedIndex < end);
1318 
1319             _currentIndex = updatedIndex;
1320         }
1321         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1322     }
1323 
1324     /**
1325      * @dev Transfers `tokenId` from `from` to `to`.
1326      *
1327      * Requirements:
1328      *
1329      * - `to` cannot be the zero address.
1330      * - `tokenId` token must be owned by `from`.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _transfer(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) private {
1339         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1340 
1341         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1342 
1343         bool isApprovedOrOwner = (_msgSender() == from ||
1344             isApprovedForAll(from, _msgSender()) ||
1345             getApproved(tokenId) == _msgSender());
1346 
1347         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1348         if (to == address(0)) revert TransferToZeroAddress();
1349 
1350         _beforeTokenTransfers(from, to, tokenId, 1);
1351 
1352         // Clear approvals from the previous owner
1353         _approve(address(0), tokenId, from);
1354 
1355         // Underflow of the sender's balance is impossible because we check for
1356         // ownership above and the recipient's balance can't realistically overflow.
1357         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1358         unchecked {
1359             _addressData[from].balance -= 1;
1360             _addressData[to].balance += 1;
1361 
1362             TokenOwnership storage currSlot = _ownerships[tokenId];
1363             currSlot.addr = to;
1364             currSlot.startTimestamp = uint64(block.timestamp);
1365 
1366             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1367             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1368             uint256 nextTokenId = tokenId + 1;
1369             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1370             if (nextSlot.addr == address(0)) {
1371                 // This will suffice for checking _exists(nextTokenId),
1372                 // as a burned slot cannot contain the zero address.
1373                 if (nextTokenId != _currentIndex) {
1374                     nextSlot.addr = from;
1375                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1376                 }
1377             }
1378         }
1379 
1380         emit Transfer(from, to, tokenId);
1381         _afterTokenTransfers(from, to, tokenId, 1);
1382     }
1383 
1384     /**
1385      * @dev Equivalent to `_burn(tokenId, false)`.
1386      */
1387     function _burn(uint256 tokenId) internal virtual {
1388         _burn(tokenId, false);
1389     }
1390 
1391     /**
1392      * @dev Destroys `tokenId`.
1393      * The approval is cleared when the token is burned.
1394      *
1395      * Requirements:
1396      *
1397      * - `tokenId` must exist.
1398      *
1399      * Emits a {Transfer} event.
1400      */
1401     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1402         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1403 
1404         address from = prevOwnership.addr;
1405 
1406         if (approvalCheck) {
1407             bool isApprovedOrOwner = (_msgSender() == from ||
1408                 isApprovedForAll(from, _msgSender()) ||
1409                 getApproved(tokenId) == _msgSender());
1410 
1411             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1412         }
1413 
1414         _beforeTokenTransfers(from, address(0), tokenId, 1);
1415 
1416         // Clear approvals from the previous owner
1417         _approve(address(0), tokenId, from);
1418 
1419         // Underflow of the sender's balance is impossible because we check for
1420         // ownership above and the recipient's balance can't realistically overflow.
1421         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1422         unchecked {
1423             AddressData storage addressData = _addressData[from];
1424             addressData.balance -= 1;
1425             addressData.numberBurned += 1;
1426 
1427             // Keep track of who burned the token, and the timestamp of burning.
1428             TokenOwnership storage currSlot = _ownerships[tokenId];
1429             currSlot.addr = from;
1430             currSlot.startTimestamp = uint64(block.timestamp);
1431             currSlot.burned = true;
1432 
1433             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1434             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1435             uint256 nextTokenId = tokenId + 1;
1436             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1437             if (nextSlot.addr == address(0)) {
1438                 // This will suffice for checking _exists(nextTokenId),
1439                 // as a burned slot cannot contain the zero address.
1440                 if (nextTokenId != _currentIndex) {
1441                     nextSlot.addr = from;
1442                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1443                 }
1444             }
1445         }
1446 
1447         emit Transfer(from, address(0), tokenId);
1448         _afterTokenTransfers(from, address(0), tokenId, 1);
1449 
1450         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1451         unchecked {
1452             _burnCounter++;
1453         }
1454     }
1455 
1456     /**
1457      * @dev Approve `to` to operate on `tokenId`
1458      *
1459      * Emits a {Approval} event.
1460      */
1461     function _approve(
1462         address to,
1463         uint256 tokenId,
1464         address owner
1465     ) private {
1466         _tokenApprovals[tokenId] = to;
1467         emit Approval(owner, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1472      *
1473      * @param from address representing the previous owner of the given token ID
1474      * @param to target address that will receive the tokens
1475      * @param tokenId uint256 ID of the token to be transferred
1476      * @param _data bytes optional data to send along with the call
1477      * @return bool whether the call correctly returned the expected magic value
1478      */
1479     function _checkContractOnERC721Received(
1480         address from,
1481         address to,
1482         uint256 tokenId,
1483         bytes memory _data
1484     ) private returns (bool) {
1485         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1486             return retval == IERC721Receiver(to).onERC721Received.selector;
1487         } catch (bytes memory reason) {
1488             if (reason.length == 0) {
1489                 revert TransferToNonERC721ReceiverImplementer();
1490             } else {
1491                 assembly {
1492                     revert(add(32, reason), mload(reason))
1493                 }
1494             }
1495         }
1496     }
1497 
1498     /**
1499      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1500      * And also called before burning one token.
1501      *
1502      * startTokenId - the first token id to be transferred
1503      * quantity - the amount to be transferred
1504      *
1505      * Calling conditions:
1506      *
1507      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1508      * transferred to `to`.
1509      * - When `from` is zero, `tokenId` will be minted for `to`.
1510      * - When `to` is zero, `tokenId` will be burned by `from`.
1511      * - `from` and `to` are never both zero.
1512      */
1513     function _beforeTokenTransfers(
1514         address from,
1515         address to,
1516         uint256 startTokenId,
1517         uint256 quantity
1518     ) internal virtual {}
1519 
1520     /**
1521      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1522      * minting.
1523      * And also called after one token has been burned.
1524      *
1525      * startTokenId - the first token id to be transferred
1526      * quantity - the amount to be transferred
1527      *
1528      * Calling conditions:
1529      *
1530      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1531      * transferred to `to`.
1532      * - When `from` is zero, `tokenId` has been minted for `to`.
1533      * - When `to` is zero, `tokenId` has been burned by `from`.
1534      * - `from` and `to` are never both zero.
1535      */
1536     function _afterTokenTransfers(
1537         address from,
1538         address to,
1539         uint256 startTokenId,
1540         uint256 quantity
1541     ) internal virtual {}
1542 }
1543 
1544 error InvalidQueryRange();
1545 
1546 /**
1547  * @title ERC721A Queryable
1548  * @dev ERC721A subclass with convenience query functions.
1549  */
1550 abstract contract ERC721AQueryable is ERC721A {
1551     /**
1552      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1553      *
1554      * If the `tokenId` is out of bounds:
1555      *   - `addr` = `address(0)`
1556      *   - `startTimestamp` = `0`
1557      *   - `burned` = `false`
1558      *
1559      * If the `tokenId` is burned:
1560      *   - `addr` = `<Address of owner before token was burned>`
1561      *   - `startTimestamp` = `<Timestamp when token was burned>`
1562      *   - `burned = `true`
1563      *
1564      * Otherwise:
1565      *   - `addr` = `<Address of owner>`
1566      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1567      *   - `burned = `false`
1568      */
1569     function explicitOwnershipOf(uint256 tokenId)
1570         public
1571         view
1572         returns (TokenOwnership memory)
1573     {
1574         TokenOwnership memory ownership;
1575         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1576             return ownership;
1577         }
1578         ownership = _ownerships[tokenId];
1579         if (ownership.burned) {
1580             return ownership;
1581         }
1582         return _ownershipOf(tokenId);
1583     }
1584 
1585     /**
1586      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1587      * See {ERC721AQueryable-explicitOwnershipOf}
1588      */
1589     function explicitOwnershipsOf(uint256[] memory tokenIds)
1590         external
1591         view
1592         returns (TokenOwnership[] memory)
1593     {
1594         unchecked {
1595             uint256 tokenIdsLength = tokenIds.length;
1596             TokenOwnership[] memory ownerships = new TokenOwnership[](
1597                 tokenIdsLength
1598             );
1599             for (uint256 i; i != tokenIdsLength; ++i) {
1600                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1601             }
1602             return ownerships;
1603         }
1604     }
1605 
1606     /**
1607      * @dev Returns an array of token IDs owned by `owner`,
1608      * in the range [`start`, `stop`)
1609      * (i.e. `start <= tokenId < stop`).
1610      *
1611      * This function allows for tokens to be queried if the collection
1612      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1613      *
1614      * Requirements:
1615      *
1616      * - `start` < `stop`
1617      */
1618     function tokensOfOwnerIn(
1619         address owner,
1620         uint256 start,
1621         uint256 stop
1622     ) external view returns (uint256[] memory) {
1623         unchecked {
1624             if (start >= stop) revert InvalidQueryRange();
1625             uint256 tokenIdsIdx;
1626             uint256 stopLimit = _currentIndex;
1627             // Set `start = max(start, _startTokenId())`.
1628             if (start < _startTokenId()) {
1629                 start = _startTokenId();
1630             }
1631             // Set `stop = min(stop, _currentIndex)`.
1632             if (stop > stopLimit) {
1633                 stop = stopLimit;
1634             }
1635             uint256 tokenIdsMaxLength = balanceOf(owner);
1636             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1637             // to cater for cases where `balanceOf(owner)` is too big.
1638             if (start < stop) {
1639                 uint256 rangeLength = stop - start;
1640                 if (rangeLength < tokenIdsMaxLength) {
1641                     tokenIdsMaxLength = rangeLength;
1642                 }
1643             } else {
1644                 tokenIdsMaxLength = 0;
1645             }
1646             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1647             if (tokenIdsMaxLength == 0) {
1648                 return tokenIds;
1649             }
1650             // We need to call `explicitOwnershipOf(start)`,
1651             // because the slot at `start` may not be initialized.
1652             TokenOwnership memory ownership = explicitOwnershipOf(start);
1653             address currOwnershipAddr;
1654             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1655             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1656             if (!ownership.burned) {
1657                 currOwnershipAddr = ownership.addr;
1658             }
1659             for (
1660                 uint256 i = start;
1661                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1662                 ++i
1663             ) {
1664                 ownership = _ownerships[i];
1665                 if (ownership.burned) {
1666                     continue;
1667                 }
1668                 if (ownership.addr != address(0)) {
1669                     currOwnershipAddr = ownership.addr;
1670                 }
1671                 if (currOwnershipAddr == owner) {
1672                     tokenIds[tokenIdsIdx++] = i;
1673                 }
1674             }
1675             // Downsize the array to fit.
1676             assembly {
1677                 mstore(tokenIds, tokenIdsIdx)
1678             }
1679             return tokenIds;
1680         }
1681     }
1682 
1683     /**
1684      * @dev Returns an array of token IDs owned by `owner`.
1685      *
1686      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1687      * It is meant to be called off-chain.
1688      *
1689      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1690      * multiple smaller scans if the collection is large enough to cause
1691      * an out-of-gas error (10K pfp collections should be fine).
1692      */
1693     function tokensOfOwner(address owner)
1694         external
1695         view
1696         returns (uint256[] memory)
1697     {
1698         unchecked {
1699             uint256 tokenIdsIdx;
1700             address currOwnershipAddr;
1701             uint256 tokenIdsLength = balanceOf(owner);
1702             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1703             TokenOwnership memory ownership;
1704             for (
1705                 uint256 i = _startTokenId();
1706                 tokenIdsIdx != tokenIdsLength;
1707                 ++i
1708             ) {
1709                 ownership = _ownerships[i];
1710                 if (ownership.burned) {
1711                     continue;
1712                 }
1713                 if (ownership.addr != address(0)) {
1714                     currOwnershipAddr = ownership.addr;
1715                 }
1716                 if (currOwnershipAddr == owner) {
1717                     tokenIds[tokenIdsIdx++] = i;
1718                 }
1719             }
1720             return tokenIds;
1721         }
1722     }
1723 }
1724 
1725 
1726 
1727 contract RoastingFirepit is  Ownable, ERC721AQueryable {
1728     using SafeMath for uint256;
1729     using Strings for uint256;
1730 
1731     uint256 public MAX_SUPPLY = 5000;
1732 
1733     uint256 public initial = 100000000 ether;
1734 
1735     IERC721 private tokenA;
1736 
1737     IERC20 private tokenB;
1738 
1739     address public tokenAaddress =  0x6079EA481eBb901568E294E8dcdeCFf6AC451B1A;
1740 
1741     address public tokenBaddress =  0xd33B79F237508251e5740c5229f2c8Ea47Ee30C8;
1742 
1743     address public  blackHole = 0x000000000000000000000000000000000000dEaD;
1744 
1745     address public  START_ADDRESS = 0x52cf48eC3485c2F1312d9F1f1Ddd3fcA9CC232e3;
1746 
1747     string baseURI = "https://cdn.monstercave.wtf/meta/dc9f28b12dd1818ee42ffc92ecb940386/json/";
1748 
1749     string public baseExtension = ".json";
1750 
1751     constructor() ERC721A("Roasting Firepit", "Roasting Firepit") {
1752         tokenA = IERC721(tokenAaddress);
1753         tokenB = IERC20(tokenBaddress);
1754     }
1755 
1756     function setUpToken(address _tokenA) public onlyOwner {
1757         tokenA = IERC721(_tokenA);
1758     }
1759 
1760     function setUp20Token(address _tokenB) public onlyOwner {
1761         tokenB = IERC20(_tokenB);
1762     }
1763  
1764     function setUpstartAddress(address _addr) public onlyOwner {
1765         START_ADDRESS = _addr;
1766     }
1767     
1768     function synthesisMint(uint256[] memory _tokenId) public {
1769         uint256  tokenIdLength  = _tokenId.length;
1770         require(tokenIdLength > 1, "need two!");
1771         require(tokenIdLength.mod(2) == 0, "wrong quantity");
1772 
1773         for(uint i = 0;i < tokenIdLength;i++){
1774             require(tokenA.ownerOf(_tokenId[i]) ==  msg.sender, "Insufficient balance");
1775         }
1776 
1777         uint256 tokenQuantity = tokenIdLength.div(2);
1778 
1779         require(totalSupply() + tokenQuantity <= MAX_SUPPLY, "Exceeded maximum supply");
1780 
1781         for(uint i= 0;i < tokenIdLength;i++){
1782             tokenA.transferFrom(msg.sender,blackHole,_tokenId[i]);
1783         }
1784         uint256 number  =  initial.mul(tokenQuantity);
1785         tokenB.transferFrom(START_ADDRESS,msg.sender,number);
1786 
1787         _safeMint(msg.sender, tokenQuantity);
1788     }
1789 
1790     function tokenURI(uint256 tokenId)
1791         public
1792         view
1793         virtual
1794         override
1795         returns (string memory)
1796     {
1797         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1798 
1799         string memory base = _baseURI();
1800         return bytes(base).length != 0 ? string(abi.encodePacked(base, tokenId.toString() , baseExtension)) : '';
1801     }
1802 
1803     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1804         baseURI = _newBaseURI;
1805     }
1806 
1807     function _baseURI() internal view virtual override returns (string memory) {
1808         return baseURI;
1809     }
1810 
1811 }