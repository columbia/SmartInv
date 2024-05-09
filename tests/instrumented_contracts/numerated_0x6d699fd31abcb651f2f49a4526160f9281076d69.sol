1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(isOwner(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Returns true if the caller is the current owner.
69      */
70     function isOwner() public view returns (bool) {
71         return _msgSender() == _owner;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 	/**
261      * @dev Interface to the staking contract for ERC-20 token pools.
262      */
263 interface SmolTingPot {
264     function withdraw(uint256 _pid, uint256 _amount, address _staker) external;
265     function poolLength() external view returns (uint256);
266     function pendingTing(uint256 _pid, address _user) external view returns (uint256);
267 }
268 
269 	/**
270      * @dev Interface to the ERC-1155 NFT contract for smol.finance
271      */
272 interface SmolStudio {
273     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
274     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
275     function setApprovalForAll(address _operator, bool _approved) external;
276     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
277     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
278 }
279 
280 	/**
281      * @dev Interface to the farmed currency.
282      */
283 interface SmolTing {
284     function totalSupply() external view returns (uint256);
285     function totalClaimed() external view returns (uint256);
286     function addClaimed(uint256 _amount) external;
287     function setClaimed(uint256 _amount) external;
288     function transfer(address receiver, uint numTokens) external returns (bool);
289     function transferFrom(address owner, address buyer, uint numTokens) external returns (bool);
290     function balanceOf(address owner) external view returns (uint256);
291     function mint(address _to, uint256 _amount) external;
292     function burn(address _account, uint256 value) external;
293 }
294 
295 	/**
296      * @dev Interface to the exclusive booster contract.
297      */
298 interface TingBooster {
299     function getMultiplierOfAddress(address _addr) external view returns (uint256);
300 }
301 
302 	/**
303      * @dev Contract for handling the NFT staking and set creation.
304      */
305 contract SmolMuseum is Ownable {
306     using SafeMath for uint256;
307 
308     struct CardSet {
309         uint256[] cardIds;
310         uint256 tingPerDayPerCard;
311         uint256 bonusTingMultiplier;     	// 100% bonus = 1e5
312         bool isBooster;                   	// False if the card set doesn't give pool boost at smolTingPot
313         uint256[] poolBoosts;            	// 100% bonus = 1e5. Applicable if isBooster is true.Eg: [0,20000] = 0% boost for pool 1, 20% boost for pool 2
314         uint256 bonusFullSetBoost;          // 100% bonus = 1e5. Gives an additional boost if you stake all boosters of that set.
315         bool isRemoved;
316     }
317 
318     SmolStudio public smolStudio;
319     SmolTing public ting;
320     TingBooster public tingBooster;
321     SmolTingPot public smolTingPot;
322     address public treasuryAddr;
323 
324     uint256[] public cardSetList;
325 	//Highest CardId added to the museum
326     uint256 public highestCardId;
327 	//SetId mapped to all card IDs in the set.
328     mapping (uint256 => CardSet) public cardSets;
329 	//CardId to SetId mapping
330     mapping (uint256 => uint256) public cardToSetMap;
331 	//Status of user's cards staked mapped to the cardID
332     mapping (address => mapping(uint256 => bool)) public userCards;
333 	//Last update time for a user's TING rewards calculation
334     mapping (address => uint256) public userLastUpdate;
335 
336     event Stake(address indexed user, uint256[] cardIds);
337     event Unstake(address indexed user, uint256[] cardIds);
338     event Harvest(address indexed user, uint256 amount);
339 
340     constructor(SmolTingPot _smolTingPotAddr, SmolStudio _smolStudioAddr, SmolTing _tingAddr, TingBooster _tingBoosterAddr, address _treasuryAddr) public {
341         smolTingPot = _smolTingPotAddr;
342         smolStudio = _smolStudioAddr;
343         ting = _tingAddr;
344         tingBooster = _tingBoosterAddr;
345         treasuryAddr = _treasuryAddr;
346     }
347 
348 	/**
349      * @dev Utility function to check if a value is inside an array
350      */
351     function _isInArray(uint256 _value, uint256[] memory _array) internal pure returns(bool) {
352         uint256 length = _array.length;
353         for (uint256 i = 0; i < length; ++i) {
354             if (_array[i] == _value) {
355                 return true;
356             }
357         }
358         return false;
359     }
360 
361 	/**
362      * @dev Indexed boolean for whether a card is staked or not. Index represents the cardId.
363      */
364     function getCardsStakedOfAddress(address _user) public view returns(bool[] memory) {
365         bool[] memory cardsStaked = new bool[](highestCardId + 1);
366         for (uint256 i = 0; i < highestCardId + 1; ++i) {			
367             cardsStaked[i] = userCards[_user][i];
368         }
369         return cardsStaked;
370     }
371     
372 	/**
373      * @dev Returns the list of cardIds which are part of a set
374      */
375     function getCardIdListOfSet(uint256 _setId) external view returns(uint256[] memory) {
376         return cardSets[_setId].cardIds;
377     }
378     
379     /**
380      * @dev Returns the boosters associated with a card Id per pool
381      */
382     function getBoostersOfCard(uint256 _cardId) external view returns(uint256[] memory) {
383         return cardSets[cardToSetMap[_cardId]].poolBoosts;
384     }
385 	
386 	/**
387      * @dev Indexed  boolean of each setId for which a user has a full set or not.
388      */
389     function getFullSetsOfAddress(address _user) public view returns(bool[] memory) {
390         uint256 length = cardSetList.length;
391         bool[] memory isFullSet = new bool[](length);
392         for (uint256 i = 0; i < length; ++i) {
393             uint256 setId = cardSetList[i];
394             if (cardSets[setId].isRemoved) {
395                 isFullSet[i] = false;
396                 continue;
397             }
398             bool _fullSet = true;
399             uint256[] memory _cardIds = cardSets[setId].cardIds;
400 			
401             for (uint256 j = 0; j < _cardIds.length; ++j) {
402                 if (userCards[_user][_cardIds[j]] == false) {
403                     _fullSet = false;
404                     break;
405                 }
406             }
407             isFullSet[i] = _fullSet;
408         }
409         return isFullSet;
410     }
411 
412 	/**
413      * @dev Returns the amount of NFTs staked by an address for a given set
414      */
415     function getNumOfNftsStakedForSet(address _user, uint256 _setId) public view returns(uint256) {
416         uint256 nbStaked = 0;
417         if (cardSets[_setId].isRemoved) return 0;
418         uint256 length = cardSets[_setId].cardIds.length;
419         for (uint256 j = 0; j < length; ++j) {
420             uint256 cardId = cardSets[_setId].cardIds[j];
421             if (userCards[_user][cardId] == true) {
422                 nbStaked = nbStaked.add(1);
423             }
424         }
425         return nbStaked;
426     }
427 
428 	/**
429      * @dev Returns the total amount of NFTs staked by an address across all sets
430      */
431     function getNumOfNftsStakedByAddress(address _user) public view returns(uint256) {
432         uint256 nbStaked = 0;
433         for (uint256 i = 0; i < cardSetList.length; ++i) {
434             nbStaked = nbStaked.add(getNumOfNftsStakedForSet(_user, cardSetList[i]));
435         }
436         return nbStaked;
437     }
438     
439 	/**
440      * @dev Returns the total ting pending for a given address. Can include the bonus from TingBooster,
441 	 * if second param is set to true.
442      */
443     function totalPendingTingOfAddress(address _user, bool _includeTingBooster) public view returns (uint256) {
444         uint256 totalTingPerDay = 0;
445         uint256 length = cardSetList.length;
446         for (uint256 i = 0; i < length; ++i) {
447             uint256 setId = cardSetList[i];
448             CardSet storage set = cardSets[setId];
449             if (set.isRemoved) continue;
450             uint256 cardLength = set.cardIds.length;
451             bool isFullSet = true;
452             uint256 setTingPerDay = 0;
453             for (uint256 j = 0; j < cardLength; ++j) {
454                 if (userCards[_user][set.cardIds[j]] == false) {
455                     isFullSet = false;
456                     continue;
457                 }
458                 setTingPerDay = setTingPerDay.add(set.tingPerDayPerCard);
459             }
460             if (isFullSet) {
461                 setTingPerDay = setTingPerDay.mul(set.bonusTingMultiplier).div(1e5);
462             }
463             totalTingPerDay = totalTingPerDay.add(setTingPerDay);
464         }
465 
466         if (_includeTingBooster) {
467 			uint256 boostMult = tingBooster.getMultiplierOfAddress(_user).add(1e5);
468             totalTingPerDay = totalTingPerDay.mul(boostMult).div(1e5);
469         }
470         uint256 lastUpdate = userLastUpdate[_user];
471         uint256 blockTime = block.timestamp;
472         return blockTime.sub(lastUpdate).mul(totalTingPerDay.div(86400));
473     }
474 
475 	/**
476      * @dev Returns the pending ting coming from the bonus generated by TingBooster
477      */
478     function totalPendingTingOfAddressFromBooster(address _user) external view returns (uint256) {
479         uint256 totalPending = totalPendingTingOfAddress(_user, false);
480 		uint256 userBoost = tingBooster.getMultiplierOfAddress(_user).add(1e5);
481         return totalPending.mul(userBoost).div(1e5);
482     }
483     
484     /**
485      * @dev Returns the applicable booster of a user, for a pool, from a staked NFT set.
486      */
487     function getBoosterForUser(address _user, uint256 _pid) public view returns (uint256) {
488         uint256 totalBooster = 0;
489         uint256 length = cardSetList.length;
490         for (uint256 i = 0; i < length; ++i) {
491             uint256 setId = cardSetList[i];
492             CardSet storage set = cardSets[setId];
493             if (set.isBooster == false) continue;
494             if (set.poolBoosts.length < _pid.add(1)) continue;
495             if (set.poolBoosts[_pid] == 0) continue;
496             uint256 cardLength = set.cardIds.length;
497             bool isFullSet = true;
498             uint256 setBooster = 0;
499             for (uint256 j = 0; j < cardLength; ++j) {
500                 if (userCards[_user][set.cardIds[j]] == false) {
501                     isFullSet = false;
502                     continue;
503                 }
504                 setBooster = setBooster.add(set.poolBoosts[_pid]);
505             }
506             if (isFullSet) {
507                 setBooster = setBooster.add(set.bonusFullSetBoost);
508             }
509             totalBooster = totalBooster.add(setBooster);
510         }
511         return totalBooster;
512     }
513 
514 	/**
515      * @dev Manually sets the highestCardId, if it goes out of sync.
516 	 * Required calculate the range for iterating the list of staked cards for an address.
517      */
518     function setHighestCardId(uint256 _highestId) public onlyOwner {
519         require(_highestId > 0, "Set if minimum 1 card is staked.");
520         highestCardId = _highestId;
521     }
522 
523 	/**
524      * @dev Adds a card set with the input param configs. Removes an existing set if the id exists.
525      */
526     function addCardSet(uint256 _setId, uint256[] memory _cardIds, uint256 _bonusTingMultiplier, uint256 _tingPerDayPerCard, uint256[] memory _poolBoosts, uint256 _bonusFullSetBoost, bool _isBooster) public onlyOwner {
527         removeCardSet(_setId);
528         uint256 length = _cardIds.length;
529         for (uint256 i = 0; i < length; ++i) {
530             uint256 cardId = _cardIds[i];
531             if (cardId > highestCardId) {
532                 highestCardId = cardId;
533             }
534             // Check all cards to assign arent already part of another set
535             require(cardToSetMap[cardId] == 0, "Card already assigned to a set");
536             // Assign to set
537             cardToSetMap[cardId] = _setId;
538         }
539         if (_isInArray(_setId, cardSetList) == false) {
540             cardSetList.push(_setId);
541         }
542         cardSets[_setId] = CardSet({
543         cardIds: _cardIds,
544         bonusTingMultiplier: _bonusTingMultiplier,
545         tingPerDayPerCard: _tingPerDayPerCard,
546         isBooster: _isBooster,
547         poolBoosts: _poolBoosts,
548         bonusFullSetBoost: _bonusFullSetBoost,
549         isRemoved: false
550         });
551     }
552 
553 	/**
554      * @dev Updates the tingPerDayPerCard for a card set.
555      */
556     function setTingRateOfSets(uint256[] memory _setIds, uint256[] memory _tingPerDayPerCard) public onlyOwner {
557         require(_setIds.length == _tingPerDayPerCard.length, "_setId and _tingPerDayPerCard have different length");
558         for (uint256 i = 0; i < _setIds.length; ++i) {
559             require(cardSets[_setIds[i]].cardIds.length > 0, "Set is empty");
560             cardSets[_setIds[i]].tingPerDayPerCard = _tingPerDayPerCard[i];
561         }
562     }
563 
564 	/**
565      * @dev Set the bonusTingMultiplier value for a list of Card sets
566      */
567     function setBonusTingMultiplierOfSets(uint256[] memory _setIds, uint256[] memory _bonusTingMultiplier) public onlyOwner {
568         require(_setIds.length == _bonusTingMultiplier.length, "_setId and _tingPerDayPerCard have different length");
569         for (uint256 i = 0; i < _setIds.length; ++i) {
570             require(cardSets[_setIds[i]].cardIds.length > 0, "Set is empty");
571             cardSets[_setIds[i]].bonusTingMultiplier = _bonusTingMultiplier[i];
572         }
573     }
574 
575 	/**
576      * @dev Remove a cardSet that has been added.
577 	 * !!!  Warning : if a booster set is removed, users with the booster staked will continue to benefit from the multiplier  !!!
578      */
579     function removeCardSet(uint256 _setId) public onlyOwner {
580         uint256 length = cardSets[_setId].cardIds.length;
581         for (uint256 i = 0; i < length; ++i) {
582             uint256 cardId = cardSets[_setId].cardIds[i];
583             cardToSetMap[cardId] = 0;
584         }
585         delete cardSets[_setId].cardIds;
586         cardSets[_setId].isRemoved = true;
587         cardSets[_setId].isBooster = false;
588     }
589 
590 	/**
591      * @dev Harvests the accumulated TING in the contract, for the caller.
592      */
593     function harvest() public {
594         uint256 pendingTing = totalPendingTingOfAddress(msg.sender, true);
595         userLastUpdate[msg.sender] = block.timestamp;
596         if (pendingTing > 0) {
597             ting.mint(treasuryAddr, pendingTing.div(40)); // 2.5% TING for the treasury (Usable to purchase NFTs)
598             ting.mint(msg.sender, pendingTing);
599             ting.addClaimed(pendingTing);
600         }
601         emit Harvest(msg.sender, pendingTing);
602     }
603 
604 	/**
605      * @dev Stakes the cards on providing the card IDs. 
606      */
607     function stake(uint256[] memory _cardIds) public {
608         require(_cardIds.length > 0, "you need to stake something");
609 
610         // Check no card will end up above max stake and if it is needed to update the user NFT pool
611         uint256 length = _cardIds.length;
612         bool onlyBoosters = true;
613         bool onlyNoBoosters = true;
614         for (uint256 i = 0; i < length; ++i) {
615             uint256 cardId = _cardIds[i];
616             require(userCards[msg.sender][cardId] == false, "item already staked");
617             require(cardToSetMap[cardId] != 0, "you can't stake that");
618             if (cardSets[cardToSetMap[cardId]].tingPerDayPerCard > 0) onlyBoosters = false;
619             if (cardSets[cardToSetMap[cardId]].isBooster == true) onlyNoBoosters = false;
620         }
621                 // Harvest NFT pool if the Ting/day will be modified
622         if (onlyBoosters == false) harvest();
623         
624             	// Harvest each pool where booster value will be modified 
625         if (onlyNoBoosters == false) {
626             for (uint256 i = 0; i < length; ++i) {                                                                  
627                 uint256 cardId = _cardIds[i];
628                 if (cardSets[cardToSetMap[cardId]].isBooster) {
629                     CardSet storage cardSet = cardSets[cardToSetMap[cardId]];
630                     uint256 boostLength = cardSet.poolBoosts.length;
631                     for (uint256 j = 0; j < boostLength; ++j) {                                                     
632                         if (cardSet.poolBoosts[j] > 0 && smolTingPot.pendingTing(j, msg.sender) > 0) {
633                             address staker = msg.sender;
634                             smolTingPot.withdraw(j, 0, staker);   
635                         }
636                     }
637                 }
638             }
639         }
640         
641         //Stake 1 unit of each cardId
642         uint256[] memory amounts = new uint256[](_cardIds.length);
643         for (uint256 i = 0; i < _cardIds.length; ++i) {
644             amounts[i] = 1;
645         }
646         smolStudio.safeBatchTransferFrom(msg.sender, address(this), _cardIds, amounts, "");
647 		//Update the staked status for the card ID.
648         for (uint256 i = 0; i < length; ++i) {
649             uint256 cardId = _cardIds[i];
650             userCards[msg.sender][cardId] = true;
651         }
652         emit Stake(msg.sender, _cardIds);
653     }
654 
655 	/**
656      * @dev Unstakes the cards on providing the card IDs. 
657      */
658     function unstake(uint256[] memory _cardIds) public {
659  
660          require(_cardIds.length > 0, "input at least 1 card id");
661 
662         // Check if all cards are staked and if it is needed to update the user NFT pool
663         uint256 length = _cardIds.length;
664         bool onlyBoosters = true;
665         bool onlyNoBoosters = true;
666         for (uint256 i = 0; i < length; ++i) {
667             uint256 cardId = _cardIds[i];
668             require(userCards[msg.sender][cardId] == true, "Card not staked");
669             userCards[msg.sender][cardId] = false;
670             if (cardSets[cardToSetMap[cardId]].tingPerDayPerCard > 0) onlyBoosters = false;
671             if (cardSets[cardToSetMap[cardId]].isBooster == true) onlyNoBoosters = false;
672         }
673         
674         if (onlyBoosters == false) harvest();
675 
676     				// Harvest each pool where booster value will be modified  
677         if (onlyNoBoosters == false) {
678             for (uint256 i = 0; i < length; ++i) {                                                                  
679                 uint256 cardId = _cardIds[i];
680                 if (cardSets[cardToSetMap[cardId]].isBooster) {
681                     CardSet storage cardSet = cardSets[cardToSetMap[cardId]];
682                     uint256 boostLength = cardSet.poolBoosts.length;
683                     for (uint256 j = 0; j < boostLength; ++j) {                                                     
684                         if (cardSet.poolBoosts[j] > 0 && smolTingPot.pendingTing(j, msg.sender) > 0) {
685                             address staker = msg.sender;
686                             smolTingPot.withdraw(j, 0, staker);   
687                         }
688                     }
689                 }
690             }
691         }
692 
693         //UnStake 1 unit of each cardId
694         uint256[] memory amounts = new uint256[](_cardIds.length);
695         for (uint256 i = 0; i < _cardIds.length; ++i) {
696             amounts[i] = 1;
697         }
698         smolStudio.safeBatchTransferFrom(address(this), msg.sender, _cardIds, amounts, "");
699         emit Unstake(msg.sender, _cardIds);
700     }
701 
702 	/**
703      * @dev Emergency unstake the cards on providing the card IDs, forfeiting the TING rewards in both Museum and SmolTingPot.
704      */
705     function emergencyUnstake(uint256[] memory _cardIds) public {
706         userLastUpdate[msg.sender] = block.timestamp;
707         uint256 length = _cardIds.length;
708         for (uint256 i = 0; i < length; ++i) {
709             uint256 cardId = _cardIds[i];
710             require(userCards[msg.sender][cardId] == true, "Card not staked");
711             userCards[msg.sender][cardId] = false;
712         }
713 
714         //UnStake 1 unit of each cardId
715         uint256[] memory amounts = new uint256[](_cardIds.length);
716         for (uint256 i = 0; i < _cardIds.length; ++i) {
717             amounts[i] = 1;
718         }
719         smolStudio.safeBatchTransferFrom(address(this), msg.sender, _cardIds, amounts, "");
720     }
721     
722 	/**
723      * @dev Update TingBooster contract address linked to smolMuseum.
724      */
725     function updateTingBoosterAddress(TingBooster _tingBoosterAddress) public onlyOwner{
726         tingBooster = _tingBoosterAddress;
727     }
728 	
729 	// update pot address if the pot logic changed.
730     function updateSmolTingPotAddress(SmolTingPot _smolTingPotAddress) public onlyOwner{
731         smolTingPot = _smolTingPotAddress;
732     }
733     
734 	/**
735      * @dev Update treasury address by the previous treasury.
736      */
737     function treasury(address _treasuryAddr) public {
738         require(msg.sender == treasuryAddr, "Only current treasury address can update.");
739         treasuryAddr = _treasuryAddr;
740     }
741 
742     /**
743      * @notice Handle the receipt of a single ERC1155 token type
744      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
745      * This function MAY throw to revert and reject the transfer
746      * Return of other amount than the magic value MUST result in the transaction being reverted
747      * Note: The token contract address is always the message sender
748      * @param _operator  The address which called the `safeTransferFrom` function
749      * @param _from      The address which previously owned the token
750      * @param _id        The id of the token being transferred
751      * @param _amount    The amount of tokens being transferred
752      * @param _data      Additional data with no specified format
753      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
754      */
755     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4) {
756         return 0xf23a6e61;
757     }
758 
759     /**
760      * @notice Handle the receipt of multiple ERC1155 token types
761      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
762      * This function MAY throw to revert and reject the transfer
763      * Return of other amount than the magic value WILL result in the transaction being reverted
764      * Note: The token contract address is always the message sender
765      * @param _operator  The address which called the `safeBatchTransferFrom` function
766      * @param _from      The address which previously owned the token
767      * @param _ids       An array containing ids of each token being transferred
768      * @param _amounts   An array containing amounts of each token being transferred
769      * @param _data      Additional data with no specified format
770      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
771      */
772     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4) {
773         return 0xbc197c81;
774     }
775 
776     /**
777      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
778      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
779      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
780      *      This function MUST NOT consume more than 5,000 gas.
781      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
782      */
783     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
784         return  interfaceID == 0x01ffc9a7 ||    // ERC-165 support (i.e. `bytes4(keccak256('supportsInterface(bytes4)'))`).
785         interfaceID == 0x4e2312e0;      // ERC-1155 `ERC1155TokenReceiver` support (i.e. `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) ^ bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`).
786     }
787 }