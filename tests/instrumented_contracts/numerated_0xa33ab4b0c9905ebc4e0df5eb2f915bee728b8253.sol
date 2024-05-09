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
470   CelebrityBreederToken private CelBetta=CelebrityBreederToken(0xdab64dc4a02225f76fccce35ab9ba53b3735c684); //@Artyom Pointing to betta 
471  
472   string public constant NAME = "CryptoCelebrityBreederCards"; 
473   string public constant SYMBOL = "CeleBreedCard"; 
474 
475   uint256 public breedingFee = 0.01 ether;
476   uint256 public initialTraining = 0.00001 ether;
477   uint256 public initialBeating = 0.00002 ether;
478   uint256 private constant CreationLimitGen0 = 5000;
479   uint256 private constant CreationLimitGen1 = 2500000;
480   uint256 public constant MaxValue =  100000000 ether;
481   
482   mapping (uint256 => address) public personIndexToOwnerGen1;
483   mapping (address => uint256) private ownershipTokenCountGen1;
484   mapping (uint256 => address) public personIndexToApprovedGen1;
485   mapping (uint256 => uint256) private personIndexToPriceGen1;
486   mapping (uint256 => address) public ExternalAllowdContractGen0;
487   mapping (uint256 => address) public ExternalAllowdContractGen1; 
488   mapping (uint256 => uint256) public personIndexToSiringPrice0;
489   mapping (uint256 => uint256) public personIndexToSiringPrice1;
490   address public CeoAddress; 
491   address public DevAddress;
492   
493    struct Person {
494     string name;
495     string surname; 
496     uint64 genes; 
497     uint64 birthTime;
498     uint32 fatherId;
499     uint32 motherId;
500     uint32 readyToBreedWithId;
501     uint32 trainedcount;
502     uint32 beatencount;
503     bool readyToBreedWithGen;
504     bool gender;
505     bool fatherGeneration;
506     bool motherGeneration;
507   }
508   
509   Person[] private PersonsGen0;
510   Person[] private PersonsGen1;
511   
512     modifier onlyCEO() {
513     require(msg.sender == CeoAddress);
514     _;
515   }
516 
517   modifier onlyDEV() {
518     require(msg.sender == DevAddress);
519     _;
520   }
521   
522    modifier onlyPlayers() {
523     require(ownershipTokenCountGen1[msg.sender]>0 || CelGen0.balanceOf(msg.sender)>0);
524     _;
525   }
526 
527   /// Access modifier for contract owner only functionality
528  /* modifier onlyTopLevel() {
529     require(
530       msg.sender == CeoAddress ||
531       msg.sender == DevAddress
532     );
533     _;
534   }
535   */
536   function masscreate(uint256 fromindex, uint256 toindex) external onlyCEO{ 
537       string memory name; string memory surname; uint64 genes;  bool gender;
538       for(uint256 i=fromindex;i<=toindex;i++)
539       {
540           ( name, surname, genes, , ,  , , ,  gender)=CelBetta.getPerson(i,false);
541          _birthPerson(name, surname ,genes, gender, false);
542       }
543   }
544   function CelebrityBreederToken() public { 
545       CeoAddress= msg.sender;
546       DevAddress= msg.sender;
547   }
548     function setBreedingFee(uint256 newfee) external onlyCEO{
549       breedingFee=newfee;
550   }
551   function allowexternalContract(address _to, uint256 _tokenId,bool _tokengeneration) public { 
552     // Caller must own token.
553     require(_owns(msg.sender, _tokenId, _tokengeneration));
554     
555     if(_tokengeneration) {
556         if(_addressNotNull(_to)) {
557             ExternalAllowdContractGen1[_tokenId]=_to;
558         }
559         else {
560              delete ExternalAllowdContractGen1[_tokenId];
561         }
562     }
563     else {
564        if(_addressNotNull(_to)) {
565             ExternalAllowdContractGen0[_tokenId]=_to;
566         }
567         else {
568              delete ExternalAllowdContractGen0[_tokenId];
569         }
570     }
571 
572   }
573   
574   
575   //@Artyom Required for ERC-721 compliance.
576   function approve(address _to, uint256 _tokenId) public { //@Artyom only gen1
577     // Caller must own token.
578     require(_owns(msg.sender, _tokenId, true));
579 
580     personIndexToApprovedGen1[_tokenId] = _to;
581 
582     Approval(msg.sender, _to, _tokenId);
583   }
584   // @Artyom Required for ERC-721 compliance.
585   //@Artyom only gen1
586    function balanceOf(address _owner) public view returns (uint256 balance) {
587     return ownershipTokenCountGen1[_owner];
588   }
589   
590     function getPerson(uint256 _tokenId,bool generation) public view returns ( string name, string surname, uint64 genes,uint64 birthTime, uint32 readyToBreedWithId, uint32 trainedcount,uint32 beatencount,bool readyToBreedWithGen, bool gender) {
591     Person person;
592     if(generation==false) {
593         person = PersonsGen0[_tokenId];
594     }
595     else {
596         person = PersonsGen1[_tokenId];
597     }
598          
599     name = person.name;
600     surname=person.surname;
601     genes=person.genes;
602     birthTime=person.birthTime;
603     readyToBreedWithId=person.readyToBreedWithId;
604     trainedcount=person.trainedcount;
605     beatencount=person.beatencount;
606     readyToBreedWithGen=person.readyToBreedWithGen;
607     gender=person.gender;
608 
609   }
610    function getPersonParents(uint256 _tokenId, bool generation) public view returns ( uint32 fatherId, uint32 motherId, bool fatherGeneration, bool motherGeneration) {
611     Person person;
612     if(generation==false) {
613         person = PersonsGen0[_tokenId];
614     }
615     else {
616         person = PersonsGen1[_tokenId];
617     }
618          
619     fatherId=person.fatherId;
620     motherId=person.motherId;
621     fatherGeneration=person.fatherGeneration;
622     motherGeneration=person.motherGeneration;
623   }
624   // @Artyom Required for ERC-721 compliance.
625    function implementsERC721() public pure returns (bool) { 
626     return true;
627   }
628 
629   // @Artyom Required for ERC-721 compliance.
630   function name() public pure returns (string) {
631     return NAME;
632   }
633 
634 // @Artyom Required for ERC-721 compliance.
635   function ownerOf(uint256 _tokenId) public view returns (address owner)
636   {
637     owner = personIndexToOwnerGen1[_tokenId];
638     require(_addressNotNull(owner));
639   }
640   
641   //@Artyom only gen1
642    function purchase(uint256 _tokenId) public payable {
643     address oldOwner = personIndexToOwnerGen1[_tokenId];
644     address newOwner = msg.sender;
645 
646     uint256 sellingPrice = personIndexToPriceGen1[_tokenId];
647     personIndexToPriceGen1[_tokenId]=MaxValue;
648 
649     // Making sure token owner is not sending to self
650     require(oldOwner != newOwner);
651 
652     // Safety check to prevent against an unexpected 0x0 default.
653     require(_addressNotNull(newOwner));
654 
655     // Making sure sent amount is greater than or equal to the sellingPrice
656     require(msg.value >= sellingPrice);
657 
658    // uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
659     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
660 
661     _transfer(oldOwner, newOwner, _tokenId);
662 
663     // Pay previous tokenOwner if owner is not contract
664     if (oldOwner != address(this)) {
665     //  oldOwner.transfer(payment); //(1-0.06) //old code for holding some percents
666     oldOwner.transfer(sellingPrice);
667     }
668     blankbreedingdata(_tokenId,true);
669 
670     TokenSold(_tokenId, sellingPrice, personIndexToPriceGen1[_tokenId], oldOwner, newOwner, PersonsGen1[_tokenId].name);
671 
672     msg.sender.transfer(purchaseExcess);
673   }
674   
675    //@Artyom only gen1
676    function priceOf(uint256 _tokenId) public view returns (uint256 price) {
677     return personIndexToPriceGen1[_tokenId];
678   }
679 
680  
681   function setCEO(address _newCEO) external onlyCEO {
682     require(_addressNotNull(_newCEO));
683 
684     CeoAddress = _newCEO;
685   }
686 
687  //@Artyom only gen1
688  function setprice(uint256 _tokenId, uint256 _price) public {
689     require(_owns(msg.sender, _tokenId, true));
690     if(_price<=0 || _price>=MaxValue) {
691         personIndexToPriceGen1[_tokenId]=MaxValue;
692     }
693     else {
694         personIndexToPriceGen1[_tokenId]=_price;
695     }
696     SellingPriceEvent(msg.sender,_tokenId,true,_price);
697  }
698  
699   function setDEV(address _newDEV) external onlyDEV {
700     require(_addressNotNull(_newDEV));
701 
702     DevAddress = _newDEV;
703   }
704   
705     // @Artyom Required for ERC-721 compliance.
706   function symbol() public pure returns (string) {
707     return SYMBOL;
708   }
709 
710 
711   // @Artyom Required for ERC-721 compliance.
712    //@Artyom only gen1
713   function takeOwnership(uint256 _tokenId) public {
714     address newOwner = msg.sender;
715     address oldOwner = personIndexToOwnerGen1[_tokenId];
716 
717     // Safety check to prevent against an unexpected 0x0 default.
718     require(_addressNotNull(newOwner));
719 
720     // Making sure transfer is approved
721     require(_approvedGen1(newOwner, _tokenId));
722 
723     _transfer(oldOwner, newOwner, _tokenId);
724   }
725   
726   //@Artyom only gen1
727   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
728     uint256 tokenCount = balanceOf(_owner);
729     if (tokenCount == 0) {
730         // Return an empty array
731       return new uint256[](0);
732     } 
733     else {
734       uint256[] memory result = new uint256[](tokenCount);
735       uint256 totalPersons = totalSupply();
736       uint256 resultIndex = 0;
737 
738       uint256 personId;
739       for (personId = 0; personId <= totalPersons; personId++) {
740         if (personIndexToOwnerGen1[personId] == _owner) {
741           result[resultIndex] = personId;
742           resultIndex++;
743         }
744       }
745       return result;
746     }
747   }
748   
749    // @Artyom Required for ERC-721 compliance.
750    //@Artyom only gen1
751    function totalSupply() public view returns (uint256 total) {
752     return PersonsGen1.length;
753   }
754 
755    // @Artyom Required for ERC-721 compliance.
756    //@Artyom only gen1
757   function transfer( address _to, uint256 _tokenId) public {
758     require(_owns(msg.sender, _tokenId, true));
759     require(_addressNotNull(_to));
760 
761     _transfer(msg.sender, _to, _tokenId);
762   }
763   
764    // @Artyom Required for ERC-721 compliance.
765    //@Artyom only gen1
766     function transferFrom(address _from, address _to, uint256 _tokenId) public {
767     require(_owns(_from, _tokenId, true));
768     require(_approvedGen1(_to, _tokenId));
769     require(_addressNotNull(_to));
770 
771     _transfer(_from, _to, _tokenId);
772   }
773   
774    function _addressNotNull(address _to) private pure returns (bool) {
775     return _to != address(0);
776   }
777 
778   /// For checking approval of transfer for address _to
779   function _approvedGen1(address _to, uint256 _tokenId) private view returns (bool) {
780     return personIndexToApprovedGen1[_tokenId] == _to;
781   }
782   //@Artyom only gen0
783    function createPersonGen0(string _name, string _surname,uint64 _genes, bool _gender) external onlyCEO returns(uint256) {
784     return _birthPerson(_name, _surname ,_genes, _gender, false);
785   }
786   function SetGene(uint256 tokenId,bool generation, uint64 newgene) public {
787      require(_owns(msg.sender, tokenId, generation) || msg.sender==CeoAddress);
788      require(newgene<=9999999999 && newgene>=10);
789      Person person; //@Artyom reference
790     if (generation==false) { 
791         person = PersonsGen0[tokenId];
792     }
793     else {
794         person = PersonsGen1[tokenId];
795     }
796     require(person.genes<=90);
797      
798     uint64 _gene=newgene;
799     uint64 _pointCount=0;
800    
801    
802       for(uint i=0;i<10;i++) {
803            _pointCount+=_gene%10;
804            _gene=_gene/10;
805       }
806     //  log(_pointCount,person.genes);
807     require(_pointCount==person.genes);
808            
809     person.genes=newgene;
810     GenesInitialisedEvent(msg.sender,tokenId,generation,newgene);
811 }
812  
813    function breed(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool  _withpersongeneration, string _boyname, string _girlname) public payable { //@Artyom mother
814        require(_owns(msg.sender, _mypersonid, _mypersongeneration));
815        require(CreationLimitGen1>totalSupply()+1);
816     
817     //Mother
818     Person person; //@Artyom reference
819     if(_mypersongeneration==false) { 
820         person = PersonsGen0[_mypersonid];
821     }
822     else {
823         person = PersonsGen1[_mypersonid];
824         require(person.gender==false); //@Artyom checking gender for gen1 to be mother in this case
825     }
826 
827     require(person.genes>90);//@Artyom if its unlocked
828     
829     uint64 genes1=person.genes;
830     //Father
831         if(_withpersongeneration==false) { 
832         person = PersonsGen0[_withpersonid];
833     }
834     else {
835         person = PersonsGen1[_withpersonid];
836        
837     }
838      
839    
840      require(readyTobreed(_mypersonid, _mypersongeneration, _withpersonid,  _withpersongeneration));
841      require(breedingFee<=msg.value);
842    
843     
844     delete person.readyToBreedWithId;
845     person.readyToBreedWithGen=false;
846     
847    // uint64 genes2=person.genes;
848     
849        uint64 _generatedGen;
850        bool _gender; 
851        (_generatedGen,_gender)=_generateGene(genes1,person.genes,_mypersonid,_withpersonid); 
852        
853      if(_gender) {
854        _girlname=_boyname; //@Artyom if gender is true/1 then it should take the boyname
855      }
856        uint newid=_birthPerson(_girlname, person.surname, _generatedGen, _gender, true);
857             PersonsGen1[newid].fatherGeneration=_withpersongeneration; // @ Artyom, did here because stack too deep for function
858             PersonsGen1[newid].motherGeneration=_mypersongeneration;
859             PersonsGen1[newid].fatherId=uint32(_withpersonid); 
860             PersonsGen1[newid].motherId=uint32(_mypersonid);
861         
862         
863        _payout();
864   }
865   
866     function breedOnAuction(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool  _withpersongeneration, string _boyname, string _girlname) public payable { //@Artyom mother
867        require(_owns(msg.sender, _mypersonid, _mypersongeneration));
868        require(CreationLimitGen1>totalSupply()+1);
869        require(!(_mypersonid==_withpersonid && _mypersongeneration==_withpersongeneration));// @Artyom not to breed with self
870        require(!((_mypersonid==0 && _mypersongeneration==false) || (_withpersonid==0 && _withpersongeneration==false))); //Not to touch Satoshi
871     //Mother
872     Person person; //@Artyom reference
873     if(_mypersongeneration==false) { 
874         person = PersonsGen0[_mypersonid];
875     }
876     else {
877         person = PersonsGen1[_mypersonid];
878         require(person.gender==false); //@Artyom checking gender for gen1 to be mother in this case
879     }
880     
881     require(person.genes>90);//@Artyom if its unlocked
882     
883     address owneroffather;
884     uint256 _siringprice;
885     uint64 genes1=person.genes;
886     //Father
887         if(_withpersongeneration==false) { 
888         person = PersonsGen0[_withpersonid];
889         _siringprice=personIndexToSiringPrice0[_withpersonid];
890         owneroffather=CelGen0.ownerOf(_withpersonid);
891     }
892     else {
893         person = PersonsGen1[_withpersonid];
894         _siringprice=personIndexToSiringPrice1[_withpersonid];
895         owneroffather= personIndexToOwnerGen1[_withpersonid];
896     }
897      
898    require(_siringprice>0 && _siringprice<MaxValue);
899    require((breedingFee+_siringprice)<=msg.value);
900     
901     
902 //    uint64 genes2=;
903     
904        uint64 _generatedGen;
905        bool _gender; 
906        (_generatedGen,_gender)=_generateGene(genes1,person.genes,_mypersonid,_withpersonid); 
907        
908      if(_gender) {
909        _girlname=_boyname; //@Artyom if gender is true/1 then it should take the boyname
910      }
911        uint newid=_birthPerson(_girlname, person.surname, _generatedGen, _gender, true);
912             PersonsGen1[newid].fatherGeneration=_withpersongeneration; // @ Artyom, did here because stack too deep for function
913             PersonsGen1[newid].motherGeneration=_mypersongeneration;
914             PersonsGen1[newid].fatherId=uint32(_withpersonid); 
915             PersonsGen1[newid].motherId=uint32(_mypersonid);
916         
917         
918         owneroffather.transfer(_siringprice);
919        _payout();
920   }
921  
922   
923   
924   function prepareToBreed(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool _withpersongeneration, uint256 _siringprice) external { //@Artyom father
925       require(_owns(msg.sender, _mypersonid, _mypersongeneration)); 
926       
927        Person person; //@Artyom reference
928     if(_mypersongeneration==false) {
929         person = PersonsGen0[_mypersonid];
930         personIndexToSiringPrice0[_mypersonid]=_siringprice;
931     }
932     else {
933         person = PersonsGen1[_mypersonid];
934         
935         require(person.gender==true);//@Artyom for gen1 checking genders to be male
936         personIndexToSiringPrice1[_mypersonid]=_siringprice;
937     }
938       require(person.genes>90);//@Artyom if its unlocked
939 
940        person.readyToBreedWithId=uint32(_withpersonid); 
941        person.readyToBreedWithGen=_withpersongeneration;
942        SiringPriceEvent(msg.sender,_mypersonid,_mypersongeneration,_siringprice);
943       
944   }
945   
946   function readyTobreed(uint256 _mypersonid, bool _mypersongeneration, uint256 _withpersonid, bool _withpersongeneration) public view returns(bool) {
947 
948 if (_mypersonid==_withpersonid && _mypersongeneration==_withpersongeneration) //Not to fuck Themselves 
949 return false;
950 
951 if((_mypersonid==0 && _mypersongeneration==false) || (_withpersonid==0 && _withpersongeneration==false)) //Not to touch Satoshi
952 return false;
953 
954     Person withperson; //@Artyom reference
955     if(_withpersongeneration==false) {
956         withperson = PersonsGen0[_withpersonid];
957     }
958     else {
959         withperson = PersonsGen1[_withpersonid];
960     }
961    
962    
963    if(withperson.readyToBreedWithGen==_mypersongeneration) {
964        if(withperson.readyToBreedWithId==_mypersonid) {
965        return true;
966    }
967    }
968   
969     
970     return false;
971     
972   }
973   function _birthPerson(string _name, string _surname, uint64 _genes, bool _gender, bool _generation) private returns(uint256) { // about this steps   
974     Person memory _person = Person({
975         name: _name,
976         surname: _surname,
977         genes: _genes,
978         birthTime: uint64(now),
979         fatherId: 0,
980         motherId: 0,
981         readyToBreedWithId: 0,
982         trainedcount: 0,
983         beatencount: 0,
984         readyToBreedWithGen: false,
985         gender: _gender,
986         fatherGeneration: false,
987         motherGeneration: false
988 
989         
990     });
991     
992     uint256 newPersonId;
993     if(_generation==false) {
994          newPersonId = PersonsGen0.push(_person) - 1;
995     }
996     else {
997          newPersonId = PersonsGen1.push(_person) - 1;
998          personIndexToPriceGen1[newPersonId] = MaxValue; //@Artyom indicating not for sale
999           // per ERC721 draft-This will assign ownership, and also emit the Transfer event as
1000         _transfer(address(0), msg.sender, newPersonId);
1001         
1002 
1003     }
1004 
1005     Birth(newPersonId, _name, msg.sender);
1006     return newPersonId;
1007   }
1008   function _generateGene(uint64 _genes1,uint64 _genes2,uint256 _mypersonid,uint256 _withpersonid) private returns(uint64,bool) {
1009        uint64 _gene;
1010        uint64 _gene1;
1011        uint64 _gene2;
1012        uint64 _rand;
1013        uint256 _finalGene=0;
1014        bool gender=false;
1015 
1016        for(uint i=0;i<10;i++) {
1017            _gene1 =_genes1%10;
1018            _gene2=_genes2%10;
1019            _genes1=_genes1/10;
1020            _genes2=_genes2/10;
1021            _rand=uint64(keccak256(block.blockhash(block.number), i, now,_mypersonid,_withpersonid))%10000;
1022            
1023           _gene=(_gene1+_gene2)/2;
1024            
1025            if(_rand<26) {
1026                _gene-=3;
1027            }
1028             else if(_rand<455) {
1029                 _gene-=2;
1030            }
1031             else if(_rand<3173) {
1032                 _gene-=1;
1033            }
1034             else if(_rand<6827) {
1035                 
1036            }
1037             else if(_rand<9545) {
1038                 _gene+=1;
1039            }
1040             else if(_rand<9974) {
1041                 _gene+=2;
1042            }
1043             else if(_rand<10000) {
1044                 _gene+=3;
1045            }
1046            
1047            if(_gene>12) //@Artyom to avoid negative overflow
1048            _gene=0;
1049            if(_gene>9)
1050            _gene=9;
1051            
1052            _finalGene+=(uint(10)**i)*_gene;
1053        }
1054       
1055       if(uint64(keccak256(block.blockhash(block.number), 11, now,_mypersonid,_withpersonid))%2>0)
1056       gender=true;
1057       
1058       return(uint64(_finalGene),gender);  
1059   } 
1060   function _owns(address claimant, uint256 _tokenId,bool _tokengeneration) private view returns (bool) {
1061    if(_tokengeneration) {
1062         return ((claimant == personIndexToOwnerGen1[_tokenId]) || (claimant==ExternalAllowdContractGen1[_tokenId]));
1063    }
1064    else {
1065        return ((claimant == CelGen0.personIndexToOwner(_tokenId)) || (claimant==ExternalAllowdContractGen0[_tokenId]));
1066    }
1067   }
1068       
1069   function _payout() private {
1070     DevAddress.transfer((this.balance/10)*3);
1071     CeoAddress.transfer((this.balance/10)*7); 
1072   }
1073   
1074    // @Artyom Required for ERC-721 compliance.
1075    //@Artyom only gen1
1076    function _transfer(address _from, address _to, uint256 _tokenId) private {
1077     // Since the number of persons is capped to 2^32 we can't overflow this
1078     ownershipTokenCountGen1[_to]++;
1079     //transfer ownership
1080     personIndexToOwnerGen1[_tokenId] = _to;
1081 
1082     // When creating new persons _from is 0x0, but we can't account that address.
1083     if (_addressNotNull(_from)) {
1084       ownershipTokenCountGen1[_from]--;
1085       // clear any previously approved ownership exchange
1086      blankbreedingdata(_tokenId,true);
1087     }
1088 
1089     // Emit the transfer event.
1090     Transfer(_from, _to, _tokenId);
1091   }
1092   function blankbreedingdata(uint256 _personid, bool _persongeneration) private{
1093       Person person;
1094       if(_persongeneration==false) { 
1095         person = PersonsGen0[_personid];
1096         delete ExternalAllowdContractGen0[_personid];
1097         delete personIndexToSiringPrice0[_personid];
1098     }
1099     else {
1100         person = PersonsGen1[_personid];
1101         delete ExternalAllowdContractGen1[_personid];
1102         delete personIndexToSiringPrice1[_personid];
1103     	delete personIndexToApprovedGen1[_personid];
1104     }
1105      delete person.readyToBreedWithId;
1106      delete person.readyToBreedWithGen; 
1107   }
1108     function train(uint256 personid, bool persongeneration, uint8 gene) external payable onlyPlayers {
1109         
1110         require(gene>=0 && gene<10);
1111         uint256 trainingPrice=checkTrainingPrice(personid,persongeneration);
1112         require(msg.value >= trainingPrice);
1113          Person person; 
1114     if(persongeneration==false) {
1115         person = PersonsGen0[personid];
1116     }
1117     else {
1118         person = PersonsGen1[personid];
1119     }
1120     
1121      require(person.genes>90);//@Artyom if its unlocked
1122      uint gensolo=person.genes/(uint(10)**gene);
1123     gensolo=gensolo%10;
1124     require(gensolo<9); //@Artyom not to train after 9
1125     
1126           person.genes+=uint64(10)**gene;
1127           person.trainedcount++;
1128 
1129     uint256 purchaseExcess = SafeMath.sub(msg.value, trainingPrice);
1130     msg.sender.transfer(purchaseExcess);
1131     _payout();
1132     Trained(msg.sender, personid, persongeneration);
1133     }
1134     
1135      function beat(uint256 personid, bool persongeneration, uint8 gene) external payable onlyPlayers {
1136         require(gene>=0 && gene<10);
1137         uint256 beatingPrice=checkBeatingPrice(personid,persongeneration);
1138         require(msg.value >= beatingPrice);
1139          Person person; 
1140     if(persongeneration==false) {
1141         person = PersonsGen0[personid];
1142     }
1143     else {
1144         person = PersonsGen1[personid];
1145     }
1146     
1147     require(person.genes>90);//@Artyom if its unlocked
1148     uint gensolo=person.genes/(uint(10)**gene);
1149     gensolo=gensolo%10;
1150     require(gensolo>0);
1151           person.genes-=uint64(10)**gene;
1152           person.beatencount++;
1153 
1154     uint256 purchaseExcess = SafeMath.sub(msg.value, beatingPrice);
1155     msg.sender.transfer(purchaseExcess);
1156     _payout();
1157     Beaten(msg.sender, personid, persongeneration);    
1158     }
1159     
1160     
1161     function checkTrainingPrice(uint256 personid, bool persongeneration) view returns (uint256) {
1162          Person person;
1163     if(persongeneration==false) {
1164         person = PersonsGen0[personid];
1165     }
1166     else {
1167         person = PersonsGen1[personid];
1168     }
1169     
1170     uint256 _trainingprice= (uint(2)**person.trainedcount) * initialTraining;
1171     if (_trainingprice > 5 ether)
1172     _trainingprice=5 ether;
1173     
1174     return _trainingprice;
1175     }
1176     function checkBeatingPrice(uint256 personid, bool persongeneration) view returns (uint256) {
1177          Person person;
1178     if(persongeneration==false) {
1179         person = PersonsGen0[personid];
1180     }
1181     else {
1182         person = PersonsGen1[personid];
1183     }
1184     uint256 _beatingprice=(uint(2)**person.beatencount) * initialBeating;
1185      if (_beatingprice > 7 ether)
1186     _beatingprice=7 ether;
1187     return _beatingprice;
1188     } 
1189   
1190 }