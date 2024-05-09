1 pragma solidity ^0.4.25;
2 
3 /**
4 Правила игр eSmart
5 
6 * Процентная ставка 120%
7 * Фиксированный размер депозита; 0.05 eth, 0.1eth, 1eth
8 * Ежедневные старты, 5 раундов для каждой категории депозитов
9 * Распределение баланса
10 - 90% на выплаты участникам
11 - 7% делится поровну и распределяется между последними депозитами которые не прошли круг
12 (возврат 20% от депозита)
13 - 1% Джекпот
14 - 2% маркетинг и техническая поддержка
15 
16 * Джекпот выигрывает участник который сделает больше всех транзакций с оборота за 5 раундов, в каждой категории отдельно.
17 
18 * Раунд заканчивается через 10 минут от последней входящей транзакции на смарт контракт.
19 
20 * eSmart предлагает самые эффективные умножители с высокой вероятностью прохождения круга!
21 * В играх eSmart нет проигравших, так как в каждом раунде все транзакции получают выплаты
22 - 77% первых транзакций 120% от депозита
23 - 23% последних транзакций в очереди 20% от депозита
24 
25 * Играй в честные игры с eSmart
26 
27 */
28 
29 contract ESmart {
30     uint constant public INVESTMENT = 0.05 ether;
31     uint constant private START_TIME = 1541435400; // 2018-11-05 19:30 MSK (GMT+3)
32 
33     //Address for tech expences
34     address constant private TECH = 0x9A5B6966379a61388068bb765c518E5bC4D9B509;
35     //Address for promo expences
36     address constant private PROMO = 0xD6104cEca65db37925541A800870aEe09C8Fd78D;
37     //Address for promo expences
38     address constant private LAST_FUND = 0x357b9046f99eEC7E705980F328F00BAab4b3b6Be;
39     //Percent for first multiplier donation
40     uint constant public JACKPOT_PERCENT = 1;
41     uint constant public TECH_PERCENT = 7; //0.7%
42     uint constant public PROMO_PERCENT = 13; //1.3%
43     uint constant public LAST_FUND_PERCENT = 10;
44     uint constant public MAX_IDLE_TIME = 10 minutes; //Maximum time the deposit should remain the last to receive prize
45     uint constant public NEXT_ROUND_TIME = 30 minutes; //Time to next round since the last deposit
46 
47     //How many percent for your deposit to be multiplied
48     uint constant public MULTIPLIER = 120;
49 
50     //The deposit structure holds all the info about the deposit made
51     struct Deposit {
52         address depositor; //The depositor address
53         uint128 deposit;   //The deposit amount
54         uint128 expect;    //How much we should pay out (initially it is 120% of deposit)
55     }
56 
57     struct LastDepositInfo {
58         uint128 index;
59         uint128 time;
60     }
61 
62     struct MaxDepositInfo {
63         address depositor;
64         uint count;
65     }
66 
67     Deposit[] private queue;  //The queue
68     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
69     uint public currentQueueSize = 0; //The current size of queue (may be less than queue.length)
70     LastDepositInfo public lastDepositInfo; //The time last deposit made at
71     MaxDepositInfo public maxDepositInfo; //The pretender for jackpot
72     uint private startTime = START_TIME;
73     mapping(address => uint) public depCount; //Number of deposits made
74 
75     uint public jackpotAmount = 0; //Prize amount accumulated for the last depositor
76     int public stage = 0; //Number of contract runs
77 
78     //This function receives all the deposits
79     //stores them and make immediate payouts
80     function () public payable {
81         //If money are from first multiplier, just add them to the balance
82         //All these money will be distributed to current investors
83         if(msg.value > 0){
84             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
85             require(msg.value >= INVESTMENT, "The investment is too small!");
86             require(stage < 5); //Only 5 rounds!!!
87 
88             checkAndUpdateStage();
89 
90             //Check that we can accept deposits
91             require(getStartTime() <= now, "Deposits are not accepted before time");
92 
93             addDeposit(msg.sender, msg.value);
94 
95             //Pay to first investors in line
96             pay();
97         }else if(msg.value == 0){
98             withdrawPrize();
99         }
100     }
101 
102     //Used to pay to current investors
103     //Each new transaction processes 1 - 4+ investors in the head of queue
104     //depending on balance and gas left
105     function pay() private {
106         //Try to send all the money on contract to the first investors in line
107         uint balance = address(this).balance;
108         uint128 money = 0;
109         if(balance > (jackpotAmount)) //The opposite is impossible, however the check will not do any harm
110             money = uint128(balance - jackpotAmount);
111 
112         //We will do cycle on the queue
113         for(uint i=currentReceiverIndex; i<currentQueueSize; i++){
114 
115             Deposit storage dep = queue[i]; //get the info of the first investor
116 
117             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
118                 dep.depositor.send(dep.expect); //Send money to him
119                 money -= dep.expect;            //update money left
120 
121                 //this investor is fully paid, so remove him
122                 delete queue[i];
123             }else{
124                 //Here we don't have enough money so partially pay to investor
125                 dep.depositor.send(money); //Send to him everything we have
126                 dep.expect -= money;       //Update the expected amount
127                 break;                     //Exit cycle
128             }
129 
130             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
131                 break;                     //The next investor will process the line further
132         }
133 
134         currentReceiverIndex = i; //Update the index of the current first investor
135     }
136 
137     function addDeposit(address depositor, uint value) private {
138         require(stage < 5); //Only 5 rounds!!!
139         //If you are applying for the prize you should invest more than minimal amount
140         //Otherwize it doesn't count
141         if(value > INVESTMENT){ //Fixed deposit
142             depositor.transfer(value - INVESTMENT);
143             value = INVESTMENT;
144         }
145 
146         lastDepositInfo.index = uint128(currentQueueSize);
147         lastDepositInfo.time = uint128(now);
148 
149         //Add the investor into the queue. Mark that he expects to receive 120% of deposit back
150         push(depositor, value, value*MULTIPLIER/100);
151 
152         depCount[depositor]++;
153 
154         //Check if candidate for jackpot changed
155         uint count = depCount[depositor];
156         if(maxDepositInfo.count < count){
157             maxDepositInfo.count = count;
158             maxDepositInfo.depositor = depositor;
159         }
160 
161         //Save money for prize and father multiplier
162         jackpotAmount += value*(JACKPOT_PERCENT)/100;
163 
164         uint lastFund = value*LAST_FUND_PERCENT/100;
165         LAST_FUND.send(lastFund);
166         //Send small part to tech support
167         uint support = value*TECH_PERCENT/1000;
168         TECH.send(support);
169         uint adv = value*PROMO_PERCENT/1000;
170         PROMO.send(adv);
171 
172     }
173 
174     function checkAndUpdateStage() private{
175         int _stage = getCurrentStageByTime();
176 
177         require(_stage >= stage, "We should only go forward in time");
178 
179         if(_stage != stage){
180             proceedToNewStage(_stage);
181         }
182     }
183 
184     function proceedToNewStage(int _stage) private {
185         //Clean queue info
186         //The prize amount on the balance is left the same if not withdrawn
187         startTime = getStageStartTime(_stage);
188         assert(startTime > 0);
189         stage = _stage;
190         currentQueueSize = 0; //Instead of deleting queue just reset its length (gas economy)
191         currentReceiverIndex = 0;
192         delete lastDepositInfo;
193     }
194 
195     function withdrawPrize() private {
196         require(getCurrentStageByTime() >= 5); //Only after 5 rounds!
197         require(maxDepositInfo.count > 0, "The max depositor is not confirmed yet");
198 
199         uint balance = address(this).balance;
200         if(jackpotAmount > balance) //Impossible but better check it
201             jackpotAmount = balance;
202 
203         maxDepositInfo.depositor.send(jackpotAmount);
204 
205         selfdestruct(TECH); //5 rounds are over, so we can clean the contract
206     }
207 
208     //Pushes investor to the queue
209     function push(address depositor, uint deposit, uint expect) private {
210         //Add the investor into the queue
211         Deposit memory dep = Deposit(depositor, uint128(deposit), uint128(expect));
212         assert(currentQueueSize <= queue.length); //Assert queue size is not corrupted
213         if(queue.length == currentQueueSize)
214             queue.push(dep);
215         else
216             queue[currentQueueSize] = dep;
217 
218         currentQueueSize++;
219     }
220 
221     //Get the deposit info by its index
222     //You can get deposit index from
223     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
224         Deposit storage dep = queue[idx];
225         return (dep.depositor, dep.deposit, dep.expect);
226     }
227 
228     //Get the count of deposits of specific investor
229     function getDepositsCount(address depositor) public view returns (uint) {
230         uint c = 0;
231         for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
232             if(queue[i].depositor == depositor)
233                 c++;
234         }
235         return c;
236     }
237 
238     //Get all deposits (index, deposit, expect) of a specific investor
239     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
240         uint c = getDepositsCount(depositor);
241 
242         idxs = new uint[](c);
243         deposits = new uint128[](c);
244         expects = new uint128[](c);
245 
246         if(c > 0) {
247             uint j = 0;
248             for(uint i=currentReceiverIndex; i<currentQueueSize; ++i){
249                 Deposit storage dep = queue[i];
250                 if(dep.depositor == depositor){
251                     idxs[j] = i;
252                     deposits[j] = dep.deposit;
253                     expects[j] = dep.expect;
254                     j++;
255                 }
256             }
257         }
258     }
259 
260     //Get current queue size
261     function getQueueLength() public view returns (uint) {
262         return currentQueueSize - currentReceiverIndex;
263     }
264 
265     function getCurrentStageByTime() public view returns (int) {
266         if(lastDepositInfo.time > 0 && lastDepositInfo.time + MAX_IDLE_TIME <= now){
267             return stage + 1; //Move to next stage if last deposit is too old
268         }
269         return stage;
270     }
271 
272     function getStageStartTime(int _stage) public view returns (uint) {
273         if(_stage >= 5)
274             return 0;
275         if(_stage == stage)
276             return startTime;
277         if(lastDepositInfo.time == 0)
278             return 0;
279         if(_stage == stage + 1)
280             return lastDepositInfo.time + NEXT_ROUND_TIME;
281         return 0;
282     }
283 
284     function getStartTime() public view returns (uint) {
285         return getStageStartTime(getCurrentStageByTime());
286     }
287 
288 }