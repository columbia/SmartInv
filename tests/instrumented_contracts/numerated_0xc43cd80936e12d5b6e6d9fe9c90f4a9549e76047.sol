1 pragma solidity ^0.4.23;
2 
3 
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11   function ownable() public {
12     owner = msg.sender;
13   }
14 
15   modifier onlyOwner() {
16     require(msg.sender == owner);
17     _;
18   }
19 
20   function transferOwnership(address newOwner) onlyOwner public {
21     require(newOwner != address(0));
22   emit OwnershipTransferred(owner, newOwner);
23     owner = newOwner;
24   }
25 
26 }
27 
28 
29 contract ERC721 {
30     
31     function totalSupply() public view returns (uint256 total);
32     function balanceOf(address _owner) public view returns (uint256 balance);
33     function ownerOf(uint256 _tokenId) external view returns (address owner);
34     function approve(address _to, uint256 _tokenId) external;
35     function transfer(address _to, uint256 _tokenId) external payable;
36     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
37 
38 
39     event Transfer(address from, address to, uint256 tokenId);
40     event Approval(address owner, address approved, uint256 tokenId); 
41     
42     
43     
44 }
45 
46 
47 
48 contract SaddleControl  {
49 
50     address public ceoAddress=0xC87959bbafD5cDCbC5E29C92E3161f59f51d5794;
51     
52     address public ctoAddress=0x6c2324c462184058C6ce28339C39FF04b9d9bEf1;
53  
54         
55 
56     modifier onCEO() {
57         require(msg.sender == ceoAddress);
58         _;
59     }
60 
61     modifier onCTO() {
62         require(msg.sender == ctoAddress);
63         _;
64     }
65 
66     modifier onlyC() {
67         require(
68             msg.sender == ceoAddress ||
69             msg.sender == ctoAddress
70         );
71         _;
72     }
73     
74     
75     
76     address public raceDistCon;
77         
78 
79     address public addr_Saddlery;
80    
81 
82 
83             
84         function newSaddleryCon (address newConAddr) external onCTO {
85             addr_Saddlery = newConAddr;
86             
87         }
88             
89         function newRaceDistCon (address newConAddr) external onCTO {
90             raceDistCon = newConAddr;
91             
92         }
93             
94     
95             
96 
97     
98     
99 
100  
101 }
102 
103 contract SaddleShopOwner is SaddleControl, ERC721 {
104     
105 
106     
107     mapping (uint256 => address) public SaddleShopO;
108     
109     mapping (uint256 => uint256) public SaddleShopPrice;
110     
111     mapping (uint256 => bool) public SaddleShopForSale;
112     mapping (uint256 => bool) public SaddleShopForBiding;
113     
114     mapping (address => uint256) SaddleShopOwnCount;
115     
116      uint256 public SaddleShopSaleFee = 20;
117    
118   
119         mapping (uint256 => uint256)  startBlock;
120       
121     mapping (uint256 => uint256) startPrice;
122     mapping (uint256 => uint256) public shopPriceDecreaseRate;
123     
124 
125       function getCurrentItemPrice(uint256 _id) public view returns (uint256)  {
126           
127         uint256  currentPrice =startPrice[_id] - shopPriceDecreaseRate[_id]*(block.number - startBlock[_id]);
128           
129            if(currentPrice <=0 ){
130       return 0;
131   }else if(currentPrice>startPrice[_id]){
132       
133       return 0;
134   }else{
135       
136     return currentPrice;
137   }
138   
139   
140   }
141     
142       function newPriceDecreaseRate(uint DecreRate,uint256 _id) external onlyC   {
143                 shopPriceDecreaseRate[_id]=DecreRate;
144   }
145     
146     
147     
148     function changeSaddleShopPrice(uint256 price, uint256 SadShopId) external{
149         
150         require(msg.sender==SaddleShopO[SadShopId]);
151         
152         require(SaddleShopForSale[SadShopId]==true);
153         
154         require(price!=0);
155         
156         SaddleShopPrice[SadShopId]=price;
157         
158     }
159     
160     
161     function buySaddleShop(uint256 id) payable external{
162         
163           require(SaddleShopForSale[id]==true);
164          
165               uint256 price = SaddleShopPrice[id];
166             
167             require(price<=msg.value);
168             
169          uint256 Fee = price / SaddleShopSaleFee ;
170             
171           uint256  oPrice= price - Fee;
172             
173             address _to = msg.sender;
174             address _from = SaddleShopO[id];
175             
176             SaddleShopOwnCount[_to]++;
177             
178             SaddleShopO[id] = _to;
179             
180             SaddleShopForSale[id]=false;
181             
182             
183                 SaddleShopOwnCount[_from]--;
184                
185            emit Transfer(_from, _to, id);
186            
187              ceoAddress.transfer(Fee);
188             
189             if(_from!=0){
190                 
191              _from.transfer(oPrice);
192             }else{
193                 
194              ceoAddress.transfer(oPrice);
195             }
196              
197              
198              
199             uint256 buyExcess = msg.value - oPrice - Fee;
200             _to.transfer(buyExcess);
201       
202         
203     }
204     
205 
206     
207     function firstSellSaddleShop(uint256 _id, uint256 price, uint256 _decreRate) external onlyC {
208         
209         require(SaddleShopO[_id]==0);
210         
211         SaddleShopPrice[_id]=price;
212         
213             
214                 SaddleShopForBiding[_id]=true;
215                 
216                   startBlock[_id] = block.number;
217                   
218                   startPrice[_id] = price;
219                   
220                  shopPriceDecreaseRate[_id]= _decreRate;
221                 
222     }
223     
224     function bid(uint256 _id) payable external{
225       
226         
227         
228         uint256 priceNow = getCurrentItemPrice(_id);
229         require(msg.value>=priceNow);
230         
231         require(SaddleShopForBiding[_id]==true);
232         
233           if(priceNow<=0||priceNow>=startPrice[_id]){
234         SaddleShopForBiding[_id]=false;
235               _to.transfer( msg.value);
236               
237               //besser regeln!!
238         }else{
239             
240         
241         SaddleShopForBiding[_id]=false;
242         
243             
244             address _to = msg.sender;
245             address _from = SaddleShopO[_id];
246             
247             SaddleShopOwnCount[_to]++;
248             
249             SaddleShopO[_id] = _to;
250             
251             SaddleShopForSale[_id]=true;
252             
253             uint256 priceAufschlag=msg.value/3;
254             
255             
256    SaddleShopPrice[_id]=msg.value+ priceAufschlag;
257                
258            emit Transfer(_from, _to, _id);
259             
260              ceoAddress.transfer(priceNow);
261          
262              
263             uint256 buyExcess = msg.value - priceNow;
264             _to.transfer(buyExcess);
265         }
266         
267         
268       
269     }
270     
271     
272      function setSaddleShopSaleFee(uint256 val) external onCTO {
273         SaddleShopSaleFee = val;
274     }
275     
276 }
277 
278 contract SaddleBasis is  SaddleShopOwner {
279     
280     
281    
282     event Birth(address owner, uint256 SaddleId);
283    
284     event Transfer(address from, address to, uint256 tokenId);
285 
286     struct SaddleAttr {
287         
288         uint256 dna1; 
289         uint256 dna2; 
290         uint256 dna3;
291 
292         bool dna4; 
293         
294         
295     }
296 
297 
298     SaddleAttr[] Saddles;
299 
300     mapping (uint256 => address) SaddleOwnerIndex;
301     
302     mapping (uint256 => uint256) public saddleIndexPrice;
303     
304     mapping (uint256 => uint256) public saddleQuality;
305     
306     
307     
308     mapping (uint256 => bool) SaddleIndexForSale;
309 
310     mapping (address => uint256) tokenOwnershipCount;
311     
312     mapping (uint256 => bool)  raceListed;
313     
314     mapping (uint256 => bool) public DutchAListed;
315     
316     mapping (uint256 => uint256)  startDutchABlock;
317       
318     mapping (uint256 => uint256) startDutchAPrice;
319     
320     mapping (uint256 => uint256) public DutchADecreaseRate;
321     
322     
323 
324 
325   uint256 public saleFee = 20;
326    
327 
328 
329  
330     function _transfer(address _from, address _to, uint256 _tokenId) internal {
331         tokenOwnershipCount[_to]++;
332         SaddleOwnerIndex[_tokenId] = _to;
333         
334         if (_from != address(0)) {
335             tokenOwnershipCount[_from]--;
336          
337         }
338        emit Transfer(_from, _to, _tokenId);
339        
340     }
341     
342     
343  
344     function transfer10( address _to, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3, uint256 _tokenId4, uint256 _tokenId5, uint256 _tokenId6, uint256 _tokenId7, uint256 _tokenId8, uint256 _tokenId9, uint256 _tokenId10  ) external onlyC {
345      
346        require(_to != address(0));
347 		
348         require(_to != address(this));
349      
350      require( SaddleOwnerIndex[_tokenId1] == msg.sender );
351      require( SaddleOwnerIndex[_tokenId2] == msg.sender );
352      require( SaddleOwnerIndex[_tokenId3] == msg.sender );
353      require( SaddleOwnerIndex[_tokenId4] == msg.sender );
354      require( SaddleOwnerIndex[_tokenId5] == msg.sender );
355      require( SaddleOwnerIndex[_tokenId6] == msg.sender );
356      require( SaddleOwnerIndex[_tokenId7] == msg.sender );
357      require( SaddleOwnerIndex[_tokenId8] == msg.sender );
358      require( SaddleOwnerIndex[_tokenId9] == msg.sender );
359      require( SaddleOwnerIndex[_tokenId10] == msg.sender );
360       
361       
362       
363       _transfer(msg.sender,  _to,  _tokenId1);
364         
365    
366       _transfer(msg.sender,  _to,  _tokenId2);
367      
368       _transfer(msg.sender,  _to,  _tokenId3);
369        
370       _transfer(msg.sender,  _to,  _tokenId4);
371   
372       _transfer(msg.sender,  _to,  _tokenId5);
373        
374       _transfer(msg.sender,  _to,  _tokenId6);
375         
376       _transfer(msg.sender,  _to,  _tokenId7);
377        
378       _transfer(msg.sender,  _to,  _tokenId8);
379       
380       
381       _transfer(msg.sender,  _to,  _tokenId9);
382       _transfer(msg.sender,  _to,  _tokenId10);
383        
384     }
385     
386     function _sell(address _from,  uint256 _tokenId, uint256 value) internal {
387      
388            uint256 price;
389             
390             
391          if(DutchAListed[_tokenId]==true){
392              
393         price  = getCurrentSaddlePrice(_tokenId);
394                 
395          }else{
396              
397         price  = saddleIndexPrice[_tokenId];
398              
399          }
400          
401          if(price==0){
402              SaddleIndexForSale[_tokenId]=false;
403          }
404          
405      if(SaddleIndexForSale[_tokenId]==true){
406           
407             require(price<=value);
408             
409             
410             
411          uint256 Fee = price / saleFee /2;
412             
413           uint256  oPrice= price - Fee - Fee;
414             
415             address _to = msg.sender;
416             
417             tokenOwnershipCount[_to]++;
418             SaddleOwnerIndex[_tokenId] = _to;
419             
420             SaddleIndexForSale[_tokenId]=false;
421          DutchAListed[_tokenId]=false;
422             
423             
424             if (_from != address(0)) {
425                 tokenOwnershipCount[_from]--;
426                
427             }
428                  
429            emit Transfer(_from, _to, _tokenId);
430             
431             uint256 saddleQ = saddleQuality[_tokenId]/10;
432              address SaddleSOwner;
433              
434               if(saddleQ>=0&&saddleQ<=2){
435               SaddleSOwner= SaddleShopO[5];
436                  
437              }else  if(saddleQ>=2&&saddleQ<=4){
438               SaddleSOwner= SaddleShopO[4];
439                  
440              } else  if(saddleQ>=4&&saddleQ<=6){
441              SaddleSOwner=  SaddleShopO[3];
442                  
443              } else  if(saddleQ>=6&&saddleQ<=8){
444              SaddleSOwner=  SaddleShopO[2];
445                  
446              }else  if(saddleQ>=8&&saddleQ<=10){
447              SaddleSOwner=  SaddleShopO[1];
448                  
449              }else{
450                  
451              SaddleSOwner= ceoAddress;
452              }
453              
454             
455              
456              _from.transfer(oPrice);
457              
458             uint256 bidExcess = value - oPrice - Fee - Fee;
459             _to.transfer(bidExcess);
460              
461              ceoAddress.transfer(Fee);
462              
463              if(SaddleSOwner!=0){
464                  
465              SaddleSOwner.transfer(Fee);
466              }else {
467              ceoAddress.transfer(Fee);
468                  
469              }
470             
471             
472      }else{
473           _to.transfer(value);
474      }
475       
476     }
477     
478     
479     
480     
481     
482     
483 
484       function getCurrentSaddlePrice(uint256 _id) public view returns (uint256)  {
485           
486       uint256     currentPrice= startDutchAPrice[_id] - DutchADecreaseRate[_id]*(block.number - startDutchABlock[_id]);
487   if(currentPrice <=0 ){
488       return 0;
489   }else if(currentPrice>startDutchAPrice[_id]){
490       
491       return 0;
492   }else{
493       
494     return currentPrice;
495   }
496   }
497     
498       function newDutchPriceRate(uint DecreRate,uint256 _id) external  {
499                
500                require(msg.sender==SaddleOwnerIndex[_id]);
501                
502                require(DutchAListed[_id]==true);
503                
504                 DutchADecreaseRate[_id]=DecreRate;
505   }
506     
507     
508     
509     
510        
511     function setForDutchSale(uint256 _id, uint256 price, uint256 _decreRate) external {
512         
513                require(msg.sender==SaddleOwnerIndex[_id]);
514         
515                  require(raceListed[_id]==false);
516                  
517         SaddleShopPrice[_id]=price;
518         
519             
520                 DutchAListed[_id]=true;
521                 
522                   startDutchABlock[_id] = block.number;
523                   
524                   startDutchAPrice[_id] = price;
525                   
526                  DutchADecreaseRate[_id]= _decreRate;
527                  
528                 SaddleIndexForSale[_id]=true;
529     }
530     
531   
532     
533     
534     
535     
536 	
537     function _newSaddle(
538         uint256 _genes1,
539         uint256 _genes2,
540         uint256 _genes3,
541         bool _genes4,
542         address _owner
543     )
544         internal
545         returns (uint)
546     {
547    
548    
549    
550    
551         SaddleAttr memory _saddle = SaddleAttr({
552           dna1:_genes1,  
553         dna2: _genes2,
554         dna3 : _genes3,
555         dna4: _genes4
556             
557         });
558        
559        
560         
561        uint256 newSaddleId;
562 	   
563      newSaddleId = Saddles.push(_saddle)-1;
564      
565   
566         require(newSaddleId == uint256(uint32(newSaddleId)));
567 
568 
569         
570        saddleQuality[newSaddleId]= (_genes1 +_genes2 + _genes3)/3;
571         
572         raceListed[newSaddleId]=false;
573         
574        emit Birth(_owner, newSaddleId);
575 
576         _transfer(0, _owner, newSaddleId);
577 
578         return newSaddleId;  
579     }
580 
581 
582 
583 }
584 
585 
586 contract SaddleOwnership is SaddleBasis{
587 
588   string public constant  name = "CryptoSaddle";
589     string public constant symbol = "CSD";
590      uint8 public constant decimals = 0; 
591 
592     function SaddleForSale(uint256 _tokenId, uint256 price) external { 
593   
594      address  ownerof =  SaddleOwnerIndex[_tokenId];
595         require(ownerof == msg.sender);
596         
597                  require(raceListed[_tokenId]==false);
598                  
599        uint256 forDutch =  getCurrentSaddlePrice(_tokenId);
600   
601       require(forDutch==0||DutchAListed[_tokenId]==false);
602                  
603         saddleIndexPrice[_tokenId] = price;
604        SaddleIndexForSale[_tokenId]= true;
605        DutchAListed[_tokenId]=false;
606        
607        
608 		}
609 		
610 
611 		
612  function changePrice(uint256 _tokenId, uint256 price) external {
613   
614      address  ownerof =  SaddleOwnerIndex[_tokenId];
615         require(ownerof == msg.sender);
616         require(SaddleIndexForSale[_tokenId] == true);
617   
618   
619       require(DutchAListed[_tokenId]==false);
620           
621              saddleIndexPrice[_tokenId] = price;
622       
623              
624          
625 		}
626 
627  function SaddleNotForSale(uint256 _tokenId) external {
628          address  ownerof =  SaddleOwnerIndex[_tokenId];
629             require(ownerof == msg.sender);
630        SaddleIndexForSale[_tokenId]= false;
631          DutchAListed[_tokenId]=false;
632 
633     }
634 
635 
636     function _owns(address _applicant, uint256 _tokenId) internal view returns (bool) {
637         return SaddleOwnerIndex[_tokenId] == _applicant;
638     }
639 
640 
641     function balanceOf(address _owner) public view returns (uint256 count) {
642         return tokenOwnershipCount[_owner];
643     }
644 
645     function transfer(
646         address _to,
647         uint256 _tokenId
648     )
649         external
650         payable
651     {
652         require(_to != address(0));
653 		
654         require(_to != address(this));
655  
656         require(_owns(msg.sender, _tokenId));
657        _transfer(msg.sender, _to, _tokenId);
658     }
659 
660     function approve(
661         address _to,
662         uint256 _tokenId
663     )
664         external 
665     {
666        require(_owns(msg.sender, _tokenId));
667 
668         emit Approval(msg.sender, _to, _tokenId);
669     }
670 
671     function transferFrom(address _from, address _to, uint256 _tokenId ) external payable {
672         
673         if(_from != msg.sender){
674               require(_to == msg.sender);
675                  
676                  require(raceListed[_tokenId]==false);
677                  
678                 require(_from==SaddleOwnerIndex[_tokenId]);
679         
680                _sell(_from,  _tokenId, msg.value);
681             
682         }else{
683             
684           _to.transfer(msg.value);
685         }
686  
687     }
688 
689     function totalSupply() public view returns (uint) {
690         return Saddles.length;
691     }
692 
693     function ownerOf(uint256 _tokenId)  external view returns (address owner)  {
694         owner = SaddleOwnerIndex[_tokenId];
695 
696        return;
697        
698     }
699     
700     function ownerOfID(uint256 _tokenId)  external view returns (address owner, uint256 tokenId)  {
701         owner = SaddleOwnerIndex[_tokenId];
702 tokenId=_tokenId;
703        return;
704        
705     }
706 
707        function SaddleFS(uint256 _tokenId) external view  returns (bool buyable, uint256 tokenId) {
708       
709 	bool	forDutchSale=DutchAListed[_tokenId];
710 	uint256 price;
711 	
712 		if(	forDutchSale==true){
713 		    	price = getCurrentSaddlePrice(_tokenId);
714 		}else{
715 		    	price = saddleIndexPrice[_tokenId];
716 		}	
717 		if(price==0){
718 		    buyable=false;
719 		}else{
720 		    
721         buyable = SaddleIndexForSale[_tokenId];
722 		}
723 		
724         tokenId=_tokenId;
725        return;
726        
727     }
728 	
729 	function SaddlePr(uint256 _tokenId) external view  returns (uint256 price, uint256 tokenId) {
730         price = saddleIndexPrice[_tokenId];
731         tokenId=_tokenId;
732        return;
733        
734     }
735 
736  function setSaleFee(uint256 val) external onCTO {
737         saleFee = val;
738     }
739 
740 
741 function raceOut(uint256 _tokenIdA) external {
742     
743     require(msg.sender==raceDistCon);
744 
745     
746 		
747       SaddleAttr storage saddleA = Saddles[_tokenIdA];
748     
749     saddleA.dna4=true;
750     
751 	  
752 	  raceListed[_tokenIdA]=false;
753     
754       
755 }
756 
757 
758 function raceRegistration(uint256 _tokenIdA, address owner) external {
759     
760    require(msg.sender==raceDistCon);
761     
762     
763   require(SaddleOwnerIndex[_tokenIdA]==owner);
764   
765       SaddleAttr storage saddleA = Saddles[_tokenIdA];
766     require(saddleA.dna4==true);
767     
768     require( raceListed[_tokenIdA]==false);
769     
770           
771 	bool forDutchSale=DutchAListed[_tokenIdA];
772 	uint256 price;
773 	
774 		if(	forDutchSale==true){
775 		    	price = getCurrentSaddlePrice(_tokenIdA);
776 		}else{
777 		    	price = saddleIndexPrice[_tokenIdA];
778 		}
779     
780     bool buyable;
781     
782     if(price==0){
783 		    buyable=false;
784 		}else{
785 		    
786         buyable = SaddleIndexForSale[_tokenIdA];
787 		}
788 		
789 		
790 	require(buyable==false);
791 	
792         
793 		
794     
795     saddleA.dna4=false;
796     
797     raceListed[_tokenIdA]=true;
798 	
799 	
800 		
801         
802 }
803 
804 
805     
806 }
807 
808 
809 
810 contract SaddleMinting is SaddleOwnership {
811 
812     uint256 public  Saddle_Limit = 20000;
813 
814 
815     
816         function createSaddle1(   uint256 _genes1, uint256 _genes2,uint256 _genes3, address _owner) external onlyC {
817         address SaddleOwner = _owner;
818         
819    require(Saddles.length+1 < Saddle_Limit);
820 
821               _newSaddle(_genes1, _genes2, _genes3,true, SaddleOwner);
822             
823           
824         
825     }
826     
827     function createSaddle6(
828     uint256 _genes1, 
829     uint256 _genes2,
830     uint256 _genes3,
831     uint256 _genes1a, 
832     uint256 _genes2a,
833     uint256 _genes3a,
834     uint256 _genes1b, 
835     uint256 _genes2b,
836     uint256 _genes3b,
837     address _owner
838     ) external onlyC {
839         address SaddleOwner = _owner;
840         
841    require(Saddles.length+6 < Saddle_Limit);
842 
843 
844              
845               _newSaddle(_genes1, _genes2, _genes3,true, SaddleOwner);
846               _newSaddle(_genes1a, _genes2a, _genes3a,true, SaddleOwner); 
847               _newSaddle(_genes1b, _genes2b, _genes3b,true, SaddleOwner);
848               _newSaddle(_genes1, _genes2, _genes3,true, SaddleOwner);
849               _newSaddle(_genes1a, _genes2a, _genes3a,true, SaddleOwner); 
850               _newSaddle(_genes1b, _genes2b, _genes3b,true, SaddleOwner);
851     }
852   
853 
854   
855     
856        function _generateNewSaddle(uint256 saddleM_quality ,uint256 maschine_quality, uint256 leader_qual, address _owner) external {
857     
858         
859    require(msg.sender==addr_Saddlery);
860         
861               _newSaddle(leader_qual, saddleM_quality, maschine_quality,true, _owner);
862 
863         
864     }
865    
866    
867 }
868 
869 
870 contract GetTheSaddle is SaddleMinting {
871 
872 
873     function getSaddle(uint256 _id)
874         external
875         view
876         returns (
877         uint256 price,
878         uint256 id,
879         bool forSale,
880         bool forDutchSale,
881         uint256 _genes1,
882         uint256 _genes2,
883         uint256 _genes3,
884         bool _genes4
885 		
886     ) {
887         id = uint256(_id);
888 		forDutchSale=DutchAListed[_id];
889 		
890 		if(	forDutchSale==true){
891 		    	price = getCurrentSaddlePrice(_id);
892 		}else{
893 		    	price = saddleIndexPrice[_id];
894 		}	
895 		       
896     
897     if(price==0){
898 		    forSale=false;
899 		forDutchSale=false;
900 		    
901 		}else{
902 		    
903         forSale = SaddleIndexForSale[_id];
904 		}
905 		
906 		
907 		
908         SaddleAttr storage saddle = Saddles[_id];
909         
910         _genes1 = saddle.dna1;
911         _genes2 = saddle.dna2;
912         _genes3 = saddle.dna3;
913         _genes4 = saddle.dna4;
914 		
915 
916     }
917 
918   
919 
920 }