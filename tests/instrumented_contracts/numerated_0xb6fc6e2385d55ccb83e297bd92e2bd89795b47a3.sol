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
21 
22 
23 
24 contract ClockAuctionBase {
25 
26     //@dev 옥션이 생성되었을 때 발생하는 이벤트
27     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
28     //@dev 옥션이 성공하였을 때 발생하는 이벤트
29     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
30     //@dev 옥션이 취소하였을 때 발생하는 이벤트
31     event AuctionCancelled(uint256 tokenId);
32 
33     //@dev 옥션 정보를 가지고 있는 구조체
34     struct Auction {
35         //seller의 주소
36         address seller;
37         // 경매 시작 가격
38         uint128 startingPrice;
39         // 경매 종료 가격
40         uint128 endingPrice;
41         // 경매 기간
42         uint64 duration;
43         // 경매 시작 시점
44         uint64 startedAt;
45     }
46 
47     //@dev ERC721 PonyCore의 주소
48     ERC721 public nonFungibleContract;
49 
50     //@dev 수수료율
51     uint256 public ownerCut;
52 
53     //@dev Pony Id에 해당하는 옥션 정보를 가지고 있는 테이블
54     mapping(uint256 => Auction) tokenIdToAuction;
55 
56     //@dev 요청한 주소가 토큰 아이디(포니)를 소유하고 있는지 확인하기 위한 internal Method
57     //@param _claimant  요청한 주소
58     //@param _tokenId  포니 아이디
59     function _owns(address _claimant, uint256 _tokenId)
60     internal
61     view
62     returns (bool)
63     {
64         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
65     }
66 
67 
68     //@dev PonyCore Contract에 id에 해당하는 pony를 escrow 시키는 internal method
69     //@param _owner  소유자 주소
70     //@param _tokenId  포니 아이디
71     function _escrow(address _owner, uint256 _tokenId)
72     internal
73     {
74         nonFungibleContract.transferFrom(_owner, this, _tokenId);
75     }
76 
77     //@dev 입력한 주소로 pony의 소유권을 이전시키는 internal method
78     //@param _receiver  포니를 소요할 주소
79     //@param _tokenId  포니 아이디
80     function _transfer(address _receiver, uint256 _tokenId)
81     internal
82     {
83         nonFungibleContract.transfer(_receiver, _tokenId);
84     }
85 
86     //@dev 경매에 등록시키는 internal method
87     //@param _tokenId  포니 아이디
88     //@param _auction  옥션 정보
89     function _addAuction(uint256 _tokenId, Auction _auction) internal {
90         require(_auction.duration >= 1 minutes);
91 
92         tokenIdToAuction[_tokenId] = _auction;
93 
94         emit AuctionCreated(
95             uint256(_tokenId),
96             uint256(_auction.startingPrice),
97             uint256(_auction.endingPrice),
98             uint256(_auction.duration)
99         );
100     }
101 
102     //@dev 경매를 취소시키는 internal method
103     //@param _tokenId  포니 아이디
104     //@param _seller  판매자의 주소
105     function _cancelAuction(uint256 _tokenId, address _seller)
106     internal
107     {
108         _removeAuction(_tokenId);
109         _transfer(_seller, _tokenId);
110         emit AuctionCancelled(_tokenId);
111     }
112 
113     //@dev 경매를 참여시키는 internal method
114     //@param _tokenId  포니 아이디
115     //@param _bidAmount 경매 가격 (최종)
116     function _bid(uint256 _tokenId, uint256 _bidAmount)
117     internal
118     returns (uint256)
119     {
120         Auction storage auction = tokenIdToAuction[_tokenId];
121 
122         require(_isOnAuction(auction));
123 
124         uint256 price = _currentPrice(auction);
125         require(_bidAmount >= price);
126 
127         address seller = auction.seller;
128 
129         _removeAuction(_tokenId);
130 
131         if (price > 0) {
132             uint256 auctioneerCut = _computeCut(price);
133             uint256 sellerProceeds = price - auctioneerCut;
134             seller.transfer(sellerProceeds);
135         }
136 
137         uint256 bidExcess = _bidAmount - price;
138         msg.sender.transfer(bidExcess);
139 
140         emit AuctionSuccessful(_tokenId, price, msg.sender);
141 
142         return price;
143     }
144 
145     //@dev 경매에서 제거 시키는 internal method
146     //@param _tokenId  포니 아이디
147     function _removeAuction(uint256 _tokenId) internal {
148         delete tokenIdToAuction[_tokenId];
149     }
150 
151     //@dev 경매가 진행중인지 확인하는 internal method
152     //@param _auction 경매 정보
153     function _isOnAuction(Auction storage _auction)
154     internal
155     view
156     returns (bool)
157     {
158         return (_auction.startedAt > 0);
159     }
160 
161     //@dev 현재 경매 가격을 리턴하는 internal method
162     //@param _auction 경매 정보
163     function _currentPrice(Auction storage _auction)
164     internal
165     view
166     returns (uint256)
167     {
168         uint256 secondsPassed = 0;
169 
170         if (now > _auction.startedAt) {
171             secondsPassed = now - _auction.startedAt;
172         }
173 
174         return _computeCurrentPrice(
175             _auction.startingPrice,
176             _auction.endingPrice,
177             _auction.duration,
178             secondsPassed
179         );
180     }
181 
182     //@dev 현재 경매 가격을 계산하는 internal method
183     //@param _startingPrice 경매 시작 가격
184     //@param _endingPrice 경매 종료 가격
185     //@param _duration 경매 기간
186     //@param _secondsPassed  경과 시간
187     function _computeCurrentPrice(
188         uint256 _startingPrice,
189         uint256 _endingPrice,
190         uint256 _duration,
191         uint256 _secondsPassed
192     )
193     internal
194     pure
195     returns (uint256)
196     {
197         if (_secondsPassed >= _duration) {
198             return _endingPrice;
199         } else {
200             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
201             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
202             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
203             return uint256(currentPrice);
204         }
205     }
206     //@dev 현재 가격을 기준으로 수수료를 적용하여 가격을 리턴하는 internal method
207     //@param _price 현재 가격
208     function _computeCut(uint256 _price)
209     internal
210     view
211     returns (uint256)
212     {
213         return _price * ownerCut / 10000;
214     }
215 
216 }
217 
218 
219 
220 
221 
222 contract Ownable {
223     address public owner;
224 
225 
226     /**
227      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228      * account.
229      */
230     constructor() public {
231         owner = msg.sender;
232     }
233 
234 
235     /**
236      * @dev Throws if called by any account other than the owner.
237      */
238     modifier onlyOwner() {
239         require(msg.sender == owner);
240         _;
241     }
242 
243 
244     /**
245      * @dev Allows the current owner to transfer control of the contract to a newOwner.
246      * @param newOwner The address to transfer ownership to.
247      */
248     function transferOwnership(address newOwner)public onlyOwner {
249         if (newOwner != address(0)) {
250             owner = newOwner;
251         }
252     }
253 
254 }
255 
256 //@title 컨트렉트에 대한 중지 및 시작 기능을 제공해주는 컨트렉트
257 //@dev 컨트렉트 owner만이 컨트렉트 기능을 작동시킬 수 있음
258 contract Pausable is Ownable {
259 
260     //@dev 컨트렉트가 멈추었을때 발생하는 이벤트
261     event Pause();
262     //@dev 컨트렉트가 시작되었을 때 발생하는 이벤트
263     event Unpause();
264 
265     //@dev Contract의 운영을 관리(시작, 중지)하는 변수로서
266     //paused true가 되지 않으면  컨트렉트의 대부분 동작들이 작동하지 않음
267     bool public paused = false;
268 
269 
270     //@dev paused가 멈추지 않았을 때 기능을 수행하도록 해주는 modifier
271     modifier whenNotPaused() {
272         require(!paused);
273         _;
274     }
275 
276     //@dev paused가 멈춰을 때 기능을 수행하도록 해주는 modifier
277     modifier whenPaused {
278         require(paused);
279         _;
280     }
281 
282     //@dev owner 권한을 가진 사용자와 paused가 falsed일 때 수행 가능
283     //paused를 true로 설정
284     function pause() public onlyOwner whenNotPaused returns (bool) {
285         paused = true;
286         emit Pause();
287         return true;
288     }
289 
290 
291     //@dev owner 권한을 가진 사용자와 paused가 true일때
292     //paused를 false로 설정
293     function unPause() public onlyOwner whenPaused returns (bool) {
294         paused = false;
295         emit Unpause();
296         return true;
297     }
298 }
299 
300 
301 
302 //@title non-fungible 토큰을 위한 Clock Auction
303 
304 contract ClockAuction is Pausable, ClockAuctionBase {
305 
306     //@dev ERC721 Interface를 준수하고 있는지 체크하기 위해서 필요한 변수
307     bytes4 constant InterfaceSignature_ERC721 =bytes4(0x9a20483d);
308 
309     //@dev ClockAuction의 생성자
310     //@param _nftAddr PonyCore의 주소
311     //@param _cut 수수료 율
312     constructor(address _nftAddress, uint256 _cut) public {
313         require(_cut <= 10000);
314         ownerCut = _cut;
315 
316         ERC721 candidateContract = ERC721(_nftAddress);
317         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
318         nonFungibleContract = candidateContract;
319     }
320 
321     //@dev contract에서 잔고를 인출하기 위해서 사용
322     function withdrawBalance() external {
323         address nftAddress = address(nonFungibleContract);
324 
325         require(
326             msg.sender == owner ||
327             msg.sender == nftAddress
328         );
329         nftAddress.transfer(address(this).balance);
330     }
331 
332     //@dev  판매용 경매 생성
333     //@param _tokenId 포니의 아이디
334     //@param _startingPrice 경매의 시작 가격
335     //@param _endingPrice  경매의 종료 가격
336     //@param _duration 경매 기간
337     function createAuction(
338         uint256 _tokenId,
339         uint256 _startingPrice,
340         uint256 _endingPrice,
341         uint256 _duration,
342         address _seller
343     )
344     external
345     whenNotPaused
346     {
347 
348         require(_startingPrice == uint256(uint128(_startingPrice)));
349         require(_endingPrice == uint256(uint128(_endingPrice)));
350         require(_duration == uint256(uint64(_duration)));
351 
352         require(_owns(msg.sender, _tokenId));
353         _escrow(msg.sender, _tokenId);
354         Auction memory auction = Auction(
355             _seller,
356             uint128(_startingPrice),
357             uint128(_endingPrice),
358             uint64(_duration),
359             uint64(now)
360         );
361         _addAuction(_tokenId, auction);
362     }
363 
364     //@dev 경매에 참여
365     //@param _tokenId 포니의 아이디
366     function bid(uint256 _tokenId)
367     external
368     payable
369     whenNotPaused
370     {
371         _bid(_tokenId, msg.value);
372         _transfer(msg.sender, _tokenId);
373     }
374 
375     //@dev 경매를 취소
376     //@param _tokenId 포니의 아이디
377     function cancelAuction(uint256 _tokenId)
378     external
379     {
380         Auction storage auction = tokenIdToAuction[_tokenId];
381         require(_isOnAuction(auction));
382         address seller = auction.seller;
383         require(msg.sender == seller);
384         _cancelAuction(_tokenId, seller);
385     }
386 
387     //@dev 컨트랙트가 멈출 경우 포니아이디에 대해 경매를 취소하는 기능
388     //@param _tokenId 포니의 아이디
389     //modifier Owner
390     function cancelAuctionWhenPaused(uint256 _tokenId)
391     whenPaused
392     onlyOwner
393     external
394     {
395         Auction storage auction = tokenIdToAuction[_tokenId];
396         require(_isOnAuction(auction));
397         _cancelAuction(_tokenId, auction.seller);
398     }
399 
400     //@dev 옥션의 정보를 가져옴
401     //@param _tokenId 포니의 아이디
402     function getAuction(uint256 _tokenId)
403     external
404     view
405     returns
406     (
407         address seller,
408         uint256 startingPrice,
409         uint256 endingPrice,
410         uint256 duration,
411         uint256 startedAt
412     ) {
413         Auction storage auction = tokenIdToAuction[_tokenId];
414         require(_isOnAuction(auction));
415         return (
416         auction.seller,
417         auction.startingPrice,
418         auction.endingPrice,
419         auction.duration,
420         auction.startedAt
421         );
422     }
423 
424     //@dev 현재의 가격을 가져옴
425     //@param _tokenId 포니의 아이디
426     function getCurrentPrice(uint256 _tokenId)
427     external
428     view
429     returns (uint256)
430     {
431         Auction storage auction = tokenIdToAuction[_tokenId];
432         require(_isOnAuction(auction));
433         return _currentPrice(auction);
434     }
435 }
436 
437 
438 contract GeneScienceInterface {
439     function isGeneScience() public pure returns (bool);
440     function createNewGen(bytes22 genes1, bytes22 genes22) external returns (bytes22, uint);
441 }
442 
443 
444 contract PonyAbilityInterface {
445 
446     function isPonyAbility() external pure returns (bool);
447 
448     function getBasicAbility(bytes22 _genes) external pure returns(uint8, uint8, uint8, uint8, uint8);
449 
450    function getMaxAbilitySpeed(
451         uint _matronDerbyAttendCount,
452         uint _matronRanking,
453         uint _matronWinningCount,
454         bytes22 _childGenes        
455       ) external view returns (uint);
456 
457     function getMaxAbilityStamina(
458         uint _sireDerbyAttendCount,
459         uint _sireRanking,
460         uint _sireWinningCount,
461         bytes22 _childGenes
462     ) external view returns (uint);
463     
464     function getMaxAbilityStart(
465         uint _matronRanking,
466         uint _matronWinningCount,
467         uint _sireDerbyAttendCount,
468         bytes22 _childGenes
469         ) external view returns (uint);
470     
471         
472     function getMaxAbilityBurst(
473         uint _matronDerbyAttendCount,
474         uint _sireWinningCount,
475         uint _sireRanking,
476         bytes22 _childGenes
477     ) external view returns (uint);
478 
479     function getMaxAbilityTemperament(
480         uint _matronDerbyAttendCount,
481         uint _matronWinningCount,
482         uint _sireDerbyAttendCount,
483         uint _sireWinningCount,
484         bytes22 _childGenes
485     ) external view returns (uint);
486 
487   }
488 
489 
490 //@title 포니에 대한 접근 권한을 관리하는 컨트렉트
491 //@dev CFO, COO, CLevel, derby, reward에 대한 주소를 지정하고
492 //contract의 method에 modifier를 통해서 사용하면 지정된 주소의
493 //사용자 만이 그 기능을 사용할 수 있도록 접근을 제어 해줌
494 contract PonyAccessControl {
495 
496     event ContractUpgrade(address newContract);
497 
498     //@dev CFO,COO 역활을 수행하는 계정의 주소
499     address public cfoAddress;
500     address public cooAddress;    
501     address public derbyAddress; // derby update 전용
502     address public rewardAddress; // reward send 전용    
503 
504     //@dev Contract의 운영을 관리(시작, 중지)하는 변수로서
505     //paused true가 되지 않으면  컨트렉트의 대부분 동작들이 작동하지 않음
506     bool public paused = false;
507 
508     //@dev CFO 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
509     modifier onlyCFO() {
510         require(msg.sender == cfoAddress);
511         _;
512     }
513 
514     //@dev COO 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
515     modifier onlyCOO() {
516         require(msg.sender == cooAddress);
517         _;
518     }      
519 
520     //@dev derby 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
521     modifier onlyDerbyAdress() {
522         require(msg.sender == derbyAddress);
523         _;
524     }
525 
526     //@dev reward 주소로 지정된 사용자만이 기능을 수행할 수 있도록해주는 modifier
527     modifier onlyRewardAdress() {
528         require(msg.sender == rewardAddress);
529         _;
530     }           
531 
532     //@dev COO, CFO, derby, reward 주소로 지정된 사용자들 만이 기능을 수행할 수 있도록해주는 modifier
533     modifier onlyCLevel() {
534         require(
535             msg.sender == cooAddress ||
536             msg.sender == cfoAddress ||            
537             msg.sender == derbyAddress ||
538             msg.sender == rewardAddress            
539         );
540         _;
541     }
542 
543     //@dev CFO 권한을 가진 사용자만 수행 가능,새로운 CF0 계정을 지정
544     function setCFO(address _newCFO) external onlyCFO {
545         require(_newCFO != address(0));
546 
547         cfoAddress = _newCFO;
548     }
549 
550     //@dev CFO 권한을 가진 사용자만 수행 가능,새로운 COO 계정을 지정
551     function setCOO(address _newCOO) external onlyCFO {
552         require(_newCOO != address(0));
553 
554         cooAddress = _newCOO;
555     }    
556 
557     //@dev COO 권한을 가진 사용자만 수행 가능,새로운 Derby 계정을 지정
558     function setDerbyAdress(address _newDerby) external onlyCOO {
559         require(_newDerby != address(0));
560 
561         derbyAddress = _newDerby;
562     }
563 
564     //@dev COO 권한을 가진 사용자만 수행 가능,새로운 Reward 계정을 지정
565     function setRewardAdress(address _newReward) external onlyCOO {
566         require(_newReward != address(0));
567 
568         rewardAddress = _newReward;
569     }    
570 
571     //@dev paused가 멈추지 않았을 때 기능을 수행하도록 해주는 modifier
572     modifier whenNotPaused() {
573         require(!paused);
574         _;
575     }
576 
577     //@dev paused가 멈춰을 때 기능을 수행하도록 해주는 modifier
578     modifier whenPaused {
579         require(paused);
580         _;
581     }
582 
583     //@dev COO 권한을 가진 사용자와 paused가 falsed일 때 수행 가능
584     //paused를 true로 설정
585     function pause() external onlyCOO whenNotPaused {
586         paused = true;
587     }
588 
589     //@dev COO 권한을 가진 사용자와 paused가 true일때
590     //paused를 false로 설정
591     function unPause() public onlyCOO whenPaused {
592         paused = false;
593     }
594 }
595 
596 
597 
598 
599 
600 
601 
602 
603 
604 
605 
606 
607 
608 
609 
610 
611 
612 //@title SaleClockAuction
613 
614 contract SaleClockAuction is ClockAuction {
615 
616     //@dev SaleClockAuction인지 확인해주기 위해서 사용하는 값
617     bool public isSaleClockAuction = true;
618 
619     //@dev GEN0의 판매 개수
620     uint256 public gen0SaleCount;
621     //@dev GEN0의 최종 판매 갯수
622     uint256[5] public lastGen0SalePrices;
623 
624     //@dev SaleClockAuction 생성자
625     //@param _nftAddr PonyCore의 주소
626     //@param _cut 수수료 율
627     constructor(address _nftAddr, uint256 _cut) public
628     ClockAuction(_nftAddr, _cut) {}
629 
630     //@dev  판매용 경매 생성
631     //@param _tokenId 포니의 아이디
632     //@param _startingPrice 경매의 시작 가격
633     //@param _endingPrice  경매의 종료 가격
634     //@param _duration 경매 기간
635     function createAuction(
636         uint256 _tokenId,
637         uint256 _startingPrice,
638         uint256 _endingPrice,
639         uint256 _duration,
640         address _seller
641     )
642     external
643     {
644         require(_startingPrice == uint256(uint128(_startingPrice)));
645         require(_endingPrice == uint256(uint128(_endingPrice)));
646         require(_duration == uint256(uint64(_duration)));
647 
648         require(msg.sender == address(nonFungibleContract));
649         _escrow(_seller, _tokenId);
650         Auction memory auction = Auction(
651             _seller,
652             uint128(_startingPrice),
653             uint128(_endingPrice),
654             uint64(_duration),
655             uint64(now)
656         );
657         _addAuction(_tokenId, auction);
658     }
659 
660     //@dev 경매에 참여
661     //@param _tokenId 포니의 아이디
662     function bid(uint256 _tokenId)
663     external
664     payable
665     {
666         address seller = tokenIdToAuction[_tokenId].seller;
667         uint256 price = _bid(_tokenId, msg.value);
668         _transfer(msg.sender, _tokenId);
669 
670         if (seller == address(nonFungibleContract)) {
671             lastGen0SalePrices[gen0SaleCount % 5] = price;
672             gen0SaleCount++;
673         }
674     }
675 
676     //@dev 포니 가격을 리턴 (최근 판매된 다섯개의 평균 가격)
677     function averageGen0SalePrice()
678     external
679     view
680     returns (uint256)
681     {
682         uint256 sum = 0;
683         for (uint256 i = 0; i < 5; i++) {
684             sum += lastGen0SalePrices[i];
685         }
686         return sum / 5;
687     }
688 
689 
690 }
691 
692 
693 
694 
695 //@title SiringClockAuction
696 
697 contract SiringClockAuction is ClockAuction {
698 
699     //@dev SiringClockAuction인지 확인해주기 위해서 사용하는 값
700     bool public isSiringClockAuction = true;
701 
702     //@dev SiringClockAuction의 생성자
703     //@param _nftAddr PonyCore의 주소
704     //@param _cut 수수료 율
705     constructor(address _nftAddr, uint256 _cut) public
706     ClockAuction(_nftAddr, _cut) {}
707 
708     //@dev 경매를 생성
709     //@param _tokenId 포니의 아이디
710     //@param _startingPrice 경매의 시작 가격
711     //@param _endingPrice  경매의 종료 가격
712     //@param _duration 경매 기간
713     function createAuction(
714         uint256 _tokenId,
715         uint256 _startingPrice,
716         uint256 _endingPrice,
717         uint256 _duration,
718         address _seller
719     )
720     external
721     {
722         require(_startingPrice == uint256(uint128(_startingPrice)));
723         require(_endingPrice == uint256(uint128(_endingPrice)));
724         require(_duration == uint256(uint64(_duration)));
725 
726         require(msg.sender == address(nonFungibleContract));
727         _escrow(_seller, _tokenId);
728         Auction memory auction = Auction(
729             _seller,
730             uint128(_startingPrice),
731             uint128(_endingPrice),
732             uint64(_duration),
733             uint64(now)
734         );
735         _addAuction(_tokenId, auction);
736     }
737 
738     //@dev 경매에 참여
739     //@param _tokenId 포니의 아이디
740     function bid(uint256 _tokenId)
741     external
742     payable
743     {
744         require(msg.sender == address(nonFungibleContract));
745         address seller = tokenIdToAuction[_tokenId].seller;
746         _bid(_tokenId, msg.value);
747         _transfer(seller, _tokenId);
748     }
749 
750 }
751 
752 
753 
754 
755 
756 
757 //@title 포니의 기본 contract
758 //@dev Pony에 관련된 모든 struct, event, variables를 가지고 있음
759 contract PonyBase is PonyAccessControl {
760 
761     //@dev 새로운 Pony가 생성되었을 때 발생하는 이벤트 (giveBirth 메소드 호출 시 발생)
762     event Birth(address owner, uint256 ponyId, uint256 matronId, uint256 sireId, bytes22 genes);
763 
764     //@dev 기존 코어 데이터 이전용(새로운 ponyId)
765     event Relocate(address owner, uint256 ponyId, bytes22 genes);
766 
767     //@dev 포니의 소유권 이전이 발생하였을 때 발생하는 이벤트 (출생 포함)
768     event Transfer(address from, address to, uint256 tokenId);
769 
770     //@dev 당근구매시 발생하는 이벤트
771     event carrotPurchased(address buyer, uint256 receivedValue, uint256 carrotCount);
772 
773     //@dev 랭킹보상이 지급되면 발생하는 이벤트
774     event RewardSendSuccessful(address from, address to, uint256 value);    
775 
776     //@dev 당근 환전시 발생하는 이벤트
777     event CarrotToETHSuccessful(address to, uint256 count, uint256 value);    
778 
779     struct Pony {
780         // 포니의 탄생 시간
781         uint64 birthTime;
782         // 새로운 쿨다운 적용되었을때, cooldown이 끝나는 block의 번호
783         uint64 cooldownEndBlock;
784         // 모의 아이디
785         uint32 matronId;
786         // 부의 아이디
787         uint32 sireId;        
788         // 나이
789         uint8 age;
790         // 개월 수
791         uint8 month;
792         // 은퇴 나이
793         uint8 retiredAge;        
794         // 유전자 정보
795         bytes22 genes;        
796     }
797     
798     struct Ability {
799         //속도
800         uint8 speed;
801         //스테미너
802         uint8 stamina;
803         //스타트
804         uint8 start;
805         //폭발력
806         uint8 burst;
807         //기질
808         uint8 temperament;
809         //속도
810 
811         //최대 속도
812         uint8 maxSpeed;
813         //최대 스테미너
814         uint8 maxStamina;
815         //최대 시작
816         uint8 maxStart;
817         //최대 폭발력
818         uint8 maxBurst;
819         //최대 기질
820         uint8 maxTemperament;
821     }
822 
823     struct Gen0Stat {
824         //은퇴나이
825         uint8 retiredAge;
826         //최대 속도
827         uint8 maxSpeed;
828         //최대 스테미너
829         uint8 maxStamina;
830         //최대 시작
831         uint8 maxStart;
832         //최대 폭발력
833         uint8 maxBurst;
834         //최대 기질
835         uint8 maxTemperament;
836     }    
837 
838     //@dev 교배가 발생할때의 다음 교배까지 필요한 시간을 가진 배열
839     uint32[15] public cooldowns = [
840         uint32(2 minutes),
841         uint32(5 minutes),
842         uint32(10 minutes),
843         uint32(30 minutes),
844         uint32(1 hours),
845         uint32(2 hours),
846         uint32(4 hours),
847         uint32(8 hours),
848         uint32(16 hours),
849         uint32(24 hours),
850         uint32(48 hours),
851         uint32(5 days),
852         uint32(7 days),
853         uint32(10 days),
854         uint32(15 days)
855     ];
856 
857 
858     // 능력치 정보를 가지고 있는 배열
859     Ability[] ability;
860 
861     // Gen0생성포니의 은퇴나이 Max능력치 정보
862     Gen0Stat public gen0Stat; 
863 
864     // 모든 포니의 정보를 가지고 있는 배열
865     Pony[] ponies;
866 
867     //포니 아이디에 대한 소유권를 가진 주소들에 대한 테이블
868     mapping(uint256 => address) public ponyIndexToOwner;
869     //주소에 해당하는 소유자가 가지고 있는 포니의 개수를 가진 m테이블
870     mapping(address => uint256) ownershipTokenCount;
871     //포니 아이디에 대한 소유권 이전을 허용한 주소 정보를 가진 테이블
872     mapping(uint256 => address) public ponyIndexToApproved;    
873 
874     //@dev 시간 기반의 Pony의 경매를 담당하는 SaleClockAuction의 주소
875     SaleClockAuction public saleAuction;
876     //@dev 교배 기반의 Pony의 경매를 담당하는 SiringClockAuction의 주소
877     SiringClockAuction public siringAuction;    
878 
879 	//@dev 교배 시 능력치를 계산하는 컨트렉트의 주소
880     PonyAbilityInterface public ponyAbility;
881 
882     //@dev 교배 시 유전자 정보를 생성하는 컨트렉트의 주소
883     GeneScienceInterface public geneScience;
884 
885     // 새로운 블록이 생성되기까지 소유되는 시간
886     uint256 public secondsPerBlock = 15;
887 
888     //@dev 포니의 소유권을 이전해는 internal Method
889     //@param _from 보내는 지갑 주소
890     //@param _to 받는 지갑 주소
891     //@param _tokenId Pony의 아이디
892     function _transfer(address _from, address _to, uint256 _tokenId)
893     internal
894     {
895         ownershipTokenCount[_to]++;
896         ponyIndexToOwner[_tokenId] = _to;
897         if (_from != address(0)) {
898             ownershipTokenCount[_from]--;            
899             delete ponyIndexToApproved[_tokenId];
900         }
901         emit Transfer(_from, _to, _tokenId);
902     }
903 
904     //@dev 신규 포니를 생성하는 internal Method
905     //@param _relocate  코어 이전용
906     //@param _matronId  종마의 암컷의 id
907     //@param _sireId 종마의 수컷의 id
908     //@param _age  포니의 나이
909     //@param _month  포니의 나이
910     //@param _genes 포니의 유전자 정보
911     //@param _derbyMaxCount 경마 최대 참여 개수
912     //@param _owner 포니의 소유자
913     //@param _maxSpeed 최대 능력치
914     //@param _maxStamina 최대 스테미너
915     //@param _maxStart 최대 스타트
916     //@param _maxBurst 최대 폭발력
917     //@param _maxTemperament 최대 기질
918     function _createPony(
919         uint8 _relocate,
920         uint256[2] _parent, // 0-_matronId, 1-_sireId        
921         uint8[2] _age,        
922         bytes22 _genes,
923         uint256 _retiredAge,
924         address _owner,
925         uint8[5] _ability,
926         uint8[5] _maxAbility        
927     )
928     internal
929     returns (uint)
930     {
931         require(_parent[0] == uint256(uint32(_parent[0])));
932         require(_parent[1] == uint256(uint32(_parent[1])));
933         require(_retiredAge == uint256(uint32(_retiredAge)));
934 
935         Pony memory _pony = Pony({
936             birthTime : uint64(now),
937             cooldownEndBlock : 0,
938             matronId : uint32(_parent[0]),
939             sireId : uint32(_parent[1]),            
940             age : _age[0],
941             month : _age[1],
942             retiredAge : uint8(_retiredAge),            
943             genes : _genes      
944             });
945 
946 
947         Ability memory _newAbility = Ability({
948             speed : _ability[0],
949             stamina : _ability[1],
950             start : _ability[2],
951             burst : _ability[3],
952             temperament : _ability[4],
953             maxSpeed : _maxAbility[0],
954             maxStamina : _maxAbility[1],
955             maxStart : _maxAbility[2],
956             maxBurst : _maxAbility[3],
957             maxTemperament : _maxAbility[4]
958             });
959        
960 
961         uint256 newPonyId = ponies.push(_pony) - 1;
962         uint newAbilityId = ability.push(_newAbility) - 1;
963         require(newPonyId == uint256(uint32(newPonyId)));
964         require(newAbilityId == uint256(uint32(newAbilityId)));
965         require(newPonyId == newAbilityId);
966 
967         if( _relocate == 1)
968         {
969             emit Relocate(_owner, newPonyId, _pony.genes);
970         }
971         else
972         {
973             emit Birth(
974                 _owner,
975                 newPonyId,
976                 uint256(_pony.matronId),
977                 uint256(_pony.sireId),
978                 _pony.genes
979             );
980         }
981         _transfer(0, _owner, newPonyId);
982 
983         return newPonyId;
984     }    
985 
986     //@dev 블록체인에서 새로운 블록이 생성되는데 소요되는 평균 시간을 지정
987     //@param _secs 블록 생성 시간
988     //modifier : COO 만 실행 가능
989     function setSecondsPerBlock(uint256 _secs)
990     external
991     onlyCOO
992     {
993         require(_secs < cooldowns[0]);
994         secondsPerBlock = _secs;
995     }
996 }
997 
998 
999 /*import "./ERC721Metadata.sol";*/
1000 
1001 //@title non-Fungible 토큰에 대한 트랙잭션 지원을 위해 필요한 컨트렉트
1002 
1003 contract PonyOwnership is PonyBase, ERC721 {
1004 
1005     //@dev PonyId에 해당하는 포니가 from부터 to로 이전되었을 때 발생하는 이벤트
1006     event Transfer(address from, address to, uint256 tokenId);
1007     //@dev PonyId에 해당하는 포니의 소유권 이전을 승인하였을 때 발생하는 이벤트 (onwer -> approved)
1008     event Approval(address owner, address approved, uint256 tokenId);
1009 
1010     string public constant name = "GoPony";
1011     string public constant symbol = "GP";
1012 
1013 /*    ERC721Metadata public erc721Metadata;
1014 
1015     bytes4 constant InterfaceSignature_ERC165 =
1016     bytes4(keccak256('supportsInterface(bytes4)'));*/
1017 
1018     bytes4 constant InterfaceSignature_ERC721 =
1019     bytes4(keccak256('name()')) ^
1020     bytes4(keccak256('symbol()')) ^
1021     bytes4(keccak256('totalSupply()')) ^
1022     bytes4(keccak256('balanceOf(address)')) ^
1023     bytes4(keccak256('ownerOf(uint256)')) ^
1024     bytes4(keccak256('approve(address,uint256)')) ^
1025     bytes4(keccak256('transfer(address,uint256)')) ^
1026     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1027     bytes4(keccak256('tokensOfOwner(address)')) ^
1028     bytes4(keccak256('tokenMetadata(uint256,string)'));
1029 
1030     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
1031     {
1032         return (_interfaceID == InterfaceSignature_ERC721);
1033     }
1034 
1035     /*    
1036     function setMetadataAddress(address _contractAddress)
1037     public
1038     onlyCOO
1039     {
1040         erc721Metadata = ERC721Metadata(_contractAddress);
1041     }
1042     */
1043 
1044     //@dev 요청한 주소가 PonyId를 소유하고 있는지 확인하는 Internal Method
1045     //@Param _calimant 요청자의 주소
1046     //@param _tokenId 포니의 아이디
1047     function _owns(address _claimant, uint256 _tokenId)
1048     internal
1049     view
1050     returns (bool)
1051     {
1052         return ponyIndexToOwner[_tokenId] == _claimant;
1053     }
1054 
1055     //@dev 요청한 주소로 PonyId를 소유권 이전을 승인하였는지 확인하는 internal Method
1056     //@Param _calimant 요청자의 주소
1057     //@param _tokenId 포니의 아이디
1058     function _approvedFor(address _claimant, uint256 _tokenId)
1059     internal
1060     view
1061     returns (bool)
1062     {
1063         return ponyIndexToApproved[_tokenId] == _claimant;
1064     }
1065 
1066     //@dev  PonyId의 소유권 이전을 승인하는 Internal Method
1067     //@param _tokenId 포니의 아이디
1068     //@Param _approved 이전할 소유자의 주소
1069     function _approve(uint256 _tokenId, address _approved)
1070     internal
1071     {
1072         ponyIndexToApproved[_tokenId] = _approved;
1073     }
1074 
1075     //@dev  주소의 소유자가 가진 Pony의 개수를 리턴
1076     //@Param _owner 소유자의 주소
1077     function balanceOf(address _owner)
1078     public
1079     view
1080     returns (uint256 count)
1081     {
1082         return ownershipTokenCount[_owner];
1083     }
1084 
1085     //@dev 소유권을 이전하는 Method
1086     //@Param _owner 소유자의 주소
1087     //@param _tokenId 포니의 아이디
1088     function transfer(
1089         address _to,
1090         uint256 _tokenId
1091     )
1092     external
1093     whenNotPaused
1094     {
1095         require(_to != address(0));
1096         require(_to != address(this));
1097         require(_to != address(saleAuction));
1098         require(_to != address(siringAuction));
1099         require(_owns(msg.sender, _tokenId));
1100         _transfer(msg.sender, _to, _tokenId);
1101     }
1102 
1103     //@dev  PonyId의 소유권 이전을 승인하는 Method
1104     //@param _tokenId 포니의 아이디
1105     //@Param _approved 이전할 소유자의 주소
1106     function approve(
1107         address _to,
1108         uint256 _tokenId
1109     )
1110     external
1111     whenNotPaused
1112     {
1113         require(_owns(msg.sender, _tokenId));
1114 
1115         _approve(_tokenId, _to);
1116         emit Approval(msg.sender, _to, _tokenId);
1117     }
1118 
1119     //@dev  이전 소유자로부터 포니의 소유권을 이전 받아옴
1120     //@Param _from 이전 소유자 주소
1121     //@Param _to 신규 소유자 주소
1122     //@param _tokenId 포니의 아이디
1123     function transferFrom(
1124         address _from,
1125         address _to,
1126         uint256 _tokenId
1127     )
1128     external
1129     whenNotPaused
1130     {
1131         require(_to != address(0));
1132         require(_to != address(this));
1133         require(_approvedFor(msg.sender, _tokenId));
1134         require(_owns(_from, _tokenId));
1135         _transfer(_from, _to, _tokenId);
1136     }
1137 
1138     //@dev 존재하는 모든 포니의 개수를 가져옴
1139     function totalSupply()
1140     public
1141     view
1142     returns (uint)
1143     {
1144         return ponies.length - 1;
1145     }
1146 
1147     //@dev 포니 아이디에 대한 소유자 정보를 가져옴
1148     //@param _tokenId  포니의 아이디
1149     function ownerOf(uint256 _tokenId)
1150     external
1151     view
1152     returns (address owner)
1153     {
1154         owner = ponyIndexToOwner[_tokenId];
1155         require(owner != address(0));
1156     }
1157 
1158     //@dev 소유자의 모든 포니 아이디를 가져옴
1159     //@param _owner 포니의 소유자
1160     function tokensOfOwner(address _owner)
1161     external
1162     view
1163     returns (uint256[] ownerTokens)
1164     {
1165         uint256 tokenCount = balanceOf(_owner);
1166 
1167         if (tokenCount == 0) {
1168             // Return an empty array
1169             return new uint256[](0);
1170         } else {
1171             uint256[] memory result = new uint256[](tokenCount);
1172             uint256 totalPonies = totalSupply();
1173             uint256 resultIndex = 0;
1174 
1175             uint256 ponyId;
1176 
1177             for (ponyId = 1; ponyId <= totalPonies; ponyId++) {
1178                 if (ponyIndexToOwner[ponyId] == _owner) {
1179                     result[resultIndex] = ponyId;
1180                     resultIndex++;
1181                 }
1182             }
1183 
1184             return result;
1185         }
1186     }
1187 
1188 }
1189 
1190 
1191 //@title 포니의 교배, 임심, 출생을 관리하는 컨트렉트
1192 //@dev 외부의 SaleClockAuction과 SiringClockAuction에 대한 컨트렉트를 설정
1193 
1194 contract PonyBreeding is PonyOwnership {
1195 
1196 
1197     //@dev 포니가 임신되면 발생하는 이벤트
1198     event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 matronCooldownEndBlock, uint256 sireCooldownEndBlock);
1199 
1200     //교배가 이루어지는데 필요한 비용
1201     uint256 public autoBirthFee = 13 finney;
1202 
1203     //@dev 유전자 정보를 생성하는 컨트렉트의 주소를 지정하는 method
1204     //modifier COO
1205     function setGeneScienceAddress(address _address)
1206     external
1207     onlyCOO
1208     {
1209         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
1210 
1211         require(candidateContract.isGeneScience());
1212 
1213         geneScience = candidateContract;
1214     }
1215 
1216     //@dev 유전자 정보를 생성하는 컨트렉트의 주소를 지정하는 method
1217     //modifier COO
1218     function setPonyAbilityAddress(address _address)
1219     external
1220     onlyCOO
1221     {
1222         PonyAbilityInterface candidateContract = PonyAbilityInterface(_address);
1223 
1224         require(candidateContract.isPonyAbility());
1225 
1226         ponyAbility = candidateContract;
1227     }
1228 
1229 
1230 
1231     //@dev 교배가 가능한지 확인하는 internal method
1232     //@param _pony 포니 정보
1233     function _isReadyToBreed(Pony _pony)
1234     internal
1235     view
1236     returns (bool)
1237     {
1238         return (_pony.cooldownEndBlock <= uint64(block.number));
1239     }
1240 
1241     //@dev 셀프 교배 확인용
1242     //@param _sireId  교배할 암놈의 아이디
1243     //@param _matronId 교배할 숫놈의 아이디
1244     function _isSiringPermitted(uint256 _sireId, uint256 _matronId)
1245     internal
1246     view
1247     returns (bool)
1248     {
1249         address matronOwner = ponyIndexToOwner[_matronId];
1250         address sireOwner = ponyIndexToOwner[_sireId];
1251 
1252         return (matronOwner == sireOwner);
1253     }
1254 
1255 
1256     //@dev 포니에 대해서 쿨다운을 적용하는 internal method
1257     //@param _pony 포니 정보
1258     function _triggerCooldown(Pony storage _pony)
1259     internal
1260     {
1261         if (_pony.age < 14) {
1262             _pony.cooldownEndBlock = uint64((cooldowns[_pony.age] / secondsPerBlock) + block.number);
1263         } else {
1264             _pony.cooldownEndBlock = uint64((cooldowns[14] / secondsPerBlock) + block.number);
1265         }
1266 
1267     }
1268     //@dev 포니 교배에 따라 나이를 6개월 증가시키는 internal method
1269     //@param _pony 포니 정보
1270     function _triggerAgeSixMonth(Pony storage _pony)
1271     internal
1272     {
1273         uint8 sumMonth = _pony.month + 6;
1274         if (sumMonth >= 12) {
1275             _pony.age = _pony.age + 1;
1276             _pony.month = sumMonth - 12;
1277         } else {
1278             _pony.month = sumMonth;
1279         }
1280     }
1281     //@dev 포니 교배에 따라 나이를 1개월 증가시키는 internal method
1282     //@param _pony 포니 정보
1283     function _triggerAgeOneMonth(Pony storage _pony)
1284     internal
1285     {
1286         uint8 sumMonth = _pony.month + 1;
1287         if (sumMonth >= 12) {
1288             _pony.age = _pony.age + 1;
1289             _pony.month = sumMonth - 12;
1290         } else {
1291             _pony.month = sumMonth;
1292         }
1293     }    
1294 
1295     //@dev 포니가 교배할때 수수료를 지정
1296     //@param val  수수료율
1297     //@modifier COO
1298     function setAutoBirthFee(uint256 val)
1299     external
1300     onlyCOO {
1301         autoBirthFee = val;
1302     }    
1303 
1304     //@dev 교배가 가능한지 확인
1305     //@param _ponyId 포니의 아이디
1306     function isReadyToBreed(uint256 _ponyId)
1307     public
1308     view
1309     returns (bool)
1310     {
1311         require(_ponyId > 0);
1312         Pony storage pony = ponies[_ponyId];
1313         return _isReadyToBreed(pony);
1314     }    
1315 
1316     //@dev 교배가 가능한지 확인하는 method
1317     //@param _matron 암놈의 정보
1318     //@param _matronId 모의 아이디
1319     //@param _sire 숫놈의 정보
1320     //@param _sireId 부의 아이디
1321     function _isValidMatingPair(
1322         Pony storage _matron,
1323         uint256 _matronId,
1324         Pony storage _sire,
1325         uint256 _sireId
1326     )
1327     private
1328     view
1329     returns (bool)
1330     {
1331         if (_matronId == _sireId) {
1332             return false;
1333         }
1334 
1335         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
1336             return false;
1337         }
1338         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
1339             return false;
1340         }
1341 
1342         if (_sire.matronId == 0 || _matron.matronId == 0) {
1343             return true;
1344         }
1345 
1346         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
1347             return false;
1348         }
1349         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
1350             return false;
1351         }
1352 
1353         return true;
1354     }
1355 
1356     //@dev 경매를 통해서 교배가 가능한지 확인하는 internal method
1357     //@param _matronId 암놈의 아이디
1358     //@param _sireId 숫놈의 아이디
1359     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
1360     internal
1361     view
1362     returns (bool)
1363     {
1364         Pony storage matron = ponies[_matronId];
1365         Pony storage sire = ponies[_sireId];
1366         return _isValidMatingPair(matron, _matronId, sire, _sireId);
1367     }
1368 
1369     //@dev 교배가 가능한지 확인하는 method
1370     //@param _matronId 암놈의 아이디
1371     //@param _sireId 숫놈의 아이디
1372     function canBreedWith(uint256 _matronId, uint256 _sireId)
1373     external
1374     view
1375     returns (bool)
1376     {
1377         require(_matronId > 0);
1378         require(_sireId > 0);
1379         Pony storage matron = ponies[_matronId];
1380         Pony storage sire = ponies[_sireId];
1381         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
1382         _isSiringPermitted(_sireId, _matronId);
1383     }
1384 
1385     //@dev 교배하는 method
1386     //@param _matronId 암놈의 아이디
1387     //@param _sireId 숫놈의 아이디
1388     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
1389         Pony storage sire = ponies[_sireId];
1390         Pony storage matron = ponies[_matronId];        
1391 
1392         _triggerCooldown(sire);
1393         _triggerCooldown(matron);
1394         _triggerAgeSixMonth(sire);
1395         _triggerAgeSixMonth(matron);            
1396         emit Pregnant(ponyIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock, sire.cooldownEndBlock);
1397         _giveBirth(_matronId, _sireId);
1398     }
1399 
1400     //@dev 소유하고 있는 암놈과 숫놈을 이용하여 교배를 시키는 method
1401     //@param _matronId 암놈의 아이디
1402     //@param _sireId 숫놈의 아이디
1403     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1404     external
1405     payable
1406     whenNotPaused
1407     {
1408         require(msg.value >= autoBirthFee);
1409 
1410         require(_owns(msg.sender, _matronId));
1411 
1412         require(_isSiringPermitted(_sireId, _matronId));
1413 
1414         Pony storage matron = ponies[_matronId];
1415 
1416         require(_isReadyToBreed(matron));
1417 
1418         Pony storage sire = ponies[_sireId];
1419 
1420         require(_isReadyToBreed(sire));
1421 
1422         require(_isValidMatingPair(
1423                 matron,
1424                 _matronId,
1425                 sire,
1426                 _sireId
1427             ));
1428 
1429         _breedWith(_matronId, _sireId);
1430     }
1431 
1432     //@dev 포니를 출생시키는 method
1433     //@param _matronId 암놈의 아이디 (임신한)
1434     function _giveBirth(uint256 _matronId, uint256 _sireId)
1435     internal    
1436     returns (uint256)
1437     {
1438         Pony storage matron = ponies[_matronId];
1439         require(matron.birthTime != 0);
1440         
1441         Pony storage sire = ponies[_sireId];
1442 
1443         bytes22 childGenes;
1444         uint retiredAge;
1445         (childGenes, retiredAge) = geneScience.createNewGen(matron.genes, sire.genes);
1446 
1447         address owner = ponyIndexToOwner[_matronId];
1448         
1449         uint8[5] memory ability = [0,0,0,0,0];
1450         uint8[5] memory maxAbility = [0,0,0,0,0];
1451         uint[2] memory parent = [_matronId, _sireId];
1452         uint8[2] memory age = [0,0];
1453         
1454 
1455         (ability[0], ability[1], ability[2], ability[3], ability[4]) = ponyAbility.getBasicAbility(childGenes);
1456 
1457         //maxAbility = _getMaxAbility(_matronId, _sireId, matron.derbyAttendCount, matron.rankingScore, sire.derbyAttendCount, sire.rankingScore, childGenes);        
1458         uint256 ponyId = _createPony(0, parent, age, childGenes, retiredAge, owner, ability, maxAbility);                
1459 
1460         return ponyId;
1461     }
1462 }
1463 
1464 
1465 
1466 
1467 
1468 //@title 포니의 Siring 및 Sale 옥션의 생성을 담담
1469 //@dev 외부의 SaleClockAuction과 SiringClockAuction에 대한 컨트렉트를 설정
1470 contract PonyAuction is PonyBreeding {
1471 
1472     //@dev SaleAuction의 주소를 지정
1473     //@param _address SaleAuction의 주소
1474     //modifier COO
1475     function setSaleAuctionAddress(address _address) external onlyCOO {
1476         SaleClockAuction candidateContract = SaleClockAuction(_address);
1477         require(candidateContract.isSaleClockAuction());
1478         saleAuction = candidateContract;
1479     }
1480 
1481     //@dev SaleAuction의 주소를 지정
1482     //@param _address SiringAuction의 주소
1483     //modifier COO
1484     function setSiringAuctionAddress(address _address) external onlyCOO {
1485         SiringClockAuction candidateContract = SiringClockAuction(_address);
1486         require(candidateContract.isSiringClockAuction());
1487         siringAuction = candidateContract;
1488     }
1489 
1490     //@dev  판매용 경매 생성
1491     //@param _ponyId 포니의 아이디
1492     //@param _startingPrice 경매의 시작 가격
1493     //@param _endingPrice  경매의 종료 가격
1494     //@param _duration 경매 기간
1495     function createSaleAuction(
1496         uint _ponyId,
1497         uint _startingPrice,
1498         uint _endingPrice,
1499         uint _duration
1500     )
1501     external
1502     whenNotPaused
1503     {
1504         require(_owns(msg.sender, _ponyId));
1505         require(isReadyToBreed(_ponyId));
1506         _approve(_ponyId, saleAuction);
1507         saleAuction.createAuction(
1508             _ponyId,
1509             _startingPrice,
1510             _endingPrice,
1511             _duration,
1512             msg.sender
1513         );
1514     }
1515 
1516     //@dev 교배용 경매 생성
1517     //@param _ponyId 포니의 아이디
1518     //@param _startingPrice 경매의 시작 가격
1519     //@param _endingPrice  경매의 종료 가격
1520     //@param _duration 경매 기간
1521     function createSiringAuction(
1522         uint _ponyId,
1523         uint _startingPrice,
1524         uint _endingPrice,
1525         uint _duration
1526     )
1527     external
1528     whenNotPaused
1529     {
1530         require(_owns(msg.sender, _ponyId));
1531         require(isReadyToBreed(_ponyId));
1532         _approve(_ponyId, siringAuction);
1533         siringAuction.createAuction(
1534             _ponyId,
1535             _startingPrice,
1536             _endingPrice,
1537             _duration,
1538             msg.sender
1539         );
1540     }
1541 
1542 
1543     //@dev 교배 경매에 참여
1544     //@param _sireId 경매에 등록한 숫놈 Id
1545     //@param _matronId 교배한 암놈의 Id
1546     function bidOnSiringAuction(
1547         uint _sireId,
1548         uint _matronId
1549     )
1550     external
1551     payable
1552     whenNotPaused
1553     {
1554         require(_owns(msg.sender, _matronId));
1555         require(isReadyToBreed(_matronId));
1556         require(_canBreedWithViaAuction(_matronId, _sireId));
1557 
1558         uint currentPrice = siringAuction.getCurrentPrice(_sireId);
1559         require(msg.value >= currentPrice + autoBirthFee);
1560         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
1561         _breedWith(uint32(_matronId), uint32(_sireId));
1562     }
1563 
1564     //@dev ether를 PonyCore로 출금
1565     //modifier CLevel
1566     function withdrawAuctionBalances() external onlyCLevel {
1567         saleAuction.withdrawBalance();
1568         siringAuction.withdrawBalance();
1569     }
1570 }
1571 
1572 
1573 //@title 포니의 생성과 관련된 컨트렉트
1574 
1575 contract PonyMinting is PonyAuction {
1576 
1577 
1578     //@dev 프로모션용 포니의 최대 생성 개수
1579     //uint256 public constant PROMO_CREATION_LIMIT = 10000;
1580     //@dev GEN0용 포니의 최대 생성 개수
1581     //uint256 public constant GEN0_CREATION_LIMIT = 40000;
1582 
1583     //@dev GEN0포니의 최소 시작 가격
1584     uint256 public GEN0_MINIMUM_STARTING_PRICE = 90 finney;
1585 
1586     //@dev GEN0포니의 최대 시작 가격
1587     uint256 public GEN0_MAXIMUM_STARTING_PRICE = 500 finney;
1588 
1589     //@dev 다음Gen0판매시작가격 상승율 ( 10000 => 100 % )
1590     uint256 public nextGen0PriceRate = 1000;
1591 
1592     //@dev GEN0용 포니의 경매 기간
1593     uint256 public gen0AuctionDuration = 30 days;
1594 
1595     //@dev 생성된 프로모션용 포니 카운트 개수
1596     uint256 public promoCreatedCount;
1597     //@dev 생성된 GEN0용 포니 카운트 개수
1598     uint256 public gen0CreatedCount;
1599 
1600     //@dev 주어진 유전자 정보와 coolDownIndex로 포니를 생성하고, 지정된 주소로 자동할당
1601     //@param _genes  유전자 정보
1602     //@param _coolDownIndex  genes에 해당하는 cooldown Index 값
1603     //@param _owner Pony를 소유할 사용자의 주소
1604     //@param _maxSpeed 최대 능력치
1605     //@param _maxStamina 최대 스테미너
1606     //@param _maxStart 최대 스타트
1607     //@param _maxBurst 최대 폭발력
1608     //@param _maxTemperament 최대 기질
1609     //@modifier COO
1610     function createPromoPony(bytes22 _genes, uint256 _retiredAge, address _owner, uint8[5] _maxStats) external onlyCOO {
1611         address ponyOwner = _owner;
1612         if (ponyOwner == address(0)) {
1613             ponyOwner = cooAddress;
1614         }
1615         //require(promoCreatedCount < PROMO_CREATION_LIMIT);
1616 
1617         promoCreatedCount++;
1618 
1619         uint zero = uint(0);
1620         uint8[5] memory ability;        
1621         uint8[2] memory age = [0,0];
1622         uint[2] memory parents = [zero, zero];
1623         
1624         
1625         (ability[0],ability[1],ability[2],ability[3],ability[4]) = ponyAbility.getBasicAbility(_genes);
1626         _createPony(0, parents, age, _genes, _retiredAge, ponyOwner,ability,_maxStats);
1627     }
1628 
1629     //@dev 이전 코어의 포니 정보를 새로 생성    
1630     //@modifier COO
1631     function createPreCorePony(bytes22 _genes, uint256 _retiredAge, address _owner, uint256 _matronId, uint256 _sireId, uint8 _age, uint8 _month, uint8[5] stats, uint8[5] maxStats) external onlyCOO {
1632         address ponyOwner = _owner;
1633         if (ponyOwner == address(0)) {
1634             ponyOwner = cooAddress;
1635         }
1636         uint8[2] memory age = [_age, _month];
1637         uint[2] memory parents = [_matronId, _sireId];        
1638         _createPony(1, parents, age, _genes, _retiredAge, ponyOwner, stats, maxStats);
1639     }
1640 
1641     //@dev 주어진 유전자 정보와 cooldownIndex 이용하여 GEN0용 포니를 생성
1642     //@param _genes  유전자 정보
1643     //@param _coolDownIndex  genes에 해당하는 cooldown Index 값
1644     //@param _maxSpeed 최대 능력치
1645     //@param _maxStamina 최대 스테미너
1646     //@param _maxStart 최대 스타트
1647     //@param _maxBurst 최대 폭발력
1648     //@param _maxTemperament 최대 기질
1649     //@modifier COO
1650     function createGen0Auction(bytes22 _genes) public onlyCOO {
1651         //require(gen0CreatedCount < GEN0_CREATION_LIMIT);
1652         uint zero = uint(0);
1653         uint8[5] memory ability;
1654         uint8[5] memory maxAbility = [gen0Stat.maxSpeed, gen0Stat.maxStamina, gen0Stat.maxStart, gen0Stat.maxBurst, gen0Stat.maxTemperament];
1655         uint8[2] memory age = [0, 0];
1656         uint[2] memory parents = [zero, zero];        
1657 
1658         (ability[0],ability[1],ability[2],ability[3],ability[4]) = ponyAbility.getBasicAbility(_genes);
1659         
1660         uint256 ponyId = _createPony(0, parents, age,_genes, gen0Stat.retiredAge, address(this),ability,maxAbility);
1661         _approve(ponyId, saleAuction);
1662 
1663         saleAuction.createAuction(
1664             ponyId,
1665             _computeNextGen0Price(),
1666             10 finney,
1667             gen0AuctionDuration,
1668             address(this)
1669         );
1670 
1671         gen0CreatedCount++;
1672     }
1673 
1674     //@dev 주어진 유전자 정보와 cooldownIndex 이용하여 GEN0용 포니를 생성
1675     //@param _genes  유전자 정보
1676     //@param _coolDownIndex  genes에 해당하는 cooldown Index 값
1677     //@param _maxSpeed 최대 능력치
1678     //@param _maxStamina 최대 스테미너
1679     //@param _maxStart 최대 스타트
1680     //@param _maxBurst 최대 폭발력
1681     //@param _maxTemperament 최대 기질
1682     //@param _startPrice 경매 시작가격
1683     //@modifier COO
1684     function createCustomGen0Auction(bytes22 _genes, uint256 _retiredAge, uint8[5] _maxStats, uint8 _startPrice, uint _endPrice) external onlyCOO {
1685         require(10 finney < _startPrice);
1686         require(10 finney < _endPrice);
1687 
1688         uint zero = uint(0);
1689         uint8[5] memory ability;        
1690         uint8[2] memory age = [0, 0];
1691         uint[2] memory parents = [zero, zero];
1692         
1693         (ability[0],ability[1],ability[2],ability[3],ability[4]) = ponyAbility.getBasicAbility(_genes);
1694         
1695         uint256 ponyId = _createPony(0, parents, age, _genes, _retiredAge, address(this),ability,_maxStats);
1696         _approve(ponyId, saleAuction);
1697 
1698         saleAuction.createAuction(
1699             ponyId,
1700             _startPrice,
1701             _endPrice,
1702             gen0AuctionDuration,
1703             address(this)
1704         );
1705 
1706         gen0CreatedCount++;
1707     }  
1708 
1709     //@dev 새로운 Gen0의 가격 산정하는 internal Method
1710     //(최근에 판매된 gen0 5개의 평균가격)*1.5+0.0.1
1711     function _computeNextGen0Price()
1712     internal
1713     view
1714     returns (uint256)
1715     {
1716         uint256 avePrice = saleAuction.averageGen0SalePrice();
1717         require(avePrice == uint256(uint128(avePrice)));
1718 
1719         uint256 nextPrice = avePrice + (avePrice * nextGen0PriceRate / 10000);
1720 
1721         if (nextPrice < GEN0_MINIMUM_STARTING_PRICE) {
1722             nextPrice = GEN0_MINIMUM_STARTING_PRICE;
1723         }else if (nextPrice > GEN0_MAXIMUM_STARTING_PRICE) {
1724             nextPrice = GEN0_MAXIMUM_STARTING_PRICE;
1725         }
1726 
1727         return nextPrice;
1728     }
1729     
1730     function setAuctionDuration(uint256 _duration)
1731     external
1732     onlyCOO
1733     {
1734         gen0AuctionDuration=_duration * 1 days;
1735     }
1736 
1737     //Gen0 Pony Max능력치 Setting
1738     function setGen0Stat(uint256[6] _gen0Stat) 
1739     public 
1740     onlyCOO
1741     {
1742         gen0Stat = Gen0Stat({
1743             retiredAge : uint8(_gen0Stat[0]),
1744             maxSpeed : uint8(_gen0Stat[1]),
1745             maxStamina : uint8(_gen0Stat[2]),
1746             maxStart : uint8(_gen0Stat[3]),
1747             maxBurst : uint8(_gen0Stat[4]),
1748             maxTemperament : uint8(_gen0Stat[5])
1749         });
1750     }
1751 
1752     //@dev 최소시작판매가격을 변경
1753     //@param _minPrice 최소시작판매가격
1754     function setMinStartingPrice(uint256 _minPrice)
1755     public
1756     onlyCOO
1757     {
1758         GEN0_MINIMUM_STARTING_PRICE = _minPrice;
1759     }
1760 
1761     //@dev 최대시작판매가격을 변경
1762     //@param _maxPrice 최대시작판매가격
1763     function setMaxStartingPrice(uint256 _maxPrice)
1764     public
1765     onlyCOO
1766     {
1767         GEN0_MAXIMUM_STARTING_PRICE = _maxPrice;
1768     }    
1769 
1770     //@dev setNextGen0Price 상승율을 변경
1771     //@param _increaseRate 가격상승율
1772     function setNextGen0PriceRate(uint256 _increaseRate)
1773     public
1774     onlyCOO
1775     {
1776         require(_increaseRate <= 10000);
1777         nextGen0PriceRate = _increaseRate;
1778     }
1779     
1780 }
1781 
1782 
1783 //@title 포니 경마에 대한 처리를 지원하는 컨트렉트
1784 
1785 contract PonyDerby is PonyMinting {
1786     //@dev 은퇴한 포니 인가를 조회하는 메소드
1787     //@param _pony 포니 정보
1788     //@returns 은퇴 : true, 은퇴하지 않은 경우 false
1789     function isPonyRetired(uint256 _id)
1790     external
1791     view
1792     returns (
1793         bool isRetired
1794 
1795     ) {
1796         Pony storage pony = ponies[_id];
1797         if (pony.age >= pony.retiredAge) {
1798             isRetired = true;
1799         } else {
1800             isRetired = false;
1801         }
1802     }
1803 
1804     //@dev 포니 정보 업데이트
1805     function setPonyInfo(uint _id, uint8 age, uint8 month, uint8 speed, uint8 stamina, uint8 start, uint8 burst, uint8 temperament)
1806     public
1807     onlyDerbyAdress
1808     {       
1809         Pony storage pony = ponies[_id];
1810         pony.age = age;
1811         pony.month = month;
1812 
1813         Ability storage _ability = ability[_id];        
1814         _ability.speed = speed;
1815         _ability.stamina = stamina;
1816         _ability.start = start;
1817         _ability.burst = burst;
1818         _ability.temperament = temperament;
1819     }
1820 
1821     //@dev 포니 maxStat 업데이트
1822     function setPonyMaxStat(uint _id, uint8 maxSpeed, uint8 maxStamina, uint8 maxStart, uint8 maxBurst, uint8 maxTemperament)
1823     public
1824     onlyDerbyAdress
1825     {   
1826         Ability storage _ability = ability[_id];        
1827         _ability.maxSpeed = maxSpeed;
1828         _ability.maxStamina = maxStamina;
1829         _ability.maxStart = maxStart;
1830         _ability.maxBurst = maxBurst;
1831         _ability.maxTemperament = maxTemperament;
1832     }
1833 
1834     //@dev 포니별 능력치 정보를 가져옴
1835     //@param id 포니 아이디
1836     //@return speed 속도
1837     //@return stamina  스태미나
1838     //@return start  스타트
1839     //@return burst 폭발력
1840     //@return temperament  기질
1841     //@return maxSpeed 최대 스피드
1842     //@return maxStamina  최대 스태미나
1843     //@return maxBurst  최대 폭발력
1844     //@return maxStart  최대 스타트
1845     //@return maxTemperament  최대 기질
1846 
1847     function getAbility(uint _id)
1848     public
1849     view
1850     returns (
1851         uint8 speed,
1852         uint8 stamina,
1853         uint8 start,
1854         uint8 burst,
1855         uint8 temperament,
1856         uint8 maxSpeed,
1857         uint8 maxStamina,
1858         uint8 maxBurst,
1859         uint8 maxStart,
1860         uint8 maxTemperament
1861 
1862     ){
1863         Ability memory _ability = ability[_id];
1864         speed = _ability.speed;
1865         stamina = _ability.stamina;
1866         start = _ability.start;
1867         burst = _ability.burst;
1868         temperament = _ability.temperament;
1869         maxSpeed = _ability.maxSpeed;
1870         maxStamina = _ability.maxStamina;
1871         maxBurst = _ability.maxBurst;
1872         maxStart = _ability.maxStart;
1873         maxTemperament = _ability.maxTemperament;
1874     }
1875 
1876 
1877 }
1878 
1879 //@title 포니의 모든 작업을 처리하는 컨트렉트
1880 //@dev 포니 생성시 초기 유전자 코드 설정 필요
1881 
1882 contract PonyCore is PonyDerby {
1883 
1884     address public newContractAddress;
1885 
1886     //@dev PonyCore의 생성자 (최초 한번만 실행됨)
1887     constructor() public payable {
1888         paused = true;
1889         cfoAddress = msg.sender;
1890         cooAddress = msg.sender;
1891     }
1892 
1893     //@param gensis gensis에 대한 유전자 코드
1894     function genesisPonyInit(bytes22 _gensis, uint8[5] _ability, uint8[5] _maxAbility, uint[6] _gen0Stat) external onlyCOO whenPaused {
1895         require(ponies.length==0);
1896         uint zero = uint(0);
1897         uint[2] memory parents = [zero, zero];
1898         uint8[2] memory age = [0, 0];                
1899         _createPony(0, parents, age, _gensis, 100, address(0),_ability,_maxAbility);
1900         setGen0Stat(_gen0Stat);
1901     }
1902 
1903     function setNewAddress(address _v2Address)
1904     external
1905     onlyCOO whenPaused
1906     {
1907         newContractAddress = _v2Address;
1908         emit ContractUpgrade(_v2Address);
1909     }
1910 
1911 
1912     function() external payable {
1913         /*
1914         require(
1915             msg.sender == address(saleAuction) ||
1916             msg.sender == address(siringAuction)
1917         );
1918         */
1919     }
1920 
1921     //@ 포니의 아이디에 해당하는 포니의 정보를 가져옴
1922     //@param _id 포니의 아이디
1923     function getPony(uint256 _id)
1924     external
1925     view
1926     returns (        
1927         bool isReady,
1928         uint256 cooldownEndBlock,        
1929         uint256 birthTime,
1930         uint256 matronId,
1931         uint256 sireId,
1932         bytes22 genes,
1933         uint256 age,
1934         uint256 month,
1935         uint256 retiredAge        
1936     ) {
1937         Pony storage pony = ponies[_id];        
1938         isReady = (pony.cooldownEndBlock <= block.number);
1939         cooldownEndBlock = pony.cooldownEndBlock;        
1940         birthTime = uint256(pony.birthTime);
1941         matronId = uint256(pony.matronId);
1942         sireId = uint256(pony.sireId);
1943         genes =  pony.genes;
1944         age = uint256(pony.age);
1945         month = uint256(pony.month);
1946         retiredAge = uint256(pony.retiredAge);        
1947     }
1948 
1949     //@dev 컨트렉트를 작동시키는 method
1950     //(SaleAuction, SiringAuction, GeneScience 지정되어 있어야하며, newContractAddress가 지정 되어 있지 않아야 함)
1951     //modifier COO
1952     function unPause()
1953     public
1954     onlyCOO
1955     whenPaused
1956     {
1957         require(saleAuction != address(0));
1958         require(siringAuction != address(0));
1959         require(geneScience != address(0));
1960         require(ponyAbility != address(0));
1961         require(newContractAddress == address(0));
1962 
1963         super.unPause();
1964     }
1965 
1966     //@dev 잔액을 인출하는 Method
1967     //modifier CFO
1968     function withdrawBalance(uint256 _value)
1969     external
1970     onlyCLevel
1971     {
1972         uint256 balance = address(this).balance;
1973         require(balance >= _value);        
1974         cfoAddress.transfer(_value);
1975     }
1976 
1977     function buyCarrot(uint256 carrotCount)
1978     external
1979     payable
1980     whenNotPaused
1981     {
1982         emit carrotPurchased(msg.sender, msg.value, carrotCount);
1983     }
1984 
1985     event RewardSendSuccessful(address from, address to, uint value);    
1986 
1987     function sendRankingReward(address[] _recipients, uint256[] _rewards)
1988     external
1989     payable
1990     onlyRewardAdress
1991     {
1992         for(uint i = 0; i < _recipients.length; i++){
1993             _recipients[i].transfer(_rewards[i]);
1994             emit RewardSendSuccessful(this, _recipients[i], _rewards[i]);
1995         }
1996     }
1997 
1998     event CarrotToETHSuccessful(address to, uint256 count, uint value);
1999 
2000     function sendCarrotToETH(address _recipient, uint256 _carrotCount, uint256 _value)
2001     external
2002     payable
2003     onlyRewardAdress
2004     {        
2005         _recipient.transfer(_value);
2006         emit CarrotToETHSuccessful(_recipient, _carrotCount, _value);     
2007     }
2008 
2009 }