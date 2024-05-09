1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-15
3 */
4 
5 /*                
6           RRRR   OOO  L     L         EEEEE  RRRR   CCCCC  
7           R   R O   O L     L         E      R   R C     
8           RRRR  O   O L     L         EEEE   RRRR  C     
9           R  R  O   O L     L         E      R  R  C     
10           R   R  OOO  LLLLL LLLLL     EEEEE  R   R  CCCCC 
11 
12                 +-------+            +-------+              
13                / o   o /|           /     o /|              
14               / o   o / |          / o     / |                
15              +-------+  +         +-------+  +                 
16              |     o |  /         | o   o |  /                 
17              |   o   | /          |       | /                  
18              | o     |/           | o   o |/                   
19              +-------+            +-------+
20 */
21 
22 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
23 
24 
25 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 // CAUTION
30 // This version of SafeMath should only be used with Solidity 0.8 or later,
31 // because it relies on the compiler's built in overflow checks.
32 
33 /**
34  * @dev Wrappers over Solidity's arithmetic operations.
35  *
36  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
37  * now has built in overflow checking.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             uint256 c = a + b;
48             if (c < a) return (false, 0);
49             return (true, c);
50         }
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b > a) return (false, 0);
61             return (true, a - b);
62         }
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73             // benefit is lost if 'b' is also tested.
74             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75             if (a == 0) return (true, 0);
76             uint256 c = a * b;
77             if (c / a != b) return (false, 0);
78             return (true, c);
79         }
80     }
81 
82     /**
83      * @dev Returns the division of two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a / b);
91         }
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
96      *
97      * _Available since v3.4._
98      */
99     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         unchecked {
101             if (b == 0) return (false, 0);
102             return (true, a % b);
103         }
104     }
105 
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a + b;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a - b;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      *
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a * b;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers, reverting on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator.
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a / b;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * reverting when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a % b;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180      * overflow (when the result is negative).
181      *
182      * CAUTION: This function is deprecated because it requires allocating memory for the error
183      * message unnecessarily. For custom revert reasons use {trySub}.
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b <= a, errorMessage);
198             return a - b;
199         }
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a / b;
222         }
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting with custom message when dividing by zero.
228      *
229      * CAUTION: This function is deprecated because it requires allocating memory for the error
230      * message unnecessarily. For custom revert reasons use {tryMod}.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b > 0, errorMessage);
247             return a % b;
248         }
249     }
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
253 
254 
255 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Interface of the ERC20 standard as defined in the EIP.
261  */
262 interface IERC20 {
263     /**
264      * @dev Emitted when `value` tokens are moved from one account (`from`) to
265      * another (`to`).
266      *
267      * Note that `value` may be zero.
268      */
269     event Transfer(address indexed from, address indexed to, uint256 value);
270 
271     /**
272      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
273      * a call to {approve}. `value` is the new allowance.
274      */
275     event Approval(address indexed owner, address indexed spender, uint256 value);
276 
277     /**
278      * @dev Returns the amount of tokens in existence.
279      */
280     function totalSupply() external view returns (uint256);
281 
282     /**
283      * @dev Returns the amount of tokens owned by `account`.
284      */
285     function balanceOf(address account) external view returns (uint256);
286 
287     /**
288      * @dev Moves `amount` tokens from the caller's account to `to`.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transfer(address to, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Returns the remaining number of tokens that `spender` will be
298      * allowed to spend on behalf of `owner` through {transferFrom}. This is
299      * zero by default.
300      *
301      * This value changes when {approve} or {transferFrom} are called.
302      */
303     function allowance(address owner, address spender) external view returns (uint256);
304 
305     /**
306      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * IMPORTANT: Beware that changing an allowance with this method brings the risk
311      * that someone may use both the old and the new allowance by unfortunate
312      * transaction ordering. One possible solution to mitigate this race
313      * condition is to first reduce the spender's allowance to 0 and set the
314      * desired value afterwards:
315      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address spender, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Moves `amount` tokens from `from` to `to` using the
323      * allowance mechanism. `amount` is then deducted from the caller's
324      * allowance.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transferFrom(address from, address to, uint256 amount) external returns (bool);
331 }
332 
333 // File: @openzeppelin/contracts/utils/Context.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Provides information about the current execution context, including the
342  * sender of the transaction and its data. While these are generally available
343  * via msg.sender and msg.data, they should not be accessed in such a direct
344  * manner, since when dealing with meta-transactions the account sending and
345  * paying for execution may not be the actual sender (as far as an application
346  * is concerned).
347  *
348  * This contract is only required for intermediate, library-like contracts.
349  */
350 abstract contract Context {
351     function _msgSender() internal view virtual returns (address) {
352         return msg.sender;
353     }
354 
355     function _msgData() internal view virtual returns (bytes calldata) {
356         return msg.data;
357     }
358 }
359 
360 // File: @openzeppelin/contracts/access/Ownable.sol
361 
362 
363 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Contract module which provides a basic access control mechanism, where
370  * there is an account (an owner) that can be granted exclusive access to
371  * specific functions.
372  *
373  * By default, the owner account will be the one that deploys the contract. This
374  * can later be changed with {transferOwnership}.
375  *
376  * This module is used through inheritance. It will make available the modifier
377  * `onlyOwner`, which can be applied to your functions to restrict their use to
378  * the owner.
379  */
380 abstract contract Ownable is Context {
381     address private _owner;
382 
383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385     /**
386      * @dev Initializes the contract setting the deployer as the initial owner.
387      */
388     constructor() {
389         _transferOwnership(_msgSender());
390     }
391 
392     /**
393      * @dev Throws if called by any account other than the owner.
394      */
395     modifier onlyOwner() {
396         _checkOwner();
397         _;
398     }
399 
400     /**
401      * @dev Returns the address of the current owner.
402      */
403     function owner() public view virtual returns (address) {
404         return _owner;
405     }
406 
407     /**
408      * @dev Throws if the sender is not the owner.
409      */
410     function _checkOwner() internal view virtual {
411         require(owner() == _msgSender(), "Ownable: caller is not the owner");
412     }
413 
414     /**
415      * @dev Leaves the contract without owner. It will not be possible to call
416      * `onlyOwner` functions anymore. Can only be called by the current owner.
417      *
418      * NOTE: Renouncing ownership will leave the contract without an owner,
419      * thereby removing any functionality that is only available to the owner.
420      */
421     function renounceOwnership() public virtual onlyOwner {
422         _transferOwnership(address(0));
423     }
424 
425     /**
426      * @dev Transfers ownership of the contract to a new account (`newOwner`).
427      * Can only be called by the current owner.
428      */
429     function transferOwnership(address newOwner) public virtual onlyOwner {
430         require(newOwner != address(0), "Ownable: new owner is the zero address");
431         _transferOwnership(newOwner);
432     }
433 
434     /**
435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
436      * Internal function without access restriction.
437      */
438     function _transferOwnership(address newOwner) internal virtual {
439         address oldOwner = _owner;
440         _owner = newOwner;
441         emit OwnershipTransferred(oldOwner, newOwner);
442     }
443 }
444 
445 // File: contracts/RollERC20/roll.sol
446 
447 //SPDX-License-Identifier: MIT
448 pragma solidity ^0.8.0;
449 
450 
451 
452 
453 contract RollERCGame is Ownable {
454     using SafeMath for uint256;
455 
456     IERC20 public gameToken;
457 
458     enum GameStatus { NOT_STARTED, IN_PROGRESS, ENDED }
459 
460     struct Game {
461         address[] wallets; // user_id -> wallet mapping
462         uint256 betAmount;
463         GameStatus status;
464         uint256 playerCount;
465     }
466 
467     mapping(int64 => Game) public games; // group_id -> Game mapping
468 
469     address public feeWallet; // Wallet for fees
470     address public burnAddress = 0x000000000000000000000000000000000000dEaD; // Common burn address
471     uint256 public feeBasepoints = 800; // 800 basepoints => 8%
472 
473     uint256 maxPlayers;
474 
475     event GameStarted(int64 groupId, uint256 betAmount);
476     event GameEnded(int64 groupId, address winner);
477     event FeeTaken(uint256 amount);
478     event TokensBurned(uint256 amount);
479 
480     constructor(IERC20 _gameToken, address _feeWallet) {
481         gameToken = _gameToken;
482         feeWallet = _feeWallet;
483         maxPlayers = 4;
484     }
485 
486     function setMaxPlayers(uint256 _maxPlayers) external onlyOwner {
487         maxPlayers = _maxPlayers;
488     }
489 
490 
491     function setGameToken(IERC20 _gameToken) external onlyOwner {
492         gameToken = _gameToken;
493     }
494 
495     function setFeeWallet(address _feeWallet) external onlyOwner {
496         feeWallet = _feeWallet;
497     }
498 
499     function setFeeBasepoints(uint256 _feeBasepoints) external onlyOwner {
500         require(_feeBasepoints <= 10000, "Cannot set fee over 100%");
501         feeBasepoints = _feeBasepoints;
502     }
503 
504     function startGame(int64 groupId, address[] memory _wallets, uint256 betAmount, uint256 _playerCount) external onlyOwner {
505 
506         require(_wallets.length == _playerCount, "Mismatch in wallets length and player count.");
507         require(_playerCount < maxPlayers, "You are trying to start a game with more players than currently permitted.");
508 
509         Game storage game = games[groupId];
510         game.betAmount = betAmount;
511         game.status = GameStatus.IN_PROGRESS;
512         game.wallets = _wallets;
513         game.playerCount = _playerCount;
514        
515 
516 
517         for (uint i = 0; i < _wallets.length; i++) {
518             // Transfer betAmount from each player's wallet to this contract
519             gameToken.transferFrom(_wallets[i], address(this), betAmount);
520         }
521 
522 
523     emit GameStarted(groupId, betAmount);
524 }
525 
526 
527     function endGame(int64 groupId, address winner) external onlyOwner {
528         Game storage game = games[groupId];
529         require(game.status == GameStatus.IN_PROGRESS, "Game not in progress");
530 
531         // Calculate total pool
532         uint256 playerCount = games[groupId].playerCount;
533 
534         uint256 totalPool = playerCount.mul(game.betAmount);
535 
536         uint256 feeAmount = totalPool.mul(feeBasepoints).div(10000); // Convert basepoints to fee
537         uint256 burnAmount = totalPool.mul(200).div(10000); // 2% for burn => 200 basepoints
538 
539         gameToken.transfer(feeWallet, feeAmount);
540         gameToken.transfer(burnAddress, burnAmount);
541         gameToken.transfer(winner, totalPool.sub(feeAmount).sub(burnAmount));
542 
543         delete games[groupId]; // Delete the game from mapping
544 
545         emit FeeTaken(feeAmount);
546         emit TokensBurned(burnAmount);
547         emit GameEnded(groupId, winner);
548     }
549 
550     function getGameStatus(int64 groupId) external view returns(GameStatus) {
551         return games[groupId].status;
552     }
553 
554     function getBetAmount(int64 groupId) external view returns(uint256) {
555         return games[groupId].betAmount;
556     }
557 }