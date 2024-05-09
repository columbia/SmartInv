1 // SPDX-License-Identifier: MIT
2 
3 // GO TO LINE 1904 TO SEE WHERE THE APE CONTRACT STARTS
4  
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/introspection/IERC165.sol
31 
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Interface of the ERC165 standard, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-165[EIP].
39  *
40  * Implementers can declare support of contract interfaces, which can then be
41  * queried by others ({ERC165Checker}).
42  *
43  * For an implementation, see {ERC165}.
44  */
45 interface IERC165 {
46     /**
47      * @dev Returns true if this contract implements the interface defined by
48      * `interfaceId`. See the corresponding
49      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
50      * to learn more about how these ids are created.
51      *
52      * This function call must use less than 30 000 gas.
53      */
54     function supportsInterface(bytes4 interfaceId) external view returns (bool);
55 }
56 
57 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
58 
59 
60 
61 pragma solidity >=0.6.2 <0.8.0;
62 
63 
64 /**
65  * @dev Required interface of an ERC721 compliant contract.
66  */
67 interface IERC721 is IERC165 {
68     /**
69      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
75      */
76     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
77 
78     /**
79      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
80      */
81     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
82 
83     /**
84      * @dev Returns the number of tokens in ``owner``'s account.
85      */
86     function balanceOf(address owner) external view returns (uint256 balance);
87 
88     /**
89      * @dev Returns the owner of the `tokenId` token.
90      *
91      * Requirements:
92      *
93      * - `tokenId` must exist.
94      */
95     function ownerOf(uint256 tokenId) external view returns (address owner);
96 
97     /**
98      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
99      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must exist and be owned by `from`.
106      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
108      *
109      * Emits a {Transfer} event.
110      */
111     function safeTransferFrom(address from, address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Transfers `tokenId` token from `from` to `to`.
115      *
116      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
117      *
118      * Requirements:
119      *
120      * - `from` cannot be the zero address.
121      * - `to` cannot be the zero address.
122      * - `tokenId` token must be owned by `from`.
123      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transferFrom(address from, address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
131      * The approval is cleared when the token is transferred.
132      *
133      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
134      *
135      * Requirements:
136      *
137      * - The caller must own the token or be an approved operator.
138      * - `tokenId` must exist.
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address to, uint256 tokenId) external;
143 
144     /**
145      * @dev Returns the account approved for `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function getApproved(uint256 tokenId) external view returns (address operator);
152 
153     /**
154      * @dev Approve or remove `operator` as an operator for the caller.
155      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
156      *
157      * Requirements:
158      *
159      * - The `operator` cannot be the caller.
160      *
161      * Emits an {ApprovalForAll} event.
162      */
163     function setApprovalForAll(address operator, bool _approved) external;
164 
165     /**
166      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
167      *
168      * See {setApprovalForAll}
169      */
170     function isApprovedForAll(address owner, address operator) external view returns (bool);
171 
172     /**
173       * @dev Safely transfers `tokenId` token from `from` to `to`.
174       *
175       * Requirements:
176       *
177       * - `from` cannot be the zero address.
178       * - `to` cannot be the zero address.
179       * - `tokenId` token must exist and be owned by `from`.
180       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182       *
183       * Emits a {Transfer} event.
184       */
185     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
189 
190 
191 
192 pragma solidity >=0.6.2 <0.8.0;
193 
194 
195 /**
196  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
197  * @dev See https://eips.ethereum.org/EIPS/eip-721
198  */
199 interface IERC721Metadata is IERC721 {
200 
201     /**
202      * @dev Returns the token collection name.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the token collection symbol.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
213      */
214     function tokenURI(uint256 tokenId) external view returns (string memory);
215 }
216 
217 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
218 
219 
220 
221 pragma solidity >=0.6.2 <0.8.0;
222 
223 
224 /**
225  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
226  * @dev See https://eips.ethereum.org/EIPS/eip-721
227  */
228 interface IERC721Enumerable is IERC721 {
229 
230     /**
231      * @dev Returns the total amount of tokens stored by the contract.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
237      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
238      */
239     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
240 
241     /**
242      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
243      * Use along with {totalSupply} to enumerate all tokens.
244      */
245     function tokenByIndex(uint256 index) external view returns (uint256);
246 }
247 
248 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
249 
250 
251 
252 pragma solidity >=0.6.0 <0.8.0;
253 
254 /**
255  * @title ERC721 token receiver interface
256  * @dev Interface for any contract that wants to support safeTransfers
257  * from ERC721 asset contracts.
258  */
259 interface IERC721Receiver {
260     /**
261      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
262      * by `operator` from `from`, this function is called.
263      *
264      * It must return its Solidity selector to confirm the token transfer.
265      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
266      *
267      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
268      */
269     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
270 }
271 
272 // File: @openzeppelin/contracts/introspection/ERC165.sol
273 
274 
275 
276 pragma solidity >=0.6.0 <0.8.0;
277 
278 
279 /**
280  * @dev Implementation of the {IERC165} interface.
281  *
282  * Contracts may inherit from this and call {_registerInterface} to declare
283  * their support of an interface.
284  */
285 abstract contract ERC165 is IERC165 {
286     /*
287      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
288      */
289     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
290 
291     /**
292      * @dev Mapping of interface ids to whether or not it's supported.
293      */
294     mapping(bytes4 => bool) private _supportedInterfaces;
295 
296     constructor () internal {
297         // Derived contracts need only register support for their own interfaces,
298         // we register support for ERC165 itself here
299         _registerInterface(_INTERFACE_ID_ERC165);
300     }
301 
302     /**
303      * @dev See {IERC165-supportsInterface}.
304      *
305      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
306      */
307     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
308         return _supportedInterfaces[interfaceId];
309     }
310 
311     /**
312      * @dev Registers the contract as an implementer of the interface defined by
313      * `interfaceId`. Support of the actual ERC165 interface is automatic and
314      * registering its interface id is not required.
315      *
316      * See {IERC165-supportsInterface}.
317      *
318      * Requirements:
319      *
320      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
321      */
322     function _registerInterface(bytes4 interfaceId) internal virtual {
323         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
324         _supportedInterfaces[interfaceId] = true;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/math/SafeMath.sol
329 
330 
331 
332 pragma solidity >=0.6.0 <0.8.0;
333 
334 /**
335  * @dev Wrappers over Solidity's arithmetic operations with added overflow
336  * checks.
337  *
338  * Arithmetic operations in Solidity wrap on overflow. This can easily result
339  * in bugs, because programmers usually assume that an overflow raises an
340  * error, which is the standard behavior in high level programming languages.
341  * `SafeMath` restores this intuition by reverting the transaction when an
342  * operation overflows.
343  *
344  * Using this library instead of the unchecked operations eliminates an entire
345  * class of bugs, so it's recommended to use it always.
346  */
347 library SafeMath {
348     /**
349      * @dev Returns the addition of two unsigned integers, with an overflow flag.
350      *
351      * _Available since v3.4._
352      */
353     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         uint256 c = a + b;
355         if (c < a) return (false, 0);
356         return (true, c);
357     }
358 
359     /**
360      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
361      *
362      * _Available since v3.4._
363      */
364     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
365         if (b > a) return (false, 0);
366         return (true, a - b);
367     }
368 
369     /**
370      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
376         // benefit is lost if 'b' is also tested.
377         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
378         if (a == 0) return (true, 0);
379         uint256 c = a * b;
380         if (c / a != b) return (false, 0);
381         return (true, c);
382     }
383 
384     /**
385      * @dev Returns the division of two unsigned integers, with a division by zero flag.
386      *
387      * _Available since v3.4._
388      */
389     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
390         if (b == 0) return (false, 0);
391         return (true, a / b);
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
396      *
397      * _Available since v3.4._
398      */
399     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
400         if (b == 0) return (false, 0);
401         return (true, a % b);
402     }
403 
404     /**
405      * @dev Returns the addition of two unsigned integers, reverting on
406      * overflow.
407      *
408      * Counterpart to Solidity's `+` operator.
409      *
410      * Requirements:
411      *
412      * - Addition cannot overflow.
413      */
414     function add(uint256 a, uint256 b) internal pure returns (uint256) {
415         uint256 c = a + b;
416         require(c >= a, "SafeMath: addition overflow");
417         return c;
418     }
419 
420     /**
421      * @dev Returns the subtraction of two unsigned integers, reverting on
422      * overflow (when the result is negative).
423      *
424      * Counterpart to Solidity's `-` operator.
425      *
426      * Requirements:
427      *
428      * - Subtraction cannot overflow.
429      */
430     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
431         require(b <= a, "SafeMath: subtraction overflow");
432         return a - b;
433     }
434 
435     /**
436      * @dev Returns the multiplication of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `*` operator.
440      *
441      * Requirements:
442      *
443      * - Multiplication cannot overflow.
444      */
445     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
446         if (a == 0) return 0;
447         uint256 c = a * b;
448         require(c / a == b, "SafeMath: multiplication overflow");
449         return c;
450     }
451 
452     /**
453      * @dev Returns the integer division of two unsigned integers, reverting on
454      * division by zero. The result is rounded towards zero.
455      *
456      * Counterpart to Solidity's `/` operator. Note: this function uses a
457      * `revert` opcode (which leaves remaining gas untouched) while Solidity
458      * uses an invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function div(uint256 a, uint256 b) internal pure returns (uint256) {
465         require(b > 0, "SafeMath: division by zero");
466         return a / b;
467     }
468 
469     /**
470      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
471      * reverting when dividing by zero.
472      *
473      * Counterpart to Solidity's `%` operator. This function uses a `revert`
474      * opcode (which leaves remaining gas untouched) while Solidity uses an
475      * invalid opcode to revert (consuming all remaining gas).
476      *
477      * Requirements:
478      *
479      * - The divisor cannot be zero.
480      */
481     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
482         require(b > 0, "SafeMath: modulo by zero");
483         return a % b;
484     }
485 
486     /**
487      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
488      * overflow (when the result is negative).
489      *
490      * CAUTION: This function is deprecated because it requires allocating memory for the error
491      * message unnecessarily. For custom revert reasons use {trySub}.
492      *
493      * Counterpart to Solidity's `-` operator.
494      *
495      * Requirements:
496      *
497      * - Subtraction cannot overflow.
498      */
499     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b <= a, errorMessage);
501         return a - b;
502     }
503 
504     /**
505      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
506      * division by zero. The result is rounded towards zero.
507      *
508      * CAUTION: This function is deprecated because it requires allocating memory for the error
509      * message unnecessarily. For custom revert reasons use {tryDiv}.
510      *
511      * Counterpart to Solidity's `/` operator. Note: this function uses a
512      * `revert` opcode (which leaves remaining gas untouched) while Solidity
513      * uses an invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      *
517      * - The divisor cannot be zero.
518      */
519     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
520         require(b > 0, errorMessage);
521         return a / b;
522     }
523 
524     /**
525      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
526      * reverting with custom message when dividing by zero.
527      *
528      * CAUTION: This function is deprecated because it requires allocating memory for the error
529      * message unnecessarily. For custom revert reasons use {tryMod}.
530      *
531      * Counterpart to Solidity's `%` operator. This function uses a `revert`
532      * opcode (which leaves remaining gas untouched) while Solidity uses an
533      * invalid opcode to revert (consuming all remaining gas).
534      *
535      * Requirements:
536      *
537      * - The divisor cannot be zero.
538      */
539     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
540         require(b > 0, errorMessage);
541         return a % b;
542     }
543 }
544 
545 // File: @openzeppelin/contracts/utils/Address.sol
546 
547 
548 
549 pragma solidity >=0.6.2 <0.8.0;
550 
551 /**
552  * @dev Collection of functions related to the address type
553  */
554 library Address {
555     /**
556      * @dev Returns true if `account` is a contract.
557      *
558      * [IMPORTANT]
559      * ====
560      * It is unsafe to assume that an address for which this function returns
561      * false is an externally-owned account (EOA) and not a contract.
562      *
563      * Among others, `isContract` will return false for the following
564      * types of addresses:
565      *
566      *  - an externally-owned account
567      *  - a contract in construction
568      *  - an address where a contract will be created
569      *  - an address where a contract lived, but was destroyed
570      * ====
571      */
572     function isContract(address account) internal view returns (bool) {
573         // This method relies on extcodesize, which returns 0 for contracts in
574         // construction, since the code is only stored at the end of the
575         // constructor execution.
576 
577         uint256 size;
578         // solhint-disable-next-line no-inline-assembly
579         assembly { size := extcodesize(account) }
580         return size > 0;
581     }
582 
583     /**
584      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
585      * `recipient`, forwarding all available gas and reverting on errors.
586      *
587      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
588      * of certain opcodes, possibly making contracts go over the 2300 gas limit
589      * imposed by `transfer`, making them unable to receive funds via
590      * `transfer`. {sendValue} removes this limitation.
591      *
592      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
593      *
594      * IMPORTANT: because control is transferred to `recipient`, care must be
595      * taken to not create reentrancy vulnerabilities. Consider using
596      * {ReentrancyGuard} or the
597      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
598      */
599     function sendValue(address payable recipient, uint256 amount) internal {
600         require(address(this).balance >= amount, "Address: insufficient balance");
601 
602         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
603         (bool success, ) = recipient.call{ value: amount }("");
604         require(success, "Address: unable to send value, recipient may have reverted");
605     }
606 
607     /**
608      * @dev Performs a Solidity function call using a low level `call`. A
609      * plain`call` is an unsafe replacement for a function call: use this
610      * function instead.
611      *
612      * If `target` reverts with a revert reason, it is bubbled up by this
613      * function (like regular Solidity function calls).
614      *
615      * Returns the raw returned data. To convert to the expected return value,
616      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
617      *
618      * Requirements:
619      *
620      * - `target` must be a contract.
621      * - calling `target` with `data` must not revert.
622      *
623      * _Available since v3.1._
624      */
625     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
626       return functionCall(target, data, "Address: low-level call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
631      * `errorMessage` as a fallback revert reason when `target` reverts.
632      *
633      * _Available since v3.1._
634      */
635     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
636         return functionCallWithValue(target, data, 0, errorMessage);
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
641      * but also transferring `value` wei to `target`.
642      *
643      * Requirements:
644      *
645      * - the calling contract must have an ETH balance of at least `value`.
646      * - the called Solidity function must be `payable`.
647      *
648      * _Available since v3.1._
649      */
650     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
651         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
656      * with `errorMessage` as a fallback revert reason when `target` reverts.
657      *
658      * _Available since v3.1._
659      */
660     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
661         require(address(this).balance >= value, "Address: insufficient balance for call");
662         require(isContract(target), "Address: call to non-contract");
663 
664         // solhint-disable-next-line avoid-low-level-calls
665         (bool success, bytes memory returndata) = target.call{ value: value }(data);
666         return _verifyCallResult(success, returndata, errorMessage);
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
671      * but performing a static call.
672      *
673      * _Available since v3.3._
674      */
675     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
676         return functionStaticCall(target, data, "Address: low-level static call failed");
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
681      * but performing a static call.
682      *
683      * _Available since v3.3._
684      */
685     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
686         require(isContract(target), "Address: static call to non-contract");
687 
688         // solhint-disable-next-line avoid-low-level-calls
689         (bool success, bytes memory returndata) = target.staticcall(data);
690         return _verifyCallResult(success, returndata, errorMessage);
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
695      * but performing a delegate call.
696      *
697      * _Available since v3.4._
698      */
699     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
700         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
705      * but performing a delegate call.
706      *
707      * _Available since v3.4._
708      */
709     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
710         require(isContract(target), "Address: delegate call to non-contract");
711 
712         // solhint-disable-next-line avoid-low-level-calls
713         (bool success, bytes memory returndata) = target.delegatecall(data);
714         return _verifyCallResult(success, returndata, errorMessage);
715     }
716 
717     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
718         if (success) {
719             return returndata;
720         } else {
721             // Look for revert reason and bubble it up if present
722             if (returndata.length > 0) {
723                 // The easiest way to bubble the revert reason is using memory via assembly
724 
725                 // solhint-disable-next-line no-inline-assembly
726                 assembly {
727                     let returndata_size := mload(returndata)
728                     revert(add(32, returndata), returndata_size)
729                 }
730             } else {
731                 revert(errorMessage);
732             }
733         }
734     }
735 }
736 
737 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
738 
739 
740 
741 pragma solidity >=0.6.0 <0.8.0;
742 
743 /**
744  * @dev Library for managing
745  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
746  * types.
747  *
748  * Sets have the following properties:
749  *
750  * - Elements are added, removed, and checked for existence in constant time
751  * (O(1)).
752  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
753  *
754  * ```
755  * contract Example {
756  *     // Add the library methods
757  *     using EnumerableSet for EnumerableSet.AddressSet;
758  *
759  *     // Declare a set state variable
760  *     EnumerableSet.AddressSet private mySet;
761  * }
762  * ```
763  *
764  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
765  * and `uint256` (`UintSet`) are supported.
766  */
767 library EnumerableSet {
768     // To implement this library for multiple types with as little code
769     // repetition as possible, we write it in terms of a generic Set type with
770     // bytes32 values.
771     // The Set implementation uses private functions, and user-facing
772     // implementations (such as AddressSet) are just wrappers around the
773     // underlying Set.
774     // This means that we can only create new EnumerableSets for types that fit
775     // in bytes32.
776 
777     struct Set {
778         // Storage of set values
779         bytes32[] _values;
780 
781         // Position of the value in the `values` array, plus 1 because index 0
782         // means a value is not in the set.
783         mapping (bytes32 => uint256) _indexes;
784     }
785 
786     /**
787      * @dev Add a value to a set. O(1).
788      *
789      * Returns true if the value was added to the set, that is if it was not
790      * already present.
791      */
792     function _add(Set storage set, bytes32 value) private returns (bool) {
793         if (!_contains(set, value)) {
794             set._values.push(value);
795             // The value is stored at length-1, but we add 1 to all indexes
796             // and use 0 as a sentinel value
797             set._indexes[value] = set._values.length;
798             return true;
799         } else {
800             return false;
801         }
802     }
803 
804     /**
805      * @dev Removes a value from a set. O(1).
806      *
807      * Returns true if the value was removed from the set, that is if it was
808      * present.
809      */
810     function _remove(Set storage set, bytes32 value) private returns (bool) {
811         // We read and store the value's index to prevent multiple reads from the same storage slot
812         uint256 valueIndex = set._indexes[value];
813 
814         if (valueIndex != 0) { // Equivalent to contains(set, value)
815             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
816             // the array, and then remove the last element (sometimes called as 'swap and pop').
817             // This modifies the order of the array, as noted in {at}.
818 
819             uint256 toDeleteIndex = valueIndex - 1;
820             uint256 lastIndex = set._values.length - 1;
821 
822             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
823             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
824 
825             bytes32 lastvalue = set._values[lastIndex];
826 
827             // Move the last value to the index where the value to delete is
828             set._values[toDeleteIndex] = lastvalue;
829             // Update the index for the moved value
830             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
831 
832             // Delete the slot where the moved value was stored
833             set._values.pop();
834 
835             // Delete the index for the deleted slot
836             delete set._indexes[value];
837 
838             return true;
839         } else {
840             return false;
841         }
842     }
843 
844     /**
845      * @dev Returns true if the value is in the set. O(1).
846      */
847     function _contains(Set storage set, bytes32 value) private view returns (bool) {
848         return set._indexes[value] != 0;
849     }
850 
851     /**
852      * @dev Returns the number of values on the set. O(1).
853      */
854     function _length(Set storage set) private view returns (uint256) {
855         return set._values.length;
856     }
857 
858    /**
859     * @dev Returns the value stored at position `index` in the set. O(1).
860     *
861     * Note that there are no guarantees on the ordering of values inside the
862     * array, and it may change when more values are added or removed.
863     *
864     * Requirements:
865     *
866     * - `index` must be strictly less than {length}.
867     */
868     function _at(Set storage set, uint256 index) private view returns (bytes32) {
869         require(set._values.length > index, "EnumerableSet: index out of bounds");
870         return set._values[index];
871     }
872 
873     // Bytes32Set
874 
875     struct Bytes32Set {
876         Set _inner;
877     }
878 
879     /**
880      * @dev Add a value to a set. O(1).
881      *
882      * Returns true if the value was added to the set, that is if it was not
883      * already present.
884      */
885     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
886         return _add(set._inner, value);
887     }
888 
889     /**
890      * @dev Removes a value from a set. O(1).
891      *
892      * Returns true if the value was removed from the set, that is if it was
893      * present.
894      */
895     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
896         return _remove(set._inner, value);
897     }
898 
899     /**
900      * @dev Returns true if the value is in the set. O(1).
901      */
902     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
903         return _contains(set._inner, value);
904     }
905 
906     /**
907      * @dev Returns the number of values in the set. O(1).
908      */
909     function length(Bytes32Set storage set) internal view returns (uint256) {
910         return _length(set._inner);
911     }
912 
913    /**
914     * @dev Returns the value stored at position `index` in the set. O(1).
915     *
916     * Note that there are no guarantees on the ordering of values inside the
917     * array, and it may change when more values are added or removed.
918     *
919     * Requirements:
920     *
921     * - `index` must be strictly less than {length}.
922     */
923     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
924         return _at(set._inner, index);
925     }
926 
927     // AddressSet
928 
929     struct AddressSet {
930         Set _inner;
931     }
932 
933     /**
934      * @dev Add a value to a set. O(1).
935      *
936      * Returns true if the value was added to the set, that is if it was not
937      * already present.
938      */
939     function add(AddressSet storage set, address value) internal returns (bool) {
940         return _add(set._inner, bytes32(uint256(uint160(value))));
941     }
942 
943     /**
944      * @dev Removes a value from a set. O(1).
945      *
946      * Returns true if the value was removed from the set, that is if it was
947      * present.
948      */
949     function remove(AddressSet storage set, address value) internal returns (bool) {
950         return _remove(set._inner, bytes32(uint256(uint160(value))));
951     }
952 
953     /**
954      * @dev Returns true if the value is in the set. O(1).
955      */
956     function contains(AddressSet storage set, address value) internal view returns (bool) {
957         return _contains(set._inner, bytes32(uint256(uint160(value))));
958     }
959 
960     /**
961      * @dev Returns the number of values in the set. O(1).
962      */
963     function length(AddressSet storage set) internal view returns (uint256) {
964         return _length(set._inner);
965     }
966 
967    /**
968     * @dev Returns the value stored at position `index` in the set. O(1).
969     *
970     * Note that there are no guarantees on the ordering of values inside the
971     * array, and it may change when more values are added or removed.
972     *
973     * Requirements:
974     *
975     * - `index` must be strictly less than {length}.
976     */
977     function at(AddressSet storage set, uint256 index) internal view returns (address) {
978         return address(uint160(uint256(_at(set._inner, index))));
979     }
980 
981 
982     // UintSet
983 
984     struct UintSet {
985         Set _inner;
986     }
987 
988     /**
989      * @dev Add a value to a set. O(1).
990      *
991      * Returns true if the value was added to the set, that is if it was not
992      * already present.
993      */
994     function add(UintSet storage set, uint256 value) internal returns (bool) {
995         return _add(set._inner, bytes32(value));
996     }
997 
998     /**
999      * @dev Removes a value from a set. O(1).
1000      *
1001      * Returns true if the value was removed from the set, that is if it was
1002      * present.
1003      */
1004     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1005         return _remove(set._inner, bytes32(value));
1006     }
1007 
1008     /**
1009      * @dev Returns true if the value is in the set. O(1).
1010      */
1011     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1012         return _contains(set._inner, bytes32(value));
1013     }
1014 
1015     /**
1016      * @dev Returns the number of values on the set. O(1).
1017      */
1018     function length(UintSet storage set) internal view returns (uint256) {
1019         return _length(set._inner);
1020     }
1021 
1022    /**
1023     * @dev Returns the value stored at position `index` in the set. O(1).
1024     *
1025     * Note that there are no guarantees on the ordering of values inside the
1026     * array, and it may change when more values are added or removed.
1027     *
1028     * Requirements:
1029     *
1030     * - `index` must be strictly less than {length}.
1031     */
1032     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1033         return uint256(_at(set._inner, index));
1034     }
1035 }
1036 
1037 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1038 
1039 
1040 
1041 pragma solidity >=0.6.0 <0.8.0;
1042 
1043 /**
1044  * @dev Library for managing an enumerable variant of Solidity's
1045  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1046  * type.
1047  *
1048  * Maps have the following properties:
1049  *
1050  * - Entries are added, removed, and checked for existence in constant time
1051  * (O(1)).
1052  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1053  *
1054  * ```
1055  * contract Example {
1056  *     // Add the library methods
1057  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1058  *
1059  *     // Declare a set state variable
1060  *     EnumerableMap.UintToAddressMap private myMap;
1061  * }
1062  * ```
1063  *
1064  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1065  * supported.
1066  */
1067 library EnumerableMap {
1068     // To implement this library for multiple types with as little code
1069     // repetition as possible, we write it in terms of a generic Map type with
1070     // bytes32 keys and values.
1071     // The Map implementation uses private functions, and user-facing
1072     // implementations (such as Uint256ToAddressMap) are just wrappers around
1073     // the underlying Map.
1074     // This means that we can only create new EnumerableMaps for types that fit
1075     // in bytes32.
1076 
1077     struct MapEntry {
1078         bytes32 _key;
1079         bytes32 _value;
1080     }
1081 
1082     struct Map {
1083         // Storage of map keys and values
1084         MapEntry[] _entries;
1085 
1086         // Position of the entry defined by a key in the `entries` array, plus 1
1087         // because index 0 means a key is not in the map.
1088         mapping (bytes32 => uint256) _indexes;
1089     }
1090 
1091     /**
1092      * @dev Adds a key-value pair to a map, or updates the value for an existing
1093      * key. O(1).
1094      *
1095      * Returns true if the key was added to the map, that is if it was not
1096      * already present.
1097      */
1098     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1099         // We read and store the key's index to prevent multiple reads from the same storage slot
1100         uint256 keyIndex = map._indexes[key];
1101 
1102         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1103             map._entries.push(MapEntry({ _key: key, _value: value }));
1104             // The entry is stored at length-1, but we add 1 to all indexes
1105             // and use 0 as a sentinel value
1106             map._indexes[key] = map._entries.length;
1107             return true;
1108         } else {
1109             map._entries[keyIndex - 1]._value = value;
1110             return false;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Removes a key-value pair from a map. O(1).
1116      *
1117      * Returns true if the key was removed from the map, that is if it was present.
1118      */
1119     function _remove(Map storage map, bytes32 key) private returns (bool) {
1120         // We read and store the key's index to prevent multiple reads from the same storage slot
1121         uint256 keyIndex = map._indexes[key];
1122 
1123         if (keyIndex != 0) { // Equivalent to contains(map, key)
1124             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1125             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1126             // This modifies the order of the array, as noted in {at}.
1127 
1128             uint256 toDeleteIndex = keyIndex - 1;
1129             uint256 lastIndex = map._entries.length - 1;
1130 
1131             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1132             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1133 
1134             MapEntry storage lastEntry = map._entries[lastIndex];
1135 
1136             // Move the last entry to the index where the entry to delete is
1137             map._entries[toDeleteIndex] = lastEntry;
1138             // Update the index for the moved entry
1139             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1140 
1141             // Delete the slot where the moved entry was stored
1142             map._entries.pop();
1143 
1144             // Delete the index for the deleted slot
1145             delete map._indexes[key];
1146 
1147             return true;
1148         } else {
1149             return false;
1150         }
1151     }
1152 
1153     /**
1154      * @dev Returns true if the key is in the map. O(1).
1155      */
1156     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1157         return map._indexes[key] != 0;
1158     }
1159 
1160     /**
1161      * @dev Returns the number of key-value pairs in the map. O(1).
1162      */
1163     function _length(Map storage map) private view returns (uint256) {
1164         return map._entries.length;
1165     }
1166 
1167    /**
1168     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1169     *
1170     * Note that there are no guarantees on the ordering of entries inside the
1171     * array, and it may change when more entries are added or removed.
1172     *
1173     * Requirements:
1174     *
1175     * - `index` must be strictly less than {length}.
1176     */
1177     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1178         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1179 
1180         MapEntry storage entry = map._entries[index];
1181         return (entry._key, entry._value);
1182     }
1183 
1184     /**
1185      * @dev Tries to returns the value associated with `key`.  O(1).
1186      * Does not revert if `key` is not in the map.
1187      */
1188     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1189         uint256 keyIndex = map._indexes[key];
1190         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1191         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1192     }
1193 
1194     /**
1195      * @dev Returns the value associated with `key`.  O(1).
1196      *
1197      * Requirements:
1198      *
1199      * - `key` must be in the map.
1200      */
1201     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1202         uint256 keyIndex = map._indexes[key];
1203         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1204         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1205     }
1206 
1207     /**
1208      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1209      *
1210      * CAUTION: This function is deprecated because it requires allocating memory for the error
1211      * message unnecessarily. For custom revert reasons use {_tryGet}.
1212      */
1213     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1214         uint256 keyIndex = map._indexes[key];
1215         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1216         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1217     }
1218 
1219     // UintToAddressMap
1220 
1221     struct UintToAddressMap {
1222         Map _inner;
1223     }
1224 
1225     /**
1226      * @dev Adds a key-value pair to a map, or updates the value for an existing
1227      * key. O(1).
1228      *
1229      * Returns true if the key was added to the map, that is if it was not
1230      * already present.
1231      */
1232     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1233         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1234     }
1235 
1236     /**
1237      * @dev Removes a value from a set. O(1).
1238      *
1239      * Returns true if the key was removed from the map, that is if it was present.
1240      */
1241     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1242         return _remove(map._inner, bytes32(key));
1243     }
1244 
1245     /**
1246      * @dev Returns true if the key is in the map. O(1).
1247      */
1248     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1249         return _contains(map._inner, bytes32(key));
1250     }
1251 
1252     /**
1253      * @dev Returns the number of elements in the map. O(1).
1254      */
1255     function length(UintToAddressMap storage map) internal view returns (uint256) {
1256         return _length(map._inner);
1257     }
1258 
1259    /**
1260     * @dev Returns the element stored at position `index` in the set. O(1).
1261     * Note that there are no guarantees on the ordering of values inside the
1262     * array, and it may change when more values are added or removed.
1263     *
1264     * Requirements:
1265     *
1266     * - `index` must be strictly less than {length}.
1267     */
1268     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1269         (bytes32 key, bytes32 value) = _at(map._inner, index);
1270         return (uint256(key), address(uint160(uint256(value))));
1271     }
1272 
1273     /**
1274      * @dev Tries to returns the value associated with `key`.  O(1).
1275      * Does not revert if `key` is not in the map.
1276      *
1277      * _Available since v3.4._
1278      */
1279     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1280         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1281         return (success, address(uint160(uint256(value))));
1282     }
1283 
1284     /**
1285      * @dev Returns the value associated with `key`.  O(1).
1286      *
1287      * Requirements:
1288      *
1289      * - `key` must be in the map.
1290      */
1291     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1292         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1293     }
1294 
1295     /**
1296      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1297      *
1298      * CAUTION: This function is deprecated because it requires allocating memory for the error
1299      * message unnecessarily. For custom revert reasons use {tryGet}.
1300      */
1301     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1302         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1303     }
1304 }
1305 
1306 // File: @openzeppelin/contracts/utils/Strings.sol
1307 
1308 
1309 
1310 pragma solidity >=0.6.0 <0.8.0;
1311 
1312 /**
1313  * @dev String operations.
1314  */
1315 library Strings {
1316     /**
1317      * @dev Converts a `uint256` to its ASCII `string` representation.
1318      */
1319     function toString(uint256 value) internal pure returns (string memory) {
1320         // Inspired by OraclizeAPI's implementation - MIT licence
1321         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1322 
1323         if (value == 0) {
1324             return "0";
1325         }
1326         uint256 temp = value;
1327         uint256 digits;
1328         while (temp != 0) {
1329             digits++;
1330             temp /= 10;
1331         }
1332         bytes memory buffer = new bytes(digits);
1333         uint256 index = digits - 1;
1334         temp = value;
1335         while (temp != 0) {
1336             buffer[index--] = bytes1(uint8(48 + temp % 10));
1337             temp /= 10;
1338         }
1339         return string(buffer);
1340     }
1341 }
1342 
1343 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1344 
1345 
1346 
1347 pragma solidity >=0.6.0 <0.8.0;
1348 
1349 /**
1350  * @title ERC721 Non-Fungible Token Standard basic implementation
1351  * @dev see https://eips.ethereum.org/EIPS/eip-721
1352  */
1353  
1354 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1355     using SafeMath for uint256;
1356     using Address for address;
1357     using EnumerableSet for EnumerableSet.UintSet;
1358     using EnumerableMap for EnumerableMap.UintToAddressMap;
1359     using Strings for uint256;
1360 
1361     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1362     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1363     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1364 
1365     // Mapping from holder address to their (enumerable) set of owned tokens
1366     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1367 
1368     // Enumerable mapping from token ids to their owners
1369     EnumerableMap.UintToAddressMap private _tokenOwners;
1370 
1371     // Mapping from token ID to approved address
1372     mapping (uint256 => address) private _tokenApprovals;
1373 
1374     // Mapping from owner to operator approvals
1375     mapping (address => mapping (address => bool)) private _operatorApprovals;
1376 
1377     // Token name
1378     string private _name;
1379 
1380     // Token symbol
1381     string private _symbol;
1382 
1383     // Optional mapping for token URIs
1384     mapping (uint256 => string) private _tokenURIs;
1385 
1386     // Base URI
1387     string private _baseURI;
1388 
1389     /*
1390      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1391      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1392      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1393      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1394      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1395      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1396      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1397      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1398      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1399      *
1400      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1401      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1402      */
1403     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1404 
1405     /*
1406      *     bytes4(keccak256('name()')) == 0x06fdde03
1407      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1408      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1409      *
1410      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1411      */
1412     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1413 
1414     /*
1415      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1416      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1417      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1418      *
1419      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1420      */
1421     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1422 
1423     /**
1424      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1425      */
1426     constructor (string memory name_, string memory symbol_) public {
1427         _name = name_;
1428         _symbol = symbol_;
1429 
1430         // register the supported interfaces to conform to ERC721 via ERC165
1431         _registerInterface(_INTERFACE_ID_ERC721);
1432         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1433         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1434     }
1435 
1436     /**
1437      * @dev See {IERC721-balanceOf}.
1438      */
1439     function balanceOf(address owner) public view virtual override returns (uint256) {
1440         require(owner != address(0), "ERC721: balance query for the zero address");
1441         return _holderTokens[owner].length();
1442     }
1443 
1444     /**
1445      * @dev See {IERC721-ownerOf}.
1446      */
1447     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1448         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1449     }
1450 
1451     /**
1452      * @dev See {IERC721Metadata-name}.
1453      */
1454     function name() public view virtual override returns (string memory) {
1455         return _name;
1456     }
1457 
1458     /**
1459      * @dev See {IERC721Metadata-symbol}.
1460      */
1461     function symbol() public view virtual override returns (string memory) {
1462         return _symbol;
1463     }
1464 
1465     /**
1466      * @dev See {IERC721Metadata-tokenURI}.
1467      */
1468     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1469         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1470 
1471         string memory _tokenURI = _tokenURIs[tokenId];
1472         string memory base = baseURI();
1473 
1474         // If there is no base URI, return the token URI.
1475         if (bytes(base).length == 0) {
1476             return _tokenURI;
1477         }
1478         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1479         if (bytes(_tokenURI).length > 0) {
1480             return string(abi.encodePacked(base, _tokenURI));
1481         }
1482         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1483         return string(abi.encodePacked(base, tokenId.toString()));
1484     }
1485 
1486     /**
1487     * @dev Returns the base URI set via {_setBaseURI}. This will be
1488     * automatically added as a prefix in {tokenURI} to each token's URI, or
1489     * to the token ID if no specific URI is set for that token ID.
1490     */
1491     function baseURI() public view virtual returns (string memory) {
1492         return _baseURI;
1493     }
1494 
1495     /**
1496      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1497      */
1498     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1499         return _holderTokens[owner].at(index);
1500     }
1501 
1502     /**
1503      * @dev See {IERC721Enumerable-totalSupply}.
1504      */
1505     function totalSupply() public view virtual override returns (uint256) {
1506         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1507         return _tokenOwners.length();
1508     }
1509 
1510     /**
1511      * @dev See {IERC721Enumerable-tokenByIndex}.
1512      */
1513     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1514         (uint256 tokenId, ) = _tokenOwners.at(index);
1515         return tokenId;
1516     }
1517 
1518     /**
1519      * @dev See {IERC721-approve}.
1520      */
1521     function approve(address to, uint256 tokenId) public virtual override {
1522         address owner = ERC721.ownerOf(tokenId);
1523         require(to != owner, "ERC721: approval to current owner");
1524 
1525         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1526             "ERC721: approve caller is not owner nor approved for all"
1527         );
1528 
1529         _approve(to, tokenId);
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-getApproved}.
1534      */
1535     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1536         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1537 
1538         return _tokenApprovals[tokenId];
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-setApprovalForAll}.
1543      */
1544     function setApprovalForAll(address operator, bool approved) public virtual override {
1545         require(operator != _msgSender(), "ERC721: approve to caller");
1546 
1547         _operatorApprovals[_msgSender()][operator] = approved;
1548         emit ApprovalForAll(_msgSender(), operator, approved);
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-isApprovedForAll}.
1553      */
1554     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1555         return _operatorApprovals[owner][operator];
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-transferFrom}.
1560      */
1561     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1562         //solhint-disable-next-line max-line-length
1563         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1564 
1565         _transfer(from, to, tokenId);
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-safeTransferFrom}.
1570      */
1571     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1572         safeTransferFrom(from, to, tokenId, "");
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-safeTransferFrom}.
1577      */
1578     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1579         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1580         _safeTransfer(from, to, tokenId, _data);
1581     }
1582 
1583     /**
1584      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1585      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1586      *
1587      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1588      *
1589      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1590      * implement alternative mechanisms to perform token transfer, such as signature-based.
1591      *
1592      * Requirements:
1593      *
1594      * - `from` cannot be the zero address.
1595      * - `to` cannot be the zero address.
1596      * - `tokenId` token must exist and be owned by `from`.
1597      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1598      *
1599      * Emits a {Transfer} event.
1600      */
1601     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1602         _transfer(from, to, tokenId);
1603         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1604     }
1605 
1606     /**
1607      * @dev Returns whether `tokenId` exists.
1608      *
1609      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1610      *
1611      * Tokens start existing when they are minted (`_mint`),
1612      * and stop existing when they are burned (`_burn`).
1613      */
1614     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1615         return _tokenOwners.contains(tokenId);
1616     }
1617 
1618     /**
1619      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must exist.
1624      */
1625     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1626         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1627         address owner = ERC721.ownerOf(tokenId);
1628         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1629     }
1630 
1631     /**
1632      * @dev Safely mints `tokenId` and transfers it to `to`.
1633      *
1634      * Requirements:
1635      d*
1636      * - `tokenId` must not exist.
1637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1638      *
1639      * Emits a {Transfer} event.
1640      */
1641     function _safeMint(address to, uint256 tokenId) internal virtual {
1642         _safeMint(to, tokenId, "");
1643     }
1644 
1645     /**
1646      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1647      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1648      */
1649     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1650         _mint(to, tokenId);
1651         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1652     }
1653 
1654     /**
1655      * @dev Mints `tokenId` and transfers it to `to`.
1656      *
1657      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1658      *
1659      * Requirements:
1660      *
1661      * - `tokenId` must not exist.
1662      * - `to` cannot be the zero address.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function _mint(address to, uint256 tokenId) internal virtual {
1667         require(to != address(0), "ERC721: mint to the zero address");
1668         require(!_exists(tokenId), "ERC721: token already minted");
1669 
1670         _beforeTokenTransfer(address(0), to, tokenId);
1671 
1672         _holderTokens[to].add(tokenId);
1673 
1674         _tokenOwners.set(tokenId, to);
1675 
1676         emit Transfer(address(0), to, tokenId);
1677     }
1678 
1679     /**
1680      * @dev Destroys `tokenId`.
1681      * The approval is cleared when the token is burned.
1682      *
1683      * Requirements:
1684      *
1685      * - `tokenId` must exist.
1686      *
1687      * Emits a {Transfer} event.
1688      */
1689     function _burn(uint256 tokenId) internal virtual {
1690         address owner = ERC721.ownerOf(tokenId); // internal owner
1691 
1692         _beforeTokenTransfer(owner, address(0), tokenId);
1693 
1694         // Clear approvals
1695         _approve(address(0), tokenId);
1696 
1697         // Clear metadata (if any)
1698         if (bytes(_tokenURIs[tokenId]).length != 0) {
1699             delete _tokenURIs[tokenId];
1700         }
1701 
1702         _holderTokens[owner].remove(tokenId);
1703 
1704         _tokenOwners.remove(tokenId);
1705 
1706         emit Transfer(owner, address(0), tokenId);
1707     }
1708 
1709     /**
1710      * @dev Transfers `tokenId` from `from` to `to`.
1711      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1712      *
1713      * Requirements:
1714      *
1715      * - `to` cannot be the zero address.
1716      * - `tokenId` token must be owned by `from`.
1717      *
1718      * Emits a {Transfer} event.
1719      */
1720     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1721         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1722         require(to != address(0), "ERC721: transfer to the zero address");
1723 
1724         _beforeTokenTransfer(from, to, tokenId);
1725 
1726         // Clear approvals from the previous owner
1727         _approve(address(0), tokenId);
1728 
1729         _holderTokens[from].remove(tokenId);
1730         _holderTokens[to].add(tokenId);
1731 
1732         _tokenOwners.set(tokenId, to);
1733 
1734         emit Transfer(from, to, tokenId);
1735     }
1736 
1737     /**
1738      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1739      *
1740      * Requirements:
1741      *
1742      * - `tokenId` must exist.
1743      */
1744     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1745         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1746         _tokenURIs[tokenId] = _tokenURI;
1747     }
1748 
1749     /**
1750      * @dev Internal function to set the base URI for all token IDs. It is
1751      * automatically added as a prefix to the value returned in {tokenURI},
1752      * or to the token ID if {tokenURI} is empty.
1753      */
1754     function _setBaseURI(string memory baseURI_) internal virtual {
1755         _baseURI = baseURI_;
1756     }
1757 
1758     /**
1759      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1760      * The call is not executed if the target address is not a contract.
1761      *
1762      * @param from address representing the previous owner of the given token ID
1763      * @param to target address that will receive the tokens
1764      * @param tokenId uint256 ID of the token to be transferred
1765      * @param _data bytes optional data to send along with the call
1766      * @return bool whether the call correctly returned the expected magic value
1767      */
1768     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1769         private returns (bool)
1770     {
1771         if (!to.isContract()) {
1772             return true;
1773         }
1774         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1775             IERC721Receiver(to).onERC721Received.selector,
1776             _msgSender(),
1777             from,
1778             tokenId,
1779             _data
1780         ), "ERC721: transfer to non ERC721Receiver implementer");
1781         bytes4 retval = abi.decode(returndata, (bytes4));
1782         return (retval == _ERC721_RECEIVED);
1783     }
1784 
1785     /**
1786      * @dev Approve `to` to operate on `tokenId`
1787      *
1788      * Emits an {Approval} event.
1789      */
1790     function _approve(address to, uint256 tokenId) internal virtual {
1791         _tokenApprovals[tokenId] = to;
1792         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1793     }
1794 
1795     /**
1796      * @dev Hook that is called before any token transfer. This includes minting
1797      * and burning.
1798      *
1799      * Calling conditions:
1800      *
1801      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1802      * transferred to `to`.
1803      * - When `from` is zero, `tokenId` will be minted for `to`.
1804      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1805      * - `from` cannot be the zero address.
1806      * - `to` cannot be the zero address.
1807      *
1808      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1809      */
1810     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1811 }
1812 
1813 // File: @openzeppelin/contracts/access/Ownable.sol
1814 
1815 
1816 
1817 pragma solidity >=0.6.0 <0.8.0;
1818 
1819 /**
1820  * @dev Contract module which provides a basic access control mechanism, where
1821  * there is an account (an owner) that can be granted exclusive access to
1822  * specific functions.
1823  *
1824  * By default, the owner account will be the one that deploys the contract. This
1825  * can later be changed with {transferOwnership}.
1826  *
1827  * This module is used through inheritance. It will make available the modifier
1828  * `onlyOwner`, which can be applied to your functions to restrict their use to
1829  * the owner.
1830  */
1831 abstract contract Ownable is Context {
1832     address private _owner;
1833 
1834     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1835 
1836     /**
1837      * @dev Initializes the contract setting the deployer as the initial owner.
1838      */
1839     constructor () internal {
1840         address msgSender = _msgSender();
1841         _owner = msgSender;
1842         emit OwnershipTransferred(address(0), msgSender);
1843     }
1844 
1845     /**
1846      * @dev Returns the address of the current owner.
1847      */
1848     function owner() public view virtual returns (address) {
1849         return _owner;
1850     }
1851 
1852     /**
1853      * @dev Throws if called by any account other than the owner.
1854      */
1855     modifier onlyOwner() {
1856         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1857         _;
1858     }
1859 
1860     /**
1861      * @dev Leaves the contract without owner. It will not be possible to call
1862      * `onlyOwner` functions anymore. Can only be called by the current owner.
1863      *
1864      * NOTE: Renouncing ownership will leave the contract without an owner,
1865      * thereby removing any functionality that is only available to the owner.
1866      */
1867     function renounceOwnership() public virtual onlyOwner {
1868         emit OwnershipTransferred(_owner, address(0));
1869         _owner = address(0);
1870     }
1871 
1872     /**
1873      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1874      * Can only be called by the current owner.
1875      */
1876     function transferOwnership(address newOwner) public virtual onlyOwner {
1877         require(newOwner != address(0), "Ownable: new owner is the zero address");
1878         emit OwnershipTransferred(_owner, newOwner);
1879         _owner = newOwner;
1880     }
1881 }
1882 // ************************************************
1883 // ************************************************
1884 // ************************************************
1885 // ************************************************
1886 pragma solidity ^0.7.0;
1887 pragma abicoder v2;
1888 
1889 contract Apes is ERC721, Ownable {
1890     
1891     using SafeMath for uint256;
1892 
1893     string public APE_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN APE ARE ALL SOLD OUT
1894     
1895     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1896     
1897     bool licenseLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1898 
1899     uint256 public constant apePrice = 20000000000000000; // 0.02 ETH
1900 
1901     uint public constant maxApePurchase = 10;
1902 
1903     uint256 public constant MAX_APE = 3333;
1904 
1905     bool public saleIsActive = false;
1906     
1907     mapping(uint => string) public apeNames;
1908     
1909     // Reserve 1 ape for team - Giveaways/Prizes etc
1910     uint public apeReserve = 1;
1911     
1912     event apeNameChange(address _by, uint _tokenId, string _name);
1913     
1914     event licenseisLocked(string _licenseText);
1915 
1916     constructor() ERC721("Apes", "Ape") { }
1917     
1918     function withdraw() public onlyOwner {
1919         uint balance = address(this).balance;
1920         msg.sender.transfer(balance);
1921     }
1922     
1923     function reserveApe(address _to, uint256 _reserveAmount) public onlyOwner {        
1924         uint supply = totalSupply();
1925         require(_reserveAmount > 0 && _reserveAmount <= apeReserve, "Not enough reserve left for team");
1926         for (uint i = 0; i < _reserveAmount; i++) {
1927             _safeMint(_to, supply + i);
1928         }
1929         apeReserve = apeReserve.sub(_reserveAmount);
1930     }
1931 
1932 
1933     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1934         APE_PROVENANCE = provenanceHash;
1935     }
1936 
1937     function setBaseURI(string memory baseURI) public onlyOwner {
1938         _setBaseURI(baseURI);
1939     }
1940 
1941 
1942     function flipSaleState() public onlyOwner {
1943         saleIsActive = !saleIsActive;
1944     }
1945     
1946     
1947     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1948         uint256 tokenCount = balanceOf(_owner);
1949         if (tokenCount == 0) {
1950             // Return an empty array
1951             return new uint256[](0);
1952         } else {
1953             uint256[] memory result = new uint256[](tokenCount);
1954             uint256 index;
1955             for (index = 0; index < tokenCount; index++) {
1956                 result[index] = tokenOfOwnerByIndex(_owner, index);
1957             }
1958             return result;
1959         }
1960     }
1961     
1962     // Returns the license for tokens
1963     function tokenLicense(uint _id) public view returns(string memory) {
1964         require(_id < totalSupply(), "CHOOSE A APE WITHIN RANGE");
1965         return LICENSE_TEXT;
1966     }
1967     
1968     // Locks the license to prevent further changes 
1969     function lockLicense() public onlyOwner {
1970         licenseLocked =  true;
1971         emit licenseisLocked(LICENSE_TEXT);
1972     }
1973     
1974     // Change the license
1975     function changeLicense(string memory _license) public onlyOwner {
1976         require(licenseLocked == false, "License already locked");
1977         LICENSE_TEXT = _license;
1978     }
1979     
1980     
1981     function mintApes(uint numberOfTokens) public payable {
1982         require(saleIsActive, "Sale must be active to mint Ape");
1983         require(numberOfTokens > 0 && numberOfTokens <= maxApePurchase, "Can only mint 2 tokens at a time");
1984         require(totalSupply().add(numberOfTokens) <= MAX_APE, "Purchase would exceed max supply of Ape");
1985         require(msg.value >= apePrice.mul(numberOfTokens), "Ether value sent is not correct");
1986         
1987         for(uint i = 0; i < numberOfTokens; i++) {
1988             uint mintIndex = totalSupply();
1989             if (totalSupply() < MAX_APE) {
1990                 _safeMint(msg.sender, mintIndex);
1991             }
1992         }
1993 
1994     }
1995      
1996     function changeApeName(uint _tokenId, string memory _name) public {
1997         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this ape!");
1998         require(sha256(bytes(_name)) != sha256(bytes(apeNames[_tokenId])), "New name is same as the current one");
1999         apeNames[_tokenId] = _name;
2000         
2001         emit apeNameChange(msg.sender, _tokenId, _name);
2002         
2003     }
2004     
2005     function viewApeName(uint _tokenId) public view returns( string memory ){
2006         require( _tokenId < totalSupply(), "Choose a ape within range" );
2007         return apeNames[_tokenId];
2008     }
2009     
2010     
2011     // GET ALL APE OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2012     function apeNamesOfOwner(address _owner) external view returns(string[] memory ) {
2013         uint256 tokenCount = balanceOf(_owner);
2014         if (tokenCount == 0) {
2015             // Return an empty array
2016             return new string[](0);
2017         } else {
2018             string[] memory result = new string[](tokenCount);
2019             uint256 index;
2020             for (index = 0; index < tokenCount; index++) {
2021                 result[index] = apeNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2022             }
2023             return result;
2024         }
2025     }
2026     
2027 }