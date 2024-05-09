1 pragma solidity ^0.4.23;
2 
3 /*
4 
5 
6     (   )
7   (   ) (
8    ) _   )
9     ( \_
10   _(_\ \)__
11  (____\___)) 
12  
13  
14 */
15 
16 
17 // similar to ShrimpFarmer, with eight changes:
18 // 1. one third of your ShitClones die when you sell your time
19 // 2. the ownership of the devfee can transfer through sacrificing ShitClones
20 //  a. the new requirement will be how many remaining ShitClones you have after the sacrifice
21 //  b. you cannot sacrifice ShitClones if you are the ShitClonesLord
22 // 3. the "free" 500 ShitClones cost 0.001 eth (in line with the mining fee)
23 // bots should have a harder time, and whales can compete for the devfee
24 // 4. UI is for peasants, this is mew sniper territory. Step away to a safe distance.
25 // 5. I made some changes to the contract that might have fucked it, or not.
26 // https://bit.ly/2xc8v53
27 // 6. Join our discord @ https://discord.gg/RbgqjPd
28 // 7. Let's stop creating these and move on. M'kay?
29 // 8. Drops the mic.
30 
31 contract ShitCloneFarmer {
32 
33     uint256 public TIME_TO_MAKE_1_SHITCLONE = 86400;
34     uint256 public STARTING_SHITCLONE = 100;
35     uint256 PSN = 10000;
36     uint256 PSNH = 5000;
37     bool public initialized = true;
38     address public ShitCloneslordAddress;
39     uint256 public ShitCloneslordReq = 500000; // starts at 500k ShitClones
40     mapping (address => uint256) public ballShitClone;
41     mapping (address => uint256) public claimedTime;
42     mapping (address => uint256) public lastEvent;
43     mapping (address => address) public referrals;
44     uint256 public marketTime;
45 
46     function ShitCloneFarmer() public {
47         ShitCloneslordAddress = msg.sender;
48     }
49 
50     function makeShitClone(address ref) public {
51         require(initialized);
52 
53         if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
54             referrals[msg.sender] = ref;
55         }
56 
57         uint256 timeUsed = getMyTime();
58         uint256 newShitClone = SafeMath.div(timeUsed, TIME_TO_MAKE_1_SHITCLONE);
59         ballShitClone[msg.sender] = SafeMath.add(ballShitClone[msg.sender], newShitClone);
60         claimedTime[msg.sender] = 0;
61         lastEvent[msg.sender] = now;
62         
63         // send referral time
64         claimedTime[referrals[msg.sender]] = SafeMath.add(claimedTime[referrals[msg.sender]], SafeMath.div(timeUsed, 5)); // +20%
65         
66         // boost market to prevent sprem hoarding
67         marketTime = SafeMath.add(marketTime, SafeMath.div(timeUsed, 10)); // +10%
68     }
69 
70     function sellShitClones() public {
71         require(initialized);
72 
73         uint256 cellCount = getMyTime();
74         uint256 cellValue = calculateCellSell(cellCount);
75         uint256 fee = devFee(cellValue);
76         
77         // one third of your ShitClones die :'(
78         ballShitClone[msg.sender] = SafeMath.mul(SafeMath.div(ballShitClone[msg.sender], 3), 2); // =66%
79         claimedTime[msg.sender] = 0;
80         lastEvent[msg.sender] = now;
81 
82         // put them on the market
83         marketTime = SafeMath.add(marketTime, cellCount);
84 
85         // ALL HAIL THE SHITCLONELORD!
86         ShitCloneslordAddress.transfer(fee);
87         msg.sender.transfer(SafeMath.sub(cellValue, fee));
88     }
89 
90     function buyShitClones() public payable {
91         require(initialized);
92 
93         uint256 timeBought = calculateCellBuy(msg.value, SafeMath.sub(this.balance, msg.value));
94         timeBought = SafeMath.sub(timeBought, devFee(timeBought));
95         claimedTime[msg.sender] = SafeMath.add(claimedTime[msg.sender], timeBought);
96 
97         // ALL HAIL THE SHITCLONELORD!
98         ShitCloneslordAddress.transfer(devFee(msg.value));
99     }
100 
101     // magic trade balancing algorithm
102     function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {
103         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
104         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
105     }
106 
107     function calculateCellSell(uint256 time) public view returns(uint256) {
108         return calculateTrade(time, marketTime, this.balance);
109     }
110 
111     function calculateCellBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
112         return calculateTrade(eth, contractBalance, marketTime);
113     }
114 
115     function calculateCellBuySimple(uint256 eth) public view returns(uint256) {
116         return calculateCellBuy(eth, this.balance);
117     }
118 
119     function devFee(uint256 amount) public view returns(uint256) {
120         return SafeMath.div(SafeMath.mul(amount, 4), 100); // 4%
121     }
122 
123     function seedMarket(uint256 time) public payable {
124         require(marketTime == 0);
125         require(ShitCloneslordAddress == msg.sender);
126         marketTime = time;
127     }
128 
129     function getFreeShitClone() public payable {
130         require(initialized);
131         require(msg.value == 0.001 ether); // similar to mining fee, prevents bots
132         ShitCloneslordAddress.transfer(msg.value); // the ShitCloneslord gets the entry fee ;)
133 
134         require(ballShitClone[msg.sender] == 0);
135         lastEvent[msg.sender] = now;
136         ballShitClone[msg.sender] = STARTING_SHITCLONE;
137     }
138 
139     function getBalance() public view returns(uint256) {
140         return this.balance;
141     }
142 
143     function getMyShitClone() public view returns(uint256) {
144         return ballShitClone[msg.sender];
145     }
146 
147     function becomeShitClonelord() public {
148         require(initialized);
149         require(msg.sender != ShitCloneslordAddress);
150         require(ballShitClone[msg.sender] >= ShitCloneslordReq);
151 
152         ballShitClone[msg.sender] = SafeMath.sub(ballShitClone[msg.sender], ShitCloneslordReq);
153         ShitCloneslordReq = ballShitClone[msg.sender]; // the requirement now becomes the balance at that time
154         ShitCloneslordAddress = msg.sender;
155     }
156 
157     function getShitClonelordReq() public view returns(uint256) {
158         return ShitCloneslordReq;
159     }
160 
161     function getMyTime() public view returns(uint256) {
162         return SafeMath.add(claimedTime[msg.sender], getTimeSinceLastEvent(msg.sender));
163     }
164 
165     function getTimeSinceLastEvent(address adr) public view returns(uint256) {
166         uint256 secondsPassed = min(TIME_TO_MAKE_1_SHITCLONE, SafeMath.sub(now, lastEvent[adr]));
167         return SafeMath.mul(secondsPassed, ballShitClone[adr]);
168     }
169 
170     function min(uint256 a, uint256 b) private pure returns (uint256) {
171         return a < b ? a : b;
172     }
173 }
174 
175 library SafeMath {
176 
177   /**
178   * @dev Multiplies two numbers, throws on overflow.
179   */
180   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181     if (a == 0) {
182       return 0;
183     }
184     uint256 c = a * b;
185     assert(c / a == b);
186     return c;
187   }
188 
189   /**
190   * @dev Integer division of two numbers, truncating the quotient.
191   */
192   function div(uint256 a, uint256 b) internal pure returns (uint256) {
193     // assert(b > 0); // Solidity automatically throws when dividing by 0
194     uint256 c = a / b;
195     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196     return c;
197   }
198 
199   /**
200   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
201   */
202   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203     assert(b <= a);
204     return a - b;
205   }
206 
207   /**
208   * @dev Adds two numbers, throws on overflow.
209   */
210   function add(uint256 a, uint256 b) internal pure returns (uint256) {
211     uint256 c = a + b;
212     assert(c >= a);
213     return c;
214   }
215 }