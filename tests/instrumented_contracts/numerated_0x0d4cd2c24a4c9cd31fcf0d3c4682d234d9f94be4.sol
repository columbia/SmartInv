1 pragma solidity 0.5.16;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see {ERC20Detailed}.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      *
131      * _Available since v2.4.0._
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following 
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258         // for accounts without code, i.e. `keccak256('')`
259         bytes32 codehash;
260         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { codehash := extcodehash(account) }
263         return (codehash != accountHash && codehash != 0x0);
264     }
265 
266     /**
267      * @dev Converts an `address` into `address payable`. Note that this is
268      * simply a type cast: the actual underlying value is not changed.
269      *
270      * _Available since v2.4.0._
271      */
272     function toPayable(address account) internal pure returns (address payable) {
273         return address(uint160(account));
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      *
292      * _Available since v2.4.0._
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-call-value
298         (bool success, ) = recipient.call.value(amount)("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 }
302 
303 library SafeERC20 {
304     using SafeMath for uint256;
305     using Address for address;
306 
307     function safeTransfer(IERC20 token, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
309     }
310 
311     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
312         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
313     }
314 
315     function safeApprove(IERC20 token, address spender, uint256 value) internal {
316         // safeApprove should only be called when setting an initial allowance,
317         // or when resetting it to zero. To increase and decrease it, use
318         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
319         // solhint-disable-next-line max-line-length
320         require((value == 0) || (token.allowance(address(this), spender) == 0),
321             "SafeERC20: approve from non-zero to non-zero allowance"
322         );
323         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
324     }
325 
326     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
327         uint256 newAllowance = token.allowance(address(this), spender).add(value);
328         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329     }
330 
331     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
332         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
333         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
334     }
335 
336     /**
337      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
338      * on the return value: the return value is optional (but if data is returned, it must not be false).
339      * @param token The token targeted by the call.
340      * @param data The call data (encoded using abi.encode or one of its variants).
341      */
342     function callOptionalReturn(IERC20 token, bytes memory data) private {
343         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
344         // we're implementing it ourselves.
345 
346         // A Solidity high level call has three parts:
347         //  1. The target address is checked to verify it contains contract code
348         //  2. The call itself is made, and success asserted
349         //  3. The return value is decoded, which in turn checks the size of the returned data.
350         // solhint-disable-next-line max-line-length
351         require(address(token).isContract(), "SafeERC20: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = address(token).call(data);
355         require(success, "SafeERC20: low-level call failed");
356 
357         if (returndata.length > 0) { // Return data is optional
358             // solhint-disable-next-line max-line-length
359             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
360         }
361     }
362 }
363 
364 contract ReentrancyGuard {
365     bool private _notEntered;
366 
367     constructor () internal {
368         // Storing an initial non-zero value makes deployment a bit more
369         // expensive, but in exchange the refund on every call to nonReentrant
370         // will be lower in amount. Since refunds are capped to a percetange of
371         // the total transaction's gas, it is best to keep them low in cases
372         // like this one, to increase the likelihood of the full refund coming
373         // into effect.
374         _notEntered = true;
375     }
376 
377     /**
378      * @dev Prevents a contract from calling itself, directly or indirectly.
379      * Calling a `nonReentrant` function from another `nonReentrant`
380      * function is not supported. It is possible to prevent this from happening
381      * by making the `nonReentrant` function external, and make it call a
382      * `private` function that does the actual work.
383      */
384     modifier nonReentrant() {
385         // On the first call to nonReentrant, _notEntered will be true
386         require(_notEntered, "ReentrancyGuard: reentrant call");
387 
388         // Any calls to nonReentrant after this point will fail
389         _notEntered = false;
390 
391         _;
392 
393         // By storing the original value once again, a refund is triggered (see
394         // https://eips.ethereum.org/EIPS/eip-2200)
395         _notEntered = true;
396     }
397 }
398 
399 contract StakingTokenWrapper is ReentrancyGuard {
400 
401     using SafeMath for uint256;
402     using SafeERC20 for IERC20;
403 
404     IERC20 public stakingToken;
405 
406     uint256 private _totalSupply;
407     mapping(address => uint256) private _balances;
408 
409     /**
410      * @dev TokenWrapper constructor
411      * @param _stakingToken Wrapped token to be staked
412      */
413     constructor(address _stakingToken) internal {
414         stakingToken = IERC20(_stakingToken);
415     }
416 
417     /**
418      * @dev Get the total amount of the staked token
419      * @return uint256 total supply
420      */
421     function totalSupply()
422         public
423         view
424         returns (uint256)
425     {
426         return _totalSupply;
427     }
428 
429     /**
430      * @dev Get the balance of a given account
431      * @param _account User for which to retrieve balance
432      */
433     function balanceOf(address _account)
434         public
435         view
436         returns (uint256)
437     {
438         return _balances[_account];
439     }
440 
441     /**
442      * @dev Deposits a given amount of StakingToken from sender
443      * @param _amount Units of StakingToken
444      */
445     function _stake(address _beneficiary, uint256 _amount)
446         internal
447         nonReentrant
448     {
449         _totalSupply = _totalSupply.add(_amount);
450         _balances[_beneficiary] = _balances[_beneficiary].add(_amount);
451         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
452     }
453 
454     /**
455      * @dev Withdraws a given stake from sender
456      * @param _amount Units of StakingToken
457      */
458     function _withdraw(uint256 _amount)
459         internal
460         nonReentrant
461     {
462         _totalSupply = _totalSupply.sub(_amount);
463         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
464         stakingToken.safeTransfer(msg.sender, _amount);
465     }
466 }
467 
468 contract ModuleKeys {
469 
470     // Governance
471     // ===========
472                                                 // Phases
473     // keccak256("Governance");                 // 2.x
474     bytes32 internal constant KEY_GOVERNANCE = 0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
475     //keccak256("Staking");                     // 1.2
476     bytes32 internal constant KEY_STAKING = 0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
477     //keccak256("ProxyAdmin");                  // 1.0
478     bytes32 internal constant KEY_PROXY_ADMIN = 0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;
479 
480     // mStable
481     // =======
482     // keccak256("OracleHub");                  // 1.2
483     bytes32 internal constant KEY_ORACLE_HUB = 0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
484     // keccak256("Manager");                    // 1.2
485     bytes32 internal constant KEY_MANAGER = 0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
486     //keccak256("Recollateraliser");            // 2.x
487     bytes32 internal constant KEY_RECOLLATERALISER = 0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
488     //keccak256("MetaToken");                   // 1.1
489     bytes32 internal constant KEY_META_TOKEN = 0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
490     // keccak256("SavingsManager");             // 1.0
491     bytes32 internal constant KEY_SAVINGS_MANAGER = 0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
492 }
493 
494 interface INexus {
495     function governor() external view returns (address);
496     function getModule(bytes32 key) external view returns (address);
497 
498     function proposeModule(bytes32 _key, address _addr) external;
499     function cancelProposedModule(bytes32 _key) external;
500     function acceptProposedModule(bytes32 _key) external;
501     function acceptProposedModules(bytes32[] calldata _keys) external;
502 
503     function requestLockModule(bytes32 _key) external;
504     function cancelLockModule(bytes32 _key) external;
505     function lockModule(bytes32 _key) external;
506 }
507 
508 contract Module is ModuleKeys {
509 
510     INexus public nexus;
511 
512     /**
513      * @dev Initialises the Module by setting publisher addresses,
514      *      and reading all available system module information
515      */
516     constructor(address _nexus) internal {
517         require(_nexus != address(0), "Nexus is zero address");
518         nexus = INexus(_nexus);
519     }
520 
521     /**
522      * @dev Modifier to allow function calls only from the Governor.
523      */
524     modifier onlyGovernor() {
525         require(msg.sender == _governor(), "Only governor can execute");
526         _;
527     }
528 
529     /**
530      * @dev Modifier to allow function calls only from the Governance.
531      *      Governance is either Governor address or Governance address.
532      */
533     modifier onlyGovernance() {
534         require(
535             msg.sender == _governor() || msg.sender == _governance(),
536             "Only governance can execute"
537         );
538         _;
539     }
540 
541     /**
542      * @dev Modifier to allow function calls only from the ProxyAdmin.
543      */
544     modifier onlyProxyAdmin() {
545         require(
546             msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"
547         );
548         _;
549     }
550 
551     /**
552      * @dev Modifier to allow function calls only from the Manager.
553      */
554     modifier onlyManager() {
555         require(msg.sender == _manager(), "Only manager can execute");
556         _;
557     }
558 
559     /**
560      * @dev Returns Governor address from the Nexus
561      * @return Address of Governor Contract
562      */
563     function _governor() internal view returns (address) {
564         return nexus.governor();
565     }
566 
567     /**
568      * @dev Returns Governance Module address from the Nexus
569      * @return Address of the Governance (Phase 2)
570      */
571     function _governance() internal view returns (address) {
572         return nexus.getModule(KEY_GOVERNANCE);
573     }
574 
575     /**
576      * @dev Return Staking Module address from the Nexus
577      * @return Address of the Staking Module contract
578      */
579     function _staking() internal view returns (address) {
580         return nexus.getModule(KEY_STAKING);
581     }
582 
583     /**
584      * @dev Return ProxyAdmin Module address from the Nexus
585      * @return Address of the ProxyAdmin Module contract
586      */
587     function _proxyAdmin() internal view returns (address) {
588         return nexus.getModule(KEY_PROXY_ADMIN);
589     }
590 
591     /**
592      * @dev Return MetaToken Module address from the Nexus
593      * @return Address of the MetaToken Module contract
594      */
595     function _metaToken() internal view returns (address) {
596         return nexus.getModule(KEY_META_TOKEN);
597     }
598 
599     /**
600      * @dev Return OracleHub Module address from the Nexus
601      * @return Address of the OracleHub Module contract
602      */
603     function _oracleHub() internal view returns (address) {
604         return nexus.getModule(KEY_ORACLE_HUB);
605     }
606 
607     /**
608      * @dev Return Manager Module address from the Nexus
609      * @return Address of the Manager Module contract
610      */
611     function _manager() internal view returns (address) {
612         return nexus.getModule(KEY_MANAGER);
613     }
614 
615     /**
616      * @dev Return SavingsManager Module address from the Nexus
617      * @return Address of the SavingsManager Module contract
618      */
619     function _savingsManager() internal view returns (address) {
620         return nexus.getModule(KEY_SAVINGS_MANAGER);
621     }
622 
623     /**
624      * @dev Return Recollateraliser Module address from the Nexus
625      * @return  Address of the Recollateraliser Module contract (Phase 2)
626      */
627     function _recollateraliser() internal view returns (address) {
628         return nexus.getModule(KEY_RECOLLATERALISER);
629     }
630 }
631 
632 interface IRewardsDistributionRecipient {
633     function notifyRewardAmount(uint256 reward) external;
634     function getRewardToken() external view returns (IERC20);
635 }
636 
637 contract RewardsDistributionRecipient is IRewardsDistributionRecipient, Module {
638 
639     // @abstract
640     function notifyRewardAmount(uint256 reward) external;
641     function getRewardToken() external view returns (IERC20);
642 
643     // This address has the ability to distribute the rewards
644     address public rewardsDistributor;
645 
646     /** @dev Recipient is a module, governed by mStable governance */
647     constructor(address _nexus, address _rewardsDistributor)
648         internal
649         Module(_nexus)
650     {
651         rewardsDistributor = _rewardsDistributor;
652     }
653 
654     /**
655      * @dev Only the rewards distributor can notify about rewards
656      */
657     modifier onlyRewardsDistributor() {
658         require(msg.sender == rewardsDistributor, "Caller is not reward distributor");
659         _;
660     }
661 
662     /**
663      * @dev Change the rewardsDistributor - only called by mStable governor
664      * @param _rewardsDistributor   Address of the new distributor
665      */
666     function setRewardsDistribution(address _rewardsDistributor)
667         external
668         onlyGovernor
669     {
670         rewardsDistributor = _rewardsDistributor;
671     }
672 }
673 
674 library StableMath {
675 
676     using SafeMath for uint256;
677 
678     /**
679      * @dev Scaling unit for use in specific calculations,
680      * where 1 * 10**18, or 1e18 represents a unit '1'
681      */
682     uint256 private constant FULL_SCALE = 1e18;
683 
684     /**
685      * @notice Token Ratios are used when converting between units of bAsset, mAsset and MTA
686      * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
687      * @dev bAsset ratio unit for use in exact calculations,
688      * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
689      */
690     uint256 private constant RATIO_SCALE = 1e8;
691 
692     /**
693      * @dev Provides an interface to the scaling unit
694      * @return Scaling unit (1e18 or 1 * 10**18)
695      */
696     function getFullScale() internal pure returns (uint256) {
697         return FULL_SCALE;
698     }
699 
700     /**
701      * @dev Provides an interface to the ratio unit
702      * @return Ratio scale unit (1e8 or 1 * 10**8)
703      */
704     function getRatioScale() internal pure returns (uint256) {
705         return RATIO_SCALE;
706     }
707 
708     /**
709      * @dev Scales a given integer to the power of the full scale.
710      * @param x   Simple uint256 to scale
711      * @return    Scaled value a to an exact number
712      */
713     function scaleInteger(uint256 x)
714         internal
715         pure
716         returns (uint256)
717     {
718         return x.mul(FULL_SCALE);
719     }
720 
721     /***************************************
722               PRECISE ARITHMETIC
723     ****************************************/
724 
725     /**
726      * @dev Multiplies two precise units, and then truncates by the full scale
727      * @param x     Left hand input to multiplication
728      * @param y     Right hand input to multiplication
729      * @return      Result after multiplying the two inputs and then dividing by the shared
730      *              scale unit
731      */
732     function mulTruncate(uint256 x, uint256 y)
733         internal
734         pure
735         returns (uint256)
736     {
737         return mulTruncateScale(x, y, FULL_SCALE);
738     }
739 
740     /**
741      * @dev Multiplies two precise units, and then truncates by the given scale. For example,
742      * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
743      * @param x     Left hand input to multiplication
744      * @param y     Right hand input to multiplication
745      * @param scale Scale unit
746      * @return      Result after multiplying the two inputs and then dividing by the shared
747      *              scale unit
748      */
749     function mulTruncateScale(uint256 x, uint256 y, uint256 scale)
750         internal
751         pure
752         returns (uint256)
753     {
754         // e.g. assume scale = fullScale
755         // z = 10e18 * 9e17 = 9e36
756         uint256 z = x.mul(y);
757         // return 9e38 / 1e18 = 9e18
758         return z.div(scale);
759     }
760 
761     /**
762      * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
763      * @param x     Left hand input to multiplication
764      * @param y     Right hand input to multiplication
765      * @return      Result after multiplying the two inputs and then dividing by the shared
766      *              scale unit, rounded up to the closest base unit.
767      */
768     function mulTruncateCeil(uint256 x, uint256 y)
769         internal
770         pure
771         returns (uint256)
772     {
773         // e.g. 8e17 * 17268172638 = 138145381104e17
774         uint256 scaled = x.mul(y);
775         // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
776         uint256 ceil = scaled.add(FULL_SCALE.sub(1));
777         // e.g. 13814538111.399...e18 / 1e18 = 13814538111
778         return ceil.div(FULL_SCALE);
779     }
780 
781     /**
782      * @dev Precisely divides two units, by first scaling the left hand operand. Useful
783      *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
784      * @param x     Left hand input to division
785      * @param y     Right hand input to division
786      * @return      Result after multiplying the left operand by the scale, and
787      *              executing the division on the right hand input.
788      */
789     function divPrecisely(uint256 x, uint256 y)
790         internal
791         pure
792         returns (uint256)
793     {
794         // e.g. 8e18 * 1e18 = 8e36
795         uint256 z = x.mul(FULL_SCALE);
796         // e.g. 8e36 / 10e18 = 8e17
797         return z.div(y);
798     }
799 
800 
801     /***************************************
802                   RATIO FUNCS
803     ****************************************/
804 
805     /**
806      * @dev Multiplies and truncates a token ratio, essentially flooring the result
807      *      i.e. How much mAsset is this bAsset worth?
808      * @param x     Left hand operand to multiplication (i.e Exact quantity)
809      * @param ratio bAsset ratio
810      * @return      Result after multiplying the two inputs and then dividing by the ratio scale
811      */
812     function mulRatioTruncate(uint256 x, uint256 ratio)
813         internal
814         pure
815         returns (uint256 c)
816     {
817         return mulTruncateScale(x, ratio, RATIO_SCALE);
818     }
819 
820     /**
821      * @dev Multiplies and truncates a token ratio, rounding up the result
822      *      i.e. How much mAsset is this bAsset worth?
823      * @param x     Left hand input to multiplication (i.e Exact quantity)
824      * @param ratio bAsset ratio
825      * @return      Result after multiplying the two inputs and then dividing by the shared
826      *              ratio scale, rounded up to the closest base unit.
827      */
828     function mulRatioTruncateCeil(uint256 x, uint256 ratio)
829         internal
830         pure
831         returns (uint256)
832     {
833         // e.g. How much mAsset should I burn for this bAsset (x)?
834         // 1e18 * 1e8 = 1e26
835         uint256 scaled = x.mul(ratio);
836         // 1e26 + 9.99e7 = 100..00.999e8
837         uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
838         // return 100..00.999e8 / 1e8 = 1e18
839         return ceil.div(RATIO_SCALE);
840     }
841 
842 
843     /**
844      * @dev Precisely divides two ratioed units, by first scaling the left hand operand
845      *      i.e. How much bAsset is this mAsset worth?
846      * @param x     Left hand operand in division
847      * @param ratio bAsset ratio
848      * @return      Result after multiplying the left operand by the scale, and
849      *              executing the division on the right hand input.
850      */
851     function divRatioPrecisely(uint256 x, uint256 ratio)
852         internal
853         pure
854         returns (uint256 c)
855     {
856         // e.g. 1e14 * 1e8 = 1e22
857         uint256 y = x.mul(RATIO_SCALE);
858         // return 1e22 / 1e12 = 1e10
859         return y.div(ratio);
860     }
861 
862     /***************************************
863                     HELPERS
864     ****************************************/
865 
866     /**
867      * @dev Calculates minimum of two numbers
868      * @param x     Left hand input
869      * @param y     Right hand input
870      * @return      Minimum of the two inputs
871      */
872     function min(uint256 x, uint256 y)
873         internal
874         pure
875         returns (uint256)
876     {
877         return x > y ? y : x;
878     }
879 
880     /**
881      * @dev Calculated maximum of two numbers
882      * @param x     Left hand input
883      * @param y     Right hand input
884      * @return      Maximum of the two inputs
885      */
886     function max(uint256 x, uint256 y)
887         internal
888         pure
889         returns (uint256)
890     {
891         return x > y ? x : y;
892     }
893 
894     /**
895      * @dev Clamps a value to an upper bound
896      * @param x           Left hand input
897      * @param upperBound  Maximum possible value to return
898      * @return            Input x clamped to a maximum value, upperBound
899      */
900     function clamp(uint256 x, uint256 upperBound)
901         internal
902         pure
903         returns (uint256)
904     {
905         return x > upperBound ? upperBound : x;
906     }
907 }
908 
909 // Internal
910 // Libs
911 /**
912  * @title  StakingRewards
913  * @author Originally: Synthetix (forked from /Synthetixio/synthetix/contracts/StakingRewards.sol)
914  *         Audit: https://github.com/sigp/public-audits/blob/master/synthetix/unipool/review.pdf
915  *         Changes by: Stability Labs Pty. Ltd.
916  * @notice Rewards stakers of a given LP token (a.k.a StakingToken) with RewardsToken, on a pro-rata basis
917  * @dev    Uses an ever increasing 'rewardPerTokenStored' variable to distribute rewards
918  * each time a write action is called in the contract. This allows for passive reward accrual.
919  *         Changes:
920  *           - Cosmetic (comments, readability)
921  *           - Addition of getRewardToken()
922  *           - Changing of `StakingTokenWrapper` funcs from `super.stake` to `_stake`
923  *           - Introduced a `stake(_beneficiary)` function to enable contract wrappers to stake on behalf
924  */
925 contract StakingRewards is StakingTokenWrapper, RewardsDistributionRecipient {
926 
927     using StableMath for uint256;
928 
929     IERC20 public rewardsToken;
930 
931     uint256 public constant DURATION = 7 days;
932 
933     // Timestamp for current period finish
934     uint256 public periodFinish = 0;
935     // RewardRate for the rest of the PERIOD
936     uint256 public rewardRate = 0;
937     // Last time any user took action
938     uint256 public lastUpdateTime = 0;
939     // Ever increasing rewardPerToken rate, based on % of total supply
940     uint256 public rewardPerTokenStored = 0;
941     mapping(address => uint256) public userRewardPerTokenPaid;
942     mapping(address => uint256) public rewards;
943 
944     event RewardAdded(uint256 reward);
945     event Staked(address indexed user, uint256 amount, address payer);
946     event Withdrawn(address indexed user, uint256 amount);
947     event RewardPaid(address indexed user, uint256 reward);
948 
949     /** @dev StakingRewards is a TokenWrapper and RewardRecipient */
950     constructor(
951         address _nexus,
952         address _stakingToken,
953         address _rewardsToken,
954         address _rewardsDistributor
955     )
956         public
957         StakingTokenWrapper(_stakingToken)
958         RewardsDistributionRecipient(_nexus, _rewardsDistributor)
959     {
960         rewardsToken = IERC20(_rewardsToken);
961     }
962 
963     /** @dev Updates the reward for a given address, before executing function */
964     modifier updateReward(address _account) {
965         // Setting of global vars
966         uint256 newRewardPerToken = rewardPerToken();
967         // If statement protects against loss in initialisation case
968         if(newRewardPerToken > 0) {
969             rewardPerTokenStored = newRewardPerToken;
970             lastUpdateTime = lastTimeRewardApplicable();
971             // Setting of personal vars based on new globals
972             if (_account != address(0)) {
973                 rewards[_account] = earned(_account);
974                 userRewardPerTokenPaid[_account] = newRewardPerToken;
975             }
976         }
977         _;
978     }
979 
980     /***************************************
981                     ACTIONS
982     ****************************************/
983 
984     /**
985      * @dev Stakes a given amount of the StakingToken for the sender
986      * @param _amount Units of StakingToken
987      */
988     function stake(uint256 _amount)
989         external
990     {
991         _stake(msg.sender, _amount);
992     }
993 
994     /**
995      * @dev Stakes a given amount of the StakingToken for a given beneficiary
996      * @param _beneficiary Staked tokens are credited to this address
997      * @param _amount      Units of StakingToken
998      */
999     function stake(address _beneficiary, uint256 _amount)
1000         external
1001     {
1002         _stake(_beneficiary, _amount);
1003     }
1004 
1005     /**
1006      * @dev Internally stakes an amount by depositing from sender,
1007      * and crediting to the specified beneficiary
1008      * @param _beneficiary Staked tokens are credited to this address
1009      * @param _amount      Units of StakingToken
1010      */
1011     function _stake(address _beneficiary, uint256 _amount)
1012         internal
1013         updateReward(_beneficiary)
1014     {
1015         require(_amount > 0, "Cannot stake 0");
1016         super._stake(_beneficiary, _amount);
1017         emit Staked(_beneficiary, _amount, msg.sender);
1018     }
1019 
1020     /**
1021      * @dev Withdraws stake from pool and claims any rewards
1022      */
1023     function exit() external {
1024         withdraw(balanceOf(msg.sender));
1025         claimReward();
1026     }
1027 
1028     /**
1029      * @dev Withdraws given stake amount from the pool
1030      * @param _amount Units of the staked token to withdraw
1031      */
1032     function withdraw(uint256 _amount)
1033         public
1034         updateReward(msg.sender)
1035     {
1036         require(_amount > 0, "Cannot withdraw 0");
1037         _withdraw(_amount);
1038         emit Withdrawn(msg.sender, _amount);
1039     }
1040 
1041     /**
1042      * @dev Claims outstanding rewards for the sender.
1043      * First updates outstanding reward allocation and then transfers.
1044      */
1045     function claimReward()
1046         public
1047         updateReward(msg.sender)
1048     {
1049         uint256 reward = rewards[msg.sender];
1050         if (reward > 0) {
1051             rewards[msg.sender] = 0;
1052             rewardsToken.transfer(msg.sender, reward);
1053             emit RewardPaid(msg.sender, reward);
1054         }
1055     }
1056 
1057 
1058     /***************************************
1059                     GETTERS
1060     ****************************************/
1061 
1062     /**
1063      * @dev Gets the RewardsToken
1064      */
1065     function getRewardToken()
1066         external
1067         view
1068         returns (IERC20)
1069     {
1070         return rewardsToken;
1071     }
1072 
1073     /**
1074      * @dev Gets the last applicable timestamp for this reward period
1075      */
1076     function lastTimeRewardApplicable()
1077         public
1078         view
1079         returns (uint256)
1080     {
1081         return StableMath.min(block.timestamp, periodFinish);
1082     }
1083 
1084     /**
1085      * @dev Calculates the amount of unclaimed rewards per token since last update,
1086      * and sums with stored to give the new cumulative reward per token
1087      * @return 'Reward' per staked token
1088      */
1089     function rewardPerToken()
1090         public
1091         view
1092         returns (uint256)
1093     {
1094         // If there is no StakingToken liquidity, avoid div(0)
1095         uint256 stakedTokens = totalSupply();
1096         if (stakedTokens == 0) {
1097             return rewardPerTokenStored;
1098         }
1099         // new reward units to distribute = rewardRate * timeSinceLastUpdate
1100         uint256 rewardUnitsToDistribute = rewardRate.mul(lastTimeRewardApplicable().sub(lastUpdateTime));
1101         // new reward units per token = (rewardUnitsToDistribute * 1e18) / totalTokens
1102         uint256 unitsToDistributePerToken = rewardUnitsToDistribute.divPrecisely(stakedTokens);
1103         // return summed rate
1104         return rewardPerTokenStored.add(unitsToDistributePerToken);
1105     }
1106 
1107     /**
1108      * @dev Calculates the amount of unclaimed rewards a user has earned
1109      * @param _account User address
1110      * @return Total reward amount earned
1111      */
1112     function earned(address _account)
1113         public
1114         view
1115         returns (uint256)
1116     {
1117         // current rate per token - rate user previously received
1118         uint256 userRewardDelta = rewardPerToken().sub(userRewardPerTokenPaid[_account]);
1119         // new reward = staked tokens * difference in rate
1120         uint256 userNewReward = balanceOf(_account).mulTruncate(userRewardDelta);
1121         // add to previous rewards
1122         return rewards[_account].add(userNewReward);
1123     }
1124 
1125 
1126     /***************************************
1127                     ADMIN
1128     ****************************************/
1129 
1130     /**
1131      * @dev Notifies the contract that new rewards have been added.
1132      * Calculates an updated rewardRate based on the rewards in period.
1133      * @param _reward Units of RewardToken that have been added to the pool
1134      */
1135     function notifyRewardAmount(uint256 _reward)
1136         external
1137         onlyRewardsDistributor
1138         updateReward(address(0))
1139     {
1140         uint256 currentTime = block.timestamp;
1141         // If previous period over, reset rewardRate
1142         if (currentTime >= periodFinish) {
1143             rewardRate = _reward.div(DURATION);
1144         }
1145         // If additional reward to existing period, calc sum
1146         else {
1147             uint256 remaining = periodFinish.sub(currentTime);
1148             uint256 leftover = remaining.mul(rewardRate);
1149             rewardRate = _reward.add(leftover).div(DURATION);
1150         }
1151 
1152         lastUpdateTime = currentTime;
1153         periodFinish = currentTime.add(DURATION);
1154 
1155         emit RewardAdded(_reward);
1156     }
1157     
1158     /**
1159      * @dev Collects the accumulated BAL token from the contract
1160      * @param _recipient Recipient to credit
1161      */
1162     function collectRewardToken(
1163         address _recipient
1164     )
1165         external
1166         onlyGovernor
1167     {
1168         // Official checksummed BAL token address
1169         // https://ethplorer.io/address/0xba100000625a3754423978a60c9317c58a424e3d
1170         IERC20 balToken = IERC20(0xba100000625a3754423978a60c9317c58a424e3D);
1171 
1172         uint256 balance = balToken.balanceOf(address(this));
1173 
1174         require(balToken.transfer(_recipient, balance), "Collection transfer failed");
1175     }
1176 }