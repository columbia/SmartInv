1 pragma solidity ^0.4.11;
2 
3 /** ************************************************************************ **/
4 /** ************************ Abstract CK Core ****************************** **/
5 /** ************************************************************************ **/
6 
7 /**
8  * @dev This can be exchanged for any ERC721 contract if we don't want to rely on CK.
9 **/
10 contract KittyCore {
11     function ownerOf(uint256 _tokenId) external view returns (address owner);
12 }
13 
14 /**
15  * @title Ownable
16  * @dev The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20   address public owner;
21 
22 
23   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() public {
31     owner = msg.sender;
32   }
33 
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) onlyOwner public {
49     require(newOwner != address(0));
50     OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54 }
55 
56 /** ************************************************************************ **/
57 /** *************************** Cuddle Data ******************************** **/ 
58 /** ************************************************************************ **/
59     
60 /**
61  * @dev Holds the data for all kitty actions and all kitty effects.
62  * @notice TO-DO: Haven't fully converted this to a format where effects are actions!
63 **/
64 contract CuddleData is Ownable {
65     // Action/Effect Id => struct for actions and for effects.
66     mapping (uint256 => Action) public actions;
67     // Actions specific to personality types.
68     mapping (uint256 => uint256[]) typeActions;
69     // Actions that any personality can have.
70     uint256[] anyActions;
71 
72     // This struct used for all moves a kitty may have.
73     struct Action {
74         uint256 energy;
75         uint8[6] basePets; // Each owner is an index that has a base amount of pets.
76         uint8[6] petsAddition; // Special effects may give extra pets.
77         uint16[6] critChance; // Special effects may increase (or decrease?) crit chance.
78         uint8[6] missChance; // Special effects may decrease (or increase?) miss chance.
79         uint256 turnsAffected; // If an effect occurrs
80     }
81     
82 /** ************************** EXTERNAL VIEW ******************************* **/
83     
84     /**
85      * @dev Used by CuddleScience to get relevant info for a sequence of moves.
86      * @param _actions The 8 length array of the move sequence.
87      * @param _cuddleOwner The owner Id that we need info for.
88     **/
89     function returnActions(uint256[8] _actions, uint256 _cuddleOwner)
90       external
91       view
92     returns (uint256[8] energy, uint256[8] basePets, uint256[8] petsAddition,
93              uint256[8] critChance, uint256[8] missChance, uint256[8] turnsAffected)
94     {
95         for (uint256 i = 0; i < 8; i++) {
96             if (_actions[i] == 0) break;
97             
98             Action memory action = actions[_actions[i]];
99             energy[i] = action.energy;
100             basePets[i] = action.basePets[_cuddleOwner];
101             petsAddition[i] = action.petsAddition[_cuddleOwner];
102             critChance[i] = action.critChance[_cuddleOwner];
103             missChance[i] = action.missChance[_cuddleOwner];
104             turnsAffected[i] = action.turnsAffected;
105         }
106     }
107     
108     /**
109      * @NOTICE This is hardcoded for announcement until launch.
110      * No point in adding actions now that are just going to be changed.
111     **/
112     
113     /**
114      * @dev Returns the amount of kitty actions available.
115      * @param _personality If we want personality actions, this is the personality index
116     **/
117     function getActionCount(uint256 _personality)
118       external
119       view
120     returns (uint256 totalActions)
121     {
122         //if (_personality > 0) totalActions = typeActions[_personality].length;
123         //else totalActions = anyActions.length;
124         if (_personality == 0) return 10;
125         else return 5;
126     }
127     
128 /** ******************************* ONLY OWNER ***************************** **/
129     
130     /**
131      * @dev Used by the owner to create/edit a new action that kitties may learn.
132      * @param _actionId The given ID of this action.
133      * @param _newEnergy The amount of energy the action will cost.
134      * @param _newPets The amount of base pets each owner will give to this action.
135      * @param _petAdditions The amount of additional pets each owner will give.
136      * @param _critChance The crit chance this move has against each owner.
137      * @param _missChance The miss chance this move has against each owner.
138      * @param _turnsAffected The amount of turns an effect, if any, will be applied.
139      * @param _personality The type/personality this move is specific to (0 for any).
140     **/
141     function addAction(uint256 _actionId, uint256 _newEnergy, uint8[6] _newPets, uint8[6] _petAdditions,
142             uint16[6] _critChance, uint8[6] _missChance, uint256 _turnsAffected, uint256 _personality)
143       public // This is called in prepActions down below.
144       onlyOwner
145     {
146         Action memory newAction = Action(_newEnergy, _newPets, _petAdditions, _critChance, _missChance, _turnsAffected);
147         actions[_actionId] = newAction;
148         
149         if (_personality > 0) typeActions[_personality].push(_actionId);
150         else anyActions.push(_actionId);
151     }
152     
153 }
154 
155 /** ************************************************************************* **/
156 /** **************************** Kitty Data ********************************* **/
157 /** ************************************************************************* **/
158 
159 /**
160  * @dev Kitty data holds the core of all data for kitties. This is the most permanent
161  * @dev of all contracts in the CryptoCuddles system. As simple as possible because of that.
162 **/
163 contract KittyData is Ownable {
164     address public gymContract; // Address of the gym contract.
165     address public specialContract; // Address of the contract used to train special kitties.
166     address public arenaContract; // Address of the arena contract.
167     
168     // Mapping of all kitties by CK kitty Id
169     mapping (uint256 => Kitty) public kitties;
170     
171     // All trained kitties
172     struct Kitty {
173         uint8[2] kittyType; // Personality/type of the kitty.
174         uint32[12] actionsArray; // Array of all moves.
175         uint16 level; // Current level of the kitty.
176         uint16 totalBattles; // Total battles that the kitty has "fought".
177     }
178     
179 /** ******************************* DEFAULT ******************************** **/
180     
181     /**
182      * @param _arenaContract The address of the Arena so that it may level up kitties.
183      * @param _gymContract The address of the KittyGym so that it may train kitties.
184      * @param _specialContract The address of the SpecialGym so it may train specials.
185     **/
186     function KittyData(address _arenaContract, address _gymContract, address _specialContract)
187       public
188     {
189         arenaContract = _arenaContract;
190         gymContract = _gymContract;
191         specialContract = _specialContract;
192     }
193     
194 /** ***************************** ONLY VERIFIED **************************** **/
195     
196     /**
197      * @dev Used by KittyGym to initially add a kitty.
198      * @param _kittyId Unique CK Id of kitty to be added.
199      * @param _kittyType The personality type of this kitty.
200      * @param _actions Array of all actions to be added to kitty.
201     **/
202     function addKitty(uint256 _kittyId, uint256 _kittyType, uint256[5] _actions)
203       external
204       onlyVerified
205     returns (bool success)
206     {
207         delete kitties[_kittyId]; // Wipe this kitty if it's already trained.
208         
209         kitties[_kittyId].kittyType[0] = uint8(_kittyType);
210         for (uint256 i = 0; i < 5; i++) { 
211             addAction(_kittyId, _actions[i], i);
212         }
213 
214         return true;
215     }
216     
217     /**
218      * @dev Give this learned kitty with a wealthy owner a degree and new graduate-specific actions.
219      * @param _kittyId The unique CK Id of the kitty to graduate.
220      * @param _specialId The Id of the special type that is being trained.
221      * @param _actions The graduate-specific actions that are being given to this kitty.
222      * @param _slots The array indices where the new actions will go.
223     **/
224     function trainSpecial(uint256 _kittyId, uint256 _specialId, uint256[2] _actions, uint256[2] _slots)
225       external
226       onlyVerified
227     returns (bool success)
228     {
229         kitties[_kittyId].kittyType[1] = uint8(_specialId);
230         addAction(_kittyId, _actions[0], _slots[0]);
231         addAction(_kittyId, _actions[1], _slots[1]);
232         return true;
233     }
234 
235     /**
236      * @dev Used internally and externally to add an action or replace an action.
237      * @param _kittyId The unique CK Id of the learning kitty.
238      * @param _newAction The new action to learn.
239      * @param _moveSlot The kitty's actionsArray index where the move shall go.
240     **/
241     function addAction(uint256 _kittyId, uint256 _newAction, uint256 _moveSlot)
242       public
243       onlyVerified
244     returns (bool success)
245     {
246         kitties[_kittyId].actionsArray[_moveSlot] = uint32(_newAction);
247         return true;
248     }
249     
250 
251     /**
252      * @dev Arena contract uses this on either a win or lose.
253      * @param _kittyId The unique CK Id for the kitty being edited.
254      * @param _won Whether or not the kitty won the battle.
255     **/
256     function incrementBattles(uint256 _kittyId, bool _won)
257       external
258       onlyVerified
259     returns (bool success)
260     {
261         if (_won) kitties[_kittyId].level++;
262         kitties[_kittyId].totalBattles++;
263         return true;
264     }
265     
266 /** ****************************** CONSTANT ******************************** **/
267     
268     /**
269      * @dev Used on KittyGym when rerolling a move to ensure validity.
270      * @param _kittyId Unique CK Id of the kitty.
271      * @param _moveSlot The index of the kitty's actionsArray to check.
272      * @return The move that occupies the _moveSlot.
273     **/
274     function fetchSlot(uint256 _kittyId, uint256 _moveSlot)
275       external
276       view
277     returns (uint32)
278     {
279         return kitties[_kittyId].actionsArray[_moveSlot];
280     }
281     
282     /**
283      * @dev Used by frontend to get data for a kitty.
284      * @param _kittyId The unique CK Id we're querying for.
285     **/
286     function returnKitty(uint256 _kittyId)
287       external
288       view
289     returns (uint8[2] kittyType, uint32[12] actionsArray, uint16 level, uint16 totalBattles)
290     {
291         Kitty memory kitty = kitties[_kittyId];
292         kittyType = kitty.kittyType;
293         actionsArray = kitty.actionsArray;
294         level = kitty.level;
295         totalBattles = kitty.totalBattles;
296     }
297     
298 /** ***************************** ONLY OWNER ******************************* **/
299     
300     /**
301      * @dev Owner of this contract may change the addresses of associated contracts.
302      * @param _gymContract The address of the new KittyGym contract.
303      * @param _arenaContract The address of the new Arena contract.
304      * @param _specialContract The address of the new SpecialGym contract.
305     **/
306     function changeContracts(address _gymContract, address _specialContract, address _arenaContract)
307       external
308       onlyOwner
309     {
310         if (_gymContract != 0) gymContract = _gymContract;
311         if (_specialContract != 0) specialContract = _specialContract;
312         if (_arenaContract != 0) arenaContract = _arenaContract;
313     }
314     
315 /** ***************************** MODIFIERS ******************************** **/
316     
317     /**
318      * @dev Only the KittyGym and Arena contracts may make changes to KittyData!
319     **/
320     modifier onlyVerified()
321     {
322         require(msg.sender == gymContract || msg.sender == specialContract || 
323                 msg.sender == arenaContract);
324         _;
325     }
326     
327 }
328 
329 /** ************************************************************************ **/
330 /** **************************** Kitty Gym ********************************* **/
331 /** ************************************************************************ **/
332 
333 /**
334  * @dev Allows players to train kitties, reroll the training, or reroll specific moves.
335  * @dev Also holds all specific kitty data such as their available actions (but not action data!)
336 **/
337 contract KittyGym is Ownable {
338     KittyCore public core;
339     CuddleData public cuddleData;
340     CuddleCoin public token;
341     KittyData public kittyData;
342     address public specialGym;
343 
344     uint256 public totalKitties = 1; // Total amount of trained kitties.
345     uint256 public personalityTypes; // Number of personality types for randomization.
346 
347     uint256 public trainFee; // In wei
348     uint256 public learnFee; // In CuddleCoin wei
349     uint256 public rerollFee; // In CuddleCoin wei
350     
351     // Unique CK Id => action Id => true if the kitty knows the action.
352     mapping (uint256 => mapping (uint256 => bool)) public kittyActions;
353 
354     event KittyTrained(uint256 indexed kittyId, uint256 indexed kittyNumber,
355             uint256 indexed personality, uint256[5] learnedActions);
356     event MoveLearned(uint256 indexed kittyId, uint256 indexed actionId);
357     event MoveRerolled(uint256 indexed kittyId, uint256 indexed oldActionId,
358                         uint256 indexed newActionId);
359 
360     /**
361      * @dev Initialize contract.
362     **/
363     function KittyGym(address _kittyCore, address _cuddleData, address _cuddleCoin, 
364                     address _specialGym, address _kittyData)
365       public 
366     {
367         core = KittyCore(_kittyCore);
368         cuddleData = CuddleData(_cuddleData);
369         token = CuddleCoin(_cuddleCoin);
370         kittyData = KittyData(_kittyData);
371         specialGym = _specialGym;
372         
373         trainFee = 0;
374         learnFee = 1;
375         rerollFee = 1;
376         personalityTypes = 5;
377     }
378 
379 /** ***************************** EXTERNAL ********************************* **/
380 
381     /**
382      * @dev The owner of a kitty may train or retrain (reset everything) a kitty here.
383      * @param _kittyId ID of Kitty to train or retrain.
384     **/
385     function trainKitty(uint256 _kittyId)
386       external
387       payable
388       isNotContract
389     {
390         // Make sure trainer owns this kitty
391         require(core.ownerOf(_kittyId) == msg.sender);
392         require(msg.value == trainFee);
393         
394         // Make sure we delete all actions if the kitty has already been trained.
395         if (kittyData.fetchSlot(_kittyId, 0) > 0) {
396             var (,actionsArray,,) = kittyData.returnKitty(_kittyId);
397             deleteActions(_kittyId, actionsArray); // A special kitty will be thrown here.
398         }
399 
400         uint256 newType = random(totalKitties * 11, 1, personalityTypes); // upper is inclusive here
401         kittyActions[_kittyId][(newType * 1000) + 1] = true;
402         
403         uint256[2] memory newTypeActions = randomizeActions(newType, _kittyId);
404         uint256[2] memory newAnyActions = randomizeActions(0, _kittyId);
405 
406         uint256[5] memory newActions;
407         newActions[0] = (newType * 1000) + 1;
408         newActions[1] = newTypeActions[0];
409         newActions[2] = newTypeActions[1];
410         newActions[3] = newAnyActions[0];
411         newActions[4] = newAnyActions[1];
412         
413         kittyActions[_kittyId][newActions[1]] = true;
414         kittyActions[_kittyId][newActions[2]] = true;
415         kittyActions[_kittyId][newActions[3]] = true;
416         kittyActions[_kittyId][newActions[4]] = true;
417  
418         assert(kittyData.addKitty(_kittyId, newType, newActions));
419         KittyTrained(_kittyId, totalKitties, newType, newActions);
420         totalKitties++;
421         
422         owner.transfer(msg.value);
423     }
424 
425     /**
426      * @dev May teach your kitty a new random move for a fee.
427      * @param _kittyId The ID of the kitty who shall get a move added.
428      * @param _moveSlot The array index that the move shall be placed in.
429     **/
430     function learnMove(uint256 _kittyId, uint256 _moveSlot)
431       external
432       isNotContract
433     {
434         require(msg.sender == core.ownerOf(_kittyId));
435         // Burn the learning fee from the trainer's balance
436         assert(token.burn(msg.sender, learnFee));
437         require(kittyData.fetchSlot(_kittyId, 0) > 0); // Cannot learn without training.
438         require(kittyData.fetchSlot(_kittyId, _moveSlot) == 0); // Must be put in blank spot.
439         
440         uint256 upper = cuddleData.getActionCount(0);
441         uint256 actionId = unduplicate(_kittyId * 11, 999, upper, 0); // * 11 and 99...are arbitrary
442         
443         assert(!kittyActions[_kittyId][actionId]); // Throw if a new move still wasn't found.
444         kittyActions[_kittyId][actionId] = true;
445         
446         assert(kittyData.addAction(_kittyId, actionId, _moveSlot));
447         MoveLearned(_kittyId, actionId);
448     }
449 
450     /**
451      * @dev May reroll one kitty move. Cheaper than buying a new one.
452      * @param _kittyId The kitty who needs to retrain a move slot.
453      * @param _moveSlot The index of the kitty's actionsArray to replace.
454      * @param _typeId The personality Id of the kity.
455     **/
456     function reRollMove(uint256 _kittyId, uint256 _moveSlot, uint256 _typeId)
457       external
458       isNotContract
459     {
460         require(msg.sender == core.ownerOf(_kittyId));
461         
462         // Make sure the old action exists and is of the correct type (purposeful underflow).
463         uint256 oldAction = kittyData.fetchSlot(_kittyId, _moveSlot);
464         require(oldAction > 0);
465         require(oldAction - (_typeId * 1000) < 1000);
466         
467         // Burn the rerolling fee from the trainer's balance
468         assert(token.burn(msg.sender, rerollFee));
469 
470         uint256 upper = cuddleData.getActionCount(_typeId);
471         uint256 actionId = unduplicate(_kittyId, oldAction, upper, _typeId);
472 
473         assert(!kittyActions[_kittyId][actionId]); 
474         kittyActions[_kittyId][oldAction] = false;
475         kittyActions[_kittyId][actionId] = true;
476         
477         assert(kittyData.addAction(_kittyId, actionId, _moveSlot));
478         MoveRerolled(_kittyId, oldAction, actionId);
479     }
480     
481 /** ******************************* INTERNAL ******************************** **/
482     
483     /**
484      * @dev Return two actions for training or hybridizing a kitty using the given type.
485      * @param _actionType The type of actions that shall be learned. 0 for "any" actions.
486      * @param _kittyId The unique CK Id of the kitty.
487     **/ 
488     function randomizeActions(uint256 _actionType, uint256 _kittyId)
489       internal
490       view
491     returns (uint256[2])
492     {
493         uint256 upper = cuddleData.getActionCount(_actionType);
494         uint256 action1 = unduplicate(_kittyId, 999, upper, _actionType);
495         uint256 action2 = unduplicate(_kittyId, action1, upper, _actionType);
496         return [action1,action2];
497     }
498     
499     /**
500      * @dev Used when a new action is chosen but the kitty already knows it.
501      * @dev If no unique actions can be found, unduplicate throws.
502      * @param _kittyId The unique CK Id of the kitty.
503      * @param _action1 The action that is already known.
504      * @param _upper The amount of actions that can be tried.
505      * @param _type The type of action that these actions are.
506      * @return The new action that is not a duplicate.
507     **/
508     function unduplicate(uint256 _kittyId, uint256 _action1, uint256 _upper, uint256 _type)
509       internal
510       view
511     returns (uint256 newAction)
512     {
513         uint256 typeBase = _type * 1000; // The base thousand for this move's type.
514 
515         for (uint256 i = 1; i < 11; i++) {
516             newAction = random(i * 666, 1, _upper) + typeBase;
517             if (newAction != _action1 && !kittyActions[_kittyId][newAction]) break;
518         }
519         
520         // If the kitty still knows the move, increment till we find one it doesn't.
521         if (newAction == _action1 || kittyActions[_kittyId][newAction]) {
522             for (uint256 j = 1; j < _upper + 1; j++) {
523                 uint256 incAction = ((newAction + j) % _upper) + 1;
524 
525                 incAction += typeBase;
526                 if (incAction != _action1 && !kittyActions[_kittyId][incAction]) {
527                     newAction = incAction;
528                     break;
529                 }
530             }
531         }
532     }
533     
534     /**
535      * @dev Create a random number.
536      * @param _rnd Seed to help randomize.
537      * @param _lower The lower bound of the random number (inclusive).
538      * @param _upper The upper bound of the random number (exclusive).
539     **/ 
540     function random(uint256 _rnd, uint256 _lower, uint256 _upper) 
541       internal
542       view
543     returns (uint256) 
544     {
545         uint256 _seed = uint256(keccak256(keccak256(_rnd, _seed), now));
546         return (_seed % _upper) + _lower;
547     }
548     
549     /**
550      * @dev Used by trainKitty to delete mapping values if the kitty has already been trained.
551      * @param _kittyId The unique CK Id of the kitty.
552      * @param _actions The list of all actions the kitty currently has.
553     **/
554     function deleteActions(uint256 _kittyId, uint32[12] _actions)
555       internal
556     {
557         for (uint256 i = 0; i < _actions.length; i++) {
558             // Make sure a special kitty isn't retrained. Purposeful underflow.
559             require(uint256(_actions[i]) - 50000 > 10000000);
560             
561             delete kittyActions[_kittyId][uint256(_actions[i])];
562         }
563     }
564     
565 /** ************************* EXTERNAL CONSTANT **************************** **/
566     
567     /**
568      * @dev Confirms whether a kitty has chosen actions.
569      * @param _kittyId The id of the kitty whose actions need to be checked.
570      * @param _kittyActions The actions to be checked.
571     **/
572     function confirmKittyActions(uint256 _kittyId, uint256[8] _kittyActions) 
573       external 
574       view
575     returns (bool)
576     {
577         for (uint256 i = 0; i < 8; i++) {
578             if (!kittyActions[_kittyId][_kittyActions[i]]) return false; 
579         }
580         return true;
581     }
582     
583 /** ************************* ONLY VERIFIED/OWNER ************************** **/
584     
585     /**
586      * @dev Used by the SpecialGym contract when a kitty learns new special moves.
587      * @param _kittyId The Id of the now special kitty!
588      * @param _moves A 2-length array with the new special moves.
589     **/
590     function addMoves(uint256 _kittyId, uint256[2] _moves)
591       external
592       onlyVerified
593     returns (bool success)
594     {
595         kittyActions[_kittyId][_moves[0]] = true;
596         kittyActions[_kittyId][_moves[1]] = true;
597         return true;
598     }
599     
600     /**
601      * @dev Used by owner to change all fees on KittyGym.
602      * @param _trainFee The new cost (IN ETHER WEI) of training a new cat.
603      * @param _learnFee The new cost (IN TOKEN WEI) of learning a new move.
604      * @param _rerollFee The new cost (IN TOKEN WEI) of rerolling a move.
605     **/
606     function changeFees(uint256 _trainFee, uint256 _learnFee, uint256 _rerollFee)
607       external
608       onlyOwner
609     {
610         trainFee = _trainFee;
611         learnFee = _learnFee;
612         rerollFee = _rerollFee;
613     }
614 
615     /**
616      * @dev Used by owner to change the amount of actions there are.
617      * @param _newTypeCount The new number of personalities there are.
618     **/
619     function changeVariables(uint256 _newTypeCount)
620       external
621       onlyOwner
622     {
623         if (_newTypeCount != 0) personalityTypes = _newTypeCount;
624     }
625     
626     /**
627      * @dev Owner may use to change any/every connected contract address.
628      * @dev Owner may leave params as null and nothing will happen to that variable.
629      * @param _newData The address of the new cuddle data contract if desired.
630      * @param _newCore The address of the new CK core contract if desired.
631      * @param _newToken The address of the new cuddle token if desired.
632      * @param _newKittyData The address of the new KittyData contract.
633      * @param _newSpecialGym The address of the new SpecialGym contract.
634     **/
635     function changeContracts(address _newData, address _newCore, address _newToken, address _newKittyData,
636                             address _newSpecialGym)
637       external
638       onlyOwner
639     {
640         if (_newData != 0) cuddleData = CuddleData(_newData);
641         if (_newCore != 0) core = KittyCore(_newCore);
642         if (_newToken != 0) token = CuddleCoin(_newToken);
643         if (_newKittyData != 0) kittyData = KittyData(_newKittyData);
644         if (_newSpecialGym != 0) specialGym = _newSpecialGym;
645     }
646     
647 /** ***************************** MODIFIERS ******************************** **/
648     
649     /**
650     * @dev Ensure only the arena contract can call pet count.
651     **/
652     modifier onlyVerified()
653     {
654         require(msg.sender == specialGym);
655         _;
656     }
657     
658     /**
659      * @dev Ensure the sender is not a contract. This removes most of 
660      * @dev the possibility of abuse of our timestamp/blockhash randomizers.
661     **/ 
662     modifier isNotContract() {
663         uint size;
664         address addr = msg.sender;
665         assembly { size := extcodesize(addr) }
666         require(size == 0);
667         _;
668     }
669     
670 }
671 
672 /** ************************************************************************ **/
673 /** **************************** Special Gym ******************************* **/
674 /** ************************************************************************ **/
675 
676 /**
677  * @dev Special Gym is used to train kitties with special
678  * @dev personality types such as graduates.
679 **/
680 contract SpecialGym is Ownable {
681     KittyCore public core;
682     KittyData public kittyData;
683     CuddleData public cuddleData;
684     KittyGym public kittyGym;
685     
686     // Unique CK Id => true if they already have a special.
687     mapping (uint256 => bool) public specialKitties;
688     
689     // Special personality Id => number left that may train. Graduates are Id 50.
690     mapping (uint256 => SpecialPersonality) public specialInfo;
691     
692     struct SpecialPersonality {
693         uint16 population; // Total amount of this special ever available.
694         uint16 amountLeft; // The number of special personalities available to buy.
695         uint256 price; // Price of this special.
696     }
697     
698     event SpecialTrained(uint256 indexed kittyId, uint256 indexed specialId, 
699         uint256 indexed specialRank, uint256[2] specialMoves);
700     
701     function SpecialGym(address _kittyCore, address _kittyData, address _cuddleData, address _kittyGym)
702       public
703     {
704         core = KittyCore(_kittyCore);
705         kittyData = KittyData(_kittyData);
706         cuddleData = CuddleData(_cuddleData);
707         kittyGym = KittyGym(_kittyGym);
708     }
709     
710     /**
711      * @dev Used to buy an exclusive special personality such as graduate.
712      * @param _kittyId The unique CK Id of the kitty to train.
713      * @param _specialId The Id of the special personality being trained.
714      * @param _slots The two move slots where the kitty wants their new moves.
715     **/
716     function trainSpecial(uint256 _kittyId, uint256 _specialId, uint256[2] _slots)
717       external
718       payable
719       isNotContract
720     {
721         SpecialPersonality storage special = specialInfo[_specialId];
722         
723         require(msg.sender == core.ownerOf(_kittyId));
724         require(kittyData.fetchSlot(_kittyId, 0) > 0); // Require kitty has been trained.
725         require(!specialKitties[_kittyId]);
726         require(msg.value == special.price);
727         require(special.amountLeft > 0);
728 
729         // Get two new random special moves.
730         uint256[2] memory randomMoves = randomizeActions(_specialId);
731         
732         assert(kittyData.trainSpecial(_kittyId, _specialId, randomMoves, _slots));
733         assert(kittyGym.addMoves(_kittyId, randomMoves));
734         
735         uint256 specialRank = special.population - special.amountLeft + 1;
736         SpecialTrained(_kittyId, _specialId, specialRank, randomMoves);
737     
738         special.amountLeft--;
739         specialKitties[_kittyId] = true;
740         owner.transfer(msg.value);
741     }
742     
743 /** ******************************* INTERNAL ******************************* **/
744     
745     /**
746      * @dev Return two actions for training or hybridizing a kitty using the given type.
747      * @param _specialType The type of actions that shall be learned. 0 for "any" actions.
748      * @return Two new special moves.
749     **/ 
750     function randomizeActions(uint256 _specialType)
751       internal
752       view
753     returns (uint256[2])
754     {
755         uint256 upper = cuddleData.getActionCount(_specialType);
756         
757         uint256 action1 = random(_specialType, 1, upper);
758         uint256 action2 = random(action1 + 1, 1, upper);
759         if (action1 == action2) {
760             action2 = unduplicate(action1, upper);
761         }
762 
763         uint256 typeBase = 1000 * _specialType;
764         return [action1 + typeBase, action2 + typeBase];
765     }
766     
767     /**
768      * @dev Used to make sure the kitty doesn't learn two of the same move.
769      * @dev If no unique actions can be found, unduplicate throws.
770      * @param _action1 The action that is already known.
771      * @param _upper The amount of actions that can be tried.
772      * @return The new action that is not a duplicate.
773     **/
774     function unduplicate(uint256 _action1, uint256 _upper)
775       internal
776       view
777     returns (uint256)
778     {
779         uint256 action2;
780         for (uint256 i = 1; i < 10; i++) { // Start at 1 to make sure _rnd is never 1.
781             action2 = random(action2 + i, 1, _upper);
782             if (action2 != _action1) break;
783         }
784         
785         // If the kitty still knows the move, simply increment.
786         if (action2 == _action1) {
787             action2 = (_action1 % _upper) + 1;
788         }
789             
790         return action2;
791     }
792     
793     /**
794      * @dev Create a random number.
795      * @param _rnd Seed to help randomize.
796      * @param _lower The lower bound of the random number (inclusive).
797      * @param _upper The upper bound of the random number (exclusive).
798      * @return Returns a fairly random number.
799     **/ 
800     function random(uint256 _rnd, uint256 _lower, uint256 _upper) 
801       internal
802       view
803     returns (uint256) 
804     {
805         uint256 _seed = uint256(keccak256(keccak256(_rnd, _seed), now));
806         return (_seed % _upper) + _lower;
807     }
808     
809 /** ******************************* CONSTANT ****************************** **/
810     
811     /**
812      * @dev Used by frontend to get information on a special.
813      * @param _specialId The unique identifier of the special personality.
814     **/
815     function specialsInfo(uint256 _specialId) 
816       external 
817       view 
818     returns(uint256, uint256) 
819     { 
820         require(_specialId > 0); 
821         return (specialInfo[_specialId].amountLeft, specialInfo[_specialId].price); 
822     }
823     
824 /** ****************************** ONLY OWNER ****************************** **/
825     
826     /**
827      * @dev Used by owner to create and populate a new special personality.
828      * @param _specialId The special's personality Id--starts at 50
829      * @param _amountAvailable The maximum amount of this special that will ever be available.
830      * @param _price The price that the special will be sold for.
831     **/
832     function addSpecial(uint256 _specialId, uint256 _amountAvailable, uint256 _price)
833       external
834       onlyOwner
835     {
836         SpecialPersonality storage special = specialInfo[_specialId];
837         require(special.price == 0);
838         
839         special.population = uint16(_amountAvailable);
840         special.amountLeft = uint16(_amountAvailable);
841         special.price = _price; 
842     }
843     
844     /**
845      * @dev Used by owner to change price of a special kitty or lower available population.
846      * @dev Owner may NOT increase available population to ensure their rarity to players.
847      * @param _specialId The unique Id of the special to edit (graduate is 50).
848      * @param _newPrice The desired new price of the special.
849      * @param _amountToDestroy The amount of this special that we want to lower supply for.
850     **/
851     function editSpecial(uint256 _specialId, uint256 _newPrice, uint16 _amountToDestroy)
852       external
853       onlyOwner
854     {
855         SpecialPersonality storage special = specialInfo[_specialId];
856         
857         if (_newPrice != 0) special.price = _newPrice;
858         if (_amountToDestroy != 0) {
859             require(_amountToDestroy <= special.population && _amountToDestroy <= special.amountLeft);
860             special.population -= _amountToDestroy;
861             special.amountLeft -= _amountToDestroy;
862         }
863     }
864     
865     /**
866      * @dev Owner may use to change any/every connected contract address.
867      * @dev Owner may leave params as null and nothing will happen to that variable.
868      * @param _newData The address of the new cuddle data contract if desired.
869      * @param _newCore The address of the new CK core contract if desired.
870      * @param _newKittyGym The address of the new KittyGym if desired.
871      * @param _newKittyData The address of the new KittyData contract.
872     **/
873     function changeContracts(address _newData, address _newCore, address _newKittyData, address _newKittyGym)
874       external
875       onlyOwner
876     {
877         if (_newData != 0) cuddleData = CuddleData(_newData);
878         if (_newCore != 0) core = KittyCore(_newCore);
879         if (_newKittyData != 0) kittyData = KittyData(_newKittyData);
880         if (_newKittyGym != 0) kittyGym = KittyGym(_newKittyGym);
881     }
882     
883 /** ****************************** MODIFIERS ******************************* **/
884 
885     /**
886      * @dev Ensure the sender is not a contract. This removes most of 
887      * @dev the possibility of abuse of our timestamp/blockhash randomizers.
888     **/ 
889     modifier isNotContract() {
890         uint size;
891         address addr = msg.sender;
892         assembly { size := extcodesize(addr) }
893         require(size == 0);
894         _;
895     }
896     
897 }
898 
899 /**
900  * @title Cuddle Coin
901  * @dev A very straightforward ERC20 contract that also has minting abilities
902  * @dev for people to be able to win coins and purchase coins. EFFECTIVELY CENTRALIZED!
903 **/
904 
905 contract CuddleCoin is Ownable {
906     string public constant symbol = "CDL";
907     string public constant name = "CuddleCoin";
908 
909     address arenaContract; // Needed for minting.
910     address vendingMachine; // Needed for minting and burning.
911     address kittyGym; // Needed for burning.
912     
913     // Storing small numbers is cheaper.
914     uint8 public constant decimals = 18;
915     uint256 _totalSupply = 1000000 * (10 ** 18);
916 
917     // Balances for each account
918     mapping(address => uint256) balances;
919 
920     // Owner of account approves the transfer of an amount to another account
921     mapping(address => mapping (address => uint256)) allowed;
922 
923     event Transfer(address indexed _from, address indexed _to, uint256 indexed _amount);
924     event Approval(address indexed _from, address indexed _spender, uint256 indexed _amount);
925     event Mint(address indexed _to, uint256 indexed _amount);
926     event Burn(address indexed _from, uint256 indexed _amount);
927 
928     /**
929      * @dev Set owner and beginning balance.
930     **/
931     function CuddleCoin(address _arenaContract, address _vendingMachine)
932       public
933     {
934         balances[msg.sender] = _totalSupply;
935         arenaContract = _arenaContract;
936         vendingMachine = _vendingMachine;
937     }
938 
939     /**
940      * @dev Return total supply of token
941     **/
942     function totalSupply() 
943       external
944       constant 
945      returns (uint256) 
946     {
947         return _totalSupply;
948     }
949 
950     /**
951      * @dev Return balance of a certain address.
952      * @param _owner The address whose balance we want to check.
953     **/
954     function balanceOf(address _owner)
955       external
956       constant 
957     returns (uint256) 
958     {
959         return balances[_owner];
960     }
961 
962     /**
963      * @dev Transfers coins from one address to another.
964      * @param _to The recipient of the transfer amount.
965      * @param _amount The amount of tokens to transfer.
966     **/
967     function transfer(address _to, uint256 _amount) 
968       external
969     returns (bool success)
970     {
971         // Throw if insufficient balance
972         require(balances[msg.sender] >= _amount);
973 
974         balances[msg.sender] -= _amount;
975         balances[_to] += _amount;
976 
977         Transfer(msg.sender, _to, _amount);
978         return true;
979     }
980 
981     /**
982      * @dev An allowed address can transfer tokens from another's address.
983      * @param _from The owner of the tokens to be transferred.
984      * @param _to The address to which the tokens will be transferred.
985      * @param _amount The amount of tokens to be transferred.
986     **/
987     function transferFrom(address _from, address _to, uint _amount)
988       external
989     returns (bool success)
990     {
991         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
992 
993         allowed[_from][msg.sender] -= _amount;
994         balances[_from] -= _amount;
995         balances[_to] += _amount;
996         
997         Transfer(_from, _to, _amount);
998         return true;
999     }
1000 
1001     /**
1002      * @dev Approves a wallet to transfer tokens on one's behalf.
1003      * @param _spender The wallet approved to spend tokens.
1004      * @param _amount The amount of tokens approved to spend.
1005     **/
1006     function approve(address _spender, uint256 _amount) 
1007       external
1008     {
1009         require(_amount == 0 || allowed[msg.sender][_spender] == 0);
1010         require(balances[msg.sender] >= _amount);
1011         
1012         allowed[msg.sender][_spender] = _amount;
1013         Approval(msg.sender, _spender, _amount);
1014     }
1015 
1016     /**
1017      * @dev Allowed amount for a user to spend of another's tokens.
1018      * @param _owner The owner of the tokens approved to spend.
1019      * @param _spender The address of the user allowed to spend the tokens.
1020     **/
1021     function allowance(address _owner, address _spender) 
1022       external
1023       constant 
1024     returns (uint256) 
1025     {
1026         return allowed[_owner][_spender];
1027     }
1028     
1029     /**
1030      * @dev Used only be vending machine and arena contract to mint to
1031      * @dev token purchases and cuddlers in a battle.
1032      * @param _to The address to which coins will be minted.
1033      * @param _amount The amount of coins to be minted to that address.
1034     **/
1035     function mint(address _to, uint256 _amount)
1036       external
1037       onlyMinter
1038     returns (bool success)
1039     {
1040         balances[_to] += _amount;
1041         
1042         Mint(_to, _amount);
1043         return true;
1044     }
1045     
1046     /**
1047      * @dev Used by kitty gym and vending machine to take coins from users.
1048      * @param _from The address that will have coins burned.
1049      * @param _amount The amount of coins that will be burned.
1050     **/
1051     function burn(address _from, uint256 _amount)
1052       external
1053       onlyMinter
1054     returns (bool success)
1055     {
1056         require(balances[_from] >= _amount);
1057         
1058         balances[_from] -= _amount;
1059         Burn(_from, _amount);
1060         return true;
1061     }
1062       
1063     /**
1064      * @dev Owner my change the contracts allowed to mint.
1065      * @dev This gives owner full control over these tokens but since they are
1066      * @dev not a normal cryptocurrency, centralization is not a problem.
1067      * @param _arenaContract The first contract allowed to mint coins.
1068      * @param _vendingMachine The second contract allowed to mint coins.
1069     **/
1070     function changeMinters(address _arenaContract, address _vendingMachine, address _kittyGym)
1071       external
1072       onlyOwner
1073     returns (bool success)
1074     {
1075         if (_arenaContract != 0) arenaContract = _arenaContract;
1076         if (_vendingMachine != 0) vendingMachine = _vendingMachine;
1077         if (_kittyGym != 0) kittyGym = _kittyGym;
1078         
1079         return true;
1080     }
1081     
1082     /**
1083      * @dev Arena contract and vending machine contract must be able to mint coins.
1084      * @dev This modifier ensures no other contract may be able to mint.
1085      * @dev Owner can change these permissions.
1086     **/
1087     modifier onlyMinter()
1088     {
1089         require(msg.sender == arenaContract || msg.sender == vendingMachine || msg.sender == kittyGym);
1090         _;
1091     }
1092 }