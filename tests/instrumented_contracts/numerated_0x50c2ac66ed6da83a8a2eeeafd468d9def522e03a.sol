1 pragma solidity ^0.6.0;
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
14     function _msgSender() internal virtual view returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal virtual view returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 pragma solidity ^0.6.0;
25 
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
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(
88             newOwner != address(0),
89             "Ownable: new owner is the zero address"
90         );
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 pragma solidity ^0.6.0;
97 
98 /**
99  * @dev Interface of the ERC20 standard as defined in the EIP.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount)
120         external
121         returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender)
131         external
132         view
133         returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(
179         address indexed owner,
180         address indexed spender,
181         uint256 value
182     );
183 }
184 
185 pragma solidity ^0.6.0;
186 
187 /**
188  * @dev Wrappers over Solidity's arithmetic operations with added overflow
189  * checks.
190  *
191  * Arithmetic operations in Solidity wrap on overflow. This can easily result
192  * in bugs, because programmers usually assume that an overflow raises an
193  * error, which is the standard behavior in high level programming languages.
194  * `SafeMath` restores this intuition by reverting the transaction when an
195  * operation overflows.
196  *
197  * Using this library instead of the unchecked operations eliminates an entire
198  * class of bugs, so it's recommended to use it always.
199  */
200 library SafeMath {
201     /**
202      * @dev Returns the addition of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `+` operator.
206      *
207      * Requirements:
208      *
209      * - Addition cannot overflow.
210      */
211     function add(uint256 a, uint256 b) internal pure returns (uint256) {
212         uint256 c = a + b;
213         require(c >= a, "SafeMath: addition overflow");
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      *
240      * - Subtraction cannot overflow.
241      */
242     function sub(
243         uint256 a,
244         uint256 b,
245         string memory errorMessage
246     ) internal pure returns (uint256) {
247         require(b <= a, errorMessage);
248         uint256 c = a - b;
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the multiplication of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `*` operator.
258      *
259      * Requirements:
260      *
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return div(a, b, "SafeMath: division by zero");
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         require(b > 0, errorMessage);
311         uint256 c = a / b;
312         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
313 
314         return c;
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      *
327      * - The divisor cannot be zero.
328      */
329     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
330         return mod(a, b, "SafeMath: modulo by zero");
331     }
332 
333     /**
334      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
335      * Reverts with custom message when dividing by zero.
336      *
337      * Counterpart to Solidity's `%` operator. This function uses a `revert`
338      * opcode (which leaves remaining gas untouched) while Solidity uses an
339      * invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      *
343      * - The divisor cannot be zero.
344      */
345     function mod(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         require(b != 0, errorMessage);
351         return a % b;
352     }
353 }
354 
355 pragma solidity ^0.6.2;
356 
357 /**
358  * @dev Collection of functions related to the address type
359  */
360 library Address {
361     /**
362      * @dev Returns true if `account` is a contract.
363      *
364      * [IMPORTANT]
365      * ====
366      * It is unsafe to assume that an address for which this function returns
367      * false is an externally-owned account (EOA) and not a contract.
368      *
369      * Among others, `isContract` will return false for the following
370      * types of addresses:
371      *
372      *  - an externally-owned account
373      *  - a contract in construction
374      *  - an address where a contract will be created
375      *  - an address where a contract lived, but was destroyed
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // This method relies in extcodesize, which returns 0 for contracts in
380         // construction, since the code is only stored at the end of the
381         // constructor execution.
382 
383         uint256 size;
384         // solhint-disable-next-line no-inline-assembly
385         assembly {
386             size := extcodesize(account)
387         }
388         return size > 0;
389     }
390 
391     /**
392      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
393      * `recipient`, forwarding all available gas and reverting on errors.
394      *
395      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
396      * of certain opcodes, possibly making contracts go over the 2300 gas limit
397      * imposed by `transfer`, making them unable to receive funds via
398      * `transfer`. {sendValue} removes this limitation.
399      *
400      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
401      *
402      * IMPORTANT: because control is transferred to `recipient`, care must be
403      * taken to not create reentrancy vulnerabilities. Consider using
404      * {ReentrancyGuard} or the
405      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
406      */
407     function sendValue(address payable recipient, uint256 amount) internal {
408         require(
409             address(this).balance >= amount,
410             "Address: insufficient balance"
411         );
412 
413         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
414         (bool success, ) = recipient.call{value: amount}("");
415         require(
416             success,
417             "Address: unable to send value, recipient may have reverted"
418         );
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain`call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data)
440         internal
441         returns (bytes memory)
442     {
443         return functionCall(target, data, "Address: low-level call failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
448      * `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(
453         address target,
454         bytes memory data,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         return _functionCallWithValue(target, data, 0, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but also transferring `value` wei to `target`.
463      *
464      * Requirements:
465      *
466      * - the calling contract must have an ETH balance of at least `value`.
467      * - the called Solidity function must be `payable`.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value
475     ) internal returns (bytes memory) {
476         return
477             functionCallWithValue(
478                 target,
479                 data,
480                 value,
481                 "Address: low-level call with value failed"
482             );
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
487      * with `errorMessage` as a fallback revert reason when `target` reverts.
488      *
489      * _Available since v3.1._
490      */
491     function functionCallWithValue(
492         address target,
493         bytes memory data,
494         uint256 value,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(
498             address(this).balance >= value,
499             "Address: insufficient balance for call"
500         );
501         return _functionCallWithValue(target, data, value, errorMessage);
502     }
503 
504     function _functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 weiValue,
508         string memory errorMessage
509     ) private returns (bytes memory) {
510         require(isContract(target), "Address: call to non-contract");
511 
512         // solhint-disable-next-line avoid-low-level-calls
513         (bool success, bytes memory returndata) = target.call{value: weiValue}(
514             data
515         );
516         if (success) {
517             return returndata;
518         } else {
519             // Look for revert reason and bubble it up if present
520             if (returndata.length > 0) {
521                 // The easiest way to bubble the revert reason is using memory via assembly
522 
523                 // solhint-disable-next-line no-inline-assembly
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 pragma solidity ^0.6.0;
536 
537 /**
538  * @title SafeERC20
539  * @dev Wrappers around ERC20 operations that throw on failure (when the token
540  * contract returns false). Tokens that return no value (and instead revert or
541  * throw on failure) are also supported, non-reverting calls are assumed to be
542  * successful.
543  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
544  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
545  */
546 library SafeERC20 {
547     using SafeMath for uint256;
548     using Address for address;
549 
550     function safeTransfer(
551         IERC20 token,
552         address to,
553         uint256 value
554     ) internal {
555         _callOptionalReturn(
556             token,
557             abi.encodeWithSelector(token.transfer.selector, to, value)
558         );
559     }
560 
561     function safeTransferFrom(
562         IERC20 token,
563         address from,
564         address to,
565         uint256 value
566     ) internal {
567         _callOptionalReturn(
568             token,
569             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
570         );
571     }
572 
573     /**
574      * @dev Deprecated. This function has issues similar to the ones found in
575      * {IERC20-approve}, and its usage is discouraged.
576      *
577      * Whenever possible, use {safeIncreaseAllowance} and
578      * {safeDecreaseAllowance} instead.
579      */
580     function safeApprove(
581         IERC20 token,
582         address spender,
583         uint256 value
584     ) internal {
585         // safeApprove should only be called when setting an initial allowance,
586         // or when resetting it to zero. To increase and decrease it, use
587         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
588         // solhint-disable-next-line max-line-length
589         require(
590             (value == 0) || (token.allowance(address(this), spender) == 0),
591             "SafeERC20: approve from non-zero to non-zero allowance"
592         );
593         _callOptionalReturn(
594             token,
595             abi.encodeWithSelector(token.approve.selector, spender, value)
596         );
597     }
598 
599     function safeIncreaseAllowance(
600         IERC20 token,
601         address spender,
602         uint256 value
603     ) internal {
604         uint256 newAllowance = token.allowance(address(this), spender).add(
605             value
606         );
607         _callOptionalReturn(
608             token,
609             abi.encodeWithSelector(
610                 token.approve.selector,
611                 spender,
612                 newAllowance
613             )
614         );
615     }
616 
617     function safeDecreaseAllowance(
618         IERC20 token,
619         address spender,
620         uint256 value
621     ) internal {
622         uint256 newAllowance = token.allowance(address(this), spender).sub(
623             value,
624             "SafeERC20: decreased allowance below zero"
625         );
626         _callOptionalReturn(
627             token,
628             abi.encodeWithSelector(
629                 token.approve.selector,
630                 spender,
631                 newAllowance
632             )
633         );
634     }
635 
636     /**
637      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
638      * on the return value: the return value is optional (but if data is returned, it must not be false).
639      * @param token The token targeted by the call.
640      * @param data The call data (encoded using abi.encode or one of its variants).
641      */
642     function _callOptionalReturn(IERC20 token, bytes memory data) private {
643         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
644         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
645         // the target address contains contract code and also asserts for success in the low-level call.
646 
647         bytes memory returndata = address(token).functionCall(
648             data,
649             "SafeERC20: low-level call failed"
650         );
651         if (returndata.length > 0) {
652             // Return data is optional
653             // solhint-disable-next-line max-line-length
654             require(
655                 abi.decode(returndata, (bool)),
656                 "SafeERC20: ERC20 operation did not succeed"
657             );
658         }
659     }
660 }
661 
662 pragma solidity >=0.6.0;
663 
664 /**
665  * @title Roles
666  * @dev Library for managing addresses assigned to a Role.
667  */
668 library Roles {
669     struct Role {
670         mapping(address => bool) bearer;
671     }
672 
673     /**
674      * @dev Give an account access to this role.
675      */
676     function add(Role storage role, address account) internal {
677         require(!has(role, account), "Roles: account already has role");
678         role.bearer[account] = true;
679     }
680 
681     /**
682      * @dev Remove an account's access to this role.
683      */
684     function remove(Role storage role, address account) internal {
685         require(has(role, account), "Roles: account does not have role");
686         role.bearer[account] = false;
687     }
688 
689     /**
690      * @dev Check if an account has this role.
691      * @return bool
692      */
693     function has(Role storage role, address account)
694         internal
695         view
696         returns (bool)
697     {
698         require(account != address(0), "Roles: account is the zero address");
699         return role.bearer[account];
700     }
701 }
702 
703 contract MinterRole is Context {
704     using Roles for Roles.Role;
705 
706     event MinterAdded(address indexed account);
707     event MinterRemoved(address indexed account);
708 
709     Roles.Role private _minters;
710 
711     constructor() internal {
712         _addMinter(_msgSender());
713     }
714 
715     modifier onlyMinter() {
716         require(
717             isMinter(_msgSender()),
718             "MinterRole: caller does not have the Minter role"
719         );
720         _;
721     }
722 
723     function isMinter(address account) public view returns (bool) {
724         return _minters.has(account);
725     }
726 
727     function addMinter(address account) public onlyMinter {
728         _addMinter(account);
729     }
730 
731     function renounceMinter() public {
732         _removeMinter(_msgSender());
733     }
734 
735     function _addMinter(address account) internal {
736         _minters.add(account);
737         emit MinterAdded(account);
738     }
739 
740     function _removeMinter(address account) internal {
741         _minters.remove(account);
742         emit MinterRemoved(account);
743     }
744 }
745 
746 contract CanTransferRole is Context {
747     using Roles for Roles.Role;
748 
749     event CanTransferAdded(address indexed account);
750     event CanTransferRemoved(address indexed account);
751 
752     Roles.Role private _canTransfer;
753 
754     constructor() internal {
755         _addCanTransfer(_msgSender());
756     }
757 
758     modifier onlyCanTransfer() {
759         require(
760             canTransfer(_msgSender()),
761             "CanTransferRole: caller does not have the CanTransfer role"
762         );
763         _;
764     }
765 
766     function canTransfer(address account) public view returns (bool) {
767         return _canTransfer.has(account);
768     }
769 
770     function addCanTransfer(address account) public onlyCanTransfer {
771         _addCanTransfer(account);
772     }
773 
774     function renounceCanTransfer() public {
775         _removeCanTransfer(_msgSender());
776     }
777 
778     function _addCanTransfer(address account) internal {
779         _canTransfer.add(account);
780         emit CanTransferAdded(account);
781     }
782 
783     function _removeCanTransfer(address account) internal {
784         _canTransfer.remove(account);
785         emit CanTransferRemoved(account);
786     }
787 }
788 
789 contract ToshiCoinNonTradable is Ownable, MinterRole, CanTransferRole {
790     using SafeMath for uint256;
791 
792     event Transfer(address indexed from, address indexed to, uint256 value);
793 
794     mapping(address => uint256) private _balances;
795 
796     string public name = "ToshiCoin - Non Tradable";
797     string public symbol = "ToshiCoin";
798     uint8 public decimals = 18;
799 
800     uint256 public totalSupply;
801     uint256 public totalClaimed;
802     uint256 public totalMinted;
803 
804     uint256 public remainingToshiCoinForSale = 4000 * (1e18);
805     uint256 public priceInTOSHI = 3;
806 
807     IERC20 public toshi;
808     address public toshiTreasury;
809 
810     constructor(IERC20 _toshi, address _toshiTreasury) public {
811         toshi = _toshi;
812         toshiTreasury = _toshiTreasury;
813     }
814 
815     function addClaimed(uint256 amount) internal {
816         totalClaimed = totalClaimed.add(amount);
817     }
818 
819     function addMinted(uint256 amount) internal {
820         totalMinted = totalMinted.add(amount);
821     }
822 
823     function setRemainingToshiCoinForSale(uint256 _remainingToshiCoinForSale)
824         external
825         onlyMinter
826     {
827         remainingToshiCoinForSale = _remainingToshiCoinForSale;
828     }
829 
830     function setPriceInToshi(uint256 _priceInTOSHI) external onlyMinter {
831         priceInTOSHI = _priceInTOSHI;
832     }
833 
834     function setToshiTreasury(address _toshiTreasury) external onlyMinter {
835         toshiTreasury = _toshiTreasury;
836     }
837 
838     /**
839      * @dev Anyone can purchase ToshiCoin for TOSHI until it is sold out.
840      */
841     function purchase(uint256 amount) external {
842         uint256 price = priceInTOSHI.mul(amount);
843         uint256 balance = toshi.balanceOf(msg.sender);
844 
845         require(balance >= price, "ToshiCoin: Not enough TOSHI in wallet.");
846         require(
847             remainingToshiCoinForSale >= amount,
848             "ToshiCoin: Not enough ToshiCoin for sale."
849         );
850 
851         safeToshiTransferFrom(msg.sender, toshiTreasury, price);
852 
853         remainingToshiCoinForSale = remainingToshiCoinForSale.sub(amount);
854 
855         _mint(msg.sender, amount);
856         addMinted(amount);
857     }
858 
859     /**
860      * @dev Claiming is white-listed to specific minter addresses for now to limit transfers.
861      */
862     function claim(address to, uint256 amount) public onlyCanTransfer {
863         transfer(to, amount);
864         addClaimed(amount);
865     }
866 
867     /**
868      * @dev Transferring is white-listed to specific minter addresses for now.
869      */
870     function transfer(address to, uint256 amount)
871         public
872         onlyCanTransfer
873         returns (bool)
874     {
875         require(
876             amount <= _balances[msg.sender],
877             "ToshiCoin: Cannot transfer more than balance"
878         );
879 
880         _balances[msg.sender] = _balances[msg.sender].sub(amount);
881         _balances[to] = _balances[to].add(amount);
882 
883         emit Transfer(msg.sender, to, amount);
884 
885         return true;
886     }
887 
888     /**
889      * @dev Transferring is white-listed to specific minter addresses for now.
890      */
891     function transferFrom(
892         address from,
893         address to,
894         uint256 amount
895     ) public onlyCanTransfer returns (bool) {
896         require(
897             amount <= _balances[from],
898             "ToshiCoin: Cannot transfer more than balance"
899         );
900 
901         _balances[from] = _balances[from].sub(amount);
902         _balances[to] = _balances[to].add(amount);
903 
904         emit Transfer(from, to, amount);
905 
906         return true;
907     }
908 
909     /**
910      * @dev Gets the balance of the specified address.
911      */
912     function balanceOf(address account) public view returns (uint256) {
913         return _balances[account];
914     }
915 
916     /**
917      * @dev Minting is white-listed to specific minter addresses for now.
918      */
919     function mint(address to, uint256 amount) public onlyMinter {
920         _mint(to, amount);
921         addMinted(amount);
922     }
923 
924     /**
925      * @dev Burning is white-listed to specific minter addresses for now.
926      */
927     function burn(address from, uint256 value) public onlyCanTransfer {
928         require(
929             _balances[from] >= value,
930             "ToshiCoin: Cannot burn more than the address balance"
931         );
932 
933         _burn(from, value);
934     }
935 
936     /**
937      * @dev Internal function that creates an amount of the token and assigns it to an account.
938      * This encapsulates the modification of balances such that the proper events are emitted.
939      * @param to The account that will receive the created tokens.
940      * @param amount The amount that will be created.
941      */
942     function _mint(address to, uint256 amount) internal {
943         require(to != address(0), "ToshiCoin: mint to the zero address");
944 
945         totalSupply = totalSupply.add(amount);
946         _balances[to] = _balances[to].add(amount);
947 
948         emit Transfer(address(0), to, amount);
949     }
950 
951     /**
952      * @dev Internal function that destroys an amount of the token of a given address.
953      * @param from The account whose tokens will be destroyed.
954      * @param amount The amount that will be destroyed.
955      */
956     function _burn(address from, uint256 amount) internal {
957         require(from != address(0), "ToshiCoin: burn from the zero address");
958 
959         totalSupply = totalSupply.sub(amount);
960         _balances[from] = _balances[from].sub(amount);
961 
962         emit Transfer(from, address(0), amount);
963     }
964 
965     /**
966      * @dev Safe token transfer from to prevent over-transfers.
967      */
968     function safeToshiTransferFrom(
969         address from,
970         address to,
971         uint256 amount
972     ) internal {
973         uint256 tokenBalance = toshi.balanceOf(address(from));
974         uint256 transferAmount = amount > tokenBalance ? tokenBalance : amount;
975 
976         toshi.transferFrom(from, to, transferAmount);
977     }
978 }
979 
980 pragma solidity >=0.6.0;
981 
982 contract ToshiCoinFarm is Ownable {
983     using SafeMath for uint256;
984 
985     struct UserInfo {
986         uint256 amountInPool;
987         uint256 coinsReceivedToDate;
988         /*
989          *  At any point in time, the amount of ToshiCoin earned by a user waiting to be claimed is:
990          *
991          *    Pending claim = (user.amountInPool * pool.coinsEarnedPerToken) - user.coinsReceivedToDate
992          *
993          *  Whenever a user deposits or withdraws tokens to a pool, the following occurs:
994          *   1. The pool's `coinsEarnedPerToken` is rebalanced to account for the new shares in the pool.
995          *   2. The `lastRewardBlock` is updated to the latest block.
996          *   3. The user receives the pending claim sent to their address.
997          *   4. The user's `amountInPool` and `coinsReceivedToDate` get updated for this pool.
998          */
999     }
1000 
1001     struct PoolInfo {
1002         IERC20 token;
1003         uint256 lastUpdateTime;
1004         uint256 coinsPerDay;
1005         uint256 coinsEarnedPerToken;
1006     }
1007 
1008     PoolInfo[] public poolInfo;
1009 
1010     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1011     mapping(address => uint256) public tokenPoolIds;
1012 
1013     ToshiCoinNonTradable public ToshiCoin;
1014 
1015     event Deposit(address indexed user, uint256 indexed poolId, uint256 amount);
1016     event Withdraw(
1017         address indexed user,
1018         uint256 indexed poolId,
1019         uint256 amount
1020     );
1021     event EmergencyWithdraw(
1022         address indexed user,
1023         uint256 indexed poolId,
1024         uint256 amount
1025     );
1026 
1027     constructor(ToshiCoinNonTradable toshiCoinAddress) public {
1028         ToshiCoin = toshiCoinAddress;
1029     }
1030 
1031     function poolLength() external view returns (uint256) {
1032         return poolInfo.length;
1033     }
1034 
1035     function pendingCoins(uint256 poolId, address user)
1036         public
1037         view
1038         returns (uint256)
1039     {
1040         PoolInfo storage pool = poolInfo[poolId];
1041         UserInfo storage user = userInfo[poolId][user];
1042 
1043         uint256 tokenSupply = pool.token.balanceOf(address(this));
1044         uint256 coinsEarnedPerToken = pool.coinsEarnedPerToken;
1045 
1046         if (block.timestamp > pool.lastUpdateTime && tokenSupply > 0) {
1047             uint256 pendingCoins = block
1048                 .timestamp
1049                 .sub(pool.lastUpdateTime)
1050                 .mul(pool.coinsPerDay)
1051                 .div(86400);
1052 
1053             coinsEarnedPerToken = coinsEarnedPerToken.add(
1054                 pendingCoins.mul(1e18).div(tokenSupply)
1055             );
1056         }
1057 
1058         return
1059             user.amountInPool.mul(coinsEarnedPerToken).div(1e18).sub(
1060                 user.coinsReceivedToDate
1061             );
1062     }
1063 
1064     function totalPendingCoins(address user) public view returns (uint256) {
1065         uint256 total = 0;
1066         uint256 length = poolInfo.length;
1067 
1068         for (uint256 poolId = 0; poolId < length; ++poolId) {
1069             total = total.add(pendingCoins(poolId, user));
1070         }
1071 
1072         return total;
1073     }
1074 
1075     /**
1076      * @dev Add new pool to the farm. Cannot add the same token more than once.
1077      */
1078     function addPool(IERC20 token, uint256 _coinsPerDay) public onlyOwner {
1079         require(
1080             tokenPoolIds[address(token)] == 0,
1081             "ToshiCoinFarm: Added duplicate token pool"
1082         );
1083         require(
1084             address(token) != address(ToshiCoin),
1085             "ToshiCoinFarm: Cannot add ToshiCoin pool"
1086         );
1087 
1088         poolInfo.push(
1089             PoolInfo({
1090                 token: token,
1091                 coinsPerDay: _coinsPerDay,
1092                 lastUpdateTime: block.timestamp,
1093                 coinsEarnedPerToken: 0
1094             })
1095         );
1096 
1097         tokenPoolIds[address(token)] = poolInfo.length;
1098     }
1099 
1100     function setCoinsPerDay(uint256 poolId, uint256 amount) public onlyOwner {
1101         require(amount >= 0, "ToshiCoinFarm: Coins per day cannot be negative");
1102 
1103         updatePool(poolId);
1104 
1105         poolInfo[poolId].coinsPerDay = amount;
1106     }
1107 
1108     /**
1109      * @dev Claim all pending rewards in all pools.
1110      */
1111     function claimAll(uint256[] memory poolIds) public {
1112         uint256 length = poolInfo.length;
1113 
1114         for (uint256 poolId = 0; poolId < length; poolId++) {
1115             withdraw(poolIds[poolId], 0);
1116         }
1117     }
1118 
1119     /**
1120      * @dev Update pending rewards in all pools.
1121      */
1122     function updateAllPools() public {
1123         uint256 length = poolInfo.length;
1124 
1125         for (uint256 poolId = 0; poolId < length; poolId++) {
1126             updatePool(poolId);
1127         }
1128     }
1129 
1130     /**
1131      * @dev Update pending rewards for a pool.
1132      */
1133     function updatePool(uint256 poolId) public {
1134         PoolInfo storage pool = poolInfo[poolId];
1135 
1136         if (block.timestamp <= pool.lastUpdateTime) {
1137             return;
1138         }
1139 
1140         uint256 tokenSupply = pool.token.balanceOf(address(this));
1141 
1142         if (pool.coinsPerDay == 0 || tokenSupply == 0) {
1143             pool.lastUpdateTime = block.timestamp;
1144             return;
1145         }
1146 
1147         uint256 pendingCoins = block
1148             .timestamp
1149             .sub(pool.lastUpdateTime)
1150             .mul(pool.coinsPerDay)
1151             .div(86400);
1152 
1153         ToshiCoin.mint(address(this), pendingCoins);
1154 
1155         pool.lastUpdateTime = block.timestamp;
1156         pool.coinsEarnedPerToken = pool.coinsEarnedPerToken.add(
1157             pendingCoins.mul(1e18).div(tokenSupply)
1158         );
1159     }
1160 
1161     /**
1162      * @dev Deposit tokens into a pool and claim pending reward.
1163      */
1164     function deposit(uint256 poolId, uint256 amount) public {
1165         require(
1166             amount > 0,
1167             "ToshiCoinFarm: Cannot deposit non-positive amount into pool"
1168         );
1169 
1170         PoolInfo storage pool = poolInfo[poolId];
1171         UserInfo storage user = userInfo[poolId][msg.sender];
1172 
1173         updatePool(poolId);
1174 
1175         uint256 pending = user
1176             .amountInPool
1177             .mul(pool.coinsEarnedPerToken)
1178             .div(1e18)
1179             .sub(user.coinsReceivedToDate);
1180 
1181         if (pending > 0) {
1182             safeToshiCoinClaim(msg.sender, pending);
1183         }
1184 
1185         user.amountInPool = user.amountInPool.add(amount);
1186         user.coinsReceivedToDate = user
1187             .amountInPool
1188             .mul(pool.coinsEarnedPerToken)
1189             .div(1e18);
1190 
1191         safePoolTransferFrom(msg.sender, address(this), amount, pool);
1192 
1193         emit Deposit(msg.sender, poolId, amount);
1194     }
1195 
1196     /**
1197      * @dev Withdraw tokens from a pool and claim pending reward.
1198      */
1199     function withdraw(uint256 poolId, uint256 amount) public {
1200         PoolInfo storage pool = poolInfo[poolId];
1201         UserInfo storage user = userInfo[poolId][msg.sender];
1202 
1203         require(
1204             user.amountInPool >= amount,
1205             "ToshiCoinFarm: User does not have enough funds to withdraw from this pool"
1206         );
1207 
1208         updatePool(poolId);
1209 
1210         uint256 pending = user
1211             .amountInPool
1212             .mul(pool.coinsEarnedPerToken)
1213             .div(1e18)
1214             .sub(user.coinsReceivedToDate);
1215 
1216         if (pending > 0) {
1217             safeToshiCoinClaim(msg.sender, pending);
1218         }
1219 
1220         user.amountInPool = user.amountInPool.sub(amount);
1221         user.coinsReceivedToDate = user
1222             .amountInPool
1223             .mul(pool.coinsEarnedPerToken)
1224             .div(1e18);
1225 
1226         if (amount > 0) {
1227             safePoolTransfer(msg.sender, amount, pool);
1228         }
1229 
1230         emit Withdraw(msg.sender, poolId, amount);
1231     }
1232 
1233     /**
1234      * @dev Emergency withdraw withdraws funds without claiming rewards.
1235      *      This should only be used in emergencies.
1236      */
1237     function emergencyWithdraw(uint256 poolId) public {
1238         PoolInfo storage pool = poolInfo[poolId];
1239         UserInfo storage user = userInfo[poolId][msg.sender];
1240 
1241         require(
1242             user.amountInPool > 0,
1243             "ToshiCoinFarm: User has no funds to withdraw from this pool"
1244         );
1245 
1246         uint256 amount = user.amountInPool;
1247 
1248         user.amountInPool = 0;
1249         user.coinsReceivedToDate = 0;
1250 
1251         safePoolTransfer(msg.sender, amount, pool);
1252 
1253         emit EmergencyWithdraw(msg.sender, poolId, amount);
1254     }
1255 
1256     /**
1257      * @dev Safe ToshiCoin transfer to prevent over-transfers.
1258      */
1259     function safeToshiCoinClaim(address to, uint256 amount) internal {
1260         uint256 coinsBalance = ToshiCoin.balanceOf(address(this));
1261         uint256 claimAmount = amount > coinsBalance ? coinsBalance : amount;
1262 
1263         ToshiCoin.claim(to, claimAmount);
1264     }
1265 
1266     /**
1267      * @dev Safe pool token transfer to prevent over-transfers.
1268      */
1269     function safePoolTransfer(
1270         address to,
1271         uint256 amount,
1272         PoolInfo storage pool
1273     ) internal {
1274         uint256 tokenBalance = pool.token.balanceOf(address(this));
1275         uint256 transferAmount = amount > tokenBalance ? tokenBalance : amount;
1276 
1277         pool.token.transfer(to, transferAmount);
1278     }
1279 
1280     /**
1281      * @dev Safe pool token transfer from to prevent over-transfers.
1282      */
1283     function safePoolTransferFrom(
1284         address from,
1285         address to,
1286         uint256 amount,
1287         PoolInfo storage pool
1288     ) internal {
1289         uint256 tokenBalance = pool.token.balanceOf(from);
1290         uint256 transferAmount = amount > tokenBalance ? tokenBalance : amount;
1291 
1292         pool.token.transferFrom(from, to, transferAmount);
1293     }
1294 }