1 pragma solidity ^0.4.11;
2 
3 
4 
5 
6 /**
7  * @title Math
8  * @dev Assorted math operations y
9  */
10 library Math {
11   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
12     return a >= b ? a : b;
13   }
14 
15   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
16     return a < b ? a : b;
17   }
18 
19   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
20     return a >= b ? a : b;
21   }
22 
23   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
24     return a < b ? a : b;
25   }
26 }
27 
28 
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/179
68  */
69 contract ERC20Basic {
70   uint256 public totalSupply;
71 
72   function balanceOf(address who) constant public returns (uint256);
73 
74   function transfer(address to, uint256 value) public returns (bool);
75 
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 
80 
81 
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) constant public returns (uint256);
89 
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91 
92   function approve(address spender, uint256 value) public returns (bool);
93 
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 
99 
100 
101 contract ERC223 {
102   uint public totalSupply;
103   function balanceOf(address who) constant public returns (uint);
104 
105   function name() constant public returns (string _name);
106   function symbol() constant public returns (string _symbol);
107   function decimals() constant public returns (uint8 _decimals);
108   function totalSupply() constant public returns (uint256 _supply);
109 
110   function transfer(address to, uint value) public returns (bool ok);
111   function transfer(address to, uint value, bytes data) public returns (bool ok);
112   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
113 }
114 
115 
116 
117 
118 
119 /*
120 * Contract that is working with ERC223 tokens
121 */
122 
123 contract ContractReceiver {
124 
125   string public functionName;
126   address public sender;
127   uint public value;
128   bytes public data;
129 
130   function tokenFallback(address _from, uint _value, bytes _data) public {
131 
132     sender = _from;
133     value = _value;
134     data = _data;
135     functionName = "tokenFallback";
136     //uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
137     //tkn.sig = bytes4(u);
138 
139     /* tkn variable is analogue of msg variable of Ether transaction
140     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
141     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
142     *  tkn.data is data of token transaction   (analogue of msg.data)
143     *  tkn.sig is 4 bytes signature of function
144     *  if data of token transaction is a function execution
145     */
146   }
147 
148   function customFallback(address _from, uint _value, bytes _data) public {
149     tokenFallback(_from, _value, _data);
150     functionName = "customFallback";
151   }
152 }
153 
154 
155 
156 
157 
158 
159 
160 contract RobomedIco is ERC223, ERC20 {
161 
162     using SafeMath for uint256;
163 
164     string public name = "RobomedToken";
165 
166     string public symbol = "RBM";
167 
168     uint8 public decimals = 18;
169 
170     //addresses
171 
172     /*
173      * ADDR_OWNER - владелец контракта - распределяет вип токены, начисляет баунти и team, осуществляет переход по стадиям
174      */
175     address public constant ADDR_OWNER = 0x21F6C4D926B705aD244Ec33271559dA8c562400F;
176 
177     /*
178     * ADDR_WITHDRAWAL1, ADDR_WITHDRAWAL2 - участники контракта, которые совместно выводят eth после наступления PostIco
179     */
180     address public constant ADDR_WITHDRAWAL1 = 0x0dD97e6259a7de196461B36B028456a97e3268bE;
181 
182     /*
183     * ADDR_WITHDRAWAL1, ADDR_WITHDRAWAL2 - участники контракта, которые совместно выводят eth после наступления PostIco
184     */
185     address public constant ADDR_WITHDRAWAL2 = 0x8c5B02144F7664D37FDfd4a2f90148d08A04838D;
186 
187     /**
188     * Адрес на который кладуться токены для раздачи по Baunty
189     */
190     address public constant ADDR_BOUNTY_TOKENS_ACCOUNT = 0x6542393623Db0D7F27fDEd83e6feDBD767BfF9b4;
191 
192     /**
193     * Адрес на который кладуться токены для раздачи Team
194     */
195     address public constant ADDR_TEAM_TOKENS_ACCOUNT = 0x28c6bCAB2204CEd29677fEE6607E872E3c40d783;
196 
197 
198 
199     //VipPlacement constants
200 
201 
202     /**
203      * Количество токенов для стадии VipPlacement
204     */
205     uint256 public constant INITIAL_COINS_FOR_VIPPLACEMENT =507937500 * 10 ** 18;
206 
207     /**
208      * Длительность стадии VipPlacement
209     */
210     uint256 public constant DURATION_VIPPLACEMENT = 1 seconds;// 1 minutes;//  1 days;
211 
212     //end VipPlacement constants
213 
214     //PreSale constants
215 
216     /**
217      * Количество токенов для стадии PreSale
218     */
219     uint256 public constant EMISSION_FOR_PRESALE = 76212500 * 10 ** 18;
220 
221     /**
222      * Длительность стадии PreSale
223     */
224     uint256 public constant DURATION_PRESALE = 1 days;//2 minutes;//1 days;
225 
226     /**
227      * Курс стадии PreSale
228     */
229     uint256 public constant RATE_PRESALE = 2702;
230 
231     //end PreSale constants
232 
233     //SaleStage1 constants
234 
235     /**
236      * Общая длительность стадий Sale с SaleStage1 по SaleStage7 включительно
237     */
238     uint256 public constant DURATION_SALESTAGES = 10 days; //2 minutes;//30 days;
239 
240     /**
241      * Курс стадии SaleStage1
242     */
243     uint256 public constant RATE_SALESTAGE1 = 2536;
244 
245     /**
246      * Эмиссия токенов для стадии SaleStage1
247     */
248     uint256 public constant EMISSION_FOR_SALESTAGE1 = 40835000 * 10 ** 18;
249 
250     //end SaleStage1 constants
251 
252     //SaleStage2 constants
253 
254     /**
255      * Курс стадии SaleStage2
256     */
257     uint256 public constant RATE_SALESTAGE2 = 2473;
258 
259     /**
260     * Эмиссия токенов для стадии SaleStage2
261     */
262     uint256 public constant EMISSION_FOR_SALESTAGE2 = 40835000 * 10 ** 18;
263 
264     //end SaleStage2 constants
265 
266     //SaleStage3 constants
267 
268     /**
269      * Курс стадии SaleStage3
270     */
271     uint256 public constant RATE_SALESTAGE3 = 2390;
272 
273     /**
274     * Эмиссия токенов для стадии SaleStage3
275     */
276     uint256 public constant EMISSION_FOR_SALESTAGE3 = 40835000 * 10 ** 18;
277     //end SaleStage3 constants
278 
279     //SaleStage4 constants
280 
281     /**
282      * Курс стадии SaleStage4
283     */
284     uint256 public constant RATE_SALESTAGE4 = 2349;
285 
286     /**
287     * Эмиссия токенов для стадии SaleStage4
288     */
289     uint256 public constant EMISSION_FOR_SALESTAGE4 = 40835000 * 10 ** 18;
290 
291     //end SaleStage4 constants
292 
293 
294     //SaleStage5 constants
295 
296     /**
297      * Курс стадии SaleStage5
298     */
299     uint256 public constant RATE_SALESTAGE5 = 2286;
300 
301     /**
302     * Эмиссия токенов для стадии SaleStage5
303     */
304     uint256 public constant EMISSION_FOR_SALESTAGE5 = 40835000 * 10 ** 18;
305 
306     //end SaleStage5 constants
307 
308 
309 
310     //SaleStage6 constants
311 
312     /**
313      * Курс стадии SaleStage6
314     */
315     uint256 public constant RATE_SALESTAGE6 = 2224;
316 
317     /**
318     * Эмиссия токенов для стадии SaleStage6
319     */
320     uint256 public constant EMISSION_FOR_SALESTAGE6 = 40835000 * 10 ** 18;
321 
322     //end SaleStage6 constants
323 
324 
325     //SaleStage7 constants
326 
327     /**
328      * Курс стадии SaleStage7
329     */
330     uint256 public constant RATE_SALESTAGE7 = 2182;
331 
332     /**
333     * Эмиссия токенов для стадии SaleStage7
334     */
335     uint256 public constant EMISSION_FOR_SALESTAGE7 = 40835000 * 10 ** 18;
336 
337     //end SaleStage7 constants
338 
339 
340     //SaleStageLast constants
341 
342     /**
343      * Длительность стадии SaleStageLast
344     */
345     uint256 public constant DURATION_SALESTAGELAST = 1 days;// 20 minutes;//10 days;
346 
347     /**
348      * Курс стадии SaleStageLast
349     */
350     uint256 public constant RATE_SALESTAGELAST = 2078;
351 
352     /**
353     * Эмиссия токенов для стадии SaleStageLast
354     */
355     uint256 public constant EMISSION_FOR_SALESTAGELAST = 302505000 * 10 ** 18;
356     //end SaleStageLast constants
357 
358     //PostIco constants
359 
360     /**
361      * Длительность периода на который нельзя использовать team токены, полученные при распределении
362     */
363     uint256 public constant DURATION_NONUSETEAM = 180 days;//10 days;
364 
365     /**
366      * Длительность периода на который нельзя восстановить нераспроданные unsoldTokens токены,
367      * отсчитывается после наступления PostIco
368     */
369     uint256 public constant DURATION_BEFORE_RESTORE_UNSOLD = 270 days;
370 
371     //end PostIco constants
372 
373     /**
374     * Эмиссия токенов для BOUNTY
375     */
376     uint256 public constant EMISSION_FOR_BOUNTY = 83750000 * 10 ** 18;
377 
378     /**
379     * Эмиссия токенов для TEAM
380     */
381     uint256 public constant EMISSION_FOR_TEAM = 418750000 * 10 ** 18;
382 
383     /**
384     * Кол-во токенов, которое будет начислено каждому участнику команды
385     */
386     uint256 public constant TEAM_MEMBER_VAL = 2000000 * 10 ** 18;
387 
388     /**
389       * Перечисление состояний контракта
390       */
391     enum IcoStates {
392 
393     /**
394      * Состояние для которого выполняется заданная эмиссия на кошелёк владельца,
395      * далее все выпущенные токены распределяются владельцем из своего кошелька на произвольные кошельки, распределение может происходить всегда.
396      * Владелец не может распределить из своего кошелька, количество превышающее INITIAL_COINS_FOR_VIPPLACEMENT до прекращения ICO
397      * Состояние завершается по наступлению времени endDateOfVipPlacement
398      */
399     VipPlacement,
400 
401     /**
402        * Состояние для которого выполняется заданная эмиссия в свободный пул freeMoney.
403        * далее все выпущенные свободные токены покупаются всеми желающими вплоть до endDateOfPreSale,
404        * не выкупленные токены будут уничтожены
405        * Состояние завершается по наступлению времени endDateOfPreSale.
406        * С момента наступления PreSale покупка токенов становиться разрешена
407        */
408     PreSale,
409 
410     /**
411      * Состояние представляющее из себя подстадию продаж,
412      * при наступлении данного состояния выпускается заданное количество токенов,
413      * количество свободных токенов приравнивается к этой эмиссии
414      * Состояние завершается при выкупе всех свободных токенов или по наступлению времени startDateOfSaleStageLast.
415      * Если выкупаются все свободные токены - переход осуществляется на следующую стадию -
416      * например [с SaleStage1 на SaleStage2] или [с SaleStage2 на SaleStage3]
417      * Если наступает время startDateOfSaleStageLast, то независимо от выкупленных токенов переходим на стостояние SaleStageLast
418     */
419     SaleStage1,
420 
421     /**
422      * Аналогично SaleStage1
423      */
424     SaleStage2,
425 
426     /**
427      * Аналогично SaleStage1
428      */
429     SaleStage3,
430 
431     /**
432      * Аналогично SaleStage1
433      */
434     SaleStage4,
435 
436     /**
437      * Аналогично SaleStage1
438      */
439     SaleStage5,
440 
441     /**
442      * Аналогично SaleStage1
443      */
444     SaleStage6,
445 
446     /**
447      * Аналогично SaleStage1
448      */
449     SaleStage7,
450 
451     /**
452      * Состояние представляющее из себя последнюю подстадию продаж,
453      * при наступлении данного состояния выпускается заданное количество токенов,
454      * количество свободных токенов приравнивается к этой эмиссии,
455      * плюс остатки нераспроданных токенов со стадий SaleStage1,SaleStage2,SaleStage3,SaleStage4,SaleStage5,SaleStage6,SaleStage7
456      * Состояние завершается по наступлению времени endDateOfSaleStageLast.
457     */
458     SaleStageLast,
459 
460     /**
461      * Состояние наступающее после завершения Ico,
462      * при наступлении данного состояния свободные токены сохраняются в unsoldTokens,
463      * также происходит бонусное распределение дополнительных токенов Bounty и Team,
464      * С момента наступления PostIco покупка токенов невозможна
465     */
466     PostIco
467 
468     }
469 
470 
471     /**
472     * Здесь храним балансы токенов
473     */
474     mapping (address => uint256)  balances;
475 
476     mapping (address => mapping (address => uint256))  allowed;
477 
478     /**
479     * Здесь храним начисленные премиальные токены, могут быть выведены на кошелёк начиная с даты startDateOfUseTeamTokens
480     */
481     mapping (address => uint256) teamBalances;
482 
483     /**
484     * Владелец контракта - распределяет вип токены, начисляет баунти и team, осуществляет переход по стадиям,
485     */
486     address public owner;
487 
488 
489     /**
490     * Участник контракта -  выводит eth после наступления PostIco, совместно с withdrawal2
491     */
492     address public withdrawal1;
493 
494     /**
495     * Участник контракта - только при его участии может быть выведены eth после наступления PostIco, совместно с withdrawal1
496     */
497     address public withdrawal2;
498 
499 
500 
501 
502     /**
503     * Адрес на счёте которого находятся нераспределённые bounty токены
504     */
505     address public bountyTokensAccount;
506 
507     /**
508     * Адрес на счёте которого находятся нераспределённые team токены
509     */
510     address public teamTokensAccount;
511 
512     /**
513     *Адрес на который инициирован вывод eth (владельцем)
514     */
515     address public withdrawalTo;
516 
517     /**
518     * Количество eth который предполагается выводить на адрес withdrawalTo
519     */
520     uint256 public withdrawalValue;
521 
522     /**
523      * Количество нераспределённых токенов bounty
524      * */
525     uint256 public bountyTokensNotDistributed;
526 
527     /**
528      * Количество нераспределённых токенов team
529      * */
530     uint256 public teamTokensNotDistributed;
531 
532     /**
533       * Текущее состояние
534       */
535     IcoStates public currentState;
536 
537     /**
538     * Количество собранного эфира
539     */
540     uint256 public totalBalance;
541 
542     /**
543     * Количество свободных токенов (никто ими не владеет)
544     */
545     uint256 public freeMoney = 0;
546 
547     /**
548      * Общее количество выпущенных токенов
549      * */
550     uint256 public totalSupply = 0;
551 
552     /**
553      * Общее количество купленных токенов
554      * */
555     uint256 public totalBought = 0;
556 
557 
558 
559     /**
560      * Количество не распределённых токенов от стадии VipPlacement
561      */
562     uint256 public vipPlacementNotDistributed;
563 
564     /**
565      * Дата окончания стадии VipPlacement
566     */
567     uint256 public endDateOfVipPlacement;
568 
569     /**
570      * Дата окончания стадии PreSale
571     */
572     uint256 public endDateOfPreSale = 0;
573 
574     /**
575      * Дата начала стадии SaleStageLast
576     */
577     uint256 public startDateOfSaleStageLast;
578 
579     /**
580      * Дата окончания стадии SaleStageLast
581     */
582     uint256 public endDateOfSaleStageLast = 0;
583 
584 
585     /**
586      * Остаток нераспроданных токенов для состояний с SaleStage1 по SaleStage7, которые переходят в свободные на момент наступления SaleStageLast
587      */
588     uint256 public remForSalesBeforeStageLast = 0;
589 
590     /**
591     * Дата, начиная с которой можно получить team токены непосредственно на кошелёк
592     */
593     uint256 public startDateOfUseTeamTokens = 0;
594 
595     /**
596     * Дата, начиная с которой можно восстановить-перевести нераспроданные токены unsoldTokens
597     */
598     uint256 public startDateOfRestoreUnsoldTokens = 0;
599 
600     /**
601     * Количество нераспроданных токенов на момент наступления PostIco
602     */
603     uint256 public unsoldTokens = 0;
604 
605     /**
606      * How many token units a buyer gets per wei
607      */
608     uint256 public rate = 0;
609 
610 
611     /**
612      * @dev Throws if called by any account other than the owner.
613      */
614     modifier onlyOwner() {
615         require(msg.sender == owner);
616         _;
617     }
618 
619     /**
620      * @dev Throws if called by any account other than the withdrawal1.
621      */
622     modifier onlyWithdrawal1() {
623         require(msg.sender == withdrawal1);
624         _;
625     }
626 
627     /**
628      * @dev Throws if called by any account other than the withdrawal2.
629      */
630     modifier onlyWithdrawal2() {
631         require(msg.sender == withdrawal2);
632         _;
633     }
634 
635     /**
636      * Модификатор позволяющий выполнять вызов,
637      * только если состояние PostIco или выше
638      */
639     modifier afterIco() {
640         require(uint(currentState) >= uint(IcoStates.PostIco));
641         _;
642     }
643 
644 
645     /**
646     * Модификатор проверяющий допустимость операций transfer
647     */
648     modifier checkForTransfer(address _from, address _to, uint256 _value)  {
649 
650         //проверяем размер перевода
651         require(_value > 0);
652 
653         //проверяем кошелёк назначения
654         require(_to != 0x0 && _to != _from);
655 
656         //на стадиях перед ico переводить может только владелец
657         require(currentState == IcoStates.PostIco || _from == owner);
658 
659         //операции на bounty и team не допустимы до окончания ico
660         require(currentState == IcoStates.PostIco || (_to != bountyTokensAccount && _to != teamTokensAccount));
661 
662         _;
663     }
664 
665 
666 
667     /**
668      * Событие изменения состояния контракта
669      */
670     event StateChanged(IcoStates state);
671 
672 
673     /**
674      * Событие покупки токенов
675      */
676     event Buy(address beneficiary, uint256 boughtTokens, uint256 ethValue);
677 
678     /**
679     * @dev Конструктор
680     */
681     function RobomedIco() public {
682 
683         //проверяем, что все указанные адреса не равны 0, также они отличаются от создающего контракт
684         //по сути контракт создаёт некое 3-ее лицо не имеющее в дальнейшем ни каких особенных прав
685         //так же действует условие что все перичисленные адреса разные (нельзя быть одновременно владельцем и кошельком для токенов - например)
686         require(ADDR_OWNER != 0x0 && ADDR_OWNER != msg.sender);
687         require(ADDR_WITHDRAWAL1 != 0x0 && ADDR_WITHDRAWAL1 != msg.sender);
688         require(ADDR_WITHDRAWAL2 != 0x0 && ADDR_WITHDRAWAL2 != msg.sender);
689         require(ADDR_BOUNTY_TOKENS_ACCOUNT != 0x0 && ADDR_BOUNTY_TOKENS_ACCOUNT != msg.sender);
690         require(ADDR_TEAM_TOKENS_ACCOUNT != 0x0 && ADDR_TEAM_TOKENS_ACCOUNT != msg.sender);
691 
692         require(ADDR_BOUNTY_TOKENS_ACCOUNT != ADDR_TEAM_TOKENS_ACCOUNT);
693         require(ADDR_OWNER != ADDR_TEAM_TOKENS_ACCOUNT);
694         require(ADDR_OWNER != ADDR_BOUNTY_TOKENS_ACCOUNT);
695         require(ADDR_WITHDRAWAL1 != ADDR_OWNER);
696         require(ADDR_WITHDRAWAL1 != ADDR_BOUNTY_TOKENS_ACCOUNT);
697         require(ADDR_WITHDRAWAL1 != ADDR_TEAM_TOKENS_ACCOUNT);
698         require(ADDR_WITHDRAWAL2 != ADDR_OWNER);
699         require(ADDR_WITHDRAWAL2 != ADDR_BOUNTY_TOKENS_ACCOUNT);
700         require(ADDR_WITHDRAWAL2 != ADDR_TEAM_TOKENS_ACCOUNT);
701         require(ADDR_WITHDRAWAL2 != ADDR_WITHDRAWAL1);
702 
703         //выставляем адреса
704         //test
705         owner = ADDR_OWNER;
706         withdrawal1 = ADDR_WITHDRAWAL1;
707         withdrawal2 = ADDR_WITHDRAWAL2;
708         bountyTokensAccount = ADDR_BOUNTY_TOKENS_ACCOUNT;
709         teamTokensAccount = ADDR_TEAM_TOKENS_ACCOUNT;
710 
711         //устанавливаем начальное значение на предопределённых аккаунтах
712         balances[owner] = INITIAL_COINS_FOR_VIPPLACEMENT;
713         balances[bountyTokensAccount] = EMISSION_FOR_BOUNTY;
714         balances[teamTokensAccount] = EMISSION_FOR_TEAM;
715 
716         //нераспределённые токены
717         bountyTokensNotDistributed = EMISSION_FOR_BOUNTY;
718         teamTokensNotDistributed = EMISSION_FOR_TEAM;
719         vipPlacementNotDistributed = INITIAL_COINS_FOR_VIPPLACEMENT;
720 
721         currentState = IcoStates.VipPlacement;
722         totalSupply = INITIAL_COINS_FOR_VIPPLACEMENT + EMISSION_FOR_BOUNTY + EMISSION_FOR_TEAM;
723 
724         endDateOfVipPlacement = now.add(DURATION_VIPPLACEMENT);
725         remForSalesBeforeStageLast = 0;
726 
727 
728         //set team for members
729         owner = msg.sender;
730         //ildar
731         transferTeam(0xa19DC4c158169bC45b17594d3F15e4dCb36CC3A3, TEAM_MEMBER_VAL);
732         //vova
733         transferTeam(0xdf66490Fe9F2ada51967F71d6B5e26A9D77065ED, TEAM_MEMBER_VAL);
734         //kirill
735         transferTeam(0xf0215C6A553AD8E155Da69B2657BeaBC51d187c5, TEAM_MEMBER_VAL);
736         //evg
737         transferTeam(0x6c1666d388302385AE5c62993824967a097F14bC, TEAM_MEMBER_VAL);
738         //igor
739         transferTeam(0x82D550dC74f8B70B202aB5b63DAbe75E6F00fb36, TEAM_MEMBER_VAL);
740         owner = ADDR_OWNER;
741     }
742 
743     /**
744     * Function to access name of token .
745     */
746     function name() public constant returns (string) {
747         return name;
748     }
749 
750     /**
751     * Function to access symbol of token .
752     */
753     function symbol() public constant returns (string) {
754         return symbol;
755     }
756 
757     /**
758     * Function to access decimals of token .
759     */
760     function decimals() public constant returns (uint8) {
761         return decimals;
762     }
763 
764 
765     /**
766     * Function to access total supply of tokens .
767     */
768     function totalSupply() public constant returns (uint256) {
769         return totalSupply;
770     }
771 
772     /**
773     * Метод получающий количество начисленных премиальных токенов
774     */
775     function teamBalanceOf(address _owner) public constant returns (uint256){
776         return teamBalances[_owner];
777     }
778 
779     /**
780     * Метод зачисляющий предварительно распределённые team токены на кошелёк
781     */
782     function accrueTeamTokens() public afterIco {
783         //зачисление возможно только после определённой даты
784         require(startDateOfUseTeamTokens <= now);
785 
786         //добавляем в общее количество выпущенных
787         totalSupply = totalSupply.add(teamBalances[msg.sender]);
788 
789         //зачисляем на кошелёк и обнуляем не начисленные
790         balances[msg.sender] = balances[msg.sender].add(teamBalances[msg.sender]);
791         teamBalances[msg.sender] = 0;
792     }
793 
794     /**
795     * Метод проверяющий возможность восстановления нераспроданных токенов
796     */
797     function canRestoreUnsoldTokens() public constant returns (bool) {
798         //восстановление возможно только после ico
799         if (currentState != IcoStates.PostIco) return false;
800 
801         //восстановление возможно только после определённой даты
802         if (startDateOfRestoreUnsoldTokens > now) return false;
803 
804         //восстановление возможно только если есть что восстанавливать
805         if (unsoldTokens == 0) return false;
806 
807         return true;
808     }
809 
810     /**
811     * Метод выполняющий восстановление нераспроданных токенов
812     */
813     function restoreUnsoldTokens(address _to) public onlyOwner {
814         require(_to != 0x0);
815         require(canRestoreUnsoldTokens());
816 
817         balances[_to] = balances[_to].add(unsoldTokens);
818         totalSupply = totalSupply.add(unsoldTokens);
819         unsoldTokens = 0;
820     }
821 
822     /**
823      * Метод переводящий контракт в следующее доступное состояние,
824      * Для выяснения возможности перехода можно использовать метод canGotoState
825     */
826     function gotoNextState() public onlyOwner returns (bool)  {
827 
828         if (gotoPreSale() || gotoSaleStage1() || gotoSaleStageLast() || gotoPostIco()) {
829             return true;
830         }
831         return false;
832     }
833 
834 
835     /**
836     * Инициация снятия эфира на указанный кошелёк
837     */
838     function initWithdrawal(address _to, uint256 _value) public afterIco onlyWithdrawal1 {
839         withdrawalTo = _to;
840         withdrawalValue = _value;
841     }
842 
843     /**
844     * Подтверждение снятия эфира на указанный кошелёк
845     */
846     function approveWithdrawal(address _to, uint256 _value) public afterIco onlyWithdrawal2 {
847         require(_to != 0x0 && _value > 0);
848         require(_to == withdrawalTo);
849         require(_value == withdrawalValue);
850 
851         totalBalance = totalBalance.sub(_value);
852         withdrawalTo.transfer(_value);
853 
854         withdrawalTo = 0x0;
855         withdrawalValue = 0;
856     }
857 
858 
859 
860     /**
861      * Метод проверяющий возможность перехода в указанное состояние
862      */
863     function canGotoState(IcoStates toState) public constant returns (bool){
864         if (toState == IcoStates.PreSale) {
865             return (currentState == IcoStates.VipPlacement && endDateOfVipPlacement <= now);
866         }
867         else if (toState == IcoStates.SaleStage1) {
868             return (currentState == IcoStates.PreSale && endDateOfPreSale <= now);
869         }
870         else if (toState == IcoStates.SaleStage2) {
871             return (currentState == IcoStates.SaleStage1 && freeMoney == 0 && startDateOfSaleStageLast > now);
872         }
873         else if (toState == IcoStates.SaleStage3) {
874             return (currentState == IcoStates.SaleStage2 && freeMoney == 0 && startDateOfSaleStageLast > now);
875         }
876         else if (toState == IcoStates.SaleStage4) {
877             return (currentState == IcoStates.SaleStage3 && freeMoney == 0 && startDateOfSaleStageLast > now);
878         }
879         else if (toState == IcoStates.SaleStage5) {
880             return (currentState == IcoStates.SaleStage4 && freeMoney == 0 && startDateOfSaleStageLast > now);
881         }
882         else if (toState == IcoStates.SaleStage6) {
883             return (currentState == IcoStates.SaleStage5 && freeMoney == 0 && startDateOfSaleStageLast > now);
884         }
885         else if (toState == IcoStates.SaleStage7) {
886             return (currentState == IcoStates.SaleStage6 && freeMoney == 0 && startDateOfSaleStageLast > now);
887         }
888         else if (toState == IcoStates.SaleStageLast) {
889             //переход на состояние SaleStageLast возможен только из состояний SaleStages
890             if (
891             currentState != IcoStates.SaleStage1
892             &&
893             currentState != IcoStates.SaleStage2
894             &&
895             currentState != IcoStates.SaleStage3
896             &&
897             currentState != IcoStates.SaleStage4
898             &&
899             currentState != IcoStates.SaleStage5
900             &&
901             currentState != IcoStates.SaleStage6
902             &&
903             currentState != IcoStates.SaleStage7) return false;
904 
905             //переход осуществляется если на состоянии SaleStage7 не осталось свободных токенов
906             //или на одном из состояний SaleStages наступило время startDateOfSaleStageLast
907             if (!(currentState == IcoStates.SaleStage7 && freeMoney == 0) && startDateOfSaleStageLast > now) {
908                 return false;
909             }
910 
911             return true;
912         }
913         else if (toState == IcoStates.PostIco) {
914             return (currentState == IcoStates.SaleStageLast && endDateOfSaleStageLast <= now);
915         }
916     }
917 
918     /**
919     * Fallback функция - из неё по сути просто происходит вызов покупки токенов для отправителя
920     */
921     function() public payable {
922         buyTokens(msg.sender);
923     }
924 
925     /**
926      * Метод покупки токенов
927      */
928     function buyTokens(address beneficiary) public payable {
929         require(beneficiary != 0x0);
930         require(msg.value != 0);
931 
932         //нельзя покупать на токены bounty и team
933         require(beneficiary != bountyTokensAccount && beneficiary != teamTokensAccount);
934 
935         //выставляем остаток средств
936         //в процессе покупки будем его уменьшать на каждой итерации - итерация - покупка токенов на определённой стадии
937         //суть - если покупающий переводит количество эфира,
938         //большее чем возможное количество свободных токенов на определённой стадии,
939         //то выполняется переход на следующую стадию (курс тоже меняется)
940         //и на остаток идёт покупка на новой стадии и т.д.
941         //если же в процессе покупке все свободные токены израсходуются (со всех допустимых стадий)
942         //будет выкинуто исключение
943         uint256 remVal = msg.value;
944 
945         //увеличиваем количество эфира пришедшего к нам
946         totalBalance = totalBalance.add(msg.value);
947 
948         //общее количество токенов которые купили за этот вызов
949         uint256 boughtTokens = 0;
950 
951         while (remVal > 0) {
952             //покупать токены можно только на указанных стадиях
953             require(
954             currentState != IcoStates.VipPlacement
955             &&
956             currentState != IcoStates.PostIco);
957 
958             //выполняем покупку для вызывающего
959             //смотрим, есть ли у нас такое количество свободных токенов на текущей стадии
960             uint256 tokens = remVal.mul(rate);
961             if (tokens > freeMoney) {
962                 remVal = remVal.sub(freeMoney.div(rate));
963                 tokens = freeMoney;
964             }
965             else
966             {
967                 remVal = 0;
968                 //если остаток свободных токенов меньше чем курс - отдаём их покупателю
969                 uint256 remFreeTokens = freeMoney.sub(tokens);
970                 if (0 < remFreeTokens && remFreeTokens < rate) {
971                     tokens = freeMoney;
972                 }
973             }
974             assert(tokens > 0);
975 
976             freeMoney = freeMoney.sub(tokens);
977             totalBought = totalBought.add(tokens);
978             balances[beneficiary] = balances[beneficiary].add(tokens);
979             boughtTokens = boughtTokens.add(tokens);
980 
981             //если покупка была выполнена на любой из стадий Sale кроме последней
982             if (
983             uint(currentState) >= uint(IcoStates.SaleStage1)
984             &&
985             uint(currentState) <= uint(IcoStates.SaleStage7)) {
986 
987                 //уменьшаем количество остатка по токенам которые необходимо продать на этих стадиях
988                 remForSalesBeforeStageLast = remForSalesBeforeStageLast.sub(tokens);
989 
990                 //пробуем перейти между SaleStages
991                 transitionBetweenSaleStages();
992             }
993 
994         }
995 
996         Buy(beneficiary, boughtTokens, msg.value);
997 
998     }
999 
1000     /**
1001     * Метод выполняющий выдачу баунти-токенов на указанный адрес
1002     */
1003     function transferBounty(address _to, uint256 _value) public onlyOwner {
1004         //проверяем кошелёк назначения
1005         require(_to != 0x0 && _to != msg.sender);
1006 
1007         //уменьшаем количество нераспределённых
1008         bountyTokensNotDistributed = bountyTokensNotDistributed.sub(_value);
1009 
1010         //переводим с акаунта баунти на акаунт назначения
1011         balances[_to] = balances[_to].add(_value);
1012         balances[bountyTokensAccount] = balances[bountyTokensAccount].sub(_value);
1013 
1014         Transfer(bountyTokensAccount, _to, _value);
1015     }
1016 
1017     /**
1018     * Метод выполняющий выдачу баунти-токенов на указанный адрес
1019     */
1020     function transferTeam(address _to, uint256 _value) public onlyOwner {
1021         //проверяем кошелёк назначения
1022         require(_to != 0x0 && _to != msg.sender);
1023 
1024         //уменьшаем количество нераспределённых
1025         teamTokensNotDistributed = teamTokensNotDistributed.sub(_value);
1026 
1027         //переводим с акаунта team на team акаунт назначения
1028         teamBalances[_to] = teamBalances[_to].add(_value);
1029         balances[teamTokensAccount] = balances[teamTokensAccount].sub(_value);
1030 
1031         //убираем токены из общего количества выпущенных
1032         totalSupply = totalSupply.sub(_value);
1033     }
1034 
1035     /**
1036     * Function that is called when a user or another contract wants to transfer funds .
1037     */
1038     function transfer(address _to, uint _value, bytes _data) checkForTransfer(msg.sender, _to, _value) public returns (bool) {
1039 
1040         if (isContract(_to)) {
1041             return transferToContract(_to, _value, _data);
1042         }
1043         else {
1044             return transferToAddress(_to, _value, _data);
1045         }
1046     }
1047 
1048 
1049     /**
1050     * @dev transfer token for a specified address
1051     * Standard function transfer similar to ERC20 transfer with no _data .
1052     * Added due to backwards compatibility reasons .
1053     * @param _to The address to transfer to.
1054     * @param _value The amount to be transferred.
1055     */
1056     function transfer(address _to, uint _value) checkForTransfer(msg.sender, _to, _value) public returns (bool) {
1057 
1058         //standard function transfer similar to ERC20 transfer with no _data
1059         //added due to backwards compatibility reasons
1060         bytes memory empty;
1061         if (isContract(_to)) {
1062             return transferToContract(_to, _value, empty);
1063         }
1064         else {
1065             return transferToAddress(_to, _value, empty);
1066         }
1067     }
1068 
1069     /**
1070     * assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1071     */
1072     function isContract(address _addr) private view returns (bool) {
1073         uint length;
1074         assembly {
1075         //retrieve the size of the code on target address, this needs assembly
1076         length := extcodesize(_addr)
1077         }
1078         return (length > 0);
1079     }
1080 
1081     /**
1082     * function that is called when transaction target is an address
1083     */
1084     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool) {
1085         _transfer(msg.sender, _to, _value);
1086         Transfer(msg.sender, _to, _value, _data);
1087         return true;
1088     }
1089 
1090     /**
1091     * function that is called when transaction target is a contract
1092     */
1093     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
1094         _transfer(msg.sender, _to, _value);
1095         ContractReceiver receiver = ContractReceiver(_to);
1096         receiver.tokenFallback(msg.sender, _value, _data);
1097         Transfer(msg.sender, _to, _value, _data);
1098         return true;
1099     }
1100 
1101     function _transfer(address _from, address _to, uint _value) private {
1102         require(balances[_from] >= _value);
1103         balances[_from] = balances[_from].sub(_value);
1104         balances[_to] = balances[_to].add(_value);
1105         if (currentState != IcoStates.PostIco) {
1106             //общая сумма переводов от владельца (до завершения) ico не может превышать InitialCoinsFor_VipPlacement
1107             vipPlacementNotDistributed = vipPlacementNotDistributed.sub(_value);
1108         }
1109     }
1110 
1111 
1112 
1113 
1114     /**
1115     * @dev Gets the balance of the specified address.
1116     * @param _owner The address to query the the balance of.
1117     * @return An uint256 representing the amount owned by the passed address.
1118     */
1119     function balanceOf(address _owner) public constant returns (uint256 balance) {
1120         return balances[_owner];
1121     }
1122 
1123     /**
1124      * @dev Transfer tokens from one address to another
1125      * @param _from address The address which you want to send tokens from
1126      * @param _to address The address which you want to transfer to
1127      * @param _value uint256 the amout of tokens to be transfered
1128      */
1129     function transferFrom(address _from, address _to, uint256 _value) public afterIco returns (bool) {
1130 
1131         var _allowance = allowed[_from][msg.sender];
1132 
1133         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
1134         // require (_value <= _allowance);
1135 
1136         balances[_to] = balances[_to].add(_value);
1137         balances[_from] = balances[_from].sub(_value);
1138         allowed[_from][msg.sender] = _allowance.sub(_value);
1139         Transfer(_from, _to, _value);
1140         return true;
1141     }
1142 
1143     /**
1144      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
1145      * @param _spender The address which will spend the funds.
1146      * @param _value The amount of tokens to be spent.
1147      */
1148     function approve(address _spender, uint256 _value) public afterIco returns (bool) {
1149         // To change the approve amount you first have to reduce the addresses`
1150         //  allowance to zero by calling `approve(_spender, 0)` if it is not
1151         //  already 0 to mitigate the race condition described here:
1152         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1153         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
1154 
1155         allowed[msg.sender][_spender] = _value;
1156         Approval(msg.sender, _spender, _value);
1157         return true;
1158     }
1159 
1160     /**
1161      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1162      * @param _owner address The address which owns the funds.
1163      * @param _spender address The address which will spend the funds.
1164      * @return A uint256 specifing the amount of tokens still available for the spender.
1165      */
1166     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1167         return allowed[_owner][_spender];
1168     }
1169 
1170     /**
1171     * Вспомогательный метод выставляющий количество свободных токенов, рейт и добавляющий количество эмитированных
1172     */
1173     function setMoney(uint256 _freeMoney, uint256 _emission, uint256 _rate) private {
1174         freeMoney = _freeMoney;
1175         totalSupply = totalSupply.add(_emission);
1176         rate = _rate;
1177     }
1178 
1179     /**
1180      * Метод переводящий контракт в состояние PreSale
1181      */
1182     function gotoPreSale() private returns (bool) {
1183 
1184         //проверяем возможность перехода
1185         if (!canGotoState(IcoStates.PreSale)) return false;
1186 
1187         //да нужно переходить
1188 
1189         //переходим в PreSale
1190         currentState = IcoStates.PreSale;
1191 
1192 
1193         //выставляем состояние токенов
1194         setMoney(EMISSION_FOR_PRESALE, EMISSION_FOR_PRESALE, RATE_PRESALE);
1195 
1196         //устанавливаем дату окончания PreSale
1197         endDateOfPreSale = now.add(DURATION_PRESALE);
1198 
1199         //разим событие изменения состояния
1200         StateChanged(IcoStates.PreSale);
1201         return true;
1202     }
1203 
1204     /**
1205     * Метод переводящий контракт в состояние SaleStage1
1206     */
1207     function gotoSaleStage1() private returns (bool) {
1208         //проверяем возможность перехода
1209         if (!canGotoState(IcoStates.SaleStage1)) return false;
1210 
1211         //да нужно переходить
1212 
1213         //переходим в SaleStage1
1214         currentState = IcoStates.SaleStage1;
1215 
1216         //непроданные токены сгорают
1217         totalSupply = totalSupply.sub(freeMoney);
1218 
1219         //выставляем состояние токенов
1220         setMoney(EMISSION_FOR_SALESTAGE1, EMISSION_FOR_SALESTAGE1, RATE_SALESTAGE1);
1221 
1222         //определяем количество токенов которое можно продать на всех стадиях Sale кроме последней
1223         remForSalesBeforeStageLast =
1224         EMISSION_FOR_SALESTAGE1 +
1225         EMISSION_FOR_SALESTAGE2 +
1226         EMISSION_FOR_SALESTAGE3 +
1227         EMISSION_FOR_SALESTAGE4 +
1228         EMISSION_FOR_SALESTAGE5 +
1229         EMISSION_FOR_SALESTAGE6 +
1230         EMISSION_FOR_SALESTAGE7;
1231 
1232 
1233         //устанавливаем дату начала последней стадии продаж
1234         startDateOfSaleStageLast = now.add(DURATION_SALESTAGES);
1235 
1236         //разим событие изменения состояния
1237         StateChanged(IcoStates.SaleStage1);
1238         return true;
1239     }
1240 
1241     /**
1242      * Метод выполняющий переход между состояниями Sale
1243      */
1244     function transitionBetweenSaleStages() private {
1245         //переход между состояниями SaleStages возможен только если находимся в одном из них, кроме последнего
1246         if (
1247         currentState != IcoStates.SaleStage1
1248         &&
1249         currentState != IcoStates.SaleStage2
1250         &&
1251         currentState != IcoStates.SaleStage3
1252         &&
1253         currentState != IcoStates.SaleStage4
1254         &&
1255         currentState != IcoStates.SaleStage5
1256         &&
1257         currentState != IcoStates.SaleStage6
1258         &&
1259         currentState != IcoStates.SaleStage7) return;
1260 
1261         //если есть возможность сразу переходим в состояние StageLast
1262         if (gotoSaleStageLast()) {
1263             return;
1264         }
1265 
1266         //смотрим в какое состояние можем перейти и выполняем переход
1267         if (canGotoState(IcoStates.SaleStage2)) {
1268             currentState = IcoStates.SaleStage2;
1269             setMoney(EMISSION_FOR_SALESTAGE2, EMISSION_FOR_SALESTAGE2, RATE_SALESTAGE2);
1270             StateChanged(IcoStates.SaleStage2);
1271         }
1272         else if (canGotoState(IcoStates.SaleStage3)) {
1273             currentState = IcoStates.SaleStage3;
1274             setMoney(EMISSION_FOR_SALESTAGE3, EMISSION_FOR_SALESTAGE3, RATE_SALESTAGE3);
1275             StateChanged(IcoStates.SaleStage3);
1276         }
1277         else if (canGotoState(IcoStates.SaleStage4)) {
1278             currentState = IcoStates.SaleStage4;
1279             setMoney(EMISSION_FOR_SALESTAGE4, EMISSION_FOR_SALESTAGE4, RATE_SALESTAGE4);
1280             StateChanged(IcoStates.SaleStage4);
1281         }
1282         else if (canGotoState(IcoStates.SaleStage5)) {
1283             currentState = IcoStates.SaleStage5;
1284             setMoney(EMISSION_FOR_SALESTAGE5, EMISSION_FOR_SALESTAGE5, RATE_SALESTAGE5);
1285             StateChanged(IcoStates.SaleStage5);
1286         }
1287         else if (canGotoState(IcoStates.SaleStage6)) {
1288             currentState = IcoStates.SaleStage6;
1289             setMoney(EMISSION_FOR_SALESTAGE6, EMISSION_FOR_SALESTAGE6, RATE_SALESTAGE6);
1290             StateChanged(IcoStates.SaleStage6);
1291         }
1292         else if (canGotoState(IcoStates.SaleStage7)) {
1293             currentState = IcoStates.SaleStage7;
1294             setMoney(EMISSION_FOR_SALESTAGE7, EMISSION_FOR_SALESTAGE7, RATE_SALESTAGE7);
1295             StateChanged(IcoStates.SaleStage7);
1296         }
1297     }
1298 
1299     /**
1300       * Метод переводящий контракт в состояние SaleStageLast
1301       */
1302     function gotoSaleStageLast() private returns (bool) {
1303         if (!canGotoState(IcoStates.SaleStageLast)) return false;
1304 
1305         //ок переходим на состояние SaleStageLast
1306         currentState = IcoStates.SaleStageLast;
1307 
1308         //выставляем состояние токенов, с учётом всех остатков
1309         setMoney(remForSalesBeforeStageLast + EMISSION_FOR_SALESTAGELAST, EMISSION_FOR_SALESTAGELAST, RATE_SALESTAGELAST);
1310 
1311 
1312         //устанавливаем дату окончания SaleStageLast
1313         endDateOfSaleStageLast = now.add(DURATION_SALESTAGELAST);
1314 
1315         StateChanged(IcoStates.SaleStageLast);
1316         return true;
1317     }
1318 
1319 
1320 
1321     /**
1322       * Метод переводящий контракт в состояние PostIco
1323       */
1324     function gotoPostIco() private returns (bool) {
1325         if (!canGotoState(IcoStates.PostIco)) return false;
1326 
1327         //ок переходим на состояние PostIco
1328         currentState = IcoStates.PostIco;
1329 
1330         //выставляем дату после которой можно использовать премиальные токены
1331         startDateOfUseTeamTokens = now + DURATION_NONUSETEAM;
1332 
1333         //выставляем дату после которой можно зачислять оставшиеся (не распроданные) токены, на произвольный кошелёк
1334         startDateOfRestoreUnsoldTokens = now + DURATION_BEFORE_RESTORE_UNSOLD;
1335 
1336         //запоминаем количество нераспроданных токенов
1337         unsoldTokens = freeMoney;
1338 
1339         //уничтожаем свободные токены
1340         totalSupply = totalSupply.sub(freeMoney);
1341         setMoney(0, 0, 0);
1342 
1343         StateChanged(IcoStates.PostIco);
1344         return true;
1345     }
1346 
1347 
1348 }