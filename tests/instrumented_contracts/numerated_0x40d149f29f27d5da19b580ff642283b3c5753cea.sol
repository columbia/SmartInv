1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 111%-141% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 10 ETH
11      - min 250000 gas limit
12      - max 50 gwei gas price
13      - you are added to a queue
14   2. Wait a little bit
15   3. ...
16   4. PROFIT! You have got 111-141%
17 
18   How is that?
19   1. The first investor in the queue (you will become the
20      first in some time) receives next investments until
21      it become 111-141% of his initial investment.
22   2. You will receive payments in several parts or all at once
23   3. Once you receive 111-141% of your initial investment you are
24      removed from the queue.
25   4. You can make multiple deposits
26   5. The balance of this contract should normally be 0 because
27      all the money are immediately go to payouts
28   6. The more deposits you make the more multiplier you get. See MULTIPLIERS var
29   7. If you are the last depositor (no deposits after you in 20 mins)
30      you get 2% of all the ether that were on the contract. Send 0 to withdraw it.
31      Do it BEFORE NEXT RESTART!
32   8. The contract automatically restarts each 24 hours at 17:00 GMT
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
53      - сумма от 0.01 до 10 ETH
54      - gas limit минимум 250000
55      - gas price максимум 50 gwei
56      - вы встанете в очередь
57   2. Немного подождите
58   3. ...
59   4. PROFIT! Вам пришло 111%-141% от вашего депозита.
60 
61   Как это возможно?
62   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
63      новых инвесторов до тех пор, пока не получит 111%-141% от своего депозита
64   2. Выплаты могут приходить несколькими частями или все сразу
65   3. Как только вы получаете 111%-141% от вашего депозита, вы удаляетесь из очереди
66   4. Вы можете делать несколько депозитов сразу
67   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
68      сразу же направляются на выплаты
69   6. Чем больше вы сделали депозитов, тем больший процент вы получаете на очередной депозит
70      Смотрите переменную MULTIPLIERS в контракте
71   7. Если вы последний вкладчик (после вас не сделан депозит в течение 20 минут), то вы можете
72      забрать призовой фонд - 2% от эфира, прошедшего через контракт. Пошлите 0 на контракт
73      с газом не менее 350000, чтобы его получить.
74   8. Контракт автоматически стартует каждые сутки в 20:00 MSK
75   9. За 20 минут до рестарта депозиты перестают приниматься. Но приз забрать можно.
76 
77 
78      Таким образом, последние платят первым, и инвесторы, достигшие выплат 111%-141% от депозита,
79      удаляются из очереди, уступая место остальным
80 
81               новый инвестор --|            совсем новый инвестор --|
82                  инвестор5     |                новый инвестор      |
83                  инвестор4     |     =======>      инвестор5        |
84                  инвестор3     |                   инвестор4        |
85  (част. выплата) инвестор2    <|                   инвестор3        |
86 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 111%-141%)
87 
88 */
89 
90 contract Multipliers {
91     //Address of old Multiplier
92     address constant private FATHER = 0x7CDfA222f37f5C4CCe49b3bBFC415E8C911D1cD8;
93     //Address for tech expences
94     address constant private TECH = 0xDb058D036768Cfa9a94963f99161e3c94aD6f5dA;
95     //Address for promo expences
96     address constant private PROMO = 0xdA149b17C154e964456553C749B7B4998c152c9E;
97     //Percent for first multiplier donation
98     uint constant public FATHER_PERCENT = 1;
99     uint constant public TECH_PERCENT = 2;
100     uint constant public PROMO_PERCENT = 2;
101     uint constant public PRIZE_PERCENT = 2;
102     uint constant public MAX_INVESTMENT = 10 ether;
103     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.05 ether;
104     uint constant public MAX_IDLE_TIME = 20 minutes; //Maximum time the deposit should remain the last to receive prize
105 
106     //How many percent for your deposit to be multiplied
107     //Depends on number of deposits from specified address at this stage
108     //The more deposits the higher the multiplier
109     uint8[] MULTIPLIERS = [
110         111, //For first deposit made at this stage
111         113, //For second
112         117, //For third
113         121, //For forth
114         125, //For fifth
115         130, //For sixth
116         135, //For seventh
117         141  //For eighth and on
118     ];
119 
120     //The deposit structure holds all the info about the deposit made
121     struct Deposit {
122         address depositor; //The depositor address
123         uint128 deposit;   //The deposit amount
124         uint128 expect;    //How much we should pay out (initially it is 111%-141% of deposit)
125     }
126 
127     struct DepositCount {
128         int128 stage;
129         uint128 count;
130     }
131 
132     struct LastDepositInfo {
133         uint128 index;
134         uint128 time;
135     }
136 
137     Deposit[] private queue;  //The queue
138     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
139     uint public currentQueueSize = 0; //The current size of queue (may be less than queue.length)
140     LastDepositInfo public lastDepositInfo; //The time last deposit made at
141 
142     uint public prizeAmount = 0; //Prize amount accumulated for the last depositor
143     int public stage = 0; //Number of contract runs
144     mapping(address => DepositCount) public depositsMade; //The number of deposits of different depositors
145 
146     constructor(){
147         //Initialize array to save gas to first depositor
148         //Remember - actual queue length is stored in currentQueueSize!
149         queue.push(Deposit(address(0x1),0,1));
150     }
151 
152     //This function receives all the deposits
153     //stores them and make immediate payouts
154     function () public payable {
155         //Prevent cheating with high gas prices. Money from first multiplier are allowed to enter with any gas price
156         //because they do not enter the queue
157         require(msg.sender == FATHER || tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
158 
159         //If money are from first multiplier, just add them to the balance
160         //All these money will be distributed to current investors
161         if(msg.value > 0 && msg.sender != FATHER){
162             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
163             require(msg.value <= MAX_INVESTMENT, "The investment is too much!"); //Do not allow too big investments to stabilize payouts
164 
165             checkAndUpdateStage();
166 
167             //No new deposits 20 minutes before next restart, you should withdraw the prize
168             require(getStageStartTime(stage+1) >= now + MAX_IDLE_TIME);
169 
170             addDeposit(msg.sender, msg.value);
171 
172             //Pay to first investors in line
173             pay();
174         }else if(msg.value == 0){
175             withdrawPrize();
176         }
177     }
178 
179     //Used to pay to current investors
180     //Each new transaction processes 1 - 4+ investors in the head of queue
181     //depending on balance and gas left
182     function pay() private {
183         //Try to send all the money on contract to the first investors in line
184         uint balance = address(this).balance;
185         uint128 money = 0;
186         if(balance > prizeAmount) //The opposite is impossible, however the check will not do any harm
187             money = uint128(balance - prizeAmount);
188 
189         //We will do cycle on the queue
190         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
191 
192             Deposit storage dep = queue[i]; //get the info of the first investor
193 
194             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
195                 dep.depositor.send(dep.expect); //Send money to him
196                 money -= dep.expect;            //update money left
197 
198                 //this investor is fully paid, so remove him
199                 delete queue[i];
200             }else{
201                 //Here we don't have enough money so partially pay to investor
202                 dep.depositor.send(money); //Send to him everything we have
203                 dep.expect -= money;       //Update the expected amount
204                 break;                     //Exit cycle
205             }
206 
207             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
208                 break;                     //The next investor will process the line further
209         }
210 
211         currentReceiverIndex = i; //Update the index of the current first investor
212     }
213 
214     function addDeposit(address depositor, uint value) private {
215         //Count the number of the deposit at this stage
216         DepositCount storage c = depositsMade[depositor];
217         if(c.stage != stage){
218             c.stage = int128(stage);
219             c.count = 0;
220         }
221 
222         //If you are applying for the prize you should invest more than minimal amount
223         //Otherwize it doesn't count
224         if(value >= MIN_INVESTMENT_FOR_PRIZE)
225             lastDepositInfo = LastDepositInfo(uint128(currentQueueSize), uint128(now));
226 
227         //Compute the multiplier percent for this depositor
228         uint multiplier = getDepositorMultiplier(depositor);
229         //Add the investor into the queue. Mark that he expects to receive 111%-141% of deposit back
230         push(depositor, value, value*multiplier/100);
231 
232         //Increment number of deposits the depositors made this round
233         c.count++;
234 
235         //Save money for prize and father multiplier
236         prizeAmount += value*(FATHER_PERCENT + PRIZE_PERCENT)/100;
237 
238         //Send small part to tech support
239         uint support = value*TECH_PERCENT/100;
240         TECH.send(support);
241         uint adv = value*PROMO_PERCENT/100;
242         PROMO.send(adv);
243 
244     }
245 
246     function checkAndUpdateStage() private{
247         int _stage = getCurrentStageByTime();
248 
249         require(_stage >= stage, "We should only go forward in time");
250 
251         if(_stage != stage){
252             proceedToNewStage(_stage);
253         }
254     }
255 
256     function proceedToNewStage(int _stage) private {
257         //Clean queue info
258         //The prize amount on the balance is left the same if not withdrawn
259         stage = _stage;
260         currentQueueSize = 0; //Instead of deleting queue just reset its length (gas economy)
261         currentReceiverIndex = 0;
262         delete lastDepositInfo;
263     }
264 
265     function withdrawPrize() private {
266         //You can withdraw prize only if the last deposit was more than MAX_IDLE_TIME ago
267         require(lastDepositInfo.time > 0 && lastDepositInfo.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
268         //Last depositor will receive prize only if it has not been fully paid
269         require(currentReceiverIndex <= lastDepositInfo.index, "The last depositor should still be in queue");
270 
271         uint balance = address(this).balance;
272         if(prizeAmount > balance) //Impossible but better check it
273             prizeAmount = balance;
274 
275         //Send donation to the first multiplier for it to spin faster
276         //It already contains all the sum, so we must split for father and last depositor only
277         uint donation = prizeAmount*FATHER_PERCENT/(FATHER_PERCENT + PRIZE_PERCENT);
278         if(donation > 10 ether) //The father contract accepts up to 10 ether
279             donation = 10 ether;
280 
281         //If the .call fails then ether will just stay on the contract to be distributed to
282         //the queue at the next stage
283         require(gasleft() >= 300000, "We need gas for the father contract");
284         FATHER.call.value(donation).gas(250000)();
285 
286         uint prize = prizeAmount - donation;
287         queue[lastDepositInfo.index].depositor.send(prize);
288 
289         prizeAmount = 0;
290         proceedToNewStage(stage + 1);
291     }
292 
293     //Pushes investor to the queue
294     function push(address depositor, uint deposit, uint expect) private {
295         //Add the investor into the queue
296         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
297         assert(currentQueueSize <= queue.length); //Assert queue size is not corrupted
298         if(queue.length == currentQueueSize)
299             queue.push(dep);
300         else
301             queue[currentQueueSize] = dep;
302 
303         currentQueueSize++;
304     }
305 
306     //Get the deposit info by its index
307     //You can get deposit index from
308     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
309         Deposit storage dep = queue[idx];
310         return (dep.depositor, dep.deposit, dep.expect);
311     }
312 
313     //Get the count of deposits of specific investor
314     function getDepositsCount(address depositor) public view returns (uint) {
315         uint c = 0;
316         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
317             if(queue[i].depositor == depositor)
318                 c++;
319         }
320         return c;
321     }
322 
323     //Get all deposits (index, deposit, expect) of a specific investor
324     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
325         uint c = getDepositsCount(depositor);
326 
327         idxs = new uint[](c);
328         deposits = new uint128[](c);
329         expects = new uint128[](c);
330 
331         if(c > 0) {
332             uint j = 0;
333             for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
334                 Deposit storage dep = queue[i];
335                 if(dep.depositor == depositor){
336                     idxs[j] = i;
337                     deposits[j] = dep.deposit;
338                     expects[j] = dep.expect;
339                     j++;
340                 }
341             }
342         }
343     }
344 
345     //Get current queue size
346     function getQueueLength() public view returns (uint) {
347         return currentQueueSize - currentReceiverIndex;
348     }
349 
350     //Get current depositors multiplier percent at this stage
351     function getDepositorMultiplier(address depositor) public view returns (uint) {
352         DepositCount storage c = depositsMade[depositor];
353         uint count = 0;
354         if(c.stage == getCurrentStageByTime())
355             count = c.count;
356         if(count < MULTIPLIERS.length)
357             return MULTIPLIERS[count];
358 
359         return MULTIPLIERS[MULTIPLIERS.length - 1];
360     }
361 
362     function getCurrentStageByTime() public view returns (int) {
363         return int(now - 17 hours) / 1 days - 17844; //Start is 09/11/2018 20:00 GMT+3
364     }
365 
366     function getStageStartTime(int _stage) public pure returns (uint) {
367         return 17 hours + uint(_stage + 17844)*1 days;
368     }
369 
370     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
371         //prevent exception, just return 0 for absent candidate
372         if(currentReceiverIndex <= lastDepositInfo.index && lastDepositInfo.index < currentQueueSize){
373             Deposit storage d = queue[lastDepositInfo.index];
374             addr = d.depositor;
375             timeLeft = int(lastDepositInfo.time + MAX_IDLE_TIME) - int(now);
376         }
377     }
378 
379 }