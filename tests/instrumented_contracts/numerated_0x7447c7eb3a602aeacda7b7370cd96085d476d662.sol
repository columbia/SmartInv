1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 interface IERC721 is IERC165 {
29     /**
30      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33 
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
41      */
42     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
43 
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48 
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57 
58     /**
59      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
60      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(address from, address to, uint256 tokenId) external;
73 
74     /**
75      * @dev Transfers `tokenId` token from `from` to `to`.
76      *
77      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
78      *
79      * Requirements:
80      *
81      * - `from` cannot be the zero address.
82      * - `to` cannot be the zero address.
83      * - `tokenId` token must be owned by `from`.
84      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address from, address to, uint256 tokenId) external;
89 
90     /**
91      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
92      * The approval is cleared when the token is transferred.
93      *
94      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
95      *
96      * Requirements:
97      *
98      * - The caller must own the token or be an approved operator.
99      * - `tokenId` must exist.
100      *
101      * Emits an {Approval} event.
102      */
103     function approve(address to, uint256 tokenId) external;
104 
105     /**
106      * @dev Returns the account approved for `tokenId` token.
107      *
108      * Requirements:
109      *
110      * - `tokenId` must exist.
111      */
112     function getApproved(uint256 tokenId) external view returns (address operator);
113 
114     /**
115      * @dev Approve or remove `operator` as an operator for the caller.
116      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
117      *
118      * Requirements:
119      *
120      * - The `operator` cannot be the caller.
121      *
122      * Emits an {ApprovalForAll} event.
123      */
124     function setApprovalForAll(address operator, bool _approved) external;
125 
126     /**
127      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
128      *
129      * See {setApprovalForAll}
130      */
131     function isApprovedForAll(address owner, address operator) external view returns (bool);
132 
133     /**
134       * @dev Safely transfers `tokenId` token from `from` to `to`.
135       *
136       * Requirements:
137       *
138       * - `from` cannot be the zero address.
139       * - `to` cannot be the zero address.
140       * - `tokenId` token must exist and be owned by `from`.
141       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143       *
144       * Emits a {Transfer} event.
145       */
146     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
147 }
148 
149 /**
150  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
151  * @dev See https://eips.ethereum.org/EIPS/eip-721
152  */
153 interface IERC721Metadata is IERC721 {
154 
155     /**
156      * @dev Returns the token collection name.
157      */
158     function name() external view returns (string memory);
159 
160     /**
161      * @dev Returns the token collection symbol.
162      */
163     function symbol() external view returns (string memory);
164 
165     /**
166      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
167      */
168     function tokenURI(uint256 tokenId) external view returns (string memory);
169 }
170 
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Enumerable is IERC721 {
176 
177     /**
178      * @dev Returns the total amount of tokens stored by the contract.
179      */
180     function totalSupply() external view returns (uint256);
181 
182     /**
183      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
184      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
185      */
186     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
187 
188     /**
189      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
190      * Use along with {totalSupply} to enumerate all tokens.
191      */
192     function tokenByIndex(uint256 index) external view returns (uint256);
193 }
194 
195 /**
196  * @title ERC721 token receiver interface
197  * @dev Interface for any contract that wants to support safeTransfers
198  * from ERC721 asset contracts.
199  */
200 interface IERC721Receiver {
201     /**
202      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
203      * by `operator` from `from`, this function is called.
204      *
205      * It must return its Solidity selector to confirm the token transfer.
206      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
207      *
208      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
209      */
210     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
211 }
212 
213 /*
214  * @dev Provides information about the current execution context, including the
215  * sender of the transaction and its data. While these are generally available
216  * via msg.sender and msg.data, they should not be accessed in such a direct
217  * manner, since when dealing with GSN meta-transactions the account sending and
218  * paying for execution may not be the actual sender (as far as an application
219  * is concerned).
220  *
221  * This contract is only required for intermediate, library-like contracts.
222  */
223 abstract contract Context {
224     function _msgSender() internal view virtual returns (address payable) {
225         return msg.sender;
226     }
227 
228     function _msgData() internal view virtual returns (bytes memory) {
229         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
230         return msg.data;
231     }
232 }
233 
234 /**
235  * @dev Implementation of the {IERC165} interface.
236  *
237  * Contracts may inherit from this and call {_registerInterface} to declare
238  * their support of an interface.
239  */
240 abstract contract ERC165 is IERC165 {
241     /*
242      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
243      */
244     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
245 
246     /**
247      * @dev Mapping of interface ids to whether or not it's supported.
248      */
249     mapping(bytes4 => bool) private _supportedInterfaces;
250 
251     constructor () {
252         // Derived contracts need only register support for their own interfaces,
253         // we register support for ERC165 itself here
254         _registerInterface(_INTERFACE_ID_ERC165);
255     }
256 
257     /**
258      * @dev See {IERC165-supportsInterface}.
259      *
260      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
261      */
262     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
263         return _supportedInterfaces[interfaceId];
264     }
265 
266     /**
267      * @dev Registers the contract as an implementer of the interface defined by
268      * `interfaceId`. Support of the actual ERC165 interface is automatic and
269      * registering its interface id is not required.
270      *
271      * See {IERC165-supportsInterface}.
272      *
273      * Requirements:
274      *
275      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
276      */
277     function _registerInterface(bytes4 interfaceId) internal virtual {
278         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
279         _supportedInterfaces[interfaceId] = true;
280     }
281 }
282 
283 /**
284  * @dev Contract module which provides a basic access control mechanism, where
285  * there is an account (an owner) that can be granted exclusive access to
286  * specific functions.
287  *
288  * By default, the owner account will be the one that deploys the contract. This
289  * can later be changed with {transferOwnership}.
290  *
291  * This module is used through inheritance. It will make available the modifier
292  * `onlyOwner`, which can be applied to your functions to restrict their use to
293  * the owner.
294  */
295 abstract contract Ownable is Context {
296     address private _owner;
297 
298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
299 
300     /**
301      * @dev Initializes the contract setting the deployer as the initial owner.
302      */
303     constructor () {
304         address msgSender = _msgSender();
305         _owner = msgSender;
306         emit OwnershipTransferred(address(0), msgSender);
307     }
308 
309     /**
310      * @dev Returns the address of the current owner.
311      */
312     function owner() public view virtual returns (address) {
313         return _owner;
314     }
315 
316     /**
317      * @dev Throws if called by any account other than the owner.
318      */
319     modifier onlyOwner() {
320         require(owner() == _msgSender(), "Ownable: caller is not the owner");
321         _;
322     }
323 
324     /**
325      * @dev Leaves the contract without owner. It will not be possible to call
326      * `onlyOwner` functions anymore. Can only be called by the current owner.
327      *
328      * NOTE: Renouncing ownership will leave the contract without an owner,
329      * thereby removing any functionality that is only available to the owner.
330      */
331     function renounceOwnership() public virtual onlyOwner {
332         emit OwnershipTransferred(_owner, address(0));
333         _owner = address(0);
334     }
335 
336     /**
337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
338      * Can only be called by the current owner.
339      */
340     function transferOwnership(address newOwner) public virtual onlyOwner {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345 }
346 
347 /**
348  * @dev Wrappers over Solidity's arithmetic operations with added overflow
349  * checks.
350  *
351  * Arithmetic operations in Solidity wrap on overflow. This can easily result
352  * in bugs, because programmers usually assume that an overflow raises an
353  * error, which is the standard behavior in high level programming languages.
354  * `SafeMath` restores this intuition by reverting the transaction when an
355  * operation overflows.
356  *
357  * Using this library instead of the unchecked operations eliminates an entire
358  * class of bugs, so it's recommended to use it always.
359  */
360 library SafeMath {
361     /**
362      * @dev Returns the addition of two unsigned integers, with an overflow flag.
363      *
364      * _Available since v3.4._
365      */
366     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
367         uint256 c = a + b;
368         if (c < a) return (false, 0);
369         return (true, c);
370     }
371 
372     /**
373      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
374      *
375      * _Available since v3.4._
376      */
377     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
378         if (b > a) return (false, 0);
379         return (true, a - b);
380     }
381 
382     /**
383      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
389         // benefit is lost if 'b' is also tested.
390         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
391         if (a == 0) return (true, 0);
392         uint256 c = a * b;
393         if (c / a != b) return (false, 0);
394         return (true, c);
395     }
396 
397     /**
398      * @dev Returns the division of two unsigned integers, with a division by zero flag.
399      *
400      * _Available since v3.4._
401      */
402     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
403         if (b == 0) return (false, 0);
404         return (true, a / b);
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         if (b == 0) return (false, 0);
414         return (true, a % b);
415     }
416 
417     /**
418      * @dev Returns the addition of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `+` operator.
422      *
423      * Requirements:
424      *
425      * - Addition cannot overflow.
426      */
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         uint256 c = a + b;
429         require(c >= a, "SafeMath: addition overflow");
430         return c;
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting on
435      * overflow (when the result is negative).
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      *
441      * - Subtraction cannot overflow.
442      */
443     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b <= a, "SafeMath: subtraction overflow");
445         return a - b;
446     }
447 
448     /**
449      * @dev Returns the multiplication of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `*` operator.
453      *
454      * Requirements:
455      *
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         if (a == 0) return 0;
460         uint256 c = a * b;
461         require(c / a == b, "SafeMath: multiplication overflow");
462         return c;
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers, reverting on
467      * division by zero. The result is rounded towards zero.
468      *
469      * Counterpart to Solidity's `/` operator. Note: this function uses a
470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
471      * uses an invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         require(b > 0, "SafeMath: division by zero");
479         return a / b;
480     }
481 
482     /**
483      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
484      * reverting when dividing by zero.
485      *
486      * Counterpart to Solidity's `%` operator. This function uses a `revert`
487      * opcode (which leaves remaining gas untouched) while Solidity uses an
488      * invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
495         require(b > 0, "SafeMath: modulo by zero");
496         return a % b;
497     }
498 
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
501      * overflow (when the result is negative).
502      *
503      * CAUTION: This function is deprecated because it requires allocating memory for the error
504      * message unnecessarily. For custom revert reasons use {trySub}.
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         return a - b;
515     }
516 
517     /**
518      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
519      * division by zero. The result is rounded towards zero.
520      *
521      * CAUTION: This function is deprecated because it requires allocating memory for the error
522      * message unnecessarily. For custom revert reasons use {tryDiv}.
523      *
524      * Counterpart to Solidity's `/` operator. Note: this function uses a
525      * `revert` opcode (which leaves remaining gas untouched) while Solidity
526      * uses an invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
533         require(b > 0, errorMessage);
534         return a / b;
535     }
536 
537     /**
538      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
539      * reverting with custom message when dividing by zero.
540      *
541      * CAUTION: This function is deprecated because it requires allocating memory for the error
542      * message unnecessarily. For custom revert reasons use {tryMod}.
543      *
544      * Counterpart to Solidity's `%` operator. This function uses a `revert`
545      * opcode (which leaves remaining gas untouched) while Solidity uses an
546      * invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
553         require(b > 0, errorMessage);
554         return a % b;
555     }
556 }
557 
558 /**
559  * @dev Collection of functions related to the address type
560  */
561 library Address {
562     /**
563      * @dev Returns true if `account` is a contract.
564      *
565      * [IMPORTANT]
566      * ====
567      * It is unsafe to assume that an address for which this function returns
568      * false is an externally-owned account (EOA) and not a contract.
569      *
570      * Among others, `isContract` will return false for the following
571      * types of addresses:
572      *
573      *  - an externally-owned account
574      *  - a contract in construction
575      *  - an address where a contract will be created
576      *  - an address where a contract lived, but was destroyed
577      * ====
578      */
579     function isContract(address account) internal view returns (bool) {
580         // This method relies on extcodesize, which returns 0 for contracts in
581         // construction, since the code is only stored at the end of the
582         // constructor execution.
583 
584         uint256 size;
585         // solhint-disable-next-line no-inline-assembly
586         assembly { size := extcodesize(account) }
587         return size > 0;
588     }
589 
590     /**
591      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
592      * `recipient`, forwarding all available gas and reverting on errors.
593      *
594      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
595      * of certain opcodes, possibly making contracts go over the 2300 gas limit
596      * imposed by `transfer`, making them unable to receive funds via
597      * `transfer`. {sendValue} removes this limitation.
598      *
599      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
600      *
601      * IMPORTANT: because control is transferred to `recipient`, care must be
602      * taken to not create reentrancy vulnerabilities. Consider using
603      * {ReentrancyGuard} or the
604      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
605      */
606     function sendValue(address payable recipient, uint256 amount) internal {
607         require(address(this).balance >= amount, "Address: insufficient balance");
608 
609         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
610         (bool success, ) = recipient.call{ value: amount }("");
611         require(success, "Address: unable to send value, recipient may have reverted");
612     }
613 
614     /**
615      * @dev Performs a Solidity function call using a low level `call`. A
616      * plain`call` is an unsafe replacement for a function call: use this
617      * function instead.
618      *
619      * If `target` reverts with a revert reason, it is bubbled up by this
620      * function (like regular Solidity function calls).
621      *
622      * Returns the raw returned data. To convert to the expected return value,
623      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
624      *
625      * Requirements:
626      *
627      * - `target` must be a contract.
628      * - calling `target` with `data` must not revert.
629      *
630      * _Available since v3.1._
631      */
632     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
633         return functionCall(target, data, "Address: low-level call failed");
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
638      * `errorMessage` as a fallback revert reason when `target` reverts.
639      *
640      * _Available since v3.1._
641      */
642     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
643         return functionCallWithValue(target, data, 0, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but also transferring `value` wei to `target`.
649      *
650      * Requirements:
651      *
652      * - the calling contract must have an ETH balance of at least `value`.
653      * - the called Solidity function must be `payable`.
654      *
655      * _Available since v3.1._
656      */
657     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
658         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
659     }
660 
661     /**
662      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
663      * with `errorMessage` as a fallback revert reason when `target` reverts.
664      *
665      * _Available since v3.1._
666      */
667     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
668         require(address(this).balance >= value, "Address: insufficient balance for call");
669         require(isContract(target), "Address: call to non-contract");
670 
671         // solhint-disable-next-line avoid-low-level-calls
672         (bool success, bytes memory returndata) = target.call{ value: value }(data);
673         return _verifyCallResult(success, returndata, errorMessage);
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
678      * but performing a static call.
679      *
680      * _Available since v3.3._
681      */
682     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
683         return functionStaticCall(target, data, "Address: low-level static call failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
688      * but performing a static call.
689      *
690      * _Available since v3.3._
691      */
692     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
693         require(isContract(target), "Address: static call to non-contract");
694 
695         // solhint-disable-next-line avoid-low-level-calls
696         (bool success, bytes memory returndata) = target.staticcall(data);
697         return _verifyCallResult(success, returndata, errorMessage);
698     }
699 
700     /**
701      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
702      * but performing a delegate call.
703      *
704      * _Available since v3.4._
705      */
706     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
707         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
712      * but performing a delegate call.
713      *
714      * _Available since v3.4._
715      */
716     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
717         require(isContract(target), "Address: delegate call to non-contract");
718 
719         // solhint-disable-next-line avoid-low-level-calls
720         (bool success, bytes memory returndata) = target.delegatecall(data);
721         return _verifyCallResult(success, returndata, errorMessage);
722     }
723 
724     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
725         if (success) {
726             return returndata;
727         } else {
728             // Look for revert reason and bubble it up if present
729             if (returndata.length > 0) {
730                 // The easiest way to bubble the revert reason is using memory via assembly
731 
732                 // solhint-disable-next-line no-inline-assembly
733                 assembly {
734                     let returndata_size := mload(returndata)
735                     revert(add(32, returndata), returndata_size)
736                 }
737             } else {
738                 revert(errorMessage);
739             }
740         }
741     }
742 }
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
859     /**
860      * @dev Returns the value stored at position `index` in the set. O(1).
861      *
862      * Note that there are no guarantees on the ordering of values inside the
863      * array, and it may change when more values are added or removed.
864      *
865      * Requirements:
866      *
867      * - `index` must be strictly less than {length}.
868      */
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
914     /**
915      * @dev Returns the value stored at position `index` in the set. O(1).
916      *
917      * Note that there are no guarantees on the ordering of values inside the
918      * array, and it may change when more values are added or removed.
919      *
920      * Requirements:
921      *
922      * - `index` must be strictly less than {length}.
923      */
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
968     /**
969      * @dev Returns the value stored at position `index` in the set. O(1).
970      *
971      * Note that there are no guarantees on the ordering of values inside the
972      * array, and it may change when more values are added or removed.
973      *
974      * Requirements:
975      *
976      * - `index` must be strictly less than {length}.
977      */
978     function at(AddressSet storage set, uint256 index) internal view returns (address) {
979         return address(uint160(uint256(_at(set._inner, index))));
980     }
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
1022     /**
1023      * @dev Returns the value stored at position `index` in the set. O(1).
1024      *
1025      * Note that there are no guarantees on the ordering of values inside the
1026      * array, and it may change when more values are added or removed.
1027      *
1028      * Requirements:
1029      *
1030      * - `index` must be strictly less than {length}.
1031      */
1032     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1033         return uint256(_at(set._inner, index));
1034     }
1035 }
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
1161     /**
1162      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1163      *
1164      * Note that there are no guarantees on the ordering of entries inside the
1165      * array, and it may change when more entries are added or removed.
1166      *
1167      * Requirements:
1168      *
1169      * - `index` must be strictly less than {length}.
1170      */
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
1253     /**
1254      * @dev Returns the element stored at position `index` in the set. O(1).
1255      * Note that there are no guarantees on the ordering of values inside the
1256      * array, and it may change when more values are added or removed.
1257      *
1258      * Requirements:
1259      *
1260      * - `index` must be strictly less than {length}.
1261      */
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
1300 /**
1301  * @dev String operations.
1302  */
1303 library Strings {
1304     /**
1305      * @dev Converts a `uint256` to its ASCII `string` representation.
1306      */
1307     function toString(uint256 value) internal pure returns (string memory) {
1308         // Inspired by OraclizeAPI's implementation - MIT licence
1309         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1310 
1311         if (value == 0) {
1312             return "0";
1313         }
1314         uint256 temp = value;
1315         uint256 digits;
1316         while (temp != 0) {
1317             digits++;
1318             temp /= 10;
1319         }
1320         bytes memory buffer = new bytes(digits);
1321         uint256 index = digits - 1;
1322         temp = value;
1323         while (temp != 0) {
1324             buffer[index--] = bytes1(uint8(48 + temp % 10));
1325             temp /= 10;
1326         }
1327         return string(buffer);
1328     }
1329 }
1330 
1331 /**
1332  * @title ERC721 Non-Fungible Token Standard basic implementation
1333  * @dev see https://eips.ethereum.org/EIPS/eip-721
1334  */
1335 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1336     using SafeMath for uint256;
1337     using Address for address;
1338     using EnumerableSet for EnumerableSet.UintSet;
1339     using EnumerableMap for EnumerableMap.UintToAddressMap;
1340     using Strings for uint256;
1341 
1342     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1343     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1344     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1345 
1346     // Mapping from holder address to their (enumerable) set of owned tokens
1347     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1348 
1349     // Enumerable mapping from token ids to their owners
1350     EnumerableMap.UintToAddressMap private _tokenOwners;
1351 
1352     // Mapping from token ID to approved address
1353     mapping (uint256 => address) private _tokenApprovals;
1354 
1355     // Mapping from owner to operator approvals
1356     mapping (address => mapping (address => bool)) private _operatorApprovals;
1357 
1358     // Token name
1359     string private _name;
1360 
1361     // Token symbol
1362     string private _symbol;
1363 
1364     // Optional mapping for token URIs
1365     mapping (uint256 => string) private _tokenURIs;
1366 
1367     // Base URI
1368     string private _baseURI;
1369 
1370     /*
1371      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1372      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1373      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1374      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1375      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1376      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1377      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1378      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1379      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1380      *
1381      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1382      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1383      */
1384     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1385 
1386     /*
1387      *     bytes4(keccak256('name()')) == 0x06fdde03
1388      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1389      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1390      *
1391      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1392      */
1393     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1394 
1395     /*
1396      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1397      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1398      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1399      *
1400      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1401      */
1402     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1403 
1404     /**
1405      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1406      */
1407     constructor (string memory name_, string memory symbol_) {
1408         _name = name_;
1409         _symbol = symbol_;
1410 
1411         // register the supported interfaces to conform to ERC721 via ERC165
1412         _registerInterface(_INTERFACE_ID_ERC721);
1413         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1414         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1415     }
1416 
1417     /**
1418      * @dev See {IERC721-balanceOf}.
1419      */
1420     function balanceOf(address owner) public view virtual override returns (uint256) {
1421         require(owner != address(0), "ERC721: balance query for the zero address");
1422         return _holderTokens[owner].length();
1423     }
1424 
1425     /**
1426      * @dev See {IERC721-ownerOf}.
1427      */
1428     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1429         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Metadata-name}.
1434      */
1435     function name() public view virtual override returns (string memory) {
1436         return _name;
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Metadata-symbol}.
1441      */
1442     function symbol() public view virtual override returns (string memory) {
1443         return _symbol;
1444     }
1445 
1446     /**
1447      * @dev See {IERC721Metadata-tokenURI}.
1448      */
1449     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1450         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1451 
1452         string memory _tokenURI = _tokenURIs[tokenId];
1453         string memory base = baseURI();
1454 
1455         // If there is no base URI, return the token URI.
1456         if (bytes(base).length == 0) {
1457             return _tokenURI;
1458         }
1459         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1460         if (bytes(_tokenURI).length > 0) {
1461             return string(abi.encodePacked(base, _tokenURI));
1462         }
1463         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1464         return string(abi.encodePacked(base, tokenId.toString()));
1465     }
1466 
1467     /**
1468     * @dev Returns the base URI set via {_setBaseURI}. This will be
1469     * automatically added as a prefix in {tokenURI} to each token's URI, or
1470     * to the token ID if no specific URI is set for that token ID.
1471     */
1472     function baseURI() public view virtual returns (string memory) {
1473         return _baseURI;
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1478      */
1479     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1480         return _holderTokens[owner].at(index);
1481     }
1482 
1483     /**
1484      * @dev See {IERC721Enumerable-totalSupply}.
1485      */
1486     function totalSupply() public view virtual override returns (uint256) {
1487         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1488         return _tokenOwners.length();
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Enumerable-tokenByIndex}.
1493      */
1494     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1495         (uint256 tokenId, ) = _tokenOwners.at(index);
1496         return tokenId;
1497     }
1498 
1499     /**
1500      * @dev See {IERC721-approve}.
1501      */
1502     function approve(address to, uint256 tokenId) public virtual override {
1503         address owner = ERC721.ownerOf(tokenId);
1504         require(to != owner, "ERC721: approval to current owner");
1505 
1506         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1507             "ERC721: approve caller is not owner nor approved for all"
1508         );
1509 
1510         _approve(to, tokenId);
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-getApproved}.
1515      */
1516     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1517         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1518 
1519         return _tokenApprovals[tokenId];
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-setApprovalForAll}.
1524      */
1525     function setApprovalForAll(address operator, bool approved) public virtual override {
1526         require(operator != _msgSender(), "ERC721: approve to caller");
1527 
1528         _operatorApprovals[_msgSender()][operator] = approved;
1529         emit ApprovalForAll(_msgSender(), operator, approved);
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-isApprovedForAll}.
1534      */
1535     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1536         return _operatorApprovals[owner][operator];
1537     }
1538 
1539     /**
1540      * @dev See {IERC721-transferFrom}.
1541      */
1542     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1543         //solhint-disable-next-line max-line-length
1544         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1545 
1546         _transfer(from, to, tokenId);
1547     }
1548 
1549     /**
1550      * @dev See {IERC721-safeTransferFrom}.
1551      */
1552     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1553         safeTransferFrom(from, to, tokenId, "");
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-safeTransferFrom}.
1558      */
1559     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1560         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1561         _safeTransfer(from, to, tokenId, _data);
1562     }
1563 
1564     /**
1565      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1566      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1567      *
1568      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1569      *
1570      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1571      * implement alternative mechanisms to perform token transfer, such as signature-based.
1572      *
1573      * Requirements:
1574      *
1575      * - `from` cannot be the zero address.
1576      * - `to` cannot be the zero address.
1577      * - `tokenId` token must exist and be owned by `from`.
1578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1579      *
1580      * Emits a {Transfer} event.
1581      */
1582     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1583         _transfer(from, to, tokenId);
1584         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1585     }
1586 
1587     /**
1588      * @dev Returns whether `tokenId` exists.
1589      *
1590      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1591      *
1592      * Tokens start existing when they are minted (`_mint`),
1593      * and stop existing when they are burned (`_burn`).
1594      */
1595     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1596         return _tokenOwners.contains(tokenId);
1597     }
1598 
1599     /**
1600      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      */
1606     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1607         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1608         address owner = ERC721.ownerOf(tokenId);
1609         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1610     }
1611 
1612     /**
1613      * @dev Safely mints `tokenId` and transfers it to `to`.
1614      *
1615      * Requirements:
1616      d*
1617      * - `tokenId` must not exist.
1618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1619      *
1620      * Emits a {Transfer} event.
1621      */
1622     function _safeMint(address to, uint256 tokenId) internal virtual {
1623         _safeMint(to, tokenId, "");
1624     }
1625 
1626     /**
1627      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1628      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1629      */
1630     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1631         _mint(to, tokenId);
1632         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1633     }
1634 
1635     /**
1636      * @dev Mints `tokenId` and transfers it to `to`.
1637      *
1638      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1639      *
1640      * Requirements:
1641      *
1642      * - `tokenId` must not exist.
1643      * - `to` cannot be the zero address.
1644      *
1645      * Emits a {Transfer} event.
1646      */
1647     function _mint(address to, uint256 tokenId) internal virtual {
1648         require(to != address(0), "ERC721: mint to the zero address");
1649         require(!_exists(tokenId), "ERC721: token already minted");
1650 
1651         _beforeTokenTransfer(address(0), to, tokenId);
1652 
1653         _holderTokens[to].add(tokenId);
1654 
1655         _tokenOwners.set(tokenId, to);
1656 
1657         emit Transfer(address(0), to, tokenId);
1658     }
1659 
1660     /**
1661      * @dev Destroys `tokenId`.
1662      * The approval is cleared when the token is burned.
1663      *
1664      * Requirements:
1665      *
1666      * - `tokenId` must exist.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function _burn(uint256 tokenId) internal virtual {
1671         address owner = ERC721.ownerOf(tokenId); // internal owner
1672 
1673         _beforeTokenTransfer(owner, address(0), tokenId);
1674 
1675         // Clear approvals
1676         _approve(address(0), tokenId);
1677 
1678         // Clear metadata (if any)
1679         if (bytes(_tokenURIs[tokenId]).length != 0) {
1680             delete _tokenURIs[tokenId];
1681         }
1682 
1683         _holderTokens[owner].remove(tokenId);
1684 
1685         _tokenOwners.remove(tokenId);
1686 
1687         emit Transfer(owner, address(0), tokenId);
1688     }
1689 
1690     /**
1691      * @dev Transfers `tokenId` from `from` to `to`.
1692      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1693      *
1694      * Requirements:
1695      *
1696      * - `to` cannot be the zero address.
1697      * - `tokenId` token must be owned by `from`.
1698      *
1699      * Emits a {Transfer} event.
1700      */
1701     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1702         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1703         require(to != address(0), "ERC721: transfer to the zero address");
1704 
1705         _beforeTokenTransfer(from, to, tokenId);
1706 
1707         // Clear approvals from the previous owner
1708         _approve(address(0), tokenId);
1709 
1710         _holderTokens[from].remove(tokenId);
1711         _holderTokens[to].add(tokenId);
1712 
1713         _tokenOwners.set(tokenId, to);
1714 
1715         emit Transfer(from, to, tokenId);
1716     }
1717 
1718     /**
1719      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1720      *
1721      * Requirements:
1722      *
1723      * - `tokenId` must exist.
1724      */
1725     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1726         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1727         _tokenURIs[tokenId] = _tokenURI;
1728     }
1729 
1730     /**
1731      * @dev Internal function to set the base URI for all token IDs. It is
1732      * automatically added as a prefix to the value returned in {tokenURI},
1733      * or to the token ID if {tokenURI} is empty.
1734      */
1735     function _setBaseURI(string memory baseURI_) internal virtual {
1736         _baseURI = baseURI_;
1737     }
1738 
1739     /**
1740      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1741      * The call is not executed if the target address is not a contract.
1742      *
1743      * @param from address representing the previous owner of the given token ID
1744      * @param to target address that will receive the tokens
1745      * @param tokenId uint256 ID of the token to be transferred
1746      * @param _data bytes optional data to send along with the call
1747      * @return bool whether the call correctly returned the expected magic value
1748      */
1749     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1750     private returns (bool)
1751     {
1752         if (!to.isContract()) {
1753             return true;
1754         }
1755         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1756                 IERC721Receiver(to).onERC721Received.selector,
1757                 _msgSender(),
1758                 from,
1759                 tokenId,
1760                 _data
1761             ), "ERC721: transfer to non ERC721Receiver implementer");
1762         bytes4 retval = abi.decode(returndata, (bytes4));
1763         return (retval == _ERC721_RECEIVED);
1764     }
1765 
1766     /**
1767      * @dev Approve `to` to operate on `tokenId`
1768      *
1769      * Emits an {Approval} event.
1770      */
1771     function _approve(address to, uint256 tokenId) internal virtual {
1772         _tokenApprovals[tokenId] = to;
1773         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1774     }
1775 
1776     /**
1777      * @dev Hook that is called before any token transfer. This includes minting
1778      * and burning.
1779      *
1780      * Calling conditions:
1781      *
1782      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1783      * transferred to `to`.
1784      * - When `from` is zero, `tokenId` will be minted for `to`.
1785      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1786      * - `from` cannot be the zero address.
1787      * - `to` cannot be the zero address.
1788      *
1789      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1790      */
1791     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1792 }
1793 
1794 contract DogeX is ERC721, Ownable {
1795     using SafeMath for uint256;
1796 
1797     uint256 private _price = 0.08 ether;
1798     uint256 private _maxSupply = 10000;
1799     uint256 private _reserved = 300;
1800     bool private _paused = true;
1801 
1802     constructor(string memory _baseURI) ERC721('DogeX', 'DogeX') {
1803         _setBaseURI(_baseURI);
1804     }
1805 
1806     function mint(uint256 count) public payable {
1807         uint supply = totalSupply();
1808         require(!_paused, "DogeX: Minting is paused!");
1809         require(count > 0, "DogeX: Must mint atleast 1 DogeX!");
1810         require(count <= 20, "DogeX: Can only mint 20 DogeX at a time!");
1811         require(supply + count < _maxSupply-_reserved, "DogeX: Mint will exceeded supply!");
1812         require(msg.value >= _price * count, "DogeX: Insufficient ETH sent!");
1813 
1814         for(uint i = 0; i < count; i++) {
1815             _safeMint(msg.sender, supply+i);
1816         }
1817         if(msg.value > _price * count) {
1818             payable(msg.sender).transfer(msg.value - _price * count);
1819         }
1820     }
1821 
1822     function giveAway(address to, uint256 count) external onlyOwner() {
1823         require(count <= _reserved, "DogeX: Reserve is empty!" );
1824 
1825         uint256 supply = totalSupply();
1826         for(uint256 i; i < count; i++){
1827             _safeMint( to, supply + i );
1828         }
1829         _reserved -= count;
1830     }
1831 
1832     function pause() external onlyOwner() {
1833         require(!_paused, "DogeX: Already paused!");
1834         _paused = true;
1835     }
1836 
1837     function unpause() external onlyOwner() {
1838         require(_paused, "DogeX: Already unpaused!");
1839         _paused = false;
1840     }
1841 
1842     function getPrice() public view returns (uint256) {
1843         return _price;
1844     }
1845 
1846     function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1847         uint256 tokenCount = balanceOf(_owner);
1848         uint256[] memory tokensId = new uint256[](tokenCount);
1849         for (uint256 i = 0; i < tokenCount; i++) {
1850             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1851         }
1852         return tokensId;
1853     }
1854 
1855     function returnSupply() external view returns (uint256) {
1856         return totalSupply();
1857     }
1858 
1859     function withdraw() external onlyOwner() {
1860         uint balance = address(this).balance;
1861         payable(owner()).transfer(balance);
1862     }
1863 
1864     function updateBaseURI(string memory baseURI) external onlyOwner() {
1865         _setBaseURI(baseURI);
1866     }
1867 }