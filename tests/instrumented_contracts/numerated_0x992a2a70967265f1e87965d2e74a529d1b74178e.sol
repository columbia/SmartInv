1 pragma solidity ^0.4.25;
2 
3 /**
4     ================================
5     Disclaimer: Данный контракт - всего лишь игра и не является профессиональным инструментом заработка.
6     Отнеситесь к этому с забавой, пользуйтесь с умом и не забывайте, что вклад денег в фаст-контракты - это всегда крайне рисково. 
7     Мы не призываем людей относится к данному контракту, как к инвестиционному проекту.
8     ================================
9 
10   Gradual.pro - Плавно растущий и долго живущий умножитель КАЖДЫЙ ДЕНЬ с розыгрыванием ДЖЕКПОТА!, который возвращает 121% от вашего депозита!
11 
12   Маленький лимит на депозит избавляет от проблем с КИТАМИ, которые очень сильно тормозили предыдущую версию контракта и значительно продлевает срок его жизни!
13 
14   Автоматические выплаты!
15   Полные отчеты о потраченых на рекламу средствах в группе!
16   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
17   Создан и проверен профессионалами!
18   Код полностью документирован на русском языке, каждая строчка понятна!
19 
20   Вебсайт: http://gradual.pro/
21   Канал в телеграмме: https://t.me/gradualpro
22 
23   1. Пошлите любую ненулевую сумму на адрес контракта
24      - сумма от 0.01 до 1 ETH
25      - gas limit минимум 250000
26      - вы встанете в очередь
27   2. Немного подождите
28   3. ...
29   4. PROFIT! Вам пришло 121% от вашего депозита.
30   5. После 21:00 МСК контракт выплачивает 25% от накопленного джекпота последнему вкладчику.
31   6. Остальной джекпот распределяется всем остальным в обратной очереди по 121% от каждого вклада.
32   7. Затем очередь обнуляется и запускается заново!
33 
34 
35   Как это возможно?
36   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
37      новых инвесторов до тех пор, пока не получит 121% от своего депозита
38   2. Выплаты могут приходить несколькими частями или все сразу
39   3. Как только вы получаете 121% от вашего депозита, вы удаляетесь из очереди
40   4. Вы можете делать несколько депозитов сразу
41   5. Баланс этого контракта состовляет сумму джекпота на данный момент!
42 
43      Таким образом, последние платят первым, и инвесторы, достигшие выплат 121% от депозита,
44      удаляются из очереди, уступая место остальным
45 
46               новый инвестор --|            совсем новый инвестор --|
47                  инвестор5     |                новый инвестор      |
48                  инвестор4     |     =======>      инвестор5        |
49                  инвестор3     |                   инвестор4        |
50  (част. выплата) инвестор2    <|                   инвестор3        |
51 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 121%)
52 
53 */
54 
55 contract Restarter {
56     // Время отсроченного старта (timestamp)
57     uint constant public FIRST_START_TIMESTAMP = 1541008800;
58 
59     // Интервал рестарта
60     uint constant public RESTART_INTERVAL = 24 hours; // 24 hours
61 
62     // Адрес кошелька для оплаты рекламы
63     address constant private ADS_SUPPORT = 0x79C188C8d8c7dEc9110c340140F46bE10854E754;
64 
65     // Адрес кошелька для оплаты технической поддержки информационных каналов
66     address constant private TECH_SUPPORT = 0x988f1a2fb17414c95f45E2DAaaA40509F5C9088c;
67 
68     // Процент депозита на рекламу 2%
69     uint constant public ADS_PERCENT = 2;
70 
71     // Процент депозита на тех поддержку 1%
72     uint constant public TECH_PERCENT = 1;
73 
74     // Процент депозита в Джекпот 3%
75     uint constant public JACKPOT_PERCENT = 3;
76 
77     // Процент который перечислится победителю джекпота (последний вкладчик перед рестартом)
78     uint constant public JACKPOT_WINNER_PERCENT = 25;
79     
80     // Процент выплат всем участникам
81     uint constant public MULTIPLIER = 121;
82 
83     // Максимальный размер депозита = 1 эфир, чтобы каждый смог учавстовать и киты не тормозили и не пугали вкладчиков
84     uint constant public MAX_LIMIT = 1 ether;
85 
86     // Минимальный размер депозита = 0.01 эфира
87     uint constant public MIN_LIMIT = 0.01 ether;
88 
89     // Минимальный лимит газа
90     uint constant public MINIMAL_GAS_LIMIT = 250000;
91 
92     // Структура Deposit содержит информацию о депозите
93     struct Deposit {
94         address depositor; // Владелец депозита
95         uint128 deposit;   // Сумма депозита
96         uint128 expect;    // Сумма выплаты (моментально 121% от депозита)
97     }
98 
99     // Событие, чтобы моментально показывать уведомления на сайте
100     event Restart(uint timestamp);
101 
102     // Очередь
103     Deposit[] private _queue;
104 
105     // Номер обрабатываемого депозита, можно следить в разделе Read contract
106     uint public currentReceiverIndex = 0;
107 
108     // Сумма джекпота
109     uint public jackpotAmount = 0;
110 
111     // Храним время последнего старта, чтобы знать когда делать рестарт
112     uint public lastStartTimestamp;
113 
114     uint public queueCurrentLength = 0;
115 
116     // При создании контракта
117     constructor() public {
118         // Записываем время первого старта
119         lastStartTimestamp = FIRST_START_TIMESTAMP;
120     }
121 
122     // Данная функция получает все депозиты, сохраняет их и производит моментальные выплаты
123     function () public payable {
124         // Проверяем, если отсроченый старт начался
125         require(now >= FIRST_START_TIMESTAMP, "Not started yet!");
126 
127         // Проверяем минимальный лимит газа, иначе отменяем депозит и возвращаем деньги вкладчику
128         require(gasleft() >= MINIMAL_GAS_LIMIT, "We require more gas!");
129 
130         // Проверяем максимальную сумму вклада
131         require(msg.value <= MAX_LIMIT, "Deposit is too big!");
132 
133         // Проверяем минимальную сумму вклада
134         require(msg.value >= MIN_LIMIT, "Deposit is too small!");
135 
136         // Проверяем, если нужно сделать рестарт
137         if (now >= lastStartTimestamp + RESTART_INTERVAL) {
138             // Записываем время нового рестарта
139             lastStartTimestamp += (now - lastStartTimestamp) / RESTART_INTERVAL * RESTART_INTERVAL;
140             // Выплачиваем Джекпот
141             _payoutJackpot();
142             _clearQueue();
143             // Вызываем событие
144             emit Restart(now);
145         }
146 
147         // Добавляем депозит в очередь, записываем что ему нужно выплатить % от суммы депозита
148         _insertQueue(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * MULTIPLIER / 100)));
149 
150         // Увеличиваем Джекпот
151         jackpotAmount += msg.value * JACKPOT_PERCENT / 100;
152 
153         // Отправляем процент на продвижение проекта
154         uint ads = msg.value * ADS_PERCENT / 100;
155         ADS_SUPPORT.transfer(ads);
156 
157         // Отправляем процент на техническую поддержку проекта
158         uint tech = msg.value * TECH_PERCENT / 100;
159         TECH_SUPPORT.transfer(tech);
160 
161         // Вызываем функцию оплаты первым в очереди депозитам
162         _pay();
163     }
164 
165     // Функция используется для оплаты первым в очереди депозитам
166     // Каждая новая транзация обрабатывает от 1 до 4+ вкладчиков в начале очереди 
167     // В зависимости от оставшегося газа
168     function _pay() private {
169         // Попытаемся послать все деньги имеющиеся на контракте первым в очереди вкладчикам за вычетом суммы Джекпота
170         uint128 money = uint128(address(this).balance) - uint128(jackpotAmount);
171 
172         // Проходим по всей очереди
173         for (uint i = 0; i < queueCurrentLength; i++) {
174 
175             // Достаем номер первого в очереди депозита
176             uint idx = currentReceiverIndex + i;
177 
178             // Достаем информацию о первом депозите
179             Deposit storage dep = _queue[idx];
180 
181             // Если у нас есть достаточно денег для полной выплаты, то выплачиваем ему все
182             if(money >= dep.expect) {
183                 // Отправляем ему деньги
184                 dep.depositor.transfer(dep.expect);
185                 // Обновляем количество оставшихся денег
186                 money -= dep.expect;
187             } else {
188                 // Попадаем сюда, если у нас не достаточно денег выплатить все, а лишь часть
189                 // Отправляем все оставшееся
190                 dep.depositor.transfer(money);
191                 // Обновляем количество оставшихся денег
192                 dep.expect -= money;
193                 // Выходим из цикла
194                 break;
195             }
196 
197             // Проверяем если еще остался газ, и если его нет, то выходим из цикла
198             if (gasleft() <= 50000) {
199                 //  Следующий вкладчик осуществит выплату следующим в очереди
200                 break;
201             }
202         }
203 
204         // Обновляем номер депозита ставшего первым в очереди
205         currentReceiverIndex += i;
206     }
207 
208     function _payoutJackpot() private {
209         // Попытаемся послать все деньги имеющиеся на контракте первым в очереди вкладчикам за вычетом суммы Джекпота
210         uint128 money = uint128(jackpotAmount);
211 
212         // Перечисляем 25% с джекпота победителю
213         Deposit storage dep = _queue[queueCurrentLength - 1];
214 
215         dep.depositor.transfer(uint128(jackpotAmount * JACKPOT_WINNER_PERCENT / 100));
216         money -= uint128(jackpotAmount * JACKPOT_WINNER_PERCENT / 100);
217 
218         // Проходим по всей очереди с конца
219         for (uint i = queueCurrentLength - 2; i < queueCurrentLength && i >= currentReceiverIndex; i--) {
220             // Достаем информацию о последнем депозите
221             dep = _queue[i];
222 
223             // Если у нас есть достаточно денег для полной выплаты, то выплачиваем ему все
224             if(money >= dep.expect) {
225                 // Отправляем ему деньги
226                 dep.depositor.transfer(dep.expect);
227                 // Обновляем количество оставшихся денег
228                 money -= dep.expect;
229             } else if (money > 0) {
230                 // Попадаем сюда, если у нас не достаточно денег выплатить все, а лишь часть
231                 // Отправляем все оставшееся
232                 dep.depositor.transfer(money);
233                 // Обновляем количество оставшихся денег
234                 dep.expect -= money;
235                 money = 0;
236             } else {
237                 break;
238             }
239         }
240 
241         // Обнуляем джекпот на новый раунд
242         jackpotAmount = 0;
243         // Обнуляем очередь
244         currentReceiverIndex = 0;
245     }
246 
247     function _insertQueue(Deposit deposit) private {
248         if (queueCurrentLength == _queue.length) {
249             _queue.length += 1;
250         }
251         _queue[queueCurrentLength++] = deposit;
252     }
253 
254     function _clearQueue() private {
255         queueCurrentLength = 0;
256     }
257 
258     // Показывает информацию о депозите по его номеру (idx), можно следить в разделе Read contract
259     // Вы можете получить номер депозита  (idx) вызвав функцию getDeposits()
260     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
261         Deposit storage dep = _queue[idx];
262         return (dep.depositor, dep.deposit, dep.expect);
263     }
264 
265     // Показывает количество вкладов определенного инвестора
266     function getDepositsCount(address depositor) public view returns (uint) {
267         uint c = 0;
268         for(uint i=currentReceiverIndex; i < queueCurrentLength; ++i){
269             if(_queue[i].depositor == depositor)
270                 c++;
271         }
272         return c;
273     }
274 
275     // Показывает все депозиты (index, deposit, expect) определенного инвестора, можно следить в разделе Read contract
276     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
277         uint c = getDepositsCount(depositor);
278 
279         idxs = new uint[](c);
280         deposits = new uint128[](c);
281         expects = new uint128[](c);
282 
283         if(c > 0) {
284             uint j = 0;
285             for(uint i = currentReceiverIndex; i < queueCurrentLength; ++i){
286                 Deposit storage dep = _queue[i];
287                 if(dep.depositor == depositor){
288                     idxs[j] = i;
289                     deposits[j] = dep.deposit;
290                     expects[j] = dep.expect;
291                     j++;
292                 }
293             }
294         }
295     }
296     
297     // Показывает длинну очереди, можно следить в разделе Read contract
298     function getQueueLength() public view returns (uint) {
299         return queueCurrentLength - currentReceiverIndex;
300     }
301 
302 }