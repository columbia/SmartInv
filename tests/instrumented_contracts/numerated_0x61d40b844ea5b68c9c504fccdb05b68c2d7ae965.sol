1 pragma solidity ^0.4.19;
2 
3 // Turn the usage of callcode
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal returns (uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         assert(c>=a && c>=b);
19         return c;
20     }
21 }
22 
23 contract CreatorEnabled {
24     address public creator = 0x0;
25 
26     modifier onlyCreator() { require(msg.sender==creator); _; }
27 
28     function changeCreator(address _to) public onlyCreator {
29         creator = _to;
30     }
31 }
32 
33 // ERC20 standard
34 contract StdToken is SafeMath {
35 
36     mapping(address => uint256) public balances;
37     mapping (address => mapping (address => uint256)) internal allowed;
38     uint public totalSupply = 0;
39 
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 
45     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns(bool) {
46       require(0x0!=_to);
47 
48       balances[msg.sender] = safeSub(balances[msg.sender],_value);
49       balances[_to] = safeAdd(balances[_to],_value);
50 
51       Transfer(msg.sender, _to, _value);
52       return true;
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns(bool) {
56       require(0x0!=_to);
57 
58       balances[_to] = safeAdd(balances[_to],_value);
59       balances[_from] = safeSub(balances[_from],_value);
60       allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
61 
62       Transfer(_from, _to, _value);
63       return true;
64     }
65 
66     function balanceOf(address _owner) constant returns (uint256) {
67       return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) returns (bool) {
71       // To change the approve amount you first have to reduce the addresses`
72       //  allowance to zero by calling `approve(_spender, 0)` if it is not
73       //  already 0 to mitigate the race condition described here:
74       //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75       require((_value == 0) || (allowed[msg.sender][_spender] == 0));
76 
77       allowed[msg.sender][_spender] = _value;
78       Approval(msg.sender, _spender, _value);
79       return true;
80     }
81 
82     function allowance(address _owner, address _spender) constant returns (uint256) {
83       return allowed[_owner][_spender];
84     }
85 
86     modifier onlyPayloadSize(uint _size) {
87       require(msg.data.length >= _size + 4);
88       _;
89     }
90 }
91 
92 contract IGoldFee {
93     function calculateFee(address _sender, bool _isMigrationStarted, bool _isMigrationFinished, uint _mntpBalance, uint _value) public constant returns(uint);
94 }
95 
96 contract GoldFee is CreatorEnabled {
97 
98     mapping(address => bool) exceptAddresses;
99 
100     function GoldFee() {
101         creator = msg.sender;
102     }
103 
104     function getMin(uint out)returns (uint) {
105         // 0.002 GOLD is min fee
106         uint minFee = (2 * 1 ether) / 1000;
107         if (out < minFee) {
108              return minFee;
109         }
110         return out;
111     }
112 
113     function getMax(uint out)returns (uint) {
114         // 0.02 GOLD is max fee
115         uint maxFee = (2 * 1 ether) / 100;
116         if (out >= maxFee) {
117              return maxFee;
118         }
119         return out;
120     }
121 
122     function calculateFee(address _sender, bool _isMigrationStarted, bool _isMigrationFinished, uint _mntpBalance, uint _value) public constant returns(uint)
123     {
124        //if this is an excaptional address
125        if (exceptAddresses[_sender]) {
126             return 0;
127        }
128 
129         // When migration process is finished (1 year from Goldmint blockchain launch), then transaction fee is 1% GOLD.
130         if (_isMigrationFinished) {
131              return (_value / 100);
132         }
133 
134         // If the sender holds 0 MNTP, then the transaction fee is 1% GOLD.
135 
136         // If the sender holds at least 10 MNTP, then the transaction fee is 0.333333% GOLD,
137         // but not less than 0.002 MNTP
138 
139         // If the sender holds at least 1000 MNTP, then the transaction fee is 0.033333% GOLD,
140         // but not less than 0.002 MNTP
141 
142         // If the sender holds at least 10000 MNTP, then the transaction fee is 0.0333333% GOLD,
143         // but not more than 0.02 MNTP
144         if (_mntpBalance >= (10000 * 1 ether)) {
145              return getMax((_value / 100) / 30);
146         }
147         if (_mntpBalance >= (1000 * 1 ether)) {
148              return getMin((_value / 100) / 30);
149         }
150         if (_mntpBalance >= (10 * 1 ether)) {
151              return getMin((_value / 100) / 3);
152         }
153 
154         // 1%
155         return getMin(_value / 100);
156     }
157 
158     function addExceptAddress(address _address) public onlyCreator {
159         exceptAddresses[_address] = true;
160     }
161 
162     function removeExceptAddress(address _address) public onlyCreator {
163         exceptAddresses[_address] = false;
164     }
165 
166     function isAddressExcept(address _address) public constant returns(bool) {
167         return exceptAddresses[_address];
168     }
169 }
170 
171 contract Gold is StdToken, CreatorEnabled {
172 
173     string public constant name = "GoldMint GOLD cryptoasset";
174     string public constant symbol = "GOLD";
175     uint8 public constant decimals = 18;
176 
177     // this is used to send fees (that is then distributed as rewards)
178     address public migrationAddress = 0x0;
179     address public storageControllerAddress = 0x0;
180 
181     address public goldmintTeamAddress = 0x0;
182     IMNTP public mntpToken;
183     IGoldFee public goldFee;
184 
185 
186     bool public transfersLocked = false;
187     bool public contractLocked = false;
188     bool public migrationStarted = false;
189     bool public migrationFinished = false;
190 
191     uint public totalIssued = 0;
192     uint public totalBurnt = 0;
193 
194     // Modifiers:
195     modifier onlyMigration() { require(msg.sender == migrationAddress); _; }
196     modifier onlyMigrationOrStorageController() { require(msg.sender == migrationAddress || msg.sender == storageControllerAddress); _; }
197     modifier onlyCreatorOrStorageController() { require(msg.sender == creator || msg.sender == storageControllerAddress); _; }
198     modifier onlyIfUnlocked() { require(!transfersLocked); _; }
199 
200     // Functions:
201     function Gold(address _mntpContractAddress, address _goldmintTeamAddress, address _goldFeeAddress) public {
202         creator = msg.sender;
203 
204         mntpToken = IMNTP(_mntpContractAddress);
205         goldmintTeamAddress = _goldmintTeamAddress;
206         goldFee = IGoldFee(_goldFeeAddress);
207     }
208 
209     function setCreator(address _address) public onlyCreator {
210        creator = _address;
211     }
212 
213     function lockContract(bool _contractLocked) public onlyCreator {
214        contractLocked = _contractLocked;
215     }
216 
217     function setStorageControllerContractAddress(address _address) public onlyCreator {
218         storageControllerAddress = _address;
219     }
220 
221     function setMigrationContractAddress(address _migrationAddress) public onlyCreator {
222         migrationAddress = _migrationAddress;
223     }
224 
225     function setGoldmintTeamAddress(address _teamAddress) public onlyCreator {
226         goldmintTeamAddress = _teamAddress;
227     }
228 
229     function setGoldFeeAddress(address _goldFeeAddress) public onlyCreator {
230         goldFee = IGoldFee(_goldFeeAddress);
231     }
232 
233     function issueTokens(address _who, uint _tokens) public onlyCreatorOrStorageController {
234         require(!contractLocked);
235 
236         balances[_who] = safeAdd(balances[_who],_tokens);
237         totalSupply = safeAdd(totalSupply,_tokens);
238         totalIssued = safeAdd(totalIssued,_tokens);
239 
240         Transfer(0x0, _who, _tokens);
241     }
242 
243     function burnTokens(address _who, uint _tokens) public onlyMigrationOrStorageController {
244         require(!contractLocked);
245         balances[_who] = safeSub(balances[_who],_tokens);
246         totalSupply = safeSub(totalSupply,_tokens);
247         totalBurnt = safeAdd(totalBurnt,_tokens);
248     }
249 
250     // there is no way to revert that
251     function startMigration() public onlyMigration {
252         require(false == migrationStarted);
253         migrationStarted = true;
254     }
255 
256     // there is no way to revert that
257     function finishMigration() public onlyMigration {
258         require(true == migrationStarted);
259 
260         migrationFinished = true;
261     }
262 
263     function lockTransfer(bool _lock) public onlyMigration {
264         transfersLocked = _lock;
265     }
266 
267     function transfer(address _to, uint256 _value) public onlyIfUnlocked onlyPayloadSize(2 * 32) returns(bool) {
268 
269         uint yourCurrentMntpBalance = mntpToken.balanceOf(msg.sender);
270 
271         // you can transfer if fee is ZERO
272         uint fee = goldFee.calculateFee(msg.sender, migrationStarted, migrationFinished, yourCurrentMntpBalance, _value);
273         uint sendThis = _value;
274         if (0 != fee) {
275              sendThis = safeSub(_value,fee);
276 
277              // 1.Transfer fee
278              // A -> rewards account
279              //
280              // Each GOLD token transfer should send transaction fee to
281              // GoldmintMigration contract if Migration process is not started.
282              // Goldmint team if Migration process is started.
283              if (migrationStarted) {
284                   super.transfer(goldmintTeamAddress, fee);
285              } else {
286                   super.transfer(migrationAddress, fee);
287              }
288         }
289 
290         // 2.Transfer
291         // A -> B
292         return super.transfer(_to, sendThis);
293     }
294 
295     function transferFrom(address _from, address _to, uint256 _value) public onlyIfUnlocked returns(bool) {
296 
297         uint yourCurrentMntpBalance = mntpToken.balanceOf(_from);
298 
299         uint fee = goldFee.calculateFee(msg.sender, migrationStarted, migrationFinished, yourCurrentMntpBalance, _value);
300         if (0 != fee) {
301              // 1.Transfer fee
302              // A -> rewards account
303              //
304              // Each GOLD token transfer should send transaction fee to
305              // GoldmintMigration contract if Migration process is not started.
306              // Goldmint team if Migration process is started.
307              if (migrationStarted) {
308                   super.transferFrom(_from, goldmintTeamAddress, fee);
309              } else {
310                   super.transferFrom(_from, migrationAddress, fee);
311              }
312         }
313 
314         // 2.Transfer
315         // A -> B
316         uint sendThis = safeSub(_value,fee);
317         return super.transferFrom(_from, _to, sendThis);
318     }
319 
320     // Used to send rewards)
321     function transferRewardWithoutFee(address _to, uint _value) public onlyMigration onlyPayloadSize(2*32) {
322         require(0x0!=_to);
323 
324         balances[migrationAddress] = safeSub(balances[migrationAddress],_value);
325         balances[_to] = safeAdd(balances[_to],_value);
326 
327         Transfer(migrationAddress, _to, _value);
328     }
329 
330     // This is an emergency function that can be called by Creator only
331     function rescueAllRewards(address _to) public onlyCreator {
332         require(0x0!=_to);
333 
334         uint totalReward = balances[migrationAddress];
335 
336         balances[_to] = safeAdd(balances[_to],totalReward);
337         balances[migrationAddress] = 0;
338 
339         Transfer(migrationAddress, _to, totalReward);
340     }
341 
342 
343     function getTotalIssued() public constant returns (uint) {
344         return totalIssued;
345     }
346 
347     function getTotalBurnt() public constant returns (uint) {
348         return totalBurnt;
349     }
350 }
351 
352 contract IMNTP is StdToken {
353     // Additional methods that MNTP contract provides
354     function lockTransfer(bool _lock);
355     function issueTokens(address _who, uint _tokens);
356     function burnTokens(address _who, uint _tokens);
357 }
358 
359 contract GoldmintMigration is CreatorEnabled {
360     // Fields:
361     IMNTP public mntpToken;
362     Gold public goldToken;
363 
364     enum State {
365         Init,
366         MigrationStarted,
367         MigrationPaused,
368         MigrationFinished
369     }
370 
371     State public state = State.Init;
372 
373     // this is total collected GOLD rewards (launch to migration start)
374     uint public mntpToMigrateTotal = 0;
375     uint public migrationRewardTotal = 0;
376     uint64 public migrationStartedTime = 0;
377     uint64 public migrationFinishedTime = 0;
378 
379     struct Migration {
380         address ethAddress;
381         string gmAddress;
382         uint tokensCount;
383         bool migrated;
384         uint64 date;
385         string comment;
386     }
387 
388     mapping (uint=>Migration) public mntpMigrations;
389     mapping (address=>uint) public mntpMigrationIndexes;
390     uint public mntpMigrationsCount = 0;
391 
392     mapping (uint=>Migration) public goldMigrations;
393     mapping (address=>uint) public goldMigrationIndexes;
394     uint public goldMigrationsCount = 0;
395 
396     event MntpMigrateWanted(address _ethAddress, string _gmAddress, uint256 _value);
397     event MntpMigrated(address _ethAddress, string _gmAddress, uint256 _value);
398 
399     event GoldMigrateWanted(address _ethAddress, string _gmAddress, uint256 _value);
400     event GoldMigrated(address _ethAddress, string _gmAddress, uint256 _value);
401 
402     // Access methods
403     function getMntpMigration(uint index) public constant returns(address,string,uint,bool,uint64,string){
404         Migration memory mig = mntpMigrations[index];
405         return (mig.ethAddress, mig.gmAddress, mig.tokensCount, mig.migrated, mig.date, mig.comment);
406     }
407 
408     function getGoldMigration(uint index) public constant returns(address,string,uint,bool,uint64,string){
409         Migration memory mig = goldMigrations[index];
410         return (mig.ethAddress, mig.gmAddress, mig.tokensCount, mig.migrated, mig.date, mig.comment);
411     }
412 
413     // Functions:
414     // Constructor
415     function GoldmintMigration(address _mntpContractAddress, address _goldContractAddress) public {
416         creator = msg.sender;
417 
418         require(_mntpContractAddress != 0);
419         require(_goldContractAddress != 0);
420 
421         mntpMigrationIndexes[address(0x0)] = 0;
422         goldMigrationIndexes[address(0x0)] = 0;
423 
424         mntpToken = IMNTP(_mntpContractAddress);
425         goldToken = Gold(_goldContractAddress);
426     }
427 
428     function lockMntpTransfers(bool _lock) public onlyCreator {
429         mntpToken.lockTransfer(_lock);
430     }
431 
432     function lockGoldTransfers(bool _lock) public onlyCreator {
433         goldToken.lockTransfer(_lock);
434     }
435 
436     // This method is called when migration to Goldmint's blockchain
437     // process is started...
438     function startMigration() public onlyCreator {
439         require((State.Init == state) || (State.MigrationPaused == state));
440 
441         if (State.Init == state) {
442              // 1 - change fees
443              goldToken.startMigration();
444 
445              // 2 - store the current values
446              migrationRewardTotal = goldToken.balanceOf(this);
447              migrationStartedTime = uint64(now);
448              mntpToMigrateTotal = mntpToken.totalSupply();
449         }
450 
451         state = State.MigrationStarted;
452     }
453 
454     function pauseMigration() public onlyCreator {
455         require((state == State.MigrationStarted) || (state == State.MigrationFinished));
456 
457         state = State.MigrationPaused;
458     }
459 
460     // that doesn't mean that you cant migrate from Ethereum -> Goldmint blockchain
461     // that means that you will get no reward
462     function finishMigration() public onlyCreator {
463         require((State.MigrationStarted == state) || (State.MigrationPaused == state));
464 
465         if (State.MigrationStarted == state) {
466              goldToken.finishMigration();
467              migrationFinishedTime = uint64(now);
468         }
469 
470         state = State.MigrationFinished;
471     }
472 
473     function destroyMe() public onlyCreator {
474         selfdestruct(msg.sender);
475     }
476 
477     // MNTP
478     // Call this to migrate your MNTP tokens to Goldmint MNT
479     // (this is one-way only)
480     // _gmAddress is something like that - "BTS7yRXCkBjKxho57RCbqYE3nEiprWXXESw3Hxs5CKRnft8x7mdGi"
481     //
482     // !!! WARNING: will not allow anyone to migrate tokens partly
483     // !!! DISCLAIMER: check goldmint blockchain address format. You will not be able to change that!
484     function migrateMntp(string _gmAddress) public {
485         require((state==State.MigrationStarted) || (state==State.MigrationFinished));
486 
487         // 1 - calculate current reward
488         uint myBalance = mntpToken.balanceOf(msg.sender);
489         require(0!=myBalance);
490 
491         uint myRewardMax = calculateMyRewardMax(msg.sender);
492         uint myReward = calculateMyReward(myRewardMax);
493 
494         // 2 - pay the reward to our user
495         goldToken.transferRewardWithoutFee(msg.sender, myReward);
496 
497         // 3 - burn tokens
498         // WARNING: burn will reduce totalSupply
499         //
500         // WARNING: creator must call
501         // setIcoContractAddress(migrationContractAddress)
502         // of the mntpToken
503         mntpToken.burnTokens(msg.sender,myBalance);
504 
505         // save tuple
506         Migration memory mig;
507         mig.ethAddress = msg.sender;
508         mig.gmAddress = _gmAddress;
509         mig.tokensCount = myBalance;
510         mig.migrated = false;
511         mig.date = uint64(now);
512         mig.comment = '';
513 
514         mntpMigrations[mntpMigrationsCount + 1] = mig;
515         mntpMigrationIndexes[msg.sender] = mntpMigrationsCount + 1;
516         mntpMigrationsCount++;
517 
518         // send an event
519         MntpMigrateWanted(msg.sender, _gmAddress, myBalance);
520     }
521 
522     function isMntpMigrated(address _who) public constant returns(bool) {
523         uint index = mntpMigrationIndexes[_who];
524 
525         Migration memory mig = mntpMigrations[index];
526         return mig.migrated;
527     }
528 
529     function setMntpMigrated(address _who, bool _isMigrated, string _comment) public onlyCreator {
530         uint index = mntpMigrationIndexes[_who];
531         require(index > 0);
532 
533         mntpMigrations[index].migrated = _isMigrated;
534         mntpMigrations[index].comment = _comment;
535 
536         // send an event
537         if (_isMigrated) {
538              MntpMigrated(  mntpMigrations[index].ethAddress,
539                             mntpMigrations[index].gmAddress,
540                             mntpMigrations[index].tokensCount);
541         }
542     }
543 
544     // GOLD
545     function migrateGold(string _gmAddress) public {
546         require((state==State.MigrationStarted) || (state==State.MigrationFinished));
547 
548         // 1 - get balance
549         uint myBalance = goldToken.balanceOf(msg.sender);
550         require(0!=myBalance);
551 
552         // 2 - burn tokens
553         // WARNING: burn will reduce totalSupply
554         //
555         goldToken.burnTokens(msg.sender,myBalance);
556 
557         // save tuple
558         Migration memory mig;
559         mig.ethAddress = msg.sender;
560         mig.gmAddress = _gmAddress;
561         mig.tokensCount = myBalance;
562         mig.migrated = false;
563         mig.date = uint64(now);
564         mig.comment = '';
565 
566         goldMigrations[goldMigrationsCount + 1] = mig;
567         goldMigrationIndexes[msg.sender] = goldMigrationsCount + 1;
568         goldMigrationsCount++;
569 
570         // send an event
571         GoldMigrateWanted(msg.sender, _gmAddress, myBalance);
572     }
573 
574     function isGoldMigrated(address _who) public constant returns(bool) {
575         uint index = goldMigrationIndexes[_who];
576 
577         Migration memory mig = goldMigrations[index];
578         return mig.migrated;
579     }
580 
581     function setGoldMigrated(address _who, bool _isMigrated, string _comment) public onlyCreator {
582         uint index = goldMigrationIndexes[_who];
583         require(index > 0);
584 
585         goldMigrations[index].migrated = _isMigrated;
586         goldMigrations[index].comment = _comment;
587 
588         // send an event
589         if (_isMigrated) {
590              GoldMigrated(  goldMigrations[index].ethAddress,
591                             goldMigrations[index].gmAddress,
592                             goldMigrations[index].tokensCount);
593         }
594     }
595 
596     // Each MNTP token holder gets a GOLD reward as a percent of all rewards
597     // proportional to his MNTP token stake
598     function calculateMyRewardMax(address _of) public constant returns(uint){
599         if (0 == mntpToMigrateTotal) {
600              return 0;
601         }
602 
603         uint myCurrentMntpBalance = mntpToken.balanceOf(_of);
604         if (0 == myCurrentMntpBalance) {
605              return 0;
606         }
607 
608         return (migrationRewardTotal * myCurrentMntpBalance) / mntpToMigrateTotal;
609     }
610 
611     //emergency function. used in case of a mistake to transfer all the reward to a new migraiton smart contract.
612     function transferReward(address _newContractAddress) public onlyCreator {
613       goldToken.transferRewardWithoutFee(_newContractAddress, goldToken.balanceOf(this));
614     }
615 
616     // Migration rewards decreased linearly.
617     //
618     // The formula is: rewardPercents = max(100 - 100 * day / 365, 0)
619     //
620     // On 1st day of migration, you will get: 100 - 100 * 0/365 = 100% of your rewards
621     // On 2nd day of migration, you will get: 100 - 100 * 1/365 = 99.7261% of your rewards
622     // On 365th day of migration, you will get: 100 - 100 * 364/365 = 0.274%
623     function calculateMyRewardDecreased(uint _day, uint _myRewardMax) public constant returns(uint){
624         if (_day >= 365) {
625              return 0;
626         }
627 
628         uint x = ((100 * 1000000000 * _day) / 365);
629         return (_myRewardMax * ((100 * 1000000000) - x)) / (100 * 1000000000);
630     }
631 
632     function calculateMyReward(uint _myRewardMax) public constant returns(uint){
633         // day starts from 0
634         uint day = (uint64(now) - migrationStartedTime) / uint64(1 days);
635         return calculateMyRewardDecreased(day, _myRewardMax);
636     }
637 
638     // do not allow to send money to this contract...
639     function() external payable {
640         revert();
641     }
642 }