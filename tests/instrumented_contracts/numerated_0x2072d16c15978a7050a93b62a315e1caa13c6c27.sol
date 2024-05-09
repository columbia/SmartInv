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
85 
86 /******* USING MONARCHYCONTROLLER **************************
87 
88 Gives the inherting contract access to:
89     .getMonarchyController(): returns current IMC instance
90     [modifier] .fromMonarchyController(): requires the sender is current MC.
91 
92 *************************************************/
93 // Returned by .getMonarchyController()
94 interface IMonarchyController {
95     function refreshGames() external returns (uint _numGamesEnded, uint _feesSent);
96     function startDefinedGame(uint _index) external payable returns (address _game);
97     function getFirstStartableIndex() external view returns (uint _index);
98     function getNumEndableGames() external view returns (uint _count);
99     function getAvailableFees() external view returns (uint _feesAvailable);
100     function getInitialPrize(uint _index) external view returns (uint);
101     function getIsStartable(uint _index) external view returns (bool);
102 }
103 
104 contract UsingMonarchyController is
105     UsingRegistry
106 {
107     constructor(address _registry)
108         UsingRegistry(_registry)
109         public
110     {}
111 
112     modifier fromMonarchyController(){
113         require(msg.sender == address(getMonarchyController()));
114         _;
115     }
116 
117     function getMonarchyController()
118         public
119         view
120         returns (IMonarchyController)
121     {
122         return IMonarchyController(addressOf("MONARCHY_CONTROLLER"));
123     }
124 }
125 
126 
127 /******* USING TREASURY **************************
128 
129 Gives the inherting contract access to:
130     .getTreasury(): returns current ITreasury instance
131     [modifier] .fromTreasury(): requires the sender is current Treasury
132 
133 *************************************************/
134 // Returned by .getTreasury()
135 interface ITreasury {
136     function issueDividend() external returns (uint _profits);
137     function profitsSendable() external view returns (uint _profits);
138 }
139 
140 contract UsingTreasury is
141     UsingRegistry
142 {
143     constructor(address _registry)
144         UsingRegistry(_registry)
145         public
146     {}
147 
148     modifier fromTreasury(){
149         require(msg.sender == address(getTreasury()));
150         _;
151     }
152     
153     function getTreasury()
154         public
155         view
156         returns (ITreasury)
157     {
158         return ITreasury(addressOf("TREASURY"));
159     }
160 }
161 
162 /*
163     Exposes the following internal methods:
164         - _useFromDailyLimit(uint)
165         - _setDailyLimit(uint)
166         - getDailyLimit()
167         - getDailyLimitUsed()
168         - getDailyLimitUnused()
169 */
170 contract HasDailyLimit {
171     // squeeze all vars into one storage slot.
172     struct DailyLimitVars {
173         uint112 dailyLimit; // Up to 5e15 * 1e18.
174         uint112 usedToday;  // Up to 5e15 * 1e18.
175         uint32 lastDay;     // Up to the year 11,000,000 AD
176     }
177     DailyLimitVars private vars;
178     uint constant MAX_ALLOWED = 2**112 - 1;
179 
180     constructor(uint _limit) public {
181         _setDailyLimit(_limit);
182     }
183 
184     // Sets the daily limit.
185     function _setDailyLimit(uint _limit) internal {
186         require(_limit <= MAX_ALLOWED);
187         vars.dailyLimit = uint112(_limit);
188     }
189 
190     // Uses the requested amount if its within limit. Or throws.
191     // You should use getDailyLimitRemaining() before calling this.
192     function _useFromDailyLimit(uint _amount) internal {
193         uint _remaining = updateAndGetRemaining();
194         require(_amount <= _remaining);
195         vars.usedToday += uint112(_amount);
196     }
197 
198     // If necessary, resets the day's usage.
199     // Then returns the amount remaining for today.
200     function updateAndGetRemaining() private returns (uint _amtRemaining) {
201         if (today() > vars.lastDay) {
202             vars.usedToday = 0;
203             vars.lastDay = today();
204         }
205         uint112 _usedToday = vars.usedToday;
206         uint112 _dailyLimit = vars.dailyLimit;
207         // This could be negative if _dailyLimit was reduced.
208         return uint(_usedToday >= _dailyLimit ? 0 : _dailyLimit - _usedToday);
209     }
210 
211     // Returns the current day.
212     function today() private view returns (uint32) {
213         return uint32(block.timestamp / 1 days);
214     }
215 
216 
217     /////////////////////////////////////////////////////////////////
218     ////////////// PUBLIC VIEWS /////////////////////////////////////
219     /////////////////////////////////////////////////////////////////
220 
221     function getDailyLimit() public view returns (uint) {
222         return uint(vars.dailyLimit);
223     }
224     function getDailyLimitUsed() public view returns (uint) {
225         return uint(today() > vars.lastDay ? 0 : vars.usedToday);
226     }
227     function getDailyLimitRemaining() public view returns (uint) {
228         uint _used = getDailyLimitUsed();
229         return uint(_used >= vars.dailyLimit ? 0 : vars.dailyLimit - _used);
230     }
231 }
232 
233 
234 /**
235     This is a simple class that maintains a doubly linked list of
236     addresses it has seen. Addresses can be added and removed
237     from the set, and a full list of addresses can be obtained.
238 
239     Methods:
240      - [fromOwner] .add()
241      - [fromOwner] .remove()
242     Views:
243      - .size()
244      - .has()
245      - .addresses()
246 */
247 contract AddressSet {
248     
249     struct Entry {  // Doubly linked list
250         bool exists;
251         address next;
252         address prev;
253     }
254     mapping (address => Entry) public entries;
255 
256     address public owner;
257     modifier fromOwner() { require(msg.sender==owner); _; }
258 
259     // Constructor sets the owner.
260     constructor(address _owner)
261         public
262     {
263         owner = _owner;
264     }
265 
266 
267     /******************************************************/
268     /*************** OWNER METHODS ************************/
269     /******************************************************/
270 
271     function add(address _address)
272         fromOwner
273         public
274         returns (bool _didCreate)
275     {
276         // Do not allow the adding of HEAD.
277         if (_address == address(0)) return;
278         Entry storage entry = entries[_address];
279         // If already exists, do nothing. Otherwise set it.
280         if (entry.exists) return;
281         else entry.exists = true;
282 
283         // Replace first entry with this one.
284         // Before: HEAD <-> X <-> Y
285         // After: HEAD <-> THIS <-> X <-> Y
286         // do: THIS.NEXT = [0].next; [0].next.prev = THIS; [0].next = THIS; THIS.prev = 0;
287         Entry storage HEAD = entries[0x0];
288         entry.next = HEAD.next;
289         entries[HEAD.next].prev = _address;
290         HEAD.next = _address;
291         return true;
292     }
293 
294     function remove(address _address)
295         fromOwner
296         public
297         returns (bool _didExist)
298     {
299         // Do not allow the removal of HEAD.
300         if (_address == address(0)) return;
301         Entry storage entry = entries[_address];
302         // If it doesn't exist already, there is nothing to do.
303         if (!entry.exists) return;
304 
305         // Stitch together next and prev, delete entry.
306         // Before: X <-> THIS <-> Y
307         // After: X <-> Y
308         // do: THIS.next.prev = this.prev; THIS.prev.next = THIS.next;
309         entries[entry.prev].next = entry.next;
310         entries[entry.next].prev = entry.prev;
311         delete entries[_address];
312         return true;
313     }
314 
315 
316     /******************************************************/
317     /*************** PUBLIC VIEWS *************************/
318     /******************************************************/
319 
320     function size()
321         public
322         view
323         returns (uint _size)
324     {
325         // Loop once to get the total count.
326         Entry memory _curEntry = entries[0x0];
327         while (_curEntry.next > 0) {
328             _curEntry = entries[_curEntry.next];
329             _size++;
330         }
331         return _size;
332     }
333 
334     function has(address _address)
335         public
336         view
337         returns (bool _exists)
338     {
339         return entries[_address].exists;
340     }
341 
342     function addresses()
343         public
344         view
345         returns (address[] _addresses)
346     {
347         // Populate names and addresses
348         uint _size = size();
349         _addresses = new address[](_size);
350         // Iterate forward through all entries until the end.
351         uint _i = 0;
352         Entry memory _curEntry = entries[0x0];
353         while (_curEntry.next > 0) {
354             _addresses[_i] = _curEntry.next;
355             _curEntry = entries[_curEntry.next];
356             _i++;
357         }
358         return _addresses;
359     }
360 }
361 
362 /**
363     This is a simple class that maintains a doubly linked list of
364     address => uint amounts. Address balances can be added to 
365     or removed from via add() and subtract(). All balances can
366     be obtain by calling balances(). If an address has a 0 amount,
367     it is removed from the Ledger.
368 
369     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
370           use to track Ether balances.
371 
372     Public methods:
373       - [fromOwner] add()
374       - [fromOwner] subtract()
375     Public views:
376       - total()
377       - size()
378       - balanceOf()
379       - balances()
380       - entries() [to manually iterate]
381 */
382 contract Ledger {
383     uint public total;      // Total amount in Ledger
384 
385     struct Entry {          // Doubly linked list tracks amount per address
386         uint balance;
387         address next;
388         address prev;
389     }
390     mapping (address => Entry) public entries;
391 
392     address public owner;
393     modifier fromOwner() { require(msg.sender==owner); _; }
394 
395     // Constructor sets the owner
396     constructor(address _owner)
397         public
398     {
399         owner = _owner;
400     }
401 
402 
403     /******************************************************/
404     /*************** OWNER METHODS ************************/
405     /******************************************************/
406 
407     function add(address _address, uint _amt)
408         fromOwner
409         public
410     {
411         if (_address == address(0) || _amt == 0) return;
412         Entry storage entry = entries[_address];
413 
414         // If new entry, replace first entry with this one.
415         if (entry.balance == 0) {
416             entry.next = entries[0x0].next;
417             entries[entries[0x0].next].prev = _address;
418             entries[0x0].next = _address;
419         }
420         // Update stats.
421         total += _amt;
422         entry.balance += _amt;
423     }
424 
425     function subtract(address _address, uint _amt)
426         fromOwner
427         public
428         returns (uint _amtRemoved)
429     {
430         if (_address == address(0) || _amt == 0) return;
431         Entry storage entry = entries[_address];
432 
433         uint _maxAmt = entry.balance;
434         if (_maxAmt == 0) return;
435         
436         if (_amt >= _maxAmt) {
437             // Subtract the max amount, and delete entry.
438             total -= _maxAmt;
439             entries[entry.prev].next = entry.next;
440             entries[entry.next].prev = entry.prev;
441             delete entries[_address];
442             return _maxAmt;
443         } else {
444             // Subtract the amount from entry.
445             total -= _amt;
446             entry.balance -= _amt;
447             return _amt;
448         }
449     }
450 
451 
452     /******************************************************/
453     /*************** PUBLIC VIEWS *************************/
454     /******************************************************/
455 
456     function size()
457         public
458         view
459         returns (uint _size)
460     {
461         // Loop once to get the total count.
462         Entry memory _curEntry = entries[0x0];
463         while (_curEntry.next > 0) {
464             _curEntry = entries[_curEntry.next];
465             _size++;
466         }
467         return _size;
468     }
469 
470     function balanceOf(address _address)
471         public
472         view
473         returns (uint _balance)
474     {
475         return entries[_address].balance;
476     }
477 
478     function balances()
479         public
480         view
481         returns (address[] _addresses, uint[] _balances)
482     {
483         // Populate names and addresses
484         uint _size = size();
485         _addresses = new address[](_size);
486         _balances = new uint[](_size);
487         uint _i = 0;
488         Entry memory _curEntry = entries[0x0];
489         while (_curEntry.next > 0) {
490             _addresses[_i] = _curEntry.next;
491             _balances[_i] = entries[_curEntry.next].balance;
492             _curEntry = entries[_curEntry.next];
493             _i++;
494         }
495         return (_addresses, _balances);
496     }
497 }
498 
499 /**
500   A simple class that manages bankroll, and maintains collateral.
501   This class only ever sends profits the Treasury. No exceptions.
502 
503   - Anybody can add funding (according to whitelist)
504   - Anybody can tell profits (balance - (funding + collateral)) to go to Treasury.
505   - Anyone can remove their funding, so long as balance >= collateral.
506   - Whitelist is managed by getWhitelistOwner() -- typically Admin.
507 
508   Exposes the following:
509     Public Methods
510      - addBankroll
511      - removeBankroll
512      - sendProfits
513     Public Views
514      - getCollateral
515      - profits
516      - profitsSent
517      - profitsTotal
518      - bankroll
519      - bankrollAvailable
520      - bankrolledBy
521      - bankrollerTable
522 */
523 contract Bankrollable is
524     UsingTreasury
525 {   
526     // How much profits have been sent. 
527     uint public profitsSent;
528     // Ledger keeps track of who has bankrolled us, and for how much
529     Ledger public ledger;
530     // This is a copy of ledger.total(), to save gas in .bankrollAvailable()
531     uint public bankroll;
532     // This is the whitelist of who can call .addBankroll()
533     AddressSet public whitelist;
534 
535     modifier fromWhitelistOwner(){
536         require(msg.sender == getWhitelistOwner());
537         _;
538     }
539 
540     event BankrollAdded(uint time, address indexed bankroller, uint amount, uint bankroll);
541     event BankrollRemoved(uint time, address indexed bankroller, uint amount, uint bankroll);
542     event ProfitsSent(uint time, address indexed treasury, uint amount);
543     event AddedToWhitelist(uint time, address indexed addr, address indexed wlOwner);
544     event RemovedFromWhitelist(uint time, address indexed addr, address indexed wlOwner);
545 
546     // Constructor creates the ledger and whitelist, with self as owner.
547     constructor(address _registry)
548         UsingTreasury(_registry)
549         public
550     {
551         ledger = new Ledger(this);
552         whitelist = new AddressSet(this);
553     }
554 
555 
556     /*****************************************************/
557     /************** WHITELIST MGMT ***********************/
558     /*****************************************************/    
559 
560     function addToWhitelist(address _addr)
561         fromWhitelistOwner
562         public
563     {
564         bool _didAdd = whitelist.add(_addr);
565         if (_didAdd) emit AddedToWhitelist(now, _addr, msg.sender);
566     }
567 
568     function removeFromWhitelist(address _addr)
569         fromWhitelistOwner
570         public
571     {
572         bool _didRemove = whitelist.remove(_addr);
573         if (_didRemove) emit RemovedFromWhitelist(now, _addr, msg.sender);
574     }
575 
576     /*****************************************************/
577     /************** PUBLIC FUNCTIONS *********************/
578     /*****************************************************/
579 
580     // Bankrollable contracts should be payable (to receive revenue)
581     function () public payable {}
582 
583     // Increase funding by whatever value is sent
584     function addBankroll()
585         public
586         payable 
587     {
588         require(whitelist.size()==0 || whitelist.has(msg.sender));
589         ledger.add(msg.sender, msg.value);
590         bankroll = ledger.total();
591         emit BankrollAdded(now, msg.sender, msg.value, bankroll);
592     }
593 
594     // Removes up to _amount from Ledger, and sends it to msg.sender._callbackFn
595     function removeBankroll(uint _amount, string _callbackFn)
596         public
597         returns (uint _recalled)
598     {
599         // cap amount at the balance minus collateral, or nothing at all.
600         address _bankroller = msg.sender;
601         uint _collateral = getCollateral();
602         uint _balance = address(this).balance;
603         uint _available = _balance > _collateral ? _balance - _collateral : 0;
604         if (_amount > _available) _amount = _available;
605 
606         // Try to remove _amount from ledger, get actual _amount removed.
607         _amount = ledger.subtract(_bankroller, _amount);
608         bankroll = ledger.total();
609         if (_amount == 0) return;
610 
611         bytes4 _sig = bytes4(keccak256(_callbackFn));
612         require(_bankroller.call.value(_amount)(_sig));
613         emit BankrollRemoved(now, _bankroller, _amount, bankroll);
614         return _amount;
615     }
616 
617     // Send any excess profits to treasury.
618     function sendProfits()
619         public
620         returns (uint _profits)
621     {
622         int _p = profits();
623         if (_p <= 0) return;
624         _profits = uint(_p);
625         profitsSent += _profits;
626         // Send profits to Treasury
627         address _tr = getTreasury();
628         require(_tr.call.value(_profits)());
629         emit ProfitsSent(now, _tr, _profits);
630     }
631 
632 
633     /*****************************************************/
634     /************** PUBLIC VIEWS *************************/
635     /*****************************************************/
636 
637     // Function must be overridden by inheritors to ensure collateral is kept.
638     function getCollateral()
639         public
640         view
641         returns (uint _amount);
642 
643     // Function must be overridden by inheritors to enable whitelist control.
644     function getWhitelistOwner()
645         public
646         view
647         returns (address _addr);
648 
649     // Profits are the difference between balance and threshold
650     function profits()
651         public
652         view
653         returns (int _profits)
654     {
655         int _balance = int(address(this).balance);
656         int _threshold = int(bankroll + getCollateral());
657         return _balance - _threshold;
658     }
659 
660     // How profitable this contract is, overall
661     function profitsTotal()
662         public
663         view
664         returns (int _profits)
665     {
666         return int(profitsSent) + profits();
667     }
668 
669     // Returns the amount that can currently be bankrolled.
670     //   - 0 if balance < collateral
671     //   - If profits: full bankroll
672     //   - If no profits: remaning bankroll: balance - collateral
673     function bankrollAvailable()
674         public
675         view
676         returns (uint _amount)
677     {
678         uint _balance = address(this).balance;
679         uint _bankroll = bankroll;
680         uint _collat = getCollateral();
681         // Balance is below collateral!
682         if (_balance <= _collat) return 0;
683         // No profits, but we have a balance over collateral.
684         else if (_balance < _collat + _bankroll) return _balance - _collat;
685         // Profits. Return only _bankroll
686         else return _bankroll;
687     }
688 
689     function bankrolledBy(address _addr)
690         public
691         view
692         returns (uint _amount)
693     {
694         return ledger.balanceOf(_addr);
695     }
696 
697     function bankrollerTable()
698         public
699         view
700         returns (address[], uint[])
701     {
702         return ledger.balances();
703     }
704 }
705 
706 /*
707   This is a simple class that pays anybody to execute methods on
708   other contracts. The reward amounts are configurable by the Admin,
709   with some hard limits to prevent the Admin from pilfering. The
710   contract has a DailyLimit, so even if the Admin is compromised,
711   the contract cannot be drained.
712 
713   TaskManager is Bankrollable, meaning it can accept bankroll from 
714   the Treasury (and have it recalled).  However, it will never generate
715   profits. On rare occasion, new funds will need to be added to ensure
716   rewards can be paid.
717 
718   This class is divided into sections that pay rewards for a specific
719   contract or set of contracts. Any time a new contract is added to
720   the system that requires Tasks, this file will be updated and 
721   redeployed.
722 */
723 interface _IBankrollable {
724     function sendProfits() external returns (uint _profits);
725     function profits() external view returns (int _profits);
726 }
727 contract TaskManager is
728     HasDailyLimit,
729     Bankrollable,
730     UsingAdmin,
731     UsingMonarchyController
732 {
733     uint constant public version = 1;
734     uint public totalRewarded;
735 
736     // Number of basis points to reward caller.
737     // 1 = .01%, 10 = .1%, 100 = 1%. Capped at .1%.
738     uint public issueDividendRewardBips;
739     // Number of basis points to reward caller.
740     // 1 = .01%, 10 = .1%, 100 = 1%. Capped at 1%.
741     uint public sendProfitsRewardBips;
742     // How much to pay for games to start and end.
743     // These values are capped at 1 Ether.
744     uint public monarchyStartReward;
745     uint public monarchyEndReward;
746     
747     event Created(uint time);
748     event DailyLimitChanged(uint time, address indexed owner, uint newValue);
749     // admin events
750     event IssueDividendRewardChanged(uint time, address indexed admin, uint newValue);
751     event SendProfitsRewardChanged(uint time, address indexed admin, uint newValue);
752     event MonarchyRewardsChanged(uint time, address indexed admin, uint startReward, uint endReward);
753     // base events
754     event TaskError(uint time, address indexed caller, string msg);
755     event RewardSuccess(uint time, address indexed caller, uint reward);
756     event RewardFailure(uint time, address indexed caller, uint reward, string msg);
757     // task events
758     event IssueDividendSuccess(uint time, address indexed treasury, uint profitsSent);
759     event SendProfitsSuccess(uint time, address indexed bankrollable, uint profitsSent);
760     event MonarchyGameStarted(uint time, address indexed addr, uint initialPrize);
761     event MonarchyGamesRefreshed(uint time, uint numEnded, uint feesCollected);
762 
763     // Construct sets the registry and instantiates inherited classes.
764     constructor(address _registry)
765         public
766         HasDailyLimit(1 ether)
767         Bankrollable(_registry)
768         UsingAdmin(_registry)
769         UsingMonarchyController(_registry)
770     {
771         emit Created(now);
772     }
773 
774 
775     ///////////////////////////////////////////////////////////////////
776     ////////// OWNER FUNCTIONS ////////////////////////////////////////
777     ///////////////////////////////////////////////////////////////////
778 
779     function setDailyLimit(uint _amount)
780         public
781         fromOwner
782     {
783         _setDailyLimit(_amount);
784         emit DailyLimitChanged(now, msg.sender, _amount);
785     }
786 
787 
788     ///////////////////////////////////////////////////////////////////
789     ////////// ADMIN FUNCTIONS ////////////////////////////////////////
790     ///////////////////////////////////////////////////////////////////
791 
792     function setIssueDividendReward(uint _bips)
793         public
794         fromAdmin
795     {
796         require(_bips <= 10);
797         issueDividendRewardBips = _bips;
798         emit IssueDividendRewardChanged(now, msg.sender, _bips);
799     }
800 
801     function setSendProfitsReward(uint _bips)
802         public
803         fromAdmin
804     {
805         require(_bips <= 100);
806         sendProfitsRewardBips = _bips;
807         emit SendProfitsRewardChanged(now, msg.sender, _bips);
808     }
809 
810     function setMonarchyRewards(uint _startReward, uint _endReward)
811         public
812         fromAdmin
813     {
814         require(_startReward <= 1 ether);
815         require(_endReward <= 1 ether);
816         monarchyStartReward = _startReward;
817         monarchyEndReward = _endReward;
818         emit MonarchyRewardsChanged(now, msg.sender, _startReward, _endReward);
819     }
820 
821 
822     ///////////////////////////////////////////////////////////////////
823     ////////// ISSUE DIVIDEND TASK ////////////////////////////////////
824     ///////////////////////////////////////////////////////////////////
825 
826     function doIssueDividend()
827         public
828         returns (uint _reward, uint _profits)
829     {
830         // get amount of profits
831         ITreasury _tr = getTreasury();
832         _profits = _tr.profitsSendable();
833         // quit if no profits to send.
834         if (_profits == 0) {
835             _taskError("No profits to send.");
836             return;
837         }
838         // call .issueDividend(), use return value to compute _reward
839         _profits = _tr.issueDividend();
840         if (_profits == 0) {
841             _taskError("No profits were sent.");
842             return;
843         } else {
844             emit IssueDividendSuccess(now, address(_tr), _profits);
845         }
846         // send reward
847         _reward = (_profits * issueDividendRewardBips) / 10000;
848         _sendReward(_reward);
849     }
850 
851     // Returns reward and profits
852     function issueDividendReward()
853         public
854         view
855         returns (uint _reward, uint _profits)
856     {
857         _profits = getTreasury().profitsSendable();
858         _reward = _cappedReward((_profits * issueDividendRewardBips) / 10000);
859     }
860 
861 
862     ///////////////////////////////////////////////////////////////////
863     ////////// SEND PROFITS TASKS /////////////////////////////////////
864     ///////////////////////////////////////////////////////////////////
865 
866     function doSendProfits(address _bankrollable)
867         public
868         returns (uint _reward, uint _profits)
869     {
870         // Call .sendProfits(). Look for Treasury balance to change.
871         ITreasury _tr = getTreasury();
872         uint _oldTrBalance = address(_tr).balance;
873         _IBankrollable(_bankrollable).sendProfits();
874         uint _newTrBalance = address(_tr).balance;
875 
876         // Quit if no profits. Otherwise compute profits.
877         if (_newTrBalance <= _oldTrBalance) {
878             _taskError("No profits were sent.");
879             return;
880         } else {
881             _profits = _newTrBalance - _oldTrBalance;
882             emit SendProfitsSuccess(now, _bankrollable, _profits);
883         }
884         
885         // Cap reward to current balance (or send will fail)
886         _reward = (_profits * sendProfitsRewardBips) / 10000;
887         _sendReward(_reward);
888     }
889 
890     // Returns an estimate of profits to send, and reward.
891     function sendProfitsReward(address _bankrollable)
892         public
893         view
894         returns (uint _reward, uint _profits)
895     {
896         int _p = _IBankrollable(_bankrollable).profits();
897         if (_p <= 0) return;
898         _profits = uint(_p);
899         _reward = _cappedReward((_profits * sendProfitsRewardBips) / 10000);
900     }
901 
902 
903     ///////////////////////////////////////////////////////////////////
904     ////////// MONARCHY TASKS /////////////////////////////////////////
905     ///////////////////////////////////////////////////////////////////
906 
907     // Try to start monarchy game, reward upon success.
908     function startMonarchyGame(uint _index)
909         public
910     {
911         // Don't bother trying if it's not startable
912         IMonarchyController _mc = getMonarchyController();
913         if (!_mc.getIsStartable(_index)){
914             _taskError("Game is not currently startable.");
915             return;
916         }
917 
918         // Try to start the game. This may fail.
919         address _game = _mc.startDefinedGame(_index);
920         if (_game == address(0)) {
921             _taskError("MonarchyConroller.startDefinedGame() failed.");
922             return;
923         } else {
924             emit MonarchyGameStarted(now, _game, _mc.getInitialPrize(_index));   
925         }
926 
927         // Reward
928         _sendReward(monarchyStartReward);
929     }
930 
931     // Return the _reward and _index of the first startable MonarchyGame
932     function startMonarchyGameReward()
933         public
934         view
935         returns (uint _reward, uint _index)
936     {
937         IMonarchyController _mc = getMonarchyController();
938         _index = _mc.getFirstStartableIndex();
939         if (_index > 0) _reward = _cappedReward(monarchyStartReward);
940     }
941 
942 
943     // Invoke .refreshGames() and pay reward on number of games ended.
944     function refreshMonarchyGames()
945         public
946     {
947         // do the call
948         uint _numGamesEnded;
949         uint _feesCollected;
950         (_numGamesEnded, _feesCollected) = getMonarchyController().refreshGames();
951         emit MonarchyGamesRefreshed(now, _numGamesEnded, _feesCollected);
952 
953         if (_numGamesEnded == 0) {
954             _taskError("No games ended.");
955         } else {
956             _sendReward(_numGamesEnded * monarchyEndReward);   
957         }
958     }
959     
960     // Return a reward for each MonarchyGame that will end
961     function refreshMonarchyGamesReward()
962         public
963         view
964         returns (uint _reward, uint _numEndable)
965     {
966         IMonarchyController _mc = getMonarchyController();
967         _numEndable = _mc.getNumEndableGames();
968         _reward = _cappedReward(_numEndable * monarchyEndReward);
969     }
970 
971 
972     ///////////////////////////////////////////////////////////////////////
973     /////////////////// PRIVATE FUNCTIONS /////////////////////////////////
974     ///////////////////////////////////////////////////////////////////////
975 
976     // Called when task is unable to execute.
977     function _taskError(string _msg) private {
978         emit TaskError(now, msg.sender, _msg);
979     }
980 
981     // Sends a capped amount of _reward to the msg.sender, and emits proper event.
982     function _sendReward(uint _reward) private {
983         // Limit the reward to balance or dailyLimitRemaining
984         uint _amount = _cappedReward(_reward);
985         if (_reward > 0 && _amount == 0) {
986             emit RewardFailure(now, msg.sender, _amount, "Not enough funds, or daily limit reached.");
987             return;
988         }
989 
990         // Attempt to send it (even if _reward was 0)
991         if (msg.sender.call.value(_amount)()) {
992             _useFromDailyLimit(_amount);
993             totalRewarded += _amount;
994             emit RewardSuccess(now, msg.sender, _amount);
995         } else {
996             emit RewardFailure(now, msg.sender, _amount, "Reward rejected by recipient (out of gas, or revert).");
997         }
998     }
999 
1000     // This caps the reward amount to the minimum of (reward, balance, dailyLimitRemaining)
1001     function _cappedReward(uint _reward) private view returns (uint) {
1002         uint _balance = address(this).balance;
1003         uint _remaining = getDailyLimitRemaining();
1004         if (_reward > _balance) _reward = _balance;
1005         if (_reward > _remaining) _reward = _remaining;
1006         return _reward;
1007     }
1008 
1009     // IMPLEMENT BANKROLLABLE FUNCTIONS
1010     function getCollateral() public view returns (uint) {}
1011     function getWhitelistOwner() public view returns (address){ return getAdmin(); }
1012 }