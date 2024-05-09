1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // GO TO LINE 1904 TO SEE WHERE THE PIG CONTRACT STARTS
8  
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 pragma solidity >=0.6.0 <0.8.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 
35 
36 
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Interface of the ERC165 standard, as defined in the
42  * https://eips.ethereum.org/EIPS/eip-165[EIP].
43  *
44  * Implementers can declare support of contract interfaces, which can then be
45 
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
62 
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
1354 /**
1355  * @title ERC721 Non-Fungible Token Standard basic implementation
1356  * @dev see https://eips.ethereum.org/EIPS/eip-721
1357  */
1358  
1359 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1360     using SafeMath for uint256;
1361     using Address for address;
1362     using EnumerableSet for EnumerableSet.UintSet;
1363     using EnumerableMap for EnumerableMap.UintToAddressMap;
1364     using Strings for uint256;
1365 
1366     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1367     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1368     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1369 
1370     // Mapping from holder address to their (enumerable) set of owned tokens
1371     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1372 
1373     // Enumerable mapping from token ids to their owners
1374     EnumerableMap.UintToAddressMap private _tokenOwners;
1375 
1376     // Mapping from token ID to approved address
1377     mapping (uint256 => address) private _tokenApprovals;
1378 
1379     // Mapping from owner to operator approvals
1380     mapping (address => mapping (address => bool)) private _operatorApprovals;
1381 
1382     // Token name
1383     string private _name;
1384 
1385     // Token symbol
1386     string private _symbol;
1387 
1388     // Optional mapping for token URIs
1389     mapping (uint256 => string) private _tokenURIs;
1390 
1391     // Base URI
1392     string private _baseURI;
1393 
1394     /*
1395      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1396      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1397      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1398      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1399      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1400      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1401      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1402      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1403      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1404      *
1405      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1406      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1407      */
1408     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1409 
1410     /*
1411      *     bytes4(keccak256('name()')) == 0x06fdde03
1412      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1413      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1414      *
1415      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1416      */
1417     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1418 
1419     /*
1420      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1421      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1422      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1423      *
1424      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1425      */
1426     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1427 
1428     /**
1429      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1430      */
1431     constructor (string memory name_, string memory symbol_) public {
1432         _name = name_;
1433         _symbol = symbol_;
1434 
1435         // register the supported interfaces to conform to ERC721 via ERC165
1436         _registerInterface(_INTERFACE_ID_ERC721);
1437         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1438         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-balanceOf}.
1443      */
1444     function balanceOf(address owner) public view virtual override returns (uint256) {
1445         require(owner != address(0), "ERC721: balance query for the zero address");
1446         return _holderTokens[owner].length();
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-ownerOf}.
1451      */
1452     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1453         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1454     }
1455 
1456     /**
1457      * @dev See {IERC721Metadata-name}.
1458      */
1459     function name() public view virtual override returns (string memory) {
1460         return _name;
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Metadata-symbol}.
1465      */
1466     function symbol() public view virtual override returns (string memory) {
1467         return _symbol;
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Metadata-tokenURI}.
1472      */
1473     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1474         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1475 
1476         string memory _tokenURI = _tokenURIs[tokenId];
1477         string memory base = baseURI();
1478 
1479         // If there is no base URI, return the token URI.
1480         if (bytes(base).length == 0) {
1481             return _tokenURI;
1482         }
1483         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1484         if (bytes(_tokenURI).length > 0) {
1485             return string(abi.encodePacked(base, _tokenURI));
1486         }
1487         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1488         return string(abi.encodePacked(base, tokenId.toString()));
1489     }
1490 
1491     /**
1492     * @dev Returns the base URI set via {_setBaseURI}. This will be
1493     * automatically added as a prefix in {tokenURI} to each token's URI, or
1494     * to the token ID if no specific URI is set for that token ID.
1495     */
1496     function baseURI() public view virtual returns (string memory) {
1497         return _baseURI;
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1502      */
1503     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1504         return _holderTokens[owner].at(index);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-totalSupply}.
1509      */
1510     function totalSupply() public view virtual override returns (uint256) {
1511         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1512         return _tokenOwners.length();
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-tokenByIndex}.
1517      */
1518     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1519         (uint256 tokenId, ) = _tokenOwners.at(index);
1520         return tokenId;
1521     }
1522 
1523     /**
1524      * @dev See {IERC721-approve}.
1525      */
1526     function approve(address to, uint256 tokenId) public virtual override {
1527         address owner = ERC721.ownerOf(tokenId);
1528         require(to != owner, "ERC721: approval to current owner");
1529 
1530         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1531             "ERC721: approve caller is not owner nor approved for all"
1532         );
1533 
1534         _approve(to, tokenId);
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-getApproved}.
1539      */
1540     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1541         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1542 
1543         return _tokenApprovals[tokenId];
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-setApprovalForAll}.
1548      */
1549     function setApprovalForAll(address operator, bool approved) public virtual override {
1550         require(operator != _msgSender(), "ERC721: approve to caller");
1551 
1552         _operatorApprovals[_msgSender()][operator] = approved;
1553         emit ApprovalForAll(_msgSender(), operator, approved);
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-isApprovedForAll}.
1558      */
1559     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1560         return _operatorApprovals[owner][operator];
1561     }
1562 
1563     /**
1564      * @dev See {IERC721-transferFrom}.
1565      */
1566     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1567         //solhint-disable-next-line max-line-length
1568         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1569 
1570         _transfer(from, to, tokenId);
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-safeTransferFrom}.
1575      */
1576     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1577         safeTransferFrom(from, to, tokenId, "");
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-safeTransferFrom}.
1582      */
1583     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1584         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1585         _safeTransfer(from, to, tokenId, _data);
1586     }
1587 
1588     /**
1589      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1590      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1591      *
1592      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1593      *
1594      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1595      * implement alternative mechanisms to perform token transfer, such as signature-based.
1596      *
1597      * Requirements:
1598      *
1599      * - `from` cannot be the zero address.
1600      * - `to` cannot be the zero address.
1601      * - `tokenId` token must exist and be owned by `from`.
1602      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1603      *
1604      * Emits a {Transfer} event.
1605      */
1606     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1607         _transfer(from, to, tokenId);
1608         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1609     }
1610 
1611     /**
1612      * @dev Returns whether `tokenId` exists.
1613      *
1614      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1615      *
1616      * Tokens start existing when they are minted (`_mint`),
1617      * and stop existing when they are burned (`_burn`).
1618      */
1619     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1620         return _tokenOwners.contains(tokenId);
1621     }
1622 
1623     /**
1624      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must exist.
1629      */
1630     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1631         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1632         address owner = ERC721.ownerOf(tokenId);
1633         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1634     }
1635 
1636     /**
1637      * @dev Safely mints `tokenId` and transfers it to `to`.
1638      *
1639      * Requirements:
1640      d*
1641      * - `tokenId` must not exist.
1642      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1643      *
1644      * Emits a {Transfer} event.
1645      */
1646     function _safeMint(address to, uint256 tokenId) internal virtual {
1647         _safeMint(to, tokenId, "");
1648     }
1649 
1650     /**
1651      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1652      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1653      */
1654     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1655         _mint(to, tokenId);
1656         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1657     }
1658 
1659     /**
1660      * @dev Mints `tokenId` and transfers it to `to`.
1661      *
1662      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1663      *
1664      * Requirements:
1665      *
1666      * - `tokenId` must not exist.
1667      * - `to` cannot be the zero address.
1668      *
1669      * Emits a {Transfer} event.
1670      */
1671     function _mint(address to, uint256 tokenId) internal virtual {
1672         require(to != address(0), "ERC721: mint to the zero address");
1673         require(!_exists(tokenId), "ERC721: token already minted");
1674 
1675         _beforeTokenTransfer(address(0), to, tokenId);
1676 
1677         _holderTokens[to].add(tokenId);
1678 
1679         _tokenOwners.set(tokenId, to);
1680 
1681         emit Transfer(address(0), to, tokenId);
1682     }
1683 
1684     /**
1685      * @dev Destroys `tokenId`.
1686      * The approval is cleared when the token is burned.
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must exist.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function _burn(uint256 tokenId) internal virtual {
1695         address owner = ERC721.ownerOf(tokenId); // internal owner
1696 
1697         _beforeTokenTransfer(owner, address(0), tokenId);
1698 
1699         // Clear approvals
1700         _approve(address(0), tokenId);
1701 
1702         // Clear metadata (if any)
1703         if (bytes(_tokenURIs[tokenId]).length != 0) {
1704             delete _tokenURIs[tokenId];
1705         }
1706 
1707         _holderTokens[owner].remove(tokenId);
1708 
1709         _tokenOwners.remove(tokenId);
1710 
1711         emit Transfer(owner, address(0), tokenId);
1712     }
1713 
1714     /**
1715      * @dev Transfers `tokenId` from `from` to `to`.
1716      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1717      *
1718      * Requirements:
1719      *
1720      * - `to` cannot be the zero address.
1721      * - `tokenId` token must be owned by `from`.
1722      *
1723      * Emits a {Transfer} event.
1724      */
1725     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1726         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1727         require(to != address(0), "ERC721: transfer to the zero address");
1728 
1729         _beforeTokenTransfer(from, to, tokenId);
1730 
1731         // Clear approvals from the previous owner
1732         _approve(address(0), tokenId);
1733 
1734         _holderTokens[from].remove(tokenId);
1735         _holderTokens[to].add(tokenId);
1736 
1737         _tokenOwners.set(tokenId, to);
1738 
1739         emit Transfer(from, to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1744      *
1745      * Requirements:
1746      *
1747      * - `tokenId` must exist.
1748      */
1749     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1750         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1751         _tokenURIs[tokenId] = _tokenURI;
1752     }
1753 
1754     /**
1755      * @dev Internal function to set the base URI for all token IDs. It is
1756      * automatically added as a prefix to the value returned in {tokenURI},
1757      * or to the token ID if {tokenURI} is empty.
1758      */
1759     function _setBaseURI(string memory baseURI_) internal virtual {
1760         _baseURI = baseURI_;
1761     }
1762 
1763     /**
1764      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1765      * The call is not executed if the target address is not a contract.
1766      *
1767      * @param from address representing the previous owner of the given token ID
1768      * @param to target address that will receive the tokens
1769      * @param tokenId uint256 ID of the token to be transferred
1770      * @param _data bytes optional data to send along with the call
1771      * @return bool whether the call correctly returned the expected magic value
1772      */
1773     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1774         private returns (bool)
1775     {
1776         if (!to.isContract()) {
1777             return true;
1778         }
1779         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1780             IERC721Receiver(to).onERC721Received.selector,
1781             _msgSender(),
1782             from,
1783             tokenId,
1784             _data
1785         ), "ERC721: transfer to non ERC721Receiver implementer");
1786         bytes4 retval = abi.decode(returndata, (bytes4));
1787         return (retval == _ERC721_RECEIVED);
1788     }
1789 
1790     /**
1791      * @dev Approve `to` to operate on `tokenId`
1792      *
1793      * Emits an {Approval} event.
1794      */
1795     function _approve(address to, uint256 tokenId) internal virtual {
1796         _tokenApprovals[tokenId] = to;
1797         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1798     }
1799 
1800     /**
1801      * @dev Hook that is called before any token transfer. This includes minting
1802      * and burning.
1803      *
1804      * Calling conditions:
1805      *
1806      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1807      * transferred to `to`.
1808      * - When `from` is zero, `tokenId` will be minted for `to`.
1809      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1810      * - `from` cannot be the zero address.
1811      * - `to` cannot be the zero address.
1812      *
1813      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1814      */
1815     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1816 }
1817 
1818 // File: @openzeppelin/contracts/access/Ownable.sol
1819 
1820 
1821 
1822 pragma solidity >=0.6.0 <0.8.0;
1823 
1824 /**
1825  * @dev Contract module which provides a basic access control mechanism, where
1826  * there is an account (an owner) that can be granted exclusive access to
1827  * specific functions.
1828  *
1829  * By default, the owner account will be the one that deploys the contract. This
1830  * can later be changed with {transferOwnership}.
1831  *
1832  * This module is used through inheritance. It will make available the modifier
1833  * `onlyOwner`, which can be applied to your functions to restrict their use to
1834  * the owner.
1835  */
1836 abstract contract Ownable is Context {
1837     address private _owner;
1838 
1839     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1840 
1841     /**
1842      * @dev Initializes the contract setting the deployer as the initial owner.
1843      */
1844     constructor () internal {
1845         address msgSender = _msgSender();
1846         _owner = msgSender;
1847         emit OwnershipTransferred(address(0), msgSender);
1848     }
1849 
1850     /**
1851      * @dev Returns the address of the current owner.
1852      */
1853     function owner() public view virtual returns (address) {
1854         return _owner;
1855     }
1856 
1857     /**
1858      * @dev Throws if called by any account other than the owner.
1859      */
1860     modifier onlyOwner() {
1861         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1862         _;
1863     }
1864 
1865     /**
1866      * @dev Leaves the contract without owner. It will not be possible to call
1867      * `onlyOwner` functions anymore. Can only be called by the current owner.
1868      *
1869      * NOTE: Renouncing ownership will leave the contract without an owner,
1870      * thereby removing any functionality that is only available to the owner.
1871      */
1872     function renounceOwnership() public virtual onlyOwner {
1873         emit OwnershipTransferred(_owner, address(0));
1874         _owner = address(0);
1875     }
1876 
1877     /**
1878      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1879      * Can only be called by the current owner.
1880      */
1881     function transferOwnership(address newOwner) public virtual onlyOwner {
1882         require(newOwner != address(0), "Ownable: new owner is the zero address");
1883         emit OwnershipTransferred(_owner, newOwner);
1884         _owner = newOwner;
1885     }
1886 }
1887 
1888 
1889 // CPC
1890 
1891 
1892 
1893 pragma solidity ^0.7.0;
1894 pragma abicoder v2;
1895 
1896 contract CutePigClub is ERC721, Ownable {
1897     
1898     using SafeMath for uint256;
1899 
1900     string public PIG_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN PIGS ARE ALL SOLD OUT
1901     
1902     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1903     
1904     bool licenseLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1905 
1906     uint256 public constant pigPrice = 30000000000000000; // 0.03 ETH
1907     
1908     uint public constant maxPigPurchase = 10000;
1909 
1910     uint256 public constant MAX_PIGS = 10000;
1911 
1912     bool public saleIsActive = false;
1913     
1914     mapping(uint => string) public pigNames;
1915     
1916     // Reserve 200 for team - Giveaways/Prizes etc
1917     uint public pigReserve = 200;
1918     
1919     event pigNameChange(address _by, uint _tokenId, string _name);
1920     
1921     event licenseisLocked(string _licenseText);
1922 
1923     constructor() ERC721("Cute Pig Club", "CPC") { }
1924     
1925     function withdraw() public onlyOwner {
1926         uint balance = address(this).balance;
1927         msg.sender.transfer(balance);
1928     }
1929     
1930     function reservePigs(address _to, uint256 _reserveAmount) public onlyOwner {        
1931         uint supply = totalSupply();
1932         require(_reserveAmount > 0 && _reserveAmount <= pigReserve, "Not enough reserve left for team");
1933         for (uint i = 0; i < _reserveAmount; i++) {
1934             _safeMint(_to, supply + i);
1935         }
1936         pigReserve = pigReserve.sub(_reserveAmount);
1937     }
1938 
1939 
1940     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1941         PIG_PROVENANCE = provenanceHash;
1942     }
1943 
1944     function setBaseURI(string memory baseURI) public onlyOwner {
1945         _setBaseURI(baseURI);
1946     }
1947 
1948 
1949     function flipSaleState() public onlyOwner {
1950         saleIsActive = !saleIsActive;
1951     }
1952     
1953     
1954     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1955         uint256 tokenCount = balanceOf(_owner);
1956         if (tokenCount == 0) {
1957             // Return an empty array
1958             return new uint256[](0);
1959         } else {
1960             uint256[] memory result = new uint256[](tokenCount);
1961             uint256 index;
1962             for (index = 0; index < tokenCount; index++) {
1963                 result[index] = tokenOfOwnerByIndex(_owner, index);
1964             }
1965             return result;
1966         }
1967     }
1968     
1969     // Returns the license for tokens
1970     function tokenLicense(uint _id) public view returns(string memory) {
1971         require(_id < totalSupply(), "CHOOSE A PIG WITHIN RANGE");
1972         return LICENSE_TEXT;
1973     }
1974     
1975     // Locks the license to prevent further changes 
1976     function lockLicense() public onlyOwner {
1977         licenseLocked =  true;
1978         emit licenseisLocked(LICENSE_TEXT);
1979     }
1980     
1981     // Change the license
1982     function changeLicense(string memory _license) public onlyOwner {
1983         require(licenseLocked == false, "License already locked");
1984         LICENSE_TEXT = _license;
1985     }
1986     
1987     
1988     function mintCutepigclub(uint numberOfTokens) public payable {
1989         require(saleIsActive, "Sale must be active to mint Pig");
1990         require(numberOfTokens > 0 && numberOfTokens <= maxPigPurchase, "Can only mint 258 tokens at a time");
1991         require(totalSupply().add(numberOfTokens) <= MAX_PIGS, "Purchase would exceed max supply of pigs");
1992         require(msg.value >= pigPrice.mul(numberOfTokens), "Ether value sent is not correct");
1993         
1994         for(uint i = 0; i < numberOfTokens; i++) {
1995             uint mintIndex = totalSupply();
1996             if (totalSupply() < MAX_PIGS) {
1997                 _safeMint(msg.sender, mintIndex);
1998             }
1999         }
2000 
2001     }
2002      
2003     function changePigName(uint _tokenId, string memory _name) public {
2004         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this pig!");
2005         require(sha256(bytes(_name)) != sha256(bytes(pigNames[_tokenId])), "New name is same as the current one");
2006         pigNames[_tokenId] = _name;
2007         
2008         emit pigNameChange(msg.sender, _tokenId, _name);
2009         
2010     }
2011     
2012     function viewPigName(uint _tokenId) public view returns( string memory ){
2013         require( _tokenId < totalSupply(), "Choose a pig within range" );
2014         return pigNames[_tokenId];
2015     }
2016     
2017     
2018     // GET ALL PIG OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2019     function pigNamesOfOwner(address _owner) external view returns(string[] memory ) {
2020         uint256 tokenCount = balanceOf(_owner);
2021         if (tokenCount == 0) {
2022             // Return an empty array
2023             return new string[](0);
2024         } else {
2025             string[] memory result = new string[](tokenCount);
2026             uint256 index;
2027             for (index = 0; index < tokenCount; index++) {
2028                 result[index] = pigNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2029             }
2030             return result;
2031         }
2032     }
2033     
2034 }