1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor() internal {
26         address msgSender = _msgSender();
27         _owner = msgSender;
28         emit OwnershipTransferred(address(0), msgSender);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 library SafeMath {
70     /**
71      * @dev Returns the addition of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         uint256 c = a + b;
77         if (c < a) return (false, 0);
78         return (true, c);
79     }
80 
81     /**
82      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
83      *
84      * _Available since v3.4._
85      */
86     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         if (b > a) return (false, 0);
88         return (true, a - b);
89     }
90 
91     /**
92      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) return (true, 0);
101         uint256 c = a * b;
102         if (c / a != b) return (false, 0);
103         return (true, c);
104     }
105 
106     /**
107      * @dev Returns the division of two unsigned integers, with a division by zero flag.
108      *
109      * _Available since v3.4._
110      */
111     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         if (b == 0) return (false, 0);
113         return (true, a / b);
114     }
115 
116     /**
117      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
118      *
119      * _Available since v3.4._
120      */
121     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         if (b == 0) return (false, 0);
123         return (true, a % b);
124     }
125 
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b <= a, "SafeMath: subtraction overflow");
154         return a - b;
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `*` operator.
162      *
163      * Requirements:
164      *
165      * - Multiplication cannot overflow.
166      */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         if (a == 0) return 0;
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b > 0, "SafeMath: division by zero");
188         return a / b;
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * reverting when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
204         require(b > 0, "SafeMath: modulo by zero");
205         return a % b;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
210      * overflow (when the result is negative).
211      *
212      * CAUTION: This function is deprecated because it requires allocating memory for the error
213      * message unnecessarily. For custom revert reasons use {trySub}.
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      *
219      * - Subtraction cannot overflow.
220      */
221     function sub(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         require(b <= a, errorMessage);
227         return a - b;
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
232      * division by zero. The result is rounded towards zero.
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {tryDiv}.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function div(
246         uint256 a,
247         uint256 b,
248         string memory errorMessage
249     ) internal pure returns (uint256) {
250         require(b > 0, errorMessage);
251         return a / b;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * reverting with custom message when dividing by zero.
257      *
258      * CAUTION: This function is deprecated because it requires allocating memory for the error
259      * message unnecessarily. For custom revert reasons use {tryMod}.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(
270         uint256 a,
271         uint256 b,
272         string memory errorMessage
273     ) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 
280 abstract contract ReentrancyGuard {
281     // Booleans are more expensive than uint256 or any type that takes up a full
282     // word because each write operation emits an extra SLOAD to first read the
283     // slot's contents, replace the bits taken up by the boolean, and then write
284     // back. This is the compiler's defense against contract upgrades and
285     // pointer aliasing, and it cannot be disabled.
286 
287     // The values being non-zero value makes deployment a bit more expensive,
288     // but in exchange the refund on every call to nonReentrant will be lower in
289     // amount. Since refunds are capped to a percentage of the total
290     // transaction's gas, it is best to keep them low in cases like this one, to
291     // increase the likelihood of the full refund coming into effect.
292     uint256 private constant _NOT_ENTERED = 1;
293     uint256 private constant _ENTERED = 2;
294 
295     uint256 private _status;
296 
297     constructor() internal {
298         _status = _NOT_ENTERED;
299     }
300 
301     /**
302      * @dev Prevents a contract from calling itself, directly or indirectly.
303      * Calling a `nonReentrant` function from another `nonReentrant`
304      * function is not supported. It is possible to prevent this from happening
305      * by making the `nonReentrant` function external, and make it call a
306      * `private` function that does the actual work.
307      */
308     modifier nonReentrant() {
309         // On the first call to nonReentrant, _notEntered will be true
310         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
311 
312         // Any calls to nonReentrant after this point will fail
313         _status = _ENTERED;
314 
315         _;
316 
317         // By storing the original value once again, a refund is triggered (see
318         // https://eips.ethereum.org/EIPS/eip-2200)
319         _status = _NOT_ENTERED;
320     }
321 }
322 
323 interface IBEP20 {
324     /**
325      * @dev Returns the amount of tokens in existence.
326      */
327     function totalSupply() external view returns (uint256);
328 
329     /**
330      * @dev Returns the token decimals.
331      */
332     function decimals() external view returns (uint8);
333 
334     /**
335      * @dev Returns the token symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the token name.
341      */
342     function name() external view returns (string memory);
343 
344     /**
345      * @dev Returns the bep token owner.
346      */
347     function getOwner() external view returns (address);
348 
349     /**
350      * @dev Returns the amount of tokens owned by `account`.
351      */
352     function balanceOf(address account) external view returns (uint256);
353 
354     /**
355      * @dev Moves `amount` tokens from the caller's account to `recipient`.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transfer(address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Returns the remaining number of tokens that `spender` will be
365      * allowed to spend on behalf of `owner` through {transferFrom}. This is
366      * zero by default.
367      *
368      * This value changes when {approve} or {transferFrom} are called.
369      */
370     function allowance(address _owner, address spender) external view returns (uint256);
371 
372     /**
373      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * IMPORTANT: Beware that changing an allowance with this method brings the risk
378      * that someone may use both the old and the new allowance by unfortunate
379      * transaction ordering. One possible solution to mitigate this race
380      * condition is to first reduce the spender's allowance to 0 and set the
381      * desired value afterwards:
382      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address spender, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Moves `amount` tokens from `sender` to `recipient` using the
390      * allowance mechanism. `amount` is then deducted from the caller's
391      * allowance.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transferFrom(
398         address sender,
399         address recipient,
400         uint256 amount
401     ) external returns (bool);
402 
403     /**
404      * @dev Emitted when `value` tokens are moved from one account (`from`) to
405      * another (`to`).
406      *
407      * Note that `value` may be zero.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 value);
410 
411     /**
412      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
413      * a call to {approve}. `value` is the new allowance.
414      */
415     event Approval(address indexed owner, address indexed spender, uint256 value);
416 }
417 
418 
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies on extcodesize, which returns 0 for contracts in
439         // construction, since the code is only stored at the end of the
440         // constructor execution.
441 
442         uint256 size;
443         // solhint-disable-next-line no-inline-assembly
444         assembly {
445             size := extcodesize(account)
446         }
447         return size > 0;
448     }
449 
450     /**
451      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
452      * `recipient`, forwarding all available gas and reverting on errors.
453      *
454      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
455      * of certain opcodes, possibly making contracts go over the 2300 gas limit
456      * imposed by `transfer`, making them unable to receive funds via
457      * `transfer`. {sendValue} removes this limitation.
458      *
459      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
460      *
461      * IMPORTANT: because control is transferred to `recipient`, care must be
462      * taken to not create reentrancy vulnerabilities. Consider using
463      * {ReentrancyGuard} or the
464      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
465      */
466     function sendValue(address payable recipient, uint256 amount) internal {
467         require(address(this).balance >= amount, "Address: insufficient balance");
468 
469         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
470         (bool success, ) = recipient.call{value: amount}("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 
474     /**
475      * @dev Performs a Solidity function call using a low level `call`. A
476      * plain`call` is an unsafe replacement for a function call: use this
477      * function instead.
478      *
479      * If `target` reverts with a revert reason, it is bubbled up by this
480      * function (like regular Solidity function calls).
481      *
482      * Returns the raw returned data. To convert to the expected return value,
483      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
484      *
485      * Requirements:
486      *
487      * - `target` must be a contract.
488      * - calling `target` with `data` must not revert.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionCall(target, data, "Address: low-level call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
498      * `errorMessage` as a fallback revert reason when `target` reverts.
499      *
500      * _Available since v3.1._
501      */
502     function functionCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value
525     ) internal returns (bytes memory) {
526         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
531      * with `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(address(this).balance >= value, "Address: insufficient balance for call");
542         require(isContract(target), "Address: call to non-contract");
543 
544         // solhint-disable-next-line avoid-low-level-calls
545         (bool success, bytes memory returndata) = target.call{value: value}(data);
546         return _verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
556         return functionStaticCall(target, data, "Address: low-level static call failed");
557     }
558 
559     /**
560      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
561      * but performing a static call.
562      *
563      * _Available since v3.3._
564      */
565     function functionStaticCall(
566         address target,
567         bytes memory data,
568         string memory errorMessage
569     ) internal view returns (bytes memory) {
570         require(isContract(target), "Address: static call to non-contract");
571 
572         // solhint-disable-next-line avoid-low-level-calls
573         (bool success, bytes memory returndata) = target.staticcall(data);
574         return _verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
584         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(
594         address target,
595         bytes memory data,
596         string memory errorMessage
597     ) internal returns (bytes memory) {
598         require(isContract(target), "Address: delegate call to non-contract");
599 
600         // solhint-disable-next-line avoid-low-level-calls
601         (bool success, bytes memory returndata) = target.delegatecall(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     function _verifyCallResult(
606         bool success,
607         bytes memory returndata,
608         string memory errorMessage
609     ) private pure returns (bytes memory) {
610         if (success) {
611             return returndata;
612         } else {
613             // Look for revert reason and bubble it up if present
614             if (returndata.length > 0) {
615                 // The easiest way to bubble the revert reason is using memory via assembly
616 
617                 // solhint-disable-next-line no-inline-assembly
618                 assembly {
619                     let returndata_size := mload(returndata)
620                     revert(add(32, returndata), returndata_size)
621                 }
622             } else {
623                 revert(errorMessage);
624             }
625         }
626     }
627 }
628 
629 library SafeBEP20 {
630     using SafeMath for uint256;
631     using Address for address;
632 
633     function safeTransfer(
634         IBEP20 token,
635         address to,
636         uint256 value
637     ) internal {
638         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
639     }
640 
641     function safeTransferFrom(
642         IBEP20 token,
643         address from,
644         address to,
645         uint256 value
646     ) internal {
647         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
648     }
649 
650     /**
651      * @dev Deprecated. This function has issues similar to the ones found in
652      * {IBEP20-approve}, and its usage is discouraged.
653      *
654      * Whenever possible, use {safeIncreaseAllowance} and
655      * {safeDecreaseAllowance} instead.
656      */
657     function safeApprove(
658         IBEP20 token,
659         address spender,
660         uint256 value
661     ) internal {
662         // safeApprove should only be called when setting an initial allowance,
663         // or when resetting it to zero. To increase and decrease it, use
664         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
665         // solhint-disable-next-line max-line-length
666         require(
667             (value == 0) || (token.allowance(address(this), spender) == 0),
668             "SafeBEP20: approve from non-zero to non-zero allowance"
669         );
670         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
671     }
672 
673     function safeIncreaseAllowance(
674         IBEP20 token,
675         address spender,
676         uint256 value
677     ) internal {
678         uint256 newAllowance = token.allowance(address(this), spender).add(value);
679         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
680     }
681 
682     function safeDecreaseAllowance(
683         IBEP20 token,
684         address spender,
685         uint256 value
686     ) internal {
687         uint256 newAllowance =
688             token.allowance(address(this), spender).sub(value, "SafeBEP20: decreased allowance below zero");
689         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
690     }
691 
692     /**
693      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
694      * on the return value: the return value is optional (but if data is returned, it must not be false).
695      * @param token The token targeted by the call.
696      * @param data The call data (encoded using abi.encode or one of its variants).
697      */
698     function _callOptionalReturn(IBEP20 token, bytes memory data) private {
699         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
700         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
701         // the target address contains contract code and also asserts for success in the low-level call.
702 
703         bytes memory returndata = address(token).functionCall(data, "SafeBEP20: low-level call failed");
704         if (returndata.length > 0) {
705             // Return data is optional
706             // solhint-disable-next-line max-line-length
707             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
708         }
709     }
710 }
711 
712 
713 contract KodachiStaking is Ownable, ReentrancyGuard {
714     using SafeMath for uint256;
715     using SafeBEP20 for IBEP20;
716 
717     // Whether it is initialized
718     bool public isInitialized;
719 
720     // Accrued token per share
721     uint256 public accTokenPerShare;
722 
723     // The block number when kodachi reward ends.
724     uint256 public bonusEndBlock;
725 
726     // The block number when kodachi reward starts.
727     uint256 public startBlock;
728 
729     // The block number of the last pool update
730     uint256 public lastRewardBlock;
731 
732     // KATSUMI tokens reward per block.
733     uint256 public rewardPerBlock;
734     
735     // The precision factor
736     uint256 public PRECISION_FACTOR;
737 
738     // The reward token
739     IBEP20 public rewardToken;
740 
741     // The staked token
742     IBEP20 public stakedToken;
743 
744     // token staked
745     uint256 public tokenStaked;
746 
747     // Info of each user that stakes tokens (stakedToken)
748     mapping(address => UserInfo) public userInfo;
749 
750     struct UserInfo {
751         uint256 amount; // How many staked tokens the user has provided
752         uint256 rewardDebt; // Reward debt
753     }
754 
755     event AdminTokenRecovery(address tokenRecovered, uint256 amount);
756     event Deposit(address indexed user, uint256 amount);
757     event EmergencyWithdraw(address indexed user, uint256 amount);
758     event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);
759     event NewRewardPerBlock(uint256 rewardPerBlock);
760     event RewardsStop(uint256 blockNumber);
761     event Withdraw(address indexed user, uint256 amount);
762 
763     constructor() public {}
764 
765     /*
766      * @notice Initialize the contract
767      * @param _stakedToken: staked token address
768      * @param _rewardToken: reward token address
769      * @param _rewardPerBlock: reward per block (in rewardToken)
770      * @param _startBlock: start block
771      * @param _bonusEndBlock: end block
772      * @param _poolLimitPerUser: pool limit per user in stakedToken (if any, else 0)
773      * @param _admin: admin address with ownership
774      */
775     function initialize(
776         IBEP20 _stakedToken,
777         IBEP20 _rewardToken,
778         uint256 _rewardPerBlock,
779         uint256 _startBlock,
780         uint256 _bonusEndBlock
781     ) external onlyOwner {
782         require(!isInitialized, "Already initialized");
783 
784         // Make this contract initialized
785         isInitialized = true;
786 
787         stakedToken = _stakedToken;
788         rewardToken = _rewardToken;
789         rewardPerBlock = _rewardPerBlock;
790         startBlock = _startBlock;
791         bonusEndBlock = _bonusEndBlock;
792 
793 
794         uint256 decimalsRewardToken = uint256(rewardToken.decimals());
795         require(decimalsRewardToken < 30, "Must be inferior to 30");
796 
797         PRECISION_FACTOR = uint256(10**(uint256(30).sub(decimalsRewardToken)));
798 
799         // Set the lastRewardBlock as the startBlock
800         lastRewardBlock = startBlock;
801 
802     }
803     
804     function modifyTimes(uint256 _startTime, uint256 _endTime, uint256 _reward) public onlyOwner {
805         startBlock = _startTime;
806         bonusEndBlock = _endTime;
807         rewardPerBlock = _reward;
808         lastRewardBlock = startBlock;
809     }
810 
811     /*
812      * @notice Deposit staked tokens and collect reward tokens (if any)
813      * @param _amount: amount to withdraw (in rewardToken)
814      */
815     function deposit(uint256 _amount) external nonReentrant {
816         UserInfo storage user = userInfo[msg.sender];
817 
818         _updatePool();
819 
820         if (user.amount > 0) {
821             uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
822             if (pending > 0) {
823                 rewardToken.safeTransfer(address(msg.sender), pending);
824             }
825         }
826 
827         if (_amount > 0) {
828             stakedToken.safeTransferFrom(address(msg.sender), address(this), _amount);
829             user.amount = user.amount.add(_amount);
830             
831         }
832 
833         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
834         tokenStaked+=_amount;
835 
836         emit Deposit(msg.sender, _amount);
837     }
838 
839     function harvest() external nonReentrant {
840         UserInfo storage user = userInfo[msg.sender];
841         require(user.amount > 0, "No staked amount");
842         _updatePool();
843 
844         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
845         require(pending > 0, "No reward to harvest");
846 
847         rewardToken.safeTransfer(address(msg.sender), pending);
848         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
849 
850     }
851 
852     /*
853      * @notice Withdraw staked tokens and collect reward tokens
854      * @param _amount: amount to withdraw (in rewardToken)
855      */
856     function withdraw(uint256 _amount) external nonReentrant {
857         require(block.number >= bonusEndBlock, "tokens are locked");
858         UserInfo storage user = userInfo[msg.sender];
859         require(user.amount >= _amount, "Amount to withdraw too high");
860 
861         _updatePool();
862 
863         uint256 pending = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
864 
865         if (_amount > 0) {
866             user.amount = user.amount.sub(_amount);
867             stakedToken.safeTransfer(address(msg.sender), _amount);
868         }
869 
870         if (pending > 0) {
871             rewardToken.safeTransfer(address(msg.sender), pending);
872         }
873 
874         user.rewardDebt = user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR);
875         tokenStaked = tokenStaked.sub(_amount);
876 
877         emit Withdraw(msg.sender, _amount);
878     }
879 
880     /*
881      * @notice Withdraw staked tokens without caring about rewards rewards
882      * @dev Needs to be for emergency.
883      */
884     function emergencyWithdraw() external nonReentrant {
885         require(block.number >= bonusEndBlock, "tokens are locked");
886 
887         UserInfo storage user = userInfo[msg.sender];
888         uint256 amountToTransfer = user.amount;
889         user.amount = 0;
890         user.rewardDebt = 0;
891 
892         if (amountToTransfer > 0) {
893             stakedToken.safeTransfer(address(msg.sender), amountToTransfer);
894         }
895         tokenStaked = tokenStaked.sub(amountToTransfer);
896 
897         emit EmergencyWithdraw(msg.sender, user.amount);
898     }
899 
900     /*
901      * @notice Stop rewards
902      * @dev Only callable by owner. Needs to be for emergency.
903      */
904     function emergencyRewardWithdraw(uint256 _amount) external onlyOwner {
905         rewardToken.safeTransfer(address(msg.sender), _amount);
906     }
907 
908     /**
909      * @notice It allows the admin to recover wrong tokens sent to the contract
910      * @param _tokenAddress: the address of the token to withdraw
911      * @param _tokenAmount: the number of tokens to withdraw
912      * @dev This function is only callable by admin.
913      */
914     function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
915         require(_tokenAddress != address(stakedToken), "Cannot be staked token");
916         require(_tokenAddress != address(rewardToken), "Cannot be reward token");
917 
918         IBEP20(_tokenAddress).safeTransfer(address(msg.sender), _tokenAmount);
919 
920         emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
921     }
922 
923     /*
924      * @notice Stop rewards
925      * @dev Only callable by owner
926      */
927     function stopReward() external onlyOwner {
928         bonusEndBlock = block.number;
929     }
930 
931 
932     /*
933      * @notice Update reward per block
934      * @dev Only callable by owner.
935      * @param _rewardPerBlock: the reward per block
936      */
937     function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner {
938         rewardPerBlock = _rewardPerBlock;
939         emit NewRewardPerBlock(_rewardPerBlock);
940     }
941 
942     /**
943      * @notice It allows the admin to update start and end blocks
944      * @dev This function is only callable by owner.
945      * @param _startBlock: the new start block
946      * @param _bonusEndBlock: the new end block
947      */
948     function updateStartAndEndBlocks(uint256 _startBlock, uint256 _bonusEndBlock) external onlyOwner {
949         require(block.number < startBlock, "Pool has started");
950         require(_startBlock < _bonusEndBlock, "New startBlock must be lower than new endBlock");
951         require(block.number < _startBlock, "New startBlock must be higher than current block");
952 
953         startBlock = _startBlock;
954         bonusEndBlock = _bonusEndBlock;
955 
956         // Set the lastRewardBlock as the startBlock
957         lastRewardBlock = startBlock;
958 
959         emit NewStartAndEndBlocks(_startBlock, _bonusEndBlock);
960     }
961 
962     /*
963      * @notice View function to see pending reward on frontend.
964      * @param _user: user address
965      * @return Pending reward for a given user
966      */
967     function pendingReward(address _user) external view returns (uint256) {
968         UserInfo storage user = userInfo[_user];
969         if (block.number > lastRewardBlock && tokenStaked != 0) {
970             uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
971             uint256 kodachiReward = multiplier.mul(rewardPerBlock);
972             uint256 adjustedTokenPerShare =
973                 accTokenPerShare.add(kodachiReward.mul(PRECISION_FACTOR).div(tokenStaked));
974             return user.amount.mul(adjustedTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
975         } else {
976             return user.amount.mul(accTokenPerShare).div(PRECISION_FACTOR).sub(user.rewardDebt);
977         }
978     }
979 
980     /*
981      * @notice Update reward variables of the given pool to be up-to-date.
982      */
983     function _updatePool() internal {
984         if (block.number <= lastRewardBlock) {
985             return;
986         }
987 
988         if (tokenStaked == 0) {
989             lastRewardBlock = block.number;
990             return;
991         }
992 
993         uint256 multiplier = _getMultiplier(lastRewardBlock, block.number);
994         uint256 kodachiReward = multiplier.mul(rewardPerBlock);
995         accTokenPerShare = accTokenPerShare.add(kodachiReward.mul(PRECISION_FACTOR).div(tokenStaked));
996         lastRewardBlock = block.number;
997     }
998 
999     /*
1000      * @notice Return reward multiplier over the given _from to _to block.
1001      * @param _from: block to start
1002      * @param _to: block to finish
1003      */
1004     function _getMultiplier(uint256 _from, uint256 _to) internal view returns (uint256) {
1005         if (_to <= bonusEndBlock) {
1006             return _to.sub(_from);
1007         } else if (_from >= bonusEndBlock) {
1008             return 0;
1009         } else {
1010             return bonusEndBlock.sub(_from);
1011         }
1012     }
1013 }