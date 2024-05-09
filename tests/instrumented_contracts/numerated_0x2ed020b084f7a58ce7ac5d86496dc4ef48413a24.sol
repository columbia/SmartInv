1 pragma solidity ^0.4.23;
2 
3 /*
4 * Author:  Konstantin G...
5 * Telegram: @bunnygame (en)
6 * talk : https://bitcointalk.org/index.php?topic=5025885.0
7 * discord : https://discordapp.com/invite/G2jt4Fw
8 * email: info@bunnycoin.co
9 * site : http://bunnycoin.co 
10 */
11 
12 /**
13 * @title Ownable
14 * @dev The Ownable contract has an owner address, and provides basic authorization control
15 * functions, this simplifies the implementation of "user permissions".
16 */
17 contract Ownable {
18     
19     address ownerCEO;
20     address ownerMoney;  
21     address privAddress; 
22     address addressAdmixture;
23     
24     /**
25     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26     * account.
27     */
28     constructor() public { 
29         ownerCEO = msg.sender; 
30         ownerMoney = msg.sender;
31     }
32  
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36     modifier onlyOwner() {
37         require(msg.sender == ownerCEO);
38         _;
39     }
40    
41     function transferOwnership(address add) public onlyOwner {
42         if (add != address(0)) {
43             ownerCEO = add;
44         }
45     }
46  
47     function transferOwnerMoney(address _ownerMoney) public  onlyOwner {
48         if (_ownerMoney != address(0)) {
49             ownerMoney = _ownerMoney;
50         }
51     }
52  
53     function getOwnerMoney() public view onlyOwner returns(address) {
54         return ownerMoney;
55     } 
56     /**
57     *  @dev private contract
58      */
59     function getPrivAddress() public view onlyOwner returns(address) {
60         return privAddress;
61     }
62     function getAddressAdmixture() public view onlyOwner returns(address) {
63         return addressAdmixture;
64     }
65 } 
66 
67 
68 /**
69  * @title Whitelist
70  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
71  * @dev This simplifies the implementation of "user permissions".
72  */
73 contract Whitelist is Ownable {
74     mapping(address => bool) public whitelist;
75 
76     mapping(uint  => address)   whitelistCheck;
77     uint public countAddress = 0;
78 
79     event WhitelistedAddressAdded(address addr);
80     event WhitelistedAddressRemoved(address addr);
81  
82   /**
83    * @dev Throws if called by any account that's not whitelisted.
84    */
85     modifier onlyWhitelisted() {
86         require(whitelist[msg.sender]);
87         _;
88     }
89 
90     constructor() public {
91             whitelist[msg.sender] = true;  
92             whitelist[this] = true;  
93     }
94 
95   /**
96    * @dev add an address to the whitelist
97    * @param addr address
98    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
99    */
100     function addAddressToWhitelist(address addr) onlyWhitelisted public returns(bool success) {
101         if (!whitelist[addr]) {
102             whitelist[addr] = true;
103 
104             countAddress = countAddress + 1;
105             whitelistCheck[countAddress] = addr;
106 
107             emit WhitelistedAddressAdded(addr);
108             success = true;
109         }
110     }
111 
112     function getWhitelistCheck(uint key) onlyWhitelisted view public returns(address) {
113         return whitelistCheck[key];
114     }
115 
116 
117     function getInWhitelist(address addr) public view returns(bool) {
118         return whitelist[addr];
119     }
120     function getOwnerCEO() public onlyWhitelisted view returns(address) {
121         return ownerCEO;
122     }
123  
124     /**
125     * @dev add addresses to the whitelist
126     * @param addrs addresses
127     * @return true if at least one address was added to the whitelist,
128     * false if all addresses were already in the whitelist
129     */
130     function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
131         for (uint256 i = 0; i < addrs.length; i++) {
132             if (addAddressToWhitelist(addrs[i])) {
133                 success = true;
134             }
135         }
136     }
137 
138     /**
139     * @dev remove an address from the whitelist
140     * @param addr address
141     * @return true if the address was removed from the whitelist,
142     * false if the address wasn't in the whitelist in the first place
143     */
144     function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
145         if (whitelist[addr]) {
146             whitelist[addr] = false;
147             emit WhitelistedAddressRemoved(addr);
148             success = true;
149         }
150     }
151 
152     /**
153     * @dev remove addresses from the whitelist
154     * @param addrs addresses
155     * @return true if at least one address was removed from the whitelist,
156     * false if all addresses weren't in the whitelist in the first place
157     */
158     function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
159         for (uint256 i = 0; i < addrs.length; i++) {
160             if (removeAddressFromWhitelist(addrs[i])) {
161                 success = true;
162             }
163         }
164     }
165 }
166 
167 library SafeMath {
168 
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         if (a == 0) {
171             return 0;
172         }
173         uint c = a * b;
174         assert(c / a == b);
175         return c;
176     }
177 
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         // assert(b > 0); // Solidity automatically throws when dividing by 0
180         uint256 c = a / b;
181         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182         return c;
183     }
184 
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         assert(b <= a);
187         return a - b;
188     }
189 
190     function add(uint256 a, uint256 b) internal pure returns (uint256) {
191         uint256 c = a + b;
192         assert(c >= a);
193         return c;
194     }
195   
196 }
197  
198 
199 contract BaseRabbit  is Whitelist {
200     event EmotherCount(uint32 mother, uint summ);
201     event SalaryBunny(uint32 bunnyId, uint cost);
202     event CreateChildren(uint32 matron, uint32 sire, uint32 child);
203     event BunnyDescription(uint32 bunnyId, string name);
204     event CoolduwnMother(uint32 bunnyId, uint num);
205     event Referral(address from, uint32 matronID, uint32 childID, uint currentTime);
206     event Approval(address owner, address approved, uint32 tokenId);
207     event Transfer(address from, address to, uint32 tokenId);
208     event NewBunny(uint32 bunnyId, uint dnk, uint256 blocknumber, uint breed);
209  
210 
211     using SafeMath for uint256;
212     bool pauseSave = false;
213     
214     // ID the last seal
215     // ID the last seal
216     bool public promoPause = false;
217 
218 
219 
220 
221     function setPromoPause() public onlyWhitelisted() {
222         promoPause = !promoPause;
223     }
224 
225 
226  // 
227     // внешняя функция сколько заработала мамочка
228     mapping(uint32 => uint) public totalSalaryBunny;
229     // кто мамочка у ребёнка
230     mapping(uint32 => uint32[5]) public rabbitMother;
231     // сколько раз стала мамочка текущий кролик
232     mapping(uint32 => uint) public motherCount;
233     // сколько стоит скрещивание у кролика
234     mapping(uint32 => uint)  public rabbitSirePrice;
235     // разрешено ли менять кролику пол
236     mapping(uint32 => bool)  public allowedChangeSex;
237     // сколько мужиков с текущим геном
238    // mapping(uint => uint32[]) public sireGenom;
239     mapping (uint32 => uint) mapDNK;
240    
241     mapping (uint32 => bool) giffblock; 
242     /**
243     * Where we will store information about rabbits
244     */
245   //  Rabbit[]  public rabbits;
246     mapping (uint32 => Rabbit)  tokenBunny; 
247      
248     uint public tokenBunnyTotal;
249     /**
250     * who owns the rabbit
251     */
252     mapping (uint32 => address) public rabbitToOwner; 
253     mapping (address => uint32[]) public ownerBunnies;
254     mapping (address => bool) ownerGennezise;
255 
256     struct Rabbit { 
257          // parents
258         uint32 mother;
259         uint32 sire; 
260         // block in which a rabbit was born
261         uint birthblock;
262          // number of births or how many times were offspring
263         uint birthCount;
264          // The time when Rabbit last gave birth
265         uint birthLastTime;
266         //indexGenome   
267         uint genome; 
268     }
269 }
270 
271 
272 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
273 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
274 contract ERC721 {
275     // Required methods 
276 
277     function ownerOf(uint32 _tokenId) public view returns (address owner);
278     function approve(address _to, uint32 _tokenId) public returns (bool success);
279     function transfer(address _to, uint32 _tokenId) public;
280     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
281     function totalSupply() public view returns (uint total);
282     function balanceOf(address _owner) public view returns (uint balance);
283 
284 }
285 
286 /// @title Interface new rabbits address
287 contract PrivateRabbitInterface {
288     function getNewRabbit(address from)  public view returns (uint);
289     function mixDNK(uint dnkmother, uint dnksire, uint genome)  public view returns (uint);
290     function isUIntPrivate() public pure returns (bool);
291 }
292 
293 
294 contract Rabbit is BaseRabbit, ERC721 {
295     uint public totalBunny = 0;
296     string public constant name = "CryptoRabbits";
297     string public constant symbol = "CRB";
298 
299     function ownerOf(uint32 _tokenId) public view returns (address owner) {
300         return rabbitToOwner[_tokenId];
301     }
302 
303     function approve(address _to, uint32 _tokenId) public returns (bool) { 
304         _to;
305         _tokenId;
306         return false;
307     }
308 
309 
310     function removeTokenList(address _owner, uint32 _tokenId) internal { 
311         require(isPauseSave());
312         uint count = ownerBunnies[_owner].length;
313         for (uint256 i = 0; i < count; i++) {
314             if(ownerBunnies[_owner][i] == _tokenId)
315             { 
316                 delete ownerBunnies[_owner][i];
317                 if(count > 0 && count != (i-1)){
318                     ownerBunnies[_owner][i] = ownerBunnies[_owner][(count-1)];
319                     delete ownerBunnies[_owner][(count-1)];
320                 } 
321                 ownerBunnies[_owner].length--;
322                 return;
323             } 
324         }
325     }
326 
327 
328     /**
329     * @dev add a new bunny in the storage
330      */
331     function addTokenList(address owner,  uint32 _tokenId) internal {
332         ownerBunnies[owner].push( _tokenId);
333         rabbitToOwner[_tokenId] = owner; 
334     }
335  
336 
337     function transfer(address _to, uint32 _tokenId) public {
338         require(isPauseSave());
339         address currentOwner = msg.sender;
340         address oldOwner = rabbitToOwner[_tokenId];
341         require(rabbitToOwner[_tokenId] == msg.sender);
342         require(currentOwner != _to);
343         require(_to != address(0));
344         removeTokenList(oldOwner, _tokenId);
345         addTokenList(_to, _tokenId);
346         emit Transfer(oldOwner, _to, _tokenId);
347     }
348     
349     function transferFrom(address _from, address _to, uint32 _tokenId) public onlyWhitelisted() returns(bool) {
350         require(isPauseSave());
351         address oldOwner = rabbitToOwner[_tokenId];
352         require(oldOwner == _from); 
353         require(oldOwner != _to);
354         require(_to != address(0));
355         removeTokenList(oldOwner, _tokenId);
356         addTokenList(_to, _tokenId); 
357         setAllowedChangeSex(_tokenId, false);
358         emit Transfer (oldOwner, _to, _tokenId);
359         return true;
360     }  
361      
362 
363     function isPauseSave() public view returns(bool) {
364         return !pauseSave;
365     }
366     
367     function isPromoPause() public view returns(bool) {
368         if (getInWhitelist(msg.sender)) {
369             return true;
370         } else {
371             return !promoPause;
372         } 
373     }
374 
375     function setPauseSave() public onlyWhitelisted() returns(bool) {
376         return pauseSave = !pauseSave;
377     }
378 
379     function setTotalBunny() internal onlyWhitelisted() returns(uint) {
380         require(isPauseSave());
381         return totalBunny = totalBunny.add(1);
382     }
383      
384 
385     function setTotalBunny_id(uint _totalBunny) external onlyWhitelisted() {
386         require(isPauseSave());
387         totalBunny = _totalBunny;
388     }
389 
390 
391     function setTokenBunny(uint32 mother, uint32  sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome, address _owner, uint DNK) 
392         external onlyWhitelisted() returns(uint32) {
393             uint32 id = uint32(setTotalBunny());
394             tokenBunny[id] = Rabbit(mother, sire, birthblock, birthCount, birthLastTime, genome);
395             mapDNK[id] = DNK;
396             addTokenList(_owner, id); 
397 
398             emit NewBunny(id, DNK, block.number, 0);
399             emit CreateChildren(mother, sire, id);
400             setMotherCount(id, 0);
401         return id;
402     }
403     
404     
405     // correction of mistakes with parents
406     function relocateToken(
407         uint32 id, 
408         uint32 mother, 
409         uint32 sire, 
410         uint birthblock, 
411         uint birthCount, 
412         uint birthLastTime, 
413         uint genome, 
414         address _owner, 
415         uint DNK
416          ) external onlyWhitelisted(){
417         //    if(mapDNK[id] != 0){ 
418                 tokenBunny[id] = Rabbit(mother, sire, birthblock, birthCount, birthLastTime, genome);
419                 mapDNK[id] = DNK;
420                 addTokenList(_owner, id);
421        //     }
422     }
423 
424     
425     
426     function setDNK( uint32 _bunny, uint dnk) external onlyWhitelisted() {
427         require(isPauseSave());
428         mapDNK[_bunny] = dnk;
429     }
430     
431     
432     function setMotherCount( uint32 _bunny, uint count) public onlyWhitelisted() {
433         require(isPauseSave()); 
434         motherCount[_bunny] = count;
435     }
436     
437     function setRabbitSirePrice( uint32 _bunny, uint count) external onlyWhitelisted() {
438         require(isPauseSave()); 
439         rabbitSirePrice[_bunny] = count;
440     }
441   
442     function setAllowedChangeSex( uint32 _bunny, bool canBunny) public onlyWhitelisted() {
443         require(isPauseSave()); 
444         allowedChangeSex[_bunny] = canBunny;
445     }
446     
447     function setTotalSalaryBunny( uint32 _bunny, uint count) external onlyWhitelisted() {
448         require(isPauseSave()); 
449         totalSalaryBunny[_bunny] = count;
450     }  
451 
452     function setRabbitMother(uint32 children, uint32[5] _m) external onlyWhitelisted() { 
453              rabbitMother[children] = _m;
454     }
455 
456     function setGenome(uint32 _bunny, uint genome)  external onlyWhitelisted(){ 
457         tokenBunny[_bunny].genome = genome;
458     }
459 
460     function setParent(uint32 _bunny, uint32 mother, uint32 sire)  external onlyWhitelisted() { 
461         tokenBunny[_bunny].mother = mother;
462         tokenBunny[_bunny].sire = sire;
463     }
464 
465     function setBirthLastTime(uint32 _bunny, uint birthLastTime) external onlyWhitelisted() { 
466         tokenBunny[_bunny].birthLastTime = birthLastTime;
467     }
468 
469     function setBirthCount(uint32 _bunny, uint birthCount) external onlyWhitelisted() { 
470         tokenBunny[_bunny].birthCount = birthCount;
471     }
472 
473     function setBirthblock(uint32 _bunny, uint birthblock) external onlyWhitelisted() { 
474         tokenBunny[_bunny].birthblock = birthblock;
475     }
476 
477     function setGiffBlock(uint32 _bunny, bool blocked) external onlyWhitelisted() { 
478         giffblock[_bunny] = blocked;
479     }
480 
481 
482     function setOwnerGennezise(address _to, bool canYou) external onlyWhitelisted() { 
483         ownerGennezise[_to] = canYou;
484     }
485 
486 
487  
488 
489     ////// getters
490  
491     function getOwnerGennezise(address _to) public view returns(bool) { 
492         return ownerGennezise[_to];
493     }
494     function getGiffBlock(uint32 _bunny) public view returns(bool) { 
495         return !giffblock[_bunny];
496     }
497 
498     function getAllowedChangeSex(uint32 _bunny) public view returns(bool) {
499         return !allowedChangeSex[_bunny];
500     } 
501  
502     function getRabbitSirePrice(uint32 _bunny) public view returns(uint) {
503         return rabbitSirePrice[_bunny];
504     } 
505 
506     function getTokenOwner(address owner) public view returns(uint total, uint32[] list) {
507         total = ownerBunnies[owner].length;
508         list = ownerBunnies[owner];
509     } 
510 
511     function totalSupply() public view returns (uint total) {
512         return totalBunny;
513     }
514 
515     function balanceOf(address _owner) public view returns (uint) {
516         return ownerBunnies[_owner].length;
517     }
518 
519      function getMotherCount(uint32 _mother) public view returns(uint) { //internal
520         return  motherCount[_mother];
521     }
522 
523      function getTotalSalaryBunny(uint32 _bunny) public view returns(uint) { //internal
524         return  totalSalaryBunny[_bunny];
525     }
526 
527     function getRabbitMother( uint32 mother) public view returns(uint32[5]) {
528         return rabbitMother[mother];
529     }
530 
531      function getRabbitMotherSumm(uint32 mother) public view returns(uint count) { //internal
532         for (uint m = 0; m < 5 ; m++) {
533             if(rabbitMother[mother][m] != 0 ) { 
534                 count++;
535             }
536         }
537     }
538     function getDNK(uint32 bunnyid) public view returns(uint) { 
539         return mapDNK[bunnyid];
540     }
541 
542 
543     function getTokenBunny(uint32 _bunny) public 
544     view returns(uint32 mother, uint32 sire, uint birthblock, uint birthCount, uint birthLastTime, uint genome) { 
545         mother = tokenBunny[_bunny].mother;
546         sire = tokenBunny[_bunny].sire;
547         birthblock = tokenBunny[_bunny].birthblock;
548         birthCount = tokenBunny[_bunny].birthCount;
549         birthLastTime = tokenBunny[_bunny].birthLastTime;
550         genome = tokenBunny[_bunny].genome;
551     }
552 
553     function isUIntPublic() public view returns(bool) {
554         require(isPauseSave());
555         return true;
556     }
557 
558     function getSex(uint32 _bunny) public view returns(bool) {
559         if(getRabbitSirePrice(_bunny) > 0) {
560             return true;
561         }
562         return false;
563     }
564 
565     function getGenome(uint32 _bunny) public view returns( uint) { 
566         return tokenBunny[_bunny].genome;
567     }
568 
569     function getParent(uint32 _bunny) public view returns(uint32 mother, uint32 sire) { 
570         mother = tokenBunny[_bunny].mother;
571         sire = tokenBunny[_bunny].sire;
572     }
573 
574     function getBirthLastTime(uint32 _bunny) public view returns(uint) { 
575         return tokenBunny[_bunny].birthLastTime;
576     }
577 
578     function getBirthCount(uint32 _bunny) public view returns(uint) { 
579         return tokenBunny[_bunny].birthCount;
580     }
581 
582     function getBirthblock(uint32 _bunny) public view returns(uint) { 
583         return tokenBunny[_bunny].birthblock;
584     }
585   
586 
587     function getBunnyInfo(uint32 _bunny) public view returns(
588         uint32 mother,
589         uint32 sire,
590         uint birthblock,
591         uint birthCount,
592         uint birthLastTime,
593         bool role, 
594         uint genome,
595         bool interbreed,
596         uint leftTime,
597         uint lastTime,
598         uint price,
599         uint motherSumm
600         ) { 
601             role = getSex(_bunny);
602             mother = tokenBunny[_bunny].mother;
603             sire = tokenBunny[_bunny].sire;
604             birthblock = tokenBunny[_bunny].birthblock;
605             birthCount = tokenBunny[_bunny].birthCount;
606             birthLastTime = tokenBunny[_bunny].birthLastTime;
607             genome = tokenBunny[_bunny].genome;
608             motherSumm = getMotherCount(_bunny);
609             price = getRabbitSirePrice(_bunny);
610             lastTime = lastTime.add(birthLastTime);
611             if(lastTime <= now) {
612                 interbreed = true;
613             } else {
614                 leftTime = lastTime.sub(now);
615             }
616     }
617 }