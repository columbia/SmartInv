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
321             if (island.owner != address(this)) {
322                 island.owner.transfer(owners_cut);
323                 //divs for current island owner
324             }
325 
326             island.previous_owners[0].transfer(previous_owner_fee);
327             //divs for 1st previous owner
328             island.previous_owners[1].transfer(previous_owner_fee2);
329             //divs for 2nd previous owner
330             island.treasury = SafeMath.add(treasury_cut, island.treasury);
331             // divs for treasury
332 
333             //Split dev fee
334             uint256 m_fee = SafeMath.mul(SafeMath.div(dev_fee, 100), 20);
335             uint256 d_fee = SafeMath.mul(SafeMath.div(dev_fee, 100), 80);
336             m_address.transfer(m_fee);
337             owner.transfer(d_fee);
338 
339             DividendsPaid(island.previous_owners[0], previous_owner_fee, "previousOwner");
340             DividendsPaid(island.previous_owners[1], previous_owner_fee2, "previousOwner2");
341             DividendsPaid(island.owner, owners_cut, "owner");
342             DividendsPaid(owner, dev_fee, "dev");
343         } else {
344             island.owner.transfer(msg.value);
345         }
346 
347         island.previous_price = island.price;
348         island.treasury_next_withdrawal_block = block.number + withdrawalBlocksCooldown;
349         address _old_owner = island.owner;
350 
351         island.price = SafeMath.mul(SafeMath.div(island.price, 100), 160);
352 
353         //Change owners
354         island.previous_owners[1] = island.previous_owners[0];
355         island.previous_owners[0] = island.owner;
356         island.owner = msg.sender;
357         island.transactions_count++;
358 
359         ownerCount[_old_owner] -= 1;
360         ownerCount[island.owner] += 1;
361 
362         islandBattleStats[_island_id].attack_cooldown = battle_cooldown; // immunity for 10 mins
363         islandBattleStats[_island_id].defense_cooldown = battle_cooldown; // immunity for 10 mins
364 
365         Transfer(_old_owner, island.owner, _island_id);
366         IslandSold(_island_id, island.previous_price, island.price, _old_owner, island.owner, island.name);
367 
368         msg.sender.transfer(excess);
369         //returning excess
370     }
371 
372     function onMaintenance() public onlyOwner {
373         require(msg.sender != address(0));
374         maintenance = true;
375     }
376 
377     function offMaintenance() public onlyOwner {
378         require(msg.sender != address(0));
379         maintenance = false;
380     }
381 
382     function totalSupply() public view returns (uint256 total) {
383         return islands_count;
384     }
385 
386     function balanceOf(address _owner) public view returns (uint256 balance) {
387         return ownerCount[_owner];
388     }
389 
390     function priceOf(uint256 _island_id) public view returns (uint256 price) {
391         return islands[_island_id].price;
392     }
393 
394     function getIslandBattleStats(uint256 _island_id) public view returns (
395         uint256 id,
396         uint256 attacks_won,
397         uint256 attacks_lost,
398         uint256 defenses_won,
399         uint256 defenses_lost,
400         uint256 treasury_stolen,
401         uint256 treasury_lost,
402         uint256 attack_cooldown,
403         uint256 defense_cooldown
404     ) {
405         id = _island_id;
406         attacks_won = islandBattleStats[_island_id].attacks_won;
407         attacks_lost = islandBattleStats[_island_id].attacks_lost;
408         defenses_won = islandBattleStats[_island_id].defenses_won;
409         defenses_lost = islandBattleStats[_island_id].defenses_lost;
410         treasury_stolen = islandBattleStats[_island_id].treasury_stolen;
411         treasury_lost = islandBattleStats[_island_id].treasury_lost;
412         attack_cooldown = islandBattleStats[_island_id].attack_cooldown;
413         defense_cooldown = islandBattleStats[_island_id].defense_cooldown;
414     }
415 
416     function getIsland(uint256 _island_id) public view returns (
417         uint256 id,
418         bytes32 island_name,
419         address owner,
420         uint256 price,
421         uint256 treasury,
422         uint256 treasury_next_withdrawal_block,
423         uint256 previous_price,
424         uint256 attack_ships_count,
425         uint256 defense_ships_count,
426         uint256 transactions_count
427     ) {
428         id = _island_id;
429         island_name = islands[_island_id].name;
430         owner = islands[_island_id].owner;
431         price = islands[_island_id].price;
432         treasury = islands[_island_id].treasury;
433         treasury_next_withdrawal_block = islands[_island_id].treasury_next_withdrawal_block;
434         previous_price = islands[_island_id].previous_price;
435         attack_ships_count = islands[_island_id].attack_ships_count;
436         defense_ships_count = islands[_island_id].defense_ships_count;
437         transactions_count = islands[_island_id].transactions_count;
438     }
439 
440     function getIslandPreviousOwners(uint256 _island_id) public view returns (
441         address[2] previous_owners
442     ) {
443         previous_owners = islands[_island_id].previous_owners;
444     }
445 
446     function getIslands() public view returns (uint256[], address[], uint256[], uint256[], uint256[], uint256[], uint256[]) {
447         uint256[] memory ids = new uint256[](islands_count);
448         address[] memory owners = new address[](islands_count);
449         uint256[] memory prices = new uint256[](islands_count);
450         uint256[] memory treasuries = new uint256[](islands_count);
451         uint256[] memory attack_ships_counts = new uint256[](islands_count);
452         uint256[] memory defense_ships_counts = new uint256[](islands_count);
453         uint256[] memory transactions_count = new uint256[](islands_count);
454         for (uint256 _id = 0; _id < islands_count; _id++) {
455             ids[_id] = _id;
456             owners[_id] = islands[_id].owner;
457             prices[_id] = islands[_id].price;
458             treasuries[_id] = islands[_id].treasury;
459             attack_ships_counts[_id] = islands[_id].attack_ships_count;
460             defense_ships_counts[_id] = islands[_id].defense_ships_count;
461             transactions_count[_id] = islands[_id].transactions_count;
462         }
463         return (ids, owners, prices, treasuries, attack_ships_counts, defense_ships_counts, transactions_count);
464     }
465 
466     /** PRIVATE METHODS **/
467     function _create_island(bytes32 _name, address _owner, uint256 _price, uint256 _previous_price, uint256 _attack_ships_count, uint256 _defense_ships_count) private {
468         islands[islands_count] = Island({
469             name : _name,
470             owner : _owner,
471             price : _price,
472             treasury : 0,
473             treasury_next_withdrawal_block : 0,
474             previous_price : _previous_price,
475             attack_ships_count : _attack_ships_count,
476             defense_ships_count : _defense_ships_count,
477             transactions_count : 0,
478             approve_transfer_to : address(0),
479             previous_owners : [_owner, _owner]
480             });
481 
482         islandBattleStats[islands_count] = IslandBattleStats({
483             attacks_won : 0,
484             attacks_lost : 0,
485             defenses_won : 0,
486             defenses_lost : 0,
487             treasury_stolen : 0,
488             treasury_lost : 0,
489             attack_cooldown : 0,
490             defense_cooldown : 0
491             });
492 
493         NewIsland(islands_count, _name, _owner);
494         Transfer(address(this), _owner, islands_count);
495         islands_count++;
496     }
497 
498     function _import_island(bytes32 _name, address[3] _owners, uint256[7] _island_data, uint256[8] _island_battle_stats) private {
499         islands[islands_count] = Island({
500             name : _name,
501             owner : _owners[0],
502             price : _island_data[0],
503             treasury : _island_data[1],
504             treasury_next_withdrawal_block : _island_data[2],
505             previous_price : _island_data[3],
506             attack_ships_count : _island_data[4],
507             defense_ships_count : _island_data[5],
508             transactions_count : _island_data[6],
509             approve_transfer_to : address(0),
510             previous_owners : [_owners[1], _owners[2]]
511             });
512 
513         islandBattleStats[islands_count] = IslandBattleStats({
514             attacks_won : _island_battle_stats[0],
515             attacks_lost : _island_battle_stats[1],
516             defenses_won : _island_battle_stats[2],
517             defenses_lost : _island_battle_stats[3],
518             treasury_stolen : _island_battle_stats[4],
519             treasury_lost : _island_battle_stats[5],
520             attack_cooldown : _island_battle_stats[6],
521             defense_cooldown : _island_battle_stats[7]
522             });
523 
524         NewIsland(islands_count, _name, _owners[0]);
525         Transfer(address(this), _owners[0], islands_count);
526         islands_count++;
527     }
528 
529     function _transfer(address _from, address _to, uint256 _island_id) private {
530         islands[_island_id].owner = _to;
531         islands[_island_id].approve_transfer_to = address(0);
532         ownerCount[_from] -= 1;
533         ownerCount[_to] += 1;
534         Transfer(_from, _to, _island_id);
535     }
536 
537     /*** ERC-721 compliance. ***/
538     function approve(address _to, uint256 _island_id) public {
539         require(msg.sender == islands[_island_id].owner);
540         islands[_island_id].approve_transfer_to = _to;
541         Approval(msg.sender, _to, _island_id);
542     }
543 
544     function ownerOf(uint256 _island_id) public view returns (address owner){
545         owner = islands[_island_id].owner;
546         require(owner != address(0));
547     }
548 
549     function takeOwnership(uint256 _island_id) public {
550         address oldOwner = islands[_island_id].owner;
551         require(msg.sender != address(0));
552         require(islands[_island_id].approve_transfer_to == msg.sender);
553         _transfer(oldOwner, msg.sender, _island_id);
554     }
555 
556     function transfer(address _to, uint256 _island_id) public {
557         require(msg.sender != address(0));
558         require(msg.sender == islands[_island_id].owner);
559         _transfer(msg.sender, _to, _island_id);
560     }
561 
562     function transferFrom(address _from, address _to, uint256 _island_id) public {
563         require(_from == islands[_island_id].owner);
564         require(islands[_island_id].approve_transfer_to == _to);
565         require(_to != address(0));
566         _transfer(_from, _to, _island_id);
567     }
568 
569     function upgradeContract(address _newContract) public onlyOwner {
570         _newContract.transfer(this.balance);
571     }
572 
573     function AddEth () public payable {}
574 }