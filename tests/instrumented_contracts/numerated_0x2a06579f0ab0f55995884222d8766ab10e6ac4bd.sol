1 pragma solidity ^0.4.18;
2 
3 // DragonKingConfig v2.0 2e59d4
4 
5 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   uint256 public totalSupply;
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 // File: zeppelin-solidity/contracts/token/ERC20.sol
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 // File: contracts/DragonKingConfig.sol
77 
78 /**
79  * DragonKing game configuration contract
80 **/
81 
82 pragma solidity ^0.4.23;
83 
84 
85 contract DragonKingConfig is Ownable {
86 
87   struct PurchaseRequirement {
88     address[] tokens;
89     uint256[] amounts;
90   }
91 
92   /**
93    * creates Configuration for the DragonKing game
94    * tokens array should be in the following order:
95       0    1    2    3     4    5    6    7     8
96      [tpt, ndc, skl, xper, mag, stg, dex, luck, gift]
97   */
98   constructor(uint8 characterFee, uint8 eruptionThresholdInHours, uint8 percentageOfCharactersToKill, uint128[] charactersCosts, address[] tokens) public {
99     fee = characterFee;
100     for (uint8 i = 0; i < charactersCosts.length; i++) {
101       costs.push(uint128(charactersCosts[i]) * 1 finney);
102       values.push(costs[i] - costs[i] / 100 * fee);
103     }
104     eruptionThreshold = uint256(eruptionThresholdInHours) * 60 * 60; // convert to seconds
105     castleLootDistributionThreshold = 1 days; // once per day
106     percentageToKill = percentageOfCharactersToKill;
107     maxCharacters = 600;
108     teleportPrice = 1000000000000000000;
109     protectionPrice = 1000000000000000000;
110     luckThreshold = 4200;
111     fightFactor = 4;
112     giftTokenAmount = 1000000000000000000;
113     giftToken = ERC20(tokens[8]);
114     // purchase requirements
115     // knights
116     purchaseRequirements[7].tokens = [tokens[5]]; // 5 STG
117     purchaseRequirements[7].amounts = [250];
118     purchaseRequirements[8].tokens = [tokens[5]]; // 5 STG
119     purchaseRequirements[8].amounts = [5*(10**2)];
120     purchaseRequirements[9].tokens = [tokens[5]]; // 10 STG
121     purchaseRequirements[9].amounts = [10*(10**2)];
122     purchaseRequirements[10].tokens = [tokens[5]]; // 20 STG
123     purchaseRequirements[10].amounts = [20*(10**2)];
124     purchaseRequirements[11].tokens = [tokens[5]]; // 50 STG
125     purchaseRequirements[11].amounts = [50*(10**2)];
126     // wizards
127     purchaseRequirements[15].tokens = [tokens[2], tokens[3]]; // 5 SKL % 10 XPER
128     purchaseRequirements[15].amounts = [25*(10**17), 5*(10**2)];
129     purchaseRequirements[16].tokens = [tokens[2], tokens[3], tokens[4]]; // 5 SKL & 10 XPER & 2.5 MAG
130     purchaseRequirements[16].amounts = [5*(10**18), 10*(10**2), 250];
131     purchaseRequirements[17].tokens = [tokens[2], tokens[3], tokens[4]]; // 10 SKL & 20 XPER & 5 MAG
132     purchaseRequirements[17].amounts = [10*(10**18), 20*(10**2), 5*(10**2)];
133     purchaseRequirements[18].tokens = [tokens[2], tokens[3], tokens[4]]; // 25 SKL & 50 XP & 10 MAG
134     purchaseRequirements[18].amounts = [25*(10**18), 50*(10**2), 10*(10**2)];
135     purchaseRequirements[19].tokens = [tokens[2], tokens[3], tokens[4]]; // 50 SKL & 100 XP & 20 MAG
136     purchaseRequirements[19].amounts = [50*(10**18), 100*(10**2), 20*(10**2)]; 
137     purchaseRequirements[20].tokens = [tokens[2], tokens[3], tokens[4]]; // 100 SKL & 200 XP & 50 MAG 
138     purchaseRequirements[20].amounts = [100*(10**18), 200*(10**2), 50*(10**2)];
139     // archers
140     purchaseRequirements[21].tokens = [tokens[2], tokens[3]]; // 2.5 SKL & 5 XPER
141     purchaseRequirements[21].amounts = [25*(10**17), 5*(10**2)];
142     purchaseRequirements[22].tokens = [tokens[2], tokens[3], tokens[6]]; // 5 SKL & 10 XPER & 2.5 DEX
143     purchaseRequirements[22].amounts = [5*(10**18), 10*(10**2), 250];
144     purchaseRequirements[23].tokens = [tokens[2], tokens[3], tokens[6]]; // 10 SKL & 20 XPER & 5 DEX
145     purchaseRequirements[23].amounts = [10*(10**18), 20*(10**2), 5*(10**2)];
146     purchaseRequirements[24].tokens = [tokens[2], tokens[3], tokens[6]]; // 25 SKL & 50 XP & 10 DEX
147     purchaseRequirements[24].amounts = [25*(10**18), 50*(10**2), 10*(10**2)];
148     purchaseRequirements[25].tokens = [tokens[2], tokens[3], tokens[6]]; // 50 SKL & 100 XP & 20 DEX
149     purchaseRequirements[25].amounts = [50*(10**18), 100*(10**2), 20*(10**2)]; 
150     purchaseRequirements[26].tokens = [tokens[2], tokens[3], tokens[6]]; // 100 SKL & 200 XP & 50 DEX 
151     purchaseRequirements[26].amounts = [100*(10**18), 200*(10**2), 50*(10**2)];
152   }
153 
154   /** the Gift token contract **/
155   ERC20 public giftToken;
156   /** amount of gift tokens to send **/
157   uint256 public giftTokenAmount;
158   /** purchase requirements for each type of character **/
159   PurchaseRequirement[30] purchaseRequirements; 
160   /** the cost of each character type */
161   uint128[] public costs;
162   /** the value of each character type (cost - fee), so it's not necessary to compute it each time*/
163   uint128[] public values;
164   /** the fee to be paid each time an character is bought in percent*/
165   uint8 fee;
166   /** The maximum of characters allowed in the game */
167   uint16 public maxCharacters;
168   /** the amount of time that should pass since last eruption **/
169   uint256 public eruptionThreshold;
170   /** the amount of time that should pass ince last castle loot distribution **/
171   uint256 public castleLootDistributionThreshold;
172   /** how many characters to kill in %, e.g. 20 will stand for 20%, should be < 100 **/
173   uint8 public percentageToKill;
174   /* Cooldown threshold */
175   uint256 public constant CooldownThreshold = 1 days;
176   /** fight factor, used to compute extra probability in fight **/
177   uint8 public fightFactor;
178 
179   /** the price for teleportation*/
180   uint256 public teleportPrice;
181   /** the price for protection */
182   uint256 public protectionPrice;
183   /** the luck threshold */
184   uint256 public luckThreshold;
185 
186   function hasEnoughTokensToPurchase(address buyer, uint8 characterType) external returns (bool canBuy) {
187     for (uint256 i = 0; i < purchaseRequirements[characterType].tokens.length; i++) {
188       if (ERC20(purchaseRequirements[characterType].tokens[i]).balanceOf(buyer) < purchaseRequirements[characterType].amounts[i]) {
189         return false;
190       }
191     }
192     return true;
193   }
194 
195 
196   function setPurchaseRequirements(uint8 characterType, address[] tokens, uint256[] amounts) external {
197     purchaseRequirements[characterType].tokens = tokens;
198     purchaseRequirements[characterType].amounts = amounts;
199   } 
200 
201   function getPurchaseRequirements(uint8 characterType) view external returns (address[] tokens, uint256[] amounts) {
202     tokens = purchaseRequirements[characterType].tokens;
203     amounts = purchaseRequirements[characterType].amounts;
204   }
205 
206   /**
207    * sets the prices of the character types
208    * @param prices the prices in finney
209    * */
210   function setPrices(uint16[] prices) external onlyOwner {
211     for (uint8 i = 0; i < prices.length; i++) {
212       costs[i] = uint128(prices[i]) * 1 finney;
213       values[i] = costs[i] - costs[i] / 100 * fee;
214     }
215   }
216 
217   /**
218    * sets the eruption threshold
219    * @param _value the threshold in seconds, e.g. 24 hours = 25*60*60
220    * */
221   function setEruptionThreshold(uint256 _value) external onlyOwner {
222     eruptionThreshold = _value;
223   }
224 
225   /**
226    * sets the castle loot distribution threshold
227    * @param _value the threshold in seconds, e.g. 24 hours = 25*60*60
228    * */
229   function setCastleLootDistributionThreshold(uint256 _value) external onlyOwner {
230     castleLootDistributionThreshold = _value;
231   }
232 
233   /**
234    * sets the fee
235    * @param _value for the fee, e.g. 3% = 3
236    * */
237   function setFee(uint8 _value) external onlyOwner {
238     fee = _value;
239   }
240 
241   /**
242    * sets the percentage of characters to kill on eruption
243    * @param _value the percentage, e.g. 10% = 10
244    * */
245   function setPercentageToKill(uint8 _value) external onlyOwner {
246     percentageToKill = _value;
247   }
248 
249   /**
250    * sets the maximum amount of characters allowed to be present in the game
251    * @param _value characters limit, e.g 600
252    * */
253   function setMaxCharacters(uint16 _value) external onlyOwner {
254     maxCharacters = _value;
255   }
256 
257   /**
258    * sets the fight factor
259    * @param _value fight factor, e.g 4
260    * */
261   function setFightFactor(uint8 _value) external onlyOwner {
262     fightFactor = _value;
263   }
264 
265   /**
266    * sets the teleport price
267    * @param _value base amount of TPT to transfer on teleport, e.g 10e18
268    * */
269   function setTeleportPrice(uint256 _value) external onlyOwner {
270     teleportPrice = _value;
271   }
272 
273   /**
274    * sets the protection price
275    * @param _value base amount of NDC to transfer on protection, e.g 10e18
276    * */
277   function setProtectionPrice(uint256 _value) external onlyOwner {
278     protectionPrice = _value;
279   }
280 
281   /**
282    * sets the luck threshold
283    * @param _value the minimum amount of luck tokens required for the second roll
284    * */
285   function setLuckThreshold(uint256 _value) external onlyOwner {
286     luckThreshold = _value;
287   }
288 
289   /**
290    * sets the amount of tokens to gift threshold
291    * @param _value new value of the amount to gift
292    * */
293   function setGiftTokenAmount(uint256 _value) {
294     giftTokenAmount = _value;
295   }
296 
297   /**
298    * sets the gift token address
299    * @param _value new gift token address
300    * */
301   function setGiftToken(address _value) {
302     giftToken = ERC20(_value);
303   }
304 
305 
306 }