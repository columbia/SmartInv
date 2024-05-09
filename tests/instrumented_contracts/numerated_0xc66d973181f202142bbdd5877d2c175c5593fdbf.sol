1 pragma solidity ^0.4.25;
2 
3 /**
4   EN: Telegram channel https://t.me/formula1game
5    
6    FORMULA 1 Game - is a daily entertaining BLOCKCHAIN game 
7    with the possibility of winning ETHEREUM for each lap.
8    
9    JACKPOT is played in every race
10    MEGAJACKPOT once a week or by voting
11    ____________________________________________________________
12    
13    RU: Телеграм канал https://t.me/formula1game
14    
15    FORMULA 1 Game - это ежедневная развлекательная БЛОКЧЕЙН игра 
16    с возможностью выигрыша ETHEREUM за каждый пройденный круг.
17    
18    ДЖЕКПОТ разыгрывается в каждом заезде
19    МЕГАДЖЕКПОТ раз в неделю или по голосованию
20 */
21 
22 contract Formula1Game {
23     address constant private PROMO1 = 0x43D5bE543CFB01F62b8Df6070149A8eE7E49b39B;
24 	address constant private PROMO2 = 0x38bF70b7b45cd09aB56C137522f2360C7B060d3C;
25 	address constant private TECH = 0xbc6807e9BAdFbc2c8d8629cC72ECCDDA9CDec933;
26     uint constant public PROMO_PERCENT1 = 8;
27 	uint constant public PROMO_PERCENT2 = 1;
28 	uint constant public TECH_PERCENT = 3;
29     uint constant public MULTIPLIER = 125; 
30     
31     struct Deposit {
32         address depositor; 
33         uint128 deposit;  
34         uint128 expect;   
35     }
36 
37     Deposit[] private queue;
38     uint public currentReceiverIndex = 0;
39 
40     function () public payable {
41         if(msg.value > 0){
42             require(gasleft() >= 220000, "We require more gas!"); 
43             require(msg.value >= 0.05 ether && msg.value <= 0.15 ether); 
44             
45             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
46             uint promo1 = msg.value*PROMO_PERCENT1/100;
47             PROMO1.send(promo1);
48 			uint promo2 = msg.value*PROMO_PERCENT2/100;
49             PROMO2.send(promo2);
50 			uint tech = msg.value*TECH_PERCENT/100;
51             TECH.send(tech);
52             pay();
53         }
54     }
55 
56     function pay() private {
57         uint128 money = uint128(address(this).balance);
58         for(uint i=0; i<queue.length; i++){
59             uint idx = currentReceiverIndex + i;
60             Deposit storage dep = queue[idx]; 
61             if(money >= dep.expect){  
62                 dep.depositor.send(dep.expect); 
63                 money -= dep.expect;            
64                 delete queue[idx];
65             }else{
66                 dep.depositor.send(money); 
67                 dep.expect -= money;       
68                 break;                    
69             }
70             if(gasleft() <= 50000)         
71                 break;                     
72         }
73         currentReceiverIndex += i; 
74     }
75 
76     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
77         Deposit storage dep = queue[idx];
78         return (dep.depositor, dep.deposit, dep.expect);
79     }
80 
81     function getDepositsCount(address depositor) public view returns (uint) {
82         uint c = 0;
83         for(uint i=currentReceiverIndex; i<queue.length; ++i){
84             if(queue[i].depositor == depositor)
85                 c++;
86         }
87         return c;
88     }
89 
90     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
91         uint c = getDepositsCount(depositor);
92 
93         idxs = new uint[](c);
94         deposits = new uint128[](c);
95         expects = new uint128[](c);
96 
97         if(c > 0) {
98             uint j = 0;
99             for(uint i=currentReceiverIndex; i<queue.length; ++i){
100                 Deposit storage dep = queue[i];
101                 if(dep.depositor == depositor){
102                     idxs[j] = i;
103                     deposits[j] = dep.deposit;
104                     expects[j] = dep.expect;
105                     j++;
106                 }
107             }
108         }
109     }
110 
111     function getQueueLength() public view returns (uint) {
112         return queue.length - currentReceiverIndex;
113     }
114 
115 }