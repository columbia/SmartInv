1 // File: contracts/sol6/IERC20.sol
2 
3 pragma solidity 0.6.6;
4 
5 
6 interface IERC20 {
7     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
8 
9     function approve(address _spender, uint256 _value) external returns (bool success);
10 
11     function transfer(address _to, uint256 _value) external returns (bool success);
12 
13     function transferFrom(
14         address _from,
15         address _to,
16         uint256 _value
17     ) external returns (bool success);
18 
19     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
20 
21     function balanceOf(address _owner) external view returns (uint256 balance);
22 
23     function decimals() external view returns (uint8 digits);
24 
25     function totalSupply() external view returns (uint256 supply);
26 }
27 
28 
29 // to support backward compatible contract name -- so function signature remains same
30 abstract contract ERC20 is IERC20 {
31 
32 }
33 
34 // File: contracts/sol6/reserves/IConversionRates.sol
35 
36 pragma solidity 0.6.6;
37 
38 
39 
40 interface IConversionRates {
41 
42     function recordImbalance(
43         IERC20 token,
44         int buyAmount,
45         uint256 rateUpdateBlock,
46         uint256 currentBlock
47     ) external;
48 
49     function getRate(
50         IERC20 token,
51         uint256 currentBlockNumber,
52         bool buy,
53         uint256 qty
54     ) external view returns(uint256);
55 }
56 
57 // File: contracts/sol6/reserves/IWeth.sol
58 
59 pragma solidity 0.6.6;
60 
61 
62 
63 interface IWeth is IERC20 {
64     function deposit() external payable;
65     function withdraw(uint256 wad) external;
66 }
67 
68 // File: contracts/sol6/IKyberSanity.sol
69 
70 pragma solidity 0.6.6;
71 
72 
73 interface IKyberSanity {
74     function getSanityRate(IERC20 src, IERC20 dest) external view returns (uint256);
75 }
76 
77 // File: contracts/sol6/IKyberReserve.sol
78 
79 pragma solidity 0.6.6;
80 
81 
82 
83 interface IKyberReserve {
84     function trade(
85         IERC20 srcToken,
86         uint256 srcAmount,
87         IERC20 destToken,
88         address payable destAddress,
89         uint256 conversionRate,
90         bool validate
91     ) external payable returns (bool);
92 
93     function getConversionRate(
94         IERC20 src,
95         IERC20 dest,
96         uint256 srcQty,
97         uint256 blockNumber
98     ) external view returns (uint256);
99 }
100 
101 // File: contracts/sol6/utils/Utils5.sol
102 
103 pragma solidity 0.6.6;
104 
105 
106 
107 /**
108  * @title Kyber utility file
109  * mostly shared constants and rate calculation helpers
110  * inherited by most of kyber contracts.
111  * previous utils implementations are for previous solidity versions.
112  */
113 contract Utils5 {
114     IERC20 internal constant ETH_TOKEN_ADDRESS = IERC20(
115         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
116     );
117     uint256 internal constant PRECISION = (10**18);
118     uint256 internal constant MAX_QTY = (10**28); // 10B tokens
119     uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
120     uint256 internal constant MAX_DECIMALS = 18;
121     uint256 internal constant ETH_DECIMALS = 18;
122     uint256 constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
123     uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite
124 
125     mapping(IERC20 => uint256) internal decimals;
126 
127     function getUpdateDecimals(IERC20 token) internal returns (uint256) {
128         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
129         uint256 tokenDecimals = decimals[token];
130         // moreover, very possible that old tokens have decimals 0
131         // these tokens will just have higher gas fees.
132         if (tokenDecimals == 0) {
133             tokenDecimals = token.decimals();
134             decimals[token] = tokenDecimals;
135         }
136 
137         return tokenDecimals;
138     }
139 
140     function setDecimals(IERC20 token) internal {
141         if (decimals[token] != 0) return; //already set
142 
143         if (token == ETH_TOKEN_ADDRESS) {
144             decimals[token] = ETH_DECIMALS;
145         } else {
146             decimals[token] = token.decimals();
147         }
148     }
149 
150     /// @dev get the balance of a user.
151     /// @param token The token type
152     /// @return The balance
153     function getBalance(IERC20 token, address user) internal view returns (uint256) {
154         if (token == ETH_TOKEN_ADDRESS) {
155             return user.balance;
156         } else {
157             return token.balanceOf(user);
158         }
159     }
160 
161     function getDecimals(IERC20 token) internal view returns (uint256) {
162         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
163         uint256 tokenDecimals = decimals[token];
164         // moreover, very possible that old tokens have decimals 0
165         // these tokens will just have higher gas fees.
166         if (tokenDecimals == 0) return token.decimals();
167 
168         return tokenDecimals;
169     }
170 
171     function calcDestAmount(
172         IERC20 src,
173         IERC20 dest,
174         uint256 srcAmount,
175         uint256 rate
176     ) internal view returns (uint256) {
177         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
178     }
179 
180     function calcSrcAmount(
181         IERC20 src,
182         IERC20 dest,
183         uint256 destAmount,
184         uint256 rate
185     ) internal view returns (uint256) {
186         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
187     }
188 
189     function calcDstQty(
190         uint256 srcQty,
191         uint256 srcDecimals,
192         uint256 dstDecimals,
193         uint256 rate
194     ) internal pure returns (uint256) {
195         require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
196         require(rate <= MAX_RATE, "rate > MAX_RATE");
197 
198         if (dstDecimals >= srcDecimals) {
199             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
200             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
201         } else {
202             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
203             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
204         }
205     }
206 
207     function calcSrcQty(
208         uint256 dstQty,
209         uint256 srcDecimals,
210         uint256 dstDecimals,
211         uint256 rate
212     ) internal pure returns (uint256) {
213         require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
214         require(rate <= MAX_RATE, "rate > MAX_RATE");
215 
216         //source quantity is rounded up. to avoid dest quantity being too low.
217         uint256 numerator;
218         uint256 denominator;
219         if (srcDecimals >= dstDecimals) {
220             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
221             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
222             denominator = rate;
223         } else {
224             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
225             numerator = (PRECISION * dstQty);
226             denominator = (rate * (10**(dstDecimals - srcDecimals)));
227         }
228         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
229     }
230 
231     function calcRateFromQty(
232         uint256 srcAmount,
233         uint256 destAmount,
234         uint256 srcDecimals,
235         uint256 dstDecimals
236     ) internal pure returns (uint256) {
237         require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
238         require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");
239 
240         if (dstDecimals >= srcDecimals) {
241             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
242             return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
243         } else {
244             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
245             return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
246         }
247     }
248 
249     function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
250         return x > y ? y : x;
251     }
252 }
253 
254 // File: contracts/sol6/utils/PermissionGroups3.sol
255 
256 pragma solidity 0.6.6;
257 
258 contract PermissionGroups3 {
259     uint256 internal constant MAX_GROUP_SIZE = 50;
260 
261     address public admin;
262     address public pendingAdmin;
263     mapping(address => bool) internal operators;
264     mapping(address => bool) internal alerters;
265     address[] internal operatorsGroup;
266     address[] internal alertersGroup;
267 
268     event AdminClaimed(address newAdmin, address previousAdmin);
269 
270     event TransferAdminPending(address pendingAdmin);
271 
272     event OperatorAdded(address newOperator, bool isAdd);
273 
274     event AlerterAdded(address newAlerter, bool isAdd);
275 
276     constructor(address _admin) public {
277         require(_admin != address(0), "admin 0");
278         admin = _admin;
279     }
280 
281     modifier onlyAdmin() {
282         require(msg.sender == admin, "only admin");
283         _;
284     }
285 
286     modifier onlyOperator() {
287         require(operators[msg.sender], "only operator");
288         _;
289     }
290 
291     modifier onlyAlerter() {
292         require(alerters[msg.sender], "only alerter");
293         _;
294     }
295 
296     function getOperators() external view returns (address[] memory) {
297         return operatorsGroup;
298     }
299 
300     function getAlerters() external view returns (address[] memory) {
301         return alertersGroup;
302     }
303 
304     /**
305      * @dev Allows the current admin to set the pendingAdmin address.
306      * @param newAdmin The address to transfer ownership to.
307      */
308     function transferAdmin(address newAdmin) public onlyAdmin {
309         require(newAdmin != address(0), "new admin 0");
310         emit TransferAdminPending(newAdmin);
311         pendingAdmin = newAdmin;
312     }
313 
314     /**
315      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
316      * @param newAdmin The address to transfer ownership to.
317      */
318     function transferAdminQuickly(address newAdmin) public onlyAdmin {
319         require(newAdmin != address(0), "admin 0");
320         emit TransferAdminPending(newAdmin);
321         emit AdminClaimed(newAdmin, admin);
322         admin = newAdmin;
323     }
324 
325     /**
326      * @dev Allows the pendingAdmin address to finalize the change admin process.
327      */
328     function claimAdmin() public {
329         require(pendingAdmin == msg.sender, "not pending");
330         emit AdminClaimed(pendingAdmin, admin);
331         admin = pendingAdmin;
332         pendingAdmin = address(0);
333     }
334 
335     function addAlerter(address newAlerter) public onlyAdmin {
336         require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
337         require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");
338 
339         emit AlerterAdded(newAlerter, true);
340         alerters[newAlerter] = true;
341         alertersGroup.push(newAlerter);
342     }
343 
344     function removeAlerter(address alerter) public onlyAdmin {
345         require(alerters[alerter], "not alerter");
346         alerters[alerter] = false;
347 
348         for (uint256 i = 0; i < alertersGroup.length; ++i) {
349             if (alertersGroup[i] == alerter) {
350                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
351                 alertersGroup.pop();
352                 emit AlerterAdded(alerter, false);
353                 break;
354             }
355         }
356     }
357 
358     function addOperator(address newOperator) public onlyAdmin {
359         require(!operators[newOperator], "operator exists"); // prevent duplicates.
360         require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");
361 
362         emit OperatorAdded(newOperator, true);
363         operators[newOperator] = true;
364         operatorsGroup.push(newOperator);
365     }
366 
367     function removeOperator(address operator) public onlyAdmin {
368         require(operators[operator], "not operator");
369         operators[operator] = false;
370 
371         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
372             if (operatorsGroup[i] == operator) {
373                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
374                 operatorsGroup.pop();
375                 emit OperatorAdded(operator, false);
376                 break;
377             }
378         }
379     }
380 }
381 
382 // File: contracts/sol6/utils/Withdrawable3.sol
383 
384 pragma solidity 0.6.6;
385 
386 
387 
388 contract Withdrawable3 is PermissionGroups3 {
389     constructor(address _admin) public PermissionGroups3(_admin) {}
390 
391     event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);
392 
393     event EtherWithdraw(uint256 amount, address sendTo);
394 
395     /**
396      * @dev Withdraw all IERC20 compatible tokens
397      * @param token IERC20 The address of the token contract
398      */
399     function withdrawToken(
400         IERC20 token,
401         uint256 amount,
402         address sendTo
403     ) external onlyAdmin {
404         token.transfer(sendTo, amount);
405         emit TokenWithdraw(token, amount, sendTo);
406     }
407 
408     /**
409      * @dev Withdraw Ethers
410      */
411     function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
412         (bool success, ) = sendTo.call{value: amount}("");
413         require(success);
414         emit EtherWithdraw(amount, sendTo);
415     }
416 }
417 
418 // File: contracts/sol6/utils/zeppelin/SafeMath.sol
419 
420 pragma solidity 0.6.6;
421 
422 /**
423  * @dev Wrappers over Solidity's arithmetic operations with added overflow
424  * checks.
425  *
426  * Arithmetic operations in Solidity wrap on overflow. This can easily result
427  * in bugs, because programmers usually assume that an overflow raises an
428  * error, which is the standard behavior in high level programming languages.
429  * `SafeMath` restores this intuition by reverting the transaction when an
430  * operation overflows.
431  *
432  * Using this library instead of the unchecked operations eliminates an entire
433  * class of bugs, so it's recommended to use it always.
434  */
435 library SafeMath {
436     /**
437      * @dev Returns the addition of two unsigned integers, reverting on
438      * overflow.
439      *
440      * Counterpart to Solidity's `+` operator.
441      *
442      * Requirements:
443      * - Addition cannot overflow.
444      */
445     function add(uint256 a, uint256 b) internal pure returns (uint256) {
446         uint256 c = a + b;
447         require(c >= a, "SafeMath: addition overflow");
448 
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
459      * - Subtraction cannot overflow.
460      */
461     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
462         return sub(a, b, "SafeMath: subtraction overflow");
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
467      * overflow (when the result is negative).
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      * - Subtraction cannot overflow.
473      */
474     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
475         require(b <= a, errorMessage);
476         uint256 c = a - b;
477 
478         return c;
479     }
480 
481     /**
482      * @dev Returns the multiplication of two unsigned integers, reverting on
483      * overflow.
484      *
485      * Counterpart to Solidity's `*` operator.
486      *
487      * Requirements:
488      * - Multiplication cannot overflow.
489      */
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
492         // benefit is lost if 'b' is also tested.
493         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
494         if (a == 0) {
495             return 0;
496         }
497 
498         uint256 c = a * b;
499         require(c / a == b, "SafeMath: multiplication overflow");
500 
501         return c;
502     }
503 
504     /**
505      * @dev Returns the integer division of two unsigned integers. Reverts on
506      * division by zero. The result is rounded towards zero.
507      *
508      * Counterpart to Solidity's `/` operator. Note: this function uses a
509      * `revert` opcode (which leaves remaining gas untouched) while Solidity
510      * uses an invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      * - The divisor cannot be zero.
514      */
515     function div(uint256 a, uint256 b) internal pure returns (uint256) {
516         return div(a, b, "SafeMath: division by zero");
517     }
518 
519     /**
520      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
521      * division by zero. The result is rounded towards zero.
522      *
523      * Counterpart to Solidity's `/` operator. Note: this function uses a
524      * `revert` opcode (which leaves remaining gas untouched) while Solidity
525      * uses an invalid opcode to revert (consuming all remaining gas).
526      *
527      * Requirements:
528      * - The divisor cannot be zero.
529      */
530     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
531         // Solidity only automatically asserts when dividing by 0
532         require(b > 0, errorMessage);
533         uint256 c = a / b;
534         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
535 
536         return c;
537     }
538 
539     /**
540      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
541      * Reverts when dividing by zero.
542      *
543      * Counterpart to Solidity's `%` operator. This function uses a `revert`
544      * opcode (which leaves remaining gas untouched) while Solidity uses an
545      * invalid opcode to revert (consuming all remaining gas).
546      *
547      * Requirements:
548      * - The divisor cannot be zero.
549      */
550     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
551         return mod(a, b, "SafeMath: modulo by zero");
552     }
553 
554     /**
555      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
556      * Reverts with custom message when dividing by zero.
557      *
558      * Counterpart to Solidity's `%` operator. This function uses a `revert`
559      * opcode (which leaves remaining gas untouched) while Solidity uses an
560      * invalid opcode to revert (consuming all remaining gas).
561      *
562      * Requirements:
563      * - The divisor cannot be zero.
564      */
565     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
566         require(b != 0, errorMessage);
567         return a % b;
568     }
569 
570     /**
571      * @dev Returns the smallest of two numbers.
572      */
573     function min(uint256 a, uint256 b) internal pure returns (uint256) {
574         return a < b ? a : b;
575     }
576 }
577 
578 // File: contracts/sol6/utils/zeppelin/Address.sol
579 
580 pragma solidity 0.6.6;
581 
582 /**
583  * @dev Collection of functions related to the address type
584  */
585 library Address {
586     /**
587      * @dev Returns true if `account` is a contract.
588      *
589      * [IMPORTANT]
590      * ====
591      * It is unsafe to assume that an address for which this function returns
592      * false is an externally-owned account (EOA) and not a contract.
593      *
594      * Among others, `isContract` will return false for the following
595      * types of addresses:
596      *
597      *  - an externally-owned account
598      *  - a contract in construction
599      *  - an address where a contract will be created
600      *  - an address where a contract lived, but was destroyed
601      * ====
602      */
603     function isContract(address account) internal view returns (bool) {
604         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
605         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
606         // for accounts without code, i.e. `keccak256('')`
607         bytes32 codehash;
608         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
609         // solhint-disable-next-line no-inline-assembly
610         assembly { codehash := extcodehash(account) }
611         return (codehash != accountHash && codehash != 0x0);
612     }
613 
614     /**
615      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
616      * `recipient`, forwarding all available gas and reverting on errors.
617      *
618      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
619      * of certain opcodes, possibly making contracts go over the 2300 gas limit
620      * imposed by `transfer`, making them unable to receive funds via
621      * `transfer`. {sendValue} removes this limitation.
622      *
623      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
624      *
625      * IMPORTANT: because control is transferred to `recipient`, care must be
626      * taken to not create reentrancy vulnerabilities. Consider using
627      * {ReentrancyGuard} or the
628      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
629      */
630     function sendValue(address payable recipient, uint256 amount) internal {
631         require(address(this).balance >= amount, "Address: insufficient balance");
632 
633         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
634         (bool success, ) = recipient.call{ value: amount }("");
635         require(success, "Address: unable to send value, recipient may have reverted");
636     }
637 }
638 
639 // File: contracts/sol6/utils/zeppelin/SafeERC20.sol
640 
641 pragma solidity 0.6.6;
642 
643 
644 
645 
646 /**
647  * @title SafeERC20
648  * @dev Wrappers around ERC20 operations that throw on failure (when the token
649  * contract returns false). Tokens that return no value (and instead revert or
650  * throw on failure) are also supported, non-reverting calls are assumed to be
651  * successful.
652  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
653  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
654  */
655 library SafeERC20 {
656     using SafeMath for uint256;
657     using Address for address;
658 
659     function safeTransfer(IERC20 token, address to, uint256 value) internal {
660         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
661     }
662 
663     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
664         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
665     }
666 
667     function safeApprove(IERC20 token, address spender, uint256 value) internal {
668         // safeApprove should only be called when setting an initial allowance,
669         // or when resetting it to zero. To increase and decrease it, use
670         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
671         // solhint-disable-next-line max-line-length
672         require((value == 0) || (token.allowance(address(this), spender) == 0),
673             "SafeERC20: approve from non-zero to non-zero allowance"
674         );
675         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
676     }
677 
678     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
679         uint256 newAllowance = token.allowance(address(this), spender).add(value);
680         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
681     }
682 
683     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
684         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
685         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
686     }
687 
688     /**
689      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
690      * on the return value: the return value is optional (but if data is returned, it must not be false).
691      * @param token The token targeted by the call.
692      * @param data The call data (encoded using abi.encode or one of its variants).
693      */
694     function _callOptionalReturn(IERC20 token, bytes memory data) private {
695         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
696         // we're implementing it ourselves.
697 
698         // A Solidity high level call has three parts:
699         //  1. The target address is checked to verify it contains contract code
700         //  2. The call itself is made, and success asserted
701         //  3. The return value is decoded, which in turn checks the size of the returned data.
702         // solhint-disable-next-line max-line-length
703         require(address(token).isContract(), "SafeERC20: call to non-contract");
704 
705         // solhint-disable-next-line avoid-low-level-calls
706         (bool success, bytes memory returndata) = address(token).call(data);
707         require(success, "SafeERC20: low-level call failed");
708 
709         if (returndata.length > 0) { // Return data is optional
710             // solhint-disable-next-line max-line-length
711             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
712         }
713     }
714 }
715 
716 // File: contracts/sol6/reserves/KyberFprReserveV2.sol
717 
718 // SPDX-License-Identifier: MIT
719 pragma solidity 0.6.6;
720 
721 
722 
723 
724 
725 
726 
727 
728 
729 /// @title KyberFprReserve version 2
730 /// Allow Reserve to work work with either weth or eth.
731 /// for working with weth should specify external address to hold weth.
732 /// Allow Reserve to set maxGasPriceWei to trade with
733 contract KyberFprReserveV2 is IKyberReserve, Utils5, Withdrawable3 {
734     using SafeERC20 for IERC20;
735     using SafeMath for uint256;
736 
737     mapping(bytes32 => bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
738     mapping(address => address) public tokenWallet;
739 
740     struct ConfigData {
741         bool tradeEnabled;
742         bool doRateValidation; // whether to do rate validation in trade func
743         uint128 maxGasPriceWei;
744     }
745 
746     address public kyberNetwork;
747     ConfigData internal configData;
748 
749     IConversionRates public conversionRatesContract;
750     IKyberSanity public sanityRatesContract;
751     IWeth public weth;
752 
753     event DepositToken(IERC20 indexed token, uint256 amount);
754     event TradeExecute(
755         address indexed origin,
756         IERC20 indexed src,
757         uint256 srcAmount,
758         IERC20 indexed destToken,
759         uint256 destAmount,
760         address payable destAddress
761     );
762     event TradeEnabled(bool enable);
763     event MaxGasPriceUpdated(uint128 newMaxGasPrice);
764     event DoRateValidationUpdated(bool doRateValidation);
765     event WithdrawAddressApproved(IERC20 indexed token, address indexed addr, bool approve);
766     event NewTokenWallet(IERC20 indexed token, address indexed wallet);
767     event WithdrawFunds(IERC20 indexed token, uint256 amount, address indexed destination);
768     event SetKyberNetworkAddress(address indexed network);
769     event SetConversionRateAddress(IConversionRates indexed rate);
770     event SetWethAddress(IWeth indexed weth);
771     event SetSanityRateAddress(IKyberSanity indexed sanity);
772 
773     constructor(
774         address _kyberNetwork,
775         IConversionRates _ratesContract,
776         IWeth _weth,
777         uint128 _maxGasPriceWei,
778         bool _doRateValidation,
779         address _admin
780     ) public Withdrawable3(_admin) {
781         require(_kyberNetwork != address(0), "kyberNetwork 0");
782         require(_ratesContract != IConversionRates(0), "ratesContract 0");
783         require(_weth != IWeth(0), "weth 0");
784         kyberNetwork = _kyberNetwork;
785         conversionRatesContract = _ratesContract;
786         weth = _weth;
787         configData = ConfigData({
788             tradeEnabled: true,
789             maxGasPriceWei: _maxGasPriceWei,
790             doRateValidation: _doRateValidation
791         });
792     }
793 
794     receive() external payable {
795         emit DepositToken(ETH_TOKEN_ADDRESS, msg.value);
796     }
797 
798     function trade(
799         IERC20 srcToken,
800         uint256 srcAmount,
801         IERC20 destToken,
802         address payable destAddress,
803         uint256 conversionRate,
804         bool /* validate */
805     ) external override payable returns (bool) {
806         require(msg.sender == kyberNetwork, "wrong sender");
807         ConfigData memory data = configData;
808         require(data.tradeEnabled, "trade not enable");
809         require(tx.gasprice <= uint256(data.maxGasPriceWei), "gas price too high");
810 
811         doTrade(
812             srcToken,
813             srcAmount,
814             destToken,
815             destAddress,
816             conversionRate,
817             data.doRateValidation
818         );
819 
820         return true;
821     }
822 
823     function enableTrade() external onlyAdmin {
824         configData.tradeEnabled = true;
825         emit TradeEnabled(true);
826     }
827 
828     function disableTrade() external onlyAlerter {
829         configData.tradeEnabled = false;
830         emit TradeEnabled(false);
831     }
832 
833     function setMaxGasPrice(uint128 newMaxGasPrice) external onlyOperator {
834         configData.maxGasPriceWei = newMaxGasPrice;
835         emit MaxGasPriceUpdated(newMaxGasPrice);
836     }
837 
838     function setDoRateValidation(bool _doRateValidation) external onlyAdmin {
839         configData.doRateValidation = _doRateValidation;
840         emit DoRateValidationUpdated(_doRateValidation);
841     }
842 
843     function approveWithdrawAddress(
844         IERC20 token,
845         address addr,
846         bool approve
847     ) external onlyAdmin {
848         approvedWithdrawAddresses[keccak256(abi.encodePacked(address(token), addr))] = approve;
849         setDecimals(token);
850         emit WithdrawAddressApproved(token, addr, approve);
851     }
852 
853     /// @dev allow set tokenWallet[token] back to 0x0 address
854     /// @dev in case of using weth from external wallet, must call set token wallet for weth
855     ///      tokenWallet for weth must be different from this reserve address
856     function setTokenWallet(IERC20 token, address wallet) external onlyAdmin {
857         tokenWallet[address(token)] = wallet;
858         setDecimals(token);
859         emit NewTokenWallet(token, wallet);
860     }
861 
862     /// @dev withdraw amount of token to an approved destination
863     ///      if reserve is using weth instead of eth, should call withdraw weth
864     /// @param token token to withdraw
865     /// @param amount amount to withdraw
866     /// @param destination address to transfer fund to
867     function withdraw(
868         IERC20 token,
869         uint256 amount,
870         address destination
871     ) external onlyOperator {
872         require(
873             approvedWithdrawAddresses[keccak256(abi.encodePacked(address(token), destination))],
874             "destination is not approved"
875         );
876 
877         if (token == ETH_TOKEN_ADDRESS) {
878             (bool success, ) = destination.call{value: amount}("");
879             require(success, "withdraw eth failed");
880         } else {
881             address wallet = getTokenWallet(token);
882             if (wallet == address(this)) {
883                 token.safeTransfer(destination, amount);
884             } else {
885                 token.safeTransferFrom(wallet, destination, amount);
886             }
887         }
888 
889         emit WithdrawFunds(token, amount, destination);
890     }
891 
892     function setKyberNetwork(address _newNetwork) external onlyAdmin {
893         require(_newNetwork != address(0), "kyberNetwork 0");
894         kyberNetwork = _newNetwork;
895         emit SetKyberNetworkAddress(_newNetwork);
896     }
897 
898     function setConversionRate(IConversionRates _newConversionRate) external onlyAdmin {
899         require(_newConversionRate != IConversionRates(0), "conversionRates 0");
900         conversionRatesContract = _newConversionRate;
901         emit SetConversionRateAddress(_newConversionRate);
902     }
903 
904     /// @dev weth is unlikely to be changed, but added this function to keep the flexibilty
905     function setWeth(IWeth _newWeth) external onlyAdmin {
906         require(_newWeth != IWeth(0), "weth 0");
907         weth = _newWeth;
908         emit SetWethAddress(_newWeth);
909     }
910 
911     /// @dev sanity rate can be set to 0x0 address to disable sanity rate check
912     function setSanityRate(IKyberSanity _newSanity) external onlyAdmin {
913         sanityRatesContract = _newSanity;
914         emit SetSanityRateAddress(_newSanity);
915     }
916 
917     function getConversionRate(
918         IERC20 src,
919         IERC20 dest,
920         uint256 srcQty,
921         uint256 blockNumber
922     ) external override view returns (uint256) {
923         ConfigData memory data = configData;
924         if (!data.tradeEnabled) return 0;
925         if (tx.gasprice > uint256(data.maxGasPriceWei)) return 0;
926         if (srcQty == 0) return 0;
927 
928         IERC20 token;
929         bool isBuy;
930 
931         if (ETH_TOKEN_ADDRESS == src) {
932             isBuy = true;
933             token = dest;
934         } else if (ETH_TOKEN_ADDRESS == dest) {
935             isBuy = false;
936             token = src;
937         } else {
938             return 0; // pair is not listed
939         }
940 
941         uint256 rate;
942         try conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty) returns(uint256 r) {
943             rate = r;
944         } catch {
945             return 0;
946         }
947         uint256 destQty = calcDestAmount(src, dest, srcQty, rate);
948 
949         if (getBalance(dest) < destQty) return 0;
950 
951         if (sanityRatesContract != IKyberSanity(0)) {
952             uint256 sanityRate = sanityRatesContract.getSanityRate(src, dest);
953             if (rate > sanityRate) return 0;
954         }
955 
956         return rate;
957     }
958 
959     function isAddressApprovedForWithdrawal(IERC20 token, address addr)
960         external
961         view
962         returns (bool)
963     {
964         return approvedWithdrawAddresses[keccak256(abi.encodePacked(address(token), addr))];
965     }
966 
967     function tradeEnabled() external view returns (bool) {
968         return configData.tradeEnabled;
969     }
970 
971     function maxGasPriceWei() external view returns (uint128) {
972         return configData.maxGasPriceWei;
973     }
974 
975     function doRateValidation() external view returns (bool) {
976         return configData.doRateValidation;
977     }
978 
979     /// @dev return available balance of a token that reserve can use
980     ///      if using weth, call getBalance(eth) will return weth balance
981     ///      if using wallet for token, will return min of balance and allowance
982     /// @param token token to get available balance that reserve can use
983     function getBalance(IERC20 token) public view returns (uint256) {
984         address wallet = getTokenWallet(token);
985         IERC20 usingToken;
986 
987         if (token == ETH_TOKEN_ADDRESS) {
988             if (wallet == address(this)) {
989                 // reserve should be using eth instead of weth
990                 return address(this).balance;
991             }
992             // reserve is using weth instead of eth
993             usingToken = weth;
994         } else {
995             if (wallet == address(this)) {
996                 // not set token wallet or reserve is the token wallet, no need to check allowance
997                 return token.balanceOf(address(this));
998             }
999             usingToken = token;
1000         }
1001 
1002         uint256 balanceOfWallet = usingToken.balanceOf(wallet);
1003         uint256 allowanceOfWallet = usingToken.allowance(wallet, address(this));
1004 
1005         return minOf(balanceOfWallet, allowanceOfWallet);
1006     }
1007 
1008     /// @dev return wallet that holds the token
1009     ///      if token is ETH, check tokenWallet of WETH instead
1010     ///      if wallet is 0x0, consider as this reserve address
1011     function getTokenWallet(IERC20 token) public view returns (address wallet) {
1012         wallet = (token == ETH_TOKEN_ADDRESS)
1013             ? tokenWallet[address(weth)]
1014             : tokenWallet[address(token)];
1015         if (wallet == address(0)) {
1016             wallet = address(this);
1017         }
1018     }
1019 
1020     /// @dev do a trade, re-validate the conversion rate, remove trust assumption with network
1021     /// @param srcToken Src token
1022     /// @param srcAmount Amount of src token
1023     /// @param destToken Destination token
1024     /// @param destAddress Destination address to send tokens to
1025     /// @param validateRate re-validate rate or not
1026     function doTrade(
1027         IERC20 srcToken,
1028         uint256 srcAmount,
1029         IERC20 destToken,
1030         address payable destAddress,
1031         uint256 conversionRate,
1032         bool validateRate
1033     ) internal {
1034         require(conversionRate > 0, "rate is 0");
1035 
1036         bool isBuy = srcToken == ETH_TOKEN_ADDRESS;
1037         if (isBuy) {
1038             require(msg.value == srcAmount, "wrong msg value");
1039         } else {
1040             require(msg.value == 0, "bad msg value");
1041         }
1042 
1043         if (validateRate) {
1044             uint256 rate = conversionRatesContract.getRate(
1045                 isBuy ? destToken : srcToken,
1046                 block.number,
1047                 isBuy,
1048                 srcAmount
1049             );
1050             // re-validate conversion rate
1051             require(rate >= conversionRate, "reserve rate lower then network requested rate");
1052             if (sanityRatesContract != IKyberSanity(0)) {
1053                 // sanity rate check
1054                 uint256 sanityRate = sanityRatesContract.getSanityRate(srcToken, destToken);
1055                 require(rate <= sanityRate, "rate should not be greater than sanity rate" );
1056             }
1057         }
1058 
1059         uint256 destAmount = calcDestAmount(srcToken, destToken, srcAmount, conversionRate);
1060         require(destAmount > 0, "dest amount is 0");
1061 
1062         address srcTokenWallet = getTokenWallet(srcToken);
1063         address destTokenWallet = getTokenWallet(destToken);
1064 
1065         if (isBuy) {
1066             // add to imbalance
1067             conversionRatesContract.recordImbalance(
1068                 destToken,
1069                 int256(destAmount),
1070                 0,
1071                 block.number
1072             );
1073             // if reserve is using weth, convert eth to weth and transfer weth to its' tokenWallet
1074             if (srcTokenWallet != address(this)) {
1075                 weth.deposit{value: msg.value}();
1076                 IERC20(weth).safeTransfer(srcTokenWallet, msg.value);
1077             }
1078             // transfer dest token from tokenWallet to destAddress
1079             if (destTokenWallet == address(this)) {
1080                 destToken.safeTransfer(destAddress, destAmount);
1081             } else {
1082                 destToken.safeTransferFrom(destTokenWallet, destAddress, destAmount);
1083             }
1084         } else {
1085             // add to imbalance
1086             conversionRatesContract.recordImbalance(
1087                 srcToken,
1088                 -1 * int256(srcAmount),
1089                 0,
1090                 block.number
1091             );
1092             // collect src token from sender
1093             srcToken.safeTransferFrom(msg.sender, srcTokenWallet, srcAmount);
1094             // if reserve is using weth, reserve needs to collect weth from tokenWallet,
1095             // then convert it to eth
1096             if (destTokenWallet != address(this)) {
1097                 IERC20(weth).safeTransferFrom(destTokenWallet, address(this), destAmount);
1098                 weth.withdraw(destAmount);
1099             }
1100             // transfer eth to destAddress
1101             (bool success, ) = destAddress.call{value: destAmount}("");
1102             require(success, "transfer eth from reserve to destAddress failed");
1103         }
1104 
1105         emit TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
1106     }
1107 }