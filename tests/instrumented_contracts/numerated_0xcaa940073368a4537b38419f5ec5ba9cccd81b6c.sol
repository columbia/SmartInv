1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 150% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 1 ETH
11      - min 250000 gas limit
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 150%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 150% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 150% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 150% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 150%)
38 
39 
40   Контракт Умножитель: возвращает 150% от вашего депозита!
41   Автоматические выплаты!
42   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
43   Создан и проверен профессионалами!
44 
45   1. Пошлите любую ненулевую сумму на адрес контракта
46      - сумма от 0.01 до 1 ETH  лимит в 1 eth  очередь в 10 раз быстрей
47      - gas limit минимум 250000
48      - вы встанете в очередь
49   2. Немного подождите
50   3. ...
51   4. PROFIT! Вам пришло 150% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 150% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 150% от вашего депозита, вы удаляетесь из очереди
58   4. Вы можете делать несколько депозитов сразу
59   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
60      сразу же направляются на выплаты
61 
62      Таким образом, последние платят первым, и инвесторы, достигшие выплат 150% от депозита,
63      удаляются из очереди, уступая место остальным
64 
65               новый инвестор --|            совсем новый инвестор --|
66                  инвестор5     |                новый инвестор      |
67                  инвестор4     |     =======>      инвестор5        |
68                  инвестор3     |                   инвестор4        |
69  (част. выплата) инвестор2    <|                   инвестор3        |
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 150%)
71 
72 */
73 
74 
75 
76 contract MultiX150max1eth {
77     //Address for promo expences
78     address constant private PROMO = 0x74E6B17a922C741c4dA0b71796eFB0edDDda398a;
79     //Percent for promo expences
80     uint constant public PROMO_PERCENT = 10;
81     //How many percent for your deposit to be multiplied
82     uint constant public MULTIPLIER = 150;
83 
84     //The deposit structure holds all the info about the deposit made
85     struct Deposit {
86         address depositor; //The depositor address
87         uint128 deposit;   //The deposit amount
88         uint128 expect;    //How much we should pay out (initially it is 150% of deposit)
89     }
90 
91     Deposit[] private queue;  //The queue
92     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
93 
94     //This function receives all the deposits
95     //stores them and make immediate payouts
96     function () public payable {
97         if(msg.value > 0){
98             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
99             require(msg.value <= 1 ether); //Do not allow too big investments to stabilize payouts
100 
101             //Add the investor into the queue. Mark that he expects to receive 150% of deposit back
102             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
103 
104             //Send some promo to enable this contract to leave long-long time
105             uint promo = msg.value*PROMO_PERCENT/100;
106             PROMO.transfer(promo);
107 
108             //Pay to first investors in line
109             pay();
110         }
111     }
112 
113     //Used to pay to current investors
114     //Each new transaction processes 1 - 4+ investors in the head of queue 
115     //depending on balance and gas left
116     function pay() private {
117         //Try to send all the money on contract to the first investors in line
118         uint128 money = uint128(address(this).balance);
119 
120         //We will do cycle on the queue
121         for(uint i=0; i<queue.length; i++){
122 
123             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
124 
125             Deposit storage dep = queue[idx]; //get the info of the first investor
126 
127             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
128                 dep.depositor.transfer(dep.expect); //Send money to him
129                 money -= dep.expect;            //update money left
130 
131                 //this investor is fully paid, so remove him
132                 delete queue[idx];
133             }else{
134                 //Here we don't have enough money so partially pay to investor
135                 dep.depositor.transfer(money); //Send to him everything we have
136                 dep.expect -= money;       //Update the expected amount
137                 break;                     //Exit cycle
138             }
139 
140             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
141                 break;                     //The next investor will process the line further
142         }
143 
144         currentReceiverIndex += i; //Update the index of the current first investor
145     }
146 
147     //Get the deposit info by its index
148     //You can get deposit index from
149     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
150         Deposit storage dep = queue[idx];
151         return (dep.depositor, dep.deposit, dep.expect);
152     }
153 
154     //Get the count of deposits of specific investor
155     function getDepositsCount(address depositor) public view returns (uint) {
156         uint c = 0;
157         for(uint i=currentReceiverIndex; i<queue.length; ++i){
158             if(queue[i].depositor == depositor)
159                 c++;
160         }
161         return c;
162     }
163 
164     //Get all deposits (index, deposit, expect) of a specific investor
165     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
166         uint c = getDepositsCount(depositor);
167 
168         idxs = new uint[](c);
169         deposits = new uint128[](c);
170         expects = new uint128[](c);
171 
172         if(c > 0) {
173             uint j = 0;
174             for(uint i=currentReceiverIndex; i<queue.length; ++i){
175                 Deposit storage dep = queue[i];
176                 if(dep.depositor == depositor){
177                     idxs[j] = i;
178                     deposits[j] = dep.deposit;
179                     expects[j] = dep.expect;
180                     j++;
181                 }
182             }
183         }
184     }
185     
186     //Get current queue size
187     function getQueueLength() public view returns (uint) {
188         return queue.length - currentReceiverIndex;
189     }
190 
191 }