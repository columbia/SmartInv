1 pragma solidity ^0.4.25;
2 
3 /**
4   EN: Telegram channel https://t.me/formula1game
5    
6    FORMULA 1 Game - is a daily entertaining BLOCKCHAIN game 
7    with the possibility of earning an ETHEREUM
8    cryptocurrency for each lap.
9    
10    JACKPOT is played in every race
11    MEGAJACKPOT once a week or by voting
12    ____________________________________________________________
13    
14    RU: Телеграм канал https://t.me/formula1game
15    
16    FORMULA 1 Game - это ежедневная развлекательная БЛОКЧЕЙН игра 
17    с возможностью заработка криптовалюты ETHEREUM
18    за каждый пройденный круг.
19    
20    ДЖЕКПОТ разыгрывается в каждом заезде
21    МЕГАДЖЕКПОТ раз в неделю или по голосованию
22 */
23 
24 contract Formula1Game {
25     address constant private PROMO1 = 0x51A2BF880F4db7713E95498833308ffE4D61d080;
26 	address constant private PROMO2 = 0x1e8f7BD53c898625cDc2416ae5f1c446A16dd8D9;
27 	address constant private TECH = 0x36413D58cA47520575889EE3E02E7Bb508b3D1E8;
28     uint constant public PROMO_PERCENT1 = 1;
29 	uint constant public PROMO_PERCENT2 = 1;
30 	uint constant public TECH_PERCENT = 1;
31     uint constant public MULTIPLIER = 110; 
32     
33     struct Deposit {
34         address depositor; 
35         uint128 deposit;  
36         uint128 expect;   
37     }
38 
39     Deposit[] private queue;
40     uint public currentReceiverIndex = 0;
41 
42     function () public payable {
43         if(msg.value > 0){
44             require(gasleft() >= 220000, "We require more gas!"); 
45             require(msg.value >= 0.001 ether && msg.value <= 0.002 ether); 
46             
47             queue.push(Deposit(msg.sender, uint128(msg.value), uint128(msg.value*MULTIPLIER/100)));
48             uint promo1 = msg.value*PROMO_PERCENT1/100;
49             PROMO1.send(promo1);
50 			uint promo2 = msg.value*PROMO_PERCENT2/100;
51             PROMO2.send(promo2);
52 			uint tech = msg.value*TECH_PERCENT/100;
53             TECH.send(tech);
54             pay();
55         }
56     }
57 
58     function pay() private {
59         uint128 money = uint128(address(this).balance);
60         for(uint i=0; i<queue.length; i++){
61             uint idx = currentReceiverIndex + i;
62             Deposit storage dep = queue[idx]; 
63             if(money >= dep.expect){  
64                 dep.depositor.send(dep.expect); 
65                 money -= dep.expect;            
66                 delete queue[idx];
67             }else{
68                 dep.depositor.send(money); 
69                 dep.expect -= money;       
70                 break;                    
71             }
72             if(gasleft() <= 50000)         
73                 break;                     
74         }
75         currentReceiverIndex += i; 
76     }
77 
78     function getDeposit(uint idx) public view returns (address depositor, uint deposit, uint expect){
79         Deposit storage dep = queue[idx];
80         return (dep.depositor, dep.deposit, dep.expect);
81     }
82 
83     function getDepositsCount(address depositor) public view returns (uint) {
84         uint c = 0;
85         for(uint i=currentReceiverIndex; i<queue.length; ++i){
86             if(queue[i].depositor == depositor)
87                 c++;
88         }
89         return c;
90     }
91 
92     function getDeposits(address depositor) public view returns (uint[] idxs, uint128[] deposits, uint128[] expects) {
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
113     function getQueueLength() public view returns (uint) {
114         return queue.length - currentReceiverIndex;
115     }
116 
117 }