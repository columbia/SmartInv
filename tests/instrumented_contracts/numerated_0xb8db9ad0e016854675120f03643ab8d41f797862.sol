1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Returns true if the caller is the current owner.
71      */
72     function isOwner() public view returns (bool) {
73         return _msgSender() == _owner;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      *
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 interface RMU {
264     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
265     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
266     function setApprovalForAll(address _operator, bool _approved) external;
267     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
268     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
269 }
270 
271 interface Hope {
272     function totalSupply() external view returns (uint256);
273     function totalClaimed() external view returns (uint256);
274     function addClaimed(uint256 _amount) external;
275     function setClaimed(uint256 _amount) external;
276     function transfer(address receiver, uint numTokens) external returns (bool);
277     function transferFrom(address owner, address buyer, uint numTokens) external returns (bool);
278     function balanceOf(address owner) external view returns (uint256);
279     function mint(address _to, uint256 _amount) external;
280     function burn(address _account, uint256 value) external;
281 }
282 
283 interface HopeBooster {
284     function getMultiplier(uint256 ropeAmount) external view returns (uint256);
285     function getMultiplierOfAddress(address _addr) external view returns (uint256);
286     function pendingHope(address _user) external view returns (uint256);
287     function hopePerDayOfAddress(address _addr) external view returns (uint256);
288     function addClaimed(uint256 _amount) external;
289 }
290 
291 contract CardKeeper is Ownable {
292     using SafeMath for uint256;
293 
294     struct CardSet {
295         uint256[] cardIds;
296         uint256 hopePerDayPerCard;
297         uint256 bonusHopeMultiplier; // 100% bonus = 1e5
298         bool isRemoved;
299     }
300 
301     RMU public ropeMaker;
302     Hope public hope;
303     HopeBooster public hopeBooster;
304     address public treasuryAddr;
305 
306     uint256[] public cardSetList;
307     uint256 public highestCardId;
308     mapping (uint256 => CardSet) public cardSets;
309     mapping (uint256 => uint256) public cardToSetMap;
310 
311     mapping (address => mapping(uint256 => bool)) public userCards;
312     mapping (address => uint256) public userLastUpdate;
313 
314     event Stake(address indexed user, uint256[] cardIds);
315     event Unstake(address indexed user, uint256[] cardIds);
316     event Harvest(address indexed user, uint256 amount);
317 
318     constructor(RMU _ropeMakerAddr, Hope _hopeAddr, HopeBooster _hopeBoosterAddr, address _treasuryAddr) public {
319         ropeMaker = _ropeMakerAddr;
320         hope = _hopeAddr;
321         hopeBooster = _hopeBoosterAddr;
322         treasuryAddr = _treasuryAddr;
323     }
324 
325     // Utility function to check if a value is inside an array
326     function _isInArray(uint256 _value, uint256[] memory _array) internal pure returns(bool) {
327         uint256 length = _array.length;
328         for (uint256 i = 0; i < length; ++i) {
329             if (_array[i] == _value) {
330                 return true;
331             }
332         }
333 
334         return false;
335     }
336 
337     // Index of the value in the return array is the cardId, value is whether card is staked or not
338     function getCardsStakedOfAddress(address _user) public view returns(bool[] memory) {
339         bool[] memory cardsStaked = new bool[](highestCardId + 1);
340 
341         for (uint256 i = 0; i < highestCardId + 1; ++i) {
342             cardsStaked[i] = userCards[_user][i];
343         }
344 
345         return cardsStaked;
346     }
347 
348     // Returns the list of cardIds which are part of a set
349     function getCardIdListOfSet(uint256 _setId) external view returns(uint256[] memory) {
350         return cardSets[_setId].cardIds;
351     }
352 
353     function getFullSetsOfAddress(address _user) public view returns(bool[] memory) {
354         uint256 length = cardSetList.length;
355 
356         bool[] memory isFullSet = new bool[](length);
357         for (uint256 i = 0; i < length; ++i) {
358             uint256 setId = cardSetList[i];
359 
360             if (cardSets[setId].isRemoved) {
361                 isFullSet[i] = false;
362                 continue;
363             }
364 
365             bool _fullSet = true;
366 
367             uint256[] memory _cardIds = cardSets[setId].cardIds;
368             for (uint256 j = 0; j < _cardIds.length; ++j) {
369                 if (userCards[_user][_cardIds[j]] == false) {
370                     _fullSet = false;
371                     break;
372                 }
373             }
374 
375             isFullSet[i] = _fullSet;
376         }
377 
378         return isFullSet;
379     }
380 
381     // Returns the amount of nft staked by an address for a given set
382     function getNbSetNftStakedOfAddress(address _user, uint256 _setId) public view returns(uint256) {
383         uint256 nbStaked = 0;
384 
385         if (cardSets[_setId].isRemoved) return 0;
386 
387         uint256 length = cardSets[_setId].cardIds.length;
388         for (uint256 j = 0; j < length; ++j) {
389             uint256 cardId = cardSets[_setId].cardIds[j];
390             if (userCards[_user][cardId] == true) {
391                 nbStaked = nbStaked.add(1);
392             }
393         }
394 
395         return nbStaked;
396     }
397 
398     // Returns the total amount of nft staked by an address across all sets
399     function getNbNftStakedOfAddress(address _user) public view returns(uint256) {
400         uint256 nbStaked = 0;
401 
402         for (uint256 i = 0; i < cardSetList.length; ++i) {
403             nbStaked = nbStaked.add(getNbSetNftStakedOfAddress(_user, cardSetList[i]));
404         }
405 
406         return nbStaked;
407     }
408 
409 
410     // Returns the total hope pending for a given address
411     // Can include the bonus from hopeBooster or not
412     function totalPendingHopeOfAddress(address _user, bool _includeHopeBooster) public view returns (uint256) {
413         uint256 totalHopePerDay = 0;
414 
415         uint256 length = cardSetList.length;
416         for (uint256 i = 0; i < length; ++i) {
417             uint256 setId = cardSetList[i];
418             CardSet storage set = cardSets[setId];
419 
420             if (set.isRemoved) continue;
421 
422             // bool isFullSet = fullSets[i];
423 
424             uint256 cardLength = set.cardIds.length;
425 
426             bool isFullSet = true;
427             uint256 setHopePerDay = 0;
428             for (uint256 j = 0; j < cardLength; ++j) {
429                 if (userCards[_user][set.cardIds[j]] == false) {
430                     isFullSet = false;
431                     continue;
432                 }
433 
434                 setHopePerDay = setHopePerDay.add(set.hopePerDayPerCard);
435             }
436 
437             if (isFullSet) {
438                 setHopePerDay = setHopePerDay.mul(set.bonusHopeMultiplier).div(1e5);
439             }
440 
441             totalHopePerDay = totalHopePerDay.add(setHopePerDay);
442         }
443 
444         // Apply hopeBooster bonus
445         if (_includeHopeBooster) {
446             uint256 toAdd = totalHopePerDay.mul(hopeBooster.getMultiplierOfAddress(_user)).div(1e5);
447             totalHopePerDay = totalHopePerDay.add(toAdd);
448         }
449 
450         uint256 lastUpdate = userLastUpdate[_user];
451         uint256 blockTime = block.timestamp;
452         return blockTime.sub(lastUpdate).mul(totalHopePerDay.div(86400));
453     }
454 
455     // Returns the pending hope coming from the bonus generated by HopeBooster
456     function totalPendingHopeOfAddressFromBooster(address _user) external view returns (uint256) {
457         uint256 totalPending = totalPendingHopeOfAddress(_user, false);
458         return totalPending.mul(hopeBooster.getMultiplierOfAddress(_user)).div(1e5);
459     }
460 
461     //////////////////////////////
462     //////////////////////////////
463     //////////////////////////////
464 
465     // Set manually the highestCardId, in case there has been a mistake while adding a set
466     // (This value is used to know the range in which iterate to get the list of staked cards for an address)
467     function setHighestCardId(uint256 _highestId) public onlyOwner {
468         require(_highestId > 0);
469         highestCardId = _highestId;
470     }
471 
472     function addCardSet(uint256 _setId, uint256[] memory _cardIds, uint256 _bonusHopeMultiplier, uint256 _hopePerDayPerCard) public onlyOwner {
473         removeCardSet(_setId);
474 
475         uint256 length = _cardIds.length;
476         for (uint256 i = 0; i < length; ++i) {
477             uint256 cardId = _cardIds[i];
478 
479             if (cardId > highestCardId) {
480                 highestCardId = cardId;
481             }
482 
483             // Check all cards to assign arent already part of another set
484             require(cardToSetMap[cardId] == 0, "Card already assigned to a set");
485 
486             // Assign to set
487             cardToSetMap[cardId] = _setId;
488         }
489 
490         if (_isInArray(_setId, cardSetList) == false) {
491             cardSetList.push(_setId);
492         }
493 
494         cardSets[_setId] = CardSet({
495         cardIds: _cardIds,
496         bonusHopeMultiplier: _bonusHopeMultiplier,
497         hopePerDayPerCard: _hopePerDayPerCard,
498         isRemoved: false
499         });
500     }
501 
502     // Set the hopePerDayPerCard value for a list of sets
503     function setHopeRateOfSets(uint256[] memory _setIds, uint256[] memory _hopePerDayPerCard) public onlyOwner {
504         require(_setIds.length == _hopePerDayPerCard.length, "_setId and _hopePerDayPerCard have different length");
505 
506         for (uint256 i = 0; i < _setIds.length; ++i) {
507             require(cardSets[_setIds[i]].cardIds.length > 0, "Set is empty");
508             cardSets[_setIds[i]].hopePerDayPerCard = _hopePerDayPerCard[i];
509         }
510     }
511 
512     // Set the bonusHopeMultiplier value for a list of sets
513     function setBonusHopeMultiplierOfSets(uint256[] memory _setIds, uint256[] memory _bonusHopeMultiplier) public onlyOwner {
514         require(_setIds.length == _bonusHopeMultiplier.length, "_setId and _hopePerDayPerCard have different length");
515 
516         for (uint256 i = 0; i < _setIds.length; ++i) {
517             require(cardSets[_setIds[i]].cardIds.length > 0, "Set is empty");
518             cardSets[_setIds[i]].bonusHopeMultiplier = _bonusHopeMultiplier[i];
519         }
520     }
521 
522     function removeCardSet(uint256 _setId) public onlyOwner {
523         uint256 length = cardSets[_setId].cardIds.length;
524         for (uint256 i = 0; i < length; ++i) {
525             uint256 cardId = cardSets[_setId].cardIds[i];
526             cardToSetMap[cardId] = 0;
527         }
528 
529         delete cardSets[_setId].cardIds;
530         cardSets[_setId].isRemoved = true;
531     }
532 
533     function harvest() public {
534         uint256 pendingHope = totalPendingHopeOfAddress(msg.sender, true);
535         userLastUpdate[msg.sender] = block.timestamp;
536 
537         if (pendingHope > 0) {
538             hope.mint(treasuryAddr, pendingHope.div(40)); // 2.5% HOPE for the treasury (Usable to purchase NFTs)
539             hope.mint(msg.sender, pendingHope);
540             hope.addClaimed(pendingHope);
541         }
542 
543         emit Harvest(msg.sender, pendingHope);
544     }
545 
546     function stake(uint256[] memory _cardIds) public {
547         require(_cardIds.length > 0, "_cardIds array empty");
548 
549         harvest();
550 
551         // Check no card will end up above max stake
552         uint256 length = _cardIds.length;
553         for (uint256 i = 0; i < length; ++i) {
554             uint256 cardId = _cardIds[i];
555             require(userCards[msg.sender][cardId] == false, "Card already staked");
556             require(cardToSetMap[cardId] != 0, "Card is not part of any set");
557         }
558 
559         // 1 of each card
560         uint256[] memory amounts = new uint256[](_cardIds.length);
561         for (uint256 i = 0; i < _cardIds.length; ++i) {
562             amounts[i] = 1;
563         }
564 
565         ropeMaker.safeBatchTransferFrom(msg.sender, address(this), _cardIds, amounts, "");
566 
567         for (uint256 i = 0; i < length; ++i) {
568             uint256 cardId = _cardIds[i];
569 
570             userCards[msg.sender][cardId] = true;
571         }
572 
573         emit Stake(msg.sender, _cardIds);
574     }
575 
576     function unstake(uint256[] memory _cardIds) public {
577         require(_cardIds.length > 0, "_cardIds array empty");
578 
579         harvest();
580 
581         uint256 length = _cardIds.length;
582         for (uint256 i = 0; i < length; ++i) {
583             uint256 cardId = _cardIds[i];
584 
585             require(userCards[msg.sender][cardId] == true, "Card not staked");
586             userCards[msg.sender][cardId] = false;
587         }
588 
589         // 1 of each card
590         uint256[] memory amounts = new uint256[](_cardIds.length);
591         for (uint256 i = 0; i < _cardIds.length; ++i) {
592             amounts[i] = 1;
593         }
594 
595         ropeMaker.safeBatchTransferFrom(address(this), msg.sender, _cardIds, amounts, "");
596 
597         emit Unstake(msg.sender, _cardIds);
598     }
599 
600     // Withdraw without rewards
601     function emergencyUnstake(uint256[] memory _cardIds) public {
602         userLastUpdate[msg.sender] = block.timestamp;
603 
604         uint256 length = _cardIds.length;
605         for (uint256 i = 0; i < length; ++i) {
606             uint256 cardId = _cardIds[i];
607 
608             require(userCards[msg.sender][cardId] == true, "Card not staked");
609             userCards[msg.sender][cardId] = false;
610         }
611 
612         // 1 of each card
613         uint256[] memory amounts = new uint256[](_cardIds.length);
614         for (uint256 i = 0; i < _cardIds.length; ++i) {
615             amounts[i] = 1;
616         }
617 
618         ropeMaker.safeBatchTransferFrom(address(this), msg.sender, _cardIds, amounts, "");
619     }
620 
621     // Update treasury address by the previous treasury.
622     function treasury(address _treasuryAddr) public {
623         require(msg.sender == treasuryAddr, "Must be called from current treasury address");
624         treasuryAddr = _treasuryAddr;
625     }
626 
627     /////////
628     /////////
629     /////////
630 
631     /**
632      * @notice Handle the receipt of a single ERC1155 token type
633      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
634      * This function MAY throw to revert and reject the transfer
635      * Return of other amount than the magic value MUST result in the transaction being reverted
636      * Note: The token contract address is always the message sender
637      * @param _operator  The address which called the `safeTransferFrom` function
638      * @param _from      The address which previously owned the token
639      * @param _id        The id of the token being transferred
640      * @param _amount    The amount of tokens being transferred
641      * @param _data      Additional data with no specified format
642      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
643      */
644     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4) {
645         return 0xf23a6e61;
646     }
647 
648     /**
649      * @notice Handle the receipt of multiple ERC1155 token types
650      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
651      * This function MAY throw to revert and reject the transfer
652      * Return of other amount than the magic value WILL result in the transaction being reverted
653      * Note: The token contract address is always the message sender
654      * @param _operator  The address which called the `safeBatchTransferFrom` function
655      * @param _from      The address which previously owned the token
656      * @param _ids       An array containing ids of each token being transferred
657      * @param _amounts   An array containing amounts of each token being transferred
658      * @param _data      Additional data with no specified format
659      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
660      */
661     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4) {
662         return 0xbc197c81;
663     }
664 
665     /**
666      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
667      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
668      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
669      *      This function MUST NOT consume more than 5,000 gas.
670      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
671      */
672     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
673         return  interfaceID == 0x01ffc9a7 ||    // ERC-165 support (i.e. `bytes4(keccak256('supportsInterface(bytes4)'))`).
674         interfaceID == 0x4e2312e0;      // ERC-1155 `ERC1155TokenReceiver` support (i.e. `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) ^ bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`).
675     }
676 }