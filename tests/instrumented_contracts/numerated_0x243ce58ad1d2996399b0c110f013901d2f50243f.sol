1 pragma solidity ^0.4.25;
2 
3 
4 contract FastProfit {
5     //Address for promo expences
6     address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;
7     //Percent for promo expences
8     uint constant public PROMO_PERCENT = 5;
9     //How many percent for your deposit to be multiplied
10     uint constant public MULTIPLIER = 125;
11 
12     //The deposit structure holds all the info about the deposit made
13     struct Deposit {
14         address depositor; //The depositor address
15         uint128 deposit;   //The deposit amount
16         uint128 expect;    //How much we should pay out (initially it is 125% of deposit)
17     }
18 
19     Deposit[] private queue;  //The queue
20     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
21 
22     //This function receives all the deposits
23     //stores them and make immediate payouts
24     function () public payable {
25         if(msg.value > 0){
26             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
27             require(msg.value <= 10 ether); //Do not allow too big investments to stabilize payouts
28 
29             //Add the investor into the queue. Mark that he expects to receive 125% of deposit back
30             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
31 
32             //Send some promo to enable this contract to leave long-long time
33             uint promo = msg.value*PROMO_PERCENT/100;
34             PROMO.transfer(promo);
35 
36             //Pay to first investors in line
37             pay();
38         }
39     }
40 
41     //Used to pay to current investors
42     //Each new transaction processes 1 - 4+ investors in the head of queue 
43     //depending on balance and gas left
44     function pay() private {
45         //Try to send all the money on contract to the first investors in line
46         uint128 money = uint128(address(this).balance);
47 
48         //We will do cycle on the queue
49         for(uint i=0; i<queue.length; i++){
50 
51             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
52 
53             Deposit storage dep = queue[idx]; //get the info of the first investor
54 
55             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
56                 dep.depositor.transfer(dep.expect); //Send money to him
57                 money -= dep.expect;            //update money left
58 
59                 //this investor is fully paid, so remove him
60                 delete queue[idx];
61             }else{
62                 //Here we don't have enough money so partially pay to investor
63                 dep.depositor.transfer(money); //Send to him everything we have
64                 dep.expect -= money;       //Update the expected amount
65                 break;                     //Exit cycle
66             }
67 
68             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
69                 break;                     //The next investor will process the line further
70         }
71 
72         currentReceiverIndex += i; //Update the index of the current first investor
73     }
74 
75     //Get the deposit info by its index
76     //You can get deposit index from
77     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
78         Deposit storage dep = queue[idx];
79         return (dep.depositor, dep.deposit, dep.expect);
80     }
81 
82     //Get the count of deposits of specific investor
83     function getDepositsCount(address depositor) public view returns (uint) {
84         uint c = 0;
85         for(uint i=currentReceiverIndex; i<queue.length; ++i){
86             if(queue[i].depositor == depositor)
87                 c++;
88         }
89         return c;
90     }
91 
92     //Get all deposits (index, deposit, expect) of a specific investor
93     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
94         uint c = getDepositsCount(depositor);
95 
96         idxs = new uint[](c);
97         deposits = new uint128[](c);
98         expects = new uint128[](c);
99 
100         if(c > 0) {
101             uint j = 0;
102             for(uint i=currentReceiverIndex; i<queue.length; ++i){
103                 Deposit storage dep = queue[i];
104                 if(dep.depositor == depositor){
105                     idxs[j] = i;
106                     deposits[j] = dep.deposit;
107                     expects[j] = dep.expect;
108                     j++;
109                 }
110             }
111         }
112     }
113     
114     //Get current queue size
115     function getQueueLength() public view returns (uint) {
116         return queue.length - currentReceiverIndex;
117     }
118 
119 }