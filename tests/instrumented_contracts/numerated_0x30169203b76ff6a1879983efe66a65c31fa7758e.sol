1 pragma solidity ^0.4.25;
2 
3 /**
4   WITH AUTORESTART EVERY 256 BLOCKS!!! / С АВТОРЕСТАРТОМ КАЖДЫЕ 256 БЛОКОВ!!!
5 
6   EN:
7   Multiplier contract: returns 110-130% of each investment!
8 
9   Automatic payouts!
10   No bugs, no backdoors, NO OWNER - fully automatic!
11   Made and checked by professionals!
12 
13   1. Send any sum to smart contract address
14      - sum from 0.1 ETH
15      - min 280000 gas limit
16      - you are added to a queue
17   2. Wait a little bit
18   3. ...
19   4. PROFIT! You have got 110-130%
20 
21   How is that?
22   1. The first investor in the queue (you will become the
23      first in some time) receives next investments until
24      it become 110-130% of his initial investment.
25   2. You will receive payments in several parts or all at once
26   3. Once you receive 110-130% of your initial investment you are
27      removed from the queue.
28   4. You can make only one active deposit
29   5. The balance of this contract should normally be 0 because
30      all the money are immediately go to payouts
31 
32 
33      So the last pays to the first (or to several first ones
34      if the deposit big enough) and the investors paid 110-130% are removed from the queue
35 
36                 new investor --|               brand new investor --|
37                  investor5     |                 new investor       |
38                  investor4     |     =======>      investor5        |
39                  investor3     |                   investor4        |
40     (part. paid) investor2    <|                   investor3        |
41     (fully paid) investor1   <-|                   investor2   <----|  (pay until 110-130%)
42 
43     ==> Limits: <==
44 
45     Total invested: up to 20ETH
46     Multiplier: 130%
47     Maximum deposit: 0.5ETH
48 
49     Total invested: from 20 to 50ETH
50     Multiplier: 120%
51     Maximum deposit: 0.7ETH
52 
53     Total invested: from 50 to 100ETH
54     Multiplier: 115%
55     Maximum deposit: 1ETH
56 
57     Total invested: from 100 to 200ETH
58     Multiplier: 112%
59     Maximum deposit: 1.5ETH
60 
61     Total invested: from 200ETH
62     Multiplier: 110%
63     Maximum deposit: 2ETH
64 
65     Do not invest at the end of the round
66 */
67 
68 
69 /**
70 
71   RU:
72   Контракт Умножитель: возвращает 110-130% от вашего депозита!
73 
74   Автоматические выплаты!
75   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
76   Создан и проверен профессионалами!
77 
78   1. Пошлите любую ненулевую сумму на адрес контракта
79      - сумма от 0.1 ETH
80      - gas limit минимум 280000
81      - вы встанете в очередь
82   2. Немного подождите
83   3. ...
84   4. PROFIT! Вам пришло 110-130% от вашего депозита.
85 
86   Как это возможно?
87   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
88      новых инвесторов до тех пор, пока не получит 110-130% от своего депозита
89   2. Выплаты могут приходить несколькими частями или все сразу
90   3. Как только вы получаете 110-130% от вашего депозита, вы удаляетесь из очереди
91   4. У вас может быть только один активный вклад
92   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
93      сразу же направляются на выплаты
94 
95      Таким образом, последние платят первым, и инвесторы, достигшие выплат 110-130% от депозита,
96      удаляются из очереди, уступая место остальным
97 
98               новый инвестор --|            совсем новый инвестор --|
99                  инвестор5     |                новый инвестор      |
100                  инвестор4     |     =======>      инвестор5        |
101                  инвестор3     |                   инвестор4        |
102  (част. выплата) инвестор2    <|                   инвестор3        |
103 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 110-130%)
104 
105     ==> Лимиты: <==
106 
107     Всего инвестировано: до 20ETH
108     Профит: 130%
109     Максимальный вклад: 0.5ETH
110 
111     Всего инвестировано: от 20 до 50ETH
112     Профит: 120%
113     Максимальный вклад: 0.7ETH
114 
115     Всего инвестировано: от 50 до 100ETH
116     Профит: 115%
117     Максимальный вклад: 1ETH
118 
119     Всего инвестировано: от 100 до 200ETH
120     Профит: 112%
121     Максимальный вклад: 1.5ETH
122 
123     Всего инвестировано: более 200ETH
124     Профит: 110%
125     Максимальный вклад: 2ETH
126 
127     Не инвестируйте в конце раунда
128 
129 */
130 contract EternalMultiplier {
131 
132     //The deposit structure holds all the info about the deposit made
133     struct Deposit {
134         address depositor; // The depositor address
135         uint deposit;   // The deposit amount
136         uint payout; // Amount already paid
137     }
138 
139     uint public roundDuration = 256;
140     
141     mapping (uint => Deposit[]) public queue;  // The queue
142     mapping (uint => mapping (address => uint)) public depositNumber; // investor deposit index
143     mapping (uint => uint) public currentReceiverIndex; // The index of the depositor in the queue
144     mapping (uint => uint) public totalInvested; // Total invested amount
145 
146     address public support = msg.sender;
147     mapping (uint => uint) public amountForSupport;
148 
149     //This function receives all the deposits
150     //stores them and make immediate payouts
151     function () public payable {
152         require(block.number >= 6617925);
153         require(block.number % roundDuration < roundDuration - 20);
154         uint stage = block.number / roundDuration;
155 
156         if(msg.value > 0){
157 
158             require(gasleft() >= 250000); // We need gas to process queue
159             require(msg.value >= 0.1 ether && msg.value <= calcMaxDeposit(stage)); // Too small and too big deposits are not accepted
160             require(depositNumber[stage][msg.sender] == 0); // Investor should not already be in the queue
161 
162             // Add the investor into the queue
163             queue[stage].push( Deposit(msg.sender, msg.value, 0) );
164             depositNumber[stage][msg.sender] = queue[stage].length;
165 
166             totalInvested[stage] += msg.value;
167 
168             // No more than 5 ETH per stage can be sent to support the project
169             if (amountForSupport[stage] < 5 ether) {
170                 uint fee = msg.value / 5;
171                 amountForSupport[stage] += fee;
172                 support.transfer(fee);
173             }
174 
175             // Pay to first investors in line
176             pay(stage);
177 
178         }
179     }
180 
181     // Used to pay to current investors
182     // Each new transaction processes 1 - 4+ investors in the head of queue
183     // depending on balance and gas left
184     function pay(uint stage) internal {
185 
186         uint money = address(this).balance;
187         uint multiplier = calcMultiplier(stage);
188 
189         // We will do cycle on the queue
190         for (uint i = 0; i < queue[stage].length; i++){
191 
192             uint idx = currentReceiverIndex[stage] + i;  //get the index of the currently first investor
193 
194             Deposit storage dep = queue[stage][idx]; // get the info of the first investor
195 
196             uint totalPayout = dep.deposit * multiplier / 100;
197             uint leftPayout;
198 
199             if (totalPayout > dep.payout) {
200                 leftPayout = totalPayout - dep.payout;
201             }
202 
203             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
204 
205                 if (leftPayout > 0) {
206                     dep.depositor.send(leftPayout); // Send money to him
207                     money -= leftPayout;
208                 }
209 
210                 // this investor is fully paid, so remove him
211                 depositNumber[stage][dep.depositor] = 0;
212                 delete queue[stage][idx];
213 
214             } else{
215 
216                 // Here we don't have enough money so partially pay to investor
217                 dep.depositor.send(money); // Send to him everything we have
218                 dep.payout += money;       // Update the payout amount
219                 break;                     // Exit cycle
220 
221             }
222 
223             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
224                 break;                       // The next investor will process the line further
225             }
226         }
227 
228         currentReceiverIndex[stage] += i; //Update the index of the current first investor
229     }
230 
231     // Get current queue size
232     function getQueueLength() public view returns (uint) {
233         uint stage = block.number / roundDuration;
234         return queue[stage].length - currentReceiverIndex[stage];
235     }
236 
237     // Get max deposit for your investment
238     function calcMaxDeposit(uint stage) public view returns (uint) {
239 
240         if (totalInvested[stage] <= 20 ether) {
241             return 0.5 ether;
242         } else if (totalInvested[stage] <= 50 ether) {
243             return 0.7 ether;
244         } else if (totalInvested[stage] <= 100 ether) {
245             return 1 ether;
246         } else if (totalInvested[stage] <= 200 ether) {
247             return 1.5 ether;
248         } else {
249             return 2 ether;
250         }
251 
252     }
253 
254     // How many percent for your deposit to be multiplied at now
255     function calcMultiplier(uint stage) public view returns (uint) {
256 
257         if (totalInvested[stage] <= 20 ether) {
258             return 130;
259         } else if (totalInvested[stage] <= 50 ether) {
260             return 120;
261         } else if (totalInvested[stage] <= 100 ether) {
262             return 115;
263         } else if (totalInvested[stage] <= 200 ether) {
264             return 112;
265         } else {
266             return 110;
267         }
268 
269     }
270 
271 }