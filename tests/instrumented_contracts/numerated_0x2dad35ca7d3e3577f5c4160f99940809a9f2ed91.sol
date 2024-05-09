1 pragma solidity ^0.4.25;
2 
3 /**
4   
5   EN:
6   
7   Multiplier contract: returns 130% of each investment!
8   
9   Automatic payouts!
10   No bugs, no backdoors, NO OWNER - fully automatic!
11   Made and checked by professionals!
12 
13   1. Send any sum to smart contract address
14      - sum from 0.01 to 10 ETH
15      - min 250000 gas limit
16      - you are added to a queue
17   2. Wait a little bit
18   3. ...
19   4. PROFIT! You have got 130%
20 
21   How is that?
22   1. The first investor in the queue (you will become the
23      first in some time) receives next investments until
24      it become 130% of his initial investment.
25   2. You will receive payments in several parts or all at once
26   3. Once you receive 130% of your initial investment you are
27      removed from the queue.
28   4. You can make multiple deposits
29   5. The balance of this contract should normally be 0 because
30      all the money are immediately go to payouts
31 
32 
33      So the last pays to the first (or to several first ones
34      if the deposit big enough) and the investors paid 130% are removed from the queue
35 
36                 new investor --|               brand new investor --|
37                  investor5     |                 new investor       |
38                  investor4     |     =======>      investor5        |
39                  investor3     |                   investor4        |
40     (part. paid) investor2    <|                   investor3        |
41     (fully paid) investor1   <-|                   investor2   <----|  (pay until 130%)
42 
43 */
44 
45 
46 /**
47 
48   RU:    
49 
50   Контракт Умножитель: возвращает 130% от вашего депозита!
51   
52   Автоматические выплаты!
53   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
54   Создан и проверен профессионалами!
55 
56   1. Пошлите любую ненулевую сумму на адрес контракта
57      - сумма от 0.01 до 10 ETH
58      - gas limit минимум 250000
59      - вы встанете в очередь
60   2. Немного подождите
61   3. ...
62   4. PROFIT! Вам пришло 130% от вашего депозита.
63 
64   Как это возможно?
65   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
66      новых инвесторов до тех пор, пока не получит 130% от своего депозита
67   2. Выплаты могут приходить несколькими частями или все сразу
68   3. Как только вы получаете 130% от вашего депозита, вы удаляетесь из очереди
69   4. Вы можете делать несколько депозитов сразу
70   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
71      сразу же направляются на выплаты
72 
73      Таким образом, последние платят первым, и инвесторы, достигшие выплат 130% от депозита,
74      удаляются из очереди, уступая место остальным
75 
76               новый инвестор --|            совсем новый инвестор --|
77                  инвестор5     |                новый инвестор      |
78                  инвестор4     |     =======>      инвестор5        |
79                  инвестор3     |                   инвестор4        |
80  (част. выплата) инвестор2    <|                   инвестор3        |
81 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 130%)
82 
83 */
84 
85 contract BestMultiplier {
86 
87     // address of the technical support of the project
88     address public support;
89 
90     // How many percent for your deposit to be multiplied
91     uint constant public MULTIPLIER = 130;
92 
93     //The deposit structure holds all the info about the deposit made
94     struct Deposit {
95         address depositor; //The depositor address
96         uint128 deposit;   //The deposit amount
97         uint128 expect;    //How much we should pay out (initially it is 130% of deposit)
98     }
99 
100     Deposit[] private queue;  //The queue
101     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
102 
103     mapping (address => bool) public notSupport; // The list of users allowed and forbidden to send 0.5% for support
104 
105     constructor() public {
106         support = msg.sender; // project support
107     }
108 
109     //This function receives all the deposits
110     //stores them and make immediate payouts
111     function () public payable {
112         
113         // You can not send 0.5% to support the project. To disable this feature, send 0.0000001 ether
114         if (msg.value == 0.0000001 ether) {
115             notSupport[msg.sender] = true;
116             return;
117         }
118         
119         if(msg.value > 0){
120             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
121             require(msg.value >= 0.01 ether); // Too small deposits are not accepted
122             require(msg.value <= 10 ether); // Do not allow too big investments to stabilize payouts
123 
124             //Add the investor into the queue. Mark that he expects to receive 130% of deposit back
125             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
126 
127             // Send 0.5% for support project if you agree to this
128             if (!notSupport[msg.sender]) {
129                  support.transfer(msg.value * 5 / 1000); // 0.5%
130             }
131             
132             //Pay to first investors in line
133             pay();
134         }
135     }
136 
137     //Used to pay to current investors
138     //Each new transaction processes 1 - 4+ investors in the head of queue 
139     //depending on balance and gas left
140     function pay() private {
141         //Try to send all the money on contract to the first investors in line
142         uint128 money = uint128(address(this).balance);
143 
144         //We will do cycle on the queue
145         for(uint i=0; i<queue.length; i++){
146 
147             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
148 
149             Deposit storage dep = queue[idx]; //get the info of the first investor
150 
151             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
152                 dep.depositor.send(dep.expect); //Send money to him
153                 money -= dep.expect;            //update money left
154 
155                 //this investor is fully paid, so remove him
156                 delete queue[idx];
157             }else{
158                 //Here we don't have enough money so partially pay to investor
159                 dep.depositor.send(money); //Send to him everything we have
160                 dep.expect -= money;       //Update the expected amount
161                 break;                     //Exit cycle
162             }
163 
164             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
165                 break;                     //The next investor will process the line further
166         }
167 
168         currentReceiverIndex += i; //Update the index of the current first investor
169     }
170 
171     //Get the deposit info by its index
172     //You can get deposit index from
173     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
174         Deposit storage dep = queue[idx];
175         return (dep.depositor, dep.deposit, dep.expect);
176     }
177 
178     //Get the count of deposits of specific investor
179     function getDepositsCount(address depositor) public view returns (uint) {
180         uint c = 0;
181         for(uint i=currentReceiverIndex; i<queue.length; ++i){
182             if(queue[i].depositor == depositor)
183                 c++;
184         }
185         return c;
186     }
187 
188     //Get all deposits (index, deposit, expect) of a specific investor
189     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
190         uint c = getDepositsCount(depositor);
191 
192         idxs = new uint[](c);
193         deposits = new uint128[](c);
194         expects = new uint128[](c);
195 
196         if(c > 0) {
197             uint j = 0;
198             for(uint i=currentReceiverIndex; i<queue.length; ++i){
199                 Deposit storage dep = queue[i];
200                 if(dep.depositor == depositor){
201                     idxs[j] = i;
202                     deposits[j] = dep.deposit;
203                     expects[j] = dep.expect;
204                     j++;
205                 }
206             }
207         }
208     }
209     
210     //Get current queue size
211     function getQueueLength() public view returns (uint) {
212         return queue.length - currentReceiverIndex;
213     }
214 
215 }