1 pragma solidity ^0.6.6;
2 
3 // SPDX-License-Identifier: MIT
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15   function _msgSender() internal view virtual returns (address payable) {
16     return msg.sender;
17   }
18 
19   function _msgData() internal view virtual returns (bytes memory) {
20     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21     return msg.data;
22   }
23 }
24 
25 // SPDX-License-Identifier: MIT
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39   address private _owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   /**
44    * @dev Initializes the contract setting the deployer as the initial owner.
45    */
46   constructor() internal {
47     address msgSender = _msgSender();
48     _owner = msgSender;
49     emit OwnershipTransferred(address(0), msgSender);
50   }
51 
52   /**
53    * @dev Returns the address of the current owner.
54    */
55   function owner() public view returns (address) {
56     return _owner;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(_owner == _msgSender(), "Ownable: caller is not the owner");
64     _;
65   }
66 
67   /**
68    * @dev Leaves the contract without owner. It will not be possible to call
69    * `onlyOwner` functions anymore. Can only be called by the current owner.
70    *
71    * NOTE: Renouncing ownership will leave the contract without an owner,
72    * thereby removing any functionality that is only available to the owner.
73    */
74   function renounceOwnership() public virtual onlyOwner {
75     emit OwnershipTransferred(_owner, address(0));
76     _owner = address(0);
77   }
78 
79   /**
80    * @dev Transfers ownership of the contract to a new account (`newOwner`).
81    * Can only be called by the current owner.
82    */
83   function transferOwnership(address newOwner) public virtual onlyOwner {
84     require(newOwner != address(0), "Ownable: new owner is the zero address");
85     emit OwnershipTransferred(_owner, newOwner);
86     _owner = newOwner;
87   }
88 }
89 
90 // SPDX-License-Identifier: MIT
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105   /**
106    * @dev Returns the addition of two unsigned integers, reverting on
107    * overflow.
108    *
109    * Counterpart to Solidity's `+` operator.
110    *
111    * Requirements:
112    *
113    * - Addition cannot overflow.
114    */
115   function add(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a + b;
117     require(c >= a, "SafeMath: addition overflow");
118 
119     return c;
120   }
121 
122   /**
123    * @dev Returns the subtraction of two unsigned integers, reverting on
124    * overflow (when the result is negative).
125    *
126    * Counterpart to Solidity's `-` operator.
127    *
128    * Requirements:
129    *
130    * - Subtraction cannot overflow.
131    */
132   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133     return sub(a, b, "SafeMath: subtraction overflow");
134   }
135 
136   /**
137    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138    * overflow (when the result is negative).
139    *
140    * Counterpart to Solidity's `-` operator.
141    *
142    * Requirements:
143    *
144    * - Subtraction cannot overflow.
145    */
146   function sub(
147     uint256 a,
148     uint256 b,
149     string memory errorMessage
150   ) internal pure returns (uint256) {
151     require(b <= a, errorMessage);
152     uint256 c = a - b;
153 
154     return c;
155   }
156 
157   /**
158    * @dev Returns the multiplication of two unsigned integers, reverting on
159    * overflow.
160    *
161    * Counterpart to Solidity's `*` operator.
162    *
163    * Requirements:
164    *
165    * - Multiplication cannot overflow.
166    */
167   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169     // benefit is lost if 'b' is also tested.
170     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171     if (a == 0) {
172       return 0;
173     }
174 
175     uint256 c = a * b;
176     require(c / a == b, "SafeMath: multiplication overflow");
177 
178     return c;
179   }
180 
181   /**
182    * @dev Returns the integer division of two unsigned integers. Reverts on
183    * division by zero. The result is rounded towards zero.
184    *
185    * Counterpart to Solidity's `/` operator. Note: this function uses a
186    * `revert` opcode (which leaves remaining gas untouched) while Solidity
187    * uses an invalid opcode to revert (consuming all remaining gas).
188    *
189    * Requirements:
190    *
191    * - The divisor cannot be zero.
192    */
193   function div(uint256 a, uint256 b) internal pure returns (uint256) {
194     return div(a, b, "SafeMath: division by zero");
195   }
196 
197   /**
198    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199    * division by zero. The result is rounded towards zero.
200    *
201    * Counterpart to Solidity's `/` operator. Note: this function uses a
202    * `revert` opcode (which leaves remaining gas untouched) while Solidity
203    * uses an invalid opcode to revert (consuming all remaining gas).
204    *
205    * Requirements:
206    *
207    * - The divisor cannot be zero.
208    */
209   function div(
210     uint256 a,
211     uint256 b,
212     string memory errorMessage
213   ) internal pure returns (uint256) {
214     require(b > 0, errorMessage);
215     uint256 c = a / b;
216     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218     return c;
219   }
220 
221   /**
222    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223    * Reverts when dividing by zero.
224    *
225    * Counterpart to Solidity's `%` operator. This function uses a `revert`
226    * opcode (which leaves remaining gas untouched) while Solidity uses an
227    * invalid opcode to revert (consuming all remaining gas).
228    *
229    * Requirements:
230    *
231    * - The divisor cannot be zero.
232    */
233   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234     return mod(a, b, "SafeMath: modulo by zero");
235   }
236 
237   /**
238    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239    * Reverts with custom message when dividing by zero.
240    *
241    * Counterpart to Solidity's `%` operator. This function uses a `revert`
242    * opcode (which leaves remaining gas untouched) while Solidity uses an
243    * invalid opcode to revert (consuming all remaining gas).
244    *
245    * Requirements:
246    *
247    * - The divisor cannot be zero.
248    */
249   function mod(
250     uint256 a,
251     uint256 b,
252     string memory errorMessage
253   ) internal pure returns (uint256) {
254     require(b != 0, errorMessage);
255     return a % b;
256   }
257 }
258 
259 // SPDX-License-Identifier: MIT
260 /**
261  * @dev Interface of the ERC20 standard as defined in the EIP.
262  */
263 interface IERC20 {
264   /**
265    * @dev Returns the amount of tokens in existence.
266    */
267   function totalSupply() external view returns (uint256);
268 
269   /**
270    * @dev Returns the amount of tokens owned by `account`.
271    */
272   function balanceOf(address account) external view returns (uint256);
273 
274   /**
275    * @dev Moves `amount` tokens from the caller's account to `recipient`.
276    *
277    * Returns a boolean value indicating whether the operation succeeded.
278    *
279    * Emits a {Transfer} event.
280    */
281   function transfer(address recipient, uint256 amount) external returns (bool);
282 
283   /**
284    * @dev Returns the remaining number of tokens that `spender` will be
285    * allowed to spend on behalf of `owner` through {transferFrom}. This is
286    * zero by default.
287    *
288    * This value changes when {approve} or {transferFrom} are called.
289    */
290   function allowance(address owner, address spender) external view returns (uint256);
291 
292   /**
293    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
294    *
295    * Returns a boolean value indicating whether the operation succeeded.
296    *
297    * IMPORTANT: Beware that changing an allowance with this method brings the risk
298    * that someone may use both the old and the new allowance by unfortunate
299    * transaction ordering. One possible solution to mitigate this race
300    * condition is to first reduce the spender's allowance to 0 and set the
301    * desired value afterwards:
302    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303    *
304    * Emits an {Approval} event.
305    */
306   function approve(address spender, uint256 amount) external returns (bool);
307 
308   /**
309    * @dev Moves `amount` tokens from `sender` to `recipient` using the
310    * allowance mechanism. `amount` is then deducted from the caller's
311    * allowance.
312    *
313    * Returns a boolean value indicating whether the operation succeeded.
314    *
315    * Emits a {Transfer} event.
316    */
317   function transferFrom(
318     address sender,
319     address recipient,
320     uint256 amount
321   ) external returns (bool);
322 
323   /**
324    * @dev Emitted when `value` tokens are moved from one account (`from`) to
325    * another (`to`).
326    *
327    * Note that `value` may be zero.
328    */
329   event Transfer(address indexed from, address indexed to, uint256 value);
330 
331   /**
332    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
333    * a call to {approve}. `value` is the new allowance.
334    */
335   event Approval(address indexed owner, address indexed spender, uint256 value);
336 }
337 
338 // SPDX-License-Identifier: MIT
339 interface IERC1155 {
340   event TransferSingle(
341     address indexed _operator,
342     address indexed _from,
343     address indexed _to,
344     uint256 _id,
345     uint256 _amount
346   );
347 
348   event TransferBatch(
349     address indexed _operator,
350     address indexed _from,
351     address indexed _to,
352     uint256[] _ids,
353     uint256[] _amounts
354   );
355 
356   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
357 
358   event URI(string _amount, uint256 indexed _id);
359 
360   function mint(
361     address _to,
362     uint256 _id,
363     uint256 _quantity,
364     bytes calldata _data
365   ) external;
366 
367   function create(
368     uint256 _maxSupply,
369     uint256 _initialSupply,
370     string calldata _uri,
371     bytes calldata _data
372   ) external returns (uint256 tokenId);
373 
374   function safeTransferFrom(
375     address _from,
376     address _to,
377     uint256 _id,
378     uint256 _amount,
379     bytes calldata _data
380   ) external;
381 
382   function safeBatchTransferFrom(
383     address _from,
384     address _to,
385     uint256[] calldata _ids,
386     uint256[] calldata _amounts,
387     bytes calldata _data
388   ) external;
389 
390   function balanceOf(address _owner, uint256 _id) external view returns (uint256);
391 
392   function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
393 
394   function setApprovalForAll(address _operator, bool _approved) external;
395 
396   function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
397 }
398 
399 // SPDX-License-Identifier: MIT
400 /**
401  * @title Roles
402  * @dev Library for managing addresses assigned to a Role.
403  */
404 library Roles {
405   struct Role {
406     mapping(address => bool) bearer;
407   }
408 
409   /**
410    * @dev Give an account access to this role.
411    */
412   function add(Role storage role, address account) internal {
413     require(!has(role, account), "Roles: account already has role");
414     role.bearer[account] = true;
415   }
416 
417   /**
418    * @dev Remove an account's access to this role.
419    */
420   function remove(Role storage role, address account) internal {
421     require(has(role, account), "Roles: account does not have role");
422     role.bearer[account] = false;
423   }
424 
425   /**
426    * @dev Check if an account has this role.
427    * @return bool
428    */
429   function has(Role storage role, address account) internal view returns (bool) {
430     require(account != address(0), "Roles: account is the zero address");
431     return role.bearer[account];
432   }
433 }
434 
435 // SPDX-License-Identifier: MIT
436 contract PauserRole is Context {
437   using Roles for Roles.Role;
438 
439   event PauserAdded(address indexed account);
440   event PauserRemoved(address indexed account);
441 
442   Roles.Role private _pausers;
443 
444   constructor() internal {
445     _addPauser(_msgSender());
446   }
447 
448   modifier onlyPauser() {
449     require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
450     _;
451   }
452 
453   function isPauser(address account) public view returns (bool) {
454     return _pausers.has(account);
455   }
456 
457   function addPauser(address account) public onlyPauser {
458     _addPauser(account);
459   }
460 
461   function renouncePauser() public {
462     _removePauser(_msgSender());
463   }
464 
465   function _addPauser(address account) internal {
466     _pausers.add(account);
467     emit PauserAdded(account);
468   }
469 
470   function _removePauser(address account) internal {
471     _pausers.remove(account);
472     emit PauserRemoved(account);
473   }
474 }
475 
476 // SPDX-License-Identifier: MIT
477 /**
478  * @dev Contract module which allows children to implement an emergency stop
479  * mechanism that can be triggered by an authorized account.
480  *
481  * This module is used through inheritance. It will make available the
482  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
483  * the functions of your contract. Note that they will not be pausable by
484  * simply including this module, only once the modifiers are put in place.
485  */
486 contract Pausable is Context, PauserRole {
487   /**
488    * @dev Emitted when the pause is triggered by a pauser (`account`).
489    */
490   event Paused(address account);
491 
492   /**
493    * @dev Emitted when the pause is lifted by a pauser (`account`).
494    */
495   event Unpaused(address account);
496 
497   bool private _paused;
498 
499   /**
500    * @dev Initializes the contract in unpaused state. Assigns the Pauser role
501    * to the deployer.
502    */
503   constructor() internal {
504     _paused = false;
505   }
506 
507   /**
508    * @dev Returns true if the contract is paused, and false otherwise.
509    */
510   function paused() public view returns (bool) {
511     return _paused;
512   }
513 
514   /**
515    * @dev Modifier to make a function callable only when the contract is not paused.
516    */
517   modifier whenNotPaused() {
518     require(!_paused, "Pausable: paused");
519     _;
520   }
521 
522   /**
523    * @dev Modifier to make a function callable only when the contract is paused.
524    */
525   modifier whenPaused() {
526     require(_paused, "Pausable: not paused");
527     _;
528   }
529 
530   /**
531    * @dev Called by a pauser to pause, triggers stopped state.
532    */
533   function pause() public onlyPauser whenNotPaused {
534     _paused = true;
535     emit Paused(_msgSender());
536   }
537 
538   /**
539    * @dev Called by a pauser to unpause, returns to normal state.
540    */
541   function unpause() public onlyPauser whenPaused {
542     _paused = false;
543     emit Unpaused(_msgSender());
544   }
545 }
546 
547 // SPDX-License-Identifier: MIT
548 /**
549  * @dev Collection of functions related to the address type
550  */
551 library Address {
552   /**
553    * @dev Returns true if `account` is a contract.
554    *
555    * [IMPORTANT]
556    * ====
557    * It is unsafe to assume that an address for which this function returns
558    * false is an externally-owned account (EOA) and not a contract.
559    *
560    * Among others, `isContract` will return false for the following
561    * types of addresses:
562    *
563    *  - an externally-owned account
564    *  - a contract in construction
565    *  - an address where a contract will be created
566    *  - an address where a contract lived, but was destroyed
567    * ====
568    */
569   function isContract(address account) internal view returns (bool) {
570     // This method relies on extcodesize, which returns 0 for contracts in
571     // construction, since the code is only stored at the end of the
572     // constructor execution.
573 
574     uint256 size;
575     // solhint-disable-next-line no-inline-assembly
576     assembly {
577       size := extcodesize(account)
578     }
579     return size > 0;
580   }
581 
582   /**
583    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
584    * `recipient`, forwarding all available gas and reverting on errors.
585    *
586    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
587    * of certain opcodes, possibly making contracts go over the 2300 gas limit
588    * imposed by `transfer`, making them unable to receive funds via
589    * `transfer`. {sendValue} removes this limitation.
590    *
591    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
592    *
593    * IMPORTANT: because control is transferred to `recipient`, care must be
594    * taken to not create reentrancy vulnerabilities. Consider using
595    * {ReentrancyGuard} or the
596    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
597    */
598   function sendValue(address payable recipient, uint256 amount) internal {
599     require(address(this).balance >= amount, "Address: insufficient balance");
600 
601     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
602     (bool success, ) = recipient.call{value: amount}("");
603     require(success, "Address: unable to send value, recipient may have reverted");
604   }
605 
606   /**
607    * @dev Performs a Solidity function call using a low level `call`. A
608    * plain`call` is an unsafe replacement for a function call: use this
609    * function instead.
610    *
611    * If `target` reverts with a revert reason, it is bubbled up by this
612    * function (like regular Solidity function calls).
613    *
614    * Returns the raw returned data. To convert to the expected return value,
615    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
616    *
617    * Requirements:
618    *
619    * - `target` must be a contract.
620    * - calling `target` with `data` must not revert.
621    *
622    * _Available since v3.1._
623    */
624   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
625     return functionCall(target, data, "Address: low-level call failed");
626   }
627 
628   /**
629    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
630    * `errorMessage` as a fallback revert reason when `target` reverts.
631    *
632    * _Available since v3.1._
633    */
634   function functionCall(
635     address target,
636     bytes memory data,
637     string memory errorMessage
638   ) internal returns (bytes memory) {
639     return functionCallWithValue(target, data, 0, errorMessage);
640   }
641 
642   /**
643    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
644    * but also transferring `value` wei to `target`.
645    *
646    * Requirements:
647    *
648    * - the calling contract must have an ETH balance of at least `value`.
649    * - the called Solidity function must be `payable`.
650    *
651    * _Available since v3.1._
652    */
653   function functionCallWithValue(
654     address target,
655     bytes memory data,
656     uint256 value
657   ) internal returns (bytes memory) {
658     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
659   }
660 
661   /**
662    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
663    * with `errorMessage` as a fallback revert reason when `target` reverts.
664    *
665    * _Available since v3.1._
666    */
667   function functionCallWithValue(
668     address target,
669     bytes memory data,
670     uint256 value,
671     string memory errorMessage
672   ) internal returns (bytes memory) {
673     require(address(this).balance >= value, "Address: insufficient balance for call");
674     require(isContract(target), "Address: call to non-contract");
675 
676     // solhint-disable-next-line avoid-low-level-calls
677     (bool success, bytes memory returndata) = target.call{value: value}(data);
678     return _verifyCallResult(success, returndata, errorMessage);
679   }
680 
681   /**
682    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
683    * but performing a static call.
684    *
685    * _Available since v3.3._
686    */
687   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
688     return functionStaticCall(target, data, "Address: low-level static call failed");
689   }
690 
691   /**
692    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
693    * but performing a static call.
694    *
695    * _Available since v3.3._
696    */
697   function functionStaticCall(
698     address target,
699     bytes memory data,
700     string memory errorMessage
701   ) internal view returns (bytes memory) {
702     require(isContract(target), "Address: static call to non-contract");
703 
704     // solhint-disable-next-line avoid-low-level-calls
705     (bool success, bytes memory returndata) = target.staticcall(data);
706     return _verifyCallResult(success, returndata, errorMessage);
707   }
708 
709   function _verifyCallResult(
710     bool success,
711     bytes memory returndata,
712     string memory errorMessage
713   ) private pure returns (bytes memory) {
714     if (success) {
715       return returndata;
716     } else {
717       // Look for revert reason and bubble it up if present
718       if (returndata.length > 0) {
719         // The easiest way to bubble the revert reason is using memory via assembly
720 
721         // solhint-disable-next-line no-inline-assembly
722         assembly {
723           let returndata_size := mload(returndata)
724           revert(add(32, returndata), returndata_size)
725         }
726       } else {
727         revert(errorMessage);
728       }
729     }
730   }
731 }
732 
733 // SPDX-License-Identifier: MIT
734 /**
735  * @title SafeERC20
736  * @dev Wrappers around ERC20 operations that throw on failure (when the token
737  * contract returns false). Tokens that return no value (and instead revert or
738  * throw on failure) are also supported, non-reverting calls are assumed to be
739  * successful.
740  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
741  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
742  */
743 library SafeERC20 {
744   using SafeMath for uint256;
745   using Address for address;
746 
747   function safeTransfer(
748     IERC20 token,
749     address to,
750     uint256 value
751   ) internal {
752     _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
753   }
754 
755   function safeTransferFrom(
756     IERC20 token,
757     address from,
758     address to,
759     uint256 value
760   ) internal {
761     _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
762   }
763 
764   /**
765    * @dev Deprecated. This function has issues similar to the ones found in
766    * {IERC20-approve}, and its usage is discouraged.
767    *
768    * Whenever possible, use {safeIncreaseAllowance} and
769    * {safeDecreaseAllowance} instead.
770    */
771   function safeApprove(
772     IERC20 token,
773     address spender,
774     uint256 value
775   ) internal {
776     // safeApprove should only be called when setting an initial allowance,
777     // or when resetting it to zero. To increase and decrease it, use
778     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
779     // solhint-disable-next-line max-line-length
780     require(
781       (value == 0) || (token.allowance(address(this), spender) == 0),
782       "SafeERC20: approve from non-zero to non-zero allowance"
783     );
784     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
785   }
786 
787   function safeIncreaseAllowance(
788     IERC20 token,
789     address spender,
790     uint256 value
791   ) internal {
792     uint256 newAllowance = token.allowance(address(this), spender).add(value);
793     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
794   }
795 
796   function safeDecreaseAllowance(
797     IERC20 token,
798     address spender,
799     uint256 value
800   ) internal {
801     uint256 newAllowance =
802       token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
803     _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
804   }
805 
806   /**
807    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
808    * on the return value: the return value is optional (but if data is returned, it must not be false).
809    * @param token The token targeted by the call.
810    * @param data The call data (encoded using abi.encode or one of its variants).
811    */
812   function _callOptionalReturn(IERC20 token, bytes memory data) private {
813     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
814     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
815     // the target address contains contract code and also asserts for success in the low-level call.
816 
817     bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
818     if (returndata.length > 0) {
819       // Return data is optional
820       // solhint-disable-next-line max-line-length
821       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
822     }
823   }
824 }
825 
826 // SPDX-License-Identifier: MIT
827 contract PoolTokenWrapper {
828   using SafeMath for uint256;
829   using SafeERC20 for IERC20;
830   IERC20 public token;
831 
832   constructor(IERC20 _erc20Address) public {
833     token = IERC20(_erc20Address);
834   }
835 
836   uint256 private _totalSupply;
837   // Objects balances [id][address] => balance
838   mapping(uint256 => mapping(address => uint256)) internal _balances;
839   mapping(address => uint256) private _accountBalances;
840   mapping(uint256 => uint256) private _poolBalances;
841 
842   function totalSupply() public view returns (uint256) {
843     return _totalSupply;
844   }
845 
846   function balanceOfAccount(address account) public view returns (uint256) {
847     return _accountBalances[account];
848   }
849 
850   function balanceOfPool(uint256 id) public view returns (uint256) {
851     return _poolBalances[id];
852   }
853 
854   function balanceOf(address account, uint256 id) public view returns (uint256) {
855     return _balances[id][account];
856   }
857 
858   function stake(uint256 id, uint256 amount) public virtual {
859     _totalSupply = _totalSupply.add(amount);
860     _poolBalances[id] = _poolBalances[id].add(amount);
861     _accountBalances[msg.sender] = _accountBalances[msg.sender].add(amount);
862     _balances[id][msg.sender] = _balances[id][msg.sender].add(amount);
863     token.safeTransferFrom(msg.sender, address(this), amount);
864   }
865 
866   function withdraw(uint256 id, uint256 amount) public virtual {
867     _totalSupply = _totalSupply.sub(amount);
868     _poolBalances[id] = _poolBalances[id].sub(amount);
869     _accountBalances[msg.sender] = _accountBalances[msg.sender].sub(amount);
870     _balances[id][msg.sender] = _balances[id][msg.sender].sub(amount);
871     token.safeTransfer(msg.sender, amount);
872   }
873 
874   function transfer(
875     uint256 fromId,
876     uint256 toId,
877     uint256 amount
878   ) public virtual {
879     _poolBalances[fromId] = _poolBalances[fromId].sub(amount);
880     _balances[fromId][msg.sender] = _balances[fromId][msg.sender].sub(amount);
881 
882     _poolBalances[toId] = _poolBalances[toId].add(amount);
883     _balances[toId][msg.sender] = _balances[toId][msg.sender].add(amount);
884   }
885 
886   function _rescuePoints(address account, uint256 id) internal {
887     uint256 amount = _balances[id][account];
888 
889     _totalSupply = _totalSupply.sub(amount);
890     _poolBalances[id] = _poolBalances[id].sub(amount);
891     _accountBalances[msg.sender] = _accountBalances[msg.sender].sub(amount);
892     _balances[id][account] = _balances[id][account].sub(amount);
893     token.safeTransfer(account, amount);
894   }
895 }
896 
897 // SPDX-License-Identifier: MIT
898 /**
899  * @dev Contract module that helps prevent reentrant calls to a function.
900  *
901  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
902  * available, which can be applied to functions to make sure there are no nested
903  * (reentrant) calls to them.
904  *
905  * Note that because there is a single `nonReentrant` guard, functions marked as
906  * `nonReentrant` may not call one another. This can be worked around by making
907  * those functions `private`, and then adding `external` `nonReentrant` entry
908  * points to them.
909  *
910  * TIP: If you would like to learn more about reentrancy and alternative ways
911  * to protect against it, check out our blog post
912  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
913  *
914  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
915  * metering changes introduced in the Istanbul hardfork.
916  */
917 contract ReentrancyGuard {
918   bool private _notEntered;
919 
920   constructor() internal {
921     // Storing an initial non-zero value makes deployment a bit more
922     // expensive, but in exchange the refund on every call to nonReentrant
923     // will be lower in amount. Since refunds are capped to a percetange of
924     // the total transaction's gas, it is best to keep them low in cases
925     // like this one, to increase the likelihood of the full refund coming
926     // into effect.
927     _notEntered = true;
928   }
929 
930   /**
931    * @dev Prevents a contract from calling itself, directly or indirectly.
932    * Calling a `nonReentrant` function from another `nonReentrant`
933    * function is not supported. It is possible to prevent this from happening
934    * by making the `nonReentrant` function external, and make it call a
935    * `private` function that does the actual work.
936    */
937   modifier nonReentrant() {
938     // On the first call to nonReentrant, _notEntered will be true
939     require(_notEntered, "ReentrancyGuard: reentrant call");
940 
941     // Any calls to nonReentrant after this point will fail
942     _notEntered = false;
943 
944     _;
945 
946     // By storing the original value once again, a refund is triggered (see
947     // https://eips.ethereum.org/EIPS/eip-2200)
948     _notEntered = true;
949   }
950 }
951 
952 // SPDX-License-Identifier: MIT
953 contract NftStake is PoolTokenWrapper, Ownable, Pausable, ReentrancyGuard {
954   using SafeMath for uint256;
955   IERC1155 public nfts;
956 
957   struct Card {
958     uint256 points;
959     uint256 releaseTime;
960     uint256 mintFee;
961   }
962 
963   struct Pool {
964     uint256 periodStart;
965     uint256 maxStake;
966     uint256 rewardRate; // 11574074074000, 1 point per day per staked token
967     uint256 feesCollected;
968     uint256 spentPoints;
969     uint256 controllerShare;
970     address artist;
971     mapping(address => uint256) lastUpdateTime;
972     mapping(address => uint256) points;
973     mapping(uint256 => Card) cards;
974   }
975 
976   uint256 public constant MAX_CONTROLLER_SHARE = 1000;
977   uint256 public constant MIN_CARD_POINTS = 1e17;
978   address public controller;
979   address public rescuer;
980   mapping(address => uint256) public pendingWithdrawals;
981   mapping(uint256 => Pool) public pools;
982 
983   event UpdatedArtist(uint256 poolId, address artist);
984   event PoolAdded(uint256 poolId, address artist, uint256 periodStart, uint256 rewardRate, uint256 maxStake);
985   event CardAdded(uint256 poolId, uint256 cardId, uint256 points, uint256 mintFee, uint256 releaseTime);
986   event Staked(address indexed user, uint256 poolId, uint256 amount);
987   event Withdrawn(address indexed user, uint256 poolId, uint256 amount);
988   event Transferred(address indexed user, uint256 fromPoolId, uint256 toPoolId, uint256 amount);
989   event Redeemed(address indexed user, uint256 poolId, uint256 amount);
990   event CardPointsUpdated(uint256 poolId, uint256 cardId, uint256 points);
991 
992   modifier updateReward(address account, uint256 id) {
993     if (account != address(0)) {
994       pools[id].points[account] = earned(account, id);
995       pools[id].lastUpdateTime[account] = block.timestamp;
996     }
997     _;
998   }
999 
1000   modifier poolExists(uint256 id) {
1001     require(pools[id].rewardRate > 0, "pool does not exists");
1002     _;
1003   }
1004 
1005   modifier cardExists(uint256 pool, uint256 card) {
1006     require(pools[pool].cards[card].points > 0, "card does not exists");
1007     _;
1008   }
1009 
1010   constructor(
1011     address _controller,
1012     IERC1155 _nftsAddress,
1013     IERC20 _tokenAddress
1014   ) public PoolTokenWrapper(_tokenAddress) {
1015     require(_controller != address(0), "Invalid controller");
1016     controller = _controller;
1017     nfts = _nftsAddress;
1018   }
1019 
1020   function cardMintFee(uint256 pool, uint256 card) public view returns (uint256) {
1021     return pools[pool].cards[card].mintFee;
1022   }
1023 
1024   function cardReleaseTime(uint256 pool, uint256 card) public view returns (uint256) {
1025     return pools[pool].cards[card].releaseTime;
1026   }
1027 
1028   function cardPoints(uint256 pool, uint256 card) public view returns (uint256) {
1029     return pools[pool].cards[card].points;
1030   }
1031 
1032   function earned(address account, uint256 pool) public view returns (uint256) {
1033     Pool storage p = pools[pool];
1034     uint256 blockTime = block.timestamp;
1035     return
1036       balanceOf(account, pool).mul(blockTime.sub(p.lastUpdateTime[account]).mul(p.rewardRate)).div(1e18).add(
1037         p.points[account]
1038       );
1039   }
1040 
1041   // override PoolTokenWrapper's stake() function
1042   function stake(uint256 pool, uint256 amount)
1043     public
1044     override
1045     poolExists(pool)
1046     updateReward(msg.sender, pool)
1047     whenNotPaused()
1048     nonReentrant
1049   {
1050     Pool memory p = pools[pool];
1051 
1052     require(block.timestamp >= p.periodStart, "pool not open");
1053     require(amount.add(balanceOf(msg.sender, pool)) <= p.maxStake, "stake exceeds max");
1054 
1055     super.stake(pool, amount);
1056     emit Staked(msg.sender, pool, amount);
1057   }
1058 
1059   // override PoolTokenWrapper's withdraw() function
1060   function withdraw(uint256 pool, uint256 amount)
1061     public
1062     override
1063     poolExists(pool)
1064     updateReward(msg.sender, pool)
1065     nonReentrant
1066   {
1067     require(amount > 0, "cannot withdraw 0");
1068 
1069     super.withdraw(pool, amount);
1070     emit Withdrawn(msg.sender, pool, amount);
1071   }
1072 
1073   // override PoolTokenWrapper's transfer() function
1074   function transfer(
1075     uint256 fromPool,
1076     uint256 toPool,
1077     uint256 amount
1078   )
1079     public
1080     override
1081     poolExists(fromPool)
1082     poolExists(toPool)
1083     updateReward(msg.sender, fromPool)
1084     updateReward(msg.sender, toPool)
1085     whenNotPaused()
1086     nonReentrant
1087   {
1088     Pool memory toP = pools[toPool];
1089 
1090     require(block.timestamp >= toP.periodStart, "pool not open");
1091     require(amount.add(balanceOf(msg.sender, toPool)) <= toP.maxStake, "stake exceeds max");
1092 
1093     super.transfer(fromPool, toPool, amount);
1094     emit Transferred(msg.sender, fromPool, toPool, amount);
1095   }
1096 
1097   function transferAll(uint256 fromPool, uint256 toPool) external nonReentrant {
1098     transfer(fromPool, toPool, balanceOf(msg.sender, fromPool));
1099   }
1100 
1101   function exit(uint256 pool) external {
1102     withdraw(pool, balanceOf(msg.sender, pool));
1103   }
1104 
1105   function redeem(uint256 pool, uint256 card)
1106     public
1107     payable
1108     poolExists(pool)
1109     cardExists(pool, card)
1110     updateReward(msg.sender, pool)
1111     nonReentrant
1112   {
1113     Pool storage p = pools[pool];
1114     Card memory c = p.cards[card];
1115     require(block.timestamp >= c.releaseTime, "card not released");
1116     require(p.points[msg.sender] >= c.points, "not enough points");
1117     require(msg.value == c.mintFee, "support our artists, send eth");
1118 
1119     if (c.mintFee > 0) {
1120       uint256 _controllerShare = msg.value.mul(p.controllerShare).div(MAX_CONTROLLER_SHARE);
1121       uint256 _artistRoyalty = msg.value.sub(_controllerShare);
1122       require(_artistRoyalty.add(_controllerShare) == msg.value, "problem with fee");
1123 
1124       p.feesCollected = p.feesCollected.add(c.mintFee);
1125       pendingWithdrawals[controller] = pendingWithdrawals[controller].add(_controllerShare);
1126       pendingWithdrawals[p.artist] = pendingWithdrawals[p.artist].add(_artistRoyalty);
1127     }
1128 
1129     p.points[msg.sender] = p.points[msg.sender].sub(c.points);
1130     p.spentPoints = p.spentPoints.add(c.points);
1131     nfts.mint(msg.sender, card, 1, "");
1132     emit Redeemed(msg.sender, pool, c.points);
1133   }
1134 
1135   function rescuePoints(address account, uint256 pool)
1136     public
1137     poolExists(pool)
1138     updateReward(account, pool)
1139     nonReentrant
1140     returns (uint256)
1141   {
1142     require(msg.sender == rescuer, "!rescuer");
1143     Pool storage p = pools[pool];
1144 
1145     uint256 earnedPoints = p.points[account];
1146     p.spentPoints = p.spentPoints.add(earnedPoints);
1147     p.points[account] = 0;
1148 
1149     // transfer remaining tokens to the account
1150     if (balanceOf(account, pool) > 0) {
1151       _rescuePoints(account, pool);
1152     }
1153 
1154     emit Redeemed(account, pool, earnedPoints);
1155     return earnedPoints;
1156   }
1157 
1158   function setArtist(uint256 pool_, address artist_) public onlyOwner poolExists(pool_) nonReentrant {
1159     require(artist_ != address(0), "Invalid artist");
1160     address oldArtist = pools[pool_].artist;
1161     pendingWithdrawals[artist_] = pendingWithdrawals[artist_].add(pendingWithdrawals[oldArtist]);
1162     pendingWithdrawals[oldArtist] = 0;
1163     pools[pool_].artist = artist_;
1164 
1165     emit UpdatedArtist(pool_, artist_);
1166   }
1167 
1168   function setController(address _controller) public onlyOwner nonReentrant {
1169     require(_controller != address(0), "Invalid controller");
1170     pendingWithdrawals[_controller] = pendingWithdrawals[_controller].add(pendingWithdrawals[controller]);
1171     pendingWithdrawals[controller] = 0;
1172     controller = _controller;
1173   }
1174 
1175   function setRescuer(address _rescuer) public onlyOwner nonReentrant {
1176     rescuer = _rescuer;
1177   }
1178 
1179   function setControllerShare(uint256 pool, uint256 _controllerShare) public onlyOwner poolExists(pool) nonReentrant {
1180     require(_controllerShare <= MAX_CONTROLLER_SHARE, "Incorrect controller share");
1181     pools[pool].controllerShare = _controllerShare;
1182   }
1183 
1184   function addCard(
1185     uint256 pool,
1186     uint256 id,
1187     uint256 points,
1188     uint256 mintFee,
1189     uint256 releaseTime
1190   ) public onlyOwner poolExists(pool) nonReentrant {
1191     require(points >= MIN_CARD_POINTS, "Points too small");
1192     Card storage c = pools[pool].cards[id];
1193     c.points = points;
1194     c.releaseTime = releaseTime;
1195     c.mintFee = mintFee;
1196     emit CardAdded(pool, id, points, mintFee, releaseTime);
1197   }
1198 
1199   function createCard(
1200     uint256 pool,
1201     uint256 supply,
1202     uint256 points,
1203     uint256 mintFee,
1204     uint256 releaseTime
1205   ) public onlyOwner poolExists(pool) nonReentrant returns (uint256) {
1206     require(points >= MIN_CARD_POINTS, "Points too small");
1207     uint256 tokenId = nfts.create(supply, 0, "", "");
1208     require(tokenId > 0, "ERC1155 create did not succeed");
1209 
1210     Card storage c = pools[pool].cards[tokenId];
1211     c.points = points;
1212     c.releaseTime = releaseTime;
1213     c.mintFee = mintFee;
1214     emit CardAdded(pool, tokenId, points, mintFee, releaseTime);
1215     return tokenId;
1216   }
1217 
1218   function createPool(
1219     uint256 id,
1220     uint256 periodStart,
1221     uint256 maxStake,
1222     uint256 rewardRate,
1223     uint256 controllerShare,
1224     address artist
1225   ) public onlyOwner nonReentrant returns (uint256) {
1226     require(rewardRate > 0, "Invalid rewardRate");
1227     require(pools[id].rewardRate == 0, "pool exists");
1228     require(artist != address(0), "Invalid artist");
1229     require(controllerShare <= MAX_CONTROLLER_SHARE, "Incorrect controller share");
1230 
1231     Pool storage p = pools[id];
1232 
1233     p.periodStart = periodStart;
1234     p.maxStake = maxStake;
1235     p.rewardRate = rewardRate;
1236     p.controllerShare = controllerShare;
1237     p.artist = artist;
1238 
1239     emit PoolAdded(id, artist, periodStart, rewardRate, maxStake);
1240   }
1241 
1242   function withdrawFee() public nonReentrant {
1243     uint256 amount = pendingWithdrawals[msg.sender];
1244     require(amount > 0, "nothing to withdraw");
1245     pendingWithdrawals[msg.sender] = 0;
1246     msg.sender.transfer(amount);
1247   }
1248 
1249   // For development and QA
1250   function assignPointsTo(
1251     uint256 pool_,
1252     address tester_,
1253     uint256 points_
1254   ) public onlyOwner poolExists(pool_) nonReentrant returns (uint256) {
1255     Pool storage p = pools[pool_];
1256     p.points[tester_] = points_;
1257 
1258     // rescue continues
1259     return p.points[tester_];
1260   }
1261 
1262   /**
1263    * @dev Updates card points
1264    * @param poolId_ uint256 ID of the pool
1265    * @param cardId_ uint256 ID of the card to update
1266    * @param points_ uint256 new "points" value
1267    */
1268   function updateCardPoints(
1269     uint256 poolId_,
1270     uint256 cardId_,
1271     uint256 points_
1272   ) public onlyOwner poolExists(poolId_) cardExists(poolId_, cardId_) nonReentrant {
1273     require(points_ >= MIN_CARD_POINTS, "Points too small");
1274     Card storage c = pools[poolId_].cards[cardId_];
1275     c.points = points_;
1276     emit CardPointsUpdated(poolId_, cardId_, points_);
1277   }
1278 }
1279 
1280 // SPDX-License-Identifier: MIT
1281 contract EddaNftStake is NftStake {
1282   constructor(
1283     address _controller,
1284     IERC1155 _nftsAddress,
1285     IERC20 _tokenAddress
1286   ) public NftStake(_controller, _nftsAddress, _tokenAddress) {}
1287 }