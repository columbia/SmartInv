1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-06
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // GO TO LINE 1920 TO SEE WHERE EMOSHUNS STARTS
12 
13 // File: @openzeppelin/contracts/utils/Context.sol
14 
15 
16 //The MIT License
17 
18 //Copyright (c) 2017-2019 0xcert, d.o.o. https://0xcert.org
19 
20 //Permission is hereby granted, free of charge, to any person obtaining a copy
21 //of this software and associated documentation files (the "Software"), to deal
22 //in the Software without restriction, including without limitation the rights
23 //to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
24 //copies of the Software, and to permit persons to whom the Software is
25 //furnished to do so, subject to the following conditions:
26 
27 //The above copyright notice and this permission notice shall be included in
28 //all copies or substantial portions of the Software.
29 
30 //THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 //IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 //FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
33 //AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 //LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 //OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
36 //THE SOFTWARE.
37 
38 
39 pragma solidity >=0.6.2 <0.8.0;
40 
41 /*
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with GSN meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes memory) {
57         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
58         return msg.data;
59     }
60 }
61 
62 // File: @openzeppelin/contracts/introspection/IERC165.sol
63 
64 
65 
66 pragma solidity >=0.6.2 <0.8.0;
67 
68 /**
69  * @dev Interface of the ERC165 standard, as defined in the
70  * https://eips.ethereum.org/EIPS/eip-165[EIP].
71  *
72  * Implementers can declare support of contract interfaces, which can then be
73  * queried by others ({ERC165Checker}).
74  *
75  * For an implementation, see {ERC165}.
76  */
77 interface IERC165 {
78     /**
79      * @dev Returns true if this contract implements the interface defined by
80      * `interfaceId`. See the corresponding
81      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
82      * to learn more about how these ids are created.
83      *
84      * This function call must use less than 30 000 gas.
85      */
86     function supportsInterface(bytes4 interfaceId) external view returns (bool);
87 }
88 
89 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
90 
91 
92 
93 pragma solidity >=0.6.2 <0.8.0;
94 
95 
96 /**
97  * @dev Required interface of an ERC721 compliant contract.
98  */
99 interface IERC721 is IERC165 {
100     /**
101      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
104 
105     /**
106      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
107      */
108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
109 
110     /**
111      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
112      */
113     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
114 
115     /**
116      * @dev Returns the number of tokens in ``owner``'s account.
117      */
118     function balanceOf(address owner) external view returns (uint256 balance);
119 
120     /**
121      * @dev Returns the owner of the `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function ownerOf(uint256 tokenId) external view returns (address owner);
128 
129     /**
130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
132      *
133      * Requirements:
134      *
135      * - `from` cannot be the zero address.
136      * - `to` cannot be the zero address.
137      * - `tokenId` token must exist and be owned by `from`.
138      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
140      *
141      * Emits a {Transfer} event.
142      */
143     function safeTransferFrom(address from, address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Transfers `tokenId` token from `from` to `to`.
147      *
148      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address from, address to, uint256 tokenId) external;
160 
161     /**
162      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
163      * The approval is cleared when the token is transferred.
164      *
165      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
166      *
167      * Requirements:
168      *
169      * - The caller must own the token or be an approved operator.
170      * - `tokenId` must exist.
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address to, uint256 tokenId) external;
175 
176     /**
177      * @dev Returns the account approved for `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function getApproved(uint256 tokenId) external view returns (address operator);
184 
185     /**
186      * @dev Approve or remove `operator` as an operator for the caller.
187      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
188      *
189      * Requirements:
190      *
191      * - The `operator` cannot be the caller.
192      *
193      * Emits an {ApprovalForAll} event.
194      */
195     function setApprovalForAll(address operator, bool _approved) external;
196 
197     /**
198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
199      *
200      * See {setApprovalForAll}
201      */
202     function isApprovedForAll(address owner, address operator) external view returns (bool);
203 
204     /**
205       * @dev Safely transfers `tokenId` token from `from` to `to`.
206       *
207       * Requirements:
208       *
209       * - `from` cannot be the zero address.
210       * - `to` cannot be the zero address.
211       * - `tokenId` token must exist and be owned by `from`.
212       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
214       *
215       * Emits a {Transfer} event.
216       */
217     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
218 }
219 
220 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
221 
222 
223 
224 pragma solidity >=0.6.2 <0.8.0;
225 
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Metadata is IERC721 {
232 
233     /**
234      * @dev Returns the token collection name.
235      */
236     function name() external view returns (string memory);
237 
238     /**
239      * @dev Returns the token collection symbol.
240      */
241     function symbol() external view returns (string memory);
242 
243     /**
244      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
245      */
246     function tokenURI(uint256 tokenId) external view returns (string memory);
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
250 
251 
252 
253 pragma solidity >=0.6.2 <0.8.0;
254 
255 
256 /**
257  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
258  * @dev See https://eips.ethereum.org/EIPS/eip-721
259  */
260 interface IERC721Enumerable is IERC721 {
261 
262     /**
263      * @dev Returns the total amount of tokens stored by the contract.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     /**
268      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
269      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
270      */
271     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
272 
273     /**
274      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
275      * Use along with {totalSupply} to enumerate all tokens.
276      */
277     function tokenByIndex(uint256 index) external view returns (uint256);
278 }
279 
280 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
281 
282 
283 
284 pragma solidity >=0.6.2 <0.8.0;
285 
286 /**
287  * @title ERC721 token receiver interface
288  * @dev Interface for any contract that wants to support safeTransfers
289  * from ERC721 asset contracts.
290  */
291 interface IERC721Receiver {
292     /**
293      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
294      * by `operator` from `from`, this function is called.
295      *
296      * It must return its Solidity selector to confirm the token transfer.
297      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
298      *
299      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
300      */
301     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
302 }
303 
304 // File: @openzeppelin/contracts/introspection/ERC165.sol
305 
306 
307 
308 pragma solidity >=0.6.2 <0.8.0;
309 
310 
311 /**
312  * @dev Implementation of the {IERC165} interface.
313  *
314  * Contracts may inherit from this and call {_registerInterface} to declare
315  * their support of an interface.
316  */
317 abstract contract ERC165 is IERC165 {
318     /*
319      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
320      */
321     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
322 
323     /**
324      * @dev Mapping of interface ids to whether or not it's supported.
325      */
326     mapping(bytes4 => bool) private _supportedInterfaces;
327 
328     constructor () internal {
329         // Derived contracts need only register support for their own interfaces,
330         // we register support for ERC165 itself here
331         _registerInterface(_INTERFACE_ID_ERC165);
332     }
333 
334     /**
335      * @dev See {IERC165-supportsInterface}.
336      *
337      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
338      */
339     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
340         return _supportedInterfaces[interfaceId];
341     }
342 
343     /**
344      * @dev Registers the contract as an implementer of the interface defined by
345      * `interfaceId`. Support of the actual ERC165 interface is automatic and
346      * registering its interface id is not required.
347      *
348      * See {IERC165-supportsInterface}.
349      *
350      * Requirements:
351      *
352      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
353      */
354     function _registerInterface(bytes4 interfaceId) internal virtual {
355         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
356         _supportedInterfaces[interfaceId] = true;
357     }
358 }
359 
360 // File: @openzeppelin/contracts/math/SafeMath.sol
361 
362 
363 
364 pragma solidity >=0.6.2 <0.8.0;
365 
366 /**
367  * @dev Wrappers over Solidity's arithmetic operations with added overflow
368  * checks.
369  *
370  * Arithmetic operations in Solidity wrap on overflow. This can easily result
371  * in bugs, because programmers usually assume that an overflow raises an
372  * error, which is the standard behavior in high level programming languages.
373  * `SafeMath` restores this intuition by reverting the transaction when an
374  * operation overflows.
375  *
376  * Using this library instead of the unchecked operations eliminates an entire
377  * class of bugs, so it's recommended to use it always.
378  */
379 library SafeMath {
380     /**
381      * @dev Returns the addition of two unsigned integers, with an overflow flag.
382      *
383      * _Available since v3.4._
384      */
385     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
386         uint256 c = a + b;
387         if (c < a) return (false, 0);
388         return (true, c);
389     }
390 
391     /**
392      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
393      *
394      * _Available since v3.4._
395      */
396     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397         if (b > a) return (false, 0);
398         return (true, a - b);
399     }
400 
401     /**
402      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
403      *
404      * _Available since v3.4._
405      */
406     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
407         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
408         // benefit is lost if 'b' is also tested.
409         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
410         if (a == 0) return (true, 0);
411         uint256 c = a * b;
412         if (c / a != b) return (false, 0);
413         return (true, c);
414     }
415 
416     /**
417      * @dev Returns the division of two unsigned integers, with a division by zero flag.
418      *
419      * _Available since v3.4._
420      */
421     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
422         if (b == 0) return (false, 0);
423         return (true, a / b);
424     }
425 
426     /**
427      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
428      *
429      * _Available since v3.4._
430      */
431     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
432         if (b == 0) return (false, 0);
433         return (true, a % b);
434     }
435 
436     /**
437      * @dev Returns the addition of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `+` operator.
441      *
442      * Requirements:
443      *
444      * - Addition cannot overflow.
445      */
446     function add(uint256 a, uint256 b) internal pure returns (uint256) {
447         uint256 c = a + b;
448         require(c >= a, "SafeMath: addition overflow");
449         return c;
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, reverting on
454      * overflow (when the result is negative).
455      *
456      * Counterpart to Solidity's `-` operator.
457      *
458      * Requirements:
459      *
460      * - Subtraction cannot overflow.
461      */
462     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
463         require(b <= a, "SafeMath: subtraction overflow");
464         return a - b;
465     }
466 
467     /**
468      * @dev Returns the multiplication of two unsigned integers, reverting on
469      * overflow.
470      *
471      * Counterpart to Solidity's `*` operator.
472      *
473      * Requirements:
474      *
475      * - Multiplication cannot overflow.
476      */
477     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
478         if (a == 0) return 0;
479         uint256 c = a * b;
480         require(c / a == b, "SafeMath: multiplication overflow");
481         return c;
482     }
483 
484     /**
485      * @dev Returns the integer division of two unsigned integers, reverting on
486      * division by zero. The result is rounded towards zero.
487      *
488      * Counterpart to Solidity's `/` operator. Note: this function uses a
489      * `revert` opcode (which leaves remaining gas untouched) while Solidity
490      * uses an invalid opcode to revert (consuming all remaining gas).
491      *
492      * Requirements:
493      *
494      * - The divisor cannot be zero.
495      */
496     function div(uint256 a, uint256 b) internal pure returns (uint256) {
497         require(b > 0, "SafeMath: division by zero");
498         return a / b;
499     }
500 
501     /**
502      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
503      * reverting when dividing by zero.
504      *
505      * Counterpart to Solidity's `%` operator. This function uses a `revert`
506      * opcode (which leaves remaining gas untouched) while Solidity uses an
507      * invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
514         require(b > 0, "SafeMath: modulo by zero");
515         return a % b;
516     }
517 
518     /**
519      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
520      * overflow (when the result is negative).
521      *
522      * CAUTION: This function is deprecated because it requires allocating memory for the error
523      * message unnecessarily. For custom revert reasons use {trySub}.
524      *
525      * Counterpart to Solidity's `-` operator.
526      *
527      * Requirements:
528      *
529      * - Subtraction cannot overflow.
530      */
531     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
532         require(b <= a, errorMessage);
533         return a - b;
534     }
535 
536     /**
537      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
538      * division by zero. The result is rounded towards zero.
539      *
540      * CAUTION: This function is deprecated because it requires allocating memory for the error
541      * message unnecessarily. For custom revert reasons use {tryDiv}.
542      *
543      * Counterpart to Solidity's `/` operator. Note: this function uses a
544      * `revert` opcode (which leaves remaining gas untouched) while Solidity
545      * uses an invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      *
549      * - The divisor cannot be zero.
550      */
551     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
552         require(b > 0, errorMessage);
553         return a / b;
554     }
555 
556     /**
557      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
558      * reverting with custom message when dividing by zero.
559      *
560      * CAUTION: This function is deprecated because it requires allocating memory for the error
561      * message unnecessarily. For custom revert reasons use {tryMod}.
562      *
563      * Counterpart to Solidity's `%` operator. This function uses a `revert`
564      * opcode (which leaves remaining gas untouched) while Solidity uses an
565      * invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b > 0, errorMessage);
573         return a % b;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/utils/Address.sol
578 
579 
580 
581 pragma solidity >=0.6.2 <0.8.0;
582 
583 /**
584  * @dev Collection of functions related to the address type
585  */
586 library Address {
587     /**
588      * @dev Returns true if `account` is a contract.
589      *
590      * [IMPORTANT]
591      * ====
592      * It is unsafe to assume that an address for which this function returns
593      * false is an externally-owned account (EOA) and not a contract.
594      *
595      * Among others, `isContract` will return false for the following
596      * types of addresses:
597      *
598      *  - an externally-owned account
599      *  - a contract in construction
600      *  - an address where a contract will be created
601      *  - an address where a contract lived, but was destroyed
602      * ====
603      */
604     function isContract(address account) internal view returns (bool) {
605         // This method relies on extcodesize, which returns 0 for contracts in
606         // construction, since the code is only stored at the end of the
607         // constructor execution.
608 
609         uint256 size;
610         // solhint-disable-next-line no-inline-assembly
611         assembly { size := extcodesize(account) }
612         return size > 0;
613     }
614 
615     /**
616      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
617      * `recipient`, forwarding all available gas and reverting on errors.
618      *
619      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
620      * of certain opcodes, possibly making contracts go over the 2300 gas limit
621      * imposed by `transfer`, making them unable to receive funds via
622      * `transfer`. {sendValue} removes this limitation.
623      *
624      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
625      *
626      * IMPORTANT: because control is transferred to `recipient`, care must be
627      * taken to not create reentrancy vulnerabilities. Consider using
628      * {ReentrancyGuard} or the
629      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
630      */
631     function sendValue(address payable recipient, uint256 amount) internal {
632         require(address(this).balance >= amount, "Address: insufficient balance");
633 
634         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
635         (bool success, ) = recipient.call{ value: amount }("");
636         require(success, "Address: unable to send value, recipient may have reverted");
637     }
638 
639     /**
640      * @dev Performs a Solidity function call using a low level `call`. A
641      * plain`call` is an unsafe replacement for a function call: use this
642      * function instead.
643      *
644      * If `target` reverts with a revert reason, it is bubbled up by this
645      * function (like regular Solidity function calls).
646      *
647      * Returns the raw returned data. To convert to the expected return value,
648      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
649      *
650      * Requirements:
651      *
652      * - `target` must be a contract.
653      * - calling `target` with `data` must not revert.
654      *
655      * _Available since v3.1._
656      */
657     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
658       return functionCall(target, data, "Address: low-level call failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
663      * `errorMessage` as a fallback revert reason when `target` reverts.
664      *
665      * _Available since v3.1._
666      */
667     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
668         return functionCallWithValue(target, data, 0, errorMessage);
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
673      * but also transferring `value` wei to `target`.
674      *
675      * Requirements:
676      *
677      * - the calling contract must have an ETH balance of at least `value`.
678      * - the called Solidity function must be `payable`.
679      *
680      * _Available since v3.1._
681      */
682     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
683         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
688      * with `errorMessage` as a fallback revert reason when `target` reverts.
689      *
690      * _Available since v3.1._
691      */
692     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
693         require(address(this).balance >= value, "Address: insufficient balance for call");
694         require(isContract(target), "Address: call to non-contract");
695 
696         // solhint-disable-next-line avoid-low-level-calls
697         (bool success, bytes memory returndata) = target.call{ value: value }(data);
698         return _verifyCallResult(success, returndata, errorMessage);
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
703      * but performing a static call.
704      *
705      * _Available since v3.3._
706      */
707     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
708         return functionStaticCall(target, data, "Address: low-level static call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
713      * but performing a static call.
714      *
715      * _Available since v3.3._
716      */
717     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
718         require(isContract(target), "Address: static call to non-contract");
719 
720         // solhint-disable-next-line avoid-low-level-calls
721         (bool success, bytes memory returndata) = target.staticcall(data);
722         return _verifyCallResult(success, returndata, errorMessage);
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
727      * but performing a delegate call.
728      *
729      * _Available since v3.4._
730      */
731     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
732         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
737      * but performing a delegate call.
738      *
739      * _Available since v3.4._
740      */
741     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
742         require(isContract(target), "Address: delegate call to non-contract");
743 
744         // solhint-disable-next-line avoid-low-level-calls
745         (bool success, bytes memory returndata) = target.delegatecall(data);
746         return _verifyCallResult(success, returndata, errorMessage);
747     }
748 
749     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
750         if (success) {
751             return returndata;
752         } else {
753             // Look for revert reason and bubble it up if present
754             if (returndata.length > 0) {
755                 // The easiest way to bubble the revert reason is using memory via assembly
756 
757                 // solhint-disable-next-line no-inline-assembly
758                 assembly {
759                     let returndata_size := mload(returndata)
760                     revert(add(32, returndata), returndata_size)
761                 }
762             } else {
763                 revert(errorMessage);
764             }
765         }
766     }
767 }
768 
769 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
770 
771 
772 
773 pragma solidity >=0.6.2 <0.8.0;
774 
775 /**
776  * @dev Library for managing
777  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
778  * types.
779  *
780  * Sets have the following properties:
781  *
782  * - Elements are added, removed, and checked for existence in constant time
783  * (O(1)).
784  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
785  *
786  * ```
787  * contract Example {
788  *     // Add the library methods
789  *     using EnumerableSet for EnumerableSet.AddressSet;
790  *
791  *     // Declare a set state variable
792  *     EnumerableSet.AddressSet private mySet;
793  * }
794  * ```
795  *
796  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
797  * and `uint256` (`UintSet`) are supported.
798  */
799 library EnumerableSet {
800     // To implement this library for multiple types with as little code
801     // repetition as possible, we write it in terms of a generic Set type with
802     // bytes32 values.
803     // The Set implementation uses private functions, and user-facing
804     // implementations (such as AddressSet) are just wrappers around the
805     // underlying Set.
806     // This means that we can only create new EnumerableSets for types that fit
807     // in bytes32.
808 
809     struct Set {
810         // Storage of set values
811         bytes32[] _values;
812 
813         // Position of the value in the `values` array, plus 1 because index 0
814         // means a value is not in the set.
815         mapping (bytes32 => uint256) _indexes;
816     }
817 
818     /**
819      * @dev Add a value to a set. O(1).
820      *
821      * Returns true if the value was added to the set, that is if it was not
822      * already present.
823      */
824     function _add(Set storage set, bytes32 value) private returns (bool) {
825         if (!_contains(set, value)) {
826             set._values.push(value);
827             // The value is stored at length-1, but we add 1 to all indexes
828             // and use 0 as a sentinel value
829             set._indexes[value] = set._values.length;
830             return true;
831         } else {
832             return false;
833         }
834     }
835 
836     /**
837      * @dev Removes a value from a set. O(1).
838      *
839      * Returns true if the value was removed from the set, that is if it was
840      * present.
841      */
842     function _remove(Set storage set, bytes32 value) private returns (bool) {
843         // We read and store the value's index to prevent multiple reads from the same storage slot
844         uint256 valueIndex = set._indexes[value];
845 
846         if (valueIndex != 0) { // Equivalent to contains(set, value)
847             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
848             // the array, and then remove the last element (sometimes called as 'swap and pop').
849             // This modifies the order of the array, as noted in {at}.
850 
851             uint256 toDeleteIndex = valueIndex - 1;
852             uint256 lastIndex = set._values.length - 1;
853 
854             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
855             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
856 
857             bytes32 lastvalue = set._values[lastIndex];
858 
859             // Move the last value to the index where the value to delete is
860             set._values[toDeleteIndex] = lastvalue;
861             // Update the index for the moved value
862             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
863 
864             // Delete the slot where the moved value was stored
865             set._values.pop();
866 
867             // Delete the index for the deleted slot
868             delete set._indexes[value];
869 
870             return true;
871         } else {
872             return false;
873         }
874     }
875 
876     /**
877      * @dev Returns true if the value is in the set. O(1).
878      */
879     function _contains(Set storage set, bytes32 value) private view returns (bool) {
880         return set._indexes[value] != 0;
881     }
882 
883     /**
884      * @dev Returns the number of values on the set. O(1).
885      */
886     function _length(Set storage set) private view returns (uint256) {
887         return set._values.length;
888     }
889 
890    /**
891     * @dev Returns the value stored at position `index` in the set. O(1).
892     *
893     * Note that there are no guarantees on the ordering of values inside the
894     * array, and it may change when more values are added or removed.
895     *
896     * Requirements:
897     *
898     * - `index` must be strictly less than {length}.
899     */
900     function _at(Set storage set, uint256 index) private view returns (bytes32) {
901         require(set._values.length > index, "EnumerableSet: index out of bounds");
902         return set._values[index];
903     }
904 
905     // Bytes32Set
906 
907     struct Bytes32Set {
908         Set _inner;
909     }
910 
911     /**
912      * @dev Add a value to a set. O(1).
913      *
914      * Returns true if the value was added to the set, that is if it was not
915      * already present.
916      */
917     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
918         return _add(set._inner, value);
919     }
920 
921     /**
922      * @dev Removes a value from a set. O(1).
923      *
924      * Returns true if the value was removed from the set, that is if it was
925      * present.
926      */
927     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
928         return _remove(set._inner, value);
929     }
930 
931     /**
932      * @dev Returns true if the value is in the set. O(1).
933      */
934     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
935         return _contains(set._inner, value);
936     }
937 
938     /**
939      * @dev Returns the number of values in the set. O(1).
940      */
941     function length(Bytes32Set storage set) internal view returns (uint256) {
942         return _length(set._inner);
943     }
944 
945    /**
946     * @dev Returns the value stored at position `index` in the set. O(1).
947     *
948     * Note that there are no guarantees on the ordering of values inside the
949     * array, and it may change when more values are added or removed.
950     *
951     * Requirements:
952     *
953     * - `index` must be strictly less than {length}.
954     */
955     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
956         return _at(set._inner, index);
957     }
958 
959     // AddressSet
960 
961     struct AddressSet {
962         Set _inner;
963     }
964 
965     /**
966      * @dev Add a value to a set. O(1).
967      *
968      * Returns true if the value was added to the set, that is if it was not
969      * already present.
970      */
971     function add(AddressSet storage set, address value) internal returns (bool) {
972         return _add(set._inner, bytes32(uint256(uint160(value))));
973     }
974 
975     /**
976      * @dev Removes a value from a set. O(1).
977      *
978      * Returns true if the value was removed from the set, that is if it was
979      * present.
980      */
981     function remove(AddressSet storage set, address value) internal returns (bool) {
982         return _remove(set._inner, bytes32(uint256(uint160(value))));
983     }
984 
985     /**
986      * @dev Returns true if the value is in the set. O(1).
987      */
988     function contains(AddressSet storage set, address value) internal view returns (bool) {
989         return _contains(set._inner, bytes32(uint256(uint160(value))));
990     }
991 
992     /**
993      * @dev Returns the number of values in the set. O(1).
994      */
995     function length(AddressSet storage set) internal view returns (uint256) {
996         return _length(set._inner);
997     }
998 
999    /**
1000     * @dev Returns the value stored at position `index` in the set. O(1).
1001     *
1002     * Note that there are no guarantees on the ordering of values inside the
1003     * array, and it may change when more values are added or removed.
1004     *
1005     * Requirements:
1006     *
1007     * - `index` must be strictly less than {length}.
1008     */
1009     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1010         return address(uint160(uint256(_at(set._inner, index))));
1011     }
1012 
1013 
1014     // UintSet
1015 
1016     struct UintSet {
1017         Set _inner;
1018     }
1019 
1020     /**
1021      * @dev Add a value to a set. O(1).
1022      *
1023      * Returns true if the value was added to the set, that is if it was not
1024      * already present.
1025      */
1026     function add(UintSet storage set, uint256 value) internal returns (bool) {
1027         return _add(set._inner, bytes32(value));
1028     }
1029 
1030     /**
1031      * @dev Removes a value from a set. O(1).
1032      *
1033      * Returns true if the value was removed from the set, that is if it was
1034      * present.
1035      */
1036     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1037         return _remove(set._inner, bytes32(value));
1038     }
1039 
1040     /**
1041      * @dev Returns true if the value is in the set. O(1).
1042      */
1043     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1044         return _contains(set._inner, bytes32(value));
1045     }
1046 
1047     /**
1048      * @dev Returns the number of values on the set. O(1).
1049      */
1050     function length(UintSet storage set) internal view returns (uint256) {
1051         return _length(set._inner);
1052     }
1053 
1054    /**
1055     * @dev Returns the value stored at position `index` in the set. O(1).
1056     *
1057     * Note that there are no guarantees on the ordering of values inside the
1058     * array, and it may change when more values are added or removed.
1059     *
1060     * Requirements:
1061     *
1062     * - `index` must be strictly less than {length}.
1063     */
1064     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1065         return uint256(_at(set._inner, index));
1066     }
1067 }
1068 
1069 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1070 
1071 
1072 
1073 pragma solidity >=0.6.2 <0.8.0;
1074 
1075 /**
1076  * @dev Library for managing an enumerable variant of Solidity's
1077  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1078  * type.
1079  *
1080  * Maps have the following properties:
1081  *
1082  * - Entries are added, removed, and checked for existence in constant time
1083  * (O(1)).
1084  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1085  *
1086  * ```
1087  * contract Example {
1088  *     // Add the library methods
1089  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1090  *
1091  *     // Declare a set state variable
1092  *     EnumerableMap.UintToAddressMap private myMap;
1093  * }
1094  * ```
1095  *
1096  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1097  * supported.
1098  */
1099 library EnumerableMap {
1100     // To implement this library for multiple types with as little code
1101     // repetition as possible, we write it in terms of a generic Map type with
1102     // bytes32 keys and values.
1103     // The Map implementation uses private functions, and user-facing
1104     // implementations (such as Uint256ToAddressMap) are just wrappers around
1105     // the underlying Map.
1106     // This means that we can only create new EnumerableMaps for types that fit
1107     // in bytes32.
1108 
1109     struct MapEntry {
1110         bytes32 _key;
1111         bytes32 _value;
1112     }
1113 
1114     struct Map {
1115         // Storage of map keys and values
1116         MapEntry[] _entries;
1117 
1118         // Position of the entry defined by a key in the `entries` array, plus 1
1119         // because index 0 means a key is not in the map.
1120         mapping (bytes32 => uint256) _indexes;
1121     }
1122 
1123     /**
1124      * @dev Adds a key-value pair to a map, or updates the value for an existing
1125      * key. O(1).
1126      *
1127      * Returns true if the key was added to the map, that is if it was not
1128      * already present.
1129      */
1130     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1131         // We read and store the key's index to prevent multiple reads from the same storage slot
1132         uint256 keyIndex = map._indexes[key];
1133 
1134         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1135             map._entries.push(MapEntry({ _key: key, _value: value }));
1136             // The entry is stored at length-1, but we add 1 to all indexes
1137             // and use 0 as a sentinel value
1138             map._indexes[key] = map._entries.length;
1139             return true;
1140         } else {
1141             map._entries[keyIndex - 1]._value = value;
1142             return false;
1143         }
1144     }
1145 
1146     /**
1147      * @dev Removes a key-value pair from a map. O(1).
1148      *
1149      * Returns true if the key was removed from the map, that is if it was present.
1150      */
1151     function _remove(Map storage map, bytes32 key) private returns (bool) {
1152         // We read and store the key's index to prevent multiple reads from the same storage slot
1153         uint256 keyIndex = map._indexes[key];
1154 
1155         if (keyIndex != 0) { // Equivalent to contains(map, key)
1156             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1157             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1158             // This modifies the order of the array, as noted in {at}.
1159 
1160             uint256 toDeleteIndex = keyIndex - 1;
1161             uint256 lastIndex = map._entries.length - 1;
1162 
1163             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1164             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1165 
1166             MapEntry storage lastEntry = map._entries[lastIndex];
1167 
1168             // Move the last entry to the index where the entry to delete is
1169             map._entries[toDeleteIndex] = lastEntry;
1170             // Update the index for the moved entry
1171             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1172 
1173             // Delete the slot where the moved entry was stored
1174             map._entries.pop();
1175 
1176             // Delete the index for the deleted slot
1177             delete map._indexes[key];
1178 
1179             return true;
1180         } else {
1181             return false;
1182         }
1183     }
1184 
1185     /**
1186      * @dev Returns true if the key is in the map. O(1).
1187      */
1188     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1189         return map._indexes[key] != 0;
1190     }
1191 
1192     /**
1193      * @dev Returns the number of key-value pairs in the map. O(1).
1194      */
1195     function _length(Map storage map) private view returns (uint256) {
1196         return map._entries.length;
1197     }
1198 
1199    /**
1200     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1201     *
1202     * Note that there are no guarantees on the ordering of entries inside the
1203     * array, and it may change when more entries are added or removed.
1204     *
1205     * Requirements:
1206     *
1207     * - `index` must be strictly less than {length}.
1208     */
1209     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1210         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1211 
1212         MapEntry storage entry = map._entries[index];
1213         return (entry._key, entry._value);
1214     }
1215 
1216     /**
1217      * @dev Tries to returns the value associated with `key`.  O(1).
1218      * Does not revert if `key` is not in the map.
1219      */
1220     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1221         uint256 keyIndex = map._indexes[key];
1222         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1223         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1224     }
1225 
1226     /**
1227      * @dev Returns the value associated with `key`.  O(1).
1228      *
1229      * Requirements:
1230      *
1231      * - `key` must be in the map.
1232      */
1233     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1234         uint256 keyIndex = map._indexes[key];
1235         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1236         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1237     }
1238 
1239     /**
1240      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1241      *
1242      * CAUTION: This function is deprecated because it requires allocating memory for the error
1243      * message unnecessarily. For custom revert reasons use {_tryGet}.
1244      */
1245     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1246         uint256 keyIndex = map._indexes[key];
1247         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1248         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1249     }
1250 
1251     // UintToAddressMap
1252 
1253     struct UintToAddressMap {
1254         Map _inner;
1255     }
1256 
1257     /**
1258      * @dev Adds a key-value pair to a map, or updates the value for an existing
1259      * key. O(1).
1260      *
1261      * Returns true if the key was added to the map, that is if it was not
1262      * already present.
1263      */
1264     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1265         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1266     }
1267 
1268     /**
1269      * @dev Removes a value from a set. O(1).
1270      *
1271      * Returns true if the key was removed from the map, that is if it was present.
1272      */
1273     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1274         return _remove(map._inner, bytes32(key));
1275     }
1276 
1277     /**
1278      * @dev Returns true if the key is in the map. O(1).
1279      */
1280     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1281         return _contains(map._inner, bytes32(key));
1282     }
1283 
1284     /**
1285      * @dev Returns the number of elements in the map. O(1).
1286      */
1287     function length(UintToAddressMap storage map) internal view returns (uint256) {
1288         return _length(map._inner);
1289     }
1290 
1291    /**
1292     * @dev Returns the element stored at position `index` in the set. O(1).
1293     * Note that there are no guarantees on the ordering of values inside the
1294     * array, and it may change when more values are added or removed.
1295     *
1296     * Requirements:
1297     *
1298     * - `index` must be strictly less than {length}.
1299     */
1300     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1301         (bytes32 key, bytes32 value) = _at(map._inner, index);
1302         return (uint256(key), address(uint160(uint256(value))));
1303     }
1304 
1305     /**
1306      * @dev Tries to returns the value associated with `key`.  O(1).
1307      * Does not revert if `key` is not in the map.
1308      *
1309      * _Available since v3.4._
1310      */
1311     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1312         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1313         return (success, address(uint160(uint256(value))));
1314     }
1315 
1316     /**
1317      * @dev Returns the value associated with `key`.  O(1).
1318      *
1319      * Requirements:
1320      *
1321      * - `key` must be in the map.
1322      */
1323     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1324         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1325     }
1326 
1327     /**
1328      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1329      *
1330      * CAUTION: This function is deprecated because it requires allocating memory for the error
1331      * message unnecessarily. For custom revert reasons use {tryGet}.
1332      */
1333     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1334         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1335     }
1336 }
1337 
1338 // File: @openzeppelin/contracts/utils/Strings.sol
1339 
1340 
1341 
1342 pragma solidity >=0.6.2 <0.8.0;
1343 
1344 /**
1345  * @dev String operations.
1346  */
1347 library Strings {
1348     /**
1349      * @dev Converts a `uint256` to its ASCII `string` representation.
1350      */
1351     function toString(uint256 value) internal pure returns (string memory) {
1352         // Inspired by OraclizeAPI's implementation - MIT licence
1353         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1354 
1355         if (value == 0) {
1356             return "0";
1357         }
1358         uint256 temp = value;
1359         uint256 digits;
1360         while (temp != 0) {
1361             digits++;
1362             temp /= 10;
1363         }
1364         bytes memory buffer = new bytes(digits);
1365         uint256 index = digits - 1;
1366         temp = value;
1367         while (temp != 0) {
1368             buffer[index--] = bytes1(uint8(48 + temp % 10));
1369             temp /= 10;
1370         }
1371         return string(buffer);
1372     }
1373 }
1374 
1375 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1376 
1377 
1378 
1379 pragma solidity >=0.6.2 <0.8.0;
1380 
1381 /**
1382  * @title ERC721 Non-Fungible Token Standard basic implementation
1383  * @dev see https://eips.ethereum.org/EIPS/eip-721
1384  */
1385 
1386 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1387     using SafeMath for uint256;
1388     using Address for address;
1389     using EnumerableSet for EnumerableSet.UintSet;
1390     using EnumerableMap for EnumerableMap.UintToAddressMap;
1391     using Strings for uint256;
1392 
1393     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1394     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1395     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1396 
1397     // Mapping from holder address to their (enumerable) set of owned tokens
1398     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1399 
1400     // Enumerable mapping from token ids to their owners
1401     EnumerableMap.UintToAddressMap private _tokenOwners;
1402 
1403     // Mapping from token ID to approved address
1404     mapping (uint256 => address) private _tokenApprovals;
1405 
1406     // Mapping from owner to operator approvals
1407     mapping (address => mapping (address => bool)) private _operatorApprovals;
1408 
1409     // Token name
1410     string private _name;
1411 
1412     // Token symbol
1413     string private _symbol;
1414 
1415     // Optional mapping for token URIs
1416     mapping (uint256 => string) private _tokenURIs;
1417 
1418     // Base URI
1419     string private _baseURI;
1420 
1421     /*
1422      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1423      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1424      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1425      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1426      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1427      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1428      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1429      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1430      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1431      *
1432      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1433      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1434      */
1435     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1436 
1437     /*
1438      *     bytes4(keccak256('name()')) == 0x06fdde03
1439      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1440      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1441      *
1442      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1443      */
1444     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1445 
1446     /*
1447      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1448      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1449      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1450      *
1451      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1452      */
1453     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1454 
1455     /**
1456      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1457      */
1458     constructor (string memory name_, string memory symbol_) public {
1459         _name = name_;
1460         _symbol = symbol_;
1461 
1462         // register the supported interfaces to conform to ERC721 via ERC165
1463         _registerInterface(_INTERFACE_ID_ERC721);
1464         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1465         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1466     }
1467 
1468     /**
1469      * @dev See {IERC721-balanceOf}.
1470      */
1471     function balanceOf(address owner) public view virtual override returns (uint256) {
1472         require(owner != address(0), "ERC721: balance query for the zero address");
1473         return _holderTokens[owner].length();
1474     }
1475 
1476     /**
1477      * @dev See {IERC721-ownerOf}.
1478      */
1479     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1480         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1481     }
1482 
1483     /**
1484      * @dev See {IERC721Metadata-name}.
1485      */
1486     function name() public view virtual override returns (string memory) {
1487         return _name;
1488     }
1489 
1490     /**
1491      * @dev See {IERC721Metadata-symbol}.
1492      */
1493     function symbol() public view virtual override returns (string memory) {
1494         return _symbol;
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Metadata-tokenURI}.
1499      */
1500     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1501         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1502 
1503         string memory _tokenURI = _tokenURIs[tokenId];
1504         string memory base = baseURI();
1505 
1506         // If there is no base URI, return the token URI.
1507         if (bytes(base).length == 0) {
1508             return _tokenURI;
1509         }
1510         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1511         if (bytes(_tokenURI).length > 0) {
1512             return string(abi.encodePacked(base, _tokenURI));
1513         }
1514         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1515         return string(abi.encodePacked(base, tokenId.toString()));
1516     }
1517 
1518     /**
1519     * @dev Returns the base URI set via {_setBaseURI}. This will be
1520     * automatically added as a prefix in {tokenURI} to each token's URI, or
1521     * to the token ID if no specific URI is set for that token ID.
1522     */
1523     function baseURI() public view virtual returns (string memory) {
1524         return _baseURI;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1529      */
1530     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1531         return _holderTokens[owner].at(index);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721Enumerable-totalSupply}.
1536      */
1537     function totalSupply() public view virtual override returns (uint256) {
1538         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1539         return _tokenOwners.length();
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Enumerable-tokenByIndex}.
1544      */
1545     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1546         (uint256 tokenId, ) = _tokenOwners.at(index);
1547         return tokenId;
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-approve}.
1552      */
1553     function approve(address to, uint256 tokenId) public virtual override {
1554         address owner = ERC721.ownerOf(tokenId);
1555         require(to != owner, "ERC721: approval to current owner");
1556 
1557         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1558             "ERC721: approve caller is not owner nor approved for all"
1559         );
1560 
1561         _approve(to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-getApproved}.
1566      */
1567     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1568         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1569 
1570         return _tokenApprovals[tokenId];
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-setApprovalForAll}.
1575      */
1576     function setApprovalForAll(address operator, bool approved) public virtual override {
1577         require(operator != _msgSender(), "ERC721: approve to caller");
1578 
1579         _operatorApprovals[_msgSender()][operator] = approved;
1580         emit ApprovalForAll(_msgSender(), operator, approved);
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-isApprovedForAll}.
1585      */
1586     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1587         return _operatorApprovals[owner][operator];
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-transferFrom}.
1592      */
1593     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1594         //solhint-disable-next-line max-line-length
1595         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1596 
1597         _transfer(from, to, tokenId);
1598     }
1599 
1600     /**
1601      * @dev See {IERC721-safeTransferFrom}.
1602      */
1603     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1604         safeTransferFrom(from, to, tokenId, "");
1605     }
1606 
1607     /**
1608      * @dev See {IERC721-safeTransferFrom}.
1609      */
1610     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1611         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1612         _safeTransfer(from, to, tokenId, _data);
1613     }
1614 
1615     /**
1616      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1617      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1618      *
1619      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1620      *
1621      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1622      * implement alternative mechanisms to perform token transfer, such as signature-based.
1623      *
1624      * Requirements:
1625      *
1626      * - `from` cannot be the zero address.
1627      * - `to` cannot be the zero address.
1628      * - `tokenId` token must exist and be owned by `from`.
1629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1634         _transfer(from, to, tokenId);
1635         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1636     }
1637 
1638     /**
1639      * @dev Returns whether `tokenId` exists.
1640      *
1641      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1642      *
1643      * Tokens start existing when they are minted (`_mint`),
1644      * and stop existing when they are burned (`_burn`).
1645      */
1646     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1647         return _tokenOwners.contains(tokenId);
1648     }
1649 
1650     /**
1651      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1652      *
1653      * Requirements:
1654      *
1655      * - `tokenId` must exist.
1656      */
1657     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1658         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1659         address owner = ERC721.ownerOf(tokenId);
1660         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1661     }
1662 
1663     /**
1664      * @dev Safely mints `tokenId` and transfers it to `to`.
1665      *
1666      * Requirements:
1667      d*
1668      * - `tokenId` must not exist.
1669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _safeMint(address to, uint256 tokenId) internal virtual {
1674         _safeMint(to, tokenId, "");
1675     }
1676 
1677     /**
1678      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1679      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1680      */
1681     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1682         _mint(to, tokenId);
1683         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1684     }
1685 
1686     /**
1687      * @dev Mints `tokenId` and transfers it to `to`.
1688      *
1689      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1690      *
1691      * Requirements:
1692      *
1693      * - `tokenId` must not exist.
1694      * - `to` cannot be the zero address.
1695      *
1696      * Emits a {Transfer} event.
1697      */
1698     function _mint(address to, uint256 tokenId) internal virtual {
1699         require(to != address(0), "ERC721: mint to the zero address");
1700         require(!_exists(tokenId), "ERC721: token already minted");
1701 
1702         _beforeTokenTransfer(address(0), to, tokenId);
1703 
1704         _holderTokens[to].add(tokenId);
1705 
1706         _tokenOwners.set(tokenId, to);
1707 
1708         emit Transfer(address(0), to, tokenId);
1709     }
1710 
1711     /**
1712      * @dev Destroys `tokenId`.
1713      * The approval is cleared when the token is burned.
1714      *
1715      * Requirements:
1716      *
1717      * - `tokenId` must exist.
1718      *
1719      * Emits a {Transfer} event.
1720      */
1721     function _burn(uint256 tokenId) internal virtual {
1722         address owner = ERC721.ownerOf(tokenId); // internal owner
1723 
1724         _beforeTokenTransfer(owner, address(0), tokenId);
1725 
1726         // Clear approvals
1727         _approve(address(0), tokenId);
1728 
1729         // Clear metadata (if any)
1730         if (bytes(_tokenURIs[tokenId]).length != 0) {
1731             delete _tokenURIs[tokenId];
1732         }
1733 
1734         _holderTokens[owner].remove(tokenId);
1735 
1736         _tokenOwners.remove(tokenId);
1737 
1738         emit Transfer(owner, address(0), tokenId);
1739     }
1740 
1741     /**
1742      * @dev Transfers `tokenId` from `from` to `to`.
1743      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1744      *
1745      * Requirements:
1746      *
1747      * - `to` cannot be the zero address.
1748      * - `tokenId` token must be owned by `from`.
1749      *
1750      * Emits a {Transfer} event.
1751      */
1752     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1753         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1754         require(to != address(0), "ERC721: transfer to the zero address");
1755 
1756         _beforeTokenTransfer(from, to, tokenId);
1757 
1758         // Clear approvals from the previous owner
1759         _approve(address(0), tokenId);
1760 
1761         _holderTokens[from].remove(tokenId);
1762         _holderTokens[to].add(tokenId);
1763 
1764         _tokenOwners.set(tokenId, to);
1765 
1766         emit Transfer(from, to, tokenId);
1767     }
1768 
1769     /**
1770      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1771      *
1772      * Requirements:
1773      *
1774      * - `tokenId` must exist.
1775      */
1776     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1777         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1778         _tokenURIs[tokenId] = _tokenURI;
1779     }
1780 
1781     /**
1782      * @dev Internal function to set the base URI for all token IDs. It is
1783      * automatically added as a prefix to the value returned in {tokenURI},
1784      * or to the token ID if {tokenURI} is empty.
1785      */
1786     function _setBaseURI(string memory baseURI_) internal virtual {
1787         _baseURI = baseURI_;
1788     }
1789 
1790     /**
1791      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1792      * The call is not executed if the target address is not a contract.
1793      *
1794      * @param from address representing the previous owner of the given token ID
1795      * @param to target address that will receive the tokens
1796      * @param tokenId uint256 ID of the token to be transferred
1797      * @param _data bytes optional data to send along with the call
1798      * @return bool whether the call correctly returned the expected magic value
1799      */
1800     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1801         private returns (bool)
1802     {
1803         if (!to.isContract()) {
1804             return true;
1805         }
1806         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1807             IERC721Receiver(to).onERC721Received.selector,
1808             _msgSender(),
1809             from,
1810             tokenId,
1811             _data
1812         ), "ERC721: transfer to non ERC721Receiver implementer");
1813         bytes4 retval = abi.decode(returndata, (bytes4));
1814         return (retval == _ERC721_RECEIVED);
1815     }
1816 
1817     /**
1818      * @dev Approve `to` to operate on `tokenId`
1819      *
1820      * Emits an {Approval} event.
1821      */
1822     function _approve(address to, uint256 tokenId) internal virtual {
1823         _tokenApprovals[tokenId] = to;
1824         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1825     }
1826 
1827     /**
1828      * @dev Hook that is called before any token transfer. This includes minting
1829      * and burning.
1830      *
1831      * Calling conditions:
1832      *
1833      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1834      * transferred to `to`.
1835      * - When `from` is zero, `tokenId` will be minted for `to`.
1836      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1837      * - `from` cannot be the zero address.
1838      * - `to` cannot be the zero address.
1839      *
1840      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1841      */
1842     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1843 }
1844 
1845 // File: @openzeppelin/contracts/access/Ownable.sol
1846 
1847 
1848 
1849 pragma solidity >=0.6.2 <0.8.0;
1850 
1851 /**
1852  * @dev Contract module which provides a basic access control mechanism, where
1853  * there is an account (an owner) that can be granted exclusive access to
1854  * specific functions.
1855  *
1856  * By default, the owner account will be the one that deploys the contract. This
1857  * can later be changed with {transferOwnership}.
1858  *
1859  * This module is used through inheritance. It will make available the modifier
1860  * `onlyOwner`, which can be applied to your functions to restrict their use to
1861  * the owner.
1862  */
1863 abstract contract Ownable is Context {
1864     address private _owner;
1865 
1866     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1867 
1868     /**
1869      * @dev Initializes the contract setting the deployer as the initial owner.
1870      */
1871     constructor () internal {
1872         address msgSender = _msgSender();
1873         _owner = msgSender;
1874         emit OwnershipTransferred(address(0), msgSender);
1875     }
1876 
1877     /**
1878      * @dev Returns the address of the current owner.
1879      */
1880     function owner() public view virtual returns (address) {
1881         return _owner;
1882     }
1883 
1884     /**
1885      * @dev Throws if called by any account other than the owner.
1886      */
1887     modifier onlyOwner() {
1888         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1889         _;
1890     }
1891 
1892     /**
1893      * @dev Leaves the contract without owner. It will not be possible to call
1894      * `onlyOwner` functions anymore. Can only be called by the current owner.
1895      *
1896      * NOTE: Renouncing ownership will leave the contract without an owner,
1897      * thereby removing any functionality that is only available to the owner.
1898      */
1899     function renounceOwnership() public virtual onlyOwner {
1900         emit OwnershipTransferred(_owner, address(0));
1901         _owner = address(0);
1902     }
1903 
1904     /**
1905      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1906      * Can only be called by the current owner.
1907      */
1908     function transferOwnership(address newOwner) public virtual onlyOwner {
1909         require(newOwner != address(0), "Ownable: new owner is the zero address");
1910         emit OwnershipTransferred(_owner, newOwner);
1911         _owner = newOwner;
1912     }
1913 }
1914 
1915 
1916 
1917 
1918 
1919 
1920 //artist/dev/publciity - @emoshunsNFT (twitter)
1921 
1922 
1923 pragma solidity >=0.6.2 <0.8.0;
1924 pragma abicoder v2;
1925 
1926 contract emoshuns is ERC721, Ownable {
1927 
1928     using SafeMath for uint256;
1929 
1930     uint256 public constant emoshunsPrice = 0e10; 
1931 
1932     uint public constant maxEmoshunsPurchase = 10;
1933 
1934     uint256 public constant MAX_EMOSHUNS = 5000;
1935       
1936     bool public saleIsActive = false;
1937 
1938     constructor() ERC721("emoshuns", "EMOSH") { }
1939 
1940     function withdraw() public onlyOwner {
1941         uint balance = address(this).balance;
1942         msg.sender.transfer(balance);
1943     }
1944 
1945     function setBaseURI(string memory baseURI) public onlyOwner {
1946         _setBaseURI(baseURI);
1947     }
1948 
1949 
1950     function flipSaleState() public onlyOwner {
1951         saleIsActive = !saleIsActive;
1952     }
1953 
1954 
1955     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1956         uint256 tokenCount = balanceOf(_owner);
1957         if (tokenCount == 0) {
1958             // Return an empty array
1959             return new uint256[](0);
1960         } else {
1961             uint256[] memory result = new uint256[](tokenCount);
1962             uint256 index;
1963             for (index = 0; index < tokenCount; index++) {
1964                 result[index] = tokenOfOwnerByIndex(_owner, index);
1965             }
1966             return result;
1967         }
1968     }
1969 
1970     
1971 
1972     function mintEmoshuns(uint numberOfTokens) public payable {
1973         require(saleIsActive, "Sale must be active to mint emoshuns");
1974         require(numberOfTokens > 0 && numberOfTokens <= maxEmoshunsPurchase, "Can only mint 10 tokens at a time");
1975         require(totalSupply().add(numberOfTokens) <= MAX_EMOSHUNS, "Purchase would exceed max supply of emoshuns");
1976         require(msg.value >= emoshunsPrice.mul(numberOfTokens), "Ether value sent is not correct");
1977 
1978         for(uint i = 0; i < numberOfTokens; i++) {
1979             uint mintIndex = totalSupply();
1980             if (totalSupply() < MAX_EMOSHUNS) {
1981                 _safeMint(msg.sender, mintIndex);
1982             }
1983         }
1984 
1985     }
1986 
1987 }