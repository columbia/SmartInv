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
166 /**
167  * @title PoSTokenStandard
168  * @dev the interface of PoSTokenStandard
169  */
170 contract PoSTokenStandard {
171     uint256 public stakeStartTime;
172     uint256 public stakeMinAge;
173     uint256 public stakeMaxAge;
174     function mint() public returns (bool);
175     function coinAge() public view returns (uint256);
176     function annualInterest() public view returns (uint256);
177     function calculateReward() public view returns (uint256);
178     function calculateRewardAt(uint256 _now) public view returns (uint256);
179     event Mint(
180         address indexed _address,
181         uint256 _reward
182     );
183 }
184 
185 /**
186  * @title TrueDeck TDP Token
187  * @dev ERC20, PoS Token for TrueDeck Platform
188  */
189 contract TrueDeckToken is ERC20, PoSTokenStandard, Pausable {
190     using SafeMath for uint256;
191 
192     event CoinAgeRecordEvent(
193         address indexed who,
194         uint256 value,
195         uint64 time
196     );
197     event CoinAgeResetEvent(
198         address indexed who,
199         uint256 value,
200         uint64 time
201     );
202 
203     string public constant name = "TrueDeck";
204     string public constant symbol = "TDP";
205     uint8 public constant decimals = 18;
206 
207     mapping (address => uint256) balances;
208 
209     mapping (address => mapping (address => uint256)) internal allowed;
210 
211     uint256 totalSupply_;
212 
213     /**
214     * @dev Total Number of TDP tokens that can ever be created.
215     *      200M TDP Tokens
216     */
217     uint256 public MAX_TOTAL_SUPPLY = 200000000 * 10 ** uint256(decimals);
218 
219     /**
220     * @dev Initial supply of TDP tokens.
221     *      70M TDP Tokens
222     *      35% of Maximum Total Supply
223     *      Will be distributed as follows:
224     *           5% : Platform Partners
225     *           1% : Pre-Airdrop
226     *          15% : Mega-Airdrop
227     *           4% : Bounty (Vested over 6 months)
228     *          10% : Development (Vested over 12 months)
229     */
230     uint256 public INITIAL_SUPPLY = 70000000 * 10 ** uint256(decimals);
231 
232     /**
233     * @dev Time at which the contract was deployed
234     */
235     uint256 public chainStartTime;
236 
237     /**
238     * @dev Ethereum Blockchain Block Number at time the contract was deployed
239     */
240     uint256 public chainStartBlockNumber;
241 
242     /**
243     * @dev To keep the record of a single incoming token transfer
244     */
245     struct CoinAgeRecord {
246         uint256 amount;
247         uint64 time;
248     }
249 
250     /**
251     * @dev To keep the coin age record for all addresses
252     */
253     mapping(address => CoinAgeRecord[]) coinAgeRecordMap;
254 
255     /**
256      * @dev Modifier to make contract mint new tokens only
257      *      - Staking has started.
258      *      - When total supply has not reached MAX_TOTAL_SUPPLY.
259      */
260     modifier canMint() {
261         require(stakeStartTime > 0 && now >= stakeStartTime && totalSupply_ < MAX_TOTAL_SUPPLY);            // solium-disable-line
262         _;
263     }
264 
265     constructor() public {
266         chainStartTime = now;                                                                               // solium-disable-line
267         chainStartBlockNumber = block.number;
268 
269         stakeMinAge = 3 days;
270         stakeMaxAge = 60 days;
271 
272         balances[msg.sender] = INITIAL_SUPPLY;
273         totalSupply_ = INITIAL_SUPPLY;
274     }
275 
276     /**
277     * @dev total number of tokens in existence
278     */
279     function totalSupply() public view returns (uint256) {
280         return totalSupply_;
281     }
282 
283     /**
284     * @dev Transfer the specified amount of tokens to the specified address.
285     *      This function works the same with the previous one
286     *      but doesn't contain `_data` param.
287     *      Added due to backwards compatibility reasons.
288     * @param _to The address to transfer to.
289     * @param _value The amount to be transferred.
290     */
291     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
292         require(_to != address(0));
293 
294         if (msg.sender == _to) {
295             return mint();
296         }
297 
298         require(_value <= balances[msg.sender]);
299 
300         balances[msg.sender] = balances[msg.sender].sub(_value);
301         balances[_to] = balances[_to].add(_value);
302         emit Transfer(msg.sender, _to, _value);
303 
304         logCoinAgeRecord(msg.sender, _to, _value);
305 
306         return true;
307     }
308 
309 
310     /**
311      * @dev Transfer tokens from one address to another
312      * @param _from address The address which you want to send tokens from
313      * @param _to address The address which you want to transfer to
314      * @param _value uint256 the amount of tokens to be transferred
315      */
316     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
317         require(_to != address(0));
318         require(_value <= balances[_from]);
319         require(_value <= allowed[_from][msg.sender]);
320 
321         balances[_from] = balances[_from].sub(_value);
322         balances[_to] = balances[_to].add(_value);
323         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
324         emit Transfer(_from, _to, _value);
325 
326         // Coin age should not be recorded if receiver is the sender.
327         if (_from != _to) {
328             logCoinAgeRecord(_from, _to, _value);
329         }
330 
331         return true;
332     }
333 
334     /**
335      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
336      *
337      * Beware that changing an allowance with this method brings the risk that someone may use both the old
338      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
339      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
340      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
341      * @param _spender The address which will spend the funds.
342      * @param _value The amount of tokens to be spent.
343      */
344     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
345         require(_spender != address(0));
346         allowed[msg.sender][_spender] = _value;
347         emit Approval(msg.sender, _spender, _value);
348         return true;
349     }
350 
351     /**
352      * @dev Function to check the amount of tokens that an owner allowed to a spender.
353      * @param _owner address The address which owns the funds.
354      * @param _spender address The address which will spend the funds.
355      * @return A uint256 specifying the amount of tokens still available for the spender.
356      */
357     function allowance(address _owner, address _spender) public view returns (uint256) {
358         return allowed[_owner][_spender];
359     }
360 
361     /**
362      * @dev Increase the amount of tokens that an owner allowed to a spender.
363      *
364      * approve should be called when allowed[_spender] == 0. To increment
365      * allowed value is better to use this function to avoid 2 calls (and wait until
366      * the first transaction is mined)
367      * From MonolithDAO Token.sol
368      * @param _spender The address which will spend the funds.
369      * @param _addedValue The amount of tokens to increase the allowance by.
370      */
371     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
372         require(_spender != address(0));
373         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
374         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375         return true;
376     }
377 
378     /**
379      * @dev Decrease the amount of tokens that an owner allowed to a spender.
380      *
381      * approve should be called when allowed[_spender] == 0. To decrement
382      * allowed value is better to use this function to avoid 2 calls (and wait until
383      * the first transaction is mined)
384      * From MonolithDAO Token.sol
385      * @param _spender The address which will spend the funds.
386      * @param _subtractedValue The amount of tokens to decrease the allowance by.
387      */
388     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
389         require(_spender != address(0));
390         uint256 oldValue = allowed[msg.sender][_spender];
391         if (_subtractedValue > oldValue) {
392             allowed[msg.sender][_spender] = 0;
393         } else {
394             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
395         }
396         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
397         return true;
398     }
399 
400     /**
401     * @dev Gets the balance of the specified address.
402     * @param _owner The address to query the the balance of.
403     * @return An uint256 representing the amount owned by the passed address.
404     */
405     function balanceOf(address _owner) public view returns (uint256) {
406         return balances[_owner];
407     }
408 
409     /**
410     * @dev Mints new TDP token and rewards to caller as per the coin age.
411     *      Deletes all previous coinage records and resets with new coin age record.
412     */
413     function mint() public whenNotPaused canMint returns (bool) {
414         if (balances[msg.sender] <= 0) {
415             return false;
416         }
417 
418         if (coinAgeRecordMap[msg.sender].length <= 0) {
419             return false;
420         }
421 
422         uint256 reward = calculateRewardInternal(msg.sender, now);                                          // solium-disable-line
423         if (reward <= 0) {
424             return false;
425         }
426 
427         if (reward > MAX_TOTAL_SUPPLY.sub(totalSupply_)) {
428             reward = MAX_TOTAL_SUPPLY.sub(totalSupply_);
429         }
430 
431         totalSupply_ = totalSupply_.add(reward);
432         balances[msg.sender] = balances[msg.sender].add(reward);
433         emit Mint(msg.sender, reward);
434         emit Transfer(address(0), msg.sender, reward);
435 
436         uint64 _now = uint64(now);                                                                          // solium-disable-line
437         delete coinAgeRecordMap[msg.sender];
438         coinAgeRecordMap[msg.sender].push(CoinAgeRecord(balances[msg.sender], _now));
439         emit CoinAgeResetEvent(msg.sender, balances[msg.sender], _now);
440 
441         return true;
442     }
443 
444     /**
445     * @dev Returns coinage for the caller address
446     */
447     function coinAge() public view returns (uint256) {
448         return getCoinAgeInternal(msg.sender, now);                                                         // solium-disable-line
449     }
450 
451     /**
452     * @dev Returns current annual interest
453     */
454     function annualInterest() public view returns(uint256) {
455         return getAnnualInterest(now);                                                                      // solium-disable-line
456     }
457 
458     /**
459     * @dev Calculates and returns proof-of-stake reward
460     */
461     function calculateReward() public view returns (uint256) {
462         return calculateRewardInternal(msg.sender, now);                                                    // solium-disable-line
463     }
464 
465     /**
466     * @dev Calculates and returns proof-of-stake reward for provided time
467     *
468     * @param _now timestamp The time for which the reward will be calculated
469     */
470     function calculateRewardAt(uint256 _now) public view returns (uint256) {
471         return calculateRewardInternal(msg.sender, _now);
472     }
473 
474     /**
475     * @dev Returns coinage record for the given address and index
476     *
477     * @param _address address The address for which coinage record will be fetched
478     * @param _index index The index of coinage record for that address
479     */
480     function coinAgeRecordForAddress(address _address, uint256 _index) public view onlyOwner returns (uint256, uint64) {
481         if (coinAgeRecordMap[_address].length > _index) {
482             return (coinAgeRecordMap[_address][_index].amount, coinAgeRecordMap[_address][_index].time);
483         } else {
484             return (0, 0);
485         }
486     }
487 
488     /**
489     * @dev Returns coinage for the caller address
490     *
491     * @param _address address The address for which coinage will be calculated
492     */
493     function coinAgeForAddress(address _address) public view onlyOwner returns (uint256) {
494         return getCoinAgeInternal(_address, now);                                                           // solium-disable-line
495     }
496 
497     /**
498     * @dev Returns coinage for the caller address
499     *
500     * @param _address address The address for which coinage will be calculated
501     * @param _now timestamp The time for which the coinage will be calculated
502     */
503     function coinAgeForAddressAt(address _address, uint256 _now) public view onlyOwner returns (uint256) {
504         return getCoinAgeInternal(_address, _now);
505     }
506 
507     /**
508     * @dev Calculates and returns proof-of-stake reward for provided address and time
509     *
510     * @param _address address The address for which reward will be calculated
511     */
512     function calculateRewardForAddress(address _address) public view onlyOwner returns (uint256) {
513         return calculateRewardInternal(_address, now);                                                      // solium-disable-line
514     }
515 
516     /**
517     * @dev Calculates and returns proof-of-stake reward for provided address and time
518     *
519     * @param _address address The address for which reward will be calculated
520     * @param _now timestamp The time for which the reward will be calculated
521     */
522     function calculateRewardForAddressAt(address _address, uint256 _now) public view onlyOwner returns (uint256) {
523         return calculateRewardInternal(_address, _now);
524     }
525 
526     /**
527     * @dev Sets the stake start time
528     */
529     function startStakingAt(uint256 timestamp) public onlyOwner {
530         require(stakeStartTime <= 0 && timestamp >= chainStartTime && timestamp > now);                     // solium-disable-line
531         stakeStartTime = timestamp;
532     }
533 
534     /**
535     * @dev Returns true if the given _address is a contract, false otherwise.
536     */
537     function isContract(address _address) private view returns (bool) {
538         uint256 length;
539         /* solium-disable-next-line */
540         assembly {
541             //retrieve the size of the code on target address, this needs assembly
542             length := extcodesize(_address)
543         }
544         return (length>0);
545     }
546 
547 
548     /**
549     * @dev Logs coinage record for sender and receiver.
550     *      Deletes sender's previous coinage records if any.
551     *      Doesn't record coinage for contracts.
552     *
553     * @param _from address The address which you want to send tokens from
554     * @param _to address The address which you want to transfer to
555     * @param _value uint256 the amount of tokens to be transferred
556     */
557     function logCoinAgeRecord(address _from, address _to, uint256 _value) private returns (bool) {
558         if (coinAgeRecordMap[_from].length > 0) {
559             delete coinAgeRecordMap[_from];
560         }
561 
562         uint64 _now = uint64(now);                                                                          // solium-disable-line
563 
564         if (balances[_from] != 0 && !isContract(_from)) {
565             coinAgeRecordMap[_from].push(CoinAgeRecord(balances[_from], _now));
566             emit CoinAgeResetEvent(_from, balances[_from], _now);
567         }
568 
569         if (_value != 0 && !isContract(_to)) {
570             coinAgeRecordMap[_to].push(CoinAgeRecord(_value, _now));
571             emit CoinAgeRecordEvent(_to, _value, _now);
572         }
573 
574         return true;
575     }
576 
577     /**
578     * @dev Calculates and returns proof-of-stake reward for provided address
579     *
580     * @param _address address The address for which reward will be calculated
581     * @param _now timestamp The time for which the reward will be calculated
582     */
583     function calculateRewardInternal(address _address, uint256 _now) private view returns (uint256) {
584         uint256 _coinAge = getCoinAgeInternal(_address, _now);
585         if (_coinAge <= 0) {
586             return 0;
587         }
588 
589         uint256 interest = getAnnualInterest(_now);
590 
591         return (_coinAge.mul(interest)).div(365 * 100);
592     }
593 
594     /**
595     * @dev Calculates the coin age for given address and time.
596     *
597     * @param _address address The address for which coinage will be calculated
598     * @param _now timestamp The time for which the coinage will be calculated
599     */
600     function getCoinAgeInternal(address _address, uint256 _now) private view returns (uint256 _coinAge) {
601         if (coinAgeRecordMap[_address].length <= 0) {
602             return 0;
603         }
604 
605         for (uint256 i = 0; i < coinAgeRecordMap[_address].length; i++) {
606             if (_now < uint256(coinAgeRecordMap[_address][i].time).add(stakeMinAge)) {
607                 continue;
608             }
609 
610             uint256 secondsPassed = _now.sub(uint256(coinAgeRecordMap[_address][i].time));
611             if (secondsPassed > stakeMaxAge ) {
612                 secondsPassed = stakeMaxAge;
613             }
614 
615             _coinAge = _coinAge.add((coinAgeRecordMap[_address][i].amount).mul(secondsPassed.div(1 days)));
616         }
617     }
618 
619     /**
620     * @dev Returns the annual interest rate for given time
621     *
622     * @param _now timestamp The time for which the annual interest will be calculated
623     */
624     function getAnnualInterest(uint256 _now) private view returns(uint256 interest) {
625         if (stakeStartTime > 0 && _now >= stakeStartTime && totalSupply_ < MAX_TOTAL_SUPPLY) {
626             uint256 secondsPassed = _now.sub(stakeStartTime);
627             // 1st Year = 30% annually
628             if (secondsPassed <= 365 days) {
629                 interest = 30;
630             } else if (secondsPassed <= 547 days) {  // 2nd Year, 1st Half = 25% annually
631                 interest = 25;
632             } else if (secondsPassed <= 730 days) {  // 2nd Year, 2nd Half = 20% annually
633                 interest = 20;
634             } else if (secondsPassed <= 911 days) {  // 3rd Year, 1st Half = 15% annually
635                 interest = 15;
636             } else if (secondsPassed <= 1094 days) {  // 3rd Year, 2nd Half = 10% annually
637                 interest = 10;
638             } else {  // 4th Year Onwards = 5% annually
639                 interest = 5;
640             }
641         } else {
642             interest = 0;
643         }
644     }
645 
646     /**
647     * @dev Batch token transfer. Used by contract creator to distribute initial tokens.
648     *      Does not record any coinage for the owner.
649     *
650     * @param _recipients Array of address
651     * @param _values Array of amount
652     */
653     function batchTransfer(address[] _recipients, uint256[] _values) public onlyOwner returns (bool) {
654         require(_recipients.length > 0 && _recipients.length == _values.length);
655 
656         uint256 total = 0;
657         for(uint256 i = 0; i < _values.length; i++) {
658             total = total.add(_values[i]);
659         }
660         require(total <= balances[msg.sender]);
661 
662         uint64 _now = uint64(now);                                                                          // solium-disable-line
663         for(uint256 j = 0; j < _recipients.length; j++){
664             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
665             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
666             emit Transfer(msg.sender, _recipients[j], _values[j]);
667 
668             coinAgeRecordMap[_recipients[j]].push(CoinAgeRecord(_values[j], _now));
669             emit CoinAgeRecordEvent(_recipients[j], _values[j], _now);
670         }
671 
672         return true;
673     }
674 }