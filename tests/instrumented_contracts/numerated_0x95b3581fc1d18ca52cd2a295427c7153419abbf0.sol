1 pragma solidity ^0.4.25;
2 
3 /**
4   Контракт Multi7 (Множитель7): возвращает 107% от вашего депозита!
5   Автоматические выплаты на базе смарт-контракта (НЕ НУЖНА администрация)
6   
7   Инструкция:
8   1. Пошлите любую ненулевую сумму на адрес контракта
9      - сумма от 0.01 до 5 ETH
10      - gas limit минимум 250000
11      - вы встанете в очередь
12   2. Немного подождите
13   3. ...
14   4. PROFIT! Вам пришло 107% от вашего депозита.
15 
16   Как это возможно?
17   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
18      новых инвесторов до тех пор, пока не получит 107% от своего депозита
19   2. Выплаты могут приходить несколькими частями или все сразу
20   3. Как только вы получаете 107% от вашего депозита, вы удаляетесь из очереди
21   4. Вы можете делать несколько депозитов сразу
22   5. Баланс этого контракта должен обычно быть в районе 0, потому что все поступления
23      сразу же направляются на выплаты
24 
25      Таким образом, последние платят первым, и инвесторы, достигшие выплат 107% от депозита,
26      удаляются из очереди, уступая место остальным
27 
28               новый инвестор --|            совсем новый инвестор --|
29                  инвестор5     |                новый инвестор      |
30                  инвестор4     |     =======>      инвестор5        |
31                  инвестор3     |                   инвестор4        |
32  (част. выплата) инвестор2    <|                   инвестор3        |
33 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 107%)
34 
35   Внимание! Данный смарт-контракт является высоко-рисковым инвестиционным инструментом
36   Используйте только те средства, которые не боитесь потерять.
37 */
38 
39 contract Multi7 {
40     //Address for promo expences
41     address constant private PROMO = 0x3828F118b075d0c25b8Cf712030E9102200A3e90;
42     //Percent for promo expences
43     uint constant public PROMO_PERCENT = 3; //3% for advertizing
44     //How many percent for your deposit to be multiplied
45     uint constant public MULTIPLIER = 107;
46 
47     //The deposit structure holds all the info about the deposit made
48     struct Deposit {
49         address depositor; //The depositor address
50         uint128 deposit;   //The deposit amount
51         uint128 expect;    //How much we should pay out (initially it is 107% of deposit)
52     }
53 
54     Deposit[] private queue;  //The queue
55     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
56 
57     //This function receives all the deposits
58     //stores them and make immediate payouts
59     function () public payable {
60         if(msg.value > 0){
61             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
62             require(msg.value <= 5 ether); // Do not allow too big investments to stabilize payouts
63 
64             //Add the investor into the queue. Mark that he expects to receive 107% of deposit back
65             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
66 
67             //Send some promo to enable this contract to leave long-long time
68             uint promo = msg.value*PROMO_PERCENT/100;
69             PROMO.send(promo);
70 
71             //Pay to first investors in line
72             pay();
73         }
74     }
75 
76     //Used to pay to current investors
77     //Each new transaction processes 1 - 4+ investors in the head of queue 
78     //depending on balance and gas left
79     function pay() private {
80         //Try to send all the money on contract to the first investors in line
81         uint128 money = uint128(address(this).balance);
82 
83         //We will do cycle on the queue
84         for(uint i=0; i<queue.length; i++){
85 
86             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
87 
88             Deposit storage dep = queue[idx]; //get the info of the first investor
89 
90             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
91                 dep.depositor.send(dep.expect); //Send money to him
92                 money -= dep.expect;            //update money left
93 
94                 //this investor is fully paid, so remove him
95                 delete queue[idx];
96             }else{
97                 //Here we don't have enough money so partially pay to investor
98                 dep.depositor.send(money); //Send to him everything we have
99                 dep.expect -= money;       //Update the expected amount
100                 break;                     //Exit cycle
101             }
102 
103             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
104                 break;                     //The next investor will process the line further
105         }
106 
107         currentReceiverIndex += i; //Update the index of the current first investor
108     }
109 
110     //Get the deposit info by its index
111     //You can get deposit index from
112     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
113         Deposit storage dep = queue[idx];
114         return (dep.depositor, dep.deposit, dep.expect);
115     }
116 
117     //Get the count of deposits of specific investor
118     function getDepositsCount(address depositor) public view returns (uint) {
119         uint c = 0;
120         for(uint i=currentReceiverIndex; i<queue.length; ++i){
121             if(queue[i].depositor == depositor)
122                 c++;
123         }
124         return c;
125     }
126 
127     //Get all deposits (index, deposit, expect) of a specific investor
128     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
129         uint c = getDepositsCount(depositor);
130 
131         idxs = new uint[](c);
132         deposits = new uint128[](c);
133         expects = new uint128[](c);
134 
135         if(c > 0) {
136             uint j = 0;
137             for(uint i=currentReceiverIndex; i<queue.length; ++i){
138                 Deposit storage dep = queue[i];
139                 if(dep.depositor == depositor){
140                     idxs[j] = i;
141                     deposits[j] = dep.deposit;
142                     expects[j] = dep.expect;
143                     j++;
144                 }
145             }
146         }
147     }
148     
149     //Get current queue size
150     function getQueueLength() public view returns (uint) {
151         return queue.length - currentReceiverIndex;
152     }
153 
154 }