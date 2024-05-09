1 pragma solidity ^0.4.23;
2 
3 /******* https://www.pennyether.com **************/
4 
5 /******* USING Registry **************************
6 
7 Gives the inherting contract access to:
8     .addressOf(bytes32): returns current address mapped to the name.
9     [modifier] .fromOwner(): requires the sender is owner.
10 
11 *************************************************/
12 // Returned by .getRegistry()
13 interface IRegistry {
14     function owner() external view returns (address _addr);
15     function addressOf(bytes32 _name) external view returns (address _addr);
16 }
17 
18 contract UsingRegistry {
19     IRegistry private registry;
20 
21     modifier fromOwner(){
22         require(msg.sender == getOwner());
23         _;
24     }
25 
26     constructor(address _registry)
27         public
28     {
29         require(_registry != 0);
30         registry = IRegistry(_registry);
31     }
32 
33     function addressOf(bytes32 _name)
34         internal
35         view
36         returns(address _addr)
37     {
38         return registry.addressOf(_name);
39     }
40 
41     function getOwner()
42         public
43         view
44         returns (address _addr)
45     {
46         return registry.owner();
47     }
48 
49     function getRegistry()
50         public
51         view
52         returns (IRegistry _addr)
53     {
54         return registry;
55     }
56 }
57 
58 /**
59     This is a simple class that maintains a doubly linked list of
60     address => uint amounts. Address balances can be added to 
61     or removed from via add() and subtract(). All balances can
62     be obtain by calling balances(). If an address has a 0 amount,
63     it is removed from the Ledger.
64 
65     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
66           use to track Ether balances.
67 
68     Public methods:
69       - [fromOwner] add()
70       - [fromOwner] subtract()
71     Public views:
72       - total()
73       - size()
74       - balanceOf()
75       - balances()
76       - entries() [to manually iterate]
77 */
78 contract Ledger {
79     uint public total;      // Total amount in Ledger
80 
81     struct Entry {          // Doubly linked list tracks amount per address
82         uint balance;
83         address next;
84         address prev;
85     }
86     mapping (address => Entry) public entries;
87 
88     address public owner;
89     modifier fromOwner() { require(msg.sender==owner); _; }
90 
91     // Constructor sets the owner
92     constructor(address _owner)
93         public
94     {
95         owner = _owner;
96     }
97 
98 
99     /******************************************************/
100     /*************** OWNER METHODS ************************/
101     /******************************************************/
102 
103     function add(address _address, uint _amt)
104         fromOwner
105         public
106     {
107         if (_address == address(0) || _amt == 0) return;
108         Entry storage entry = entries[_address];
109 
110         // If new entry, replace first entry with this one.
111         if (entry.balance == 0) {
112             entry.next = entries[0x0].next;
113             entries[entries[0x0].next].prev = _address;
114             entries[0x0].next = _address;
115         }
116         // Update stats.
117         total += _amt;
118         entry.balance += _amt;
119     }
120 
121     function subtract(address _address, uint _amt)
122         fromOwner
123         public
124         returns (uint _amtRemoved)
125     {
126         if (_address == address(0) || _amt == 0) return;
127         Entry storage entry = entries[_address];
128 
129         uint _maxAmt = entry.balance;
130         if (_maxAmt == 0) return;
131         
132         if (_amt >= _maxAmt) {
133             // Subtract the max amount, and delete entry.
134             total -= _maxAmt;
135             entries[entry.prev].next = entry.next;
136             entries[entry.next].prev = entry.prev;
137             delete entries[_address];
138             return _maxAmt;
139         } else {
140             // Subtract the amount from entry.
141             total -= _amt;
142             entry.balance -= _amt;
143             return _amt;
144         }
145     }
146 
147 
148     /******************************************************/
149     /*************** PUBLIC VIEWS *************************/
150     /******************************************************/
151 
152     function size()
153         public
154         view
155         returns (uint _size)
156     {
157         // Loop once to get the total count.
158         Entry memory _curEntry = entries[0x0];
159         while (_curEntry.next > 0) {
160             _curEntry = entries[_curEntry.next];
161             _size++;
162         }
163         return _size;
164     }
165 
166     function balanceOf(address _address)
167         public
168         view
169         returns (uint _balance)
170     {
171         return entries[_address].balance;
172     }
173 
174     function balances()
175         public
176         view
177         returns (address[] _addresses, uint[] _balances)
178     {
179         // Populate names and addresses
180         uint _size = size();
181         _addresses = new address[](_size);
182         _balances = new uint[](_size);
183         uint _i = 0;
184         Entry memory _curEntry = entries[0x0];
185         while (_curEntry.next > 0) {
186             _addresses[_i] = _curEntry.next;
187             _balances[_i] = entries[_curEntry.next].balance;
188             _curEntry = entries[_curEntry.next];
189             _i++;
190         }
191         return (_addresses, _balances);
192     }
193 }
194 
195 /**
196     This is a simple class that maintains a doubly linked list of
197     addresses it has seen. Addresses can be added and removed
198     from the set, and a full list of addresses can be obtained.
199 
200     Methods:
201      - [fromOwner] .add()
202      - [fromOwner] .remove()
203     Views:
204      - .size()
205      - .has()
206      - .addresses()
207 */
208 contract AddressSet {
209     
210     struct Entry {  // Doubly linked list
211         bool exists;
212         address next;
213         address prev;
214     }
215     mapping (address => Entry) public entries;
216 
217     address public owner;
218     modifier fromOwner() { require(msg.sender==owner); _; }
219 
220     // Constructor sets the owner.
221     constructor(address _owner)
222         public
223     {
224         owner = _owner;
225     }
226 
227 
228     /******************************************************/
229     /*************** OWNER METHODS ************************/
230     /******************************************************/
231 
232     function add(address _address)
233         fromOwner
234         public
235         returns (bool _didCreate)
236     {
237         // Do not allow the adding of HEAD.
238         if (_address == address(0)) return;
239         Entry storage entry = entries[_address];
240         // If already exists, do nothing. Otherwise set it.
241         if (entry.exists) return;
242         else entry.exists = true;
243 
244         // Replace first entry with this one.
245         // Before: HEAD <-> X <-> Y
246         // After: HEAD <-> THIS <-> X <-> Y
247         // do: THIS.NEXT = [0].next; [0].next.prev = THIS; [0].next = THIS; THIS.prev = 0;
248         Entry storage HEAD = entries[0x0];
249         entry.next = HEAD.next;
250         entries[HEAD.next].prev = _address;
251         HEAD.next = _address;
252         return true;
253     }
254 
255     function remove(address _address)
256         fromOwner
257         public
258         returns (bool _didExist)
259     {
260         // Do not allow the removal of HEAD.
261         if (_address == address(0)) return;
262         Entry storage entry = entries[_address];
263         // If it doesn't exist already, there is nothing to do.
264         if (!entry.exists) return;
265 
266         // Stitch together next and prev, delete entry.
267         // Before: X <-> THIS <-> Y
268         // After: X <-> Y
269         // do: THIS.next.prev = this.prev; THIS.prev.next = THIS.next;
270         entries[entry.prev].next = entry.next;
271         entries[entry.next].prev = entry.prev;
272         delete entries[_address];
273         return true;
274     }
275 
276 
277     /******************************************************/
278     /*************** PUBLIC VIEWS *************************/
279     /******************************************************/
280 
281     function size()
282         public
283         view
284         returns (uint _size)
285     {
286         // Loop once to get the total count.
287         Entry memory _curEntry = entries[0x0];
288         while (_curEntry.next > 0) {
289             _curEntry = entries[_curEntry.next];
290             _size++;
291         }
292         return _size;
293     }
294 
295     function has(address _address)
296         public
297         view
298         returns (bool _exists)
299     {
300         return entries[_address].exists;
301     }
302 
303     function addresses()
304         public
305         view
306         returns (address[] _addresses)
307     {
308         // Populate names and addresses
309         uint _size = size();
310         _addresses = new address[](_size);
311         // Iterate forward through all entries until the end.
312         uint _i = 0;
313         Entry memory _curEntry = entries[0x0];
314         while (_curEntry.next > 0) {
315             _addresses[_i] = _curEntry.next;
316             _curEntry = entries[_curEntry.next];
317             _i++;
318         }
319         return _addresses;
320     }
321 }
322 
323 /******* USING TREASURY **************************
324 
325 Gives the inherting contract access to:
326     .getTreasury(): returns current ITreasury instance
327     [modifier] .fromTreasury(): requires the sender is current Treasury
328 
329 *************************************************/
330 // Returned by .getTreasury()
331 interface ITreasury {
332     function issueDividend() external returns (uint _profits);
333     function profitsSendable() external view returns (uint _profits);
334 }
335 
336 contract UsingTreasury is
337     UsingRegistry
338 {
339     constructor(address _registry)
340         UsingRegistry(_registry)
341         public
342     {}
343 
344     modifier fromTreasury(){
345         require(msg.sender == address(getTreasury()));
346         _;
347     }
348     
349     function getTreasury()
350         public
351         view
352         returns (ITreasury)
353     {
354         return ITreasury(addressOf("TREASURY"));
355     }
356 }
357 
358 
359 /**
360   A simple class that manages bankroll, and maintains collateral.
361   This class only ever sends profits the Treasury. No exceptions.
362 
363   - Anybody can add funding (according to whitelist)
364   - Anybody can tell profits (balance - (funding + collateral)) to go to Treasury.
365   - Anyone can remove their funding, so long as balance >= collateral.
366   - Whitelist is managed by getWhitelistOwner() -- typically Admin.
367 
368   Exposes the following:
369     Public Methods
370      - addBankroll
371      - removeBankroll
372      - sendProfits
373     Public Views
374      - getCollateral
375      - profits
376      - profitsSent
377      - profitsTotal
378      - bankroll
379      - bankrollAvailable
380      - bankrolledBy
381      - bankrollerTable
382 */
383 contract Bankrollable is
384     UsingTreasury
385 {   
386     // How much profits have been sent. 
387     uint public profitsSent;
388     // Ledger keeps track of who has bankrolled us, and for how much
389     Ledger public ledger;
390     // This is a copy of ledger.total(), to save gas in .bankrollAvailable()
391     uint public bankroll;
392     // This is the whitelist of who can call .addBankroll()
393     AddressSet public whitelist;
394 
395     modifier fromWhitelistOwner(){
396         require(msg.sender == getWhitelistOwner());
397         _;
398     }
399 
400     event BankrollAdded(uint time, address indexed bankroller, uint amount, uint bankroll);
401     event BankrollRemoved(uint time, address indexed bankroller, uint amount, uint bankroll);
402     event ProfitsSent(uint time, address indexed treasury, uint amount);
403     event AddedToWhitelist(uint time, address indexed addr, address indexed wlOwner);
404     event RemovedFromWhitelist(uint time, address indexed addr, address indexed wlOwner);
405 
406     // Constructor creates the ledger and whitelist, with self as owner.
407     constructor(address _registry)
408         UsingTreasury(_registry)
409         public
410     {
411         ledger = new Ledger(this);
412         whitelist = new AddressSet(this);
413     }
414 
415 
416     /*****************************************************/
417     /************** WHITELIST MGMT ***********************/
418     /*****************************************************/    
419 
420     function addToWhitelist(address _addr)
421         fromWhitelistOwner
422         public
423     {
424         bool _didAdd = whitelist.add(_addr);
425         if (_didAdd) emit AddedToWhitelist(now, _addr, msg.sender);
426     }
427 
428     function removeFromWhitelist(address _addr)
429         fromWhitelistOwner
430         public
431     {
432         bool _didRemove = whitelist.remove(_addr);
433         if (_didRemove) emit RemovedFromWhitelist(now, _addr, msg.sender);
434     }
435 
436     /*****************************************************/
437     /************** PUBLIC FUNCTIONS *********************/
438     /*****************************************************/
439 
440     // Bankrollable contracts should be payable (to receive revenue)
441     function () public payable {}
442 
443     // Increase funding by whatever value is sent
444     function addBankroll()
445         public
446         payable 
447     {
448         require(whitelist.size()==0 || whitelist.has(msg.sender));
449         ledger.add(msg.sender, msg.value);
450         bankroll = ledger.total();
451         emit BankrollAdded(now, msg.sender, msg.value, bankroll);
452     }
453 
454     // Removes up to _amount from Ledger, and sends it to msg.sender._callbackFn
455     function removeBankroll(uint _amount, string _callbackFn)
456         public
457         returns (uint _recalled)
458     {
459         // cap amount at the balance minus collateral, or nothing at all.
460         address _bankroller = msg.sender;
461         uint _collateral = getCollateral();
462         uint _balance = address(this).balance;
463         uint _available = _balance > _collateral ? _balance - _collateral : 0;
464         if (_amount > _available) _amount = _available;
465 
466         // Try to remove _amount from ledger, get actual _amount removed.
467         _amount = ledger.subtract(_bankroller, _amount);
468         bankroll = ledger.total();
469         if (_amount == 0) return;
470 
471         bytes4 _sig = bytes4(keccak256(_callbackFn));
472         require(_bankroller.call.value(_amount)(_sig));
473         emit BankrollRemoved(now, _bankroller, _amount, bankroll);
474         return _amount;
475     }
476 
477     // Send any excess profits to treasury.
478     function sendProfits()
479         public
480         returns (uint _profits)
481     {
482         int _p = profits();
483         if (_p <= 0) return;
484         _profits = uint(_p);
485         profitsSent += _profits;
486         // Send profits to Treasury
487         address _tr = getTreasury();
488         require(_tr.call.value(_profits)());
489         emit ProfitsSent(now, _tr, _profits);
490     }
491 
492 
493     /*****************************************************/
494     /************** PUBLIC VIEWS *************************/
495     /*****************************************************/
496 
497     // Function must be overridden by inheritors to ensure collateral is kept.
498     function getCollateral()
499         public
500         view
501         returns (uint _amount);
502 
503     // Function must be overridden by inheritors to enable whitelist control.
504     function getWhitelistOwner()
505         public
506         view
507         returns (address _addr);
508 
509     // Profits are the difference between balance and threshold
510     function profits()
511         public
512         view
513         returns (int _profits)
514     {
515         int _balance = int(address(this).balance);
516         int _threshold = int(bankroll + getCollateral());
517         return _balance - _threshold;
518     }
519 
520     // How profitable this contract is, overall
521     function profitsTotal()
522         public
523         view
524         returns (int _profits)
525     {
526         return int(profitsSent) + profits();
527     }
528 
529     // Returns the amount that can currently be bankrolled.
530     //   - 0 if balance < collateral
531     //   - If profits: full bankroll
532     //   - If no profits: remaning bankroll: balance - collateral
533     function bankrollAvailable()
534         public
535         view
536         returns (uint _amount)
537     {
538         uint _balance = address(this).balance;
539         uint _bankroll = bankroll;
540         uint _collat = getCollateral();
541         // Balance is below collateral!
542         if (_balance <= _collat) return 0;
543         // No profits, but we have a balance over collateral.
544         else if (_balance < _collat + _bankroll) return _balance - _collat;
545         // Profits. Return only _bankroll
546         else return _bankroll;
547     }
548 
549     function bankrolledBy(address _addr)
550         public
551         view
552         returns (uint _amount)
553     {
554         return ledger.balanceOf(_addr);
555     }
556 
557     function bankrollerTable()
558         public
559         view
560         returns (address[], uint[])
561     {
562         return ledger.balances();
563     }
564 }
565 
566 
567 
568 
569 /******* USING ADMIN ***********************
570 
571 Gives the inherting contract access to:
572     .getAdmin(): returns the current address of the admin
573     [modifier] .fromAdmin: requires the sender is the admin
574 
575 *************************************************/
576 contract UsingAdmin is
577     UsingRegistry
578 {
579     constructor(address _registry)
580         UsingRegistry(_registry)
581         public
582     {}
583 
584     modifier fromAdmin(){
585         require(msg.sender == getAdmin());
586         _;
587     }
588     
589     function getAdmin()
590         public
591         constant
592         returns (address _addr)
593     {
594         return addressOf("ADMIN");
595     }
596 }
597 
598 /*********************************************************
599 *********************** INSTADICE ************************
600 **********************************************************
601 
602 UI: https://www.pennyether.com
603 
604 This contract allows for users to wager a limited amount on then
605 outcome of a random roll between [1, 100]. The user may choose
606 a number, and if the roll is less than or equal to that number,
607 they will win a payout that is inversely proportional to the
608 number they chose (lower numbers pay out more).
609 
610 When a roll is "finalized", it means the result was determined
611 and the payout paid to the user if they won. Each time somebody 
612 rolls, their previous roll is finalized. Roll results are based
613 on blockhash, and since only the last 256 blockhashes are 
614 available (who knows why it is so limited...), the user must
615 finalize within 256 blocks or their roll loses.
616 
617 Note about randomness:
618   Although using blockhash for randomness is not advised,
619   it is perfectly acceptable if the results of the block
620   are not worth an expected value greater than that of:
621     (full block reward - uncle block reward) = ~.625 Eth
622 
623   In other words, a miner is better of mining honestly and
624   getting a full block reward than trying to game this contract,
625   unless the maximum bet is increased to about .625, which
626   this contract forbids.
627 */
628 contract InstaDice is
629     Bankrollable,
630     UsingAdmin
631 {
632     struct User {
633         uint32 id;
634         uint32 r_id;
635         uint32 r_block;
636         uint8 r_number;
637         uint72 r_payout;
638     }
639 
640     // These stats are updated on each roll.
641     struct Stats {
642         uint32 numUsers;
643         uint32 numRolls;
644         uint96 totalWagered;
645         uint96 totalWon;
646     }
647     
648     // Admin controlled settings
649     struct Settings {
650         uint64 minBet;    //
651         uint64 maxBet;    // 
652         uint8 minNumber;  // they get ~20x their bet
653         uint8 maxNumber;  // they get ~1.01x their bet
654         uint16 feeBips;   // each bip is .01%, eg: 100 = 1% fee.
655     }
656 
657     mapping (address => User) public users;
658     Stats stats;
659     Settings settings;
660     uint8 constant public version = 2;
661     
662     // Admin events
663     event Created(uint time);
664     event SettingsChanged(uint time, address indexed admin);
665 
666     // Events
667     event RollWagered(uint time, uint32 indexed id, address indexed user, uint bet, uint8 number, uint payout);
668     event RollRefunded(uint time, address indexed user, string msg, uint bet, uint8 number);
669     event RollFinalized(uint time, uint32 indexed id, address indexed user, uint8 result, uint payout);
670     event PayoutError(uint time, string msg);
671 
672     constructor(address _registry)
673         Bankrollable(_registry)
674         UsingAdmin(_registry)
675         public
676     {
677         // populate with prev contracts' stats
678         stats.totalWagered = 3650000000000000000;
679         stats.totalWon = 3537855001272912000;
680         stats.numRolls = 123;
681         stats.numUsers = 19;
682 
683         // default settings
684         settings.maxBet = .3 ether;
685         settings.minBet = .001 ether;
686         settings.minNumber = 5;
687         settings.maxNumber = 98;
688         settings.feeBips = 100;
689         emit Created(now);
690     }
691 
692 
693     ///////////////////////////////////////////////////
694     ////// ADMIN FUNCTIONS ////////////////////////////
695     ///////////////////////////////////////////////////
696 
697     // Changes the settings
698     function changeSettings(
699         uint64 _minBet,
700         uint64 _maxBet,
701         uint8 _minNumber,
702         uint8 _maxNumber,
703         uint16 _feeBips
704     )
705         public
706         fromAdmin
707     {
708         require(_minBet <= _maxBet);    // makes sense
709         require(_maxBet <= .625 ether); // capped at (block reward - uncle reward)
710         require(_minNumber >= 1);       // not advisible, but why not
711         require(_maxNumber <= 99);      // over 100 makes no sense
712         require(_feeBips <= 500);       // max of 5%
713         settings.minBet = _minBet;
714         settings.maxBet = _maxBet;
715         settings.minNumber = _minNumber;
716         settings.maxNumber = _maxNumber;
717         settings.feeBips = _feeBips;
718         emit SettingsChanged(now, msg.sender);
719     }
720     
721 
722     ///////////////////////////////////////////////////
723     ////// PUBLIC FUNCTIONS ///////////////////////////
724     ///////////////////////////////////////////////////
725 
726     // Resolves the last roll for the user.
727     // Then creates a new roll.
728     // Gas:
729     //    Total: 56k (new), or up to 44k (repeat)
730     //    Overhead: 36k
731     //       22k: tx overhead
732     //        2k: SLOAD
733     //        3k: execution
734     //        2k: curMaxBet()
735     //        5k: update stats
736     //        2k: RollWagered event
737     //    New User: 20k
738     //       20k: create user
739     //    Repeat User: 8k, 16k
740     //        5k: update user
741     //        3k: RollFinalized event
742     //        8k: pay last roll
743     function roll(uint8 _number)
744         public
745         payable
746         returns (bool _success)
747     {
748         // Ensure bet and number are valid.
749         if (!_validateBetOrRefund(_number)) return;
750 
751         // Ensure one bet per block.
752         User memory _prevUser = users[msg.sender];
753         if (_prevUser.r_block == uint32(block.number)){
754             _errorAndRefund("Only one bet per block allowed.", msg.value, _number);
755             return false;
756         }
757 
758         // Create and write new user data before finalizing last roll
759         Stats memory _stats = stats;
760         User memory _newUser = User({
761             id: _prevUser.id == 0 ? _stats.numUsers + 1 : _prevUser.id,
762             r_id: _stats.numRolls + 1,
763             r_block: uint32(block.number),
764             r_number: _number,
765             r_payout: computePayout(msg.value, _number)
766         });
767         users[msg.sender] = _newUser;
768 
769         // Finalize last roll, if there was one.
770         // This will throw if user won, but we couldn't pay.
771         if (_prevUser.r_block != 0) _finalizePreviousRoll(_prevUser, _stats);
772 
773         // Increment additional stats data
774         _stats.numUsers = _prevUser.id == 0 ? _stats.numUsers + 1 : _stats.numUsers;
775         _stats.numRolls = stats.numRolls + 1;
776         _stats.totalWagered = stats.totalWagered + uint96(msg.value);
777         stats = _stats;
778 
779         // Save user in one write.
780         emit RollWagered(now, _newUser.r_id, msg.sender, msg.value, _newUser.r_number, _newUser.r_payout);
781         return true;
782     }
783 
784     // Finalizes the previous roll and pays out user if they won.
785     // Gas: 45k
786     //   21k: tx overhead
787     //    1k: SLOADs
788     //    2k: execution
789     //    8k: send winnings
790     //    5k: update user
791     //    5k: update stats
792     //    3k: RollFinalized event
793     function payoutPreviousRoll()
794         public
795         returns (bool _success)
796     {
797         // Load last roll in one SLOAD.
798         User memory _prevUser = users[msg.sender];
799         // Error if on same block.
800         if (_prevUser.r_block == uint32(block.number)){
801             emit PayoutError(now, "Cannot payout roll on the same block");
802             return false;
803         }
804         // Error if nothing to payout.
805         if (_prevUser.r_block == 0){
806             emit PayoutError(now, "No roll to pay out.");
807             return false;
808         }
809 
810         // Clear last roll data
811         User storage _user = users[msg.sender];
812         _user.r_id = 0;
813         _user.r_block = 0;
814         _user.r_number = 0;
815         _user.r_payout = 0;
816 
817         // Finalize previous roll and update stats
818         Stats memory _stats = stats;
819         _finalizePreviousRoll(_prevUser, _stats);
820         stats.totalWon = _stats.totalWon;
821         return true;
822     }
823 
824 
825     ////////////////////////////////////////////////////////
826     ////// PRIVATE FUNCTIONS ///////////////////////////////
827     ////////////////////////////////////////////////////////
828 
829     // Validates the bet, or refunds the user.
830     function _validateBetOrRefund(uint8 _number)
831         private
832         returns (bool _isValid)
833     {
834         Settings memory _settings = settings;
835         if (_number < _settings.minNumber) {
836             _errorAndRefund("Roll number too small.", msg.value, _number);
837             return false;
838         }
839         if (_number > _settings.maxNumber){
840             _errorAndRefund("Roll number too large.", msg.value, _number);
841             return false;
842         }
843         if (msg.value < _settings.minBet){
844             _errorAndRefund("Bet too small.", msg.value, _number);
845             return false;
846         }
847         if (msg.value > _settings.maxBet){
848             _errorAndRefund("Bet too large.", msg.value, _number);
849             return false;
850         }
851         if (msg.value > curMaxBet()){
852             _errorAndRefund("May be unable to payout on a win.", msg.value, _number);
853             return false;
854         }
855         return true;
856     }
857 
858     // Finalizes the previous roll for the _user.
859     // This will modify _stats, but not _user.
860     // Throws if unable to pay user on a win.
861     function _finalizePreviousRoll(User memory _user, Stats memory _stats)
862         private
863     {
864         assert(_user.r_block != uint32(block.number));
865         assert(_user.r_block != 0);
866         
867         // compute result and isWinner
868         uint8 _result = computeResult(_user.r_block, _user.r_id);
869         bool _isWinner = _result <= _user.r_number;
870         if (_isWinner) {
871             require(msg.sender.call.value(_user.r_payout)());
872             _stats.totalWon += _user.r_payout;
873         }
874         // they won and we paid, or they lost. roll is finalized.
875         emit RollFinalized(now, _user.r_id, msg.sender, _result, _isWinner ? _user.r_payout : 0);
876     }
877 
878     // Only called from above.
879     // Refunds user the full value, and logs an error
880     function _errorAndRefund(string _msg, uint _bet, uint8 _number)
881         private
882     {
883         require(msg.sender.call.value(msg.value)());
884         emit RollRefunded(now, msg.sender, _msg, _bet, _number);
885     }
886 
887 
888     ///////////////////////////////////////////////////
889     ////// PUBLIC VIEWS ///////////////////////////////
890     ///////////////////////////////////////////////////
891 
892     // IMPLEMENTS: Bankrollable.getCollateral()
893     // This contract has no collateral, as it pays out in near realtime.
894     function getCollateral() public view returns (uint _amount) {
895         return 0;
896     }
897 
898     // IMPLEMENTS: Bankrollable.getWhitelistOwner()
899     // Ensures contract always has at least bankroll + totalCredits.
900     function getWhitelistOwner() public view returns (address _wlOwner)
901     {
902         return getAdmin();
903     }
904 
905     // Returns the largest bet such that we could pay out 10 maximum wins.
906     // The likelihood that 10 maximum bets (with highest payouts) are won
907     //  within a short period of time are extremely low.
908     function curMaxBet() public view returns (uint _amount) {
909         // Return largest bet such that 10*bet*payout = bankrollable()
910         uint _maxPayout = 10 * 100 / uint(settings.minNumber);
911         return bankrollAvailable() / _maxPayout;
912     }
913 
914     // Return the less of settings.maxBet and curMaxBet()
915     function effectiveMaxBet() public view returns (uint _amount) {
916         uint _curMax = curMaxBet();
917         return _curMax > settings.maxBet ? settings.maxBet : _curMax;
918     }
919 
920     // Computes the payout amount for the current _feeBips
921     function computePayout(uint _bet, uint _number)
922         public
923         view
924         returns (uint72 _wei)
925     {
926         uint _feeBips = settings.feeBips;   // Cast to uint, makes below math cheaper.
927         uint _bigBet = _bet * 1e32;         // Will not overflow unless _bet >> ~1e40
928         uint _bigPayout = (_bigBet * 100) / _number;
929         uint _bigFee = (_bigPayout * _feeBips) / 10000;
930         return uint72( (_bigPayout - _bigFee) / 1e32 );
931     }
932 
933     // Returns a number between 1 and 100 (inclusive)
934     // If blockNumber is too far past, returns 101.
935     function computeResult(uint32 _blockNumber, uint32 _id)
936         public
937         view
938         returns (uint8 _result)
939     {
940         bytes32 _blockHash = blockhash(_blockNumber);
941         if (_blockHash == 0) { return 101; }
942         return uint8(uint(keccak256(_blockHash, _id)) % 100 + 1);
943     }
944 
945     // Expose all Stats /////////////////////////////////
946     function numUsers() public view returns (uint32) {
947         return stats.numUsers;
948     }
949     function numRolls() public view returns (uint32) {
950         return stats.numRolls;
951     }
952     function totalWagered() public view returns (uint) {
953         return stats.totalWagered;
954     }
955     function totalWon() public view returns (uint) {
956         return stats.totalWon;
957     }
958     //////////////////////////////////////////////////////
959 
960     // Expose all Settings ///////////////////////////////
961     function minBet() public view returns (uint) {
962         return settings.minBet;
963     }
964     function maxBet() public view returns (uint) {
965         return settings.maxBet;
966     }
967     function minNumber() public view returns (uint8) {
968         return settings.minNumber;
969     }
970     function maxNumber() public view returns (uint8) {
971         return settings.maxNumber;
972     }
973     function feeBips() public view returns (uint16) {
974         return settings.feeBips;
975     }
976     //////////////////////////////////////////////////////
977 
978 }