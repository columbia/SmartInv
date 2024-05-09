1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier2 contract: returns 111% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 3 ETH
11      - min 280000 gas limit
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 111%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 111% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 111% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 111% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 111%)
38 
39 
40   Контракт Умножитель2: возвращает 111% от вашего депозита!
41   Автоматические выплаты!
42   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
43   Создан и проверен профессионалами!
44 
45   1. Пошлите любую ненулевую сумму на адрес контракта
46      - сумма от 0.01 до 3 ETH
47      - gas limit минимум 280000
48      - вы встанете в очередь
49   2. Немного подождите
50   3. ...
51   4. PROFIT! Вам пришло 111% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 111% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 111% от вашего депозита, вы удаляетесь из очереди
58   4. Вы можете делать несколько депозитов сразу
59   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
60      сразу же направляются на выплаты
61 
62      Таким образом, последние платят первым, и инвесторы, достигшие выплат 111% от депозита,
63      удаляются из очереди, уступая место остальным
64 
65               новый инвестор --|            совсем новый инвестор --|
66                  инвестор5     |                новый инвестор      |
67                  инвестор4     |     =======>      инвестор5        |
68                  инвестор3     |                   инвестор4        |
69  (част. выплата) инвестор2    <|                   инвестор3        |
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 111%)
71 
72 */
73 
74 contract Multiplier2 {
75     //Address of old Multiplier
76     address constant private FATHER = 0x7CDfA222f37f5C4CCe49b3bBFC415E8C911D1cD8;
77     //Address for tech and promo expences
78     address constant private TECH_AND_PROMO = 0xdA149b17C154e964456553C749B7B4998c152c9E;
79     //Percent for first multiplier donation
80     uint constant public FATHER_PERCENT = 6;
81     uint constant public TECH_AND_PROMO_PERCENT = 1;
82     uint constant public MAX_INVESTMENT = 3 ether;
83 
84     //How many percent for your deposit to be multiplied
85     uint constant public MULTIPLIER = 111;
86 
87     //The deposit structure holds all the info about the deposit made
88     struct Deposit {
89         address depositor; //The depositor address
90         uint128 deposit;   //The deposit amount
91         uint128 expect;    //How much we should pay out (initially it is 111% of deposit)
92     }
93 
94     Deposit[] private queue;  //The queue
95     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
96     mapping(address => uint) public numInQueue; //The number of a depositor in queue
97 
98     //This function receives all the deposits
99     //stores them and make immediate payouts
100     function () public payable {
101         //If money are from first multiplier, just add them to the balance
102         //All these money will be distributed to current investors
103         if(msg.value > 0 && msg.sender != FATHER){
104             require(gasleft() >= 250000, "We require more gas!"); //We need gas to process queue
105             require(msg.value <= MAX_INVESTMENT); //Do not allow too big investments to stabilize payouts
106 
107             //Send donation to the first multiplier for it to spin faster
108             uint donation = msg.value*FATHER_PERCENT/100;
109             require(FATHER.call.value(donation).gas(gasleft())());
110 
111             require(numInQueue[msg.sender] == 0, "Only one deposit at a time!");
112             
113             //Add the investor into the queue. Mark that he expects to receive 111% of deposit back
114             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
115             numInQueue[msg.sender] = queue.length; //Remember this depositor is already in queue
116 
117             //Send small part to tech support
118             uint support = msg.value*TECH_AND_PROMO_PERCENT/100;
119             TECH_AND_PROMO.send(support);
120 
121             //Pay to first investors in line
122             pay();
123         }
124     }
125 
126     //Used to pay to current investors
127     //Each new transaction processes 1 - 4+ investors in the head of queue
128     //depending on balance and gas left
129     function pay() private {
130         //Try to send all the money on contract to the first investors in line
131         uint128 money = uint128(address(this).balance);
132 
133         //We will do cycle on the queue
134         for(uint i=currentReceiverIndex; i<queue.length; i++){
135 
136             Deposit storage dep = queue[i]; //get the info of the first investor
137 
138             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
139                 dep.depositor.send(dep.expect); //Send money to him
140                 money -= dep.expect;            //update money left
141 
142                 //this investor is fully paid, so remove him
143                 delete numInQueue[dep.depositor];
144                 delete queue[i];
145             }else{
146                 //Here we don't have enough money so partially pay to investor
147                 dep.depositor.send(money); //Send to him everything we have
148                 dep.expect -= money;       //Update the expected amount
149                 break;                     //Exit cycle
150             }
151 
152             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
153                 break;                     //The next investor will process the line further
154         }
155 
156         currentReceiverIndex += i; //Update the index of the current first investor
157     }
158 
159     //Get the deposit info by its index
160     //You can get deposit index from
161     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
162         Deposit storage dep = queue[idx];
163         return (dep.depositor, dep.deposit, dep.expect);
164     }
165 
166     //Get the count of deposits of specific investor
167     function getDepositsCount(address depositor) public view returns (uint) {
168         uint c = 0;
169         for(uint i=currentReceiverIndex; i<queue.length; ++i){
170             if(queue[i].depositor == depositor)
171                 c++;
172         }
173         return c;
174     }
175 
176     //Get all deposits (index, deposit, expect) of a specific investor
177     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
178         uint c = getDepositsCount(depositor);
179 
180         idxs = new uint[](c);
181         deposits = new uint128[](c);
182         expects = new uint128[](c);
183 
184         if(c > 0) {
185             uint j = 0;
186             for(uint i=currentReceiverIndex; i<queue.length; ++i){
187                 Deposit storage dep = queue[i];
188                 if(dep.depositor == depositor){
189                     idxs[j] = i;
190                     deposits[j] = dep.deposit;
191                     expects[j] = dep.expect;
192                     j++;
193                 }
194             }
195         }
196     }
197 
198     //Get current queue size
199     function getQueueLength() public view returns (uint) {
200         return queue.length - currentReceiverIndex;
201     }
202 
203 }