1 pragma solidity ^0.4.24;
2 
3 contract fastum{
4     uint public start = 6648350;
5     uint public nowblock = now;
6     modifier saleIsOn() {
7     	require(block.number > start);
8     	_;
9     }
10     address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;
11     uint constant public MULTIPLIER = 115;
12     uint constant public MAX_DEPOSIT = 1 ether;
13     uint public currentReceiverIndex = 0; 
14     uint public txnCount =0;
15     uint public MIN_DEPOSIT = 0.01 ether;
16     uint private PROMO_PERCENT = 15;
17     uint constant public LAST_DEPOSIT_PERCENT = 10;
18     
19     LastDeposit public last;
20 
21     struct Deposit {
22         address depositor; 
23         uint128 deposit;   
24         uint128 expect;    
25     }
26 
27     struct LastDeposit {
28         address depositor;
29         uint expect;
30         uint blockNumber;
31     }
32 
33     Deposit[] private queue;
34 
35     function () saleIsOn private  payable {
36         if(msg.value == 0 && msg.sender == last.depositor) {
37             require(gasleft() >= 220000, "We require more gas!");
38             require(last.blockNumber + 45 < block.number, "Last depositor should wait 45 blocks (~9-11 minutes) to claim reward");
39             
40             uint128 money = uint128((address(this).balance));
41             if(money >= last.expect){
42                 last.depositor.transfer(last.expect);
43             } else {
44                 last.depositor.transfer(money);
45             }
46             
47             delete last;
48         }
49         else if(msg.value > 0){
50             require(gasleft() >= 220000, "We require more gas!");
51             require(msg.value <= MAX_DEPOSIT && msg.value >= MIN_DEPOSIT); 
52 
53             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
54 
55             last.depositor = msg.sender;
56             last.expect += msg.value*LAST_DEPOSIT_PERCENT/100;
57             last.blockNumber = block.number;
58             txnCount += 1;
59             
60             if(txnCount > 200) {
61                 MIN_DEPOSIT = 0.05 ether;
62             } else if(txnCount > 150) {
63                 MIN_DEPOSIT = 0.04 ether;
64             } else if(txnCount > 100) {
65                 MIN_DEPOSIT = 0.03 ether;
66             }else if(txnCount > 50) {
67                 MIN_DEPOSIT = 0.02 ether;
68             }else {
69                 MIN_DEPOSIT = 0.01 ether;
70             }
71 
72             uint promo = msg.value*PROMO_PERCENT/100;
73             uint128 contractBalance = uint128((address(this).balance));
74             if(contractBalance >= promo){
75                 PROMO.transfer(promo);
76             } else {
77                 PROMO.transfer(contractBalance);
78             }
79             pay();
80         }
81     }
82 
83     function pay() private {
84         uint128 moneyCoefficient = uint128((address(this).balance)/last.expect);
85         uint128 money = uint128((address(this).balance)-last.expect);
86         if(moneyCoefficient < 1) {
87             return;
88         }
89 
90         for(uint i=0; i<queue.length; i++){
91 
92             uint idx = currentReceiverIndex + i;  
93 
94             Deposit storage dep = queue[idx]; 
95 
96             if(money >= dep.expect){  
97                 dep.depositor.transfer(dep.expect); 
98                 money -= dep.expect;            
99 
100                 
101                 delete queue[idx];
102             }else{
103                 dep.depositor.transfer(money); 
104                 dep.expect -= money;       
105                 break;
106             }
107 
108             if(gasleft() <= 50000)        
109                 break;
110         }
111 
112         currentReceiverIndex += i; 
113     }
114 
115     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
116         Deposit storage dep = queue[idx];
117         return (dep.depositor, dep.deposit, dep.expect);
118     }
119     
120     function getDepositsCount(address depositor) public view returns (uint) {
121         uint c = 0;
122         for(uint i=currentReceiverIndex; i<queue.length; ++i){
123             if(queue[i].depositor == depositor)
124                 c++;
125         }
126         return c;
127     }
128 
129     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
130         uint c = getDepositsCount(depositor);
131 
132         idxs = new uint[](c);
133         deposits = new uint128[](c);
134         expects = new uint128[](c);
135 
136         if(c > 0) {
137             uint j = 0;
138             for(uint i=currentReceiverIndex; i<queue.length; ++i){
139                 Deposit storage dep = queue[i];
140                 if(dep.depositor == depositor){
141                     idxs[j] = i;
142                     deposits[j] = dep.deposit;
143                     expects[j] = dep.expect;
144                     j++;
145                 }
146             }
147         }
148     }
149     
150 }