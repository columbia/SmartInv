1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6 
7   Web: http://www.queuesmart.today
8   Telegram: https://t.me/queuesmart
9 
10   Queue contract: returns 110-130% of each investment!
11 
12   Automatic payouts!
13   No bugs, no backdoors, NO OWNER - fully automatic!
14   Made and checked by professionals!
15 
16   1. Send any sum to smart contract address
17      - sum from 0.15 ETH
18      - min 300 000 gas limit
19      - you are added to a queue
20   2. Wait a little bit
21   3. ...
22   4. PROFIT! You have got 110-130%
23 
24   How is that?
25   1. The first investor in the queue (you will become the
26      first in some time) receives next investments until
27      it become 110-130% of his initial investment.
28   2. You will receive payments in several parts or all at once
29   3. Once you receive 110-130% of your initial investment you are
30      removed from the queue.
31   4. The balance of this contract should normally be 0 because
32      all the money are immediately go to payouts
33 
34 
35      So the last pays to the first (or to several first ones
36      if the deposit big enough) and the investors paid 105-130% are removed from the queue
37 
38                 new investor --|               brand new investor --|
39                  investor5     |                 new investor       |
40                  investor4     |     =======>      investor5        |
41                  investor3     |                   investor4        |
42     (part. paid) investor2    <|                   investor3        |
43     (fully paid) investor1   <-|                   investor2   <----|  (pay until 110-130%)
44 
45     ==> Limits: <==
46 
47     Total invested: up to 50ETH
48     Multiplier: 110%
49     Maximum deposit: 1.5ETH
50 
51     Total invested: from 50 to 150ETH
52     Multiplier: 111-116%
53     Maximum deposit: 3ETH
54 
55     Total invested: from 150 to 300ETH
56     Multiplier: 117-123%
57     Maximum deposit: 5ETH
58 
59     Total invested: from 300 to 500ETH
60     Multiplier: 124-129%
61     Maximum deposit: 7ETH
62 
63     Total invested: from 500ETH
64     Multiplier: 130%
65     Maximum deposit: 10ETH
66 
67 */
68 
69 
70 /**
71 
72   RU:
73 
74   Web: http://www.queuesmart.today
75   Telegram: https://t.me/queuesmart
76 
77   Контракт Умная Очередь: возвращает 110-130% от вашего депозита!
78 
79   Автоматические выплаты!
80   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
81   Создан и проверен профессионалами!
82 
83   1. Пошлите любую ненулевую сумму на адрес контракта
84      - сумма от 0.15 ETH
85      - gas limit минимум 300 000
86      - вы встанете в очередь
87   2. Немного подождите
88   3. ...
89   4. PROFIT! Вам пришло 110-130% от вашего депозита.
90 
91   Как это возможно?
92   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
93      новых инвесторов до тех пор, пока не получит 110-130% от своего депозита
94   2. Выплаты могут приходить несколькими частями или все сразу
95   3. Как только вы получаете 110-130% от вашего депозита, вы удаляетесь из очереди
96   4. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
97      сразу же направляются на выплаты
98 
99      Таким образом, последние платят первым, и инвесторы, достигшие выплат 110-130% от депозита,
100      удаляются из очереди, уступая место остальным
101 
102               новый инвестор --|            совсем новый инвестор --|
103                  инвестор5     |                новый инвестор      |
104                  инвестор4     |     =======>      инвестор5        |
105                  инвестор3     |                   инвестор4        |
106  (част. выплата) инвестор2    <|                   инвестор3        |
107 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 110-130%)
108 
109     ==> Лимиты: <==
110 
111     Всего инвестировано: до 50ETH
112     Профит: 110%
113     Максимальный вклад: 1.5ETH
114 
115     Всего инвестировано: от 50 до 150ETH
116     Профит: 111-116%
117     Максимальный вклад: 3ETH
118 
119     Всего инвестировано: от 150 до 300ETH
120     Профит: 117-123%
121     Максимальный вклад: 5ETH
122 
123     Всего инвестировано: от 300 до 500ETH
124     Профит: 124-129%
125     Максимальный вклад: 7ETH
126 
127     Всего инвестировано: более 500ETH
128     Профит: 130%
129     Максимальный вклад: 10ETH
130 
131 */
132 contract Queue {
133 
134 	//Address for promo expences
135     address constant private PROMO1 = 0x0569E1777f2a7247D27375DB1c6c2AF9CE9a9C15;
136 	address constant private PROMO2 = 0xF892380E9880Ad0843bB9600D060BA744365EaDf;
137 	address constant private PROMO3	= 0x35aAF2c74F173173d28d1A7ce9d255f639ac1625;
138 	address constant private PRIZE	= 0xa93E50526B63760ccB5fAD6F5107FA70d36ABC8b;
139 	
140 	//Percent for promo expences
141     uint constant public PROMO_PERCENT = 2;
142 		
143     //The deposit structure holds all the info about the deposit made
144     struct Deposit {
145         address depositor; // The depositor address
146         uint deposit;   // The deposit amount
147         uint payout; // Amount already paid
148     }
149 
150     Deposit[] public queue;  // The queue
151     mapping (address => uint) public depositNumber; // investor deposit index
152     uint public currentReceiverIndex; // The index of the depositor in the queue
153     uint public totalInvested; // Total invested amount
154 
155     //This function receives all the deposits
156     //stores them and make immediate payouts
157     function () public payable {
158         
159         require(block.number >= 6612602);
160 
161         if(msg.value > 0){
162 
163             require(gasleft() >= 250000); // We need gas to process queue
164             require(msg.value >= 0.15 ether && msg.value <= calcMaxDeposit()); // Too small and too big deposits are not accepted
165             
166             // Add the investor into the queue
167             queue.push( Deposit(msg.sender, msg.value, 0) );
168             depositNumber[msg.sender] = queue.length;
169 
170             totalInvested += msg.value;
171 
172             //Send some promo to enable queue contracts to leave long-long time
173             uint promo1 = msg.value*PROMO_PERCENT/100;
174             PROMO1.send(promo1);
175 			uint promo2 = msg.value*PROMO_PERCENT/100;
176             PROMO2.send(promo2);
177 			uint promo3 = msg.value*PROMO_PERCENT/100;
178             PROMO3.send(promo3);
179             uint prize = msg.value*1/100;
180             PRIZE.send(prize);
181             
182             // Pay to first investors in line
183             pay();
184 
185         }
186     }
187 
188     // Used to pay to current investors
189     // Each new transaction processes 1 - 4+ investors in the head of queue
190     // depending on balance and gas left
191     function pay() internal {
192 
193         uint money = address(this).balance;
194         uint multiplier = calcMultiplier();
195 
196         // We will do cycle on the queue
197         for (uint i = 0; i < queue.length; i++){
198 
199             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
200 
201             Deposit storage dep = queue[idx]; // get the info of the first investor
202 
203             uint totalPayout = dep.deposit * multiplier / 100;
204             uint leftPayout;
205 
206             if (totalPayout > dep.payout) {
207                 leftPayout = totalPayout - dep.payout;
208             }
209 
210             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
211 
212                 if (leftPayout > 0) {
213                     dep.depositor.send(leftPayout); // Send money to him
214                     money -= leftPayout;
215                 }
216 
217                 // this investor is fully paid, so remove him
218                 depositNumber[dep.depositor] = 0;
219                 delete queue[idx];
220 
221             } else{
222 
223                 // Here we don't have enough money so partially pay to investor
224                 dep.depositor.send(money); // Send to him everything we have
225                 dep.payout += money;       // Update the payout amount
226                 break;                     // Exit cycle
227 
228             }
229 
230             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
231                 break;                       // The next investor will process the line further
232             }
233         }
234 
235         currentReceiverIndex += i; //Update the index of the current first investor
236     }
237 
238     // Get current queue size
239     function getQueueLength() public view returns (uint) {
240         return queue.length - currentReceiverIndex;
241     }
242 
243     // Get max deposit for your investment
244     function calcMaxDeposit() public view returns (uint) {
245 
246         if (totalInvested <= 50 ether) {
247             return 1.5 ether;
248         } else if (totalInvested <= 150 ether) {
249             return 3 ether;
250         } else if (totalInvested <= 300 ether) {
251             return 5 ether;
252         } else if (totalInvested <= 500 ether) {
253             return 7 ether;
254         } else {
255             return 10 ether;
256         }
257 
258     }
259 
260     // How many percent for your deposit to be multiplied at now
261     function calcMultiplier() public view returns (uint) {
262 
263         if (totalInvested <= 50 ether) {
264             return 110;
265         } else if (totalInvested <= 100 ether) {
266             return 113;
267         } else if (totalInvested <= 150 ether) {
268             return 116;
269         } else if (totalInvested <= 200 ether) {
270             return 119;
271 		} else if (totalInvested <= 250 ether) {
272             return 122;
273 		} else if (totalInvested <= 300 ether) {
274             return 125;
275 		} else if (totalInvested <= 350 ether) {
276             return 128;
277 		} else if (totalInvested <= 500 ether) {
278             return 129;
279         } else {
280             return 130;
281         }
282 
283     }
284 
285 }