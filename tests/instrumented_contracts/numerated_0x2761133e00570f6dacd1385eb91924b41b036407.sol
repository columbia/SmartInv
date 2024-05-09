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
269     function totalSupply(uint256 _id) external view returns (uint256);
270     function maxSupply(uint256 _id) external view returns (uint256);
271     function mint(address _to, uint256 _id, uint256 _quantity, bytes memory _data) external;
272 }
273 
274 interface Hope {
275     function totalSupply() external view returns (uint256);
276     function totalClaimed() external view returns (uint256);
277     function addClaimed(uint256 _amount) external;
278     function setClaimed(uint256 _amount) external;
279     function transfer(address receiver, uint numTokens) external returns (bool);
280     function transferFrom(address owner, address buyer, uint numTokens) external returns (bool);
281     function balanceOf(address owner) external view returns (uint256);
282     function mint(address _to, uint256 _amount) external;
283     function burn(address _account, uint256 value) external;
284 }
285 
286 contract CardRedeemer is Ownable {
287     using SafeMath for uint256;
288 
289     RMU public ropeMaker;
290     Hope public hope;
291 
292     struct Pack {
293         uint256[] cardIdList;
294         uint256 price;
295         uint256 redeemed;
296     }
297 
298     uint256[] public packIdList;
299     mapping (uint256 => Pack) public packs;
300 
301     event Redeemed(address indexed _user, uint256 indexed _packId, uint256 indexed _cardId);
302 
303     constructor(RMU _ropeMakerAddr, Hope _hopeAddr) public {
304         ropeMaker = _ropeMakerAddr;
305         hope = _hopeAddr;
306     }
307 
308     modifier onlyEOA() {
309         require(msg.sender == tx.origin, "Not eoa");
310         _;
311     }
312 
313     /////
314     /////
315     /////
316 
317     // Returns the list of cardIds which are part of a pack
318     function getCardIdListOfPack(uint256 _packId) external view returns(uint256[] memory) {
319         return packs[_packId].cardIdList;
320     }
321 
322     // Returns amount of packs left
323     function getPacksLeft(uint256 _packId) public view returns(uint256) {
324         uint256[] memory _cardIdList = packs[_packId].cardIdList;
325 
326         uint256 total = 0;
327         for (uint256 i = 0; i < _cardIdList.length; ++i) {
328             uint256 _cardId = _cardIdList[i];
329             uint256 cardsLeft = ropeMaker.maxSupply(_cardId).sub(ropeMaker.totalSupply(_cardId));
330 
331             total = total.add(cardsLeft);
332         }
333 
334         return total;
335     }
336 
337     // Returns probability to get each card (Value must be divided by 1e5)
338     function getPackProbabilities(uint256 _packId) public view returns(uint256[] memory) {
339         uint256 packsLeft = getPacksLeft(_packId);
340         uint256[] memory _cardIdList = packs[_packId].cardIdList;
341 
342         uint256[] memory proba = new uint256[](_cardIdList.length);
343         for (uint256 i = 0; i < _cardIdList.length; ++i) {
344             uint256 _cardId = _cardIdList[i];
345             uint256 cardsLeft = ropeMaker.maxSupply(_cardId).sub(ropeMaker.totalSupply(_cardId));
346 
347             proba[i] = cardsLeft.mul(1e5).div(packsLeft);
348         }
349 
350         return proba;
351     }
352 
353     function getTotalRedeemed() public view returns(uint256) {
354         uint256 totalRedeemed = 0;
355 
356         for (uint256 i = 0; i < packIdList.length; ++i) {
357             totalRedeemed = totalRedeemed.add(packs[packIdList[i]].redeemed);
358         }
359 
360         return totalRedeemed;
361     }
362 
363     function getCardsLeft(uint256 _packId) external view returns(uint256[] memory) {
364         uint256[] memory _cardIdList = packs[_packId].cardIdList;
365         uint256[] memory result = new uint256[](_cardIdList.length);
366 
367         for (uint256 i = 0; i < _cardIdList.length; ++i) {
368             uint256 _cardId = _cardIdList[i];
369             uint256 cardsLeft = ropeMaker.maxSupply(_cardId).sub(ropeMaker.totalSupply(_cardId));
370             result[i] = cardsLeft;
371         }
372 
373         return result;
374     }
375 
376     /////
377     /////
378     /////
379 
380     function addPack(uint256 _packId, uint256[] memory _cardIdList, uint256 _price) public onlyOwner {
381         require(_cardIdList.length > 0, "CardIdList cannot be empty");
382         require(_price > 0, "Price cannot be 0");
383 
384         if (_isInArray(_packId, packIdList) == false) {
385             packIdList.push(_packId);
386         }
387 
388         packs[_packId] = Pack(_cardIdList, _price, 0);
389     }
390 
391     function removePack(uint256 _packId) public onlyOwner {
392         delete packs[_packId].cardIdList;
393         packs[_packId].price = 0;
394     }
395 
396     //
397 
398     // Redeem a random card from a pack (Not callable by contract, to prevent exploits on RNG)
399     function redeem(uint256 _packId) public onlyEOA {
400         Pack storage pack = packs[_packId];
401         require(pack.price > 0, "Pack does not exist");
402         require(hope.balanceOf(msg.sender) >= pack.price, "Not enough hope for pack");
403 
404         uint256 packsLeft = getPacksLeft(_packId);
405         require(packsLeft > 0, "Pack sold out");
406 
407         hope.burn(msg.sender, pack.price);
408         pack.redeemed = pack.redeemed.add(1);
409 
410         uint256 rng = _rng(getTotalRedeemed()) % packsLeft;
411 
412 
413         uint256[] memory _cardIdList = pack.cardIdList;
414 
415         uint256 cardIdWon = 0;
416         uint256 cumul = 0;
417         for (uint256 i = 0; i < _cardIdList.length; ++i) {
418             uint256 cardId = _cardIdList[i];
419             uint256 cardsLeft = ropeMaker.maxSupply(cardId).sub(ropeMaker.totalSupply(cardId));
420 
421             cumul = cumul.add(cardsLeft);
422             if (rng < cumul) {
423                 cardIdWon = cardId;
424                 break;
425             }
426         }
427 
428         require(cardIdWon != 0, "Error during card redeeming RNG");
429 
430         ropeMaker.mint(msg.sender, cardIdWon, 1, "");
431         emit Redeemed(msg.sender, _packId, cardIdWon);
432     }
433 
434     //////////////
435     // Internal //
436     //////////////
437 
438     // Utility function to check if a value is inside an array
439     function _isInArray(uint256 _value, uint256[] memory _array) internal pure returns(bool) {
440         uint256 length = _array.length;
441         for (uint256 i = 0; i < length; ++i) {
442             if (_array[i] == _value) {
443                 return true;
444             }
445         }
446 
447         return false;
448     }
449 
450     // This is a pseudo random function, but considering the fact that redeem function is not callable by contract,
451     // and the fact that Hope is not transferable, this should be enough to protect us from an attack
452     // I would only expect a miner to be able to exploit this, and the attack cost would not be worth it in our case
453     function _rng(uint256 _seed) internal view returns(uint256) {
454         return uint256(keccak256(abi.encodePacked((block.timestamp).add(_seed).add
455         (block.difficulty).add
456         ((uint256(keccak256(abi.encodePacked(block.coinbase)))) /
457             block.timestamp).add
458         (block.gaslimit).add
459         ((uint256(keccak256(abi.encodePacked(msg.sender)))) /
460             block.timestamp).add
461             (block.number)
462             )));
463     }
464 }