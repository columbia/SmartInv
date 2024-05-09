1 pragma solidity ^0.4.18;
2 
3 contract HeroAccessControl {
4     event ContractUpgrade(address newContract);
5     address public leaderAddress;
6     address public opmAddress;
7     
8     bool public paused = false;
9 
10     modifier onlyLeader() {
11         require(msg.sender == leaderAddress);
12         _;
13     }
14     modifier onlyOPM() {
15         require(msg.sender == opmAddress);
16         _;
17     }
18 
19     modifier onlyMLevel() {
20         require(
21             msg.sender == opmAddress ||
22             msg.sender == leaderAddress
23         );
24         _;
25     }
26 
27     function setLeader(address _newLeader) public onlyLeader {
28         require(_newLeader != address(0));
29         leaderAddress = _newLeader;
30     }
31 
32     function setOPM(address _newOPM) public onlyLeader {
33         require(_newOPM != address(0));
34         opmAddress = _newOPM;
35     }
36 
37     function withdrawBalance() external onlyLeader {
38         leaderAddress.transfer(this.balance);
39     }
40 
41 
42     modifier whenNotPaused() {
43         require(!paused);
44         _;
45     }
46 
47     modifier whenPaused {
48         require(paused);
49         _;
50     }
51 
52     function pause() public onlyMLevel whenNotPaused {
53         paused = true;
54     }
55 
56     function unpause() public onlyLeader whenPaused {
57         paused = false;
58     }
59     
60     
61 }
62 
63 
64 contract ERC20{
65 
66 bool public isERC20 = true;
67 
68 function balanceOf(address who) constant returns (uint256);
69 
70 function transfer(address _to, uint256 _value) returns (bool);
71 
72 function transferFrom(address _from, address _to, uint256 _value) returns (bool);
73 
74 function approve(address _spender, uint256 _value) returns (bool);
75 
76 function allowance(address _owner, address _spender) constant returns (uint256);
77 
78 }
79 
80 
81 contract HeroLedger is HeroAccessControl{
82     ERC20 public erc20;
83     
84     mapping (address => uint256) public ownerIndexToERC20Balance;  
85     mapping (address => uint256) public ownerIndexToERC20Used;  
86     uint256 public totalBalance;
87     uint256 public totalUsed;
88     
89     uint256 public totalPromo;
90     uint256 public candy;
91         
92     function setERC20Address(address _address,uint256 _totalPromo,uint256 _candy) public onlyLeader {
93         ERC20 candidateContract = ERC20(_address);
94         require(candidateContract.isERC20());
95         erc20 = candidateContract; 
96         uint256 realTotal = erc20.balanceOf(this); 
97         require(realTotal >= _totalPromo);
98         totalPromo=_totalPromo;
99         candy=_candy;
100     }
101     
102     function setERC20TotalPromo(uint256 _totalPromo,uint256 _candy) public onlyLeader {
103         uint256 realTotal = erc20.balanceOf(this);
104         totalPromo +=_totalPromo;
105         require(realTotal - totalBalance >= totalPromo); 
106         
107         candy=_candy;
108     }
109  
110     function charge(uint256 amount) public {
111     		if(erc20.transferFrom(msg.sender, this, amount)){
112     				ownerIndexToERC20Balance[msg.sender] += amount;
113     				totalBalance +=amount;
114     		}
115     }	
116 		
117 		function collect(uint256 amount) public {
118 				require(ownerIndexToERC20Balance[msg.sender] >= amount);
119     		if(erc20.transfer(msg.sender, amount)){
120     				ownerIndexToERC20Balance[msg.sender] -= amount;
121     				totalBalance -=amount;
122     		}
123     }
124     
125     function withdrawERC20Balance(uint256 amount) external onlyLeader {
126         uint256 realTotal = erc20.balanceOf(this);
127      		require((realTotal -  (totalPromo  + totalBalance- totalUsed ) )  >=amount);
128         erc20.transfer(leaderAddress, amount);
129         totalBalance -=amount;
130         totalUsed -=amount;
131     }
132     
133     
134     function withdrawOtherERC20Balance(uint256 amount, address _address) external onlyLeader {
135     		require(_address != address(erc20));
136     		require(_address != address(this));
137         ERC20 candidateContract = ERC20(_address);
138         uint256 realTotal = candidateContract.balanceOf(this);
139         require( realTotal >= amount );
140         candidateContract.transfer(leaderAddress, amount);
141     }
142     
143 
144 }
145 
146 contract HeroBase is  HeroLedger{
147     event Recruitment(address indexed owner, uint256 heroId, uint256 yinId, uint256 yangId, uint256 talent);
148     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
149     event ItmesChange(uint256 indexed tokenId, uint256 items);
150     
151     address public magicStore;
152 
153     struct Hero {
154         uint256 talent;
155         uint64 recruitmentTime;
156         uint64 cooldownEndTime;
157         uint32 yinId;
158         uint32 yangId;
159         uint16 cooldownIndex;
160         uint16 generation;        
161         uint256 belongings;       
162         uint32 items;
163     }    
164     
165     uint32[14] public cooldowns = [
166     
167         uint32(1 minutes),
168         uint32(2 minutes),
169         uint32(5 minutes),
170         uint32(10 minutes),
171         uint32(30 minutes),
172         uint32(1 hours),
173         uint32(2 hours),
174         uint32(4 hours),
175         uint32(8 hours),
176         uint32(16 hours),
177         uint32(1 days),
178         uint32(2 days),
179         uint32(4 days),
180         uint32(7 days)
181     ];
182         
183     uint128 public cdFee = 118102796674000; 
184 
185     Hero[] heroes;
186     mapping (uint256 => address) public heroIndexToOwner;
187     mapping (address => uint256) ownershipTokenCount;
188 
189     mapping (uint256 => address) public heroIndexToApproved;   
190     mapping (uint256 => uint32) public heroIndexToWin;   
191     mapping (uint256 => uint32) public heroIndexToLoss;
192   
193     function _transfer(address _from, address _to, uint256 _tokenId) internal {
194         ownershipTokenCount[_to]++;
195         heroIndexToOwner[_tokenId] = _to;
196         if (_from != address(0)) {
197             ownershipTokenCount[_from]--;
198             delete heroIndexToApproved[_tokenId];
199         }
200         Transfer(_from, _to, _tokenId);
201     }
202 
203     function _createHero(
204         uint256 _yinId,
205         uint256 _yangId,
206         uint256 _generation,
207         uint256 _talent,
208         address _owner
209 	)
210         internal
211         returns (uint)
212     {
213         require(_generation <= 65535);
214        
215         
216         uint16 _cooldownIndex = uint16(_generation/2);
217         if(_cooldownIndex > 13){
218         	_cooldownIndex =13;
219         }   
220         Hero memory _hero = Hero({
221             talent: _talent,
222             recruitmentTime: uint64(now),
223             cooldownEndTime: 0,
224             yinId: uint32(_yinId),
225             yangId: uint32(_yangId),
226             cooldownIndex: _cooldownIndex,
227             generation: uint16(_generation),
228             belongings: _talent,
229             items: uint32(0)
230         });
231         uint256 newHeroId = heroes.push(_hero) - 1;
232         require(newHeroId <= 4294967295);
233         Recruitment(
234             _owner,
235             newHeroId,
236             uint256(_hero.yinId),
237             uint256(_hero.yangId),
238             _hero.talent
239         );
240         _transfer(0, _owner, newHeroId);
241 
242         return newHeroId;
243     } 
244     
245     function setMagicStore(address _address) public onlyOPM{
246        magicStore = _address;
247     }
248  
249 }
250 
251 contract ERC721 {
252     function implementsERC721() public pure returns (bool);
253     function totalSupply() public view returns (uint256 total);
254     function balanceOf(address _owner) public view returns (uint256 balance);
255     function ownerOf(uint256 _tokenId) public view returns (address owner);
256     function approve(address _to, uint256 _tokenId) public;
257     function transferFrom(address _from, address _to, uint256 _tokenId) public;
258     function transfer(address _to, uint256 _tokenId) public;
259     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
260     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
261 }
262 
263 contract HeroOwnership is HeroBase, ERC721 {
264 
265     string public name = "MyHero";
266     string public symbol = "MH";
267 
268     function implementsERC721() public pure returns (bool)
269     {
270         return true;
271     }
272     
273     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
274         return heroIndexToOwner[_tokenId] == _claimant;
275     }
276 
277     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
278         return heroIndexToApproved[_tokenId] == _claimant;
279     }
280 
281     function _approve(uint256 _tokenId, address _approved) internal {
282         heroIndexToApproved[_tokenId] = _approved;
283     }
284 
285     function rescueLostHero(uint256 _heroId, address _recipient) public onlyOPM whenNotPaused {
286         require(_owns(this, _heroId));
287         _transfer(this, _recipient, _heroId);
288     }
289 
290     function balanceOf(address _owner) public view returns (uint256 count) {
291         return ownershipTokenCount[_owner];
292     }
293 
294     function transfer(
295         address _to,
296         uint256 _tokenId
297     )
298         public
299     {
300         require(_to != address(0));
301         require(_owns(msg.sender, _tokenId));
302         _transfer(msg.sender, _to, _tokenId);
303     }
304 
305     function approve(
306         address _to,
307         uint256 _tokenId
308     )
309         public
310         whenNotPaused
311     {
312         require(_owns(msg.sender, _tokenId));
313         _approve(_tokenId, _to);
314         Approval(msg.sender, _to, _tokenId);
315     }
316 
317     function transferFrom(
318         address _from,
319         address _to,
320         uint256 _tokenId
321     )
322         public
323     {
324         require(_approvedFor(msg.sender, _tokenId));
325         require(_owns(_from, _tokenId));
326         _transfer(_from, _to, _tokenId);
327     }
328 
329     function totalSupply() public view returns (uint) {
330         return heroes.length - 1;
331     }
332 
333     function ownerOf(uint256 _tokenId)
334         public
335         view
336         returns (address owner)
337     {
338         owner = heroIndexToOwner[_tokenId];
339 
340         require(owner != address(0));
341     }
342 
343     function tokensOfOwnerByIndex(address _owner, uint256 _index)
344         external
345         view
346         returns (uint256 tokenId)
347     {
348         uint256 count = 0;
349         for (uint256 i = 1; i <= totalSupply(); i++) {
350             if (heroIndexToOwner[i] == _owner) {
351                 if (count == _index) {
352                     return i;
353                 } else {
354                     count++;
355                 }
356             }
357         }
358         revert();
359     }
360 
361 }
362 
363 contract MasterRecruitmentInterface {
364     function isMasterRecruitment() public pure returns (bool);   
365     function fightMix(uint256 belongings1, uint256 belongings2) public returns (bool,uint256,uint256,uint256);    
366 }
367 
368 
369 contract HeroFighting is HeroOwnership {
370   
371     MasterRecruitmentInterface public masterRecruitment;
372     function setMasterRecruitmentAddress(address _address) public onlyLeader {
373         MasterRecruitmentInterface candidateContract = MasterRecruitmentInterface(_address);
374         require(candidateContract.isMasterRecruitment());
375         masterRecruitment = candidateContract;
376     }
377 
378     function _triggerCooldown(Hero storage _newHero) internal {
379         _newHero.cooldownEndTime = uint64(now + cooldowns[_newHero.cooldownIndex]);
380         if (_newHero.cooldownIndex < 13) {
381             _newHero.cooldownIndex += 1;
382         }
383     }
384 
385     function isReadyToFight(uint256 _heroId)
386         public
387         view
388         returns (bool)
389     {
390         require(_heroId > 0);
391 	      Hero memory hero = heroes[_heroId];
392         return (hero.cooldownEndTime <= now);
393     }
394 
395     function _fight(uint32 _yinId, uint32 _yangId)
396         internal 
397         whenNotPaused
398         returns(uint256)
399     {
400         Hero storage yin = heroes[_yinId];
401         require(yin.recruitmentTime != 0);
402         Hero storage yang = heroes[_yangId];
403         uint16 parentGen = yin.generation;
404         if (yang.generation > yin.generation) {
405             parentGen = yang.generation;
406         }        
407         var (flag, childTalent, belongings1,  belongings2) = masterRecruitment.fightMix(yin.belongings,yang.belongings);
408         yin.belongings = belongings1;
409         yang.belongings = belongings2;                
410 	      if(!flag){      
411            (_yinId,_yangId) = (_yangId,_yinId);
412         }    
413         address owner = heroIndexToOwner[_yinId];
414         heroIndexToWin[_yinId] +=1;
415         heroIndexToLoss[_yangId] +=1;
416         uint256 newHeroId = _createHero(_yinId, _yangId, parentGen + 1, childTalent, owner); 
417         _triggerCooldown(yang);
418         _triggerCooldown(yin);
419         return (newHeroId );
420     }
421     
422     
423    
424     
425      function reduceCDFee(uint256 heroId) 
426          public 
427          view 
428          returns (uint256 fee)
429     {
430     		Hero memory hero = heroes[heroId];
431     		require(hero.cooldownEndTime > now);
432     		uint64 cdTime = uint64(hero.cooldownEndTime-now);
433     		fee= uint256(cdTime * cdFee * (hero.cooldownIndex+1));
434     		
435     }
436     
437     
438     
439 }
440 
441 
442 contract ClockAuction {
443     //bool public isClockAuction = true;
444     
445     function withdrawBalance() external ;
446       
447     function order(uint256 _tokenId, uint256 orderAmount ,address buyer)
448         public  returns (bool);
449     
450      function createAuction(
451         uint256 _tokenId,
452         uint256 _startingPrice,
453         uint256 _endingPrice,
454         uint256 _startingPriceEth,
455         uint256 _endingPriceEth,
456         uint256 _duration,
457         address _seller
458     )
459         public;
460     
461     function getSeller(uint256 _tokenId)
462         public
463         returns
464     (
465         address seller
466     ); 
467     
468      function getCurrentPrice(uint256 _tokenId, uint8 ccy)
469         public
470         view
471         returns (uint256);
472         
473 }
474 
475 contract FightClockAuction is ClockAuction {
476     bool public isFightClockAuction = true;
477 }
478 
479 contract SaleClockAuction is ClockAuction {
480     bool public isSaleClockAuction = true;
481     function averageGen0SalePrice() public view returns (uint256);
482 }
483 
484 contract HeroAuction is HeroFighting {
485 
486 		SaleClockAuction public saleAuction;
487     FightClockAuction public fightAuction;
488     uint256 public ownerCut =500;    
489     
490     function setSaleAuctionAddress(address _address) public onlyLeader {
491         SaleClockAuction candidateContract = SaleClockAuction(_address);
492         require(candidateContract.isSaleClockAuction());
493         saleAuction = candidateContract;
494     }
495 
496     function setFightAuctionAddress(address _address) public onlyLeader {
497         FightClockAuction candidateContract = FightClockAuction(_address);
498         require(candidateContract.isFightClockAuction());
499         fightAuction = candidateContract;
500     }
501     
502 
503     function createSaleAuction(
504         uint256 _heroId,
505         uint256 _startingPrice,
506         uint256 _endingPrice,
507         uint256 _startingPriceEth,
508         uint256 _endingPriceEth,
509         uint256 _duration
510     )
511         public
512     {
513         require(_owns(msg.sender, _heroId));
514         _approve(_heroId, saleAuction);
515         saleAuction.createAuction(
516             _heroId,
517             _startingPrice,
518             _endingPrice,
519             _startingPriceEth,
520             _endingPriceEth,
521             _duration,
522             msg.sender
523         );
524     }
525     
526     function orderOnSaleAuction(
527         uint256 _heroId,
528         uint256 orderAmount
529     )
530         public
531     {
532         require(ownerIndexToERC20Balance[msg.sender] >= orderAmount); 
533         address saller = saleAuction.getSeller(_heroId);
534         uint256 price = saleAuction.getCurrentPrice(_heroId,1);
535         require( price <= orderAmount && saller != address(0));
536        
537         if(saleAuction.order(_heroId, orderAmount, msg.sender)  &&orderAmount >0 ){
538          
539 	          ownerIndexToERC20Balance[msg.sender] -= orderAmount;
540 	    		  ownerIndexToERC20Used[msg.sender] += orderAmount;  
541 	    		  
542 	    		  if( saller == address(this)){
543 	    		     totalUsed +=orderAmount;
544 	    		  }else{
545 	    		     uint256 cut = _computeCut(price);
546 	    		     totalUsed += (orderAmount - price +cut);
547 	    		     ownerIndexToERC20Balance[saller] += price -cut;
548 	    		  }	
549          } 
550           
551         
552     }
553     
554 
555     function createFightAuction(
556         uint256 _heroId,
557         uint256 _startingPrice,
558         uint256 _endingPrice,
559         uint256 _duration
560     )
561         public
562         whenNotPaused
563     {
564         require(_owns(msg.sender, _heroId));
565         require(isReadyToFight(_heroId));
566         _approve(_heroId, fightAuction);
567         fightAuction.createAuction(
568             _heroId,
569             _startingPrice,
570             _endingPrice,
571             0,
572             0,
573             _duration,
574             msg.sender
575         );
576     }    
577 
578     function orderOnFightAuction(
579         uint256 _yangId,
580         uint256 _yinId,
581         uint256 orderAmount
582     )
583         public
584         whenNotPaused
585     {
586         require(_owns(msg.sender, _yinId));
587         require(isReadyToFight(_yinId));
588         require(_yinId !=_yangId);
589         require(ownerIndexToERC20Balance[msg.sender] >= orderAmount);
590         
591         address saller= fightAuction.getSeller(_yangId);
592         uint256 price = fightAuction.getCurrentPrice(_yangId,1);
593       
594         require( price <= orderAmount && saller != address(0));
595         
596         if(fightAuction.order(_yangId, orderAmount, msg.sender)){
597 	         _fight(uint32(_yinId), uint32(_yangId));
598 	        ownerIndexToERC20Balance[msg.sender] -= orderAmount;
599 	    		ownerIndexToERC20Used[msg.sender] += orderAmount;  
600 	    		
601     		  if( saller == address(this)){
602     		     totalUsed +=orderAmount;
603     		  }else{
604     		     uint256 cut = _computeCut(price);
605     		     totalUsed += (orderAmount - price+cut);
606     		     ownerIndexToERC20Balance[saller] += price-cut;
607     		  }	  
608 	        
609         }
610     }
611 
612     function withdrawAuctionBalances() external onlyOPM {
613         saleAuction.withdrawBalance();
614         fightAuction.withdrawBalance();
615     }
616     
617     function setCut(uint256 newCut) public onlyOPM{
618         ownerCut = newCut;
619     }
620     
621     
622     function _computeCut(uint256 _price) internal view returns (uint256) {
623         return _price * ownerCut / 10000;
624     }  
625     
626     
627     function promoBun(address _address) public {
628         require(msg.sender == address(saleAuction));
629         if(totalPromo >= candy && candy > 0){
630           ownerIndexToERC20Balance[_address] += candy;
631           totalPromo -=candy;
632          }
633     } 
634 
635 }
636 
637 contract HeroMinting is HeroAuction {
638 
639     uint256 public promoCreationLimit = 5000;
640     uint256 public gen0CreationLimit = 50000;
641     
642     uint256 public gen0StartingPrice = 100000000000000000;
643     uint256 public gen0AuctionDuration = 1 days;
644 
645     uint256 public promoCreatedCount;
646     uint256 public gen0CreatedCount;
647 
648     function createPromoHero(uint256 _talent, address _owner) public onlyOPM {
649         if (_owner == address(0)) {
650              _owner = opmAddress;
651         }
652         require(promoCreatedCount < promoCreationLimit);
653         require(gen0CreatedCount < gen0CreationLimit);
654 
655         promoCreatedCount++;
656         gen0CreatedCount++;
657         _createHero(0, 0, 0, _talent, _owner);
658     }
659 
660     function createGen0Auction(uint256 _talent,uint256 price) public onlyOPM {
661         require(gen0CreatedCount < gen0CreationLimit);
662         require(price < 340282366920938463463374607431768211455);
663 
664         uint256 heroId = _createHero(0, 0, 0, _talent, address(this));
665         _approve(heroId, saleAuction);
666 				if(price == 0 ){
667 				     price = _computeNextGen0Price();
668 				}
669 				
670         saleAuction.createAuction(
671             heroId,
672             price *1000,
673             0,
674             price,
675             0,
676             gen0AuctionDuration,
677             address(this)
678         );
679 
680         gen0CreatedCount++;
681     }
682 
683     function _computeNextGen0Price() internal view returns (uint256) {
684         uint256 avePrice = saleAuction.averageGen0SalePrice();
685 
686         require(avePrice < 340282366920938463463374607431768211455);
687 
688         uint256 nextPrice = avePrice + (avePrice / 2);
689 
690         if (nextPrice < gen0StartingPrice) {
691             nextPrice = gen0StartingPrice;
692         }
693 
694         return nextPrice;
695     }
696     
697     
698 }
699 
700 contract HeroCore is HeroMinting {
701 
702     address public newContractAddress;
703 
704     function HeroCore() public {
705 
706         paused = true;
707 
708         leaderAddress = msg.sender;
709 
710         opmAddress = msg.sender;
711 
712         _createHero(0, 0, 0, uint256(-1), address(0));
713     }
714 
715     function setNewAddress(address _v2Address) public onlyLeader whenPaused {
716         newContractAddress = _v2Address;
717         ContractUpgrade(_v2Address);
718     }
719 
720     function() external payable {
721         require(
722             msg.sender != address(0)
723         );
724     }
725     
726     function getHero(uint256 _id)
727         public
728         view
729         returns (
730         bool isReady,
731         uint256 cooldownIndex,
732         uint256 nextActionAt,
733         uint256 recruitmentTime,
734         uint256 yinId,
735         uint256 yangId,
736         uint256 generation,
737 	      uint256 talent,
738 	      uint256 belongings,
739 	      uint32 items
740 	    
741     ) {
742         Hero storage her = heroes[_id];
743         isReady = (her.cooldownEndTime <= now);
744         cooldownIndex = uint256(her.cooldownIndex);
745         nextActionAt = uint256(her.cooldownEndTime);
746         recruitmentTime = uint256(her.recruitmentTime);
747         yinId = uint256(her.yinId);
748         yangId = uint256(her.yangId);
749         generation = uint256(her.generation);
750 	      talent = her.talent;
751 	      belongings = her.belongings;
752 	      items = her.items;
753     }
754 
755     function unpause() public onlyLeader whenPaused {
756         require(saleAuction != address(0));
757         require(fightAuction != address(0));
758         require(masterRecruitment != address(0));
759         require(erc20 != address(0));
760         require(newContractAddress == address(0));
761 
762         super.unpause();
763     }
764     
765     
766      function setNewCdFee(uint128 _cdFee) public onlyOPM {
767         cdFee = _cdFee;
768     }
769      
770     function reduceCD(uint256 heroId,uint256 reduceAmount) 
771          public  
772          whenNotPaused 
773     {
774     		Hero storage hero = heroes[heroId];
775     		require(hero.cooldownEndTime > now);
776     		require(ownerIndexToERC20Balance[msg.sender] >= reduceAmount);
777     		
778     		uint64 cdTime = uint64(hero.cooldownEndTime-now);
779     		require(reduceAmount >= uint256(cdTime * cdFee * (hero.cooldownIndex+1)));
780     		
781     		ownerIndexToERC20Balance[msg.sender] -= reduceAmount;
782     		ownerIndexToERC20Used[msg.sender] += reduceAmount;  
783         totalUsed +=reduceAmount;
784     		hero.cooldownEndTime = uint64(now);
785     }
786     
787     function useItems(uint32 _items, uint256 tokenId, address owner, uint256 fee) public returns (bool flag){
788       require(msg.sender == magicStore);
789       require(owner == heroIndexToOwner[tokenId]);        
790          heroes[tokenId].items=_items;
791          ItmesChange(tokenId,_items);      
792       ownerIndexToERC20Balance[owner] -= fee;
793     	ownerIndexToERC20Used[owner] += fee;  
794       totalUsed +=fee;
795       
796       flag = true;
797     }
798 
799 }