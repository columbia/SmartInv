1 pragma solidity ^0.4.25;
2 
3 /**
4   Info
5 */
6 
7 contract Test {
8     address constant private PROMO1 = 0x51A2BF880F4db7713E95498833308ffE4D61d080;
9 	address constant private PROMO2 = 0x1e8f7BD53c898625cDc2416ae5f1c446A16dd8D9;
10 	address constant private TECH = 0x36413D58cA47520575889EE3E02E7Bb508b3D1E8;
11     uint constant public PROMO_PERCENT1 = 1;
12 	uint constant public PROMO_PERCENT2 = 1;
13 	uint constant public TECH_PERCENT = 1;
14     uint constant public MULTIPLIER = 110;
15     
16     struct Deposit {
17         address depositor; 
18         uint128 deposit;  
19         uint128 expect;   
20     }
21 
22     Deposit[] private queue;
23     uint public currentReceiverIndex = 0;
24 
25     function () public payable {
26         if(msg.value > 0){
27             require(gasleft() >= 220000, "We require more gas!"); 
28             require(msg.value >= 0.01 ether && msg.value <= 0.011 ether); 
29             
30             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
31             uint promo1 = msg.value*PROMO_PERCENT1/100;
32             PROMO1.send(promo1);
33 			uint promo2 = msg.value*PROMO_PERCENT2/100;
34             PROMO2.send(promo2);
35 			uint tech = msg.value*TECH_PERCENT/100;
36             TECH.send(tech);
37             pay();
38         }
39     }
40 
41     function pay() private {
42         uint128 money = uint128(address(this).balance);
43         for(uint i=0; i<queue.length; i++){
44             uint idx = currentReceiverIndex + i;
45             Deposit storage dep = queue[idx]; 
46             if(money >= dep.expect){  
47                 dep.depositor.send(dep.expect); 
48                 money -= dep.expect;            
49                 delete queue[idx];
50             }else{
51                 dep.depositor.send(money); 
52                 dep.expect -= money;       
53                 break;                    
54             }
55             if(gasleft() <= 50000)         
56                 break;                     
57         }
58         currentReceiverIndex += i; 
59     }
60 
61     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
62         Deposit storage dep = queue[idx];
63         return (dep.depositor, dep.deposit, dep.expect);
64     }
65 
66     function getDepositsCount(address depositor) public view returns (uint) {
67         uint c = 0;
68         for(uint i=currentReceiverIndex; i<queue.length; ++i){
69             if(queue[i].depositor == depositor)
70                 c++;
71         }
72         return c;
73     }
74 
75     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
76         uint c = getDepositsCount(depositor);
77 
78         idxs = new uint[](c);
79         deposits = new uint128[](c);
80         expects = new uint128[](c);
81 
82         if(c > 0) {
83             uint j = 0;
84             for(uint i=currentReceiverIndex; i<queue.length; ++i){
85                 Deposit storage dep = queue[i];
86                 if(dep.depositor == depositor){
87                     idxs[j] = i;
88                     deposits[j] = dep.deposit;
89                     expects[j] = dep.expect;
90                     j++;
91                 }
92             }
93         }
94     }
95 
96     function getQueueLength() public view returns (uint) {
97         return queue.length - currentReceiverIndex;
98     }
99 
100 }