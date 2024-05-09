1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier ETHMOON: returns 125% of each investment!
5   Fully transparent smartcontract with automatic payments proven professionals.
6   An additional level of protection against fraud - you can make only two deposits, until you get 125%.
7 
8   1. Send any sum to smart contract address
9      - sum from 0.01 to 5 ETH
10      - min 250000 gas limit
11      - you are added to a queue
12      - only two deposit until you got 125%
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 125%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 125% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 125% of your initial investment you are
23      removed from the queue.
24   4. You can make no more than two deposits at once
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 125% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 125%)
38 
39 
40   Контракт ETHMOON: возвращает 125% от вашего депозита!
41   Полностью прозрачный смартконтракт с автоматическими выплатами, проверенный профессионалами.
42   Дополнительный уровень защиты от обмана - вы сможете внести только два депозита, пока вы не получите 125%.
43 
44   1. Пошлите любую ненулевую сумму на адрес контракта
45      - сумма от 0.01 до 5 ETH
46      - gas limit минимум 250000
47      - вы встанете в очередь
48      - только два депозита, пока не получите 125%
49   2. Немного подождите
50   3. ...
51   4. PROFIT! Вам пришло 125% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 125% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 125% от вашего депозита, вы удаляетесь из очереди
58   4. Вы можете делать не больше двух депозитов сразу
59   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
60      сразу же направляются на выплаты
61 
62      Таким образом, последние платят первым, и инвесторы, достигшие выплат 125% от депозита,
63      удаляются из очереди, уступая место остальным
64 
65               новый инвестор --|            совсем новый инвестор --|
66                  инвестор5     |                новый инвестор      |
67                  инвестор4     |     =======>      инвестор5        |
68                  инвестор3     |                   инвестор4        |
69  (част. выплата) инвестор2    <|                   инвестор3        |
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 125%)
71 
72 */
73 
74 
75 contract Ethmoon {
76     // address for promo expences
77     address constant private PROMO = 0xa4Db4f62314Db6539B60F0e1CBE2377b918953Bd;
78     address constant private TECH = 0x093D552Bde4D55D2e32dedA3a04D3B2ceA2B5595;
79     // percent for promo/tech expences
80     uint constant public PROMO_PERCENT = 6;
81     uint constant public TECH_PERCENT = 2;
82     // how many percent for your deposit to be multiplied
83     uint constant public MULTIPLIER = 125;
84     // deposit limits
85     uint constant public MIN_DEPOSIT = .01 ether;
86     uint constant public MAX_DEPOSIT = 5 ether;
87 
88     // the deposit structure holds all the info about the deposit made
89     struct Deposit {
90         address depositor; // the depositor address
91         uint128 deposit;   // the deposit amount
92         uint128 expect;    // how much we should pay out (initially it is 125% of deposit)
93     }
94 
95     Deposit[] private queue;  // the queue
96     uint public currentReceiverIndex = 0; // the index of the first depositor in the queue. The receiver of investments!
97 
98     // this function receives all the deposits
99     // stores them and make immediate payouts
100     function () public payable {
101         require(gasleft() >= 220000, "We require more gas!"); // we need gas to process queue
102         require((msg.value >= MIN_DEPOSIT) && (msg.value <= MAX_DEPOSIT)); // do not allow too big investments to stabilize payouts
103         require(getDepositsCount(msg.sender) < 2); // not allow more than 2 deposit in until you to receive 125% of deposit back
104 
105         // add the investor into the queue. Mark that he expects to receive 125% of deposit back
106         queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * MULTIPLIER/100)));
107 
108         // send some promo to enable this contract to leave long-long time
109         uint promo = msg.value * PROMO_PERCENT/100;
110         PROMO.transfer(promo);
111         uint tech = msg.value * TECH_PERCENT/100;
112         TECH.transfer(tech);
113 
114         // pay to first investors in line
115         pay();
116     }
117 
118     // used to pay to current investors
119     // each new transaction processes 1 - 4+ investors in the head of queue 
120     // depending on balance and gas left
121     function pay() private {
122         // try to send all the money on contract to the first investors in line
123         uint128 money = uint128(address(this).balance);
124 
125         // we will do cycle on the queue
126         for (uint i=0; i<queue.length; i++) {
127             uint idx = currentReceiverIndex + i;  // get the index of the currently first investor
128 
129             Deposit storage dep = queue[idx]; // get the info of the first investor
130 
131             if (money >= dep.expect) {  // if we have enough money on the contract to fully pay to investor
132                 dep.depositor.transfer(dep.expect); // send money to him
133                 money -= dep.expect;            // update money left
134 
135                 // this investor is fully paid, so remove him
136                 delete queue[idx];
137             } else {
138                 // here we don't have enough money so partially pay to investor
139                 dep.depositor.transfer(money); // send to him everything we have
140                 dep.expect -= money;       // update the expected amount
141                 break;                     // exit cycle
142             }
143 
144             if (gasleft() <= 50000)         // check the gas left. If it is low, exit the cycle
145                 break;                     // the next investor will process the line further
146         }
147 
148         currentReceiverIndex += i; // update the index of the current first investor
149     }
150 
151     // get the deposit info by its index
152     // you can get deposit index from
153     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
154         Deposit storage dep = queue[idx];
155         return (dep.depositor, dep.deposit, dep.expect);
156     }
157 
158     // get the count of deposits of specific investor
159     function getDepositsCount(address depositor) public view returns (uint) {
160         uint c = 0;
161         for (uint i=currentReceiverIndex; i<queue.length; ++i) {
162             if(queue[i].depositor == depositor)
163                 c++;
164         }
165         return c;
166     }
167 
168     // get all deposits (index, deposit, expect) of a specific investor
169     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
170         uint c = getDepositsCount(depositor);
171 
172         idxs = new uint[](c);
173         deposits = new uint128[](c);
174         expects = new uint128[](c);
175 
176         if (c > 0) {
177             uint j = 0;
178             for (uint i=currentReceiverIndex; i<queue.length; ++i) {
179                 Deposit storage dep = queue[i];
180                 if (dep.depositor == depositor) {
181                     idxs[j] = i;
182                     deposits[j] = dep.deposit;
183                     expects[j] = dep.expect;
184                     j++;
185                 }
186             }
187         }
188     }
189     
190     // get current queue size
191     function getQueueLength() public view returns (uint) {
192         return queue.length - currentReceiverIndex;
193     }
194 }