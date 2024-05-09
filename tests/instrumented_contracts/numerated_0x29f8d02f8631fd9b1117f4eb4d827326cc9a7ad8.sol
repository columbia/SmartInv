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
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 111-141%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 111-141% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 111-141% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27   6. The more deposits you make the more multiplier you get. See MULTIPLIERS var
28   7. If you are the last depositor (no deposits after you in 20 mins)
29      you get 2% of all the ether that were on the contract. Send 0 to withdraw it.
30      Do it BEFORE NEXT RESTART!
31   8. The contract automatically restarts each 24 hours at 17:00 GMT
32   9. Deposits will not be accepted 20 mins before next restart. But prize can be withdrawn.
33 
34 
35      So the last pays to the first (or to several first ones
36      if the deposit big enough) and the investors paid 111-141% are removed from the queue
37 
38                 new investor --|               brand new investor --|
39                  investor5     |                 new investor       |
40                  investor4     |     =======>      investor5        |
41                  investor3     |                   investor4        |
42     (part. paid) investor2    <|                   investor3        |
43     (fully paid) investor1   <-|                   investor2   <----|  (pay until full %)
44 
45 
46   Контракт Умножитель: возвращает 111%-141% от вашего депозита!
47   Автоматические выплаты!
48   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
49   Создан и проверен профессионалами!
50 
51   1. Пошлите любую ненулевую сумму на адрес контракта
52      - сумма от 0.01 до 10 ETH
53      - gas limit минимум 250000
54      - вы встанете в очередь
55   2. Немного подождите
56   3. ...
57   4. PROFIT! Вам пришло 111%-141% от вашего депозита.
58 
59   Как это возможно?
60   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
61      новых инвесторов до тех пор, пока не получит 111%-141% от своего депозита
62   2. Выплаты могут приходить несколькими частями или все сразу
63   3. Как только вы получаете 111%-141% от вашего депозита, вы удаляетесь из очереди
64   4. Вы можете делать несколько депозитов сразу
65   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
66      сразу же направляются на выплаты
67   6. Чем больше вы сделали депозитов, тем больший процент вы получаете на очередной депозит
68      Смотрите переменную MULTIPLIERS в контракте
69   7. Если вы последний вкладчик (после вас не сделан депозит в течение 20 минут), то вы можете
70      забрать призовой фонд - 2% от эфира, прошедшего через контракт. Пошлите 0 на контракт
71      с газом не менее 350000, чтобы его получить.
72   8. Контракт автоматически стартует каждые сутки в 20:00 MSK
73   9. За 20 минут до рестарта депозиты перестают приниматься. Но приз забрать можно.
74 
75 
76      Таким образом, последние платят первым, и инвесторы, достигшие выплат 111%-141% от депозита,
77      удаляются из очереди, уступая место остальным
78 
79               новый инвестор --|            совсем новый инвестор --|
80                  инвестор5     |                новый инвестор      |
81                  инвестор4     |     =======>      инвестор5        |
82                  инвестор3     |                   инвестор4        |
83  (част. выплата) инвестор2    <|                   инвестор3        |
84 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 111%-141%)
85 
86 */
87 
88 contract Multipliers {
89     //Address of old Multiplier
90     address constant private FATHER = 0x7CDfA222f37f5C4CCe49b3bBFC415E8C911D1cD8;
91     //Address for tech expences
92     address constant private TECH = 0xDb058D036768Cfa9a94963f99161e3c94aD6f5dA;
93     //Address for promo expences
94     address constant private PROMO = 0xdA149b17C154e964456553C749B7B4998c152c9E;
95     //Percent for first multiplier donation
96     uint constant public FATHER_PERCENT = 1;
97     uint constant public TECH_PERCENT = 2;
98     uint constant public PROMO_PERCENT = 2;
99     uint constant public PRIZE_PERCENT = 2;
100     uint constant public MAX_INVESTMENT = 10 ether;
101     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.05 ether;
102     uint constant public MAX_IDLE_TIME = 20 minutes; //Maximum time the deposit should remain the last to receive prize
103 
104     //How many percent for your deposit to be multiplied
105     //Depends on number of deposits from specified address at this stage
106     //The more deposits the higher the multiplier
107     uint8[] MULTIPLIERS = [
108         111, //For first deposit made at this stage
109         113, //For second
110         117, //For third
111         121, //For forth
112         125, //For fifth
113         130, //For sixth
114         135, //For seventh
115         141  //For eighth and on
116     ];
117 
118     //The deposit structure holds all the info about the deposit made
119     struct Deposit {
120         address depositor; //The depositor address
121         uint128 deposit;   //The deposit amount
122         uint128 expect;    //How much we should pay out (initially it is 111%-141% of deposit)
123     }
124 
125     struct DepositCount {
126         int128 stage;
127         uint128 count;
128     }
129 
130     struct LastDepositInfo {
131         uint128 index;
132         uint128 time;
133     }
134 
135     Deposit[] private queue;  //The queue
136     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
137     uint public currentQueueSize = 0; //The current size of queue (may be less than queue.length)
138     LastDepositInfo public lastDepositInfo; //The time last deposit made at
139 
140     uint public prizeAmount = 0; //Prize amount accumulated for the last depositor
141     int public stage = 0; //Number of contract runs
142     mapping(address => DepositCount) public depositsMade; //The number of deposits of different depositors
143 
144     //This function receives all the deposits
145     //stores them and make immediate payouts
146     function () public payable {
147         //If money are from first multiplier, just add them to the balance
148         //All these money will be distributed to current investors
149         if(msg.value > 0 && msg.sender != FATHER){
150             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
151             require(msg.value <= MAX_INVESTMENT, "The investment is too much!"); //Do not allow too big investments to stabilize payouts
152 
153             checkAndUpdateStage();
154 
155             //No new deposits 20 minutes before next restart, you should withdraw the prize
156             require(getStageStartTime(stage+1) >= now + MAX_IDLE_TIME);
157 
158             addDeposit(msg.sender, msg.value);
159 
160             //Pay to first investors in line
161             pay();
162         }else if(msg.value == 0){
163             withdrawPrize();
164         }
165     }
166 
167     //Used to pay to current investors
168     //Each new transaction processes 1 - 4+ investors in the head of queue
169     //depending on balance and gas left
170     function pay() private {
171         //Try to send all the money on contract to the first investors in line
172         uint balance = address(this).balance;
173         uint128 money = 0;
174         if(balance > prizeAmount) //The opposite is impossible, however the check will not do any harm
175             money = uint128(balance - prizeAmount);
176 
177         //We will do cycle on the queue
178         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
179 
180             Deposit storage dep = queue[i]; //get the info of the first investor
181 
182             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
183                 dep.depositor.send(dep.expect); //Send money to him
184                 money -= dep.expect;            //update money left
185 
186                 //this investor is fully paid, so remove him
187                 delete queue[i];
188             }else{
189                 //Here we don't have enough money so partially pay to investor
190                 dep.depositor.send(money); //Send to him everything we have
191                 dep.expect -= money;       //Update the expected amount
192                 break;                     //Exit cycle
193             }
194 
195             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
196                 break;                     //The next investor will process the line further
197         }
198 
199         currentReceiverIndex = i; //Update the index of the current first investor
200     }
201 
202     function addDeposit(address depositor, uint value) private {
203         //Count the number of the deposit at this stage
204         DepositCount storage c = depositsMade[depositor];
205         if(c.stage != stage){
206             c.stage = int128(stage);
207             c.count = 0;
208         }
209 
210         //If you are applying for the prize you should invest more than minimal amount
211         //Otherwize it doesn't count
212         if(value >= MIN_INVESTMENT_FOR_PRIZE)
213             lastDepositInfo = LastDepositInfo(uint128(currentQueueSize), uint128(now));
214 
215         //Compute the multiplier percent for this depositor
216         uint multiplier = getDepositorMultiplier(depositor);
217         //Add the investor into the queue. Mark that he expects to receive 111%-141% of deposit back
218         push(depositor, value, value*multiplier/100);
219 
220         //Increment number of deposits the depositors made this round
221         c.count++;
222 
223         //Save money for prize and father multiplier
224         prizeAmount += value*(FATHER_PERCENT + PRIZE_PERCENT)/100;
225 
226         //Send small part to tech support
227         uint support = value*TECH_PERCENT/100;
228         TECH.send(support);
229         uint adv = value*PROMO_PERCENT/100;
230         PROMO.send(adv);
231 
232     }
233 
234     function checkAndUpdateStage() private{
235         int _stage = getCurrentStageByTime();
236 
237         require(_stage >= stage, "We should only go forward in time");
238 
239         if(_stage != stage){
240             proceedToNewStage(_stage);
241         }
242     }
243 
244     function proceedToNewStage(int _stage) private {
245         //Clean queue info
246         //The prize amount on the balance is left the same if not withdrawn
247         stage = _stage;
248         currentQueueSize = 0; //Instead of deleting queue just reset its length (gas economy)
249         currentReceiverIndex = 0;
250         delete lastDepositInfo;
251     }
252 
253     function withdrawPrize() private {
254         //You can withdraw prize only if the last deposit was more than MAX_IDLE_TIME ago
255         require(lastDepositInfo.time > 0 && lastDepositInfo.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
256         //Last depositor will receive prize only if it has not been fully paid
257         require(currentReceiverIndex <= lastDepositInfo.index, "The last depositor should still be in queue");
258 
259         uint balance = address(this).balance;
260         if(prizeAmount > balance) //Impossible but better check it
261             prizeAmount = balance;
262 
263         //Send donation to the first multiplier for it to spin faster
264         //It already contains all the sum, so we must split for father and last depositor only
265         uint donation = prizeAmount*FATHER_PERCENT/(FATHER_PERCENT + PRIZE_PERCENT);
266         if(donation > 10 ether) //The father contract accepts up to 10 ether
267             donation = 10 ether;
268 
269         //If the .call fails then ether will just stay on the contract to be distributed to
270         //the queue at the next stage
271         require(gasleft() >= 300000, "We need gas for the father contract");
272         FATHER.call.value(donation).gas(250000)();
273 
274         uint prize = prizeAmount - donation;
275         queue[lastDepositInfo.index].depositor.send(prize);
276 
277         prizeAmount = 0;
278         proceedToNewStage(stage + 1);
279     }
280 
281     //Pushes investor to the queue
282     function push(address depositor, uint deposit, uint expect) private {
283         //Add the investor into the queue
284         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
285         assert(currentQueueSize <= queue.length); //Assert queue size is not corrupted
286         if(queue.length == currentQueueSize)
287             queue.push(dep);
288         else
289             queue[currentQueueSize] = dep;
290 
291         currentQueueSize++;
292     }
293 
294     //Get the deposit info by its index
295     //You can get deposit index from
296     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
297         Deposit storage dep = queue[idx];
298         return (dep.depositor, dep.deposit, dep.expect);
299     }
300 
301     //Get the count of deposits of specific investor
302     function getDepositsCount(address depositor) public view returns (uint) {
303         uint c = 0;
304         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
305             if(queue[i].depositor == depositor)
306                 c++;
307         }
308         return c;
309     }
310 
311     //Get all deposits (index, deposit, expect) of a specific investor
312     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
313         uint c = getDepositsCount(depositor);
314 
315         idxs = new uint[](c);
316         deposits = new uint128[](c);
317         expects = new uint128[](c);
318 
319         if(c > 0) {
320             uint j = 0;
321             for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
322                 Deposit storage dep = queue[i];
323                 if(dep.depositor == depositor){
324                     idxs[j] = i;
325                     deposits[j] = dep.deposit;
326                     expects[j] = dep.expect;
327                     j++;
328                 }
329             }
330         }
331     }
332 
333     //Get current queue size
334     function getQueueLength() public view returns (uint) {
335         return currentQueueSize - currentReceiverIndex;
336     }
337 
338     //Get current depositors multiplier percent at this stage
339     function getDepositorMultiplier(address depositor) public view returns (uint) {
340         DepositCount storage c = depositsMade[depositor];
341         uint count = 0;
342         if(c.stage == getCurrentStageByTime())
343             count = c.count;
344         if(count < MULTIPLIERS.length)
345             return MULTIPLIERS[count];
346 
347         return MULTIPLIERS[MULTIPLIERS.length - 1];
348     }
349 
350     function getCurrentStageByTime() public view returns (int) {
351         return int(now - 17 hours) / 1 days - 17837; //Start is 02/11/2018 20:00 GMT+3
352     }
353 
354     function getStageStartTime(int _stage) public pure returns (uint) {
355         return 17 hours + uint(_stage + 17837)*1 days;
356     }
357 
358     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
359         //prevent exception, just return 0 for absent candidate
360         if(currentReceiverIndex <= lastDepositInfo.index && lastDepositInfo.index < currentQueueSize){
361             Deposit storage d = queue[lastDepositInfo.index];
362             addr = d.depositor;
363             timeLeft = int(lastDepositInfo.time + MAX_IDLE_TIME) - int(now);
364         }
365     }
366 
367 }