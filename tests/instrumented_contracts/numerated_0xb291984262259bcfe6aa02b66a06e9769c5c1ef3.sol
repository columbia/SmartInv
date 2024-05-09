1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File contracts/token/IERC165.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File contracts/token/IERC721.sol
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(address from, address to, uint256 tokenId) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address from, address to, uint256 tokenId) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145       * @dev Safely transfers `tokenId` token from `from` to `to`.
146       *
147       * Requirements:
148       *
149       * - `from` cannot be the zero address.
150       * - `to` cannot be the zero address.
151       * - `tokenId` token must exist and be owned by `from`.
152       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154       *
155       * Emits a {Transfer} event.
156       */
157     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
158 }
159 
160 
161 // File contracts/IWaifusion.sol
162 
163 pragma solidity ^0.8.0;
164 
165 interface IWaifusion {
166     function withdraw() external;
167     function mintNFT(uint256 num) external payable;
168     function changeName(uint256 tokenId, string memory newName) external;
169     function transferOwnership(address newOwner) external;
170 
171     // Read functions.
172     function getNFTPrice() external view returns (uint256);
173     function totalSupply() external view returns (uint256);
174 }
175 
176 
177 // File contracts/token/IERC20.sol
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Interface of the ERC20 standard as defined in the EIP.
184  */
185 interface IERC20 {
186     function claim(uint256[] memory indices) external returns (uint256);
187     /**
188      * @dev Returns the amount of tokens in existence.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns the amount of tokens owned by `account`.
194      */
195     function balanceOf(address account) external view returns (uint256);
196 
197     /**
198      * @dev Moves `amount` tokens from the caller's account to `recipient`.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transfer(address recipient, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender) external view returns (uint256);
214 
215     /**
216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
221      * that someone may use both the old and the new allowance by unfortunate
222      * transaction ordering. One possible solution to mitigate this race
223      * condition is to first reduce the spender's allowance to 0 and set the
224      * desired value afterwards:
225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address spender, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Moves `amount` tokens from `sender` to `recipient` using the
233      * allowance mechanism. `amount` is then deducted from the caller's
234      * allowance.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Emitted when `value` tokens are moved from one account (`from`) to
244      * another (`to`).
245      *
246      * Note that `value` may be zero.
247      */
248     event Transfer(address indexed from, address indexed to, uint256 value);
249 
250     /**
251      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
252      * a call to {approve}. `value` is the new allowance.
253      */
254     event Approval(address indexed owner, address indexed spender, uint256 value);
255 }
256 
257 
258 // File contracts/utils/Address.sol
259 
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // This method relies on extcodesize, which returns 0 for contracts in
286         // construction, since the code is only stored at the end of the
287         // constructor execution.
288 
289         uint256 size;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { size := extcodesize(account) }
292         return size > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: value }(data);
378         return _verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
388         return functionStaticCall(target, data, "Address: low-level static call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
393      * but performing a static call.
394      *
395      * _Available since v3.3._
396      */
397     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
398         require(isContract(target), "Address: static call to non-contract");
399 
400         // solhint-disable-next-line avoid-low-level-calls
401         (bool success, bytes memory returndata) = target.staticcall(data);
402         return _verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
422         require(isContract(target), "Address: delegate call to non-contract");
423 
424         // solhint-disable-next-line avoid-low-level-calls
425         (bool success, bytes memory returndata) = target.delegatecall(data);
426         return _verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 // solhint-disable-next-line no-inline-assembly
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 
450 // File contracts/token/SafeERC20.sol
451 
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @title SafeERC20
458  * @dev Wrappers around ERC20 operations that throw on failure (when the token
459  * contract returns false). Tokens that return no value (and instead revert or
460  * throw on failure) are also supported, non-reverting calls are assumed to be
461  * successful.
462  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
463  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
464  */
465 library SafeERC20 {
466     using Address for address;
467 
468     function safeTransfer(IERC20 token, address to, uint256 value) internal {
469         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
470     }
471 
472     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
473         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
474     }
475 
476     /**
477      * @dev Deprecated. This function has issues similar to the ones found in
478      * {IERC20-approve}, and its usage is discouraged.
479      *
480      * Whenever possible, use {safeIncreaseAllowance} and
481      * {safeDecreaseAllowance} instead.
482      */
483     function safeApprove(IERC20 token, address spender, uint256 value) internal {
484         // safeApprove should only be called when setting an initial allowance,
485         // or when resetting it to zero. To increase and decrease it, use
486         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
487         // solhint-disable-next-line max-line-length
488         require((value == 0) || (token.allowance(address(this), spender) == 0),
489             "SafeERC20: approve from non-zero to non-zero allowance"
490         );
491         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
492     }
493 
494     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
495         uint256 newAllowance = token.allowance(address(this), spender) + value;
496         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
497     }
498 
499     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
500         unchecked {
501             uint256 oldAllowance = token.allowance(address(this), spender);
502             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
503             uint256 newAllowance = oldAllowance - value;
504             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
505         }
506     }
507 
508     /**
509      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
510      * on the return value: the return value is optional (but if data is returned, it must not be false).
511      * @param token The token targeted by the call.
512      * @param data The call data (encoded using abi.encode or one of its variants).
513      */
514     function _callOptionalReturn(IERC20 token, bytes memory data) private {
515         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
516         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
517         // the target address contains contract code and also asserts for success in the low-level call.
518 
519         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
520         if (returndata.length > 0) { // Return data is optional
521             // solhint-disable-next-line max-line-length
522             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
523         }
524     }
525 }
526 
527 
528 // File contracts/utils/Context.sol
529 
530 
531 pragma solidity ^0.8.0;
532 
533 /*
534  * @dev Provides information about the current execution context, including the
535  * sender of the transaction and its data. While these are generally available
536  * via msg.sender and msg.data, they should not be accessed in such a direct
537  * manner, since when dealing with meta-transactions the account sending and
538  * paying for execution may not be the actual sender (as far as an application
539  * is concerned).
540  *
541  * This contract is only required for intermediate, library-like contracts.
542  */
543 abstract contract Context {
544     function _msgSender() internal view virtual returns (address) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes calldata) {
549         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
550         return msg.data;
551     }
552 }
553 
554 
555 // File contracts/utils/Ownable.sol
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Contract module which provides a basic access control mechanism, where
562  * there is an account (an owner) that can be granted exclusive access to
563  * specific functions.
564  *
565  * By default, the owner account will be the one that deploys the contract. This
566  * can later be changed with {transferOwnership}.
567  *
568  * This module is used through inheritance. It will make available the modifier
569  * `onlyOwner`, which can be applied to your functions to restrict their use to
570  * the owner.
571  */
572 abstract contract Ownable is Context {
573     address private _owner;
574 
575     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
576 
577     /**
578      * @dev Initializes the contract setting the deployer as the initial owner.
579      */
580     constructor () {
581         address msgSender = _msgSender();
582         _owner = msgSender;
583         emit OwnershipTransferred(address(0), msgSender);
584     }
585 
586     /**
587      * @dev Returns the address of the current owner.
588      */
589     function owner() public view virtual returns (address) {
590         return _owner;
591     }
592 
593     /**
594      * @dev Throws if called by any account other than the owner.
595      */
596     modifier onlyOwner() {
597         require(owner() == _msgSender(), "Ownable: caller is not the owner");
598         _;
599     }
600 
601     /**
602      * @dev Leaves the contract without owner. It will not be possible to call
603      * `onlyOwner` functions anymore. Can only be called by the current owner.
604      *
605      * NOTE: Renouncing ownership will leave the contract without an owner,
606      * thereby removing any functionality that is only available to the owner.
607      */
608     function renounceOwnership() public virtual onlyOwner {
609         emit OwnershipTransferred(_owner, address(0));
610         _owner = address(0);
611     }
612 
613     /**
614      * @dev Transfers ownership of the contract to a new account (`newOwner`).
615      * Can only be called by the current owner.
616      */
617     function transferOwnership(address newOwner) public virtual onlyOwner {
618         require(newOwner != address(0), "Ownable: new owner is the zero address");
619         emit OwnershipTransferred(_owner, newOwner);
620         _owner = newOwner;
621     }
622 }
623 
624 
625 // File contracts/WaifuDungeon.sol
626 
627 pragma solidity ^0.8.0;
628 
629 
630 
631 
632 // Author: 0xKiwi. 
633 
634 contract WaifuDungeon is Ownable {
635     address public constant BURN_ADDR = 0x0000000000000000000000000000000000080085;
636     address public constant WET_TOKEN = 0x76280AF9D18a868a0aF3dcA95b57DDE816c1aaf2;
637     address public constant WAIFUSION = 0x2216d47494E516d8206B70FCa8585820eD3C4946;
638     uint256 constant MAX_NFT_SUPPLY = 16384;
639     uint256 public constant MAX_SWAP = 3;
640     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
641 
642     uint256 public buyCost = 0.7 ether;
643     uint256 public swapCost = 5490 ether;
644 
645     uint256 public waifuCount;
646     uint256 public revealNonce;
647 
648     struct Commit {
649         uint64 block;
650         uint64 amount;
651     }
652     mapping (address => Commit) public commits;
653 
654     struct Waifu {
655         address nftContract;
656         uint64 waifuID;
657     }
658     mapping (uint256 => Waifu) public waifusInDungeon;
659 
660     constructor() Ownable() {
661     }
662     
663     receive() external payable {
664     }
665 
666     // This function is executed when a ERC721 is received via safeTransferFrom. This function is purposely strict to ensure 
667     // the NFTs in this contract are all valid.
668     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
669         // Only accept NFTs through this function if they're being funneled.
670         require(msg.sender == WAIFUSION, "WaifuDungeon: NFT not from waifusion");
671         require(operator == address(this), "WaifuDungeon: invalid operator");
672         require(tokenId <= MAX_NFT_SUPPLY, "WaifuDungeon: over max waifus");
673         waifusInDungeon[waifuCount] = Waifu(WAIFUSION, uint64(tokenId));
674         waifuCount++;
675         return _ERC721_RECEIVED;
676     }
677     
678     // This function commits that the sender will purchase a waifu within the next 255 blocks.
679     // If they fail to revealWaifus() within that timeframe. The money they sent is forfeited to reduce complexity.
680     function commitBuyWaifus(uint256 num) external payable {
681         require(msg.value == num * buyCost, "WaifuDungeon: invalid ether to buy");
682         require(num <= 20, "WaifuDungeon: swapping too many");
683         require(num <= waifuCount, "WaifuDungeon: not enough waifus in dungeon");
684         _commitRandomWaifus(num);
685     }
686 
687     // This function commits that the sender will swap a waifu within the next 255 blocks.
688     // If they fail to revealWaifus() within that timeframe. The money they sent is forfeited to reduce complexity.
689     function commitSwapWaifus(uint256[] calldata _ids) external {
690         uint256 amountToSwap = _ids.length;
691         require(amountToSwap <= MAX_SWAP, "WaifuDungeon: swapping too many");
692         require(amountToSwap <= waifuCount, "WaifuDungeon: not enough waifus in dungeon");
693         address _BURN_ADDR = BURN_ADDR;
694         address _WAIFUSION = WAIFUSION;
695         SafeERC20.safeTransferFrom(IERC20(WET_TOKEN), msg.sender, _BURN_ADDR, swapCost*amountToSwap);
696         for (uint256 i = 0; i < amountToSwap; i++) {    
697             // Burn waifu.
698             IERC721(_WAIFUSION).transferFrom(msg.sender, _BURN_ADDR, _ids[i]);
699         }
700         _commitRandomWaifus(amountToSwap);
701     }
702 
703     function revealWaifus() external {
704         uint256[] memory randomIDs = _revealRandomWaifus();
705         for (uint256 i = 0; i < randomIDs.length; i++) { 
706             Waifu memory waifu = waifusInDungeon[randomIDs[i]];
707             IERC721(waifu.nftContract).safeTransferFrom(address(this), msg.sender, uint256(waifu.waifuID));
708         }
709         for (uint256 i = 0; i < randomIDs.length; i++) { 
710             uint256 count = waifuCount;
711             if (randomIDs[i] < count) {
712                 waifusInDungeon[randomIDs[i]] = waifusInDungeon[count-1];
713             }
714             delete waifusInDungeon[count-1];
715             waifuCount--;
716         }
717     }
718 
719     // Permissioned functions.
720 
721     // This function is permissioned and allows the owner to receive ETH from the waifusion contract, 
722     // and uses said funds to buy more NFTs. If there are under 20 waifus remaining in the contract, it should adjust to that.
723     function funnelMaxWaifus() external onlyOwner() {
724         uint256 remainingWaifus = MAX_NFT_SUPPLY - IWaifusion(WAIFUSION).totalSupply();
725         uint256 waifusToMint = remainingWaifus < 20 ? remainingWaifus : 20;
726         if (waifusToMint == 0) {
727             return;
728         }
729         funnelWaifus(waifusToMint);
730     }
731 
732     function funnelWaifus(uint256 num) public onlyOwner() {
733         withdrawFromWaifusion();
734         uint256 nftPrice = IWaifusion(WAIFUSION).getNFTPrice();
735         IWaifusion(WAIFUSION).mintNFT{value: num * nftPrice}(num);
736     }
737 
738     // addNFTToDungeon allows for arbitrary NFT addition to the contract, assuming 
739     // its ID fits within uint48. 
740     function addNFTToDungeon(address nftContract, uint256 nftID) external onlyOwner() {
741         require(nftContract != address(0), "WaifuDungeon: addNFT zero addr");
742         IERC721(nftContract).transferFrom(msg.sender, address(this), nftID);
743         waifusInDungeon[waifuCount] = Waifu(nftContract, uint64(nftID));
744         waifuCount++;
745     }
746 
747     function withdraw() external onlyOwner() {
748         uint256 balance = address(this).balance;
749         payable(msg.sender).transfer(balance);
750     }
751 
752     function withdrawFromWaifusion() public onlyOwner() {
753         IWaifusion(WAIFUSION).withdraw();
754     }
755 
756     function setWaifusionOwner(address newOwner) external onlyOwner() {
757         IWaifusion(WAIFUSION).transferOwnership(newOwner);
758     }
759 
760     function setBuyCost(uint256 newBuyCost) external onlyOwner() {
761         buyCost = newBuyCost;
762     }
763 
764     function setSwapCost(uint256 newSwapCost) external onlyOwner() {
765         swapCost = newSwapCost;
766     }
767 
768     // Internal functions.
769 
770     function _commitRandomWaifus(uint256 num) internal {
771         require(num > 0, "WaifuDungeon: anon, you cant reveal 0 waifus");
772         uint256 currentBlock = block.number;
773         require(commits[msg.sender].block + 255 < currentBlock, "WaifuDungeon: still need to reveal");
774         commits[msg.sender].block = uint64(currentBlock);
775         commits[msg.sender].amount = uint64(num);
776     }
777 
778     function _revealRandomWaifus() internal returns (uint256[] memory) {
779         Commit memory commit = commits[msg.sender];
780         require(commit.amount > 0 && commit.block != 0, "WaifuDungeon: Need to commit");
781         require(commit.block < uint64(block.number), "WaifuDungeon: cannot reveal same block");
782         require(commit.block + 255 >= uint64(block.number), "WaifuDungeon: Revealed too late");
783         commits[msg.sender].block = 0;
784         
785         // Get the hash of the block that happened after they committed.
786         bytes32 revealHash = blockhash(commit.block + 1);
787 
788         uint256[] memory randomIDs = new uint256[](commit.amount); 
789         uint256 _waifuCount = waifuCount;
790         uint256 randomIndex = uint256(keccak256(abi.encodePacked(revealNonce, revealHash))) % _waifuCount;
791         for (uint256 i = 0; i < commit.amount; i++) {
792             randomIDs[i] = randomIndex;
793             randomIndex = (randomIndex + 1) % _waifuCount;
794         }
795         revealNonce++;
796         return randomIDs;
797     }
798 }