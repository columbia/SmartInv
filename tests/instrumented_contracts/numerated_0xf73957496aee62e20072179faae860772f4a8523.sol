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
13     function buySuperDragon() public payable {
14         require(isEnabled);
15         require(initialized);
16         uint currenPrice = SafeMath.add(SafeMath.div(SafeMath.mul(lastPrice, 4),100),lastPrice);
17         require(msg.value > currenPrice);
18         
19         uint256 timeSpent = SafeMath.sub(now, snatchedOn);
20         userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);
21         
22         hatchingSpeed += SafeMath.div(SafeMath.sub(now, contractStarted), 60*60*24);
23         ceoAddress.transfer(calculatePercentage(msg.value,30));
24         superPowerFulDragonOwner.transfer(msg.value - calculatePercentage(msg.value, 2));
25         lastPrice = currenPrice;
26         superPowerFulDragonOwner = msg.sender;
27         snatchedOn = now;
28     }
29     
30     function claimSuperDragonEggs() public {
31         require(isEnabled);
32         require (msg.sender == superPowerFulDragonOwner);
33         uint256 timeSpent = SafeMath.sub(now, snatchedOn);
34         userReferralEggs[superPowerFulDragonOwner] += SafeMath.mul(hatchingSpeed,timeSpent);
35         snatchedOn = now;
36     }
37     
38     uint256 public EGGS_TO_HATCH_1Dragon=86400;//for final version should be seconds in a day
39     uint256 public STARTING_Dragon=100;
40     
41     uint256 PSN=10000;
42     uint256 PSNH=5000;
43     
44     bool public initialized=false;
45     address public ceoAddress = 0xdf4703369ecE603a01e049e34e438ff74Cd96D66;
46     
47     mapping (address => uint256) public iceDragons;
48     mapping (address => uint256) public premiumDragons;
49     mapping (address => uint256) public normalDragon;
50     mapping (address => uint256) public userHatchRate;
51     
52     mapping (address => uint256) public userReferralEggs;
53     mapping (address => uint256) public lastHatch;
54     mapping (address => address) public referrals;
55     
56     uint256 public marketEggs;
57     uint256 public contractStarted;
58         
59     function seedMarket(uint256 eggs) public payable {
60         require(marketEggs==0);
61         initialized=true;
62         marketEggs=eggs;
63         contractStarted = now;
64     }
65     
66     function getMyEggs() public view returns(uint256){
67         return SafeMath.add(userReferralEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
68     }
69     
70     function getEggsSinceLastHatch(address adr) public view returns(uint256){
71         uint256 secondsPassed = SafeMath.sub(now,lastHatch[adr]);
72         uint256 dragonCount = SafeMath.mul(iceDragons[adr], 12);
73         dragonCount = SafeMath.add(dragonCount, premiumDragons[adr]);
74         dragonCount = SafeMath.add(dragonCount, normalDragon[adr]);
75         return SafeMath.mul(secondsPassed, dragonCount);
76     }
77     
78     function getEggsToHatchDragon() public view returns (uint) {
79         uint256 timeSpent = SafeMath.sub(now,contractStarted); 
80         timeSpent = SafeMath.div(timeSpent, 3600);
81         return SafeMath.mul(timeSpent, 10);
82     }
83     
84     function getBalance() public view returns(uint256){
85         return address(this).balance;
86     }
87     
88     function getMyNormalDragons() public view returns(uint256) {
89         return SafeMath.add(normalDragon[msg.sender], premiumDragons[msg.sender]);
90     }
91     
92     function getMyIceDragon() public view returns(uint256) {
93         return iceDragons[msg.sender];
94     }
95     
96     function setUserHatchRate() internal {
97         if (userHatchRate[msg.sender] == 0) 
98             userHatchRate[msg.sender] = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
99     }
100     
101     function calculatePercentage(uint256 amount, uint percentage) public pure returns(uint256){
102         return SafeMath.div(SafeMath.mul(amount,percentage),100);
103     }
104     
105     function getFreeDragon() public {
106         require(initialized);
107         require(normalDragon[msg.sender] == 0);
108         
109         lastHatch[msg.sender]=now;
110         normalDragon[msg.sender]=STARTING_Dragon;
111         setUserHatchRate();
112     }
113     
114     function buyDrangon() public payable {
115         require(initialized);
116         require(userHatchRate[msg.sender] != 0);
117         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance);
118         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
119         require(dragonAmount > 0);
120         
121         ceoAddress.transfer(calculatePercentage(msg.value,30));
122         premiumDragons[msg.sender] += dragonAmount;
123     }
124     
125     function buyIceDrangon() public payable {
126         require(initialized);
127         require(userHatchRate[msg.sender] != 0);
128         uint dragonPrice = getDragonPrice(userHatchRate[msg.sender], address(this).balance) * 8;
129         uint dragonAmount = SafeMath.div(msg.value, dragonPrice);
130         require(dragonAmount > 0);
131         
132         ceoAddress.transfer(calculatePercentage(msg.value,30));
133         iceDragons[msg.sender] += dragonAmount;
134     }
135     
136     function hatchEggs(address ref) public {
137         require(initialized);
138         
139         if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
140             referrals[msg.sender] = ref;
141         }
142         
143         uint256 eggsProduced = getMyEggs();
144         
145         uint256 newDragon = SafeMath.div(eggsProduced,userHatchRate[msg.sender]);
146         
147         uint256 eggsConsumed = SafeMath.mul(newDragon, userHatchRate[msg.sender]);
148         
149         normalDragon[msg.sender] = SafeMath.add(normalDragon[msg.sender],newDragon);
150         userReferralEggs[msg.sender] = SafeMath.sub(eggsProduced, eggsConsumed); 
151         lastHatch[msg.sender]=now;
152         
153         //send referral eggs
154         userReferralEggs[referrals[msg.sender]]=SafeMath.add(userReferralEggs[referrals[msg.sender]],SafeMath.div(eggsConsumed,10));
155         
156         //boost market to nerf Dragon hoarding
157         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsProduced,10));
158     }
159     
160     function sellEggs() public {
161         require(initialized);
162         uint256 hasEggs = getMyEggs();
163         uint256 eggValue = calculateEggSell(hasEggs);
164         uint256 fee = calculatePercentage(eggValue, 10);
165         userReferralEggs[msg.sender] = 0;
166         lastHatch[msg.sender]=now;
167         normalDragon[msg.sender]=SafeMath.mul(SafeMath.div(normalDragon[msg.sender],3),2);
168         marketEggs=SafeMath.add(marketEggs,hasEggs);
169         ceoAddress.transfer(fee);
170         msg.sender.transfer(SafeMath.sub(eggValue,fee));
171     }
172     
173     function getDragonPrice(uint eggs, uint256 eth) internal view returns (uint) {
174         uint dragonPrice = calculateEggSell(eggs, eth);
175         return calculatePercentage(dragonPrice, 140);
176     }
177     
178     function getDragonPriceNo() public view returns (uint) {
179         uint256 d = userHatchRate[msg.sender];
180         if (d == 0) 
181             d = SafeMath.add(EGGS_TO_HATCH_1Dragon, getEggsToHatchDragon());
182         return getDragonPrice(d, address(this).balance);
183     }
184     
185     //magic trade balancing algorithm
186     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
187         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
188         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
189     }
190     
191     function calculateEggSell(uint256 eggs) public view returns(uint256){
192         return calculatePercentage(calculateTrade(eggs,marketEggs,address(this).balance),80);
193     }
194     
195     function calculateEggSell(uint256 eggs, uint256 eth) public view returns(uint256){
196         return calculatePercentage(calculateTrade(eggs,marketEggs,eth),80);
197     }
198     
199     
200     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256){
201         return calculateTrade(eth,contractBalance,marketEggs);
202     }
203     
204     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
205         return calculateEggBuy(eth, address(this).balance);
206     }
207     
208     
209 
210 }
211 
212 library SafeMath {
213 
214   /**
215   * @dev Multiplies two numbers, throws on overflow.
216   */
217   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218     if (a == 0) {
219       return 0;
220     }
221     uint256 c = a * b;
222     assert(c / a == b);
223     return c;
224   }
225 
226   /**
227   * @dev Integer division of two numbers, truncating the quotient.
228   */
229   function div(uint256 a, uint256 b) internal pure returns (uint256) {
230     // assert(b > 0); // Solidity automatically throws when dividing by 0
231     uint256 c = a / b;
232     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233     return c;
234   }
235 
236   /**
237   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
238   */
239   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240     assert(b <= a);
241     return a - b;
242   }
243 
244   /**
245   * @dev Adds two numbers, throws on overflow.
246   */
247   function add(uint256 a, uint256 b) internal pure returns (uint256) {
248     uint256 c = a + b;
249     assert(c >= a);
250     return c;
251   }
252 }