1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6 
7   Web: https://www.multy150.today/
8   Telegram: https://t.me/multy150today
9 
10   Queue contract: returns 150% of each investment!
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
22   4. PROFIT! You have got 150%
23 
24   How is that?
25   1. The first investor in the queue (you will become the
26      first in some time) receives next investments until
27      it become 150% of his initial investment.
28   2. You will receive payments in several parts or all at once
29   3. Once you receive 150% of your initial investment you are
30      removed from the queue.
31   4. The balance of this contract should normally be 0 because
32      all the money are immediately go to payouts
33 
34 
35      So the last pays to the first (or to several first ones
36      if the deposit big enough) and the investors paid 150% are removed from the queue
37 
38                 new investor --|               brand new investor --|
39                  investor5     |                 new investor       |
40                  investor4     |     =======>      investor5        |
41                  investor3     |                   investor4        |
42     (part. paid) investor2    <|                   investor3        |
43     (fully paid) investor1   <-|                   investor2   <----|  (pay until 150%)
44 
45     ==> Limits: <==
46 
47     Multiplier: 150%
48     Minimum deposit: 0.05ETH
49     Maximum deposit: 10ETH
50 */
51 
52 
53 /**
54 
55   RU:
56 
57   Web: https://www.multy150.today/
58   Telegram: https://t.me/multy150today
59 
60   Контракт Умная Очередь: возвращает 150% от вашего депозита!
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
72   4. PROFIT! Вам пришло 150% от вашего депозита.
73 
74   Как это возможно?
75   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
76      новых инвесторов до тех пор, пока не получит 150% от своего депозита
77   2. Выплаты могут приходить несколькими частями или все сразу
78   3. Как только вы получаете 150% от вашего депозита, вы удаляетесь из очереди
79   4. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
80      сразу же направляются на выплаты
81 
82      Таким образом, последние платят первым, и инвесторы, достигшие выплат 150% от депозита,
83      удаляются из очереди, уступая место остальным
84 
85               новый инвестор --|            совсем новый инвестор --|
86                  инвестор5     |                новый инвестор      |
87                  инвестор4     |     =======>      инвестор5        |
88                  инвестор3     |                   инвестор4        |
89  (част. выплата) инвестор2    <|                   инвестор3        |
90 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 150%)
91 
92     ==> Лимиты: <==
93 
94     Профит: 150%
95     Минимальный вклад: 0.05 ETH
96     Максимальный вклад: 10 ETH
97 
98 
99 */
100 contract Multy {
101 
102 	//Address for promo expences
103     address constant private PROMO = 0xa3093FdE89050b3EAF6A9705f343757b4DfDCc4d;
104 	address constant private PRIZE = 0x86C1185CE646e549B13A6675C7a1DF073f3E3c0A;
105 	
106 	//Percent for promo expences
107     uint constant public PROMO_PERCENT = 6;
108     
109     //Bonus prize
110     uint constant public BONUS_PERCENT = 4;
111 		
112     //The deposit structure holds all the info about the deposit made
113     struct Deposit {
114         address depositor; // The depositor address
115         uint deposit;   // The deposit amount
116         uint payout; // Amount already paid
117     }
118 
119     Deposit[] public queue;  // The queue
120     mapping (address => uint) public depositNumber; // investor deposit index
121     uint public currentReceiverIndex; // The index of the depositor in the queue
122     uint public totalInvested; // Total invested amount
123 
124     //This function receives all the deposits
125     //stores them and make immediate payouts
126     function () public payable {
127         
128         require(block.number >= 6655835);
129 
130         if(msg.value > 0){
131 
132             require(gasleft() >= 250000); // We need gas to process queue
133             require(msg.value >= 0.05 ether && msg.value <= 10 ether); // Too small and too big deposits are not accepted
134             
135             // Add the investor into the queue
136             queue.push( Deposit(msg.sender, msg.value, 0) );
137             depositNumber[msg.sender] = queue.length;
138 
139             totalInvested += msg.value;
140 
141             //Send some promo to enable queue contracts to leave long-long time
142             uint promo = msg.value*PROMO_PERCENT/100;
143             PROMO.send(promo);
144             uint prize = msg.value*BONUS_PERCENT/100;
145             PRIZE.send(prize);
146             
147             // Pay to first investors in line
148             pay();
149 
150         }
151     }
152 
153     // Used to pay to current investors
154     // Each new transaction processes 1 - 4+ investors in the head of queue
155     // depending on balance and gas left
156     function pay() internal {
157 
158         uint money = address(this).balance;
159         uint multiplier = 150;
160 
161         // We will do cycle on the queue
162         for (uint i = 0; i < queue.length; i++){
163 
164             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
165 
166             Deposit storage dep = queue[idx]; // get the info of the first investor
167 
168             uint totalPayout = dep.deposit * multiplier / 100;
169             uint leftPayout;
170 
171             if (totalPayout > dep.payout) {
172                 leftPayout = totalPayout - dep.payout;
173             }
174 
175             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
176 
177                 if (leftPayout > 0) {
178                     dep.depositor.send(leftPayout); // Send money to him
179                     money -= leftPayout;
180                 }
181 
182                 // this investor is fully paid, so remove him
183                 depositNumber[dep.depositor] = 0;
184                 delete queue[idx];
185 
186             } else{
187 
188                 // Here we don't have enough money so partially pay to investor
189                 dep.depositor.send(money); // Send to him everything we have
190                 dep.payout += money;       // Update the payout amount
191                 break;                     // Exit cycle
192 
193             }
194 
195             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
196                 break;                       // The next investor will process the line further
197             }
198         }
199 
200         currentReceiverIndex += i; //Update the index of the current first investor
201     }
202     
203     //Returns your position in queue
204     function getDepositsCount(address depositor) public view returns (uint) {
205         uint c = 0;
206         for(uint i=currentReceiverIndex; i<queue.length; ++i){
207             if(queue[i].depositor == depositor)
208                 c++;
209         }
210         return c;
211     }
212 
213     // Get current queue size
214     function getQueueLength() public view returns (uint) {
215         return queue.length - currentReceiverIndex;
216     }
217 
218 }