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
108 // File: contracts/KingOfEthReferencer.sol
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
124 /// @title King of Eth Referencer
125 /// @author Anthony Burzillo <burz@burznest.com>
126 /// @dev Functionality to allow contracts to reference the king contract
127 contract KingOfEthReferencer is GodMode {
128     /// @dev The address of the king contract
129     address public kingOfEthContract;
130 
131     /// @dev Only the king contract can run this
132     modifier onlyKingOfEthContract()
133     {
134         require(kingOfEthContract == msg.sender);
135         _;
136     }
137 
138     /// @dev God can change the king contract
139     /// @param _kingOfEthContract The new address
140     function godSetKingOfEthContract(address _kingOfEthContract)
141         public
142         onlyGod
143     {
144         kingOfEthContract = _kingOfEthContract;
145     }
146 }
147 
148 // File: contracts/KingOfEthEthExchangeReferencer.sol
149 
150 /****************************************************
151  *
152  * Copyright 2018 BurzNest LLC. All rights reserved.
153  *
154  * The contents of this file are provided for review
155  * and educational purposes ONLY. You MAY NOT use,
156  * copy, distribute, or modify this software without
157  * explicit written permission from BurzNest LLC.
158  *
159  ****************************************************/
160 
161 pragma solidity ^0.4.24;
162 
163 
164 /// @title King of Eth: Resource-to-ETH Exchange Referencer
165 /// @author Anthony Burzillo <burz@burznest.com>
166 /// @dev Provides functionality to interface with the
167 ///  ETH exchange contract
168 contract KingOfEthEthExchangeReferencer is GodMode {
169     /// @dev Address of the ETH exchange contract
170     address public ethExchangeContract;
171 
172     /// @dev Only the ETH exchange contract may run this function
173     modifier onlyEthExchangeContract()
174     {
175         require(ethExchangeContract == msg.sender);
176         _;
177     }
178 
179     /// @dev God may set the ETH exchange contract's address
180     /// @dev _ethExchangeContract The new address
181     function godSetEthExchangeContract(address _ethExchangeContract)
182         public
183         onlyGod
184     {
185         ethExchangeContract = _ethExchangeContract;
186     }
187 }
188 
189 // File: contracts/KingOfEthResourceExchangeReferencer.sol
190 
191 /****************************************************
192  *
193  * Copyright 2018 BurzNest LLC. All rights reserved.
194  *
195  * The contents of this file are provided for review
196  * and educational purposes ONLY. You MAY NOT use,
197  * copy, distribute, or modify this software without
198  * explicit written permission from BurzNest LLC.
199  *
200  ****************************************************/
201 
202 pragma solidity ^0.4.24;
203 
204 
205 /// @title King of Eth: Resource-to-Resource Exchange Referencer
206 /// @author Anthony Burzillo <burz@burznest.com>
207 /// @dev Provides functionality to interface with the
208 ///  resource-to-resource contract
209 contract KingOfEthResourceExchangeReferencer is GodMode {
210     /// @dev Address of the resource-to-resource contract
211     address public resourceExchangeContract;
212 
213     /// @dev Only the resource-to-resource contract may run this function
214     modifier onlyResourceExchangeContract()
215     {
216         require(resourceExchangeContract == msg.sender);
217         _;
218     }
219 
220     /// @dev God may set the resource-to-resource contract's address
221     /// @dev _resourceExchangeContract The new address
222     function godSetResourceExchangeContract(address _resourceExchangeContract)
223         public
224         onlyGod
225     {
226         resourceExchangeContract = _resourceExchangeContract;
227     }
228 }
229 
230 // File: contracts/KingOfEthExchangeReferencer.sol
231 
232 /****************************************************
233  *
234  * Copyright 2018 BurzNest LLC. All rights reserved.
235  *
236  * The contents of this file are provided for review
237  * and educational purposes ONLY. You MAY NOT use,
238  * copy, distribute, or modify this software without
239  * explicit written permission from BurzNest LLC.
240  *
241  ****************************************************/
242 
243 pragma solidity ^0.4.24;
244 
245 
246 
247 
248 /// @title King of Eth: Exchange Referencer
249 /// @author Anthony Burzillo <burz@burznest.com>
250 /// @dev Provides functionality to interface with the exchange contract
251 contract KingOfEthExchangeReferencer is
252       GodMode
253     , KingOfEthEthExchangeReferencer
254     , KingOfEthResourceExchangeReferencer
255 {
256     /// @dev Only one of the exchange contracts may
257     ///  run this function
258     modifier onlyExchangeContract()
259     {
260         require(
261                ethExchangeContract == msg.sender
262             || resourceExchangeContract == msg.sender
263         );
264         _;
265     }
266 }
267 
268 // File: contracts/KingOfEthHousesReferencer.sol
269 
270 /****************************************************
271  *
272  * Copyright 2018 BurzNest LLC. All rights reserved.
273  *
274  * The contents of this file are provided for review
275  * and educational purposes ONLY. You MAY NOT use,
276  * copy, distribute, or modify this software without
277  * explicit written permission from BurzNest LLC.
278  *
279  ****************************************************/
280 
281 pragma solidity ^0.4.24;
282 
283 
284 /// @title King of Eth: Houses Referencer
285 /// @author Anthony Burzillo <burz@burznest.com>
286 /// @dev Provides functionality to reference the houses contract
287 contract KingOfEthHousesReferencer is GodMode {
288     /// @dev The houses contract's address
289     address public housesContract;
290 
291     /// @dev Only the houses contract can run this function
292     modifier onlyHousesContract()
293     {
294         require(housesContract == msg.sender);
295         _;
296     }
297 
298     /// @dev God can set the realty contract
299     /// @param _housesContract The new address
300     function godSetHousesContract(address _housesContract)
301         public
302         onlyGod
303     {
304         housesContract = _housesContract;
305     }
306 }
307 
308 // File: contracts/KingOfEthResourcesInterfaceReferencer.sol
309 
310 /****************************************************
311  *
312  * Copyright 2018 BurzNest LLC. All rights reserved.
313  *
314  * The contents of this file are provided for review
315  * and educational purposes ONLY. You MAY NOT use,
316  * copy, distribute, or modify this software without
317  * explicit written permission from BurzNest LLC.
318  *
319  ****************************************************/
320 
321 pragma solidity ^0.4.24;
322 
323 
324 /// @title King of Eth: Resources Interface Referencer
325 /// @author Anthony Burzillo <burz@burznest.com>
326 /// @dev Provides functionality to reference the resource interface contract
327 contract KingOfEthResourcesInterfaceReferencer is GodMode {
328     /// @dev The interface contract's address
329     address public interfaceContract;
330 
331     /// @dev Only the interface contract can run this function
332     modifier onlyInterfaceContract()
333     {
334         require(interfaceContract == msg.sender);
335         _;
336     }
337 
338     /// @dev God can set the realty contract
339     /// @param _interfaceContract The new address
340     function godSetInterfaceContract(address _interfaceContract)
341         public
342         onlyGod
343     {
344         interfaceContract = _interfaceContract;
345     }
346 }
347 
348 // File: contracts/KingOfEthResource.sol
349 
350 /****************************************************
351  *
352  * Copyright 2018 BurzNest LLC. All rights reserved.
353  *
354  * The contents of this file are provided for review
355  * and educational purposes ONLY. You MAY NOT use,
356  * copy, distribute, or modify this software without
357  * explicit written permission from BurzNest LLC.
358  *
359  ****************************************************/
360 
361 pragma solidity ^0.4.24;
362 
363 
364 
365 /// @title ERC20Interface
366 /// @dev ERC20 token interface contract
367 contract ERC20Interface {
368     function totalSupply() public constant returns(uint);
369     function balanceOf(address _tokenOwner) public constant returns(uint balance);
370     function allowance(address _tokenOwner, address _spender) public constant returns(uint remaining);
371     function transfer(address _to, uint _tokens) public returns(bool success);
372     function approve(address _spender, uint _tokens) public returns(bool success);
373     function transferFrom(address _from, address _to, uint _tokens) public returns(bool success);
374 
375     event Transfer(address indexed from, address indexed to, uint tokens);
376     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
377 }
378 
379 /// @title King of Eth: Resource
380 /// @author Anthony Burzillo <burz@burznest.com>
381 /// @dev Common contract implementation for resources
382 contract KingOfEthResource is
383       ERC20Interface
384     , GodMode
385     , KingOfEthResourcesInterfaceReferencer
386 {
387     /// @dev Current resource supply
388     uint public resourceSupply;
389 
390     /// @dev ERC20 token's decimals
391     uint8 public constant decimals = 0;
392 
393     /// @dev mapping of addresses to holdings
394     mapping (address => uint) holdings;
395 
396     /// @dev mapping of addresses to amount of tokens frozen
397     mapping (address => uint) frozenHoldings;
398 
399     /// @dev mapping of addresses to mapping of allowances for an address
400     mapping (address => mapping (address => uint)) allowances;
401 
402     /// @dev ERC20 total supply
403     /// @return The current total supply of the resource
404     function totalSupply()
405         public
406         constant
407         returns(uint)
408     {
409         return resourceSupply;
410     }
411 
412     /// @dev ERC20 balance of address
413     /// @param _tokenOwner The address to look up
414     /// @return The balance of the address
415     function balanceOf(address _tokenOwner)
416         public
417         constant
418         returns(uint balance)
419     {
420         return holdings[_tokenOwner];
421     }
422 
423     /// @dev Total resources frozen for an address
424     /// @param _tokenOwner The address to look up
425     /// @return The frozen balance of the address
426     function frozenTokens(address _tokenOwner)
427         public
428         constant
429         returns(uint balance)
430     {
431         return frozenHoldings[_tokenOwner];
432     }
433 
434     /// @dev The allowance for a spender on an account
435     /// @param _tokenOwner The account that allows withdrawels
436     /// @param _spender The account that is allowed to withdraw
437     /// @return The amount remaining in the allowance
438     function allowance(address _tokenOwner, address _spender)
439         public
440         constant
441         returns(uint remaining)
442     {
443         return allowances[_tokenOwner][_spender];
444     }
445 
446     /// @dev Only run if player has at least some amount of tokens
447     /// @param _owner The owner of the tokens
448     /// @param _tokens The amount of tokens required
449     modifier hasAvailableTokens(address _owner, uint _tokens)
450     {
451         require(holdings[_owner] - frozenHoldings[_owner] >= _tokens);
452         _;
453     }
454 
455     /// @dev Only run if player has at least some amount of tokens frozen
456     /// @param _owner The owner of the tokens
457     /// @param _tokens The amount of frozen tokens required
458     modifier hasFrozenTokens(address _owner, uint _tokens)
459     {
460         require(frozenHoldings[_owner] >= _tokens);
461         _;
462     }
463 
464     /// @dev Set up the exact same state in each resource
465     constructor() public
466     {
467         // God gets 200 to put on exchange
468         holdings[msg.sender] = 200;
469 
470         resourceSupply = 200;
471     }
472 
473     /// @dev The resources interface can burn tokens for building
474     ///  roads or houses
475     /// @param _owner The owner of the tokens
476     /// @param _tokens The amount of tokens to burn
477     function interfaceBurnTokens(address _owner, uint _tokens)
478         public
479         onlyInterfaceContract
480         hasAvailableTokens(_owner, _tokens)
481     {
482         holdings[_owner] -= _tokens;
483 
484         resourceSupply -= _tokens;
485 
486         // Pretend the tokens were sent to 0x0
487         emit Transfer(_owner, 0x0, _tokens);
488     }
489 
490     /// @dev The resources interface contract can mint tokens for houses
491     /// @param _owner The owner of the tokens
492     /// @param _tokens The amount of tokens to burn
493     function interfaceMintTokens(address _owner, uint _tokens)
494         public
495         onlyInterfaceContract
496     {
497         holdings[_owner] += _tokens;
498 
499         resourceSupply += _tokens;
500 
501         // Pretend the tokens were sent from the interface contract
502         emit Transfer(interfaceContract, _owner, _tokens);
503     }
504 
505     /// @dev The interface can freeze tokens
506     /// @param _owner The owner of the tokens
507     /// @param _tokens The amount of tokens to freeze
508     function interfaceFreezeTokens(address _owner, uint _tokens)
509         public
510         onlyInterfaceContract
511         hasAvailableTokens(_owner, _tokens)
512     {
513         frozenHoldings[_owner] += _tokens;
514     }
515 
516     /// @dev The interface can thaw tokens
517     /// @param _owner The owner of the tokens
518     /// @param _tokens The amount of tokens to thaw
519     function interfaceThawTokens(address _owner, uint _tokens)
520         public
521         onlyInterfaceContract
522         hasFrozenTokens(_owner, _tokens)
523     {
524         frozenHoldings[_owner] -= _tokens;
525     }
526 
527     /// @dev The interface can transfer tokens
528     /// @param _from The owner of the tokens
529     /// @param _to The new owner of the tokens
530     /// @param _tokens The amount of tokens to transfer
531     function interfaceTransfer(address _from, address _to, uint _tokens)
532         public
533         onlyInterfaceContract
534     {
535         assert(holdings[_from] >= _tokens);
536 
537         holdings[_from] -= _tokens;
538         holdings[_to]   += _tokens;
539 
540         emit Transfer(_from, _to, _tokens);
541     }
542 
543     /// @dev The interface can transfer frozend tokens
544     /// @param _from The owner of the tokens
545     /// @param _to The new owner of the tokens
546     /// @param _tokens The amount of frozen tokens to transfer
547     function interfaceFrozenTransfer(address _from, address _to, uint _tokens)
548         public
549         onlyInterfaceContract
550         hasFrozenTokens(_from, _tokens)
551     {
552         // Make sure to deduct the tokens from both the total and frozen amounts
553         holdings[_from]       -= _tokens;
554         frozenHoldings[_from] -= _tokens;
555         holdings[_to]         += _tokens;
556 
557         emit Transfer(_from, _to, _tokens);
558     }
559 
560     /// @dev ERC20 transfer
561     /// @param _to The address to transfer to
562     /// @param _tokens The amount of tokens to transfer
563     function transfer(address _to, uint _tokens)
564         public
565         hasAvailableTokens(msg.sender, _tokens)
566         returns(bool success)
567     {
568         holdings[_to]        += _tokens;
569         holdings[msg.sender] -= _tokens;
570 
571         emit Transfer(msg.sender, _to, _tokens);
572 
573         return true;
574     }
575 
576     /// @dev ERC20 approve
577     /// @param _spender The address to approve
578     /// @param _tokens The amount of tokens to approve
579     function approve(address _spender, uint _tokens)
580         public
581         returns(bool success)
582     {
583         allowances[msg.sender][_spender] = _tokens;
584 
585         emit Approval(msg.sender, _spender, _tokens);
586 
587         return true;
588     }
589 
590     /// @dev ERC20 transfer from
591     /// @param _from The address providing the allowance
592     /// @param _to The address using the allowance
593     /// @param _tokens The amount of tokens to transfer
594     function transferFrom(address _from, address _to, uint _tokens)
595         public
596         hasAvailableTokens(_from, _tokens)
597         returns(bool success)
598     {
599         require(allowances[_from][_to] >= _tokens);
600 
601         holdings[_to]          += _tokens;
602         holdings[_from]        -= _tokens;
603         allowances[_from][_to] -= _tokens;
604 
605         emit Transfer(_from, _to, _tokens);
606 
607         return true;
608     }
609 }
610 
611 // File: contracts/KingOfEthResourceType.sol
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
626 /// @title King of Eth: Resource Type
627 /// @author Anthony Burzillo <burz@burznest.com>
628 /// @dev Provides enum to choose resource types
629 contract KingOfEthResourceType {
630     /// @dev Enum describing a choice of a resource
631     enum ResourceType {
632           ETH
633         , BRONZE
634         , CORN
635         , GOLD
636         , OIL
637         , ORE
638         , STEEL
639         , URANIUM
640         , WOOD
641     }
642 }
643 
644 // File: contracts/KingOfEthRoadsReferencer.sol
645 
646 /****************************************************
647  *
648  * Copyright 2018 BurzNest LLC. All rights reserved.
649  *
650  * The contents of this file are provided for review
651  * and educational purposes ONLY. You MAY NOT use,
652  * copy, distribute, or modify this software without
653  * explicit written permission from BurzNest LLC.
654  *
655  ****************************************************/
656 
657 pragma solidity ^0.4.24;
658 
659 
660 /// @title King of Eth: Roads Referencer
661 /// @author Anthony Burzillo <burz@burznest.com>
662 /// @dev Provides functionality to reference the roads contract
663 contract KingOfEthRoadsReferencer is GodMode {
664     /// @dev The roads contract's address
665     address public roadsContract;
666 
667     /// @dev Only the roads contract can run this function
668     modifier onlyRoadsContract()
669     {
670         require(roadsContract == msg.sender);
671         _;
672     }
673 
674     /// @dev God can set the realty contract
675     /// @param _roadsContract The new address
676     function godSetRoadsContract(address _roadsContract)
677         public
678         onlyGod
679     {
680         roadsContract = _roadsContract;
681     }
682 }
683 
684 // File: contracts/KingOfEthResourcesInterface.sol
685 
686 /****************************************************
687  *
688  * Copyright 2018 BurzNest LLC. All rights reserved.
689  *
690  * The contents of this file are provided for review
691  * and educational purposes ONLY. You MAY NOT use,
692  * copy, distribute, or modify this software without
693  * explicit written permission from BurzNest LLC.
694  *
695  ****************************************************/
696 
697 pragma solidity ^0.4.24;
698 
699 
700 
701 
702 
703 
704 
705 /// @title King of Eth: Resources Interface
706 /// @author Anthony Burzillo <burz@burznest.com>
707 /// @dev Contract for interacting with resources
708 contract KingOfEthResourcesInterface is
709       GodMode
710     , KingOfEthExchangeReferencer
711     , KingOfEthHousesReferencer
712     , KingOfEthResourceType
713     , KingOfEthRoadsReferencer
714 {
715     /// @dev Amount of resources a user gets for building a house
716     uint public constant resourcesPerHouse = 3;
717 
718     /// @dev Address for the bronze contract
719     address public bronzeContract;
720 
721     /// @dev Address for the corn contract
722     address public cornContract;
723 
724     /// @dev Address for the gold contract
725     address public goldContract;
726 
727     /// @dev Address for the oil contract
728     address public oilContract;
729 
730     /// @dev Address for the ore contract
731     address public oreContract;
732 
733     /// @dev Address for the steel contract
734     address public steelContract;
735 
736     /// @dev Address for the uranium contract
737     address public uraniumContract;
738 
739     /// @dev Address for the wood contract
740     address public woodContract;
741 
742     /// @param _bronzeContract The address of the bronze contract
743     /// @param _cornContract The address of the corn contract
744     /// @param _goldContract The address of the gold contract
745     /// @param _oilContract The address of the oil contract
746     /// @param _oreContract The address of the ore contract
747     /// @param _steelContract The address of the steel contract
748     /// @param _uraniumContract The address of the uranium contract
749     /// @param _woodContract The address of the wood contract
750     constructor(
751           address _bronzeContract
752         , address _cornContract
753         , address _goldContract
754         , address _oilContract
755         , address _oreContract
756         , address _steelContract
757         , address _uraniumContract
758         , address _woodContract
759     )
760         public
761     {
762         bronzeContract  = _bronzeContract;
763         cornContract    = _cornContract;
764         goldContract    = _goldContract;
765         oilContract     = _oilContract;
766         oreContract     = _oreContract;
767         steelContract   = _steelContract;
768         uraniumContract = _uraniumContract;
769         woodContract    = _woodContract;
770     }
771 
772     /// @dev Return the particular address for a certain resource type
773     /// @param _type The resource type
774     /// @return The address for that resource
775     function contractFor(ResourceType _type)
776         public
777         view
778         returns(address)
779     {
780         // ETH does not have a contract
781         require(ResourceType.ETH != _type);
782 
783         if(ResourceType.BRONZE == _type)
784         {
785             return bronzeContract;
786         }
787         else if(ResourceType.CORN == _type)
788         {
789             return cornContract;
790         }
791         else if(ResourceType.GOLD == _type)
792         {
793             return goldContract;
794         }
795         else if(ResourceType.OIL == _type)
796         {
797             return oilContract;
798         }
799         else if(ResourceType.ORE == _type)
800         {
801             return oreContract;
802         }
803         else if(ResourceType.STEEL == _type)
804         {
805             return steelContract;
806         }
807         else if(ResourceType.URANIUM == _type)
808         {
809             return uraniumContract;
810         }
811         else if(ResourceType.WOOD == _type)
812         {
813             return woodContract;
814         }
815     }
816 
817     /// @dev Determine the resource type of a tile
818     /// @param _x The x coordinate of the top left corner of the tile
819     /// @param _y The y coordinate of the top left corner of the tile
820     function resourceType(uint _x, uint _y)
821         public
822         pure
823         returns(ResourceType resource)
824     {
825         uint _seed = (_x + 7777777) ^  _y;
826 
827         if(0 == _seed % 97)
828         {
829           return ResourceType.URANIUM;
830         }
831         else if(0 == _seed % 29)
832         {
833           return ResourceType.OIL;
834         }
835         else if(0 == _seed % 23)
836         {
837           return ResourceType.STEEL;
838         }
839         else if(0 == _seed % 17)
840         {
841           return ResourceType.GOLD;
842         }
843         else if(0 == _seed % 11)
844         {
845           return ResourceType.BRONZE;
846         }
847         else if(0 == _seed % 5)
848         {
849           return ResourceType.WOOD;
850         }
851         else if(0 == _seed % 2)
852         {
853           return ResourceType.CORN;
854         }
855         else
856         {
857           return ResourceType.ORE;
858         }
859     }
860 
861     /// @dev Lookup the number of resource points for a certain
862     ///  player
863     /// @param _player The player in question
864     function lookupResourcePoints(address _player)
865         public
866         view
867         returns(uint)
868     {
869         uint result = 0;
870 
871         result += KingOfEthResource(bronzeContract).balanceOf(_player);
872         result += KingOfEthResource(goldContract).balanceOf(_player)    * 3;
873         result += KingOfEthResource(steelContract).balanceOf(_player)   * 6;
874         result += KingOfEthResource(oilContract).balanceOf(_player)     * 10;
875         result += KingOfEthResource(uraniumContract).balanceOf(_player) * 44;
876 
877         return result;
878     }
879 
880     /// @dev Burn the resources necessary to build a house
881     /// @param _count the number of houses being built
882     /// @param _player The player who is building the house
883     function burnHouseCosts(uint _count, address _player)
884         public
885         onlyHousesContract
886     {
887         // Costs 2 corn per house
888         KingOfEthResource(contractFor(ResourceType.CORN)).interfaceBurnTokens(
889               _player
890             , 2 * _count
891         );
892 
893         // Costs 2 ore per house
894         KingOfEthResource(contractFor(ResourceType.ORE)).interfaceBurnTokens(
895               _player
896             , 2 * _count
897         );
898 
899         // Costs 1 wood per house
900         KingOfEthResource(contractFor(ResourceType.WOOD)).interfaceBurnTokens(
901               _player
902             , _count
903         );
904     }
905 
906     /// @dev Burn the costs of upgrading a house
907     /// @param _currentLevel The level of the house before the upgrade
908     /// @param _player The player who is upgrading the house
909     function burnUpgradeCosts(uint8 _currentLevel, address _player)
910         public
911         onlyHousesContract
912     {
913         // Do not allow upgrades after level 4
914         require(5 > _currentLevel);
915 
916         // Burn the base house cost
917         burnHouseCosts(1, _player);
918 
919         if(0 == _currentLevel)
920         {
921             // Level 1 costs bronze
922             KingOfEthResource(contractFor(ResourceType.BRONZE)).interfaceBurnTokens(
923                   _player
924                 , 1
925             );
926         }
927         else if(1 == _currentLevel)
928         {
929             // Level 2 costs gold
930             KingOfEthResource(contractFor(ResourceType.GOLD)).interfaceBurnTokens(
931                   _player
932                 , 1
933             );
934         }
935         else if(2 == _currentLevel)
936         {
937             // Level 3 costs steel
938             KingOfEthResource(contractFor(ResourceType.STEEL)).interfaceBurnTokens(
939                   _player
940                 , 1
941             );
942         }
943         else if(3 == _currentLevel)
944         {
945             // Level 4 costs oil
946             KingOfEthResource(contractFor(ResourceType.OIL)).interfaceBurnTokens(
947                   _player
948                 , 1
949             );
950         }
951         else if(4 == _currentLevel)
952         {
953             // Level 5 costs uranium
954             KingOfEthResource(contractFor(ResourceType.URANIUM)).interfaceBurnTokens(
955                   _player
956                 , 1
957             );
958         }
959     }
960 
961     /// @dev Mint resources for a house and distribute all to its owner
962     /// @param _owner The owner of the house
963     /// @param _x The x coordinate of the house
964     /// @param _y The y coordinate of the house
965     /// @param _y The y coordinate of the house
966     /// @param _level The new level of the house
967     function distributeResources(address _owner, uint _x, uint _y, uint8 _level)
968         public
969         onlyHousesContract
970     {
971         // Calculate the count of resources for this level
972         uint _count = resourcesPerHouse * uint(_level + 1);
973 
974         // Distribute the top left resource
975         KingOfEthResource(contractFor(resourceType(_x - 1, _y - 1))).interfaceMintTokens(
976             _owner
977           , _count
978         );
979 
980         // Distribute the top right resource
981         KingOfEthResource(contractFor(resourceType(_x, _y - 1))).interfaceMintTokens(
982             _owner
983           , _count
984         );
985 
986         // Distribute the bottom right resource
987         KingOfEthResource(contractFor(resourceType(_x, _y))).interfaceMintTokens(
988             _owner
989           , _count
990         );
991 
992         // Distribute the bottom left resource
993         KingOfEthResource(contractFor(resourceType(_x - 1, _y))).interfaceMintTokens(
994             _owner
995           , _count
996         );
997     }
998 
999     /// @dev Burn the costs necessary to build a road
1000     /// @param _length The length of the road
1001     /// @param _player The player who is building the house
1002     function burnRoadCosts(uint _length, address _player)
1003         public
1004         onlyRoadsContract
1005     {
1006         // Burn corn
1007         KingOfEthResource(cornContract).interfaceBurnTokens(
1008               _player
1009             , _length
1010         );
1011 
1012         // Burn ore
1013         KingOfEthResource(oreContract).interfaceBurnTokens(
1014               _player
1015             , _length
1016         );
1017     }
1018 
1019     /// @dev The exchange can freeze tokens
1020     /// @param _type The type of resource
1021     /// @param _owner The owner of the tokens
1022     /// @param _tokens The amount of tokens to freeze
1023     function exchangeFreezeTokens(ResourceType _type, address _owner, uint _tokens)
1024         public
1025         onlyExchangeContract
1026     {
1027         KingOfEthResource(contractFor(_type)).interfaceFreezeTokens(_owner, _tokens);
1028     }
1029 
1030     /// @dev The exchange can thaw tokens
1031     /// @param _type The type of resource
1032     /// @param _owner The owner of the tokens
1033     /// @param _tokens The amount of tokens to thaw
1034     function exchangeThawTokens(ResourceType _type, address _owner, uint _tokens)
1035         public
1036         onlyExchangeContract
1037     {
1038         KingOfEthResource(contractFor(_type)).interfaceThawTokens(_owner, _tokens);
1039     }
1040 
1041     /// @dev The exchange can transfer tokens
1042     /// @param _type The type of resource
1043     /// @param _from The owner of the tokens
1044     /// @param _to The new owner of the tokens
1045     /// @param _tokens The amount of tokens to transfer
1046     function exchangeTransfer(ResourceType _type, address _from, address _to, uint _tokens)
1047         public
1048         onlyExchangeContract
1049     {
1050         KingOfEthResource(contractFor(_type)).interfaceTransfer(_from, _to, _tokens);
1051     }
1052 
1053     /// @dev The exchange can transfer frozend tokens
1054     /// @param _type The type of resource
1055     /// @param _from The owner of the tokens
1056     /// @param _to The new owner of the tokens
1057     /// @param _tokens The amount of frozen tokens to transfer
1058     function exchangeFrozenTransfer(ResourceType _type, address _from, address _to, uint _tokens)
1059         public
1060         onlyExchangeContract
1061     {
1062         KingOfEthResource(contractFor(_type)).interfaceFrozenTransfer(_from, _to, _tokens);
1063     }
1064 }
1065 
1066 // File: contracts/KingOfEthEthExchange.sol
1067 
1068 /****************************************************
1069  *
1070  * Copyright 2018 BurzNest LLC. All rights reserved.
1071  *
1072  * The contents of this file are provided for review
1073  * and educational purposes ONLY. You MAY NOT use,
1074  * copy, distribute, or modify this software without
1075  * explicit written permission from BurzNest LLC.
1076  *
1077  ****************************************************/
1078 
1079 pragma solidity ^0.4.24;
1080 
1081 
1082 
1083 
1084 
1085 
1086 
1087 /// @title King of Eth: Resource-to-ETH Exchange
1088 /// @author Anthony Burzillo <burz@burznest.com>
1089 /// @dev All the ETH exchange functionality
1090 contract KingOfEthEthExchange is
1091       GodMode
1092     , KingOfEthReferencer
1093     , KingOfEthResourcesInterfaceReferencer
1094     , KingOfEthResourceType
1095 {
1096     /// @dev Struct to hold data about a trade
1097     struct Trade {
1098         /// @dev The creator of the trade
1099         address creator;
1100 
1101         /// @dev The resource the trade is providing
1102         ResourceType resource;
1103 
1104         /// @dev The resource the trade is asking for
1105         ResourceType tradingFor;
1106 
1107         /// @dev The amount of the resource that is left to trade
1108         uint amountRemaining;
1109 
1110         /// @dev The amount of what is asked for needed for one
1111         ///  of the provided resource
1112         uint price;
1113     }
1114 
1115     /// @dev The number of decimals that the price of the trade has
1116     uint public constant priceDecimals = 6;
1117 
1118     /// @dev The number that divides ETH in a trade to pay as taxes
1119     uint public constant taxDivisor = 25;
1120 
1121     /// @dev The id of the next trade created
1122     uint public nextTradeId;
1123 
1124     /// @dev Mapping of trade ids to info about the trade
1125     mapping (uint => Trade) trades;
1126 
1127     /// @dev Fired when a trade is created
1128     event EthTradeCreated(
1129           uint tradeId
1130         , ResourceType resource
1131         , ResourceType tradingFor
1132         , uint amount
1133         , uint price
1134         , address creator
1135     );
1136 
1137     /// @dev Fired when a trade is (partially) filled
1138     event EthTradeFilled(
1139           uint tradeId
1140         , ResourceType resource
1141         , ResourceType tradingFor
1142         , uint amount
1143         , uint price
1144         , address creator
1145         , address filler
1146     );
1147 
1148     /// @dev Fired when a trade is cancelled
1149     event EthTradeCancelled(
1150           uint tradeId
1151         , ResourceType resource
1152         , ResourceType tradingFor
1153         , uint amount
1154         , address creator
1155     );
1156 
1157     /// @param _kingOfEthContract The address of the king contract
1158     /// @param _interfaceContract The address of the resources
1159     ///  interface contract
1160     constructor(
1161           address _kingOfEthContract
1162         , address _interfaceContract
1163     )
1164         public
1165     {
1166         kingOfEthContract = _kingOfEthContract;
1167         interfaceContract = _interfaceContract;
1168     }
1169 
1170     /// @dev Create a trade
1171     /// @param _resource The resource the trade is providing
1172     /// @param _tradingFor The resource the trade is asking for
1173     /// @param _amount The amount of the resource that to trade
1174     /// @param _price The amount of what is asked for needed for one
1175     ///  of the provided resource
1176     /// @return The id of the trade
1177     function createTrade(
1178           ResourceType _resource
1179         , ResourceType _tradingFor
1180         , uint _amount
1181         , uint _price
1182     )
1183         public
1184         payable
1185         returns(uint)
1186     {
1187         // Require one of the resources to be ETH
1188         require(
1189                ResourceType.ETH == _resource
1190             || ResourceType.ETH == _tradingFor
1191         );
1192 
1193         // Don't allow trades for the same resource
1194         require(_resource != _tradingFor);
1195 
1196         // Require that the amount is greater than 0
1197         require(0 < _amount);
1198 
1199         // Require that the price is greater than 0
1200         require(0 < _price);
1201 
1202         // If the resource provided is ETH
1203         if(ResourceType.ETH == _resource)
1204         {
1205             // Start calculating size of resources
1206             uint _size = _amount * _price;
1207 
1208             // Ensure that the result is reversable (there is no overflow)
1209             require(_amount == _size / _price);
1210 
1211             // Finish the calculation
1212             _size /= 10 ** priceDecimals;
1213 
1214             // Ensure the size is a whole number
1215             require(0 == _size % 1 ether);
1216 
1217             // Require that the ETH was sent with the transaction
1218             require(_amount == msg.value);
1219         }
1220         // If it was a normal resource
1221         else
1222         {
1223             // Freeze the amount of tokens for that resource
1224             KingOfEthResourcesInterface(interfaceContract).exchangeFreezeTokens(
1225                   _resource
1226                 , msg.sender
1227                 , _amount
1228             );
1229         }
1230 
1231         // Set up the info about the trade
1232         trades[nextTradeId] = Trade(
1233               msg.sender
1234             , _resource
1235             , _tradingFor
1236             , _amount
1237             , _price
1238         );
1239 
1240         emit EthTradeCreated(
1241               nextTradeId
1242             , _resource
1243             , _tradingFor
1244             , _amount
1245             , _price
1246             , msg.sender
1247         );
1248 
1249         // Return the trade id
1250         return nextTradeId++;
1251     }
1252 
1253     /// @dev Fill an amount of some trade
1254     /// @param _tradeId The id of the trade
1255     /// @param _amount The amount of the provided resource to fill
1256     function fillTrade(uint _tradeId, uint _amount) public payable
1257     {
1258         // Require a nonzero amount to be filled
1259         require(0 < _amount);
1260 
1261         // Lookup the trade
1262         Trade storage _trade = trades[_tradeId];
1263 
1264         // Require that at least the amount filling is available to trade
1265         require(_trade.amountRemaining >= _amount);
1266 
1267         // Reduce the amount remaining by the amount being filled
1268         _trade.amountRemaining -= _amount;
1269 
1270         // The size of the trade
1271         uint _size;
1272 
1273         // The tax cut of this trade
1274         uint _taxCut;
1275 
1276         // If the resource filling for is ETH
1277         if(ResourceType.ETH == _trade.resource)
1278         {
1279             // Calculate the size of the resources filling with
1280             _size = _trade.price * _amount;
1281 
1282             // Ensure that the result is reversable (there is no overflow)
1283             require(_size / _trade.price == _amount);
1284 
1285             // Divide by the price decimals
1286             _size /= 10 ** priceDecimals;
1287 
1288             // Require that the size is a whole number
1289             require(0 == _size % 1 ether);
1290 
1291             // Get the size in resources
1292             _size /= 1 ether;
1293 
1294             // Require no ETH was sent with this transaction
1295             require(0 == msg.value);
1296 
1297             // Calculate the tax cut
1298             _taxCut = _amount / taxDivisor;
1299 
1300             // Send the filler the ETH
1301             msg.sender.transfer(_amount - _taxCut);
1302 
1303             // Pay the taxes
1304             KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(_taxCut)();
1305 
1306             // Send the creator the filler's resoruces
1307             KingOfEthResourcesInterface(interfaceContract).exchangeTransfer(
1308                   _trade.tradingFor
1309                 , msg.sender
1310                 , _trade.creator
1311                 , _size
1312             );
1313         }
1314         // If ETH is being filled
1315         else
1316         {
1317             // Calculate the size of the resources filling with
1318             _size = _trade.price * _amount;
1319 
1320             // Ensure that the result is reversable (there is no overflow)
1321             require(_size / _trade.price == _amount);
1322 
1323             // Convert to ETH
1324             uint _temp = _size * 1 ether;
1325 
1326             // Ensure that the result is reversable (there is no overflow)
1327             require(_size == _temp / 1 ether);
1328 
1329             // Divide by the price decimals
1330             _size = _temp / (10 ** priceDecimals);
1331 
1332             // Require that the user has sent the correct amount of ETH
1333             require(_size == msg.value);
1334 
1335             // Calculate the tax cut
1336             _taxCut = msg.value / taxDivisor;
1337 
1338             // Send the creator his ETH
1339             _trade.creator.transfer(msg.value - _taxCut);
1340 
1341             // Pay the taxes
1342             KingOfEthAbstractInterface(kingOfEthContract).payTaxes.value(_taxCut)();
1343 
1344             // Send the filler the creator's frozen resources
1345             KingOfEthResourcesInterface(interfaceContract).exchangeFrozenTransfer(
1346                   _trade.resource
1347                 , _trade.creator
1348                 , msg.sender
1349                 , _amount
1350             );
1351         }
1352 
1353         emit EthTradeFilled(
1354               _tradeId
1355             , _trade.resource
1356             , _trade.tradingFor
1357             , _amount
1358             , _trade.price
1359             , _trade.creator
1360             , msg.sender
1361         );
1362     }
1363 
1364     /// @dev Cancel a trade
1365     /// @param _tradeId The trade's id
1366     function cancelTrade(uint _tradeId) public
1367     {
1368         // Lookup the trade's info
1369         Trade storage _trade = trades[_tradeId];
1370 
1371         // Require that the creator is cancelling the trade
1372         require(_trade.creator == msg.sender);
1373 
1374         // Save the amount remaining
1375         uint _amountRemaining = _trade.amountRemaining;
1376 
1377         // Set the amount remaining to trade to 0
1378         // Note that this effectively cancels the trade
1379         _trade.amountRemaining = 0;
1380 
1381         // If the trade provided ETH
1382         if(ResourceType.ETH == _trade.resource)
1383         {
1384             // Sent the creator back his ETH
1385             msg.sender.transfer(_amountRemaining);
1386         }
1387         // If the trade provided a resource
1388         else
1389         {
1390             // Thaw the creator's resource
1391             KingOfEthResourcesInterface(interfaceContract).exchangeThawTokens(
1392                   _trade.resource
1393                 , msg.sender
1394                 , _amountRemaining
1395             );
1396         }
1397 
1398         emit EthTradeCancelled(
1399               _tradeId
1400             , _trade.resource
1401             , _trade.tradingFor
1402             , _amountRemaining
1403             , msg.sender
1404         );
1405     }
1406 }