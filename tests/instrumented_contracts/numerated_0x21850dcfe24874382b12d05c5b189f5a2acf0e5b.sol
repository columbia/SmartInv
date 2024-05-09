1 pragma solidity >=0.6.0 <0.8.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 
25 /**
26  * @dev Interface of the ERC165 standard, as defined in the
27  * https://eips.ethereum.org/EIPS/eip-165[EIP].
28  *
29  * Implementers can declare support of contract interfaces, which can then be
30  * queried by others ({ERC165Checker}).
31  *
32  * For an implementation, see {ERC165}.
33  */
34 interface IERC165 {
35     /**
36      * @dev Returns true if this contract implements the interface defined by
37      * `interfaceId`. See the corresponding
38      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
39      * to learn more about how these ids are created.
40      *
41      * This function call must use less than 30 000 gas.
42      */
43     function supportsInterface(bytes4 interfaceId) external view returns (bool);
44 }
45 
46 
47 /**
48  * @dev Required interface of an ERC721 compliant contract.
49  */
50 interface IERC721 is IERC165 {
51     /**
52      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
53      */
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55 
56     /**
57      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
58      */
59     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
65 
66     /**
67      * @dev Returns the number of tokens in ``owner``'s account.
68      */
69     function balanceOf(address owner) external view returns (uint256 balance);
70 
71     /**
72      * @dev Returns the owner of the `tokenId` token.
73      *
74      * Requirements:
75      *
76      * - `tokenId` must exist.
77      */
78     function ownerOf(uint256 tokenId) external view returns (address owner);
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(address from, address to, uint256 tokenId) external;
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(address from, address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
114      * The approval is cleared when the token is transferred.
115      *
116      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
117      *
118      * Requirements:
119      *
120      * - The caller must own the token or be an approved operator.
121      * - `tokenId` must exist.
122      *
123      * Emits an {Approval} event.
124      */
125     function approve(address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Returns the account approved for `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function getApproved(uint256 tokenId) external view returns (address operator);
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
150      *
151      * See {setApprovalForAll}
152      */
153     function isApprovedForAll(address owner, address operator) external view returns (bool);
154 
155     /**
156       * @dev Safely transfers `tokenId` token from `from` to `to`.
157       *
158       * Requirements:
159       *
160       * - `from` cannot be the zero address.
161       * - `to` cannot be the zero address.
162       * - `tokenId` token must exist and be owned by `from`.
163       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165       *
166       * Emits a {Transfer} event.
167       */
168     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
169 }
170 
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Metadata is IERC721 {
176 
177     /**
178      * @dev Returns the token collection name.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the token collection symbol.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
189      */
190     function tokenURI(uint256 tokenId) external view returns (string memory);
191 }
192 
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Enumerable is IERC721 {
199 
200     /**
201      * @dev Returns the total amount of tokens stored by the contract.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
207      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
208      */
209     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
210 
211     /**
212      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
213      * Use along with {totalSupply} to enumerate all tokens.
214      */
215     function tokenByIndex(uint256 index) external view returns (uint256);
216 }
217 
218 
219 /**
220  * @title ERC721 token receiver interface
221  * @dev Interface for any contract that wants to support safeTransfers
222  * from ERC721 asset contracts.
223  */
224 interface IERC721Receiver {
225     /**
226      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
227      * by `operator` from `from`, this function is called.
228      *
229      * It must return its Solidity selector to confirm the token transfer.
230      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
231      *
232      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
233      */
234     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
235 }
236 
237 /**
238  * @dev Implementation of the {IERC165} interface.
239  *
240  * Contracts may inherit from this and call {_registerInterface} to declare
241  * their support of an interface.
242  */
243 abstract contract ERC165 is IERC165 {
244     /*
245      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
246      */
247     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
248 
249     /**
250      * @dev Mapping of interface ids to whether or not it's supported.
251      */
252     mapping(bytes4 => bool) private _supportedInterfaces;
253 
254     constructor () internal {
255         // Derived contracts need only register support for their own interfaces,
256         // we register support for ERC165 itself here
257         _registerInterface(_INTERFACE_ID_ERC165);
258     }
259 
260     /**
261      * @dev See {IERC165-supportsInterface}.
262      *
263      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
264      */
265     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
266         return _supportedInterfaces[interfaceId];
267     }
268 
269     /**
270      * @dev Registers the contract as an implementer of the interface defined by
271      * `interfaceId`. Support of the actual ERC165 interface is automatic and
272      * registering its interface id is not required.
273      *
274      * See {IERC165-supportsInterface}.
275      *
276      * Requirements:
277      *
278      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
279      */
280     function _registerInterface(bytes4 interfaceId) internal virtual {
281         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
282         _supportedInterfaces[interfaceId] = true;
283     }
284 }
285 
286 
287 /**
288  * @dev Wrappers over Solidity's arithmetic operations with added overflow
289  * checks.
290  *
291  * Arithmetic operations in Solidity wrap on overflow. This can easily result
292  * in bugs, because programmers usually assume that an overflow raises an
293  * error, which is the standard behavior in high level programming languages.
294  * `SafeMath` restores this intuition by reverting the transaction when an
295  * operation overflows.
296  *
297  * Using this library instead of the unchecked operations eliminates an entire
298  * class of bugs, so it's recommended to use it always.
299  */
300 library SafeMath {
301     /**
302      * @dev Returns the addition of two unsigned integers, with an overflow flag.
303      *
304      * _Available since v3.4._
305      */
306     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
307         uint256 c = a + b;
308         if (c < a) return (false, 0);
309         return (true, c);
310     }
311 
312     /**
313      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
314      *
315      * _Available since v3.4._
316      */
317     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
318         if (b > a) return (false, 0);
319         return (true, a - b);
320     }
321 
322     /**
323      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
324      *
325      * _Available since v3.4._
326      */
327     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
328         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
329         // benefit is lost if 'b' is also tested.
330         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
331         if (a == 0) return (true, 0);
332         uint256 c = a * b;
333         if (c / a != b) return (false, 0);
334         return (true, c);
335     }
336 
337     /**
338      * @dev Returns the division of two unsigned integers, with a division by zero flag.
339      *
340      * _Available since v3.4._
341      */
342     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
343         if (b == 0) return (false, 0);
344         return (true, a / b);
345     }
346 
347     /**
348      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
349      *
350      * _Available since v3.4._
351      */
352     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
353         if (b == 0) return (false, 0);
354         return (true, a % b);
355     }
356 
357     /**
358      * @dev Returns the addition of two unsigned integers, reverting on
359      * overflow.
360      *
361      * Counterpart to Solidity's `+` operator.
362      *
363      * Requirements:
364      *
365      * - Addition cannot overflow.
366      */
367     function add(uint256 a, uint256 b) internal pure returns (uint256) {
368         uint256 c = a + b;
369         require(c >= a, "SafeMath: addition overflow");
370         return c;
371     }
372 
373     /**
374      * @dev Returns the subtraction of two unsigned integers, reverting on
375      * overflow (when the result is negative).
376      *
377      * Counterpart to Solidity's `-` operator.
378      *
379      * Requirements:
380      *
381      * - Subtraction cannot overflow.
382      */
383     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
384         require(b <= a, "SafeMath: subtraction overflow");
385         return a - b;
386     }
387 
388     /**
389      * @dev Returns the multiplication of two unsigned integers, reverting on
390      * overflow.
391      *
392      * Counterpart to Solidity's `*` operator.
393      *
394      * Requirements:
395      *
396      * - Multiplication cannot overflow.
397      */
398     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
399         if (a == 0) return 0;
400         uint256 c = a * b;
401         require(c / a == b, "SafeMath: multiplication overflow");
402         return c;
403     }
404 
405     /**
406      * @dev Returns the integer division of two unsigned integers, reverting on
407      * division by zero. The result is rounded towards zero.
408      *
409      * Counterpart to Solidity's `/` operator. Note: this function uses a
410      * `revert` opcode (which leaves remaining gas untouched) while Solidity
411      * uses an invalid opcode to revert (consuming all remaining gas).
412      *
413      * Requirements:
414      *
415      * - The divisor cannot be zero.
416      */
417     function div(uint256 a, uint256 b) internal pure returns (uint256) {
418         require(b > 0, "SafeMath: division by zero");
419         return a / b;
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * reverting when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
435         require(b > 0, "SafeMath: modulo by zero");
436         return a % b;
437     }
438 
439     /**
440      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
441      * overflow (when the result is negative).
442      *
443      * CAUTION: This function is deprecated because it requires allocating memory for the error
444      * message unnecessarily. For custom revert reasons use {trySub}.
445      *
446      * Counterpart to Solidity's `-` operator.
447      *
448      * Requirements:
449      *
450      * - Subtraction cannot overflow.
451      */
452     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
453         require(b <= a, errorMessage);
454         return a - b;
455     }
456 
457     /**
458      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
459      * division by zero. The result is rounded towards zero.
460      *
461      * CAUTION: This function is deprecated because it requires allocating memory for the error
462      * message unnecessarily. For custom revert reasons use {tryDiv}.
463      *
464      * Counterpart to Solidity's `/` operator. Note: this function uses a
465      * `revert` opcode (which leaves remaining gas untouched) while Solidity
466      * uses an invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
473         require(b > 0, errorMessage);
474         return a / b;
475     }
476 
477     /**
478      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
479      * reverting with custom message when dividing by zero.
480      *
481      * CAUTION: This function is deprecated because it requires allocating memory for the error
482      * message unnecessarily. For custom revert reasons use {tryMod}.
483      *
484      * Counterpart to Solidity's `%` operator. This function uses a `revert`
485      * opcode (which leaves remaining gas untouched) while Solidity uses an
486      * invalid opcode to revert (consuming all remaining gas).
487      *
488      * Requirements:
489      *
490      * - The divisor cannot be zero.
491      */
492     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
493         require(b > 0, errorMessage);
494         return a % b;
495     }
496 }
497 
498 /**
499  * @dev Collection of functions related to the address type
500  */
501 library Address {
502     /**
503      * @dev Returns true if `account` is a contract.
504      *
505      * [IMPORTANT]
506      * ====
507      * It is unsafe to assume that an address for which this function returns
508      * false is an externally-owned account (EOA) and not a contract.
509      *
510      * Among others, `isContract` will return false for the following
511      * types of addresses:
512      *
513      *  - an externally-owned account
514      *  - a contract in construction
515      *  - an address where a contract will be created
516      *  - an address where a contract lived, but was destroyed
517      * ====
518      */
519     function isContract(address account) internal view returns (bool) {
520         // This method relies on extcodesize, which returns 0 for contracts in
521         // construction, since the code is only stored at the end of the
522         // constructor execution.
523 
524         uint256 size;
525         // solhint-disable-next-line no-inline-assembly
526         assembly { size := extcodesize(account) }
527         return size > 0;
528     }
529 
530     /**
531      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
532      * `recipient`, forwarding all available gas and reverting on errors.
533      *
534      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
535      * of certain opcodes, possibly making contracts go over the 2300 gas limit
536      * imposed by `transfer`, making them unable to receive funds via
537      * `transfer`. {sendValue} removes this limitation.
538      *
539      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
540      *
541      * IMPORTANT: because control is transferred to `recipient`, care must be
542      * taken to not create reentrancy vulnerabilities. Consider using
543      * {ReentrancyGuard} or the
544      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
545      */
546     function sendValue(address payable recipient, uint256 amount) internal {
547         require(address(this).balance >= amount, "Address: insufficient balance");
548 
549         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
550         (bool success, ) = recipient.call{ value: amount }("");
551         require(success, "Address: unable to send value, recipient may have reverted");
552     }
553 
554     /**
555      * @dev Performs a Solidity function call using a low level `call`. A
556      * plain`call` is an unsafe replacement for a function call: use this
557      * function instead.
558      *
559      * If `target` reverts with a revert reason, it is bubbled up by this
560      * function (like regular Solidity function calls).
561      *
562      * Returns the raw returned data. To convert to the expected return value,
563      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
564      *
565      * Requirements:
566      *
567      * - `target` must be a contract.
568      * - calling `target` with `data` must not revert.
569      *
570      * _Available since v3.1._
571      */
572     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
573       return functionCall(target, data, "Address: low-level call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
578      * `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
583         return functionCallWithValue(target, data, 0, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but also transferring `value` wei to `target`.
589      *
590      * Requirements:
591      *
592      * - the calling contract must have an ETH balance of at least `value`.
593      * - the called Solidity function must be `payable`.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
598         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
603      * with `errorMessage` as a fallback revert reason when `target` reverts.
604      *
605      * _Available since v3.1._
606      */
607     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
608         require(address(this).balance >= value, "Address: insufficient balance for call");
609         require(isContract(target), "Address: call to non-contract");
610 
611         // solhint-disable-next-line avoid-low-level-calls
612         (bool success, bytes memory returndata) = target.call{ value: value }(data);
613         return _verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but performing a static call.
619      *
620      * _Available since v3.3._
621      */
622     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
623         return functionStaticCall(target, data, "Address: low-level static call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a static call.
629      *
630      * _Available since v3.3._
631      */
632     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
633         require(isContract(target), "Address: static call to non-contract");
634 
635         // solhint-disable-next-line avoid-low-level-calls
636         (bool success, bytes memory returndata) = target.staticcall(data);
637         return _verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
642      * but performing a delegate call.
643      *
644      * _Available since v3.4._
645      */
646     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
647         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
652      * but performing a delegate call.
653      *
654      * _Available since v3.4._
655      */
656     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
657         require(isContract(target), "Address: delegate call to non-contract");
658 
659         // solhint-disable-next-line avoid-low-level-calls
660         (bool success, bytes memory returndata) = target.delegatecall(data);
661         return _verifyCallResult(success, returndata, errorMessage);
662     }
663 
664     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
665         if (success) {
666             return returndata;
667         } else {
668             // Look for revert reason and bubble it up if present
669             if (returndata.length > 0) {
670                 // The easiest way to bubble the revert reason is using memory via assembly
671 
672                 // solhint-disable-next-line no-inline-assembly
673                 assembly {
674                     let returndata_size := mload(returndata)
675                     revert(add(32, returndata), returndata_size)
676                 }
677             } else {
678                 revert(errorMessage);
679             }
680         }
681     }
682 }
683 
684 /**
685  * @dev Library for managing
686  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
687  * types.
688  *
689  * Sets have the following properties:
690  *
691  * - Elements are added, removed, and checked for existence in constant time
692  * (O(1)).
693  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
694  *
695  * ```
696  * contract Example {
697  *     // Add the library methods
698  *     using EnumerableSet for EnumerableSet.AddressSet;
699  *
700  *     // Declare a set state variable
701  *     EnumerableSet.AddressSet private mySet;
702  * }
703  * ```
704  *
705  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
706  * and `uint256` (`UintSet`) are supported.
707  */
708 library EnumerableSet {
709     // To implement this library for multiple types with as little code
710     // repetition as possible, we write it in terms of a generic Set type with
711     // bytes32 values.
712     // The Set implementation uses private functions, and user-facing
713     // implementations (such as AddressSet) are just wrappers around the
714     // underlying Set.
715     // This means that we can only create new EnumerableSets for types that fit
716     // in bytes32.
717 
718     struct Set {
719         // Storage of set values
720         bytes32[] _values;
721 
722         // Position of the value in the `values` array, plus 1 because index 0
723         // means a value is not in the set.
724         mapping (bytes32 => uint256) _indexes;
725     }
726 
727     /**
728      * @dev Add a value to a set. O(1).
729      *
730      * Returns true if the value was added to the set, that is if it was not
731      * already present.
732      */
733     function _add(Set storage set, bytes32 value) private returns (bool) {
734         if (!_contains(set, value)) {
735             set._values.push(value);
736             // The value is stored at length-1, but we add 1 to all indexes
737             // and use 0 as a sentinel value
738             set._indexes[value] = set._values.length;
739             return true;
740         } else {
741             return false;
742         }
743     }
744 
745     /**
746      * @dev Removes a value from a set. O(1).
747      *
748      * Returns true if the value was removed from the set, that is if it was
749      * present.
750      */
751     function _remove(Set storage set, bytes32 value) private returns (bool) {
752         // We read and store the value's index to prevent multiple reads from the same storage slot
753         uint256 valueIndex = set._indexes[value];
754 
755         if (valueIndex != 0) { // Equivalent to contains(set, value)
756             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
757             // the array, and then remove the last element (sometimes called as 'swap and pop').
758             // This modifies the order of the array, as noted in {at}.
759 
760             uint256 toDeleteIndex = valueIndex - 1;
761             uint256 lastIndex = set._values.length - 1;
762 
763             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
764             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
765 
766             bytes32 lastvalue = set._values[lastIndex];
767 
768             // Move the last value to the index where the value to delete is
769             set._values[toDeleteIndex] = lastvalue;
770             // Update the index for the moved value
771             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
772 
773             // Delete the slot where the moved value was stored
774             set._values.pop();
775 
776             // Delete the index for the deleted slot
777             delete set._indexes[value];
778 
779             return true;
780         } else {
781             return false;
782         }
783     }
784 
785     /**
786      * @dev Returns true if the value is in the set. O(1).
787      */
788     function _contains(Set storage set, bytes32 value) private view returns (bool) {
789         return set._indexes[value] != 0;
790     }
791 
792     /**
793      * @dev Returns the number of values on the set. O(1).
794      */
795     function _length(Set storage set) private view returns (uint256) {
796         return set._values.length;
797     }
798 
799    /**
800     * @dev Returns the value stored at position `index` in the set. O(1).
801     *
802     * Note that there are no guarantees on the ordering of values inside the
803     * array, and it may change when more values are added or removed.
804     *
805     * Requirements:
806     *
807     * - `index` must be strictly less than {length}.
808     */
809     function _at(Set storage set, uint256 index) private view returns (bytes32) {
810         require(set._values.length > index, "EnumerableSet: index out of bounds");
811         return set._values[index];
812     }
813 
814     // Bytes32Set
815 
816     struct Bytes32Set {
817         Set _inner;
818     }
819 
820     /**
821      * @dev Add a value to a set. O(1).
822      *
823      * Returns true if the value was added to the set, that is if it was not
824      * already present.
825      */
826     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
827         return _add(set._inner, value);
828     }
829 
830     /**
831      * @dev Removes a value from a set. O(1).
832      *
833      * Returns true if the value was removed from the set, that is if it was
834      * present.
835      */
836     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
837         return _remove(set._inner, value);
838     }
839 
840     /**
841      * @dev Returns true if the value is in the set. O(1).
842      */
843     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
844         return _contains(set._inner, value);
845     }
846 
847     /**
848      * @dev Returns the number of values in the set. O(1).
849      */
850     function length(Bytes32Set storage set) internal view returns (uint256) {
851         return _length(set._inner);
852     }
853 
854    /**
855     * @dev Returns the value stored at position `index` in the set. O(1).
856     *
857     * Note that there are no guarantees on the ordering of values inside the
858     * array, and it may change when more values are added or removed.
859     *
860     * Requirements:
861     *
862     * - `index` must be strictly less than {length}.
863     */
864     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
865         return _at(set._inner, index);
866     }
867 
868     // AddressSet
869 
870     struct AddressSet {
871         Set _inner;
872     }
873 
874     /**
875      * @dev Add a value to a set. O(1).
876      *
877      * Returns true if the value was added to the set, that is if it was not
878      * already present.
879      */
880     function add(AddressSet storage set, address value) internal returns (bool) {
881         return _add(set._inner, bytes32(uint256(uint160(value))));
882     }
883 
884     /**
885      * @dev Removes a value from a set. O(1).
886      *
887      * Returns true if the value was removed from the set, that is if it was
888      * present.
889      */
890     function remove(AddressSet storage set, address value) internal returns (bool) {
891         return _remove(set._inner, bytes32(uint256(uint160(value))));
892     }
893 
894     /**
895      * @dev Returns true if the value is in the set. O(1).
896      */
897     function contains(AddressSet storage set, address value) internal view returns (bool) {
898         return _contains(set._inner, bytes32(uint256(uint160(value))));
899     }
900 
901     /**
902      * @dev Returns the number of values in the set. O(1).
903      */
904     function length(AddressSet storage set) internal view returns (uint256) {
905         return _length(set._inner);
906     }
907 
908    /**
909     * @dev Returns the value stored at position `index` in the set. O(1).
910     *
911     * Note that there are no guarantees on the ordering of values inside the
912     * array, and it may change when more values are added or removed.
913     *
914     * Requirements:
915     *
916     * - `index` must be strictly less than {length}.
917     */
918     function at(AddressSet storage set, uint256 index) internal view returns (address) {
919         return address(uint160(uint256(_at(set._inner, index))));
920     }
921 
922 
923     // UintSet
924 
925     struct UintSet {
926         Set _inner;
927     }
928 
929     /**
930      * @dev Add a value to a set. O(1).
931      *
932      * Returns true if the value was added to the set, that is if it was not
933      * already present.
934      */
935     function add(UintSet storage set, uint256 value) internal returns (bool) {
936         return _add(set._inner, bytes32(value));
937     }
938 
939     /**
940      * @dev Removes a value from a set. O(1).
941      *
942      * Returns true if the value was removed from the set, that is if it was
943      * present.
944      */
945     function remove(UintSet storage set, uint256 value) internal returns (bool) {
946         return _remove(set._inner, bytes32(value));
947     }
948 
949     /**
950      * @dev Returns true if the value is in the set. O(1).
951      */
952     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
953         return _contains(set._inner, bytes32(value));
954     }
955 
956     /**
957      * @dev Returns the number of values on the set. O(1).
958      */
959     function length(UintSet storage set) internal view returns (uint256) {
960         return _length(set._inner);
961     }
962 
963    /**
964     * @dev Returns the value stored at position `index` in the set. O(1).
965     *
966     * Note that there are no guarantees on the ordering of values inside the
967     * array, and it may change when more values are added or removed.
968     *
969     * Requirements:
970     *
971     * - `index` must be strictly less than {length}.
972     */
973     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
974         return uint256(_at(set._inner, index));
975     }
976 }
977 
978 /**
979  * @dev Library for managing an enumerable variant of Solidity's
980  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
981  * type.
982  *
983  * Maps have the following properties:
984  *
985  * - Entries are added, removed, and checked for existence in constant time
986  * (O(1)).
987  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
988  *
989  * ```
990  * contract Example {
991  *     // Add the library methods
992  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
993  *
994  *     // Declare a set state variable
995  *     EnumerableMap.UintToAddressMap private myMap;
996  * }
997  * ```
998  *
999  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1000  * supported.
1001  */
1002 library EnumerableMap {
1003     // To implement this library for multiple types with as little code
1004     // repetition as possible, we write it in terms of a generic Map type with
1005     // bytes32 keys and values.
1006     // The Map implementation uses private functions, and user-facing
1007     // implementations (such as Uint256ToAddressMap) are just wrappers around
1008     // the underlying Map.
1009     // This means that we can only create new EnumerableMaps for types that fit
1010     // in bytes32.
1011 
1012     struct MapEntry {
1013         bytes32 _key;
1014         bytes32 _value;
1015     }
1016 
1017     struct Map {
1018         // Storage of map keys and values
1019         MapEntry[] _entries;
1020 
1021         // Position of the entry defined by a key in the `entries` array, plus 1
1022         // because index 0 means a key is not in the map.
1023         mapping (bytes32 => uint256) _indexes;
1024     }
1025 
1026     /**
1027      * @dev Adds a key-value pair to a map, or updates the value for an existing
1028      * key. O(1).
1029      *
1030      * Returns true if the key was added to the map, that is if it was not
1031      * already present.
1032      */
1033     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1034         // We read and store the key's index to prevent multiple reads from the same storage slot
1035         uint256 keyIndex = map._indexes[key];
1036 
1037         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1038             map._entries.push(MapEntry({ _key: key, _value: value }));
1039             // The entry is stored at length-1, but we add 1 to all indexes
1040             // and use 0 as a sentinel value
1041             map._indexes[key] = map._entries.length;
1042             return true;
1043         } else {
1044             map._entries[keyIndex - 1]._value = value;
1045             return false;
1046         }
1047     }
1048 
1049     /**
1050      * @dev Removes a key-value pair from a map. O(1).
1051      *
1052      * Returns true if the key was removed from the map, that is if it was present.
1053      */
1054     function _remove(Map storage map, bytes32 key) private returns (bool) {
1055         // We read and store the key's index to prevent multiple reads from the same storage slot
1056         uint256 keyIndex = map._indexes[key];
1057 
1058         if (keyIndex != 0) { // Equivalent to contains(map, key)
1059             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1060             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1061             // This modifies the order of the array, as noted in {at}.
1062 
1063             uint256 toDeleteIndex = keyIndex - 1;
1064             uint256 lastIndex = map._entries.length - 1;
1065 
1066             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1067             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1068 
1069             MapEntry storage lastEntry = map._entries[lastIndex];
1070 
1071             // Move the last entry to the index where the entry to delete is
1072             map._entries[toDeleteIndex] = lastEntry;
1073             // Update the index for the moved entry
1074             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1075 
1076             // Delete the slot where the moved entry was stored
1077             map._entries.pop();
1078 
1079             // Delete the index for the deleted slot
1080             delete map._indexes[key];
1081 
1082             return true;
1083         } else {
1084             return false;
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns true if the key is in the map. O(1).
1090      */
1091     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1092         return map._indexes[key] != 0;
1093     }
1094 
1095     /**
1096      * @dev Returns the number of key-value pairs in the map. O(1).
1097      */
1098     function _length(Map storage map) private view returns (uint256) {
1099         return map._entries.length;
1100     }
1101 
1102    /**
1103     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1104     *
1105     * Note that there are no guarantees on the ordering of entries inside the
1106     * array, and it may change when more entries are added or removed.
1107     *
1108     * Requirements:
1109     *
1110     * - `index` must be strictly less than {length}.
1111     */
1112     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1113         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1114 
1115         MapEntry storage entry = map._entries[index];
1116         return (entry._key, entry._value);
1117     }
1118 
1119     /**
1120      * @dev Tries to returns the value associated with `key`.  O(1).
1121      * Does not revert if `key` is not in the map.
1122      */
1123     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1124         uint256 keyIndex = map._indexes[key];
1125         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1126         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1127     }
1128 
1129     /**
1130      * @dev Returns the value associated with `key`.  O(1).
1131      *
1132      * Requirements:
1133      *
1134      * - `key` must be in the map.
1135      */
1136     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1137         uint256 keyIndex = map._indexes[key];
1138         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1139         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1140     }
1141 
1142     /**
1143      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1144      *
1145      * CAUTION: This function is deprecated because it requires allocating memory for the error
1146      * message unnecessarily. For custom revert reasons use {_tryGet}.
1147      */
1148     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1149         uint256 keyIndex = map._indexes[key];
1150         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1151         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1152     }
1153 
1154     // UintToAddressMap
1155 
1156     struct UintToAddressMap {
1157         Map _inner;
1158     }
1159 
1160     /**
1161      * @dev Adds a key-value pair to a map, or updates the value for an existing
1162      * key. O(1).
1163      *
1164      * Returns true if the key was added to the map, that is if it was not
1165      * already present.
1166      */
1167     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1168         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1169     }
1170 
1171     /**
1172      * @dev Removes a value from a set. O(1).
1173      *
1174      * Returns true if the key was removed from the map, that is if it was present.
1175      */
1176     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1177         return _remove(map._inner, bytes32(key));
1178     }
1179 
1180     /**
1181      * @dev Returns true if the key is in the map. O(1).
1182      */
1183     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1184         return _contains(map._inner, bytes32(key));
1185     }
1186 
1187     /**
1188      * @dev Returns the number of elements in the map. O(1).
1189      */
1190     function length(UintToAddressMap storage map) internal view returns (uint256) {
1191         return _length(map._inner);
1192     }
1193 
1194    /**
1195     * @dev Returns the element stored at position `index` in the set. O(1).
1196     * Note that there are no guarantees on the ordering of values inside the
1197     * array, and it may change when more values are added or removed.
1198     *
1199     * Requirements:
1200     *
1201     * - `index` must be strictly less than {length}.
1202     */
1203     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1204         (bytes32 key, bytes32 value) = _at(map._inner, index);
1205         return (uint256(key), address(uint160(uint256(value))));
1206     }
1207 
1208     /**
1209      * @dev Tries to returns the value associated with `key`.  O(1).
1210      * Does not revert if `key` is not in the map.
1211      *
1212      * _Available since v3.4._
1213      */
1214     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1215         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1216         return (success, address(uint160(uint256(value))));
1217     }
1218 
1219     /**
1220      * @dev Returns the value associated with `key`.  O(1).
1221      *
1222      * Requirements:
1223      *
1224      * - `key` must be in the map.
1225      */
1226     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1227         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1228     }
1229 
1230     /**
1231      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1232      *
1233      * CAUTION: This function is deprecated because it requires allocating memory for the error
1234      * message unnecessarily. For custom revert reasons use {tryGet}.
1235      */
1236     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1237         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1238     }
1239 }
1240 
1241 /**
1242  * @dev String operations.
1243  */
1244 library Strings {
1245     /**
1246      * @dev Converts a `uint256` to its ASCII `string` representation.
1247      */
1248     function toString(uint256 value) internal pure returns (string memory) {
1249         // Inspired by OraclizeAPI's implementation - MIT licence
1250         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1251 
1252         if (value == 0) {
1253             return "0";
1254         }
1255         uint256 temp = value;
1256         uint256 digits;
1257         while (temp != 0) {
1258             digits++;
1259             temp /= 10;
1260         }
1261         bytes memory buffer = new bytes(digits);
1262         uint256 index = digits - 1;
1263         temp = value;
1264         while (temp != 0) {
1265             buffer[index--] = bytes1(uint8(48 + temp % 10));
1266             temp /= 10;
1267         }
1268         return string(buffer);
1269     }
1270 }
1271 
1272 
1273 /**
1274  * @title ERC721 Non-Fungible Token Standard basic implementation
1275  * @dev see https://eips.ethereum.org/EIPS/eip-721
1276  */
1277 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1278     using SafeMath for uint256;
1279     using Address for address;
1280     using EnumerableSet for EnumerableSet.UintSet;
1281     using EnumerableMap for EnumerableMap.UintToAddressMap;
1282     using Strings for uint256;
1283 
1284     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1285     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1286     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1287 
1288     // Mapping from holder address to their (enumerable) set of owned tokens
1289     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1290 
1291     // Enumerable mapping from token ids to their owners
1292     EnumerableMap.UintToAddressMap private _tokenOwners;
1293 
1294     // Mapping from token ID to approved address
1295     mapping (uint256 => address) private _tokenApprovals;
1296 
1297     // Mapping from owner to operator approvals
1298     mapping (address => mapping (address => bool)) private _operatorApprovals;
1299 
1300     // Token name
1301     string private _name;
1302 
1303     // Token symbol
1304     string private _symbol;
1305 
1306     // Optional mapping for token URIs
1307     mapping (uint256 => string) private _tokenURIs;
1308 
1309     // Base URI
1310     string private _baseURI;
1311 
1312     /*
1313      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1314      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1315      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1316      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1317      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1318      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1319      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1320      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1321      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1322      *
1323      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1324      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1325      */
1326     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1327 
1328     /*
1329      *     bytes4(keccak256('name()')) == 0x06fdde03
1330      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1331      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1332      *
1333      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1334      */
1335     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1336 
1337     /*
1338      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1339      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1340      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1341      *
1342      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1343      */
1344     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1345 
1346     /**
1347      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1348      */
1349     constructor (string memory name_, string memory symbol_) public {
1350         _name = name_;
1351         _symbol = symbol_;
1352 
1353         // register the supported interfaces to conform to ERC721 via ERC165
1354         _registerInterface(_INTERFACE_ID_ERC721);
1355         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1356         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-balanceOf}.
1361      */
1362     function balanceOf(address owner) public view virtual override returns (uint256) {
1363         require(owner != address(0), "ERC721: balance query for the zero address");
1364         return _holderTokens[owner].length();
1365     }
1366 
1367     /**
1368      * @dev See {IERC721-ownerOf}.
1369      */
1370     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1371         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1372     }
1373 
1374     /**
1375      * @dev See {IERC721Metadata-name}.
1376      */
1377     function name() public view virtual override returns (string memory) {
1378         return _name;
1379     }
1380 
1381     /**
1382      * @dev See {IERC721Metadata-symbol}.
1383      */
1384     function symbol() public view virtual override returns (string memory) {
1385         return _symbol;
1386     }
1387 
1388     /**
1389      * @dev See {IERC721Metadata-tokenURI}.
1390      */
1391     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1392         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1393 
1394         string memory _tokenURI = _tokenURIs[tokenId];
1395         string memory base = baseURI();
1396 
1397         // If there is no base URI, return the token URI.
1398         if (bytes(base).length == 0) {
1399             return _tokenURI;
1400         }
1401         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1402         if (bytes(_tokenURI).length > 0) {
1403             return string(abi.encodePacked(base, _tokenURI, '.json'));
1404         }
1405         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1406         return string(abi.encodePacked(base, (tokenId.toString())));
1407     }
1408 
1409     /**
1410     * @dev Returns the base URI set via {_setBaseURI}. This will be
1411     * automatically added as a prefix in {tokenURI} to each token's URI, or
1412     * to the token ID if no specific URI is set for that token ID.
1413     */
1414     function baseURI() public view virtual returns (string memory) {
1415         return _baseURI;
1416     }
1417 
1418     /**
1419      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1420      */
1421     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1422         return _holderTokens[owner].at(index);
1423     }
1424 
1425     /**
1426      * @dev See {IERC721Enumerable-totalSupply}.
1427      */
1428     function totalSupply() public view virtual override returns (uint256) {
1429         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1430         return _tokenOwners.length();
1431     }
1432 
1433     /**
1434      * @dev See {IERC721Enumerable-tokenByIndex}.
1435      */
1436     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1437         (uint256 tokenId, ) = _tokenOwners.at(index);
1438         return tokenId;
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-approve}.
1443      */
1444     function approve(address to, uint256 tokenId) public virtual override {
1445         address owner = ERC721.ownerOf(tokenId);
1446         require(to != owner, "ERC721: approval to current owner");
1447 
1448         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1449             "ERC721: approve caller is not owner nor approved for all"
1450         );
1451 
1452         _approve(to, tokenId);
1453     }
1454 
1455     /**
1456      * @dev See {IERC721-getApproved}.
1457      */
1458     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1459         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1460 
1461         return _tokenApprovals[tokenId];
1462     }
1463 
1464     /**
1465      * @dev See {IERC721-setApprovalForAll}.
1466      */
1467     function setApprovalForAll(address operator, bool approved) public virtual override {
1468         require(operator != _msgSender(), "ERC721: approve to caller");
1469 
1470         _operatorApprovals[_msgSender()][operator] = approved;
1471         emit ApprovalForAll(_msgSender(), operator, approved);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-isApprovedForAll}.
1476      */
1477     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1478         return _operatorApprovals[owner][operator];
1479     }
1480 
1481     /**
1482      * @dev See {IERC721-transferFrom}.
1483      */
1484     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1485         //solhint-disable-next-line max-line-length
1486         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1487 
1488         _transfer(from, to, tokenId);
1489     }
1490 
1491     /**
1492      * @dev See {IERC721-safeTransferFrom}.
1493      */
1494     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1495         safeTransferFrom(from, to, tokenId, "");
1496     }
1497 
1498     /**
1499      * @dev See {IERC721-safeTransferFrom}.
1500      */
1501     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1502         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1503         _safeTransfer(from, to, tokenId, _data);
1504     }
1505 
1506     /**
1507      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1508      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1509      *
1510      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1511      *
1512      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1513      * implement alternative mechanisms to perform token transfer, such as signature-based.
1514      *
1515      * Requirements:
1516      *
1517      * - `from` cannot be the zero address.
1518      * - `to` cannot be the zero address.
1519      * - `tokenId` token must exist and be owned by `from`.
1520      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1525         _transfer(from, to, tokenId);
1526         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1527     }
1528 
1529     /**
1530      * @dev Returns whether `tokenId` exists.
1531      *
1532      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1533      *
1534      * Tokens start existing when they are minted (`_mint`),
1535      * and stop existing when they are burned (`_burn`).
1536      */
1537     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1538         return _tokenOwners.contains(tokenId);
1539     }
1540 
1541     /**
1542      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1543      *
1544      * Requirements:
1545      *
1546      * - `tokenId` must exist.
1547      */
1548     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1549         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1550         address owner = ERC721.ownerOf(tokenId);
1551         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1552     }
1553 
1554     /**
1555      * @dev Safely mints `tokenId` and transfers it to `to`.
1556      *
1557      * Requirements:
1558      d*
1559      * - `tokenId` must not exist.
1560      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1561      *
1562      * Emits a {Transfer} event.
1563      */
1564     function _safeMint(address to, uint256 tokenId) internal virtual {
1565         _safeMint(to, tokenId, "");
1566     }
1567 
1568     /**
1569      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1570      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1571      */
1572     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1573         _mint(to, tokenId);
1574         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1575     }
1576 
1577     /**
1578      * @dev Mints `tokenId` and transfers it to `to`.
1579      *
1580      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1581      *
1582      * Requirements:
1583      *
1584      * - `tokenId` must not exist.
1585      * - `to` cannot be the zero address.
1586      *
1587      * Emits a {Transfer} event.
1588      */
1589     function _mint(address to, uint256 tokenId) internal virtual {
1590         require(to != address(0), "ERC721: mint to the zero address");
1591         require(!_exists(tokenId), "ERC721: token already minted");
1592 
1593         _beforeTokenTransfer(address(0), to, tokenId);
1594 
1595         _holderTokens[to].add(tokenId);
1596 
1597         _tokenOwners.set(tokenId, to);
1598 
1599         emit Transfer(address(0), to, tokenId);
1600     }
1601 
1602     /**
1603      * @dev Destroys `tokenId`.
1604      * The approval is cleared when the token is burned.
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must exist.
1609      *
1610      * Emits a {Transfer} event.
1611      */
1612     function _burn(uint256 tokenId) internal virtual {
1613         address owner = ERC721.ownerOf(tokenId); // internal owner
1614 
1615         _beforeTokenTransfer(owner, address(0), tokenId);
1616 
1617         // Clear approvals
1618         _approve(address(0), tokenId);
1619 
1620         // Clear metadata (if any)
1621         if (bytes(_tokenURIs[tokenId]).length != 0) {
1622             delete _tokenURIs[tokenId];
1623         }
1624 
1625         _holderTokens[owner].remove(tokenId);
1626 
1627         _tokenOwners.remove(tokenId);
1628 
1629         emit Transfer(owner, address(0), tokenId);
1630     }
1631 
1632     /**
1633      * @dev Transfers `tokenId` from `from` to `to`.
1634      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1635      *
1636      * Requirements:
1637      *
1638      * - `to` cannot be the zero address.
1639      * - `tokenId` token must be owned by `from`.
1640      *
1641      * Emits a {Transfer} event.
1642      */
1643     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1644         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1645         require(to != address(0), "ERC721: transfer to the zero address");
1646 
1647         _beforeTokenTransfer(from, to, tokenId);
1648 
1649         // Clear approvals from the previous owner
1650         _approve(address(0), tokenId);
1651 
1652         _holderTokens[from].remove(tokenId);
1653         _holderTokens[to].add(tokenId);
1654 
1655         _tokenOwners.set(tokenId, to);
1656 
1657         emit Transfer(from, to, tokenId);
1658     }
1659 
1660     /**
1661      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1662      *
1663      * Requirements:
1664      *
1665      * - `tokenId` must exist.
1666      */
1667     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1668         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1669         _tokenURIs[tokenId] = _tokenURI;
1670     }
1671 
1672     /**
1673      * @dev Internal function to set the base URI for all token IDs. It is
1674      * automatically added as a prefix to the value returned in {tokenURI},
1675      * or to the token ID if {tokenURI} is empty.
1676      */
1677     function _setBaseURI(string memory baseURI_) internal virtual {
1678         _baseURI = baseURI_;
1679     }
1680 
1681     /**
1682      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1683      * The call is not executed if the target address is not a contract.
1684      *
1685      * @param from address representing the previous owner of the given token ID
1686      * @param to target address that will receive the tokens
1687      * @param tokenId uint256 ID of the token to be transferred
1688      * @param _data bytes optional data to send along with the call
1689      * @return bool whether the call correctly returned the expected magic value
1690      */
1691     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1692         private returns (bool)
1693     {
1694         if (!to.isContract()) {
1695             return true;
1696         }
1697         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1698             IERC721Receiver(to).onERC721Received.selector,
1699             _msgSender(),
1700             from,
1701             tokenId,
1702             _data
1703         ), "ERC721: transfer to non ERC721Receiver implementer");
1704         bytes4 retval = abi.decode(returndata, (bytes4));
1705         return (retval == _ERC721_RECEIVED);
1706     }
1707 
1708     /**
1709      * @dev Approve `to` to operate on `tokenId`
1710      *
1711      * Emits an {Approval} event.
1712      */
1713     function _approve(address to, uint256 tokenId) internal virtual {
1714         _tokenApprovals[tokenId] = to;
1715         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1716     }
1717 
1718     /**
1719      * @dev Hook that is called before any token transfer. This includes minting
1720      * and burning.
1721      *
1722      * Calling conditions:
1723      *
1724      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1725      * transferred to `to`.
1726      * - When `from` is zero, `tokenId` will be minted for `to`.
1727      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1728      * - `from` cannot be the zero address.
1729      * - `to` cannot be the zero address.
1730      *
1731      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1732      */
1733     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1734 }
1735 
1736 /**
1737  * @dev Contract module which provides a basic access control mechanism, where
1738  * there is an account (an owner) that can be granted exclusive access to
1739  * specific functions.
1740  *
1741  * By default, the owner account will be the one that deploys the contract. This
1742  * can later be changed with {transferOwnership}.
1743  *
1744  * This module is used through inheritance. It will make available the modifier
1745  * `onlyOwner`, which can be applied to your functions to restrict their use to
1746  * the owner.
1747  */
1748 abstract contract Ownable is Context {
1749     address private _owner;
1750 
1751     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1752 
1753     /**
1754      * @dev Initializes the contract setting the deployer as the initial owner.
1755      */
1756     constructor () internal {
1757         address msgSender = _msgSender();
1758         _owner = msgSender;
1759         emit OwnershipTransferred(address(0), msgSender);
1760     }
1761 
1762     /**
1763      * @dev Returns the address of the current owner.
1764      */
1765     function owner() public view virtual returns (address) {
1766         return _owner;
1767     }
1768 
1769     /**
1770      * @dev Throws if called by any account other than the owner.
1771      */
1772     modifier onlyOwner() {
1773         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1774         _;
1775     }
1776 
1777     /**
1778      * @dev Leaves the contract without owner. It will not be possible to call
1779      * `onlyOwner` functions anymore. Can only be called by the current owner.
1780      *
1781      * NOTE: Renouncing ownership will leave the contract without an owner,
1782      * thereby removing any functionality that is only available to the owner.
1783      */
1784     function renounceOwnership() public virtual onlyOwner {
1785         emit OwnershipTransferred(_owner, address(0));
1786         _owner = address(0);
1787     }
1788 
1789     /**
1790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1791      * Can only be called by the current owner.
1792      */
1793     function transferOwnership(address newOwner) public virtual onlyOwner {
1794         require(newOwner != address(0), "Ownable: new owner is the zero address");
1795         emit OwnershipTransferred(_owner, newOwner);
1796         _owner = newOwner;
1797     }
1798 }
1799 
1800 contract KILLAz is ERC721, Ownable {
1801     using SafeMath for uint256;
1802 
1803     uint256 public immutable pricePerKILLA;
1804     uint256 public immutable maxPerTx;
1805     uint256 public immutable maxKILLAz;
1806     bool public isSaleActive;
1807     
1808     address private immutable reserveAddress;
1809 
1810     constructor(address _reserveAddress)
1811         public
1812         ERC721("KILLAz", "Kz")
1813     {
1814         pricePerKILLA = 0.029 * 10 ** 18;
1815         maxPerTx = 20;
1816         maxKILLAz = 9971;
1817         reserveAddress = _reserveAddress;
1818     }
1819 
1820     function flipSaleState() public onlyOwner {
1821         isSaleActive = !isSaleActive;
1822     }
1823 
1824     function setBaseURI(string memory baseURI) public onlyOwner {
1825         _setBaseURI(baseURI);
1826     }
1827 
1828     function reserveKILLAz() public onlyOwner {   
1829         require(totalSupply() < 100);
1830         for (uint256 i = 0; i < 50; i++) {
1831             uint256 mintIndex = totalSupply();
1832             _safeMint(reserveAddress, mintIndex);
1833         }
1834         
1835     }
1836 
1837      function mintKILLAz(uint256 numberOfTokens) public payable {
1838         require(isSaleActive, "Sale is not active");
1839         require(numberOfTokens <= maxPerTx, "No more than 20 tokens per transaction");
1840         require(totalSupply().add(numberOfTokens) <= maxKILLAz, "Purchase would exceed max supply of KILLAz");
1841         require(pricePerKILLA.mul(numberOfTokens) == msg.value, "Ether value is not correct");
1842         
1843         payable(owner()).transfer(msg.value);
1844 
1845         for (uint256 i = 0; i < numberOfTokens; i++) {
1846             uint256 mintIndex = totalSupply();
1847             if (totalSupply() < maxKILLAz) {
1848                 _safeMint(msg.sender, mintIndex);
1849             }
1850         }
1851     }
1852 }