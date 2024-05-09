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
28   7. If you are the last depositor (no deposits after you in 30 mins)
29      you get 2% of all the ether that were on the contract. Send 0 to withdraw it.
30      Do it BEFORE NEXT RESTART!
31   8. The contract automatically restarts each 24 hours at 17:00 GMT
32 
33 
34      So the last pays to the first (or to several first ones
35      if the deposit big enough) and the investors paid 111-141% are removed from the queue
36 
37                 new investor --|               brand new investor --|
38                  investor5     |                 new investor       |
39                  investor4     |     =======>      investor5        |
40                  investor3     |                   investor4        |
41     (part. paid) investor2    <|                   investor3        |
42     (fully paid) investor1   <-|                   investor2   <----|  (pay until full %)
43 
44 
45   Контракт Умножитель: возвращает 111%-141% от вашего депозита!
46   Автоматические выплаты!
47   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
48   Создан и проверен профессионалами!
49 
50   1. Пошлите любую ненулевую сумму на адрес контракта
51      - сумма от 0.01 до 10 ETH
52      - gas limit минимум 250000
53      - вы встанете в очередь
54   2. Немного подождите
55   3. ...
56   4. PROFIT! Вам пришло 111%-141% от вашего депозита.
57 
58   Как это возможно?
59   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
60      новых инвесторов до тех пор, пока не получит 111%-141% от своего депозита
61   2. Выплаты могут приходить несколькими частями или все сразу
62   3. Как только вы получаете 111%-141% от вашего депозита, вы удаляетесь из очереди
63   4. Вы можете делать несколько депозитов сразу
64   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
65      сразу же направляются на выплаты
66   6. Чем больше вы сделали депозитов, тем больший процент вы получаете на очередной депозит
67      Смотрите переменную MULTIPLIERS в контракте
68   7. Если вы последний вкладчик (после вас не сделан депозит в течение 30 минут), то вы можете
69      забрать призовой фонд - 2% от эфира, прошедшего через контракт. Пошлите 0 на контракт
70      с газом не менее 350000, чтобы его получить.
71   8. Контракт автоматически стартует каждые сутки в 20:00 MSK
72 
73 
74      Таким образом, последние платят первым, и инвесторы, достигшие выплат 111%-141% от депозита,
75      удаляются из очереди, уступая место остальным
76 
77               новый инвестор --|            совсем новый инвестор --|
78                  инвестор5     |                новый инвестор      |
79                  инвестор4     |     =======>      инвестор5        |
80                  инвестор3     |                   инвестор4        |
81  (част. выплата) инвестор2    <|                   инвестор3        |
82 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 111%-141%)
83 
84 */
85 
86 contract Multipliers {
87     //Address of old Multiplier
88     address constant private FATHER = 0x7CDfA222f37f5C4CCe49b3bBFC415E8C911D1cD8;
89     //Address for tech expences
90     address constant private TECH = 0xDb058D036768Cfa9a94963f99161e3c94aD6f5dA;
91     //Address for promo expences
92     address constant private PROMO = 0xdA149b17C154e964456553C749B7B4998c152c9E;
93     //Percent for first multiplier donation
94     uint constant public FATHER_PERCENT = 1;
95     uint constant public TECH_PERCENT = 2;
96     uint constant public PROMO_PERCENT = 2;
97     uint constant public PRIZE_PERCENT = 2;
98     uint constant public MAX_INVESTMENT = 10 ether;
99     uint constant public MIN_INVESTMENT_FOR_PRIZE = 0.05 ether;
100     uint constant public MAX_IDLE_TIME = 30 minutes; //Maximum time the deposit should remain the last to receive prize
101 
102     //How many percent for your deposit to be multiplied
103     //Depends on number of deposits from specified address at this stage
104     //The more deposits the higher the multiplier
105     uint8[] MULTIPLIERS = [
106         111, //For first deposit made at this stage
107         113, //For second
108         117, //For third
109         121, //For forth
110         125, //For fifth
111         130, //For sixth
112         135, //For seventh
113         141  //For eighth and on
114     ];
115 
116     //The deposit structure holds all the info about the deposit made
117     struct Deposit {
118         address depositor; //The depositor address
119         uint128 deposit;   //The deposit amount
120         uint128 expect;    //How much we should pay out (initially it is 111%-141% of deposit)
121     }
122 
123     struct DepositCount {
124         int128 stage;
125         uint128 count;
126     }
127 
128     struct LastDepositInfo {
129         uint128 index;
130         uint128 time;
131     }
132 
133     Deposit[] private queue;  //The queue
134     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
135     LastDepositInfo public lastDepositInfo; //The time last deposit made at
136 
137     uint public prizeAmount = 0; //Prize amount accumulated for the last depositor
138     int public stage = 0; //Number of contract runs
139     mapping(address => DepositCount) public depositsMade; //The number of deposits of different depositors
140 
141     //This function receives all the deposits
142     //stores them and make immediate payouts
143     function () public payable {
144         //If money are from first multiplier, just add them to the balance
145         //All these money will be distributed to current investors
146         if(msg.value > 0 && msg.sender != FATHER){
147             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
148             require(msg.value <= MAX_INVESTMENT, "The investment is too much!"); //Do not allow too big investments to stabilize payouts
149 
150             checkAndUpdateStage();
151 
152             addDeposit(msg.sender, msg.value);
153 
154             //Pay to first investors in line
155             pay();
156         }else if(msg.value == 0){
157             withdrawPrize();
158         }
159     }
160 
161     //Used to pay to current investors
162     //Each new transaction processes 1 - 4+ investors in the head of queue
163     //depending on balance and gas left
164     function pay() private {
165         //Try to send all the money on contract to the first investors in line
166         uint balance = address(this).balance;
167         uint128 money = 0;
168         if(balance > prizeAmount) //The opposite is impossible, however the check will not do any harm
169             money = uint128(balance - prizeAmount);
170 
171         //We will do cycle on the queue
172         for(uint i=currentReceiverIndex; i<queue.length; i++){
173 
174             Deposit storage dep = queue[i]; //get the info of the first investor
175 
176             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
177                 dep.depositor.send(dep.expect); //Send money to him
178                 money -= dep.expect;            //update money left
179 
180                 //this investor is fully paid, so remove him
181                 delete queue[i];
182             }else{
183                 //Here we don't have enough money so partially pay to investor
184                 dep.depositor.send(money); //Send to him everything we have
185                 dep.expect -= money;       //Update the expected amount
186                 break;                     //Exit cycle
187             }
188 
189             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
190                 break;                     //The next investor will process the line further
191         }
192 
193         currentReceiverIndex = i; //Update the index of the current first investor
194     }
195 
196     function addDeposit(address depositor, uint value) private {
197         //Count the number of the deposit at this stage
198         DepositCount storage c = depositsMade[depositor];
199         if(c.stage != stage){
200             c.stage = int128(stage);
201             c.count = 0;
202         }
203 
204         //If you are applying for the prize you should invest more than minimal amount
205         //Otherwize it doesn't count
206         if(value >= MIN_INVESTMENT_FOR_PRIZE)
207             lastDepositInfo = LastDepositInfo(uint128(queue.length), uint128(now));
208 
209         //Compute the multiplier percent for this depositor
210         uint multiplier = getDepositorMultiplier(depositor);
211         //Add the investor into the queue. Mark that he expects to receive 111%-141% of deposit back
212         queue.push(Deposit(depositor, uint128(value), uint128(value*multiplier/100)));
213 
214         //Increment number of deposits the depositors made this round
215         c.count++;
216 
217         //Save money for prize and father multiplier
218         prizeAmount += value*(FATHER_PERCENT + PRIZE_PERCENT)/100;
219 
220         //Send small part to tech support
221         uint support = value*TECH_PERCENT/100;
222         TECH.send(support);
223         uint adv = value*PROMO_PERCENT/100;
224         PROMO.send(adv);
225 
226     }
227 
228     function checkAndUpdateStage() private{
229         int _stage = getCurrentStageByTime();
230 
231         require(_stage >= stage, "We should only go forward in time");
232 
233         if(_stage != stage){
234             proceedToNewStage(_stage);
235         }
236     }
237 
238     function proceedToNewStage(int _stage) private {
239         //Clean queue info
240         //The prize amount on the balance is left the same if not withdrawn
241         stage = _stage;
242         delete queue;
243         currentReceiverIndex = 0;
244         delete lastDepositInfo;
245     }
246 
247     function withdrawPrize() private {
248         //You can withdraw prize only if the last deposit was more than MAX_IDLE_TIME ago
249         require(lastDepositInfo.time > 0 && lastDepositInfo.time <= now - MAX_IDLE_TIME, "The last depositor is not confirmed yet");
250         //Last depositor will receive prize only if it has not been fully paid
251         require(currentReceiverIndex <= lastDepositInfo.index, "The last depositor should still be in queue");
252 
253         uint balance = address(this).balance;
254         if(prizeAmount > balance) //Impossible but better check it
255             prizeAmount = balance;
256 
257         //Send donation to the first multiplier for it to spin faster
258         //It already contains all the sum, so we must split for father and last depositor only
259         //If the .call fails then ether will just stay on the contract to be distributed to
260         //the queue at the next stage
261         uint donation = prizeAmount*FATHER_PERCENT/(FATHER_PERCENT + PRIZE_PERCENT);
262         require(gasleft() >= 250000, "We need gas for the father contract");
263         FATHER.call.value(donation).gas(gasleft())();
264 
265         uint prize = prizeAmount - donation;
266         queue[lastDepositInfo.index].depositor.send(prize);
267 
268         prizeAmount = 0;
269         proceedToNewStage(stage + 1);
270     }
271 
272     //Get the deposit info by its index
273     //You can get deposit index from
274     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
275         Deposit storage dep = queue[idx];
276         return (dep.depositor, dep.deposit, dep.expect);
277     }
278 
279     //Get the count of deposits of specific investor
280     function getDepositsCount(address depositor) public view returns (uint) {
281         uint c = 0;
282         for(uint i=currentReceiverIndex; i<queue.length; ++i){
283             if(queue[i].depositor == depositor)
284                 c++;
285         }
286         return c;
287     }
288 
289     //Get all deposits (index, deposit, expect) of a specific investor
290     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
291         uint c = getDepositsCount(depositor);
292 
293         idxs = new uint[](c);
294         deposits = new uint128[](c);
295         expects = new uint128[](c);
296 
297         if(c > 0) {
298             uint j = 0;
299             for(uint i=currentReceiverIndex; i<queue.length; ++i){
300                 Deposit storage dep = queue[i];
301                 if(dep.depositor == depositor){
302                     idxs[j] = i;
303                     deposits[j] = dep.deposit;
304                     expects[j] = dep.expect;
305                     j++;
306                 }
307             }
308         }
309     }
310 
311     //Get current queue size
312     function getQueueLength() public view returns (uint) {
313         return queue.length - currentReceiverIndex;
314     }
315 
316     //Get current depositors multiplier percent at this stage
317     function getDepositorMultiplier(address depositor) public view returns (uint) {
318         DepositCount storage c = depositsMade[depositor];
319         uint count = 0;
320         if(c.stage == getCurrentStageByTime())
321             count = c.count;
322         if(count < MULTIPLIERS.length)
323             return MULTIPLIERS[count];
324 
325         return MULTIPLIERS[MULTIPLIERS.length - 1];
326     }
327 
328     function getCurrentStageByTime() public view returns (int) {
329         return int(now - 17 hours) / 1 days - 17836; //Start is 01/11/2018 20:00 GMT+3
330     }
331 
332     function getStageStartTime(int _stage) public pure returns (int) {
333         return 17 hours + (_stage + 17836)*1 days;
334     }
335 
336     function getCurrentCandidateForPrize() public view returns (address addr, int timeLeft){
337         Deposit storage d = queue[lastDepositInfo.index];
338         addr = d.depositor;
339         timeLeft = int(lastDepositInfo.time + MAX_IDLE_TIME) - int(now);
340     }
341 
342 }