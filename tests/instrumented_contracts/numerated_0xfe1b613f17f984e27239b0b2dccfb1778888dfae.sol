1 pragma solidity ^0.4.23;
2 
3 /******* USING Registry **************************
4 
5 Gives the inherting contract access to:
6     .addressOf(bytes32): returns current address mapped to the name.
7     [modifier] .fromOwner(): requires the sender is owner.
8 
9 *************************************************/
10 // Returned by .getRegistry()
11 interface IRegistry {
12     function owner() external view returns (address _addr);
13     function addressOf(bytes32 _name) external view returns (address _addr);
14 }
15 
16 contract UsingRegistry {
17     IRegistry private registry;
18 
19     modifier fromOwner(){
20         require(msg.sender == getOwner());
21         _;
22     }
23 
24     constructor(address _registry)
25         public
26     {
27         require(_registry != 0);
28         registry = IRegistry(_registry);
29     }
30 
31     function addressOf(bytes32 _name)
32         internal
33         view
34         returns(address _addr)
35     {
36         return registry.addressOf(_name);
37     }
38 
39     function getOwner()
40         public
41         view
42         returns (address _addr)
43     {
44         return registry.owner();
45     }
46 
47     function getRegistry()
48         public
49         view
50         returns (IRegistry _addr)
51     {
52         return registry;
53     }
54 }
55 
56 /**
57     This is a simple class that maintains a doubly linked list of
58     address => uint amounts. Address balances can be added to 
59     or removed from via add() and subtract(). All balances can
60     be obtain by calling balances(). If an address has a 0 amount,
61     it is removed from the Ledger.
62 
63     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
64           use to track Ether balances.
65 
66     Public methods:
67       - [fromOwner] add()
68       - [fromOwner] subtract()
69     Public views:
70       - total()
71       - size()
72       - balanceOf()
73       - balances()
74       - entries() [to manually iterate]
75 */
76 contract Ledger {
77     uint public total;      // Total amount in Ledger
78 
79     struct Entry {          // Doubly linked list tracks amount per address
80         uint balance;
81         address next;
82         address prev;
83     }
84     mapping (address => Entry) public entries;
85 
86     address public owner;
87     modifier fromOwner() { require(msg.sender==owner); _; }
88 
89     // Constructor sets the owner
90     constructor(address _owner)
91         public
92     {
93         owner = _owner;
94     }
95 
96 
97     /******************************************************/
98     /*************** OWNER METHODS ************************/
99     /******************************************************/
100 
101     function add(address _address, uint _amt)
102         fromOwner
103         public
104     {
105         if (_address == address(0) || _amt == 0) return;
106         Entry storage entry = entries[_address];
107 
108         // If new entry, replace first entry with this one.
109         if (entry.balance == 0) {
110             entry.next = entries[0x0].next;
111             entries[entries[0x0].next].prev = _address;
112             entries[0x0].next = _address;
113         }
114         // Update stats.
115         total += _amt;
116         entry.balance += _amt;
117     }
118 
119     function subtract(address _address, uint _amt)
120         fromOwner
121         public
122         returns (uint _amtRemoved)
123     {
124         if (_address == address(0) || _amt == 0) return;
125         Entry storage entry = entries[_address];
126 
127         uint _maxAmt = entry.balance;
128         if (_maxAmt == 0) return;
129         
130         if (_amt >= _maxAmt) {
131             // Subtract the max amount, and delete entry.
132             total -= _maxAmt;
133             entries[entry.prev].next = entry.next;
134             entries[entry.next].prev = entry.prev;
135             delete entries[_address];
136             return _maxAmt;
137         } else {
138             // Subtract the amount from entry.
139             total -= _amt;
140             entry.balance -= _amt;
141             return _amt;
142         }
143     }
144 
145 
146     /******************************************************/
147     /*************** PUBLIC VIEWS *************************/
148     /******************************************************/
149 
150     function size()
151         public
152         view
153         returns (uint _size)
154     {
155         // Loop once to get the total count.
156         Entry memory _curEntry = entries[0x0];
157         while (_curEntry.next > 0) {
158             _curEntry = entries[_curEntry.next];
159             _size++;
160         }
161         return _size;
162     }
163 
164     function balanceOf(address _address)
165         public
166         view
167         returns (uint _balance)
168     {
169         return entries[_address].balance;
170     }
171 
172     function balances()
173         public
174         view
175         returns (address[] _addresses, uint[] _balances)
176     {
177         // Populate names and addresses
178         uint _size = size();
179         _addresses = new address[](_size);
180         _balances = new uint[](_size);
181         uint _i = 0;
182         Entry memory _curEntry = entries[0x0];
183         while (_curEntry.next > 0) {
184             _addresses[_i] = _curEntry.next;
185             _balances[_i] = entries[_curEntry.next].balance;
186             _curEntry = entries[_curEntry.next];
187             _i++;
188         }
189         return (_addresses, _balances);
190     }
191 }
192 
193 /**
194     This is a simple class that maintains a doubly linked list of
195     addresses it has seen. Addresses can be added and removed
196     from the set, and a full list of addresses can be obtained.
197 
198     Methods:
199      - [fromOwner] .add()
200      - [fromOwner] .remove()
201     Views:
202      - .size()
203      - .has()
204      - .addresses()
205 */
206 contract AddressSet {
207     
208     struct Entry {  // Doubly linked list
209         bool exists;
210         address next;
211         address prev;
212     }
213     mapping (address => Entry) public entries;
214 
215     address public owner;
216     modifier fromOwner() { require(msg.sender==owner); _; }
217 
218     // Constructor sets the owner.
219     constructor(address _owner)
220         public
221     {
222         owner = _owner;
223     }
224 
225 
226     /******************************************************/
227     /*************** OWNER METHODS ************************/
228     /******************************************************/
229 
230     function add(address _address)
231         fromOwner
232         public
233         returns (bool _didCreate)
234     {
235         // Do not allow the adding of HEAD.
236         if (_address == address(0)) return;
237         Entry storage entry = entries[_address];
238         // If already exists, do nothing. Otherwise set it.
239         if (entry.exists) return;
240         else entry.exists = true;
241 
242         // Replace first entry with this one.
243         // Before: HEAD <-> X <-> Y
244         // After: HEAD <-> THIS <-> X <-> Y
245         // do: THIS.NEXT = [0].next; [0].next.prev = THIS; [0].next = THIS; THIS.prev = 0;
246         Entry storage HEAD = entries[0x0];
247         entry.next = HEAD.next;
248         entries[HEAD.next].prev = _address;
249         HEAD.next = _address;
250         return true;
251     }
252 
253     function remove(address _address)
254         fromOwner
255         public
256         returns (bool _didExist)
257     {
258         // Do not allow the removal of HEAD.
259         if (_address == address(0)) return;
260         Entry storage entry = entries[_address];
261         // If it doesn't exist already, there is nothing to do.
262         if (!entry.exists) return;
263 
264         // Stitch together next and prev, delete entry.
265         // Before: X <-> THIS <-> Y
266         // After: X <-> Y
267         // do: THIS.next.prev = this.prev; THIS.prev.next = THIS.next;
268         entries[entry.prev].next = entry.next;
269         entries[entry.next].prev = entry.prev;
270         delete entries[_address];
271         return true;
272     }
273 
274 
275     /******************************************************/
276     /*************** PUBLIC VIEWS *************************/
277     /******************************************************/
278 
279     function size()
280         public
281         view
282         returns (uint _size)
283     {
284         // Loop once to get the total count.
285         Entry memory _curEntry = entries[0x0];
286         while (_curEntry.next > 0) {
287             _curEntry = entries[_curEntry.next];
288             _size++;
289         }
290         return _size;
291     }
292 
293     function has(address _address)
294         public
295         view
296         returns (bool _exists)
297     {
298         return entries[_address].exists;
299     }
300 
301     function addresses()
302         public
303         view
304         returns (address[] _addresses)
305     {
306         // Populate names and addresses
307         uint _size = size();
308         _addresses = new address[](_size);
309         // Iterate forward through all entries until the end.
310         uint _i = 0;
311         Entry memory _curEntry = entries[0x0];
312         while (_curEntry.next > 0) {
313             _addresses[_i] = _curEntry.next;
314             _curEntry = entries[_curEntry.next];
315             _i++;
316         }
317         return _addresses;
318     }
319 }
320 
321 /******* USING TREASURY **************************
322 
323 Gives the inherting contract access to:
324     .getTreasury(): returns current ITreasury instance
325     [modifier] .fromTreasury(): requires the sender is current Treasury
326 
327 *************************************************/
328 // Returned by .getTreasury()
329 interface ITreasury {
330     function issueDividend() external returns (uint _profits);
331     function profitsSendable() external view returns (uint _profits);
332 }
333 
334 contract UsingTreasury is
335     UsingRegistry
336 {
337     constructor(address _registry)
338         UsingRegistry(_registry)
339         public
340     {}
341 
342     modifier fromTreasury(){
343         require(msg.sender == address(getTreasury()));
344         _;
345     }
346     
347     function getTreasury()
348         public
349         view
350         returns (ITreasury)
351     {
352         return ITreasury(addressOf("TREASURY"));
353     }
354 }
355 
356 
357 /**
358   A simple class that manages bankroll, and maintains collateral.
359   This class only ever sends profits the Treasury. No exceptions.
360 
361   - Anybody can add funding (according to whitelist)
362   - Anybody can tell profits (balance - (funding + collateral)) to go to Treasury.
363   - Anyone can remove their funding, so long as balance >= collateral.
364   - Whitelist is managed by getWhitelistOwner() -- typically Admin.
365 
366   Exposes the following:
367     Public Methods
368      - addBankroll
369      - removeBankroll
370      - sendProfits
371     Public Views
372      - getCollateral
373      - profits
374      - profitsSent
375      - profitsTotal
376      - bankroll
377      - bankrollAvailable
378      - bankrolledBy
379      - bankrollerTable
380 */
381 contract Bankrollable is
382     UsingTreasury
383 {   
384     // How much profits have been sent. 
385     uint public profitsSent;
386     // Ledger keeps track of who has bankrolled us, and for how much
387     Ledger public ledger;
388     // This is a copy of ledger.total(), to save gas in .bankrollAvailable()
389     uint public bankroll;
390     // This is the whitelist of who can call .addBankroll()
391     AddressSet public whitelist;
392 
393     modifier fromWhitelistOwner(){
394         require(msg.sender == getWhitelistOwner());
395         _;
396     }
397 
398     event BankrollAdded(uint time, address indexed bankroller, uint amount, uint bankroll);
399     event BankrollRemoved(uint time, address indexed bankroller, uint amount, uint bankroll);
400     event ProfitsSent(uint time, address indexed treasury, uint amount);
401     event AddedToWhitelist(uint time, address indexed addr, address indexed wlOwner);
402     event RemovedFromWhitelist(uint time, address indexed addr, address indexed wlOwner);
403 
404     // Constructor creates the ledger and whitelist, with self as owner.
405     constructor(address _registry)
406         UsingTreasury(_registry)
407         public
408     {
409         ledger = new Ledger(this);
410         whitelist = new AddressSet(this);
411     }
412 
413 
414     /*****************************************************/
415     /************** WHITELIST MGMT ***********************/
416     /*****************************************************/    
417 
418     function addToWhitelist(address _addr)
419         fromWhitelistOwner
420         public
421     {
422         bool _didAdd = whitelist.add(_addr);
423         if (_didAdd) emit AddedToWhitelist(now, _addr, msg.sender);
424     }
425 
426     function removeFromWhitelist(address _addr)
427         fromWhitelistOwner
428         public
429     {
430         bool _didRemove = whitelist.remove(_addr);
431         if (_didRemove) emit RemovedFromWhitelist(now, _addr, msg.sender);
432     }
433 
434     /*****************************************************/
435     /************** PUBLIC FUNCTIONS *********************/
436     /*****************************************************/
437 
438     // Bankrollable contracts should be payable (to receive revenue)
439     function () public payable {}
440 
441     // Increase funding by whatever value is sent
442     function addBankroll()
443         public
444         payable 
445     {
446         require(whitelist.size()==0 || whitelist.has(msg.sender));
447         ledger.add(msg.sender, msg.value);
448         bankroll = ledger.total();
449         emit BankrollAdded(now, msg.sender, msg.value, bankroll);
450     }
451 
452     // Removes up to _amount from Ledger, and sends it to msg.sender._callbackFn
453     function removeBankroll(uint _amount, string _callbackFn)
454         public
455         returns (uint _recalled)
456     {
457         // cap amount at the balance minus collateral, or nothing at all.
458         address _bankroller = msg.sender;
459         uint _collateral = getCollateral();
460         uint _balance = address(this).balance;
461         uint _available = _balance > _collateral ? _balance - _collateral : 0;
462         if (_amount > _available) _amount = _available;
463 
464         // Try to remove _amount from ledger, get actual _amount removed.
465         _amount = ledger.subtract(_bankroller, _amount);
466         bankroll = ledger.total();
467         if (_amount == 0) return;
468 
469         bytes4 _sig = bytes4(keccak256(_callbackFn));
470         require(_bankroller.call.value(_amount)(_sig));
471         emit BankrollRemoved(now, _bankroller, _amount, bankroll);
472         return _amount;
473     }
474 
475     // Send any excess profits to treasury.
476     function sendProfits()
477         public
478         returns (uint _profits)
479     {
480         int _p = profits();
481         if (_p <= 0) return;
482         _profits = uint(_p);
483         profitsSent += _profits;
484         // Send profits to Treasury
485         address _tr = getTreasury();
486         require(_tr.call.value(_profits)());
487         emit ProfitsSent(now, _tr, _profits);
488     }
489 
490 
491     /*****************************************************/
492     /************** PUBLIC VIEWS *************************/
493     /*****************************************************/
494 
495     // Function must be overridden by inheritors to ensure collateral is kept.
496     function getCollateral()
497         public
498         view
499         returns (uint _amount);
500 
501     // Function must be overridden by inheritors to enable whitelist control.
502     function getWhitelistOwner()
503         public
504         view
505         returns (address _addr);
506 
507     // Profits are the difference between balance and threshold
508     function profits()
509         public
510         view
511         returns (int _profits)
512     {
513         int _balance = int(address(this).balance);
514         int _threshold = int(bankroll + getCollateral());
515         return _balance - _threshold;
516     }
517 
518     // How profitable this contract is, overall
519     function profitsTotal()
520         public
521         view
522         returns (int _profits)
523     {
524         return int(profitsSent) + profits();
525     }
526 
527     // Returns the amount that can currently be bankrolled.
528     //   - 0 if balance < collateral
529     //   - If profits: full bankroll
530     //   - If no profits: remaning bankroll: balance - collateral
531     function bankrollAvailable()
532         public
533         view
534         returns (uint _amount)
535     {
536         uint _balance = address(this).balance;
537         uint _bankroll = bankroll;
538         uint _collat = getCollateral();
539         // Balance is below collateral!
540         if (_balance <= _collat) return 0;
541         // No profits, but we have a balance over collateral.
542         else if (_balance < _collat + _bankroll) return _balance - _collat;
543         // Profits. Return only _bankroll
544         else return _bankroll;
545     }
546 
547     function bankrolledBy(address _addr)
548         public
549         view
550         returns (uint _amount)
551     {
552         return ledger.balanceOf(_addr);
553     }
554 
555     function bankrollerTable()
556         public
557         view
558         returns (address[], uint[])
559     {
560         return ledger.balances();
561     }
562 }
563 
564 
565 
566 
567 /******* USING ADMIN ***********************
568 
569 Gives the inherting contract access to:
570     .getAdmin(): returns the current address of the admin
571     [modifier] .fromAdmin: requires the sender is the admin
572 
573 *************************************************/
574 contract UsingAdmin is
575     UsingRegistry
576 {
577     constructor(address _registry)
578         UsingRegistry(_registry)
579         public
580     {}
581 
582     modifier fromAdmin(){
583         require(msg.sender == getAdmin());
584         _;
585     }
586     
587     function getAdmin()
588         public
589         constant
590         returns (address _addr)
591     {
592         return addressOf("ADMIN");
593     }
594 }
595 
596 /*********************************************************
597 *********************** INSTADICE ************************
598 **********************************************************
599 
600 This contract allows for users to wager a limited amount on then
601 outcome of a random roll between [1, 100]. The user may choose
602 a number, and if the roll is less than or equal to that number,
603 they will win a payout that is inversely proportional to the
604 number they chose (lower numbers pay out more).
605 
606 When a roll is "finalized", it means the result was determined
607 and the payout paid to the user if they won. Each time somebody 
608 rolls, their previous roll is finalized. Roll results are based
609 on blockhash, and since only the last 256 blockhashes are 
610 available (who knows why it is so limited...), the user must
611 finalize within 256 blocks or their roll loses.
612 
613 Note about randomness:
614   Although using blockhash for randomness is not advised,
615   it is perfectly acceptable if the results of the block
616   are not worth an expected value greater than that of:
617     (full block reward - uncle block reward) = ~.625 Eth
618 
619   In other words, a miner is better of mining honestly and
620   getting a full block reward than trying to game this contract,
621   unless the maximum bet is increased to about .625, which
622   this contract forbids.
623 */
624 contract InstaDice is
625     Bankrollable,
626     UsingAdmin
627 {
628     struct User {
629         uint32 id;
630         uint32 r_id;
631         uint32 r_block;
632         uint8 r_number;
633         uint72 r_payout;
634     }
635 
636     // These stats are updated on each roll.
637     struct Stats {
638         uint32 numUsers;
639         uint32 numRolls;
640         uint96 totalWagered;
641         uint96 totalWon;
642     }
643     
644     // Admin controlled settings
645     struct Settings {
646         uint64 minBet;    //
647         uint64 maxBet;    // 
648         uint8 minNumber;  // they get ~20x their bet
649         uint8 maxNumber;  // they get ~1.01x their bet
650         uint16 feeBips;   // each bip is .01%, eg: 100 = 1% fee.
651     }
652 
653     mapping (address => User) public users;
654     Stats stats;
655     Settings settings;
656     uint8 constant public version = 1;
657     
658     // Admin events
659     event Created(uint time);
660     event SettingsChanged(uint time, address indexed admin);
661 
662     // Events
663     event RollWagered(uint time, uint32 indexed id, address indexed user, uint bet, uint8 number, uint payout);
664     event RollRefunded(uint time, address indexed user, string msg, uint bet, uint8 number);
665     event RollFinalized(uint time, uint32 indexed id, address indexed user, uint8 result, uint payout);
666     event PayoutError(uint time, string msg);
667 
668     constructor(address _registry)
669         Bankrollable(_registry)
670         UsingAdmin(_registry)
671         public
672     {
673         stats.totalWagered = 1;  // initialize to 1 to make first roll cheaper.
674         settings.maxBet = .3 ether;
675         settings.minBet = .001 ether;
676         settings.minNumber = 5;
677         settings.maxNumber = 98;
678         settings.feeBips = 100;
679         emit Created(now);
680     }
681 
682 
683     ///////////////////////////////////////////////////
684     ////// ADMIN FUNCTIONS ////////////////////////////
685     ///////////////////////////////////////////////////
686 
687     // Changes the settings
688     function changeSettings(
689         uint64 _minBet,
690         uint64 _maxBet,
691         uint8 _minNumber,
692         uint8 _maxNumber,
693         uint16 _feeBips
694     )
695         public
696         fromAdmin
697     {
698         require(_minBet <= _maxBet);    // makes sense
699         require(_maxBet <= .625 ether); // capped at (block reward - uncle reward)
700         require(_minNumber >= 1);       // not advisible, but why not
701         require(_maxNumber <= 99);      // over 100 makes no sense
702         require(_feeBips <= 500);       // max of 5%
703         settings.minBet = _minBet;
704         settings.maxBet = _maxBet;
705         settings.minNumber = _minNumber;
706         settings.maxNumber = _maxNumber;
707         settings.feeBips = _feeBips;
708         emit SettingsChanged(now, msg.sender);
709     }
710     
711 
712     ///////////////////////////////////////////////////
713     ////// PUBLIC FUNCTIONS ///////////////////////////
714     ///////////////////////////////////////////////////
715 
716     // Resolves the last roll for the user.
717     // Then creates a new roll.
718     // Gas:
719     //    Total: 56k (new), or up to 44k (repeat)
720     //    Overhead: 36k
721     //       22k: tx overhead
722     //        2k: SLOAD
723     //        3k: execution
724     //        2k: curMaxBet()
725     //        5k: update stats
726     //        2k: RollWagered event
727     //    New User: 20k
728     //       20k: create user
729     //    Repeat User: 8k, 16k
730     //        5k: update user
731     //        3k: RollFinalized event
732     //        8k: pay last roll
733     function roll(uint8 _number)
734         public
735         payable
736         returns (bool _success)
737     {
738         // Ensure bet and number are valid.
739         if (!_validateBetOrRefund(_number)) return;
740 
741         // Ensure one bet per block.
742         User memory _user = users[msg.sender];
743         if (_user.r_block == uint32(block.number)){
744             _errorAndRefund("Only one bet per block allowed.", msg.value, _number);
745             return false;
746         }
747         // Finalize last roll, if there is one.
748         Stats memory _stats = stats;
749         if (_user.r_block != 0) _finalizePreviousRoll(_user, _stats);
750 
751         // Compute new stats data
752         _stats.numUsers = _user.id == 0 ? _stats.numUsers + 1 : _stats.numUsers;
753         _stats.numRolls = stats.numRolls + 1;
754         _stats.totalWagered = stats.totalWagered + uint96(msg.value);
755         stats = _stats;
756 
757         // Compute new user data
758         _user.id = _user.id == 0 ? _stats.numUsers : _user.id;
759         _user.r_id = _stats.numRolls;
760         _user.r_block = uint32(block.number);
761         _user.r_number = _number;
762         _user.r_payout = computePayout(msg.value, _number);
763         users[msg.sender] = _user;
764 
765         // Save user in one write.
766         emit RollWagered(now, _user.r_id, msg.sender, msg.value, _user.r_number, _user.r_payout);
767         return true;
768     }
769 
770     // Finalizes the previous roll and pays out user if they won.
771     // Gas: 45k
772     //   21k: tx overhead
773     //    1k: SLOADs
774     //    2k: execution
775     //    8k: send winnings
776     //    5k: update user
777     //    5k: update stats
778     //    3k: RollFinalized event
779     function payoutPreviousRoll()
780         public
781         returns (bool _success)
782     {
783         // Load last roll in one SLOAD.
784         User storage _user = users[msg.sender];
785         // Error if on same block.
786         if (_user.r_block == uint32(block.number)){
787             emit PayoutError(now, "Cannot payout roll on the same block");
788             return false;
789         }
790         // Error if nothing to payout.
791         if (_user.r_block == 0){
792             emit PayoutError(now, "No roll to pay out.");
793             return false;
794         }
795 
796         // Finalize previous roll (this may update stats)
797         Stats memory _stats = stats;
798         _finalizePreviousRoll(_user, _stats);
799 
800         // Clear last roll, update stats
801         _user.r_id = 0;
802         _user.r_block = 0;
803         _user.r_number = 0;
804         _user.r_payout = 0;
805         stats.totalWon = _stats.totalWon;
806         return true;
807     }
808 
809 
810     ////////////////////////////////////////////////////////
811     ////// PRIVATE FUNCTIONS ///////////////////////////////
812     ////////////////////////////////////////////////////////
813 
814     // Validates the bet, or refunds the user.
815     function _validateBetOrRefund(uint8 _number)
816         private
817         returns (bool _isValid)
818     {
819         Settings memory _settings = settings;
820         if (_number < _settings.minNumber) {
821             _errorAndRefund("Roll number too small.", msg.value, _number);
822             return false;
823         }
824         if (_number > _settings.maxNumber){
825             _errorAndRefund("Roll number too large.", msg.value, _number);
826             return false;
827         }
828         if (msg.value < _settings.minBet){
829             _errorAndRefund("Bet too small.", msg.value, _number);
830             return false;
831         }
832         if (msg.value > _settings.maxBet){
833             _errorAndRefund("Bet too large.", msg.value, _number);
834             return false;
835         }
836         if (msg.value > curMaxBet()){
837             _errorAndRefund("May be unable to payout on a win.", msg.value, _number);
838             return false;
839         }
840         return true;
841     }
842 
843     // Finalizes the previous roll for the _user.
844     // There must be a previous roll, or this throws.
845     // Returns true, unless user wins and we couldn't pay.
846     function _finalizePreviousRoll(User memory _user, Stats memory _stats)
847         private
848     {
849         assert(_user.r_block != uint32(block.number));
850         assert(_user.r_block != 0);
851         
852         // compute result and isWinner
853         uint8 _result = computeResult(_user.r_block, _user.r_id);
854         bool _isWinner = _result <= _user.r_number;
855         if (_isWinner) {
856             require(msg.sender.call.value(_user.r_payout)());
857             _stats.totalWon += _user.r_payout;
858         }
859         // they won and we paid, or they lost. roll is finalized.
860         emit RollFinalized(now, _user.r_id, msg.sender, _result, _isWinner ? _user.r_payout : 0);
861     }
862 
863     // Only called from above.
864     // Refunds user the full value, and logs an error
865     function _errorAndRefund(string _msg, uint _bet, uint8 _number)
866         private
867     {
868         require(msg.sender.call.value(msg.value)());
869         emit RollRefunded(now, msg.sender, _msg, _bet, _number);
870     }
871 
872 
873     ///////////////////////////////////////////////////
874     ////// PUBLIC VIEWS ///////////////////////////////
875     ///////////////////////////////////////////////////
876 
877     // IMPLEMENTS: Bankrollable.getCollateral()
878     // This contract has no collateral, as it pays out in near realtime.
879     function getCollateral() public view returns (uint _amount) {
880         return 0;
881     }
882 
883     // IMPLEMENTS: Bankrollable.getWhitelistOwner()
884     // Ensures contract always has at least bankroll + totalCredits.
885     function getWhitelistOwner() public view returns (address _wlOwner)
886     {
887         return getAdmin();
888     }
889 
890     // Returns the largest bet such that we could pay out 10 maximum wins.
891     // The likelihood that 10 maximum bets (with highest payouts) are won
892     //  within a short period of time are extremely low.
893     function curMaxBet() public view returns (uint _amount) {
894         // Return largest bet such that 10*bet*payout = bankrollable()
895         uint _maxPayout = 10 * 100 / uint(settings.minNumber);
896         return bankrollAvailable() / _maxPayout;
897     }
898 
899     // Return the less of settings.maxBet and curMaxBet()
900     function effectiveMaxBet() public view returns (uint _amount) {
901         uint _curMax = curMaxBet();
902         return _curMax > settings.maxBet ? settings.maxBet : _curMax;
903     }
904 
905     // Computes the payout amount for the current _feeBips
906     function computePayout(uint _bet, uint _number)
907         public
908         view
909         returns (uint72 _wei)
910     {
911         uint _feeBips = settings.feeBips;   // Cast to uint, makes below math cheaper.
912         uint _bigBet = _bet * 1e32;         // Will not overflow unless _bet >> ~1e40
913         uint _bigPayout = (_bigBet * 100) / _number;
914         uint _bigFee = (_bigPayout * _feeBips) / 10000;
915         return uint72( (_bigPayout - _bigFee) / 1e32 );
916     }
917 
918     // Returns a number between 1 and 100 (inclusive)
919     // If blockNumber is too far past, returns 101.
920     function computeResult(uint32 _blockNumber, uint32 _id)
921         public
922         view
923         returns (uint8 _result)
924     {
925         bytes32 _blockHash = blockhash(_blockNumber);
926         if (_blockHash == 0) { return 101; }
927         return uint8(uint(keccak256(_blockHash, _id)) % 100 + 1);
928     }
929 
930     // Expose all Stats /////////////////////////////////
931     function numUsers() public view returns (uint32) {
932         return stats.numUsers;
933     }
934     function numRolls() public view returns (uint32) {
935         return stats.numRolls;
936     }
937     function totalWagered() public view returns (uint) {
938         return stats.totalWagered;
939     }
940     function totalWon() public view returns (uint) {
941         return stats.totalWon;
942     }
943     //////////////////////////////////////////////////////
944 
945     // Expose all Settings ///////////////////////////////
946     function minBet() public view returns (uint) {
947         return settings.minBet;
948     }
949     function maxBet() public view returns (uint) {
950         return settings.maxBet;
951     }
952     function minNumber() public view returns (uint8) {
953         return settings.minNumber;
954     }
955     function maxNumber() public view returns (uint8) {
956         return settings.maxNumber;
957     }
958     function feeBips() public view returns (uint16) {
959         return settings.feeBips;
960     }
961     //////////////////////////////////////////////////////
962 
963 }