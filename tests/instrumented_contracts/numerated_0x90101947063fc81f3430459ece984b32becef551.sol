1 pragma solidity ^0.4.25;
2 
3 //Умножитель 117% с призом последнему вкладчику - x2 от его вклада
4 //Если в течение 30 минут нет новых вкладов, последний вкладчик получает свой вклад х2
5 
6 contract Multiplier3 {
7     //Address for tech expences
8     address constant private TECH = 0x2392169A23B989C053ECED808E4899c65473E4af;
9     //Address for promo expences and prize for the last depositor
10     address constant private PROMO_AND_PRIZE = 0xdA149b17C154e964456553C749B7B4998c152c9E;
11     //Percent for first multiplier donation
12     uint constant public TECH_PERCENT = 1;
13     uint constant public PROMO_AND_PRIZE_PERCENT = 6;
14     uint constant public MAX_INVESTMENT = 10 ether;
15 
16     //How many percent for your deposit to be multiplied
17     uint constant public MULTIPLIER = 117;
18 
19     //The deposit structure holds all the info about the deposit made
20     struct Deposit {
21         address depositor; //The depositor address
22         uint128 deposit;   //The deposit amount
23         uint128 expect;    //How much we should pay out (initially it is 111% of deposit)
24     }
25 
26     Deposit[] private queue;  //The queue
27     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
28 
29     //This function receives all the deposits
30     //stores them and make immediate payouts
31     function () public payable {
32         //If money are from first multiplier, just add them to the balance
33         //All these money will be distributed to current investors
34         if(msg.value > 0){
35             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
36             require(msg.value <= MAX_INVESTMENT); //Do not allow too big investments to stabilize payouts
37 
38             //Add the investor into the queue. Mark that he expects to receive 111% of deposit back
39             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
40 
41             //Send donation to the promo and prize fund
42             uint adv = msg.value*PROMO_AND_PRIZE_PERCENT/100;
43             PROMO_AND_PRIZE.send(adv);
44             //Send small part to tech support
45             uint support = msg.value*TECH_PERCENT/100;
46             TECH.send(support);
47 
48             //Pay to first investors in line
49             pay();
50         }
51     }
52 
53     //Used to pay to current investors
54     //Each new transaction processes 1 - 4+ investors in the head of queue
55     //depending on balance and gas left
56     function pay() private {
57         //Try to send all the money on contract to the first investors in line
58         uint128 money = uint128(address(this).balance);
59 
60         //We will do cycle on the queue
61         for(uint i=currentReceiverIndex; i<queue.length; i++){
62 
63             Deposit storage dep = queue[i]; //get the info of the first investor
64 
65             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
66                 dep.depositor.send(dep.expect); //Send money to him
67                 money -= dep.expect;            //update money left
68 
69                 //this investor is fully paid, so remove him
70                 delete queue[i];
71             }else{
72                 //Here we don't have enough money so partially pay to investor
73                 dep.depositor.send(money); //Send to him everything we have
74                 dep.expect -= money;       //Update the expected amount
75                 break;                     //Exit cycle
76             }
77 
78             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
79                 break;                     //The next investor will process the line further
80         }
81 
82         currentReceiverIndex = i; //Update the index of the current first investor
83     }
84 
85     //Get the deposit info by its index
86     //You can get deposit index from
87     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
88         Deposit storage dep = queue[idx];
89         return (dep.depositor, dep.deposit, dep.expect);
90     }
91 
92     //Get the count of deposits of specific investor
93     function getDepositsCount(address depositor) public view returns (uint) {
94         uint c = 0;
95         for(uint i=currentReceiverIndex; i<queue.length; ++i){
96             if(queue[i].depositor == depositor)
97                 c++;
98         }
99         return c;
100     }
101 
102     //Get all deposits (index, deposit, expect) of a specific investor
103     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
104         uint c = getDepositsCount(depositor);
105 
106         idxs = new uint[](c);
107         deposits = new uint128[](c);
108         expects = new uint128[](c);
109 
110         if(c > 0) {
111             uint j = 0;
112             for(uint i=currentReceiverIndex; i<queue.length; ++i){
113                 Deposit storage dep = queue[i];
114                 if(dep.depositor == depositor){
115                     idxs[j] = i;
116                     deposits[j] = dep.deposit;
117                     expects[j] = dep.expect;
118                     j++;
119                 }
120             }
121         }
122     }
123 
124     //Get current queue size
125     function getQueueLength() public view returns (uint) {
126         return queue.length - currentReceiverIndex;
127     }
128 
129 }