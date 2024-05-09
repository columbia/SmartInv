1 pragma solidity ^0.4.25;
2 
3 contract FastGameMultiplier {
4 
5     //адрес поддержки
6     address public support;
7 
8     //Проценты
9 	uint constant public PRIZE_PERCENT = 3;
10     uint constant public SUPPORT_PERCENT = 2;
11     
12     //ограничения депозита
13     uint constant public MAX_INVESTMENT =  0.2 ether;
14     uint constant public MIN_INVESTMENT = 0.01 ether;
15     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.02 ether;
16     uint constant public GAS_PRICE_MAX = 20; // максимальная цена газа maximum gas price for contribution transactions
17     uint constant public MAX_IDLE_TIME = 10 minutes; //время ожидания до забора приза //Maximum time the deposit should remain the last to receive prize
18 
19     //успешность игры, минимальное количество участников
20     uint constant public SIZE_TO_SAVE_INVEST = 10; //минимальное количество участников
21     uint constant public TIME_TO_SAVE_INVEST = 5 minutes; //время после которого игру можно отменить
22     
23     //сетка процентов для вложения в одном старте, старт каждый час (тестово)
24     uint8[] MULTIPLIERS = [
25         115, //первый
26         120, //второй
27         125 //третий
28     ];
29 
30     //описание депозита
31     struct Deposit {
32         address depositor; //Адрес депозита
33         uint128 deposit;   //Сумма депозита 
34         uint128 expect;    //Сколько выплатить по депозиту (115%-125%)
35     }
36 
37    //Описание номера очереди и номер депозита в очереди
38     struct DepositCount {
39         int128 stage;
40         uint128 count;
41     }
42 
43 	//Описание последнего и предпоследнего депозита 
44     struct LastDepositInfo {
45         uint128 index;
46         uint128 time;
47     }
48 
49     Deposit[] private queue;  //The queue
50 
51     uint public currentReceiverIndex = 0; //Индекс первого инвестора The index of the first depositor in the queue. The receiver of investments!
52     uint public currentQueueSize = 0; //Размер очереди The current size of queue (may be less than queue.length)
53     LastDepositInfo public lastDepositInfoForPrize; //Последний депозит для Джека The time last deposit made at
54     LastDepositInfo public previosDepositInfoForPrize; //Предпоследний депозит для Джека The time last deposit made at
55 
56     uint public prizeAmount = 0; //Сумма приза оставшаяся с прошлого запуска
57     uint public prizeStageAmount = 0; //Сумма приза Prize в текущем запуске amount accumulated for the last depositor
58     int public stage = 0; //Количество стартов Number of contract runs
59     uint128 public lastDepositTime = 0; //Время последнего депозита
60     
61     mapping(address => DepositCount) public depositsMade; //The number of deposits of different depositors
62 
63     constructor() public {
64         support = msg.sender; 
65         proceedToNewStage(getCurrentStageByTime() + 1);
66     }
67     
68     //This function receives all the deposits
69     //stores them and make immediate payouts
70     function () public payable {
71         require(tx.gasprice <= GAS_PRICE_MAX * 1000000000);
72         require(gasleft() >= 250000, "We require more gas!"); //условие ограничения газа
73         
74         checkAndUpdateStage();
75         
76         if(msg.value > 0){
77             require(msg.value >= MIN_INVESTMENT && msg.value <= MAX_INVESTMENT); //Условие  депозита
78             require(lastDepositInfoForPrize.time <= now + MAX_IDLE_TIME); 
79 
80             
81 
82             require(getNextStageStartTime() >= now + MAX_IDLE_TIME + 10 minutes);//нельзя инвестировать за MAX_IDLE_TIME до следующего старта
83 
84             //Pay to first investors in line
85             if(currentQueueSize < SIZE_TO_SAVE_INVEST){ //страховка от плохого старта
86                 
87                 addDeposit(msg.sender, msg.value);
88                 
89             } else {
90                 
91                 addDeposit(msg.sender, msg.value);
92                 pay(); 
93                 
94             }
95             
96         } else if(msg.value == 0 && currentQueueSize > SIZE_TO_SAVE_INVEST){
97             
98             withdrawPrize(); //выплата приза
99             
100         } else if(msg.value == 0){
101             
102             require(currentQueueSize <= SIZE_TO_SAVE_INVEST); //Для возврата должно быть менее, либо равно SIZE_TO_SAVE_INVEST игроков
103             require(lastDepositTime > 0 && (now - lastDepositTime) >= TIME_TO_SAVE_INVEST); //Для возврата должно пройти время TIME_TO_SAVE_INVEST
104             
105             returnPays(); //Вернуть все депозиты
106             
107         } 
108     }
109 
110     //Used to pay to current investors
111     function pay() private {
112         //Try to send all the money on contract to the first investors in line
113         uint balance = address(this).balance;
114         uint128 money = 0;
115         
116         if(balance > prizeStageAmount) //The opposite is impossible, however the check will not do any harm
117             money = uint128(balance - prizeStageAmount);
118 
119         //Send small part to tech support
120         uint128 moneyS = uint128(money*SUPPORT_PERCENT/100);
121         support.send(moneyS);
122         money -= moneyS;
123         
124         //We will do cycle on the queue
125         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
126 
127             Deposit storage dep = queue[i]; //get the info of the first investor
128 
129             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
130                     
131                 dep.depositor.send(dep.expect); 
132                 money -= dep.expect;          
133                 
134                 //После выплаты депозиты + процента удаляется из очереди this investor is fully paid, so remove him
135                 delete queue[i];
136             
137                 
138             }else{
139                 //Here we don't have enough money so partially pay to investor
140 
141                 dep.depositor.send(money);      //Send to him everything we have
142                 money -= dep.expect;            //update money left
143 
144                 break;                     //Exit cycle
145             }
146 
147             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
148                 break;                     //The next investor will process the line further
149         }
150 
151         currentReceiverIndex = i; //Update the index of the current first investor
152     }
153     
154     function returnPays() private {
155         //Try to send all the money on contract to the first investors in line
156         uint balance = address(this).balance;
157         uint128 money = 0;
158         
159         if(balance > prizeAmount) //The opposite is impossible, however the check will not do any harm
160             money = uint128(balance - prizeAmount);
161         
162         //We will do cycle on the queue
163         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
164 
165             Deposit storage dep = queue[i]; //get the info of the first investor
166 
167                 dep.depositor.send(dep.deposit); //Игра не состоялась, возврат
168                 money -= dep.deposit;            
169                 
170                 //После выплаты депозиты + процента удаляется из очереди this investor is fully paid, so remove him
171                 delete queue[i];
172 
173         }
174 
175         prizeStageAmount = 0; //Вернули деньги, джека текущей очереди нет.
176         proceedToNewStage(getCurrentStageByTime() + 1);
177     }
178 
179     function addDeposit(address depositor, uint value) private {
180         //Count the number of the deposit at this stage
181         DepositCount storage c = depositsMade[depositor];
182         if(c.stage != stage){
183             c.stage = int128(stage);
184             c.count = 0;
185         }
186 
187         //Участие в игре за джекпот только минимальном депозите MIN_INVESTMENT_FOR_PRIZE
188         if(value >= MIN_INVESTMENT_FOR_PRIZE){
189             previosDepositInfoForPrize = lastDepositInfoForPrize;
190             lastDepositInfoForPrize = LastDepositInfo(uint128(currentQueueSize), uint128(now));
191         }
192 
193         //Compute the multiplier percent for this depositor
194         uint multiplier = getDepositorMultiplier(depositor);
195         
196         push(depositor, value, value*multiplier/100);
197 
198         //Increment number of deposits the depositors made this round
199         c.count++;
200 
201         lastDepositTime = uint128(now);
202         
203         //Save money for prize
204         prizeStageAmount += value*PRIZE_PERCENT/100;
205     }
206 
207     function checkAndUpdateStage() private {
208         int _stage = getCurrentStageByTime();
209 
210         require(_stage >= stage); //старт еще не произошел
211 
212         if(_stage != stage){
213             proceedToNewStage(_stage);
214         }
215     }
216 
217     function proceedToNewStage(int _stage) private {
218         //Старт новой игры
219         stage = _stage;
220         currentQueueSize = 0; 
221         currentReceiverIndex = 0;
222         lastDepositTime = 0;
223         prizeAmount += prizeStageAmount; 
224         prizeStageAmount = 0;
225         delete queue;
226         delete previosDepositInfoForPrize;
227         delete lastDepositInfoForPrize;
228     }
229 
230     //отправка приза
231     function withdrawPrize() private {
232         //You can withdraw prize only if the last deposit was more than MAX_IDLE_TIME ago
233         require(lastDepositInfoForPrize.time > 0 && lastDepositInfoForPrize.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
234         //Last depositor will receive prize only if it has not been fully paid
235         require(currentReceiverIndex <= lastDepositInfoForPrize.index, "The last depositor should still be in queue");
236 
237         uint balance = address(this).balance;
238 
239         //Send donation to the first multiplier for it to spin faster
240         //It already contains all the sum, so we must split for father and last depositor only
241         //If the .call fails then ether will just stay on the contract to be distributed to
242         //the queue at the next stage
243 
244         uint prize = balance;
245         if(previosDepositInfoForPrize.index > 0){
246             uint prizePrevios = prize*10/100;
247             queue[previosDepositInfoForPrize.index].depositor.transfer(prizePrevios);
248             prize -= prizePrevios;
249         }
250 
251         queue[lastDepositInfoForPrize.index].depositor.send(prize);
252         
253         proceedToNewStage(getCurrentStageByTime() + 1);
254     }
255 
256     //Добавить выплату в очередь
257     function push(address depositor, uint deposit, uint expect) private {
258         //Add the investor into the queue
259         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
260         assert(currentQueueSize <= queue.length); //Assert queue size is not corrupted
261         if(queue.length == currentQueueSize)
262             queue.push(dep);
263         else
264             queue[currentQueueSize] = dep;
265 
266         currentQueueSize++;
267     }
268 
269     //Информация о депозите
270     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
271         Deposit storage dep = queue[idx];
272         return (dep.depositor, dep.deposit, dep.expect);
273     }
274 
275     //Количество депозитов внесенное игроком
276     function getDepositsCount(address depositor) public view returns (uint) {
277         uint c = 0;
278         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
279             if(queue[i].depositor == depositor)
280                 c++;
281         }
282         return c;
283     }
284 
285     //Количество участников игры
286     function getQueueLength() public view returns (uint) {
287         return currentQueueSize - currentReceiverIndex;
288     }
289 
290     //Номер вклада в текущей очереди
291     function getDepositorMultiplier(address depositor) public view returns (uint) {
292         DepositCount storage c = depositsMade[depositor];
293         uint count = 0;
294         if(c.stage == getCurrentStageByTime())
295             count = c.count;
296         if(count < MULTIPLIERS.length)
297             return MULTIPLIERS[count];
298 
299         return MULTIPLIERS[MULTIPLIERS.length - 1];
300     }
301 
302     // Текущий этап игры
303     function getCurrentStageByTime() public view returns (int) {
304         return int(now - 17848 * 86400 - 16 * 3600 - 30 * 60) / (24 * 60 * 60);
305     }
306 
307     // Время начала следующей игры
308     function getNextStageStartTime() public view returns (uint) {
309         return 17848 * 86400 + 16 * 3600 + 30 * 60 + uint((getCurrentStageByTime() + 1) * 24 * 60 * 60); //старт 19:30
310     }
311 
312     //Информация об кандидате на приз
313     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
314         if(currentReceiverIndex <= lastDepositInfoForPrize.index && lastDepositInfoForPrize.index < currentQueueSize){
315             Deposit storage d = queue[lastDepositInfoForPrize.index];
316             addr = d.depositor;
317             timeLeft = int(lastDepositInfoForPrize.time + MAX_IDLE_TIME) - int(now);
318         }
319     }
320 }