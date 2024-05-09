1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 contract PremiumFactories {
12     
13     Bankroll constant bankroll = Bankroll(0x66a9f1e53173de33bec727ef76afa84956ae1b25);
14     address owner;
15     
16     constructor() public {
17         owner = msg.sender;
18     }
19     
20     mapping(uint256 => PremiumUnit) premiumUnits; // Contracts for each premium unit (unitId)
21     mapping(uint256 => PremiumFactory) premiumFactories; // Factory Id
22     
23     uint256 minPrice = 0.5 ether;
24     uint256 dailyDegradation = 10; // 1% a day
25     uint256 maxGasPrice = 20000000000; // 20 Gwei 
26     uint256 constant LAUNCH_TIME = 1558814400;
27     
28     struct PremiumFactory {
29         address owner;
30         uint256 unitId;
31         uint256 price;
32         uint256 lastFlipTime; // Last time factory was purchased
33         uint256 lastClaimTimestamp; // Last time factory produced units
34     }
35     
36     function purchaseFactory(uint256 factoryId) external payable {
37         require(msg.sender == tx.origin);
38         require(tx.gasprice <= maxGasPrice);
39         require(now >= LAUNCH_TIME);
40         
41         PremiumFactory memory factory = premiumFactories[factoryId];
42         require(msg.sender != factory.owner && factory.owner > 0);
43         
44         uint256 currentFactoryPrice = getFactoryPrice(factory);
45         require(msg.value >= currentFactoryPrice);
46         
47         
48         PremiumUnit premiumUnit = premiumUnits[factory.unitId];
49         uint256 unitsProduced = (now - factory.lastClaimTimestamp) / premiumUnit.unitProductionSeconds();
50         if (unitsProduced == 0) {
51             unitsProduced++; // Round up (so every owner gets at least 1 unit)
52         }
53         premiumUnit.mintUnit(factory.owner, unitsProduced);
54         
55         // Send profit to previous owner (and bankroll)
56         uint256 previousOwnerProfit = currentFactoryPrice * 94 / 100; // 94% of 120% (so ~13% profit)
57         factory.owner.transfer(previousOwnerProfit);
58         bankroll.depositEth.value(currentFactoryPrice - previousOwnerProfit)(50, 50); // Remaining 7% cut
59         
60         // Update factory
61         factory.price = currentFactoryPrice * 120 / 100;
62         factory.owner = msg.sender;
63         factory.lastFlipTime = now;
64         factory.lastClaimTimestamp = now;
65         premiumFactories[factoryId] = factory;
66         
67         // Return overpayments
68         if (msg.value > currentFactoryPrice) {
69             msg.sender.transfer(msg.value - currentFactoryPrice);
70         }
71     }
72     
73     function getFactoryPrice(PremiumFactory factory) internal view returns (uint256 factoryPrice) {
74         uint256 secondsSinceLastFlip = 0;
75         if (now > factory.lastFlipTime) { // Edge case for initial listing
76             secondsSinceLastFlip = now - factory.lastFlipTime;
77         }
78         
79         uint256 priceReduction = (secondsSinceLastFlip * dailyDegradation * factory.price) / 86400000;
80         
81         factoryPrice = factory.price;
82         if (priceReduction > factoryPrice || factoryPrice - priceReduction < minPrice) {
83             factoryPrice = minPrice;
84         } else {
85             factoryPrice -= priceReduction;
86         }
87     }
88     
89     function getFactories(uint256 endId) external view returns (uint256[] factoryIds, address[] owners, uint256[] unitIds, uint256[] prices, uint256[] lastClaimTime) {
90         factoryIds = new uint256[](endId);
91         owners = new address[](endId);
92         unitIds = new uint256[](endId);
93         prices = new uint256[](endId);
94         lastClaimTime = new uint256[](endId);
95         
96         for (uint256 i = 0; i < endId; i++) {
97             PremiumFactory memory factory = premiumFactories[i+1]; // Id starts at 1
98             factoryIds[i] = i+1;
99             owners[i] = factory.owner;
100             unitIds[i] = factory.unitId;
101             prices[i] = getFactoryPrice(factory);
102             lastClaimTime[i] = factory.lastClaimTimestamp;
103         }
104     }
105     
106     // Just incase needs tweaking for longevity
107     function updateFactoryConfig(uint256 newMinPrice, uint256 newDailyDegradation, uint256 newMaxGasPrice) external {
108         require(msg.sender == owner);
109         minPrice = newMinPrice;
110         dailyDegradation = newDailyDegradation;
111         maxGasPrice = newMaxGasPrice;
112     }
113     
114     function addPremiumUnit(address premiumUnitContract) external {
115         require(msg.sender == owner);
116         PremiumUnit unit = PremiumUnit(premiumUnitContract);
117         premiumUnits[unit.unitId()] = unit;
118     }
119     
120     function addFactory(uint256 id, uint256 unitId, address player, uint256 startPrice) external {
121         require(msg.sender == owner);
122         require(premiumFactories[id].owner == 0);
123         require(premiumUnits[unitId].unitId() == unitId);
124         
125         PremiumFactory memory newFactory;
126         newFactory.owner = player;
127         newFactory.unitId = unitId;
128         newFactory.price = startPrice;
129         newFactory.lastClaimTimestamp = now;
130         newFactory.lastFlipTime = LAUNCH_TIME;
131         
132         premiumFactories[id] = newFactory;
133     }
134     
135     function claimUnits(uint256 factoryId, bool equip) external {
136         PremiumFactory storage factory = premiumFactories[factoryId];
137         require(factory.owner == msg.sender);
138         
139         // Claim all units produced by a factory (since last claimed)
140         PremiumUnit premiumUnit = premiumUnits[factory.unitId];
141         uint256 unitProductionSeconds = premiumUnit.unitProductionSeconds(); // Seconds to produce one unit
142         uint256 unitsProduced = (now - factory.lastClaimTimestamp) / unitProductionSeconds;
143         require(unitsProduced > 0);
144         factory.lastClaimTimestamp += (unitProductionSeconds * unitsProduced);
145         
146         // Mints erc-20 premium units
147         premiumUnit.mintUnit(msg.sender, unitsProduced);
148         
149         // Allow equip in one tx too
150         if (equip) {
151              premiumUnit.equipUnit(msg.sender, uint80(unitsProduced), 100);
152         }
153     }
154     
155     
156     
157 }
158 
159 interface ERC20 {
160     function totalSupply() external constant returns (uint);
161     function balanceOf(address tokenOwner) external constant returns (uint balance);
162     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
163     function transfer(address to, uint tokens) external returns (bool success);
164     function approve(address spender, uint tokens) external returns (bool success);
165     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
166     function transferFrom(address from, address to, uint tokens) external returns (bool success);
167 
168     event Transfer(address indexed from, address indexed to, uint tokens);
169     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
170 }
171 
172 interface ApproveAndCallFallBack {
173     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
174 }
175 
176 contract Bankroll {
177      function depositEth(uint256 gooAllocation, uint256 tokenAllocation) payable external;
178 }
179 
180 contract PremiumUnit {
181     function mintUnit(address player, uint256 amount) external;
182     function equipUnit(address player, uint80 amount, uint8 chosenPosition) external;
183     uint256 public unitId;
184     uint256 public unitProductionSeconds;
185 }
186 
187 contract Units {
188     mapping(address => mapping(uint256 => UnitsOwned)) public unitsOwned;
189     function mintUnitExternal(uint256 unit, uint80 amount, address player, uint8 chosenPosition) external;
190     function deleteUnitExternal(uint80 amount, uint256 unit, address player) external;
191     
192     struct UnitsOwned {
193         uint80 units;
194         uint8 factoryBuiltFlag;
195     }
196 }
197 
198 
199 library SafeMath {
200 
201   /**
202   * @dev Multiplies two numbers, throws on overflow.
203   */
204   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205     if (a == 0) {
206       return 0;
207     }
208     uint256 c = a * b;
209     assert(c / a == b);
210     return c;
211   }
212 
213   /**
214   * @dev Integer division of two numbers, truncating the quotient.
215   */
216   function div(uint256 a, uint256 b) internal pure returns (uint256) {
217     // assert(b > 0); // Solidity automatically throws when dividing by 0
218     uint256 c = a / b;
219     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220     return c;
221   }
222 
223   /**
224   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
225   */
226   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227     assert(b <= a);
228     return a - b;
229   }
230 
231   /**
232   * @dev Adds two numbers, throws on overflow.
233   */
234   function add(uint256 a, uint256 b) internal pure returns (uint256) {
235     uint256 c = a + b;
236     assert(c >= a);
237     return c;
238   }
239 }