1 pragma solidity ^0.4.19;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) onlyOwner public {
20     require(newOwner != address(0));
21     OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 
25 }
26 
27 
28 contract ERC721 {
29     
30     function totalSupply() public view returns (uint256 total);
31     function balanceOf(address _owner) public view returns (uint256 balance);
32     function ownerOf(uint256 _tokenId) external view returns (address owner, uint256 tokenId);
33     function approve(address _to, uint256 _tokenId) external;
34     function transfer(address _to, uint256 _tokenId) external payable;
35     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
36 
37 
38     event Transfer(address from, address to, uint256 tokenId);
39     event Approval(address owner, address approved, uint256 tokenId);
40     
41     
42     
43 }
44 
45 
46 contract HorseControl  {
47 
48     address public ceoAddress=0xC229F1e3D3a798725e09dbC6b31b20c07b95543B;
49     address public ctoAddress=0x01569f2D20499ad013daE86B325EE30cB582c3Ba;
50  
51 
52     modifier onCEO() {
53         require(msg.sender == ceoAddress);
54         _;
55     }
56 
57     modifier onCTO() {
58         require(msg.sender == ctoAddress);
59         _;
60     }
61 
62     modifier onlyC() {
63         require(
64             msg.sender == ceoAddress ||
65             msg.sender == ctoAddress
66         );
67         _;
68     }
69 
70  
71 }
72 
73 
74 contract GeneScienceInterface is HorseControl{
75     
76         mapping (uint256 => uint256) public dna1; 
77         mapping (uint256 => uint256) public dna2; 
78         mapping (uint256 => uint256) public dna3; 
79         mapping (uint256 => uint256) public dna4; 
80         mapping (uint256 => uint256) public dna5; 
81         mapping (uint256 => uint256) public dna6; 
82 
83     
84     function mixGenes(uint256 childId, uint256 _mareId, uint16 mumcool, uint256 _stallionId, uint16 dadcool) internal {
85      
86 
87             uint16 cooldownI = (mumcool+dadcool)/2;     
88             
89    uint256   childG1;
90         uint256   childG2;
91         uint256   childG3;
92         uint256   childG4;
93         uint256   childG5;
94         uint256   childG6;
95 
96                if(cooldownI<=1 && cooldownI>=0){
97                    
98                    
99            childG1= dna1[_stallionId];
100            childG2= dna2[_stallionId];
101            childG3= dna3[_mareId];
102            childG4= dna4[_mareId];
103            childG5= dna5[_mareId];
104            childG6= dna6[_stallionId];
105 
106           
107                   
108                   
109               }else if(cooldownI<=2 && cooldownI>1){
110             childG1= dna1[_stallionId];
111            childG2= dna2[_mareId];
112            childG3= dna3[_stallionId];
113            childG4= dna4[_mareId];
114            childG5= dna5[_mareId];
115            childG6= dna6[_stallionId];
116            
117                   
118               }else if(cooldownI<=3 && cooldownI>2){
119                   
120            
121          childG1= dna1[_mareId];
122            childG2= dna2[_stallionId];
123            childG3= dna3[_mareId];
124            childG4= dna4[_stallionId];
125            childG5= dna5[_stallionId];
126            childG6= dna6[_mareId];
127         
128               }else if(cooldownI<=4 && cooldownI>3){
129                   
130            childG1= dna1[_mareId];
131            childG2= dna2[_mareId];
132            childG3= dna3[_stallionId];
133            childG4= dna4[_stallionId];
134            childG5= dna5[_stallionId];
135            childG6= dna6[_mareId];
136         
137               }
138 
139         dna1[childId] = childG1;
140         dna2[childId] = childG2;
141         dna3[childId] = childG3;
142         dna4[childId] = childG4;
143         dna5[childId] = childG5;
144         dna6[childId] = childG6;
145 
146     }
147    
148 }
149 
150 
151 
152 
153 contract HoresBasis is  GeneScienceInterface {
154    
155     event Birth(address owner, uint256 HorseId, uint256 mareId, uint256 stallionId);
156    
157     event Transfer(address from, address to, uint256 tokenId);
158 
159     struct Horse {
160         uint64 birthTime;
161         uint64 unproductiveEndBlock;
162         uint32 mareId;
163         uint32 stallionId;
164         uint32 stallionWithId;
165         uint16 unproductiveIndex;
166         uint16 generation;
167     }
168 
169     uint32[5] public sterile = [
170         uint32(15 minutes),
171         uint32(120 minutes),
172         uint32(480 minutes),
173         uint32(1800 minutes),
174         uint32(3000 minutes)
175     ];
176 
177 
178     uint256 public secondsPerBlock = 15;
179 
180     Horse[] horses;
181 
182     mapping (uint256 => address) public horseOwnerIndex;
183     
184     mapping (uint256 => uint256) public horseIndexPrice;
185     
186     mapping (uint256 => bool)  horseIndexForSale;
187 
188     mapping (address => uint256) tokenOwnershipCount;
189 
190 
191    uint256 public saleFee = 20;
192 
193    uint256 public BirthFee = 4 finney;
194    
195    
196  
197     function _transfer(address _from, address _to, uint256 _tokenId) internal {
198         tokenOwnershipCount[_to]++;
199         horseOwnerIndex[_tokenId] = _to;
200         
201         if (_from != address(0)) {
202             tokenOwnershipCount[_from]--;
203          
204         }
205        Transfer(_from, _to, _tokenId);
206        
207     }
208     
209     
210     function _sell(address _from,  uint256 _tokenId, uint256 value) internal {
211      
212      if(horseIndexForSale[_tokenId]==true){
213          
214               uint256 price = horseIndexPrice[_tokenId];
215             
216             require(price<=value);
217             
218          uint256 Fee = price / saleFee;
219             
220           uint256  oPrice= price - Fee;
221             
222             address _to = msg.sender;
223             
224             tokenOwnershipCount[_to]++;
225             horseOwnerIndex[_tokenId] = _to;
226             
227             horseIndexForSale[_tokenId]=false;
228             
229             
230             if (_from != address(0)) {
231                 tokenOwnershipCount[_from]--;
232                
233             }
234                  
235            Transfer(_from, _to, _tokenId);
236              
237              _from.transfer(oPrice);
238              
239              ceoAddress.transfer(Fee);
240              
241             uint256 bidExcess = value - oPrice - Fee;
242             _to.transfer(bidExcess);
243             
244             
245      }else{
246           _to.transfer(value);
247      }
248       
249     }
250     
251     
252 	
253     function _newHorse(
254         uint256 _mareId,
255         uint256 _stallionId,
256         uint256 _generation,
257         uint256 _genes1,
258         uint256 _genes2,
259         uint256 _genes3,
260         uint256 _genes4,
261         uint256 _genes5,
262         uint256 _genes6,
263         address _owner
264     )
265         internal
266         returns (uint)
267     {
268    
269         Horse memory _horse = Horse({
270            birthTime: uint64(now),
271             unproductiveEndBlock: 0,
272             mareId: uint32(_mareId),
273             stallionId: uint32(_stallionId),
274             stallionWithId: 0,
275             unproductiveIndex: 0,
276             generation: uint16(_generation)
277             
278         });
279        
280         
281        uint256 newHorseId;
282 	   
283      newHorseId = horses.push(_horse)-1;
284      
285      makeDna(_mareId, _stallionId, newHorseId, _genes1, _genes2, _genes3, _genes4, _genes5, _genes6);
286         require(newHorseId == uint256(uint32(newHorseId)));
287 
288        Birth(
289             _owner,
290             newHorseId,
291             uint256(_horse.mareId),
292             uint256(_horse.stallionId)
293         );
294 
295         _transfer(0, _owner, newHorseId);
296 
297         return newHorseId;  
298     }
299 
300 
301 function makeDna( uint256 _mareId,
302         uint256 _stallionId,
303         uint256 _newId,
304         uint256 _genes1,
305         uint256 _genes2,
306         uint256 _genes3,
307         uint256 _genes4,
308         uint256 _genes5,
309         uint256 _genes6)internal{
310     
311       if(_mareId!=0 && _stallionId!=0){
312                
313           Horse storage stallion = horses[_stallionId];
314      Horse storage mare = horses[_mareId];
315      
316     GeneScienceInterface.mixGenes(_newId, _mareId,mare.unproductiveIndex, _stallionId, stallion.unproductiveIndex);
317          
318      }else{
319          
320         dna1[_newId] = _genes1;
321         dna2[_newId] = _genes2;
322         dna3[_newId] = _genes3;
323         dna4[_newId] = _genes4;
324         dna5[_newId] = _genes5;
325         dna6[_newId] = _genes6;
326      }
327 }
328 
329 
330 
331     function setSecondsPerBlock(uint256 secs) external  onlyC {
332     require(secs < sterile[0]);
333        secondsPerBlock = secs;
334       
335     }
336    
337 }
338 
339 
340 contract HorseOwnership is HoresBasis, ERC721{
341 
342   string public constant  name = "CryptoHorse";
343     string public constant symbol = "CHC";
344      uint8 public constant decimals = 0; 
345 
346     function horseForSale(uint256 _tokenId, uint256 price) external {
347   
348      address  ownerof =  horseOwnerIndex[_tokenId];
349         require(ownerof == msg.sender);
350         horseIndexPrice[_tokenId] = price;
351         horseIndexForSale[_tokenId]= true;
352 		}
353 
354 
355  function horseNotForSale(uint256 _tokenId) external {
356          address  ownerof =  horseOwnerIndex[_tokenId];
357             require(ownerof == msg.sender);
358         horseIndexForSale[_tokenId]= false;
359 
360     }
361 
362 
363     function _owns(address _applicant, uint256 _tokenId) internal view returns (bool) {
364         return horseOwnerIndex[_tokenId] == _applicant;
365     }
366 
367 
368     function balanceOf(address _owner) public view returns (uint256 count) {
369         return tokenOwnershipCount[_owner];
370     }
371 
372     function transfer(
373         address _to,
374         uint256 _tokenId
375     )
376         external
377         payable
378     {
379         require(_to != address(0));
380 		
381         require(_to != address(this));
382  
383         require(_owns(msg.sender, _tokenId));
384        _transfer(msg.sender, _to, _tokenId);
385     }
386 
387     function approve(
388         address _to,
389         uint256 _tokenId
390     )
391         external 
392     {
393         require(_owns(msg.sender, _tokenId));
394 
395         Approval(msg.sender, _to, _tokenId);
396     }
397 
398     function transferFrom(address _from, address _to, uint256 _tokenId ) external payable {
399         
400         if(_from != msg.sender){
401               require(_to == msg.sender);
402                  
403                 require(_from==horseOwnerIndex[_tokenId]);
404         
405                _sell(_from,  _tokenId, msg.value);
406             
407         }
408  
409     }
410 
411     function totalSupply() public view returns (uint) {
412         return horses.length;
413     }
414 
415     function ownerOf(uint256 _tokenId)  external view returns (address owner, uint256 tokenId)  {
416         owner = horseOwnerIndex[_tokenId];
417         tokenId=_tokenId;
418        
419        return;
420        
421     }
422 
423        function horseFS(uint256 _tokenId) external view  returns (bool buyable, uint256 tokenId) {
424         buyable = horseIndexForSale[_tokenId];
425         tokenId=_tokenId;
426        return;
427        
428     }
429 	
430 	function horsePr(uint256 _tokenId) external view  returns (uint256 price, uint256 tokenId) {
431         price = horseIndexPrice[_tokenId];
432         tokenId=_tokenId;
433        return;
434        
435     }
436     
437 }
438 
439 contract HorseStud is HorseOwnership {
440   
441     event Pregnant(address owner, uint256 mareId, uint256 stallionId, uint256 unproductiveEndBlock);
442 
443     uint256 public pregnantHorses;
444 
445 
446     function _isStallionPermitted(uint256 _stallionId, uint256 _mareId) internal view returns (bool) {
447         address mareOwner = horseOwnerIndex[_mareId];
448         address stallionOwner = horseOwnerIndex[_stallionId];
449         return (mareOwner == stallionOwner);
450     }
451 
452  function setBirthFee(uint256 val) external onCTO {
453         BirthFee = val;
454     }
455     
456  function setSaleFee(uint256 val) external onCTO {
457         saleFee = val;
458     }
459 
460  
461     function isReadyToBear(uint256 _horseId) public view returns (bool) {
462         require(_horseId > 0);
463         Horse storage knight = horses[_horseId];
464         require(knight.unproductiveIndex<4);  
465     
466         bool ready = (knight.stallionWithId == 0) && (knight.unproductiveEndBlock <= uint64(block.number));
467        return ready;
468     }
469 
470     function isPregnant(uint256 _horseId) public view returns (bool) {
471         require(_horseId > 0);
472         return horses[_horseId].stallionWithId != 0;
473     }
474 
475 	
476     function _canScrewEachOther(uint256 _mareId, uint256 _stallionId) private view returns(bool) {
477 		
478         if (_mareId == _stallionId) {
479             return false;
480         }
481         
482      uint256   matronSex=dna4[_mareId];
483      uint256   sireSex=dna4[_stallionId];
484 
485         if(matronSex!=1){
486             return false;
487         }
488         
489          if(sireSex!=2){
490             return false;
491         }
492         
493       if(matronSex==sireSex){
494           return false;
495       }  
496         
497         return true;
498     }
499 
500     function canBearWith(uint256 _mareId, uint256 _stallionId)
501         external
502         view
503         returns(bool)
504     {
505         require(_mareId > 0);
506         require(_stallionId > 0);
507         return _canScrewEachOther( _mareId,  _stallionId) &&
508             _isStallionPermitted(_stallionId, _mareId);
509     }
510 
511     
512     function _bearWith(uint256 _mareId, uint256 _stallionId) internal {
513         Horse storage stallion = horses[_stallionId];
514         Horse storage mare = horses[_mareId];
515 
516         mare.stallionWithId = uint32(_stallionId);
517        
518          stallion.unproductiveEndBlock = uint64((sterile[stallion.unproductiveIndex]/secondsPerBlock) + block.number);
519  mare.unproductiveEndBlock = uint64((sterile[mare.unproductiveIndex]/secondsPerBlock) + block.number);
520         
521         if (stallion.unproductiveIndex < 5) {
522             stallion.unproductiveIndex += 1;
523         }
524 		 if (mare.unproductiveIndex < 5) {
525 					mare.unproductiveIndex += 1;
526 		}
527 		 
528         pregnantHorses++;
529 
530         Pregnant(horseOwnerIndex[_mareId], _mareId, _stallionId, mare.unproductiveEndBlock);
531    
532    bearChild(_mareId);
533 
534     }
535 
536 	
537 	
538     function stallionWith(uint256 _mareId, uint256 _stallionId) external payable  {
539 		require(_owns(msg.sender, _mareId));
540         require(_owns(msg.sender, _stallionId));
541 
542         Horse storage mare = horses[_mareId];
543 
544         require(isReadyToBear(_mareId));
545         require(isReadyToBear(_stallionId));
546 
547         bool (mare.stallionWithId == 0) && (mare.unproductiveEndBlock <= uint64(block.number));
548 
549         Horse storage stallion = horses[_stallionId];
550 
551         bool (stallion.stallionWithId == 0) && (stallion.unproductiveEndBlock <= uint64(block.number));
552 
553         require(_canScrewEachOther(
554             _mareId,
555             _stallionId
556         ));
557         
558         if(BirthFee>= msg.value){
559            
560 		   ceoAddress.transfer(BirthFee);
561              uint256   rest=msg.value-BirthFee;
562                 msg.sender.transfer(rest);   
563      _bearWith(uint32(_mareId), uint32(_stallionId));
564  
565         
566         }else{
567             
568                msg.sender.transfer(msg.value);
569   
570         }
571         
572     }
573 
574 	
575 	
576     function bearChild(uint256 _mareId) internal  {
577         
578             Horse storage mare = horses[_mareId];
579           
580                require(mare.birthTime != 0);
581         
582                 bool (mare.stallionWithId != 0) && (mare.unproductiveEndBlock <= uint64(block.number)); 
583             
584               uint256 stallionId = mare.stallionWithId;
585                 
586                Horse storage stallion = horses[stallionId];
587         
588                 uint16 parentGen = mare.generation;
589                 if (stallion.generation > mare.generation) {
590                     parentGen = stallion.generation;
591                 }
592         
593                 address owner = horseOwnerIndex[_mareId];
594                 
595              _newHorse(_mareId, stallionId, parentGen + 1, 0,0,0,0,0,0, owner);
596            
597               mare.stallionWithId=0;
598                 
599                 pregnantHorses--;
600                 
601     }
602     
603     
604     
605 }
606 
607 
608 
609 
610 contract HorseMinting is HorseStud {
611 
612     uint256 public  GEN_0_LIMIT = 20000;
613 
614 
615     uint256 public gen0Count;
616 
617     
618 
619     function createGen0Horse(uint256 _genes1,uint256 _genes2,uint256 _genes3,uint256 _genes4,uint256 _genes5,uint256 _genes6, address _owner) external onCTO {
620         address horseOwner = _owner;
621        if (horseOwner == address(0)) {
622              horseOwner = ctoAddress;
623         }
624     require(gen0Count < GEN_0_LIMIT);
625 
626             
627               _newHorse(0, 0, 0, _genes1, _genes2, _genes3, _genes4, _genes5, _genes6, horseOwner);
628             
629         gen0Count++;
630         
631     }
632 
633    
634 }
635 
636 
637 contract GetTheHorse is HorseMinting {
638 
639 
640     function getHorse(uint256 _id)
641         external
642         view
643         returns (
644         uint256 price,
645         uint256 id,
646         bool forSale,
647         bool isGestating,
648         bool isReady,
649         uint256 unproductiveIndex,
650         uint256 nextActionAt,
651         uint256 stallionWithId,
652         uint256 birthTime,
653         uint256 mareId,
654         uint256 stallionId,
655         uint256 generation
656 		
657     ) {
658 		price = horseIndexPrice[_id];
659         id = uint256(_id);
660 		forSale = horseIndexForSale[_id];
661         Horse storage knight = horses[_id];
662         isGestating = (knight.stallionWithId != 0);
663         isReady = (knight.unproductiveEndBlock <= block.number);
664         unproductiveIndex = uint256(knight.unproductiveIndex);
665         nextActionAt = uint256(knight.unproductiveEndBlock);
666         stallionWithId = uint256(knight.stallionWithId);
667         birthTime = uint256(knight.birthTime);
668         mareId = uint256(knight.mareId);
669         stallionId = uint256(knight.stallionId);
670         generation = uint256(knight.generation);
671 
672     }
673 
674   
675 
676 }