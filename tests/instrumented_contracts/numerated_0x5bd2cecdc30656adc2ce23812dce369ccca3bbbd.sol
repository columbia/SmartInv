1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract EtherMorty {
6     
7     address public superPowerFulDragonOwner;
8     uint256 lastPrice = 200000000000000000;
9     uint public hatchingSpeed = 100;
10     uint256 public snatchedOn;
11     bool public isEnabled = false;
12     
13     
14     function withDrawMoney() public {
15         require(msg.sender == ceoAddress);
16         uint256 myBalance = ceoEtherBalance;
17         ceoEtherBalance = 0;
18         ceoAddress.transfer(myBalance);
19     }
20     
21     function buySuperDragon() public payable {
22         require(isEnabled);
23         require(initialized);
24         uint currenPrice = SafeMath.add(SafeMath.div(SafeMath.mul(lastPrice, 4),100),lastPrice);
25         require(msg.value > currenPrice);
26         
27         uint256 timeSpent = SafeMath.sub(now, snatchedOn);
28         userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);
29         
30         hatchingSpeed += SafeMath.div(SafeMath.sub(now, contractStarted), 60*60*24);
31         ceoEtherBalance += calculatePercentage(msg.value, 20);
32         superPowerFulDragonOwner.transfer(msg.value - calculatePercentage(msg.value, 2));
33         lastPrice = currenPrice;
34         superPowerFulDragonOwner = msg.sender;
35         snatchedOn = now;
36     }
37     
38     function claimSuperDragonEggs() public {
39         require(isEnabled);
40         require (msg.sender == superPowerFulDragonOwner);
41         uint256 timeSpent = SafeMath.sub(now, snatchedOn);
42         userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);
43         snatchedOn = now;
44     }
45     
46     uint256 public EGGS_TO_HATCH_1Dragon=86400;//for final version should be seconds in a day
47     uint256 public STARTING_Dragon=100;
48     
49     uint256 PSN=10000;
50     uint256 PSNH=5000;
51     
52     bool public initialized=false;
53     address public ceoAddress = 0xdf4703369ecE603a01e049e34e438ff74Cd96D66;
54     uint public ceoEtherBalance;
55     
56     mapping (address => uint256) public iceDragons;
57     mapping (address => uint256) public premiumDragons;
58     mapping (address => uint256) public normalDragon;
59     mapping (address => uint256) public userHatchRate;
60     
61     mapping (address => uint256) public userReferralEggs;
62     mapping (address => uint256) public lastHatch;
63     mapping (address => address) public referrals;
64     
65     uint256 public marketEggs;
66     uint256 public contractStarted;
67         
68     function seedMarket(uint256 eggs) public payable {
69         require(marketEggs==0);
70         initialized=true;
71         marketEggs=eggs;
72         contractStarted = now;
73     }
74     
75     function getMyEggs() public view returns(uint256){
76         return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
77     }
78     
79     function getEggsSinceLastHatch(address adr) public view returns(uint256){
80         uint256 secondsPassed = SafeMath.sub(now,lastHatch[adr]);
81         uint256 dragonCount = SafeMath.mul(iceDragons[adr], 12);
82         dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);
83         dragonCount = SafeMath.add(dragonCount, normalDragon[adr]);
84         return SafeMath.mul(secondsPassed, dragonCount);
85     }
86     
87     function getEggsToHatchDragon() public view returns (uint) {
88         uint256 timeSpent = SafeMath.sub(now,contractStarted); 
89         timeSpent = SafeMath.div(timeSpent, 3600);
90         return SafeMath.mul(timeSpent, 10);
91     }
92     
93     function getBalance() public view returns(uint256){
94         return address(this).balance;
95     }
96     
97     function getMyNormalDragons() public view returns(uint256) {
98         return SafeMath.add(normalDragon[msg.sender], premiumDragons[msg.sender]);
99     }
100     
101     function getMyIceDragon() public view returns(uint256) {
102         return iceDragons[msg.sender];
103     }
104     
105     function setUserHatchRate() internal {
106         if (userHatchRate[msg.sender] == 0) 
107             userHatchRate[msg.sender] = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
108     }
109     
110     function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){
111         return SafeMath.div(SafeMath.mul(amount,percentage),100);
112     }
113     
114     function getFreeDragon() public {
115         require(initialized);
116         require(normalDragon[msg.sender] == 0);
117         
118         lastHatch[msg.sender]=now;
119         normalDragon[msg.sender]=STARTING_Dragon;
120         setUserHatchRate();
121     }
122     
123     function buyDrangon() public payable {
124         require(initialized);
125         require(userHatchRate[msg.sender] != 0);
126         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance);
127         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
128         require(dragonAmount > 0);
129         
130         ceoEtherBalance += calculatePercentage(msg.value, 40);
131         premiumDragons[msg.sender] += dragonAmount;
132     }
133     
134     function buyIceDrangon() public payable {
135         require(initialized);
136         require(userHatchRate[msg.sender] != 0);
137         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 8;
138         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
139         require(dragonAmount > 0);
140         
141         ceoEtherBalance += calculatePercentage(msg.value, 40);
142         iceDragons[msg.sender] += dragonAmount;
143     }
144     
145     function hatchEggs(address ref) public {
146         require(initialized);
147         
148         if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
149             referrals[msg.sender] = ref;
150         }
151         
152         uint256 eggsProduced = getMyEggs();
153         
154         uint256 newDragon = SafeMath.div(eggsProduced,userHatchRate[msg.sender]);
155         
156         uint256 eggsConsumed = SafeMath.mul(newDragon, userHatchRate[msg.sender]);
157         
158         normalDragon[msg.sender] = SafeMath.add(normalDragon[msg.sender],newDragon);
159         userReferralEggs[msg.sender] = SafeMath.sub(eggsProduced, eggsConsumed); 
160         lastHatch[msg.sender]=now;
161         
162         //send referral eggs
163         userReferralEggs[referrals[msg.sender]]=SafeMath.add(userReferralEggs[referrals[msg.sender]],SafeMath.div(eggsConsumed,10));
164         
165         //boost market to nerf Dragon hoarding
166         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsProduced,10));
167     }
168     
169     function sellEggs() public {
170         require(initialized);
171         uint256 hasEggs = getMyEggs();
172         uint256 eggValue = calculateEggSell(hasEggs);
173         uint256 fee = calculatePercentage(eggValue, 20);
174         userReferralEggs[msg.sender] = 0;
175         lastHatch[msg.sender]=now;
176         marketEggs=SafeMath.add(marketEggs,hasEggs);
177         ceoEtherBalance += fee;
178         msg.sender.transfer(SafeMath.sub(eggValue,fee));
179     }
180     
181     function getDragonPrice(uint eggs, uint256 eth) internal view returns (uint) {
182         uint dragonPrice = calculateEggSell(eggs, eth);
183         return calculatePercentage(dragonPrice, 140);
184     }
185     
186     function getDragonPriceNo() public view returns (uint) {
187         uint256 d = userHatchRate[msg.sender];
188         if (d == 0) 
189             d = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
190         return getDragonPrice(d, address(this).balance);
191     }
192     
193     //magic trade balancing algorithm
194     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
195         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
196         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
197     }
198     
199     function calculateEggSell(uint256 eggs) public view returns(uint256){
200         return calculateTrade(eggs,marketEggs,address(this).balance);
201     }
202     
203     function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){
204         return calculateTrade(eggs,marketEggs,eth);
205     }
206     
207     
208     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){
209         return calculateTrade(eth,contractBalance,marketEggs);
210     }
211     
212     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
213         return calculateEggBuy(eth, address(this).balance);
214     }
215     
216     
217 
218 }
219 
220 library SafeMath {
221 
222   /**
223   * @dev Multiplies two numbers, throws on overflow.
224   */
225   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226     if (a == 0) {
227       return 0;
228     }
229     uint256 c = a * b;
230     assert(c / a == b);
231     return c;
232   }
233 
234   /**
235   * @dev Integer division of two numbers, truncating the quotient.
236   */
237   function div(uint256 a, uint256 b) internal pure returns (uint256) {
238     // assert(b > 0); // Solidity automatically throws when dividing by 0
239     uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241     return c;
242   }
243 
244   /**
245   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246   */
247   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   /**
253   * @dev Adds two numbers, throws on overflow.
254   */
255   function add(uint256 a, uint256 b) internal pure returns (uint256) {
256     uint256 c = a + b;
257     assert(c >= a);
258     return c;
259   }
260 }