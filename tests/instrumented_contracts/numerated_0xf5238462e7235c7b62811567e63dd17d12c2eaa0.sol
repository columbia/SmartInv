1 pragma solidity 0.5.16;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 /**
5  * @dev Contract module which provides a basic access control mechanism, where
6  * there is an account (an owner) that can be granted exclusive access to
7  * specific functions.
8  *
9  * This module is used through inheritance. It will make available the modifier
10  * `onlyOwner`, which can be aplied to your functions to restrict their use to
11  * the owner.
12  */
13 contract Ownable {
14     address private _owner;
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16     /**
17      * @dev Initializes the contract setting the deployer as the initial owner.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23     /**
24      * @dev Returns the address of the current owner.
25      */
26     function owner() public view returns (address) {
27         return _owner;
28     }
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner(), "Ownable: caller is not the owner");
34         _;
35     }
36     /**
37      * @dev Returns true if the caller is the current owner.
38      */
39     function isOwner() public view returns (bool) {
40         return msg.sender == _owner;
41     }
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * > Note: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipTransferred(_owner, address(0));
51         _owner = address(0);
52     }
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public onlyOwner {
58         _transferOwnership(newOwner);
59     }
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      */
63     function _transferOwnership(address newOwner) internal {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 /**
71  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
72  * the optional functions; to access them see `ERC20Detailed`.
73  */
74 interface IERC20 {
75     /**
76      * @dev Returns the amount of tokens in existence.
77      */
78     function totalSupply() external view returns (uint256);
79     /**
80      * @dev Returns the amount of tokens owned by `account`.
81      */
82     function balanceOf(address account) external view returns (uint256);
83     /**
84      * @dev Moves `amount` tokens from the caller's account to `recipient`.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a `Transfer` event.
89      */
90     function transfer(address recipient, uint256 amount) external returns (bool);
91     /**
92      * @dev Returns the remaining number of tokens that `spender` will be
93      * allowed to spend on behalf of `owner` through `transferFrom`. This is
94      * zero by default.
95      *
96      * This value changes when `approve` or `transferFrom` are called.
97      */
98     function allowance(address owner, address spender) external view returns (uint256);
99     /**
100      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * > Beware that changing an allowance with this method brings the risk
105      * that someone may use both the old and the new allowance by unfortunate
106      * transaction ordering. One possible solution to mitigate this race
107      * condition is to first reduce the spender's allowance to 0 and set the
108      * desired value afterwards:
109      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110      *
111      * Emits an `Approval` event.
112      */
113     function approve(address spender, uint256 amount) external returns (bool);
114     /**
115      * @dev Moves `amount` tokens from `sender` to `recipient` using the
116      * allowance mechanism. `amount` is then deducted from the caller's
117      * allowance.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a `Transfer` event.
122      */
123     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to `approve`. `value` is the new allowance.
134      */
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
138 /**
139  * @dev Wrappers over Solidity's arithmetic operations with added overflow
140  * checks.
141  *
142  * Arithmetic operations in Solidity wrap on overflow. This can easily result
143  * in bugs, because programmers usually assume that an overflow raises an
144  * error, which is the standard behavior in high level programming languages.
145  * `SafeMath` restores this intuition by reverting the transaction when an
146  * operation overflows.
147  *
148  * Using this library instead of the unchecked operations eliminates an entire
149  * class of bugs, so it's recommended to use it always.
150  */
151 library SafeMath {
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a + b;
163         require(c >= a, "SafeMath: addition overflow");
164         return c;
165     }
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         require(b <= a, "SafeMath: subtraction overflow");
177         uint256 c = a - b;
178         return c;
179     }
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
193         if (a == 0) {
194             return 0;
195         }
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198         return c;
199     }
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Solidity only automatically asserts when dividing by 0
213         require(b > 0, "SafeMath: division by zero");
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216         return c;
217     }
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b != 0, "SafeMath: modulo by zero");
231         return a % b;
232     }
233 }
234 // File: contracts/LockedGoldOracle.sol
235 // Simple contract regulating the total supply of gold locked at any
236 // given time so that the Cache contract can't over mint tokens
237 contract LockedGoldOracle is Ownable {
238   using SafeMath for uint256;
239   uint256 private _lockedGold;
240   address private _cacheContract;
241   event LockEvent(uint256 amount);
242   event UnlockEvent(uint256 amount);
243   function setCacheContract(address cacheContract) external onlyOwner {
244     _cacheContract = cacheContract;
245   }
246   function lockAmount(uint256 amountGrams) external onlyOwner {
247     _lockedGold = _lockedGold.add(amountGrams);
248     emit LockEvent(amountGrams);
249   }
250   // Can only unlock amount of gold if it would leave the
251   // total amount of locked gold greater than or equal to the
252   // number of tokens in circulation
253   function unlockAmount(uint256 amountGrams) external onlyOwner {
254     _lockedGold = _lockedGold.sub(amountGrams);
255     require(_lockedGold >= CacheGold(_cacheContract).totalCirculation());
256     emit UnlockEvent(amountGrams);
257   }
258   function lockedGold() external view returns(uint256) {
259     return _lockedGold;
260   }
261   function cacheContract() external view returns(address) {
262     return _cacheContract;
263   }
264 }
265 // File: contracts/CacheGold.sol
266 /// @title The CacheGold Token Contract
267 /// @author Cache Pte Ltd
268 contract CacheGold is IERC20, Ownable {
269   using SafeMath for uint256;
270   // ERC20 Detailed Info
271   /* solhint-disable */
272   string public constant name = "CACHE Gold";
273   string public constant symbol = "CGT";
274   uint8 public constant decimals = 8;
275   /* solhint-enable */
276   // 10^8 shortcut
277   uint256 private constant TOKEN = 10 ** uint256(decimals);
278   // Seconds in a day
279   uint256 private constant DAY = 86400;
280   // Days in a year
281   uint256 private constant YEAR = 365;
282   // The maximum transfer fee is 10 basis points
283   uint256 private constant MAX_TRANSFER_FEE_BASIS_POINTS = 10;
284   // Basis points means divide by 10,000 to get decimal
285   uint256 private constant BASIS_POINTS_MULTIPLIER = 10000;
286   // The storage fee of 0.25%
287   uint256 private constant STORAGE_FEE_DENOMINATOR = 40000000000;
288   // The inactive fee of 0.50%
289   uint256 private constant INACTIVE_FEE_DENOMINATOR = 20000000000;
290   // The minimum balance that would accrue a storage fee after 1 day
291   uint256 private constant MIN_BALANCE_FOR_FEES = 146000;
292   // Initial basis points for transfer fee
293   uint256 private _transferFeeBasisPoints = 10;
294   // Cap on total number of tokens that can ever be produced
295   uint256 public constant SUPPLY_CAP = 8133525786 * TOKEN;
296   // How many days need to pass before late fees can be collected (3 years)
297   uint256 public constant INACTIVE_THRESHOLD_DAYS = 1095;
298   // Token balance of each address
299   mapping (address => uint256) private _balances;
300   // Allowed transfer from address
301   mapping (address => mapping (address => uint256)) private _allowances;
302   // Last time storage fee was paid
303   mapping (address => uint256) private _timeStorageFeePaid;
304   // Last time the address produced a transaction on this contract
305   mapping (address => uint256) private _timeLastActivity;
306   // Amount of inactive fees already paid
307   mapping (address => uint256) private _inactiveFeePaid;
308   // If address doesn't have any activity for INACTIVE_THRESHOLD_DAYS
309   // we can start deducting chunks off the address so that
310   // full balance can be recouped after 200 years. This is likely
311   // to happen if the user loses their private key.
312   mapping (address => uint256) private _inactiveFeePerYear;
313   // Addresses not subject to transfer fees
314   mapping (address => bool) private _transferFeeExempt;
315   // Address is not subject to storage fees
316   mapping (address => bool) private _storageFeeExempt;
317   // Save grace period on storage fees for an address
318   mapping (address => uint256) private _storageFeeGracePeriod;
319   // Current total number of tokens created
320   uint256 private _totalSupply;
321   // Address where storage and transfer fees are collected
322   address private _feeAddress;
323   // The address for the "backed treasury". When a bar is locked into the
324   // vault for tokens to be minted, they are created in the backed_treasury
325   // and can then be sold from this address.
326   address private _backedTreasury;
327   // The address for the "unbacked treasury". The unbacked treasury is a
328   // storing address for excess tokens that are not locked in the vault
329   // and therefore do not correspond to any real world value. If new bars are
330   // locked in the vault, tokens will first be moved from the unbacked
331   // treasury to the backed treasury before minting new tokens.
332   //
333   // This address only accepts transfers from the _backedTreasury or _redeemAddress
334   // the general public should not be able to manipulate this balance.
335   address private _unbackedTreasury;
336   // The address for the LockedGoldOracle that determines the maximum number of
337   // tokens that can be in circulation at any given time
338   address private _oracle;
339   // A fee-exempt address that can be used to collect gold tokens in exchange
340   // for redemption of physical gold
341   address private _redeemAddress;
342   // An address that can force addresses with overdue storage or inactive fee to pay.
343   // This is separate from the contract owner, because the owner will change
344   // to a multisig address after deploy, and we want to be able to write
345   // a script that can sign "force-pay" transactions with a single private key
346   address private _feeEnforcer;
347   // Grace period before storage fees kick in
348   uint256 private _storageFeeGracePeriodDays = 0;
349   // When gold bars are locked, we add tokens to circulation either
350   // through moving them from the unbacked treasury or minting new ones,
351   // or some combination of both
352   event AddBackedGold(uint256 amount);
353   // Before gold bars can be unlocked (removed from circulation), they must
354   // be moved to the unbacked treasury, we emit an event when this happens
355   // to signal a change in the circulating supply
356   event RemoveGold(uint256 amount);
357   // When an account has no activity for INACTIVE_THRESHOLD_DAYS
358   // it will be flagged as inactive
359   event AccountInactive(address indexed account, uint256 feePerYear);
360   // If an previoulsy dormant account is reactivated
361   event AccountReActive(address indexed account);
362   /**
363    * @dev Contructor for the CacheGold token sets internal addresses
364    * @param unbackedTreasury The address of the unbacked treasury
365    * @param backedTreasury The address of the backed treasury
366    * @param feeAddress The address where fees are collected
367    * @param redeemAddress The address where tokens are send to redeem physical gold
368    * @param oracle The address of the LockedGoldOracle
369    */
370   constructor(address unbackedTreasury,
371               address backedTreasury,
372               address feeAddress,
373               address redeemAddress,
374               address oracle) public {
375     _unbackedTreasury = unbackedTreasury;
376     _backedTreasury = backedTreasury;
377     _feeAddress = feeAddress;
378     _redeemAddress = redeemAddress;
379     _feeEnforcer = owner();
380     _oracle = oracle;
381     setFeeExempt(_feeAddress);
382     setFeeExempt(_redeemAddress);
383     setFeeExempt(_backedTreasury);
384     setFeeExempt(_unbackedTreasury);
385     setFeeExempt(owner());
386   }
387   /**
388    * @dev Throws if called by any account other than THE ENFORCER
389    */
390   modifier onlyEnforcer() {
391     require(msg.sender == _feeEnforcer);
392     _;
393   }
394   /**
395   * @dev Transfer token for a specified address
396   * @param to The address to transfer to.
397   * @param value The amount to be transferred.
398   */
399   function transfer(address to, uint256 value) external returns (bool) {
400     // Update activity for the sender
401     _updateActivity(msg.sender);
402     // Can opportunistically mark an account inactive if someone
403     // sends money to it
404     if (_shouldMarkInactive(to)) {
405       _setInactive(to);
406     }
407     _transfer(msg.sender, to, value);
408     return true;
409   }
410   /**
411   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
412   * Beware that changing an allowance with this method brings the risk that someone may use both the old
413   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
414   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
415   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
416   * @param spender The address which will spend the funds.
417   * @param value The amount of tokens to be spent.
418   */
419   function approve(address spender, uint256 value) external returns (bool) {
420     _updateActivity(msg.sender);
421     _approve(msg.sender, spender, value);
422     return true;
423   }
424   /**
425   * @dev Transfer tokens from one address to another.
426   * Note that while this function emits an Approval event, this is not required as per the specification,
427   * and other compliant implementations may not emit the event.
428   * Also note that even though balance requirements are not explicitly checked,
429   * any transfer attempt over the approved amount will automatically fail due to
430   * SafeMath revert when trying to subtract approval to a negative balance
431   * @param from address The address which you want to send tokens from
432   * @param to address The address which you want to transfer to
433   * @param value uint256 the amount of tokens to be transferred
434   */
435   function transferFrom(address from, address to, uint256 value) external returns (bool) {
436     _updateActivity(msg.sender);
437     _transfer(from, to, value);
438     _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
439     return true;
440   }
441   /**
442   * @dev Increase the amount of tokens that an owner allowed to a spender.
443   * approve should be called when allowed_[_spender] == 0. To increment
444   * allowed value is better to use this function to avoid 2 calls (and wait until
445   * the first transaction is mined)
446   * From MonolithDAO Token.sol
447   * Emits an Approval event.
448   * @param spender The address which will spend the funds.
449   * @param addedValue The amount of tokens to increase the allowance by.
450   */
451   function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
452     _updateActivity(msg.sender);
453     _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
454     return true;
455   }
456   /**
457   * @dev Decrease the amount of tokens that an owner allowed to a spender.
458   * approve should be called when allowed_[_spender] == 0. To decrement
459   * allowed value is better to use this function to avoid 2 calls (and wait until
460   * the first transaction is mined)
461   * From MonolithDAO Token.sol
462   * Emits an Approval event.
463   * @param spender The address which will spend the funds.
464   * @param subtractedValue The amount of tokens to decrease the allowance by.
465   */
466   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
467     _updateActivity(msg.sender);
468     _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
469     return true;
470   }
471   /**
472   * @dev Function to add a certain amount of backed tokens. This will first
473   * take any tokens from the _unbackedTreasury address and move them to the
474   * _backedTreasury. Any remaining tokens will actually be minted.
475   * This operation will fail if there is not a sufficient supply of locked gold
476   * as determined by the LockedGoldOracle
477   *
478   * @param value The amount of tokens to add to the backed treasury
479   * @return A boolean that indicates if the operation was successful.
480   */
481   function addBackedTokens(uint256 value) external onlyOwner returns (bool)
482   {
483     uint256 unbackedBalance = _balances[_unbackedTreasury];
484     // Use oracle to check if there is actually enough gold
485     // in custody to validate this operation
486     uint256 lockedGrams =  LockedGoldOracle(_oracle).lockedGold();
487     // Should reject mint if it would make the total supply
488     // exceed the amount actually locked in vault
489     require(lockedGrams >= totalCirculation().add(value),
490             "Insufficent grams locked in LockedGoldOracle to complete operation");
491     // If we have sufficient balance, just move from the unbacked to backed
492     // treasury address
493     if (value <= unbackedBalance) {
494       _transfer(_unbackedTreasury, _backedTreasury, value);
495     } else {
496       if (unbackedBalance > 0) {
497         // There is no sufficient balance, so we have to both transfer and mint new tokens
498         // Transfer the remaining unbacked treasury balance to backed treasury
499         _transfer(_unbackedTreasury, _backedTreasury, unbackedBalance);
500       }
501       // And mint the remaining to the backed treasury
502       _mint(value.sub(unbackedBalance));
503     }
504     emit AddBackedGold(value);
505     return true;
506   }
507   /**
508   * @dev Manually pay storage fees on senders address. Exchanges may want to
509   * periodically call this function to pay owed storage fees. This is a
510   * cheaper option than 'send to self', which would also trigger paying
511   * storage fees
512   *
513   * @return A boolean that indicates if the operation was successful.
514   */
515   function payStorageFee() external returns (bool) {
516     _updateActivity(msg.sender);
517     _payStorageFee(msg.sender);
518     return true;
519   }
520   function setAccountInactive(address account) external onlyEnforcer returns (bool) {
521     require(_shouldMarkInactive(account), "Account not eligible to be marked inactive");
522     _setInactive(account);
523   }
524   /**
525   * @dev Contract allows the forcible collection of storage fees on an address
526   * if it is has been more than than 365 days since the last time storage fees
527   * were paid on this address.
528   *
529   * Alternatively inactive fees may also be collected periodically on a prorated
530   * basis if the account is currently marked as inactive.
531   *
532   * @param account The address to pay storage fees on
533   * @return A boolean that indicates if the operation was successful.
534   */
535   function forcePayFees(address account) external onlyEnforcer returns(bool) {
536     require(account != address(0));
537     require(_balances[account] > 0,
538             "Account has no balance, cannot force paying fees");
539     // If account is inactive, pay inactive fees
540     if (isInactive(account)) {
541       uint256 paid = _payInactiveFee(account);
542       require(paid > 0);
543     } else if (_shouldMarkInactive(account)) {
544       // If it meets inactive threshold, but hasn't been set yet, set it.
545       // This will also trigger automatic payment of owed storage fees
546       // before starting inactive fees
547       _setInactive(account);
548     } else {
549       // Otherwise just force paying owed storage fees, which can only
550       // be called if they are more than 365 days overdue
551       require(daysSincePaidStorageFee(account) >= YEAR,
552               "Account has paid storage fees more recently than 365 days");
553       uint256 paid = _payStorageFee(account);
554       require(paid > 0, "No appreciable storage fees due, will refund gas");
555     }
556   }
557   /**
558   * @dev Set the address that can force collecting fees from users
559   * @param enforcer The address to force collecting fees
560   * @return An bool representing successfully changing enforcer address
561   */
562   function setFeeEnforcer(address enforcer) external onlyOwner returns(bool) {
563     require(enforcer != address(0));
564     _feeEnforcer = enforcer;
565     setFeeExempt(_feeEnforcer);
566     return true;
567   }
568   /**
569   * @dev Set the address to collect fees
570   * @param newFeeAddress The address to collect storage and transfer fees
571   * @return An bool representing successfully changing fee address
572   */
573   function setFeeAddress(address newFeeAddress) external onlyOwner returns(bool) {
574     require(newFeeAddress != address(0));
575     require(newFeeAddress != _unbackedTreasury,
576             "Cannot set fee address to unbacked treasury");
577     _feeAddress = newFeeAddress;
578     setFeeExempt(_feeAddress);
579     return true;
580   }
581   /**
582   * @dev Set the address to deposit tokens when redeeming for physical locked bars.
583   * @param newRedeemAddress The address to redeem tokens for bars
584   * @return An bool representing successfully changing redeem address
585   */
586   function setRedeemAddress(address newRedeemAddress) external onlyOwner returns(bool) {
587     require(newRedeemAddress != address(0));
588     require(newRedeemAddress != _unbackedTreasury,
589             "Cannot set redeem address to unbacked treasury");
590     _redeemAddress = newRedeemAddress;
591     setFeeExempt(_redeemAddress);
592     return true;
593   }
594   /**
595   * @dev Set the address of backed treasury
596   * @param newBackedAddress The address of backed treasury
597   * @return An bool representing successfully changing backed address
598   */
599   function setBackedAddress(address newBackedAddress) external onlyOwner returns(bool) {
600     require(newBackedAddress != address(0));
601     require(newBackedAddress != _unbackedTreasury,
602             "Cannot set backed address to unbacked treasury");
603     _backedTreasury = newBackedAddress;
604     setFeeExempt(_backedTreasury);
605     return true;
606   }
607   /**
608   * @dev Set the address to unbacked treasury
609   * @param newUnbackedAddress The address of unbacked treasury
610   * @return An bool representing successfully changing unbacked address
611   */
612   function setUnbackedAddress(address newUnbackedAddress) external onlyOwner returns(bool) {
613     require(newUnbackedAddress != address(0));
614     require(newUnbackedAddress != _backedTreasury,
615             "Cannot set unbacked treasury to backed treasury");
616     require(newUnbackedAddress != _feeAddress,
617             "Cannot set unbacked treasury to fee address ");
618     require(newUnbackedAddress != _redeemAddress,
619             "Cannot set unbacked treasury to fee address ");
620     _unbackedTreasury = newUnbackedAddress;
621     setFeeExempt(_unbackedTreasury);
622     return true;
623   }
624   /**
625   * @dev Set the LockedGoldOracle address
626   * @param oracleAddress The address for oracle
627   * @return An bool representing successfully changing oracle address
628   */
629   function setOracleAddress(address oracleAddress) external onlyOwner returns(bool) {
630     require(oracleAddress != address(0));
631     _oracle = oracleAddress;
632     return true;
633   }
634   /**
635   * @dev Set the number of days before storage fees begin accruing.
636   * @param daysGracePeriod The global setting for the grace period before storage
637   * fees begin accruing. Note that calling this will not change the grace period
638   * for addresses already actively inside a grace period
639   */
640   function setStorageFeeGracePeriodDays(uint256 daysGracePeriod) external onlyOwner {
641     _storageFeeGracePeriodDays = daysGracePeriod;
642   }
643   /**
644   * @dev Set this account as being exempt from transfer fees. This may be used
645   * in special circumstance for cold storage addresses owed by Cache, exchanges, etc.
646   * @param account The account to exempt from transfer fees
647   */
648   function setTransferFeeExempt(address account) external onlyOwner {
649     _transferFeeExempt[account] = true;
650   }
651   /**
652   * @dev Set this account as being exempt from storage fees. This may be used
653   * in special circumstance for cold storage addresses owed by Cache, exchanges, etc.
654   * @param account The account to exempt from storage fees
655   */
656   function setStorageFeeExempt(address account) external onlyOwner {
657     _storageFeeExempt[account] = true;
658   }
659   /**
660   * @dev Set account is no longer exempt from all fees
661   * @param account The account to reactivate fees
662   */
663   function unsetFeeExempt(address account) external onlyOwner {
664     _transferFeeExempt[account] = false;
665     _storageFeeExempt[account] = false;
666   }
667   /**
668   * @dev Set a new transfer fee in basis points, must be less than or equal to 10 basis points
669   * @param fee The new transfer fee in basis points
670   */
671   function setTransferFeeBasisPoints(uint256 fee) external onlyOwner {
672     require(fee <= MAX_TRANSFER_FEE_BASIS_POINTS,
673             "Transfer fee basis points must be an integer between 0 and 10");
674     _transferFeeBasisPoints = fee;
675   }
676   /**
677   * @dev Gets the balance of the specified address deducting owed fees and
678   * accounting for the maximum amount that could be sent including transfer fee
679   * @param owner The address to query the balance of.
680   * @return An uint256 representing the amount sendable by the passed address
681   * including transaction and storage fees
682   */
683   function balanceOf(address owner) external view returns (uint256) {
684     return calcSendAllBalance(owner);
685   }
686   /**
687   * @dev Gets the balance of the specified address not deducting owed fees.
688   * this returns the 'traditional' ERC-20 balance that represents the balance
689   * currently stored in contract storage.
690   * @param owner The address to query the balance of.
691   * @return An uint256 representing the amount stored in passed address
692   */
693   function balanceOfNoFees(address owner) external view returns (uint256) {
694     return _balances[owner];
695   }
696   /**
697   * @dev Total number of tokens in existence. This includes tokens
698   * in the unbacked treasury that are essentially unusable and not
699   * in circulation
700   * @return A uint256 representing the total number of minted tokens
701   */
702   function totalSupply() external view returns (uint256) {
703     return _totalSupply;
704   }
705   /**
706   * @dev Function to check the amount of tokens that an owner allowed to a spender.
707   * @param owner address The address which owns the funds.
708   * @param spender address The address which will spend the funds.
709   * @return A uint256 specifying the amount of tokens still available for the spender.
710   */
711   function allowance(address owner, address spender) external view returns (uint256) {
712     return _allowances[owner][spender];
713   }
714   /**
715   * @return address that can force paying overdue inactive fees
716   */
717   function feeEnforcer() external view returns(address) {
718     return _feeEnforcer;
719   }
720   /**
721    * @return address where fees are collected
722    */
723   function feeAddress() external view returns(address) {
724     return _feeAddress;
725   }
726   /**
727    * @return address for redeeming tokens for gold bars
728    */
729   function redeemAddress() external view returns(address) {
730     return _redeemAddress;
731   }
732   /**
733    * @return address for backed treasury
734    */
735   function backedTreasury() external view returns(address) {
736     return _backedTreasury;
737   }
738   /**
739   * @return address for unbacked treasury
740   */
741   function unbackedTreasury() external view returns(address) {
742     return _unbackedTreasury;
743   }
744   /**
745   * @return address for oracle contract
746   */
747   function oracleAddress() external view returns(address) {
748     return _oracle;
749   }
750   /**
751   * @return the current number of days and address is exempt
752   * from storage fees upon receiving tokens
753   */
754   function storageFeeGracePeriodDays() external view returns(uint256) {
755     return _storageFeeGracePeriodDays;
756   }
757   /**
758   * @return the current transfer fee in basis points [0-10]
759   */
760   function transferFeeBasisPoints() external view returns(uint256) {
761     return _transferFeeBasisPoints;
762   }
763   /**
764   * @dev Simulate the transfer from one address to another see final balances and associated fees
765   * @param from The address to transfer from.
766   * @param to The address to transfer to.
767   * @param value The amount to be transferred.
768   * @return See _simulateTransfer function
769   */
770   function simulateTransfer(address from, address to, uint256 value) external view returns (uint256[5] memory) {
771     return _simulateTransfer(from, to, value);
772   }
773   /**
774   * @dev Set this account as being exempt from all fees. This may be used
775   * in special circumstance for cold storage addresses owed by Cache, exchanges, etc.
776   * @param account The account to exempt from storage and transfer fees
777   */
778   function setFeeExempt(address account) public onlyOwner {
779     _transferFeeExempt[account] = true;
780     _storageFeeExempt[account] = true;
781   }
782   /**
783   * @dev Check if the address given is extempt from storage fees
784   * @param account The address to check
785   * @return A boolean if the address passed is exempt from storage fees
786   */
787   function isStorageFeeExempt(address account) public view returns(bool) {
788     return _storageFeeExempt[account];
789   }
790   /**
791   * @dev Check if the address given is extempt from transfer fees
792   * @param account The address to check
793   * @return A boolean if the address passed is exempt from transfer fees
794   */
795   function isTransferFeeExempt(address account) public view returns(bool) {
796     return _transferFeeExempt[account];
797   }
798   /**
799   * @dev Check if the address given is extempt from transfer fees
800   * @param account The address to check
801   * @return A boolean if the address passed is exempt from transfer fees
802   */
803   function isAllFeeExempt(address account) public view returns(bool) {
804     return _transferFeeExempt[account] && _storageFeeExempt[account];
805   }
806   /**
807   * @dev Check if the address is considered inactive for not having transacted with
808   * the contract for INACTIVE_THRESHOLD_DAYS
809   * @param account The address to check
810   * @return A boolean if the address passed is considered inactive
811   */
812   function isInactive(address account) public view returns(bool) {
813     return _inactiveFeePerYear[account] > 0;
814   }
815   /**
816   * @dev Total number of tokens that are actually in circulation, which is
817   * total tokens excluding the unbacked treasury
818   * @return A uint256 representing the total number of tokens in circulation
819   */
820   function totalCirculation() public view returns (uint256) {
821     return _totalSupply.sub(_balances[_unbackedTreasury]);
822   }
823   /**
824   * @dev Get the number of days since the account last paid storage fees
825   * @param account The address to check
826   * @return A uint256 representing the number of days since storage fees where last paid
827   */
828   function daysSincePaidStorageFee(address account) public view returns(uint256) {
829     if (isInactive(account) || _timeStorageFeePaid[account] == 0) {
830       return 0;
831     }
832     return block.timestamp.sub(_timeStorageFeePaid[account]).div(DAY);
833   }
834   /**
835   * @dev Get the days since the account last sent a transaction to the contract (activity)
836   * @param account The address to check
837   * @return A uint256 representing the number of days since the address last had activity
838   * with the contract
839   */
840   function daysSinceActivity(address account) public view returns(uint256) {
841     if (_timeLastActivity[account] == 0) {
842       return 0;
843     }
844     return block.timestamp.sub(_timeLastActivity[account]).div(DAY);
845   }
846   /**
847   * @dev Returns the total number of fees owed on a particular address
848   * @param account The address to check
849   * @return The total storage and inactive fees owed on the address
850   */
851   function calcOwedFees(address account) public view returns(uint256) {
852     return calcStorageFee(account).add(calcInactiveFee(account));
853   }
854   /**
855    * @dev Calculate the current storage fee owed for a given address
856    * @param account The address to check
857    * @return A uint256 representing current storage fees for the address
858    */
859   function calcStorageFee(address account) public view returns(uint256) {
860     // If an account is in an inactive state those fees take over and
861     // storage fees are effectively paused
862     uint256 balance = _balances[account];
863     if (isInactive(account) || isStorageFeeExempt(account) || balance == 0) {
864       return 0;
865     }
866     uint256 daysSinceStoragePaid = daysSincePaidStorageFee(account);
867     uint256 daysInactive = daysSinceActivity(account);
868     uint256 gracePeriod = _storageFeeGracePeriod[account];
869     // If there is a grace period, we can deduct it from the daysSinceStoragePaid
870     if (gracePeriod > 0) {
871       if (daysSinceStoragePaid > gracePeriod) {
872         daysSinceStoragePaid = daysSinceStoragePaid.sub(gracePeriod);
873       } else {
874         daysSinceStoragePaid = 0;
875       }
876     }
877     if (daysSinceStoragePaid == 0) {
878       return 0;
879     }
880     // This is an edge case where the account has not yet been marked inactive, but
881     // will be marked inactive whenever there is a transaction allowing it to be marked.
882     // Therefore we know storage fees will only be valid up to a point, and inactive
883     // fees will take over.
884     if (daysInactive >= INACTIVE_THRESHOLD_DAYS) {
885       // This should not be at risk of being negative, because its impossible to force paying
886       // storage fees without also setting the account to inactive, so if we are here it means
887       // the last time storage fees were paid was BEFORE the account became eligible to be inactive
888       // and it's always the case that daysSinceStoragePaid > daysInactive.sub(INACTIVE_THRESHOLD_DAYS)
889       daysSinceStoragePaid = daysSinceStoragePaid.sub(daysInactive.sub(INACTIVE_THRESHOLD_DAYS));
890     }
891     // The normal case with normal storage fees
892     return storageFee(balance, daysSinceStoragePaid);
893   }
894   /**
895    * @dev Calculate the current inactive fee for a given address
896    * @param account The address to check
897    * @return A uint256 representing current inactive fees for the address
898    */
899   function calcInactiveFee(address account) public view returns(uint256) {
900     uint256 balance = _balances[account];
901     uint256 daysInactive = daysSinceActivity(account);
902     // if the account is marked inactive already, can use the snapshot balance
903     if (isInactive(account)) {
904       return _calcInactiveFee(balance,
905                           daysInactive,
906                           _inactiveFeePerYear[account],
907                           _inactiveFeePaid[account]);
908     } else if (_shouldMarkInactive(account)) {
909       // Account has not yet been marked inactive in contract, but the inactive fees will still be due.
910       // Just assume snapshotBalance will be current balance after fees
911       uint256 snapshotBalance = balance.sub(calcStorageFee(account));
912       return _calcInactiveFee(snapshotBalance,                          // current balance
913                               daysInactive,                             // number of days inactive
914                               _calcInactiveFeePerYear(snapshotBalance), // the inactive fee per year based on balance
915                               0);                                       // fees paid already
916     }
917     return 0;
918   }
919   /**
920    * @dev Calculate the amount that would clear the balance from the address
921    * accounting for owed storage and transfer fees
922    * accounting for storage and transfer fees
923    * @param account The address to check
924    * @return A uint256 representing total amount an address has available to send
925    */
926   function calcSendAllBalance(address account) public view returns (uint256) {
927     require(account != address(0));
928     // Internal addresses pay no fees, so they can send their entire balance
929     uint256 balanceAfterStorage = _balances[account].sub(calcOwedFees(account));
930     if (_transferFeeBasisPoints == 0 || isTransferFeeExempt(account)) {
931       return balanceAfterStorage;
932     }
933     // Edge cases where remaining balance is 0.00000001, but is effectively 0
934     if (balanceAfterStorage <= 1) {
935       return 0;
936     }
937     // Calculate the send all amount including storage fee
938     // Send All = Balance / 1.001
939     // and round up 0.00000001
940     uint256 divisor = TOKEN.add(_transferFeeBasisPoints.mul(BASIS_POINTS_MULTIPLIER));
941     uint256 sendAllAmount = balanceAfterStorage.mul(TOKEN).div(divisor).add(1);
942     // Calc transfer fee on send all amount
943     uint256 transFee = sendAllAmount.mul(_transferFeeBasisPoints).div(BASIS_POINTS_MULTIPLIER);
944     // Fix to include rounding errors
945     if (sendAllAmount.add(transFee) > balanceAfterStorage) {
946       return sendAllAmount.sub(1);
947     }
948     return sendAllAmount;
949   }
950   /*
951    * @dev Calculate the transfer fee on an amount
952    * @param value The value being sent
953    * @return A uint256 representing the transfer fee on sending the value given
954    */
955   function calcTransferFee(address account, uint256 value) public view returns(uint256) {
956     if (isTransferFeeExempt(account)) {
957       return 0;
958     }
959     // Basis points -> decimal multiplier:
960     // f(x) = x / 10,0000 (10 basis points is 0.001)
961     // So transfer fee working with integers =
962     // f(balance, basis) = (balance * TOKEN) / (10,000 * TOKEN / basis)
963     return value.mul(_transferFeeBasisPoints).div(BASIS_POINTS_MULTIPLIER);
964   }
965   /*
966    * @dev Calculate the storage fee for a given balance after a certain number of
967    * days have passed since the last time fees were paid.
968    * @param balance The current balance of the address
969    * @param daysSinceStoragePaid The number days that have passed since fees where last paid
970    * @return A uint256 representing the storage fee owed
971    */
972   function storageFee(uint256 balance, uint256 daysSinceStoragePaid) public pure returns(uint256) {
973     uint256 fee = balance.mul(TOKEN).mul(daysSinceStoragePaid).div(YEAR).div(STORAGE_FEE_DENOMINATOR);
974     if (fee > balance) {
975       return balance;
976     }
977     return fee;
978   }
979   /**
980    * @dev Approve an address to spend another addresses' tokens.
981    * @param owner The address that owns the tokens.
982    * @param spender The address that will spend the tokens.
983    * @param value The number of tokens that can be spent.
984    */
985   function _approve(address owner, address spender, uint256 value) internal {
986     require(spender != address(0));
987     require(owner != address(0));
988     _allowances[owner][spender] = value;
989     emit Approval(owner, spender, value);
990   }
991   /**
992   * @dev Transfer token for a specified addresses. Transfer is modified from a
993   * standard ERC20 contract in that it must also process transfer and storage fees
994   * for the token itself. Additionally there are certain internal addresses that
995   * are not subject to fees.
996   * @param from The address to transfer from.
997   * @param to The address to transfer to.
998   * @param value The amount to be transferred.
999   */
1000   function _transfer(address from, address to, uint256 value) internal {
1001     _transferRestrictions(to, from);
1002     // If the account was previously inactive and initiated the transfer, the
1003     // inactive fees and storage fees have already been paid by the time we get here
1004     // via the _updateActivity() call
1005     uint256 storageFeeFrom = calcStorageFee(from);
1006     uint256 storageFeeTo = 0;
1007     uint256 allFeeFrom = storageFeeFrom;
1008     uint256 balanceFromBefore = _balances[from];
1009     uint256 balanceToBefore = _balances[to];
1010     // If not sending to self can pay storage and transfer fee
1011     if (from != to) {
1012       // Need transfer fee and storage fee for receiver if not sending to self
1013       allFeeFrom = allFeeFrom.add(calcTransferFee(from, value));
1014       storageFeeTo = calcStorageFee(to);
1015       _balances[from] = balanceFromBefore.sub(value).sub(allFeeFrom);
1016       _balances[to] = balanceToBefore.add(value).sub(storageFeeTo);
1017       _balances[_feeAddress] = _balances[_feeAddress].add(allFeeFrom).add(storageFeeTo);
1018     } else {
1019       // Only storage fee if sending to self
1020       _balances[from] = balanceFromBefore.sub(storageFeeFrom);
1021       _balances[_feeAddress] = _balances[_feeAddress].add(storageFeeFrom);
1022     }
1023     // Regular Transfer
1024     emit Transfer(from, to, value);
1025     // Fee transfer on `from` address
1026     if (allFeeFrom > 0) {
1027       emit Transfer(from, _feeAddress, allFeeFrom);
1028       if (storageFeeFrom > 0) {
1029         _timeStorageFeePaid[from] = block.timestamp;
1030         _endGracePeriod(from);
1031       }
1032     }
1033     // If first time receiving coins, set the grace period
1034     // and start the the activity clock and storage fee clock
1035     if (_timeStorageFeePaid[to] == 0) {
1036       // We may change the grace period in the future so we want to
1037       // preserve it per address so there is no retroactive deduction
1038       _storageFeeGracePeriod[to] = _storageFeeGracePeriodDays;
1039       _timeLastActivity[to] = block.timestamp;
1040       _timeStorageFeePaid[to] = block.timestamp;
1041     }
1042     // Fee transfer on `to` address
1043     if (storageFeeTo > 0) {
1044       emit Transfer(to, _feeAddress, storageFeeTo);
1045       _timeStorageFeePaid[to] = block.timestamp;
1046       _endGracePeriod(to);
1047     } else if (balanceToBefore < MIN_BALANCE_FOR_FEES) {
1048       // MIN_BALANCE_FOR_FEES is the minimum amount in which a storage fee
1049       // would be due after a sigle day, so if the balance is above that,
1050       // the storage fee would always be greater than 0.
1051       //
1052       // This avoids the following condition:
1053       // 1. User receives tokens
1054       // 2. Users sends all but a tiny amount to another address
1055       // 3. A year later, the user receives more tokens. Because
1056       // their previous balance was super small, there were no appreciable
1057       // storage fee, therefore the storage fee clock was not reset
1058       // 4. User now owes storage fees on entire balance, as if they
1059       // held tokens for 1 year, instead of resetting the clock to now.
1060       _timeStorageFeePaid[to] = block.timestamp;
1061     }
1062     // If transferring to unbacked treasury, tokens are being taken from
1063     // circulation, because gold is being 'unlocked' from the vault
1064     if (to == _unbackedTreasury) {
1065       emit RemoveGold(value);
1066     }
1067   }
1068   /**
1069   * @dev Function to mint tokens to backed treasury. In general this method
1070   * will not be called on it's own, but instead will be called from
1071   * addBackedTokens.
1072   * @param value The amount of tokens to mint to backed treasury
1073   * @return A boolean that indicates if the operation was successful.
1074   */
1075   function _mint(uint256 value) internal returns(bool) {
1076     // Can't break supply cap
1077     require(_totalSupply.add(value) <= SUPPLY_CAP, "Call would exceed supply cap");
1078     // Can only mint if the unbacked treasury balance is 0
1079     require(_balances[_unbackedTreasury] == 0, "The unbacked treasury balance is not 0");
1080     // Can only mint to the backed treasury
1081     _totalSupply = _totalSupply.add(value);
1082     _balances[_backedTreasury] = _balances[_backedTreasury].add(value);
1083     emit Transfer(address(0), _backedTreasury, value);
1084     return true;
1085   }
1086   /**
1087    * @dev Apply storage fee deduction
1088    * @param account The account to pay storage fees
1089    * @return A uint256 representing the storage fee paid
1090    */
1091   function _payStorageFee(address account) internal returns(uint256) {
1092     uint256 storeFee = calcStorageFee(account);
1093     if (storeFee == 0) {
1094       return 0;
1095     }
1096     // Reduce account balance and add to fee address
1097     _balances[account] = _balances[account].sub(storeFee);
1098     _balances[_feeAddress] = _balances[_feeAddress].add(storeFee);
1099     emit Transfer(account, _feeAddress, storeFee);
1100     _timeStorageFeePaid[account] = block.timestamp;
1101     _endGracePeriod(account);
1102     return storeFee;
1103   }
1104   /**
1105    * @dev Apply inactive fee deduction
1106    * @param account The account to pay inactive fees
1107    * @return A uint256 representing the inactive fee paid
1108    */
1109   function _payInactiveFee(address account) internal returns(uint256) {
1110     uint256 fee = _calcInactiveFee(
1111         _balances[account],
1112         daysSinceActivity(account),
1113         _inactiveFeePerYear[account],
1114         _inactiveFeePaid[account]);
1115     if (fee == 0) {
1116       return 0;
1117     }
1118     _balances[account] = _balances[account].sub(fee);
1119     _balances[_feeAddress] = _balances[_feeAddress].add(fee);
1120     _inactiveFeePaid[account] = _inactiveFeePaid[account].add(fee);
1121     emit Transfer(account, _feeAddress, fee);
1122     return fee;
1123   }
1124   function _shouldMarkInactive(address account) internal view returns(bool) {
1125     // Can only mark an account as inactive if
1126     //
1127     // 1. it's not fee exempt
1128     // 2. it has a balance
1129     // 3. it's been over INACTIVE_THRESHOLD_DAYS since last activity
1130     // 4. it's not already marked inactive
1131     // 5. the storage fees owed already consume entire balance
1132     if (account != address(0) &&
1133         _balances[account] > 0 &&
1134         daysSinceActivity(account) >= INACTIVE_THRESHOLD_DAYS &&
1135         !isInactive(account) &&
1136         !isAllFeeExempt(account) &&
1137         _balances[account].sub(calcStorageFee(account)) > 0) {
1138       return true;
1139     }
1140     return false;
1141   }
1142   /**
1143   * @dev Mark an account as inactive. The function will automatically deduct
1144   * owed storage fees and inactive fees in one go.
1145   *
1146   * @param account The account to mark inactive
1147   */
1148   function _setInactive(address account) internal {
1149     // First get owed storage fees
1150     uint256 storeFee = calcStorageFee(account);
1151     uint256 snapshotBalance = _balances[account].sub(storeFee);
1152     // all _setInactive calls are wrapped in _shouldMarkInactive, which
1153     // already checks this, so we shouldn't hit this condition
1154     assert(snapshotBalance > 0);
1155     // Set the account inactive on deducted balance
1156     _inactiveFeePerYear[account] = _calcInactiveFeePerYear(snapshotBalance);
1157     emit AccountInactive(account, _inactiveFeePerYear[account]);
1158     uint256 inactiveFees = _calcInactiveFee(snapshotBalance,
1159                                             daysSinceActivity(account),
1160                                             _inactiveFeePerYear[account],
1161                                             0);
1162     // Deduct owed storage and inactive fees
1163     uint256 fees = storeFee.add(inactiveFees);
1164     _balances[account] = _balances[account].sub(fees);
1165     _balances[_feeAddress] = _balances[_feeAddress].add(fees);
1166     _inactiveFeePaid[account] = _inactiveFeePaid[account].add(inactiveFees);
1167     emit Transfer(account, _feeAddress, fees);
1168     // Reset storage fee clock if storage fees paid
1169     if (storeFee > 0) {
1170       _timeStorageFeePaid[account] = block.timestamp;
1171       _endGracePeriod(account);
1172     }
1173   }
1174   /**
1175   * @dev Update the activity clock on an account thats originated a transaction.
1176   * If the account has previously been marked inactive or should have been
1177   * marked inactive, it will opportunistically collect those owed fees.
1178   *
1179   * @param account The account to update activity
1180   */
1181   function _updateActivity(address account) internal {
1182     // Cache has the ability to force collecting storage and inactivity fees,
1183     // but in the event an address was missed, can we still detect if the
1184     // account was inactive when they next transact
1185     //
1186     // Here we simply set the account as being inactive, collect the previous
1187     // storage and inactive fees that were owed, and then reactivate the account
1188     if (_shouldMarkInactive(account)) {
1189       // Call will pay existing storage fees before marking inactive
1190       _setInactive(account);
1191     }
1192     // Pay remaining fees and reset fee clocks
1193     if (isInactive(account)) {
1194       _payInactiveFee(account);
1195       _inactiveFeePerYear[account] = 0;
1196       _timeStorageFeePaid[account] = block.timestamp;
1197       emit AccountReActive(account);
1198     }
1199     // The normal case will just hit this and update
1200     // the activity clock for the account
1201     _timeLastActivity[account] = block.timestamp;
1202   }
1203   /**
1204    * @dev Turn off storage fee grace period for an address the first
1205    * time storage fees are paid (after grace period has ended)
1206    * @param account The account to turn off storage fee grace period
1207    */
1208   function _endGracePeriod(address account) internal {
1209     if (_storageFeeGracePeriod[account] > 0) {
1210       _storageFeeGracePeriod[account] = 0;
1211     }
1212   }
1213   /**
1214   * @dev Enforce the rules of which addresses can transfer to others
1215   * @param to The sending address
1216   * @param from The receiving address
1217   */
1218   function _transferRestrictions(address to, address from) internal view {
1219     require(from != address(0));
1220     require(to != address(0));
1221     require(to != address(this), "Cannot transfer tokens to the contract");
1222     // unbacked treasury can only transfer to backed treasury
1223     if (from == _unbackedTreasury) {
1224       require(to == _backedTreasury,
1225               "Unbacked treasury can only transfer to backed treasury");
1226     }
1227     // redeem address can only transfer to unbacked or backed treasury
1228     if (from == _redeemAddress) {
1229       require((to == _unbackedTreasury) || (to == _backedTreasury),
1230               "Redeem address can only transfer to treasury");
1231     }
1232     // Only the backed treasury  and redeem address
1233     // can transfer to unbacked treasury
1234     if (to == _unbackedTreasury) {
1235       require((from == _backedTreasury) || (from == _redeemAddress),
1236               "Unbacked treasury can only receive from redeem address and backed treasury");
1237     }
1238     // Only the unbacked treasury can transfer to the backed treasury
1239     if (to == _backedTreasury) {
1240       require((from == _unbackedTreasury) || (from == _redeemAddress),
1241               "Only unbacked treasury and redeem address can transfer to backed treasury");
1242     }
1243   }
1244   /**
1245    * @dev Simulate the transfer from one address to another see final balances and associated fees
1246    * @param from address The address which you want to send tokens from
1247    * @param to address The address which you want to transfer to
1248    * @return a uint256 array of 5 values representing the
1249    * [0] storage fees `from`
1250    * [1] storage fees `to`
1251    * [2] transfer fee `from`
1252    * [3] final `from` balance
1253    * [4] final `to` balance
1254    */
1255   function _simulateTransfer(address from, address to, uint256 value) internal view returns (uint256[5] memory) {
1256     uint256[5] memory ret;
1257     // Return value slots
1258     // 0 - fees `from`
1259     // 1 - fees `to`
1260     // 2 - transfer fee `from`
1261     // 3 - final `from` balance
1262     // 4 - final `to` balance
1263     ret[0] = calcOwedFees(from);
1264     ret[1] = 0;
1265     ret[2] = 0;
1266     // Don't double charge storage fee sending to self
1267     if (from != to) {
1268       ret[1] = calcOwedFees(to);
1269       ret[2] = calcTransferFee(from, value);
1270       ret[3] = _balances[from].sub(value).sub(ret[0]).sub(ret[2]);
1271       ret[4] = _balances[to].add(value).sub(ret[1]);
1272     } else {
1273       ret[3] = _balances[from].sub(ret[0]);
1274       ret[4] = ret[3];
1275     }
1276     return ret;
1277   }
1278   /**
1279   * @dev Calculate the amount of inactive fees due per year on the snapshot balance.
1280   * Should return 50 basis points or 1 token minimum.
1281   *
1282   * @param snapshotBalance The balance of the account when marked inactive
1283   * @return uint256 the inactive fees due each year
1284   */
1285   function _calcInactiveFeePerYear(uint256 snapshotBalance) internal pure returns(uint256) {
1286     uint256 inactiveFeePerYear = snapshotBalance.mul(TOKEN).div(INACTIVE_FEE_DENOMINATOR);
1287     if (inactiveFeePerYear < TOKEN) {
1288       return TOKEN;
1289     }
1290     return inactiveFeePerYear;
1291   }
1292   /**
1293   * @dev Calcuate inactive fees due on an account
1294   * @param balance The current account balance
1295   * @param daysInactive The number of days the account has been inactive
1296   * @param feePerYear The inactive fee per year based on snapshot balance
1297   * @param paidAlready The amount of inactive fees that have been paid already
1298   * @return uint256 for inactive fees due
1299   */
1300   function _calcInactiveFee(uint256 balance,
1301                         uint256 daysInactive,
1302                         uint256 feePerYear,
1303                         uint256 paidAlready) internal pure returns(uint256) {
1304     uint256 daysDue = daysInactive.sub(INACTIVE_THRESHOLD_DAYS);
1305     uint256 totalDue = feePerYear.mul(TOKEN).mul(daysDue).div(YEAR).div(TOKEN).sub(paidAlready);
1306     // The fee per year can be off by 0.00000001 so we can collect
1307     // the final dust after 200 years
1308     if (totalDue > balance || balance.sub(totalDue) <= 200) {
1309       return balance;
1310     }
1311     return totalDue;
1312   }
1313 }