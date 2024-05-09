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
11  *    - sum from 0.21 to 10 ETH
12  *    - min 250000 gas limit
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
45  *    - сумма от 0.21 до 10 ETH
46  *    - gas limit минимум 250000
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
61  * Таким образом, последние платят первым, и инвесторы, достигшие выплат 115%-120% от 
62  * депозита, удаляются из очереди, уступая место остальным
63  *
64  *             новый инвестор --|            совсем новый инвестор --|
65  *                инвестор5     |                новый инвестор      |
66  *                инвестор4     |     =======>      инвестор5        |
67  *                инвестор3     |                   инвестор4        |
68  * (част. выпл.)  инвестор2    <|                   инвестор3        |
69  * (полная выпл.) инвестор1   <-|                   инвестор2   <----|  (доплата до 115%-120%)
70  *
71 */
72 
73 
74 contract EthmoonV3 {
75     // address for promo expences
76     address constant private PROMO = 0xa4Db4f62314Db6539B60F0e1CBE2377b918953Bd;
77     address constant private SMARTCONTRACT = 0x03f69791513022D8b67fACF221B98243346DF7Cb;
78     address constant private STARTER = 0x5dfE1AfD8B7Ae0c8067dB962166a4e2D318AA241;
79     // percent for promo/tech expences
80     uint constant public PROMO_PERCENT = 5;
81     uint constant public SMARTCONTRACT_PERCENT = 5;
82     // how many percent for your deposit to be multiplied
83     uint constant public START_MULTIPLIER = 115;
84     // deposit limits
85     uint constant public MIN_DEPOSIT = 0.21 ether;
86     uint constant public MAX_DEPOSIT = 10 ether;
87     bool public started = false;
88     // count participation
89     mapping(address => uint) public participation;
90 
91     // the deposit structure holds all the info about the deposit made
92     struct Deposit {
93         address depositor; // the depositor address
94         uint128 deposit;   // the deposit amount
95         uint128 expect;    // how much we should pay out (initially it is 115%-120% of deposit)
96     }
97 
98     Deposit[] private queue;  // the queue
99     uint public currentReceiverIndex = 0; // the index of the first depositor in the queue. The receiver of investments!
100 
101     // this function receives all the deposits
102     // stores them and make immediate payouts
103     function () public payable {
104         require(gasleft() >= 220000, "We require more gas!"); // we need gas to process queue
105         require((msg.sender == STARTER) || (started));
106         
107         if (msg.sender != STARTER) {
108             require((msg.value >= MIN_DEPOSIT) && (msg.value <= MAX_DEPOSIT)); // do not allow too big investments to stabilize payouts
109             uint multiplier = percentRate(msg.sender);
110             // add the investor into the queue. Mark that he expects to receive 115%-120% of deposit back
111             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * multiplier/100)));
112             participation[msg.sender] = participation[msg.sender] + 1;
113             // send some promo to enable this contract to leave long-long time
114             uint promo = msg.value * PROMO_PERCENT/100;
115             PROMO.transfer(promo);
116             uint smartcontract = msg.value * SMARTCONTRACT_PERCENT/100;
117             SMARTCONTRACT.transfer(smartcontract);
118     
119             // pay to first investors in line
120             pay();
121         } else {
122             started = true;
123         }
124     }
125 
126     // used to pay to current investors
127     // each new transaction processes 1 - 4+ investors in the head of queue 
128     // depending on balance and gas left
129     function pay() private {
130         // try to send all the money on contract to the first investors in line
131         uint128 money = uint128(address(this).balance);
132 
133         // we will do cycle on the queue
134         for (uint i=0; i<queue.length; i++) {
135             uint idx = currentReceiverIndex + i;  // get the index of the currently first investor
136 
137             Deposit storage dep = queue[idx]; // get the info of the first investor
138 
139             if (money >= dep.expect) {  // if we have enough money on the contract to fully pay to investor
140                 dep.depositor.transfer(dep.expect); // send money to him
141                 money -= dep.expect;            // update money left
142 
143                 // this investor is fully paid, so remove him
144                 delete queue[idx];
145             } else {
146                 // here we don't have enough money so partially pay to investor
147                 dep.depositor.transfer(money); // send to him everything we have
148                 dep.expect -= money;       // update the expected amount
149                 break;                     // exit cycle
150             }
151 
152             if (gasleft() <= 50000)         // check the gas left. If it is low, exit the cycle
153                 break;                     // the next investor will process the line further
154         }
155 
156         currentReceiverIndex += i; // update the index of the current first investor
157     }
158 
159     // get the deposit info by its index
160     // you can get deposit index from
161     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
162         Deposit storage dep = queue[idx];
163         return (dep.depositor, dep.deposit, dep.expect);
164     }
165 
166     // get the count of deposits of specific investor
167     function getDepositsCount(address depositor) public view returns (uint) {
168         uint c = 0;
169         for (uint i=currentReceiverIndex; i<queue.length; ++i) {
170             if(queue[i].depositor == depositor)
171                 c++;
172         }
173         return c;
174     }
175 
176     // get all deposits (index, deposit, expect) of a specific investor
177     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
178         uint c = getDepositsCount(depositor);
179 
180         idxs = new uint[](c);
181         deposits = new uint128[](c);
182         expects = new uint128[](c);
183 
184         if (c > 0) {
185             uint j = 0;
186             for (uint i=currentReceiverIndex; i<queue.length; ++i) {
187                 Deposit storage dep = queue[i];
188                 if (dep.depositor == depositor) {
189                     idxs[j] = i;
190                     deposits[j] = dep.deposit;
191                     expects[j] = dep.expect;
192                     j++;
193                 }
194             }
195         }
196     }
197     
198     // get current queue size
199     function getQueueLength() public view returns (uint) {
200         return queue.length - currentReceiverIndex;
201     }
202     
203     // get persent rate
204     function percentRate(address depositor) public view returns(uint) {
205         uint persent = START_MULTIPLIER;
206         if (participation[depositor] > 0) {
207             persent = persent + participation[depositor] * 5;
208         }
209         if (persent > 120) {
210             persent = 120;
211         } 
212         return persent;
213     }
214 }