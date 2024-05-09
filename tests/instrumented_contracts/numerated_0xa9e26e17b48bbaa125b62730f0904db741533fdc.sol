1 // SPDX-License-Identifier: MIT
2 
3 
4 /**
5  * Submitted for verification at Etherscan.io on XXXX-XX-XX
6  * Sales contract inherited from the Bored Ape Yacht Club. Check their opensea at:
7  * https://opensea.io/collection/boredapeyachtclub
8 */
9 
10 // File: @openzeppelin/contracts/utils/Context.sol
11 
12 pragma solidity >=0.6.0 <0.8.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 // File: @openzeppelin/contracts/introspection/IERC165.sol
36 
37 
38 
39 pragma solidity >=0.6.0 <0.8.0;
40 
41 /**
42  * @dev Interface of the ERC165 standard, as defined in the
43  * https://eips.ethereum.org/EIPS/eip-165[EIP].
44  *
45  * Implementers can declare support of contract interfaces, which can then be
46  * queried by others ({ERC165Checker}).
47  *
48  * For an implementation, see {ERC165}.
49  */
50 interface IERC165 {
51     /**
52      * @dev Returns true if this contract implements the interface defined by
53      * `interfaceId`. See the corresponding
54      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
55      * to learn more about how these ids are created.
56      *
57      * This function call must use less than 30 000 gas.
58      */
59     function supportsInterface(bytes4 interfaceId) external view returns (bool);
60 }
61 
62 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
63 
64 
65 
66 pragma solidity >=0.6.2 <0.8.0;
67 
68 
69 /**
70  * @dev Required interface of an ERC721 compliant contract.
71  */
72 interface IERC721 is IERC165 {
73     /**
74      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
77 
78     /**
79      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
80      */
81     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
82 
83     /**
84      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
85      */
86     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
87 
88     /**
89      * @dev Returns the number of tokens in ``owner``'s account.
90      */
91     function balanceOf(address owner) external view returns (uint256 balance);
92 
93     /**
94      * @dev Returns the owner of the `tokenId` token.
95      *
96      * Requirements:
97      *
98      * - `tokenId` must exist.
99      */
100     function ownerOf(uint256 tokenId) external view returns (address owner);
101 
102     /**
103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must exist and be owned by `from`.
111      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
112      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
113      *
114      * Emits a {Transfer} event.
115      */
116     function safeTransferFrom(address from, address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Transfers `tokenId` token from `from` to `to`.
120      *
121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(address from, address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
136      * The approval is cleared when the token is transferred.
137      *
138      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
139      *
140      * Requirements:
141      *
142      * - The caller must own the token or be an approved operator.
143      * - `tokenId` must exist.
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address to, uint256 tokenId) external;
148 
149     /**
150      * @dev Returns the account approved for `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function getApproved(uint256 tokenId) external view returns (address operator);
157 
158     /**
159      * @dev Approve or remove `operator` as an operator for the caller.
160      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
161      *
162      * Requirements:
163      *
164      * - The `operator` cannot be the caller.
165      *
166      * Emits an {ApprovalForAll} event.
167      */
168     function setApprovalForAll(address operator, bool _approved) external;
169 
170     /**
171      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
172      *
173      * See {setApprovalForAll}
174      */
175     function isApprovedForAll(address owner, address operator) external view returns (bool);
176 
177     /**
178       * @dev Safely transfers `tokenId` token from `from` to `to`.
179       *
180       * Requirements:
181       *
182       * - `from` cannot be the zero address.
183       * - `to` cannot be the zero address.
184       * - `tokenId` token must exist and be owned by `from`.
185       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
186       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187       *
188       * Emits a {Transfer} event.
189       */
190     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
191 }
192 
193 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
194 
195 
196 
197 pragma solidity >=0.6.2 <0.8.0;
198 
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Metadata is IERC721 {
205 
206     /**
207      * @dev Returns the token collection name.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the token collection symbol.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
218      */
219     function tokenURI(uint256 tokenId) external view returns (string memory);
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
223 
224 
225 
226 pragma solidity >=0.6.2 <0.8.0;
227 
228 
229 /**
230  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
231  * @dev See https://eips.ethereum.org/EIPS/eip-721
232  */
233 interface IERC721Enumerable is IERC721 {
234 
235     /**
236      * @dev Returns the total amount of tokens stored by the contract.
237      */
238     function totalSupply() external view returns (uint256);
239 
240     /**
241      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
242      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
243      */
244     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
245 
246     /**
247      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
248      * Use along with {totalSupply} to enumerate all tokens.
249      */
250     function tokenByIndex(uint256 index) external view returns (uint256);
251 }
252 
253 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
254 
255 
256 
257 pragma solidity >=0.6.0 <0.8.0;
258 
259 /**
260  * @title ERC721 token receiver interface
261  * @dev Interface for any contract that wants to support safeTransfers
262  * from ERC721 asset contracts.
263  */
264 interface IERC721Receiver {
265     /**
266      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
267      * by `operator` from `from`, this function is called.
268      *
269      * It must return its Solidity selector to confirm the token transfer.
270      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
271      *
272      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
273      */
274     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
275 }
276 
277 // File: @openzeppelin/contracts/introspection/ERC165.sol
278 
279 
280 
281 pragma solidity >=0.6.0 <0.8.0;
282 
283 
284 /**
285  * @dev Implementation of the {IERC165} interface.
286  *
287  * Contracts may inherit from this and call {_registerInterface} to declare
288  * their support of an interface.
289  */
290 abstract contract ERC165 is IERC165 {
291     /*
292      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
293      */
294     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
295 
296     /**
297      * @dev Mapping of interface ids to whether or not it's supported.
298      */
299     mapping(bytes4 => bool) private _supportedInterfaces;
300 
301     constructor () internal {
302         // Derived contracts need only register support for their own interfaces,
303         // we register support for ERC165 itself here
304         _registerInterface(_INTERFACE_ID_ERC165);
305     }
306 
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      *
310      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return _supportedInterfaces[interfaceId];
314     }
315 
316     /**
317      * @dev Registers the contract as an implementer of the interface defined by
318      * `interfaceId`. Support of the actual ERC165 interface is automatic and
319      * registering its interface id is not required.
320      *
321      * See {IERC165-supportsInterface}.
322      *
323      * Requirements:
324      *
325      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
326      */
327     function _registerInterface(bytes4 interfaceId) internal virtual {
328         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
329         _supportedInterfaces[interfaceId] = true;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/math/SafeMath.sol
334 
335 
336 
337 pragma solidity >=0.6.0 <0.8.0;
338 
339 /**
340  * @dev Wrappers over Solidity's arithmetic operations with added overflow
341  * checks.
342  *
343  * Arithmetic operations in Solidity wrap on overflow. This can easily result
344  * in bugs, because programmers usually assume that an overflow raises an
345  * error, which is the standard behavior in high level programming languages.
346  * `SafeMath` restores this intuition by reverting the transaction when an
347  * operation overflows.
348  *
349  * Using this library instead of the unchecked operations eliminates an entire
350  * class of bugs, so it's recommended to use it always.
351  */
352 library SafeMath {
353     /**
354      * @dev Returns the addition of two unsigned integers, with an overflow flag.
355      *
356      * _Available since v3.4._
357      */
358     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
359         uint256 c = a + b;
360         if (c < a) return (false, 0);
361         return (true, c);
362     }
363 
364     /**
365      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
366      *
367      * _Available since v3.4._
368      */
369     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         if (b > a) return (false, 0);
371         return (true, a - b);
372     }
373 
374     /**
375      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
376      *
377      * _Available since v3.4._
378      */
379     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
380         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
381         // benefit is lost if 'b' is also tested.
382         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
383         if (a == 0) return (true, 0);
384         uint256 c = a * b;
385         if (c / a != b) return (false, 0);
386         return (true, c);
387     }
388 
389     /**
390      * @dev Returns the division of two unsigned integers, with a division by zero flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
395         if (b == 0) return (false, 0);
396         return (true, a / b);
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
401      *
402      * _Available since v3.4._
403      */
404     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
405         if (b == 0) return (false, 0);
406         return (true, a % b);
407     }
408 
409     /**
410      * @dev Returns the addition of two unsigned integers, reverting on
411      * overflow.
412      *
413      * Counterpart to Solidity's `+` operator.
414      *
415      * Requirements:
416      *
417      * - Addition cannot overflow.
418      */
419     function add(uint256 a, uint256 b) internal pure returns (uint256) {
420         uint256 c = a + b;
421         require(c >= a, "SafeMath: addition overflow");
422         return c;
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting on
427      * overflow (when the result is negative).
428      *
429      * Counterpart to Solidity's `-` operator.
430      *
431      * Requirements:
432      *
433      * - Subtraction cannot overflow.
434      */
435     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436         require(b <= a, "SafeMath: subtraction overflow");
437         return a - b;
438     }
439 
440     /**
441      * @dev Returns the multiplication of two unsigned integers, reverting on
442      * overflow.
443      *
444      * Counterpart to Solidity's `*` operator.
445      *
446      * Requirements:
447      *
448      * - Multiplication cannot overflow.
449      */
450     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
451         if (a == 0) return 0;
452         uint256 c = a * b;
453         require(c / a == b, "SafeMath: multiplication overflow");
454         return c;
455     }
456 
457     /**
458      * @dev Returns the integer division of two unsigned integers, reverting on
459      * division by zero. The result is rounded towards zero.
460      *
461      * Counterpart to Solidity's `/` operator. Note: this function uses a
462      * `revert` opcode (which leaves remaining gas untouched) while Solidity
463      * uses an invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function div(uint256 a, uint256 b) internal pure returns (uint256) {
470         require(b > 0, "SafeMath: division by zero");
471         return a / b;
472     }
473 
474     /**
475      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
476      * reverting when dividing by zero.
477      *
478      * Counterpart to Solidity's `%` operator. This function uses a `revert`
479      * opcode (which leaves remaining gas untouched) while Solidity uses an
480      * invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
487         require(b > 0, "SafeMath: modulo by zero");
488         return a % b;
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * CAUTION: This function is deprecated because it requires allocating memory for the error
496      * message unnecessarily. For custom revert reasons use {trySub}.
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b <= a, errorMessage);
506         return a - b;
507     }
508 
509     /**
510      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
511      * division by zero. The result is rounded towards zero.
512      *
513      * CAUTION: This function is deprecated because it requires allocating memory for the error
514      * message unnecessarily. For custom revert reasons use {tryDiv}.
515      *
516      * Counterpart to Solidity's `/` operator. Note: this function uses a
517      * `revert` opcode (which leaves remaining gas untouched) while Solidity
518      * uses an invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
525         require(b > 0, errorMessage);
526         return a / b;
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
531      * reverting with custom message when dividing by zero.
532      *
533      * CAUTION: This function is deprecated because it requires allocating memory for the error
534      * message unnecessarily. For custom revert reasons use {tryMod}.
535      *
536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
537      * opcode (which leaves remaining gas untouched) while Solidity uses an
538      * invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b > 0, errorMessage);
546         return a % b;
547     }
548 }
549 
550 // File: @openzeppelin/contracts/utils/Address.sol
551 
552 
553 
554 pragma solidity >=0.6.2 <0.8.0;
555 
556 /**
557  * @dev Collection of functions related to the address type
558  */
559 library Address {
560     /**
561      * @dev Returns true if `account` is a contract.
562      *
563      * [IMPORTANT]
564      * ====
565      * It is unsafe to assume that an address for which this function returns
566      * false is an externally-owned account (EOA) and not a contract.
567      *
568      * Among others, `isContract` will return false for the following
569      * types of addresses:
570      *
571      *  - an externally-owned account
572      *  - a contract in construction
573      *  - an address where a contract will be created
574      *  - an address where a contract lived, but was destroyed
575      * ====
576      */
577     function isContract(address account) internal view returns (bool) {
578         // This method relies on extcodesize, which returns 0 for contracts in
579         // construction, since the code is only stored at the end of the
580         // constructor execution.
581 
582         uint256 size;
583         // solhint-disable-next-line no-inline-assembly
584         assembly { size := extcodesize(account) }
585         return size > 0;
586     }
587 
588     /**
589      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
590      * `recipient`, forwarding all available gas and reverting on errors.
591      *
592      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
593      * of certain opcodes, possibly making contracts go over the 2300 gas limit
594      * imposed by `transfer`, making them unable to receive funds via
595      * `transfer`. {sendValue} removes this limitation.
596      *
597      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
598      *
599      * IMPORTANT: because control is transferred to `recipient`, care must be
600      * taken to not create reentrancy vulnerabilities. Consider using
601      * {ReentrancyGuard} or the
602      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
603      */
604     function sendValue(address payable recipient, uint256 amount) internal {
605         require(address(this).balance >= amount, "Address: insufficient balance");
606 
607         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
608         (bool success, ) = recipient.call{ value: amount }("");
609         require(success, "Address: unable to send value, recipient may have reverted");
610     }
611 
612     /**
613      * @dev Performs a Solidity function call using a low level `call`. A
614      * plain`call` is an unsafe replacement for a function call: use this
615      * function instead.
616      *
617      * If `target` reverts with a revert reason, it is bubbled up by this
618      * function (like regular Solidity function calls).
619      *
620      * Returns the raw returned data. To convert to the expected return value,
621      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
622      *
623      * Requirements:
624      *
625      * - `target` must be a contract.
626      * - calling `target` with `data` must not revert.
627      *
628      * _Available since v3.1._
629      */
630     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
631       return functionCall(target, data, "Address: low-level call failed");
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
636      * `errorMessage` as a fallback revert reason when `target` reverts.
637      *
638      * _Available since v3.1._
639      */
640     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
641         return functionCallWithValue(target, data, 0, errorMessage);
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
646      * but also transferring `value` wei to `target`.
647      *
648      * Requirements:
649      *
650      * - the calling contract must have an ETH balance of at least `value`.
651      * - the called Solidity function must be `payable`.
652      *
653      * _Available since v3.1._
654      */
655     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
656         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
661      * with `errorMessage` as a fallback revert reason when `target` reverts.
662      *
663      * _Available since v3.1._
664      */
665     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
666         require(address(this).balance >= value, "Address: insufficient balance for call");
667         require(isContract(target), "Address: call to non-contract");
668 
669         // solhint-disable-next-line avoid-low-level-calls
670         (bool success, bytes memory returndata) = target.call{ value: value }(data);
671         return _verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but performing a static call.
677      *
678      * _Available since v3.3._
679      */
680     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
681         return functionStaticCall(target, data, "Address: low-level static call failed");
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
686      * but performing a static call.
687      *
688      * _Available since v3.3._
689      */
690     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
691         require(isContract(target), "Address: static call to non-contract");
692 
693         // solhint-disable-next-line avoid-low-level-calls
694         (bool success, bytes memory returndata) = target.staticcall(data);
695         return _verifyCallResult(success, returndata, errorMessage);
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
700      * but performing a delegate call.
701      *
702      * _Available since v3.4._
703      */
704     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
705         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
710      * but performing a delegate call.
711      *
712      * _Available since v3.4._
713      */
714     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
715         require(isContract(target), "Address: delegate call to non-contract");
716 
717         // solhint-disable-next-line avoid-low-level-calls
718         (bool success, bytes memory returndata) = target.delegatecall(data);
719         return _verifyCallResult(success, returndata, errorMessage);
720     }
721 
722     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
723         if (success) {
724             return returndata;
725         } else {
726             // Look for revert reason and bubble it up if present
727             if (returndata.length > 0) {
728                 // The easiest way to bubble the revert reason is using memory via assembly
729 
730                 // solhint-disable-next-line no-inline-assembly
731                 assembly {
732                     let returndata_size := mload(returndata)
733                     revert(add(32, returndata), returndata_size)
734                 }
735             } else {
736                 revert(errorMessage);
737             }
738         }
739     }
740 }
741 
742 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
743 
744 
745 
746 pragma solidity >=0.6.0 <0.8.0;
747 
748 /**
749  * @dev Library for managing
750  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
751  * types.
752  *
753  * Sets have the following properties:
754  *
755  * - Elements are added, removed, and checked for existence in constant time
756  * (O(1)).
757  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
758  *
759  * ```
760  * contract Example {
761  *     // Add the library methods
762  *     using EnumerableSet for EnumerableSet.AddressSet;
763  *
764  *     // Declare a set state variable
765  *     EnumerableSet.AddressSet private mySet;
766  * }
767  * ```
768  *
769  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
770  * and `uint256` (`UintSet`) are supported.
771  */
772 library EnumerableSet {
773     // To implement this library for multiple types with as little code
774     // repetition as possible, we write it in terms of a generic Set type with
775     // bytes32 values.
776     // The Set implementation uses private functions, and user-facing
777     // implementations (such as AddressSet) are just wrappers around the
778     // underlying Set.
779     // This means that we can only create new EnumerableSets for types that fit
780     // in bytes32.
781 
782     struct Set {
783         // Storage of set values
784         bytes32[] _values;
785 
786         // Position of the value in the `values` array, plus 1 because index 0
787         // means a value is not in the set.
788         mapping (bytes32 => uint256) _indexes;
789     }
790 
791     /**
792      * @dev Add a value to a set. O(1).
793      *
794      * Returns true if the value was added to the set, that is if it was not
795      * already present.
796      */
797     function _add(Set storage set, bytes32 value) private returns (bool) {
798         if (!_contains(set, value)) {
799             set._values.push(value);
800             // The value is stored at length-1, but we add 1 to all indexes
801             // and use 0 as a sentinel value
802             set._indexes[value] = set._values.length;
803             return true;
804         } else {
805             return false;
806         }
807     }
808 
809     /**
810      * @dev Removes a value from a set. O(1).
811      *
812      * Returns true if the value was removed from the set, that is if it was
813      * present.
814      */
815     function _remove(Set storage set, bytes32 value) private returns (bool) {
816         // We read and store the value's index to prevent multiple reads from the same storage slot
817         uint256 valueIndex = set._indexes[value];
818 
819         if (valueIndex != 0) { // Equivalent to contains(set, value)
820             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
821             // the array, and then remove the last element (sometimes called as 'swap and pop').
822             // This modifies the order of the array, as noted in {at}.
823 
824             uint256 toDeleteIndex = valueIndex - 1;
825             uint256 lastIndex = set._values.length - 1;
826 
827             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
828             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
829 
830             bytes32 lastvalue = set._values[lastIndex];
831 
832             // Move the last value to the index where the value to delete is
833             set._values[toDeleteIndex] = lastvalue;
834             // Update the index for the moved value
835             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
836 
837             // Delete the slot where the moved value was stored
838             set._values.pop();
839 
840             // Delete the index for the deleted slot
841             delete set._indexes[value];
842 
843             return true;
844         } else {
845             return false;
846         }
847     }
848 
849     /**
850      * @dev Returns true if the value is in the set. O(1).
851      */
852     function _contains(Set storage set, bytes32 value) private view returns (bool) {
853         return set._indexes[value] != 0;
854     }
855 
856     /**
857      * @dev Returns the number of values on the set. O(1).
858      */
859     function _length(Set storage set) private view returns (uint256) {
860         return set._values.length;
861     }
862 
863    /**
864     * @dev Returns the value stored at position `index` in the set. O(1).
865     *
866     * Note that there are no guarantees on the ordering of values inside the
867     * array, and it may change when more values are added or removed.
868     *
869     * Requirements:
870     *
871     * - `index` must be strictly less than {length}.
872     */
873     function _at(Set storage set, uint256 index) private view returns (bytes32) {
874         require(set._values.length > index, "EnumerableSet: index out of bounds");
875         return set._values[index];
876     }
877 
878     // Bytes32Set
879 
880     struct Bytes32Set {
881         Set _inner;
882     }
883 
884     /**
885      * @dev Add a value to a set. O(1).
886      *
887      * Returns true if the value was added to the set, that is if it was not
888      * already present.
889      */
890     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
891         return _add(set._inner, value);
892     }
893 
894     /**
895      * @dev Removes a value from a set. O(1).
896      *
897      * Returns true if the value was removed from the set, that is if it was
898      * present.
899      */
900     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
901         return _remove(set._inner, value);
902     }
903 
904     /**
905      * @dev Returns true if the value is in the set. O(1).
906      */
907     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
908         return _contains(set._inner, value);
909     }
910 
911     /**
912      * @dev Returns the number of values in the set. O(1).
913      */
914     function length(Bytes32Set storage set) internal view returns (uint256) {
915         return _length(set._inner);
916     }
917 
918    /**
919     * @dev Returns the value stored at position `index` in the set. O(1).
920     *
921     * Note that there are no guarantees on the ordering of values inside the
922     * array, and it may change when more values are added or removed.
923     *
924     * Requirements:
925     *
926     * - `index` must be strictly less than {length}.
927     */
928     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
929         return _at(set._inner, index);
930     }
931 
932     // AddressSet
933 
934     struct AddressSet {
935         Set _inner;
936     }
937 
938     /**
939      * @dev Add a value to a set. O(1).
940      *
941      * Returns true if the value was added to the set, that is if it was not
942      * already present.
943      */
944     function add(AddressSet storage set, address value) internal returns (bool) {
945         return _add(set._inner, bytes32(uint256(uint160(value))));
946     }
947 
948     /**
949      * @dev Removes a value from a set. O(1).
950      *
951      * Returns true if the value was removed from the set, that is if it was
952      * present.
953      */
954     function remove(AddressSet storage set, address value) internal returns (bool) {
955         return _remove(set._inner, bytes32(uint256(uint160(value))));
956     }
957 
958     /**
959      * @dev Returns true if the value is in the set. O(1).
960      */
961     function contains(AddressSet storage set, address value) internal view returns (bool) {
962         return _contains(set._inner, bytes32(uint256(uint160(value))));
963     }
964 
965     /**
966      * @dev Returns the number of values in the set. O(1).
967      */
968     function length(AddressSet storage set) internal view returns (uint256) {
969         return _length(set._inner);
970     }
971 
972    /**
973     * @dev Returns the value stored at position `index` in the set. O(1).
974     *
975     * Note that there are no guarantees on the ordering of values inside the
976     * array, and it may change when more values are added or removed.
977     *
978     * Requirements:
979     *
980     * - `index` must be strictly less than {length}.
981     */
982     function at(AddressSet storage set, uint256 index) internal view returns (address) {
983         return address(uint160(uint256(_at(set._inner, index))));
984     }
985 
986 
987     // UintSet
988 
989     struct UintSet {
990         Set _inner;
991     }
992 
993     /**
994      * @dev Add a value to a set. O(1).
995      *
996      * Returns true if the value was added to the set, that is if it was not
997      * already present.
998      */
999     function add(UintSet storage set, uint256 value) internal returns (bool) {
1000         return _add(set._inner, bytes32(value));
1001     }
1002 
1003     /**
1004      * @dev Removes a value from a set. O(1).
1005      *
1006      * Returns true if the value was removed from the set, that is if it was
1007      * present.
1008      */
1009     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1010         return _remove(set._inner, bytes32(value));
1011     }
1012 
1013     /**
1014      * @dev Returns true if the value is in the set. O(1).
1015      */
1016     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1017         return _contains(set._inner, bytes32(value));
1018     }
1019 
1020     /**
1021      * @dev Returns the number of values on the set. O(1).
1022      */
1023     function length(UintSet storage set) internal view returns (uint256) {
1024         return _length(set._inner);
1025     }
1026 
1027    /**
1028     * @dev Returns the value stored at position `index` in the set. O(1).
1029     *
1030     * Note that there are no guarantees on the ordering of values inside the
1031     * array, and it may change when more values are added or removed.
1032     *
1033     * Requirements:
1034     *
1035     * - `index` must be strictly less than {length}.
1036     */
1037     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1038         return uint256(_at(set._inner, index));
1039     }
1040 }
1041 
1042 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1043 
1044 
1045 
1046 pragma solidity >=0.6.0 <0.8.0;
1047 
1048 /**
1049  * @dev Library for managing an enumerable variant of Solidity's
1050  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1051  * type.
1052  *
1053  * Maps have the following properties:
1054  *
1055  * - Entries are added, removed, and checked for existence in constant time
1056  * (O(1)).
1057  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1058  *
1059  * ```
1060  * contract Example {
1061  *     // Add the library methods
1062  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1063  *
1064  *     // Declare a set state variable
1065  *     EnumerableMap.UintToAddressMap private myMap;
1066  * }
1067  * ```
1068  *
1069  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1070  * supported.
1071  */
1072 library EnumerableMap {
1073     // To implement this library for multiple types with as little code
1074     // repetition as possible, we write it in terms of a generic Map type with
1075     // bytes32 keys and values.
1076     // The Map implementation uses private functions, and user-facing
1077     // implementations (such as Uint256ToAddressMap) are just wrappers around
1078     // the underlying Map.
1079     // This means that we can only create new EnumerableMaps for types that fit
1080     // in bytes32.
1081 
1082     struct MapEntry {
1083         bytes32 _key;
1084         bytes32 _value;
1085     }
1086 
1087     struct Map {
1088         // Storage of map keys and values
1089         MapEntry[] _entries;
1090 
1091         // Position of the entry defined by a key in the `entries` array, plus 1
1092         // because index 0 means a key is not in the map.
1093         mapping (bytes32 => uint256) _indexes;
1094     }
1095 
1096     /**
1097      * @dev Adds a key-value pair to a map, or updates the value for an existing
1098      * key. O(1).
1099      *
1100      * Returns true if the key was added to the map, that is if it was not
1101      * already present.
1102      */
1103     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1104         // We read and store the key's index to prevent multiple reads from the same storage slot
1105         uint256 keyIndex = map._indexes[key];
1106 
1107         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1108             map._entries.push(MapEntry({ _key: key, _value: value }));
1109             // The entry is stored at length-1, but we add 1 to all indexes
1110             // and use 0 as a sentinel value
1111             map._indexes[key] = map._entries.length;
1112             return true;
1113         } else {
1114             map._entries[keyIndex - 1]._value = value;
1115             return false;
1116         }
1117     }
1118 
1119     /**
1120      * @dev Removes a key-value pair from a map. O(1).
1121      *
1122      * Returns true if the key was removed from the map, that is if it was present.
1123      */
1124     function _remove(Map storage map, bytes32 key) private returns (bool) {
1125         // We read and store the key's index to prevent multiple reads from the same storage slot
1126         uint256 keyIndex = map._indexes[key];
1127 
1128         if (keyIndex != 0) { // Equivalent to contains(map, key)
1129             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1130             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1131             // This modifies the order of the array, as noted in {at}.
1132 
1133             uint256 toDeleteIndex = keyIndex - 1;
1134             uint256 lastIndex = map._entries.length - 1;
1135 
1136             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1137             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1138 
1139             MapEntry storage lastEntry = map._entries[lastIndex];
1140 
1141             // Move the last entry to the index where the entry to delete is
1142             map._entries[toDeleteIndex] = lastEntry;
1143             // Update the index for the moved entry
1144             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1145 
1146             // Delete the slot where the moved entry was stored
1147             map._entries.pop();
1148 
1149             // Delete the index for the deleted slot
1150             delete map._indexes[key];
1151 
1152             return true;
1153         } else {
1154             return false;
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns true if the key is in the map. O(1).
1160      */
1161     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1162         return map._indexes[key] != 0;
1163     }
1164 
1165     /**
1166      * @dev Returns the number of key-value pairs in the map. O(1).
1167      */
1168     function _length(Map storage map) private view returns (uint256) {
1169         return map._entries.length;
1170     }
1171 
1172    /**
1173     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1174     *
1175     * Note that there are no guarantees on the ordering of entries inside the
1176     * array, and it may change when more entries are added or removed.
1177     *
1178     * Requirements:
1179     *
1180     * - `index` must be strictly less than {length}.
1181     */
1182     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1183         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1184 
1185         MapEntry storage entry = map._entries[index];
1186         return (entry._key, entry._value);
1187     }
1188 
1189     /**
1190      * @dev Tries to returns the value associated with `key`.  O(1).
1191      * Does not revert if `key` is not in the map.
1192      */
1193     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1194         uint256 keyIndex = map._indexes[key];
1195         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1196         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1197     }
1198 
1199     /**
1200      * @dev Returns the value associated with `key`.  O(1).
1201      *
1202      * Requirements:
1203      *
1204      * - `key` must be in the map.
1205      */
1206     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1207         uint256 keyIndex = map._indexes[key];
1208         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1209         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1210     }
1211 
1212     /**
1213      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1214      *
1215      * CAUTION: This function is deprecated because it requires allocating memory for the error
1216      * message unnecessarily. For custom revert reasons use {_tryGet}.
1217      */
1218     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1219         uint256 keyIndex = map._indexes[key];
1220         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1221         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1222     }
1223 
1224     // UintToAddressMap
1225 
1226     struct UintToAddressMap {
1227         Map _inner;
1228     }
1229 
1230     /**
1231      * @dev Adds a key-value pair to a map, or updates the value for an existing
1232      * key. O(1).
1233      *
1234      * Returns true if the key was added to the map, that is if it was not
1235      * already present.
1236      */
1237     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1238         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1239     }
1240 
1241     /**
1242      * @dev Removes a value from a set. O(1).
1243      *
1244      * Returns true if the key was removed from the map, that is if it was present.
1245      */
1246     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1247         return _remove(map._inner, bytes32(key));
1248     }
1249 
1250     /**
1251      * @dev Returns true if the key is in the map. O(1).
1252      */
1253     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1254         return _contains(map._inner, bytes32(key));
1255     }
1256 
1257     /**
1258      * @dev Returns the number of elements in the map. O(1).
1259      */
1260     function length(UintToAddressMap storage map) internal view returns (uint256) {
1261         return _length(map._inner);
1262     }
1263 
1264    /**
1265     * @dev Returns the element stored at position `index` in the set. O(1).
1266     * Note that there are no guarantees on the ordering of values inside the
1267     * array, and it may change when more values are added or removed.
1268     *
1269     * Requirements:
1270     *
1271     * - `index` must be strictly less than {length}.
1272     */
1273     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1274         (bytes32 key, bytes32 value) = _at(map._inner, index);
1275         return (uint256(key), address(uint160(uint256(value))));
1276     }
1277 
1278     /**
1279      * @dev Tries to returns the value associated with `key`.  O(1).
1280      * Does not revert if `key` is not in the map.
1281      *
1282      * _Available since v3.4._
1283      */
1284     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1285         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1286         return (success, address(uint160(uint256(value))));
1287     }
1288 
1289     /**
1290      * @dev Returns the value associated with `key`.  O(1).
1291      *
1292      * Requirements:
1293      *
1294      * - `key` must be in the map.
1295      */
1296     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1297         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1298     }
1299 
1300     /**
1301      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1302      *
1303      * CAUTION: This function is deprecated because it requires allocating memory for the error
1304      * message unnecessarily. For custom revert reasons use {tryGet}.
1305      */
1306     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1307         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1308     }
1309 }
1310 
1311 // File: @openzeppelin/contracts/utils/Strings.sol
1312 
1313 
1314 
1315 pragma solidity >=0.6.0 <0.8.0;
1316 
1317 /**
1318  * @dev String operations.
1319  */
1320 library Strings {
1321     /**
1322      * @dev Converts a `uint256` to its ASCII `string` representation.
1323      */
1324     function toString(uint256 value) internal pure returns (string memory) {
1325         // Inspired by OraclizeAPI's implementation - MIT licence
1326         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1327 
1328         if (value == 0) {
1329             return "0";
1330         }
1331         uint256 temp = value;
1332         uint256 digits;
1333         while (temp != 0) {
1334             digits++;
1335             temp /= 10;
1336         }
1337         bytes memory buffer = new bytes(digits);
1338         uint256 index = digits - 1;
1339         temp = value;
1340         while (temp != 0) {
1341             buffer[index--] = bytes1(uint8(48 + temp % 10));
1342             temp /= 10;
1343         }
1344         return string(buffer);
1345     }
1346 }
1347 
1348 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1349 
1350 
1351 
1352 pragma solidity >=0.6.0 <0.8.0;
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 
1362 
1363 
1364 
1365 /**
1366  * @title ERC721 Non-Fungible Token Standard basic implementation
1367  * @dev see https://eips.ethereum.org/EIPS/eip-721
1368  */
1369 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1370     using SafeMath for uint256;
1371     using Address for address;
1372     using EnumerableSet for EnumerableSet.UintSet;
1373     using EnumerableMap for EnumerableMap.UintToAddressMap;
1374     using Strings for uint256;
1375 
1376     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1377     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1378     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1379 
1380     // Mapping from holder address to their (enumerable) set of owned tokens
1381     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1382 
1383     // Enumerable mapping from token ids to their owners
1384     EnumerableMap.UintToAddressMap private _tokenOwners;
1385 
1386     // Mapping from token ID to approved address
1387     mapping (uint256 => address) private _tokenApprovals;
1388 
1389     // Mapping from owner to operator approvals
1390     mapping (address => mapping (address => bool)) private _operatorApprovals;
1391 
1392     // Token name
1393     string private _name;
1394 
1395     // Token symbol
1396     string private _symbol;
1397 
1398     // Optional mapping for token URIs
1399     mapping (uint256 => string) private _tokenURIs;
1400 
1401     // Base URI
1402     string private _baseURI;
1403 
1404     /*
1405      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1406      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1407      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1408      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1409      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1410      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1411      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1412      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1413      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1414      *
1415      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1416      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1417      */
1418     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1419 
1420     /*
1421      *     bytes4(keccak256('name()')) == 0x06fdde03
1422      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1423      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1424      *
1425      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1426      */
1427     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1428 
1429     /*
1430      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1431      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1432      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1433      *
1434      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1435      */
1436     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1437 
1438     /**
1439      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1440      */
1441     constructor (string memory name_, string memory symbol_) public {
1442         _name = name_;
1443         _symbol = symbol_;
1444 
1445         // register the supported interfaces to conform to ERC721 via ERC165
1446         _registerInterface(_INTERFACE_ID_ERC721);
1447         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1448         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-balanceOf}.
1453      */
1454     function balanceOf(address owner) public view virtual override returns (uint256) {
1455         require(owner != address(0), "ERC721: balance query for the zero address");
1456         return _holderTokens[owner].length();
1457     }
1458 
1459     /**
1460      * @dev See {IERC721-ownerOf}.
1461      */
1462     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1463         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Metadata-name}.
1468      */
1469     function name() public view virtual override returns (string memory) {
1470         return _name;
1471     }
1472 
1473     /**
1474      * @dev See {IERC721Metadata-symbol}.
1475      */
1476     function symbol() public view virtual override returns (string memory) {
1477         return _symbol;
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Metadata-tokenURI}.
1482      */
1483     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1484         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1485 
1486         string memory _tokenURI = _tokenURIs[tokenId];
1487         string memory base = baseURI();
1488 
1489         // If there is no base URI, return the token URI.
1490         if (bytes(base).length == 0) {
1491             return _tokenURI;
1492         }
1493         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1494         if (bytes(_tokenURI).length > 0) {
1495             return string(abi.encodePacked(base, _tokenURI));
1496         }
1497         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1498         return string(abi.encodePacked(base, tokenId.toString()));
1499     }
1500 
1501     /**
1502     * @dev Returns the base URI set via {_setBaseURI}. This will be
1503     * automatically added as a prefix in {tokenURI} to each token's URI, or
1504     * to the token ID if no specific URI is set for that token ID.
1505     */
1506     function baseURI() public view virtual returns (string memory) {
1507         return _baseURI;
1508     }
1509 
1510     /**
1511      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1512      */
1513     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1514         return _holderTokens[owner].at(index);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721Enumerable-totalSupply}.
1519      */
1520     function totalSupply() public view virtual override returns (uint256) {
1521         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1522         return _tokenOwners.length();
1523     }
1524 
1525     /**
1526      * @dev See {IERC721Enumerable-tokenByIndex}.
1527      */
1528     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1529         (uint256 tokenId, ) = _tokenOwners.at(index);
1530         return tokenId;
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-approve}.
1535      */
1536     function approve(address to, uint256 tokenId) public virtual override {
1537         address owner = ERC721.ownerOf(tokenId);
1538         require(to != owner, "ERC721: approval to current owner");
1539 
1540         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1541             "ERC721: approve caller is not owner nor approved for all"
1542         );
1543 
1544         _approve(to, tokenId);
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-getApproved}.
1549      */
1550     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1551         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1552 
1553         return _tokenApprovals[tokenId];
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-setApprovalForAll}.
1558      */
1559     function setApprovalForAll(address operator, bool approved) public virtual override {
1560         require(operator != _msgSender(), "ERC721: approve to caller");
1561 
1562         _operatorApprovals[_msgSender()][operator] = approved;
1563         emit ApprovalForAll(_msgSender(), operator, approved);
1564     }
1565 
1566     /**
1567      * @dev See {IERC721-isApprovedForAll}.
1568      */
1569     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1570         return _operatorApprovals[owner][operator];
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-transferFrom}.
1575      */
1576     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1577         //solhint-disable-next-line max-line-length
1578         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1579 
1580         _transfer(from, to, tokenId);
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-safeTransferFrom}.
1585      */
1586     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1587         safeTransferFrom(from, to, tokenId, "");
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-safeTransferFrom}.
1592      */
1593     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1594         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1595         _safeTransfer(from, to, tokenId, _data);
1596     }
1597 
1598     /**
1599      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1600      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1601      *
1602      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1603      *
1604      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1605      * implement alternative mechanisms to perform token transfer, such as signature-based.
1606      *
1607      * Requirements:
1608      *
1609      * - `from` cannot be the zero address.
1610      * - `to` cannot be the zero address.
1611      * - `tokenId` token must exist and be owned by `from`.
1612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1617         _transfer(from, to, tokenId);
1618         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1619     }
1620 
1621     /**
1622      * @dev Returns whether `tokenId` exists.
1623      *
1624      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1625      *
1626      * Tokens start existing when they are minted (`_mint`),
1627      * and stop existing when they are burned (`_burn`).
1628      */
1629     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1630         return _tokenOwners.contains(tokenId);
1631     }
1632 
1633     /**
1634      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1635      *
1636      * Requirements:
1637      *
1638      * - `tokenId` must exist.
1639      */
1640     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1641         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1642         address owner = ERC721.ownerOf(tokenId);
1643         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1644     }
1645 
1646     /**
1647      * @dev Safely mints `tokenId` and transfers it to `to`.
1648      *
1649      * Requirements:
1650      d*
1651      * - `tokenId` must not exist.
1652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1653      *
1654      * Emits a {Transfer} event.
1655      */
1656     function _safeMint(address to, uint256 tokenId) internal virtual {
1657         _safeMint(to, tokenId, "");
1658     }
1659 
1660     /**
1661      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1662      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1663      */
1664     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1665         _mint(to, tokenId);
1666         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1667     }
1668 
1669     /**
1670      * @dev Mints `tokenId` and transfers it to `to`.
1671      *
1672      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1673      *
1674      * Requirements:
1675      *
1676      * - `tokenId` must not exist.
1677      * - `to` cannot be the zero address.
1678      *
1679      * Emits a {Transfer} event.
1680      */
1681     function _mint(address to, uint256 tokenId) internal virtual {
1682         require(to != address(0), "ERC721: mint to the zero address");
1683         require(!_exists(tokenId), "ERC721: token already minted");
1684 
1685         _beforeTokenTransfer(address(0), to, tokenId);
1686 
1687         _holderTokens[to].add(tokenId);
1688 
1689         _tokenOwners.set(tokenId, to);
1690 
1691         emit Transfer(address(0), to, tokenId);
1692     }
1693 
1694     /**
1695      * @dev Destroys `tokenId`.
1696      * The approval is cleared when the token is burned.
1697      *
1698      * Requirements:
1699      *
1700      * - `tokenId` must exist.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _burn(uint256 tokenId) internal virtual {
1705         address owner = ERC721.ownerOf(tokenId); // internal owner
1706 
1707         _beforeTokenTransfer(owner, address(0), tokenId);
1708 
1709         // Clear approvals
1710         _approve(address(0), tokenId);
1711 
1712         // Clear metadata (if any)
1713         if (bytes(_tokenURIs[tokenId]).length != 0) {
1714             delete _tokenURIs[tokenId];
1715         }
1716 
1717         _holderTokens[owner].remove(tokenId);
1718 
1719         _tokenOwners.remove(tokenId);
1720 
1721         emit Transfer(owner, address(0), tokenId);
1722     }
1723 
1724     /**
1725      * @dev Transfers `tokenId` from `from` to `to`.
1726      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1727      *
1728      * Requirements:
1729      *
1730      * - `to` cannot be the zero address.
1731      * - `tokenId` token must be owned by `from`.
1732      *
1733      * Emits a {Transfer} event.
1734      */
1735     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1736         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1737         require(to != address(0), "ERC721: transfer to the zero address");
1738 
1739         _beforeTokenTransfer(from, to, tokenId);
1740 
1741         // Clear approvals from the previous owner
1742         _approve(address(0), tokenId);
1743 
1744         _holderTokens[from].remove(tokenId);
1745         _holderTokens[to].add(tokenId);
1746 
1747         _tokenOwners.set(tokenId, to);
1748 
1749         emit Transfer(from, to, tokenId);
1750     }
1751 
1752     /**
1753      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1754      *
1755      * Requirements:
1756      *
1757      * - `tokenId` must exist.
1758      */
1759     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1760         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1761         _tokenURIs[tokenId] = _tokenURI;
1762     }
1763 
1764     /**
1765      * @dev Internal function to set the base URI for all token IDs. It is
1766      * automatically added as a prefix to the value returned in {tokenURI},
1767      * or to the token ID if {tokenURI} is empty.
1768      */
1769     function _setBaseURI(string memory baseURI_) internal virtual {
1770         _baseURI = baseURI_;
1771     }
1772 
1773     /**
1774      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1775      * The call is not executed if the target address is not a contract.
1776      *
1777      * @param from address representing the previous owner of the given token ID
1778      * @param to target address that will receive the tokens
1779      * @param tokenId uint256 ID of the token to be transferred
1780      * @param _data bytes optional data to send along with the call
1781      * @return bool whether the call correctly returned the expected magic value
1782      */
1783     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1784         private returns (bool)
1785     {
1786         if (!to.isContract()) {
1787             return true;
1788         }
1789         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1790             IERC721Receiver(to).onERC721Received.selector,
1791             _msgSender(),
1792             from,
1793             tokenId,
1794             _data
1795         ), "ERC721: transfer to non ERC721Receiver implementer");
1796         bytes4 retval = abi.decode(returndata, (bytes4));
1797         return (retval == _ERC721_RECEIVED);
1798     }
1799 
1800     /**
1801      * @dev Approve `to` to operate on `tokenId`
1802      *
1803      * Emits an {Approval} event.
1804      */
1805     function _approve(address to, uint256 tokenId) internal virtual {
1806         _tokenApprovals[tokenId] = to;
1807         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1808     }
1809 
1810     /**
1811      * @dev Hook that is called before any token transfer. This includes minting
1812      * and burning.
1813      *
1814      * Calling conditions:
1815      *
1816      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1817      * transferred to `to`.
1818      * - When `from` is zero, `tokenId` will be minted for `to`.
1819      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1820      * - `from` cannot be the zero address.
1821      * - `to` cannot be the zero address.
1822      *
1823      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1824      */
1825     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1826 }
1827 
1828 // File: @openzeppelin/contracts/access/Ownable.sol
1829 
1830 
1831 
1832 pragma solidity >=0.6.0 <0.8.0;
1833 
1834 /**
1835  * @dev Contract module which provides a basic access control mechanism, where
1836  * there is an account (an owner) that can be granted exclusive access to
1837  * specific functions.
1838  *
1839  * By default, the owner account will be the one that deploys the contract. This
1840  * can later be changed with {transferOwnership}.
1841  *
1842  * This module is used through inheritance. It will make available the modifier
1843  * `onlyOwner`, which can be applied to your functions to restrict their use to
1844  * the owner.
1845  */
1846 abstract contract Ownable is Context {
1847     address private _owner;
1848 
1849     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1850 
1851     /**
1852      * @dev Initializes the contract setting the deployer as the initial owner.
1853      */
1854     constructor () internal {
1855         address msgSender = _msgSender();
1856         _owner = msgSender;
1857         emit OwnershipTransferred(address(0), msgSender);
1858     }
1859 
1860     /**
1861      * @dev Returns the address of the current owner.
1862      */
1863     function owner() public view virtual returns (address) {
1864         return _owner;
1865     }
1866 
1867     /**
1868      * @dev Throws if called by any account other than the owner.
1869      */
1870     modifier onlyOwner() {
1871         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1872         _;
1873     }
1874 
1875     /**
1876      * @dev Leaves the contract without owner. It will not be possible to call
1877      * `onlyOwner` functions anymore. Can only be called by the current owner.
1878      *
1879      * NOTE: Renouncing ownership will leave the contract without an owner,
1880      * thereby removing any functionality that is only available to the owner.
1881      */
1882     function renounceOwnership() public virtual onlyOwner {
1883         emit OwnershipTransferred(_owner, address(0));
1884         _owner = address(0);
1885     }
1886 
1887     /**
1888      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1889      * Can only be called by the current owner.
1890      */
1891     function transferOwnership(address newOwner) public virtual onlyOwner {
1892         require(newOwner != address(0), "Ownable: new owner is the zero address");
1893         emit OwnershipTransferred(_owner, newOwner);
1894         _owner = newOwner;
1895     }
1896 }
1897 
1898 // File: contracts/BoredApeYachtClub.sol
1899 
1900 
1901 pragma solidity ^0.7.0;
1902 
1903 
1904 
1905 /**
1906  * @title WTFoxes contract
1907  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1908  */
1909 contract WTFoxes is ERC721, Ownable {
1910     using SafeMath for uint256;
1911     using Strings for uint256;
1912 
1913     uint256 public constant wtfoxesPrice = 44000000000000000; //0.044 ETH
1914 
1915     uint public constant maxWtfoxesPurchase = 10;
1916 
1917     uint256 public MAX_WTFOXES;
1918 
1919     bool public saleIsActive = false;
1920 
1921     constructor(string memory name, string memory symbol, uint256 maxNftSupply) ERC721(name, symbol) {
1922         MAX_WTFOXES = maxNftSupply;
1923     }
1924 
1925     function withdraw() public onlyOwner {
1926         uint balance = address(this).balance;
1927         msg.sender.transfer(balance);
1928     }
1929 
1930     function reserveWTFoxes() public onlyOwner {        
1931         uint supply = totalSupply();
1932         uint i;
1933         for (i = 0; i < 40; i++) {
1934             _safeMint(msg.sender, supply + i);
1935         }
1936     }
1937 
1938     function setBaseURI(string memory baseURI) public onlyOwner {
1939         _setBaseURI(baseURI);
1940     }
1941 
1942     /*
1943     * Pause sale if active, make active if paused
1944     */
1945     function flipSaleState() public onlyOwner {
1946         saleIsActive = !saleIsActive;
1947     }
1948 
1949     function mintWTFoxes(uint numberOfTokens) public payable {
1950         require(saleIsActive, "Sale must be active to mint WTFoxes");
1951         require(numberOfTokens <= maxWtfoxesPurchase, "Can only mint 10 tokens at a time");
1952         require(totalSupply().add(numberOfTokens) <= MAX_WTFOXES, "Purchase would exceed max supply of WTFoxes");
1953         require(wtfoxesPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1954         
1955         for(uint i = 0; i < numberOfTokens; i++) {
1956             uint mintIndex = totalSupply();
1957             if (totalSupply() < MAX_WTFOXES) {
1958                 _safeMint(msg.sender, mintIndex);
1959             }
1960         }
1961     }
1962 
1963     /**
1964      * @dev See {IERC721Metadata-tokenURI}.
1965      */
1966     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1967         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1968 
1969         string memory base = baseURI();
1970         return string(abi.encodePacked(base, tokenId.toString()));
1971     }
1972 }