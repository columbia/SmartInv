1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 121% of each investment!
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
15   4. PROFIT! You have got 121%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 121% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 121% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 121% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 121%)
38 
39 
40   Контракт Умножитель: возвращает 121% от вашего депозита!
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
51   4. PROFIT! Вам пришло 121% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 121% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 121% от вашего депозита, вы удаляетесь из очереди
58   4. Вы можете делать несколько депозитов сразу
59   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
60      сразу же направляются на выплаты
61 
62      Таким образом, последние платят первым, и инвесторы, достигшие выплат 121% от депозита,
63      удаляются из очереди, уступая место остальным
64 
65               новый инвестор --|            совсем новый инвестор --|
66                  инвестор5     |                новый инвестор      |
67                  инвестор4     |     =======>      инвестор5        |
68                  инвестор3     |                   инвестор4        |
69  (част. выплата) инвестор2    <|                   инвестор3        |
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 121%)
71 
72 */
73 
74 contract BestMultiplier {
75     //Address for reclame expences
76     address constant private Reclame = 0x39D080403562770754d2fA41225b33CaEE85fdDd;
77     //Percent for reclame expences
78     uint constant public Reclame_PERCENT = 3; 
79     //3 for advertizing
80     address constant private Admin = 0x0eDd0c239Ef99A285ddCa25EC340064232aD985e;
81     // Address for admin expences
82     uint constant public Admin_PERCENT = 1;
83     // 1 for techsupport
84     address constant private BMG = 0xc42F87a2E51577d56D64BF7Aa8eE3A26F3ffE8cF;
85     // Address for BestMoneyGroup
86     uint constant public BMG_PERCENT = 2;
87     // 2 for BMG
88     uint constant public Refferal_PERCENT = 10;
89     // 10 for Refferal
90     //How many percent for your deposit to be multiplied
91     uint constant public MULTIPLIER = 121;
92 
93     //The deposit structure holds all the info about the deposit made
94     struct Deposit {
95         address depositor; //The depositor address
96         uint128 deposit;   //The deposit amount
97         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
98     }
99 
100     Deposit[] private queue;  //The queue
101     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
102 
103     //This function receives all the deposits
104     //stores them and make immediate payouts
105     function () public payable {
106         require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
107         if(msg.value > 0){
108             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
109             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
110 
111             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
112             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
113 
114             //Send some promo to enable this contract to leave long-long time
115             uint promo = msg.value*Reclame_PERCENT/100;
116             Reclame.send(promo);
117             uint admin = msg.value*Admin_PERCENT/100;
118             Admin.send(admin);
119             uint bmg = msg.value*BMG_PERCENT/100;
120             BMG.send(bmg);
121 
122             //Pay to first investors in line
123             pay();
124         }
125     
126     }
127         function refferal (address REF) public payable {
128         require(tx.gasprice <= 50000000000 wei, "Gas price is too high! Do not cheat!");
129         if(msg.value > 0){
130             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
131             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
132 
133             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
134             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
135 
136             //Send some promo to enable this contract to leave long-long time
137             uint promo = msg.value*Reclame_PERCENT/100;
138             Reclame.send(promo);
139             uint admin = msg.value*Admin_PERCENT/100;
140             Admin.send(admin);
141             uint bmg = msg.value*BMG_PERCENT/100;
142             BMG.send(bmg);
143             require(REF != 0x0000000000000000000000000000000000000000 && REF != msg.sender, "You need another refferal!"); //We need gas to process queue
144             uint ref = msg.value*Refferal_PERCENT/100;
145             REF.send(ref);
146             //Pay to first investors in line
147             pay();
148         }
149     
150     }
151     //Used to pay to current investors
152     //Each new transaction processes 1 - 4+ investors in the head of queue 
153     //depending on balance and gas left
154     function pay() private {
155         //Try to send all the money on contract to the first investors in line
156         uint128 money = uint128(address(this).balance);
157 
158         //We will do cycle on the queue
159         for(uint i=0; i<queue.length; i++){
160 
161             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
162 
163             Deposit storage dep = queue[idx]; //get the info of the first investor
164 
165             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
166                 dep.depositor.send(dep.expect); //Send money to him
167                 money -= dep.expect;            //update money left
168 
169                 //this investor is fully paid, so remove him
170                 delete queue[idx];
171             }else{
172                 //Here we don't have enough money so partially pay to investor
173                 dep.depositor.send(money); //Send to him everything we have
174                 dep.expect -= money;       //Update the expected amount
175                 break;                     //Exit cycle
176             }
177 
178             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
179                 break;                     //The next investor will process the line further
180         }
181 
182         currentReceiverIndex += i; //Update the index of the current first investor
183     }
184 
185     //Get the deposit info by its index
186     //You can get deposit index from
187     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
188         Deposit storage dep = queue[idx];
189         return (dep.depositor, dep.deposit, dep.expect);
190     }
191 
192     //Get the count of deposits of specific investor
193     function getDepositsCount(address depositor) public view returns (uint) {
194         uint c = 0;
195         for(uint i=currentReceiverIndex; i<queue.length; ++i){
196             if(queue[i].depositor == depositor)
197                 c++;
198         }
199         return c;
200     }
201 
202     //Get all deposits (index, deposit, expect) of a specific investor
203     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
204         uint c = getDepositsCount(depositor);
205 
206         idxs = new uint[](c);
207         deposits = new uint128[](c);
208         expects = new uint128[](c);
209 
210         if(c > 0) {
211             uint j = 0;
212             for(uint i=currentReceiverIndex; i<queue.length; ++i){
213                 Deposit storage dep = queue[i];
214                 if(dep.depositor == depositor){
215                     idxs[j] = i;
216                     deposits[j] = dep.deposit;
217                     expects[j] = dep.expect;
218                     j++;
219                 }
220             }
221         }
222     }
223     
224     //Get current queue size
225     function getQueueLength() public view returns (uint) {
226         return queue.length - currentReceiverIndex;
227     }
228 
229 }