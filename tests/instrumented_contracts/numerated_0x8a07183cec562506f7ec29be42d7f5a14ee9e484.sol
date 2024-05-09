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