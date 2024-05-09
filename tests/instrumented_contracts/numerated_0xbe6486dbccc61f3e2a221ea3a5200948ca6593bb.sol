1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4   function balanceOf(address who) constant returns (uint);
5   function allowance(address owner, address spender) constant returns (uint);
6 
7   function transfer(address to, uint value) returns (bool ok);
8   function transferFrom(address from, address to, uint value) returns (bool ok);
9   function approve(address spender, uint value) returns (bool ok);
10   event Transfer(address indexed from, address indexed to, uint value);
11   event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 //Безопасные математические вычисления
15 contract SafeMath {
16   function safeMul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function safeDiv(uint a, uint b) internal returns (uint) {
23     assert(b > 0);
24     uint c = a / b;
25     assert(a == b * c + a % b);
26     return c;
27   }
28 
29   function safeSub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function safeAdd(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c>=a && c>=b);
37     return c;
38   }
39 
40   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a >= b ? a : b;
42   }
43 
44   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a < b ? a : b;
46   }
47 
48   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a >= b ? a : b;
50   }
51 
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55 
56 }
57 
58 contract StandardToken is ERC20, SafeMath {
59 
60   /* Token supply got increased and a new owner received these tokens */
61   event Minted(address receiver, uint amount);
62 
63   /* Actual balances of token holders */
64   mapping(address => uint) balances;
65 
66   /* approve() allowances */
67   mapping (address => mapping (address => uint)) allowed;
68 
69   /* Interface declaration */
70   function isToken() public constant returns (bool Yes) {
71     return true;
72   }
73 
74   function transfer(address _to, uint _value) returns (bool success) {
75     balances[msg.sender] = safeSub(balances[msg.sender], _value);
76     balances[_to] = safeAdd(balances[_to], _value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
82     uint _allowance = allowed[_from][msg.sender];
83 
84     balances[_to] = safeAdd(balances[_to], _value);
85     balances[_from] = safeSub(balances[_from], _value);
86     allowed[_from][msg.sender] = safeSub(_allowance, _value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function balanceOf(address _address) constant returns (uint balance) {
92     return balances[_address];
93   }
94 
95   function approve(address _spender, uint _value) returns (bool success) {
96 
97     // To change the approve amount you first have to reduce the addresses`
98     //  allowance to zero by calling `approve(_spender, 0)` if it is not
99     //  already 0 to mitigate the race condition described here:
100     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
102 
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) constant returns (uint remaining) {
109     return allowed[_owner][_spender];
110   }
111 
112 }
113 
114 contract DESToken is StandardToken {
115 
116     string public name = "Decentralized Escrow Service";
117     string public symbol = "DES";
118     uint public decimals = 18;//Разрядность токена
119 	uint public HardCapEthereum = 66666000000000000000000 wei;//Максимальное количество собранного Ethereum - 66 666 ETH (задано в wei)
120     
121     //Массив с замороженными адресами, которым запрещено осуществять переводы токенов
122     mapping (address => bool) public noTransfer;
123 	
124 	// Время начала ICO и время окончания ICO
125 	uint constant public TimeStart = 1511956800;//Константа - время начала ICO - 29.11.2017 в 15:00 по Мск
126 	uint public TimeEnd = 1514375999;//Время окончания ICO - 27.12.2017 в 14:59:59 по мск
127 	
128 	// Время окончания бонусных этапов (недель)
129 	uint public TimeWeekOne = 1512561600;//1000 DES – начальная цена – 1-ая неделя
130 	uint public TimeWeekTwo = 1513166400;//800 DES – 2-ая неделя
131 	uint public TimeWeekThree = 1513771200;//666,666 DES – 3-ая неделя
132     
133 	uint public TimeTransferAllowed = 1516967999;//Переводы токенов разрешены через месяц (30 суток = 2592000 секунд) после ICO
134 	
135 	//Пулы ICO (различное время выхода на биржу: запрет некоторым пулам перечисления токенов до определенного времени)
136 	uint public PoolPreICO = 0;//Человек в ЛК указывает свой адрес эфириума, на котором хранятся DEST или DESP и ему на этот адрес приходят токены DES в таком же количестве + ещё 50%
137 	uint public PoolICO = 0;//Пул ICO - выход на биржу через 1 месяц
138 	uint public PoolTeam = 0;//Пул команды - выход на биржу через 1 месяц. 15%
139 	uint public PoolAdvisors = 0;//Пул эдвайзеров - выход на биржу через 1 месяц. 7%
140 	uint public PoolBounty = 0;//Пул баунти кампании - выход на биржу через 1 месяц. 3%
141 	    
142 	//Стоимость токенов на различных этапах
143 	uint public PriceWeekOne = 1000000000000000 wei;//Стоимость токена во время недели 1
144 	uint public PriceWeekTwo = 1250000000000000 wei;//Стоимость токена во время недели 2
145 	uint public PriceWeekThree = 1500000000000000 wei;//Стоимость токена во время недели 3
146 	uint public PriceWeekFour = 1750000000000000 wei;//Стоимость токена во время недели 4
147 	uint public PriceManual = 0 wei;//Стоимость токена, установленная вручную
148 	
149 	//Технические переменные состояния ICO
150     bool public ICOPaused = false; //Основатель может активировать данный параметр (true), чтобы приостановить ICO на неопределенный срок
151     bool public ICOFinished = false; //ICO было завершено
152 	
153     //Технические переменные для хранения данных статистики
154 	uint public StatsEthereumRaised = 0 wei;//Переменная сохранит в себе количество собранного Ethereum
155 	uint public StatsTotalSupply = 0;//Общее количество выпущенных токенов
156 
157     //События
158     event Buy(address indexed sender, uint eth, uint fbt);//Покупка токенов
159     event TokensSent(address indexed to, uint value);//Токены отправлены на адрес
160     event ContributionReceived(address indexed to, uint value);//Вложение получено
161     event PriceChanged(string _text, uint _tokenPrice);//Стоимость токена установлена вручную
162     event TimeEndChanged(string _text, uint _timeEnd);//Время окончания ICO изменено вручную
163     event TimeTransferAllowanceChanged(string _text, uint _timeAllowance);//Время, до которого запрещены переводы токенов, изменено вручную
164 //    event HardCapChanged(string _text, uint _HardCapEthereum);//Установка максимальной капитализации, после которой ICO считается завершенным
165     
166     address public owner = 0x0;//Административные действия 0xE7F7d6cBCdC1fE78F938Bfaca6eA49604cB58D33
167     address public wallet = 0x0;//Кошелек сбора средств 0x51559efc1acc15bcafc7e0c2fb440848c136a46b
168  
169 function DESToken(address _owner, address _wallet) payable {
170         
171       owner = _owner;
172       wallet = _wallet;
173     
174       balances[owner] = 0;
175       balances[wallet] = 0;
176     }
177     
178     modifier onlyOwner() {
179         require(msg.sender == owner);
180         _;
181     }
182 
183 	//Приостановлено ли ICO или запущено
184     modifier isActive() {
185         require(!ICOPaused);
186         _;
187     }
188 
189     //Транзакция получена - запустить функцию покупки
190     function() payable {
191         buy();
192     }
193     
194     //Установка стоимости токена вручную. Если значение больше 0, токены продаются по установленной вручную цене
195     function setTokenPrice(uint _tokenPrice) external onlyOwner {
196         PriceManual = _tokenPrice;
197         PriceChanged("New price is ", _tokenPrice);
198     }
199     
200     //Установка времени окончания ICO
201     function setTimeEnd(uint _timeEnd) external onlyOwner {
202         TimeEnd = _timeEnd;
203         TimeEndChanged("New ICO End Time is ", _timeEnd);
204     }
205     
206     //Установка максимальной капитализации, после которой ICO считается завершенным
207 //    function setHardCap(uint _HardCapEthereum) external onlyOwner {
208 //        HardCapEthereum = _HardCapEthereum;
209 //        HardCapChanged("New ICO Hard Cap is ", _HardCapEthereum);
210 //    }
211      
212     //Установка времени, до которого запрещены переводы токенов
213     function setTimeTransferAllowance(uint _timeAllowance) external onlyOwner {
214         TimeTransferAllowed = _timeAllowance;
215         TimeTransferAllowanceChanged("Token transfers will be allowed at ", _timeAllowance);
216     }
217     
218     // Запретить определенному покупателю осуществлять переводы его токенов
219     // @параметр target Адрес покупателя, на который установить запрет
220     // @параметр allow Установить запрет (true) или запрет снят (false)
221     function disallowTransfer(address target, bool disallow) external onlyOwner {
222         noTransfer[target] = disallow;
223     }
224     
225     //Завершить ICO и создать пулы токенов (команда, баунти, эдвайзеры)
226     function finishCrowdsale() external onlyOwner returns (bool) {
227         if (ICOFinished == false) {
228             
229             PoolTeam = StatsTotalSupply*15/100;//Пул команды - выход на биржу через 1 месяц. 15%
230             PoolAdvisors = StatsTotalSupply*7/100;//Пул эдвайзеров - выход на биржу через 1 месяц. 7%
231             PoolBounty = StatsTotalSupply*3/100;//Пул баунти кампании - выход на биржу через 1 месяц. 3%
232             
233             uint poolTokens = 0;
234             poolTokens = safeAdd(poolTokens,PoolTeam);
235             poolTokens = safeAdd(poolTokens,PoolAdvisors);
236             poolTokens = safeAdd(poolTokens,PoolBounty);
237             
238             //Зачислить на счет основателя токены пула команды, эдвайзеров и баунти
239             require(poolTokens>0);//Количество токенов должно быть больше 0
240             balances[owner] = safeAdd(balances[owner], poolTokens);
241             StatsTotalSupply = safeAdd(StatsTotalSupply, poolTokens);//Обновляем общее количество выпущенных токенов
242             Transfer(0, this, poolTokens);
243             Transfer(this, owner, poolTokens);
244                         
245             ICOFinished = true;//ICO завершено
246             
247             }
248         }
249 
250     //Функция возвращает текущую стоимость в wei 1 токена
251     function price() constant returns (uint) {
252         if(PriceManual > 0){return PriceManual;}
253         if(now >= TimeStart && now < TimeWeekOne){return PriceWeekOne;}
254         if(now >= TimeWeekOne && now < TimeWeekTwo){return PriceWeekTwo;}
255         if(now >= TimeWeekTwo && now < TimeWeekThree){return PriceWeekThree;}
256         if(now >= TimeWeekThree){return PriceWeekFour;}
257     }
258     
259     // Создать `amount` токенов и отправить их `target`
260     // @параметр target Адрес получателя токенов
261     // @параметр amount Количество создаваемых токенов
262     function sendPreICOTokens(address target, uint amount) onlyOwner external {
263         
264         require(amount>0);//Количество токенов должно быть больше 0
265         balances[target] = safeAdd(balances[target], amount);
266         StatsTotalSupply = safeAdd(StatsTotalSupply, amount);//Обновляем общее количество выпущенных токенов
267         Transfer(0, this, amount);
268         Transfer(this, target, amount);
269         
270         PoolPreICO = safeAdd(PoolPreICO,amount);//Обновляем общее количество токенов в пуле Pre-ICO
271     }
272     
273     // Создать `amount` токенов и отправить их `target`
274     // @параметр target Адрес получателя токенов
275     // @параметр amount Количество создаваемых токенов
276     function sendICOTokens(address target, uint amount) onlyOwner external {
277         
278         require(amount>0);//Количество токенов должно быть больше 0
279         balances[target] = safeAdd(balances[target], amount);
280         StatsTotalSupply = safeAdd(StatsTotalSupply, amount);//Обновляем общее количество выпущенных токенов
281         Transfer(0, this, amount);
282         Transfer(this, target, amount);
283         
284         PoolICO = safeAdd(PoolICO,amount);//Обновляем общее количество токенов в пуле Pre-ICO
285     }
286     
287     // Перечислить `amount` командных токенов на адрес `target` со счета основателя (администратора) после завершения ICO
288     // @параметр target Адрес получателя токенов
289     // @параметр amount Количество перечисляемых токенов
290     function sendTeamTokens(address target, uint amount) onlyOwner external {
291         
292         require(ICOFinished);//Возможно только после завершения ICO
293         require(amount>0);//Количество токенов должно быть больше 0
294         require(amount>=PoolTeam);//Количество токенов должно быть больше или равно размеру пула команды
295         require(balances[owner]>=PoolTeam);//Количество токенов должно быть больше или равно балансу основателя
296         
297         balances[owner] = safeSub(balances[owner], amount);//Вычитаем токены у администратора (основателя)
298         balances[target] = safeAdd(balances[target], amount);//Добавляем токены на счет получателя
299         PoolTeam = safeSub(PoolTeam, amount);//Обновляем общее количество токенов пула команды
300         TokensSent(target, amount);//Публикуем событие в блокчейн
301         Transfer(owner, target, amount);//Осуществляем перевод
302         
303         noTransfer[target] = true;//Вносим получателя в базу аккаунтов, которым 1 месяц после ICO запрещено осуществлять переводы токенов
304     }
305     
306     // Перечислить `amount` токенов эдвайзеров на адрес `target` со счета основателя (администратора) после завершения ICO
307     // @параметр target Адрес получателя токенов
308     // @параметр amount Количество перечисляемых токенов
309     function sendAdvisorsTokens(address target, uint amount) onlyOwner external {
310         
311         require(ICOFinished);//Возможно только после завершения ICO
312         require(amount>0);//Количество токенов должно быть больше 0
313         require(amount>=PoolAdvisors);//Количество токенов должно быть больше или равно размеру пула эдвайзеров
314         require(balances[owner]>=PoolAdvisors);//Количество токенов должно быть больше или равно балансу основателя
315         
316         balances[owner] = safeSub(balances[owner], amount);//Вычитаем токены у администратора (основателя)
317         balances[target] = safeAdd(balances[target], amount);//Добавляем токены на счет получателя
318         PoolAdvisors = safeSub(PoolAdvisors, amount);//Обновляем общее количество токенов пула эдвайзеров
319         TokensSent(target, amount);//Публикуем событие в блокчейн
320         Transfer(owner, target, amount);//Осуществляем перевод
321         
322         noTransfer[target] = true;//Вносим получателя в базу аккаунтов, которым 1 месяц после ICO запрещено осуществлять переводы токенов
323     }
324     
325     // Перечислить `amount` баунти токенов на адрес `target` со счета основателя (администратора) после завершения ICO
326     // @параметр target Адрес получателя токенов
327     // @параметр amount Количество перечисляемых токенов
328     function sendBountyTokens(address target, uint amount) onlyOwner external {
329         
330         require(ICOFinished);//Возможно только после завершения ICO
331         require(amount>0);//Количество токенов должно быть больше 0
332         require(amount>=PoolBounty);//Количество токенов должно быть больше или равно размеру пула баунти
333         require(balances[owner]>=PoolBounty);//Количество токенов должно быть больше или равно балансу основателя
334         
335         balances[owner] = safeSub(balances[owner], amount);//Вычитаем токены у администратора (основателя)
336         balances[target] = safeAdd(balances[target], amount);//Добавляем токены на счет получателя
337         PoolBounty = safeSub(PoolBounty, amount);//Обновляем общее количество токенов пула баунти
338         TokensSent(target, amount);//Публикуем событие в блокчейн
339         Transfer(owner, target, amount);//Осуществляем перевод
340         
341         noTransfer[target] = true;//Вносим получателя в базу аккаунтов, которым 1 месяц после ICO запрещено осуществлять переводы токенов
342     }
343 
344     //Функция покупки токенов на ICO
345     function buy() public payable returns(bool) {
346 
347         require(msg.sender != owner);//Основатели не могут покупать токены
348         require(msg.sender != wallet);//Основатели не могут покупать токены
349         require(!ICOPaused);//Покупка разрешена, если ICO не приостановлено
350         require(!ICOFinished);//Покупка разрешена, если ICO не завершено
351         require(msg.value >= price());//Полученная сумма в wei должна быть больше стоимости 1 токена
352         require(now >= TimeStart);//Условие продажи - ICO началось
353         require(now <= TimeEnd);//Условие продажи - ICO не завершено
354         uint tokens = msg.value/price();//Количество токенов, которое должен получить покупатель
355         require(safeAdd(StatsEthereumRaised, msg.value) <= HardCapEthereum);//Собранный эфир не больше hard cap
356         
357         require(tokens>0);//Количество токенов должно быть больше 0
358         
359         wallet.transfer(msg.value);//Отправить полученные ETH на кошелек сбора средств
360         
361         //Зачисление токенов на счет покупателя
362         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
363         StatsTotalSupply = safeAdd(StatsTotalSupply, tokens);//Обновляем общее количество выпущенных токенов
364         Transfer(0, this, tokens);
365         Transfer(this, msg.sender, tokens);
366         
367         StatsEthereumRaised = safeAdd(StatsEthereumRaised, msg.value);//Обновляем цифру собранных ETH
368         PoolICO = safeAdd(PoolICO, tokens);//Обновляем размер пула ICO
369         
370         //Записываем события в блокчейн
371         Buy(msg.sender, msg.value, tokens);
372         TokensSent(msg.sender, tokens);
373         ContributionReceived(msg.sender, msg.value);
374 
375         return true;
376     }
377     
378     function EventEmergencyStop() onlyOwner() {ICOPaused = true;}//Остановить ICO (в случае непредвиденных обстоятельств)
379     function EventEmergencyContinue() onlyOwner() {ICOPaused = false;}//Продолжить ICO
380 
381     //Если переводы токенов для всех участников еще не разрешены (1 месяц после ICO), проверяем, участник ли это Pre-ICO. Если нет, запрещаем перевод
382     function transfer(address _to, uint _value) isActive() returns (bool success) {
383         
384     if(now >= TimeTransferAllowed){
385         if(noTransfer[msg.sender]){noTransfer[msg.sender] = false;}//Если переводы разрешены по времени, разрешаем их отправителю
386     }
387         
388     if(now < TimeTransferAllowed){require(!noTransfer[msg.sender]);}//Если переводы еще не разрешены по времени, переводить могут только участники Pre-ICO
389         
390     return super.transfer(_to, _value);
391     }
392     /**
393      * ERC 20 Standard Token interface transfer function
394      *
395      * Prevent transfers until halt period is over.
396      */
397     function transferFrom(address _from, address _to, uint _value) isActive() returns (bool success) {
398         
399     if(now >= TimeTransferAllowed){
400         if(noTransfer[msg.sender]){noTransfer[msg.sender] = false;}//Если переводы разрешены по времени, разрешаем их отправителю
401     }
402         
403     if(now < TimeTransferAllowed){require(!noTransfer[msg.sender]);}//Если переводы еще не разрешены по времени, переводить могут только участники Pre-ICO
404         
405         return super.transferFrom(_from, _to, _value);
406     }
407 
408     //Сменить владельца
409     function changeOwner(address _to) onlyOwner() {
410         balances[_to] = balances[owner];
411         balances[owner] = 0;
412         owner = _to;
413     }
414 
415     //Сменить адрес кошелька для сбора средств
416     function changeWallet(address _to) onlyOwner() {
417         balances[_to] = balances[wallet];
418         balances[wallet] = 0;
419         wallet = _to;
420     }
421 }