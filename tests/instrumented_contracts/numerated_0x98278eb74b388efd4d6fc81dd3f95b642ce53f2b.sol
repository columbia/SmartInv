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
11 contract Army {
12 
13     GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);
14     Clans clans = Clans(0x0);
15 
16     uint224 public totalArmyPower; // Global power of players (attack + defence)
17     uint224 public gooBankroll; // Goo dividends to be split over time between clans/players' army power
18     uint256 public nextSnapshotTime;
19     address public owner; // Minor management of game
20 
21     mapping(address => mapping(uint256 => ArmyPower)) public armyPowerSnapshots; // Store player's army power for given day (snapshot)
22     mapping(address => mapping(uint256 => bool)) public armyPowerZeroedSnapshots; // Edgecase to determine difference between 0 army and an unused/inactive day.
23     mapping(address => uint256) public lastWarFundClaim; // Days (snapshot number)
24     mapping(address => uint256) public lastArmyPowerUpdate; // Days (last snapshot) player's army was updated
25     mapping(address => bool) operator;
26 
27     uint224[] public totalArmyPowerSnapshots; // The total player army power for each prior day past
28     uint224[] public allocatedWarFundSnapshots; // Div pot (goo allocated to each prior day past)
29     
30     uint224 public playerDivPercent = 2;
31     uint224 public clanDivPercent = 2;
32 
33     struct ArmyPower {
34         uint80 attack;
35         uint80 defense;
36         uint80 looting;
37     }
38 
39     constructor(uint256 firstSnapshotTime) public {
40         nextSnapshotTime = firstSnapshotTime;
41         owner = msg.sender;
42     }
43 
44     function setClans(address clansContract) external {
45         require(msg.sender == owner);
46         clans = Clans(clansContract);
47     }
48 
49     function setOperator(address gameContract, bool isOperator) external {
50         require(msg.sender == owner);
51         operator[gameContract] = isOperator;
52     }
53     
54     function updateDailyDivPercents(uint224 newPlayersPercent, uint224 newClansPercent) external {
55         require(msg.sender == owner);
56         require(newPlayersPercent > 0 && newPlayersPercent <= 10); // 1-10% daily
57         require(newClansPercent > 0 && newClansPercent <= 10); // 1-10% daily
58         playerDivPercent = newPlayersPercent;
59         clanDivPercent = newClansPercent;
60     }
61 
62     function depositSpentGoo(uint224 gooSpent) external {
63         require(operator[msg.sender]);
64         gooBankroll += gooSpent;
65     }
66 
67     function getArmyPower(address player) external view returns (uint80, uint80, uint80) {
68         ArmyPower memory armyPower = armyPowerSnapshots[player][lastArmyPowerUpdate[player]];
69         return (armyPower.attack, armyPower.defense, armyPower.looting);
70     }
71     
72     // Convenience function 
73     function getArmiesPower(address player, address target) external view returns (uint80 playersAttack, uint80 playersLooting, uint80 targetsDefense) {
74         ArmyPower memory armyPower = armyPowerSnapshots[player][lastArmyPowerUpdate[player]];
75         playersAttack = armyPower.attack;
76         playersLooting = armyPower.looting;
77         targetsDefense = armyPowerSnapshots[target][lastArmyPowerUpdate[target]].defense;
78     }
79 
80     function increasePlayersArmyPowerTrio(address player, uint80 attackGain, uint80 defenseGain, uint80 lootingGain) public {
81         require(operator[msg.sender]);
82 
83         ArmyPower memory existingArmyPower = armyPowerSnapshots[player][lastArmyPowerUpdate[player]];
84         uint256 snapshotDay = allocatedWarFundSnapshots.length;
85 
86         // Adjust army power (reusing struct)
87         existingArmyPower.attack += attackGain;
88         existingArmyPower.defense += defenseGain;
89         existingArmyPower.looting += lootingGain;
90         armyPowerSnapshots[player][snapshotDay] = existingArmyPower;
91 
92         if (lastArmyPowerUpdate[player] != snapshotDay) {
93             lastArmyPowerUpdate[player] = snapshotDay;
94         }
95         
96         totalArmyPower += (attackGain + defenseGain);
97         clans.increaseClanPower(player, attackGain + defenseGain);
98     }
99 
100     function decreasePlayersArmyPowerTrio(address player, uint80 attackLoss, uint80 defenseLoss, uint80 lootingLoss) public {
101         require(operator[msg.sender]);
102 
103         ArmyPower memory existingArmyPower = armyPowerSnapshots[player][lastArmyPowerUpdate[player]];
104         uint256 snapshotDay = allocatedWarFundSnapshots.length;
105 
106         // Adjust army power (reusing struct)
107         existingArmyPower.attack -= attackLoss;
108         existingArmyPower.defense -= defenseLoss;
109         existingArmyPower.looting -= lootingLoss;
110 
111         if (existingArmyPower.attack == 0 && existingArmyPower.defense == 0) { // Special case which tangles with "inactive day" snapshots (claiming divs)
112             armyPowerZeroedSnapshots[player][snapshotDay] = true;
113             delete armyPowerSnapshots[player][snapshotDay]; // 0
114         } else {
115             armyPowerSnapshots[player][snapshotDay] = existingArmyPower;
116         }
117         
118         if (lastArmyPowerUpdate[player] != snapshotDay) {
119             lastArmyPowerUpdate[player] = snapshotDay;
120         }
121 
122         totalArmyPower -= (attackLoss + defenseLoss);
123         clans.decreaseClanPower(player, attackLoss + defenseLoss);
124     }
125 
126     function changePlayersArmyPowerTrio(address player, int attackChange, int defenseChange, int lootingChange) public {
127         require(operator[msg.sender]);
128 
129         ArmyPower memory existingArmyPower = armyPowerSnapshots[player][lastArmyPowerUpdate[player]];
130         uint256 snapshotDay = allocatedWarFundSnapshots.length;
131 
132         // Allow change to be positive or negative
133         existingArmyPower.attack = uint80(int(existingArmyPower.attack) + attackChange);
134         existingArmyPower.defense = uint80(int(existingArmyPower.defense) + defenseChange);
135         existingArmyPower.looting = uint80(int(existingArmyPower.looting) + lootingChange);
136 
137         if (existingArmyPower.attack == 0 && existingArmyPower.defense == 0) { // Special case which tangles with "inactive day" snapshots (claiming divs)
138             armyPowerZeroedSnapshots[player][snapshotDay] = true;
139             delete armyPowerSnapshots[player][snapshotDay]; // 0
140         } else {
141             armyPowerSnapshots[player][snapshotDay] = existingArmyPower;
142         }
143 
144         if (lastArmyPowerUpdate[player] != snapshotDay) {
145             lastArmyPowerUpdate[player] = snapshotDay;
146         }
147         changeTotalArmyPower(player, attackChange, defenseChange);
148     }
149 
150     function changeTotalArmyPower(address player, int attackChange, int defenseChange) internal {
151         uint224 newTotal = uint224(int(totalArmyPower) + attackChange + defenseChange);
152 
153         if (newTotal > totalArmyPower) {
154             clans.increaseClanPower(player, newTotal - totalArmyPower);
155         } else if (newTotal < totalArmyPower) {
156             clans.decreaseClanPower(player, totalArmyPower - newTotal);
157         }
158         totalArmyPower = newTotal;
159     }
160 
161     // Allocate army power divs for the day (00:00 cron job)
162     function snapshotDailyWarFunding() external {
163         require(msg.sender == owner);
164         require(now + 6 hours > nextSnapshotTime);
165 
166         totalArmyPowerSnapshots.push(totalArmyPower);
167         allocatedWarFundSnapshots.push((gooBankroll * playerDivPercent) / 100);
168         uint256 allocatedClanWarFund = (gooBankroll * clanDivPercent) / 100; // No daily snapshots needed for Clans (as below will also claim between the handful of clans)
169         gooBankroll -= (gooBankroll * (playerDivPercent + clanDivPercent)) / 100;  // % of pool daily
170 
171         uint256 numClans = clans.totalSupply();
172         uint256[] memory clanArmyPower = new uint256[](numClans);
173 
174         // Get total power from all clans
175         uint256 todaysTotalClanPower;
176         for (uint256 i = 1; i <= numClans; i++) {
177             clanArmyPower[i-1] = clans.clanTotalArmyPower(i);
178             todaysTotalClanPower += clanArmyPower[i-1];
179         }
180 
181         // Distribute goo divs to clans based on their relative power
182         for (i = 1; i <= numClans; i++) {
183             clans.depositGoo((allocatedClanWarFund * clanArmyPower[i-1]) / todaysTotalClanPower, i);
184         }
185 
186         nextSnapshotTime = now + 24 hours;
187     }
188 
189     function claimWarFundDividends(uint256 startSnapshot, uint256 endSnapShot) external {
190         require(startSnapshot <= endSnapShot);
191         require(startSnapshot >= lastWarFundClaim[msg.sender]);
192         require(endSnapShot < allocatedWarFundSnapshots.length);
193 
194         uint224 gooShare;
195         ArmyPower memory previousArmyPower = armyPowerSnapshots[msg.sender][lastWarFundClaim[msg.sender] - 1]; // Underflow won't be a problem as armyPowerSnapshots[][0xffffffff] = 0;
196         for (uint256 i = startSnapshot; i <= endSnapShot; i++) {
197 
198             // Slightly complex things by accounting for days/snapshots when user made no tx's
199             ArmyPower memory armyPowerDuringSnapshot = armyPowerSnapshots[msg.sender][i];
200             bool soldAllArmy = armyPowerZeroedSnapshots[msg.sender][i];
201             if (!soldAllArmy && armyPowerDuringSnapshot.attack == 0 && armyPowerDuringSnapshot.defense == 0) {
202                 armyPowerDuringSnapshot = previousArmyPower;
203             } else {
204                previousArmyPower = armyPowerDuringSnapshot;
205             }
206 
207             gooShare += (allocatedWarFundSnapshots[i] * (armyPowerDuringSnapshot.attack + armyPowerDuringSnapshot.defense)) / totalArmyPowerSnapshots[i];
208         }
209 
210 
211         ArmyPower memory endSnapshotArmyPower = armyPowerSnapshots[msg.sender][endSnapShot];
212         if (endSnapshotArmyPower.attack == 0 && endSnapshotArmyPower.defense == 0 && !armyPowerZeroedSnapshots[msg.sender][endSnapShot] && (previousArmyPower.attack + previousArmyPower.defense) > 0) {
213             armyPowerSnapshots[msg.sender][endSnapShot] = previousArmyPower; // Checkpoint for next claim
214         }
215 
216         lastWarFundClaim[msg.sender] = endSnapShot + 1;
217 
218         (uint224 clanFee, uint224 leaderFee, address leader, uint224 referalFee, address referer) = clans.getPlayerFees(msg.sender);
219         if (clanFee > 0) {
220             clanFee = (gooShare * clanFee) / 100; // Convert from percent to goo
221             leaderFee = (gooShare * leaderFee) / 100; // Convert from percent to goo
222             clans.mintGoo(msg.sender, clanFee);
223             goo.mintGoo(leaderFee, leader);
224         }
225         if (referer == address(0)) {
226             referalFee = 0;
227         } else if (referalFee > 0) {
228             referalFee = (gooShare * referalFee) / 100; // Convert from percent to goo
229             goo.mintGoo(referalFee, referer);
230         }
231         
232         goo.mintGoo(gooShare - (clanFee + leaderFee + referalFee), msg.sender);
233     }
234 
235     function getSnapshotDay() external view returns (uint256 snapshot) {
236         snapshot = allocatedWarFundSnapshots.length;
237     }
238 
239 }
240 
241 
242 contract GooToken {
243     function transfer(address to, uint256 tokens) external returns (bool);
244     function increasePlayersGooProduction(address player, uint256 increase) external;
245     function decreasePlayersGooProduction(address player, uint256 decrease) external;
246     function updatePlayersGooFromPurchase(address player, uint224 purchaseCost) external;
247     function updatePlayersGoo(address player) external;
248     function mintGoo(uint224 amount, address player) external;
249 }
250 
251 contract Clans {
252     mapping(uint256 => uint256) public clanTotalArmyPower;
253     function totalSupply() external view returns (uint256);
254     function depositGoo(uint256 amount, uint256 clanId) external;
255     function getPlayerFees(address player) external view returns (uint224 clansFee, uint224 leadersFee, address leader, uint224 referalsFee, address referer);
256     function getPlayersClanUpgrade(address player, uint256 upgradeClass) external view returns (uint224 upgradeGain);
257     function mintGoo(address player, uint256 amount) external;
258     function increaseClanPower(address player, uint256 amount) external;
259     function decreaseClanPower(address player, uint256 amount) external;
260 }
261 
262 contract Factories {
263     uint256 public constant MAX_SIZE = 40;
264     function getFactories(address player) external returns (uint256[]);
265     function addFactory(address player, uint8 position, uint256 unitId) external;
266 }
267 
268 
269 library SafeMath {
270 
271   /**
272   * @dev Multiplies two numbers, throws on overflow.
273   */
274   function mul(uint224 a, uint224 b) internal pure returns (uint224) {
275     if (a == 0) {
276       return 0;
277     }
278     uint224 c = a * b;
279     assert(c / a == b);
280     return c;
281   }
282 
283   /**
284   * @dev Integer division of two numbers, truncating the quotient.
285   */
286   function div(uint256 a, uint256 b) internal pure returns (uint256) {
287     // assert(b > 0); // Solidity automatically throws when dividing by 0
288     uint256 c = a / b;
289     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290     return c;
291   }
292 
293   /**
294   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
295   */
296   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297     assert(b <= a);
298     return a - b;
299   }
300 
301   /**
302   * @dev Adds two numbers, throws on overflow.
303   */
304   function add(uint256 a, uint256 b) internal pure returns (uint256) {
305     uint256 c = a + b;
306     assert(c >= a);
307     return c;
308   }
309 }
310 
311 
312 library SafeMath224 {
313 
314   /**
315   * @dev Multiplies two numbers, throws on overflow.
316   */
317   function mul(uint224 a, uint224 b) internal pure returns (uint224) {
318     if (a == 0) {
319       return 0;
320     }
321     uint224 c = a * b;
322     assert(c / a == b);
323     return c;
324   }
325 
326   /**
327   * @dev Integer division of two numbers, truncating the quotient.
328   */
329   function div(uint224 a, uint224 b) internal pure returns (uint224) {
330     // assert(b > 0); // Solidity automatically throws when dividing by 0
331     uint224 c = a / b;
332     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
333     return c;
334   }
335 
336   /**
337   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
338   */
339   function sub(uint224 a, uint224 b) internal pure returns (uint224) {
340     assert(b <= a);
341     return a - b;
342   }
343 
344   /**
345   * @dev Adds two numbers, throws on overflow.
346   */
347   function add(uint224 a, uint224 b) internal pure returns (uint224) {
348     uint224 c = a + b;
349     assert(c >= a);
350     return c;
351   }
352 }