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
56 /******* USING ADMIN ***********************
57 
58 Gives the inherting contract access to:
59     .getAdmin(): returns the current address of the admin
60     [modifier] .fromAdmin: requires the sender is the admin
61 
62 *************************************************/
63 contract UsingAdmin is
64     UsingRegistry
65 {
66     constructor(address _registry)
67         UsingRegistry(_registry)
68         public
69     {}
70 
71     modifier fromAdmin(){
72         require(msg.sender == getAdmin());
73         _;
74     }
75     
76     function getAdmin()
77         public
78         constant
79         returns (address _addr)
80     {
81         return addressOf("ADMIN");
82     }
83 }
84 
85 /******* USING MONARCHYFACTORY **************************
86 
87 Gives the inherting contract access to:
88     .getPaf(): returns current IPaf instance
89     [modifier] .fromPaf(): requires the sender is current Paf.
90 
91 *************************************************/
92 // Returned by .getMonarchyFactory()
93 interface IMonarchyFactory {
94     function lastCreatedGame() external view returns (address _game);
95     function getCollector() external view returns (address _collector);
96 }
97 
98 contract UsingMonarchyFactory is
99     UsingRegistry
100 {
101     constructor(address _registry)
102         UsingRegistry(_registry)
103         public
104     {}
105 
106     modifier fromMonarchyFactory(){ 
107         require(msg.sender == address(getMonarchyFactory()));
108         _;
109     }
110 
111     function getMonarchyFactory()
112         public
113         view
114         returns (IMonarchyFactory)
115     {
116         return IMonarchyFactory(addressOf("MONARCHY_FACTORY"));
117     }
118 }
119 
120 
121 /******* USING TREASURY **************************
122 
123 Gives the inherting contract access to:
124     .getTreasury(): returns current ITreasury instance
125     [modifier] .fromTreasury(): requires the sender is current Treasury
126 
127 *************************************************/
128 // Returned by .getTreasury()
129 interface ITreasury {
130     function issueDividend() external returns (uint _profits);
131     function profitsSendable() external view returns (uint _profits);
132 }
133 
134 contract UsingTreasury is
135     UsingRegistry
136 {
137     constructor(address _registry)
138         UsingRegistry(_registry)
139         public
140     {}
141 
142     modifier fromTreasury(){
143         require(msg.sender == address(getTreasury()));
144         _;
145     }
146     
147     function getTreasury()
148         public
149         view
150         returns (ITreasury)
151     {
152         return ITreasury(addressOf("TREASURY"));
153     }
154 }
155 
156 
157 /*
158     Exposes the following internal methods:
159         - _useFromDailyLimit(uint)
160         - _setDailyLimit(uint)
161         - getDailyLimit()
162         - getDailyLimitUsed()
163         - getDailyLimitUnused()
164 */
165 contract HasDailyLimit {
166     // squeeze all vars into one storage slot.
167     struct DailyLimitVars {
168         uint112 dailyLimit; // Up to 5e15 * 1e18.
169         uint112 usedToday;  // Up to 5e15 * 1e18.
170         uint32 lastDay;     // Up to the year 11,000,000 AD
171     }
172     DailyLimitVars private vars;
173     uint constant MAX_ALLOWED = 2**112 - 1;
174 
175     constructor(uint _limit) public {
176         _setDailyLimit(_limit);
177     }
178 
179     // Sets the daily limit.
180     function _setDailyLimit(uint _limit) internal {
181         require(_limit <= MAX_ALLOWED);
182         vars.dailyLimit = uint112(_limit);
183     }
184 
185     // Uses the requested amount if its within limit. Or throws.
186     // You should use getDailyLimitRemaining() before calling this.
187     function _useFromDailyLimit(uint _amount) internal {
188         uint _remaining = updateAndGetRemaining();
189         require(_amount <= _remaining);
190         vars.usedToday += uint112(_amount);
191     }
192 
193     // If necessary, resets the day's usage.
194     // Then returns the amount remaining for today.
195     function updateAndGetRemaining() private returns (uint _amtRemaining) {
196         if (today() > vars.lastDay) {
197             vars.usedToday = 0;
198             vars.lastDay = today();
199         }
200         uint112 _usedToday = vars.usedToday;
201         uint112 _dailyLimit = vars.dailyLimit;
202         // This could be negative if _dailyLimit was reduced.
203         return uint(_usedToday >= _dailyLimit ? 0 : _dailyLimit - _usedToday);
204     }
205 
206     // Returns the current day.
207     function today() private view returns (uint32) {
208         return uint32(block.timestamp / 1 days);
209     }
210 
211 
212     /////////////////////////////////////////////////////////////////
213     ////////////// PUBLIC VIEWS /////////////////////////////////////
214     /////////////////////////////////////////////////////////////////
215 
216     function getDailyLimit() public view returns (uint) {
217         return uint(vars.dailyLimit);
218     }
219     function getDailyLimitUsed() public view returns (uint) {
220         return uint(today() > vars.lastDay ? 0 : vars.usedToday);
221     }
222     function getDailyLimitRemaining() public view returns (uint) {
223         uint _used = getDailyLimitUsed();
224         return uint(_used >= vars.dailyLimit ? 0 : vars.dailyLimit - _used);
225     }
226 }
227 
228 /**
229     This is a simple class that maintains a doubly linked list of
230     address => uint amounts. Address balances can be added to 
231     or removed from via add() and subtract(). All balances can
232     be obtain by calling balances(). If an address has a 0 amount,
233     it is removed from the Ledger.
234 
235     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
236           use to track Ether balances.
237 
238     Public methods:
239       - [fromOwner] add()
240       - [fromOwner] subtract()
241     Public views:
242       - total()
243       - size()
244       - balanceOf()
245       - balances()
246       - entries() [to manually iterate]
247 */
248 contract Ledger {
249     uint public total;      // Total amount in Ledger
250 
251     struct Entry {          // Doubly linked list tracks amount per address
252         uint balance;
253         address next;
254         address prev;
255     }
256     mapping (address => Entry) public entries;
257 
258     address public owner;
259     modifier fromOwner() { require(msg.sender==owner); _; }
260 
261     // Constructor sets the owner
262     constructor(address _owner)
263         public
264     {
265         owner = _owner;
266     }
267 
268 
269     /******************************************************/
270     /*************** OWNER METHODS ************************/
271     /******************************************************/
272 
273     function add(address _address, uint _amt)
274         fromOwner
275         public
276     {
277         if (_address == address(0) || _amt == 0) return;
278         Entry storage entry = entries[_address];
279 
280         // If new entry, replace first entry with this one.
281         if (entry.balance == 0) {
282             entry.next = entries[0x0].next;
283             entries[entries[0x0].next].prev = _address;
284             entries[0x0].next = _address;
285         }
286         // Update stats.
287         total += _amt;
288         entry.balance += _amt;
289     }
290 
291     function subtract(address _address, uint _amt)
292         fromOwner
293         public
294         returns (uint _amtRemoved)
295     {
296         if (_address == address(0) || _amt == 0) return;
297         Entry storage entry = entries[_address];
298 
299         uint _maxAmt = entry.balance;
300         if (_maxAmt == 0) return;
301         
302         if (_amt >= _maxAmt) {
303             // Subtract the max amount, and delete entry.
304             total -= _maxAmt;
305             entries[entry.prev].next = entry.next;
306             entries[entry.next].prev = entry.prev;
307             delete entries[_address];
308             return _maxAmt;
309         } else {
310             // Subtract the amount from entry.
311             total -= _amt;
312             entry.balance -= _amt;
313             return _amt;
314         }
315     }
316 
317 
318     /******************************************************/
319     /*************** PUBLIC VIEWS *************************/
320     /******************************************************/
321 
322     function size()
323         public
324         view
325         returns (uint _size)
326     {
327         // Loop once to get the total count.
328         Entry memory _curEntry = entries[0x0];
329         while (_curEntry.next > 0) {
330             _curEntry = entries[_curEntry.next];
331             _size++;
332         }
333         return _size;
334     }
335 
336     function balanceOf(address _address)
337         public
338         view
339         returns (uint _balance)
340     {
341         return entries[_address].balance;
342     }
343 
344     function balances()
345         public
346         view
347         returns (address[] _addresses, uint[] _balances)
348     {
349         // Populate names and addresses
350         uint _size = size();
351         _addresses = new address[](_size);
352         _balances = new uint[](_size);
353         uint _i = 0;
354         Entry memory _curEntry = entries[0x0];
355         while (_curEntry.next > 0) {
356             _addresses[_i] = _curEntry.next;
357             _balances[_i] = entries[_curEntry.next].balance;
358             _curEntry = entries[_curEntry.next];
359             _i++;
360         }
361         return (_addresses, _balances);
362     }
363 }
364 
365 /**
366     This is a simple class that maintains a doubly linked list of
367     addresses it has seen. Addresses can be added and removed
368     from the set, and a full list of addresses can be obtained.
369 
370     Methods:
371      - [fromOwner] .add()
372      - [fromOwner] .remove()
373     Views:
374      - .size()
375      - .has()
376      - .addresses()
377 */
378 contract AddressSet {
379     
380     struct Entry {  // Doubly linked list
381         bool exists;
382         address next;
383         address prev;
384     }
385     mapping (address => Entry) public entries;
386 
387     address public owner;
388     modifier fromOwner() { require(msg.sender==owner); _; }
389 
390     // Constructor sets the owner.
391     constructor(address _owner)
392         public
393     {
394         owner = _owner;
395     }
396 
397 
398     /******************************************************/
399     /*************** OWNER METHODS ************************/
400     /******************************************************/
401 
402     function add(address _address)
403         fromOwner
404         public
405         returns (bool _didCreate)
406     {
407         // Do not allow the adding of HEAD.
408         if (_address == address(0)) return;
409         Entry storage entry = entries[_address];
410         // If already exists, do nothing. Otherwise set it.
411         if (entry.exists) return;
412         else entry.exists = true;
413 
414         // Replace first entry with this one.
415         // Before: HEAD <-> X <-> Y
416         // After: HEAD <-> THIS <-> X <-> Y
417         // do: THIS.NEXT = [0].next; [0].next.prev = THIS; [0].next = THIS; THIS.prev = 0;
418         Entry storage HEAD = entries[0x0];
419         entry.next = HEAD.next;
420         entries[HEAD.next].prev = _address;
421         HEAD.next = _address;
422         return true;
423     }
424 
425     function remove(address _address)
426         fromOwner
427         public
428         returns (bool _didExist)
429     {
430         // Do not allow the removal of HEAD.
431         if (_address == address(0)) return;
432         Entry storage entry = entries[_address];
433         // If it doesn't exist already, there is nothing to do.
434         if (!entry.exists) return;
435 
436         // Stitch together next and prev, delete entry.
437         // Before: X <-> THIS <-> Y
438         // After: X <-> Y
439         // do: THIS.next.prev = this.prev; THIS.prev.next = THIS.next;
440         entries[entry.prev].next = entry.next;
441         entries[entry.next].prev = entry.prev;
442         delete entries[_address];
443         return true;
444     }
445 
446 
447     /******************************************************/
448     /*************** PUBLIC VIEWS *************************/
449     /******************************************************/
450 
451     function size()
452         public
453         view
454         returns (uint _size)
455     {
456         // Loop once to get the total count.
457         Entry memory _curEntry = entries[0x0];
458         while (_curEntry.next > 0) {
459             _curEntry = entries[_curEntry.next];
460             _size++;
461         }
462         return _size;
463     }
464 
465     function has(address _address)
466         public
467         view
468         returns (bool _exists)
469     {
470         return entries[_address].exists;
471     }
472 
473     function addresses()
474         public
475         view
476         returns (address[] _addresses)
477     {
478         // Populate names and addresses
479         uint _size = size();
480         _addresses = new address[](_size);
481         // Iterate forward through all entries until the end.
482         uint _i = 0;
483         Entry memory _curEntry = entries[0x0];
484         while (_curEntry.next > 0) {
485             _addresses[_i] = _curEntry.next;
486             _curEntry = entries[_curEntry.next];
487             _i++;
488         }
489         return _addresses;
490     }
491 }
492 
493 
494 /**
495   A simple class that manages bankroll, and maintains collateral.
496   This class only ever sends profits the Treasury. No exceptions.
497 
498   - Anybody can add funding (according to whitelist)
499   - Anybody can tell profits (balance - (funding + collateral)) to go to Treasury.
500   - Anyone can remove their funding, so long as balance >= collateral.
501   - Whitelist is managed by getWhitelistOwner() -- typically Admin.
502 
503   Exposes the following:
504     Public Methods
505      - addBankroll
506      - removeBankroll
507      - sendProfits
508     Public Views
509      - getCollateral
510      - profits
511      - profitsSent
512      - profitsTotal
513      - bankroll
514      - bankrollAvailable
515      - bankrolledBy
516      - bankrollerTable
517 */
518 contract Bankrollable is
519     UsingTreasury
520 {   
521     // How much profits have been sent. 
522     uint public profitsSent;
523     // Ledger keeps track of who has bankrolled us, and for how much
524     Ledger public ledger;
525     // This is a copy of ledger.total(), to save gas in .bankrollAvailable()
526     uint public bankroll;
527     // This is the whitelist of who can call .addBankroll()
528     AddressSet public whitelist;
529 
530     modifier fromWhitelistOwner(){
531         require(msg.sender == getWhitelistOwner());
532         _;
533     }
534 
535     event BankrollAdded(uint time, address indexed bankroller, uint amount, uint bankroll);
536     event BankrollRemoved(uint time, address indexed bankroller, uint amount, uint bankroll);
537     event ProfitsSent(uint time, address indexed treasury, uint amount);
538     event AddedToWhitelist(uint time, address indexed addr, address indexed wlOwner);
539     event RemovedFromWhitelist(uint time, address indexed addr, address indexed wlOwner);
540 
541     // Constructor creates the ledger and whitelist, with self as owner.
542     constructor(address _registry)
543         UsingTreasury(_registry)
544         public
545     {
546         ledger = new Ledger(this);
547         whitelist = new AddressSet(this);
548     }
549 
550 
551     /*****************************************************/
552     /************** WHITELIST MGMT ***********************/
553     /*****************************************************/    
554 
555     function addToWhitelist(address _addr)
556         fromWhitelistOwner
557         public
558     {
559         bool _didAdd = whitelist.add(_addr);
560         if (_didAdd) emit AddedToWhitelist(now, _addr, msg.sender);
561     }
562 
563     function removeFromWhitelist(address _addr)
564         fromWhitelistOwner
565         public
566     {
567         bool _didRemove = whitelist.remove(_addr);
568         if (_didRemove) emit RemovedFromWhitelist(now, _addr, msg.sender);
569     }
570 
571     /*****************************************************/
572     /************** PUBLIC FUNCTIONS *********************/
573     /*****************************************************/
574 
575     // Bankrollable contracts should be payable (to receive revenue)
576     function () public payable {}
577 
578     // Increase funding by whatever value is sent
579     function addBankroll()
580         public
581         payable 
582     {
583         require(whitelist.size()==0 || whitelist.has(msg.sender));
584         ledger.add(msg.sender, msg.value);
585         bankroll = ledger.total();
586         emit BankrollAdded(now, msg.sender, msg.value, bankroll);
587     }
588 
589     // Removes up to _amount from Ledger, and sends it to msg.sender._callbackFn
590     function removeBankroll(uint _amount, string _callbackFn)
591         public
592         returns (uint _recalled)
593     {
594         // cap amount at the balance minus collateral, or nothing at all.
595         address _bankroller = msg.sender;
596         uint _collateral = getCollateral();
597         uint _balance = address(this).balance;
598         uint _available = _balance > _collateral ? _balance - _collateral : 0;
599         if (_amount > _available) _amount = _available;
600 
601         // Try to remove _amount from ledger, get actual _amount removed.
602         _amount = ledger.subtract(_bankroller, _amount);
603         bankroll = ledger.total();
604         if (_amount == 0) return;
605 
606         bytes4 _sig = bytes4(keccak256(_callbackFn));
607         require(_bankroller.call.value(_amount)(_sig));
608         emit BankrollRemoved(now, _bankroller, _amount, bankroll);
609         return _amount;
610     }
611 
612     // Send any excess profits to treasury.
613     function sendProfits()
614         public
615         returns (uint _profits)
616     {
617         int _p = profits();
618         if (_p <= 0) return;
619         _profits = uint(_p);
620         profitsSent += _profits;
621         // Send profits to Treasury
622         address _tr = getTreasury();
623         require(_tr.call.value(_profits)());
624         emit ProfitsSent(now, _tr, _profits);
625     }
626 
627 
628     /*****************************************************/
629     /************** PUBLIC VIEWS *************************/
630     /*****************************************************/
631 
632     // Function must be overridden by inheritors to ensure collateral is kept.
633     function getCollateral()
634         public
635         view
636         returns (uint _amount);
637 
638     // Function must be overridden by inheritors to enable whitelist control.
639     function getWhitelistOwner()
640         public
641         view
642         returns (address _addr);
643 
644     // Profits are the difference between balance and threshold
645     function profits()
646         public
647         view
648         returns (int _profits)
649     {
650         int _balance = int(address(this).balance);
651         int _threshold = int(bankroll + getCollateral());
652         return _balance - _threshold;
653     }
654 
655     // How profitable this contract is, overall
656     function profitsTotal()
657         public
658         view
659         returns (int _profits)
660     {
661         return int(profitsSent) + profits();
662     }
663 
664     // Returns the amount that can currently be bankrolled.
665     //   - 0 if balance < collateral
666     //   - If profits: full bankroll
667     //   - If no profits: remaning bankroll: balance - collateral
668     function bankrollAvailable()
669         public
670         view
671         returns (uint _amount)
672     {
673         uint _balance = address(this).balance;
674         uint _bankroll = bankroll;
675         uint _collat = getCollateral();
676         // Balance is below collateral!
677         if (_balance <= _collat) return 0;
678         // No profits, but we have a balance over collateral.
679         else if (_balance < _collat + _bankroll) return _balance - _collat;
680         // Profits. Return only _bankroll
681         else return _bankroll;
682     }
683 
684     function bankrolledBy(address _addr)
685         public
686         view
687         returns (uint _amount)
688     {
689         return ledger.balanceOf(_addr);
690     }
691 
692     function bankrollerTable()
693         public
694         view
695         returns (address[], uint[])
696     {
697         return ledger.balances();
698     }
699 }
700 
701 // An interface to MonarchyGame instances.
702 interface IMonarchyGame {
703     function sendPrize(uint _gasLimit) external returns (bool _success, uint _prizeSent);
704     function sendFees() external returns (uint _feesSent);
705     function prize() external view returns(uint);
706     function numOverthrows() external view returns(uint);
707     function fees() external view returns (uint _fees);
708     function monarch() external view returns (address _addr);
709     function isEnded() external view returns (bool _bool);
710     function isPaid() external view returns (bool _bool);
711 }
712 
713 /*
714 
715   MonarchyController manages a list of PredefinedGames.
716   PredefinedGames' parameters are definable by the Admin.
717   These gamess can be started, ended, or refreshed by anyone.
718 
719   Starting games uses the funds in this contract, unless called via
720   .startDefinedGameManually(), in which case it uses the funds sent.
721 
722   All revenues of any started games will come back to this contract.
723 
724   Since this contract inherits Bankrollable, it is able to be funded
725   via the Registry (or by anyone whitelisted). Profits will go to the
726   Treasury, and can be triggered by anyone.
727 
728 */
729 contract MonarchyController is
730     HasDailyLimit,
731     Bankrollable,
732     UsingAdmin,
733     UsingMonarchyFactory
734 {
735     uint constant public version = 1;
736 
737     // just some accounting/stats stuff to keep track of
738     uint public totalFees;
739     uint public totalPrizes;
740     uint public totalOverthrows;
741     IMonarchyGame[] public endedGames;
742 
743     // An admin-controlled index of available games.
744     // Note: Index starts at 1, and is limited to 20.
745     uint public numDefinedGames;
746     mapping (uint => DefinedGame) public definedGames;
747     struct DefinedGame {
748         IMonarchyGame game;     // address of ongoing game (or 0)
749         bool isEnabled;         // if true, can be started
750         string summary;         // definable via editDefinedGame
751         uint initialPrize;      // definable via editDefinedGame
752         uint fee;               // definable via editDefinedGame
753         int prizeIncr;          // definable via editDefinedGame
754         uint reignBlocks;       // definable via editDefinedGame
755         uint initialBlocks;     // definable via editDefinedGame
756     }
757 
758     event Created(uint time);
759     event DailyLimitChanged(uint time, address indexed owner, uint newValue);
760     event Error(uint time, string msg);
761     event DefinedGameEdited(uint time, uint index);
762     event DefinedGameEnabled(uint time, uint index, bool isEnabled);
763     event DefinedGameFailedCreation(uint time, uint index);
764     event GameStarted(uint time, uint indexed index, address indexed addr, uint initialPrize);
765     event GameEnded(uint time, uint indexed index, address indexed addr, address indexed winner);
766     event FeesCollected(uint time, uint amount);
767 
768 
769     constructor(address _registry) 
770         HasDailyLimit(10 ether)
771         Bankrollable(_registry)
772         UsingAdmin(_registry)
773         UsingMonarchyFactory(_registry)
774         public
775     {
776         emit Created(now);
777     }
778 
779     /*************************************************************/
780     /******** OWNER FUNCTIONS ************************************/
781     /*************************************************************/
782 
783     function setDailyLimit(uint _amount)
784         public
785         fromOwner
786     {
787         _setDailyLimit(_amount);
788         emit DailyLimitChanged(now, msg.sender, _amount);
789     }
790 
791 
792     /*************************************************************/
793     /******** ADMIN FUNCTIONS ************************************/
794     /*************************************************************/
795 
796     // allows admin to edit or add an available game
797     function editDefinedGame(
798         uint _index,
799         string _summary,
800         uint _initialPrize,
801         uint _fee,
802         int _prizeIncr,
803         uint _reignBlocks,
804         uint _initialBlocks
805     )
806         public
807         fromAdmin
808         returns (bool _success)
809     {
810         if (_index-1 > numDefinedGames || _index > 20) {
811             emit Error(now, "Index out of bounds.");
812             return;
813         }
814 
815         if (_index-1 == numDefinedGames) numDefinedGames++;
816         definedGames[_index].summary = _summary;
817         definedGames[_index].initialPrize = _initialPrize;
818         definedGames[_index].fee = _fee;
819         definedGames[_index].prizeIncr = _prizeIncr;
820         definedGames[_index].reignBlocks = _reignBlocks;
821         definedGames[_index].initialBlocks = _initialBlocks;
822         emit DefinedGameEdited(now, _index);
823         return true;
824     }
825 
826     function enableDefinedGame(uint _index, bool _bool)
827         public
828         fromAdmin
829         returns (bool _success)
830     {
831         if (_index-1 >= numDefinedGames) {
832             emit Error(now, "Index out of bounds.");
833             return;
834         }
835         definedGames[_index].isEnabled = _bool;
836         emit DefinedGameEnabled(now, _index, _bool);
837         return true;
838     }
839 
840 
841     /*************************************************************/
842     /******* PUBLIC FUNCTIONS ************************************/
843     /*************************************************************/
844 
845     function () public payable {
846          totalFees += msg.value;
847     }
848 
849     // This is called by anyone when a new MonarchyGame should be started.
850     // In reality will only be called by TaskManager.
851     //
852     // Errors if:
853     //      - isEnabled is false (or doesnt exist)
854     //      - game is already started
855     //      - not enough funds
856     //      - PAF.getCollector() points to another address
857     //      - unable to create game
858     function startDefinedGame(uint _index)
859         public
860         returns (address _game)
861     {
862         DefinedGame memory dGame = definedGames[_index];
863         if (_index-1 >= numDefinedGames) {
864             _error("Index out of bounds.");
865             return;
866         }
867         if (dGame.isEnabled == false) {
868             _error("DefinedGame is not enabled.");
869             return;
870         }
871         if (dGame.game != IMonarchyGame(0)) {
872             _error("Game is already started.");
873             return;
874         }
875         if (address(this).balance < dGame.initialPrize) {
876             _error("Not enough funds to start this game.");
877             return;
878         }
879         if (getDailyLimitRemaining() < dGame.initialPrize) {
880             _error("Starting game would exceed daily limit.");
881             return;
882         }
883 
884         // Ensure that if this game is started, revenue comes back to this contract.
885         IMonarchyFactory _mf = getMonarchyFactory();
886         if (_mf.getCollector() != address(this)){
887             _error("MonarchyFactory.getCollector() points to a different contract.");
888             return;
889         }
890 
891         // Try to create game via factory.
892         bool _success = address(_mf).call.value(dGame.initialPrize)(
893             bytes4(keccak256("createGame(uint256,uint256,int256,uint256,uint256)")),
894             dGame.initialPrize,
895             dGame.fee,
896             dGame.prizeIncr,
897             dGame.reignBlocks,
898             dGame.initialBlocks
899         );
900         if (!_success) {
901             emit DefinedGameFailedCreation(now, _index);
902             _error("MonarchyFactory could not create game (invalid params?)");
903             return;
904         }
905 
906         // Get the game, add it to definedGames, and return.
907         _useFromDailyLimit(dGame.initialPrize);
908         _game = _mf.lastCreatedGame();
909         definedGames[_index].game = IMonarchyGame(_game);
910         emit GameStarted(now, _index, _game, dGame.initialPrize);
911         return _game;
912     }
913         // Emits an error with a given message
914         function _error(string _msg)
915             private
916         {
917             emit Error(now, _msg);
918         }
919 
920     function startDefinedGameManually(uint _index)
921         public
922         payable
923         returns (address _game)
924     {
925         // refund if invalid value sent.
926         DefinedGame memory dGame = definedGames[_index];
927         if (msg.value != dGame.initialPrize) {
928             _error("Value sent does not match initialPrize.");
929             require(msg.sender.call.value(msg.value)());
930             return;
931         }
932 
933         // refund if .startDefinedGame fails
934         _game = startDefinedGame(_index);
935         if (_game == address(0)) {
936             require(msg.sender.call.value(msg.value)());
937         }
938     }
939 
940     // Looks at all active defined games and:
941     //  - tells each game to send fees to collector (us)
942     //  - if ended: tries to pay winner, moves to endedGames
943     function refreshGames()
944         public
945         returns (uint _numGamesEnded, uint _feesCollected)
946     {
947         for (uint _i = 1; _i <= numDefinedGames; _i++) {
948             IMonarchyGame _game = definedGames[_i].game;
949             if (_game == IMonarchyGame(0)) continue;
950 
951             // redeem the fees
952             uint _fees = _game.sendFees();
953             _feesCollected += _fees;
954 
955             // attempt to pay winner, update stats, and set game to empty.
956             if (_game.isEnded()) {
957                 // paying the winner can error if the winner uses too much gas
958                 // in that case, they can call .sendPrize() themselves later.
959                 if (!_game.isPaid()) _game.sendPrize(2300);
960                 
961                 // update stats
962                 totalPrizes += _game.prize();
963                 totalOverthrows += _game.numOverthrows();
964 
965                 // clear game, move to endedGames, update return
966                 definedGames[_i].game = IMonarchyGame(0);
967                 endedGames.push(_game);
968                 _numGamesEnded++;
969 
970                 emit GameEnded(now, _i, address(_game), _game.monarch());
971             }
972         }
973         if (_feesCollected > 0) emit FeesCollected(now, _feesCollected);
974         return (_numGamesEnded, _feesCollected);
975     }
976 
977 
978     /*************************************************************/
979     /*********** PUBLIC VIEWS ************************************/
980     /*************************************************************/
981     // IMPLEMENTS: Bankrollable.getCollateral()
982     function getCollateral() public view returns (uint) { return 0; }
983     function getWhitelistOwner() public view returns (address){ return getAdmin(); }
984 
985     function numEndedGames()
986         public
987         view
988         returns (uint)
989     {
990         return endedGames.length;
991     }
992 
993     function numActiveGames()
994         public
995         view
996         returns (uint _count)
997     {
998         for (uint _i = 1; _i <= numDefinedGames; _i++) {
999             if (definedGames[_i].game != IMonarchyGame(0)) _count++;
1000         }
1001     }
1002 
1003     function getNumEndableGames()
1004         public
1005         view
1006         returns (uint _count)
1007     {
1008         for (uint _i = 1; _i <= numDefinedGames; _i++) {
1009             IMonarchyGame _game = definedGames[_i].game;
1010             if (_game == IMonarchyGame(0)) continue;
1011             if (_game.isEnded()) _count++;
1012         }
1013         return _count;
1014     }
1015 
1016     function getFirstStartableIndex()
1017         public
1018         view
1019         returns (uint _index)
1020     {
1021         for (uint _i = 1; _i <= numDefinedGames; _i++) {
1022             if (getIsStartable(_i)) return _i;
1023         }
1024     }
1025 
1026     // Gets total amount of fees that are redeemable if refreshGames() is called.
1027     function getAvailableFees()
1028         public
1029         view
1030         returns (uint _feesAvailable)
1031     {
1032         for (uint _i = 1; _i <= numDefinedGames; _i++) {
1033             if (definedGames[_i].game == IMonarchyGame(0)) continue;
1034             _feesAvailable += definedGames[_i].game.fees();
1035         }
1036         return _feesAvailable;
1037     }
1038 
1039     function recentlyEndedGames(uint _num)
1040         public
1041         view
1042         returns (address[] _addresses)
1043     {
1044         // set _num to Min(_num, _len), initialize the array
1045         uint _len = endedGames.length;
1046         if (_num > _len) _num = _len;
1047         _addresses = new address[](_num);
1048 
1049         // Loop _num times, adding from end of endedGames.
1050         uint _i = 1;
1051         while (_i <= _num) {
1052             _addresses[_i - 1] = endedGames[_len - _i];
1053             _i++;
1054         }
1055     }
1056 
1057     /******** Shorthand access to definedGames **************************/
1058     function getGame(uint _index)
1059         public
1060         view
1061         returns (address)
1062     {
1063         return address(definedGames[_index].game);
1064     }
1065 
1066     function getIsEnabled(uint _index)
1067         public
1068         view
1069         returns (bool)
1070     {
1071         return definedGames[_index].isEnabled;
1072     }
1073 
1074     function getInitialPrize(uint _index)
1075         public
1076         view
1077         returns (uint)
1078     {
1079         return definedGames[_index].initialPrize;
1080     }
1081 
1082     function getIsStartable(uint _index)
1083         public
1084         view
1085         returns (bool _isStartable)
1086     {
1087         DefinedGame memory dGame = definedGames[_index];
1088         if (_index >= numDefinedGames) return;
1089         if (dGame.isEnabled == false) return;
1090         if (dGame.game != IMonarchyGame(0)) return;
1091         if (dGame.initialPrize > address(this).balance) return;
1092         if (dGame.initialPrize > getDailyLimitRemaining()) return;
1093         return true;
1094     }
1095     /******** Shorthand access to definedGames **************************/
1096 }