1 pragma solidity ^0.4.19;
2 
3 // Turn the usage of callcode
4 contract SafeMath {
5      function safeMul(uint a, uint b) internal returns (uint) {
6           uint c = a * b;
7           assert(a == 0 || c / a == b);
8           return c;
9      }
10 
11      function safeSub(uint a, uint b) internal returns (uint) {
12           assert(b <= a);
13           return a - b;
14      }
15 
16      function safeAdd(uint a, uint b) internal returns (uint) {
17           uint c = a + b;
18           assert(c>=a && c>=b);
19           return c;
20      }
21 }
22 
23 contract CreatorEnabled {
24      address public creator = 0x0;
25 
26      modifier onlyCreator() { require(msg.sender==creator); _; }
27 
28      function changeCreator(address _to) public onlyCreator {
29           creator = _to;
30      }
31 }
32 
33 // ERC20 standard
34 contract StdToken is SafeMath {
35 // Fields:
36      mapping(address => uint256) public balances;
37      mapping (address => mapping (address => uint256)) internal allowed;
38      uint public totalSupply = 0;
39 
40 // Events:
41      event Transfer(address indexed _from, address indexed _to, uint256 _value);
42      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 // Functions:
45      function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns(bool) {
46           require(0x0!=_to);
47 
48           balances[msg.sender] = safeSub(balances[msg.sender],_value);
49           balances[_to] = safeAdd(balances[_to],_value);
50 
51           Transfer(msg.sender, _to, _value);
52           return true;
53      }
54 
55      function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
56           require(0x0!=_to);
57 
58           balances[_to] = safeAdd(balances[_to],_value);
59           balances[_from] = safeSub(balances[_from],_value);
60           allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
61 
62           Transfer(_from, _to, _value);
63           return true;
64      }
65 
66      function balanceOf(address _owner) constant returns (uint256) {
67           return balances[_owner];
68      }
69 
70      function approve(address _spender, uint256 _value) returns (bool) {
71           // To change the approve amount you first have to reduce the addresses`
72           //  allowance to zero by calling `approve(_spender, 0)` if it is not
73           //  already 0 to mitigate the race condition described here:
74           //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75           require((_value == 0) || (allowed[msg.sender][_spender] == 0));
76 
77           allowed[msg.sender][_spender] = _value;
78           Approval(msg.sender, _spender, _value);
79           return true;
80      }
81 
82      function allowance(address _owner, address _spender) constant returns (uint256) {
83           return allowed[_owner][_spender];
84      }
85 
86      modifier onlyPayloadSize(uint _size) {
87           require(msg.data.length >= _size + 4);
88           _;
89      }
90 }
91 
92 contract IGoldFee {
93      function calculateFee(
94           bool _isMigrationStarted, bool _isMigrationFinished, 
95           uint _mntpBalance, uint _value) public constant returns(uint);
96 }
97 
98 contract GoldFee is CreatorEnabled {
99 // Functions: 
100      function GoldFee() {
101           creator = msg.sender;
102      }
103 
104      function getMin(uint out)returns (uint) {
105           // 0.002 GOLD is min fee
106           uint minFee = (2 * 1 ether) / 1000;
107           if (out < minFee) {
108                return minFee;
109           }
110           return out;
111      }
112 
113      function getMax(uint out)returns (uint) {
114           // 0.02 GOLD is max fee
115           uint maxFee = (2 * 1 ether) / 100;
116           if (out >= maxFee) {
117                return maxFee;
118           }
119           return out;
120      }
121 
122      function calculateFee(
123           bool _isMigrationStarted, bool _isMigrationFinished, 
124           uint _mntpBalance, uint _value) public constant returns(uint) 
125      {
126           // When migration process is finished (1 year from Goldmint blockchain launch), then transaction fee is 1% GOLD.
127           if (_isMigrationFinished) {
128                return (_value / 100); 
129           }
130 
131           // If the sender holds 0 MNTP, then the transaction fee is 1% GOLD.
132 
133           // If the sender holds at least 10 MNTP, then the transaction fee is 0.333333% GOLD, 
134           // but not less than 0.002 MNTP
135 
136           // If the sender holds at least 1000 MNTP, then the transaction fee is 0.033333% GOLD,
137           // but not less than 0.002 MNTP
138 
139           // If the sender holds at least 10000 MNTP, then the transaction fee is 0.0333333% GOLD,
140           // but not more than 0.02 MNTP
141           if (_mntpBalance >= (10000 * 1 ether)) {
142                return getMax((_value / 100) / 30);
143           }
144           if (_mntpBalance >= (1000 * 1 ether)) {
145                return getMin((_value / 100) / 30);
146           }
147           if (_mntpBalance >= (10 * 1 ether)) {
148                return getMin((_value / 100) / 3);
149           }
150           
151           // 1%
152           return getMin(_value / 100);
153      }
154 }
155 
156 contract Gold is StdToken, CreatorEnabled {
157 // Fields:
158      string public constant name = "Goldmint GOLD Token";
159      string public constant symbol = "GOLD";
160      uint8 public constant decimals = 18;
161 
162      // this is used to send fees (that is then distributed as rewards)
163      address public migrationAddress = 0x0;
164      address public storageControllerAddress = 0x0;
165 
166      address public goldmintTeamAddress = 0x0;
167      IMNTP public mntpToken;
168      IGoldFee public goldFee;
169      
170 
171      bool public transfersLocked = false;
172      bool public contractLocked = false;
173      bool public migrationStarted = false;
174      bool public migrationFinished = false;
175 
176      uint public totalIssued = 0;
177      uint public totalBurnt = 0;
178 
179 
180 // Modifiers:
181      modifier onlyMigration() { require(msg.sender == migrationAddress); _; }
182      modifier onlyCreator() { require(msg.sender == creator); _; }
183      modifier onlyMigrationOrStorageController() { require(msg.sender == migrationAddress || msg.sender == storageControllerAddress); _; }
184      modifier onlyCreatorOrStorageController() { require(msg.sender == creator || msg.sender == storageControllerAddress); _; }
185      modifier onlyIfUnlocked() { require(!transfersLocked); _; }
186 
187 // Functions:
188      function Gold(address _mntpContractAddress, address _goldmintTeamAddress, address _goldFeeAddress) public {
189           creator = msg.sender;
190 
191           mntpToken = IMNTP(_mntpContractAddress);
192           goldmintTeamAddress = _goldmintTeamAddress; 
193           goldFee = IGoldFee(_goldFeeAddress);
194      }
195 
196      function setCreator(address _address) public onlyCreator {
197          creator = _address;
198      }
199 
200     function lockContract(bool _contractLocked) public onlyCreator {
201          contractLocked = _contractLocked;
202      }
203 
204      function setStorageControllerContractAddress(address _address) public onlyCreator {
205           storageControllerAddress = _address;
206      }
207 
208      function setMigrationContractAddress(address _migrationAddress) public onlyCreator {
209           migrationAddress = _migrationAddress;
210      }
211 
212      function setGoldmintTeamAddress(address _teamAddress) public onlyCreator {
213           goldmintTeamAddress = _teamAddress;
214      }
215 
216      function setGoldFeeAddress(address _goldFeeAddress) public onlyCreator {
217           goldFee = IGoldFee(_goldFeeAddress);
218      }
219      
220      function issueTokens(address _who, uint _tokens) public onlyCreatorOrStorageController {
221           require(!contractLocked);
222 
223           balances[_who] = safeAdd(balances[_who],_tokens);
224           totalSupply = safeAdd(totalSupply,_tokens);
225           totalIssued = safeAdd(totalIssued,_tokens);
226 
227           Transfer(0x0, _who, _tokens);
228      }
229 
230      function burnTokens(address _who, uint _tokens) public onlyMigrationOrStorageController {
231           require(!contractLocked);
232           balances[_who] = safeSub(balances[_who],_tokens);
233           totalSupply = safeSub(totalSupply,_tokens);
234           totalBurnt = safeAdd(totalBurnt,_tokens);
235      }
236 
237      // there is no way to revert that
238      function startMigration() public onlyMigration {
239           require(false == migrationStarted);
240           migrationStarted = true;
241      }
242 
243      // there is no way to revert that
244      function finishMigration() public onlyMigration {
245           require(true == migrationStarted);
246 
247           migrationFinished = true;
248      }
249 
250      function lockTransfer(bool _lock) public onlyMigration {
251           transfersLocked = _lock;
252      }
253 
254      function transfer(address _to, uint256 _value) public onlyIfUnlocked onlyPayloadSize(2 * 32) returns(bool) {
255 
256           uint yourCurrentMntpBalance = mntpToken.balanceOf(msg.sender);
257 
258           // you can transfer if fee is ZERO 
259           uint fee = goldFee.calculateFee(migrationStarted, migrationFinished, yourCurrentMntpBalance, _value);
260           uint sendThis = _value;
261           if (0 != fee) { 
262                sendThis = safeSub(_value,fee);
263           
264                // 1.Transfer fee
265                // A -> rewards account
266                // 
267                // Each GOLD token transfer should send transaction fee to
268                // GoldmintMigration contract if Migration process is not started.
269                // Goldmint team if Migration process is started.
270                if (migrationStarted) {
271                     super.transfer(goldmintTeamAddress, fee);
272                } else {
273                     super.transfer(migrationAddress, fee);
274                }
275           }
276 
277           // 2.Transfer
278           // A -> B
279           return super.transfer(_to, sendThis);
280      }
281 
282      function transferFrom(address _from, address _to, uint256 _value) public onlyIfUnlocked returns(bool) {
283 
284           uint yourCurrentMntpBalance = mntpToken.balanceOf(_from);
285 
286           uint fee = goldFee.calculateFee(migrationStarted, migrationFinished, yourCurrentMntpBalance, _value);
287           if (0 != fee) { 
288                // 1.Transfer fee
289                // A -> rewards account
290                // 
291                // Each GOLD token transfer should send transaction fee to
292                // GoldmintMigration contract if Migration process is not started.
293                // Goldmint team if Migration process is started.
294                if (migrationStarted) {
295                     super.transferFrom(_from, goldmintTeamAddress, fee);
296                } else {
297                     super.transferFrom(_from, migrationAddress, fee);
298                }
299           }
300           
301           // 2.Transfer
302           // A -> B
303           uint sendThis = safeSub(_value,fee);
304           return super.transferFrom(_from, _to, sendThis);
305      }
306 
307      // Used to send rewards)
308      function transferRewardWithoutFee(address _to, uint _value) public onlyMigration onlyPayloadSize(2*32) {
309           require(0x0!=_to);
310 
311           balances[migrationAddress] = safeSub(balances[migrationAddress],_value);
312           balances[_to] = safeAdd(balances[_to],_value);
313 
314           Transfer(migrationAddress, _to, _value);
315      }
316 
317      // This is an emergency function that can be called by Creator only 
318      function rescueAllRewards(address _to) public onlyCreator {
319           require(0x0!=_to);
320 
321           uint totalReward = balances[migrationAddress];
322 
323           balances[_to] = safeAdd(balances[_to],totalReward);
324           balances[migrationAddress] = 0;
325 
326           Transfer(migrationAddress, _to, totalReward);
327      }
328 
329 
330      function getTotalIssued() public constant returns (uint) {
331           return totalIssued; 
332      }
333 
334      function getTotalBurnt() public constant returns (uint) {
335           return totalBurnt; 
336      }
337 
338 
339 }
340 
341 contract IMNTP is StdToken {
342 // Additional methods that MNTP contract provides
343      function lockTransfer(bool _lock);
344      function issueTokens(address _who, uint _tokens);
345      function burnTokens(address _who, uint _tokens);
346 }
347 
348 contract GoldmintMigration is CreatorEnabled {
349 // Fields:
350      IMNTP public mntpToken;
351      Gold public goldToken;
352 
353      enum State {
354           Init,
355           MigrationStarted,
356           MigrationPaused,
357           MigrationFinished
358      }
359 
360      State public state = State.Init;
361      
362      // this is total collected GOLD rewards (launch to migration start)
363      uint public mntpToMigrateTotal = 0;
364      uint public migrationRewardTotal = 0;
365      uint64 public migrationStartedTime = 0;
366      uint64 public migrationFinishedTime = 0;
367 
368      struct Migration {
369           address ethAddress;
370           string gmAddress;
371           uint tokensCount;
372           bool migrated;
373           uint64 date;
374           string comment;
375      }
376 
377      mapping (uint=>Migration) public mntpMigrations;
378      mapping (address=>uint) public mntpMigrationIndexes;
379      uint public mntpMigrationsCount = 0;
380 
381      mapping (uint=>Migration) public goldMigrations;
382      mapping (address=>uint) public goldMigrationIndexes;
383      uint public goldMigrationsCount = 0;
384 
385      event MntpMigrateWanted(address _ethAddress, string _gmAddress, uint256 _value);
386      event MntpMigrated(address _ethAddress, string _gmAddress, uint256 _value);
387 
388      event GoldMigrateWanted(address _ethAddress, string _gmAddress, uint256 _value);
389      event GoldMigrated(address _ethAddress, string _gmAddress, uint256 _value);
390 
391 // Access methods
392      function getMntpMigration(uint index) public constant returns(address,string,uint,bool,uint64,string){
393           Migration memory mig = mntpMigrations[index];
394           return (mig.ethAddress, mig.gmAddress, mig.tokensCount, mig.migrated, mig.date, mig.comment);
395      }
396 
397      function getGoldMigration(uint index) public constant returns(address,string,uint,bool,uint64,string){
398           Migration memory mig = goldMigrations[index];
399           return (mig.ethAddress, mig.gmAddress, mig.tokensCount, mig.migrated, mig.date, mig.comment);
400      }
401 
402 // Functions:
403      // Constructor
404      function GoldmintMigration(address _mntpContractAddress, address _goldContractAddress) public {
405           creator = msg.sender;
406 
407           require(_mntpContractAddress != 0);
408           require(_goldContractAddress != 0);
409 
410           mntpMigrationIndexes[address(0x0)] = 0;
411           goldMigrationIndexes[address(0x0)] = 0;
412 
413           mntpToken = IMNTP(_mntpContractAddress);
414           goldToken = Gold(_goldContractAddress);
415      }
416 
417      function lockMntpTransfers(bool _lock) public onlyCreator {
418           mntpToken.lockTransfer(_lock);
419      }
420 
421      function lockGoldTransfers(bool _lock) public onlyCreator {
422           goldToken.lockTransfer(_lock);
423      }
424 
425      // This method is called when migration to Goldmint's blockchain
426      // process is started...
427      function startMigration() public onlyCreator {
428           require((State.Init == state) || (State.MigrationPaused == state));
429 
430           if (State.Init == state) {
431                // 1 - change fees
432                goldToken.startMigration();
433                
434                // 2 - store the current values 
435                migrationRewardTotal = goldToken.balanceOf(this);
436                migrationStartedTime = uint64(now);
437                mntpToMigrateTotal = mntpToken.totalSupply();
438           }
439 
440           state = State.MigrationStarted;
441      }
442 
443      function pauseMigration() public onlyCreator {
444           require((state == State.MigrationStarted) || (state == State.MigrationFinished));
445 
446           state = State.MigrationPaused;
447      }
448 
449      // that doesn't mean that you cant migrate from Ethereum -> Goldmint blockchain
450      // that means that you will get no reward
451      function finishMigration() public onlyCreator {
452           require((State.MigrationStarted == state) || (State.MigrationPaused == state));
453 
454           if (State.MigrationStarted == state) {
455                goldToken.finishMigration();
456                migrationFinishedTime = uint64(now);
457           }
458 
459           state = State.MigrationFinished;
460      }
461 
462      function destroyMe() public onlyCreator {
463           selfdestruct(msg.sender);          
464      }
465 
466 // MNTP
467      // Call this to migrate your MNTP tokens to Goldmint MNT
468      // (this is one-way only)
469      // _gmAddress is something like that - "BTS7yRXCkBjKxho57RCbqYE3nEiprWXXESw3Hxs5CKRnft8x7mdGi"
470      //
471      // !!! WARNING: will not allow anyone to migrate tokens partly
472      // !!! DISCLAIMER: check goldmint blockchain address format. You will not be able to change that!
473      function migrateMntp(string _gmAddress) public {
474           require((state==State.MigrationStarted) || (state==State.MigrationFinished));
475 
476           // 1 - calculate current reward
477           uint myBalance = mntpToken.balanceOf(msg.sender);
478           require(0!=myBalance);
479 
480           uint myRewardMax = calculateMyRewardMax(msg.sender);        
481           uint myReward = calculateMyReward(myRewardMax);
482 
483           // 2 - pay the reward to our user
484           goldToken.transferRewardWithoutFee(msg.sender, myReward);
485 
486           // 3 - burn tokens 
487           // WARNING: burn will reduce totalSupply
488           // 
489           // WARNING: creator must call 
490           // setIcoContractAddress(migrationContractAddress)
491           // of the mntpToken
492           mntpToken.burnTokens(msg.sender,myBalance);
493 
494           // save tuple 
495           Migration memory mig;
496           mig.ethAddress = msg.sender;
497           mig.gmAddress = _gmAddress;
498           mig.tokensCount = myBalance;
499           mig.migrated = false;
500           mig.date = uint64(now);
501           mig.comment = '';
502 
503           mntpMigrations[mntpMigrationsCount + 1] = mig;
504           mntpMigrationIndexes[msg.sender] = mntpMigrationsCount + 1;
505           mntpMigrationsCount++;
506 
507           // send an event
508           MntpMigrateWanted(msg.sender, _gmAddress, myBalance);
509      }
510 
511      function isMntpMigrated(address _who) public constant returns(bool) {
512           uint index = mntpMigrationIndexes[_who];
513 
514           Migration memory mig = mntpMigrations[index];
515           return mig.migrated;
516      }
517 
518      function setMntpMigrated(address _who, bool _isMigrated, string _comment) public onlyCreator { 
519           uint index = mntpMigrationIndexes[_who];
520           require(index > 0);
521 
522           mntpMigrations[index].migrated = _isMigrated; 
523           mntpMigrations[index].comment = _comment; 
524 
525           // send an event
526           if (_isMigrated) {
527                MntpMigrated(  mntpMigrations[index].ethAddress, 
528                               mntpMigrations[index].gmAddress, 
529                               mntpMigrations[index].tokensCount);
530           }
531      }
532 
533 // GOLD
534      function migrateGold(string _gmAddress) public {
535           require((state==State.MigrationStarted) || (state==State.MigrationFinished));
536 
537           // 1 - get balance
538           uint myBalance = goldToken.balanceOf(msg.sender);
539           require(0!=myBalance);
540 
541           // 2 - burn tokens 
542           // WARNING: burn will reduce totalSupply
543           // 
544           goldToken.burnTokens(msg.sender,myBalance);
545 
546           // save tuple 
547           Migration memory mig;
548           mig.ethAddress = msg.sender;
549           mig.gmAddress = _gmAddress;
550           mig.tokensCount = myBalance;
551           mig.migrated = false;
552           mig.date = uint64(now);
553           mig.comment = '';
554 
555           goldMigrations[goldMigrationsCount + 1] = mig;
556           goldMigrationIndexes[msg.sender] = goldMigrationsCount + 1;
557           goldMigrationsCount++;
558 
559           // send an event
560           GoldMigrateWanted(msg.sender, _gmAddress, myBalance);
561      }
562 
563      function isGoldMigrated(address _who) public constant returns(bool) {
564           uint index = goldMigrationIndexes[_who];
565 
566           Migration memory mig = goldMigrations[index];
567           return mig.migrated;
568      }
569 
570      function setGoldMigrated(address _who, bool _isMigrated, string _comment) public onlyCreator { 
571           uint index = goldMigrationIndexes[_who];
572           require(index > 0);
573 
574           goldMigrations[index].migrated = _isMigrated; 
575           goldMigrations[index].comment = _comment; 
576 
577           // send an event
578           if (_isMigrated) {
579                GoldMigrated(  goldMigrations[index].ethAddress, 
580                               goldMigrations[index].gmAddress, 
581                               goldMigrations[index].tokensCount);
582           }
583      }
584 
585      // Each MNTP token holder gets a GOLD reward as a percent of all rewards
586      // proportional to his MNTP token stake
587      function calculateMyRewardMax(address _of) public constant returns(uint){
588           if (0 == mntpToMigrateTotal) {
589                return 0;
590           }
591 
592           uint myCurrentMntpBalance = mntpToken.balanceOf(_of);
593           if (0 == myCurrentMntpBalance) {
594                return 0;
595           }
596 
597           return (migrationRewardTotal * myCurrentMntpBalance) / mntpToMigrateTotal;
598      }
599 
600      // Migration rewards decreased linearly. 
601      // 
602      // The formula is: rewardPercents = max(100 - 100 * day / 365, 0)
603      //
604      // On 1st day of migration, you will get: 100 - 100 * 0/365 = 100% of your rewards
605      // On 2nd day of migration, you will get: 100 - 100 * 1/365 = 99.7261% of your rewards
606      // On 365th day of migration, you will get: 100 - 100 * 364/365 = 0.274%
607      function calculateMyRewardDecreased(uint _day, uint _myRewardMax) public constant returns(uint){
608           if (_day >= 365) {
609                return 0;
610           }
611 
612           uint x = ((100 * 1000000000 * _day) / 365);
613           return (_myRewardMax * ((100 * 1000000000) - x)) / (100 * 1000000000);
614      }
615      
616      function calculateMyReward(uint _myRewardMax) public constant returns(uint){
617           // day starts from 0
618           uint day = (uint64(now) - migrationStartedTime) / uint64(1 days);  
619           return calculateMyRewardDecreased(day, _myRewardMax);
620      }
621 
622 /////////
623      // do not allow to send money to this contract...
624      function() external payable {
625           revert();
626      }
627 }