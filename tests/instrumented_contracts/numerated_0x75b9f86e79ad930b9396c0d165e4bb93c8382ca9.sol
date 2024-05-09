1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // Contract owner and transfer functions
5 // just in case someone wants to get my bacon
6 // ----------------------------------------------------------------------------
7 contract ContractOwned {
8     address public contract_owner;
9     address public contract_newOwner;
10 
11     event OwnershipTransferred(address indexed _from, address indexed _to);
12 
13     constructor() public {
14         contract_owner = msg.sender;
15     }
16 
17     modifier contract_onlyOwner {
18         require(msg.sender == contract_owner);
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) public contract_onlyOwner {
23         contract_newOwner = _newOwner;
24     }
25 
26     function acceptOwnership() public {
27         require(msg.sender == contract_newOwner);
28         emit OwnershipTransferred(contract_owner, contract_newOwner);
29         contract_owner = contract_newOwner;
30         contract_newOwner = address(0);
31     }
32 }
33 
34 
35 /**
36 * @title SafeMath
37 * @dev Math operations with safety checks that throw on error
38 */
39 library SafeMath {
40 
41     /**
42     * @dev Multiplies two numbers, throws on overflow.
43     */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         assert(c / a == b);
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers, truncating the quotient.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     /**
64     * @dev Substracts two numbers, returns 0 if it would go into minus range.
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (b >= a) {
68             return 0;
69         }
70         return a - b;
71     }
72 
73     /**
74     * @dev Adds two numbers, throws on overflow.
75     */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         assert(c >= a);
79         return c;
80     }
81 }
82 
83 /** 
84 * ERC721 compatibility from
85 * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC721/ERC721Token.sol
86 * plus our magic sauce
87 */ 
88 
89 /**
90 * @title Custom CustomEvents
91 * @dev some custom events specific to this contract
92 */
93 contract CustomEvents {
94     event ChibiCreated(uint tokenId, address indexed _owner, bool founder, string _name, uint16[13] dna, uint father, uint mother, uint gen, uint adult, string infoUrl);
95     event ChibiForFusion(uint tokenId, uint price);
96     event ChibiForFusionCancelled(uint tokenId);
97     event WarriorCreated(uint tokenId, string battleRoar);
98 }
99 
100 /**
101 * @title ERC721 interface
102 * @dev see https://github.com/ethereum/eips/issues/721
103 */
104 contract ERC721 {
105     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
106     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
107     
108     function balanceOf(address _owner) public view returns (uint256 _balance);
109     function ownerOf(uint256 _tokenId) public view returns (address _owner);
110     function transfer(address _to, uint256 _tokenId) public;
111     function approve(address _to, uint256 _tokenId) public;
112     function takeOwnership(uint256 _tokenId) public;
113     function tokenMetadata(uint256 _tokenId) constant public returns (string infoUrl);
114     function tokenURI(uint256 _tokenId) public view returns (string);
115 }
116 
117 
118 // interacting with gene contract
119 contract GeneInterface {
120     // creates genes when bought directly on this contract, they will always be superb
121     // address, seed, founder, tokenId
122     function createGenes(address, uint, bool, uint, uint) external view returns (
123     uint16[13] genes
124 );
125  
126 // transfusion chamber, no one really knows what that crazy thing does
127 // except the scientists, but they giggle all day long
128 // address, seed, tokenId
129 function splitGenes(address, uint, uint) external view returns (
130     uint16[13] genes
131     );
132     function exhaustAfterFusion(uint _gen, uint _counter, uint _exhaustionTime) public pure returns (uint);
133     function exhaustAfterBattle(uint _gen, uint _exhaust) public pure returns (uint);
134         
135 }
136 
137 // interacting with fcf contract
138 contract FcfInterface {
139     function balanceOf(address) public pure returns (uint) {}
140     function transferFrom(address, address, uint) public pure returns (bool) {}
141 }
142 
143 // interacting with battle contract
144 contract BattleInterface {
145     function addWarrior(address, uint, uint8, string) pure public returns (bool) {}
146     function isDead(uint) public pure returns (bool) {}
147 }
148  
149 
150 /**
151  * @title ERC721Token
152  * Generic implementation for the required functionality of the ERC721 standard
153  */
154 contract ChibiFighters is ERC721, ContractOwned, CustomEvents {
155     using SafeMath for uint256;
156 
157     // Total amount of tokens
158     uint256 private totalTokens;
159 
160     // Mapping from token ID to owner
161     mapping (uint256 => address) private tokenOwner;
162 
163     // Mapping from token ID to approved address
164     mapping (uint256 => address) private tokenApprovals;
165 
166     // Mapping from owner to list of owned token IDs
167     mapping (address => uint256[]) private ownedTokens;
168 
169     // Mapping from token ID to index of the owner tokens list
170     mapping(uint256 => uint256) private ownedTokensIndex;
171 
172     // interfaces for other contracts, so updates are possible
173     GeneInterface geneContract;
174     FcfInterface fcfContract;
175     BattleInterface battleContract;
176     address battleContractAddress;
177 
178     // default price for 1 Chibi
179     uint public priceChibi;
180     // minimum price for fusion chibis
181     uint priceFusionChibi;
182 
183     // counter that keeps upping with each token
184     uint uniqueCounter;
185 
186     // time to become adult
187     uint adultTime;
188 
189     // recovery time after each fusion
190     uint exhaustionTime;
191     
192     // our comission
193     uint comission;
194     
195     // battleRemoveContractAddress to remove from array
196     address battleRemoveContractAddress;
197 
198     struct Chibi {
199         // address of current chibi owner
200         address owner;
201         // belongs to og
202         bool founder;
203         // name of the chibi, chibis need names
204         string nameChibi;
205         // the dna, specifies, bodyparts, etc.
206         // array is easier to decode, but we are not reinventing the wheel here
207         uint16[13] dna;
208         // originates from tokenIds, gen0s will return 0
209         // uint size only matters in structs
210         uint256 father;
211         uint256 mother;
212         // generations, gen0 is created from the incubator, they are pure
213         // but of course the funniest combos will come from the fusion chamber
214         uint gen;
215         // fusions, the beautiful fusion Chibis that came out of this one
216         uint256[] fusions;
217         // up for fusion?
218         bool forFusion;
219         // cost to fusion with this Chibi, can be set by player at will
220         uint256 fusionPrice;
221         // exhaustion after fusion
222         uint256 exhausted;
223         // block after which chibi is an adult 
224         uint256 adult;
225         // info url
226         string infoUrl;
227     }
228 
229     // the link to chibis website
230     string _infoUrlPrefix;
231 
232     Chibi[] public chibies;
233 
234     string public constant name = "Chibi Fighters";
235     string public constant symbol = "CBF";
236 
237     // pause function so fusion and minting can be paused for updates
238     bool paused;
239     bool fcfPaused;
240     bool fusionPaused; // needed so founder can fuse while game is paused
241 
242     /**
243     * @dev Run only once at contract creation
244     */
245     constructor() public {
246         // a helping counter to keep chibis unique
247         uniqueCounter = 0;
248         // inital price in wei
249         priceChibi = 100000000000000000;
250         // default price to allow fusion
251         priceFusionChibi = 10000000000000000;
252         // time to become adult
253         adultTime = 2 hours;
254         //exhaustionTime = 3 hours;
255         exhaustionTime = 1 hours;
256         // start the contract paused
257         paused = true;
258         fcfPaused = true;
259         fusionPaused = true;
260         // set comission percentage 100-90 = 10%
261         comission = 90; 
262 
263         _infoUrlPrefix = "http://chibigame.io/chibis.php?idj=";
264     }
265     
266     /**
267     * @dev Set Comission rate 100-x = %
268     * @param _comission Rate inverted
269     */
270     function setComission(uint _comission) public contract_onlyOwner returns(bool success) {
271         comission = _comission;
272         return true;
273     }
274     
275     /**
276     * @dev Set minimum price for fusion Chibis in Wei
277     */
278     function setMinimumPriceFusion(uint _price) public contract_onlyOwner returns(bool success) {
279         priceFusionChibi = _price;
280         return true;
281     }
282     
283     /**
284     * @dev Set time until Chibi is considered adult
285     * @param _adultTimeSecs Set time in seconds
286     */
287     function setAdultTime(uint _adultTimeSecs) public contract_onlyOwner returns(bool success) {
288         adultTime = _adultTimeSecs;
289         return true;
290     }
291 
292     /**
293     * @dev Fusion Chamber Cool down
294     * @param _exhaustionTime Set time in seconds
295     */
296     function setExhaustionTime(uint _exhaustionTime) public contract_onlyOwner returns(bool success) {
297         exhaustionTime = _exhaustionTime;
298         return true;
299     }
300     
301     /**
302     * @dev Set game state paused for updates, pauses the entire creation
303     * @param _setPaused Boolean sets the game paused or not
304     */
305     function setGameState(bool _setPaused) public contract_onlyOwner returns(bool _paused) {
306         paused = _setPaused;
307         fcfPaused = _setPaused;
308         fusionPaused = _setPaused;
309         return paused;
310     }
311     
312     /**
313     * @dev Set game state for fcf tokens only, so Founder can get Chibis pre launch
314     * @param _setPaused Boolean sets the game paused or not
315     */
316     function setGameStateFCF(bool _setPaused) public contract_onlyOwner returns(bool _pausedFCF) {
317         fcfPaused = _setPaused;
318         return fcfPaused;
319     }
320     
321     /**
322     * @dev unpause Fusions so Founder can Fuse
323     * @param _setPaused Boolean sets the game paused or not
324     */
325     function setGameStateFusion(bool _setPaused) public contract_onlyOwner returns(bool _pausedFusions) {
326         fusionPaused = _setPaused;
327         return fusionPaused;
328     }
329 
330     /**
331     * @dev Query game state. Paused (True) or not?
332     */
333     function getGameState() public constant returns(bool _paused) {
334         return paused;
335     }
336 
337     /**
338     * @dev Set url prefix, of course that won`t change the existing Chibi urls on chain
339     */
340     function setInfoUrlPrefix(string prefix) external contract_onlyOwner returns (bool success) {
341         _infoUrlPrefix = prefix;
342         return true;
343     }
344 
345     /**
346     * @dev Connect to Founder contract so user can pay in FCF
347     */
348     function setFcfContractAddress(address _address) external contract_onlyOwner returns (bool success) {
349         fcfContract = FcfInterface(_address);
350         return true;
351     }
352 
353     /**
354     * @dev Connect to Battle contract
355     */
356     function setBattleContractAddress(address _address) external contract_onlyOwner returns (bool success) {
357         battleContract = BattleInterface(_address);
358         battleContractAddress = _address;
359         return true;
360     }
361     
362     /**
363     * @dev Connect to Battle contract
364     */
365     function setBattleRemoveContractAddress(address _address) external contract_onlyOwner returns (bool success) {
366         battleRemoveContractAddress = _address;
367         return true;
368     }
369 
370     /**
371     * @dev Rename a Chibi
372     * @param _tokenId ID of the Chibi
373     * @param _name Name of the Chibi
374     */
375     function renameChibi(uint _tokenId, string _name) public returns (bool success){
376         require(ownerOf(_tokenId) == msg.sender);
377 
378         chibies[_tokenId].nameChibi = _name;
379         return true;
380     }
381 
382     /**
383      * @dev Has chibi necromancer trait?
384      * @param _tokenId ID of the chibi
385      */
386     function isNecromancer(uint _tokenId) public view returns (bool) {
387         for (uint i=10; i<13; i++) {
388             if (chibies[_tokenId].dna[i] == 1000) {
389                 return true;
390             }
391         }
392         return false;
393     }
394 
395     /**
396     * @dev buy Chibis with Founders
397     */
398     function buyChibiWithFcf(string _name, string _battleRoar, uint8 _region, uint _seed) public returns (bool success) {
399         // must own at least 1 FCF, only entire FCF can be swapped for Chibis
400         require(fcfContract.balanceOf(msg.sender) >= 1 * 10 ** 18);
401         require(fcfPaused == false);
402         // prevent hack
403         uint fcfBefore = fcfContract.balanceOf(address(this));
404         // user must approved Founders contract to take tokens from account
405         // oh my, this will need a tutorial video
406         // always only take 1 Founder at a time
407         if (fcfContract.transferFrom(msg.sender, this, 1 * 10 ** 18)) {
408             _mint(_name, _battleRoar, _region, _seed, true, 0);
409         }
410         // prevent hacking
411         assert(fcfBefore == fcfContract.balanceOf(address(this)) - 1 * 10 ** 18);
412         return true;
413     }
414 
415     /**
416     * @dev Put Chibi up for fusion, this will not destroy your Chibi. Only adults can fuse.
417     * @param _tokenId Id of Chibi token that is for fusion
418     * @param _price Price for the chibi in wei
419     */
420     function setChibiForFusion(uint _tokenId, uint _price) public returns (bool success) {
421         require(ownerOf(_tokenId) == msg.sender);
422         require(_price >= priceFusionChibi);
423         require(chibies[_tokenId].adult <= now);
424         require(chibies[_tokenId].exhausted <= now);
425         require(chibies[_tokenId].forFusion == false);
426         require(battleContract.isDead(_tokenId) == false);
427 
428         chibies[_tokenId].forFusion = true;
429         chibies[_tokenId].fusionPrice = _price;
430 
431         emit ChibiForFusion(_tokenId, _price);
432         return true;
433     }
434 
435     function cancelChibiForFusion(uint _tokenId) public returns (bool success) {
436         if (ownerOf(_tokenId) != msg.sender && msg.sender != address(battleRemoveContractAddress)) {
437             revert();
438         }
439         require(chibies[_tokenId].forFusion == true);
440         
441         chibies[_tokenId].forFusion = false;
442         
443         emit ChibiForFusionCancelled(_tokenId);
444             
445     return false;
446     }
447     
448 
449  
450     /**
451     * @dev Connect to gene contract. That way we can update that contract and add more fighters.
452     */
453     function setGeneContractAddress(address _address) external contract_onlyOwner returns (bool success) {
454         geneContract = GeneInterface(_address);
455         return true;
456     }
457  
458     /**
459     * @dev Fusions cost too much so they are here
460     * @return All the fusions (babies) of tokenId
461     */
462     function queryFusionData(uint _tokenId) public view returns (
463         uint256[] fusions,
464         bool forFusion,
465         uint256 costFusion,
466         uint256 adult,
467         uint exhausted
468         ) {
469         return (
470         chibies[_tokenId].fusions,
471         chibies[_tokenId].forFusion,
472         chibies[_tokenId].fusionPrice,
473         chibies[_tokenId].adult,
474         chibies[_tokenId].exhausted
475         );
476     }
477     
478     /**
479     * @dev Minimal query for battle contract
480     * @return If for fusion
481     */
482     function queryFusionData_ext(uint _tokenId) public view returns (
483         bool forFusion,
484         uint fusionPrice
485         ) {
486         return (
487         chibies[_tokenId].forFusion,
488         chibies[_tokenId].fusionPrice
489         );
490     }
491  
492     /**
493     * @dev Triggers a Chibi event to get some data of token
494     * @return various
495     */
496     function queryChibi(uint _tokenId) public view returns (
497         string nameChibi,
498         string infoUrl,
499         uint16[13] dna,
500         uint256 father,
501         uint256 mother,
502         uint gen,
503         uint adult
504         ) {
505         return (
506         chibies[_tokenId].nameChibi,
507         chibies[_tokenId].infoUrl,
508         chibies[_tokenId].dna,
509         chibies[_tokenId].father,
510         chibies[_tokenId].mother,
511         chibies[_tokenId].gen,
512         chibies[_tokenId].adult
513         );
514     }
515 
516     /**
517     * @dev Triggers a Chibi event getting some additional data
518     * @return various
519     */
520     function queryChibiAdd(uint _tokenId) public view returns (
521         address owner,
522         bool founder
523         ) {
524         return (
525         chibies[_tokenId].owner,
526         chibies[_tokenId].founder
527         );
528     }
529     // exhaust after battle
530     function exhaustBattle(uint _tokenId) internal view returns (uint) {
531         uint _exhaust = 0;
532         
533         for (uint i=10; i<13; i++) {
534             if (chibies[_tokenId].dna[i] == 1) {
535                 _exhaust += (exhaustionTime * 3);
536             }
537             if (chibies[_tokenId].dna[i] == 3) {
538                 _exhaust += exhaustionTime.div(2);
539             }
540         }
541         
542         _exhaust = geneContract.exhaustAfterBattle(chibies[_tokenId].gen, _exhaust);
543 
544         return _exhaust;
545     }
546     // exhaust after fusion
547     function exhaustFusion(uint _tokenId) internal returns (uint) {
548         uint _exhaust = 0;
549         
550         uint counter = chibies[_tokenId].dna[9];
551         // set dna here, that way boni still apply but not infinite fusions possible
552         // max value 9999
553         if (chibies[_tokenId].dna[9] < 9999) chibies[_tokenId].dna[9]++;
554         
555         for (uint i=10; i<13; i++) {
556             if (chibies[_tokenId].dna[i] == 2) {
557                 counter = counter.sub(1);
558             }
559             if (chibies[_tokenId].dna[i] == 4) {
560                 counter++;
561             }
562         }
563 
564         _exhaust = geneContract.exhaustAfterFusion(chibies[_tokenId].gen, counter, exhaustionTime);
565         
566         return _exhaust;
567     }
568     /** 
569      * @dev Exhaust Chibis after battle
570      */
571     function exhaustChibis(uint _tokenId1, uint _tokenId2) public returns (bool success) {
572         require(msg.sender == battleContractAddress);
573         
574         chibies[_tokenId1].exhausted = now.add(exhaustBattle(_tokenId1));
575         chibies[_tokenId2].exhausted = now.add(exhaustBattle(_tokenId2)); 
576         
577         return true;
578     }
579     
580     /**
581      * @dev Split traits between father and mother and leave the random at the _tokenId2
582      */
583     function traits(uint16[13] memory genes, uint _seed, uint _fatherId, uint _motherId) internal view returns (uint16[13] memory) {
584     
585         uint _switch = uint136(keccak256(_seed, block.coinbase, block.timestamp)) % 5;
586         
587         if (_switch == 0) {
588             genes[10] = chibies[_fatherId].dna[10];
589             genes[11] = chibies[_motherId].dna[11];
590         }
591         if (_switch == 1) {
592             genes[10] = chibies[_motherId].dna[10];
593             genes[11] = chibies[_fatherId].dna[11];
594         }
595         if (_switch == 2) {
596             genes[10] = chibies[_fatherId].dna[10];
597             genes[11] = chibies[_fatherId].dna[11];
598         }
599         if (_switch == 3) {
600             genes[10] = chibies[_motherId].dna[10];
601             genes[11] = chibies[_motherId].dna[11];
602         }
603         
604         return genes;
605         
606     }
607     
608     /**
609     * @dev The fusion chamber combines both dnas and adds a generation.
610     */
611     function fusionChibis(uint _fatherId, uint _motherId, uint _seed, string _name, string _battleRoar, uint8 _region) payable public returns (bool success) {
612         require(fusionPaused == false);
613         require(ownerOf(_fatherId) == msg.sender);
614         require(ownerOf(_motherId) != msg.sender);
615         require(chibies[_fatherId].adult <= now);
616         require(chibies[_fatherId].exhausted <= now);
617         require(chibies[_motherId].adult <= now);
618         require(chibies[_motherId].exhausted <= now);
619         require(chibies[_motherId].forFusion == true);
620         require(chibies[_motherId].fusionPrice == msg.value);
621         // exhaust father and mother
622         chibies[_motherId].forFusion = false;
623         chibies[_motherId].exhausted = now.add(exhaustFusion(_motherId));
624         chibies[_fatherId].exhausted = now.add(exhaustFusion(_fatherId));
625         
626         uint _gen = 0;
627         if (chibies[_fatherId].gen >= chibies[_motherId].gen) {
628             _gen = chibies[_fatherId].gen.add(1);
629         } else {
630             _gen = chibies[_motherId].gen.add(1);
631         }
632         // fusion chamber here we come
633         uint16[13] memory dna = traits(geneContract.splitGenes(address(this), _seed, uniqueCounter+1), _seed, _fatherId, _motherId);
634         
635         // new Chibi is born!
636         addToken(msg.sender, uniqueCounter);
637 
638         // father and mother get the chibi in their fusion list
639         chibies[_fatherId].fusions.push(uniqueCounter);
640         // only add if mother different than father, otherwise double entry
641         if (_fatherId != _motherId) {
642             chibies[_motherId].fusions.push(uniqueCounter);
643         }
644         
645         // baby Chibi won't have fusions
646         uint[] memory _fusions;
647         
648         // baby Chibis can't be fused
649         chibies.push(Chibi(
650             msg.sender,
651             false,
652             _name, 
653             dna,
654             _fatherId,
655             _motherId,
656             _gen,
657             _fusions,
658             false,
659             priceFusionChibi,
660             0,
661             now.add(adultTime.mul((_gen.mul(_gen)).add(1))),
662             strConcat(_infoUrlPrefix, uint2str(uniqueCounter))
663         ));
664         
665         // fires chibi created event
666         emit ChibiCreated(
667             uniqueCounter,
668             chibies[uniqueCounter].owner,
669             chibies[uniqueCounter].founder,
670             chibies[uniqueCounter].nameChibi,
671             chibies[uniqueCounter].dna, 
672             chibies[uniqueCounter].father, 
673             chibies[uniqueCounter].mother, 
674             chibies[uniqueCounter].gen,
675             chibies[uniqueCounter].adult,
676             chibies[uniqueCounter].infoUrl
677         );
678 
679         // send transfer event
680         emit Transfer(0x0, msg.sender, uniqueCounter);
681         
682         // create Warrior
683         if (battleContract.addWarrior(address(this), uniqueCounter, _region, _battleRoar) == false) revert();
684         
685         uniqueCounter ++;
686         // transfer money to seller minus our share, remain stays in contract
687         uint256 amount = msg.value / 100 * comission;
688         chibies[_motherId].owner.transfer(amount);
689         return true;
690  }
691 
692     /**
693     * @dev Guarantees msg.sender is owner of the given token
694     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
695     */
696     modifier onlyOwnerOf(uint256 _tokenId) {
697         require(ownerOf(_tokenId) == msg.sender);
698         _;
699     }
700  
701     /**
702     * @dev Gets the total amount of tokens stored by the contract
703     * @return uint256 representing the total amount of tokens
704     */
705     function totalSupply() public view returns (uint256) {
706         return totalTokens;
707     }
708  
709     /**
710     * @dev Gets the balance of the specified address
711     * @param _owner address to query the balance of
712     * @return uint256 representing the amount owned by the passed address
713     */
714     function balanceOf(address _owner) public view returns (uint256) {
715         return ownedTokens[_owner].length;
716     }
717  
718     /**
719     * @dev Gets the list of tokens owned by a given address
720     * @param _owner address to query the tokens of
721     * @return uint256[] representing the list of tokens owned by the passed address
722     */
723     function tokensOf(address _owner) public view returns (uint256[]) {
724         return ownedTokens[_owner];
725     }
726  
727     /**
728     * @dev Gets the owner of the specified token ID
729     * @param _tokenId uint256 ID of the token to query the owner of
730     * @return owner address currently marked as the owner of the given token ID
731     */
732     function ownerOf(uint256 _tokenId) public view returns (address) {
733         address owner = tokenOwner[_tokenId];
734         require(owner != address(0));
735         return owner;
736     }
737  
738     /**
739     * @dev Gets the approved address to take ownership of a given token ID
740     * @param _tokenId uint256 ID of the token to query the approval of
741     * @return address currently approved to take ownership of the given token ID
742     */
743     function approvedFor(uint256 _tokenId) public view returns (address) {
744         return tokenApprovals[_tokenId];
745     }
746  
747     /**
748     * @dev Transfers the ownership of a given token ID to another address
749     * @param _to address to receive the ownership of the given token ID
750     * @param _tokenId uint256 ID of the token to be transferred
751     */
752     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
753         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
754     }
755  
756     /**
757     * @dev Approves another address to claim for the ownership of the given token ID
758     * @param _to address to be approved for the given token ID
759     * @param _tokenId uint256 ID of the token to be approved
760     */
761     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
762         address owner = ownerOf(_tokenId);
763         require(_to != owner);
764         if (approvedFor(_tokenId) != 0 || _to != 0) {
765             tokenApprovals[_tokenId] = _to;
766             emit Approval(owner, _to, _tokenId);
767         }
768     }
769  
770     /**
771     * @dev Claims the ownership of a given token ID
772     * @param _tokenId uint256 ID of the token being claimed by the msg.sender
773     */
774     function takeOwnership(uint256 _tokenId) public {
775         require(isApprovedFor(msg.sender, _tokenId));
776         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
777     }
778     
779     function mintSpecial(string _name, string _battleRoar, uint8 _region, uint _seed, uint _specialId) public contract_onlyOwner returns (bool success) {
780         // name can be empty
781         _mint(_name, _battleRoar, _region, _seed, false, _specialId);
782         return true;
783     }
784     
785     /**
786     * @dev Mint token function
787     * @param _name name of the Chibi
788     */
789     function _mint(string _name, string _battleRoar, uint8 _region, uint _seed, bool _founder, uint _specialId) internal {
790         require(msg.sender != address(0));
791         addToken(msg.sender, uniqueCounter);
792     
793         // creates a gen0 Chibi, no father, mother, gen0
794         uint16[13] memory dna;
795         
796         if (_specialId > 0) {
797             dna  = geneContract.createGenes(address(this), _seed, _founder, uniqueCounter, _specialId);
798         } else {
799             dna = geneContract.createGenes(address(this), _seed, _founder, uniqueCounter, 0);
800         }
801 
802         uint[] memory _fusions;
803 
804         chibies.push(Chibi(
805             msg.sender,
806             _founder,
807             _name, 
808             dna,
809             0,
810             0,
811             0,
812             _fusions,
813             false,
814             priceFusionChibi,
815             0,
816             now.add(adultTime),
817             strConcat(_infoUrlPrefix, uint2str(uniqueCounter))
818         ));
819         
820         // send transfer event
821         emit Transfer(0x0, msg.sender, uniqueCounter);
822         
823         // create Warrior
824         if (battleContract.addWarrior(address(this), uniqueCounter, _region, _battleRoar) == false) revert();
825         
826         // fires chibi created event
827         emit ChibiCreated(
828             uniqueCounter,
829             chibies[uniqueCounter].owner,
830             chibies[uniqueCounter].founder,
831             chibies[uniqueCounter].nameChibi,
832             chibies[uniqueCounter].dna, 
833             chibies[uniqueCounter].father, 
834             chibies[uniqueCounter].mother, 
835             chibies[uniqueCounter].gen,
836             chibies[uniqueCounter].adult,
837             chibies[uniqueCounter].infoUrl
838         );
839         
840         uniqueCounter ++;
841     }
842  
843     /**
844     * @dev buy gen0 chibis
845     * @param _name name of the Chibi
846     */
847     function buyGEN0Chibi(string _name, string _battleRoar, uint8 _region, uint _seed) payable public returns (bool success) {
848         require(paused == false);
849         // cost at least 100 wei
850         require(msg.value == priceChibi);
851         // name can be empty
852         _mint(_name, _battleRoar, _region, _seed, false, 0);
853         return true;
854     }
855  
856     /**
857     * @dev set default sale price of Chibies
858     * @param _priceChibi price of 1 Chibi in Wei
859     */
860     function setChibiGEN0Price(uint _priceChibi) public contract_onlyOwner returns (bool success) {
861         priceChibi = _priceChibi;
862         return true;
863     }
864  
865     /**
866     * @dev Tells whether the msg.sender is approved for the given token ID or not
867     * This function is not private so it can be extended in further implementations like the operatable ERC721
868     * @param _owner address of the owner to query the approval of
869     * @param _tokenId uint256 ID of the token to query the approval of
870     * @return bool whether the msg.sender is approved for the given token ID or not
871     */
872     function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
873         return approvedFor(_tokenId) == _owner;
874     }
875  
876     /**
877     * @dev Internal function to clear current approval and transfer the ownership of a given token ID
878     * @param _from address which you want to send tokens from
879     * @param _to address which you want to transfer the token to
880     * @param _tokenId uint256 ID of the token to be transferred
881     */
882     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
883         require(_to != address(0));
884         require(_to != ownerOf(_tokenId));
885         require(ownerOf(_tokenId) == _from);
886 
887         clearApproval(_from, _tokenId);
888         removeToken(_from, _tokenId);
889         addToken(_to, _tokenId);
890         
891         // Chibbi code
892         chibies[_tokenId].owner = _to;
893         chibies[_tokenId].forFusion = false;
894         
895         emit Transfer(_from, _to, _tokenId);
896     }
897  
898     /**
899     * @dev Internal function to clear current approval of a given token ID
900     * @param _tokenId uint256 ID of the token to be transferred
901     */
902     function clearApproval(address _owner, uint256 _tokenId) private {
903         require(ownerOf(_tokenId) == _owner);
904         tokenApprovals[_tokenId] = 0;
905         emit Approval(_owner, 0, _tokenId);
906     }
907  
908     /**
909     * @dev Internal function to add a token ID to the list of a given address
910     * @param _to address representing the new owner of the given token ID
911     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
912     */
913     function addToken(address _to, uint256 _tokenId) private {
914         require(tokenOwner[_tokenId] == address(0));
915         tokenOwner[_tokenId] = _to;
916         uint256 length = balanceOf(_to);
917         ownedTokens[_to].push(_tokenId);
918         ownedTokensIndex[_tokenId] = length;
919         totalTokens++;
920     }
921  
922     /**
923     * @dev Internal function to remove a token ID from the list of a given address
924     * @param _from address representing the previous owner of the given token ID
925     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
926     */
927     function removeToken(address _from, uint256 _tokenId) private {
928         require(ownerOf(_tokenId) == _from);
929         
930         uint256 tokenIndex = ownedTokensIndex[_tokenId];
931         uint256 lastTokenIndex = balanceOf(_from).sub(1);
932         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
933         
934         tokenOwner[_tokenId] = 0;
935         ownedTokens[_from][tokenIndex] = lastToken;
936         ownedTokens[_from][lastTokenIndex] = 0;
937         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
938         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
939         // the lastToken to the first position, and then dropping the element placed in the last position of the list
940         
941         ownedTokens[_from].length--;
942         ownedTokensIndex[_tokenId] = 0;
943         ownedTokensIndex[lastToken] = tokenIndex;
944         totalTokens = totalTokens.sub(1);
945     }
946 
947     /**
948     * @dev Send Ether to owner
949     * @param _address Receiving address
950     * @param amount Amount in WEI to send
951     **/
952     function weiToOwner(address _address, uint amount) public contract_onlyOwner {
953         require(amount <= address(this).balance);
954         _address.transfer(amount);
955     }
956     
957     /**
958     * @dev Return the infoUrl of Chibi
959     * @param _tokenId infoUrl of _tokenId
960     **/
961     function tokenMetadata(uint256 _tokenId) constant public returns (string infoUrl) {
962         return chibies[_tokenId].infoUrl;
963     }
964     
965     function tokenURI(uint256 _tokenId) public view returns (string) {
966         return chibies[_tokenId].infoUrl;
967     }
968 
969     //
970     // some helpful functions
971     // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
972     //
973     function uint2str(uint i) internal pure returns (string) {
974         if (i == 0) return "0";
975         uint j = i;
976         uint len;
977         while (j != 0){
978             len++;
979             j /= 10;
980         }
981         bytes memory bstr = new bytes(len);
982         uint k = len - 1;
983         while (i != 0){
984             bstr[k--] = byte(48 + i % 10);
985             i /= 10;
986         }
987         return string(bstr);
988     }
989 
990     function strConcat(string _a, string _b) internal pure returns (string) {
991         bytes memory _ba = bytes(_a);
992         bytes memory _bb = bytes(_b);
993 
994         string memory ab = new string(_ba.length + _bb.length);
995         bytes memory bab = bytes(ab);
996         uint k = 0;
997         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
998         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
999         return string(bab);
1000         }
1001     }