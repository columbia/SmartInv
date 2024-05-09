1 // File: contracts/GodMode.sol
2 
3 /****************************************************
4  *
5  * Copyright 2018 BurzNest LLC. All rights reserved.
6  *
7  * The contents of this file are provided for review
8  * and educational purposes ONLY. You MAY NOT use,
9  * copy, distribute, or modify this software without
10  * explicit written permission from BurzNest LLC.
11  *
12  ****************************************************/
13 
14 pragma solidity ^0.4.24;
15 
16 /// @title God Mode
17 /// @author Anthony Burzillo <burz@burznest.com>
18 /// @dev This contract provides a basic interface for God
19 ///  in a contract as well as the ability for God to pause
20 ///  the contract
21 contract GodMode {
22     /// @dev Is the contract paused?
23     bool public isPaused;
24 
25     /// @dev God's address
26     address public god;
27 
28     /// @dev Only God can run this function
29     modifier onlyGod()
30     {
31         require(god == msg.sender);
32         _;
33     }
34 
35     /// @dev This function can only be run while the contract
36     ///  is not paused
37     modifier notPaused()
38     {
39         require(!isPaused);
40         _;
41     }
42 
43     /// @dev This event is fired when the contract is paused
44     event GodPaused();
45 
46     /// @dev This event is fired when the contract is unpaused
47     event GodUnpaused();
48 
49     constructor() public
50     {
51         // Make the creator of the contract God
52         god = msg.sender;
53     }
54 
55     /// @dev God can change the address of God
56     /// @param _newGod The new address for God
57     function godChangeGod(address _newGod) public onlyGod
58     {
59         god = _newGod;
60     }
61 
62     /// @dev God can pause the game
63     function godPause() public onlyGod
64     {
65         isPaused = true;
66 
67         emit GodPaused();
68     }
69 
70     /// @dev God can unpause the game
71     function godUnpause() public onlyGod
72     {
73         isPaused = false;
74 
75         emit GodUnpaused();
76     }
77 }
78 
79 // File: contracts/KingOfEthAbstractInterface.sol
80 
81 /****************************************************
82  *
83  * Copyright 2018 BurzNest LLC. All rights reserved.
84  *
85  * The contents of this file are provided for review
86  * and educational purposes ONLY. You MAY NOT use,
87  * copy, distribute, or modify this software without
88  * explicit written permission from BurzNest LLC.
89  *
90  ****************************************************/
91 
92 pragma solidity ^0.4.24;
93 
94 /// @title King of Eth Abstract Interface
95 /// @author Anthony Burzillo <burz@burznest.com>
96 /// @dev Abstract interface contract for titles and taxes
97 contract KingOfEthAbstractInterface {
98     /// @dev The address of the current King
99     address public king;
100 
101     /// @dev The address of the current Wayfarer
102     address public wayfarer;
103 
104     /// @dev Anyone can pay taxes
105     function payTaxes() public payable;
106 }
107 
108 // File: contracts/KingOfEthAuctionsAbstractInterface.sol
109 
110 /****************************************************
111  *
112  * Copyright 2018 BurzNest LLC. All rights reserved.
113  *
114  * The contents of this file are provided for review
115  * and educational purposes ONLY. You MAY NOT use,
116  * copy, distribute, or modify this software without
117  * explicit written permission from BurzNest LLC.
118  *
119  ****************************************************/
120 
121 pragma solidity ^0.4.24;
122 
123 /// @title King of Eth: Auctions Abstract Interface
124 /// @author Anthony Burzillo <burz@burznest.com>
125 /// @dev Abstract interface contract for auctions of houses
126 contract KingOfEthAuctionsAbstractInterface {
127     /// @dev Determines if there is an auction at a particular location
128     /// @param _x The x coordinate of the auction
129     /// @param _y The y coordinate of the auction
130     /// @return true if there is an existing auction
131     function existingAuction(uint _x, uint _y) public view returns(bool);
132 }
133 
134 // File: contracts/KingOfEthBlindAuctionsReferencer.sol
135 
136 /****************************************************
137  *
138  * Copyright 2018 BurzNest LLC. All rights reserved.
139  *
140  * The contents of this file are provided for review
141  * and educational purposes ONLY. You MAY NOT use,
142  * copy, distribute, or modify this software without
143  * explicit written permission from BurzNest LLC.
144  *
145  ****************************************************/
146 
147 pragma solidity ^0.4.24;
148 
149 
150 /// @title King of Eth: Blind Auctions Referencer
151 /// @author Anthony Burzillo <burz@burznest.com>
152 /// @dev This contract provides a reference to the blind auctions contract
153 contract KingOfEthBlindAuctionsReferencer is GodMode {
154     /// @dev The address of the blind auctions contract
155     address public blindAuctionsContract;
156 
157     /// @dev Only the blind auctions contract can run this
158     modifier onlyBlindAuctionsContract()
159     {
160         require(blindAuctionsContract == msg.sender);
161         _;
162     }
163 
164     /// @dev God can set a new blind auctions contract
165     /// @param _blindAuctionsContract the address of the blind auctions
166     ///  contract
167     function godSetBlindAuctionsContract(address _blindAuctionsContract)
168         public
169         onlyGod
170     {
171         blindAuctionsContract = _blindAuctionsContract;
172     }
173 }
174 
175 // File: contracts/KingOfEthOpenAuctionsReferencer.sol
176 
177 /****************************************************
178  *
179  * Copyright 2018 BurzNest LLC. All rights reserved.
180  *
181  * The contents of this file are provided for review
182  * and educational purposes ONLY. You MAY NOT use,
183  * copy, distribute, or modify this software without
184  * explicit written permission from BurzNest LLC.
185  *
186  ****************************************************/
187 
188 pragma solidity ^0.4.24;
189 
190 
191 /// @title King of Eth: Open Auctions Referencer
192 /// @author Anthony Burzillo <burz@burznest.com>
193 /// @dev This contract provides a reference to the open auctions contract
194 contract KingOfEthOpenAuctionsReferencer is GodMode {
195     /// @dev The address of the auctions contract
196     address public openAuctionsContract;
197 
198     /// @dev Only the open auctions contract can run this
199     modifier onlyOpenAuctionsContract()
200     {
201         require(openAuctionsContract == msg.sender);
202         _;
203     }
204 
205     /// @dev God can set a new auctions contract
206     function godSetOpenAuctionsContract(address _openAuctionsContract)
207         public
208         onlyGod
209     {
210         openAuctionsContract = _openAuctionsContract;
211     }
212 }
213 
214 // File: contracts/KingOfEthAuctionsReferencer.sol
215 
216 /****************************************************
217  *
218  * Copyright 2018 BurzNest LLC. All rights reserved.
219  *
220  * The contents of this file are provided for review
221  * and educational purposes ONLY. You MAY NOT use,
222  * copy, distribute, or modify this software without
223  * explicit written permission from BurzNest LLC.
224  *
225  ****************************************************/
226 
227 pragma solidity ^0.4.24;
228 
229 
230 
231 /// @title King of Eth: Auctions Referencer
232 /// @author Anthony Burzillo <burz@burznest.com>
233 /// @dev This contract provides a reference to the auctions contracts
234 contract KingOfEthAuctionsReferencer is
235       KingOfEthBlindAuctionsReferencer
236     , KingOfEthOpenAuctionsReferencer
237 {
238     /// @dev Only an auctions contract can run this
239     modifier onlyAuctionsContract()
240     {
241         require(blindAuctionsContract == msg.sender
242              || openAuctionsContract == msg.sender);
243         _;
244     }
245 }
246 
247 // File: contracts/KingOfEthReferencer.sol
248 
249 /****************************************************
250  *
251  * Copyright 2018 BurzNest LLC. All rights reserved.
252  *
253  * The contents of this file are provided for review
254  * and educational purposes ONLY. You MAY NOT use,
255  * copy, distribute, or modify this software without
256  * explicit written permission from BurzNest LLC.
257  *
258  ****************************************************/
259 
260 pragma solidity ^0.4.24;
261 
262 
263 /// @title King of Eth Referencer
264 /// @author Anthony Burzillo <burz@burznest.com>
265 /// @dev Functionality to allow contracts to reference the king contract
266 contract KingOfEthReferencer is GodMode {
267     /// @dev The address of the king contract
268     address public kingOfEthContract;
269 
270     /// @dev Only the king contract can run this
271     modifier onlyKingOfEthContract()
272     {
273         require(kingOfEthContract == msg.sender);
274         _;
275     }
276 
277     /// @dev God can change the king contract
278     /// @param _kingOfEthContract The new address
279     function godSetKingOfEthContract(address _kingOfEthContract)
280         public
281         onlyGod
282     {
283         kingOfEthContract = _kingOfEthContract;
284     }
285 }
286 
287 // File: contracts/KingOfEthBoard.sol
288 
289 /****************************************************
290  *
291  * Copyright 2018 BurzNest LLC. All rights reserved.
292  *
293  * The contents of this file are provided for review
294  * and educational purposes ONLY. You MAY NOT use,
295  * copy, distribute, or modify this software without
296  * explicit written permission from BurzNest LLC.
297  *
298  ****************************************************/
299 
300 pragma solidity ^0.4.24;
301 
302 
303 
304 
305 
306 /// @title King of Eth: Board
307 /// @author Anthony Burzillo <burz@burznest.com>
308 /// @dev Contract for board
309 contract KingOfEthBoard is
310       GodMode
311     , KingOfEthAuctionsReferencer
312     , KingOfEthReferencer
313 {
314     /// @dev x coordinate of the top left corner of the boundary
315     uint public boundX1 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef;
316 
317     /// @dev y coordinate of the top left corner of the boundary
318     uint public boundY1 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef;
319 
320     /// @dev x coordinate of the bottom right corner of the boundary
321     uint public boundX2 = 0x800000000000000000000000000000000000000000000000000000000000000f;
322 
323     /// @dev y coordinate of the bottom right corner of the boundary
324     uint public boundY2 = 0x800000000000000000000000000000000000000000000000000000000000000f;
325 
326     /// @dev Number used to divide the total number of house locations
327     /// after any expansion to yield the number of auctions that  will be
328     /// available to start for the expansion's duration
329     uint public constant auctionsAvailableDivisor = 10;
330 
331     /// @dev Amount of time the King must wait between increasing the board
332     uint public constant kingTimeBetweenIncrease = 2 weeks;
333 
334     /// @dev Amount of time the Wayfarer must wait between increasing the board
335     uint public constant wayfarerTimeBetweenIncrease = 3 weeks;
336 
337     /// @dev Amount of time that anyone but the King or Wayfarer must wait
338     ///  before increasing the board
339     uint public constant plebTimeBetweenIncrease = 4 weeks;
340 
341     /// @dev The last time the board was increased in size
342     uint public lastIncreaseTime;
343 
344     /// @dev The direction of the next increase
345     uint8 public nextIncreaseDirection;
346 
347     /// @dev The number of auctions that players may choose to start
348     ///  for this expansion
349     uint public auctionsRemaining;
350 
351     constructor() public
352     {
353         // Game is paused as God must start it
354         isPaused = true;
355 
356         // Set the auctions remaining
357         setAuctionsAvailableForBounds();
358     }
359 
360     /// @dev Fired when the board is increased in size
361     event BoardSizeIncreased(
362           address initiator
363         , uint newBoundX1
364         , uint newBoundY1
365         , uint newBoundX2
366         , uint newBoundY2
367         , uint lastIncreaseTime
368         , uint nextIncreaseDirection
369         , uint auctionsRemaining
370     );
371 
372     /// @dev Only the King can run this
373     modifier onlyKing()
374     {
375         require(KingOfEthAbstractInterface(kingOfEthContract).king() == msg.sender);
376         _;
377     }
378 
379     /// @dev Only the Wayfarer can run this
380     modifier onlyWayfarer()
381     {
382         require(KingOfEthAbstractInterface(kingOfEthContract).wayfarer() == msg.sender);
383         _;
384     }
385 
386     /// @dev Set the total auctions available
387     function setAuctionsAvailableForBounds() private
388     {
389         uint boundDiffX = boundX2 - boundX1;
390         uint boundDiffY = boundY2 - boundY1;
391 
392         auctionsRemaining = boundDiffX * boundDiffY / 2 / auctionsAvailableDivisor;
393     }
394 
395     /// @dev Increase the board's size making sure to keep steady at
396     ///  the maximum outer bounds
397     function increaseBoard() private
398     {
399         // The length of increase
400         uint _increaseLength;
401 
402         // If this increase direction is right
403         if(0 == nextIncreaseDirection)
404         {
405             _increaseLength = boundX2 - boundX1;
406             uint _updatedX2 = boundX2 + _increaseLength;
407 
408             // Stay within bounds
409             if(_updatedX2 <= boundX2 || _updatedX2 <= _increaseLength)
410             {
411                 boundX2 = ~uint(0);
412             }
413             else
414             {
415                 boundX2 = _updatedX2;
416             }
417         }
418         // If this increase direction is down
419         else if(1 == nextIncreaseDirection)
420         {
421             _increaseLength = boundY2 - boundY1;
422             uint _updatedY2 = boundY2 + _increaseLength;
423 
424             // Stay within bounds
425             if(_updatedY2 <= boundY2 || _updatedY2 <= _increaseLength)
426             {
427                 boundY2 = ~uint(0);
428             }
429             else
430             {
431                 boundY2 = _updatedY2;
432             }
433         }
434         // If this increase direction is left
435         else if(2 == nextIncreaseDirection)
436         {
437             _increaseLength = boundX2 - boundX1;
438 
439             // Stay within bounds
440             if(boundX1 <= _increaseLength)
441             {
442                 boundX1 = 0;
443             }
444             else
445             {
446                 boundX1 -= _increaseLength;
447             }
448         }
449         // If this increase direction is up
450         else if(3 == nextIncreaseDirection)
451         {
452             _increaseLength = boundY2 - boundY1;
453 
454             // Stay within bounds
455             if(boundY1 <= _increaseLength)
456             {
457                 boundY1 = 0;
458             }
459             else
460             {
461                 boundY1 -= _increaseLength;
462             }
463         }
464 
465         // The last increase time is now
466         lastIncreaseTime = now;
467 
468         // Set the next increase direction
469         nextIncreaseDirection = (nextIncreaseDirection + 1) % 4;
470 
471         // Reset the auctions available
472         setAuctionsAvailableForBounds();
473 
474         emit BoardSizeIncreased(
475               msg.sender
476             , boundX1
477             , boundY1
478             , boundX2
479             , boundY2
480             , now
481             , nextIncreaseDirection
482             , auctionsRemaining
483         );
484     }
485 
486     /// @dev God can start the game
487     function godStartGame() public onlyGod
488     {
489         // Reset increase times
490         lastIncreaseTime = now;
491 
492         // Unpause the game
493         godUnpause();
494     }
495 
496     /// @dev The auctions contracts can decrement the number
497     ///  of auctions that are available to be started
498     function auctionsDecrementAuctionsRemaining()
499         public
500         onlyAuctionsContract
501     {
502         auctionsRemaining -= 1;
503     }
504 
505     /// @dev The auctions contracts can increment the number
506     ///  of auctions that are available to be started when
507     ///  an auction ends wihout a winner
508     function auctionsIncrementAuctionsRemaining()
509         public
510         onlyAuctionsContract
511     {
512         auctionsRemaining += 1;
513     }
514 
515     /// @dev The King can increase the board much faster than the plebs
516     function kingIncreaseBoard()
517         public
518         onlyKing
519     {
520         // Require enough time has passed since the last increase
521         require(lastIncreaseTime + kingTimeBetweenIncrease < now);
522 
523         increaseBoard();
524     }
525 
526     /// @dev The Wayfarer can increase the board faster than the plebs
527     function wayfarerIncreaseBoard()
528         public
529         onlyWayfarer
530     {
531         // Require enough time has passed since the last increase
532         require(lastIncreaseTime + wayfarerTimeBetweenIncrease < now);
533 
534         increaseBoard();
535     }
536 
537     /// @dev Any old pleb can increase the board
538     function plebIncreaseBoard() public
539     {
540         // Require enough time has passed since the last increase
541         require(lastIncreaseTime + plebTimeBetweenIncrease < now);
542 
543         increaseBoard();
544     }
545 }
546 
547 // File: contracts/KingOfEthBoardReferencer.sol
548 
549 /****************************************************
550  *
551  * Copyright 2018 BurzNest LLC. All rights reserved.
552  *
553  * The contents of this file are provided for review
554  * and educational purposes ONLY. You MAY NOT use,
555  * copy, distribute, or modify this software without
556  * explicit written permission from BurzNest LLC.
557  *
558  ****************************************************/
559 
560 pragma solidity ^0.4.24;
561 
562 
563 /// @title King of Eth: Board Referencer
564 /// @author Anthony Burzillo <burz@burznest.com>
565 /// @dev Functionality to allow contracts to reference the board contract
566 contract KingOfEthBoardReferencer is GodMode {
567     /// @dev The address of the board contract
568     address public boardContract;
569 
570     /// @dev Only the board contract can run this
571     modifier onlyBoardContract()
572     {
573         require(boardContract == msg.sender);
574         _;
575     }
576 
577     /// @dev God can change the board contract
578     /// @param _boardContract The new address
579     function godSetBoardContract(address _boardContract)
580         public
581         onlyGod
582     {
583         boardContract = _boardContract;
584     }
585 }
586 
587 // File: contracts/KingOfEthHousesAbstractInterface.sol
588 
589 /****************************************************
590  *
591  * Copyright 2018 BurzNest LLC. All rights reserved.
592  *
593  * The contents of this file are provided for review
594  * and educational purposes ONLY. You MAY NOT use,
595  * copy, distribute, or modify this software without
596  * explicit written permission from BurzNest LLC.
597  *
598  ****************************************************/
599 
600 pragma solidity ^0.4.24;
601 
602 /// @title King of Eth: Houses Abstract Interface
603 /// @author Anthony Burzillo <burz@burznest.com>
604 /// @dev Abstract interface contract for houses
605 contract KingOfEthHousesAbstractInterface {
606     /// @dev Get the owner of the house at some location
607     /// @param _x The x coordinate of the house
608     /// @param _y The y coordinate of the house
609     /// @return The address of the owner
610     function ownerOf(uint _x, uint _y) public view returns(address);
611 
612     /// @dev Get the level of the house at some location
613     /// @param _x The x coordinate of the house
614     /// @param _y The y coordinate of the house
615     /// @return The level of the house
616     function level(uint _x, uint _y) public view returns(uint8);
617 
618     /// @dev The auctions contracts can set the owner of a house after an auction
619     /// @param _x The x coordinate of the house
620     /// @param _y The y coordinate of the house
621     /// @param _owner The new owner of the house
622     function auctionsSetOwner(uint _x, uint _y, address _owner) public;
623 
624     /// @dev The house realty contract can transfer house ownership
625     /// @param _x The x coordinate of the house
626     /// @param _y The y coordinate of the house
627     /// @param _from The previous owner of house
628     /// @param _to The new owner of house
629     function houseRealtyTransferOwnership(
630           uint _x
631         , uint _y
632         , address _from
633         , address _to
634     ) public;
635 }
636 
637 // File: contracts/KingOfEthHousesReferencer.sol
638 
639 /****************************************************
640  *
641  * Copyright 2018 BurzNest LLC. All rights reserved.
642  *
643  * The contents of this file are provided for review
644  * and educational purposes ONLY. You MAY NOT use,
645  * copy, distribute, or modify this software without
646  * explicit written permission from BurzNest LLC.
647  *
648  ****************************************************/
649 
650 pragma solidity ^0.4.24;
651 
652 
653 /// @title King of Eth: Houses Referencer
654 /// @author Anthony Burzillo <burz@burznest.com>
655 /// @dev Provides functionality to reference the houses contract
656 contract KingOfEthHousesReferencer is GodMode {
657     /// @dev The houses contract's address
658     address public housesContract;
659 
660     /// @dev Only the houses contract can run this function
661     modifier onlyHousesContract()
662     {
663         require(housesContract == msg.sender);
664         _;
665     }
666 
667     /// @dev God can set the realty contract
668     /// @param _housesContract The new address
669     function godSetHousesContract(address _housesContract)
670         public
671         onlyGod
672     {
673         housesContract = _housesContract;
674     }
675 }
676 
677 // File: contracts/KingOfEthOpenAuctions.sol
678 
679 /****************************************************
680  *
681  * Copyright 2018 BurzNest LLC. All rights reserved.
682  *
683  * The contents of this file are provided for review
684  * and educational purposes ONLY. You MAY NOT use,
685  * copy, distribute, or modify this software without
686  * explicit written permission from BurzNest LLC.
687  *
688  ****************************************************/
689 
690 pragma solidity ^0.4.24;
691 
692 
693 
694 
695 
696 
697 
698 
699 
700 
701 /// @title King of Eth: Open Auctions
702 /// @author Anthony Burzillo <burz@burznest.com>
703 /// @dev Contract for open auctions of houses
704 contract KingOfEthOpenAuctions is
705       GodMode
706     , KingOfEthAuctionsAbstractInterface
707     , KingOfEthReferencer
708     , KingOfEthBlindAuctionsReferencer
709     , KingOfEthBoardReferencer
710     , KingOfEthHousesReferencer
711 {
712     /// @dev Data for an auction
713     struct Auction {
714         /// @dev The time the auction started
715         uint startTime;
716 
717         /// @dev The (current) winning bid
718         uint winningBid;
719 
720         /// @dev The address of the (current) winner
721         address winner;
722     }
723 
724     /// @dev Mapping from location (x, y) to the auction at that location
725     mapping (uint => mapping (uint => Auction)) auctions;
726 
727     /// @dev The span of time that players may bid on an auction
728     uint public constant bidSpan = 20 minutes;
729 
730     /// @param _kingOfEthContract The address for the king contract
731     /// @param _blindAuctionsContract The address for the blind auctions contract
732     /// @param _boardContract The address for the board contract
733     constructor(
734           address _kingOfEthContract
735         , address _blindAuctionsContract
736         , address _boardContract
737     )
738         public
739     {
740         kingOfEthContract     = _kingOfEthContract;
741         blindAuctionsContract = _blindAuctionsContract;
742         boardContract         = _boardContract;
743 
744         // Auctions are not allowed before God has begun the game
745         isPaused = true;
746     }
747 
748     /// @dev Fired when a new auction is started
749     event OpenAuctionStarted(
750           uint x
751         , uint y
752         , address starter
753         , uint startTime
754     );
755 
756     /// @dev Fired when a new bid is placed
757     event OpenBidPlaced(uint x, uint y, address bidder, uint amount);
758 
759     /// @dev Fired when an auction is closed
760     event OpenAuctionClosed(uint x, uint y, address newOwner, uint amount);
761 
762     /// @dev Determines if there is an auction at a particular location
763     /// @param _x The x coordinate of the auction
764     /// @param _y The y coordinate of the auction
765     /// @return true if there is an existing auction
766     function existingAuction(uint _x, uint _y) public view returns(bool)
767     {
768         return 0 != auctions[_x][_y].startTime;
769     }
770 
771     /// @dev Create an auction at a particular location
772     /// @param _x The x coordinate of the auction
773     /// @param _y The y coordinate of the auction
774     function createAuction(uint _x, uint _y) public notPaused
775     {
776         // Require that there is not an auction already started at
777         // the location
778         require(0 == auctions[_x][_y].startTime);
779 
780         // Require that there is no blind auction at that location
781         require(!KingOfEthAuctionsAbstractInterface(blindAuctionsContract).existingAuction(_x, _y));
782 
783         KingOfEthBoard _board = KingOfEthBoard(boardContract);
784 
785         // Require that there is at least one available auction remaining
786         require(0 < _board.auctionsRemaining());
787 
788         // Require that the auction is within the current bounds of the board
789         require(_board.boundX1() < _x);
790         require(_board.boundY1() < _y);
791         require(_board.boundX2() > _x);
792         require(_board.boundY2() > _y);
793 
794         // Require that nobody currently owns the house
795         require(0x0 == KingOfEthHousesAbstractInterface(housesContract).ownerOf(_x, _y));
796 
797         // Use up an available auction
798         _board.auctionsDecrementAuctionsRemaining();
799 
800         auctions[_x][_y].startTime = now;
801 
802         emit OpenAuctionStarted(_x, _y, msg.sender, now);
803     }
804 
805     /// @dev Make a bid on an auction. The amount bid is the amount sent
806     ///  with the transaction.
807     /// @param _x The x coordinate of the auction
808     /// @param _y The y coordinate of the auction
809     function placeBid(uint _x, uint _y) public payable notPaused
810     {
811         // Lookup the auction
812         Auction storage _auction = auctions[_x][_y];
813 
814         // Require that the auction actually exists
815         require(0 != _auction.startTime);
816 
817         // Require that it is still during the bid span
818         require(_auction.startTime + bidSpan > now);
819 
820         // If the new bid is larger than the current winning bid
821         if(_auction.winningBid < msg.value)
822         {
823             // Temporarily save the old winning values
824             uint    _oldWinningBid = _auction.winningBid;
825             address _oldWinner     = _auction.winner;
826 
827             // Store the new winner
828             _auction.winningBid = msg.value;
829             _auction.winner     = msg.sender;
830 
831             // Send the loser back their ETH
832             if(0 < _oldWinningBid) {
833                 _oldWinner.transfer(_oldWinningBid);
834             }
835         }
836         else
837         {
838             // Return the sender their ETH
839             msg.sender.transfer(msg.value);
840         }
841 
842         emit OpenBidPlaced(_x, _y, msg.sender, msg.value);
843     }
844 
845     /// @dev Close an auction and distribute the bid amount as taxes
846     /// @param _x The x coordinate of the auction
847     /// @param _y The y coordinate of the auction
848     function closeAuction(uint _x, uint _y) public notPaused
849     {
850         // Lookup the auction
851         Auction storage _auction = auctions[_x][_y];
852 
853         // Require that the auction actually exists
854         require(0 != _auction.startTime);
855 
856         // If nobody won the auction
857         if(0x0 == _auction.winner)
858         {
859             // Mark that there is no current auction for this location
860             _auction.startTime = 0;
861 
862             // Allow another auction to be created
863             KingOfEthBoard(boardContract).auctionsIncrementAuctionsRemaining();
864         }
865         // If a player won the auction
866         else
867         {
868             // Set the auction's winner as the owner of the house.
869             // Note that this will fail if there is already an owner so we
870             // don't need to mark the auction as closed with some extra
871             // variable.
872             KingOfEthHousesAbstractInterface(housesContract).auctionsSetOwner(
873                   _x
874                 , _y
875                 , _auction.winner
876             );
877 
878             // Pay the taxes
879             KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(_auction.winningBid)();
880         }
881 
882         emit OpenAuctionClosed(_x, _y, _auction.winner, _auction.winningBid);
883     }
884 }