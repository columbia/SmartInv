1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.10;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 //Note that assert() is now used because the try/catch mechanism in the Pamp.sol contract does not revert on failure with require();
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations with added overflow
20  * checks.
21  *
22  * Arithmetic operations in Solidity wrap on overflow. This can easily result
23  * in bugs, because programmers usually assume that an overflow raises an
24  * error, which is the standard behavior in high level programming languages.
25  * `SafeMath` restores this intuition by reverting the transaction when an
26  * operation overflows.
27  *
28  * Using this library instead of the unchecked operations eliminates an entire
29  * class of bugs, so it's recommended to use it always.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, reverting on
34      * overflow.
35      *
36      * Counterpart to Solidity's `+` operator.
37      *
38      * Requirements:
39      * - Addition cannot overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a/*, "SafeMath: addition overflow"*/);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         assert(b <= a/*, errorMessage*/);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         assert(c / a == b/*, "SafeMath: multiplication overflow"*/);
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         assert(b > 0/*, errorMessage*/);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts with custom message when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         assert(b != 0/*, errorMessage*/);
162         return a % b;
163     }
164 }
165 
166 contract Ownable is Context {
167     address private _owner;
168 
169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171     /**
172      * @dev Initializes the contract setting the deployer as the initial owner.
173      */
174     constructor () internal {
175         address msgSender = _msgSender();
176         _owner = msgSender;
177         emit OwnershipTransferred(address(0), msgSender);
178     }
179 
180     /**
181      * @dev Returns the address of the current owner.
182      */
183     function owner() public view returns (address) {
184         return _owner;
185     }
186 
187     /**
188      * @dev Throws if called by any account other than the owner.
189      */
190     modifier onlyOwner() {
191         assert(_owner == _msgSender()/*, "Ownable: caller is not the owner"*/);
192         _;
193     }
194 
195     /**
196      * @dev Leaves the contract without owner. It will not be possible to call
197      * `onlyOwner` functions anymore. Can only be called by the current owner.
198      *
199      * NOTE: Renouncing ownership will leave the contract without an owner,
200      * thereby removing any functionality that is only available to the owner.
201      */
202     function renounceOwnership() public virtual onlyOwner {
203         emit OwnershipTransferred(_owner, address(0));
204         _owner = address(0);
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Can only be called by the current owner.
210      */
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         assert(newOwner != address(0)/*, "Ownable: new owner is the zero address"*/);
213         emit OwnershipTransferred(_owner, newOwner);
214         _owner = newOwner;
215     }
216 }
217 
218 // Contract used to calculate stakes. Unused currently.
219 
220 abstract contract CalculatorInterface {
221     function calculateNumTokens(uint256 balance, uint256 daysStaked, address stakerAddress, uint256 totalSupply) public virtual returns (uint256);
222     function randomness() public view virtual returns (uint256);
223 }
224 
225 
226 // Parent token contract, see Pamp.sol
227 abstract contract PampToken {
228     function balanceOf(address account) public view virtual returns (uint256);
229     function _burn(address account, uint256 amount) external virtual;
230 }
231 
232 
233 
234 /**
235  * @dev Implementation of the Pamp Network: https://pamp.network
236  * Pamp Network (PAMP) is the world's first price-reactive cryptocurrency.
237  * That is, the inflation rate of the token is wholly dependent on its market activity.
238  * Minting does not happen when the price is less than the day prior.
239  * When the price is greater than the day prior, the inflation for that day is
240  * a function of its price, percent increase, volume, any positive price streaks,
241  * and the amount of time any given holder has been holding.
242  * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
243  * This contract is the staking contract for the project and is upgradeable by the owner.
244  */
245 contract PampStaking is Ownable {
246     using SafeMath for uint256;
247     
248     // A 'staker' is an individual who holds the minimum staking amount in his address.
249     
250     struct staker {
251         uint startTimestamp;    // When the staking started in unix time (block.timesamp)
252         uint lastTimestamp;     // When the last staking reward was claimed in unix time (block.timestamp)
253     }
254     
255     struct update {             // Price updateState
256         uint timestamp;         // Last update timestamp, unix time
257         uint numerator;         // Numerator of percent change (1% increase = 1/100)
258         uint denominator;       // Denominator of percent change
259         uint price;         // In USD. 0001 is $0.001, 1000 is $1.000, 1001 is $1.001, etc
260         uint volume;        // In whole USD (100 = $100)
261     }
262     
263     PampToken public token;     // ERC20 token contract that uses this upgradeable contract for staking and burning
264     
265     modifier onlyToken() {
266         assert(_msgSender() == address(token)/*, "Caller must be PAMP token contract."*/);
267         _;
268     }
269     
270     modifier onlyNextStakingContract() {    // Caller must be the next staking contract
271         assert(_msgSender() == _nextStakingContract);
272         _;
273     }
274 
275     
276     mapping (address => staker) private _stakers;        // Mapping of all individuals staking/holding tokens greater than minStake
277     
278     mapping (address => string) private _whitelist;      // Mapping of all addresses that do not burn tokens on receive and send (generally other smart contracts). Mapping of address to reason (string)
279     
280     mapping (address => uint256) private _blacklist;     // Mapping of all addresses that receive a specific token burn when receiving. Mapping of address to percent burn (uint256)
281     
282 
283     bool private _enableBurns; // Enable burning on transfer or fee on transfer
284     
285     bool private _priceTarget1Hit;  // Price targets, defined in updateState()
286     
287     bool private _priceTarget2Hit;
288     
289     address public _uniswapV2Pair;      // Uniswap pair address, done for fees on Uniswap sells
290     
291     uint8 private _uniswapSellerBurnPercent;        // Uniswap sells pay a fee
292     
293     bool private _enableUniswapDirectBurns;         // Enable seller fees on Uniswap
294     
295     uint256 private _minStake;                      // Minimum amount to stake
296         
297     uint8 private _minStakeDurationDays;            // Minimum amount of time to claim staking rewards
298     
299     uint8 private _minPercentIncrease;              // Minimum percent increase to enable rewards for the day. 10 = 1.0%, 100 = 10.0%
300     
301     uint256 private _inflationAdjustmentFactor;     // Factor to adjust the amount of rewards (inflation) to be given out in a single day
302     
303     uint256 private _streak;                        // Number of days in a row that the price has increased
304     
305     update public _lastUpdate;                      // latest price update
306     
307     CalculatorInterface private _externalCalculator;    // external calculator to calculate the number of tokens given several variables (defined above). Currently unused
308     
309     address private _nextStakingContract;                // Next staking contract deployed. Used for migrating staker state.
310     
311     bool private _useExternalCalc;                      // self-explanatory
312     
313     bool private _freeze;                               // freeze all transfers in an emergency
314     
315     bool private _enableHoldersDay;                     // once a month, holders receive a nice bump
316     
317     event StakerRemoved(address StakerAddress);     // Staker was removed due to balance dropping below _minStake
318     
319     event StakerAdded(address StakerAddress);       // Staker was added due to balance increasing abolve _minStake
320     
321     event StakesUpdated(uint Amount);               // Staking rewards were claimed
322     
323     event MassiveCelebration();                     // Happens when price targets are hit
324     
325     event Transfer(address indexed from, address indexed to, uint256 value);        // self-explanatory
326     
327     
328     constructor (PampToken Token) public {
329         token = Token;
330         _minStake = 500E18;
331         _inflationAdjustmentFactor = 100;
332         _streak = 0;
333         _minStakeDurationDays = 0;
334         _useExternalCalc = false;
335         _uniswapSellerBurnPercent = 5;
336         _enableBurns = false;
337         _freeze = false;
338         _minPercentIncrease = 10; // 1.0% min increase
339         _enableUniswapDirectBurns = false;
340         
341     }
342     
343     // The owner (or price oracle) will call this function to update the price on days the coin is positive. On negative days, no update is made.
344     
345     function updateState(uint numerator, uint denominator, uint256 price, uint256 volume) external onlyOwner {  // when chainlink is integrated a separate contract will call this function (onlyOwner state will be changed as well)
346     
347         require(numerator > 0 && denominator > 0 && price > 0 && volume > 0, "Parameters cannot be negative or zero");
348         
349         if (numerator < 2 && denominator == 100 || numerator < 20 && denominator == 1000) {
350             require(mulDiv(1000, numerator, denominator) >= _minPercentIncrease, "Increase must be at least _minPercentIncrease to count");
351         }
352         
353         uint8 daysSinceLastUpdate = uint8((block.timestamp - _lastUpdate.timestamp) / 86400);       // We calculate time since last price update in days. Overflow is possible but incredibly unlikely.
354         
355         if (daysSinceLastUpdate == 0) { // We should only update once per day, but block timestamps can vary
356             _streak++;
357         } else if (daysSinceLastUpdate == 1) {
358             _streak++;  // If we updated yesterday and today, we are on a streak
359         } else {
360             _streak = 1;
361         }
362         
363         if (price >= 1000 && _priceTarget1Hit == false) { // 1000 = $1.00
364             _priceTarget1Hit = true;
365             _streak = 50;
366             emit MassiveCelebration();
367             
368         } else if (price >= 10000 && _priceTarget2Hit == false) {   // It is written, so it shall be done
369             _priceTarget2Hit = true;
370             _streak = 100;
371              _minStake = 100E18;        // Need $1000 to stake
372             emit MassiveCelebration();
373         }
374         
375         _lastUpdate = update(block.timestamp, numerator, denominator, price, volume);
376 
377     }
378     
379     function resetStakeTime() external {    // This is only necessary if a new staking contract is deployed. Resets 0 timestamp to block.timestamp
380         uint balance = token.balanceOf(msg.sender);
381         assert(balance > 0);
382         assert(balance >= _minStake);
383         
384         staker memory thisStaker = _stakers[msg.sender];
385         
386         if (thisStaker.lastTimestamp == 0) {
387             _stakers[msg.sender].lastTimestamp = block.timestamp;
388         }
389         if (thisStaker.startTimestamp == 0) {
390              _stakers[msg.sender].startTimestamp = block.timestamp;
391         }
392     }
393     
394     
395     // This is used by the next staking contract to migrate staker state
396     function resetStakeTimeMigrateState(address addr) external onlyNextStakingContract returns (uint256 startTimestamp, uint256 lastTimestamp) {
397         startTimestamp = _stakers[addr].startTimestamp;
398         lastTimestamp = _stakers[addr].lastTimestamp;
399         _stakers[addr].lastTimestamp = block.timestamp;
400         _stakers[addr].startTimestamp = block.timestamp;
401     }
402     
403     function updateMyStakes(address stakerAddress, uint256 balance, uint256 totalSupply) external onlyToken returns (uint256) {     // This function is called by the token contract. Holders call the function on the token contract every day the price is positive to claim rewards.
404         
405         assert(balance > 0);
406         
407         staker memory thisStaker = _stakers[stakerAddress];
408         
409         assert(thisStaker.lastTimestamp > 0/*,"Error: your last timestamp cannot be zero."*/); // We use asserts now so that we fail on errors due to try/catch in token contract.
410         
411         
412         assert(thisStaker.startTimestamp > 0/*,"Error: your start timestamp cannot be zero."*/);
413         
414         assert((block.timestamp.sub(_lastUpdate.timestamp)) / 86400 == 0/*, "Stakes must be updated the same day of the latest update"*/);      // We recognize that block.timestamp can be gamed by miners to some extent, but from what we undertand block timestamps *cannot be before the last block* by consensus rules, otherwise they will fork the chain
415 
416         
417         assert(block.timestamp > thisStaker.lastTimestamp/*, "Error: block timestamp is not greater than your last timestamp!"*/);
418         assert(_lastUpdate.timestamp > thisStaker.lastTimestamp/*, "Error: you can only update stakes once per day. You also cannot update stakes on the same day that you purchased them."*/);
419         
420         
421         
422         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
423         
424         assert(daysStaked >= _minStakeDurationDays/*, "You must stake for at least minStakeDurationDays to claim rewards"*/);
425         assert(balance >= _minStake/*, "You must have a balance of at least minStake to claim rewards"*/);
426 
427             
428         uint numTokens = calculateNumTokens(balance, daysStaked, stakerAddress, totalSupply);           // Calls token calculation function - this is either an external contract or the function in this contract
429         if (_enableHoldersDay && daysStaked >= 30) {
430             numTokens = mulDiv(balance, daysStaked, 600);   // Once a month, holders get a nice bump
431         }
432         
433         _stakers[stakerAddress].lastTimestamp = block.timestamp;        // Again, this can be gamed to some extent, but *cannot be before the last block*
434         emit StakesUpdated(numTokens);
435         
436         return numTokens;       // Token contract will add these tokens to the balance of stakerAddress
437     
438         
439     }
440 
441     function calculateNumTokens(uint256 balance, uint256 daysStaked, address stakerAddress, uint256 totalSupply) internal returns (uint256) {
442         
443         if (_useExternalCalc) {
444             return _externalCalculator.calculateNumTokens(balance, daysStaked, stakerAddress, totalSupply); // Use external contract, if one is enabled (disabled by default, currently unused)
445         }
446         
447         uint256 inflationAdjustmentFactor = _inflationAdjustmentFactor;
448         
449         if (_streak > 1) {
450             inflationAdjustmentFactor /= _streak;       // If there is a streak, we decrease the inflationAdjustmentFactor
451         }
452         
453         if (daysStaked > 60) {      // If you stake for more than 60 days, you have hit the upper limit of the multiplier
454             daysStaked = 60;
455         } else if (daysStaked == 0) {   // If the minimum days staked is zero, we change the number to 1 so we don't return zero below
456             daysStaked = 1;
457         }
458         
459         uint marketCap = mulDiv(totalSupply, _lastUpdate.price, 1000E18);       // Market cap (including locked team tokens)
460         
461         uint ratio = marketCap.div(_lastUpdate.volume);     // Ratio of market cap to volume
462         
463         if (ratio > 50) {  // Too little volume. Decrease rewards.
464             inflationAdjustmentFactor = inflationAdjustmentFactor.mul(10);
465         } else if (ratio > 25) { // Still not enough. Streak doesn't count.
466             inflationAdjustmentFactor = _inflationAdjustmentFactor;
467         }
468         
469         uint numTokens = mulDiv(balance, _lastUpdate.numerator * daysStaked, _lastUpdate.denominator * inflationAdjustmentFactor);      // Function that calculates how many tokens are due. See muldiv below.
470         uint tenPercent = mulDiv(balance, 1, 10);
471         
472         if (numTokens > tenPercent) {       // We don't allow a daily rewards of greater than ten percent of a holder's balance.
473             numTokens = tenPercent;
474         }
475         
476         return numTokens;
477     }
478     
479     // Self-explanatory functions to update several configuration variables
480     
481     function updateTokenAddress(PampToken newToken) external onlyOwner {
482         require(address(newToken) != address(0));
483         token = newToken;
484     }
485     
486     function updateCalculator(CalculatorInterface calc) external onlyOwner {
487         if(address(calc) == address(0)) {
488             _externalCalculator = CalculatorInterface(address(0));
489             _useExternalCalc = false;
490         } else {
491             _externalCalculator = calc;
492             _useExternalCalc = true;
493         }
494     }
495     
496     
497     function updateInflationAdjustmentFactor(uint256 inflationAdjustmentFactor) external onlyOwner {
498         _inflationAdjustmentFactor = inflationAdjustmentFactor;
499     }
500     
501     function updateStreak(uint streak) external onlyOwner {
502         _streak = streak;
503     }
504     
505     function updateMinStakeDurationDays(uint8 minStakeDurationDays) external onlyOwner {
506         _minStakeDurationDays = minStakeDurationDays;
507     }
508     
509     function updateMinStakes(uint minStake) external onlyOwner {
510         _minStake = minStake;
511     }
512     function updateMinPercentIncrease(uint8 minIncrease) external onlyOwner {
513         _minPercentIncrease = minIncrease;
514     }
515     
516     function enableBurns(bool enabledBurns) external onlyOwner {
517         _enableBurns = enabledBurns;
518     }
519     function updateHoldersDay(bool enableHoldersDay)   external onlyOwner {
520         _enableHoldersDay = enableHoldersDay;
521     }
522     
523     function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner returns (bool) {
524         if (remove) {
525             delete _whitelist[addr];
526             return true;
527         } else {
528             _whitelist[addr] = reason;
529             return true;
530         }
531         return false;        
532     }
533     
534     function updateBlacklist(address addr, uint256 fee, bool remove) external onlyOwner returns (bool) {
535         if (remove) {
536             delete _blacklist[addr];
537             return true;
538         } else {
539             _blacklist[addr] = fee;
540             return true;
541         }
542         return false;
543     }
544     
545     function updateUniswapPair(address addr) external onlyOwner returns (bool) {
546         require(addr != address(0));
547         _uniswapV2Pair = addr;
548         return true;
549     }
550     
551     function updateDirectSellBurns(bool enableDirectSellBurns) external onlyOwner {
552         _enableUniswapDirectBurns = enableDirectSellBurns;
553     }
554     
555     function updateUniswapSellerBurnPercent(uint8 sellerBurnPercent) external onlyOwner {
556         _uniswapSellerBurnPercent = sellerBurnPercent;
557     }
558     
559     function freeze(bool enableFreeze) external onlyOwner {
560         _freeze = enableFreeze;
561     }
562     
563     function updateNextStakingContract(address nextContract) external onlyOwner {
564         require(nextContract != address(0));
565         _nextStakingContract = nextContract;
566     }
567     
568     function getStaker(address staker) external view returns (uint256, uint256) {
569         return (_stakers[staker].startTimestamp, _stakers[staker].lastTimestamp);
570     }
571     
572     function getWhitelist(address addr) external view returns (string memory) {
573         return _whitelist[addr];
574     }
575     
576     function getBlacklist(address addr) external view returns (uint) {
577         return _blacklist[addr];
578     }
579 
580     
581     // This function was not written by us. It was taken from here: https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
582     // We believe it works but do not have the understanding of math required to verify it 100%.
583     // Takes in three numbers and calculates x * (y/z)
584     // This is very useful for this contract as percentages are used constantly
585 
586     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
587           (uint l, uint h) = fullMul (x, y);
588           assert (h < z);
589           uint mm = mulmod (x, y, z);
590           if (mm > l) h -= 1;
591           l -= mm;
592           uint pow2 = z & -z;
593           z /= pow2;
594           l /= pow2;
595           l += h * ((-pow2) / pow2 + 1);
596           uint r = 1;
597           r *= 2 - z * r;
598           r *= 2 - z * r;
599           r *= 2 - z * r;
600           r *= 2 - z * r;
601           r *= 2 - z * r;
602           r *= 2 - z * r;
603           r *= 2 - z * r;
604           r *= 2 - z * r;
605           return l * r;
606     }
607     
608     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
609           uint mm = mulmod (x, y, uint (-1));
610           l = x * y;
611           h = mm - l;
612           if (mm < l) h -= 1;
613     }
614     
615     function streak() public view returns (uint) {
616         return _streak;
617     }
618 
619 
620     // Hooks the transfer() function on pamptoken. All transfers call this function. Takes in sender, recipient address and balances and amount and returns sender balance, recipient balance, and burned amount
621     function transferHook(address sender, address recipient, uint256 amount, uint256 senderBalance, uint256 recipientBalance) external onlyToken returns (uint256, uint256, uint256) {
622         
623         assert(_freeze == false);
624         assert(sender != recipient);
625         assert(amount > 0);
626         assert(senderBalance >= amount);
627         
628         uint totalAmount = amount;
629         bool shouldAddStaker = true;    // We assume that the recipient is a potential staker (not a smart contract)
630         uint burnedAmount = 0;
631         
632         if (_enableBurns && bytes(_whitelist[sender]).length == 0 && bytes(_whitelist[recipient]).length == 0) { // Burns are enabled and neither the recipient nor the sender are whitelisted
633                 
634             burnedAmount = mulDiv(amount, _randomness(), 100);  // Calculates the amount to be burned. Random integer between 1% and 4%. See _randomness() below
635             
636             
637             if (_blacklist[recipient] > 0) {   //Transferring to a blacklisted address incurs a specific fee
638                 burnedAmount = mulDiv(amount, _blacklist[recipient], 100);      // Calculate the fee. The fee is burnt
639                 shouldAddStaker = false;            // Blacklisted addresses will never be stakers. 
640             }
641             
642             
643             
644             if (burnedAmount > 0) {
645                 if (burnedAmount > amount) {
646                     totalAmount = 0;
647                 } else {
648                     totalAmount = amount.sub(burnedAmount);
649                 }
650                 senderBalance = senderBalance.sub(burnedAmount, "ERC20: burn amount exceeds balance");  // Remove the burned amount from the sender's balance
651             }
652         } else if (recipient == _uniswapV2Pair) {    // Uniswap was used. This is a special case. Uniswap is burn on receive but whitelist on send, so sellers pay fee and buyers do not.
653             shouldAddStaker = false;
654            if (_enableUniswapDirectBurns) {
655                 burnedAmount = mulDiv(amount, _uniswapSellerBurnPercent, 100);     // Seller fee
656                 if (burnedAmount > 0) {
657                     if (burnedAmount > amount) {
658                         totalAmount = 0;
659                     } else {
660                         totalAmount = amount.sub(burnedAmount);
661                     }
662                     senderBalance = senderBalance.sub(burnedAmount, "ERC20: burn amount exceeds balance");
663                 }
664             }
665         
666         }
667         
668         if (bytes(_whitelist[recipient]).length > 0) {
669             shouldAddStaker = false;
670         }
671         
672         // Here we calculate the percent of the balance an address is receiving. If the address receives too many tokens, the staking time and last time rewards were claimed is reset to block.timestamp
673         // This is necessary because otherwise funds could move from address to address with no penality and thus an individual could claim multiple times with the same funds
674         
675         if (shouldAddStaker && _stakers[recipient].startTimestamp > 0 && recipientBalance > 0) {  // If you are currently staking, these should all be true
676         
677             uint percent = mulDiv(1000000, totalAmount, recipientBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
678             assert(percent > 0);
679             if(percent.add(_stakers[recipient].startTimestamp) > block.timestamp) {         // We represent the 'percent' as seconds and add to the recipient's unix time
680                 _stakers[recipient].startTimestamp = block.timestamp;
681             } else {
682                 _stakers[recipient].startTimestamp = _stakers[recipient].startTimestamp.add(percent);               // Receiving too many tokens resets your holding time
683             }
684             if(percent.add(_stakers[recipient].lastTimestamp) > block.timestamp) {
685                 _stakers[recipient].lastTimestamp = block.timestamp;
686             } else {
687                 _stakers[recipient].lastTimestamp = _stakers[recipient].lastTimestamp.add(percent);                 // Receiving too many tokens may make you ineligible to claim the next day
688             }
689         } else if (shouldAddStaker && recipientBalance == 0 && (_stakers[recipient].startTimestamp > 0 || _stakers[recipient].lastTimestamp > 0)) { // Invalid state, so we reset their data/remove them
690             delete _stakers[recipient];
691             emit StakerRemoved(recipient);
692         }
693         
694         
695 
696         senderBalance = senderBalance.sub(totalAmount, "ERC20: transfer amount exceeds balance");       // Normal ERC20 transfer
697         recipientBalance = recipientBalance.add(totalAmount);
698         
699         if (shouldAddStaker && _stakers[recipient].startTimestamp == 0 && (totalAmount >= _minStake || recipientBalance >= _minStake)) {        // If the recipient was not previously a staker and their balance is now greater than minStake, we add them automatically
700             _stakers[recipient] = staker(block.timestamp, block.timestamp);
701             emit StakerAdded(recipient);
702         }
703         
704         if (senderBalance < _minStake) {        // If the sender's balance is below the minimum stake, we remove them automatically
705             // Remove staker
706             delete _stakers[sender];
707             emit StakerRemoved(sender);
708         } else {
709             _stakers[sender].startTimestamp = block.timestamp;      // Sending tokens automatically resets your 'holding time'
710             if (_stakers[sender].lastTimestamp == 0) {
711                 _stakers[sender].lastTimestamp = block.timestamp;
712             }
713         }
714     
715         return (senderBalance, recipientBalance, burnedAmount);
716     }
717     
718     
719     function _randomness() internal view returns (uint256) {        // Calculates token burn on transfer between 1% and 4% (integers)
720         if(_useExternalCalc) {
721             return _externalCalculator.randomness();
722         }
723         return 1 + uint256(keccak256(abi.encodePacked(blockhash(block.number-1), _msgSender())))%4;     // We use the previous block hash as entropy. Can be gamed by a miner to some extent, but we accept this.
724     }
725     
726     function burn(address account, uint256 amount) external onlyOwner {     // We allow ourselves to burn tokens in case they were minted due to a bug
727         token._burn(account, amount);
728     }
729     
730     function resetStakeTimeDebug(address account) external onlyOwner {      // We allow ourselves to reset stake times in case they get changed incorrectly due to a bug
731     
732         _stakers[account].lastTimestamp = block.timestamp;
733       
734         _stakers[account].startTimestamp = block.timestamp;
735         
736     }
737 
738 
739 
740 }