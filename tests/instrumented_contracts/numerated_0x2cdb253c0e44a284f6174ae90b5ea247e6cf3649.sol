1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6 
7   Web: https://bestmultiplier.biz/ru/
8   Telegram: https://t.me/bestMultiplierEn
9 
10   Multiplier contract: returns 105-130% of each investment!
11 
12   Automatic payouts!
13   No bugs, no backdoors, NO OWNER - fully automatic!
14   Made and checked by professionals!
15 
16   1. Send any sum to smart contract address
17      - sum from 0.01 ETH
18      - min 280000 gas limit
19      - you are added to a queue
20   2. Wait a little bit
21   3. ...
22   4. PROFIT! You have got 105-130%
23 
24   How is that?
25   1. The first investor in the queue (you will become the
26      first in some time) receives next investments until
27      it become 105-130% of his initial investment.
28   2. You will receive payments in several parts or all at once
29   3. Once you receive 105-м% of your initial investment you are
30      removed from the queue.
31   4. You can make only one active deposit
32   5. The balance of this contract should normally be 0 because
33      all the money are immediately go to payouts
34 
35 
36      So the last pays to the first (or to several first ones
37      if the deposit big enough) and the investors paid 105-130% are removed from the queue
38 
39                 new investor --|               brand new investor --|
40                  investor5     |                 new investor       |
41                  investor4     |     =======>      investor5        |
42                  investor3     |                   investor4        |
43     (part. paid) investor2    <|                   investor3        |
44     (fully paid) investor1   <-|                   investor2   <----|  (pay until 105-130%)
45 
46     ==> Limits: <==
47 
48     Total invested: up to 100ETH
49     Multiplier: 130%
50     Maximum deposit: 2.5ETH
51 
52     Total invested: from 100 to 250ETH
53     Multiplier: 125%
54     Maximum deposit: 5ETH
55 
56     Total invested: from 250 to 500ETH
57     Multiplier: 120%
58     Maximum deposit: 10ETH
59 
60     Total invested: from 500 to 1000ETH
61     Multiplier: 110%
62     Maximum deposit: 15ETH
63 
64     Total invested: from 1000ETH
65     Multiplier: 105%
66     Maximum deposit: 20ETH
67 
68 */
69 
70 
71 /**
72 
73   RU:
74 
75   Web: https://bestmultiplier.biz/ru/
76   Telegram: https://t.me/bestMultiplier
77 
78   Контракт Умножитель: возвращает 105-130% от вашего депозита!
79 
80   Автоматические выплаты!
81   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
82   Создан и проверен профессионалами!
83 
84   1. Пошлите любую ненулевую сумму на адрес контракта
85      - сумма от 0.01 ETH
86      - gas limit минимум 280000
87      - вы встанете в очередь
88   2. Немного подождите
89   3. ...
90   4. PROFIT! Вам пришло 105-130% от вашего депозита.
91 
92   Как это возможно?
93   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
94      новых инвесторов до тех пор, пока не получит 105-130% от своего депозита
95   2. Выплаты могут приходить несколькими частями или все сразу
96   3. Как только вы получаете 105-130% от вашего депозита, вы удаляетесь из очереди
97   4. У вас может быть только один активный вклад
98   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
99      сразу же направляются на выплаты
100 
101      Таким образом, последние платят первым, и инвесторы, достигшие выплат 105-130% от депозита,
102      удаляются из очереди, уступая место остальным
103 
104               новый инвестор --|            совсем новый инвестор --|
105                  инвестор5     |                новый инвестор      |
106                  инвестор4     |     =======>      инвестор5        |
107                  инвестор3     |                   инвестор4        |
108  (част. выплата) инвестор2    <|                   инвестор3        |
109 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 105-130%)
110 
111     ==> Лимиты: <==
112 
113     Всего инвестировано: до 100ETH
114     Профит: 130%
115     Максимальный вклад: 2.5ETH
116 
117     Всего инвестировано: от 100 до 250ETH
118     Профит: 125%
119     Максимальный вклад: 5ETH
120 
121     Всего инвестировано: от 250 до 500ETH
122     Профит: 120%
123     Максимальный вклад: 10ETH
124 
125     Всего инвестировано: от 500 до 1000ETH
126     Профит: 110%
127     Максимальный вклад: 15ETH
128 
129     Всего инвестировано: более 1000ETH
130     Профит: 105%
131     Максимальный вклад: 20ETH
132 
133 */
134 contract BestMultiplierV2 {
135 
136     //The deposit structure holds all the info about the deposit made
137     struct Deposit {
138         address depositor; // The depositor address
139         uint deposit;   // The deposit amount
140         uint payout; // Amount already paid
141     }
142 
143     Deposit[] public queue;  // The queue
144     mapping (address => uint) public depositNumber; // investor deposit index
145     uint public currentReceiverIndex; // The index of the depositor in the queue
146     uint public totalInvested; // Total invested amount
147 
148     address public support = msg.sender;
149     uint public amountForSupport;
150 
151     //This function receives all the deposits
152     //stores them and make immediate payouts
153     function () public payable {
154 
155         if(msg.value > 0){
156 
157             require(gasleft() >= 250000); // We need gas to process queue
158             require(msg.value >= 0.01 ether && msg.value <= calcMaxDeposit()); // Too small and too big deposits are not accepted
159             require(depositNumber[msg.sender] == 0); // Investor should not already be in the queue
160 
161             // Add the investor into the queue
162             queue.push( Deposit(msg.sender, msg.value, 0) );
163             depositNumber[msg.sender] = queue.length;
164 
165             totalInvested += msg.value;
166 
167             // In total, no more than 5 ETH can be sent to support the project
168             if (amountForSupport < 5 ether) {
169                 amountForSupport += msg.value / 10;
170                 support.transfer(msg.value / 10);
171             }
172 
173             // Pay to first investors in line
174             pay();
175 
176         }
177     }
178 
179     // Used to pay to current investors
180     // Each new transaction processes 1 - 4+ investors in the head of queue
181     // depending on balance and gas left
182     function pay() internal {
183 
184         uint money = address(this).balance;
185         uint multiplier = calcMultiplier();
186 
187         // We will do cycle on the queue
188         for (uint i = 0; i < queue.length; i++){
189 
190             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
191 
192             Deposit storage dep = queue[idx]; // get the info of the first investor
193 
194             uint totalPayout = dep.deposit * multiplier / 100;
195             uint leftPayout;
196 
197             if (totalPayout > dep.payout) {
198                 leftPayout = totalPayout - dep.payout;
199             }
200 
201             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
202 
203                 if (leftPayout > 0) {
204                     dep.depositor.send(leftPayout); // Send money to him
205                     money -= leftPayout;
206                 }
207 
208                 // this investor is fully paid, so remove him
209                 depositNumber[dep.depositor] = 0;
210                 delete queue[idx];
211 
212             } else{
213 
214                 // Here we don't have enough money so partially pay to investor
215                 dep.depositor.send(money); // Send to him everything we have
216                 dep.payout += money;       // Update the payout amount
217                 break;                     // Exit cycle
218 
219             }
220 
221             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
222                 break;                       // The next investor will process the line further
223             }
224         }
225 
226         currentReceiverIndex += i; //Update the index of the current first investor
227     }
228 
229     // Get current queue size
230     function getQueueLength() public view returns (uint) {
231         return queue.length - currentReceiverIndex;
232     }
233 
234     // Get max deposit for your investment
235     function calcMaxDeposit() public view returns (uint) {
236 
237         if (totalInvested <= 100 ether) {
238             return 2.5 ether;
239         } else if (totalInvested <= 250 ether) {
240             return 5 ether;
241         } else if (totalInvested <= 500 ether) {
242             return 10 ether;
243         } else if (totalInvested <= 1000 ether) {
244             return 15 ether;
245         } else {
246             return 20 ether;
247         }
248 
249     }
250 
251     // How many percent for your deposit to be multiplied at now
252     function calcMultiplier() public view returns (uint) {
253 
254         if (totalInvested <= 100 ether) {
255             return 130;
256         } else if (totalInvested <= 250 ether) {
257             return 125;
258         } else if (totalInvested <= 500 ether) {
259             return 120;
260         } else if (totalInvested <= 1000 ether) {
261             return 110;
262         } else {
263             return 105;
264         }
265 
266     }
267 
268 }