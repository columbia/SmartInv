1 pragma solidity ^0.4.18;
2 
3 // similar to ShrimpFarmer, with three changes:
4 // 1. one third of your sperm die when you sell your cells
5 // 2. the ownership of the devfee can transfer through sacrificing sperm
6 //  a. the new requirement will be how many remaining sperm you have after the sacrifice
7 //  b. you cannot sacrifice sperm if you are the spermlord
8 // 3. the "free" 500 sperm cost 0.001 eth (in line with the mining fee)
9 
10 // bots should have a harder time, and whales can compete for the devfee
11 
12 contract EtherSpermBank {
13 
14     uint256 public CELLS_TO_MAKE_1_SPERM = 86400;
15     uint256 public STARTING_SPERM = 500;
16     uint256 PSN = 10000;
17     uint256 PSNH = 5000;
18     bool public initialized = false;
19     address public spermlordAddress;
20     uint256 public spermlordReq = 500000; // starts at 500k sperm
21     mapping (address => uint256) public ballSperm;
22     mapping (address => uint256) public claimedCells;
23     mapping (address => uint256) public lastEvent;
24     mapping (address => address) public referrals;
25     uint256 public marketCells;
26 
27     function EtherSpermBank() public {
28         spermlordAddress = msg.sender;
29     }
30 
31     function makeSperm(address ref) public {
32         require(initialized);
33 
34         if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
35             referrals[msg.sender] = ref;
36         }
37 
38         uint256 cellsUsed = getMyCells();
39         uint256 newSperm = SafeMath.div(cellsUsed, CELLS_TO_MAKE_1_SPERM);
40         ballSperm[msg.sender] = SafeMath.add(ballSperm[msg.sender], newSperm);
41         claimedCells[msg.sender] = 0;
42         lastEvent[msg.sender] = now;
43         
44         // send referral cells
45         claimedCells[referrals[msg.sender]] = SafeMath.add(claimedCells[referrals[msg.sender]], SafeMath.div(cellsUsed, 5)); // +20%
46         
47         // boost market to prevent sprem hoarding
48         marketCells = SafeMath.add(marketCells, SafeMath.div(cellsUsed, 10)); // +10%
49     }
50 
51     function sellCells() public {
52         require(initialized);
53 
54         uint256 cellCount = getMyCells();
55         uint256 cellValue = calculateCellSell(cellCount);
56         uint256 fee = devFee(cellValue);
57         
58         // one third of your sperm die :'(
59         ballSperm[msg.sender] = SafeMath.mul(SafeMath.div(ballSperm[msg.sender], 3), 2); // =66%
60         claimedCells[msg.sender] = 0;
61         lastEvent[msg.sender] = now;
62 
63         // put them on the market
64         marketCells = SafeMath.add(marketCells, cellCount);
65 
66         // ALL HAIL THE SPERMLORD!
67         spermlordAddress.transfer(fee);
68         msg.sender.transfer(SafeMath.sub(cellValue, fee));
69     }
70 
71     function buyCells() public payable {
72         require(initialized);
73 
74         uint256 cellsBought = calculateCellBuy(msg.value, SafeMath.sub(this.balance, msg.value));
75         cellsBought = SafeMath.sub(cellsBought, devFee(cellsBought));
76         claimedCells[msg.sender] = SafeMath.add(claimedCells[msg.sender], cellsBought);
77 
78         // ALL HAIL THE SPERMLORD!
79         spermlordAddress.transfer(devFee(msg.value));
80     }
81 
82     // magic trade balancing algorithm
83     function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {
84         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
85         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
86     }
87 
88     function calculateCellSell(uint256 cells) public view returns(uint256) {
89         return calculateTrade(cells, marketCells, this.balance);
90     }
91 
92     function calculateCellBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
93         return calculateTrade(eth, contractBalance, marketCells);
94     }
95 
96     function calculateCellBuySimple(uint256 eth) public view returns(uint256) {
97         return calculateCellBuy(eth, this.balance);
98     }
99 
100     function devFee(uint256 amount) public view returns(uint256) {
101         return SafeMath.div(SafeMath.mul(amount, 4), 100); // 4%
102     }
103 
104     function seedMarket(uint256 cells) public payable {
105         require(marketCells == 0);
106 
107         initialized = true;
108         marketCells = cells;
109     }
110 
111     function getFreeSperm() public payable {
112         require(initialized);
113         require(msg.value == 0.001 ether); // similar to mining fee, prevents bots
114         spermlordAddress.transfer(msg.value); // the spermlord gets the entry fee ;)
115 
116         require(ballSperm[msg.sender] == 0);
117         lastEvent[msg.sender] = now;
118         ballSperm[msg.sender] = STARTING_SPERM;
119     }
120 
121     function getBalance() public view returns(uint256) {
122         return this.balance;
123     }
124 
125     function getMySperm() public view returns(uint256) {
126         return ballSperm[msg.sender];
127     }
128 
129     function becomeSpermlord() public {
130         require(initialized);
131         require(msg.sender != spermlordAddress);
132         require(ballSperm[msg.sender] >= spermlordReq);
133 
134         ballSperm[msg.sender] = SafeMath.sub(ballSperm[msg.sender], spermlordReq);
135         spermlordReq = ballSperm[msg.sender]; // the requirement now becomes the balance at that time
136         spermlordAddress = msg.sender;
137     }
138 
139     function getSpermlordReq() public view returns(uint256) {
140         return spermlordReq;
141     }
142 
143     function getMyCells() public view returns(uint256) {
144         return SafeMath.add(claimedCells[msg.sender], getCellsSinceLastEvent(msg.sender));
145     }
146 
147     function getCellsSinceLastEvent(address adr) public view returns(uint256) {
148         uint256 secondsPassed = min(CELLS_TO_MAKE_1_SPERM, SafeMath.sub(now, lastEvent[adr]));
149         return SafeMath.mul(secondsPassed, ballSperm[adr]);
150     }
151 
152     function min(uint256 a, uint256 b) private pure returns (uint256) {
153         return a < b ? a : b;
154     }
155 }
156 
157 library SafeMath {
158 
159   /**
160   * @dev Multiplies two numbers, throws on overflow.
161   */
162   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163     if (a == 0) {
164       return 0;
165     }
166     uint256 c = a * b;
167     assert(c / a == b);
168     return c;
169   }
170 
171   /**
172   * @dev Integer division of two numbers, truncating the quotient.
173   */
174   function div(uint256 a, uint256 b) internal pure returns (uint256) {
175     // assert(b > 0); // Solidity automatically throws when dividing by 0
176     uint256 c = a / b;
177     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178     return c;
179   }
180 
181   /**
182   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
183   */
184   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185     assert(b <= a);
186     return a - b;
187   }
188 
189   /**
190   * @dev Adds two numbers, throws on overflow.
191   */
192   function add(uint256 a, uint256 b) internal pure returns (uint256) {
193     uint256 c = a + b;
194     assert(c >= a);
195     return c;
196   }
197 }