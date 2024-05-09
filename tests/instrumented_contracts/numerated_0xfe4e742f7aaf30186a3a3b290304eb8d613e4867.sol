1 pragma solidity ^0.4.24;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: node_modules/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
80 
81 /**
82  * @title Helps contracts guard against reentrancy attacks.
83  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
84  * @dev If you mark a function `nonReentrant`, you should also
85  * mark it `external`.
86  */
87 contract ReentrancyGuard {
88 
89   /// @dev counter to allow mutex lock with only one SSTORE operation
90   uint256 private _guardCounter;
91 
92   constructor() internal {
93     // The counter starts at one to prevent changing it from zero to a non-zero
94     // value, which is a more expensive operation.
95     _guardCounter = 1;
96   }
97 
98   /**
99    * @dev Prevents a contract from calling itself, directly or indirectly.
100    * Calling a `nonReentrant` function from another `nonReentrant`
101    * function is not supported. It is possible to prevent this from happening
102    * by making the `nonReentrant` function external, and make it call a
103    * `private` function that does the actual work.
104    */
105   modifier nonReentrant() {
106     _guardCounter += 1;
107     uint256 localCounter = _guardCounter;
108     _;
109     require(localCounter == _guardCounter);
110   }
111 
112 }
113 
114 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 interface IERC20 {
187   function totalSupply() external view returns (uint256);
188 
189   function balanceOf(address who) external view returns (uint256);
190 
191   function allowance(address owner, address spender)
192     external view returns (uint256);
193 
194   function transfer(address to, uint256 value) external returns (bool);
195 
196   function approve(address spender, uint256 value)
197     external returns (bool);
198 
199   function transferFrom(address from, address to, uint256 value)
200     external returns (bool);
201 
202   event Transfer(
203     address indexed from,
204     address indexed to,
205     uint256 value
206   );
207 
208   event Approval(
209     address indexed owner,
210     address indexed spender,
211     uint256 value
212   );
213 }
214 
215 // File: lib/CanReclaimToken.sol
216 
217 /**
218  * @title Contracts that should be able to recover tokens
219  * @author SylTi
220  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
221  * This will prevent any accidental loss of tokens.
222  */
223 contract CanReclaimToken is Ownable {
224 
225   /**
226    * @dev Reclaim all ERC20 compatible tokens
227    * @param token ERC20 The address of the token contract
228    */
229   function reclaimToken(IERC20 token) external onlyOwner {
230     if (address(token) == address(0)) {
231       owner().transfer(address(this).balance);
232       return;
233     }
234     uint256 balance = token.balanceOf(this);
235     token.transfer(owner(), balance);
236   }
237 
238 }
239 
240 // File: openzeppelin-solidity/contracts/access/Roles.sol
241 
242 /**
243  * @title Roles
244  * @dev Library for managing addresses assigned to a Role.
245  */
246 library Roles {
247   struct Role {
248     mapping (address => bool) bearer;
249   }
250 
251   /**
252    * @dev give an account access to this role
253    */
254   function add(Role storage role, address account) internal {
255     require(account != address(0));
256     require(!has(role, account));
257 
258     role.bearer[account] = true;
259   }
260 
261   /**
262    * @dev remove an account's access to this role
263    */
264   function remove(Role storage role, address account) internal {
265     require(account != address(0));
266     require(has(role, account));
267 
268     role.bearer[account] = false;
269   }
270 
271   /**
272    * @dev check if an account has this role
273    * @return bool
274    */
275   function has(Role storage role, address account)
276     internal
277     view
278     returns (bool)
279   {
280     require(account != address(0));
281     return role.bearer[account];
282   }
283 }
284 
285 // File: lib/ServiceRole.sol
286 
287 contract ServiceRole {
288   using Roles for Roles.Role;
289 
290   event ServiceAdded(address indexed account);
291   event ServiceRemoved(address indexed account);
292 
293   Roles.Role private services;
294 
295   constructor() internal {
296     _addService(msg.sender);
297   }
298 
299   modifier onlyService() {
300     require(isService(msg.sender));
301     _;
302   }
303 
304   function isService(address account) public view returns (bool) {
305     return services.has(account);
306   }
307 
308   function renounceService() public {
309     _removeService(msg.sender);
310   }
311 
312   function _addService(address account) internal {
313     services.add(account);
314     emit ServiceAdded(account);
315   }
316 
317   function _removeService(address account) internal {
318     services.remove(account);
319     emit ServiceRemoved(account);
320   }
321 }
322 
323 // File: contracts/Fights.sol
324 
325 interface HEROES {
326   function getLevel(uint256 tokenId) external view returns (uint256);
327   function getGenes(uint256 tokenId) external view returns (uint256);
328   function getRace(uint256 tokenId) external view returns (uint256);
329   function lock(uint256 tokenId, uint256 lockedTo, bool onlyFreeze) external returns (bool);
330   function unlock(uint256 tokenId) external returns (bool);
331   function ownerOf(uint256 tokenId) external view returns (address);
332   function addWin(uint256 tokenId, uint winsCount, uint levelUp) external returns (bool);
333   function addLoss(uint256 tokenId, uint256 lossesCount, uint levelDown) external returns (bool);
334 }
335 
336 //Crypto Hero Rocket coin
337 interface CHR {
338   //  function mint(address _to, uint256 _amount) external returns (bool);
339   function burn(address _from, uint256 _amount) external returns (bool);
340 }
341 
342 
343 contract Fights is Ownable, ServiceRole, ReentrancyGuard, CanReclaimToken {
344   using SafeMath for uint256;
345 
346   event SetFightInterval(uint startsFrom, uint pastFightsCount, uint fightsInterval, uint fightPeriod, uint applicationPeriod, uint betsPeriod);
347   event EnterArena(uint tokenId, uint fightId, uint startsAt, uint level, uint enemyRace);
348   event ChangeEnemy(uint tokenId, uint fightId, uint enemyRace);
349   event LeaveArena(uint tokenId, uint fightId, Result result, uint level);
350   event StartFight(uint fightId, uint startAt);
351   event RemoveFight(uint fightId);
352   event FightResult(uint fightId, uint[] races, uint[] values);
353   event FinishFight(uint fightId, uint startedAt, uint finishedAt, uint startCheckedAt, uint finishCheckedAt);
354 
355   HEROES public heroes;
356   CHR public coin;
357 
358   enum Result {QUAIL, WIN, LOSS, DRAW}
359 
360   struct Fighter {
361     uint index;
362     bool exists;
363     uint race;
364     uint level;
365     uint enemyRace;
366     bool finished;
367   }
368 
369   struct Race {
370     uint index;
371     bool exists;
372     uint count; //число участников данной рассы
373     uint enemyCount; //число игроков выбравших эту расу соперником
374     uint levelSum; //сумма всех уникальных значений уровней
375     //level => count
376     mapping(uint => uint) levelCount; // количество участников по уровням
377     //результат битвы в универсальных единицах, может быть отрицательным (32бит)
378     //измеряется в % изменении курса валюты по отношению к доллару на начало и конец периода
379     //пример курс BTC на 12:00 - 6450.33, на 17:00 - 6387.22, изменение = (6387.22 - 6450.33) / 6450.33 = -0,009784 = -0.978%
380     //учитываем 3 знака после запятой и переводим в целое число умножи на 1000 = -978
381     int32 result;
382   }
383 
384   struct Fight {
385     uint startedAt;
386     uint finishedAt;
387     uint startCheckedAt;
388     uint finishCheckedAt;
389     //index участника => tokenId
390     mapping(uint => uint) arena;
391     //tokenId => структура Бойца
392     mapping(uint => Fighter) fighters;
393     uint fightersCount;
394     // raceId => Race
395     mapping(uint => Race) races;
396     // race index => raceId
397     mapping(uint => uint) raceList;
398     uint raceCount;
399   }
400 
401 
402   //массив произошедших битв, в него помещаются только id состоявшихся битв
403   uint[] public fightsList;
404   //tokenId => fightId помним ид последней битвы персонажа, чтобы он мог выйти с использованием монетки
405   mapping(uint => uint[]) public characterFights;
406 
407   //id битвы, жестко привязан к интервалам времени
408   //т.е. если интервал = 1 час, то через 10 часов даже если не было ни одной битвы, id = 10
409   //fightId => Fight
410   mapping(uint => Fight) fights;
411 
412   //структура описывающая интервалы битв
413   struct FightInterval {
414     uint fightsInterval;
415     uint startsFrom;
416     uint fightsCount; //число уже завершенных битв до этого интервала
417     uint betsPeriod;
418     uint applicationPeriod;
419     uint fightPeriod;
420   }
421 
422   //массив хранит историю изменений настроек битв
423   //чтобы можно было иметь доступ к прошлым битвам, в случае если интервалы изменится
424   FightInterval[] public intervalHistory;
425 
426   uint public constant FightEpoch = 1542240000; //Thursday, 15 November 2018 г., 0:00:00
427   uint public minBetsLevel = 5;
428   bool public allowEnterDuringBets = true;
429 
430   modifier onlyOwnerOf(uint256 _tokenId) {
431     require(heroes.ownerOf(_tokenId) == msg.sender);
432     _;
433   }
434 
435   constructor(HEROES _heroes, CHR _coin) public {
436     require(address(_heroes) != address(0));
437     require(address(_coin) != address(0));
438     heroes = _heroes;
439     coin = _coin;
440 
441     //  uint public fightsInterval = 12 * 60 * 60; //12 hours, интервал с которым проводятся бои
442     //  uint public betsPeriod = 2 * 60 * 60; //период в течении которого доступны ставки 2 hours
443     //  uint public applicationPeriod = 11 * 60 * 60; //11 hours, период в течении которого можно подать заявку на участие в бою до начала боя
444     //  uint public fightPeriod = 5 * 60 * 60;//длительность боя, 5 часов
445 
446     intervalHistory.push(FightInterval({
447       fightPeriod: 5 * 60 * 60, //длительность боя, 5 часов,
448       startsFrom : FightEpoch,
449       fightsCount : 0,
450       fightsInterval : 12 * 60 * 60, //12 hours, интервал с которым проводятся бои,
451       betsPeriod : 2 * 60 * 60, //период в течении которого доступны ставки 2 hours,
452       applicationPeriod : 11 * 60 * 60 //11 hours, период в течении которого можно подать заявку на участие в бою до начала боя
453       }));
454   }
455 
456   /// @notice The fallback function payable
457   function() external payable {
458     require(msg.value > 0);
459     address(heroes).transfer(msg.value);
460   }
461 
462   function addService(address account) public onlyOwner {
463     _addService(account);
464   }
465 
466   function removeService(address account) public onlyOwner {
467     _removeService(account);
468   }
469 
470 
471   //устанавливает новые значения интервалов битв
472   function setFightInterval(uint _fightsInterval, uint _applicationPeriod, uint _betsPeriod, uint _fightPeriod) external onlyOwner {
473     FightInterval memory i = _getFightIntervalAt(now);
474     //todo проверить )
475     // количество интервалов прошедших с момента последней записи в истории
476     uint intervalsCount = (now - i.startsFrom) / i.fightsInterval + 1;
477     FightInterval memory ni = FightInterval({
478       fightsInterval : _fightsInterval,
479       startsFrom : i.startsFrom + i.fightsInterval * intervalsCount,
480       fightsCount : intervalsCount + i.fightsCount,
481       applicationPeriod : _applicationPeriod,
482       betsPeriod : _betsPeriod,
483       fightPeriod : _fightPeriod
484       });
485     intervalHistory.push(ni);
486     emit SetFightInterval(ni.startsFrom, ni.fightsCount, _fightsInterval, _fightPeriod, _applicationPeriod, _betsPeriod);
487   }
488 
489   //устанавливает новые значения дополнительных параметров
490   function setParameters(uint _minBetsLevel, bool _allowEnterDuringBets) external onlyOwner {
491     minBetsLevel = _minBetsLevel;
492     allowEnterDuringBets = _allowEnterDuringBets;
493   }
494 
495   function enterArena(uint _tokenId, uint _enemyRace) public onlyOwnerOf(_tokenId) {
496     //only if finished last fight
497     require(isAllowed(_tokenId));
498     uint intervalId = _getFightIntervalIdAt(now);
499     FightInterval memory i = intervalHistory[intervalId];
500     uint nextStartsAt = _getFightStartsAt(intervalId, 1);
501     //вступить в арену можно только в период приема заявок
502     require(now >= nextStartsAt - i.applicationPeriod);
503     //вступить в арену можно только до начала битвы или до начала ставок
504     require(now < nextStartsAt - (allowEnterDuringBets ? 0 : i.betsPeriod));
505 
506     uint nextFightId = getFightId(intervalId, 1);
507     Fight storage f = fights[nextFightId];
508     //на всякий случай, если мы вдруг решим закрыть определенную битву в будущем
509 //    require(f.finishedAt != 0);
510 
511     //участник еще не на арене
512     require(!f.fighters[_tokenId].exists);
513 
514     uint level = heroes.getLevel(_tokenId);
515     uint race = heroes.getRace(_tokenId);
516     require(race != _enemyRace);
517 
518     //начать fight если он еще не был начат
519     if (f.startedAt == 0) {
520       f.startedAt = nextStartsAt;
521       fightsList.push(nextFightId);
522       emit StartFight(nextFightId, nextStartsAt);
523       //todo что еще?
524     }
525 
526     //добавляем на арену
527     f.fighters[_tokenId] = Fighter({
528       exists : true,
529       finished : false,
530       index : f.fightersCount,
531       race : race,
532       enemyRace : _enemyRace,
533       level: level
534       });
535     f.arena[f.fightersCount++] = _tokenId;
536     //запоминаем в списке битв конкретного токена
537     characterFights[_tokenId].push(nextFightId);
538 
539     Race storage r = f.races[race];
540     if (!r.exists) {
541       r.exists = true;
542       r.index = f.raceCount;
543       f.raceList[f.raceCount++] = race;
544     }
545     r.count++;
546     //для будущего расчета выигрыша
547     //учет только игроков 5 и выше уровня
548     if (level >= minBetsLevel) {
549       //если еще не было участников с таким уровнем, считаем что это новый уникальный
550       if (r.levelCount[level] == 0) {
551         //суммируем уникальное значения уровня
552         r.levelSum = r.levelSum.add(level);
553       }
554       //счетчик количества игроков с данным уровнем
555       r.levelCount[level]++;
556     }
557     //учтем вражескую расу, просто создаем ее и добавляем в список, без изменения количеств,
558     //чтобы потом с бэкенда было проще пройтись по списку рас
559     Race storage er = f.races[_enemyRace];
560     if (!er.exists) {
561       er.exists = true;
562       er.index = f.raceCount;
563       f.raceList[f.raceCount++] = _enemyRace;
564     }
565     er.enemyCount++;
566 
567     //устанавливаем блокировку до конца битвы
568     require(heroes.lock(_tokenId, nextStartsAt + i.fightPeriod, false));
569     emit EnterArena(_tokenId, nextFightId, nextStartsAt, level, _enemyRace);
570 
571   }
572 
573 
574   function changeEnemy(uint _tokenId, uint _enemyRace) public onlyOwnerOf(_tokenId) {
575     uint fightId = characterLastFightId(_tokenId);
576 
577     //последняя битва должны существовать
578     require(fightId != 0);
579     Fight storage f = fights[fightId];
580     Fighter storage fr = f.fighters[_tokenId];
581     //участник уже на арене
582     //todo излишне, такого быть не должно, проанализировать
583     require(fr.exists);
584     //только если еще не завершена битва для  данного бойца
585     require(!fr.finished);
586 
587     //поменять на новую только
588     require(fr.enemyRace != _enemyRace);
589 
590     FightInterval memory i = _getFightIntervalAt(f.startedAt);
591 
592     //требуем либо текущее время до начала ставок
593     //todo излишне, достаточно now < f.startedAt - params.betsPeriod
594     //т.к. в теории игрок не может находится до начала периода заявок
595     require(now >= f.startedAt - i.applicationPeriod && now < f.startedAt - i.betsPeriod && f.finishedAt != 0);
596 
597     fr.enemyRace = _enemyRace;
598 
599     //уменьшаем счетчик расс врагов
600     Race storage er_old = f.races[fr.enemyRace];
601     er_old.enemyCount--;
602 
603     if (er_old.count == 0 && er_old.enemyCount == 0) {
604       f.races[f.raceList[--f.raceCount]].index = er_old.index;
605       f.raceList[er_old.index] = f.raceList[f.raceCount];
606       delete f.arena[f.raceCount];
607       delete f.races[fr.enemyRace];
608     }
609 
610     //учтем вражескую расу, просто создаем ее и добавляем в список, без изменения количеств,
611     //чтобы потом с бэкенда было проще пройтись по списку рас
612     Race storage er_new = f.races[_enemyRace];
613     if (!er_new.exists) {
614       er_new.index = f.raceCount;
615       f.raceList[f.raceCount++] = _enemyRace;
616     }
617     er_new.enemyCount++;
618     emit ChangeEnemy(_tokenId, fightId, _enemyRace);
619   }
620 
621   function reenterArena(uint _tokenId, uint _enemyRace, bool _useCoin) public onlyOwnerOf(_tokenId) {
622     uint fightId = characterLastFightId(_tokenId);
623     //последняя битва должны существовать
624     require(fightId != 0);
625     Fight storage f = fights[fightId];
626     Fighter storage fr = f.fighters[_tokenId];
627     //участник уже на арене
628     //todo излишне, такого быть не должно, проанализировать
629     require(fr.exists);
630     //нельзя перезайти из не начатой битвы
631 //    require (f.startedAt != 0);
632 
633     //только если еще не завершена битва для  данного бойца
634     require(!fr.finished);
635 
636     //требуем либо текущее время после конца битвы, которая завершена
637     require(f.finishedAt != 0 && now > f.finishedAt);
638 
639     Result result = Result.QUAIL;
640 
641     //обработка результатов
642     if (f.races[f.fighters[_tokenId].race].result > f.races[f.fighters[_tokenId].enemyRace].result) {
643       result = Result.WIN;
644       //wins +1, level + 1
645       heroes.addWin(_tokenId, 1, 1);
646     } else if (f.races[f.fighters[_tokenId].race].result < f.races[f.fighters[_tokenId].enemyRace].result) {
647       result = Result.LOSS;
648       //засчитываем поражение
649       if (_useCoin) {
650         require(coin.burn(heroes.ownerOf(_tokenId), 1));
651         //losses +1, level the same
652         heroes.addLoss(_tokenId, 1, 0);
653       } else {
654         //losses +1, level - 1
655         heroes.addLoss(_tokenId, 1, 1);
656       }
657     } else {
658       //todo ничья
659 //      result = Result.QUAIL;
660     }
661     fr.finished = true;
662 
663     emit LeaveArena(_tokenId, fightId, result, fr.level);
664     //вход на арену
665     enterArena(_tokenId, _enemyRace);
666   }
667 
668 
669   //покинуть арену можно до начала ставок или после окончания, и естественно только последнюю
670   function leaveArena(uint _tokenId, bool _useCoin) public onlyOwnerOf(_tokenId) {
671     uint fightId = characterLastFightId(_tokenId);
672 
673     //последняя битва должны существовать
674     require(fightId != 0);
675     Fight storage f = fights[fightId];
676     Fighter storage fr = f.fighters[_tokenId];
677     //участник уже на арене
678     //todo излишне, такого быть не должно, проанализировать
679     require(fr.exists);
680 
681     //нельзя покинуть не начатую битву
682     //    require (f.startedAt != 0);
683 
684     //только если еще не завершена битва для  данного бойца
685     require(!fr.finished);
686 
687     FightInterval memory i = _getFightIntervalAt(f.startedAt);
688 
689     //требуем либо текущее время до начала ставок, либо уже после конца битвы, которая завершена
690     require(now < f.startedAt - i.betsPeriod || (f.finishedAt != 0 && now > f.finishedAt));
691     Result result = Result.QUAIL;
692     //выход до начала битвы
693     if (f.finishedAt == 0) {
694 
695       Race storage r = f.races[fr.race];
696       //учет только игроков 5 и выше уровня
697       if (fr.level >= minBetsLevel) {
698         //уменьшаем счетчик игроков этого уровня
699         r.levelCount[fr.level]--;
700         //если это был последний игрок
701         if (r.levelCount[fr.level] == 0) {
702           r.levelSum = r.levelSum.sub(fr.level);
703         }
704       }
705       r.count--;
706 
707       Race storage er = f.races[fr.enemyRace];
708       er.enemyCount--;
709 
710       //если больше не осталось игроков в этих расах удаляем их
711       if (r.count == 0 && r.enemyCount == 0) {
712         f.races[f.raceList[--f.raceCount]].index = r.index;
713         f.raceList[r.index] = f.raceList[f.raceCount];
714         delete f.arena[f.raceCount];
715         delete f.races[fr.race];
716       }
717       if (er.count == 0 && er.enemyCount == 0) {
718           f.races[f.raceList[--f.raceCount]].index = er.index;
719         f.raceList[er.index] = f.raceList[f.raceCount];
720         delete f.arena[f.raceCount];
721         delete f.races[fr.enemyRace];
722       }
723 
724       // удалить с арены
725       f.fighters[f.arena[--f.fightersCount]].index = fr.index;
726       f.arena[fr.index] = f.arena[f.fightersCount];
727       delete f.arena[f.fightersCount];
728       delete f.fighters[_tokenId];
729       //удаляем из списка битв
730       delete characterFights[_tokenId][characterFights[_tokenId].length--];
731 
732       //todo если участник последний - то удалить битву
733       if (f.fightersCount == 0) {
734         delete fights[fightId];
735         emit RemoveFight(fightId);
736       }
737     } else {
738 
739       //выход после окончания битвы
740       if (f.races[f.fighters[_tokenId].race].result > f.races[f.fighters[_tokenId].enemyRace].result) {
741         result = Result.WIN;
742         heroes.addWin(_tokenId, 1, 1);
743       } else if (f.races[f.fighters[_tokenId].race].result < f.races[f.fighters[_tokenId].enemyRace].result) {
744         result = Result.LOSS;
745         //засчитываем поражение
746         if (_useCoin) {
747           //сжигаем 1 монетку
748           require(coin.burn(heroes.ownerOf(_tokenId), 1));
749           //при использовании монетки не уменьшаем уровень, при этом счетчик поражений +1
750           heroes.addLoss(_tokenId, 1, 0);
751         } else {
752           heroes.addLoss(_tokenId, 1, 1);
753         }
754       } else {
755         //todo ничья
756         result = Result.DRAW;
757       }
758 
759       fr.finished = true;
760     }
761     //разблокируем игрока
762     require(heroes.unlock(_tokenId));
763     emit LeaveArena(_tokenId, fightId, result, fr.level);
764 
765   }
766 
767   function fightsCount() public view returns (uint) {
768     return fightsList.length;
769   }
770 
771   //возвращает id битвы актуальный в данный момент
772   function getCurrentFightId() public view returns (uint) {
773     return getFightId(_getFightIntervalIdAt(now), 0);
774   }
775 
776   function getNextFightId() public view returns (uint) {
777     return getFightId(_getFightIntervalIdAt(now), 1);
778   }
779 
780   function getFightId(uint intervalId, uint nextShift) internal view returns (uint) {
781     FightInterval memory i = intervalHistory[intervalId];
782     return (now - i.startsFrom) / i.fightsInterval + i.fightsCount + nextShift;
783   }
784 
785   function characterFightsCount(uint _tokenId) public view returns (uint) {
786     return characterFights[_tokenId].length;
787   }
788 
789   function characterLastFightId(uint _tokenId) public view returns (uint) {
790     //    require(characterFights[_tokenId].length > 0);
791     return characterFights[_tokenId].length > 0 ? characterFights[_tokenId][characterFights[_tokenId].length - 1] : 0;
792   }
793 
794   function characterLastFight(uint _tokenId) public view returns (
795     uint index,
796     uint race,
797     uint level,
798     uint enemyRace,
799     bool finished
800   ) {
801     return getFightFighter(characterLastFightId(_tokenId), _tokenId);
802   }
803 
804   function getFightFighter(uint _fightId, uint _tokenId) public view returns (
805     uint index,
806     uint race,
807     uint level,
808     uint enemyRace,
809     bool finished
810   ) {
811     Fighter memory fr = fights[_fightId].fighters[_tokenId];
812     return (fr.index, fr.race, fr.level, fr.enemyRace, fr.finished);
813   }
814 
815   function getFightArenaFighter(uint _fightId, uint _fighterIndex) public view returns (
816     uint tokenId,
817     uint race,
818     uint level,
819     uint enemyRace,
820     bool finished
821   ) {
822     uint _tokenId = fights[_fightId].arena[_fighterIndex];
823     Fighter memory fr = fights[_fightId].fighters[_tokenId];
824     return (_tokenId, fr.race, fr.level, fr.enemyRace, fr.finished);
825   }
826 
827   function getFightRaces(uint _fightId) public view returns(uint[]) {
828     Fight storage f = fights[_fightId];
829     if (f.startedAt == 0) return;
830     uint[] memory r = new uint[](f.raceCount);
831     for(uint i; i < f.raceCount; i++) {
832       r[i] = f.raceList[i];
833     }
834     return r;
835   }
836 
837   function getFightRace(uint _fightId, uint _race) external view returns (
838     uint index,
839     uint count, //число участников данной рассы
840     uint enemyCount, //число игроков выбравших эту расу соперником
841     int32 result
842   ){
843     Race memory r = fights[_fightId].races[_race];
844     return (r.index, r.count, r.enemyCount, r.result);
845   }
846 
847   function getFightRaceLevelStat(uint _fightId, uint _race, uint _level) external view returns (
848     uint levelCount, //число участников данной рассы данного уровня
849     uint levelSum //сумма уникальных значений всех уровней данной рассы
850   ){
851     Race storage r = fights[_fightId].races[_race];
852     return (r.levelCount[_level], r.levelSum);
853   }
854 
855   function getFightResult(uint _fightId, uint _tokenId) public view returns (Result) {
856 //    uint fightId = getCharacterLastFightId(_tokenId);
857     //    require(fightId != 0);
858     Fight storage f = fights[_fightId];
859     Fighter storage fr = f.fighters[_tokenId];
860     //участник существует
861     if (!fr.exists) {
862       return Result.QUAIL;
863     }
864 //    return (int(f.races[fr.race].result) - int(f.races[fr.enemyRace].result));
865     return f.races[fr.race].result > f.races[fr.enemyRace].result ? Result.WIN : f.races[fr.race].result < f.races[fr.enemyRace].result ? Result.LOSS : Result.DRAW;
866   }
867 
868 
869   function isAllowed(uint tokenId) public view returns (bool) {
870     uint fightId = characterLastFightId(tokenId);
871     return fightId == 0 ? true : fights[fightId].fighters[tokenId].finished;
872   }
873 
874   function getCurrentFight() public view returns (
875     uint256 fightId,
876     uint256 startedAt,
877     uint256 finishedAt,
878     uint256 startCheckedAt,
879     uint256 finishCheckedAt,
880     uint256 fightersCount,
881     uint256 raceCount
882   ) {
883     fightId = getCurrentFightId();
884     (startedAt, finishedAt, startCheckedAt, finishCheckedAt, fightersCount, raceCount) = getFight(fightId);
885   }
886 
887   function getNextFight() public view returns (
888     uint256 fightId,
889     uint256 startedAt,
890     uint256 finishedAt,
891     uint256 startCheckedAt,
892     uint256 finishCheckedAt,
893     uint256 fightersCount,
894     uint256 raceCount
895   ) {
896     fightId = getNextFightId();
897     (startedAt, finishedAt, startCheckedAt, finishCheckedAt, fightersCount, raceCount) = getFight(fightId);
898   }
899 
900   function getFight(uint _fightId) public view returns (
901     uint256 startedAt,
902     uint256 finishedAt,
903     uint256 startCheckedAt,
904     uint256 finishCheckedAt,
905     uint256 fightersCount,
906     uint256 raceCount
907   ) {
908     Fight memory f = fights[_fightId];
909     return (f.startedAt, f.finishedAt, f.startCheckedAt, f.finishCheckedAt, f.fightersCount, f.raceCount);
910   }
911 
912   function getNextFightInterval() external view returns (
913     uint fightId,
914     uint currentTime,
915     uint applicationStartAt,
916     uint betsStartAt,
917     uint fightStartAt,
918     uint fightFinishAt
919   ) {
920     uint intervalId = _getFightIntervalIdAt(now);
921     fightId = getFightId(intervalId, 1);
922     (currentTime, applicationStartAt, betsStartAt, fightStartAt, fightFinishAt) = _getFightInterval(intervalId, 1);
923   }
924 
925   function getCurrentFightInterval() external view returns (
926     uint fightId,
927     uint currentTime,
928     uint applicationStartAt,
929     uint betsStartAt,
930     uint fightStartAt,
931     uint fightFinishAt
932   ) {
933     uint intervalId = _getFightIntervalIdAt(now);
934     fightId = getFightId(intervalId, 0);
935     (currentTime, applicationStartAt, betsStartAt, fightStartAt, fightFinishAt) = _getFightInterval(intervalId, 0);
936   }
937 
938   function _getFightInterval(uint intervalId, uint nextShift) internal view returns (
939 //    uint fightId,
940     uint currentTime,
941     uint applicationStartAt,
942     uint betsStartAt,
943     uint fightStartAt,
944     uint fightFinishAt
945   ) {
946 
947     fightStartAt = _getFightStartsAt(intervalId, nextShift);
948 
949     FightInterval memory i = intervalHistory[intervalId];
950     currentTime = now;
951     applicationStartAt = fightStartAt - i.applicationPeriod;
952     betsStartAt = fightStartAt - i.betsPeriod;
953     fightFinishAt = fightStartAt + i.fightPeriod;
954   }
955 
956   function _getFightStartsAt(uint intervalId, uint nextShift) internal view returns (uint) {
957     FightInterval memory i = intervalHistory[intervalId];
958     uint intervalsCount = (now - i.startsFrom) / i.fightsInterval + nextShift;
959     return i.startsFrom + i.fightsInterval * intervalsCount;
960   }
961 
962 
963   function getCurrentIntervals() external view returns (
964     uint fightsInterval,
965     uint fightPeriod,
966     uint applicationPeriod,
967     uint betsPeriod
968   ) {
969     FightInterval memory i = _getFightIntervalAt(now);
970     fightsInterval = i.fightsInterval;
971     fightPeriod = i.fightPeriod;
972     applicationPeriod = i.applicationPeriod;
973     betsPeriod = i.betsPeriod;
974   }
975 
976 
977   function _getFightIntervalAt(uint _time)  internal view returns (FightInterval memory) {
978     return intervalHistory[_getFightIntervalIdAt(_time)];
979   }
980 
981 
982   function _getFightIntervalIdAt(uint _time)  internal view returns (uint) {
983     require(intervalHistory.length>0);
984     //    if (intervalHistory.length == 0) return 0;
985 
986     // Shortcut for the actual value
987     if (_time >= intervalHistory[intervalHistory.length - 1].startsFrom)
988       return intervalHistory.length - 1;
989     if (_time < intervalHistory[0].startsFrom) return 0;
990 
991     // Binary search of the value in the array
992     uint min = 0;
993     uint max = intervalHistory.length - 1;
994     while (max > min) {
995       uint mid = (max + min + 1) / 2;
996       if (intervalHistory[mid].startsFrom <= _time) {
997         min = mid;
998       } else {
999         max = mid - 1;
1000       }
1001     }
1002     return min;
1003   }
1004 
1005 
1006   //устанавливает результаты для битвы для всех расс
1007   //принимает 2 соответствующих массива id расс и значений результата битвы
1008   //значения 32битные, упакованы в uint256
1009   // !!! закрытие битвы отдельной функцией, т.к. результатов может быть очень много и не уложится в один вызов !!!
1010   function setFightResult(uint fightId, uint count, uint[] packedRaces, uint[] packedResults) public onlyService {
1011     require(packedRaces.length == packedResults.length);
1012     require(packedRaces.length * 8 >= count);
1013 
1014     Fight storage f = fights[fightId];
1015     require(f.startedAt != 0 && f.finishedAt == 0);
1016 
1017     //    f.finishedAt = now;
1018     for (uint i = 0; i < count; i++) {
1019 //      for (uint n = 0; n < 8 || ; n++) {
1020         f.races[_upack(packedRaces[i / 8], i % 8)].result = int32(_upack(packedResults[i / 8], i % 8));
1021 //      }
1022     }
1023     emit FightResult(fightId, packedRaces, packedResults);
1024 
1025   }
1026 
1027   //close the fight, save check points time
1028   function finishFight(uint fightId, uint startCheckedAt, uint finishCheckedAt) public onlyService {
1029     Fight storage f = fights[fightId];
1030     require(f.startedAt != 0 && f.finishedAt == 0);
1031     FightInterval memory i = _getFightIntervalAt(f.startedAt);
1032     //нельзя закрыть до истечения периода битвы
1033     require(now >= f.startedAt + i.fightPeriod);
1034     f.finishedAt = now;
1035     f.startCheckedAt = startCheckedAt;
1036     f.finishCheckedAt = finishCheckedAt;
1037     emit FinishFight(fightId, f.startedAt, f.finishedAt, startCheckedAt, finishCheckedAt);
1038   }
1039 
1040   //extract n-th 32-bit int from uint
1041   function _upack(uint _v, uint _n) internal pure returns (uint) {
1042     //    _n = _n & 7; //be sure < 8
1043     return (_v >> (32 * _n)) & 0xFFFFFFFF;
1044   }
1045 
1046   //merge n-th 32-bit int to uint
1047   function _puck(uint _v, uint _n, uint _x) internal pure returns (uint) {
1048     //    _n = _n & 7; //be sure < 8
1049     //number = number & ~(1 << n) | (x << n);
1050     return _v & ~(0xFFFFFFFF << (32 * _n)) | ((_x & 0xFFFFFFFF) << (32 * _n));
1051   }
1052 }