1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
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
77 
78 }
79 
80 abstract contract Context {
81     function _msgSender() internal view virtual returns (address payable) {
82         return msg.sender;
83     }
84 
85     function _msgData() internal view virtual returns (bytes memory) {
86         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
87         return msg.data;
88     }
89 }
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor () internal {
248         address msgSender = _msgSender();
249         _owner = msgSender;
250         emit OwnershipTransferred(address(0), msgSender);
251     }
252 
253     /**
254      * @dev Returns the address of the current owner.
255      */
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         emit OwnershipTransferred(_owner, newOwner);
287         _owner = newOwner;
288     }
289 }
290 
291 abstract contract CalculatorInterface {
292     function calculateNumTokens(uint256 balance, uint256 daysStaked) public virtual returns (uint256);
293     function randomness() public view virtual returns (uint256);
294 }
295 
296 
297 /**
298  * @dev Implementation of the Pamp Network: https://pamp.network
299  * Pamp Network (PAMP) is the world's first price-reactive cryptocurrency.
300  * That is, the inflation rate of the token is wholly dependent on its market activity.
301  * Minting does not happen when the price is less than the day prior.
302  * When the price is greater than the day prior, the inflation for that day is
303  * a function of its price, percent increase, volume, any positive price streaks,
304  * and the amount of time any given holder has been holding.
305  * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
306  */
307 contract PampToken is Ownable, IERC20 {
308     using SafeMath for uint256;
309     
310     struct staker {
311         uint startTimestamp;
312         uint lastTimestamp;
313     }
314     
315     struct update {
316         uint timestamp;
317         uint numerator;
318         uint denominator;
319         uint price;         // In USD. 0001 is $0.001, 1000 is $1.000, 1001 is $1.001, etc
320         uint volume;        // In whole USD (100 = $100)
321     }
322     
323     struct seller {
324         address addr;
325         uint256 burnAmount;
326     }
327 
328     mapping (address => uint256) private _balances;
329 
330     mapping (address => mapping (address => uint256)) private _allowances;
331     
332     mapping (address => staker) public _stakers;
333     
334     mapping (address => string) public _whitelist;
335     
336     mapping (address => uint256) public _blacklist;
337 
338     uint256 private _totalSupply;
339     
340     bool private _enableDelayedSellBurns;
341     
342     bool private _enableBurns;
343     
344     bool private _priceTarget1Hit;
345     
346     bool private _priceTarget2Hit;
347     
348     address private _uniswapV2Pair;
349     
350     address private _uniswapV1Pair;
351     
352     seller[] private _delayedBurns;
353     
354     uint8 private _uniswapSellerBurnPercent;
355     
356     string public constant _name = "Pamp Network";
357     string public constant _symbol = "PAMP";
358     uint8 public constant _decimals = 18;
359     
360     uint256 private _minStake;
361     
362     uint8 private _minStakeDurationDays;
363     
364     uint256 private _inflationAdjustmentFactor;
365     
366     uint256 private _streak;
367     
368     update public _lastUpdate;
369     
370     CalculatorInterface private _externalCalculator;
371     
372     bool private _useExternalCalc;
373     
374     bool private _freeze;
375     
376     event StakerRemoved(address StakerAddress);
377     
378     event StakerAdded(address StakerAddress);
379     
380     event StakesUpdated(uint Amount);
381     
382     event MassiveCelebration();
383     
384      
385     constructor () public {
386         _mint(msg.sender, 10000000E18);
387         _minStake = 100E18;
388         _inflationAdjustmentFactor = 1000;
389         _streak = 0;
390         _minStakeDurationDays = 0;
391         _useExternalCalc = false;
392         _uniswapSellerBurnPercent = 5;
393         _enableDelayedSellBurns = true;
394         _enableBurns = false;
395         _freeze = false;
396     }
397     
398     function updateState(uint numerator, uint denominator, uint256 price, uint256 volume) external onlyOwner {  // when chainlink is integrated a separate contract will call this function (onlyOwner state will be changed as well)
399     
400         require(numerator != 0 && denominator != 0 && price != 0 && volume != 0, "Parameters cannot be zero");
401         
402         
403         uint8 daysSinceLastUpdate = uint8((block.timestamp - _lastUpdate.timestamp) / 86400);
404         
405         if (daysSinceLastUpdate == 0) {
406             // should we error here?
407             _streak++;
408         } else if (daysSinceLastUpdate == 1) {
409             _streak++;
410         } else {
411             _streak = 1;
412         }
413         
414         if (price >= 1000 && _priceTarget1Hit == false) { // 1000 = $1.00
415             _priceTarget1Hit = true;
416             _streak = 50;
417             emit MassiveCelebration();
418             
419         } else if (price >= 10000 && _priceTarget2Hit == false) {   // It is written, so it shall be done
420             _priceTarget2Hit = true;
421             _streak = 100;
422             emit MassiveCelebration();
423         }
424         
425         _lastUpdate = update(block.timestamp, numerator, denominator, price, volume);
426 
427     }
428     
429     function updateMyStakes() external {
430         
431         require((block.timestamp.sub(_lastUpdate.timestamp)) / 86400 == 0, "Stakes must be updated the same day of the latest update");
432         
433         
434         address stakerAddress = _msgSender();
435     
436         staker memory thisStaker = _stakers[stakerAddress];
437         
438         require(block.timestamp > thisStaker.lastTimestamp, "Error: block timestamp is greater than your last timestamp!");
439         require((block.timestamp.sub(thisStaker.lastTimestamp)) / 86400 != 0, "Error: you can only update stakes once per day. You also cannot update stakes on the same day that you purchased them.");
440         require(thisStaker.lastTimestamp != 0, "Error: your last timestamp cannot be zero.");
441         
442         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;
443         uint balance = _balances[stakerAddress];
444         uint prevTotalSupply = _totalSupply;
445 
446         if (thisStaker.startTimestamp > 0 && balance >= _minStake && daysStaked >= _minStakeDurationDays) { // There is a minimum staking duration and amount. 
447             uint numTokens = calculateNumTokens(balance, daysStaked);
448             
449             _balances[stakerAddress] = _balances[stakerAddress].add(numTokens);
450             _totalSupply = _totalSupply.add(numTokens);
451             _stakers[stakerAddress].lastTimestamp = block.timestamp;
452             emit StakesUpdated(_totalSupply - prevTotalSupply);
453         }
454         
455     }
456     
457     function calculateNumTokens(uint256 balance, uint256 daysStaked) internal returns (uint256) {
458         
459         if (_useExternalCalc) {
460             return _externalCalculator.calculateNumTokens(balance, daysStaked);
461         }
462         
463         uint256 inflationAdjustmentFactor = _inflationAdjustmentFactor;
464         
465         if (_streak > 1) {
466             inflationAdjustmentFactor /= _streak;
467         }
468         
469         uint marketCap = _totalSupply.mul(_lastUpdate.price);
470         
471         uint ratio = marketCap.div(_lastUpdate.volume);
472         
473         if (ratio > 100) {  // Too little volume. Decrease rewards.
474             inflationAdjustmentFactor = inflationAdjustmentFactor.mul(10);
475         } else if (ratio > 50) { // Still not enough. Streak doesn't count.
476             inflationAdjustmentFactor = _inflationAdjustmentFactor;
477         }
478         
479         return mulDiv(balance, _lastUpdate.numerator * daysStaked, _lastUpdate.denominator * inflationAdjustmentFactor);
480     }
481     
482     function updateCalculator(CalculatorInterface calc) external {
483        _externalCalculator = calc;
484        _useExternalCalc = true;
485     }
486     
487     
488     function updateInflationAdjustmentFactor(uint256 inflationAdjustmentFactor) external onlyOwner {
489         _inflationAdjustmentFactor = inflationAdjustmentFactor;
490     }
491     
492     function updateStreak(uint streak) external onlyOwner {
493         _streak = streak;
494     }
495     
496     function updateMinStakeDurationDays(uint8 minStakeDurationDays) external onlyOwner {
497         _minStakeDurationDays = minStakeDurationDays;
498     }
499     
500     function updateMinStakes(uint minStake) external onlyOwner {
501         _minStake = minStake;
502     }
503     
504     function enableBurns(bool enableBurns) external onlyOwner {
505         _enableBurns = enableBurns;
506     } 
507     
508     function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner returns (bool) {
509         if (remove) {
510             delete _whitelist[addr];
511             return true;
512         } else {
513             _whitelist[addr] = reason;
514             return true;
515         }
516         return false;        
517     }
518     
519     function updateBlacklist(address addr, uint256 fee, bool remove) external onlyOwner returns (bool) {
520         if (remove) {
521             delete _blacklist[addr];
522             return true;
523         } else {
524             _blacklist[addr] = fee;
525             return true;
526         }
527         return false;
528     }
529     
530     function updateUniswapPair(address addr, bool V1) external onlyOwner returns (bool) {
531         if (V1) {
532             _uniswapV1Pair = addr;
533             return true;
534         } else {
535             _uniswapV2Pair = addr;
536             return true;
537         }
538         return false;
539     }
540     
541     function updateDelayedSellBurns(bool enableDelayedSellBurns) external onlyOwner {
542         _enableDelayedSellBurns = enableDelayedSellBurns;
543     }
544     
545     function updateUniswapSellerBurnPercent(uint8 sellerBurnPercent) external onlyOwner {
546         _uniswapSellerBurnPercent = sellerBurnPercent;
547     }
548     
549     function freeze(bool freeze) external onlyOwner {
550         _freeze = freeze;
551     }
552     
553 
554     function mulDiv (uint x, uint y, uint z) private pure returns (uint) {
555           (uint l, uint h) = fullMul (x, y);
556           require (h < z);
557           uint mm = mulmod (x, y, z);
558           if (mm > l) h -= 1;
559           l -= mm;
560           uint pow2 = z & -z;
561           z /= pow2;
562           l /= pow2;
563           l += h * ((-pow2) / pow2 + 1);
564           uint r = 1;
565           r *= 2 - z * r;
566           r *= 2 - z * r;
567           r *= 2 - z * r;
568           r *= 2 - z * r;
569           r *= 2 - z * r;
570           r *= 2 - z * r;
571           r *= 2 - z * r;
572           r *= 2 - z * r;
573           return l * r;
574     }
575     
576     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
577           uint mm = mulmod (x, y, uint (-1));
578           l = x * y;
579           h = mm - l;
580           if (mm < l) h -= 1;
581     }
582     
583     function streak() public view returns (uint) {
584         return _streak;
585     }
586 
587     /**
588      * @dev Returns the name of the token.
589      */
590     function name() public view returns (string memory) {
591         return _name;
592     }
593 
594     /**
595      * @dev Returns the symbol of the token, usually a shorter version of the
596      * name.
597      */
598     function symbol() public view returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev Returns the number of decimals used to get its user representation.
604      * For example, if `decimals` equals `2`, a balance of `505` tokens should
605      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
606      *
607      * Tokens usually opt for a value of 18, imitating the relationship between
608      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
609      * called.
610      *
611      * NOTE: This information is only used for _display_ purposes: it in
612      * no way affects any of the arithmetic of the contract, including
613      * {IERC20-balanceOf} and {IERC20-transfer}.
614      */
615     function decimals() public view returns (uint8) {
616         return _decimals;
617     }
618 
619     /**
620      * @dev See {IERC20-totalSupply}.
621      */
622     function totalSupply() public view override returns (uint256) {
623         return _totalSupply;
624     }
625 
626     /**
627      * @dev See {IERC20-balanceOf}.
628      */
629     function balanceOf(address account) public view override returns (uint256) {
630         return _balances[account];
631     }
632 
633     /**
634      * @dev See {IERC20-transfer}.
635      *
636      * Requirements:
637      *
638      * - `recipient` cannot be the zero address.
639      * - the caller must have a balance of at least `amount`.
640      */
641     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
642         _transfer(_msgSender(), recipient, amount);
643         return true;
644     }
645 
646     /**
647      * @dev See {IERC20-allowance}.
648      */
649     function allowance(address owner, address spender) public view virtual override returns (uint256) {
650         return _allowances[owner][spender];
651     }
652 
653     /**
654      * @dev See {IERC20-approve}.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      */
660     function approve(address spender, uint256 amount) public virtual override returns (bool) {
661         _approve(_msgSender(), spender, amount);
662         return true;
663     }
664 
665     /**
666      * @dev See {IERC20-transferFrom}.
667      *
668      * Emits an {Approval} event indicating the updated allowance. This is not
669      * required by the EIP. See the note at the beginning of {ERC20};
670      *
671      * Requirements:
672      * - `sender` and `recipient` cannot be the zero address.
673      * - `sender` must have a balance of at least `amount`.
674      * - the caller must have allowance for ``sender``'s tokens of at least
675      * `amount`.
676      */
677     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
678         _transfer(sender, recipient, amount);
679         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
680         return true;
681     }
682 
683     /**
684      * @dev Atomically increases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
696         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
697         return true;
698     }
699 
700     /**
701      * @dev Atomically decreases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {IERC20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      * - `spender` must have allowance for the caller of at least
712      * `subtractedValue`.
713      */
714     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
715         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
716         return true;
717     }
718 
719     /**
720      * @dev Moves tokens `amount` from `sender` to `recipient`.
721      *
722      * This is internal function is equivalent to {transfer}, and can be used to
723      * e.g. implement automatic token fees, slashing mechanisms, etc.
724      *
725      * Emits a {Transfer} event.
726      *
727      * Requirements:
728      *
729      * - `sender` cannot be the zero address.
730      * - `recipient` cannot be the zero address.
731      * - `sender` must have a balance of at least `amount`.
732      */
733     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
734         
735         require(_freeze == false, "Contract is frozen.");
736         require(sender != address(0), "ERC20: transfer from the zero address");
737         require(recipient != address(0), "ERC20: transfer to the zero address");
738         require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
739         
740         uint totalAmount = amount;
741         bool shouldAddStaker = true;
742         bool addedToDelayedBurns = false;
743         
744         if (_enableBurns && bytes(_whitelist[sender]).length == 0 && bytes(_whitelist[recipient]).length == 0 && bytes(_whitelist[_msgSender()]).length == 0) {
745                 
746             uint burnedAmount = mulDiv(amount, _randomness(), 100);
747             
748             
749             if (_blacklist[recipient] != 0) {   //Transferring to a blacklisted address incurs an additional fee
750                 burnedAmount = burnedAmount.add(mulDiv(amount, _blacklist[recipient], 100));
751                 shouldAddStaker = false;
752             }
753             
754             
755             
756             if (burnedAmount > 0) {
757                 if (burnedAmount > amount) {
758                     totalAmount = 0;
759                 } else {
760                     totalAmount = amount.sub(burnedAmount);
761                 }
762                 _balances[sender] = _balances[sender].sub(burnedAmount, "ERC20: burn amount amount exceeds balance");
763                 emit Transfer(sender, address(0), burnedAmount);
764             }
765         } else if (recipient == _uniswapV2Pair || recipient == _uniswapV1Pair) {    // Uniswap was used
766             shouldAddStaker = false;
767             if (_enableDelayedSellBurns && bytes(_whitelist[sender]).length == 0) { // delayed burns enabled and sender is not whitelisted
768                 uint burnedAmount = mulDiv(amount, _uniswapSellerBurnPercent, 100);     // Seller fee
769                 seller memory _seller;
770                 _seller.addr = sender;
771                 _seller.burnAmount = burnedAmount;
772                 _delayedBurns.push(_seller);
773                 addedToDelayedBurns = true;
774             }
775         
776         }
777         
778         if (bytes(_whitelist[recipient]).length != 0) {
779             shouldAddStaker = false;
780         }
781         
782 
783         _balances[sender] = _balances[sender].sub(totalAmount, "ERC20: transfer amount exceeds balance");
784         _balances[recipient] = _balances[recipient].add(totalAmount);
785         
786         if (shouldAddStaker && _stakers[recipient].startTimestamp == 0 && (totalAmount >= _minStake || _balances[recipient] >= _minStake)) {
787             _stakers[recipient] = staker(block.timestamp, block.timestamp);
788             emit StakerAdded(recipient);
789         }
790         
791         if (_balances[sender] < _minStake) {
792             // Remove staker
793             delete _stakers[sender];
794             emit StakerRemoved(sender);
795         } else {
796             _stakers[sender].startTimestamp = block.timestamp;
797             if (_stakers[sender].lastTimestamp == 0) {
798                 _stakers[sender].lastTimestamp = block.timestamp;
799             }
800         }
801         
802         if (_enableDelayedSellBurns && _delayedBurns.length > 0 && !addedToDelayedBurns) {
803             
804              seller memory _seller = _delayedBurns[_delayedBurns.length - 1];
805              _delayedBurns.pop();
806              
807              if(_balances[_seller.addr] >= _seller.burnAmount) {
808                  
809                  _balances[_seller.addr] = _balances[_seller.addr].sub(_seller.burnAmount);
810                  
811                  if (_stakers[_seller.addr].startTimestamp != 0 && _balances[_seller.addr] < _minStake) {
812                      // Remove staker
813                     delete _stakers[_seller.addr];
814                     emit StakerRemoved(_seller.addr);
815                  }
816              } else {
817                  delete _balances[_seller.addr];
818                  delete _stakers[_seller.addr];
819              }
820             emit Transfer(_seller.addr, address(0), _seller.burnAmount);
821         }
822         
823         emit Transfer(sender, recipient, totalAmount);
824     }
825 
826     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
827      * the total supply.
828      *
829      * Emits a {Transfer} event with `from` set to the zero address.
830      *
831      * Requirements
832      *
833      * - `to` cannot be the zero address.
834      */
835     function _mint(address account, uint256 amount) internal virtual {
836         require(account != address(0), "ERC20: mint to the zero address");
837 
838         _beforeTokenTransfer(address(0), account, amount);
839 
840         _totalSupply = _totalSupply.add(amount);
841         _balances[account] = _balances[account].add(amount);
842         emit Transfer(address(0), account, amount);
843     }
844 
845     /**
846      * @dev Destroys `amount` tokens from `account`, reducing the
847      * total supply.
848      *
849      * Emits a {Transfer} event with `to` set to the zero address.
850      *
851      * Requirements
852      *
853      * - `account` cannot be the zero address.
854      * - `account` must have at least `amount` tokens.
855      */
856     function _burn(address account, uint256 amount) internal virtual {
857         require(account != address(0), "ERC20: burn from the zero address");
858 
859         _beforeTokenTransfer(account, address(0), amount);
860 
861         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
862         _totalSupply = _totalSupply.sub(amount);
863         emit Transfer(account, address(0), amount);
864     }
865 
866     /**
867      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
868      *
869      * This is internal function is equivalent to `approve`, and can be used to
870      * e.g. set automatic allowances for certain subsystems, etc.
871      *
872      * Emits an {Approval} event.
873      *
874      * Requirements:
875      *
876      * - `owner` cannot be the zero address.
877      * - `spender` cannot be the zero address.
878      */
879     function _approve(address owner, address spender, uint256 amount) internal virtual {
880         require(owner != address(0), "ERC20: approve from the zero address");
881         require(spender != address(0), "ERC20: approve to the zero address");
882 
883         _allowances[owner][spender] = amount;
884         emit Approval(owner, spender, amount);
885     }
886     
887     function _randomness() internal view returns (uint256) {
888         if(_useExternalCalc) {
889             return _externalCalculator.randomness();
890         }
891         return 1 + uint256(keccak256(abi.encodePacked(blockhash(block.number-1), _msgSender())))%4;
892     }
893 
894     /**
895      * @dev Hook that is called before any transfer of tokens. This includes
896      * minting and burning.
897      *
898      * Calling conditions:
899      *
900      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
901      * will be to transferred to `to`.
902      * - when `from` is zero, `amount` tokens will be minted for `to`.
903      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
904      * - `from` and `to` are never both zero.
905      *
906      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
907      */
908     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
909 }