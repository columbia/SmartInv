1 pragma solidity ^0.4.23;
2 
3 /*
4 *  ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗██╗   ██╗    
5 *  ██╔══██╗██║   ██║████╗  ██║████╗  ██║╚██╗ ██╔╝    
6 *  ██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║ ╚████╔╝     
7 *  ██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║  ╚██╔╝      
8 *  ██████╔╝╚██████╔╝██║ ╚████║██║ ╚████║   ██║       
9 *  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝   ╚═╝       
10 *                                                    
11 *   ██████╗  █████╗ ███╗   ███╗███████╗              
12 *  ██╔════╝ ██╔══██╗████╗ ████║██╔════╝              
13 *  ██║  ███╗███████║██╔████╔██║█████╗                
14 *  ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝                
15 *  ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗              
16 *   ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝      
17 
18 
19 * Author:  Konstantin G...
20 * Telegram: @bunnygame
21 * 
22 * email: info@bunnycoin.co
23 * site : http://bunnycoin.co
24 * @title Ownable
25 * @dev The Ownable contract has an owner address, and provides basic authorization control
26 * functions, this simplifies the implementation of "user permissions".
27 */
28 
29 contract Ownable {
30     
31     address public ownerCEO;
32     address ownerMoney;  
33     address ownerServer;
34     address privAddress;
35     
36     /**
37     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38     * account.
39     */
40     constructor() public { 
41         ownerCEO = msg.sender; 
42         ownerServer = msg.sender;
43         ownerMoney = msg.sender;
44     }
45  
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49     modifier onlyOwner() {
50         require(msg.sender == ownerCEO);
51         _;
52     }
53    
54     modifier onlyServer() {
55         require(msg.sender == ownerServer || msg.sender == ownerCEO);
56         _;
57     }
58 
59     function transferOwnership(address add) public onlyOwner {
60         if (add != address(0)) {
61             ownerCEO = add;
62         }
63     }
64  
65 
66     function transferOwnershipServer(address add) public onlyOwner {
67         if (add != address(0)) {
68             ownerServer = add;
69         }
70     } 
71      
72     function transferOwnerMoney(address _ownerMoney) public  onlyOwner {
73         if (_ownerMoney != address(0)) {
74             ownerMoney = _ownerMoney;
75         }
76     }
77  
78     function getOwnerMoney() public view onlyOwner returns(address) {
79         return ownerMoney;
80     } 
81     function getOwnerServer() public view onlyOwner returns(address) {
82         return ownerServer;
83     }
84     /**
85     *  @dev private contract
86      */
87     function getPrivAddress() public view onlyOwner returns(address) {
88         return privAddress;
89     }
90 }
91 
92 
93 
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100     
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint c = a * b;
106         assert(c / a == b);
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // assert(b > 0); // Solidity automatically throws when dividing by 0
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114         return c;
115     }
116 
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         assert(b <= a);
119         return a - b;
120     }
121 
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         assert(c >= a);
125         return c;
126     }
127   
128 }
129  
130 
131 contract BaseRabbit  is Ownable {
132        
133 
134 
135     event SendBunny(address newOwnerBunny, uint32 bunnyId);
136     event StopMarket(uint32 bunnyId);
137     event StartMarket(uint32 bunnyId, uint money);
138     event BunnyBuy(uint32 bunnyId, uint money);  
139     event EmotherCount(uint32 mother, uint summ);
140     event NewBunny(uint32 bunnyId, uint dnk, uint256 blocknumber, uint breed );
141     event ChengeSex(uint32 bunnyId, bool sex, uint256 price);
142     event SalaryBunny(uint32 bunnyId, uint cost);
143     event CreateChildren(uint32 matron, uint32 sire, uint32 child);
144     event BunnyName(uint32 bunnyId, string name);
145     event BunnyDescription(uint32 bunnyId, string name);
146     event CoolduwnMother(uint32 bunnyId, uint num);
147 
148 
149     event Transfer(address from, address to, uint32 tokenId);
150     event Approval(address owner, address approved, uint32 tokenId);
151     event OwnerBunnies(address owner, uint32  tokenId);
152 
153  
154 
155     address public  myAddr_test = 0x982a49414fD95e3268D3559540A67B03e40AcD64;
156 
157     using SafeMath for uint256;
158     bool pauseSave = false;
159     uint256 bigPrice = 0.0005 ether;
160     
161     uint public commission_system = 5;
162      
163     // ID the last seal
164     uint32 public lastIdGen0;
165     uint public totalGen0 = 0;
166     // ID the last seal
167     uint public lastTimeGen0;
168     
169     // ID the last seal
170   //  uint public timeRangeCreateGen0 = 1800;
171     uint public timeRangeCreateGen0 = 1;
172 
173     uint public promoGen0 = 2500;
174     uint public promoMoney = 1*bigPrice;
175     bool public promoPause = false;
176 
177 
178     function setPromoGen0(uint _promoGen0) public onlyOwner {
179         promoGen0 = _promoGen0;
180     }
181 
182     function setPromoPause() public onlyOwner {
183         promoPause = !promoPause;
184     }
185 
186 
187 
188     function setPromoMoney(uint _promoMoney) public onlyOwner {
189         promoMoney = _promoMoney;
190     }
191     modifier timeRange() {
192         require((lastTimeGen0+timeRangeCreateGen0) < now);
193         _;
194     } 
195 
196     mapping(uint32 => uint) public totalSalaryBunny;
197     mapping(uint32 => uint32[5]) public rabbitMother;
198     
199     mapping(uint32 => uint) public motherCount;
200     
201     // how many times did the rabbit cross
202     mapping(uint32 => uint) public rabbitBreedCount;
203 
204     mapping(uint32 => uint)  public rabbitSirePrice;
205     mapping(uint => uint32[]) public sireGenom;
206     mapping (uint32 => uint) mapDNK;
207    
208     uint32[12] public cooldowns = [
209         uint32(1 minutes),
210         uint32(2 minutes),
211         uint32(4 minutes),
212         uint32(8 minutes),
213         uint32(16 minutes),
214         uint32(32 minutes),
215         uint32(1 hours),
216         uint32(2 hours),
217         uint32(4 hours),
218         uint32(8 hours),
219         uint32(16 hours),
220         uint32(1 days)
221     ];
222 
223 
224     struct Rabbit { 
225          // parents
226         uint32 mother;
227         uint32 sire; 
228         // block in which a rabbit was born
229         uint birthblock;
230          // number of births or how many times were offspring
231         uint birthCount;
232          // The time when Rabbit last gave birth
233         uint birthLastTime;
234         //the current role of the rabbit
235         uint role;
236         //indexGenome   
237         uint genome;
238     }
239     /**
240     * Where we will store information about rabbits
241     */
242     Rabbit[]  public rabbits;
243      
244     /**
245     * who owns the rabbit
246     */
247     mapping (uint32 => address) public rabbitToOwner; 
248     mapping(address => uint32[]) public ownerBunnies;
249     //mapping (address => uint) ownerRabbitCount;
250     mapping (uint32 => string) rabbitDescription;
251     mapping (uint32 => string) rabbitName; 
252 
253     //giff 
254     mapping (uint32 => bool) giffblock; 
255     mapping (address => bool) ownerGennezise;
256 
257 }
258 
259 
260 
261 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
262 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
263 contract ERC721 {
264     // Required methods 
265  
266 
267     function ownerOf(uint32 _tokenId) public view returns (address owner);
268     function approve(address _to, uint32 _tokenId) public returns (bool success);
269     function transfer(address _to, uint32 _tokenId) public;
270     function transferFrom(address _from, address _to, uint32 _tokenId) public returns (bool);
271     function totalSupply() public view returns (uint total);
272     function balanceOf(address _owner) public view returns (uint balance);
273 
274 }
275 
276 /// @title Interface new rabbits address
277 contract PrivateRabbitInterface {
278     function getNewRabbit(address from)  public view returns (uint);
279     function mixDNK(uint dnkmother, uint dnksire, uint genome)  public view returns (uint);
280     function isUIntPrivate() public pure returns (bool);
281     
282   //  function mixGenesRabbits(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
283 }
284 
285 
286 
287 
288 contract BodyRabbit is BaseRabbit, ERC721 {
289      
290     uint public totalBunny = 0;
291     string public constant name = "CryptoRabbits";
292     string public constant symbol = "CRB";
293 
294 
295     PrivateRabbitInterface privateContract;
296 
297     /**
298     * @dev setting up a new address for a private contract
299     */
300     function setPriv(address _privAddress) public returns(bool) {
301         privAddress = _privAddress;
302         privateContract = PrivateRabbitInterface(_privAddress);
303     } 
304 
305     bool public fcontr = false;
306  
307     
308     constructor() public { 
309         setPriv(myAddr_test);
310         fcontr = true;
311     }
312 
313     function isPriv() public view returns(bool) {
314         return privateContract.isUIntPrivate();
315     }
316 
317     modifier checkPrivate() {
318         require(isPriv());
319         _;
320     }
321 
322     function ownerOf(uint32 _tokenId) public view returns (address owner) {
323         return rabbitToOwner[_tokenId];
324     }
325 
326     function approve(address _to, uint32 _tokenId) public returns (bool) { 
327         _to;
328         _tokenId;
329         return false;
330     }
331 
332 
333     function removeTokenList(address _owner, uint32 _tokenId) internal { 
334         uint count = ownerBunnies[_owner].length;
335         for (uint256 i = 0; i < count; i++) {
336             if(ownerBunnies[_owner][i] == _tokenId)
337             { 
338                 delete ownerBunnies[_owner][i];
339                 if(count > 0 && count != (i-1)){
340                     ownerBunnies[_owner][i] = ownerBunnies[_owner][(count-1)];
341                     delete ownerBunnies[_owner][(count-1)];
342                 } 
343                 ownerBunnies[_owner].length--;
344                 return;
345             } 
346         }
347     }
348     /**
349     * Get the cost of the reward for pairing
350     * @param _tokenId - rabbit that mates
351      */
352     function getSirePrice(uint32 _tokenId) public view returns(uint) {
353         if(rabbits[(_tokenId-1)].role == 1){
354             uint procent = (rabbitSirePrice[_tokenId] / 100);
355             uint res = procent.mul(25);
356             uint system  = procent.mul(commission_system);
357 
358             res = res.add(rabbitSirePrice[_tokenId]);
359             return res.add(system); 
360         } else {
361             return 0;
362         }
363     }
364 
365  
366     function addTokenList(address owner,  uint32 _tokenId) internal {
367         ownerBunnies[owner].push( _tokenId);
368         emit OwnerBunnies(owner, _tokenId);
369         rabbitToOwner[_tokenId] = owner; 
370     }
371  
372 
373     function transfer(address _to, uint32 _tokenId) public {
374         address currentOwner = msg.sender;
375         address oldOwner = rabbitToOwner[_tokenId];
376         require(rabbitToOwner[_tokenId] == msg.sender);
377         require(currentOwner != _to);
378         require(_to != address(0));
379         removeTokenList(oldOwner, _tokenId);
380         addTokenList(_to, _tokenId);
381         emit Transfer(oldOwner, _to, _tokenId);
382     }
383 
384     function transferFrom(address _from, address _to, uint32 _tokenId) public returns(bool) {
385         address oldOwner = rabbitToOwner[_tokenId];
386         require(oldOwner == _from);
387         require(oldOwner != _to);
388         require(_to != address(0));
389         removeTokenList(oldOwner, _tokenId);
390         addTokenList(_to, _tokenId); 
391         emit Transfer (oldOwner, _to, _tokenId);
392         return true;
393     }  
394     
395     function setTimeRangeGen0(uint _sec) public onlyOwner {
396         timeRangeCreateGen0 = _sec;
397     }
398 
399 
400     function isPauseSave() public view returns(bool) {
401         return !pauseSave;
402     }
403     function isPromoPause() public view returns(bool) {
404         if(msg.sender == ownerServer || msg.sender == ownerCEO){
405             return true;
406         }else{
407             return !promoPause;
408         } 
409     }
410 
411     function setPauseSave() public onlyOwner  returns(bool) {
412         return pauseSave = !pauseSave;
413     }
414 
415     /**
416     * for check
417     *
418     */
419     function isUIntPublic() public pure returns(bool) {
420         return true;
421     }
422 
423 
424     function getTokenOwner(address owner) public view returns(uint total, uint32[] list) {
425         total = ownerBunnies[owner].length;
426         list = ownerBunnies[owner];
427     } 
428 
429 
430 
431     function setRabbitMother(uint32 children, uint32 mother) internal { 
432         require(children != mother);
433         if (mother == 0 )
434         {
435             return;
436         }
437         uint32[11] memory pullMother;
438         uint start = 0;
439         for (uint i = 0; i < 5; i++) {
440             if (rabbitMother[mother][i] != 0) {
441               pullMother[start] = uint32(rabbitMother[mother][i]);
442               rabbitMother[mother][i] = 0;
443               start++;
444             } 
445         }
446         pullMother[start] = mother;
447         start++;
448         for (uint m = 0; m < 5; m++) {
449              if(start >  5){
450                     rabbitMother[children][m] = pullMother[(m+1)];
451              }else{
452                     rabbitMother[children][m] = pullMother[m];
453              }
454         } 
455         setMotherCount(mother);
456     }
457 
458       
459 
460     function setMotherCount(uint32 _mother) internal returns(uint)  { //internal
461         motherCount[_mother] = motherCount[_mother].add(1);
462         emit EmotherCount(_mother, motherCount[_mother]);
463         return motherCount[_mother];
464     }
465 
466 
467      function getMotherCount(uint32 _mother) public view returns(uint) { //internal
468         return  motherCount[_mother];
469     }
470 
471 
472      function getTotalSalaryBunny(uint32 _bunny) public view returns(uint) { //internal
473         return  totalSalaryBunny[_bunny];
474     }
475  
476  
477     function getRabbitMother( uint32 mother) public view returns(uint32[5]){
478         return rabbitMother[mother];
479     }
480 
481      function getRabbitMotherSumm(uint32 mother) public view returns(uint count) { //internal
482         for (uint m = 0; m < 5 ; m++) {
483             if(rabbitMother[mother][m] != 0 ) { 
484                 count++;
485             }
486         }
487     }
488 
489 
490 
491     function getRabbitDNK(uint32 bunnyid) public view returns(uint) { 
492         return mapDNK[bunnyid];
493     }
494      
495     function bytes32ToString(bytes32 x)internal pure returns (string) {
496         bytes memory bytesString = new bytes(32);
497         uint charCount = 0;
498         for (uint j = 0; j < 32; j++) {
499             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
500             if (char != 0) {
501                 bytesString[charCount] = char;
502                 charCount++;
503             }
504         }
505         bytes memory bytesStringTrimmed = new bytes(charCount);
506         for (j = 0; j < charCount; j++) {
507             bytesStringTrimmed[j] = bytesString[j];
508         }
509         return string(bytesStringTrimmed);
510     }
511     
512     function uintToBytes(uint v) internal pure returns (bytes32 ret) {
513         if (v == 0) {
514             ret = '0';
515         } else {
516         while (v > 0) {
517                 ret = bytes32(uint(ret) / (2 ** 8));
518                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
519                 v /= 10;
520             }
521         }
522         return ret;
523     }
524 
525     function totalSupply() public view returns (uint total) {
526         return totalBunny;
527     }
528 
529     function balanceOf(address _owner) public view returns (uint) {
530       //  _owner;
531         return ownerBunnies[_owner].length;
532     }
533 
534     function sendMoney(address _to, uint256 _money) internal { 
535         _to.transfer((_money/100)*95);
536         ownerMoney.transfer((_money/100)*5); 
537     }
538 
539     function getGiffBlock(uint32 _bunnyid) public view returns(bool) { 
540         return !giffblock[_bunnyid];
541     }
542 
543     function getOwnerGennezise(address _to) public view returns(bool) { 
544         return ownerGennezise[_to];
545     }
546     
547 
548     function getBunny(uint32 _bunny) public view returns(
549         uint32 mother,
550         uint32 sire,
551         uint birthblock,
552         uint birthCount,
553         uint birthLastTime,
554         uint role, 
555         uint genome,
556         bool interbreed,
557         uint leftTime,
558         uint lastTime,
559         uint price,
560         uint motherSumm
561         )
562         {
563             price = getSirePrice(_bunny);
564             _bunny = _bunny - 1;
565 
566             mother = rabbits[_bunny].mother;
567             sire = rabbits[_bunny].sire;
568             birthblock = rabbits[_bunny].birthblock;
569             birthCount = rabbits[_bunny].birthCount;
570             birthLastTime = rabbits[_bunny].birthLastTime;
571             role = rabbits[_bunny].role;
572             genome = rabbits[_bunny].genome;
573                      
574             if(birthCount > 14) {
575                 birthCount = 14;
576             }
577 
578             motherSumm = motherCount[_bunny];
579 
580             lastTime = uint(cooldowns[birthCount]);
581             lastTime = lastTime.add(birthLastTime);
582             if(lastTime <= now) {
583                 interbreed = true;
584             } else {
585                 leftTime = lastTime.sub(now);
586             }
587     }
588 
589 
590     function getBreed(uint32 _bunny) public view returns(
591         bool interbreed
592         )
593         {
594         _bunny = _bunny - 1;
595         if(_bunny == 0) {
596             return;
597         }
598         uint birtTime = rabbits[_bunny].birthLastTime;
599         uint birthCount = rabbits[_bunny].birthCount;
600 
601         uint  lastTime = uint(cooldowns[birthCount]);
602         lastTime = lastTime.add(birtTime);
603 
604         if(lastTime <= now && rabbits[_bunny].role == 0 ) {
605             interbreed = true;
606         } 
607     }
608     /**
609      *  we get cooldown
610      */
611     function getcoolduwn(uint32 _mother) public view returns(uint lastTime, uint cd, uint lefttime) {
612         cd = rabbits[(_mother-1)].birthCount;
613         if(cd > 14) {
614             cd = 14;
615         }
616         // time when I can give birth
617         lastTime = (cooldowns[cd] + rabbits[(_mother-1)].birthLastTime);
618         if(lastTime > now) {
619             // I can not give birth, it remains until delivery
620             lefttime = lastTime.sub(now);
621         }
622     }
623 
624 }
625 
626 /**
627 * sale and bye Rabbits
628 */
629 contract RabbitMarket is BodyRabbit {
630  
631  // Long time
632     uint stepMoney = 2*60*60;
633            
634     function setStepMoney(uint money) public onlyOwner {
635         stepMoney = money;
636     }
637     /**
638     * @dev number of rabbits participating in the auction
639     */
640     uint marketCount = 0; 
641 
642     uint daysperiod = 1;
643     uint sec = 1;
644     // how many last sales to take into account in the contract before the formation of the price
645     uint8 middlelast = 20;
646     
647    
648      
649     // those who currently participate in the sale
650     mapping(uint32 => uint256[]) internal marketRabbits;
651      
652      
653     uint256 middlePriceMoney = 1; 
654     uint256 middleSaleTime = 0;  
655     uint moneyRange;
656  
657     function setMoneyRange(uint _money) public onlyOwner {
658         moneyRange = _money;
659     }
660      
661     // the last cost of a sold seal
662     uint lastmoney = 0;  
663     // the time which was spent on the sale of the cat
664     uint lastTimeGen0;
665 
666     //how many closed auctions
667     uint public totalClosedBID = 0;
668     mapping (uint32 => uint) bunnyCost; 
669     mapping(uint32 => uint) bidsIndex;
670  
671 
672     /**
673     * @dev get rabbit price
674     */
675     function currentPrice(uint32 _bunnyid) public view returns(uint) {
676 
677         uint money = bunnyCost[_bunnyid];
678         if (money > 0) {
679             uint moneyComs = money.div(100);
680             moneyComs = moneyComs.mul(5);
681             return money.add(moneyComs);
682         }
683     }
684     /**
685     * @dev We are selling rabbit for sale
686     * @param _bunnyid - whose rabbit we exhibit 
687     * @param _money - sale amount 
688     */
689   function startMarket(uint32 _bunnyid, uint _money) public returns (uint) {
690         require(isPauseSave());
691         require(_money >= bigPrice);
692         require(rabbitToOwner[_bunnyid] ==  msg.sender);
693         bunnyCost[_bunnyid] = _money;
694         emit StartMarket(_bunnyid, _money);
695         return marketCount++;
696     }
697 
698 
699     /**
700     * @dev remove from sale rabbit
701     * @param _bunnyid - a rabbit that is removed from sale 
702     */
703     function stopMarket(uint32 _bunnyid) public returns(uint) {
704         require(isPauseSave());
705         require(rabbitToOwner[_bunnyid] == msg.sender);  
706         bunnyCost[_bunnyid] = 0;
707         emit StopMarket(_bunnyid);
708         return marketCount--;
709     }
710 
711     /**
712     * @dev Acquisition of a rabbit from another user
713     * @param _bunnyid  Bunny
714      */
715     function buyBunny(uint32 _bunnyid) public payable {
716         require(isPauseSave());
717         require(rabbitToOwner[_bunnyid] != msg.sender);
718         uint price = currentPrice(_bunnyid);
719 
720         require(msg.value >= price && 0 != price);
721         // stop trading on the current rabbit
722         totalClosedBID++;
723         // Sending money to the old user
724         sendMoney(rabbitToOwner[_bunnyid], msg.value);
725         // is sent to the new owner of the bought rabbit
726         transferFrom(rabbitToOwner[_bunnyid], msg.sender, _bunnyid); 
727         stopMarket(_bunnyid); 
728 
729         emit BunnyBuy(_bunnyid, price);
730         emit SendBunny (msg.sender, _bunnyid);
731     } 
732 
733     /**
734     * @dev give a rabbit to a specific user
735     * @param add new address owner rabbits
736     */
737     function giff(uint32 bunnyid, address add) public {
738         require(rabbitToOwner[bunnyid] == msg.sender);
739         // a rabbit taken for free can not be given
740         require(!(giffblock[bunnyid]));
741         transferFrom(msg.sender, add, bunnyid);
742     }
743 
744     function getMarketCount() public view returns(uint) {
745         return marketCount;
746     }
747 }
748 
749 
750 /**
751 * Basic actions for the transfer of rights of rabbits
752 */
753 contract BunnyGame is RabbitMarket {    
754   
755     function transferNewBunny(address _to, uint32 _bunnyid, uint localdnk, uint breed, uint32 matron, uint32 sire) internal {
756         emit NewBunny(_bunnyid, localdnk, block.number, breed);
757         emit CreateChildren(matron, sire, _bunnyid);
758         addTokenList(_to, _bunnyid);
759         totalSalaryBunny[_bunnyid] = 0;
760         motherCount[_bunnyid] = 0;
761         totalBunny++;
762     }
763 
764     /***
765     * @dev create a new gene and put it up for sale, this operation takes place on the server
766     */
767     function createGennezise(uint32 _matron) public {
768          
769         bool promo = false;
770         require(isPriv());
771         require(isPauseSave());
772         require(isPromoPause());
773  
774         if (totalGen0 > promoGen0) { 
775             require(msg.sender == ownerServer || msg.sender == ownerCEO);
776         } else if (!(msg.sender == ownerServer || msg.sender == ownerCEO)) {
777             // promo action
778                 require(!ownerGennezise[msg.sender]);
779                 ownerGennezise[msg.sender] = true;
780                 promo = true;
781         }
782         
783         uint  localdnk = privateContract.getNewRabbit(msg.sender);
784         Rabbit memory _Rabbit =  Rabbit( 0, 0, block.number, 0, 0, 0, 0);
785         uint32 _bunnyid =  uint32(rabbits.push(_Rabbit));
786         mapDNK[_bunnyid] = localdnk;
787        
788         transferNewBunny(msg.sender, _bunnyid, localdnk, 0, 0, 0);  
789         
790         lastTimeGen0 = now;
791         lastIdGen0 = _bunnyid; 
792         totalGen0++; 
793 
794         setRabbitMother(_bunnyid, _matron);
795 
796         if (promo) {
797             giffblock[_bunnyid] = true;
798         }
799     }
800 
801     function getGenomeChildren(uint32 _matron, uint32 _sire) internal view returns(uint) {
802         uint genome;
803         if (rabbits[(_matron-1)].genome >= rabbits[(_sire-1)].genome) {
804             genome = rabbits[(_matron-1)].genome;
805         } else {
806             genome = rabbits[(_sire-1)].genome;
807         }
808         return genome.add(1);
809     }
810     
811     /**
812     * create a new rabbit, according to the cooldown
813     * @param _matron - mother who takes into account the cooldown
814     * @param _sire - the father who is rewarded for mating for the fusion of genes
815      */
816     function createChildren(uint32 _matron, uint32 _sire) public  payable returns(uint32) {
817 
818         require(isPriv());
819         require(isPauseSave());
820         require(rabbitToOwner[_matron] == msg.sender);
821         // Checking for the role
822         require(rabbits[(_sire-1)].role == 1);
823         require(_matron != _sire);
824 
825         require(getBreed(_matron));
826         // Checking the money 
827         
828         require(msg.value >= getSirePrice(_sire));
829         
830         uint genome = getGenomeChildren(_matron, _sire);
831 
832         uint localdnk =  privateContract.mixDNK(mapDNK[_matron], mapDNK[_sire], genome);
833         Rabbit memory rabbit =  Rabbit(_matron, _sire, block.number, 0, 0, 0, genome);
834 
835         uint32 bunnyid =  uint32(rabbits.push(rabbit));
836         mapDNK[bunnyid] = localdnk;
837 
838 
839         uint _moneyMother = rabbitSirePrice[_sire].div(4);
840 
841         _transferMoneyMother(_matron, _moneyMother);
842 
843         rabbitToOwner[_sire].transfer(rabbitSirePrice[_sire]);
844 
845         uint system = rabbitSirePrice[_sire].div(100);
846         system = system.mul(commission_system);
847         ownerMoney.transfer(system); // refund previous bidder
848   
849         coolduwnUP(_matron);
850         // we transfer the rabbit to the new owner
851         transferNewBunny(rabbitToOwner[_matron], bunnyid, localdnk, genome, _matron, _sire);   
852         // we establish parents for the child
853         setRabbitMother(bunnyid, _matron);
854         return bunnyid;
855     } 
856   
857     /**
858      *  Set the cooldown for childbirth
859      * @param _mother - mother for which cooldown
860      */
861     function coolduwnUP(uint32 _mother) internal { 
862         require(isPauseSave());
863         rabbits[(_mother-1)].birthCount = rabbits[(_mother-1)].birthCount.add(1);
864         rabbits[(_mother-1)].birthLastTime = now;
865         emit CoolduwnMother(_mother, rabbits[(_mother-1)].birthCount);
866     }
867 
868 
869     /**
870      * @param _mother - matron send money for parrent
871      * @param _valueMoney - current sale
872      */
873     function _transferMoneyMother(uint32 _mother, uint _valueMoney) internal {
874         require(isPauseSave());
875         require(_valueMoney > 0);
876         if (getRabbitMotherSumm(_mother) > 0) {
877             uint pastMoney = _valueMoney/getRabbitMotherSumm(_mother);
878             for (uint i=0; i < getRabbitMotherSumm(_mother); i++) {
879                 if (rabbitMother[_mother][i] != 0) { 
880                     uint32 _parrentMother = rabbitMother[_mother][i];
881                     address add = rabbitToOwner[_parrentMother];
882                     // pay salaries
883                     setMotherCount(_parrentMother);
884                     totalSalaryBunny[_parrentMother] += pastMoney;
885 
886                     emit SalaryBunny(_parrentMother, totalSalaryBunny[_parrentMother]);
887 
888                     add.transfer(pastMoney); // refund previous bidder
889                 }
890             } 
891         }
892     }
893     
894     /**
895     * @dev We set the cost of renting our genes
896     * @param price rent price
897      */
898     function setRabbitSirePrice(uint32 _rabbitid, uint price) public returns(bool) {
899         require(isPauseSave());
900         require(rabbitToOwner[_rabbitid] == msg.sender);
901         require(price > bigPrice);
902 
903         uint lastTime;
904         (lastTime,,) = getcoolduwn(_rabbitid);
905         require(now >= lastTime);
906 
907         if (rabbits[(_rabbitid-1)].role == 1 && rabbitSirePrice[_rabbitid] == price) {
908             return false;
909         }
910 
911         rabbits[(_rabbitid-1)].role = 1;
912         rabbitSirePrice[_rabbitid] = price;
913         uint gen = rabbits[(_rabbitid-1)].genome;
914         sireGenom[gen].push(_rabbitid);
915         emit ChengeSex(_rabbitid, true, getSirePrice(_rabbitid));
916         return true;
917     }
918  
919     /**
920     * @dev We set the cost of renting our genes
921      */
922     function setSireStop(uint32 _rabbitid) public returns(bool) {
923         require(isPauseSave());
924         require(rabbitToOwner[_rabbitid] == msg.sender);
925      //   require(rabbits[(_rabbitid-1)].role == 0);
926 
927         rabbits[(_rabbitid-1)].role = 0;
928         rabbitSirePrice[_rabbitid] = 0;
929         deleteSire(_rabbitid);
930         return true;
931     }
932     
933       function deleteSire(uint32 _tokenId) internal { 
934         uint gen = rabbits[(_tokenId-1)].genome;
935 
936         uint count = sireGenom[gen].length;
937         for (uint i = 0; i < count; i++) {
938             if(sireGenom[gen][i] == _tokenId)
939             { 
940                 delete sireGenom[gen][i];
941                 if(count > 0 && count != (i-1)){
942                     sireGenom[gen][i] = sireGenom[gen][(count-1)];
943                     delete sireGenom[gen][(count-1)];
944                 } 
945                 sireGenom[gen].length--;
946                 emit ChengeSex(_tokenId, false, 0);
947                 return;
948             } 
949         }
950     } 
951 
952     function getMoney(uint _value) public onlyOwner {
953         require(address(this).balance >= _value);
954         ownerMoney.transfer(_value);
955     }
956 }