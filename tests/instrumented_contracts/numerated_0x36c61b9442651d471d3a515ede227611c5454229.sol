1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, throws on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18      * @dev Integer division of two numbers, truncating the quotient.
19      */
20     function div(uint256 a, uint256 b) internal pure returns(uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Adds two numbers, throws on overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns(uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 contract Ownable {
45   address public owner;
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     if (newOwner != address(0)) {
72       owner = newOwner;
73     }
74   }
75 
76 }
77 
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev modifier to allow actions only when the contract IS paused
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev modifier to allow actions only when the contract IS NOT paused
95    */
96   modifier whenPaused {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() public onlyOwner whenNotPaused returns (bool) {
105     paused = true;
106     return true;
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() public onlyOwner whenPaused returns (bool) {
113     paused = false;
114     return true;
115   }
116 }
117 
118 contract LionCup is Pausable {
119     // total eggs one bat can produce per day
120     uint256 public EGGS_TO_HATCH_1BAT = 86400;
121     // how much bat for newbie user
122     uint256 public STARTING_BAT = 500;
123     uint256 PSN = 10000;
124     uint256 PSNH = 5000;
125     mapping(address => uint256) public hatcheryBat;
126     mapping(address => uint256) public claimedEggs;
127     mapping(address => uint256) public lastHatch;
128     mapping(address => address) public referrals;
129     uint256 public batlordReq = 500000; // starts at 500k bat
130     address public batlordAddress;
131     
132 
133     // total eggs in market
134     uint256 public marketEggs;
135     
136     constructor() public{
137         paused = false;
138         batlordAddress = msg.sender;
139     }
140 
141     function becomeBatlord() public whenNotPaused {
142         require(msg.sender != batlordAddress);
143         require(hatcheryBat[msg.sender] >= batlordReq);
144 
145         hatcheryBat[msg.sender] = SafeMath.sub(hatcheryBat[msg.sender], batlordReq);
146         batlordReq = hatcheryBat[msg.sender]; // the requirement now becomes the balance at that time
147         batlordAddress = msg.sender;
148     }
149 
150     function getBatlordReq() public view returns(uint256) {
151         return batlordReq;
152     } 
153 
154     function withdraw(uint256 _percent) public onlyOwner {
155         require(_percent>0&&_percent<=100);
156         uint256 val = SafeMath.div(SafeMath.mul(address(this).balance,_percent), 100);
157         if (val>0){
158           owner.transfer(val);
159         }
160     }
161 
162     // hatch eggs into bats
163     function hatchEggs(address ref) public whenNotPaused {
164         // set user's referral only if which is empty
165         if (referrals[msg.sender] == address(0) && referrals[msg.sender] != msg.sender) {
166             referrals[msg.sender] = ref;
167         }
168         uint256 eggsUsed = getMyEggs();
169         uint256 newBat = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1BAT);
170         hatcheryBat[msg.sender] = SafeMath.add(hatcheryBat[msg.sender], newBat);
171         claimedEggs[msg.sender] = 0;
172         lastHatch[msg.sender] = now;
173 
174         //send referral eggs 20% of user
175         claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 5));
176 
177         //boost market to nerf bat hoarding
178         // add 10% of user into market
179         marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 10));
180     }
181 
182     // sell eggs for eth
183     function sellEggs() public whenNotPaused {
184         uint256 hasEggs = getMyEggs();
185         uint256 eggValue = calculateEggSell(hasEggs);
186         uint256 fee = devFee(eggValue);
187         // kill one third of the owner's snails on egg sale
188         hatcheryBat[msg.sender] = SafeMath.mul(SafeMath.div(hatcheryBat[msg.sender], 3), 2);
189         claimedEggs[msg.sender] = 0;
190         lastHatch[msg.sender] = now;
191         marketEggs = SafeMath.add(marketEggs, hasEggs);
192         batlordAddress.transfer(fee);
193         msg.sender.transfer(SafeMath.sub(eggValue, fee));
194     }
195 
196     function buyEggs() public payable whenNotPaused {
197         uint256 eggsBought = calculateEggBuy(msg.value, SafeMath.sub(address(this).balance, msg.value));
198         eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));
199         batlordAddress.transfer(devFee(msg.value));
200         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);
201     }
202     //magic trade balancing algorithm
203     function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {
204         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
205         return SafeMath.div(SafeMath.mul(PSN, bs), SafeMath.add(PSNH, SafeMath.div(SafeMath.add(SafeMath.mul(PSN, rs), SafeMath.mul(PSNH, rt)), rt)));
206     }
207 
208     // eggs to eth
209     function calculateEggSell(uint256 eggs) public view returns(uint256) {
210         return calculateTrade(eggs, marketEggs, address(this).balance);
211     }
212 
213     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
214         return calculateTrade(eth, contractBalance, marketEggs);
215     }
216 
217     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
218         return calculateEggBuy(eth, address(this).balance);
219     }
220 
221     // eggs amount to eth for developers: eggs*4/100
222     function devFee(uint256 amount) public pure returns(uint256) {
223         return SafeMath.div(SafeMath.mul(amount, 4), 100);
224     }
225 
226     // add eggs when there's no more eggs
227     // 864000000 with 0.02 Ether
228     function seedMarket(uint256 eggs) public payable {
229         require(marketEggs == 0);
230         marketEggs = eggs;
231     }
232 
233     function getFreeBat() public payable whenNotPaused {
234         require(msg.value == 0.01 ether);
235         require(hatcheryBat[msg.sender] == 0);
236         lastHatch[msg.sender] = now;
237         hatcheryBat[msg.sender] = STARTING_BAT;
238         owner.transfer(msg.value);
239     }
240 
241     function getBalance() public view returns(uint256) {
242         return address(this).balance;
243     }
244 
245     function getMyBat() public view returns(uint256) {
246         return hatcheryBat[msg.sender];
247     }
248 
249     function getMyEggs() public view returns(uint256) {
250         return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
251     }
252 
253     function getEggsSinceLastHatch(address adr) public view returns(uint256) {
254         uint256 secondsPassed = min(EGGS_TO_HATCH_1BAT, SafeMath.sub(now, lastHatch[adr]));
255         return SafeMath.mul(secondsPassed, hatcheryBat[adr]);
256     }
257 
258     function min(uint256 a, uint256 b) private pure returns(uint256) {
259         return a < b ? a : b;
260     }
261 }