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
55         if (SafeMath.add(vineyardVines[msg.sender], newVines) > totalVineCapacity[msg.sender]) {
56             purchasedGrapes[msg.sender] = SafeMath.mul(SafeMath.sub(SafeMath.add(vineyardVines[msg.sender], newVines), totalVineCapacity[msg.sender]), GRAPE_SECS_TO_GROW_VINE);
57             vineyardVines[msg.sender] = totalVineCapacity[msg.sender];
58             grapesUsed = grapesUsed - purchasedGrapes[msg.sender];
59         }
60         else
61         {
62             vineyardVines[msg.sender] = SafeMath.add(vineyardVines[msg.sender], newVines);
63             purchasedGrapes[msg.sender] = 0;
64         }
65         lastHarvest[msg.sender] = now;
66 
67         //send referral grapes (add to purchase talley)
68         purchasedGrapes[referrals[msg.sender]]=SafeMath.add(purchasedGrapes[referrals[msg.sender]],SafeMath.div(grapesUsed,5));
69     }
70 
71     function produceWine() initializedMarket public {
72         uint256 hasGrapes = getMyGrapes();
73         uint256 wineBottles = SafeMath.div(SafeMath.mul(hasGrapes, wineProductionRate[msg.sender]), grapesToProduceBottle);
74         purchasedGrapes[msg.sender] = 0; //Remainder of grapes are lost in wine production process
75         lastHarvest[msg.sender] = now;
76         //Every bottle of wine increases the grapes to make next by 10
77         grapesToProduceBottle = SafeMath.add(SafeMath.mul(864000, wineBottles), grapesToProduceBottle);
78         wineInCellar[msg.sender] = SafeMath.add(wineInCellar[msg.sender],wineBottles);
79     }
80 
81     function buildWinery() initializedMarket public {
82         require(wineProductionRate[msg.sender] <= landMultiplier[msg.sender]);
83         uint256 hasGrapes = getMyGrapes();
84         require(hasGrapes >= grapesToBuildWinery);
85 
86         uint256 grapesLeft = SafeMath.sub(hasGrapes, grapesToBuildWinery);
87         purchasedGrapes[msg.sender] = grapesLeft;
88         lastHarvest[msg.sender] = now;
89         wineProductionRate[msg.sender] = wineProductionRate[msg.sender] + 1;
90         grapesToBuildWinery = SafeMath.add(grapesToBuildWinery, 21600000000);
91         // winery uses some portion of land, so must remove some vines
92         vineyardVines[msg.sender] = SafeMath.sub(vineyardVines[msg.sender],1000);
93     }
94 
95     function sellGrapes() initializedMarket public {
96         uint256 hasGrapes = getMyGrapes();
97         uint256 grapesToSell = hasGrapes;
98         if (grapesToSell > marketGrapes) {
99           // don't allow sell larger than the current market holdings
100           grapesToSell = marketGrapes;
101         }
102         uint256 grapeValue = calculateGrapeSell(grapesToSell);
103         uint256 fee = devFee(grapeValue);
104         purchasedGrapes[msg.sender] = SafeMath.sub(hasGrapes,grapesToSell);
105         lastHarvest[msg.sender] = now;
106         marketGrapes = SafeMath.add(marketGrapes,grapesToSell);
107         ceoWallet.transfer(fee);
108         msg.sender.transfer(SafeMath.sub(grapeValue, fee));
109     }
110 
111     function buyGrapes() initializedMarket public payable{
112         require(msg.value <= SafeMath.sub(this.balance,msg.value));
113         require(vineyardVines[msg.sender] > 0);
114 
115         uint256 grapesBought = calculateGrapeBuy(msg.value, SafeMath.sub(this.balance, msg.value));
116         grapesBought = SafeMath.sub(grapesBought, devFee(grapesBought));
117         marketGrapes = SafeMath.sub(marketGrapes, grapesBought);
118         ceoWallet.transfer(devFee(msg.value));
119         purchasedGrapes[msg.sender] = SafeMath.add(purchasedGrapes[msg.sender],grapesBought);
120     }
121 
122     function calculateTrade(uint256 valueIn, uint256 marketInv, uint256 Balance) public view returns(uint256) {
123         return SafeMath.div(SafeMath.mul(Balance, 10000), SafeMath.add(SafeMath.div(SafeMath.add(SafeMath.mul(marketInv,10000), SafeMath.mul(valueIn, 5000)), valueIn), 5000));
124     }
125 
126     function calculateGrapeSell(uint256 grapes) public view returns(uint256) {
127         return calculateTrade(grapes, marketGrapes, this.balance);
128     }
129 
130     function calculateGrapeBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
131         return calculateTrade(eth,contractBalance,marketGrapes);
132     }
133 
134     function calculateGrapeBuySimple(uint256 eth) public view returns(uint256) {
135         return calculateGrapeBuy(eth,this.balance);
136     }
137 
138     function devFee(uint256 amount) public view returns(uint256){
139         return SafeMath.div(SafeMath.mul(amount,3), 100);
140     }
141 
142     function seedMarket(uint256 grapes) public payable{
143         require(marketGrapes == 0);
144         initialized = true;
145         marketGrapes = grapes;
146     }
147 
148     function getFreeVines() initializedMarket public {
149         require(vineyardVines[msg.sender] == 0);
150         createPlotVineyard(msg.sender);
151     }
152 
153     // For existing plot holders to get added to Mini-game
154     function addFreeVineyard(address adr) initializedMarket public {
155         require(msg.sender == ceoAddress);
156         require(vineyardVines[adr] == 0);
157         createPlotVineyard(adr);
158     }
159 
160     function createPlotVineyard(address player) private {
161         lastHarvest[player] = now;
162         vineyardVines[player] = STARTING_VINES;
163         wineProductionRate[player] = 1;
164         landMultiplier[player] = 1;
165         totalVineCapacity[player] = VINE_CAPACITY_PER_LAND;
166     }
167 
168     function setLandProductionMultiplier(address adr) public {
169         landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.addressToNumVillages(adr),SafeMath.add(SafeMath.mul(landContract.addressToNumTowns(adr),3),SafeMath.mul(landContract.addressToNumCities(adr),9))));
170         totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);
171     }
172 
173     function setLandProductionMultiplierCCUser(bytes32 user, address adr) public {
174         require(msg.sender == ceoAddress);
175         landMultiplier[adr] = SafeMath.add(1,SafeMath.add(landContract.userToNumVillages(user), SafeMath.add(SafeMath.mul(landContract.userToNumTowns(user), 3), SafeMath.mul(landContract.userToNumCities(user), 9))));
176         totalVineCapacity[adr] = SafeMath.mul(landMultiplier[adr],VINE_CAPACITY_PER_LAND);
177     }
178 
179     function getBalance() public view returns(uint256) {
180         return this.balance;
181     }
182 
183     function getMyVines() public view returns(uint256) {
184         return vineyardVines[msg.sender];
185     }
186 
187     function getMyGrapes() public view returns(uint256) {
188         return SafeMath.add(purchasedGrapes[msg.sender],getGrapesSinceLastHarvest(msg.sender));
189     }
190 
191     function getMyWine() public view returns(uint256) {
192         return wineInCellar[msg.sender];
193     }
194 
195     function getWineProductionRate() public view returns(uint256) {
196         return wineProductionRate[msg.sender];
197     }
198 
199     function getGrapesSinceLastHarvest(address adr) public view returns(uint256) {
200         uint256 secondsPassed = SafeMath.sub(now, lastHarvest[adr]);
201         return SafeMath.mul(secondsPassed, SafeMath.mul(vineyardVines[adr], SafeMath.add(1,SafeMath.div(SafeMath.sub(landMultiplier[adr],1),5))));
202     }
203 
204     function getMyLandMultiplier() public view returns(uint256) {
205         return landMultiplier[msg.sender];
206     }
207 
208     function getGrapesToBuildWinery() public view returns(uint256) {
209         return grapesToBuildWinery;
210     }
211 
212     function min(uint256 a, uint256 b) private pure returns (uint256) {
213         return a < b ? a : b;
214     }
215 
216 }
217 
218 contract LandInterface {
219     function addressToNumVillages(address adr) public returns (uint256);
220     function addressToNumTowns(address adr) public returns (uint256);
221     function addressToNumCities(address adr) public returns (uint256);
222 
223     function userToNumVillages(bytes32 userId) public returns (uint256);
224     function userToNumTowns(bytes32 userId) public returns (uint256);
225     function userToNumCities(bytes32 userId) public returns (uint256);
226 }
227 
228 library SafeMath {
229 
230   /**
231   * @dev Multiplies two numbers, throws on overflow.
232   */
233   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234     if (a == 0) {
235       return 0;
236     }
237     uint256 c = a * b;
238     assert(c / a == b);
239     return c;
240   }
241 
242   /**
243   * @dev Integer division of two numbers, truncating the quotient.
244   */
245   function div(uint256 a, uint256 b) internal pure returns (uint256) {
246     // assert(b > 0); // Solidity automatically throws when dividing by 0
247     uint256 c = a / b;
248     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
249     return c;
250   }
251 
252   /**
253   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
254   */
255   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256     assert(b <= a);
257     return a - b;
258   }
259 
260   /**
261   * @dev Adds two numbers, throws on overflow.
262   */
263   function add(uint256 a, uint256 b) internal pure returns (uint256) {
264     uint256 c = a + b;
265     assert(c >= a);
266     return c;
267   }
268 }