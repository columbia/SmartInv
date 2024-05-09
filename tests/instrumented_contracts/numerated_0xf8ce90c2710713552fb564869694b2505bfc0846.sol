1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 pragma solidity ^0.5.5;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following 
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Converts an `address` into `address payable`. Note that this is
39      * simply a type cast: the actual underlying value is not changed.
40      *
41      * _Available since v2.4.0._
42      */
43     function toPayable(address account) internal pure returns (address payable) {
44         return address(uint160(account));
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      *
63      * _Available since v2.4.0._
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         // solhint-disable-next-line avoid-call-value
69         (bool success, ) = recipient.call.value(amount)("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 }
73 
74 // File: @openzeppelin/contracts/math/SafeMath.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      *
130      * _Available since v2.4.0._
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         // Solidity only automatically asserts when dividing by 0
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      *
225      * _Available since v2.4.0._
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
234 
235 pragma solidity ^0.5.0;
236 
237 /**
238  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
239  * the optional functions; to access them see {ERC20Detailed}.
240  */
241 interface IERC20 {
242     /**
243      * @dev Returns the amount of tokens in existence.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns the amount of tokens owned by `account`.
249      */
250     function balanceOf(address account) external view returns (uint256);
251 
252     /**
253      * @dev Moves `amount` tokens from the caller's account to `recipient`.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transfer(address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Returns the remaining number of tokens that `spender` will be
263      * allowed to spend on behalf of `owner` through {transferFrom}. This is
264      * zero by default.
265      *
266      * This value changes when {approve} or {transferFrom} are called.
267      */
268     function allowance(address owner, address spender) external view returns (uint256);
269 
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * IMPORTANT: Beware that changing an allowance with this method brings the risk
276      * that someone may use both the old and the new allowance by unfortunate
277      * transaction ordering. One possible solution to mitigate this race
278      * condition is to first reduce the spender's allowance to 0 and set the
279      * desired value afterwards:
280      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
281      *
282      * Emits an {Approval} event.
283      */
284     function approve(address spender, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Moves `amount` tokens from `sender` to `recipient` using the
288      * allowance mechanism. `amount` is then deducted from the caller's
289      * allowance.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Emitted when `value` tokens are moved from one account (`from`) to
299      * another (`to`).
300      *
301      * Note that `value` may be zero.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 value);
304 
305     /**
306      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
307      * a call to {approve}. `value` is the new allowance.
308      */
309     event Approval(address indexed owner, address indexed spender, uint256 value);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
313 
314 pragma solidity ^0.5.0;
315 
316 
317 
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure (when the token
322  * contract returns false). Tokens that return no value (and instead revert or
323  * throw on failure) are also supported, non-reverting calls are assumed to be
324  * successful.
325  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
326  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
327  */
328 library SafeERC20 {
329     using SafeMath for uint256;
330     using Address for address;
331 
332     function safeTransfer(IERC20 token, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     function safeApprove(IERC20 token, address spender, uint256 value) internal {
341         // safeApprove should only be called when setting an initial allowance,
342         // or when resetting it to zero. To increase and decrease it, use
343         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
344         // solhint-disable-next-line max-line-length
345         require((value == 0) || (token.allowance(address(this), spender) == 0),
346             "SafeERC20: approve from non-zero to non-zero allowance"
347         );
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
349     }
350 
351     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).add(value);
353         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
357         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
358         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     /**
362      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
363      * on the return value: the return value is optional (but if data is returned, it must not be false).
364      * @param token The token targeted by the call.
365      * @param data The call data (encoded using abi.encode or one of its variants).
366      */
367     function callOptionalReturn(IERC20 token, bytes memory data) private {
368         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
369         // we're implementing it ourselves.
370 
371         // A Solidity high level call has three parts:
372         //  1. The target address is checked to verify it contains contract code
373         //  2. The call itself is made, and success asserted
374         //  3. The return value is decoded, which in turn checks the size of the returned data.
375         // solhint-disable-next-line max-line-length
376         require(address(token).isContract(), "SafeERC20: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = address(token).call(data);
380         require(success, "SafeERC20: low-level call failed");
381 
382         if (returndata.length > 0) { // Return data is optional
383             // solhint-disable-next-line max-line-length
384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
385         }
386     }
387 }
388 
389 // File: contracts/Storage.sol
390 
391 pragma solidity 0.5.16;
392 
393 contract Storage {
394 
395   address public governance;
396   address public controller;
397 
398   constructor() public {
399     governance = msg.sender;
400   }
401 
402   modifier onlyGovernance() {
403     require(isGovernance(msg.sender), "Not governance");
404     _;
405   }
406 
407   function setGovernance(address _governance) public onlyGovernance {
408     require(_governance != address(0), "new governance shouldn't be empty");
409     governance = _governance;
410   }
411 
412   function setController(address _controller) public onlyGovernance {
413     require(_controller != address(0), "new controller shouldn't be empty");
414     controller = _controller;
415   }
416 
417   function isGovernance(address account) public view returns (bool) {
418     return account == governance;
419   }
420 
421   function isController(address account) public view returns (bool) {
422     return account == controller;
423   }
424 }
425 
426 // File: contracts/Governable.sol
427 
428 pragma solidity 0.5.16;
429 
430 
431 contract Governable {
432 
433   Storage public store;
434 
435   constructor(address _store) public {
436     require(_store != address(0), "new storage shouldn't be empty");
437     store = Storage(_store);
438   }
439 
440   modifier onlyGovernance() {
441     require(store.isGovernance(msg.sender), "Not governance");
442     _;
443   }
444 
445   function setStorage(address _store) public onlyGovernance {
446     require(_store != address(0), "new storage shouldn't be empty");
447     store = Storage(_store);
448   }
449 
450   function governance() public view returns (address) {
451     return store.governance();
452   }
453 }
454 
455 // File: contracts/Controllable.sol
456 
457 pragma solidity 0.5.16;
458 
459 
460 contract Controllable is Governable {
461 
462   constructor(address _storage) Governable(_storage) public {
463   }
464 
465   modifier onlyController() {
466     require(store.isController(msg.sender), "Not a controller");
467     _;
468   }
469 
470   modifier onlyControllerOrGovernance(){
471     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
472       "The caller must be controller or governance");
473     _;
474   }
475 
476   function controller() public view returns (address) {
477     return store.controller();
478   }
479 }
480 
481 // File: contracts/hardworkInterface/IVault.sol
482 
483 pragma solidity 0.5.16;
484 
485 
486 interface IVault {
487     // the IERC20 part is the share
488 
489     function underlyingBalanceInVault() external view returns (uint256);
490     function underlyingBalanceWithInvestment() external view returns (uint256);
491 
492     function governance() external view returns (address);
493     function controller() external view returns (address);
494     function underlying() external view returns (address);
495     function strategy() external view returns (address);
496 
497     function setStrategy(address _strategy) external;
498     function setVaultFractionToInvest(uint256 numerator, uint256 denominator) external;
499 
500     function deposit(uint256 amountWei) external;
501     function depositFor(uint256 amountWei, address holder) external;
502 
503     function withdrawAll() external;
504     function withdraw(uint256 numberOfShares) external;
505     function getPricePerFullShare() external view returns (uint256);
506 
507     function underlyingBalanceWithInvestmentForHolder(address holder) view external returns (uint256);
508 
509     // hard work should be callable only by the controller (by the hard worker) or by governance
510     function doHardWork() external;
511     function rebalance() external;
512 }
513 
514 // File: contracts/hardworkInterface/IController.sol
515 
516 pragma solidity 0.5.16;
517 
518 interface IController {
519     // [Grey list]
520     // An EOA can safely interact with the system no matter what.
521     // If you're using Metamask, you're using an EOA.
522     // Only smart contracts may be affected by this grey list.
523     //
524     // This contract will not be able to ban any EOA from the system
525     // even if an EOA is being added to the greyList, he/she will still be able
526     // to interact with the whole system as if nothing happened.
527     // Only smart contracts will be affected by being added to the greyList.
528     // This grey list is only used in Vault.sol, see the code there for reference
529     function greyList(address _target) external returns(bool);
530 
531     function addVaultAndStrategy(address _vault, address _strategy) external;
532     function doHardWork(address _vault) external;
533     function hasVault(address _vault) external returns(bool);
534 
535     function salvage(address _token, uint256 amount) external;
536     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
537 
538     function notifyFee(address _underlying, uint256 fee) external;
539     function profitSharingNumerator() external view returns (uint256);
540     function profitSharingDenominator() external view returns (uint256);
541 }
542 
543 // File: contracts/DepositHelper.sol
544 
545 pragma solidity 0.5.16;
546 
547 
548 
549 
550 
551 
552 
553 
554 contract DepositHelper is Controllable {
555   using SafeERC20 for IERC20;
556   using Address for address;
557   using SafeMath for uint256;
558 
559   event DepositComplete(
560     address holder,
561     uint numberOfTransfers
562   );
563 
564   // Only smart contracts will be affected by this modifier
565   modifier defense() {
566     require(
567       (msg.sender == tx.origin) ||                // If it is a normal user and not smart contract,
568                                                   // then the requirement will pass
569       !IController(store.controller()).greyList(msg.sender),         // If it is a smart contract, then make sure that
570       "DH: This smart contract has been grey listed"  // it is not on our greyList.
571     );
572     _;
573   }
574 
575   constructor(address _storage)
576   Controllable(_storage) public {}
577 
578   /*
579   * Transfers tokens of all kinds
580   */
581   function depositAll(uint256[] memory amounts, address[] memory vaultAddresses) public defense {
582     require(amounts.length == vaultAddresses.length, "DH: amounts and vault lengths mismatch");
583     for (uint i = 0; i < vaultAddresses.length; i++) {
584       if (amounts[i] == 0) {
585         continue;
586       }
587       require(IController(store.controller()).hasVault(vaultAddresses[i]), 'DH: vault is not present in controller');
588       IVault currentVault = IVault(vaultAddresses[i]);
589       IERC20 underlying = IERC20(currentVault.underlying());
590 
591       underlying.safeTransferFrom(msg.sender, address(this), amounts[i]);
592       underlying.safeApprove(address(currentVault), 0);
593       underlying.safeApprove(address(currentVault), amounts[i]);
594       currentVault.depositFor(amounts[i], msg.sender);
595     }
596   }
597 }