1 pragma solidity ^0.4.17;
2 
3 /// @title Manages special access privileges of BankCore.
4 /*** LoveBankAccessControl Contract adapted from CryptoKitty ***/
5 contract LoveBankAccessControl {
6 
7     // This facet controls access control for LoveBank. There are four roles managed here:
8     //
9     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
10     //         contracts. It is also the only role that can unpause the smart contract. It is initially
11     //         set to the address that created the smart contract in the BankCore constructor.
12     //
13     //     - The CFO: The CFO can withdraw funds from BankCore contract.
14     //
15     //     - The COO: The COO can set Free-Fee-Time.
16     //
17     // It should be noted that these roles are distinct without overlap in their access abilities, the
18     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
19     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
20     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
21     // convenience. The less we use an address, the less likely it is that we somehow compromise the
22     // account.
23 
24     /// @dev Emited when contract is upgraded
25     event ContractUpgrade(address newVerseContract);
26 
27     // The addresses of the accounts (or contracts) that can execute actions within each roles.
28     address public ceoAddress;
29     address public cfoAddress;
30     address public cooAddress;
31 
32     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
33     bool public paused=false;
34 
35     /// @dev Access modifier for CEO-only functionality
36     modifier onlyCEO() {
37         require(msg.sender == ceoAddress);
38         _;
39     }
40 
41     /// @dev Access modifier for CFO-only functionality
42     modifier onlyCFO() {
43         require(msg.sender == cfoAddress);
44         _;
45     }
46 
47     /// @dev Access modifier for COO-only functionality
48     modifier onlyCOO() {
49         require(msg.sender == cooAddress);
50         _;
51     }
52 
53     modifier onlyCLevel() {
54         require(
55             msg.sender == cooAddress ||
56             msg.sender == ceoAddress ||
57             msg.sender == cfoAddress
58         );
59         _;
60     }
61     
62     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
63     /// @param _newCEO is the address of the new CEO
64     function setCEO(address _newCEO) external onlyCEO {
65         require(_newCEO != address(0));
66         ceoAddress = _newCEO;
67     }
68 
69     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
70     /// @param _newCFO is the address of the new CFO
71     function setCFO(address _newCFO) external onlyCEO {
72         require(_newCFO != address(0));
73         cfoAddress = _newCFO;
74     }
75 
76     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
77     /// @param _newCOO is the address of the new COO
78     function setCOO(address _newCOO) external onlyCEO {
79         require(_newCOO != address(0));
80         cooAddress = _newCOO;
81     }
82     
83     /*** Pausable functionality adapted from OpenZeppelin ***/
84 
85     /// @dev Modifier to allow actions only when the contract IS NOT paused
86     modifier whenNotPaused() {
87         require(!paused);
88         _;
89     }
90 
91     /// @dev Modifier to allow actions only when the contract IS paused
92     modifier whenPaused() {
93         require(paused);
94         _;
95     }
96 
97     /// @dev Called by any "C-level" role to pause the contract. Used only when
98     ///  a bug or exploit is detected and we need to limit damage.
99     function pause() external onlyCLevel whenNotPaused {
100         paused = true;
101     }
102 
103     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
104     ///  one reason we may pause the contract is when CFO or COO accounts are
105     ///  compromised.
106     /// @notice This is public rather than external so it can be called by
107     ///  derived contracts.
108     function unpause() public onlyCEO whenPaused {
109         // can't unpause if contract was upgraded
110         paused = false;
111     }
112 }
113 
114 /// @title Love Account Base Contract for LoveBank. Holds all common structs, events and base 
115 ///  variables for love accounts.
116 /// @author Diana Kudrow <https://github.com/lovebankcrypto>
117 /// @dev Create new account by couple ,deposit or bless by all, withdraw with both sides' confirmation
118 
119 contract LoveAccountBase{
120 
121     // An individual new contrat is build whenever a new couple create a new love account through the 
122     // BankCore Contract. The love account contract plays seceral roles:
123     //
124     //     - Information Storage: owners names, wallet addresses, love-ID, their milestones in 
125     //        relationship, diary……
126     //
127     //     - Balance Storage: each account keep their deposit in seperate contrat for safety and 
128     //        privilege concern
129     //
130     //     - Access Control: only receive message from one of owners, triggered by bank for safety 
131     //        reason
132     //     
133     //     - Deposit/Bless(fallback), Withdraw, BreakUp, MileStone, Diary: 5 main function of our 
134     //        love bank
135 
136     /*** EVENTS ***/
137     
138     /// @dev The Deposit event is fired whenever a value>0 ether is transfered into loveaccount
139     event Deposit(address _from, uint _value);
140     
141     /*** DATA TYPES ***/
142     /// @dev choices of all account status and milestones
143     enum Status{BreakUp, Active, RequestPending, FirstMet,  //0-3
144         FirstKiss, FirstConfess, InRelationship,FirstDate, //4-7
145         Proposal, Engage, WeddingDay, Anniversary, Trip,  //8-12
146         NewFamilyMember, FirstSex, Birthday,             //13-15
147         special1, special2, special3                  // 16-18
148     }
149 
150     struct StonePage {
151     	uint64 logtime;
152     	Status contant;
153     }
154 
155     struct DiaryPage {
156     	uint64 logtime;
157     	bytes contant;
158     }
159 
160     /*** STORAGE ***/
161     
162     /// @dev Nicename of the FOUNDER of this love account
163     bytes32 public name1;
164 
165     /// @dev Nicename of the FOUNDER's lover
166     bytes32 public name2;
167 
168     /// @dev Address of the FOUNDER of this love account
169     address public owner1;
170 
171     /// @dev Address of the FOUNDER's lover
172     address public owner2;
173 
174     /// @dev contract address of Love Bank, for access control
175     address BANKACCOUNT;
176 
177     /// @dev Keep track of who is withdrawing money during double-sig pending time
178     address withdrawer;
179 
180     /// @dev Keep track of how much is withdrawing money during double-sig pending time
181     uint256 request_amount;
182 
183     /// @dev Keep track of service charge during double-sig pending time
184     uint256 request_fee;
185 
186     /// @dev One and unique LoveID of this account, smaller if sign up early
187     uint64 public loveID;
188 
189     /// @dev Time stamp of found moment
190     uint64 public foundTime=uint64(now);
191 
192     /// @dev diary index log, public
193     uint64 public next_diary_id=0;
194 
195     /// @dev milestone index log, public
196     uint64 public next_stone_id=0;
197 
198     /// @dev Status of the account: BreakUp, Active(defult), RequestPending
199     Status public status=Status.Active;
200     
201     /// @dev A mapping from timestamp to Status. Keep track of all Memory Moment for lovers
202     mapping (uint64=>StonePage) public milestone;
203 
204     /// @dev A mapping from timestamp to bytes. Lovers can keep whatever words on ethereum eternally
205     mapping (uint64=>DiaryPage) public diary;
206 
207     /// @dev Initiate love account when first found
208     function LoveAccountBase (
209         bytes32 _name1,
210         bytes32 _name2,
211         address _address1,
212         address _address2,
213         uint64 _loveID) public {
214             name1 = _name1;
215             name2 = _name2;
216             owner1 = _address1;
217             owner2 = _address2;
218             loveID = _loveID;
219             BANKACCOUNT = msg.sender;
220     }
221     /// @dev Modifier to allow actions only when the account is not Breakup
222     modifier notBreakup() {require(uint(status)!=0);_;}
223 
224     /// @dev Modifier to allow actions only when the call was sent by one of owners
225     modifier oneOfOwners(address _address) {
226         require (_address==owner1 || _address==owner2);_;
227     }
228 
229     /// @dev Modifier to allow actions only when message sender is Bank
230     modifier callByBank() {require(msg.sender == BANKACCOUNT);_;}
231     
232     /// @dev Rarely used! Only happen when extreme circumstances
233     function changeBankAccount(address newBank) external callByBank{
234         require(newBank!=address(0));
235         BANKACCOUNT = newBank;
236     }
237 
238     /// @dev THINK TWICE! If you breakup with your lover, all your balance will transfer to your
239     ///  lover's account, AND you cannot re-activate this very account! Think about your sweet
240     ///  moments before you hurt someone's heart!!
241     function breakup(
242         address _breaker, uint256 _fee) external payable 
243         notBreakup oneOfOwners(_breaker) callByBank{
244         if(_fee!=0){BankCore(BANKACCOUNT).receiveFee.value(_fee)();}
245         if(_breaker==owner1) {owner2.transfer(this.balance);}
246         if(_breaker==owner2) {owner1.transfer(this.balance);}
247         status=Status.BreakUp;
248     }
249     
250     /// @dev Log withdraw info when first receice request 
251     function withdraw(uint256 amount, 
252         address _to, uint256 _fee) external notBreakup oneOfOwners(_to) callByBank{
253         require(this.balance>=amount);
254         // change status to pending
255         status =Status.RequestPending;
256         request_amount = amount;
257         withdrawer = _to;
258         request_fee = _fee;
259     }
260 
261     /// @dev Confirm request and send money; erase info logs
262     function withdrawConfirm(
263         uint256 _amount, 
264         address _confirmer) external payable notBreakup oneOfOwners(_confirmer) callByBank{
265         // check for matching withdraw request
266         require(uint(status)==2);
267         require(_amount==request_amount);
268         require(_confirmer!=withdrawer);
269         require(this.balance>=request_amount);
270         
271         // send service fee to bank
272         if(request_fee!=0){BankCore(BANKACCOUNT).receiveFee.value(request_fee)();}
273         withdrawer.transfer(request_amount-request_fee);
274 
275         // clean pending log informations
276         status=Status.Active;
277         withdrawer=address(0);
278         request_amount=0;
279         request_fee=0;
280     }
281     
282     /// @dev Log big events(pre-set-choice) in relationship, time stamp is required
283     function mileStone(address _sender, uint64 _time, uint8 _choice) external notBreakup oneOfOwners(_sender) callByBank {
284         milestone[next_stone_id]=StonePage({
285         	logtime: _time,
286         	contant: Status(_choice)
287         });
288         next_stone_id++;
289     }
290 
291     /// @dev Log diary, time stamp is now
292     function Diary(address _sender, bytes _diary) external notBreakup oneOfOwners(_sender) callByBank {
293         diary[next_diary_id]=DiaryPage({
294         	logtime: uint64(now),
295         	contant: _diary
296         });
297         next_diary_id++;  
298     }
299     
300     // @dev Fallback function for deposit and blessing income
301     function() external payable notBreakup {
302         require(msg.value>0);
303         Deposit(msg.sender, msg.value);
304     }
305 }
306 
307 
308 /// @title Basic contract of LoveBank that defines the Creating, Saving, and Using of love 
309 /// accounts under the protect of one Bank contract.
310 /// @author Diana Kudrow <https://github.com/lovebankcrypto>
311 contract Bank is LoveBankAccessControl{
312 
313     /*** EVENTS ***/
314 
315     /// @dev Create event is fired whenever a new love account is created, and a new contract
316     ///  address is created 
317     event Create(bytes32 _name1, bytes32 _name2, address _conadd, 
318                 address _address1, address _address2, uint64 _loveID);
319     /// @dev Breakup event is fired when someone breakup with another
320     event Breakup(uint _time);
321     /// @dev StoneLog event returns when love account log a milestone
322     event StoneLog(uint _time, uint _choice);
323     /// @dev DiaryLog event returns when love account log a diary
324     event DiaryLog(uint _time, bytes _contant);
325     /// @dev Withdraw event returns when a user trigger a withdrow demand
326     event Withdraw(uint _amount, uint _endTime);
327     /// @dev WithdrawConfirm event returns when a withdraw demand is confirmed and accomplished
328     event WithdrawConfirm(uint _amount, uint _confirmTime);
329 
330     /*** DATA TYPES ***/
331     
332     struct pending {
333         bool pending;
334         address withdrawer;
335         uint256 amount;
336         uint256 fee;
337         uint64 endTime;
338     }
339 
340     /*** CONSTANTS ***/
341 
342     /// @dev constant variables
343     uint256 STONE_FEE=4000000000000000;
344     uint256 OPEN_FEE=20000000000000000;
345     uint64 FREE_START=0;
346     uint64 FREE_END=0;
347     uint64 WD_FEE_VERSE=100;  // 1% service fee
348     uint64 BU_FEE_VERSE=50;   // 2% service fee
349     uint32 public CONFIRM_LIMIT = 900; //15mins
350 
351     /*** STORAGE ***/
352 
353     /// @dev The ID of the next signing couple, also the number of current signed accounts
354     uint64 public next_id=0; 
355     /// @dev A mapping from owers addresses' sha256 to love account address
356     mapping (bytes16 => address)  public sig_to_add;
357     /// @dev A mapping from love account address to withdraw demand detail
358     mapping (address => pending) public pendingList;
359     
360     /// @dev Create a new love account and log in Bank
361     /// @param name1 is nicename of the FOUNDER of this love account
362     /// @param name2 is nicename of the FOUNDER's lover
363     /// @param address1 is address of the FOUNDER of this love account, need to be msg.sender
364     /// @param address2 is address of the FOUNDER's lover
365     function createAccount(
366         bytes32 name1,
367         bytes32 name2,
368         address address1,
369         address address2) external payable whenNotPaused {
370         uint fee;
371         // calculate open account service fee
372         if (_ifFree()){fee=0;} else{fee=OPEN_FEE;}
373         require(msg.sender==address1   &&
374                 address1!=address2     && 
375                 address1!=address(0)   &&
376                 address2!=address(0)   &&
377                 msg.value>=fee);
378         require(_ifFree() || msg.value >= OPEN_FEE);
379         // Same couple can only created love account once. Addresses' keccak256 is logged
380         bytes16 sig = bytes16(keccak256(address1))^bytes16(keccak256(address2));
381         require(sig_to_add[sig]==0);
382         // New contract created
383         address newContract = (new LoveAccountBase)(name1, name2, address1, address2, next_id);
384         sig_to_add[sig]=newContract;
385         Create(name1, name2, newContract, address1, address2, next_id);
386         // First deposit
387         if(msg.value>fee){
388             newContract.transfer(msg.value-fee);
389         }
390         next_id++;
391     }
392     
393     /// @dev Calculate service fee; to avoid ufixed data type, dev=(1/charge rate)
394     /// @param _dev is inverse of charging rate. If service fee is 1%, _dev=100
395     function _calculate(uint256 _amount, uint _dev) internal pure returns(uint256 _int){
396         _int = _amount/uint256(_dev);
397     }
398 
399     /// @dev If now is during service-free promotion, return true; else return false
400     function _ifFree() view internal returns(bool) {
401         if(uint64(now)<FREE_START || uint64(now)>FREE_END
402             ) {return false;
403         } else {return true;}
404     }
405 
406     /// @dev THINK TWICE! If you breakup with your lover, all your balance will transfer 
407     ///  to your lover's account, AND you cannot re-activate this very account! Think about 
408     ///  your sweet moments before you hurt someone's heart!!
409     /// @param _conadd is contract address of love account
410     function sendBreakup(address _conadd) external whenNotPaused {
411         if (_ifFree()){
412             // Call function in love account contract
413             LoveAccountBase(_conadd).breakup(msg.sender,0);}
414         else{
415             uint _balance = _conadd.balance;
416             uint _fee = _calculate(_balance, BU_FEE_VERSE);
417             // Call function in love account contract
418             LoveAccountBase(_conadd).breakup(msg.sender,_fee);}
419         Breakup(now);
420      }
421 
422     /// @dev Log big events(pre-set-choice) in relationship, time stamp is required
423     /// @param _conadd is contract address of love account
424     /// @param _time is time stamp of the time of event
425     /// @param _choice is uint of enum. See Love Account Base to understand how milestone work
426     function sendMileStone(
427         address _conadd, uint _time, 
428         uint _choice) external payable whenNotPaused {
429         require(msg.value >= STONE_FEE);
430         uint8 _choice8 = uint8(_choice);
431         require(_choice8>2 && _choice8<=18);
432         // Call function in love account contract
433         LoveAccountBase(_conadd).mileStone(msg.sender, uint64(_time), _choice8);
434         StoneLog(_time, _choice8);
435     }
436     
437     /// @dev Log diary, time stamp is now
438     /// @param _conadd is contract address of love account
439     function sendDiary(address _conadd, bytes _diary) external whenNotPaused{
440         LoveAccountBase(_conadd).Diary(msg.sender, _diary);
441         DiaryLog(now, _diary);
442     }
443     
444     /// @dev Log withdraw info when first receice request
445     /// @param _conadd is contract address of love account
446     /// @param _amount is the amount of money to withdraw in unit wei
447     function bankWithdraw(address _conadd, uint _amount) external whenNotPaused{
448         // Make sure no valid withdraw is pending
449         require(!pendingList[_conadd].pending || now>pendingList[_conadd].endTime);
450         uint256 _fee;
451         uint256 _amount256 = uint256(_amount); 
452         require(_amount256==_amount);
453 
454         // Fee calculation
455         if (_ifFree()){_fee=0;}else{_fee=_calculate(_amount, WD_FEE_VERSE);}
456 
457         // Call function in love account contract
458         LoveAccountBase _conA = LoveAccountBase(_conadd);
459         _conA.withdraw(_amount, msg.sender, _fee);
460 
461         // Log detail info for latter check
462         uint64 _end = uint64(now)+CONFIRM_LIMIT;
463         pendingList[_conadd] = pending({
464                     pending:true,
465                     withdrawer:msg.sender,
466                     amount: _amount256,
467                     fee:_fee,
468                     endTime: _end});
469         Withdraw(_amount256, _end);
470     }
471 
472     /// @dev Confirm request and send money; erase info logs
473     /// @param _conadd is contract address of love account 
474     /// @param _amount is the amount of money to withdraw in unit wei
475     function bankConfirm(address _conadd, uint _amount) external whenNotPaused{
476         // Confirm matching request
477         uint256 _amount256 = uint256(_amount); 
478         require(_amount256==_amount);
479         require(pendingList[_conadd].pending && now<pendingList[_conadd].endTime);
480         require(pendingList[_conadd].withdrawer != msg.sender);
481         require(pendingList[_conadd].amount == _amount);
482 
483         // Call function in love account contract
484         LoveAccountBase(_conadd).withdrawConfirm(_amount, msg.sender);
485 
486         // Clean pending information
487         delete pendingList[_conadd];
488         WithdrawConfirm(_amount, now);
489     }
490 }
491 
492 /// @title Promotion contract of LoveBank. 
493 /// @author Diana Kudrow <https://github.com/lovebankcrypto>
494 /// @dev All CLevel OPs, for promotion. CFO can define free-of-charge time, and CEO can lower the 
495 ///  service fee. (Yeah, we won't raise charge for sure, it's in the contrat!) 
496 contract LovePromo is Bank{
497 
498     /// @dev Withdraw your money for FREEEEEE! Or too if you wanna break up
499     /// @param _start is time stamp of free start time
500     /// @param _end is time stamp of free end time
501     function setFreeTime(uint _start, uint _end) external onlyCOO {
502         require(_end>=_start && _start>uint64(now));
503         FREE_START = uint64(_start);
504         FREE_END = uint64(_end);
505     }
506 
507 
508     /// @dev Set new charging rate
509     /// @param _withdrawFee is inverse of charging rate to avoid ufixed data type. 
510     ///  _withdrawFee=(1/x). If withdraw fee is 1%, _withdrawFee=100
511     /// @param _breakupFee is inverse of charging rate to avoid ufixed data type. 
512     ///  _breakupFee=(1/x). If breakup fee is 2%, _breakupFee=50
513     /// @param _stone is Milestone logging fee, wei (diary is free of charge, cost only gas)
514     /// @param _open is Open account fee, wei
515 
516     function setFee(
517         uint _withdrawFee, 
518         uint _breakupFee, 
519         uint _stone, 
520         uint _open) external onlyCEO {
521 
522         /// Service fee of withdraw NO HIGHER THAN 1%
523         require(_withdrawFee>=100);
524         /// Service fee of breakup NO HIGHER THAN 2%
525         require(_breakupFee>=50);
526 
527         WD_FEE_VERSE = uint64(_withdrawFee);
528         BU_FEE_VERSE = uint64(_breakupFee);
529         STONE_FEE = _stone;
530         OPEN_FEE = _open;
531     }
532 
533     /// @dev CEO might extend the confirm time limit when Etherum Network is blocked
534     /// @param _newlimit uses second as a unit
535     function setConfirm(uint _newlimit) external onlyCEO {
536         CONFIRM_LIMIT = uint32(_newlimit);
537     }
538 
539     /// @dev Just for checking
540     function getFreeTime() external view onlyCLevel returns(uint64 _start, uint64 _end){
541         _start = uint64(FREE_START);
542         _end = uint64(FREE_END);
543     }
544     
545     /// @dev Just for checking
546     function getFee() external view onlyCLevel returns(
547         uint64 _withdrawFee, 
548         uint64 _breakupFee, 
549         uint _stone, 
550         uint _open){
551 
552         _withdrawFee = WD_FEE_VERSE;
553         _breakupFee = BU_FEE_VERSE;
554         _stone = STONE_FEE;
555         _open = OPEN_FEE;
556     }
557 }
558 
559 /// @title Love Bank, a safe place for lovers to save money money for future and get bless from
560 ///  strangers and keep eternally on Etherum blockchain
561 /// @author Diana Kudrow <https://github.com/lovebankcrypto>
562 /// @dev The main LoveBank contract, keep track of all love accounts and their contracts, double
563 ///  security check before any operations
564 contract BankCore is LovePromo {
565 
566     // This is the main LoveBank contract. The function of our DApp is quite straight forward:
567     //  to create a account for couple, which is displayed on our website. Owers can put money in 
568     //  as well as strangers. Withdraw request can only be done with both owners permission.
569     //  In honor of eternal love, the party who puts forward a breakup will transfer all the remain
570     //  balance to the other party by default.
571     // 
572     //  To make the contract more logical, we simple seperate our contract in following parts:
573     //
574     //      - LoveBankAccessControl: This contract manages the various addresses and constraints for 
575     //             operations that can be executed only by specific roles. Namely CEO, CFO and COO.
576     //
577     //      - Bank is LoveBankAccessControl: In this contract we define the main stucture of our 
578     //              Love Bank and the methord to create accounts. Also, all the operations of users are
579     //              defined here, like money withdraw, breakup, diary, milestones. Lots of modifiers
580     //              are used to protect user's safety.
581     //
582     //      - LovePromo is Bank: Here are some simple operations for COO to set free-charge time and for CEO
583     //              to lower the charge rate.
584     //
585     //      - BankCore is LovePromo: inherit all previous contract. Contains all the big moves, like: 
586     //              creating a bank, set defult C-Level users, unpause, update (only when hugh bug happens),
587     //              withdraw money, etc.
588     //
589     //      - LoveAccountBase: This contract is the contract of a love account. Holds all common structs,
590     //              events and base variables for love accounts.
591 
592 
593     // Set in case the core contract is broken and an upgrade is required
594     address public newContractAddress;
595 
596     /// @dev DepositBank is fired when ether is received from CLevel to BankCore Contract
597     event DepositBank(address _sender, uint _value);
598 
599     function BankCore() public {
600         // Starts paused.
601         paused = true;
602         // the creator of the contract is the initial CEO
603         ceoAddress = msg.sender;
604         // the creator of the contract is also the initial COO
605         cooAddress = msg.sender;
606         // the creator of the contract is also the initial COO
607         cfoAddress = msg.sender;
608     }
609 
610     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
611     ///  breaking bug. This method does nothing but keep track of the new contract and
612     ///  emit a message indicating that the new address is set. It's up to clients of this
613     ///  contract to update to the new contract address in that case. (This contract will
614     ///  be paused indefinitely if such an upgrade takes place.)
615     /// @param _v2Address new address
616     /*** setNewAddress adapted from CryptoKitty ***/
617     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
618         newContractAddress = _v2Address;
619         ContractUpgrade(_v2Address);
620     }
621 
622     /// @dev Override unpause so it requires all external contract addresses
623     ///  to be set before contract can be unpaused. Also, we can't have
624     ///  newContractAddress set either, because then the contract was upgraded.
625     function unpause() public onlyCEO whenPaused {
626         require(newContractAddress == address(0));
627         // Actually unpause the contract.
628         super.unpause();
629     }
630     
631     /// @dev Rarely used! Only happen when extreme circumstances
632     /// @param _conadd is contract address of love account
633     /// @param newBank is newBank contract addess if updated
634     function changeBank(address _conadd, address newBank) external whenPaused onlyCEO{
635         require(newBank != address(0));
636         LoveAccountBase(_conadd).changeBankAccount(newBank);
637     }
638 
639     /// @dev Allows the CFO to capture the balance of Bank contract
640     function withdrawBalance() external onlyCFO {
641         // Subtract all the currently pregnant kittens we have, plus 1 of margin.
642         if (this.balance > 0) {
643             cfoAddress.transfer(this.balance);
644         }
645     }
646     
647     /// @dev Get Love account contrat address through Bank contract index
648     function getContract(address _add1, address _add2) external view returns(address){
649         bytes16 _sig = bytes16(keccak256(_add1))^bytes16(keccak256(_add2));
650         return sig_to_add[_sig];
651     }
652     
653     /// @dev Receive service fee from sub contracts
654     function receiveFee() external payable{}
655     
656     /// @dev Reject all deposit from outside CLevel accounts
657     function() external payable onlyCLevel {
658         require(msg.value>0);
659         DepositBank(msg.sender, msg.value);
660     }
661 }