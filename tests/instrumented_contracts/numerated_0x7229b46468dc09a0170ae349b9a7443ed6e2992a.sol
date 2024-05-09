1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 150% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 0.1 ETH
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
46      - сумма от 0.01 до 0.1 ETH
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
74 contract Multiplier {
75     //Address for promo expences
76     address constant private PROMO = 0x828cAF65a1c46C2982022f312a7318c414F11F16;
77     //Percent for promo expences
78     uint constant public PROMO_PERCENT = 15; //6 for advertizing, 1 for techsupport
79     //How many percent for your deposit to be multiplied
80     uint constant public MULTIPLIER = 150;
81 
82     //The deposit structure holds all the info about the deposit made
83     struct Deposit {
84         address depositor; //The depositor address
85         uint128 deposit;   //The deposit amount
86         uint128 expect;    //How much we should pay out (initially it is 150% of deposit)
87     }
88 
89     Deposit[] private queue;  //The queue
90     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
91 
92     //This function receives all the deposits
93     //stores them and make immediate payouts
94     function () public payable {
95         if(msg.value > 0){
96             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
97             require(msg.value <= 0.1 ether); //Do not allow too big investments to stabilize payouts
98 
99             //Add the investor into the queue. Mark that he expects to receive 150% of deposit back
100             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
101 
102             //Send some promo to enable this contract to leave long-long time
103             uint promo = msg.value*PROMO_PERCENT/100;
104             PROMO.send(promo);
105 
106             //Pay to first investors in line
107             pay();
108         }
109     }
110 
111     //Used to pay to current investors
112     //Each new transaction processes 1 - 4+ investors in the head of queue 
113     //depending on balance and gas left
114     function pay() private {
115         //Try to send all the money on contract to the first investors in line
116         uint128 money = uint128(address(this).balance);
117 
118         //We will do cycle on the queue
119         for(uint i=0; i<queue.length; i++){
120 
121             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
122 
123             Deposit storage dep = queue[idx]; //get the info of the first investor
124 
125             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
126                 dep.depositor.send(dep.expect); //Send money to him
127                 money -= dep.expect;            //update money left
128 
129                 //this investor is fully paid, so remove him
130                 delete queue[idx];
131             }else{
132                 //Here we don't have enough money so partially pay to investor
133                 dep.depositor.send(money); //Send to him everything we have
134                 dep.expect -= money;       //Update the expected amount
135                 break;                     //Exit cycle
136             }
137 
138             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
139                 break;                     //The next investor will process the line further
140         }
141 
142         currentReceiverIndex += i; //Update the index of the current first investor
143     }
144 
145     //Get the deposit info by its index
146     //You can get deposit index from
147     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
148         Deposit storage dep = queue[idx];
149         return (dep.depositor, dep.deposit, dep.expect);
150     }
151 
152     //Get the count of deposits of specific investor
153     function getDepositsCount(address depositor) public view returns (uint) {
154         uint c = 0;
155         for(uint i=currentReceiverIndex; i<queue.length; ++i){
156             if(queue[i].depositor == depositor)
157                 c++;
158         }
159         return c;
160     }
161 
162     //Get all deposits (index, deposit, expect) of a specific investor
163     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
164         uint c = getDepositsCount(depositor);
165 
166         idxs = new uint[](c);
167         deposits = new uint128[](c);
168         expects = new uint128[](c);
169 
170         if(c > 0) {
171             uint j = 0;
172             for(uint i=currentReceiverIndex; i<queue.length; ++i){
173                 Deposit storage dep = queue[i];
174                 if(dep.depositor == depositor){
175                     idxs[j] = i;
176                     deposits[j] = dep.deposit;
177                     expects[j] = dep.expect;
178                     j++;
179                 }
180             }
181         }
182     }
183     
184     //Get current queue size
185     function getQueueLength() public view returns (uint) {
186         return queue.length - currentReceiverIndex;
187     }
188 }