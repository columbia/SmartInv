1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6   MultiEther contract: returns 110-120% of each investment!
7 
8   Automatic payouts!
9   No bugs, no backdoors, NO OWNER - fully automatic!
10   Made and checked by professionals!
11 
12   1. Send any sum to smart contract address
13      - sum from 0.01 ETH
14      - min 280000 gas limit
15      - you are added to a queue
16   2. Wait a little bit
17   3. ...
18   4. PROFIT! You have got 110-120%
19 
20   How is that?
21   1. The first investor in the queue (you will become the
22      first in some time) receives next investments until
23      it become 110-120% of his initial investment.
24   2. You will receive payments in several parts or all at once
25   3. Once you receive 110-120% of your initial investment you are
26      removed from the queue.
27   4. You can make only one active deposit
28   5. The balance of this contract should normally be 0 because
29      all the money are immediately go to payouts
30 
31 
32      So the last pays to the first (or to several first ones
33      if the deposit big enough) and the investors paid 110-120% are removed from the queue
34 
35                 new investor --|               brand new investor --|
36                  investor5     |                 new investor       |
37                  investor4     |     =======>      investor5        |
38                  investor3     |                   investor4        |
39     (part. paid) investor2    <|                   investor3        |
40     (fully paid) investor1   <-|                   investor2   <----|  (pay until 110-120%)
41 
42     ==> Limits: <==
43 
44     Total invested: up to 20ETH
45     Multiplier: 120%
46     Maximum deposit: 1ETH
47 
48     Total invested: from 20 to 50ETH
49     Multiplier: 117%
50     Maximum deposit: 1.2ETH
51 
52     Total invested: from 50 to 100ETH
53     Multiplier: 115%
54     Maximum deposit: 1.4ETH
55 
56     Total invested: from 100 to 200ETH
57     Multiplier: 113%
58     Maximum deposit: 1.7ETH
59 
60     Total invested: from 200ETH
61     Multiplier: 110%
62     Maximum deposit: 2ETH
63 
64 */
65 
66 
67 /**
68 
69   RU:
70   Контракт MultiEther: возвращает 110-120% от вашего депозита!
71 
72   Автоматические выплаты!
73   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
74   Создан и проверен профессионалами!
75 
76   1. Пошлите любую ненулевую сумму на адрес контракта
77      - сумма от 0.01 ETH
78      - gas limit минимум 280000
79      - вы встанете в очередь
80   2. Немного подождите
81   3. ...
82   4. PROFIT! Вам пришло 110-120% от вашего депозита.
83 
84   Как это возможно?
85   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
86      новых инвесторов до тех пор, пока не получит 110-120% от своего депозита
87   2. Выплаты могут приходить несколькими частями или все сразу
88   3. Как только вы получаете 110-120% от вашего депозита, вы удаляетесь из очереди
89   4. У вас может быть только один активный вклад
90   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
91      сразу же направляются на выплаты
92 
93      Таким образом, последние платят первым, и инвесторы, достигшие выплат 110-120% от депозита,
94      удаляются из очереди, уступая место остальным
95 
96               новый инвестор --|            совсем новый инвестор --|
97                  инвестор5     |                новый инвестор      |
98                  инвестор4     |     =======>      инвестор5        |
99                  инвестор3     |                   инвестор4        |
100  (част. выплата) инвестор2    <|                   инвестор3        |
101 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 110-120%)
102 
103     ==> Лимиты: <==
104 
105     Всего инвестировано: до 20ETH
106     Профит: 120%
107     Максимальный вклад: 1ETH
108 
109     Всего инвестировано: от 20 до 50ETH
110     Профит: 117%
111     Максимальный вклад: 1.2ETH
112 
113     Всего инвестировано: от 50 до 100ETH
114     Профит: 115%
115     Максимальный вклад: 1.4ETH
116 
117     Всего инвестировано: от 100 до 200ETH
118     Профит: 113%
119     Максимальный вклад: 1.7ETH
120 
121     Всего инвестировано: более 200ETH
122     Профит: 110%
123     Максимальный вклад: 2ETH
124 
125 */
126 contract MultiEther {
127 
128     //The deposit structure holds all the info about the deposit made
129     struct Deposit {
130         address depositor; // The depositor address
131         uint deposit;   // The deposit amount
132         uint payout; // Amount already paid
133     }
134 
135     Deposit[] public queue;  // The queue
136     mapping (address => uint) public depositNumber; // investor deposit index
137     uint public currentReceiverIndex; // The index of the depositor in the queue
138     uint public totalInvested; // Total invested amount
139 
140     address public support = msg.sender;
141     uint public amountForSupport;
142 
143     //This function receives all the deposits
144     //stores them and make immediate payouts
145     function () public payable {
146         require(block.number >= 6661266);
147 
148         if(msg.value > 0){
149 
150             require(gasleft() >= 250000); // We need gas to process queue
151             require(msg.value >= 0.01 ether && msg.value <= calcMaxDeposit()); // Too small and too big deposits are not accepted
152             require(depositNumber[msg.sender] == 0); // Investor should not already be in the queue
153 
154             // Add the investor into the queue
155             queue.push( Deposit(msg.sender, msg.value, 0) );
156             depositNumber[msg.sender] = queue.length;
157 
158             totalInvested += msg.value;
159 
160             // In total, no more than 10 ETH can be sent to support the project
161             if (amountForSupport < 10 ether) {
162                 uint fee = msg.value / 5;
163                 amountForSupport += fee;
164                 support.transfer(fee);
165             }
166 
167             // Pay to first investors in line
168             pay();
169 
170         }
171     }
172 
173     // Used to pay to current investors
174     // Each new transaction processes 1 - 4+ investors in the head of queue
175     // depending on balance and gas left
176     function pay() internal {
177 
178         uint money = address(this).balance;
179         uint multiplier = calcMultiplier();
180 
181         // We will do cycle on the queue
182         for (uint i = 0; i < queue.length; i++){
183 
184             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
185 
186             Deposit storage dep = queue[idx]; // get the info of the first investor
187 
188             uint totalPayout = dep.deposit * multiplier / 100;
189             uint leftPayout;
190 
191             if (totalPayout > dep.payout) {
192                 leftPayout = totalPayout - dep.payout;
193             }
194 
195             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
196 
197                 if (leftPayout > 0) {
198                     dep.depositor.send(leftPayout); // Send money to him
199                     money -= leftPayout;
200                 }
201 
202                 // this investor is fully paid, so remove him
203                 depositNumber[dep.depositor] = 0;
204                 delete queue[idx];
205 
206             } else{
207 
208                 // Here we don't have enough money so partially pay to investor
209                 dep.depositor.send(money); // Send to him everything we have
210                 dep.payout += money;       // Update the payout amount
211                 break;                     // Exit cycle
212 
213             }
214 
215             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
216                 break;                       // The next investor will process the line further
217             }
218         }
219 
220         currentReceiverIndex += i; //Update the index of the current first investor
221     }
222 
223     // Get current queue size
224     function getQueueLength() public view returns (uint) {
225         return queue.length - currentReceiverIndex;
226     }
227 
228     // Get max deposit for your investment
229     function calcMaxDeposit() public view returns (uint) {
230 
231         if (totalInvested <= 20 ether) {
232             return 1 ether;
233         } else if (totalInvested <= 50 ether) {
234             return 1.2 ether;
235         } else if (totalInvested <= 100 ether) {
236             return 1.4 ether;
237         } else if (totalInvested <= 200 ether) {
238             return 1.7 ether;
239         } else {
240             return 2 ether;
241         }
242 
243     }
244 
245     // How many percent for your deposit to be multiplied at now
246     function calcMultiplier() public view returns (uint) {
247 
248         if (totalInvested <= 20 ether) {
249             return 120;
250         } else if (totalInvested <= 50 ether) {
251             return 117;
252         } else if (totalInvested <= 100 ether) {
253             return 115;
254         } else if (totalInvested <= 200 ether) {
255             return 113;
256         } else {
257             return 110;
258         }
259 
260     }
261 
262 }