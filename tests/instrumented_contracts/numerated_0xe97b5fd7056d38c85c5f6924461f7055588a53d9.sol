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
11  
12 interface ERC721 {
13     function totalSupply() external view returns (uint256 tokens);
14     function balanceOf(address owner) external view returns (uint256 balance);
15     function ownerOf(uint256 tokenId) external view returns (address owner);
16     function exists(uint256 tokenId) external view returns (bool tokenExists);
17     function approve(address to, uint256 tokenId) external;
18     function getApproved(uint256 tokenId) external view returns (address approvee);
19 
20     function transferFrom(address from, address to, uint256 tokenId) external;
21     function tokensOf(address owner) external view returns (uint256[] tokens);
22     //function tokenByIndex(uint256 index) external view returns (uint256 token);
23 
24     // Events
25     event Transfer(address from, address to, uint256 tokenId);
26     event Approval(address owner, address approved, uint256 tokenId);
27 }
28 
29 interface ApproveAndCallFallBack {
30     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
31 }
32 
33 
34 contract Clans is ERC721, ApproveAndCallFallBack {
35     using SafeMath for uint256;
36 
37     GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);
38     Army constant army = Army(0x98278eb74b388efd4d6fc81dd3f95b642ce53f2b);
39     WWGClanCoupons constant clanCoupons = WWGClanCoupons(0xe9fe4e530ebae235877289bd978f207ae0c8bb25); // For minting clans to initial owners (prelaunch buyers)
40 
41     string public constant name = "Goo Clan";
42     string public constant symbol = "GOOCLAN";
43     uint224 numClans;
44     address owner; // Minor management
45 
46     // ERC721 stuff
47     mapping (uint256 => address) public tokenOwner;
48     mapping (uint256 => address) public tokenApprovals;
49     mapping (address => uint256[]) public ownedTokens;
50     mapping(uint256 => uint256) public ownedTokensIndex;
51 
52     mapping(address => UserClan) public userClan;
53     mapping(uint256 => uint224) public clanFee;
54     mapping(uint256 => uint224) public leaderFee;
55     mapping(uint256 => uint256) public clanMembers;
56     mapping(uint256 => mapping(uint256 => uint224)) public clanUpgradesOwned;
57     mapping(uint256 => uint256) public clanGoo;
58     mapping(uint256 => address) public clanToken; // i.e. BNB
59     mapping(uint256 => uint256) public baseTokenDenomination; // base value for token gains i.e. 0.000001 BNB
60     mapping(uint256 => uint256) public clanTotalArmyPower;
61 
62     mapping(uint256 => uint224) public referalFee; // If invited to a clan how much % of player's divs go to referer
63     mapping(address => mapping(uint256 => address)) public clanReferer; // Address of who invited player to each clan
64 
65     mapping(uint256 => Upgrade) public upgradeList;
66     mapping(address => bool) operator;
67 
68     struct UserClan {
69         uint224 clanId;
70         uint32 clanJoinTime;
71     }
72 
73     struct Upgrade {
74         uint256 upgradeId;
75         uint224 gooCost;
76         uint224 upgradeGain;
77         uint256 upgradeClass;
78         uint256 prerequisiteUpgrade;
79     }
80 
81     // Events
82     event JoinedClan(uint256 clanId, address player, address referer);
83     event LeftClan(uint256 clanId, address player);
84 
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     function setOperator(address gameContract, bool isOperator) external {
90         require(msg.sender == owner);
91         operator[gameContract] = isOperator;
92     }
93 
94     function totalSupply() external view returns (uint256) {
95         return numClans;
96     }
97 
98     function balanceOf(address player) public view returns (uint256) {
99         return ownedTokens[player].length;
100     }
101 
102     function ownerOf(uint256 clanId) external view returns (address) {
103         return tokenOwner[clanId];
104     }
105 
106     function exists(uint256 clanId) public view returns (bool) {
107         return tokenOwner[clanId] != address(0);
108     }
109 
110     function approve(address to, uint256 clanId) external {
111         require(tokenOwner[clanId] == msg.sender);
112         tokenApprovals[clanId] = to;
113         emit Approval(msg.sender, to, clanId);
114     }
115 
116     function getApproved(uint256 clanId) external view returns (address) {
117         return tokenApprovals[clanId];
118     }
119 
120     function tokensOf(address player) external view returns (uint256[] tokens) {
121          return ownedTokens[player];
122     }
123 
124     function transferFrom(address from, address to, uint256 tokenId) public {
125         require(tokenApprovals[tokenId] == msg.sender || tokenOwner[tokenId] == msg.sender);
126 
127         joinClanPlayer(to, uint224(tokenId), 0); // uint224 won't overflow due to tokenOwner check in removeTokenFrom()
128         removeTokenFrom(from, tokenId);
129         addTokenTo(to, tokenId);
130 
131         delete tokenApprovals[tokenId]; // Clear approval
132         emit Transfer(from, to, tokenId);
133     }
134 
135     function safeTransferFrom(address from, address to, uint256 tokenId) public {
136         safeTransferFrom(from, to, tokenId, "");
137     }
138 
139     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
140         transferFrom(from, to, tokenId);
141         checkERC721Recieved(from, to, tokenId, data);
142     }
143 
144     function checkERC721Recieved(address from, address to, uint256 tokenId, bytes memory data) internal {
145         uint256 size;
146         assembly { size := extcodesize(to) }
147         if (size > 0) { // Recipient is contract so must confirm recipt
148             bytes4 successfullyRecieved = ERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data);
149             require(successfullyRecieved == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")));
150         }
151     }
152 
153     function removeTokenFrom(address from, uint256 tokenId) internal {
154         require(tokenOwner[tokenId] == from);
155         tokenOwner[tokenId] = address(0);
156 
157         uint256 tokenIndex = ownedTokensIndex[tokenId];
158         uint256 lastTokenIndex = ownedTokens[from].length.sub(1);
159         uint256 lastToken = ownedTokens[from][lastTokenIndex];
160 
161         ownedTokens[from][tokenIndex] = lastToken;
162         ownedTokens[from][lastTokenIndex] = 0;
163 
164         ownedTokens[from].length--;
165         ownedTokensIndex[tokenId] = 0;
166         ownedTokensIndex[lastToken] = tokenIndex;
167     }
168 
169     function addTokenTo(address to, uint256 tokenId) internal {
170         require(ownedTokens[to].length == 0); // Can't own multiple clans
171         tokenOwner[tokenId] = to;
172         ownedTokensIndex[tokenId] = ownedTokens[to].length;
173         ownedTokens[to].push(tokenId);
174     }
175 
176     function updateClanFees(uint224 newClanFee, uint224 newLeaderFee, uint224 newReferalFee, uint256 clanId) external {
177         require(msg.sender == tokenOwner[clanId]);
178         require(newClanFee <= 25); // 25% max fee
179         require(newReferalFee <= 10); // 10% max refs
180         require(newLeaderFee <= newClanFee); // Clan gets fair cut
181         clanFee[clanId] = newClanFee;
182         leaderFee[clanId] = newLeaderFee;
183         referalFee[clanId] = newReferalFee;
184     }
185 
186     function getPlayerFees(address player) external view returns (uint224 clansFee, uint224 leadersFee, address leader, uint224 referalsFee, address referer) {
187         uint256 usersClan = userClan[player].clanId;
188         clansFee = clanFee[usersClan];
189         leadersFee = leaderFee[usersClan];
190         leader = tokenOwner[usersClan];
191         referalsFee = referalFee[usersClan];
192         referer = clanReferer[player][usersClan];
193     }
194 
195     function getPlayersClanUpgrade(address player, uint256 upgradeClass) external view returns (uint224 upgradeGain) {
196         upgradeGain = upgradeList[clanUpgradesOwned[userClan[player].clanId][upgradeClass]].upgradeGain;
197     }
198 
199     function getClanUpgrade(uint256 clanId, uint256 upgradeClass) external view returns (uint224 upgradeGain) {
200         upgradeGain = upgradeList[clanUpgradesOwned[clanId][upgradeClass]].upgradeGain;
201     }
202 
203     // Convienence function
204     function getClanDetailsForAttack(address player, address target) external view returns (uint256 clanId, uint256 targetClanId, uint224 playerLootingBonus) {
205         clanId = userClan[player].clanId;
206         targetClanId = userClan[target].clanId;
207         playerLootingBonus = upgradeList[clanUpgradesOwned[clanId][3]].upgradeGain; // class 3 = looting bonus
208     }
209 
210     function joinClan(uint224 clanId, address referer) external {
211         require(exists(clanId));
212         joinClanPlayer(msg.sender, clanId, referer);
213     }
214 
215     // Allows smarter invites/referals in future
216     function joinClanFromInvite(address player, uint224 clanId, address referer) external {
217         require(operator[msg.sender]);
218         joinClanPlayer(player, clanId, referer);
219     }
220 
221     function joinClanPlayer(address player, uint224 clanId, address referer) internal {
222         require(ownedTokens[player].length == 0); // Owners can't join
223 
224         (uint80 attack, uint80 defense,) = army.getArmyPower(player);
225 
226         // Leave old clan
227         UserClan memory existingClan = userClan[player];
228         if (existingClan.clanId > 0) {
229             clanMembers[existingClan.clanId]--;
230             clanTotalArmyPower[existingClan.clanId] -= (attack + defense);
231             emit LeftClan(existingClan.clanId, player);
232         }
233 
234         if (referer != address(0) && referer != player) {
235             require(userClan[referer].clanId == clanId);
236             clanReferer[player][clanId] = referer;
237         }
238 
239         existingClan.clanId = clanId;
240         existingClan.clanJoinTime = uint32(now);
241 
242         clanMembers[clanId]++;
243         clanTotalArmyPower[clanId] += (attack + defense);
244         userClan[player] = existingClan;
245         emit JoinedClan(clanId, player, referer);
246     }
247 
248     function leaveClan() external {
249         require(ownedTokens[msg.sender].length == 0); // Owners can't leave
250 
251         UserClan memory usersClan = userClan[msg.sender];
252         require(usersClan.clanId > 0);
253 
254         (uint80 attack, uint80 defense,) = army.getArmyPower(msg.sender);
255         clanTotalArmyPower[usersClan.clanId] -= (attack + defense);
256 
257         clanMembers[usersClan.clanId]--;
258         delete userClan[msg.sender];
259         emit LeftClan(usersClan.clanId, msg.sender);
260 
261         // Cannot leave if player has unclaimed divs (edge case for clan fee abuse)
262         require(attack + defense == 0 || army.lastWarFundClaim(msg.sender) == army.getSnapshotDay());
263         require(usersClan.clanJoinTime + 24 hours < now);
264     }
265 
266     function mintClan(address recipient, uint224 referalPercent, address clanTokenAddress, uint256 baseTokenReward) external {
267         require(operator[msg.sender]);
268         require(ERC20(clanTokenAddress).totalSupply() > 0);
269 
270         numClans++;
271         uint224 clanId = numClans; // Starts from clanId 1
272 
273         // Add recipient to clan
274         joinClanPlayer(recipient, clanId, 0);
275 
276         require(tokenOwner[clanId] == address(0));
277         addTokenTo(recipient, clanId);
278         emit Transfer(address(0), recipient, clanId);
279 
280         // Store clan token
281         clanToken[clanId] = clanTokenAddress;
282         baseTokenDenomination[clanId] = baseTokenReward;
283         referalFee[clanId] = referalPercent;
284 
285         // Burn clan coupons from owner (prelaunch event)
286         if (clanCoupons.totalSupply() > 0) {
287             clanCoupons.burnCoupon(recipient, clanId);
288         }
289     }
290 
291     function addUpgrade(uint256 id, uint224 gooCost, uint224 upgradeGain, uint256 upgradeClass, uint256 prereq) external {
292         require(operator[msg.sender]);
293         upgradeList[id] = Upgrade(id, gooCost, upgradeGain, upgradeClass, prereq);
294     }
295 
296     // Incase an existing token becomes invalid (i.e. migrates away)
297     function updateClanToken(uint256 clanId, address newClanToken, bool shouldRetrieveOldTokens) external {
298         require(msg.sender == owner);
299         require(ERC20(newClanToken).totalSupply() > 0);
300 
301         if (shouldRetrieveOldTokens) {
302             ERC20(clanToken[clanId]).transferFrom(this, owner, ERC20(clanToken[clanId]).balanceOf(this));
303         }
304 
305         clanToken[clanId] = newClanToken;
306     }
307 
308     // Incase need to tweak/balance attacking rewards (i.e. token moons so not viable to restock at current level)
309     function updateClanTokenGain(uint256 clanId, uint256 baseTokenReward) external {
310         require(msg.sender == owner);
311         baseTokenDenomination[clanId] = baseTokenReward;
312     }
313 
314 
315     // Clan member goo deposits
316     function receiveApproval(address player, uint256 amount, address, bytes) external {
317         uint256 clanId = userClan[player].clanId;
318         require(exists(clanId));
319         require(msg.sender == address(goo));
320 
321         ERC20(msg.sender).transferFrom(player, address(0), amount);
322         clanGoo[clanId] += amount;
323     }
324 
325     function buyUpgrade(uint224 upgradeId) external {
326         uint256 clanId = userClan[msg.sender].clanId;
327         require(msg.sender == tokenOwner[clanId]);
328 
329         Upgrade memory upgrade = upgradeList[upgradeId];
330         require (upgrade.upgradeId > 0); // Valid upgrade
331 
332         uint256 upgradeClass = upgrade.upgradeClass;
333         uint256 latestOwned = clanUpgradesOwned[clanId][upgradeClass];
334         require(latestOwned < upgradeId); // Haven't already purchased
335         require(latestOwned >= upgrade.prerequisiteUpgrade); // Own prequisite
336 
337         // Clan discount
338         uint224 upgradeDiscount = clanUpgradesOwned[clanId][0]; // class 0 = upgrade discount
339         uint224 reducedUpgradeCost = upgrade.gooCost - ((upgrade.gooCost * upgradeDiscount) / 100);
340 
341         clanGoo[clanId] = clanGoo[clanId].sub(reducedUpgradeCost);
342         army.depositSpentGoo(reducedUpgradeCost); // Transfer to goo bankroll
343 
344         clanUpgradesOwned[clanId][upgradeClass] = upgradeId;
345     }
346 
347     // Goo from divs etc.
348     function depositGoo(uint256 amount, uint256 clanId) external {
349         require(operator[msg.sender]);
350         require(exists(clanId));
351         clanGoo[clanId] += amount;
352     }
353 
354 
355     function increaseClanPower(address player, uint256 amount) external {
356         require(operator[msg.sender]);
357 
358         uint256 clanId = userClan[player].clanId;
359         if (clanId > 0) {
360             clanTotalArmyPower[clanId] += amount;
361         }
362     }
363 
364     function decreaseClanPower(address player, uint256 amount) external {
365         require(operator[msg.sender]);
366 
367         uint256 clanId = userClan[player].clanId;
368         if (clanId > 0) {
369             clanTotalArmyPower[clanId] -= amount;
370         }
371     }
372 
373 
374     function stealGoo(address attacker, uint256 playerClanId, uint256 enemyClanId, uint80 lootingPower) external returns(uint256) {
375         require(operator[msg.sender]);
376 
377         uint224 enemyGoo = uint224(clanGoo[enemyClanId]);
378         uint224 enemyGooStolen = (lootingPower > enemyGoo) ? enemyGoo : lootingPower;
379 
380         clanGoo[enemyClanId] = clanGoo[enemyClanId].sub(enemyGooStolen);
381 
382         uint224 clansShare = (enemyGooStolen * clanFee[playerClanId]) / 100;
383         uint224 referersFee = referalFee[playerClanId];
384         address referer = clanReferer[attacker][playerClanId];
385 
386         if (clansShare > 0 || (referersFee > 0 && referer != address(0))) {
387             uint224 leaderShare = (enemyGooStolen * leaderFee[playerClanId]) / 100;
388 
389             uint224 refsShare;
390             if (referer != address(0)) {
391                 refsShare = (enemyGooStolen * referersFee) / 100;
392                 goo.mintGoo(refsShare, referer);
393             }
394 
395             clanGoo[playerClanId] += clansShare;
396             goo.mintGoo(leaderShare, tokenOwner[playerClanId]);
397             goo.mintGoo(enemyGooStolen - (clansShare + leaderShare + refsShare), attacker);
398         } else {
399             goo.mintGoo(enemyGooStolen, attacker);
400         }
401         return enemyGooStolen;
402     }
403 
404 
405     function rewardTokens(address attacker, uint256 playerClanId, uint80 lootingPower) external returns(uint256) {
406         require(operator[msg.sender]);
407 
408         uint256 amount = baseTokenDenomination[playerClanId] * lootingPower;
409         ERC20(clanToken[playerClanId]).transfer(attacker, amount);
410         return amount;
411 
412     }
413 
414     // Daily clan dividends
415     function mintGoo(address player, uint256 amount) external {
416         require(operator[msg.sender]);
417         clanGoo[userClan[player].clanId] += amount;
418     }
419 
420 }
421 
422 contract ERC20 {
423     function transferFrom(address from, address to, uint tokens) external returns (bool success);
424     function transfer(address to, uint tokens) external returns (bool success);
425     function totalSupply() external constant returns (uint);
426     function balanceOf(address tokenOwner) external constant returns (uint balance);
427 }
428 
429 contract GooToken {
430     function mintGoo(uint224 amount, address player) external;
431     function updatePlayersGooFromPurchase(address player, uint224 purchaseCost) external;
432 }
433 
434 contract Army {
435     mapping(address => uint256) public lastWarFundClaim; // Days (snapshot number)
436     function depositSpentGoo(uint224 amount) external;
437     function getArmyPower(address player) external view returns (uint80, uint80, uint80);
438     function getSnapshotDay() external view returns (uint256 snapshot);
439 }
440 
441 contract WWGClanCoupons {
442     function totalSupply() external view returns (uint256);
443     function burnCoupon(address clanOwner, uint256 tokenId) external;
444 }
445 
446 contract ERC721Receiver {
447     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external returns(bytes4);
448 }
449 
450 
451 
452 
453 
454 
455 
456 
457 
458 library SafeMath {
459 
460   /**
461   * @dev Multiplies two numbers, throws on overflow.
462   */
463   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
464     if (a == 0) {
465       return 0;
466     }
467     uint256 c = a * b;
468     assert(c / a == b);
469     return c;
470   }
471 
472   /**
473   * @dev Integer division of two numbers, truncating the quotient.
474   */
475   function div(uint256 a, uint256 b) internal pure returns (uint256) {
476     // assert(b > 0); // Solidity automatically throws when dividing by 0
477     uint256 c = a / b;
478     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
479     return c;
480   }
481 
482   /**
483   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
484   */
485   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
486     assert(b <= a);
487     return a - b;
488   }
489 
490   /**
491   * @dev Adds two numbers, throws on overflow.
492   */
493   function add(uint256 a, uint256 b) internal pure returns (uint256) {
494     uint256 c = a + b;
495     assert(c >= a);
496     return c;
497   }
498 }