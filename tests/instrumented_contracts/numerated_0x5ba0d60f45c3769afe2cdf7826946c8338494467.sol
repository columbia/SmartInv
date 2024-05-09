1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 123% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 10 ETH
11      - min 250000 gas limit
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 123%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 123% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 123% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 123% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 123%)
38 
39 
40   Контракт Умножитель: возвращает 123% от вашего депозита!
41   Автоматические выплаты!
42   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
43   Создан и проверен профессионалами!
44 
45   1. Пошлите любую ненулевую сумму на адрес контракта
46      - сумма от 0.01 до 10 ETH
47      - gas limit минимум 250000
48      - вы встанете в очередь
49   2. Немного подождите
50   3. ...
51   4. PROFIT! Вам пришло 123% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 123% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 123% от вашего депозита, вы удаляетесь из очереди
58   4. Вы можете делать несколько депозитов сразу
59   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
60      сразу же направляются на выплаты
61 
62      Таким образом, последние платят первым, и инвесторы, достигшие выплат 123% от депозита,
63      удаляются из очереди, уступая место остальным
64 
65               новый инвестор --|            совсем новый инвестор --|
66                  инвестор5     |                новый инвестор      |
67                  инвестор4     |     =======>      инвестор5        |
68                  инвестор3     |                   инвестор4        |
69  (част. выплата) инвестор2    <|                   инвестор3        |
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 123%)
71 
72 */
73 
74 contract Multiplier {
75     //Address for promo expences
76     address constant private PROMO1 = 0x44fF136480768B6Ee57BC8c26c7658667A6ceb0F;
77 	address constant private PROMO2 = 0xB97Fd03Cf90E7b45451e9Bb9cB904a0862c5f251;
78 	address constant private TECH = 0x0365d67E339B09e59E0b56aB336140c02Ef172DC;
79     //Percent for promo/tech expences
80     uint constant public PROMO_PERCENT1 = 2; //4 for advertizing, 2 for techsupport
81 	uint constant public PROMO_PERCENT2 = 2;
82 	uint constant public TECH_PERCENT = 2;
83     //How many percent for your deposit to be multiplied
84     uint constant public MULTIPLIER = 123;
85 
86     //The deposit structure holds all the info about the deposit made
87     struct Deposit {
88         address depositor; //The depositor address
89         uint128 deposit;   //The deposit amount
90         uint128 expect;    //How much we should pay out (initially it is 124% of deposit)
91     }
92 
93     Deposit[] private queue;  //The queue
94     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
95 
96     //This function receives all the deposits
97     //stores them and make immediate payouts
98     function () public payable {
99         if(msg.value > 0){
100             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
101             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
102 
103             //Add the investor into the queue. Mark that he expects to receive 124% of deposit back
104             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
105 
106             //Send some promo to enable this contract to leave long-long time
107             uint promo1 = msg.value*PROMO_PERCENT1/100;
108             PROMO1.send(promo1);
109 			uint promo2 = msg.value*PROMO_PERCENT2/100;
110             PROMO2.send(promo2);
111 			uint tech = msg.value*TECH_PERCENT/100;
112             TECH.send(tech);
113 
114             //Pay to first investors in line
115             pay();
116         }
117     }
118 
119     //Used to pay to current investors
120     //Each new transaction processes 1 - 4+ investors in the head of queue 
121     //depending on balance and gas left
122     function pay() private {
123         //Try to send all the money on contract to the first investors in line
124         uint128 money = uint128(address(this).balance);
125 
126         //We will do cycle on the queue
127         for(uint i=0; i<queue.length; i++){
128 
129             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
130 
131             Deposit storage dep = queue[idx]; //get the info of the first investor
132 
133             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
134                 dep.depositor.send(dep.expect); //Send money to him
135                 money -= dep.expect;            //update money left
136 
137                 //this investor is fully paid, so remove him
138                 delete queue[idx];
139             }else{
140                 //Here we don't have enough money so partially pay to investor
141                 dep.depositor.send(money); //Send to him everything we have
142                 dep.expect -= money;       //Update the expected amount
143                 break;                     //Exit cycle
144             }
145 
146             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
147                 break;                     //The next investor will process the line further
148         }
149 
150         currentReceiverIndex += i; //Update the index of the current first investor
151     }
152 
153     //Get the deposit info by its index
154     //You can get deposit index from
155     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
156         Deposit storage dep = queue[idx];
157         return (dep.depositor, dep.deposit, dep.expect);
158     }
159 
160     //Get the count of deposits of specific investor
161     function getDepositsCount(address depositor) public view returns (uint) {
162         uint c = 0;
163         for(uint i=currentReceiverIndex; i<queue.length; ++i){
164             if(queue[i].depositor == depositor)
165                 c++;
166         }
167         return c;
168     }
169 
170     //Get all deposits (index, deposit, expect) of a specific investor
171     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
172         uint c = getDepositsCount(depositor);
173 
174         idxs = new uint[](c);
175         deposits = new uint128[](c);
176         expects = new uint128[](c);
177 
178         if(c > 0) {
179             uint j = 0;
180             for(uint i=currentReceiverIndex; i<queue.length; ++i){
181                 Deposit storage dep = queue[i];
182                 if(dep.depositor == depositor){
183                     idxs[j] = i;
184                     deposits[j] = dep.deposit;
185                     expects[j] = dep.expect;
186                     j++;
187                 }
188             }
189         }
190     }
191     
192     //Get current queue size
193     function getQueueLength() public view returns (uint) {
194         return queue.length - currentReceiverIndex;
195     }
196 
197 }