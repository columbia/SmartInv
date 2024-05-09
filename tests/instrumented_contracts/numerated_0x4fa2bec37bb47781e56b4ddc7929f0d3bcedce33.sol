1 pragma solidity ^0.4.25;
2 
3 /**
4   Black Friday Multiplier contract: returns 110% of each investment!
5   Automatic payouts!
6   This is a BLACK FRIDAY SPECIAL so we will only take 5% for us,
7   That is why you will RECEIVE YOUR PROFITS MUCH FASTER than before.
8   No bugs, no backdoors, NO OWNER - fully automatic!
9   Made and checked by professionals!
10 
11   1. Send any sum to smart contract address
12      - sum from 0.01 to 10 ETH
13      - min 250000 gas limit
14      - you are added to a queue
15   2. Wait a little bit
16   3. ...
17   4. PROFIT! You have got 110% PROFIT
18 
19   How does this work?
20   1. The first investor in the queue (you will become the
21      first in some time) receives the next investment until
22      it become 121% of his initial investment.
23   2. You will receive payments in several parts or all at once
24   3. Once you receive 150% of your initial investment you are
25      removed from the queue.
26   4. You can make multiple deposits
27   5. The balance of this contract should always be 0 because
28      all the Ethereum is automatically paid to the next investor in the queue
29 
30 
31      So the last pays the first (or to several of the first ones if the deposit is big enough) 
32      and the investors who are paid 110% are removed from the queue
33 
34                 new investor --|               brand new investor --|
35                  investor5     |                 new investor       |
36                  investor4     |     =======>      investor5        |
37                  investor3     |                   investor4        |
38     (part. paid) investor2    <|                   investor3        |
39     (fully paid) investor1   <-|                   investor2   <----|  (pay until 110%)
40 
41 
42   Контракт Умножитель: возвращает 150% от вашего депозита!
43   Автоматические выплаты!
44   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
45   Создан и проверен профессионалами!
46 
47   1. Пошлите любую ненулевую сумму на адрес контракта
48      - сумма от 0.01 до 10 ETH
49      - gas limit минимум 250000
50      - вы встанете в очередь
51   2. Немного подождите
52   3. ...
53   4. PROFIT! Вам пришло 110% от вашего депозита.
54 
55   Как это возможно?
56   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
57      новых инвесторов до тех пор, пока не получит 121% от своего депозита
58   2. Выплаты могут приходить несколькими частями или все сразу
59   3. Как только вы получаете 121% от вашего депозита, вы удаляетесь из очереди
60   4. Вы можете делать несколько депозитов сразу
61   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
62      сразу же направляются на выплаты
63 
64      Таким образом, последние платят первым, и инвесторы, достигшие выплат 110% от депозита,
65      удаляются из очереди, уступая место остальным
66 
67               новый инвестор --|            совсем новый инвестор --|
68                  инвестор5     |                новый инвестор      |
69                  инвестор4     |     =======>      инвестор5        |
70                  инвестор3     |                   инвестор4        |
71  (част. выплата) инвестор2    <|                   инвестор3        |
72 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 110%)
73 
74 */
75 
76 contract BlackFridayMultiplier {
77     //Address for reclame expences
78     address constant private Reclame = 0xC7FCc602088b49c816b1A36848f62c35516F0F8B;
79     //Percent for reclame expences
80     uint constant public Reclame_PERCENT = 2; 
81     //2 for advertizing
82     address constant private Admin = 0x942Ee0aDa641749861c47E27E6d5c09244E4d7c8;
83     // Address for admin expences
84     uint constant public Admin_PERCENT = 2;
85     // 2 for techsupport
86     address constant private BMG = 0xaCB0406c163fBB614A36088d7F7fa0B374A60Cd1;
87     // Address for Charity
88     uint constant public BMG_PERCENT = 2;
89     // 2 for BMG
90     uint constant public Refferal_PERCENT = 5;
91     // 5 for Refferal
92     //How many percent for your deposit to be multiplied
93     uint constant public MULTIPLIER = 110;
94 
95     //The deposit structure holds all the info about the deposit made
96     struct Deposit {
97         address depositor; //The depositor address
98         uint128 deposit;   //The deposit amount
99         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
100     }
101 
102     Deposit[] private queue;  //The queue
103     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
104 
105     //This function receives all the deposits
106     //stores them and make immediate payouts
107     function () public payable {
108         require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
109         if(msg.value > 0){
110             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
111             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
112 
113             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
114             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
115 
116             //Send some promo to enable this contract to leave long-long time
117             uint promo = msg.value*Reclame_PERCENT/100;
118             Reclame.send(promo);
119             uint admin = msg.value*Admin_PERCENT/100;
120             Admin.send(admin);
121             uint bmg = msg.value*BMG_PERCENT/100;
122             BMG.send(bmg);
123 
124             //Pay to first investors in line
125             pay();
126         }
127     
128     }
129         function refferal (address REF) public payable {
130         require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
131         if(msg.value > 0){
132             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
133             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
134 
135             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
136             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
137 
138             //Send some promo to enable this contract to leave long-long time
139             uint promo = msg.value*Reclame_PERCENT/100;
140             Reclame.send(promo);
141             uint admin = msg.value*Admin_PERCENT/100;
142             Admin.send(admin);
143             uint bmg = msg.value*BMG_PERCENT/100;
144             BMG.send(bmg);
145             require(REF != 0x0000000000000000000000000000000000000000 && REF != msg.sender, "You need another refferal!"); //We need gas to process queue
146             uint ref = msg.value*Refferal_PERCENT/100;
147             REF.send(ref);
148             //Pay to first investors in line
149             pay();
150         }
151     
152     }
153     //Used to pay to current investors
154     //Each new transaction processes 1 - 4+ investors in the head of queue 
155     //depending on balance and gas left
156     function pay() private {
157         //Try to send all the money on contract to the first investors in line
158         uint128 money = uint128(address(this).balance);
159 
160         //We will do cycle on the queue
161         for(uint i=0; i<queue.length; i++){
162 
163             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
164 
165             Deposit storage dep = queue[idx]; //get the info of the first investor
166 
167             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
168                 dep.depositor.send(dep.expect); //Send money to him
169                 money -= dep.expect;            //update money left
170 
171                 //this investor is fully paid, so remove him
172                 delete queue[idx];
173             }else{
174                 //Here we don't have enough money so partially pay to investor
175                 dep.depositor.send(money); //Send to him everything we have
176                 dep.expect -= money;       //Update the expected amount
177                 break;                     //Exit cycle
178             }
179 
180             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
181                 break;                     //The next investor will process the line further
182         }
183 
184         currentReceiverIndex += i; //Update the index of the current first investor
185     }
186 
187     //Get the deposit info by its index
188     //You can get deposit index from
189     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
190         Deposit storage dep = queue[idx];
191         return (dep.depositor, dep.deposit, dep.expect);
192     }
193 
194     //Get the count of deposits of specific investor
195     function getDepositsCount(address depositor) public view returns (uint) {
196         uint c = 0;
197         for(uint i=currentReceiverIndex; i<queue.length; ++i){
198             if(queue[i].depositor == depositor)
199                 c++;
200         }
201         return c;
202     }
203 
204     //Get all deposits (index, deposit, expect) of a specific investor
205     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
206         uint c = getDepositsCount(depositor);
207 
208         idxs = new uint[](c);
209         deposits = new uint128[](c);
210         expects = new uint128[](c);
211 
212         if(c > 0) {
213             uint j = 0;
214             for(uint i=currentReceiverIndex; i<queue.length; ++i){
215                 Deposit storage dep = queue[i];
216                 if(dep.depositor == depositor){
217                     idxs[j] = i;
218                     deposits[j] = dep.deposit;
219                     expects[j] = dep.expect;
220                     j++;
221                 }
222             }
223         }
224     }
225     
226     //Get current queue size
227     function getQueueLength() public view returns (uint) {
228         return queue.length - currentReceiverIndex;
229     }
230 
231 }