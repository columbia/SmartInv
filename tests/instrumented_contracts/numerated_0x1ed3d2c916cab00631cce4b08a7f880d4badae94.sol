1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12   }
13 
14   function square(uint256 a) internal pure returns (uint256) {
15     return mul(a, a);
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26   }
27 
28 }
29 
30 
31 contract ERC20Interface {
32 
33   event Transfer(
34     address indexed from,
35     address indexed to,
36     uint256 value
37   );
38 
39   event Approval(
40     address indexed owner,
41     address indexed spender,
42     uint256 value
43   );
44 
45   function totalSupply() public view returns (uint256);
46   function balanceOf(address _owner) public view returns (uint256);
47   function transfer(address _to, uint256 _value) public returns (bool);
48   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
49   function approve(address _spender, uint256 _value) public returns (bool);
50   function allowance( address _owner, address _spender) public view returns (uint256);
51 
52 }
53 
54 
55 /**
56  * @title CHStock
57  * @author M.H. Kang
58  */
59 contract CHStock is ERC20Interface {
60 
61   using SafeMath for uint256;
62 
63   /* EVENT */
64 
65   event RedeemShares(
66     address indexed user,
67     uint256 shares,
68     uint256 dividends
69   );
70 
71   /* STORAGE */
72 
73   string public name = "ChickenHuntStock";
74   string public symbol = "CHS";
75   uint8 public decimals = 18;
76   uint256 public totalShares;
77   uint256 public dividendsPerShare;
78   uint256 public constant CORRECTION = 1 << 64;
79   mapping (address => uint256) public ethereumBalance;
80   mapping (address => uint256) internal shares;
81   mapping (address => uint256) internal refund;
82   mapping (address => uint256) internal deduction;
83   mapping (address => mapping (address => uint256)) internal allowed;
84 
85   /* FUNCTION */
86 
87   function redeemShares() public {
88     uint256 _shares = shares[msg.sender];
89     uint256 _dividends = dividendsOf(msg.sender);
90 
91     delete shares[msg.sender];
92     delete refund[msg.sender];
93     delete deduction[msg.sender];
94     totalShares = totalShares.sub(_shares);
95     ethereumBalance[msg.sender] = ethereumBalance[msg.sender].add(_dividends);
96 
97     emit RedeemShares(msg.sender, _shares, _dividends);
98   }
99 
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     _transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   function transferFrom(address _from, address _to, uint256 _value)
106     public
107     returns (bool)
108   {
109     require(_value <= allowed[_from][msg.sender]);
110     allowed[_from][msg.sender] -= _value;
111     _transfer(_from, _to, _value);
112     return true;
113   }
114 
115   function approve(address _spender, uint256 _value) public returns (bool) {
116     allowed[msg.sender][_spender] = _value;
117     emit Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   function dividendsOf(address _shareholder) public view returns (uint256) {
122     return dividendsPerShare.mul(shares[_shareholder]).add(refund[_shareholder]).sub(deduction[_shareholder]) / CORRECTION;
123   }
124 
125   function totalSupply() public view returns (uint256) {
126     return totalShares;
127   }
128 
129   function balanceOf(address _owner) public view returns (uint256) {
130     return shares[_owner];
131   }
132 
133   function allowance(address _owner, address _spender)
134     public
135     view
136     returns (uint256)
137   {
138     return allowed[_owner][_spender];
139   }
140 
141   /* INTERNAL FUNCTION */
142 
143   function _giveShares(address _user, uint256 _ethereum) internal {
144     if (_ethereum > 0) {
145       totalShares = totalShares.add(_ethereum);
146       deduction[_user] = deduction[_user].add(dividendsPerShare.mul(_ethereum));
147       shares[_user] = shares[_user].add(_ethereum);
148       dividendsPerShare = dividendsPerShare.add(_ethereum.mul(CORRECTION) / totalShares);
149 
150       emit Transfer(address(0), _user, _ethereum);
151     }
152   }
153 
154   function _transfer(address _from, address _to, uint256 _value) internal {
155     require(_to != address(0));
156     require(_value <= shares[_from]);
157     uint256 _rawProfit = dividendsPerShare.mul(_value);
158 
159     uint256 _refund = refund[_from].add(_rawProfit);
160     uint256 _min = _refund < deduction[_from] ? _refund : deduction[_from];
161     refund[_from] = _refund.sub(_min);
162     deduction[_from] = deduction[_from].sub(_min);
163     deduction[_to] = deduction[_to].add(_rawProfit);
164 
165     shares[_from] = shares[_from].sub(_value);
166     shares[_to] = shares[_to].add(_value);
167 
168     emit Transfer(_from, _to, _value);
169   }
170 
171 }
172 
173 
174 /**
175  * @title CHGameBase
176  * @author M.H. Kang
177  */
178 contract CHGameBase is CHStock {
179 
180   /* DATA STRUCT */
181 
182   struct House {
183     Hunter hunter;
184     uint256 huntingPower;
185     uint256 offensePower;
186     uint256 defensePower;
187     uint256 huntingMultiplier;
188     uint256 offenseMultiplier;
189     uint256 defenseMultiplier;
190     uint256 depots;
191     uint256[] pets;
192   }
193 
194   struct Hunter {
195     uint256 strength;
196     uint256 dexterity;
197     uint256 constitution;
198     uint256 resistance;
199   }
200 
201   struct Store {
202     address owner;
203     uint256 cut;
204     uint256 cost;
205     uint256 balance;
206   }
207 
208   /* STORAGE */
209 
210   Store public store;
211   uint256 public devCut;
212   uint256 public devFee;
213   uint256 public altarCut;
214   uint256 public altarFund;
215   uint256 public dividendRate;
216   uint256 public totalChicken;
217   address public chickenTokenDelegator;
218   mapping (address => uint256) public lastSaveTime;
219   mapping (address => uint256) public savedChickenOf;
220   mapping (address => House) internal houses;
221 
222   /* FUNCTION */
223 
224   function saveChickenOf(address _user) public returns (uint256) {
225     uint256 _unclaimedChicken = _unclaimedChickenOf(_user);
226     totalChicken = totalChicken.add(_unclaimedChicken);
227     uint256 _chicken = savedChickenOf[_user].add(_unclaimedChicken);
228     savedChickenOf[_user] = _chicken;
229     lastSaveTime[_user] = block.timestamp;
230     return _chicken;
231   }
232 
233   function transferChickenFrom(address _from, address _to, uint256 _value)
234     public
235     returns (bool)
236   {
237     require(msg.sender == chickenTokenDelegator);
238     require(saveChickenOf(_from) >= _value);
239     savedChickenOf[_from] = savedChickenOf[_from] - _value;
240     savedChickenOf[_to] = savedChickenOf[_to].add(_value);
241 
242     return true;
243   }
244 
245   function chickenOf(address _user) public view returns (uint256) {
246     return savedChickenOf[_user].add(_unclaimedChickenOf(_user));
247   }
248 
249   /* INTERNAL FUNCTION */
250 
251   function _payChicken(address _user, uint256 _chicken) internal {
252     uint256 _unclaimedChicken = _unclaimedChickenOf(_user);
253     uint256 _extraChicken;
254 
255     if (_chicken > _unclaimedChicken) {
256       _extraChicken = _chicken - _unclaimedChicken;
257       require(savedChickenOf[_user] >= _extraChicken);
258       savedChickenOf[_user] -= _extraChicken;
259       totalChicken -= _extraChicken;
260     } else {
261       _extraChicken = _unclaimedChicken - _chicken;
262       totalChicken = totalChicken.add(_extraChicken);
263       savedChickenOf[_user] += _extraChicken;
264     }
265 
266     lastSaveTime[_user] = block.timestamp;
267   }
268 
269   function _payEthereumAndDistribute(uint256 _cost) internal {
270     require(_cost * 100 / 100 == _cost);
271     _payEthereum(_cost);
272 
273     uint256 _toShareholders = _cost * dividendRate / 100;
274     uint256 _toAltar = _cost * altarCut / 100;
275     uint256 _toStore = _cost * store.cut / 100;
276     devFee = devFee.add(_cost - _toShareholders - _toAltar - _toStore);
277 
278     _giveShares(msg.sender, _toShareholders);
279     altarFund = altarFund.add(_toAltar);
280     store.balance = store.balance.add(_toStore);
281   }
282 
283   function _payEthereum(uint256 _cost) internal {
284     uint256 _extra;
285     if (_cost > msg.value) {
286       _extra = _cost - msg.value;
287       require(ethereumBalance[msg.sender] >= _extra);
288       ethereumBalance[msg.sender] -= _extra;
289     } else {
290       _extra = msg.value - _cost;
291       ethereumBalance[msg.sender] = ethereumBalance[msg.sender].add(_extra);
292     }
293   }
294 
295   function _unclaimedChickenOf(address _user) internal view returns (uint256) {
296     uint256 _timestamp = lastSaveTime[_user];
297     if (_timestamp > 0 && _timestamp < block.timestamp) {
298       return houses[_user].huntingPower.mul(
299         houses[_user].huntingMultiplier
300       ).mul(block.timestamp - _timestamp) / 100;
301     } else {
302       return 0;
303     }
304   }
305 
306   function _houseOf(address _user)
307     internal
308     view
309     returns (House storage _house)
310   {
311     _house = houses[_user];
312     require(_house.depots > 0);
313   }
314 
315 }
316 
317 
318 /**
319  * @title CHHunter
320  * @author M.H. Kang
321  */
322 contract CHHunter is CHGameBase {
323 
324   /* EVENT */
325 
326   event UpgradeHunter(
327     address indexed user,
328     string attribute,
329     uint256 to
330   );
331 
332   /* DATA STRUCT */
333 
334   struct Config {
335     uint256 chicken;
336     uint256 ethereum;
337     uint256 max;
338   }
339 
340   /* STORAGE */
341 
342   Config public typeA;
343   Config public typeB;
344 
345   /* FUNCTION */
346 
347   function upgradeStrength(uint256 _to) external payable {
348     House storage _house = _houseOf(msg.sender);
349     uint256 _from = _house.hunter.strength;
350     require(typeA.max >= _to && _to > _from);
351     _payForUpgrade(_from, _to, typeA);
352 
353     uint256 _increment = _house.hunter.dexterity.mul(2).add(8).mul(_to.square() - _from ** 2);
354     _house.hunter.strength = _to;
355     _house.huntingPower = _house.huntingPower.add(_increment);
356     _house.offensePower = _house.offensePower.add(_increment);
357 
358     emit UpgradeHunter(msg.sender, "strength", _to);
359   }
360 
361   function upgradeDexterity(uint256 _to) external payable {
362     House storage _house = _houseOf(msg.sender);
363     uint256 _from = _house.hunter.dexterity;
364     require(typeB.max >= _to && _to > _from);
365     _payForUpgrade(_from, _to, typeB);
366 
367     uint256 _increment = _house.hunter.strength.square().mul((_to - _from).mul(2));
368     _house.hunter.dexterity = _to;
369     _house.huntingPower = _house.huntingPower.add(_increment);
370     _house.offensePower = _house.offensePower.add(_increment);
371 
372     emit UpgradeHunter(msg.sender, "dexterity", _to);
373   }
374 
375   function upgradeConstitution(uint256 _to) external payable {
376     House storage _house = _houseOf(msg.sender);
377     uint256 _from = _house.hunter.constitution;
378     require(typeA.max >= _to && _to > _from);
379     _payForUpgrade(_from, _to, typeA);
380 
381     uint256 _increment = _house.hunter.resistance.mul(2).add(8).mul(_to.square() - _from ** 2);
382     _house.hunter.constitution = _to;
383     _house.defensePower = _house.defensePower.add(_increment);
384 
385     emit UpgradeHunter(msg.sender, "constitution", _to);
386   }
387 
388   function upgradeResistance(uint256 _to) external payable {
389     House storage _house = _houseOf(msg.sender);
390     uint256 _from = _house.hunter.resistance;
391     require(typeB.max >= _to && _to > _from);
392     _payForUpgrade(_from, _to, typeB);
393 
394     uint256 _increment = _house.hunter.constitution.square().mul((_to - _from).mul(2));
395     _house.hunter.resistance = _to;
396     _house.defensePower = _house.defensePower.add(_increment);
397 
398     emit UpgradeHunter(msg.sender, "resistance", _to);
399   }
400 
401   /* INTERNAL FUNCTION */
402 
403   function _payForUpgrade(uint256 _from, uint256 _to, Config _type) internal {
404     uint256 _chickenCost = _type.chicken.mul(_gapOfCubeSum(_from, _to));
405     _payChicken(msg.sender, _chickenCost);
406     uint256 _ethereumCost = _type.ethereum.mul(_gapOfSquareSum(_from, _to));
407     _payEthereumAndDistribute(_ethereumCost);
408   }
409 
410   function _gapOfSquareSum(uint256 _before, uint256 _after)
411     internal
412     pure
413     returns (uint256)
414   {
415     // max value is capped to uint32
416     return (_after * (_after - 1) * (2 * _after - 1) - _before * (_before - 1) * (2 * _before - 1)) / 6;
417   }
418 
419   function _gapOfCubeSum(uint256 _before, uint256 _after)
420     internal
421     pure
422     returns (uint256)
423   {
424     // max value is capped to uint32
425     return ((_after * (_after - 1)) ** 2 - (_before * (_before - 1)) ** 2) >> 2;
426   }
427 
428 }
429 
430 
431 /**
432  * @title CHHouse
433  * @author M.H. Kang
434  */
435 contract CHHouse is CHHunter {
436 
437   /* EVENT */
438 
439   event UpgradePet(
440     address indexed user,
441     uint256 id,
442     uint256 to
443   );
444 
445   event UpgradeDepot(
446     address indexed user,
447     uint256 to
448   );
449 
450   event BuyItem(
451     address indexed from,
452     address indexed to,
453     uint256 indexed id,
454     uint256 cost
455   );
456 
457   event BuyStore(
458     address indexed from,
459     address indexed to,
460     uint256 cost
461   );
462 
463   /* DATA STRUCT */
464 
465   struct Pet {
466     uint256 huntingPower;
467     uint256 offensePower;
468     uint256 defensePower;
469     uint256 chicken;
470     uint256 ethereum;
471     uint256 max;
472   }
473 
474   struct Item {
475     address owner;
476     uint256 huntingMultiplier;
477     uint256 offenseMultiplier;
478     uint256 defenseMultiplier;
479     uint256 cost;
480   }
481 
482   struct Depot {
483     uint256 ethereum;
484     uint256 max;
485   }
486 
487   /* STORAGE */
488 
489   uint256 public constant INCREMENT_RATE = 12; // 120% for Item and Store
490   Depot public depot;
491   Pet[] public pets;
492   Item[] public items;
493 
494   /* FUNCTION */
495 
496   function buyDepots(uint256 _amount) external payable {
497     House storage _house = _houseOf(msg.sender);
498     _house.depots = _house.depots.add(_amount);
499     require(_house.depots <= depot.max);
500     _payEthereumAndDistribute(_amount.mul(depot.ethereum));
501 
502     emit UpgradeDepot(msg.sender, _house.depots);
503   }
504 
505   function buyPets(uint256 _id, uint256 _amount) external payable {
506     require(_id < pets.length);
507     Pet memory _pet = pets[_id];
508     uint256 _chickenCost = _amount * _pet.chicken;
509     _payChicken(msg.sender, _chickenCost);
510     uint256 _ethereumCost = _amount * _pet.ethereum;
511     _payEthereumAndDistribute(_ethereumCost);
512 
513     House storage _house = _houseOf(msg.sender);
514     if (_house.pets.length < _id + 1) {
515       _house.pets.length = _id + 1;
516     }
517     _house.pets[_id] = _house.pets[_id].add(_amount);
518     require(_house.pets[_id] <= _pet.max);
519 
520     _house.huntingPower = _house.huntingPower.add(_pet.huntingPower * _amount);
521     _house.offensePower = _house.offensePower.add(_pet.offensePower * _amount);
522     _house.defensePower = _house.defensePower.add(_pet.defensePower * _amount);
523 
524     emit UpgradePet(msg.sender, _id, _house.pets[_id]);
525   }
526 
527   // This is independent of Stock and Altar.
528   function buyItem(uint256 _id) external payable {
529     Item storage _item = items[_id];
530     address _from = _item.owner;
531     uint256 _price = _item.cost.mul(INCREMENT_RATE) / 10;
532     _payEthereum(_price);
533 
534     saveChickenOf(_from);
535     House storage _fromHouse = _houseOf(_from);
536     _fromHouse.huntingMultiplier = _fromHouse.huntingMultiplier.sub(_item.huntingMultiplier);
537     _fromHouse.offenseMultiplier = _fromHouse.offenseMultiplier.sub(_item.offenseMultiplier);
538     _fromHouse.defenseMultiplier = _fromHouse.defenseMultiplier.sub(_item.defenseMultiplier);
539 
540     saveChickenOf(msg.sender);
541     House storage _toHouse = _houseOf(msg.sender);
542     _toHouse.huntingMultiplier = _toHouse.huntingMultiplier.add(_item.huntingMultiplier);
543     _toHouse.offenseMultiplier = _toHouse.offenseMultiplier.add(_item.offenseMultiplier);
544     _toHouse.defenseMultiplier = _toHouse.defenseMultiplier.add(_item.defenseMultiplier);
545 
546     uint256 _halfMargin = _price.sub(_item.cost) / 2;
547     devFee = devFee.add(_halfMargin);
548     ethereumBalance[_from] = ethereumBalance[_from].add(_price - _halfMargin);
549 
550     items[_id].cost = _price;
551     items[_id].owner = msg.sender;
552 
553     emit BuyItem(_from, msg.sender, _id, _price);
554   }
555 
556   // This is independent of Stock and Altar.
557   function buyStore() external payable {
558     address _from = store.owner;
559     uint256 _price = store.cost.mul(INCREMENT_RATE) / 10;
560     _payEthereum(_price);
561 
562     uint256 _halfMargin = (_price - store.cost) / 2;
563     devFee = devFee.add(_halfMargin);
564     ethereumBalance[_from] = ethereumBalance[_from].add(_price - _halfMargin).add(store.balance);
565 
566     store.cost = _price;
567     store.owner = msg.sender;
568     delete store.balance;
569 
570     emit BuyStore(_from, msg.sender, _price);
571   }
572 
573   function withdrawStoreBalance() public {
574     ethereumBalance[store.owner] = ethereumBalance[store.owner].add(store.balance);
575     delete store.balance;
576   }
577 
578 }
579 
580 
581 /**
582  * @title CHArena
583  * @author M.H. Kang
584  */
585 contract CHArena is CHHouse {
586 
587   /* EVENT */
588 
589   event Attack(
590     address indexed attacker,
591     address indexed defender,
592     uint256 booty
593   );
594 
595   /* STORAGE */
596 
597   mapping(address => uint256) public attackCooldown;
598   uint256 public cooldownTime;
599 
600   /* FUNCTION */
601 
602   function attack(address _target) external {
603     require(attackCooldown[msg.sender] < block.timestamp);
604     House storage _attacker = houses[msg.sender];
605     House storage _defender = houses[_target];
606     if (_attacker.offensePower.mul(_attacker.offenseMultiplier)
607         > _defender.defensePower.mul(_defender.defenseMultiplier)) {
608       uint256 _chicken = saveChickenOf(_target);
609       _chicken = _defender.depots > 0 ? _chicken / _defender.depots : _chicken;
610       savedChickenOf[_target] = savedChickenOf[_target] - _chicken;
611       savedChickenOf[msg.sender] = savedChickenOf[msg.sender].add(_chicken);
612       attackCooldown[msg.sender] = block.timestamp + cooldownTime;
613 
614       emit Attack(msg.sender, _target, _chicken);
615     }
616   }
617 
618 }
619 
620 
621 /**
622  * @title CHAltar
623  * @author M.H. Kang
624  */
625 contract CHAltar is CHArena {
626 
627   /* EVENT */
628 
629   event NewAltarRecord(uint256 id, uint256 ethereum);
630   event ChickenToAltar(address indexed user, uint256 id, uint256 chicken);
631   event EthereumFromAltar(address indexed user, uint256 id, uint256 ethereum);
632 
633   /* DATA STRUCT */
634 
635   struct AltarRecord {
636     uint256 ethereum;
637     uint256 chicken;
638   }
639 
640   struct TradeBook {
641     uint256 altarRecordId;
642     uint256 chicken;
643   }
644 
645   /* STORAGE */
646 
647   uint256 public genesis;
648   mapping (uint256 => AltarRecord) public altarRecords;
649   mapping (address => TradeBook) public tradeBooks;
650 
651   /* FUNCTION */
652 
653   function chickenToAltar(uint256 _chicken) external {
654     require(_chicken > 0);
655 
656     _payChicken(msg.sender, _chicken);
657     uint256 _id = _getCurrentAltarRecordId();
658     AltarRecord storage _altarRecord = _getAltarRecord(_id);
659     require(_altarRecord.ethereum * _chicken / _chicken == _altarRecord.ethereum);
660     TradeBook storage _tradeBook = tradeBooks[msg.sender];
661     if (_tradeBook.altarRecordId < _id) {
662       _resolveTradeBook(_tradeBook);
663       _tradeBook.altarRecordId = _id;
664     }
665     _altarRecord.chicken = _altarRecord.chicken.add(_chicken);
666     _tradeBook.chicken += _chicken;
667 
668     emit ChickenToAltar(msg.sender, _id, _chicken);
669   }
670 
671   function ethereumFromAltar() external {
672     uint256 _id = _getCurrentAltarRecordId();
673     TradeBook storage _tradeBook = tradeBooks[msg.sender];
674     require(_tradeBook.altarRecordId < _id);
675     _resolveTradeBook(_tradeBook);
676   }
677 
678   function tradeBookOf(address _user)
679     public
680     view
681     returns (
682       uint256 _id,
683       uint256 _ethereum,
684       uint256 _totalChicken,
685       uint256 _chicken,
686       uint256 _income
687     )
688   {
689     TradeBook memory _tradeBook = tradeBooks[_user];
690     _id = _tradeBook.altarRecordId;
691     _chicken = _tradeBook.chicken;
692     AltarRecord memory _altarRecord = altarRecords[_id];
693     _totalChicken = _altarRecord.chicken;
694     _ethereum = _altarRecord.ethereum;
695     _income = _totalChicken > 0 ? _ethereum.mul(_chicken) / _totalChicken : 0;
696   }
697 
698   /* INTERNAL FUNCTION */
699 
700   function _resolveTradeBook(TradeBook storage _tradeBook) internal {
701     if (_tradeBook.chicken > 0) {
702       AltarRecord memory _oldAltarRecord = altarRecords[_tradeBook.altarRecordId];
703       uint256 _ethereum = _oldAltarRecord.ethereum.mul(_tradeBook.chicken) / _oldAltarRecord.chicken;
704       delete _tradeBook.chicken;
705       ethereumBalance[msg.sender] = ethereumBalance[msg.sender].add(_ethereum);
706 
707       emit EthereumFromAltar(msg.sender, _tradeBook.altarRecordId, _ethereum);
708     }
709   }
710 
711   function _getCurrentAltarRecordId() internal view returns (uint256) {
712     return (block.timestamp - genesis) / 86400;
713   }
714 
715   function _getAltarRecord(uint256 _id) internal returns (AltarRecord storage _altarRecord) {
716     _altarRecord = altarRecords[_id];
717     if (_altarRecord.ethereum == 0) {
718       uint256 _ethereum = altarFund / 10;
719       _altarRecord.ethereum = _ethereum;
720       altarFund -= _ethereum;
721 
722       emit NewAltarRecord(_id, _ethereum);
723     }
724   }
725 
726 }
727 
728 
729 /**
730  * @title CHCommittee
731  * @author M.H. Kang
732  */
733 contract CHCommittee is CHAltar {
734 
735   /* EVENT */
736 
737   event NewPet(
738     uint256 id,
739     uint256 huntingPower,
740     uint256 offensePower,
741     uint256 defense,
742     uint256 chicken,
743     uint256 ethereum,
744     uint256 max
745   );
746 
747   event ChangePet(
748     uint256 id,
749     uint256 chicken,
750     uint256 ethereum,
751     uint256 max
752   );
753 
754   event NewItem(
755     uint256 id,
756     uint256 huntingMultiplier,
757     uint256 offenseMultiplier,
758     uint256 defenseMultiplier,
759     uint256 ethereum
760   );
761 
762   event SetDepot(uint256 ethereum, uint256 max);
763 
764   event SetConfiguration(
765     uint256 chickenA,
766     uint256 ethereumA,
767     uint256 maxA,
768     uint256 chickenB,
769     uint256 ethereumB,
770     uint256 maxB
771   );
772 
773   event SetDistribution(
774     uint256 dividendRate,
775     uint256 altarCut,
776     uint256 storeCut,
777     uint256 devCut
778   );
779 
780   event SetCooldownTime(uint256 cooldownTime);
781   event SetNameAndSymbol(string name, string symbol);
782   event SetDeveloper(address developer);
783   event SetCommittee(address committee);
784 
785   /* STORAGE */
786 
787   address public committee;
788   address public developer;
789 
790   /* FUNCTION */
791 
792   function callFor(address _to, uint256 _value, uint256 _gas, bytes _code)
793     external
794     payable
795     onlyCommittee
796     returns (bool)
797   {
798     return _to.call.value(_value).gas(_gas)(_code);
799   }
800 
801   function addPet(
802     uint256 _huntingPower,
803     uint256 _offensePower,
804     uint256 _defense,
805     uint256 _chicken,
806     uint256 _ethereum,
807     uint256 _max
808   )
809     public
810     onlyCommittee
811   {
812     require(_max > 0);
813     require(_max == uint256(uint32(_max)));
814     uint256 _newLength = pets.push(
815       Pet(_huntingPower, _offensePower, _defense, _chicken, _ethereum, _max)
816     );
817 
818     emit NewPet(
819       _newLength - 1,
820       _huntingPower,
821       _offensePower,
822       _defense,
823       _chicken,
824       _ethereum,
825       _max
826     );
827   }
828 
829   function changePet(
830     uint256 _id,
831     uint256 _chicken,
832     uint256 _ethereum,
833     uint256 _max
834   )
835     public
836     onlyCommittee
837   {
838     require(_id < pets.length);
839     Pet storage _pet = pets[_id];
840     require(_max >= _pet.max && _max == uint256(uint32(_max)));
841 
842     _pet.chicken = _chicken;
843     _pet.ethereum = _ethereum;
844     _pet.max = _max;
845 
846     emit ChangePet(_id, _chicken, _ethereum, _max);
847   }
848 
849   function addItem(
850     uint256 _huntingMultiplier,
851     uint256 _offenseMultiplier,
852     uint256 _defenseMultiplier,
853     uint256 _price
854   )
855     public
856     onlyCommittee
857   {
858     uint256 _cap = 1 << 16;
859     require(
860       _huntingMultiplier < _cap &&
861       _offenseMultiplier < _cap &&
862       _defenseMultiplier < _cap
863     );
864     saveChickenOf(committee);
865     House storage _house = _houseOf(committee);
866     _house.huntingMultiplier = _house.huntingMultiplier.add(_huntingMultiplier);
867     _house.offenseMultiplier = _house.offenseMultiplier.add(_offenseMultiplier);
868     _house.defenseMultiplier = _house.defenseMultiplier.add(_defenseMultiplier);
869 
870     uint256 _newLength = items.push(
871       Item(
872         committee,
873         _huntingMultiplier,
874         _offenseMultiplier,
875         _defenseMultiplier,
876         _price
877       )
878     );
879 
880     emit NewItem(
881       _newLength - 1,
882       _huntingMultiplier,
883       _offenseMultiplier,
884       _defenseMultiplier,
885       _price
886     );
887   }
888 
889   function setDepot(uint256 _price, uint256 _max) public onlyCommittee {
890     require(_max >= depot.max);
891 
892     depot.ethereum = _price;
893     depot.max = _max;
894 
895     emit SetDepot(_price, _max);
896   }
897 
898   function setConfiguration(
899     uint256 _chickenA,
900     uint256 _ethereumA,
901     uint256 _maxA,
902     uint256 _chickenB,
903     uint256 _ethereumB,
904     uint256 _maxB
905   )
906     public
907     onlyCommittee
908   {
909     require(_maxA >= typeA.max && (_maxA == uint256(uint32(_maxA))));
910     require(_maxB >= typeB.max && (_maxB == uint256(uint32(_maxB))));
911 
912     typeA.chicken = _chickenA;
913     typeA.ethereum = _ethereumA;
914     typeA.max = _maxA;
915 
916     typeB.chicken = _chickenB;
917     typeB.ethereum = _ethereumB;
918     typeB.max = _maxB;
919 
920     emit SetConfiguration(_chickenA, _ethereumA, _maxA, _chickenB, _ethereumB, _maxB);
921   }
922 
923   function setDistribution(
924     uint256 _dividendRate,
925     uint256 _altarCut,
926     uint256 _storeCut,
927     uint256 _devCut
928   )
929     public
930     onlyCommittee
931   {
932     require(_storeCut > 0);
933     require(
934       _dividendRate.add(_altarCut).add(_storeCut).add(_devCut) == 100
935     );
936 
937     dividendRate = _dividendRate;
938     altarCut = _altarCut;
939     store.cut = _storeCut;
940     devCut = _devCut;
941 
942     emit SetDistribution(_dividendRate, _altarCut, _storeCut, _devCut);
943   }
944 
945   function setCooldownTime(uint256 _cooldownTime) public onlyCommittee {
946     cooldownTime = _cooldownTime;
947 
948     emit SetCooldownTime(_cooldownTime);
949   }
950 
951   function setNameAndSymbol(string _name, string _symbol)
952     public
953     onlyCommittee
954   {
955     name = _name;
956     symbol = _symbol;
957 
958     emit SetNameAndSymbol(_name, _symbol);
959   }
960 
961   function setDeveloper(address _developer) public onlyCommittee {
962     require(_developer != address(0));
963     withdrawDevFee();
964     developer = _developer;
965 
966     emit SetDeveloper(_developer);
967   }
968 
969   function setCommittee(address _committee) public onlyCommittee {
970     require(_committee != address(0));
971     committee = _committee;
972 
973     emit SetCommittee(_committee);
974   }
975 
976   function withdrawDevFee() public {
977     ethereumBalance[developer] = ethereumBalance[developer].add(devFee);
978     delete devFee;
979   }
980 
981   /* MODIFIER */
982 
983   modifier onlyCommittee {
984     require(msg.sender == committee);
985     _;
986   }
987 
988 }
989 
990 
991 /**
992  * @title ChickenHunt
993  * @author M.H. Kang
994  */
995 contract ChickenHunt is CHCommittee {
996 
997   /* EVENT */
998 
999   event Join(address user);
1000 
1001   /* CONSTRUCTOR */
1002 
1003   constructor() public {
1004     committee = msg.sender;
1005     developer = msg.sender;
1006   }
1007 
1008   /* FUNCTION */
1009 
1010   function init(address _chickenTokenDelegator) external onlyCommittee {
1011     require(chickenTokenDelegator == address(0));
1012     chickenTokenDelegator = _chickenTokenDelegator;
1013     genesis = 1525791600;
1014     join();
1015     store.owner = msg.sender;
1016     store.cost = 0.1 ether;
1017     setConfiguration(100, 0.00001 ether, 99, 100000, 0.001 ether, 9);
1018     setDistribution(20, 75, 1, 4);
1019     setCooldownTime(600);
1020     setDepot(0.05 ether, 9);
1021     addItem(5, 5, 0, 0.01 ether);
1022     addItem(0, 0, 5, 0.01 ether);
1023     addPet(1000, 0, 0, 100000, 0.01 ether, 9);
1024     addPet(0, 1000, 0, 100000, 0.01 ether, 9);
1025     addPet(0, 0, 1000, 202500, 0.01 ether, 9);
1026   }
1027 
1028   function withdraw() external {
1029     uint256 _ethereum = ethereumBalance[msg.sender];
1030     delete ethereumBalance[msg.sender];
1031     msg.sender.transfer(_ethereum);
1032   }
1033 
1034   function join() public {
1035     House storage _house = houses[msg.sender];
1036     require(_house.depots == 0);
1037     _house.hunter = Hunter(1, 1, 1, 1);
1038     _house.depots = 1;
1039     _house.huntingPower = 10;
1040     _house.offensePower = 10;
1041     _house.defensePower = 110;
1042     _house.huntingMultiplier = 10;
1043     _house.offenseMultiplier = 10;
1044     _house.defenseMultiplier = 10;
1045     lastSaveTime[msg.sender] = block.timestamp;
1046 
1047     emit Join(msg.sender);
1048   }
1049 
1050   function hunterOf(address _user)
1051     public
1052     view
1053     returns (
1054       uint256 _strength,
1055       uint256 _dexterity,
1056       uint256 _constitution,
1057       uint256 _resistance
1058     )
1059   {
1060     Hunter memory _hunter = houses[_user].hunter;
1061     return (
1062       _hunter.strength,
1063       _hunter.dexterity,
1064       _hunter.constitution,
1065       _hunter.resistance
1066     );
1067   }
1068 
1069   function detailsOf(address _user)
1070     public
1071     view
1072     returns (
1073       uint256[2] _hunting,
1074       uint256[2] _offense,
1075       uint256[2] _defense,
1076       uint256[4] _hunter,
1077       uint256[] _pets,
1078       uint256 _depots,
1079       uint256 _savedChicken,
1080       uint256 _lastSaveTime,
1081       uint256 _cooldown
1082     )
1083   {
1084     House memory _house = houses[_user];
1085 
1086     _hunting = [_house.huntingPower, _house.huntingMultiplier];
1087     _offense = [_house.offensePower, _house.offenseMultiplier];
1088     _defense = [_house.defensePower, _house.defenseMultiplier];
1089     _hunter = [
1090       _house.hunter.strength,
1091       _house.hunter.dexterity,
1092       _house.hunter.constitution,
1093       _house.hunter.resistance
1094     ];
1095     _pets = _house.pets;
1096     _depots = _house.depots;
1097     _savedChicken = savedChickenOf[_user];
1098     _lastSaveTime = lastSaveTime[_user];
1099     _cooldown = attackCooldown[_user];
1100   }
1101 
1102 }