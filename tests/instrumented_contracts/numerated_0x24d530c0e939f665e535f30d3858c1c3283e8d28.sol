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
61  * @dev Extension for the Ownable contract, where the owner can assign another address
62  *  to manage some functions of the contract, using the eitherOwner modifier.
63  *  Note that onlyOwner modifier would still be accessible only for the original owner.
64  */
65 contract JointOwnable is Ownable {
66 
67   event AnotherOwnerAssigned(address indexed anotherOwner);
68 
69   address public anotherOwner;
70 
71   /**
72    * @dev Throws if called by any account other than the owner or anotherOwner.
73    */
74   modifier eitherOwner() {
75     require(msg.sender == owner || msg.sender == anotherOwner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to assign another owner.
81    * @param _anotherOwner The address to another owner.
82    */
83   function assignAnotherOwner(address _anotherOwner) onlyOwner public {
84     require(_anotherOwner != 0);
85     AnotherOwnerAssigned(_anotherOwner);
86     anotherOwner = _anotherOwner;
87   }
88 
89 }
90 
91 /**
92  * @title Destructible
93  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
94  */
95 contract Destructible is Ownable {
96 
97   function Destructible() public payable { }
98 
99   /**
100    * @dev Transfers the current balance to the owner and terminates the contract.
101    */
102   function destroy() onlyOwner public {
103     selfdestruct(owner);
104   }
105 
106   function destroyAndSend(address _recipient) onlyOwner public {
107     selfdestruct(_recipient);
108   }
109 
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117 
118   event Pause();
119   event Unpause();
120 
121   bool public paused = false;
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev called by the owner to pause, triggers stopped state
141    */
142   function pause() onlyOwner whenNotPaused public {
143     paused = true;
144     Pause();
145   }
146 
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     Unpause();
153   }
154 
155 }
156 
157 /**
158  * @title SafeMath
159  * @dev Math operations with safety checks that throw on error
160  */
161 library SafeMath {
162 
163   /**
164   * @dev Multiplies two numbers, throws on overflow.
165   */
166   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167     if (a == 0) {
168       return 0;
169     }
170     uint256 c = a * b;
171     assert(c / a == b);
172     return c;
173   }
174 
175   /**
176   * @dev Integer division of two numbers, truncating the quotient.
177   */
178   function div(uint256 a, uint256 b) internal pure returns (uint256) {
179     // assert(b > 0); // Solidity automatically throws when dividing by 0
180     uint256 c = a / b;
181     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182     return c;
183   }
184 
185   /**
186   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
187   */
188   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189     assert(b <= a);
190     return a - b;
191   }
192 
193   /**
194   * @dev Adds two numbers, throws on overflow.
195   */
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     assert(c >= a);
199     return c;
200   }
201 
202 }
203 
204 /**
205  * @title PullPayment
206  * @dev Base contract supporting async send for pull payments. Inherit from this
207  * contract and use asyncSend instead of send.
208  */
209 contract PullPayment {
210 
211   using SafeMath for uint256;
212 
213   mapping(address => uint256) public payments;
214   uint256 public totalPayments;
215 
216   /**
217    * @dev withdraw accumulated balance, called by payee.
218    */
219   function withdrawPayments() public {
220     address payee = msg.sender;
221     uint256 payment = payments[payee];
222 
223     require(payment != 0);
224     require(this.balance >= payment);
225 
226     totalPayments = totalPayments.sub(payment);
227     payments[payee] = 0;
228 
229     assert(payee.send(payment));
230   }
231 
232   /**
233    * @dev Called by the payer to store the sent amount as credit to be pulled.
234    * @param dest The destination address of the funds.
235    * @param amount The amount to transfer.
236    */
237   function asyncSend(address dest, uint256 amount) internal {
238     payments[dest] = payments[dest].add(amount);
239     totalPayments = totalPayments.add(amount);
240   }
241 
242 }
243 
244 contract DungeonStructs {
245 
246     /**
247      * @dev The main Dungeon struct. Every dungeon in the game is represented by this structure.
248      * A dungeon is consists of an unlimited number of floors for your heroes to challenge,
249      * the power level of a dungeon is encoded in the floorGenes. Some dungeons are in fact more "challenging" than others,
250      * the secret formula for that is left for user to find out.
251      *
252      * Each dungeon also has a "training area", heroes can perform trainings and upgrade their stat,
253      * and some dungeons are more effective in the training, which is also a secret formula!
254      *
255      * When player challenge or do training in a dungeon, the fee will be collected as the dungeon rewards,
256      * which will be rewarded to the player who successfully challenged the current floor.
257      *
258      * Each dungeon fits in fits into three 256-bit words.
259      */
260     struct Dungeon {
261 
262         // The timestamp from the block when this dungeon is created.
263         uint32 creationTime;
264 
265         // The status of the dungeon, each dungeon can have 4 status, namely:
266         // 0: Active | 1: Challenge Only | 2: Train Only | 3: InActive
267         uint16 status;
268 
269         // The dungeon's difficulty, the higher the difficulty,
270         // normally, the "rarer" the seedGenes, the higher the diffculty,
271         // and the higher the contribution fee it is to challenge and train with the dungeon,
272         // the formula for the contribution fee is in DungeonChallenge and DungeonTraining contracts.
273         // A dungeon's difficulty never change.
274         uint16 difficulty;
275 
276         // The current floor number, a dungeon is consists of an umlimited number of floors,
277         // when there is heroes successfully challenged a floor, the next floor will be
278         // automatically generated. 32-bit unsigned integers can have 4 billion floors.
279         uint32 floorNumber;
280 
281         // The timestamp from the block when the current floor is generated.
282         uint32 floorCreationTime;
283 
284         // Current accumulated rewards, successful challenger will get a large proportion of it.
285         uint128 rewards;
286 
287         // The seed genes of the dungeon, it is used as the base gene for first floor,
288         // some dungeons are rarer and some are more common, the exact details are,
289         // of course, top secret of the game!
290         // A dungeon's seedGenes never change.
291         uint seedGenes;
292 
293         // The genes for current floor, it encodes the difficulty level of the current floor.
294         // We considered whether to store the entire array of genes for all floors, but
295         // in order to save some precious gas we're willing to sacrifice some functionalities with that.
296         uint floorGenes;
297 
298     }
299 
300     /**
301      * @dev The main Hero struct. Every hero in the game is represented by this structure.
302      */
303     struct Hero {
304 
305         // The timestamp from the block when this dungeon is created.
306         uint64 creationTime;
307 
308         // The seed of the hero, the gene encodes the power level of the hero.
309         // This is another top secret of the game! Hero's gene can be upgraded via
310         // training in a dungeon.
311         uint genes;
312 
313     }
314 
315 }
316 
317 /**
318  * @title A simplified interface of ERC-721, but without approval functions
319  */
320 contract ERC721 {
321 
322     // Events
323     event Transfer(address indexed from, address indexed to, uint tokenId);
324 
325     // ERC20 compatible functions
326     // function name() public view returns (string);
327     // function symbol() public view returns (string);
328     function totalSupply() public view returns (uint);
329     function balanceOf(address _owner) public view returns (uint);
330 
331     // Functions that define ownership
332     function ownerOf(uint _tokenId) external view returns (address);
333     function transfer(address _to, uint _tokenId) external;
334 
335 }
336 
337 /**
338  * @title The ERC-721 compliance token contract for the Dungeon tokens.
339  * @dev See the DungeonStructs contract to see the details of the Dungeon token data structure.
340  */
341 contract DungeonToken is ERC721, DungeonStructs, Pausable, JointOwnable {
342 
343     /**
344      * @notice Limits the number of dungeons the contract owner can ever create.
345      */
346     uint public constant DUNGEON_CREATION_LIMIT = 1024;
347 
348     /**
349      * @dev The Mint event is fired whenever a new dungeon is created.
350      */
351     event Mint(address indexed owner, uint newTokenId, uint difficulty, uint seedGenes);
352 
353     /**
354      * @dev The NewDungeonFloor event is fired whenever a new dungeon floor is added.
355      */
356     event NewDungeonFloor(uint timestamp, uint indexed dungeonId, uint32 newFloorNumber, uint128 newRewards , uint newFloorGenes);
357 
358     /**
359      * @dev Transfer event as defined in current draft of ERC721. Emitted every time a token
360      *  ownership (Dungeon Master) is assigned, including token creation.
361      */
362     event Transfer(address indexed from, address indexed to, uint tokenId);
363 
364     /**
365      * @dev Name of token.
366      */
367     string public constant name = "Dungeon";
368 
369     /**
370      * @dev Symbol of token.
371      */
372     string public constant symbol = "DUNG";
373 
374     /**
375      * @dev An array containing the Dungeon struct, which contains all the dungeons in existance.
376      *  The ID for each dungeon is the index of this array.
377      */
378     Dungeon[] public dungeons;
379 
380     /**
381      * @dev A mapping from token IDs to the address that owns them.
382      */
383     mapping(uint => address) tokenIndexToOwner;
384 
385     /**
386      * @dev A mapping from owner address to count of tokens that address owns.
387      */
388     mapping(address => uint) ownershipTokenCount;
389 
390     /**
391      * Each non-fungible token owner can own more than one token at one time.
392      * Because each token is referenced by its unique ID, however,
393      * it can get difficult to keep track of the individual tokens that a user may own.
394      * To do this, the contract keeps a record of the IDs of each token that each user owns.
395      */
396     mapping(address => uint[]) public ownerTokens;
397 
398     /**
399      * @notice Returns the total number of tokens currently in existence.
400      */
401     function totalSupply() public view returns (uint) {
402         return dungeons.length;
403     }
404 
405     /**
406      * @notice Returns the number of tokens owned by a specific address.
407      * @param _owner The owner address to check.
408      */
409     function balanceOf(address _owner) public view returns (uint) {
410         return ownershipTokenCount[_owner];
411     }
412 
413     /**
414      * @dev Checks if a given address is the current owner of a particular token.
415      * @param _claimant The address we are validating against.
416      * @param _tokenId Token ID
417      */
418     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
419         return tokenIndexToOwner[_tokenId] == _claimant;
420     }
421 
422     /**
423      * @notice Returns the address currently assigned ownership of a given token.
424      */
425     function ownerOf(uint _tokenId) external view returns (address) {
426         require(tokenIndexToOwner[_tokenId] != address(0));
427 
428         return tokenIndexToOwner[_tokenId];
429     }
430 
431     /**
432      * @dev Assigns ownership of a specific token to an address.
433      */
434     function _transfer(address _from, address _to, uint _tokenId) internal {
435         // Increment the ownershipTokenCount.
436         ownershipTokenCount[_to]++;
437 
438         // Transfer ownership.
439         tokenIndexToOwner[_tokenId] = _to;
440 
441         // Add the _tokenId to ownerTokens[_to]
442         ownerTokens[_to].push(_tokenId);
443 
444         // When creating new token, _from is 0x0, but we can't account that address.
445         if (_from != address(0)) {
446             ownershipTokenCount[_from]--;
447 
448             // Remove the _tokenId from ownerTokens[_from]
449             uint[] storage fromTokens = ownerTokens[_from];
450             bool iFound = false;
451 
452             for (uint i = 0; i < fromTokens.length - 1; i++) {
453                 if (iFound) {
454                     fromTokens[i] = fromTokens[i + 1];
455                 } else if (fromTokens[i] == _tokenId) {
456                     iFound = true;
457                 }
458             }
459         }
460 
461         // Emit the Transfer event.
462         Transfer(_from, _to, _tokenId);
463     }
464 
465     /**
466      * @notice External function to transfers a token to another address.
467      * @param _to The address of the recipient, can be a user or contract.
468      * @param _tokenId The ID of the token to transfer.
469      */
470     function transfer(address _to, uint _tokenId) whenNotPaused external {
471         // Safety check to prevent against an unexpected 0x0 default.
472         require(_to != address(0));
473 
474         // Disallow transfers to this contract to prevent accidental misuse.
475         require(_to != address(this));
476 
477         // You can only send your own token.
478         require(_owns(msg.sender, _tokenId));
479 
480         // Reassign ownership, clear pending approvals, emit Transfer event.
481         _transfer(msg.sender, _to, _tokenId);
482     }
483 
484     /**
485      * @dev The external function that creates a new dungeon and stores it, only contract owners
486      *  can create new token, and will be restricted by the DUNGEON_CREATION_LIMIT.
487      *  Will generate a Mint event, a  NewDungeonFloor event, and a Transfer event.
488      * @param _difficulty The difficulty of the new dungeon.
489      * @param _seedGenes The seed genes of the new dungeon.
490      * @return The dungeon ID of the new dungeon.
491      */
492     function createDungeon(uint _difficulty, uint _seedGenes, address _owner) eitherOwner external returns (uint) {
493         // Ensure the total supply is within the fixed limit.
494         require(totalSupply() < DUNGEON_CREATION_LIMIT);
495 
496         // UPDATE STORAGE
497         // Create a new dungeon.
498         dungeons.push(Dungeon(uint32(now), 0, uint16(_difficulty), 0, 0, 0, _seedGenes, 0));
499 
500         // Token id is the index in the storage array.
501         uint newTokenId = dungeons.length - 1;
502 
503         // Emit the token mint event.
504         Mint(_owner, newTokenId, _difficulty, _seedGenes);
505 
506         // Initialize the fist floor with using the seedGenes, this will emit the NewDungeonFloor event.
507         addDungeonNewFloor(newTokenId, 0, _seedGenes);
508 
509         // This will assign ownership, and also emit the Transfer event.
510         _transfer(0, _owner, newTokenId);
511 
512         return newTokenId;
513     }
514 
515     /**
516      * @dev The external function to set dungeon status by its ID,
517      *  refer to DungeonStructs for more information about dungeon status.
518      *  Only contract owners can alter dungeon state.
519      */
520     function setDungeonStatus(uint _id, uint _newStatus) eitherOwner external {
521         require(_id < totalSupply());
522 
523         dungeons[_id].status = uint16(_newStatus);
524     }
525 
526     /**
527      * @dev The external function to add additional dungeon rewards by its ID,
528      *  only contract owners can alter dungeon state.
529      */
530     function addDungeonRewards(uint _id, uint _additinalRewards) eitherOwner external {
531         require(_id < totalSupply());
532 
533         dungeons[_id].rewards += uint64(_additinalRewards);
534     }
535 
536     /**
537      * @dev The external function to add another dungeon floor by its ID,
538      *  only contract owners can alter dungeon state.
539      *  Will generate both a NewDungeonFloor event.
540      */
541     function addDungeonNewFloor(uint _id, uint _newRewards, uint _newFloorGenes) eitherOwner public {
542         require(_id < totalSupply());
543 
544         Dungeon storage dungeon = dungeons[_id];
545 
546         dungeon.floorNumber++;
547         dungeon.floorCreationTime = uint32(now);
548         dungeon.rewards = uint128(_newRewards);
549         dungeon.floorGenes = _newFloorGenes;
550 
551         // Emit the NewDungeonFloor event.
552         NewDungeonFloor(now, _id, dungeon.floorNumber, dungeon.rewards, dungeon.floorGenes);
553     }
554 
555 }
556 
557 /**
558  * @title The ERC-721 compliance token contract for the Hero tokens.
559  * @dev See the DungeonStructs contract to see the details of the Hero token data structure.
560  */
561 contract HeroToken is ERC721, DungeonStructs, Pausable, JointOwnable {
562 
563     /**
564      * @dev The Mint event is fired whenever a new hero is created.
565      */
566     event Mint(address indexed owner, uint newTokenId, uint _genes);
567 
568     /**
569      * @dev Transfer event as defined in current draft of ERC721. Emitted every time a token
570      *  ownership is assigned, including token creation.
571      */
572     event Transfer(address indexed from, address indexed to, uint tokenId);
573 
574     /**
575      * @dev Name of token.
576      */
577     string public constant name = "Hero";
578 
579     /**
580      * @dev Symbol of token.
581      */
582     string public constant symbol = "HERO";
583 
584     /**
585      * @dev An array containing the Hero struct, which contains all the heroes in existance.
586      *  The ID for each hero is the index of this array.
587      */
588     Hero[] public heroes;
589 
590     /**
591      * @dev A mapping from token IDs to the address that owns them.
592      */
593     mapping(uint => address) tokenIndexToOwner;
594 
595     /**
596      * @dev A mapping from owner address to count of tokens that address owns.
597      */
598     mapping(address => uint) ownershipTokenCount;
599 
600     /**
601      * Each non-fungible token owner can own more than one token at one time.
602      * Because each token is referenced by its unique ID, however,
603      * it can get difficult to keep track of the individual tokens that a user may own.
604      * To do this, the contract keeps a record of the IDs of each token that each user owns.
605      */
606     mapping(address => uint[]) public ownerTokens;
607 
608     /**
609      * @notice Returns the total number of tokens currently in existence.
610      */
611     function totalSupply() public view returns (uint) {
612         return heroes.length;
613     }
614 
615     /**
616      * @notice Returns the number of tokens owned by a specific address.
617      * @param _owner The owner address to check.
618      */
619     function balanceOf(address _owner) public view returns (uint) {
620         return ownershipTokenCount[_owner];
621     }
622 
623     /**
624      * @dev Checks if a given address is the current owner of a particular token.
625      * @param _claimant The address we are validating against.
626      * @param _tokenId Token ID
627      */
628     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
629         return tokenIndexToOwner[_tokenId] == _claimant;
630     }
631 
632     /**
633      * @notice Returns the address currently assigned ownership of a given token.
634      */
635     function ownerOf(uint _tokenId) external view returns (address) {
636         require(tokenIndexToOwner[_tokenId] != address(0));
637 
638         return tokenIndexToOwner[_tokenId];
639     }
640 
641     /**
642      * @dev Assigns ownership of a specific token to an address.
643      */
644     function _transfer(address _from, address _to, uint _tokenId) internal {
645         // Increment the ownershipTokenCount.
646         ownershipTokenCount[_to]++;
647 
648         // Transfer ownership.
649         tokenIndexToOwner[_tokenId] = _to;
650 
651         // Add the _tokenId to ownerTokens[_to]
652         ownerTokens[_to].push(_tokenId);
653 
654         // When creating new token, _from is 0x0, but we can't account that address.
655         if (_from != address(0)) {
656             ownershipTokenCount[_from]--;
657 
658             // Remove the _tokenId from ownerTokens[_from]
659             uint[] storage fromTokens = ownerTokens[_from];
660             bool iFound = false;
661 
662             for (uint i = 0; i < fromTokens.length - 1; i++) {
663                 if (iFound) {
664                     fromTokens[i] = fromTokens[i + 1];
665                 } else if (fromTokens[i] == _tokenId) {
666                     iFound = true;
667                 }
668             }
669         }
670 
671         // Emit the Transfer event.
672         Transfer(_from, _to, _tokenId);
673     }
674 
675     /**
676      * @notice External function to transfers a token to another address.
677      * @param _to The address of the recipient, can be a user or contract.
678      * @param _tokenId The ID of the token to transfer.
679      */
680     function transfer(address _to, uint _tokenId) whenNotPaused external {
681         // Safety check to prevent against an unexpected 0x0 default.
682         require(_to != address(0));
683 
684         // Disallow transfers to this contract to prevent accidental misuse.
685         require(_to != address(this));
686 
687         // You can only send your own token.
688         require(_owns(msg.sender, _tokenId));
689 
690         // Reassign ownership, clear pending approvals, emit Transfer event.
691         _transfer(msg.sender, _to, _tokenId);
692     }
693 
694     /**
695      * @dev An external function that creates a new hero and stores it,
696      *  only contract owners can create new token.
697      *  method doesn't do any checking and should only be called when the
698      *  input data is known to be valid.
699      * @param _genes The gene of the new hero.
700      * @param _owner The inital owner of this hero.
701      * @return The hero ID of the new hero.
702      */
703     function createHero(uint _genes, address _owner) external returns (uint) {
704         // UPDATE STORAGE
705         // Create a new hero.
706         heroes.push(Hero(uint64(now), _genes));
707 
708         // Token id is the index in the storage array.
709         uint newTokenId = heroes.length - 1;
710 
711         // Emit the token mint event.
712         Mint(_owner, newTokenId, _genes);
713 
714         // This will assign ownership, and also emit the Transfer event.
715         _transfer(0, _owner, newTokenId);
716 
717         return newTokenId;
718     }
719 
720     /**
721      * @dev The external function to set the hero genes by its ID,
722      *  only contract owners can alter hero state.
723      */
724     function setHeroGenes(uint _id, uint _newGenes) eitherOwner external {
725         require(_id < totalSupply());
726 
727         Hero storage hero = heroes[_id];
728 
729         hero.genes = _newGenes;
730     }
731 
732 }
733 
734 /**
735  * SECRET
736  */
737 contract ChallengeScienceInterface {
738 
739     /**
740      * @dev given genes of current floor and dungeon seed, return a genetic combination - may have a random factor
741      * @param _floorGenes genes of floor
742      * @param _seedGenes seed genes of dungeon
743      * @return the resulting genes
744      */
745     function mixGenes(uint _floorGenes, uint _seedGenes) external pure returns (uint);
746 
747 }
748 
749 /**
750  * SECRET
751  */
752 contract TrainingScienceInterface {
753 
754     /**
755      * @dev given genes of hero and current floor, return a genetic combination - may have a random factor
756      * @param _heroGenes genes of hero
757      * @param _floorGenes genes of current floor
758      * @return the resulting genes
759      */
760     function mixGenes(uint _heroGenes, uint _floorGenes) external pure returns (uint);
761 
762 }
763 
764 /**
765  * @title DungeonBase
766  * @dev Base contract for Ether Dungeon. It implements all necessary sub-classes,
767  * holds all the base storage variables, and some commonly used functions.
768  */
769 contract DungeonBase is EjectableOwnable, Pausable, PullPayment, DungeonStructs {
770 
771     /* ======== TOKEN CONTRACTS ======== */
772 
773     /**
774      * @dev The address of the ERC721 token contract managing all Dungeon tokens.
775      */
776     DungeonToken public dungeonTokenContract;
777 
778     /**
779      * @dev The address of the ERC721 token contract managing all Hero tokens.
780      */
781     HeroToken public heroTokenContract;
782 
783 
784     /* ======== CLOSED SOURCE CONTRACTS ======== */
785 
786     /**
787      * @dev The address of the ChallengeScience contract that handles the floor generation mechanics after challenge success.
788      */
789     ChallengeScienceInterface challengeScienceContract;
790 
791     /**
792      * @dev The address of the TrainingScience contract that handles the hero training mechanics.
793      */
794     TrainingScienceInterface trainingScienceContract;
795 
796 
797     /* ======== SETTER FUNCTIONS ======== */
798 
799     /**
800      * @dev Set the address of the dungeon token contract.
801      * @param _newDungeonTokenContract An address of a DungeonToken contract.
802      */
803     function setDungeonTokenContract(address _newDungeonTokenContract) onlyOwner external {
804         dungeonTokenContract = DungeonToken(_newDungeonTokenContract);
805     }
806 
807     /**
808      * @dev Set the address of the hero token contract.
809      * @param _newHeroTokenContract An address of a HeroToken contract.
810      */
811     function setHeroTokenContract(address _newHeroTokenContract) onlyOwner external {
812         heroTokenContract = HeroToken(_newHeroTokenContract);
813     }
814 
815     /**
816      * @dev Set the address of the secret dungeon challenge formula contract.
817      * @param _newChallengeScienceAddress An address of a ChallengeScience contract.
818      */
819     function setChallengeScienceContract(address _newChallengeScienceAddress) onlyOwner external {
820         challengeScienceContract = ChallengeScienceInterface(_newChallengeScienceAddress);
821     }
822 
823     /**
824      * @dev Set the address of the secret hero training formula contract.
825      * @param _newTrainingScienceAddress An address of a TrainingScience contract.
826      */
827     function setTrainingScienceContract(address _newTrainingScienceAddress) onlyOwner external {
828         trainingScienceContract = TrainingScienceInterface(_newTrainingScienceAddress);
829     }
830 
831 
832     /* ======== MODIFIERS ======== */
833     /**
834      * @dev Throws if _dungeonId is not created yet.
835      */
836     modifier dungeonExists(uint _dungeonId) {
837         require(_dungeonId < dungeonTokenContract.totalSupply());
838         _;
839     }
840 
841     /**
842      * @dev Throws if dungeon status do not allow challenge, also check for dungeon existence.
843      */
844     modifier canChallenge(uint _dungeonId) {
845         require(_dungeonId < dungeonTokenContract.totalSupply());
846         uint status;
847         (,status,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
848         require(status == 0 || status == 1);
849         _;
850     }
851 
852     /**
853      * @dev Throws if dungeon status do not allow training, also check for dungeon existence.
854      */
855     modifier canTrain(uint _dungeonId) {
856         require(_dungeonId < dungeonTokenContract.totalSupply());
857         uint status;
858         (,status,,,,,,) = dungeonTokenContract.dungeons(_dungeonId);
859         require(status == 0 || status == 2);
860         _;
861     }
862 
863 
864     /* ======== HELPER FUNCTIONS ======== */
865 
866     /**
867      * @dev An internal function to calculate the power of player, or difficulty of a dungeon floor,
868      *  if the total heroes power is larger than the current dungeon floor difficulty, the heroes win the challenge.
869      */
870     function _getGenesPower(uint _genes) internal pure returns (uint) {
871         // Calculate total stats power.
872         uint statsPower;
873 
874         for (uint i = 0; i < 4; i++) {
875             statsPower += _genes % 32;
876             _genes /= 32 ** 4;
877         }
878 
879         // Calculate total stats power.
880         uint equipmentPower;
881         bool isSuper = true;
882 
883         for (uint j = 4; j < 12; j++) {
884             uint curGene = _genes % 32;
885             equipmentPower += curGene;
886             _genes /= 32 ** 4;
887 
888             if (equipmentPower != curGene * (j - 3)) {
889                 isSuper = false;
890             }
891         }
892 
893         // Calculate super power.
894         if (isSuper) {
895             equipmentPower *= 2;
896         }
897 
898         return statsPower + equipmentPower + 12;
899     }
900 
901 }
902 
903 contract DungeonChallenge is DungeonBase {
904 
905     /**
906      * @dev The DungeonChallenged event is fired when user finished a dungeon challenge.
907      */
908     event DungeonChallenged(uint timestamp, address indexed playerAddress, uint indexed dungeonId, uint heroGenes, uint floorNumber, uint floorGenes, bool success, uint newFloorGenes, uint successRewards, uint masterRewards);
909 
910     /**
911      * @notice The actual fee contribution required to call challenge() is calculated by this feeMultiplier,
912      *  times the dungeon difficulty. The payment is accumulated to the dungeon rewards,
913      *  and a large proportion will be claimed by whoever successfully challenged the floor.
914      *  1 finney = 0.001 ether
915      */
916     uint256 public challengeFeeMultiplier = 1 finney;
917 
918     /**
919      * @dev The percentage for which successful challenger be rewarded of the dungeons' accumulated rewards.
920      *  The remaining rewards subtracted by developer fee will be used as the base rewards for new floor.
921      */
922     uint public challengeRewardsPercent = 64;
923 
924     /**
925      * @dev The developer fee for owner
926      *  Note that when Ether Dungeon becomes truly decentralised, contract ownership will be ejected,
927      *  and the master rewards will be rewarded to the dungeon owner (Dungeon Masters).
928      */
929     uint public masterRewardsPercent = 8;
930 
931     /**
932      * @dev The main public function to call when a player challenge a dungeon,
933      *  it determines whether if the player successfully challenged the current floor.
934      *  Will generate a DungeonChallenged event.
935      */
936     function challenge(uint _dungeonId) external payable whenNotPaused canChallenge(_dungeonId) {
937         // Get the dungeon details from the token contract.
938         uint difficulty;
939         uint seedGenes;
940         (,,difficulty,,,,seedGenes,) = dungeonTokenContract.dungeons(_dungeonId);
941 
942         // Checks for payment, any exceeding funds will be transferred back to the player.
943         uint requiredFee = difficulty * challengeFeeMultiplier;
944         require(msg.value >= requiredFee);
945 
946         // ** STORAGE UPDATE **
947         // Increment the accumulated rewards for the dungeon.
948         dungeonTokenContract.addDungeonRewards(_dungeonId, requiredFee);
949 
950         // Calculate any excess funds and make it available to be withdrawed by the player.
951         asyncSend(msg.sender, msg.value - requiredFee);
952 
953         // Split the challenge function into multiple parts because of stack too deep error.
954         _challengePart2(_dungeonId);
955     }
956 
957     /**
958      * Split the challenge function into multiple parts because of stack too deep error.
959      */
960     function _challengePart2(uint _dungeonId) private {
961         uint floorNumber;
962         uint rewards;
963         uint floorGenes;
964         (,,,floorNumber,,rewards,,floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
965 
966         // Get the first hero gene, or initialize first hero with current dungeon's seed genes.
967         // TODO: implement multiple heroes in next phase
968         uint heroGenes = _getFirstHeroGenesAndInitialize(_dungeonId);
969 
970         bool success = _getChallengeSuccess(heroGenes, floorGenes);
971 
972         uint newFloorGenes;
973         uint successRewards;
974         uint masterRewards;
975 
976         // Whether a challenge is success or not is determined by a simple comparison between hero power and floor power.
977         if (success) {
978             newFloorGenes = _getNewFloorGene(_dungeonId);
979             successRewards = rewards * challengeRewardsPercent / 100;
980             masterRewards = rewards * masterRewardsPercent / 100;
981 
982             // The dungeon rewards for new floor as total rewards - challenge rewards - devleoper fee.
983             uint newRewards = rewards * (100 - challengeRewardsPercent - masterRewardsPercent) / 100;
984 
985             // ** STORAGE UPDATE **
986             // Add new floor with the new floor genes and new rewards.
987             dungeonTokenContract.addDungeonNewFloor(_dungeonId, newRewards, newFloorGenes);
988 
989             // Mark the challenge rewards available to be withdrawed by the player.
990             asyncSend(msg.sender, successRewards);
991 
992             // Mark the master rewards available to be withdrawed by the dungeon master.
993             asyncSend(dungeonTokenContract.ownerOf(_dungeonId), masterRewards);
994         }
995 
996         // Emit the DungeonChallenged event.
997         DungeonChallenged(now, msg.sender, _dungeonId, heroGenes, floorNumber, floorGenes, success, newFloorGenes, successRewards, masterRewards);
998     }
999 
1000     /**
1001      * Split the challenge function into multiple parts because of stack too deep error.
1002      */
1003     function _getFirstHeroGenesAndInitialize(uint _dungeonId) private returns (uint heroGenes) {
1004         uint seedGenes;
1005         (,,,,,,seedGenes,) = dungeonTokenContract.dungeons(_dungeonId);
1006 
1007         // Get the first hero of the player.
1008         uint heroId;
1009 
1010         if (heroTokenContract.balanceOf(msg.sender) == 0) {
1011             // Assign the first hero using the seed genes of the dungeon for new player.
1012             heroId = heroTokenContract.createHero(seedGenes, msg.sender);
1013         } else {
1014             heroId = heroTokenContract.ownerTokens(msg.sender, 0);
1015         }
1016 
1017         // Get the hero genes from token storage.
1018         (,heroGenes) = heroTokenContract.heroes(heroId);
1019     }
1020 
1021     /**
1022      * Split the challenge function into multiple parts because of stack too deep error.
1023      */
1024     function _getChallengeSuccess(uint heroGenes, uint floorGenes) private pure returns (bool) {
1025         // Determine if the player challenge successfuly the dungeon or not, and the new floor genes.
1026         uint heroPower = _getGenesPower(heroGenes);
1027         uint floorPower = _getGenesPower(floorGenes);
1028 
1029         return heroPower > floorPower;
1030     }
1031 
1032     /**
1033      * Split the challenge function into multiple parts because of stack too deep error.
1034      */
1035     function _getNewFloorGene(uint _dungeonId) private view returns (uint) {
1036         uint seedGenes;
1037         uint floorGenes;
1038         (,,,,,seedGenes,floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1039 
1040         // Calculate the new floor gene.
1041         uint floorPower = _getGenesPower(floorGenes);
1042         uint newFloorGenes = challengeScienceContract.mixGenes(floorGenes, seedGenes);
1043         uint newFloorPower = _getGenesPower(newFloorGenes);
1044 
1045         // If the power decreased, rollback to the current floor genes.
1046         if (newFloorPower < floorPower) {
1047             newFloorGenes = floorGenes;
1048         }
1049 
1050         return newFloorGenes;
1051     }
1052 
1053 
1054     /* ======== SETTER FUNCTIONS ======== */
1055 
1056     /**
1057      * @dev Updates the fee contribution multiplier required for calling challenge().
1058      */
1059     function setChallengeFeeMultiplier(uint _newChallengeFeeMultiplier) external onlyOwner {
1060         challengeFeeMultiplier = _newChallengeFeeMultiplier;
1061     }
1062 
1063     /**
1064      * @dev Updates the challenge rewards pecentage.
1065      */
1066     function setChallengeRewardsPercent(uint _newChallengeRewardsPercent) onlyOwner external {
1067         challengeRewardsPercent = _newChallengeRewardsPercent;
1068     }
1069 
1070     /**
1071      * @dev Updates the master rewards percentage.
1072      */
1073     function setMasterRewardsPercent(uint _newMasterRewardsPercent) onlyOwner external {
1074         masterRewardsPercent = _newMasterRewardsPercent;
1075     }
1076 
1077 }
1078 
1079 contract DungeonTraining is DungeonChallenge {
1080 
1081     /// @dev The HeroTrained event is fired when user finished a training.
1082     event HeroTrained(uint timestamp, address indexed playerAddress, uint indexed dungeonId, uint heroGenes, uint floorNumber, uint floorGenes, bool success, uint newHeroGenes);
1083 
1084     /// @notice The actual fee contribution required to call trainX() is calculated by this feeMultiplier,
1085     ///  times the dungeon difficulty, times X. The payment is accumulated to the dungeon rewards,
1086     ///  and a large proportion will be claimed by whoever successfully challenged the floor.
1087     ///  1 finney = 0.001 ether
1088     uint256 public trainingFeeMultiplier = 2 finney;
1089 
1090     /// @dev Updates the fee contribution multiplier required for calling trainX().
1091     function setTrainingFeeMultiplier(uint _newTrainingFeeMultiplier) external onlyOwner {
1092         trainingFeeMultiplier = _newTrainingFeeMultiplier;
1093     }
1094 
1095     /// @dev The public function to call when a hero train with a dungeon,
1096     ///  it determines whether whether a training is successfully, and the resulting genes.
1097     ///  Will generate a DungeonChallenged event.
1098     function train1(uint _dungeonId) external payable whenNotPaused canTrain(_dungeonId) {
1099         _train(_dungeonId, 1);
1100     }
1101 
1102     function train2(uint _dungeonId) external payable whenNotPaused canTrain(_dungeonId) {
1103         _train(_dungeonId, 2);
1104     }
1105 
1106     function train3(uint _dungeonId) external payable whenNotPaused canTrain(_dungeonId) {
1107         _train(_dungeonId, 3);
1108     }
1109 
1110     /// @dev An internal function of a hero train with dungeon,
1111     ///  it determines whether whether a training is successfully, and the resulting genes.
1112     ///  Will generate a DungeonChallenged event.
1113     function _train(uint _dungeonId, uint _trainingTimes) private {
1114         // Get the dungeon details from the token contract.
1115         uint difficulty;
1116         uint floorNumber;
1117         uint rewards;
1118         uint seedGenes;
1119         uint floorGenes;
1120         (,,difficulty,floorNumber,,rewards,seedGenes,floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1121 
1122         // Check for _trainingTimes abnormality, we probably won't have any feature that train a hero 10 times with a single call.
1123         require(_trainingTimes < 10);
1124 
1125         // Checks for payment, any exceeding funds will be transferred back to the player.
1126         uint requiredFee = difficulty * trainingFeeMultiplier * _trainingTimes;
1127         require(msg.value >= requiredFee);
1128 
1129         // Get the first hero of the player.
1130         // TODO: implement multiple heroes in next phase
1131         uint heroId;
1132 
1133         if (heroTokenContract.balanceOf(msg.sender) == 0) {
1134             // Assign the first hero using the seed genes of the dungeon for new player.
1135             heroId = heroTokenContract.createHero(seedGenes, msg.sender);
1136         } else {
1137             heroId = heroTokenContract.ownerTokens(msg.sender, 0);
1138         }
1139 
1140         // ** STORAGE UPDATE **
1141         // Increment the accumulated rewards for the dungeon.
1142         dungeonTokenContract.addDungeonRewards(_dungeonId, requiredFee);
1143 
1144         // Calculate any excess funds and make it available to be withdrawed by the player.
1145         asyncSend(msg.sender, msg.value - requiredFee);
1146 
1147         // Split the _train function into multiple parts because of stack too deep error.
1148         _trainPart2(_dungeonId, _trainingTimes, heroId);
1149     }
1150 
1151     /**
1152      * Split the _train function into multiple parts because of stack too deep error.
1153      */
1154     function _trainPart2(uint _dungeonId, uint _trainingTimes, uint _heroId) private {
1155         // Get the dungeon details from the token contract.
1156         uint floorNumber;
1157         uint floorGenes;
1158         (,,,floorNumber,,,,floorGenes) = dungeonTokenContract.dungeons(_dungeonId);
1159 
1160         uint heroGenes;
1161         (,heroGenes) = heroTokenContract.heroes(_heroId);
1162 
1163         // Determine if the hero training is successful or not, and the resulting genes.
1164         uint heroPower = _getGenesPower(heroGenes);
1165 
1166         uint newHeroGenes = heroGenes;
1167         uint newHeroPower = heroPower;
1168 
1169         // Train the hero multiple times according to _trainingTimes,
1170         // each time if the resulting power is larger, update new hero power.
1171         for (uint i = 0; i < _trainingTimes; i++) {
1172             uint tmpHeroGenes = trainingScienceContract.mixGenes(newHeroGenes, floorGenes);
1173             uint tmpHeroPower = _getGenesPower(tmpHeroGenes);
1174 
1175             if (tmpHeroPower > newHeroPower) {
1176                 newHeroGenes = tmpHeroGenes;
1177                 newHeroPower = tmpHeroPower;
1178             }
1179         }
1180 
1181         // Prevent reduced power.
1182         bool success = newHeroPower > heroPower;
1183 
1184         if (success) {
1185             // ** STORAGE UPDATE **
1186             // Set the upgraded hero genes.
1187             heroTokenContract.setHeroGenes(_heroId, newHeroGenes);
1188         }
1189 
1190         // Emit the HeroTrained event.
1191         HeroTrained(now, msg.sender, _dungeonId, heroGenes, floorNumber, floorGenes, success, newHeroGenes);
1192     }
1193 
1194 }
1195 
1196 /**
1197  * @title DungeonCoreAlpha2 (fixed challenge rewards calculation bug)
1198  * @dev Core Contract of Ether Dungeon.
1199  *  When Beta launches, DungeonCoreBeta contract will be deployed and DungeonCoreAlpha will be destroyed.
1200  *  Since all dungeons and heroes are stored as tokens in external contracts, they remains immutable.
1201  */
1202 contract DungeonCoreAlpha2 is Destructible, DungeonTraining {
1203 
1204     /**
1205      * Initialize the DungeonCore(Alpha) contract with all the required contract addresses.
1206      * TODO: really require payable here? why?
1207      */
1208     function DungeonCoreAlpha2(
1209         address _dungeonTokenAddress,
1210         address _heroTokenAddress,
1211         address _challengeScienceAddress,
1212         address _trainingScienceAddress
1213     ) public {
1214         dungeonTokenContract = DungeonToken(_dungeonTokenAddress);
1215         heroTokenContract = HeroToken(_heroTokenAddress);
1216         challengeScienceContract = ChallengeScienceInterface(_challengeScienceAddress);
1217         trainingScienceContract = TrainingScienceInterface(_trainingScienceAddress);
1218     }
1219 
1220     /**
1221      * @dev The external function to get all the relevant information about a specific dungeon by its ID.
1222      * @param _id The ID of the dungeon.
1223      */
1224     function getDungeonDetails(uint _id) external view returns (uint creationTime, uint status, uint difficulty, uint floorNumber, uint floorCreationTime, uint rewards, uint seedGenes, uint floorGenes) {
1225         require(_id < dungeonTokenContract.totalSupply());
1226 
1227         (creationTime, status, difficulty, floorNumber, floorCreationTime, rewards, seedGenes, floorGenes) = dungeonTokenContract.dungeons(_id);
1228     }
1229 
1230     /**
1231      * @dev The external function to get all the relevant information about a specific hero by its ID.
1232      * @param _id The ID of the hero.
1233      */
1234     function getHeroDetails(uint _id) external view returns (uint creationTime, uint genes) {
1235         require(_id < heroTokenContract.totalSupply());
1236 
1237         (creationTime, genes) = heroTokenContract.heroes(_id);
1238     }
1239 
1240 }