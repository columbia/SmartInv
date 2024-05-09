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
263         _infoUrlPrefix = "https://chibigame.io/chibis.php?idj=";
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
338     * @dev Set url prefix
339     */
340     function setInfoUrlPrefix(string prefix) external contract_onlyOwner returns (string infoUrlPrefix) {
341         _infoUrlPrefix = prefix;
342         return _infoUrlPrefix;
343     }
344     
345     /**
346     * @dev Set infoUrl of chibi
347     */
348     function changeInfoUrl(uint _tokenId, string _infoUrl) public returns (bool success) {
349         if (ownerOf(_tokenId) != msg.sender && msg.sender != contract_owner) revert();
350         chibies[_tokenId].infoUrl = _infoUrl;
351         return true;
352     }
353 
354     /**
355     * @dev Connect to Founder contract so user can pay in FCF
356     */
357     function setFcfContractAddress(address _address) external contract_onlyOwner returns (bool success) {
358         fcfContract = FcfInterface(_address);
359         return true;
360     }
361 
362     /**
363     * @dev Connect to Battle contract
364     */
365     function setBattleContractAddress(address _address) external contract_onlyOwner returns (bool success) {
366         battleContract = BattleInterface(_address);
367         battleContractAddress = _address;
368         return true;
369     }
370     
371     /**
372     * @dev Connect to Battle contract
373     */
374     function setBattleRemoveContractAddress(address _address) external contract_onlyOwner returns (bool success) {
375         battleRemoveContractAddress = _address;
376         return true;
377     }
378 
379     /**
380     * @dev Rename a Chibi
381     * @param _tokenId ID of the Chibi
382     * @param _name Name of the Chibi
383     */
384     function renameChibi(uint _tokenId, string _name) public returns (bool success){
385         require(ownerOf(_tokenId) == msg.sender);
386 
387         chibies[_tokenId].nameChibi = _name;
388         return true;
389     }
390 
391     /**
392      * @dev Has chibi necromancer trait?
393      * @param _tokenId ID of the chibi
394      */
395     function isNecromancer(uint _tokenId) public view returns (bool) {
396         for (uint i=10; i<13; i++) {
397             if (chibies[_tokenId].dna[i] == 1000) {
398                 return true;
399             }
400         }
401         return false;
402     }
403 
404     /**
405     * @dev buy Chibis with Founders
406     */
407     function buyChibiWithFcf(string _name, string _battleRoar, uint8 _region, uint _seed) public returns (bool success) {
408         // must own at least 1 FCF, only entire FCF can be swapped for Chibis
409         require(fcfContract.balanceOf(msg.sender) >= 1 * 10 ** 18);
410         require(fcfPaused == false);
411         // prevent hack
412         uint fcfBefore = fcfContract.balanceOf(address(this));
413         // user must approved Founders contract to take tokens from account
414         // oh my, this will need a tutorial video
415         // always only take 1 Founder at a time
416         if (fcfContract.transferFrom(msg.sender, this, 1 * 10 ** 18)) {
417             _mint(_name, _battleRoar, _region, _seed, true, 0);
418         }
419         // prevent hacking
420         assert(fcfBefore == fcfContract.balanceOf(address(this)) - 1 * 10 ** 18);
421         return true;
422     }
423 
424     /**
425     * @dev Put Chibi up for fusion, this will not destroy your Chibi. Only adults can fuse.
426     * @param _tokenId Id of Chibi token that is for fusion
427     * @param _price Price for the chibi in wei
428     */
429     function setChibiForFusion(uint _tokenId, uint _price) public returns (bool success) {
430         require(ownerOf(_tokenId) == msg.sender);
431         require(_price >= priceFusionChibi);
432         require(chibies[_tokenId].adult <= now);
433         require(chibies[_tokenId].exhausted <= now);
434         require(chibies[_tokenId].forFusion == false);
435         require(battleContract.isDead(_tokenId) == false);
436 
437         chibies[_tokenId].forFusion = true;
438         chibies[_tokenId].fusionPrice = _price;
439 
440         emit ChibiForFusion(_tokenId, _price);
441         return true;
442     }
443 
444     function cancelChibiForFusion(uint _tokenId) public returns (bool success) {
445         if (ownerOf(_tokenId) != msg.sender && msg.sender != address(battleRemoveContractAddress)) {
446             revert();
447         }
448         require(chibies[_tokenId].forFusion == true);
449         
450         chibies[_tokenId].forFusion = false;
451         
452         emit ChibiForFusionCancelled(_tokenId);
453             
454     return false;
455     }
456     
457 
458  
459     /**
460     * @dev Connect to gene contract. That way we can update that contract and add more fighters.
461     */
462     function setGeneContractAddress(address _address) external contract_onlyOwner returns (bool success) {
463         geneContract = GeneInterface(_address);
464         return true;
465     }
466  
467     /**
468     * @dev Fusions cost too much so they are here
469     * @return All the fusions (babies) of tokenId
470     */
471     function queryFusionData(uint _tokenId) public view returns (
472         uint256[] fusions,
473         bool forFusion,
474         uint256 costFusion,
475         uint256 adult,
476         uint exhausted
477         ) {
478         return (
479         chibies[_tokenId].fusions,
480         chibies[_tokenId].forFusion,
481         chibies[_tokenId].fusionPrice,
482         chibies[_tokenId].adult,
483         chibies[_tokenId].exhausted
484         );
485     }
486     
487     /**
488     * @dev Minimal query for battle contract
489     * @return If for fusion
490     */
491     function queryFusionData_ext(uint _tokenId) public view returns (
492         bool forFusion,
493         uint fusionPrice
494         ) {
495         return (
496         chibies[_tokenId].forFusion,
497         chibies[_tokenId].fusionPrice
498         );
499     }
500  
501     /**
502     * @dev Triggers a Chibi event to get some data of token
503     * @return various
504     */
505     function queryChibi(uint _tokenId) public view returns (
506         string nameChibi,
507         string infoUrl,
508         uint16[13] dna,
509         uint256 father,
510         uint256 mother,
511         uint gen,
512         uint adult
513         ) {
514         return (
515         chibies[_tokenId].nameChibi,
516         chibies[_tokenId].infoUrl,
517         chibies[_tokenId].dna,
518         chibies[_tokenId].father,
519         chibies[_tokenId].mother,
520         chibies[_tokenId].gen,
521         chibies[_tokenId].adult
522         );
523     }
524 
525     /**
526     * @dev Triggers a Chibi event getting some additional data
527     * @return various
528     */
529     function queryChibiAdd(uint _tokenId) public view returns (
530         address owner,
531         bool founder
532         ) {
533         return (
534         chibies[_tokenId].owner,
535         chibies[_tokenId].founder
536         );
537     }
538     // exhaust after battle
539     function exhaustBattle(uint _tokenId) internal view returns (uint) {
540         uint _exhaust = 0;
541         
542         for (uint i=10; i<13; i++) {
543             if (chibies[_tokenId].dna[i] == 1) {
544                 _exhaust += (exhaustionTime * 3);
545             }
546             if (chibies[_tokenId].dna[i] == 3) {
547                 _exhaust += exhaustionTime.div(2);
548             }
549         }
550         
551         _exhaust = geneContract.exhaustAfterBattle(chibies[_tokenId].gen, _exhaust);
552 
553         return _exhaust;
554     }
555     // exhaust after fusion
556     function exhaustFusion(uint _tokenId) internal returns (uint) {
557         uint _exhaust = 0;
558         
559         uint counter = chibies[_tokenId].dna[9];
560         // set dna here, that way boni still apply but not infinite fusions possible
561         // max value 9999
562         if (chibies[_tokenId].dna[9] < 9999) chibies[_tokenId].dna[9]++;
563         
564         for (uint i=10; i<13; i++) {
565             if (chibies[_tokenId].dna[i] == 2) {
566                 counter = counter.sub(1);
567             }
568             if (chibies[_tokenId].dna[i] == 4) {
569                 counter++;
570             }
571         }
572 
573         _exhaust = geneContract.exhaustAfterFusion(chibies[_tokenId].gen, counter, exhaustionTime);
574         
575         return _exhaust;
576     }
577     /** 
578      * @dev Exhaust Chibis after battle
579      */
580     function exhaustChibis(uint _tokenId1, uint _tokenId2) public returns (bool success) {
581         require(msg.sender == battleContractAddress);
582         
583         chibies[_tokenId1].exhausted = now.add(exhaustBattle(_tokenId1));
584         chibies[_tokenId2].exhausted = now.add(exhaustBattle(_tokenId2)); 
585         
586         return true;
587     }
588     
589     /**
590      * @dev Split traits between father and mother and leave the random at the _tokenId2
591      */
592     function traits(uint16[13] memory genes, uint _seed, uint _fatherId, uint _motherId) internal view returns (uint16[13] memory) {
593     
594         uint _switch = uint136(keccak256(_seed, block.coinbase, block.timestamp)) % 5;
595         
596         if (_switch == 0) {
597             genes[10] = chibies[_fatherId].dna[10];
598             genes[11] = chibies[_motherId].dna[11];
599         }
600         if (_switch == 1) {
601             genes[10] = chibies[_motherId].dna[10];
602             genes[11] = chibies[_fatherId].dna[11];
603         }
604         if (_switch == 2) {
605             genes[10] = chibies[_fatherId].dna[10];
606             genes[11] = chibies[_fatherId].dna[11];
607         }
608         if (_switch == 3) {
609             genes[10] = chibies[_motherId].dna[10];
610             genes[11] = chibies[_motherId].dna[11];
611         }
612         
613         return genes;
614         
615     }
616     
617     /**
618     * @dev The fusion chamber combines both dnas and adds a generation.
619     */
620     function fusionChibis(uint _fatherId, uint _motherId, uint _seed, string _name, string _battleRoar, uint8 _region) payable public returns (bool success) {
621         require(fusionPaused == false);
622         require(ownerOf(_fatherId) == msg.sender);
623         require(ownerOf(_motherId) != msg.sender);
624         require(chibies[_fatherId].adult <= now);
625         require(chibies[_fatherId].exhausted <= now);
626         require(chibies[_motherId].adult <= now);
627         require(chibies[_motherId].exhausted <= now);
628         require(chibies[_motherId].forFusion == true);
629         require(chibies[_motherId].fusionPrice == msg.value);
630         // exhaust father and mother
631         chibies[_motherId].forFusion = false;
632         chibies[_motherId].exhausted = now.add(exhaustFusion(_motherId));
633         chibies[_fatherId].exhausted = now.add(exhaustFusion(_fatherId));
634         
635         uint _gen = 0;
636         if (chibies[_fatherId].gen >= chibies[_motherId].gen) {
637             _gen = chibies[_fatherId].gen.add(1);
638         } else {
639             _gen = chibies[_motherId].gen.add(1);
640         }
641         // fusion chamber here we come
642         uint16[13] memory dna = traits(geneContract.splitGenes(address(this), _seed, uniqueCounter+1), _seed, _fatherId, _motherId);
643         
644         // new Chibi is born!
645         addToken(msg.sender, uniqueCounter);
646 
647         // father and mother get the chibi in their fusion list
648         chibies[_fatherId].fusions.push(uniqueCounter);
649         // only add if mother different than father, otherwise double entry
650         if (_fatherId != _motherId) {
651             chibies[_motherId].fusions.push(uniqueCounter);
652         }
653         
654         // baby Chibi won't have fusions
655         uint[] memory _fusions;
656         
657         // baby Chibis can't be fused
658         chibies.push(Chibi(
659             msg.sender,
660             false,
661             _name, 
662             dna,
663             _fatherId,
664             _motherId,
665             _gen,
666             _fusions,
667             false,
668             priceFusionChibi,
669             0,
670             now.add(adultTime.mul((_gen.mul(_gen)).add(1))),
671             strConcat(_infoUrlPrefix, uint2str(uniqueCounter))
672         ));
673         
674         // fires chibi created event
675         emit ChibiCreated(
676             uniqueCounter,
677             chibies[uniqueCounter].owner,
678             chibies[uniqueCounter].founder,
679             chibies[uniqueCounter].nameChibi,
680             chibies[uniqueCounter].dna, 
681             chibies[uniqueCounter].father, 
682             chibies[uniqueCounter].mother, 
683             chibies[uniqueCounter].gen,
684             chibies[uniqueCounter].adult,
685             chibies[uniqueCounter].infoUrl
686         );
687 
688         // send transfer event
689         emit Transfer(0x0, msg.sender, uniqueCounter);
690         
691         // create Warrior
692         if (battleContract.addWarrior(address(this), uniqueCounter, _region, _battleRoar) == false) revert();
693         
694         uniqueCounter ++;
695         // transfer money to seller minus our share, remain stays in contract
696         uint256 amount = msg.value / 100 * comission;
697         chibies[_motherId].owner.transfer(amount);
698         return true;
699  }
700 
701     /**
702     * @dev Guarantees msg.sender is owner of the given token
703     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
704     */
705     modifier onlyOwnerOf(uint256 _tokenId) {
706         require(ownerOf(_tokenId) == msg.sender);
707         _;
708     }
709  
710     /**
711     * @dev Gets the total amount of tokens stored by the contract
712     * @return uint256 representing the total amount of tokens
713     */
714     function totalSupply() public view returns (uint256) {
715         return totalTokens;
716     }
717  
718     /**
719     * @dev Gets the balance of the specified address
720     * @param _owner address to query the balance of
721     * @return uint256 representing the amount owned by the passed address
722     */
723     function balanceOf(address _owner) public view returns (uint256) {
724         return ownedTokens[_owner].length;
725     }
726  
727     /**
728     * @dev Gets the list of tokens owned by a given address
729     * @param _owner address to query the tokens of
730     * @return uint256[] representing the list of tokens owned by the passed address
731     */
732     function tokensOf(address _owner) public view returns (uint256[]) {
733         return ownedTokens[_owner];
734     }
735  
736     /**
737     * @dev Gets the owner of the specified token ID
738     * @param _tokenId uint256 ID of the token to query the owner of
739     * @return owner address currently marked as the owner of the given token ID
740     */
741     function ownerOf(uint256 _tokenId) public view returns (address) {
742         address owner = tokenOwner[_tokenId];
743         require(owner != address(0));
744         return owner;
745     }
746  
747     /**
748     * @dev Gets the approved address to take ownership of a given token ID
749     * @param _tokenId uint256 ID of the token to query the approval of
750     * @return address currently approved to take ownership of the given token ID
751     */
752     function approvedFor(uint256 _tokenId) public view returns (address) {
753         return tokenApprovals[_tokenId];
754     }
755  
756     /**
757     * @dev Transfers the ownership of a given token ID to another address
758     * @param _to address to receive the ownership of the given token ID
759     * @param _tokenId uint256 ID of the token to be transferred
760     */
761     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
762         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
763     }
764  
765     /**
766     * @dev Approves another address to claim for the ownership of the given token ID
767     * @param _to address to be approved for the given token ID
768     * @param _tokenId uint256 ID of the token to be approved
769     */
770     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
771         address owner = ownerOf(_tokenId);
772         require(_to != owner);
773         if (approvedFor(_tokenId) != 0 || _to != 0) {
774             tokenApprovals[_tokenId] = _to;
775             emit Approval(owner, _to, _tokenId);
776         }
777     }
778  
779     /**
780     * @dev Claims the ownership of a given token ID
781     * @param _tokenId uint256 ID of the token being claimed by the msg.sender
782     */
783     function takeOwnership(uint256 _tokenId) public {
784         require(isApprovedFor(msg.sender, _tokenId));
785         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
786     }
787     
788     function mintSpecial(string _name, string _battleRoar, uint8 _region, uint _seed, uint _specialId) public contract_onlyOwner returns (bool success) {
789         // name can be empty
790         _mint(_name, _battleRoar, _region, _seed, false, _specialId);
791         return true;
792     }
793     
794     /**
795     * @dev Mint token function
796     * @param _name name of the Chibi
797     */
798     function _mint(string _name, string _battleRoar, uint8 _region, uint _seed, bool _founder, uint _specialId) internal {
799         require(msg.sender != address(0));
800         addToken(msg.sender, uniqueCounter);
801     
802         // creates a gen0 Chibi, no father, mother, gen0
803         uint16[13] memory dna;
804         
805         if (_specialId > 0) {
806             dna  = geneContract.createGenes(address(this), _seed, _founder, uniqueCounter, _specialId);
807         } else {
808             dna = geneContract.createGenes(address(this), _seed, _founder, uniqueCounter, 0);
809         }
810 
811         uint[] memory _fusions;
812 
813         chibies.push(Chibi(
814             msg.sender,
815             _founder,
816             _name, 
817             dna,
818             0,
819             0,
820             0,
821             _fusions,
822             false,
823             priceFusionChibi,
824             0,
825             now.add(adultTime),
826             strConcat(_infoUrlPrefix, uint2str(uniqueCounter))
827         ));
828         
829         // send transfer event
830         emit Transfer(0x0, msg.sender, uniqueCounter);
831         
832         // create Warrior
833         if (battleContract.addWarrior(address(this), uniqueCounter, _region, _battleRoar) == false) revert();
834         
835         // fires chibi created event
836         emit ChibiCreated(
837             uniqueCounter,
838             chibies[uniqueCounter].owner,
839             chibies[uniqueCounter].founder,
840             chibies[uniqueCounter].nameChibi,
841             chibies[uniqueCounter].dna, 
842             chibies[uniqueCounter].father, 
843             chibies[uniqueCounter].mother, 
844             chibies[uniqueCounter].gen,
845             chibies[uniqueCounter].adult,
846             chibies[uniqueCounter].infoUrl
847         );
848         
849         uniqueCounter ++;
850     }
851  
852     /**
853     * @dev buy gen0 chibis
854     * @param _name name of the Chibi
855     */
856     function buyGEN0Chibi(string _name, string _battleRoar, uint8 _region, uint _seed) payable public returns (bool success) {
857         require(paused == false);
858         // cost at least 100 wei
859         require(msg.value == priceChibi);
860         // name can be empty
861         _mint(_name, _battleRoar, _region, _seed, false, 0);
862         return true;
863     }
864  
865     /**
866     * @dev set default sale price of Chibies
867     * @param _priceChibi price of 1 Chibi in Wei
868     */
869     function setChibiGEN0Price(uint _priceChibi) public contract_onlyOwner returns (bool success) {
870         priceChibi = _priceChibi;
871         return true;
872     }
873  
874     /**
875     * @dev Tells whether the msg.sender is approved for the given token ID or not
876     * This function is not private so it can be extended in further implementations like the operatable ERC721
877     * @param _owner address of the owner to query the approval of
878     * @param _tokenId uint256 ID of the token to query the approval of
879     * @return bool whether the msg.sender is approved for the given token ID or not
880     */
881     function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
882         return approvedFor(_tokenId) == _owner;
883     }
884  
885     /**
886     * @dev Internal function to clear current approval and transfer the ownership of a given token ID
887     * @param _from address which you want to send tokens from
888     * @param _to address which you want to transfer the token to
889     * @param _tokenId uint256 ID of the token to be transferred
890     */
891     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
892         require(_to != address(0));
893         require(_to != ownerOf(_tokenId));
894         require(ownerOf(_tokenId) == _from);
895 
896         clearApproval(_from, _tokenId);
897         removeToken(_from, _tokenId);
898         addToken(_to, _tokenId);
899         
900         // Chibbi code
901         chibies[_tokenId].owner = _to;
902         chibies[_tokenId].forFusion = false;
903         
904         emit Transfer(_from, _to, _tokenId);
905     }
906  
907     /**
908     * @dev Internal function to clear current approval of a given token ID
909     * @param _tokenId uint256 ID of the token to be transferred
910     */
911     function clearApproval(address _owner, uint256 _tokenId) private {
912         require(ownerOf(_tokenId) == _owner);
913         tokenApprovals[_tokenId] = 0;
914         emit Approval(_owner, 0, _tokenId);
915     }
916  
917     /**
918     * @dev Internal function to add a token ID to the list of a given address
919     * @param _to address representing the new owner of the given token ID
920     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
921     */
922     function addToken(address _to, uint256 _tokenId) private {
923         require(tokenOwner[_tokenId] == address(0));
924         tokenOwner[_tokenId] = _to;
925         uint256 length = balanceOf(_to);
926         ownedTokens[_to].push(_tokenId);
927         ownedTokensIndex[_tokenId] = length;
928         totalTokens++;
929     }
930  
931     /**
932     * @dev Internal function to remove a token ID from the list of a given address
933     * @param _from address representing the previous owner of the given token ID
934     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
935     */
936     function removeToken(address _from, uint256 _tokenId) private {
937         require(ownerOf(_tokenId) == _from);
938         
939         uint256 tokenIndex = ownedTokensIndex[_tokenId];
940         uint256 lastTokenIndex = balanceOf(_from).sub(1);
941         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
942         
943         tokenOwner[_tokenId] = 0;
944         ownedTokens[_from][tokenIndex] = lastToken;
945         ownedTokens[_from][lastTokenIndex] = 0;
946         // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
947         // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
948         // the lastToken to the first position, and then dropping the element placed in the last position of the list
949         
950         ownedTokens[_from].length--;
951         ownedTokensIndex[_tokenId] = 0;
952         ownedTokensIndex[lastToken] = tokenIndex;
953         totalTokens = totalTokens.sub(1);
954     }
955 
956     /**
957     * @dev Send Ether to owner
958     * @param _address Receiving address
959     * @param amount Amount in WEI to send
960     **/
961     function weiToOwner(address _address, uint amount) public contract_onlyOwner {
962         require(amount <= address(this).balance);
963         _address.transfer(amount);
964     }
965     
966     /**
967     * @dev Return the infoUrl of Chibi
968     * @param _tokenId infoUrl of _tokenId
969     **/
970     function tokenMetadata(uint256 _tokenId) constant public returns (string infoUrl) {
971         return chibies[_tokenId].infoUrl;
972     }
973     
974     function tokenURI(uint256 _tokenId) public view returns (string) {
975         return chibies[_tokenId].infoUrl;
976     }
977 
978     //
979     // some helpful functions
980     // https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
981     //
982     function uint2str(uint i) internal pure returns (string) {
983         if (i == 0) return "0";
984         uint j = i;
985         uint len;
986         while (j != 0){
987             len++;
988             j /= 10;
989         }
990         bytes memory bstr = new bytes(len);
991         uint k = len - 1;
992         while (i != 0){
993             bstr[k--] = byte(48 + i % 10);
994             i /= 10;
995         }
996         return string(bstr);
997     }
998 
999     function strConcat(string _a, string _b) internal pure returns (string) {
1000         bytes memory _ba = bytes(_a);
1001         bytes memory _bb = bytes(_b);
1002 
1003         string memory ab = new string(_ba.length + _bb.length);
1004         bytes memory bab = bytes(ab);
1005         uint k = 0;
1006         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1007         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1008         return string(bab);
1009         }
1010     }