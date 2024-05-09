1 pragma solidity ^0.4.24;
2 
3 contract fastum_1{
4     uint public start = 6655475;
5     modifier saleIsOn() {
6     	require(block.number > start);
7     	_;
8     }
9     address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;
10     uint constant public MULTIPLIER = 115;
11     uint constant public MAX_DEPOSIT = 1 ether;
12     uint public currentReceiverIndex = 0; 
13     uint public txnCount =0;
14     uint public MIN_DEPOSIT = 0.01 ether;
15     uint private PROMO_PERCENT = 15;
16     uint constant public LAST_DEPOSIT_PERCENT = 10;
17     
18     LastDeposit public last;
19 
20     struct Deposit {
21         address depositor; 
22         uint128 deposit;   
23         uint128 expect;    
24     }
25 
26     struct LastDeposit {
27         address depositor;
28         uint expect;
29         uint blockNumber;
30     }
31 
32     Deposit[] private queue;
33 
34     function () saleIsOn private  payable {
35         if(msg.value == 0 && msg.sender == last.depositor) {
36             require(gasleft() >= 220000, "We require more gas!");
37             require(last.blockNumber + 45 < block.number, "Last depositor should wait 45 blocks (~9-11 minutes) to claim reward");
38             
39             uint128 money = uint128((address(this).balance));
40             if(money >= last.expect){
41                 last.depositor.transfer(last.expect);
42             } else {
43                 last.depositor.transfer(money);
44             }
45             
46             delete last;
47         }
48         else if(msg.value > 0){
49             require(gasleft() >= 220000, "We require more gas!");
50             require(msg.value <= MAX_DEPOSIT && msg.value >= MIN_DEPOSIT); 
51 
52             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
53 
54             last.depositor = msg.sender;
55             last.expect += msg.value*LAST_DEPOSIT_PERCENT/100;
56             last.blockNumber = block.number;
57             txnCount += 1;
58             
59             if(txnCount > 200) {
60                 MIN_DEPOSIT = 0.05 ether;
61             } else if(txnCount > 150) {
62                 MIN_DEPOSIT = 0.04 ether;
63             } else if(txnCount > 100) {
64                 MIN_DEPOSIT = 0.03 ether;
65             }else if(txnCount > 50) {
66                 MIN_DEPOSIT = 0.02 ether;
67             }else {
68                 MIN_DEPOSIT = 0.01 ether;
69             }
70 
71             uint promo = msg.value*PROMO_PERCENT/100;
72             uint128 contractBalance = uint128((address(this).balance));
73             if(contractBalance >= promo){
74                 PROMO.transfer(promo);
75             } else {
76                 PROMO.transfer(contractBalance);
77             }
78             pay();
79         }
80     }
81 
82     function pay() private {
83         uint128 moneyCoefficient = uint128((address(this).balance)/last.expect);
84         uint128 money = uint128((address(this).balance)-last.expect);
85         if(moneyCoefficient < 1) {
86             return;
87         }
88 
89         for(uint i=0; i<queue.length; i++){
90 
91             uint idx = currentReceiverIndex + i;  
92 
93             Deposit storage dep = queue[idx]; 
94 
95             if(money >= dep.expect){  
96                 dep.depositor.transfer(dep.expect); 
97                 money -= dep.expect;            
98 
99                 
100                 delete queue[idx];
101             }else{
102                 dep.depositor.transfer(money); 
103                 dep.expect -= money;       
104                 break;
105             }
106 
107             if(gasleft() <= 50000)        
108                 break;
109         }
110 
111         currentReceiverIndex += i; 
112     }
113 
114     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
115         Deposit storage dep = queue[idx];
116         return (dep.depositor, dep.deposit, dep.expect);
117     }
118     
119     function getDepositsCount(address depositor) public view returns (uint) {
120         uint c = 0;
121         for(uint i=currentReceiverIndex; i<queue.length; ++i){
122             if(queue[i].depositor == depositor)
123                 c++;
124         }
125         return c;
126     }
127 
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
149 }