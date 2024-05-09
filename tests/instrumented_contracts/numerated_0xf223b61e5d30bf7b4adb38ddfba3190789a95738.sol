1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // site : https://ethercartel.com/
4 
5 contract EtherCartel {
6     
7     address public superPowerFulDragonOwner;
8     uint256 public lastPrice = 200000000000000000;
9     uint public hatchingSpeed = 100;
10     uint256 public snatchedOn;
11     bool public isEnabled = false;
12     
13     function enableSuperDragon(bool enable) public {
14         require(msg.sender == ceoAddress);
15         isEnabled = enable;
16         superPowerFulDragonOwner = ceoAddress;
17         snatchedOn = now;
18     }
19     
20     function withDrawMoney(uint percentage) public {
21         require(msg.sender == ceoAddress);
22         uint256 myBalance = calculatePercentage(ceoEtherBalance, percentage);
23         ceoEtherBalance = ceoEtherBalance - myBalance;
24         ceoAddress.transfer(myBalance);
25     }
26     
27     function buySuperDragon() public payable {
28         require(isEnabled);
29         require(initialized);
30         uint currenPrice = SafeMath.add(SafeMath.div(SafeMath.mul(lastPrice, 4),100),lastPrice);
31         require(msg.value > currenPrice);
32         
33         uint256 timeSpent = SafeMath.sub(now, snatchedOn);
34         userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);
35         
36         hatchingSpeed += SafeMath.div(SafeMath.sub(now, contractStarted), 60*60*24);
37         ceoEtherBalance += calculatePercentage(msg.value, 2);
38         superPowerFulDragonOwner.transfer(msg.value - calculatePercentage(msg.value, 2));
39         lastPrice = currenPrice;
40         superPowerFulDragonOwner = msg.sender;
41         snatchedOn = now;
42     }
43     
44     function claimSuperDragonEggs() public {
45         require(isEnabled);
46         require (msg.sender == superPowerFulDragonOwner);
47         uint256 timeSpent = SafeMath.sub(now, snatchedOn);
48         userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);
49         snatchedOn = now;
50     }
51     
52     //uint256 EGGS_PER_Dragon_PER_SECOND=1;
53     uint256 public EGGS_TO_HATCH_1Dragon=86400;//for final version should be seconds in a day
54     uint256 public STARTING_Dragon=5;
55     
56     uint256 PSN=10000;
57     uint256 PSNH=5000;
58     
59     bool public initialized=false;
60     address public ceoAddress;
61     uint public ceoEtherBalance;
62     uint public constant maxIceDragonsCount = 5;
63     uint public constant maxPremiumDragonsCount = 20;
64     
65     mapping (address => uint256) public iceDragons;
66     mapping (address => uint256) public premiumDragons;
67     mapping (address => uint256) public normalDragon;
68     mapping (address => uint256) public userHatchRate;
69     
70     mapping (address => uint256) public userReferralEggs;
71     mapping (address => uint256) public lastHatch;
72     mapping (address => address) public referrals;
73     
74     uint256 public marketEggs;
75     uint256 public contractStarted;
76     
77     constructor() public {
78         ceoAddress=msg.sender;
79     }
80     
81     function seedMarket(uint256 eggs) public payable {
82         require(marketEggs==0);
83         initialized=true;
84         marketEggs=eggs;
85         contractStarted = now;
86     }
87     
88     function getMyEggs() public view returns(uint256){
89         return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
90     }
91     
92     function getEggsSinceLastHatch(address adr) public view returns(uint256){
93         uint256 secondsPassed = SafeMath.sub(now,lastHatch[adr]);
94         uint256 dragonCount = SafeMath.mul(iceDragons[adr], 10);
95         dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);
96         dragonCount = SafeMath.add(dragonCount, normalDragon[adr]);
97         return SafeMath.mul(secondsPassed, dragonCount);
98     }
99     
100     function getEggsToHatchDragon() public view returns (uint) {
101         uint256 timeSpent = SafeMath.sub(now,contractStarted); 
102         timeSpent = SafeMath.div(timeSpent, 3600);
103         return SafeMath.mul(timeSpent, 10);
104     }
105     
106     function getBalance() public view returns(uint256){
107         return address(this).balance;
108     }
109     
110     function getMyNormalDragons() public view returns(uint256) {
111         return SafeMath.add(normalDragon[msg.sender], premiumDragons[msg.sender]);
112     }
113     
114     function getMyIceDragon() public view returns(uint256) {
115         return iceDragons[msg.sender];
116     }
117     
118     function setUserHatchRate() internal {
119         if (userHatchRate[msg.sender] == 0) 
120             userHatchRate[msg.sender] = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
121     }
122     
123     function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){
124         return SafeMath.div(SafeMath.mul(amount,percentage),100);
125     }
126     
127     function getFreeDragon() public {
128         require(initialized);
129         require(normalDragon[msg.sender] == 0);
130         
131         lastHatch[msg.sender]=now;
132         normalDragon[msg.sender]=STARTING_Dragon;
133         setUserHatchRate();
134     }
135     
136     function buyDrangon() public payable {
137         require(initialized);
138         require(userHatchRate[msg.sender] != 0);
139         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance);
140         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
141         require(dragonAmount > 0);
142         
143         ceoEtherBalance += calculatePercentage(msg.value, 10);
144         premiumDragons[msg.sender] += dragonAmount;
145     }
146     
147     function buyIceDrangon() public payable {
148         require(initialized);
149         require(userHatchRate[msg.sender] != 0);
150         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 8;
151         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
152         require(dragonAmount > 0);
153         
154         ceoEtherBalance += calculatePercentage(msg.value, 10);
155         iceDragons[msg.sender] += dragonAmount;
156     }
157     
158     function hatchEggs(address ref) public {
159         require(initialized);
160         
161         if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
162             referrals[msg.sender] = ref;
163         }
164         
165         uint256 eggsProduced = getMyEggs();
166         
167         uint256 newDragon = SafeMath.div(eggsProduced,userHatchRate[msg.sender]);
168         
169         uint256 eggsConsumed = SafeMath.mul(newDragon, userHatchRate[msg.sender]);
170         
171         normalDragon[msg.sender] = SafeMath.add(normalDragon[msg.sender],newDragon);
172         userReferralEggs[msg.sender] = SafeMath.sub(eggsProduced, eggsConsumed); 
173         lastHatch[msg.sender]=now;
174         
175         //send referral eggs
176         userReferralEggs[referrals[msg.sender]]=SafeMath.add(userReferralEggs[referrals[msg.sender]],SafeMath.div(eggsConsumed,10));
177         
178         //boost market to nerf Dragon hoarding
179         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsProduced,10));
180     }
181     
182     function sellEggs() public {
183         require(initialized);
184         uint256 hasEggs = getMyEggs();
185         uint256 eggValue = calculateEggSell(hasEggs);
186         uint256 fee = calculatePercentage(eggValue, 2);
187         userReferralEggs[msg.sender] = 0;
188         lastHatch[msg.sender]=now;
189         marketEggs=SafeMath.add(marketEggs,hasEggs);
190         ceoEtherBalance += fee;
191         msg.sender.transfer(SafeMath.sub(eggValue,fee));
192     }
193     
194     function getDragonPrice(uint eggs, uint256 eth) internal view returns (uint) {
195         uint dragonPrice = calculateEggSell(eggs, eth);
196         return calculatePercentage(dragonPrice, 140);
197     }
198     
199     function getDragonPriceNo(uint eth) public view returns (uint) {
200         uint256 d = userHatchRate[msg.sender];
201         if (d == 0) 
202             d = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
203         return getDragonPrice(d, eth);
204     }
205     
206     //magic trade balancing algorithm
207     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
208         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
209         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
210     }
211     
212     function calculateEggSell(uint256 eggs) public view returns(uint256){
213         return calculateTrade(eggs,marketEggs,address(this).balance);
214     }
215     
216     function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){
217         return calculateTrade(eggs,marketEggs,eth);
218     }
219     
220     
221     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){
222         return calculateTrade(eth,contractBalance,marketEggs);
223     }
224     
225     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
226         return calculateEggBuy(eth, address(this).balance);
227     }
228 }
229 
230 library SafeMath {
231 
232   /**
233   * @dev Multiplies two numbers, throws on overflow.
234   */
235   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236     if (a == 0) {
237       return 0;
238     }
239     uint256 c = a * b;
240     assert(c / a == b);
241     return c;
242   }
243 
244   /**
245   * @dev Integer division of two numbers, truncating the quotient.
246   */
247   function div(uint256 a, uint256 b) internal pure returns (uint256) {
248     // assert(b > 0); // Solidity automatically throws when dividing by 0
249     uint256 c = a / b;
250     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251     return c;
252   }
253 
254   /**
255   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
256   */
257   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258     assert(b <= a);
259     return a - b;
260   }
261 
262   /**
263   * @dev Adds two numbers, throws on overflow.
264   */
265   function add(uint256 a, uint256 b) internal pure returns (uint256) {
266     uint256 c = a + b;
267     assert(c >= a);
268     return c;
269   }
270 }