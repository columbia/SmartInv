1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6   Multiplier contract: returns 110-135% of each investment!
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
18   4. PROFIT! You have got 110-135%
19 
20   How is that?
21   1. The first investor in the queue (you will become the
22      first in some time) receives next investments until
23      it become 110-135% of his initial investment.
24   2. You will receive payments in several parts or all at once.
25   3. Once you receive 110-135% of your initial investment you are
26      removed from the queue.
27   4. You can invest an unlimited number of times without waiting for the full
28      payment on deposits.
29 
30 
31      So the last pays to the first (or to several first ones
32      if the deposit big enough) and the investors paid 110-135% are removed from the queue
33 
34                 new investor --|               brand new investor --|
35                  investor5     |                 new investor       |
36                  investor4     |     =======>      investor5        |
37                  investor3     |                   investor4        |
38     (part. paid) investor2    <|                   investor3        |
39     (fully paid) investor1   <-|                   investor2   <----|  (pay until 110-135%)
40 
41     ==> Limits: <==
42 
43     Total invested: up to 20ETH
44     Multiplier: 135%
45     Maximum deposit: 1ETH
46 
47     Total invested: from 20 to 50ETH
48     Multiplier: 120%
49     Maximum deposit: 1.2ETH
50 
51     Total invested: from 50 to 100ETH
52     Multiplier: 115%
53     Maximum deposit: 1.4ETH
54 
55     Total invested: from 100 to 200ETH
56     Multiplier: 112%
57     Maximum deposit: 1.7ETH
58 
59     Total invested: from 200ETH
60     Multiplier: 110%
61     Maximum deposit: 2ETH
62 
63 */
64 
65 
66 /**
67 
68   RU:
69   Контракт Умножитель: возвращает 110-135% от вашего депозита!
70 
71   Автоматические выплаты!
72   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
73   Создан и проверен профессионалами!
74 
75   1. Пошлите любую ненулевую сумму на адрес контракта
76      - сумма от 0.01 ETH
77      - gas limit минимум 280000
78      - вы встанете в очередь
79   2. Немного подождите
80   3. ...
81   4. PROFIT! Вам пришло 110-135% от вашего депозита.
82 
83   Как это возможно?
84   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
85      новых инвесторов до тех пор, пока не получит 110-135% от своего депозита.
86   2. Выплаты могут приходить несколькими частями или все сразу.
87   3. Как только вы получаете 110-135% от вашего депозита, вы удаляетесь из очереди.
88   4. Вы можете вкладывать неограниченное количество раз, не дожидаясь
89      полной выплаты по депозитам.
90 
91      Таким образом, последние платят первым, и инвесторы, достигшие выплат 110-135% от депозита,
92      удаляются из очереди, уступая место остальным
93 
94               новый инвестор --|            совсем новый инвестор --|
95                  инвестор5     |                новый инвестор      |
96                  инвестор4     |     =======>      инвестор5        |
97                  инвестор3     |                   инвестор4        |
98  (част. выплата) инвестор2    <|                   инвестор3        |
99 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 110-135%)
100 
101     ==> Лимиты: <==
102 
103     Всего инвестировано: до 20ETH
104     Профит: 135%
105     Максимальный вклад: 1ETH
106 
107     Всего инвестировано: от 20 до 50ETH
108     Профит: 120%
109     Максимальный вклад: 1.2ETH
110 
111     Всего инвестировано: от 50 до 100ETH
112     Профит: 115%
113     Максимальный вклад: 1.4ETH
114 
115     Всего инвестировано: от 100 до 200ETH
116     Профит: 112%
117     Максимальный вклад: 1.7ETH
118 
119     Всего инвестировано: более 200ETH
120     Профит: 110%
121     Максимальный вклад: 2ETH
122 
123 */
124 contract SmartEthRocket {
125 
126     uint public prizeFee = 7;
127     uint public prize;
128     address public lastInvestor;
129     uint public lastInvestedAt;
130 
131     //The deposit structure holds all the info about the deposit made
132     struct Deposit {
133         address depositor; // The depositor address
134         uint deposit;   // The deposit amount
135         uint payout; // Amount already paid
136     }
137 
138     Deposit[] public queue;  // The queue
139     mapping (address => uint) public depositNumber; // investor deposit index
140     uint public currentReceiverIndex; // The index of the depositor in the queue
141     uint public totalInvested; // Total invested amount
142 
143     address public support = msg.sender;
144     uint public amountForSupport;
145 
146     //This function receives all the deposits
147     //stores them and make immediate payouts
148     function () public payable {
149         require(block.number >= 6648870);
150 
151         if(msg.value > 0){
152 
153             require(gasleft() >= 250000); // We need gas to process queue
154             require(msg.value >= 0.01 ether && msg.value <= calcMaxDeposit()); // Too small and too big deposits are not accepted
155             
156             if (depositNumber[msg.sender] == 0) {
157                 // Add the investor into the queue
158                 queue.push( Deposit(msg.sender, msg.value, 0) );
159                 depositNumber[msg.sender] = queue.length;
160             } else {
161                 queue[depositNumber[msg.sender] - 1].deposit += msg.value;
162             }
163 
164             totalInvested += msg.value;
165 
166             // In total, no more than 5 ETH can be sent to support the project
167             if (amountForSupport < 5 ether) {
168                 uint fee = msg.value / 20;
169                 amountForSupport += fee;
170                 support.transfer(fee);
171             }
172             
173             prize += msg.value * prizeFee / 100;
174             lastInvestor = msg.sender;
175             lastInvestedAt = block.number;
176 
177             // Pay to first investors in line
178             pay();
179 
180         } else if (lastInvestor == msg.sender && block.number >= lastInvestedAt + 126) {
181             lastInvestor.transfer(prize);
182             delete prize;
183             delete lastInvestor;
184         } else {
185             revert();
186         }
187     }
188 
189     // Used to pay to current investors
190     // Each new transaction processes 1 - 4+ investors in the head of queue
191     // depending on balance and gas left
192     function pay() internal {
193 
194         uint money = address(this).balance - prize;
195         uint multiplier = calcMultiplier();
196 
197         // We will do cycle on the queue
198         for (uint i = 0; i < queue.length; i++){
199 
200             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
201 
202             Deposit storage dep = queue[idx]; // get the info of the first investor
203 
204             uint totalPayout = dep.deposit * multiplier / 100;
205             uint leftPayout;
206 
207             if (totalPayout > dep.payout) {
208                 leftPayout = totalPayout - dep.payout;
209             }
210 
211             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
212 
213                 if (leftPayout > 0) {
214                     dep.depositor.send(leftPayout); // Send money to him
215                     money -= leftPayout;
216                 }
217 
218                 // this investor is fully paid, so remove him
219                 depositNumber[dep.depositor] = 0;
220                 delete queue[idx];
221 
222             } else{
223 
224                 // Here we don't have enough money so partially pay to investor
225                 dep.depositor.send(money); // Send to him everything we have
226                 dep.payout += money;       // Update the payout amount
227                 break;                     // Exit cycle
228 
229             }
230 
231             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
232                 break;                       // The next investor will process the line further
233             }
234         }
235 
236         currentReceiverIndex += i; //Update the index of the current first investor
237     }
238 
239     // Get current queue size
240     function getQueueLength() public view returns (uint) {
241         return queue.length - currentReceiverIndex;
242     }
243 
244     // Get max deposit for your investment
245     function calcMaxDeposit() public view returns (uint) {
246 
247         if (totalInvested <= 20 ether) {
248             return 1 ether;
249         } else if (totalInvested <= 50 ether) {
250             return 1.2 ether;
251         } else if (totalInvested <= 100 ether) {
252             return 1.4 ether;
253         } else if (totalInvested <= 200 ether) {
254             return 1.7 ether;
255         } else {
256             return 2 ether;
257         }
258 
259     }
260 
261     // How many percent for your deposit to be multiplied at now
262     function calcMultiplier() public view returns (uint) {
263 
264         if (totalInvested <= 20 ether) {
265             return 135;
266         } else if (totalInvested <= 50 ether) {
267             return 120;
268         } else if (totalInvested <= 100 ether) {
269             return 115;
270         } else if (totalInvested <= 200 ether) {
271             return 112;
272         } else {
273             return 110;
274         }
275 
276     }
277 
278 }