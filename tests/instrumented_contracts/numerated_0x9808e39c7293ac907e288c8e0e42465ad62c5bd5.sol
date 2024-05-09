1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 /**
91  * @title ERC721 interface
92  * @dev see https://github.com/ethereum/eips/issues/721
93  */
94 contract ERC721 {
95   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
96   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
97 
98   function balanceOf(address _owner) public view returns (uint256 _balance);
99   function ownerOf(uint256 _tokenId) public view returns (address _owner);
100   function transfer(address _to, uint256 _tokenId) public;
101   function approve(address _to, uint256 _tokenId) public;
102   function takeOwnership(uint256 _tokenId) public;
103 }
104 
105 contract EtherIslands is Ownable, ERC721 {
106     using SafeMath for uint256;
107 
108     /*** EVENTS ***/
109     event NewIsland(uint256 tokenId, bytes32 name, address owner);
110     event IslandSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, bytes32 name);
111     event Transfer(address from, address to, uint256 tokenId);
112     event DividendsPaid(address to, uint256 amount, bytes32 divType);
113     event ShipsBought(uint256 tokenId, address owner);
114     event IslandAttacked(uint256 attackerId, uint256 targetId);
115     event TreasuryWithdrawn(uint256 tokenId);
116 
117     /*** STRUCTS ***/
118     struct Island {
119         bytes32 name;
120         address owner;
121         uint256 price;
122         uint256 treasury;
123         uint256 treasury_next_withdrawal_block;
124         uint256 previous_price;
125         uint256 attack_ships_count;
126         uint256 defense_ships_count;
127         uint256 transactions_count;
128         address approve_transfer_to;
129         address[2] previous_owners;
130     }
131 
132     struct IslandBattleStats {
133         uint256 attacks_won;
134         uint256 attacks_lost;
135         uint256 defenses_won;
136         uint256 defenses_lost;
137         uint256 treasury_stolen;
138         uint256 treasury_lost;
139         uint256 attack_cooldown;
140         uint256 defense_cooldown;
141     }
142 
143     /*** CONSTANTS ***/
144     string public constant NAME = "EtherIslands";
145     string public constant SYMBOL = "EIS";
146 
147     bool public maintenance = true;
148     uint256 islands_count;
149 
150     uint256 shipPrice = 0.01 ether;
151     uint256 withdrawalBlocksCooldown = 100;
152     address m_address = 0xd17e2bFE196470A9fefb567e8f5992214EB42F24;
153 
154     mapping(address => uint256) private ownerCount;
155     mapping(uint256 => Island) private islands;
156     mapping(uint256 => IslandBattleStats) private islandBattleStats;
157 
158     /*** DEFAULT METHODS ***/
159     function symbol() public pure returns (string) {return SYMBOL;}
160 
161     function name() public pure returns (string) {return NAME;}
162 
163     function implementsERC721() public pure returns (bool) {return true;}
164 
165     function EtherIslands() public {
166         _create_island("Santorini", msg.sender, 0.001 ether, 0, 0, 0);
167         _create_island("Seychelles", msg.sender, 0.001 ether, 0, 0, 0);
168         _create_island("Palawan", msg.sender, 0.001 ether, 0, 0, 0);
169         _create_island("The Cook Islands", msg.sender, 0.001 ether, 0, 0, 0);
170         _create_island("Bora Bora", msg.sender, 0.001 ether, 0, 0, 0);
171         _create_island("Maldives", msg.sender, 0.001 ether, 0, 0, 0);
172     }
173 
174     /** PUBLIC METHODS **/
175     function createIsland(bytes32 _name, uint256 _price, address _owner, uint256 _attack_ships_count, uint256 _defense_ships_count) public onlyOwner {
176         require(msg.sender != address(0));
177         _create_island(_name, _owner, _price, 0, _attack_ships_count, _defense_ships_count);
178     }
179 
180     function attackIsland(uint256 _attacker_id, uint256 _target_id) public payable {
181         require(maintenance == false);
182         Island storage attackerIsland = islands[_attacker_id];
183         IslandBattleStats storage attackerIslandBattleStats = islandBattleStats[_attacker_id];
184 
185         Island storage defenderIsland = islands[_target_id];
186         IslandBattleStats storage defenderIslandBattleStats = islandBattleStats[_target_id];
187 
188         require(attackerIsland.owner == msg.sender);
189         require(attackerIsland.owner != defenderIsland.owner);
190         require(msg.sender != address(0));
191         require(msg.value == 0);
192         require(block.number >= attackerIslandBattleStats.attack_cooldown);
193         require(block.number >= defenderIslandBattleStats.defense_cooldown);
194         require(attackerIsland.attack_ships_count > 0); // attacker must have at least 1 attack ship
195         require(attackerIsland.attack_ships_count > defenderIsland.defense_ships_count);
196 
197         uint256 goods_stolen = SafeMath.mul(SafeMath.div(defenderIsland.treasury, 100), 75);
198 
199         defenderIsland.treasury = SafeMath.sub(defenderIsland.treasury, goods_stolen);
200 
201         attackerIslandBattleStats.attacks_won++;
202         attackerIslandBattleStats.treasury_stolen = SafeMath.add(attackerIslandBattleStats.treasury_stolen, goods_stolen);
203 
204         defenderIslandBattleStats.defenses_lost++;
205         defenderIslandBattleStats.treasury_lost = SafeMath.add(defenderIslandBattleStats.treasury_lost, goods_stolen);
206 
207         uint256 cooldown_block = block.number + 20;
208         attackerIslandBattleStats.attack_cooldown = cooldown_block;
209         defenderIslandBattleStats.defense_cooldown = cooldown_block;
210 
211         uint256 goods_to_treasury = SafeMath.mul(SafeMath.div(goods_stolen, 100), 75);
212 
213         attackerIsland.treasury = SafeMath.add(attackerIsland.treasury, goods_to_treasury);
214 
215         // 2% of attacker army and 10% of defender army is destroyed
216         attackerIsland.attack_ships_count = SafeMath.sub(attackerIsland.attack_ships_count, SafeMath.mul(SafeMath.div(attackerIsland.attack_ships_count, 100), 2));
217         defenderIsland.defense_ships_count = SafeMath.sub(defenderIsland.defense_ships_count, SafeMath.mul(SafeMath.div(defenderIsland.defense_ships_count, 100), 10));
218 
219         // Dividends
220         uint256 goods_for_current_owner = SafeMath.mul(SafeMath.div(goods_stolen, 100), 15);
221         uint256 goods_for_previous_owner_1 = SafeMath.mul(SafeMath.div(goods_stolen, 100), 6);
222         uint256 goods_for_previous_owner_2 = SafeMath.mul(SafeMath.div(goods_stolen, 100), 3);
223         uint256 goods_for_dev = SafeMath.mul(SafeMath.div(goods_stolen, 100), 1);
224 
225         attackerIsland.owner.transfer(goods_for_current_owner);
226         attackerIsland.previous_owners[0].transfer(goods_for_previous_owner_1);
227         attackerIsland.previous_owners[1].transfer(goods_for_previous_owner_2);
228 
229         //Split dev fee
230         m_address.transfer(SafeMath.mul(SafeMath.div(goods_for_dev, 100), 20));
231         owner.transfer(SafeMath.mul(SafeMath.div(goods_for_dev, 100), 80));
232 
233         IslandAttacked(_attacker_id, _target_id);
234     }
235 
236     function buyShips(uint256 _island_id, uint256 _ships_to_buy, bool _is_attack_ships) public payable {
237         require(maintenance == false);
238         Island storage island = islands[_island_id];
239 
240         uint256 totalPrice = SafeMath.mul(_ships_to_buy, shipPrice);
241         require(island.owner == msg.sender);
242         require(msg.sender != address(0));
243         require(msg.value >= totalPrice);
244 
245         if (_is_attack_ships) {
246             island.attack_ships_count = SafeMath.add(island.attack_ships_count, _ships_to_buy);
247         } else {
248             island.defense_ships_count = SafeMath.add(island.defense_ships_count, _ships_to_buy);
249         }
250 
251         // Dividends
252         uint256 treasury_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 80);
253         uint256 dev_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 17);
254         uint256 previous_owner_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 2);
255         uint256 previous_owner2_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 1);
256 
257         island.previous_owners[0].transfer(previous_owner_div);
258         //divs for 1st previous owner
259         island.previous_owners[1].transfer(previous_owner2_div);
260         //divs for 2nd previous owner
261         island.treasury = SafeMath.add(treasury_div, island.treasury);
262         // divs for treasury
263 
264         //Split dev fee
265         uint256 m_fee = SafeMath.mul(SafeMath.div(dev_div, 100), 20);
266         uint256 d_fee = SafeMath.mul(SafeMath.div(dev_div, 100), 80);
267         m_address.transfer(m_fee);
268         owner.transfer(d_fee);
269 
270         DividendsPaid(island.previous_owners[0], previous_owner_div, "buyShipPreviousOwner");
271         DividendsPaid(island.previous_owners[1], previous_owner2_div, "buyShipPreviousOwner2");
272 
273         ShipsBought(_island_id, island.owner);
274     }
275 
276     function withdrawTreasury(uint256 _island_id) public payable {
277         require(maintenance == false);
278         Island storage island = islands[_island_id];
279 
280         require(island.owner == msg.sender);
281         require(msg.sender != address(0));
282         require(island.treasury > 0);
283         require(block.number >= island.treasury_next_withdrawal_block);
284 
285         uint256 treasury_to_withdraw = SafeMath.mul(SafeMath.div(island.treasury, 100), 10);
286         uint256 treasury_for_previous_owner_1 = SafeMath.mul(SafeMath.div(treasury_to_withdraw, 100), 2);
287         uint256 treasury_for_previous_owner_2 = SafeMath.mul(SafeMath.div(treasury_to_withdraw, 100), 1);
288         uint256 treasury_for_previous_owners = SafeMath.add(treasury_for_previous_owner_2, treasury_for_previous_owner_1);
289         uint256 treasury_for_current_owner = SafeMath.sub(treasury_to_withdraw, treasury_for_previous_owners);
290 
291         island.owner.transfer(treasury_for_current_owner);
292         island.previous_owners[0].transfer(treasury_for_previous_owner_1);
293         island.previous_owners[1].transfer(treasury_for_previous_owner_2);
294 
295         island.treasury = SafeMath.sub(island.treasury, treasury_to_withdraw);
296         island.treasury_next_withdrawal_block = block.number + withdrawalBlocksCooldown;
297         //setting cooldown for next withdrawal
298 
299         DividendsPaid(island.previous_owners[0], treasury_for_previous_owner_1, "withdrawalPreviousOwner");
300         DividendsPaid(island.previous_owners[1], treasury_for_previous_owner_2, "withdrawalPreviousOwner2");
301         DividendsPaid(island.owner, treasury_for_current_owner, "withdrawalOwner");
302 
303         TreasuryWithdrawn(_island_id);
304     }
305 
306     function purchase(uint256 _island_id) public payable {
307         require(maintenance == false);
308         Island storage island = islands[_island_id];
309 
310         require(island.owner != msg.sender);
311         require(msg.sender != address(0));
312         require(msg.value >= island.price);
313 
314         uint256 excess = SafeMath.sub(msg.value, island.price);
315         if (island.previous_price > 0) {
316             uint256 owners_cut = SafeMath.mul(SafeMath.div(island.price, 160), 130);
317             uint256 treasury_cut = SafeMath.mul(SafeMath.div(island.price, 160), 18);
318             uint256 dev_fee = SafeMath.mul(SafeMath.div(island.price, 160), 7);
319             uint256 previous_owner_fee = SafeMath.mul(SafeMath.div(island.price, 160), 3);
320             uint256 previous_owner_fee2 = SafeMath.mul(SafeMath.div(island.price, 160), 2);
321 
322             if (island.owner != address(this)) {
323                 island.owner.transfer(owners_cut);
324                 //divs for current island owner
325             }
326 
327             island.previous_owners[0].transfer(previous_owner_fee);
328             //divs for 1st previous owner
329             island.previous_owners[1].transfer(previous_owner_fee2);
330             //divs for 2nd previous owner
331             island.treasury = SafeMath.add(treasury_cut, island.treasury);
332             // divs for treasury
333 
334             //Split dev fee
335             uint256 m_fee = SafeMath.mul(SafeMath.div(dev_fee, 100), 20);
336             uint256 d_fee = SafeMath.mul(SafeMath.div(dev_fee, 100), 80);
337             m_address.transfer(m_fee);
338             owner.transfer(d_fee);
339 
340             DividendsPaid(island.previous_owners[0], previous_owner_fee, "previousOwner");
341             DividendsPaid(island.previous_owners[1], previous_owner_fee2, "previousOwner2");
342             DividendsPaid(island.owner, owners_cut, "owner");
343             DividendsPaid(owner, dev_fee, "dev");
344         } else {
345             island.owner.transfer(msg.value);
346         }
347 
348         island.previous_price = island.price;
349         island.treasury_next_withdrawal_block = block.number + withdrawalBlocksCooldown;
350         address _old_owner = island.owner;
351 
352         island.price = SafeMath.mul(SafeMath.div(island.price, 100), 160);
353 
354         //Change owners
355         island.previous_owners[1] = island.previous_owners[0];
356         island.previous_owners[0] = island.owner;
357         island.owner = msg.sender;
358         island.transactions_count++;
359 
360         ownerCount[_old_owner] -= 1;
361         ownerCount[island.owner] += 1;
362 
363         Transfer(_old_owner, island.owner, _island_id);
364         IslandSold(_island_id, island.previous_price, island.price, _old_owner, island.owner, island.name);
365 
366         msg.sender.transfer(excess);
367         //returning excess
368     }
369 
370     function onMaintenance() public onlyOwner {
371         require(msg.sender != address(0));
372         maintenance = true;
373     }
374 
375     function offMaintenance() public onlyOwner {
376         require(msg.sender != address(0));
377         maintenance = false;
378     }
379 
380     function totalSupply() public view returns (uint256 total) {
381         return islands_count;
382     }
383 
384     function balanceOf(address _owner) public view returns (uint256 balance) {
385         return ownerCount[_owner];
386     }
387 
388     function priceOf(uint256 _island_id) public view returns (uint256 price) {
389         return islands[_island_id].price;
390     }
391 
392     function getIslandBattleStats(uint256 _island_id) public view returns (
393         uint256 id,
394         uint256 attacks_won,
395         uint256 attacks_lost,
396         uint256 defenses_won,
397         uint256 defenses_lost,
398         uint256 treasury_stolen,
399         uint256 treasury_lost,
400         uint256 attack_cooldown,
401         uint256 defense_cooldown
402     ) {
403         id = _island_id;
404         attacks_won = islandBattleStats[_island_id].attacks_won;
405         attacks_lost = islandBattleStats[_island_id].attacks_lost;
406         defenses_won = islandBattleStats[_island_id].defenses_won;
407         defenses_lost = islandBattleStats[_island_id].defenses_lost;
408         treasury_stolen = islandBattleStats[_island_id].treasury_stolen;
409         treasury_lost = islandBattleStats[_island_id].treasury_lost;
410         attack_cooldown = islandBattleStats[_island_id].attack_cooldown;
411         defense_cooldown = islandBattleStats[_island_id].defense_cooldown;
412     }
413 
414     function getIsland(uint256 _island_id) public view returns (
415         uint256 id,
416         bytes32 island_name,
417         address owner,
418         uint256 price,
419         uint256 treasury,
420         uint256 treasury_next_withdrawal_block,
421         uint256 previous_price,
422         uint256 attack_ships_count,
423         uint256 defense_ships_count,
424         uint256 transactions_count
425     ) {
426         id = _island_id;
427         island_name = islands[_island_id].name;
428         owner = islands[_island_id].owner;
429         price = islands[_island_id].price;
430         treasury = islands[_island_id].treasury;
431         treasury_next_withdrawal_block = islands[_island_id].treasury_next_withdrawal_block;
432         previous_price = islands[_island_id].previous_price;
433         attack_ships_count = islands[_island_id].attack_ships_count;
434         defense_ships_count = islands[_island_id].defense_ships_count;
435         transactions_count = islands[_island_id].transactions_count;
436     }
437 
438     function getIslands() public view returns (uint256[], address[], uint256[], uint256[], uint256[], uint256[], uint256[]) {
439         uint256[] memory ids = new uint256[](islands_count);
440         address[] memory owners = new address[](islands_count);
441         uint256[] memory prices = new uint256[](islands_count);
442         uint256[] memory treasuries = new uint256[](islands_count);
443         uint256[] memory attack_ships_counts = new uint256[](islands_count);
444         uint256[] memory defense_ships_counts = new uint256[](islands_count);
445         uint256[] memory transactions_count = new uint256[](islands_count);
446         for (uint256 _id = 0; _id < islands_count; _id++) {
447             ids[_id] = _id;
448             owners[_id] = islands[_id].owner;
449             prices[_id] = islands[_id].price;
450             treasuries[_id] = islands[_id].treasury;
451             attack_ships_counts[_id] = islands[_id].attack_ships_count;
452             defense_ships_counts[_id] = islands[_id].defense_ships_count;
453             transactions_count[_id] = islands[_id].transactions_count;
454         }
455         return (ids, owners, prices, treasuries, attack_ships_counts, defense_ships_counts, transactions_count);
456     }
457 
458     /** PRIVATE METHODS **/
459     function _create_island(bytes32 _name, address _owner, uint256 _price, uint256 _previous_price, uint256 _attack_ships_count, uint256 _defense_ships_count) private {
460         islands[islands_count] = Island({
461             name : _name,
462             owner : _owner,
463             price : _price,
464             treasury : 0,
465             treasury_next_withdrawal_block : 0,
466             previous_price : _previous_price,
467             attack_ships_count : _attack_ships_count,
468             defense_ships_count : _defense_ships_count,
469             transactions_count : 0,
470             approve_transfer_to : address(0),
471             previous_owners : [_owner, _owner]
472             });
473 
474         islandBattleStats[islands_count] = IslandBattleStats({
475             attacks_won : 0,
476             attacks_lost : 0,
477             defenses_won : 0,
478             defenses_lost : 0,
479             treasury_stolen : 0,
480             treasury_lost : 0,
481             attack_cooldown : 0,
482             defense_cooldown : 0
483             });
484 
485         NewIsland(islands_count, _name, _owner);
486         Transfer(address(this), _owner, islands_count);
487         islands_count++;
488     }
489 
490     function _transfer(address _from, address _to, uint256 _island_id) private {
491         islands[_island_id].owner = _to;
492         islands[_island_id].approve_transfer_to = address(0);
493         ownerCount[_from] -= 1;
494         ownerCount[_to] += 1;
495         Transfer(_from, _to, _island_id);
496     }
497 
498     /*** ERC-721 compliance. ***/
499     function approve(address _to, uint256 _island_id) public {
500         require(msg.sender == islands[_island_id].owner);
501         islands[_island_id].approve_transfer_to = _to;
502         Approval(msg.sender, _to, _island_id);
503     }
504 
505     function ownerOf(uint256 _island_id) public view returns (address owner){
506         owner = islands[_island_id].owner;
507         require(owner != address(0));
508     }
509 
510     function takeOwnership(uint256 _island_id) public {
511         address oldOwner = islands[_island_id].owner;
512         require(msg.sender != address(0));
513         require(islands[_island_id].approve_transfer_to == msg.sender);
514         _transfer(oldOwner, msg.sender, _island_id);
515     }
516 
517     function transfer(address _to, uint256 _island_id) public {
518         require(msg.sender != address(0));
519         require(msg.sender == islands[_island_id].owner);
520         _transfer(msg.sender, _to, _island_id);
521     }
522 
523     function transferFrom(address _from, address _to, uint256 _island_id) public {
524         require(_from == islands[_island_id].owner);
525         require(islands[_island_id].approve_transfer_to == _to);
526         require(_to != address(0));
527         _transfer(_from, _to, _island_id);
528     }
529 
530     function upgradeContract(address _newContract) public onlyOwner {
531         _newContract.transfer(this.balance);
532     }
533 }