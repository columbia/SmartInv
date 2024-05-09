1 pragma solidity ^0.4.25;
2 
3 contract EtherwaterTest {
4     //Address for promo expences
5     address constant private PROMO = 0x014bF153476683dC0A0673325C07EB3342281DC8;
6     //Percent for promo expences
7     uint constant public PROMO_PERCENT = 6; //6 for advertizing, 1 for techsupport
8     //How many percent for your deposit to be multiplied
9     uint constant public MULTIPLIER = 119;
10 
11     //The deposit structure holds all the info about the deposit made
12     struct Deposit {
13         address depositor; //The depositor address
14         uint128 deposit;   //The deposit amount
15         uint128 expect;    //How much we should pay out (initially it is 121% of deposit)
16     }
17 
18     Deposit[] private queue;  //The queue
19     uint public currentReceiverIndex = 0; //The index of the first depositor in the queue. The receiver of investments!
20 
21     //This function receives all the deposits
22     //stores them and make immediate payouts
23     function () public payable {
24         if(msg.value > 0){
25             require(gasleft() >= 220000, "We require more gas!"); //We need gas to process queue
26             require(msg.value <= 13 ether); //Do not allow too big investments to stabilize payouts
27 
28             //Add the investor into the queue. Mark that he expects to receive 121% of deposit back
29             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
30 
31             //Send some promo to enable this contract to leave long-long time
32             uint promo = msg.value*PROMO_PERCENT/100;
33             PROMO.send(promo);
34 
35             //Pay to first investors in line
36             pay();
37         }
38     }
39 
40     //Used to pay to current investors
41     //Each new transaction processes 1 - 4+ investors in the head of queue 
42     //depending on balance and gas left
43     function pay() private {
44         //Try to send all the money on contract to the first investors in line
45         uint128 money = uint128(address(this).balance);
46 
47         //We will do cycle on the queue
48         for(uint i=0; i<queue.length; i++){
49 
50             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
51 
52             Deposit storage dep = queue[idx]; //get the info of the first investor
53 
54             if(money >= dep.expect){  //If we have enough money on the contract to fully pay to investor
55                 dep.depositor.send(dep.expect); //Send money to him
56                 money -= dep.expect;            //update money left
57 
58                 //this investor is fully paid, so remove him
59                 delete queue[idx];
60             }else{
61                 //Here we don't have enough money so partially pay to investor
62                 dep.depositor.send(money); //Send to him everything we have
63                 dep.expect -= money;       //Update the expected amount
64                 break;                     //Exit cycle
65             }
66 
67             if(gasleft() <= 50000)         //Check the gas left. If it is low, exit the cycle
68                 break;                     //The next investor will process the line further
69         }
70 
71         currentReceiverIndex += i; //Update the index of the current first investor
72     }
73 
74     //Get the deposit info by its index
75     //You can get deposit index from
76     function getSingleDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
77         Deposit storage dep = queue[idx];
78         return (dep.depositor, dep.deposit, dep.expect);
79     }
80 
81     //Get the count of deposits of specific investor
82     function getDepositsCount(address depositor) public view returns (uint) {
83         uint c = 0;
84         for(uint i=currentReceiverIndex; i<queue.length; ++i){
85             if(queue[i].depositor == depositor)
86                 c++;
87         }
88         return c;
89     }
90 
91     //Get all deposits (index, deposit, expect) of a specific investor
92     function getAllDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
93         uint c = getDepositsCount(depositor);
94 
95         idxs = new uint[](c);
96         deposits = new uint128[](c);
97         expects = new uint128[](c);
98 
99         if(c > 0) {
100             uint j = 0;
101             for(uint i=currentReceiverIndex; i<queue.length; ++i){
102                 Deposit storage dep = queue[i];
103                 if(dep.depositor == depositor){
104                     idxs[j] = i;
105                     deposits[j] = dep.deposit;
106                     expects[j] = dep.expect;
107                     j++;
108                 }
109             }
110         }
111     }
112     
113     //Get current queue size
114     function getQueueLength() public view returns (uint) {
115         return queue.length - currentReceiverIndex;
116     }
117 
118 }