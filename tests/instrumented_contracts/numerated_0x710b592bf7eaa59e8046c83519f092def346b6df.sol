1 pragma solidity ^0.4.22;
2 
3 contract Roulette {
4   
5   uint betAmount;
6   uint necessaryBalance;
7   uint nextRoundTimestamp;
8   address creator;
9   uint256 maxAmountAllowedInTheBank;
10   mapping (address => uint256) winnings;
11   uint8[] payouts;
12   uint8[] numberRange;
13   
14   /*
15     BetTypes are as follow:
16       0: color
17       1: column
18       2: dozen
19       3: eighteen
20       4: modulus
21       5: number
22       
23     Depending on the BetType, number will be:
24       color: 0 for black, 1 for red
25       column: 0 for left, 1 for middle, 2 for right
26       dozen: 0 for first, 1 for second, 2 for third
27       eighteen: 0 for low, 1 for high
28       modulus: 0 for even, 1 for odd
29       number: number
30   */
31   
32   struct Bet {
33     address player;
34     uint8 betType;
35     uint8 number;
36   }
37   Bet[] public bets;
38   
39   constructor() public payable {
40     creator = msg.sender;
41     necessaryBalance = 0;
42     nextRoundTimestamp = now;
43     payouts = [2,3,3,2,2,36];
44     numberRange = [1,2,2,1,1,36];
45     betAmount = 50000000000000000; /* 0.05 ether */
46     maxAmountAllowedInTheBank = 2000000000000000000; /* 2 ether */
47   }
48 
49   event RandomNumber(uint256 number);
50   
51   function getStatus() public view returns(uint, uint, uint, uint, uint) {
52     return (
53       bets.length,             // number of active bets
54       bets.length * betAmount, // value of active bets
55       nextRoundTimestamp,      // when can we play again
56       address(this).balance,   // roulette balance
57       winnings[msg.sender]     // winnings of player
58     ); 
59   }
60     
61   function addEther() payable public {}
62 
63   function bet(uint8 number, uint8 betType) payable public {
64     /* 
65        A bet is valid when:
66        1 - the value of the bet is correct (=betAmount)
67        2 - betType is known (between 0 and 5)
68        3 - the option betted is valid (don't bet on 37!)
69        4 - the bank has sufficient funds to pay the bet
70     */
71     require(msg.value == betAmount);                               // 1
72     require(betType >= 0 && betType <= 5);                         // 2
73     require(number >= 0 && number <= numberRange[betType]);        // 3
74     uint payoutForThisBet = payouts[betType] * msg.value;
75     uint provisionalBalance = necessaryBalance + payoutForThisBet;
76     require(provisionalBalance < address(this).balance);           // 4
77     /* we are good to go */
78     necessaryBalance += payoutForThisBet;
79     bets.push(Bet({
80       betType: betType,
81       player: msg.sender,
82       number: number
83     }));
84   }
85 
86   function spinWheel() public {
87     /* are there any bets? */
88     require(bets.length > 0);
89     /* are we allowed to spin the wheel? */
90     require(now > nextRoundTimestamp);
91     /* next time we are allowed to spin the wheel again */
92     nextRoundTimestamp = now;
93     /* calculate 'random' number */
94     uint diff = block.difficulty;
95     bytes32 hash = blockhash(block.number-1);
96     Bet memory lb = bets[bets.length-1];
97     uint number = uint(keccak256(abi.encodePacked(now, diff, hash, lb.betType, lb.player, lb.number))) % 37;
98     /* check every bet for this number */
99     for (uint i = 0; i < bets.length; i++) {
100       bool won = false;
101       Bet memory b = bets[i];
102       if (number == 0) {
103         won = (b.betType == 5 && b.number == 0);                   /* bet on 0 */
104       } else {
105         if (b.betType == 5) { 
106           won = (b.number == number);                              /* bet on number */
107         } else if (b.betType == 4) {
108           if (b.number == 0) won = (number % 2 == 0);              /* bet on even */
109           if (b.number == 1) won = (number % 2 == 1);              /* bet on odd */
110         } else if (b.betType == 3) {            
111           if (b.number == 0) won = (number <= 18);                 /* bet on low 18s */
112           if (b.number == 1) won = (number >= 19);                 /* bet on high 18s */
113         } else if (b.betType == 2) {                               
114           if (b.number == 0) won = (number <= 12);                 /* bet on 1st dozen */
115           if (b.number == 1) won = (number > 12 && number <= 24);  /* bet on 2nd dozen */
116           if (b.number == 2) won = (number > 24);                  /* bet on 3rd dozen */
117         } else if (b.betType == 1) {               
118           if (b.number == 0) won = (number % 3 == 1);              /* bet on left column */
119           if (b.number == 1) won = (number % 3 == 2);              /* bet on middle column */
120           if (b.number == 2) won = (number % 3 == 0);              /* bet on right column */
121         } else if (b.betType == 0) {
122           if (b.number == 0) {                                     /* bet on black */
123             if (number <= 10 || (number >= 20 && number <= 28)) {
124               won = (number % 2 == 0);
125             } else {
126               won = (number % 2 == 1);
127             }
128           } else {                                                 /* bet on red */
129             if (number <= 10 || (number >= 20 && number <= 28)) {
130               won = (number % 2 == 1);
131             } else {
132               won = (number % 2 == 0);
133             }
134           }
135         }
136       }
137       /* if winning bet, add to player winnings balance */
138       if (won) {
139         winnings[b.player] += betAmount * payouts[b.betType];
140       }
141     }
142     /* delete all bets */
143     bets.length = 0;
144     /* reset necessaryBalance */
145     necessaryBalance = 0;
146     /* check if to much money in the bank */
147     if (address(this).balance > maxAmountAllowedInTheBank) takeProfits();
148     /* returns 'random' number to UI */
149     emit RandomNumber(number);
150   }
151   
152   function cashOut() public {
153     address player = msg.sender;
154     uint256 amount = winnings[player];
155     require(amount > 0);
156     require(amount <= address(this).balance);
157     winnings[player] = 0;
158     player.transfer(amount);
159   }
160   
161   function takeProfits() internal {
162     uint amount = address(this).balance - maxAmountAllowedInTheBank;
163     if (amount > 0) creator.transfer(amount);
164   }
165   
166   function creatorKill() public {
167     require(msg.sender == creator);
168     selfdestruct(creator);
169   }
170  
171 }