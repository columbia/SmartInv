1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57     event OwnershipRenounced(
58         address indexed previousOwner
59     );
60     event OwnershipTransferred(
61         address indexed previousOwner,
62         address indexed newOwner
63     );
64 
65     /**
66      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67      * account.
68      */
69     constructor() public {
70         owner = msg.sender;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     /**
82      * @dev Allows the current owner to transfer control of the contract to a newOwner.
83      * @param newOwner The address to transfer ownership to.
84      */
85     function transferOwnership(address newOwner) public onlyOwner {
86         require(newOwner != address(0));
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89     }
90 }
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is Ownable {
97     event Pause();
98     event Unpause();
99 
100     bool public paused = false;
101 
102     /**
103      * @dev Modifier to make a function callable only when the contract is not paused.
104      */
105     modifier whenNotPaused() {
106         require(!paused);
107         _;
108     }
109 
110     /**
111      * @dev Modifier to make a function callable only when the contract is paused.
112      */
113     modifier whenPaused() {
114         require(paused);
115         _;
116     }
117 
118     /**
119      * @dev called by the owner to pause, triggers stopped state
120      */
121     function pause() onlyOwner whenNotPaused public {
122         paused = true;
123         emit Pause();
124     }
125 
126     /**
127      * @dev called by the owner to unpause, returns to normal state
128      */
129     function unpause() onlyOwner whenPaused public {
130         paused = false;
131         emit Unpause();
132     }
133 }
134 
135 /**
136  * @title ERC20Basic
137  * @dev Simpler version of ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/179
139  */
140 contract ERC20Basic {
141     function totalSupply() public view returns (uint256);
142     function balanceOf(address who) public view returns (uint256);
143     function transfer(address to, uint256 value) public returns (bool);
144     event Transfer(
145         address indexed from,
146         address indexed to,
147         uint256 value
148     );
149 }
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20 is ERC20Basic {
156     function allowance(address owner, address spender) public view returns (uint256);
157     function transferFrom(address from, address to, uint256 value) public returns (bool);
158     function approve(address spender, uint256 value) public returns (bool);
159     event Approval(
160         address indexed owner,
161         address indexed spender,
162         uint256 value
163     );
164 }
165 
166 contract ERC223Interface {
167     function balanceOf(address who) public view returns (uint256);
168     function transfer(address to, uint256 value) public returns (bool);
169     function transfer(address to, uint256 value, bytes data) public returns (bool);
170     event Transfer(
171         address indexed from,
172         address indexed to,
173         uint256 value,
174         bytes data
175     );
176 }
177 
178 contract ERC223ReceivingContract {
179     /**
180      * @dev Standard ERC223 function that will handle incoming token transfers.
181      *
182      * @param _from  Token sender address.
183      * @param _value Amount of tokens.
184      * @param _data  Transaction metadata.
185      */
186     function tokenFallback(address _from, uint256 _value, bytes _data) public;
187 }
188 
189 /**
190  * @title PoSTokenStandard
191  * @dev the interface of PoSTokenStandard
192  */
193 contract PoSTokenStandard {
194     uint256 public stakeStartTime;
195     uint256 public stakeMinAge;
196     uint256 public stakeMaxAge;
197     function mint() public returns (bool);
198     function coinAge() public view returns (uint256);
199     function annualInterest() public view returns (uint256);
200     function calculateReward() public view returns (uint256);
201     function calculateRewardAt(uint256 _now) public view returns (uint256);
202     event Mint(
203         address indexed _address,
204         uint256 _reward
205     );
206 }
207 
208 /**
209  * @title TRUE Token
210  * @dev ERC20, ERC223, PoS Token for TrueDeck Platform
211  */
212 contract TrueToken is ERC20, ERC223Interface, PoSTokenStandard, Pausable {
213     using SafeMath for uint256;
214 
215     event CoinAgeRecordEvent(
216         address indexed who,
217         uint256 value,
218         uint64 time
219     );
220     event CoinAgeResetEvent(
221         address indexed who,
222         uint256 value,
223         uint64 time
224     );
225 
226     string public constant name = "TRUE Token";
227     string public constant symbol = "TRUE";
228     uint8 public constant decimals = 18;
229 
230     mapping (address => uint256) balances;
231 
232     mapping (address => mapping (address => uint256)) internal allowed;
233 
234     uint256 totalSupply_;
235 
236     /**
237     * @dev Total Number of TRUE tokens that can ever be created.
238     *      200M TRUE Tokens
239     */
240     uint256 public MAX_TOTAL_SUPPLY = 200000000 *  10 ** uint256(decimals);
241 
242     /**
243     * @dev Initial supply of TRUE tokens.
244     *      70M TRUE Tokens
245     *      35% of Maximum Total Supply
246     *      Will be distributed as follows:
247     *           5% : Platform Partners
248     *           1% : Pre-Airdrop
249     *          15% : Mega-Airdrop
250     *           4% : Bounty (Vested over 6 months)
251     *          10% : Development (Vested over 12 months)
252     */
253     uint256 public INITIAL_SUPPLY = 70000000 *  10 ** uint256(decimals);
254 
255     /**
256     * @dev Time at which the contract was deployed
257     */
258     uint256 public chainStartTime;
259 
260     /**
261     * @dev Ethereum Blockchain Block Number at time the contract was deployed
262     */
263     uint256 public chainStartBlockNumber;
264 
265     /**
266     * @dev To keep the record of a single incoming token transfer
267     */
268     struct CoinAgeRecord {
269         uint256 amount;
270         uint64 time;
271     }
272 
273     /**
274     * @dev To keep the coin age record for all addresses
275     */
276     mapping(address => CoinAgeRecord[]) coinAgeRecordMap;
277 
278     /**
279      * @dev Modifier to make contract mint new tokens only
280      *      - Staking has started.
281      *      - When total supply has not reached MAX_TOTAL_SUPPLY.
282      */
283     modifier canMint() {
284         require(stakeStartTime > 0 && now >= stakeStartTime && totalSupply_ < MAX_TOTAL_SUPPLY);
285         _;
286     }
287 
288     constructor() public {
289         chainStartTime = now;
290         chainStartBlockNumber = block.number;
291 
292         stakeMinAge = 3 days;
293         stakeMaxAge = 60 days;
294 
295         balances[msg.sender] = INITIAL_SUPPLY;
296         totalSupply_ = INITIAL_SUPPLY;
297     }
298 
299     /**
300     * @dev total number of tokens in existence
301     */
302     function totalSupply() public view returns (uint256) {
303         return totalSupply_;
304     }
305 
306     /**
307     * @dev Transfer the specified amount of tokens to the specified address.
308     *      - Invokes the `tokenFallback` function if the recipient is a contract.
309     *        The token transfer fails if the recipient is a contract
310     *        but does not implement the `tokenFallback` function
311     *        or the fallback function to receive funds.
312     *      - Records coin age if the recipient is not a contract
313     *
314     * @param _to    Receiver address.
315     * @param _value Amount of tokens that will be transferred.
316     * @param _data  Transaction metadata.
317     */
318     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
319         require(_to != address(0));
320 
321         if (msg.sender == _to) {
322             return mint();
323         }
324 
325         require(_value <= balances[msg.sender]);
326 
327         bool flag = isContract(_to);
328 
329         balances[msg.sender] = balances[msg.sender].sub(_value);
330         balances[_to] = balances[_to].add(_value);
331         if (flag) {
332             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
333             receiver.tokenFallback(msg.sender, _value, _data);
334         }
335         emit Transfer(msg.sender, _to, _value, _data);
336 
337         logCoinAgeRecord(msg.sender, _to, _value, flag);
338 
339         return true;
340     }
341 
342     /**
343     * @dev Transfer the specified amount of tokens to the specified address.
344     *      This function works the same with the previous one
345     *      but doesn't contain `_data` param.
346     *      Added due to backwards compatibility reasons.
347     * @param _to The address to transfer to.
348     * @param _value The amount to be transferred.
349     */
350     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
351         require(_to != address(0));
352 
353         if (msg.sender == _to) {
354             return mint();
355         }
356 
357         require(_value <= balances[msg.sender]);
358 
359         bytes memory empty;
360         bool flag = isContract(_to);
361 
362         balances[msg.sender] = balances[msg.sender].sub(_value);
363         balances[_to] = balances[_to].add(_value);
364         if (flag) {
365             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
366             receiver.tokenFallback(msg.sender, _value, empty);
367         }
368         emit Transfer(msg.sender, _to, _value, empty);
369 
370         logCoinAgeRecord(msg.sender, _to, _value, flag);
371 
372         return true;
373     }
374 
375 
376     /**
377      * @dev Transfer tokens from one address to another
378      * @param _from address The address which you want to send tokens from
379      * @param _to address The address which you want to transfer to
380      * @param _value uint256 the amount of tokens to be transferred
381      */
382     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
383         require(_to != address(0));
384         require(_value <= balances[_from]);
385         require(_value <= allowed[_from][msg.sender]);
386 
387         balances[_from] = balances[_from].sub(_value);
388         balances[_to] = balances[_to].add(_value);
389         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
390         emit Transfer(_from, _to, _value);
391 
392         // Coin age should not be recorded if receiver is the sender.
393         if (_from != _to) {
394             logCoinAgeRecord(_from, _to, _value, isContract(_to));
395         }
396 
397         return true;
398     }
399 
400     /**
401      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
402      *
403      * Beware that changing an allowance with this method brings the risk that someone may use both the old
404      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
405      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
406      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407      * @param _spender The address which will spend the funds.
408      * @param _value The amount of tokens to be spent.
409      */
410     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
411         require(_spender != address(0));
412         allowed[msg.sender][_spender] = _value;
413         emit Approval(msg.sender, _spender, _value);
414         return true;
415     }
416 
417     /**
418      * @dev Function to check the amount of tokens that an owner allowed to a spender.
419      * @param _owner address The address which owns the funds.
420      * @param _spender address The address which will spend the funds.
421      * @return A uint256 specifying the amount of tokens still available for the spender.
422      */
423     function allowance(address _owner, address _spender) public view returns (uint256) {
424         return allowed[_owner][_spender];
425     }
426 
427     /**
428      * @dev Increase the amount of tokens that an owner allowed to a spender.
429      *
430      * approve should be called when allowed[_spender] == 0. To increment
431      * allowed value is better to use this function to avoid 2 calls (and wait until
432      * the first transaction is mined)
433      * From MonolithDAO Token.sol
434      * @param _spender The address which will spend the funds.
435      * @param _addedValue The amount of tokens to increase the allowance by.
436      */
437     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
438         require(_spender != address(0));
439         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
440         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
441         return true;
442     }
443 
444     /**
445      * @dev Decrease the amount of tokens that an owner allowed to a spender.
446      *
447      * approve should be called when allowed[_spender] == 0. To decrement
448      * allowed value is better to use this function to avoid 2 calls (and wait until
449      * the first transaction is mined)
450      * From MonolithDAO Token.sol
451      * @param _spender The address which will spend the funds.
452      * @param _subtractedValue The amount of tokens to decrease the allowance by.
453      */
454     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
455         require(_spender != address(0));
456         uint256 oldValue = allowed[msg.sender][_spender];
457         if (_subtractedValue > oldValue) {
458             allowed[msg.sender][_spender] = 0;
459         } else {
460             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
461         }
462         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
463         return true;
464     }
465 
466     /**
467     * @dev Gets the balance of the specified address.
468     * @param _owner The address to query the the balance of.
469     * @return An uint256 representing the amount owned by the passed address.
470     */
471     function balanceOf(address _owner) public view returns (uint256) {
472         return balances[_owner];
473     }
474 
475     /**
476     * @dev Mints new TRUE token and rewards to caller as per the coin age.
477     *      Deletes all previous coinage records and resets with new coin age record.
478     */
479     function mint() public whenNotPaused canMint returns (bool) {
480         if (balances[msg.sender] <= 0) {
481             return false;
482         }
483 
484         if (coinAgeRecordMap[msg.sender].length <= 0) {
485             return false;
486         }
487 
488         uint256 reward = calculateRewardInternal(msg.sender, now);
489         if (reward <= 0) {
490             return false;
491         }
492 
493         if (reward > MAX_TOTAL_SUPPLY.sub(totalSupply_)) {
494             reward = MAX_TOTAL_SUPPLY.sub(totalSupply_);
495         }
496 
497         totalSupply_ = totalSupply_.add(reward);
498         balances[msg.sender] = balances[msg.sender].add(reward);
499         emit Mint(msg.sender, reward);
500 
501         uint64 _now = uint64(now);
502         delete coinAgeRecordMap[msg.sender];
503         coinAgeRecordMap[msg.sender].push(CoinAgeRecord(balances[msg.sender], _now));
504         emit CoinAgeResetEvent(msg.sender, balances[msg.sender], _now);
505 
506         return true;
507     }
508 
509     /**
510     * @dev Returns coinage for the caller address
511     */
512     function coinAge() public view returns (uint256) {
513          return getCoinAgeInternal(msg.sender, now);
514     }
515 
516     /**
517     * @dev Returns current annual interest
518     */
519     function annualInterest() public view returns(uint256) {
520         return getAnnualInterest(now);
521     }
522 
523     /**
524     * @dev Calculates and returns proof-of-stake reward
525     */
526     function calculateReward() public view returns (uint256) {
527         return calculateRewardInternal(msg.sender, now);
528     }
529 
530     /**
531     * @dev Calculates and returns proof-of-stake reward for provided time
532     *
533     * @param _now timestamp The time for which the reward will be calculated
534     */
535     function calculateRewardAt(uint256 _now) public view returns (uint256) {
536         return calculateRewardInternal(msg.sender, _now);
537     }
538 
539     /**
540     * @dev Returns coinage record for the given address and index
541     *
542     * @param _address address The address for which coinage record will be fetched
543     * @param _index index The index of coinage record for that address
544     */
545     function coinAgeRecordForAddress(address _address, uint256 _index) public view onlyOwner returns (uint256, uint64) {
546         if (coinAgeRecordMap[_address].length > _index) {
547             return (coinAgeRecordMap[_address][_index].amount, coinAgeRecordMap[_address][_index].time);
548         } else {
549             return (0, 0);
550         }
551     }
552 
553     /**
554     * @dev Returns coinage for the caller address
555     *
556     * @param _address address The address for which coinage will be calculated
557     */
558     function coinAgeForAddress(address _address) public view onlyOwner returns (uint256) {
559          return getCoinAgeInternal(_address, now);
560     }
561 
562     /**
563     * @dev Returns coinage for the caller address
564     *
565     * @param _address address The address for which coinage will be calculated
566     * @param _now timestamp The time for which the coinage will be calculated
567     */
568     function coinAgeForAddressAt(address _address, uint256 _now) public view onlyOwner returns (uint256) {
569          return getCoinAgeInternal(_address, _now);
570     }
571 
572     /**
573     * @dev Calculates and returns proof-of-stake reward for provided address and time
574     *
575     * @param _address address The address for which reward will be calculated
576     */
577     function calculateRewardForAddress(address _address) public view onlyOwner returns (uint256) {
578         return calculateRewardInternal(_address, now);
579     }
580 
581     /**
582     * @dev Calculates and returns proof-of-stake reward for provided address and time
583     *
584     * @param _address address The address for which reward will be calculated
585     * @param _now timestamp The time for which the reward will be calculated
586     */
587     function calculateRewardForAddressAt(address _address, uint256 _now) public view onlyOwner returns (uint256) {
588         return calculateRewardInternal(_address, _now);
589     }
590 
591     /**
592     * @dev Sets the stake start time
593     */
594     function startStakingAt(uint256 timestamp) public onlyOwner {
595         require(stakeStartTime <= 0 && timestamp >= chainStartTime && timestamp > now);
596         stakeStartTime = timestamp;
597     }
598 
599     /**
600     * @dev Returns true if the given _address is a contract, false otherwise.
601     */
602     function isContract(address _address) private view returns (bool) {
603         uint256 length;
604         assembly {
605             //retrieve the size of the code on target address, this needs assembly
606             length := extcodesize(_address)
607         }
608         return (length>0);
609     }
610 
611     /**
612     * @dev Logs coinage record for sender and receiver.
613     *      Deletes sender's previous coinage records if any.
614     *
615     * @param _from address The address which you want to send tokens from
616     * @param _to address The address which you want to transfer to
617     * @param _value uint256 the amount of tokens to be transferred
618     * @param _isContract bool if the receiver is a contract
619     */
620     function logCoinAgeRecord(address _from, address _to, uint256 _value, bool _isContract) private returns (bool) {
621         if (coinAgeRecordMap[_from].length > 0) {
622             delete coinAgeRecordMap[_from];
623         }
624 
625         uint64 _now = uint64(now);
626 
627         if (balances[_from] != 0) {
628             coinAgeRecordMap[_from].push(CoinAgeRecord(balances[_from], _now));
629             emit CoinAgeResetEvent(_from, balances[_from], _now);
630         }
631 
632         if (_value != 0 && !_isContract) {
633             coinAgeRecordMap[_to].push(CoinAgeRecord(_value, _now));
634             emit CoinAgeRecordEvent(_to, _value, _now);
635         }
636 
637         return true;
638     }
639 
640     /**
641     * @dev Calculates and returns proof-of-stake reward for provided address
642     *
643     * @param _address address The address for which reward will be calculated
644     * @param _now timestamp The time for which the reward will be calculated
645     */
646     function calculateRewardInternal(address _address, uint256 _now) private view returns (uint256) {
647         uint256 _coinAge = getCoinAgeInternal(_address, _now);
648         if (_coinAge <= 0) {
649             return 0;
650         }
651 
652         uint256 interest = getAnnualInterest(_now);
653 
654         return (_coinAge.mul(interest)).div(365 * 100);
655     }
656 
657     /**
658     * @dev Calculates the coin age for given address and time.
659     *
660     * @param _address address The address for which coinage will be calculated
661     * @param _now timestamp The time for which the coinage will be calculated
662     */
663     function getCoinAgeInternal(address _address, uint256 _now) private view returns (uint256 _coinAge) {
664         if (coinAgeRecordMap[_address].length <= 0) {
665             return 0;
666         }
667 
668         for (uint256 i = 0; i < coinAgeRecordMap[_address].length; i++) {
669             if (_now < uint256(coinAgeRecordMap[_address][i].time).add(stakeMinAge)) {
670                 continue;
671             }
672 
673             uint256 secondsPassed = _now.sub(uint256(coinAgeRecordMap[_address][i].time));
674             if (secondsPassed > stakeMaxAge ) {
675                 secondsPassed = stakeMaxAge;
676             }
677 
678             _coinAge = _coinAge.add((coinAgeRecordMap[_address][i].amount).mul(secondsPassed.div(1 days)));
679         }
680     }
681 
682     /**
683     * @dev Returns the annual interest rate for given time
684     *
685     * @param _now timestamp The time for which the annual interest will be calculated
686     */
687     function getAnnualInterest(uint256 _now) private view returns(uint256 interest) {
688         if (stakeStartTime > 0 && _now >= stakeStartTime && totalSupply_ < MAX_TOTAL_SUPPLY) {
689             uint256 secondsPassed = _now.sub(stakeStartTime);
690             // 1st Year = 30% annually
691             if (secondsPassed <= 365 days) {
692                 interest = 30;
693             } else if (secondsPassed <= 547 days) {  // 2nd Year, 1st Half = 25% annually
694                 interest = 25;
695             } else if (secondsPassed <= 730 days) {  // 2nd Year, 2nd Half = 20% annually
696                 interest = 20;
697             } else if (secondsPassed <= 911 days) {  // 3rd Year, 1st Half = 15% annually
698                 interest = 15;
699             } else if (secondsPassed <= 1094 days) {  // 3rd Year, 2nd Half = 10% annually
700                 interest = 10;
701             } else {  // 4th Year Onwards = 5% annually
702                 interest = 5;
703             }
704         } else {
705             interest = 0;
706         }
707     }
708 }