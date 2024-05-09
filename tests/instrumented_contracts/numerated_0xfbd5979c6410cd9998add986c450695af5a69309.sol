1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6 
7   Web: http://www.queuesmart.today
8   Telegram: https://t.me/queuesmart
9 
10   Queue contract: returns 120% of each investment!
11 
12   Automatic payouts!
13   No bugs, no backdoors, NO OWNER - fully automatic!
14   Made and checked by professionals!
15 
16   1. Send any sum to smart contract address
17      - sum from 0.05 ETH
18      - min 350 000 gas limit
19      - you are added to a queue
20   2. Wait a little bit
21   3. ...
22   4. PROFIT! You have got 120%
23 
24   How is that?
25   1. The first investor in the queue (you will become the
26      first in some time) receives next investments until
27      it become 120% of his initial investment.
28   2. You will receive payments in several parts or all at once
29   3. Once you receive 120% of your initial investment you are
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
43     (fully paid) investor1   <-|                   investor2   <----|  (pay until 120%)
44 
45     ==> Limits: <==
46 
47     Multiplier: 120%
48     Minimum deposit: 0.05ETH
49     Maximum deposit: 10ETH
50 */
51 
52 
53 /**
54 
55   RU:
56 
57   Web: http://www.queuesmart.today
58   Telegram: https://t.me/queuesmarten
59 
60   Контракт Умная Очередь: возвращает 120% от вашего депозита!
61 
62   Автоматические выплаты!
63   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
64   Создан и проверен профессионалами!
65 
66   1. Пошлите любую ненулевую сумму на адрес контракта
67      - сумма от 0.05 ETH
68      - gas limit минимум 350 000
69      - вы встанете в очередь
70   2. Немного подождите
71   3. ...
72   4. PROFIT! Вам пришло 120% от вашего депозита.
73 
74   Как это возможно?
75   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
76      новых инвесторов до тех пор, пока не получит 120% от своего депозита
77   2. Выплаты могут приходить несколькими частями или все сразу
78   3. Как только вы получаете 120% от вашего депозита, вы удаляетесь из очереди
79   4. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
80      сразу же направляются на выплаты
81 
82      Таким образом, последние платят первым, и инвесторы, достигшие выплат 120% от депозита,
83      удаляются из очереди, уступая место остальным
84 
85               новый инвестор --|            совсем новый инвестор --|
86                  инвестор5     |                новый инвестор      |
87                  инвестор4     |     =======>      инвестор5        |
88                  инвестор3     |                   инвестор4        |
89  (част. выплата) инвестор2    <|                   инвестор3        |
90 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 120%)
91 
92     ==> Лимиты: <==
93 
94     Профит: 120%
95     Минимальный вклад: 0.05 ETH
96     Максимальный вклад: 10 ETH
97 
98 
99 */
100 contract Queue {
101 
102 	//Address for promo expences
103     address constant private PROMO1 = 0x0569E1777f2a7247D27375DB1c6c2AF9CE9a9C15;
104 	address constant private PROMO2 = 0xF892380E9880Ad0843bB9600D060BA744365EaDf;
105 	address constant private PROMO3	= 0x35aAF2c74F173173d28d1A7ce9d255f639ac1625;
106 	address constant private PRIZE	= 0xa93E50526B63760ccB5fAD6F5107FA70d36ABC8b;
107 	
108     uint constant public PROMO_PERCENT = 2; //Percent for promo expences
109     uint constant public BONUS_PERCENT = 4; //Bonus prize
110     uint256 public constant GAS_PRICE_MAX = 30000000000 wei; // maximum gas price for contribution transactions
111     uint startTime = 1541781000; //start time
112 		
113     //The deposit structure holds all the info about the deposit made
114     struct Deposit {
115         address depositor; // The depositor address
116         uint deposit;   // The deposit amount
117         uint payout; // Amount already paid
118     }
119 
120     Deposit[] public queue;  // The queue
121     mapping (address => uint) public depositNumber; // investor deposit index
122     uint public currentReceiverIndex; // The index of the depositor in the queue
123     uint public totalInvested; // Total invested amount
124 
125     //This function receives all the deposits
126     //stores them and make immediate payouts
127     function () public payable {
128         
129         require(block.timestamp >= startTime);
130         require(tx.gasprice <= GAS_PRICE_MAX);
131         
132         if(msg.value > 0){
133 
134             require(gasleft() >= 250000); // We need gas to process queue
135             require(msg.value >= 0.05 ether && msg.value <= 10 ether); // Too small and too big deposits are not accepted
136            
137             // Add the investor into the queue
138             queue.push( Deposit(msg.sender, msg.value, 0) );
139             depositNumber[msg.sender] = queue.length;
140 
141             totalInvested += msg.value;
142 
143             //Send some promo to enable queue contracts to leave long-long time
144             uint promo1 = msg.value*PROMO_PERCENT/100;
145             PROMO1.send(promo1);
146 			uint promo2 = msg.value*PROMO_PERCENT/100;
147             PROMO2.send(promo2);
148 			uint promo3 = msg.value*PROMO_PERCENT/100;
149             PROMO3.send(promo3);
150             uint prize = msg.value*BONUS_PERCENT/100;
151             PRIZE.send(prize);
152             
153             // Pay to first investors in line
154             pay();
155 
156         }
157     }
158 
159     // Used to pay to current investors
160     // Each new transaction processes 1 - 4+ investors in the head of queue
161     // depending on balance and gas left
162     function pay() internal {
163 
164         uint money = address(this).balance;
165         uint multiplier = 120;
166 
167         // We will do cycle on the queue
168         for (uint i = 0; i < queue.length; i++){
169 
170             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
171 
172             Deposit storage dep = queue[idx]; // get the info of the first investor
173 
174             uint totalPayout = dep.deposit * multiplier / 100;
175             uint leftPayout;
176 
177             if (totalPayout > dep.payout) {
178                 leftPayout = totalPayout - dep.payout;
179             }
180 
181             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
182 
183                 if (leftPayout > 0) {
184                     dep.depositor.send(leftPayout); // Send money to him
185                     money -= leftPayout;
186                 }
187 
188                 // this investor is fully paid, so remove him
189                 depositNumber[dep.depositor] = 0;
190                 delete queue[idx];
191 
192             } else{
193 
194                 // Here we don't have enough money so partially pay to investor
195                 dep.depositor.send(money); // Send to him everything we have
196                 dep.payout += money;       // Update the payout amount
197                 break;                     // Exit cycle
198 
199             }
200 
201             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
202                 break;                       // The next investor will process the line further
203             }
204         }
205 
206         currentReceiverIndex += i; //Update the index of the current first investor
207     }
208     
209     //Returns your position in queue
210     function getDepositsCount(address depositor) public view returns (uint) {
211         uint c = 0;
212         for(uint i=currentReceiverIndex; i<queue.length; ++i){
213             if(queue[i].depositor == depositor)
214                 c++;
215         }
216         return c;
217     }
218 
219     // Get current queue size
220     function getQueueLength() public view returns (uint) {
221         return queue.length - currentReceiverIndex;
222     }
223 
224 }