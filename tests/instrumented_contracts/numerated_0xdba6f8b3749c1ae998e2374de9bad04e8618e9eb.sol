1 // SPDX-License-Identifier: MIT
2 
3 // SOME STANDARD LIBRARIES FROM OPENZEPPELIN AND THEN THE SUPERCARS!
4 
5 
6 // File: @openzeppelin/contracts/utils/Context.sol
7 
8 pragma solidity >=0.6.0 <0.8.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/introspection/IERC165.sol
32 
33 
34 
35 pragma solidity >=0.6.0 <0.8.0;
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
59 
60 
61 
62 pragma solidity >=0.6.2 <0.8.0;
63 
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(address from, address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Returns the account approved for `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function getApproved(uint256 tokenId) external view returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 
173     /**
174       * @dev Safely transfers `tokenId` token from `from` to `to`.
175       *
176       * Requirements:
177       *
178       * - `from` cannot be the zero address.
179       * - `to` cannot be the zero address.
180       * - `tokenId` token must exist and be owned by `from`.
181       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183       *
184       * Emits a {Transfer} event.
185       */
186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
187 }
188 
189 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
190 
191 
192 
193 pragma solidity >=0.6.2 <0.8.0;
194 
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Metadata is IERC721 {
201 
202     /**
203      * @dev Returns the token collection name.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the token collection symbol.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
214      */
215     function tokenURI(uint256 tokenId) external view returns (string memory);
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
219 
220 
221 
222 pragma solidity >=0.6.2 <0.8.0;
223 
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Enumerable is IERC721 {
230 
231     /**
232      * @dev Returns the total amount of tokens stored by the contract.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
238      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
239      */
240     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
241 
242     /**
243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
244      * Use along with {totalSupply} to enumerate all tokens.
245      */
246     function tokenByIndex(uint256 index) external view returns (uint256);
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
250 
251 
252 
253 pragma solidity >=0.6.0 <0.8.0;
254 
255 /**
256  * @title ERC721 token receiver interface
257  * @dev Interface for any contract that wants to support safeTransfers
258  * from ERC721 asset contracts.
259  */
260 interface IERC721Receiver {
261     /**
262      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
263      * by `operator` from `from`, this function is called.
264      *
265      * It must return its Solidity selector to confirm the token transfer.
266      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
267      *
268      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
269      */
270     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
271 }
272 
273 // File: @openzeppelin/contracts/introspection/ERC165.sol
274 
275 
276 
277 pragma solidity >=0.6.0 <0.8.0;
278 
279 
280 /**
281  * @dev Implementation of the {IERC165} interface.
282  *
283  * Contracts may inherit from this and call {_registerInterface} to declare
284  * their support of an interface.
285  */
286 abstract contract ERC165 is IERC165 {
287     /*
288      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
289      */
290     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
291 
292     /**
293      * @dev Mapping of interface ids to whether or not it's supported.
294      */
295     mapping(bytes4 => bool) private _supportedInterfaces;
296 
297     constructor () internal {
298         // Derived contracts need only register support for their own interfaces,
299         // we register support for ERC165 itself here
300         _registerInterface(_INTERFACE_ID_ERC165);
301     }
302 
303     /**
304      * @dev See {IERC165-supportsInterface}.
305      *
306      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
307      */
308     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
309         return _supportedInterfaces[interfaceId];
310     }
311 
312     /**
313      * @dev Registers the contract as an implementer of the interface defined by
314      * `interfaceId`. Support of the actual ERC165 interface is automatic and
315      * registering its interface id is not required.
316      *
317      * See {IERC165-supportsInterface}.
318      *
319      * Requirements:
320      *
321      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
322      */
323     function _registerInterface(bytes4 interfaceId) internal virtual {
324         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
325         _supportedInterfaces[interfaceId] = true;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/math/SafeMath.sol
330 
331 
332 
333 pragma solidity >=0.6.0 <0.8.0;
334 
335 /**
336  * @dev Wrappers over Solidity's arithmetic operations with added overflow
337  * checks.
338  *
339  * Arithmetic operations in Solidity wrap on overflow. This can easily result
340  * in bugs, because programmers usually assume that an overflow raises an
341  * error, which is the standard behavior in high level programming languages.
342  * `SafeMath` restores this intuition by reverting the transaction when an
343  * operation overflows.
344  *
345  * Using this library instead of the unchecked operations eliminates an entire
346  * class of bugs, so it's recommended to use it always.
347  */
348 library SafeMath {
349     /**
350      * @dev Returns the addition of two unsigned integers, with an overflow flag.
351      *
352      * _Available since v3.4._
353      */
354     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355         uint256 c = a + b;
356         if (c < a) return (false, 0);
357         return (true, c);
358     }
359 
360     /**
361      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
362      *
363      * _Available since v3.4._
364      */
365     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         if (b > a) return (false, 0);
367         return (true, a - b);
368     }
369 
370     /**
371      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
372      *
373      * _Available since v3.4._
374      */
375     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
376         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
377         // benefit is lost if 'b' is also tested.
378         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
379         if (a == 0) return (true, 0);
380         uint256 c = a * b;
381         if (c / a != b) return (false, 0);
382         return (true, c);
383     }
384 
385     /**
386      * @dev Returns the division of two unsigned integers, with a division by zero flag.
387      *
388      * _Available since v3.4._
389      */
390     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
391         if (b == 0) return (false, 0);
392         return (true, a / b);
393     }
394 
395     /**
396      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
397      *
398      * _Available since v3.4._
399      */
400     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
401         if (b == 0) return (false, 0);
402         return (true, a % b);
403     }
404 
405     /**
406      * @dev Returns the addition of two unsigned integers, reverting on
407      * overflow.
408      *
409      * Counterpart to Solidity's `+` operator.
410      *
411      * Requirements:
412      *
413      * - Addition cannot overflow.
414      */
415     function add(uint256 a, uint256 b) internal pure returns (uint256) {
416         uint256 c = a + b;
417         require(c >= a, "SafeMath: addition overflow");
418         return c;
419     }
420 
421     /**
422      * @dev Returns the subtraction of two unsigned integers, reverting on
423      * overflow (when the result is negative).
424      *
425      * Counterpart to Solidity's `-` operator.
426      *
427      * Requirements:
428      *
429      * - Subtraction cannot overflow.
430      */
431     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
432         require(b <= a, "SafeMath: subtraction overflow");
433         return a - b;
434     }
435 
436     /**
437      * @dev Returns the multiplication of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `*` operator.
441      *
442      * Requirements:
443      *
444      * - Multiplication cannot overflow.
445      */
446     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
447         if (a == 0) return 0;
448         uint256 c = a * b;
449         require(c / a == b, "SafeMath: multiplication overflow");
450         return c;
451     }
452 
453     /**
454      * @dev Returns the integer division of two unsigned integers, reverting on
455      * division by zero. The result is rounded towards zero.
456      *
457      * Counterpart to Solidity's `/` operator. Note: this function uses a
458      * `revert` opcode (which leaves remaining gas untouched) while Solidity
459      * uses an invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function div(uint256 a, uint256 b) internal pure returns (uint256) {
466         require(b > 0, "SafeMath: division by zero");
467         return a / b;
468     }
469 
470     /**
471      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
472      * reverting when dividing by zero.
473      *
474      * Counterpart to Solidity's `%` operator. This function uses a `revert`
475      * opcode (which leaves remaining gas untouched) while Solidity uses an
476      * invalid opcode to revert (consuming all remaining gas).
477      *
478      * Requirements:
479      *
480      * - The divisor cannot be zero.
481      */
482     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
483         require(b > 0, "SafeMath: modulo by zero");
484         return a % b;
485     }
486 
487     /**
488      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
489      * overflow (when the result is negative).
490      *
491      * CAUTION: This function is deprecated because it requires allocating memory for the error
492      * message unnecessarily. For custom revert reasons use {trySub}.
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b <= a, errorMessage);
502         return a - b;
503     }
504 
505     /**
506      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
507      * division by zero. The result is rounded towards zero.
508      *
509      * CAUTION: This function is deprecated because it requires allocating memory for the error
510      * message unnecessarily. For custom revert reasons use {tryDiv}.
511      *
512      * Counterpart to Solidity's `/` operator. Note: this function uses a
513      * `revert` opcode (which leaves remaining gas untouched) while Solidity
514      * uses an invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         require(b > 0, errorMessage);
522         return a / b;
523     }
524 
525     /**
526      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
527      * reverting with custom message when dividing by zero.
528      *
529      * CAUTION: This function is deprecated because it requires allocating memory for the error
530      * message unnecessarily. For custom revert reasons use {tryMod}.
531      *
532      * Counterpart to Solidity's `%` operator. This function uses a `revert`
533      * opcode (which leaves remaining gas untouched) while Solidity uses an
534      * invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
541         require(b > 0, errorMessage);
542         return a % b;
543     }
544 }
545 
546 // File: @openzeppelin/contracts/utils/Address.sol
547 
548 
549 
550 pragma solidity >=0.6.2 <0.8.0;
551 
552 /**
553  * @dev Collection of functions related to the address type
554  */
555 library Address {
556     /**
557      * @dev Returns true if `account` is a contract.
558      *
559      * [IMPORTANT]
560      * ====
561      * It is unsafe to assume that an address for which this function returns
562      * false is an externally-owned account (EOA) and not a contract.
563      *
564      * Among others, `isContract` will return false for the following
565      * types of addresses:
566      *
567      *  - an externally-owned account
568      *  - a contract in construction
569      *  - an address where a contract will be created
570      *  - an address where a contract lived, but was destroyed
571      * ====
572      */
573     function isContract(address account) internal view returns (bool) {
574         // This method relies on extcodesize, which returns 0 for contracts in
575         // construction, since the code is only stored at the end of the
576         // constructor execution.
577 
578         uint256 size;
579         // solhint-disable-next-line no-inline-assembly
580         assembly { size := extcodesize(account) }
581         return size > 0;
582     }
583 
584     /**
585      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
586      * `recipient`, forwarding all available gas and reverting on errors.
587      *
588      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
589      * of certain opcodes, possibly making contracts go over the 2300 gas limit
590      * imposed by `transfer`, making them unable to receive funds via
591      * `transfer`. {sendValue} removes this limitation.
592      *
593      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
594      *
595      * IMPORTANT: because control is transferred to `recipient`, care must be
596      * taken to not create reentrancy vulnerabilities. Consider using
597      * {ReentrancyGuard} or the
598      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
599      */
600     function sendValue(address payable recipient, uint256 amount) internal {
601         require(address(this).balance >= amount, "Address: insufficient balance");
602 
603         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
604         (bool success, ) = recipient.call{ value: amount }("");
605         require(success, "Address: unable to send value, recipient may have reverted");
606     }
607 
608     /**
609      * @dev Performs a Solidity function call using a low level `call`. A
610      * plain`call` is an unsafe replacement for a function call: use this
611      * function instead.
612      *
613      * If `target` reverts with a revert reason, it is bubbled up by this
614      * function (like regular Solidity function calls).
615      *
616      * Returns the raw returned data. To convert to the expected return value,
617      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
618      *
619      * Requirements:
620      *
621      * - `target` must be a contract.
622      * - calling `target` with `data` must not revert.
623      *
624      * _Available since v3.1._
625      */
626     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
627       return functionCall(target, data, "Address: low-level call failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
632      * `errorMessage` as a fallback revert reason when `target` reverts.
633      *
634      * _Available since v3.1._
635      */
636     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
637         return functionCallWithValue(target, data, 0, errorMessage);
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
642      * but also transferring `value` wei to `target`.
643      *
644      * Requirements:
645      *
646      * - the calling contract must have an ETH balance of at least `value`.
647      * - the called Solidity function must be `payable`.
648      *
649      * _Available since v3.1._
650      */
651     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
652         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
657      * with `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
662         require(address(this).balance >= value, "Address: insufficient balance for call");
663         require(isContract(target), "Address: call to non-contract");
664 
665         // solhint-disable-next-line avoid-low-level-calls
666         (bool success, bytes memory returndata) = target.call{ value: value }(data);
667         return _verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
672      * but performing a static call.
673      *
674      * _Available since v3.3._
675      */
676     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
677         return functionStaticCall(target, data, "Address: low-level static call failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
682      * but performing a static call.
683      *
684      * _Available since v3.3._
685      */
686     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
687         require(isContract(target), "Address: static call to non-contract");
688 
689         // solhint-disable-next-line avoid-low-level-calls
690         (bool success, bytes memory returndata) = target.staticcall(data);
691         return _verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
696      * but performing a delegate call.
697      *
698      * _Available since v3.4._
699      */
700     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
701         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
706      * but performing a delegate call.
707      *
708      * _Available since v3.4._
709      */
710     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
711         require(isContract(target), "Address: delegate call to non-contract");
712 
713         // solhint-disable-next-line avoid-low-level-calls
714         (bool success, bytes memory returndata) = target.delegatecall(data);
715         return _verifyCallResult(success, returndata, errorMessage);
716     }
717 
718     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
719         if (success) {
720             return returndata;
721         } else {
722             // Look for revert reason and bubble it up if present
723             if (returndata.length > 0) {
724                 // The easiest way to bubble the revert reason is using memory via assembly
725 
726                 // solhint-disable-next-line no-inline-assembly
727                 assembly {
728                     let returndata_size := mload(returndata)
729                     revert(add(32, returndata), returndata_size)
730                 }
731             } else {
732                 revert(errorMessage);
733             }
734         }
735     }
736 }
737 
738 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
739 
740 
741 
742 pragma solidity >=0.6.0 <0.8.0;
743 
744 /**
745  * @dev Library for managing
746  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
747  * types.
748  *
749  * Sets have the following properties:
750  *
751  * - Elements are added, removed, and checked for existence in constant time
752  * (O(1)).
753  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
754  *
755  * ```
756  * contract Example {
757  *     // Add the library methods
758  *     using EnumerableSet for EnumerableSet.AddressSet;
759  *
760  *     // Declare a set state variable
761  *     EnumerableSet.AddressSet private mySet;
762  * }
763  * ```
764  *
765  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
766  * and `uint256` (`UintSet`) are supported.
767  */
768 library EnumerableSet {
769     // To implement this library for multiple types with as little code
770     // repetition as possible, we write it in terms of a generic Set type with
771     // bytes32 values.
772     // The Set implementation uses private functions, and user-facing
773     // implementations (such as AddressSet) are just wrappers around the
774     // underlying Set.
775     // This means that we can only create new EnumerableSets for types that fit
776     // in bytes32.
777 
778     struct Set {
779         // Storage of set values
780         bytes32[] _values;
781 
782         // Position of the value in the `values` array, plus 1 because index 0
783         // means a value is not in the set.
784         mapping (bytes32 => uint256) _indexes;
785     }
786 
787     /**
788      * @dev Add a value to a set. O(1).
789      *
790      * Returns true if the value was added to the set, that is if it was not
791      * already present.
792      */
793     function _add(Set storage set, bytes32 value) private returns (bool) {
794         if (!_contains(set, value)) {
795             set._values.push(value);
796             // The value is stored at length-1, but we add 1 to all indexes
797             // and use 0 as a sentinel value
798             set._indexes[value] = set._values.length;
799             return true;
800         } else {
801             return false;
802         }
803     }
804 
805     /**
806      * @dev Removes a value from a set. O(1).
807      *
808      * Returns true if the value was removed from the set, that is if it was
809      * present.
810      */
811     function _remove(Set storage set, bytes32 value) private returns (bool) {
812         // We read and store the value's index to prevent multiple reads from the same storage slot
813         uint256 valueIndex = set._indexes[value];
814 
815         if (valueIndex != 0) { // Equivalent to contains(set, value)
816             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
817             // the array, and then remove the last element (sometimes called as 'swap and pop').
818             // This modifies the order of the array, as noted in {at}.
819 
820             uint256 toDeleteIndex = valueIndex - 1;
821             uint256 lastIndex = set._values.length - 1;
822 
823             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
824             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
825 
826             bytes32 lastvalue = set._values[lastIndex];
827 
828             // Move the last value to the index where the value to delete is
829             set._values[toDeleteIndex] = lastvalue;
830             // Update the index for the moved value
831             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
832 
833             // Delete the slot where the moved value was stored
834             set._values.pop();
835 
836             // Delete the index for the deleted slot
837             delete set._indexes[value];
838 
839             return true;
840         } else {
841             return false;
842         }
843     }
844 
845     /**
846      * @dev Returns true if the value is in the set. O(1).
847      */
848     function _contains(Set storage set, bytes32 value) private view returns (bool) {
849         return set._indexes[value] != 0;
850     }
851 
852     /**
853      * @dev Returns the number of values on the set. O(1).
854      */
855     function _length(Set storage set) private view returns (uint256) {
856         return set._values.length;
857     }
858 
859    /**
860     * @dev Returns the value stored at position `index` in the set. O(1).
861     *
862     * Note that there are no guarantees on the ordering of values inside the
863     * array, and it may change when more values are added or removed.
864     *
865     * Requirements:
866     *
867     * - `index` must be strictly less than {length}.
868     */
869     function _at(Set storage set, uint256 index) private view returns (bytes32) {
870         require(set._values.length > index, "EnumerableSet: index out of bounds");
871         return set._values[index];
872     }
873 
874     // Bytes32Set
875 
876     struct Bytes32Set {
877         Set _inner;
878     }
879 
880     /**
881      * @dev Add a value to a set. O(1).
882      *
883      * Returns true if the value was added to the set, that is if it was not
884      * already present.
885      */
886     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
887         return _add(set._inner, value);
888     }
889 
890     /**
891      * @dev Removes a value from a set. O(1).
892      *
893      * Returns true if the value was removed from the set, that is if it was
894      * present.
895      */
896     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
897         return _remove(set._inner, value);
898     }
899 
900     /**
901      * @dev Returns true if the value is in the set. O(1).
902      */
903     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
904         return _contains(set._inner, value);
905     }
906 
907     /**
908      * @dev Returns the number of values in the set. O(1).
909      */
910     function length(Bytes32Set storage set) internal view returns (uint256) {
911         return _length(set._inner);
912     }
913 
914    /**
915     * @dev Returns the value stored at position `index` in the set. O(1).
916     *
917     * Note that there are no guarantees on the ordering of values inside the
918     * array, and it may change when more values are added or removed.
919     *
920     * Requirements:
921     *
922     * - `index` must be strictly less than {length}.
923     */
924     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
925         return _at(set._inner, index);
926     }
927 
928     // AddressSet
929 
930     struct AddressSet {
931         Set _inner;
932     }
933 
934     /**
935      * @dev Add a value to a set. O(1).
936      *
937      * Returns true if the value was added to the set, that is if it was not
938      * already present.
939      */
940     function add(AddressSet storage set, address value) internal returns (bool) {
941         return _add(set._inner, bytes32(uint256(uint160(value))));
942     }
943 
944     /**
945      * @dev Removes a value from a set. O(1).
946      *
947      * Returns true if the value was removed from the set, that is if it was
948      * present.
949      */
950     function remove(AddressSet storage set, address value) internal returns (bool) {
951         return _remove(set._inner, bytes32(uint256(uint160(value))));
952     }
953 
954     /**
955      * @dev Returns true if the value is in the set. O(1).
956      */
957     function contains(AddressSet storage set, address value) internal view returns (bool) {
958         return _contains(set._inner, bytes32(uint256(uint160(value))));
959     }
960 
961     /**
962      * @dev Returns the number of values in the set. O(1).
963      */
964     function length(AddressSet storage set) internal view returns (uint256) {
965         return _length(set._inner);
966     }
967 
968    /**
969     * @dev Returns the value stored at position `index` in the set. O(1).
970     *
971     * Note that there are no guarantees on the ordering of values inside the
972     * array, and it may change when more values are added or removed.
973     *
974     * Requirements:
975     *
976     * - `index` must be strictly less than {length}.
977     */
978     function at(AddressSet storage set, uint256 index) internal view returns (address) {
979         return address(uint160(uint256(_at(set._inner, index))));
980     }
981 
982 
983     // UintSet
984 
985     struct UintSet {
986         Set _inner;
987     }
988 
989     /**
990      * @dev Add a value to a set. O(1).
991      *
992      * Returns true if the value was added to the set, that is if it was not
993      * already present.
994      */
995     function add(UintSet storage set, uint256 value) internal returns (bool) {
996         return _add(set._inner, bytes32(value));
997     }
998 
999     /**
1000      * @dev Removes a value from a set. O(1).
1001      *
1002      * Returns true if the value was removed from the set, that is if it was
1003      * present.
1004      */
1005     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1006         return _remove(set._inner, bytes32(value));
1007     }
1008 
1009     /**
1010      * @dev Returns true if the value is in the set. O(1).
1011      */
1012     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1013         return _contains(set._inner, bytes32(value));
1014     }
1015 
1016     /**
1017      * @dev Returns the number of values on the set. O(1).
1018      */
1019     function length(UintSet storage set) internal view returns (uint256) {
1020         return _length(set._inner);
1021     }
1022 
1023    /**
1024     * @dev Returns the value stored at position `index` in the set. O(1).
1025     *
1026     * Note that there are no guarantees on the ordering of values inside the
1027     * array, and it may change when more values are added or removed.
1028     *
1029     * Requirements:
1030     *
1031     * - `index` must be strictly less than {length}.
1032     */
1033     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1034         return uint256(_at(set._inner, index));
1035     }
1036 }
1037 
1038 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1039 
1040 
1041 
1042 pragma solidity >=0.6.0 <0.8.0;
1043 
1044 /**
1045  * @dev Library for managing an enumerable variant of Solidity's
1046  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1047  * type.
1048  *
1049  * Maps have the following properties:
1050  *
1051  * - Entries are added, removed, and checked for existence in constant time
1052  * (O(1)).
1053  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1054  *
1055  * ```
1056  * contract Example {
1057  *     // Add the library methods
1058  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1059  *
1060  *     // Declare a set state variable
1061  *     EnumerableMap.UintToAddressMap private myMap;
1062  * }
1063  * ```
1064  *
1065  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1066  * supported.
1067  */
1068 library EnumerableMap {
1069     // To implement this library for multiple types with as little code
1070     // repetition as possible, we write it in terms of a generic Map type with
1071     // bytes32 keys and values.
1072     // The Map implementation uses private functions, and user-facing
1073     // implementations (such as Uint256ToAddressMap) are just wrappers around
1074     // the underlying Map.
1075     // This means that we can only create new EnumerableMaps for types that fit
1076     // in bytes32.
1077 
1078     struct MapEntry {
1079         bytes32 _key;
1080         bytes32 _value;
1081     }
1082 
1083     struct Map {
1084         // Storage of map keys and values
1085         MapEntry[] _entries;
1086 
1087         // Position of the entry defined by a key in the `entries` array, plus 1
1088         // because index 0 means a key is not in the map.
1089         mapping (bytes32 => uint256) _indexes;
1090     }
1091 
1092     /**
1093      * @dev Adds a key-value pair to a map, or updates the value for an existing
1094      * key. O(1).
1095      *
1096      * Returns true if the key was added to the map, that is if it was not
1097      * already present.
1098      */
1099     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1100         // We read and store the key's index to prevent multiple reads from the same storage slot
1101         uint256 keyIndex = map._indexes[key];
1102 
1103         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1104             map._entries.push(MapEntry({ _key: key, _value: value }));
1105             // The entry is stored at length-1, but we add 1 to all indexes
1106             // and use 0 as a sentinel value
1107             map._indexes[key] = map._entries.length;
1108             return true;
1109         } else {
1110             map._entries[keyIndex - 1]._value = value;
1111             return false;
1112         }
1113     }
1114 
1115     /**
1116      * @dev Removes a key-value pair from a map. O(1).
1117      *
1118      * Returns true if the key was removed from the map, that is if it was present.
1119      */
1120     function _remove(Map storage map, bytes32 key) private returns (bool) {
1121         // We read and store the key's index to prevent multiple reads from the same storage slot
1122         uint256 keyIndex = map._indexes[key];
1123 
1124         if (keyIndex != 0) { // Equivalent to contains(map, key)
1125             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1126             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1127             // This modifies the order of the array, as noted in {at}.
1128 
1129             uint256 toDeleteIndex = keyIndex - 1;
1130             uint256 lastIndex = map._entries.length - 1;
1131 
1132             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1133             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1134 
1135             MapEntry storage lastEntry = map._entries[lastIndex];
1136 
1137             // Move the last entry to the index where the entry to delete is
1138             map._entries[toDeleteIndex] = lastEntry;
1139             // Update the index for the moved entry
1140             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1141 
1142             // Delete the slot where the moved entry was stored
1143             map._entries.pop();
1144 
1145             // Delete the index for the deleted slot
1146             delete map._indexes[key];
1147 
1148             return true;
1149         } else {
1150             return false;
1151         }
1152     }
1153 
1154     /**
1155      * @dev Returns true if the key is in the map. O(1).
1156      */
1157     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1158         return map._indexes[key] != 0;
1159     }
1160 
1161     /**
1162      * @dev Returns the number of key-value pairs in the map. O(1).
1163      */
1164     function _length(Map storage map) private view returns (uint256) {
1165         return map._entries.length;
1166     }
1167 
1168    /**
1169     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1170     *
1171     * Note that there are no guarantees on the ordering of entries inside the
1172     * array, and it may change when more entries are added or removed.
1173     *
1174     * Requirements:
1175     *
1176     * - `index` must be strictly less than {length}.
1177     */
1178     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1179         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1180 
1181         MapEntry storage entry = map._entries[index];
1182         return (entry._key, entry._value);
1183     }
1184 
1185     /**
1186      * @dev Tries to returns the value associated with `key`.  O(1).
1187      * Does not revert if `key` is not in the map.
1188      */
1189     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1190         uint256 keyIndex = map._indexes[key];
1191         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1192         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1193     }
1194 
1195     /**
1196      * @dev Returns the value associated with `key`.  O(1).
1197      *
1198      * Requirements:
1199      *
1200      * - `key` must be in the map.
1201      */
1202     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1203         uint256 keyIndex = map._indexes[key];
1204         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1205         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1206     }
1207 
1208     /**
1209      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1210      *
1211      * CAUTION: This function is deprecated because it requires allocating memory for the error
1212      * message unnecessarily. For custom revert reasons use {_tryGet}.
1213      */
1214     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1215         uint256 keyIndex = map._indexes[key];
1216         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1217         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1218     }
1219 
1220     // UintToAddressMap
1221 
1222     struct UintToAddressMap {
1223         Map _inner;
1224     }
1225 
1226     /**
1227      * @dev Adds a key-value pair to a map, or updates the value for an existing
1228      * key. O(1).
1229      *
1230      * Returns true if the key was added to the map, that is if it was not
1231      * already present.
1232      */
1233     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1234         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1235     }
1236 
1237     /**
1238      * @dev Removes a value from a set. O(1).
1239      *
1240      * Returns true if the key was removed from the map, that is if it was present.
1241      */
1242     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1243         return _remove(map._inner, bytes32(key));
1244     }
1245 
1246     /**
1247      * @dev Returns true if the key is in the map. O(1).
1248      */
1249     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1250         return _contains(map._inner, bytes32(key));
1251     }
1252 
1253     /**
1254      * @dev Returns the number of elements in the map. O(1).
1255      */
1256     function length(UintToAddressMap storage map) internal view returns (uint256) {
1257         return _length(map._inner);
1258     }
1259 
1260    /**
1261     * @dev Returns the element stored at position `index` in the set. O(1).
1262     * Note that there are no guarantees on the ordering of values inside the
1263     * array, and it may change when more values are added or removed.
1264     *
1265     * Requirements:
1266     *
1267     * - `index` must be strictly less than {length}.
1268     */
1269     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1270         (bytes32 key, bytes32 value) = _at(map._inner, index);
1271         return (uint256(key), address(uint160(uint256(value))));
1272     }
1273 
1274     /**
1275      * @dev Tries to returns the value associated with `key`.  O(1).
1276      * Does not revert if `key` is not in the map.
1277      *
1278      * _Available since v3.4._
1279      */
1280     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1281         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1282         return (success, address(uint160(uint256(value))));
1283     }
1284 
1285     /**
1286      * @dev Returns the value associated with `key`.  O(1).
1287      *
1288      * Requirements:
1289      *
1290      * - `key` must be in the map.
1291      */
1292     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1293         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1294     }
1295 
1296     /**
1297      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1298      *
1299      * CAUTION: This function is deprecated because it requires allocating memory for the error
1300      * message unnecessarily. For custom revert reasons use {tryGet}.
1301      */
1302     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1303         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1304     }
1305 }
1306 
1307 // File: @openzeppelin/contracts/utils/Strings.sol
1308 
1309 
1310 
1311 pragma solidity >=0.6.0 <0.8.0;
1312 
1313 /**
1314  * @dev String operations.
1315  */
1316 library Strings {
1317     /**
1318      * @dev Converts a `uint256` to its ASCII `string` representation.
1319      */
1320     function toString(uint256 value) internal pure returns (string memory) {
1321         // Inspired by OraclizeAPI's implementation - MIT licence
1322         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1323 
1324         if (value == 0) {
1325             return "0";
1326         }
1327         uint256 temp = value;
1328         uint256 digits;
1329         while (temp != 0) {
1330             digits++;
1331             temp /= 10;
1332         }
1333         bytes memory buffer = new bytes(digits);
1334         uint256 index = digits - 1;
1335         temp = value;
1336         while (temp != 0) {
1337             buffer[index--] = bytes1(uint8(48 + temp % 10));
1338             temp /= 10;
1339         }
1340         return string(buffer);
1341     }
1342 }
1343 
1344 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1345 
1346 
1347 
1348 pragma solidity >=0.6.0 <0.8.0;
1349 
1350 /**
1351  * @title ERC721 Non-Fungible Token Standard basic implementation
1352  * @dev see https://eips.ethereum.org/EIPS/eip-721
1353  */
1354 
1355 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1356     using SafeMath for uint256;
1357     using Address for address;
1358     using EnumerableSet for EnumerableSet.UintSet;
1359     using EnumerableMap for EnumerableMap.UintToAddressMap;
1360     using Strings for uint256;
1361 
1362     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1363     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1364     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1365 
1366     // Mapping from holder address to their (enumerable) set of owned tokens
1367     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1368 
1369     // Enumerable mapping from token ids to their owners
1370     EnumerableMap.UintToAddressMap private _tokenOwners;
1371 
1372     // Mapping from token ID to approved address
1373     mapping (uint256 => address) private _tokenApprovals;
1374 
1375     // Mapping from owner to operator approvals
1376     mapping (address => mapping (address => bool)) private _operatorApprovals;
1377 
1378     // Token name
1379     string private _name;
1380 
1381     // Token symbol
1382     string private _symbol;
1383 
1384     // Optional mapping for token URIs
1385     mapping (uint256 => string) private _tokenURIs;
1386 
1387     // Base URI
1388     string private _baseURI;
1389 
1390     /*
1391      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1392      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1393      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1394      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1395      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1396      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1397      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1398      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1399      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1400      *
1401      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1402      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1403      */
1404     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1405 
1406     /*
1407      *     bytes4(keccak256('name()')) == 0x06fdde03
1408      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1409      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1410      *
1411      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1412      */
1413     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1414 
1415     /*
1416      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1417      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1418      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1419      *
1420      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1421      */
1422     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1423 
1424     /**
1425      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1426      */
1427     constructor (string memory name_, string memory symbol_) public {
1428         _name = name_;
1429         _symbol = symbol_;
1430 
1431         // register the supported interfaces to conform to ERC721 via ERC165
1432         _registerInterface(_INTERFACE_ID_ERC721);
1433         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1434         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1435     }
1436 
1437     /**
1438      * @dev See {IERC721-balanceOf}.
1439      */
1440     function balanceOf(address owner) public view virtual override returns (uint256) {
1441         require(owner != address(0), "ERC721: balance query for the zero address");
1442         return _holderTokens[owner].length();
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-ownerOf}.
1447      */
1448     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1449         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1450     }
1451 
1452     /**
1453      * @dev See {IERC721Metadata-name}.
1454      */
1455     function name() public view virtual override returns (string memory) {
1456         return _name;
1457     }
1458 
1459     /**
1460      * @dev See {IERC721Metadata-symbol}.
1461      */
1462     function symbol() public view virtual override returns (string memory) {
1463         return _symbol;
1464     }
1465 
1466     /**
1467      * @dev See {IERC721Metadata-tokenURI}.
1468      */
1469     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1470         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1471 
1472         string memory _tokenURI = _tokenURIs[tokenId];
1473         string memory base = baseURI();
1474 
1475         // If there is no base URI, return the token URI.
1476         if (bytes(base).length == 0) {
1477             return _tokenURI;
1478         }
1479         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1480         if (bytes(_tokenURI).length > 0) {
1481             return string(abi.encodePacked(base, _tokenURI));
1482         }
1483         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1484         return string(abi.encodePacked(base, tokenId.toString()));
1485     }
1486 
1487     /**
1488     * @dev Returns the base URI set via {_setBaseURI}. This will be
1489     * automatically added as a prefix in {tokenURI} to each token's URI, or
1490     * to the token ID if no specific URI is set for that token ID.
1491     */
1492     function baseURI() public view virtual returns (string memory) {
1493         return _baseURI;
1494     }
1495 
1496     /**
1497      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1498      */
1499     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1500         return _holderTokens[owner].at(index);
1501     }
1502 
1503     /**
1504      * @dev See {IERC721Enumerable-totalSupply}.
1505      */
1506     function totalSupply() public view virtual override returns (uint256) {
1507         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1508         return _tokenOwners.length();
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Enumerable-tokenByIndex}.
1513      */
1514     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1515         (uint256 tokenId, ) = _tokenOwners.at(index);
1516         return tokenId;
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-approve}.
1521      */
1522     function approve(address to, uint256 tokenId) public virtual override {
1523         address owner = ERC721.ownerOf(tokenId);
1524         require(to != owner, "ERC721: approval to current owner");
1525 
1526         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1527             "ERC721: approve caller is not owner nor approved for all"
1528         );
1529 
1530         _approve(to, tokenId);
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-getApproved}.
1535      */
1536     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1537         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1538 
1539         return _tokenApprovals[tokenId];
1540     }
1541 
1542     /**
1543      * @dev See {IERC721-setApprovalForAll}.
1544      */
1545     function setApprovalForAll(address operator, bool approved) public virtual override {
1546         require(operator != _msgSender(), "ERC721: approve to caller");
1547 
1548         _operatorApprovals[_msgSender()][operator] = approved;
1549         emit ApprovalForAll(_msgSender(), operator, approved);
1550     }
1551 
1552     /**
1553      * @dev See {IERC721-isApprovedForAll}.
1554      */
1555     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1556         return _operatorApprovals[owner][operator];
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-transferFrom}.
1561      */
1562     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1563         //solhint-disable-next-line max-line-length
1564         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1565 
1566         _transfer(from, to, tokenId);
1567     }
1568 
1569     /**
1570      * @dev See {IERC721-safeTransferFrom}.
1571      */
1572     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1573         safeTransferFrom(from, to, tokenId, "");
1574     }
1575 
1576     /**
1577      * @dev See {IERC721-safeTransferFrom}.
1578      */
1579     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1580         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1581         _safeTransfer(from, to, tokenId, _data);
1582     }
1583 
1584     /**
1585      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1586      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1587      *
1588      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1589      *
1590      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1591      * implement alternative mechanisms to perform token transfer, such as signature-based.
1592      *
1593      * Requirements:
1594      *
1595      * - `from` cannot be the zero address.
1596      * - `to` cannot be the zero address.
1597      * - `tokenId` token must exist and be owned by `from`.
1598      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1599      *
1600      * Emits a {Transfer} event.
1601      */
1602     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1603         _transfer(from, to, tokenId);
1604         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1605     }
1606 
1607     /**
1608      * @dev Returns whether `tokenId` exists.
1609      *
1610      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1611      *
1612      * Tokens start existing when they are minted (`_mint`),
1613      * and stop existing when they are burned (`_burn`).
1614      */
1615     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1616         return _tokenOwners.contains(tokenId);
1617     }
1618 
1619     /**
1620      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1621      *
1622      * Requirements:
1623      *
1624      * - `tokenId` must exist.
1625      */
1626     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1627         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1628         address owner = ERC721.ownerOf(tokenId);
1629         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1630     }
1631 
1632     /**
1633      * @dev Safely mints `tokenId` and transfers it to `to`.
1634      *
1635      * Requirements:
1636      d*
1637      * - `tokenId` must not exist.
1638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1639      *
1640      * Emits a {Transfer} event.
1641      */
1642     function _safeMint(address to, uint256 tokenId) internal virtual {
1643         _safeMint(to, tokenId, "");
1644     }
1645 
1646     /**
1647      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1648      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1649      */
1650     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1651         _mint(to, tokenId);
1652         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1653     }
1654 
1655     /**
1656      * @dev Mints `tokenId` and transfers it to `to`.
1657      *
1658      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1659      *
1660      * Requirements:
1661      *
1662      * - `tokenId` must not exist.
1663      * - `to` cannot be the zero address.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function _mint(address to, uint256 tokenId) internal virtual {
1668         require(to != address(0), "ERC721: mint to the zero address");
1669         require(!_exists(tokenId), "ERC721: token already minted");
1670 
1671         _beforeTokenTransfer(address(0), to, tokenId);
1672 
1673         _holderTokens[to].add(tokenId);
1674 
1675         _tokenOwners.set(tokenId, to);
1676 
1677         emit Transfer(address(0), to, tokenId);
1678     }
1679 
1680     /**
1681      * @dev Destroys `tokenId`.
1682      * The approval is cleared when the token is burned.
1683      *
1684      * Requirements:
1685      *
1686      * - `tokenId` must exist.
1687      *
1688      * Emits a {Transfer} event.
1689      */
1690     function _burn(uint256 tokenId) internal virtual {
1691         address owner = ERC721.ownerOf(tokenId); // internal owner
1692 
1693         _beforeTokenTransfer(owner, address(0), tokenId);
1694 
1695         // Clear approvals
1696         _approve(address(0), tokenId);
1697 
1698         // Clear metadata (if any)
1699         if (bytes(_tokenURIs[tokenId]).length != 0) {
1700             delete _tokenURIs[tokenId];
1701         }
1702 
1703         _holderTokens[owner].remove(tokenId);
1704 
1705         _tokenOwners.remove(tokenId);
1706 
1707         emit Transfer(owner, address(0), tokenId);
1708     }
1709 
1710     /**
1711      * @dev Transfers `tokenId` from `from` to `to`.
1712      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1713      *
1714      * Requirements:
1715      *
1716      * - `to` cannot be the zero address.
1717      * - `tokenId` token must be owned by `from`.
1718      *
1719      * Emits a {Transfer} event.
1720      */
1721     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1722         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1723         require(to != address(0), "ERC721: transfer to the zero address");
1724 
1725         _beforeTokenTransfer(from, to, tokenId);
1726 
1727         // Clear approvals from the previous owner
1728         _approve(address(0), tokenId);
1729 
1730         _holderTokens[from].remove(tokenId);
1731         _holderTokens[to].add(tokenId);
1732 
1733         _tokenOwners.set(tokenId, to);
1734 
1735         emit Transfer(from, to, tokenId);
1736     }
1737 
1738     /**
1739      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1740      *
1741      * Requirements:
1742      *
1743      * - `tokenId` must exist.
1744      */
1745     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1746         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1747         _tokenURIs[tokenId] = _tokenURI;
1748     }
1749 
1750     /**
1751      * @dev Internal function to set the base URI for all token IDs. It is
1752      * automatically added as a prefix to the value returned in {tokenURI},
1753      * or to the token ID if {tokenURI} is empty.
1754      */
1755     function _setBaseURI(string memory baseURI_) internal virtual {
1756         _baseURI = baseURI_;
1757     }
1758 
1759     /**
1760      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1761      * The call is not executed if the target address is not a contract.
1762      *
1763      * @param from address representing the previous owner of the given token ID
1764      * @param to target address that will receive the tokens
1765      * @param tokenId uint256 ID of the token to be transferred
1766      * @param _data bytes optional data to send along with the call
1767      * @return bool whether the call correctly returned the expected magic value
1768      */
1769     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1770         private returns (bool)
1771     {
1772         if (!to.isContract()) {
1773             return true;
1774         }
1775         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1776             IERC721Receiver(to).onERC721Received.selector,
1777             _msgSender(),
1778             from,
1779             tokenId,
1780             _data
1781         ), "ERC721: transfer to non ERC721Receiver implementer");
1782         bytes4 retval = abi.decode(returndata, (bytes4));
1783         return (retval == _ERC721_RECEIVED);
1784     }
1785 
1786     /**
1787      * @dev Approve `to` to operate on `tokenId`
1788      *
1789      * Emits an {Approval} event.
1790      */
1791     function _approve(address to, uint256 tokenId) internal virtual {
1792         _tokenApprovals[tokenId] = to;
1793         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1794     }
1795 
1796     /**
1797      * @dev Hook that is called before any token transfer. This includes minting
1798      * and burning.
1799      *
1800      * Calling conditions:
1801      *
1802      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1803      * transferred to `to`.
1804      * - When `from` is zero, `tokenId` will be minted for `to`.
1805      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1806      * - `from` cannot be the zero address.
1807      * - `to` cannot be the zero address.
1808      *
1809      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1810      */
1811     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1812 }
1813 
1814 // File: @openzeppelin/contracts/access/Ownable.sol
1815 
1816 
1817 
1818 pragma solidity >=0.6.0 <0.8.0;
1819 
1820 /**
1821  * @dev Contract module which provides a basic access control mechanism, where
1822  * there is an account (an owner) that can be granted exclusive access to
1823  * specific functions.
1824  *
1825  * By default, the owner account will be the one that deploys the contract. This
1826  * can later be changed with {transferOwnership}.
1827  *
1828  * This module is used through inheritance. It will make available the modifier
1829  * `onlyOwner`, which can be applied to your functions to restrict their use to
1830  * the owner.
1831  */
1832 abstract contract Ownable is Context {
1833     address private _owner;
1834 
1835     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1836 
1837     /**
1838      * @dev Initializes the contract setting the deployer as the initial owner.
1839      */
1840     constructor () internal {
1841         address msgSender = _msgSender();
1842         _owner = msgSender;
1843         emit OwnershipTransferred(address(0), msgSender);
1844     }
1845 
1846     /**
1847      * @dev Returns the address of the current owner.
1848      */
1849     function owner() public view virtual returns (address) {
1850         return _owner;
1851     }
1852 
1853     /**
1854      * @dev Throws if called by any account other than the owner.
1855      */
1856     modifier onlyOwner() {
1857         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1858         _;
1859     }
1860 
1861     /**
1862      * @dev Leaves the contract without owner. It will not be possible to call
1863      * `onlyOwner` functions anymore. Can only be called by the current owner.
1864      *
1865      * NOTE: Renouncing ownership will leave the contract without an owner,
1866      * thereby removing any functionality that is only available to the owner.
1867      */
1868     function renounceOwnership() public virtual onlyOwner {
1869         emit OwnershipTransferred(_owner, address(0));
1870         _owner = address(0);
1871     }
1872 
1873     /**
1874      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1875      * Can only be called by the current owner.
1876      */
1877     function transferOwnership(address newOwner) public virtual onlyOwner {
1878         require(newOwner != address(0), "Ownable: new owner is the zero address");
1879         emit OwnershipTransferred(_owner, newOwner);
1880         _owner = newOwner;
1881     }
1882 }
1883 
1884 
1885 
1886 // SUPERCAR CONTRACT START HERE
1887 
1888 pragma solidity ^0.7.0;
1889 pragma abicoder v2;
1890 
1891 contract KittySupercars is ERC721, Ownable {
1892 
1893     using SafeMath for uint256;
1894 
1895     string public SUPERCAR_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN SUPERCARS ARE ALL SOLD OUT
1896 
1897     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1898 
1899     bool licenseLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1900 
1901     uint256 public constant supercarPrice = 30000000000000000; // 0.03 ETH
1902 
1903     uint public constant maxSupercarPurchase = 20;
1904 
1905     uint256 public constant MAX_SUPERCARS = 3000;
1906 
1907     bool public saleIsActive = false;
1908 
1909     mapping(uint => string) public supercarNames;
1910 
1911     // Reserve 100 SUPERCARS for team - Giveaways/Prizes etc
1912     uint public supercarReserve = 100;
1913 
1914     event supercarNameChange(address _by, uint _tokenId, string _name);
1915 
1916     event licenseisLocked(string _licenseText);
1917 
1918     constructor() ERC721("KittySupercars", "KS") { }
1919 
1920     function withdraw() public onlyOwner {
1921         uint balance = address(this).balance;
1922         msg.sender.transfer(balance);
1923     }
1924 
1925     function reserveSupercars(address _to, uint256 _reserveAmount) public onlyOwner {
1926         uint supply = totalSupply();
1927         require(_reserveAmount > 0 && _reserveAmount <= supercarReserve, "Not enough reserve left for team");
1928         for (uint i = 0; i < _reserveAmount; i++) {
1929             _safeMint(_to, supply + i);
1930         }
1931         supercarReserve = supercarReserve.sub(_reserveAmount);
1932     }
1933 
1934 
1935     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1936         SUPERCAR_PROVENANCE = provenanceHash;
1937     }
1938 
1939     function setBaseURI(string memory baseURI) public onlyOwner {
1940         _setBaseURI(baseURI);
1941     }
1942 
1943 
1944     function flipSaleState() public onlyOwner {
1945         saleIsActive = !saleIsActive;
1946     }
1947 
1948 
1949     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1950         uint256 tokenCount = balanceOf(_owner);
1951         if (tokenCount == 0) {
1952             // Return an empty array
1953             return new uint256[](0);
1954         } else {
1955             uint256[] memory result = new uint256[](tokenCount);
1956             uint256 index;
1957             for (index = 0; index < tokenCount; index++) {
1958                 result[index] = tokenOfOwnerByIndex(_owner, index);
1959             }
1960             return result;
1961         }
1962     }
1963 
1964     // Returns the license for tokens
1965     function tokenLicense(uint _id) public view returns(string memory) {
1966         require(_id < totalSupply(), "CHOOSE A SUPERCAR WITHIN RANGE");
1967         return LICENSE_TEXT;
1968     }
1969 
1970     // Locks the license to prevent further changes
1971     function lockLicense() public onlyOwner {
1972         licenseLocked =  true;
1973         emit licenseisLocked(LICENSE_TEXT);
1974     }
1975 
1976     // Change the license
1977     function changeLicense(string memory _license) public onlyOwner {
1978         require(licenseLocked == false, "License already locked");
1979         LICENSE_TEXT = _license;
1980     }
1981 
1982 
1983     function mintSupercar(uint numberOfTokens) public payable {
1984         require(saleIsActive, "Sale must be active to mint a Supercar");
1985         require(numberOfTokens > 0 && numberOfTokens <= maxSupercarPurchase, "Can only mint 20 tokens at a time");
1986         require(totalSupply().add(numberOfTokens) <= MAX_SUPERCARS, "Purchase would exceed max supply of Supercars");
1987         require(msg.value >= supercarPrice.mul(numberOfTokens), "Ether value sent is not correct");
1988 
1989         for(uint i = 0; i < numberOfTokens; i++) {
1990             uint mintIndex = totalSupply();
1991             if (totalSupply() < MAX_SUPERCARS) {
1992                 _safeMint(msg.sender, mintIndex);
1993             }
1994         }
1995 
1996     }
1997 
1998     function changeSupercarName(uint _tokenId, string memory _name) public {
1999         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this supercar!");
2000         require(sha256(bytes(_name)) != sha256(bytes(supercarNames[_tokenId])), "New name is same as the current one");
2001         supercarNames[_tokenId] = _name;
2002 
2003         emit supercarNameChange(msg.sender, _tokenId, _name);
2004 
2005     }
2006 
2007     function viewSupercarName(uint _tokenId) public view returns( string memory ){
2008         require( _tokenId < totalSupply(), "Choose a supercar within range" );
2009         return supercarNames[_tokenId];
2010     }
2011 
2012 
2013     // GET ALL SUPERCARS OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2014     function supercarNamesOfOwner(address _owner) external view returns(string[] memory ) {
2015         uint256 tokenCount = balanceOf(_owner);
2016         if (tokenCount == 0) {
2017             // Return an empty array
2018             return new string[](0);
2019         } else {
2020             string[] memory result = new string[](tokenCount);
2021             uint256 index;
2022             for (index = 0; index < tokenCount; index++) {
2023                 result[index] = supercarNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2024             }
2025             return result;
2026         }
2027     }
2028 
2029 }