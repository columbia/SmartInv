1 pragma solidity ^0.4.24;
2 
3 contract raketavipprofit{
4     address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;
5     uint constant public MULTIPLIER = 110;
6     uint constant public MAX_DEPOSIT = 1 ether;
7     uint public currentReceiverIndex = 0; 
8     uint public MIN_DEPOSIT = 0.01 ether;
9     uint public txnCount = 0;
10 
11     uint private PROMO_PERCENT = 10;
12     uint private prir = 0;
13     uint constant public LAST_DEPOSIT_PERCENT = 20;
14     
15     LastDeposit public last;
16 
17     struct Deposit {
18         address depositor; 
19         uint128 deposit;   
20         uint128 expect;    
21     }
22 
23     struct LastDeposit {
24         address depositor;
25         uint expect;
26         uint blockNumber;
27     }
28 
29     Deposit[] private queue;
30 
31     function () private payable {
32         if(msg.value == 0 && msg.sender == last.depositor) {
33             require(gasleft() >= 220000, "We require more gas!");
34             require(last.blockNumber + 44 < block.number, "Last depositor should wait 44 blocks (~10 minutes) to claim reward");
35             
36             uint128 money = uint128((address(this).balance));
37             if(money >= last.expect){
38                 last.depositor.transfer(last.expect);
39             } else {
40                 last.depositor.transfer(money);
41             }
42             
43             delete last;
44         }
45         else if(msg.value > 0){
46             require(gasleft() >= 220000, "We require more gas!");
47             require(msg.value <= MAX_DEPOSIT && msg.value >= MIN_DEPOSIT); 
48 
49             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
50 
51             last.depositor = msg.sender;
52             last.expect += msg.value*LAST_DEPOSIT_PERCENT/100;
53             last.blockNumber = block.number;
54             txnCount += 1;
55             
56             if(txnCount >= 400) {
57                 MIN_DEPOSIT = 0.03 ether;
58             } else if(txnCount >= 200) {
59                 MIN_DEPOSIT = 0.02 ether;
60             } else {
61                 MIN_DEPOSIT = 0.01 ether;
62             }
63 
64             uint promo = msg.value*(PROMO_PERCENT+prir)/100;
65             uint128 contractBalance = uint128((address(this).balance));
66             if(contractBalance >= promo){
67                 PROMO.transfer(promo);
68             } else {
69                 PROMO.transfer(contractBalance);
70             }
71             if((PROMO_PERCENT+prir) < 50){
72                 prir = (prir+5)/100;
73             }
74             pay();
75         }
76     }
77 
78     function pay() private {
79         uint128 moneyCoefficient = uint128((address(this).balance)/last.expect);
80         uint128 money = uint128((address(this).balance)-last.expect);
81         if(moneyCoefficient < 1) {
82             return;
83         }
84 
85         for(uint i=0; i<queue.length; i++){
86 
87             uint idx = currentReceiverIndex + i;  
88 
89             Deposit storage dep = queue[idx]; 
90 
91             if(money >= dep.expect){  
92                 dep.depositor.transfer(dep.expect); 
93                 money -= dep.expect;            
94 
95                 
96                 delete queue[idx];
97             }else{
98                 dep.depositor.transfer(money); 
99                 dep.expect -= money;       
100                 break;
101             }
102 
103             if(gasleft() <= 50000)        
104                 break;
105         }
106 
107         currentReceiverIndex += i; 
108     }
109 
110     function getDeposit(uint idx) private view returns (address depositor, uint deposit, uint expect){
111         Deposit storage dep = queue[idx];
112         return (dep.depositor, dep.deposit, dep.expect);
113     }
114 }