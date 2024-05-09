1 pragma solidity ^0.4.25;
2 
3 /** https://212eth.com
4  *
5   INVEST_212 contract: returns 212% of each investment!
6   Automatic payouts!
7   No bugs, no backdoors, NO OWNER - fully automatic!
8   Made and checked by professionals!
9 
10   1. Send any sum to smart contract address
11      - sum from 0.01 to 10 ETH
12      - min 200000 gas limit
13      - you are added to a queue
14   2. Wait a little bit
15   3. ...
16   4. PROFIT! You have got 212%
17 
18   How is that?
19   1. The first investor in the queue (you will become the
20      first in some time) receives next investments until
21      it become 212% of his initial investment.
22   2. You will receive payments in several parts or all at once
23   3. Once you receive 212% of your initial investment you are
24      removed from the queue.
25   4. You can make multiple deposits
26   5. The balance of this contract should normally be 0 because
27      all the money are immediately go to payouts
28 
29 
30      So the last pays to the first (or to several first ones
31      if the deposit big enough) and the investors paid 212% are removed from the queue
32 
33                 new investor --|               brand new investor --|
34                  investor5     |                 new investor       |
35                  investor4     |     =======>      investor5        |
36                  investor3     |                   investor4        |
37     (part. paid) investor2    <|                   investor3        |
38     (fully paid) investor1   <-|                   investor2   <----|  (pay until 212%)
39 
40 
41   Контракт Умножитель: возвращает 212% от вашего депозита!
42   Автоматические выплаты!
43   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
44   Создан и проверен профессионалами!
45 
46   1. Пошлите любую ненулевую сумму на адрес контракта
47      - сумма от 0.01 до 10 ETH
48      - gas limit минимум 250000
49      - вы встанете в очередь
50   2. Немного подождите
51   3. ...
52   4. PROFIT! Вам пришло 212% от вашего депозита.
53 
54   Как это возможно?
55   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
56      новых инвесторов до тех пор, пока не получит 212% от своего депозита
57   2. Выплаты могут приходить несколькими частями или все сразу
58   3. Как только вы получаете 212% от вашего депозита, вы удаляетесь из очереди
59   4. Вы можете делать несколько депозитов сразу
60   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
61      сразу же направляются на выплаты
62 
63      Таким образом, последние платят первым, и инвесторы, достигшие выплат 212% от депозита,
64      удаляются из очереди, уступая место остальным
65 
66               новый инвестор --|            совсем новый инвестор --|
67                  инвестор5     |                новый инвестор      |
68                  инвестор4     |     =======>      инвестор5        |
69                  инвестор3     |                   инвестор4        |
70  (част. выплата) инвестор2    <|                   инвестор3        |
71 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 212%)
72 
73 */
74 
75 contract TwoOneTwo_ETH {
76     //Address for promo expences
77     address constant private PROMO = 0xF5610DC0319Bbf6Ed5849c1f7f32a66d1376B2d0;
78     //Percent for promo expences
79     uint constant public PROMO_PERCENT = 212; //212 for investors
80     //How many percent for your deposit to be multiplied
81     uint constant public MULTIPLIER = 212;
82 
83     //The deposit structure holds all the info about the deposit made
84     struct Deposit {
85         address depositor; //The depositor address
86         uint128 deposit;   //The deposit amount
87         uint128 expect;    //How much we should pay out (initially it is 212% of deposit)
88     }
89 
90     Deposit[] private queue;  //The queue
91     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
92 
93     //This function receives all the deposits
94     //stores them and make immediate payouts
95     function () public payable {
96         if(msg.value > 0){
97             require(gasleft() >= 100000, "We require more gas!"); //We need gas to process queue
98             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
99 
100             //Add the investor into the queue. Mark that he expects to receive 212% of deposit back
101             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
102 
103             //Send some promo to enable this contract to leave long-long time
104             uint promo = msg.value*PROMO_PERCENT/100;
105             PROMO.send(promo);
106 
107             //Pay to first investors in line
108             pay();
109         }
110     }
111 
112     //Used to pay to current investors
113     //Each new transaction processes 1 - 4+ investors in the head of queue 
114     //depending on balance and gas left
115     function pay() private {
116         //Try to send all the money on contract to the first investors in line
117         uint128 money = uint128(address(this).balance);
118 
119         //We will do cycle on the queue
120         for(uint i=0; i<queue.length; i++){
121 
122             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
123 
124             Deposit storage dep = queue[idx]; //get the info of the first investor
125 
126             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
127                 dep.depositor.send(dep.expect); //Send money to him
128                 money -= dep.expect;            //update money left
129 
130                 //this investor is fully paid, so remove him
131                 delete queue[idx];
132             }else{
133                 //Here we don't have enough money so partially pay to investor
134                 dep.depositor.send(money); //Send to him everything we have
135                 dep.expect -= money;       //Update the expected amount
136                 break;                     //Exit cycle
137             }
138 
139             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
140                 break;                     //The next investor will process the line further
141         }
142 
143         currentReceiverIndex += i; //Update the index of the current first investor
144     }
145 
146     //Get the deposit info by its index
147     //You can get deposit index from
148     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
149         Deposit storage dep = queue[idx];
150         return (dep.depositor, dep.deposit, dep.expect);
151     }
152 
153     //Get the count of deposits of specific investor
154     function getDepositsCount(address depositor) public view returns (uint) {
155         uint c = 0;
156         for(uint i=currentReceiverIndex; i<queue.length; ++i){
157             if(queue[i].depositor == depositor)
158                 c++;
159         }
160         return c;
161     }
162 
163     //Get all deposits (index, deposit, expect) of a specific investor
164     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
165         uint c = getDepositsCount(depositor);
166 
167         idxs = new uint[](c);
168         deposits = new uint128[](c);
169         expects = new uint128[](c);
170 
171         if(c > 0) {
172             uint j = 0;
173             for(uint i=currentReceiverIndex; i<queue.length; ++i){
174                 Deposit storage dep = queue[i];
175                 if(dep.depositor == depositor){
176                     idxs[j] = i;
177                     deposits[j] = dep.deposit;
178                     expects[j] = dep.expect;
179                     j++;
180                 }
181             }
182         }
183     }
184     
185     //Get current queue size
186     function getQueueLength() public view returns (uint) {
187         return queue.length - currentReceiverIndex;
188     }
189 
190 }