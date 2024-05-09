1 pragma solidity ^0.4.0;
2 
3 
4 // "Proof of Commitment" fun pre-launch competition for Goo!
5 
6 //  Goo is an addictive freemium game but you can get ahead of
7 //  other players (and earn more divs) by playing with eth
8 
9 //  Full details and game smart contract will shortly be able:
10 //  ~~ https://ethergoo.io ~~
11 
12 //  This contest will award some of the keen Goo players
13 //  and those looking to refer can also free win prizes too!
14 
15 
16 //  ALL ETHER DEPOSITED INTO THIS PROMO CAN BE WITHDRAWN BY PLAYER AT ANY
17 //  TIME BUT PRIZES WILL BE DRAWN: FRIDAY 30TH MARCH (LAUNCH)
18 //  AT WHICH POINT ALL ETHER WILL ALSO BE REFUNDED TO PLAYERS
19 
20 
21 //  PRIZES:
22 //  0.5 ether (top eth deposit)
23 //  0.3 ether (1 random deposit)
24 //  0.2 ether (1 random deposit)
25 //  +3 prizes of 0.25, 0.2, & 0.15 for most referals (which will awarded off-contract) as winners manually checked there was no bot/abuse
26 
27 
28 contract GooLaunchPromotion {
29     
30     // First Goo Players!
31     mapping(address => uint256) public deposits;
32     mapping(address => bool) depositorAlreadyStored;
33     address[] public depositors;
34     
35     // Referers contest
36     mapping(address => address[]) refererals;
37     mapping(address => bool) refererAlreadyStored;
38     address[] public uniqueReferers;
39     
40     // To trigger contest end only
41     address public ownerAddress;
42     
43     // Flag so can only be awarded once
44     bool public prizesAwarded;
45     
46     // Ether to be returned to depositor on launch
47     uint256 public constant LAUNCH_DATE = 1522436400; // Friday, 30 March 2018 19:00:00 (seconds)
48     
49     // Proof of Commitment contest prizes
50     uint256 private constant TOP_DEPOSIT_PRIZE = 0.5 ether;
51     uint256 private constant RANDOM_DEPOSIT_PRIZE1 = 0.3 ether;
52     uint256 private constant RANDOM_DEPOSIT_PRIZE2 = 0.2 ether;
53     
54     function GooLaunchPromotion() public payable {
55         require(msg.value == 1 ether); // Owner must provide enough for prizes
56         ownerAddress = msg.sender;
57     }
58     
59     
60     function deposit(address referer) external payable {
61         uint256 existing = deposits[msg.sender];
62         
63         // Safely store the ether sent
64         deposits[msg.sender] = SafeMath.add(msg.value, existing);
65         
66         // Finally store contest details
67         if (msg.value >= 0.01 ether && !depositorAlreadyStored[msg.sender]) {
68             depositors.push(msg.sender);
69             depositorAlreadyStored[msg.sender] = true;
70             
71             // Credit referal
72             if (referer != address(0) && referer != msg.sender) {
73                 refererals[referer].push(msg.sender);
74                 if (!refererAlreadyStored[referer]) {
75                     refererAlreadyStored[referer] = true;
76                     uniqueReferers.push(referer);
77                 }
78             }
79         }
80     }
81     
82     function refund() external {
83         // Safely transfer players deposit back
84         uint256 depositAmount = deposits[msg.sender];
85         deposits[msg.sender] = 0; // Can't withdraw twice obviously
86         msg.sender.transfer(depositAmount);
87     }
88     
89     
90     function refundPlayer(address depositor) external {
91         require(msg.sender == ownerAddress);
92         
93         // Safely transfer back to player
94         uint256 depositAmount = deposits[depositor];
95         deposits[depositor] = 0; // Can't withdraw twice obviously
96         
97         // Sends back to correct depositor
98         depositor.transfer(depositAmount);
99     }
100     
101     
102     function awardPrizes() external {
103         require(msg.sender == ownerAddress);
104         require(now >= LAUNCH_DATE);
105         require(!prizesAwarded);
106         
107         // Ensure only ran once
108         prizesAwarded = true;
109         
110         uint256 highestDeposit;
111         address highestDepositWinner;
112         
113         for (uint256 i = 0; i < depositors.length; i++) {
114             address depositor = depositors[i];
115             
116             // No tie allowed!
117             if (deposits[depositor] > highestDeposit) {
118                 highestDeposit = deposits[depositor];
119                 highestDepositWinner = depositor;
120             }
121         }
122         
123         uint256 numContestants = depositors.length;
124         uint256 seed1 = numContestants + block.timestamp;
125         uint256 seed2 = seed1 + uniqueReferers.length;
126         
127         address randomDepositWinner1 = depositors[randomContestant(numContestants, seed1)];
128         address randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];
129         
130         // Just incase
131         while(randomDepositWinner2 == randomDepositWinner1) {
132             seed2++;
133             randomDepositWinner2 = depositors[randomContestant(numContestants, seed2)];
134         }
135         
136         highestDepositWinner.transfer(TOP_DEPOSIT_PRIZE);
137         randomDepositWinner1.transfer(RANDOM_DEPOSIT_PRIZE1);
138         randomDepositWinner2.transfer(RANDOM_DEPOSIT_PRIZE2);
139     }
140     
141     
142     // Random enough for small contest
143     function randomContestant(uint256 contestants, uint256 seed) constant internal returns (uint256 result){
144         return addmod(uint256(block.blockhash(block.number-1)), seed, contestants);   
145     }
146     
147     
148     function myReferrals() external constant returns (address[]) {
149         return refererals[msg.sender];
150     }
151     
152 }
153 
154 library SafeMath {
155 
156   /**
157   * @dev Multiplies two numbers, throws on overflow.
158   */
159   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160     if (a == 0) {
161       return 0;
162     }
163     uint256 c = a * b;
164     assert(c / a == b);
165     return c;
166   }
167 
168   /**
169   * @dev Integer division of two numbers, truncating the quotient.
170   */
171   function div(uint256 a, uint256 b) internal pure returns (uint256) {
172     // assert(b > 0); // Solidity automatically throws when dividing by 0
173     uint256 c = a / b;
174     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175     return c;
176   }
177 
178   /**
179   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
180   */
181   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182     assert(b <= a);
183     return a - b;
184   }
185 
186   /**
187   * @dev Adds two numbers, throws on overflow.
188   */
189   function add(uint256 a, uint256 b) internal pure returns (uint256) {
190     uint256 c = a + b;
191     assert(c >= a);
192     return c;
193   }
194 }