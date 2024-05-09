1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 105%-150% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 0.1 ETH
11      - min 250000 gas limit
12      - max 30 gwei gas price
13      - you are added to a queue
14   2. Wait a little bit
15   3. ...
16   4. PROFIT! You have got 105-150%
17 
18   How is that?
19   1. The first investor in the queue (you will become the
20      first in some time) receives next investments until
21      it become 105-150% of his initial investment.
22   2. You will receive payments in several parts or all at once
23   3. Once you receive 105-150% of your initial investment you are
24      removed from the queue.
25   4. You can make multiple deposits
26   5. The balance of this contract should normally be 0 because
27      all the money are immediately go to payouts
28   6. The more deposits you make the more multiplier you get. See MULTIPLIERS var
29   7. If you are the last depositor (no deposits after you in 20 mins)
30      you get 5% of all the ether that were on the contract. Send 0 to withdraw it.
31      Do it BEFORE NEXT RESTART!
32   8. The contract automatically restarts each 24 hours at 18:00 GMT
33   9. Deposits will not be accepted 20 mins before next restart. But prize can be withdrawn.
34 
35 
36      So the last pays to the first (or to several first ones
37      if the deposit big enough) and the investors paid 111-141% are removed from the queue
38 
39                 new investor --|               brand new investor --|
40                  investor5     |                 new investor       |
41                  investor4     |     =======>      investor5        |
42                  investor3     |                   investor4        |
43     (part. paid) investor2    <|                   investor3        |
44     (fully paid) investor1   <-|                   investor2   <----|  (pay until full %)
45 
46 
47   Контракт Умножитель: возвращает 111%-141% от вашего депозита!
48   Автоматические выплаты!
49   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
50   Создан и проверен профессионалами!
51 
52   1. Пошлите любую ненулевую сумму на адрес контракта
53      - сумма от 0.01 до 0.1 ETH
54      - gas limit минимум 250000
55      - gas price максимум 30 gwei
56      - вы встанете в очередь
57   2. Немного подождите
58   3. ...
59   4. PROFIT! Вам пришло 105%-150% от вашего депозита.
60 
61   Как это возможно?
62   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
63      новых инвесторов до тех пор, пока не получит 105%-150% от своего депозита
64   2. Выплаты могут приходить несколькими частями или все сразу
65   3. Как только вы получаете 105%-150% от вашего депозита, вы удаляетесь из очереди
66   4. Вы можете делать несколько депозитов сразу
67   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
68      сразу же направляются на выплаты
69   6. Чем больше вы сделали депозитов, тем больший процент вы получаете на очередной депозит
70      Смотрите переменную MULTIPLIERS в контракте
71   7. Если вы последний вкладчик (после вас не сделан депозит в течение 20 минут), то вы можете
72      забрать призовой фонд - 5% от эфира, прошедшего через контракт. Пошлите 0 на контракт
73      с газом не менее 350000, чтобы его получить.
74   8. Контракт автоматически стартует каждые сутки в 21:00 MSK
75   9. За 20 минут до рестарта депозиты перестают приниматься. Но приз забрать можно.
76 
77 
78      Таким образом, последние платят первым, и инвесторы, достигшие выплат 105%-150% от депозита,
79      удаляются из очереди, уступая место остальным
80 
81               новый инвестор --|            совсем новый инвестор --|
82                  инвестор5     |                новый инвестор      |
83                  инвестор4     |     =======>      инвестор5        |
84                  инвестор3     |                   инвестор4        |
85  (част. выплата) инвестор2    <|                   инвестор3        |
86 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 105%-150%)
87 
88 */
89 
90 contract Nowhales {
91     //Address for tech expences
92     address constant private TECH = 0x86C1185CE646e549B13A6675C7a1DF073f3E3c0A;
93     //Address for promo expences
94     address constant private PROMO = 0xa3093FdE89050b3EAF6A9705f343757b4DfDCc4d;
95     //Percent for first multiplier donation
96     uint constant public TECH_PERCENT = 4;
97     uint constant public PROMO_PERCENT = 6;
98     uint constant public PRIZE_PERCENT = 5;
99     uint constant public MAX_INVESTMENT = 0.1 ether;
100     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.01 ether;
101     uint constant public MAX_IDLE_TIME = 20 minutes; //Maximum time the deposit should remain the last to receive prize
102 
103     //How many percent for your deposit to be multiplied
104     //Depends on number of deposits from specified address at this stage
105     //The more deposits the higher the multiplier
106     uint8[] MULTIPLIERS = [
107         105, //For first deposit made at this stage
108         110, //For second
109         150 //For third
110     ];
111 
112     //The deposit structure holds all the info about the deposit made
113     struct Deposit {
114         address depositor; //The depositor address
115         uint128 deposit;   //The deposit amount
116         uint128 expect;    //How much we should pay out (initially it is 105%-150% of deposit)
117     }
118 
119     struct DepositCount {
120         int128 stage;
121         uint128 count;
122     }
123 
124     struct LastDepositInfo {
125         uint128 index;
126         uint128 time;
127     }
128 
129     Deposit[] private queue;  //The queue
130     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
131     uint public currentQueueSize = 0; //The current size of queue (may be less than queue.length)
132     LastDepositInfo public lastDepositInfo; //The time last deposit made at
133 
134     uint public prizeAmount = 0; //Prize amount accumulated for the last depositor
135     int public stage = 0; //Number of contract runs
136     mapping(address => DepositCount) public depositsMade; //The number of deposits of different depositors
137 
138     constructor(){
139         //Initialize array to save gas to first depositor
140         //Remember - actual queue length is stored in currentQueueSize!
141         queue.push(Deposit(address(0x1),0,1));
142     }
143 
144     //This function receives all the deposits
145     //stores them and make immediate payouts
146     function () public payable {
147         //Prevent cheating with high gas prices.
148         require(tx.gasprice <= 30000000000 wei, "Gas price is too high!");
149 
150         //All these money will be distributed to current investors
151         if(msg.value > 0){
152             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
153             require(msg.value <= MAX_INVESTMENT, "The investment is too much!"); //Do not allow too big investments to stabilize payouts
154 
155             checkAndUpdateStage();
156 
157             //No new deposits 20 minutes before next restart, you should withdraw the prize
158             require(getStageStartTime(stage+1) >= now + MAX_IDLE_TIME);
159 
160             addDeposit(msg.sender, msg.value);
161 
162             //Pay to first investors in line
163             pay();
164         }else if(msg.value == 0){
165             withdrawPrize();
166         }
167     }
168 
169     //Used to pay to current investors
170     //Each new transaction processes 1 - 4+ investors in the head of queue
171     //depending on balance and gas left
172     function pay() private {
173         //Try to send all the money on contract to the first investors in line
174         uint balance = address(this).balance;
175         uint128 money = 0;
176         if(balance > prizeAmount) //The opposite is impossible, however the check will not do any harm
177             money = uint128(balance - prizeAmount);
178 
179         //We will do cycle on the queue
180         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
181 
182             Deposit storage dep = queue[i]; //get the info of the first investor
183 
184             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
185                 dep.depositor.send(dep.expect); //Send money to him
186                 money -= dep.expect;            //update money left
187 
188                 //this investor is fully paid, so remove him
189                 delete queue[i];
190             }else{
191                 //Here we don't have enough money so partially pay to investor
192                 dep.depositor.send(money); //Send to him everything we have
193                 dep.expect -= money;       //Update the expected amount
194                 break;                     //Exit cycle
195             }
196 
197             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
198                 break;                     //The next investor will process the line further
199         }
200 
201         currentReceiverIndex = i; //Update the index of the current first investor
202     }
203 
204     function addDeposit(address depositor, uint value) private {
205         //Count the number of the deposit at this stage
206         DepositCount storage c = depositsMade[depositor];
207         if(c.stage != stage){
208             c.stage = int128(stage);
209             c.count = 0;
210         }
211 
212         //If you are applying for the prize you should invest more than minimal amount
213         //Otherwize it doesn't count
214         if(value >= MIN_INVESTMENT_FOR_PRIZE)
215             lastDepositInfo = LastDepositInfo(uint128(currentQueueSize), uint128(now));
216 
217         //Compute the multiplier percent for this depositor
218         uint multiplier = getDepositorMultiplier(depositor);
219         //Add the investor into the queue. Mark that he expects to receive 111%-141% of deposit back
220         push(depositor, value, value*multiplier/100);
221 
222         //Increment number of deposits the depositors made this round
223         c.count++;
224 
225         //Save money for prize and father multiplier
226         prizeAmount += value*(PRIZE_PERCENT)/100;
227 
228         //Send small part to tech support
229         uint support = value*TECH_PERCENT/100;
230         TECH.send(support);
231         uint adv = value*PROMO_PERCENT/100;
232         PROMO.send(adv);
233 
234     }
235 
236     function checkAndUpdateStage() private{
237         int _stage = getCurrentStageByTime();
238 
239         require(_stage >= stage, "We should only go forward in time");
240 
241         if(_stage != stage){
242             proceedToNewStage(_stage);
243         }
244     }
245 
246     function proceedToNewStage(int _stage) private {
247         //Clean queue info
248         //The prize amount on the balance is left the same if not withdrawn
249         stage = _stage;
250         currentQueueSize = 0; //Instead of deleting queue just reset its length (gas economy)
251         currentReceiverIndex = 0;
252         delete lastDepositInfo;
253     }
254 
255     function withdrawPrize() private {
256         //You can withdraw prize only if the last deposit was more than MAX_IDLE_TIME ago
257         require(lastDepositInfo.time > 0 && lastDepositInfo.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
258         //Last depositor will receive prize only if it has not been fully paid
259         require(currentReceiverIndex <= lastDepositInfo.index, "The last depositor should still be in queue");
260 
261         uint balance = address(this).balance;
262         if(prizeAmount > balance) //Impossible but better check it
263             prizeAmount = balance;
264 
265         uint prize = prizeAmount;
266         queue[lastDepositInfo.index].depositor.send(prize);
267 
268         prizeAmount = 0;
269         proceedToNewStage(stage + 1);
270     }
271 
272     //Pushes investor to the queue
273     function push(address depositor, uint deposit, uint expect) private {
274         //Add the investor into the queue
275         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
276         assert(currentQueueSize <= queue.length); //Assert queue size is not corrupted
277         if(queue.length == currentQueueSize)
278             queue.push(dep);
279         else
280             queue[currentQueueSize] = dep;
281 
282         currentQueueSize++;
283     }
284 
285     //Get the deposit info by its index
286     //You can get deposit index from
287     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
288         Deposit storage dep = queue[idx];
289         return (dep.depositor, dep.deposit, dep.expect);
290     }
291 
292     //Get the count of deposits of specific investor
293     function getDepositsCount(address depositor) public view returns (uint) {
294         uint c = 0;
295         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
296             if(queue[i].depositor == depositor)
297                 c++;
298         }
299         return c;
300     }
301 
302     //Get all deposits (index, deposit, expect) of a specific investor
303     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
304         uint c = getDepositsCount(depositor);
305 
306         idxs = new uint[](c);
307         deposits = new uint128[](c);
308         expects = new uint128[](c);
309 
310         if(c > 0) {
311             uint j = 0;
312             for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
313                 Deposit storage dep = queue[i];
314                 if(dep.depositor == depositor){
315                     idxs[j] = i;
316                     deposits[j] = dep.deposit;
317                     expects[j] = dep.expect;
318                     j++;
319                 }
320             }
321         }
322     }
323 
324     //Get current queue size
325     function getQueueLength() public view returns (uint) {
326         return currentQueueSize - currentReceiverIndex;
327     }
328 
329     //Get current depositors multiplier percent at this stage
330     function getDepositorMultiplier(address depositor) public view returns (uint) {
331         DepositCount storage c = depositsMade[depositor];
332         uint count = 0;
333         if(c.stage == getCurrentStageByTime())
334             count = c.count;
335         if(count < MULTIPLIERS.length)
336             return MULTIPLIERS[count];
337 
338         return MULTIPLIERS[MULTIPLIERS.length - 1];
339     }
340 
341     function getCurrentStageByTime() public view returns (int) {
342         return int(now - 18 hours) / 1 days - 17847; //Start is 12/11/2018 21:00 GMT+3
343     }
344 
345     function getStageStartTime(int _stage) public pure returns (uint) {
346         return 18 hours + uint(_stage + 17847)*1 days;
347     }
348 
349     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
350         //prevent exception, just return 0 for absent candidate
351         if(currentReceiverIndex <= lastDepositInfo.index && lastDepositInfo.index < currentQueueSize){
352             Deposit storage d = queue[lastDepositInfo.index];
353             addr = d.depositor;
354             timeLeft = int(lastDepositInfo.time + MAX_IDLE_TIME) - int(now);
355         }
356     }
357 
358 }