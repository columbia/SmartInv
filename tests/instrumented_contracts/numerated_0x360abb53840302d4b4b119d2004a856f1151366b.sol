1 pragma solidity ^0.4.18;
2 
3 contract ERC721 {
4     // Required methods
5     function totalSupply() public view returns (uint256 _totalSupply);
6     function balanceOf(address _owner) public view returns (uint256 _balance);
7     function ownerOf(uint _tokenId) external view returns (address _owner);
8     function approve(address _to, uint _tokenId) external;
9     function transferFrom(address _from, address _to, uint _tokenId) external;
10     function transfer(address _to, uint _tokenId) external;
11     
12     // Events
13     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
14     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
15 
16     // Optional functions
17     // function name() public view returns (string _name);
18     // function symbol() public view returns (string _symbol);
19     // function tokenOfOwnerByIndex(address _owner, uint _index) external view returns (uint _tokenId);
20     // function tokenMetadata(uint _tokenId) public view returns (string _infoUrl);
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     if (a == 0) {
34       return 0;
35     }
36     uint256 c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   /**
52   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     
76   address public owner;
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to transfer control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));      
100     owner = newOwner;
101   }
102 
103 }
104 
105 contract AccessControl is Ownable {
106     
107     bool public paused = false;
108     
109     modifier whenPaused {
110         require(paused);
111         _;
112     }
113     
114     modifier whenNotPaused() {
115         require(!paused);
116         _;
117     }
118     
119     function pause() external onlyOwner whenNotPaused {
120         paused = true;
121     }
122     
123     function unpause() external onlyOwner whenPaused {
124         paused = false;
125     }
126     
127 }
128 
129 contract DetailBase is AccessControl {
130     
131     event Create(address owner, uint256 detailId, uint256 dna);
132 
133     event Transfer(address from, address to, uint256 tokenId);
134 
135     struct Detail {
136         uint256 dna;
137         uint256 idParent;
138         uint64 releaseTime;
139     }
140 
141     Detail[] details;
142 
143     mapping (uint256 => address) public detailIndexToOwner;
144     mapping (address => uint256) public ownershipTokenCount;
145     mapping (uint256 => address) public detailIndexToApproved;
146 
147     function _transfer(address _from, address _to, uint256 _tokenId) internal {
148         ownershipTokenCount[_to]++;
149         detailIndexToOwner[_tokenId] = _to;
150         if (_from != address(0)) {
151             ownershipTokenCount[_from]--;
152             delete detailIndexToApproved[_tokenId];
153         }
154         Transfer(_from, _to, _tokenId);
155     }
156 
157     function createDetail(address _owner, uint256 _dna) internal whenNotPaused returns (uint) {
158         Detail memory _detail = Detail(_dna, 0, uint64(now));
159         uint256 newDetailId = details.push(_detail) - 1;
160         require(newDetailId == uint256(uint32(newDetailId)));
161         Create(_owner, newDetailId, _detail.dna);
162         _transfer(0, _owner, newDetailId);
163 
164         return newDetailId;
165     }
166 
167     function getDetail(uint _id) public view returns (uint256, uint256, uint64) {
168         return (details[_id].dna, details[_id].idParent, details[_id].releaseTime);
169     }
170     
171 }
172 
173 contract AssemblyBase is DetailBase {
174         
175     struct Assembly {
176         uint256 idParent;
177         uint256 dna;
178         uint64 releaseTime;
179         uint64 updateTime;
180         uint64 startMiningTime;
181         uint64[] spares;
182         uint8 countMiningDetail;
183         uint8 rang;
184     }
185     
186     uint8[] private rangIndex = [
187         3,
188         4,
189         5,
190         6
191     ];
192     
193     Assembly[] assemblys;
194     
195     mapping (uint256 => address) public assemblIndexToOwner;
196     mapping (address => uint256) public ownershipAssemblyCount;
197     mapping (uint256 => address) public robotIndexToApproved;
198     
199     function gatherDetails(uint64[] _arrIdDetails) public whenNotPaused returns (uint) {
200         
201         require(_arrIdDetails.length == 7);
202         
203         for (uint i = 0; i < _arrIdDetails.length; i++) {
204             _checkDetail(_arrIdDetails[i], uint8(i+1));
205         }
206         
207         Assembly memory _ass = Assembly(0, _makeDna(_arrIdDetails), uint64(now), uint64(now), 0, _arrIdDetails, 0,  _range(_arrIdDetails));
208         
209         uint256 newAssemblyId = assemblys.push(_ass) - 1;
210         
211         for (uint j = 0; j < _arrIdDetails.length; j++) {
212             details[_arrIdDetails[j]].idParent = newAssemblyId;
213         }
214         
215         assemblIndexToOwner[newAssemblyId] = msg.sender;
216         ownershipAssemblyCount[msg.sender]++;
217         
218         return newAssemblyId;
219     }
220     
221     function changeAssembly(uint _id, uint64[] _index, uint64[] _arrIdReplace) public whenNotPaused {
222         require(_index.length == _arrIdReplace.length &&
223                 assemblIndexToOwner[_id] == msg.sender &&
224                 assemblys[_id].startMiningTime == 0);
225         for (uint i = 0; i < _arrIdReplace.length; i++) {
226             _checkDetail(_arrIdReplace[i], uint8(_index[i] + 1));
227         }
228         
229         Assembly storage _assStorage = assemblys[_id];
230         
231         for (uint j = 0; j < _index.length; j++) {
232             details[_assStorage.spares[_index[j]]].idParent = 0;
233             _assStorage.spares[_index[j]] = _arrIdReplace[j];
234             details[_arrIdReplace[j]].idParent = _id;
235         }
236         
237         _assStorage.dna = _makeDna(_assStorage.spares);
238         _assStorage.updateTime = uint64(now);
239         _assStorage.rang = _range(_assStorage.spares);
240     }
241     
242     function startMining(uint _id) public whenNotPaused returns(bool) {
243         require(assemblIndexToOwner[_id] == msg.sender &&
244                 assemblys[_id].rang > 0 &&
245                 assemblys[_id].startMiningTime == 0);
246         assemblys[_id].startMiningTime = uint64(now);
247         return true;
248     }
249     
250     function getAssembly(uint _id) public view returns (uint256, uint64, uint64, uint64, uint64[], uint8, uint8) {
251         return (assemblys[_id].dna,
252                 assemblys[_id].releaseTime,
253                 assemblys[_id].updateTime,
254                 assemblys[_id].startMiningTime,
255                 assemblys[_id].spares,
256                 assemblys[_id].countMiningDetail,
257                 assemblys[_id].rang);
258     }
259     
260     function getAllAssembly(address _owner) public view returns(uint[], uint[], uint[]) {
261         uint[] memory resultIndex = new uint[](ownershipAssemblyCount[_owner]);
262         uint[] memory resultDna = new uint[](ownershipAssemblyCount[_owner]);
263         uint[] memory resultRang = new uint[](ownershipAssemblyCount[_owner]);
264         uint counter = 0;
265         for (uint i = 0; i < assemblys.length; i++) {
266           if (assemblIndexToOwner[i] == _owner) {
267             resultIndex[counter] = i; // index
268             resultDna[counter] = assemblys[i].dna;
269             resultRang[counter] = assemblys[i].rang;
270             counter++;
271           }
272         }
273         return (resultIndex, resultDna, resultRang);
274     }
275     
276     function _checkDetail(uint _id, uint8 _mask) internal view {
277         require(detailIndexToOwner[_id] == msg.sender
278         && details[_id].idParent == 0
279         && details[_id].dna / 1000 == _mask);
280     }
281     
282     function _isCanMining(uint64[] memory _arrIdDetails) internal view returns(uint) {
283         uint _ch = details[_arrIdDetails[i]].dna % 100;
284         for (uint i = 1; i < _arrIdDetails.length; i++) {
285             if (_ch != details[_arrIdDetails[i]].dna % 100) {
286                 return 0;
287             }
288         }
289         return _ch;
290     }
291     
292     function costRecharge(uint _robotId) public view returns(uint) {
293         uint8 _rang = assemblys[_robotId].rang;
294         if (_rang == 3) {
295             return 0.015 ether;
296         } else if (_rang == 4) {
297             return 0.02 ether;
298         } else if (_rang == 5) {
299             return 0.025 ether;
300         } else if (_rang == 6) {
301             return 0.025 ether;
302         }
303     }
304     
305     function _range(uint64[] memory _arrIdDetails) internal view returns(uint8) {
306         uint8 rang;
307         uint _ch = _isCanMining(_arrIdDetails);
308         if (_ch == 0) {
309             rang = 0;
310         } else if (_ch < 29) {
311             rang = rangIndex[0];
312         } else if (_ch > 28 && _ch < 37) {
313             rang = rangIndex[1];
314         } else if (_ch > 36 && _ch < 40) {
315             rang = rangIndex[2];
316         } else if (_ch < 39) {
317             rang = rangIndex[3];
318         }
319         return rang;
320     }
321     
322     function _makeDna(uint64[] memory _arrIdDetails) internal view returns(uint) {
323         uint _dna = 0;
324         for (uint i = 0; i < _arrIdDetails.length; i++) {
325             _dna += details[_arrIdDetails[i]].dna * (10000 ** i);
326         }
327         return _dna;
328     }
329     
330     function _transferRobot(address _from, address _to, uint256 _robotId) internal {
331         ownershipAssemblyCount[_to]++;
332         assemblIndexToOwner[_robotId] = _to;
333         if (_from != address(0)) {
334             ownershipAssemblyCount[_from]--;
335             delete robotIndexToApproved[_robotId];
336         }
337         Transfer(_from, _to, _robotId);
338     }
339     
340 }
341 
342 contract BaseContract is AssemblyBase, ERC721 {
343     
344     using SafeMath for uint;
345     address wallet1;
346     address wallet2;
347     address wallet3;
348     address wallet4;
349     address wallet5;
350     
351     string public constant name = "Robots Crypto";
352     string public constant symbol = "RC";
353 
354     uint[] dHead;
355     uint[] dHousing;
356     uint[] dLeftHand;
357     uint[] dRightHand;
358     uint[] dPelvic;
359     uint[] dLeftLeg;
360     uint[] dRightLeg;
361     
362     uint randNonce = 0;
363 
364     function BaseContract() public {
365         Detail memory _detail = Detail(0, 0, 0);
366         details.push(_detail);
367         Assembly memory _ass = Assembly(0, 0, 0, 0, 0, new uint64[](0), 0, 0);
368         assemblys.push(_ass);
369     }
370 
371     function transferOnWallet() public payable {
372         uint value84 = msg.value.mul(84).div(100);
373         uint val79 = msg.value.mul(79).div(100);
374         
375         wallet1.transfer(msg.value - value84);
376         wallet2.transfer(msg.value - val79);
377         wallet3.transfer(msg.value - val79);
378         wallet4.transfer(msg.value - val79);
379         wallet5.transfer(msg.value - val79);
380         
381     }
382     
383     function setWallet(address _wall1, address _wall2, address _wall3, address _wall4, address _wall5) public onlyOwner {
384         wallet1 = _wall1;
385         wallet2 = _wall2;
386         wallet3 = _wall3;
387         wallet4 = _wall4;
388         wallet5 = _wall5;
389     }
390     
391     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
392         return detailIndexToOwner[_tokenId] == _claimant;
393     }
394     
395     function _ownsRobot(address _claimant, uint256 _robotId) internal view returns (bool) {
396         return assemblIndexToOwner[_robotId] == _claimant;
397     }
398     
399     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
400         return detailIndexToApproved[_tokenId] == _claimant;
401     }
402 
403     function _approve(uint256 _tokenId, address _approved) internal {
404         detailIndexToApproved[_tokenId] = _approved;
405     }
406     
407     function _approveRobot(uint256 _robotId, address _approved) internal {
408         robotIndexToApproved[_robotId] = _approved;
409     }
410 
411     function balanceOf(address _owner) public view returns (uint256 count) {
412         return ownershipTokenCount[_owner];
413     }
414     
415     function balanceOfRobots(address _owner) public view returns (uint256 count) {
416         return ownershipAssemblyCount[_owner];
417     }
418 
419     function transfer(
420         address _to,
421         uint256 _tokenId
422     )
423         external
424     {
425         require(_to != address(0));
426         require(_to != address(this));
427         _transfer(msg.sender, _to, _tokenId);
428     }
429     
430     function transferRobot(
431         address _to,
432         uint256 _robotId
433     )
434         external
435     {
436         require(_to != address(0));
437         require(_to != address(this));
438         _transferRobot(msg.sender, _to, _robotId);
439         uint64[] storage spares = assemblys[_robotId].spares;
440         for (uint i = 0; i < spares.length; i++) {
441             _transfer(msg.sender, _to, spares[i]);
442         }
443     }
444 
445     function approve(address _to, uint256 _tokenId) external {
446         require(_owns(msg.sender, _tokenId));
447         _approve(_tokenId, _to);
448         Approval(msg.sender, _to, _tokenId);
449     }
450     
451     function approveRobot(address _to, uint256 _robotId) external {
452         require(_ownsRobot(msg.sender, _robotId));
453         _approveRobot(_robotId, _to);
454         Approval(msg.sender, _to, _robotId);
455     }
456 
457     function transferFrom(
458         address _from,
459         address _to,
460         uint256 _tokenId
461     )
462         external
463         
464     {
465         require(_to != address(0));
466         require(_owns(_from, _tokenId));
467         _transfer(_from, _to, _tokenId);
468     }
469     
470     function transferFromRobot(
471         address _from,
472         address _to,
473         uint256 _robotId
474     )
475         external
476         
477     {
478         require(_to != address(0));
479         require(_ownsRobot(_from, _robotId));
480 
481         _transferRobot(_from, _to, _robotId);
482         ownershipTokenCount[_from] -= 7;
483     }
484 
485     function totalSupply() public view returns (uint) {
486         return details.length - 1;
487     }
488 
489     function ownerOf(uint256 _tokenId)
490         external
491         view
492         returns (address owner)
493     {
494         owner = detailIndexToOwner[_tokenId];
495         require(owner != address(0));
496     }
497     
498     function ownerOfRobot(uint256 _robotId)
499         external
500         view
501         returns (address owner)
502     {
503         owner = assemblIndexToOwner[_robotId];
504         require(owner != address(0));
505     }
506 
507 
508     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
509         uint256 tokenCount = balanceOf(_owner);
510 
511         if (tokenCount == 0) {
512             return new uint256[](0);
513         } else {
514             uint256[] memory result = new uint256[](tokenCount);
515             uint256 totalDetails = totalSupply();
516             uint256 resultIndex = 0;
517             uint256 detailId;
518 
519             for (detailId = 1; detailId <= totalDetails; detailId++) {
520                 if (detailIndexToOwner[detailId] == _owner) {
521                     result[resultIndex] = detailId;
522                     resultIndex++;
523                 }
524             }
525 
526             return result;
527         }
528     }
529     
530     modifier canMining(uint _id) {
531         if (assemblys[_id].rang == 6) {
532             require(assemblys[_id].countMiningDetail < (assemblys[_id].rang - 1));
533         } else {
534             require(assemblys[_id].countMiningDetail < assemblys[_id].rang);
535         }
536         _;
537       }
538     
539     function getAllHead() public view returns (uint[]) {
540         return dHead;
541     }
542     
543     function getAllHousing() public view returns (uint[]) {
544         return dHousing;
545     }
546     
547     function getAllLeftHand() public view returns (uint[]) {
548         return dLeftHand;
549     }
550     
551     function getAllRightHand() public view returns (uint[]) {
552         return dRightHand;
553     }
554     
555     function getAllPelvic() public view returns (uint[]) {
556         return dPelvic;
557     }
558     
559     function getAllLeftLeg() public view returns (uint[]) {
560         return dLeftLeg;
561     }
562     
563     function getAllRightLeg() public view returns (uint[]) {
564         return dRightLeg;
565     }
566     
567 }
568 
569 contract MainContract is BaseContract {
570     
571     event BuyChestSuccess(uint count);
572     
573     mapping (address => uint256) public ownershipChestCount;
574     
575         modifier isMultiplePrice() {
576         require((msg.value % 0.1 ether) == 0);
577         _;
578     }
579     
580     modifier isMinValue() {
581         require(msg.value >= 0.1 ether);
582         _;
583     }
584     
585     function addOwnershipChest(address _owner, uint _num) external onlyOwner {
586         ownershipChestCount[_owner] += _num;
587     }
588     
589     function getMyChest(address _owner) external view returns(uint) {
590         return ownershipChestCount[_owner];
591     }
592     
593     function buyChest() public payable whenNotPaused isMinValue isMultiplePrice {
594         transferOnWallet();
595         uint tokens = msg.value.div(0.1 ether);
596         ownershipChestCount[msg.sender] += tokens;
597         BuyChestSuccess(tokens);
598     }
599     
600     
601     function getMiningDetail(uint _id) public canMining(_id) whenNotPaused returns(bool) {
602         require(assemblIndexToOwner[_id] == msg.sender);
603         if (assemblys[_id].startMiningTime + 259200 <= now) {
604             if (assemblys[_id].rang == 6) {
605                 _generateDetail(40);
606             } else {
607                 _generateDetail(28);
608             }
609             assemblys[_id].startMiningTime = uint64(now);
610             assemblys[_id].countMiningDetail++;
611             return true;
612         }
613         return false;
614     }
615     
616     function getAllDetails(address _owner) public view returns(uint[], uint[]) {
617         uint[] memory resultIndex = new uint[](ownershipTokenCount[_owner] - (ownershipAssemblyCount[_owner] * 7));
618         uint[] memory resultDna = new uint[](ownershipTokenCount[_owner] - (ownershipAssemblyCount[_owner] * 7));
619         uint counter = 0;
620         for (uint i = 0; i < details.length; i++) {
621           if (detailIndexToOwner[i] == _owner && details[i].idParent == 0) {
622             resultIndex[counter] = i;
623             resultDna[counter] = details[i].dna;
624             counter++;
625           }
626         }
627         return (resultIndex, resultDna);
628     }
629     
630     function _generateDetail(uint _randLim) internal {
631         uint _dna = randMod(7);
632             
633         uint256 newDetailId = createDetail(msg.sender, (_dna * 1000 + randMod(_randLim)));
634                 
635         if (_dna == 1) {
636             dHead.push(newDetailId);
637         } else if (_dna == 2) {
638             dHousing.push(newDetailId);
639         } else if (_dna == 3) {
640             dLeftHand.push(newDetailId);
641         } else if (_dna == 4) {
642             dRightHand.push(newDetailId);
643         } else if (_dna == 5) {
644             dPelvic.push(newDetailId);
645         } else if (_dna == 6) {
646             dLeftLeg.push(newDetailId);
647         } else if (_dna == 7) {
648             dRightLeg.push(newDetailId);
649         }
650     }
651     
652     function init(address _owner, uint _color) external onlyOwner {
653         
654         uint _dna = 1;
655         
656         for (uint i = 0; i < 7; i++) {
657             
658             uint256 newDetailId = createDetail(_owner, (_dna * 1000 + _color));
659             
660             if (_dna == 1) {
661                 dHead.push(newDetailId);
662             } else if (_dna == 2) {
663                 dHousing.push(newDetailId);
664             } else if (_dna == 3) {
665                 dLeftHand.push(newDetailId);
666             } else if (_dna == 4) {
667                 dRightHand.push(newDetailId);
668             } else if (_dna == 5) {
669                 dPelvic.push(newDetailId);
670             } else if (_dna == 6) {
671                 dLeftLeg.push(newDetailId);
672             } else if (_dna == 7) {
673                 dRightLeg.push(newDetailId);
674             }
675             _dna++;
676         }
677     }
678     
679     function randMod(uint _modulus) internal returns(uint) {
680         randNonce++;
681         return (uint(keccak256(now, msg.sender, randNonce)) % _modulus) + 1;
682     }
683     
684     function openChest() public whenNotPaused {
685         require(ownershipChestCount[msg.sender] >= 1);
686         for (uint i = 0; i < 5; i++) {
687             _generateDetail(40);
688         }
689         ownershipChestCount[msg.sender]--;
690     }
691     
692     function open5Chest() public whenNotPaused {
693         require(ownershipChestCount[msg.sender] >= 5);
694         for (uint i = 0; i < 5; i++) {
695             openChest();
696         }
697     }
698     
699     function rechargeRobot(uint _robotId) external whenNotPaused payable {
700         require(assemblIndexToOwner[_robotId] == msg.sender &&
701                 msg.value == costRecharge(_robotId));
702         if (assemblys[_robotId].rang == 6) {
703             require(assemblys[_robotId].countMiningDetail == (assemblys[_robotId].rang - 1));
704         } else {
705             require(assemblys[_robotId].countMiningDetail == assemblys[_robotId].rang);
706         }   
707         transferOnWallet();        
708         assemblys[_robotId].countMiningDetail = 0;
709         assemblys[_robotId].startMiningTime = 0;
710     }
711     
712     
713 }