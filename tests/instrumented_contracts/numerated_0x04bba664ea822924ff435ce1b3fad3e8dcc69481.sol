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
79 // File: contracts/KingOfEthAuctionsAbstractInterface.sol
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
94 /// @title King of Eth: Auctions Abstract Interface
95 /// @author Anthony Burzillo <burz@burznest.com>
96 /// @dev Abstract interface contract for auctions of houses
97 contract KingOfEthAuctionsAbstractInterface {
98     /// @dev Determines if there is an auction at a particular location
99     /// @param _x The x coordinate of the auction
100     /// @param _y The y coordinate of the auction
101     /// @return true if there is an existing auction
102     function existingAuction(uint _x, uint _y) public view returns(bool);
103 }
104 
105 // File: contracts/KingOfEthBlindAuctionsReferencer.sol
106 
107 /****************************************************
108  *
109  * Copyright 2018 BurzNest LLC. All rights reserved.
110  *
111  * The contents of this file are provided for review
112  * and educational purposes ONLY. You MAY NOT use,
113  * copy, distribute, or modify this software without
114  * explicit written permission from BurzNest LLC.
115  *
116  ****************************************************/
117 
118 pragma solidity ^0.4.24;
119 
120 
121 /// @title King of Eth: Blind Auctions Referencer
122 /// @author Anthony Burzillo <burz@burznest.com>
123 /// @dev This contract provides a reference to the blind auctions contract
124 contract KingOfEthBlindAuctionsReferencer is GodMode {
125     /// @dev The address of the blind auctions contract
126     address public blindAuctionsContract;
127 
128     /// @dev Only the blind auctions contract can run this
129     modifier onlyBlindAuctionsContract()
130     {
131         require(blindAuctionsContract == msg.sender);
132         _;
133     }
134 
135     /// @dev God can set a new blind auctions contract
136     /// @param _blindAuctionsContract the address of the blind auctions
137     ///  contract
138     function godSetBlindAuctionsContract(address _blindAuctionsContract)
139         public
140         onlyGod
141     {
142         blindAuctionsContract = _blindAuctionsContract;
143     }
144 }
145 
146 // File: contracts/KingOfEthOpenAuctionsReferencer.sol
147 
148 /****************************************************
149  *
150  * Copyright 2018 BurzNest LLC. All rights reserved.
151  *
152  * The contents of this file are provided for review
153  * and educational purposes ONLY. You MAY NOT use,
154  * copy, distribute, or modify this software without
155  * explicit written permission from BurzNest LLC.
156  *
157  ****************************************************/
158 
159 pragma solidity ^0.4.24;
160 
161 
162 /// @title King of Eth: Open Auctions Referencer
163 /// @author Anthony Burzillo <burz@burznest.com>
164 /// @dev This contract provides a reference to the open auctions contract
165 contract KingOfEthOpenAuctionsReferencer is GodMode {
166     /// @dev The address of the auctions contract
167     address public openAuctionsContract;
168 
169     /// @dev Only the open auctions contract can run this
170     modifier onlyOpenAuctionsContract()
171     {
172         require(openAuctionsContract == msg.sender);
173         _;
174     }
175 
176     /// @dev God can set a new auctions contract
177     function godSetOpenAuctionsContract(address _openAuctionsContract)
178         public
179         onlyGod
180     {
181         openAuctionsContract = _openAuctionsContract;
182     }
183 }
184 
185 // File: contracts/KingOfEthAuctionsReferencer.sol
186 
187 /****************************************************
188  *
189  * Copyright 2018 BurzNest LLC. All rights reserved.
190  *
191  * The contents of this file are provided for review
192  * and educational purposes ONLY. You MAY NOT use,
193  * copy, distribute, or modify this software without
194  * explicit written permission from BurzNest LLC.
195  *
196  ****************************************************/
197 
198 pragma solidity ^0.4.24;
199 
200 
201 
202 /// @title King of Eth: Auctions Referencer
203 /// @author Anthony Burzillo <burz@burznest.com>
204 /// @dev This contract provides a reference to the auctions contracts
205 contract KingOfEthAuctionsReferencer is
206       KingOfEthBlindAuctionsReferencer
207     , KingOfEthOpenAuctionsReferencer
208 {
209     /// @dev Only an auctions contract can run this
210     modifier onlyAuctionsContract()
211     {
212         require(blindAuctionsContract == msg.sender
213              || openAuctionsContract == msg.sender);
214         _;
215     }
216 }
217 
218 // File: contracts/KingOfEthAbstractInterface.sol
219 
220 /****************************************************
221  *
222  * Copyright 2018 BurzNest LLC. All rights reserved.
223  *
224  * The contents of this file are provided for review
225  * and educational purposes ONLY. You MAY NOT use,
226  * copy, distribute, or modify this software without
227  * explicit written permission from BurzNest LLC.
228  *
229  ****************************************************/
230 
231 pragma solidity ^0.4.24;
232 
233 /// @title King of Eth Abstract Interface
234 /// @author Anthony Burzillo <burz@burznest.com>
235 /// @dev Abstract interface contract for titles and taxes
236 contract KingOfEthAbstractInterface {
237     /// @dev The address of the current King
238     address public king;
239 
240     /// @dev The address of the current Wayfarer
241     address public wayfarer;
242 
243     /// @dev Anyone can pay taxes
244     function payTaxes() public payable;
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
677 // File: contracts/KingOfEthHouseRealty.sol
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
697 /// @title King of Eth: House Realty
698 /// @author Anthony Burzillo <burz@burznest.com>
699 /// @dev Contract for controlling sales of houses
700 contract KingOfEthHouseRealty is
701       GodMode
702     , KingOfEthHousesReferencer
703     , KingOfEthReferencer
704 {
705     /// @dev The number that divides the amount payed for any sale to produce
706     ///  the amount payed in taxes
707     uint public constant taxDivisor = 25;
708 
709     /// @dev Mapping from the x, y coordinates of a house to the current sale
710     ///  price (0 if there is no sale)
711     mapping (uint => mapping (uint => uint)) housePrices;
712 
713     /// @dev Fired when there is a new house for sale
714     event HouseForSale(
715           uint x
716         , uint y
717         , address owner
718         , uint amount
719     );
720 
721     /// @dev Fired when the owner changes the price of a house
722     event HousePriceChanged(uint x, uint y, uint amount);
723 
724     /// @dev Fired when a house is sold
725     event HouseSold(
726           uint x
727         , uint y
728         , address from
729         , address to
730         , uint amount
731         , uint8 level
732     );
733 
734     /// @dev Fired when the sale for a house is cancelled by the owner
735     event HouseSaleCancelled(
736           uint x
737         , uint y
738         , address owner
739     );
740 
741     /// @dev Only the owner of the house at a location can run this
742     /// @param _x The x coordinate of the house
743     /// @param _y The y coordinate of the house
744     modifier onlyHouseOwner(uint _x, uint _y)
745     {
746         require(KingOfEthHousesAbstractInterface(housesContract).ownerOf(_x, _y) == msg.sender);
747         _;
748     }
749 
750     /// @dev This can only be run if there is *not* an existing sale for a house
751     ///  at a location
752     /// @param _x The x coordinate of the house
753     /// @param _y The y coordinate of the house
754     modifier noExistingHouseSale(uint _x, uint _y)
755     {
756         require(0 == housePrices[_x][_y]);
757         _;
758     }
759 
760     /// @dev This can only be run if there is an existing sale for a house
761     ///  at a location
762     /// @param _x The x coordinate of the house
763     /// @param _y The y coordinate of the house
764     modifier existingHouseSale(uint _x, uint _y)
765     {
766         require(0 != housePrices[_x][_y]);
767         _;
768     }
769 
770     /// @param _kingOfEthContract The address of the king contract
771     constructor(address _kingOfEthContract) public
772     {
773         kingOfEthContract = _kingOfEthContract;
774     }
775 
776     /// @dev The houses contract can cancel a sale when a house is transfered
777     ///  to another player
778     /// @param _x The x coordinate of the house
779     /// @param _y The y coordinate of the house
780     function housesCancelHouseSale(uint _x, uint _y)
781         public
782         onlyHousesContract
783     {
784         // If there is indeed a sale
785         if(0 != housePrices[_x][_y])
786         {
787             // Cancel the sale
788             housePrices[_x][_y] = 0;
789 
790             emit HouseSaleCancelled(_x, _y, msg.sender);
791         }
792     }
793 
794     /// @dev The owner of a house can start a sale
795     /// @param _x The x coordinate of the house
796     /// @param _y The y coordinate of the house
797     /// @param _askingPrice The price that must be payed by another player
798     ///  to purchase the house
799     function startHouseSale(uint _x, uint _y, uint _askingPrice)
800         public
801         notPaused
802         onlyHouseOwner(_x, _y)
803         noExistingHouseSale(_x, _y)
804     {
805         // Require that the price is at least 0
806         require(0 != _askingPrice);
807 
808         // Record the price
809         housePrices[_x][_y] = _askingPrice;
810 
811         emit HouseForSale(_x, _y, msg.sender, _askingPrice);
812     }
813 
814     /// @dev The owner of a house can change the price of a sale
815     /// @param _x The x coordinate of the house
816     /// @param _y The y coordinate of the house
817     /// @param _askingPrice The new price that must be payed by another
818     ///  player to purchase the house
819     function changeHousePrice(uint _x, uint _y, uint _askingPrice)
820         public
821         notPaused
822         onlyHouseOwner(_x, _y)
823         existingHouseSale(_x, _y)
824     {
825         // Require that the price is at least 0
826         require(0 != _askingPrice);
827 
828         // Record the price
829         housePrices[_x][_y] = _askingPrice;
830 
831         emit HousePriceChanged(_x, _y, _askingPrice);
832     }
833 
834     /// @dev Anyone can purchase a house as long as the sale exists
835     /// @param _x The y coordinate of the house
836     /// @param _y The y coordinate of the house
837     function purchaseHouse(uint _x, uint _y)
838         public
839         payable
840         notPaused
841         existingHouseSale(_x, _y)
842     {
843         // Require that the exact price was paid
844         require(housePrices[_x][_y] == msg.value);
845 
846         // End the sale
847         housePrices[_x][_y] = 0;
848 
849         // Calculate the taxes to be paid
850         uint taxCut = msg.value / taxDivisor;
851 
852         // Pay the taxes
853         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(taxCut)();
854 
855         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
856 
857         // Determine the previous owner
858         address _oldOwner = _housesContract.ownerOf(_x, _y);
859 
860         // Send the buyer the house
861         _housesContract.houseRealtyTransferOwnership(
862               _x
863             , _y
864             , _oldOwner
865             , msg.sender
866         );
867 
868         // Send the previous owner his share
869         _oldOwner.transfer(msg.value - taxCut);
870 
871         emit HouseSold(
872               _x
873             , _y
874             , _oldOwner
875             , msg.sender
876             , msg.value
877             , _housesContract.level(_x, _y)
878         );
879     }
880 
881     /// @dev The owner of a house can cancel a sale
882     /// @param _x The y coordinate of the house
883     /// @param _y The y coordinate of the house
884     function cancelHouseSale(uint _x, uint _y)
885         public
886         notPaused
887         onlyHouseOwner(_x, _y)
888         existingHouseSale(_x, _y)
889     {
890         // Cancel the sale
891         housePrices[_x][_y] = 0;
892 
893         emit HouseSaleCancelled(_x, _y, msg.sender);
894     }
895 }
896 
897 // File: contracts/KingOfEthHouseRealtyReferencer.sol
898 
899 /****************************************************
900  *
901  * Copyright 2018 BurzNest LLC. All rights reserved.
902  *
903  * The contents of this file are provided for review
904  * and educational purposes ONLY. You MAY NOT use,
905  * copy, distribute, or modify this software without
906  * explicit written permission from BurzNest LLC.
907  *
908  ****************************************************/
909 
910 pragma solidity ^0.4.24;
911 
912 
913 /// @title King of Eth: House Realty Referencer
914 /// @author Anthony Burzillo <burz@burznest.com>
915 /// @dev Provides functionality to reference the house realty contract
916 contract KingOfEthHouseRealtyReferencer is GodMode {
917     /// @dev The realty contract's address
918     address public houseRealtyContract;
919 
920     /// @dev Only the house realty contract can run this function
921     modifier onlyHouseRealtyContract()
922     {
923         require(houseRealtyContract == msg.sender);
924         _;
925     }
926 
927     /// @dev God can set the house realty contract
928     /// @param _houseRealtyContract The new address
929     function godSetHouseRealtyContract(address _houseRealtyContract)
930         public
931         onlyGod
932     {
933         houseRealtyContract = _houseRealtyContract;
934     }
935 }
936 
937 // File: contracts/KingOfEthRoadsAbstractInterface.sol
938 
939 /****************************************************
940  *
941  * Copyright 2018 BurzNest LLC. All rights reserved.
942  *
943  * The contents of this file are provided for review
944  * and educational purposes ONLY. You MAY NOT use,
945  * copy, distribute, or modify this software without
946  * explicit written permission from BurzNest LLC.
947  *
948  ****************************************************/
949 
950 pragma solidity ^0.4.24;
951 
952 /// @title King of Eth: Roads Abstract Interface
953 /// @author Anthony Burzillo <burz@burznest.com>
954 /// @dev Abstract interface contract for roads
955 contract KingOfEthRoadsAbstractInterface {
956     /// @dev Get the owner of the road at some location
957     /// @param _x The x coordinate of the road
958     /// @param _y The y coordinate of the road
959     /// @param _direction The direction of the road (either
960     ///  0 for right or 1 for down)
961     /// @return The address of the owner
962     function ownerOf(uint _x, uint _y, uint8 _direction) public view returns(address);
963 
964     /// @dev The road realty contract can transfer road ownership
965     /// @param _x The x coordinate of the road
966     /// @param _y The y coordinate of the road
967     /// @param _direction The direction of the road
968     /// @param _from The previous owner of road
969     /// @param _to The new owner of road
970     function roadRealtyTransferOwnership(
971           uint _x
972         , uint _y
973         , uint8 _direction
974         , address _from
975         , address _to
976     ) public;
977 }
978 
979 // File: contracts/KingOfEthRoadsReferencer.sol
980 
981 /****************************************************
982  *
983  * Copyright 2018 BurzNest LLC. All rights reserved.
984  *
985  * The contents of this file are provided for review
986  * and educational purposes ONLY. You MAY NOT use,
987  * copy, distribute, or modify this software without
988  * explicit written permission from BurzNest LLC.
989  *
990  ****************************************************/
991 
992 pragma solidity ^0.4.24;
993 
994 
995 /// @title King of Eth: Roads Referencer
996 /// @author Anthony Burzillo <burz@burznest.com>
997 /// @dev Provides functionality to reference the roads contract
998 contract KingOfEthRoadsReferencer is GodMode {
999     /// @dev The roads contract's address
1000     address public roadsContract;
1001 
1002     /// @dev Only the roads contract can run this function
1003     modifier onlyRoadsContract()
1004     {
1005         require(roadsContract == msg.sender);
1006         _;
1007     }
1008 
1009     /// @dev God can set the realty contract
1010     /// @param _roadsContract The new address
1011     function godSetRoadsContract(address _roadsContract)
1012         public
1013         onlyGod
1014     {
1015         roadsContract = _roadsContract;
1016     }
1017 }
1018 
1019 // File: contracts/KingOfEthEthExchangeReferencer.sol
1020 
1021 /****************************************************
1022  *
1023  * Copyright 2018 BurzNest LLC. All rights reserved.
1024  *
1025  * The contents of this file are provided for review
1026  * and educational purposes ONLY. You MAY NOT use,
1027  * copy, distribute, or modify this software without
1028  * explicit written permission from BurzNest LLC.
1029  *
1030  ****************************************************/
1031 
1032 pragma solidity ^0.4.24;
1033 
1034 
1035 /// @title King of Eth: Resource-to-ETH Exchange Referencer
1036 /// @author Anthony Burzillo <burz@burznest.com>
1037 /// @dev Provides functionality to interface with the
1038 ///  ETH exchange contract
1039 contract KingOfEthEthExchangeReferencer is GodMode {
1040     /// @dev Address of the ETH exchange contract
1041     address public ethExchangeContract;
1042 
1043     /// @dev Only the ETH exchange contract may run this function
1044     modifier onlyEthExchangeContract()
1045     {
1046         require(ethExchangeContract == msg.sender);
1047         _;
1048     }
1049 
1050     /// @dev God may set the ETH exchange contract's address
1051     /// @dev _ethExchangeContract The new address
1052     function godSetEthExchangeContract(address _ethExchangeContract)
1053         public
1054         onlyGod
1055     {
1056         ethExchangeContract = _ethExchangeContract;
1057     }
1058 }
1059 
1060 // File: contracts/KingOfEthResourceExchangeReferencer.sol
1061 
1062 /****************************************************
1063  *
1064  * Copyright 2018 BurzNest LLC. All rights reserved.
1065  *
1066  * The contents of this file are provided for review
1067  * and educational purposes ONLY. You MAY NOT use,
1068  * copy, distribute, or modify this software without
1069  * explicit written permission from BurzNest LLC.
1070  *
1071  ****************************************************/
1072 
1073 pragma solidity ^0.4.24;
1074 
1075 
1076 /// @title King of Eth: Resource-to-Resource Exchange Referencer
1077 /// @author Anthony Burzillo <burz@burznest.com>
1078 /// @dev Provides functionality to interface with the
1079 ///  resource-to-resource contract
1080 contract KingOfEthResourceExchangeReferencer is GodMode {
1081     /// @dev Address of the resource-to-resource contract
1082     address public resourceExchangeContract;
1083 
1084     /// @dev Only the resource-to-resource contract may run this function
1085     modifier onlyResourceExchangeContract()
1086     {
1087         require(resourceExchangeContract == msg.sender);
1088         _;
1089     }
1090 
1091     /// @dev God may set the resource-to-resource contract's address
1092     /// @dev _resourceExchangeContract The new address
1093     function godSetResourceExchangeContract(address _resourceExchangeContract)
1094         public
1095         onlyGod
1096     {
1097         resourceExchangeContract = _resourceExchangeContract;
1098     }
1099 }
1100 
1101 // File: contracts/KingOfEthExchangeReferencer.sol
1102 
1103 /****************************************************
1104  *
1105  * Copyright 2018 BurzNest LLC. All rights reserved.
1106  *
1107  * The contents of this file are provided for review
1108  * and educational purposes ONLY. You MAY NOT use,
1109  * copy, distribute, or modify this software without
1110  * explicit written permission from BurzNest LLC.
1111  *
1112  ****************************************************/
1113 
1114 pragma solidity ^0.4.24;
1115 
1116 
1117 
1118 
1119 /// @title King of Eth: Exchange Referencer
1120 /// @author Anthony Burzillo <burz@burznest.com>
1121 /// @dev Provides functionality to interface with the exchange contract
1122 contract KingOfEthExchangeReferencer is
1123       GodMode
1124     , KingOfEthEthExchangeReferencer
1125     , KingOfEthResourceExchangeReferencer
1126 {
1127     /// @dev Only one of the exchange contracts may
1128     ///  run this function
1129     modifier onlyExchangeContract()
1130     {
1131         require(
1132                ethExchangeContract == msg.sender
1133             || resourceExchangeContract == msg.sender
1134         );
1135         _;
1136     }
1137 }
1138 
1139 // File: contracts/KingOfEthResourcesInterfaceReferencer.sol
1140 
1141 /****************************************************
1142  *
1143  * Copyright 2018 BurzNest LLC. All rights reserved.
1144  *
1145  * The contents of this file are provided for review
1146  * and educational purposes ONLY. You MAY NOT use,
1147  * copy, distribute, or modify this software without
1148  * explicit written permission from BurzNest LLC.
1149  *
1150  ****************************************************/
1151 
1152 pragma solidity ^0.4.24;
1153 
1154 
1155 /// @title King of Eth: Resources Interface Referencer
1156 /// @author Anthony Burzillo <burz@burznest.com>
1157 /// @dev Provides functionality to reference the resource interface contract
1158 contract KingOfEthResourcesInterfaceReferencer is GodMode {
1159     /// @dev The interface contract's address
1160     address public interfaceContract;
1161 
1162     /// @dev Only the interface contract can run this function
1163     modifier onlyInterfaceContract()
1164     {
1165         require(interfaceContract == msg.sender);
1166         _;
1167     }
1168 
1169     /// @dev God can set the realty contract
1170     /// @param _interfaceContract The new address
1171     function godSetInterfaceContract(address _interfaceContract)
1172         public
1173         onlyGod
1174     {
1175         interfaceContract = _interfaceContract;
1176     }
1177 }
1178 
1179 // File: contracts/KingOfEthResource.sol
1180 
1181 /****************************************************
1182  *
1183  * Copyright 2018 BurzNest LLC. All rights reserved.
1184  *
1185  * The contents of this file are provided for review
1186  * and educational purposes ONLY. You MAY NOT use,
1187  * copy, distribute, or modify this software without
1188  * explicit written permission from BurzNest LLC.
1189  *
1190  ****************************************************/
1191 
1192 pragma solidity ^0.4.24;
1193 
1194 
1195 
1196 /// @title ERC20Interface
1197 /// @dev ERC20 token interface contract
1198 contract ERC20Interface {
1199     function totalSupply() public constant returns(uint);
1200     function balanceOf(address _tokenOwner) public constant returns(uint balance);
1201     function allowance(address _tokenOwner, address _spender) public constant returns(uint remaining);
1202     function transfer(address _to, uint _tokens) public returns(bool success);
1203     function approve(address _spender, uint _tokens) public returns(bool success);
1204     function transferFrom(address _from, address _to, uint _tokens) public returns(bool success);
1205 
1206     event Transfer(address indexed from, address indexed to, uint tokens);
1207     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
1208 }
1209 
1210 /// @title King of Eth: Resource
1211 /// @author Anthony Burzillo <burz@burznest.com>
1212 /// @dev Common contract implementation for resources
1213 contract KingOfEthResource is
1214       ERC20Interface
1215     , GodMode
1216     , KingOfEthResourcesInterfaceReferencer
1217 {
1218     /// @dev Current resource supply
1219     uint public resourceSupply;
1220 
1221     /// @dev ERC20 token's decimals
1222     uint8 public constant decimals = 0;
1223 
1224     /// @dev mapping of addresses to holdings
1225     mapping (address => uint) holdings;
1226 
1227     /// @dev mapping of addresses to amount of tokens frozen
1228     mapping (address => uint) frozenHoldings;
1229 
1230     /// @dev mapping of addresses to mapping of allowances for an address
1231     mapping (address => mapping (address => uint)) allowances;
1232 
1233     /// @dev ERC20 total supply
1234     /// @return The current total supply of the resource
1235     function totalSupply()
1236         public
1237         constant
1238         returns(uint)
1239     {
1240         return resourceSupply;
1241     }
1242 
1243     /// @dev ERC20 balance of address
1244     /// @param _tokenOwner The address to look up
1245     /// @return The balance of the address
1246     function balanceOf(address _tokenOwner)
1247         public
1248         constant
1249         returns(uint balance)
1250     {
1251         return holdings[_tokenOwner];
1252     }
1253 
1254     /// @dev Total resources frozen for an address
1255     /// @param _tokenOwner The address to look up
1256     /// @return The frozen balance of the address
1257     function frozenTokens(address _tokenOwner)
1258         public
1259         constant
1260         returns(uint balance)
1261     {
1262         return frozenHoldings[_tokenOwner];
1263     }
1264 
1265     /// @dev The allowance for a spender on an account
1266     /// @param _tokenOwner The account that allows withdrawels
1267     /// @param _spender The account that is allowed to withdraw
1268     /// @return The amount remaining in the allowance
1269     function allowance(address _tokenOwner, address _spender)
1270         public
1271         constant
1272         returns(uint remaining)
1273     {
1274         return allowances[_tokenOwner][_spender];
1275     }
1276 
1277     /// @dev Only run if player has at least some amount of tokens
1278     /// @param _owner The owner of the tokens
1279     /// @param _tokens The amount of tokens required
1280     modifier hasAvailableTokens(address _owner, uint _tokens)
1281     {
1282         require(holdings[_owner] - frozenHoldings[_owner] >= _tokens);
1283         _;
1284     }
1285 
1286     /// @dev Only run if player has at least some amount of tokens frozen
1287     /// @param _owner The owner of the tokens
1288     /// @param _tokens The amount of frozen tokens required
1289     modifier hasFrozenTokens(address _owner, uint _tokens)
1290     {
1291         require(frozenHoldings[_owner] >= _tokens);
1292         _;
1293     }
1294 
1295     /// @dev Set up the exact same state in each resource
1296     constructor() public
1297     {
1298         // God gets 200 to put on exchange
1299         holdings[msg.sender] = 200;
1300 
1301         resourceSupply = 200;
1302     }
1303 
1304     /// @dev The resources interface can burn tokens for building
1305     ///  roads or houses
1306     /// @param _owner The owner of the tokens
1307     /// @param _tokens The amount of tokens to burn
1308     function interfaceBurnTokens(address _owner, uint _tokens)
1309         public
1310         onlyInterfaceContract
1311         hasAvailableTokens(_owner, _tokens)
1312     {
1313         holdings[_owner] -= _tokens;
1314 
1315         resourceSupply -= _tokens;
1316 
1317         // Pretend the tokens were sent to 0x0
1318         emit Transfer(_owner, 0x0, _tokens);
1319     }
1320 
1321     /// @dev The resources interface contract can mint tokens for houses
1322     /// @param _owner The owner of the tokens
1323     /// @param _tokens The amount of tokens to burn
1324     function interfaceMintTokens(address _owner, uint _tokens)
1325         public
1326         onlyInterfaceContract
1327     {
1328         holdings[_owner] += _tokens;
1329 
1330         resourceSupply += _tokens;
1331 
1332         // Pretend the tokens were sent from the interface contract
1333         emit Transfer(interfaceContract, _owner, _tokens);
1334     }
1335 
1336     /// @dev The interface can freeze tokens
1337     /// @param _owner The owner of the tokens
1338     /// @param _tokens The amount of tokens to freeze
1339     function interfaceFreezeTokens(address _owner, uint _tokens)
1340         public
1341         onlyInterfaceContract
1342         hasAvailableTokens(_owner, _tokens)
1343     {
1344         frozenHoldings[_owner] += _tokens;
1345     }
1346 
1347     /// @dev The interface can thaw tokens
1348     /// @param _owner The owner of the tokens
1349     /// @param _tokens The amount of tokens to thaw
1350     function interfaceThawTokens(address _owner, uint _tokens)
1351         public
1352         onlyInterfaceContract
1353         hasFrozenTokens(_owner, _tokens)
1354     {
1355         frozenHoldings[_owner] -= _tokens;
1356     }
1357 
1358     /// @dev The interface can transfer tokens
1359     /// @param _from The owner of the tokens
1360     /// @param _to The new owner of the tokens
1361     /// @param _tokens The amount of tokens to transfer
1362     function interfaceTransfer(address _from, address _to, uint _tokens)
1363         public
1364         onlyInterfaceContract
1365     {
1366         assert(holdings[_from] >= _tokens);
1367 
1368         holdings[_from] -= _tokens;
1369         holdings[_to]   += _tokens;
1370 
1371         emit Transfer(_from, _to, _tokens);
1372     }
1373 
1374     /// @dev The interface can transfer frozend tokens
1375     /// @param _from The owner of the tokens
1376     /// @param _to The new owner of the tokens
1377     /// @param _tokens The amount of frozen tokens to transfer
1378     function interfaceFrozenTransfer(address _from, address _to, uint _tokens)
1379         public
1380         onlyInterfaceContract
1381         hasFrozenTokens(_from, _tokens)
1382     {
1383         // Make sure to deduct the tokens from both the total and frozen amounts
1384         holdings[_from]       -= _tokens;
1385         frozenHoldings[_from] -= _tokens;
1386         holdings[_to]         += _tokens;
1387 
1388         emit Transfer(_from, _to, _tokens);
1389     }
1390 
1391     /// @dev ERC20 transfer
1392     /// @param _to The address to transfer to
1393     /// @param _tokens The amount of tokens to transfer
1394     function transfer(address _to, uint _tokens)
1395         public
1396         hasAvailableTokens(msg.sender, _tokens)
1397         returns(bool success)
1398     {
1399         holdings[_to]        += _tokens;
1400         holdings[msg.sender] -= _tokens;
1401 
1402         emit Transfer(msg.sender, _to, _tokens);
1403 
1404         return true;
1405     }
1406 
1407     /// @dev ERC20 approve
1408     /// @param _spender The address to approve
1409     /// @param _tokens The amount of tokens to approve
1410     function approve(address _spender, uint _tokens)
1411         public
1412         returns(bool success)
1413     {
1414         allowances[msg.sender][_spender] = _tokens;
1415 
1416         emit Approval(msg.sender, _spender, _tokens);
1417 
1418         return true;
1419     }
1420 
1421     /// @dev ERC20 transfer from
1422     /// @param _from The address providing the allowance
1423     /// @param _to The address using the allowance
1424     /// @param _tokens The amount of tokens to transfer
1425     function transferFrom(address _from, address _to, uint _tokens)
1426         public
1427         hasAvailableTokens(_from, _tokens)
1428         returns(bool success)
1429     {
1430         require(allowances[_from][_to] >= _tokens);
1431 
1432         holdings[_to]          += _tokens;
1433         holdings[_from]        -= _tokens;
1434         allowances[_from][_to] -= _tokens;
1435 
1436         emit Transfer(_from, _to, _tokens);
1437 
1438         return true;
1439     }
1440 }
1441 
1442 // File: contracts/KingOfEthResourceType.sol
1443 
1444 /****************************************************
1445  *
1446  * Copyright 2018 BurzNest LLC. All rights reserved.
1447  *
1448  * The contents of this file are provided for review
1449  * and educational purposes ONLY. You MAY NOT use,
1450  * copy, distribute, or modify this software without
1451  * explicit written permission from BurzNest LLC.
1452  *
1453  ****************************************************/
1454 
1455 pragma solidity ^0.4.24;
1456 
1457 /// @title King of Eth: Resource Type
1458 /// @author Anthony Burzillo <burz@burznest.com>
1459 /// @dev Provides enum to choose resource types
1460 contract KingOfEthResourceType {
1461     /// @dev Enum describing a choice of a resource
1462     enum ResourceType {
1463           ETH
1464         , BRONZE
1465         , CORN
1466         , GOLD
1467         , OIL
1468         , ORE
1469         , STEEL
1470         , URANIUM
1471         , WOOD
1472     }
1473 }
1474 
1475 // File: contracts/KingOfEthResourcesInterface.sol
1476 
1477 /****************************************************
1478  *
1479  * Copyright 2018 BurzNest LLC. All rights reserved.
1480  *
1481  * The contents of this file are provided for review
1482  * and educational purposes ONLY. You MAY NOT use,
1483  * copy, distribute, or modify this software without
1484  * explicit written permission from BurzNest LLC.
1485  *
1486  ****************************************************/
1487 
1488 pragma solidity ^0.4.24;
1489 
1490 
1491 
1492 
1493 
1494 
1495 
1496 /// @title King of Eth: Resources Interface
1497 /// @author Anthony Burzillo <burz@burznest.com>
1498 /// @dev Contract for interacting with resources
1499 contract KingOfEthResourcesInterface is
1500       GodMode
1501     , KingOfEthExchangeReferencer
1502     , KingOfEthHousesReferencer
1503     , KingOfEthResourceType
1504     , KingOfEthRoadsReferencer
1505 {
1506     /// @dev Amount of resources a user gets for building a house
1507     uint public constant resourcesPerHouse = 3;
1508 
1509     /// @dev Address for the bronze contract
1510     address public bronzeContract;
1511 
1512     /// @dev Address for the corn contract
1513     address public cornContract;
1514 
1515     /// @dev Address for the gold contract
1516     address public goldContract;
1517 
1518     /// @dev Address for the oil contract
1519     address public oilContract;
1520 
1521     /// @dev Address for the ore contract
1522     address public oreContract;
1523 
1524     /// @dev Address for the steel contract
1525     address public steelContract;
1526 
1527     /// @dev Address for the uranium contract
1528     address public uraniumContract;
1529 
1530     /// @dev Address for the wood contract
1531     address public woodContract;
1532 
1533     /// @param _bronzeContract The address of the bronze contract
1534     /// @param _cornContract The address of the corn contract
1535     /// @param _goldContract The address of the gold contract
1536     /// @param _oilContract The address of the oil contract
1537     /// @param _oreContract The address of the ore contract
1538     /// @param _steelContract The address of the steel contract
1539     /// @param _uraniumContract The address of the uranium contract
1540     /// @param _woodContract The address of the wood contract
1541     constructor(
1542           address _bronzeContract
1543         , address _cornContract
1544         , address _goldContract
1545         , address _oilContract
1546         , address _oreContract
1547         , address _steelContract
1548         , address _uraniumContract
1549         , address _woodContract
1550     )
1551         public
1552     {
1553         bronzeContract  = _bronzeContract;
1554         cornContract    = _cornContract;
1555         goldContract    = _goldContract;
1556         oilContract     = _oilContract;
1557         oreContract     = _oreContract;
1558         steelContract   = _steelContract;
1559         uraniumContract = _uraniumContract;
1560         woodContract    = _woodContract;
1561     }
1562 
1563     /// @dev Return the particular address for a certain resource type
1564     /// @param _type The resource type
1565     /// @return The address for that resource
1566     function contractFor(ResourceType _type)
1567         public
1568         view
1569         returns(address)
1570     {
1571         // ETH does not have a contract
1572         require(ResourceType.ETH != _type);
1573 
1574         if(ResourceType.BRONZE == _type)
1575         {
1576             return bronzeContract;
1577         }
1578         else if(ResourceType.CORN == _type)
1579         {
1580             return cornContract;
1581         }
1582         else if(ResourceType.GOLD == _type)
1583         {
1584             return goldContract;
1585         }
1586         else if(ResourceType.OIL == _type)
1587         {
1588             return oilContract;
1589         }
1590         else if(ResourceType.ORE == _type)
1591         {
1592             return oreContract;
1593         }
1594         else if(ResourceType.STEEL == _type)
1595         {
1596             return steelContract;
1597         }
1598         else if(ResourceType.URANIUM == _type)
1599         {
1600             return uraniumContract;
1601         }
1602         else if(ResourceType.WOOD == _type)
1603         {
1604             return woodContract;
1605         }
1606     }
1607 
1608     /// @dev Determine the resource type of a tile
1609     /// @param _x The x coordinate of the top left corner of the tile
1610     /// @param _y The y coordinate of the top left corner of the tile
1611     function resourceType(uint _x, uint _y)
1612         public
1613         pure
1614         returns(ResourceType resource)
1615     {
1616         uint _seed = (_x + 7777777) ^  _y;
1617 
1618         if(0 == _seed % 97)
1619         {
1620           return ResourceType.URANIUM;
1621         }
1622         else if(0 == _seed % 29)
1623         {
1624           return ResourceType.OIL;
1625         }
1626         else if(0 == _seed % 23)
1627         {
1628           return ResourceType.STEEL;
1629         }
1630         else if(0 == _seed % 17)
1631         {
1632           return ResourceType.GOLD;
1633         }
1634         else if(0 == _seed % 11)
1635         {
1636           return ResourceType.BRONZE;
1637         }
1638         else if(0 == _seed % 5)
1639         {
1640           return ResourceType.WOOD;
1641         }
1642         else if(0 == _seed % 2)
1643         {
1644           return ResourceType.CORN;
1645         }
1646         else
1647         {
1648           return ResourceType.ORE;
1649         }
1650     }
1651 
1652     /// @dev Lookup the number of resource points for a certain
1653     ///  player
1654     /// @param _player The player in question
1655     function lookupResourcePoints(address _player)
1656         public
1657         view
1658         returns(uint)
1659     {
1660         uint result = 0;
1661 
1662         result += KingOfEthResource(bronzeContract).balanceOf(_player);
1663         result += KingOfEthResource(goldContract).balanceOf(_player)    * 3;
1664         result += KingOfEthResource(steelContract).balanceOf(_player)   * 6;
1665         result += KingOfEthResource(oilContract).balanceOf(_player)     * 10;
1666         result += KingOfEthResource(uraniumContract).balanceOf(_player) * 44;
1667 
1668         return result;
1669     }
1670 
1671     /// @dev Burn the resources necessary to build a house
1672     /// @param _count the number of houses being built
1673     /// @param _player The player who is building the house
1674     function burnHouseCosts(uint _count, address _player)
1675         public
1676         onlyHousesContract
1677     {
1678         // Costs 2 corn per house
1679         KingOfEthResource(contractFor(ResourceType.CORN)).interfaceBurnTokens(
1680               _player
1681             , 2 * _count
1682         );
1683 
1684         // Costs 2 ore per house
1685         KingOfEthResource(contractFor(ResourceType.ORE)).interfaceBurnTokens(
1686               _player
1687             , 2 * _count
1688         );
1689 
1690         // Costs 1 wood per house
1691         KingOfEthResource(contractFor(ResourceType.WOOD)).interfaceBurnTokens(
1692               _player
1693             , _count
1694         );
1695     }
1696 
1697     /// @dev Burn the costs of upgrading a house
1698     /// @param _currentLevel The level of the house before the upgrade
1699     /// @param _player The player who is upgrading the house
1700     function burnUpgradeCosts(uint8 _currentLevel, address _player)
1701         public
1702         onlyHousesContract
1703     {
1704         // Do not allow upgrades after level 4
1705         require(5 > _currentLevel);
1706 
1707         // Burn the base house cost
1708         burnHouseCosts(1, _player);
1709 
1710         if(0 == _currentLevel)
1711         {
1712             // Level 1 costs bronze
1713             KingOfEthResource(contractFor(ResourceType.BRONZE)).interfaceBurnTokens(
1714                   _player
1715                 , 1
1716             );
1717         }
1718         else if(1 == _currentLevel)
1719         {
1720             // Level 2 costs gold
1721             KingOfEthResource(contractFor(ResourceType.GOLD)).interfaceBurnTokens(
1722                   _player
1723                 , 1
1724             );
1725         }
1726         else if(2 == _currentLevel)
1727         {
1728             // Level 3 costs steel
1729             KingOfEthResource(contractFor(ResourceType.STEEL)).interfaceBurnTokens(
1730                   _player
1731                 , 1
1732             );
1733         }
1734         else if(3 == _currentLevel)
1735         {
1736             // Level 4 costs oil
1737             KingOfEthResource(contractFor(ResourceType.OIL)).interfaceBurnTokens(
1738                   _player
1739                 , 1
1740             );
1741         }
1742         else if(4 == _currentLevel)
1743         {
1744             // Level 5 costs uranium
1745             KingOfEthResource(contractFor(ResourceType.URANIUM)).interfaceBurnTokens(
1746                   _player
1747                 , 1
1748             );
1749         }
1750     }
1751 
1752     /// @dev Mint resources for a house and distribute all to its owner
1753     /// @param _owner The owner of the house
1754     /// @param _x The x coordinate of the house
1755     /// @param _y The y coordinate of the house
1756     /// @param _y The y coordinate of the house
1757     /// @param _level The new level of the house
1758     function distributeResources(address _owner, uint _x, uint _y, uint8 _level)
1759         public
1760         onlyHousesContract
1761     {
1762         // Calculate the count of resources for this level
1763         uint _count = resourcesPerHouse * uint(_level + 1);
1764 
1765         // Distribute the top left resource
1766         KingOfEthResource(contractFor(resourceType(_x - 1, _y - 1))).interfaceMintTokens(
1767             _owner
1768           , _count
1769         );
1770 
1771         // Distribute the top right resource
1772         KingOfEthResource(contractFor(resourceType(_x, _y - 1))).interfaceMintTokens(
1773             _owner
1774           , _count
1775         );
1776 
1777         // Distribute the bottom right resource
1778         KingOfEthResource(contractFor(resourceType(_x, _y))).interfaceMintTokens(
1779             _owner
1780           , _count
1781         );
1782 
1783         // Distribute the bottom left resource
1784         KingOfEthResource(contractFor(resourceType(_x - 1, _y))).interfaceMintTokens(
1785             _owner
1786           , _count
1787         );
1788     }
1789 
1790     /// @dev Burn the costs necessary to build a road
1791     /// @param _length The length of the road
1792     /// @param _player The player who is building the house
1793     function burnRoadCosts(uint _length, address _player)
1794         public
1795         onlyRoadsContract
1796     {
1797         // Burn corn
1798         KingOfEthResource(cornContract).interfaceBurnTokens(
1799               _player
1800             , _length
1801         );
1802 
1803         // Burn ore
1804         KingOfEthResource(oreContract).interfaceBurnTokens(
1805               _player
1806             , _length
1807         );
1808     }
1809 
1810     /// @dev The exchange can freeze tokens
1811     /// @param _type The type of resource
1812     /// @param _owner The owner of the tokens
1813     /// @param _tokens The amount of tokens to freeze
1814     function exchangeFreezeTokens(ResourceType _type, address _owner, uint _tokens)
1815         public
1816         onlyExchangeContract
1817     {
1818         KingOfEthResource(contractFor(_type)).interfaceFreezeTokens(_owner, _tokens);
1819     }
1820 
1821     /// @dev The exchange can thaw tokens
1822     /// @param _type The type of resource
1823     /// @param _owner The owner of the tokens
1824     /// @param _tokens The amount of tokens to thaw
1825     function exchangeThawTokens(ResourceType _type, address _owner, uint _tokens)
1826         public
1827         onlyExchangeContract
1828     {
1829         KingOfEthResource(contractFor(_type)).interfaceThawTokens(_owner, _tokens);
1830     }
1831 
1832     /// @dev The exchange can transfer tokens
1833     /// @param _type The type of resource
1834     /// @param _from The owner of the tokens
1835     /// @param _to The new owner of the tokens
1836     /// @param _tokens The amount of tokens to transfer
1837     function exchangeTransfer(ResourceType _type, address _from, address _to, uint _tokens)
1838         public
1839         onlyExchangeContract
1840     {
1841         KingOfEthResource(contractFor(_type)).interfaceTransfer(_from, _to, _tokens);
1842     }
1843 
1844     /// @dev The exchange can transfer frozend tokens
1845     /// @param _type The type of resource
1846     /// @param _from The owner of the tokens
1847     /// @param _to The new owner of the tokens
1848     /// @param _tokens The amount of frozen tokens to transfer
1849     function exchangeFrozenTransfer(ResourceType _type, address _from, address _to, uint _tokens)
1850         public
1851         onlyExchangeContract
1852     {
1853         KingOfEthResource(contractFor(_type)).interfaceFrozenTransfer(_from, _to, _tokens);
1854     }
1855 }
1856 
1857 // File: contracts/KingOfEthHouses.sol
1858 
1859 /****************************************************
1860  *
1861  * Copyright 2018 BurzNest LLC. All rights reserved.
1862  *
1863  * The contents of this file are provided for review
1864  * and educational purposes ONLY. You MAY NOT use,
1865  * copy, distribute, or modify this software without
1866  * explicit written permission from BurzNest LLC.
1867  *
1868  ****************************************************/
1869 
1870 pragma solidity ^0.4.24;
1871 
1872 
1873 
1874 
1875 
1876 
1877 
1878 
1879 
1880 
1881 
1882 
1883 
1884 
1885 /// @title King of Eth: Houses
1886 /// @author Anthony Burzillo <burz@burznest.com>
1887 /// @dev Contract for houses
1888 contract KingOfEthHouses is
1889       GodMode
1890     , KingOfEthAuctionsReferencer
1891     , KingOfEthBoardReferencer
1892     , KingOfEthHouseRealtyReferencer
1893     , KingOfEthHousesAbstractInterface
1894     , KingOfEthReferencer
1895     , KingOfEthRoadsReferencer
1896     , KingOfEthResourcesInterfaceReferencer
1897 {
1898     /// @dev ETH cost to build or upgrade a house
1899     uint public houseCost = 0.001 ether;
1900 
1901     /// @dev Struct to hold info about a house location on the board
1902     struct LocationInfo {
1903         /// @dev The owner of the house at this location
1904         address owner;
1905 
1906         /// @dev The level of the house at this location
1907         uint8 level;
1908     }
1909 
1910     /// @dev Mapping from the (x, y) coordinate of the location to its info
1911     mapping (uint => mapping (uint => LocationInfo)) locationInfo;
1912 
1913     /// @dev Mapping from a player's address to his points
1914     mapping (address => uint) pointCounts;
1915 
1916     /// @param _blindAuctionsContract The address of the blind auctions contract
1917     /// @param _boardContract The address of the board contract
1918     /// @param _kingOfEthContract The address of the king contract
1919     /// @param _houseRealtyContract The address of the house realty contract
1920     /// @param _openAuctionsContract The address of the open auctions contract
1921     /// @param _roadsContract The address of the roads contract
1922     /// @param _interfaceContract The address of the resources
1923     ///  interface contract
1924     constructor(
1925           address _blindAuctionsContract
1926         , address _boardContract
1927         , address _kingOfEthContract
1928         , address _houseRealtyContract
1929         , address _openAuctionsContract
1930         , address _roadsContract
1931         , address _interfaceContract
1932     )
1933         public
1934     {
1935         blindAuctionsContract = _blindAuctionsContract;
1936         boardContract         = _boardContract;
1937         kingOfEthContract     = _kingOfEthContract;
1938         houseRealtyContract   = _houseRealtyContract;
1939         openAuctionsContract  = _openAuctionsContract;
1940         roadsContract         = _roadsContract;
1941         interfaceContract     = _interfaceContract;
1942     }
1943 
1944     /// @dev Fired when new houses are built
1945     event NewHouses(address owner, uint[] locations);
1946 
1947     /// @dev Fired when a house is sent from one player to another
1948     event SentHouse(uint x, uint y, address from, address to, uint8 level);
1949 
1950     /// @dev Fired when a house is upgraded
1951     event UpgradedHouse(uint x, uint y, address owner, uint8 newLevel);
1952 
1953     /// @dev Get the owner of the house at some location
1954     /// @param _x The x coordinate of the house
1955     /// @param _y The y coordinate of the house
1956     /// @return The address of the owner
1957     function ownerOf(uint _x, uint _y) public view returns(address)
1958     {
1959         return locationInfo[_x][_y].owner;
1960     }
1961 
1962     /// @dev Get the level of the house at some location
1963     /// @param _x The x coordinate of the house
1964     /// @param _y The y coordinate of the house
1965     /// @return The level of the house
1966     function level(uint _x, uint _y) public view returns(uint8)
1967     {
1968         return locationInfo[_x][_y].level;
1969     }
1970 
1971     /// @dev Get the number of points held by a player
1972     /// @param _player The player's address
1973     /// @return The number of points
1974     function numberOfPoints(address _player) public view returns(uint)
1975     {
1976         return pointCounts[_player];
1977     }
1978 
1979     /// @dev Helper function to build a house at a location
1980     /// @param _x The x coordinate of the house
1981     /// @param _y The y coordinate of the house
1982     function buildHouseInner(uint _x, uint _y) private
1983     {
1984         // Lookup the info about the house
1985         LocationInfo storage _locationInfo = locationInfo[_x][_y];
1986 
1987         KingOfEthBoard _boardContract = KingOfEthBoard(boardContract);
1988 
1989         // Require the house to be within the current bounds of the game
1990         require(_boardContract.boundX1() <= _x);
1991         require(_boardContract.boundY1() <= _y);
1992         require(_boardContract.boundX2() > _x);
1993         require(_boardContract.boundY2() > _y);
1994 
1995         // Require the spot to be empty
1996         require(0x0 == _locationInfo.owner);
1997 
1998         KingOfEthRoadsAbstractInterface _roadsContract = KingOfEthRoadsAbstractInterface(roadsContract);
1999 
2000         // Require either either the right, bottom, left or top road
2001         // to be owned by the player
2002         require(
2003                 _roadsContract.ownerOf(_x, _y, 0) == msg.sender
2004              || _roadsContract.ownerOf(_x, _y, 1) == msg.sender
2005              || _roadsContract.ownerOf(_x - 1, _y, 0) == msg.sender
2006              || _roadsContract.ownerOf(_x, _y - 1, 1) == msg.sender
2007         );
2008 
2009         // Require that there is no existing blind auction at the location
2010         require(!KingOfEthAuctionsAbstractInterface(blindAuctionsContract).existingAuction(_x, _y));
2011 
2012         // Require that there is no existing open auction at the location
2013         require(!KingOfEthAuctionsAbstractInterface(openAuctionsContract).existingAuction(_x, _y));
2014 
2015         // Set new owner
2016         _locationInfo.owner = msg.sender;
2017 
2018         // Update player's points
2019         ++pointCounts[msg.sender];
2020 
2021         // Distribute resources to the player
2022         KingOfEthResourcesInterface(interfaceContract).distributeResources(
2023               msg.sender
2024             , _x
2025             , _y
2026             , 0 // Level 0
2027         );
2028     }
2029 
2030     /// @dev God can change the house cost
2031     /// @param _newHouseCost The new cost of a house
2032     function godChangeHouseCost(uint _newHouseCost)
2033         public
2034         onlyGod
2035     {
2036         houseCost = _newHouseCost;
2037     }
2038 
2039     /// @dev The auctions contracts can set the owner of a house after an auction
2040     /// @param _x The x coordinate of the house
2041     /// @param _y The y coordinate of the house
2042     /// @param _owner The new owner of the house
2043     function auctionsSetOwner(uint _x, uint _y, address _owner)
2044         public
2045         onlyAuctionsContract
2046     {
2047         // Lookup the info about the house
2048         LocationInfo storage _locationInfo = locationInfo[_x][_y];
2049 
2050         // Require that nobody already owns the house.
2051         // Note that this would be an assert if only the blind auctions
2052         // contract used this code, but the open auctions contract
2053         // depends on this require to save space.
2054         require(0x0 == _locationInfo.owner);
2055 
2056         // Set the house's new owner
2057         _locationInfo.owner = _owner;
2058 
2059         // Give the player a point for the house
2060         ++pointCounts[_owner];
2061 
2062         // Distribute the resources for the house
2063         KingOfEthResourcesInterface(interfaceContract).distributeResources(
2064               _owner
2065             , _x
2066             , _y
2067             , 0 // Level 0
2068         );
2069 
2070         // Set up the locations for the event
2071         uint[] memory _locations = new uint[](2);
2072         _locations[0] = _x;
2073         _locations[1] = _y;
2074 
2075         emit NewHouses(_owner, _locations);
2076     }
2077 
2078     /// @dev The house realty contract can transfer house ownership
2079     /// @param _x The x coordinate of the house
2080     /// @param _y The y coordinate of the house
2081     /// @param _from The previous owner of house
2082     /// @param _to The new owner of house
2083     function houseRealtyTransferOwnership(
2084           uint _x
2085         , uint _y
2086         , address _from
2087         , address _to
2088     )
2089         public
2090         onlyHouseRealtyContract
2091     {
2092         // Lookup the info about the house
2093         LocationInfo storage _locationInfo = locationInfo[_x][_y];
2094 
2095         // Assert that the previous owner still has the house
2096         assert(_locationInfo.owner == _from);
2097 
2098         // Set the new owner
2099         _locationInfo.owner = _to;
2100 
2101         // Calculate the total points of the house
2102         uint _points = _locationInfo.level + 1;
2103 
2104         // Update the point counts
2105         pointCounts[_from] -= _points;
2106         pointCounts[_to]   += _points;
2107     }
2108 
2109     /// @dev Build multiple houses at once
2110     /// @param _locations An array of coordinates for the houses. These
2111     ///  are specified sequentially like [x1, y1, x2, y2] representing
2112     ///  location (x1, y1) and location (x2, y2).
2113     function buildHouses(uint[] _locations)
2114         public
2115         payable
2116     {
2117         // Require that there are an even number of locations
2118         require(0 == _locations.length % 2);
2119 
2120         uint _count = _locations.length / 2;
2121 
2122         // Require the house cost
2123         require(houseCost * _count == msg.value);
2124 
2125         // Pay taxes
2126         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(msg.value)();
2127 
2128         // Burn the required resource costs for the houses
2129         KingOfEthResourcesInterface(interfaceContract).burnHouseCosts(
2130               _count
2131             , msg.sender
2132         );
2133 
2134         // Build a house at each one of the locations
2135         for(uint i = 0; i < _locations.length; i += 2)
2136         {
2137             buildHouseInner(_locations[i], _locations[i + 1]);
2138         }
2139 
2140         emit NewHouses(msg.sender, _locations);
2141     }
2142 
2143     /// @dev Send a house to another player
2144     /// @param _x The x coordinate of the house
2145     /// @param _y The y coordinate of the house
2146     /// @param _to The recipient of the house
2147     function sendHouse(uint _x, uint _y, address _to) public
2148     {
2149         // Lookup the info about the house
2150         LocationInfo storage _locationInfo = locationInfo[_x][_y];
2151 
2152         // Require that the sender is the owner
2153         require(_locationInfo.owner == msg.sender);
2154 
2155         // Set the new owner
2156         _locationInfo.owner = _to;
2157 
2158         // Calculate the points of the house
2159         uint _points = _locationInfo.level + 1;
2160 
2161         // Update point counts
2162         pointCounts[msg.sender] -= _points;
2163         pointCounts[_to]        += _points;
2164 
2165         // Cancel any sales that exist
2166         KingOfEthHouseRealty(houseRealtyContract).housesCancelHouseSale(_x, _y);
2167 
2168         emit SentHouse(_x, _y, msg.sender, _to, _locationInfo.level);
2169     }
2170 
2171     /// @dev Upgrade a house
2172     /// @param _x The x coordinate of the house
2173     /// @param _y The y coordinate of the house
2174     function upgradeHouse(uint _x, uint _y) public payable
2175     {
2176         // Lookup the info about the house
2177         LocationInfo storage _locationInfo = locationInfo[_x][_y];
2178 
2179         // Require that the sender is the owner
2180         require(_locationInfo.owner == msg.sender);
2181 
2182         // Require the house cost be payed
2183         require(houseCost == msg.value);
2184 
2185         // Pay the taxes
2186         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(msg.value)();
2187 
2188         // Burn the resource costs of the upgrade
2189         KingOfEthResourcesInterface(interfaceContract).burnUpgradeCosts(
2190               _locationInfo.level
2191             , msg.sender
2192         );
2193 
2194         // Update the house's level
2195         ++locationInfo[_x][_y].level;
2196 
2197         // Update the owner's points
2198         ++pointCounts[msg.sender];
2199 
2200         // Distribute the resources for the house
2201         KingOfEthResourcesInterface(interfaceContract).distributeResources(
2202               msg.sender
2203             , _x
2204             , _y
2205             , _locationInfo.level
2206         );
2207 
2208         emit UpgradedHouse(_x, _y, msg.sender, _locationInfo.level);
2209     }
2210 }
2211 
2212 // File: contracts/KingOfEthRoadRealty.sol
2213 
2214 /****************************************************
2215  *
2216  * Copyright 2018 BurzNest LLC. All rights reserved.
2217  *
2218  * The contents of this file are provided for review
2219  * and educational purposes ONLY. You MAY NOT use,
2220  * copy, distribute, or modify this software without
2221  * explicit written permission from BurzNest LLC.
2222  *
2223  ****************************************************/
2224 
2225 pragma solidity ^0.4.24;
2226 
2227 
2228 
2229 
2230 
2231 
2232 /// @title King of Eth: Road Realty
2233 /// @author Anthony Burzillo <burz@burznest.com>
2234 /// @dev Contract for controlling sales of roads
2235 contract KingOfEthRoadRealty is
2236       GodMode
2237     , KingOfEthReferencer
2238     , KingOfEthRoadsReferencer
2239 {
2240     /// @dev The number that divides the amount payed for any sale to produce
2241     ///  the amount payed in taxes
2242     uint public constant taxDivisor = 25;
2243 
2244     /// @dev Mapping from the x, y coordinates and the direction (0 for right and
2245     ///  1 for down) of a road to the  current sale price (0 if there is no sale)
2246     mapping (uint => mapping (uint => uint[2])) roadPrices;
2247 
2248     /// @dev Fired when there is a new road for sale
2249     event RoadForSale(
2250           uint x
2251         , uint y
2252         , uint8 direction
2253         , address owner
2254         , uint amount
2255     );
2256 
2257     /// @dev Fired when the owner changes the price of a road
2258     event RoadPriceChanged(
2259           uint x
2260         , uint y
2261         , uint8 direction
2262         , uint amount
2263     );
2264 
2265     /// @dev Fired when a road is sold
2266     event RoadSold(
2267           uint x
2268         , uint y
2269         , uint8 direction
2270         , address from
2271         , address to
2272         , uint amount
2273     );
2274 
2275     /// @dev Fired when the sale for a road is cancelled by the owner
2276     event RoadSaleCancelled(
2277           uint x
2278         , uint y
2279         , uint8 direction
2280         , address owner
2281     );
2282 
2283     /// @dev Only the owner of the road at a location can run this
2284     /// @param _x The x coordinate of the road
2285     /// @param _y The y coordinate of the road
2286     /// @param _direction The direction of the road
2287     modifier onlyRoadOwner(uint _x, uint _y, uint8 _direction)
2288     {
2289         require(KingOfEthRoadsAbstractInterface(roadsContract).ownerOf(_x, _y, _direction) == msg.sender);
2290         _;
2291     }
2292 
2293     /// @dev This can only be run if there is *not* an existing sale for a road
2294     ///  at a location
2295     /// @param _x The x coordinate of the road
2296     /// @param _y The y coordinate of the road
2297     /// @param _direction The direction of the road
2298     modifier noExistingRoadSale(uint _x, uint _y, uint8 _direction)
2299     {
2300         require(0 == roadPrices[_x][_y][_direction]);
2301         _;
2302     }
2303 
2304     /// @dev This can only be run if there is an existing sale for a house
2305     ///  at a location
2306     /// @param _x The x coordinate of the road
2307     /// @param _y The y coordinate of the road
2308     /// @param _direction The direction of the road
2309     modifier existingRoadSale(uint _x, uint _y, uint8 _direction)
2310     {
2311         require(0 != roadPrices[_x][_y][_direction]);
2312         _;
2313     }
2314 
2315     /// @param _kingOfEthContract The address of the king contract
2316     constructor(address _kingOfEthContract) public
2317     {
2318         kingOfEthContract = _kingOfEthContract;
2319     }
2320 
2321     /// @dev The roads contract can cancel a sale when a road is transfered
2322     ///  to another player
2323     /// @param _x The x coordinate of the road
2324     /// @param _y The y coordinate of the road
2325     /// @param _direction The direction of the road
2326     function roadsCancelRoadSale(uint _x, uint _y, uint8 _direction)
2327         public
2328         onlyRoadsContract
2329     {
2330         // If there is indeed a sale
2331         if(0 != roadPrices[_x][_y][_direction])
2332         {
2333             // Cancel the sale
2334             roadPrices[_x][_y][_direction] = 0;
2335 
2336             emit RoadSaleCancelled(_x, _y, _direction, msg.sender);
2337         }
2338     }
2339 
2340     /// @dev The owner of a road can start a sale
2341     /// @param _x The x coordinate of the road
2342     /// @param _y The y coordinate of the road
2343     /// @param _direction The direction of the road
2344     /// @param _askingPrice The price that must be payed by another player
2345     ///  to purchase the road
2346     function startRoadSale(
2347           uint _x
2348         , uint _y
2349         , uint8 _direction
2350         , uint _askingPrice
2351     )
2352         public
2353         notPaused
2354         onlyRoadOwner(_x, _y, _direction)
2355         noExistingRoadSale(_x, _y, _direction)
2356     {
2357         // Require that the price is at least 0
2358         require(0 != _askingPrice);
2359 
2360         // Record the price
2361         roadPrices[_x][_y][_direction] = _askingPrice;
2362 
2363         emit RoadForSale(_x, _y, _direction, msg.sender, _askingPrice);
2364     }
2365 
2366     /// @dev The owner of a road can change the price of a sale
2367     /// @param _x The x coordinate of the road
2368     /// @param _y The y coordinate of the road
2369     /// @param _direction The direction of the road
2370     /// @param _askingPrice The new price that must be payed by another
2371     ///  player to purchase the road
2372     function changeRoadPrice(
2373           uint _x
2374         , uint _y
2375         , uint8 _direction
2376         , uint _askingPrice
2377     )
2378         public
2379         notPaused
2380         onlyRoadOwner(_x, _y, _direction)
2381         existingRoadSale(_x, _y, _direction)
2382     {
2383         // Require that the price is at least 0
2384         require(0 != _askingPrice);
2385 
2386         // Record the price
2387         roadPrices[_x][_y][_direction] = _askingPrice;
2388 
2389         emit RoadPriceChanged(_x, _y, _direction, _askingPrice);
2390     }
2391 
2392     /// @dev Anyone can purchase a road as long as the sale exists
2393     /// @param _x The x coordinate of the road
2394     /// @param _y The y coordinate of the road
2395     /// @param _direction The direction of the road
2396     function purchaseRoad(uint _x, uint _y, uint8 _direction)
2397         public
2398         payable
2399         notPaused
2400         existingRoadSale(_x, _y, _direction)
2401     {
2402         // Require that the exact price was paid
2403         require(roadPrices[_x][_y][_direction] == msg.value);
2404 
2405         // End the sale
2406         roadPrices[_x][_y][_direction] = 0;
2407 
2408         // Calculate the taxes to be paid
2409         uint taxCut = msg.value / taxDivisor;
2410 
2411         // Pay the taxes
2412         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(taxCut)();
2413 
2414         KingOfEthRoadsAbstractInterface _roadsContract = KingOfEthRoadsAbstractInterface(roadsContract);
2415 
2416         // Determine the previous owner
2417         address _oldOwner = _roadsContract.ownerOf(_x, _y, _direction);
2418 
2419         // Send the buyer the house
2420         _roadsContract.roadRealtyTransferOwnership(
2421               _x
2422             , _y
2423             , _direction
2424             , _oldOwner
2425             , msg.sender
2426         );
2427 
2428         // Send the previous owner his share
2429         _oldOwner.transfer(msg.value - taxCut);
2430 
2431         emit RoadSold(
2432               _x
2433             , _y
2434             , _direction
2435             , _oldOwner
2436             , msg.sender
2437             , msg.value
2438         );
2439     }
2440 
2441     /// @dev The owner of a road can cancel a sale
2442     /// @param _x The x coordinate of the road
2443     /// @param _y The y coordinate of the road
2444     /// @param _direction The direction of the road
2445     function cancelRoadSale(uint _x, uint _y, uint8 _direction)
2446         public
2447         notPaused
2448         onlyRoadOwner(_x, _y, _direction)
2449         existingRoadSale(_x, _y, _direction)
2450     {
2451         // Cancel the sale
2452         roadPrices[_x][_y][_direction] = 0;
2453 
2454         emit RoadSaleCancelled(_x, _y, _direction, msg.sender);
2455     }
2456 }
2457 
2458 // File: contracts/KingOfEthRoadRealtyReferencer.sol
2459 
2460 /****************************************************
2461  *
2462  * Copyright 2018 BurzNest LLC. All rights reserved.
2463  *
2464  * The contents of this file are provided for review
2465  * and educational purposes ONLY. You MAY NOT use,
2466  * copy, distribute, or modify this software without
2467  * explicit written permission from BurzNest LLC.
2468  *
2469  ****************************************************/
2470 
2471 pragma solidity ^0.4.24;
2472 
2473 
2474 /// @title King of Eth: Road Realty Referencer
2475 /// @author Anthony Burzillo <burz@burznest.com>
2476 /// @dev Provides functionality to reference the road realty contract
2477 contract KingOfEthRoadRealtyReferencer is GodMode {
2478     /// @dev The realty contract's address
2479     address public roadRealtyContract;
2480 
2481     /// @dev Only the road realty contract can run this function
2482     modifier onlyRoadRealtyContract()
2483     {
2484         require(roadRealtyContract == msg.sender);
2485         _;
2486     }
2487 
2488     /// @dev God can set the road realty contract
2489     /// @param _roadRealtyContract The new address
2490     function godSetRoadRealtyContract(address _roadRealtyContract)
2491         public
2492         onlyGod
2493     {
2494         roadRealtyContract = _roadRealtyContract;
2495     }
2496 }
2497 
2498 // File: contracts/KingOfEthRoads.sol
2499 
2500 /****************************************************
2501  *
2502  * Copyright 2018 BurzNest LLC. All rights reserved.
2503  *
2504  * The contents of this file are provided for review
2505  * and educational purposes ONLY. You MAY NOT use,
2506  * copy, distribute, or modify this software without
2507  * explicit written permission from BurzNest LLC.
2508  *
2509  ****************************************************/
2510 
2511 pragma solidity ^0.4.24;
2512 
2513 
2514 
2515 
2516 
2517 
2518 
2519 
2520 
2521 
2522 
2523 
2524 
2525 /// @title King of Eth: Roads
2526 /// @author Anthony Burzillo <burz@burznest.com>
2527 /// @dev Contract for roads
2528 contract KingOfEthRoads is
2529       GodMode
2530     , KingOfEthBoardReferencer
2531     , KingOfEthHousesReferencer
2532     , KingOfEthReferencer
2533     , KingOfEthResourcesInterfaceReferencer
2534     , KingOfEthRoadRealtyReferencer
2535     , KingOfEthRoadsAbstractInterface
2536 {
2537     /// @dev ETH cost to build a road
2538     uint public roadCost = 0.0002 ether;
2539 
2540     /// @dev Mapping from the x, y, direction coordinate of the location to its owner
2541     mapping (uint => mapping (uint => address[2])) owners;
2542 
2543     /// @dev Mapping from a players address to his road counts
2544     mapping (address => uint) roadCounts;
2545 
2546     /// @param _boardContract The address of the board contract
2547     /// @param _roadRealtyContract The address of the road realty contract
2548     /// @param _kingOfEthContract The address of the king contract
2549     /// @param _interfaceContract The address of the resources
2550     ///  interface contract
2551     constructor(
2552           address _boardContract
2553         , address _roadRealtyContract
2554         , address _kingOfEthContract
2555         , address _interfaceContract
2556     )
2557         public
2558     {
2559         boardContract      = _boardContract;
2560         roadRealtyContract = _roadRealtyContract;
2561         kingOfEthContract  = _kingOfEthContract;
2562         interfaceContract  = _interfaceContract;
2563     }
2564 
2565     /// @dev Fired when new roads are built
2566     event NewRoads(
2567           address owner
2568         , uint x
2569         , uint y
2570         , uint8 direction
2571         , uint length
2572     );
2573 
2574     /// @dev Fired when a road is sent from one player to another
2575     event SentRoad(
2576           uint x
2577         , uint y
2578         , uint direction
2579         , address from
2580         , address to
2581     );
2582 
2583     /// @dev Get the owner of the road at some location
2584     /// @param _x The x coordinate of the road
2585     /// @param _y The y coordinate of the road
2586     /// @param _direction The direction of the road (either
2587     ///  0 for right or 1 for down)
2588     /// @return The address of the owner
2589     function ownerOf(uint _x, uint _y, uint8 _direction)
2590         public
2591         view
2592         returns(address)
2593     {
2594         // Only 0 or 1 is a valid direction
2595         require(2 > _direction);
2596 
2597         return owners[_x][_y][_direction];
2598     }
2599 
2600     /// @dev Get the number of roads owned by a player
2601     /// @param _player The player's address
2602     /// @return The number of roads
2603     function numberOfRoads(address _player) public view returns(uint)
2604     {
2605         return roadCounts[_player];
2606     }
2607 
2608     /// @dev Only the owner of a road can run this
2609     /// @param _x The x coordinate of the road
2610     /// @param _y The y coordinate of the road
2611     /// @param _direction The direction of the road
2612     modifier onlyRoadOwner(uint _x, uint _y, uint8 _direction)
2613     {
2614         require(owners[_x][_y][_direction] == msg.sender);
2615         _;
2616     }
2617 
2618     /// @dev Build houses to the right
2619     /// @param _x The x coordinate of the starting point of the first road
2620     /// @param _y The y coordinate of the starting point of the first road
2621     /// @param _length The length to build
2622     function buildRight(uint _x, uint _y, uint _length) private
2623     {
2624         // Require that nobody currently owns the road
2625         require(0x0 == owners[_x][_y][0]);
2626 
2627         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2628 
2629         // Require that either the player owns the house at the
2630         // starting location, the road below it, the road to the
2631         // left of it, or the road above it
2632         address _houseOwner = _housesContract.ownerOf(_x, _y);
2633         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2634                owners[_x][_y][1] == msg.sender
2635             || owners[_x - 1][_y][0] == msg.sender
2636             || owners[_x][_y - 1][1] == msg.sender
2637         )));
2638 
2639         // Set the new owner
2640         owners[_x][_y][0] = msg.sender;
2641 
2642         for(uint _i = 1; _i < _length; ++_i)
2643         {
2644             // Require that nobody currently owns the road
2645             require(0x0 == owners[_x + _i][_y][0]);
2646 
2647             // Require that either the house location is empty or
2648             // that it is owned by the player
2649             require(
2650                    _housesContract.ownerOf(_x + _i, _y) == 0x0
2651                 || _housesContract.ownerOf(_x + _i, _y) == msg.sender
2652             );
2653 
2654             // Set the new owner
2655             owners[_x + _i][_y][0] = msg.sender;
2656         }
2657     }
2658 
2659     /// @dev Build houses downwards
2660     /// @param _x The x coordinate of the starting point of the first road
2661     /// @param _y The y coordinate of the starting point of the first road
2662     /// @param _length The length to build
2663     function buildDown(uint _x, uint _y, uint _length) private
2664     {
2665         // Require that nobody currently owns the road
2666         require(0x0 == owners[_x][_y][1]);
2667 
2668         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2669 
2670         // Require that either the player owns the house at the
2671         // starting location, the road to the right of it, the road to
2672         // the left of it, or the road above it
2673         address _houseOwner = _housesContract.ownerOf(_x, _y);
2674         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2675                owners[_x][_y][0] == msg.sender
2676             || owners[_x - 1][_y][0] == msg.sender
2677             || owners[_x][_y - 1][1] == msg.sender
2678         )));
2679 
2680         // Set the new owner
2681         owners[_x][_y][1] = msg.sender;
2682 
2683         for(uint _i = 1; _i < _length; ++_i)
2684         {
2685             // Require that nobody currently owns the road
2686             require(0x0 == owners[_x][_y + _i][1]);
2687 
2688             // Require that either the house location is empty or
2689             // that it is owned by the player
2690             require(
2691                    _housesContract.ownerOf(_x, _y + _i) == 0x0
2692                 || _housesContract.ownerOf(_x, _y + _i) == msg.sender
2693             );
2694 
2695             // Set the new owner
2696             owners[_x][_y + _i][1] = msg.sender;
2697         }
2698     }
2699 
2700     /// @dev Build houses to the left
2701     /// @param _x The x coordinate of the starting point of the first road
2702     /// @param _y The y coordinate of the starting point of the first road
2703     /// @param _length The length to build
2704     function buildLeft(uint _x, uint _y, uint _length) private
2705     {
2706         // Require that nobody currently owns the road
2707         require(0x0 == owners[_x - 1][_y][0]);
2708 
2709         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2710 
2711         // Require that either the player owns the house at the
2712         // starting location, the road to the right of it, the road
2713         // below it, or the road above it
2714         address _houseOwner = _housesContract.ownerOf(_x, _y);
2715         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2716                owners[_x][_y][0] == msg.sender
2717             || owners[_x][_y][1] == msg.sender
2718             || owners[_x][_y - 1][1] == msg.sender
2719         )));
2720 
2721         // Set the new owner
2722         owners[_x - 1][_y][0] = msg.sender;
2723 
2724         for(uint _i = 1; _i < _length; ++_i)
2725         {
2726             // Require that nobody currently owns the road
2727             require(0x0 == owners[_x - _i - 1][_y][0]);
2728 
2729             // Require that either the house location is empty or
2730             // that it is owned by the player
2731             require(
2732                    _housesContract.ownerOf(_x - _i, _y) == 0x0
2733                 || _housesContract.ownerOf(_x - _i, _y) == msg.sender
2734             );
2735 
2736             // Set the new owner
2737             owners[_x - _i - 1][_y][0] = msg.sender;
2738         }
2739     }
2740 
2741     /// @dev Build houses upwards
2742     /// @param _x The x coordinate of the starting point of the first road
2743     /// @param _y The y coordinate of the starting point of the first road
2744     /// @param _length The length to build
2745     function buildUp(uint _x, uint _y, uint _length) private
2746     {
2747         // Require that nobody currently owns the road
2748         require(0x0 == owners[_x][_y - 1][1]);
2749 
2750         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2751 
2752         // Require that either the player owns the house at the
2753         // starting location, the road to the right of it, the road
2754         // below it, or the road to the left of it
2755         address _houseOwner = _housesContract.ownerOf(_x, _y);
2756         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2757                owners[_x][_y][0] == msg.sender
2758             || owners[_x][_y][1] == msg.sender
2759             || owners[_x - 1][_y][0] == msg.sender
2760         )));
2761 
2762         // Set the new owner
2763         owners[_x][_y - 1][1] = msg.sender;
2764 
2765         for(uint _i = 1; _i < _length; ++_i)
2766         {
2767             // Require that nobody currently owns the road
2768             require(0x0 == owners[_x][_y - _i - 1][1]);
2769 
2770             // Require that either the house location is empty or
2771             // that it is owned by the player
2772             require(
2773                    _housesContract.ownerOf(_x, _y - _i) == 0x0
2774                 || _housesContract.ownerOf(_x, _y - _i) == msg.sender
2775             );
2776 
2777             // Set the new owner
2778             owners[_x][_y - _i - 1][1] = msg.sender;
2779         }
2780     }
2781 
2782     /// @dev God can change the road cost
2783     /// @param _newRoadCost The new cost of a road
2784     function godChangeRoadCost(uint _newRoadCost)
2785         public
2786         onlyGod
2787     {
2788         roadCost = _newRoadCost;
2789     }
2790 
2791     /// @dev The road realty contract can transfer road ownership
2792     /// @param _x The x coordinate of the road
2793     /// @param _y The y coordinate of the road
2794     /// @param _direction The direction of the road
2795     /// @param _from The previous owner of road
2796     /// @param _to The new owner of road
2797     function roadRealtyTransferOwnership(
2798           uint _x
2799         , uint _y
2800         , uint8 _direction
2801         , address _from
2802         , address _to
2803     )
2804         public
2805         onlyRoadRealtyContract
2806     {
2807         // Assert that the previous owner still has the road
2808         assert(owners[_x][_y][_direction] == _from);
2809 
2810         // Set the new owner
2811         owners[_x][_y][_direction] = _to;
2812 
2813         // Update the road counts
2814         --roadCounts[_from];
2815         ++roadCounts[_to];
2816     }
2817 
2818     /// @dev Build a road in a direction from a location
2819     /// @param _x The x coordinate of the starting location
2820     /// @param _y The y coordinate of the starting location
2821     /// @param _direction The direction to build (right is 0, down is 1,
2822     ///  2 is left, and 3 is up)
2823     /// @param _length The number of roads to build
2824     function buildRoads(
2825           uint _x
2826         , uint _y
2827         , uint8 _direction
2828         , uint _length
2829     )
2830         public
2831         payable
2832     {
2833         // Require at least one road to be built
2834         require(0 < _length);
2835 
2836         // Require that the cost for each road was payed
2837         require(roadCost * _length == msg.value);
2838 
2839         KingOfEthBoard _boardContract = KingOfEthBoard(boardContract);
2840 
2841         // Require that the start is within bounds
2842         require(_boardContract.boundX1() <= _x);
2843         require(_boardContract.boundY1() <= _y);
2844         require(_boardContract.boundX2() > _x);
2845         require(_boardContract.boundY2() > _y);
2846 
2847         // Burn the resource costs for each road
2848         KingOfEthResourcesInterface(interfaceContract).burnRoadCosts(
2849               _length
2850             , msg.sender
2851         );
2852 
2853         // If the direction is right
2854         if(0 == _direction)
2855         {
2856             // Require that the roads will be in bounds
2857             require(_boardContract.boundX2() > _x + _length);
2858 
2859             buildRight(_x, _y, _length);
2860         }
2861         // If the direction is down
2862         else if(1 == _direction)
2863         {
2864             // Require that the roads will be in bounds
2865             require(_boardContract.boundY2() > _y + _length);
2866 
2867             buildDown(_x, _y, _length);
2868         }
2869         // If the direction is left
2870         else if(2 == _direction)
2871         {
2872             // Require that the roads will be in bounds
2873             require(_boardContract.boundX1() < _x - _length - 1);
2874 
2875             buildLeft(_x, _y, _length);
2876         }
2877         // If the direction is up
2878         else if(3 == _direction)
2879         {
2880             // Require that the roads will be in bounds
2881             require(_boardContract.boundY1() < _y - _length - 1);
2882 
2883             buildUp(_x, _y, _length);
2884         }
2885         else
2886         {
2887             // Revert if the direction is invalid
2888             revert();
2889         }
2890 
2891         // Update the number of roads of the player
2892         roadCounts[msg.sender] += _length;
2893 
2894         // Pay taxes
2895         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(msg.value)();
2896 
2897         emit NewRoads(msg.sender, _x, _y, _direction, _length);
2898     }
2899 
2900     /// @dev Send a road to another player
2901     /// @param _x The x coordinate of the road
2902     /// @param _y The y coordinate of the road
2903     /// @param _direction The direction of the road
2904     /// @param _to The recipient of the road
2905     function sendRoad(uint _x, uint _y, uint8 _direction, address _to)
2906         public
2907         onlyRoadOwner(_x, _y, _direction)
2908     {
2909         // Set the new owner
2910         owners[_x][_y][_direction] = _to;
2911 
2912         // Update road counts
2913         --roadCounts[msg.sender];
2914         ++roadCounts[_to];
2915 
2916         // Cancel any sales that exist
2917         KingOfEthRoadRealty(roadRealtyContract).roadsCancelRoadSale(
2918               _x
2919             , _y
2920             , _direction
2921         );
2922 
2923         emit SentRoad(_x, _y, _direction, msg.sender, _to);
2924     }
2925 }
2926 
2927 // File: contracts/KingOfEth.sol
2928 
2929 /****************************************************
2930  *
2931  * Copyright 2018 BurzNest LLC. All rights reserved.
2932  *
2933  * The contents of this file are provided for review
2934  * and educational purposes ONLY. You MAY NOT use,
2935  * copy, distribute, or modify this software without
2936  * explicit written permission from BurzNest LLC.
2937  *
2938  ****************************************************/
2939 
2940 pragma solidity ^0.4.24;
2941 
2942 
2943 
2944 
2945 
2946 
2947 
2948 
2949 /// @title King of Eth
2950 /// @author Anthony Burzillo <burz@burznest.com>
2951 /// @dev Contract for titles, and taxes
2952 contract KingOfEth is
2953       GodMode
2954     , KingOfEthHousesReferencer
2955     , KingOfEthRoadsReferencer
2956     , KingOfEthResourcesInterfaceReferencer
2957 {
2958     /// @dev Number used to divide the taxes to yield the King's share
2959     uint public constant kingsTaxDivisor = 5;
2960 
2961     /// @dev Number used to divide the taxes to yield the Wayfarer's share
2962     uint public constant wayfarersTaxDivisor = 20;
2963 
2964     /// @dev Number used to divide the taxes to yield Parliament's share
2965     uint public constant parliamentsTaxDivisor = 4;
2966 
2967     /// @dev Amount of time the King, Wayfarer, and Paliament must wait
2968     ///  between claiming/distributing their taxes
2969     uint public constant timeBetweenClaims = 2 weeks;
2970 
2971     /// @dev Amount of time the King or Parliement has to claim/distribute
2972     ///  their taxes before the other side is able to overthrow them
2973     uint public constant gracePeriod = 1 days;
2974 
2975     /// @dev The address of the current King
2976     address public king;
2977 
2978     /// @dev The amount of taxes currently reserved for the King
2979     uint public kingsTaxes;
2980 
2981     /// @dev The last time that the King claimed his taxes
2982     uint public kingsTaxesLastClaimed;
2983 
2984     /// @dev The address of the current Wayfarer
2985     address public wayfarer;
2986 
2987     /// @dev The amount of taxes currently reserved for the Wayfarer
2988     uint public wayfarersTaxes;
2989 
2990     /// @dev The last time that the Wayfarer claimed his taxes
2991     uint public wayfarersTaxesLastClaimed;
2992 
2993     /// @dev Relevant data for each seat of Parliament
2994     struct ParliamentSeatData {
2995         /// @dev The number of resource points the seat holds
2996         uint points;
2997 
2998         /// @dev The amount of unclaimed taxes the seat has
2999         ///  and can claim at any time
3000         uint unclaimedTaxes;
3001     }
3002 
3003     /// @dev The 10 seats of Parliament
3004     address[10] public parliamentSeats;
3005 
3006     /// @dev Mapping from an arbitrary address to data about a seat
3007     ///  of Parliament (this data exists only for the current seats)
3008     mapping (address => ParliamentSeatData) parliamentSeatData;
3009 
3010     /// @dev The number of taxes currently reserved for Parliament
3011     uint public parliamentsTaxes;
3012 
3013     /// @dev The last time that Parliament's taxes were distributed
3014     uint public parliamentsTaxesLastDistributed;
3015 
3016     /// @param _interfaceContract The address for the resources
3017     ///  interface contract
3018     constructor(address _interfaceContract) public
3019     {
3020         interfaceContract = _interfaceContract;
3021 
3022         // Game is paused as God must start it
3023         isPaused = true;
3024     }
3025 
3026     /// @dev Fired when the King's taxes are claimed
3027     event KingsTaxesClaimed(address king, uint claimedTime);
3028 
3029     /// @dev Fired when the Wayfarer's taxes are claimed
3030     event WayfarersTaxesClaimed(address wayfarer, uint claimedTime);
3031 
3032     /// @dev Fired when a seat in Parliament claims their
3033     ///  unclaimed taxes
3034     event ParliamentTaxesClaimed(address seat);
3035 
3036     /// @dev Fired when a new King claims the throne
3037     event NewKing(address king);
3038 
3039     /// @dev Fired when a new Wayfarer claims the title
3040     event NewWayfarer(address wayfarer);
3041 
3042     /// @dev Fired when a player claims a seat in Parliament
3043     event ParliamentSeatClaimed(address seat, uint points);
3044 
3045     /// @dev Fired when a successful inquest is made against a
3046     ///  seat of Parliament
3047     event ParliamentInquest(address seat, uint points);
3048 
3049     /// @dev Fired when Parliament's taxes are distributed
3050     event ParliamentsTaxesDistributed(
3051           address distributor
3052         , uint share
3053         , uint distributedTime
3054     );
3055 
3056     /// @dev Fired when Parliament is overthrown by the king
3057     event ParliamentOverthrown(uint overthrownTime);
3058 
3059     /// @dev Fired when the King is overthrown by Parliament
3060     event KingOverthrown(uint overthrownTime);
3061 
3062     /// @dev Only the King can run this
3063     modifier onlyKing()
3064     {
3065         require(king == msg.sender);
3066         _;
3067     }
3068 
3069     /// @dev Only the Wayfarer can run this
3070     modifier onlyWayfarer()
3071     {
3072         require(wayfarer == msg.sender);
3073         _;
3074     }
3075 
3076     /// @dev Only a Parliament seat can run this
3077     modifier onlyParliamentSeat()
3078     {
3079         require(0 != parliamentSeatData[msg.sender].points);
3080         _;
3081     }
3082 
3083     /// @dev God can withdraw his taxes
3084     function godWithdrawTaxes()
3085         public
3086         onlyGod
3087     {
3088         // Add up each Parliament seat's unclaimed taxes
3089         uint _parliamentsUnclaimed = 0;
3090         for(uint8 _i = 0; _i < 10; ++_i)
3091         {
3092             _parliamentsUnclaimed += parliamentSeatData[parliamentSeats[_i]].unclaimedTaxes;
3093         }
3094 
3095         // God's share is the balance minus the king's, the wayfarer's,
3096         //  Parliament's, as well as any of Parliament's seat's unclaimed taxes
3097         uint taxes = address(this).balance - kingsTaxes - wayfarersTaxes
3098                    - parliamentsTaxes - _parliamentsUnclaimed;
3099 
3100         god.transfer(taxes);
3101     }
3102 
3103     /// @dev God can start the game
3104     function godStartGame() public onlyGod
3105     {
3106         // Reset time title taxes were last claimed
3107         kingsTaxesLastClaimed           = now;
3108         wayfarersTaxesLastClaimed       = now;
3109         parliamentsTaxesLastDistributed = now;
3110 
3111         // Unpause the game
3112         isPaused = false;
3113     }
3114 
3115     /// @dev The King can claim his taxes
3116     function kingWithdrawTaxes()
3117         public
3118         onlyKing
3119     {
3120         // Require that enought time has passed since the King's last claim
3121         require(kingsTaxesLastClaimed + timeBetweenClaims < now);
3122 
3123         // The last claim time is now
3124         kingsTaxesLastClaimed = now;
3125 
3126         // Temporarily save the King's taxes
3127         uint _taxes = kingsTaxes;
3128 
3129         // Reset the King's taxes
3130         kingsTaxes = 0;
3131 
3132         king.transfer(_taxes);
3133 
3134         emit KingsTaxesClaimed(msg.sender, now);
3135     }
3136 
3137     /// @dev The Wayfarer can claim his taxes
3138     function wayfarerWithdrawTaxes()
3139         public
3140         onlyWayfarer
3141     {
3142         // Require that enough time has passed since the Wayfarer's last claim
3143         require(wayfarersTaxesLastClaimed + timeBetweenClaims < now);
3144 
3145         // The last claim time is now
3146         wayfarersTaxesLastClaimed = now;
3147 
3148         // Temporarily save the Wayfarer's taxes
3149         uint _taxes = wayfarersTaxes;
3150 
3151         // Reset the Wayfarer's taxes
3152         wayfarersTaxes = 0;
3153 
3154         wayfarer.transfer(_taxes);
3155 
3156         emit WayfarersTaxesClaimed(msg.sender, now);
3157     }
3158 
3159     /// @dev A seat of Parliament can withdraw any unclaimed taxes
3160     function parliamentWithdrawTaxes()
3161         public
3162     {
3163         // Lookup the data on the sender
3164         ParliamentSeatData storage _senderData = parliamentSeatData[msg.sender];
3165 
3166         // If the sender does indeed have unclaimed taxes
3167         if(0 != _senderData.unclaimedTaxes)
3168         {
3169             // Temporarily save the taxes
3170             uint _taxes = _senderData.unclaimedTaxes;
3171 
3172             // Mark the taxes as claimed
3173             _senderData.unclaimedTaxes = 0;
3174 
3175             // Send the sender the unclaimed taxes
3176             msg.sender.transfer(_taxes);
3177         }
3178 
3179         emit ParliamentTaxesClaimed(msg.sender);
3180     }
3181 
3182     /// @dev Claim the King's throne
3183     function claimThrone() public
3184     {
3185         KingOfEthHouses _housesContract = KingOfEthHouses(housesContract);
3186 
3187         // Require the claimant to have more points than the King
3188         require(_housesContract.numberOfPoints(king) < _housesContract.numberOfPoints(msg.sender));
3189 
3190         // Save the new King
3191         king = msg.sender;
3192 
3193         emit NewKing(msg.sender);
3194     }
3195 
3196     /// @dev Claim the Wayfarer's title
3197     function claimWayfarerTitle() public
3198     {
3199         KingOfEthRoads _roadsContract = KingOfEthRoads(roadsContract);
3200 
3201         // Require the claimant to have more roads than the wayfarer
3202         require(_roadsContract.numberOfRoads(wayfarer) < _roadsContract.numberOfRoads(msg.sender));
3203 
3204         // Save the new Wayfarer
3205         wayfarer = msg.sender;
3206 
3207         emit NewWayfarer(msg.sender);
3208     }
3209 
3210     /// @dev Claim a seat in Parliament
3211     function claimParliamentSeat() public
3212     {
3213         // Lookup the sender's data
3214         ParliamentSeatData storage _senderData = parliamentSeatData[msg.sender];
3215 
3216         // If the sender is not already in Parliament
3217         if(0 == _senderData.points)
3218         {
3219             // Determine the points of the sender
3220             uint _points
3221                 = KingOfEthResourcesInterface(interfaceContract).lookupResourcePoints(msg.sender);
3222 
3223             // Lookup the lowest seat in parliament (the last seat)
3224             ParliamentSeatData storage _lastSeat = parliamentSeatData[parliamentSeats[9]];
3225 
3226             // If the lowest ranking seat has fewer points than the sender
3227             if(_lastSeat.points < _points)
3228             {
3229                 // If the lowest ranking seat has unclaimed taxes
3230                 if(0 != _lastSeat.unclaimedTaxes)
3231                 {
3232                     // Put them back into Parliament's pool
3233                     parliamentsTaxes += _lastSeat.unclaimedTaxes;
3234                 }
3235 
3236                 // Delete the lowest seat's data
3237                 delete parliamentSeatData[parliamentSeats[9]];
3238 
3239                 // Record the sender's points
3240                 _senderData.points = _points;
3241 
3242                 // Record the new seat's temporary standing
3243                 parliamentSeats[_i] = msg.sender;
3244 
3245                 uint8 _i;
3246 
3247                 // Move the new seat up until they are in the correct position
3248                 for(_i = 8; _i >= 0; --_i)
3249                 {
3250                     // If the seat above has fewer points than the new seat
3251                     if(parliamentSeatData[parliamentSeats[_i]].points < _points)
3252                     {
3253                         // Move the seat above down
3254                         parliamentSeats[_i + 1] = parliamentSeats[_i];
3255                     }
3256                     else
3257                     {
3258                         // We have found the new seat's position
3259                         parliamentSeats[_i] = msg.sender;
3260 
3261                         break;
3262                     }
3263                 }
3264 
3265                 emit ParliamentSeatClaimed(msg.sender, _points);
3266             }
3267         }
3268     }
3269 
3270     /// @dev Question the standing of a current seat in Parliament
3271     /// @param _seat The seat to run the inquest on
3272     function parliamentInquest(address _seat) public
3273     {
3274         // Grab the seat's data
3275         ParliamentSeatData storage _seatData = parliamentSeatData[_seat];
3276 
3277         // Ensure that the account in question is actually in Parliament
3278         if(0 != _seatData.points)
3279         {
3280             // Determine the current points held by the seat
3281             uint _newPoints
3282                 = KingOfEthResourcesInterface(interfaceContract).lookupResourcePoints(_seat);
3283 
3284             uint _i;
3285 
3286             // If the seat has more points than before
3287             if(_seatData.points < _newPoints)
3288             {
3289                 // Find the seat's current location
3290                 _i = 9;
3291                 while(_seat != parliamentSeats[_i])
3292                 {
3293                     --_i;
3294                 }
3295 
3296                 // For each seat higher than the seat in question
3297                 for(; _i > 0; --_i)
3298                 {
3299                     // If the higher seat has fewer points than the seat in question
3300                     if(parliamentSeatData[parliamentSeats[_i - 1]].points < _newPoints)
3301                     {
3302                         // Move the seat back
3303                         parliamentSeats[_i] = parliamentSeats[_i - 1];
3304                     }
3305                     else
3306                     {
3307                         // Record the seat's (new) position
3308                         parliamentSeats[_i] = _seat;
3309 
3310                         break;
3311                     }
3312                 }
3313             }
3314             // If the seat has the same number of points
3315             else if(_seatData.points == _newPoints)
3316             {
3317                 revert();
3318             }
3319             // If the seat has fewer points than before
3320             else
3321             {
3322                 // Find the seat's current position
3323                 _i = 0;
3324                 while(_seat != parliamentSeats[_i])
3325                 {
3326                     ++_i;
3327                 }
3328 
3329                 // For each seat lower than the seat in question
3330                 for(; _i < 10; ++_i)
3331                 {
3332                     // If the lower seat has more points than the seat in question
3333                     if(parliamentSeatData[parliamentSeats[_i + 1]].points > _newPoints)
3334                     {
3335                         // Move the lower seat up
3336                         parliamentSeats[_i] = parliamentSeats[_i + 1];
3337                     }
3338                     else
3339                     {
3340                         // Record the seat's (new) position
3341                         parliamentSeats[_i] = _seat;
3342 
3343                         break;
3344                     }
3345                 }
3346             }
3347 
3348             // Save the seat in question's points
3349             _seatData.points = _newPoints;
3350 
3351             emit ParliamentInquest(_seat, _newPoints);
3352         }
3353     }
3354 
3355     /// @dev Distribute the taxes set aside for Parliament to
3356     ///  the seats of Parliament
3357     function distributeParliamentTaxes()
3358         public
3359         onlyParliamentSeat
3360     {
3361         // Require enough time has passed since Parliament's last taxes
3362         // were distributed
3363         require(parliamentsTaxesLastDistributed + timeBetweenClaims < now);
3364 
3365         // Determine the share for each seat of Parliament (plus an additional
3366         // share for the distributor)
3367         uint _share = parliamentsTaxes / 11;
3368 
3369         // Calculate the distributor's share
3370         uint _distributorsShare = parliamentsTaxes - _share * 9;
3371 
3372         // Reset Parliament's claimable taxes
3373         parliamentsTaxes = 0;
3374 
3375         // For each seat of Parliament
3376         for(uint8 _i = 0; _i < 10; ++_i)
3377         {
3378             // If the distributor is not the seat in question
3379             if(msg.sender != parliamentSeats[_i])
3380             {
3381                 // Add the share to the seat's unclaimedTaxes
3382                 parliamentSeatData[parliamentSeats[_i]].unclaimedTaxes += _share;
3383             }
3384         }
3385 
3386         // Set the last time the taxes were distributed to now
3387         parliamentsTaxesLastDistributed = now;
3388 
3389         // Send the distributor their double share
3390         msg.sender.transfer(_distributorsShare);
3391 
3392         emit ParliamentsTaxesDistributed(msg.sender, _share, now);
3393     }
3394 
3395     /// @dev If the grace period has elapsed, the king can overthrow
3396     ///  Parliament and claim their taxes
3397     function overthrowParliament()
3398         public
3399         onlyKing
3400     {
3401         // Require that the time between claims plus
3402         //  the grace period has elapsed
3403         require(parliamentsTaxesLastDistributed + timeBetweenClaims + gracePeriod < now);
3404 
3405         // The king can now claim Parliament's taxes as well
3406         kingsTaxes += parliamentsTaxes;
3407 
3408         // Parliament has lost their taxes
3409         parliamentsTaxes = 0;
3410 
3411         // Parliament must wait before distributing their taxes again
3412         parliamentsTaxesLastDistributed = now;
3413 
3414         emit ParliamentOverthrown(now);
3415     }
3416 
3417     /// @dev If the grace period has elapsed, Parliament can overthrow
3418     ///  the king and claim his taxes
3419     function overthrowKing()
3420         public
3421         onlyParliamentSeat
3422     {
3423         // Require the time between claims plus
3424         // the grace period has elapsed
3425         require(kingsTaxesLastClaimed + timeBetweenClaims + gracePeriod < now);
3426 
3427         // Parliament can now claim the King's taxes as well
3428         parliamentsTaxes += kingsTaxes;
3429 
3430         // The King has lost his taxes
3431         kingsTaxes = 0;
3432 
3433         // The King must wait before claiming his taxes again
3434         kingsTaxesLastClaimed = now;
3435 
3436         emit KingOverthrown(now);
3437     }
3438 
3439     /// @dev Anyone can pay taxes
3440     function payTaxes() public payable
3441     {
3442         // Add the King's share
3443         kingsTaxes += msg.value / kingsTaxDivisor;
3444 
3445         // Add the Wayfarer's share
3446         wayfarersTaxes += msg.value / wayfarersTaxDivisor;
3447 
3448         // Add Parliament's share
3449         parliamentsTaxes += msg.value / parliamentsTaxDivisor;
3450     }
3451 }