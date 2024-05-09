1 pragma solidity 0.5.16;
2 
3 
4 interface IBasicToken {
5     function decimals() external view returns (uint8);
6 }
7 
8 contract IERC20WithCheckpointing {
9     function balanceOf(address _owner) public view returns (uint256);
10     function balanceOfAt(address _owner, uint256 _blockNumber) public view returns (uint256);
11 
12     function totalSupply() public view returns (uint256);
13     function totalSupplyAt(uint256 _blockNumber) public view returns (uint256);
14 }
15 
16 contract IIncentivisedVotingLockup is IERC20WithCheckpointing {
17 
18     function getLastUserPoint(address _addr) external view returns(int128 bias, int128 slope, uint256 ts);
19     function createLock(uint256 _value, uint256 _unlockTime) external;
20     function withdraw() external;
21     function increaseLockAmount(uint256 _value) external;
22     function increaseLockLength(uint256 _unlockTime) external;
23     function eject(address _user) external;
24     function expireContract() external;
25 
26     function claimReward() public;
27     function earned(address _account) public view returns (uint256);
28 }
29 
30 contract ReentrancyGuard {
31     bool private _notEntered;
32 
33     constructor () internal {
34         // Storing an initial non-zero value makes deployment a bit more
35         // expensive, but in exchange the refund on every call to nonReentrant
36         // will be lower in amount. Since refunds are capped to a percetange of
37         // the total transaction's gas, it is best to keep them low in cases
38         // like this one, to increase the likelihood of the full refund coming
39         // into effect.
40         _notEntered = true;
41     }
42 
43     /**
44      * @dev Prevents a contract from calling itself, directly or indirectly.
45      * Calling a `nonReentrant` function from another `nonReentrant`
46      * function is not supported. It is possible to prevent this from happening
47      * by making the `nonReentrant` function external, and make it call a
48      * `private` function that does the actual work.
49      */
50     modifier nonReentrant() {
51         // On the first call to nonReentrant, _notEntered will be true
52         require(_notEntered, "ReentrancyGuard: reentrant call");
53 
54         // Any calls to nonReentrant after this point will fail
55         _notEntered = false;
56 
57         _;
58 
59         // By storing the original value once again, a refund is triggered (see
60         // https://eips.ethereum.org/EIPS/eip-2200)
61         _notEntered = true;
62     }
63 }
64 
65 contract ModuleKeys {
66 
67     // Governance
68     // ===========
69                                                 // Phases
70     // keccak256("Governance");                 // 2.x
71     bytes32 internal constant KEY_GOVERNANCE = 0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
72     //keccak256("Staking");                     // 1.2
73     bytes32 internal constant KEY_STAKING = 0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
74     //keccak256("ProxyAdmin");                  // 1.0
75     bytes32 internal constant KEY_PROXY_ADMIN = 0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;
76 
77     // mStable
78     // =======
79     // keccak256("OracleHub");                  // 1.2
80     bytes32 internal constant KEY_ORACLE_HUB = 0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
81     // keccak256("Manager");                    // 1.2
82     bytes32 internal constant KEY_MANAGER = 0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
83     //keccak256("Recollateraliser");            // 2.x
84     bytes32 internal constant KEY_RECOLLATERALISER = 0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
85     //keccak256("MetaToken");                   // 1.1
86     bytes32 internal constant KEY_META_TOKEN = 0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
87     // keccak256("SavingsManager");             // 1.0
88     bytes32 internal constant KEY_SAVINGS_MANAGER = 0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
89 }
90 
91 interface INexus {
92     function governor() external view returns (address);
93     function getModule(bytes32 key) external view returns (address);
94 
95     function proposeModule(bytes32 _key, address _addr) external;
96     function cancelProposedModule(bytes32 _key) external;
97     function acceptProposedModule(bytes32 _key) external;
98     function acceptProposedModules(bytes32[] calldata _keys) external;
99 
100     function requestLockModule(bytes32 _key) external;
101     function cancelLockModule(bytes32 _key) external;
102     function lockModule(bytes32 _key) external;
103 }
104 
105 contract Module is ModuleKeys {
106 
107     INexus public nexus;
108 
109     /**
110      * @dev Initialises the Module by setting publisher addresses,
111      *      and reading all available system module information
112      */
113     constructor(address _nexus) internal {
114         require(_nexus != address(0), "Nexus is zero address");
115         nexus = INexus(_nexus);
116     }
117 
118     /**
119      * @dev Modifier to allow function calls only from the Governor.
120      */
121     modifier onlyGovernor() {
122         require(msg.sender == _governor(), "Only governor can execute");
123         _;
124     }
125 
126     /**
127      * @dev Modifier to allow function calls only from the Governance.
128      *      Governance is either Governor address or Governance address.
129      */
130     modifier onlyGovernance() {
131         require(
132             msg.sender == _governor() || msg.sender == _governance(),
133             "Only governance can execute"
134         );
135         _;
136     }
137 
138     /**
139      * @dev Modifier to allow function calls only from the ProxyAdmin.
140      */
141     modifier onlyProxyAdmin() {
142         require(
143             msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"
144         );
145         _;
146     }
147 
148     /**
149      * @dev Modifier to allow function calls only from the Manager.
150      */
151     modifier onlyManager() {
152         require(msg.sender == _manager(), "Only manager can execute");
153         _;
154     }
155 
156     /**
157      * @dev Returns Governor address from the Nexus
158      * @return Address of Governor Contract
159      */
160     function _governor() internal view returns (address) {
161         return nexus.governor();
162     }
163 
164     /**
165      * @dev Returns Governance Module address from the Nexus
166      * @return Address of the Governance (Phase 2)
167      */
168     function _governance() internal view returns (address) {
169         return nexus.getModule(KEY_GOVERNANCE);
170     }
171 
172     /**
173      * @dev Return Staking Module address from the Nexus
174      * @return Address of the Staking Module contract
175      */
176     function _staking() internal view returns (address) {
177         return nexus.getModule(KEY_STAKING);
178     }
179 
180     /**
181      * @dev Return ProxyAdmin Module address from the Nexus
182      * @return Address of the ProxyAdmin Module contract
183      */
184     function _proxyAdmin() internal view returns (address) {
185         return nexus.getModule(KEY_PROXY_ADMIN);
186     }
187 
188     /**
189      * @dev Return MetaToken Module address from the Nexus
190      * @return Address of the MetaToken Module contract
191      */
192     function _metaToken() internal view returns (address) {
193         return nexus.getModule(KEY_META_TOKEN);
194     }
195 
196     /**
197      * @dev Return OracleHub Module address from the Nexus
198      * @return Address of the OracleHub Module contract
199      */
200     function _oracleHub() internal view returns (address) {
201         return nexus.getModule(KEY_ORACLE_HUB);
202     }
203 
204     /**
205      * @dev Return Manager Module address from the Nexus
206      * @return Address of the Manager Module contract
207      */
208     function _manager() internal view returns (address) {
209         return nexus.getModule(KEY_MANAGER);
210     }
211 
212     /**
213      * @dev Return SavingsManager Module address from the Nexus
214      * @return Address of the SavingsManager Module contract
215      */
216     function _savingsManager() internal view returns (address) {
217         return nexus.getModule(KEY_SAVINGS_MANAGER);
218     }
219 
220     /**
221      * @dev Return Recollateraliser Module address from the Nexus
222      * @return  Address of the Recollateraliser Module contract (Phase 2)
223      */
224     function _recollateraliser() internal view returns (address) {
225         return nexus.getModule(KEY_RECOLLATERALISER);
226     }
227 }
228 
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `recipient`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through {transferFrom}. This is
252      * zero by default.
253      *
254      * This value changes when {approve} or {transferFrom} are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `sender` to `recipient` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to {approve}. `value` is the new allowance.
296      */
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 interface IRewardsDistributionRecipient {
301     function notifyRewardAmount(uint256 reward) external;
302     function getRewardToken() external view returns (IERC20);
303 }
304 
305 contract RewardsDistributionRecipient is IRewardsDistributionRecipient, Module {
306 
307     // @abstract
308     function notifyRewardAmount(uint256 reward) external;
309     function getRewardToken() external view returns (IERC20);
310 
311     // This address has the ability to distribute the rewards
312     address public rewardsDistributor;
313 
314     /** @dev Recipient is a module, governed by mStable governance */
315     constructor(address _nexus, address _rewardsDistributor)
316         internal
317         Module(_nexus)
318     {
319         rewardsDistributor = _rewardsDistributor;
320     }
321 
322     /**
323      * @dev Only the rewards distributor can notify about rewards
324      */
325     modifier onlyRewardsDistributor() {
326         require(msg.sender == rewardsDistributor, "Caller is not reward distributor");
327         _;
328     }
329 
330     /**
331      * @dev Change the rewardsDistributor - only called by mStable governor
332      * @param _rewardsDistributor   Address of the new distributor
333      */
334     function setRewardsDistribution(address _rewardsDistributor)
335         external
336         onlyGovernor
337     {
338         rewardsDistributor = _rewardsDistributor;
339     }
340 }
341 
342 /**
343  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
344  * the optional functions; to access them see {ERC20Detailed}.
345  */
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
398      *
399      * _Available since v2.4.0._
400      */
401     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
402         require(b <= a, errorMessage);
403         uint256 c = a - b;
404 
405         return c;
406     }
407 
408     /**
409      * @dev Returns the multiplication of two unsigned integers, reverting on
410      * overflow.
411      *
412      * Counterpart to Solidity's `*` operator.
413      *
414      * Requirements:
415      * - Multiplication cannot overflow.
416      */
417     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
418         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
419         // benefit is lost if 'b' is also tested.
420         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
421         if (a == 0) {
422             return 0;
423         }
424 
425         uint256 c = a * b;
426         require(c / a == b, "SafeMath: multiplication overflow");
427 
428         return c;
429     }
430 
431     /**
432      * @dev Returns the integer division of two unsigned integers. Reverts on
433      * division by zero. The result is rounded towards zero.
434      *
435      * Counterpart to Solidity's `/` operator. Note: this function uses a
436      * `revert` opcode (which leaves remaining gas untouched) while Solidity
437      * uses an invalid opcode to revert (consuming all remaining gas).
438      *
439      * Requirements:
440      * - The divisor cannot be zero.
441      */
442     function div(uint256 a, uint256 b) internal pure returns (uint256) {
443         return div(a, b, "SafeMath: division by zero");
444     }
445 
446     /**
447      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
448      * division by zero. The result is rounded towards zero.
449      *
450      * Counterpart to Solidity's `/` operator. Note: this function uses a
451      * `revert` opcode (which leaves remaining gas untouched) while Solidity
452      * uses an invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      * - The divisor cannot be zero.
456      *
457      * _Available since v2.4.0._
458      */
459     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
460         // Solidity only automatically asserts when dividing by 0
461         require(b > 0, errorMessage);
462         uint256 c = a / b;
463         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
464 
465         return c;
466     }
467 
468     /**
469      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
470      * Reverts when dividing by zero.
471      *
472      * Counterpart to Solidity's `%` operator. This function uses a `revert`
473      * opcode (which leaves remaining gas untouched) while Solidity uses an
474      * invalid opcode to revert (consuming all remaining gas).
475      *
476      * Requirements:
477      * - The divisor cannot be zero.
478      */
479     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
480         return mod(a, b, "SafeMath: modulo by zero");
481     }
482 
483     /**
484      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
485      * Reverts with custom message when dividing by zero.
486      *
487      * Counterpart to Solidity's `%` operator. This function uses a `revert`
488      * opcode (which leaves remaining gas untouched) while Solidity uses an
489      * invalid opcode to revert (consuming all remaining gas).
490      *
491      * Requirements:
492      * - The divisor cannot be zero.
493      *
494      * _Available since v2.4.0._
495      */
496     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
497         require(b != 0, errorMessage);
498         return a % b;
499     }
500 }
501 
502 /**
503  * @dev Collection of functions related to the address type
504  */
505 library Address {
506     /**
507      * @dev Returns true if `account` is a contract.
508      *
509      * [IMPORTANT]
510      * ====
511      * It is unsafe to assume that an address for which this function returns
512      * false is an externally-owned account (EOA) and not a contract.
513      *
514      * Among others, `isContract` will return false for the following 
515      * types of addresses:
516      *
517      *  - an externally-owned account
518      *  - a contract in construction
519      *  - an address where a contract will be created
520      *  - an address where a contract lived, but was destroyed
521      * ====
522      */
523     function isContract(address account) internal view returns (bool) {
524         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
525         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
526         // for accounts without code, i.e. `keccak256('')`
527         bytes32 codehash;
528         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
529         // solhint-disable-next-line no-inline-assembly
530         assembly { codehash := extcodehash(account) }
531         return (codehash != accountHash && codehash != 0x0);
532     }
533 
534     /**
535      * @dev Converts an `address` into `address payable`. Note that this is
536      * simply a type cast: the actual underlying value is not changed.
537      *
538      * _Available since v2.4.0._
539      */
540     function toPayable(address account) internal pure returns (address payable) {
541         return address(uint160(account));
542     }
543 
544     /**
545      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
546      * `recipient`, forwarding all available gas and reverting on errors.
547      *
548      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
549      * of certain opcodes, possibly making contracts go over the 2300 gas limit
550      * imposed by `transfer`, making them unable to receive funds via
551      * `transfer`. {sendValue} removes this limitation.
552      *
553      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
554      *
555      * IMPORTANT: because control is transferred to `recipient`, care must be
556      * taken to not create reentrancy vulnerabilities. Consider using
557      * {ReentrancyGuard} or the
558      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
559      *
560      * _Available since v2.4.0._
561      */
562     function sendValue(address payable recipient, uint256 amount) internal {
563         require(address(this).balance >= amount, "Address: insufficient balance");
564 
565         // solhint-disable-next-line avoid-call-value
566         (bool success, ) = recipient.call.value(amount)("");
567         require(success, "Address: unable to send value, recipient may have reverted");
568     }
569 }
570 
571 library SafeERC20 {
572     using SafeMath for uint256;
573     using Address for address;
574 
575     function safeTransfer(IERC20 token, address to, uint256 value) internal {
576         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
577     }
578 
579     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
580         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
581     }
582 
583     function safeApprove(IERC20 token, address spender, uint256 value) internal {
584         // safeApprove should only be called when setting an initial allowance,
585         // or when resetting it to zero. To increase and decrease it, use
586         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
587         // solhint-disable-next-line max-line-length
588         require((value == 0) || (token.allowance(address(this), spender) == 0),
589             "SafeERC20: approve from non-zero to non-zero allowance"
590         );
591         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
592     }
593 
594     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
595         uint256 newAllowance = token.allowance(address(this), spender).add(value);
596         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
597     }
598 
599     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
600         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
601         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
602     }
603 
604     /**
605      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
606      * on the return value: the return value is optional (but if data is returned, it must not be false).
607      * @param token The token targeted by the call.
608      * @param data The call data (encoded using abi.encode or one of its variants).
609      */
610     function callOptionalReturn(IERC20 token, bytes memory data) private {
611         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
612         // we're implementing it ourselves.
613 
614         // A Solidity high level call has three parts:
615         //  1. The target address is checked to verify it contains contract code
616         //  2. The call itself is made, and success asserted
617         //  3. The return value is decoded, which in turn checks the size of the returned data.
618         // solhint-disable-next-line max-line-length
619         require(address(token).isContract(), "SafeERC20: call to non-contract");
620 
621         // solhint-disable-next-line avoid-low-level-calls
622         (bool success, bytes memory returndata) = address(token).call(data);
623         require(success, "SafeERC20: low-level call failed");
624 
625         if (returndata.length > 0) { // Return data is optional
626             // solhint-disable-next-line max-line-length
627             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
628         }
629     }
630 }
631 
632 library SignedSafeMath128 {
633     int128 constant private _INT128_MIN = -2**127;
634 
635     /**
636      * @dev Returns the multiplication of two signed integers, reverting on
637      * overflow.
638      *
639      * Counterpart to Solidity's `*` operator.
640      *
641      * Requirements:
642      *
643      * - Multiplication cannot overflow.
644      */
645     function mul(int128 a, int128 b) internal pure returns (int128) {
646         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
647         // benefit is lost if 'b' is also tested.
648         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
649         if (a == 0) {
650             return 0;
651         }
652 
653         require(!(a == -1 && b == _INT128_MIN), "SignedSafeMath: multiplication overflow");
654 
655         int128 c = a * b;
656         require(c / a == b, "SignedSafeMath: multiplication overflow");
657 
658         return c;
659     }
660 
661     /**
662      * @dev Returns the integer division of two signed integers. Reverts on
663      * division by zero. The result is rounded towards zero.
664      *
665      * Counterpart to Solidity's `/` operator. Note: this function uses a
666      * `revert` opcode (which leaves remaining gas untouched) while Solidity
667      * uses an invalid opcode to revert (consuming all remaining gas).
668      *
669      * Requirements:
670      *
671      * - The divisor cannot be zero.
672      */
673     function div(int128 a, int128 b) internal pure returns (int128) {
674         require(b != 0, "SignedSafeMath: division by zero");
675         require(!(b == -1 && a == _INT128_MIN), "SignedSafeMath: division overflow");
676 
677         int128 c = a / b;
678 
679         return c;
680     }
681 
682     /**
683      * @dev Returns the subtraction of two signed integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `-` operator.
687      *
688      * Requirements:
689      *
690      * - Subtraction cannot overflow.
691      */
692     function sub(int128 a, int128 b) internal pure returns (int128) {
693         int128 c = a - b;
694         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
695 
696         return c;
697     }
698 
699     /**
700      * @dev Returns the addition of two signed integers, reverting on
701      * overflow.
702      *
703      * Counterpart to Solidity's `+` operator.
704      *
705      * Requirements:
706      *
707      * - Addition cannot overflow.
708      */
709     function add(int128 a, int128 b) internal pure returns (int128) {
710         int128 c = a + b;
711         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
712 
713         return c;
714     }
715 }
716 
717 library StableMath {
718 
719     using SafeMath for uint256;
720 
721     /**
722      * @dev Scaling unit for use in specific calculations,
723      * where 1 * 10**18, or 1e18 represents a unit '1'
724      */
725     uint256 private constant FULL_SCALE = 1e18;
726 
727     /**
728      * @notice Token Ratios are used when converting between units of bAsset, mAsset and MTA
729      * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
730      * @dev bAsset ratio unit for use in exact calculations,
731      * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
732      */
733     uint256 private constant RATIO_SCALE = 1e8;
734 
735     /**
736      * @dev Provides an interface to the scaling unit
737      * @return Scaling unit (1e18 or 1 * 10**18)
738      */
739     function getFullScale() internal pure returns (uint256) {
740         return FULL_SCALE;
741     }
742 
743     /**
744      * @dev Provides an interface to the ratio unit
745      * @return Ratio scale unit (1e8 or 1 * 10**8)
746      */
747     function getRatioScale() internal pure returns (uint256) {
748         return RATIO_SCALE;
749     }
750 
751     /**
752      * @dev Scales a given integer to the power of the full scale.
753      * @param x   Simple uint256 to scale
754      * @return    Scaled value a to an exact number
755      */
756     function scaleInteger(uint256 x)
757         internal
758         pure
759         returns (uint256)
760     {
761         return x.mul(FULL_SCALE);
762     }
763 
764     /***************************************
765               PRECISE ARITHMETIC
766     ****************************************/
767 
768     /**
769      * @dev Multiplies two precise units, and then truncates by the full scale
770      * @param x     Left hand input to multiplication
771      * @param y     Right hand input to multiplication
772      * @return      Result after multiplying the two inputs and then dividing by the shared
773      *              scale unit
774      */
775     function mulTruncate(uint256 x, uint256 y)
776         internal
777         pure
778         returns (uint256)
779     {
780         return mulTruncateScale(x, y, FULL_SCALE);
781     }
782 
783     /**
784      * @dev Multiplies two precise units, and then truncates by the given scale. For example,
785      * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
786      * @param x     Left hand input to multiplication
787      * @param y     Right hand input to multiplication
788      * @param scale Scale unit
789      * @return      Result after multiplying the two inputs and then dividing by the shared
790      *              scale unit
791      */
792     function mulTruncateScale(uint256 x, uint256 y, uint256 scale)
793         internal
794         pure
795         returns (uint256)
796     {
797         // e.g. assume scale = fullScale
798         // z = 10e18 * 9e17 = 9e36
799         uint256 z = x.mul(y);
800         // return 9e38 / 1e18 = 9e18
801         return z.div(scale);
802     }
803 
804     /**
805      * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
806      * @param x     Left hand input to multiplication
807      * @param y     Right hand input to multiplication
808      * @return      Result after multiplying the two inputs and then dividing by the shared
809      *              scale unit, rounded up to the closest base unit.
810      */
811     function mulTruncateCeil(uint256 x, uint256 y)
812         internal
813         pure
814         returns (uint256)
815     {
816         // e.g. 8e17 * 17268172638 = 138145381104e17
817         uint256 scaled = x.mul(y);
818         // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
819         uint256 ceil = scaled.add(FULL_SCALE.sub(1));
820         // e.g. 13814538111.399...e18 / 1e18 = 13814538111
821         return ceil.div(FULL_SCALE);
822     }
823 
824     /**
825      * @dev Precisely divides two units, by first scaling the left hand operand. Useful
826      *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
827      * @param x     Left hand input to division
828      * @param y     Right hand input to division
829      * @return      Result after multiplying the left operand by the scale, and
830      *              executing the division on the right hand input.
831      */
832     function divPrecisely(uint256 x, uint256 y)
833         internal
834         pure
835         returns (uint256)
836     {
837         // e.g. 8e18 * 1e18 = 8e36
838         uint256 z = x.mul(FULL_SCALE);
839         // e.g. 8e36 / 10e18 = 8e17
840         return z.div(y);
841     }
842 
843 
844     /***************************************
845                   RATIO FUNCS
846     ****************************************/
847 
848     /**
849      * @dev Multiplies and truncates a token ratio, essentially flooring the result
850      *      i.e. How much mAsset is this bAsset worth?
851      * @param x     Left hand operand to multiplication (i.e Exact quantity)
852      * @param ratio bAsset ratio
853      * @return      Result after multiplying the two inputs and then dividing by the ratio scale
854      */
855     function mulRatioTruncate(uint256 x, uint256 ratio)
856         internal
857         pure
858         returns (uint256 c)
859     {
860         return mulTruncateScale(x, ratio, RATIO_SCALE);
861     }
862 
863     /**
864      * @dev Multiplies and truncates a token ratio, rounding up the result
865      *      i.e. How much mAsset is this bAsset worth?
866      * @param x     Left hand input to multiplication (i.e Exact quantity)
867      * @param ratio bAsset ratio
868      * @return      Result after multiplying the two inputs and then dividing by the shared
869      *              ratio scale, rounded up to the closest base unit.
870      */
871     function mulRatioTruncateCeil(uint256 x, uint256 ratio)
872         internal
873         pure
874         returns (uint256)
875     {
876         // e.g. How much mAsset should I burn for this bAsset (x)?
877         // 1e18 * 1e8 = 1e26
878         uint256 scaled = x.mul(ratio);
879         // 1e26 + 9.99e7 = 100..00.999e8
880         uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
881         // return 100..00.999e8 / 1e8 = 1e18
882         return ceil.div(RATIO_SCALE);
883     }
884 
885 
886     /**
887      * @dev Precisely divides two ratioed units, by first scaling the left hand operand
888      *      i.e. How much bAsset is this mAsset worth?
889      * @param x     Left hand operand in division
890      * @param ratio bAsset ratio
891      * @return      Result after multiplying the left operand by the scale, and
892      *              executing the division on the right hand input.
893      */
894     function divRatioPrecisely(uint256 x, uint256 ratio)
895         internal
896         pure
897         returns (uint256 c)
898     {
899         // e.g. 1e14 * 1e8 = 1e22
900         uint256 y = x.mul(RATIO_SCALE);
901         // return 1e22 / 1e12 = 1e10
902         return y.div(ratio);
903     }
904 
905     /***************************************
906                     HELPERS
907     ****************************************/
908 
909     /**
910      * @dev Calculates minimum of two numbers
911      * @param x     Left hand input
912      * @param y     Right hand input
913      * @return      Minimum of the two inputs
914      */
915     function min(uint256 x, uint256 y)
916         internal
917         pure
918         returns (uint256)
919     {
920         return x > y ? y : x;
921     }
922 
923     /**
924      * @dev Calculated maximum of two numbers
925      * @param x     Left hand input
926      * @param y     Right hand input
927      * @return      Maximum of the two inputs
928      */
929     function max(uint256 x, uint256 y)
930         internal
931         pure
932         returns (uint256)
933     {
934         return x > y ? x : y;
935     }
936 
937     /**
938      * @dev Clamps a value to an upper bound
939      * @param x           Left hand input
940      * @param upperBound  Maximum possible value to return
941      * @return            Input x clamped to a maximum value, upperBound
942      */
943     function clamp(uint256 x, uint256 upperBound)
944         internal
945         pure
946         returns (uint256)
947     {
948         return x > upperBound ? upperBound : x;
949     }
950 }
951 
952 library Root {
953 
954     using SafeMath for uint256;
955 
956     /**
957      * @dev Returns the square root of a given number
958      * @param x Input
959      * @return y Square root of Input
960      */
961     function sqrt(uint x) internal pure returns (uint y) {
962         uint z = (x.add(1)).div(2);
963         y = x;
964         while (z < y) {
965             y = z;
966             z = (x.div(z).add(z)).div(2);
967         }
968     }
969 }
970 
971 /* solium-disable security/no-block-members */
972 /**
973  * @title  IncentivisedVotingLockup
974  * @author Voting Weight tracking & Decay
975  *             -> Curve Finance (MIT) - forked & ported to Solidity
976  *             -> https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/VotingEscrow.vy
977  *         osolmaz - Research & Reward distributions
978  *         alsco77 - Solidity implementation
979  * @notice Lockup MTA, receive vMTA (voting weight that decays over time), and earn
980  *         rewards based on staticWeight
981  * @dev    Supports:
982  *            1) Tracking MTA Locked up (LockedBalance)
983  *            2) Pull Based Reward allocations based on Lockup (Static Balance)
984  *            3) Decaying voting weight lookup through CheckpointedERC20 (balanceOf)
985  *            4) Ejecting fully decayed participants from reward allocation (eject)
986  *            5) Migration of points to v2 (used as multiplier in future) ***** (rewardsPaid)
987  *            6) Closure of contract (expire)
988  */
989 contract IncentivisedVotingLockup is
990     IIncentivisedVotingLockup,
991     ReentrancyGuard,
992     RewardsDistributionRecipient
993 {
994     using StableMath for uint256;
995     using SafeMath for uint256;
996     using SignedSafeMath128 for int128;
997     using SafeERC20 for IERC20;
998 
999     /** Shared Events */
1000     event Deposit(address indexed provider, uint256 value, uint256 locktime, LockAction indexed action, uint256 ts);
1001     event Withdraw(address indexed provider, uint256 value, uint256 ts);
1002     event Ejected(address indexed ejected, address ejector, uint256 ts);
1003     event Expired();
1004     event RewardAdded(uint256 reward);
1005     event RewardPaid(address indexed user, uint256 reward);
1006 
1007     /** Shared Globals */
1008     IERC20 public stakingToken;
1009     uint256 private constant WEEK = 7 days;
1010     uint256 public constant MAXTIME = 365 days;
1011     uint256 public END;
1012     bool public expired = false;
1013 
1014     /** Lockup */
1015     uint256 public globalEpoch;
1016     Point[] public pointHistory;
1017     mapping(address => Point[]) public userPointHistory;
1018     mapping(address => uint256) public userPointEpoch;
1019     mapping(uint256 => int128) public slopeChanges;
1020     mapping(address => LockedBalance) public locked;
1021 
1022     // Voting token - Checkpointed view only ERC20
1023     string public name;
1024     string public symbol;
1025     uint256 public decimals = 18;
1026 
1027     /** Rewards */
1028     // Updated upon admin deposit
1029     uint256 public periodFinish = 0;
1030     uint256 public rewardRate = 0;
1031 
1032     // Globals updated per stake/deposit/withdrawal
1033     uint256 public totalStaticWeight = 0;
1034     uint256 public lastUpdateTime = 0;
1035     uint256 public rewardPerTokenStored = 0;
1036 
1037     // Per user storage updated per stake/deposit/withdrawal
1038     mapping(address => uint256) public userRewardPerTokenPaid;
1039     mapping(address => uint256) public rewards;
1040     mapping(address => uint256) public rewardsPaid;
1041 
1042     /** Structs */
1043     struct Point {
1044         int128 bias;
1045         int128 slope;
1046         uint256 ts;
1047         uint256 blk;
1048     }
1049 
1050     struct LockedBalance {
1051         int128 amount;
1052         uint256 end;
1053     }
1054 
1055     enum LockAction {
1056         CREATE_LOCK,
1057         INCREASE_LOCK_AMOUNT,
1058         INCREASE_LOCK_TIME
1059     }
1060 
1061     constructor(
1062         address _stakingToken,
1063         string memory _name,
1064         string memory _symbol,
1065         address _nexus,
1066         address _rewardsDistributor
1067     )
1068         public
1069         RewardsDistributionRecipient(_nexus, _rewardsDistributor)
1070     {
1071         stakingToken = IERC20(_stakingToken);
1072         Point memory init = Point({ bias: int128(0), slope: int128(0), ts: block.timestamp, blk: block.number});
1073         pointHistory.push(init);
1074 
1075         decimals = IBasicToken(_stakingToken).decimals();
1076         require(decimals <= 18, "Cannot have more than 18 decimals");
1077 
1078         name = _name;
1079         symbol = _symbol;
1080 
1081         END = block.timestamp.add(MAXTIME);
1082     }
1083 
1084     /** @dev Modifier to ensure contract has not yet expired */
1085     modifier contractNotExpired(){
1086         require(!expired, "Contract is expired");
1087         _;
1088     }
1089 
1090     /**
1091     * @dev Validates that the user has an expired lock && they still have capacity to earn
1092     * @param _addr User address to check
1093     */
1094     modifier lockupIsOver(address _addr) {
1095         LockedBalance memory userLock = locked[_addr];
1096         require(userLock.amount > 0 && block.timestamp >= userLock.end, "Users lock didn't expire");
1097         require(staticBalanceOf(_addr) > 0, "User must have existing bias");
1098         _;
1099     }
1100 
1101     /***************************************
1102                 LOCKUP - GETTERS
1103     ****************************************/
1104 
1105     /**
1106      * @dev Gets the last available user point
1107      * @param _addr User address
1108      * @return bias i.e. y
1109      * @return slope i.e. linear gradient
1110      * @return ts i.e. time point was logged
1111      */
1112     function getLastUserPoint(address _addr)
1113         external
1114         view
1115         returns(
1116             int128 bias,
1117             int128 slope,
1118             uint256 ts
1119         )
1120     {
1121         uint256 uepoch = userPointEpoch[_addr];
1122         if(uepoch == 0){
1123             return (0, 0, 0);
1124         }
1125         Point memory point = userPointHistory[_addr][uepoch];
1126         return (point.bias, point.slope, point.ts);
1127     }
1128 
1129     /***************************************
1130                     LOCKUP
1131     ****************************************/
1132 
1133     /**
1134      * @dev Records a checkpoint of both individual and global slope
1135      * @param _addr User address, or address(0) for only global
1136      * @param _oldLocked Old amount that user had locked, or null for global
1137      * @param _newLocked new amount that user has locked, or null for global
1138      */
1139     function _checkpoint(
1140         address _addr,
1141         LockedBalance memory _oldLocked,
1142         LockedBalance memory _newLocked
1143     )
1144         internal
1145     {
1146         Point memory userOldPoint;
1147         Point memory userNewPoint;
1148         int128 oldSlopeDelta = 0;
1149         int128 newSlopeDelta = 0;
1150         uint256 epoch = globalEpoch;
1151 
1152         if(_addr != address(0)){
1153             // Calculate slopes and biases
1154             // Kept at zero when they have to
1155             if(_oldLocked.end > block.timestamp && _oldLocked.amount > 0){
1156                 userOldPoint.slope = _oldLocked.amount.div(int128(MAXTIME));
1157                 userOldPoint.bias = userOldPoint.slope.mul(int128(_oldLocked.end.sub(block.timestamp)));
1158             }
1159             if(_newLocked.end > block.timestamp && _newLocked.amount > 0){
1160                 userNewPoint.slope = _newLocked.amount.div(int128(MAXTIME));
1161                 userNewPoint.bias = userNewPoint.slope.mul(int128(_newLocked.end.sub(block.timestamp)));
1162             }
1163 
1164             // Moved from bottom final if statement to resolve stack too deep err
1165             // start {
1166             // Now handle user history
1167             uint256 uEpoch = userPointEpoch[_addr];
1168             if(uEpoch == 0){
1169                 userPointHistory[_addr].push(userOldPoint);
1170             }
1171             // track the total static weight
1172             uint256 newStatic = _staticBalance(userNewPoint.slope, block.timestamp, _newLocked.end);
1173             uint256 additiveStaticWeight = totalStaticWeight.add(newStatic);
1174             if(uEpoch > 0){
1175                 uint256 oldStatic = _staticBalance(userPointHistory[_addr][uEpoch].slope, userPointHistory[_addr][uEpoch].ts, _oldLocked.end);
1176                 additiveStaticWeight = additiveStaticWeight.sub(oldStatic);
1177             }
1178             totalStaticWeight = additiveStaticWeight;
1179 
1180             userPointEpoch[_addr] = uEpoch.add(1);
1181             userNewPoint.ts = block.timestamp;
1182             userNewPoint.blk = block.number;
1183             // userPointHistory[_addr][uEpoch.add(1)] = userNewPoint;
1184             userPointHistory[_addr].push(userNewPoint);
1185 
1186             // } end
1187 
1188             // Read values of scheduled changes in the slope
1189             // oldLocked.end can be in the past and in the future
1190             // newLocked.end can ONLY by in the FUTURE unless everything expired: than zeros
1191             oldSlopeDelta = slopeChanges[_oldLocked.end];
1192             if(_newLocked.end != 0){
1193                 if (_newLocked.end == _oldLocked.end) {
1194                     newSlopeDelta = oldSlopeDelta;
1195                 } else {
1196                     newSlopeDelta = slopeChanges[_newLocked.end];
1197                 }
1198             }
1199         }
1200 
1201         Point memory lastPoint = Point({bias: 0, slope: 0, ts: block.timestamp, blk: block.number});
1202         if(epoch > 0){
1203             lastPoint = pointHistory[epoch];
1204         }
1205         uint256 lastCheckpoint = lastPoint.ts;
1206 
1207         // initialLastPoint is used for extrapolation to calculate block number
1208         // (approximately, for *At methods) and save them
1209         // as we cannot figure that out exactly from inside the contract
1210         Point memory initialLastPoint = Point({bias: 0, slope: 0, ts: lastPoint.ts, blk: lastPoint.blk});
1211         uint256 blockSlope = 0; // dblock/dt
1212         if(block.timestamp > lastPoint.ts){
1213             blockSlope = StableMath.scaleInteger(block.number.sub(lastPoint.blk)).div(block.timestamp.sub(lastPoint.ts));
1214         }
1215         // If last point is already recorded in this block, slope=0
1216         // But that's ok b/c we know the block in such case
1217 
1218         // Go over weeks to fill history and calculate what the current point is
1219         uint256 iterativeTime = _floorToWeek(lastCheckpoint);
1220         for (uint256 i = 0; i < 255; i++){
1221             // Hopefully it won't happen that this won't get used in 5 years!
1222             // If it does, users will be able to withdraw but vote weight will be broken
1223             iterativeTime = iterativeTime.add(WEEK);
1224             int128 dSlope = 0;
1225             if(iterativeTime > block.timestamp){
1226                 iterativeTime = block.timestamp;
1227             } else {
1228                 dSlope = slopeChanges[iterativeTime];
1229             }
1230             int128 biasDelta = lastPoint.slope.mul(int128(iterativeTime.sub(lastCheckpoint)));
1231             lastPoint.bias = lastPoint.bias.sub(biasDelta);
1232             lastPoint.slope = lastPoint.slope.add(dSlope);
1233             // This can happen
1234             if(lastPoint.bias < 0){
1235                 lastPoint.bias = 0;
1236             }
1237             // This cannot happen - just in case
1238             if(lastPoint.slope < 0){
1239                 lastPoint.slope = 0;
1240             }
1241             lastCheckpoint = iterativeTime;
1242             lastPoint.ts = iterativeTime;
1243             lastPoint.blk = initialLastPoint.blk.add(blockSlope.mulTruncate(iterativeTime.sub(initialLastPoint.ts)));
1244 
1245             // when epoch is incremented, we either push here or after slopes updated below
1246             epoch = epoch.add(1);
1247             if(iterativeTime == block.timestamp) {
1248                 lastPoint.blk = block.number;
1249                 break;
1250             } else {
1251                 // pointHistory[epoch] = lastPoint;
1252                 pointHistory.push(lastPoint);
1253             }
1254         }
1255 
1256         globalEpoch = epoch;
1257         // Now pointHistory is filled until t=now
1258 
1259         if(_addr != address(0)){
1260             // If last point was in this block, the slope change has been applied already
1261             // But in such case we have 0 slope(s)
1262             lastPoint.slope = lastPoint.slope.add(userNewPoint.slope.sub(userOldPoint.slope));
1263             lastPoint.bias = lastPoint.bias.add(userNewPoint.bias.sub(userOldPoint.bias));
1264             if(lastPoint.slope < 0) {
1265                 lastPoint.slope = 0;
1266             }
1267             if(lastPoint.bias < 0){
1268                 lastPoint.bias = 0;
1269             }
1270         }
1271 
1272         // Record the changed point into history
1273         // pointHistory[epoch] = lastPoint;
1274         pointHistory.push(lastPoint);
1275 
1276         if(_addr != address(0)){
1277             // Schedule the slope changes (slope is going down)
1278             // We subtract new_user_slope from [new_locked.end]
1279             // and add old_user_slope to [old_locked.end]
1280             if(_oldLocked.end > block.timestamp){
1281                 // oldSlopeDelta was <something> - userOldPoint.slope, so we cancel that
1282                 oldSlopeDelta = oldSlopeDelta.add(userOldPoint.slope);
1283                 if(_newLocked.end == _oldLocked.end) {
1284                     oldSlopeDelta = oldSlopeDelta.sub(userNewPoint.slope);  // It was a new deposit, not extension
1285                 }
1286                 slopeChanges[_oldLocked.end] = oldSlopeDelta;
1287             }
1288             if(_newLocked.end > block.timestamp) {
1289                 if(_newLocked.end > _oldLocked.end){
1290                     newSlopeDelta = newSlopeDelta.sub(userNewPoint.slope);  // old slope disappeared at this point
1291                     slopeChanges[_newLocked.end] = newSlopeDelta;
1292                 }
1293                 // else: we recorded it already in oldSlopeDelta
1294             }
1295         }
1296     }
1297 
1298     /**
1299      * @dev Deposits or creates a stake for a given address
1300      * @param _addr User address to assign the stake
1301      * @param _value Total units of StakingToken to lockup
1302      * @param _unlockTime Time at which the stake should unlock
1303      * @param _oldLocked Previous amount staked by this user
1304      * @param _action See LockAction enum
1305      */
1306     function _depositFor(
1307         address _addr,
1308         uint256 _value,
1309         uint256 _unlockTime,
1310         LockedBalance memory _oldLocked,
1311         LockAction _action
1312     )
1313         internal
1314     {
1315         LockedBalance memory newLocked = LockedBalance({amount: _oldLocked.amount, end: _oldLocked.end});
1316 
1317         // Adding to existing lock, or if a lock is expired - creating a new one
1318         newLocked.amount = newLocked.amount.add(int128(_value));
1319         if(_unlockTime != 0){
1320             newLocked.end = _unlockTime;
1321         }
1322         locked[_addr] = newLocked;
1323 
1324         // Possibilities:
1325         // Both _oldLocked.end could be current or expired (>/< block.timestamp)
1326         // value == 0 (extend lock) or value > 0 (add to lock or extend lock)
1327         // newLocked.end > block.timestamp (always)
1328         _checkpoint(_addr, _oldLocked, newLocked);
1329 
1330         if(_value != 0) {
1331             stakingToken.safeTransferFrom(_addr, address(this), _value);
1332         }
1333 
1334         emit Deposit(_addr, _value, newLocked.end, _action, block.timestamp);
1335     }
1336 
1337     /**
1338      * @dev Public function to trigger global checkpoint
1339      */
1340     function checkpoint() external {
1341         LockedBalance memory empty;
1342         _checkpoint(address(0), empty, empty);
1343     }
1344 
1345     /**
1346      * @dev Creates a new lock
1347      * @param _value Total units of StakingToken to lockup
1348      * @param _unlockTime Time at which the stake should unlock
1349      */
1350     function createLock(uint256 _value, uint256 _unlockTime)
1351         external
1352         nonReentrant
1353         contractNotExpired
1354         updateReward(msg.sender)
1355     {
1356         uint256 unlock_time = _floorToWeek(_unlockTime);  // Locktime is rounded down to weeks
1357         LockedBalance memory locked_ = LockedBalance({amount: locked[msg.sender].amount, end: locked[msg.sender].end});
1358 
1359         require(_value > 0, "Must stake non zero amount");
1360         require(locked_.amount == 0, "Withdraw old tokens first");
1361 
1362         require(unlock_time > block.timestamp, "Can only lock until time in the future");
1363         require(unlock_time <= END, "Voting lock can be 1 year max (until recol)");
1364 
1365         _depositFor(msg.sender, _value, unlock_time, locked_, LockAction.CREATE_LOCK);
1366     }
1367 
1368     /**
1369      * @dev Increases amount of stake thats locked up & resets decay
1370      * @param _value Additional units of StakingToken to add to exiting stake
1371      */
1372     function increaseLockAmount(uint256 _value)
1373         external
1374         nonReentrant
1375         contractNotExpired
1376         updateReward(msg.sender)
1377     {
1378         LockedBalance memory locked_ = LockedBalance({amount: locked[msg.sender].amount, end: locked[msg.sender].end});
1379 
1380         require(_value > 0, "Must stake non zero amount");
1381         require(locked_.amount > 0, "No existing lock found");
1382         require(locked_.end > block.timestamp, "Cannot add to expired lock. Withdraw");
1383 
1384         _depositFor(msg.sender, _value, 0, locked_, LockAction.INCREASE_LOCK_AMOUNT);
1385     }
1386 
1387     /**
1388      * @dev Increases length of lockup & resets decay
1389      * @param _unlockTime New unlocktime for lockup
1390      */
1391     function increaseLockLength(uint256 _unlockTime)
1392         external
1393         nonReentrant
1394         contractNotExpired
1395         updateReward(msg.sender)
1396     {
1397         LockedBalance memory locked_ = LockedBalance({amount: locked[msg.sender].amount, end: locked[msg.sender].end});
1398         uint256 unlock_time = _floorToWeek(_unlockTime);  // Locktime is rounded down to weeks
1399 
1400         require(locked_.amount > 0, "Nothing is locked");
1401         require(locked_.end > block.timestamp, "Lock expired");
1402         require(unlock_time > locked_.end, "Can only increase lock WEEK");
1403         require(unlock_time <= END, "Voting lock can be 1 year max (until recol)");
1404 
1405         _depositFor(msg.sender, 0, unlock_time, locked_, LockAction.INCREASE_LOCK_TIME);
1406     }
1407 
1408     /**
1409      * @dev Withdraws all the senders stake, providing lockup is over
1410      */
1411     function withdraw()
1412         external
1413     {
1414         _withdraw(msg.sender);
1415     }
1416 
1417     /**
1418      * @dev Withdraws a given users stake, providing the lockup has finished
1419      * @param _addr User for which to withdraw
1420      */
1421     function _withdraw(address _addr)
1422         internal
1423         nonReentrant
1424         updateReward(_addr)
1425     {
1426         LockedBalance memory oldLock = LockedBalance({ end: locked[_addr].end, amount: locked[_addr].amount });
1427         require(block.timestamp >= oldLock.end || expired, "The lock didn't expire");
1428         require(oldLock.amount > 0, "Must have something to withdraw");
1429 
1430         uint256 value = uint256(oldLock.amount);
1431 
1432         LockedBalance memory currentLock = LockedBalance({end: 0, amount: 0});
1433         locked[_addr] = currentLock;
1434 
1435         // oldLocked can have either expired <= timestamp or zero end
1436         // currentLock has only 0 end
1437         // Both can have >= 0 amount
1438         if(!expired){
1439             _checkpoint(_addr, oldLock, currentLock);
1440         }
1441 
1442         stakingToken.safeTransfer(_addr, value);
1443 
1444         emit Withdraw(_addr, value, block.timestamp);
1445     }
1446 
1447     /**
1448      * @dev Withdraws and consequently claims rewards for the sender
1449      */
1450     function exit()
1451         external
1452     {
1453         _withdraw(msg.sender);
1454         claimReward();
1455     }
1456 
1457     /**
1458      * @dev Ejects a user from the reward allocation, given their lock has freshly expired.
1459      * Leave it to the user to withdraw and claim their rewards.
1460      * @param _addr Address of the user
1461      */
1462     function eject(address _addr)
1463         external
1464         contractNotExpired
1465         lockupIsOver(_addr)
1466     {
1467         _withdraw(_addr);
1468 
1469         // solium-disable-next-line security/no-tx-origin
1470         emit Ejected(_addr, tx.origin, block.timestamp);
1471     }
1472 
1473     /**
1474      * @dev Ends the contract, unlocking all stakes.
1475      * No more staking can happen. Only withdraw and Claim.
1476      */
1477     function expireContract()
1478         external
1479         onlyGovernor
1480         contractNotExpired
1481         updateReward(address(0))
1482     {
1483         require(block.timestamp > periodFinish, "Period must be over");
1484 
1485         expired = true;
1486 
1487         emit Expired();
1488     }
1489 
1490 
1491 
1492     /***************************************
1493                     GETTERS
1494     ****************************************/
1495 
1496 
1497     /** @dev Floors a timestamp to the nearest weekly increment */
1498     function _floorToWeek(uint256 _t)
1499         internal
1500         pure
1501         returns(uint256)
1502     {
1503         return _t.div(WEEK).mul(WEEK);
1504     }
1505 
1506     /**
1507      * @dev Uses binarysearch to find the most recent point history preceeding block
1508      * @param _block Find the most recent point history before this block
1509      * @param _maxEpoch Do not search pointHistories past this index
1510      */
1511     function _findBlockEpoch(uint256 _block, uint256 _maxEpoch)
1512         internal
1513         view
1514         returns(uint256)
1515     {
1516         // Binary search
1517         uint256 min = 0;
1518         uint256 max = _maxEpoch;
1519         // Will be always enough for 128-bit numbers
1520         for(uint256 i = 0; i < 128; i++){
1521             if (min >= max)
1522                 break;
1523             uint256 mid = (min.add(max).add(1)).div(2);
1524             if (pointHistory[mid].blk <= _block){
1525                 min = mid;
1526             } else {
1527                 max = mid.sub(1);
1528             }
1529         }
1530         return min;
1531     }
1532 
1533     /**
1534      * @dev Uses binarysearch to find the most recent user point history preceeding block
1535      * @param _addr User for which to search
1536      * @param _block Find the most recent point history before this block
1537      */
1538     function _findUserBlockEpoch(address _addr, uint256 _block)
1539         internal
1540         view
1541         returns(uint256)
1542     {
1543         uint256 min = 0;
1544         uint256 max = userPointEpoch[_addr];
1545         for(uint256 i = 0; i < 128; i++) {
1546             if(min >= max){
1547                 break;
1548             }
1549             uint256 mid = (min.add(max).add(1)).div(2);
1550             if(userPointHistory[_addr][mid].blk <= _block){
1551                 min = mid;
1552             } else {
1553                 max = mid.sub(1);
1554             }
1555         }
1556         return min;
1557     }
1558 
1559     /**
1560      * @dev Gets curent user voting weight (aka effectiveStake)
1561      * @param _owner User for which to return the balance
1562      * @return uint256 Balance of user
1563      */
1564     function balanceOf(address _owner)
1565         public
1566         view
1567         returns (uint256)
1568     {
1569         uint256 epoch = userPointEpoch[_owner];
1570         if(epoch == 0){
1571             return 0;
1572         }
1573         Point memory lastPoint = userPointHistory[_owner][epoch];
1574         lastPoint.bias = lastPoint.bias.sub(lastPoint.slope.mul(int128(block.timestamp.sub(lastPoint.ts))));
1575         if(lastPoint.bias < 0) {
1576             lastPoint.bias = 0;
1577         }
1578         return uint256(lastPoint.bias);
1579     }
1580 
1581     /**
1582      * @dev Gets a users votingWeight at a given blockNumber
1583      * @param _owner User for which to return the balance
1584      * @param _blockNumber Block at which to calculate balance
1585      * @return uint256 Balance of user
1586      */
1587     function balanceOfAt(address _owner, uint256 _blockNumber)
1588         public
1589         view
1590         returns (uint256)
1591     {
1592         require(_blockNumber <= block.number, "Must pass block number in the past");
1593 
1594         // Get most recent user Point to block
1595         uint256 userEpoch = _findUserBlockEpoch(_owner, _blockNumber);
1596         if(userEpoch == 0){
1597             return 0;
1598         }
1599         Point memory upoint = userPointHistory[_owner][userEpoch];
1600 
1601         // Get most recent global Point to block
1602         uint256 maxEpoch = globalEpoch;
1603         uint256 epoch = _findBlockEpoch(_blockNumber, maxEpoch);
1604         Point memory point0 = pointHistory[epoch];
1605 
1606         // Calculate delta (block & time) between user Point and target block
1607         // Allowing us to calculate the average seconds per block between
1608         // the two points
1609         uint256 dBlock = 0;
1610         uint256 dTime = 0;
1611         if(epoch < maxEpoch){
1612             Point memory point1 = pointHistory[epoch.add(1)];
1613             dBlock = point1.blk.sub(point0.blk);
1614             dTime = point1.ts.sub(point0.ts);
1615         } else {
1616             dBlock = block.number.sub(point0.blk);
1617             dTime = block.timestamp.sub(point0.ts);
1618         }
1619         // (Deterministically) Estimate the time at which block _blockNumber was mined
1620         uint256 blockTime = point0.ts;
1621         if(dBlock != 0) {
1622             // blockTime += dTime * (_blockNumber - point0.blk) / dBlock;
1623             blockTime = blockTime.add(dTime.mul(_blockNumber.sub(point0.blk)).div(dBlock));
1624         }
1625         // Current Bias = most recent bias - (slope * time since update)
1626         upoint.bias = upoint.bias.sub(upoint.slope.mul(int128(blockTime.sub(upoint.ts))));
1627         if(upoint.bias >= 0){
1628             return uint256(upoint.bias);
1629         } else {
1630             return 0;
1631         }
1632     }
1633 
1634     /**
1635      * @dev Calculates total supply of votingWeight at a given time _t
1636      * @param _point Most recent point before time _t
1637      * @param _t Time at which to calculate supply
1638      * @return totalSupply at given point in time
1639      */
1640     function _supplyAt(Point memory _point, uint256 _t)
1641         internal
1642         view
1643         returns (uint256)
1644     {
1645         Point memory lastPoint = _point;
1646         // Floor the timestamp to weekly interval
1647         uint256 iterativeTime = _floorToWeek(lastPoint.ts);
1648         // Iterate through all weeks between _point & _t to account for slope changes
1649         for(uint256 i = 0; i < 255; i++){
1650             iterativeTime = iterativeTime.add(WEEK);
1651             int128 dSlope = 0;
1652             // If week end is after timestamp, then truncate & leave dSlope to 0
1653             if(iterativeTime > _t){
1654                 iterativeTime = _t;
1655             }
1656             // else get most recent slope change
1657             else {
1658                 dSlope = slopeChanges[iterativeTime];
1659             }
1660 
1661             // lastPoint.bias -= lastPoint.slope * convert(iterativeTime - lastPoint.ts, int128)
1662             lastPoint.bias = lastPoint.bias.sub(lastPoint.slope.mul(int128(iterativeTime.sub(lastPoint.ts))));
1663             if(iterativeTime == _t){
1664                 break;
1665             }
1666             lastPoint.slope = lastPoint.slope.add(dSlope);
1667             lastPoint.ts = iterativeTime;
1668         }
1669 
1670         if (lastPoint.bias < 0){
1671             lastPoint.bias = 0;
1672         }
1673         return uint256(lastPoint.bias);
1674     }
1675 
1676     /**
1677      * @dev Calculates current total supply of votingWeight
1678      * @return totalSupply of voting token weight
1679      */
1680     function totalSupply()
1681         public
1682         view
1683         returns (uint256)
1684     {
1685         uint256 epoch_ = globalEpoch;
1686         Point memory lastPoint = pointHistory[epoch_];
1687         return _supplyAt(lastPoint, block.timestamp);
1688     }
1689 
1690     /**
1691      * @dev Calculates total supply of votingWeight at a given blockNumber
1692      * @param _blockNumber Block number at which to calculate total supply
1693      * @return totalSupply of voting token weight at the given blockNumber
1694      */
1695     function totalSupplyAt(uint256 _blockNumber)
1696         public
1697         view
1698         returns (uint256)
1699     {
1700         require(_blockNumber <= block.number, "Must pass block number in the past");
1701 
1702         uint256 epoch = globalEpoch;
1703         uint256 targetEpoch = _findBlockEpoch(_blockNumber, epoch);
1704 
1705         Point memory point = pointHistory[targetEpoch];
1706 
1707         // If point.blk > _blockNumber that means we got the initial epoch & contract did not yet exist
1708         if(point.blk > _blockNumber){
1709             return 0;
1710         }
1711 
1712         uint256 dTime = 0;
1713         if(targetEpoch < epoch){
1714             Point memory pointNext = pointHistory[targetEpoch.add(1)];
1715             if(point.blk != pointNext.blk) {
1716                 dTime = (_blockNumber.sub(point.blk)).mul(pointNext.ts.sub(point.ts)).div(pointNext.blk.sub(point.blk));
1717             }
1718         } else if (point.blk != block.number){
1719             dTime = (_blockNumber.sub(point.blk)).mul(block.timestamp.sub(point.ts)).div(block.number.sub(point.blk));
1720         }
1721         // Now dTime contains info on how far are we beyond point
1722 
1723         return _supplyAt(point, point.ts.add(dTime));
1724     }
1725 
1726 
1727     /***************************************
1728                     REWARDS
1729     ****************************************/
1730 
1731     /** @dev Updates the reward for a given address, before executing function */
1732     modifier updateReward(address _account) {
1733         // Setting of global vars
1734         uint256 newRewardPerToken = rewardPerToken();
1735         // If statement protects against loss in initialisation case
1736         if(newRewardPerToken > 0) {
1737             rewardPerTokenStored = newRewardPerToken;
1738             lastUpdateTime = lastTimeRewardApplicable();
1739             // Setting of personal vars based on new globals
1740             if (_account != address(0)) {
1741                 rewards[_account] = earned(_account);
1742                 userRewardPerTokenPaid[_account] = newRewardPerToken;
1743             }
1744         }
1745         _;
1746     }
1747 
1748     /**
1749      * @dev Claims outstanding rewards for the sender.
1750      * First updates outstanding reward allocation and then transfers.
1751      */
1752     function claimReward()
1753         public
1754         updateReward(msg.sender)
1755     {
1756         uint256 reward = rewards[msg.sender];
1757         if (reward > 0) {
1758             rewards[msg.sender] = 0;
1759             stakingToken.safeTransfer(msg.sender, reward);
1760             rewardsPaid[msg.sender] = rewardsPaid[msg.sender].add(reward);
1761             emit RewardPaid(msg.sender, reward);
1762         }
1763     }
1764 
1765 
1766     /***************************************
1767                 REWARDS - GETTERS
1768     ****************************************/
1769 
1770     /**
1771      * @dev Gets the most recent Static Balance (bias) for a user
1772      * @param _addr User for which to retrieve static balance
1773      * @return uint256 balance
1774      */
1775     function staticBalanceOf(address _addr)
1776         public
1777         view
1778         returns (uint256)
1779     {
1780         uint256 uepoch = userPointEpoch[_addr];
1781         if(uepoch == 0 || userPointHistory[_addr][uepoch].bias == 0){
1782             return 0;
1783         }
1784         return _staticBalance(userPointHistory[_addr][uepoch].slope, userPointHistory[_addr][uepoch].ts, locked[_addr].end);
1785     }
1786 
1787     function _staticBalance(int128 _slope, uint256 _startTime, uint256 _endTime)
1788         internal
1789         pure
1790         returns (uint256)
1791     {
1792         if(_startTime > _endTime) return 0;
1793         // get lockup length (end - point.ts)
1794         uint256 lockupLength = _endTime.sub(_startTime);
1795         // s = amount * sqrt(length)
1796         uint256 s = uint256(_slope.mul(10000)).mul(Root.sqrt(lockupLength));
1797         return s;
1798     }
1799 
1800     /**
1801      * @dev Gets the RewardsToken
1802      */
1803     function getRewardToken()
1804         external
1805         view
1806         returns (IERC20)
1807     {
1808         return stakingToken;
1809     }
1810 
1811     /**
1812      * @dev Gets the duration of the rewards period
1813      */
1814     function getDuration()
1815         external
1816         pure
1817         returns (uint256)
1818     {
1819         return WEEK;
1820     }
1821 
1822     /**
1823      * @dev Gets the last applicable timestamp for this reward period
1824      */
1825     function lastTimeRewardApplicable()
1826         public
1827         view
1828         returns (uint256)
1829     {
1830         return StableMath.min(block.timestamp, periodFinish);
1831     }
1832 
1833     /**
1834      * @dev Calculates the amount of unclaimed rewards per token since last update,
1835      * and sums with stored to give the new cumulative reward per token
1836      * @return 'Reward' per staked token
1837      */
1838     function rewardPerToken()
1839         public
1840         view
1841         returns (uint256)
1842     {
1843         // If there is no StakingToken liquidity, avoid div(0)
1844         uint256 totalStatic = totalStaticWeight;
1845         if (totalStatic == 0) {
1846             return rewardPerTokenStored;
1847         }
1848         // new reward units to distribute = rewardRate * timeSinceLastUpdate
1849         uint256 rewardUnitsToDistribute = rewardRate.mul(lastTimeRewardApplicable().sub(lastUpdateTime));
1850         // new reward units per token = (rewardUnitsToDistribute * 1e18) / totalTokens
1851         uint256 unitsToDistributePerToken = rewardUnitsToDistribute.divPrecisely(totalStatic);
1852         // return summed rate
1853         return rewardPerTokenStored.add(unitsToDistributePerToken);
1854     }
1855 
1856     /**
1857      * @dev Calculates the amount of unclaimed rewards a user has earned
1858      * @param _addr User address
1859      * @return Total reward amount earned
1860      */
1861     function earned(address _addr)
1862         public
1863         view
1864         returns (uint256)
1865     {
1866         // current rate per token - rate user previously received
1867         uint256 userRewardDelta = rewardPerToken().sub(userRewardPerTokenPaid[_addr]);
1868         // new reward = staked tokens * difference in rate
1869         uint256 userNewReward = staticBalanceOf(_addr).mulTruncate(userRewardDelta);
1870         // add to previous rewards
1871         return rewards[_addr].add(userNewReward);
1872     }
1873 
1874 
1875     /***************************************
1876                 REWARDS - ADMIN
1877     ****************************************/
1878 
1879     /**
1880      * @dev Notifies the contract that new rewards have been added.
1881      * Calculates an updated rewardRate based on the rewards in period.
1882      * @param _reward Units of RewardToken that have been added to the pool
1883      */
1884     function notifyRewardAmount(uint256 _reward)
1885         external
1886         onlyRewardsDistributor
1887         contractNotExpired
1888         updateReward(address(0))
1889     {
1890         uint256 currentTime = block.timestamp;
1891         // If previous period over, reset rewardRate
1892         if (currentTime >= periodFinish) {
1893             rewardRate = _reward.div(WEEK);
1894         }
1895         // If additional reward to existing period, calc sum
1896         else {
1897             uint256 remaining = periodFinish.sub(currentTime);
1898             uint256 leftover = remaining.mul(rewardRate);
1899             rewardRate = _reward.add(leftover).div(WEEK);
1900         }
1901 
1902         lastUpdateTime = currentTime;
1903         periodFinish = currentTime.add(WEEK);
1904 
1905         emit RewardAdded(_reward);
1906     }
1907 }