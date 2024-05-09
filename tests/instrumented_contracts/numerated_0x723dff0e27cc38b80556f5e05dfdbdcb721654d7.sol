1 pragma solidity ^0.4.4;
2 contract DFS {
3   
4     struct Deposit {
5         uint amount;
6         uint plan;
7         uint time;
8         uint payed;
9         address sender;
10     }
11     uint numDeposits;
12     mapping (uint => Deposit) deposits;
13     
14     address constant owner1 = 0x8D98b4360F20FD285FF38bd2BB2B0e4E9159D77e;
15     address constant owner2 = 0x1D8850Ff087b3256Cb98945D478e88bAeF892Bd4;
16     
17     function makeDeposit(
18         uint plan,
19         address ref1,
20         address ref2,
21         address ref3
22     ) payable {
23 
24         /* minimum amount is 3 ether, plan must be 1, 2 or 3 */
25         if (msg.value < 3 ether || (plan != 1 && plan !=2 && plan !=3)) {
26             throw;
27         }
28 
29         uint amount;
30         /* maximum amount is 1000 ether */
31         if (msg.value > 1000 ether) {
32             if(!msg.sender.send(msg.value - 1000 ether)) {
33                 throw;
34             }
35             amount = 1000 ether;
36         } else {
37             amount = msg.value;
38         }
39         
40         deposits[numDeposits++] = Deposit({
41             sender: msg.sender,
42             time: now,
43             amount: amount,
44             plan: plan,
45             payed: 0,
46         });
47         
48         /* fee */
49         if(!owner1.send(amount *  5/2 / 100)) {
50             throw;
51         }
52         if(!owner2.send(amount *  5/2 / 100)) {
53             throw;
54         }
55         
56         /* referral rewards */
57         if(ref1 != address(0x0)){
58             /* 1st level referral rewards */
59             if(!ref1.send(amount * 5 / 100)) {
60                 throw;
61             }
62             if(ref2 != address(0x0)){
63                 /* 2nd level referral rewards */
64                 if(!ref2.send(amount * 2 / 100)) {
65                     throw;
66                 }
67                 if(ref3 != address(0x0)){
68                     /* 3nd level referral rewards */
69                     if(!ref3.send(amount / 100)) {
70                         throw;
71                     }
72                 }
73             }
74         }
75     }
76 
77     uint i;
78 
79     function pay(){
80 
81         while (i < numDeposits && msg.gas > 200000) {
82 
83             uint rest =  (now - deposits[i].time) % 1 days;
84             uint depositDays =  (now - deposits[i].time - rest) / 1 days;
85             uint profit;
86             uint amountToWithdraw;
87             
88             if(deposits[i].plan == 1){
89                 if(depositDays > 30){
90                     depositDays = 30;
91                 }
92                 profit = deposits[i].amount * depositDays  * 7/2 / 100;
93             }
94             
95             if(deposits[i].plan == 2){
96                 if(depositDays > 90){
97                     depositDays = 90;
98                 }
99                 profit = deposits[i].amount * depositDays  * 27/20 / 100;
100             }
101             
102             if(deposits[i].plan == 3){
103                 if(depositDays > 180){
104                     depositDays = 180;
105                 }
106                 profit = deposits[i].amount * depositDays  * 9/10 / 100;
107             }
108             
109  
110             if(profit > deposits[i].payed){
111                 amountToWithdraw = profit - deposits[i].payed;
112                 if(this.balance > amountToWithdraw){
113                     if(!deposits[i].sender.send(amountToWithdraw)) {}
114                     deposits[i].payed = profit;
115                 } else {
116                     return;
117                 }
118             }
119             i++;
120         }
121         if(i == numDeposits){
122              i = 0;
123         }
124     }
125 }