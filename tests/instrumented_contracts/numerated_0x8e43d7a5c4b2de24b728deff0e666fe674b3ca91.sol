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
40     event Approval(address owner, address approved, uint256 tokenId); //Einbauen!
41     
42     
43     
44 }
45 
46 
47 
48 contract HorseShoeControl  {
49 
50     address public ceoAddress=0xC6F3Fb72db068C96A1D50Bbc3D370cC8e4af0bFc;
51     address public ctoAddress=0x73A895C06D6E3DcCA3acE48FC8801E17eD247f85;
52  
53         
54 
55 
56 
57 
58     modifier onCEO() {
59         require(msg.sender == ceoAddress);
60         _;
61     }
62 
63     modifier onCTO() {
64         require(msg.sender == ctoAddress);
65         _;
66     }
67 
68     modifier onlyC() {
69         require(
70             msg.sender == ceoAddress ||
71             msg.sender == ctoAddress
72         );
73         _;
74     }
75     
76     
77     
78     address public raceDistCon;
79         
80 
81     address public addr_forge;
82    
83 
84 
85             
86         function newForgeCon (address newConAddr) external onCTO {
87             addr_forge = newConAddr;
88             
89         }
90             
91         function newRaceDistCon (address newConAddr) external onCTO {
92             raceDistCon = newConAddr;
93             
94         }
95             
96     
97             
98 
99     
100     
101 
102  
103 }
104 
105 contract HorseShoeShopOwner is HorseShoeControl, ERC721 {
106     
107 
108     
109     mapping (uint256 => address) public HShoeShopO;
110     
111     mapping (uint256 => uint256) public HSShopPrice;
112     
113     mapping (uint256 => bool) public HSShopForSale;
114     mapping (uint256 => bool) public HSShopForBiding;
115     
116     mapping (address => uint256) HSShopOwnCount;
117     
118      uint256 public HSShopSaleFee = 20;
119    
120   
121         mapping (uint256 => uint256)  startBlock;
122       
123     mapping (uint256 => uint256) startPrice;
124     mapping (uint256 => uint256) public priceDecreaseRate;
125     
126 
127       function getCurrentItemPrice(uint256 _id) public view returns (uint256)  {
128     return startPrice[_id] - priceDecreaseRate[_id]*(block.number - startBlock[_id]);
129   }
130     
131       function newPriceDecreaseRate(uint DecreRate,uint256 _id) external onlyC   {
132                 priceDecreaseRate[_id]=DecreRate;
133   }
134     
135     
136     
137     function changeHSShopPrice(uint256 price, uint256 HSShopId) external{
138         
139         require(msg.sender==HShoeShopO[HSShopId]);
140         
141         require(HSShopForSale[HSShopId]==true);
142         
143         require(price!=0);
144         
145         HSShopPrice[HSShopId]=price;
146         
147     }
148     
149     
150     function buyHSShop(uint256 id) payable external{
151         
152           require(HSShopForSale[id]==true);
153          
154               uint256 price = HSShopPrice[id];
155             
156             require(price<=msg.value);
157             
158          uint256 Fee = price / HSShopSaleFee ;
159             
160           uint256  oPrice= price - Fee;
161             
162             address _to = msg.sender;
163             address _from = HShoeShopO[id];
164             
165             HSShopOwnCount[_to]++;
166             
167             HShoeShopO[id] = _to;
168             
169             HSShopForSale[id]=false;
170             
171             
172                 HSShopOwnCount[_from]--;
173                
174            emit Transfer(_from, _to, id);
175             
176             if(_from!=0){
177                 
178              _from.transfer(oPrice);
179             }else{
180                 
181              ceoAddress.transfer(oPrice);
182             }
183              
184              ceoAddress.transfer(Fee);
185              
186              
187             uint256 buyExcess = msg.value - oPrice - Fee;
188             _to.transfer(buyExcess);
189       
190         
191     }
192     
193 
194     
195     function firstSellHSShop(uint256 _id, uint256 price, uint256 _decreRate) external onlyC {
196         
197         require(HShoeShopO[_id]==0);
198         
199         HSShopPrice[_id]=price;
200         
201             
202                 HSShopForBiding[_id]=true;
203                 
204                   startBlock[_id] = block.number;
205                   
206                   startPrice[_id] = price;
207                   
208                  priceDecreaseRate[_id]= _decreRate;
209                 
210     }
211     
212     function bid(uint256 _id) payable external{
213       
214         
215         
216         uint256 priceNow = getCurrentItemPrice(_id);
217         require(msg.value>=priceNow);
218         
219         require(HSShopForBiding[_id]==true);
220         
221           if(priceNow<=0||priceNow>=startPrice[_id]){
222         HSShopForBiding[_id]=false;
223               _to.transfer( msg.value);
224         }else{
225             
226         
227         HSShopForBiding[_id]=false;
228         
229             
230             address _to = msg.sender;
231             address _from = HShoeShopO[_id];
232             
233             HSShopOwnCount[_to]++;
234             
235             HShoeShopO[_id] = _to;
236             
237             HSShopForSale[_id]=true;
238             
239             uint256 priceAufschlag=msg.value/3;
240             
241             
242    HSShopPrice[_id]=msg.value+ priceAufschlag;
243                
244            emit Transfer(_from, _to, _id);
245             
246              ceoAddress.transfer(priceNow);
247          
248              
249             uint256 buyExcess = msg.value - priceNow;
250             _to.transfer(buyExcess);
251         }
252         
253         
254       
255     }
256     
257     
258      function setHSShopSaleFee(uint256 val) external onCTO {
259         HSShopSaleFee = val;
260     }
261     
262 }
263 
264 contract HorseShoeBasis is  HorseShoeShopOwner {
265     
266     
267    
268     event Birth(address owner, uint256 HorseShoeId);
269    
270     event Transfer(address from, address to, uint256 tokenId);
271 
272     struct HorseShoe {
273         uint256 dna2; 
274         uint256 dna3; 
275         bool dna4;
276         bool dna5; 
277 
278         
279     }
280 
281 
282     HorseShoe[] horseShoes;
283 
284     mapping (uint256 => address) horseShoeOwnerIndex;
285     
286     mapping (uint256 => uint256) public horseShoeIndexPrice;
287     
288     mapping (uint256 => uint256) public processingQuality;
289     
290     mapping (uint256 => uint256) public WearOut;
291     
292     
293     mapping (uint256 => bool)  horseShoeIndexForSale;
294 
295     mapping (address => uint256) tokenOwnershipCount;
296     
297     mapping (uint256 => bool)  raceListed;
298 
299 
300   uint256 public saleFee = 20;
301    
302    
303 
304  
305     function _transfer(address _from, address _to, uint256 _tokenId) internal {
306         tokenOwnershipCount[_to]++;
307         horseShoeOwnerIndex[_tokenId] = _to;
308         
309         if (_from != address(0)) {
310             tokenOwnershipCount[_from]--;
311          
312         }
313        emit Transfer(_from, _to, _tokenId);
314        
315     }
316     
317     
318  
319     function transfer10( address _to, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3, uint256 _tokenId4, uint256 _tokenId5, uint256 _tokenId6, uint256 _tokenId7, uint256 _tokenId8, uint256 _tokenId9, uint256 _tokenId10  ) external onlyC {
320      
321        require(_to != address(0));
322 		
323         require(_to != address(this));
324      
325      require( horseShoeOwnerIndex[_tokenId1] == msg.sender );
326       
327       _transfer(msg.sender,  _to,  _tokenId1);
328         
329      require( horseShoeOwnerIndex[_tokenId2] == msg.sender );
330    
331       _transfer(msg.sender,  _to,  _tokenId2);
332      require( horseShoeOwnerIndex[_tokenId3] == msg.sender );
333      
334       _transfer(msg.sender,  _to,  _tokenId3);
335      require( horseShoeOwnerIndex[_tokenId4] == msg.sender );
336        
337       _transfer(msg.sender,  _to,  _tokenId4);
338      require( horseShoeOwnerIndex[_tokenId5] == msg.sender );
339   
340       _transfer(msg.sender,  _to,  _tokenId5);
341      require( horseShoeOwnerIndex[_tokenId6] == msg.sender );
342        
343       _transfer(msg.sender,  _to,  _tokenId6);
344      require( horseShoeOwnerIndex[_tokenId7] == msg.sender );
345         
346       _transfer(msg.sender,  _to,  _tokenId7);
347      require( horseShoeOwnerIndex[_tokenId8] == msg.sender );
348        
349       _transfer(msg.sender,  _to,  _tokenId8);
350       
351      require( horseShoeOwnerIndex[_tokenId9] == msg.sender );
352       
353       _transfer(msg.sender,  _to,  _tokenId9);
354      require( horseShoeOwnerIndex[_tokenId10] == msg.sender );
355       
356       
357       _transfer(msg.sender,  _to,  _tokenId10);
358        
359     }
360     
361     function _sell(address _from,  uint256 _tokenId, uint256 value) internal {
362      
363      if(horseShoeIndexForSale[_tokenId]==true){
364          
365               uint256 price = horseShoeIndexPrice[_tokenId];
366             
367             require(price<=value);
368             
369          uint256 Fee = price / saleFee /2;
370             
371           uint256  oPrice= price - Fee - Fee;
372             
373             address _to = msg.sender;
374             
375             tokenOwnershipCount[_to]++;
376             horseShoeOwnerIndex[_tokenId] = _to;
377             
378             horseShoeIndexForSale[_tokenId]=false;
379             
380             
381             if (_from != address(0)) {
382                 tokenOwnershipCount[_from]--;
383                
384             }
385                  
386            emit Transfer(_from, _to, _tokenId);
387             
388             uint256 HSQ = processingQuality[_tokenId]/10;
389              address HSSOwner;
390              
391               if(HSQ>=10||WearOut[_tokenId]>=1){
392                  
393             HSSOwner= HShoeShopO[6];
394             
395              }else  if(HSQ>=0&&HSQ<=2){
396               HSSOwner= HShoeShopO[5];
397                  
398              }else  if(HSQ>=2&&HSQ<=4){
399               HSSOwner= HShoeShopO[4];
400                  
401              } else  if(HSQ>=4&&HSQ<=6){
402              HSSOwner=  HShoeShopO[3];
403                  
404              } else  if(HSQ>=6&&HSQ<=8){
405              HSSOwner=  HShoeShopO[2];
406                  
407              }else  if(HSQ>=8&&HSQ<=10){
408              HSSOwner=  HShoeShopO[1];
409                  
410              }else{
411                  
412              HSSOwner= ceoAddress;
413              }
414              
415             
416              
417              _from.transfer(oPrice);
418              
419              ceoAddress.transfer(Fee);
420              if(HSSOwner!=0){
421                  
422              HSSOwner.transfer(Fee);
423              }else {
424              ceoAddress.transfer(Fee);
425                  
426              }
427              
428             uint256 bidExcess = value - oPrice - Fee - Fee;
429             _to.transfer(bidExcess);
430             
431             
432      }else{
433           _to.transfer(value);
434      }
435       
436     }
437     
438     
439 	
440     function _newHorseShoe(
441         uint256 _genes1,
442         uint256 _genes2,
443         uint256 _genes3,
444         bool _genes4,
445         bool _genes5,
446         address _owner
447     )
448         internal
449         returns (uint)
450     {
451    
452    
453    
454    
455         HorseShoe memory _horseShoe = HorseShoe({
456         dna2: _genes2,
457         dna3 : _genes3,
458         dna4: _genes4,
459         dna5: _genes5
460             
461         });
462        
463        
464         
465        uint256 newHorseShoeId;
466 	   
467      newHorseShoeId = horseShoes.push(_horseShoe)-1;
468      
469   
470         require(newHorseShoeId == uint256(uint32(newHorseShoeId)));
471 
472 
473         WearOut[newHorseShoeId]=_genes1;
474         
475         processingQuality[newHorseShoeId]= (_genes2 + _genes3)/2;
476         
477         raceListed[newHorseShoeId]=false;
478         
479        emit Birth(_owner, newHorseShoeId);
480 
481         _transfer(0, _owner, newHorseShoeId);
482 
483         return newHorseShoeId;  
484     }
485 
486 
487 
488 }
489 
490 
491 contract IronConnect {
492     
493         function balanceOf(address tokenOwner) public constant returns (uint balance);
494         
495         function ironProcessed(address tokenOwner) external; 
496         
497 }
498 
499 contract SmithConnect {
500 
501       mapping (uint256 => uint256) public averageQuality;
502 
503     function ownerOf(uint256 _tokenId) external view returns (address owner);
504     function balanceOf(address _owner) public view returns (uint256 balance);
505     
506     
507 }
508 
509 contract ForgeConnection {
510     
511     
512     mapping (uint256 => uint256) public forgeToolQuality;
513     
514     function ownerOf(uint256 _tokenId) external view returns (address owner);
515     function balanceOf(address _owner) public view returns (uint256 balance);
516 
517     
518 }
519 
520 
521 contract HorseShoeOwnership is HorseShoeBasis{
522 
523   string public constant  name = "CryptoHorseShoe";
524     string public constant symbol = "CHS";
525      uint8 public constant decimals = 0; 
526 
527     function horseShoeForSale(uint256 _tokenId, uint256 price) external {
528   
529      address  ownerof =  horseShoeOwnerIndex[_tokenId];
530         require(ownerof == msg.sender);
531         horseShoeIndexPrice[_tokenId] = price;
532         horseShoeIndexForSale[_tokenId]= true;
533 		}
534 		
535  function changePrice(uint256 _tokenId, uint256 price) external {
536   
537      address  ownerof =  horseShoeOwnerIndex[_tokenId];
538         require(ownerof == msg.sender);
539         require(horseShoeIndexForSale[_tokenId] == true);
540        
541              
542               horseShoeIndexPrice[_tokenId] = price;
543          
544 		}
545 
546  function horseShoeNotForSale(uint256 _tokenId) external {
547          address  ownerof =  horseShoeOwnerIndex[_tokenId];
548             require(ownerof == msg.sender);
549         horseShoeIndexForSale[_tokenId]= false;
550 
551     }
552 
553 
554     function _owns(address _applicant, uint256 _tokenId) internal view returns (bool) {
555         return horseShoeOwnerIndex[_tokenId] == _applicant;
556     }
557 
558 
559     function balanceOf(address _owner) public view returns (uint256 count) {
560         return tokenOwnershipCount[_owner];
561     }
562 
563     function transfer(
564         address _to,
565         uint256 _tokenId
566     )
567         external
568         payable
569     {
570         require(_to != address(0));
571 		
572         require(_to != address(this));
573  
574         require(_owns(msg.sender, _tokenId));
575        _transfer(msg.sender, _to, _tokenId);
576     }
577 
578     function approve(
579         address _to,
580         uint256 _tokenId
581     )
582         external 
583     {
584        require(_owns(msg.sender, _tokenId));
585 
586         emit Approval(msg.sender, _to, _tokenId);
587     }
588 
589     function transferFrom(address _from, address _to, uint256 _tokenId ) external payable {
590         
591         if(_from != msg.sender){
592               require(_to == msg.sender);
593                  
594                  require(raceListed[_tokenId]==false);
595                  
596                 require(_from==horseShoeOwnerIndex[_tokenId]);
597         
598                _sell(_from,  _tokenId, msg.value);
599             
600         }else{
601             
602           _to.transfer(msg.value);
603         }
604  
605     }
606 
607     function totalSupply() public view returns (uint) {
608         return horseShoes.length;
609     }
610 
611     function ownerOf(uint256 _tokenId)  external view returns (address owner)  {
612         owner = horseShoeOwnerIndex[_tokenId];
613 
614        return;
615        
616     }
617     
618     function ownerOfID(uint256 _tokenId)  external view returns (address owner, uint256 tokenId)  {
619         owner = horseShoeOwnerIndex[_tokenId];
620 tokenId=_tokenId;
621        return;
622        
623     }
624 
625        function horseShoeFS(uint256 _tokenId) external view  returns (bool buyable, uint256 tokenId) {
626         buyable = horseShoeIndexForSale[_tokenId];
627         tokenId=_tokenId;
628        return;
629        
630     }
631 	
632 	function horseShoePr(uint256 _tokenId) external view  returns (uint256 price, uint256 tokenId) {
633         price = horseShoeIndexPrice[_tokenId];
634         tokenId=_tokenId;
635        return;
636        
637     }
638 
639  function setSaleFee(uint256 val) external onCTO {
640         saleFee = val;
641     }
642 
643 
644 function raceOut(uint256 _tokenIdA) external {
645     
646     require(msg.sender==raceDistCon);
647 
648         require(WearOut[_tokenIdA] <10 );
649     
650 		
651       HorseShoe storage horseshoeA = horseShoes[_tokenIdA];
652     
653     horseshoeA.dna4=true;
654     
655 	  
656        WearOut[_tokenIdA] = WearOut[_tokenIdA]+1;
657 	  
658 	  raceListed[_tokenIdA]=false;
659     
660       
661 }
662 
663 function meltHorseShoe(uint256 _tokenId, address owner) external{
664   
665 
666   require(msg.sender==addr_forge);
667 
668    
669         
670             horseShoeIndexForSale[_tokenId]=false;
671         horseShoeOwnerIndex[_tokenId]=0x00;
672         
673       
674        tokenOwnershipCount[owner]--;
675         
676         //iron totalsupply less?
677     
678     
679         
680          HorseShoe storage horseshoe = horseShoes[_tokenId];
681         horseshoe.dna5 = true;
682       horseshoe.dna4 = false;
683       
684       
685 }
686 
687 function raceRegistration(uint256 _tokenIdA, address owner) external {
688     
689   //  require(msg.sender==raceDistCon);
690     
691     require(tokenOwnershipCount[owner]>=4);
692     
693   require(horseShoeOwnerIndex[_tokenIdA]==owner);
694   
695       HorseShoe storage horseshoeA = horseShoes[_tokenIdA];
696     require(horseshoeA.dna4==true);
697     require(horseshoeA.dna5==false);
698     require( raceListed[_tokenIdA]==false);
699 	require(horseShoeIndexForSale[_tokenIdA]==false);
700 	
701         
702 		
703     
704     horseshoeA.dna4=false;
705     
706     raceListed[_tokenIdA]=true;
707 	
708 	
709 		
710         
711 }
712 
713 
714     
715 }
716 
717 
718 
719 contract HorseShoeMinting is HorseShoeOwnership {
720 
721     uint256 public  HShoe_Limit = 160000;
722 
723 
724     function createHorseShoe4(uint256 _genes2,uint256 _genes3,uint256 _genes2a,uint256 _genes3a, uint256 _genes2b,uint256 _genes3b,uint256 _genes2c,uint256 _genes3c, address _owner) external onlyC {
725         address horseShoeOwner = _owner;
726         
727    require(horseShoes.length+3 < HShoe_Limit);
728 
729             
730               _newHorseShoe(0, _genes2, _genes3,true,false , horseShoeOwner);
731             
732               _newHorseShoe(0, _genes2b, _genes3b,true,false , horseShoeOwner);
733             
734             
735               _newHorseShoe(0, _genes2a, _genes3a,true,false , horseShoeOwner);
736             
737             
738               _newHorseShoe(0, _genes2c, _genes3c,true,false , horseShoeOwner);
739         
740     }
741     
742         function createHorseShoe1(uint256 _genes2,uint256 _genes3, address _owner) external onlyC {
743         address horseShoeOwner = _owner;
744         
745    require(horseShoes.length+3 < HShoe_Limit);
746 
747             
748               _newHorseShoe(0, _genes2, _genes3,true,false , horseShoeOwner);
749             
750           
751         
752     }
753     
754     function createHorseShoe10(uint256 _genes2,uint256 _genes3,uint256 _genes2a,uint256 _genes3a, uint256 _genes2b,uint256 _genes3b,uint256 _genes2c,uint256 _genes3c, uint256 _genes2d,uint256 _genes3d, address _owner) external onlyC {
755         address horseShoeOwner = _owner;
756         
757    require(horseShoes.length+3 < HShoe_Limit);
758 
759             
760               _newHorseShoe(0, _genes2, _genes3,true,false , horseShoeOwner);
761             
762               _newHorseShoe(0, _genes2b, _genes3b,true,false , horseShoeOwner);
763             
764             
765               _newHorseShoe(0, _genes2a, _genes3a,true,false , horseShoeOwner);
766             
767             
768               _newHorseShoe(0, _genes2c, _genes3c,true,false , horseShoeOwner);
769               
770               _newHorseShoe(0, _genes2d, _genes3d,true,false , horseShoeOwner);
771         
772               _newHorseShoe(0, _genes2, _genes3,true,false , horseShoeOwner);
773             
774               _newHorseShoe(0, _genes2b, _genes3b,true,false , horseShoeOwner);
775             
776             
777               _newHorseShoe(0, _genes2a, _genes3a,true,false , horseShoeOwner);
778             
779             
780               _newHorseShoe(0, _genes2c, _genes3c,true,false , horseShoeOwner);
781               
782               _newHorseShoe(0, _genes2d, _genes3d,true,false , horseShoeOwner);
783     }
784   
785 
786   
787     
788        function _generateNewHorseShoe(uint256 smith_quality ,uint256 maschine_quality, address _owner) external {
789     
790         
791    require(msg.sender==addr_forge);
792         
793               _newHorseShoe(  0, smith_quality, maschine_quality, true, false , _owner);
794 
795         
796     }
797    
798    
799 }
800 
801 
802 contract GetTheHorseShoe is HorseShoeMinting {
803 
804 
805     function getHorseShoe(uint256 _id)
806         external
807         view
808         returns (
809         uint256 price,
810         uint256 id,
811         bool forSale,
812         uint256 _genes1,
813         uint256 _genes2,
814         uint256 _genes3,
815         bool _genes4,
816         bool _genes5
817 		
818     ) {
819 		price = horseShoeIndexPrice[_id];
820         id = uint256(_id);
821 		forSale = horseShoeIndexForSale[_id];
822         HorseShoe storage horseshoe = horseShoes[_id];
823         
824         _genes1 = WearOut[_id];
825         _genes2 = horseshoe.dna2;
826         _genes3 = horseshoe.dna3;
827         _genes4 = horseshoe.dna4;
828         _genes5 = horseshoe.dna5;
829 		
830 
831     }
832 
833   
834 
835 }