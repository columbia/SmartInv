1 pragma solidity ^0.4.25;
2 
3 /**
4    QuickQueue contract: returns 103% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - sum from 0.01 to 1 ETH
11      - min 250000 gas limit
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 103%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 103% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 103% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 103% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                           new investor       |
34                  investor4     |     =======>         investor5        |
35                  investor3     |                               investor4        |
36     (part. paid) investor2    <|                      investor3        |
37     (fully paid) investor1   <-|                    investor2   <----|  (pay until 103%)
38     
39     
40   QuickQueue - Надежный умножитель, который возвращает 103% от вашего депозита!
41 
42   Маленький лимит на депозит избавляет от проблем с крупными вкладами и дает возможность заработать каждому!
43 
44   Автоматические выплаты!
45   Полные отчеты о потраченных на рекламу средствах в группе!
46   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
47   Создан и проверен профессионалами!
48 
49   1. Пошлите любую ненулевую сумму на адрес контракта
50      - сумма от 0.01 до 1 ETH
51      - gas limit минимум 250000
52      - вы встанете в очередь
53   2. Немного подождите
54   3. ...
55   4. PROFIT! Вам пришло 103% от вашего депозита.
56 
57   Как это возможно?
58   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
59      новых инвесторов до тех пор, пока не получит 103% от своего депозита
60   2. Выплаты могут приходить несколькими частями или все сразу
61   3. Как только вы получаете 103% от вашего депозита, вы удаляетесь из очереди
62   4. Вы можете делать несколько депозитов сразу
63   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
64      сразу же направляются на выплаты
65 
66      Таким образом, последние платят первым, и инвесторы, достигшие выплат 103% от депозита,
67      удаляются из очереди, уступая место остальным
68 
69               новый инвестор --|            совсем новый инвестор --|
70                  инвестор5     |                              новый инвестор      |
71                  инвестор4     |     =======>                инвестор5        |
72                  инвестор3     |                                      инвестор4        |
73  (част. выплата) инвестор2    <|                       инвестор3        |
74 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 103%)
75 
76 */
77 
78 contract QuickQueue {
79    
80     address constant private SUPPORT = 0x1f78Ae3ab029456a3ac5b6f4F90EaB5B675c47D5;  // Address for promo expences
81     uint constant public SUPPORT_PERCENT = 5; //Percent for promo expences 5% (3% for advertizing, 2% for techsupport)
82     uint constant public QUICKQUEUE = 103; // Percent for your deposit to be QuickQueue
83     uint constant public MAX_LIMIT = 1 ether; // Max deposit = 1 Eth
84 
85     //The deposit structure holds all the info about the deposit made
86     struct Deposit {
87         address depositor; // The depositor address
88         uint128 deposit;   // The deposit amount
89         uint128 expect;    // How much we should pay out (initially it is 103% of deposit)
90     }
91 
92     //The queue
93     Deposit[] private queue;
94 
95     uint public currentReceiverIndex = 0;
96 
97     //This function receives all the deposits
98     //stores them and make immediate payouts
99     function () public payable {
100         if(msg.value > 0){
101             require(gasleft() >= 220000, "We require more gas!");
102             require(msg.value <= MAX_LIMIT, "Deposit is too big");
103 
104             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value * QUICKQUEUE / 100)));
105 
106             uint ads = msg.value * SUPPORT_PERCENT / 100;
107             SUPPORT.transfer(ads);
108 
109             pay();
110         }
111     }
112 
113     //Used to pay to current investors
114     //Each new transaction processes 1 - 4+ investors in the head of queue 
115     //depending on balance and gas left
116     function pay() private {
117         uint128 money = uint128(address(this).balance);
118 
119         for(uint i = 0; i < queue.length; i++) {
120 
121             uint idx = currentReceiverIndex + i;
122 
123             Deposit storage dep = queue[idx];
124 
125             if(money >= dep.expect) {  
126                 dep.depositor.transfer(dep.expect);
127                 money -= dep.expect;
128 
129                 delete queue[idx];
130             } else {
131                 dep.depositor.transfer(money);
132                 dep.expect -= money;       
133                 break;                     
134             }
135 
136             if (gasleft() <= 50000)     
137                 break;                     
138         }
139 
140         currentReceiverIndex += i; 
141     }
142 
143     //Get the deposit info by its index
144     //You can get deposit index from
145     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
146         Deposit storage dep = queue[idx];
147         return (dep.depositor, dep.deposit, dep.expect);
148     }
149 
150     //Get the count of deposits of specific investor
151     function getDepositsCount(address depositor) public view returns (uint) {
152         uint c = 0;
153         for(uint i=currentReceiverIndex; i<queue.length; ++i){
154             if(queue[i].depositor == depositor)
155                 c++;
156         }
157         return c;
158     }
159 
160     //Get all deposits (index, deposit, expect) of a specific investor
161     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
162         uint c = getDepositsCount(depositor);
163 
164         idxs = new uint[](c);
165         deposits = new uint128[](c);
166         expects = new uint128[](c);
167 
168         if(c > 0) {
169             uint j = 0;
170             for(uint i=currentReceiverIndex; i<queue.length; ++i){
171                 Deposit storage dep = queue[i];
172                 if(dep.depositor == depositor){
173                     idxs[j] = i;
174                     deposits[j] = dep.deposit;
175                     expects[j] = dep.expect;
176                     j++;
177                 }
178             }
179         }
180     }
181     
182     //Get current queue size
183     function getQueueLength() public view returns (uint) {
184         return queue.length - currentReceiverIndex;
185     }
186 
187 }