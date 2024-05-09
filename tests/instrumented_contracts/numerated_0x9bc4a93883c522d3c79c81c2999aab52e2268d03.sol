1 pragma solidity 0.5.10;
2 
3 interface IMultipleDistribution {
4     function initialize(address _tokenAddress) external;
5     function poolStake() external view returns (uint256);
6 }
7 
8 
9 interface IDistribution {
10     function supply() external view returns(uint256);
11     function poolAddress(uint8) external view returns(address);
12 }
13 
14 
15 interface IERC677MultiBridgeToken {
16     function transfer(address _to, uint256 _value) external returns (bool);
17     function transferDistribution(address _to, uint256 _value) external returns (bool);
18     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
19     function balanceOf(address _account) external view returns (uint256);
20 }
21 
22 
23 
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * This module is used through inheritance. It will make available the modifier
31  * `onlyOwner`, which can be aplied to your functions to restrict their use to
32  * the owner.
33  */
34 contract Ownable {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev Initializes the contract setting the deployer as the initial owner.
41      */
42     constructor () internal {
43         _owner = msg.sender;
44         emit OwnershipTransferred(address(0), _owner);
45     }
46 
47     /**
48      * @dev Returns the address of the current owner.
49      */
50     function owner() public view returns (address) {
51         return _owner;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(isOwner(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     /**
63      * @dev Returns true if the caller is the current owner.
64      */
65     function isOwner() public view returns (bool) {
66         return msg.sender == _owner;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * > Note: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public onlyOwner {
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      */
92     function _transferOwnership(address newOwner) internal {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b <= a, "SafeMath: subtraction overflow");
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Solidity only automatically asserts when dividing by 0
183         require(b > 0, "SafeMath: division by zero");
184         uint256 c = a / b;
185         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
192      * Reverts when dividing by zero.
193      *
194      * Counterpart to Solidity's `%` operator. This function uses a `revert`
195      * opcode (which leaves remaining gas untouched) while Solidity uses an
196      * invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         require(b != 0, "SafeMath: modulo by zero");
203         return a % b;
204     }
205 }
206 
207 
208 
209 /**
210  * @dev Collection of functions related to the address type,
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * This test is non-exhaustive, and there may be false-negatives: during the
217      * execution of a contract's constructor, its address will be reported as
218      * not containing a contract.
219      *
220      * > It is unsafe to assume that an address for which this function returns
221      * false is an externally-owned account (EOA) and not a contract.
222      */
223     function isContract(address account) internal view returns (bool) {
224         // This method relies in extcodesize, which returns 0 for contracts in
225         // construction, since the code is only stored at the end of the
226         // constructor execution.
227 
228         uint256 size;
229         // solhint-disable-next-line no-inline-assembly
230         assembly { size := extcodesize(account) }
231         return size > 0;
232     }
233 }
234 
235 
236 
237 
238 
239 /// @dev Distributes STAKE tokens.
240 contract Distribution is Ownable, IDistribution {
241     using SafeMath for uint256;
242     using Address for address;
243 
244     /// @dev Emits when `preInitialize` method has been called.
245     /// @param token The address of ERC677MultiBridgeToken.
246     /// @param caller The address of the caller.
247     event PreInitialized(address token, address caller);
248 
249     /// @dev Emits when `initialize` method has been called.
250     /// @param caller The address of the caller.
251     event Initialized(address caller);
252 
253     /// @dev Emits when an installment for the specified pool has been made.
254     /// @param pool The index of the pool.
255     /// @param value The installment value.
256     /// @param caller The address of the caller.
257     event InstallmentMade(uint8 indexed pool, uint256 value, address caller);
258 
259     /// @dev Emits when the pool address was changed.
260     /// @param pool The index of the pool.
261     /// @param oldAddress Old address.
262     /// @param newAddress New address.
263     event PoolAddressChanged(uint8 indexed pool, address oldAddress, address newAddress);
264 
265     /// @dev The instance of ERC677MultiBridgeToken.
266     IERC677MultiBridgeToken public token;
267 
268     uint8 public constant ECOSYSTEM_FUND = 1;
269     uint8 public constant PUBLIC_OFFERING = 2;
270     uint8 public constant PRIVATE_OFFERING = 3;
271     uint8 public constant ADVISORS_REWARD = 4;
272     uint8 public constant FOUNDATION_REWARD = 5;
273     uint8 public constant LIQUIDITY_FUND = 6;
274 
275     /// @dev Pool address.
276     mapping (uint8 => address) public poolAddress;
277     /// @dev Pool total amount of tokens.
278     mapping (uint8 => uint256) public stake;
279     /// @dev Amount of remaining tokens to distribute for the pool.
280     mapping (uint8 => uint256) public tokensLeft;
281     /// @dev Pool cliff period (in seconds).
282     mapping (uint8 => uint256) public cliff;
283     /// @dev Total number of installments for the pool.
284     mapping (uint8 => uint256) public numberOfInstallments;
285     /// @dev Number of installments that were made.
286     mapping (uint8 => uint256) public numberOfInstallmentsMade;
287     /// @dev The value of one-time installment for the pool.
288     mapping (uint8 => uint256) public installmentValue;
289     /// @dev The value to transfer to the pool at cliff.
290     mapping (uint8 => uint256) public valueAtCliff;
291     /// @dev Boolean variable that contains whether the value for the pool at cliff was paid or not.
292     mapping (uint8 => bool) public wasValueAtCliffPaid;
293     /// @dev Boolean variable that contains whether all installments for the pool were made or not.
294     mapping (uint8 => bool) public installmentsEnded;
295 
296     /// @dev The total token supply.
297     uint256 constant public supply = 8537500 ether;
298 
299     /// @dev The timestamp of the distribution start.
300     uint256 public distributionStartTimestamp;
301 
302     /// @dev The timestamp of pre-initialization.
303     uint256 public preInitializationTimestamp;
304     /// @dev Boolean variable that indicates whether the contract was pre-initialized.
305     bool public isPreInitialized = false;
306     /// @dev Boolean variable that indicates whether the contract was initialized.
307     bool public isInitialized = false;
308 
309     /// @dev Checks that the contract is initialized.
310     modifier initialized() {
311         require(isInitialized, "not initialized");
312         _;
313     }
314 
315     /// @dev Checks that the installments for the given pool are started and are not finished already.
316     /// @param _pool The index of the pool.
317     modifier active(uint8 _pool) {
318         require(
319             // solium-disable-next-line security/no-block-members
320             _now() >= distributionStartTimestamp.add(cliff[_pool]) && !installmentsEnded[_pool],
321             "installments are not active for this pool"
322         );
323         _;
324     }
325 
326     /// @dev Sets up constants and pools addresses that are used in distribution.
327     /// @param _ecosystemFundAddress The address of the Ecosystem Fund.
328     /// @param _publicOfferingAddress The address of the Public Offering.
329     /// @param _privateOfferingAddress The address of the Private Offering contract.
330     /// @param _advisorsRewardAddress The address of the Advisors Reward contract.
331     /// @param _foundationAddress The address of the Foundation Reward.
332     /// @param _liquidityFundAddress The address of the Liquidity Fund.
333     constructor(
334         address _ecosystemFundAddress,
335         address _publicOfferingAddress,
336         address _privateOfferingAddress,
337         address _advisorsRewardAddress,
338         address _foundationAddress,
339         address _liquidityFundAddress
340     ) public {
341         // validate provided addresses
342         require(
343             _privateOfferingAddress.isContract() &&
344             _advisorsRewardAddress.isContract(),
345             "not a contract address"
346         );
347         _validateAddress(_ecosystemFundAddress);
348         _validateAddress(_publicOfferingAddress);
349         _validateAddress(_foundationAddress);
350         _validateAddress(_liquidityFundAddress);
351         poolAddress[ECOSYSTEM_FUND] = _ecosystemFundAddress;
352         poolAddress[PUBLIC_OFFERING] = _publicOfferingAddress;
353         poolAddress[PRIVATE_OFFERING] = _privateOfferingAddress;
354         poolAddress[ADVISORS_REWARD] = _advisorsRewardAddress;
355         poolAddress[FOUNDATION_REWARD] = _foundationAddress;
356         poolAddress[LIQUIDITY_FUND] = _liquidityFundAddress;
357 
358         // initialize token amounts
359         stake[ECOSYSTEM_FUND] = 4000000 ether;
360         stake[PUBLIC_OFFERING] = 400000 ether;
361         stake[PRIVATE_OFFERING] = IMultipleDistribution(poolAddress[PRIVATE_OFFERING]).poolStake();
362         stake[ADVISORS_REWARD] = IMultipleDistribution(poolAddress[ADVISORS_REWARD]).poolStake();
363         stake[FOUNDATION_REWARD] = 699049 ether;
364         stake[LIQUIDITY_FUND] = 816500 ether;
365 
366         require(
367             stake[ECOSYSTEM_FUND] // solium-disable-line operator-whitespace
368                 .add(stake[PUBLIC_OFFERING])
369                 .add(stake[PRIVATE_OFFERING])
370                 .add(stake[ADVISORS_REWARD])
371                 .add(stake[FOUNDATION_REWARD])
372                 .add(stake[LIQUIDITY_FUND])
373             == supply,
374             "wrong sum of pools stakes"
375         );
376 
377         tokensLeft[ECOSYSTEM_FUND] = stake[ECOSYSTEM_FUND];
378         tokensLeft[PUBLIC_OFFERING] = stake[PUBLIC_OFFERING];
379         tokensLeft[PRIVATE_OFFERING] = stake[PRIVATE_OFFERING];
380         tokensLeft[ADVISORS_REWARD] = stake[ADVISORS_REWARD];
381         tokensLeft[FOUNDATION_REWARD] = stake[FOUNDATION_REWARD];
382         tokensLeft[LIQUIDITY_FUND] = stake[LIQUIDITY_FUND];
383 
384         valueAtCliff[ECOSYSTEM_FUND] = stake[ECOSYSTEM_FUND].mul(20).div(100);       // 20%
385         valueAtCliff[PRIVATE_OFFERING] = stake[PRIVATE_OFFERING].mul(10).div(100);   // 10%
386         valueAtCliff[ADVISORS_REWARD] = stake[ADVISORS_REWARD].mul(20).div(100);     // 20%
387         valueAtCliff[FOUNDATION_REWARD] = stake[FOUNDATION_REWARD].mul(20).div(100); // 20%
388 
389         cliff[ECOSYSTEM_FUND] = 336 days;
390         cliff[PRIVATE_OFFERING] = 28 days;
391         cliff[ADVISORS_REWARD] = 84 days;
392         cliff[FOUNDATION_REWARD] = 84 days;
393 
394         numberOfInstallments[ECOSYSTEM_FUND] = 336; // days
395         numberOfInstallments[PRIVATE_OFFERING] = 224; // days
396         numberOfInstallments[ADVISORS_REWARD] = 252; // days
397         numberOfInstallments[FOUNDATION_REWARD] = 252; // days
398 
399         installmentValue[ECOSYSTEM_FUND] = _calculateInstallmentValue(ECOSYSTEM_FUND);
400         installmentValue[PRIVATE_OFFERING] = _calculateInstallmentValue(
401             PRIVATE_OFFERING,
402             stake[PRIVATE_OFFERING].mul(35).div(100) // 25% will be distributed at pre-initializing and 10% at cliff
403         );
404         installmentValue[ADVISORS_REWARD] = _calculateInstallmentValue(ADVISORS_REWARD);
405         installmentValue[FOUNDATION_REWARD] = _calculateInstallmentValue(FOUNDATION_REWARD);
406     }
407 
408     /// @dev Pre-initializes the contract after the token is created.
409     /// Distributes tokens for Public Offering, Liquidity Fund, and part of Private Offering.
410     /// @param _tokenAddress The address of the STAKE token contract.
411     /// @param _initialStakeAmount The sum of initial stakes made on xDai chain before transitioning to POSDAO.
412     /// This amount must be sent to address(0) because it is excess on Mainnet side.
413     function preInitialize(address _tokenAddress, uint256 _initialStakeAmount) external onlyOwner {
414         require(!isPreInitialized, "already pre-initialized");
415 
416         token = IERC677MultiBridgeToken(_tokenAddress);
417         uint256 balance = token.balanceOf(address(this));
418         require(balance == supply, "wrong contract balance");
419 
420         preInitializationTimestamp = _now(); // solium-disable-line security/no-block-members
421         isPreInitialized = true;
422 
423         IMultipleDistribution(poolAddress[PRIVATE_OFFERING]).initialize(_tokenAddress);
424         IMultipleDistribution(poolAddress[ADVISORS_REWARD]).initialize(_tokenAddress);
425         uint256 privateOfferingPrerelease = stake[PRIVATE_OFFERING].mul(25).div(100); // 25%
426 
427         token.transferDistribution(poolAddress[PUBLIC_OFFERING], stake[PUBLIC_OFFERING]); // 100%
428         token.transfer(poolAddress[PRIVATE_OFFERING], privateOfferingPrerelease);
429 
430         uint256 liquidityFundDistribution = stake[LIQUIDITY_FUND].sub(_initialStakeAmount);
431         token.transferDistribution(poolAddress[LIQUIDITY_FUND], liquidityFundDistribution);
432         if (_initialStakeAmount > 0) {
433             token.transferDistribution(address(0), _initialStakeAmount);
434         }
435 
436         tokensLeft[PUBLIC_OFFERING] = tokensLeft[PUBLIC_OFFERING].sub(stake[PUBLIC_OFFERING]);
437         tokensLeft[PRIVATE_OFFERING] = tokensLeft[PRIVATE_OFFERING].sub(privateOfferingPrerelease);
438         tokensLeft[LIQUIDITY_FUND] = tokensLeft[LIQUIDITY_FUND].sub(stake[LIQUIDITY_FUND]);
439 
440         emit PreInitialized(_tokenAddress, msg.sender);
441         emit InstallmentMade(PUBLIC_OFFERING, stake[PUBLIC_OFFERING], msg.sender);
442         emit InstallmentMade(PRIVATE_OFFERING, privateOfferingPrerelease, msg.sender);
443         emit InstallmentMade(LIQUIDITY_FUND, liquidityFundDistribution, msg.sender);
444 
445         if (_initialStakeAmount > 0) {
446             emit InstallmentMade(0, _initialStakeAmount, msg.sender);
447         }
448     }
449 
450     /// @dev Initializes token distribution.
451     function initialize() external {
452         require(isPreInitialized, "not pre-initialized");
453         require(!isInitialized, "already initialized");
454 
455         if (_now().sub(preInitializationTimestamp) < 90 days) { // solium-disable-line security/no-block-members
456             require(isOwner(), "for now only owner can call this method");
457         }
458 
459         distributionStartTimestamp = _now(); // solium-disable-line security/no-block-members
460         isInitialized = true;
461 
462         emit Initialized(msg.sender);
463     }
464 
465     /// @dev Changes the address of the specified pool.
466     /// @param _pool The index of the pool (only ECOSYSTEM_FUND or FOUNDATION_REWARD are allowed).
467     /// @param _newAddress The new address for the change.
468     function changePoolAddress(uint8 _pool, address _newAddress) external {
469         require(_pool == ECOSYSTEM_FUND || _pool == FOUNDATION_REWARD, "wrong pool");
470         require(msg.sender == poolAddress[_pool], "not authorized");
471         _validateAddress(_newAddress);
472         emit PoolAddressChanged(_pool, poolAddress[_pool], _newAddress);
473         poolAddress[_pool] = _newAddress;
474     }
475 
476     /// @dev Makes an installment for one of the following pools:
477     /// Private Offering, Advisors Reward, Ecosystem Fund, Foundation Reward.
478     /// @param _pool The index of the pool.
479     function makeInstallment(uint8 _pool) public initialized active(_pool) {
480         require(
481             _pool == PRIVATE_OFFERING ||
482             _pool == ADVISORS_REWARD ||
483             _pool == ECOSYSTEM_FUND ||
484             _pool == FOUNDATION_REWARD,
485             "wrong pool"
486         );
487         uint256 value = 0;
488         if (!wasValueAtCliffPaid[_pool]) {
489             value = valueAtCliff[_pool];
490             wasValueAtCliffPaid[_pool] = true;
491         }
492         uint256 availableNumberOfInstallments = _calculateNumberOfAvailableInstallments(_pool);
493         value = value.add(installmentValue[_pool].mul(availableNumberOfInstallments));
494 
495         require(value > 0, "no installments available");
496 
497         uint256 remainder = _updatePoolData(_pool, value, availableNumberOfInstallments);
498         value = value.add(remainder);
499 
500         if (_pool == PRIVATE_OFFERING || _pool == ADVISORS_REWARD) {
501             token.transfer(poolAddress[_pool], value);
502         } else {
503             token.transferDistribution(poolAddress[_pool], value);
504         }
505 
506         emit InstallmentMade(_pool, value, msg.sender);
507     }
508 
509     /// @dev This method is called after the STAKE tokens are transferred to this contract.
510     function onTokenTransfer(address, uint256, bytes memory) public pure returns (bool) {
511         revert("sending tokens to this contract is not allowed");
512     }
513 
514     /// @dev The removed implementation of the ownership renouncing.
515     function renounceOwnership() public onlyOwner {
516         revert("not implemented");
517     }
518 
519     function _now() internal view returns (uint256) {
520         return now; // solium-disable-line security/no-block-members
521     }
522 
523     /// @dev Updates the given pool data after each installment:
524     /// the remaining number of tokens,
525     /// the number of made installments.
526     /// If the last installment are done and the tokens remained
527     /// then transfers them to the pool and marks that all installments for the given pool are made.
528     /// @param _pool The index of the pool.
529     /// @param _value Current installment value.
530     /// @param _currentNumberOfInstallments Number of installment that are made.
531     function _updatePoolData(
532         uint8 _pool,
533         uint256 _value,
534         uint256 _currentNumberOfInstallments
535     ) internal returns (uint256) {
536         uint256 remainder = 0;
537         tokensLeft[_pool] = tokensLeft[_pool].sub(_value);
538         numberOfInstallmentsMade[_pool] = numberOfInstallmentsMade[_pool].add(_currentNumberOfInstallments);
539         if (numberOfInstallmentsMade[_pool] >= numberOfInstallments[_pool]) {
540             if (tokensLeft[_pool] > 0) {
541                 remainder = tokensLeft[_pool];
542                 tokensLeft[_pool] = 0;
543             }
544             _endInstallment(_pool);
545         }
546         return remainder;
547     }
548 
549     /// @dev Marks that all installments for the given pool are made.
550     /// @param _pool The index of the pool.
551     function _endInstallment(uint8 _pool) internal {
552         installmentsEnded[_pool] = true;
553     }
554 
555     /// @dev Calculates the value of the installment for 1 day for the given pool.
556     /// @param _pool The index of the pool.
557     /// @param _valueAtCliff Custom value to distribute at cliff.
558     function _calculateInstallmentValue(
559         uint8 _pool,
560         uint256 _valueAtCliff
561     ) internal view returns (uint256) {
562         return stake[_pool].sub(_valueAtCliff).div(numberOfInstallments[_pool]);
563     }
564 
565     /// @dev Calculates the value of the installment for 1 day for the given pool.
566     /// @param _pool The index of the pool.
567     function _calculateInstallmentValue(uint8 _pool) internal view returns (uint256) {
568         return _calculateInstallmentValue(_pool, valueAtCliff[_pool]);
569     }
570 
571     /// @dev Calculates the number of available installments for the given pool.
572     /// @param _pool The index of the pool.
573     /// @return The number of available installments.
574     function _calculateNumberOfAvailableInstallments(
575         uint8 _pool
576     ) internal view returns (
577         uint256 availableNumberOfInstallments
578     ) {
579         uint256 paidDays = numberOfInstallmentsMade[_pool].mul(1 days);
580         uint256 lastTimestamp = distributionStartTimestamp.add(cliff[_pool]).add(paidDays);
581         // solium-disable-next-line security/no-block-members
582         availableNumberOfInstallments = _now().sub(lastTimestamp).div(1 days);
583         if (numberOfInstallmentsMade[_pool].add(availableNumberOfInstallments) > numberOfInstallments[_pool]) {
584             availableNumberOfInstallments = numberOfInstallments[_pool].sub(numberOfInstallmentsMade[_pool]);
585         }
586     }
587 
588     /// @dev Checks for an empty address.
589     function _validateAddress(address _address) internal pure {
590         if (_address == address(0)) {
591             revert("invalid address");
592         }
593     }
594 }