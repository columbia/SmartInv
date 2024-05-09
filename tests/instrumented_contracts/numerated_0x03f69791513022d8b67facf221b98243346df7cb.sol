1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier ETHMOON_V2: returns 125%-150% of each investment!
5   Fully transparent smartcontract with automatic payments proven professionals.
6   1. Send any sum to smart contract address
7      - sum from 0.01 to 5 ETH
8      - min 250000 gas limit
9      - you are added to a queue
10   2. Wait a little bit
11   3. ...
12   4. PROFIT! You have got 125%-150%
13   How is that?
14   1. The first investor in the queue (you will become the
15      first in some time) receives next investments until
16      it become 125%-150% of his initial investment.
17   2. You will receive payments in several parts or all at once
18   3. Once you receive 125%-150% of your initial investment you are
19      removed from the queue.
20   4. You can make more than one deposits at once
21   5. The balance of this contract should normally be 0 because
22      all the money are immediately go to payouts
23 
24 
25   So the last pays to the first (or to several first ones if the deposit big enough) 
26   and the investors paid 125%-150% are removed from the queue
27 
28                 new investor --|               brand new investor --|
29                  investor5     |                 new investor       |
30                  investor4     |     =======>      investor5        |
31                  investor3     |                   investor4        |
32     (part. paid) investor2    <|                   investor3        |
33     (fully paid) investor1   <-|                   investor2   <----|  (pay until 125%-150%)
34 
35 
36 
37   Контракт ETHMOON_V2: возвращает 125%-150% от вашего депозита!
38   Полностью прозрачный смартконтракт с автоматическими выплатами, проверенный профессионалами.
39   1. Пошлите любую ненулевую сумму на адрес контракта
40      - сумма от 0.01 до 5 ETH
41      - gas limit минимум 250000
42      - вы встанете в очередь
43   2. Немного подождите
44   3. ...
45   4. PROFIT! Вам пришло 125%-150% от вашего депозита.
46   Как это возможно?
47   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
48      новых инвесторов до тех пор, пока не получит 125%-150% от своего депозита
49   2. Выплаты могут приходить несколькими частями или все сразу
50   3. Как только вы получаете 125%-150% от вашего депозита, вы удаляетесь из очереди
51   4. Вы можете делать несколько депозитов сразу
52   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
53      сразу же направляются на выплаты
54 
55   Таким образом, последние платят первым, и инвесторы, достигшие выплат 125%-150% от 
56   депозита, удаляются из очереди, уступая место остальным
57 
58               новый инвестор --|            совсем новый инвестор --|
59                  инвестор5     |                новый инвестор      |
60                  инвестор4     |     =======>      инвестор5        |
61                  инвестор3     |                   инвестор4        |
62  (част. выплата) инвестор2    <|                   инвестор3        |
63 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 125%-150%)
64 
65 */
66 
67 
68 contract EthmoonV2 {
69     // address for promo expences
70     address constant private PROMO = 0xa4Db4f62314Db6539B60F0e1CBE2377b918953Bd;
71     address constant private TECH = 0x093D552Bde4D55D2e32dedA3a04D3B2ceA2B5595;
72     // percent for promo/tech expences
73     uint constant public PROMO_PERCENT = 6;
74     uint constant public TECH_PERCENT = 2;
75     // how many percent for your deposit to be multiplied
76     uint constant public START_MULTIPLIER = 125;
77     // deposit limits
78     uint constant public MIN_DEPOSIT = .01 ether;
79     uint constant public MAX_DEPOSIT = 5 ether;
80     // count participation
81     mapping(address => uint) public participation;
82 
83     // the deposit structure holds all the info about the deposit made
84     struct Deposit {
85         address depositor; // the depositor address
86         uint128 deposit;   // the deposit amount
87         uint128 expect;    // how much we should pay out (initially it is 125%-150% of deposit)
88     }
89 
90     Deposit[] private queue;  // the queue
91     uint public currentReceiverIndex = 0; // the index of the first depositor in the queue. The receiver of investments!
92 
93     // this function receives all the deposits
94     // stores them and make immediate payouts
95     function () public payable {
96         require(gasleft() >= 220000, "We require more gas!"); // we need gas to process queue
97         require((msg.value >= MIN_DEPOSIT) && (msg.value <= MAX_DEPOSIT)); // do not allow too big investments to stabilize payouts
98         
99         uint multiplier = percentRate(msg.sender);
100         // add the investor into the queue. Mark that he expects to receive 125%-150% of deposit back
101         queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * multiplier/100)));
102         participation[msg.sender] = participation[msg.sender] + 1;
103         // send some promo to enable this contract to leave long-long time
104         uint promo = msg.value * PROMO_PERCENT/100;
105         PROMO.transfer(promo);
106         uint tech = msg.value * TECH_PERCENT/100;
107         TECH.transfer(tech);
108 
109         // pay to first investors in line
110         pay();
111     }
112 
113     // used to pay to current investors
114     // each new transaction processes 1 - 4+ investors in the head of queue 
115     // depending on balance and gas left
116     function pay() private {
117         // try to send all the money on contract to the first investors in line
118         uint128 money = uint128(address(this).balance);
119 
120         // we will do cycle on the queue
121         for (uint i=0; i<queue.length; i++) {
122             uint idx = currentReceiverIndex + i;  // get the index of the currently first investor
123 
124             Deposit storage dep = queue[idx]; // get the info of the first investor
125 
126             if (money >= dep.expect) {  // if we have enough money on the contract to fully pay to investor
127                 dep.depositor.transfer(dep.expect); // send money to him
128                 money -= dep.expect;            // update money left
129 
130                 // this investor is fully paid, so remove him
131                 delete queue[idx];
132             } else {
133                 // here we don't have enough money so partially pay to investor
134                 dep.depositor.transfer(money); // send to him everything we have
135                 dep.expect -= money;       // update the expected amount
136                 break;                     // exit cycle
137             }
138 
139             if (gasleft() <= 50000)         // check the gas left. If it is low, exit the cycle
140                 break;                     // the next investor will process the line further
141         }
142 
143         currentReceiverIndex += i; // update the index of the current first investor
144     }
145 
146     // get the deposit info by its index
147     // you can get deposit index from
148     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
149         Deposit storage dep = queue[idx];
150         return (dep.depositor, dep.deposit, dep.expect);
151     }
152 
153     // get the count of deposits of specific investor
154     function getDepositsCount(address depositor) public view returns (uint) {
155         uint c = 0;
156         for (uint i=currentReceiverIndex; i<queue.length; ++i) {
157             if(queue[i].depositor == depositor)
158                 c++;
159         }
160         return c;
161     }
162 
163     // get all deposits (index, deposit, expect) of a specific investor
164     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
165         uint c = getDepositsCount(depositor);
166 
167         idxs = new uint[](c);
168         deposits = new uint128[](c);
169         expects = new uint128[](c);
170 
171         if (c > 0) {
172             uint j = 0;
173             for (uint i=currentReceiverIndex; i<queue.length; ++i) {
174                 Deposit storage dep = queue[i];
175                 if (dep.depositor == depositor) {
176                     idxs[j] = i;
177                     deposits[j] = dep.deposit;
178                     expects[j] = dep.expect;
179                     j++;
180                 }
181             }
182         }
183     }
184     
185     // get current queue size
186     function getQueueLength() public view returns (uint) {
187         return queue.length - currentReceiverIndex;
188     }
189     
190     // get persent rate
191     function percentRate(address depositor) public view returns(uint) {
192         uint persent = START_MULTIPLIER;
193         if (participation[depositor] > 0) {
194             persent = persent + participation[depositor] * 5;
195         }
196         if (persent > 150) {
197             persent = 150;
198         } 
199         return persent;
200     }
201 }