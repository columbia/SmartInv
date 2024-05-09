1 pragma solidity ^0.4.24;
2 
3 // File: contracts\utils\ItemUtils.sol
4 
5 library ItemUtils {
6 
7     uint256 internal constant UID_SHIFT = 2 ** 0; // 32
8     uint256 internal constant RARITY_SHIFT = 2 ** 32; // 4
9     uint256 internal constant CLASS_SHIFT = 2 ** 36;  // 10
10     uint256 internal constant TYPE_SHIFT = 2 ** 46;  // 10
11     uint256 internal constant TIER_SHIFT = 2 ** 56; // 7
12     uint256 internal constant NAME_SHIFT = 2 ** 63; // 7
13     uint256 internal constant REGION_SHIFT = 2 ** 70; // 8
14     uint256 internal constant BASE_SHIFT = 2 ** 78;
15 
16     function createItem(uint256 _class, uint256 _type, uint256 _rarity, uint256 _tier, uint256 _name, uint256 _region) internal pure returns (uint256 dna) {
17         dna = setClass(dna, _class);
18         dna = setType(dna, _type);
19         dna = setRarity(dna, _rarity);
20         dna = setTier(dna, _tier);
21         dna = setName(dna, _name);
22         dna = setRegion(dna, _region);
23     }
24 
25     function setUID(uint256 _dna, uint256 _value) internal pure returns (uint256) {
26         require(_value < RARITY_SHIFT / UID_SHIFT);
27         return setValue(_dna, _value, UID_SHIFT);
28     }
29 
30     function setRarity(uint256 _dna, uint256 _value) internal pure returns (uint256) {
31         require(_value < CLASS_SHIFT / RARITY_SHIFT);
32         return setValue(_dna, _value, RARITY_SHIFT);
33     }
34 
35     function setClass(uint256 _dna, uint256 _value) internal pure returns (uint256) {
36         require(_value < TYPE_SHIFT / CLASS_SHIFT);
37         return setValue(_dna, _value, CLASS_SHIFT);
38     }
39 
40     function setType(uint256 _dna, uint256 _value) internal pure returns (uint256) {
41         require(_value < TIER_SHIFT / TYPE_SHIFT);
42         return setValue(_dna, _value, TYPE_SHIFT);
43     }
44 
45     function setTier(uint256 _dna, uint256 _value) internal pure returns (uint256) {
46         require(_value < NAME_SHIFT / TIER_SHIFT);
47         return setValue(_dna, _value, TIER_SHIFT);
48     }
49 
50     function setName(uint256 _dna, uint256 _value) internal pure returns (uint256) {
51         require(_value < REGION_SHIFT / NAME_SHIFT);
52         return setValue(_dna, _value, NAME_SHIFT);
53     }
54 
55     function setRegion(uint256 _dna, uint256 _value) internal pure returns (uint256) {
56         require(_value < BASE_SHIFT / REGION_SHIFT);
57         return setValue(_dna, _value, REGION_SHIFT);
58     }
59 
60     function getUID(uint256 _dna) internal pure returns (uint256) {
61         return (_dna % RARITY_SHIFT) / UID_SHIFT;
62     }
63 
64     function getRarity(uint256 _dna) internal pure returns (uint256) {
65         return (_dna % CLASS_SHIFT) / RARITY_SHIFT;
66     }
67 
68     function getClass(uint256 _dna) internal pure returns (uint256) {
69         return (_dna % TYPE_SHIFT) / CLASS_SHIFT;
70     }
71 
72     function getType(uint256 _dna) internal pure returns (uint256) {
73         return (_dna % TIER_SHIFT) / TYPE_SHIFT;
74     }
75 
76     function getTier(uint256 _dna) internal pure returns (uint256) {
77         return (_dna % NAME_SHIFT) / TIER_SHIFT;
78     }
79 
80     function getName(uint256 _dna) internal pure returns (uint256) {
81         return (_dna % REGION_SHIFT) / NAME_SHIFT;
82     }
83 
84     function getRegion(uint256 _dna) internal pure returns (uint256) {
85         return (_dna % BASE_SHIFT) / REGION_SHIFT;
86     }
87 
88     function setValue(uint256 dna, uint256 value, uint256 shift) internal pure returns (uint256) {
89         return dna + (value * shift);
90     }
91 }
92 
93 // File: contracts\utils\StringUtils.sol
94 
95 library StringUtils {
96 
97     function concat(string _base, string _value) internal pure returns (string) {
98         bytes memory _baseBytes = bytes(_base);
99         bytes memory _valueBytes = bytes(_value);
100 
101         string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
102         bytes memory _newValue = bytes(_tmpValue);
103 
104         uint i;
105         uint j;
106 
107         for (i = 0; i < _baseBytes.length; i++) {
108             _newValue[j++] = _baseBytes[i];
109         }
110 
111         for (i = 0; i < _valueBytes.length; i++) {
112             _newValue[j++] = _valueBytes[i++];
113         }
114 
115         return string(_newValue);
116     }
117 
118     function uint2str(uint i) internal pure returns (string){
119         if (i == 0) return "0";
120         uint j = i;
121         uint length;
122         while (j != 0) {
123             length++;
124             j /= 10;
125         }
126         bytes memory bstr = new bytes(length);
127         uint k = length - 1;
128         while (i != 0) {
129             bstr[k--] = byte(48 + i % 10);
130             i /= 10;
131         }
132         return string(bstr);
133     }
134 
135 }
136 
137 // File: contracts\Ownable.sol
138 
139 /**
140  * @title Ownable
141  * @dev The Ownable contract has an emitter and administrator addresses, and provides basic authorization control
142  * functions, this simplifies the implementation of "user permissions".
143  */
144 contract Ownable {
145     address emitter;
146     address administrator;
147 
148     /**
149      * @dev Sets the original `emitter` of the contract
150      */
151     function setEmitter(address _emitter) internal {
152         require(_emitter != address(0));
153         require(emitter == address(0));
154         emitter = _emitter;
155     }
156 
157     /**
158      * @dev Sets the original `administrator` of the contract
159      */
160     function setAdministrator(address _administrator) internal {
161         require(_administrator != address(0));
162         require(administrator == address(0));
163         administrator = _administrator;
164     }
165 
166     /**
167      * @dev Throws if called by any account other than the emitter.
168      */
169     modifier onlyEmitter() {
170         require(msg.sender == emitter);
171         _;
172     }
173 
174     /**
175      * @dev Throws if called by any account other than the administrator.
176      */
177     modifier onlyAdministrator() {
178         require(msg.sender == administrator);
179         _;
180     }
181 
182     /**
183    * @dev Allows the current super emitter to transfer control of the contract to a emitter.
184    * @param _emitter The address to transfer emitter ownership to.
185    * @param _administrator The address to transfer administrator ownership to.
186    */
187     function transferOwnership(address _emitter, address _administrator) public onlyAdministrator {
188         require(_emitter != _administrator);
189         require(_emitter != emitter);
190         require(_emitter != address(0));
191         require(_administrator != address(0));
192         emitter = _emitter;
193         administrator = _administrator;
194     }
195 }
196 
197 // File: contracts\token\ERC20\ERC20Basic.sol
198 
199 /**
200  * @title ERC20Basic
201  * @dev Simpler version of ERC20 interface
202  * See https://github.com/ethereum/EIPs/issues/179
203  */
204 contract ERC20Basic {
205   function totalSupply() public view returns (uint256);
206   function balanceOf(address _who) public view returns (uint256);
207   function transfer(address _to, uint256 _value) public returns (bool);
208   event Transfer(address indexed from, address indexed to, uint256 value);
209 }
210 
211 // File: contracts\math\SafeMath.sol
212 
213 /**
214  * @title SafeMath
215  * @dev Math operations with safety checks that throw on error
216  */
217 library SafeMath {
218 
219   /**
220   * @dev Multiplies two numbers, throws on overflow.
221   */
222   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
223     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
224     // benefit is lost if 'b' is also tested.
225     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
226     if (_a == 0) {
227       return 0;
228     }
229 
230     c = _a * _b;
231     assert(c / _a == _b);
232     return c;
233   }
234 
235   /**
236   * @dev Integer division of two numbers, truncating the quotient.
237   */
238   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
239     // assert(_b > 0); // Solidity automatically throws when dividing by 0
240     // uint256 c = _a / _b;
241     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
242     return _a / _b;
243   }
244 
245   /**
246   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
247   */
248   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
249     assert(_b <= _a);
250     return _a - _b;
251   }
252 
253   /**
254   * @dev Adds two numbers, throws on overflow.
255   */
256   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
257     c = _a + _b;
258     assert(c >= _a);
259     return c;
260   }
261 }
262 
263 // File: contracts\token\ERC20\BasicToken.sol
264 
265 /**
266  * @title Basic token
267  * @dev Basic version of StandardToken, with no allowances.
268  */
269 contract BasicToken is ERC20Basic {
270   using SafeMath for uint256;
271 
272   mapping(address => uint256) internal balances;
273 
274   uint256 internal totalSupply_;
275 
276   /**
277   * @dev Total number of tokens in existence
278   */
279   function totalSupply() public view returns (uint256) {
280     return totalSupply_;
281   }
282 
283   /**
284   * @dev Transfer token for a specified address
285   * @param _to The address to transfer to.
286   * @param _value The amount to be transferred.
287   */
288   function transfer(address _to, uint256 _value) public returns (bool) {
289     require(_value <= balances[msg.sender]);
290     require(_to != address(0));
291 
292     balances[msg.sender] = balances[msg.sender].sub(_value);
293     balances[_to] = balances[_to].add(_value);
294     emit Transfer(msg.sender, _to, _value);
295     return true;
296   }
297 
298   /**
299   * @dev Gets the balance of the specified address.
300   * @param _owner The address to query the the balance of.
301   * @return An uint256 representing the amount owned by the passed address.
302   */
303   function balanceOf(address _owner) public view returns (uint256) {
304     return balances[_owner];
305   }
306 
307 }
308 
309 // File: contracts\token\ERC20\ERC20.sol
310 
311 /**
312  * @title ERC20 interface
313  * @dev see https://github.com/ethereum/EIPs/issues/20
314  */
315 contract ERC20 is ERC20Basic {
316   function allowance(address _owner, address _spender)
317     public view returns (uint256);
318 
319   function transferFrom(address _from, address _to, uint256 _value)
320     public returns (bool);
321 
322   function approve(address _spender, uint256 _value) public returns (bool);
323   event Approval(
324     address indexed owner,
325     address indexed spender,
326     uint256 value
327   );
328 }
329 
330 // File: contracts\token\ERC20\StandardToken.sol
331 
332 /**
333  * @title Standard ERC20 token
334  *
335  * @dev Implementation of the basic standard token.
336  * https://github.com/ethereum/EIPs/issues/20
337  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
338  */
339 contract StandardToken is ERC20, BasicToken {
340 
341   mapping (address => mapping (address => uint256)) internal allowed;
342 
343 
344   /**
345    * @dev Transfer tokens from one address to another
346    * @param _from address The address which you want to send tokens from
347    * @param _to address The address which you want to transfer to
348    * @param _value uint256 the amount of tokens to be transferred
349    */
350   function transferFrom(
351     address _from,
352     address _to,
353     uint256 _value
354   )
355     public
356     returns (bool)
357   {
358     require(_value <= balances[_from]);
359     require(_value <= allowed[_from][msg.sender]);
360     require(_to != address(0));
361 
362     balances[_from] = balances[_from].sub(_value);
363     balances[_to] = balances[_to].add(_value);
364     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
365     emit Transfer(_from, _to, _value);
366     return true;
367   }
368 
369   /**
370    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
371    * Beware that changing an allowance with this method brings the risk that someone may use both the old
372    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
373    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
374    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375    * @param _spender The address which will spend the funds.
376    * @param _value The amount of tokens to be spent.
377    */
378   function approve(address _spender, uint256 _value) public returns (bool) {
379     allowed[msg.sender][_spender] = _value;
380     emit Approval(msg.sender, _spender, _value);
381     return true;
382   }
383 
384   /**
385    * @dev Function to check the amount of tokens that an owner allowed to a spender.
386    * @param _owner address The address which owns the funds.
387    * @param _spender address The address which will spend the funds.
388    * @return A uint256 specifying the amount of tokens still available for the spender.
389    */
390   function allowance(
391     address _owner,
392     address _spender
393    )
394     public
395     view
396     returns (uint256)
397   {
398     return allowed[_owner][_spender];
399   }
400 
401   /**
402    * @dev Increase the amount of tokens that an owner allowed to a spender.
403    * approve should be called when allowed[_spender] == 0. To increment
404    * allowed value is better to use this function to avoid 2 calls (and wait until
405    * the first transaction is mined)
406    * From MonolithDAO Token.sol
407    * @param _spender The address which will spend the funds.
408    * @param _addedValue The amount of tokens to increase the allowance by.
409    */
410   function increaseApproval(
411     address _spender,
412     uint256 _addedValue
413   )
414     public
415     returns (bool)
416   {
417     allowed[msg.sender][_spender] = (
418       allowed[msg.sender][_spender].add(_addedValue));
419     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
420     return true;
421   }
422 
423   /**
424    * @dev Decrease the amount of tokens that an owner allowed to a spender.
425    * approve should be called when allowed[_spender] == 0. To decrement
426    * allowed value is better to use this function to avoid 2 calls (and wait until
427    * the first transaction is mined)
428    * From MonolithDAO Token.sol
429    * @param _spender The address which will spend the funds.
430    * @param _subtractedValue The amount of tokens to decrease the allowance by.
431    */
432   function decreaseApproval(
433     address _spender,
434     uint256 _subtractedValue
435   )
436     public
437     returns (bool)
438   {
439     uint256 oldValue = allowed[msg.sender][_spender];
440     if (_subtractedValue >= oldValue) {
441       allowed[msg.sender][_spender] = 0;
442     } else {
443       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
444     }
445     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
446     return true;
447   }
448 
449 }
450 
451 // File: contracts\GameCoin.sol
452 
453 contract GameCoin is StandardToken {
454     string public constant name = "GameCoin";
455 
456     string public constant symbol = "GC";
457 
458     uint8 public constant decimals = 0;
459 
460     bool public isGameCoin = true;
461 
462     /**
463    * @dev Constructor that gives msg.sender all of existing tokens.
464    */
465     constructor(address[] owners) public {
466         for (uint256 i = 0; i < owners.length; i++) {
467             _mint(owners[i], 2 * 10 ** 6);
468         }
469     }
470 
471     /**
472      * @dev Internal function that mints an amount of the token and assigns it to
473      * an account. This encapsulates the modification of balances such that the
474      * proper events are emitted.
475      * @param _account The account that will receive the created tokens.
476      * @param _amount The amount that will be created.
477      */
478     function _mint(address _account, uint256 _amount) internal {
479         require(_account != 0);
480         totalSupply_ = totalSupply_.add(_amount);
481         balances[_account] = balances[_account].add(_amount);
482         emit Transfer(address(0), _account, _amount);
483     }
484 }
485 
486 // File: contracts\PresaleGacha.sol
487 
488 contract PresaleGacha {
489 
490     uint32 internal constant CLASS_NONE = 0;
491     uint32 internal constant CLASS_CHARACTER = 1;
492     uint32 internal constant CLASS_CHEST = 2;
493     uint32 internal constant CLASS_MELEE = 3;
494     uint32 internal constant CLASS_RANGED = 4;
495     uint32 internal constant CLASS_ARMOR = 5;
496     uint32 internal constant CLASS_HELMET = 6;
497     uint32 internal constant CLASS_LEGS = 7;
498     uint32 internal constant CLASS_GLOVES = 8;
499     uint32 internal constant CLASS_BOOTS = 9;
500     uint32 internal constant CLASS_NECKLACE = 10;
501     uint32 internal constant CLASS_MODS = 11;
502     uint32 internal constant CLASS_TROPHY = 12;
503 
504     uint32 internal constant TYPE_CHEST_NONE = 0;
505     uint32 internal constant TYPE_CHEST_APPRENTICE = 1;
506     uint32 internal constant TYPE_CHEST_WARRIOR = 2;
507     uint32 internal constant TYPE_CHEST_GLADIATOR = 3;
508     uint32 internal constant TYPE_CHEST_WARLORD = 4;
509     uint32 internal constant TYPE_CHEST_TOKEN_PACK = 5;
510     uint32 internal constant TYPE_CHEST_INVESTOR_PACK = 6;
511 
512     uint32 internal constant TYPE_RANGED_PRESALE_RIFLE = 1;
513     uint32 internal constant TYPE_ARMOR_PRESALE_ARMOR = 1;
514     uint32 internal constant TYPE_LEGS_PRESALE_LEGS = 1;
515     uint32 internal constant TYPE_BOOTS_PRESALE_BOOTS = 1;
516     uint32 internal constant TYPE_GLOVES_PRESALE_GLOVES = 1;
517     uint32 internal constant TYPE_HELMET_PRESALE_HELMET = 1;
518     uint32 internal constant TYPE_NECKLACE_PRESALE_NECKLACE = 1;
519     uint32 internal constant TYPE_MODES_PRESALE_MODES = 1;
520 
521     uint32 internal constant NAME_NONE = 0;
522     uint32 internal constant NAME_COSMIC = 1;
523     uint32 internal constant NAME_FUSION = 2;
524     uint32 internal constant NAME_CRIMSON = 3;
525     uint32 internal constant NAME_SHINING = 4;
526     uint32 internal constant NAME_ANCIENT = 5;
527 
528     uint32 internal constant RARITY_NONE = 0;
529     uint32 internal constant RARITY_COMMON = 1;
530     uint32 internal constant RARITY_RARE = 2;
531     uint32 internal constant RARITY_EPIC = 3;
532     uint32 internal constant RARITY_LEGENDARY = 4;
533     uint32 internal constant RARITY_UNIQUE = 5;
534 
535     struct ChestItem {
536         uint32 _class;
537         uint32 _type;
538         uint32 _rarity;
539         uint32 _tier;
540         uint32 _name;
541     }
542 
543     mapping(uint256 => ChestItem) chestItems;
544 
545     mapping(uint32 => uint32) apprenticeChestProbability;
546     mapping(uint32 => uint32) warriorChestProbability;
547     mapping(uint32 => uint32) gladiatorChestProbability;
548     mapping(uint32 => uint32) warlordChestProbability;
549 
550     constructor () public {
551         chestItems[0] = ChestItem(CLASS_RANGED, TYPE_RANGED_PRESALE_RIFLE, RARITY_NONE, 0, NAME_NONE);
552         chestItems[1] = ChestItem(CLASS_ARMOR, TYPE_ARMOR_PRESALE_ARMOR, RARITY_NONE, 0, NAME_NONE);
553         chestItems[2] = ChestItem(CLASS_LEGS, TYPE_LEGS_PRESALE_LEGS, RARITY_NONE, 0, NAME_NONE);
554         chestItems[3] = ChestItem(CLASS_BOOTS, TYPE_BOOTS_PRESALE_BOOTS, RARITY_NONE, 0, NAME_NONE);
555         chestItems[4] = ChestItem(CLASS_GLOVES, TYPE_GLOVES_PRESALE_GLOVES, RARITY_NONE, 0, NAME_NONE);
556         chestItems[5] = ChestItem(CLASS_HELMET, TYPE_HELMET_PRESALE_HELMET, RARITY_NONE, 0, NAME_NONE);
557         chestItems[6] = ChestItem(CLASS_NECKLACE, TYPE_NECKLACE_PRESALE_NECKLACE, RARITY_NONE, 0, NAME_NONE);
558         chestItems[7] = ChestItem(CLASS_MODS, TYPE_MODES_PRESALE_MODES, RARITY_NONE, 0, NAME_NONE);
559 
560         apprenticeChestProbability[0] = 60;
561         apprenticeChestProbability[1] = 29;
562         apprenticeChestProbability[2] = 5;
563         apprenticeChestProbability[3] = 3;
564         apprenticeChestProbability[4] = 2;
565         apprenticeChestProbability[5] = 1;
566 
567         warriorChestProbability[0] = 10;
568         warriorChestProbability[1] = 20;
569         warriorChestProbability[2] = 15;
570         warriorChestProbability[3] = 25;
571         warriorChestProbability[4] = 25;
572         warriorChestProbability[5] = 5;
573 
574         gladiatorChestProbability[0] = 15;
575         gladiatorChestProbability[1] = 15;
576         gladiatorChestProbability[2] = 20;
577         gladiatorChestProbability[3] = 20;
578         gladiatorChestProbability[4] = 18;
579         gladiatorChestProbability[5] = 12;
580 
581         warlordChestProbability[0] = 10;
582         warlordChestProbability[1] = 30;
583         warlordChestProbability[2] = 60;
584     }
585 
586     function getTier(uint32 _type, uint256 _id) internal pure returns (uint32){
587         if (_type == TYPE_CHEST_APPRENTICE) {
588             return (_id == 0 || _id == 3) ? 3 : (_id == 1 || _id == 4) ? 4 : 5;
589         } else if (_type == TYPE_CHEST_WARRIOR) {
590             return (_id == 0 || _id == 3 || _id == 5) ? 4 : (_id == 1 || _id == 4) ? 5 : 3;
591         } else if (_type == TYPE_CHEST_GLADIATOR) {
592             return (_id == 0 || _id == 3 || _id == 5) ? 5 : (_id == 2 || _id == 4) ? 5 : 3;
593         } else if (_type == TYPE_CHEST_WARLORD) {
594             return (_id == 1) ? 4 : 5;
595         } else {
596             require(false);
597         }
598     }
599 
600     function getRarity(uint32 _type, uint256 _id) internal pure returns (uint32) {
601         if (_type == TYPE_CHEST_APPRENTICE) {
602             return _id < 3 ? RARITY_RARE : RARITY_EPIC;
603         } else if (_type == TYPE_CHEST_WARRIOR) {
604             return _id < 2 ? RARITY_RARE : (_id > 1 && _id < 5) ? RARITY_EPIC : RARITY_LEGENDARY;
605         } else if (_type == TYPE_CHEST_GLADIATOR) {
606             return _id == 0 ? RARITY_RARE : (_id > 0 && _id < 4) ? RARITY_EPIC : RARITY_LEGENDARY;
607         } else if (_type == TYPE_CHEST_WARLORD) {
608             return (_id == 0) ? RARITY_EPIC : RARITY_LEGENDARY;
609         } else {
610             require(false);
611         }
612     }
613 
614     function isApprenticeChest(uint256 _identifier) internal pure returns (bool) {
615         return ItemUtils.getType(_identifier) == TYPE_CHEST_APPRENTICE;
616     }
617 
618     function isWarriorChest(uint256 _identifier) internal pure returns (bool) {
619         return ItemUtils.getType(_identifier) == TYPE_CHEST_WARRIOR;
620     }
621 
622     function isGladiatorChest(uint256 _identifier) internal pure returns (bool) {
623         return ItemUtils.getType(_identifier) == TYPE_CHEST_GLADIATOR;
624     }
625 
626     function isWarlordChest(uint256 _identifier) internal pure returns (bool) {
627         return ItemUtils.getType(_identifier) == TYPE_CHEST_WARLORD;
628     }
629 
630     function getApprenticeDistributedRandom(uint256 rnd) internal view returns (uint256) {
631         uint256 tempDist = 0;
632         for (uint8 i = 0; i < 6; i++) {
633             tempDist += apprenticeChestProbability[i];
634             if (rnd <= tempDist) {
635                 return i;
636             }
637         }
638         return 0;
639     }
640 
641     function getWarriorDistributedRandom(uint256 rnd) internal view returns (uint256) {
642         uint256 tempDist = 0;
643         for (uint8 i = 0; i < 6; i++) {
644             tempDist += warriorChestProbability[i];
645             if (rnd <= tempDist) {
646                 return i;
647             }
648         }
649         return 0;
650     }
651 
652     function getGladiatorDistributedRandom(uint256 rnd) internal view returns (uint256) {
653         uint256 tempDist = 0;
654         for (uint8 i = 0; i < 6; i++) {
655             tempDist += gladiatorChestProbability[i];
656             if (rnd <= tempDist) {
657                 return i;
658             }
659         }
660         return 0;
661     }
662 
663     function getWarlordDistributedRandom(uint256 rnd) internal view returns (uint256) {
664         uint256 tempDist = 0;
665         for (uint8 i = 0; i < 3; i++) {
666             tempDist += warlordChestProbability[i];
667             if (rnd <= tempDist) {
668                 return i;
669             }
670         }
671         return 0;
672     }
673 }
674 
675 // File: contracts\introspection\ERC165.sol
676 
677 /**
678  * @title ERC165
679  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
680  */
681 interface ERC165 {
682 
683   /**
684    * @notice Query if a contract implements an interface
685    * @param _interfaceId The interface identifier, as specified in ERC-165
686    * @dev Interface identification is specified in ERC-165. This function
687    * uses less than 30,000 gas.
688    */
689   function supportsInterface(bytes4 _interfaceId)
690     external
691     view
692     returns (bool);
693 }
694 
695 // File: contracts\token\ERC721\ERC721Basic.sol
696 
697 /**
698  * @title ERC721 Non-Fungible Token Standard basic interface
699  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
700  */
701 contract ERC721Basic is ERC165 {
702 
703   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
704   /*
705    * 0x80ac58cd ===
706    *   bytes4(keccak256('balanceOf(address)')) ^
707    *   bytes4(keccak256('ownerOf(uint256)')) ^
708    *   bytes4(keccak256('approve(address,uint256)')) ^
709    *   bytes4(keccak256('getApproved(uint256)')) ^
710    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
711    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
712    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
713    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
714    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
715    */
716 
717   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
718   /*
719    * 0x4f558e79 ===
720    *   bytes4(keccak256('exists(uint256)'))
721    */
722 
723   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
724   /**
725    * 0x780e9d63 ===
726    *   bytes4(keccak256('totalSupply()')) ^
727    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
728    *   bytes4(keccak256('tokenByIndex(uint256)'))
729    */
730 
731   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
732   /**
733    * 0x5b5e139f ===
734    *   bytes4(keccak256('name()')) ^
735    *   bytes4(keccak256('symbol()')) ^
736    *   bytes4(keccak256('tokenURI(uint256)'))
737    */
738 
739   event Transfer(
740     address indexed _from,
741     address indexed _to,
742     uint256 indexed _tokenId
743   );
744   event Approval(
745     address indexed _owner,
746     address indexed _approved,
747     uint256 indexed _tokenId
748   );
749   event ApprovalForAll(
750     address indexed _owner,
751     address indexed _operator,
752     bool _approved
753   );
754 
755   function balanceOf(address _owner) public view returns (uint256 _balance);
756   function ownerOf(uint256 _tokenId) public view returns (address _owner);
757   function exists(uint256 _tokenId) public view returns (bool _exists);
758 
759   function approve(address _to, uint256 _tokenId) public;
760   function getApproved(uint256 _tokenId)
761     public view returns (address _operator);
762 
763   function setApprovalForAll(address _operator, bool _approved) public;
764   function isApprovedForAll(address _owner, address _operator)
765     public view returns (bool);
766 
767   function transferFrom(address _from, address _to, uint256 _tokenId) public;
768   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
769     public;
770 
771   function safeTransferFrom(
772     address _from,
773     address _to,
774     uint256 _tokenId,
775     bytes _data
776   )
777     public;
778 }
779 
780 // File: contracts\token\ERC721\ERC721.sol
781 
782 /**
783  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
784  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
785  */
786 contract ERC721Enumerable is ERC721Basic {
787   function totalSupply() public view returns (uint256);
788   function tokenOfOwnerByIndex(
789     address _owner,
790     uint256 _index
791   )
792     public
793     view
794     returns (uint256 _tokenId);
795 
796   function tokenByIndex(uint256 _index) public view returns (uint256);
797 }
798 
799 
800 /**
801  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
802  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
803  */
804 contract ERC721Metadata is ERC721Basic {
805   function name() external view returns (string _name);
806   function symbol() external view returns (string _symbol);
807   function tokenURI(uint256 _tokenId) public view returns (string);
808 }
809 
810 
811 /**
812  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
813  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
814  */
815 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
816 }
817 
818 // File: contracts\token\ERC721\ERC721Receiver.sol
819 
820 /**
821  * @title ERC721 token receiver interface
822  * @dev Interface for any contract that wants to support safeTransfers
823  * from ERC721 asset contracts.
824  */
825 contract ERC721Receiver {
826   /**
827    * @dev Magic value to be returned upon successful reception of an NFT
828    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
829    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
830    */
831   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
832 
833   /**
834    * @notice Handle the receipt of an NFT
835    * @dev The ERC721 smart contract calls this function on the recipient
836    * after a `safetransfer`. This function MAY throw to revert and reject the
837    * transfer. Return of other than the magic value MUST result in the
838    * transaction being reverted.
839    * Note: the contract address is always the message sender.
840    * @param _operator The address which called `safeTransferFrom` function
841    * @param _from The address which previously owned the token
842    * @param _tokenId The NFT identifier which is being transferred
843    * @param _data Additional data with no specified format
844    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
845    */
846   function onERC721Received(
847     address _operator,
848     address _from,
849     uint256 _tokenId,
850     bytes _data
851   )
852     public
853     returns(bytes4);
854 }
855 
856 // File: contracts\introspection\SupportsInterfaceWithLookup.sol
857 
858 /**
859  * @title SupportsInterfaceWithLookup
860  * @author Matt Condon (@shrugs)
861  * @dev Implements ERC165 using a lookup table.
862  */
863 contract SupportsInterfaceWithLookup is ERC165 {
864 
865   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
866   /**
867    * 0x01ffc9a7 ===
868    *   bytes4(keccak256('supportsInterface(bytes4)'))
869    */
870 
871   /**
872    * @dev a mapping of interface id to whether or not it's supported
873    */
874   mapping(bytes4 => bool) internal supportedInterfaces;
875 
876   /**
877    * @dev A contract implementing SupportsInterfaceWithLookup
878    * implement ERC165 itself
879    */
880   constructor()
881     public
882   {
883     _registerInterface(InterfaceId_ERC165);
884   }
885 
886   /**
887    * @dev implement supportsInterface(bytes4) using a lookup table
888    */
889   function supportsInterface(bytes4 _interfaceId)
890     external
891     view
892     returns (bool)
893   {
894     return supportedInterfaces[_interfaceId];
895   }
896 
897   /**
898    * @dev private method for registering an interface
899    */
900   function _registerInterface(bytes4 _interfaceId)
901     internal
902   {
903     require(_interfaceId != 0xffffffff);
904     supportedInterfaces[_interfaceId] = true;
905   }
906 }
907 
908 // File: contracts\utils\AddressUtils.sol
909 
910 /**
911  * Utility library of inline functions on addresses
912  */
913 library AddressUtils {
914 
915   /**
916    * Returns whether the target address is a contract
917    * @dev This function will return false if invoked during the constructor of a contract,
918    * as the code is not actually created until after the constructor finishes.
919    * @param _addr address to check
920    * @return whether the target address is a contract
921    */
922   function isContract(address _addr) internal view returns (bool) {
923     uint256 size;
924     // XXX Currently there is no better way to check if there is a contract in an address
925     // than to check the size of the code at that address.
926     // See https://ethereum.stackexchange.com/a/14016/36603
927     // for more details about how this works.
928     // TODO Check this again before the Serenity release, because all addresses will be
929     // contracts then.
930     // solium-disable-next-line security/no-inline-assembly
931     assembly { size := extcodesize(_addr) }
932     return size > 0;
933   }
934 
935 }
936 
937 // File: contracts\token\ERC721\ERC721BasicToken.sol
938 
939 /**
940  * @title ERC721 Non-Fungible Token Standard basic implementation
941  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
942  */
943 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
944 
945   using SafeMath for uint256;
946   using AddressUtils for address;
947 
948   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
949   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
950   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
951 
952   // Mapping from token ID to owner
953   mapping (uint256 => address) internal tokenOwner;
954 
955   // Mapping from token ID to approved address
956   mapping (uint256 => address) internal tokenApprovals;
957 
958   // Mapping from owner to number of owned token
959   mapping (address => uint256) internal ownedTokensCount;
960 
961   // Mapping from owner to operator approvals
962   mapping (address => mapping (address => bool)) internal operatorApprovals;
963 
964   constructor()
965     public
966   {
967     // register the supported interfaces to conform to ERC721 via ERC165
968     _registerInterface(InterfaceId_ERC721);
969     _registerInterface(InterfaceId_ERC721Exists);
970   }
971 
972   /**
973    * @dev Gets the balance of the specified address
974    * @param _owner address to query the balance of
975    * @return uint256 representing the amount owned by the passed address
976    */
977   function balanceOf(address _owner) public view returns (uint256) {
978     require(_owner != address(0));
979     return ownedTokensCount[_owner];
980   }
981 
982   /**
983    * @dev Gets the owner of the specified token ID
984    * @param _tokenId uint256 ID of the token to query the owner of
985    * @return owner address currently marked as the owner of the given token ID
986    */
987   function ownerOf(uint256 _tokenId) public view returns (address) {
988     address owner = tokenOwner[_tokenId];
989     require(owner != address(0));
990     return owner;
991   }
992 
993   /**
994    * @dev Returns whether the specified token exists
995    * @param _tokenId uint256 ID of the token to query the existence of
996    * @return whether the token exists
997    */
998   function exists(uint256 _tokenId) public view returns (bool) {
999     address owner = tokenOwner[_tokenId];
1000     return owner != address(0);
1001   }
1002 
1003   /**
1004    * @dev Approves another address to transfer the given token ID
1005    * The zero address indicates there is no approved address.
1006    * There can only be one approved address per token at a given time.
1007    * Can only be called by the token owner or an approved operator.
1008    * @param _to address to be approved for the given token ID
1009    * @param _tokenId uint256 ID of the token to be approved
1010    */
1011   function approve(address _to, uint256 _tokenId) public {
1012     address owner = ownerOf(_tokenId);
1013     require(_to != owner);
1014     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1015 
1016     tokenApprovals[_tokenId] = _to;
1017     emit Approval(owner, _to, _tokenId);
1018   }
1019 
1020   /**
1021    * @dev Gets the approved address for a token ID, or zero if no address set
1022    * @param _tokenId uint256 ID of the token to query the approval of
1023    * @return address currently approved for the given token ID
1024    */
1025   function getApproved(uint256 _tokenId) public view returns (address) {
1026     return tokenApprovals[_tokenId];
1027   }
1028 
1029   /**
1030    * @dev Sets or unsets the approval of a given operator
1031    * An operator is allowed to transfer all tokens of the sender on their behalf
1032    * @param _to operator address to set the approval
1033    * @param _approved representing the status of the approval to be set
1034    */
1035   function setApprovalForAll(address _to, bool _approved) public {
1036     require(_to != msg.sender);
1037     operatorApprovals[msg.sender][_to] = _approved;
1038     emit ApprovalForAll(msg.sender, _to, _approved);
1039   }
1040 
1041   /**
1042    * @dev Tells whether an operator is approved by a given owner
1043    * @param _owner owner address which you want to query the approval of
1044    * @param _operator operator address which you want to query the approval of
1045    * @return bool whether the given operator is approved by the given owner
1046    */
1047   function isApprovedForAll(
1048     address _owner,
1049     address _operator
1050   )
1051     public
1052     view
1053     returns (bool)
1054   {
1055     return operatorApprovals[_owner][_operator];
1056   }
1057 
1058   /**
1059    * @dev Transfers the ownership of a given token ID to another address
1060    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1061    * Requires the msg sender to be the owner, approved, or operator
1062    * @param _from current owner of the token
1063    * @param _to address to receive the ownership of the given token ID
1064    * @param _tokenId uint256 ID of the token to be transferred
1065   */
1066   function transferFrom(
1067     address _from,
1068     address _to,
1069     uint256 _tokenId
1070   )
1071     public
1072   {
1073     require(isApprovedOrOwner(msg.sender, _tokenId));
1074     require(_from != address(0));
1075     require(_to != address(0));
1076 
1077     clearApproval(_from, _tokenId);
1078     removeTokenFrom(_from, _tokenId);
1079     addTokenTo(_to, _tokenId);
1080 
1081     emit Transfer(_from, _to, _tokenId);
1082   }
1083 
1084   /**
1085    * @dev Safely transfers the ownership of a given token ID to another address
1086    * If the target address is a contract, it must implement `onERC721Received`,
1087    * which is called upon a safe transfer, and return the magic value
1088    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1089    * the transfer is reverted.
1090    *
1091    * Requires the msg sender to be the owner, approved, or operator
1092    * @param _from current owner of the token
1093    * @param _to address to receive the ownership of the given token ID
1094    * @param _tokenId uint256 ID of the token to be transferred
1095   */
1096   function safeTransferFrom(
1097     address _from,
1098     address _to,
1099     uint256 _tokenId
1100   )
1101     public
1102   {
1103     // solium-disable-next-line arg-overflow
1104     safeTransferFrom(_from, _to, _tokenId, "");
1105   }
1106 
1107   /**
1108    * @dev Safely transfers the ownership of a given token ID to another address
1109    * If the target address is a contract, it must implement `onERC721Received`,
1110    * which is called upon a safe transfer, and return the magic value
1111    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1112    * the transfer is reverted.
1113    * Requires the msg sender to be the owner, approved, or operator
1114    * @param _from current owner of the token
1115    * @param _to address to receive the ownership of the given token ID
1116    * @param _tokenId uint256 ID of the token to be transferred
1117    * @param _data bytes data to send along with a safe transfer check
1118    */
1119   function safeTransferFrom(
1120     address _from,
1121     address _to,
1122     uint256 _tokenId,
1123     bytes _data
1124   )
1125     public
1126   {
1127     transferFrom(_from, _to, _tokenId);
1128     // solium-disable-next-line arg-overflow
1129     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1130   }
1131 
1132   /**
1133    * @dev Returns whether the given spender can transfer a given token ID
1134    * @param _spender address of the spender to query
1135    * @param _tokenId uint256 ID of the token to be transferred
1136    * @return bool whether the msg.sender is approved for the given token ID,
1137    *  is an operator of the owner, or is the owner of the token
1138    */
1139   function isApprovedOrOwner(
1140     address _spender,
1141     uint256 _tokenId
1142   )
1143     internal
1144     view
1145     returns (bool)
1146   {
1147     address owner = ownerOf(_tokenId);
1148     // Disable solium check because of
1149     // https://github.com/duaraghav8/Solium/issues/175
1150     // solium-disable-next-line operator-whitespace
1151     return (
1152       _spender == owner ||
1153       getApproved(_tokenId) == _spender ||
1154       isApprovedForAll(owner, _spender)
1155     );
1156   }
1157 
1158   /**
1159    * @dev Internal function to mint a new token
1160    * Reverts if the given token ID already exists
1161    * @param _to The address that will own the minted token
1162    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1163    */
1164   function _mint(address _to, uint256 _tokenId) internal {
1165     require(_to != address(0));
1166     addTokenTo(_to, _tokenId);
1167     emit Transfer(address(0), _to, _tokenId);
1168   }
1169 
1170   /**
1171    * @dev Internal function to burn a specific token
1172    * Reverts if the token does not exist
1173    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1174    */
1175   function _burn(address _owner, uint256 _tokenId) internal {
1176     clearApproval(_owner, _tokenId);
1177     removeTokenFrom(_owner, _tokenId);
1178     emit Transfer(_owner, address(0), _tokenId);
1179   }
1180 
1181   /**
1182    * @dev Internal function to clear current approval of a given token ID
1183    * Reverts if the given address is not indeed the owner of the token
1184    * @param _owner owner of the token
1185    * @param _tokenId uint256 ID of the token to be transferred
1186    */
1187   function clearApproval(address _owner, uint256 _tokenId) internal {
1188     require(ownerOf(_tokenId) == _owner);
1189     if (tokenApprovals[_tokenId] != address(0)) {
1190       tokenApprovals[_tokenId] = address(0);
1191     }
1192   }
1193 
1194   /**
1195    * @dev Internal function to add a token ID to the list of a given address
1196    * @param _to address representing the new owner of the given token ID
1197    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1198    */
1199   function addTokenTo(address _to, uint256 _tokenId) internal {
1200     require(tokenOwner[_tokenId] == address(0));
1201     tokenOwner[_tokenId] = _to;
1202     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1203   }
1204 
1205   /**
1206    * @dev Internal function to remove a token ID from the list of a given address
1207    * @param _from address representing the previous owner of the given token ID
1208    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1209    */
1210   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1211     require(ownerOf(_tokenId) == _from);
1212     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1213     tokenOwner[_tokenId] = address(0);
1214   }
1215 
1216   /**
1217    * @dev Internal function to invoke `onERC721Received` on a target address
1218    * The call is not executed if the target address is not a contract
1219    * @param _from address representing the previous owner of the given token ID
1220    * @param _to target address that will receive the tokens
1221    * @param _tokenId uint256 ID of the token to be transferred
1222    * @param _data bytes optional data to send along with the call
1223    * @return whether the call correctly returned the expected magic value
1224    */
1225   function checkAndCallSafeTransfer(
1226     address _from,
1227     address _to,
1228     uint256 _tokenId,
1229     bytes _data
1230   )
1231     internal
1232     returns (bool)
1233   {
1234     if (!_to.isContract()) {
1235       return true;
1236     }
1237     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1238       msg.sender, _from, _tokenId, _data);
1239     return (retval == ERC721_RECEIVED);
1240   }
1241 }
1242 
1243 // File: contracts\token\ERC721\ERC721Token.sol
1244 
1245 /**
1246  * @title Full ERC721 Token
1247  * This implementation includes all the required and some optional functionality of the ERC721 standard
1248  * Moreover, it includes approve all functionality using operator terminology
1249  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1250  */
1251 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1252 
1253   // Token name
1254   string internal name_;
1255 
1256   // Token symbol
1257   string internal symbol_;
1258 
1259   // Mapping from owner to list of owned token IDs
1260   mapping(address => uint256[]) internal ownedTokens;
1261 
1262   // Mapping from token ID to index of the owner tokens list
1263   mapping(uint256 => uint256) internal ownedTokensIndex;
1264 
1265   // Array with all token ids, used for enumeration
1266   uint256[] internal allTokens;
1267 
1268   // Mapping from token id to position in the allTokens array
1269   mapping(uint256 => uint256) internal allTokensIndex;
1270 
1271   /**
1272    * @dev Constructor function
1273    */
1274   constructor(string _name, string _symbol) public {
1275     name_ = _name;
1276     symbol_ = _symbol;
1277 
1278     // register the supported interfaces to conform to ERC721 via ERC165
1279     _registerInterface(InterfaceId_ERC721Enumerable);
1280     _registerInterface(InterfaceId_ERC721Metadata);
1281   }
1282 
1283   /**
1284    * @dev Gets the token name
1285    * @return string representing the token name
1286    */
1287   function name() external view returns (string) {
1288     return name_;
1289   }
1290 
1291   /**
1292    * @dev Gets the token symbol
1293    * @return string representing the token symbol
1294    */
1295   function symbol() external view returns (string) {
1296     return symbol_;
1297   }
1298 
1299   /**
1300    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1301    * @param _owner address owning the tokens list to be accessed
1302    * @param _index uint256 representing the index to be accessed of the requested tokens list
1303    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1304    */
1305   function tokenOfOwnerByIndex(
1306     address _owner,
1307     uint256 _index
1308   )
1309     public
1310     view
1311     returns (uint256)
1312   {
1313     require(_index < balanceOf(_owner));
1314     return ownedTokens[_owner][_index];
1315   }
1316 
1317   /**
1318    * @dev Gets the total amount of tokens stored by the contract
1319    * @return uint256 representing the total amount of tokens
1320    */
1321   function totalSupply() public view returns (uint256) {
1322     return allTokens.length;
1323   }
1324 
1325   /**
1326    * @dev Gets the token ID at a given index of all the tokens in this contract
1327    * Reverts if the index is greater or equal to the total number of tokens
1328    * @param _index uint256 representing the index to be accessed of the tokens list
1329    * @return uint256 token ID at the given index of the tokens list
1330    */
1331   function tokenByIndex(uint256 _index) public view returns (uint256) {
1332     require(_index < totalSupply());
1333     return allTokens[_index];
1334   }
1335 
1336 
1337   /**
1338    * @dev Internal function to add a token ID to the list of a given address
1339    * @param _to address representing the new owner of the given token ID
1340    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1341    */
1342   function addTokenTo(address _to, uint256 _tokenId) internal {
1343     super.addTokenTo(_to, _tokenId);
1344     uint256 length = ownedTokens[_to].length;
1345     ownedTokens[_to].push(_tokenId);
1346     ownedTokensIndex[_tokenId] = length;
1347   }
1348 
1349   /**
1350    * @dev Internal function to remove a token ID from the list of a given address
1351    * @param _from address representing the previous owner of the given token ID
1352    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1353    */
1354   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1355     super.removeTokenFrom(_from, _tokenId);
1356 
1357     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1358     // then delete the last slot.
1359     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1360     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1361     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1362 
1363     ownedTokens[_from][tokenIndex] = lastToken;
1364     // This also deletes the contents at the last position of the array
1365     ownedTokens[_from].length--;
1366 
1367     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1368     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1369     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1370 
1371     ownedTokensIndex[_tokenId] = 0;
1372     ownedTokensIndex[lastToken] = tokenIndex;
1373   }
1374 
1375   /**
1376    * @dev Internal function to mint a new token
1377    * Reverts if the given token ID already exists
1378    * @param _to address the beneficiary that will own the minted token
1379    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1380    */
1381   function _mint(address _to, uint256 _tokenId) internal {
1382     super._mint(_to, _tokenId);
1383 
1384     allTokensIndex[_tokenId] = allTokens.length;
1385     allTokens.push(_tokenId);
1386   }
1387 
1388   /**
1389    * @dev Internal function to burn a specific token
1390    * Reverts if the token does not exist
1391    * @param _owner owner of the token to burn
1392    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1393    */
1394   function _burn(address _owner, uint256 _tokenId) internal {
1395     super._burn(_owner, _tokenId);
1396 
1397     // Reorg all tokens array
1398     uint256 tokenIndex = allTokensIndex[_tokenId];
1399     uint256 lastTokenIndex = allTokens.length.sub(1);
1400     uint256 lastToken = allTokens[lastTokenIndex];
1401 
1402     allTokens[tokenIndex] = lastToken;
1403     allTokens[lastTokenIndex] = 0;
1404 
1405     allTokens.length--;
1406     allTokensIndex[_tokenId] = 0;
1407     allTokensIndex[lastToken] = tokenIndex;
1408   }
1409 
1410 }
1411 
1412 // File: contracts\GlitchGoonsItem.sol
1413 
1414 contract GlitchGoonsItem is PresaleGacha, ERC721Token, Ownable {
1415     string public constant name = "GlitchGoons";
1416 
1417     string public constant symbol = "GG";
1418 
1419     uint256 internal id;
1420     string internal tokenUriPref = "https://static.glitch-goons.com/metadata/gg/";
1421 
1422     struct PresalePack {
1423         uint32 available;
1424         uint32 gameCoin;
1425         uint256 price;
1426     }
1427 
1428     PresalePack tokenPack;
1429     PresalePack investorPack;
1430     PresalePack apprenticeChest;
1431     PresalePack warriorChest;
1432     PresalePack gladiatorChest;
1433     PresalePack warlordChest;
1434 
1435     uint256 private closingTime;
1436     uint256 private openingTime;
1437 
1438     GameCoin gameCoinContract;
1439 
1440     constructor (address _emitter, address _administrator, address _gameCoin, uint256 _openingTime, uint256 _closingTime)
1441     ERC721Token(name, symbol)
1442     public {
1443         setEmitter(_emitter);
1444         setAdministrator(_administrator);
1445 
1446         GameCoin gameCoinCandidate = GameCoin(_gameCoin);
1447         require(gameCoinCandidate.isGameCoin());
1448         gameCoinContract = gameCoinCandidate;
1449 
1450         tokenPack = PresalePack(50, 4000, 10 ether);
1451         investorPack = PresalePack(1, 10 ** 6, 500 ether);
1452 
1453         apprenticeChest = PresalePack(550, 207, .5 ether);
1454         warriorChest = PresalePack(200, 717, 1.75 ether);
1455         gladiatorChest = PresalePack(80, 1405, 3.5 ether);
1456         warlordChest = PresalePack(35, 3890, 10 ether);
1457 
1458         closingTime = _closingTime;
1459         openingTime = _openingTime;
1460     }
1461 
1462     function addItemToInternal(address _to, uint256 _class, uint256 _type, uint256 _rarity, uint256 _tier, uint256 _name, uint256 _region) internal {
1463         uint256 identity = ItemUtils.createItem(_class, _type, _rarity, _tier, _name, _region);
1464         identity = ItemUtils.setUID(identity, ++id);
1465         _mint(_to, identity);
1466     }
1467 
1468     function addItemTo(address _to, uint256 _class, uint256 _type, uint256 _rarity, uint256 _tier, uint256 _name, uint256 _region) external onlyEmitter {
1469         addItemToInternal(_to, _class, _type, _rarity, _tier, _name, _region);
1470     }
1471 
1472     function buyTokenPack(uint256 _region) external onlyWhileOpen canBuyPack(tokenPack) payable {
1473         addItemToInternal(msg.sender, CLASS_CHEST, TYPE_CHEST_TOKEN_PACK, RARITY_NONE, 0, NAME_NONE, _region);
1474         tokenPack.available--;
1475         administrator.transfer(msg.value);
1476     }
1477 
1478     function buyInvestorPack(uint256 _region) external onlyWhileOpen canBuyPack(investorPack) payable {
1479         addItemToInternal(msg.sender, CLASS_CHEST, TYPE_CHEST_INVESTOR_PACK, RARITY_NONE, 0, NAME_NONE, _region);
1480         investorPack.available--;
1481         administrator.transfer(msg.value);
1482     }
1483 
1484     function buyApprenticeChest(uint256 _region) external onlyWhileOpen canBuyPack(apprenticeChest) payable {
1485         addItemToInternal(msg.sender, CLASS_CHEST, TYPE_CHEST_APPRENTICE, RARITY_NONE, 0, NAME_NONE, _region);
1486         apprenticeChest.available--;
1487         administrator.transfer(msg.value);
1488     }
1489 
1490     function buyWarriorChest(uint256 _region) external onlyWhileOpen canBuyPack(warriorChest) payable {
1491         addItemToInternal(msg.sender, CLASS_CHEST, TYPE_CHEST_WARRIOR, RARITY_NONE, 0, NAME_NONE, _region);
1492         warriorChest.available--;
1493         administrator.transfer(msg.value);
1494     }
1495 
1496     function buyGladiatorChest(uint256 _region) external onlyWhileOpen canBuyPack(gladiatorChest) payable {
1497         addItemToInternal(msg.sender, CLASS_CHEST, TYPE_CHEST_GLADIATOR, RARITY_NONE, 0, NAME_NONE, _region);
1498         gladiatorChest.available--;
1499         administrator.transfer(msg.value);
1500     }
1501 
1502     function buyWarlordChest(uint256 _region) external onlyWhileOpen canBuyPack(warlordChest) payable {
1503         addItemToInternal(msg.sender, CLASS_CHEST, TYPE_CHEST_WARLORD, RARITY_NONE, 0, NAME_NONE, _region);
1504         warlordChest.available--;
1505         administrator.transfer(msg.value);
1506     }
1507 
1508     function openChest(uint256 _identifier) external onlyChestOwner(_identifier) {
1509         uint256 _type = ItemUtils.getType(_identifier);
1510 
1511         if (_type == TYPE_CHEST_TOKEN_PACK) {
1512             transferTokens(tokenPack);
1513         } else if (_type == TYPE_CHEST_INVESTOR_PACK) {
1514             transferTokens(investorPack);
1515         } else {
1516             uint256 blockNum = block.number;
1517 
1518             for (uint i = 0; i < 5; i++) {
1519                 uint256 hash = uint256(keccak256(abi.encodePacked(_identifier, blockNum, i, block.coinbase, block.timestamp, block.difficulty)));
1520                 blockNum--;
1521                 uint256 rnd = hash % 101;
1522                 uint32 _tier;
1523                 uint32 _rarity;
1524                 uint256 _id;
1525 
1526                 if (isApprenticeChest(_identifier)) {
1527                     _id = getApprenticeDistributedRandom(rnd);
1528                     _rarity = getRarity(TYPE_CHEST_APPRENTICE, _id);
1529                     _tier = getTier(TYPE_CHEST_APPRENTICE, _id);
1530                 } else if (isWarriorChest(_identifier)) {
1531                     _id = getWarriorDistributedRandom(rnd);
1532                     _rarity = getRarity(TYPE_CHEST_WARRIOR, _id);
1533                     _tier = getTier(TYPE_CHEST_WARRIOR, _id);
1534                 } else if (isGladiatorChest(_identifier)) {
1535                     _id = getGladiatorDistributedRandom(rnd);
1536                     _rarity = getRarity(TYPE_CHEST_GLADIATOR, _id);
1537                     _tier = getTier(TYPE_CHEST_GLADIATOR, _id);
1538                 } else if (isWarlordChest(_identifier)) {
1539                     _id = getWarlordDistributedRandom(rnd);
1540                     _rarity = getRarity(TYPE_CHEST_WARLORD, _id);
1541                     _tier = getTier(TYPE_CHEST_WARLORD, _id);
1542                 } else {
1543                     require(false);
1544                 }
1545 
1546                 ChestItem storage chestItem = chestItems[hash % 8];
1547                 uint256 _region = ItemUtils.getRegion(_identifier);
1548                 uint256 _name = 1 + hash % 5;
1549                 if (i == 0) {
1550                     if (isWarriorChest(_identifier)) {
1551                         addItemToInternal(msg.sender, chestItem._class, chestItem._type, RARITY_RARE, 3, _name, _region);
1552                     } else if (isGladiatorChest(_identifier)) {
1553                         addItemToInternal(msg.sender, chestItem._class, chestItem._type, RARITY_RARE, 5, _name, _region);
1554                     } else if (isWarlordChest(_identifier)) {
1555                         addItemToInternal(msg.sender, chestItem._class, chestItem._type, RARITY_LEGENDARY, 5, _name, _region);
1556                     } else {
1557                         addItemToInternal(msg.sender, chestItem._class, chestItem._type, _rarity, _tier, _name, _region);
1558                     }
1559                 } else {
1560                     addItemToInternal(msg.sender, chestItem._class, chestItem._type, _rarity, _tier, _name, _region);
1561                 }
1562             }
1563         }
1564 
1565         _burn(msg.sender, _identifier);
1566     }
1567 
1568     function getTokenPacksAvailable() view public returns (uint256) {
1569         return tokenPack.available;
1570     }
1571 
1572     function getTokenPackPrice() view public returns (uint256) {
1573         return tokenPack.price;
1574     }
1575 
1576     function getInvestorPacksAvailable() view public returns (uint256) {
1577         return investorPack.available;
1578     }
1579 
1580     function getInvestorPackPrice() view public returns (uint256) {
1581         return investorPack.price;
1582     }
1583 
1584     function getApprenticeChestAvailable() view public returns (uint256) {
1585         return apprenticeChest.available;
1586     }
1587 
1588     function getApprenticeChestPrice() view public returns (uint256) {
1589         return apprenticeChest.price;
1590     }
1591 
1592     function getWarriorChestAvailable() view public returns (uint256) {
1593         return warriorChest.available;
1594     }
1595 
1596     function getWarriorChestPrice() view public returns (uint256) {
1597         return warriorChest.price;
1598     }
1599 
1600     function getGladiatorChestAvailable() view public returns (uint256) {
1601         return gladiatorChest.available;
1602     }
1603 
1604     function getGladiatorChestPrice() view public returns (uint256) {
1605         return gladiatorChest.price;
1606     }
1607 
1608     function getWarlordChestAvailable() view public returns (uint256) {
1609         return warlordChest.available;
1610     }
1611 
1612     function getWarlordChestPrice() view public returns (uint256) {
1613         return warlordChest.price;
1614     }
1615 
1616     /**
1617     * @dev Reverts if not in presale time range.
1618     */
1619     modifier onlyWhileOpen {
1620         require(isOpen());
1621         _;
1622     }
1623 
1624     modifier canBuyPack(PresalePack pack) {
1625         require(msg.value == pack.price);
1626         require(pack.available > 0);
1627         _;
1628     }
1629 
1630     modifier onlyChestOwner(uint256 _identity) {
1631         require(ownerOf(_identity) == msg.sender);
1632         require(ItemUtils.getClass(_identity) == CLASS_CHEST);
1633         _;
1634     }
1635 
1636     /**
1637     * @return true if the presale is open, false otherwise.
1638     */
1639     function isOpen() public view returns (bool) {
1640         return block.timestamp >= openingTime && block.timestamp <= closingTime;
1641     }
1642 
1643     function getClosingTime() public view returns (uint256) {
1644         return closingTime;
1645     }
1646 
1647     function getOpeningTime() public view returns (uint256) {
1648         return openingTime;
1649     }
1650 
1651     function transferTokens(PresalePack pack) internal {
1652         require(gameCoinContract.balanceOf(address(this)) >= pack.gameCoin);
1653         gameCoinContract.transfer(msg.sender, pack.gameCoin);
1654     }
1655 
1656     function tokenURI(uint256 _tokenId) public view returns (string) {
1657         require(exists(_tokenId));
1658         return string(abi.encodePacked(tokenUriPref, StringUtils.uint2str(ItemUtils.getUID(_tokenId)), ".json"));
1659     }
1660 
1661     function setTokenUriPref(string _uri) public onlyAdministrator {
1662         tokenUriPref = _uri;
1663     }
1664 }