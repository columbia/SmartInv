1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC165 standard, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-165[EIP].
36  *
37  * Implementers can declare support of contract interfaces, which can then be
38  * queried by others ({ERC165Checker}).
39  *
40  * For an implementation, see {ERC165}.
41  */
42 interface IERC165 {
43     /**
44      * @dev Returns true if this contract implements the interface defined by
45      * `interfaceId`. See the corresponding
46      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
47      * to learn more about how these ids are created.
48      *
49      * This function call must use less than 30 000 gas.
50      */
51     function supportsInterface(bytes4 interfaceId) external view returns (bool);
52 }
53 
54 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
55 
56 
57 pragma solidity >=0.6.2 <0.8.0;
58 
59 
60 /**
61  * @dev Required interface of an ERC721 compliant contract.
62  */
63 interface IERC721 is IERC165 {
64     /**
65      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
76      */
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78 
79     /**
80      * @dev Returns the number of tokens in ``owner``'s account.
81      */
82     function balanceOf(address owner) external view returns (uint256 balance);
83 
84     /**
85      * @dev Returns the owner of the `tokenId` token.
86      *
87      * Requirements:
88      *
89      * - `tokenId` must exist.
90      */
91     function ownerOf(uint256 tokenId) external view returns (address owner);
92 
93     /**
94      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
95      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
96      *
97      * Requirements:
98      *
99      * - `from` cannot be the zero address.
100      * - `to` cannot be the zero address.
101      * - `tokenId` token must exist and be owned by `from`.
102      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
104      *
105      * Emits a {Transfer} event.
106      */
107     function safeTransferFrom(address from, address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Transfers `tokenId` token from `from` to `to`.
111      *
112      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must be owned by `from`.
119      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(address from, address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId) external view returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 
168     /**
169       * @dev Safely transfers `tokenId` token from `from` to `to`.
170       *
171       * Requirements:
172       *
173       * - `from` cannot be the zero address.
174       * - `to` cannot be the zero address.
175       * - `tokenId` token must exist and be owned by `from`.
176       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
177       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178       *
179       * Emits a {Transfer} event.
180       */
181     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
182 }
183 
184 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
185 
186 
187 pragma solidity >=0.6.2 <0.8.0;
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195 
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
213 
214 
215 pragma solidity >=0.6.2 <0.8.0;
216 
217 
218 /**
219  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
220  * @dev See https://eips.ethereum.org/EIPS/eip-721
221  */
222 interface IERC721Enumerable is IERC721 {
223 
224     /**
225      * @dev Returns the total amount of tokens stored by the contract.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
231      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
232      */
233     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
234 
235     /**
236      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
237      * Use along with {totalSupply} to enumerate all tokens.
238      */
239     function tokenByIndex(uint256 index) external view returns (uint256);
240 }
241 
242 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
243 
244 
245 pragma solidity >=0.6.0 <0.8.0;
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 interface IERC721Receiver {
253     /**
254      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
255      * by `operator` from `from`, this function is called.
256      *
257      * It must return its Solidity selector to confirm the token transfer.
258      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
259      *
260      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
261      */
262     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
263 }
264 
265 // File: @openzeppelin/contracts/introspection/ERC165.sol
266 
267 
268 pragma solidity >=0.6.0 <0.8.0;
269 
270 
271 /**
272  * @dev Implementation of the {IERC165} interface.
273  *
274  * Contracts may inherit from this and call {_registerInterface} to declare
275  * their support of an interface.
276  */
277 abstract contract ERC165 is IERC165 {
278     /*
279      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
280      */
281     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
282 
283     /**
284      * @dev Mapping of interface ids to whether or not it's supported.
285      */
286     mapping(bytes4 => bool) private _supportedInterfaces;
287 
288     constructor () internal {
289         // Derived contracts need only register support for their own interfaces,
290         // we register support for ERC165 itself here
291         _registerInterface(_INTERFACE_ID_ERC165);
292     }
293 
294     /**
295      * @dev See {IERC165-supportsInterface}.
296      *
297      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300         return _supportedInterfaces[interfaceId];
301     }
302 
303     /**
304      * @dev Registers the contract as an implementer of the interface defined by
305      * `interfaceId`. Support of the actual ERC165 interface is automatic and
306      * registering its interface id is not required.
307      *
308      * See {IERC165-supportsInterface}.
309      *
310      * Requirements:
311      *
312      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
313      */
314     function _registerInterface(bytes4 interfaceId) internal virtual {
315         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
316         _supportedInterfaces[interfaceId] = true;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/math/SafeMath.sol
321 
322 
323 pragma solidity >=0.6.0 <0.8.0;
324 
325 /**
326  * @dev Wrappers over Solidity's arithmetic operations with added overflow
327  * checks.
328  *
329  * Arithmetic operations in Solidity wrap on overflow. This can easily result
330  * in bugs, because programmers usually assume that an overflow raises an
331  * error, which is the standard behavior in high level programming languages.
332  * `SafeMath` restores this intuition by reverting the transaction when an
333  * operation overflows.
334  *
335  * Using this library instead of the unchecked operations eliminates an entire
336  * class of bugs, so it's recommended to use it always.
337  */
338 library SafeMath {
339     /**
340      * @dev Returns the addition of two unsigned integers, with an overflow flag.
341      *
342      * _Available since v3.4._
343      */
344     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
345         uint256 c = a + b;
346         if (c < a) return (false, 0);
347         return (true, c);
348     }
349 
350     /**
351      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
352      *
353      * _Available since v3.4._
354      */
355     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         if (b > a) return (false, 0);
357         return (true, a - b);
358     }
359 
360     /**
361      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
362      *
363      * _Available since v3.4._
364      */
365     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
367         // benefit is lost if 'b' is also tested.
368         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
369         if (a == 0) return (true, 0);
370         uint256 c = a * b;
371         if (c / a != b) return (false, 0);
372         return (true, c);
373     }
374 
375     /**
376      * @dev Returns the division of two unsigned integers, with a division by zero flag.
377      *
378      * _Available since v3.4._
379      */
380     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         if (b == 0) return (false, 0);
382         return (true, a / b);
383     }
384 
385     /**
386      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
387      *
388      * _Available since v3.4._
389      */
390     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
391         if (b == 0) return (false, 0);
392         return (true, a % b);
393     }
394 
395     /**
396      * @dev Returns the addition of two unsigned integers, reverting on
397      * overflow.
398      *
399      * Counterpart to Solidity's `+` operator.
400      *
401      * Requirements:
402      *
403      * - Addition cannot overflow.
404      */
405     function add(uint256 a, uint256 b) internal pure returns (uint256) {
406         uint256 c = a + b;
407         require(c >= a, "SafeMath: addition overflow");
408         return c;
409     }
410 
411     /**
412      * @dev Returns the subtraction of two unsigned integers, reverting on
413      * overflow (when the result is negative).
414      *
415      * Counterpart to Solidity's `-` operator.
416      *
417      * Requirements:
418      *
419      * - Subtraction cannot overflow.
420      */
421     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422         require(b <= a, "SafeMath: subtraction overflow");
423         return a - b;
424     }
425 
426     /**
427      * @dev Returns the multiplication of two unsigned integers, reverting on
428      * overflow.
429      *
430      * Counterpart to Solidity's `*` operator.
431      *
432      * Requirements:
433      *
434      * - Multiplication cannot overflow.
435      */
436     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
437         if (a == 0) return 0;
438         uint256 c = a * b;
439         require(c / a == b, "SafeMath: multiplication overflow");
440         return c;
441     }
442 
443     /**
444      * @dev Returns the integer division of two unsigned integers, reverting on
445      * division by zero. The result is rounded towards zero.
446      *
447      * Counterpart to Solidity's `/` operator. Note: this function uses a
448      * `revert` opcode (which leaves remaining gas untouched) while Solidity
449      * uses an invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function div(uint256 a, uint256 b) internal pure returns (uint256) {
456         require(b > 0, "SafeMath: division by zero");
457         return a / b;
458     }
459 
460     /**
461      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
462      * reverting when dividing by zero.
463      *
464      * Counterpart to Solidity's `%` operator. This function uses a `revert`
465      * opcode (which leaves remaining gas untouched) while Solidity uses an
466      * invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b > 0, "SafeMath: modulo by zero");
474         return a % b;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
479      * overflow (when the result is negative).
480      *
481      * CAUTION: This function is deprecated because it requires allocating memory for the error
482      * message unnecessarily. For custom revert reasons use {trySub}.
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
491         require(b <= a, errorMessage);
492         return a - b;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
497      * division by zero. The result is rounded towards zero.
498      *
499      * CAUTION: This function is deprecated because it requires allocating memory for the error
500      * message unnecessarily. For custom revert reasons use {tryDiv}.
501      *
502      * Counterpart to Solidity's `/` operator. Note: this function uses a
503      * `revert` opcode (which leaves remaining gas untouched) while Solidity
504      * uses an invalid opcode to revert (consuming all remaining gas).
505      *
506      * Requirements:
507      *
508      * - The divisor cannot be zero.
509      */
510     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b > 0, errorMessage);
512         return a / b;
513     }
514 
515     /**
516      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
517      * reverting with custom message when dividing by zero.
518      *
519      * CAUTION: This function is deprecated because it requires allocating memory for the error
520      * message unnecessarily. For custom revert reasons use {tryMod}.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
531         require(b > 0, errorMessage);
532         return a % b;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/Address.sol
537 
538 
539 pragma solidity >=0.6.2 <0.8.0;
540 
541 /**
542  * @dev Collection of functions related to the address type
543  */
544 library Address {
545     /**
546      * @dev Returns true if `account` is a contract.
547      *
548      * [IMPORTANT]
549      * ====
550      * It is unsafe to assume that an address for which this function returns
551      * false is an externally-owned account (EOA) and not a contract.
552      *
553      * Among others, `isContract` will return false for the following
554      * types of addresses:
555      *
556      *  - an externally-owned account
557      *  - a contract in construction
558      *  - an address where a contract will be created
559      *  - an address where a contract lived, but was destroyed
560      * ====
561      */
562     function isContract(address account) internal view returns (bool) {
563         // This method relies on extcodesize, which returns 0 for contracts in
564         // construction, since the code is only stored at the end of the
565         // constructor execution.
566 
567         uint256 size;
568         // solhint-disable-next-line no-inline-assembly
569         assembly { size := extcodesize(account) }
570         return size > 0;
571     }
572 
573     /**
574      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
575      * `recipient`, forwarding all available gas and reverting on errors.
576      *
577      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
578      * of certain opcodes, possibly making contracts go over the 2300 gas limit
579      * imposed by `transfer`, making them unable to receive funds via
580      * `transfer`. {sendValue} removes this limitation.
581      *
582      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
583      *
584      * IMPORTANT: because control is transferred to `recipient`, care must be
585      * taken to not create reentrancy vulnerabilities. Consider using
586      * {ReentrancyGuard} or the
587      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
588      */
589     function sendValue(address payable recipient, uint256 amount) internal {
590         require(address(this).balance >= amount, "Address: insufficient balance");
591 
592         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
593         (bool success, ) = recipient.call{ value: amount }("");
594         require(success, "Address: unable to send value, recipient may have reverted");
595     }
596 
597     /**
598      * @dev Performs a Solidity function call using a low level `call`. A
599      * plain`call` is an unsafe replacement for a function call: use this
600      * function instead.
601      *
602      * If `target` reverts with a revert reason, it is bubbled up by this
603      * function (like regular Solidity function calls).
604      *
605      * Returns the raw returned data. To convert to the expected return value,
606      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
607      *
608      * Requirements:
609      *
610      * - `target` must be a contract.
611      * - calling `target` with `data` must not revert.
612      *
613      * _Available since v3.1._
614      */
615     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
616       return functionCall(target, data, "Address: low-level call failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
621      * `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
626         return functionCallWithValue(target, data, 0, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but also transferring `value` wei to `target`.
632      *
633      * Requirements:
634      *
635      * - the calling contract must have an ETH balance of at least `value`.
636      * - the called Solidity function must be `payable`.
637      *
638      * _Available since v3.1._
639      */
640     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
641         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
642     }
643 
644     /**
645      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
646      * with `errorMessage` as a fallback revert reason when `target` reverts.
647      *
648      * _Available since v3.1._
649      */
650     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
651         require(address(this).balance >= value, "Address: insufficient balance for call");
652         require(isContract(target), "Address: call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.call{ value: value }(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
661      * but performing a static call.
662      *
663      * _Available since v3.3._
664      */
665     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
666         return functionStaticCall(target, data, "Address: low-level static call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a static call.
672      *
673      * _Available since v3.3._
674      */
675     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
676         require(isContract(target), "Address: static call to non-contract");
677 
678         // solhint-disable-next-line avoid-low-level-calls
679         (bool success, bytes memory returndata) = target.staticcall(data);
680         return _verifyCallResult(success, returndata, errorMessage);
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
690         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
695      * but performing a delegate call.
696      *
697      * _Available since v3.4._
698      */
699     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
700         require(isContract(target), "Address: delegate call to non-contract");
701 
702         // solhint-disable-next-line avoid-low-level-calls
703         (bool success, bytes memory returndata) = target.delegatecall(data);
704         return _verifyCallResult(success, returndata, errorMessage);
705     }
706 
707     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
708         if (success) {
709             return returndata;
710         } else {
711             // Look for revert reason and bubble it up if present
712             if (returndata.length > 0) {
713                 // The easiest way to bubble the revert reason is using memory via assembly
714 
715                 // solhint-disable-next-line no-inline-assembly
716                 assembly {
717                     let returndata_size := mload(returndata)
718                     revert(add(32, returndata), returndata_size)
719                 }
720             } else {
721                 revert(errorMessage);
722             }
723         }
724     }
725 }
726 
727 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
728 
729 
730 pragma solidity >=0.6.0 <0.8.0;
731 
732 /**
733  * @dev Library for managing
734  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
735  * types.
736  *
737  * Sets have the following properties:
738  *
739  * - Elements are added, removed, and checked for existence in constant time
740  * (O(1)).
741  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
742  *
743  * ```
744  * contract Example {
745  *     // Add the library methods
746  *     using EnumerableSet for EnumerableSet.AddressSet;
747  *
748  *     // Declare a set state variable
749  *     EnumerableSet.AddressSet private mySet;
750  * }
751  * ```
752  *
753  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
754  * and `uint256` (`UintSet`) are supported.
755  */
756 library EnumerableSet {
757     // To implement this library for multiple types with as little code
758     // repetition as possible, we write it in terms of a generic Set type with
759     // bytes32 values.
760     // The Set implementation uses private functions, and user-facing
761     // implementations (such as AddressSet) are just wrappers around the
762     // underlying Set.
763     // This means that we can only create new EnumerableSets for types that fit
764     // in bytes32.
765 
766     struct Set {
767         // Storage of set values
768         bytes32[] _values;
769 
770         // Position of the value in the `values` array, plus 1 because index 0
771         // means a value is not in the set.
772         mapping (bytes32 => uint256) _indexes;
773     }
774 
775     /**
776      * @dev Add a value to a set. O(1).
777      *
778      * Returns true if the value was added to the set, that is if it was not
779      * already present.
780      */
781     function _add(Set storage set, bytes32 value) private returns (bool) {
782         if (!_contains(set, value)) {
783             set._values.push(value);
784             // The value is stored at length-1, but we add 1 to all indexes
785             // and use 0 as a sentinel value
786             set._indexes[value] = set._values.length;
787             return true;
788         } else {
789             return false;
790         }
791     }
792 
793     /**
794      * @dev Removes a value from a set. O(1).
795      *
796      * Returns true if the value was removed from the set, that is if it was
797      * present.
798      */
799     function _remove(Set storage set, bytes32 value) private returns (bool) {
800         // We read and store the value's index to prevent multiple reads from the same storage slot
801         uint256 valueIndex = set._indexes[value];
802 
803         if (valueIndex != 0) { // Equivalent to contains(set, value)
804             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
805             // the array, and then remove the last element (sometimes called as 'swap and pop').
806             // This modifies the order of the array, as noted in {at}.
807 
808             uint256 toDeleteIndex = valueIndex - 1;
809             uint256 lastIndex = set._values.length - 1;
810 
811             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
812             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
813 
814             bytes32 lastvalue = set._values[lastIndex];
815 
816             // Move the last value to the index where the value to delete is
817             set._values[toDeleteIndex] = lastvalue;
818             // Update the index for the moved value
819             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
820 
821             // Delete the slot where the moved value was stored
822             set._values.pop();
823 
824             // Delete the index for the deleted slot
825             delete set._indexes[value];
826 
827             return true;
828         } else {
829             return false;
830         }
831     }
832 
833     /**
834      * @dev Returns true if the value is in the set. O(1).
835      */
836     function _contains(Set storage set, bytes32 value) private view returns (bool) {
837         return set._indexes[value] != 0;
838     }
839 
840     /**
841      * @dev Returns the number of values on the set. O(1).
842      */
843     function _length(Set storage set) private view returns (uint256) {
844         return set._values.length;
845     }
846 
847    /**
848     * @dev Returns the value stored at position `index` in the set. O(1).
849     *
850     * Note that there are no guarantees on the ordering of values inside the
851     * array, and it may change when more values are added or removed.
852     *
853     * Requirements:
854     *
855     * - `index` must be strictly less than {length}.
856     */
857     function _at(Set storage set, uint256 index) private view returns (bytes32) {
858         require(set._values.length > index, "EnumerableSet: index out of bounds");
859         return set._values[index];
860     }
861 
862     // Bytes32Set
863 
864     struct Bytes32Set {
865         Set _inner;
866     }
867 
868     /**
869      * @dev Add a value to a set. O(1).
870      *
871      * Returns true if the value was added to the set, that is if it was not
872      * already present.
873      */
874     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
875         return _add(set._inner, value);
876     }
877 
878     /**
879      * @dev Removes a value from a set. O(1).
880      *
881      * Returns true if the value was removed from the set, that is if it was
882      * present.
883      */
884     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
885         return _remove(set._inner, value);
886     }
887 
888     /**
889      * @dev Returns true if the value is in the set. O(1).
890      */
891     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
892         return _contains(set._inner, value);
893     }
894 
895     /**
896      * @dev Returns the number of values in the set. O(1).
897      */
898     function length(Bytes32Set storage set) internal view returns (uint256) {
899         return _length(set._inner);
900     }
901 
902    /**
903     * @dev Returns the value stored at position `index` in the set. O(1).
904     *
905     * Note that there are no guarantees on the ordering of values inside the
906     * array, and it may change when more values are added or removed.
907     *
908     * Requirements:
909     *
910     * - `index` must be strictly less than {length}.
911     */
912     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
913         return _at(set._inner, index);
914     }
915 
916     // AddressSet
917 
918     struct AddressSet {
919         Set _inner;
920     }
921 
922     /**
923      * @dev Add a value to a set. O(1).
924      *
925      * Returns true if the value was added to the set, that is if it was not
926      * already present.
927      */
928     function add(AddressSet storage set, address value) internal returns (bool) {
929         return _add(set._inner, bytes32(uint256(uint160(value))));
930     }
931 
932     /**
933      * @dev Removes a value from a set. O(1).
934      *
935      * Returns true if the value was removed from the set, that is if it was
936      * present.
937      */
938     function remove(AddressSet storage set, address value) internal returns (bool) {
939         return _remove(set._inner, bytes32(uint256(uint160(value))));
940     }
941 
942     /**
943      * @dev Returns true if the value is in the set. O(1).
944      */
945     function contains(AddressSet storage set, address value) internal view returns (bool) {
946         return _contains(set._inner, bytes32(uint256(uint160(value))));
947     }
948 
949     /**
950      * @dev Returns the number of values in the set. O(1).
951      */
952     function length(AddressSet storage set) internal view returns (uint256) {
953         return _length(set._inner);
954     }
955 
956    /**
957     * @dev Returns the value stored at position `index` in the set. O(1).
958     *
959     * Note that there are no guarantees on the ordering of values inside the
960     * array, and it may change when more values are added or removed.
961     *
962     * Requirements:
963     *
964     * - `index` must be strictly less than {length}.
965     */
966     function at(AddressSet storage set, uint256 index) internal view returns (address) {
967         return address(uint160(uint256(_at(set._inner, index))));
968     }
969 
970 
971     // UintSet
972 
973     struct UintSet {
974         Set _inner;
975     }
976 
977     /**
978      * @dev Add a value to a set. O(1).
979      *
980      * Returns true if the value was added to the set, that is if it was not
981      * already present.
982      */
983     function add(UintSet storage set, uint256 value) internal returns (bool) {
984         return _add(set._inner, bytes32(value));
985     }
986 
987     /**
988      * @dev Removes a value from a set. O(1).
989      *
990      * Returns true if the value was removed from the set, that is if it was
991      * present.
992      */
993     function remove(UintSet storage set, uint256 value) internal returns (bool) {
994         return _remove(set._inner, bytes32(value));
995     }
996 
997     /**
998      * @dev Returns true if the value is in the set. O(1).
999      */
1000     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1001         return _contains(set._inner, bytes32(value));
1002     }
1003 
1004     /**
1005      * @dev Returns the number of values on the set. O(1).
1006      */
1007     function length(UintSet storage set) internal view returns (uint256) {
1008         return _length(set._inner);
1009     }
1010 
1011    /**
1012     * @dev Returns the value stored at position `index` in the set. O(1).
1013     *
1014     * Note that there are no guarantees on the ordering of values inside the
1015     * array, and it may change when more values are added or removed.
1016     *
1017     * Requirements:
1018     *
1019     * - `index` must be strictly less than {length}.
1020     */
1021     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1022         return uint256(_at(set._inner, index));
1023     }
1024 }
1025 
1026 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1027 
1028 
1029 pragma solidity >=0.6.0 <0.8.0;
1030 
1031 /**
1032  * @dev Library for managing an enumerable variant of Solidity's
1033  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1034  * type.
1035  *
1036  * Maps have the following properties:
1037  *
1038  * - Entries are added, removed, and checked for existence in constant time
1039  * (O(1)).
1040  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1041  *
1042  * ```
1043  * contract Example {
1044  *     // Add the library methods
1045  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1046  *
1047  *     // Declare a set state variable
1048  *     EnumerableMap.UintToAddressMap private myMap;
1049  * }
1050  * ```
1051  *
1052  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1053  * supported.
1054  */
1055 library EnumerableMap {
1056     // To implement this library for multiple types with as little code
1057     // repetition as possible, we write it in terms of a generic Map type with
1058     // bytes32 keys and values.
1059     // The Map implementation uses private functions, and user-facing
1060     // implementations (such as Uint256ToAddressMap) are just wrappers around
1061     // the underlying Map.
1062     // This means that we can only create new EnumerableMaps for types that fit
1063     // in bytes32.
1064 
1065     struct MapEntry {
1066         bytes32 _key;
1067         bytes32 _value;
1068     }
1069 
1070     struct Map {
1071         // Storage of map keys and values
1072         MapEntry[] _entries;
1073 
1074         // Position of the entry defined by a key in the `entries` array, plus 1
1075         // because index 0 means a key is not in the map.
1076         mapping (bytes32 => uint256) _indexes;
1077     }
1078 
1079     /**
1080      * @dev Adds a key-value pair to a map, or updates the value for an existing
1081      * key. O(1).
1082      *
1083      * Returns true if the key was added to the map, that is if it was not
1084      * already present.
1085      */
1086     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1087         // We read and store the key's index to prevent multiple reads from the same storage slot
1088         uint256 keyIndex = map._indexes[key];
1089 
1090         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1091             map._entries.push(MapEntry({ _key: key, _value: value }));
1092             // The entry is stored at length-1, but we add 1 to all indexes
1093             // and use 0 as a sentinel value
1094             map._indexes[key] = map._entries.length;
1095             return true;
1096         } else {
1097             map._entries[keyIndex - 1]._value = value;
1098             return false;
1099         }
1100     }
1101 
1102     /**
1103      * @dev Removes a key-value pair from a map. O(1).
1104      *
1105      * Returns true if the key was removed from the map, that is if it was present.
1106      */
1107     function _remove(Map storage map, bytes32 key) private returns (bool) {
1108         // We read and store the key's index to prevent multiple reads from the same storage slot
1109         uint256 keyIndex = map._indexes[key];
1110 
1111         if (keyIndex != 0) { // Equivalent to contains(map, key)
1112             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1113             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1114             // This modifies the order of the array, as noted in {at}.
1115 
1116             uint256 toDeleteIndex = keyIndex - 1;
1117             uint256 lastIndex = map._entries.length - 1;
1118 
1119             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1120             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1121 
1122             MapEntry storage lastEntry = map._entries[lastIndex];
1123 
1124             // Move the last entry to the index where the entry to delete is
1125             map._entries[toDeleteIndex] = lastEntry;
1126             // Update the index for the moved entry
1127             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1128 
1129             // Delete the slot where the moved entry was stored
1130             map._entries.pop();
1131 
1132             // Delete the index for the deleted slot
1133             delete map._indexes[key];
1134 
1135             return true;
1136         } else {
1137             return false;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Returns true if the key is in the map. O(1).
1143      */
1144     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1145         return map._indexes[key] != 0;
1146     }
1147 
1148     /**
1149      * @dev Returns the number of key-value pairs in the map. O(1).
1150      */
1151     function _length(Map storage map) private view returns (uint256) {
1152         return map._entries.length;
1153     }
1154 
1155    /**
1156     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1157     *
1158     * Note that there are no guarantees on the ordering of entries inside the
1159     * array, and it may change when more entries are added or removed.
1160     *
1161     * Requirements:
1162     *
1163     * - `index` must be strictly less than {length}.
1164     */
1165     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1166         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1167 
1168         MapEntry storage entry = map._entries[index];
1169         return (entry._key, entry._value);
1170     }
1171 
1172     /**
1173      * @dev Tries to returns the value associated with `key`.  O(1).
1174      * Does not revert if `key` is not in the map.
1175      */
1176     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1177         uint256 keyIndex = map._indexes[key];
1178         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1179         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1180     }
1181 
1182     /**
1183      * @dev Returns the value associated with `key`.  O(1).
1184      *
1185      * Requirements:
1186      *
1187      * - `key` must be in the map.
1188      */
1189     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1190         uint256 keyIndex = map._indexes[key];
1191         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1192         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1193     }
1194 
1195     /**
1196      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1197      *
1198      * CAUTION: This function is deprecated because it requires allocating memory for the error
1199      * message unnecessarily. For custom revert reasons use {_tryGet}.
1200      */
1201     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1202         uint256 keyIndex = map._indexes[key];
1203         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1204         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1205     }
1206 
1207     // UintToAddressMap
1208 
1209     struct UintToAddressMap {
1210         Map _inner;
1211     }
1212 
1213     /**
1214      * @dev Adds a key-value pair to a map, or updates the value for an existing
1215      * key. O(1).
1216      *
1217      * Returns true if the key was added to the map, that is if it was not
1218      * already present.
1219      */
1220     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1221         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1222     }
1223 
1224     /**
1225      * @dev Removes a value from a set. O(1).
1226      *
1227      * Returns true if the key was removed from the map, that is if it was present.
1228      */
1229     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1230         return _remove(map._inner, bytes32(key));
1231     }
1232 
1233     /**
1234      * @dev Returns true if the key is in the map. O(1).
1235      */
1236     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1237         return _contains(map._inner, bytes32(key));
1238     }
1239 
1240     /**
1241      * @dev Returns the number of elements in the map. O(1).
1242      */
1243     function length(UintToAddressMap storage map) internal view returns (uint256) {
1244         return _length(map._inner);
1245     }
1246 
1247    /**
1248     * @dev Returns the element stored at position `index` in the set. O(1).
1249     * Note that there are no guarantees on the ordering of values inside the
1250     * array, and it may change when more values are added or removed.
1251     *
1252     * Requirements:
1253     *
1254     * - `index` must be strictly less than {length}.
1255     */
1256     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1257         (bytes32 key, bytes32 value) = _at(map._inner, index);
1258         return (uint256(key), address(uint160(uint256(value))));
1259     }
1260 
1261     /**
1262      * @dev Tries to returns the value associated with `key`.  O(1).
1263      * Does not revert if `key` is not in the map.
1264      *
1265      * _Available since v3.4._
1266      */
1267     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1268         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1269         return (success, address(uint160(uint256(value))));
1270     }
1271 
1272     /**
1273      * @dev Returns the value associated with `key`.  O(1).
1274      *
1275      * Requirements:
1276      *
1277      * - `key` must be in the map.
1278      */
1279     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1280         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1281     }
1282 
1283     /**
1284      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1285      *
1286      * CAUTION: This function is deprecated because it requires allocating memory for the error
1287      * message unnecessarily. For custom revert reasons use {tryGet}.
1288      */
1289     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1290         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1291     }
1292 }
1293 
1294 // File: @openzeppelin/contracts/utils/Strings.sol
1295 
1296 
1297 pragma solidity >=0.6.0 <0.8.0;
1298 
1299 /**
1300  * @dev String operations.
1301  */
1302 library Strings {
1303     /**
1304      * @dev Converts a `uint256` to its ASCII `string` representation.
1305      */
1306     function toString(uint256 value) internal pure returns (string memory) {
1307         // Inspired by OraclizeAPI's implementation - MIT licence
1308         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1309 
1310         if (value == 0) {
1311             return "0";
1312         }
1313         uint256 temp = value;
1314         uint256 digits;
1315         while (temp != 0) {
1316             digits++;
1317             temp /= 10;
1318         }
1319         bytes memory buffer = new bytes(digits);
1320         uint256 index = digits - 1;
1321         temp = value;
1322         while (temp != 0) {
1323             buffer[index--] = bytes1(uint8(48 + temp % 10));
1324             temp /= 10;
1325         }
1326         return string(buffer);
1327     }
1328 }
1329 
1330 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1331 
1332 
1333 pragma solidity >=0.6.0 <0.8.0;
1334 
1335 
1336 
1337 
1338 
1339 
1340 
1341 
1342 
1343 
1344 
1345 
1346 /**
1347  * @title ERC721 Non-Fungible Token Standard basic implementation
1348  * @dev see https://eips.ethereum.org/EIPS/eip-721
1349  */
1350 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1351     using SafeMath for uint256;
1352     using Address for address;
1353     using EnumerableSet for EnumerableSet.UintSet;
1354     using EnumerableMap for EnumerableMap.UintToAddressMap;
1355     using Strings for uint256;
1356 
1357     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1358     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1359     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1360 
1361     // Mapping from holder address to their (enumerable) set of owned tokens
1362     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1363 
1364     // Enumerable mapping from token ids to their owners
1365     EnumerableMap.UintToAddressMap private _tokenOwners;
1366 
1367     // Mapping from token ID to approved address
1368     mapping (uint256 => address) private _tokenApprovals;
1369 
1370     // Mapping from owner to operator approvals
1371     mapping (address => mapping (address => bool)) private _operatorApprovals;
1372 
1373     // Token name
1374     string private _name;
1375 
1376     // Token symbol
1377     string private _symbol;
1378 
1379     // Optional mapping for token URIs
1380     mapping (uint256 => string) private _tokenURIs;
1381 
1382     // Base URI
1383     string private _baseURI;
1384 
1385     /*
1386      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1387      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1388      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1389      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1390      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1391      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1392      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1393      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1394      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1395      *
1396      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1397      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1398      */
1399     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1400 
1401     /*
1402      *     bytes4(keccak256('name()')) == 0x06fdde03
1403      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1404      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1405      *
1406      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1407      */
1408     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1409 
1410     /*
1411      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1412      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1413      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1414      *
1415      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1416      */
1417     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1418 
1419     /**
1420      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1421      */
1422     constructor (string memory name_, string memory symbol_) public {
1423         _name = name_;
1424         _symbol = symbol_;
1425 
1426         // register the supported interfaces to conform to ERC721 via ERC165
1427         _registerInterface(_INTERFACE_ID_ERC721);
1428         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1429         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-balanceOf}.
1434      */
1435     function balanceOf(address owner) public view virtual override returns (uint256) {
1436         require(owner != address(0), "ERC721: balance query for the zero address");
1437         return _holderTokens[owner].length();
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-ownerOf}.
1442      */
1443     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1444         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1445     }
1446 
1447     /**
1448      * @dev See {IERC721Metadata-name}.
1449      */
1450     function name() public view virtual override returns (string memory) {
1451         return _name;
1452     }
1453 
1454     /**
1455      * @dev See {IERC721Metadata-symbol}.
1456      */
1457     function symbol() public view virtual override returns (string memory) {
1458         return _symbol;
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Metadata-tokenURI}.
1463      */
1464     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1465         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1466 
1467         string memory _tokenURI = _tokenURIs[tokenId];
1468         string memory base = baseURI();
1469 
1470         // If there is no base URI, return the token URI.
1471         if (bytes(base).length == 0) {
1472             return _tokenURI;
1473         }
1474         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1475         if (bytes(_tokenURI).length > 0) {
1476             return string(abi.encodePacked(base, _tokenURI));
1477         }
1478         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1479         return string(abi.encodePacked(base, tokenId.toString()));
1480     }
1481 
1482     /**
1483     * @dev Returns the base URI set via {_setBaseURI}. This will be
1484     * automatically added as a prefix in {tokenURI} to each token's URI, or
1485     * to the token ID if no specific URI is set for that token ID.
1486     */
1487     function baseURI() public view virtual returns (string memory) {
1488         return _baseURI;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1493      */
1494     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1495         return _holderTokens[owner].at(index);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721Enumerable-totalSupply}.
1500      */
1501     function totalSupply() public view virtual override returns (uint256) {
1502         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1503         return _tokenOwners.length();
1504     }
1505 
1506     /**
1507      * @dev See {IERC721Enumerable-tokenByIndex}.
1508      */
1509     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1510         (uint256 tokenId, ) = _tokenOwners.at(index);
1511         return tokenId;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-approve}.
1516      */
1517     function approve(address to, uint256 tokenId) public virtual override {
1518         address owner = ERC721.ownerOf(tokenId);
1519         require(to != owner, "ERC721: approval to current owner");
1520 
1521         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1522             "ERC721: approve caller is not owner nor approved for all"
1523         );
1524 
1525         _approve(to, tokenId);
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-getApproved}.
1530      */
1531     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1532         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1533 
1534         return _tokenApprovals[tokenId];
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-setApprovalForAll}.
1539      */
1540     function setApprovalForAll(address operator, bool approved) public virtual override {
1541         require(operator != _msgSender(), "ERC721: approve to caller");
1542 
1543         _operatorApprovals[_msgSender()][operator] = approved;
1544         emit ApprovalForAll(_msgSender(), operator, approved);
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-isApprovedForAll}.
1549      */
1550     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1551         return _operatorApprovals[owner][operator];
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-transferFrom}.
1556      */
1557     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1558         //solhint-disable-next-line max-line-length
1559         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1560 
1561         _transfer(from, to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-safeTransferFrom}.
1566      */
1567     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1568         safeTransferFrom(from, to, tokenId, "");
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-safeTransferFrom}.
1573      */
1574     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1575         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1576         _safeTransfer(from, to, tokenId, _data);
1577     }
1578 
1579     /**
1580      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1581      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1582      *
1583      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1584      *
1585      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1586      * implement alternative mechanisms to perform token transfer, such as signature-based.
1587      *
1588      * Requirements:
1589      *
1590      * - `from` cannot be the zero address.
1591      * - `to` cannot be the zero address.
1592      * - `tokenId` token must exist and be owned by `from`.
1593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1598         _transfer(from, to, tokenId);
1599         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1600     }
1601 
1602     /**
1603      * @dev Returns whether `tokenId` exists.
1604      *
1605      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1606      *
1607      * Tokens start existing when they are minted (`_mint`),
1608      * and stop existing when they are burned (`_burn`).
1609      */
1610     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1611         return _tokenOwners.contains(tokenId);
1612     }
1613 
1614     /**
1615      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      */
1621     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1622         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1623         address owner = ERC721.ownerOf(tokenId);
1624         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1625     }
1626 
1627     /**
1628      * @dev Safely mints `tokenId` and transfers it to `to`.
1629      *
1630      * Requirements:
1631      d*
1632      * - `tokenId` must not exist.
1633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function _safeMint(address to, uint256 tokenId) internal virtual {
1638         _safeMint(to, tokenId, "");
1639     }
1640 
1641     /**
1642      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1643      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1644      */
1645     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1646         _mint(to, tokenId);
1647         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1648     }
1649 
1650     /**
1651      * @dev Mints `tokenId` and transfers it to `to`.
1652      *
1653      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1654      *
1655      * Requirements:
1656      *
1657      * - `tokenId` must not exist.
1658      * - `to` cannot be the zero address.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function _mint(address to, uint256 tokenId) internal virtual {
1663         require(to != address(0), "ERC721: mint to the zero address");
1664         require(!_exists(tokenId), "ERC721: token already minted");
1665 
1666         _beforeTokenTransfer(address(0), to, tokenId);
1667 
1668         _holderTokens[to].add(tokenId);
1669 
1670         _tokenOwners.set(tokenId, to);
1671 
1672         emit Transfer(address(0), to, tokenId);
1673     }
1674 
1675     /**
1676      * @dev Destroys `tokenId`.
1677      * The approval is cleared when the token is burned.
1678      *
1679      * Requirements:
1680      *
1681      * - `tokenId` must exist.
1682      *
1683      * Emits a {Transfer} event.
1684      */
1685     function _burn(uint256 tokenId) internal virtual {
1686         address owner = ERC721.ownerOf(tokenId); // internal owner
1687 
1688         _beforeTokenTransfer(owner, address(0), tokenId);
1689 
1690         // Clear approvals
1691         _approve(address(0), tokenId);
1692 
1693         // Clear metadata (if any)
1694         if (bytes(_tokenURIs[tokenId]).length != 0) {
1695             delete _tokenURIs[tokenId];
1696         }
1697 
1698         _holderTokens[owner].remove(tokenId);
1699 
1700         _tokenOwners.remove(tokenId);
1701 
1702         emit Transfer(owner, address(0), tokenId);
1703     }
1704 
1705     /**
1706      * @dev Transfers `tokenId` from `from` to `to`.
1707      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1708      *
1709      * Requirements:
1710      *
1711      * - `to` cannot be the zero address.
1712      * - `tokenId` token must be owned by `from`.
1713      *
1714      * Emits a {Transfer} event.
1715      */
1716     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1717         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1718         require(to != address(0), "ERC721: transfer to the zero address");
1719 
1720         _beforeTokenTransfer(from, to, tokenId);
1721 
1722         // Clear approvals from the previous owner
1723         _approve(address(0), tokenId);
1724 
1725         _holderTokens[from].remove(tokenId);
1726         _holderTokens[to].add(tokenId);
1727 
1728         _tokenOwners.set(tokenId, to);
1729 
1730         emit Transfer(from, to, tokenId);
1731     }
1732 
1733     /**
1734      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1735      *
1736      * Requirements:
1737      *
1738      * - `tokenId` must exist.
1739      */
1740     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1741         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1742         _tokenURIs[tokenId] = _tokenURI;
1743     }
1744 
1745     /**
1746      * @dev Internal function to set the base URI for all token IDs. It is
1747      * automatically added as a prefix to the value returned in {tokenURI},
1748      * or to the token ID if {tokenURI} is empty.
1749      */
1750     function _setBaseURI(string memory baseURI_) internal virtual {
1751         _baseURI = baseURI_;
1752     }
1753 
1754     /**
1755      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1756      * The call is not executed if the target address is not a contract.
1757      *
1758      * @param from address representing the previous owner of the given token ID
1759      * @param to target address that will receive the tokens
1760      * @param tokenId uint256 ID of the token to be transferred
1761      * @param _data bytes optional data to send along with the call
1762      * @return bool whether the call correctly returned the expected magic value
1763      */
1764     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1765         private returns (bool)
1766     {
1767         if (!to.isContract()) {
1768             return true;
1769         }
1770         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1771             IERC721Receiver(to).onERC721Received.selector,
1772             _msgSender(),
1773             from,
1774             tokenId,
1775             _data
1776         ), "ERC721: transfer to non ERC721Receiver implementer");
1777         bytes4 retval = abi.decode(returndata, (bytes4));
1778         return (retval == _ERC721_RECEIVED);
1779     }
1780 
1781     /**
1782      * @dev Approve `to` to operate on `tokenId`
1783      *
1784      * Emits an {Approval} event.
1785      */
1786     function _approve(address to, uint256 tokenId) internal virtual {
1787         _tokenApprovals[tokenId] = to;
1788         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1789     }
1790 
1791     /**
1792      * @dev Hook that is called before any token transfer. This includes minting
1793      * and burning.
1794      *
1795      * Calling conditions:
1796      *
1797      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1798      * transferred to `to`.
1799      * - When `from` is zero, `tokenId` will be minted for `to`.
1800      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1801      * - `from` cannot be the zero address.
1802      * - `to` cannot be the zero address.
1803      *
1804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1805      */
1806     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1807 }
1808 
1809 // File: @openzeppelin/contracts/access/Ownable.sol
1810 
1811 
1812 pragma solidity >=0.6.0 <0.8.0;
1813 
1814 /**
1815  * @dev Contract module which provides a basic access control mechanism, where
1816  * there is an account (an owner) that can be granted exclusive access to
1817  * specific functions.
1818  *
1819  * By default, the owner account will be the one that deploys the contract. This
1820  * can later be changed with {transferOwnership}.
1821  *
1822  * This module is used through inheritance. It will make available the modifier
1823  * `onlyOwner`, which can be applied to your functions to restrict their use to
1824  * the owner.
1825  */
1826 abstract contract Ownable is Context {
1827     address private _owner;
1828 
1829     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1830 
1831     /**
1832      * @dev Initializes the contract setting the deployer as the initial owner.
1833      */
1834     constructor () internal {
1835         address msgSender = _msgSender();
1836         _owner = msgSender;
1837         emit OwnershipTransferred(address(0), msgSender);
1838     }
1839 
1840     /**
1841      * @dev Returns the address of the current owner.
1842      */
1843     function owner() public view virtual returns (address) {
1844         return _owner;
1845     }
1846 
1847     /**
1848      * @dev Throws if called by any account other than the owner.
1849      */
1850     modifier onlyOwner() {
1851         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1852         _;
1853     }
1854 
1855     /**
1856      * @dev Leaves the contract without owner. It will not be possible to call
1857      * `onlyOwner` functions anymore. Can only be called by the current owner.
1858      *
1859      * NOTE: Renouncing ownership will leave the contract without an owner,
1860      * thereby removing any functionality that is only available to the owner.
1861      */
1862     function renounceOwnership() public virtual onlyOwner {
1863         emit OwnershipTransferred(_owner, address(0));
1864         _owner = address(0);
1865     }
1866 
1867     /**
1868      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1869      * Can only be called by the current owner.
1870      */
1871     function transferOwnership(address newOwner) public virtual onlyOwner {
1872         require(newOwner != address(0), "Ownable: new owner is the zero address");
1873         emit OwnershipTransferred(_owner, newOwner);
1874         _owner = newOwner;
1875     }
1876 }
1877 
1878 // File: contracts/helpers/strings.sol
1879 
1880 /*
1881  * @title String & slice utility library for Solidity contracts.
1882  * @author Nick Johnson <arachnid@notdot.net>
1883  */
1884 
1885 pragma solidity ^0.6.8;
1886 
1887 library strings {
1888     struct slice {
1889         uint _len;
1890         uint _ptr;
1891     }
1892 
1893     function memcpy(uint dest, uint src, uint len) private pure {
1894         // Copy word-length chunks while possible
1895         for (; len >= 32; len -= 32) {
1896             assembly {
1897                 mstore(dest, mload(src))
1898             }
1899             dest += 32;
1900             src += 32;
1901         }
1902 
1903         // Copy remaining bytes
1904         uint mask = 256 ** (32 - len) - 1;
1905         assembly {
1906             let srcpart := and(mload(src), not(mask))
1907             let destpart := and(mload(dest), mask)
1908             mstore(dest, or(destpart, srcpart))
1909         }
1910     }
1911 
1912     /*
1913      * @dev Returns a slice containing the entire string.
1914      * @param self The string to make a slice from.
1915      * @return A newly allocated slice containing the entire string.
1916      */
1917     function toSlice(string memory self) internal pure returns (slice memory) {
1918         uint ptr;
1919         assembly {
1920             ptr := add(self, 0x20)
1921         }
1922         return slice(bytes(self).length, ptr);
1923     }
1924 
1925     /*
1926      * @dev Returns a newly allocated string containing the concatenation of
1927      *      `self` and `other`.
1928      * @param self The first slice to concatenate.
1929      * @param other The second slice to concatenate.
1930      * @return The concatenation of the two strings.
1931      */
1932     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1933         string memory ret = new string(self._len + other._len);
1934         uint retptr;
1935         assembly {
1936             retptr := add(ret, 32)
1937         }
1938         memcpy(retptr, self._ptr, self._len);
1939         memcpy(retptr + self._len, other._ptr, other._len);
1940         return ret;
1941     }
1942 }
1943 
1944 // File: contracts/Metadata.sol
1945 
1946 pragma solidity ^0.6.8;
1947 
1948 /**
1949 * Metadata contract is upgradeable and returns metadata about Token
1950 */
1951 
1952 
1953 contract Metadata {
1954     using strings for *;
1955 
1956     function tokenURI(uint256 _tokenId) public pure returns (string memory _infoUrl) {
1957         string memory base = "https://virus.folia.app/metadata/";
1958         string memory id = uint2str(_tokenId);
1959         return base.toSlice().concat(id.toSlice());
1960     }
1961     function uint2str(uint i) internal pure returns (string memory) {
1962         if (i == 0) return "0";
1963         uint j = i;
1964         uint length;
1965         while (j != 0) {
1966             length++;
1967             j /= 10;
1968         }
1969         bytes memory bstr = new bytes(length);
1970         uint k = length - 1;
1971         while (i != 0) {
1972             uint _uint = 48 + i % 10;
1973             bstr[k--] = toBytes(_uint)[31];
1974             i /= 10;
1975         }
1976         return string(bstr);
1977     }
1978     function toBytes(uint256 x) public pure returns (bytes memory b) {
1979         b = new bytes(32);
1980         assembly { mstore(add(b, 32), x) }
1981     }
1982 }
1983 
1984 // File: contracts/Kudzu.sol
1985 
1986 pragma solidity ^0.6.8;
1987 
1988 
1989 
1990 
1991 /**
1992  * The FoliaVirus contract does this and that and doesn't stop.
1993  */
1994 
1995 contract Kudzu is ERC721, Ownable {
1996     Metadata public metadata;
1997 
1998     event Infect(address indexed from, address indexed to, uint256 indexed tokenId);
1999 
2000     constructor(Metadata _metadata, address genesis) public ERC721("FoliaVirus", "☣️") {
2001         metadata = _metadata;
2002         uint256 tokenId = 1;
2003 
2004         tokenId = tokenId << 8;
2005         tokenId = tokenId | pseudoRNG(32, 1);
2006 
2007         tokenId = tokenId << 8;
2008         tokenId = tokenId | pseudoRNG(32, 2);
2009         _mint(genesis, tokenId);
2010         emit Infect(address(0), genesis, tokenId);
2011     }
2012     function getPiecesOfTokenID(uint256 tokenId) public pure returns(uint256 id, uint256 eyes, uint256 mouth) {
2013         return (tokenId >> 16, (tokenId >> 8 & 0xFF), tokenId & 0xFF);
2014     }
2015     function updateMetadata(Metadata _metadata) public onlyOwner {
2016         metadata = _metadata;
2017     }
2018     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2019         require(balanceOf(from) == 1, "NOT YET INFECTED");
2020         require(balanceOf(to) == 0, "ALREADY INFECTED");
2021         uint256 parentId = tokenId;
2022         tokenId = totalSupply() + 1;
2023         tokenId = tokenId << 8;
2024         if (pseudoRNG(2, 1) == 0) {
2025             //inherit eyes
2026             tokenId = tokenId | (parentId >> 8 & 0xFF);
2027             tokenId = tokenId << 8;
2028             tokenId = tokenId | pseudoRNG(32, 2);
2029         } else {
2030             //inherit mouth
2031             tokenId = tokenId | pseudoRNG(32, 3);
2032             tokenId = tokenId << 8;
2033             tokenId = tokenId | (parentId & 0xFF);
2034         }
2035         _mint(to, tokenId);
2036         emit Infect(from, to, tokenId);
2037     }
2038 
2039     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2040         return metadata.tokenURI(tokenId);
2041     }
2042     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {}
2043     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {}
2044     function pseudoRNG(uint modulo, uint nonce) private view returns (uint256) {
2045         return uint256(keccak256(abi.encodePacked(block.difficulty, now, totalSupply(), nonce))) % modulo;
2046     }
2047 }