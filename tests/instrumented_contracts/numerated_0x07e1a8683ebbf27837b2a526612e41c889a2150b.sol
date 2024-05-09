1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 pragma experimental ABIEncoderV2;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(isOwner(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Returns true if the caller is the current owner.
72      */
73     function isOwner() public view returns (bool) {
74         return _msgSender() == _owner;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      */
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 interface RMU {
265     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
266     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
267     function setApprovalForAll(address _operator, bool _approved) external;
268     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
269     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
270     function totalSupply(uint256 _id) external view returns (uint256);
271     function maxSupply(uint256 _id) external view returns (uint256);
272     function mint(address _to, uint256 _id, uint256 _quantity, bytes memory _data) external;
273 }
274 
275 interface Hope {
276     function totalSupply() external view returns (uint256);
277     function totalClaimed() external view returns (uint256);
278     function addClaimed(uint256 _amount) external;
279     function setClaimed(uint256 _amount) external;
280     function transfer(address receiver, uint numTokens) external returns (bool);
281     function transferFrom(address owner, address buyer, uint numTokens) external returns (bool);
282     function balanceOf(address owner) external view returns (uint256);
283     function mint(address _to, uint256 _amount) external;
284     function burn(address _account, uint256 value) external;
285 }
286 
287 contract CardRedeemerV2 is Ownable {
288     using SafeMath for uint256;
289 
290     RMU public ropeMaker;
291     Hope public hope;
292 
293     struct Pack {
294         uint256[] cardIdList;
295         uint256 price;
296         uint256 redeemed;
297     }
298 
299     struct Card {
300         uint256 maxSupply;
301         uint256 supply;
302     }
303 
304     struct PackCardData {
305         uint256 cardId;
306         uint256 cardsLeft;
307     }
308 
309     uint256[] public packIdList;
310     mapping (uint256 => Pack) public packs;
311     mapping (uint256 => Card) public cards;
312 
313     event Redeemed(address indexed _user, uint256 indexed _packId, uint256 indexed _cardId);
314 
315     constructor(RMU _ropeMakerAddr, Hope _hopeAddr) public {
316         ropeMaker = _ropeMakerAddr;
317         hope = _hopeAddr;
318     }
319 
320     modifier onlyEOA() {
321         require(msg.sender == tx.origin, "Not eoa");
322         _;
323     }
324 
325     /////
326     /////
327     /////
328 
329     // Returns the list of cardIds which are part of a pack
330     function getCardIdListOfPack(uint256 _packId) external view returns(uint256[] memory) {
331         return packs[_packId].cardIdList;
332     }
333 
334     function _getPackCardData(uint256 _packId) internal view returns(PackCardData[] memory) {
335         uint256[] memory _cardIdList = packs[_packId].cardIdList;
336         PackCardData[] memory result = new PackCardData[](_cardIdList.length);
337 
338         for (uint256 i = 0; i < _cardIdList.length; ++i) {
339             uint256 _cardId = _cardIdList[i];
340             uint256 maxSupply = cards[_cardId].maxSupply;
341             uint256 supply = cards[_cardId].supply;
342             uint256 cardsLeft = maxSupply.sub(supply);
343             result[i] = PackCardData(_cardId, cardsLeft);
344         }
345 
346         return result;
347     }
348 
349     // Returns amount of packs left
350     function _getPacksLeft(PackCardData[] memory _data) internal pure returns(uint256) {
351         uint256 total = 0;
352         for (uint256 i = 0; i < _data.length; ++i) {
353             total = total.add(_data[i].cardsLeft);
354         }
355 
356         return total;
357     }
358 
359     /////////
360     /////////
361     /////////
362 
363     // Returns amount of packs left
364     function getPacksLeft(uint256 _packId) public view returns(uint256) {
365         uint256[] memory _cardIdList = packs[_packId].cardIdList;
366 
367         uint256 total = 0;
368         for (uint256 i = 0; i < _cardIdList.length; ++i) {
369             uint256 _cardId = _cardIdList[i];
370             uint256 cardsLeft = ropeMaker.maxSupply(_cardId).sub(ropeMaker.totalSupply(_cardId));
371 
372             total = total.add(cardsLeft);
373         }
374 
375         return total;
376     }
377 
378     // Returns probability to get each card (Value must be divided by 1e5)
379     function getPackProbabilities(uint256 _packId) public view returns(uint256[] memory) {
380         uint256 packsLeft = getPacksLeft(_packId);
381         uint256[] memory _cardIdList = packs[_packId].cardIdList;
382 
383         uint256[] memory proba = new uint256[](_cardIdList.length);
384         for (uint256 i = 0; i < _cardIdList.length; ++i) {
385             uint256 _cardId = _cardIdList[i];
386             uint256 cardsLeft = ropeMaker.maxSupply(_cardId).sub(ropeMaker.totalSupply(_cardId));
387 
388             proba[i] = cardsLeft.mul(1e5).div(packsLeft);
389         }
390 
391         return proba;
392     }
393 
394     function getTotalRedeemed() public view returns(uint256) {
395         uint256 totalRedeemed = 0;
396 
397         for (uint256 i = 0; i < packIdList.length; ++i) {
398             totalRedeemed = totalRedeemed.add(packs[packIdList[i]].redeemed);
399         }
400 
401         return totalRedeemed;
402     }
403 
404     function getCardsLeft(uint256 _packId) external view returns(uint256[] memory) {
405         uint256[] memory _cardIdList = packs[_packId].cardIdList;
406         uint256[] memory result = new uint256[](_cardIdList.length);
407 
408         for (uint256 i = 0; i < _cardIdList.length; ++i) {
409             uint256 _cardId = _cardIdList[i];
410             uint256 cardsLeft = ropeMaker.maxSupply(_cardId).sub(ropeMaker.totalSupply(_cardId));
411             result[i] = cardsLeft;
412         }
413 
414         return result;
415     }
416 
417     /////
418     /////
419     /////
420 
421     function addPack(uint256 _packId, uint256[] memory _cardIdList, uint256 _price) public onlyOwner {
422         require(_cardIdList.length > 0, "CardIdList cannot be empty");
423         require(_price > 0, "Price cannot be 0");
424 
425         updateCardsData(_cardIdList);
426 
427         if (_isInArray(_packId, packIdList) == false) {
428             packIdList.push(_packId);
429         }
430 
431         packs[_packId] = Pack(_cardIdList, _price, 0);
432     }
433 
434     // We need to call this function, if we ever mint manually some cards included in a pack
435     function updateCardsData(uint256[] memory _cardIdList) public onlyOwner {
436         for (uint256 i = 0; i < _cardIdList.length; ++i) {
437             uint256 _cardId = _cardIdList[i];
438             cards[_cardId] = Card(ropeMaker.maxSupply(_cardId), ropeMaker.totalSupply(_cardId));
439         }
440     }
441 
442     function removePack(uint256 _packId) public onlyOwner {
443         delete packs[_packId].cardIdList;
444         packs[_packId].price = 0;
445     }
446 
447     //
448 
449     // Redeem a random card from a pack (Not callable by contract, to prevent exploits on RNG)
450     function redeem(uint256 _packId) public onlyEOA {
451         Pack storage pack = packs[_packId];
452         require(pack.price > 0, "Pack does not exist");
453         require(hope.balanceOf(msg.sender) >= pack.price, "Not enough hope for pack");
454 
455         PackCardData[] memory data = _getPackCardData(_packId);
456 
457         uint256 packsLeft = _getPacksLeft(data);
458         require(packsLeft > 0, "Pack sold out");
459 
460         hope.burn(msg.sender, pack.price);
461         pack.redeemed = pack.redeemed.add(1);
462 
463         uint256 rng = _rng(getTotalRedeemed()) % packsLeft;
464 
465 
466         uint256 cardIdWon = 0;
467         uint256 cumul = 0;
468         for (uint256 i = 0; i < data.length; ++i) {
469             uint256 cardId = data[i].cardId;
470 
471             cumul = cumul.add(data[i].cardsLeft);
472             if (rng < cumul) {
473                 cardIdWon = cardId;
474                 cards[cardId].supply = cards[cardId].supply.add(1);
475                 break;
476             }
477         }
478 
479         require(cardIdWon != 0, "Error during card redeeming RNG");
480 
481         ropeMaker.mint(msg.sender, cardIdWon, 1, "");
482         emit Redeemed(msg.sender, _packId, cardIdWon);
483     }
484 
485     //////////////
486     // Internal //
487     //////////////
488 
489     // Utility function to check if a value is inside an array
490     function _isInArray(uint256 _value, uint256[] memory _array) internal pure returns(bool) {
491         uint256 length = _array.length;
492         for (uint256 i = 0; i < length; ++i) {
493             if (_array[i] == _value) {
494                 return true;
495             }
496         }
497 
498         return false;
499     }
500 
501     // This is a pseudo random function, but considering the fact that redeem function is not callable by contract,
502     // and the fact that Hope is not transferable, this should be enough to protect us from an attack
503     // I would only expect a miner to be able to exploit this, and the attack cost would not be worth it in our case
504     function _rng(uint256 _seed) internal view returns(uint256) {
505         return uint256(keccak256(abi.encodePacked((block.timestamp).add(_seed).add
506         (block.difficulty).add
507         ((uint256(keccak256(abi.encodePacked(block.coinbase)))) /
508             block.timestamp).add
509         (block.gaslimit).add
510         ((uint256(keccak256(abi.encodePacked(msg.sender)))) /
511             block.timestamp).add
512             (block.number)
513             )));
514     }
515 }