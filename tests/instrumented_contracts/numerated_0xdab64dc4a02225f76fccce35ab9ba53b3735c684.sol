1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8   // Required methods
9   function approve(address _to, uint256 _tokenId) public;
10   function balanceOf(address _owner) public view returns (uint256 balance);
11   function implementsERC721() public pure returns (bool);
12   function ownerOf(uint256 _tokenId) public view returns (address addr);
13   function takeOwnership(uint256 _tokenId) public;
14   function totalSupply() public view returns (uint256 total);
15   function transferFrom(address _from, address _to, uint256 _tokenId) public;
16   function transfer(address _to, uint256 _tokenId) public;
17 
18   event Transfer(address indexed from, address indexed to, uint256 tokenId);
19   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
20 
21   // Optional
22   // function name() public view returns (string name);
23   // function symbol() public view returns (string symbol);
24   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
25   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
26 }
27 
28 
29 contract CelebrityToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new person comes into existence.
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev The TokenSold event is fired whenever a token is sold.
37   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   /// @dev Transfer event as defined in current draft of ERC721. 
40   ///  ownership is assigned, including births.
41   event Transfer(address from, address to, uint256 tokenId);
42 
43   /*** CONSTANTS ***/
44 
45   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
46   string public constant NAME = "CryptoCelebrities"; // solhint-disable-line
47   string public constant SYMBOL = "CelebrityToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 5000;
51   uint256 private firstStepLimit =  0.053613 ether;
52   uint256 private secondStepLimit = 0.564957 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from person IDs to the address that owns them. All persons have
57   ///  some valid owner address.
58   mapping (uint256 => address) public personIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from PersonIDs to an address that has been approved to call
65   ///  transferFrom(). Each Person can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public personIndexToApproved;
68 
69   // @dev A mapping from PersonIDs to the price of the token.
70   mapping (uint256 => uint256) private personIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   uint256 public promoCreatedCount;
77 
78   /*** DATATYPES ***/
79   struct Person {
80     string name;
81   }
82 
83   Person[] private persons;
84 
85   /*** ACCESS MODIFIERS ***/
86   /// @dev Access modifier for CEO-only functionality
87   modifier onlyCEO() {
88     require(msg.sender == ceoAddress);
89     _;
90   }
91 
92   /// @dev Access modifier for COO-only functionality
93   modifier onlyCOO() {
94     require(msg.sender == cooAddress);
95     _;
96   }
97 
98   /// Access modifier for contract owner only functionality
99   modifier onlyCLevel() {
100     require(
101       msg.sender == ceoAddress ||
102       msg.sender == cooAddress
103     );
104     _;
105   }
106 
107   /*** CONSTRUCTOR ***/
108   function CelebrityToken() public {
109     ceoAddress = msg.sender;
110     cooAddress = msg.sender;
111   }
112 
113   /*** PUBLIC FUNCTIONS ***/
114   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
115   /// @param _to The address to be granted transfer approval. Pass address(0) to
116   ///  clear all approvals.
117   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
118   /// @dev Required for ERC-721 compliance.
119   function approve(
120     address _to,
121     uint256 _tokenId
122   ) public {
123     // Caller must own token.
124     require(_owns(msg.sender, _tokenId));
125 
126     personIndexToApproved[_tokenId] = _to;
127 
128     Approval(msg.sender, _to, _tokenId);
129   }
130 
131   /// For querying balance of a particular account
132   /// @param _owner The address for balance query
133   /// @dev Required for ERC-721 compliance.
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return ownershipTokenCount[_owner];
136   }
137 
138   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
139   function createPromoPerson(address _owner, string _name, uint256 _price) public onlyCOO {
140     require(promoCreatedCount < PROMO_CREATION_LIMIT);
141 
142     address personOwner = _owner;
143     if (personOwner == address(0)) {
144       personOwner = cooAddress;
145     }
146 
147     if (_price <= 0) {
148       _price = startingPrice;
149     }
150 
151     promoCreatedCount++;
152     _createPerson(_name, personOwner, _price);
153   }
154 
155   /// @dev Creates a new Person with the given name.
156   function createContractPerson(string _name) public onlyCOO {
157     _createPerson(_name, address(this), startingPrice);
158   }
159 
160   /// @notice Returns all the relevant information about a specific person.
161   /// @param _tokenId The tokenId of the person of interest.
162   function getPerson(uint256 _tokenId) public view returns (
163     string personName,
164     uint256 sellingPrice,
165     address owner
166   ) {
167     Person storage person = persons[_tokenId];
168     personName = person.name;
169     sellingPrice = personIndexToPrice[_tokenId];
170     owner = personIndexToOwner[_tokenId];
171   }
172 
173   function implementsERC721() public pure returns (bool) {
174     return true;
175   }
176 
177   /// @dev Required for ERC-721 compliance.
178   function name() public pure returns (string) {
179     return NAME;
180   }
181 
182   /// For querying owner of token
183   /// @param _tokenId The tokenID for owner inquiry
184   /// @dev Required for ERC-721 compliance.
185   function ownerOf(uint256 _tokenId)
186     public
187     view
188     returns (address owner)
189   {
190     owner = personIndexToOwner[_tokenId];
191     require(owner != address(0));
192   }
193 
194   function payout(address _to) public onlyCLevel {
195     _payout(_to);
196   }
197 
198   // Allows someone to send ether and obtain the token
199   function purchase(uint256 _tokenId) public payable {
200     address oldOwner = personIndexToOwner[_tokenId];
201     address newOwner = msg.sender;
202 
203     uint256 sellingPrice = personIndexToPrice[_tokenId];
204 
205     // Making sure token owner is not sending to self
206     require(oldOwner != newOwner);
207 
208     // Safety check to prevent against an unexpected 0x0 default.
209     require(_addressNotNull(newOwner));
210 
211     // Making sure sent amount is greater than or equal to the sellingPrice
212     require(msg.value >= sellingPrice);
213 
214     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
215     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
216 
217     // Update prices
218     if (sellingPrice < firstStepLimit) {
219       // first stage
220       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
221     } else if (sellingPrice < secondStepLimit) {
222       // second stage
223       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
224     } else {
225       // third stage
226       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
227     }
228 
229     _transfer(oldOwner, newOwner, _tokenId);
230 
231     // Pay previous tokenOwner if owner is not contract
232     if (oldOwner != address(this)) {
233       oldOwner.transfer(payment); //(1-0.06)
234     }
235 
236     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner, persons[_tokenId].name);
237 
238     msg.sender.transfer(purchaseExcess);
239   }
240 
241   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
242     return personIndexToPrice[_tokenId];
243   }
244 
245   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
246   /// @param _newCEO The address of the new CEO
247   function setCEO(address _newCEO) public onlyCEO {
248     require(_newCEO != address(0));
249 
250     ceoAddress = _newCEO;
251   }
252 
253   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
254   /// @param _newCOO The address of the new COO
255   function setCOO(address _newCOO) public onlyCEO {
256     require(_newCOO != address(0));
257 
258     cooAddress = _newCOO;
259   }
260 
261   /// @dev Required for ERC-721 compliance.
262   function symbol() public pure returns (string) {
263     return SYMBOL;
264   }
265 
266   /// @notice Allow pre-approved user to take ownership of a token
267   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
268   /// @dev Required for ERC-721 compliance.
269   function takeOwnership(uint256 _tokenId) public {
270     address newOwner = msg.sender;
271     address oldOwner = personIndexToOwner[_tokenId];
272 
273     // Safety check to prevent against an unexpected 0x0 default.
274     require(_addressNotNull(newOwner));
275 
276     // Making sure transfer is approved
277     require(_approved(newOwner, _tokenId));
278 
279     _transfer(oldOwner, newOwner, _tokenId);
280   }
281 
282   /// @param _owner The owner whose celebrity tokens we are interested in.
283   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
284   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
285   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
286   ///  not contract-to-contract calls.
287   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
288     uint256 tokenCount = balanceOf(_owner);
289     if (tokenCount == 0) {
290         // Return an empty array
291       return new uint256[](0);
292     } else {
293       uint256[] memory result = new uint256[](tokenCount);
294       uint256 totalPersons = totalSupply();
295       uint256 resultIndex = 0;
296 
297       uint256 personId;
298       for (personId = 0; personId <= totalPersons; personId++) {
299         if (personIndexToOwner[personId] == _owner) {
300           result[resultIndex] = personId;
301           resultIndex++;
302         }
303       }
304       return result;
305     }
306   }
307 
308   /// For querying totalSupply of token
309   /// @dev Required for ERC-721 compliance.
310   function totalSupply() public view returns (uint256 total) {
311     return persons.length;
312   }
313 
314   /// Owner initates the transfer of the token to another account
315   /// @param _to The address for the token to be transferred to.
316   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
317   /// @dev Required for ERC-721 compliance.
318   function transfer(
319     address _to,
320     uint256 _tokenId
321   ) public {
322     require(_owns(msg.sender, _tokenId));
323     require(_addressNotNull(_to));
324 
325     _transfer(msg.sender, _to, _tokenId);
326   }
327 
328   /// Third-party initiates transfer of token from address _from to address _to
329   /// @param _from The address for the token to be transferred from.
330   /// @param _to The address for the token to be transferred to.
331   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
332   /// @dev Required for ERC-721 compliance.
333   function transferFrom(
334     address _from,
335     address _to,
336     uint256 _tokenId
337   ) public {
338     require(_owns(_from, _tokenId));
339     require(_approved(_to, _tokenId));
340     require(_addressNotNull(_to));
341 
342     _transfer(_from, _to, _tokenId);
343   }
344 
345   /*** PRIVATE FUNCTIONS ***/
346   /// Safety check on _to address to prevent against an unexpected 0x0 default.
347   function _addressNotNull(address _to) private pure returns (bool) {
348     return _to != address(0);
349   }
350 
351   /// For checking approval of transfer for address _to
352   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
353     return personIndexToApproved[_tokenId] == _to;
354   }
355 
356   /// For creating Person
357   function _createPerson(string _name, address _owner, uint256 _price) private {
358     Person memory _person = Person({
359       name: _name
360     });
361     uint256 newPersonId = persons.push(_person) - 1;
362 
363     // It's probably never going to happen, 4 billion tokens are A LOT, but
364     // let's just be 100% sure we never let this happen.
365     require(newPersonId == uint256(uint32(newPersonId)));
366 
367     Birth(newPersonId, _name, _owner);
368 
369     personIndexToPrice[newPersonId] = _price;
370 
371     // This will assign ownership, and also emit the Transfer event as
372     // per ERC721 draft
373     _transfer(address(0), _owner, newPersonId);
374   }
375 
376   /// Check for token ownership
377   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
378     return claimant == personIndexToOwner[_tokenId];
379   }
380 
381   /// For paying out balance on contract
382   function _payout(address _to) private {
383     if (_to == address(0)) {
384       ceoAddress.transfer(this.balance);
385     } else {
386       _to.transfer(this.balance);
387     }
388   }
389 
390   /// @dev Assigns ownership of a specific Person to an address.
391   function _transfer(address _from, address _to, uint256 _tokenId) private {
392     // Since the number of persons is capped to 2^32 we can't overflow this
393     ownershipTokenCount[_to]++;
394     //transfer ownership
395     personIndexToOwner[_tokenId] = _to;
396 
397     // When creating new persons _from is 0x0, but we can't account that address.
398     if (_from != address(0)) {
399       ownershipTokenCount[_from]--;
400       // clear any previously approved ownership exchange
401       delete personIndexToApproved[_tokenId];
402     }
403 
404     // Emit the transfer event.
405     Transfer(_from, _to, _tokenId);
406   }
407 }
408 library SafeMath {
409 
410   /**
411   * @dev Multiplies two numbers, throws on overflow.
412   */
413   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
414     if (a == 0) {
415       return 0;
416     }
417     uint256 c = a * b;
418     assert(c / a == b);
419     return c;
420   }
421 
422   /**
423   * @dev Integer division of two numbers, truncating the quotient.
424   */
425   function div(uint256 a, uint256 b) internal pure returns (uint256) {
426     // assert(b > 0); // Solidity automatically throws when dividing by 0
427     uint256 c = a / b;
428     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
429     return c;
430   }
431 
432   /**
433   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
434   */
435   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436     assert(b <= a);
437     return a - b;
438   }
439 
440   /**
441   * @dev Adds two numbers, throws on overflow.
442   */
443   function add(uint256 a, uint256 b) internal pure returns (uint256) {
444     uint256 c = a + b;
445     assert(c >= a);
446     return c;
447   }
448 }
449 
450 /// @author Artyom Harutyunyan <artyomharutyunyans@gmail.com>
451 
452 contract CelebrityBreederToken is ERC721 {
453   
454    /// @dev The Birth event is fired whenever a new person comes into existence.
455   event Birth(uint256 tokenId, string name, address owner);
456 
457   /// @dev The TokenSold event is fired whenever a token is sold.
458   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
459 
460   /// @dev Transfer event as defined in current draft of ERC721. 
461   ///  ownership is assigned, including births.
462   event Transfer(address from, address to, uint256 tokenId);
463   event Trained(address caller, uint256 tokenId, bool generation);
464   event Beaten(address caller, uint256 tokenId, bool generation);
465   event SiringPriceEvent(address caller, uint256 tokenId, bool generation, uint price);
466   event SellingPriceEvent(address caller, uint256 tokenId, bool generation, uint price);
467   event GenesInitialisedEvent(address caller, uint256 tokenId, bool generation, uint genes);
468   
469   CelebrityToken private CelGen0=CelebrityToken(0xbb5Ed1EdeB5149AF3ab43ea9c7a6963b3C1374F7); //@Artyom Pointing to original CC
470   
471   string public constant NAME = "CryptoCelebrityBreederCards"; 
472   string public constant SYMBOL = "CeleBreedCard"; 
473 
474   uint256 public breedingFee = 0.01 ether;
475   uint256 public initialTraining = 0.00001 ether;
476   uint256 public initialBeating = 0.00002 ether;
477   uint256 private constant CreationLimitGen0 = 5000;
478   uint256 private constant CreationLimitGen1 = 2500000;
479   uint256 public constant MaxValue =  100000000 ether;
480   
481   mapping (uint256 => address) public personIndexToOwnerGen1;
482   mapping (address => uint256) private ownershipTokenCountGen1;
483   mapping (uint256 => address) public personIndexToApprovedGen1;
484   mapping (uint256 => uint256) private personIndexToPriceGen1;
485   mapping (uint256 => address) public ExternalAllowdContractGen0;
486   mapping (uint256 => address) public ExternalAllowdContractGen1; 
487   mapping (uint256 => uint256) public personIndexToSiringPrice0;
488   mapping (uint256 => uint256) public personIndexToSiringPrice1;
489   address public CeoAddress; 
490   address public DevAddress;
491   
492    struct Person {
493     string name;
494     string surname; 
495     uint64 genes; 
496     uint64 birthTime;
497     uint32 fatherId;
498     uint32 motherId;
499     uint32 readyToBreedWithId;
500     uint32 trainedcount;
501     uint32 beatencount;
502     bool readyToBreedWithGen;
503     bool gender;
504     bool fatherGeneration;
505     bool motherGeneration;
506   }
507   
508   Person[] private PersonsGen0;
509   Person[] private PersonsGen1;
510   
511     modifier onlyCEO() {
512     require(msg.sender == CeoAddress);
513     _;
514   }
515 
516   modifier onlyDEV() {
517     require(msg.sender == DevAddress);
518     _;
519   }
520   
521    modifier onlyPlayers() {
522     require(ownershipTokenCountGen1[msg.sender]>0 || CelGen0.balanceOf(msg.sender)>0);
523     _;
524   }
525 
526   /// Access modifier for contract owner only functionality
527  /* modifier onlyTopLevel() {
528     require(
529       msg.sender == CeoAddress ||
530       msg.sender == DevAddress
531     );
532     _;
533   }
534   */
535   function CelebrityBreederToken() public { 
536       CeoAddress= msg.sender;
537       DevAddress= msg.sender;
538   }
539     function setBreedingFee(uint256 newfee) external onlyCEO{
540       breedingFee=newfee;
541   }
542   function allowexternalContract(address _to, uint256 _tokenId,bool _tokengeneration) public { 
543     // Caller must own token.
544     require(_owns(msg.sender, _tokenId, _tokengeneration));
545     
546     if(_tokengeneration) {
547         if(_addressNotNull(_to)) {
548             ExternalAllowdContractGen1[_tokenId]=_to;
549         }
550         else {
551              delete ExternalAllowdContractGen1[_tokenId];
552         }
553     }
554     else {
555        if(_addressNotNull(_to)) {
556             ExternalAllowdContractGen0[_tokenId]=_to;
557         }
558         else {
559              delete ExternalAllowdContractGen0[_tokenId];
560         }
561     }
562 
563   }
564   
565   
566   //@Artyom Required for ERC-721 compliance.
567   function approve(address _to, uint256 _tokenId) public { //@Artyom only gen1
568     // Caller must own token.
569     require(_owns(msg.sender, _tokenId, true));
570 
571     personIndexToApprovedGen1[_tokenId] = _to;
572 
573     Approval(msg.sender, _to, _tokenId);
574   }
575   // @Artyom Required for ERC-721 compliance.
576   //@Artyom only gen1
577    function balanceOf(address _owner) public view returns (uint256 balance) {
578     return ownershipTokenCountGen1[_owner];
579   }
580   
581     function getPerson(uint256 _tokenId,bool generation) public view returns ( string name, string surname, uint64 genes,uint64 birthTime, uint32 readyToBreedWithId, uint32 trainedcount,uint32 beatencount,bool readyToBreedWithGen, bool gender) {
582     Person person;
583     if(generation==false) {
584         person = PersonsGen0[_tokenId];
585     }
586     else {
587         person = PersonsGen1[_tokenId];
588     }
589          
590     name = person.name;
591     surname=person.surname;
592     genes=person.genes;
593     birthTime=person.birthTime;
594     readyToBreedWithId=person.readyToBreedWithId;
595     trainedcount=person.trainedcount;
596     beatencount=person.beatencount;
597     readyToBreedWithGen=person.readyToBreedWithGen;
598     gender=person.gender;
599 
600   }
601    function getPersonParents(uint256 _tokenId, bool generation) public view returns ( uint32 fatherId, uint32 motherId, bool fatherGeneration, bool motherGeneration) {
602     Person person;
603     if(generation==false) {
604         person = PersonsGen0[_tokenId];
605     }
606     else {
607         person = PersonsGen1[_tokenId];
608     }
609          
610     fatherId=person.fatherId;
611     motherId=person.motherId;
612     fatherGeneration=person.fatherGeneration;
613     motherGeneration=person.motherGeneration;
614   }
615   // @Artyom Required for ERC-721 compliance.
616    function implementsERC721() public pure returns (bool) { 
617     return true;
618   }
619 
620   // @Artyom Required for ERC-721 compliance.
621   function name() public pure returns (string) {
622     return NAME;
623   }
624 
625 // @Artyom Required for ERC-721 compliance.
626   function ownerOf(uint256 _tokenId) public view returns (address owner)
627   {
628     owner = personIndexToOwnerGen1[_tokenId];
629     require(_addressNotNull(owner));
630   }
631   
632   //@Artyom only gen1
633    function purchase(uint256 _tokenId) public payable {
634     address oldOwner = personIndexToOwnerGen1[_tokenId];
635     address newOwner = msg.sender;
636 
637     uint256 sellingPrice = personIndexToPriceGen1[_tokenId];
638     personIndexToPriceGen1[_tokenId]=MaxValue;
639 
640     // Making sure token owner is not sending to self
641     require(oldOwner != newOwner);
642 
643     // Safety check to prevent against an unexpected 0x0 default.
644     require(_addressNotNull(newOwner));
645 
646     // Making sure sent amount is greater than or equal to the sellingPrice
647     require(msg.value >= sellingPrice);
648 
649    // uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
650     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
651 
652     _transfer(oldOwner, newOwner, _tokenId);
653 
654     // Pay previous tokenOwner if owner is not contract
655     if (oldOwner != address(this)) {
656     //  oldOwner.transfer(payment); //(1-0.06) //old code for holding some percents
657     oldOwner.transfer(sellingPrice);
658     }
659     blankbreedingdata(_tokenId,true);
660 
661     TokenSold(_tokenId, sellingPrice, personIndexToPriceGen1[_tokenId], oldOwner, newOwner, PersonsGen1[_tokenId].name);
662 
663     msg.sender.transfer(purchaseExcess);
664   }
665   
666    //@Artyom only gen1
667    function priceOf(uint256 _tokenId) public view returns (uint256 price) {
668     return personIndexToPriceGen1[_tokenId];
669   }
670 
671  
672   function setCEO(address _newCEO) external onlyCEO {
673     require(_addressNotNull(_newCEO));
674 
675     CeoAddress = _newCEO;
676   }
677 
678  //@Artyom only gen1
679  function setprice(uint256 _tokenId, uint256 _price) public {
680     require(_owns(msg.sender, _tokenId, true));
681     if(_price<=0 || _price>=MaxValue) {
682         personIndexToPriceGen1[_tokenId]=MaxValue;
683     }
684     else {
685         personIndexToPriceGen1[_tokenId]=_price;
686     }
687     SellingPriceEvent(msg.sender,_tokenId,true,_price);
688  }
689  
690   function setDEV(address _newDEV) external onlyDEV {
691     require(_addressNotNull(_newDEV));
692 
693     DevAddress = _newDEV;
694   }
695   
696     // @Artyom Required for ERC-721 compliance.
697   function symbol() public pure returns (string) {
698     return SYMBOL;
699   }
700 
701 
702   // @Artyom Required for ERC-721 compliance.
703    //@Artyom only gen1
704   function takeOwnership(uint256 _tokenId) public {
705     address newOwner = msg.sender;
706     address oldOwner = personIndexToOwnerGen1[_tokenId];
707 
708     // Safety check to prevent against an unexpected 0x0 default.
709     require(_addressNotNull(newOwner));
710 
711     // Making sure transfer is approved
712     require(_approvedGen1(newOwner, _tokenId));
713 
714     _transfer(oldOwner, newOwner, _tokenId);
715   }
716   
717   //@Artyom only gen1
718   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
719     uint256 tokenCount = balanceOf(_owner);
720     if (tokenCount == 0) {
721         // Return an empty array
722       return new uint256[](0);
723     } 
724     else {
725       uint256[] memory result = new uint256[](tokenCount);
726       uint256 totalPersons = totalSupply();
727       uint256 resultIndex = 0;
728 
729       uint256 personId;
730       for (personId = 0; personId <= totalPersons; personId++) {
731         if (personIndexToOwnerGen1[personId] == _owner) {
732           result[resultIndex] = personId;
733           resultIndex++;
734         }
735       }
736       return result;
737     }
738   }
739   
740    // @Artyom Required for ERC-721 compliance.
741    //@Artyom only gen1
742    function totalSupply() public view returns (uint256 total) {
743     return PersonsGen1.length;
744   }
745 
746    // @Artyom Required for ERC-721 compliance.
747    //@Artyom only gen1
748   function transfer( address _to, uint256 _tokenId) public {
749     require(_owns(msg.sender, _tokenId, true));
750     require(_addressNotNull(_to));
751 
752     _transfer(msg.sender, _to, _tokenId);
753   }
754   
755    // @Artyom Required for ERC-721 compliance.
756    //@Artyom only gen1
757     function transferFrom(address _from, address _to, uint256 _tokenId) public {
758     require(_owns(_from, _tokenId, true));
759     require(_approvedGen1(_to, _tokenId));
760     require(_addressNotNull(_to));
761 
762     _transfer(_from, _to, _tokenId);
763   }
764   
765    function _addressNotNull(address _to) private pure returns (bool) {
766     return _to != address(0);
767   }
768 
769   /// For checking approval of transfer for address _to
770   function _approvedGen1(address _to, uint256 _tokenId) private view returns (bool) {
771     return personIndexToApprovedGen1[_tokenId] == _to;
772   }
773   //@Artyom only gen0
774    function createPersonGen0(string _name, string _surname,uint64 _genes, bool _gender) external onlyCEO returns(uint256) {
775     return _birthPerson(_name, _surname ,_genes, _gender, false);
776   }
777   function SetGene(uint256 tokenId,bool generation, uint64 newgene) public {
778      require(_owns(msg.sender, tokenId, generation) || msg.sender==CeoAddress);
779      require(newgene<=9999999999 && newgene>=10);
780      Person person; //@Artyom reference
781     if (generation==false) { 
782         person = PersonsGen0[tokenId];
783     }
784     else {
785         person = PersonsGen1[tokenId];
786     }
787     require(person.genes<=90);
788      
789     uint64 _gene=newgene;
790     uint64 _pointCount=0;
791    
792    
793       for(uint i=0;i<10;i++) {
794            _pointCount+=_gene%10;
795            _gene=_gene/10;
796       }
797     //  log(_pointCount,person.genes);
798     require(_pointCount==person.genes);
799            
800     person.genes=newgene;
801     GenesInitialisedEvent(msg.sender,tokenId,generation,newgene);
802 }
803  
804    function breed(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool  _withpersongeneration, string _boyname, string _girlname) public payable { //@Artyom mother
805        require(_owns(msg.sender, _mypersonid, _mypersongeneration));
806        require(CreationLimitGen1>totalSupply()+1);
807     
808     //Mother
809     Person person; //@Artyom reference
810     if(_mypersongeneration==false) { 
811         person = PersonsGen0[_mypersonid];
812     }
813     else {
814         person = PersonsGen1[_mypersonid];
815         require(person.gender==false); //@Artyom checking gender for gen1 to be mother in this case
816     }
817 
818     require(person.genes>90);//@Artyom if its unlocked
819     
820     uint64 genes1=person.genes;
821     //Father
822         if(_withpersongeneration==false) { 
823         person = PersonsGen0[_withpersonid];
824     }
825     else {
826         person = PersonsGen1[_withpersonid];
827        
828     }
829      
830    
831      require(readyTobreed(_mypersonid, _mypersongeneration, _withpersonid,  _withpersongeneration));
832      require(breedingFee<=msg.value);
833    
834     
835     delete person.readyToBreedWithId;
836     person.readyToBreedWithGen=false;
837     
838    // uint64 genes2=person.genes;
839     
840        uint64 _generatedGen;
841        bool _gender; 
842        (_generatedGen,_gender)=_generateGene(genes1,person.genes,_mypersonid,_withpersonid); 
843        
844      if(_gender) {
845        _girlname=_boyname; //@Artyom if gender is true/1 then it should take the boyname
846      }
847        uint newid=_birthPerson(_girlname, person.surname, _generatedGen, _gender, true);
848             PersonsGen1[newid].fatherGeneration=_withpersongeneration; // @ Artyom, did here because stack too deep for function
849             PersonsGen1[newid].motherGeneration=_mypersongeneration;
850             PersonsGen1[newid].fatherId=uint32(_withpersonid); 
851             PersonsGen1[newid].motherId=uint32(_mypersonid);
852         
853         
854        _payout();
855   }
856   
857     function breedOnAuction(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool  _withpersongeneration, string _boyname, string _girlname) public payable { //@Artyom mother
858        require(_owns(msg.sender, _mypersonid, _mypersongeneration));
859        require(CreationLimitGen1>totalSupply()+1);
860        require(!(_mypersonid==_withpersonid && _mypersongeneration==_withpersongeneration));// @Artyom not to breed with self
861        require(!((_mypersonid==0 && _mypersongeneration==false) || (_withpersonid==0 && _withpersongeneration==false))); //Not to touch Satoshi
862     //Mother
863     Person person; //@Artyom reference
864     if(_mypersongeneration==false) { 
865         person = PersonsGen0[_mypersonid];
866     }
867     else {
868         person = PersonsGen1[_mypersonid];
869         require(person.gender==false); //@Artyom checking gender for gen1 to be mother in this case
870     }
871     
872     require(person.genes>90);//@Artyom if its unlocked
873     
874     address owneroffather;
875     uint256 _siringprice;
876     uint64 genes1=person.genes;
877     //Father
878         if(_withpersongeneration==false) { 
879         person = PersonsGen0[_withpersonid];
880         _siringprice=personIndexToSiringPrice0[_withpersonid];
881         owneroffather=CelGen0.ownerOf(_withpersonid);
882     }
883     else {
884         person = PersonsGen1[_withpersonid];
885         _siringprice=personIndexToSiringPrice1[_withpersonid];
886         owneroffather= personIndexToOwnerGen1[_withpersonid];
887     }
888      
889    require(_siringprice>0 && _siringprice<MaxValue);
890    require((breedingFee+_siringprice)<=msg.value);
891     
892     
893 //    uint64 genes2=;
894     
895        uint64 _generatedGen;
896        bool _gender; 
897        (_generatedGen,_gender)=_generateGene(genes1,person.genes,_mypersonid,_withpersonid); 
898        
899      if(_gender) {
900        _girlname=_boyname; //@Artyom if gender is true/1 then it should take the boyname
901      }
902        uint newid=_birthPerson(_girlname, person.surname, _generatedGen, _gender, true);
903             PersonsGen1[newid].fatherGeneration=_withpersongeneration; // @ Artyom, did here because stack too deep for function
904             PersonsGen1[newid].motherGeneration=_mypersongeneration;
905             PersonsGen1[newid].fatherId=uint32(_withpersonid); 
906             PersonsGen1[newid].motherId=uint32(_mypersonid);
907         
908         
909         owneroffather.transfer(_siringprice);
910        _payout();
911   }
912  
913   
914   
915   function prepareToBreed(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool _withpersongeneration, uint256 _siringprice) external { //@Artyom father
916       require(_owns(msg.sender, _mypersonid, _mypersongeneration)); 
917       
918        Person person; //@Artyom reference
919     if(_mypersongeneration==false) {
920         person = PersonsGen0[_mypersonid];
921         personIndexToSiringPrice0[_mypersonid]=_siringprice;
922     }
923     else {
924         person = PersonsGen1[_mypersonid];
925         
926         require(person.gender==true);//@Artyom for gen1 checking genders to be male
927         personIndexToSiringPrice1[_mypersonid]=_siringprice;
928     }
929       require(person.genes>90);//@Artyom if its unlocked
930 
931        person.readyToBreedWithId=uint32(_withpersonid); 
932        person.readyToBreedWithGen=_withpersongeneration;
933        SiringPriceEvent(msg.sender,_mypersonid,_mypersongeneration,_siringprice);
934       
935   }
936   
937   function readyTobreed(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool _withpersongeneration) public view returns(bool) {
938 
939 if (_mypersonid==_withpersonid && _mypersongeneration==_withpersongeneration) //Not to fuck Themselves 
940 return false;
941 
942 if((_mypersonid==0 && _mypersongeneration==false) || (_withpersonid==0 && _withpersongeneration==false)) //Not to touch Satoshi
943 return false;
944 
945     Person withperson; //@Artyom reference
946     if(_withpersongeneration==false) {
947         withperson = PersonsGen0[_withpersonid];
948     }
949     else {
950         withperson = PersonsGen1[_withpersonid];
951     }
952    
953    
954    if(withperson.readyToBreedWithGen==_mypersongeneration) {
955        if(withperson.readyToBreedWithId==_mypersonid) {
956        return true;
957    }
958    }
959   
960     
961     return false;
962     
963   }
964   function _birthPerson(string _name, string _surname, uint64 _genes, bool _gender, bool _generation) private returns(uint256) { // about this steps   
965     Person memory _person = Person({
966         name: _name,
967         surname: _surname,
968         genes: _genes,
969         birthTime: uint64(now),
970         fatherId: 0,
971         motherId: 0,
972         readyToBreedWithId: 0,
973         trainedcount: 0,
974         beatencount: 0,
975         readyToBreedWithGen: false,
976         gender: _gender,
977         fatherGeneration: false,
978         motherGeneration: false
979 
980         
981     });
982     
983     uint256 newPersonId;
984     if(_generation==false) {
985          newPersonId = PersonsGen0.push(_person) - 1;
986     }
987     else {
988          newPersonId = PersonsGen1.push(_person) - 1;
989          personIndexToPriceGen1[newPersonId] = MaxValue; //@Artyom indicating not for sale
990           // per ERC721 draft-This will assign ownership, and also emit the Transfer event as
991         _transfer(address(0), msg.sender, newPersonId);
992         
993 
994     }
995 
996     Birth(newPersonId, _name, msg.sender);
997     return newPersonId;
998   }
999   function _generateGene(uint64 _genes1,uint64 _genes2,uint256 _mypersonid,uint256 _withpersonid) private returns(uint64,bool) {
1000        uint64 _gene;
1001        uint64 _gene1;
1002        uint64 _gene2;
1003        uint64 _rand;
1004        uint256 _finalGene=0;
1005        bool gender=false;
1006 
1007        for(uint i=0;i<10;i++) {
1008            _gene1 =_genes1%10;
1009            _gene2=_genes2%10;
1010            _genes1=_genes1/10;
1011            _genes2=_genes2/10;
1012            _rand=uint64(keccak256(block.blockhash(block.number), i, now,_mypersonid,_withpersonid))%10000;
1013            
1014            if(_gene1>=_gene2) {
1015                _gene=_gene1-_gene2;
1016            }
1017            else {
1018                _gene=_gene2-_gene1;
1019            }
1020            
1021            if(_rand<26) {
1022                _gene-=3;
1023            }
1024             else if(_rand<455) {
1025                 _gene-=2;
1026            }
1027             else if(_rand<3173) {
1028                 _gene-=1;
1029            }
1030             else if(_rand<6827) {
1031                 
1032            }
1033             else if(_rand<9545) {
1034                 _gene+=1;
1035            }
1036             else if(_rand<9974) {
1037                 _gene+=2;
1038            }
1039             else if(_rand<1000) {
1040                 _gene+=3;
1041            }
1042            
1043            if(_gene>12) //@Artyom to avoid negative overflow
1044            _gene=0;
1045            if(_gene>9)
1046            _gene=9;
1047            
1048            _finalGene+=(uint(10)**i)*_gene;
1049        }
1050       
1051       if(uint64(keccak256(block.blockhash(block.number), 11, now,_mypersonid,_withpersonid))%2>0)
1052       gender=true;
1053       
1054       return(uint64(_finalGene),gender);  
1055   } 
1056   function _owns(address claimant, uint256 _tokenId,bool _tokengeneration) private view returns (bool) {
1057    if(_tokengeneration) {
1058         return ((claimant == personIndexToOwnerGen1[_tokenId]) || (claimant==ExternalAllowdContractGen1[_tokenId]));
1059    }
1060    else {
1061        return ((claimant == CelGen0.personIndexToOwner(_tokenId)) || (claimant==ExternalAllowdContractGen0[_tokenId]));
1062    }
1063   }
1064       
1065   function _payout() private {
1066     DevAddress.transfer((this.balance/10)*3);
1067     CeoAddress.transfer((this.balance/10)*7); 
1068   }
1069   
1070    // @Artyom Required for ERC-721 compliance.
1071    //@Artyom only gen1
1072    function _transfer(address _from, address _to, uint256 _tokenId) private {
1073     // Since the number of persons is capped to 2^32 we can't overflow this
1074     ownershipTokenCountGen1[_to]++;
1075     //transfer ownership
1076     personIndexToOwnerGen1[_tokenId] = _to;
1077 
1078     // When creating new persons _from is 0x0, but we can't account that address.
1079     if (_addressNotNull(_from)) {
1080       ownershipTokenCountGen1[_from]--;
1081       // clear any previously approved ownership exchange
1082      blankbreedingdata(_tokenId,true);
1083     }
1084 
1085     // Emit the transfer event.
1086     Transfer(_from, _to, _tokenId);
1087   }
1088   function blankbreedingdata(uint256 _personid, bool _persongeneration) private{
1089       Person person;
1090       if(_persongeneration==false) { 
1091         person = PersonsGen0[_personid];
1092         delete ExternalAllowdContractGen0[_personid];
1093         delete personIndexToSiringPrice0[_personid];
1094     }
1095     else {
1096         person = PersonsGen1[_personid];
1097         delete ExternalAllowdContractGen1[_personid];
1098         delete personIndexToSiringPrice1[_personid];
1099     	delete personIndexToApprovedGen1[_personid];
1100     }
1101      delete person.readyToBreedWithId;
1102      delete person.readyToBreedWithGen; 
1103   }
1104     function train(uint256 personid, bool persongeneration, uint8 gene) external payable onlyPlayers {
1105         
1106         require(gene>=0 && gene<10);
1107         uint256 trainingPrice=checkTrainingPrice(personid,persongeneration);
1108         require(msg.value >= trainingPrice);
1109          Person person; 
1110     if(persongeneration==false) {
1111         person = PersonsGen0[personid];
1112     }
1113     else {
1114         person = PersonsGen1[personid];
1115     }
1116     
1117      require(person.genes>90);//@Artyom if its unlocked
1118      uint gensolo=person.genes/(uint(10)**gene);
1119     gensolo=gensolo%10;
1120     require(gensolo<9); //@Artyom not to train after 9
1121     
1122           person.genes+=uint64(10)**gene;
1123           person.trainedcount++;
1124 
1125     uint256 purchaseExcess = SafeMath.sub(msg.value, trainingPrice);
1126     msg.sender.transfer(purchaseExcess);
1127     _payout();
1128     Trained(msg.sender, personid, persongeneration);
1129     }
1130     
1131      function beat(uint256 personid, bool persongeneration, uint8 gene) external payable onlyPlayers {
1132         require(gene>=0 && gene<10);
1133         uint256 beatingPrice=checkBeatingPrice(personid,persongeneration);
1134         require(msg.value >= beatingPrice);
1135          Person person; 
1136     if(persongeneration==false) {
1137         person = PersonsGen0[personid];
1138     }
1139     else {
1140         person = PersonsGen1[personid];
1141     }
1142     
1143     require(person.genes>90);//@Artyom if its unlocked
1144     uint gensolo=person.genes/(uint(10)**gene);
1145     gensolo=gensolo%10;
1146     require(gensolo>0);
1147           person.genes-=uint64(10)**gene;
1148           person.beatencount++;
1149 
1150     uint256 purchaseExcess = SafeMath.sub(msg.value, beatingPrice);
1151     msg.sender.transfer(purchaseExcess);
1152     _payout();
1153     Beaten(msg.sender, personid, persongeneration);    
1154     }
1155     
1156     
1157     function checkTrainingPrice(uint256 personid, bool persongeneration) view returns (uint256) {
1158          Person person;
1159     if(persongeneration==false) {
1160         person = PersonsGen0[personid];
1161     }
1162     else {
1163         person = PersonsGen1[personid];
1164     }
1165     
1166     uint256 _trainingprice= (uint(2)**person.trainedcount) * initialTraining;
1167     if (_trainingprice > 5 ether)
1168     _trainingprice=5 ether;
1169     
1170     return _trainingprice;
1171     }
1172     function checkBeatingPrice(uint256 personid, bool persongeneration) view returns (uint256) {
1173          Person person;
1174     if(persongeneration==false) {
1175         person = PersonsGen0[personid];
1176     }
1177     else {
1178         person = PersonsGen1[personid];
1179     }
1180     uint256 _beatingprice=(uint(2)**person.beatencount) * initialBeating;
1181      if (_beatingprice > 7 ether)
1182     _beatingprice=7 ether;
1183     return _beatingprice;
1184     } 
1185   
1186 }