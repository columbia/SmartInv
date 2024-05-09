1 pragma solidity ^0.4.18;
2 
3 //      (`)
4 //     / /
5 //    / /
6 //   / /
7 //  (_)_)
8 
9 
10 // similar to ShrimpFarmer, with three changes:
11 // 1. one third of your sperm die when you sell your cells
12 // 2. the ownership of the devfee can transfer through sacrificing sperm
13 //  a. the new requirement will be how many remaining sperm you have after the sacrifice
14 //  b. you cannot sacrifice sperm if you are the spermlord
15 // 3. the "free" 500 sperm cost 0.001 eth (in line with the mining fee)
16 // bots should have a harder time, and whales can compete for the devfee
17 
18 contract SpermLabsReborn {
19 
20     uint256 public CELLS_TO_MAKE_1_SPERM = 86400;
21     uint256 public STARTING_SPERM = 500;
22     uint256 PSN = 10000;
23     uint256 PSNH = 5000;
24     bool public initialized = false;
25     address public spermlordAddress;
26     uint256 public spermlordReq = 500000; // starts at 500k sperm
27     mapping (address => uint256) public ballSperm;
28     mapping (address => uint256) public claimedCells;
29     mapping (address => uint256) public lastEvent;
30     mapping (address => address) public referrals;
31     uint256 public marketCells;
32 
33     function SpermLabsReborn() public {
34         spermlordAddress = msg.sender;
35     }
36 
37     function makeSperm(address ref) public {
38         require(initialized);
39 
40         if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
41             referrals[msg.sender] = ref;
42         }
43 
44         uint256 cellsUsed = getMyCells();
45         uint256 newSperm = SafeMath.div(cellsUsed, CELLS_TO_MAKE_1_SPERM);
46         ballSperm[msg.sender] = SafeMath.add(ballSperm[msg.sender], newSperm);
47         claimedCells[msg.sender] = 0;
48         lastEvent[msg.sender] = now;
49         
50         // send referral cells
51         claimedCells[referrals[msg.sender]] = SafeMath.add(claimedCells[referrals[msg.sender]], SafeMath.div(cellsUsed, 5)); // +20%
52         
53         // boost market to prevent sprem hoarding
54         marketCells = SafeMath.add(marketCells, SafeMath.div(cellsUsed, 10)); // +10%
55     }
56 
57     function sellCells() public {
58         require(initialized);
59 
60         uint256 cellCount = getMyCells();
61         uint256 cellValue = calculateCellSell(cellCount);
62         uint256 fee = devFee(cellValue);
63         
64         // one third of your sperm die :'(
65         ballSperm[msg.sender] = SafeMath.mul(SafeMath.div(ballSperm[msg.sender], 3), 2); // =66%
66         claimedCells[msg.sender] = 0;
67         lastEvent[msg.sender] = now;
68 
69         // put them on the market
70         marketCells = SafeMath.add(marketCells, cellCount);
71 
72         // ALL HAIL THE SPERMLORD!
73         spermlordAddress.transfer(fee);
74         msg.sender.transfer(SafeMath.sub(cellValue, fee));
75     }
76 
77     function buyCells() public payable {
78         require(initialized);
79 
80         uint256 cellsBought = calculateCellBuy(msg.value, SafeMath.sub(this.balance, msg.value));
81         cellsBought = SafeMath.sub(cellsBought, devFee(cellsBought));
82         claimedCells[msg.sender] = SafeMath.add(claimedCells[msg.sender], cellsBought);
83 
84         // ALL HAIL THE SPERMLORD!
85         spermlordAddress.transfer(devFee(msg.value));
86     }
87 
88     // magic trade balancing algorithm
89     function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {
90         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
91         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
92     }
93 
94     function calculateCellSell(uint256 cells) public view returns(uint256) {
95         return calculateTrade(cells, marketCells, this.balance);
96     }
97 
98     function calculateCellBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
99         return calculateTrade(eth, contractBalance, marketCells);
100     }
101 
102     function calculateCellBuySimple(uint256 eth) public view returns(uint256) {
103         return calculateCellBuy(eth, this.balance);
104     }
105 
106     function devFee(uint256 amount) public view returns(uint256) {
107         return SafeMath.div(SafeMath.mul(amount, 4), 100); // 4%
108     }
109 
110     function seedMarket(uint256 cells) public payable {
111         require(marketCells == 0);
112 
113         initialized = true;
114         marketCells = cells;
115     }
116 
117     function getFreeSperm() public payable {
118         require(initialized);
119         require(msg.value == 0.001 ether); // similar to mining fee, prevents bots
120         spermlordAddress.transfer(msg.value); // the spermlord gets the entry fee ;)
121 
122         require(ballSperm[msg.sender] == 0);
123         lastEvent[msg.sender] = now;
124         ballSperm[msg.sender] = STARTING_SPERM;
125     }
126 
127     function getBalance() public view returns(uint256) {
128         return this.balance;
129     }
130 
131     function getMySperm() public view returns(uint256) {
132         return ballSperm[msg.sender];
133     }
134 
135     function becomeSpermlord() public {
136         require(initialized);
137         require(msg.sender != spermlordAddress);
138         require(ballSperm[msg.sender] >= spermlordReq);
139 
140         ballSperm[msg.sender] = SafeMath.sub(ballSperm[msg.sender], spermlordReq);
141         spermlordReq = ballSperm[msg.sender]; // the requirement now becomes the balance at that time
142         spermlordAddress = msg.sender;
143     }
144 
145     function getSpermlordReq() public view returns(uint256) {
146         return spermlordReq;
147     }
148 
149     function getMyCells() public view returns(uint256) {
150         return SafeMath.add(claimedCells[msg.sender], getCellsSinceLastEvent(msg.sender));
151     }
152 
153     function getCellsSinceLastEvent(address adr) public view returns(uint256) {
154         uint256 secondsPassed = min(CELLS_TO_MAKE_1_SPERM, SafeMath.sub(now, lastEvent[adr]));
155         return SafeMath.mul(secondsPassed, ballSperm[adr]);
156     }
157 
158     function min(uint256 a, uint256 b) private pure returns (uint256) {
159         return a < b ? a : b;
160     }
161 }
162 
163 library SafeMath {
164 
165   /**
166   * @dev Multiplies two numbers, throws on overflow.
167   */
168   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169     if (a == 0) {
170       return 0;
171     }
172     uint256 c = a * b;
173     assert(c / a == b);
174     return c;
175   }
176 
177   /**
178   * @dev Integer division of two numbers, truncating the quotient.
179   */
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return c;
185   }
186 
187   /**
188   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     assert(b <= a);
192     return a - b;
193   }
194 
195   /**
196   * @dev Adds two numbers, throws on overflow.
197   */
198   function add(uint256 a, uint256 b) internal pure returns (uint256) {
199     uint256 c = a + b;
200     assert(c >= a);
201     return c;
202   }
203 }