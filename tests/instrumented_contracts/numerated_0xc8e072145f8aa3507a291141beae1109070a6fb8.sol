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
108 // File: contracts/KingOfEthBlindAuctionsReferencer.sol
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
123 
124 /// @title King of Eth: Blind Auctions Referencer
125 /// @author Anthony Burzillo <burz@burznest.com>
126 /// @dev This contract provides a reference to the blind auctions contract
127 contract KingOfEthBlindAuctionsReferencer is GodMode {
128     /// @dev The address of the blind auctions contract
129     address public blindAuctionsContract;
130 
131     /// @dev Only the blind auctions contract can run this
132     modifier onlyBlindAuctionsContract()
133     {
134         require(blindAuctionsContract == msg.sender);
135         _;
136     }
137 
138     /// @dev God can set a new blind auctions contract
139     /// @param _blindAuctionsContract the address of the blind auctions
140     ///  contract
141     function godSetBlindAuctionsContract(address _blindAuctionsContract)
142         public
143         onlyGod
144     {
145         blindAuctionsContract = _blindAuctionsContract;
146     }
147 }
148 
149 // File: contracts/KingOfEthOpenAuctionsReferencer.sol
150 
151 /****************************************************
152  *
153  * Copyright 2018 BurzNest LLC. All rights reserved.
154  *
155  * The contents of this file are provided for review
156  * and educational purposes ONLY. You MAY NOT use,
157  * copy, distribute, or modify this software without
158  * explicit written permission from BurzNest LLC.
159  *
160  ****************************************************/
161 
162 pragma solidity ^0.4.24;
163 
164 
165 /// @title King of Eth: Open Auctions Referencer
166 /// @author Anthony Burzillo <burz@burznest.com>
167 /// @dev This contract provides a reference to the open auctions contract
168 contract KingOfEthOpenAuctionsReferencer is GodMode {
169     /// @dev The address of the auctions contract
170     address public openAuctionsContract;
171 
172     /// @dev Only the open auctions contract can run this
173     modifier onlyOpenAuctionsContract()
174     {
175         require(openAuctionsContract == msg.sender);
176         _;
177     }
178 
179     /// @dev God can set a new auctions contract
180     function godSetOpenAuctionsContract(address _openAuctionsContract)
181         public
182         onlyGod
183     {
184         openAuctionsContract = _openAuctionsContract;
185     }
186 }
187 
188 // File: contracts/KingOfEthAuctionsReferencer.sol
189 
190 /****************************************************
191  *
192  * Copyright 2018 BurzNest LLC. All rights reserved.
193  *
194  * The contents of this file are provided for review
195  * and educational purposes ONLY. You MAY NOT use,
196  * copy, distribute, or modify this software without
197  * explicit written permission from BurzNest LLC.
198  *
199  ****************************************************/
200 
201 pragma solidity ^0.4.24;
202 
203 
204 
205 /// @title King of Eth: Auctions Referencer
206 /// @author Anthony Burzillo <burz@burznest.com>
207 /// @dev This contract provides a reference to the auctions contracts
208 contract KingOfEthAuctionsReferencer is
209       KingOfEthBlindAuctionsReferencer
210     , KingOfEthOpenAuctionsReferencer
211 {
212     /// @dev Only an auctions contract can run this
213     modifier onlyAuctionsContract()
214     {
215         require(blindAuctionsContract == msg.sender
216              || openAuctionsContract == msg.sender);
217         _;
218     }
219 }
220 
221 // File: contracts/KingOfEthReferencer.sol
222 
223 /****************************************************
224  *
225  * Copyright 2018 BurzNest LLC. All rights reserved.
226  *
227  * The contents of this file are provided for review
228  * and educational purposes ONLY. You MAY NOT use,
229  * copy, distribute, or modify this software without
230  * explicit written permission from BurzNest LLC.
231  *
232  ****************************************************/
233 
234 pragma solidity ^0.4.24;
235 
236 
237 /// @title King of Eth Referencer
238 /// @author Anthony Burzillo <burz@burznest.com>
239 /// @dev Functionality to allow contracts to reference the king contract
240 contract KingOfEthReferencer is GodMode {
241     /// @dev The address of the king contract
242     address public kingOfEthContract;
243 
244     /// @dev Only the king contract can run this
245     modifier onlyKingOfEthContract()
246     {
247         require(kingOfEthContract == msg.sender);
248         _;
249     }
250 
251     /// @dev God can change the king contract
252     /// @param _kingOfEthContract The new address
253     function godSetKingOfEthContract(address _kingOfEthContract)
254         public
255         onlyGod
256     {
257         kingOfEthContract = _kingOfEthContract;
258     }
259 }
260 
261 // File: contracts/KingOfEthBoard.sol
262 
263 /****************************************************
264  *
265  * Copyright 2018 BurzNest LLC. All rights reserved.
266  *
267  * The contents of this file are provided for review
268  * and educational purposes ONLY. You MAY NOT use,
269  * copy, distribute, or modify this software without
270  * explicit written permission from BurzNest LLC.
271  *
272  ****************************************************/
273 
274 pragma solidity ^0.4.24;
275 
276 
277 
278 
279 
280 /// @title King of Eth: Board
281 /// @author Anthony Burzillo <burz@burznest.com>
282 /// @dev Contract for board
283 contract KingOfEthBoard is
284       GodMode
285     , KingOfEthAuctionsReferencer
286     , KingOfEthReferencer
287 {
288     /// @dev x coordinate of the top left corner of the boundary
289     uint public boundX1 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef;
290 
291     /// @dev y coordinate of the top left corner of the boundary
292     uint public boundY1 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffef;
293 
294     /// @dev x coordinate of the bottom right corner of the boundary
295     uint public boundX2 = 0x800000000000000000000000000000000000000000000000000000000000000f;
296 
297     /// @dev y coordinate of the bottom right corner of the boundary
298     uint public boundY2 = 0x800000000000000000000000000000000000000000000000000000000000000f;
299 
300     /// @dev Number used to divide the total number of house locations
301     /// after any expansion to yield the number of auctions that  will be
302     /// available to start for the expansion's duration
303     uint public constant auctionsAvailableDivisor = 10;
304 
305     /// @dev Amount of time the King must wait between increasing the board
306     uint public constant kingTimeBetweenIncrease = 2 weeks;
307 
308     /// @dev Amount of time the Wayfarer must wait between increasing the board
309     uint public constant wayfarerTimeBetweenIncrease = 3 weeks;
310 
311     /// @dev Amount of time that anyone but the King or Wayfarer must wait
312     ///  before increasing the board
313     uint public constant plebTimeBetweenIncrease = 4 weeks;
314 
315     /// @dev The last time the board was increased in size
316     uint public lastIncreaseTime;
317 
318     /// @dev The direction of the next increase
319     uint8 public nextIncreaseDirection;
320 
321     /// @dev The number of auctions that players may choose to start
322     ///  for this expansion
323     uint public auctionsRemaining;
324 
325     constructor() public
326     {
327         // Game is paused as God must start it
328         isPaused = true;
329 
330         // Set the auctions remaining
331         setAuctionsAvailableForBounds();
332     }
333 
334     /// @dev Fired when the board is increased in size
335     event BoardSizeIncreased(
336           address initiator
337         , uint newBoundX1
338         , uint newBoundY1
339         , uint newBoundX2
340         , uint newBoundY2
341         , uint lastIncreaseTime
342         , uint nextIncreaseDirection
343         , uint auctionsRemaining
344     );
345 
346     /// @dev Only the King can run this
347     modifier onlyKing()
348     {
349         require(KingOfEthAbstractInterface(kingOfEthContract).king() == msg.sender);
350         _;
351     }
352 
353     /// @dev Only the Wayfarer can run this
354     modifier onlyWayfarer()
355     {
356         require(KingOfEthAbstractInterface(kingOfEthContract).wayfarer() == msg.sender);
357         _;
358     }
359 
360     /// @dev Set the total auctions available
361     function setAuctionsAvailableForBounds() private
362     {
363         uint boundDiffX = boundX2 - boundX1;
364         uint boundDiffY = boundY2 - boundY1;
365 
366         auctionsRemaining = boundDiffX * boundDiffY / 2 / auctionsAvailableDivisor;
367     }
368 
369     /// @dev Increase the board's size making sure to keep steady at
370     ///  the maximum outer bounds
371     function increaseBoard() private
372     {
373         // The length of increase
374         uint _increaseLength;
375 
376         // If this increase direction is right
377         if(0 == nextIncreaseDirection)
378         {
379             _increaseLength = boundX2 - boundX1;
380             uint _updatedX2 = boundX2 + _increaseLength;
381 
382             // Stay within bounds
383             if(_updatedX2 <= boundX2 || _updatedX2 <= _increaseLength)
384             {
385                 boundX2 = ~uint(0);
386             }
387             else
388             {
389                 boundX2 = _updatedX2;
390             }
391         }
392         // If this increase direction is down
393         else if(1 == nextIncreaseDirection)
394         {
395             _increaseLength = boundY2 - boundY1;
396             uint _updatedY2 = boundY2 + _increaseLength;
397 
398             // Stay within bounds
399             if(_updatedY2 <= boundY2 || _updatedY2 <= _increaseLength)
400             {
401                 boundY2 = ~uint(0);
402             }
403             else
404             {
405                 boundY2 = _updatedY2;
406             }
407         }
408         // If this increase direction is left
409         else if(2 == nextIncreaseDirection)
410         {
411             _increaseLength = boundX2 - boundX1;
412 
413             // Stay within bounds
414             if(boundX1 <= _increaseLength)
415             {
416                 boundX1 = 0;
417             }
418             else
419             {
420                 boundX1 -= _increaseLength;
421             }
422         }
423         // If this increase direction is up
424         else if(3 == nextIncreaseDirection)
425         {
426             _increaseLength = boundY2 - boundY1;
427 
428             // Stay within bounds
429             if(boundY1 <= _increaseLength)
430             {
431                 boundY1 = 0;
432             }
433             else
434             {
435                 boundY1 -= _increaseLength;
436             }
437         }
438 
439         // The last increase time is now
440         lastIncreaseTime = now;
441 
442         // Set the next increase direction
443         nextIncreaseDirection = (nextIncreaseDirection + 1) % 4;
444 
445         // Reset the auctions available
446         setAuctionsAvailableForBounds();
447 
448         emit BoardSizeIncreased(
449               msg.sender
450             , boundX1
451             , boundY1
452             , boundX2
453             , boundY2
454             , now
455             , nextIncreaseDirection
456             , auctionsRemaining
457         );
458     }
459 
460     /// @dev God can start the game
461     function godStartGame() public onlyGod
462     {
463         // Reset increase times
464         lastIncreaseTime = now;
465 
466         // Unpause the game
467         godUnpause();
468     }
469 
470     /// @dev The auctions contracts can decrement the number
471     ///  of auctions that are available to be started
472     function auctionsDecrementAuctionsRemaining()
473         public
474         onlyAuctionsContract
475     {
476         auctionsRemaining -= 1;
477     }
478 
479     /// @dev The auctions contracts can increment the number
480     ///  of auctions that are available to be started when
481     ///  an auction ends wihout a winner
482     function auctionsIncrementAuctionsRemaining()
483         public
484         onlyAuctionsContract
485     {
486         auctionsRemaining += 1;
487     }
488 
489     /// @dev The King can increase the board much faster than the plebs
490     function kingIncreaseBoard()
491         public
492         onlyKing
493     {
494         // Require enough time has passed since the last increase
495         require(lastIncreaseTime + kingTimeBetweenIncrease < now);
496 
497         increaseBoard();
498     }
499 
500     /// @dev The Wayfarer can increase the board faster than the plebs
501     function wayfarerIncreaseBoard()
502         public
503         onlyWayfarer
504     {
505         // Require enough time has passed since the last increase
506         require(lastIncreaseTime + wayfarerTimeBetweenIncrease < now);
507 
508         increaseBoard();
509     }
510 
511     /// @dev Any old pleb can increase the board
512     function plebIncreaseBoard() public
513     {
514         // Require enough time has passed since the last increase
515         require(lastIncreaseTime + plebTimeBetweenIncrease < now);
516 
517         increaseBoard();
518     }
519 }
520 
521 // File: contracts/KingOfEthBoardReferencer.sol
522 
523 /****************************************************
524  *
525  * Copyright 2018 BurzNest LLC. All rights reserved.
526  *
527  * The contents of this file are provided for review
528  * and educational purposes ONLY. You MAY NOT use,
529  * copy, distribute, or modify this software without
530  * explicit written permission from BurzNest LLC.
531  *
532  ****************************************************/
533 
534 pragma solidity ^0.4.24;
535 
536 
537 /// @title King of Eth: Board Referencer
538 /// @author Anthony Burzillo <burz@burznest.com>
539 /// @dev Functionality to allow contracts to reference the board contract
540 contract KingOfEthBoardReferencer is GodMode {
541     /// @dev The address of the board contract
542     address public boardContract;
543 
544     /// @dev Only the board contract can run this
545     modifier onlyBoardContract()
546     {
547         require(boardContract == msg.sender);
548         _;
549     }
550 
551     /// @dev God can change the board contract
552     /// @param _boardContract The new address
553     function godSetBoardContract(address _boardContract)
554         public
555         onlyGod
556     {
557         boardContract = _boardContract;
558     }
559 }
560 
561 // File: contracts/KingOfEthHousesAbstractInterface.sol
562 
563 /****************************************************
564  *
565  * Copyright 2018 BurzNest LLC. All rights reserved.
566  *
567  * The contents of this file are provided for review
568  * and educational purposes ONLY. You MAY NOT use,
569  * copy, distribute, or modify this software without
570  * explicit written permission from BurzNest LLC.
571  *
572  ****************************************************/
573 
574 pragma solidity ^0.4.24;
575 
576 /// @title King of Eth: Houses Abstract Interface
577 /// @author Anthony Burzillo <burz@burznest.com>
578 /// @dev Abstract interface contract for houses
579 contract KingOfEthHousesAbstractInterface {
580     /// @dev Get the owner of the house at some location
581     /// @param _x The x coordinate of the house
582     /// @param _y The y coordinate of the house
583     /// @return The address of the owner
584     function ownerOf(uint _x, uint _y) public view returns(address);
585 
586     /// @dev Get the level of the house at some location
587     /// @param _x The x coordinate of the house
588     /// @param _y The y coordinate of the house
589     /// @return The level of the house
590     function level(uint _x, uint _y) public view returns(uint8);
591 
592     /// @dev The auctions contracts can set the owner of a house after an auction
593     /// @param _x The x coordinate of the house
594     /// @param _y The y coordinate of the house
595     /// @param _owner The new owner of the house
596     function auctionsSetOwner(uint _x, uint _y, address _owner) public;
597 
598     /// @dev The house realty contract can transfer house ownership
599     /// @param _x The x coordinate of the house
600     /// @param _y The y coordinate of the house
601     /// @param _from The previous owner of house
602     /// @param _to The new owner of house
603     function houseRealtyTransferOwnership(
604           uint _x
605         , uint _y
606         , address _from
607         , address _to
608     ) public;
609 }
610 
611 // File: contracts/KingOfEthHousesReferencer.sol
612 
613 /****************************************************
614  *
615  * Copyright 2018 BurzNest LLC. All rights reserved.
616  *
617  * The contents of this file are provided for review
618  * and educational purposes ONLY. You MAY NOT use,
619  * copy, distribute, or modify this software without
620  * explicit written permission from BurzNest LLC.
621  *
622  ****************************************************/
623 
624 pragma solidity ^0.4.24;
625 
626 
627 /// @title King of Eth: Houses Referencer
628 /// @author Anthony Burzillo <burz@burznest.com>
629 /// @dev Provides functionality to reference the houses contract
630 contract KingOfEthHousesReferencer is GodMode {
631     /// @dev The houses contract's address
632     address public housesContract;
633 
634     /// @dev Only the houses contract can run this function
635     modifier onlyHousesContract()
636     {
637         require(housesContract == msg.sender);
638         _;
639     }
640 
641     /// @dev God can set the realty contract
642     /// @param _housesContract The new address
643     function godSetHousesContract(address _housesContract)
644         public
645         onlyGod
646     {
647         housesContract = _housesContract;
648     }
649 }
650 
651 // File: contracts/KingOfEthEthExchangeReferencer.sol
652 
653 /****************************************************
654  *
655  * Copyright 2018 BurzNest LLC. All rights reserved.
656  *
657  * The contents of this file are provided for review
658  * and educational purposes ONLY. You MAY NOT use,
659  * copy, distribute, or modify this software without
660  * explicit written permission from BurzNest LLC.
661  *
662  ****************************************************/
663 
664 pragma solidity ^0.4.24;
665 
666 
667 /// @title King of Eth: Resource-to-ETH Exchange Referencer
668 /// @author Anthony Burzillo <burz@burznest.com>
669 /// @dev Provides functionality to interface with the
670 ///  ETH exchange contract
671 contract KingOfEthEthExchangeReferencer is GodMode {
672     /// @dev Address of the ETH exchange contract
673     address public ethExchangeContract;
674 
675     /// @dev Only the ETH exchange contract may run this function
676     modifier onlyEthExchangeContract()
677     {
678         require(ethExchangeContract == msg.sender);
679         _;
680     }
681 
682     /// @dev God may set the ETH exchange contract's address
683     /// @dev _ethExchangeContract The new address
684     function godSetEthExchangeContract(address _ethExchangeContract)
685         public
686         onlyGod
687     {
688         ethExchangeContract = _ethExchangeContract;
689     }
690 }
691 
692 // File: contracts/KingOfEthResourceExchangeReferencer.sol
693 
694 /****************************************************
695  *
696  * Copyright 2018 BurzNest LLC. All rights reserved.
697  *
698  * The contents of this file are provided for review
699  * and educational purposes ONLY. You MAY NOT use,
700  * copy, distribute, or modify this software without
701  * explicit written permission from BurzNest LLC.
702  *
703  ****************************************************/
704 
705 pragma solidity ^0.4.24;
706 
707 
708 /// @title King of Eth: Resource-to-Resource Exchange Referencer
709 /// @author Anthony Burzillo <burz@burznest.com>
710 /// @dev Provides functionality to interface with the
711 ///  resource-to-resource contract
712 contract KingOfEthResourceExchangeReferencer is GodMode {
713     /// @dev Address of the resource-to-resource contract
714     address public resourceExchangeContract;
715 
716     /// @dev Only the resource-to-resource contract may run this function
717     modifier onlyResourceExchangeContract()
718     {
719         require(resourceExchangeContract == msg.sender);
720         _;
721     }
722 
723     /// @dev God may set the resource-to-resource contract's address
724     /// @dev _resourceExchangeContract The new address
725     function godSetResourceExchangeContract(address _resourceExchangeContract)
726         public
727         onlyGod
728     {
729         resourceExchangeContract = _resourceExchangeContract;
730     }
731 }
732 
733 // File: contracts/KingOfEthExchangeReferencer.sol
734 
735 /****************************************************
736  *
737  * Copyright 2018 BurzNest LLC. All rights reserved.
738  *
739  * The contents of this file are provided for review
740  * and educational purposes ONLY. You MAY NOT use,
741  * copy, distribute, or modify this software without
742  * explicit written permission from BurzNest LLC.
743  *
744  ****************************************************/
745 
746 pragma solidity ^0.4.24;
747 
748 
749 
750 
751 /// @title King of Eth: Exchange Referencer
752 /// @author Anthony Burzillo <burz@burznest.com>
753 /// @dev Provides functionality to interface with the exchange contract
754 contract KingOfEthExchangeReferencer is
755       GodMode
756     , KingOfEthEthExchangeReferencer
757     , KingOfEthResourceExchangeReferencer
758 {
759     /// @dev Only one of the exchange contracts may
760     ///  run this function
761     modifier onlyExchangeContract()
762     {
763         require(
764                ethExchangeContract == msg.sender
765             || resourceExchangeContract == msg.sender
766         );
767         _;
768     }
769 }
770 
771 // File: contracts/KingOfEthResourcesInterfaceReferencer.sol
772 
773 /****************************************************
774  *
775  * Copyright 2018 BurzNest LLC. All rights reserved.
776  *
777  * The contents of this file are provided for review
778  * and educational purposes ONLY. You MAY NOT use,
779  * copy, distribute, or modify this software without
780  * explicit written permission from BurzNest LLC.
781  *
782  ****************************************************/
783 
784 pragma solidity ^0.4.24;
785 
786 
787 /// @title King of Eth: Resources Interface Referencer
788 /// @author Anthony Burzillo <burz@burznest.com>
789 /// @dev Provides functionality to reference the resource interface contract
790 contract KingOfEthResourcesInterfaceReferencer is GodMode {
791     /// @dev The interface contract's address
792     address public interfaceContract;
793 
794     /// @dev Only the interface contract can run this function
795     modifier onlyInterfaceContract()
796     {
797         require(interfaceContract == msg.sender);
798         _;
799     }
800 
801     /// @dev God can set the realty contract
802     /// @param _interfaceContract The new address
803     function godSetInterfaceContract(address _interfaceContract)
804         public
805         onlyGod
806     {
807         interfaceContract = _interfaceContract;
808     }
809 }
810 
811 // File: contracts/KingOfEthResource.sol
812 
813 /****************************************************
814  *
815  * Copyright 2018 BurzNest LLC. All rights reserved.
816  *
817  * The contents of this file are provided for review
818  * and educational purposes ONLY. You MAY NOT use,
819  * copy, distribute, or modify this software without
820  * explicit written permission from BurzNest LLC.
821  *
822  ****************************************************/
823 
824 pragma solidity ^0.4.24;
825 
826 
827 
828 /// @title ERC20Interface
829 /// @dev ERC20 token interface contract
830 contract ERC20Interface {
831     function totalSupply() public constant returns(uint);
832     function balanceOf(address _tokenOwner) public constant returns(uint balance);
833     function allowance(address _tokenOwner, address _spender) public constant returns(uint remaining);
834     function transfer(address _to, uint _tokens) public returns(bool success);
835     function approve(address _spender, uint _tokens) public returns(bool success);
836     function transferFrom(address _from, address _to, uint _tokens) public returns(bool success);
837 
838     event Transfer(address indexed from, address indexed to, uint tokens);
839     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
840 }
841 
842 /// @title King of Eth: Resource
843 /// @author Anthony Burzillo <burz@burznest.com>
844 /// @dev Common contract implementation for resources
845 contract KingOfEthResource is
846       ERC20Interface
847     , GodMode
848     , KingOfEthResourcesInterfaceReferencer
849 {
850     /// @dev Current resource supply
851     uint public resourceSupply;
852 
853     /// @dev ERC20 token's decimals
854     uint8 public constant decimals = 0;
855 
856     /// @dev mapping of addresses to holdings
857     mapping (address => uint) holdings;
858 
859     /// @dev mapping of addresses to amount of tokens frozen
860     mapping (address => uint) frozenHoldings;
861 
862     /// @dev mapping of addresses to mapping of allowances for an address
863     mapping (address => mapping (address => uint)) allowances;
864 
865     /// @dev ERC20 total supply
866     /// @return The current total supply of the resource
867     function totalSupply()
868         public
869         constant
870         returns(uint)
871     {
872         return resourceSupply;
873     }
874 
875     /// @dev ERC20 balance of address
876     /// @param _tokenOwner The address to look up
877     /// @return The balance of the address
878     function balanceOf(address _tokenOwner)
879         public
880         constant
881         returns(uint balance)
882     {
883         return holdings[_tokenOwner];
884     }
885 
886     /// @dev Total resources frozen for an address
887     /// @param _tokenOwner The address to look up
888     /// @return The frozen balance of the address
889     function frozenTokens(address _tokenOwner)
890         public
891         constant
892         returns(uint balance)
893     {
894         return frozenHoldings[_tokenOwner];
895     }
896 
897     /// @dev The allowance for a spender on an account
898     /// @param _tokenOwner The account that allows withdrawels
899     /// @param _spender The account that is allowed to withdraw
900     /// @return The amount remaining in the allowance
901     function allowance(address _tokenOwner, address _spender)
902         public
903         constant
904         returns(uint remaining)
905     {
906         return allowances[_tokenOwner][_spender];
907     }
908 
909     /// @dev Only run if player has at least some amount of tokens
910     /// @param _owner The owner of the tokens
911     /// @param _tokens The amount of tokens required
912     modifier hasAvailableTokens(address _owner, uint _tokens)
913     {
914         require(holdings[_owner] - frozenHoldings[_owner] >= _tokens);
915         _;
916     }
917 
918     /// @dev Only run if player has at least some amount of tokens frozen
919     /// @param _owner The owner of the tokens
920     /// @param _tokens The amount of frozen tokens required
921     modifier hasFrozenTokens(address _owner, uint _tokens)
922     {
923         require(frozenHoldings[_owner] >= _tokens);
924         _;
925     }
926 
927     /// @dev Set up the exact same state in each resource
928     constructor() public
929     {
930         // God gets 200 to put on exchange
931         holdings[msg.sender] = 200;
932 
933         resourceSupply = 200;
934     }
935 
936     /// @dev The resources interface can burn tokens for building
937     ///  roads or houses
938     /// @param _owner The owner of the tokens
939     /// @param _tokens The amount of tokens to burn
940     function interfaceBurnTokens(address _owner, uint _tokens)
941         public
942         onlyInterfaceContract
943         hasAvailableTokens(_owner, _tokens)
944     {
945         holdings[_owner] -= _tokens;
946 
947         resourceSupply -= _tokens;
948 
949         // Pretend the tokens were sent to 0x0
950         emit Transfer(_owner, 0x0, _tokens);
951     }
952 
953     /// @dev The resources interface contract can mint tokens for houses
954     /// @param _owner The owner of the tokens
955     /// @param _tokens The amount of tokens to burn
956     function interfaceMintTokens(address _owner, uint _tokens)
957         public
958         onlyInterfaceContract
959     {
960         holdings[_owner] += _tokens;
961 
962         resourceSupply += _tokens;
963 
964         // Pretend the tokens were sent from the interface contract
965         emit Transfer(interfaceContract, _owner, _tokens);
966     }
967 
968     /// @dev The interface can freeze tokens
969     /// @param _owner The owner of the tokens
970     /// @param _tokens The amount of tokens to freeze
971     function interfaceFreezeTokens(address _owner, uint _tokens)
972         public
973         onlyInterfaceContract
974         hasAvailableTokens(_owner, _tokens)
975     {
976         frozenHoldings[_owner] += _tokens;
977     }
978 
979     /// @dev The interface can thaw tokens
980     /// @param _owner The owner of the tokens
981     /// @param _tokens The amount of tokens to thaw
982     function interfaceThawTokens(address _owner, uint _tokens)
983         public
984         onlyInterfaceContract
985         hasFrozenTokens(_owner, _tokens)
986     {
987         frozenHoldings[_owner] -= _tokens;
988     }
989 
990     /// @dev The interface can transfer tokens
991     /// @param _from The owner of the tokens
992     /// @param _to The new owner of the tokens
993     /// @param _tokens The amount of tokens to transfer
994     function interfaceTransfer(address _from, address _to, uint _tokens)
995         public
996         onlyInterfaceContract
997     {
998         assert(holdings[_from] >= _tokens);
999 
1000         holdings[_from] -= _tokens;
1001         holdings[_to]   += _tokens;
1002 
1003         emit Transfer(_from, _to, _tokens);
1004     }
1005 
1006     /// @dev The interface can transfer frozend tokens
1007     /// @param _from The owner of the tokens
1008     /// @param _to The new owner of the tokens
1009     /// @param _tokens The amount of frozen tokens to transfer
1010     function interfaceFrozenTransfer(address _from, address _to, uint _tokens)
1011         public
1012         onlyInterfaceContract
1013         hasFrozenTokens(_from, _tokens)
1014     {
1015         // Make sure to deduct the tokens from both the total and frozen amounts
1016         holdings[_from]       -= _tokens;
1017         frozenHoldings[_from] -= _tokens;
1018         holdings[_to]         += _tokens;
1019 
1020         emit Transfer(_from, _to, _tokens);
1021     }
1022 
1023     /// @dev ERC20 transfer
1024     /// @param _to The address to transfer to
1025     /// @param _tokens The amount of tokens to transfer
1026     function transfer(address _to, uint _tokens)
1027         public
1028         hasAvailableTokens(msg.sender, _tokens)
1029         returns(bool success)
1030     {
1031         holdings[_to]        += _tokens;
1032         holdings[msg.sender] -= _tokens;
1033 
1034         emit Transfer(msg.sender, _to, _tokens);
1035 
1036         return true;
1037     }
1038 
1039     /// @dev ERC20 approve
1040     /// @param _spender The address to approve
1041     /// @param _tokens The amount of tokens to approve
1042     function approve(address _spender, uint _tokens)
1043         public
1044         returns(bool success)
1045     {
1046         allowances[msg.sender][_spender] = _tokens;
1047 
1048         emit Approval(msg.sender, _spender, _tokens);
1049 
1050         return true;
1051     }
1052 
1053     /// @dev ERC20 transfer from
1054     /// @param _from The address providing the allowance
1055     /// @param _to The address using the allowance
1056     /// @param _tokens The amount of tokens to transfer
1057     function transferFrom(address _from, address _to, uint _tokens)
1058         public
1059         hasAvailableTokens(_from, _tokens)
1060         returns(bool success)
1061     {
1062         require(allowances[_from][_to] >= _tokens);
1063 
1064         holdings[_to]          += _tokens;
1065         holdings[_from]        -= _tokens;
1066         allowances[_from][_to] -= _tokens;
1067 
1068         emit Transfer(_from, _to, _tokens);
1069 
1070         return true;
1071     }
1072 }
1073 
1074 // File: contracts/KingOfEthResourceType.sol
1075 
1076 /****************************************************
1077  *
1078  * Copyright 2018 BurzNest LLC. All rights reserved.
1079  *
1080  * The contents of this file are provided for review
1081  * and educational purposes ONLY. You MAY NOT use,
1082  * copy, distribute, or modify this software without
1083  * explicit written permission from BurzNest LLC.
1084  *
1085  ****************************************************/
1086 
1087 pragma solidity ^0.4.24;
1088 
1089 /// @title King of Eth: Resource Type
1090 /// @author Anthony Burzillo <burz@burznest.com>
1091 /// @dev Provides enum to choose resource types
1092 contract KingOfEthResourceType {
1093     /// @dev Enum describing a choice of a resource
1094     enum ResourceType {
1095           ETH
1096         , BRONZE
1097         , CORN
1098         , GOLD
1099         , OIL
1100         , ORE
1101         , STEEL
1102         , URANIUM
1103         , WOOD
1104     }
1105 }
1106 
1107 // File: contracts/KingOfEthRoadsReferencer.sol
1108 
1109 /****************************************************
1110  *
1111  * Copyright 2018 BurzNest LLC. All rights reserved.
1112  *
1113  * The contents of this file are provided for review
1114  * and educational purposes ONLY. You MAY NOT use,
1115  * copy, distribute, or modify this software without
1116  * explicit written permission from BurzNest LLC.
1117  *
1118  ****************************************************/
1119 
1120 pragma solidity ^0.4.24;
1121 
1122 
1123 /// @title King of Eth: Roads Referencer
1124 /// @author Anthony Burzillo <burz@burznest.com>
1125 /// @dev Provides functionality to reference the roads contract
1126 contract KingOfEthRoadsReferencer is GodMode {
1127     /// @dev The roads contract's address
1128     address public roadsContract;
1129 
1130     /// @dev Only the roads contract can run this function
1131     modifier onlyRoadsContract()
1132     {
1133         require(roadsContract == msg.sender);
1134         _;
1135     }
1136 
1137     /// @dev God can set the realty contract
1138     /// @param _roadsContract The new address
1139     function godSetRoadsContract(address _roadsContract)
1140         public
1141         onlyGod
1142     {
1143         roadsContract = _roadsContract;
1144     }
1145 }
1146 
1147 // File: contracts/KingOfEthResourcesInterface.sol
1148 
1149 /****************************************************
1150  *
1151  * Copyright 2018 BurzNest LLC. All rights reserved.
1152  *
1153  * The contents of this file are provided for review
1154  * and educational purposes ONLY. You MAY NOT use,
1155  * copy, distribute, or modify this software without
1156  * explicit written permission from BurzNest LLC.
1157  *
1158  ****************************************************/
1159 
1160 pragma solidity ^0.4.24;
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 /// @title King of Eth: Resources Interface
1169 /// @author Anthony Burzillo <burz@burznest.com>
1170 /// @dev Contract for interacting with resources
1171 contract KingOfEthResourcesInterface is
1172       GodMode
1173     , KingOfEthExchangeReferencer
1174     , KingOfEthHousesReferencer
1175     , KingOfEthResourceType
1176     , KingOfEthRoadsReferencer
1177 {
1178     /// @dev Amount of resources a user gets for building a house
1179     uint public constant resourcesPerHouse = 3;
1180 
1181     /// @dev Address for the bronze contract
1182     address public bronzeContract;
1183 
1184     /// @dev Address for the corn contract
1185     address public cornContract;
1186 
1187     /// @dev Address for the gold contract
1188     address public goldContract;
1189 
1190     /// @dev Address for the oil contract
1191     address public oilContract;
1192 
1193     /// @dev Address for the ore contract
1194     address public oreContract;
1195 
1196     /// @dev Address for the steel contract
1197     address public steelContract;
1198 
1199     /// @dev Address for the uranium contract
1200     address public uraniumContract;
1201 
1202     /// @dev Address for the wood contract
1203     address public woodContract;
1204 
1205     /// @param _bronzeContract The address of the bronze contract
1206     /// @param _cornContract The address of the corn contract
1207     /// @param _goldContract The address of the gold contract
1208     /// @param _oilContract The address of the oil contract
1209     /// @param _oreContract The address of the ore contract
1210     /// @param _steelContract The address of the steel contract
1211     /// @param _uraniumContract The address of the uranium contract
1212     /// @param _woodContract The address of the wood contract
1213     constructor(
1214           address _bronzeContract
1215         , address _cornContract
1216         , address _goldContract
1217         , address _oilContract
1218         , address _oreContract
1219         , address _steelContract
1220         , address _uraniumContract
1221         , address _woodContract
1222     )
1223         public
1224     {
1225         bronzeContract  = _bronzeContract;
1226         cornContract    = _cornContract;
1227         goldContract    = _goldContract;
1228         oilContract     = _oilContract;
1229         oreContract     = _oreContract;
1230         steelContract   = _steelContract;
1231         uraniumContract = _uraniumContract;
1232         woodContract    = _woodContract;
1233     }
1234 
1235     /// @dev Return the particular address for a certain resource type
1236     /// @param _type The resource type
1237     /// @return The address for that resource
1238     function contractFor(ResourceType _type)
1239         public
1240         view
1241         returns(address)
1242     {
1243         // ETH does not have a contract
1244         require(ResourceType.ETH != _type);
1245 
1246         if(ResourceType.BRONZE == _type)
1247         {
1248             return bronzeContract;
1249         }
1250         else if(ResourceType.CORN == _type)
1251         {
1252             return cornContract;
1253         }
1254         else if(ResourceType.GOLD == _type)
1255         {
1256             return goldContract;
1257         }
1258         else if(ResourceType.OIL == _type)
1259         {
1260             return oilContract;
1261         }
1262         else if(ResourceType.ORE == _type)
1263         {
1264             return oreContract;
1265         }
1266         else if(ResourceType.STEEL == _type)
1267         {
1268             return steelContract;
1269         }
1270         else if(ResourceType.URANIUM == _type)
1271         {
1272             return uraniumContract;
1273         }
1274         else if(ResourceType.WOOD == _type)
1275         {
1276             return woodContract;
1277         }
1278     }
1279 
1280     /// @dev Determine the resource type of a tile
1281     /// @param _x The x coordinate of the top left corner of the tile
1282     /// @param _y The y coordinate of the top left corner of the tile
1283     function resourceType(uint _x, uint _y)
1284         public
1285         pure
1286         returns(ResourceType resource)
1287     {
1288         uint _seed = (_x + 7777777) ^  _y;
1289 
1290         if(0 == _seed % 97)
1291         {
1292           return ResourceType.URANIUM;
1293         }
1294         else if(0 == _seed % 29)
1295         {
1296           return ResourceType.OIL;
1297         }
1298         else if(0 == _seed % 23)
1299         {
1300           return ResourceType.STEEL;
1301         }
1302         else if(0 == _seed % 17)
1303         {
1304           return ResourceType.GOLD;
1305         }
1306         else if(0 == _seed % 11)
1307         {
1308           return ResourceType.BRONZE;
1309         }
1310         else if(0 == _seed % 5)
1311         {
1312           return ResourceType.WOOD;
1313         }
1314         else if(0 == _seed % 2)
1315         {
1316           return ResourceType.CORN;
1317         }
1318         else
1319         {
1320           return ResourceType.ORE;
1321         }
1322     }
1323 
1324     /// @dev Lookup the number of resource points for a certain
1325     ///  player
1326     /// @param _player The player in question
1327     function lookupResourcePoints(address _player)
1328         public
1329         view
1330         returns(uint)
1331     {
1332         uint result = 0;
1333 
1334         result += KingOfEthResource(bronzeContract).balanceOf(_player);
1335         result += KingOfEthResource(goldContract).balanceOf(_player)    * 3;
1336         result += KingOfEthResource(steelContract).balanceOf(_player)   * 6;
1337         result += KingOfEthResource(oilContract).balanceOf(_player)     * 10;
1338         result += KingOfEthResource(uraniumContract).balanceOf(_player) * 44;
1339 
1340         return result;
1341     }
1342 
1343     /// @dev Burn the resources necessary to build a house
1344     /// @param _count the number of houses being built
1345     /// @param _player The player who is building the house
1346     function burnHouseCosts(uint _count, address _player)
1347         public
1348         onlyHousesContract
1349     {
1350         // Costs 2 corn per house
1351         KingOfEthResource(contractFor(ResourceType.CORN)).interfaceBurnTokens(
1352               _player
1353             , 2 * _count
1354         );
1355 
1356         // Costs 2 ore per house
1357         KingOfEthResource(contractFor(ResourceType.ORE)).interfaceBurnTokens(
1358               _player
1359             , 2 * _count
1360         );
1361 
1362         // Costs 1 wood per house
1363         KingOfEthResource(contractFor(ResourceType.WOOD)).interfaceBurnTokens(
1364               _player
1365             , _count
1366         );
1367     }
1368 
1369     /// @dev Burn the costs of upgrading a house
1370     /// @param _currentLevel The level of the house before the upgrade
1371     /// @param _player The player who is upgrading the house
1372     function burnUpgradeCosts(uint8 _currentLevel, address _player)
1373         public
1374         onlyHousesContract
1375     {
1376         // Do not allow upgrades after level 4
1377         require(5 > _currentLevel);
1378 
1379         // Burn the base house cost
1380         burnHouseCosts(1, _player);
1381 
1382         if(0 == _currentLevel)
1383         {
1384             // Level 1 costs bronze
1385             KingOfEthResource(contractFor(ResourceType.BRONZE)).interfaceBurnTokens(
1386                   _player
1387                 , 1
1388             );
1389         }
1390         else if(1 == _currentLevel)
1391         {
1392             // Level 2 costs gold
1393             KingOfEthResource(contractFor(ResourceType.GOLD)).interfaceBurnTokens(
1394                   _player
1395                 , 1
1396             );
1397         }
1398         else if(2 == _currentLevel)
1399         {
1400             // Level 3 costs steel
1401             KingOfEthResource(contractFor(ResourceType.STEEL)).interfaceBurnTokens(
1402                   _player
1403                 , 1
1404             );
1405         }
1406         else if(3 == _currentLevel)
1407         {
1408             // Level 4 costs oil
1409             KingOfEthResource(contractFor(ResourceType.OIL)).interfaceBurnTokens(
1410                   _player
1411                 , 1
1412             );
1413         }
1414         else if(4 == _currentLevel)
1415         {
1416             // Level 5 costs uranium
1417             KingOfEthResource(contractFor(ResourceType.URANIUM)).interfaceBurnTokens(
1418                   _player
1419                 , 1
1420             );
1421         }
1422     }
1423 
1424     /// @dev Mint resources for a house and distribute all to its owner
1425     /// @param _owner The owner of the house
1426     /// @param _x The x coordinate of the house
1427     /// @param _y The y coordinate of the house
1428     /// @param _y The y coordinate of the house
1429     /// @param _level The new level of the house
1430     function distributeResources(address _owner, uint _x, uint _y, uint8 _level)
1431         public
1432         onlyHousesContract
1433     {
1434         // Calculate the count of resources for this level
1435         uint _count = resourcesPerHouse * uint(_level + 1);
1436 
1437         // Distribute the top left resource
1438         KingOfEthResource(contractFor(resourceType(_x - 1, _y - 1))).interfaceMintTokens(
1439             _owner
1440           , _count
1441         );
1442 
1443         // Distribute the top right resource
1444         KingOfEthResource(contractFor(resourceType(_x, _y - 1))).interfaceMintTokens(
1445             _owner
1446           , _count
1447         );
1448 
1449         // Distribute the bottom right resource
1450         KingOfEthResource(contractFor(resourceType(_x, _y))).interfaceMintTokens(
1451             _owner
1452           , _count
1453         );
1454 
1455         // Distribute the bottom left resource
1456         KingOfEthResource(contractFor(resourceType(_x - 1, _y))).interfaceMintTokens(
1457             _owner
1458           , _count
1459         );
1460     }
1461 
1462     /// @dev Burn the costs necessary to build a road
1463     /// @param _length The length of the road
1464     /// @param _player The player who is building the house
1465     function burnRoadCosts(uint _length, address _player)
1466         public
1467         onlyRoadsContract
1468     {
1469         // Burn corn
1470         KingOfEthResource(cornContract).interfaceBurnTokens(
1471               _player
1472             , _length
1473         );
1474 
1475         // Burn ore
1476         KingOfEthResource(oreContract).interfaceBurnTokens(
1477               _player
1478             , _length
1479         );
1480     }
1481 
1482     /// @dev The exchange can freeze tokens
1483     /// @param _type The type of resource
1484     /// @param _owner The owner of the tokens
1485     /// @param _tokens The amount of tokens to freeze
1486     function exchangeFreezeTokens(ResourceType _type, address _owner, uint _tokens)
1487         public
1488         onlyExchangeContract
1489     {
1490         KingOfEthResource(contractFor(_type)).interfaceFreezeTokens(_owner, _tokens);
1491     }
1492 
1493     /// @dev The exchange can thaw tokens
1494     /// @param _type The type of resource
1495     /// @param _owner The owner of the tokens
1496     /// @param _tokens The amount of tokens to thaw
1497     function exchangeThawTokens(ResourceType _type, address _owner, uint _tokens)
1498         public
1499         onlyExchangeContract
1500     {
1501         KingOfEthResource(contractFor(_type)).interfaceThawTokens(_owner, _tokens);
1502     }
1503 
1504     /// @dev The exchange can transfer tokens
1505     /// @param _type The type of resource
1506     /// @param _from The owner of the tokens
1507     /// @param _to The new owner of the tokens
1508     /// @param _tokens The amount of tokens to transfer
1509     function exchangeTransfer(ResourceType _type, address _from, address _to, uint _tokens)
1510         public
1511         onlyExchangeContract
1512     {
1513         KingOfEthResource(contractFor(_type)).interfaceTransfer(_from, _to, _tokens);
1514     }
1515 
1516     /// @dev The exchange can transfer frozend tokens
1517     /// @param _type The type of resource
1518     /// @param _from The owner of the tokens
1519     /// @param _to The new owner of the tokens
1520     /// @param _tokens The amount of frozen tokens to transfer
1521     function exchangeFrozenTransfer(ResourceType _type, address _from, address _to, uint _tokens)
1522         public
1523         onlyExchangeContract
1524     {
1525         KingOfEthResource(contractFor(_type)).interfaceFrozenTransfer(_from, _to, _tokens);
1526     }
1527 }
1528 
1529 // File: contracts/KingOfEthRoadsAbstractInterface.sol
1530 
1531 /****************************************************
1532  *
1533  * Copyright 2018 BurzNest LLC. All rights reserved.
1534  *
1535  * The contents of this file are provided for review
1536  * and educational purposes ONLY. You MAY NOT use,
1537  * copy, distribute, or modify this software without
1538  * explicit written permission from BurzNest LLC.
1539  *
1540  ****************************************************/
1541 
1542 pragma solidity ^0.4.24;
1543 
1544 /// @title King of Eth: Roads Abstract Interface
1545 /// @author Anthony Burzillo <burz@burznest.com>
1546 /// @dev Abstract interface contract for roads
1547 contract KingOfEthRoadsAbstractInterface {
1548     /// @dev Get the owner of the road at some location
1549     /// @param _x The x coordinate of the road
1550     /// @param _y The y coordinate of the road
1551     /// @param _direction The direction of the road (either
1552     ///  0 for right or 1 for down)
1553     /// @return The address of the owner
1554     function ownerOf(uint _x, uint _y, uint8 _direction) public view returns(address);
1555 
1556     /// @dev The road realty contract can transfer road ownership
1557     /// @param _x The x coordinate of the road
1558     /// @param _y The y coordinate of the road
1559     /// @param _direction The direction of the road
1560     /// @param _from The previous owner of road
1561     /// @param _to The new owner of road
1562     function roadRealtyTransferOwnership(
1563           uint _x
1564         , uint _y
1565         , uint8 _direction
1566         , address _from
1567         , address _to
1568     ) public;
1569 }
1570 
1571 // File: contracts/KingOfEthRoadRealty.sol
1572 
1573 /****************************************************
1574  *
1575  * Copyright 2018 BurzNest LLC. All rights reserved.
1576  *
1577  * The contents of this file are provided for review
1578  * and educational purposes ONLY. You MAY NOT use,
1579  * copy, distribute, or modify this software without
1580  * explicit written permission from BurzNest LLC.
1581  *
1582  ****************************************************/
1583 
1584 pragma solidity ^0.4.24;
1585 
1586 
1587 
1588 
1589 
1590 
1591 /// @title King of Eth: Road Realty
1592 /// @author Anthony Burzillo <burz@burznest.com>
1593 /// @dev Contract for controlling sales of roads
1594 contract KingOfEthRoadRealty is
1595       GodMode
1596     , KingOfEthReferencer
1597     , KingOfEthRoadsReferencer
1598 {
1599     /// @dev The number that divides the amount payed for any sale to produce
1600     ///  the amount payed in taxes
1601     uint public constant taxDivisor = 25;
1602 
1603     /// @dev Mapping from the x, y coordinates and the direction (0 for right and
1604     ///  1 for down) of a road to the  current sale price (0 if there is no sale)
1605     mapping (uint => mapping (uint => uint[2])) roadPrices;
1606 
1607     /// @dev Fired when there is a new road for sale
1608     event RoadForSale(
1609           uint x
1610         , uint y
1611         , uint8 direction
1612         , address owner
1613         , uint amount
1614     );
1615 
1616     /// @dev Fired when the owner changes the price of a road
1617     event RoadPriceChanged(
1618           uint x
1619         , uint y
1620         , uint8 direction
1621         , uint amount
1622     );
1623 
1624     /// @dev Fired when a road is sold
1625     event RoadSold(
1626           uint x
1627         , uint y
1628         , uint8 direction
1629         , address from
1630         , address to
1631         , uint amount
1632     );
1633 
1634     /// @dev Fired when the sale for a road is cancelled by the owner
1635     event RoadSaleCancelled(
1636           uint x
1637         , uint y
1638         , uint8 direction
1639         , address owner
1640     );
1641 
1642     /// @dev Only the owner of the road at a location can run this
1643     /// @param _x The x coordinate of the road
1644     /// @param _y The y coordinate of the road
1645     /// @param _direction The direction of the road
1646     modifier onlyRoadOwner(uint _x, uint _y, uint8 _direction)
1647     {
1648         require(KingOfEthRoadsAbstractInterface(roadsContract).ownerOf(_x, _y, _direction) == msg.sender);
1649         _;
1650     }
1651 
1652     /// @dev This can only be run if there is *not* an existing sale for a road
1653     ///  at a location
1654     /// @param _x The x coordinate of the road
1655     /// @param _y The y coordinate of the road
1656     /// @param _direction The direction of the road
1657     modifier noExistingRoadSale(uint _x, uint _y, uint8 _direction)
1658     {
1659         require(0 == roadPrices[_x][_y][_direction]);
1660         _;
1661     }
1662 
1663     /// @dev This can only be run if there is an existing sale for a house
1664     ///  at a location
1665     /// @param _x The x coordinate of the road
1666     /// @param _y The y coordinate of the road
1667     /// @param _direction The direction of the road
1668     modifier existingRoadSale(uint _x, uint _y, uint8 _direction)
1669     {
1670         require(0 != roadPrices[_x][_y][_direction]);
1671         _;
1672     }
1673 
1674     /// @param _kingOfEthContract The address of the king contract
1675     constructor(address _kingOfEthContract) public
1676     {
1677         kingOfEthContract = _kingOfEthContract;
1678     }
1679 
1680     /// @dev The roads contract can cancel a sale when a road is transfered
1681     ///  to another player
1682     /// @param _x The x coordinate of the road
1683     /// @param _y The y coordinate of the road
1684     /// @param _direction The direction of the road
1685     function roadsCancelRoadSale(uint _x, uint _y, uint8 _direction)
1686         public
1687         onlyRoadsContract
1688     {
1689         // If there is indeed a sale
1690         if(0 != roadPrices[_x][_y][_direction])
1691         {
1692             // Cancel the sale
1693             roadPrices[_x][_y][_direction] = 0;
1694 
1695             emit RoadSaleCancelled(_x, _y, _direction, msg.sender);
1696         }
1697     }
1698 
1699     /// @dev The owner of a road can start a sale
1700     /// @param _x The x coordinate of the road
1701     /// @param _y The y coordinate of the road
1702     /// @param _direction The direction of the road
1703     /// @param _askingPrice The price that must be payed by another player
1704     ///  to purchase the road
1705     function startRoadSale(
1706           uint _x
1707         , uint _y
1708         , uint8 _direction
1709         , uint _askingPrice
1710     )
1711         public
1712         notPaused
1713         onlyRoadOwner(_x, _y, _direction)
1714         noExistingRoadSale(_x, _y, _direction)
1715     {
1716         // Require that the price is at least 0
1717         require(0 != _askingPrice);
1718 
1719         // Record the price
1720         roadPrices[_x][_y][_direction] = _askingPrice;
1721 
1722         emit RoadForSale(_x, _y, _direction, msg.sender, _askingPrice);
1723     }
1724 
1725     /// @dev The owner of a road can change the price of a sale
1726     /// @param _x The x coordinate of the road
1727     /// @param _y The y coordinate of the road
1728     /// @param _direction The direction of the road
1729     /// @param _askingPrice The new price that must be payed by another
1730     ///  player to purchase the road
1731     function changeRoadPrice(
1732           uint _x
1733         , uint _y
1734         , uint8 _direction
1735         , uint _askingPrice
1736     )
1737         public
1738         notPaused
1739         onlyRoadOwner(_x, _y, _direction)
1740         existingRoadSale(_x, _y, _direction)
1741     {
1742         // Require that the price is at least 0
1743         require(0 != _askingPrice);
1744 
1745         // Record the price
1746         roadPrices[_x][_y][_direction] = _askingPrice;
1747 
1748         emit RoadPriceChanged(_x, _y, _direction, _askingPrice);
1749     }
1750 
1751     /// @dev Anyone can purchase a road as long as the sale exists
1752     /// @param _x The x coordinate of the road
1753     /// @param _y The y coordinate of the road
1754     /// @param _direction The direction of the road
1755     function purchaseRoad(uint _x, uint _y, uint8 _direction)
1756         public
1757         payable
1758         notPaused
1759         existingRoadSale(_x, _y, _direction)
1760     {
1761         // Require that the exact price was paid
1762         require(roadPrices[_x][_y][_direction] == msg.value);
1763 
1764         // End the sale
1765         roadPrices[_x][_y][_direction] = 0;
1766 
1767         // Calculate the taxes to be paid
1768         uint taxCut = msg.value / taxDivisor;
1769 
1770         // Pay the taxes
1771         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(taxCut)();
1772 
1773         KingOfEthRoadsAbstractInterface _roadsContract = KingOfEthRoadsAbstractInterface(roadsContract);
1774 
1775         // Determine the previous owner
1776         address _oldOwner = _roadsContract.ownerOf(_x, _y, _direction);
1777 
1778         // Send the buyer the house
1779         _roadsContract.roadRealtyTransferOwnership(
1780               _x
1781             , _y
1782             , _direction
1783             , _oldOwner
1784             , msg.sender
1785         );
1786 
1787         // Send the previous owner his share
1788         _oldOwner.transfer(msg.value - taxCut);
1789 
1790         emit RoadSold(
1791               _x
1792             , _y
1793             , _direction
1794             , _oldOwner
1795             , msg.sender
1796             , msg.value
1797         );
1798     }
1799 
1800     /// @dev The owner of a road can cancel a sale
1801     /// @param _x The x coordinate of the road
1802     /// @param _y The y coordinate of the road
1803     /// @param _direction The direction of the road
1804     function cancelRoadSale(uint _x, uint _y, uint8 _direction)
1805         public
1806         notPaused
1807         onlyRoadOwner(_x, _y, _direction)
1808         existingRoadSale(_x, _y, _direction)
1809     {
1810         // Cancel the sale
1811         roadPrices[_x][_y][_direction] = 0;
1812 
1813         emit RoadSaleCancelled(_x, _y, _direction, msg.sender);
1814     }
1815 }
1816 
1817 // File: contracts/KingOfEthRoadRealtyReferencer.sol
1818 
1819 /****************************************************
1820  *
1821  * Copyright 2018 BurzNest LLC. All rights reserved.
1822  *
1823  * The contents of this file are provided for review
1824  * and educational purposes ONLY. You MAY NOT use,
1825  * copy, distribute, or modify this software without
1826  * explicit written permission from BurzNest LLC.
1827  *
1828  ****************************************************/
1829 
1830 pragma solidity ^0.4.24;
1831 
1832 
1833 /// @title King of Eth: Road Realty Referencer
1834 /// @author Anthony Burzillo <burz@burznest.com>
1835 /// @dev Provides functionality to reference the road realty contract
1836 contract KingOfEthRoadRealtyReferencer is GodMode {
1837     /// @dev The realty contract's address
1838     address public roadRealtyContract;
1839 
1840     /// @dev Only the road realty contract can run this function
1841     modifier onlyRoadRealtyContract()
1842     {
1843         require(roadRealtyContract == msg.sender);
1844         _;
1845     }
1846 
1847     /// @dev God can set the road realty contract
1848     /// @param _roadRealtyContract The new address
1849     function godSetRoadRealtyContract(address _roadRealtyContract)
1850         public
1851         onlyGod
1852     {
1853         roadRealtyContract = _roadRealtyContract;
1854     }
1855 }
1856 
1857 // File: contracts/KingOfEthRoads.sol
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
1884 /// @title King of Eth: Roads
1885 /// @author Anthony Burzillo <burz@burznest.com>
1886 /// @dev Contract for roads
1887 contract KingOfEthRoads is
1888       GodMode
1889     , KingOfEthBoardReferencer
1890     , KingOfEthHousesReferencer
1891     , KingOfEthReferencer
1892     , KingOfEthResourcesInterfaceReferencer
1893     , KingOfEthRoadRealtyReferencer
1894     , KingOfEthRoadsAbstractInterface
1895 {
1896     /// @dev ETH cost to build a road
1897     uint public roadCost = 0.0002 ether;
1898 
1899     /// @dev Mapping from the x, y, direction coordinate of the location to its owner
1900     mapping (uint => mapping (uint => address[2])) owners;
1901 
1902     /// @dev Mapping from a players address to his road counts
1903     mapping (address => uint) roadCounts;
1904 
1905     /// @param _boardContract The address of the board contract
1906     /// @param _roadRealtyContract The address of the road realty contract
1907     /// @param _kingOfEthContract The address of the king contract
1908     /// @param _interfaceContract The address of the resources
1909     ///  interface contract
1910     constructor(
1911           address _boardContract
1912         , address _roadRealtyContract
1913         , address _kingOfEthContract
1914         , address _interfaceContract
1915     )
1916         public
1917     {
1918         boardContract      = _boardContract;
1919         roadRealtyContract = _roadRealtyContract;
1920         kingOfEthContract  = _kingOfEthContract;
1921         interfaceContract  = _interfaceContract;
1922     }
1923 
1924     /// @dev Fired when new roads are built
1925     event NewRoads(
1926           address owner
1927         , uint x
1928         , uint y
1929         , uint8 direction
1930         , uint length
1931     );
1932 
1933     /// @dev Fired when a road is sent from one player to another
1934     event SentRoad(
1935           uint x
1936         , uint y
1937         , uint direction
1938         , address from
1939         , address to
1940     );
1941 
1942     /// @dev Get the owner of the road at some location
1943     /// @param _x The x coordinate of the road
1944     /// @param _y The y coordinate of the road
1945     /// @param _direction The direction of the road (either
1946     ///  0 for right or 1 for down)
1947     /// @return The address of the owner
1948     function ownerOf(uint _x, uint _y, uint8 _direction)
1949         public
1950         view
1951         returns(address)
1952     {
1953         // Only 0 or 1 is a valid direction
1954         require(2 > _direction);
1955 
1956         return owners[_x][_y][_direction];
1957     }
1958 
1959     /// @dev Get the number of roads owned by a player
1960     /// @param _player The player's address
1961     /// @return The number of roads
1962     function numberOfRoads(address _player) public view returns(uint)
1963     {
1964         return roadCounts[_player];
1965     }
1966 
1967     /// @dev Only the owner of a road can run this
1968     /// @param _x The x coordinate of the road
1969     /// @param _y The y coordinate of the road
1970     /// @param _direction The direction of the road
1971     modifier onlyRoadOwner(uint _x, uint _y, uint8 _direction)
1972     {
1973         require(owners[_x][_y][_direction] == msg.sender);
1974         _;
1975     }
1976 
1977     /// @dev Build houses to the right
1978     /// @param _x The x coordinate of the starting point of the first road
1979     /// @param _y The y coordinate of the starting point of the first road
1980     /// @param _length The length to build
1981     function buildRight(uint _x, uint _y, uint _length) private
1982     {
1983         // Require that nobody currently owns the road
1984         require(0x0 == owners[_x][_y][0]);
1985 
1986         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
1987 
1988         // Require that either the player owns the house at the
1989         // starting location, the road below it, the road to the
1990         // left of it, or the road above it
1991         address _houseOwner = _housesContract.ownerOf(_x, _y);
1992         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
1993                owners[_x][_y][1] == msg.sender
1994             || owners[_x - 1][_y][0] == msg.sender
1995             || owners[_x][_y - 1][1] == msg.sender
1996         )));
1997 
1998         // Set the new owner
1999         owners[_x][_y][0] = msg.sender;
2000 
2001         for(uint _i = 1; _i < _length; ++_i)
2002         {
2003             // Require that nobody currently owns the road
2004             require(0x0 == owners[_x + _i][_y][0]);
2005 
2006             // Require that either the house location is empty or
2007             // that it is owned by the player
2008             require(
2009                    _housesContract.ownerOf(_x + _i, _y) == 0x0
2010                 || _housesContract.ownerOf(_x + _i, _y) == msg.sender
2011             );
2012 
2013             // Set the new owner
2014             owners[_x + _i][_y][0] = msg.sender;
2015         }
2016     }
2017 
2018     /// @dev Build houses downwards
2019     /// @param _x The x coordinate of the starting point of the first road
2020     /// @param _y The y coordinate of the starting point of the first road
2021     /// @param _length The length to build
2022     function buildDown(uint _x, uint _y, uint _length) private
2023     {
2024         // Require that nobody currently owns the road
2025         require(0x0 == owners[_x][_y][1]);
2026 
2027         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2028 
2029         // Require that either the player owns the house at the
2030         // starting location, the road to the right of it, the road to
2031         // the left of it, or the road above it
2032         address _houseOwner = _housesContract.ownerOf(_x, _y);
2033         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2034                owners[_x][_y][0] == msg.sender
2035             || owners[_x - 1][_y][0] == msg.sender
2036             || owners[_x][_y - 1][1] == msg.sender
2037         )));
2038 
2039         // Set the new owner
2040         owners[_x][_y][1] = msg.sender;
2041 
2042         for(uint _i = 1; _i < _length; ++_i)
2043         {
2044             // Require that nobody currently owns the road
2045             require(0x0 == owners[_x][_y + _i][1]);
2046 
2047             // Require that either the house location is empty or
2048             // that it is owned by the player
2049             require(
2050                    _housesContract.ownerOf(_x, _y + _i) == 0x0
2051                 || _housesContract.ownerOf(_x, _y + _i) == msg.sender
2052             );
2053 
2054             // Set the new owner
2055             owners[_x][_y + _i][1] = msg.sender;
2056         }
2057     }
2058 
2059     /// @dev Build houses to the left
2060     /// @param _x The x coordinate of the starting point of the first road
2061     /// @param _y The y coordinate of the starting point of the first road
2062     /// @param _length The length to build
2063     function buildLeft(uint _x, uint _y, uint _length) private
2064     {
2065         // Require that nobody currently owns the road
2066         require(0x0 == owners[_x - 1][_y][0]);
2067 
2068         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2069 
2070         // Require that either the player owns the house at the
2071         // starting location, the road to the right of it, the road
2072         // below it, or the road above it
2073         address _houseOwner = _housesContract.ownerOf(_x, _y);
2074         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2075                owners[_x][_y][0] == msg.sender
2076             || owners[_x][_y][1] == msg.sender
2077             || owners[_x][_y - 1][1] == msg.sender
2078         )));
2079 
2080         // Set the new owner
2081         owners[_x - 1][_y][0] = msg.sender;
2082 
2083         for(uint _i = 1; _i < _length; ++_i)
2084         {
2085             // Require that nobody currently owns the road
2086             require(0x0 == owners[_x - _i - 1][_y][0]);
2087 
2088             // Require that either the house location is empty or
2089             // that it is owned by the player
2090             require(
2091                    _housesContract.ownerOf(_x - _i, _y) == 0x0
2092                 || _housesContract.ownerOf(_x - _i, _y) == msg.sender
2093             );
2094 
2095             // Set the new owner
2096             owners[_x - _i - 1][_y][0] = msg.sender;
2097         }
2098     }
2099 
2100     /// @dev Build houses upwards
2101     /// @param _x The x coordinate of the starting point of the first road
2102     /// @param _y The y coordinate of the starting point of the first road
2103     /// @param _length The length to build
2104     function buildUp(uint _x, uint _y, uint _length) private
2105     {
2106         // Require that nobody currently owns the road
2107         require(0x0 == owners[_x][_y - 1][1]);
2108 
2109         KingOfEthHousesAbstractInterface _housesContract = KingOfEthHousesAbstractInterface(housesContract);
2110 
2111         // Require that either the player owns the house at the
2112         // starting location, the road to the right of it, the road
2113         // below it, or the road to the left of it
2114         address _houseOwner = _housesContract.ownerOf(_x, _y);
2115         require(_houseOwner == msg.sender || (0x0 == _houseOwner && (
2116                owners[_x][_y][0] == msg.sender
2117             || owners[_x][_y][1] == msg.sender
2118             || owners[_x - 1][_y][0] == msg.sender
2119         )));
2120 
2121         // Set the new owner
2122         owners[_x][_y - 1][1] = msg.sender;
2123 
2124         for(uint _i = 1; _i < _length; ++_i)
2125         {
2126             // Require that nobody currently owns the road
2127             require(0x0 == owners[_x][_y - _i - 1][1]);
2128 
2129             // Require that either the house location is empty or
2130             // that it is owned by the player
2131             require(
2132                    _housesContract.ownerOf(_x, _y - _i) == 0x0
2133                 || _housesContract.ownerOf(_x, _y - _i) == msg.sender
2134             );
2135 
2136             // Set the new owner
2137             owners[_x][_y - _i - 1][1] = msg.sender;
2138         }
2139     }
2140 
2141     /// @dev God can change the road cost
2142     /// @param _newRoadCost The new cost of a road
2143     function godChangeRoadCost(uint _newRoadCost)
2144         public
2145         onlyGod
2146     {
2147         roadCost = _newRoadCost;
2148     }
2149 
2150     /// @dev The road realty contract can transfer road ownership
2151     /// @param _x The x coordinate of the road
2152     /// @param _y The y coordinate of the road
2153     /// @param _direction The direction of the road
2154     /// @param _from The previous owner of road
2155     /// @param _to The new owner of road
2156     function roadRealtyTransferOwnership(
2157           uint _x
2158         , uint _y
2159         , uint8 _direction
2160         , address _from
2161         , address _to
2162     )
2163         public
2164         onlyRoadRealtyContract
2165     {
2166         // Assert that the previous owner still has the road
2167         assert(owners[_x][_y][_direction] == _from);
2168 
2169         // Set the new owner
2170         owners[_x][_y][_direction] = _to;
2171 
2172         // Update the road counts
2173         --roadCounts[_from];
2174         ++roadCounts[_to];
2175     }
2176 
2177     /// @dev Build a road in a direction from a location
2178     /// @param _x The x coordinate of the starting location
2179     /// @param _y The y coordinate of the starting location
2180     /// @param _direction The direction to build (right is 0, down is 1,
2181     ///  2 is left, and 3 is up)
2182     /// @param _length The number of roads to build
2183     function buildRoads(
2184           uint _x
2185         , uint _y
2186         , uint8 _direction
2187         , uint _length
2188     )
2189         public
2190         payable
2191     {
2192         // Require at least one road to be built
2193         require(0 < _length);
2194 
2195         // Require that the cost for each road was payed
2196         require(roadCost * _length == msg.value);
2197 
2198         KingOfEthBoard _boardContract = KingOfEthBoard(boardContract);
2199 
2200         // Require that the start is within bounds
2201         require(_boardContract.boundX1() <= _x);
2202         require(_boardContract.boundY1() <= _y);
2203         require(_boardContract.boundX2() > _x);
2204         require(_boardContract.boundY2() > _y);
2205 
2206         // Burn the resource costs for each road
2207         KingOfEthResourcesInterface(interfaceContract).burnRoadCosts(
2208               _length
2209             , msg.sender
2210         );
2211 
2212         // If the direction is right
2213         if(0 == _direction)
2214         {
2215             // Require that the roads will be in bounds
2216             require(_boardContract.boundX2() > _x + _length);
2217 
2218             buildRight(_x, _y, _length);
2219         }
2220         // If the direction is down
2221         else if(1 == _direction)
2222         {
2223             // Require that the roads will be in bounds
2224             require(_boardContract.boundY2() > _y + _length);
2225 
2226             buildDown(_x, _y, _length);
2227         }
2228         // If the direction is left
2229         else if(2 == _direction)
2230         {
2231             // Require that the roads will be in bounds
2232             require(_boardContract.boundX1() < _x - _length - 1);
2233 
2234             buildLeft(_x, _y, _length);
2235         }
2236         // If the direction is up
2237         else if(3 == _direction)
2238         {
2239             // Require that the roads will be in bounds
2240             require(_boardContract.boundY1() < _y - _length - 1);
2241 
2242             buildUp(_x, _y, _length);
2243         }
2244         else
2245         {
2246             // Revert if the direction is invalid
2247             revert();
2248         }
2249 
2250         // Update the number of roads of the player
2251         roadCounts[msg.sender] += _length;
2252 
2253         // Pay taxes
2254         KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(msg.value)();
2255 
2256         emit NewRoads(msg.sender, _x, _y, _direction, _length);
2257     }
2258 
2259     /// @dev Send a road to another player
2260     /// @param _x The x coordinate of the road
2261     /// @param _y The y coordinate of the road
2262     /// @param _direction The direction of the road
2263     /// @param _to The recipient of the road
2264     function sendRoad(uint _x, uint _y, uint8 _direction, address _to)
2265         public
2266         onlyRoadOwner(_x, _y, _direction)
2267     {
2268         // Set the new owner
2269         owners[_x][_y][_direction] = _to;
2270 
2271         // Update road counts
2272         --roadCounts[msg.sender];
2273         ++roadCounts[_to];
2274 
2275         // Cancel any sales that exist
2276         KingOfEthRoadRealty(roadRealtyContract).roadsCancelRoadSale(
2277               _x
2278             , _y
2279             , _direction
2280         );
2281 
2282         emit SentRoad(_x, _y, _direction, msg.sender, _to);
2283     }
2284 }