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
79 // File: contracts/KingOfEthEthExchangeReferencer.sol
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
94 
95 /// @title King of Eth: Resource-to-ETH Exchange Referencer
96 /// @author Anthony Burzillo <burz@burznest.com>
97 /// @dev Provides functionality to interface with the
98 ///  ETH exchange contract
99 contract KingOfEthEthExchangeReferencer is GodMode {
100     /// @dev Address of the ETH exchange contract
101     address public ethExchangeContract;
102 
103     /// @dev Only the ETH exchange contract may run this function
104     modifier onlyEthExchangeContract()
105     {
106         require(ethExchangeContract == msg.sender);
107         _;
108     }
109 
110     /// @dev God may set the ETH exchange contract's address
111     /// @dev _ethExchangeContract The new address
112     function godSetEthExchangeContract(address _ethExchangeContract)
113         public
114         onlyGod
115     {
116         ethExchangeContract = _ethExchangeContract;
117     }
118 }
119 
120 // File: contracts/KingOfEthResourceExchangeReferencer.sol
121 
122 /****************************************************
123  *
124  * Copyright 2018 BurzNest LLC. All rights reserved.
125  *
126  * The contents of this file are provided for review
127  * and educational purposes ONLY. You MAY NOT use,
128  * copy, distribute, or modify this software without
129  * explicit written permission from BurzNest LLC.
130  *
131  ****************************************************/
132 
133 pragma solidity ^0.4.24;
134 
135 
136 /// @title King of Eth: Resource-to-Resource Exchange Referencer
137 /// @author Anthony Burzillo <burz@burznest.com>
138 /// @dev Provides functionality to interface with the
139 ///  resource-to-resource contract
140 contract KingOfEthResourceExchangeReferencer is GodMode {
141     /// @dev Address of the resource-to-resource contract
142     address public resourceExchangeContract;
143 
144     /// @dev Only the resource-to-resource contract may run this function
145     modifier onlyResourceExchangeContract()
146     {
147         require(resourceExchangeContract == msg.sender);
148         _;
149     }
150 
151     /// @dev God may set the resource-to-resource contract's address
152     /// @dev _resourceExchangeContract The new address
153     function godSetResourceExchangeContract(address _resourceExchangeContract)
154         public
155         onlyGod
156     {
157         resourceExchangeContract = _resourceExchangeContract;
158     }
159 }
160 
161 // File: contracts/KingOfEthExchangeReferencer.sol
162 
163 /****************************************************
164  *
165  * Copyright 2018 BurzNest LLC. All rights reserved.
166  *
167  * The contents of this file are provided for review
168  * and educational purposes ONLY. You MAY NOT use,
169  * copy, distribute, or modify this software without
170  * explicit written permission from BurzNest LLC.
171  *
172  ****************************************************/
173 
174 pragma solidity ^0.4.24;
175 
176 
177 
178 
179 /// @title King of Eth: Exchange Referencer
180 /// @author Anthony Burzillo <burz@burznest.com>
181 /// @dev Provides functionality to interface with the exchange contract
182 contract KingOfEthExchangeReferencer is
183       GodMode
184     , KingOfEthEthExchangeReferencer
185     , KingOfEthResourceExchangeReferencer
186 {
187     /// @dev Only one of the exchange contracts may
188     ///  run this function
189     modifier onlyExchangeContract()
190     {
191         require(
192                ethExchangeContract == msg.sender
193             || resourceExchangeContract == msg.sender
194         );
195         _;
196     }
197 }
198 
199 // File: contracts/KingOfEthHousesReferencer.sol
200 
201 /****************************************************
202  *
203  * Copyright 2018 BurzNest LLC. All rights reserved.
204  *
205  * The contents of this file are provided for review
206  * and educational purposes ONLY. You MAY NOT use,
207  * copy, distribute, or modify this software without
208  * explicit written permission from BurzNest LLC.
209  *
210  ****************************************************/
211 
212 pragma solidity ^0.4.24;
213 
214 
215 /// @title King of Eth: Houses Referencer
216 /// @author Anthony Burzillo <burz@burznest.com>
217 /// @dev Provides functionality to reference the houses contract
218 contract KingOfEthHousesReferencer is GodMode {
219     /// @dev The houses contract's address
220     address public housesContract;
221 
222     /// @dev Only the houses contract can run this function
223     modifier onlyHousesContract()
224     {
225         require(housesContract == msg.sender);
226         _;
227     }
228 
229     /// @dev God can set the realty contract
230     /// @param _housesContract The new address
231     function godSetHousesContract(address _housesContract)
232         public
233         onlyGod
234     {
235         housesContract = _housesContract;
236     }
237 }
238 
239 // File: contracts/KingOfEthResourcesInterfaceReferencer.sol
240 
241 /****************************************************
242  *
243  * Copyright 2018 BurzNest LLC. All rights reserved.
244  *
245  * The contents of this file are provided for review
246  * and educational purposes ONLY. You MAY NOT use,
247  * copy, distribute, or modify this software without
248  * explicit written permission from BurzNest LLC.
249  *
250  ****************************************************/
251 
252 pragma solidity ^0.4.24;
253 
254 
255 /// @title King of Eth: Resources Interface Referencer
256 /// @author Anthony Burzillo <burz@burznest.com>
257 /// @dev Provides functionality to reference the resource interface contract
258 contract KingOfEthResourcesInterfaceReferencer is GodMode {
259     /// @dev The interface contract's address
260     address public interfaceContract;
261 
262     /// @dev Only the interface contract can run this function
263     modifier onlyInterfaceContract()
264     {
265         require(interfaceContract == msg.sender);
266         _;
267     }
268 
269     /// @dev God can set the realty contract
270     /// @param _interfaceContract The new address
271     function godSetInterfaceContract(address _interfaceContract)
272         public
273         onlyGod
274     {
275         interfaceContract = _interfaceContract;
276     }
277 }
278 
279 // File: contracts/KingOfEthResource.sol
280 
281 /****************************************************
282  *
283  * Copyright 2018 BurzNest LLC. All rights reserved.
284  *
285  * The contents of this file are provided for review
286  * and educational purposes ONLY. You MAY NOT use,
287  * copy, distribute, or modify this software without
288  * explicit written permission from BurzNest LLC.
289  *
290  ****************************************************/
291 
292 pragma solidity ^0.4.24;
293 
294 
295 
296 /// @title ERC20Interface
297 /// @dev ERC20 token interface contract
298 contract ERC20Interface {
299     function totalSupply() public constant returns(uint);
300     function balanceOf(address _tokenOwner) public constant returns(uint balance);
301     function allowance(address _tokenOwner, address _spender) public constant returns(uint remaining);
302     function transfer(address _to, uint _tokens) public returns(bool success);
303     function approve(address _spender, uint _tokens) public returns(bool success);
304     function transferFrom(address _from, address _to, uint _tokens) public returns(bool success);
305 
306     event Transfer(address indexed from, address indexed to, uint tokens);
307     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
308 }
309 
310 /// @title King of Eth: Resource
311 /// @author Anthony Burzillo <burz@burznest.com>
312 /// @dev Common contract implementation for resources
313 contract KingOfEthResource is
314       ERC20Interface
315     , GodMode
316     , KingOfEthResourcesInterfaceReferencer
317 {
318     /// @dev Current resource supply
319     uint public resourceSupply;
320 
321     /// @dev ERC20 token's decimals
322     uint8 public constant decimals = 0;
323 
324     /// @dev mapping of addresses to holdings
325     mapping (address => uint) holdings;
326 
327     /// @dev mapping of addresses to amount of tokens frozen
328     mapping (address => uint) frozenHoldings;
329 
330     /// @dev mapping of addresses to mapping of allowances for an address
331     mapping (address => mapping (address => uint)) allowances;
332 
333     /// @dev ERC20 total supply
334     /// @return The current total supply of the resource
335     function totalSupply()
336         public
337         constant
338         returns(uint)
339     {
340         return resourceSupply;
341     }
342 
343     /// @dev ERC20 balance of address
344     /// @param _tokenOwner The address to look up
345     /// @return The balance of the address
346     function balanceOf(address _tokenOwner)
347         public
348         constant
349         returns(uint balance)
350     {
351         return holdings[_tokenOwner];
352     }
353 
354     /// @dev Total resources frozen for an address
355     /// @param _tokenOwner The address to look up
356     /// @return The frozen balance of the address
357     function frozenTokens(address _tokenOwner)
358         public
359         constant
360         returns(uint balance)
361     {
362         return frozenHoldings[_tokenOwner];
363     }
364 
365     /// @dev The allowance for a spender on an account
366     /// @param _tokenOwner The account that allows withdrawels
367     /// @param _spender The account that is allowed to withdraw
368     /// @return The amount remaining in the allowance
369     function allowance(address _tokenOwner, address _spender)
370         public
371         constant
372         returns(uint remaining)
373     {
374         return allowances[_tokenOwner][_spender];
375     }
376 
377     /// @dev Only run if player has at least some amount of tokens
378     /// @param _owner The owner of the tokens
379     /// @param _tokens The amount of tokens required
380     modifier hasAvailableTokens(address _owner, uint _tokens)
381     {
382         require(holdings[_owner] - frozenHoldings[_owner] >= _tokens);
383         _;
384     }
385 
386     /// @dev Only run if player has at least some amount of tokens frozen
387     /// @param _owner The owner of the tokens
388     /// @param _tokens The amount of frozen tokens required
389     modifier hasFrozenTokens(address _owner, uint _tokens)
390     {
391         require(frozenHoldings[_owner] >= _tokens);
392         _;
393     }
394 
395     /// @dev Set up the exact same state in each resource
396     constructor() public
397     {
398         // God gets 200 to put on exchange
399         holdings[msg.sender] = 200;
400 
401         resourceSupply = 200;
402     }
403 
404     /// @dev The resources interface can burn tokens for building
405     ///  roads or houses
406     /// @param _owner The owner of the tokens
407     /// @param _tokens The amount of tokens to burn
408     function interfaceBurnTokens(address _owner, uint _tokens)
409         public
410         onlyInterfaceContract
411         hasAvailableTokens(_owner, _tokens)
412     {
413         holdings[_owner] -= _tokens;
414 
415         resourceSupply -= _tokens;
416 
417         // Pretend the tokens were sent to 0x0
418         emit Transfer(_owner, 0x0, _tokens);
419     }
420 
421     /// @dev The resources interface contract can mint tokens for houses
422     /// @param _owner The owner of the tokens
423     /// @param _tokens The amount of tokens to burn
424     function interfaceMintTokens(address _owner, uint _tokens)
425         public
426         onlyInterfaceContract
427     {
428         holdings[_owner] += _tokens;
429 
430         resourceSupply += _tokens;
431 
432         // Pretend the tokens were sent from the interface contract
433         emit Transfer(interfaceContract, _owner, _tokens);
434     }
435 
436     /// @dev The interface can freeze tokens
437     /// @param _owner The owner of the tokens
438     /// @param _tokens The amount of tokens to freeze
439     function interfaceFreezeTokens(address _owner, uint _tokens)
440         public
441         onlyInterfaceContract
442         hasAvailableTokens(_owner, _tokens)
443     {
444         frozenHoldings[_owner] += _tokens;
445     }
446 
447     /// @dev The interface can thaw tokens
448     /// @param _owner The owner of the tokens
449     /// @param _tokens The amount of tokens to thaw
450     function interfaceThawTokens(address _owner, uint _tokens)
451         public
452         onlyInterfaceContract
453         hasFrozenTokens(_owner, _tokens)
454     {
455         frozenHoldings[_owner] -= _tokens;
456     }
457 
458     /// @dev The interface can transfer tokens
459     /// @param _from The owner of the tokens
460     /// @param _to The new owner of the tokens
461     /// @param _tokens The amount of tokens to transfer
462     function interfaceTransfer(address _from, address _to, uint _tokens)
463         public
464         onlyInterfaceContract
465     {
466         assert(holdings[_from] >= _tokens);
467 
468         holdings[_from] -= _tokens;
469         holdings[_to]   += _tokens;
470 
471         emit Transfer(_from, _to, _tokens);
472     }
473 
474     /// @dev The interface can transfer frozend tokens
475     /// @param _from The owner of the tokens
476     /// @param _to The new owner of the tokens
477     /// @param _tokens The amount of frozen tokens to transfer
478     function interfaceFrozenTransfer(address _from, address _to, uint _tokens)
479         public
480         onlyInterfaceContract
481         hasFrozenTokens(_from, _tokens)
482     {
483         // Make sure to deduct the tokens from both the total and frozen amounts
484         holdings[_from]       -= _tokens;
485         frozenHoldings[_from] -= _tokens;
486         holdings[_to]         += _tokens;
487 
488         emit Transfer(_from, _to, _tokens);
489     }
490 
491     /// @dev ERC20 transfer
492     /// @param _to The address to transfer to
493     /// @param _tokens The amount of tokens to transfer
494     function transfer(address _to, uint _tokens)
495         public
496         hasAvailableTokens(msg.sender, _tokens)
497         returns(bool success)
498     {
499         holdings[_to]        += _tokens;
500         holdings[msg.sender] -= _tokens;
501 
502         emit Transfer(msg.sender, _to, _tokens);
503 
504         return true;
505     }
506 
507     /// @dev ERC20 approve
508     /// @param _spender The address to approve
509     /// @param _tokens The amount of tokens to approve
510     function approve(address _spender, uint _tokens)
511         public
512         returns(bool success)
513     {
514         allowances[msg.sender][_spender] = _tokens;
515 
516         emit Approval(msg.sender, _spender, _tokens);
517 
518         return true;
519     }
520 
521     /// @dev ERC20 transfer from
522     /// @param _from The address providing the allowance
523     /// @param _to The address using the allowance
524     /// @param _tokens The amount of tokens to transfer
525     function transferFrom(address _from, address _to, uint _tokens)
526         public
527         hasAvailableTokens(_from, _tokens)
528         returns(bool success)
529     {
530         require(allowances[_from][_to] >= _tokens);
531 
532         holdings[_to]          += _tokens;
533         holdings[_from]        -= _tokens;
534         allowances[_from][_to] -= _tokens;
535 
536         emit Transfer(_from, _to, _tokens);
537 
538         return true;
539     }
540 }
541 
542 // File: contracts/KingOfEthResourceType.sol
543 
544 /****************************************************
545  *
546  * Copyright 2018 BurzNest LLC. All rights reserved.
547  *
548  * The contents of this file are provided for review
549  * and educational purposes ONLY. You MAY NOT use,
550  * copy, distribute, or modify this software without
551  * explicit written permission from BurzNest LLC.
552  *
553  ****************************************************/
554 
555 pragma solidity ^0.4.24;
556 
557 /// @title King of Eth: Resource Type
558 /// @author Anthony Burzillo <burz@burznest.com>
559 /// @dev Provides enum to choose resource types
560 contract KingOfEthResourceType {
561     /// @dev Enum describing a choice of a resource
562     enum ResourceType {
563           ETH
564         , BRONZE
565         , CORN
566         , GOLD
567         , OIL
568         , ORE
569         , STEEL
570         , URANIUM
571         , WOOD
572     }
573 }
574 
575 // File: contracts/KingOfEthRoadsReferencer.sol
576 
577 /****************************************************
578  *
579  * Copyright 2018 BurzNest LLC. All rights reserved.
580  *
581  * The contents of this file are provided for review
582  * and educational purposes ONLY. You MAY NOT use,
583  * copy, distribute, or modify this software without
584  * explicit written permission from BurzNest LLC.
585  *
586  ****************************************************/
587 
588 pragma solidity ^0.4.24;
589 
590 
591 /// @title King of Eth: Roads Referencer
592 /// @author Anthony Burzillo <burz@burznest.com>
593 /// @dev Provides functionality to reference the roads contract
594 contract KingOfEthRoadsReferencer is GodMode {
595     /// @dev The roads contract's address
596     address public roadsContract;
597 
598     /// @dev Only the roads contract can run this function
599     modifier onlyRoadsContract()
600     {
601         require(roadsContract == msg.sender);
602         _;
603     }
604 
605     /// @dev God can set the realty contract
606     /// @param _roadsContract The new address
607     function godSetRoadsContract(address _roadsContract)
608         public
609         onlyGod
610     {
611         roadsContract = _roadsContract;
612     }
613 }
614 
615 // File: contracts/KingOfEthResourcesInterface.sol
616 
617 /****************************************************
618  *
619  * Copyright 2018 BurzNest LLC. All rights reserved.
620  *
621  * The contents of this file are provided for review
622  * and educational purposes ONLY. You MAY NOT use,
623  * copy, distribute, or modify this software without
624  * explicit written permission from BurzNest LLC.
625  *
626  ****************************************************/
627 
628 pragma solidity ^0.4.24;
629 
630 
631 
632 
633 
634 
635 
636 /// @title King of Eth: Resources Interface
637 /// @author Anthony Burzillo <burz@burznest.com>
638 /// @dev Contract for interacting with resources
639 contract KingOfEthResourcesInterface is
640       GodMode
641     , KingOfEthExchangeReferencer
642     , KingOfEthHousesReferencer
643     , KingOfEthResourceType
644     , KingOfEthRoadsReferencer
645 {
646     /// @dev Amount of resources a user gets for building a house
647     uint public constant resourcesPerHouse = 3;
648 
649     /// @dev Address for the bronze contract
650     address public bronzeContract;
651 
652     /// @dev Address for the corn contract
653     address public cornContract;
654 
655     /// @dev Address for the gold contract
656     address public goldContract;
657 
658     /// @dev Address for the oil contract
659     address public oilContract;
660 
661     /// @dev Address for the ore contract
662     address public oreContract;
663 
664     /// @dev Address for the steel contract
665     address public steelContract;
666 
667     /// @dev Address for the uranium contract
668     address public uraniumContract;
669 
670     /// @dev Address for the wood contract
671     address public woodContract;
672 
673     /// @param _bronzeContract The address of the bronze contract
674     /// @param _cornContract The address of the corn contract
675     /// @param _goldContract The address of the gold contract
676     /// @param _oilContract The address of the oil contract
677     /// @param _oreContract The address of the ore contract
678     /// @param _steelContract The address of the steel contract
679     /// @param _uraniumContract The address of the uranium contract
680     /// @param _woodContract The address of the wood contract
681     constructor(
682           address _bronzeContract
683         , address _cornContract
684         , address _goldContract
685         , address _oilContract
686         , address _oreContract
687         , address _steelContract
688         , address _uraniumContract
689         , address _woodContract
690     )
691         public
692     {
693         bronzeContract  = _bronzeContract;
694         cornContract    = _cornContract;
695         goldContract    = _goldContract;
696         oilContract     = _oilContract;
697         oreContract     = _oreContract;
698         steelContract   = _steelContract;
699         uraniumContract = _uraniumContract;
700         woodContract    = _woodContract;
701     }
702 
703     /// @dev Return the particular address for a certain resource type
704     /// @param _type The resource type
705     /// @return The address for that resource
706     function contractFor(ResourceType _type)
707         public
708         view
709         returns(address)
710     {
711         // ETH does not have a contract
712         require(ResourceType.ETH != _type);
713 
714         if(ResourceType.BRONZE == _type)
715         {
716             return bronzeContract;
717         }
718         else if(ResourceType.CORN == _type)
719         {
720             return cornContract;
721         }
722         else if(ResourceType.GOLD == _type)
723         {
724             return goldContract;
725         }
726         else if(ResourceType.OIL == _type)
727         {
728             return oilContract;
729         }
730         else if(ResourceType.ORE == _type)
731         {
732             return oreContract;
733         }
734         else if(ResourceType.STEEL == _type)
735         {
736             return steelContract;
737         }
738         else if(ResourceType.URANIUM == _type)
739         {
740             return uraniumContract;
741         }
742         else if(ResourceType.WOOD == _type)
743         {
744             return woodContract;
745         }
746     }
747 
748     /// @dev Determine the resource type of a tile
749     /// @param _x The x coordinate of the top left corner of the tile
750     /// @param _y The y coordinate of the top left corner of the tile
751     function resourceType(uint _x, uint _y)
752         public
753         pure
754         returns(ResourceType resource)
755     {
756         uint _seed = (_x + 7777777) ^  _y;
757 
758         if(0 == _seed % 97)
759         {
760           return ResourceType.URANIUM;
761         }
762         else if(0 == _seed % 29)
763         {
764           return ResourceType.OIL;
765         }
766         else if(0 == _seed % 23)
767         {
768           return ResourceType.STEEL;
769         }
770         else if(0 == _seed % 17)
771         {
772           return ResourceType.GOLD;
773         }
774         else if(0 == _seed % 11)
775         {
776           return ResourceType.BRONZE;
777         }
778         else if(0 == _seed % 5)
779         {
780           return ResourceType.WOOD;
781         }
782         else if(0 == _seed % 2)
783         {
784           return ResourceType.CORN;
785         }
786         else
787         {
788           return ResourceType.ORE;
789         }
790     }
791 
792     /// @dev Lookup the number of resource points for a certain
793     ///  player
794     /// @param _player The player in question
795     function lookupResourcePoints(address _player)
796         public
797         view
798         returns(uint)
799     {
800         uint result = 0;
801 
802         result += KingOfEthResource(bronzeContract).balanceOf(_player);
803         result += KingOfEthResource(goldContract).balanceOf(_player)    * 3;
804         result += KingOfEthResource(steelContract).balanceOf(_player)   * 6;
805         result += KingOfEthResource(oilContract).balanceOf(_player)     * 10;
806         result += KingOfEthResource(uraniumContract).balanceOf(_player) * 44;
807 
808         return result;
809     }
810 
811     /// @dev Burn the resources necessary to build a house
812     /// @param _count the number of houses being built
813     /// @param _player The player who is building the house
814     function burnHouseCosts(uint _count, address _player)
815         public
816         onlyHousesContract
817     {
818         // Costs 2 corn per house
819         KingOfEthResource(contractFor(ResourceType.CORN)).interfaceBurnTokens(
820               _player
821             , 2 * _count
822         );
823 
824         // Costs 2 ore per house
825         KingOfEthResource(contractFor(ResourceType.ORE)).interfaceBurnTokens(
826               _player
827             , 2 * _count
828         );
829 
830         // Costs 1 wood per house
831         KingOfEthResource(contractFor(ResourceType.WOOD)).interfaceBurnTokens(
832               _player
833             , _count
834         );
835     }
836 
837     /// @dev Burn the costs of upgrading a house
838     /// @param _currentLevel The level of the house before the upgrade
839     /// @param _player The player who is upgrading the house
840     function burnUpgradeCosts(uint8 _currentLevel, address _player)
841         public
842         onlyHousesContract
843     {
844         // Do not allow upgrades after level 4
845         require(5 > _currentLevel);
846 
847         // Burn the base house cost
848         burnHouseCosts(1, _player);
849 
850         if(0 == _currentLevel)
851         {
852             // Level 1 costs bronze
853             KingOfEthResource(contractFor(ResourceType.BRONZE)).interfaceBurnTokens(
854                   _player
855                 , 1
856             );
857         }
858         else if(1 == _currentLevel)
859         {
860             // Level 2 costs gold
861             KingOfEthResource(contractFor(ResourceType.GOLD)).interfaceBurnTokens(
862                   _player
863                 , 1
864             );
865         }
866         else if(2 == _currentLevel)
867         {
868             // Level 3 costs steel
869             KingOfEthResource(contractFor(ResourceType.STEEL)).interfaceBurnTokens(
870                   _player
871                 , 1
872             );
873         }
874         else if(3 == _currentLevel)
875         {
876             // Level 4 costs oil
877             KingOfEthResource(contractFor(ResourceType.OIL)).interfaceBurnTokens(
878                   _player
879                 , 1
880             );
881         }
882         else if(4 == _currentLevel)
883         {
884             // Level 5 costs uranium
885             KingOfEthResource(contractFor(ResourceType.URANIUM)).interfaceBurnTokens(
886                   _player
887                 , 1
888             );
889         }
890     }
891 
892     /// @dev Mint resources for a house and distribute all to its owner
893     /// @param _owner The owner of the house
894     /// @param _x The x coordinate of the house
895     /// @param _y The y coordinate of the house
896     /// @param _y The y coordinate of the house
897     /// @param _level The new level of the house
898     function distributeResources(address _owner, uint _x, uint _y, uint8 _level)
899         public
900         onlyHousesContract
901     {
902         // Calculate the count of resources for this level
903         uint _count = resourcesPerHouse * uint(_level + 1);
904 
905         // Distribute the top left resource
906         KingOfEthResource(contractFor(resourceType(_x - 1, _y - 1))).interfaceMintTokens(
907             _owner
908           , _count
909         );
910 
911         // Distribute the top right resource
912         KingOfEthResource(contractFor(resourceType(_x, _y - 1))).interfaceMintTokens(
913             _owner
914           , _count
915         );
916 
917         // Distribute the bottom right resource
918         KingOfEthResource(contractFor(resourceType(_x, _y))).interfaceMintTokens(
919             _owner
920           , _count
921         );
922 
923         // Distribute the bottom left resource
924         KingOfEthResource(contractFor(resourceType(_x - 1, _y))).interfaceMintTokens(
925             _owner
926           , _count
927         );
928     }
929 
930     /// @dev Burn the costs necessary to build a road
931     /// @param _length The length of the road
932     /// @param _player The player who is building the house
933     function burnRoadCosts(uint _length, address _player)
934         public
935         onlyRoadsContract
936     {
937         // Burn corn
938         KingOfEthResource(cornContract).interfaceBurnTokens(
939               _player
940             , _length
941         );
942 
943         // Burn ore
944         KingOfEthResource(oreContract).interfaceBurnTokens(
945               _player
946             , _length
947         );
948     }
949 
950     /// @dev The exchange can freeze tokens
951     /// @param _type The type of resource
952     /// @param _owner The owner of the tokens
953     /// @param _tokens The amount of tokens to freeze
954     function exchangeFreezeTokens(ResourceType _type, address _owner, uint _tokens)
955         public
956         onlyExchangeContract
957     {
958         KingOfEthResource(contractFor(_type)).interfaceFreezeTokens(_owner, _tokens);
959     }
960 
961     /// @dev The exchange can thaw tokens
962     /// @param _type The type of resource
963     /// @param _owner The owner of the tokens
964     /// @param _tokens The amount of tokens to thaw
965     function exchangeThawTokens(ResourceType _type, address _owner, uint _tokens)
966         public
967         onlyExchangeContract
968     {
969         KingOfEthResource(contractFor(_type)).interfaceThawTokens(_owner, _tokens);
970     }
971 
972     /// @dev The exchange can transfer tokens
973     /// @param _type The type of resource
974     /// @param _from The owner of the tokens
975     /// @param _to The new owner of the tokens
976     /// @param _tokens The amount of tokens to transfer
977     function exchangeTransfer(ResourceType _type, address _from, address _to, uint _tokens)
978         public
979         onlyExchangeContract
980     {
981         KingOfEthResource(contractFor(_type)).interfaceTransfer(_from, _to, _tokens);
982     }
983 
984     /// @dev The exchange can transfer frozend tokens
985     /// @param _type The type of resource
986     /// @param _from The owner of the tokens
987     /// @param _to The new owner of the tokens
988     /// @param _tokens The amount of frozen tokens to transfer
989     function exchangeFrozenTransfer(ResourceType _type, address _from, address _to, uint _tokens)
990         public
991         onlyExchangeContract
992     {
993         KingOfEthResource(contractFor(_type)).interfaceFrozenTransfer(_from, _to, _tokens);
994     }
995 }
996 
997 // File: contracts/KingOfEthResourceExchange.sol
998 
999 /****************************************************
1000  *
1001  * Copyright 2018 BurzNest LLC. All rights reserved.
1002  *
1003  * The contents of this file are provided for review
1004  * and educational purposes ONLY. You MAY NOT use,
1005  * copy, distribute, or modify this software without
1006  * explicit written permission from BurzNest LLC.
1007  *
1008  ****************************************************/
1009 
1010 pragma solidity ^0.4.24;
1011 
1012 
1013 
1014 
1015 
1016 /// @title King of Eth: Resource-to-Resource Exchange
1017 /// @author Anthony Burzillo <burz@burznest.com>
1018 /// @dev All the resource-to-resource exchange functionality
1019 contract KingOfEthResourceExchange is
1020       GodMode
1021     , KingOfEthResourcesInterfaceReferencer
1022     , KingOfEthResourceType
1023 {
1024     /// @dev Struct to hold data about a trade
1025     struct Trade {
1026         /// @dev The creator of the trade
1027         address creator;
1028 
1029         /// @dev The resource the trade is providing
1030         ResourceType resource;
1031 
1032         /// @dev The resource the trade is asking for
1033         ResourceType tradingFor;
1034 
1035         /// @dev The amount of the resource that is left to trade
1036         uint amountRemaining;
1037 
1038         /// @dev The number to multiply an amount by to get the size
1039         ///  for that amount
1040         uint numerator;
1041 
1042         /// @dev The number to divide an amount by to get the size
1043         ///  for that amount
1044         uint denominator;
1045     }
1046 
1047     /// @dev The id of the next trade created
1048     uint public nextTradeId;
1049 
1050     /// @dev Mapping of trade ids to info about the trade
1051     mapping (uint => Trade) trades;
1052 
1053     /// @dev Fired when a trade is created
1054     event ResourceTradeCreated(
1055           uint tradeId
1056         , ResourceType resource
1057         , ResourceType tradingFor
1058         , uint amountTrading
1059         , uint amountRequesting
1060         , address creator
1061     );
1062 
1063     /// @dev Fired when a trade is (partially) filled
1064     event ResourceTradeFilled(
1065           uint tradeId
1066         , ResourceType resource
1067         , ResourceType tradingFor
1068         , uint amount
1069         , uint numerator
1070         , uint denominator
1071         , address creator
1072         , address filler
1073     );
1074 
1075     /// @dev Fired when a trade is cancelled
1076     event ResourceTradeCancelled(
1077           uint tradeId
1078         , ResourceType resource
1079         , ResourceType tradingFor
1080         , uint amount
1081         , address creator
1082     );
1083 
1084     /// @param _interfaceContract The address of the resources
1085     ///  interface contract
1086     constructor(address _interfaceContract)
1087         public
1088     {
1089         interfaceContract = _interfaceContract;
1090     }
1091 
1092     /// @dev Create a trade
1093     /// @param _resource The resource the trade is providing
1094     /// @param _tradingFor The resource the trade is asking for
1095     /// @param _amountTrading The amount of the resource to trade
1096     /// @param _amountRequesting The amount of the other resource
1097     ///   to request
1098     /// @return The id of the trade
1099     function createTrade(
1100           ResourceType _resource
1101         , ResourceType _tradingFor
1102         , uint _amountTrading
1103         , uint _amountRequesting
1104     )
1105         public
1106         returns(uint)
1107     {
1108         // Don't allow ETH trades
1109         require(
1110                ResourceType.ETH != _resource
1111             && ResourceType.ETH != _tradingFor
1112         );
1113 
1114         // Don't allow trades for the same resource
1115         require(_resource != _tradingFor);
1116 
1117         // Require that the amount for trade is greater than 0
1118         require(0 < _amountTrading);
1119 
1120         // Require that the amount requested is greater than 0
1121         require(0 < _amountRequesting);
1122 
1123         // Freeze the amount of tokens for that resource
1124         KingOfEthResourcesInterface(interfaceContract).exchangeFreezeTokens(
1125               _resource
1126             , msg.sender
1127             , _amountTrading
1128         );
1129 
1130         // Set up the info about the trade
1131         trades[nextTradeId] = Trade(
1132               msg.sender
1133             , _resource
1134             , _tradingFor
1135             , _amountTrading // Amount remaining to trade
1136             , _amountRequesting
1137             , _amountTrading
1138         );
1139 
1140         emit ResourceTradeCreated(
1141               nextTradeId
1142             , _resource
1143             , _tradingFor
1144             , _amountTrading
1145             , _amountRequesting
1146             , msg.sender
1147         );
1148 
1149         // Return the trade id
1150         return nextTradeId++;
1151     }
1152 
1153     /// @dev Fill an amount of some trade
1154     /// @param _tradeId The id of the trade
1155     /// @param _amount The amount of the provided resource to fill
1156     function fillTrade(uint _tradeId, uint _amount) public
1157     {
1158         // Require a nonzero amount to be filled
1159         require(0 < _amount);
1160 
1161         // Lookup the trade
1162         Trade storage _trade = trades[_tradeId];
1163 
1164         // Require that at least the amount filling is available to trade
1165         require(_trade.amountRemaining >= _amount);
1166 
1167         // Start calculating the size of the resources filling with
1168         uint _size = _amount * _trade.numerator;
1169 
1170         // Ensure that the result is reversable (there is no overflow)
1171         require(_amount == _size / _trade.numerator);
1172 
1173         // Require that the resulting amount is a whole number
1174         require(0 == _size % _trade.denominator);
1175 
1176         // Finish the size calculation
1177         _size /= _trade.denominator;
1178 
1179         // Reduce the amount remaining by the amount being filled
1180         _trade.amountRemaining -= _amount;
1181 
1182         // Send the filler the creator's frozen resources
1183         KingOfEthResourcesInterface(interfaceContract).exchangeFrozenTransfer(
1184               _trade.resource
1185             , _trade.creator
1186             , msg.sender
1187             , _amount
1188         );
1189 
1190         // Send the creator the filler's resources
1191         KingOfEthResourcesInterface(interfaceContract).exchangeTransfer(
1192               _trade.tradingFor
1193             , msg.sender
1194             , _trade.creator
1195             , _size
1196         );
1197 
1198         emit ResourceTradeFilled(
1199               _tradeId
1200             , _trade.resource
1201             , _trade.tradingFor
1202             , _amount
1203             , _trade.numerator
1204             , _trade.denominator
1205             , _trade.creator
1206             , msg.sender
1207         );
1208     }
1209 
1210     /// @dev Cancel a trade
1211     /// @param _tradeId The trade's id
1212     function cancelTrade(uint _tradeId) public
1213     {
1214         // Lookup the trade's info
1215         Trade storage _trade = trades[_tradeId];
1216 
1217         // Require that the creator is cancelling the trade
1218         require(_trade.creator == msg.sender);
1219 
1220         // Save the amount remaining
1221         uint _amountRemaining = _trade.amountRemaining;
1222 
1223         // Set the amount remaining to trade to 0.
1224         // Note that this effectively cancels the trade
1225         _trade.amountRemaining = 0;
1226 
1227         // Thaw the creator's resource
1228         KingOfEthResourcesInterface(interfaceContract).exchangeThawTokens(
1229               _trade.resource
1230             , msg.sender
1231             , _amountRemaining
1232         );
1233 
1234         emit ResourceTradeCancelled(
1235               _tradeId
1236             , _trade.resource
1237             , _trade.tradingFor
1238             , _amountRemaining
1239             , msg.sender
1240         );
1241     }
1242 }