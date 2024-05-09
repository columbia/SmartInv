1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/introspection/IERC165.sol
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
52 
53 
54 
55 pragma solidity >=0.6.2 <0.8.0;
56 
57 
58 /**
59  * @dev Required interface of an ERC721 compliant contract.
60  */
61 interface IERC721 is IERC165 {
62     /**
63      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
66 
67     /**
68      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
69      */
70     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
71 
72     /**
73      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
74      */
75     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
76 
77     /**
78      * @dev Returns the number of tokens in ``owner``'s account.
79      */
80     function balanceOf(address owner) external view returns (uint256 balance);
81 
82     /**
83      * @dev Returns the owner of the `tokenId` token.
84      *
85      * Requirements:
86      *
87      * - `tokenId` must exist.
88      */
89     function ownerOf(uint256 tokenId) external view returns (address owner);
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(address from, address to, uint256 tokenId) external;
106 
107     /**
108      * @dev Transfers `tokenId` token from `from` to `to`.
109      *
110      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(address from, address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
125      * The approval is cleared when the token is transferred.
126      *
127      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
128      *
129      * Requirements:
130      *
131      * - The caller must own the token or be an approved operator.
132      * - `tokenId` must exist.
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Returns the account approved for `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function getApproved(uint256 tokenId) external view returns (address operator);
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator) external view returns (bool);
165 
166     /**
167       * @dev Safely transfers `tokenId` token from `from` to `to`.
168       *
169       * Requirements:
170       *
171       * - `from` cannot be the zero address.
172       * - `to` cannot be the zero address.
173       * - `tokenId` token must exist and be owned by `from`.
174       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176       *
177       * Emits a {Transfer} event.
178       */
179     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
180 }
181 
182 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
183 
184 
185 
186 pragma solidity >=0.6.2 <0.8.0;
187 
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194 
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
212 
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
245 
246 pragma solidity >=0.6.0 <0.8.0;
247 
248 /**
249  * @title ERC721 token receiver interface
250  * @dev Interface for any contract that wants to support safeTransfers
251  * from ERC721 asset contracts.
252  */
253 interface IERC721Receiver {
254     /**
255      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
256      * by `operator` from `from`, this function is called.
257      *
258      * It must return its Solidity selector to confirm the token transfer.
259      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
260      *
261      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
262      */
263     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
264 }
265 
266 // File: @openzeppelin/contracts/introspection/ERC165.sol
267 
268 
269 
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 
273 /**
274  * @dev Implementation of the {IERC165} interface.
275  *
276  * Contracts may inherit from this and call {_registerInterface} to declare
277  * their support of an interface.
278  */
279 abstract contract ERC165 is IERC165 {
280     /*
281      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
282      */
283     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
284 
285     /**
286      * @dev Mapping of interface ids to whether or not it's supported.
287      */
288     mapping(bytes4 => bool) private _supportedInterfaces;
289 
290     constructor () internal {
291         // Derived contracts need only register support for their own interfaces,
292         // we register support for ERC165 itself here
293         _registerInterface(_INTERFACE_ID_ERC165);
294     }
295 
296     /**
297      * @dev See {IERC165-supportsInterface}.
298      *
299      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
300      */
301     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302         return _supportedInterfaces[interfaceId];
303     }
304 
305     /**
306      * @dev Registers the contract as an implementer of the interface defined by
307      * `interfaceId`. Support of the actual ERC165 interface is automatic and
308      * registering its interface id is not required.
309      *
310      * See {IERC165-supportsInterface}.
311      *
312      * Requirements:
313      *
314      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
315      */
316     function _registerInterface(bytes4 interfaceId) internal virtual {
317         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
318         _supportedInterfaces[interfaceId] = true;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/math/SafeMath.sol
323 
324 
325 
326 pragma solidity >=0.6.0 <0.8.0;
327 
328 /**
329  * @dev Wrappers over Solidity's arithmetic operations with added overflow
330  * checks.
331  *
332  * Arithmetic operations in Solidity wrap on overflow. This can easily result
333  * in bugs, because programmers usually assume that an overflow raises an
334  * error, which is the standard behavior in high level programming languages.
335  * `SafeMath` restores this intuition by reverting the transaction when an
336  * operation overflows.
337  *
338  * Using this library instead of the unchecked operations eliminates an entire
339  * class of bugs, so it's recommended to use it always.
340  */
341 library SafeMath {
342     /**
343      * @dev Returns the addition of two unsigned integers, with an overflow flag.
344      *
345      * _Available since v3.4._
346      */
347     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
348         uint256 c = a + b;
349         if (c < a) return (false, 0);
350         return (true, c);
351     }
352 
353     /**
354      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
355      *
356      * _Available since v3.4._
357      */
358     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
359         if (b > a) return (false, 0);
360         return (true, a - b);
361     }
362 
363     /**
364      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
365      *
366      * _Available since v3.4._
367      */
368     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
369         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
370         // benefit is lost if 'b' is also tested.
371         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
372         if (a == 0) return (true, 0);
373         uint256 c = a * b;
374         if (c / a != b) return (false, 0);
375         return (true, c);
376     }
377 
378     /**
379      * @dev Returns the division of two unsigned integers, with a division by zero flag.
380      *
381      * _Available since v3.4._
382      */
383     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384         if (b == 0) return (false, 0);
385         return (true, a / b);
386     }
387 
388     /**
389      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         if (b == 0) return (false, 0);
395         return (true, a % b);
396     }
397 
398     /**
399      * @dev Returns the addition of two unsigned integers, reverting on
400      * overflow.
401      *
402      * Counterpart to Solidity's `+` operator.
403      *
404      * Requirements:
405      *
406      * - Addition cannot overflow.
407      */
408     function add(uint256 a, uint256 b) internal pure returns (uint256) {
409         uint256 c = a + b;
410         require(c >= a, "SafeMath: addition overflow");
411         return c;
412     }
413 
414     /**
415      * @dev Returns the subtraction of two unsigned integers, reverting on
416      * overflow (when the result is negative).
417      *
418      * Counterpart to Solidity's `-` operator.
419      *
420      * Requirements:
421      *
422      * - Subtraction cannot overflow.
423      */
424     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
425         require(b <= a, "SafeMath: subtraction overflow");
426         return a - b;
427     }
428 
429     /**
430      * @dev Returns the multiplication of two unsigned integers, reverting on
431      * overflow.
432      *
433      * Counterpart to Solidity's `*` operator.
434      *
435      * Requirements:
436      *
437      * - Multiplication cannot overflow.
438      */
439     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
440         if (a == 0) return 0;
441         uint256 c = a * b;
442         require(c / a == b, "SafeMath: multiplication overflow");
443         return c;
444     }
445 
446     /**
447      * @dev Returns the integer division of two unsigned integers, reverting on
448      * division by zero. The result is rounded towards zero.
449      *
450      * Counterpart to Solidity's `/` operator. Note: this function uses a
451      * `revert` opcode (which leaves remaining gas untouched) while Solidity
452      * uses an invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function div(uint256 a, uint256 b) internal pure returns (uint256) {
459         require(b > 0, "SafeMath: division by zero");
460         return a / b;
461     }
462 
463     /**
464      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
465      * reverting when dividing by zero.
466      *
467      * Counterpart to Solidity's `%` operator. This function uses a `revert`
468      * opcode (which leaves remaining gas untouched) while Solidity uses an
469      * invalid opcode to revert (consuming all remaining gas).
470      *
471      * Requirements:
472      *
473      * - The divisor cannot be zero.
474      */
475     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
476         require(b > 0, "SafeMath: modulo by zero");
477         return a % b;
478     }
479 
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
482      * overflow (when the result is negative).
483      *
484      * CAUTION: This function is deprecated because it requires allocating memory for the error
485      * message unnecessarily. For custom revert reasons use {trySub}.
486      *
487      * Counterpart to Solidity's `-` operator.
488      *
489      * Requirements:
490      *
491      * - Subtraction cannot overflow.
492      */
493     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
494         require(b <= a, errorMessage);
495         return a - b;
496     }
497 
498     /**
499      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
500      * division by zero. The result is rounded towards zero.
501      *
502      * CAUTION: This function is deprecated because it requires allocating memory for the error
503      * message unnecessarily. For custom revert reasons use {tryDiv}.
504      *
505      * Counterpart to Solidity's `/` operator. Note: this function uses a
506      * `revert` opcode (which leaves remaining gas untouched) while Solidity
507      * uses an invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
514         require(b > 0, errorMessage);
515         return a / b;
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * reverting with custom message when dividing by zero.
521      *
522      * CAUTION: This function is deprecated because it requires allocating memory for the error
523      * message unnecessarily. For custom revert reasons use {tryMod}.
524      *
525      * Counterpart to Solidity's `%` operator. This function uses a `revert`
526      * opcode (which leaves remaining gas untouched) while Solidity uses an
527      * invalid opcode to revert (consuming all remaining gas).
528      *
529      * Requirements:
530      *
531      * - The divisor cannot be zero.
532      */
533     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
534         require(b > 0, errorMessage);
535         return a % b;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/utils/Address.sol
540 
541 
542 
543 pragma solidity >=0.6.2 <0.8.0;
544 
545 /**
546  * @dev Collection of functions related to the address type
547  */
548 library Address {
549     /**
550      * @dev Returns true if `account` is a contract.
551      *
552      * [IMPORTANT]
553      * ====
554      * It is unsafe to assume that an address for which this function returns
555      * false is an externally-owned account (EOA) and not a contract.
556      *
557      * Among others, `isContract` will return false for the following
558      * types of addresses:
559      *
560      *  - an externally-owned account
561      *  - a contract in construction
562      *  - an address where a contract will be created
563      *  - an address where a contract lived, but was destroyed
564      * ====
565      */
566     function isContract(address account) internal view returns (bool) {
567         // This method relies on extcodesize, which returns 0 for contracts in
568         // construction, since the code is only stored at the end of the
569         // constructor execution.
570 
571         uint256 size;
572         // solhint-disable-next-line no-inline-assembly
573         assembly { size := extcodesize(account) }
574         return size > 0;
575     }
576 
577     /**
578      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
579      * `recipient`, forwarding all available gas and reverting on errors.
580      *
581      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
582      * of certain opcodes, possibly making contracts go over the 2300 gas limit
583      * imposed by `transfer`, making them unable to receive funds via
584      * `transfer`. {sendValue} removes this limitation.
585      *
586      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
587      *
588      * IMPORTANT: because control is transferred to `recipient`, care must be
589      * taken to not create reentrancy vulnerabilities. Consider using
590      * {ReentrancyGuard} or the
591      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
592      */
593     function sendValue(address payable recipient, uint256 amount) internal {
594         require(address(this).balance >= amount, "Address: insufficient balance");
595 
596         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
597         (bool success, ) = recipient.call{ value: amount }("");
598         require(success, "Address: unable to send value, recipient may have reverted");
599     }
600 
601     /**
602      * @dev Performs a Solidity function call using a low level `call`. A
603      * plain`call` is an unsafe replacement for a function call: use this
604      * function instead.
605      *
606      * If `target` reverts with a revert reason, it is bubbled up by this
607      * function (like regular Solidity function calls).
608      *
609      * Returns the raw returned data. To convert to the expected return value,
610      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
611      *
612      * Requirements:
613      *
614      * - `target` must be a contract.
615      * - calling `target` with `data` must not revert.
616      *
617      * _Available since v3.1._
618      */
619     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
620       return functionCall(target, data, "Address: low-level call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
625      * `errorMessage` as a fallback revert reason when `target` reverts.
626      *
627      * _Available since v3.1._
628      */
629     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
630         return functionCallWithValue(target, data, 0, errorMessage);
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
635      * but also transferring `value` wei to `target`.
636      *
637      * Requirements:
638      *
639      * - the calling contract must have an ETH balance of at least `value`.
640      * - the called Solidity function must be `payable`.
641      *
642      * _Available since v3.1._
643      */
644     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
645         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
650      * with `errorMessage` as a fallback revert reason when `target` reverts.
651      *
652      * _Available since v3.1._
653      */
654     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
655         require(address(this).balance >= value, "Address: insufficient balance for call");
656         require(isContract(target), "Address: call to non-contract");
657 
658         // solhint-disable-next-line avoid-low-level-calls
659         (bool success, bytes memory returndata) = target.call{ value: value }(data);
660         return _verifyCallResult(success, returndata, errorMessage);
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
665      * but performing a static call.
666      *
667      * _Available since v3.3._
668      */
669     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
670         return functionStaticCall(target, data, "Address: low-level static call failed");
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
675      * but performing a static call.
676      *
677      * _Available since v3.3._
678      */
679     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
680         require(isContract(target), "Address: static call to non-contract");
681 
682         // solhint-disable-next-line avoid-low-level-calls
683         (bool success, bytes memory returndata) = target.staticcall(data);
684         return _verifyCallResult(success, returndata, errorMessage);
685     }
686 
687     /**
688      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
689      * but performing a delegate call.
690      *
691      * _Available since v3.4._
692      */
693     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
694         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
699      * but performing a delegate call.
700      *
701      * _Available since v3.4._
702      */
703     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
704         require(isContract(target), "Address: delegate call to non-contract");
705 
706         // solhint-disable-next-line avoid-low-level-calls
707         (bool success, bytes memory returndata) = target.delegatecall(data);
708         return _verifyCallResult(success, returndata, errorMessage);
709     }
710 
711     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
712         if (success) {
713             return returndata;
714         } else {
715             // Look for revert reason and bubble it up if present
716             if (returndata.length > 0) {
717                 // The easiest way to bubble the revert reason is using memory via assembly
718 
719                 // solhint-disable-next-line no-inline-assembly
720                 assembly {
721                     let returndata_size := mload(returndata)
722                     revert(add(32, returndata), returndata_size)
723                 }
724             } else {
725                 revert(errorMessage);
726             }
727         }
728     }
729 }
730 
731 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
732 
733 
734 
735 pragma solidity >=0.6.0 <0.8.0;
736 
737 /**
738  * @dev Library for managing
739  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
740  * types.
741  *
742  * Sets have the following properties:
743  *
744  * - Elements are added, removed, and checked for existence in constant time
745  * (O(1)).
746  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
747  *
748  * ```
749  * contract Example {
750  *     // Add the library methods
751  *     using EnumerableSet for EnumerableSet.AddressSet;
752  *
753  *     // Declare a set state variable
754  *     EnumerableSet.AddressSet private mySet;
755  * }
756  * ```
757  *
758  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
759  * and `uint256` (`UintSet`) are supported.
760  */
761 library EnumerableSet {
762     // To implement this library for multiple types with as little code
763     // repetition as possible, we write it in terms of a generic Set type with
764     // bytes32 values.
765     // The Set implementation uses private functions, and user-facing
766     // implementations (such as AddressSet) are just wrappers around the
767     // underlying Set.
768     // This means that we can only create new EnumerableSets for types that fit
769     // in bytes32.
770 
771     struct Set {
772         // Storage of set values
773         bytes32[] _values;
774 
775         // Position of the value in the `values` array, plus 1 because index 0
776         // means a value is not in the set.
777         mapping (bytes32 => uint256) _indexes;
778     }
779 
780     /**
781      * @dev Add a value to a set. O(1).
782      *
783      * Returns true if the value was added to the set, that is if it was not
784      * already present.
785      */
786     function _add(Set storage set, bytes32 value) private returns (bool) {
787         if (!_contains(set, value)) {
788             set._values.push(value);
789             // The value is stored at length-1, but we add 1 to all indexes
790             // and use 0 as a sentinel value
791             set._indexes[value] = set._values.length;
792             return true;
793         } else {
794             return false;
795         }
796     }
797 
798     /**
799      * @dev Removes a value from a set. O(1).
800      *
801      * Returns true if the value was removed from the set, that is if it was
802      * present.
803      */
804     function _remove(Set storage set, bytes32 value) private returns (bool) {
805         // We read and store the value's index to prevent multiple reads from the same storage slot
806         uint256 valueIndex = set._indexes[value];
807 
808         if (valueIndex != 0) { // Equivalent to contains(set, value)
809             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
810             // the array, and then remove the last element (sometimes called as 'swap and pop').
811             // This modifies the order of the array, as noted in {at}.
812 
813             uint256 toDeleteIndex = valueIndex - 1;
814             uint256 lastIndex = set._values.length - 1;
815 
816             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
817             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
818 
819             bytes32 lastvalue = set._values[lastIndex];
820 
821             // Move the last value to the index where the value to delete is
822             set._values[toDeleteIndex] = lastvalue;
823             // Update the index for the moved value
824             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
825 
826             // Delete the slot where the moved value was stored
827             set._values.pop();
828 
829             // Delete the index for the deleted slot
830             delete set._indexes[value];
831 
832             return true;
833         } else {
834             return false;
835         }
836     }
837 
838     /**
839      * @dev Returns true if the value is in the set. O(1).
840      */
841     function _contains(Set storage set, bytes32 value) private view returns (bool) {
842         return set._indexes[value] != 0;
843     }
844 
845     /**
846      * @dev Returns the number of values on the set. O(1).
847      */
848     function _length(Set storage set) private view returns (uint256) {
849         return set._values.length;
850     }
851 
852    /**
853     * @dev Returns the value stored at position `index` in the set. O(1).
854     *
855     * Note that there are no guarantees on the ordering of values inside the
856     * array, and it may change when more values are added or removed.
857     *
858     * Requirements:
859     *
860     * - `index` must be strictly less than {length}.
861     */
862     function _at(Set storage set, uint256 index) private view returns (bytes32) {
863         require(set._values.length > index, "EnumerableSet: index out of bounds");
864         return set._values[index];
865     }
866 
867     // Bytes32Set
868 
869     struct Bytes32Set {
870         Set _inner;
871     }
872 
873     /**
874      * @dev Add a value to a set. O(1).
875      *
876      * Returns true if the value was added to the set, that is if it was not
877      * already present.
878      */
879     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
880         return _add(set._inner, value);
881     }
882 
883     /**
884      * @dev Removes a value from a set. O(1).
885      *
886      * Returns true if the value was removed from the set, that is if it was
887      * present.
888      */
889     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
890         return _remove(set._inner, value);
891     }
892 
893     /**
894      * @dev Returns true if the value is in the set. O(1).
895      */
896     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
897         return _contains(set._inner, value);
898     }
899 
900     /**
901      * @dev Returns the number of values in the set. O(1).
902      */
903     function length(Bytes32Set storage set) internal view returns (uint256) {
904         return _length(set._inner);
905     }
906 
907    /**
908     * @dev Returns the value stored at position `index` in the set. O(1).
909     *
910     * Note that there are no guarantees on the ordering of values inside the
911     * array, and it may change when more values are added or removed.
912     *
913     * Requirements:
914     *
915     * - `index` must be strictly less than {length}.
916     */
917     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
918         return _at(set._inner, index);
919     }
920 
921     // AddressSet
922 
923     struct AddressSet {
924         Set _inner;
925     }
926 
927     /**
928      * @dev Add a value to a set. O(1).
929      *
930      * Returns true if the value was added to the set, that is if it was not
931      * already present.
932      */
933     function add(AddressSet storage set, address value) internal returns (bool) {
934         return _add(set._inner, bytes32(uint256(uint160(value))));
935     }
936 
937     /**
938      * @dev Removes a value from a set. O(1).
939      *
940      * Returns true if the value was removed from the set, that is if it was
941      * present.
942      */
943     function remove(AddressSet storage set, address value) internal returns (bool) {
944         return _remove(set._inner, bytes32(uint256(uint160(value))));
945     }
946 
947     /**
948      * @dev Returns true if the value is in the set. O(1).
949      */
950     function contains(AddressSet storage set, address value) internal view returns (bool) {
951         return _contains(set._inner, bytes32(uint256(uint160(value))));
952     }
953 
954     /**
955      * @dev Returns the number of values in the set. O(1).
956      */
957     function length(AddressSet storage set) internal view returns (uint256) {
958         return _length(set._inner);
959     }
960 
961    /**
962     * @dev Returns the value stored at position `index` in the set. O(1).
963     *
964     * Note that there are no guarantees on the ordering of values inside the
965     * array, and it may change when more values are added or removed.
966     *
967     * Requirements:
968     *
969     * - `index` must be strictly less than {length}.
970     */
971     function at(AddressSet storage set, uint256 index) internal view returns (address) {
972         return address(uint160(uint256(_at(set._inner, index))));
973     }
974 
975 
976     // UintSet
977 
978     struct UintSet {
979         Set _inner;
980     }
981 
982     /**
983      * @dev Add a value to a set. O(1).
984      *
985      * Returns true if the value was added to the set, that is if it was not
986      * already present.
987      */
988     function add(UintSet storage set, uint256 value) internal returns (bool) {
989         return _add(set._inner, bytes32(value));
990     }
991 
992     /**
993      * @dev Removes a value from a set. O(1).
994      *
995      * Returns true if the value was removed from the set, that is if it was
996      * present.
997      */
998     function remove(UintSet storage set, uint256 value) internal returns (bool) {
999         return _remove(set._inner, bytes32(value));
1000     }
1001 
1002     /**
1003      * @dev Returns true if the value is in the set. O(1).
1004      */
1005     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1006         return _contains(set._inner, bytes32(value));
1007     }
1008 
1009     /**
1010      * @dev Returns the number of values on the set. O(1).
1011      */
1012     function length(UintSet storage set) internal view returns (uint256) {
1013         return _length(set._inner);
1014     }
1015 
1016    /**
1017     * @dev Returns the value stored at position `index` in the set. O(1).
1018     *
1019     * Note that there are no guarantees on the ordering of values inside the
1020     * array, and it may change when more values are added or removed.
1021     *
1022     * Requirements:
1023     *
1024     * - `index` must be strictly less than {length}.
1025     */
1026     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1027         return uint256(_at(set._inner, index));
1028     }
1029 }
1030 
1031 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1032 
1033 
1034 
1035 pragma solidity >=0.6.0 <0.8.0;
1036 
1037 /**
1038  * @dev Library for managing an enumerable variant of Solidity's
1039  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1040  * type.
1041  *
1042  * Maps have the following properties:
1043  *
1044  * - Entries are added, removed, and checked for existence in constant time
1045  * (O(1)).
1046  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1047  *
1048  * ```
1049  * contract Example {
1050  *     // Add the library methods
1051  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1052  *
1053  *     // Declare a set state variable
1054  *     EnumerableMap.UintToAddressMap private myMap;
1055  * }
1056  * ```
1057  *
1058  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1059  * supported.
1060  */
1061 library EnumerableMap {
1062     // To implement this library for multiple types with as little code
1063     // repetition as possible, we write it in terms of a generic Map type with
1064     // bytes32 keys and values.
1065     // The Map implementation uses private functions, and user-facing
1066     // implementations (such as Uint256ToAddressMap) are just wrappers around
1067     // the underlying Map.
1068     // This means that we can only create new EnumerableMaps for types that fit
1069     // in bytes32.
1070 
1071     struct MapEntry {
1072         bytes32 _key;
1073         bytes32 _value;
1074     }
1075 
1076     struct Map {
1077         // Storage of map keys and values
1078         MapEntry[] _entries;
1079 
1080         // Position of the entry defined by a key in the `entries` array, plus 1
1081         // because index 0 means a key is not in the map.
1082         mapping (bytes32 => uint256) _indexes;
1083     }
1084 
1085     /**
1086      * @dev Adds a key-value pair to a map, or updates the value for an existing
1087      * key. O(1).
1088      *
1089      * Returns true if the key was added to the map, that is if it was not
1090      * already present.
1091      */
1092     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1093         // We read and store the key's index to prevent multiple reads from the same storage slot
1094         uint256 keyIndex = map._indexes[key];
1095 
1096         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1097             map._entries.push(MapEntry({ _key: key, _value: value }));
1098             // The entry is stored at length-1, but we add 1 to all indexes
1099             // and use 0 as a sentinel value
1100             map._indexes[key] = map._entries.length;
1101             return true;
1102         } else {
1103             map._entries[keyIndex - 1]._value = value;
1104             return false;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Removes a key-value pair from a map. O(1).
1110      *
1111      * Returns true if the key was removed from the map, that is if it was present.
1112      */
1113     function _remove(Map storage map, bytes32 key) private returns (bool) {
1114         // We read and store the key's index to prevent multiple reads from the same storage slot
1115         uint256 keyIndex = map._indexes[key];
1116 
1117         if (keyIndex != 0) { // Equivalent to contains(map, key)
1118             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1119             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1120             // This modifies the order of the array, as noted in {at}.
1121 
1122             uint256 toDeleteIndex = keyIndex - 1;
1123             uint256 lastIndex = map._entries.length - 1;
1124 
1125             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1126             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1127 
1128             MapEntry storage lastEntry = map._entries[lastIndex];
1129 
1130             // Move the last entry to the index where the entry to delete is
1131             map._entries[toDeleteIndex] = lastEntry;
1132             // Update the index for the moved entry
1133             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1134 
1135             // Delete the slot where the moved entry was stored
1136             map._entries.pop();
1137 
1138             // Delete the index for the deleted slot
1139             delete map._indexes[key];
1140 
1141             return true;
1142         } else {
1143             return false;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Returns true if the key is in the map. O(1).
1149      */
1150     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1151         return map._indexes[key] != 0;
1152     }
1153 
1154     /**
1155      * @dev Returns the number of key-value pairs in the map. O(1).
1156      */
1157     function _length(Map storage map) private view returns (uint256) {
1158         return map._entries.length;
1159     }
1160 
1161    /**
1162     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1163     *
1164     * Note that there are no guarantees on the ordering of entries inside the
1165     * array, and it may change when more entries are added or removed.
1166     *
1167     * Requirements:
1168     *
1169     * - `index` must be strictly less than {length}.
1170     */
1171     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1172         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1173 
1174         MapEntry storage entry = map._entries[index];
1175         return (entry._key, entry._value);
1176     }
1177 
1178     /**
1179      * @dev Tries to returns the value associated with `key`.  O(1).
1180      * Does not revert if `key` is not in the map.
1181      */
1182     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1183         uint256 keyIndex = map._indexes[key];
1184         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1185         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1186     }
1187 
1188     /**
1189      * @dev Returns the value associated with `key`.  O(1).
1190      *
1191      * Requirements:
1192      *
1193      * - `key` must be in the map.
1194      */
1195     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1196         uint256 keyIndex = map._indexes[key];
1197         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1198         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1199     }
1200 
1201     /**
1202      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1203      *
1204      * CAUTION: This function is deprecated because it requires allocating memory for the error
1205      * message unnecessarily. For custom revert reasons use {_tryGet}.
1206      */
1207     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1208         uint256 keyIndex = map._indexes[key];
1209         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1210         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1211     }
1212 
1213     // UintToAddressMap
1214 
1215     struct UintToAddressMap {
1216         Map _inner;
1217     }
1218 
1219     /**
1220      * @dev Adds a key-value pair to a map, or updates the value for an existing
1221      * key. O(1).
1222      *
1223      * Returns true if the key was added to the map, that is if it was not
1224      * already present.
1225      */
1226     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1227         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1228     }
1229 
1230     /**
1231      * @dev Removes a value from a set. O(1).
1232      *
1233      * Returns true if the key was removed from the map, that is if it was present.
1234      */
1235     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1236         return _remove(map._inner, bytes32(key));
1237     }
1238 
1239     /**
1240      * @dev Returns true if the key is in the map. O(1).
1241      */
1242     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1243         return _contains(map._inner, bytes32(key));
1244     }
1245 
1246     /**
1247      * @dev Returns the number of elements in the map. O(1).
1248      */
1249     function length(UintToAddressMap storage map) internal view returns (uint256) {
1250         return _length(map._inner);
1251     }
1252 
1253    /**
1254     * @dev Returns the element stored at position `index` in the set. O(1).
1255     * Note that there are no guarantees on the ordering of values inside the
1256     * array, and it may change when more values are added or removed.
1257     *
1258     * Requirements:
1259     *
1260     * - `index` must be strictly less than {length}.
1261     */
1262     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1263         (bytes32 key, bytes32 value) = _at(map._inner, index);
1264         return (uint256(key), address(uint160(uint256(value))));
1265     }
1266 
1267     /**
1268      * @dev Tries to returns the value associated with `key`.  O(1).
1269      * Does not revert if `key` is not in the map.
1270      *
1271      * _Available since v3.4._
1272      */
1273     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1274         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1275         return (success, address(uint160(uint256(value))));
1276     }
1277 
1278     /**
1279      * @dev Returns the value associated with `key`.  O(1).
1280      *
1281      * Requirements:
1282      *
1283      * - `key` must be in the map.
1284      */
1285     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1286         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1287     }
1288 
1289     /**
1290      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1291      *
1292      * CAUTION: This function is deprecated because it requires allocating memory for the error
1293      * message unnecessarily. For custom revert reasons use {tryGet}.
1294      */
1295     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1296         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1297     }
1298 }
1299 
1300 // File: @openzeppelin/contracts/utils/Strings.sol
1301 
1302 
1303 
1304 pragma solidity >=0.6.0 <0.8.0;
1305 
1306 /**
1307  * @dev String operations.
1308  */
1309 library Strings {
1310     /**
1311      * @dev Converts a `uint256` to its ASCII `string` representation.
1312      */
1313     function toString(uint256 value) internal pure returns (string memory) {
1314         // Inspired by OraclizeAPI's implementation - MIT licence
1315         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1316 
1317         if (value == 0) {
1318             return "0";
1319         }
1320         uint256 temp = value;
1321         uint256 digits;
1322         while (temp != 0) {
1323             digits++;
1324             temp /= 10;
1325         }
1326         bytes memory buffer = new bytes(digits);
1327         uint256 index = digits - 1;
1328         temp = value;
1329         while (temp != 0) {
1330             buffer[index--] = bytes1(uint8(48 + temp % 10));
1331             temp /= 10;
1332         }
1333         return string(buffer);
1334     }
1335 }
1336 
1337 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1338 
1339 
1340 
1341 pragma solidity >=0.6.0 <0.8.0;
1342 
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 
1351 
1352 
1353 
1354 /**
1355  * @title ERC721 Non-Fungible Token Standard basic implementation
1356  * @dev see https://eips.ethereum.org/EIPS/eip-721
1357  */
1358 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1359     using SafeMath for uint256;
1360     using Address for address;
1361     using EnumerableSet for EnumerableSet.UintSet;
1362     using EnumerableMap for EnumerableMap.UintToAddressMap;
1363     using Strings for uint256;
1364 
1365     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1366     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1367     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1368 
1369     // Mapping from holder address to their (enumerable) set of owned tokens
1370     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1371 
1372     // Enumerable mapping from token ids to their owners
1373     EnumerableMap.UintToAddressMap private _tokenOwners;
1374 
1375     // Mapping from token ID to approved address
1376     mapping (uint256 => address) private _tokenApprovals;
1377 
1378     // Mapping from owner to operator approvals
1379     mapping (address => mapping (address => bool)) private _operatorApprovals;
1380 
1381     // Token name
1382     string private _name;
1383 
1384     // Token symbol
1385     string private _symbol;
1386 
1387     // Optional mapping for token URIs
1388     mapping (uint256 => string) private _tokenURIs;
1389 
1390     // Base URI
1391     string private _baseURI;
1392 
1393     /*
1394      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1395      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1396      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1397      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1398      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1399      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1400      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1401      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1402      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1403      *
1404      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1405      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1406      */
1407     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1408 
1409     /*
1410      *     bytes4(keccak256('name()')) == 0x06fdde03
1411      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1412      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1413      *
1414      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1415      */
1416     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1417 
1418     /*
1419      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1420      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1421      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1422      *
1423      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1424      */
1425     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1426 
1427     /**
1428      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1429      */
1430     constructor (string memory name_, string memory symbol_) public {
1431         _name = name_;
1432         _symbol = symbol_;
1433 
1434         // register the supported interfaces to conform to ERC721 via ERC165
1435         _registerInterface(_INTERFACE_ID_ERC721);
1436         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1437         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-balanceOf}.
1442      */
1443     function balanceOf(address owner) public view virtual override returns (uint256) {
1444         require(owner != address(0), "ERC721: balance query for the zero address");
1445         return _holderTokens[owner].length();
1446     }
1447 
1448     /**
1449      * @dev See {IERC721-ownerOf}.
1450      */
1451     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1452         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Metadata-name}.
1457      */
1458     function name() public view virtual override returns (string memory) {
1459         return _name;
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Metadata-symbol}.
1464      */
1465     function symbol() public view virtual override returns (string memory) {
1466         return _symbol;
1467     }
1468 
1469     /**
1470      * @dev See {IERC721Metadata-tokenURI}.
1471      */
1472     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1473         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1474 
1475         string memory _tokenURI = _tokenURIs[tokenId];
1476         string memory base = baseURI();
1477 
1478         // If there is no base URI, return the token URI.
1479         if (bytes(base).length == 0) {
1480             return _tokenURI;
1481         }
1482         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1483         if (bytes(_tokenURI).length > 0) {
1484             return string(abi.encodePacked(base, _tokenURI));
1485         }
1486         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1487         return string(abi.encodePacked(base, tokenId.toString()));
1488     }
1489 
1490     /**
1491     * @dev Returns the base URI set via {_setBaseURI}. This will be
1492     * automatically added as a prefix in {tokenURI} to each token's URI, or
1493     * to the token ID if no specific URI is set for that token ID.
1494     */
1495     function baseURI() public view virtual returns (string memory) {
1496         return _baseURI;
1497     }
1498 
1499     /**
1500      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1501      */
1502     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1503         return _holderTokens[owner].at(index);
1504     }
1505 
1506     /**
1507      * @dev See {IERC721Enumerable-totalSupply}.
1508      */
1509     function totalSupply() public view virtual override returns (uint256) {
1510         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1511         return _tokenOwners.length();
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Enumerable-tokenByIndex}.
1516      */
1517     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1518         (uint256 tokenId, ) = _tokenOwners.at(index);
1519         return tokenId;
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-approve}.
1524      */
1525     function approve(address to, uint256 tokenId) public virtual override {
1526         address owner = ERC721.ownerOf(tokenId);
1527         require(to != owner, "ERC721: approval to current owner");
1528 
1529         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1530             "ERC721: approve caller is not owner nor approved for all"
1531         );
1532 
1533         _approve(to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev See {IERC721-getApproved}.
1538      */
1539     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1540         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1541 
1542         return _tokenApprovals[tokenId];
1543     }
1544 
1545     /**
1546      * @dev See {IERC721-setApprovalForAll}.
1547      */
1548     function setApprovalForAll(address operator, bool approved) public virtual override {
1549         require(operator != _msgSender(), "ERC721: approve to caller");
1550 
1551         _operatorApprovals[_msgSender()][operator] = approved;
1552         emit ApprovalForAll(_msgSender(), operator, approved);
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-isApprovedForAll}.
1557      */
1558     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1559         return _operatorApprovals[owner][operator];
1560     }
1561 
1562     /**
1563      * @dev See {IERC721-transferFrom}.
1564      */
1565     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1566         //solhint-disable-next-line max-line-length
1567         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1568 
1569         _transfer(from, to, tokenId);
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-safeTransferFrom}.
1574      */
1575     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1576         safeTransferFrom(from, to, tokenId, "");
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-safeTransferFrom}.
1581      */
1582     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1583         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1584         _safeTransfer(from, to, tokenId, _data);
1585     }
1586 
1587     /**
1588      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1589      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1590      *
1591      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1592      *
1593      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1594      * implement alternative mechanisms to perform token transfer, such as signature-based.
1595      *
1596      * Requirements:
1597      *
1598      * - `from` cannot be the zero address.
1599      * - `to` cannot be the zero address.
1600      * - `tokenId` token must exist and be owned by `from`.
1601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1602      *
1603      * Emits a {Transfer} event.
1604      */
1605     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1606         _transfer(from, to, tokenId);
1607         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1608     }
1609 
1610     /**
1611      * @dev Returns whether `tokenId` exists.
1612      *
1613      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1614      *
1615      * Tokens start existing when they are minted (`_mint`),
1616      * and stop existing when they are burned (`_burn`).
1617      */
1618     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1619         return _tokenOwners.contains(tokenId);
1620     }
1621 
1622     /**
1623      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1624      *
1625      * Requirements:
1626      *
1627      * - `tokenId` must exist.
1628      */
1629     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1630         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1631         address owner = ERC721.ownerOf(tokenId);
1632         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1633     }
1634 
1635     /**
1636      * @dev Safely mints `tokenId` and transfers it to `to`.
1637      *
1638      * Requirements:
1639      d*
1640      * - `tokenId` must not exist.
1641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function _safeMint(address to, uint256 tokenId) internal virtual {
1646         _safeMint(to, tokenId, "");
1647     }
1648 
1649     /**
1650      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1651      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1652      */
1653     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1654         _mint(to, tokenId);
1655         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1656     }
1657 
1658     /**
1659      * @dev Mints `tokenId` and transfers it to `to`.
1660      *
1661      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1662      *
1663      * Requirements:
1664      *
1665      * - `tokenId` must not exist.
1666      * - `to` cannot be the zero address.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function _mint(address to, uint256 tokenId) internal virtual {
1671         require(to != address(0), "ERC721: mint to the zero address");
1672         require(!_exists(tokenId), "ERC721: token already minted");
1673 
1674         _beforeTokenTransfer(address(0), to, tokenId);
1675 
1676         _holderTokens[to].add(tokenId);
1677 
1678         _tokenOwners.set(tokenId, to);
1679 
1680         emit Transfer(address(0), to, tokenId);
1681     }
1682 
1683     /**
1684      * @dev Destroys `tokenId`.
1685      * The approval is cleared when the token is burned.
1686      *
1687      * Requirements:
1688      *
1689      * - `tokenId` must exist.
1690      *
1691      * Emits a {Transfer} event.
1692      */
1693     function _burn(uint256 tokenId) internal virtual {
1694         address owner = ERC721.ownerOf(tokenId); // internal owner
1695 
1696         _beforeTokenTransfer(owner, address(0), tokenId);
1697 
1698         // Clear approvals
1699         _approve(address(0), tokenId);
1700 
1701         // Clear metadata (if any)
1702         if (bytes(_tokenURIs[tokenId]).length != 0) {
1703             delete _tokenURIs[tokenId];
1704         }
1705 
1706         _holderTokens[owner].remove(tokenId);
1707 
1708         _tokenOwners.remove(tokenId);
1709 
1710         emit Transfer(owner, address(0), tokenId);
1711     }
1712 
1713     /**
1714      * @dev Transfers `tokenId` from `from` to `to`.
1715      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1716      *
1717      * Requirements:
1718      *
1719      * - `to` cannot be the zero address.
1720      * - `tokenId` token must be owned by `from`.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1725         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1726         require(to != address(0), "ERC721: transfer to the zero address");
1727 
1728         _beforeTokenTransfer(from, to, tokenId);
1729 
1730         // Clear approvals from the previous owner
1731         _approve(address(0), tokenId);
1732 
1733         _holderTokens[from].remove(tokenId);
1734         _holderTokens[to].add(tokenId);
1735 
1736         _tokenOwners.set(tokenId, to);
1737 
1738         emit Transfer(from, to, tokenId);
1739     }
1740 
1741     /**
1742      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1743      *
1744      * Requirements:
1745      *
1746      * - `tokenId` must exist.
1747      */
1748     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1749         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1750         _tokenURIs[tokenId] = _tokenURI;
1751     }
1752 
1753     /**
1754      * @dev Internal function to set the base URI for all token IDs. It is
1755      * automatically added as a prefix to the value returned in {tokenURI},
1756      * or to the token ID if {tokenURI} is empty.
1757      */
1758     function _setBaseURI(string memory baseURI_) internal virtual {
1759         _baseURI = baseURI_;
1760     }
1761 
1762     /**
1763      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1764      * The call is not executed if the target address is not a contract.
1765      *
1766      * @param from address representing the previous owner of the given token ID
1767      * @param to target address that will receive the tokens
1768      * @param tokenId uint256 ID of the token to be transferred
1769      * @param _data bytes optional data to send along with the call
1770      * @return bool whether the call correctly returned the expected magic value
1771      */
1772     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1773         private returns (bool)
1774     {
1775         if (!to.isContract()) {
1776             return true;
1777         }
1778         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1779             IERC721Receiver(to).onERC721Received.selector,
1780             _msgSender(),
1781             from,
1782             tokenId,
1783             _data
1784         ), "ERC721: transfer to non ERC721Receiver implementer");
1785         bytes4 retval = abi.decode(returndata, (bytes4));
1786         return (retval == _ERC721_RECEIVED);
1787     }
1788 
1789     /**
1790      * @dev Approve `to` to operate on `tokenId`
1791      *
1792      * Emits an {Approval} event.
1793      */
1794     function _approve(address to, uint256 tokenId) internal virtual {
1795         _tokenApprovals[tokenId] = to;
1796         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1797     }
1798 
1799     /**
1800      * @dev Hook that is called before any token transfer. This includes minting
1801      * and burning.
1802      *
1803      * Calling conditions:
1804      *
1805      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1806      * transferred to `to`.
1807      * - When `from` is zero, `tokenId` will be minted for `to`.
1808      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1809      * - `from` cannot be the zero address.
1810      * - `to` cannot be the zero address.
1811      *
1812      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1813      */
1814     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1815 }
1816 
1817 // File: @openzeppelin/contracts/access/Ownable.sol
1818 
1819 
1820 
1821 pragma solidity >=0.6.0 <0.8.0;
1822 
1823 /**
1824  * @dev Contract module which provides a basic access control mechanism, where
1825  * there is an account (an owner) that can be granted exclusive access to
1826  * specific functions.
1827  *
1828  * By default, the owner account will be the one that deploys the contract. This
1829  * can later be changed with {transferOwnership}.
1830  *
1831  * This module is used through inheritance. It will make available the modifier
1832  * `onlyOwner`, which can be applied to your functions to restrict their use to
1833  * the owner.
1834  */
1835 abstract contract Ownable is Context {
1836     address private _owner;
1837 
1838     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1839 
1840     /**
1841      * @dev Initializes the contract setting the deployer as the initial owner.
1842      */
1843     constructor () internal {
1844         address msgSender = _msgSender();
1845         _owner = msgSender;
1846         emit OwnershipTransferred(address(0), msgSender);
1847     }
1848 
1849     /**
1850      * @dev Returns the address of the current owner.
1851      */
1852     function owner() public view virtual returns (address) {
1853         return _owner;
1854     }
1855 
1856     /**
1857      * @dev Throws if called by any account other than the owner.
1858      */
1859     modifier onlyOwner() {
1860         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1861         _;
1862     }
1863 
1864     /**
1865      * @dev Leaves the contract without owner. It will not be possible to call
1866      * `onlyOwner` functions anymore. Can only be called by the current owner.
1867      *
1868      * NOTE: Renouncing ownership will leave the contract without an owner,
1869      * thereby removing any functionality that is only available to the owner.
1870      */
1871     function renounceOwnership() public virtual onlyOwner {
1872         emit OwnershipTransferred(_owner, address(0));
1873         _owner = address(0);
1874     }
1875 
1876     /**
1877      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1878      * Can only be called by the current owner.
1879      */
1880     function transferOwnership(address newOwner) public virtual onlyOwner {
1881         require(newOwner != address(0), "Ownable: new owner is the zero address");
1882         emit OwnershipTransferred(_owner, newOwner);
1883         _owner = newOwner;
1884     }
1885 }
1886 
1887 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
1888 
1889 
1890 
1891 pragma solidity >=0.6.0 <0.8.0;
1892 
1893 /**
1894  * @dev Contract module that helps prevent reentrant calls to a function.
1895  *
1896  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1897  * available, which can be applied to functions to make sure there are no nested
1898  * (reentrant) calls to them.
1899  *
1900  * Note that because there is a single `nonReentrant` guard, functions marked as
1901  * `nonReentrant` may not call one another. This can be worked around by making
1902  * those functions `private`, and then adding `external` `nonReentrant` entry
1903  * points to them.
1904  *
1905  * TIP: If you would like to learn more about reentrancy and alternative ways
1906  * to protect against it, check out our blog post
1907  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1908  */
1909 abstract contract ReentrancyGuard {
1910     // Booleans are more expensive than uint256 or any type that takes up a full
1911     // word because each write operation emits an extra SLOAD to first read the
1912     // slot's contents, replace the bits taken up by the boolean, and then write
1913     // back. This is the compiler's defense against contract upgrades and
1914     // pointer aliasing, and it cannot be disabled.
1915 
1916     // The values being non-zero value makes deployment a bit more expensive,
1917     // but in exchange the refund on every call to nonReentrant will be lower in
1918     // amount. Since refunds are capped to a percentage of the total
1919     // transaction's gas, it is best to keep them low in cases like this one, to
1920     // increase the likelihood of the full refund coming into effect.
1921     uint256 private constant _NOT_ENTERED = 1;
1922     uint256 private constant _ENTERED = 2;
1923 
1924     uint256 private _status;
1925 
1926     constructor () internal {
1927         _status = _NOT_ENTERED;
1928     }
1929 
1930     /**
1931      * @dev Prevents a contract from calling itself, directly or indirectly.
1932      * Calling a `nonReentrant` function from another `nonReentrant`
1933      * function is not supported. It is possible to prevent this from happening
1934      * by making the `nonReentrant` function external, and make it call a
1935      * `private` function that does the actual work.
1936      */
1937     modifier nonReentrant() {
1938         // On the first call to nonReentrant, _notEntered will be true
1939         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1940 
1941         // Any calls to nonReentrant after this point will fail
1942         _status = _ENTERED;
1943 
1944         _;
1945 
1946         // By storing the original value once again, a refund is triggered (see
1947         // https://eips.ethereum.org/EIPS/eip-2200)
1948         _status = _NOT_ENTERED;
1949     }
1950 }
1951 
1952 // File: @openzeppelin/contracts/utils/Pausable.sol
1953 
1954 
1955 
1956 pragma solidity >=0.6.0 <0.8.0;
1957 
1958 
1959 /**
1960  * @dev Contract module which allows children to implement an emergency stop
1961  * mechanism that can be triggered by an authorized account.
1962  *
1963  * This module is used through inheritance. It will make available the
1964  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1965  * the functions of your contract. Note that they will not be pausable by
1966  * simply including this module, only once the modifiers are put in place.
1967  */
1968 abstract contract Pausable is Context {
1969     /**
1970      * @dev Emitted when the pause is triggered by `account`.
1971      */
1972     event Paused(address account);
1973 
1974     /**
1975      * @dev Emitted when the pause is lifted by `account`.
1976      */
1977     event Unpaused(address account);
1978 
1979     bool private _paused;
1980 
1981     /**
1982      * @dev Initializes the contract in unpaused state.
1983      */
1984     constructor () internal {
1985         _paused = false;
1986     }
1987 
1988     /**
1989      * @dev Returns true if the contract is paused, and false otherwise.
1990      */
1991     function paused() public view virtual returns (bool) {
1992         return _paused;
1993     }
1994 
1995     /**
1996      * @dev Modifier to make a function callable only when the contract is not paused.
1997      *
1998      * Requirements:
1999      *
2000      * - The contract must not be paused.
2001      */
2002     modifier whenNotPaused() {
2003         require(!paused(), "Pausable: paused");
2004         _;
2005     }
2006 
2007     /**
2008      * @dev Modifier to make a function callable only when the contract is paused.
2009      *
2010      * Requirements:
2011      *
2012      * - The contract must be paused.
2013      */
2014     modifier whenPaused() {
2015         require(paused(), "Pausable: not paused");
2016         _;
2017     }
2018 
2019     /**
2020      * @dev Triggers stopped state.
2021      *
2022      * Requirements:
2023      *
2024      * - The contract must not be paused.
2025      */
2026     function _pause() internal virtual whenNotPaused {
2027         _paused = true;
2028         emit Paused(_msgSender());
2029     }
2030 
2031     /**
2032      * @dev Returns to normal state.
2033      *
2034      * Requirements:
2035      *
2036      * - The contract must be paused.
2037      */
2038     function _unpause() internal virtual whenPaused {
2039         _paused = false;
2040         emit Unpaused(_msgSender());
2041     }
2042 }
2043 
2044 // File: contracts/WrappedCryptoCat.sol
2045 
2046 // SPDX-License-Identifier: MIT
2047 
2048 pragma solidity ^0.7.6;
2049 
2050 // -----------------------------------------------------------------------------------------------
2051 // Wrapped CryptoCat
2052 //
2053 // Wrapper contract for minting ERC721 for vintage 8-bit NFT project CryptoCats (cryptocats.thetwentysix.io)
2054 // 
2055 // Community built with feedback and contributions from
2056 // https://github.com/surfer77
2057 // https://github.com/abcoathup
2058 // https://github.com/bokkypoobah
2059 // https://github.com/catmaestro
2060 // ----------------------------------------------------------------------------------------------
2061 
2062 
2063 
2064 
2065 
2066 interface ICryptoCats {
2067     function totalSupply() external view returns (uint256);
2068     function balanceOf(address tokenOwner) external view returns (uint256 balance);
2069     function transfer(address _to, uint256 _value) external returns (bool success);
2070     function catIndexToAddress(uint256 tokenId) external view returns (address owner);
2071     function buyCat(uint256 catIndex) external payable;
2072     function getCatOwner(uint256 catIndex) external returns (address);
2073 }
2074 
2075 contract WrappedCryptoCat is
2076     ERC721,
2077     Ownable,
2078     ReentrancyGuard,
2079     Pausable
2080 {
2081     ICryptoCats private cryptoCatsCore = ICryptoCats(0x088C6Ad962812b5Aa905BA6F3c5c145f9D4C079f);
2082 
2083     mapping(uint256 => bool) private catIsDepositedInContract;
2084 
2085     event BurnTokenAndWithdrawCat(uint256 catId);
2086     event DepositCatAndMintToken(uint256 catId);
2087 
2088     constructor(
2089         string memory _name,
2090         string memory _symbol,
2091         string memory _baseURI
2092     ) ERC721(_name, _symbol) {
2093         _setBaseURI(_baseURI);
2094     }
2095 
2096     function pause() public onlyOwner {
2097         _pause();
2098     }
2099 
2100     function unpause() public onlyOwner {
2101         _unpause();
2102     }
2103 
2104     function setBaseURI(string memory baseURI_) public onlyOwner {
2105         _setBaseURI(baseURI_);
2106     }
2107 
2108     function depositCatAndMintToken(uint256 _catId)
2109         external
2110         payable
2111         nonReentrant
2112         whenNotPaused
2113     {
2114         require(
2115             cryptoCatsCore.getCatOwner(_catId) == msg.sender,
2116             "Only cat owner is allowed"
2117         );
2118         address sender = _msgSender();
2119 
2120         // pay 0 ETH to get a cat
2121         // precondition that owner has called offerCatForSaleToAddress to sell to this wrapper contract for 0 ETH
2122         cryptoCatsCore.buyCat(_catId);
2123         // verify that ownership of cat already transferred to contract
2124         require(
2125             cryptoCatsCore.getCatOwner(_catId) == address(this),
2126             "Cat cannot be transferred"
2127         );
2128 
2129         catIsDepositedInContract[_catId] = true;
2130         _mint(sender, _catId);
2131 
2132         emit DepositCatAndMintToken(_catId);
2133     }
2134 
2135     function unwrap(uint256 _tokenId) external nonReentrant {
2136         require(_isApprovedOrOwner(msg.sender, _tokenId), "Caller is not owner nor approved");
2137         require(
2138             catIsDepositedInContract[_tokenId],
2139             "Cat not found in contract"
2140         );
2141         require(
2142             cryptoCatsCore.transfer(msg.sender, _tokenId),
2143             "Cat cannot be transferred"
2144         );
2145         
2146         _burn(_tokenId);
2147         catIsDepositedInContract[_tokenId] = false;
2148         emit BurnTokenAndWithdrawCat(_tokenId);
2149     }
2150 }