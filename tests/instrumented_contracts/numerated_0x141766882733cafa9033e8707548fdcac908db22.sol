1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     require(newOwner != address(0));
36     OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40 }
41 
42 /**
43  * @title EjectableOwnable
44  * @dev The EjectableOwnable contract provides the function to remove the ownership of the contract.
45  */
46 contract EjectableOwnable is Ownable {
47 
48     /**
49      * @dev Remove the ownership by setting the owner address to null,
50      * after calling this function, all onlyOwner function will be be able to be called by anyone anymore,
51      * the contract will achieve truly decentralisation.
52     */
53     function removeOwnership() onlyOwner public {
54         owner = 0x0;
55     }
56 
57 }
58 
59 /**
60  * @title JointOwnable
61  * @dev Extension for the Ownable contract, where the owner can assign at most 2 other addresses
62  *  to manage some functions of the contract, using the eitherOwner modifier.
63  *  Note that onlyOwner modifier would still be accessible only for the original owner.
64  */
65 contract JointOwnable is Ownable {
66 
67   event AnotherOwnerAssigned(address indexed anotherOwner);
68 
69   address public anotherOwner1;
70   address public anotherOwner2;
71 
72   /**
73    * @dev Throws if called by any account other than the owner or anotherOwner.
74    */
75   modifier eitherOwner() {
76     require(msg.sender == owner || msg.sender == anotherOwner1 || msg.sender == anotherOwner2);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to assign another owner.
82    * @param _anotherOwner The address to another owner.
83    */
84   function assignAnotherOwner1(address _anotherOwner) onlyOwner public {
85     require(_anotherOwner != 0);
86     AnotherOwnerAssigned(_anotherOwner);
87     anotherOwner1 = _anotherOwner;
88   }
89 
90   /**
91    * @dev Allows the current owner to assign another owner.
92    * @param _anotherOwner The address to another owner.
93    */
94   function assignAnotherOwner2(address _anotherOwner) onlyOwner public {
95     require(_anotherOwner != 0);
96     AnotherOwnerAssigned(_anotherOwner);
97     anotherOwner2 = _anotherOwner;
98   }
99 
100 }
101 
102 /**
103  * @title Pausable
104  * @dev Base contract which allows children to implement an emergency stop mechanism.
105  */
106 contract Pausable is Ownable {
107 
108   event Pause();
109   event Unpause();
110 
111   bool public paused = false;
112 
113   /**
114    * @dev Modifier to make a function callable only when the contract is not paused.
115    */
116   modifier whenNotPaused() {
117     require(!paused);
118     _;
119   }
120 
121   /**
122    * @dev Modifier to make a function callable only when the contract is paused.
123    */
124   modifier whenPaused() {
125     require(paused);
126     _;
127   }
128 
129   /**
130    * @dev called by the owner to pause, triggers stopped state
131    */
132   function pause() onlyOwner whenNotPaused public {
133     paused = true;
134     Pause();
135   }
136 
137   /**
138    * @dev called by the owner to unpause, returns to normal state
139    */
140   function unpause() onlyOwner whenPaused public {
141     paused = false;
142     Unpause();
143   }
144 
145 }
146 
147 /**
148  * @title Destructible
149  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
150  */
151 contract Destructible is Ownable {
152 
153   function Destructible() public payable { }
154 
155   /**
156    * @dev Transfers the current balance to the owner and terminates the contract.
157    */
158   function destroy() onlyOwner public {
159     selfdestruct(owner);
160   }
161 
162   function destroyAndSend(address _recipient) onlyOwner public {
163     selfdestruct(_recipient);
164   }
165 
166 }
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173 
174   /**
175   * @dev Multiplies two numbers, throws on overflow.
176   */
177   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178     if (a == 0) {
179       return 0;
180     }
181     uint256 c = a * b;
182     assert(c / a == b);
183     return c;
184   }
185 
186   /**
187   * @dev Integer division of two numbers, truncating the quotient.
188   */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     // assert(b > 0); // Solidity automatically throws when dividing by 0
191     uint256 c = a / b;
192     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193     return c;
194   }
195 
196   /**
197   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 
213 }
214 
215 /**
216  * @title PullPayment
217  * @dev Base contract supporting async send for pull payments. Inherit from this
218  * contract and use asyncSend instead of send.
219  */
220 contract PullPayment {
221 
222   using SafeMath for uint256;
223 
224   mapping(address => uint256) public payments;
225   uint256 public totalPayments;
226 
227   /**
228    * @dev withdraw accumulated balance, called by payee.
229    */
230   function withdrawPayments() public {
231     address payee = msg.sender;
232     uint256 payment = payments[payee];
233 
234     require(payment != 0);
235     require(this.balance >= payment);
236 
237     totalPayments = totalPayments.sub(payment);
238     payments[payee] = 0;
239 
240     assert(payee.send(payment));
241   }
242 
243   /**
244    * @dev Called by the payer to store the sent amount as credit to be pulled.
245    * @param dest The destination address of the funds.
246    * @param amount The amount to transfer.
247    */
248   function asyncSend(address dest, uint256 amount) internal {
249     payments[dest] = payments[dest].add(amount);
250     totalPayments = totalPayments.add(amount);
251   }
252 
253 }
254 
255 /**
256  * @title A simplified interface of ERC-721, but without approval functions
257  */
258 contract ERC721 {
259 
260     // Events
261     event Transfer(address indexed from, address indexed to, uint tokenId);
262 
263     // ERC20 compatible functions
264     // function name() public view returns (string);
265     // function symbol() public view returns (string);
266     function totalSupply() public view returns (uint);
267     function balanceOf(address _owner) public view returns (uint);
268 
269     // Functions that define ownership
270     function ownerOf(uint _tokenId) external view returns (address);
271     function transfer(address _to, uint _tokenId) external;
272 
273 }
274 
275 contract DungeonStructs {
276 
277     /**
278      * @dev The main Dungeon struct. Every dungeon in the game is represented by this structure.
279      * A dungeon is consists of an unlimited number of floors for your heroes to challenge,
280      * the power level of a dungeon is encoded in the floorGenes. Some dungeons are in fact more "challenging" than others,
281      * the secret formula for that is left for user to find out.
282      *
283      * Each dungeon also has a "training area", heroes can perform trainings and upgrade their stat,
284      * and some dungeons are more effective in the training, which is also a secret formula!
285      *
286      * When player challenge or do training in a dungeon, the fee will be collected as the dungeon rewards,
287      * which will be rewarded to the player who successfully challenged the current floor.
288      *
289      * Each dungeon fits in fits into three 256-bit words.
290      */
291     struct Dungeon {
292 
293         // Each dungeon has an ID which is the index in the storage array.
294 
295         // The timestamp of the block when this dungeon is created.
296         uint32 creationTime;
297 
298         // The status of the dungeon, each dungeon can have 5 status, namely:
299         // 0: Active | 1: Transport Only | 2: Challenge Only | 3: Train Only | 4: InActive
300         uint8 status;
301 
302         // The dungeon's difficulty, the higher the difficulty,
303         // normally, the "rarer" the seedGenes, the higher the diffculty,
304         // and the higher the contribution fee it is to challenge, train, and transport to the dungeon,
305         // the formula for the contribution fee is in DungeonChallenge and DungeonTraining contracts.
306         // A dungeon's difficulty never change.
307         uint8 difficulty;
308 
309         // The dungeon's capacity, maximum number of players allowed to stay on this dungeon.
310         // The capacity of the newbie dungeon (Holyland) is set at 0 (which is infinity).
311         // Using 16-bit unsigned integers can have a maximum of 65535 in capacity.
312         // A dungeon's capacity never change.
313         uint16 capacity;
314 
315         // The current floor number, a dungeon is consists of an umlimited number of floors,
316         // when there is heroes successfully challenged a floor, the next floor will be
317         // automatically generated. Using 32-bit unsigned integer can have a maximum of 4 billion floors.
318         uint32 floorNumber;
319 
320         // The timestamp of the block when the current floor is generated.
321         uint32 floorCreationTime;
322 
323         // Current accumulated rewards, successful challenger will get a large proportion of it.
324         uint128 rewards;
325 
326         // The seed genes of the dungeon, it is used as the base gene for first floor,
327         // some dungeons are rarer and some are more common, the exact details are,
328         // of course, top secret of the game!
329         // A dungeon's seedGenes never change.
330         uint seedGenes;
331 
332         // The genes for current floor, it encodes the difficulty level of the current floor.
333         // We considered whether to store the entire array of genes for all floors, but
334         // in order to save some precious gas we're willing to sacrifice some functionalities with that.
335         uint floorGenes;
336 
337     }
338 
339     /**
340      * @dev The main Hero struct. Every hero in the game is represented by this structure.
341      */
342     struct Hero {
343 
344         // Each hero has an ID which is the index in the storage array.
345 
346         // The timestamp of the block when this dungeon is created.
347         uint64 creationTime;
348 
349         // The timestamp of the block where a challenge is performed, used to calculate when a hero is allowed to engage in another challenge.
350         uint64 cooldownStartTime;
351 
352         // Every time a hero challenge a dungeon, its cooldown index will be incremented by one.
353         uint32 cooldownIndex;
354 
355         // The seed of the hero, the gene encodes the power level of the hero.
356         // This is another top secret of the game! Hero's gene can be upgraded via
357         // training in a dungeon.
358         uint genes;
359 
360     }
361 
362 }
363 
364 /**
365  * @title The ERC-721 compliance token contract for the Dungeon tokens.
366  * @dev See the DungeonStructs contract to see the details of the Dungeon token data structure.
367  */
368 contract DungeonToken is ERC721, DungeonStructs, Pausable, JointOwnable {
369 
370     /**
371      * @notice Limits the number of dungeons the contract owner can ever create.
372      */
373     uint public constant DUNGEON_CREATION_LIMIT = 1024;
374 
375     /**
376      * @dev The Mint event is fired whenever a new dungeon is created.
377      */
378     event Mint(address indexed owner, uint newTokenId, uint difficulty, uint capacity, uint seedGenes);
379 
380     /**
381      * @dev The NewDungeonFloor event is fired whenever a new dungeon floor is added.
382      */
383     event NewDungeonFloor(uint timestamp, uint indexed dungeonId, uint32 newFloorNumber, uint128 newRewards , uint newFloorGenes);
384 
385     /**
386      * @dev Transfer event as defined in current draft of ERC721. Emitted every time a token
387      *  ownership (Dungeon Master) is assigned, including token creation.
388      */
389     event Transfer(address indexed from, address indexed to, uint tokenId);
390 
391     /**
392      * @dev Name of token.
393      */
394     string public constant name = "Dungeon";
395 
396     /**
397      * @dev Symbol of token.
398      */
399     string public constant symbol = "DUNG";
400 
401     /**
402      * @dev An array containing the Dungeon struct, which contains all the dungeons in existance.
403      *  The ID for each dungeon is the index of this array.
404      */
405     Dungeon[] public dungeons;
406 
407     /**
408      * @dev A mapping from token IDs to the address that owns them.
409      */
410     mapping(uint => address) tokenIndexToOwner;
411 
412     /**
413      * @dev A mapping from owner address to count of tokens that address owns.
414      */
415     mapping(address => uint) ownershipTokenCount;
416 
417     /**
418      * Each non-fungible token owner can own more than one token at one time.
419      * Because each token is referenced by its unique ID, however,
420      * it can get difficult to keep track of the individual tokens that a user may own.
421      * To do this, the contract keeps a record of the IDs of each token that each user owns.
422      */
423     mapping(address => uint[]) public ownerTokens;
424 
425     /**
426      * @dev Returns the total number of tokens currently in existence.
427      */
428     function totalSupply() public view returns (uint) {
429         return dungeons.length;
430     }
431 
432     /**
433      * @dev Returns the number of tokens owned by a specific address.
434      * @param _owner The owner address to check.
435      */
436     function balanceOf(address _owner) public view returns (uint) {
437         return ownershipTokenCount[_owner];
438     }
439 
440     /**
441      * @dev Checks if a given address is the current owner of a particular token.
442      * @param _claimant The address we are validating against.
443      * @param _tokenId Token ID
444      */
445     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
446         return tokenIndexToOwner[_tokenId] == _claimant;
447     }
448 
449     /**
450      * @dev Returns the address currently assigned ownership of a given token.
451      */
452     function ownerOf(uint _tokenId) external view returns (address) {
453         require(tokenIndexToOwner[_tokenId] != address(0));
454 
455         return tokenIndexToOwner[_tokenId];
456     }
457 
458     /**
459      * @dev Assigns ownership of a specific token to an address.
460      */
461     function _transfer(address _from, address _to, uint _tokenId) internal {
462         // Increment the ownershipTokenCount.
463         ownershipTokenCount[_to]++;
464 
465         // Transfer ownership.
466         tokenIndexToOwner[_tokenId] = _to;
467 
468         // Add the _tokenId to ownerTokens[_to]
469         ownerTokens[_to].push(_tokenId);
470 
471         // When creating new token, _from is 0x0, but we can't account that address.
472         if (_from != address(0)) {
473             ownershipTokenCount[_from]--;
474 
475             // Remove the _tokenId from ownerTokens[_from]
476             uint[] storage fromTokens = ownerTokens[_from];
477             bool iFound = false;
478 
479             for (uint i = 0; i < fromTokens.length - 1; i++) {
480                 if (iFound) {
481                     fromTokens[i] = fromTokens[i + 1];
482                 } else if (fromTokens[i] == _tokenId) {
483                     iFound = true;
484                     fromTokens[i] = fromTokens[i + 1];
485                 }
486             }
487 
488             fromTokens.length--;
489         }
490 
491         // Emit the Transfer event.
492         Transfer(_from, _to, _tokenId);
493     }
494 
495     /**
496      * @dev External function to transfers a token to another address.
497      * @param _to The address of the recipient, can be a user or contract.
498      * @param _tokenId The ID of the token to transfer.
499      */
500     function transfer(address _to, uint _tokenId) whenNotPaused external {
501         // Safety check to prevent against an unexpected 0x0 default.
502         require(_to != address(0));
503 
504         // Disallow transfers to this contract to prevent accidental misuse.
505         require(_to != address(this));
506 
507         // You can only send your own token.
508         require(_owns(msg.sender, _tokenId));
509 
510         // Reassign ownership, clear pending approvals, emit Transfer event.
511         _transfer(msg.sender, _to, _tokenId);
512     }
513 
514     /**
515      * @dev Get an array of IDs of each token that an user owns.
516      */
517     function getOwnerTokens(address _owner) external view returns(uint[]) {
518         return ownerTokens[_owner];
519     }
520 
521     /**
522      * @dev The external function that creates a new dungeon and stores it, only contract owners
523      *  can create new token, and will be restricted by the DUNGEON_CREATION_LIMIT.
524      *  Will generate a Mint event, a  NewDungeonFloor event, and a Transfer event.
525      * @param _difficulty The difficulty of the new dungeon.
526      * @param _capacity The capacity of the new dungeon.
527      * @param _seedGenes The seed genes of the new dungeon.
528      * @param _firstFloorGenes The genes of the first dungeon floor.
529      * @return The dungeon ID of the new dungeon.
530      */
531     function createDungeon(uint _difficulty, uint _capacity, uint _seedGenes, uint _firstFloorGenes, address _owner) eitherOwner external returns (uint) {
532         // Ensure the total supply is within the fixed limit.
533         require(totalSupply() < DUNGEON_CREATION_LIMIT);
534 
535         // UPDATE STORAGE
536         // Create a new dungeon.
537         dungeons.push(Dungeon(uint32(now), 0, uint8(_difficulty), uint16(_capacity), 0, 0, 0, _seedGenes, 0));
538 
539         // Token id is the index in the storage array.
540         uint newTokenId = dungeons.length - 1;
541 
542         // Emit the token mint event.
543         Mint(_owner, newTokenId, _difficulty, _capacity, _seedGenes);
544 
545         // Initialize the fist floor, this will emit the NewDungeonFloor event.
546         addDungeonNewFloor(newTokenId, 0, _firstFloorGenes);
547 
548         // This will assign ownership, and also emit the Transfer event.
549         _transfer(0, _owner, newTokenId);
550 
551         return newTokenId;
552     }
553 
554     /**
555      * @dev The external function to set dungeon status by its ID,
556      *  refer to DungeonStructs for more information about dungeon status.
557      *  Only contract owners can alter dungeon state.
558      */
559     function setDungeonStatus(uint _id, uint _newStatus) eitherOwner tokenExists(_id) external {
560         dungeons[_id].status = uint8(_newStatus);
561     }
562 
563     /**
564      * @dev The external function to add additional dungeon rewards by its ID,
565      *  only contract owners can alter dungeon state.
566      */
567     function addDungeonRewards(uint _id, uint _additinalRewards) eitherOwner tokenExists(_id) external {
568         dungeons[_id].rewards += uint128(_additinalRewards);
569     }
570 
571     /**
572      * @dev The external function to add another dungeon floor by its ID,
573      *  only contract owners can alter dungeon state.
574      *  Will generate both a NewDungeonFloor event.
575      */
576     function addDungeonNewFloor(uint _id, uint _newRewards, uint _newFloorGenes) eitherOwner tokenExists(_id) public {
577         Dungeon storage dungeon = dungeons[_id];
578 
579         dungeon.floorNumber++;
580         dungeon.floorCreationTime = uint32(now);
581         dungeon.rewards = uint128(_newRewards);
582         dungeon.floorGenes = _newFloorGenes;
583 
584         // Emit the NewDungeonFloor event.
585         NewDungeonFloor(now, _id, dungeon.floorNumber, dungeon.rewards, dungeon.floorGenes);
586     }
587 
588 
589     /* ======== MODIFIERS ======== */
590 
591     /**
592      * @dev Throws if _dungeonId is not created yet.
593      */
594     modifier tokenExists(uint _tokenId) {
595         require(_tokenId < totalSupply());
596         _;
597     }
598 
599 }
600 
601 /**
602  * @title The ERC-721 compliance token contract for the Hero tokens.
603  * @dev See the DungeonStructs contract to see the details of the Hero token data structure.
604  */
605 contract HeroToken is ERC721, DungeonStructs, Pausable, JointOwnable {
606 
607     /**
608      * @dev The Mint event is fired whenever a new hero is created.
609      */
610     event Mint(address indexed owner, uint newTokenId, uint _genes);
611 
612     /**
613      * @dev Transfer event as defined in current draft of ERC721. Emitted every time a token
614      *  ownership is assigned, including token creation.
615      */
616     event Transfer(address indexed from, address indexed to, uint tokenId);
617 
618     /**
619      * @dev Name of token.
620      */
621     string public constant name = "Hero";
622 
623     /**
624      * @dev Symbol of token.
625      */
626     string public constant symbol = "HERO";
627 
628     /**
629      * @dev An array containing the Hero struct, which contains all the heroes in existance.
630      *  The ID for each hero is the index of this array.
631      */
632     Hero[] public heroes;
633 
634     /**
635      * @dev A mapping from token IDs to the address that owns them.
636      */
637     mapping(uint => address) tokenIndexToOwner;
638 
639     /**
640      * @dev A mapping from owner address to count of tokens that address owns.
641      */
642     mapping(address => uint) ownershipTokenCount;
643 
644     /**
645      * Each non-fungible token owner can own more than one token at one time.
646      * Because each token is referenced by its unique ID, however,
647      * it can get difficult to keep track of the individual tokens that a user may own.
648      * To do this, the contract keeps a record of the IDs of each token that each user owns.
649      */
650     mapping(address => uint[]) public ownerTokens;
651 
652     /**
653      * @dev Returns the total number of tokens currently in existence.
654      */
655     function totalSupply() public view returns (uint) {
656         return heroes.length;
657     }
658 
659     /**
660      * @dev Returns the number of tokens owned by a specific address.
661      * @param _owner The owner address to check.
662      */
663     function balanceOf(address _owner) public view returns (uint) {
664         return ownershipTokenCount[_owner];
665     }
666 
667     /**
668      * @dev Checks if a given address is the current owner of a particular token.
669      * @param _claimant The address we are validating against.
670      * @param _tokenId Token ID
671      */
672     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
673         return tokenIndexToOwner[_tokenId] == _claimant;
674     }
675 
676     /**
677      * @dev Returns the address currently assigned ownership of a given token.
678      */
679     function ownerOf(uint _tokenId) external view returns (address) {
680         require(tokenIndexToOwner[_tokenId] != address(0));
681 
682         return tokenIndexToOwner[_tokenId];
683     }
684 
685     /**
686      * @dev Assigns ownership of a specific token to an address.
687      */
688     function _transfer(address _from, address _to, uint _tokenId) internal {
689         // Increment the ownershipTokenCount.
690         ownershipTokenCount[_to]++;
691 
692         // Transfer ownership.
693         tokenIndexToOwner[_tokenId] = _to;
694 
695         // Add the _tokenId to ownerTokens[_to]
696         ownerTokens[_to].push(_tokenId);
697 
698         // When creating new token, _from is 0x0, but we can't account that address.
699         if (_from != address(0)) {
700             ownershipTokenCount[_from]--;
701 
702             // Remove the _tokenId from ownerTokens[_from]
703             uint[] storage fromTokens = ownerTokens[_from];
704             bool iFound = false;
705 
706             for (uint i = 0; i < fromTokens.length - 1; i++) {
707                 if (iFound) {
708                     fromTokens[i] = fromTokens[i + 1];
709                 } else if (fromTokens[i] == _tokenId) {
710                     iFound = true;
711                     fromTokens[i] = fromTokens[i + 1];
712                 }
713             }
714 
715             fromTokens.length--;
716         }
717 
718         // Emit the Transfer event.
719         Transfer(_from, _to, _tokenId);
720     }
721 
722     /**
723      * @dev External function to transfers a token to another address.
724      * @param _to The address of the recipient, can be a user or contract.
725      * @param _tokenId The ID of the token to transfer.
726      */
727     function transfer(address _to, uint _tokenId) whenNotPaused external {
728         // Safety check to prevent against an unexpected 0x0 default.
729         require(_to != address(0));
730 
731         // Disallow transfers to this contract to prevent accidental misuse.
732         require(_to != address(this));
733 
734         // You can only send your own token.
735         require(_owns(msg.sender, _tokenId));
736 
737         // Reassign ownership, clear pending approvals, emit Transfer event.
738         _transfer(msg.sender, _to, _tokenId);
739     }
740 
741     /**
742      * @dev Get an array of IDs of each token that an user owns.
743      */
744     function getOwnerTokens(address _owner) external view returns(uint[]) {
745         return ownerTokens[_owner];
746     }
747 
748     /**
749      * @dev An external function that creates a new hero and stores it,
750      *  only contract owners can create new token.
751      *  method doesn't do any checking and should only be called when the
752      *  input data is known to be valid.
753      * @param _genes The gene of the new hero.
754      * @param _owner The inital owner of this hero.
755      * @return The hero ID of the new hero.
756      */
757     function createHero(uint _genes, address _owner) eitherOwner external returns (uint) {
758         // UPDATE STORAGE
759         // Create a new hero.
760         heroes.push(Hero(uint64(now), 0, 0, _genes));
761 
762         // Token id is the index in the storage array.
763         uint newTokenId = heroes.length - 1;
764 
765         // Emit the token mint event.
766         Mint(_owner, newTokenId, _genes);
767 
768         // This will assign ownership, and also emit the Transfer event.
769         _transfer(0, _owner, newTokenId);
770 
771         return newTokenId;
772     }
773 
774     /**
775      * @dev The external function to set the hero genes by its ID,
776      *  only contract owners can alter hero state.
777      */
778     function setHeroGenes(uint _id, uint _newGenes) eitherOwner tokenExists(_id) external {
779         heroes[_id].genes = _newGenes;
780     }
781 
782     /**
783      * @dev Set the cooldownStartTime for the given hero. Also increments the cooldownIndex.
784      */
785     function triggerCooldown(uint _id) eitherOwner tokenExists(_id) external {
786         Hero storage hero = heroes[_id];
787 
788         hero.cooldownStartTime = uint64(now);
789         hero.cooldownIndex++;
790     }
791 
792 
793     /* ======== MODIFIERS ======== */
794 
795     /**
796      * @dev Throws if _dungeonId is not created yet.
797      */
798     modifier tokenExists(uint _tokenId) {
799         require(_tokenId < totalSupply());
800         _;
801     }
802 
803 }
804 
805 /**
806  * SECRET
807  */
808 contract ChallengeScienceInterface {
809 
810     /**
811      * @dev given genes of current floor and dungeon seed, return a genetic combination - may have a random factor.
812      * @param _floorGenes Genes of floor.
813      * @param _seedGenes Seed genes of dungeon.
814      * @return The resulting genes.
815      */
816     function mixGenes(uint _floorGenes, uint _seedGenes) external returns (uint);
817 
818 }
819 
820 /**
821  * SECRET
822  */
823 contract TrainingScienceInterface {
824 
825     /**
826      * @dev given genes of hero and current floor, return a genetic combination - may have a random factor.
827      * @param _heroGenes Genes of hero.
828      * @param _floorGenes Genes of current floor.
829      * @param _equipmentId Equipment index to train for, 0 is train all attributes.
830      * @return The resulting genes.
831      */
832     function mixGenes(uint _heroGenes, uint _floorGenes, uint _equipmentId) external returns (uint);
833 
834 }
835 
836 /**
837  * @title DungeonBase
838  * @dev Base contract for Ether Dungeon. It implements all necessary sub-classes,
839  * holds all the base storage variables, and some commonly used functions.
840  */
841 contract DungeonBase is EjectableOwnable, Pausable, PullPayment, DungeonStructs {
842 
843     /* ======== TOKEN CONTRACTS ======== */
844 
845     /**
846      * @dev The address of the ERC721 token contract managing all Dungeon tokens.
847      */
848     DungeonToken public dungeonTokenContract;
849 
850     /**
851      * @dev The address of the ERC721 token contract managing all Hero tokens.
852      */
853     HeroToken public heroTokenContract;
854 
855 
856     /* ======== CLOSED SOURCE CONTRACTS ======== */
857 
858     /**
859      * @dev The address of the ChallengeScience contract that handles the floor generation mechanics after challenge success.
860      */
861     ChallengeScienceInterface challengeScienceContract;
862 
863     /**
864      * @dev The address of the TrainingScience contract that handles the hero training mechanics.
865      */
866     TrainingScienceInterface trainingScienceContract;
867 
868 
869     /* ======== CONSTANTS ======== */
870 
871     uint16[32] EQUIPMENT_POWERS = [
872         1, 2, 4, 5, 16, 17, 18, 19, 0, 0, 0, 0, 0, 0, 0, 0,
873         4, 16, 32, 33, 0, 0, 0, 0, 32, 64, 0, 0, 128, 0, 0, 0
874     ];
875 
876     uint SUPER_HERO_MULTIPLIER = 32;
877 
878     /* ======== SETTER FUNCTIONS ======== */
879 
880     /**
881      * @dev Set the address of the dungeon token contract.
882      * @param _newDungeonTokenContract An address of a DungeonToken contract.
883      */
884     function setDungeonTokenContract(address _newDungeonTokenContract) onlyOwner external {
885         dungeonTokenContract = DungeonToken(_newDungeonTokenContract);
886     }
887 
888     /**
889      * @dev Set the address of the hero token contract.
890      * @param _newHeroTokenContract An address of a HeroToken contract.
891      */
892     function setHeroTokenContract(address _newHeroTokenContract) onlyOwner external {
893         heroTokenContract = HeroToken(_newHeroTokenContract);
894     }
895 
896     /**
897      * @dev Set the address of the secret dungeon challenge formula contract.
898      * @param _newChallengeScienceAddress An address of a ChallengeScience contract.
899      */
900     function setChallengeScienceContract(address _newChallengeScienceAddress) onlyOwner external {
901         challengeScienceContract = ChallengeScienceInterface(_newChallengeScienceAddress);
902     }
903 
904     /**
905      * @dev Set the address of the secret hero training formula contract.
906      * @param _newTrainingScienceAddress An address of a TrainingScience contract.
907      */
908     function setTrainingScienceContract(address _newTrainingScienceAddress) onlyOwner external {
909         trainingScienceContract = TrainingScienceInterface(_newTrainingScienceAddress);
910     }
911 
912 
913     /* ======== MODIFIERS ======== */
914 
915     /**
916      * @dev Throws if _dungeonId is not created yet.
917      */
918     modifier dungeonExists(uint _dungeonId) {
919         require(_dungeonId < dungeonTokenContract.totalSupply());
920         _;
921     }
922 
923 
924     /* ======== HELPER FUNCTIONS ======== */
925 
926     /**
927      * @dev An internal function to calculate the top 5 heroes power of a player.
928      */
929     function _getTop5HeroesPower(address _address, uint _dungeonId) internal view returns (uint) {
930         uint heroCount = heroTokenContract.balanceOf(_address);
931 
932         if (heroCount == 0) {
933             return 0;
934         }
935 
936         // Compute all hero powers for further calculation.
937         uint[] memory heroPowers = new uint[](heroCount);
938 
939         for (uint i = 0; i < heroCount; i++) {
940             uint heroId = heroTokenContract.ownerTokens(_address, i);
941             uint genes;
942             (,,, genes) = heroTokenContract.heroes(heroId);
943             // Power of dungeonId = 0 (no super hero boost).
944             heroPowers[i] = _getHeroPower(genes, _dungeonId);
945         }
946 
947         // Calculate the top 5 heroes power.
948         uint result;
949         uint curMax;
950         uint curMaxIndex;
951 
952         for (uint j; j < 5; j++){
953             for (uint k = 0; k < heroPowers.length; k++) {
954                 if (heroPowers[k] > curMax) {
955                     curMax = heroPowers[k];
956                     curMaxIndex = k;
957                 }
958             }
959 
960             result += curMax;
961             heroPowers[curMaxIndex] = 0;
962             curMax = 0;
963             curMaxIndex = 0;
964         }
965 
966         return result;
967     }
968 
969     /**
970      * @dev An internal function to calculate the power of a hero,
971      *  it calculates the base equipment power, stats power, and "Super" multiplier.
972      */
973     function _getHeroPower(uint _genes, uint _dungeonId) internal view returns (uint) {
974         uint difficulty;
975         (,, difficulty,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
976 
977         // Calculate total stats power.
978         uint statsPower;
979 
980         for (uint i = 0; i < 4; i++) {
981             statsPower += _genes % 32 + 1;
982             _genes /= 32 ** 4;
983         }
984 
985         // Calculate total equipment power.
986         uint equipmentPower;
987         uint superRank = _genes % 32;
988 
989         for (uint j = 4; j < 12; j++) {
990             uint curGene = _genes % 32;
991             equipmentPower += EQUIPMENT_POWERS[curGene];
992             _genes /= 32 ** 4;
993 
994             if (superRank != curGene) {
995                 superRank = 0;
996             }
997         }
998 
999         // Calculate super power boost.
1000         bool isSuper = superRank >= 16;
1001         uint superBoost;
1002 
1003         if (isSuper) {
1004             superBoost = (difficulty - 1) * SUPER_HERO_MULTIPLIER;
1005         }
1006 
1007         return statsPower + equipmentPower + superBoost;
1008     }
1009 
1010     /**
1011      * @dev An internal function to calculate the difficulty of a dungeon floor.
1012      */
1013     function _getDungeonPower(uint _genes) internal view returns (uint) {
1014         // Calculate total dungeon power.
1015         uint dungeonPower;
1016 
1017         for (uint j = 0; j < 12; j++) {
1018             dungeonPower += EQUIPMENT_POWERS[_genes % 32];
1019             _genes /= 32 ** 4;
1020         }
1021 
1022         return dungeonPower;
1023     }
1024 
1025 }
1026 
1027 contract DungeonTransportation is DungeonBase {
1028 
1029     /**
1030      * @dev The PlayerTransported event is fired when user transported to another dungeon.
1031      */
1032     event PlayerTransported(uint timestamp, address indexed playerAddress, uint indexed originDungeonId, uint indexed destinationDungeonId);
1033 
1034 
1035     /* ======== GAME SETTINGS ======== */
1036 
1037     /**
1038      * @notice The actual fee contribution required to call transport() is calculated by this feeMultiplier,
1039      *  times the dungeon difficulty of destination dungeon. The payment is accumulated to the rewards of the origin dungeon,
1040      *  and a large proportion will be claimed by whoever successfully challenged the floor.
1041      *  1000 szabo = 0.001 ether
1042      */
1043     uint public transportationFeeMultiplier = 500 szabo;
1044 
1045 
1046     /* ======== STORAGE ======== */
1047 
1048 
1049     /**
1050      * @dev A mapping from token IDs to the address that owns them.
1051      */
1052     mapping(address => uint) public playerToDungeonID;
1053 
1054     /**
1055      * @dev A mapping from owner address to count of tokens that address owns.
1056      */
1057     mapping(uint => uint) public dungeonPlayerCount;
1058 
1059     /**
1060      * @dev The main external function to call when a player transport to another dungeon.
1061      *  Will generate a PlayerTransported event.
1062      */
1063     function transport(uint _destinationDungeonId) whenNotPaused dungeonCanTransport(_destinationDungeonId) external payable {
1064         uint originDungeonId = playerToDungeonID[msg.sender];
1065 
1066         // Disallow transport to the same dungeon.
1067         require(_destinationDungeonId != originDungeonId);
1068 
1069         // Get the dungeon details from the token contract.
1070         uint difficulty;
1071         uint capacity;
1072         (,, difficulty, capacity,,,,,) = dungeonTokenContract.dungeons(_destinationDungeonId);
1073 
1074         // Disallow weaker user to transport to "difficult" dungeon.
1075         uint top5HeroesPower = _getTop5HeroesPower(msg.sender, _destinationDungeonId);
1076         require(top5HeroesPower >= difficulty * 12);
1077 
1078         // Checks for payment, any exceeding funds will be transferred back to the player.
1079         uint baseFee = difficulty * transportationFeeMultiplier;
1080         uint additionalFee = top5HeroesPower / 48 * transportationFeeMultiplier;
1081         uint requiredFee = baseFee + additionalFee;
1082         require(msg.value >= requiredFee);
1083 
1084         // ** STORAGE UPDATE **
1085         // Increment the accumulated rewards for the dungeon.
1086         dungeonTokenContract.addDungeonRewards(originDungeonId, requiredFee);
1087 
1088         // Calculate any excess funds and make it available to be withdrawed by the player.
1089         asyncSend(msg.sender, msg.value - requiredFee);
1090 
1091         _transport(originDungeonId, _destinationDungeonId);
1092     }
1093 
1094     /**
1095      * Private function to assigns location of a player
1096      */
1097     function _transport(uint _originDungeonId, uint _destinationDungeonId) private {
1098         // If a player do not have any hero, claim first hero.
1099         if (heroTokenContract.balanceOf(msg.sender) == 0) {
1100             claimHero();
1101         }
1102 
1103         // ** STORAGE UPDATE **
1104         // Update the ownershipTokenCount.
1105         dungeonPlayerCount[_originDungeonId]--;
1106         dungeonPlayerCount[_destinationDungeonId]++;
1107 
1108         // ** STORAGE UPDATE **
1109         // Update player location.
1110         playerToDungeonID[msg.sender] = _destinationDungeonId;
1111 
1112         // Emit the DungeonChallenged event.
1113         PlayerTransported(now, msg.sender, _originDungeonId, _destinationDungeonId);
1114     }
1115 
1116 
1117     /* ======== OWNERSHIP FUNCTIONS ======== */
1118 
1119     /**
1120      * @notice Used in transport, challenge and train, to get the genes of a specific hero,
1121      *  a claim a hero if didn't have any.
1122      */
1123     function _getHeroGenesOrClaimFirstHero(uint _heroId) internal returns (uint heroId, uint heroGenes) {
1124         heroId = _heroId;
1125 
1126         // If a player do not have any hero, claim first hero first.
1127         if (heroTokenContract.balanceOf(msg.sender) == 0) {
1128             heroId = claimHero();
1129         }
1130 
1131         (,,,heroGenes) = heroTokenContract.heroes(heroId);
1132     }
1133 
1134     /**
1135      * @dev Claim a new hero with empty genes.
1136      */
1137     function claimHero() public returns (uint) {
1138         // If a player do not tranport to any dungeon yet, and it is the first time claiming the hero,
1139         // set the dungeon location, increment the #0 Holyland player count by 1.
1140         if (playerToDungeonID[msg.sender] == 0 && heroTokenContract.balanceOf(msg.sender) == 0) {
1141             dungeonPlayerCount[0]++;
1142         }
1143 
1144         return heroTokenContract.createHero(0, msg.sender);
1145     }
1146 
1147 
1148     /* ======== SETTER FUNCTIONS ======== */
1149 
1150     /**
1151      * @dev Updates the fee contribution multiplier required for calling transport().
1152      */
1153     function setTransportationFeeMultiplier(uint _newTransportationFeeMultiplier) onlyOwner external {
1154         transportationFeeMultiplier = _newTransportationFeeMultiplier;
1155     }
1156 
1157 
1158     /* ======== MODIFIERS ======== */
1159 
1160     /**
1161      * @dev Throws if dungeon status do not allow transportation, also check for dungeon existence.
1162      *  Also check if the capacity of the destination dungeon is reached.
1163      */
1164     modifier dungeonCanTransport(uint _destinationDungeonId) {
1165         require(_destinationDungeonId < dungeonTokenContract.totalSupply());
1166         uint status;
1167         uint capacity;
1168         (,status,,capacity,,,,,) = dungeonTokenContract.dungeons(_destinationDungeonId);
1169         require(status == 0 || status == 1);
1170 
1171         // Check if the capacity of the destination dungeon is reached.
1172         // Capacity 0 = Infinity
1173         require(capacity == 0 || dungeonPlayerCount[_destinationDungeonId] < capacity);
1174         _;
1175     }
1176 
1177 }
1178 
1179 contract DungeonChallenge is DungeonTransportation {
1180 
1181     /**
1182      * @dev The DungeonChallenged event is fired when user finished a dungeon challenge.
1183      */
1184     event DungeonChallenged(uint timestamp, address indexed playerAddress, uint indexed dungeonId, uint indexed heroId, uint heroGenes, uint floorNumber, uint floorGenes, bool success, uint newFloorGenes, uint successRewards, uint masterRewards);
1185 
1186 
1187     /* ======== GAME SETTINGS ======== */
1188 
1189     /**
1190      * @notice The actual fee contribution required to call challenge() is calculated by this feeMultiplier,
1191      *  times the dungeon difficulty. The payment is accumulated to the dungeon rewards,
1192      *  and a large proportion will be claimed by whoever successfully challenged the floor.
1193      *  1 finney = 0.001 ether
1194      */
1195     uint public challengeFeeMultiplier = 1 finney;
1196 
1197     /**
1198      * @dev The percentage for which successful challenger be rewarded of the dungeons' accumulated rewards.
1199      *  The remaining rewards subtract dungeon master rewards will be used as the base rewards for new floor.
1200      */
1201     uint public challengeRewardsPercent = 64;
1202 
1203     /**
1204      * @dev The developer fee for owner
1205      *  Note that when Ether Dungeon becomes truly decentralised, contract ownership will be ejected,
1206      *  and the master rewards will be rewarded to the dungeon owner (Dungeon Masters).
1207      */
1208     uint public masterRewardsPercent = 8;
1209 
1210     /**
1211      * @dev The cooldown time period where a hero can engage in challenge again.
1212      *  This settings will likely be changed to 20 minutes when multiple heroes system is launched in Version 1.
1213      */
1214     uint public challengeCooldownTime = 3 minutes;
1215 
1216     /**
1217      * @dev The preparation time period where a new dungeon is created, before it can be challenged.
1218      *  This settings will likely be changed to a smaller period (e.g. 20-30 minutes) .
1219      */
1220     uint public dungeonPreparationTime = 60 minutes;
1221 
1222     /**
1223      * @dev The challenge rewards percentage used right after the preparation period.
1224      */
1225     uint public rushTimeChallengeRewardsPercent = 30;
1226 
1227     /**
1228      * @dev The number of floor in which the rushTimeChallengeRewardsPercent be applied.
1229      */
1230     uint public rushTimeFloorCount = 30;
1231 
1232     /**
1233      * @dev The main external function to call when a player challenge a dungeon,
1234      *  it determines whether if the player successfully challenged the current floor.
1235      *  Will generate a DungeonChallenged event.
1236      */
1237     function challenge(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanChallenge(_dungeonId) heroAllowedToChallenge(_heroId) external payable {
1238         // Get the dungeon details from the token contract.
1239         uint difficulty;
1240         uint seedGenes;
1241         (,, difficulty,,,,, seedGenes,) = dungeonTokenContract.dungeons(_dungeonId);
1242 
1243         // Checks for payment, any exceeding funds will be transferred back to the player.
1244         uint requiredFee = difficulty * challengeFeeMultiplier;
1245         require(msg.value >= requiredFee);
1246 
1247         // ** STORAGE UPDATE **
1248         // Increment the accumulated rewards for the dungeon.
1249         dungeonTokenContract.addDungeonRewards(_dungeonId, requiredFee);
1250 
1251         // Calculate any excess funds and make it available to be withdrawed by the player.
1252         asyncSend(msg.sender, msg.value - requiredFee);
1253 
1254         // Split the challenge function into multiple parts because of stack too deep error.
1255         _challengePart2(_dungeonId, _heroId);
1256     }
1257 
1258     /**
1259      * Split the challenge function into multiple parts because of stack too deep error.
1260      */
1261     function _challengePart2(uint _dungeonId, uint _heroId) private {
1262         uint floorNumber;
1263         uint rewards;
1264         uint floorGenes;
1265         (,,,, floorNumber,, rewards,, floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1266 
1267         // Get the hero gene, or claim first hero.
1268         uint heroGenes;
1269         (_heroId, heroGenes) = _getHeroGenesOrClaimFirstHero(_heroId);
1270 
1271         bool success = _getChallengeSuccess(heroGenes, _dungeonId, floorGenes);
1272 
1273         uint newFloorGenes;
1274         uint masterRewards;
1275         uint successRewards;
1276         uint newRewards;
1277 
1278         // Whether a challenge is success or not is determined by a simple comparison between hero power and floor power.
1279         if (success) {
1280             newFloorGenes = _getNewFloorGene(_dungeonId);
1281 
1282             masterRewards = rewards * masterRewardsPercent / 100;
1283 
1284             if (floorNumber < rushTimeFloorCount) { // rush time right after prepration period
1285                 successRewards = rewards * rushTimeChallengeRewardsPercent / 100;
1286 
1287                 // The dungeon rewards for new floor as total rewards - challenge rewards - devleoper fee.
1288                 newRewards = rewards * (100 - rushTimeChallengeRewardsPercent - masterRewardsPercent) / 100;
1289             } else {
1290                 successRewards = rewards * challengeRewardsPercent / 100;
1291                 newRewards = rewards * (100 - challengeRewardsPercent - masterRewardsPercent) / 100;
1292             }
1293 
1294             // TRIPLE CONFIRM sanity check.
1295             require(successRewards + masterRewards + newRewards <= rewards);
1296 
1297             // ** STORAGE UPDATE **
1298             // Add new floor with the new floor genes and new rewards.
1299             dungeonTokenContract.addDungeonNewFloor(_dungeonId, newRewards, newFloorGenes);
1300 
1301             // Mark the challenge rewards available to be withdrawed by the player.
1302             asyncSend(msg.sender, successRewards);
1303 
1304             // Mark the master rewards available to be withdrawed by the dungeon master.
1305             asyncSend(dungeonTokenContract.ownerOf(_dungeonId), masterRewards);
1306         }
1307 
1308         // ** STORAGE UPDATE **
1309         // Trigger the cooldown for the hero.
1310         heroTokenContract.triggerCooldown(_heroId);
1311 
1312         // Emit the DungeonChallenged event.
1313         DungeonChallenged(now, msg.sender, _dungeonId, _heroId, heroGenes, floorNumber, floorGenes, success, newFloorGenes, successRewards, masterRewards);
1314     }
1315 
1316     /**
1317      * Split the challenge function into multiple parts because of stack too deep error.
1318      */
1319     function _getChallengeSuccess(uint _heroGenes, uint _dungeonId, uint _floorGenes) private view returns (bool) {
1320         // Determine if the player challenge successfuly the dungeon or not.
1321         uint heroPower = _getHeroPower(_heroGenes, _dungeonId);
1322         uint floorPower = _getDungeonPower(_floorGenes);
1323 
1324         return heroPower > floorPower;
1325     }
1326 
1327     /**
1328      * Split the challenge function into multiple parts because of stack too deep error.
1329      */
1330     function _getNewFloorGene(uint _dungeonId) private returns (uint) {
1331         uint seedGenes;
1332         uint floorGenes;
1333         (,,,,,, seedGenes, floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1334 
1335         // Calculate the new floor gene.
1336         uint floorPower = _getDungeonPower(floorGenes);
1337 
1338         // Call the external closed source secret function that determines the resulting floor "genes".
1339         uint newFloorGenes = challengeScienceContract.mixGenes(floorGenes, seedGenes);
1340 
1341         uint newFloorPower = _getDungeonPower(newFloorGenes);
1342 
1343         // If the power decreased, rollback to the current floor genes.
1344         if (newFloorPower < floorPower) {
1345             newFloorGenes = floorGenes;
1346         }
1347 
1348         return newFloorGenes;
1349     }
1350 
1351 
1352     /* ======== SETTER FUNCTIONS ======== */
1353 
1354     /**
1355      * @dev Updates the fee contribution multiplier required for calling challenge().
1356      */
1357     function setChallengeFeeMultiplier(uint _newChallengeFeeMultiplier) onlyOwner external {
1358         challengeFeeMultiplier = _newChallengeFeeMultiplier;
1359     }
1360 
1361     /**
1362      * @dev Updates the challenge rewards pecentage.
1363      */
1364     function setChallengeRewardsPercent(uint _newChallengeRewardsPercent) onlyOwner external {
1365         challengeRewardsPercent = _newChallengeRewardsPercent;
1366     }
1367 
1368     /**
1369      * @dev Updates the master rewards percentage.
1370      */
1371     function setMasterRewardsPercent(uint _newMasterRewardsPercent) onlyOwner external {
1372         masterRewardsPercent = _newMasterRewardsPercent;
1373     }
1374 
1375     /**
1376      * @dev Updates the challenge cooldown time.
1377      */
1378     function setChallengeCooldownTime(uint _newChallengeCooldownTime) onlyOwner external {
1379         challengeCooldownTime = _newChallengeCooldownTime;
1380     }
1381 
1382     /**
1383      * @dev Updates the challenge cooldown time.
1384      */
1385     function setDungeonPreparationTime(uint _newDungeonPreparationTime) onlyOwner external {
1386         dungeonPreparationTime = _newDungeonPreparationTime;
1387     }
1388 
1389     /**
1390      * @dev Updates the rush time challenge rewards percentage.
1391      */
1392     function setRushTimeChallengeRewardsPercent(uint _newRushTimeChallengeRewardsPercent) onlyOwner external {
1393         rushTimeChallengeRewardsPercent = _newRushTimeChallengeRewardsPercent;
1394     }
1395 
1396     /**
1397      * @dev Updates the rush time floor count.
1398      */
1399     function setRushTimeFloorCount(uint _newRushTimeFloorCount) onlyOwner external {
1400         rushTimeFloorCount = _newRushTimeFloorCount;
1401     }
1402 
1403 
1404     /* ======== MODIFIERS ======== */
1405 
1406     /**
1407      * @dev Throws if dungeon status do not allow challenge, also check for dungeon existence.
1408      *  Also check if the user is in the dungeon.
1409      *  Also check if the dungeon is not in preparation period.
1410      */
1411     modifier dungeonCanChallenge(uint _dungeonId) {
1412         require(_dungeonId < dungeonTokenContract.totalSupply());
1413         uint creationTime;
1414         uint status;
1415         (creationTime, status,,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
1416         require(status == 0 || status == 2);
1417 
1418         // Check if the user is in the dungeon.
1419         require(playerToDungeonID[msg.sender] == _dungeonId);
1420 
1421         // Check if the dungeon is not in preparation period.
1422         require(creationTime + dungeonPreparationTime <= now);
1423         _;
1424     }
1425 
1426     /**
1427      * @dev Throws if player does not own the hero, or it is still in cooldown.
1428      *  Unless the player does not have any hero yet, which will auto claim one during first challenge / train.
1429      */
1430     modifier heroAllowedToChallenge(uint _heroId) {
1431         if (heroTokenContract.balanceOf(msg.sender) > 0) {
1432             // You can only challenge with your own hero.
1433             require(heroTokenContract.ownerOf(_heroId) == msg.sender);
1434 
1435             uint cooldownStartTime;
1436             (, cooldownStartTime,,) = heroTokenContract.heroes(_heroId);
1437             require(cooldownStartTime + challengeCooldownTime <= now);
1438         }
1439         _;
1440     }
1441 
1442 }
1443 
1444 contract DungeonTraining is DungeonChallenge {
1445 
1446     /**
1447      * @dev The HeroTrained event is fired when user finished a training.
1448      */
1449     event HeroTrained(uint timestamp, address indexed playerAddress, uint indexed dungeonId, uint indexed heroId, uint heroGenes, uint floorNumber, uint floorGenes, bool success, uint newHeroGenes);
1450 
1451 
1452     /* ======== GAME SETTINGS ======== */
1453 
1454     /**
1455      * @dev The actual fee contribution required to call trainX() is calculated by this feeMultiplier,
1456      *  times the dungeon difficulty, times X. The payment is accumulated to the dungeon rewards,
1457      *  and a large proportion will be claimed by whoever successfully challenged the floor.
1458      *  1 finney = 0.001 ether
1459      */
1460     uint public trainingFeeMultiplier = 2 finney;
1461 
1462     /**
1463      * @dev The discounted training fee multiplier to be used in the preparation period.
1464      * 1000 szabo = 0.001 ether
1465      */
1466     uint public preparationPeriodTrainingFeeMultiplier = 1800 szabo;
1467 
1468     /**
1469      * @dev The actual fee contribution required to call trainEquipment() is calculated by this feeMultiplier,
1470      *  times the dungeon difficulty, times X. The payment is accumulated to the dungeon rewards,
1471      *  and a large proportion will be claimed by whoever successfully challenged the floor.
1472      *  (No preparation period discount on equipment training.)
1473      *  1000 szabo = 0.001 ether
1474      */
1475     uint public equipmentTrainingFeeMultiplier = 500 szabo;
1476 
1477     /**
1478      * @dev The external function to call when a hero train with a dungeon,
1479      *  it determines whether whether a training is successfully, and the resulting genes.
1480      *  Will generate a DungeonChallenged event.
1481      */
1482     function train1(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1483         _train(_dungeonId, _heroId, 0, 1);
1484     }
1485 
1486     function train2(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1487         _train(_dungeonId, _heroId, 0, 2);
1488     }
1489 
1490     function train3(uint _dungeonId, uint _heroId) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1491         _train(_dungeonId, _heroId, 0, 3);
1492     }
1493 
1494     /**
1495      * @dev The external function to call when a hero train a particular equipment with a dungeon,
1496      *  it determines whether whether a training is successfully, and the resulting genes.
1497      *  Will generate a DungeonChallenged event.
1498      *  _equipmentIndex is the index of equipment: 0 is train all attributes, including equipments and stats.
1499      *  1: weapon | 2: shield | 3: armor | 4: shoe | 5: helmet | 6: gloves | 7: belt | 8: shawl
1500      */
1501     function trainEquipment(uint _dungeonId, uint _heroId, uint _equipmentIndex) whenNotPaused dungeonCanTrain(_dungeonId) heroAllowedToTrain(_heroId) external payable {
1502         require(_equipmentIndex <= 8);
1503 
1504         _train(_dungeonId, _heroId, _equipmentIndex, 1);
1505     }
1506 
1507     /**
1508      * @dev An internal function of a hero train with dungeon,
1509      *  it determines whether whether a training is successfully, and the resulting genes.
1510      *  Will generate a DungeonChallenged event.
1511      */
1512     function _train(uint _dungeonId, uint _heroId, uint _equipmentIndex, uint _trainingTimes) private {
1513         // Get the dungeon details from the token contract.
1514         uint creationTime;
1515         uint difficulty;
1516         uint floorNumber;
1517         uint rewards;
1518         uint seedGenes;
1519         uint floorGenes;
1520         (creationTime,,difficulty,,floorNumber,,rewards,seedGenes,floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1521 
1522         // Check for _trainingTimes abnormality, we probably won't have any feature that train a hero 10 times with a single call.
1523         require(_trainingTimes < 10);
1524 
1525         // Checks for payment, any exceeding funds will be transferred back to the player.
1526         uint requiredFee;
1527 
1528         if (_equipmentIndex > 0) { // train specific equipments
1529             requiredFee = difficulty * equipmentTrainingFeeMultiplier * _trainingTimes;
1530         } else if (now < creationTime + dungeonPreparationTime) { // train all attributes, preparation period
1531             requiredFee = difficulty * preparationPeriodTrainingFeeMultiplier * _trainingTimes;
1532         } else { // train all attributes, normal period
1533             requiredFee = difficulty * trainingFeeMultiplier * _trainingTimes;
1534         }
1535 
1536         require(msg.value >= requiredFee);
1537 
1538         // Get the hero gene, or claim first hero.
1539         uint heroGenes;
1540         (_heroId, heroGenes) = _getHeroGenesOrClaimFirstHero(_heroId);
1541 
1542         // ** STORAGE UPDATE **
1543         // Increment the accumulated rewards for the dungeon.
1544         dungeonTokenContract.addDungeonRewards(_dungeonId, requiredFee);
1545 
1546         // Calculate any excess funds and make it available to be withdrawed by the player.
1547         asyncSend(msg.sender, msg.value - requiredFee);
1548 
1549         // Split the _train function into multiple parts because of stack too deep error.
1550         _trainPart2(_dungeonId, _heroId, heroGenes, _equipmentIndex, _trainingTimes);
1551     }
1552 
1553     /**
1554      * Split the _train function into multiple parts because of Stack Too Deep error.
1555      */
1556     function _trainPart2(uint _dungeonId, uint _heroId, uint _heroGenes, uint _equipmentIndex, uint _trainingTimes) private {
1557         // Get the dungeon details from the token contract.
1558         uint floorNumber;
1559         uint floorGenes;
1560         (,,,, floorNumber,,,, floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1561 
1562         // Determine if the hero training is successful or not, and the resulting genes.
1563         uint heroPower = _getHeroPower(_heroGenes, _dungeonId);
1564 
1565         uint newHeroGenes = _heroGenes;
1566         uint newHeroPower = heroPower;
1567 
1568         // Train the hero multiple times according to _trainingTimes,
1569         // each time if the resulting power is larger, update new hero power.
1570         for (uint i = 0; i < _trainingTimes; i++) {
1571             // Call the external closed source secret function that determines the resulting hero "genes".
1572             uint tmpHeroGenes = trainingScienceContract.mixGenes(newHeroGenes, floorGenes, _equipmentIndex);
1573 
1574             uint tmpHeroPower = _getHeroPower(tmpHeroGenes, _dungeonId);
1575 
1576             if (tmpHeroPower > newHeroPower) {
1577                 newHeroGenes = tmpHeroGenes;
1578                 newHeroPower = tmpHeroPower;
1579             }
1580         }
1581 
1582         // Prevent reduced power.
1583         if (newHeroPower > heroPower) {
1584             // ** STORAGE UPDATE **
1585             // Set the upgraded hero genes.
1586             heroTokenContract.setHeroGenes(_heroId, newHeroGenes);
1587         }
1588 
1589         // Emit the HeroTrained event.
1590         HeroTrained(now, msg.sender, _dungeonId, _heroId, _heroGenes, floorNumber, floorGenes, newHeroPower > heroPower, newHeroGenes);
1591     }
1592 
1593 
1594     /* ======== SETTER FUNCTIONS ======== */
1595 
1596     /// @dev Updates the fee contribution multiplier required for calling trainX().
1597     function setTrainingFeeMultiplier(uint _newTrainingFeeMultiplier) onlyOwner external {
1598         trainingFeeMultiplier = _newTrainingFeeMultiplier;
1599     }
1600 
1601     /// @dev Updates the fee contribution multiplier for preparation period required for calling trainX().
1602     function setPreparationPeriodTrainingFeeMultiplier(uint _newPreparationPeriodTrainingFeeMultiplier) onlyOwner external {
1603         preparationPeriodTrainingFeeMultiplier = _newPreparationPeriodTrainingFeeMultiplier;
1604     }
1605 
1606     /// @dev Updates the fee contribution multiplier required for calling trainEquipment().
1607     function setEquipmentTrainingFeeMultiplier(uint _newEquipmentTrainingFeeMultiplier) onlyOwner external {
1608         equipmentTrainingFeeMultiplier = _newEquipmentTrainingFeeMultiplier;
1609     }
1610 
1611 
1612     /* ======== MODIFIERS ======== */
1613 
1614     /**
1615      * @dev Throws if dungeon status do not allow training, also check for dungeon existence.
1616      *  Also check if the user is in the dungeon.
1617      */
1618     modifier dungeonCanTrain(uint _dungeonId) {
1619         require(_dungeonId < dungeonTokenContract.totalSupply());
1620         uint status;
1621         (,status,,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
1622         require(status == 0 || status == 3);
1623 
1624         // Also check if the user is in the dungeon.
1625         require(playerToDungeonID[msg.sender] == _dungeonId);
1626         _;
1627     }
1628 
1629     /**
1630      * @dev Throws if player does not own the hero.
1631      *  Unless the player does not have any hero yet, which will auto claim one during first challenge / train.
1632      */
1633     modifier heroAllowedToTrain(uint _heroId) {
1634         if (heroTokenContract.balanceOf(msg.sender) > 0) {
1635             // You can only train with your own hero.
1636             require(heroTokenContract.ownerOf(_heroId) == msg.sender);
1637         }
1638         _;
1639     }
1640 
1641 
1642 }
1643 
1644 /**
1645  * @title DungeonCoreBeta
1646  * @dev Core Contract of Ether Dungeon.
1647  *  When Version 1 launches, DungeonCoreVersion1 contract will be deployed and DungeonCoreBeta will be destroyed.
1648  *  Since all dungeons and heroes are stored as tokens in external contracts, they remains immutable.
1649  */
1650 contract DungeonCoreBeta is Destructible, DungeonTraining {
1651 
1652     /**
1653      * Initialize the DungeonCore contract with all the required contract addresses.
1654      */
1655     function DungeonCoreBeta(
1656         address _dungeonTokenAddress,
1657         address _heroTokenAddress,
1658         address _challengeScienceAddress,
1659         address _trainingScienceAddress
1660     ) public {
1661         dungeonTokenContract = DungeonToken(_dungeonTokenAddress);
1662         heroTokenContract = HeroToken(_heroTokenAddress);
1663         challengeScienceContract = ChallengeScienceInterface(_challengeScienceAddress);
1664         trainingScienceContract = TrainingScienceInterface(_trainingScienceAddress);
1665     }
1666 
1667     /**
1668      * @dev The external function to get all the relevant information about a specific dungeon by its ID.
1669      * @param _id The ID of the dungeon.
1670      */
1671     function getDungeonDetails(uint _id) external view returns (uint creationTime, uint status, uint difficulty, uint capacity, bool isReady, uint playerCount) {
1672         require(_id < dungeonTokenContract.totalSupply());
1673 
1674         // Didn't get the "floorCreationTime" because of Stack Too Deep error.
1675         (creationTime, status, difficulty, capacity,,,,,) = dungeonTokenContract.dungeons(_id);
1676 
1677         // Dungeon is ready to be challenged (not in preparation mode).
1678         isReady = creationTime + dungeonPreparationTime <= now;
1679         playerCount = dungeonPlayerCount[_id];
1680     }
1681 
1682     /**
1683      * @dev Split floor related details out of getDungeonDetails, just to avoid Stack Too Deep error.
1684      * @param _id The ID of the dungeon.
1685      */
1686     function getDungeonFloorDetails(uint _id) external view returns (uint floorNumber, uint floorCreationTime, uint rewards, uint seedGenes, uint floorGenes) {
1687         require(_id < dungeonTokenContract.totalSupply());
1688 
1689         // Didn't get the "floorCreationTime" because of Stack Too Deep error.
1690         (,,,, floorNumber, floorCreationTime, rewards, seedGenes, floorGenes) = dungeonTokenContract.dungeons(_id);
1691     }
1692 
1693     /**
1694      * @dev The external function to get all the relevant information about a specific hero by its ID.
1695      * @param _id The ID of the hero.
1696      */
1697     function getHeroDetails(uint _id) external view returns (uint creationTime, uint cooldownStartTime, uint cooldownIndex, uint genes, bool isReady) {
1698         require(_id < heroTokenContract.totalSupply());
1699 
1700         (creationTime, cooldownStartTime, cooldownIndex, genes) = heroTokenContract.heroes(_id);
1701 
1702         // Hero is ready to challenge (not in cooldown mode).
1703         isReady = cooldownStartTime + challengeCooldownTime <= now;
1704     }
1705 
1706     /**
1707      * @dev The external function to get all the relevant information about a specific player by its address.
1708      * @param _address The address of the player.
1709      */
1710     function getPlayerDetails(address _address) external view returns (uint dungeonId, uint payment) {
1711         dungeonId = playerToDungeonID[_address];
1712         payment = payments[_address];
1713     }
1714 
1715 }