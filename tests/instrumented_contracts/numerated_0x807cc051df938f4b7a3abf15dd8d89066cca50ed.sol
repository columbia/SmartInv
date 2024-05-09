1 /**
2  * Crypto Bunny Factory
3  * Buy,sell,trade and mate crypto based digital bunnies
4  * 
5  * Developer Team
6  * Check on CryptoBunnies.com
7  * 
8  **/
9  
10 pragma solidity ^0.4.23;
11 
12  
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20  function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 // The ERC-721 Interface to reference the animal factory token
77 interface ERC721Interface {
78      function totalSupply() public view returns (uint256);
79      function safeTransferFrom(address _from, address _to, uint256 _tokenId);
80      function burnToken(address tokenOwner, uint256 tid) ;
81      function sendToken(address sendTo, uint tid, string tmeta) ;
82      function getTotalTokensAgainstAddress(address ownerAddress) public constant returns (uint totalAnimals);
83      function getAnimalIdAgainstAddress(address ownerAddress) public constant returns (uint[] listAnimals);
84      function balanceOf(address _owner) public view returns (uint256 _balance);
85      function ownerOf(uint256 _tokenId) public view returns (address _owner);
86      function setAnimalMeta(uint tid, string tmeta);
87 }
88 
89 
90 contract AnimalFactory is Ownable
91 {
92     //The structure defining a single animal
93     struct AnimalProperties
94     {
95         uint id;
96         string name;
97         string desc;
98         bool upForSale;
99         uint priceForSale;
100         bool upForMating;
101         bool eggPhase;
102         uint priceForMating;
103         bool isBornByMating;
104         uint parentId1;
105         uint parentId2;
106         uint birthdate;
107         uint costumeId;
108         uint generationId;
109 		bool isSpecial;
110     }
111     
112     using SafeMath for uint256;
113  
114     // The token being sold
115     ERC721Interface public token;
116     
117     
118     //sequentially generated ids for the animals
119     uint uniqueAnimalId=0;
120 
121     //mapping to show all the animal properties against a single id
122     mapping(uint=>AnimalProperties)  animalAgainstId;
123     
124     //mapping to show how many children does a single animal has
125     mapping(uint=>uint[])  childrenIdAgainstAnimalId;
126     
127     //the animals that have been advertised for mating
128     uint[] upForMatingList;
129 
130     //the animals that have been advertised for selling
131     uint[] upForSaleList;
132     
133     //the list of addresses that can remove animals from egg phase 
134     address[] memberAddresses;
135 
136     //animal object to be used in various functions as an intermediate variable
137     AnimalProperties  animalObject;
138 
139     //The owner percentages from mating and selling transactions
140     uint public ownerPerThousandShareForMating = 35;
141     uint public ownerPerThousandShareForBuying = 35;
142 
143     //the number of free animals an address can claim
144     uint public freeAnimalsLimit = 4;
145     
146     //variable to show whether the contract has been paused or not
147     bool public isContractPaused;
148 
149     //the fees for advertising an animal for sale and mate
150     uint public priceForMateAdvertisement;
151     uint public priceForSaleAdvertisement;
152     
153     uint public priceForBuyingCostume;
154 
155     // amount of raised money in wei
156     uint256 public weiRaised;
157 
158     // Total no of bunnies created
159     uint256 public totalBunniesCreated=0;
160 
161     //rate of each animal
162     uint256 public weiPerAnimal = 1*10**18;
163     uint[] eggPhaseAnimalIds;
164     uint[] animalIdsWithPendingCostumes;
165 
166     /**
167      * event for animals purchase logging
168      * @param purchaser who paid for the animals
169      * @param beneficiary who got the animals
170      * @param value weis paid for purchase
171      * @param amount of animals purchased
172     */
173     event AnimalsPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
174 
175   
176    function AnimalFactory(address _walletOwner,address _tokenAddress) public 
177    { 
178         require(_walletOwner != 0x0);
179         owner = _walletOwner;
180         isContractPaused = false;
181         priceForMateAdvertisement = 1 * 10 ** 16;
182         priceForSaleAdvertisement = 1 * 10 ** 16;
183         priceForBuyingCostume = 1 * 10 ** 16;
184         token = ERC721Interface(_tokenAddress);
185     }
186 
187     /**
188      * function to get animal details by id
189      **/ 
190     
191     function getAnimalById(uint aid) public constant returns 
192     (string, string,uint,uint ,uint, uint,uint)
193     {
194         if(animalAgainstId[aid].eggPhase==true)
195         {
196             return(animalAgainstId[aid].name,
197             animalAgainstId[aid].desc,
198             2**256 - 1,
199             animalAgainstId[aid].priceForSale,
200             animalAgainstId[aid].priceForMating,
201             animalAgainstId[aid].parentId1,
202             animalAgainstId[aid].parentId2
203             );
204         }
205         else 
206         {
207             return(animalAgainstId[aid].name,
208             animalAgainstId[aid].desc,
209             animalAgainstId[aid].id,
210             animalAgainstId[aid].priceForSale,
211             animalAgainstId[aid].priceForMating,
212             animalAgainstId[aid].parentId1,
213             animalAgainstId[aid].parentId2
214             );
215         }
216     }
217     function getAnimalByIdVisibility(uint aid) public constant 
218     returns (bool upforsale,bool upformating,bool eggphase,bool isbornbymating, 
219     uint birthdate, uint costumeid, uint generationid)
220     {
221         return(
222             animalAgainstId[aid].upForSale,
223             animalAgainstId[aid].upForMating,
224             animalAgainstId[aid].eggPhase,
225             animalAgainstId[aid].isBornByMating,
226             animalAgainstId[aid].birthdate,
227             animalAgainstId[aid].costumeId,
228             animalAgainstId[aid].generationId
229 
230 			
231             );
232     }
233     
234      function getOwnerByAnimalId(uint aid) public constant 
235     returns (address)
236     {
237         return token.ownerOf(aid);
238             
239     }
240     
241     /**
242      * function to get all animals against an address
243      **/ 
244     function getAllAnimalsByAddress(address ad) public constant returns (uint[] listAnimals)
245     {
246         require (!isContractPaused);
247         return token.getAnimalIdAgainstAddress(ad);
248     }
249 
250     /**
251      * claim an animal from animal factory
252      **/ 
253     function claimFreeAnimalFromAnimalFactory( string animalName, string animalDesc) public
254     {
255         require(msg.sender != 0x0);
256         require (!isContractPaused);
257         uint gId=0;
258         //owner can claim as many free animals as he or she wants
259         if (msg.sender!=owner)
260         {
261             require(token.getTotalTokensAgainstAddress(msg.sender)<freeAnimalsLimit);
262             gId=1;
263         }
264 
265         //sequentially generated animal id   
266         uniqueAnimalId++;
267         
268         //Generating an Animal Record
269         animalObject = AnimalProperties({
270             id:uniqueAnimalId,
271             name:animalName,
272             desc:animalDesc,
273             upForSale: false,
274             eggPhase: false,
275             priceForSale:0,
276             upForMating: false,
277             priceForMating:0,
278             isBornByMating: false,
279             parentId1:0,
280             parentId2:0,
281             birthdate:now,
282             costumeId:0, 
283             generationId:gId,
284 			isSpecial:false
285         });
286         token.sendToken(msg.sender, uniqueAnimalId,animalName);
287         
288         //updating the mappings to store animal information  
289         animalAgainstId[uniqueAnimalId]=animalObject;
290         totalBunniesCreated++;
291     }
292   
293     /**
294      * Function to buy animals from the factory in exchange for ethers
295      **/ 
296     function buyAnimalsFromAnimalFactory(string animalName, string animalDesc) public payable 
297     {
298         require (!isContractPaused);
299         require(validPurchase());
300         require(msg.sender != 0x0);
301     
302         uint gId=0;
303         //owner can claim as many free animals as he or she wants
304         if (msg.sender!=owner)
305         {
306             gId=1;
307         }
308 
309     
310         uint256 weiAmount = msg.value;
311         
312         // calculate token amount to be created
313         uint256 tokens = weiAmount.div(weiPerAnimal);
314         
315         // update state
316         weiRaised = weiRaised.add(weiAmount);
317 
318     
319         uniqueAnimalId++;
320         //Generating Animal Record
321         animalObject = AnimalProperties({
322             id:uniqueAnimalId,
323             name:animalName,
324             desc:animalDesc,
325             upForSale: false,
326             priceForSale:0,
327             upForMating: false,
328             eggPhase: false,
329             priceForMating:0,
330             isBornByMating:false,
331             parentId1:0,
332             parentId2:0,
333             birthdate:now,
334             costumeId:0,
335             generationId:gId,
336 			isSpecial:false
337         });
338           
339           
340         //transferring the token
341         token.sendToken(msg.sender, uniqueAnimalId,animalName); 
342         emit AnimalsPurchased(msg.sender, owner, weiAmount, tokens);
343         
344         //updating the mappings to store animal records
345         animalAgainstId[uniqueAnimalId]=animalObject;
346         
347         
348         totalBunniesCreated++;
349         
350         //transferring the ethers to the owner of the contract
351         owner.transfer(msg.value);
352     }
353   
354     /** 
355      * Buying animals from a user 
356      **/ 
357     function buyAnimalsFromUser(uint animalId) public payable 
358     {
359         require (!isContractPaused);
360         require(msg.sender != 0x0);
361         address prevOwner=token.ownerOf(animalId);
362         
363         //checking that a user is not trying to buy an animal from himself
364         require(prevOwner!=msg.sender);
365         
366         //the price of sale
367         uint price=animalAgainstId[animalId].priceForSale;
368 
369         //the percentage of owner         
370         uint OwnerPercentage=animalAgainstId[animalId].priceForSale.mul(ownerPerThousandShareForBuying);
371         OwnerPercentage=OwnerPercentage.div(1000);
372         uint priceWithOwnerPercentage = animalAgainstId[animalId].priceForSale.add(OwnerPercentage);
373         
374         //funds sent should be enough to cover the selling price plus the owner fees
375         require(msg.value>=priceWithOwnerPercentage); 
376 
377         // transfer token only
378        // token.mint(prevOwner,msg.sender,1); 
379     // transfer token here
380         token.safeTransferFrom(prevOwner,msg.sender,animalId);
381 
382         // change mapping in animalAgainstId
383         animalAgainstId[animalId].upForSale=false;
384         animalAgainstId[animalId].priceForSale=0;
385 
386         //remove from for sale list
387         for (uint j=0;j<upForSaleList.length;j++)
388         {
389           if (upForSaleList[j] == animalId)
390             delete upForSaleList[j];
391         }      
392         
393         //transfer of money from buyer to beneficiary
394         prevOwner.transfer(price);
395         
396         //transfer of percentage money to ownerWallet
397         owner.transfer(OwnerPercentage);
398         
399         // return extra funds if sent by mistake
400         if(msg.value>priceWithOwnerPercentage)
401         {
402             msg.sender.transfer(msg.value.sub(priceWithOwnerPercentage));
403         }
404     }
405   
406     /**
407      * function to accept a mate offer by offering one of your own animals 
408      * and paying ethers ofcourse
409      **/ 
410     function mateAnimal(uint parent1Id, uint parent2Id, string animalName,string animalDesc) public payable 
411     {
412         require (!isContractPaused);
413         require(msg.sender != 0x0);
414         
415         //the requester is actually the owner of the animal which he or she is offering for mating
416         require (token.ownerOf(parent2Id) == msg.sender);
417         
418         //a user cannot mate two of his own animals
419         require(token.ownerOf(parent2Id)!=token.ownerOf(parent1Id));
420         
421         //the animal id given was actually advertised for mating
422         require(animalAgainstId[parent1Id].upForMating==true);
423 		
424 		require(animalAgainstId[parent1Id].isSpecial==false);
425 		require(animalAgainstId[parent2Id].isSpecial==false);
426 		
427 
428         // the price requested for mating
429         uint price=animalAgainstId[parent1Id].priceForMating;
430         
431         // the owner fees 
432         uint OwnerPercentage=animalAgainstId[parent1Id].priceForMating.mul(ownerPerThousandShareForMating);
433         OwnerPercentage=OwnerPercentage.div(1000);
434         
435         uint priceWithOwnerPercentage = animalAgainstId[parent1Id].priceForMating.add(OwnerPercentage);
436         
437         // the ethers sent should be enough to cover the mating price and the owner fees
438         require(msg.value>=priceWithOwnerPercentage);
439         uint generationnum = 1;
440 
441         if(animalAgainstId[parent1Id].generationId >= animalAgainstId[parent2Id].generationId)
442         {
443         generationnum = animalAgainstId[parent1Id].generationId+1;
444         }
445         else{
446         generationnum = animalAgainstId[parent2Id].generationId+1;
447         
448         }
449         // sequentially generated id for animal
450          uniqueAnimalId++;
451 
452         //Adding Saving Animal Record
453         animalObject = AnimalProperties({
454             id:uniqueAnimalId,
455             name:animalName,
456             desc:animalDesc,
457             upForSale: false,
458             priceForSale:0,
459             upForMating: false,
460             eggPhase: true,     
461             priceForMating:0,
462             isBornByMating:true,
463             parentId1: parent1Id,
464             parentId2: parent2Id,
465             birthdate:now,
466             costumeId:0,
467             generationId:generationnum,
468 			isSpecial:false
469           });
470         // transfer token only
471         token.sendToken(msg.sender,uniqueAnimalId,animalName);
472         //updating the mappings to store animal information
473         animalAgainstId[uniqueAnimalId]=animalObject;
474         //adding the generated animal to egg phase list
475         eggPhaseAnimalIds.push(uniqueAnimalId);
476         
477         //adding this animal as a child to the parents who mated to produce this offspring
478         childrenIdAgainstAnimalId[parent1Id].push(uniqueAnimalId);
479         childrenIdAgainstAnimalId[parent2Id].push(uniqueAnimalId);
480 
481         //remove from for mate list
482         for (uint i=0;i<upForMatingList.length;i++)
483         {
484             if (upForMatingList[i]==parent1Id)
485                 delete upForMatingList[i];   
486         }
487         
488         //remove the parent animal from mating advertisment      
489         animalAgainstId[parent1Id].upForMating = false;
490         animalAgainstId[parent1Id].priceForMating = 0;
491         
492         //transfer of money from beneficiary to mate owner
493         token.ownerOf(parent1Id).transfer(price);
494         
495         //transfer of percentage money to ownerWallet
496         owner.transfer(OwnerPercentage);
497         
498         // return extra funds if sent by mistake
499         if(msg.value>priceWithOwnerPercentage)
500         {
501             msg.sender.transfer(msg.value.sub(priceWithOwnerPercentage));
502         }
503         
504     }
505 
506     /**
507      * function to transfer an animal to another user
508      * direct token cannot be passed as we have disabled the transfer feature
509      * all animal transfers should occur through this function
510      **/ 
511     function TransferAnimalToAnotherUser(uint animalId,address to) public 
512     {
513         require (!isContractPaused);
514         require(msg.sender != 0x0);
515         
516         //the requester of the transfer is actually the owner of the animal id provided
517         require(token.ownerOf(animalId)==msg.sender);
518         
519         //if an animal has to be transferred, it shouldnt be up for sale or mate
520         require(animalAgainstId[animalId].upForSale == false);
521         require(animalAgainstId[animalId].upForMating == false);
522         token.safeTransferFrom(msg.sender, to, animalId);
523 
524         }
525     
526     /**
527      * Advertise your animal for selling in exchange for ethers
528      **/ 
529     function putSaleRequest(uint animalId, uint salePrice) public payable
530     {
531         require (!isContractPaused);
532         //everyone except owner has to pay the adertisement fees
533         if (msg.sender!=owner)
534         {
535             require(msg.value>=priceForSaleAdvertisement);  
536         }
537         
538         //the advertiser is actually the owner of the animal id provided
539         require(token.ownerOf(animalId)==msg.sender);
540         
541         //you cannot advertise an animal for sale which is in egg phase
542         require(animalAgainstId[animalId].eggPhase==false);
543 
544         // you cannot advertise an animal for sale which is already on sale
545         require(animalAgainstId[animalId].upForSale==false);
546 
547         //you cannot put an animal for sale and mate simultaneously
548         require(animalAgainstId[animalId].upForMating==false);
549         
550         //putting up the flag for sale 
551         animalAgainstId[animalId].upForSale=true;
552         animalAgainstId[animalId].priceForSale=salePrice;
553         upForSaleList.push(animalId);
554         
555         //transferring the sale advertisement price to the owner
556         owner.transfer(msg.value);
557     }
558     
559     /**
560      * function to withdraw a sale advertisement that was put earlier
561      **/ 
562     function withdrawSaleRequest(uint animalId) public
563     {
564         require (!isContractPaused);
565         
566         // the animal id actually belongs to the requester
567         require(token.ownerOf(animalId)==msg.sender);
568         
569         // the animal in question is still up for sale
570         require(animalAgainstId[animalId].upForSale==true);
571 
572         // change the animal state to not be on sale
573         animalAgainstId[animalId].upForSale=false;
574         animalAgainstId[animalId].priceForSale=0;
575 
576         // remove the animal from sale list
577         for (uint i=0;i<upForSaleList.length;i++)
578         {
579             if (upForSaleList[i]==animalId)
580                 delete upForSaleList[i];     
581         }
582     }
583 
584     /**
585      * function to put mating request in exchange for ethers
586      **/ 
587     function putMatingRequest(uint animalId, uint matePrice) public payable
588     {
589         require(!isContractPaused);
590 		
591 		require(animalAgainstId[animalId].isSpecial==false);
592 
593         // the owner of the contract does not need to pay the mate advertisement fees
594         if (msg.sender!=owner)
595         {
596             require(msg.value>=priceForMateAdvertisement);
597         }
598     
599         require(token.ownerOf(animalId)==msg.sender);
600 
601         // an animal in egg phase cannot be put for mating
602         require(animalAgainstId[animalId].eggPhase==false);
603         
604         // an animal on sale cannot be put for mating
605         require(animalAgainstId[animalId].upForSale==false);
606         
607         // an animal already up for mating cannot be put for mating again
608         require(animalAgainstId[animalId].upForMating==false);
609         animalAgainstId[animalId].upForMating=true;
610         animalAgainstId[animalId].priceForMating=matePrice;
611         upForMatingList.push(animalId);
612 
613         // transfer the mating advertisement charges to owner
614         owner.transfer(msg.value);
615     }
616     
617     /**
618      * withdraw the mating request that was put earlier
619      **/ 
620     function withdrawMatingRequest(uint animalId) public
621     {
622         require(!isContractPaused);
623         require(token.ownerOf(animalId)==msg.sender);
624         require(animalAgainstId[animalId].upForMating==true);
625         animalAgainstId[animalId].upForMating=false;
626         animalAgainstId[animalId].priceForMating=0;
627         for (uint i=0;i<upForMatingList.length;i++)
628         {
629             if (upForMatingList[i]==animalId)
630                 delete upForMatingList[i];    
631         }
632     }
633   
634     // @return true if the transaction can buy tokens
635     function validPurchase() internal constant returns (bool) 
636     {
637         // check validity of purchase
638         if(msg.value.div(weiPerAnimal)<1)
639             return false;
640     
641         uint quotient=msg.value.div(weiPerAnimal); 
642    
643         uint actualVal=quotient.mul(weiPerAnimal);
644    
645         if(msg.value>actualVal)
646             return false;
647         else 
648             return true;
649     }
650 
651     /**
652      * function to show how many animals does an address have
653      **/
654     function showMyAnimalBalance() public view returns (uint256 tokenBalance) 
655     {
656         tokenBalance = token.balanceOf(msg.sender);
657     }
658 
659     /**
660      * function to set the new price 
661      * can only be called from owner wallet
662      **/ 
663     function setPriceRate(uint256 newPrice) public onlyOwner returns (bool) 
664     {
665         weiPerAnimal = newPrice;
666     }
667     
668      /**
669      * function to set the mate advertisement price 
670      * can only be called from owner wallet
671      **/ 
672     function setMateAdvertisementRate(uint256 newPrice) public onlyOwner returns (bool) 
673     {
674         priceForMateAdvertisement = newPrice;
675     }
676     
677      /**
678      * function to set the sale advertisement price
679      * can only be called from owner wallet
680      **/ 
681     function setSaleAdvertisementRate(uint256 newPrice) public onlyOwner returns (bool) 
682     {
683         priceForSaleAdvertisement = newPrice;
684     }
685     
686      /**
687      * function to set the sale advertisement price
688      * can only be called from owner wallet
689      **/ 
690     function setBuyingCostumeRate(uint256 newPrice) public onlyOwner returns (bool) 
691     {
692         priceForBuyingCostume = newPrice;
693     }
694     
695     
696      /**
697      * function to get all mating animal ids
698      **/ 
699     function getAllMatingAnimals() public constant returns (uint[]) 
700     {
701         return upForMatingList;
702     }
703     
704      /**
705      * function to get all sale animals ids
706      **/ 
707     function getAllSaleAnimals() public constant returns (uint[]) 
708     {
709         return upForSaleList;
710     }
711     
712      /**
713      * function to change the free animals limit for each user
714      * can only be called from owner wallet
715      **/ 
716     function changeFreeAnimalsLimit(uint limit) public onlyOwner
717     {
718         freeAnimalsLimit = limit;
719     }
720 
721      /**
722      * function to change the owner share on buying transactions
723      * can only be called from owner wallet
724      **/    
725     function changeOwnerSharePerThousandForBuying(uint buyshare) public onlyOwner
726     {
727         ownerPerThousandShareForBuying = buyshare;
728     }
729     
730     /**
731      * function to change the owner share on mating transactions
732      * can only be called from owner wallet
733      **/  
734     function changeOwnerSharePerThousandForMating(uint mateshare) public onlyOwner
735     {
736         ownerPerThousandShareForMating = mateshare;
737     }
738     
739     /**
740      * function to pause the contract
741      * can only be called from owner wallet
742      **/  
743     function pauseContract(bool isPaused) public onlyOwner
744     {
745         isContractPaused = isPaused;
746     }
747   
748     /**
749      * function to remove an animal from egg phase
750      * can be called from anyone in the member addresses list
751      **/  
752     function removeFromEggPhase(uint animalId) public
753     {
754         for (uint i=0;i<memberAddresses.length;i++)
755         {
756             if (memberAddresses[i]==msg.sender)
757             {
758                 for (uint j=0;j<eggPhaseAnimalIds.length;j++)
759                 {
760                     if (eggPhaseAnimalIds[j]==animalId)
761                     {
762                         delete eggPhaseAnimalIds[j];
763                     }
764                 }
765                 animalAgainstId[animalId].eggPhase = false;
766             }
767         }
768     }
769     
770     /**
771      * function to get all children ids of an animal
772      **/  
773     function getChildrenAgainstAnimalId(uint id) public constant returns (uint[]) 
774     {
775         return childrenIdAgainstAnimalId[id];
776     }
777     
778     /**
779      * function to get all animals in the egg phase list
780      **/  
781     function getEggPhaseList() public constant returns (uint[]) 
782     {
783         return eggPhaseAnimalIds;
784     }
785     
786     
787      /**
788      * function to get all animals in costume not yet approved list
789      **/  
790     function getAnimalIdsWithPendingCostume() public constant returns (uint[]) 
791     {
792         return animalIdsWithPendingCostumes;
793     }
794     
795        /**
796      * function to request to buy costume
797      **/  
798     function buyCostume(uint cId, uint aId) public payable 
799     {
800         require(msg.value>=priceForBuyingCostume);
801         require(!isContractPaused);
802         require(token.ownerOf(aId)==msg.sender);
803         require(animalAgainstId[aId].costumeId==0);
804         animalAgainstId[aId].costumeId=cId;
805         animalIdsWithPendingCostumes.push(aId);
806         // transfer the mating advertisement charges to owner
807         owner.transfer(msg.value);
808     }
809     
810     
811     /**
812      * function to approve a pending costume
813      * can be called from anyone in the member addresses list
814      **/  
815     function approvePendingCostume(uint animalId) public
816     {
817         for (uint i=0;i<memberAddresses.length;i++)
818         {
819             if (memberAddresses[i]==msg.sender)
820             {
821                 for (uint j=0;j<animalIdsWithPendingCostumes.length;j++)
822                 {
823                     if (animalIdsWithPendingCostumes[j]==animalId)
824                     {
825                         delete animalIdsWithPendingCostumes[j];
826                     }
827                 }
828             }
829         }
830     }
831     
832     /**
833      * function to add a member that could remove animals from egg phase
834      * can only be called from owner wallet
835      **/  
836     function addMember(address member) public onlyOwner 
837     { 
838         memberAddresses.push(member);
839     }
840   
841     /**
842      * function to return the members that could remove an animal from egg phase
843      **/  
844     function listMembers() public constant returns (address[]) 
845     { 
846         return memberAddresses;
847     }
848     
849     /**
850      * function to delete a member from the list that could remove an animal from egg phase
851      * can only be called from owner wallet
852      **/  
853     function deleteMember(address member) public onlyOwner 
854     { 
855         for (uint i=0;i<memberAddresses.length;i++)
856         {
857             if (memberAddresses[i]==member)
858             {
859                 delete memberAddresses[i];
860             }
861         }
862     }
863     /**
864      * function to update an animal
865      * can only be called from owner wallet
866      **/  
867     function updateAnimal(uint animalId, string name, string desc) public  
868     { 
869         require(msg.sender==token.ownerOf(animalId));
870         animalAgainstId[animalId].name=name;
871         animalAgainstId[animalId].desc=desc;
872         token.setAnimalMeta(animalId, name);
873     }
874 	
875 	    /**
876      * function to update an animal
877      * can only be called from owner wallet
878      **/  
879     function updateAnimalSpecial(uint animalId, bool isSpecial) public onlyOwner 
880     { 
881         require(msg.sender==token.ownerOf(animalId));
882         animalAgainstId[animalId].isSpecial=isSpecial;
883         
884     }
885    
886 }