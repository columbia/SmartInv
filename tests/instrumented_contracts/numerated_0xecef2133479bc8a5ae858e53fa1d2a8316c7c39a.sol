1 pragma solidity ^0.4.23;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9     
10     address ownerCEO;
11     address ownerMoney;  
12     address privAddress = 0x23a9C3452F3f8FF71c7729624f4beCEd4A24fa55; 
13     address public addressTokenBunny = 0x2Ed020b084F7a58Ce7AC5d86496dC4ef48413a24;
14     
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     constructor() public { 
20         ownerCEO = msg.sender; 
21         ownerMoney = msg.sender;
22     }
23  
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27     modifier onlyOwner() {
28         require(msg.sender == ownerCEO);
29         _;
30     }
31    
32     function transferOwnership(address add) public onlyOwner {
33         if (add != address(0)) {
34             ownerCEO = add;
35         }
36     }
37  
38     function transferOwnerMoney(address _ownerMoney) public  onlyOwner {
39         if (_ownerMoney != address(0)) {
40             ownerMoney = _ownerMoney;
41         }
42     }
43  
44     function getOwnerMoney() public view onlyOwner returns(address) {
45         return ownerMoney;
46     } 
47     /**
48     *  @dev private contract
49      */
50     function getPrivAddress() public view onlyOwner returns(address) {
51         return privAddress;
52     }
53 
54 } 
55 
56 
57 contract Whitelist is Ownable {
58     mapping(address => bool) public whitelist;
59 
60     mapping(uint  => address)   whitelistCheck;
61     uint public countAddress = 0;
62 
63     event WhitelistedAddressAdded(address addr);
64     event WhitelistedAddressRemoved(address addr);
65  
66     modifier onlyWhitelisted() {
67         require(whitelist[msg.sender]);
68         _;
69     }
70 
71     constructor() public {
72             whitelist[msg.sender] = true;  
73     }
74 
75     function addAddressToWhitelist(address addr) onlyWhitelisted public returns(bool success) {
76         if (!whitelist[addr]) {
77             whitelist[addr] = true;
78 
79             countAddress = countAddress + 1;
80             whitelistCheck[countAddress] = addr;
81 
82             emit WhitelistedAddressAdded(addr);
83             success = true;
84         }
85     }
86 
87     function getWhitelistCheck(uint key) onlyWhitelisted view public returns(address) {
88         return whitelistCheck[key];
89     }
90 
91 
92     function getInWhitelist(address addr) public view returns(bool) {
93         return whitelist[addr];
94     }
95     function getOwnerCEO() public onlyWhitelisted view returns(address) {
96         return ownerCEO;
97     }
98  
99     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
100         for (uint256 i = 0; i < addrs.length; i++) {
101             if (addAddressToWhitelist(addrs[i])) {
102                 success = true;
103             }
104         }
105     }
106     
107     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
108         if (whitelist[addr]) {
109             whitelist[addr] = false;
110             emit WhitelistedAddressRemoved(addr);
111             success = true;
112         }
113     }
114 
115     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
116         for (uint256 i = 0; i < addrs.length; i++) {
117             if (removeAddressFromWhitelist(addrs[i])) {
118                 success = true;
119             }
120         }
121     }
122 }
123 
124 
125 /**
126  * @title SafeMath
127  * @dev Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130 
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         if (a == 0) {
133             return 0;
134         }
135         uint c = a * b;
136         assert(c / a == b);
137         return c;
138     }
139 
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         // assert(b > 0); // Solidity automatically throws when dividing by 0
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144         return c;
145     }
146 
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         assert(b <= a);
149         return a - b;
150     }
151 
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         assert(c >= a);
155         return c;
156     }
157   
158 }
159  
160 /// @title Interface new rabbits address
161 contract PrivateRabbitInterface {
162     function getNewRabbit(address from)  public view returns (uint);
163     function mixDNK(uint dnkmother, uint dnksire, uint genome)  public view returns (uint);
164     function isUIntPrivate() public pure returns (bool);
165 }
166 
167 contract TokenBunnyInterface { 
168     
169     function isPromoPause() public view returns(bool);
170     function setTokenBunny(uint32 mother, uint32  sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome, address _owner, uint DNK) external returns(uint32);
171     function publicSetTokenBunnyTest(uint32 mother, uint32  sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome, address _owner, uint DNK) public; 
172     function setMotherCount( uint32 _bunny, uint count) external;
173     function setRabbitSirePrice( uint32 _bunny, uint count) external;
174     function setAllowedChangeSex( uint32 _bunny, bool canBunny) public;
175     function setTotalSalaryBunny( uint32 _bunny, uint count) external;
176     function setRabbitMother(uint32 children, uint32[5] _m) external; 
177     function setDNK( uint32 _bunny, uint dnk) external;
178     function setGiffBlock(uint32 _bunny, bool blocked) external;
179     function transferFrom(address _from, address _to, uint32 _tokenId) public returns(bool);
180     function setOwnerGennezise(address _to, bool canYou) external;
181     function setBirthCount(uint32 _bunny, uint birthCount) external;
182     function setBirthblock(uint32 _bunny, uint birthblock) external; 
183     function setBirthLastTime(uint32 _bunny, uint birthLastTime) external;
184     ////// getters
185  
186     function getOwnerGennezise(address _to) public view returns(bool);
187     function getAllowedChangeSex(uint32 _bunny) public view returns(bool);
188     function getRabbitSirePrice(uint32 _bunny) public view returns(uint);
189     function getTokenOwner(address owner) public view returns(uint total, uint32[] list); 
190     function getMotherCount(uint32 _mother) public view returns(uint);
191     function getTotalSalaryBunny(uint32 _bunny) public view returns(uint);
192     function getRabbitMother( uint32 mother) public view returns(uint32[5]);
193     function getRabbitMotherSumm(uint32 mother) public view returns(uint count);
194     function getDNK(uint32 bunnyid) public view returns(uint);
195     function getSex(uint32 _bunny) public view returns(bool);
196     function isUIntPublic() public view returns(bool);
197     function balanceOf(address _owner) public view returns (uint);
198     function totalSupply() public view returns (uint total); 
199     function ownerOf(uint32 _tokenId) public view returns (address owner);
200     function getBunnyInfo(uint32 _bunny) external view returns( uint32 mother, uint32 sire, uint birthblock, uint birthCount, uint birthLastTime, bool role, uint genome, bool interbreed, uint leftTime, uint lastTime, uint price, uint motherSumm);
201     function getTokenBunny(uint32 _bunny) public view returns(uint32 mother, uint32 sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome);
202     function getGiffBlock(uint32 _bunny) public view returns(bool);
203 
204     function getGenome(uint32 _bunny) public view returns( uint);
205     function getParent(uint32 _bunny) public view returns(uint32 mother, uint32 sire);
206     function getBirthLastTime(uint32 _bunny) public view returns(uint);
207     function getBirthCount(uint32 _bunny) public view returns(uint);
208     function getBirthblock(uint32 _bunny) public view returns(uint);
209         
210 }
211 
212 contract BaseRabbit  is Whitelist {
213     event EmotherCount(uint32 mother, uint summ); 
214     event ChengeSex(uint32 bunnyId, bool sex, uint256 price);
215     event SalaryBunny(uint32 bunnyId, uint cost); 
216     event BunnyDescription(uint32 bunnyId, string name);
217     event CoolduwnMother(uint32 bunnyId, uint num);
218     event Referral(address from, uint32 matronID, uint32 childID, uint currentTime);
219     event Approval(address owner, address approved, uint32 tokenId);
220     event OwnerBunnies(address owner, uint32  tokenId);
221     event Transfer(address from, address to, uint32 tokenId);
222 
223  
224     TokenBunnyInterface TokenBunny;
225     PrivateRabbitInterface privateContract; 
226 
227     /**
228     * @dev setting up a new address for a private contract
229     */
230     function setToken(address _addressTokenBunny ) public returns(bool) {
231         addressTokenBunny = _addressTokenBunny;
232         TokenBunny = TokenBunnyInterface(_addressTokenBunny);
233     } 
234     /**
235     * @dev setting up a new address for a private contract
236     */
237     function setPriv(address _privAddress) public returns(bool) {
238         privAddress = _privAddress;
239         privateContract = PrivateRabbitInterface(_privAddress);
240     } 
241     function isPriv() public view returns(bool) {
242         return privateContract.isUIntPrivate();
243     }
244 
245     modifier checkPrivate() {
246         require(isPriv());
247         _;
248     }
249 
250 
251     using SafeMath for uint256;
252     bool pauseSave = false;
253     uint256 bigPrice = 0.005 ether;
254     uint public commission_system = 5;
255      
256     // ID the last seal
257     
258     uint public totalGen0 = 0;
259     
260     // ID the last seal
261   //  uint public timeRangeCreateGen0 = 1800; 
262 
263     uint public promoGen0 = 15000; 
264     bool public promoPause = false;
265 
266 
267     function setPromoGen0(uint _promoGen0) public onlyWhitelisted() {
268         promoGen0 = _promoGen0;
269     }
270 
271     function setPromoPause() public onlyWhitelisted() {
272         promoPause = !promoPause;
273     }
274 
275     function setBigPrice(uint _bigPrice) public onlyWhitelisted() {
276         bigPrice = _bigPrice;
277     }
278      
279     uint32[12] public cooldowns = [
280         uint32(1 minutes),
281         uint32(2 minutes),
282         uint32(4 minutes),
283         uint32(8 minutes),
284         uint32(16 minutes),
285         uint32(32 minutes),
286         uint32(1 hours),
287         uint32(2 hours),
288         uint32(4 hours),
289         uint32(8 hours),
290         uint32(16 hours),
291         uint32(1 days)
292     ];
293 
294     struct Rabbit { 
295          // parents
296         uint32 mother;
297         uint32 sire; 
298         // block in which a rabbit was born
299         uint birthblock;
300          // number of births or how many times were offspring
301         uint birthCount;
302          // The time when Rabbit last gave birth
303         uint birthLastTime;
304         //indexGenome   
305         uint genome; 
306     }
307 }
308 
309 contract BodyRabbit is BaseRabbit {
310     uint public totalBunny = 0;
311     string public constant name = "CryptoRabbits";
312     string public constant symbol = "CRB";
313 
314 
315     constructor() public { 
316         setPriv(privAddress); 
317         setToken(addressTokenBunny ); 
318      //   fcontr = true;
319     }
320  
321     function ownerOf(uint32 _tokenId) public view returns (address owner) {
322         return TokenBunny.ownerOf(_tokenId);
323     }
324 
325 
326  
327  
328     function getSirePrice(uint32 _tokenId) public view returns(uint) {
329         if(TokenBunny.getRabbitSirePrice(_tokenId) != 0){
330             uint procent = (TokenBunny.getRabbitSirePrice(_tokenId) / 100);
331             uint res = procent.mul(25);
332             uint system  = procent.mul(commission_system);
333 
334             res = res.add( TokenBunny.getRabbitSirePrice(_tokenId));
335             return res.add(system); 
336         } else {
337             return 0;
338         }
339 
340     }
341 
342 
343     function transferFrom(address _from, address _to, uint32 _tokenId) public onlyWhitelisted() returns(bool) {
344         if(TokenBunny.transferFrom(_from, _to, _tokenId)){ 
345             emit Transfer(_from, _to, _tokenId);
346             return true;
347         }
348     }  
349      
350 
351     function isPauseSave() public view returns(bool) {
352         return !pauseSave;
353     }
354     
355     function isPromoPause() public view returns(bool) {
356         if (getInWhitelist(msg.sender)) {
357             return true;
358         } else {
359             return !promoPause;
360         } 
361     }
362 
363     function setPauseSave() public onlyWhitelisted()  returns(bool) {
364         return pauseSave = !pauseSave;
365     }
366  
367 
368     function getTokenOwner(address owner) public view returns(uint total, uint32[] list) {
369         (total, list) = TokenBunny.getTokenOwner(owner);
370     } 
371 
372 
373     function setRabbitMother(uint32 children, uint32 mother) internal { 
374         require(children != mother);
375         uint32[11] memory pullMother;
376         uint32[5] memory rabbitMother = TokenBunny.getRabbitMother(mother);
377         uint32[5] memory arrayChildren;
378 
379         uint start = 0;
380         for (uint i = 0; i < 5; i++) {
381 
382             if (rabbitMother[i] != 0) {
383               pullMother[start] = uint32(rabbitMother[i]);
384               start++;
385             } 
386         }
387         pullMother[start] = mother;
388         start++;
389         for (uint m = 0; m < 5; m++) {
390              if(start >  5){
391                     arrayChildren[m] = pullMother[(m+1)];
392              }else{
393                     arrayChildren[m] = pullMother[m];
394              }
395         }
396         TokenBunny.setRabbitMother(children, arrayChildren);
397         uint c = TokenBunny.getMotherCount(mother);
398         TokenBunny.setMotherCount( mother, c.add(1));
399     }
400 
401       
402 
403   //  function setMotherCount(uint32 _mother) internal { //internal
404    // //    uint c = TokenBunny.getMotherCount(_mother);
405 //TokenBunny.setMotherCount(_mother, c.add(1));
406    //     emit EmotherCount(_mother, c.add(1));
407    // } 
408      
409 
410 
411     
412     function uintToBytes(uint v) internal pure returns (bytes32 ret) {
413         if (v == 0) {
414             ret = '0';
415         } else {
416         while (v > 0) {
417                 ret = bytes32(uint(ret) / (2 ** 8));
418                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
419                 v /= 10;
420             }
421         }
422         return ret;
423     }
424 
425 
426 
427     function sendMoney(address _to, uint256 _money) internal { 
428         _to.transfer((_money/100)*95);
429         ownerMoney.transfer((_money/100)*5); 
430     }
431 
432    
433 
434     function getOwnerGennezise(address _to) public view returns(bool) { 
435         return TokenBunny.getOwnerGennezise(_to);
436     }
437     
438 
439 
440 
441 
442     /**
443     * @param _bunny A rabbit on which we receive information
444      */
445     function getBreed(uint32 _bunny) public view returns(bool interbreed)
446         {
447             uint birtTime = 0;
448             uint birthCount = 0;
449             (, , , birthCount, birtTime, ) = TokenBunny.getTokenBunny(_bunny);
450 
451             uint  lastTime = uint(cooldowns[birthCount]);
452             lastTime = lastTime.add(birtTime);
453  
454             if(lastTime <= now && TokenBunny.getSex(_bunny) == false) {
455                 interbreed = true;
456             }
457     }
458 
459     /**
460      *  we get cooldown
461      */
462     function getcoolduwn(uint32 _mother) public view returns(uint lastTime, uint cd, uint lefttime) {
463         uint birthLastTime;
464          (, , , cd, birthLastTime, ) = TokenBunny.getTokenBunny(_mother);
465 
466         if(cd > 11) {
467             cd = 11;
468         }
469         // time when I can give birth 
470         lastTime = (cooldowns[cd] + birthLastTime);
471         if(lastTime > now) {
472             // I can not give birth, it remains until delivery
473             lefttime = lastTime.sub(now);
474         }
475     }
476 
477 
478 
479      function getMotherCount(uint32 _mother) public view returns(uint) { //internal
480         return TokenBunny.getMotherCount(_mother);
481     }
482 
483 
484      function getTotalSalaryBunny(uint32 _bunny) public view returns(uint) { //internal
485         return TokenBunny.getTotalSalaryBunny(_bunny);
486     }
487  
488  
489     function getRabbitMother( uint32 mother) public view returns(uint32[5]) {
490         return TokenBunny.getRabbitMother(mother);
491     }
492 
493      function getRabbitMotherSumm(uint32 mother) public view returns(uint count) { //internal
494         uint32[5] memory rabbitMother = TokenBunny.getRabbitMother(mother);
495         for (uint m = 0; m < 5 ; m++) {
496             if(rabbitMother[m] != 0 ) { 
497                 count++;
498             }
499         }
500     }
501 
502     function getRabbitDNK(uint32 bunnyid) public view returns(uint) { 
503         return TokenBunny.getDNK(bunnyid);
504     }
505 
506     function isUIntPublic() public view returns(bool) {
507         require(isPauseSave());
508         return true;
509     }
510 
511 }
512 /**
513 * Basic actions for the transfer of rights of rabbits
514 */ 
515  
516 contract BunnyGame is BodyRabbit {    
517   
518     event CreateChildren(uint32 matron, uint32 sire, uint32 child);
519 
520     /***
521     * @dev create a new gene and put it up for sale, this operation takes place on the server
522     */
523     function createGennezise(uint32 _matron) public {
524         bool promo = false;
525         require(isPriv());
526         require(isPauseSave());
527         require(isPromoPause());
528         if (totalGen0 > promoGen0) { 
529             require(getInWhitelist(msg.sender));
530         } else if (!(getInWhitelist(msg.sender))) {
531             // promo action
532                 require(!TokenBunny.getOwnerGennezise(msg.sender));
533                 TokenBunny.setOwnerGennezise(msg.sender, true);
534                 promo = true;
535         }
536         uint  localdnk = privateContract.getNewRabbit(msg.sender);
537         uint32 _bunnyid = TokenBunny.setTokenBunny(0, 0, block.number, 0, 0, 0, msg.sender, localdnk);
538         
539         totalGen0++; 
540         setRabbitMother(_bunnyid, _matron);
541 
542         if(_matron != 0){  
543             emit Referral(msg.sender, _matron, _bunnyid, block.timestamp);
544         }
545 
546         if (promo) { 
547             TokenBunny.setGiffBlock(_bunnyid, true);
548         }
549     }
550 
551  
552 
553 
554 
555     function getGenomeChildren(uint32 _matron, uint32 _sire) internal view returns(uint) {
556         uint genome;
557         if (TokenBunny.getGenome(_matron) >= TokenBunny.getGenome(_sire)) {
558             genome = TokenBunny.getGenome(_matron);
559         } else {
560             genome = TokenBunny.getGenome(_sire);
561         }
562         return genome.add(1);
563     }
564        
565 
566 
567     /**
568     * create a new rabbit, according to the cooldown
569     * @param _matron - mother who takes into account the cooldown
570     * @param _sire - the father who is rewarded for mating for the fusion of genes
571      */
572     function createChildren(uint32 _matron, uint32 _sire) public  payable returns(uint32) {
573 
574         require(isPriv());
575         require(isPauseSave());
576         require(TokenBunny.ownerOf(_matron) == msg.sender);
577         // Checking for the role
578         require(TokenBunny.getSex(_sire) == true);
579         require(_matron != _sire);
580 
581         require(getBreed(_matron));
582         // Checking the money 
583         
584         require(msg.value >= getSirePrice(_sire));
585         
586         uint genome = getGenomeChildren(_matron, _sire);
587 
588         uint localdnk =  privateContract.mixDNK(TokenBunny.getDNK(_matron), TokenBunny.getDNK(_sire), genome);
589  
590         uint32 bunnyid = TokenBunny.setTokenBunny(_matron, _sire, block.number, 0, 0, genome, msg.sender, localdnk);
591         uint _moneyMother = TokenBunny.getRabbitSirePrice(_sire).div(4);
592         _transferMoneyMother(_matron, _moneyMother);
593 
594         TokenBunny.ownerOf(_sire).transfer( TokenBunny.getRabbitSirePrice(_sire) );
595  
596         uint system = TokenBunny.getRabbitSirePrice(_sire).div(100);
597 
598         system = system.mul(commission_system);
599         ownerMoney.transfer(system); // refund previous bidder
600   
601         coolduwnUP(_matron); 
602         setRabbitMother(bunnyid, _matron);
603         return bunnyid;
604     } 
605   
606     /**
607      *  Set the cooldown for childbirth
608      * @param _mother - mother for which cooldown
609      */
610     function coolduwnUP(uint32 _mother) internal { 
611         require(isPauseSave());
612         uint coolduwn = TokenBunny.getBirthCount(_mother).add(1);
613         TokenBunny.setBirthCount(_mother, coolduwn);
614         TokenBunny.setBirthLastTime(_mother, now);
615         emit CoolduwnMother(_mother, TokenBunny.getBirthCount(_mother));
616     }
617 
618 
619     /**
620      * @param _mother - matron send money for parrent
621      * @param _valueMoney - current sale
622      */
623     function _transferMoneyMother(uint32 _mother, uint _valueMoney) internal {
624         require(isPauseSave());
625         require(_valueMoney > 0);
626         if (getRabbitMotherSumm(_mother) > 0) {
627             uint pastMoney = _valueMoney/getRabbitMotherSumm(_mother);
628             
629             for (uint i=0; i < getRabbitMotherSumm(_mother); i++) {
630 
631                 if ( TokenBunny.getRabbitMother(_mother)[i] != 0) { 
632                     uint32 _parrentMother = TokenBunny.getRabbitMother(_mother)[i];
633                     address add = TokenBunny.ownerOf(_parrentMother);
634                     // pay salaries 
635 
636                     TokenBunny.setMotherCount(_parrentMother, TokenBunny.getMotherCount(_parrentMother).add(1));
637                     TokenBunny.setTotalSalaryBunny( _parrentMother, TokenBunny.getTotalSalaryBunny(_parrentMother).add(pastMoney));
638                     emit SalaryBunny(_parrentMother, TokenBunny.getTotalSalaryBunny(_parrentMother));
639                     add.transfer(pastMoney); // refund previous bidder
640                 }
641             } 
642         }
643     }
644     
645     /**
646     * @dev We set the cost of renting our genes
647     * @param price rent price
648      */
649     function setRabbitSirePrice(uint32 _rabbitid, uint price) public {
650         require(isPauseSave());
651         require(TokenBunny.ownerOf(_rabbitid) == msg.sender);
652         require(price > bigPrice);
653  
654         require(TokenBunny.getAllowedChangeSex(_rabbitid));
655         require(TokenBunny.getRabbitSirePrice(_rabbitid) != price);
656 
657         uint lastTime;
658         (lastTime,,) = getcoolduwn(_rabbitid);
659         require(now >= lastTime);
660 
661         TokenBunny.setRabbitSirePrice(_rabbitid, price);
662         
663       //  uint gen = rabbits[(_rabbitid-1)].genome;
664        // sireGenom[gen].push(_rabbitid);
665         emit ChengeSex(_rabbitid, true, getSirePrice(_rabbitid));
666 
667     }
668  
669     /**
670     * @dev We set the cost of renting our genes
671      */
672     function setSireStop(uint32 _rabbitid) public returns(bool) {
673         require(isPauseSave());
674         require(TokenBunny.getRabbitSirePrice(_rabbitid) !=0);
675 
676         require(TokenBunny.ownerOf(_rabbitid) == msg.sender);
677      //   require(rabbits[(_rabbitid-1)].role == 0);
678         TokenBunny.setRabbitSirePrice( _rabbitid, 0);
679      //   deleteSire(_rabbitid);
680         emit ChengeSex(_rabbitid, false, 0);
681         return true;
682     }
683     
684  
685 
686     function getMoney(uint _value) public onlyOwner {
687         require(address(this).balance >= _value);
688         ownerMoney.transfer(_value);
689     }
690 
691 }