1 pragma solidity ^0.4.23;
2 
3 /*
4 ______ _   _ _   _  _   ___   __
5 | ___ \ | | | \ | || \ | \ \ / /
6 | |_/ / | | |  \| ||  \| |\ V / 
7 | ___ \ | | | . ` || . ` | \ /  
8 | |_/ / |_| | |\  || |\  | | |  
9 \____/ \___/\_| \_/\_| \_/ \_/   
10  _____   ___  ___  ___ _____    
11 |  __ \ / _ \ |  \/  ||  ___|   
12 | |  \// /_\ \| .  . || |__     
13 | | __ |  _  || |\/| ||  __|    
14 | |_\ \| | | || |  | || |___    
15  \____/\_| |_/\_|  |_/\____/ 
16 *
17 * Author:  Konstantin G...
18 * Telegram: @bunnygame (en)
19 * talk : https://bitcointalk.org/index.php?topic=5025885.0
20 * discord : https://discordapp.com/invite/G2jt4Fw
21 * email: info@bunnycoin.co
22 * site : http://bunnycoin.co 
23 */
24  
25 contract Ownable {
26     
27     address ownerCEO;
28     address ownerMoney;  
29     address privAddress = 0x23a9C3452F3f8FF71c7729624f4beCEd4A24fa55; 
30     address public addressTokenBunny = 0x2Ed020b084F7a58Ce7AC5d86496dC4ef48413a24;
31     
32     /**
33     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34     * account.
35     */
36     constructor() public { 
37         ownerCEO = msg.sender; 
38         ownerMoney = msg.sender;
39     }
40  
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44     modifier onlyOwner() {
45         require(msg.sender == ownerCEO);
46         _;
47     }
48    
49     function transferOwnership(address add) public onlyOwner {
50         if (add != address(0)) {
51             ownerCEO = add;
52         }
53     }
54  
55     function transferOwnerMoney(address _ownerMoney) public  onlyOwner {
56         if (_ownerMoney != address(0)) {
57             ownerMoney = _ownerMoney;
58         }
59     }
60  
61     function getOwnerMoney() public view onlyOwner returns(address) {
62         return ownerMoney;
63     } 
64     /**
65     *  @dev private contract
66      */
67     function getPrivAddress() public view onlyOwner returns(address) {
68         return privAddress;
69     }
70 
71 } 
72 
73 
74 contract Whitelist is Ownable {
75     mapping(address => bool) public whitelist;
76 
77     mapping(uint  => address)   whitelistCheck;
78     uint public countAddress = 0;
79 
80     event WhitelistedAddressAdded(address addr);
81     event WhitelistedAddressRemoved(address addr);
82  
83     modifier onlyWhitelisted() {
84         require(whitelist[msg.sender]);
85         _;
86     }
87 
88     constructor() public {
89             whitelist[msg.sender] = true;  
90     }
91 
92     function addAddressToWhitelist(address addr) onlyWhitelisted public returns(bool success) {
93         if (!whitelist[addr]) {
94             whitelist[addr] = true;
95 
96             countAddress = countAddress + 1;
97             whitelistCheck[countAddress] = addr;
98 
99             emit WhitelistedAddressAdded(addr);
100             success = true;
101         }
102     }
103 
104     function getWhitelistCheck(uint key) onlyWhitelisted view public returns(address) {
105         return whitelistCheck[key];
106     }
107 
108 
109     function getInWhitelist(address addr) public view returns(bool) {
110         return whitelist[addr];
111     }
112     function getOwnerCEO() public onlyWhitelisted view returns(address) {
113         return ownerCEO;
114     }
115  
116     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
117         for (uint256 i = 0; i < addrs.length; i++) {
118             if (addAddressToWhitelist(addrs[i])) {
119                 success = true;
120             }
121         }
122     }
123     
124     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
125         if (whitelist[addr]) {
126             whitelist[addr] = false;
127             emit WhitelistedAddressRemoved(addr);
128             success = true;
129         }
130     }
131 
132     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
133         for (uint256 i = 0; i < addrs.length; i++) {
134             if (removeAddressFromWhitelist(addrs[i])) {
135                 success = true;
136             }
137         }
138     }
139 }
140 
141 /**
142  * @title SafeMath
143  * @dev Math operations with safety checks that throw on error
144  */
145 library SafeMath {
146 
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         if (a == 0) {
149             return 0;
150         }
151         uint c = a * b;
152         assert(c / a == b);
153         return c;
154     }
155 
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         // assert(b > 0); // Solidity automatically throws when dividing by 0
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160         return c;
161     }
162 
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         assert(b <= a);
165         return a - b;
166     }
167 
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         assert(c >= a);
171         return c;
172     }
173   
174 }
175  contract ERC721 {
176     // Required methods 
177 
178     function ownerOf(uint32 _tokenId) public view returns (address owner);
179     function approve(address _to, uint32 _tokenId) public returns (bool success);
180     function transfer(address _to, uint32 _tokenId) public;
181     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
182     function totalSupply() public view returns (uint total);
183     function balanceOf(address _owner) public view returns (uint balance);
184  }
185 /// @title Interface new rabbits address
186 contract PrivateRabbitInterface {
187     function getNewRabbit(address from)  public view returns (uint);
188     function mixDNK(uint dnkmother, uint dnksire, uint genome)  public view returns (uint);
189     function isUIntPrivate() public pure returns (bool);
190 }
191 
192 contract TokenBunnyInterface { 
193     
194     function isPromoPause() public view returns(bool);
195     function setTokenBunny(uint32 mother, uint32  sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome, address _owner, uint DNK) external returns(uint32);
196     function publicSetTokenBunnyTest(uint32 mother, uint32  sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome, address _owner, uint DNK) public; 
197     function setMotherCount( uint32 _bunny, uint count) external;
198     function setRabbitSirePrice( uint32 _bunny, uint count) external;
199     function setAllowedChangeSex( uint32 _bunny, bool canBunny) public;
200     function setTotalSalaryBunny( uint32 _bunny, uint count) external;
201     function setRabbitMother(uint32 children, uint32[5] _m) external; 
202     function setDNK( uint32 _bunny, uint dnk) external;
203     function setGiffBlock(uint32 _bunny, bool blocked) external;
204     function transferFrom(address _from, address _to, uint32 _tokenId) public returns(bool);
205     function setOwnerGennezise(address _to, bool canYou) external;
206     function setBirthCount(uint32 _bunny, uint birthCount) external;
207     function setBirthblock(uint32 _bunny, uint birthblock) external; 
208     function setBirthLastTime(uint32 _bunny, uint birthLastTime) external;
209     // getters
210     function getOwnerGennezise(address _to) public view returns(bool);
211     function getAllowedChangeSex(uint32 _bunny) public view returns(bool);
212     function getRabbitSirePrice(uint32 _bunny) public view returns(uint);
213     function getTokenOwner(address owner) public view returns(uint total, uint32[] list); 
214     function getMotherCount(uint32 _mother) public view returns(uint);
215     function getTotalSalaryBunny(uint32 _bunny) public view returns(uint);
216     function getRabbitMother( uint32 mother) public view returns(uint32[5]);
217     function getRabbitMotherSumm(uint32 mother) public view returns(uint count);
218     function getDNK(uint32 bunnyid) public view returns(uint);
219     function getSex(uint32 _bunny) public view returns(bool);
220     function isUIntPublic() public view returns(bool);
221     function balanceOf(address _owner) public view returns (uint);
222     function totalSupply() public view returns (uint total); 
223     function ownerOf(uint32 _tokenId) public view returns (address owner);
224     function getBunnyInfo(uint32 _bunny) external view returns( uint32 mother, uint32 sire, uint birthblock, uint birthCount, uint birthLastTime, bool role, uint genome, bool interbreed, uint leftTime, uint lastTime, uint price, uint motherSumm);
225     function getTokenBunny(uint32 _bunny) public view returns(uint32 mother, uint32 sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome);
226     function getGiffBlock(uint32 _bunny) public view returns(bool);
227     function getGenome(uint32 _bunny) public view returns( uint);
228     function getParent(uint32 _bunny) public view returns(uint32 mother, uint32 sire);
229     function getBirthLastTime(uint32 _bunny) public view returns(uint);
230     function getBirthCount(uint32 _bunny) public view returns(uint);
231     function getBirthblock(uint32 _bunny) public view returns(uint);
232         
233 }
234 
235 contract BaseRabbit  is Whitelist, ERC721 {
236     event EmotherCount(uint32 mother, uint summ); 
237     event ChengeSex(uint32 bunnyId, bool sex, uint256 price);
238     event SalaryBunny(uint32 bunnyId, uint cost); 
239     event CoolduwnMother(uint32 bunnyId, uint num);
240     event Referral(address from, uint32 matronID, uint32 childID, uint currentTime);
241     event Approval(address owner, address approved, uint32 tokenId);
242     event OwnerBunnies(address owner, uint32  tokenId);
243     event Transfer(address from, address to, uint32 tokenId);
244     event CreateChildren(uint32 matron, uint32 sire, uint32 child);
245     TokenBunnyInterface TokenBunny;
246     PrivateRabbitInterface privateContract; 
247 
248     /**
249     * @dev setting up a new address for a private contract
250     */
251     function setToken(address _addressTokenBunny ) public returns(bool) {
252         addressTokenBunny = _addressTokenBunny;
253         TokenBunny = TokenBunnyInterface(_addressTokenBunny);
254     } 
255     /**
256     * @dev setting up a new address for a private contract
257     */
258     function setPriv(address _privAddress) public returns(bool) {
259         privAddress = _privAddress;
260         privateContract = PrivateRabbitInterface(_privAddress);
261     } 
262     function isPriv() public view returns(bool) {
263         return privateContract.isUIntPrivate();
264     }
265     modifier checkPrivate() {
266         require(isPriv());
267         _;
268     }
269 
270     using SafeMath for uint256;
271     bool pauseSave = false;
272     uint256 bigPrice = 0.003 ether;
273     uint public commission_system = 5;
274     uint public totalGen0 = 0;
275     uint public promoGen0 = 15000; 
276     bool public promoPause = false;
277 
278     function setPromoGen0(uint _promoGen0) public onlyWhitelisted() {
279         promoGen0 = _promoGen0;
280     }
281     function setPromoPause() public onlyWhitelisted() {
282         promoPause = !promoPause;
283     }
284     function setBigPrice(uint _bigPrice) public onlyWhitelisted() {
285         bigPrice = _bigPrice;
286     }
287     uint32[12] public cooldowns = [
288         uint32(1 minutes),
289         uint32(2 minutes),
290         uint32(4 minutes),
291         uint32(8 minutes),
292         uint32(16 minutes),
293         uint32(32 minutes),
294         uint32(1 hours),
295         uint32(2 hours),
296         uint32(4 hours),
297         uint32(8 hours),
298         uint32(16 hours),
299         uint32(1 days)
300     ];
301     struct Rabbit { 
302         uint32 mother;
303         uint32 sire; 
304         uint birthblock;
305         uint birthCount;
306         uint birthLastTime;
307         uint genome; 
308     }
309 }
310 
311 contract BodyRabbit is BaseRabbit {
312     uint public totalBunny = 0;
313     string public constant name = "CryptoRabbits";
314     string public constant symbol = "CRB";
315 
316     constructor() public { 
317         setPriv(privAddress); 
318         setToken(addressTokenBunny ); 
319     }
320     function ownerOf(uint32 _tokenId) public view returns (address owner) {
321         return TokenBunny.ownerOf(_tokenId);
322     }
323     function balanceOf(address _owner) public view returns (uint balance) {
324         return TokenBunny.balanceOf(_owner);
325     }
326     function transfer(address _to, uint32 _tokenId) public {
327      _to;_tokenId;
328     }
329   function approve(address _to, uint32 _tokenId) public returns (bool success) {
330      _to;_tokenId;
331       return false;
332   }
333   
334  
335     function getSirePrice(uint32 _tokenId) public view returns(uint) {
336         if(TokenBunny.getRabbitSirePrice(_tokenId) != 0){
337             uint procent = (TokenBunny.getRabbitSirePrice(_tokenId) / 100);
338             uint res = procent.mul(25);
339             uint system  = procent.mul(commission_system);
340             res = res.add( TokenBunny.getRabbitSirePrice(_tokenId));
341             return res.add(system); 
342         } else {
343             return 0;
344         }
345 
346     }
347 
348     function transferFrom(address _from, address _to, uint32 _tokenId) public onlyWhitelisted() returns(bool) {
349         if(TokenBunny.transferFrom(_from, _to, _tokenId)){ 
350             emit Transfer(_from, _to, _tokenId);
351             return true;
352         }
353         return false;
354     }  
355 
356     function isPauseSave() public view returns(bool) {
357         return !pauseSave;
358     }
359     
360     function isPromoPause() public view returns(bool) {
361         if (getInWhitelist(msg.sender)) {
362             return true;
363         } else {
364             return !promoPause;
365         } 
366     }
367 
368     function setPauseSave() public onlyWhitelisted()  returns(bool) {
369         return pauseSave = !pauseSave;
370     }
371  
372 
373     function getTokenOwner(address owner) public view returns(uint total, uint32[] list) {
374         (total, list) = TokenBunny.getTokenOwner(owner);
375     } 
376 
377 
378     function setRabbitMother(uint32 children, uint32 mother) internal { 
379         require(children != mother);
380         uint32[11] memory pullMother;
381         uint32[5] memory rabbitMother = TokenBunny.getRabbitMother(mother);
382         uint32[5] memory arrayChildren;
383         uint start = 0;
384         for (uint i = 0; i < 5; i++) {
385             if (rabbitMother[i] != 0) {
386               pullMother[start] = uint32(rabbitMother[i]);
387               start++;
388             } 
389         }
390         pullMother[start] = mother;
391         start++;
392         for (uint m = 0; m < 5; m++) {
393              if(start >  5){
394                     arrayChildren[m] = pullMother[(m+1)];
395              }else{
396                     arrayChildren[m] = pullMother[m];
397              }
398         }
399         TokenBunny.setRabbitMother(children, arrayChildren);
400         uint c = TokenBunny.getMotherCount(mother);
401         TokenBunny.setMotherCount( mother, c.add(1));
402     }
403 
404     // function uintToBytes(uint v) internal pure returns (bytes32 ret) {
405     //     if (v == 0) {
406     //         ret = '0';
407     //     } else {
408     //     while (v > 0) {
409     //             ret = bytes32(uint(ret) / (2 ** 8));
410     //             ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
411     //             v /= 10;
412     //         }
413     //     }
414     //     return ret;
415     // }
416 
417     function sendMoney(address _to, uint256 _money) internal { 
418         _to.transfer((_money/100)*95);
419         ownerMoney.transfer((_money/100)*5); 
420     }
421 
422     function getOwnerGennezise(address _to) public view returns(bool) { 
423         return TokenBunny.getOwnerGennezise(_to);
424     }
425 
426     function totalSupply() public view returns (uint total){ 
427         return TokenBunny.totalSupply();
428     }
429     
430     function getBreed(uint32 _bunny) public view returns(bool interbreed)
431         {
432             uint birtTime = 0;
433             uint birthCount = 0;
434             (, , , birthCount, birtTime, ) = TokenBunny.getTokenBunny(_bunny);
435 
436             uint  lastTime = uint(cooldowns[birthCount]);
437             lastTime = lastTime.add(birtTime);
438  
439             if(lastTime <= now && TokenBunny.getSex(_bunny) == false) {
440                 interbreed = true;
441             }
442     }
443     function getcoolduwn(uint32 _mother) public view returns(uint lastTime, uint cd, uint lefttime) {
444         uint birthLastTime;
445          (, , , cd, birthLastTime, ) = TokenBunny.getTokenBunny(_mother);
446 
447         if(cd > 11) {
448             cd = 11;
449         }
450         lastTime = (cooldowns[cd] + birthLastTime);
451         if(lastTime > now) {
452             // I can not give birth, it remains until delivery
453             lefttime = lastTime.sub(now);
454         }
455     }
456      function getMotherCount(uint32 _mother) public view returns(uint) { //internal
457         return TokenBunny.getMotherCount(_mother);
458     }
459      function getTotalSalaryBunny(uint32 _bunny) public view returns(uint) { //internal
460         return TokenBunny.getTotalSalaryBunny(_bunny);
461     }
462     function getRabbitMother( uint32 mother) public view returns(uint32[5]) {
463         return TokenBunny.getRabbitMother(mother);
464     }
465      function getRabbitMotherSumm(uint32 mother) public view returns(uint count) { //internal
466         uint32[5] memory rabbitMother = TokenBunny.getRabbitMother(mother);
467         for (uint m = 0; m < 5 ; m++) {
468             if(rabbitMother[m] != 0 ) { 
469                 count++;
470             }
471         }
472     }
473     function getRabbitDNK(uint32 bunnyid) public view returns(uint) { 
474         return TokenBunny.getDNK(bunnyid);
475     }
476     function isUIntPublic() public view returns(bool) {
477         require(isPauseSave());
478         return true;
479     }
480 }
481 contract BunnyGame is BodyRabbit { 
482 
483     function createGennezise(uint32 _matron) public {
484         bool promo = false;
485         require(isPriv());
486         require(isPauseSave());
487         require(isPromoPause());
488         if (totalGen0 > promoGen0) { 
489             require(getInWhitelist(msg.sender));
490         } else if (!(getInWhitelist(msg.sender))) {
491             // promo action
492                 require(!TokenBunny.getOwnerGennezise(msg.sender));
493                 TokenBunny.setOwnerGennezise(msg.sender, true);
494                 promo = true;
495         }
496         uint  localdnk = privateContract.getNewRabbit(msg.sender);
497         uint32 _bunnyid = TokenBunny.setTokenBunny(0, 0, block.number, 0, 0, 0, msg.sender, localdnk);
498         
499         totalGen0++; 
500         setRabbitMother(_bunnyid, _matron);
501 
502         if(_matron != 0){  
503             emit Referral(msg.sender, _matron, _bunnyid, block.timestamp);
504         }
505         
506         if (promo) { 
507             TokenBunny.setGiffBlock(_bunnyid, true);
508         }
509         emit Transfer(this, msg.sender, _bunnyid);
510     }
511     function getGenomeChildren(uint32 _matron, uint32 _sire) internal view returns(uint) {
512         uint genome;
513         if (TokenBunny.getGenome(_matron) >= TokenBunny.getGenome(_sire)) {
514             genome = TokenBunny.getGenome(_matron);
515         } else {
516             genome = TokenBunny.getGenome(_sire);
517         }
518         return genome.add(1);
519     }
520     function createChildren(uint32 _matron, uint32 _sire) public  payable returns(uint32) {
521 
522         require(isPriv());
523         require(isPauseSave());
524         require(TokenBunny.ownerOf(_matron) == msg.sender);
525         require(TokenBunny.getSex(_sire) == true);
526         require(_matron != _sire);
527         require(getBreed(_matron));
528         require(msg.value >= getSirePrice(_sire));
529         uint genome = getGenomeChildren(_matron, _sire);
530         uint localdnk =  privateContract.mixDNK(TokenBunny.getDNK(_matron), TokenBunny.getDNK(_sire), genome);
531  
532         uint32 bunnyid = TokenBunny.setTokenBunny(_matron, _sire, block.number, 0, 0, genome, msg.sender, localdnk);
533         uint _moneyMother = TokenBunny.getRabbitSirePrice(_sire).div(4);
534         _transferMoneyMother(_matron, _moneyMother);
535 
536         TokenBunny.ownerOf(_sire).transfer( TokenBunny.getRabbitSirePrice(_sire) );
537  
538         uint system = TokenBunny.getRabbitSirePrice(_sire).div(100);
539 
540         system = system.mul(commission_system);
541         ownerMoney.transfer(system);
542         coolduwnUP(_matron); 
543         setRabbitMother(bunnyid, _matron);
544         emit Transfer(this, msg.sender, bunnyid);
545         return bunnyid;
546     } 
547     function coolduwnUP(uint32 _mother) internal { 
548         require(isPauseSave());
549         uint coolduwn = TokenBunny.getBirthCount(_mother).add(1);
550         TokenBunny.setBirthCount(_mother, coolduwn);
551         TokenBunny.setBirthLastTime(_mother, now);
552         emit CoolduwnMother(_mother, TokenBunny.getBirthCount(_mother));
553     }
554     function _transferMoneyMother(uint32 _mother, uint _valueMoney) internal {
555         require(isPauseSave());
556         require(_valueMoney > 0);
557         if (getRabbitMotherSumm(_mother) > 0) {
558             uint pastMoney = _valueMoney/getRabbitMotherSumm(_mother);
559             
560             for (uint i=0; i < getRabbitMotherSumm(_mother); i++) {
561 
562                 if ( TokenBunny.getRabbitMother(_mother)[i] != 0) { 
563                     uint32 _parrentMother = TokenBunny.getRabbitMother(_mother)[i];
564                     address add = TokenBunny.ownerOf(_parrentMother);
565                     TokenBunny.setMotherCount(_parrentMother, TokenBunny.getMotherCount(_parrentMother).add(1));
566                     TokenBunny.setTotalSalaryBunny( _parrentMother, TokenBunny.getTotalSalaryBunny(_parrentMother).add(pastMoney));
567                     emit SalaryBunny(_parrentMother, TokenBunny.getTotalSalaryBunny(_parrentMother));
568                     add.transfer(pastMoney); // refund previous bidder
569                 }
570             } 
571         }
572     }
573     /*
574     function setRabbitSirePrice(uint32 _rabbitid, uint price) public {
575         require(isPauseSave());
576         require(TokenBunny.ownerOf(_rabbitid) == msg.sender);
577         require(price > bigPrice);
578         require(TokenBunny.getAllowedChangeSex(_rabbitid));
579         require(TokenBunny.getRabbitSirePrice(_rabbitid) != price);
580         uint lastTime;
581         (lastTime,,) = getcoolduwn(_rabbitid);
582         require(now >= lastTime);
583         TokenBunny.setRabbitSirePrice(_rabbitid, price);
584         emit ChengeSex(_rabbitid, true, getSirePrice(_rabbitid));
585 
586     }
587     function setSireStop(uint32 _rabbitid) public returns(bool) {
588         require(isPauseSave());
589         require(TokenBunny.getRabbitSirePrice(_rabbitid) !=0);
590 
591         require(TokenBunny.ownerOf(_rabbitid) == msg.sender);
592      //   require(rabbits[(_rabbitid-1)].role == 0);
593         TokenBunny.setRabbitSirePrice( _rabbitid, 0);
594      //   deleteSire(_rabbitid);
595         emit ChengeSex(_rabbitid, false, 0);
596         return true;
597     }*/
598     function getMoney(uint _value) public onlyOwner {
599         require(address(this).balance >= _value);
600         ownerMoney.transfer(_value);
601     }
602 }