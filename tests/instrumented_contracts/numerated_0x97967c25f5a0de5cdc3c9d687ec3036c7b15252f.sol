1 pragma solidity ^0.4.23;
2 
3 // https://www.pennyether.com
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
58 
59 /******* USING ADMIN ***********************
60 
61 Gives the inherting contract access to:
62     .getAdmin(): returns the current address of the admin
63     [modifier] .fromAdmin: requires the sender is the admin
64 
65 *************************************************/
66 contract UsingAdmin is
67     UsingRegistry
68 {
69     constructor(address _registry)
70         UsingRegistry(_registry)
71         public
72     {}
73 
74     modifier fromAdmin(){
75         require(msg.sender == getAdmin());
76         _;
77     }
78     
79     function getAdmin()
80         public
81         constant
82         returns (address _addr)
83     {
84         return addressOf("ADMIN");
85     }
86 }
87 
88 /******* USING TREASURY **************************
89 
90 Gives the inherting contract access to:
91     .getTreasury(): returns current ITreasury instance
92     [modifier] .fromTreasury(): requires the sender is current Treasury
93 
94 *************************************************/
95 // Returned by .getTreasury()
96 interface ITreasury {
97     function issueDividend() external returns (uint _profits);
98     function profitsSendable() external view returns (uint _profits);
99 }
100 
101 contract UsingTreasury is
102     UsingRegistry
103 {
104     constructor(address _registry)
105         UsingRegistry(_registry)
106         public
107     {}
108 
109     modifier fromTreasury(){
110         require(msg.sender == address(getTreasury()));
111         _;
112     }
113     
114     function getTreasury()
115         public
116         view
117         returns (ITreasury)
118     {
119         return ITreasury(addressOf("TREASURY"));
120     }
121 }
122 
123 
124 /**
125     This is a simple class that maintains a doubly linked list of
126     address => uint amounts. Address balances can be added to 
127     or removed from via add() and subtract(). All balances can
128     be obtain by calling balances(). If an address has a 0 amount,
129     it is removed from the Ledger.
130 
131     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
132           use to track Ether balances.
133 
134     Public methods:
135       - [fromOwner] add()
136       - [fromOwner] subtract()
137     Public views:
138       - total()
139       - size()
140       - balanceOf()
141       - balances()
142       - entries() [to manually iterate]
143 */
144 contract Ledger {
145     uint public total;      // Total amount in Ledger
146 
147     struct Entry {          // Doubly linked list tracks amount per address
148         uint balance;
149         address next;
150         address prev;
151     }
152     mapping (address => Entry) public entries;
153 
154     address public owner;
155     modifier fromOwner() { require(msg.sender==owner); _; }
156 
157     // Constructor sets the owner
158     constructor(address _owner)
159         public
160     {
161         owner = _owner;
162     }
163 
164 
165     /******************************************************/
166     /*************** OWNER METHODS ************************/
167     /******************************************************/
168 
169     function add(address _address, uint _amt)
170         fromOwner
171         public
172     {
173         if (_address == address(0) || _amt == 0) return;
174         Entry storage entry = entries[_address];
175 
176         // If new entry, replace first entry with this one.
177         if (entry.balance == 0) {
178             entry.next = entries[0x0].next;
179             entries[entries[0x0].next].prev = _address;
180             entries[0x0].next = _address;
181         }
182         // Update stats.
183         total += _amt;
184         entry.balance += _amt;
185     }
186 
187     function subtract(address _address, uint _amt)
188         fromOwner
189         public
190         returns (uint _amtRemoved)
191     {
192         if (_address == address(0) || _amt == 0) return;
193         Entry storage entry = entries[_address];
194 
195         uint _maxAmt = entry.balance;
196         if (_maxAmt == 0) return;
197         
198         if (_amt >= _maxAmt) {
199             // Subtract the max amount, and delete entry.
200             total -= _maxAmt;
201             entries[entry.prev].next = entry.next;
202             entries[entry.next].prev = entry.prev;
203             delete entries[_address];
204             return _maxAmt;
205         } else {
206             // Subtract the amount from entry.
207             total -= _amt;
208             entry.balance -= _amt;
209             return _amt;
210         }
211     }
212 
213 
214     /******************************************************/
215     /*************** PUBLIC VIEWS *************************/
216     /******************************************************/
217 
218     function size()
219         public
220         view
221         returns (uint _size)
222     {
223         // Loop once to get the total count.
224         Entry memory _curEntry = entries[0x0];
225         while (_curEntry.next > 0) {
226             _curEntry = entries[_curEntry.next];
227             _size++;
228         }
229         return _size;
230     }
231 
232     function balanceOf(address _address)
233         public
234         view
235         returns (uint _balance)
236     {
237         return entries[_address].balance;
238     }
239 
240     function balances()
241         public
242         view
243         returns (address[] _addresses, uint[] _balances)
244     {
245         // Populate names and addresses
246         uint _size = size();
247         _addresses = new address[](_size);
248         _balances = new uint[](_size);
249         uint _i = 0;
250         Entry memory _curEntry = entries[0x0];
251         while (_curEntry.next > 0) {
252             _addresses[_i] = _curEntry.next;
253             _balances[_i] = entries[_curEntry.next].balance;
254             _curEntry = entries[_curEntry.next];
255             _i++;
256         }
257         return (_addresses, _balances);
258     }
259 }
260 
261 
262 /**
263     This is a simple class that maintains a doubly linked list of
264     addresses it has seen. Addresses can be added and removed
265     from the set, and a full list of addresses can be obtained.
266 
267     Methods:
268      - [fromOwner] .add()
269      - [fromOwner] .remove()
270     Views:
271      - .size()
272      - .has()
273      - .addresses()
274 */
275 contract AddressSet {
276     
277     struct Entry {  // Doubly linked list
278         bool exists;
279         address next;
280         address prev;
281     }
282     mapping (address => Entry) public entries;
283 
284     address public owner;
285     modifier fromOwner() { require(msg.sender==owner); _; }
286 
287     // Constructor sets the owner.
288     constructor(address _owner)
289         public
290     {
291         owner = _owner;
292     }
293 
294 
295     /******************************************************/
296     /*************** OWNER METHODS ************************/
297     /******************************************************/
298 
299     function add(address _address)
300         fromOwner
301         public
302         returns (bool _didCreate)
303     {
304         // Do not allow the adding of HEAD.
305         if (_address == address(0)) return;
306         Entry storage entry = entries[_address];
307         // If already exists, do nothing. Otherwise set it.
308         if (entry.exists) return;
309         else entry.exists = true;
310 
311         // Replace first entry with this one.
312         // Before: HEAD <-> X <-> Y
313         // After: HEAD <-> THIS <-> X <-> Y
314         // do: THIS.NEXT = [0].next; [0].next.prev = THIS; [0].next = THIS; THIS.prev = 0;
315         Entry storage HEAD = entries[0x0];
316         entry.next = HEAD.next;
317         entries[HEAD.next].prev = _address;
318         HEAD.next = _address;
319         return true;
320     }
321 
322     function remove(address _address)
323         fromOwner
324         public
325         returns (bool _didExist)
326     {
327         // Do not allow the removal of HEAD.
328         if (_address == address(0)) return;
329         Entry storage entry = entries[_address];
330         // If it doesn't exist already, there is nothing to do.
331         if (!entry.exists) return;
332 
333         // Stitch together next and prev, delete entry.
334         // Before: X <-> THIS <-> Y
335         // After: X <-> Y
336         // do: THIS.next.prev = this.prev; THIS.prev.next = THIS.next;
337         entries[entry.prev].next = entry.next;
338         entries[entry.next].prev = entry.prev;
339         delete entries[_address];
340         return true;
341     }
342 
343 
344     /******************************************************/
345     /*************** PUBLIC VIEWS *************************/
346     /******************************************************/
347 
348     function size()
349         public
350         view
351         returns (uint _size)
352     {
353         // Loop once to get the total count.
354         Entry memory _curEntry = entries[0x0];
355         while (_curEntry.next > 0) {
356             _curEntry = entries[_curEntry.next];
357             _size++;
358         }
359         return _size;
360     }
361 
362     function has(address _address)
363         public
364         view
365         returns (bool _exists)
366     {
367         return entries[_address].exists;
368     }
369 
370     function addresses()
371         public
372         view
373         returns (address[] _addresses)
374     {
375         // Populate names and addresses
376         uint _size = size();
377         _addresses = new address[](_size);
378         // Iterate forward through all entries until the end.
379         uint _i = 0;
380         Entry memory _curEntry = entries[0x0];
381         while (_curEntry.next > 0) {
382             _addresses[_i] = _curEntry.next;
383             _curEntry = entries[_curEntry.next];
384             _i++;
385         }
386         return _addresses;
387     }
388 }
389 
390 /**
391   A simple class that manages bankroll, and maintains collateral.
392   This class only ever sends profits the Treasury. No exceptions.
393 
394   - Anybody can add funding (according to whitelist)
395   - Anybody can tell profits (balance - (funding + collateral)) to go to Treasury.
396   - Anyone can remove their funding, so long as balance >= collateral.
397   - Whitelist is managed by getWhitelistOwner() -- typically Admin.
398 
399   Exposes the following:
400     Public Methods
401      - addBankroll
402      - removeBankroll
403      - sendProfits
404     Public Views
405      - getCollateral
406      - profits
407      - profitsSent
408      - profitsTotal
409      - bankroll
410      - bankrollAvailable
411      - bankrolledBy
412      - bankrollerTable
413 */
414 contract Bankrollable is
415     UsingTreasury
416 {   
417     // How much profits have been sent. 
418     uint public profitsSent;
419     // Ledger keeps track of who has bankrolled us, and for how much
420     Ledger public ledger;
421     // This is a copy of ledger.total(), to save gas in .bankrollAvailable()
422     uint public bankroll;
423     // This is the whitelist of who can call .addBankroll()
424     AddressSet public whitelist;
425 
426     modifier fromWhitelistOwner(){
427         require(msg.sender == getWhitelistOwner());
428         _;
429     }
430 
431     event BankrollAdded(uint time, address indexed bankroller, uint amount, uint bankroll);
432     event BankrollRemoved(uint time, address indexed bankroller, uint amount, uint bankroll);
433     event ProfitsSent(uint time, address indexed treasury, uint amount);
434     event AddedToWhitelist(uint time, address indexed addr, address indexed wlOwner);
435     event RemovedFromWhitelist(uint time, address indexed addr, address indexed wlOwner);
436 
437     // Constructor creates the ledger and whitelist, with self as owner.
438     constructor(address _registry)
439         UsingTreasury(_registry)
440         public
441     {
442         ledger = new Ledger(this);
443         whitelist = new AddressSet(this);
444     }
445 
446 
447     /*****************************************************/
448     /************** WHITELIST MGMT ***********************/
449     /*****************************************************/    
450 
451     function addToWhitelist(address _addr)
452         fromWhitelistOwner
453         public
454     {
455         bool _didAdd = whitelist.add(_addr);
456         if (_didAdd) emit AddedToWhitelist(now, _addr, msg.sender);
457     }
458 
459     function removeFromWhitelist(address _addr)
460         fromWhitelistOwner
461         public
462     {
463         bool _didRemove = whitelist.remove(_addr);
464         if (_didRemove) emit RemovedFromWhitelist(now, _addr, msg.sender);
465     }
466 
467     /*****************************************************/
468     /************** PUBLIC FUNCTIONS *********************/
469     /*****************************************************/
470 
471     // Bankrollable contracts should be payable (to receive revenue)
472     function () public payable {}
473 
474     // Increase funding by whatever value is sent
475     function addBankroll()
476         public
477         payable 
478     {
479         require(whitelist.size()==0 || whitelist.has(msg.sender));
480         ledger.add(msg.sender, msg.value);
481         bankroll = ledger.total();
482         emit BankrollAdded(now, msg.sender, msg.value, bankroll);
483     }
484 
485     // Removes up to _amount from Ledger, and sends it to msg.sender._callbackFn
486     function removeBankroll(uint _amount, string _callbackFn)
487         public
488         returns (uint _recalled)
489     {
490         // cap amount at the balance minus collateral, or nothing at all.
491         address _bankroller = msg.sender;
492         uint _collateral = getCollateral();
493         uint _balance = address(this).balance;
494         uint _available = _balance > _collateral ? _balance - _collateral : 0;
495         if (_amount > _available) _amount = _available;
496 
497         // Try to remove _amount from ledger, get actual _amount removed.
498         _amount = ledger.subtract(_bankroller, _amount);
499         bankroll = ledger.total();
500         if (_amount == 0) return;
501 
502         bytes4 _sig = bytes4(keccak256(_callbackFn));
503         require(_bankroller.call.value(_amount)(_sig));
504         emit BankrollRemoved(now, _bankroller, _amount, bankroll);
505         return _amount;
506     }
507 
508     // Send any excess profits to treasury.
509     function sendProfits()
510         public
511         returns (uint _profits)
512     {
513         int _p = profits();
514         if (_p <= 0) return;
515         _profits = uint(_p);
516         profitsSent += _profits;
517         // Send profits to Treasury
518         address _tr = getTreasury();
519         require(_tr.call.value(_profits)());
520         emit ProfitsSent(now, _tr, _profits);
521     }
522 
523 
524     /*****************************************************/
525     /************** PUBLIC VIEWS *************************/
526     /*****************************************************/
527 
528     // Function must be overridden by inheritors to ensure collateral is kept.
529     function getCollateral()
530         public
531         view
532         returns (uint _amount);
533 
534     // Function must be overridden by inheritors to enable whitelist control.
535     function getWhitelistOwner()
536         public
537         view
538         returns (address _addr);
539 
540     // Profits are the difference between balance and threshold
541     function profits()
542         public
543         view
544         returns (int _profits)
545     {
546         int _balance = int(address(this).balance);
547         int _threshold = int(bankroll + getCollateral());
548         return _balance - _threshold;
549     }
550 
551     // How profitable this contract is, overall
552     function profitsTotal()
553         public
554         view
555         returns (int _profits)
556     {
557         return int(profitsSent) + profits();
558     }
559 
560     // Returns the amount that can currently be bankrolled.
561     //   - 0 if balance < collateral
562     //   - If profits: full bankroll
563     //   - If no profits: remaning bankroll: balance - collateral
564     function bankrollAvailable()
565         public
566         view
567         returns (uint _amount)
568     {
569         uint _balance = address(this).balance;
570         uint _bankroll = bankroll;
571         uint _collat = getCollateral();
572         // Balance is below collateral!
573         if (_balance <= _collat) return 0;
574         // No profits, but we have a balance over collateral.
575         else if (_balance < _collat + _bankroll) return _balance - _collat;
576         // Profits. Return only _bankroll
577         else return _bankroll;
578     }
579 
580     function bankrolledBy(address _addr)
581         public
582         view
583         returns (uint _amount)
584     {
585         return ledger.balanceOf(_addr);
586     }
587 
588     function bankrollerTable()
589         public
590         view
591         returns (address[], uint[])
592     {
593         return ledger.balances();
594     }
595 }
596 
597 contract VideoPokerUtils {
598     uint constant HAND_UNDEFINED = 0;
599     uint constant HAND_RF = 1;
600     uint constant HAND_SF = 2;
601     uint constant HAND_FK = 3;
602     uint constant HAND_FH = 4;
603     uint constant HAND_FL = 5;
604     uint constant HAND_ST = 6;
605     uint constant HAND_TK = 7;
606     uint constant HAND_TP = 8;
607     uint constant HAND_JB = 9;
608     uint constant HAND_HC = 10;
609     uint constant HAND_NOT_COMPUTABLE = 11;
610 
611     /*****************************************************/
612     /********** PUBLIC PURE FUNCTIONS ********************/
613     /*****************************************************/
614 
615     // Gets a new 5-card hand, stored in uint32
616     // Gas Cost: 3k
617     function getHand(uint256 _hash)
618         public
619         pure
620         returns (uint32)
621     {
622         // Return the cards as a hand.
623         return uint32(getCardsFromHash(_hash, 5, 0));
624     }
625 
626     // Both _hand and _draws store the first card in the
627     //   rightmost position. _hand uses chunks of 6 bits.
628     //
629     // In the below example, hand is [9,18,35,12,32], and
630     // the cards 18 and 35 will be replaced.
631     //
632     // _hand:                                [9,18,35,12,32]  
633     //    encoding:    XX 100000 001100 100011 010010 001001
634     //      chunks:           32     12     35     18      9
635     //       order:        card5, card4, card3, card2, card1
636     //     decimal:                                540161161
637     //
638     // _draws:                               card2 and card4
639     //    encoding:   XXX      0      0      1      1      0
640     //       order:        card5, card4, card3, card2, card1 
641     //     decimal:                                        6
642     // 
643     // Gas Cost: Fixed 6k gas. 
644     function drawToHand(uint256 _hash, uint32 _hand, uint _draws)
645         public
646         pure
647         returns (uint32)
648     {
649         // Draws must be valid. If no hand, must draw all 5 cards.
650         assert(_draws <= 31);
651         assert(_hand != 0 || _draws == 31);
652         // Shortcuts. Return _hand on no draws, or 5 cards on full draw.
653         if (_draws == 0) return _hand;
654         if (_draws == 31) return uint32(getCardsFromHash(_hash, 5, handToBitmap(_hand)));
655 
656         // Create a mask of 1's where new cards should go.
657         uint _newMask;
658         for (uint _i=0; _i<5; _i++) {
659             if (_draws & 2**_i == 0) continue;
660             _newMask |= 63 * (2**(6*_i));
661         }
662         // Create a mask of 0's where new cards should go.
663         // Be sure to use only first 30 bits (5 cards x 6 bits)
664         uint _discardMask = ~_newMask & (2**31-1);
665 
666         // Select from _newHand, discard from _hand, and combine.
667         uint _newHand = getCardsFromHash(_hash, 5, handToBitmap(_hand));
668         _newHand &= _newMask;
669         _newHand |= _hand & _discardMask;
670         return uint32(_newHand);
671     }
672 
673     // Looks at a hand of 5-cards, determines strictly the HandRank.
674     // Gas Cost: up to 7k depending on hand.
675     function getHandRank(uint32 _hand)
676         public
677         pure
678         returns (uint)
679     {
680         if (_hand == 0) return HAND_NOT_COMPUTABLE;
681 
682         uint _card;
683         uint[] memory _valCounts = new uint[](13);
684         uint[] memory _suitCounts = new uint[](5);
685         uint _pairVal;
686         uint _minNonAce = 100;
687         uint _maxNonAce = 0;
688         uint _numPairs;
689         uint _maxSet;
690         bool _hasFlush;
691         bool _hasAce;
692 
693         // Set all the values above.
694         // Note:
695         //   _hasTwoPair will be true even if one pair is Trips.
696         //   Likewise, _hasTrips will be true even if there are Quads.
697         uint _i;
698         uint _val;
699         for (_i=0; _i<5; _i++) {
700             _card = readFromCards(_hand, _i);
701             if (_card > 51) return HAND_NOT_COMPUTABLE;
702             
703             // update val and suit counts, and if it's a flush
704             _val = _card % 13;
705             _valCounts[_val]++;
706             _suitCounts[_card/13]++;
707             if (_suitCounts[_card/13] == 5) _hasFlush = true;
708             
709             // update _hasAce, and min/max value
710             if (_val == 0) {
711                 _hasAce = true;
712             } else {
713                 if (_val < _minNonAce) _minNonAce = _val;
714                 if (_val > _maxNonAce) _maxNonAce = _val;
715             }
716 
717             // update _pairVal, _numPairs, _maxSet
718             if (_valCounts[_val] == 2) {
719                 if (_numPairs==0) _pairVal = _val;
720                 _numPairs++;
721             } else if (_valCounts[_val] == 3) {
722                 _maxSet = 3;
723             } else if (_valCounts[_val] == 4) {
724                 _maxSet = 4;
725             }
726         }
727 
728         if (_numPairs > 0){
729             // If they have quads, they can't have royal flush, so we can return.
730             if (_maxSet==4) return HAND_FK;
731             // One of the two pairs was the trips, so it's a full house.
732             if (_maxSet==3 && _numPairs==2) return HAND_FH;
733             // Trips is their best hand (no straight or flush possible)
734             if (_maxSet==3) return HAND_TK;
735             // Two pair is their best hand (no straight or flush possible)
736             if (_numPairs==2) return HAND_TP;
737             // One pair is their best hand (no straight or flush possible)
738             if (_numPairs == 1 && (_pairVal >= 10 || _pairVal==0)) return HAND_JB;
739             // They have a low pair (no straight or flush possible)
740             return HAND_HC;
741         }
742 
743         // They have no pair. Do they have a straight?
744         bool _hasStraight = _hasAce
745             // Check for: A,1,2,3,4 or 9,10,11,12,A
746             ? _maxNonAce == 4 || _minNonAce == 9
747             // Check for X,X+1,X+2,X+3,X+4
748             : _maxNonAce - _minNonAce == 4;
749         
750         // Check for hands in order of rank.
751         if (_hasStraight && _hasFlush && _minNonAce==9) return HAND_RF;
752         if (_hasStraight && _hasFlush) return HAND_SF;
753         if (_hasFlush) return HAND_FL;
754         if (_hasStraight) return HAND_ST;
755         return HAND_HC;
756     }
757 
758     // Not used anywhere, but added for convenience
759     function handToCards(uint32 _hand)
760         public
761         pure
762         returns (uint8[5] _cards)
763     {
764         uint32 _mask;
765         for (uint _i=0; _i<5; _i++){
766             _mask = uint32(63 * 2**(6*_i));
767             _cards[_i] = uint8((_hand & _mask) / (2**(6*_i)));
768         }
769     }
770 
771 
772 
773     /*****************************************************/
774     /********** PRIVATE INTERNAL FUNCTIONS ***************/
775     /*****************************************************/
776 
777     function readFromCards(uint _cards, uint _index)
778         internal
779         pure
780         returns (uint)
781     {
782         uint _offset = 2**(6*_index);
783         uint _oneBits = 2**6 - 1;
784         return (_cards & (_oneBits * _offset)) / _offset;
785     }
786 
787     // Returns a bitmap to represent the set of cards in _hand.
788     function handToBitmap(uint32 _hand)
789         internal
790         pure
791         returns (uint _bitmap)
792     {
793         if (_hand == 0) return 0;
794         uint _mask;
795         uint _card;
796         for (uint _i=0; _i<5; _i++){
797             _mask = 63 * 2**(6*_i);
798             _card = (_hand & _mask) / (2**(6*_i));
799             _bitmap |= 2**_card;
800         }
801     }
802 
803     // Returns numCards from a uint256 (eg, keccak256) seed hash.
804     // Returns cards as one uint, with each card being 6 bits.
805     function getCardsFromHash(uint256 _hash, uint _numCards, uint _usedBitmap)
806         internal
807         pure
808         returns (uint _cards)
809     {
810         // Return early if we don't need to pick any cards.
811         if (_numCards == 0) return;
812 
813         uint _cardIdx = 0;                // index of currentCard
814         uint _card;                       // current chosen card
815         uint _usedMask;                   // mask of current card
816 
817         while (true) {
818             _card = _hash % 52;           // Generate card from hash
819             _usedMask = 2**_card;         // Create mask for the card
820 
821             // If card is not used, add it to _cards and _usedBitmap
822             // Return if we have enough cards.
823             if (_usedBitmap & _usedMask == 0) {
824                 _cards |= (_card * 2**(_cardIdx*6));
825                 _usedBitmap |= _usedMask;
826                 _cardIdx++;
827                 if (_cardIdx == _numCards) return _cards;
828             }
829 
830             // Generate hash used to pick next card.
831             _hash = uint256(keccak256(_hash));
832         }
833     }
834 }
835 
836 contract VideoPoker is
837     VideoPokerUtils,
838     Bankrollable,
839     UsingAdmin
840 {
841     // All the data needed for each game.
842     struct Game {
843         // [1st 256-bit block]
844         uint32 userId;
845         uint64 bet;         // max of 18 Ether (set on bet)
846         uint16 payTableId;  // the PayTable used (set on bet)
847         uint32 iBlock;      // initial hand block (set on bet)
848         uint32 iHand;       // initial hand (set on draw/finalize)
849         uint8 draws;        // bitmap of which cards to draw (set on draw/finalize)
850         uint32 dBlock;      // block of the dHand (set on draw/finalize)
851         uint32 dHand;       // hand after draws (set on finalize)
852         uint8 handRank;     // result of the hand (set on finalize)
853     }
854 
855     // These variables change on each bet and finalization.
856     // We put them in a struct with the hopes that optimizer
857     //   will do one write if any/all of them change.
858     struct Vars {
859         // [1st 256-bit block]
860         uint32 curId;               // (changes on bet)
861         uint64 totalWageredGwei;    // (changes on bet)
862         uint32 curUserId;           // (changes on bet, maybe)
863         uint128 empty1;             // intentionally left empty, so the below
864                                     //   updates occur in the same update
865         // [2nd 256-bit block]
866         uint64 totalWonGwei;        // (changes on finalization win)
867         uint88 totalCredits;        // (changes on finalization win)
868         uint8 empty2;               // set to true to normalize gas cost
869     }
870 
871     struct Settings {
872         uint64 minBet;
873         uint64 maxBet;
874         uint16 curPayTableId;
875         uint16 numPayTables;
876         uint32 lastDayAdded;
877     }
878 
879     Settings settings;
880     Vars vars;
881 
882     // A Mapping of all games
883     mapping(uint32 => Game) public games;
884     
885     // Credits we owe the user
886     mapping(address => uint) public credits;
887 
888     // Store a two-way mapping of address <=> userId
889     // If we've seen a user before, betting will be just 1 write
890     //  per Game struct vs 2 writes.
891     // The trade-off is 3 writes for new users. Seems fair.
892     mapping (address => uint32) public userIds;
893     mapping (uint32 => address) public userAddresses;
894 
895     // Note: Pay tables cannot be changed once added.
896     // However, admin can change the current PayTable
897     mapping(uint16=>uint16[12]) payTables;
898 
899     // version of the game
900     uint8 public constant version = 2;
901     uint8 constant WARN_IHAND_TIMEOUT = 1; // "Initial hand not available. Drawing 5 new cards."
902     uint8 constant WARN_DHAND_TIMEOUT = 2; // "Draw cards not available. Using initial hand."
903     uint8 constant WARN_BOTH_TIMEOUT = 3;  // "Draw cards not available, and no initial hand."
904     
905     // Admin Events
906     event Created(uint time);
907     event PayTableAdded(uint time, address admin, uint payTableId);
908     event SettingsChanged(uint time, address admin);
909     // Game Events
910     event BetSuccess(uint time, address indexed user, uint32 indexed id, uint bet, uint payTableId);
911     event BetFailure(uint time, address indexed user, uint bet, string msg);
912     event DrawSuccess(uint time, address indexed user, uint32 indexed id, uint32 iHand, uint8 draws, uint8 warnCode);
913     event DrawFailure(uint time, address indexed user, uint32 indexed id, uint8 draws, string msg);
914     event FinalizeSuccess(uint time, address indexed user, uint32 indexed id, uint32 dHand, uint8 handRank, uint payout, uint8 warnCode);
915     event FinalizeFailure(uint time, address indexed user, uint32 indexed id, string msg);
916     // Credits
917     event CreditsAdded(uint time, address indexed user, uint32 indexed id, uint amount);
918     event CreditsUsed(uint time, address indexed user, uint32 indexed id, uint amount);
919     event CreditsCashedout(uint time, address indexed user, uint amount);
920         
921     constructor(address _registry)
922         Bankrollable(_registry)
923         UsingAdmin(_registry)
924         public
925     {
926         // Add the default PayTable.
927         _addPayTable(800, 50, 25, 9, 6, 4, 3, 2, 1);
928         // write to vars, to lower gas-cost for the first game.
929         // vars.empty1 = 1;
930         // vars.empty2 = 1;
931         // initialze stats to last settings
932         vars.curId = 293;
933         vars.totalWageredGwei =2864600000;
934         vars.curUserId = 38;
935         vars.totalWonGwei = 2450400000;
936 
937         // initialize settings
938         settings.minBet = .001 ether;
939         settings.maxBet = .375 ether;
940         emit Created(now);
941     }
942     
943     
944     /************************************************************/
945     /******************** ADMIN FUNCTIONS ***********************/
946     /************************************************************/
947     
948     // Allows admin to change minBet, maxBet, and curPayTableId
949     function changeSettings(uint64 _minBet, uint64 _maxBet, uint8 _payTableId)
950         public
951         fromAdmin
952     {
953         require(_maxBet <= .375 ether);
954         require(_payTableId < settings.numPayTables);
955         settings.minBet = _minBet;
956         settings.maxBet = _maxBet;
957         settings.curPayTableId = _payTableId;
958         emit SettingsChanged(now, msg.sender);
959     }
960     
961     // Allows admin to permanently add a PayTable (once per day)
962     function addPayTable(
963         uint16 _rf, uint16 _sf, uint16 _fk, uint16 _fh,
964         uint16 _fl, uint16 _st, uint16 _tk, uint16 _tp, uint16 _jb
965     )
966         public
967         fromAdmin
968     {
969         uint32 _today = uint32(block.timestamp / 1 days);
970         require(settings.lastDayAdded < _today);
971         settings.lastDayAdded = _today;
972         _addPayTable(_rf, _sf, _fk, _fh, _fl, _st, _tk, _tp, _jb);
973         emit PayTableAdded(now, msg.sender, settings.numPayTables-1);
974     }
975     
976 
977     /************************************************************/
978     /****************** PUBLIC FUNCTIONS ************************/
979     /************************************************************/
980 
981     // Allows a user to add credits to their account.
982     function addCredits()
983         public
984         payable
985     {
986         _creditUser(msg.sender, msg.value, 0);
987     }
988 
989     // Allows the user to cashout an amt (or their whole balance)
990     function cashOut(uint _amt)
991         public
992     {
993         _uncreditUser(msg.sender, _amt);
994     }
995 
996     // Allows a user to create a game from Ether sent.
997     //
998     // Gas Cost: 55k (prev player), 95k (new player)
999     //   - 22k: tx overhead
1000     //   - 26k, 66k: see _createNewGame()
1001     //   -  3k: event
1002     //   -  2k: curMaxBet()
1003     //   -  2k: SLOAD, execution
1004     function bet()
1005         public
1006         payable
1007     {
1008         uint _bet = msg.value;
1009         if (_bet > settings.maxBet)
1010             return _betFailure("Bet too large.", _bet, true);
1011         if (_bet < settings.minBet)
1012             return _betFailure("Bet too small.", _bet, true);
1013         if (_bet > curMaxBet())
1014             return _betFailure("The bankroll is too low.", _bet, true);
1015 
1016         // no uint64 overflow: _bet < maxBet < .625 ETH < 2e64
1017         uint32 _id = _createNewGame(uint64(_bet));
1018         emit BetSuccess(now, msg.sender, _id, _bet, settings.curPayTableId);
1019     }
1020 
1021     // Allows a user to create a game from Credits.
1022     //
1023     // Gas Cost: 61k
1024     //   - 22k: tx overhead
1025     //   - 26k: see _createNewGame()
1026     //   -  3k: event
1027     //   -  2k: curMaxBet()
1028     //   -  2k: 1 event: CreditsUsed
1029     //   -  5k: update credits[user]
1030     //   -  1k: SLOAD, execution
1031     function betWithCredits(uint64 _bet)
1032         public
1033     {
1034         if (_bet > settings.maxBet)
1035             return _betFailure("Bet too large.", _bet, false);
1036         if (_bet < settings.minBet)
1037             return _betFailure("Bet too small.", _bet, false);
1038         if (_bet > curMaxBet())
1039             return _betFailure("The bankroll is too low.", _bet, false);
1040         if (_bet > credits[msg.sender])
1041             return _betFailure("Insufficient credits", _bet, false);
1042 
1043         uint32 _id = _createNewGame(uint64(_bet));
1044         vars.totalCredits -= uint88(_bet);
1045         credits[msg.sender] -= _bet;
1046         emit CreditsUsed(now, msg.sender, _id, _bet);
1047         emit BetSuccess(now, msg.sender, _id, _bet, settings.curPayTableId);
1048     }
1049 
1050     function betFromGame(uint32 _id, bytes32 _hashCheck)
1051         public
1052     {
1053         bool _didFinalize = finalize(_id, _hashCheck);
1054         uint64 _bet = games[_id].bet;
1055         if (!_didFinalize)
1056             return _betFailure("Failed to finalize prior game.", _bet, false);
1057         betWithCredits(_bet);
1058     }
1059 
1060         // Logs an error, and optionally refunds user the _bet
1061         function _betFailure(string _msg, uint _bet, bool _doRefund)
1062             private
1063         {
1064             if (_doRefund) require(msg.sender.call.value(_bet)());
1065             emit BetFailure(now, msg.sender, _bet, _msg);
1066         }
1067         
1068 
1069     // Resolves the initial hand (if possible) and sets the users draws.
1070     // Users cannot draw 0 cards. They should instead use finalize().
1071     //
1072     // Notes:
1073     //  - If user unable to resolve initial hand, sets draws to 5
1074     //  - This always sets game.dBlock
1075     //
1076     // Gas Cost: ~38k
1077     //   - 23k: tx
1078     //   - 13k: see _draw()
1079     //   -  2k: SLOADs, execution
1080     function draw(uint32 _id, uint8 _draws, bytes32 _hashCheck)
1081         public
1082     {
1083         Game storage _game = games[_id];
1084         address _user = userAddresses[_game.userId];
1085         if (_game.iBlock == 0)
1086             return _drawFailure(_id, _draws, "Invalid game Id.");
1087         if (_user != msg.sender)
1088             return _drawFailure(_id, _draws, "This is not your game.");
1089         if (_game.iBlock == block.number)
1090             return _drawFailure(_id, _draws, "Initial cards not available.");
1091         if (_game.dBlock != 0)
1092             return _drawFailure(_id, _draws, "Cards already drawn.");
1093         if (_draws > 31)
1094             return _drawFailure(_id, _draws, "Invalid draws.");
1095         if (_draws == 0)
1096             return _drawFailure(_id, _draws, "Cannot draw 0 cards. Use finalize instead.");
1097         if (_game.handRank != HAND_UNDEFINED)
1098             return _drawFailure(_id, _draws, "Game already finalized.");
1099         
1100         _draw(_game, _id, _draws, _hashCheck);
1101     }
1102         function _drawFailure(uint32 _id, uint8 _draws, string _msg)
1103             private
1104         {
1105             emit DrawFailure(now, msg.sender, _id, _draws, _msg);
1106         }
1107       
1108 
1109     // Callable any time after the initial hand. Will assume
1110     // no draws if called directly after new hand.
1111     //
1112     // Gas Cost: 44k (loss), 59k (win, has credits), 72k (win, no credits)
1113     //   - 22k: tx overhead
1114     //   - 21k, 36k, 49k: see _finalize()
1115     //   -  1k: SLOADs, execution
1116     function finalize(uint32 _id, bytes32 _hashCheck)
1117         public
1118         returns (bool _didFinalize)
1119     {
1120         Game storage _game = games[_id];
1121         address _user = userAddresses[_game.userId];
1122         if (_game.iBlock == 0)
1123             return _finalizeFailure(_id, "Invalid game Id.");
1124         if (_user != msg.sender)
1125             return _finalizeFailure(_id, "This is not your game.");
1126         if (_game.iBlock == block.number)
1127             return _finalizeFailure(_id, "Initial hand not avaiable.");
1128         if (_game.dBlock == block.number)
1129             return _finalizeFailure(_id, "Drawn cards not available.");
1130         if (_game.handRank != HAND_UNDEFINED)
1131             return _finalizeFailure(_id, "Game already finalized.");
1132 
1133         _finalize(_game, _id, _hashCheck);
1134         return true;
1135     }
1136         function _finalizeFailure(uint32 _id, string _msg)
1137             private
1138             returns (bool)
1139         {
1140             emit FinalizeFailure(now, msg.sender, _id, _msg);
1141             return false;
1142         }
1143 
1144 
1145     /************************************************************/
1146     /****************** PRIVATE FUNCTIONS ***********************/
1147     /************************************************************/
1148 
1149     // Appends a PayTable to the mapping.
1150     // It ensures sane values. (Double the defaults)
1151     function _addPayTable(
1152         uint16 _rf, uint16 _sf, uint16 _fk, uint16 _fh,
1153         uint16 _fl, uint16 _st, uint16 _tk, uint16 _tp, uint16 _jb
1154     )
1155         private
1156     {
1157         require(_rf<=1600 && _sf<=100 && _fk<=50 && _fh<=18 && _fl<=12 
1158                  && _st<=8 && _tk<=6 && _tp<=4 && _jb<=2);
1159 
1160         uint16[12] memory _pt;
1161         _pt[HAND_UNDEFINED] = 0;
1162         _pt[HAND_RF] = _rf;
1163         _pt[HAND_SF] = _sf;
1164         _pt[HAND_FK] = _fk;
1165         _pt[HAND_FH] = _fh;
1166         _pt[HAND_FL] = _fl;
1167         _pt[HAND_ST] = _st;
1168         _pt[HAND_TK] = _tk;
1169         _pt[HAND_TP] = _tp;
1170         _pt[HAND_JB] = _jb;
1171         _pt[HAND_HC] = 0;
1172         _pt[HAND_NOT_COMPUTABLE] = 0;
1173         payTables[settings.numPayTables] = _pt;
1174         settings.numPayTables++;
1175     }
1176 
1177     // Increases totalCredits and credits[user]
1178     // Optionally increases totalWonGwei stat.
1179     function _creditUser(address _user, uint _amt, uint32 _gameId)
1180         private
1181     {
1182         if (_amt == 0) return;
1183         uint64 _incr = _gameId == 0 ? 0 : uint64(_amt / 1e9);
1184         uint88 _totalCredits = vars.totalCredits + uint88(_amt);
1185         uint64 _totalWonGwei = vars.totalWonGwei + _incr;
1186         vars.totalCredits = _totalCredits;
1187         vars.totalWonGwei = _totalWonGwei;
1188         credits[_user] += _amt;
1189         emit CreditsAdded(now, _user, _gameId, _amt);
1190     }
1191 
1192     // Lowers totalCredits and credits[user].
1193     // Sends to user, using unlimited gas.
1194     function _uncreditUser(address _user, uint _amt)
1195         private
1196     {
1197         if (_amt > credits[_user] || _amt == 0) _amt = credits[_user];
1198         if (_amt == 0) return;
1199         vars.totalCredits -= uint88(_amt);
1200         credits[_user] -= _amt;
1201         require(_user.call.value(_amt)());
1202         emit CreditsCashedout(now, _user, _amt);
1203     }
1204 
1205     // Creates a new game with the specified bet and current PayTable.
1206     // Does no validation of the _bet size.
1207     //
1208     // Gas Cost: 26k, 66k
1209     //   Overhead:
1210     //     - 20k: 1 writes: Game
1211     //     -  5k: 1 update: vars
1212     //     -  1k: SLOAD, execution
1213     //   New User:
1214     //     - 40k: 2 writes: userIds, userAddresses
1215     //   Repeat User:
1216     //     -  0k: nothing extra
1217     function _createNewGame(uint64 _bet)
1218         private
1219         returns (uint32 _curId)
1220     {
1221         // get or create user id
1222         uint32 _curUserId = vars.curUserId;
1223         uint32 _userId = userIds[msg.sender];
1224         if (_userId == 0) {
1225             _curUserId++;
1226             userIds[msg.sender] = _curUserId;
1227             userAddresses[_curUserId] = msg.sender;
1228             _userId = _curUserId;
1229         }
1230 
1231         // increment vars
1232         _curId =  vars.curId + 1;
1233         uint64 _totalWagered = vars.totalWageredGwei + _bet / 1e9;
1234         vars.curId = _curId;
1235         vars.totalWageredGwei = _totalWagered;
1236         vars.curUserId = _curUserId;
1237 
1238         // save game
1239         uint16 _payTableId = settings.curPayTableId;
1240         Game storage _game = games[_curId];
1241         _game.userId = _userId;
1242         _game.bet = _bet;
1243         _game.payTableId = _payTableId;
1244         _game.iBlock = uint32(block.number);
1245         return _curId;
1246     }
1247 
1248     // Gets initialHand, and stores .draws and .dBlock.
1249     // Gas Cost: 13k
1250     //   - 3k: getHand()
1251     //   - 5k: 1 update: iHand, draws, dBlock
1252     //   - 3k: event: DrawSuccess
1253     //   - 2k: SLOADs, other
1254     function _draw(Game storage _game, uint32 _id, uint8 _draws, bytes32 _hashCheck)
1255         private
1256     {
1257         // assert hand is not already drawn
1258         assert(_game.dBlock == 0);
1259 
1260         // Deal the initial hand, or set draws to 5.
1261         uint32 _iHand;
1262         bytes32 _iBlockHash = blockhash(_game.iBlock);
1263         uint8 _warnCode;
1264         if (_iBlockHash != 0) {
1265             // Ensure they are drawing against expected hand
1266             if (_iBlockHash != _hashCheck) {
1267                 return _drawFailure(_id, _draws, "HashCheck Failed. Try refreshing game.");
1268             }
1269             _iHand = getHand(uint(keccak256(_iBlockHash, _id)));
1270         } else {
1271             _warnCode = WARN_IHAND_TIMEOUT;
1272             _draws = 31;
1273         }
1274 
1275         // update game
1276         _game.iHand = _iHand;
1277         _game.draws = _draws;
1278         _game.dBlock = uint32(block.number);
1279 
1280         emit DrawSuccess(now, msg.sender, _id, _game.iHand, _draws, _warnCode);
1281     }
1282 
1283     // Resolves game based on .iHand and .draws, crediting user on a win.
1284     // This always sets game.dHand and game.handRank.
1285     //
1286     // There are four possible scenarios:
1287     //   User draws N cads, and dBlock is fresh:
1288     //     - draw N cards into iHand, this is dHand
1289     //   User draws N cards, and dBlock is too old:
1290     //     - set dHand to iHand (note: iHand may be empty)
1291     //   User draws 0 cards, and iBlock is fresh:
1292     //     - draw 5 cards into iHand, set dHand to iHand
1293     //   User draws 0 cards, and iBlock is too old:
1294     //     - fail: set draws to 5, return. (user should call finalize again)
1295     //
1296     // Gas Cost: 21k loss, 36k win, 49k new win
1297     //   - 6k: if draws > 0: drawToHand()
1298     //   - 7k: getHandRank()
1299     //   - 5k: 1 update: Game
1300     //   - 2k: FinalizeSuccess
1301     //   - 1k: SLOADs, execution
1302     //   On Win: +13k, or +28k
1303     //   - 5k: 1 updates: totalCredits, totalWon
1304     //   - 5k or 20k: 1 update/write to credits[user]
1305     //   - 2k: event: AccountCredited
1306     //   - 1k: SLOADs, execution
1307     function _finalize(Game storage _game, uint32 _id, bytes32 _hashCheck)
1308         private
1309     {
1310         // Require game is not already finalized
1311         assert(_game.handRank == HAND_UNDEFINED);
1312 
1313         // Compute _dHand
1314         address _user = userAddresses[_game.userId];
1315         bytes32 _blockhash;
1316         uint32 _dHand;
1317         uint32 _iHand;  // set if draws are 0, and iBlock is fresh
1318         uint8 _warnCode;
1319         if (_game.draws != 0) {
1320             _blockhash = blockhash(_game.dBlock);
1321             if (_blockhash != 0) {
1322                 // draw cards to iHand, use as dHand
1323                 _dHand = drawToHand(uint(keccak256(_blockhash, _id)), _game.iHand, _game.draws);
1324             } else {
1325                 // cannot draw any cards. use iHand.
1326                 if (_game.iHand != 0){
1327                     _dHand = _game.iHand;
1328                     _warnCode = WARN_DHAND_TIMEOUT;
1329                 } else {
1330                     _dHand = 0;
1331                     _warnCode = WARN_BOTH_TIMEOUT;
1332                 }
1333             }
1334         } else {
1335             _blockhash = blockhash(_game.iBlock);
1336             if (_blockhash != 0) {
1337                 // ensure they are drawing against expected hand
1338                 if (_blockhash != _hashCheck) {
1339                     _finalizeFailure(_id, "HashCheck Failed. Try refreshing game.");
1340                     return;
1341                 }
1342                 // draw 5 cards into iHand, use as dHand
1343                 _iHand = getHand(uint(keccak256(_blockhash, _id)));
1344                 _dHand = _iHand;
1345             } else {
1346                 // can't finalize with iHand. Draw 5 cards.
1347                 _finalizeFailure(_id, "Initial hand not available. Drawing 5 new cards.");
1348                 _game.draws = 31;
1349                 _game.dBlock = uint32(block.number);
1350                 emit DrawSuccess(now, _user, _id, 0, 31, WARN_IHAND_TIMEOUT);
1351                 return;
1352             }
1353         }
1354 
1355         // Compute _handRank. be sure dHand is not empty
1356         uint8 _handRank = _dHand == 0
1357             ? uint8(HAND_NOT_COMPUTABLE)
1358             : uint8(getHandRank(_dHand));
1359 
1360         // This only happens if draws==0, and iHand was drawable.
1361         if (_iHand > 0) _game.iHand = _iHand;
1362         // Always set dHand and handRank
1363         _game.dHand = _dHand;
1364         _game.handRank = _handRank;
1365 
1366         // Compute _payout, credit user, emit event.
1367         uint _payout = payTables[_game.payTableId][_handRank] * uint(_game.bet);
1368         if (_payout > 0) _creditUser(_user, _payout, _id);
1369         emit FinalizeSuccess(now, _user, _id, _game.dHand, _game.handRank, _payout, _warnCode);
1370     }
1371 
1372 
1373 
1374     /************************************************************/
1375     /******************** PUBLIC VIEWS **************************/
1376     /************************************************************/
1377 
1378     // IMPLEMENTS: Bankrollable.getProfits()
1379     // Ensures contract always has at least bankroll + totalCredits.
1380     function getCollateral() public view returns (uint _amount) {
1381         return vars.totalCredits;
1382     }
1383 
1384     // IMPLEMENTS: Bankrollable.getWhitelistOwner()
1385     // Ensures contract always has at least bankroll + totalCredits.
1386     function getWhitelistOwner() public view returns (address _wlOwner) {
1387         return getAdmin();
1388     }
1389 
1390     // Returns the largest bet such that we could pay out two RoyalFlushes.
1391     // The likelihood that two RoyalFlushes (with max bet size) are 
1392     //  won within a 255 block period is extremely low.
1393     function curMaxBet() public view returns (uint) {
1394         // Return largest bet such that RF*2*bet = bankrollable
1395         uint _maxPayout = payTables[settings.curPayTableId][HAND_RF] * 2;
1396         return bankrollAvailable() / _maxPayout;
1397     }
1398 
1399     // Return the less of settings.maxBet and curMaxBet()
1400     function effectiveMaxBet() public view returns (uint _amount) {
1401         uint _curMax = curMaxBet();
1402         return _curMax > settings.maxBet ? settings.maxBet : _curMax;
1403     }
1404 
1405     function getPayTable(uint16 _payTableId)
1406         public
1407         view
1408         returns (uint16[12])
1409     {
1410         require(_payTableId < settings.numPayTables);
1411         return payTables[_payTableId];
1412     }
1413 
1414     function getCurPayTable()
1415         public
1416         view
1417         returns (uint16[12])
1418     {
1419         return getPayTable(settings.curPayTableId);
1420     }
1421 
1422     // Gets the initial hand of a game.
1423     function getIHand(uint32 _id)
1424         public
1425         view
1426         returns (uint32)
1427     {
1428         Game memory _game = games[_id];
1429         if (_game.iHand != 0) return _game.iHand;
1430         if (_game.iBlock == 0) return;
1431         
1432         bytes32 _iBlockHash = blockhash(_game.iBlock);
1433         if (_iBlockHash == 0) return;
1434         return getHand(uint(keccak256(_iBlockHash, _id)));
1435     }
1436 
1437     // Get the final hand of a game.
1438     // This will return iHand if there are no draws yet.
1439     function getDHand(uint32 _id)
1440         public
1441         view
1442         returns (uint32)
1443     {
1444         Game memory _game = games[_id];
1445         if (_game.dHand != 0) return _game.dHand;
1446         if (_game.draws == 0) return _game.iHand;
1447         if (_game.dBlock == 0) return;
1448 
1449         bytes32 _dBlockHash = blockhash(_game.dBlock);
1450         if (_dBlockHash == 0) return _game.iHand;
1451         return drawToHand(uint(keccak256(_dBlockHash, _id)), _game.iHand, _game.draws);
1452     }
1453 
1454     // Returns the hand rank and payout of a Game.
1455     function getDHandRank(uint32 _id)
1456         public
1457         view
1458         returns (uint8)
1459     {
1460         uint32 _dHand = getDHand(_id);
1461         return _dHand == 0
1462             ? uint8(HAND_NOT_COMPUTABLE)
1463             : uint8(getHandRank(_dHand));
1464     }
1465 
1466     // Expose Vars //////////////////////////////////////
1467     function curId() public view returns (uint32) {
1468         return vars.curId;
1469     }
1470     function totalWagered() public view returns (uint) {
1471         return uint(vars.totalWageredGwei) * 1e9;
1472     }
1473     function curUserId() public view returns (uint) {
1474         return uint(vars.curUserId);
1475     }
1476     function totalWon() public view returns (uint) {
1477         return uint(vars.totalWonGwei) * 1e9;
1478     }
1479     function totalCredits() public view returns (uint) {
1480         return vars.totalCredits;
1481     }
1482     /////////////////////////////////////////////////////
1483 
1484     // Expose Settings //////////////////////////////////
1485     function minBet() public view returns (uint) {
1486         return settings.minBet;
1487     }
1488     function maxBet() public view returns (uint) {
1489         return settings.maxBet;
1490     }
1491     function curPayTableId() public view returns (uint) {
1492         return settings.curPayTableId;
1493     }
1494     function numPayTables() public view returns (uint) {
1495         return settings.numPayTables;
1496     }
1497     /////////////////////////////////////////////////////
1498 }