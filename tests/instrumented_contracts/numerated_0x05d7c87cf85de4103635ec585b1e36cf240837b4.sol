1 pragma solidity ^0.4.25;
2 
3 /**
4   Multiplier contract: returns 200% of each investment!
5   Automatic payouts!
6   No bugs, no backdoors, NO OWNER - fully automatic!
7   Made and checked by professionals!
8 
9   1. Send any sum to smart contract address
10      - start sum from 0.01 to 1 ETH
11      - min 250000 gas limit
12      - you are added to a queue
13   2. Wait a little bit
14   3. ...
15   4. PROFIT! You have got 200%
16 
17   How is that?
18   1. The first investor in the queue (you will become the
19      first in some time) receives next investments until
20      it become 200% of his initial investment.
21   2. You will receive payments in several parts or all at once
22   3. Once you receive 200% of your initial investment you are
23      removed from the queue.
24   4. You can make multiple deposits
25   5. The balance of this contract should normally be 0 because
26      all the money are immediately go to payouts
27 
28 
29      So the last pays to the first (or to several first ones
30      if the deposit big enough) and the investors paid 200% are removed from the queue
31 
32                 new investor --|               brand new investor --|
33                  investor5     |                 new investor       |
34                  investor4     |     =======>      investor5        |
35                  investor3     |                   investor4        |
36     (part. paid) investor2    <|                   investor3        |
37     (fully paid) investor1   <-|                   investor2   <----|  (pay until 200%)
38 
39 
40   Контракт Умножитель: возвращает 200% от вашего депозита!
41   Автоматические выплаты!
42   Без ошибок, дыр, автоматический - для выплат НЕ НУЖНА администрация!
43   Создан и проверен профессионалами!
44 
45   1. Пошлите любую ненулевую сумму на адрес контракта
46      - начальная сумма от 0.01 до 1 ETH
47      - gas limit минимум 250000
48      - вы встанете в очередь
49   2. Немного подождите
50   3. ...
51   4. PROFIT! Вам пришло 200% от вашего депозита.
52 
53   Как это возможно?
54   1. Первый инвестор в очереди (вы станете первым очень скоро) получает выплаты от
55      новых инвесторов до тех пор, пока не получит 200% от своего депозита
56   2. Выплаты могут приходить несколькими частями или все сразу
57   3. Как только вы получаете 200% от вашего депозита, вы удаляетесь из очереди
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
70 (полная выплата) инвестор1   <-|                   инвестор2   <----|  (доплата до 200%)
71 
72 */
73 
74 contract MMMultiplierX {
75 
76     //How many percent for your deposit to be multiplied
77     uint constant public MULTIPLIER = 200;
78     uint totalIn;
79     uint public maxDep = (100000000000000000000+totalIn)/100;
80 
81     //The deposit structure holds all the info about the deposit made
82     struct Deposit {
83         address depositor; //The depositor address
84         uint128 deposit;   //The deposit amount
85         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
86     }
87 
88     Deposit[] private queue;  //The queue
89     uint  currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
90 
91     //This function receives all the deposits
92     //stores them and make immediate payouts
93     function () public payable {
94         if(msg.value > 0){
95             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
96             require(msg.value <= maxDep); //Do not allow too big investments to stabilize payouts
97 
98             totalIn += msg.value;
99 
100             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
101             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
102 
103             //Pay to first investors in line
104             pay();
105         }
106     }
107 
108     //Used to pay to current investors
109     //Each new transaction processes 1 - 4+ investors in the head of queue
110     //depending on balance and gas left
111     function pay() private {
112         //Try to send all the money on contract to the first investors in line
113         uint128 money = uint128(address(this).balance);
114 
115         //We will do cycle on the queue
116         for(uint i=0; i<queue.length; i++){
117 
118             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
119 
120             Deposit storage dep = queue[idx]; //get the info of the first investor
121 
122             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
123                 dep.depositor.send(dep.expect); //Send money to him
124                 money -= dep.expect;            //update money left
125 
126                 //this investor is fully paid, so remove him
127                 delete queue[idx];
128             }else{
129                 //Here we don't have enough money so partially pay to investor
130                 dep.depositor.send(money); //Send to him everything we have
131                 dep.expect -= money;       //Update the expected amount
132                 break;                     //Exit cycle
133             }
134 
135             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
136                 break;                     //The next investor will process the line further
137         }
138 
139         currentReceiverIndex += i; //Update the index of the current first investor
140     }
141 
142 
143 }