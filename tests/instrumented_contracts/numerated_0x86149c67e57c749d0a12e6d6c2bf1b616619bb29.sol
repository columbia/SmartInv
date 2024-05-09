1 pragma solidity 0.5.11;
2 
3 library AddressCalc {
4 
5 
6     function futureAddressCalc(address payable _origin, uint _nonce) internal pure  returns (address) {
7 
8         if(_nonce == 0x00) return address(uint160(uint256((keccak256(abi.encodePacked(byte(0xd6),
9          byte(0x94), _origin, byte(0x80)))))));
10 
11         if(_nonce <= 0x7f) return address(uint160(uint256((keccak256(abi.encodePacked(byte(0xd6),
12          byte(0x94), _origin, byte(uint8(_nonce))))))));
13 
14         if(_nonce <= 0xff) return address(uint160(uint256((keccak256(abi.encodePacked(byte(0xd7),
15          byte(0x94), _origin, byte(0x81), uint8(_nonce)))))));
16 
17         if(_nonce <= 0xffff) return address(uint160(uint256((keccak256(abi.encodePacked(byte(0xd8),
18          byte(0x94), _origin, byte(0x82), uint16(_nonce)))))));
19 
20         if(_nonce <= 0xffffff) return address(uint160(uint256((keccak256(abi.encodePacked(byte(0xd9),
21          byte(0x94), _origin, byte(0x83), uint24(_nonce)))))));
22 
23 		return address(uint160(uint256((keccak256(abi.encodePacked(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce)))))));
24     }
25 
26 }
27 
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      * - Multiplication cannot overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99         // benefit is lost if 'b' is also tested.
100         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b) internal pure returns (uint256) {
123         return div(a, b, "SafeMath: division by zero");
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         // Solidity only automatically asserts when dividing by 0
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
158         return mod(a, b, "SafeMath: modulo by zero");
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts with custom message when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b != 0, errorMessage);
174         return a % b;
175     }
176 }
177 
178 contract BNY   {
179     using SafeMath for uint256;
180     using AddressCalc for address payable;
181     event Deposit(
182         address indexed _investor,
183         uint256 _investmentValue,
184         uint256 _ID,
185         uint256 _unlocktime,
186         string _investmentTerm
187     );
188     event PassiveDeposit(
189         address indexed _investor2,
190         uint256 _investmentValue2,
191         uint256 _ID2,
192         uint256 _unlocktime2,
193         uint256 _dailyIncome,
194         uint256 _investmentTime
195     );
196     event Spent(
197         address indexed _acclaimer,
198         uint256 indexed _amout
199     );
200     event PassiveSpent(
201         address indexed _acclaimer2,
202         uint256 indexed _amout2
203     );
204     event Transfer(
205         address indexed _from,
206         address indexed _to,
207         uint256 _value
208     );
209     event Approval(
210         address indexed _owner,
211         address indexed _spender,
212         uint256 _value
213     );
214     string constant public name = "BANCACY";
215     string constant public symbol = "BNY";
216     string constant public standard = "BNY Token";
217     uint256 constant public decimals = 18 ;
218     uint256 private _totalSupply;
219     uint256 public totalInvestmentAfterInterest;
220     uint256 public investorIndex = 1;
221     uint256 public passiveInvestorIndex = 1;
222     uint256 constant public interestRate = 16;
223     uint256 constant public multiplicationForMidTerm  = 5;
224     uint256 constant public multiplicationForLongTerm = 20;
225     uint256 public minForPassive = 1200000 * (10 ** uint256(decimals));
226     uint256 public tokensForSale = 534600000 * (10 ** uint256(decimals));
227     uint256 public tokensSold = 1 * (10 ** uint256(decimals));
228     uint256 constant public tokensPerWei = 54000;
229   	uint256 constant public Percent = 1000000000;
230     uint256 constant internal secondsInDay = 86400;
231     uint256 constant internal secondsInWeek = 604800;
232     uint256 constant internal secondsInMonth = 2419200;
233     uint256 constant internal secondsInQuarter = 7257600;
234 	uint256 constant internal daysInYear = 365;
235     uint256 internal _startSupply = 455400000 * (10 ** uint256(decimals));
236     address payable public fundsWallet;
237     address public XBNY;
238     address public BNY_DATA;
239 
240 	enum TermData {DEFAULT, ONE, TWO, THREE}
241 
242     mapping(uint256 => Investment) private investors;
243     mapping(uint256 => PassiveIncome) private passiveInvestors;
244     mapping (address => uint256) private _balances;
245     mapping (address => mapping (address => uint256)) private _allowances;
246     struct Investment {
247         address investorAddress;
248         uint256 investedAmount;
249         uint256 investmentUnlocktime;
250         bool spent;
251         string term;
252     }
253     struct PassiveIncome {
254         address investorAddress2;
255         uint256 investedAmount2;
256         uint256 dailyPassiveIncome;
257         uint256 investmentTimeStamp;
258         uint256 investmentUnlocktime2;
259         uint256 day;
260         bool spent2;
261     }
262     constructor (address payable _fundsWallet)  public {
263         _totalSupply = _startSupply;
264         fundsWallet = _fundsWallet;
265         _balances[fundsWallet] = _startSupply;
266         _balances[address(1)] = 0;
267         emit Transfer(
268             address(1),
269             fundsWallet,
270             _startSupply
271         );
272         XBNY = _msgSender().futureAddressCalc(1);
273         BNY_DATA = _msgSender().futureAddressCalc(2);
274     }
275     function () external payable{
276         require(tokensSold < tokensForSale, "All tokens are sold");
277         require(msg.value > 0, "Value must be > 0");
278         uint256 eth = msg.value;
279         uint256 tokens = eth.mul(tokensPerWei);
280         uint256 bounosTokens = getDiscountOnBuy(tokens);
281 		uint256 totalTokens = bounosTokens.add(tokens);
282         require(totalTokens <= (tokensForSale).sub(tokensSold), "All tokens are sold");
283         fundsWallet.transfer(msg.value);
284         tokensSold = tokensSold.add((totalTokens));
285         _totalSupply = _totalSupply.add((totalTokens));
286         _balances[_msgSender()] = _balances[_msgSender()].add((totalTokens));
287         emit Transfer(
288             address(0),
289             _msgSender(),
290             totalTokens
291         );
292     }
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view returns (uint256) {
297         return _totalSupply;
298     }
299     /**
300      * @dev See {IERC20-transfer}.
301      *
302      * Requirements:
303      *
304      * - `recipient` cannot be the zero address.
305      * - the caller must have a balance of at least `amount`.
306      */
307     function transfer(address recipient, uint256 amount) public returns (bool) {
308         _transfer(_msgSender(), recipient, amount);
309         return true;
310     }
311     /**
312      * @dev See {IERC20-approve}.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function approve(address spender, uint256 value) public returns (bool) {
319         _approve(_msgSender(), spender, value);
320         return true;
321     }
322     /**
323      * @dev See {IERC20-transferFrom}.
324      *
325      * Emits an {Approval} event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of {ERC20};
327      *
328      * Requirements:
329      * - `sender` and `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `value`.
331      * - the caller must have allowance for `sender`'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
335         _transfer(sender, recipient, amount);
336         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
337         return true;
338     }
339 	/**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 	/**
346      * @dev See {IERC20-balanceOf}.
347      */
348     function balanceOf(address account) public view returns (uint256) {
349         return _balances[account];
350     }
351 	/**
352      * @dev Atomically increases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
383         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
384         return true;
385     }
386 	/**
387      * @dev Moves tokens `amount` from `sender` to `recipient`.
388      *
389      * This is internal function is equivalent to {transfer}, and can be used to
390      * e.g. implement automatic token fees, slashing mechanisms, etc.
391      *
392      * Emits a {Transfer} event.
393      *
394      * Requirements:
395      *
396      * - `sender` cannot be the zero address.
397      * - `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      */
400     function _transfer(address sender, address recipient, uint256 amount) internal {
401         require(sender != address(0), "ERC20: transfer from the zero address");
402         require(recipient != address(0), "ERC20: transfer to the zero address");
403 
404         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
405         _balances[recipient] = _balances[recipient].add(amount);
406         emit Transfer(sender, recipient, amount);
407     }
408 	/**
409      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
410      *
411      * This is internal function is equivalent to `approve`, and can be used to
412      * e.g. set automatic allowances for certain subsystems, etc.
413      *
414      * Emits an {Approval} event.
415      *
416      * Requirements:
417      *
418      * - `owner` cannot be the zero address.
419      * - `spender` cannot be the zero address.
420      */
421     function _approve(address owner, address spender, uint256 value) internal {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = value;
426         emit Approval(owner, spender, value);
427     }
428 	/**
429 	* @dev Destroys `amount` tokens from the caller.
430 	*
431 	* See {ERC20-_burn}.
432 	*/
433     function burn(uint256 amount) public {
434         _burn(_msgSender(), amount);
435     }
436     /**
437      * @dev Destroys `amount` tokens from `account`, reducing the
438      * total supply.
439      *
440      * Emits a {Transfer} event with `to` set to the zero address.
441      *
442      * Requirements
443      *
444      * - `account` cannot be the zero address.
445      * - `account` must have at least `amount` tokens.
446      */
447     function _burn(address account, uint256 amount) internal {
448         require(account != address(0), "ERC20: burn from the zero address");
449 
450         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
451         _totalSupply = _totalSupply.sub(amount);
452         emit Transfer(account, address(0), amount);
453     }
454 	function _msgSender() internal view returns (address payable) {
455         return msg.sender;
456     }
457     function makeInvestment(uint256 _unlockTime, uint256 _amount, uint term123) external returns (uint256) {
458         require(_balances[_msgSender()] >= _amount, "You dont have sufficent amount of tokens");
459         require(_amount > 0, "Investment amount should be bigger than 0");
460         require(_unlockTime >= secondsInWeek && (_unlockTime.mod(secondsInWeek)) == 0, "Wrong investment time");
461         // Term time is currently in weeks
462         uint256 termAfter = (_unlockTime.div(secondsInWeek));
463         uint256 currentInvestor = investorIndex;
464 
465         /*
466         The termAfter in weeks is more than or equal to 1 (week).
467         The user must have typed (in weeks) a figure (as termAfter) less than or equal to 48 (when comparing termAfter in weeks). Taken from the UI in (weeks), calculated into (seconds).
468         The user has selected "weeks" / "short term" (1) in the UI.
469         Previous check: The unlock time is a factor of weeks (in require).
470         */
471         if((termAfter >= 1) &&
472 		(termAfter <= 48) &&
473 		(term123 == uint(TermData.ONE)))
474         {
475             investorIndex++;
476             totalInvestmentAfterInterest = _amount.add(getInterestRate(_amount, termAfter));
477             investors[currentInvestor] = Investment(
478                 _msgSender(),
479                 totalInvestmentAfterInterest,
480                 block.timestamp.add(_unlockTime),
481                 false,
482                 "short"
483             );
484             emit Deposit(_msgSender(),
485                 _amount,
486                 currentInvestor,
487                 block.timestamp.add(_unlockTime),
488                 "SHORT-TERM"
489             );
490             emit Transfer(
491                 _msgSender(),
492                 address(1),
493                 _amount
494             );
495             emit Transfer(
496                 address(1),
497                 address(1),
498                 totalInvestmentAfterInterest.sub(_amount)
499             );
500             _balances[_msgSender()] = _balances[_msgSender()].sub(_amount);
501             _balances[address(1)] = _balances[address(1)].add(totalInvestmentAfterInterest);
502             _totalSupply = _totalSupply.sub(_amount);
503             return (currentInvestor);
504         }
505         // Recalculate the original termAfter (set in weeks) from unlocktime (in seconds) (instead as whole months, in seconds) for multiplier.
506         termAfter = (_unlockTime.div(secondsInMonth));
507         /*
508         The unlock time in seconds is more than or equal to 1 month in seconds.
509         The user has selected "months" / "mid term" (2) in the UI.
510         The user must have typed (in months) a figure (as termAfter) less than or equal to 1 year / 12 (when comparing termAfter in months). Taken from the UI in (months), calculated into seconds.
511         The unlock time (in seconds) is a factor of whole months (in seconds).
512         */
513         if((_unlockTime >= secondsInMonth) &&
514 		(term123 == uint(TermData.TWO)) &&
515 		(termAfter <= 12 ) &&
516 		(_unlockTime.mod(secondsInMonth)) == 0) {
517             investorIndex++;
518             totalInvestmentAfterInterest = _amount.add(getInterestRate(_amount, multiplicationForMidTerm).mul(termAfter));
519             investors[currentInvestor] = Investment(
520                 _msgSender(),
521                 totalInvestmentAfterInterest,
522                 block.timestamp.add(_unlockTime),
523                 false,
524                 "mid"
525             );
526             emit Deposit(
527                 _msgSender(),
528                 _amount,
529                 currentInvestor,
530                 block.timestamp.add(_unlockTime),
531                 "MID-TERM"
532             );
533             emit Transfer(
534                 _msgSender(),
535                 address(1),
536                 _amount
537             );
538             emit Transfer(
539                 address(1),
540                 address(1),
541                 totalInvestmentAfterInterest.sub(_amount)
542             );
543             _balances[_msgSender()] = _balances[_msgSender()].sub(_amount);
544             _balances[address(1)] = _balances[address(1)].add(totalInvestmentAfterInterest);
545             _totalSupply = _totalSupply.sub(_amount);
546             return (currentInvestor);
547         }
548 
549 
550         // Recalculate the original termAfter (reset as months) from unlocktime (in seconds) (instead as whole quarters, in seconds) for the multiplier.
551         termAfter = (_unlockTime.div(secondsInQuarter));
552         /*
553         The unlock time in seconds is more than or equal to 1 quarter in seconds.
554         The user has selected "quarters" / "long term" (3) in the UI.
555         The user must have typed a figure less than or equal to 3 years / 12 (when comparing termAfter in quarters). Taken from the UI in (quarters), calculated into seconds.
556         The unlock time (in seconds) is a factor of whole quarters (in seconds).
557         */
558         if((_unlockTime >= secondsInQuarter) &&
559 		(term123 == uint(TermData.THREE)) &&
560 		(termAfter <= 12 ) &&
561 		(_unlockTime.mod(secondsInQuarter) == 0)) {
562             investorIndex++;
563             totalInvestmentAfterInterest = _amount.add(getInterestRate(_amount, multiplicationForLongTerm).mul(termAfter));
564             investors[currentInvestor] = Investment(
565                 _msgSender(),
566                 totalInvestmentAfterInterest,
567                 block.timestamp.add(_unlockTime),
568                 false,
569                 "long"
570             );
571             emit Deposit(
572                 _msgSender(),
573                 _amount,
574                 currentInvestor,
575                 block.timestamp.add(_unlockTime),
576                 "LONG-TERM"
577             );
578             emit Transfer(
579                 _msgSender(),
580                 address(1),
581                 _amount
582             );
583             emit Transfer(
584                 address(1),
585                 address(1),
586                 totalInvestmentAfterInterest.sub(_amount)
587             );
588             _balances[_msgSender()] = _balances[_msgSender()].sub(_amount);
589             _balances[address(1)] = _balances[address(1)].add(totalInvestmentAfterInterest);
590             _totalSupply = _totalSupply.sub(_amount);
591             return (currentInvestor);
592         }
593     }
594     function releaseInvestment(uint256 _investmentId) external returns (bool success) {
595         require(investors[_investmentId].investorAddress == _msgSender(), "Only the investor can claim the investment");
596         require(investors[_investmentId].spent == false, "The investment is already spent");
597         require(investors[_investmentId].investmentUnlocktime < block.timestamp, "Unlock time for the investment did not pass");
598         investors[_investmentId].spent = true;
599         _totalSupply = _totalSupply.add(investors[_investmentId].investedAmount);
600         _balances[address(1)] = _balances[address(1)].sub(investors[_investmentId].investedAmount);
601         _balances[_msgSender()] = _balances[_msgSender()].add(investors[_investmentId].investedAmount);
602         emit Transfer(
603             address(1),
604             _msgSender(),
605             investors[_investmentId].investedAmount
606         );
607         emit Spent(
608             _msgSender(),
609             investors[_investmentId].investedAmount
610         );
611         return true;
612     }
613     function makePassiveIncomeInvestment(uint256 _amount) external returns (uint256) {
614         require(_balances[_msgSender()] >= _amount, "You  have insufficent amount of tokens");
615         require(_amount >= minForPassive, "Investment amount should be bigger than 1.2M");
616         uint256 interestOnInvestment = getInterestRate(_amount, 75).div(daysInYear);
617         uint256 currentInvestor = passiveInvestorIndex;
618         passiveInvestorIndex++;
619         passiveInvestors[currentInvestor] = PassiveIncome(
620             _msgSender(),
621             _amount,
622             interestOnInvestment,
623             block.timestamp,
624             block.timestamp.add(secondsInDay * daysInYear),
625             1,
626             false
627         );
628         emit Transfer(
629             _msgSender(),
630             address(1),
631             _amount
632         );
633         emit Transfer(
634             address(1),
635             address(1),
636             interestOnInvestment.mul(daysInYear)
637         );
638         emit PassiveDeposit(
639             _msgSender(),
640             _amount,
641             currentInvestor,
642             block.timestamp.add((secondsInDay * daysInYear)),
643             passiveInvestors[currentInvestor].dailyPassiveIncome,
644             passiveInvestors[currentInvestor].investmentTimeStamp
645         );
646         _balances[_msgSender()] = _balances[_msgSender()].sub(_amount);
647         _balances[address(1)] = _balances[address(1)].add((interestOnInvestment.mul(daysInYear)).add(_amount));
648         _totalSupply = _totalSupply.sub(_amount);
649         return (currentInvestor);
650     }
651     function releasePassiveIncome(uint256 _passiveIncomeID) external returns (bool success) {
652         require(passiveInvestors[_passiveIncomeID].investorAddress2 == _msgSender(), "Only the investor can claim the investment");
653         require(passiveInvestors[_passiveIncomeID].spent2 == false, "The investment is already claimed");
654         require(passiveInvestors[_passiveIncomeID].investmentTimeStamp.add((
655         secondsInDay * passiveInvestors[_passiveIncomeID].day)) < block.timestamp,
656         "Unlock time for the investment did not pass");
657         require(passiveInvestors[_passiveIncomeID].day < 366, "The investment is already claimed");
658         uint256 totalReward = 0;
659         uint256 numberOfDaysHeld = (block.timestamp - passiveInvestors[_passiveIncomeID].investmentTimeStamp) / secondsInDay;
660         if(numberOfDaysHeld > daysInYear){
661             passiveInvestors[_passiveIncomeID].spent2 = true;
662             numberOfDaysHeld = daysInYear;
663             totalReward = passiveInvestors[_passiveIncomeID].investedAmount2;
664         }
665         uint numberOfDaysOwed = numberOfDaysHeld - (passiveInvestors[_passiveIncomeID].day - 1);
666         uint totalDailyPassiveIncome = passiveInvestors[_passiveIncomeID].dailyPassiveIncome * numberOfDaysOwed;
667         passiveInvestors[_passiveIncomeID].day = numberOfDaysHeld.add(1);
668         totalReward = totalReward.add(totalDailyPassiveIncome);
669         if(totalReward > 0){
670             _totalSupply = _totalSupply.add(totalReward);
671             _balances[address(1)] = _balances[address(1)].sub(totalReward);
672             _balances[_msgSender()] = _balances[_msgSender()].add(totalReward);
673             emit Transfer(
674                 address(1),
675                 _msgSender(),
676                 totalReward
677             );
678             emit PassiveSpent(
679                 _msgSender(),
680                 totalReward
681             );
682             return true;
683         }
684         else{
685             revert(
686                 "There is no total reward earned."
687             );
688         }
689     }
690     function BNY_AssetSolidification(address _user, uint256 _value) external returns (bool success) {
691         require(_msgSender() == BNY_DATA, "No Permission");
692         require(_balances[_user] >= _value, "User have incufficent balance");
693         _balances[_user] = _balances[_user].sub(_value);
694         _totalSupply = _totalSupply.sub(_value);
695         emit Transfer(
696             _user,
697             address(2),
698             _value
699         );
700         return true;
701     }
702     function BNY_AssetDesolidification(address _user,uint256 _value) external returns (bool success) {
703         require(_msgSender() == BNY_DATA, "No Permission");
704         _balances[_user] = _balances[_user].add(_value);
705         _totalSupply = _totalSupply.add(_value);
706         emit Transfer(
707             address(2),
708             _user,
709             _value
710         );
711         return true;
712     }
713     function getBalanceOf(address _user) external view returns (uint256 balance) {
714         require(_msgSender() == BNY_DATA, "No Permission");
715         return _balances[_user];
716     }
717     function getPassiveDetails (uint _passiveIncomeID) external view returns (
718         address investorAddress2,
719         uint256 investedAmount2,
720         uint256 dailyPassiveIncome,
721         uint256 investmentTimeStamp,
722         uint256 investmentUnlocktime2,
723         uint256 day,
724         bool spent2
725     ){
726         return(
727             passiveInvestors[_passiveIncomeID].investorAddress2,
728             passiveInvestors[_passiveIncomeID].investedAmount2,
729             passiveInvestors[_passiveIncomeID].dailyPassiveIncome,
730             passiveInvestors[_passiveIncomeID].investmentTimeStamp,
731             passiveInvestors[_passiveIncomeID].investmentUnlocktime2,
732             passiveInvestors[_passiveIncomeID].day,
733             passiveInvestors[_passiveIncomeID].spent2
734         );
735     }
736     function getPassiveIncomeDay(uint256 _passiveIncomeID) external view returns (uint256) {
737         return(passiveInvestors[_passiveIncomeID].day);
738     }
739     function getPassiveIncomeStatus(uint256 _passiveIncomeID) external view returns (bool) {
740         return (passiveInvestors[_passiveIncomeID].spent2);
741     }
742     function getPassiveInvestmentTerm(uint256 _passiveIncomeID) external view returns (uint256){
743         return (passiveInvestors[_passiveIncomeID].investmentUnlocktime2);
744     }
745     function getPassiveNumberOfDays (uint _passiveIncomeID) external view returns (uint256){
746         return (block.timestamp - passiveInvestors[_passiveIncomeID].investmentTimeStamp) / secondsInDay;
747     }
748     function getPassiveInvestmentTimeStamp(uint256 _passiveIncomeID) external view returns (uint256){
749         return (passiveInvestors[_passiveIncomeID].investmentTimeStamp);
750     }
751     function getInvestmentStatus(uint256 _ID) external view returns (bool){
752         return (investors[_ID].spent);
753     }
754     function getInvestmentTerm(uint256 _ID) external view returns (uint256){
755         return (investors[_ID].investmentUnlocktime);
756     }
757     function getDiscountOnBuy(uint256 _tokensAmount) public view returns (uint256 discount) {
758         uint256 tokensSoldADJ = tokensSold.mul(1000000000);
759         uint256 discountPercentage = tokensSoldADJ.div(tokensForSale);
760         uint256 adjustedDiscount = (Percent.sub(discountPercentage)).mul(2500);
761         uint256 DiscountofTokens = (adjustedDiscount.mul(_tokensAmount));
762         return((DiscountofTokens).div(10000000000000));
763     }
764     function getBlockTimestamp () external view returns (uint blockTimestamp){
765         return block.timestamp;
766     }
767     function getInterestRate(uint256 _investment, uint _term) public view returns (uint256 rate) {
768         require(_investment < _totalSupply, "The investment is too large");
769         uint256 totalinvestments = _balances[address(1)].mul(Percent);
770         uint256 investmentsPercentage = totalinvestments.div(_totalSupply);
771         uint256 adjustedinterestrate = (Percent.sub(investmentsPercentage)).mul(interestRate);
772         uint256 interestoninvestment = (adjustedinterestrate.mul(_investment)).div(10000000000000);
773         return (interestoninvestment.mul(_term));
774     }
775     function getSimulatedDailyIncome (uint _passiveIncomeID) external view returns (
776         uint _numberOfDaysHeld,
777         uint _numberOfDaysOwed,
778         uint _totalDailyPassiveIncome,
779         uint _dailyPassiveIncome,
780         uint _totalReward,
781         uint _day,
782         bool _spent
783     ){
784         _spent = false;
785         _numberOfDaysHeld = (block.timestamp - passiveInvestors[_passiveIncomeID].investmentTimeStamp) / secondsInDay;
786         if(_numberOfDaysHeld > daysInYear){
787             _numberOfDaysHeld = daysInYear;
788             _totalReward = passiveInvestors[_passiveIncomeID].investedAmount2;
789             _spent = true;
790         }
791         _numberOfDaysOwed = _numberOfDaysHeld - (passiveInvestors[_passiveIncomeID].day - 1);
792         _totalDailyPassiveIncome = passiveInvestors[_passiveIncomeID].dailyPassiveIncome * _numberOfDaysOwed;
793         _day = _numberOfDaysHeld.add(1);
794         _totalReward = _totalReward.add(_totalDailyPassiveIncome);
795         _dailyPassiveIncome = passiveInvestors[_passiveIncomeID].dailyPassiveIncome;
796         return (
797             _numberOfDaysHeld,
798             _numberOfDaysOwed,
799             _totalDailyPassiveIncome,
800             _dailyPassiveIncome,
801             _totalReward,
802             _day,
803             _spent
804         );
805     }
806 }