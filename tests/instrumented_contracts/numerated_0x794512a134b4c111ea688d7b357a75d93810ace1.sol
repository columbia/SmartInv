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
105 	address constant private PRIZE	= 0xeE9B823ef62FfB79aFf2C861eDe7d632bbB5B653;
106 	
107 	//Percent for promo expences
108     uint constant public PROMO_PERCENT = 5;
109     
110     //Bonus prize
111     uint constant public BONUS_PERCENT = 5;
112 	
113     // Start time
114     uint constant StartEpoc = 1541260770;                     
115                          
116     //The deposit structure holds all the info about the deposit made
117     struct Deposit {
118         address depositor; // The depositor address
119         uint deposit;   // The deposit amount
120         uint payout; // Amount already paid
121     }
122 
123     Deposit[] public queue;  // The queue
124     mapping (address => uint) public depositNumber; // investor deposit index
125     uint public currentReceiverIndex; // The index of the depositor in the queue
126     uint public totalInvested; // Total invested amount
127 
128     //This function receives all the deposits
129     //stores them and make immediate payouts
130     function () public payable {
131         
132         require(now >= StartEpoc);
133 
134         if(msg.value > 0){
135 
136             require(gasleft() >= 250000); // We need gas to process queue
137             require(msg.value >= 0.05 ether && msg.value <= 10 ether); // Too small and too big deposits are not accepted
138             
139             // Add the investor into the queue
140             queue.push( Deposit(msg.sender, msg.value, 0) );
141             depositNumber[msg.sender] = queue.length;
142 
143             totalInvested += msg.value;
144 
145             //Send some promo to enable queue contracts to leave long-long time
146             uint promo1 = msg.value*PROMO_PERCENT/100;
147             PROMO1.transfer(promo1);
148 			uint promo2 = msg.value*PROMO_PERCENT/100;
149             PROMO2.transfer(promo2);			
150             uint prize = msg.value*BONUS_PERCENT/100;
151             PRIZE.transfer(prize);
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
165         uint multiplier = 125;
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
184                     dep.depositor.transfer(leftPayout); // Send money to him
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
195                 dep.depositor.transfer(money); // Send to him everything we have
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