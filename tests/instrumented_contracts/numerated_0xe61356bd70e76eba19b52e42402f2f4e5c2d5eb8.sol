1 pragma solidity ^0.5.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     int256 constant private INT256_MIN = -2**255;
9 
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Multiplies two signed integers, reverts on overflow.
29     */
30     function mul(int256 a, int256 b) internal pure returns (int256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
39 
40         int256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
60     */
61     function div(int256 a, int256 b) internal pure returns (int256) {
62         require(b != 0); // Solidity only automatically asserts when dividing by 0
63         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
64 
65         int256 c = a / b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81     * @dev Subtracts two signed integers, reverts on overflow.
82     */
83     function sub(int256 a, int256 b) internal pure returns (int256) {
84         int256 c = a - b;
85         require((b >= 0 && c <= a) || (b < 0 && c > a));
86 
87         return c;
88     }
89 
90     /**
91     * @dev Adds two unsigned integers, reverts on overflow.
92     */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a);
96 
97         return c;
98     }
99 
100     /**
101     * @dev Adds two signed integers, reverts on overflow.
102     */
103     function add(int256 a, int256 b) internal pure returns (int256) {
104         int256 c = a + b;
105         require((b >= 0 && c >= a) || (b < 0 && c < a));
106 
107         return c;
108     }
109 
110     /**
111     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
112     * reverts when dividing by zero.
113     */
114     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b != 0);
116         return a % b;
117     }
118 }
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
122  * the optional functions; to access them see `ERC20Detailed`.
123  */
124 interface IERC20 {
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a `Transfer` event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through `transferFrom`. This is
147      * zero by default.
148      *
149      * This value changes when `approve` or `transferFrom` are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * > Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an `Approval` event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `sender` to `recipient` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a `Transfer` event.
177      */
178     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to `approve`. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be aplied to your functions to restrict their use to
203  * the owner.
204  */
205 contract Ownable {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor () internal {
214         _owner = msg.sender;
215         emit OwnershipTransferred(address(0), _owner);
216     }
217 
218     /**
219      * @dev Returns the address of the current owner.
220      */
221     function owner() public view returns (address) {
222         return _owner;
223     }
224 
225     /**
226      * @dev Throws if called by any account other than the owner.
227      */
228     modifier onlyOwner() {
229         require(isOwner(), "Ownable: caller is not the owner");
230         _;
231     }
232 
233     /**
234      * @dev Returns true if the caller is the current owner.
235      */
236     function isOwner() public view returns (bool) {
237         return msg.sender == _owner;
238     }
239 
240     /**
241      * @dev Leaves the contract without owner. It will not be possible to call
242      * `onlyOwner` functions anymore. Can only be called by the current owner.
243      *
244      * > Note: Renouncing ownership will leave the contract without an owner,
245      * thereby removing any functionality that is only available to the owner.
246      */
247     function renounceOwnership() public onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Can only be called by the current owner.
255      */
256     function transferOwnership(address newOwner) public onlyOwner {
257         _transferOwnership(newOwner);
258     }
259 
260     /**
261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
262      */
263     function _transferOwnership(address newOwner) internal {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         emit OwnershipTransferred(_owner, newOwner);
266         _owner = newOwner;
267     }
268 }
269 
270 /**
271  * @title Contracts that should be able to recover tokens
272  * @author SylTi
273  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
274  * This will prevent any accidental loss of tokens.
275  */
276 contract CanReclaimToken is Ownable {
277 
278     /**
279      * @dev Reclaim all ERC20 compatible tokens
280      * @param token ERC20 The address of the token contract
281      */
282     function reclaimToken(IERC20 token) external onlyOwner {
283         address payable owner = address(uint160(owner()));
284 
285         if (address(token) == address(0)) {
286             owner.transfer(address(this).balance);
287             return;
288         }
289         uint256 balance = token.balanceOf(address(this));
290         token.transfer(owner, balance);
291     }
292 
293 }
294 
295 /**
296  * @title Roles
297  * @dev Library for managing addresses assigned to a Role.
298  */
299 library Roles {
300     struct Role {
301         mapping (address => bool) bearer;
302     }
303 
304     /**
305      * @dev give an account access to this role
306      */
307     function add(Role storage role, address account) internal {
308         require(account != address(0));
309         require(!has(role, account));
310 
311         role.bearer[account] = true;
312     }
313 
314     /**
315      * @dev remove an account's access to this role
316      */
317     function remove(Role storage role, address account) internal {
318         require(account != address(0));
319         require(has(role, account));
320 
321         role.bearer[account] = false;
322     }
323 
324     /**
325      * @dev check if an account has this role
326      * @return bool
327      */
328     function has(Role storage role, address account) internal view returns (bool) {
329         require(account != address(0));
330         return role.bearer[account];
331     }
332 }
333 
334 
335 contract AdminRole is Ownable {
336     using Roles for Roles.Role;
337 
338     event AdminAdded(address indexed account);
339     event AdminRemoved(address indexed account);
340 
341     Roles.Role private _admins;
342 
343     constructor () internal {
344         _addAdmin(msg.sender);
345     }
346 
347     modifier onlyAdmin() {
348         require(isAdmin(msg.sender));
349         _;
350     }
351 
352     function isAdmin(address account) public view returns (bool) {
353         return _admins.has(account);
354     }
355 
356     function addAdmin(address account) public onlyOwner {
357         _addAdmin(account);
358     }
359 
360     function renounceAdmin() public {
361         _removeAdmin(msg.sender);
362     }
363 
364     function removeAdmin(address account) public onlyOwner {
365         _removeAdmin(account);
366     }
367 
368     function _addAdmin(address account) internal {
369         _admins.add(account);
370         emit AdminAdded(account);
371     }
372 
373     function _removeAdmin(address account) internal {
374         _admins.remove(account);
375         emit AdminRemoved(account);
376     }
377 }
378 
379 
380 //TODO referral
381 contract SNKGame is AdminRole, CanReclaimToken {
382     using SafeMath for uint;
383 
384     address payable public dividendManagerAddress;
385 
386     struct Node {
387         mapping (bool => uint) children;
388         uint parent;
389         bool side;
390         uint height;
391         uint count;
392         uint dupes;
393     }
394 
395     struct Game {
396         mapping(uint => Node) bets;
397         uint res;
398         uint resPos;
399         uint amount;
400 
401         mapping(uint => address[]) users; //betValue => users
402         mapping(uint => mapping(address => uint)) betUsers; // betValue => user => userBetAmount
403         mapping(address => uint[]) userBets; //user => userBetValue
404         mapping(address => bool) executed; //user => prizeExecuted
405 
406         uint winnersAmount;
407         uint prizePool;
408         //        uint winnersCount;
409         uint lastLeftPos;
410         uint lastRightPos;
411         uint lastLeftValue;
412         uint lastRightValue;
413         bool allDone;
414     }
415 
416     mapping (uint => Game) public games;
417 
418     uint public gameStep;
419     uint public closeBetsTime;
420     uint public gamesStart;
421     uint public betValue;
422 
423 
424 
425     event NewBet(address indexed user, uint indexed game, uint bet, uint value);
426     event ResultSet(uint indexed game, uint res, uint lastLeftValue, uint lastRightValue, uint amount);
427     event PrizeTaken(address indexed user, uint game, uint amount);
428 
429     constructor(address payable _dividendManagerAddress, uint _betValue) public {
430         require(_dividendManagerAddress != address(0));
431         dividendManagerAddress = _dividendManagerAddress;
432 
433         gameStep = 10 minutes;
434         closeBetsTime = 3 minutes;
435         gamesStart = 1568332800; //Friday, 13 September 2019 г., 0:00:00
436         betValue = _betValue;
437     }
438 
439 
440     function() external payable {
441         revert();
442     }
443 
444 
445     function makeBet(uint _game, uint _bet) public payable {
446         require(_bet > 0);
447         require(betValue == 0 ? msg.value > 0 : msg.value == betValue);
448         if (_game == 0) {
449             _game = getCurrentGameId();
450         }
451         require(now < getGameTime(_game) - closeBetsTime);
452 
453         _makeBet(games[_game], _bet);
454 
455         emit NewBet(msg.sender, _game, _bet, msg.value);
456     }
457 
458     function setRes(uint _game, uint _res) onlyAdmin public {
459         insertResult(_game, _res);
460         setLastLeftRight(_game);
461         shiftLeftRight(_game);
462         setWinnersAmount(_game, 0, 0);
463     }
464 
465     function insertResult(uint _game, uint _res) onlyAdmin public {
466         //require(getGameTime(_game) < now);
467         _insertResult(games[_game], _res);
468     }
469 
470     function setLastLeftRight(uint _game) onlyAdmin public {
471         _setLastLeftRight(games[_game]);
472     }
473 
474     function shiftLeftRight(uint _game) onlyAdmin public {
475         _shiftLeftRight(games[_game]);
476     }
477 
478 
479     function setWinnersAmount(uint _game, uint _start, uint _stop) onlyAdmin public {
480         _setWinnersAmount(games[_game], _start, _stop);
481         if (games[_game].allDone) {
482             emit ResultSet(_game, games[_game].res, games[_game].lastLeftValue, games[_game].lastRightValue, games[_game].amount);
483         }
484     }
485 
486     function isPrizeTaken(uint _game, address _user) public view returns (bool){
487         return games[_game].executed[_user];
488     }
489     function isMyPrizeTaken(uint _game) public view returns (bool){
490         return isPrizeTaken(_game, msg.sender);
491     }
492 
493 
494     function checkPrize(uint _game, address _user) public view returns (uint) {
495         if (games[_game].executed[_user]) {
496             return 0;
497         }
498         return _getPrizeAmount(games[_game], _user);
499     }
500 
501     function checkMyPrize(uint _game) public view returns (uint) {
502         return checkPrize(_game, msg.sender);
503     }
504 
505     function getPrize(uint _game, address payable _user) public {
506         uint amount = _getPrize(games[_game], _user);
507         emit PrizeTaken(_user, _game, amount);
508     }
509 
510     function getMyPrize(uint _game) public {
511         getPrize(_game, msg.sender);
512     }
513 
514     function getGameTime(uint _id) public view returns (uint) {
515         return gamesStart + (gameStep * _id);
516     }
517 
518     function setDividendManager(address payable _dividendManagerAddress) onlyOwner external  {
519         require(_dividendManagerAddress != address(0));
520         dividendManagerAddress = _dividendManagerAddress;
521     }
522     
523     function setBetValue(uint _betValue) onlyOwner external  {
524         betValue = _betValue;
525     }
526 
527     function getCurrentGameId() public view returns (uint) {
528         return (now - gamesStart) / gameStep + 1;
529     }
530 
531     function getNextGameId() external view returns (uint) {
532         return (now - gamesStart) / gameStep + 2;
533     }
534 
535     function getUserBetValues(uint _game, address _user) public view returns (uint[] memory values) {
536         // values = new uint[](games[_game].userBets[msg.sender].length);
537         // for (uint i = 0; i < games[_game].userBets[msg.sender].length; i++) {
538         //     values[i] = games[_game].userBets[msg.sender][i];
539         // }
540         return games[_game].userBets[_user];
541     }
542     function getUserBetValues(uint _game) external view returns (uint[] memory values) {
543         return getUserBetValues(_game, msg.sender);
544     }
545 
546     function getUserBetAmounts(uint _game, address _user) public view returns (uint[] memory amounts) {
547         amounts = new uint[](games[_game].userBets[_user].length);
548         for (uint i = 0; i < games[_game].userBets[_user].length; i++) {
549             amounts[i] = games[_game].betUsers[ games[_game].userBets[_user][i] ][_user];
550         }
551     }
552     function getUserBetAmounts(uint _game) external view returns (uint[] memory values) {
553         return getUserBetAmounts(_game, msg.sender);
554     }
555 
556 
557     //INTERNAL FUNCTIONS
558 
559     function _makeBet(Game storage game, uint _bet) internal {
560         if (game.betUsers[_bet][msg.sender] == 0) {
561             _insert(game, _bet);
562             game.users[_bet].push(msg.sender);
563             game.userBets[msg.sender].push(_bet);
564         }
565 
566         game.amount = game.amount.add(msg.value);
567         game.betUsers[_bet][msg.sender] = game.betUsers[_bet][msg.sender].add(msg.value);
568     }
569 
570 
571     function _insertResult(Game storage game, uint _res) internal {
572         _insert(game, _res);
573         game.res = _res;
574         game.resPos = _getPos(game, _res);
575     }
576 
577 
578     function _setLastLeftRight(Game storage game) internal returns (bool) {
579         require(game.res > 0);
580 
581         //JackPot
582         if (game.bets[game.res].dupes > 0) {
583             game.lastLeftPos = game.resPos;
584             game.lastRightPos = game.resPos;
585             game.lastLeftValue = game.res;
586             game.lastRightValue = game.res;
587             return true;
588         }
589 
590         uint lastPos = _count(game) - 1;
591 
592         if (lastPos < 19) { //1 winner
593             //если результат на первой или последней позиции то ставим победителя слева или справа
594             if (game.resPos == 0 || game.resPos == lastPos) {
595                 game.lastLeftPos = game.resPos == 0 ? 1 : lastPos - 1;
596                 game.lastRightPos = game.lastLeftPos;
597             } else {
598                 uint leftBet =  _select_at(game, game.resPos - 1);
599                 uint rightBet = _select_at(game, game.resPos + 1);
600                 uint leftBetDif = game.res - leftBet;
601                 uint rightBetDif = rightBet - game.res;
602 
603                 if (leftBetDif == rightBetDif) {
604                     game.lastLeftPos = game.resPos - 1;
605                     game.lastRightPos = game.resPos + 1;
606                 }
607 
608                 if (leftBetDif > rightBetDif) {
609                     game.lastLeftPos = game.resPos + 1;
610                     game.lastRightPos = game.resPos + 1;
611                 }
612 
613                 if (leftBetDif < rightBetDif) {
614                     //дубликатов в resPos нет, т.к. проверили выше в джекпоте
615                     game.lastLeftPos = game.resPos - 1;
616                     game.lastRightPos = game.resPos - 1;
617                 }
618             }
619         } else {
620             uint winnersCount = lastPos.add(1).mul(10).div(100);
621             uint halfWinners = winnersCount.div(2);
622 
623             if (game.resPos < halfWinners) {
624                 game.lastLeftPos = 0;
625                 game.lastRightPos = game.lastLeftPos + winnersCount;
626             } else {
627                 if (game.resPos + halfWinners > lastPos) {
628                     game.lastRightPos = lastPos;
629                     game.lastLeftPos = lastPos - winnersCount;
630                 } else {
631                     game.lastLeftPos = game.resPos - halfWinners;
632                     game.lastRightPos = game.lastLeftPos + winnersCount;
633                 }
634             }
635         }
636 
637         game.lastLeftValue = _select_at(game, game.lastLeftPos);
638         game.lastRightValue = _select_at(game, game.lastRightPos);
639 
640 
641         //не учитывает дубликаты для left - dupes для right + dupes, но они и не нужны нам
642         game.lastLeftPos = _getPos(game, game.lastLeftValue);
643         game.lastRightPos = _getPos(game, game.lastRightValue);// + games[_game].bets[games[_game].lastRightValue].dupes;
644 
645         return true;
646     }
647 
648 
649     function _shiftRight(Game storage game, uint leftBetDif, uint rightBetDif, uint _val, uint lastPos) internal {
650         uint gleft = gasleft();
651         uint gasused = 0;
652         uint lastRightValue = game.lastRightValue;
653         uint lastRightPos = game.lastRightPos;
654         uint lastLeftValue = game.lastLeftValue;
655         uint lastLeftPos = game.lastLeftPos;
656         while (leftBetDif > rightBetDif) {
657 
658             lastRightValue = _val;
659             lastRightPos = lastRightPos + 1 + game.bets[_val].dupes;
660 
661             lastLeftValue = _select_at(game, lastLeftValue + 1);
662             lastLeftPos = _getPos(game, lastLeftValue);
663 
664             if (lastRightPos == lastPos) break;
665             if (lastLeftPos >= game.resPos) break;
666 
667             _val = _select_at(game, lastRightPos + 1);
668             leftBetDif = game.res - lastLeftValue;
669             rightBetDif = _val - game.res;
670 
671             if (gasused == 0) {
672                 gasused = gleft - gasleft() + 100000;
673             }
674             if (gasleft() < gasused) break;
675         }
676 
677         game.lastRightValue = lastRightValue;
678         game.lastRightPos = lastRightPos;
679         game.lastLeftValue = lastLeftValue;
680         game.lastLeftPos = lastLeftPos;
681     }
682 
683 
684     function _shiftLeft(Game storage game, uint leftBetDif, uint rightBetDif, uint _val) internal {
685         uint gleft = gasleft();
686         uint gasused = 0;
687         uint lastRightValue = game.lastRightValue;
688         uint lastRightPos = game.lastRightPos;
689         uint lastLeftValue = game.lastLeftValue;
690         uint lastLeftPos = game.lastLeftPos;
691         while (rightBetDif > leftBetDif) {
692             lastLeftValue = _val;
693             lastLeftPos = lastLeftPos - game.bets[lastLeftValue].dupes - 1;
694 
695             lastRightPos = lastRightPos - game.bets[lastRightValue].dupes - 1;
696             lastRightValue = _select_at(game, lastRightPos);
697 
698             if (lastLeftPos - game.bets[lastLeftValue].dupes == 0) break;
699             if (lastRightPos <= game.resPos) break;
700 
701             _val = _select_at(game, lastLeftPos - game.bets[lastLeftValue].dupes - 1);
702             leftBetDif = game.res - lastLeftValue;
703             rightBetDif = _val - game.res;
704 
705             if (gasused == 0) {
706                 gasused = gleft - gasleft() + 100000;
707             }
708             if (gasleft() < gasused) break;
709         }
710 
711         game.lastRightValue = lastRightValue;
712         game.lastRightPos = lastRightPos;
713         game.lastLeftValue = lastLeftValue;
714         game.lastLeftPos = lastLeftPos;
715     }
716 
717     function _shiftLeftRight(Game storage game) internal returns (bool) {
718         uint leftBetDif = game.res - game.lastLeftValue;
719         uint rightBetDif = game.lastRightValue - game.res;
720         if (rightBetDif == leftBetDif) return true;
721 
722         uint _val;
723 
724 
725         if (leftBetDif > rightBetDif) {
726             uint lastPos = _count(game) - 1;
727             if (game.lastRightPos == lastPos) return true;
728             if (game.lastLeftPos >= game.resPos) return true;
729             // в lastRightPos последняя позиция дубля поэтому просто +1
730             _val = _select_at(game, game.lastRightPos + 1);
731             rightBetDif = _val - game.res;
732 
733             _shiftRight(game, leftBetDif, rightBetDif, _val, lastPos);
734 
735         } else {
736             if (game.lastLeftPos - game.bets[game.lastLeftValue].dupes == 0) return true;
737             if (game.lastRightPos <= game.resPos) return true;
738             //последняя позиция дубля поэтому минус дубликаты
739             _val = _select_at(game, game.lastLeftPos - game.bets[game.lastLeftValue].dupes - 1);
740             leftBetDif = game.res - _val;
741 
742             _shiftLeft(game, leftBetDif, rightBetDif, _val);
743         }
744 
745         return true;
746     }
747 
748 
749     //при передачи старт и стоп необходимо учитывать дубликаты (старт = последняя позиция дубликата)
750     function _setWinnersAmount(Game storage game, uint _start, uint _stop) internal {
751         uint _bet;
752         uint _betAmount;
753         if (game.lastLeftPos == game.lastRightPos) {
754             _bet = _select_at(game, game.lastLeftPos);
755             game.winnersAmount = _getBetAmount(game, _bet);
756             game.allDone = true;
757         } else {
758             _start = _start > 0 ? _start : game.lastLeftPos;
759             _stop = _stop > 0 ? _stop : game.lastRightPos;
760             uint i = _start;
761             uint winnersAmount;
762             while(i <= _stop) {
763                 if (i == game.resPos) {
764                     i++;
765                     continue;
766                 }
767                 _bet = _select_at(game, i);
768                 _betAmount = _getBetAmount(game, _bet);
769                 winnersAmount = winnersAmount.add(_betAmount);
770                 //верим что старт == последней позиции дубликата
771                 if (i != _start && game.bets[_bet].dupes > 0) {
772                     i += game.bets[_bet].dupes;
773                 }
774 
775                 if (i >= game.lastRightPos) game.allDone = true;
776                 i++;
777             }
778             // это сумма ставок победителей!
779             game.winnersAmount = winnersAmount;
780         }
781 
782         if (game.allDone) {
783             uint profit = game.amount - game.winnersAmount;
784             if (profit > 0) {
785                 uint ownerPercent = profit.div(10); //10% fee
786                 game.prizePool = profit.sub(ownerPercent);
787                 dividendManagerAddress.transfer(ownerPercent);
788             }
789         }
790 
791     }
792 
793     function _getBetAmount(Game storage game, uint _bet) internal view returns (uint amount) {
794         for (uint i = 0; i < game.users[_bet].length; i++) {
795             amount = amount.add(game.betUsers[_bet][game.users[_bet][i]]);
796         }
797     }
798 
799     function _getPrize(Game storage game, address payable user) internal returns (uint amount) {
800         require(game.allDone);
801         require(!game.executed[user]);
802         game.executed[user] = true;
803         amount = _getPrizeAmount(game, user);
804 
805         require(amount > 0);
806         user.transfer(amount);
807 
808     }
809 
810     function _getPrizeAmount(Game storage game, address user) internal view returns (uint amount){
811         amount = _getUserAmount(game, user);
812         if (amount > 0 && game.prizePool > 0) {
813             // доля суммы ставок игрока, которые вошли в число победивших от общей суммы ставок победителей
814             amount = amount.add(game.prizePool.mul(amount).div(game.winnersAmount));
815         }
816     }
817 
818     function _getUserAmount(Game storage game, address user) internal view returns (uint amount){
819         amount = 0;
820         for (uint i = 0; i < game.userBets[user].length; i++) {
821             if (game.userBets[user][i] >= game.lastLeftValue &&
822                 game.userBets[user][i] <= game.lastRightValue)
823             {
824                 amount += game.betUsers[game.userBets[user][i]][user];
825             }
826         }
827     }
828 
829     //AVL FUNCTIONS
830     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
831 
832     function getPos(uint _game, uint _value) public view returns (uint) {
833         return _getPos(games[_game], _value);
834     }
835 
836     function select_at(uint _game, uint pos) public view returns (uint) {
837         return _select_at(games[_game], pos);
838     }
839 
840     function count(uint _game) public view returns (uint) {
841         return _count(games[_game]);
842     }
843 
844 
845 
846     //internal
847     //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
848     function _insert(Game storage game, uint _value) internal {
849         if (_value==0)
850             game.bets[_value].dupes++;
851         else{
852             insert_helper(game, 0, true, _value);
853         }
854     }
855 
856     //если есть дупбликаты, то возвращает позицию послденего элемента
857     function _getPos(Game storage game, uint _value) internal view returns (uint) {
858         uint c = _count(game);
859         if (c == 0) return 0; //err
860         if (game.bets[_value].count == 0) return 0; //err
861 
862         uint _first = _select_at(game, 0);
863         uint _last = _select_at(game, c-1);
864 
865         // Shortcut for the actual value
866         if (_value > _last || _value < _first) return 0; //err
867         if (_value == _first) return 0;
868         if (_value == _last) return c - 1;
869 
870         // Binary search of the value in the array
871         uint min = 0;
872         uint max = c-1;
873         while (max > min) {
874             uint mid = (max + min + 1)/ 2;
875             uint _val = _select_at(game, mid);
876             if (_val <= _value) {
877                 min = mid;
878             } else {
879                 max = mid-1;
880             }
881         }
882         return min;
883     }
884 
885 
886     function _select_at(Game storage game, uint pos) internal view returns (uint value){
887         uint zeroes=game.bets[0].dupes;
888         // Node memory left_node;
889         uint left_count;
890         if (pos<zeroes) {
891             return 0;
892         }
893         uint pos_new=pos-zeroes;
894         uint cur=game.bets[0].children[true];
895         Node storage cur_node=game.bets[cur];
896         while(true){
897             uint left=cur_node.children[false];
898             uint cur_num=cur_node.dupes+1;
899             if (left!=0) {
900 
901                 left_count=game.bets[left].count;
902             }
903             else {
904                 left_count=0;
905             }
906             if (pos_new<left_count) {
907                 cur=left;
908                 cur_node=game.bets[left];
909             }
910             else if (pos_new<left_count+cur_num){
911                 return cur;
912             }
913             else {
914                 cur=cur_node.children[true];
915                 cur_node=game.bets[cur];
916                 pos_new-=left_count+cur_num;
917             }
918         }
919 
920     }
921 
922 
923     function _count(Game storage game) internal view returns (uint){
924         Node storage root=game.bets[0];
925         Node storage child=game.bets[root.children[true]];
926         return root.dupes+child.count;
927     }
928 
929 
930     function insert_helper(Game storage game, uint p_value, bool side, uint value) private {
931         Node storage root=game.bets[p_value];
932         uint c_value=root.children[side];
933         if (c_value==0){
934             root.children[side]=value;
935             Node storage child=game.bets[value];
936             child.parent=p_value;
937             child.side=side;
938             child.height=1;
939             child.count=1;
940             update_counts(game, value);
941             rebalance_insert(game, value);
942         }
943         else if (c_value==value){
944             game.bets[c_value].dupes++;
945             update_count(game, value);
946             update_counts(game, value);
947         }
948         else{
949             bool side_new=(value >= c_value);
950             insert_helper(game, c_value,side_new,value);
951         }
952     }
953 
954 
955     function update_count(Game storage game, uint value) private {
956         Node storage n=game.bets[value];
957         n.count=1+game.bets[n.children[false]].count+game.bets[n.children[true]].count+n.dupes;
958     }
959 
960 
961     function update_counts(Game storage game, uint value) private {
962         uint parent=game.bets[value].parent;
963         while (parent!=0) {
964             update_count(game, parent);
965             parent=game.bets[parent].parent;
966         }
967     }
968 
969 
970     function rebalance_insert(Game storage game, uint n_value) private {
971         update_height(game, n_value);
972         Node storage n=game.bets[n_value];
973         uint p_value=n.parent;
974         if (p_value!=0) {
975             int p_bf=balance_factor(game, p_value);
976             bool side=n.side;
977             int sign;
978             if (side)
979                 sign=-1;
980             else
981                 sign=1;
982             if (p_bf == sign*2) {
983                 if (balance_factor(game, n_value) == (-1 * sign))
984                     rotate(game, n_value,side);
985                 rotate(game, p_value,!side);
986             }
987             else if (p_bf != 0)
988                 rebalance_insert(game, p_value);
989         }
990     }
991 
992 
993     function update_height(Game storage game, uint value) private {
994         Node storage n=game.bets[value];
995         uint height_left=game.bets[n.children[false]].height;
996         uint height_right=game.bets[n.children[true]].height;
997         if (height_left>height_right)
998             n.height=height_left+1;
999         else
1000             n.height=height_right+1;
1001     }
1002 
1003 
1004     function balance_factor(Game storage game, uint value) private view returns (int bf) {
1005         Node storage n=game.bets[value];
1006         return int(game.bets[n.children[false]].height)-int(game.bets[n.children[true]].height);
1007     }
1008 
1009 
1010     function rotate(Game storage game, uint value,bool dir) private {
1011         bool other_dir=!dir;
1012         Node storage n=game.bets[value];
1013         bool side=n.side;
1014         uint parent=n.parent;
1015         uint value_new=n.children[other_dir];
1016         Node storage n_new=game.bets[value_new];
1017         uint orphan=n_new.children[dir];
1018         Node storage p=game.bets[parent];
1019         Node storage o=game.bets[orphan];
1020         p.children[side]=value_new;
1021         n_new.side=side;
1022         n_new.parent=parent;
1023         n_new.children[dir]=value;
1024         n.parent=value_new;
1025         n.side=dir;
1026         n.children[other_dir]=orphan;
1027         o.parent=value;
1028         o.side=other_dir;
1029         update_height(game, value);
1030         update_height(game, value_new);
1031         update_count(game, value);
1032         update_count(game, value_new);
1033     }
1034 
1035 }