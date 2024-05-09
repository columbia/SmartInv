1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // site : http://ethdragonfarm.com/
4 
5 contract DragonFarmer {
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
54     uint256 public STARTING_Dragon=30;
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
68     mapping (address => uint256) public anotherDragon;
69     
70     mapping (address => uint256) public userHatchRate;
71     
72     mapping (address => bool) public freeUser;		
73     mapping (address => bool) public cashedOut;
74     
75     mapping (address => uint256) public userReferralEggs;
76     mapping (address => uint256) public lastHatch;
77     mapping (address => address) public referrals;
78     
79     uint256 public marketEggs;
80     uint256 public contractStarted;
81     
82     constructor() public {
83         ceoAddress=msg.sender;
84     }
85     
86     function seedMarket(uint256 eggs) public payable {
87         require(marketEggs==0);
88         initialized=true;
89         marketEggs=eggs;
90         contractStarted = now;
91     }
92     
93     function getMyEggs() public view returns(uint256){
94         return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
95     }
96     
97     function getEggsSinceLastHatch(address adr) public view returns(uint256){
98         uint256 secondsPassed = SafeMath.sub(now,lastHatch[adr]);
99         uint256 dragonCount = SafeMath.mul(iceDragons[adr], 10);
100         dragonCount = SafeMath.add(SafeMath.mul(anotherDragon[adr], 20), dragonCount);
101         dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);
102         dragonCount = SafeMath.add(dragonCount, normalDragon[adr]);
103         return SafeMath.mul(secondsPassed, dragonCount);
104     }
105     
106     function getEggsToHatchDragon() public view returns (uint) {
107         uint256 timeSpent = SafeMath.sub(now,contractStarted); 
108         timeSpent = SafeMath.div(timeSpent, 3600);
109         return SafeMath.mul(timeSpent, 10);
110     }
111     
112     function getBalance() public view returns(uint256){
113         return address(this).balance;
114     }
115     
116     function getMyNormalDragons() public view returns(uint256) {
117         return SafeMath.add(normalDragon[msg.sender], premiumDragons[msg.sender]);
118     }
119     
120     function getMyIceDragon() public view returns(uint256) {
121         return iceDragons[msg.sender];
122     }
123     
124     function getMyAnotherDragon() public view returns(uint256) {
125         return anotherDragon[msg.sender];
126     }
127     
128     function setUserHatchRate() internal {
129         if (userHatchRate[msg.sender] == 0) 
130             userHatchRate[msg.sender] = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
131     }
132     
133     function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){
134         return SafeMath.div(SafeMath.mul(amount,percentage),100);
135     }
136     
137     function getFreeDragon() public {
138         require(initialized);
139         require(normalDragon[msg.sender] == 0);
140         freeUser[msg.sender] = true;
141         
142         lastHatch[msg.sender]=now;
143         normalDragon[msg.sender]=STARTING_Dragon;
144         setUserHatchRate();
145     }
146     
147     function buyDrangon() public payable {
148         require(initialized);
149         require(userHatchRate[msg.sender] != 0);
150         freeUser[msg.sender] = false;
151         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance);
152         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
153         require(dragonAmount > 0);
154         
155         ceoEtherBalance += calculatePercentage(msg.value, 20);
156         premiumDragons[msg.sender] += dragonAmount;
157     }
158     
159     function buyIceDrangon() public payable {
160         require(initialized);
161         require(userHatchRate[msg.sender] != 0);
162         freeUser[msg.sender] = false;
163         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 8;
164         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
165         require(dragonAmount > 0);
166         
167         ceoEtherBalance += calculatePercentage(msg.value, 20);
168         iceDragons[msg.sender] += dragonAmount;
169     }
170     
171     function buyAnotherDrangon() public payable {
172         require(initialized);
173         require(userHatchRate[msg.sender] != 0);
174         freeUser[msg.sender] = false;
175         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 17;
176         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
177         require(dragonAmount > 0);
178         
179         ceoEtherBalance += calculatePercentage(msg.value, 20);
180         anotherDragon[msg.sender] += dragonAmount;
181     }
182     
183     function hatchEggs(address ref) public {
184         require(initialized);
185         
186         if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
187             referrals[msg.sender] = ref;
188         }
189         
190         uint256 eggsProduced = getMyEggs();
191         
192         uint256 newDragon = SafeMath.div(eggsProduced,userHatchRate[msg.sender]);
193         
194         uint256 eggsConsumed = SafeMath.mul(newDragon, userHatchRate[msg.sender]);
195         
196         normalDragon[msg.sender] = SafeMath.add(normalDragon[msg.sender],newDragon);
197         userReferralEggs[msg.sender] = SafeMath.sub(eggsProduced, eggsConsumed); 
198         lastHatch[msg.sender]=now;
199         
200         //send referral eggs
201         userReferralEggs[referrals[msg.sender]]=SafeMath.add(userReferralEggs[referrals[msg.sender]],SafeMath.div(eggsConsumed,10));
202         
203         //boost market to nerf Dragon hoarding
204         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsProduced,10));
205     }
206     
207     function sellEggs() public {
208         require(initialized);
209         uint256 hasEggs = getMyEggs();
210         
211         if(freeUser[msg.sender]) {
212             require(cashedOut[msg.sender] == false);
213             if (hasEggs > 86400 * 5) {
214                 hasEggs = 86400 * 5;
215             }
216         }
217         uint256 eggValue = calculateEggSell(hasEggs);
218         uint256 fee = calculatePercentage(eggValue, 2);
219         userReferralEggs[msg.sender] = 0;
220         lastHatch[msg.sender]=now;
221         marketEggs=SafeMath.add(marketEggs,hasEggs);
222         ceoEtherBalance += fee;
223         require(address(this).balance > ceoEtherBalance);
224         msg.sender.transfer(SafeMath.sub(eggValue,fee));
225         cashedOut[msg.sender] = true;
226     }
227     
228     function getDragonPrice(uint eggs, uint256 eth) internal view returns (uint) {
229         return calculateEggSell(eggs, eth);
230     }
231     
232     function getDragonPriceNo(uint eth) public view returns (uint) {
233         uint256 d = userHatchRate[msg.sender];
234         if (d == 0) 
235             d = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
236         return getDragonPrice(d, eth);
237     }
238     
239     //magic trade balancing algorithm
240     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
241         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
242         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
243     }
244     
245     function calculateEggSell(uint256 eggs) public view returns(uint256){
246         return calculateTrade(eggs,marketEggs,address(this).balance);
247     }
248     
249     function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){
250         return calculateTrade(eggs,marketEggs,eth);
251     }
252     
253     
254     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){
255         return calculateTrade(eth,contractBalance,marketEggs);
256     }
257     
258     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
259         return calculateEggBuy(eth, address(this).balance);
260     }
261 }
262 
263 library SafeMath {
264 
265   /**
266   * @dev Multiplies two numbers, throws on overflow.
267   */
268   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269     if (a == 0) {
270       return 0;
271     }
272     uint256 c = a * b;
273     assert(c / a == b);
274     return c;
275   }
276 
277   /**
278   * @dev Integer division of two numbers, truncating the quotient.
279   */
280   function div(uint256 a, uint256 b) internal pure returns (uint256) {
281     // assert(b > 0); // Solidity automatically throws when dividing by 0
282     uint256 c = a / b;
283     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284     return c;
285   }
286 
287   /**
288   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
289   */
290   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
291     assert(b <= a);
292     return a - b;
293   }
294 
295   /**
296   * @dev Adds two numbers, throws on overflow.
297   */
298   function add(uint256 a, uint256 b) internal pure returns (uint256) {
299     uint256 c = a + b;
300     assert(c >= a);
301     return c;
302   }
303 }