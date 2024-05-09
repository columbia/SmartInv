1 pragma solidity ^0.4.24;
2 
3 contract FastProfit {
4     address constant private PROMO = 0xA93c13B3E3561e5e2A1a20239486D03A16d1Fc4b;
5     uint constant public PROMO_PERCENT = 5;
6     uint constant public MULTIPLIER = 110;
7     uint constant public MAX_DEPOSIT = 1 ether;
8     uint constant public MIN_DEPOSIT = 0.01 ether;
9 
10     uint constant public LAST_DEPOSIT_PERCENT = 2;
11     
12     LastDeposit public last;
13 
14     struct Deposit {
15         address depositor; 
16         uint128 deposit;   
17         uint128 expect;    
18     }
19 
20     struct LastDeposit {
21         address depositor;
22         uint expect;
23         uint blockNumber;
24     }
25 
26     Deposit[] private queue;
27     uint public currentReceiverIndex = 0; 
28 
29     function () public payable {
30         if(msg.value == 0 && msg.sender == last.depositor) {
31             require(gasleft() >= 220000, "We require more gas!");
32             require(last.blockNumber + 258 < block.number, "Last depositor should wait 258 blocks (~1 hour) to claim reward");
33             
34             uint128 money = uint128((address(this).balance));
35             if(money >= last.expect){
36                 last.depositor.transfer(last.expect);
37             } else {
38                 last.depositor.transfer(money);
39             }
40             
41             delete last;
42         }
43         else if(msg.value > 0){
44             require(gasleft() >= 220000, "We require more gas!");
45             require(msg.value <= MAX_DEPOSIT && msg.value >= MIN_DEPOSIT, "Deposit must be >= 0.01 ETH and <= 1 ETH"); 
46 
47             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
48 
49             last.depositor = msg.sender;
50             last.expect += msg.value*LAST_DEPOSIT_PERCENT/100;
51             last.blockNumber = block.number;
52 
53             uint promo = msg.value*PROMO_PERCENT/100;
54             PROMO.transfer(promo);
55 
56             pay();
57         }
58     }
59 
60     function pay() private {
61         uint128 money = uint128((address(this).balance)-last.expect);
62 
63         for(uint i=0; i<queue.length; i++){
64 
65             uint idx = currentReceiverIndex + i;  
66 
67             Deposit storage dep = queue[idx]; 
68 
69             if(money >= dep.expect){  
70                 dep.depositor.transfer(dep.expect); 
71                 money -= dep.expect;            
72 
73                 
74                 delete queue[idx];
75             }else{
76                 dep.depositor.transfer(money); 
77                 dep.expect -= money;       
78                 break;
79             }
80 
81             if(gasleft() <= 50000)        
82                 break;
83         }
84 
85         currentReceiverIndex += i; 
86     }
87 
88     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
89         Deposit storage dep = queue[idx];
90         return (dep.depositor, dep.deposit, dep.expect);
91     }
92 
93     function getDepositsCount(address depositor) public view returns (uint) {
94         uint c = 0;
95         for(uint i=currentReceiverIndex; i<queue.length; ++i){
96             if(queue[i].depositor == depositor)
97                 c++;
98         }
99         return c;
100     }
101 
102     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
103         uint c = getDepositsCount(depositor);
104 
105         idxs = new uint[](c);
106         deposits = new uint128[](c);
107         expects = new uint128[](c);
108 
109         if(c > 0) {
110             uint j = 0;
111             for(uint i=currentReceiverIndex; i<queue.length; ++i){
112                 Deposit storage dep = queue[i];
113                 if(dep.depositor == depositor){
114                     idxs[j] = i;
115                     deposits[j] = dep.deposit;
116                     expects[j] = dep.expect;
117                     j++;
118                 }
119             }
120         }
121     }
122     
123     function getQueueLength() public view returns (uint) {
124         return queue.length - currentReceiverIndex;
125     }
126 
127 }