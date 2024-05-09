1 pragma solidity ^0.4.18;
2 
3 contract Vineyard{
4 
5     // All grape units are in grape-secs/day
6     uint256 constant public GRAPE_SECS_TO_GROW_VINE = 86400; // 1 grape
7     uint256 constant public STARTING_VINES = 300;
8     uint256 constant public VINE_CAPACITY_PER_LAND = 1000;
9 
10     bool public initialized=false;
11     address public ceoAddress;
12     address public ceoWallet;
13 
14     mapping (address => uint256) public vineyardVines;
15     mapping (address => uint256) public purchasedGrapes;
16     mapping (address => uint256) public lastHarvest;
17     mapping (address => address) public referrals;
18 
19     uint256 public marketGrapes;
20 
21     mapping (address => uint256) public landMultiplier;
22     mapping (address => uint256) public totalVineCapacity;
23     mapping (address => uint256) public wineInCellar;
24     mapping (address => uint256) public wineProductionRate;
25     uint256 public grapesToBuildWinery = 43200000000; // 500000 grapes
26     uint256 public grapesToProduceBottle = 3456000000; //40000 grapes
27 
28     address constant public LAND_ADDRESS = 0x2C1E693cCC537c8c98C73FaC0262CD7E18a3Ad60;
29     LandInterface landContract;
30 
31     function Vineyard(address _wallet) public{
32         require(_wallet != address(0));
33         ceoAddress = msg.sender;
34         ceoWallet = _wallet;
35         landContract = LandInterface(LAND_ADDRESS);
36     }
37 
38     function transferWalletOwnership(address newWalletAddress) public {
39       require(msg.sender == ceoAddress);
40       require(newWalletAddress != address(0));
41       ceoWallet = newWalletAddress;
42     }
43 
44     modifier initializedMarket {
45         require(initialized);
46         _;
47     }
48 
49     function harvest(address ref) initializedMarket public {
50         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
51             referrals[msg.sender]=ref;
52         }
53         uint256 grapesUsed = getMyGrapes();
54         uint256 newVines = SafeMath.div(grapesUsed, GRAPE_SECS_TO_GROW_VINE);
55         vineyardVines[msg.sender] = SafeMath.add(vineyardVines[msg.sender], newVines);
56         if (vineyardVines[msg.sender] > totalVineCapacity[msg.sender]) {
57           vineyardVines[msg.sender] = totalVineCapacity[msg.sender];
58         }
59         purchasedGrapes[msg.sender] = 0;
60         lastHarvest[msg.sender] = now;
61 
62         //send referral grapes (add to purchase talley)
63         purchasedGrapes[referrals[msg.sender]]=SafeMath.add(purchasedGrapes[referrals[msg.sender]],SafeMath.div(grapesUsed,5));
64     }
65 
66     function produceWine() initializedMarket public {
67         uint256 hasGrapes = getMyGrapes();
68         uint256 wineBottles = SafeMath.div(SafeMath.mul(hasGrapes, wineProductionRate[msg.sender]), grapesToProduceBottle);
69         purchasedGrapes[msg.sender] = 0; //Remainder of grapes are lost in wine production process
70         lastHarvest[msg.sender] = now;
71         //Every bottle of wine increases the grapes to make next by 10
72         grapesToProduceBottle = SafeMath.add(SafeMath.mul(864000, wineBottles), grapesToProduceBottle);
73         wineInCellar[msg.sender] = SafeMath.add(wineInCellar[msg.sender],wineBottles);
74     }
75 
76     function buildWinery() initializedMarket public {
77         require(wineProductionRate[msg.sender] <= landMultiplier[msg.sender]);
78         uint256 hasGrapes = getMyGrapes();
79         require(hasGrapes >= grapesToBuildWinery);
80 
81         uint256 grapesLeft = SafeMath.sub(hasGrapes, grapesToBuildWinery);
82         purchasedGrapes[msg.sender] = grapesLeft;
83         lastHarvest[msg.sender] = now;
84         wineProductionRate[msg.sender] = wineProductionRate[msg.sender] + 1;
85         grapesToBuildWinery = SafeMath.add(grapesToBuildWinery, 21600000000);
86         // winery uses some portion of land, so must remove some vines
87         vineyardVines[msg.sender] = SafeMath.sub(vineyardVines[msg.sender],1000);
88     }
89 
90     function sellGrapes() initializedMarket public {
91         uint256 hasGrapes = getMyGrapes();
92         uint256 grapesToSell = hasGrapes;
93         if (grapesToSell > marketGrapes) {
94           // don't allow sell larger than the current market holdings
95           grapesToSell = marketGrapes;
96         }
97         uint256 grapeValue = calculateGrapeSell(grapesToSell);
98         uint256 fee = devFee(grapeValue);
99         purchasedGrapes[msg.sender] = SafeMath.sub(hasGrapes,grapesToSell);
100         lastHarvest[msg.sender] = now;
101         marketGrapes = SafeMath.add(marketGrapes,grapesToSell);
102         ceoWallet.transfer(fee);
103         msg.sender.transfer(SafeMath.sub(grapeValue, fee));
104     }
105 
106     function buyGrapes() initializedMarket public payable{
107         require(msg.value <= SafeMath.sub(this.balance,msg.value));
108         uint256 grapesBought = calculateGrapeBuy(msg.value, SafeMath.sub(this.balance, msg.value));
109         grapesBought = SafeMath.sub(grapesBought, devFee(grapesBought));
110         marketGrapes = SafeMath.sub(marketGrapes, grapesBought);
111         ceoWallet.transfer(devFee(msg.value));
112         purchasedGrapes[msg.sender] = SafeMath.add(purchasedGrapes[msg.sender],grapesBought);
113     }
114 
115     function calculateTrade(uint256 valueIn, uint256 marketInv, uint256 Balance) public view returns(uint256) {
116         return SafeMath.div(SafeMath.mul(Balance, 10000), SafeMath.add(SafeMath.div(SafeMath.add(SafeMath.mul(marketInv,10000), SafeMath.mul(valueIn, 5000)), valueIn), 5000));
117     }
118 
119     function calculateGrapeSell(uint256 grapes) public view returns(uint256) {
120         return calculateTrade(grapes, marketGrapes, this.balance);
121     }
122 
123     function calculateGrapeBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
124         return calculateTrade(eth,contractBalance,marketGrapes);
125     }
126 
127     function calculateGrapeBuySimple(uint256 eth) public view returns(uint256) {
128         return calculateGrapeBuy(eth,this.balance);
129     }
130 
131     function devFee(uint256 amount) public view returns(uint256){
132         return SafeMath.div(SafeMath.mul(amount,3), 100);
133     }
134 
135     function seedMarket(uint256 grapes) public payable{
136         require(marketGrapes == 0);
137         initialized = true;
138         marketGrapes = grapes;
139     }
140 
141     function getFreeVines() initializedMarket public {
142         require(vineyardVines[msg.sender] == 0);
143         createPlotVineyard(msg.sender);
144     }
145 
146     // For existing plot holders to get added to Mini-game
147     function addFreeVineyard(address adr) initializedMarket public {
148         require(msg.sender == ceoAddress);
149         require(vineyardVines[adr] == 0);
150         createPlotVineyard(adr);
151     }
152 
153     function createPlotVineyard(address player) private {
154         lastHarvest[player] = now;
155         vineyardVines[player] = STARTING_VINES;
156         wineProductionRate[player] = 1;
157         landMultiplier[player] = 1;
158         totalVineCapacity[player] = VINE_CAPACITY_PER_LAND;
159     }
160 
161     function setLandProductionMultiplier(address adr) public {
162         landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.addressToNumVillages(adr),SafeMath.add(SafeMath.mul(landContract.addressToNumTowns(adr),3),SafeMath.mul(landContract.addressToNumCities(adr),9))));
163         totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);
164     }
165 
166     function setLandProductionMultiplierCCUser(bytes32 user, address adr) public {
167         require(msg.sender == ceoAddress);
168         landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.userToNumVillages(user), SafeMath.add(SafeMath.mul(landContract.userToNumTowns(user), 3), SafeMath.mul(landContract.userToNumCities(user), 9))));
169         totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);
170     }
171 
172     function getBalance() public view returns(uint256) {
173         return this.balance;
174     }
175 
176     function getMyVines() public view returns(uint256) {
177         return vineyardVines[msg.sender];
178     }
179 
180     function getMyGrapes() public view returns(uint256) {
181         return SafeMath.add(purchasedGrapes[msg.sender],getGrapesSinceLastHarvest(msg.sender));
182     }
183 
184     function getMyWine() public view returns(uint256) {
185         return wineInCellar[msg.sender];
186     }
187 
188     function getWineProductionRate() public view returns(uint256) {
189         return wineProductionRate[msg.sender];
190     }
191 
192     function getGrapesSinceLastHarvest(address adr) public view returns(uint256) {
193         uint256 secondsPassed = SafeMath.sub(now, lastHarvest[adr]);
194         return SafeMath.mul(secondsPassed, SafeMath.mul(vineyardVines[adr], SafeMath.add(1,SafeMath.div(SafeMath.sub(landMultiplier[adr],1),5))));
195     }
196 
197     function getMyLandMultiplier() public view returns(uint256) {
198         return landMultiplier[msg.sender];
199     }
200 
201     function getGrapesToBuildWinery() public view returns(uint256) {
202         return grapesToBuildWinery;
203     }
204 
205     function min(uint256 a, uint256 b) private pure returns (uint256) {
206         return a < b ? a : b;
207     }
208 
209 }
210 
211 contract LandInterface {
212     function addressToNumVillages(address adr) public returns (uint256);
213     function addressToNumTowns(address adr) public returns (uint256);
214     function addressToNumCities(address adr) public returns (uint256);
215 
216     function userToNumVillages(bytes32 userId) public returns (uint256);
217     function userToNumTowns(bytes32 userId) public returns (uint256);
218     function userToNumCities(bytes32 userId) public returns (uint256);
219 }
220 
221 library SafeMath {
222 
223   /**
224   * @dev Multiplies two numbers, throws on overflow.
225   */
226   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227     if (a == 0) {
228       return 0;
229     }
230     uint256 c = a * b;
231     assert(c / a == b);
232     return c;
233   }
234 
235   /**
236   * @dev Integer division of two numbers, truncating the quotient.
237   */
238   function div(uint256 a, uint256 b) internal pure returns (uint256) {
239     // assert(b > 0); // Solidity automatically throws when dividing by 0
240     uint256 c = a / b;
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242     return c;
243   }
244 
245   /**
246   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
247   */
248   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249     assert(b <= a);
250     return a - b;
251   }
252 
253   /**
254   * @dev Adds two numbers, throws on overflow.
255   */
256   function add(uint256 a, uint256 b) internal pure returns (uint256) {
257     uint256 c = a + b;
258     assert(c >= a);
259     return c;
260   }
261 }