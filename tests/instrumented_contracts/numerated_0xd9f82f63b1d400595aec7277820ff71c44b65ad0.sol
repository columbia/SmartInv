1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   function getOwner() returns(address){
33     return owner;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) onlyOwner {
41     require(newOwner != address(0));      
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 /*
49  * Базовый контракт, который поддерживает остановку продаж
50  */
51 
52 contract Haltable is Ownable {
53     bool public halted;
54 
55     modifier stopInEmergency {
56         require(!halted);
57         _;
58     }
59 
60     /* Модификатор, который вызывается в потомках */
61     modifier onlyInEmergency {
62         require(halted);
63         _;
64     }
65 
66     /* Вызов функции прервет продажи, вызывать может только владелец */
67     function halt() external onlyOwner {
68         halted = true;
69     }
70 
71     /* Вызов возвращает режим продаж */
72     function unhalt() external onlyOwner onlyInEmergency {
73         halted = false;
74     }
75 
76 }
77 
78 /**
79  * Различные валидаторы
80  */
81 
82 contract ValidationUtil {
83     function requireNotEmptyAddress(address value) internal{
84         require(isAddressValid(value));
85     }
86 
87     function isAddressValid(address value) internal constant returns (bool result){
88         return value != 0;
89     }
90 }
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
98     uint256 c = a * b;
99     assert(a == 0 || c / a == b);
100     return c;
101   }
102 
103   function div(uint256 a, uint256 b) internal constant returns (uint256) {
104     // assert(b > 0); // Solidity automatically throws when dividing by 0
105     uint256 c = a / b;
106     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107     return c;
108   }
109 
110   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   function add(uint256 a, uint256 b) internal constant returns (uint256) {
116     uint256 c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) constant returns (uint256);
130   function transfer(address to, uint256 value) returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 /**
135  * @title Basic token
136  * @dev Basic version of StandardToken, with no allowances. 
137  */
138 contract BasicToken is ERC20Basic {
139   using SafeMath for uint256;
140 
141   mapping(address => uint256) balances;
142 
143   /**
144   * @dev transfer token for a specified address
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transfer(address _to, uint256 _value) returns (bool) {
149     require(_to != address(0));
150 
151     // SafeMath.sub will throw if there is not enough balance.
152     balances[msg.sender] = balances[msg.sender].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     Transfer(msg.sender, _to, _value);
155     return true;
156   }
157 
158   /**
159   * @dev Gets the balance of the specified address.
160   * @param _owner The address to query the the balance of. 
161   * @return An uint256 representing the amount owned by the passed address.
162   */
163   function balanceOf(address _owner) constant returns (uint256 balance) {
164     return balances[_owner];
165   }
166 
167 }
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) constant returns (uint256);
175   function transferFrom(address from, address to, uint256 value) returns (bool);
176   function approve(address spender, uint256 value) returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
199     require(_to != address(0));
200 
201     var _allowance = allowed[_from][msg.sender];
202 
203     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
204     // require (_value <= _allowance);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = _allowance.sub(_value);
209     Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) returns (bool) {
219 
220     // To change the approve amount you first have to reduce the addresses`
221     //  allowance to zero by calling `approve(_spender, 0)` if it is not
222     //  already 0 to mitigate the race condition described here:
223     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
225 
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
238     return allowed[_owner][_spender];
239   }
240   
241   /**
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until 
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    */
247   function increaseApproval (address _spender, uint _addedValue) 
248     returns (bool success) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   function decreaseApproval (address _spender, uint _subtractedValue) 
255     returns (bool success) {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 /**
269  * Шаблон для токена, который можно сжечь
270 */
271 contract BurnableToken is StandardToken, Ownable, ValidationUtil {
272     using SafeMath for uint;
273 
274     address public tokenOwnerBurner;
275 
276     /** Событие, сколько токенов мы сожгли */
277     event Burned(address burner, uint burnedAmount);
278 
279     function setOwnerBurner(address _tokenOwnerBurner) public onlyOwner invalidOwnerBurner{
280         // Проверка, что адрес не пустой
281         requireNotEmptyAddress(_tokenOwnerBurner);
282 
283         tokenOwnerBurner = _tokenOwnerBurner;
284     }
285 
286     /**
287      * Сжигаем токены на балансе владельца токенов, вызвать может только tokenOwnerBurner
288      */
289     function burnOwnerTokens(uint burnAmount) public onlyTokenOwnerBurner validOwnerBurner{
290         burnTokens(tokenOwnerBurner, burnAmount);
291     }
292 
293     /**
294      * Сжигаем токены на балансе адреса токенов, вызвать может только tokenOwnerBurner
295      */
296     function burnTokens(address _address, uint burnAmount) public onlyTokenOwnerBurner validOwnerBurner{
297         balances[_address] = balances[_address].sub(burnAmount);
298 
299         // Вызываем событие
300         Burned(_address, burnAmount);
301     }
302 
303     /**
304      * Сжигаем все токены на балансе владельца
305      */
306     function burnAllOwnerTokens() public onlyTokenOwnerBurner validOwnerBurner{
307         uint burnAmount = balances[tokenOwnerBurner];
308         burnTokens(tokenOwnerBurner, burnAmount);
309     }
310 
311     /** Модификаторы
312      */
313     modifier onlyTokenOwnerBurner() {
314         require(msg.sender == tokenOwnerBurner);
315 
316         _;
317     }
318 
319     modifier validOwnerBurner() {
320         // Проверка, что адрес не пустой
321         requireNotEmptyAddress(tokenOwnerBurner);
322 
323         _;
324     }
325 
326     modifier invalidOwnerBurner() {
327         // Проверка, что адрес не пустой
328         require(!isAddressValid(tokenOwnerBurner));
329 
330         _;
331     }
332 }
333 
334 /**
335  * Токен продаж
336  *
337  * ERC-20 токен, для ICO
338  *
339  */
340 
341 contract CrowdsaleToken is StandardToken, Ownable {
342 
343     /* Описание см. в конструкторе */
344     string public name;
345 
346     string public symbol;
347 
348     uint public decimals;
349 
350     address public mintAgent;
351 
352     /** Событие обновления токена (имя и символ) */
353     event UpdatedTokenInformation(string newName, string newSymbol);
354 
355     /** Событие выпуска токенов */
356     event TokenMinted(uint amount, address toAddress);
357 
358     /**
359      * Конструктор
360      *
361      * Токен должен быть создан только владельцем через кошелек (либо с мультиподписью, либо без нее)
362      *
363      * @param _name - имя токена
364      * @param _symbol - символ токена
365      * @param _decimals - кол-во знаков после запятой
366      */
367     function CrowdsaleToken(string _name, string _symbol, uint _decimals) {
368         owner = msg.sender;
369 
370         name = _name;
371         symbol = _symbol;
372 
373         decimals = _decimals;
374     }
375 
376     /**
377      * Владелец должен вызвать эту функцию, чтобы выпустить токены на адрес
378      */
379     function mintToAddress(uint amount, address toAddress) onlyMintAgent{
380         // перевод токенов на аккаунт
381         balances[toAddress] = amount;
382 
383         // вызываем событие
384         TokenMinted(amount, toAddress);
385     }
386 
387     /**
388      * Владелец может обновить инфу по токену
389      */
390     function setTokenInformation(string _name, string _symbol) onlyOwner {
391         name = _name;
392         symbol = _symbol;
393 
394         // Вызываем событие
395         UpdatedTokenInformation(name, symbol);
396     }
397 
398     /**
399      * Только владелец может обновить агента для создания токенов
400      */
401     function setMintAgent(address _address) onlyOwner {
402         mintAgent =  _address;
403     }
404 
405     modifier onlyMintAgent(){
406         require(msg.sender == mintAgent);
407 
408         _;
409     }
410 }
411 
412 /**
413  * Шаблон для продаж токена, который можно сжечь
414  *
415  */
416 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
417 
418     function BurnableCrowdsaleToken(string _name, string _symbol, uint _decimals) CrowdsaleToken(_name, _symbol, _decimals) BurnableToken(){
419 
420     }
421 }
422 
423 /**
424  * Базовый контракт для продаж
425  *
426  * Содержит
427  * - Дата начала и конца
428  */
429 
430 /* Продажи могут быть остановлены в любой момент по вызову halt() */
431 
432 contract AllocatedCappedCrowdsale is Haltable, ValidationUtil {
433     using SafeMath for uint;
434 
435     // Кол-во токенов для распределения
436     uint public advisorsTokenAmount = 8040817;
437     uint public supportTokenAmount = 3446064;
438     uint public marketingTokenAmount = 3446064;
439     uint public teamTokenAmount = 45947521;
440 
441     uint public teamTokensIssueDate;
442 
443     /* Токен, который продаем */
444     BurnableCrowdsaleToken public token;
445 
446     /* Адрес, куда будут переведена собранная сумма, в случае успеха */
447     address public destinationMultisigWallet;
448 
449     /* Первая стадия в формате UNIX timestamp */
450     uint public firstStageStartsAt;
451     /* Конец продаж в формате UNIX timestamp */
452     uint public firstStageEndsAt;
453 
454     /* Вторая стадия в формате UNIX timestamp */
455     uint public secondStageStartsAt;
456     /* Конец продаж в формате UNIX timestamp */
457     uint public secondStageEndsAt;
458 
459     /* Минимальная кепка для первой стадии в центах */
460     uint public softCapFundingGoalInCents = 392000000;
461 
462     /* Минимальная кепка для второй стадии в центах */
463     uint public hardCapFundingGoalInCents = 985000000;
464 
465     /* Сколько всего в wei мы получили 10^18 wei = 1 ether */
466     uint public weiRaised;
467 
468     /* Сколько всего собрали в ценах на первой стадии */
469     uint public firstStageRaisedInWei;
470 
471     /* Сколько всего собрали в ценах на второй стадии */
472     uint public secondStageRaisedInWei;
473 
474     /* Кол-во уникальных адресов, которые у наc получили токены */
475     uint public investorCount;
476 
477     /*  Сколько wei отдали инвесторам на refund'е в wei */
478     uint public weiRefunded;
479 
480     /*  Сколько токенов продали всего */
481     uint public tokensSold;
482 
483     /* Флаг того, что сработал финализатор первой стадии */
484     bool public isFirstStageFinalized;
485 
486     /* Флаг того, что сработал финализатор второй стадии */
487     bool public isSecondStageFinalized;
488 
489     /* Флаг нормального завершнения продаж */
490     bool public isSuccessOver;
491 
492     /* Флаг того, что начался процесс возврата */
493     bool public isRefundingEnabled;
494 
495     /*  Сколько сейчас стоит 1 eth в центах, округленная до целых */
496     uint public currentEtherRateInCents;
497 
498     /* Текущая стоимость токена в центах */
499     uint public oneTokenInCents = 7;
500 
501     /* Выпущены ли токены для первой стадии */
502     bool public isFirstStageTokensMinted;
503 
504     /* Выпущены ли токены для второй стадии */
505     bool public isSecondStageTokensMinted;
506 
507     /* Кол-во токенов для первой стадии */
508     uint public firstStageTotalSupply = 112000000;
509 
510     /* Кол-во токенов проданных на первой стадии*/
511     uint public firstStageTokensSold;
512 
513     /* Кол-во токенов для второй стадии */
514     uint public secondStageTotalSupply = 229737610;
515 
516     /* Кол-во токенов проданных на второй стадии*/
517     uint public secondStageTokensSold;
518 
519     /* Кол-во токенов, которые находятся в резерве и не продаются, после успеха, они распределяются в соотвествии с Token Policy на второй стадии*/
520     uint public secondStageReserve = 60880466;
521 
522     /* Кол-во токенов предназначенных для продажи, на второй стадии*/
523     uint public secondStageTokensForSale;
524 
525     /* Мапа адрес инвестора - кол-во выданных токенов */
526     mapping (address => uint) public tokenAmountOf;
527 
528     /* Мапа, адрес инвестора - кол-во эфира */
529     mapping (address => uint) public investedAmountOf;
530 
531     /* Адреса, куда будут распределены токены */
532     address public advisorsAccount;
533     address public marketingAccount;
534     address public supportAccount;
535     address public teamAccount;
536 
537     /** Возможные состояния
538      *
539      * - Prefunding: подготовка, залили контракт, но текущая дата меньше даты первой стадии
540      * - FirstStageFunding: Продажи первой стадии
541      * - FirstStageEnd: Окончены продажи первой стадии, но еще не вызван финализатор первой стадии
542      * - SecondStageFunding: Продажи второго этапа
543      * - SecondStageEnd: Окончены продажи второй стадии, но не вызван финализатор второй сдадии
544      * - Success: Успешно закрыли ICO
545      * - Failure: Не собрали Soft Cap
546      * - Refunding: Возвращаем собранный эфир
547      */
548     enum State{PreFunding, FirstStageFunding, FirstStageEnd, SecondStageFunding, SecondStageEnd, Success, Failure, Refunding}
549 
550     // Событие покупки токена
551     event Invested(address indexed investor, uint weiAmount, uint tokenAmount, uint centAmount, uint txId);
552 
553     // Событие изменения курса eth
554     event ExchangeRateChanged(uint oldExchangeRate, uint newExchangeRate);
555 
556     // Событие изменения даты окончания первой стадии
557     event FirstStageStartsAtChanged(uint newFirstStageStartsAt);
558     event FirstStageEndsAtChanged(uint newFirstStageEndsAt);
559 
560     // Событие изменения даты окончания второй стадии
561     event SecondStageStartsAtChanged(uint newSecondStageStartsAt);
562     event SecondStageEndsAtChanged(uint newSecondStageEndsAt);
563 
564     // Событие изменения Soft Cap'а
565     event SoftCapChanged(uint newGoal);
566 
567     // Событие изменения Hard Cap'а
568     event HardCapChanged(uint newGoal);
569 
570     // Конструктор
571     function AllocatedCappedCrowdsale(uint _currentEtherRateInCents, address _token, address _destinationMultisigWallet, uint _firstStageStartsAt, uint _firstStageEndsAt, uint _secondStageStartsAt, uint _secondStageEndsAt, address _advisorsAccount, address _marketingAccount, address _supportAccount, address _teamAccount, uint _teamTokensIssueDate) {
572         requireNotEmptyAddress(_destinationMultisigWallet);
573         // Проверка, что даты установлены
574         require(_firstStageStartsAt != 0);
575         require(_firstStageEndsAt != 0);
576 
577         require(_firstStageStartsAt < _firstStageEndsAt);
578 
579         require(_secondStageStartsAt != 0);
580         require(_secondStageEndsAt != 0);
581 
582         require(_secondStageStartsAt < _secondStageEndsAt);
583         require(_teamTokensIssueDate != 0);
584 
585         // Токен, который поддерживает сжигание
586         token = BurnableCrowdsaleToken(_token);
587 
588         destinationMultisigWallet = _destinationMultisigWallet;
589 
590         firstStageStartsAt = _firstStageStartsAt;
591         firstStageEndsAt = _firstStageEndsAt;
592         secondStageStartsAt = _secondStageStartsAt;
593         secondStageEndsAt = _secondStageEndsAt;
594 
595         // Адреса кошельков для адвизоров, маркетинга, команды
596         advisorsAccount = _advisorsAccount;
597         marketingAccount = _marketingAccount;
598         supportAccount = _supportAccount;
599         teamAccount = _teamAccount;
600 
601         teamTokensIssueDate = _teamTokensIssueDate;
602 
603         currentEtherRateInCents = _currentEtherRateInCents;
604 
605         secondStageTokensForSale = secondStageTotalSupply.sub(secondStageReserve);
606     }
607 
608     /**
609      * Функция, инициирующая нужное кол-во токенов для первого этапа продаж, вызвать можно только 1 раз
610      */
611     function mintTokensForFirstStage() public onlyOwner {
612         // Если уже создали токены для первой стадии, делаем откат
613         require(!isFirstStageTokensMinted);
614 
615         uint tokenMultiplier = 10 ** token.decimals();
616 
617         token.mintToAddress(firstStageTotalSupply.mul(tokenMultiplier), address(this));
618 
619         isFirstStageTokensMinted = true;
620     }
621 
622     /**
623      * Функция, инициирующая нужное кол-во токенов для второго этапа продаж, только в случае, если это еще не сделано и были созданы токены для первой стадии
624      */
625     function mintTokensForSecondStage() private {
626         // Если уже создали токены для второй стадии, делаем откат
627         require(!isSecondStageTokensMinted);
628 
629         require(isFirstStageTokensMinted);
630 
631         uint tokenMultiplier = 10 ** token.decimals();
632 
633         token.mintToAddress(secondStageTotalSupply.mul(tokenMultiplier), address(this));
634 
635         isSecondStageTokensMinted = true;
636     }
637 
638     /**
639      * Функция возвращающая текущую стоимость 1 токена в wei
640      */
641     function getOneTokenInWei() external constant returns(uint){
642         return oneTokenInCents.mul(10 ** 18).div(currentEtherRateInCents);
643     }
644 
645     /**
646      * Функция, которая переводит wei в центы по текущему курсу
647      */
648     function getWeiInCents(uint value) public constant returns(uint){
649         return currentEtherRateInCents.mul(value).div(10 ** 18);
650     }
651 
652     /**
653      * Перевод токенов покупателю
654      */
655     function assignTokens(address receiver, uint tokenAmount) private {
656         // Если перевод не удался, откатываем транзакцию
657         if (!token.transfer(receiver, tokenAmount)) revert();
658     }
659 
660     /**
661      * Fallback функция вызывающаяся при переводе эфира
662      */
663     function() payable {
664         buy();
665     }
666 
667     /**
668      * Низкоуровневая функция перевода эфира и выдачи токенов
669      */
670     function internalAssignTokens(address receiver, uint tokenAmount, uint weiAmount, uint centAmount, uint txId) internal {
671         // Переводим токены инвестору
672         assignTokens(receiver, tokenAmount);
673 
674         // Вызываем событие
675         Invested(receiver, weiAmount, tokenAmount, centAmount, txId);
676 
677         // Может переопределяеться в наследниках
678     }
679 
680     /**
681      * Инвестиции
682      * Должен быть включен режим продаж первой или второй стадии и не собран Hard Cap
683      * @param receiver - эфирный адрес получателя
684      * @param txId - id внешней транзакции
685      */
686     function internalInvest(address receiver, uint weiAmount, uint txId) stopInEmergency inFirstOrSecondFundingState notHardCapReached internal {
687         State currentState = getState();
688 
689         uint tokenMultiplier = 10 ** token.decimals();
690 
691         uint amountInCents = getWeiInCents(weiAmount);
692 
693         // Очень внимательно нужно менять значения, т.к. для второй стадии 1000%, чтобы учесть дробные значения
694         uint bonusPercentage = 0;
695         uint bonusStateMultiplier = 1;
696 
697         // если запущена первая стадия, в конструкторе уже выпустили нужное кол-во токенов для первой стадии
698         if (currentState == State.FirstStageFunding){
699             // меньше 25000$ не принимаем
700             require(amountInCents >= 2500000);
701 
702             // [25000$ - 50000$) - 50% бонуса
703             if (amountInCents >= 2500000 && amountInCents < 5000000){
704                 bonusPercentage = 50;
705             // [50000$ - 100000$) - 75% бонуса
706             }else if(amountInCents >= 5000000 && amountInCents < 10000000){
707                 bonusPercentage = 75;
708             // >= 100000$ - 100% бонуса
709             }else if(amountInCents >= 10000000){
710                 bonusPercentage = 100;
711             }else{
712                 revert();
713             }
714 
715         // если запущена вторая стадия
716         } else if(currentState == State.SecondStageFunding){
717             // Процент проданных токенов, будем считать с множителем 10, т.к. есть дробные значения
718             bonusStateMultiplier = 10;
719 
720             // Кол-во проданных токенов нужно считать от значения тех токенов, которые предназначены для продаж, т.е. secondStageTokensForSale
721             uint tokensSoldPercentage = secondStageTokensSold.mul(100).div(secondStageTokensForSale.mul(tokenMultiplier));
722 
723             // меньше 7$ не принимаем
724             require(amountInCents >= 700);
725 
726             // (0% - 10%) - 20% бонуса
727             if (tokensSoldPercentage >= 0 && tokensSoldPercentage < 10){
728                 bonusPercentage = 200;
729             // [10% - 20%) - 17.5% бонуса
730             }else if (tokensSoldPercentage >= 10 && tokensSoldPercentage < 20){
731                 bonusPercentage = 175;
732             // [20% - 30%) - 15% бонуса
733             }else if (tokensSoldPercentage >= 20 && tokensSoldPercentage < 30){
734                 bonusPercentage = 150;
735             // [30% - 40%) - 12.5% бонуса
736             }else if (tokensSoldPercentage >= 30 && tokensSoldPercentage < 40){
737                 bonusPercentage = 125;
738             // [40% - 50%) - 10% бонуса
739             }else if (tokensSoldPercentage >= 40 && tokensSoldPercentage < 50){
740                 bonusPercentage = 100;
741             // [50% - 60%) - 8% бонуса
742             }else if (tokensSoldPercentage >= 50 && tokensSoldPercentage < 60){
743                 bonusPercentage = 80;
744             // [60% - 70%) - 6% бонуса
745             }else if (tokensSoldPercentage >= 60 && tokensSoldPercentage < 70){
746                 bonusPercentage = 60;
747             // [70% - 80%) - 4% бонуса
748             }else if (tokensSoldPercentage >= 70 && tokensSoldPercentage < 80){
749                 bonusPercentage = 40;
750             // [80% - 90%) - 2% бонуса
751             }else if (tokensSoldPercentage >= 80 && tokensSoldPercentage < 90){
752                 bonusPercentage = 20;
753             // >= 90% - 0% бонуса
754             }else if (tokensSoldPercentage >= 90){
755                 bonusPercentage = 0;
756             }else{
757                 revert();
758             }
759         } else revert();
760 
761         // сколько токенов нужно выдать без бонуса
762         uint resultValue = amountInCents.mul(tokenMultiplier).div(oneTokenInCents);
763 
764         // с учетом бонуса
765         uint tokenAmount = resultValue.mul(bonusStateMultiplier.mul(100).add(bonusPercentage)).div(bonusStateMultiplier.mul(100));
766 
767         // краевой случай, когда запросили больше, чем можем выдать
768         uint tokensLeft = getTokensLeftForSale(currentState);
769         if (tokenAmount > tokensLeft){
770             tokenAmount = tokensLeft;
771         }
772 
773         // Кол-во 0?, делаем откат
774         require(tokenAmount != 0);
775 
776         // Новый инвестор?
777         if (investedAmountOf[receiver] == 0) {
778             investorCount++;
779         }
780 
781         // Кидаем токены инвестору
782         internalAssignTokens(receiver, tokenAmount, weiAmount, amountInCents, txId);
783 
784         // Обновляем статистику
785         updateStat(currentState, receiver, tokenAmount, weiAmount);
786 
787         // Шлем на кошелёк эфир
788         // Функция - прослойка для возможности переопределения в дочерних классах
789         // Если это внешний вызов, то депозит не кладем
790         if (txId == 0){
791             internalDeposit(destinationMultisigWallet, weiAmount);
792         }
793 
794         // Может переопределяеться в наследниках
795     }
796 
797     /**
798      * Низкоуровневая функция перевода эфира на контракт, функция доступна для переопределения в дочерних классах, но не публична
799      */
800     function internalDeposit(address receiver, uint weiAmount) internal{
801         // Переопределяется в наследниках
802     }
803 
804     /**
805      * Низкоуровневая функция для возврата средств, функция доступна для переопределения в дочерних классах, но не публична
806      */
807     function internalRefund(address receiver, uint weiAmount) internal{
808         // Переопределяется в наследниках
809     }
810 
811     /**
812      * Низкоуровневая функция для включения режима возврата средств
813      */
814     function internalEnableRefunds() internal{
815         // Переопределяется в наследниках
816     }
817 
818     /**
819      * Спец. функция, которая позволяет продавать токены вне ценовой политики, доступка только владельцу
820      * Результаты пишутся в общую статистику, без разделения на стадии
821      * @param receiver - получатель
822      * @param tokenAmount - общее кол-во токенов c decimals!!!
823      * @param weiAmount - цена в wei
824      */
825     function internalPreallocate(State currentState, address receiver, uint tokenAmount, uint weiAmount) internal {
826         // Cколько токенов осталось для продажи? Больше этого значения выдать не можем!
827         require(getTokensLeftForSale(currentState) >= tokenAmount);
828 
829         // Может быть 0, выдаем токены бесплатно
830         internalAssignTokens(receiver, tokenAmount, weiAmount, getWeiInCents(weiAmount), 0);
831 
832         // Обновляем статистику
833         updateStat(currentState, receiver, tokenAmount, weiAmount);
834 
835         // Может переопределяеться в наследниках
836     }
837 
838     /**
839      * Низкоуровневая функция для действий, в случае успеха
840      */
841     function internalSuccessOver() internal {
842         // Переопределяется в наследниках
843     }
844 
845     /**
846      * Функция, которая переопределяется в надледниках и выполняется после установки адреса аккаунта для перевода средств
847      */
848     function internalSetDestinationMultisigWallet(address destinationAddress) internal{
849     }
850 
851     /**
852      * Обновляем статистику для первой или второй стадии
853      */
854     function updateStat(State currentState, address receiver, uint tokenAmount, uint weiAmount) private{
855         weiRaised = weiRaised.add(weiAmount);
856         tokensSold = tokensSold.add(tokenAmount);
857 
858         // Если это первая стадия
859         if (currentState == State.FirstStageFunding){
860             // Увеличиваем стату
861             firstStageRaisedInWei = firstStageRaisedInWei.add(weiAmount);
862             firstStageTokensSold = firstStageTokensSold.add(tokenAmount);
863         }
864 
865         // Если это вторая стадия
866         if (currentState == State.SecondStageFunding){
867             // Увеличиваем стату
868             secondStageRaisedInWei = secondStageRaisedInWei.add(weiAmount);
869             secondStageTokensSold = secondStageTokensSold.add(tokenAmount);
870         }
871 
872         investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
873         tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
874     }
875 
876     /**
877      * Функция, которая позволяет менять адрес аккаунта, куда будут переведены средства, в случае успеха,
878      * менять может только владелец и только в случае если продажи еще не завершены успехом
879      */
880     function setDestinationMultisigWallet(address destinationAddress) public onlyOwner canSetDestinationMultisigWallet{
881         destinationMultisigWallet = destinationAddress;
882 
883         internalSetDestinationMultisigWallet(destinationAddress);
884     }
885 
886     /**
887      * Функция, которая задает текущий курс eth в центах
888      */
889     function changeCurrentEtherRateInCents(uint value) public onlyOwner {
890         // Если случайно задали 0, не откатываем транзакцию
891         require(value > 0);
892 
893         currentEtherRateInCents = value;
894 
895         ExchangeRateChanged(currentEtherRateInCents, value);
896     }
897 
898     /**
899     * Разделил на 2 метода, чтобы не запутаться при вызове
900     * Эти функции нужны в 2-х случаях: немного не собрали до Cap'а, сами докидываем необходимую сумму, есть приватные инвесторы, для которых существуют особые условия
901     */
902 
903     /* Для первой стадии */
904     function preallocateFirstStage(address receiver, uint tokenAmount, uint weiAmount) public onlyOwner isFirstStageFundingOrEnd {
905         internalPreallocate(State.FirstStageFunding, receiver, tokenAmount, weiAmount);
906     }
907 
908     /* Для второй стадии, выдать можем не больше остатка для продажи */
909     function preallocateSecondStage(address receiver, uint tokenAmount, uint weiAmount) public onlyOwner isSecondStageFundingOrEnd {
910         internalPreallocate(State.SecondStageFunding, receiver, tokenAmount, weiAmount);
911     }
912 
913     /* В случае успеха, заблокированные токены для команды могут быть востребованы только если наступила определенная дата */
914     function issueTeamTokens() public onlyOwner inState(State.Success) {
915         require(block.timestamp >= teamTokensIssueDate);
916 
917         uint teamTokenTransferAmount = teamTokenAmount.mul(10 ** token.decimals());
918 
919         if (!token.transfer(teamAccount, teamTokenTransferAmount)) revert();
920     }
921 
922     /**
923     * Включает режим возвратов, только в случае если режим возврата еще не установлен и продажи не завершены успехом
924     * Вызвать можно только 1 раз
925     */
926     function enableRefunds() public onlyOwner canEnableRefunds{
927         isRefundingEnabled = true;
928 
929         // Сжигаем остатки на балансе текущего контракта
930         token.burnAllOwnerTokens();
931 
932         internalEnableRefunds();
933     }
934 
935     /**
936      * Покупка токенов, кидаем токены на адрес отправителя
937      */
938     function buy() public payable {
939         internalInvest(msg.sender, msg.value, 0);
940     }
941 
942     /**
943      * Покупка токенов через внешние системы
944      */
945     function externalBuy(address buyerAddress, uint weiAmount, uint txId) external onlyOwner {
946         require(txId != 0);
947 
948         internalInvest(buyerAddress, weiAmount, txId);
949     }
950 
951     /**
952      * Инвесторы могут затребовать возврат средств, только в случае, если текущее состояние - Refunding
953      */
954     function refund() public inState(State.Refunding) {
955         // Получаем значение, которое нам было переведено в эфире
956         uint weiValue = investedAmountOf[msg.sender];
957 
958         require(weiValue != 0);
959 
960         // Кол-во токенов на балансе, берем 2 значения: контракт продаж и контракт токена.
961         // Вернуть wei можем только тогда, когда эти значения совпадают, если не совпадают, значит были какие-то
962         // манипуляции с токенами и такие ситуации будут решаться в индивидуальном порядке, по запросу
963         uint saleContractTokenCount = tokenAmountOf[msg.sender];
964         uint tokenContractTokenCount = token.balanceOf(msg.sender);
965 
966         require(saleContractTokenCount <= tokenContractTokenCount);
967 
968         investedAmountOf[msg.sender] = 0;
969         weiRefunded = weiRefunded.add(weiValue);
970 
971         // Событие генерируется в наследниках
972         internalRefund(msg.sender, weiValue);
973     }
974 
975     /**
976      * Финализатор первой стадии, вызвать может только владелец при условии еще незавершившейся продажи
977      * Если вызван halt, то финализатор вызвать не можем
978      * Вызвать можно только 1 раз
979      */
980     function finalizeFirstStage() public onlyOwner isNotSuccessOver {
981         require(!isFirstStageFinalized);
982 
983         // Сжигаем остатки
984         // Всего можем продать firstStageTotalSupply
985         // Продали - firstStageTokensSold
986         // Все токены на балансе контракта сжигаем - это будет остаток
987 
988         token.burnAllOwnerTokens();
989 
990         // Переходим ко второй стадии
991         // Если повторно вызвать финализатор, то еще раз токены не создадутся, условие внутри
992         mintTokensForSecondStage();
993 
994         isFirstStageFinalized = true;
995     }
996 
997     /**
998      * Финализатор второй стадии, вызвать может только владелец, и только в случае финилизированной первой стадии
999      * и только в случае, если сборы еще не завершились успехом. Если вызван halt, то финализатор вызвать не можем.
1000      * Вызвать можно только 1 раз
1001      */
1002     function finalizeSecondStage() public onlyOwner isNotSuccessOver {
1003         require(isFirstStageFinalized && !isSecondStageFinalized);
1004 
1005         // Сжигаем остатки
1006         // Всего можем продать secondStageTokensForSale
1007         // Продали - secondStageTokensSold
1008         // Разницу нужно сжечь, в любом случае
1009 
1010         // Если достигнут Soft Cap, то считаем вторую стадию успешной
1011         if (isSoftCapGoalReached()){
1012             uint tokenMultiplier = 10 ** token.decimals();
1013 
1014             uint remainingTokens = secondStageTokensForSale.mul(tokenMultiplier).sub(secondStageTokensSold);
1015 
1016             // Если кол-во оставшихся токенов > 0, то сжигаем их
1017             if (remainingTokens > 0){
1018                 token.burnOwnerTokens(remainingTokens);
1019             }
1020 
1021             // Переводим на подготовленные аккаунты: advisorsWalletAddress, marketingWalletAddress, teamWalletAddress
1022             uint advisorsTokenTransferAmount = advisorsTokenAmount.mul(tokenMultiplier);
1023             uint marketingTokenTransferAmount = marketingTokenAmount.mul(tokenMultiplier);
1024             uint supportTokenTransferAmount = supportTokenAmount.mul(tokenMultiplier);
1025 
1026             // Токены для команды заблокированы до даты teamTokensIssueDate и могут быть востребованы, только при вызове спец. функции
1027             // issueTeamTokens
1028 
1029             if (!token.transfer(advisorsAccount, advisorsTokenTransferAmount)) revert();
1030             if (!token.transfer(marketingAccount, marketingTokenTransferAmount)) revert();
1031             if (!token.transfer(supportAccount, supportTokenTransferAmount)) revert();
1032 
1033             // Контракт выполнен!
1034             isSuccessOver = true;
1035 
1036             // Вызываем метод успеха
1037             internalSuccessOver();
1038         }else{
1039             // Если не собрали Soft Cap, то сжигаем все токены на балансе контракта
1040             token.burnAllOwnerTokens();
1041         }
1042 
1043         isSecondStageFinalized = true;
1044     }
1045 
1046     /**
1047      * Позволяет менять владельцу даты стадий
1048      */
1049     function setFirstStageStartsAt(uint time) public onlyOwner {
1050         firstStageStartsAt = time;
1051 
1052         // Вызываем событие
1053         FirstStageStartsAtChanged(firstStageStartsAt);
1054     }
1055 
1056     function setFirstStageEndsAt(uint time) public onlyOwner {
1057         firstStageEndsAt = time;
1058 
1059         // Вызываем событие
1060         FirstStageEndsAtChanged(firstStageEndsAt);
1061     }
1062 
1063     function setSecondStageStartsAt(uint time) public onlyOwner {
1064         secondStageStartsAt = time;
1065 
1066         // Вызываем событие
1067         SecondStageStartsAtChanged(secondStageStartsAt);
1068     }
1069 
1070     function setSecondStageEndsAt(uint time) public onlyOwner {
1071         secondStageEndsAt = time;
1072 
1073         // Вызываем событие
1074         SecondStageEndsAtChanged(secondStageEndsAt);
1075     }
1076 
1077     /**
1078      * Позволяет менять владельцу Cap'ы
1079      */
1080     function setSoftCapInCents(uint value) public onlyOwner {
1081         require(value > 0);
1082 
1083         softCapFundingGoalInCents = value;
1084 
1085         // Вызываем событие
1086         SoftCapChanged(softCapFundingGoalInCents);
1087     }
1088 
1089     function setHardCapInCents(uint value) public onlyOwner {
1090         require(value > 0);
1091 
1092         hardCapFundingGoalInCents = value;
1093 
1094         // Вызываем событие
1095         HardCapChanged(hardCapFundingGoalInCents);
1096     }
1097 
1098     /**
1099      * Проверка сбора Soft Cap'а
1100      */
1101     function isSoftCapGoalReached() public constant returns (bool) {
1102         // Проверка по текущему курсу в центах, считает от общих продаж
1103         return getWeiInCents(weiRaised) >= softCapFundingGoalInCents;
1104     }
1105 
1106     /**
1107      * Проверка сбора Hard Cap'а
1108      */
1109     function isHardCapGoalReached() public constant returns (bool) {
1110         // Проверка по текущему курсу в центах, считает от общих продаж
1111         return getWeiInCents(weiRaised) >= hardCapFundingGoalInCents;
1112     }
1113 
1114     /**
1115      * Возвращает кол-во нераспроданных токенов, которые можно продать, в зависимости от стадии
1116      */
1117     function getTokensLeftForSale(State forState) public constant returns (uint) {
1118         // Кол-во токенов, которое адрес контракта можеть снять у owner'а и есть кол-во оставшихся токенов, из этой суммы нужно вычесть кол-во которое не участвует в продаже
1119         uint tokenBalance = token.balanceOf(address(this));
1120         uint tokensReserve = 0;
1121         if (forState == State.SecondStageFunding) tokensReserve = secondStageReserve.mul(10 ** token.decimals());
1122 
1123         if (tokenBalance <= tokensReserve){
1124             return 0;
1125         }
1126 
1127         return tokenBalance.sub(tokensReserve);
1128     }
1129 
1130     /**
1131      * Получаем стейт
1132      *
1133      * Не пишем в переменную, чтобы не было возможности поменять извне, только вызов функции может отразить текущее состояние
1134      * См. граф состояний
1135      */
1136     function getState() public constant returns (State) {
1137         // Контракт выполнен
1138         if (isSuccessOver) return State.Success;
1139 
1140         // Контракт находится в режиме возврата
1141         if (isRefundingEnabled) return State.Refunding;
1142 
1143         // Контракт еще не начал действовать
1144         if (block.timestamp < firstStageStartsAt) return State.PreFunding;
1145 
1146         //Если первая стадия - не финализирована
1147         if (!isFirstStageFinalized){
1148             // Флаг того, что текущая дата находится в интервале первой стадии
1149             bool isFirstStageTime = block.timestamp >= firstStageStartsAt && block.timestamp <= firstStageEndsAt;
1150 
1151             // Если идет первая стадия
1152             if (isFirstStageTime) return State.FirstStageFunding;
1153             // Иначе первый этап - закончен
1154             else return State.FirstStageEnd;
1155 
1156         } else {
1157 
1158             // Если первая стадия финализирована и текущее время блок чейна меньше начала второй стадии, то это означает, что первая стадия - окончена
1159             if(block.timestamp < secondStageStartsAt)return State.FirstStageEnd;
1160 
1161             // Флаг того, что текущая дата находится в интервале второй стадии
1162             bool isSecondStageTime = block.timestamp >= secondStageStartsAt && block.timestamp <= secondStageEndsAt;
1163 
1164             // Первая стадия финализирована, вторая - финализирована
1165             if (isSecondStageFinalized){
1166 
1167                 // Если набрали Soft Cap при условии финализации второй сдадии - это успешное закрытие продаж
1168                 if (isSoftCapGoalReached())return State.Success;
1169                 // Собрать Soft Cap не удалось, текущее состояние - провал
1170                 else return State.Failure;
1171 
1172             }else{
1173 
1174                 // Вторая стадия - не финализирована
1175                 if (isSecondStageTime)return State.SecondStageFunding;
1176                 // Вторая стадия - закончилась
1177                 else return State.SecondStageEnd;
1178 
1179             }
1180         }
1181     }
1182 
1183    /**
1184     * Модификаторы
1185     */
1186 
1187     /** Только, если текущее состояние соответсвует состоянию  */
1188     modifier inState(State state) {
1189         require(getState() == state);
1190 
1191         _;
1192     }
1193 
1194     /** Только, если текущее состояние - продажи: первая или вторая стадия */
1195     modifier inFirstOrSecondFundingState() {
1196         State curState = getState();
1197         require(curState == State.FirstStageFunding || curState == State.SecondStageFunding);
1198 
1199         _;
1200     }
1201 
1202     /** Только, если не достигнут Hard Cap */
1203     modifier notHardCapReached(){
1204         require(!isHardCapGoalReached());
1205 
1206         _;
1207     }
1208 
1209     /** Только, если текущее состояние - продажи первой стадии или первая стадия закончилась */
1210     modifier isFirstStageFundingOrEnd() {
1211         State curState = getState();
1212         require(curState == State.FirstStageFunding || curState == State.FirstStageEnd);
1213 
1214         _;
1215     }
1216 
1217     /** Только, если контракт не финализирован */
1218     modifier isNotSuccessOver() {
1219         require(!isSuccessOver);
1220 
1221         _;
1222     }
1223 
1224     /** Только, если идет вторая стадия или вторая стадия завершилась */
1225     modifier isSecondStageFundingOrEnd() {
1226         State curState = getState();
1227         require(curState == State.SecondStageFunding || curState == State.SecondStageEnd);
1228 
1229         _;
1230     }
1231 
1232     /** Только, если еще не включен режим возврата и продажи не завершены успехом */
1233     modifier canEnableRefunds(){
1234         require(!isRefundingEnabled && getState() != State.Success);
1235 
1236         _;
1237     }
1238 
1239     /** Только, если продажи не завершены успехом */
1240     modifier canSetDestinationMultisigWallet(){
1241         require(getState() != State.Success);
1242 
1243         _;
1244     }
1245 }
1246 
1247 /**
1248  * @title Math
1249  * @dev Assorted math operations
1250  */
1251 
1252 library Math {
1253   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
1254     return a >= b ? a : b;
1255   }
1256 
1257   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
1258     return a < b ? a : b;
1259   }
1260 
1261   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
1262     return a >= b ? a : b;
1263   }
1264 
1265   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
1266     return a < b ? a : b;
1267   }
1268 }
1269 
1270 /**
1271  * Шаблон класса хранилища средств, которое используется в контракте продаж
1272  * Поддерживает возврат средств, а такте перевод средств на кошелек, в случае успешного проведения продаж
1273  */
1274 contract FundsVault is Ownable, ValidationUtil {
1275     using SafeMath for uint;
1276     using Math for uint;
1277 
1278     enum State {Active, Refunding, Closed}
1279 
1280     mapping (address => uint256) public deposited;
1281 
1282     address public wallet;
1283 
1284     State public state;
1285 
1286     event Closed();
1287 
1288     event RefundsEnabled();
1289 
1290     event Refunded(address indexed beneficiary, uint256 weiAmount);
1291 
1292     /**
1293      * Указываем на какой кошелек будут потом переведены собранные средства, в случае, если будет вызвана функция close()
1294      * Поддерживает возврат средств, а такте перевод средств на кошелек, в случае успешного проведения продаж
1295      */
1296     function FundsVault(address _wallet) {
1297         requireNotEmptyAddress(_wallet);
1298 
1299         wallet = _wallet;
1300 
1301         state = State.Active;
1302     }
1303 
1304     /**
1305      * Положить депозит в хранилище
1306      */
1307     function deposit(address investor) public payable onlyOwner inState(State.Active) {
1308         deposited[investor] = deposited[investor].add(msg.value);
1309     }
1310 
1311     /**
1312      * Перевод собранных средств на указанный кошелек
1313      */
1314     function close() public onlyOwner inState(State.Active) {
1315         state = State.Closed;
1316 
1317         Closed();
1318 
1319         wallet.transfer(this.balance);
1320     }
1321 
1322     /**
1323      * Установливаем кошелек
1324      */
1325     function setWallet(address newWalletAddress) public onlyOwner inState(State.Active) {
1326         wallet = newWalletAddress;
1327     }
1328 
1329     /**
1330      * Установить режим возврата денег
1331      */
1332     function enableRefunds() public onlyOwner inState(State.Active) {
1333         state = State.Refunding;
1334 
1335         RefundsEnabled();
1336     }
1337 
1338     /**
1339      * Функция возврата средств
1340      */
1341     function refund(address investor, uint weiAmount) public onlyOwner inState(State.Refunding){
1342         uint256 depositedValue = weiAmount.min256(deposited[investor]);
1343         deposited[investor] = 0;
1344         investor.transfer(depositedValue);
1345 
1346         Refunded(investor, depositedValue);
1347     }
1348 
1349     /** Только, если текущее состояние соответсвует состоянию  */
1350     modifier inState(State _state) {
1351         require(state == _state);
1352 
1353         _;
1354     }
1355 
1356 }
1357 
1358 /**
1359 * Контракт продажи
1360 * Возврат средств поддержмвается только тем, кто купил токены через функцию internalInvest
1361 * Таким образом, если инвесторы будут обмениваться токенами, то вернуть можно будет только тем, у кого в контракте продаж
1362 * такая же сумма токенов, как и в контракте токена, в противном случае переведенный эфир остается навсегда в системе и не может быть выведен
1363 */
1364 contract RefundableAllocatedCappedCrowdsale is AllocatedCappedCrowdsale {
1365 
1366     /**
1367     * Хранилище, куда будут собираться средства, делается для того, чтобы гарантировать возвраты
1368     */
1369     FundsVault public fundsVault;
1370 
1371     /** Мапа адрес инвестора - был ли совершен возврат среств */
1372     mapping (address => bool) public refundedInvestors;
1373 
1374     function RefundableAllocatedCappedCrowdsale(uint _currentEtherRateInCents, address _token, address _destinationMultisigWallet, uint _firstStageStartsAt, uint _firstStageEndsAt, uint _secondStageStartsAt, uint _secondStageEndsAt, address _advisorsAccount, address _marketingAccount, address _supportAccount, address _teamAccount, uint _teamTokensIssueDate) AllocatedCappedCrowdsale(_currentEtherRateInCents, _token, _destinationMultisigWallet, _firstStageStartsAt, _firstStageEndsAt, _secondStageStartsAt, _secondStageEndsAt, _advisorsAccount, _marketingAccount, _supportAccount, _teamAccount, _teamTokensIssueDate) {
1375         // Создаем от контракта продаж новое хранилище, доступ к нему имеет только контракт продаж
1376         // При успешном завершении продаж, все собранные средства поступят на _destinationMultisigWallet
1377         // В противном случае могут быть переведены обратно инвесторам
1378         fundsVault = new FundsVault(_destinationMultisigWallet);
1379 
1380     }
1381 
1382     /** Устанавливаем новый кошелек для финального перевода
1383     */
1384     function internalSetDestinationMultisigWallet(address destinationAddress) internal{
1385         fundsVault.setWallet(destinationAddress);
1386 
1387         super.internalSetDestinationMultisigWallet(destinationAddress);
1388     }
1389 
1390     /** Финализация второго этапа
1391     */
1392     function internalSuccessOver() internal {
1393         // Успешно закрываем хранилище средств и переводим эфир на указанный кошелек
1394         fundsVault.close();
1395 
1396         super.internalSuccessOver();
1397     }
1398 
1399     /** Переопределение функции принятия допозита на счет, в данном случае, идти будет через vault
1400     */
1401     function internalDeposit(address receiver, uint weiAmount) internal{
1402         // Шлем на кошелёк эфир
1403         fundsVault.deposit.value(weiAmount)(msg.sender);
1404     }
1405 
1406     /** Переопределение функции включения состояния возврата
1407     */
1408     function internalEnableRefunds() internal{
1409         super.internalEnableRefunds();
1410 
1411         fundsVault.enableRefunds();
1412     }
1413 
1414     /** Переопределение функции возврата, возврат можно сделать только раз
1415     */
1416     function internalRefund(address receiver, uint weiAmount) internal{
1417         // Делаем возврат
1418         // Поддерживаем только 1 возврат
1419 
1420         if (refundedInvestors[receiver]) revert();
1421 
1422         fundsVault.refund(receiver, weiAmount);
1423 
1424         refundedInvestors[receiver] = true;
1425     }
1426 
1427 }