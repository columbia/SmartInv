1 pragma solidity ^0.4.24;
2 /*
3 ______ _   _ _   _  _   ___   __
4 | ___ \ | | | \ | || \ | \ \ / /
5 | |_/ / | | |  \| ||  \| |\ V / 
6 | ___ \ | | | . ` || . ` | \ /  
7 | |_/ / |_| | |\  || |\  | | |  
8 \____/ \___/\_| \_/\_| \_/ \_/   
9  _____   ___  ___  ___ _____    
10 |  __ \ / _ \ |  \/  ||  ___|   
11 | |  \// /_\ \| .  . || |__     
12 | | __ |  _  || |\/| ||  __|    
13 | |_\ \| | | || |  | || |___    
14  \____/\_| |_/\_|  |_/\____/ 
15                
16 * Author:  Konstantin G...
17 * Telegram: @bunnygame (en)
18 * email: info@bunnycoin.co
19 * site : http://bunnycoin.co 
20 */
21 
22 /**
23 * @title Ownable
24 * @dev The Ownable contract has an owner address, and provides basic authorization control
25 * functions, this simplifies the implementation of "user permissions".
26 */
27 contract Ownable {
28     
29     address ownerCEO;
30     address ownerMoney;  
31      
32     address privAddress; 
33     address addressAdmixture;
34     
35     /**
36     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37     * account.
38     */
39     constructor() public { 
40         ownerCEO = msg.sender; 
41         ownerMoney = msg.sender;
42     }
43  
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47     modifier onlyOwner() {
48         require(msg.sender == ownerCEO);
49         _;
50     }
51    
52     function transferOwnership(address add) public onlyOwner {
53         if (add != address(0)) {
54             ownerCEO = add;
55         }
56     }
57  
58     function transferOwnerMoney(address _ownerMoney) public  onlyOwner {
59         if (_ownerMoney != address(0)) {
60             ownerMoney = _ownerMoney;
61         }
62     }
63  
64     function getOwnerMoney() public view onlyOwner returns(address) {
65         return ownerMoney;
66     } 
67     /**
68     *  @dev private contract
69      */
70     function getPrivAddress() public view onlyOwner returns(address) {
71         return privAddress;
72     }
73     function getAddressAdmixture() public view onlyOwner returns(address) {
74         return addressAdmixture;
75     }
76 } 
77 
78 
79 
80 /**
81  * @title Whitelist
82  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
83  * @dev This simplifies the implementation of "user permissions".
84  */
85 contract Whitelist is Ownable {
86     mapping(address => bool) public whitelist;
87 
88     mapping(uint  => address)   whitelistCheck;
89     uint public countAddress = 0;
90 
91     event WhitelistedAddressAdded(address addr);
92     event WhitelistedAddressRemoved(address addr);
93  
94   /**
95    * @dev Throws if called by any account that's not whitelisted.
96    */
97     modifier onlyWhitelisted() {
98         require(whitelist[msg.sender]);
99         _;
100     }
101 
102     constructor() public {
103             whitelist[msg.sender] = true;  
104     }
105 
106   /**
107    * @dev add an address to the whitelist
108    * @param addr address
109    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
110    */
111     function addAddressToWhitelist(address addr) onlyWhitelisted public returns(bool success) {
112         if (!whitelist[addr]) {
113             whitelist[addr] = true;
114 
115             countAddress = countAddress + 1;
116             whitelistCheck[countAddress] = addr;
117 
118             emit WhitelistedAddressAdded(addr);
119             success = true;
120         }
121     }
122 
123     function getWhitelistCheck(uint key) onlyWhitelisted view public returns(address) {
124         return whitelistCheck[key];
125     }
126 
127 
128     function getInWhitelist(address addr) public view returns(bool) {
129         return whitelist[addr];
130     }
131     function getOwnerCEO() public onlyWhitelisted view returns(address) {
132         return ownerCEO;
133     }
134  
135     /**
136     * @dev add addresses to the whitelist
137     * @param addrs addresses
138     * @return true if at least one address was added to the whitelist,
139     * false if all addresses were already in the whitelist
140     */
141     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
142         for (uint256 i = 0; i < addrs.length; i++) {
143             if (addAddressToWhitelist(addrs[i])) {
144                 success = true;
145             }
146         }
147     }
148 
149     /**
150     * @dev remove an address from the whitelist
151     * @param addr address
152     * @return true if the address was removed from the whitelist,
153     * false if the address wasn't in the whitelist in the first place
154     */
155     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
156         if (whitelist[addr]) {
157             whitelist[addr] = false;
158             emit WhitelistedAddressRemoved(addr);
159             success = true;
160         }
161     }
162 
163     /**
164     * @dev remove addresses from the whitelist
165     * @param addrs addresses
166     * @return true if at least one address was removed from the whitelist,
167     * false if all addresses weren't in the whitelist in the first place
168     */
169     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
170         for (uint256 i = 0; i < addrs.length; i++) {
171             if (removeAddressFromWhitelist(addrs[i])) {
172                 success = true;
173             }
174         }
175     }
176 }
177 
178 /**
179  * @title SafeMath
180  * @dev Math operations with safety checks that throw on error
181  */
182 library SafeMath {
183     
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         if (a == 0) {
186             return 0;
187         }
188         uint c = a * b;
189         assert(c / a == b);
190         return c;
191     }
192 
193     function div(uint256 a, uint256 b) internal pure returns (uint256) {
194         // assert(b > 0); // Solidity automatically throws when dividing by 0
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197         return c;
198     }
199 
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         assert(b <= a);
202         return a - b;
203     }
204 
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         assert(c >= a);
208         return c;
209     }
210   
211 }
212  
213 
214 contract BaseRabbit  is Whitelist {
215        
216 
217  
218     event EmotherCount(uint32 mother, uint summ);
219     event NewBunny(uint32 bunnyId, uint dnk, uint256 blocknumber, uint breed, uint procentAdmixture, uint admixture);
220     event ChengeSex(uint32 bunnyId, bool sex, uint256 price);
221     event SalaryBunny(uint32 bunnyId, uint cost);
222     event CreateChildren(uint32 matron, uint32 sire, uint32 child);
223     event BunnyDescription(uint32 bunnyId, string name);
224     event CoolduwnMother(uint32 bunnyId, uint num);
225 
226 
227     event Referral(address from, uint32 matronID, uint32 childID, uint currentTime);
228     event Approval(address owner, address approved, uint32 tokenId);
229     event OwnerBunnies(address owner, uint32  tokenId);
230     event Transfer(address from, address to, uint32 tokenId);
231 
232  
233 
234     using SafeMath for uint256;
235     bool pauseSave = false;
236     uint256 bigPrice = 0.005 ether;
237     
238     uint public commission_system = 5;
239      
240     // ID the last seal
241     uint32 public lastIdGen0;
242     uint public totalGen0 = 0;
243     // ID the last seal
244     uint public lastTimeGen0;
245     
246     // ID the last seal
247   //  uint public timeRangeCreateGen0 = 1800; 
248 
249     uint public promoGen0 = 15000;
250     uint public promoMoney = 1*bigPrice;
251     bool public promoPause = false;
252 
253 
254     function setPromoGen0(uint _promoGen0) public onlyWhitelisted() {
255         promoGen0 = _promoGen0;
256     }
257 
258     function setPromoPause() public onlyWhitelisted() {
259         promoPause = !promoPause;
260     }
261 
262 
263 
264     function setPromoMoney(uint _promoMoney) public onlyWhitelisted() {
265         promoMoney = _promoMoney;
266     }
267  
268 
269     mapping(uint32 => uint) public totalSalaryBunny;
270     mapping(uint32 => uint32[5]) public rabbitMother;
271     
272     mapping(uint32 => uint) public motherCount;
273     
274     // how many times did the rabbit cross
275     mapping(uint32 => uint) public rabbitBreedCount;
276 
277     mapping(uint32 => uint)  public rabbitSirePrice;
278     mapping(uint => uint32[]) public sireGenom;
279     mapping (uint32 => uint) mapDNK;
280    
281     uint32[12] public cooldowns = [
282         uint32(1 minutes),
283         uint32(2 minutes),
284         uint32(4 minutes),
285         uint32(8 minutes),
286         uint32(16 minutes),
287         uint32(32 minutes),
288         uint32(1 hours),
289         uint32(2 hours),
290         uint32(4 hours),
291         uint32(8 hours),
292         uint32(16 hours),
293         uint32(1 days)
294     ];
295 
296 
297     struct Rabbit { 
298          // parents
299         uint32 mother;
300         uint32 sire; 
301         // block in which a rabbit was born
302         uint birthblock;
303          // number of births or how many times were offspring
304         uint birthCount;
305          // The time when Rabbit last gave birth
306         uint birthLastTime;
307         // the current role of the rabbit
308         uint role;
309         //indexGenome   
310         uint genome;
311 
312         uint procentAdmixture;
313         uint admixture;
314     }
315 
316  
317     /**
318     * Where we will store information about rabbits
319     */
320     Rabbit[]  public rabbits;
321      
322     /**
323     * who owns the rabbit
324     */
325     mapping (uint32 => address) public rabbitToOwner; 
326     mapping (address => uint32[]) public ownerBunnies;
327     //mapping (address => uint) ownerRabbitCount;
328     mapping (uint32 => string) rabbitDescription;
329     mapping (uint32 => string) rabbitName; 
330 
331     //giff 
332     mapping (uint32 => bool) giffblock; 
333     mapping (address => bool) ownerGennezise;
334 
335 }
336 
337 
338 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
339 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
340 contract ERC721 {
341     // Required methods 
342 
343     function ownerOf(uint32 _tokenId) public view returns (address owner);
344     function approve(address _to, uint32 _tokenId) public returns (bool success);
345     function transfer(address _to, uint32 _tokenId) public;
346     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
347     function totalSupply() public view returns (uint total);
348     function balanceOf(address _owner) public view returns (uint balance);
349 
350 }
351 
352 /// @title Interface new rabbits address
353 contract PrivateRabbitInterface {
354     function getNewRabbit(address from)  public view returns (uint);
355     function mixDNK(uint dnkmother, uint dnksire, uint genome)  public view returns (uint);
356     function isUIntPrivate() public pure returns (bool);
357 }
358 
359 contract AdmixtureInterface {
360     function getAdmixture(uint m, uint w)  public view returns (uint procentAdmixture, uint admixture);
361 }
362 
363  
364 
365 
366 contract BodyRabbit is BaseRabbit, ERC721 {
367     uint public totalBunny = 0;
368     string public constant name = "CryptoRabbits";
369     string public constant symbol = "CRB";
370 
371 
372     PrivateRabbitInterface privateContract;
373     AdmixtureInterface AdmixtureContract;
374 
375     /**
376     * @dev setting up a new address for a private contract
377     */
378     function setPriv(address _privAddress) public returns(bool) {
379         privAddress = _privAddress;
380         privateContract = PrivateRabbitInterface(_privAddress);
381     } 
382     function setAdmixture(address _addressAdmixture) public returns(bool) {
383         addressAdmixture = _addressAdmixture;
384         AdmixtureContract = AdmixtureInterface(_addressAdmixture);
385     } 
386 
387     bool public fcontr = false;
388  
389     
390     constructor() public { 
391         fcontr = true;
392     }
393 
394     function isPriv() public view returns(bool) {
395         return privateContract.isUIntPrivate();
396     }
397 
398     modifier checkPrivate() {
399         require(isPriv());
400         _;
401     }
402 
403     function ownerOf(uint32 _tokenId) public view returns (address owner) {
404         return rabbitToOwner[_tokenId];
405     }
406 
407     function approve(address _to, uint32 _tokenId) public returns (bool) { 
408         _to;
409         _tokenId;
410         return false;
411     }
412 
413 
414     function removeTokenList(address _owner, uint32 _tokenId) internal { 
415         uint count = ownerBunnies[_owner].length;
416         for (uint256 i = 0; i < count; i++) {
417             if(ownerBunnies[_owner][i] == _tokenId)
418             { 
419                 delete ownerBunnies[_owner][i];
420                 if(count > 0 && count != (i-1)){
421                     ownerBunnies[_owner][i] = ownerBunnies[_owner][(count-1)];
422                     delete ownerBunnies[_owner][(count-1)];
423                 } 
424                 ownerBunnies[_owner].length--;
425                 return;
426             } 
427         }
428     }
429     /**
430     * Get the cost of the reward for pairing
431     * @param _tokenId - rabbit that mates
432      */
433     function getSirePrice(uint32 _tokenId) public view returns(uint) {
434         if(rabbits[(_tokenId-1)].role == 1){
435             uint procent = (rabbitSirePrice[_tokenId] / 100);
436             uint res = procent.mul(25);
437             uint system  = procent.mul(commission_system);
438 
439             res = res.add(rabbitSirePrice[_tokenId]);
440             return res.add(system); 
441         } else {
442             return 0;
443         }
444     }
445 
446     /**
447     * @dev add a new bunny in the storage
448      */
449     function addTokenList(address owner,  uint32 _tokenId) internal {
450         ownerBunnies[owner].push( _tokenId);
451         emit OwnerBunnies(owner, _tokenId);
452         rabbitToOwner[_tokenId] = owner; 
453     }
454  
455 
456     function transfer(address _to, uint32 _tokenId) public {
457         address currentOwner = msg.sender;
458         address oldOwner = rabbitToOwner[_tokenId];
459         require(rabbitToOwner[_tokenId] == msg.sender);
460         require(currentOwner != _to);
461         require(_to != address(0));
462         removeTokenList(oldOwner, _tokenId);
463         addTokenList(_to, _tokenId);
464         emit Transfer(oldOwner, _to, _tokenId);
465     }
466 
467     function transferFrom(address _from, address _to, uint32 _tokenId) public returns(bool) {
468         address oldOwner = rabbitToOwner[_tokenId];
469         require(oldOwner == _from);
470         require(getInWhitelist(msg.sender));
471         require(oldOwner != _to);
472         require(_to != address(0));
473 
474         removeTokenList(oldOwner, _tokenId);
475         addTokenList(_to, _tokenId); 
476         emit Transfer (oldOwner, _to, _tokenId);
477         return true;
478     }  
479      
480 
481     function isPauseSave() public view returns(bool) {
482         return !pauseSave;
483     }
484     
485     function isPromoPause() public view returns(bool) {
486         if (getInWhitelist(msg.sender)) {
487             return true;
488         } else {
489             return !promoPause;
490         } 
491     }
492 
493     function setPauseSave() public onlyWhitelisted()  returns(bool) {
494         return pauseSave = !pauseSave;
495     }
496  
497 
498     function getTokenOwner(address owner) public view returns(uint total, uint32[] list) {
499         total = ownerBunnies[owner].length;
500         list = ownerBunnies[owner];
501     } 
502 
503 
504 
505     function setRabbitMother(uint32 children, uint32 mother) internal { 
506         require(children != mother);
507         uint32[11] memory pullMother;
508         uint start = 0;
509         for (uint i = 0; i < 5; i++) {
510             if (rabbitMother[mother][i] != 0) {
511               pullMother[start] = uint32(rabbitMother[mother][i]);
512               rabbitMother[mother][i] = 0;
513               start++;
514             } 
515         }
516         pullMother[start] = mother;
517         start++;
518         for (uint m = 0; m < 5; m++) {
519              if(start >  5){
520                     rabbitMother[children][m] = pullMother[(m+1)];
521              }else{
522                     rabbitMother[children][m] = pullMother[m];
523              }
524         } 
525         setMotherCount(mother);
526     }
527 
528       
529 
530     function setMotherCount(uint32 _mother) internal returns(uint)  { //internal
531         motherCount[_mother] = motherCount[_mother].add(1);
532         emit EmotherCount(_mother, motherCount[_mother]);
533         return motherCount[_mother];
534     } 
535      
536     function bytes32ToString(bytes32 x) internal pure returns (string) {
537         bytes memory bytesString = new bytes(32);
538         uint charCount = 0;
539         for (uint j = 0; j < 32; j++) {
540             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
541             if (char != 0) {
542                 bytesString[charCount] = char;
543                 charCount++;
544             }
545         }
546         bytes memory bytesStringTrimmed = new bytes(charCount);
547         for (j = 0; j < charCount; j++) {
548             bytesStringTrimmed[j] = bytesString[j];
549         }
550         return string(bytesStringTrimmed);
551     }
552     
553     function uintToBytes(uint v) internal pure returns (bytes32 ret) {
554         if (v == 0) {
555             ret = '0';
556         } else {
557         while (v > 0) {
558                 ret = bytes32(uint(ret) / (2 ** 8));
559                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
560                 v /= 10;
561             }
562         }
563         return ret;
564     }
565 
566     function totalSupply() public view returns (uint total) {
567         return totalBunny;
568     }
569 
570     function balanceOf(address _owner) public view returns (uint) {
571       //  _owner;
572         return ownerBunnies[_owner].length;
573     }
574 
575     function sendMoney(address _to, uint256 _money) internal { 
576         _to.transfer((_money/100)*95);
577         ownerMoney.transfer((_money/100)*5); 
578     }
579 
580     function getGiffBlock(uint32 _bunnyid) public view returns(bool) { 
581         return !giffblock[_bunnyid];
582     }
583 
584     function getOwnerGennezise(address _to) public view returns(bool) { 
585         return ownerGennezise[_to];
586     }
587     
588 
589     function getBunny(uint32 _bunny) public view returns(
590         uint32 mother,
591         uint32 sire,
592         uint birthblock,
593         uint birthCount,
594         uint birthLastTime,
595         uint role, 
596         uint genome,
597         bool interbreed,
598         uint leftTime,
599         uint lastTime,
600         uint price,
601         uint motherSumm
602         )
603         {
604             price = getSirePrice(_bunny);
605             _bunny = _bunny - 1;
606             mother = rabbits[_bunny].mother;
607             sire = rabbits[_bunny].sire;
608             birthblock = rabbits[_bunny].birthblock;
609             birthCount = rabbits[_bunny].birthCount;
610             birthLastTime = rabbits[_bunny].birthLastTime;
611             role = rabbits[_bunny].role;
612             genome = rabbits[_bunny].genome;
613                      
614             if(birthCount > 11) {
615                 birthCount = 11;
616             }
617 
618             motherSumm = motherCount[_bunny];
619 
620             lastTime = uint(cooldowns[birthCount]);
621             lastTime = lastTime.add(birthLastTime);
622             if(lastTime <= now) {
623                 interbreed = true;
624             } else {
625                 leftTime = lastTime.sub(now);
626             }
627     }
628 
629 
630 
631     /**
632     * We update the information on rabbits
633      */
634     function updateBunny(uint32 _bunny, uint types, uint data ) public onlyWhitelisted()
635     { 
636         if (types == 1) {
637             rabbits[(_bunny - 1)].birthCount = data;
638         } else if (types == 2) {
639             rabbits[(_bunny - 1)].genome = data;
640         } else if (types == 3) {
641             rabbitSirePrice[_bunny] = data;
642         } else if (types == 4) {
643             motherCount[_bunny] = data;
644             emit EmotherCount(_bunny, data);
645         } 
646 
647             
648     }
649 
650     /**
651     * @param _bunny A rabbit on which we receive information
652      */
653     function getBreed(uint32 _bunny) public view returns(bool interbreed)
654         {
655       
656         uint birtTime = rabbits[(_bunny - 1)].birthLastTime;
657         uint birthCount = rabbits[(_bunny - 1)].birthCount;
658 
659         uint  lastTime = uint(cooldowns[birthCount]);
660         lastTime = lastTime.add(birtTime);
661 
662         if(lastTime <= now && rabbits[(_bunny - 1)].role == 0 ) {
663             interbreed = true;
664         } 
665     }
666 
667     /**
668      *  we get cooldown
669      */
670     function getcoolduwn(uint32 _mother) public view returns(uint lastTime, uint cd, uint lefttime) {
671         cd = rabbits[(_mother-1)].birthCount;
672         if(cd > 11) {
673             cd = 11;
674         }
675         // time when I can give birth
676         lastTime = (cooldowns[cd] + rabbits[(_mother-1)].birthLastTime);
677         if(lastTime > now) {
678             // I can not give birth, it remains until delivery
679             lefttime = lastTime.sub(now);
680         }
681     }
682 
683 
684 
685      function getMotherCount(uint32 _mother) public view returns(uint) { //internal
686         return  motherCount[_mother];
687     }
688 
689 
690      function getTotalSalaryBunny(uint32 _bunny) public view returns(uint) { //internal
691         return  totalSalaryBunny[_bunny];
692     }
693  
694  
695     function getRabbitMother( uint32 mother) public view returns(uint32[5]) {
696         return rabbitMother[mother];
697     }
698 
699      function getRabbitMotherSumm(uint32 mother) public view returns(uint count) { //internal
700         for (uint m = 0; m < 5 ; m++) {
701             if(rabbitMother[mother][m] != 0 ) { 
702                 count++;
703             }
704         }
705     }
706 
707     function getRabbitDNK(uint32 bunnyid) public view returns(uint) { 
708         return mapDNK[bunnyid];
709     }
710 
711     function isUIntPublic() public view returns(bool) {
712         require(isPauseSave());
713         return true;
714     }
715 
716 }
717 /**
718 * Basic actions for the transfer of rights of rabbits
719 */ 
720  
721 contract BunnyGame is BodyRabbit{    
722   
723     function transferNewBunny(address _to, uint32 _bunnyid, uint localdnk, uint breed, uint32 matron, uint32 sire, uint procentAdmixture, uint admixture) internal {
724         emit NewBunny(_bunnyid, localdnk, block.number, breed, procentAdmixture, admixture);
725         emit CreateChildren(matron, sire, _bunnyid);
726         addTokenList(_to, _bunnyid);
727         totalSalaryBunny[_bunnyid] = 0;
728         motherCount[_bunnyid] = 0;
729         totalBunny++;
730     }
731 
732          
733     /***
734     * @dev create a new gene and put it up for sale, this operation takes place on the server
735     */
736     function createGennezise(uint32 _matron) public {
737          
738         bool promo = false;
739         require(isPriv());
740         require(isPauseSave());
741         require(isPromoPause());
742  
743         if (totalGen0 > promoGen0) { 
744             require(getInWhitelist(msg.sender));
745         } else if (!(getInWhitelist(msg.sender))) {
746             // promo action
747                 require(!ownerGennezise[msg.sender]);
748                 ownerGennezise[msg.sender] = true;
749                 promo = true;
750         }
751         
752         uint  localdnk = privateContract.getNewRabbit(msg.sender);
753         Rabbit memory _Rabbit =  Rabbit( 0, 0, block.number, 0, 0, 0, 0, 0, 0);
754         uint32 _bunnyid =  uint32(rabbits.push(_Rabbit));
755         mapDNK[_bunnyid] = localdnk;
756        
757         transferNewBunny(msg.sender, _bunnyid, localdnk, 0, 0, 0, 4, 0);  
758         
759         lastTimeGen0 = now;
760         lastIdGen0 = _bunnyid; 
761         totalGen0++; 
762 
763         setRabbitMother(_bunnyid, _matron);
764 
765         emit Referral(msg.sender, _matron, _bunnyid, block.timestamp);
766 
767         if (promo) {
768             giffblock[_bunnyid] = true;
769         }
770     }
771 
772     function getGenomeChildren(uint32 _matron, uint32 _sire) internal view returns(uint) {
773         uint genome;
774         if (rabbits[(_matron-1)].genome >= rabbits[(_sire-1)].genome) {
775             genome = rabbits[(_matron-1)].genome;
776         } else {
777             genome = rabbits[(_sire-1)].genome;
778         }
779         return genome.add(1);
780     }
781     
782     /**
783     * create a new rabbit, according to the cooldown
784     * @param _matron - mother who takes into account the cooldown
785     * @param _sire - the father who is rewarded for mating for the fusion of genes
786      */
787     function createChildren(uint32 _matron, uint32 _sire) public  payable returns(uint32) {
788 
789         require(isPriv());
790         require(isPauseSave());
791         require(rabbitToOwner[_matron] == msg.sender);
792         // Checking for the role
793         require(rabbits[(_sire-1)].role == 1);
794         require(_matron != _sire);
795 
796         require(getBreed(_matron));
797         // Checking the money 
798         
799         require(msg.value >= getSirePrice(_sire));
800         
801         uint genome = getGenomeChildren(_matron, _sire);
802 
803         uint localdnk =  privateContract.mixDNK(mapDNK[_matron], mapDNK[_sire], genome);
804 
805 
806         uint procentAdm; 
807         uint admixture;
808         (procentAdm, admixture) = AdmixtureContract.getAdmixture(rabbits[(_sire-1)].procentAdmixture, rabbits[(_matron-1)].procentAdmixture);
809         Rabbit memory rabbit =  Rabbit(_matron, _sire, block.number, 0, 0, 0, genome, procentAdm, admixture);
810 
811         uint32 bunnyid =  uint32(rabbits.push(rabbit));
812         mapDNK[bunnyid] = localdnk;
813 
814         uint _moneyMother = rabbitSirePrice[_sire].div(4);
815 
816         _transferMoneyMother(_matron, _moneyMother);
817 
818         rabbitToOwner[_sire].transfer(rabbitSirePrice[_sire]);
819 
820         uint system = rabbitSirePrice[_sire].div(100);
821         system = system.mul(commission_system);
822         ownerMoney.transfer(system); // refund previous bidder
823   
824         coolduwnUP(_matron);
825         // we transfer the rabbit to the new owner
826         transferNewBunny(rabbitToOwner[_matron], bunnyid, localdnk, genome, _matron, _sire, procentAdm, admixture );   
827         // we establish parents for the child
828         setRabbitMother(bunnyid, _matron);
829         return bunnyid;
830     } 
831   
832     /**
833      *  Set the cooldown for childbirth
834      * @param _mother - mother for which cooldown
835      */
836     function coolduwnUP(uint32 _mother) internal { 
837         require(isPauseSave());
838         rabbits[(_mother-1)].birthCount = rabbits[(_mother-1)].birthCount.add(1);
839         rabbits[(_mother-1)].birthLastTime = now;
840         emit CoolduwnMother(_mother, rabbits[(_mother-1)].birthCount);
841     }
842 
843 
844     /**
845      * @param _mother - matron send money for parrent
846      * @param _valueMoney - current sale
847      */
848     function _transferMoneyMother(uint32 _mother, uint _valueMoney) internal {
849         require(isPauseSave());
850         require(_valueMoney > 0);
851         if (getRabbitMotherSumm(_mother) > 0) {
852             uint pastMoney = _valueMoney/getRabbitMotherSumm(_mother);
853             for (uint i=0; i < getRabbitMotherSumm(_mother); i++) {
854                 if (rabbitMother[_mother][i] != 0) { 
855                     uint32 _parrentMother = rabbitMother[_mother][i];
856                     address add = rabbitToOwner[_parrentMother];
857                     // pay salaries
858                     setMotherCount(_parrentMother);
859                     totalSalaryBunny[_parrentMother] += pastMoney;
860                     emit SalaryBunny(_parrentMother, totalSalaryBunny[_parrentMother]);
861                     add.transfer(pastMoney); // refund previous bidder
862                 }
863             } 
864         }
865     }
866     
867     /**
868     * @dev We set the cost of renting our genes
869     * @param price rent price
870      */
871     function setRabbitSirePrice(uint32 _rabbitid, uint price) public returns(bool) {
872         require(isPauseSave());
873         require(rabbitToOwner[_rabbitid] == msg.sender);
874         require(price > bigPrice);
875 
876         uint lastTime;
877         (lastTime,,) = getcoolduwn(_rabbitid);
878         require(now >= lastTime);
879 
880         if (rabbits[(_rabbitid-1)].role == 1 && rabbitSirePrice[_rabbitid] == price) {
881             return false;
882         }
883 
884         rabbits[(_rabbitid-1)].role = 1;
885         rabbitSirePrice[_rabbitid] = price;
886         uint gen = rabbits[(_rabbitid-1)].genome;
887         sireGenom[gen].push(_rabbitid);
888         emit ChengeSex(_rabbitid, true, getSirePrice(_rabbitid));
889         return true;
890     }
891  
892     /**
893     * @dev We set the cost of renting our genes
894      */
895     function setSireStop(uint32 _rabbitid) public returns(bool) {
896         require(isPauseSave());
897         require(rabbitToOwner[_rabbitid] == msg.sender);
898      //   require(rabbits[(_rabbitid-1)].role == 0);
899         rabbits[(_rabbitid-1)].role = 0;
900         rabbitSirePrice[_rabbitid] = 0;
901         deleteSire(_rabbitid);
902         return true;
903     }
904     
905       function deleteSire(uint32 _tokenId) internal { 
906         uint gen = rabbits[(_tokenId-1)].genome;
907 
908         uint count = sireGenom[gen].length;
909         for (uint i = 0; i < count; i++) {
910             if(sireGenom[gen][i] == _tokenId)
911             { 
912                 delete sireGenom[gen][i];
913                 if(count > 0 && count != (i-1)){
914                     sireGenom[gen][i] = sireGenom[gen][(count-1)];
915                     delete sireGenom[gen][(count-1)];
916                 } 
917                 sireGenom[gen].length--;
918                 emit ChengeSex(_tokenId, false, 0);
919                 return;
920             } 
921         }
922     } 
923 
924     function getMoney(uint _value) public onlyOwner {
925         require(address(this).balance >= _value);
926         ownerMoney.transfer(_value);
927     }
928 
929     /**
930     * @dev give a rabbit to a specific user
931     * @param add new address owner rabbits
932     */
933     function gift(uint32 bunnyid, address add) public {
934         require(rabbitToOwner[bunnyid] == msg.sender);
935         // a rabbit taken for free can not be given
936         require(!(giffblock[bunnyid]));
937         transferFrom(msg.sender, add, bunnyid);
938     }
939 }