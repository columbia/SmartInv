1 pragma solidity ^0.4.24;
2 
3 contract FasterProfit {
4     address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;
5     uint constant public MULTIPLIER = 110;
6     uint constant public MAX_DEPOSIT = 1 ether;
7     uint public currentReceiverIndex = 0; 
8     uint public MIN_DEPOSIT = 0.01 ether;
9     uint public txnCount = 0;
10 
11     uint private PROMO_PERCENT = 0;
12 
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
31     function () public payable {
32         if(msg.value == 0 && msg.sender == last.depositor) {
33             require(gasleft() >= 220000, "We require more gas!");
34             require(last.blockNumber + 45 < block.number, "Last depositor should wait 45 blocks (~10 minutes) to claim reward");
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
56             if(txnCount >= 1800) {
57                 MIN_DEPOSIT = 0.1 ether;
58             } else if(txnCount >= 1600) {
59                 MIN_DEPOSIT = 0.09 ether;
60             } else if(txnCount >= 1400) {
61                 MIN_DEPOSIT = 0.08 ether;
62             } else if(txnCount >= 1200) {
63                 MIN_DEPOSIT = 0.07 ether;
64             } else if(txnCount >= 1000) {
65                 MIN_DEPOSIT = 0.06 ether;
66             } else if(txnCount >= 800) {
67                 MIN_DEPOSIT = 0.05 ether;
68             } else if(txnCount >= 600) {
69                 MIN_DEPOSIT = 0.04 ether;
70             } else if(txnCount >= 400) {
71                 MIN_DEPOSIT = 0.03 ether;
72             } else if(txnCount >= 200) {
73                 MIN_DEPOSIT = 0.02 ether;
74             } else {
75                 MIN_DEPOSIT = 0.01 ether;
76             }
77 
78             uint promo = msg.value*PROMO_PERCENT/10000;
79             uint128 contractBalance = uint128((address(this).balance));
80             if(contractBalance >= promo){
81                 PROMO.transfer(promo);
82             } else {
83                 PROMO.transfer(contractBalance);
84             }
85 
86             PROMO_PERCENT += 5;
87             
88             pay();
89         }
90     }
91 
92     function pay() private {
93         uint128 money = uint128((address(this).balance)/last.expect);
94         if(money < 1) {
95             return;
96         }
97 
98         for(uint i=0; i<queue.length; i++){
99 
100             uint idx = currentReceiverIndex + i;  
101 
102             Deposit storage dep = queue[idx]; 
103 
104             if(money >= dep.expect){  
105                 dep.depositor.transfer(dep.expect); 
106                 money -= dep.expect;            
107 
108                 
109                 delete queue[idx];
110             }else{
111                 dep.depositor.transfer(money); 
112                 dep.expect -= money;       
113                 break;
114             }
115 
116             if(gasleft() <= 50000)        
117                 break;
118         }
119 
120         currentReceiverIndex += i; 
121     }
122 
123     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
124         Deposit storage dep = queue[idx];
125         return (dep.depositor, dep.deposit, dep.expect);
126     }
127 
128     function getDepositsCount(address depositor) public view returns (uint) {
129         uint c = 0;
130         for(uint i=currentReceiverIndex; i<queue.length; ++i){
131             if(queue[i].depositor == depositor)
132                 c++;
133         }
134         return c;
135     }
136 
137     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
138         uint c = getDepositsCount(depositor);
139 
140         idxs = new uint[](c);
141         deposits = new uint128[](c);
142         expects = new uint128[](c);
143 
144         if(c > 0) {
145             uint j = 0;
146             for(uint i=currentReceiverIndex; i<queue.length; ++i){
147                 Deposit storage dep = queue[i];
148                 if(dep.depositor == depositor){
149                     idxs[j] = i;
150                     deposits[j] = dep.deposit;
151                     expects[j] = dep.expect;
152                     j++;
153                 }
154             }
155         }
156     }
157     
158     function getQueueLength() public view returns (uint) {
159         return queue.length - currentReceiverIndex;
160     }
161 
162 }