1 pragma solidity ^0.4.25;
2 
3 /**
4 
5   EN:
6 
7   Web: http://fasteth.online/
8   Telegram: https://t.me/fasteth
9 
10   Queue contract: returns 125% of each investment!
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
22   4. PROFIT! You have got 125%
23 
24   How is that?
25   1. The first investor in the queue (you will become the
26      first in some time) receives next investments until
27      it become 125% of his initial investment.
28   2. You will receive payments in several parts or all at once
29   3. Once you receive 125% of your initial investment you are
30      removed from the queue.
31   4. The balance of this contract should normally be 0 because
32      all the money are immediately go to payouts
33 
34 
35      So the last pays to the first (or to several first ones
36      if the deposit big enough) and the investors paid 125% are removed from the queue
37 
38                 new investor --|               brand new investor --|
39                  investor5     |                 new investor       |
40                  investor4     |     =======>      investor5        |
41                  investor3     |                   investor4        |
42     (part. paid) investor2    <|                   investor3        |
43     (fully paid) investor1   <-|                   investor2   <----|  (pay until 125%)
44 
45     ==> Limits: <==
46 
47     Multiplier: 125%
48     Minimum deposit: 0.05ETH
49     Maximum deposit: 10ETH
50 */
51 
52 
53 /**
54 
55   RU:
56 
57   Web: http://fasteth.online/
58   Telegram: https://t.me/fasteth
59 
60   Контракт Умная Очередь: возвращает 125% от вашего депозита!
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
72   4. PROFIT! Вам пришло 125% от вашего депозита.
73 
74   Как это возможно?
75   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
76      новых инвесторов до тех пор, пока не получит 120% от своего депозита
77   2. Выплаты могут приходить несколькими частями или все сразу
78   3. Как только вы получаете 125% от вашего депозита, вы удаляетесь из очереди
79   4. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
80      сразу же направляются на выплаты
81 
82      Таким образом, последние платят первым, и инвесторы, достигшие выплат 125% от депозита,
83      удаляются из очереди, уступая место остальным
84 
85               новый инвестор --|            совсем новый инвестор --|
86                  инвестор5     |                новый инвестор      |
87                  инвестор4     |     =======>      инвестор5        |
88                  инвестор3     |                   инвестор4        |
89  (част. выплата) инвестор2    <|                   инвестор3        |
90 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 125%)
91 
92     ==> Лимиты: <==
93 
94     Профит: 125%
95     Минимальный вклад: 0.05 ETH
96     Максимальный вклад: 10 ETH
97 
98 
99 */
100 contract FastEth {
101 
102 	//Address for promo expences
103     address constant private PROMO1 = 0xaC780d067c52227ac7563FBe975eD9A8F235eb35;
104 	address constant private PROMO2 = 0x6dBFFf54E23Cf6DB1F72211e0683a5C6144E8F03;
105 	address constant private CASHBACK = 0x33cA4CbC4b171c32C16c92AFf9feE487937475F8;
106 	address constant private PRIZE	= 0xeE9B823ef62FfB79aFf2C861eDe7d632bbB5B653;
107 	
108 	//Percent for promo expences
109     uint constant public PERCENT = 4;
110     
111     //Bonus prize
112     uint constant public BONUS_PERCENT = 5;
113 	
114     // Start time
115     uint constant StartEpoc = 1541329170;                     
116                          
117     //The deposit structure holds all the info about the deposit made
118     struct Deposit {
119         address depositor; // The depositor address
120         uint deposit;   // The deposit amount
121         uint payout; // Amount already paid
122     }
123 
124     Deposit[] public queue;  // The queue
125     mapping (address => uint) public depositNumber; // investor deposit index
126     uint public currentReceiverIndex; // The index of the depositor in the queue
127     uint public totalInvested; // Total invested amount
128 
129     //This function receives all the deposits
130     //stores them and make immediate payouts
131     function () public payable {
132         
133         require(now >= StartEpoc);
134 
135         if(msg.value > 0){
136 
137             require(gasleft() >= 250000); // We need gas to process queue
138             require(msg.value >= 0.05 ether && msg.value <= 10 ether); // Too small and too big deposits are not accepted
139             
140             // Add the investor into the queue
141             queue.push( Deposit(msg.sender, msg.value, 0) );
142             depositNumber[msg.sender] = queue.length;
143 
144             totalInvested += msg.value;
145 
146             //Send some promo to enable queue contracts to leave long-long time
147             uint promo1 = msg.value*PERCENT/100;
148             PROMO1.transfer(promo1);
149 			uint promo2 = msg.value*PERCENT/100;
150             PROMO2.transfer(promo2);
151 			uint cashback = msg.value*PERCENT/100;
152 			CASHBACK.transfer(cashback);
153             uint prize = msg.value*BONUS_PERCENT/100;
154             PRIZE.transfer(prize);
155             
156             // Pay to first investors in line
157             pay();
158 
159         }
160     }
161 
162     // Used to pay to current investors
163     // Each new transaction processes 1 - 4+ investors in the head of queue
164     // depending on balance and gas left
165     function pay() internal {
166 
167         uint money = address(this).balance;
168         uint multiplier = 125;
169 
170         // We will do cycle on the queue
171         for (uint i = 0; i < queue.length; i++){
172 
173             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
174 
175             Deposit storage dep = queue[idx]; // get the info of the first investor
176 
177             uint totalPayout = dep.deposit * multiplier / 100;
178             uint leftPayout;
179 
180             if (totalPayout > dep.payout) {
181                 leftPayout = totalPayout - dep.payout;
182             }
183 
184             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
185 
186                 if (leftPayout > 0) {
187                     dep.depositor.transfer(leftPayout); // Send money to him
188                     money -= leftPayout;
189                 }
190 
191                 // this investor is fully paid, so remove him
192                 depositNumber[dep.depositor] = 0;
193                 delete queue[idx];
194 
195             } else{
196 
197                 // Here we don't have enough money so partially pay to investor
198                 dep.depositor.transfer(money); // Send to him everything we have
199                 dep.payout += money;       // Update the payout amount
200                 break;                     // Exit cycle
201 
202             }
203 
204             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
205                 break;                       // The next investor will process the line further
206             }
207         }
208 
209         currentReceiverIndex += i; //Update the index of the current first investor
210     }
211     
212     //Returns your position in queue
213     function getDepositsCount(address depositor) public view returns (uint) {
214         uint c = 0;
215         for(uint i=currentReceiverIndex; i<queue.length; ++i){
216             if(queue[i].depositor == depositor)
217                 c++;
218         }
219         return c;
220     }
221 
222     // Get current queue size
223     function getQueueLength() public view returns (uint) {
224         return queue.length - currentReceiverIndex;
225     }
226 
227 }