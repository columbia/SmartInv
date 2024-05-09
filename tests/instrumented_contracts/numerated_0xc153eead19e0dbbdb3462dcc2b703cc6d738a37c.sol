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
34 // File: contracts/sol6/utils/PermissionGroupsNoModifiers.sol
35 
36 pragma solidity 0.6.6;
37 
38 
39 contract PermissionGroupsNoModifiers {
40     address public admin;
41     address public pendingAdmin;
42     mapping(address => bool) internal operators;
43     mapping(address => bool) internal alerters;
44     address[] internal operatorsGroup;
45     address[] internal alertersGroup;
46     uint256 internal constant MAX_GROUP_SIZE = 50;
47 
48     event AdminClaimed(address newAdmin, address previousAdmin);
49     event AlerterAdded(address newAlerter, bool isAdd);
50     event OperatorAdded(address newOperator, bool isAdd);
51     event TransferAdminPending(address pendingAdmin);
52 
53     constructor(address _admin) public {
54         require(_admin != address(0), "admin 0");
55         admin = _admin;
56     }
57 
58     function getOperators() external view returns (address[] memory) {
59         return operatorsGroup;
60     }
61 
62     function getAlerters() external view returns (address[] memory) {
63         return alertersGroup;
64     }
65 
66     function addAlerter(address newAlerter) public {
67         onlyAdmin();
68         require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
69         require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");
70 
71         emit AlerterAdded(newAlerter, true);
72         alerters[newAlerter] = true;
73         alertersGroup.push(newAlerter);
74     }
75 
76     function addOperator(address newOperator) public {
77         onlyAdmin();
78         require(!operators[newOperator], "operator exists"); // prevent duplicates.
79         require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");
80 
81         emit OperatorAdded(newOperator, true);
82         operators[newOperator] = true;
83         operatorsGroup.push(newOperator);
84     }
85 
86     /// @dev Allows the pendingAdmin address to finalize the change admin process.
87     function claimAdmin() public {
88         require(pendingAdmin == msg.sender, "not pending");
89         emit AdminClaimed(pendingAdmin, admin);
90         admin = pendingAdmin;
91         pendingAdmin = address(0);
92     }
93 
94     function removeAlerter(address alerter) public {
95         onlyAdmin();
96         require(alerters[alerter], "not alerter");
97         delete alerters[alerter];
98 
99         for (uint256 i = 0; i < alertersGroup.length; ++i) {
100             if (alertersGroup[i] == alerter) {
101                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
102                 alertersGroup.pop();
103                 emit AlerterAdded(alerter, false);
104                 break;
105             }
106         }
107     }
108 
109     function removeOperator(address operator) public {
110         onlyAdmin();
111         require(operators[operator], "not operator");
112         delete operators[operator];
113 
114         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
115             if (operatorsGroup[i] == operator) {
116                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
117                 operatorsGroup.pop();
118                 emit OperatorAdded(operator, false);
119                 break;
120             }
121         }
122     }
123 
124     /// @dev Allows the current admin to set the pendingAdmin address
125     /// @param newAdmin The address to transfer ownership to
126     function transferAdmin(address newAdmin) public {
127         onlyAdmin();
128         require(newAdmin != address(0), "new admin 0");
129         emit TransferAdminPending(newAdmin);
130         pendingAdmin = newAdmin;
131     }
132 
133     /// @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
134     /// @param newAdmin The address to transfer ownership to.
135     function transferAdminQuickly(address newAdmin) public {
136         onlyAdmin();
137         require(newAdmin != address(0), "admin 0");
138         emit TransferAdminPending(newAdmin);
139         emit AdminClaimed(newAdmin, admin);
140         admin = newAdmin;
141     }
142 
143     function onlyAdmin() internal view {
144         require(msg.sender == admin, "only admin");
145     }
146 
147     function onlyAlerter() internal view {
148         require(alerters[msg.sender], "only alerter");
149     }
150 
151     function onlyOperator() internal view {
152         require(operators[msg.sender], "only operator");
153     }
154 }
155 
156 // File: contracts/sol6/utils/WithdrawableNoModifiers.sol
157 
158 pragma solidity 0.6.6;
159 
160 
161 
162 
163 contract WithdrawableNoModifiers is PermissionGroupsNoModifiers {
164     constructor(address _admin) public PermissionGroupsNoModifiers(_admin) {}
165 
166     event EtherWithdraw(uint256 amount, address sendTo);
167     event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);
168 
169     /// @dev Withdraw Ethers
170     function withdrawEther(uint256 amount, address payable sendTo) external {
171         onlyAdmin();
172         (bool success, ) = sendTo.call{value: amount}("");
173         require(success);
174         emit EtherWithdraw(amount, sendTo);
175     }
176 
177     /// @dev Withdraw all IERC20 compatible tokens
178     /// @param token IERC20 The address of the token contract
179     function withdrawToken(
180         IERC20 token,
181         uint256 amount,
182         address sendTo
183     ) external {
184         onlyAdmin();
185         token.transfer(sendTo, amount);
186         emit TokenWithdraw(token, amount, sendTo);
187     }
188 }
189 
190 // File: contracts/sol6/utils/Utils5.sol
191 
192 pragma solidity 0.6.6;
193 
194 
195 
196 /**
197  * @title Kyber utility file
198  * mostly shared constants and rate calculation helpers
199  * inherited by most of kyber contracts.
200  * previous utils implementations are for previous solidity versions.
201  */
202 contract Utils5 {
203     IERC20 internal constant ETH_TOKEN_ADDRESS = IERC20(
204         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
205     );
206     uint256 internal constant PRECISION = (10**18);
207     uint256 internal constant MAX_QTY = (10**28); // 10B tokens
208     uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
209     uint256 internal constant MAX_DECIMALS = 18;
210     uint256 internal constant ETH_DECIMALS = 18;
211     uint256 constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
212     uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite
213 
214     mapping(IERC20 => uint256) internal decimals;
215 
216     function getUpdateDecimals(IERC20 token) internal returns (uint256) {
217         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
218         uint256 tokenDecimals = decimals[token];
219         // moreover, very possible that old tokens have decimals 0
220         // these tokens will just have higher gas fees.
221         if (tokenDecimals == 0) {
222             tokenDecimals = token.decimals();
223             decimals[token] = tokenDecimals;
224         }
225 
226         return tokenDecimals;
227     }
228 
229     function setDecimals(IERC20 token) internal {
230         if (decimals[token] != 0) return; //already set
231 
232         if (token == ETH_TOKEN_ADDRESS) {
233             decimals[token] = ETH_DECIMALS;
234         } else {
235             decimals[token] = token.decimals();
236         }
237     }
238 
239     /// @dev get the balance of a user.
240     /// @param token The token type
241     /// @return The balance
242     function getBalance(IERC20 token, address user) internal view returns (uint256) {
243         if (token == ETH_TOKEN_ADDRESS) {
244             return user.balance;
245         } else {
246             return token.balanceOf(user);
247         }
248     }
249 
250     function getDecimals(IERC20 token) internal view returns (uint256) {
251         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
252         uint256 tokenDecimals = decimals[token];
253         // moreover, very possible that old tokens have decimals 0
254         // these tokens will just have higher gas fees.
255         if (tokenDecimals == 0) return token.decimals();
256 
257         return tokenDecimals;
258     }
259 
260     function calcDestAmount(
261         IERC20 src,
262         IERC20 dest,
263         uint256 srcAmount,
264         uint256 rate
265     ) internal view returns (uint256) {
266         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
267     }
268 
269     function calcSrcAmount(
270         IERC20 src,
271         IERC20 dest,
272         uint256 destAmount,
273         uint256 rate
274     ) internal view returns (uint256) {
275         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
276     }
277 
278     function calcDstQty(
279         uint256 srcQty,
280         uint256 srcDecimals,
281         uint256 dstDecimals,
282         uint256 rate
283     ) internal pure returns (uint256) {
284         require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
285         require(rate <= MAX_RATE, "rate > MAX_RATE");
286 
287         if (dstDecimals >= srcDecimals) {
288             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
289             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
290         } else {
291             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
292             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
293         }
294     }
295 
296     function calcSrcQty(
297         uint256 dstQty,
298         uint256 srcDecimals,
299         uint256 dstDecimals,
300         uint256 rate
301     ) internal pure returns (uint256) {
302         require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
303         require(rate <= MAX_RATE, "rate > MAX_RATE");
304 
305         //source quantity is rounded up. to avoid dest quantity being too low.
306         uint256 numerator;
307         uint256 denominator;
308         if (srcDecimals >= dstDecimals) {
309             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
310             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
311             denominator = rate;
312         } else {
313             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
314             numerator = (PRECISION * dstQty);
315             denominator = (rate * (10**(dstDecimals - srcDecimals)));
316         }
317         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
318     }
319 
320     function calcRateFromQty(
321         uint256 srcAmount,
322         uint256 destAmount,
323         uint256 srcDecimals,
324         uint256 dstDecimals
325     ) internal pure returns (uint256) {
326         require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
327         require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");
328 
329         if (dstDecimals >= srcDecimals) {
330             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
331             return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
332         } else {
333             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
334             return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
335         }
336     }
337 
338     function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
339         return x > y ? y : x;
340     }
341 }
342 
343 // File: contracts/sol6/utils/zeppelin/SafeMath.sol
344 
345 pragma solidity 0.6.6;
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
362      * @dev Returns the addition of two unsigned integers, reverting on
363      * overflow.
364      *
365      * Counterpart to Solidity's `+` operator.
366      *
367      * Requirements:
368      * - Addition cannot overflow.
369      */
370     function add(uint256 a, uint256 b) internal pure returns (uint256) {
371         uint256 c = a + b;
372         require(c >= a, "SafeMath: addition overflow");
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the subtraction of two unsigned integers, reverting on
379      * overflow (when the result is negative).
380      *
381      * Counterpart to Solidity's `-` operator.
382      *
383      * Requirements:
384      * - Subtraction cannot overflow.
385      */
386     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387         return sub(a, b, "SafeMath: subtraction overflow");
388     }
389 
390     /**
391      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
392      * overflow (when the result is negative).
393      *
394      * Counterpart to Solidity's `-` operator.
395      *
396      * Requirements:
397      * - Subtraction cannot overflow.
398      */
399     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
400         require(b <= a, errorMessage);
401         uint256 c = a - b;
402 
403         return c;
404     }
405 
406     /**
407      * @dev Returns the multiplication of two unsigned integers, reverting on
408      * overflow.
409      *
410      * Counterpart to Solidity's `*` operator.
411      *
412      * Requirements:
413      * - Multiplication cannot overflow.
414      */
415     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
416         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
417         // benefit is lost if 'b' is also tested.
418         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
419         if (a == 0) {
420             return 0;
421         }
422 
423         uint256 c = a * b;
424         require(c / a == b, "SafeMath: multiplication overflow");
425 
426         return c;
427     }
428 
429     /**
430      * @dev Returns the integer division of two unsigned integers. Reverts on
431      * division by zero. The result is rounded towards zero.
432      *
433      * Counterpart to Solidity's `/` operator. Note: this function uses a
434      * `revert` opcode (which leaves remaining gas untouched) while Solidity
435      * uses an invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      * - The divisor cannot be zero.
439      */
440     function div(uint256 a, uint256 b) internal pure returns (uint256) {
441         return div(a, b, "SafeMath: division by zero");
442     }
443 
444     /**
445      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
446      * division by zero. The result is rounded towards zero.
447      *
448      * Counterpart to Solidity's `/` operator. Note: this function uses a
449      * `revert` opcode (which leaves remaining gas untouched) while Solidity
450      * uses an invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      * - The divisor cannot be zero.
454      */
455     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
456         // Solidity only automatically asserts when dividing by 0
457         require(b > 0, errorMessage);
458         uint256 c = a / b;
459         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
460 
461         return c;
462     }
463 
464     /**
465      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
466      * Reverts when dividing by zero.
467      *
468      * Counterpart to Solidity's `%` operator. This function uses a `revert`
469      * opcode (which leaves remaining gas untouched) while Solidity uses an
470      * invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      * - The divisor cannot be zero.
474      */
475     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
476         return mod(a, b, "SafeMath: modulo by zero");
477     }
478 
479     /**
480      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
481      * Reverts with custom message when dividing by zero.
482      *
483      * Counterpart to Solidity's `%` operator. This function uses a `revert`
484      * opcode (which leaves remaining gas untouched) while Solidity uses an
485      * invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      * - The divisor cannot be zero.
489      */
490     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
491         require(b != 0, errorMessage);
492         return a % b;
493     }
494 
495     /**
496      * @dev Returns the smallest of two numbers.
497      */
498     function min(uint256 a, uint256 b) internal pure returns (uint256) {
499         return a < b ? a : b;
500     }
501 }
502 
503 // File: contracts/sol6/utils/zeppelin/Address.sol
504 
505 pragma solidity 0.6.6;
506 
507 /**
508  * @dev Collection of functions related to the address type
509  */
510 library Address {
511     /**
512      * @dev Returns true if `account` is a contract.
513      *
514      * [IMPORTANT]
515      * ====
516      * It is unsafe to assume that an address for which this function returns
517      * false is an externally-owned account (EOA) and not a contract.
518      *
519      * Among others, `isContract` will return false for the following
520      * types of addresses:
521      *
522      *  - an externally-owned account
523      *  - a contract in construction
524      *  - an address where a contract will be created
525      *  - an address where a contract lived, but was destroyed
526      * ====
527      */
528     function isContract(address account) internal view returns (bool) {
529         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
530         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
531         // for accounts without code, i.e. `keccak256('')`
532         bytes32 codehash;
533         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
534         // solhint-disable-next-line no-inline-assembly
535         assembly { codehash := extcodehash(account) }
536         return (codehash != accountHash && codehash != 0x0);
537     }
538 
539     /**
540      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
541      * `recipient`, forwarding all available gas and reverting on errors.
542      *
543      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
544      * of certain opcodes, possibly making contracts go over the 2300 gas limit
545      * imposed by `transfer`, making them unable to receive funds via
546      * `transfer`. {sendValue} removes this limitation.
547      *
548      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
549      *
550      * IMPORTANT: because control is transferred to `recipient`, care must be
551      * taken to not create reentrancy vulnerabilities. Consider using
552      * {ReentrancyGuard} or the
553      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
554      */
555     function sendValue(address payable recipient, uint256 amount) internal {
556         require(address(this).balance >= amount, "Address: insufficient balance");
557 
558         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
559         (bool success, ) = recipient.call{ value: amount }("");
560         require(success, "Address: unable to send value, recipient may have reverted");
561     }
562 }
563 
564 // File: contracts/sol6/utils/zeppelin/SafeERC20.sol
565 
566 pragma solidity 0.6.6;
567 
568 
569 
570 
571 /**
572  * @title SafeERC20
573  * @dev Wrappers around ERC20 operations that throw on failure (when the token
574  * contract returns false). Tokens that return no value (and instead revert or
575  * throw on failure) are also supported, non-reverting calls are assumed to be
576  * successful.
577  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
578  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
579  */
580 library SafeERC20 {
581     using SafeMath for uint256;
582     using Address for address;
583 
584     function safeTransfer(IERC20 token, address to, uint256 value) internal {
585         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
586     }
587 
588     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
589         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
590     }
591 
592     function safeApprove(IERC20 token, address spender, uint256 value) internal {
593         // safeApprove should only be called when setting an initial allowance,
594         // or when resetting it to zero. To increase and decrease it, use
595         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
596         // solhint-disable-next-line max-line-length
597         require((value == 0) || (token.allowance(address(this), spender) == 0),
598             "SafeERC20: approve from non-zero to non-zero allowance"
599         );
600         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
601     }
602 
603     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
604         uint256 newAllowance = token.allowance(address(this), spender).add(value);
605         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
606     }
607 
608     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
609         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
610         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
611     }
612 
613     /**
614      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
615      * on the return value: the return value is optional (but if data is returned, it must not be false).
616      * @param token The token targeted by the call.
617      * @param data The call data (encoded using abi.encode or one of its variants).
618      */
619     function _callOptionalReturn(IERC20 token, bytes memory data) private {
620         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
621         // we're implementing it ourselves.
622 
623         // A Solidity high level call has three parts:
624         //  1. The target address is checked to verify it contains contract code
625         //  2. The call itself is made, and success asserted
626         //  3. The return value is decoded, which in turn checks the size of the returned data.
627         // solhint-disable-next-line max-line-length
628         require(address(token).isContract(), "SafeERC20: call to non-contract");
629 
630         // solhint-disable-next-line avoid-low-level-calls
631         (bool success, bytes memory returndata) = address(token).call(data);
632         require(success, "SafeERC20: low-level call failed");
633 
634         if (returndata.length > 0) { // Return data is optional
635             // solhint-disable-next-line max-line-length
636             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
637         }
638     }
639 }
640 
641 // File: contracts/sol6/IKyberNetwork.sol
642 
643 pragma solidity 0.6.6;
644 
645 
646 
647 interface IKyberNetwork {
648     event KyberTrade(
649         IERC20 indexed src,
650         IERC20 indexed dest,
651         uint256 ethWeiValue,
652         uint256 networkFeeWei,
653         uint256 customPlatformFeeWei,
654         bytes32[] t2eIds,
655         bytes32[] e2tIds,
656         uint256[] t2eSrcAmounts,
657         uint256[] e2tSrcAmounts,
658         uint256[] t2eRates,
659         uint256[] e2tRates
660     );
661 
662     function tradeWithHintAndFee(
663         address payable trader,
664         IERC20 src,
665         uint256 srcAmount,
666         IERC20 dest,
667         address payable destAddress,
668         uint256 maxDestAmount,
669         uint256 minConversionRate,
670         address payable platformWallet,
671         uint256 platformFeeBps,
672         bytes calldata hint
673     ) external payable returns (uint256 destAmount);
674 
675     function listTokenForReserve(
676         address reserve,
677         IERC20 token,
678         bool add
679     ) external;
680 
681     function enabled() external view returns (bool);
682 
683     function getExpectedRateWithHintAndFee(
684         IERC20 src,
685         IERC20 dest,
686         uint256 srcQty,
687         uint256 platformFeeBps,
688         bytes calldata hint
689     )
690         external
691         view
692         returns (
693             uint256 expectedRateAfterNetworkFee,
694             uint256 expectedRateAfterAllFees
695         );
696 
697     function getNetworkData()
698         external
699         view
700         returns (
701             uint256 negligibleDiffBps,
702             uint256 networkFeeBps,
703             uint256 expiryTimestamp
704         );
705 
706     function maxGasPrice() external view returns (uint256);
707 }
708 
709 // File: contracts/sol6/IKyberNetworkProxy.sol
710 
711 pragma solidity 0.6.6;
712 
713 
714 
715 interface IKyberNetworkProxy {
716 
717     event ExecuteTrade(
718         address indexed trader,
719         IERC20 src,
720         IERC20 dest,
721         address destAddress,
722         uint256 actualSrcAmount,
723         uint256 actualDestAmount,
724         address platformWallet,
725         uint256 platformFeeBps
726     );
727 
728     /// @notice backward compatible
729     function tradeWithHint(
730         ERC20 src,
731         uint256 srcAmount,
732         ERC20 dest,
733         address payable destAddress,
734         uint256 maxDestAmount,
735         uint256 minConversionRate,
736         address payable walletId,
737         bytes calldata hint
738     ) external payable returns (uint256);
739 
740     function tradeWithHintAndFee(
741         IERC20 src,
742         uint256 srcAmount,
743         IERC20 dest,
744         address payable destAddress,
745         uint256 maxDestAmount,
746         uint256 minConversionRate,
747         address payable platformWallet,
748         uint256 platformFeeBps,
749         bytes calldata hint
750     ) external payable returns (uint256 destAmount);
751 
752     function trade(
753         IERC20 src,
754         uint256 srcAmount,
755         IERC20 dest,
756         address payable destAddress,
757         uint256 maxDestAmount,
758         uint256 minConversionRate,
759         address payable platformWallet
760     ) external payable returns (uint256);
761 
762     /// @notice backward compatible
763     /// @notice Rate units (10 ** 18) => destQty (twei) / srcQty (twei) * 10 ** 18
764     function getExpectedRate(
765         ERC20 src,
766         ERC20 dest,
767         uint256 srcQty
768     ) external view returns (uint256 expectedRate, uint256 worstRate);
769 
770     function getExpectedRateAfterFee(
771         IERC20 src,
772         IERC20 dest,
773         uint256 srcQty,
774         uint256 platformFeeBps,
775         bytes calldata hint
776     ) external view returns (uint256 expectedRate);
777 }
778 
779 // File: contracts/sol6/ISimpleKyberProxy.sol
780 
781 pragma solidity 0.6.6;
782 
783 
784 
785 /*
786  * @title simple Kyber Network proxy interface
787  * add convenient functions to help with kyber proxy API
788  */
789 interface ISimpleKyberProxy {
790     function swapTokenToEther(
791         IERC20 token,
792         uint256 srcAmount,
793         uint256 minConversionRate
794     ) external returns (uint256 destAmount);
795 
796     function swapEtherToToken(IERC20 token, uint256 minConversionRate)
797         external
798         payable
799         returns (uint256 destAmount);
800 
801     function swapTokenToToken(
802         IERC20 src,
803         uint256 srcAmount,
804         IERC20 dest,
805         uint256 minConversionRate
806     ) external returns (uint256 destAmount);
807 }
808 
809 // File: contracts/sol6/IKyberReserve.sol
810 
811 pragma solidity 0.6.6;
812 
813 
814 
815 interface IKyberReserve {
816     function trade(
817         IERC20 srcToken,
818         uint256 srcAmount,
819         IERC20 destToken,
820         address payable destAddress,
821         uint256 conversionRate,
822         bool validate
823     ) external payable returns (bool);
824 
825     function getConversionRate(
826         IERC20 src,
827         IERC20 dest,
828         uint256 srcQty,
829         uint256 blockNumber
830     ) external view returns (uint256);
831 }
832 
833 // File: contracts/sol6/IKyberHint.sol
834 
835 pragma solidity 0.6.6;
836 
837 
838 
839 interface IKyberHint {
840     enum TradeType {BestOfAll, MaskIn, MaskOut, Split}
841     enum HintErrors {
842         NoError, // Hint is valid
843         NonEmptyDataError, // reserveIDs and splits must be empty for BestOfAll hint
844         ReserveIdDupError, // duplicate reserveID found
845         ReserveIdEmptyError, // reserveIDs array is empty for MaskIn and Split trade type
846         ReserveIdSplitsError, // reserveIDs and splitBpsValues arrays do not have the same length
847         ReserveIdSequenceError, // reserveID sequence in array is not in increasing order
848         ReserveIdNotFound, // reserveID isn't registered or doesn't exist
849         SplitsNotEmptyError, // splitBpsValues is not empty for MaskIn or MaskOut trade type
850         TokenListedError, // reserveID not listed for the token
851         TotalBPSError // total BPS for Split trade type is not 10000 (100%)
852     }
853 
854     function buildTokenToEthHint(
855         IERC20 tokenSrc,
856         TradeType tokenToEthType,
857         bytes32[] calldata tokenToEthReserveIds,
858         uint256[] calldata tokenToEthSplits
859     ) external view returns (bytes memory hint);
860 
861     function buildEthToTokenHint(
862         IERC20 tokenDest,
863         TradeType ethToTokenType,
864         bytes32[] calldata ethToTokenReserveIds,
865         uint256[] calldata ethToTokenSplits
866     ) external view returns (bytes memory hint);
867 
868     function buildTokenToTokenHint(
869         IERC20 tokenSrc,
870         TradeType tokenToEthType,
871         bytes32[] calldata tokenToEthReserveIds,
872         uint256[] calldata tokenToEthSplits,
873         IERC20 tokenDest,
874         TradeType ethToTokenType,
875         bytes32[] calldata ethToTokenReserveIds,
876         uint256[] calldata ethToTokenSplits
877     ) external view returns (bytes memory hint);
878 
879     function parseTokenToEthHint(IERC20 tokenSrc, bytes calldata hint)
880         external
881         view
882         returns (
883             TradeType tokenToEthType,
884             bytes32[] memory tokenToEthReserveIds,
885             IKyberReserve[] memory tokenToEthAddresses,
886             uint256[] memory tokenToEthSplits
887         );
888 
889     function parseEthToTokenHint(IERC20 tokenDest, bytes calldata hint)
890         external
891         view
892         returns (
893             TradeType ethToTokenType,
894             bytes32[] memory ethToTokenReserveIds,
895             IKyberReserve[] memory ethToTokenAddresses,
896             uint256[] memory ethToTokenSplits
897         );
898 
899     function parseTokenToTokenHint(IERC20 tokenSrc, IERC20 tokenDest, bytes calldata hint)
900         external
901         view
902         returns (
903             TradeType tokenToEthType,
904             bytes32[] memory tokenToEthReserveIds,
905             IKyberReserve[] memory tokenToEthAddresses,
906             uint256[] memory tokenToEthSplits,
907             TradeType ethToTokenType,
908             bytes32[] memory ethToTokenReserveIds,
909             IKyberReserve[] memory ethToTokenAddresses,
910             uint256[] memory ethToTokenSplits
911         );
912 }
913 
914 // File: contracts/sol6/KyberNetworkProxy.sol
915 
916 pragma solidity 0.6.6;
917 
918 
919 
920 
921 
922 
923 
924 
925 
926 /**
927  *   @title kyberProxy for kyberNetwork contract
928  *   The contract provides the following functions:
929  *   - Get rates
930  *   - Trade execution
931  *   - Simple T2E, E2T and T2T trade APIs
932  *   - Has some checks in place to safeguard takers
933  */
934 contract KyberNetworkProxy is
935     IKyberNetworkProxy,
936     ISimpleKyberProxy,
937     WithdrawableNoModifiers,
938     Utils5
939 {
940     using SafeERC20 for IERC20;
941 
942     IKyberNetwork public kyberNetwork;
943     IKyberHint public kyberHintHandler; // kyberHintHhandler pointer for users.
944 
945     event KyberNetworkSet(IKyberNetwork newKyberNetwork, IKyberNetwork previousKyberNetwork);
946     event KyberHintHandlerSet(IKyberHint kyberHintHandler);
947 
948     constructor(address _admin) public WithdrawableNoModifiers(_admin) {
949         /*empty body*/
950     }
951 
952     /// @notice Backward compatible function
953     /// @notice Use token address ETH_TOKEN_ADDRESS for ether
954     /// @dev Trade from src to dest token and sends dest token to destAddress
955     /// @param src Source token
956     /// @param srcAmount Amount of src tokens in twei
957     /// @param dest Destination token
958     /// @param destAddress Address to send tokens to
959     /// @param maxDestAmount A limit on the amount of dest tokens in twei
960     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
961     /// @param platformWallet Platform wallet address for receiving fees
962     /// @return Amount of actual dest tokens in twei
963     function trade(
964         IERC20 src,
965         uint256 srcAmount,
966         IERC20 dest,
967         address payable destAddress,
968         uint256 maxDestAmount,
969         uint256 minConversionRate,
970         address payable platformWallet
971     ) external payable override returns (uint256) {
972         bytes memory hint;
973 
974         return
975             doTrade(
976                 src,
977                 srcAmount,
978                 dest,
979                 destAddress,
980                 maxDestAmount,
981                 minConversionRate,
982                 platformWallet,
983                 0,
984                 hint
985             );
986     }
987 
988     /// @notice Backward compatible function
989     /// @notice Use token address ETH_TOKEN_ADDRESS for ether
990     /// @dev Trade from src to dest token and sends dest token to destAddress
991     /// @param src Source token
992     /// @param srcAmount Amount of src tokens in twei
993     /// @param dest Destination token
994     /// @param destAddress Address to send tokens to
995     /// @param maxDestAmount A limit on the amount of dest tokens in twei
996     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
997     /// @param walletId Platform wallet address for receiving fees
998     /// @param hint Advanced instructions for running the trade 
999     /// @return Amount of actual dest tokens in twei
1000     function tradeWithHint(
1001         ERC20 src,
1002         uint256 srcAmount,
1003         ERC20 dest,
1004         address payable destAddress,
1005         uint256 maxDestAmount,
1006         uint256 minConversionRate,
1007         address payable walletId,
1008         bytes calldata hint
1009     ) external payable override returns (uint256) {
1010         return
1011             doTrade(
1012                 src,
1013                 srcAmount,
1014                 dest,
1015                 destAddress,
1016                 maxDestAmount,
1017                 minConversionRate,
1018                 walletId,
1019                 0,
1020                 hint
1021             );
1022     }
1023 
1024     /// @notice Use token address ETH_TOKEN_ADDRESS for ether
1025     /// @dev Trade from src to dest token and sends dest token to destAddress
1026     /// @param src Source token
1027     /// @param srcAmount Amount of src tokens in twei
1028     /// @param dest Destination token
1029     /// @param destAddress Address to send tokens to
1030     /// @param maxDestAmount A limit on the amount of dest tokens in twei
1031     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
1032     /// @param platformWallet Platform wallet address for receiving fees
1033     /// @param platformFeeBps Part of the trade that is allocated as fee to platform wallet. Ex: 10000 = 100%, 100 = 1%
1034     /// @param hint Advanced instructions for running the trade 
1035     /// @return destAmount Amount of actual dest tokens in twei
1036     function tradeWithHintAndFee(
1037         IERC20 src,
1038         uint256 srcAmount,
1039         IERC20 dest,
1040         address payable destAddress,
1041         uint256 maxDestAmount,
1042         uint256 minConversionRate,
1043         address payable platformWallet,
1044         uint256 platformFeeBps,
1045         bytes calldata hint
1046     ) external payable override returns (uint256 destAmount) {
1047         return
1048             doTrade(
1049                 src,
1050                 srcAmount,
1051                 dest,
1052                 destAddress,
1053                 maxDestAmount,
1054                 minConversionRate,
1055                 platformWallet,
1056                 platformFeeBps,
1057                 hint
1058             );
1059     }
1060 
1061     /// @dev Trade from src to dest token. Sends dest tokens to msg sender
1062     /// @param src Source token
1063     /// @param srcAmount Amount of src tokens in twei
1064     /// @param dest Destination token
1065     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
1066     /// @return Amount of actual dest tokens in twei
1067     function swapTokenToToken(
1068         IERC20 src,
1069         uint256 srcAmount,
1070         IERC20 dest,
1071         uint256 minConversionRate
1072     ) external override returns (uint256) {
1073         bytes memory hint;
1074 
1075         return
1076             doTrade(
1077                 src,
1078                 srcAmount,
1079                 dest,
1080                 msg.sender,
1081                 MAX_QTY,
1082                 minConversionRate,
1083                 address(0),
1084                 0,
1085                 hint
1086             );
1087     }
1088 
1089     /// @dev Trade from eth -> token. Sends token to msg sender
1090     /// @param token Destination token
1091     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
1092     /// @return Amount of actual dest tokens in twei
1093     function swapEtherToToken(IERC20 token, uint256 minConversionRate)
1094         external
1095         payable
1096         override
1097         returns (uint256)
1098     {
1099         bytes memory hint;
1100 
1101         return
1102             doTrade(
1103                 ETH_TOKEN_ADDRESS,
1104                 msg.value,
1105                 token,
1106                 msg.sender,
1107                 MAX_QTY,
1108                 minConversionRate,
1109                 address(0),
1110                 0,
1111                 hint
1112             );
1113     }
1114 
1115     /// @dev Trade from token -> eth. Sends eth to msg sender
1116     /// @param token Source token
1117     /// @param srcAmount Amount of src tokens in twei
1118     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade reverts
1119     /// @return Amount of actual dest tokens in twei
1120     function swapTokenToEther(
1121         IERC20 token,
1122         uint256 srcAmount,
1123         uint256 minConversionRate
1124     ) external override returns (uint256) {
1125         bytes memory hint;
1126 
1127         return
1128             doTrade(
1129                 token,
1130                 srcAmount,
1131                 ETH_TOKEN_ADDRESS,
1132                 msg.sender,
1133                 MAX_QTY,
1134                 minConversionRate,
1135                 address(0),
1136                 0,
1137                 hint
1138             );
1139     }
1140 
1141     function setKyberNetwork(IKyberNetwork _kyberNetwork) external {
1142         onlyAdmin();
1143         require(_kyberNetwork != IKyberNetwork(0), "kyberNetwork 0");
1144         emit KyberNetworkSet(_kyberNetwork, kyberNetwork);
1145 
1146         kyberNetwork = _kyberNetwork;
1147     }
1148 
1149     function setHintHandler(IKyberHint _kyberHintHandler) external {
1150         onlyAdmin();
1151         require(_kyberHintHandler != IKyberHint(0), "kyberHintHandler 0");
1152         emit KyberHintHandlerSet(_kyberHintHandler);
1153 
1154         kyberHintHandler = _kyberHintHandler;
1155     }
1156 
1157     /// @notice Backward compatible function
1158     /// @notice Use token address ETH_TOKEN_ADDRESS for ether
1159     /// @dev Get expected rate for a trade from src to dest tokens, with amount srcQty (no platform fee)
1160     /// @param src Source token
1161     /// @param dest Destination token
1162     /// @param srcQty Amount of src tokens in twei
1163     /// @return expectedRate for a trade after deducting network fee. Rate = destQty (twei) / srcQty (twei) * 10 ** 18
1164     /// @return worstRate for a trade. Usually expectedRate * 97 / 100
1165     ///             Use worstRate value as trade min conversion rate at your own risk
1166     function getExpectedRate(
1167         ERC20 src,
1168         ERC20 dest,
1169         uint256 srcQty
1170     ) external view override returns (uint256 expectedRate, uint256 worstRate) {
1171         bytes memory hint;
1172         (expectedRate, ) = kyberNetwork.getExpectedRateWithHintAndFee(
1173             src,
1174             dest,
1175             srcQty,
1176             0,
1177             hint
1178         );
1179         // use simple backward compatible optoin.
1180         worstRate = (expectedRate * 97) / 100;
1181     }
1182 
1183     /// @notice Use token address ETH_TOKEN_ADDRESS for ether
1184     /// @dev Get expected rate for a trade from src to dest tokens, amount srcQty and fees
1185     /// @param src Source token
1186     /// @param dest Destination token
1187     /// @param srcQty Amount of src tokens in twei
1188     /// @param platformFeeBps Part of the trade that is allocated as fee to platform wallet. Ex: 10000 = 100%, 100 = 1%
1189     /// @param hint Advanced instructions for running the trade 
1190     /// @return expectedRate for a trade after deducting network + platform fee
1191     ///             Rate = destQty (twei) / srcQty (twei) * 10 ** 18
1192     function getExpectedRateAfterFee(
1193         IERC20 src,
1194         IERC20 dest,
1195         uint256 srcQty,
1196         uint256 platformFeeBps,
1197         bytes calldata hint
1198     ) external view override returns (uint256 expectedRate) {
1199         (, expectedRate) = kyberNetwork.getExpectedRateWithHintAndFee(
1200             src,
1201             dest,
1202             srcQty,
1203             platformFeeBps,
1204             hint
1205         );
1206     }
1207 
1208     function maxGasPrice() external view returns (uint256) {
1209         return kyberNetwork.maxGasPrice();
1210     }
1211 
1212     function enabled() external view returns (bool) {
1213         return kyberNetwork.enabled();
1214     }
1215 
1216     /// helper structure for function doTrade
1217     struct UserBalance {
1218         uint256 srcTok;
1219         uint256 destTok;
1220     }
1221 
1222     function doTrade(
1223         IERC20 src,
1224         uint256 srcAmount,
1225         IERC20 dest,
1226         address payable destAddress,
1227         uint256 maxDestAmount,
1228         uint256 minConversionRate,
1229         address payable platformWallet,
1230         uint256 platformFeeBps,
1231         bytes memory hint
1232     ) internal returns (uint256) {
1233         UserBalance memory balanceBefore = prepareTrade(src, dest, srcAmount, destAddress);
1234 
1235         uint256 reportedDestAmount = kyberNetwork.tradeWithHintAndFee{value: msg.value}(
1236             msg.sender,
1237             src,
1238             srcAmount,
1239             dest,
1240             destAddress,
1241             maxDestAmount,
1242             minConversionRate,
1243             platformWallet,
1244             platformFeeBps,
1245             hint
1246         );
1247         TradeOutcome memory tradeOutcome = calculateTradeOutcome(
1248             src,
1249             dest,
1250             destAddress,
1251             platformFeeBps,
1252             balanceBefore
1253         );
1254 
1255         require(
1256             tradeOutcome.userDeltaDestToken == reportedDestAmount,
1257             "kyberNetwork returned wrong amount"
1258         );
1259         require(
1260             tradeOutcome.userDeltaDestToken <= maxDestAmount,
1261             "actual dest amount exceeds maxDestAmount"
1262         );
1263         require(tradeOutcome.actualRate >= minConversionRate, "rate below minConversionRate");
1264 
1265         emit ExecuteTrade(
1266             msg.sender,
1267             src,
1268             dest,
1269             destAddress,
1270             tradeOutcome.userDeltaSrcToken,
1271             tradeOutcome.userDeltaDestToken,
1272             platformWallet,
1273             platformFeeBps
1274         );
1275 
1276         return tradeOutcome.userDeltaDestToken;
1277     }
1278 
1279     /// helper structure for function prepareTrade
1280     struct TradeOutcome {
1281         uint256 userDeltaSrcToken;
1282         uint256 userDeltaDestToken;
1283         uint256 actualRate;
1284     }
1285 
1286     function prepareTrade(
1287         IERC20 src,
1288         IERC20 dest,
1289         uint256 srcAmount,
1290         address destAddress
1291     ) internal returns (UserBalance memory balanceBefore) {
1292         if (src == ETH_TOKEN_ADDRESS) {
1293             require(msg.value == srcAmount, "sent eth not equal to srcAmount");
1294         } else {
1295             require(msg.value == 0, "sent eth not 0");
1296         }
1297 
1298         balanceBefore.srcTok = getBalance(src, msg.sender);
1299         balanceBefore.destTok = getBalance(dest, destAddress);
1300 
1301         if (src == ETH_TOKEN_ADDRESS) {
1302             balanceBefore.srcTok += msg.value;
1303         } else {
1304             src.safeTransferFrom(msg.sender, address(kyberNetwork), srcAmount);
1305         }
1306     }
1307 
1308     function calculateTradeOutcome(
1309         IERC20 src,
1310         IERC20 dest,
1311         address destAddress,
1312         uint256 platformFeeBps,
1313         UserBalance memory balanceBefore
1314     ) internal returns (TradeOutcome memory outcome) {
1315         uint256 srcTokenBalanceAfter;
1316         uint256 destTokenBalanceAfter;
1317 
1318         srcTokenBalanceAfter = getBalance(src, msg.sender);
1319         destTokenBalanceAfter = getBalance(dest, destAddress);
1320 
1321         //protect from underflow
1322         require(
1323             destTokenBalanceAfter > balanceBefore.destTok,
1324             "wrong amount in destination address"
1325         );
1326         require(balanceBefore.srcTok > srcTokenBalanceAfter, "wrong amount in source address");
1327 
1328         outcome.userDeltaSrcToken = balanceBefore.srcTok - srcTokenBalanceAfter;
1329         outcome.userDeltaDestToken = destTokenBalanceAfter - balanceBefore.destTok;
1330 
1331         // what would be the src amount after deducting platformFee
1332         // not protecting from platform fee
1333         uint256 srcTokenAmountAfterDeductingFee = (outcome.userDeltaSrcToken *
1334             (BPS - platformFeeBps)) / BPS;
1335 
1336         outcome.actualRate = calcRateFromQty(
1337             srcTokenAmountAfterDeductingFee,
1338             outcome.userDeltaDestToken,
1339             getUpdateDecimals(src),
1340             getUpdateDecimals(dest)
1341         );
1342     }
1343 }