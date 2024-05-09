1 pragma solidity ^0.4.25;
2 
3 /**
4   Контракт Умножитель V2: возвращает 122% от вашего депозита!
5   Автоматические выплаты!
6   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
7   Создан и проверен профессионалами!
8 
9   1. Пошлите любую ненулевую сумму на адрес контракта
10      - сумма от 0.01 до 10 ETH
11      - gas limit минимум 250000
12      - вы встанете в очередь
13   2. Немного подождите
14   3. ...
15   4. PROFIT! Вам пришло 122% от вашего депозита.
16 
17   Как это возможно?
18   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
19      новых инвесторов до тех пор, пока не получит 122% от своего депозита
20   2. Выплаты могут приходить несколькими частями или все сразу
21   3. Как только вы получаете 122% от вашего депозита, вы удаляетесь из очереди
22   4. Вы можете делать несколько депозитов сразу
23   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
24      сразу же направляются на выплаты
25 
26      Таким образом, последние платят первым, и инвесторы, достигшие выплат 122% от депозита,
27      удаляются из очереди, уступая место остальным
28 
29               новый инвестор --|            совсем новый инвестор --|
30                  инвестор5     |                новый инвестор      |
31                  инвестор4     |     =======>      инвестор5        |
32                  инвестор3     |                   инвестор4        |
33  (част. выплата) инвестор2    <|                   инвестор3        |
34 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 122%)
35 
36 */
37 
38 contract MultiplierV2 {
39     //Address for promo expences
40     address constant private PROMO = 0xBACd82fD2a77128274F68983f82c8372e06A1472;
41     //Percent for promo expences
42     uint constant public PROMO_PERCENT = 7; //6 for advertizing, 1 for techsupport
43     //How many percent for your deposit to be multiplied
44     uint constant public MULTIPLIER = 122;
45 
46     //The deposit structure holds all the info about the deposit made
47     struct Deposit {
48         address depositor; //The depositor address
49         uint128 deposit;   //The deposit amount
50         uint128 expect;    //How much we should pay out (initially it is 122% of deposit)
51     }
52 
53     Deposit[] private queue;  //The queue
54     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
55 
56     //This function receives all the deposits
57     //stores them and make immediate payouts
58     function () public payable {
59         if(msg.value > 0){
60             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
61             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
62 
63             //Add the investor into the queue. Mark that he expects to receive 122% of deposit back
64             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
65 
66             //Send some promo to enable this contract to leave long-long time
67             uint promo = msg.value*PROMO_PERCENT/100;
68             PROMO.send(promo);
69 
70             //Pay to first investors in line
71             pay();
72         }
73     }
74 
75     //Used to pay to current investors
76     //Each new transaction processes 1 - 4+ investors in the head of queue 
77     //depending on balance and gas left
78     function pay() private {
79         //Try to send all the money on contract to the first investors in line
80         uint128 money = uint128(address(this).balance);
81 
82         //We will do cycle on the queue
83         for(uint i=0; i<queue.length; i++){
84 
85             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
86 
87             Deposit storage dep = queue[idx]; //get the info of the first investor
88 
89             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
90                 dep.depositor.send(dep.expect); //Send money to him
91                 money -= dep.expect;            //update money left
92 
93                 //this investor is fully paid, so remove him
94                 delete queue[idx];
95             }else{
96                 //Here we don't have enough money so partially pay to investor
97                 dep.depositor.send(money); //Send to him everything we have
98                 dep.expect -= money;       //Update the expected amount
99                 break;                     //Exit cycle
100             }
101 
102             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
103                 break;                     //The next investor will process the line further
104         }
105 
106         currentReceiverIndex += i; //Update the index of the current first investor
107     }
108 
109     //Get the deposit info by its index
110     //You can get deposit index from
111     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
112         Deposit storage dep = queue[idx];
113         return (dep.depositor, dep.deposit, dep.expect);
114     }
115 
116     //Get the count of deposits of specific investor
117     function getDepositsCount(address depositor) public view returns (uint) {
118         uint c = 0;
119         for(uint i=currentReceiverIndex; i<queue.length; ++i){
120             if(queue[i].depositor == depositor)
121                 c++;
122         }
123         return c;
124     }
125 
126     //Get all deposits (index, deposit, expect) of a specific investor
127     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
128         uint c = getDepositsCount(depositor);
129 
130         idxs = new uint[](c);
131         deposits = new uint128[](c);
132         expects = new uint128[](c);
133 
134         if(c > 0) {
135             uint j = 0;
136             for(uint i=currentReceiverIndex; i<queue.length; ++i){
137                 Deposit storage dep = queue[i];
138                 if(dep.depositor == depositor){
139                     idxs[j] = i;
140                     deposits[j] = dep.deposit;
141                     expects[j] = dep.expect;
142                     j++;
143                 }
144             }
145         }
146     }
147     
148     //Get current queue size
149     function getQueueLength() public view returns (uint) {
150         return queue.length - currentReceiverIndex;
151     }
152 
153 }