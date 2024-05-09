1 pragma solidity 0.5.16;
2 
3 
4 contract ModuleKeys {
5 
6     // Governance
7     // ===========
8                                                 // Phases
9     // keccak256("Governance");                 // 2.x
10     bytes32 internal constant KEY_GOVERNANCE = 0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
11     //keccak256("Staking");                     // 1.2
12     bytes32 internal constant KEY_STAKING = 0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
13     //keccak256("ProxyAdmin");                  // 1.0
14     bytes32 internal constant KEY_PROXY_ADMIN = 0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;
15 
16     // mStable
17     // =======
18     // keccak256("OracleHub");                  // 1.2
19     bytes32 internal constant KEY_ORACLE_HUB = 0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
20     // keccak256("Manager");                    // 1.2
21     bytes32 internal constant KEY_MANAGER = 0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
22     //keccak256("Recollateraliser");            // 2.x
23     bytes32 internal constant KEY_RECOLLATERALISER = 0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
24     //keccak256("MetaToken");                   // 1.1
25     bytes32 internal constant KEY_META_TOKEN = 0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
26     // keccak256("SavingsManager");             // 1.0
27     bytes32 internal constant KEY_SAVINGS_MANAGER = 0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
28 }
29 
30 interface INexus {
31     function governor() external view returns (address);
32     function getModule(bytes32 key) external view returns (address);
33 
34     function proposeModule(bytes32 _key, address _addr) external;
35     function cancelProposedModule(bytes32 _key) external;
36     function acceptProposedModule(bytes32 _key) external;
37     function acceptProposedModules(bytes32[] calldata _keys) external;
38 
39     function requestLockModule(bytes32 _key) external;
40     function cancelLockModule(bytes32 _key) external;
41     function lockModule(bytes32 _key) external;
42 }
43 
44 contract Module is ModuleKeys {
45 
46     INexus public nexus;
47 
48     /**
49      * @dev Initialises the Module by setting publisher addresses,
50      *      and reading all available system module information
51      */
52     constructor(address _nexus) internal {
53         require(_nexus != address(0), "Nexus is zero address");
54         nexus = INexus(_nexus);
55     }
56 
57     /**
58      * @dev Modifier to allow function calls only from the Governor.
59      */
60     modifier onlyGovernor() {
61         require(msg.sender == _governor(), "Only governor can execute");
62         _;
63     }
64 
65     /**
66      * @dev Modifier to allow function calls only from the Governance.
67      *      Governance is either Governor address or Governance address.
68      */
69     modifier onlyGovernance() {
70         require(
71             msg.sender == _governor() || msg.sender == _governance(),
72             "Only governance can execute"
73         );
74         _;
75     }
76 
77     /**
78      * @dev Modifier to allow function calls only from the ProxyAdmin.
79      */
80     modifier onlyProxyAdmin() {
81         require(
82             msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"
83         );
84         _;
85     }
86 
87     /**
88      * @dev Modifier to allow function calls only from the Manager.
89      */
90     modifier onlyManager() {
91         require(msg.sender == _manager(), "Only manager can execute");
92         _;
93     }
94 
95     /**
96      * @dev Returns Governor address from the Nexus
97      * @return Address of Governor Contract
98      */
99     function _governor() internal view returns (address) {
100         return nexus.governor();
101     }
102 
103     /**
104      * @dev Returns Governance Module address from the Nexus
105      * @return Address of the Governance (Phase 2)
106      */
107     function _governance() internal view returns (address) {
108         return nexus.getModule(KEY_GOVERNANCE);
109     }
110 
111     /**
112      * @dev Return Staking Module address from the Nexus
113      * @return Address of the Staking Module contract
114      */
115     function _staking() internal view returns (address) {
116         return nexus.getModule(KEY_STAKING);
117     }
118 
119     /**
120      * @dev Return ProxyAdmin Module address from the Nexus
121      * @return Address of the ProxyAdmin Module contract
122      */
123     function _proxyAdmin() internal view returns (address) {
124         return nexus.getModule(KEY_PROXY_ADMIN);
125     }
126 
127     /**
128      * @dev Return MetaToken Module address from the Nexus
129      * @return Address of the MetaToken Module contract
130      */
131     function _metaToken() internal view returns (address) {
132         return nexus.getModule(KEY_META_TOKEN);
133     }
134 
135     /**
136      * @dev Return OracleHub Module address from the Nexus
137      * @return Address of the OracleHub Module contract
138      */
139     function _oracleHub() internal view returns (address) {
140         return nexus.getModule(KEY_ORACLE_HUB);
141     }
142 
143     /**
144      * @dev Return Manager Module address from the Nexus
145      * @return Address of the Manager Module contract
146      */
147     function _manager() internal view returns (address) {
148         return nexus.getModule(KEY_MANAGER);
149     }
150 
151     /**
152      * @dev Return SavingsManager Module address from the Nexus
153      * @return Address of the SavingsManager Module contract
154      */
155     function _savingsManager() internal view returns (address) {
156         return nexus.getModule(KEY_SAVINGS_MANAGER);
157     }
158 
159     /**
160      * @dev Return Recollateraliser Module address from the Nexus
161      * @return  Address of the Recollateraliser Module contract (Phase 2)
162      */
163     function _recollateraliser() internal view returns (address) {
164         return nexus.getModule(KEY_RECOLLATERALISER);
165     }
166 }
167 
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 interface IRewardsDistributionRecipient {
240     function notifyRewardAmount(uint256 reward) external;
241     function getRewardToken() external view returns (IERC20);
242 }
243 
244 contract RewardsDistributionRecipient is IRewardsDistributionRecipient, Module {
245 
246     // @abstract
247     function notifyRewardAmount(uint256 reward) external;
248     function getRewardToken() external view returns (IERC20);
249 
250     // This address has the ability to distribute the rewards
251     address public rewardsDistributor;
252 
253     /** @dev Recipient is a module, governed by mStable governance */
254     constructor(address _nexus, address _rewardsDistributor)
255         internal
256         Module(_nexus)
257     {
258         rewardsDistributor = _rewardsDistributor;
259     }
260 
261     /**
262      * @dev Only the rewards distributor can notify about rewards
263      */
264     modifier onlyRewardsDistributor() {
265         require(msg.sender == rewardsDistributor, "Caller is not reward distributor");
266         _;
267     }
268 
269     /**
270      * @dev Change the rewardsDistributor - only called by mStable governor
271      * @param _rewardsDistributor   Address of the new distributor
272      */
273     function setRewardsDistribution(address _rewardsDistributor)
274         external
275         onlyGovernor
276     {
277         rewardsDistributor = _rewardsDistributor;
278     }
279 }
280 
281 /**
282  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
283  * the optional functions; to access them see {ERC20Detailed}.
284  */
285 
286 /**
287  * @dev Wrappers over Solidity's arithmetic operations with added overflow
288  * checks.
289  *
290  * Arithmetic operations in Solidity wrap on overflow. This can easily result
291  * in bugs, because programmers usually assume that an overflow raises an
292  * error, which is the standard behavior in high level programming languages.
293  * `SafeMath` restores this intuition by reverting the transaction when an
294  * operation overflows.
295  *
296  * Using this library instead of the unchecked operations eliminates an entire
297  * class of bugs, so it's recommended to use it always.
298  */
299 library SafeMath {
300     /**
301      * @dev Returns the addition of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `+` operator.
305      *
306      * Requirements:
307      * - Addition cannot overflow.
308      */
309     function add(uint256 a, uint256 b) internal pure returns (uint256) {
310         uint256 c = a + b;
311         require(c >= a, "SafeMath: addition overflow");
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the subtraction of two unsigned integers, reverting on
318      * overflow (when the result is negative).
319      *
320      * Counterpart to Solidity's `-` operator.
321      *
322      * Requirements:
323      * - Subtraction cannot overflow.
324      */
325     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326         return sub(a, b, "SafeMath: subtraction overflow");
327     }
328 
329     /**
330      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
331      * overflow (when the result is negative).
332      *
333      * Counterpart to Solidity's `-` operator.
334      *
335      * Requirements:
336      * - Subtraction cannot overflow.
337      *
338      * _Available since v2.4.0._
339      */
340     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b <= a, errorMessage);
342         uint256 c = a - b;
343 
344         return c;
345     }
346 
347     /**
348      * @dev Returns the multiplication of two unsigned integers, reverting on
349      * overflow.
350      *
351      * Counterpart to Solidity's `*` operator.
352      *
353      * Requirements:
354      * - Multiplication cannot overflow.
355      */
356     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
357         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
358         // benefit is lost if 'b' is also tested.
359         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
360         if (a == 0) {
361             return 0;
362         }
363 
364         uint256 c = a * b;
365         require(c / a == b, "SafeMath: multiplication overflow");
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the integer division of two unsigned integers. Reverts on
372      * division by zero. The result is rounded towards zero.
373      *
374      * Counterpart to Solidity's `/` operator. Note: this function uses a
375      * `revert` opcode (which leaves remaining gas untouched) while Solidity
376      * uses an invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      * - The divisor cannot be zero.
380      */
381     function div(uint256 a, uint256 b) internal pure returns (uint256) {
382         return div(a, b, "SafeMath: division by zero");
383     }
384 
385     /**
386      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
387      * division by zero. The result is rounded towards zero.
388      *
389      * Counterpart to Solidity's `/` operator. Note: this function uses a
390      * `revert` opcode (which leaves remaining gas untouched) while Solidity
391      * uses an invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      * - The divisor cannot be zero.
395      *
396      * _Available since v2.4.0._
397      */
398     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
399         // Solidity only automatically asserts when dividing by 0
400         require(b > 0, errorMessage);
401         uint256 c = a / b;
402         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
403 
404         return c;
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
409      * Reverts when dividing by zero.
410      *
411      * Counterpart to Solidity's `%` operator. This function uses a `revert`
412      * opcode (which leaves remaining gas untouched) while Solidity uses an
413      * invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      * - The divisor cannot be zero.
417      */
418     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
419         return mod(a, b, "SafeMath: modulo by zero");
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * Reverts with custom message when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      * - The divisor cannot be zero.
432      *
433      * _Available since v2.4.0._
434      */
435     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
436         require(b != 0, errorMessage);
437         return a % b;
438     }
439 }
440 
441 /**
442  * @dev Collection of functions related to the address type
443  */
444 library Address {
445     /**
446      * @dev Returns true if `account` is a contract.
447      *
448      * [IMPORTANT]
449      * ====
450      * It is unsafe to assume that an address for which this function returns
451      * false is an externally-owned account (EOA) and not a contract.
452      *
453      * Among others, `isContract` will return false for the following 
454      * types of addresses:
455      *
456      *  - an externally-owned account
457      *  - a contract in construction
458      *  - an address where a contract will be created
459      *  - an address where a contract lived, but was destroyed
460      * ====
461      */
462     function isContract(address account) internal view returns (bool) {
463         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
464         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
465         // for accounts without code, i.e. `keccak256('')`
466         bytes32 codehash;
467         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
468         // solhint-disable-next-line no-inline-assembly
469         assembly { codehash := extcodehash(account) }
470         return (codehash != accountHash && codehash != 0x0);
471     }
472 
473     /**
474      * @dev Converts an `address` into `address payable`. Note that this is
475      * simply a type cast: the actual underlying value is not changed.
476      *
477      * _Available since v2.4.0._
478      */
479     function toPayable(address account) internal pure returns (address payable) {
480         return address(uint160(account));
481     }
482 
483     /**
484      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
485      * `recipient`, forwarding all available gas and reverting on errors.
486      *
487      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
488      * of certain opcodes, possibly making contracts go over the 2300 gas limit
489      * imposed by `transfer`, making them unable to receive funds via
490      * `transfer`. {sendValue} removes this limitation.
491      *
492      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
493      *
494      * IMPORTANT: because control is transferred to `recipient`, care must be
495      * taken to not create reentrancy vulnerabilities. Consider using
496      * {ReentrancyGuard} or the
497      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
498      *
499      * _Available since v2.4.0._
500      */
501     function sendValue(address payable recipient, uint256 amount) internal {
502         require(address(this).balance >= amount, "Address: insufficient balance");
503 
504         // solhint-disable-next-line avoid-call-value
505         (bool success, ) = recipient.call.value(amount)("");
506         require(success, "Address: unable to send value, recipient may have reverted");
507     }
508 }
509 
510 library SafeERC20 {
511     using SafeMath for uint256;
512     using Address for address;
513 
514     function safeTransfer(IERC20 token, address to, uint256 value) internal {
515         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
516     }
517 
518     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
519         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
520     }
521 
522     function safeApprove(IERC20 token, address spender, uint256 value) internal {
523         // safeApprove should only be called when setting an initial allowance,
524         // or when resetting it to zero. To increase and decrease it, use
525         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
526         // solhint-disable-next-line max-line-length
527         require((value == 0) || (token.allowance(address(this), spender) == 0),
528             "SafeERC20: approve from non-zero to non-zero allowance"
529         );
530         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
531     }
532 
533     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).add(value);
535         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
540         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     /**
544      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
545      * on the return value: the return value is optional (but if data is returned, it must not be false).
546      * @param token The token targeted by the call.
547      * @param data The call data (encoded using abi.encode or one of its variants).
548      */
549     function callOptionalReturn(IERC20 token, bytes memory data) private {
550         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
551         // we're implementing it ourselves.
552 
553         // A Solidity high level call has three parts:
554         //  1. The target address is checked to verify it contains contract code
555         //  2. The call itself is made, and success asserted
556         //  3. The return value is decoded, which in turn checks the size of the returned data.
557         // solhint-disable-next-line max-line-length
558         require(address(token).isContract(), "SafeERC20: call to non-contract");
559 
560         // solhint-disable-next-line avoid-low-level-calls
561         (bool success, bytes memory returndata) = address(token).call(data);
562         require(success, "SafeERC20: low-level call failed");
563 
564         if (returndata.length > 0) { // Return data is optional
565             // solhint-disable-next-line max-line-length
566             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
567         }
568     }
569 }
570 
571 contract ReentrancyGuard {
572     bool private _notEntered;
573 
574     constructor () internal {
575         // Storing an initial non-zero value makes deployment a bit more
576         // expensive, but in exchange the refund on every call to nonReentrant
577         // will be lower in amount. Since refunds are capped to a percetange of
578         // the total transaction's gas, it is best to keep them low in cases
579         // like this one, to increase the likelihood of the full refund coming
580         // into effect.
581         _notEntered = true;
582     }
583 
584     /**
585      * @dev Prevents a contract from calling itself, directly or indirectly.
586      * Calling a `nonReentrant` function from another `nonReentrant`
587      * function is not supported. It is possible to prevent this from happening
588      * by making the `nonReentrant` function external, and make it call a
589      * `private` function that does the actual work.
590      */
591     modifier nonReentrant() {
592         // On the first call to nonReentrant, _notEntered will be true
593         require(_notEntered, "ReentrancyGuard: reentrant call");
594 
595         // Any calls to nonReentrant after this point will fail
596         _notEntered = false;
597 
598         _;
599 
600         // By storing the original value once again, a refund is triggered (see
601         // https://eips.ethereum.org/EIPS/eip-2200)
602         _notEntered = true;
603     }
604 }
605 
606 contract StakingTokenWrapper is ReentrancyGuard {
607 
608     using SafeMath for uint256;
609     using SafeERC20 for IERC20;
610 
611     IERC20 public stakingToken;
612 
613     uint256 private _totalSupply;
614     mapping(address => uint256) private _balances;
615 
616     /**
617      * @dev TokenWrapper constructor
618      * @param _stakingToken Wrapped token to be staked
619      */
620     constructor(address _stakingToken) internal {
621         stakingToken = IERC20(_stakingToken);
622     }
623 
624     /**
625      * @dev Get the total amount of the staked token
626      * @return uint256 total supply
627      */
628     function totalSupply()
629         public
630         view
631         returns (uint256)
632     {
633         return _totalSupply;
634     }
635 
636     /**
637      * @dev Get the balance of a given account
638      * @param _account User for which to retrieve balance
639      */
640     function balanceOf(address _account)
641         public
642         view
643         returns (uint256)
644     {
645         return _balances[_account];
646     }
647 
648     /**
649      * @dev Deposits a given amount of StakingToken from sender
650      * @param _amount Units of StakingToken
651      */
652     function _stake(address _beneficiary, uint256 _amount)
653         internal
654         nonReentrant
655     {
656         _totalSupply = _totalSupply.add(_amount);
657         _balances[_beneficiary] = _balances[_beneficiary].add(_amount);
658         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
659     }
660 
661     /**
662      * @dev Withdraws a given stake from sender
663      * @param _amount Units of StakingToken
664      */
665     function _withdraw(uint256 _amount)
666         internal
667         nonReentrant
668     {
669         _totalSupply = _totalSupply.sub(_amount);
670         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
671         stakingToken.safeTransfer(msg.sender, _amount);
672     }
673 }
674 
675 library StableMath {
676 
677     using SafeMath for uint256;
678 
679     /**
680      * @dev Scaling unit for use in specific calculations,
681      * where 1 * 10**18, or 1e18 represents a unit '1'
682      */
683     uint256 private constant FULL_SCALE = 1e18;
684 
685     /**
686      * @notice Token Ratios are used when converting between units of bAsset, mAsset and MTA
687      * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
688      * @dev bAsset ratio unit for use in exact calculations,
689      * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
690      */
691     uint256 private constant RATIO_SCALE = 1e8;
692 
693     /**
694      * @dev Provides an interface to the scaling unit
695      * @return Scaling unit (1e18 or 1 * 10**18)
696      */
697     function getFullScale() internal pure returns (uint256) {
698         return FULL_SCALE;
699     }
700 
701     /**
702      * @dev Provides an interface to the ratio unit
703      * @return Ratio scale unit (1e8 or 1 * 10**8)
704      */
705     function getRatioScale() internal pure returns (uint256) {
706         return RATIO_SCALE;
707     }
708 
709     /**
710      * @dev Scales a given integer to the power of the full scale.
711      * @param x   Simple uint256 to scale
712      * @return    Scaled value a to an exact number
713      */
714     function scaleInteger(uint256 x)
715         internal
716         pure
717         returns (uint256)
718     {
719         return x.mul(FULL_SCALE);
720     }
721 
722     /***************************************
723               PRECISE ARITHMETIC
724     ****************************************/
725 
726     /**
727      * @dev Multiplies two precise units, and then truncates by the full scale
728      * @param x     Left hand input to multiplication
729      * @param y     Right hand input to multiplication
730      * @return      Result after multiplying the two inputs and then dividing by the shared
731      *              scale unit
732      */
733     function mulTruncate(uint256 x, uint256 y)
734         internal
735         pure
736         returns (uint256)
737     {
738         return mulTruncateScale(x, y, FULL_SCALE);
739     }
740 
741     /**
742      * @dev Multiplies two precise units, and then truncates by the given scale. For example,
743      * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
744      * @param x     Left hand input to multiplication
745      * @param y     Right hand input to multiplication
746      * @param scale Scale unit
747      * @return      Result after multiplying the two inputs and then dividing by the shared
748      *              scale unit
749      */
750     function mulTruncateScale(uint256 x, uint256 y, uint256 scale)
751         internal
752         pure
753         returns (uint256)
754     {
755         // e.g. assume scale = fullScale
756         // z = 10e18 * 9e17 = 9e36
757         uint256 z = x.mul(y);
758         // return 9e38 / 1e18 = 9e18
759         return z.div(scale);
760     }
761 
762     /**
763      * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
764      * @param x     Left hand input to multiplication
765      * @param y     Right hand input to multiplication
766      * @return      Result after multiplying the two inputs and then dividing by the shared
767      *              scale unit, rounded up to the closest base unit.
768      */
769     function mulTruncateCeil(uint256 x, uint256 y)
770         internal
771         pure
772         returns (uint256)
773     {
774         // e.g. 8e17 * 17268172638 = 138145381104e17
775         uint256 scaled = x.mul(y);
776         // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
777         uint256 ceil = scaled.add(FULL_SCALE.sub(1));
778         // e.g. 13814538111.399...e18 / 1e18 = 13814538111
779         return ceil.div(FULL_SCALE);
780     }
781 
782     /**
783      * @dev Precisely divides two units, by first scaling the left hand operand. Useful
784      *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
785      * @param x     Left hand input to division
786      * @param y     Right hand input to division
787      * @return      Result after multiplying the left operand by the scale, and
788      *              executing the division on the right hand input.
789      */
790     function divPrecisely(uint256 x, uint256 y)
791         internal
792         pure
793         returns (uint256)
794     {
795         // e.g. 8e18 * 1e18 = 8e36
796         uint256 z = x.mul(FULL_SCALE);
797         // e.g. 8e36 / 10e18 = 8e17
798         return z.div(y);
799     }
800 
801 
802     /***************************************
803                   RATIO FUNCS
804     ****************************************/
805 
806     /**
807      * @dev Multiplies and truncates a token ratio, essentially flooring the result
808      *      i.e. How much mAsset is this bAsset worth?
809      * @param x     Left hand operand to multiplication (i.e Exact quantity)
810      * @param ratio bAsset ratio
811      * @return      Result after multiplying the two inputs and then dividing by the ratio scale
812      */
813     function mulRatioTruncate(uint256 x, uint256 ratio)
814         internal
815         pure
816         returns (uint256 c)
817     {
818         return mulTruncateScale(x, ratio, RATIO_SCALE);
819     }
820 
821     /**
822      * @dev Multiplies and truncates a token ratio, rounding up the result
823      *      i.e. How much mAsset is this bAsset worth?
824      * @param x     Left hand input to multiplication (i.e Exact quantity)
825      * @param ratio bAsset ratio
826      * @return      Result after multiplying the two inputs and then dividing by the shared
827      *              ratio scale, rounded up to the closest base unit.
828      */
829     function mulRatioTruncateCeil(uint256 x, uint256 ratio)
830         internal
831         pure
832         returns (uint256)
833     {
834         // e.g. How much mAsset should I burn for this bAsset (x)?
835         // 1e18 * 1e8 = 1e26
836         uint256 scaled = x.mul(ratio);
837         // 1e26 + 9.99e7 = 100..00.999e8
838         uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
839         // return 100..00.999e8 / 1e8 = 1e18
840         return ceil.div(RATIO_SCALE);
841     }
842 
843 
844     /**
845      * @dev Precisely divides two ratioed units, by first scaling the left hand operand
846      *      i.e. How much bAsset is this mAsset worth?
847      * @param x     Left hand operand in division
848      * @param ratio bAsset ratio
849      * @return      Result after multiplying the left operand by the scale, and
850      *              executing the division on the right hand input.
851      */
852     function divRatioPrecisely(uint256 x, uint256 ratio)
853         internal
854         pure
855         returns (uint256 c)
856     {
857         // e.g. 1e14 * 1e8 = 1e22
858         uint256 y = x.mul(RATIO_SCALE);
859         // return 1e22 / 1e12 = 1e10
860         return y.div(ratio);
861     }
862 
863     /***************************************
864                     HELPERS
865     ****************************************/
866 
867     /**
868      * @dev Calculates minimum of two numbers
869      * @param x     Left hand input
870      * @param y     Right hand input
871      * @return      Minimum of the two inputs
872      */
873     function min(uint256 x, uint256 y)
874         internal
875         pure
876         returns (uint256)
877     {
878         return x > y ? y : x;
879     }
880 
881     /**
882      * @dev Calculated maximum of two numbers
883      * @param x     Left hand input
884      * @param y     Right hand input
885      * @return      Maximum of the two inputs
886      */
887     function max(uint256 x, uint256 y)
888         internal
889         pure
890         returns (uint256)
891     {
892         return x > y ? x : y;
893     }
894 
895     /**
896      * @dev Clamps a value to an upper bound
897      * @param x           Left hand input
898      * @param upperBound  Maximum possible value to return
899      * @return            Input x clamped to a maximum value, upperBound
900      */
901     function clamp(uint256 x, uint256 upperBound)
902         internal
903         pure
904         returns (uint256)
905     {
906         return x > upperBound ? upperBound : x;
907     }
908 }
909 
910 library MassetHelpers {
911 
912     using StableMath for uint256;
913     using SafeMath for uint256;
914     using SafeERC20 for IERC20;
915 
916     function transferTokens(
917         address _sender,
918         address _recipient,
919         address _basset,
920         bool _erc20TransferFeeCharged,
921         uint256 _qty
922     )
923         internal
924         returns (uint256 receivedQty)
925     {
926         receivedQty = _qty;
927         if(_erc20TransferFeeCharged) {
928             uint256 balBefore = IERC20(_basset).balanceOf(_recipient);
929             IERC20(_basset).safeTransferFrom(_sender, _recipient, _qty);
930             uint256 balAfter = IERC20(_basset).balanceOf(_recipient);
931             receivedQty = StableMath.min(_qty, balAfter.sub(balBefore));
932         } else {
933             IERC20(_basset).safeTransferFrom(_sender, _recipient, _qty);
934         }
935     }
936 
937     function safeInfiniteApprove(address _asset, address _spender)
938         internal
939     {
940         IERC20(_asset).safeApprove(_spender, 0);
941         IERC20(_asset).safeApprove(_spender, uint256(-1));
942     }
943 }
944 
945 contract PlatformTokenVendor {
946 
947     IERC20 public platformToken;
948     address public parentStakingContract;
949 
950     /** @dev Simple constructor that stores the parent address */
951     constructor(IERC20 _platformToken) public {
952         parentStakingContract = msg.sender;
953         platformToken = _platformToken;
954         MassetHelpers.safeInfiniteApprove(address(_platformToken), parentStakingContract);
955     }
956 
957     /**
958      * @dev Re-approves the StakingReward contract to spend the platform token.
959      * Just incase for some reason approval has been reset.
960      */
961     function reApproveOwner() external {
962         MassetHelpers.safeInfiniteApprove(address(platformToken), parentStakingContract);
963     }
964 }
965 
966 /**
967  * @title  StakingRewardsWithPlatformToken
968  * @author Stability Labs Pty. Ltd.
969  * @notice Rewards stakers of a given LP token (a.k.a StakingToken) with RewardsToken, on a pro-rata basis
970  * additionally, distributes the Platform token airdropped by the platform
971  * @dev    Derives from ./StakingRewards.sol and implements a secondary token into the core logic
972  */
973 contract StakingRewardsWithPlatformToken is StakingTokenWrapper, RewardsDistributionRecipient {
974 
975     using StableMath for uint256;
976 
977     IERC20 public rewardsToken;
978     IERC20 public platformToken;
979     PlatformTokenVendor public platformTokenVendor;
980 
981     uint256 public constant DURATION = 7 days;
982 
983     // Timestamp for current period finish
984     uint256 public periodFinish = 0;
985     // RewardRate for the rest of the PERIOD
986     uint256 public rewardRate = 0;
987     uint256 public platformRewardRate = 0;
988     // Last time any user took action
989     uint256 public lastUpdateTime;
990     // Ever increasing rewardPerToken rate, based on % of total supply
991     uint256 public rewardPerTokenStored;
992     uint256 public platformRewardPerTokenStored;
993 
994     mapping(address => uint256) public userRewardPerTokenPaid;
995     mapping(address => uint256) public userPlatformRewardPerTokenPaid;
996 
997     mapping(address => uint256) public rewards;
998     mapping(address => uint256) public platformRewards;
999 
1000     event RewardAdded(uint256 reward, uint256 platformReward);
1001     event Staked(address indexed user, uint256 amount, address payer);
1002     event Withdrawn(address indexed user, uint256 amount);
1003     event RewardPaid(address indexed user, uint256 reward, uint256 platformReward);
1004 
1005     /** @dev StakingRewards is a TokenWrapper and RewardRecipient */
1006     constructor(
1007         address _nexus,
1008         address _stakingToken,
1009         address _rewardsToken,
1010         address _platformToken,
1011         address _rewardsDistributor
1012     )
1013         public
1014         StakingTokenWrapper(_stakingToken)
1015         RewardsDistributionRecipient(_nexus, _rewardsDistributor)
1016     {
1017         rewardsToken = IERC20(_rewardsToken);
1018         platformToken = IERC20(_platformToken);
1019         platformTokenVendor = new PlatformTokenVendor(platformToken);
1020     }
1021 
1022     /** @dev Updates the reward for a given address, before executing function */
1023     modifier updateReward(address _account) {
1024         // Setting of global vars
1025         (uint256 newRewardPerTokenStored, uint256 newPlatformRewardPerTokenStored) = rewardPerToken();
1026 
1027         // If statement protects against loss in initialisation case
1028         if(newRewardPerTokenStored > 0 || newPlatformRewardPerTokenStored > 0) {
1029             rewardPerTokenStored = newRewardPerTokenStored;
1030             platformRewardPerTokenStored = newPlatformRewardPerTokenStored;
1031 
1032             lastUpdateTime = lastTimeRewardApplicable();
1033 
1034             // Setting of personal vars based on new globals
1035             if (_account != address(0)) {
1036                 (rewards[_account], platformRewards[_account]) = earned(_account);
1037 
1038                 userRewardPerTokenPaid[_account] = newRewardPerTokenStored;
1039                 userPlatformRewardPerTokenPaid[_account] = newPlatformRewardPerTokenStored;
1040             }
1041         }
1042         _;
1043     }
1044 
1045     /***************************************
1046                     ACTIONS
1047     ****************************************/
1048 
1049     /**
1050      * @dev Stakes a given amount of the StakingToken for the sender
1051      * @param _amount Units of StakingToken
1052      */
1053     function stake(uint256 _amount)
1054         external
1055     {
1056         _stake(msg.sender, _amount);
1057     }
1058 
1059     /**
1060      * @dev Stakes a given amount of the StakingToken for a given beneficiary
1061      * @param _beneficiary Staked tokens are credited to this address
1062      * @param _amount      Units of StakingToken
1063      */
1064     function stake(address _beneficiary, uint256 _amount)
1065         external
1066     {
1067         _stake(_beneficiary, _amount);
1068     }
1069 
1070     /**
1071      * @dev Internally stakes an amount by depositing from sender,
1072      * and crediting to the specified beneficiary
1073      * @param _beneficiary Staked tokens are credited to this address
1074      * @param _amount      Units of StakingToken
1075      */
1076     function _stake(address _beneficiary, uint256 _amount)
1077         internal
1078         updateReward(_beneficiary)
1079     {
1080         require(_amount > 0, "Cannot stake 0");
1081         super._stake(_beneficiary, _amount);
1082         emit Staked(_beneficiary, _amount, msg.sender);
1083     }
1084 
1085     /**
1086      * @dev Withdraws stake from pool and claims any rewards
1087      */
1088     function exit() external {
1089         withdraw(balanceOf(msg.sender));
1090         claimReward();
1091     }
1092 
1093     /**
1094      * @dev Withdraws given stake amount from the pool
1095      * @param _amount Units of the staked token to withdraw
1096      */
1097     function withdraw(uint256 _amount)
1098         public
1099         updateReward(msg.sender)
1100     {
1101         require(_amount > 0, "Cannot withdraw 0");
1102         _withdraw(_amount);
1103         emit Withdrawn(msg.sender, _amount);
1104     }
1105 
1106     /**
1107      * @dev Claims outstanding rewards (both platform and native) for the sender.
1108      * First updates outstanding reward allocation and then transfers.
1109      */
1110     function claimReward()
1111         public
1112         updateReward(msg.sender)
1113     {
1114         uint256 reward = _claimReward();
1115         uint256 platformReward = _claimPlatformReward();
1116         emit RewardPaid(msg.sender, reward, platformReward);
1117     }
1118 
1119     /**
1120      * @dev Claims outstanding rewards for the sender. Only the native
1121      * rewards token, and not the platform rewards
1122      */
1123     function claimRewardOnly()
1124         public
1125         updateReward(msg.sender)
1126     {
1127         uint256 reward = _claimReward();
1128         emit RewardPaid(msg.sender, reward, 0);
1129     }
1130 
1131     /**
1132      * @dev Credits any outstanding rewards to the sender
1133      */
1134     function _claimReward() internal returns (uint256) {
1135         uint256 reward = rewards[msg.sender];
1136         if (reward > 0) {
1137             rewards[msg.sender] = 0;
1138             rewardsToken.transfer(msg.sender, reward);
1139         }
1140         return reward;
1141     }
1142 
1143     /**
1144      * @dev Claims any outstanding platform reward tokens
1145      */
1146     function _claimPlatformReward() internal returns (uint256)  {
1147         uint256 platformReward = platformRewards[msg.sender];
1148         if(platformReward > 0) {
1149             platformRewards[msg.sender] = 0;
1150             platformToken.safeTransferFrom(address(platformTokenVendor), msg.sender, platformReward);
1151         }
1152         return platformReward;
1153     }
1154 
1155     /***************************************
1156                     GETTERS
1157     ****************************************/
1158 
1159     /**
1160      * @dev Gets the RewardsToken
1161      */
1162     function getRewardToken()
1163         external
1164         view
1165         returns (IERC20)
1166     {
1167         return rewardsToken;
1168     }
1169 
1170     /**
1171      * @dev Gets the last applicable timestamp for this reward period
1172      */
1173     function lastTimeRewardApplicable()
1174         public
1175         view
1176         returns (uint256)
1177     {
1178         return StableMath.min(block.timestamp, periodFinish);
1179     }
1180 
1181     /**
1182      * @dev Calculates the amount of unclaimed rewards a user has earned
1183      * @return 'Reward' per staked token
1184      */
1185     function rewardPerToken()
1186         public
1187         view
1188         returns (uint256, uint256)
1189     {
1190         // If there is no StakingToken liquidity, avoid div(0)
1191         uint256 stakedTokens = totalSupply();
1192         if (stakedTokens == 0) {
1193             return (rewardPerTokenStored, platformRewardPerTokenStored);
1194         }
1195         // new reward units to distribute = rewardRate * timeSinceLastUpdate
1196         uint256 timeDelta = lastTimeRewardApplicable().sub(lastUpdateTime);
1197         uint256 rewardUnitsToDistribute = rewardRate.mul(timeDelta);
1198         uint256 platformRewardUnitsToDistribute = platformRewardRate.mul(timeDelta);
1199         // new reward units per token = (rewardUnitsToDistribute * 1e18) / totalTokens
1200         uint256 unitsToDistributePerToken = rewardUnitsToDistribute.divPrecisely(stakedTokens);
1201         uint256 platformUnitsToDistributePerToken = platformRewardUnitsToDistribute.divPrecisely(stakedTokens);
1202         // return summed rate
1203         return (
1204             rewardPerTokenStored.add(unitsToDistributePerToken),
1205             platformRewardPerTokenStored.add(platformUnitsToDistributePerToken)
1206         );
1207     }
1208 
1209     /**
1210      * @dev Calculates the amount of unclaimed rewards a user has earned
1211      * @param _account User address
1212      * @return Total reward amount earned
1213      */
1214     function earned(address _account)
1215         public
1216         view
1217         returns (uint256, uint256)
1218     {
1219         // current rate per token - rate user previously received
1220         (uint256 currentRewardPerToken, uint256 currentPlatformRewardPerToken) = rewardPerToken();
1221         uint256 userRewardDelta = currentRewardPerToken.sub(userRewardPerTokenPaid[_account]);
1222         uint256 userPlatformRewardDelta = currentPlatformRewardPerToken.sub(userPlatformRewardPerTokenPaid[_account]);
1223         // new reward = staked tokens * difference in rate
1224         uint256 stakeBalance = balanceOf(_account);
1225         uint256 userNewReward = stakeBalance.mulTruncate(userRewardDelta);
1226         uint256 userNewPlatformReward = stakeBalance.mulTruncate(userPlatformRewardDelta);
1227         // add to previous rewards
1228         return (
1229             rewards[_account].add(userNewReward),
1230             platformRewards[_account].add(userNewPlatformReward)
1231         );
1232     }
1233 
1234 
1235     /***************************************
1236                     ADMIN
1237     ****************************************/
1238 
1239     /**
1240      * @dev Notifies the contract that new rewards have been added.
1241      * Calculates an updated rewardRate based on the rewards in period.
1242      * @param _reward Units of RewardToken that have been added to the pool
1243      */
1244     function notifyRewardAmount(uint256 _reward)
1245         external
1246         onlyRewardsDistributor
1247         updateReward(address(0))
1248     {
1249         uint256 newPlatformRewards = platformToken.balanceOf(address(this));
1250         if(newPlatformRewards > 0){
1251             platformToken.safeTransfer(address(platformTokenVendor), newPlatformRewards);
1252         }
1253 
1254         uint256 currentTime = block.timestamp;
1255         // If previous period over, reset rewardRate
1256         if (currentTime >= periodFinish) {
1257             rewardRate = _reward.div(DURATION);
1258             platformRewardRate = newPlatformRewards.div(DURATION);
1259         }
1260         // If additional reward to existing period, calc sum
1261         else {
1262             uint256 remaining = periodFinish.sub(currentTime);
1263 
1264             uint256 leftoverReward = remaining.mul(rewardRate);
1265             rewardRate = _reward.add(leftoverReward).div(DURATION);
1266 
1267             uint256 leftoverPlatformReward = remaining.mul(platformRewardRate);
1268             platformRewardRate = newPlatformRewards.add(leftoverPlatformReward).div(DURATION);
1269         }
1270 
1271         lastUpdateTime = currentTime;
1272         periodFinish = currentTime.add(DURATION);
1273 
1274         emit RewardAdded(_reward, newPlatformRewards);
1275     }
1276 }