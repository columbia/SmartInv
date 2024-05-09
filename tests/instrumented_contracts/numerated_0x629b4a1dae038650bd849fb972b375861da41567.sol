1 pragma solidity ^0.4.25;
2 
3 /*
4 ----- ETHERWATERFALL SMART-CONTRACT -----
5 
6 You will get 119% of your deposit in a short period.
7 
8 ----- NO BACKDOOR - NO BUGS - PERFECT LOGIC - EFFICIENT PROMOTION -----
9 
10 
11 
12 ----- ETHERWATERFALL СМАРТ-КОНТРАКТ -----
13 
14 Вы получите 119% от Вашего депозита за короткий период.
15 
16 ----- НИКАКИХ БЭКДОРОВ - НИКАКИХ БАГОВ - ПРЕВОСХОДНАЯ ЛОГИКА - ЭФФЕКТИВНОЕ ПРОДВИЖЕНИЕ -----
17 */
18 
19 contract EtherWaterfall {
20     //Address for promo expenses
21     address constant private PROMO = 0x014bF153476683dC0A0673325C07EB3342281DC8;
22     //Percent for promo expenses
23     uint constant public PROMO_PERCENT = 6; //5% for advertising and 1% for technical support
24     //How many percent for your deposit will be multiplied
25     uint constant public MULTIPLIER = 119;
26 
27     //The deposit structure holds all the info about the deposit made
28     struct Deposit {
29         address depositor; //The depositor address
30         uint128 deposit;   //The deposit amount
31         uint128 expect;    //How much we should pay out (initially it is 119% of deposit)
32     }
33 
34     Deposit[] private queue;  //The queue
35     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
36 
37     //This function receives all the deposits
38     //stores them and make immediate payouts
39     function () public payable {
40         if(msg.value > 0){
41             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
42             require(msg.value <= 13 ether); //Do not allow too big investments to stabilize payouts
43 
44             //Add the investor in queue. Mark him that he expects to receive 119% of deposit back
45             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
46 
47             //Send some promo to enable this contract to leave long-long time
48             uint promo = msg.value*PROMO_PERCENT/100;
49             PROMO.send(promo);
50 
51             //Pay to first investors in line
52             pay();
53         }
54     }
55 
56     //Used to pay to current investors
57     //Each new transaction processes 1 - 4+ investors in the head of queue 
58     //depending on balance and gas left
59     function pay() private {
60         //Try to send all the money on contract to the first investors in line
61         uint128 money = uint128(address(this).balance);
62 
63         //We will do cycle on the queue
64         for(uint i=0; i<queue.length; i++){
65 
66             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
67 
68             Deposit storage dep = queue[idx]; //get the info of the first investor
69 
70             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
71                 dep.depositor.send(dep.expect); //Send money to him
72                 money -= dep.expect;            //update money left
73 
74                 //this investor is fully paid, so remove him
75                 delete queue[idx];
76             }else{
77                 //Here we don't have enough money so partially pay to investor
78                 dep.depositor.send(money); //Send to him everything we have
79                 dep.expect -= money;       //Update the expected amount
80                 break;                     //Exit cycle
81             }
82 
83             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
84                 break;                     //The next investor will process the line further
85         }
86 
87         currentReceiverIndex += i; //Update the index of the current first investor
88     }
89 
90     //Get deposit info by it ID
91     function getSingleDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
92         Deposit storage dep = queue[idx];
93         return (dep.depositor, dep.deposit, dep.expect);
94     }
95 
96     //Get count of deposits by certain investor
97     function getDepositsCount(address depositor) public view returns (uint) {
98         uint c = 0;
99         for(uint i=currentReceiverIndex; i<queue.length; ++i){
100             if(queue[i].depositor == depositor)
101                 c++;
102         }
103         return c;
104     }
105 
106     //Get all deposits (index, deposit, expect) by certain investor
107     function getAllDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
108         uint c = getDepositsCount(depositor);
109 
110         idxs = new uint[](c);
111         deposits = new uint128[](c);
112         expects = new uint128[](c);
113 
114         if(c > 0) {
115             uint j = 0;
116             for(uint i=currentReceiverIndex; i<queue.length; ++i){
117                 Deposit storage dep = queue[i];
118                 if(dep.depositor == depositor){
119                     idxs[j] = i;
120                     deposits[j] = dep.deposit;
121                     expects[j] = dep.expect;
122                     j++;
123                 }
124             }
125         }
126     }
127     
128     //Get current queue size
129     function getQueueLength() public view returns (uint) {
130         return queue.length - currentReceiverIndex;
131     }
132 
133 }