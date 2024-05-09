1 pragma solidity 0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 
5 library MerkleProof {
6     /**
7      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
8      * defined by `root`. For this, a `proof` must be provided, containing
9      * sibling hashes on the branch from the leaf to the root of the tree. Each
10      * pair of leaves and each pair of pre-images are assumed to be sorted.
11      */
12     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
13         bytes32 computedHash = leaf;
14 
15         for (uint256 i = 0; i < proof.length; i++) {
16             bytes32 proofElement = proof[i];
17 
18             if (computedHash <= proofElement) {
19                 // Hash(current computed hash + current element of the proof)
20                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
21             } else {
22                 // Hash(current element of the proof + current computed hash)
23                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
24             }
25         }
26 
27         // Check if the computed hash (root) is equal to the provided root
28         return computedHash == root;
29     }
30 }
31 
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
105  * the optional functions; to access them see {ERC20Detailed}.
106  */
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      *
160      * _Available since v2.4.0._
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      *
218      * _Available since v2.4.0._
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      *
255      * _Available since v2.4.0._
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
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
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
293     }
294 
295     /**
296      * @dev Converts an `address` into `address payable`. Note that this is
297      * simply a type cast: the actual underlying value is not changed.
298      *
299      * _Available since v2.4.0._
300      */
301     function toPayable(address account) internal pure returns (address payable) {
302         return address(uint160(account));
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      *
321      * _Available since v2.4.0._
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-call-value
327         (bool success, ) = recipient.call.value(amount)("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 }
331 
332 library SafeERC20 {
333     using SafeMath for uint256;
334     using Address for address;
335 
336     function safeTransfer(IERC20 token, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
338     }
339 
340     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
341         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
342     }
343 
344     function safeApprove(IERC20 token, address spender, uint256 value) internal {
345         // safeApprove should only be called when setting an initial allowance,
346         // or when resetting it to zero. To increase and decrease it, use
347         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
348         // solhint-disable-next-line max-line-length
349         require((value == 0) || (token.allowance(address(this), spender) == 0),
350             "SafeERC20: approve from non-zero to non-zero allowance"
351         );
352         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
353     }
354 
355     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
356         uint256 newAllowance = token.allowance(address(this), spender).add(value);
357         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
358     }
359 
360     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
361         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
362         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
363     }
364 
365     /**
366      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
367      * on the return value: the return value is optional (but if data is returned, it must not be false).
368      * @param token The token targeted by the call.
369      * @param data The call data (encoded using abi.encode or one of its variants).
370      */
371     function callOptionalReturn(IERC20 token, bytes memory data) private {
372         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
373         // we're implementing it ourselves.
374 
375         // A Solidity high level call has three parts:
376         //  1. The target address is checked to verify it contains contract code
377         //  2. The call itself is made, and success asserted
378         //  3. The return value is decoded, which in turn checks the size of the returned data.
379         // solhint-disable-next-line max-line-length
380         require(address(token).isContract(), "SafeERC20: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = address(token).call(data);
384         require(success, "SafeERC20: low-level call failed");
385 
386         if (returndata.length > 0) { // Return data is optional
387             // solhint-disable-next-line max-line-length
388             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
389         }
390     }
391 }
392 
393 contract Initializable {
394 
395   /**
396    * @dev Indicates that the contract has been initialized.
397    */
398   bool private initialized;
399 
400   /**
401    * @dev Indicates that the contract is in the process of being initialized.
402    */
403   bool private initializing;
404 
405   /**
406    * @dev Modifier to use in the initializer function of a contract.
407    */
408   modifier initializer() {
409     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
410 
411     bool isTopLevelCall = !initializing;
412     if (isTopLevelCall) {
413       initializing = true;
414       initialized = true;
415     }
416 
417     _;
418 
419     if (isTopLevelCall) {
420       initializing = false;
421     }
422   }
423 
424   /// @dev Returns true if and only if the function is running in the constructor
425   function isConstructor() private view returns (bool) {
426     // extcodesize checks the size of the code stored in an address, and
427     // address returns the current address. Since the code is still not
428     // deployed when running a constructor, any checks on its code size will
429     // yield zero, making it an effective way to detect if a contract is
430     // under construction or not.
431     address self = address(this);
432     uint256 cs;
433     assembly { cs := extcodesize(self) }
434     return cs == 0;
435   }
436 
437   // Reserved storage space to allow for layout changes in the future.
438   uint256[50] private ______gap;
439 }
440 
441 contract InitializableModuleKeys {
442 
443     // Governance                             // Phases
444     bytes32 internal KEY_GOVERNANCE;          // 2.x
445     bytes32 internal KEY_STAKING;             // 1.2
446     bytes32 internal KEY_PROXY_ADMIN;         // 1.0
447 
448     // mStable
449     bytes32 internal KEY_ORACLE_HUB;          // 1.2
450     bytes32 internal KEY_MANAGER;             // 1.2
451     bytes32 internal KEY_RECOLLATERALISER;    // 2.x
452     bytes32 internal KEY_META_TOKEN;          // 1.1
453     bytes32 internal KEY_SAVINGS_MANAGER;     // 1.0
454 
455     /**
456      * @dev Initialize function for upgradable proxy contracts. This function should be called
457      *      via Proxy to initialize constants in the Proxy contract.
458      */
459     function _initialize() internal {
460         // keccak256() values are evaluated only once at the time of this function call.
461         // Hence, no need to assign hard-coded values to these variables.
462         KEY_GOVERNANCE = keccak256("Governance");
463         KEY_STAKING = keccak256("Staking");
464         KEY_PROXY_ADMIN = keccak256("ProxyAdmin");
465 
466         KEY_ORACLE_HUB = keccak256("OracleHub");
467         KEY_MANAGER = keccak256("Manager");
468         KEY_RECOLLATERALISER = keccak256("Recollateraliser");
469         KEY_META_TOKEN = keccak256("MetaToken");
470         KEY_SAVINGS_MANAGER = keccak256("SavingsManager");
471     }
472 }
473 
474 interface INexus {
475     function governor() external view returns (address);
476     function getModule(bytes32 key) external view returns (address);
477 
478     function proposeModule(bytes32 _key, address _addr) external;
479     function cancelProposedModule(bytes32 _key) external;
480     function acceptProposedModule(bytes32 _key) external;
481     function acceptProposedModules(bytes32[] calldata _keys) external;
482 
483     function requestLockModule(bytes32 _key) external;
484     function cancelLockModule(bytes32 _key) external;
485     function lockModule(bytes32 _key) external;
486 }
487 
488 contract InitializableModule is InitializableModuleKeys {
489 
490     INexus public nexus;
491 
492     /**
493      * @dev Modifier to allow function calls only from the Governor.
494      */
495     modifier onlyGovernor() {
496         require(msg.sender == _governor(), "Only governor can execute");
497         _;
498     }
499 
500     /**
501      * @dev Modifier to allow function calls only from the Governance.
502      *      Governance is either Governor address or Governance address.
503      */
504     modifier onlyGovernance() {
505         require(
506             msg.sender == _governor() || msg.sender == _governance(),
507             "Only governance can execute"
508         );
509         _;
510     }
511 
512     /**
513      * @dev Modifier to allow function calls only from the ProxyAdmin.
514      */
515     modifier onlyProxyAdmin() {
516         require(
517             msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"
518         );
519         _;
520     }
521 
522     /**
523      * @dev Modifier to allow function calls only from the Manager.
524      */
525     modifier onlyManager() {
526         require(msg.sender == _manager(), "Only manager can execute");
527         _;
528     }
529 
530     /**
531      * @dev Initialization function for upgradable proxy contracts
532      * @param _nexus Nexus contract address
533      */
534     function _initialize(address _nexus) internal {
535         require(_nexus != address(0), "Nexus address is zero");
536         nexus = INexus(_nexus);
537         InitializableModuleKeys._initialize();
538     }
539 
540     /**
541      * @dev Returns Governor address from the Nexus
542      * @return Address of Governor Contract
543      */
544     function _governor() internal view returns (address) {
545         return nexus.governor();
546     }
547 
548     /**
549      * @dev Returns Governance Module address from the Nexus
550      * @return Address of the Governance (Phase 2)
551      */
552     function _governance() internal view returns (address) {
553         return nexus.getModule(KEY_GOVERNANCE);
554     }
555 
556     /**
557      * @dev Return Staking Module address from the Nexus
558      * @return Address of the Staking Module contract
559      */
560     function _staking() internal view returns (address) {
561         return nexus.getModule(KEY_STAKING);
562     }
563 
564     /**
565      * @dev Return ProxyAdmin Module address from the Nexus
566      * @return Address of the ProxyAdmin Module contract
567      */
568     function _proxyAdmin() internal view returns (address) {
569         return nexus.getModule(KEY_PROXY_ADMIN);
570     }
571 
572     /**
573      * @dev Return MetaToken Module address from the Nexus
574      * @return Address of the MetaToken Module contract
575      */
576     function _metaToken() internal view returns (address) {
577         return nexus.getModule(KEY_META_TOKEN);
578     }
579 
580     /**
581      * @dev Return OracleHub Module address from the Nexus
582      * @return Address of the OracleHub Module contract
583      */
584     function _oracleHub() internal view returns (address) {
585         return nexus.getModule(KEY_ORACLE_HUB);
586     }
587 
588     /**
589      * @dev Return Manager Module address from the Nexus
590      * @return Address of the Manager Module contract
591      */
592     function _manager() internal view returns (address) {
593         return nexus.getModule(KEY_MANAGER);
594     }
595 
596     /**
597      * @dev Return SavingsManager Module address from the Nexus
598      * @return Address of the SavingsManager Module contract
599      */
600     function _savingsManager() internal view returns (address) {
601         return nexus.getModule(KEY_SAVINGS_MANAGER);
602     }
603 
604     /**
605      * @dev Return Recollateraliser Module address from the Nexus
606      * @return  Address of the Recollateraliser Module contract (Phase 2)
607      */
608     function _recollateraliser() internal view returns (address) {
609         return nexus.getModule(KEY_RECOLLATERALISER);
610     }
611 }
612 
613 contract InitializableGovernableWhitelist is InitializableModule {
614 
615     event Whitelisted(address indexed _address);
616 
617     mapping(address => bool) public whitelist;
618 
619     /**
620      * @dev Modifier to allow function calls only from the whitelisted address.
621      */
622     modifier onlyWhitelisted() {
623         require(whitelist[msg.sender], "Not a whitelisted address");
624         _;
625     }
626 
627     /**
628      * @dev Initialization function for upgradable proxy contracts
629      * @param _nexus Nexus contract address
630      * @param _whitelisted Array of whitelisted addresses.
631      */
632     function _initialize(
633         address _nexus,
634         address[] memory _whitelisted
635     )
636         internal
637     {
638         InitializableModule._initialize(_nexus);
639 
640         require(_whitelisted.length > 0, "Empty whitelist array");
641 
642         for(uint256 i = 0; i < _whitelisted.length; i++) {
643             _addWhitelist(_whitelisted[i]);
644         }
645     }
646 
647     /**
648      * @dev Adds a new whitelist address
649      * @param _address Address to add in whitelist
650      */
651     function _addWhitelist(address _address) internal {
652         require(_address != address(0), "Address is zero");
653         require(! whitelist[_address], "Already whitelisted");
654 
655         whitelist[_address] = true;
656 
657         emit Whitelisted(_address);
658     }
659 
660 }
661 
662 contract MerkleDrop is Initializable, InitializableGovernableWhitelist {
663 
664     using SafeERC20 for IERC20;
665     using SafeMath for uint256;
666 
667     event Claimed(address claimant, uint256 week, uint256 balance);
668     event TrancheAdded(uint256 tranche, bytes32 merkleRoot, uint256 totalAmount);
669     event TrancheExpired(uint256 tranche);
670     event RemovedFunder(address indexed _address);
671 
672     IERC20 public token;
673 
674     mapping(uint256 => bytes32) public merkleRoots;
675     mapping(uint256 => mapping(address => bool)) public claimed;
676     uint256 tranches;
677 
678     function initialize(
679         address _nexus,
680         address[] calldata _funders,
681         IERC20 _token
682     )
683         external
684         initializer
685     {
686         InitializableGovernableWhitelist._initialize(_nexus, _funders);
687         token = _token;
688     }
689 
690     /***************************************
691                     ADMIN
692     ****************************************/
693 
694     function seedNewAllocations(bytes32 _merkleRoot, uint256 _totalAllocation)
695         public
696         onlyWhitelisted
697         returns (uint256 trancheId)
698     {
699         token.safeTransferFrom(msg.sender, address(this), _totalAllocation);
700 
701         trancheId = tranches;
702         merkleRoots[trancheId] = _merkleRoot;
703 
704         tranches = tranches.add(1);
705 
706         emit TrancheAdded(trancheId, _merkleRoot, _totalAllocation);
707     }
708 
709     function expireTranche(uint256 _trancheId)
710         public
711         onlyWhitelisted
712     {
713         merkleRoots[_trancheId] = bytes32(0);
714 
715         emit TrancheExpired(_trancheId);
716     }
717 
718     /**
719      * @dev Allows the mStable governance to add a new Funder
720      * @param _address  Funder to add
721      */
722     function addFunder(address _address)
723         external
724         onlyGovernor
725     {
726         _addWhitelist(_address);
727     }
728 
729     /**
730      * @dev Allows the mStable governance to remove inactive Funder
731      * @param _address  Funder to remove
732      */
733     function removeFunder(address _address)
734         external
735         onlyGovernor
736     {
737         require(_address != address(0), "Address is zero");
738         require(whitelist[_address], "Address is not whitelisted");
739 
740         whitelist[_address] = false;
741 
742         emit RemovedFunder(_address);
743     }
744 
745 
746     /***************************************
747                   CLAIMING
748     ****************************************/
749 
750 
751     function claimWeek(
752         address _liquidityProvider,
753         uint256 _tranche,
754         uint256 _balance,
755         bytes32[] memory _merkleProof
756     )
757         public
758     {
759         _claimWeek(_liquidityProvider, _tranche, _balance, _merkleProof);
760         _disburse(_liquidityProvider, _balance);
761     }
762 
763 
764     function claimWeeks(
765         address _liquidityProvider,
766         uint256[] memory _tranches,
767         uint256[] memory _balances,
768         bytes32[][] memory _merkleProofs
769     )
770         public
771     {
772         uint256 len = _tranches.length;
773         require(len == _balances.length && len == _merkleProofs.length, "Mismatching inputs");
774 
775         uint256 totalBalance = 0;
776         for(uint256 i = 0; i < len; i++) {
777             _claimWeek(_liquidityProvider, _tranches[i], _balances[i], _merkleProofs[i]);
778             totalBalance = totalBalance.add(_balances[i]);
779         }
780         _disburse(_liquidityProvider, totalBalance);
781     }
782 
783 
784     function verifyClaim(
785         address _liquidityProvider,
786         uint256 _tranche,
787         uint256 _balance,
788         bytes32[] memory _merkleProof
789     )
790         public
791         view
792         returns (bool valid)
793     {
794         return _verifyClaim(_liquidityProvider, _tranche, _balance, _merkleProof);
795     }
796 
797 
798     /***************************************
799               CLAIMING - INTERNAL
800     ****************************************/
801 
802 
803     function _claimWeek(
804         address _liquidityProvider,
805         uint256 _tranche,
806         uint256 _balance,
807         bytes32[] memory _merkleProof
808     )
809         private
810     {
811         require(_tranche < tranches, "Week cannot be in the future");
812 
813         require(!claimed[_tranche][_liquidityProvider], "LP has already claimed");
814         require(_verifyClaim(_liquidityProvider, _tranche, _balance, _merkleProof), "Incorrect merkle proof");
815 
816         claimed[_tranche][_liquidityProvider] = true;
817 
818         emit Claimed(_liquidityProvider, _tranche, _balance);
819     }
820 
821 
822     function _verifyClaim(
823         address _liquidityProvider,
824         uint256 _tranche,
825         uint256 _balance,
826         bytes32[] memory _merkleProof
827     )
828         private
829         view
830         returns (bool valid)
831     {
832         bytes32 leaf = keccak256(abi.encodePacked(_liquidityProvider, _balance));
833         return MerkleProof.verify(_merkleProof, merkleRoots[_tranche], leaf);
834     }
835 
836 
837     function _disburse(address _liquidityProvider, uint256 _balance) private {
838         if (_balance > 0) {
839             token.safeTransfer(_liquidityProvider, _balance);
840         } else {
841             revert("No balance would be transfered - not gonna waste your gas");
842         }
843     }
844 }