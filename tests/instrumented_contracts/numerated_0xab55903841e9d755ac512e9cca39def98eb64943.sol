1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC721 interface
45  * @dev see https://github.com/ethereum/eips/issues/721
46  */
47 contract ERC721 {
48   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
49   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
50 
51   function balanceOf(address _owner) public view returns (uint256 _balance);
52   function ownerOf(uint256 _tokenId) public view returns (address _owner);
53   function transfer(address _to, uint256 _tokenId) public;
54   function approve(address _to, uint256 _tokenId) public;
55   function takeOwnership(uint256 _tokenId) public;
56 }
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63 
64   /**
65   * @dev Multiplies two numbers, throws on overflow.
66   */
67   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68     if (a == 0) {
69       return 0;
70     }
71     uint256 c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return c;
84   }
85 
86   /**
87   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 contract EtherIslands is Ownable, ERC721 {
105     using SafeMath for uint256;
106 
107     /*** EVENTS ***/
108     event NewIsland(uint256 tokenId, bytes32 name, address owner);
109     event IslandSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, bytes32 name);
110     event Transfer(address from, address to, uint256 tokenId);
111     event DividendsPaid(address to, uint256 amount, bytes32 divType);
112     event ShipsBought(uint256 tokenId, address owner);
113     event IslandAttacked(uint256 attackerId, uint256 targetId, uint256 treasuryStolen);
114     event TreasuryWithdrawn(uint256 tokenId);
115 
116     /*** STRUCTS ***/
117     struct Island {
118         bytes32 name;
119         address owner;
120         uint256 price;
121         uint256 treasury;
122         uint256 treasury_next_withdrawal_block;
123         uint256 previous_price;
124         uint256 attack_ships_count;
125         uint256 defense_ships_count;
126         uint256 transactions_count;
127         address approve_transfer_to;
128         address[2] previous_owners;
129     }
130 
131     struct IslandBattleStats {
132         uint256 attacks_won;
133         uint256 attacks_lost;
134         uint256 defenses_won;
135         uint256 defenses_lost;
136         uint256 treasury_stolen;
137         uint256 treasury_lost;
138         uint256 attack_cooldown;
139         uint256 defense_cooldown;
140     }
141 
142     /*** CONSTANTS ***/
143     string public constant NAME = "EtherIslands";
144     string public constant SYMBOL = "EIS";
145 
146     bool public maintenance = true;
147     uint256 islands_count;
148 
149     uint256 shipPrice = 0.01 ether;
150     uint256 withdrawalBlocksCooldown = 720;
151     uint256 battle_cooldown = 40;
152     address m_address = 0x9BB3364Baa5dbfcaa61ee0A79a9cA17359Fc7bBf;
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
166     }
167 
168     /** PUBLIC METHODS **/
169     function createIsland(bytes32 _name, uint256 _price, address _owner, uint256 _attack_ships_count, uint256 _defense_ships_count) public onlyOwner {
170         require(msg.sender != address(0));
171         _create_island(_name, _owner, _price, 0, _attack_ships_count, _defense_ships_count);
172     }
173 
174     function importIsland(bytes32 _name, address[3] _owners, uint256[7] _island_data, uint256[8] _island_battle_stats) public onlyOwner {
175         require(msg.sender != address(0));
176         _import_island(_name, _owners, _island_data, _island_battle_stats);
177     }
178 
179     function attackIsland(uint256 _attacker_id, uint256 _target_id) public payable {
180         require(maintenance == false);
181         Island storage attackerIsland = islands[_attacker_id];
182         IslandBattleStats storage attackerIslandBattleStats = islandBattleStats[_attacker_id];
183 
184         Island storage defenderIsland = islands[_target_id];
185         IslandBattleStats storage defenderIslandBattleStats = islandBattleStats[_target_id];
186 
187         require(attackerIsland.owner == msg.sender);
188         require(attackerIsland.owner != defenderIsland.owner);
189         require(msg.sender != address(0));
190         require(msg.value == 0);
191         require(block.number >= attackerIslandBattleStats.attack_cooldown);
192         require(block.number >= defenderIslandBattleStats.defense_cooldown);
193         require(attackerIsland.attack_ships_count > 0); // attacker must have at least 1 attack ship
194         require(attackerIsland.attack_ships_count > defenderIsland.defense_ships_count);
195 
196         uint256 goods_stolen = SafeMath.mul(SafeMath.div(defenderIsland.treasury, 100), 25);
197 
198         defenderIsland.treasury = SafeMath.sub(defenderIsland.treasury, goods_stolen);
199 
200         attackerIslandBattleStats.attacks_won++;
201         attackerIslandBattleStats.treasury_stolen = SafeMath.add(attackerIslandBattleStats.treasury_stolen, goods_stolen);
202 
203         defenderIslandBattleStats.defenses_lost++;
204         defenderIslandBattleStats.treasury_lost = SafeMath.add(defenderIslandBattleStats.treasury_lost, goods_stolen);
205 
206         uint256 cooldown_block = block.number + battle_cooldown;
207         attackerIslandBattleStats.attack_cooldown = cooldown_block;
208         defenderIslandBattleStats.defense_cooldown = cooldown_block;
209 
210         uint256 goods_to_treasury = SafeMath.mul(SafeMath.div(goods_stolen, 100), 75);
211 
212         attackerIsland.treasury = SafeMath.add(attackerIsland.treasury, goods_to_treasury);
213 
214         // 2% of attacker army and 10% of defender army is destroyed
215         attackerIsland.attack_ships_count = SafeMath.sub(attackerIsland.attack_ships_count, SafeMath.mul(SafeMath.div(attackerIsland.attack_ships_count, 100), 2));
216         defenderIsland.defense_ships_count = SafeMath.sub(defenderIsland.defense_ships_count, SafeMath.mul(SafeMath.div(defenderIsland.defense_ships_count, 100), 10));
217 
218         // Dividends
219         uint256 goods_for_current_owner = SafeMath.mul(SafeMath.div(goods_stolen, 100), 15);
220         uint256 goods_for_previous_owner_1 = SafeMath.mul(SafeMath.div(goods_stolen, 100), 6);
221         uint256 goods_for_previous_owner_2 = SafeMath.mul(SafeMath.div(goods_stolen, 100), 3);
222         uint256 goods_for_dev = SafeMath.mul(SafeMath.div(goods_stolen, 100), 1);
223 
224         attackerIsland.owner.transfer(goods_for_current_owner);
225         attackerIsland.previous_owners[0].transfer(goods_for_previous_owner_1);
226         attackerIsland.previous_owners[1].transfer(goods_for_previous_owner_2);
227 
228         //Split dev fee
229         m_address.transfer(SafeMath.mul(SafeMath.div(goods_for_dev, 100), 20));
230         owner.transfer(SafeMath.mul(SafeMath.div(goods_for_dev, 100), 80));
231 
232         IslandAttacked(_attacker_id, _target_id, goods_stolen);
233     }
234 
235     function buyShips(uint256 _island_id, uint256 _ships_to_buy, bool _is_attack_ships) public payable {
236         require(maintenance == false);
237         Island storage island = islands[_island_id];
238 
239         uint256 totalPrice = SafeMath.mul(_ships_to_buy, shipPrice);
240         require(island.owner == msg.sender);
241         require(msg.sender != address(0));
242         require(msg.value >= totalPrice);
243 
244         if (_is_attack_ships) {
245             island.attack_ships_count = SafeMath.add(island.attack_ships_count, _ships_to_buy);
246         } else {
247             island.defense_ships_count = SafeMath.add(island.defense_ships_count, _ships_to_buy);
248         }
249 
250         // Dividends
251         uint256 treasury_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 80);
252         uint256 dev_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 17);
253         uint256 previous_owner_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 2);
254         uint256 previous_owner2_div = SafeMath.mul(SafeMath.div(totalPrice, 100), 1);
255 
256         island.previous_owners[0].transfer(previous_owner_div);
257         //divs for 1st previous owner
258         island.previous_owners[1].transfer(previous_owner2_div);
259         //divs for 2nd previous owner
260         island.treasury = SafeMath.add(treasury_div, island.treasury);
261         // divs for treasury
262 
263         //Split dev fee
264         uint256 m_fee = SafeMath.mul(SafeMath.div(dev_div, 100), 20);
265         uint256 d_fee = SafeMath.mul(SafeMath.div(dev_div, 100), 80);
266         m_address.transfer(m_fee);
267         owner.transfer(d_fee);
268 
269         DividendsPaid(island.previous_owners[0], previous_owner_div, "buyShipPreviousOwner");
270         DividendsPaid(island.previous_owners[1], previous_owner2_div, "buyShipPreviousOwner2");
271 
272         ShipsBought(_island_id, island.owner);
273     }
274 
275     function withdrawTreasury(uint256 _island_id) public payable {
276         require(maintenance == false);
277         Island storage island = islands[_island_id];
278 
279         require(island.owner == msg.sender);
280         require(msg.sender != address(0));
281         require(island.treasury > 0);
282         require(block.number >= island.treasury_next_withdrawal_block);
283 
284         uint256 treasury_to_withdraw = SafeMath.mul(SafeMath.div(island.treasury, 100), 10);
285         uint256 treasury_for_previous_owner_1 = SafeMath.mul(SafeMath.div(treasury_to_withdraw, 100), 2);
286         uint256 treasury_for_previous_owner_2 = SafeMath.mul(SafeMath.div(treasury_to_withdraw, 100), 1);
287         uint256 treasury_for_previous_owners = SafeMath.add(treasury_for_previous_owner_2, treasury_for_previous_owner_1);
288         uint256 treasury_for_current_owner = SafeMath.sub(treasury_to_withdraw, treasury_for_previous_owners);
289 
290         island.owner.transfer(treasury_for_current_owner);
291         island.previous_owners[0].transfer(treasury_for_previous_owner_1);
292         island.previous_owners[1].transfer(treasury_for_previous_owner_2);
293 
294         island.treasury = SafeMath.sub(island.treasury, treasury_to_withdraw);
295         island.treasury_next_withdrawal_block = block.number + withdrawalBlocksCooldown;
296         //setting cooldown for next withdrawal
297 
298         DividendsPaid(island.previous_owners[0], treasury_for_previous_owner_1, "withdrawalPreviousOwner");
299         DividendsPaid(island.previous_owners[1], treasury_for_previous_owner_2, "withdrawalPreviousOwner2");
300         DividendsPaid(island.owner, treasury_for_current_owner, "withdrawalOwner");
301 
302         TreasuryWithdrawn(_island_id);
303     }
304 
305     function purchase(uint256 _island_id) public payable {
306         require(maintenance == false);
307         Island storage island = islands[_island_id];
308 
309         require(island.owner != msg.sender);
310         require(msg.sender != address(0));
311         require(msg.value >= island.price);
312 
313         uint256 excess = SafeMath.sub(msg.value, island.price);
314         if (island.previous_price > 0) {
315             uint256 owners_cut = SafeMath.mul(SafeMath.div(island.price, 160), 130);
316             uint256 treasury_cut = SafeMath.mul(SafeMath.div(island.price, 160), 18);
317             uint256 dev_fee = SafeMath.mul(SafeMath.div(island.price, 160), 7);
318             uint256 previous_owner_fee = SafeMath.mul(SafeMath.div(island.price, 160), 3);
319             uint256 previous_owner_fee2 = SafeMath.mul(SafeMath.div(island.price, 160), 2);
320 
321             island.previous_owners[0].transfer(previous_owner_fee);
322             //divs for 1st previous owner
323             island.previous_owners[1].transfer(previous_owner_fee2);
324             //divs for 2nd previous owner
325             island.treasury = SafeMath.add(treasury_cut, island.treasury);
326             // divs for treasury
327 
328             //Split dev fee
329             uint256 m_fee = SafeMath.mul(SafeMath.div(dev_fee, 100), 20);
330             uint256 d_fee = SafeMath.mul(SafeMath.div(dev_fee, 100), 80);
331             m_address.transfer(m_fee);
332             owner.transfer(d_fee);
333 
334             DividendsPaid(island.previous_owners[0], previous_owner_fee, "previousOwner");
335             DividendsPaid(island.previous_owners[1], previous_owner_fee2, "previousOwner2");
336             DividendsPaid(island.owner, owners_cut, "owner");
337             DividendsPaid(owner, dev_fee, "dev");
338 
339             if (island.owner != address(this)) {
340                 island.owner.transfer(owners_cut);
341                 //divs for current island owner
342             }
343         }
344 
345         island.previous_price = island.price;
346         island.treasury_next_withdrawal_block = block.number + withdrawalBlocksCooldown;
347         address _old_owner = island.owner;
348 
349         island.price = SafeMath.mul(SafeMath.div(island.price, 100), 160);
350 
351         //Change owners
352         island.previous_owners[1] = island.previous_owners[0];
353         island.previous_owners[0] = island.owner;
354         island.owner = msg.sender;
355         island.transactions_count++;
356 
357         ownerCount[_old_owner] -= 1;
358         ownerCount[island.owner] += 1;
359 
360         islandBattleStats[_island_id].attack_cooldown = block.number + battle_cooldown; // immunity for 10 mins
361         islandBattleStats[_island_id].defense_cooldown = block.number + battle_cooldown; // immunity for 10 mins
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
438     function getIslandPreviousOwners(uint256 _island_id) public view returns (
439         address[2] previous_owners
440     ) {
441         previous_owners = islands[_island_id].previous_owners;
442     }
443 
444     function getIslands() public view returns (uint256[], address[], uint256[], uint256[], uint256[], uint256[], uint256[]) {
445         uint256[] memory ids = new uint256[](islands_count);
446         address[] memory owners = new address[](islands_count);
447         uint256[] memory prices = new uint256[](islands_count);
448         uint256[] memory treasuries = new uint256[](islands_count);
449         uint256[] memory attack_ships_counts = new uint256[](islands_count);
450         uint256[] memory defense_ships_counts = new uint256[](islands_count);
451         uint256[] memory transactions_count = new uint256[](islands_count);
452         for (uint256 _id = 0; _id < islands_count; _id++) {
453             ids[_id] = _id;
454             owners[_id] = islands[_id].owner;
455             prices[_id] = islands[_id].price;
456             treasuries[_id] = islands[_id].treasury;
457             attack_ships_counts[_id] = islands[_id].attack_ships_count;
458             defense_ships_counts[_id] = islands[_id].defense_ships_count;
459             transactions_count[_id] = islands[_id].transactions_count;
460         }
461         return (ids, owners, prices, treasuries, attack_ships_counts, defense_ships_counts, transactions_count);
462     }
463 
464     /** PRIVATE METHODS **/
465     function _create_island(bytes32 _name, address _owner, uint256 _price, uint256 _previous_price, uint256 _attack_ships_count, uint256 _defense_ships_count) private {
466         islands[islands_count] = Island({
467             name : _name,
468             owner : _owner,
469             price : _price,
470             treasury : 0,
471             treasury_next_withdrawal_block : 0,
472             previous_price : _previous_price,
473             attack_ships_count : _attack_ships_count,
474             defense_ships_count : _defense_ships_count,
475             transactions_count : 0,
476             approve_transfer_to : address(0),
477             previous_owners : [_owner, _owner]
478             });
479 
480         islandBattleStats[islands_count] = IslandBattleStats({
481             attacks_won : 0,
482             attacks_lost : 0,
483             defenses_won : 0,
484             defenses_lost : 0,
485             treasury_stolen : 0,
486             treasury_lost : 0,
487             attack_cooldown : 0,
488             defense_cooldown : 0
489             });
490 
491         NewIsland(islands_count, _name, _owner);
492         Transfer(address(this), _owner, islands_count);
493         islands_count++;
494     }
495 
496     function _import_island(bytes32 _name, address[3] _owners, uint256[7] _island_data, uint256[8] _island_battle_stats) private {
497         islands[islands_count] = Island({
498             name : _name,
499             owner : _owners[0],
500             price : _island_data[0],
501             treasury : _island_data[1],
502             treasury_next_withdrawal_block : _island_data[2],
503             previous_price : _island_data[3],
504             attack_ships_count : _island_data[4],
505             defense_ships_count : _island_data[5],
506             transactions_count : _island_data[6],
507             approve_transfer_to : address(0),
508             previous_owners : [_owners[1], _owners[2]]
509             });
510 
511         islandBattleStats[islands_count] = IslandBattleStats({
512             attacks_won : _island_battle_stats[0],
513             attacks_lost : _island_battle_stats[1],
514             defenses_won : _island_battle_stats[2],
515             defenses_lost : _island_battle_stats[3],
516             treasury_stolen : _island_battle_stats[4],
517             treasury_lost : _island_battle_stats[5],
518             attack_cooldown : _island_battle_stats[6],
519             defense_cooldown : _island_battle_stats[7]
520             });
521 
522         NewIsland(islands_count, _name, _owners[0]);
523         Transfer(address(this), _owners[0], islands_count);
524         islands_count++;
525     }
526 
527     function _transfer(address _from, address _to, uint256 _island_id) private {
528         islands[_island_id].owner = _to;
529         islands[_island_id].approve_transfer_to = address(0);
530         ownerCount[_from] -= 1;
531         ownerCount[_to] += 1;
532         Transfer(_from, _to, _island_id);
533     }
534 
535     /*** ERC-721 compliance. ***/
536     function approve(address _to, uint256 _island_id) public {
537         require(msg.sender == islands[_island_id].owner);
538         islands[_island_id].approve_transfer_to = _to;
539         Approval(msg.sender, _to, _island_id);
540     }
541 
542     function ownerOf(uint256 _island_id) public view returns (address owner){
543         owner = islands[_island_id].owner;
544         require(owner != address(0));
545     }
546 
547     function takeOwnership(uint256 _island_id) public {
548         address oldOwner = islands[_island_id].owner;
549         require(msg.sender != address(0));
550         require(islands[_island_id].approve_transfer_to == msg.sender);
551         _transfer(oldOwner, msg.sender, _island_id);
552     }
553 
554     function transfer(address _to, uint256 _island_id) public {
555         require(msg.sender != address(0));
556         require(msg.sender == islands[_island_id].owner);
557         _transfer(msg.sender, _to, _island_id);
558     }
559 
560     function transferFrom(address _from, address _to, uint256 _island_id) public {
561         require(_from == islands[_island_id].owner);
562         require(islands[_island_id].approve_transfer_to == _to);
563         require(_to != address(0));
564         _transfer(_from, _to, _island_id);
565     }
566 
567     function upgradeContract(address _newContract) public onlyOwner {
568         _newContract.transfer(this.balance);
569     }
570 
571     function AddEth () public payable {}
572 }