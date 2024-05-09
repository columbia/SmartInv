1 pragma solidity 0.5.17;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
77  * the optional functions; to access them see {ERC20Detailed}.
78  */
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * _Available since v2.4.0._
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      *
227      * _Available since v2.4.0._
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following 
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Converts an `address` into `address payable`. Note that this is
269      * simply a type cast: the actual underlying value is not changed.
270      *
271      * _Available since v2.4.0._
272      */
273     function toPayable(address account) internal pure returns (address payable) {
274         return address(uint160(account));
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      *
293      * _Available since v2.4.0._
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-call-value
299         (bool success, ) = recipient.call.value(amount)("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 }
303 
304 library SafeERC20 {
305     using SafeMath for uint256;
306     using Address for address;
307 
308     function safeTransfer(IERC20 token, address to, uint256 value) internal {
309         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
310     }
311 
312     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
313         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
314     }
315 
316     function safeApprove(IERC20 token, address spender, uint256 value) internal {
317         // safeApprove should only be called when setting an initial allowance,
318         // or when resetting it to zero. To increase and decrease it, use
319         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
320         // solhint-disable-next-line max-line-length
321         require((value == 0) || (token.allowance(address(this), spender) == 0),
322             "SafeERC20: approve from non-zero to non-zero allowance"
323         );
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
325     }
326 
327     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
328         uint256 newAllowance = token.allowance(address(this), spender).add(value);
329         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330     }
331 
332     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
333         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
334         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
335     }
336 
337     /**
338      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
339      * on the return value: the return value is optional (but if data is returned, it must not be false).
340      * @param token The token targeted by the call.
341      * @param data The call data (encoded using abi.encode or one of its variants).
342      */
343     function callOptionalReturn(IERC20 token, bytes memory data) private {
344         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
345         // we're implementing it ourselves.
346 
347         // A Solidity high level call has three parts:
348         //  1. The target address is checked to verify it contains contract code
349         //  2. The call itself is made, and success asserted
350         //  3. The return value is decoded, which in turn checks the size of the returned data.
351         // solhint-disable-next-line max-line-length
352         require(address(token).isContract(), "SafeERC20: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = address(token).call(data);
356         require(success, "SafeERC20: low-level call failed");
357 
358         if (returndata.length > 0) { // Return data is optional
359             // solhint-disable-next-line max-line-length
360             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
361         }
362     }
363 }
364 
365 interface ICurveDeposit {
366     function add_liquidity(uint[4] calldata uamounts, uint min_mint_amount) external;
367     function remove_liquidity(uint amount, uint[4] calldata min_uamounts) external;
368     function remove_liquidity_imbalance(uint[4] calldata uamounts, uint max_burn_amount) external;
369     function remove_liquidity_one_coin(uint _token_amount, int128 i, uint min_uamount) external;
370     function calc_withdraw_one_coin(uint _token_amount, int128 i) external view returns(uint);
371 }
372 
373 interface ICurve {
374     function add_liquidity(uint[4] calldata uamounts, uint min_mint_amount) external;
375     function remove_liquidity_imbalance(uint[4] calldata uamounts, uint max_burn_amount) external;
376     function remove_liquidity(uint amount, uint[4] calldata min_amounts) external;
377     function calc_token_amount(uint[4] calldata inAmounts, bool deposit) external view returns(uint);
378     function balances(int128 i) external view returns(uint);
379     function get_virtual_price() external view returns(uint);
380     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
381     // for tests
382     function mock_add_to_balance(uint[4] calldata amounts) external;
383 }
384 
385 library Math {
386     /**
387      * @dev Returns the largest of two numbers.
388      */
389     function max(uint256 a, uint256 b) internal pure returns (uint256) {
390         return a >= b ? a : b;
391     }
392 
393     /**
394      * @dev Returns the smallest of two numbers.
395      */
396     function min(uint256 a, uint256 b) internal pure returns (uint256) {
397         return a < b ? a : b;
398     }
399 
400     /**
401      * @dev Returns the average of two numbers. The result is rounded towards
402      * zero.
403      */
404     function average(uint256 a, uint256 b) internal pure returns (uint256) {
405         // (a + b) / 2 can overflow, so we distribute
406         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
407     }
408 }
409 
410 interface ICore {
411     function mint(uint dusdAmount, address account) external returns(uint usd);
412     function redeem(uint dusdAmount, address account) external returns(uint usd);
413     function dusdToUsd(uint _dusd, bool fee) external view returns(uint usd);
414     function peaks(address peak) external view returns (uint,uint,uint8);
415 }
416 
417 interface IPeak {
418     function portfolioValue() external view returns(uint);
419 }
420 
421 contract IController {
422     function earn(address _token) external;
423     function vaultWithdraw(IERC20 token, uint _shares) external;
424     function withdraw(IERC20 token, uint amount) external;
425     function getPricePerFullShare(address token) external view returns(uint);
426 }
427 
428 contract Initializable {
429     bool initialized = false;
430 
431     modifier notInitialized() {
432         require(!initialized, "already initialized");
433         initialized = true;
434         _;
435     }
436 
437     // Reserved storage space to allow for layout changes in the future.
438     uint256[20] private _gap;
439 
440     function getStore(uint a) internal view returns(uint) {
441         require(a < 20, "Not allowed");
442         return _gap[a];
443     }
444 
445     function setStore(uint a, uint val) internal {
446         require(a < 20, "Not allowed");
447         _gap[a] = val;
448     }
449 }
450 
451 contract OwnableProxy {
452     bytes32 constant OWNER_SLOT = keccak256("proxy.owner");
453 
454     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
455 
456     constructor() internal {
457         _transferOwnership(msg.sender);
458     }
459 
460     /**
461      * @dev Returns the address of the current owner.
462      */
463     function owner() public view returns(address _owner) {
464         bytes32 position = OWNER_SLOT;
465         assembly {
466             _owner := sload(position)
467         }
468     }
469 
470     modifier onlyOwner() {
471         require(isOwner(), "NOT_OWNER");
472         _;
473     }
474 
475     function isOwner() public view returns (bool) {
476         return owner() == msg.sender;
477     }
478 
479     /**
480      * @dev Transfers ownership of the contract to a new account (`newOwner`).
481      */
482     function transferOwnership(address newOwner) public onlyOwner {
483         _transferOwnership(newOwner);
484     }
485 
486     function _transferOwnership(address newOwner) internal {
487         require(newOwner != address(0), "OwnableProxy: new owner is the zero address");
488         emit OwnershipTransferred(owner(), newOwner);
489         bytes32 position = OWNER_SLOT;
490         assembly {
491             sstore(position, newOwner)
492         }
493     }
494 }
495 
496 contract YVaultPeak is OwnableProxy, Initializable, IPeak {
497     using SafeERC20 for IERC20;
498     using SafeMath for uint;
499     using Math for uint;
500 
501     string constant ERR_INSUFFICIENT_FUNDS = "INSUFFICIENT_FUNDS";
502     uint constant MAX = 10000;
503 
504     uint min;
505     uint redeemMultiplier;
506     uint[4] feed; // unused for now but might need later
507 
508     ICore core;
509     ICurve ySwap;
510     IERC20 yCrv;
511     IERC20 yUSD;
512 
513     IController controller;
514 
515     function initialize(IController _controller)
516         public
517         notInitialized
518     {
519         controller = _controller;
520         // these need to be initialzed here, because the contract is used via a proxy
521         core = ICore(0xE449Ca7d10b041255E7e989D158Bee355d8f88d3);
522         ySwap = ICurve(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
523         yCrv = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
524         yUSD = IERC20(0x5dbcF33D8c2E976c6b560249878e6F1491Bca25c);
525         _setParams(
526             200, // 200.div(10000) implies to keep 2% of yCRV in the contract
527             9998 // 9998.div(10000) implies a redeem fee of .02%
528         );
529     }
530 
531     function mintWithYcrv(uint inAmount) external returns(uint dusdAmount) {
532         yCrv.safeTransferFrom(msg.sender, address(this), inAmount);
533         dusdAmount = calcMintWithYcrv(inAmount);
534         core.mint(dusdAmount, msg.sender);
535         // best effort at keeping min.div(MAX) funds here
536         uint farm = toFarm();
537         if (farm > 0) {
538             yCrv.safeTransfer(address(controller), farm);
539             controller.earn(address(yCrv)); // this is acting like a callback
540         }
541     }
542 
543     // Sets minimum required on-hand to keep small withdrawals cheap
544     function toFarm() internal view returns (uint) {
545         (uint here, uint total) = yCrvDistribution();
546         uint shouldBeHere = total.mul(min).div(MAX);
547         if (here > shouldBeHere) {
548             return here.sub(shouldBeHere);
549         }
550         return 0;
551     }
552 
553     function yCrvDistribution() public view returns (uint here, uint total) {
554         here = yCrv.balanceOf(address(this));
555         total = yUSD.balanceOf(address(controller))
556             .mul(controller.getPricePerFullShare(address(yCrv)))
557             .div(1e18)
558             .add(here);
559     }
560 
561     function calcMintWithYcrv(uint inAmount) public view returns (uint dusdAmount) {
562         return inAmount.mul(yCrvToUsd()).div(1e18);
563     }
564 
565     function redeemInYcrv(uint dusdAmount, uint minOut) external returns(uint _yCrv) {
566         core.redeem(dusdAmount, msg.sender);
567         _yCrv = dusdAmount.mul(1e18).div(yCrvToUsd()).mul(redeemMultiplier).div(MAX);
568         uint here = yCrv.balanceOf(address(this));
569         if (here < _yCrv) {
570             // withdraw only as much as needed from the vault
571             uint _withdraw = _yCrv.sub(here).mul(1e18).div(controller.getPricePerFullShare(address(yCrv)));
572             controller.vaultWithdraw(yCrv, _withdraw);
573             _yCrv = yCrv.balanceOf(address(this));
574         }
575         require(_yCrv >= minOut, ERR_INSUFFICIENT_FUNDS);
576         yCrv.safeTransfer(msg.sender, _yCrv);
577     }
578 
579     function calcRedeemInYcrv(uint dusdAmount) public view returns (uint _yCrv) {
580         _yCrv = dusdAmount.mul(1e18).div(yCrvToUsd()).mul(redeemMultiplier).div(MAX);
581         (,uint total) = yCrvDistribution();
582         return _yCrv.min(total);
583     }
584 
585     function yCrvToUsd() public view returns (uint) {
586         return ySwap.get_virtual_price();
587     }
588 
589     // yUSD
590 
591     function mintWithYusd(uint inAmount) external {
592         yUSD.safeTransferFrom(msg.sender, address(controller), inAmount);
593         core.mint(calcMintWithYusd(inAmount), msg.sender);
594     }
595 
596     function calcMintWithYusd(uint inAmount) public view returns (uint dusdAmount) {
597         return inAmount.mul(yUSDToUsd()).div(1e18);
598     }
599 
600     function redeemInYusd(uint dusdAmount, uint minOut) external {
601         core.redeem(dusdAmount, msg.sender);
602         uint r = dusdAmount.mul(1e18).div(yUSDToUsd()).mul(redeemMultiplier).div(MAX);
603         // there should be no reason that this contracts has yUSD, however being safe doesn't hurt
604         uint b = yUSD.balanceOf(address(this));
605         if (b < r) {
606             controller.withdraw(yUSD, r.sub(b));
607             r = yUSD.balanceOf(address(this));
608         }
609         require(r >= minOut, ERR_INSUFFICIENT_FUNDS);
610         yUSD.safeTransfer(msg.sender, r);
611     }
612 
613     function calcRedeemInYusd(uint dusdAmount) public view returns (uint) {
614         uint r = dusdAmount.mul(1e18).div(yUSDToUsd()).mul(redeemMultiplier).div(MAX);
615         return r.min(
616             yUSD.balanceOf(address(this))
617             .add(yUSD.balanceOf(address(controller))));
618     }
619 
620     function yUSDToUsd() public view returns (uint) {
621         return controller.getPricePerFullShare(address(yCrv)) // # yCrv
622             .mul(yCrvToUsd()) // USD price
623             .div(1e18);
624     }
625 
626     function portfolioValue() external view returns(uint) {
627         (,uint total) = yCrvDistribution();
628         return total.mul(yCrvToUsd()).div(1e18);
629     }
630 
631     function vars() external view returns(
632         address _core,
633         address _ySwap,
634         address _yCrv,
635         address _yUSD,
636         address _controller,
637         uint _redeemMultiplier,
638         uint _min
639     ) {
640         return(
641             address(core),
642             address(ySwap),
643             address(yCrv),
644             address(yUSD),
645             address(controller),
646             redeemMultiplier,
647             min
648         );
649     }
650 
651     // Privileged methods
652 
653     function setParams(uint _min, uint _redeemMultiplier) external onlyOwner {
654         _setParams(_min, _redeemMultiplier);
655     }
656 
657     function _setParams(uint _min, uint _redeemMultiplier) internal {
658         require(min <= MAX && redeemMultiplier <= MAX, "Invalid");
659         min = _min;
660         redeemMultiplier = _redeemMultiplier;
661     }
662 }
663 
664 contract YVaultZap {
665     using SafeMath for uint;
666     using SafeERC20 for IERC20;
667 
668     uint constant N_COINS = 4;
669     string constant ERR_SLIPPAGE = "ERR_SLIPPAGE";
670 
671     uint[N_COINS] ZEROES = [uint(0),uint(0),uint(0),uint(0)];
672     address[N_COINS] coins = [
673         0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01, // ydai
674         0xd6aD7a6750A7593E092a9B218d66C0A814a3436e, // yusdc
675         0x83f798e925BcD4017Eb265844FDDAbb448f1707D, // yusdt
676         0x73a052500105205d34Daf004eAb301916DA8190f // ytusd
677     ];
678     address[N_COINS] underlyingCoins = [
679         0x6B175474E89094C44Da98b954EedeAC495271d0F, // dai
680         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // usdc
681         0xdAC17F958D2ee523a2206206994597C13D831ec7, // usdt
682         0x0000000000085d4780B73119b644AE5ecd22b376 // tusd
683     ];
684 
685     ICurveDeposit yDeposit = ICurveDeposit(0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3);
686     ICurve ySwap = ICurve(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
687     IERC20 yCrv = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
688     IERC20 dusd = IERC20(0x5BC25f649fc4e26069dDF4cF4010F9f706c23831);
689     YVaultPeak yVaultPeak;
690 
691     constructor (YVaultPeak _yVaultPeak) public {
692         yVaultPeak = _yVaultPeak;
693     }
694 
695     /**
696     * @dev Mint DUSD
697     * @param inAmounts Exact inAmounts in the same order as required by the curve pool
698     * @param minDusdAmount Minimum DUSD to mint, used for capping slippage
699     */
700     function mint(uint[N_COINS] calldata inAmounts, uint minDusdAmount)
701         external
702         returns (uint dusdAmount)
703     {
704         address[N_COINS] memory _coins = underlyingCoins;
705         for (uint i = 0; i < N_COINS; i++) {
706             if (inAmounts[i] > 0) {
707                 IERC20(_coins[i]).safeTransferFrom(msg.sender, address(this), inAmounts[i]);
708                 IERC20(_coins[i]).safeApprove(address(yDeposit), inAmounts[i]);
709             }
710         }
711         yDeposit.add_liquidity(inAmounts, 0);
712         uint inAmount = yCrv.balanceOf(address(this));
713         yCrv.safeApprove(address(yVaultPeak), 0);
714         yCrv.safeApprove(address(yVaultPeak), inAmount);
715         dusdAmount = yVaultPeak.mintWithYcrv(inAmount);
716         require(dusdAmount >= minDusdAmount, ERR_SLIPPAGE);
717         dusd.safeTransfer(msg.sender, dusdAmount);
718     }
719 
720     function calcMint(uint[N_COINS] memory inAmounts)
721         public view
722         returns (uint dusdAmount)
723     {
724         for(uint i = 0; i < N_COINS; i++) {
725             inAmounts[i] = inAmounts[i].mul(1e18).div(yERC20(coins[i]).getPricePerFullShare());
726         }
727         uint _yCrv = ySwap.calc_token_amount(inAmounts, true /* deposit */);
728         return yVaultPeak.calcMintWithYcrv(_yCrv);
729     }
730 
731     /**
732     * @dev Redeem DUSD
733     * @param dusdAmount Exact dusdAmount to burn
734     * @param minAmounts Min expected amounts to cap slippage
735     */
736     function redeem(uint dusdAmount, uint[N_COINS] calldata minAmounts)
737         external
738     {
739         dusd.safeTransferFrom(msg.sender, address(this), dusdAmount);
740         uint r = yVaultPeak.redeemInYcrv(dusdAmount, 0);
741         yCrv.safeApprove(address(yDeposit), r);
742         yDeposit.remove_liquidity(r, ZEROES);
743         address[N_COINS] memory _coins = underlyingCoins;
744         uint toTransfer;
745         for (uint i = 0; i < N_COINS; i++) {
746             toTransfer = IERC20(_coins[i]).balanceOf(address(this));
747             require(toTransfer >= minAmounts[i], ERR_SLIPPAGE);
748             IERC20(_coins[i]).safeTransfer(msg.sender, toTransfer);
749         }
750     }
751 
752     function calcRedeem(uint dusdAmount)
753         public view
754         returns (uint[N_COINS] memory amounts)
755     {
756         uint _yCrv = yVaultPeak.calcRedeemInYcrv(dusdAmount);
757         uint totalSupply = yCrv.totalSupply();
758         for(uint i = 0; i < N_COINS; i++) {
759             amounts[i] = ySwap.balances(int128(i))
760                 .mul(_yCrv)
761                 .div(totalSupply)
762                 .mul(yERC20(coins[i]).getPricePerFullShare())
763                 .div(1e18);
764         }
765     }
766 
767     function redeemInSingleCoin(uint dusdAmount, uint i, uint minOut)
768         external
769     {
770         dusd.safeTransferFrom(msg.sender, address(this), dusdAmount);
771         uint r = yVaultPeak.redeemInYcrv(dusdAmount, 0);
772         yCrv.safeApprove(address(yDeposit), r);
773         yDeposit.remove_liquidity_one_coin(r, int128(i), minOut); // checks for slippage
774         IERC20 coin = IERC20(underlyingCoins[i]);
775         uint toTransfer = coin.balanceOf(address(this));
776         coin.safeTransfer(msg.sender, toTransfer);
777     }
778 
779     function calcRedeemInSingleCoin(uint dusdAmount, uint i)
780         public view
781         returns(uint)
782     {
783         uint _yCrv = yVaultPeak.calcRedeemInYcrv(dusdAmount);
784         return yDeposit.calc_withdraw_one_coin(_yCrv, int128(i));
785     }
786 }
787 
788 interface yERC20 {
789     function getPricePerFullShare() external view returns(uint);
790 }