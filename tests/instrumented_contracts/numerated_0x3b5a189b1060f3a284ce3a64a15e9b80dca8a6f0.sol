1 pragma solidity ^0.4.19;
2 
3 
4 // "Proof of Commitment" fun pre-launch competition for NBAOnline!
5 
6 //  Full details and game smart contract will shortly be able:
7 //  ~~ https://nbaonline.io ~~
8 
9 //  This contest will award some of the keen NBAOnline players
10 
11 //  ALL ETHER DEPOSITED INTO THIS PROMO CAN BE WITHDRAWN BY PLAYER AT ANY
12 //  TIME BUT PRIZES WILL BE DRAWN: SATURDAY 14TH APRIL (LAUNCH)
13 //  AT WHICH POINT ALL ETHER WILL ALSO BE REFUNDED TO PLAYERS
14 
15 
16 //  PRIZES:
17 //  0.5 ether (top eth deposit)
18 //  0.35 ether (1 random deposit)
19 //  0.15 ether (1 random deposit)
20 
21 contract NBAOnlineLaunchPromotion {
22     
23     // First Goo Players!
24     mapping(address => uint256) public deposits;
25     mapping(address => bool) depositorAlreadyStored;
26     address[] public depositors;
27 
28     // To trigger contest end only
29     address public ownerAddress;
30     
31     // Flag so can only be awarded once
32     bool public prizesAwarded = false;
33     
34     // Ether to be returned to depositor on launch
35 	// 1day = 86400
36     uint256 public constant LAUNCH_DATE = 1523678400; // Saturday, 14 April 2018 00:00:00 (seconds) ET
37     
38     // Proof of Commitment contest prizes
39     uint256 private constant TOP_DEPOSIT_PRIZE = 0.5 ether;
40     uint256 private constant RANDOM_DEPOSIT_PRIZE1 = 0.35 ether;
41     uint256 private constant RANDOM_DEPOSIT_PRIZE2 = 0.15 ether;
42     
43     function NBAOnlineLaunchPromotion() public payable {
44         require(msg.value == 1 ether); // Owner must provide enough for prizes
45         ownerAddress = msg.sender;
46     }
47     
48     
49     function deposit() external payable {
50         uint256 existing = deposits[msg.sender];
51         
52         // Safely store the ether sent
53         deposits[msg.sender] = SafeMath.add(msg.value, existing);
54         
55         // Finally store contest details
56         if (msg.value >= 0.01 ether && !depositorAlreadyStored[msg.sender]) {
57             depositors.push(msg.sender);
58             depositorAlreadyStored[msg.sender] = true;
59         }
60     }
61     
62     function refund() external {
63         // Safely transfer players deposit back
64         uint256 depositAmount = deposits[msg.sender];
65         deposits[msg.sender] = 0; // Can't withdraw twice obviously
66         msg.sender.transfer(depositAmount);
67     }
68     
69     
70     function refundPlayer(address depositor) external {
71         require(msg.sender == ownerAddress);
72         
73         // Safely transfer back to player
74         uint256 depositAmount = deposits[depositor];
75         deposits[depositor] = 0; // Can't withdraw twice obviously
76         
77         // Sends back to correct depositor
78         depositor.transfer(depositAmount);
79     }
80     
81     
82     function awardPrizes() external {
83         require(msg.sender == ownerAddress);
84         require(now >= LAUNCH_DATE);
85         require(!prizesAwarded);
86         
87         // Ensure only ran once
88         prizesAwarded = true;
89         
90         uint256 highestDeposit;
91         address highestDepositWinner;
92         
93         for (uint256 i = 0; i < depositors.length; i++) {
94             address depositor = depositors[i];
95             
96             // No tie allowed!
97             if (deposits[depositor] > highestDeposit) {
98                 highestDeposit = deposits[depositor];
99                 highestDepositWinner = depositor;
100             }
101         }
102         
103         uint256 numContestants = depositors.length;
104         uint256 seed1 = numContestants + block.timestamp;
105         uint256 seed2 = seed1 + (numContestants*2);
106         
107         address randomDepositWinner1 = depositors[randomContestant(numContestants, seed1)];
108         address randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];
109         
110         // Just incase
111         while(randomDepositWinner2 == randomDepositWinner1) {
112             seed2++;
113             randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];
114         }
115         
116         highestDepositWinner.transfer(TOP_DEPOSIT_PRIZE);
117         randomDepositWinner1.transfer(RANDOM_DEPOSIT_PRIZE1);
118         randomDepositWinner2.transfer(RANDOM_DEPOSIT_PRIZE2);
119     }
120     
121     
122     // Random enough for small contest
123     function randomContestant(uint256 contestants, uint256 seed) constant internal returns (uint256 result){
124         return addmod(uint256(block.blockhash(block.number-1)), seed, contestants);   
125     }
126 }
127 
128 library SafeMath {
129 
130   /**
131   * @dev Multiplies two numbers, throws on overflow.
132   */
133   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134     if (a == 0) {
135       return 0;
136     }
137     uint256 c = a * b;
138     assert(c / a == b);
139     return c;
140   }
141 
142   /**
143   * @dev Integer division of two numbers, truncating the quotient.
144   */
145   function div(uint256 a, uint256 b) internal pure returns (uint256) {
146     // assert(b > 0); // Solidity automatically throws when dividing by 0
147     uint256 c = a / b;
148     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149     return c;
150   }
151 
152   /**
153   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
154   */
155   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156     assert(b <= a);
157     return a - b;
158   }
159 
160   /**
161   * @dev Adds two numbers, throws on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     assert(c >= a);
166     return c;
167   }
168 }