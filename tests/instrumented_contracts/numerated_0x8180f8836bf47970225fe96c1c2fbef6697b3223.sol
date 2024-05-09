1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21      constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner, "You are not the owner of this contract.");
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
46 
47 /**
48  * @title Destructible
49  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
50  */
51 contract Destructible is Ownable {
52 
53   constructor() public payable { }
54 
55   /**
56    * @dev Transfers the current balance to the owner and terminates the contract.
57    */
58   function destroy() onlyOwner public {
59     selfdestruct(owner);
60   }
61 
62   function destroyAndSend(address _recipient) onlyOwner public {
63     selfdestruct(_recipient);
64   }
65 }
66 
67 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
68 
69 /**
70  * @title Pausable
71  * @dev Base contract which allows children to implement an emergency stop mechanism.
72  */
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   /**
81    * @dev Modifier to make a function callable only when the contract is not paused.
82    */
83   modifier whenNotPaused() {
84     require(!paused, "this contract is paused");
85     _;
86   }
87 
88   /**
89    * @dev Modifier to make a function callable only when the contract is paused.
90    */
91   modifier whenPaused() {
92     require(paused);
93     _;
94   }
95 
96   /**
97    * @dev called by the owner to pause, triggers stopped state
98    */
99   function pause() onlyOwner whenNotPaused public {
100     paused = true;
101     emit Pause();
102   }
103 
104   /**
105    * @dev called by the owner to unpause, returns to normal state
106    */
107   function unpause() onlyOwner whenPaused public {
108     paused = false;
109     emit Unpause();
110   }
111 }
112 
113 // File: zeppelin-solidity/contracts/math/SafeMath.sol
114 
115 /**
116  * @title SafeMath
117  * @dev Math operations with safety checks that throw on error
118  */
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125     if (a == 0) {
126       return 0;
127     }
128     uint256 c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   /**
144   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
160 
161 // File: contracts/marketplace/Marketplace.sol
162 
163 /**
164  * @title Interface for contracts conforming to ERC-20
165  */
166 contract ERC20Interface {
167     function transferFrom(address from, address to, uint tokens) public returns (bool success);
168 }
169 
170 /**
171  * @title Interface for contracts conforming to ERC-721
172  */
173 contract ERC721Interface {
174     function ownerOf(uint256 assetId) public view returns (address);
175     function safeTransferFrom(address from, address to, uint256 assetId) public;
176     function isAuthorized(address operator, uint256 assetId) public view returns (bool);
177     function exists(uint256 assetId) public view returns (bool);
178 }
179 
180 contract DCLEscrow is Ownable, Pausable, Destructible {
181     using SafeMath for uint256;
182 
183     ERC20Interface public acceptedToken;
184     ERC721Interface public nonFungibleRegistry;
185 
186     struct Escrow {
187         bytes32 id;
188         address seller;
189         address buyer;
190         uint256 price;
191         uint256 offer;
192         bool acceptsOffers;
193         bool publicE;
194         uint256 escrowByOwnerIdPos;
195         uint256 parcelCount;
196         address highestBidder;
197         uint256 lastOfferPrice;
198     }
199     
200     struct Offer {
201         address highestOffer;
202         uint256 highestOfferPrice;
203         address previousOffer;
204     }
205     
206 
207     mapping (uint256 => Escrow) public escrowByAssetId;
208     mapping (bytes32 => Escrow) public escrowByEscrowId;
209     mapping (bytes32 => Offer) public offersByEscrowId;
210     
211     mapping (address => Escrow[]) public escrowByOwnerId;
212     
213     mapping(address => uint256) public openedEscrowsByOwnerId;
214     mapping(address => uint256) public ownerEscrowsCounter;
215     
216     mapping(address => uint256[]) public allOwnerParcelsOnEscrow;
217     mapping(bytes32 => uint256[]) public assetIdByEscrowId;
218     mapping(address => bool) public whitelistAddresses;
219 
220     uint256 public whitelistCounter;
221     uint256 public publicationFeeInWei;
222     //15000000000000000000
223     
224     uint256 private publicationFeeTotal;
225     bytes32[] public allEscrowIds;
226     //address[] public whitelistAddressGetter;
227 
228     /* EVENTS */
229     event EscrowCreated(
230         bytes32 id,
231         address indexed seller, 
232         address indexed buyer,
233         uint256 priceInWei,
234         bool acceptsOffers,
235         bool publicE,
236         uint256 parcels
237     );
238     
239 
240     event EscrowSuccessful(
241         bytes32 id,
242         address indexed seller, 
243         uint256 totalPrice, 
244         address indexed winner
245     );
246     
247     event EscrowCancelled(
248         bytes32 id,
249         address indexed seller
250     );
251     
252     function addAddressWhitelist(address toWhitelist) public onlyOwner
253     {
254         require(toWhitelist != address(0), "Address cannot be empty.");
255         whitelistAddresses[toWhitelist] = true;
256     }
257     
258     /*
259     function getwhitelistCounter() public onlyOwner view returns(uint256)
260     {
261         return whitelistCounter;
262     }
263     
264     function getwhitelistAddress(uint256 index) public onlyOwner view returns(address)
265     {
266         return whitelistAddressGetter[index];
267     }
268     
269     
270     function deleteWhitelistAddress(address toDelete, uint256 index) public onlyOwner
271     {
272         require(toDelete != address(0), "Address cannot be blank.");
273         require(index > 0, "index needs to be greater than zero.");
274        delete whitelistAddresses[toDelete];
275        delete whitelistAddressGetter[index];
276     }
277     */
278     
279     function updateEscrow(address _acceptedToken, address _nonFungibleRegistry) public onlyOwner {
280         acceptedToken = ERC20Interface(_acceptedToken);
281         nonFungibleRegistry = ERC721Interface(_nonFungibleRegistry);
282     }
283     
284     constructor (address _acceptedToken, address _nonFungibleRegistry) public {
285         
286         acceptedToken = ERC20Interface(_acceptedToken);
287         nonFungibleRegistry = ERC721Interface(_nonFungibleRegistry);
288     }
289 
290     function setPublicationFee(uint256 publicationFee) onlyOwner public {
291         publicationFeeInWei = publicationFee;
292     }
293     
294     function getPublicationFeeTotal() public onlyOwner view returns(uint256)
295     {
296         return publicationFeeTotal;
297     }
298     
299     function getTotalEscrowCount() public view returns(uint256)
300     {
301         return allEscrowIds.length;
302     }
303     
304     function getSingleEscrowAdmin(bytes32 index) public view returns (bytes32, address, address,uint256, uint256, bool, bool, uint256, uint256, address, uint256) {
305     Escrow storage tempEscrow = escrowByEscrowId[index];
306 
307     return (
308     tempEscrow.id,
309     tempEscrow.seller, 
310     tempEscrow.buyer, 
311     tempEscrow.price, 
312     tempEscrow.offer, 
313     tempEscrow.publicE,
314     tempEscrow.acceptsOffers,
315     tempEscrow.escrowByOwnerIdPos,
316     tempEscrow.parcelCount,
317     tempEscrow.highestBidder,
318     tempEscrow.lastOfferPrice);
319 }
320     
321     function getAssetByEscrowIdLength(bytes32 escrowId) public view returns (uint256) {
322     return assetIdByEscrowId[escrowId].length;
323     }
324     
325     function getSingleAssetByEscrowIdLength(bytes32 escrowId, uint index) public view returns (uint256) {
326     return assetIdByEscrowId[escrowId][index];
327     }
328     
329     function getEscrowCountByAssetIdArray(address ownerAddress) public view returns (uint256) {
330     return ownerEscrowsCounter[ownerAddress];
331     }
332     
333     function getAllOwnedParcelsOnEscrow(address ownerAddress) public view returns (uint256) {
334     return allOwnerParcelsOnEscrow[ownerAddress].length;
335     }
336     
337     function getParcelAssetIdOnEscrow(address ownerAddress,uint index) public view returns (uint256) {
338     return allOwnerParcelsOnEscrow[ownerAddress][index];
339     }
340     
341     function getEscrowCountById(address ownerAddress) public view returns (uint) {
342     return escrowByOwnerId[ownerAddress].length;
343     }
344     
345     function getEscrowInfo(address ownerAddress, uint index) public view returns (bytes32, address, address,uint256, uint256, bool, bool, uint256, uint256, address, uint256) {
346     Escrow storage tempEscrow = escrowByOwnerId[ownerAddress][index];
347 
348     return (
349     tempEscrow.id,
350     tempEscrow.seller, 
351     tempEscrow.buyer, 
352     tempEscrow.price, 
353     tempEscrow.offer, 
354     tempEscrow.publicE,
355     tempEscrow.acceptsOffers,
356     tempEscrow.escrowByOwnerIdPos,
357     tempEscrow.parcelCount,
358     tempEscrow.highestBidder,
359     tempEscrow.lastOfferPrice);
360 }
361 
362    
363     function placeOffer(bytes32 escrowId, uint256 offerPrice) public whenNotPaused
364     {
365         address seller = escrowByEscrowId[escrowId].seller;
366         require(seller != msg.sender, "You are the owner of this escrow.");
367         require(seller != address(0));
368         require(offerPrice > 0, "Offer Price needs to be greater than zero");
369         require(escrowByEscrowId[escrowId].id != '0x0', "That escrow ID is no longer valid.");
370 
371         
372         bool acceptsOffers = escrowByEscrowId[escrowId].acceptsOffers;
373         require(acceptsOffers, "This escrow does not accept offers.");
374 
375         //address buyer = escrowByEscrowId[escrowId].buyer;
376         bool isPublic = escrowByEscrowId[escrowId].publicE;
377         if(!isPublic)
378         {
379             require(msg.sender == escrowByEscrowId[escrowId].buyer, "You are not authorized for this escrow.");
380         }
381         
382         Escrow memory tempEscrow = escrowByEscrowId[escrowId];
383         tempEscrow.lastOfferPrice = tempEscrow.offer;
384         tempEscrow.offer = offerPrice;
385         tempEscrow.highestBidder = msg.sender;
386         escrowByEscrowId[escrowId] = tempEscrow;
387         
388   
389     }
390     
391     function createNewEscrow(uint256[] memory assedIds, uint256 escrowPrice, bool doesAcceptOffers, bool isPublic, address buyer) public whenNotPaused{
392         //address tempAssetOwner = msg.sender;
393         uint256 tempParcelCount = assedIds.length;
394         
395         for(uint i = 0; i < tempParcelCount; i++)
396         {
397             address assetOwner = nonFungibleRegistry.ownerOf(assedIds[i]);
398             require(msg.sender == assetOwner, "You are not the owner of this parcel.");
399             require(nonFungibleRegistry.exists(assedIds[i]), "This parcel does not exist.");
400             require(nonFungibleRegistry.isAuthorized(address(this), assedIds[i]), "You have not authorized DCL Escrow to manage your LAND tokens.");
401             allOwnerParcelsOnEscrow[assetOwner].push(assedIds[i]);
402         }
403         
404         require(escrowPrice > 0, "Please pass a price greater than zero.");
405         
406         bytes32 escrowId = keccak256(abi.encodePacked(
407             block.timestamp, 
408             msg.sender,
409             assedIds[0], 
410             escrowPrice
411         ));
412         
413          assetIdByEscrowId[escrowId] = assedIds;
414         
415         //uint256 memEscrowByOwnerIdPos = openedEscrowsByOwnerId[assetOwner];
416         
417         Escrow memory memEscrow = Escrow({
418             id: escrowId,
419             seller: msg.sender,
420             buyer: buyer,
421             price: escrowPrice,
422             offer:0,
423             publicE:isPublic,
424             acceptsOffers: doesAcceptOffers,
425             escrowByOwnerIdPos: 0,
426             parcelCount: tempParcelCount,
427             highestBidder: address(0),
428             lastOfferPrice: 0
429             });
430             
431         escrowByEscrowId[escrowId] = memEscrow;
432         escrowByOwnerId[msg.sender].push(memEscrow);
433         //ownerEscrowsCounter[msg.sender] = getEscrowCountByAssetIdArray(msg.sender) + 1;
434         
435         
436            allEscrowIds.push(escrowId);
437         
438         
439             emit EscrowCreated(
440             escrowId,
441             msg.sender,
442             buyer,
443             escrowPrice,
444             doesAcceptOffers,
445             isPublic,
446             tempParcelCount
447         );
448         
449     }
450     
451     function cancelAllEscrows() public onlyOwner
452         {
453             
454         //need to delete each escrow by escrow id
455         pause();
456          for(uint e = 0; e < getTotalEscrowCount(); e++)
457         {
458              adminRemoveEscrow(allEscrowIds[e]);
459         }
460         delete allEscrowIds;
461        unpause();
462     }
463     
464     function adminRemoveEscrow(bytes32 escrowId) public onlyOwner
465     {
466         address seller = escrowByEscrowId[escrowId].seller;
467         //require(seller == msg.sender || msg.sender == owner);
468     
469         //uint256 escrowOwnerPos = escrowByEscrowId[escrowId].escrowByOwnerIdPos;
470         
471         delete escrowByEscrowId[escrowId];
472 
473         for(uint t = 0; t < escrowByOwnerId[seller].length; t++)
474         {
475             if(escrowByOwnerId[seller][t].id == escrowId)
476             {
477                 delete escrowByOwnerId[seller][t];
478             }
479         }
480         
481         //escrowByOwnerId[seller].splice
482         //ownerEscrowsCounter[seller] = getEscrowCountByAssetIdArray(seller) - 1;
483         
484         uint256[] memory assetIds = assetIdByEscrowId[escrowId];
485         
486         for(uint i = 0; i < assetIds.length; i++)
487         {
488             for(uint j = 0; j < allOwnerParcelsOnEscrow[seller].length; j++)
489             {
490                 if(assetIds[i] == allOwnerParcelsOnEscrow[seller][j])
491                 {
492                     delete allOwnerParcelsOnEscrow[seller][j];
493                 }
494             }
495         }
496         
497         emit EscrowCancelled(escrowId, seller);
498     }
499     
500     function removeEscrow(bytes32 escrowId) public whenNotPaused
501     {
502         address seller = escrowByEscrowId[escrowId].seller;
503         require(seller == msg.sender || msg.sender == owner);
504     
505         //uint256 escrowOwnerPos = escrowByEscrowId[escrowId].escrowByOwnerIdPos;
506         
507         delete escrowByEscrowId[escrowId];
508 
509         for(uint t = 0; t < escrowByOwnerId[seller].length; t++)
510         {
511             if(escrowByOwnerId[seller][t].id == escrowId)
512             {
513                 delete escrowByOwnerId[seller][t];
514             }
515         }
516         
517         //escrowByOwnerId[seller].splice
518         //ownerEscrowsCounter[seller] = getEscrowCountByAssetIdArray(seller) - 1;
519         
520         uint256[] memory assetIds = assetIdByEscrowId[escrowId];
521         
522         for(uint i = 0; i < assetIds.length; i++)
523         {
524             for(uint j = 0; j < allOwnerParcelsOnEscrow[seller].length; j++)
525             {
526                 if(assetIds[i] == allOwnerParcelsOnEscrow[seller][j])
527                 {
528                     delete allOwnerParcelsOnEscrow[seller][j];
529                 }
530             }
531         }
532         
533         delete allEscrowIds;
534 
535         
536         emit EscrowCancelled(escrowId, seller);
537     }
538  
539  
540     function acceptEscrow(bytes32 escrowId) public whenNotPaused {
541         address seller = escrowByEscrowId[escrowId].seller;
542         require(seller != msg.sender);
543         require(seller != address(0));
544 
545         address buyer = escrowByEscrowId[escrowId].buyer;
546         bool isPublic = escrowByEscrowId[escrowId].publicE;
547         if(!isPublic)
548         {
549             require(msg.sender == escrowByEscrowId[escrowId].buyer, "You are not authorized for this escrow.");
550         }
551 
552         //need to add check that offer price is accepted
553 
554 
555         uint256[] memory assetIds = assetIdByEscrowId[escrowId];
556         
557         for(uint a = 0; a < assetIds.length; a++)
558         {
559             require(seller == nonFungibleRegistry.ownerOf(assetIds[a]));
560         }
561         
562         uint escrowPrice = escrowByEscrowId[escrowId].price;
563         
564         if (publicationFeeInWei > 0) {
565             if(!whitelistAddresses[msg.sender])
566             {
567                 acceptedToken.transferFrom(
568                 msg.sender,
569                 owner,
570                 publicationFeeInWei
571             );
572             }
573             
574             if(!whitelistAddresses[seller])
575             {
576                 acceptedToken.transferFrom(
577                 seller,
578                 owner,
579                 publicationFeeInWei
580             );
581             }
582             
583         }
584         
585         // Transfer sale amount to seller
586         acceptedToken.transferFrom(
587             msg.sender,
588             seller,
589             escrowPrice
590         );
591         
592         for(uint counter = 0; counter < assetIds.length; counter++)
593         {
594             uint256 tempId = assetIds[counter];
595             nonFungibleRegistry.safeTransferFrom(
596             seller,
597             msg.sender,
598             tempId
599             ); 
600             
601         }
602 
603         
604         for(uint t = 0; t < escrowByOwnerId[seller].length; t++)
605         {
606             if(escrowByOwnerId[seller][t].id == escrowId)
607             {
608                 delete escrowByOwnerId[seller][t];
609             }
610         }
611         
612         
613         for(uint i = 0; i < assetIds.length; i++)
614         {
615             for(uint j = 0; j < allOwnerParcelsOnEscrow[seller].length; j++)
616             {
617                 if(assetIds[i] == allOwnerParcelsOnEscrow[seller][j])
618                 {
619                     delete allOwnerParcelsOnEscrow[seller][j];
620                 }
621             }
622         }
623 
624 
625         delete escrowByEscrowId[escrowId]; 
626         delete assetIdByEscrowId[escrowId];
627 
628             emit EscrowSuccessful(
629             escrowId,
630             seller,
631             escrowPrice,
632             buyer
633         );
634 
635     }
636  }