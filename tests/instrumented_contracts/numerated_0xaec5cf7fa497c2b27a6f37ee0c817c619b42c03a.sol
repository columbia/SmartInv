1 pragma solidity ^0.4.25;
2 
3 contract ERC721 {
4     function totalSupply() public view returns (uint256 total);
5     function balanceOf(address _owner) public view returns (uint256 balance);
6     function ownerOf(uint256 _tokenId) external view   returns (address owner);
7     // ownerof
8     // deploy:  public ->external
9     // test : external -> public
10     function approve(address _to, uint256 _tokenId) external;
11     function transfer(address _to, uint256 _tokenId) external;
12     function transferFrom(address _from, address _to, uint256 _tokenId) external;
13 
14     event Transfer(address from, address to, uint256 tokenId);
15     event Approval(address owner, address approved, uint256 tokenId);
16 
17     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
18 
19 }
20 
21 contract PonyAbilityInterface {
22 
23     function isPonyAbility() external pure returns (bool);
24 
25     function getBasicAbility(bytes22 _genes) external pure returns(uint8, uint8, uint8, uint8, uint8);
26 
27    function getMaxAbilitySpeed(
28         uint _matronDerbyAttendCount,
29         uint _matronRanking,
30         uint _matronWinningCount,
31         bytes22 _childGenes        
32       ) external view returns (uint);
33 
34     function getMaxAbilityStamina(
35         uint _sireDerbyAttendCount,
36         uint _sireRanking,
37         uint _sireWinningCount,
38         bytes22 _childGenes
39     ) external view returns (uint);
40     
41     function getMaxAbilityStart(
42         uint _matronRanking,
43         uint _matronWinningCount,
44         uint _sireDerbyAttendCount,
45         bytes22 _childGenes
46         ) external view returns (uint);
47     
48         
49     function getMaxAbilityBurst(
50         uint _matronDerbyAttendCount,
51         uint _sireWinningCount,
52         uint _sireRanking,
53         bytes22 _childGenes
54     ) external view returns (uint);
55 
56     function getMaxAbilityTemperament(
57         uint _matronDerbyAttendCount,
58         uint _matronWinningCount,
59         uint _sireDerbyAttendCount,
60         uint _sireWinningCount,
61         bytes22 _childGenes
62     ) external view returns (uint);
63 
64   }
65 
66 contract Ownable {
67     address public owner;
68 
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor() public {
75         owner = msg.sender;
76     }
77 
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87 
88     /**
89      * @dev Allows the current owner to transfer control of the contract to a newOwner.
90      * @param newOwner The address to transfer ownership to.
91      */
92     function transferOwnership(address newOwner)public onlyOwner {
93         if (newOwner != address(0)) {
94             owner = newOwner;
95         }
96     }
97 
98 }
99 
100 contract Pausable is Ownable {
101 
102     //@dev 컨트렉트가 멈추었을때 발생하는 이벤트
103     event Pause();
104     //@dev 컨트렉트가 시작되었을 때 발생하는 이벤트
105     event Unpause();
106 
107     //@dev Contract의 운영을 관리(시작, 중지)하는 변수로서
108     //paused true가 되지 않으면  컨트렉트의 대부분 동작들이 작동하지 않음
109     bool public paused = false;
110 
111 
112     //@dev paused가 멈추지 않았을 때 기능을 수행하도록 해주는 modifier
113     modifier whenNotPaused() {
114         require(!paused);
115         _;
116     }
117 
118     //@dev paused가 멈춰을 때 기능을 수행하도록 해주는 modifier
119     modifier whenPaused {
120         require(paused);
121         _;
122     }
123 
124     //@dev owner 권한을 가진 사용자와 paused가 falsed일 때 수행 가능
125     //paused를 true로 설정
126     function pause() public onlyOwner whenNotPaused returns (bool) {
127         paused = true;
128         emit Pause();
129         return true;
130     }
131 
132 
133     //@dev owner 권한을 가진 사용자와 paused가 true일때
134     //paused를 false로 설정
135     function unPause() public onlyOwner whenPaused returns (bool) {
136         paused = false;
137         emit Unpause();
138         return true;
139     }
140 }
141 
142 contract PonyAccessControl {
143 
144     event ContractUpgrade(address newContract);
145 
146     //@dev CFO,COO 역활을 수행하는 계정의 주소
147     address public cfoAddress;
148     address public cooAddress;    
149     address public derbyAddress; // derby update 전용
150     address public rewardAddress; // reward send 전용    
151 
152     //@dev Contract의 운영을 관리(시작, 중지)하는 변수로서
153     //paused true가 되지 않으면  컨트렉트의 대부분 동작들이 작동하지 않음
154     bool public paused = false;
155 
156     //@dev CFO 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
157     modifier onlyCFO() {
158         require(msg.sender == cfoAddress);
159         _;
160     }
161 
162     //@dev COO 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
163     modifier onlyCOO() {
164         require(msg.sender == cooAddress);
165         _;
166     }      
167 
168     //@dev derby 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
169     modifier onlyDerbyAdress() {
170         require(msg.sender == derbyAddress);
171         _;
172     }
173 
174     //@dev reward 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
175     modifier onlyRewardAdress() {
176         require(msg.sender == rewardAddress);
177         _;
178     }           
179 
180     //@dev COO, CFO, derby, reward 주소로 지정된 사용자들 만이 기능을 수행할 수 있도록해주는 modifier
181     modifier onlyCLevel() {
182         require(
183             msg.sender == cooAddress ||
184             msg.sender == cfoAddress ||            
185             msg.sender == derbyAddress ||
186             msg.sender == rewardAddress            
187         );
188         _;
189     }
190 
191     //@dev CFO 권한을 가진 사용자만 수행 가능,새로운 CF0 계정을 지정
192     function setCFO(address _newCFO) external onlyCFO {
193         require(_newCFO != address(0));
194 
195         cfoAddress = _newCFO;
196     }
197 
198     //@dev CFO 권한을 가진 사용자만 수행 가능,새로운 COO 계정을 지정
199     function setCOO(address _newCOO) external onlyCFO {
200         require(_newCOO != address(0));
201 
202         cooAddress = _newCOO;
203     }    
204 
205     //@dev COO 권한을 가진 사용자만 수행 가능,새로운 Derby 계정을 지정
206     function setDerbyAdress(address _newDerby) external onlyCOO {
207         require(_newDerby != address(0));
208 
209         derbyAddress = _newDerby;
210     }
211 
212     //@dev COO 권한을 가진 사용자만 수행 가능,새로운 Reward 계정을 지정
213     function setRewardAdress(address _newReward) external onlyCOO {
214         require(_newReward != address(0));
215 
216         rewardAddress = _newReward;
217     }    
218 
219     //@dev paused가 멈추지 않았을 때 기능을 수행하도록 해주는 modifier
220     modifier whenNotPaused() {
221         require(!paused);
222         _;
223     }
224 
225     //@dev paused가 멈춰을 때 기능을 수행하도록 해주는 modifier
226     modifier whenPaused {
227         require(paused);
228         _;
229     }
230 
231     //@dev COO 권한을 가진 사용자와 paused가 falsed일 때 수행 가능
232     //paused를 true로 설정
233     function pause() external onlyCOO whenNotPaused {
234         paused = true;
235     }
236 
237     //@dev COO 권한을 가진 사용자와 paused가 true일때
238     //paused를 false로 설정
239     function unPause() public onlyCOO whenPaused {
240         paused = false;
241     }
242 }
243 
244 contract PonyBase is PonyAccessControl {
245 
246     //@dev 새로운 Pony가 생성되었을 때 발생하는 이벤트 (giveBirth 메소드 호출 시 발생)
247     event Birth(address owner, uint256 ponyId, uint256 matronId, uint256 sireId, bytes22 genes);
248     //@dev 포니의 소유권 이전이 발생하였을 때 발생하는 이벤트 (출생 포함)
249     event Transfer(address from, address to, uint256 tokenId);
250 
251     //@dev 당근구매시 발생하는 이벤트
252     event carrotPurchased(address buyer, uint256 receivedValue, uint256 carrotCount);
253 
254     //@dev 랭킹보상이 지급되면 발생하는 이벤트
255     event RewardSendSuccessful(address from, address to, uint value);    
256 
257 
258     struct Pony {
259         // 포니의 탄생 시간
260         uint64 birthTime;
261         // 새로운 쿨다운 적용되었을때, cooldown이 끝나는 block의 번호
262         uint64 cooldownEndBlock;
263         // 모의 아이디
264         uint32 matronId;
265         // 부의 아이디
266         uint32 sireId;        
267         // 나이
268         uint8 age;
269         // 개월 수
270         uint8 month;
271         // 은퇴 나이
272         uint8 retiredAge;        
273         // 경마 참여 횟수
274         uint8 derbyAttendCount;
275         // 랭킹
276         uint32 rankingScore;
277         // 유전자 정보
278         bytes22 genes;
279     }
280 
281     struct DerbyPersonalResult {
282         //1등
283         uint16 first;
284         //2등
285         uint16 second;
286         //3등
287         uint16 third;
288 
289         uint16 lucky;
290 
291     }
292 
293     struct Ability {
294         //속도
295         uint8 speed;
296         //스테미너
297         uint8 stamina;
298         //스타트
299         uint8 start;
300         //폭발력
301         uint8 burst;
302         //기질
303         uint8 temperament;
304         //속도
305 
306         //최대 속도
307         uint8 maxSpeed;
308         //최대 스테미너
309         uint8 maxStamina;
310         //최대 시작
311         uint8 maxStart;
312         //최대 폭발력
313         uint8 maxBurst;
314         //최대 기질
315         uint8 maxTemperament;
316     }
317 
318     struct Gen0Stat {
319         //은퇴나이
320         uint8 retiredAge;
321         //최대 속도
322         uint8 maxSpeed;
323         //최대 스테미너
324         uint8 maxStamina;
325         //최대 시작
326         uint8 maxStart;
327         //최대 폭발력
328         uint8 maxBurst;
329         //최대 기질
330         uint8 maxTemperament;
331     }    
332 
333     //@dev 교배가 발생할때의 다음 교배까지 필요한 시간을 가진 배열
334     uint32[15] public cooldowns = [
335         uint32(2 minutes),
336         uint32(5 minutes),
337         uint32(10 minutes),
338         uint32(30 minutes),
339         uint32(1 hours),
340         uint32(2 hours),
341         uint32(4 hours),
342         uint32(8 hours),
343         uint32(16 hours),
344         uint32(24 hours),
345         uint32(48 hours),
346         uint32(5 days),
347         uint32(7 days),
348         uint32(10 days),
349         uint32(15 days)
350     ];
351 
352 
353     // 능력치 정보를 가지고 있는 배열
354     Ability[] ability;
355 
356     // Gen0생성포니의 은퇴나이 Max능력치 정보
357     Gen0Stat public gen0Stat; 
358 
359     // 모든 포니의 정보를 가지고 있는 배열
360     Pony[] ponies;
361 
362     // 그랑프로 우승 정보를 가지고 있는 배열
363     DerbyPersonalResult[] grandPrix;
364     // 일반 경기 우승 정보를 가지고 있는 배열
365     DerbyPersonalResult[] league;
366 
367     //포니 아이디에 대한 소유권를 가진 주소들에 대한 테이블
368     mapping(uint256 => address) public ponyIndexToOwner;
369     //주소에 해당하는 소유자가 가지고 있는 포니의 개수를 가진 m테이블
370     mapping(address => uint256) ownershipTokenCount;
371     //포니 아이디에 대한 소유권 이전을 허용한 주소 정보를 가진 테이블
372     mapping(uint256 => address) public ponyIndexToApproved;    
373 
374     //@dev 시간 기반의 Pony의 경매를 담당하는 SaleClockAuction의 주소
375     SaleClockAuction public saleAuction;
376     //@dev 교배 기반의 Pony의 경매를 담당하는 SiringClockAuction의 주소
377     SiringClockAuction public siringAuction;
378 
379     //@dev 교배 시 능력치를 계산하는 컨트렉트의 주소
380     PonyAbilityInterface public ponyAbility;
381 
382     //@dev 교배 시 유전자 정보를 생성하는 컨트렉트의 주소
383     GeneScienceInterface public geneScience;
384 
385 
386     // 새로운 블록이 생성되기까지 소유되는 시간
387     uint256 public secondsPerBlock = 15;
388 
389     //@dev 포니의 소유권을 이전해는 internal Method
390     //@param _from 보내는 지갑 주소
391     //@param _to 받는 지갑 주소
392     //@param _tokenId Pony의 아이디
393     function _transfer(address _from, address _to, uint256 _tokenId)
394     internal
395     {
396         ownershipTokenCount[_to]++;
397         ponyIndexToOwner[_tokenId] = _to;
398         if (_from != address(0)) {
399             ownershipTokenCount[_from]--;            
400             delete ponyIndexToApproved[_tokenId];
401         }
402         emit Transfer(_from, _to, _tokenId);
403     }
404 
405     //@dev 신규 포니를 생성하는 internal Method
406     //@param _matronId  종마의 암컷의 id
407     //@param _sireId 종마의 수컷의 id
408     //@param _coolDownIndex  포니의 cooldown Index 값
409     //@param _genes 포니의 유전자 정보
410     //@param _derbyMaxCount 경마 최대 참여 개수
411     //@param _owner 포니의 소유자
412     //@param _maxSpeed 최대 능력치
413     //@param _maxStamina 최대 스테미너
414     //@param _maxStart 최대 스타트
415     //@param _maxBurst 최대 폭발력
416     //@param _maxTemperament 최대 기질
417     function _createPony(
418         uint256 _matronId,
419         uint256 _sireId,
420         bytes22 _genes,
421         uint256 _retiredAge,
422         address _owner,
423         uint[5] _ability,
424         uint[5] _maxAbility
425     )
426     internal
427     returns (uint)
428     {
429         require(_matronId == uint256(uint32(_matronId)));
430         require(_sireId == uint256(uint32(_sireId)));
431         require(_retiredAge == uint256(uint32(_retiredAge)));
432 
433         Pony memory _pony = Pony({
434             birthTime : uint64(now),
435             cooldownEndBlock : 0,
436             matronId : uint32(_matronId),
437             sireId : uint32(_sireId),            
438             age : 0,
439             month : 0,
440             retiredAge : uint8(_retiredAge),
441             rankingScore : 0,
442             genes : _genes,
443             derbyAttendCount : 0
444             });
445 
446 
447         Ability memory _newAbility = Ability({
448             speed : uint8(_ability[0]),
449             stamina : uint8(_ability[1]),
450             start : uint8(_ability[2]),
451             burst : uint8(_ability[3]),
452             temperament : uint8(_ability[4]),
453             maxSpeed : uint8(_maxAbility[0]),
454             maxStamina : uint8(_maxAbility[1]),
455             maxStart : uint8(_maxAbility[2]),
456             maxBurst : uint8(_maxAbility[3]),
457             maxTemperament : uint8(_maxAbility[4])
458             });
459        
460 
461         uint256 newPonyId = ponies.push(_pony) - 1;
462         uint newAbilityId = ability.push(_newAbility) - 1;
463         require(newPonyId == uint256(uint32(newPonyId)));
464         require(newAbilityId == uint256(uint32(newAbilityId)));
465         require(newPonyId == newAbilityId);
466         
467         _leagueGrandprixInit();
468 
469         emit Birth(
470             _owner,
471             newPonyId,
472             uint256(_pony.matronId),
473             uint256(_pony.sireId),
474             _pony.genes
475         );
476         _transfer(0, _owner, newPonyId);
477 
478         return newPonyId;
479     }
480     //@Dev league 및 grandprix 구조체 초기화
481     function _leagueGrandprixInit() internal{
482         
483         DerbyPersonalResult memory _league = DerbyPersonalResult({
484             first : 0,
485             second : 0,
486             third : 0,
487             lucky : 0
488             });
489 
490         DerbyPersonalResult memory _grandPrix = DerbyPersonalResult({
491             first : 0,
492             second : 0,
493             third : 0,
494             lucky : 0
495             });
496 
497         league.push(_league);
498         grandPrix.push(_grandPrix);
499     }
500 
501     //@dev 블록체인에서 새로운 블록이 생성되는데 소요되는 평균 시간을 지정
502     //@param _secs 블록 생성 시간
503     //modifier : COO 만 실행 가능
504     function setSecondsPerBlock(uint256 _secs)
505     external
506     onlyCOO
507     {
508         require(_secs < cooldowns[0]);
509         secondsPerBlock = _secs;
510     }
511 }
512 
513 contract PonyOwnership is PonyBase, ERC721 {
514 
515     //@dev PonyId에 해당하는 포니가 from부터 to로 이전되었을 때 발생하는 이벤트
516     event Transfer(address from, address to, uint256 tokenId);
517     //@dev PonyId에 해당하는 포니의 소유권 이전을 승인하였을 때 발생하는 이벤트 (onwer -> approved)
518     event Approval(address owner, address approved, uint256 tokenId);
519 
520     string public constant name = "GoPony";
521     string public constant symbol = "GP";
522 
523 /*    ERC721Metadata public erc721Metadata;
524 
525     bytes4 constant InterfaceSignature_ERC165 =
526     bytes4(keccak256('supportsInterface(bytes4)'));*/
527 
528     bytes4 constant InterfaceSignature_ERC721 =
529     bytes4(keccak256('name()')) ^
530     bytes4(keccak256('symbol()')) ^
531     bytes4(keccak256('totalSupply()')) ^
532     bytes4(keccak256('balanceOf(address)')) ^
533     bytes4(keccak256('ownerOf(uint256)')) ^
534     bytes4(keccak256('approve(address,uint256)')) ^
535     bytes4(keccak256('transfer(address,uint256)')) ^
536     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
537     bytes4(keccak256('tokensOfOwner(address)')) ^
538     bytes4(keccak256('tokenMetadata(uint256,string)'));
539 
540     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
541     {
542         return (_interfaceID == InterfaceSignature_ERC721);
543     }
544 
545     /*    
546     function setMetadataAddress(address _contractAddress)
547     public
548     onlyCOO
549     {
550         erc721Metadata = ERC721Metadata(_contractAddress);
551     }
552     */
553 
554     //@dev 요청한 주소가 PonyId를 소유하고 있는지 확인하는 Internal Method
555     //@Param _calimant 요청자의 주소
556     //@param _tokenId 포니의 아이디
557     function _owns(address _claimant, uint256 _tokenId)
558     internal
559     view
560     returns (bool)
561     {
562         return ponyIndexToOwner[_tokenId] == _claimant;
563     }
564 
565     //@dev 요청한 주소로 PonyId를 소유권 이전을 승인하였는지 확인하는 internal Method
566     //@Param _calimant 요청자의 주소
567     //@param _tokenId 포니의 아이디
568     function _approvedFor(address _claimant, uint256 _tokenId)
569     internal
570     view
571     returns (bool)
572     {
573         return ponyIndexToApproved[_tokenId] == _claimant;
574     }
575 
576     //@dev  PonyId의 소유권 이전을 승인하는 Internal Method
577     //@param _tokenId 포니의 아이디
578     //@Param _approved 이전할 소유자의 주소
579     function _approve(uint256 _tokenId, address _approved)
580     internal
581     {
582         ponyIndexToApproved[_tokenId] = _approved;
583     }
584 
585     //@dev  주소의 소유자가 가진 Pony의 개수를 리턴
586     //@Param _owner 소유자의 주소
587     function balanceOf(address _owner)
588     public
589     view
590     returns (uint256 count)
591     {
592         return ownershipTokenCount[_owner];
593     }
594 
595     //@dev 소유권을 이전하는 Method
596     //@Param _owner 소유자의 주소
597     //@param _tokenId 포니의 아이디
598     function transfer(
599         address _to,
600         uint256 _tokenId
601     )
602     external
603     whenNotPaused
604     {
605         require(_to != address(0));
606         require(_to != address(this));
607         require(_to != address(saleAuction));
608         require(_to != address(siringAuction));
609         require(_owns(msg.sender, _tokenId));
610         _transfer(msg.sender, _to, _tokenId);
611     }
612 
613     //@dev  PonyId의 소유권 이전을 승인하는 Method
614     //@param _tokenId 포니의 아이디
615     //@Param _approved 이전할 소유자의 주소
616     function approve(
617         address _to,
618         uint256 _tokenId
619     )
620     external
621     whenNotPaused
622     {
623         require(_owns(msg.sender, _tokenId));
624 
625         _approve(_tokenId, _to);
626         emit Approval(msg.sender, _to, _tokenId);
627     }
628 
629     //@dev  이전 소유자로부터 포니의 소유권을 이전 받아옴
630     //@Param _from 이전 소유자 주소
631     //@Param _to 신규 소유자 주소
632     //@param _tokenId 포니의 아이디
633     function transferFrom(
634         address _from,
635         address _to,
636         uint256 _tokenId
637     )
638     external
639     whenNotPaused
640     {
641         require(_to != address(0));
642         require(_to != address(this));
643         require(_approvedFor(msg.sender, _tokenId));
644         require(_owns(_from, _tokenId));
645         _transfer(_from, _to, _tokenId);
646     }
647 
648     //@dev 존재하는 모든 포니의 개수를 가져옴
649     function totalSupply()
650     public
651     view
652     returns (uint)
653     {
654         return ponies.length - 1;
655     }
656 
657     //@dev 포니 아이디에 대한 소유자 정보를 가져옴
658     //@param _tokenId  포니의 아이디
659     function ownerOf(uint256 _tokenId)
660     external
661     view
662     returns (address owner)
663     {
664         owner = ponyIndexToOwner[_tokenId];
665         require(owner != address(0));
666     }
667 
668     //@dev 소유자의 모든 포니 아이디를 가져옴
669     //@param _owner 포니의 소유자
670     function tokensOfOwner(address _owner)
671     external
672     view
673     returns (uint256[] ownerTokens)
674     {
675         uint256 tokenCount = balanceOf(_owner);
676 
677         if (tokenCount == 0) {
678             // Return an empty array
679             return new uint256[](0);
680         } else {
681             uint256[] memory result = new uint256[](tokenCount);
682             uint256 totalPonies = totalSupply();
683             uint256 resultIndex = 0;
684 
685             uint256 ponyId;
686 
687             for (ponyId = 1; ponyId <= totalPonies; ponyId++) {
688                 if (ponyIndexToOwner[ponyId] == _owner) {
689                     result[resultIndex] = ponyId;
690                     resultIndex++;
691                 }
692             }
693 
694             return result;
695         }
696     }
697 
698 }
699 
700 contract PonyBreeding is PonyOwnership {
701 
702 
703     //@dev 포니가 임신되면 발생하는 이벤트
704     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock);
705 
706     //교배가 이루어지는데 필요한 비용
707     uint256 public autoBirthFee = 4 finney;
708 
709     //@dev 유전자 정보를 생성하는 컨트렉트의 주소를 지정하는 method
710     //modifier COO
711     function setGeneScienceAddress(address _address)
712     external
713     onlyCOO
714     {
715         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
716 
717         require(candidateContract.isGeneScience());
718 
719         geneScience = candidateContract;
720     }
721 
722     //@dev 유전자 정보를 생성하는 컨트렉트의 주소를 지정하는 method
723     //modifier COO
724     function setPonyAbilityAddress(address _address)
725     external
726     onlyCOO
727     {
728         PonyAbilityInterface candidateContract = PonyAbilityInterface(_address);
729 
730         require(candidateContract.isPonyAbility());
731 
732         ponyAbility = candidateContract;
733     }
734 
735 
736 
737     //@dev 교배가 가능한지 확인하는 internal method
738     //@param _pony 포니 정보
739     function _isReadyToBreed(Pony _pony)
740     internal
741     view
742     returns (bool)
743     {
744         return (_pony.cooldownEndBlock <= uint64(block.number));
745     }
746 
747     //@dev 셀프 교배 확인용
748     //@param _sireId  교배할 암놈의 아이디
749     //@param _matronId 교배할 숫놈의 아이디
750     function _isSiringPermitted(uint256 _sireId, uint256 _matronId)
751     internal
752     view
753     returns (bool)
754     {
755         address matronOwner = ponyIndexToOwner[_matronId];
756         address sireOwner = ponyIndexToOwner[_sireId];
757 
758         return (matronOwner == sireOwner);
759     }
760 
761 
762     //@dev 포니에 대해서 쿨다운을 적용하는 internal method
763     //@param _pony 포니 정보
764     function _triggerCooldown(Pony storage _pony)
765     internal
766     {
767         if (_pony.age < 14) {
768             _pony.cooldownEndBlock = uint64((cooldowns[_pony.age] / secondsPerBlock) + block.number);
769         } else {
770             _pony.cooldownEndBlock = uint64((cooldowns[14] / secondsPerBlock) + block.number);
771         }
772 
773     }
774     //@dev 포니 교배에 따라 나이를 6개월 증가시키는 internal method
775     //@param _pony 포니 정보
776     function _triggerAgeSixMonth(Pony storage _pony)
777     internal
778     {
779         uint8 sumMonth = _pony.month + 6;
780         if (sumMonth >= 12) {
781             _pony.age = _pony.age + 1;
782             _pony.month = sumMonth - 12;
783         } else {
784             _pony.month = sumMonth;
785         }
786     }
787     //@dev 포니 교배에 따라 나이를 1개월 증가시키는 internal method
788     //@param _pony 포니 정보
789     function _triggerAgeOneMonth(Pony storage _pony)
790     internal
791     {
792         uint8 sumMonth = _pony.month + 1;
793         if (sumMonth >= 12) {
794             _pony.age = _pony.age + 1;
795             _pony.month = sumMonth - 12;
796         } else {
797             _pony.month = sumMonth;
798         }
799     }    
800 
801     //@dev 포니가 교배할때 수수료를 지정
802     //@param val  수수료율
803     //@modifier COO
804     function setAutoBirthFee(uint256 val)
805     external
806     onlyCOO {
807         autoBirthFee = val;
808     }    
809 
810     //@dev 교배가 가능한지 확인
811     //@param _ponyId 포니의 아이디
812     function isReadyToBreed(uint256 _ponyId)
813     public
814     view
815     returns (bool)
816     {
817         require(_ponyId > 0);
818         Pony storage pony = ponies[_ponyId];
819         return _isReadyToBreed(pony);
820     }    
821 
822     //@dev 교배가 가능한지 확인하는 method
823     //@param _matron 암놈의 정보
824     //@param _matronId 모의 아이디
825     //@param _sire 숫놈의 정보
826     //@param _sireId 부의 아이디
827     function _isValidMatingPair(
828         Pony storage _matron,
829         uint256 _matronId,
830         Pony storage _sire,
831         uint256 _sireId
832     )
833     private
834     view
835     returns (bool)
836     {
837         if (_matronId == _sireId) {
838             return false;
839         }
840 
841         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
842             return false;
843         }
844         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
845             return false;
846         }
847 
848         if (_sire.matronId == 0 || _matron.matronId == 0) {
849             return true;
850         }
851 
852         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
853             return false;
854         }
855         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
856             return false;
857         }
858 
859         return true;
860     }
861 
862     //@dev 경매를 통해서 교배가 가능한지 확인하는 internal method
863     //@param _matronId 암놈의 아이디
864     //@param _sireId 숫놈의 아이디
865     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
866     internal
867     view
868     returns (bool)
869     {
870         Pony storage matron = ponies[_matronId];
871         Pony storage sire = ponies[_sireId];
872         return _isValidMatingPair(matron, _matronId, sire, _sireId);
873     }
874 
875     //@dev 교배가 가능한지 확인하는 method
876     //@param _matronId 암놈의 아이디
877     //@param _sireId 숫놈의 아이디
878     function canBreedWith(uint256 _matronId, uint256 _sireId)
879     external
880     view
881     returns (bool)
882     {
883         require(_matronId > 0);
884         require(_sireId > 0);
885         Pony storage matron = ponies[_matronId];
886         Pony storage sire = ponies[_sireId];
887         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
888         _isSiringPermitted(_sireId, _matronId);
889     }
890 
891     //@dev 교배하는 method
892     //@param _matronId 암놈의 아이디
893     //@param _sireId 숫놈의 아이디
894     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
895         Pony storage sire = ponies[_sireId];
896         Pony storage matron = ponies[_matronId];        
897 
898         _triggerCooldown(sire);
899         _triggerCooldown(matron);
900         _triggerAgeSixMonth(sire);
901         _triggerAgeSixMonth(matron);               
902 
903         emit Pregnant(ponyIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock, sire.cooldownEndBlock);
904         _giveBirth(_matronId, _sireId);
905     }
906 
907     //@dev 소유하고 있는 암놈과 숫놈을 이용하여 교배를 시키는 method
908     //@param _matronId 암놈의 아이디
909     //@param _sireId 숫놈의 아이디
910     function breedWithAuto(uint256 _matronId, uint256 _sireId)
911     external
912     payable
913     whenNotPaused
914     {
915         require(msg.value >= autoBirthFee);
916 
917         require(_owns(msg.sender, _matronId));
918 
919         require(_isSiringPermitted(_sireId, _matronId));
920 
921         Pony storage matron = ponies[_matronId];
922 
923         require(_isReadyToBreed(matron));
924 
925         Pony storage sire = ponies[_sireId];
926 
927         require(_isReadyToBreed(sire));
928 
929         require(_isValidMatingPair(
930                 matron,
931                 _matronId,
932                 sire,
933                 _sireId
934             ));
935 
936         _breedWith(_matronId, _sireId);
937     }
938 
939     //@dev 포니를 출생시키는 method
940     //@param _matronId 암놈의 아이디 (임신한)
941     function _giveBirth(uint256 _matronId, uint256 _sireId)
942     internal    
943     returns (uint256)
944     {
945         Pony storage matron = ponies[_matronId];
946         require(matron.birthTime != 0);
947         
948         Pony storage sire = ponies[_sireId];
949 
950         bytes22 childGenes;
951         uint retiredAge;
952         (childGenes, retiredAge) = geneScience.createNewGen(matron.genes, sire.genes);
953 
954         address owner = ponyIndexToOwner[_matronId];
955 
956         uint[5] memory ability;
957         uint[5] memory maxAbility;
958 
959         (ability[0], ability[1], ability[2], ability[3], ability[4]) = ponyAbility.getBasicAbility(childGenes);
960 
961         maxAbility = _getMaxAbility(_matronId, _sireId, matron.derbyAttendCount, matron.rankingScore, sire.derbyAttendCount, sire.rankingScore, childGenes);
962 
963         uint256 ponyId = _createPony(_matronId, _sireId, childGenes, retiredAge, owner, ability, maxAbility);                
964 
965         return ponyId;
966     }
967 
968 
969     //@dev 소유하고 있는 암놈과 숫놈을 이용하여 교배를 시키는 method
970     //@param _matronId 암놈의 아이디
971     //@param _sireId 숫놈의 아이디
972     //@param _matronDerbyAttendCount 모의 경마 참여 횟수
973     //@param _matronRanking 모의 랭킹 점수
974     //@param _sireDerbyAttendCount 부의 경마 참여 횟수
975     //@param _sireRanking 부의 랭킹 점수
976     //@param childGenes 부모유전자로 생성된 자식유전자
977     //@return   maxAbility[0]: 최대 속도, maxAbility[1]: 최대 스태미나, maxAbility[2]: 최대 폭발력, -> maxAbility[3]: 최대 start, maxAbility[4]: 최대 기질
978     function _getMaxAbility(uint _matronId, uint _sireId, uint _matronDerbyAttendCount, uint _matronRanking, uint _sireDerbyAttendCount, uint _sireRanking, bytes22 _childGenes)
979     internal
980     view
981     returns (uint[5] )
982     {
983 
984         uint[5] memory maxAbility;
985 
986         DerbyPersonalResult memory matronGrandPrix = grandPrix[_matronId];
987         DerbyPersonalResult memory sireGrandPrix = grandPrix[_sireId];
988 
989         DerbyPersonalResult memory matronLeague = league[_matronId];
990         DerbyPersonalResult memory sireLeague = league[_sireId];
991 
992         uint matronWinningCount = matronGrandPrix.first+matronGrandPrix.second+matronGrandPrix.third+ matronLeague.first+matronLeague.second+matronLeague.third;
993         uint sireWinningCount = sireGrandPrix.first+sireGrandPrix.second+sireGrandPrix.third+sireLeague.first+sireLeague.second+sireLeague.third;
994 
995         maxAbility[0] = ponyAbility.getMaxAbilitySpeed(_matronDerbyAttendCount, _matronRanking, matronWinningCount, _childGenes);
996         maxAbility[1] = ponyAbility.getMaxAbilityStamina(_sireDerbyAttendCount, _sireRanking, sireWinningCount, _childGenes);
997         maxAbility[2] = ponyAbility.getMaxAbilityStart(_sireDerbyAttendCount, _matronRanking, matronWinningCount, _childGenes);
998         maxAbility[3] = ponyAbility.getMaxAbilityBurst(_matronDerbyAttendCount, _sireRanking, sireWinningCount, _childGenes);
999         maxAbility[4] = ponyAbility.getMaxAbilityTemperament(_matronDerbyAttendCount, matronWinningCount,_sireDerbyAttendCount, sireWinningCount, _childGenes);
1000 
1001         return maxAbility;
1002     }
1003 }
1004 
1005 contract PonyAuction is PonyBreeding {
1006 
1007     //@dev SaleAuction의 주소를 지정
1008     //@param _address SaleAuction의 주소
1009     //modifier COO
1010     function setSaleAuctionAddress(address _address) external onlyCOO {
1011         SaleClockAuction candidateContract = SaleClockAuction(_address);
1012         require(candidateContract.isSaleClockAuction());
1013         saleAuction = candidateContract;
1014     }
1015 
1016     //@dev SaleAuction의 주소를 지정
1017     //@param _address SiringAuction의 주소
1018     //modifier COO
1019     function setSiringAuctionAddress(address _address) external onlyCOO {
1020         SiringClockAuction candidateContract = SiringClockAuction(_address);
1021         require(candidateContract.isSiringClockAuction());
1022         siringAuction = candidateContract;
1023     }
1024 
1025     //@dev  판매용 경매 생성
1026     //@param _ponyId 포니의 아이디
1027     //@param _startingPrice 경매의 시작 가격
1028     //@param _endingPrice  경매의 종료 가격
1029     //@param _duration 경매 기간
1030     function createSaleAuction(
1031         uint _ponyId,
1032         uint _startingPrice,
1033         uint _endingPrice,
1034         uint _duration
1035     )
1036     external
1037     whenNotPaused
1038     {
1039         require(_owns(msg.sender, _ponyId));
1040         require(isReadyToBreed(_ponyId));
1041         _approve(_ponyId, saleAuction);
1042         saleAuction.createAuction(
1043             _ponyId,
1044             _startingPrice,
1045             _endingPrice,
1046             _duration,
1047             msg.sender
1048         );
1049     }
1050 
1051     //@dev 교배용 경매 생성
1052     //@param _ponyId 포니의 아이디
1053     //@param _startingPrice 경매의 시작 가격
1054     //@param _endingPrice  경매의 종료 가격
1055     //@param _duration 경매 기간
1056     function createSiringAuction(
1057         uint _ponyId,
1058         uint _startingPrice,
1059         uint _endingPrice,
1060         uint _duration
1061     )
1062     external
1063     whenNotPaused
1064     {
1065         require(_owns(msg.sender, _ponyId));
1066         require(isReadyToBreed(_ponyId));
1067         _approve(_ponyId, siringAuction);
1068         siringAuction.createAuction(
1069             _ponyId,
1070             _startingPrice,
1071             _endingPrice,
1072             _duration,
1073             msg.sender
1074         );
1075     }
1076 
1077 
1078     //@dev 교배 경매에 참여
1079     //@param _sireId 경매에 등록한 숫놈 Id
1080     //@param _matronId 교배한 암놈의 Id
1081     function bidOnSiringAuction(
1082         uint _sireId,
1083         uint _matronId
1084     )
1085     external
1086     payable
1087     whenNotPaused
1088     {
1089         require(_owns(msg.sender, _matronId));
1090         require(isReadyToBreed(_matronId));
1091         require(_canBreedWithViaAuction(_matronId, _sireId));
1092 
1093         uint currentPrice = siringAuction.getCurrentPrice(_sireId);
1094         require(msg.value >= currentPrice + autoBirthFee);
1095         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1096         _breedWith(uint32(_matronId), uint32(_sireId));
1097     }
1098 
1099     //@dev ether를 PonyCore로 출금
1100     //modifier CLevel
1101     function withdrawAuctionBalances() external onlyCLevel {
1102         saleAuction.withdrawBalance();
1103         siringAuction.withdrawBalance();
1104     }
1105 }
1106 
1107 contract PonyMinting is PonyAuction {
1108 
1109 
1110     //@dev 프로모션용 포니의 최대 생성 개수
1111     //uint256 public constant PROMO_CREATION_LIMIT = 10000;
1112     //@dev GEN0용 포니의 최대 생성 개수
1113     //uint256 public constant GEN0_CREATION_LIMIT = 40000;
1114 
1115     //@dev GEN0포니의 최소 시작 가격
1116     uint256 public GEN0_MINIMUM_STARTING_PRICE = 40 finney;
1117 
1118     //@dev GEN0포니의 최대 시작 가격
1119     uint256 public GEN0_MAXIMUM_STARTING_PRICE = 100 finney;
1120 
1121     //@dev 다음Gen0판매시작가격 상승율 ( 10000 => 100 % )
1122     uint256 public nextGen0PriceRate = 1000;
1123 
1124     //@dev GEN0용 포니의 경매 기간
1125     uint256 public gen0AuctionDuration = 30 days;
1126 
1127     //@dev 생성된 프로모션용 포니 카운트 개수
1128     uint256 public promoCreatedCount;
1129     //@dev 생성된 GEN0용 포니 카운트 개수
1130     uint256 public gen0CreatedCount;
1131 
1132     //@dev 주어진 유전자 정보와 coolDownIndex로 포니를 생성하고, 지정된 주소로 자동할당
1133     //@param _genes  유전자 정보
1134     //@param _coolDownIndex  genes에 해당하는 cooldown Index 값
1135     //@param _owner Pony를 소유할 사용자의 주소
1136     //@param _maxSpeed 최대 능력치
1137     //@param _maxStamina 최대 스테미너
1138     //@param _maxStart 최대 스타트
1139     //@param _maxBurst 최대 폭발력
1140     //@param _maxTemperament 최대 기질
1141     //@modifier COO
1142     function createPromoPony(bytes22 _genes, uint256 _retiredAge, address _owner, uint _maxSpeed, uint _maxStamina, uint _maxStart, uint _maxBurst, uint _maxTemperament) external onlyCOO {
1143         address ponyOwner = _owner;
1144         if (ponyOwner == address(0)) {
1145             ponyOwner = cooAddress;
1146         }
1147         //require(promoCreatedCount < PROMO_CREATION_LIMIT);
1148 
1149         promoCreatedCount++;
1150 
1151         uint[5] memory ability;
1152         uint[5] memory maxAbility;
1153         maxAbility[0] =_maxSpeed;
1154         maxAbility[1] =_maxStamina;
1155         maxAbility[2] =_maxStart;
1156         maxAbility[3] =_maxBurst;
1157         maxAbility[4] =_maxTemperament;
1158         (ability[0],ability[1],ability[2],ability[3],ability[4]) = ponyAbility.getBasicAbility(_genes);
1159         _createPony(0, 0, _genes, _retiredAge, ponyOwner,ability,maxAbility);
1160     }
1161 
1162     //@dev 주어진 유전자 정보와 cooldownIndex 이용하여 GEN0용 포니를 생성
1163     //@param _genes  유전자 정보
1164     //@param _coolDownIndex  genes에 해당하는 cooldown Index 값
1165     //@param _maxSpeed 최대 능력치
1166     //@param _maxStamina 최대 스테미너
1167     //@param _maxStart 최대 스타트
1168     //@param _maxBurst 최대 폭발력
1169     //@param _maxTemperament 최대 기질
1170     //@modifier COO
1171     function createGen0Auction(bytes22 _genes) public onlyCOO {
1172         //require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1173 
1174         uint[5] memory ability;
1175         uint[5] memory maxAbility;
1176         maxAbility[0] = gen0Stat.maxSpeed;
1177         maxAbility[1] = gen0Stat.maxStamina;
1178         maxAbility[2] = gen0Stat.maxStart;
1179         maxAbility[3] = gen0Stat.maxBurst;
1180         maxAbility[4] = gen0Stat.maxTemperament;
1181         (ability[0],ability[1],ability[2],ability[3],ability[4]) = ponyAbility.getBasicAbility(_genes);
1182         
1183         uint256 ponyId = _createPony(0, 0, _genes, gen0Stat.retiredAge, address(this),ability,maxAbility);
1184         _approve(ponyId, saleAuction);
1185 
1186         saleAuction.createAuction(
1187             ponyId,
1188             _computeNextGen0Price(),
1189             10 finney,
1190             gen0AuctionDuration,
1191             address(this)
1192         );
1193 
1194         gen0CreatedCount++;
1195     }
1196 
1197     //@dev 주어진 유전자 정보와 cooldownIndex 이용하여 GEN0용 포니를 생성
1198     //@param _genes  유전자 정보
1199     //@param _coolDownIndex  genes에 해당하는 cooldown Index 값
1200     //@param _maxSpeed 최대 능력치
1201     //@param _maxStamina 최대 스테미너
1202     //@param _maxStart 최대 스타트
1203     //@param _maxBurst 최대 폭발력
1204     //@param _maxTemperament 최대 기질
1205     //@param _startPrice 경매 시작가격
1206     //@modifier COO
1207     function createCustomGen0Auction(bytes22 _genes, uint256 _retiredAge, uint _maxSpeed, uint _maxStamina, uint _maxStart, uint _maxBurst, uint _maxTemperament, uint _startPrice, uint _endPrice) external onlyCOO {
1208         require(10 finney < _startPrice);
1209         require(10 finney < _endPrice);
1210 
1211         uint[5] memory ability;
1212         uint[5] memory maxAbility;
1213         maxAbility[0]=_maxSpeed;
1214         maxAbility[1]=_maxStamina;
1215         maxAbility[2]=_maxStart;
1216         maxAbility[3]=_maxBurst;
1217         maxAbility[4]=_maxTemperament;
1218         (ability[0],ability[1],ability[2],ability[3],ability[4]) = ponyAbility.getBasicAbility(_genes);
1219         
1220         uint256 ponyId = _createPony(0, 0, _genes, _retiredAge, address(this),ability,maxAbility);
1221         _approve(ponyId, saleAuction);
1222 
1223         saleAuction.createAuction(
1224             ponyId,
1225             _startPrice,
1226             _endPrice,
1227             gen0AuctionDuration,
1228             address(this)
1229         );
1230 
1231         gen0CreatedCount++;
1232     }
1233 
1234     /*
1235     function createGen0Auctions(bytes22[] _genes) external onlyCOO {
1236         for ( uint i = 0; i < _genes.length; i++) {
1237             createGen0Auction(_genes[i]);
1238         }
1239     }
1240     */
1241 
1242     //@dev 새로운 Gen0의 가격 산정하는 internal Method
1243     //(최근에 판매된 gen0 5개의 평균가격)*1.5+0.0.1
1244     function _computeNextGen0Price()
1245     internal
1246     view
1247     returns (uint256)
1248     {
1249         uint256 avePrice = saleAuction.averageGen0SalePrice();
1250         require(avePrice == uint256(uint128(avePrice)));
1251 
1252         uint256 nextPrice = avePrice + (avePrice * nextGen0PriceRate / 10000);
1253 
1254         if (nextPrice < GEN0_MINIMUM_STARTING_PRICE) {
1255             nextPrice = GEN0_MINIMUM_STARTING_PRICE;
1256         }else if (nextPrice > GEN0_MAXIMUM_STARTING_PRICE) {
1257             nextPrice = GEN0_MAXIMUM_STARTING_PRICE;
1258         }
1259 
1260         return nextPrice;
1261     }
1262     
1263     function setAuctionDuration(uint256 _duration)
1264     external
1265     onlyCOO
1266     {
1267         gen0AuctionDuration=_duration * 1 days;
1268     }
1269 
1270     //Gen0 Pony Max능력치 Setting
1271     function setGen0Stat(uint256[6] _gen0Stat) 
1272     public 
1273     onlyCOO
1274     {
1275         gen0Stat = Gen0Stat({
1276             retiredAge : uint8(_gen0Stat[0]),
1277             maxSpeed : uint8(_gen0Stat[1]),
1278             maxStamina : uint8(_gen0Stat[2]),
1279             maxStart : uint8(_gen0Stat[3]),
1280             maxBurst : uint8(_gen0Stat[4]),
1281             maxTemperament : uint8(_gen0Stat[5])
1282         });
1283     }
1284 
1285     //@dev 최소시작판매가격을 변경
1286     //@param _minPrice 최소시작판매가격
1287     function setMinStartingPrice(uint256 _minPrice)
1288     public
1289     onlyCOO
1290     {
1291         GEN0_MINIMUM_STARTING_PRICE = _minPrice;
1292     }
1293 
1294     //@dev 최대시작판매가격을 변경
1295     //@param _maxPrice 최대시작판매가격
1296     function setMaxStartingPrice(uint256 _maxPrice)
1297     public
1298     onlyCOO
1299     {
1300         GEN0_MAXIMUM_STARTING_PRICE = _maxPrice;
1301     }    
1302 
1303     //@dev setNextGen0Price 상승율을 변경
1304     //@param _increaseRate 가격상승율
1305     function setNextGen0PriceRate(uint256 _increaseRate)
1306     public
1307     onlyCOO
1308     {
1309         require(_increaseRate <= 10000);
1310         nextGen0PriceRate = _increaseRate;
1311     }
1312     
1313 }
1314 
1315 contract PonyDerby is PonyMinting {
1316 
1317     //@dev 포니 아이디에 대한 경마 참석이 가능한지 확인하는 external Method
1318     //@param _pony 포니 정보
1319     function isAttendDerby(uint256 _id)
1320     external
1321     view
1322     returns (bool)
1323     {
1324         Pony memory _pony = ponies[_id];
1325         return (_pony.cooldownEndBlock <= uint64(block.number)) && (_pony.age < _pony.retiredAge);
1326     }
1327 
1328 
1329     //@dev 은퇴한 포니 인가를 조회하는 메소드
1330     //@param _pony 포니 정보
1331     //@returns 은퇴 : true, 은퇴하지 않은 경우 false
1332     function isPonyRetired(uint256 _id)
1333     external
1334     view
1335     returns (
1336         bool isRetired
1337 
1338     ) {
1339         Pony storage pony = ponies[_id];
1340         if (pony.age >= pony.retiredAge) {
1341             isRetired = true;
1342         } else {
1343             isRetired = false;
1344         }
1345     }
1346 
1347     //@dev 배열로 경기 결과를 설정하는 기능
1348     //modifier Derby
1349     //@param []_id  경마에 참가한 포니 아이디들에 대한 정보를 가지고 있는 배열
1350     //@param []_derbyType  경마 타입 (1:일반 대회, 2:그랑프리(이벤트)
1351     //@param []_lucky  lucky여부를  가지고 있는 배열  lucky=1을 전달
1352     //@param _rewardAbility 보상 능력치 0 :speed, 1:stamina, 2: burst, 3: speed, 4: temperament
1353 
1354     function setDerbyResults(uint[] _id, uint8 _derbyType, uint8[] _ranking, uint8[] _score, uint8[] _lucky, uint8[] _rewardAbility)
1355     public
1356     onlyDerbyAdress
1357     {
1358         require(_id.length == _score.length);
1359         require(_id.length <= 100);
1360         require(_rewardAbility.length%5==0 && _rewardAbility.length>=5);
1361         
1362         uint8[] memory rewardAbility = new uint8[](5);
1363         for (uint i = 0; i < _id.length; i++) {
1364             rewardAbility[0] = _rewardAbility[i*5];
1365             rewardAbility[1] = _rewardAbility[i*5+1];
1366             rewardAbility[2] = _rewardAbility[i*5+2];
1367             rewardAbility[3] = _rewardAbility[i*5+3];
1368             rewardAbility[4] = _rewardAbility[i*5+4];            
1369             setDerbyResult(_id[i], _derbyType, _ranking[i], _score[i], _lucky[i], rewardAbility);
1370         }
1371 
1372     }
1373 
1374     //@dev 경기 결과를 설정하는 기능
1375     //modifier Derby
1376     //@param id  경마에 참가한 포니 아이디들에 대한 정보를 가지고 있는 변수
1377     //@param derbyType  경마 타입 (1:일반 대회, 2:그랑프리(이벤트)
1378     //@param ranking  랭킹정보들을 가지고 있는 변수
1379     //@param score  랭킹 점수를 가지고 있는 변수
1380     //@param rewardAbility 보상 능력치 0 :speed, 1:stamina, 2: burst, 3: speed, 4: temperament
1381     //@param lucky  lucky여부를  가지고 있는 변수  lucky=1을 전달
1382 
1383     function setDerbyResult(uint _id, uint8 _derbyType, uint8 _ranking, uint8 _score, uint8 _lucky,  uint8[] _rewardAbility)
1384     public
1385     onlyDerbyAdress
1386     {
1387         require(_rewardAbility.length ==5);
1388         
1389         Pony storage pony = ponies[_id];
1390         _triggerAgeOneMonth(pony);
1391 
1392         uint32 scoreSum = pony.rankingScore + uint32(_score);
1393         pony.derbyAttendCount = pony.derbyAttendCount + 1;
1394 
1395         if (scoreSum > 0) {
1396             pony.rankingScore = scoreSum;
1397         } else {
1398             pony.rankingScore = 0;
1399         }
1400         if (_derbyType == 1) {
1401             _setLeagueDerbyResult(_id, _ranking, _lucky);
1402         } else if (_derbyType == 2) {
1403             _setGrandPrixDerbyResult(_id, _ranking, _lucky);
1404         }
1405 
1406         Ability storage _ability = ability[_id];
1407 
1408         uint8 speed;
1409         uint8 stamina;
1410         uint8 start;
1411         uint8 burst;
1412         uint8 temperament;
1413         
1414         speed= _ability.speed+_rewardAbility[0];    
1415         if (speed > _ability.maxSpeed) {
1416             _ability.speed = _ability.maxSpeed;
1417         } else {
1418             _ability.speed = speed;
1419         }
1420 
1421         stamina= _ability.stamina+_rewardAbility[1];
1422         if (stamina > _ability.maxStamina) {
1423             _ability.stamina = _ability.maxStamina;
1424         } else {
1425             _ability.stamina = stamina;
1426         }
1427 
1428         start= _ability.start+_rewardAbility[2];
1429         if (start > _ability.maxStart) {
1430             _ability.start = _ability.maxStart;
1431         } else {
1432             _ability.start = start;
1433         }
1434 
1435         burst= _ability.burst+_rewardAbility[3];
1436         if (burst > _ability.maxBurst) {
1437             _ability.burst = _ability.maxBurst;
1438         } else {
1439             _ability.burst = burst;
1440         }
1441         
1442         temperament= _ability.temperament+_rewardAbility[4];
1443         if (temperament > _ability.maxTemperament) {
1444             _ability.temperament = _ability.maxTemperament;
1445         } else {
1446             _ability.temperament =temperament;
1447         }
1448 
1449 
1450     }
1451 
1452     //@dev 포니별 일반경기 리그 결과를 기록
1453     //@param _id 포니 번호
1454     //@param _derbyNum  경마 번호
1455     //@param _ranking  경기 순위
1456     //@param _lucky  행운의 번호 여부
1457     function _setLeagueDerbyResult(uint _id, uint _ranking, uint _lucky)
1458     internal
1459     {
1460         DerbyPersonalResult storage _league = league[_id];
1461         if (_ranking == 1) {
1462             _league.first = _league.first + 1;
1463         } else if (_ranking == 2) {
1464             _league.second = _league.second + 1;
1465         } else if (_ranking == 3) {
1466             _league.third = _league.third + 1;
1467         } 
1468         
1469         if (_lucky == 1) {
1470             _league.lucky = _league.lucky + 1;
1471         }
1472     }
1473 
1474     //@dev 포니별 그랑프리(이벤트)경마 리그 결과를 기록
1475     //@param _id 포니 번호
1476     //@param _derbyNum  경마 번호
1477     //@param _ranking  경기 순위
1478     //@param _lucky  행운의 번호 여부
1479     function _setGrandPrixDerbyResult(uint _id, uint _ranking, uint _lucky)
1480     internal
1481     {
1482         DerbyPersonalResult storage _grandPrix = grandPrix[_id];
1483         if (_ranking == 1) {
1484             _grandPrix.first = _grandPrix.first + 1;
1485         } else if (_ranking == 2) {
1486             _grandPrix.second = _grandPrix.second + 1;
1487         } else if (_ranking == 3) {
1488             _grandPrix.third = _grandPrix.third + 1;
1489         } 
1490         if (_lucky == 1) {
1491             _grandPrix.lucky = _grandPrix.lucky + 1;
1492         }
1493 
1494     }
1495     //@dev 포니별 경마 기록을 리턴
1496     //@param id 포니 아이디
1497     //@return grandPrixCount 그랑프리 우승 카운트 (0: 1, 1:2, 2:3, 3: lucky)
1498     //@return leagueCount  리그 우승 카운트 (0: 1, 1:2, 2:3,  3: lucky)
1499     function getDerbyWinningCount(uint _id)
1500     public
1501     view
1502     returns (
1503         uint grandPrix1st,
1504         uint grandPrix2st,
1505         uint grandPrix3st,
1506         uint grandLucky,
1507         uint league1st,
1508         uint league2st,
1509         uint league3st,
1510         uint leagueLucky
1511     ){
1512         DerbyPersonalResult memory _grandPrix = grandPrix[_id];
1513         grandPrix1st = uint256(_grandPrix.first);
1514         grandPrix2st = uint256(_grandPrix.second);
1515         grandPrix3st= uint256(_grandPrix.third);
1516         grandLucky = uint256(_grandPrix.lucky);
1517 
1518         DerbyPersonalResult memory _league = league[_id];
1519         league1st = uint256(_league.first);
1520         league2st= uint256(_league.second);
1521         league3st = uint256(_league.third);
1522         leagueLucky = uint256(_league.lucky);
1523     }
1524 
1525     //@dev 포니별 능력치 정보를 가져옴
1526     //@param id 포니 아이디
1527     //@return speed 속도
1528     //@return stamina  스태미나
1529     //@return start  스타트
1530     //@return burst 폭발력
1531     //@return temperament  기질
1532     //@return maxSpeed 쵀대 스피드
1533     //@return maxStamina  최대 스태미나
1534     //@return maxBurst  최대 폭발력
1535     //@return maxStart  최대 스타트
1536     //@return maxTemperament  최대 기질
1537 
1538     function getAbility(uint _id)
1539     public
1540     view
1541     returns (
1542         uint8 speed,
1543         uint8 stamina,
1544         uint8 start,
1545         uint8 burst,
1546         uint8 temperament,
1547         uint8 maxSpeed,
1548         uint8 maxStamina,
1549         uint8 maxBurst,
1550         uint8 maxStart,
1551         uint8 maxTemperament
1552 
1553     ){
1554         Ability memory _ability = ability[_id];
1555         speed = _ability.speed;
1556         stamina = _ability.stamina;
1557         start = _ability.start;
1558         burst = _ability.burst;
1559         temperament = _ability.temperament;
1560         maxSpeed = _ability.maxSpeed;
1561         maxStamina = _ability.maxStamina;
1562         maxBurst = _ability.maxBurst;
1563         maxStart = _ability.maxStart;
1564         maxTemperament = _ability.maxTemperament;
1565     }
1566 
1567 
1568 }
1569 
1570 contract PonyCore is PonyDerby {
1571 
1572     address public newContractAddress;
1573 
1574     //@dev PonyCore의 생성자 (최초 한번만 실행됨)
1575     constructor() public payable {
1576         paused = true;
1577         cfoAddress = msg.sender;
1578         cooAddress = msg.sender;
1579     }
1580 
1581     //@param gensis gensis에 대한 유전자 코드
1582     function genesisPonyInit(bytes22 _gensis, uint[5] _ability, uint[5] _maxAbility, uint[6] _gen0Stat) external onlyCOO whenPaused {
1583         require(ponies.length==0);
1584         _createPony(0, 0, _gensis, 100, address(0),_ability,_maxAbility);
1585         setGen0Stat(_gen0Stat);
1586     }
1587 
1588     function setNewAddress(address _v2Address)
1589     external
1590     onlyCOO whenPaused
1591     {
1592         newContractAddress = _v2Address;
1593         emit ContractUpgrade(_v2Address);
1594     }
1595 
1596 
1597     function() external payable {
1598         /*
1599         require(
1600             msg.sender == address(saleAuction) ||
1601             msg.sender == address(siringAuction)
1602         );
1603         */
1604     }
1605 
1606     //@ 포니의 아이디에 해당하는 포니의 정보를 가져옴
1607     //@param _id 포니의 아이디
1608     function getPony(uint256 _id)
1609     external
1610     view
1611     returns (        
1612         bool isReady,
1613         uint256 cooldownEndBlock,        
1614         uint256 birthTime,
1615         uint256 matronId,
1616         uint256 sireId,
1617         bytes22 genes,
1618         uint256 age,
1619         uint256 month,
1620         uint256 retiredAge,
1621         uint256 rankingScore,
1622         uint256 derbyAttendCount
1623 
1624     ) {
1625         Pony storage pony = ponies[_id];        
1626         isReady = (pony.cooldownEndBlock <= block.number);
1627         cooldownEndBlock = pony.cooldownEndBlock;        
1628         birthTime = uint256(pony.birthTime);
1629         matronId = uint256(pony.matronId);
1630         sireId = uint256(pony.sireId);
1631         genes =  pony.genes;
1632         age = uint256(pony.age);
1633         month = uint256(pony.month);
1634         retiredAge = uint256(pony.retiredAge);
1635         rankingScore = uint256(pony.rankingScore);
1636         derbyAttendCount = uint256(pony.derbyAttendCount);
1637 
1638     }
1639 
1640     //@dev 컨트렉트를 작동시키는 method
1641     //(SaleAuction, SiringAuction, GeneScience 지정되어 있어야하며, newContractAddress가 지정 되어 있지 않아야 함)
1642     //modifier COO
1643     function unPause()
1644     public
1645     onlyCOO
1646     whenPaused
1647     {
1648         require(saleAuction != address(0));
1649         require(siringAuction != address(0));
1650         require(geneScience != address(0));
1651         require(ponyAbility != address(0));
1652         require(newContractAddress == address(0));
1653 
1654         super.unPause();
1655     }
1656 
1657     //@dev 잔액을 인출하는 Method
1658     //modifier CFO
1659     function withdrawBalance(uint256 _value)
1660     external
1661     onlyCLevel
1662     {
1663         uint256 balance = this.balance;
1664         require(balance >= _value);        
1665         cfoAddress.transfer(_value);
1666     }
1667 
1668     function buyCarrot(uint256 carrotCount) // 검증에 필요한값을 파라미터로 받아서 이벤트를 발생시키자
1669     external
1670     payable
1671     whenNotPaused
1672     {
1673         emit carrotPurchased(msg.sender, msg.value, carrotCount);
1674     }
1675 
1676     event RewardSendSuccessful(address from, address to, uint value);
1677 
1678     function sendRankingReward(address[] _recipients, uint256[] _rewards)
1679     external
1680     payable
1681     onlyRewardAdress
1682     {
1683         for(uint i = 0; i < _recipients.length; i++){
1684             _recipients[i].transfer(_rewards[i]);
1685             emit RewardSendSuccessful(this, _recipients[i], _rewards[i]);
1686         }
1687     }
1688 
1689 }
1690 
1691 contract ClockAuctionBase {
1692 
1693     //@dev 옥션이 생성되었을 때 발생하는 이벤트
1694     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
1695     //@dev 옥션이 성공하였을 때 발생하는 이벤트
1696     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
1697     //@dev 옥션이 취소하였을 때 발생하는 이벤트
1698     event AuctionCancelled(uint256 tokenId);
1699 
1700     //@dev 옥션 정보를 가지고 있는 구조체
1701     struct Auction {
1702         //seller의 주소
1703         address seller;
1704         // 경매 시작 가격
1705         uint128 startingPrice;
1706         // 경매 종료 가격
1707         uint128 endingPrice;
1708         // 경매 기간
1709         uint64 duration;
1710         // 경매 시작 시점
1711         uint64 startedAt;
1712     }
1713 
1714     //@dev ERC721 PonyCore의 주소
1715     ERC721 public nonFungibleContract;
1716 
1717     //@dev 수수료율
1718     uint256 public ownerCut;
1719 
1720     //@dev Pony Id에 해당하는 옥션 정보를 가지고 있는 테이블
1721     mapping(uint256 => Auction) tokenIdToAuction;
1722 
1723     //@dev 요청한 주소가 토큰 아이디(포니)를 소유하고 있는지 확인하기 위한 internal Method
1724     //@param _claimant  요청한 주소
1725     //@param _tokenId  포니 아이디
1726     function _owns(address _claimant, uint256 _tokenId)
1727     internal
1728     view
1729     returns (bool)
1730     {
1731         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
1732     }
1733 
1734 
1735     //@dev PonyCore Contract에 id에 해당하는 pony를 escrow 시키는 internal method
1736     //@param _owner  소유자 주소
1737     //@param _tokenId  포니 아이디
1738     function _escrow(address _owner, uint256 _tokenId)
1739     internal
1740     {
1741         nonFungibleContract.transferFrom(_owner, this, _tokenId);
1742     }
1743 
1744     //@dev 입력한 주소로 pony의 소유권을 이전시키는 internal method
1745     //@param _receiver  포니를 소요할 주소
1746     //@param _tokenId  포니 아이디
1747     function _transfer(address _receiver, uint256 _tokenId)
1748     internal
1749     {
1750         nonFungibleContract.transfer(_receiver, _tokenId);
1751     }
1752 
1753     //@dev 경매에 등록시키는 internal method
1754     //@param _tokenId  포니 아이디
1755     //@param _auction  옥션 정보
1756     function _addAuction(uint256 _tokenId, Auction _auction) internal {
1757         require(_auction.duration >= 1 minutes);
1758 
1759         tokenIdToAuction[_tokenId] = _auction;
1760 
1761         emit AuctionCreated(
1762             uint256(_tokenId),
1763             uint256(_auction.startingPrice),
1764             uint256(_auction.endingPrice),
1765             uint256(_auction.duration)
1766         );
1767     }
1768 
1769     //@dev 경매를 취소시키는 internal method
1770     //@param _tokenId  포니 아이디
1771     //@param _seller  판매자의 주소
1772     function _cancelAuction(uint256 _tokenId, address _seller)
1773     internal
1774     {
1775         _removeAuction(_tokenId);
1776         _transfer(_seller, _tokenId);
1777         emit AuctionCancelled(_tokenId);
1778     }
1779 
1780     //@dev 경매를 참여시키는 internal method
1781     //@param _tokenId  포니 아이디
1782     //@param _bidAmount 경매 가격 (최종)
1783     function _bid(uint256 _tokenId, uint256 _bidAmount)
1784     internal
1785     returns (uint256)
1786     {
1787         Auction storage auction = tokenIdToAuction[_tokenId];
1788 
1789         require(_isOnAuction(auction));
1790 
1791         uint256 price = _currentPrice(auction);
1792         require(_bidAmount >= price);
1793 
1794         address seller = auction.seller;
1795 
1796         _removeAuction(_tokenId);
1797 
1798         if (price > 0) {
1799             uint256 auctioneerCut = _computeCut(price);
1800             uint256 sellerProceeds = price - auctioneerCut;
1801             seller.transfer(sellerProceeds);
1802         }
1803 
1804         uint256 bidExcess = _bidAmount - price;
1805         msg.sender.transfer(bidExcess);
1806 
1807         emit AuctionSuccessful(_tokenId, price, msg.sender);
1808 
1809         return price;
1810     }
1811 
1812     //@dev 경매에서 제거 시키는 internal method
1813     //@param _tokenId  포니 아이디
1814     function _removeAuction(uint256 _tokenId) internal {
1815         delete tokenIdToAuction[_tokenId];
1816     }
1817 
1818     //@dev 경매가 진행중인지 확인하는 internal method
1819     //@param _auction 경매 정보
1820     function _isOnAuction(Auction storage _auction)
1821     internal
1822     view
1823     returns (bool)
1824     {
1825         return (_auction.startedAt > 0);
1826     }
1827 
1828     //@dev 현재 경매 가격을 리턴하는 internal method
1829     //@param _auction 경매 정보
1830     function _currentPrice(Auction storage _auction)
1831     internal
1832     view
1833     returns (uint256)
1834     {
1835         uint256 secondsPassed = 0;
1836 
1837         if (now > _auction.startedAt) {
1838             secondsPassed = now - _auction.startedAt;
1839         }
1840 
1841         return _computeCurrentPrice(
1842             _auction.startingPrice,
1843             _auction.endingPrice,
1844             _auction.duration,
1845             secondsPassed
1846         );
1847     }
1848 
1849     //@dev 현재 경매 가격을 계산하는 internal method
1850     //@param _startingPrice 경매 시작 가격
1851     //@param _endingPrice 경매 종료 가격
1852     //@param _duration 경매 기간
1853     //@param _secondsPassed  경과 시간
1854     function _computeCurrentPrice(
1855         uint256 _startingPrice,
1856         uint256 _endingPrice,
1857         uint256 _duration,
1858         uint256 _secondsPassed
1859     )
1860     internal
1861     pure
1862     returns (uint256)
1863     {
1864         if (_secondsPassed >= _duration) {
1865             return _endingPrice;
1866         } else {
1867             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
1868             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
1869             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
1870             return uint256(currentPrice);
1871         }
1872     }
1873     //@dev 현재 가격을 기준으로 수수료를 적용하여 가격을 리턴하는 internal method
1874     //@param _price 현재 가격
1875     function _computeCut(uint256 _price)
1876     internal
1877     view
1878     returns (uint256)
1879     {
1880         return _price * ownerCut / 10000;
1881     }
1882 
1883 }
1884 
1885 contract ClockAuction is Pausable, ClockAuctionBase {
1886 
1887     //@dev ERC721 Interface를 준수하고 있는지 체크하기 위해서 필요한 변수
1888     bytes4 constant InterfaceSignature_ERC721 =bytes4(0x9a20483d);
1889 
1890     //@dev ClockAuction의 생성자
1891     //@param _nftAddr PonyCore의 주소
1892     //@param _cut 수수료 율
1893     constructor(address _nftAddress, uint256 _cut) public {
1894         require(_cut <= 10000);
1895         ownerCut = _cut;
1896 
1897         ERC721 candidateContract = ERC721(_nftAddress);
1898         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
1899         nonFungibleContract = candidateContract;
1900     }
1901 
1902     //@dev contract에서 잔고를 인출하기 위해서 사용
1903     function withdrawBalance() external {
1904         address nftAddress = address(nonFungibleContract);
1905 
1906         require(
1907             msg.sender == owner ||
1908             msg.sender == nftAddress
1909         );
1910         nftAddress.send(this.balance);
1911     }
1912 
1913     //@dev  판매용 경매 생성
1914     //@param _tokenId 포니의 아이디
1915     //@param _startingPrice 경매의 시작 가격
1916     //@param _endingPrice  경매의 종료 가격
1917     //@param _duration 경매 기간
1918     function createAuction(
1919         uint256 _tokenId,
1920         uint256 _startingPrice,
1921         uint256 _endingPrice,
1922         uint256 _duration,
1923         address _seller
1924     )
1925     external
1926     whenNotPaused
1927     {
1928 
1929         require(_startingPrice == uint256(uint128(_startingPrice)));
1930         require(_endingPrice == uint256(uint128(_endingPrice)));
1931         require(_duration == uint256(uint64(_duration)));
1932 
1933         require(_owns(msg.sender, _tokenId));
1934         _escrow(msg.sender, _tokenId);
1935         Auction memory auction = Auction(
1936             _seller,
1937             uint128(_startingPrice),
1938             uint128(_endingPrice),
1939             uint64(_duration),
1940             uint64(now)
1941         );
1942         _addAuction(_tokenId, auction);
1943     }
1944 
1945     //@dev 경매에 참여
1946     //@param _tokenId 포니의 아이디
1947     function bid(uint256 _tokenId)
1948     external
1949     payable
1950     whenNotPaused
1951     {
1952         _bid(_tokenId, msg.value);
1953         _transfer(msg.sender, _tokenId);
1954     }
1955 
1956     //@dev 경매를 취소
1957     //@param _tokenId 포니의 아이디
1958     function cancelAuction(uint256 _tokenId)
1959     external
1960     {
1961         Auction storage auction = tokenIdToAuction[_tokenId];
1962         require(_isOnAuction(auction));
1963         address seller = auction.seller;
1964         require(msg.sender == seller);
1965         _cancelAuction(_tokenId, seller);
1966     }
1967 
1968     //@dev 컨트랙트가 멈출 경우 포니아이디에 대해 경매를 취소하는 기능
1969     //@param _tokenId 포니의 아이디
1970     //modifier Owner
1971     function cancelAuctionWhenPaused(uint256 _tokenId)
1972     whenPaused
1973     onlyOwner
1974     external
1975     {
1976         Auction storage auction = tokenIdToAuction[_tokenId];
1977         require(_isOnAuction(auction));
1978         _cancelAuction(_tokenId, auction.seller);
1979     }
1980 
1981     //@dev 옥션의 정보를 가져옴
1982     //@param _tokenId 포니의 아이디
1983     function getAuction(uint256 _tokenId)
1984     external
1985     view
1986     returns
1987     (
1988         address seller,
1989         uint256 startingPrice,
1990         uint256 endingPrice,
1991         uint256 duration,
1992         uint256 startedAt
1993     ) {
1994         Auction storage auction = tokenIdToAuction[_tokenId];
1995         require(_isOnAuction(auction));
1996         return (
1997         auction.seller,
1998         auction.startingPrice,
1999         auction.endingPrice,
2000         auction.duration,
2001         auction.startedAt
2002         );
2003     }
2004 
2005     //@dev 현재의 가격을 가져옴
2006     //@param _tokenId 포니의 아이디
2007     function getCurrentPrice(uint256 _tokenId)
2008     external
2009     view
2010     returns (uint256)
2011     {
2012         Auction storage auction = tokenIdToAuction[_tokenId];
2013         require(_isOnAuction(auction));
2014         return _currentPrice(auction);
2015     }
2016 }
2017 
2018 contract SaleClockAuction is ClockAuction {
2019 
2020     //@dev SaleClockAuction인지 확인해주기 위해서 사용하는 값
2021     bool public isSaleClockAuction = true;
2022 
2023     //@dev GEN0의 판매 개수
2024     uint256 public gen0SaleCount;
2025     //@dev GEN0의 최종 판매 갯수
2026     uint256[5] public lastGen0SalePrices;
2027 
2028     //@dev SaleClockAuction 생성자
2029     //@param _nftAddr PonyCore의 주소
2030     //@param _cut 수수료 율
2031     constructor(address _nftAddr, uint256 _cut) public
2032     ClockAuction(_nftAddr, _cut) {}
2033 
2034     //@dev  판매용 경매 생성
2035     //@param _tokenId 포니의 아이디
2036     //@param _startingPrice 경매의 시작 가격
2037     //@param _endingPrice  경매의 종료 가격
2038     //@param _duration 경매 기간
2039     function createAuction(
2040         uint256 _tokenId,
2041         uint256 _startingPrice,
2042         uint256 _endingPrice,
2043         uint256 _duration,
2044         address _seller
2045     )
2046     external
2047     {
2048         require(_startingPrice == uint256(uint128(_startingPrice)));
2049         require(_endingPrice == uint256(uint128(_endingPrice)));
2050         require(_duration == uint256(uint64(_duration)));
2051 
2052         require(msg.sender == address(nonFungibleContract));
2053         _escrow(_seller, _tokenId);
2054         Auction memory auction = Auction(
2055             _seller,
2056             uint128(_startingPrice),
2057             uint128(_endingPrice),
2058             uint64(_duration),
2059             uint64(now)
2060         );
2061         _addAuction(_tokenId, auction);
2062     }
2063 
2064     //@dev 경매에 참여
2065     //@param _tokenId 포니의 아이디
2066     function bid(uint256 _tokenId)
2067     external
2068     payable
2069     {
2070         address seller = tokenIdToAuction[_tokenId].seller;
2071         uint256 price = _bid(_tokenId, msg.value);
2072         _transfer(msg.sender, _tokenId);
2073 
2074         if (seller == address(nonFungibleContract)) {
2075             lastGen0SalePrices[gen0SaleCount % 5] = price;
2076             gen0SaleCount++;
2077         }
2078     }
2079 
2080     //@dev 포니 가격을 리턴 (최근 판매된 다섯개의 평균 가격)
2081     function averageGen0SalePrice()
2082     external
2083     view
2084     returns (uint256)
2085     {
2086         uint256 sum = 0;
2087         for (uint256 i = 0; i < 5; i++) {
2088             sum += lastGen0SalePrices[i];
2089         }
2090         return sum / 5;
2091     }
2092 
2093 
2094 }
2095 
2096 contract SiringClockAuction is ClockAuction {
2097 
2098     //@dev SiringClockAuction인지 확인해주기 위해서 사용하는 값
2099     bool public isSiringClockAuction = true;
2100 
2101     //@dev SiringClockAuction의 생성자
2102     //@param _nftAddr PonyCore의 주소
2103     //@param _cut 수수료 율
2104     constructor(address _nftAddr, uint256 _cut) public
2105     ClockAuction(_nftAddr, _cut) {}
2106 
2107     //@dev 경매를 생성
2108     //@param _tokenId 포니의 아이디
2109     //@param _startingPrice 경매의 시작 가격
2110     //@param _endingPrice  경매의 종료 가격
2111     //@param _duration 경매 기간
2112     function createAuction(
2113         uint256 _tokenId,
2114         uint256 _startingPrice,
2115         uint256 _endingPrice,
2116         uint256 _duration,
2117         address _seller
2118     )
2119     external
2120     {
2121         require(_startingPrice == uint256(uint128(_startingPrice)));
2122         require(_endingPrice == uint256(uint128(_endingPrice)));
2123         require(_duration == uint256(uint64(_duration)));
2124 
2125         require(msg.sender == address(nonFungibleContract));
2126         _escrow(_seller, _tokenId);
2127         Auction memory auction = Auction(
2128             _seller,
2129             uint128(_startingPrice),
2130             uint128(_endingPrice),
2131             uint64(_duration),
2132             uint64(now)
2133         );
2134         _addAuction(_tokenId, auction);
2135     }
2136 
2137     //@dev 경매에 참여
2138     //@param _tokenId 포니의 아이디
2139     function bid(uint256 _tokenId)
2140     external
2141     payable
2142     {
2143         require(msg.sender == address(nonFungibleContract));
2144         address seller = tokenIdToAuction[_tokenId].seller;
2145         _bid(_tokenId, msg.value);
2146         _transfer(seller, _tokenId);
2147     }
2148 
2149 }
2150 
2151 contract GeneScienceInterface {
2152     function isGeneScience() public pure returns (bool);
2153     function createNewGen(bytes22 genes1, bytes22 genes22) external returns (bytes22, uint);
2154 }