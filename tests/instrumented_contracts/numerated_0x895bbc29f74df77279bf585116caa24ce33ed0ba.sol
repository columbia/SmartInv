1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-03
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/introspection/IERC165.sol
33 
34 
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Interface of the ERC165 standard, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-165[EIP].
41  *
42  * Implementers can declare support of contract interfaces, which can then be
43  * queried by others ({ERC165Checker}).
44  *
45  * For an implementation, see {ERC165}.
46  */
47 interface IERC165 {
48     /**
49      * @dev Returns true if this contract implements the interface defined by
50      * `interfaceId`. See the corresponding
51      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
52      * to learn more about how these ids are created.
53      *
54      * This function call must use less than 30 000 gas.
55      */
56     function supportsInterface(bytes4 interfaceId) external view returns (bool);
57 }
58 
59 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
60 
61 
62 
63 pragma solidity >=0.6.2 <0.8.0;
64 
65 
66 /**
67  * @dev Required interface of an ERC721 compliant contract.
68  */
69 interface IERC721 is IERC165 {
70     /**
71      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
74 
75     /**
76      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
77      */
78     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
79 
80     /**
81      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
82      */
83     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
84 
85     /**
86      * @dev Returns the number of tokens in ``owner``'s account.
87      */
88     function balanceOf(address owner) external view returns (uint256 balance);
89 
90     /**
91      * @dev Returns the owner of the `tokenId` token.
92      *
93      * Requirements:
94      *
95      * - `tokenId` must exist.
96      */
97     function ownerOf(uint256 tokenId) external view returns (address owner);
98 
99     /**
100      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
101      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must exist and be owned by `from`.
108      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
110      *
111      * Emits a {Transfer} event.
112      */
113     function safeTransferFrom(address from, address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Transfers `tokenId` token from `from` to `to`.
117      *
118      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
119      *
120      * Requirements:
121      *
122      * - `from` cannot be the zero address.
123      * - `to` cannot be the zero address.
124      * - `tokenId` token must be owned by `from`.
125      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(address from, address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 
174     /**
175       * @dev Safely transfers `tokenId` token from `from` to `to`.
176       *
177       * Requirements:
178       *
179       * - `from` cannot be the zero address.
180       * - `to` cannot be the zero address.
181       * - `tokenId` token must exist and be owned by `from`.
182       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184       *
185       * Emits a {Transfer} event.
186       */
187     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
191 
192 
193 
194 pragma solidity >=0.6.2 <0.8.0;
195 
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202 
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
220 
221 
222 
223 pragma solidity >=0.6.2 <0.8.0;
224 
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Enumerable is IERC721 {
231 
232     /**
233      * @dev Returns the total amount of tokens stored by the contract.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
239      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
240      */
241     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
242 
243     /**
244      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
245      * Use along with {totalSupply} to enumerate all tokens.
246      */
247     function tokenByIndex(uint256 index) external view returns (uint256);
248 }
249 
250 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
251 
252 
253 
254 pragma solidity >=0.6.0 <0.8.0;
255 
256 /**
257  * @title ERC721 token receiver interface
258  * @dev Interface for any contract that wants to support safeTransfers
259  * from ERC721 asset contracts.
260  */
261 interface IERC721Receiver {
262     /**
263      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
264      * by `operator` from `from`, this function is called.
265      *
266      * It must return its Solidity selector to confirm the token transfer.
267      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
268      *
269      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
270      */
271     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
272 }
273 
274 // File: @openzeppelin/contracts/introspection/ERC165.sol
275 
276 
277 
278 pragma solidity >=0.6.0 <0.8.0;
279 
280 
281 /**
282  * @dev Implementation of the {IERC165} interface.
283  *
284  * Contracts may inherit from this and call {_registerInterface} to declare
285  * their support of an interface.
286  */
287 abstract contract ERC165 is IERC165 {
288     /*
289      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
290      */
291     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
292 
293     /**
294      * @dev Mapping of interface ids to whether or not it's supported.
295      */
296     mapping(bytes4 => bool) private _supportedInterfaces;
297 
298     constructor ()  {
299         // Derived contracts need only register support for their own interfaces,
300         // we register support for ERC165 itself here
301         _registerInterface(_INTERFACE_ID_ERC165);
302     }
303 
304     /**
305      * @dev See {IERC165-supportsInterface}.
306      *
307      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
308      */
309     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310         return _supportedInterfaces[interfaceId];
311     }
312 
313     /**
314      * @dev Registers the contract as an implementer of the interface defined by
315      * `interfaceId`. Support of the actual ERC165 interface is automatic and
316      * registering its interface id is not required.
317      *
318      * See {IERC165-supportsInterface}.
319      *
320      * Requirements:
321      *
322      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
323      */
324     function _registerInterface(bytes4 interfaceId) internal virtual {
325         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
326         _supportedInterfaces[interfaceId] = true;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/math/SafeMath.sol
331 
332 
333 
334 pragma solidity >=0.6.0 <0.8.0;
335 
336 /**
337  * @dev Wrappers over Solidity's arithmetic operations with added overflow
338  * checks.
339  *
340  * Arithmetic operations in Solidity wrap on overflow. This can easily result
341  * in bugs, because programmers usually assume that an overflow raises an
342  * error, which is the standard behavior in high level programming languages.
343  * `SafeMath` restores this intuition by reverting the transaction when an
344  * operation overflows.
345  *
346  * Using this library instead of the unchecked operations eliminates an entire
347  * class of bugs, so it's recommended to use it always.
348  */
349 library SafeMath {
350     /**
351      * @dev Returns the addition of two unsigned integers, with an overflow flag.
352      *
353      * _Available since v3.4._
354      */
355     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356         uint256 c = a + b;
357         if (c < a) return (false, 0);
358         return (true, c);
359     }
360 
361     /**
362      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
363      *
364      * _Available since v3.4._
365      */
366     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
367         if (b > a) return (false, 0);
368         return (true, a - b);
369     }
370 
371     /**
372      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
378         // benefit is lost if 'b' is also tested.
379         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
380         if (a == 0) return (true, 0);
381         uint256 c = a * b;
382         if (c / a != b) return (false, 0);
383         return (true, c);
384     }
385 
386     /**
387      * @dev Returns the division of two unsigned integers, with a division by zero flag.
388      *
389      * _Available since v3.4._
390      */
391     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
392         if (b == 0) return (false, 0);
393         return (true, a / b);
394     }
395 
396     /**
397      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
398      *
399      * _Available since v3.4._
400      */
401     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
402         if (b == 0) return (false, 0);
403         return (true, a % b);
404     }
405 
406     /**
407      * @dev Returns the addition of two unsigned integers, reverting on
408      * overflow.
409      *
410      * Counterpart to Solidity's `+` operator.
411      *
412      * Requirements:
413      *
414      * - Addition cannot overflow.
415      */
416     function add(uint256 a, uint256 b) internal pure returns (uint256) {
417         uint256 c = a + b;
418         require(c >= a, "SafeMath: addition overflow");
419         return c;
420     }
421 
422     /**
423      * @dev Returns the subtraction of two unsigned integers, reverting on
424      * overflow (when the result is negative).
425      *
426      * Counterpart to Solidity's `-` operator.
427      *
428      * Requirements:
429      *
430      * - Subtraction cannot overflow.
431      */
432     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
433         require(b <= a, "SafeMath: subtraction overflow");
434         return a - b;
435     }
436 
437     /**
438      * @dev Returns the multiplication of two unsigned integers, reverting on
439      * overflow.
440      *
441      * Counterpart to Solidity's `*` operator.
442      *
443      * Requirements:
444      *
445      * - Multiplication cannot overflow.
446      */
447     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
448         if (a == 0) return 0;
449         uint256 c = a * b;
450         require(c / a == b, "SafeMath: multiplication overflow");
451         return c;
452     }
453 
454     /**
455      * @dev Returns the integer division of two unsigned integers, reverting on
456      * division by zero. The result is rounded towards zero.
457      *
458      * Counterpart to Solidity's `/` operator. Note: this function uses a
459      * `revert` opcode (which leaves remaining gas untouched) while Solidity
460      * uses an invalid opcode to revert (consuming all remaining gas).
461      *
462      * Requirements:
463      *
464      * - The divisor cannot be zero.
465      */
466     function div(uint256 a, uint256 b) internal pure returns (uint256) {
467         require(b > 0, "SafeMath: division by zero");
468         return a / b;
469     }
470 
471     /**
472      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
473      * reverting when dividing by zero.
474      *
475      * Counterpart to Solidity's `%` operator. This function uses a `revert`
476      * opcode (which leaves remaining gas untouched) while Solidity uses an
477      * invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
484         require(b > 0, "SafeMath: modulo by zero");
485         return a % b;
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
490      * overflow (when the result is negative).
491      *
492      * CAUTION: This function is deprecated because it requires allocating memory for the error
493      * message unnecessarily. For custom revert reasons use {trySub}.
494      *
495      * Counterpart to Solidity's `-` operator.
496      *
497      * Requirements:
498      *
499      * - Subtraction cannot overflow.
500      */
501     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
502         require(b <= a, errorMessage);
503         return a - b;
504     }
505 
506     /**
507      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
508      * division by zero. The result is rounded towards zero.
509      *
510      * CAUTION: This function is deprecated because it requires allocating memory for the error
511      * message unnecessarily. For custom revert reasons use {tryDiv}.
512      *
513      * Counterpart to Solidity's `/` operator. Note: this function uses a
514      * `revert` opcode (which leaves remaining gas untouched) while Solidity
515      * uses an invalid opcode to revert (consuming all remaining gas).
516      *
517      * Requirements:
518      *
519      * - The divisor cannot be zero.
520      */
521     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
522         require(b > 0, errorMessage);
523         return a / b;
524     }
525 
526     /**
527      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
528      * reverting with custom message when dividing by zero.
529      *
530      * CAUTION: This function is deprecated because it requires allocating memory for the error
531      * message unnecessarily. For custom revert reasons use {tryMod}.
532      *
533      * Counterpart to Solidity's `%` operator. This function uses a `revert`
534      * opcode (which leaves remaining gas untouched) while Solidity uses an
535      * invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
542         require(b > 0, errorMessage);
543         return a % b;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/utils/Address.sol
548 
549 
550 
551 pragma solidity >=0.6.2 <0.8.0;
552 
553 /**
554  * @dev Collection of functions related to the address type
555  */
556 library Address {
557     /**
558      * @dev Returns true if `account` is a contract.
559      *
560      * [IMPORTANT]
561      * ====
562      * It is unsafe to assume that an address for which this function returns
563      * false is an externally-owned account (EOA) and not a contract.
564      *
565      * Among others, `isContract` will return false for the following
566      * types of addresses:
567      *
568      *  - an externally-owned account
569      *  - a contract in construction
570      *  - an address where a contract will be created
571      *  - an address where a contract lived, but was destroyed
572      * ====
573      */
574     function isContract(address account) internal view returns (bool) {
575         // This method relies on extcodesize, which returns 0 for contracts in
576         // construction, since the code is only stored at the end of the
577         // constructor execution.
578 
579         uint256 size;
580         // solhint-disable-next-line no-inline-assembly
581         assembly { size := extcodesize(account) }
582         return size > 0;
583     }
584 
585     /**
586      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
587      * `recipient`, forwarding all available gas and reverting on errors.
588      *
589      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
590      * of certain opcodes, possibly making contracts go over the 2300 gas limit
591      * imposed by `transfer`, making them unable to receive funds via
592      * `transfer`. {sendValue} removes this limitation.
593      *
594      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
595      *
596      * IMPORTANT: because control is transferred to `recipient`, care must be
597      * taken to not create reentrancy vulnerabilities. Consider using
598      * {ReentrancyGuard} or the
599      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
600      */
601     function sendValue(address payable recipient, uint256 amount) internal {
602         require(address(this).balance >= amount, "Address: insufficient balance");
603 
604         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
605         (bool success, ) = recipient.call{ value: amount }("");
606         require(success, "Address: unable to send value, recipient may have reverted");
607     }
608 
609     /**
610      * @dev Performs a Solidity function call using a low level `call`. A
611      * plain`call` is an unsafe replacement for a function call: use this
612      * function instead.
613      *
614      * If `target` reverts with a revert reason, it is bubbled up by this
615      * function (like regular Solidity function calls).
616      *
617      * Returns the raw returned data. To convert to the expected return value,
618      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
619      *
620      * Requirements:
621      *
622      * - `target` must be a contract.
623      * - calling `target` with `data` must not revert.
624      *
625      * _Available since v3.1._
626      */
627     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
628       return functionCall(target, data, "Address: low-level call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
633      * `errorMessage` as a fallback revert reason when `target` reverts.
634      *
635      * _Available since v3.1._
636      */
637     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
638         return functionCallWithValue(target, data, 0, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but also transferring `value` wei to `target`.
644      *
645      * Requirements:
646      *
647      * - the calling contract must have an ETH balance of at least `value`.
648      * - the called Solidity function must be `payable`.
649      *
650      * _Available since v3.1._
651      */
652     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
653         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
658      * with `errorMessage` as a fallback revert reason when `target` reverts.
659      *
660      * _Available since v3.1._
661      */
662     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
663         require(address(this).balance >= value, "Address: insufficient balance for call");
664         require(isContract(target), "Address: call to non-contract");
665 
666         // solhint-disable-next-line avoid-low-level-calls
667         (bool success, bytes memory returndata) = target.call{ value: value }(data);
668         return _verifyCallResult(success, returndata, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but performing a static call.
674      *
675      * _Available since v3.3._
676      */
677     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
678         return functionStaticCall(target, data, "Address: low-level static call failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
683      * but performing a static call.
684      *
685      * _Available since v3.3._
686      */
687     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
688         require(isContract(target), "Address: static call to non-contract");
689 
690         // solhint-disable-next-line avoid-low-level-calls
691         (bool success, bytes memory returndata) = target.staticcall(data);
692         return _verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
697      * but performing a delegate call.
698      *
699      * _Available since v3.4._
700      */
701     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
702         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
707      * but performing a delegate call.
708      *
709      * _Available since v3.4._
710      */
711     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
712         require(isContract(target), "Address: delegate call to non-contract");
713 
714         // solhint-disable-next-line avoid-low-level-calls
715         (bool success, bytes memory returndata) = target.delegatecall(data);
716         return _verifyCallResult(success, returndata, errorMessage);
717     }
718 
719     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
720         if (success) {
721             return returndata;
722         } else {
723             // Look for revert reason and bubble it up if present
724             if (returndata.length > 0) {
725                 // The easiest way to bubble the revert reason is using memory via assembly
726 
727                 // solhint-disable-next-line no-inline-assembly
728                 assembly {
729                     let returndata_size := mload(returndata)
730                     revert(add(32, returndata), returndata_size)
731                 }
732             } else {
733                 revert(errorMessage);
734             }
735         }
736     }
737 }
738 
739 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
740 
741 
742 
743 pragma solidity >=0.6.0 <0.8.0;
744 
745 /**
746  * @dev Library for managing
747  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
748  * types.
749  *
750  * Sets have the following properties:
751  *
752  * - Elements are added, removed, and checked for existence in constant time
753  * (O(1)).
754  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
755  *
756  * ```
757  * contract Example {
758  *     // Add the library methods
759  *     using EnumerableSet for EnumerableSet.AddressSet;
760  *
761  *     // Declare a set state variable
762  *     EnumerableSet.AddressSet private mySet;
763  * }
764  * ```
765  *
766  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
767  * and `uint256` (`UintSet`) are supported.
768  */
769 library EnumerableSet {
770     // To implement this library for multiple types with as little code
771     // repetition as possible, we write it in terms of a generic Set type with
772     // bytes32 values.
773     // The Set implementation uses private functions, and user-facing
774     // implementations (such as AddressSet) are just wrappers around the
775     // underlying Set.
776     // This means that we can only create new EnumerableSets for types that fit
777     // in bytes32.
778 
779     struct Set {
780         // Storage of set values
781         bytes32[] _values;
782 
783         // Position of the value in the `values` array, plus 1 because index 0
784         // means a value is not in the set.
785         mapping (bytes32 => uint256) _indexes;
786     }
787 
788     /**
789      * @dev Add a value to a set. O(1).
790      *
791      * Returns true if the value was added to the set, that is if it was not
792      * already present.
793      */
794     function _add(Set storage set, bytes32 value) private returns (bool) {
795         if (!_contains(set, value)) {
796             set._values.push(value);
797             // The value is stored at length-1, but we add 1 to all indexes
798             // and use 0 as a sentinel value
799             set._indexes[value] = set._values.length;
800             return true;
801         } else {
802             return false;
803         }
804     }
805 
806     /**
807      * @dev Removes a value from a set. O(1).
808      *
809      * Returns true if the value was removed from the set, that is if it was
810      * present.
811      */
812     function _remove(Set storage set, bytes32 value) private returns (bool) {
813         // We read and store the value's index to prevent multiple reads from the same storage slot
814         uint256 valueIndex = set._indexes[value];
815 
816         if (valueIndex != 0) { // Equivalent to contains(set, value)
817             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
818             // the array, and then remove the last element (sometimes called as 'swap and pop').
819             // This modifies the order of the array, as noted in {at}.
820 
821             uint256 toDeleteIndex = valueIndex - 1;
822             uint256 lastIndex = set._values.length - 1;
823 
824             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
825             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
826 
827             bytes32 lastvalue = set._values[lastIndex];
828 
829             // Move the last value to the index where the value to delete is
830             set._values[toDeleteIndex] = lastvalue;
831             // Update the index for the moved value
832             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
833 
834             // Delete the slot where the moved value was stored
835             set._values.pop();
836 
837             // Delete the index for the deleted slot
838             delete set._indexes[value];
839 
840             return true;
841         } else {
842             return false;
843         }
844     }
845 
846     /**
847      * @dev Returns true if the value is in the set. O(1).
848      */
849     function _contains(Set storage set, bytes32 value) private view returns (bool) {
850         return set._indexes[value] != 0;
851     }
852 
853     /**
854      * @dev Returns the number of values on the set. O(1).
855      */
856     function _length(Set storage set) private view returns (uint256) {
857         return set._values.length;
858     }
859 
860    /**
861     * @dev Returns the value stored at position `index` in the set. O(1).
862     *
863     * Note that there are no guarantees on the ordering of values inside the
864     * array, and it may change when more values are added or removed.
865     *
866     * Requirements:
867     *
868     * - `index` must be strictly less than {length}.
869     */
870     function _at(Set storage set, uint256 index) private view returns (bytes32) {
871         require(set._values.length > index, "EnumerableSet: index out of bounds");
872         return set._values[index];
873     }
874 
875     // Bytes32Set
876 
877     struct Bytes32Set {
878         Set _inner;
879     }
880 
881     /**
882      * @dev Add a value to a set. O(1).
883      *
884      * Returns true if the value was added to the set, that is if it was not
885      * already present.
886      */
887     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
888         return _add(set._inner, value);
889     }
890 
891     /**
892      * @dev Removes a value from a set. O(1).
893      *
894      * Returns true if the value was removed from the set, that is if it was
895      * present.
896      */
897     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
898         return _remove(set._inner, value);
899     }
900 
901     /**
902      * @dev Returns true if the value is in the set. O(1).
903      */
904     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
905         return _contains(set._inner, value);
906     }
907 
908     /**
909      * @dev Returns the number of values in the set. O(1).
910      */
911     function length(Bytes32Set storage set) internal view returns (uint256) {
912         return _length(set._inner);
913     }
914 
915    /**
916     * @dev Returns the value stored at position `index` in the set. O(1).
917     *
918     * Note that there are no guarantees on the ordering of values inside the
919     * array, and it may change when more values are added or removed.
920     *
921     * Requirements:
922     *
923     * - `index` must be strictly less than {length}.
924     */
925     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
926         return _at(set._inner, index);
927     }
928 
929     // AddressSet
930 
931     struct AddressSet {
932         Set _inner;
933     }
934 
935     /**
936      * @dev Add a value to a set. O(1).
937      *
938      * Returns true if the value was added to the set, that is if it was not
939      * already present.
940      */
941     function add(AddressSet storage set, address value) internal returns (bool) {
942         return _add(set._inner, bytes32(uint256(uint160(value))));
943     }
944 
945     /**
946      * @dev Removes a value from a set. O(1).
947      *
948      * Returns true if the value was removed from the set, that is if it was
949      * present.
950      */
951     function remove(AddressSet storage set, address value) internal returns (bool) {
952         return _remove(set._inner, bytes32(uint256(uint160(value))));
953     }
954 
955     /**
956      * @dev Returns true if the value is in the set. O(1).
957      */
958     function contains(AddressSet storage set, address value) internal view returns (bool) {
959         return _contains(set._inner, bytes32(uint256(uint160(value))));
960     }
961 
962     /**
963      * @dev Returns the number of values in the set. O(1).
964      */
965     function length(AddressSet storage set) internal view returns (uint256) {
966         return _length(set._inner);
967     }
968 
969    /**
970     * @dev Returns the value stored at position `index` in the set. O(1).
971     *
972     * Note that there are no guarantees on the ordering of values inside the
973     * array, and it may change when more values are added or removed.
974     *
975     * Requirements:
976     *
977     * - `index` must be strictly less than {length}.
978     */
979     function at(AddressSet storage set, uint256 index) internal view returns (address) {
980         return address(uint160(uint256(_at(set._inner, index))));
981     }
982 
983 
984     // UintSet
985 
986     struct UintSet {
987         Set _inner;
988     }
989 
990     /**
991      * @dev Add a value to a set. O(1).
992      *
993      * Returns true if the value was added to the set, that is if it was not
994      * already present.
995      */
996     function add(UintSet storage set, uint256 value) internal returns (bool) {
997         return _add(set._inner, bytes32(value));
998     }
999 
1000     /**
1001      * @dev Removes a value from a set. O(1).
1002      *
1003      * Returns true if the value was removed from the set, that is if it was
1004      * present.
1005      */
1006     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1007         return _remove(set._inner, bytes32(value));
1008     }
1009 
1010     /**
1011      * @dev Returns true if the value is in the set. O(1).
1012      */
1013     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1014         return _contains(set._inner, bytes32(value));
1015     }
1016 
1017     /**
1018      * @dev Returns the number of values on the set. O(1).
1019      */
1020     function length(UintSet storage set) internal view returns (uint256) {
1021         return _length(set._inner);
1022     }
1023 
1024    /**
1025     * @dev Returns the value stored at position `index` in the set. O(1).
1026     *
1027     * Note that there are no guarantees on the ordering of values inside the
1028     * array, and it may change when more values are added or removed.
1029     *
1030     * Requirements:
1031     *
1032     * - `index` must be strictly less than {length}.
1033     */
1034     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1035         return uint256(_at(set._inner, index));
1036     }
1037 }
1038 
1039 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1040 
1041 
1042 
1043 pragma solidity >=0.6.0 <0.8.0;
1044 
1045 /**
1046  * @dev Library for managing an enumerable variant of Solidity's
1047  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1048  * type.
1049  *
1050  * Maps have the following properties:
1051  *
1052  * - Entries are added, removed, and checked for existence in constant time
1053  * (O(1)).
1054  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1055  *
1056  * ```
1057  * contract Example {
1058  *     // Add the library methods
1059  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1060  *
1061  *     // Declare a set state variable
1062  *     EnumerableMap.UintToAddressMap private myMap;
1063  * }
1064  * ```
1065  *
1066  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1067  * supported.
1068  */
1069 library EnumerableMap {
1070     // To implement this library for multiple types with as little code
1071     // repetition as possible, we write it in terms of a generic Map type with
1072     // bytes32 keys and values.
1073     // The Map implementation uses private functions, and user-facing
1074     // implementations (such as Uint256ToAddressMap) are just wrappers around
1075     // the underlying Map.
1076     // This means that we can only create new EnumerableMaps for types that fit
1077     // in bytes32.
1078 
1079     struct MapEntry {
1080         bytes32 _key;
1081         bytes32 _value;
1082     }
1083 
1084     struct Map {
1085         // Storage of map keys and values
1086         MapEntry[] _entries;
1087 
1088         // Position of the entry defined by a key in the `entries` array, plus 1
1089         // because index 0 means a key is not in the map.
1090         mapping (bytes32 => uint256) _indexes;
1091     }
1092 
1093     /**
1094      * @dev Adds a key-value pair to a map, or updates the value for an existing
1095      * key. O(1).
1096      *
1097      * Returns true if the key was added to the map, that is if it was not
1098      * already present.
1099      */
1100     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1101         // We read and store the key's index to prevent multiple reads from the same storage slot
1102         uint256 keyIndex = map._indexes[key];
1103 
1104         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1105             map._entries.push(MapEntry({ _key: key, _value: value }));
1106             // The entry is stored at length-1, but we add 1 to all indexes
1107             // and use 0 as a sentinel value
1108             map._indexes[key] = map._entries.length;
1109             return true;
1110         } else {
1111             map._entries[keyIndex - 1]._value = value;
1112             return false;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Removes a key-value pair from a map. O(1).
1118      *
1119      * Returns true if the key was removed from the map, that is if it was present.
1120      */
1121     function _remove(Map storage map, bytes32 key) private returns (bool) {
1122         // We read and store the key's index to prevent multiple reads from the same storage slot
1123         uint256 keyIndex = map._indexes[key];
1124 
1125         if (keyIndex != 0) { // Equivalent to contains(map, key)
1126             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1127             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1128             // This modifies the order of the array, as noted in {at}.
1129 
1130             uint256 toDeleteIndex = keyIndex - 1;
1131             uint256 lastIndex = map._entries.length - 1;
1132 
1133             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1134             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1135 
1136             MapEntry storage lastEntry = map._entries[lastIndex];
1137 
1138             // Move the last entry to the index where the entry to delete is
1139             map._entries[toDeleteIndex] = lastEntry;
1140             // Update the index for the moved entry
1141             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1142 
1143             // Delete the slot where the moved entry was stored
1144             map._entries.pop();
1145 
1146             // Delete the index for the deleted slot
1147             delete map._indexes[key];
1148 
1149             return true;
1150         } else {
1151             return false;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Returns true if the key is in the map. O(1).
1157      */
1158     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1159         return map._indexes[key] != 0;
1160     }
1161 
1162     /**
1163      * @dev Returns the number of key-value pairs in the map. O(1).
1164      */
1165     function _length(Map storage map) private view returns (uint256) {
1166         return map._entries.length;
1167     }
1168 
1169    /**
1170     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1171     *
1172     * Note that there are no guarantees on the ordering of entries inside the
1173     * array, and it may change when more entries are added or removed.
1174     *
1175     * Requirements:
1176     *
1177     * - `index` must be strictly less than {length}.
1178     */
1179     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1180         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1181 
1182         MapEntry storage entry = map._entries[index];
1183         return (entry._key, entry._value);
1184     }
1185 
1186     /**
1187      * @dev Tries to returns the value associated with `key`.  O(1).
1188      * Does not revert if `key` is not in the map.
1189      */
1190     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1191         uint256 keyIndex = map._indexes[key];
1192         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1193         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1194     }
1195 
1196     /**
1197      * @dev Returns the value associated with `key`.  O(1).
1198      *
1199      * Requirements:
1200      *
1201      * - `key` must be in the map.
1202      */
1203     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1204         uint256 keyIndex = map._indexes[key];
1205         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1206         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1207     }
1208 
1209     /**
1210      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1211      *
1212      * CAUTION: This function is deprecated because it requires allocating memory for the error
1213      * message unnecessarily. For custom revert reasons use {_tryGet}.
1214      */
1215     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1216         uint256 keyIndex = map._indexes[key];
1217         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1218         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1219     }
1220 
1221     // UintToAddressMap
1222 
1223     struct UintToAddressMap {
1224         Map _inner;
1225     }
1226 
1227     /**
1228      * @dev Adds a key-value pair to a map, or updates the value for an existing
1229      * key. O(1).
1230      *
1231      * Returns true if the key was added to the map, that is if it was not
1232      * already present.
1233      */
1234     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1235         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1236     }
1237 
1238     /**
1239      * @dev Removes a value from a set. O(1).
1240      *
1241      * Returns true if the key was removed from the map, that is if it was present.
1242      */
1243     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1244         return _remove(map._inner, bytes32(key));
1245     }
1246 
1247     /**
1248      * @dev Returns true if the key is in the map. O(1).
1249      */
1250     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1251         return _contains(map._inner, bytes32(key));
1252     }
1253 
1254     /**
1255      * @dev Returns the number of elements in the map. O(1).
1256      */
1257     function length(UintToAddressMap storage map) internal view returns (uint256) {
1258         return _length(map._inner);
1259     }
1260 
1261    /**
1262     * @dev Returns the element stored at position `index` in the set. O(1).
1263     * Note that there are no guarantees on the ordering of values inside the
1264     * array, and it may change when more values are added or removed.
1265     *
1266     * Requirements:
1267     *
1268     * - `index` must be strictly less than {length}.
1269     */
1270     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1271         (bytes32 key, bytes32 value) = _at(map._inner, index);
1272         return (uint256(key), address(uint160(uint256(value))));
1273     }
1274 
1275     /**
1276      * @dev Tries to returns the value associated with `key`.  O(1).
1277      * Does not revert if `key` is not in the map.
1278      *
1279      * _Available since v3.4._
1280      */
1281     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1282         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1283         return (success, address(uint160(uint256(value))));
1284     }
1285 
1286     /**
1287      * @dev Returns the value associated with `key`.  O(1).
1288      *
1289      * Requirements:
1290      *
1291      * - `key` must be in the map.
1292      */
1293     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1294         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1295     }
1296 
1297     /**
1298      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1299      *
1300      * CAUTION: This function is deprecated because it requires allocating memory for the error
1301      * message unnecessarily. For custom revert reasons use {tryGet}.
1302      */
1303     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1304         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1305     }
1306 }
1307 
1308 // File: @openzeppelin/contracts/utils/Strings.sol
1309 
1310 
1311 
1312 pragma solidity >=0.6.0 <0.8.0;
1313 
1314 /**
1315  * @dev String operations.
1316  */
1317 library Strings {
1318     /**
1319      * @dev Converts a `uint256` to its ASCII `string` representation.
1320      */
1321     function toString(uint256 value) internal pure returns (string memory) {
1322         // Inspired by OraclizeAPI's implementation - MIT licence
1323         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1324 
1325         if (value == 0) {
1326             return "0";
1327         }
1328         uint256 temp = value;
1329         uint256 digits;
1330         while (temp != 0) {
1331             digits++;
1332             temp /= 10;
1333         }
1334         bytes memory buffer = new bytes(digits);
1335         uint256 index = digits - 1;
1336         temp = value;
1337         while (temp != 0) {
1338             buffer[index--] = bytes1(uint8(48 + temp % 10));
1339             temp /= 10;
1340         }
1341         return string(buffer);
1342     }
1343 }
1344 
1345 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1346 
1347 
1348 
1349 pragma solidity >=0.6.0 <0.8.0;
1350 
1351 
1352 
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 
1362 /**
1363  * @title ERC721 Non-Fungible Token Standard basic implementation
1364  * @dev see https://eips.ethereum.org/EIPS/eip-721
1365  */
1366 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1367     using SafeMath for uint256;
1368     using Address for address;
1369     using EnumerableSet for EnumerableSet.UintSet;
1370     using EnumerableMap for EnumerableMap.UintToAddressMap;
1371     using Strings for uint256;
1372 
1373     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1374     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1375     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1376 
1377     // Mapping from holder address to their (enumerable) set of owned tokens
1378     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1379 
1380     // Enumerable mapping from token ids to their owners
1381     EnumerableMap.UintToAddressMap private _tokenOwners;
1382 
1383     // Mapping from token ID to approved address
1384     mapping (uint256 => address) private _tokenApprovals;
1385 
1386     // Mapping from owner to operator approvals
1387     mapping (address => mapping (address => bool)) private _operatorApprovals;
1388 
1389     // Token name
1390     string private _name;
1391 
1392     // Token symbol
1393     string private _symbol;
1394 
1395     // Optional mapping for token URIs
1396     mapping (uint256 => string) private _tokenURIs;
1397 
1398     // Base URI
1399     string private _baseURI;
1400 
1401     /*
1402      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1403      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1404      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1405      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1406      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1407      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1408      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1409      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1410      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1411      *
1412      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1413      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1414      */
1415     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1416 
1417     /*
1418      *     bytes4(keccak256('name()')) == 0x06fdde03
1419      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1420      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1421      *
1422      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1423      */
1424     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1425 
1426     /*
1427      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1428      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1429      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1430      *
1431      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1432      */
1433     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1434 
1435     /**
1436      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1437      */
1438     constructor (string memory name_, string memory symbol_)  {
1439         _name = name_;
1440         _symbol = symbol_;
1441 
1442         // register the supported interfaces to conform to ERC721 via ERC165
1443         _registerInterface(_INTERFACE_ID_ERC721);
1444         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1445         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1446     }
1447 
1448     /**
1449      * @dev See {IERC721-balanceOf}.
1450      */
1451     function balanceOf(address owner) public view virtual override returns (uint256) {
1452         require(owner != address(0), "ERC721: balance query for the zero address");
1453         return _holderTokens[owner].length();
1454     }
1455 
1456     /**
1457      * @dev See {IERC721-ownerOf}.
1458      */
1459     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1460         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Metadata-name}.
1465      */
1466     function name() public view virtual override returns (string memory) {
1467         return _name;
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Metadata-symbol}.
1472      */
1473     function symbol() public view virtual override returns (string memory) {
1474         return _symbol;
1475     }
1476 
1477     
1478    	function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1479 		require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1480 		return string(abi.encodePacked(_baseURI, _tokenId.toString(), ".json"));
1481 	}
1482 
1483     /**
1484     * @dev Returns the base URI set via {_setBaseURI}. This will be
1485     * automatically added as a prefix in {tokenURI} to each token's URI, or
1486     * to the token ID if no specific URI is set for that token ID.
1487     */
1488     function baseURI() public view virtual returns (string memory) {
1489         return _baseURI;
1490     }
1491 
1492     /**
1493      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1494      */
1495     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1496         return _holderTokens[owner].at(index);
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Enumerable-totalSupply}.
1501      */
1502     function totalSupply() public view virtual override returns (uint256) {
1503         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1504         return _tokenOwners.length();
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Enumerable-tokenByIndex}.
1509      */
1510     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1511         (uint256 tokenId, ) = _tokenOwners.at(index);
1512         return tokenId;
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-approve}.
1517      */
1518     function approve(address to, uint256 tokenId) public virtual override {
1519         address owner = ERC721.ownerOf(tokenId);
1520         require(to != owner, "ERC721: approval to current owner");
1521 
1522         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1523             "ERC721: approve caller is not owner nor approved for all"
1524         );
1525 
1526         _approve(to, tokenId);
1527     }
1528 
1529     /**
1530      * @dev See {IERC721-getApproved}.
1531      */
1532     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1533         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1534 
1535         return _tokenApprovals[tokenId];
1536     }
1537 
1538     /**
1539      * @dev See {IERC721-setApprovalForAll}.
1540      */
1541     function setApprovalForAll(address operator, bool approved) public virtual override {
1542         require(operator != _msgSender(), "ERC721: approve to caller");
1543 
1544         _operatorApprovals[_msgSender()][operator] = approved;
1545         emit ApprovalForAll(_msgSender(), operator, approved);
1546     }
1547 
1548     /**
1549      * @dev See {IERC721-isApprovedForAll}.
1550      */
1551     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1552         return _operatorApprovals[owner][operator];
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-transferFrom}.
1557      */
1558     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1559         //solhint-disable-next-line max-line-length
1560         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1561 
1562         _transfer(from, to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev See {IERC721-safeTransferFrom}.
1567      */
1568     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1569         safeTransferFrom(from, to, tokenId, "");
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-safeTransferFrom}.
1574      */
1575     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1576         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1577         _safeTransfer(from, to, tokenId, _data);
1578     }
1579 
1580     /**
1581      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1582      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1583      *
1584      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1585      *
1586      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1587      * implement alternative mechanisms to perform token transfer, such as signature-based.
1588      *
1589      * Requirements:
1590      *
1591      * - `from` cannot be the zero address.
1592      * - `to` cannot be the zero address.
1593      * - `tokenId` token must exist and be owned by `from`.
1594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1595      *
1596      * Emits a {Transfer} event.
1597      */
1598     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1599         _transfer(from, to, tokenId);
1600         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1601     }
1602 
1603     /**
1604      * @dev Returns whether `tokenId` exists.
1605      *
1606      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1607      *
1608      * Tokens start existing when they are minted (`_mint`),
1609      * and stop existing when they are burned (`_burn`).
1610      */
1611     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1612         return _tokenOwners.contains(tokenId);
1613     }
1614 
1615     /**
1616      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1617      *
1618      * Requirements:
1619      *
1620      * - `tokenId` must exist.
1621      */
1622     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1623         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1624         address owner = ERC721.ownerOf(tokenId);
1625         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1626     }
1627 
1628     /**
1629      * @dev Safely mints `tokenId` and transfers it to `to`.
1630      *
1631      * Requirements:
1632      d*
1633      * - `tokenId` must not exist.
1634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1635      *
1636      * Emits a {Transfer} event.
1637      */
1638     function _safeMint(address to, uint256 tokenId) internal virtual {
1639         _safeMint(to, tokenId, "");
1640     }
1641 
1642     /**
1643      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1644      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1645      */
1646     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1647         _mint(to, tokenId);
1648         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1649     }
1650 
1651     /**
1652      * @dev Mints `tokenId` and transfers it to `to`.
1653      *
1654      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1655      *
1656      * Requirements:
1657      *
1658      * - `tokenId` must not exist.
1659      * - `to` cannot be the zero address.
1660      *
1661      * Emits a {Transfer} event.
1662      */
1663     function _mint(address to, uint256 tokenId) internal virtual {
1664         require(to != address(0), "ERC721: mint to the zero address");
1665         require(!_exists(tokenId), "ERC721: token already minted");
1666 
1667         _beforeTokenTransfer(address(0), to, tokenId);
1668         _holderTokens[to].add(tokenId);
1669         _tokenOwners.set(tokenId, to);
1670 
1671         emit Transfer(address(0), to, tokenId);
1672     }
1673 
1674     /**
1675      * @dev Destroys `tokenId`.
1676      * The approval is cleared when the token is burned.
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must exist.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function _burn(uint256 tokenId) internal virtual {
1685         address owner = ERC721.ownerOf(tokenId); // internal owner
1686 
1687         _beforeTokenTransfer(owner, address(0), tokenId);
1688 
1689         // Clear approvals
1690         _approve(address(0), tokenId);
1691 
1692         // Clear metadata (if any)
1693         if (bytes(_tokenURIs[tokenId]).length != 0) {
1694             delete _tokenURIs[tokenId];
1695         }
1696 
1697         _holderTokens[owner].remove(tokenId);
1698 
1699         _tokenOwners.remove(tokenId);
1700 
1701         emit Transfer(owner, address(0), tokenId);
1702     }
1703 
1704     /**
1705      * @dev Transfers `tokenId` from `from` to `to`.
1706      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1707      *
1708      * Requirements:
1709      *
1710      * - `to` cannot be the zero address.
1711      * - `tokenId` token must be owned by `from`.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1716         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1717         require(to != address(0), "ERC721: transfer to the zero address");
1718 
1719         _beforeTokenTransfer(from, to, tokenId);
1720 
1721         // Clear approvals from the previous owner
1722         _approve(address(0), tokenId);
1723 
1724         _holderTokens[from].remove(tokenId);
1725         _holderTokens[to].add(tokenId);
1726 
1727         _tokenOwners.set(tokenId, to);
1728 
1729         emit Transfer(from, to, tokenId);
1730     }
1731 
1732     /**
1733      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1734      *
1735      * Requirements:
1736      *
1737      * - `tokenId` must exist.
1738      */
1739     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1740         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1741         _tokenURIs[tokenId] = _tokenURI;
1742     }
1743 
1744     /**
1745      * @dev Internal function to set the base URI for all token IDs. It is
1746      * automatically added as a prefix to the value returned in {tokenURI},
1747      * or to the token ID if {tokenURI} is empty.
1748      */
1749     function _setBaseURI(string memory baseURI_) internal virtual {
1750         _baseURI = baseURI_;
1751     }
1752 
1753     /**
1754      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1755      * The call is not executed if the target address is not a contract.
1756      *
1757      * @param from address representing the previous owner of the given token ID
1758      * @param to target address that will receive the tokens
1759      * @param tokenId uint256 ID of the token to be transferred
1760      * @param _data bytes optional data to send along with the call
1761      * @return bool whether the call correctly returned the expected magic value
1762      */
1763     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1764         private returns (bool)
1765     {
1766         if (!to.isContract()) {
1767             return true;
1768         }
1769         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1770             IERC721Receiver(to).onERC721Received.selector,
1771             _msgSender(),
1772             from,
1773             tokenId,
1774             _data
1775         ), "ERC721: transfer to non ERC721Receiver implementer");
1776         bytes4 retval = abi.decode(returndata, (bytes4));
1777         return (retval == _ERC721_RECEIVED);
1778     }
1779 
1780     /**
1781      * @dev Approve `to` to operate on `tokenId`
1782      *
1783      * Emits an {Approval} event.
1784      */
1785     function _approve(address to, uint256 tokenId) internal virtual {
1786         _tokenApprovals[tokenId] = to;
1787         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1788     }
1789 
1790     /**
1791      * @dev Hook that is called before any token transfer. This includes minting
1792      * and burning.
1793      *
1794      * Calling conditions:
1795      *
1796      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1797      * transferred to `to`.
1798      * - When `from` is zero, `tokenId` will be minted for `to`.
1799      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1800      * - `from` cannot be the zero address.
1801      * - `to` cannot be the zero address.
1802      *
1803      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1804      */
1805     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1806 }
1807 
1808 // File: @openzeppelin/contracts/access/Ownable.sol
1809 
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
1834     constructor ()  {
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
1878 
1879 
1880 pragma solidity ^0.7.0;
1881 
1882 
1883 contract KangarooHeroesV2 is ERC721, Ownable {
1884 
1885     using SafeMath for uint256;
1886     using Strings for uint256;
1887 
1888 
1889 
1890 
1891     uint256 public  kangarooHeroesPrice = 0.07 ether; //0.07 ETH
1892 
1893     uint public  maxKangarooHeroesPerWallet = 5;
1894     
1895     address public companyWallet;
1896 
1897     uint256 public MAX_KANGAROO_HEROES = 3600;
1898 
1899     bool public saleIsActive = false;
1900 
1901     uint256 public totalCompanyClaimed;
1902 
1903     mapping(uint256 => bool) public isReserved;
1904 
1905     string public reservedURI;
1906 
1907 
1908     bool public isRevealed;
1909     string public placeholder = "ipfs://QmQrGNUwXPJVRtW81xwvtoGUK7xsBjHc8a3iUSqoLVw1gf";
1910 
1911     constructor(address _companyWallet) ERC721("KangarooHeroesV2", "KangarooHeroesV2") {
1912         companyWallet = _companyWallet;
1913     }
1914 
1915 
1916 
1917     function claimCompanyReserve(uint256 noOfItems) public onlyOwner{
1918         require(noOfItems.add(totalCompanyClaimed) <=511,"Max Claim for Company Exceeds");
1919         for(uint256 i=0;i< noOfItems;i++){
1920             uint mintIndex = totalSupply();
1921             _mint(msg.sender,mintIndex);
1922             isReserved[mintIndex] = true;
1923         }
1924         totalCompanyClaimed = totalCompanyClaimed.add(noOfItems);
1925     }
1926 
1927 
1928     function setPrice(uint256 _price)public onlyOwner{
1929         kangarooHeroesPrice = _price;
1930     }
1931 
1932 
1933     
1934     function setPlaceholder(string memory _placeholder)public onlyOwner{
1935         placeholder = _placeholder;
1936     }
1937 
1938 
1939     function withdraw() public onlyOwner {
1940         uint balance = address(this).balance;
1941         msg.sender.transfer(balance);
1942     }
1943 
1944     function setRevealed(bool _isRevealed) public onlyOwner {
1945        isRevealed = _isRevealed;
1946     }
1947 
1948 
1949     function setURIs(string memory baseURI) public onlyOwner {
1950         _setBaseURI(baseURI);
1951     }
1952 
1953 
1954     function setReserveURI(string memory uri) public onlyOwner {
1955        reservedURI = uri;
1956     }
1957 
1958     /*
1959     * Pause sale if active, make active if paused
1960     */
1961     function flipSaleState() public onlyOwner {
1962         saleIsActive = !saleIsActive;
1963     }
1964 
1965 
1966     function setMaxKangarooHeroesPerWallet(uint num) public onlyOwner {
1967       maxKangarooHeroesPerWallet = num;
1968     }
1969 
1970   
1971     function mint(uint numberOfTokens) public payable {
1972         require(numberOfTokens> 0, "invalid no of tokens");
1973         require(saleIsActive, "Sale must be active to mint KangarooHeroes");
1974         require(totalSupply().add(numberOfTokens) <= MAX_KANGAROO_HEROES, "Purchase would exceed max supply of KangarooHeroes");
1975         require(balanceOf(msg.sender).add(numberOfTokens) <= maxKangarooHeroesPerWallet, "Max Hold Limit Exceeds");
1976         require(numberOfTokens.mul(kangarooHeroesPrice) <= msg.value, "Invalid Ether Amount");
1977 
1978         for(uint i = 0; i < numberOfTokens; i++) {
1979            _mintKangarooHeroes(msg.sender);
1980         }
1981 
1982         uint256 bal = address(this).balance;
1983         payable(companyWallet).transfer(bal);
1984     }
1985 
1986     function _mintKangarooHeroes(address to) internal {
1987          uint mintIndex = totalSupply();
1988         _safeMint(to, mintIndex);
1989     }
1990     
1991 
1992 
1993 
1994  	function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1995 		require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1996 
1997         if(!isRevealed){
1998             return placeholder;
1999         }
2000 
2001         if(isReserved[_tokenId]){
2002             return string(abi.encodePacked(reservedURI, _tokenId.toString(), ".json"));
2003         }
2004         return string(abi.encodePacked(baseURI(), _tokenId.toString(), ".json"));
2005 	}
2006 
2007 
2008 
2009     
2010 }