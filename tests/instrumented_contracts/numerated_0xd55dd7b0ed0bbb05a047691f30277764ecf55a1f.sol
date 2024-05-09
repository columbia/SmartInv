1 pragma solidity ^0.4.25;
2 
3 /**
4   Telegram: https://t.me/multixpro
5   
6   Multiplier contract: returns 125% of each investment!
7   Automatic payouts!
8   No bugs, no backdoors, NO OWNER - fully automatic!
9   Made and checked by professionals!
10 
11   1. Send any sum to smart contract address
12      - sum from 0.01 to 0.5 ETH
13      - min 250000 gas limit
14      - you are added to a queue
15   2. Wait a little bit
16   3. ...
17   4. PROFIT! You have got 125%
18 
19   How is that?
20   1. The first investor in the queue (you will become the
21      first in some time) receives next investments until
22      it become 125% of his initial investment.
23   2. You will receive payments in several parts or all at once
24   3. Once you receive 125% of your initial investment you are
25      removed from the queue.
26   4. You can make multiple deposits
27   5. The balance of this contract should normally be 0 because
28      all the money are immediately go to payouts
29 
30 
31      So the last pays to the first (or to several first ones
32      if the deposit big enough) and the investors paid 125% are removed from the queue
33 
34                 new investor --|               brand new investor --|
35                  investor5     |                 new investor       |
36                  investor4     |     =======>      investor5        |
37                  investor3     |                   investor4        |
38     (part. paid) investor2    <|                   investor3        |
39     (fully paid) investor1   <-|                   investor2   <----|  (pay until 125%)
40 
41 
42   Контракт Умножитель: возвращает 125% от вашего депозита!
43   Автоматические выплаты!
44   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
45   Создан и проверен профессионалами!
46 
47   1. Пошлите любую ненулевую сумму на адрес контракта
48      - сумма от 0.01 до 0.5 ETH
49      - gas limit минимум 250000
50      - вы встанете в очередь
51   2. Немного подождите
52   3. ...
53   4. PROFIT! Вам пришло 125% от вашего депозита.
54 
55   Как это возможно?
56   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
57      новых инвесторов до тех пор, пока не получит 125% от своего депозита
58   2. Выплаты могут приходить несколькими частями или все сразу
59   3. Как только вы получаете 125% от вашего депозита, вы удаляетесь из очереди
60   4. Вы можете делать несколько депозитов сразу
61   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
62      сразу же направляются на выплаты
63 
64      Таким образом, последние платят первым, и инвесторы, достигшие выплат 125% от депозита,
65      удаляются из очереди, уступая место остальным
66 
67               новый инвестор --|            совсем новый инвестор --|
68                  инвестор5     |                новый инвестор      |
69                  инвестор4     |     =======>      инвестор5        |
70                  инвестор3     |                   инвестор4        |
71  (част. выплата) инвестор2    <|                   инвестор3        |
72 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 125%)
73 
74 */
75 
76 contract MultiX125_05eth {
77     // E-wallet to pay for advertising
78     address constant private ADS_SUPPORT = 0x5Fa713836267bE36ae9664E97063667e668Eab63;
79 
80     // The address of the wallet to invest back into the project
81     address constant private TECH_SUPPORT = 0xc2ce177F96a0fdfa3C72FD6E3a131086B38bc3Ef;
82 
83     // The percentage of Deposit is 5%
84     uint constant public ADS_PERCENT = 5;
85 
86     // Deposit percentage for investment in the project 2%
87     uint constant public TECH_PERCENT = 2;
88     
89     // Payout percentage for all participants
90     uint constant public MULTIPLIER = 125;
91 
92     // The maximum Deposit amount = 0.5 ether, so that everyone can participate and whales do not slow down and do not scare investors
93     uint constant public MAX_LIMIT = 0.5 ether;
94 
95     // The Deposit structure contains information about the Deposit
96     struct Deposit {
97         address depositor; // The owner of the Deposit
98         uint128 deposit;   // Deposit amount
99         uint128 expect;    // Payment amount (instantly 150% of the Deposit)
100     }
101 
102     // Turn
103     Deposit[] private queue;
104 
105     // The number of the Deposit to be processed can be found in the Read contract section
106     uint public currentReceiverIndex = 0;
107 
108     // This function receives all deposits, saves them and makes instant payments
109     function () public payable {
110         // If the Deposit amount is greater than zero
111         if(msg.value > 0){
112             // Check the minimum gas limit of 220 000, otherwise cancel the Deposit and return the money to the depositor
113             require(gasleft() >= 220000, "We require more gas!");
114 
115             // Check the maximum Deposit amount
116             require(msg.value <= MAX_LIMIT, "Deposit is too big");
117 
118             // Add a Deposit to the queue, write down that he needs to pay 125% of the Deposit amount
119             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * MULTIPLIER / 100)));
120 
121             // Send a percentage to promote the project
122             uint ads = msg.value * ADS_PERCENT / 100;
123             ADS_SUPPORT.transfer(ads);
124 
125             // We send a percentage for technical support of the project
126             uint tech = msg.value * TECH_PERCENT / 100;
127             TECH_SUPPORT.transfer(tech);
128 
129             // Call the payment function first in the queue Deposit
130             pay();
131         }
132     }
133 
134     // The function is used to pay first in line deposits
135     // Each new transaction processes 1 to 4+ depositors at the beginning of the queue 
136     // Depending on the remaining gas
137     function pay() private {
138         // We will try to send all the money available on the contract to the first depositors in the queue
139         uint128 money = uint128(address(this).balance);
140 
141         // We pass through the queue
142         for(uint i = 0; i < queue.length; i++) {
143 
144             uint idx = currentReceiverIndex + i;  // We get the number of the first Deposit in the queue
145 
146             Deposit storage dep = queue[idx]; // We get information about the first Deposit
147 
148             if(money >= dep.expect) {  // If we have enough money for the full payment, we pay him everything
149                 dep.depositor.transfer(dep.expect); // Send him money
150                 money -= dep.expect; // Update the amount of remaining money
151 
152                 // the Deposit has been fully paid, remove it
153                 delete queue[idx];
154             } else {
155                 // We get here if we do not have enough money to pay everything, but only part of it
156                 dep.depositor.transfer(money); // Send all remaining
157                 dep.expect -= money;       // Update the amount of remaining money
158                 break;                     // Exit the loop
159             }
160 
161             if (gasleft() <= 50000)         // Check if there is still gas, and if it is not, then exit the cycle
162                 break;                     //  The next depositor will make the payment next in line
163         }
164 
165         currentReceiverIndex += i; // Update the number of the first Deposit in the queue
166     }
167 
168     // Shows information about the Deposit by its number (idx), you can follow in the Read contract section
169     // You can get the Deposit number (idx) by calling the getDeposits function()
170     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
171         Deposit storage dep = queue[idx];
172         return (dep.depositor, dep.deposit, dep.expect);
173     }
174 
175     // Shows the number of deposits of a particular investor
176     function getDepositsCount(address depositor) public view returns (uint) {
177         uint c = 0;
178         for(uint i=currentReceiverIndex; i<queue.length; ++i){
179             if(queue[i].depositor == depositor)
180                 c++;
181         }
182         return c;
183     }
184 
185     // Shows all deposits (index, deposit, expect) of a certain investor, you can follow in the Read contract section
186     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
187         uint c = getDepositsCount(depositor);
188 
189         idxs = new uint[](c);
190         deposits = new uint128[](c);
191         expects = new uint128[](c);
192 
193         if(c > 0) {
194             uint j = 0;
195             for(uint i=currentReceiverIndex; i<queue.length; ++i){
196                 Deposit storage dep = queue[i];
197                 if(dep.depositor == depositor){
198                     idxs[j] = i;
199                     deposits[j] = dep.deposit;
200                     expects[j] = dep.expect;
201                     j++;
202                 }
203             }
204         }
205     }
206     
207     // Shows a length of the queue can be monitored in the Read section of the contract
208     function getQueueLength() public view returns (uint) {
209         return queue.length - currentReceiverIndex;
210     }
211 
212 }