1 pragma solidity 0.4.24;
2 
3 contract IMigrationContract {
4     function migrate(address _addr, uint256 _tokens, uint256 _totaltokens) public returns (bool success);
5 }
6 
7 /* taking ideas from FirstBlood token */
8 contract SafeMath {
9 
10     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
11         uint256 z = x + y;
12         assert((z >= x) && (z >= y));
13         return z;
14     }
15 
16     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
17         assert(x >= y);
18         uint256 z = x - y;
19         return z;
20     }
21 
22     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
23         uint256 z = x * y;
24         assert((x == 0)||(z/x == y));
25         return z;
26     }
27     
28     function safeDiv(uint256 x, uint256 y) internal pure returns(uint256) {
29         uint256 z = x / y;
30         return z;
31     }
32 
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     address public ethFundDeposit;
42 
43     event OwnershipTransferred(address indexed ethFundDeposit, address indexed _newFundDeposit);
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     constructor() public {
50         ethFundDeposit = msg.sender;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(msg.sender == ethFundDeposit);
58         _;
59     }
60 
61     /**
62      * @dev Allows the current owner to transfer control of the contract to a _newFundDeposit.
63      * @param _newFundDeposit The address to transfer ownership to.
64      */
65     function transferOwnership(address _newFundDeposit) public onlyOwner {
66         require(_newFundDeposit != address(0));
67         emit OwnershipTransferred(ethFundDeposit, _newFundDeposit);
68         ethFundDeposit = _newFundDeposit;
69     }
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77     event Pause();
78     event Unpause();
79 
80     bool public paused = false;
81 
82     /**
83      * @dev modifier to allow actions only when the contract IS paused
84      */
85     modifier whenNotPaused() {
86         require(!paused);
87         _;
88     }
89 
90     /**
91      * @dev modifier to allow actions only when the contract IS NOT paused
92      */
93     modifier whenPaused {
94         require(paused);
95         _;
96     }
97 
98     /**
99      * @dev called by the owner to pause, triggers stopped state
100      */
101     function pause() public onlyOwner whenNotPaused {
102         paused = true;
103         emit Pause();
104     }
105 
106     /**
107      * @dev called by the owner to unpause, returns to normal state
108      */
109     function unpause() public onlyOwner whenPaused {
110         paused = false;
111         emit Unpause();
112     }
113 }
114 
115 
116 /**
117  * @title Controllable
118  * @dev Base contract which allows children to control the address
119  */
120 contract controllable is Ownable {
121 
122     event AddToBlacklist(address _addr);
123     event DeleteFromBlacklist(address _addr);
124 
125     // controllable variable
126     mapping (address => bool) internal blacklist; // black list
127 
128     /**
129      * @dev called by the owner to AddToBlacklist
130      */
131     function addtoblacklist(address _addr) public onlyOwner {
132         blacklist[_addr] = true;
133         emit AddToBlacklist(_addr);
134     }
135 
136     /**
137      * @dev called by the owner to unpDeleteFromBlacklistause
138      */
139     function deletefromblacklist(address _addr) public onlyOwner {
140         blacklist[_addr] = false;
141         emit DeleteFromBlacklist(_addr);
142     }
143 
144     /**
145      * @dev called by the owner to check the blacklist address
146      */
147     function isBlacklist(address _addr) public view returns(bool) {
148         return blacklist[_addr];
149     }
150 }
151 
152 
153 /**
154  * @title Lockable
155  * @dev Base contract which allows children to control the token release mechanism
156  */
157 contract Lockable is Ownable, SafeMath {
158 
159     // parameters
160     mapping (address => uint256) balances;
161     mapping (address => uint256) totalbalances;
162     uint256 public totalreleaseblances;
163 
164     mapping (address => mapping (uint256 => uint256)) userbalances; // address ， order ，balances amount
165     mapping (address => mapping (uint256 => uint256)) userRelease; // address ， order ，release amount
166     mapping (address => mapping (uint256 => uint256)) isRelease; // already release period
167     mapping (address => mapping (uint256 => uint256)) userChargeTime; // address ， order ，charge time
168     mapping (address => uint256) userChargeCount; // user total charge times
169     mapping (address => mapping (uint256 => uint256)) lastCliff; // address ， order ，last cliff time
170 
171     // userbalances each time segmentation
172     mapping (address => mapping (uint256 => mapping (uint256 => uint256))) userbalancesSegmentation; // address ， order ，balances amount
173 
174     uint256 internal duration = 30*15 days;
175     uint256 internal cliff = 90 days;
176 
177     // event
178     event userlockmechanism(address _addr,uint256 _amount,uint256 _timestamp);
179     event userrelease(address _addr, uint256 _times, uint256 _amount);
180 
181     modifier onlySelfOrOwner(address _addr) {
182         require(msg.sender == _addr || msg.sender == ethFundDeposit);
183         _;
184     }
185 
186     function LockMechanism (
187         address _addr,
188         uint256 _value
189     )
190         internal
191     {
192         require(_addr != address(0));
193         require(_value != 0);
194         // count
195         userChargeCount[_addr] = safeAdd(userChargeCount[_addr],1);
196         uint256 _times = userChargeCount[_addr];
197         // time
198         userChargeTime[_addr][_times] = ShowTime();
199         // balances
200         userbalances[_addr][_times] = _value;
201         initsegmentation(_addr,userChargeCount[_addr],_value);
202         totalbalances[_addr] = safeAdd(totalbalances[_addr],_value);
203         isRelease[_addr][_times] = 0;
204         emit userlockmechanism(_addr,_value,ShowTime());
205     }
206 
207 // init segmentation
208     function initsegmentation(address _addr,uint256 _times,uint256 _value) internal {
209         for (uint8 i = 1 ; i <= 5 ; i++ ) {
210             userbalancesSegmentation[_addr][_times][i] = safeDiv(_value,5);
211         }
212     }
213 
214 // calculate period
215     function CalcPeriod(address _addr, uint256 _times) public view returns (uint256) {
216         uint256 userstart = userChargeTime[_addr][_times];
217         if (ShowTime() >= safeAdd(userstart,duration)) {
218             return 5;
219         }
220         uint256 timedifference = safeSubtract(ShowTime(),userstart);
221         uint256 period = 0;
222         for (uint8 i = 1 ; i <= 5 ; i++ ) {
223             if (timedifference >= cliff) {
224                 timedifference = safeSubtract(timedifference,cliff);
225                 period += 1;
226             }
227         }
228         return period;
229     }
230 
231 // ReleasableAmount() looking for the current releasable amount
232     function ReleasableAmount(address _addr, uint256 _times) public view returns (uint256) {
233         require(_addr != address(0));
234         uint256 period = CalcPeriod(_addr,_times);
235         if (safeSubtract(period,isRelease[_addr][_times]) > 0){
236             uint256 amount = 0;
237             for (uint256 i = safeAdd(isRelease[_addr][_times],1) ; i <= period ; i++ ) {
238                 amount = safeAdd(amount,userbalancesSegmentation[_addr][_times][i]);
239             }
240             return amount;
241         } else {
242             return 0;
243         }
244     }
245 
246 // release() release the current releasable amount
247     function release(address _addr, uint256 _times) external onlySelfOrOwner(_addr) {
248         uint256 amount = ReleasableAmount(_addr,_times);
249         require(amount > 0);
250         userRelease[_addr][_times] = safeAdd(userRelease[_addr][_times],amount);
251         balances[_addr] = safeAdd(balances[_addr],amount);
252         lastCliff[_addr][_times] = ShowTime();
253         isRelease[_addr][_times] = CalcPeriod(_addr,_times);
254         totalreleaseblances = safeAdd(totalreleaseblances,amount);
255         emit userrelease(_addr, _times, amount);
256     }
257 
258 // ShowTime
259     function ShowTime() internal view returns (uint256) {
260         return block.timestamp;
261     }
262 
263 // totalBalance()
264     function totalBalanceOf(address _addr) public view returns (uint256) {
265         return totalbalances[_addr];
266     }
267 // ShowRelease() looking for the already release amount of the address at some time
268     function ShowRelease(address _addr, uint256 _times) public view returns (uint256) {
269         return userRelease[_addr][_times];
270     }
271 // ShowUnrelease() looking for the not yet release amount of the address at some time
272     function ShowUnrelease(address _addr, uint256 _times) public view returns (uint256) {
273         return safeSubtract(userbalances[_addr][_times],ShowRelease(_addr,_times));
274     }
275 // ShowChargeTime() looking for the charge time
276     function ShowChargeTime(address _addr, uint256 _times) public view returns (uint256) {
277         return userChargeTime[_addr][_times];
278     }
279 // ShowChargeCount() looking for the user total charge times
280     function ShowChargeCount(address _addr) public view returns (uint256) {
281         return userChargeCount[_addr];
282     }
283 // ShowNextCliff() looking for the nex cliff time
284     function ShowNextCliff(address _addr, uint256 _times) public view returns (uint256) {
285         return safeAdd(lastCliff[_addr][_times],cliff);
286     }
287 // ShowSegmentation() looking for the user balances Segmentation
288     function ShowSegmentation(address _addr, uint256 _times,uint256 _period) public view returns (uint256) {
289         return userbalancesSegmentation[_addr][_times][_period];
290     }
291 
292 }
293 
294 contract Token {
295     uint256 public totalSupply;
296     function balanceOf(address _owner) public view returns (uint256 balance);
297     function transfer(address _to, uint256 _value) public returns (bool success);
298     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
299     function approve(address _spender, uint256 _value) public returns (bool success);
300     function allowance(address _owner, address _spender) public view returns (uint256 remaining); 
301     event Transfer(address indexed _from, address indexed _to, uint256 _value);
302     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
303 }
304 
305 /*  ERC 20 token */
306 contract StandardToken is controllable, Pausable, Token, Lockable {
307 
308     function transfer(address _to, uint256 _value) public whenNotPaused() returns (bool success) {
309         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to] && !isBlacklist(msg.sender)) {
310             // sender
311             balances[msg.sender] = safeSubtract(balances[msg.sender],_value);
312             totalbalances[msg.sender] = safeSubtract(totalbalances[msg.sender],_value);
313             // _to
314             balances[_to] = safeAdd(balances[_to],_value);
315             totalbalances[_to] = safeAdd(totalbalances[_to],_value);
316 
317             emit Transfer(msg.sender, _to, _value);
318             return true;
319         } else {
320             return false;
321         }
322     }
323 
324     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused() returns (bool success) {
325         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to] && !isBlacklist(msg.sender)) {
326             // _to
327             balances[_to] = safeAdd(balances[_to],_value);
328             totalbalances[_to] = safeAdd(totalbalances[_to],_value);
329             // _from
330             balances[_from] = safeSubtract(balances[_from],_value);
331             totalbalances[_from] = safeSubtract(totalbalances[_from],_value);
332             // allowed
333             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
334 
335             emit Transfer(_from, _to, _value);
336             return true;
337         } else {
338             return false;
339         }
340     }
341 
342     function balanceOf(address _owner) public view returns (uint256 balance) {
343         return balances[_owner];
344     }
345 
346     function approve(address _spender, uint256 _value) public returns (bool success) {
347         allowed[msg.sender][_spender] = _value;
348         emit Approval(msg.sender, _spender, _value);
349         return true;
350     }
351 
352     function allowance(address _owner, address _spender) public view returns (uint256 remaining) { 
353         return allowed[_owner][_spender];
354     }
355 
356     // mapping (address => uint256) balances;
357     mapping (address => mapping (address => uint256)) allowed;
358 }
359 
360 contract BugXToken is StandardToken {
361 
362     /**
363     *  base parameters
364     */
365 
366     // metadata
367     string  public constant name = "BUGX Token";
368     string  public constant symbol = "BUX";
369     uint256 public constant decimals = 18;
370     string  public version = "1.0";
371 
372     // contracts
373     address public newContractAddr;         // the new contract for BUGX token updates;
374 
375     // crowdsale parameters
376     bool    public isFunding;                // switched to true in operational state
377     uint256 public fundingStartBlock;
378     uint256 public fundingStopBlock;
379 
380     uint256 public currentSupply;           // current supply tokens for sell
381     uint256 public tokenRaised = 0;           // the number of total sold token
382     uint256 public tokenIssued = 0;         // the number of total issued token
383     uint256 public tokenMigrated = 0;     // the number of total Migrated token
384     uint256 internal tokenExchangeRate = 9000;             // 9000 BUGX tokens per 1 ETH
385     uint256 internal tokenExchangeRateTwo = 9900;             // 9000 * 1.1 BUGX tokens per 1 ETH
386     uint256 internal tokenExchangeRateThree = 11250;             // 9000 * 1.25 BUGX tokens per 1 ETH
387 
388     // events
389     event AllocateToken(address indexed _to, uint256 _value);   // issue token to buyer;
390     event TakebackToken(address indexed _from, uint256 _value);   //  record token take back info;
391     event RaiseToken(address indexed _to, uint256 _value);      // record token raise info;
392     event IssueToken(address indexed _to, uint256 _value);
393     event IncreaseSupply(uint256 _value);
394     event DecreaseSupply(uint256 _value);
395     event Migrate(address indexed _addr, uint256 _tokens, uint256 _totaltokens);
396 
397     // format decimals.
398     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
399         return _value * 10 ** decimals;
400     }
401 
402     /**
403     *  constructor function
404     */
405 
406     // constructor
407     constructor(
408         address _ethFundDeposit,
409         uint256 _currentSupply
410         ) 
411         public
412     {
413         require(_ethFundDeposit != address(0x0));
414         ethFundDeposit = _ethFundDeposit;
415 
416         isFunding = false;                           //controls pre through crowdsale state
417         fundingStartBlock = 0;
418         fundingStopBlock = 0;
419 
420         currentSupply = formatDecimals(_currentSupply);
421         totalSupply = formatDecimals(1500000000);    //1,500,000,000 total supply
422         require(currentSupply <= totalSupply);
423         balances[ethFundDeposit] = currentSupply;
424         totalbalances[ethFundDeposit] = currentSupply;
425     }
426 
427     /**
428     *  Modify currentSupply functions
429     */
430 
431     /// @dev increase the token's supply
432     function increaseSupply (uint256 _tokens) onlyOwner external {
433         uint256 _value = formatDecimals(_tokens);
434         require (_value + currentSupply <= totalSupply);
435         currentSupply = safeAdd(currentSupply, _value);
436         tokenadd(ethFundDeposit,_value);
437         emit IncreaseSupply(_value);
438     }
439 
440     /// @dev decrease the token's supply
441     function decreaseSupply (uint256 _tokens) onlyOwner external {
442         uint256 _value = formatDecimals(_tokens);
443         uint256 tokenCirculation = safeAdd(tokenRaised,tokenIssued);
444         require (safeAdd(_value,tokenCirculation) <= currentSupply);
445         currentSupply = safeSubtract(currentSupply, _value);
446         tokensub(ethFundDeposit,_value);
447         emit DecreaseSupply(_value);
448     }
449 
450     /**
451     *  Funding functions
452     */
453 
454     modifier whenFunding() {
455         require (isFunding);
456         require (block.number >= fundingStartBlock);
457         require (block.number <= fundingStopBlock);
458         _;
459     }
460 
461     /// @dev turn on the funding state
462     function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) onlyOwner external {
463         require (!isFunding);
464         require (_fundingStartBlock < _fundingStopBlock);
465         require (block.number < _fundingStartBlock);
466 
467         fundingStartBlock = _fundingStartBlock;
468         fundingStopBlock = _fundingStopBlock;
469         isFunding = true;
470     }
471 
472     /// @dev turn off the funding state
473     function stopFunding() onlyOwner external {
474         require (isFunding);
475         isFunding = false;
476     }
477 
478 
479     /**
480     *  migrate functions
481     */
482 
483     /// @dev set a new contract for recieve the tokens (for update contract)
484     function setMigrateContract(address _newContractAddr) onlyOwner external {
485         require (_newContractAddr != newContractAddr);
486         newContractAddr = _newContractAddr;
487     }
488 
489     /// sends the tokens to new contract by owner
490     function migrate(address _addr) onlySelfOrOwner(_addr) external {
491         require(!isFunding);
492         require(newContractAddr != address(0x0));
493 
494         uint256 tokens_value = balances[_addr];
495         uint256 totaltokens_value = totalbalances[_addr];
496         require (tokens_value != 0 || totaltokens_value != 0);
497 
498         balances[_addr] = 0;
499         totalbalances[_addr] = 0;
500 
501         IMigrationContract newContract = IMigrationContract(newContractAddr);
502         require (newContract.migrate(_addr, tokens_value, totaltokens_value));
503 
504         tokenMigrated = safeAdd(tokenMigrated, totaltokens_value);
505         emit Migrate(_addr, tokens_value, totaltokens_value);
506     }
507 
508     /**
509     *  tokenRaised and tokenIssued control functions
510     *  base functions
511     */
512 
513     /// token raised
514     function tokenRaise (address _addr,uint256 _value) internal {
515         uint256 tokenCirculation = safeAdd(tokenRaised,tokenIssued);
516         require (safeAdd(_value,tokenCirculation) <= currentSupply);
517         tokenRaised = safeAdd(tokenRaised, _value);
518         emit RaiseToken(_addr, _value);
519     }
520 
521     /// issue token 1 : token issued
522     function tokenIssue (address _addr,uint256 _value) internal {
523         uint256 tokenCirculation = safeAdd(tokenRaised,tokenIssued);
524         require (safeAdd(_value,tokenCirculation) <= currentSupply);
525         tokenIssued = safeAdd(tokenIssued, _value);
526         emit IssueToken(_addr, _value);
527     }
528 
529     /// issue token 2 : issue token take back
530     function tokenTakeback (address _addr,uint256 _value) internal {
531         require (tokenIssued >= _value);
532         tokenIssued = safeSubtract(tokenIssued, _value);
533         emit TakebackToken(_addr, _value);
534     }
535 
536     /// issue token take from ethFundDeposit to user
537     function tokenadd (address _addr,uint256 _value) internal {
538         require(_value != 0);
539         require (_addr != address(0x0));
540         balances[_addr] = safeAdd(balances[_addr], _value);
541         totalbalances[_addr] = safeAdd(totalbalances[_addr], _value);
542     }
543 
544     /// issue token take from user to ethFundDeposit
545     function tokensub (address _addr,uint256 _value) internal {
546         require(_value != 0);
547         require (_addr != address(0x0));
548         balances[_addr] = safeSubtract(balances[_addr], _value);
549         totalbalances[_addr] = safeSubtract(totalbalances[_addr], _value);
550     }
551 
552     /**
553     *  tokenRaised and tokenIssued control functions
554     *  main functions
555     */
556 
557     /// Issues tokens to buyers.
558     function allocateToken(address _addr, uint256 _tokens) onlyOwner external {
559         uint256 _value = formatDecimals(_tokens);
560         tokenadd(_addr,_value);
561         tokensub(ethFundDeposit,_value);
562         tokenIssue(_addr,_value);
563         emit Transfer(ethFundDeposit, _addr, _value);
564     }
565 
566     /// Issues tokens deduction.
567     function deductionToken (address _addr, uint256 _tokens) onlyOwner external {
568         uint256 _value = formatDecimals(_tokens);
569         tokensub(_addr,_value);
570         tokenadd(ethFundDeposit,_value);
571         tokenTakeback(_addr,_value);
572         emit Transfer(_addr, ethFundDeposit, _value);
573     }
574 
575     /// add the segmentation
576     function addSegmentation(address _addr, uint256 _times,uint256 _period,uint256 _tokens) onlyOwner external returns (bool) {
577         uint256 amount = userbalancesSegmentation[_addr][_times][_period];
578         if (amount != 0 && _tokens != 0){
579             uint256 _value = formatDecimals(_tokens);
580             userbalancesSegmentation[_addr][_times][_period] = safeAdd(amount,_value);
581             userbalances[_addr][_times] = safeAdd(userbalances[_addr][_times], _value);
582             totalbalances[_addr] = safeAdd(totalbalances[_addr], _value);
583             tokensub(ethFundDeposit,_value);
584             tokenIssue(_addr,_value);
585             return true;
586         } else {
587             return false;
588         }
589     }
590 
591     /// sub the segmentation
592     function subSegmentation(address _addr, uint256 _times,uint256 _period,uint256 _tokens) onlyOwner external returns (bool) {
593         uint256 amount = userbalancesSegmentation[_addr][_times][_period];
594         if (amount != 0 && _tokens != 0){
595             uint256 _value = formatDecimals(_tokens);
596             userbalancesSegmentation[_addr][_times][_period] = safeSubtract(amount,_value);
597             userbalances[_addr][_times] = safeSubtract(userbalances[_addr][_times], _value);
598             totalbalances[_addr] = safeSubtract(totalbalances[_addr], _value);
599             tokenadd(ethFundDeposit,_value);
600             tokenTakeback(_addr,_value);
601             return true;
602         } else {
603             return false;
604         }
605     }
606 
607     /**
608     *  tokenExchangeRate functions
609     */
610 
611     /// @dev set the token's tokenExchangeRate,
612     function setTokenExchangeRate(uint256 _RateOne,uint256 _RateTwo,uint256 _RateThree) onlyOwner external {
613         require (_RateOne != 0 && _RateTwo != 0 && _RateThree != 0);
614         require (_RateOne != tokenExchangeRate && _RateTwo != tokenExchangeRateTwo && _RateThree != tokenExchangeRateThree);
615 
616         tokenExchangeRate = _RateOne;
617         tokenExchangeRateTwo = _RateTwo;
618         tokenExchangeRateThree = _RateThree;
619     }
620 
621     /// calculate the tokenExchangeRate
622     function computeTokenAmount(uint256 _eth) internal view returns (uint256 tokens) {
623         if(_eth > 0 && _eth < 100 ether){
624             tokens = safeMult(_eth, tokenExchangeRate);
625         }
626         
627         if (_eth >= 100 ether && _eth < 500 ether){
628             tokens = safeMult(_eth, tokenExchangeRateTwo);
629         }
630 
631         if (_eth >= 500 ether ){
632             tokens = safeMult(_eth, tokenExchangeRateThree);
633         }
634     }
635 
636     /**
637     *  Append : the LockMechanism functions by owner
638     */
639 
640     function LockMechanismByOwner (
641         address _addr,
642         uint256 _tokens
643     )
644         external onlyOwner whenFunding
645     {
646         require (_tokens != 0);
647         uint256 _value = formatDecimals(_tokens);
648         tokenRaise(_addr,_value);
649         tokensub(ethFundDeposit,_value);
650         LockMechanism(_addr,_value);
651         emit Transfer(ethFundDeposit,_addr,_value);
652     }
653 
654     /**
655     *  ETH control functions
656     */
657 
658     /// @dev sends ETH to BUGX team
659     function transferETH() onlyOwner external {
660         require (address(this).balance != 0);
661         ethFundDeposit.transfer(address(this).balance);
662     }
663 
664     function () public payable whenFunding { // fallback function
665         require (msg.value != 0);
666         uint256 _value = computeTokenAmount(msg.value);
667         tokenRaise(msg.sender,_value);
668         tokensub(ethFundDeposit,_value);
669         LockMechanism(msg.sender,_value);
670         emit Transfer(ethFundDeposit,msg.sender,_value);
671     }
672 }