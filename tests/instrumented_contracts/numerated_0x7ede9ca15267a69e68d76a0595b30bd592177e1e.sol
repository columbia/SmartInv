1 /**
2  *Submitted for verification at polygonscan.com on 2021-08-29
3 */
4 
5 /**
6  *Submitted for verification at polygonscan.com on 2021-08-23
7 */
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 //                                                                                                
14 // ,------.                       ,-------.                          ,-----. ,--.          ,--.    
15 // |  .--. '  ,--,--. ,--.   ,--. `--.   /   ,---.   ,---.   ,---.  '  .--./ |  | ,--.,--. |  |-.  
16 // |  '--' | ' ,-.  | |  |.'.|  |   /   /   | .-. : | .-. : (  .-'  |  |     |  | |  ||  | | .-. ' 
17 // |  | --'  \ '-'  | |   .'.   |  /   `--. \   --. \   --. .-'  `) '  '--'\ |  | '  ''  ' | `-' | 
18 // `--'       `--`--' '--'   '--' `-------'  `----'  `----' `----'   `-----' `--'  `----'   `---'  
19 //
20                                                                                                 
21                                     
22 pragma solidity >=0.6.0 <0.8.0;
23 
24 /*
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with GSN meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address payable) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 // File: @openzeppelin/contracts/introspection/IERC165.sol
46 pragma solidity >=0.6.0 <0.8.0;
47 
48 /**
49  * @dev Interface of the ERC165 standard, as defined in the
50  * https://eips.ethereum.org/EIPS/eip-165[EIP].
51  *
52  * Implementers can declare support of contract interfaces, which can then be
53  * queried by others ({ERC165Checker}).
54  *
55  * For an implementation, see {ERC165}.
56  */
57 interface IERC165 {
58     /**
59      * @dev Returns true if this contract implements the interface defined by
60      * `interfaceId`. See the corresponding
61      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
62      * to learn more about how these ids are created.
63      *
64      * This function call must use less than 30 000 gas.
65      */
66     function supportsInterface(bytes4 interfaceId) external view returns (bool);
67 }
68 
69 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
70 pragma solidity >=0.6.2 <0.8.0;
71 
72 /**
73  * @dev Required interface of an ERC721 compliant contract.
74  */
75 interface IERC721 is IERC165 {
76     /**
77      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
83      */
84     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
85 
86     /**
87      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
88      */
89     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
90 
91     /**
92      * @dev Returns the number of tokens in ``owner``'s account.
93      */
94     function balanceOf(address owner) external view returns (uint256 balance);
95 
96     /**
97      * @dev Returns the owner of the `tokenId` token.
98      *
99      * Requirements:
100      *
101      * - `tokenId` must exist.
102      */
103     function ownerOf(uint256 tokenId) external view returns (address owner);
104 
105     /**
106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must exist and be owned by `from`.
114      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
116      *
117      * Emits a {Transfer} event.
118      */
119     function safeTransferFrom(address from, address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Transfers `tokenId` token from `from` to `to`.
123      *
124      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
125      *
126      * Requirements:
127      *
128      * - `from` cannot be the zero address.
129      * - `to` cannot be the zero address.
130      * - `tokenId` token must be owned by `from`.
131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(address from, address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
139      * The approval is cleared when the token is transferred.
140      *
141      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
142      *
143      * Requirements:
144      *
145      * - The caller must own the token or be an approved operator.
146      * - `tokenId` must exist.
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address to, uint256 tokenId) external;
151 
152     /**
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId) external view returns (address operator);
160 
161     /**
162      * @dev Approve or remove `operator` as an operator for the caller.
163      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
164      *
165      * Requirements:
166      *
167      * - The `operator` cannot be the caller.
168      *
169      * Emits an {ApprovalForAll} event.
170      */
171     function setApprovalForAll(address operator, bool _approved) external;
172 
173     /**
174      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
175      *
176      * See {setApprovalForAll}
177      */
178     function isApprovedForAll(address owner, address operator) external view returns (bool);
179 
180     /**
181       * @dev Safely transfers `tokenId` token from `from` to `to`.
182       *
183       * Requirements:
184       *
185       * - `from` cannot be the zero address.
186       * - `to` cannot be the zero address.
187       * - `tokenId` token must exist and be owned by `from`.
188       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
189       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190       *
191       * Emits a {Transfer} event.
192       */
193     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
194 }
195 
196 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
197 pragma solidity >=0.6.2 <0.8.0;
198 
199 /**
200  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
201  * @dev See https://eips.ethereum.org/EIPS/eip-721
202  */
203 interface IERC721Metadata is IERC721 {
204 
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
222 pragma solidity >=0.6.2 <0.8.0;
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
249 pragma solidity >=0.6.0 <0.8.0;
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 interface IERC721Receiver {
257     /**
258      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
259      * by `operator` from `from`, this function is called.
260      *
261      * It must return its Solidity selector to confirm the token transfer.
262      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
263      *
264      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
265      */
266     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
267 }
268 
269 // File: @openzeppelin/contracts/introspection/ERC165.sol
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 /**
273  * @dev Implementation of the {IERC165} interface.
274  *
275  * Contracts may inherit from this and call {_registerInterface} to declare
276  * their support of an interface.
277  */
278 abstract contract ERC165 is IERC165 {
279     /*
280      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
281      */
282     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
283 
284     /**
285      * @dev Mapping of interface ids to whether or not it's supported.
286      */
287     mapping(bytes4 => bool) private _supportedInterfaces;
288 
289     constructor () internal {
290         // Derived contracts need only register support for their own interfaces,
291         // we register support for ERC165 itself here
292         _registerInterface(_INTERFACE_ID_ERC165);
293     }
294 
295     /**
296      * @dev See {IERC165-supportsInterface}.
297      *
298      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
301         return _supportedInterfaces[interfaceId];
302     }
303 
304     /**
305      * @dev Registers the contract as an implementer of the interface defined by
306      * `interfaceId`. Support of the actual ERC165 interface is automatic and
307      * registering its interface id is not required.
308      *
309      * See {IERC165-supportsInterface}.
310      *
311      * Requirements:
312      *
313      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
314      */
315     function _registerInterface(bytes4 interfaceId) internal virtual {
316         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
317         _supportedInterfaces[interfaceId] = true;
318     }
319 }
320 
321 // File: @openzeppelin/contracts/math/SafeMath.sol
322 pragma solidity >=0.6.0 <0.8.0;
323 
324 /**
325  * @dev Wrappers over Solidity's arithmetic operations with added overflow
326  * checks.
327  *
328  * Arithmetic operations in Solidity wrap on overflow. This can easily result
329  * in bugs, because programmers usually assume that an overflow raises an
330  * error, which is the standard behavior in high level programming languages.
331  * `SafeMath` restores this intuition by reverting the transaction when an
332  * operation overflows.
333  *
334  * Using this library instead of the unchecked operations eliminates an entire
335  * class of bugs, so it's recommended to use it always.
336  */
337 library SafeMath {
338     /**
339      * @dev Returns the addition of two unsigned integers, with an overflow flag.
340      *
341      * _Available since v3.4._
342      */
343     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
344         uint256 c = a + b;
345         if (c < a) return (false, 0);
346         return (true, c);
347     }
348 
349     /**
350      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
351      *
352      * _Available since v3.4._
353      */
354     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355         if (b > a) return (false, 0);
356         return (true, a - b);
357     }
358 
359     /**
360      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
361      *
362      * _Available since v3.4._
363      */
364     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
365         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
366         // benefit is lost if 'b' is also tested.
367         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
368         if (a == 0) return (true, 0);
369         uint256 c = a * b;
370         if (c / a != b) return (false, 0);
371         return (true, c);
372     }
373 
374     /**
375      * @dev Returns the division of two unsigned integers, with a division by zero flag.
376      *
377      * _Available since v3.4._
378      */
379     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
380         if (b == 0) return (false, 0);
381         return (true, a / b);
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
386      *
387      * _Available since v3.4._
388      */
389     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
390         if (b == 0) return (false, 0);
391         return (true, a % b);
392     }
393 
394     /**
395      * @dev Returns the addition of two unsigned integers, reverting on
396      * overflow.
397      *
398      * Counterpart to Solidity's `+` operator.
399      *
400      * Requirements:
401      *
402      * - Addition cannot overflow.
403      */
404     function add(uint256 a, uint256 b) internal pure returns (uint256) {
405         uint256 c = a + b;
406         require(c >= a, "SafeMath: addition overflow");
407         return c;
408     }
409 
410     /**
411      * @dev Returns the subtraction of two unsigned integers, reverting on
412      * overflow (when the result is negative).
413      *
414      * Counterpart to Solidity's `-` operator.
415      *
416      * Requirements:
417      *
418      * - Subtraction cannot overflow.
419      */
420     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
421         require(b <= a, "SafeMath: subtraction overflow");
422         return a - b;
423     }
424 
425     /**
426      * @dev Returns the multiplication of two unsigned integers, reverting on
427      * overflow.
428      *
429      * Counterpart to Solidity's `*` operator.
430      *
431      * Requirements:
432      *
433      * - Multiplication cannot overflow.
434      */
435     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
436         if (a == 0) return 0;
437         uint256 c = a * b;
438         require(c / a == b, "SafeMath: multiplication overflow");
439         return c;
440     }
441 
442     /**
443      * @dev Returns the integer division of two unsigned integers, reverting on
444      * division by zero. The result is rounded towards zero.
445      *
446      * Counterpart to Solidity's `/` operator. Note: this function uses a
447      * `revert` opcode (which leaves remaining gas untouched) while Solidity
448      * uses an invalid opcode to revert (consuming all remaining gas).
449      *
450      * Requirements:
451      *
452      * - The divisor cannot be zero.
453      */
454     function div(uint256 a, uint256 b) internal pure returns (uint256) {
455         require(b > 0, "SafeMath: division by zero");
456         return a / b;
457     }
458 
459     /**
460      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
461      * reverting when dividing by zero.
462      *
463      * Counterpart to Solidity's `%` operator. This function uses a `revert`
464      * opcode (which leaves remaining gas untouched) while Solidity uses an
465      * invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      *
469      * - The divisor cannot be zero.
470      */
471     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
472         require(b > 0, "SafeMath: modulo by zero");
473         return a % b;
474     }
475 
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
478      * overflow (when the result is negative).
479      *
480      * CAUTION: This function is deprecated because it requires allocating memory for the error
481      * message unnecessarily. For custom revert reasons use {trySub}.
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
490         require(b <= a, errorMessage);
491         return a - b;
492     }
493 
494     /**
495      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
496      * division by zero. The result is rounded towards zero.
497      *
498      * CAUTION: This function is deprecated because it requires allocating memory for the error
499      * message unnecessarily. For custom revert reasons use {tryDiv}.
500      *
501      * Counterpart to Solidity's `/` operator. Note: this function uses a
502      * `revert` opcode (which leaves remaining gas untouched) while Solidity
503      * uses an invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
510         require(b > 0, errorMessage);
511         return a / b;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * reverting with custom message when dividing by zero.
517      *
518      * CAUTION: This function is deprecated because it requires allocating memory for the error
519      * message unnecessarily. For custom revert reasons use {tryMod}.
520      *
521      * Counterpart to Solidity's `%` operator. This function uses a `revert`
522      * opcode (which leaves remaining gas untouched) while Solidity uses an
523      * invalid opcode to revert (consuming all remaining gas).
524      *
525      * Requirements:
526      *
527      * - The divisor cannot be zero.
528      */
529     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
530         require(b > 0, errorMessage);
531         return a % b;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Address.sol
536 pragma solidity >=0.6.2 <0.8.0;
537 
538 /**
539  * @dev Collection of functions related to the address type
540  */
541 library Address {
542     /**
543      * @dev Returns true if `account` is a contract.
544      *
545      * [IMPORTANT]
546      * ====
547      * It is unsafe to assume that an address for which this function returns
548      * false is an externally-owned account (EOA) and not a contract.
549      *
550      * Among others, `isContract` will return false for the following
551      * types of addresses:
552      *
553      *  - an externally-owned account
554      *  - a contract in construction
555      *  - an address where a contract will be created
556      *  - an address where a contract lived, but was destroyed
557      * ====
558      */
559     function isContract(address account) internal view returns (bool) {
560         // This method relies on extcodesize, which returns 0 for contracts in
561         // construction, since the code is only stored at the end of the
562         // constructor execution.
563 
564         uint256 size;
565         // solhint-disable-next-line no-inline-assembly
566         assembly { size := extcodesize(account) }
567         return size > 0;
568     }
569 
570     /**
571      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
572      * `recipient`, forwarding all available gas and reverting on errors.
573      *
574      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
575      * of certain opcodes, possibly making contracts go over the 2300 gas limit
576      * imposed by `transfer`, making them unable to receive funds via
577      * `transfer`. {sendValue} removes this limitation.
578      *
579      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
580      *
581      * IMPORTANT: because control is transferred to `recipient`, care must be
582      * taken to not create reentrancy vulnerabilities. Consider using
583      * {ReentrancyGuard} or the
584      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
585      */
586     function sendValue(address payable recipient, uint256 amount) internal {
587         require(address(this).balance >= amount, "Address: insufficient balance");
588 
589         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
590         (bool success, ) = recipient.call{ value: amount }("");
591         require(success, "Address: unable to send value, recipient may have reverted");
592     }
593 
594     /**
595      * @dev Performs a Solidity function call using a low level `call`. A
596      * plain`call` is an unsafe replacement for a function call: use this
597      * function instead.
598      *
599      * If `target` reverts with a revert reason, it is bubbled up by this
600      * function (like regular Solidity function calls).
601      *
602      * Returns the raw returned data. To convert to the expected return value,
603      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
604      *
605      * Requirements:
606      *
607      * - `target` must be a contract.
608      * - calling `target` with `data` must not revert.
609      *
610      * _Available since v3.1._
611      */
612     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
613       return functionCall(target, data, "Address: low-level call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
618      * `errorMessage` as a fallback revert reason when `target` reverts.
619      *
620      * _Available since v3.1._
621      */
622     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
623         return functionCallWithValue(target, data, 0, errorMessage);
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
628      * but also transferring `value` wei to `target`.
629      *
630      * Requirements:
631      *
632      * - the calling contract must have an ETH balance of at least `value`.
633      * - the called Solidity function must be `payable`.
634      *
635      * _Available since v3.1._
636      */
637     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
638         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
643      * with `errorMessage` as a fallback revert reason when `target` reverts.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
648         require(address(this).balance >= value, "Address: insufficient balance for call");
649         require(isContract(target), "Address: call to non-contract");
650 
651         // solhint-disable-next-line avoid-low-level-calls
652         (bool success, bytes memory returndata) = target.call{ value: value }(data);
653         return _verifyCallResult(success, returndata, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but performing a static call.
659      *
660      * _Available since v3.3._
661      */
662     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
663         return functionStaticCall(target, data, "Address: low-level static call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
668      * but performing a static call.
669      *
670      * _Available since v3.3._
671      */
672     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
673         require(isContract(target), "Address: static call to non-contract");
674 
675         // solhint-disable-next-line avoid-low-level-calls
676         (bool success, bytes memory returndata) = target.staticcall(data);
677         return _verifyCallResult(success, returndata, errorMessage);
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
682      * but performing a delegate call.
683      *
684      * _Available since v3.4._
685      */
686     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
687         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
688     }
689 
690     /**
691      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
692      * but performing a delegate call.
693      *
694      * _Available since v3.4._
695      */
696     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
697         require(isContract(target), "Address: delegate call to non-contract");
698 
699         // solhint-disable-next-line avoid-low-level-calls
700         (bool success, bytes memory returndata) = target.delegatecall(data);
701         return _verifyCallResult(success, returndata, errorMessage);
702     }
703 
704     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
705         if (success) {
706             return returndata;
707         } else {
708             // Look for revert reason and bubble it up if present
709             if (returndata.length > 0) {
710                 // The easiest way to bubble the revert reason is using memory via assembly
711 
712                 // solhint-disable-next-line no-inline-assembly
713                 assembly {
714                     let returndata_size := mload(returndata)
715                     revert(add(32, returndata), returndata_size)
716                 }
717             } else {
718                 revert(errorMessage);
719             }
720         }
721     }
722 }
723 
724 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
725 pragma solidity >=0.6.0 <0.8.0;
726 
727 /**
728  * @dev Library for managing
729  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
730  * types.
731  *
732  * Sets have the following properties:
733  *
734  * - Elements are added, removed, and checked for existence in constant time
735  * (O(1)).
736  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
737  *
738  * ```
739  * contract Example {
740  *     // Add the library methods
741  *     using EnumerableSet for EnumerableSet.AddressSet;
742  *
743  *     // Declare a set state variable
744  *     EnumerableSet.AddressSet private mySet;
745  * }
746  * ```
747  *
748  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
749  * and `uint256` (`UintSet`) are supported.
750  */
751 library EnumerableSet {
752     // To implement this library for multiple types with as little code
753     // repetition as possible, we write it in terms of a generic Set type with
754     // bytes32 values.
755     // The Set implementation uses private functions, and user-facing
756     // implementations (such as AddressSet) are just wrappers around the
757     // underlying Set.
758     // This means that we can only create new EnumerableSets for types that fit
759     // in bytes32.
760 
761     struct Set {
762         // Storage of set values
763         bytes32[] _values;
764 
765         // Position of the value in the `values` array, plus 1 because index 0
766         // means a value is not in the set.
767         mapping (bytes32 => uint256) _indexes;
768     }
769 
770     /**
771      * @dev Add a value to a set. O(1).
772      *
773      * Returns true if the value was added to the set, that is if it was not
774      * already present.
775      */
776     function _add(Set storage set, bytes32 value) private returns (bool) {
777         if (!_contains(set, value)) {
778             set._values.push(value);
779             // The value is stored at length-1, but we add 1 to all indexes
780             // and use 0 as a sentinel value
781             set._indexes[value] = set._values.length;
782             return true;
783         } else {
784             return false;
785         }
786     }
787 
788     /**
789      * @dev Removes a value from a set. O(1).
790      *
791      * Returns true if the value was removed from the set, that is if it was
792      * present.
793      */
794     function _remove(Set storage set, bytes32 value) private returns (bool) {
795         // We read and store the value's index to prevent multiple reads from the same storage slot
796         uint256 valueIndex = set._indexes[value];
797 
798         if (valueIndex != 0) { // Equivalent to contains(set, value)
799             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
800             // the array, and then remove the last element (sometimes called as 'swap and pop').
801             // This modifies the order of the array, as noted in {at}.
802 
803             uint256 toDeleteIndex = valueIndex - 1;
804             uint256 lastIndex = set._values.length - 1;
805 
806             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
807             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
808 
809             bytes32 lastvalue = set._values[lastIndex];
810 
811             // Move the last value to the index where the value to delete is
812             set._values[toDeleteIndex] = lastvalue;
813             // Update the index for the moved value
814             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
815 
816             // Delete the slot where the moved value was stored
817             set._values.pop();
818 
819             // Delete the index for the deleted slot
820             delete set._indexes[value];
821 
822             return true;
823         } else {
824             return false;
825         }
826     }
827 
828     /**
829      * @dev Returns true if the value is in the set. O(1).
830      */
831     function _contains(Set storage set, bytes32 value) private view returns (bool) {
832         return set._indexes[value] != 0;
833     }
834 
835     /**
836      * @dev Returns the number of values on the set. O(1).
837      */
838     function _length(Set storage set) private view returns (uint256) {
839         return set._values.length;
840     }
841 
842    /**
843     * @dev Returns the value stored at position `index` in the set. O(1).
844     *
845     * Note that there are no guarantees on the ordering of values inside the
846     * array, and it may change when more values are added or removed.
847     *
848     * Requirements:
849     *
850     * - `index` must be strictly less than {length}.
851     */
852     function _at(Set storage set, uint256 index) private view returns (bytes32) {
853         require(set._values.length > index, "EnumerableSet: index out of bounds");
854         return set._values[index];
855     }
856 
857     // Bytes32Set
858 
859     struct Bytes32Set {
860         Set _inner;
861     }
862 
863     /**
864      * @dev Add a value to a set. O(1).
865      *
866      * Returns true if the value was added to the set, that is if it was not
867      * already present.
868      */
869     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
870         return _add(set._inner, value);
871     }
872 
873     /**
874      * @dev Removes a value from a set. O(1).
875      *
876      * Returns true if the value was removed from the set, that is if it was
877      * present.
878      */
879     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
880         return _remove(set._inner, value);
881     }
882 
883     /**
884      * @dev Returns true if the value is in the set. O(1).
885      */
886     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
887         return _contains(set._inner, value);
888     }
889 
890     /**
891      * @dev Returns the number of values in the set. O(1).
892      */
893     function length(Bytes32Set storage set) internal view returns (uint256) {
894         return _length(set._inner);
895     }
896 
897    /**
898     * @dev Returns the value stored at position `index` in the set. O(1).
899     *
900     * Note that there are no guarantees on the ordering of values inside the
901     * array, and it may change when more values are added or removed.
902     *
903     * Requirements:
904     *
905     * - `index` must be strictly less than {length}.
906     */
907     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
908         return _at(set._inner, index);
909     }
910 
911     // AddressSet
912 
913     struct AddressSet {
914         Set _inner;
915     }
916 
917     /**
918      * @dev Add a value to a set. O(1).
919      *
920      * Returns true if the value was added to the set, that is if it was not
921      * already present.
922      */
923     function add(AddressSet storage set, address value) internal returns (bool) {
924         return _add(set._inner, bytes32(uint256(uint160(value))));
925     }
926 
927     /**
928      * @dev Removes a value from a set. O(1).
929      *
930      * Returns true if the value was removed from the set, that is if it was
931      * present.
932      */
933     function remove(AddressSet storage set, address value) internal returns (bool) {
934         return _remove(set._inner, bytes32(uint256(uint160(value))));
935     }
936 
937     /**
938      * @dev Returns true if the value is in the set. O(1).
939      */
940     function contains(AddressSet storage set, address value) internal view returns (bool) {
941         return _contains(set._inner, bytes32(uint256(uint160(value))));
942     }
943 
944     /**
945      * @dev Returns the number of values in the set. O(1).
946      */
947     function length(AddressSet storage set) internal view returns (uint256) {
948         return _length(set._inner);
949     }
950 
951    /**
952     * @dev Returns the value stored at position `index` in the set. O(1).
953     *
954     * Note that there are no guarantees on the ordering of values inside the
955     * array, and it may change when more values are added or removed.
956     *
957     * Requirements:
958     *
959     * - `index` must be strictly less than {length}.
960     */
961     function at(AddressSet storage set, uint256 index) internal view returns (address) {
962         return address(uint160(uint256(_at(set._inner, index))));
963     }
964 
965 
966     // UintSet
967 
968     struct UintSet {
969         Set _inner;
970     }
971 
972     /**
973      * @dev Add a value to a set. O(1).
974      *
975      * Returns true if the value was added to the set, that is if it was not
976      * already present.
977      */
978     function add(UintSet storage set, uint256 value) internal returns (bool) {
979         return _add(set._inner, bytes32(value));
980     }
981 
982     /**
983      * @dev Removes a value from a set. O(1).
984      *
985      * Returns true if the value was removed from the set, that is if it was
986      * present.
987      */
988     function remove(UintSet storage set, uint256 value) internal returns (bool) {
989         return _remove(set._inner, bytes32(value));
990     }
991 
992     /**
993      * @dev Returns true if the value is in the set. O(1).
994      */
995     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
996         return _contains(set._inner, bytes32(value));
997     }
998 
999     /**
1000      * @dev Returns the number of values on the set. O(1).
1001      */
1002     function length(UintSet storage set) internal view returns (uint256) {
1003         return _length(set._inner);
1004     }
1005 
1006    /**
1007     * @dev Returns the value stored at position `index` in the set. O(1).
1008     *
1009     * Note that there are no guarantees on the ordering of values inside the
1010     * array, and it may change when more values are added or removed.
1011     *
1012     * Requirements:
1013     *
1014     * - `index` must be strictly less than {length}.
1015     */
1016     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1017         return uint256(_at(set._inner, index));
1018     }
1019 }
1020 
1021 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1022 pragma solidity >=0.6.0 <0.8.0;
1023 
1024 /**
1025  * @dev Library for managing an enumerable variant of Solidity's
1026  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1027  * type.
1028  *
1029  * Maps have the following properties:
1030  *
1031  * - Entries are added, removed, and checked for existence in constant time
1032  * (O(1)).
1033  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1034  *
1035  * ```
1036  * contract Example {
1037  *     // Add the library methods
1038  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1039  *
1040  *     // Declare a set state variable
1041  *     EnumerableMap.UintToAddressMap private myMap;
1042  * }
1043  * ```
1044  *
1045  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1046  * supported.
1047  */
1048 library EnumerableMap {
1049     // To implement this library for multiple types with as little code
1050     // repetition as possible, we write it in terms of a generic Map type with
1051     // bytes32 keys and values.
1052     // The Map implementation uses private functions, and user-facing
1053     // implementations (such as Uint256ToAddressMap) are just wrappers around
1054     // the underlying Map.
1055     // This means that we can only create new EnumerableMaps for types that fit
1056     // in bytes32.
1057 
1058     struct MapEntry {
1059         bytes32 _key;
1060         bytes32 _value;
1061     }
1062 
1063     struct Map {
1064         // Storage of map keys and values
1065         MapEntry[] _entries;
1066 
1067         // Position of the entry defined by a key in the `entries` array, plus 1
1068         // because index 0 means a key is not in the map.
1069         mapping (bytes32 => uint256) _indexes;
1070     }
1071 
1072     /**
1073      * @dev Adds a key-value pair to a map, or updates the value for an existing
1074      * key. O(1).
1075      *
1076      * Returns true if the key was added to the map, that is if it was not
1077      * already present.
1078      */
1079     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1080         // We read and store the key's index to prevent multiple reads from the same storage slot
1081         uint256 keyIndex = map._indexes[key];
1082 
1083         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1084             map._entries.push(MapEntry({ _key: key, _value: value }));
1085             // The entry is stored at length-1, but we add 1 to all indexes
1086             // and use 0 as a sentinel value
1087             map._indexes[key] = map._entries.length;
1088             return true;
1089         } else {
1090             map._entries[keyIndex - 1]._value = value;
1091             return false;
1092         }
1093     }
1094 
1095     /**
1096      * @dev Removes a key-value pair from a map. O(1).
1097      *
1098      * Returns true if the key was removed from the map, that is if it was present.
1099      */
1100     function _remove(Map storage map, bytes32 key) private returns (bool) {
1101         // We read and store the key's index to prevent multiple reads from the same storage slot
1102         uint256 keyIndex = map._indexes[key];
1103 
1104         if (keyIndex != 0) { // Equivalent to contains(map, key)
1105             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1106             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1107             // This modifies the order of the array, as noted in {at}.
1108 
1109             uint256 toDeleteIndex = keyIndex - 1;
1110             uint256 lastIndex = map._entries.length - 1;
1111 
1112             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1113             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1114 
1115             MapEntry storage lastEntry = map._entries[lastIndex];
1116 
1117             // Move the last entry to the index where the entry to delete is
1118             map._entries[toDeleteIndex] = lastEntry;
1119             // Update the index for the moved entry
1120             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1121 
1122             // Delete the slot where the moved entry was stored
1123             map._entries.pop();
1124 
1125             // Delete the index for the deleted slot
1126             delete map._indexes[key];
1127 
1128             return true;
1129         } else {
1130             return false;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Returns true if the key is in the map. O(1).
1136      */
1137     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1138         return map._indexes[key] != 0;
1139     }
1140 
1141     /**
1142      * @dev Returns the number of key-value pairs in the map. O(1).
1143      */
1144     function _length(Map storage map) private view returns (uint256) {
1145         return map._entries.length;
1146     }
1147 
1148    /**
1149     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1150     *
1151     * Note that there are no guarantees on the ordering of entries inside the
1152     * array, and it may change when more entries are added or removed.
1153     *
1154     * Requirements:
1155     *
1156     * - `index` must be strictly less than {length}.
1157     */
1158     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1159         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1160 
1161         MapEntry storage entry = map._entries[index];
1162         return (entry._key, entry._value);
1163     }
1164 
1165     /**
1166      * @dev Tries to returns the value associated with `key`.  O(1).
1167      * Does not revert if `key` is not in the map.
1168      */
1169     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1170         uint256 keyIndex = map._indexes[key];
1171         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1172         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1173     }
1174 
1175     /**
1176      * @dev Returns the value associated with `key`.  O(1).
1177      *
1178      * Requirements:
1179      *
1180      * - `key` must be in the map.
1181      */
1182     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1183         uint256 keyIndex = map._indexes[key];
1184         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1185         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1186     }
1187 
1188     /**
1189      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1190      *
1191      * CAUTION: This function is deprecated because it requires allocating memory for the error
1192      * message unnecessarily. For custom revert reasons use {_tryGet}.
1193      */
1194     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1195         uint256 keyIndex = map._indexes[key];
1196         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1197         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1198     }
1199 
1200     // UintToAddressMap
1201 
1202     struct UintToAddressMap {
1203         Map _inner;
1204     }
1205 
1206     /**
1207      * @dev Adds a key-value pair to a map, or updates the value for an existing
1208      * key. O(1).
1209      *
1210      * Returns true if the key was added to the map, that is if it was not
1211      * already present.
1212      */
1213     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1214         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1215     }
1216 
1217     /**
1218      * @dev Removes a value from a set. O(1).
1219      *
1220      * Returns true if the key was removed from the map, that is if it was present.
1221      */
1222     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1223         return _remove(map._inner, bytes32(key));
1224     }
1225 
1226     /**
1227      * @dev Returns true if the key is in the map. O(1).
1228      */
1229     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1230         return _contains(map._inner, bytes32(key));
1231     }
1232 
1233     /**
1234      * @dev Returns the number of elements in the map. O(1).
1235      */
1236     function length(UintToAddressMap storage map) internal view returns (uint256) {
1237         return _length(map._inner);
1238     }
1239 
1240    /**
1241     * @dev Returns the element stored at position `index` in the set. O(1).
1242     * Note that there are no guarantees on the ordering of values inside the
1243     * array, and it may change when more values are added or removed.
1244     *
1245     * Requirements:
1246     *
1247     * - `index` must be strictly less than {length}.
1248     */
1249     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1250         (bytes32 key, bytes32 value) = _at(map._inner, index);
1251         return (uint256(key), address(uint160(uint256(value))));
1252     }
1253 
1254     /**
1255      * @dev Tries to returns the value associated with `key`.  O(1).
1256      * Does not revert if `key` is not in the map.
1257      *
1258      * _Available since v3.4._
1259      */
1260     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1261         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1262         return (success, address(uint160(uint256(value))));
1263     }
1264 
1265     /**
1266      * @dev Returns the value associated with `key`.  O(1).
1267      *
1268      * Requirements:
1269      *
1270      * - `key` must be in the map.
1271      */
1272     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1273         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1274     }
1275 
1276     /**
1277      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1278      *
1279      * CAUTION: This function is deprecated because it requires allocating memory for the error
1280      * message unnecessarily. For custom revert reasons use {tryGet}.
1281      */
1282     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1283         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1284     }
1285 }
1286 
1287 // File: @openzeppelin/contracts/utils/Strings.sol
1288 pragma solidity >=0.6.0 <0.8.0;
1289 
1290 /**
1291  * @dev String operations.
1292  */
1293 library Strings {
1294     /**
1295      * @dev Converts a `uint256` to its ASCII `string` representation.
1296      */
1297     function toString(uint256 value) internal pure returns (string memory) {
1298         // Inspired by OraclizeAPI's implementation - MIT licence
1299         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1300 
1301         if (value == 0) {
1302             return "0";
1303         }
1304         uint256 temp = value;
1305         uint256 digits;
1306         while (temp != 0) {
1307             digits++;
1308             temp /= 10;
1309         }
1310         bytes memory buffer = new bytes(digits);
1311         uint256 index = digits - 1;
1312         temp = value;
1313         while (temp != 0) {
1314             buffer[index--] = bytes1(uint8(48 + temp % 10));
1315             temp /= 10;
1316         }
1317         return string(buffer);
1318     }
1319 }
1320 
1321 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1322 pragma solidity >=0.6.0 <0.8.0;
1323 
1324 /**
1325  * @title ERC721 Non-Fungible Token Standard basic implementation
1326  * @dev see https://eips.ethereum.org/EIPS/eip-721
1327  */
1328 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1329     using SafeMath for uint256;
1330     using Address for address;
1331     using EnumerableSet for EnumerableSet.UintSet;
1332     using EnumerableMap for EnumerableMap.UintToAddressMap;
1333     using Strings for uint256;
1334 
1335     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1336     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1337     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1338 
1339     // Mapping from holder address to their (enumerable) set of owned tokens
1340     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1341 
1342     // Enumerable mapping from token ids to their owners
1343     EnumerableMap.UintToAddressMap private _tokenOwners;
1344 
1345     // Mapping from token ID to approved address
1346     mapping (uint256 => address) private _tokenApprovals;
1347 
1348     // Mapping from owner to operator approvals
1349     mapping (address => mapping (address => bool)) private _operatorApprovals;
1350 
1351     // Token name
1352     string private _name;
1353 
1354     // Token symbol
1355     string private _symbol;
1356 
1357     // Optional mapping for token URIs
1358     mapping (uint256 => string) private _tokenURIs;
1359 
1360     // Base URI
1361     string private _baseURI;
1362 
1363     /*
1364      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1365      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1366      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1367      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1368      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1369      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1370      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1371      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1372      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1373      *
1374      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1375      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1376      */
1377     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1378 
1379     /*
1380      *     bytes4(keccak256('name()')) == 0x06fdde03
1381      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1382      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1383      *
1384      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1385      */
1386     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1387 
1388     /*
1389      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1390      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1391      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1392      *
1393      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1394      */
1395     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1396 
1397     /**
1398      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1399      */
1400     constructor (string memory name_, string memory symbol_) public {
1401         _name = name_;
1402         _symbol = symbol_;
1403 
1404         // register the supported interfaces to conform to ERC721 via ERC165
1405         _registerInterface(_INTERFACE_ID_ERC721);
1406         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1407         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-balanceOf}.
1412      */
1413     function balanceOf(address owner) public view virtual override returns (uint256) {
1414         require(owner != address(0), "ERC721: balance query for the zero address");
1415         return _holderTokens[owner].length();
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-ownerOf}.
1420      */
1421     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1422         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1423     }
1424 
1425     /**
1426      * @dev See {IERC721Metadata-name}.
1427      */
1428     function name() public view virtual override returns (string memory) {
1429         return _name;
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Metadata-symbol}.
1434      */
1435     function symbol() public view virtual override returns (string memory) {
1436         return _symbol;
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Metadata-tokenURI}.
1441      */
1442     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1443         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1444 
1445         string memory _tokenURI = _tokenURIs[tokenId];
1446         string memory base = baseURI();
1447 
1448         // If there is no base URI, return the token URI.
1449         if (bytes(base).length == 0) {
1450             return _tokenURI;
1451         }
1452         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1453         if (bytes(_tokenURI).length > 0) {
1454             return string(abi.encodePacked(base, _tokenURI));
1455         }
1456         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1457         return string(abi.encodePacked(base, tokenId.toString()));
1458     }
1459 
1460     /**
1461     * @dev Returns the base URI set via {_setBaseURI}. This will be
1462     * automatically added as a prefix in {tokenURI} to each token's URI, or
1463     * to the token ID if no specific URI is set for that token ID.
1464     */
1465     function baseURI() public view virtual returns (string memory) {
1466         return _baseURI;
1467     }
1468 
1469     /**
1470      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1471      */
1472     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1473         return _holderTokens[owner].at(index);
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Enumerable-totalSupply}.
1478      */
1479     function totalSupply() public view virtual override returns (uint256) {
1480         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1481         return _tokenOwners.length();
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Enumerable-tokenByIndex}.
1486      */
1487     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1488         (uint256 tokenId, ) = _tokenOwners.at(index);
1489         return tokenId;
1490     }
1491 
1492     /**
1493      * @dev See {IERC721-approve}.
1494      */
1495     function approve(address to, uint256 tokenId) public virtual override {
1496         address owner = ERC721.ownerOf(tokenId);
1497         require(to != owner, "ERC721: approval to current owner");
1498 
1499         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1500             "ERC721: approve caller is not owner nor approved for all"
1501         );
1502 
1503         _approve(to, tokenId);
1504     }
1505 
1506     /**
1507      * @dev See {IERC721-getApproved}.
1508      */
1509     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1510         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1511 
1512         return _tokenApprovals[tokenId];
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-setApprovalForAll}.
1517      */
1518     function setApprovalForAll(address operator, bool approved) public virtual override {
1519         require(operator != _msgSender(), "ERC721: approve to caller");
1520 
1521         _operatorApprovals[_msgSender()][operator] = approved;
1522         emit ApprovalForAll(_msgSender(), operator, approved);
1523     }
1524 
1525     /**
1526      * @dev See {IERC721-isApprovedForAll}.
1527      */
1528     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1529         return _operatorApprovals[owner][operator];
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-transferFrom}.
1534      */
1535     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1536         //solhint-disable-next-line max-line-length
1537         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1538 
1539         _transfer(from, to, tokenId);
1540     }
1541 
1542     /**
1543      * @dev See {IERC721-safeTransferFrom}.
1544      */
1545     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1546         safeTransferFrom(from, to, tokenId, "");
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-safeTransferFrom}.
1551      */
1552     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1553         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1554         _safeTransfer(from, to, tokenId, _data);
1555     }
1556 
1557     /**
1558      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1559      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1560      *
1561      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1562      *
1563      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1564      * implement alternative mechanisms to perform token transfer, such as signature-based.
1565      *
1566      * Requirements:
1567      *
1568      * - `from` cannot be the zero address.
1569      * - `to` cannot be the zero address.
1570      * - `tokenId` token must exist and be owned by `from`.
1571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1572      *
1573      * Emits a {Transfer} event.
1574      */
1575     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1576         _transfer(from, to, tokenId);
1577         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1578     }
1579 
1580     /**
1581      * @dev Returns whether `tokenId` exists.
1582      *
1583      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1584      *
1585      * Tokens start existing when they are minted (`_mint`),
1586      * and stop existing when they are burned (`_burn`).
1587      */
1588     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1589         return _tokenOwners.contains(tokenId);
1590     }
1591 
1592     /**
1593      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1594      *
1595      * Requirements:
1596      *
1597      * - `tokenId` must exist.
1598      */
1599     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1600         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1601         address owner = ERC721.ownerOf(tokenId);
1602         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1603     }
1604 
1605     /**
1606      * @dev Safely mints `tokenId` and transfers it to `to`.
1607      *
1608      * Requirements:
1609      d*
1610      * - `tokenId` must not exist.
1611      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1612      *
1613      * Emits a {Transfer} event.
1614      */
1615     function _safeMint(address to, uint256 tokenId) internal virtual {
1616         _safeMint(to, tokenId, "");
1617     }
1618 
1619     /**
1620      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1621      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1622      */
1623     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1624         _mint(to, tokenId);
1625         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1626     }
1627 
1628     /**
1629      * @dev Mints `tokenId` and transfers it to `to`.
1630      *
1631      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1632      *
1633      * Requirements:
1634      *
1635      * - `tokenId` must not exist.
1636      * - `to` cannot be the zero address.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function _mint(address to, uint256 tokenId) internal virtual {
1641         require(to != address(0), "ERC721: mint to the zero address");
1642         require(!_exists(tokenId), "ERC721: token already minted");
1643 
1644         _beforeTokenTransfer(address(0), to, tokenId);
1645 
1646         _holderTokens[to].add(tokenId);
1647 
1648         _tokenOwners.set(tokenId, to);
1649 
1650         emit Transfer(address(0), to, tokenId);
1651     }
1652 
1653     /**
1654      * @dev Destroys `tokenId`.
1655      * The approval is cleared when the token is burned.
1656      *
1657      * Requirements:
1658      *
1659      * - `tokenId` must exist.
1660      *
1661      * Emits a {Transfer} event.
1662      */
1663     function _burn(uint256 tokenId) internal virtual {
1664         address owner = ERC721.ownerOf(tokenId); // internal owner
1665 
1666         _beforeTokenTransfer(owner, address(0), tokenId);
1667 
1668         // Clear approvals
1669         _approve(address(0), tokenId);
1670 
1671         // Clear metadata (if any)
1672         if (bytes(_tokenURIs[tokenId]).length != 0) {
1673             delete _tokenURIs[tokenId];
1674         }
1675 
1676         _holderTokens[owner].remove(tokenId);
1677 
1678         _tokenOwners.remove(tokenId);
1679 
1680         emit Transfer(owner, address(0), tokenId);
1681     }
1682 
1683     /**
1684      * @dev Transfers `tokenId` from `from` to `to`.
1685      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1686      *
1687      * Requirements:
1688      *
1689      * - `to` cannot be the zero address.
1690      * - `tokenId` token must be owned by `from`.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1695         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1696         require(to != address(0), "ERC721: transfer to the zero address");
1697 
1698         _beforeTokenTransfer(from, to, tokenId);
1699 
1700         // Clear approvals from the previous owner
1701         _approve(address(0), tokenId);
1702 
1703         _holderTokens[from].remove(tokenId);
1704         _holderTokens[to].add(tokenId);
1705 
1706         _tokenOwners.set(tokenId, to);
1707 
1708         emit Transfer(from, to, tokenId);
1709     }
1710 
1711     /**
1712      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1713      *
1714      * Requirements:
1715      *
1716      * - `tokenId` must exist.
1717      */
1718     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1719         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1720         _tokenURIs[tokenId] = _tokenURI;
1721     }
1722 
1723     /**
1724      * @dev Internal function to set the base URI for all token IDs. It is
1725      * automatically added as a prefix to the value returned in {tokenURI},
1726      * or to the token ID if {tokenURI} is empty.
1727      */
1728     function _setBaseURI(string memory baseURI_) internal virtual {
1729         _baseURI = baseURI_;
1730     }
1731 
1732     /**
1733      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1734      * The call is not executed if the target address is not a contract.
1735      *
1736      * @param from address representing the previous owner of the given token ID
1737      * @param to target address that will receive the tokens
1738      * @param tokenId uint256 ID of the token to be transferred
1739      * @param _data bytes optional data to send along with the call
1740      * @return bool whether the call correctly returned the expected magic value
1741      */
1742     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1743         private returns (bool)
1744     {
1745         if (!to.isContract()) {
1746             return true;
1747         }
1748         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1749             IERC721Receiver(to).onERC721Received.selector,
1750             _msgSender(),
1751             from,
1752             tokenId,
1753             _data
1754         ), "ERC721: transfer to non ERC721Receiver implementer");
1755         bytes4 retval = abi.decode(returndata, (bytes4));
1756         return (retval == _ERC721_RECEIVED);
1757     }
1758 
1759     /**
1760      * @dev Approve `to` to operate on `tokenId`
1761      *
1762      * Emits an {Approval} event.
1763      */
1764     function _approve(address to, uint256 tokenId) internal virtual {
1765         _tokenApprovals[tokenId] = to;
1766         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1767     }
1768 
1769     /**
1770      * @dev Hook that is called before any token transfer. This includes minting
1771      * and burning.
1772      *
1773      * Calling conditions:
1774      *
1775      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1776      * transferred to `to`.
1777      * - When `from` is zero, `tokenId` will be minted for `to`.
1778      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1779      * - `from` cannot be the zero address.
1780      * - `to` cannot be the zero address.
1781      *
1782      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1783      */
1784     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1785 }
1786 
1787 // File: @openzeppelin/contracts/access/Ownable.sol
1788 pragma solidity >=0.6.0 <0.8.0;
1789 
1790 /**
1791  * @dev Contract module which provides a basic access control mechanism, where
1792  * there is an account (an owner) that can be granted exclusive access to
1793  * specific functions.
1794  *
1795  * By default, the owner account will be the one that deploys the contract. This
1796  * can later be changed with {transferOwnership}.
1797  *
1798  * This module is used through inheritance. It will make available the modifier
1799  * `onlyOwner`, which can be applied to your functions to restrict their use to
1800  * the owner.
1801  */
1802 abstract contract Ownable is Context {
1803     address private _owner;
1804 
1805     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1806 
1807     /**
1808      * @dev Initializes the contract setting the deployer as the initial owner.
1809      */
1810     constructor () internal {
1811         address msgSender = _msgSender();
1812         _owner = msgSender;
1813         emit OwnershipTransferred(address(0), msgSender);
1814     }
1815 
1816     /**
1817      * @dev Returns the address of the current owner.
1818      */
1819     function owner() public view virtual returns (address) {
1820         return _owner;
1821     }
1822 
1823     /**
1824      * @dev Throws if called by any account other than the owner.
1825      */
1826     modifier onlyOwner() {
1827         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1828         _;
1829     }
1830 
1831     /**
1832      * @dev Leaves the contract without owner. It will not be possible to call
1833      * `onlyOwner` functions anymore. Can only be called by the current owner.
1834      *
1835      * NOTE: Renouncing ownership will leave the contract without an owner,
1836      * thereby removing any functionality that is only available to the owner.
1837      */
1838     function renounceOwnership() public virtual onlyOwner {
1839         emit OwnershipTransferred(_owner, address(0));
1840         _owner = address(0);
1841     }
1842 
1843     /**
1844      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1845      * Can only be called by the current owner.
1846      */
1847     function transferOwnership(address newOwner) public virtual onlyOwner {
1848         require(newOwner != address(0), "Ownable: new owner is the zero address");
1849         emit OwnershipTransferred(_owner, newOwner);
1850         _owner = newOwner;
1851     }
1852 }
1853 
1854 
1855 pragma solidity ^0.7.0;
1856 
1857 /**
1858  * @title pawZeesClub contract
1859  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1860  */
1861 contract PawZeesClub is ERC721, Ownable {
1862     uint256 public count = 0;
1863     
1864     event Increment(address who);
1865 
1866     using SafeMath for uint256;
1867     uint256 public pawZeesPrice = 30000000000000000; //0.03 ETH
1868     uint public constant maxPawZeesPurchase = 20;
1869     uint256 public MAX_PAWZEES;
1870     bool public saleIsActive = false;
1871      mapping (
1872     address => uint) public Leaderboard;
1873 
1874     constructor(string memory name, string memory symbol, uint256 maxNftSupply) ERC721(name, symbol) {
1875         MAX_PAWZEES = maxNftSupply;
1876     }
1877 
1878     function withdraw() public onlyOwner {
1879         uint balance = address(this).balance;
1880         msg.sender.transfer(balance);
1881     }
1882 
1883     // Reserves 40 pawZees
1884     function reservePawZeesForDonations() public onlyOwner {        
1885         uint supply = totalSupply();
1886         uint i;
1887         for (i = 0; i < 40; i++) {
1888             _safeMint(msg.sender, supply + i);
1889             count += 1;
1890         }
1891         emit Increment(msg.sender);
1892     }
1893 
1894     function setBaseURI(string memory baseURI) public onlyOwner {
1895         _setBaseURI(baseURI);
1896     }
1897 
1898     function flipSaleState() public onlyOwner {
1899         saleIsActive = !saleIsActive;
1900     }
1901 
1902     function discoverPawZees(uint numberOfTokens,address referral) public payable {
1903         require(saleIsActive, "Sale must be active to mint pawZees");
1904         require(numberOfTokens <= maxPawZeesPurchase, "Can only mint 20 tokens at a time");
1905         require(totalSupply().add(numberOfTokens) <= MAX_PAWZEES, "Purchase would exceed max supply of pawZees");
1906         require(pawZeesPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1907         
1908         for(uint i = 0; i < numberOfTokens; i++) {
1909             uint mintIndex = totalSupply();
1910             if (totalSupply() < MAX_PAWZEES) {
1911                 _safeMint(msg.sender, mintIndex);
1912                 count += 1;
1913             }
1914         }
1915         Leaderboard[referral]=Leaderboard[referral]+numberOfTokens;
1916         emit Increment(msg.sender);
1917     }
1918 
1919     function getCount() public view returns(uint256) {
1920         return count;
1921     }
1922 
1923     // Emergency: can be changed to account for large fluctuations in ETH price
1924     function emergencyChangePrice(uint256 newPrice) public onlyOwner {
1925         pawZeesPrice = newPrice;
1926     }
1927 }