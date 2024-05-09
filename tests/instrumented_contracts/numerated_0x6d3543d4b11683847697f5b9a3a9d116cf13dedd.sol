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
85 /******* USING TREASURY **************************
86 
87 Gives the inherting contract access to:
88     .getTreasury(): returns current ITreasury instance
89     [modifier] .fromTreasury(): requires the sender is current Treasury
90 
91 *************************************************/
92 // Returned by .getTreasury()
93 interface ITreasury {
94     function issueDividend() external returns (uint _profits);
95     function profitsSendable() external view returns (uint _profits);
96 }
97 
98 contract UsingTreasury is
99     UsingRegistry
100 {
101     constructor(address _registry)
102         UsingRegistry(_registry)
103         public
104     {}
105 
106     modifier fromTreasury(){
107         require(msg.sender == address(getTreasury()));
108         _;
109     }
110     
111     function getTreasury()
112         public
113         view
114         returns (ITreasury)
115     {
116         return ITreasury(addressOf("TREASURY"));
117     }
118 }
119 
120 /**
121     This is a simple class that maintains a doubly linked list of
122     address => uint amounts. Address balances can be added to 
123     or removed from via add() and subtract(). All balances can
124     be obtain by calling balances(). If an address has a 0 amount,
125     it is removed from the Ledger.
126 
127     Note: THIS DOES NOT TEST FOR OVERFLOWS, but it's safe to
128           use to track Ether balances.
129 
130     Public methods:
131       - [fromOwner] add()
132       - [fromOwner] subtract()
133     Public views:
134       - total()
135       - size()
136       - balanceOf()
137       - balances()
138       - entries() [to manually iterate]
139 */
140 contract Ledger {
141     uint public total;      // Total amount in Ledger
142 
143     struct Entry {          // Doubly linked list tracks amount per address
144         uint balance;
145         address next;
146         address prev;
147     }
148     mapping (address => Entry) public entries;
149 
150     address public owner;
151     modifier fromOwner() { require(msg.sender==owner); _; }
152 
153     // Constructor sets the owner
154     constructor(address _owner)
155         public
156     {
157         owner = _owner;
158     }
159 
160 
161     /******************************************************/
162     /*************** OWNER METHODS ************************/
163     /******************************************************/
164 
165     function add(address _address, uint _amt)
166         fromOwner
167         public
168     {
169         if (_address == address(0) || _amt == 0) return;
170         Entry storage entry = entries[_address];
171 
172         // If new entry, replace first entry with this one.
173         if (entry.balance == 0) {
174             entry.next = entries[0x0].next;
175             entries[entries[0x0].next].prev = _address;
176             entries[0x0].next = _address;
177         }
178         // Update stats.
179         total += _amt;
180         entry.balance += _amt;
181     }
182 
183     function subtract(address _address, uint _amt)
184         fromOwner
185         public
186         returns (uint _amtRemoved)
187     {
188         if (_address == address(0) || _amt == 0) return;
189         Entry storage entry = entries[_address];
190 
191         uint _maxAmt = entry.balance;
192         if (_maxAmt == 0) return;
193         
194         if (_amt >= _maxAmt) {
195             // Subtract the max amount, and delete entry.
196             total -= _maxAmt;
197             entries[entry.prev].next = entry.next;
198             entries[entry.next].prev = entry.prev;
199             delete entries[_address];
200             return _maxAmt;
201         } else {
202             // Subtract the amount from entry.
203             total -= _amt;
204             entry.balance -= _amt;
205             return _amt;
206         }
207     }
208 
209 
210     /******************************************************/
211     /*************** PUBLIC VIEWS *************************/
212     /******************************************************/
213 
214     function size()
215         public
216         view
217         returns (uint _size)
218     {
219         // Loop once to get the total count.
220         Entry memory _curEntry = entries[0x0];
221         while (_curEntry.next > 0) {
222             _curEntry = entries[_curEntry.next];
223             _size++;
224         }
225         return _size;
226     }
227 
228     function balanceOf(address _address)
229         public
230         view
231         returns (uint _balance)
232     {
233         return entries[_address].balance;
234     }
235 
236     function balances()
237         public
238         view
239         returns (address[] _addresses, uint[] _balances)
240     {
241         // Populate names and addresses
242         uint _size = size();
243         _addresses = new address[](_size);
244         _balances = new uint[](_size);
245         uint _i = 0;
246         Entry memory _curEntry = entries[0x0];
247         while (_curEntry.next > 0) {
248             _addresses[_i] = _curEntry.next;
249             _balances[_i] = entries[_curEntry.next].balance;
250             _curEntry = entries[_curEntry.next];
251             _i++;
252         }
253         return (_addresses, _balances);
254     }
255 }
256 
257 /**
258     This is a simple class that maintains a doubly linked list of
259     addresses it has seen. Addresses can be added and removed
260     from the set, and a full list of addresses can be obtained.
261 
262     Methods:
263      - [fromOwner] .add()
264      - [fromOwner] .remove()
265     Views:
266      - .size()
267      - .has()
268      - .addresses()
269 */
270 contract AddressSet {
271     
272     struct Entry {  // Doubly linked list
273         bool exists;
274         address next;
275         address prev;
276     }
277     mapping (address => Entry) public entries;
278 
279     address public owner;
280     modifier fromOwner() { require(msg.sender==owner); _; }
281 
282     // Constructor sets the owner.
283     constructor(address _owner)
284         public
285     {
286         owner = _owner;
287     }
288 
289 
290     /******************************************************/
291     /*************** OWNER METHODS ************************/
292     /******************************************************/
293 
294     function add(address _address)
295         fromOwner
296         public
297         returns (bool _didCreate)
298     {
299         // Do not allow the adding of HEAD.
300         if (_address == address(0)) return;
301         Entry storage entry = entries[_address];
302         // If already exists, do nothing. Otherwise set it.
303         if (entry.exists) return;
304         else entry.exists = true;
305 
306         // Replace first entry with this one.
307         // Before: HEAD <-> X <-> Y
308         // After: HEAD <-> THIS <-> X <-> Y
309         // do: THIS.NEXT = [0].next; [0].next.prev = THIS; [0].next = THIS; THIS.prev = 0;
310         Entry storage HEAD = entries[0x0];
311         entry.next = HEAD.next;
312         entries[HEAD.next].prev = _address;
313         HEAD.next = _address;
314         return true;
315     }
316 
317     function remove(address _address)
318         fromOwner
319         public
320         returns (bool _didExist)
321     {
322         // Do not allow the removal of HEAD.
323         if (_address == address(0)) return;
324         Entry storage entry = entries[_address];
325         // If it doesn't exist already, there is nothing to do.
326         if (!entry.exists) return;
327 
328         // Stitch together next and prev, delete entry.
329         // Before: X <-> THIS <-> Y
330         // After: X <-> Y
331         // do: THIS.next.prev = this.prev; THIS.prev.next = THIS.next;
332         entries[entry.prev].next = entry.next;
333         entries[entry.next].prev = entry.prev;
334         delete entries[_address];
335         return true;
336     }
337 
338 
339     /******************************************************/
340     /*************** PUBLIC VIEWS *************************/
341     /******************************************************/
342 
343     function size()
344         public
345         view
346         returns (uint _size)
347     {
348         // Loop once to get the total count.
349         Entry memory _curEntry = entries[0x0];
350         while (_curEntry.next > 0) {
351             _curEntry = entries[_curEntry.next];
352             _size++;
353         }
354         return _size;
355     }
356 
357     function has(address _address)
358         public
359         view
360         returns (bool _exists)
361     {
362         return entries[_address].exists;
363     }
364 
365     function addresses()
366         public
367         view
368         returns (address[] _addresses)
369     {
370         // Populate names and addresses
371         uint _size = size();
372         _addresses = new address[](_size);
373         // Iterate forward through all entries until the end.
374         uint _i = 0;
375         Entry memory _curEntry = entries[0x0];
376         while (_curEntry.next > 0) {
377             _addresses[_i] = _curEntry.next;
378             _curEntry = entries[_curEntry.next];
379             _i++;
380         }
381         return _addresses;
382     }
383 }
384 
385 /**
386   A simple class that manages bankroll, and maintains collateral.
387   This class only ever sends profits the Treasury. No exceptions.
388 
389   - Anybody can add funding (according to whitelist)
390   - Anybody can tell profits (balance - (funding + collateral)) to go to Treasury.
391   - Anyone can remove their funding, so long as balance >= collateral.
392   - Whitelist is managed by getWhitelistOwner() -- typically Admin.
393 
394   Exposes the following:
395     Public Methods
396      - addBankroll
397      - removeBankroll
398      - sendProfits
399     Public Views
400      - getCollateral
401      - profits
402      - profitsSent
403      - profitsTotal
404      - bankroll
405      - bankrollAvailable
406      - bankrolledBy
407      - bankrollerTable
408 */
409 contract Bankrollable is
410     UsingTreasury
411 {   
412     // How much profits have been sent. 
413     uint public profitsSent;
414     // Ledger keeps track of who has bankrolled us, and for how much
415     Ledger public ledger;
416     // This is a copy of ledger.total(), to save gas in .bankrollAvailable()
417     uint public bankroll;
418     // This is the whitelist of who can call .addBankroll()
419     AddressSet public whitelist;
420 
421     modifier fromWhitelistOwner(){
422         require(msg.sender == getWhitelistOwner());
423         _;
424     }
425 
426     event BankrollAdded(uint time, address indexed bankroller, uint amount, uint bankroll);
427     event BankrollRemoved(uint time, address indexed bankroller, uint amount, uint bankroll);
428     event ProfitsSent(uint time, address indexed treasury, uint amount);
429     event AddedToWhitelist(uint time, address indexed addr, address indexed wlOwner);
430     event RemovedFromWhitelist(uint time, address indexed addr, address indexed wlOwner);
431 
432     // Constructor creates the ledger and whitelist, with self as owner.
433     constructor(address _registry)
434         UsingTreasury(_registry)
435         public
436     {
437         ledger = new Ledger(this);
438         whitelist = new AddressSet(this);
439     }
440 
441 
442     /*****************************************************/
443     /************** WHITELIST MGMT ***********************/
444     /*****************************************************/    
445 
446     function addToWhitelist(address _addr)
447         fromWhitelistOwner
448         public
449     {
450         bool _didAdd = whitelist.add(_addr);
451         if (_didAdd) emit AddedToWhitelist(now, _addr, msg.sender);
452     }
453 
454     function removeFromWhitelist(address _addr)
455         fromWhitelistOwner
456         public
457     {
458         bool _didRemove = whitelist.remove(_addr);
459         if (_didRemove) emit RemovedFromWhitelist(now, _addr, msg.sender);
460     }
461 
462     /*****************************************************/
463     /************** PUBLIC FUNCTIONS *********************/
464     /*****************************************************/
465 
466     // Bankrollable contracts should be payable (to receive revenue)
467     function () public payable {}
468 
469     // Increase funding by whatever value is sent
470     function addBankroll()
471         public
472         payable 
473     {
474         require(whitelist.size()==0 || whitelist.has(msg.sender));
475         ledger.add(msg.sender, msg.value);
476         bankroll = ledger.total();
477         emit BankrollAdded(now, msg.sender, msg.value, bankroll);
478     }
479 
480     // Removes up to _amount from Ledger, and sends it to msg.sender._callbackFn
481     function removeBankroll(uint _amount, string _callbackFn)
482         public
483         returns (uint _recalled)
484     {
485         // cap amount at the balance minus collateral, or nothing at all.
486         address _bankroller = msg.sender;
487         uint _collateral = getCollateral();
488         uint _balance = address(this).balance;
489         uint _available = _balance > _collateral ? _balance - _collateral : 0;
490         if (_amount > _available) _amount = _available;
491 
492         // Try to remove _amount from ledger, get actual _amount removed.
493         _amount = ledger.subtract(_bankroller, _amount);
494         bankroll = ledger.total();
495         if (_amount == 0) return;
496 
497         bytes4 _sig = bytes4(keccak256(_callbackFn));
498         require(_bankroller.call.value(_amount)(_sig));
499         emit BankrollRemoved(now, _bankroller, _amount, bankroll);
500         return _amount;
501     }
502 
503     // Send any excess profits to treasury.
504     function sendProfits()
505         public
506         returns (uint _profits)
507     {
508         int _p = profits();
509         if (_p <= 0) return;
510         _profits = uint(_p);
511         profitsSent += _profits;
512         // Send profits to Treasury
513         address _tr = getTreasury();
514         require(_tr.call.value(_profits)());
515         emit ProfitsSent(now, _tr, _profits);
516     }
517 
518 
519     /*****************************************************/
520     /************** PUBLIC VIEWS *************************/
521     /*****************************************************/
522 
523     // Function must be overridden by inheritors to ensure collateral is kept.
524     function getCollateral()
525         public
526         view
527         returns (uint _amount);
528 
529     // Function must be overridden by inheritors to enable whitelist control.
530     function getWhitelistOwner()
531         public
532         view
533         returns (address _addr);
534 
535     // Profits are the difference between balance and threshold
536     function profits()
537         public
538         view
539         returns (int _profits)
540     {
541         int _balance = int(address(this).balance);
542         int _threshold = int(bankroll + getCollateral());
543         return _balance - _threshold;
544     }
545 
546     // How profitable this contract is, overall
547     function profitsTotal()
548         public
549         view
550         returns (int _profits)
551     {
552         return int(profitsSent) + profits();
553     }
554 
555     // Returns the amount that can currently be bankrolled.
556     //   - 0 if balance < collateral
557     //   - If profits: full bankroll
558     //   - If no profits: remaning bankroll: balance - collateral
559     function bankrollAvailable()
560         public
561         view
562         returns (uint _amount)
563     {
564         uint _balance = address(this).balance;
565         uint _bankroll = bankroll;
566         uint _collat = getCollateral();
567         // Balance is below collateral!
568         if (_balance <= _collat) return 0;
569         // No profits, but we have a balance over collateral.
570         else if (_balance < _collat + _bankroll) return _balance - _collat;
571         // Profits. Return only _bankroll
572         else return _bankroll;
573     }
574 
575     function bankrolledBy(address _addr)
576         public
577         view
578         returns (uint _amount)
579     {
580         return ledger.balanceOf(_addr);
581     }
582 
583     function bankrollerTable()
584         public
585         view
586         returns (address[], uint[])
587     {
588         return ledger.balances();
589     }
590 }
591 
592 contract VideoPokerUtils {
593     uint constant HAND_UNDEFINED = 0;
594     uint constant HAND_RF = 1;
595     uint constant HAND_SF = 2;
596     uint constant HAND_FK = 3;
597     uint constant HAND_FH = 4;
598     uint constant HAND_FL = 5;
599     uint constant HAND_ST = 6;
600     uint constant HAND_TK = 7;
601     uint constant HAND_TP = 8;
602     uint constant HAND_JB = 9;
603     uint constant HAND_HC = 10;
604     uint constant HAND_NOT_COMPUTABLE = 11;
605 
606     /*****************************************************/
607     /********** PUBLIC PURE FUNCTIONS ********************/
608     /*****************************************************/
609 
610     // Gets a new 5-card hand, stored in uint32
611     // Gas Cost: 3k
612     function getHand(uint256 _hash)
613         public
614         pure
615         returns (uint32)
616     {
617         // Return the cards as a hand.
618         return uint32(getCardsFromHash(_hash, 5, 0));
619     }
620 
621     // Both _hand and _draws store the first card in the
622     //   rightmost position. _hand uses chunks of 6 bits.
623     //
624     // In the below example, hand is [9,18,35,12,32], and
625     // the cards 18 and 35 will be replaced.
626     //
627     // _hand:                                [9,18,35,12,32]  
628     //    encoding:    XX 100000 001100 100011 010010 001001
629     //      chunks:           32     12     35     18      9
630     //       order:        card5, card4, card3, card2, card1
631     //     decimal:                                540161161
632     //
633     // _draws:                               card2 and card4
634     //    encoding:   XXX      0      0      1      1      0
635     //       order:        card5, card4, card3, card2, card1 
636     //     decimal:                                        6
637     // 
638     // Gas Cost: Fixed 6k gas. 
639     function drawToHand(uint256 _hash, uint32 _hand, uint _draws)
640         public
641         pure
642         returns (uint32)
643     {
644         // Draws must be valid. If no hand, must draw all 5 cards.
645         assert(_draws <= 31);
646         assert(_hand != 0 || _draws == 31);
647         // Shortcuts. Return _hand on no draws, or 5 cards on full draw.
648         if (_draws == 0) return _hand;
649         if (_draws == 31) return uint32(getCardsFromHash(_hash, 5, handToBitmap(_hand)));
650 
651         // Create a mask of 1's where new cards should go.
652         uint _newMask;
653         for (uint _i=0; _i<5; _i++) {
654             if (_draws & 2**_i == 0) continue;
655             _newMask |= 63 * (2**(6*_i));
656         }
657         // Create a mask of 0's where new cards should go.
658         // Be sure to use only first 30 bits (5 cards x 6 bits)
659         uint _discardMask = ~_newMask & (2**31-1);
660 
661         // Select from _newHand, discard from _hand, and combine.
662         uint _newHand = getCardsFromHash(_hash, 5, handToBitmap(_hand));
663         _newHand &= _newMask;
664         _newHand |= _hand & _discardMask;
665         return uint32(_newHand);
666     }
667 
668     // Looks at a hand of 5-cards, determines strictly the HandRank.
669     // Gas Cost: up to 7k depending on hand.
670     function getHandRank(uint32 _hand)
671         public
672         pure
673         returns (uint)
674     {
675         if (_hand == 0) return HAND_NOT_COMPUTABLE;
676 
677         uint _card;
678         uint[] memory _valCounts = new uint[](13);
679         uint[] memory _suitCounts = new uint[](5);
680         uint _pairVal;
681         uint _minNonAce = 100;
682         uint _maxNonAce = 0;
683         uint _numPairs;
684         uint _maxSet;
685         bool _hasFlush;
686         bool _hasAce;
687 
688         // Set all the values above.
689         // Note:
690         //   _hasTwoPair will be true even if one pair is Trips.
691         //   Likewise, _hasTrips will be true even if there are Quads.
692         uint _i;
693         uint _val;
694         for (_i=0; _i<5; _i++) {
695             _card = readFromCards(_hand, _i);
696             if (_card > 51) return HAND_NOT_COMPUTABLE;
697             
698             // update val and suit counts, and if it's a flush
699             _val = _card % 13;
700             _valCounts[_val]++;
701             _suitCounts[_card/13]++;
702             if (_suitCounts[_card/13] == 5) _hasFlush = true;
703             
704             // update _hasAce, and min/max value
705             if (_val == 0) {
706                 _hasAce = true;
707             } else {
708                 if (_val < _minNonAce) _minNonAce = _val;
709                 if (_val > _maxNonAce) _maxNonAce = _val;
710             }
711 
712             // update _pairVal, _numPairs, _maxSet
713             if (_valCounts[_val] == 2) {
714                 if (_numPairs==0) _pairVal = _val;
715                 _numPairs++;
716             } else if (_valCounts[_val] == 3) {
717                 _maxSet = 3;
718             } else if (_valCounts[_val] == 4) {
719                 _maxSet = 4;
720             }
721         }
722 
723         if (_numPairs > 0){
724             // If they have quads, they can't have royal flush, so we can return.
725             if (_maxSet==4) return HAND_FK;
726             // One of the two pairs was the trips, so it's a full house.
727             if (_maxSet==3 && _numPairs==2) return HAND_FH;
728             // Trips is their best hand (no straight or flush possible)
729             if (_maxSet==3) return HAND_TK;
730             // Two pair is their best hand (no straight or flush possible)
731             if (_numPairs==2) return HAND_TP;
732             // One pair is their best hand (no straight or flush possible)
733             if (_numPairs == 1 && (_pairVal >= 10 || _pairVal==0)) return HAND_JB;
734             // They have a low pair (no straight or flush possible)
735             return HAND_HC;
736         }
737 
738         // They have no pair. Do they have a straight?
739         bool _hasStraight = _hasAce
740             // Check for: A,1,2,3,4 or 9,10,11,12,A
741             ? _maxNonAce == 4 || _minNonAce == 9
742             // Check for X,X+1,X+2,X+3,X+4
743             : _maxNonAce - _minNonAce == 4;
744         
745         // Check for hands in order of rank.
746         if (_hasStraight && _hasFlush && _minNonAce==9) return HAND_RF;
747         if (_hasStraight && _hasFlush) return HAND_SF;
748         if (_hasFlush) return HAND_FL;
749         if (_hasStraight) return HAND_ST;
750         return HAND_HC;
751     }
752 
753     // Not used anywhere, but added for convenience
754     function handToCards(uint32 _hand)
755         public
756         pure
757         returns (uint8[5] _cards)
758     {
759         uint32 _mask;
760         for (uint _i=0; _i<5; _i++){
761             _mask = uint32(63 * 2**(6*_i));
762             _cards[_i] = uint8((_hand & _mask) / (2**(6*_i)));
763         }
764     }
765 
766 
767 
768     /*****************************************************/
769     /********** PRIVATE INTERNAL FUNCTIONS ***************/
770     /*****************************************************/
771 
772     function readFromCards(uint _cards, uint _index)
773         internal
774         pure
775         returns (uint)
776     {
777         uint _offset = 2**(6*_index);
778         uint _oneBits = 2**6 - 1;
779         return (_cards & (_oneBits * _offset)) / _offset;
780     }
781 
782     // Returns a bitmap to represent the set of cards in _hand.
783     function handToBitmap(uint32 _hand)
784         internal
785         pure
786         returns (uint _bitmap)
787     {
788         if (_hand == 0) return 0;
789         uint _mask;
790         uint _card;
791         for (uint _i=0; _i<5; _i++){
792             _mask = 63 * 2**(6*_i);
793             _card = (_hand & _mask) / (2**(6*_i));
794             _bitmap |= 2**_card;
795         }
796     }
797 
798     // Returns numCards from a uint256 (eg, keccak256) seed hash.
799     // Returns cards as one uint, with each card being 6 bits.
800     function getCardsFromHash(uint256 _hash, uint _numCards, uint _usedBitmap)
801         internal
802         pure
803         returns (uint _cards)
804     {
805         // Return early if we don't need to pick any cards.
806         if (_numCards == 0) return;
807 
808         uint _cardIdx = 0;                // index of currentCard
809         uint _card;                       // current chosen card
810         uint _usedMask;                   // mask of current card
811 
812         while (true) {
813             _card = _hash % 52;           // Generate card from hash
814             _usedMask = 2**_card;         // Create mask for the card
815 
816             // If card is not used, add it to _cards and _usedBitmap
817             // Return if we have enough cards.
818             if (_usedBitmap & _usedMask == 0) {
819                 _cards |= (_card * 2**(_cardIdx*6));
820                 _usedBitmap |= _usedMask;
821                 _cardIdx++;
822                 if (_cardIdx == _numCards) return _cards;
823             }
824 
825             // Generate hash used to pick next card.
826             _hash = uint256(keccak256(_hash));
827         }
828     }
829 }
830 
831 contract VideoPoker is
832     VideoPokerUtils,
833     Bankrollable,
834     UsingAdmin
835 {
836     // All the data needed for each game.
837     struct Game {
838         // [1st 256-bit block]
839         uint32 userId;
840         uint64 bet;         // max of 18 Ether (set on bet)
841         uint16 payTableId;  // the PayTable used (set on bet)
842         uint32 iBlock;      // initial hand block (set on bet)
843         uint32 iHand;       // initial hand (set on draw/finalize)
844         uint8 draws;        // bitmap of which cards to draw (set on draw/finalize)
845         uint32 dBlock;      // block of the dHand (set on draw/finalize)
846         uint32 dHand;       // hand after draws (set on finalize)
847         uint8 handRank;     // result of the hand (set on finalize)
848     }
849 
850     // These variables change on each bet and finalization.
851     // We put them in a struct with the hopes that optimizer
852     //   will do one write if any/all of them change.
853     struct Vars {
854         // [1st 256-bit block]
855         uint32 curId;               // (changes on bet)
856         uint64 totalWageredGwei;    // (changes on bet)
857         uint32 curUserId;           // (changes on bet, maybe)
858         uint128 empty1;             // intentionally left empty, so the below
859                                     //   updates occur in the same update
860         // [2nd 256-bit block]
861         uint64 totalWonGwei;        // (changes on finalization win)
862         uint88 totalCredits;        // (changes on finalization win)
863         uint8 empty2;               // set to true to normalize gas cost
864     }
865 
866     struct Settings {
867         uint64 minBet;
868         uint64 maxBet;
869         uint16 curPayTableId;
870         uint16 numPayTables;
871         uint32 lastDayAdded;
872     }
873 
874     Settings settings;
875     Vars vars;
876 
877     // A Mapping of all games
878     mapping(uint32 => Game) public games;
879     
880     // Credits we owe the user
881     mapping(address => uint) public credits;
882 
883     // Store a two-way mapping of address <=> userId
884     // If we've seen a user before, betting will be just 1 write
885     //  per Game struct vs 2 writes.
886     // The trade-off is 3 writes for new users. Seems fair.
887     mapping (address => uint32) public userIds;
888     mapping (uint32 => address) public userAddresses;
889 
890     // Note: Pay tables cannot be changed once added.
891     // However, admin can change the current PayTable
892     mapping(uint16=>uint16[12]) payTables;
893 
894     // version of the game
895     uint8 public constant version = 1;
896     uint8 constant WARN_IHAND_TIMEOUT = 1; // "Initial hand not available. Drawing 5 new cards."
897     uint8 constant WARN_DHAND_TIMEOUT = 2; // "Draw cards not available. Using initial hand."
898     uint8 constant WARN_BOTH_TIMEOUT = 3;  // "Draw cards not available, and no initial hand."
899     
900     // Admin Events
901     event Created(uint time);
902     event PayTableAdded(uint time, address admin, uint payTableId);
903     event SettingsChanged(uint time, address admin);
904     // Game Events
905     event BetSuccess(uint time, address indexed user, uint32 indexed id, uint bet, uint payTableId);
906     event BetFailure(uint time, address indexed user, uint bet, string msg);
907     event DrawSuccess(uint time, address indexed user, uint32 indexed id, uint32 iHand, uint8 draws, uint8 warnCode);
908     event DrawFailure(uint time, address indexed user, uint32 indexed id, uint8 draws, string msg);
909     event FinalizeSuccess(uint time, address indexed user, uint32 indexed id, uint32 dHand, uint8 handRank, uint payout, uint8 warnCode);
910     event FinalizeFailure(uint time, address indexed user, uint32 indexed id, string msg);
911     // Credits
912     event CreditsAdded(uint time, address indexed user, uint32 indexed id, uint amount);
913     event CreditsUsed(uint time, address indexed user, uint32 indexed id, uint amount);
914     event CreditsCashedout(uint time, address indexed user, uint amount);
915         
916     constructor(address _registry)
917         Bankrollable(_registry)
918         UsingAdmin(_registry)
919         public
920     {
921         // Add the default PayTable.
922         _addPayTable(800, 50, 25, 9, 6, 4, 3, 2, 1);
923         // write to vars, to lower gas-cost for the first game.
924         vars.empty1 = 1;
925         vars.empty2 = 1;
926         // initialize settings
927         settings.minBet = .001 ether;
928         settings.maxBet = .5 ether;
929         emit Created(now);
930     }
931     
932     
933     /************************************************************/
934     /******************** ADMIN FUNCTIONS ***********************/
935     /************************************************************/
936     
937     // Allows admin to change minBet, maxBet, and curPayTableId
938     function changeSettings(uint64 _minBet, uint64 _maxBet, uint8 _payTableId)
939         public
940         fromAdmin
941     {
942         require(_minBet <= _maxBet);
943         require(_maxBet <= .625 ether);
944         require(_payTableId < settings.numPayTables);
945         settings.minBet = _minBet;
946         settings.maxBet = _maxBet;
947         settings.curPayTableId = _payTableId;
948         emit SettingsChanged(now, msg.sender);
949     }
950     
951     // Allows admin to permanently add a PayTable (once per day)
952     function addPayTable(
953         uint16 _rf, uint16 _sf, uint16 _fk, uint16 _fh,
954         uint16 _fl, uint16 _st, uint16 _tk, uint16 _tp, uint16 _jb
955     )
956         public
957         fromAdmin
958     {
959         uint32 _today = uint32(block.timestamp / 1 days);
960         require(settings.lastDayAdded < _today);
961         settings.lastDayAdded = _today;
962         _addPayTable(_rf, _sf, _fk, _fh, _fl, _st, _tk, _tp, _jb);
963         emit PayTableAdded(now, msg.sender, settings.numPayTables-1);
964     }
965     
966 
967     /************************************************************/
968     /****************** PUBLIC FUNCTIONS ************************/
969     /************************************************************/
970 
971     // Allows a user to add credits to their account.
972     function addCredits()
973         public
974         payable
975     {
976         _creditUser(msg.sender, msg.value, 0);
977     }
978 
979     // Allows the user to cashout an amt (or their whole balance)
980     function cashOut(uint _amt)
981         public
982     {
983         _uncreditUser(msg.sender, _amt);
984     }
985 
986     // Allows a user to create a game from Ether sent.
987     //
988     // Gas Cost: 55k (prev player), 95k (new player)
989     //   - 22k: tx overhead
990     //   - 26k, 66k: see _createNewGame()
991     //   -  3k: event
992     //   -  2k: curMaxBet()
993     //   -  2k: SLOAD, execution
994     function bet()
995         public
996         payable
997     {
998         uint _bet = msg.value;
999         if (_bet > settings.maxBet)
1000             return _betFailure("Bet too large.", _bet, true);
1001         if (_bet < settings.minBet)
1002             return _betFailure("Bet too small.", _bet, true);
1003         if (_bet > curMaxBet())
1004             return _betFailure("The bankroll is too low.", _bet, true);
1005 
1006         // no uint64 overflow: _bet < maxBet < .625 ETH < 2e64
1007         uint32 _id = _createNewGame(uint64(_bet));
1008         emit BetSuccess(now, msg.sender, _id, _bet, settings.curPayTableId);
1009     }
1010 
1011     // Allows a user to create a game from Credits.
1012     //
1013     // Gas Cost: 61k
1014     //   - 22k: tx overhead
1015     //   - 26k: see _createNewGame()
1016     //   -  3k: event
1017     //   -  2k: curMaxBet()
1018     //   -  2k: 1 event: CreditsUsed
1019     //   -  5k: update credits[user]
1020     //   -  1k: SLOAD, execution
1021     function betWithCredits(uint64 _bet)
1022         public
1023     {
1024         if (_bet > settings.maxBet)
1025             return _betFailure("Bet too large.", _bet, false);
1026         if (_bet < settings.minBet)
1027             return _betFailure("Bet too small.", _bet, false);
1028         if (_bet > curMaxBet())
1029             return _betFailure("The bankroll is too low.", _bet, false);
1030         if (_bet > credits[msg.sender])
1031             return _betFailure("Insufficient credits", _bet, false);
1032 
1033         uint32 _id = _createNewGame(uint64(_bet));
1034         credits[msg.sender] -= _bet;
1035         emit CreditsUsed(now, msg.sender, _id, _bet);
1036         emit BetSuccess(now, msg.sender, _id, _bet, settings.curPayTableId);
1037     }
1038 
1039     function betFromGame(uint32 _id, bytes32 _hashCheck)
1040         public
1041     {
1042         bool _didFinalize = finalize(_id, _hashCheck);
1043         uint64 _bet = games[_id].bet;
1044         if (!_didFinalize)
1045             return _betFailure("Failed to finalize prior game.", _bet, false);
1046         betWithCredits(_bet);
1047     }
1048 
1049         // Logs an error, and optionally refunds user the _bet
1050         function _betFailure(string _msg, uint _bet, bool _doRefund)
1051             private
1052         {
1053             if (_doRefund) require(msg.sender.call.value(_bet)());
1054             emit BetFailure(now, msg.sender, _bet, _msg);
1055         }
1056         
1057 
1058     // Resolves the initial hand (if possible) and sets the users draws.
1059     // Users cannot draw 0 cards. They should instead use finalize().
1060     //
1061     // Notes:
1062     //  - If user unable to resolve initial hand, sets draws to 5
1063     //  - This always sets game.dBlock
1064     //
1065     // Gas Cost: ~38k
1066     //   - 23k: tx
1067     //   - 13k: see _draw()
1068     //   -  2k: SLOADs, execution
1069     function draw(uint32 _id, uint8 _draws, bytes32 _hashCheck)
1070         public
1071     {
1072         Game storage _game = games[_id];
1073         address _user = userAddresses[_game.userId];
1074         if (_game.iBlock == 0)
1075             return _drawFailure(_id, _draws, "Invalid game Id.");
1076         if (_user != msg.sender)
1077             return _drawFailure(_id, _draws, "This is not your game.");
1078         if (_game.iBlock == block.number)
1079             return _drawFailure(_id, _draws, "Initial cards not available.");
1080         if (_game.dBlock != 0)
1081             return _drawFailure(_id, _draws, "Cards already drawn.");
1082         if (_draws > 31)
1083             return _drawFailure(_id, _draws, "Invalid draws.");
1084         if (_draws == 0)
1085             return _drawFailure(_id, _draws, "Cannot draw 0 cards. Use finalize instead.");
1086         if (_game.handRank != HAND_UNDEFINED)
1087             return _drawFailure(_id, _draws, "Game already finalized.");
1088         
1089         _draw(_game, _id, _draws, _hashCheck);
1090     }
1091         function _drawFailure(uint32 _id, uint8 _draws, string _msg)
1092             private
1093         {
1094             emit DrawFailure(now, msg.sender, _id, _draws, _msg);
1095         }
1096       
1097 
1098     // Callable any time after the initial hand. Will assume
1099     // no draws if called directly after new hand.
1100     //
1101     // Gas Cost: 44k (loss), 59k (win, has credits), 72k (win, no credits)
1102     //   - 22k: tx overhead
1103     //   - 21k, 36k, 49k: see _finalize()
1104     //   -  1k: SLOADs, execution
1105     function finalize(uint32 _id, bytes32 _hashCheck)
1106         public
1107         returns (bool _didFinalize)
1108     {
1109         Game storage _game = games[_id];
1110         address _user = userAddresses[_game.userId];
1111         if (_game.iBlock == 0)
1112             return _finalizeFailure(_id, "Invalid game Id.");
1113         if (_user != msg.sender)
1114             return _finalizeFailure(_id, "This is not your game.");
1115         if (_game.iBlock == block.number)
1116             return _finalizeFailure(_id, "Initial hand not avaiable.");
1117         if (_game.dBlock == block.number)
1118             return _finalizeFailure(_id, "Drawn cards not available.");
1119         if (_game.handRank != HAND_UNDEFINED)
1120             return _finalizeFailure(_id, "Game already finalized.");
1121 
1122         _finalize(_game, _id, _hashCheck);
1123         return true;
1124     }
1125         function _finalizeFailure(uint32 _id, string _msg)
1126             private
1127             returns (bool)
1128         {
1129             emit FinalizeFailure(now, msg.sender, _id, _msg);
1130             return false;
1131         }
1132 
1133 
1134     /************************************************************/
1135     /****************** PRIVATE FUNCTIONS ***********************/
1136     /************************************************************/
1137 
1138     // Appends a PayTable to the mapping.
1139     // It ensures sane values. (Double the defaults)
1140     function _addPayTable(
1141         uint16 _rf, uint16 _sf, uint16 _fk, uint16 _fh,
1142         uint16 _fl, uint16 _st, uint16 _tk, uint16 _tp, uint16 _jb
1143     )
1144         private
1145     {
1146         require(_rf<=1600 && _sf<=100 && _fk<=50 && _fh<=18 && _fl<=12 
1147                  && _st<=8 && _tk<=6 && _tp<=4 && _jb<=2);
1148 
1149         uint16[12] memory _pt;
1150         _pt[HAND_UNDEFINED] = 0;
1151         _pt[HAND_RF] = _rf;
1152         _pt[HAND_SF] = _sf;
1153         _pt[HAND_FK] = _fk;
1154         _pt[HAND_FH] = _fh;
1155         _pt[HAND_FL] = _fl;
1156         _pt[HAND_ST] = _st;
1157         _pt[HAND_TK] = _tk;
1158         _pt[HAND_TP] = _tp;
1159         _pt[HAND_JB] = _jb;
1160         _pt[HAND_HC] = 0;
1161         _pt[HAND_NOT_COMPUTABLE] = 0;
1162         payTables[settings.numPayTables] = _pt;
1163         settings.numPayTables++;
1164     }
1165 
1166     // Increases totalCredits and credits[user]
1167     // Optionally increases totalWonGwei stat.
1168     function _creditUser(address _user, uint _amt, uint32 _gameId)
1169         private
1170     {
1171         if (_amt == 0) return;
1172         uint64 _incr = _gameId == 0 ? 0 : uint64(_amt / 1e9);
1173         uint88 _totalCredits = vars.totalCredits + uint88(_amt);
1174         uint64 _totalWonGwei = vars.totalWonGwei + _incr;
1175         vars.totalCredits = _totalCredits;
1176         vars.totalWonGwei = _totalWonGwei;
1177         credits[_user] += _amt;
1178         emit CreditsAdded(now, _user, _gameId, _amt);
1179     }
1180 
1181     // Lowers totalCredits and credits[user].
1182     // Sends to user, using unlimited gas.
1183     function _uncreditUser(address _user, uint _amt)
1184         private
1185     {
1186         if (_amt > credits[_user] || _amt == 0) _amt = credits[_user];
1187         if (_amt == 0) return;
1188         vars.totalCredits -= uint88(_amt);
1189         credits[_user] -= _amt;
1190         require(_user.call.value(_amt)());
1191         emit CreditsCashedout(now, _user, _amt);
1192     }
1193 
1194     // Creates a new game with the specified bet and current PayTable.
1195     // Does no validation of the _bet size.
1196     //
1197     // Gas Cost: 26k, 66k
1198     //   Overhead:
1199     //     - 20k: 1 writes: Game
1200     //     -  5k: 1 update: vars
1201     //     -  1k: SLOAD, execution
1202     //   New User:
1203     //     - 40k: 2 writes: userIds, userAddresses
1204     //   Repeat User:
1205     //     -  0k: nothing extra
1206     function _createNewGame(uint64 _bet)
1207         private
1208         returns (uint32 _curId)
1209     {
1210         // get or create user id
1211         uint32 _curUserId = vars.curUserId;
1212         uint32 _userId = userIds[msg.sender];
1213         if (_userId == 0) {
1214             _curUserId++;
1215             userIds[msg.sender] = _curUserId;
1216             userAddresses[_curUserId] = msg.sender;
1217             _userId = _curUserId;
1218         }
1219 
1220         // increment vars
1221         _curId =  vars.curId + 1;
1222         uint64 _totalWagered = vars.totalWageredGwei + _bet / 1e9;
1223         vars.curId = _curId;
1224         vars.totalWageredGwei = _totalWagered;
1225         vars.curUserId = _curUserId;
1226 
1227         // save game
1228         uint16 _payTableId = settings.curPayTableId;
1229         Game storage _game = games[_curId];
1230         _game.userId = _userId;
1231         _game.bet = _bet;
1232         _game.payTableId = _payTableId;
1233         _game.iBlock = uint32(block.number);
1234         return _curId;
1235     }
1236 
1237     // Gets initialHand, and stores .draws and .dBlock.
1238     // Gas Cost: 13k
1239     //   - 3k: getHand()
1240     //   - 5k: 1 update: iHand, draws, dBlock
1241     //   - 3k: event: DrawSuccess
1242     //   - 2k: SLOADs, other
1243     function _draw(Game storage _game, uint32 _id, uint8 _draws, bytes32 _hashCheck)
1244         private
1245     {
1246         // assert hand is not already drawn
1247         assert(_game.dBlock == 0);
1248 
1249         // Deal the initial hand, or set draws to 5.
1250         uint32 _iHand;
1251         bytes32 _iBlockHash = blockhash(_game.iBlock);
1252         uint8 _warnCode;
1253         if (_iBlockHash != 0) {
1254             // Ensure they are drawing against expected hand
1255             if (_iBlockHash != _hashCheck) {
1256                 return _drawFailure(_id, _draws, "HashCheck Failed. Try refreshing game.");
1257             }
1258             _iHand = getHand(uint(keccak256(_iBlockHash, _id)));
1259         } else {
1260             _warnCode = WARN_IHAND_TIMEOUT;
1261             _draws = 31;
1262         }
1263 
1264         // update game
1265         _game.iHand = _iHand;
1266         _game.draws = _draws;
1267         _game.dBlock = uint32(block.number);
1268 
1269         emit DrawSuccess(now, msg.sender, _id, _game.iHand, _draws, _warnCode);
1270     }
1271 
1272     // Resolves game based on .iHand and .draws, crediting user on a win.
1273     // This always sets game.dHand and game.handRank.
1274     //
1275     // There are four possible scenarios:
1276     //   User draws N cads, and dBlock is fresh:
1277     //     - draw N cards into iHand, this is dHand
1278     //   User draws N cards, and dBlock is too old:
1279     //     - set dHand to iHand (note: iHand may be empty)
1280     //   User draws 0 cards, and iBlock is fresh:
1281     //     - draw 5 cards into iHand, set dHand to iHand
1282     //   User draws 0 cards, and iBlock is too old:
1283     //     - fail: set draws to 5, return. (user should call finalize again)
1284     //
1285     // Gas Cost: 21k loss, 36k win, 49k new win
1286     //   - 6k: if draws > 0: drawToHand()
1287     //   - 7k: getHandRank()
1288     //   - 5k: 1 update: Game
1289     //   - 2k: FinalizeSuccess
1290     //   - 1k: SLOADs, execution
1291     //   On Win: +13k, or +28k
1292     //   - 5k: 1 updates: totalCredits, totalWon
1293     //   - 5k or 20k: 1 update/write to credits[user]
1294     //   - 2k: event: AccountCredited
1295     //   - 1k: SLOADs, execution
1296     function _finalize(Game storage _game, uint32 _id, bytes32 _hashCheck)
1297         private
1298     {
1299         // Require game is not already finalized
1300         assert(_game.handRank == HAND_UNDEFINED);
1301 
1302         // Compute _dHand
1303         address _user = userAddresses[_game.userId];
1304         bytes32 _blockhash;
1305         uint32 _dHand;
1306         uint32 _iHand;  // set if draws are 0, and iBlock is fresh
1307         uint8 _warnCode;
1308         if (_game.draws != 0) {
1309             _blockhash = blockhash(_game.dBlock);
1310             if (_blockhash != 0) {
1311                 // draw cards to iHand, use as dHand
1312                 _dHand = drawToHand(uint(keccak256(_blockhash, _id)), _game.iHand, _game.draws);
1313             } else {
1314                 // cannot draw any cards. use iHand.
1315                 if (_game.iHand != 0){
1316                     _dHand = _game.iHand;
1317                     _warnCode = WARN_DHAND_TIMEOUT;
1318                 } else {
1319                     _dHand = 0;
1320                     _warnCode = WARN_BOTH_TIMEOUT;
1321                 }
1322             }
1323         } else {
1324             _blockhash = blockhash(_game.iBlock);
1325             if (_blockhash != 0) {
1326                 // ensure they are drawing against expected hand
1327                 if (_blockhash != _hashCheck) {
1328                     _finalizeFailure(_id, "HashCheck Failed. Try refreshing game.");
1329                     return;
1330                 }
1331                 // draw 5 cards into iHand, use as dHand
1332                 _iHand = getHand(uint(keccak256(_blockhash, _id)));
1333                 _dHand = _iHand;
1334             } else {
1335                 // can't finalize with iHand. Draw 5 cards.
1336                 _finalizeFailure(_id, "Initial hand not available. Drawing 5 new cards.");
1337                 _game.draws = 31;
1338                 _game.dBlock = uint32(block.number);
1339                 emit DrawSuccess(now, _user, _id, 0, 31, WARN_IHAND_TIMEOUT);
1340                 return;
1341             }
1342         }
1343 
1344         // Compute _handRank. be sure dHand is not empty
1345         uint8 _handRank = _dHand == 0
1346             ? uint8(HAND_NOT_COMPUTABLE)
1347             : uint8(getHandRank(_dHand));
1348 
1349         // This only happens if draws==0, and iHand was drawable.
1350         if (_iHand > 0) _game.iHand = _iHand;
1351         // Always set dHand and handRank
1352         _game.dHand = _dHand;
1353         _game.handRank = _handRank;
1354 
1355         // Compute _payout, credit user, emit event.
1356         uint _payout = payTables[_game.payTableId][_handRank] * uint(_game.bet);
1357         if (_payout > 0) _creditUser(_user, _payout, _id);
1358         emit FinalizeSuccess(now, _user, _id, _game.dHand, _game.handRank, _payout, _warnCode);
1359     }
1360 
1361 
1362 
1363     /************************************************************/
1364     /******************** PUBLIC VIEWS **************************/
1365     /************************************************************/
1366 
1367     // IMPLEMENTS: Bankrollable.getProfits()
1368     // Ensures contract always has at least bankroll + totalCredits.
1369     function getCollateral() public view returns (uint _amount) {
1370         return vars.totalCredits;
1371     }
1372 
1373     // IMPLEMENTS: Bankrollable.getWhitelistOwner()
1374     // Ensures contract always has at least bankroll + totalCredits.
1375     function getWhitelistOwner() public view returns (address _wlOwner) {
1376         return getAdmin();
1377     }
1378 
1379     // Returns the largest bet such that we could pay out two RoyalFlushes.
1380     // The likelihood that two RoyalFlushes (with max bet size) are 
1381     //  won within a 255 block period is extremely low.
1382     function curMaxBet() public view returns (uint) {
1383         // Return largest bet such that RF*2*bet = bankrollable
1384         uint _maxPayout = payTables[settings.curPayTableId][HAND_RF] * 2;
1385         return bankrollAvailable() / _maxPayout;
1386     }
1387 
1388     // Return the less of settings.maxBet and curMaxBet()
1389     function effectiveMaxBet() public view returns (uint _amount) {
1390         uint _curMax = curMaxBet();
1391         return _curMax > settings.maxBet ? settings.maxBet : _curMax;
1392     }
1393 
1394     function getPayTable(uint16 _payTableId)
1395         public
1396         view
1397         returns (uint16[12])
1398     {
1399         require(_payTableId < settings.numPayTables);
1400         return payTables[_payTableId];
1401     }
1402 
1403     function getCurPayTable()
1404         public
1405         view
1406         returns (uint16[12])
1407     {
1408         return getPayTable(settings.curPayTableId);
1409     }
1410 
1411     // Gets the initial hand of a game.
1412     function getIHand(uint32 _id)
1413         public
1414         view
1415         returns (uint32)
1416     {
1417         Game memory _game = games[_id];
1418         if (_game.iHand != 0) return _game.iHand;
1419         if (_game.iBlock == 0) return;
1420         
1421         bytes32 _iBlockHash = blockhash(_game.iBlock);
1422         if (_iBlockHash == 0) return;
1423         return getHand(uint(keccak256(_iBlockHash, _id)));
1424     }
1425 
1426     // Get the final hand of a game.
1427     // This will return iHand if there are no draws yet.
1428     function getDHand(uint32 _id)
1429         public
1430         view
1431         returns (uint32)
1432     {
1433         Game memory _game = games[_id];
1434         if (_game.dHand != 0) return _game.dHand;
1435         if (_game.draws == 0) return _game.iHand;
1436         if (_game.dBlock == 0) return;
1437 
1438         bytes32 _dBlockHash = blockhash(_game.dBlock);
1439         if (_dBlockHash == 0) return _game.iHand;
1440         return drawToHand(uint(keccak256(_dBlockHash, _id)), _game.iHand, _game.draws);
1441     }
1442 
1443     // Returns the hand rank and payout of a Game.
1444     function getDHandRank(uint32 _id)
1445         public
1446         view
1447         returns (uint8)
1448     {
1449         uint32 _dHand = getDHand(_id);
1450         return _dHand == 0
1451             ? uint8(HAND_NOT_COMPUTABLE)
1452             : uint8(getHandRank(_dHand));
1453     }
1454 
1455     // Expose Vars //////////////////////////////////////
1456     function curId() public view returns (uint32) {
1457         return vars.curId;
1458     }
1459     function totalWagered() public view returns (uint) {
1460         return uint(vars.totalWageredGwei) * 1e9;
1461     }
1462     function curUserId() public view returns (uint) {
1463         return uint(vars.curUserId);
1464     }
1465     function totalWon() public view returns (uint) {
1466         return uint(vars.totalWonGwei) * 1e9;
1467     }
1468     function totalCredits() public view returns (uint) {
1469         return vars.totalCredits;
1470     }
1471     /////////////////////////////////////////////////////
1472 
1473     // Expose Settings //////////////////////////////////
1474     function minBet() public view returns (uint) {
1475         return settings.minBet;
1476     }
1477     function maxBet() public view returns (uint) {
1478         return settings.maxBet;
1479     }
1480     function curPayTableId() public view returns (uint) {
1481         return settings.curPayTableId;
1482     }
1483     function numPayTables() public view returns (uint) {
1484         return settings.numPayTables;
1485     }
1486     /////////////////////////////////////////////////////
1487 }