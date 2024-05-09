1 pragma solidity ^0.4.19; //
2 
3 // MobSquads2.io
4 // The End of the Beginning
5 
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function totalSupply() public view returns (uint256 total);
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15   function transfer(address _to, uint256 _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 contract MobSquads2 is ERC721 {
28 
29   /*** EVENTS ***/
30 
31   /// @dev The Birth event is fired whenever a new mobster comes into existence.
32   event Birth(uint256 tokenId, string name, address owner);
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner);
36 
37   /// @dev Transfer event as defined in current draft of ERC721.
38   ///  ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /*** CONSTANTS ***/
42 
43   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
44   string public constant NAME = "MobSquads2"; //
45   string public constant SYMBOL = "MOBS2"; //
46 
47   uint256 public precision = 1000000000000; //0.000001 Eth
48 
49   uint256 public hitPrice =  0.010 ether;
50 
51   uint256 public setPriceFee = 0.02 ether; // must be a cost to set your own price.
52   uint256 public setPriceCoolingPeriod = 5 minutes; // you can't set price until 5 minutes after buying
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from mobster IDs to the address that owns them. All mobsters have
57   ///  some valid owner address.
58   mapping (uint256 => address) public mobsterIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from mobsters to an address that has been approved to call
65   ///  transferFrom(). Each mobster can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public mobsterIndexToApproved;
68 
69   // @dev A mapping from mobsters to the price of the token.
70   mapping (uint256 => uint256) private mobsterIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   // sale started
77   bool public saleStarted = false;
78 
79   /*** DATATYPES ***/
80   struct Mobster {
81     uint256 id; // needed for gnarly front end
82     string name;
83     uint256 boss; // which gang member of
84     uint256 state; // 0 = normal , 1 = dazed
85     uint256 dazedExipryTime; // if this mobster was disarmed, when does it expire
86     uint256 buyPrice; // the price at which this mobster was bought
87     uint256 startingPrice; // price through which no deflation can go
88     uint256 buyTime;
89     uint256 level;
90     string show;
91     bool hasWhacked;
92   }
93 
94   Mobster[] private mobsters;
95   uint256 public leadingGang;
96   uint256 public leadingHitCount;
97   uint256[] public gangHits;  // number of hits a gang has done
98   uint256[] public gangBadges;  // number of whacking badges a gang has
99   uint256 public currentHitTotal = 0; //
100   uint256 public lethalBonusAtHitsLead = 10; // whan a squad takes the lead by this much they win the bonus
101   uint256 public whackingPool;
102 
103 
104   // @dev A mapping from mobsters to the price of the token.
105   mapping (uint256 => uint256) private bossIndexToGang;
106 
107   mapping (address => uint256) public mobsterBalances;
108 
109 
110   /*** ACCESS MODIFIERS ***/
111   /// @dev Access modifier for CEO-only functionality
112   modifier onlyCEO() {
113     require(msg.sender == ceoAddress);
114     _;
115   }
116 
117   /// @dev Access modifier for COO-only functionality
118   modifier onlyCOO() {
119     require(msg.sender == cooAddress);
120     _;
121   }
122 
123   /// Access modifier for contract owner only functionality
124   modifier onlyCLevel() {
125     require(
126       msg.sender == ceoAddress ||
127       msg.sender == cooAddress
128     );
129     _;
130   }
131 
132   /*** CONSTRUCTOR ***/
133   function MobSquads2() public {
134     ceoAddress = msg.sender;
135     cooAddress = msg.sender;
136     leadingHitCount = 0;
137      gangHits.length++;
138      gangBadges.length++;
139   //  _createMobster("The Godfather",address(this),2000000000000000,0);
140   }
141 
142   /*** PUBLIC FUNCTIONS ***/
143   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
144   /// @param _to The address to be granted transfer approval. Pass address(0) to
145   ///  clear all approvals.
146   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
147   /// @dev Required for ERC-721 compliance.
148   function approve(
149     address _to,
150     uint256 _tokenId
151   ) public {
152     // Caller must own token.
153     require(_owns(msg.sender, _tokenId));
154 
155     mobsterIndexToApproved[_tokenId] = _to;
156 
157     Approval(msg.sender, _to, _tokenId);
158   }
159 
160   /// For querying balance of a particular account
161   /// @param _owner The address for balance query
162   /// @dev Required for ERC-721 compliance.
163   function balanceOf(address _owner) public view returns (uint256 balance) {
164     return ownershipTokenCount[_owner];
165   }
166 
167   /// @dev Creates a new mobster with the given name.
168   function createMobster(string _name, uint256 _startPrice, uint256 _boss, uint256 _level, string _show) public onlyCLevel {
169     _createMobster(_name, address(this), _startPrice,_boss, _level, _show);
170   }
171 
172   /// @dev Creates a new mobster with the given name.
173   function createMobsterWithOwner(string _name, address _owner, uint256 _startPrice, uint256 _boss, uint256 _level, string _show) public onlyCLevel {
174     address firstOwner = _owner;
175     if (_owner==0 || _owner== address(0)){
176       firstOwner =  address(this);
177     }
178     _createMobster(_name,firstOwner, _startPrice,_boss, _level, _show);
179   }
180 
181   /// @notice Returns all the relevant information about a specific mobster.
182   /// @param _tokenId The tokenId of the mobster of interest.
183   function getMobster(uint256 _tokenId) public view returns (
184     uint256 id,
185     string name,
186     uint256 boss,
187     uint256 sellingPrice,
188     address owner,
189     uint256 state,
190     uint256 dazedExipryTime,
191     uint256 nextPrice,
192     uint256 level,
193     bool canSetPrice,
194     string show,
195     bool hasWhacked
196   ) {
197     id = _tokenId;
198     Mobster storage mobster = mobsters[_tokenId];
199     name = mobster.name;
200     boss = mobster.boss;
201     sellingPrice =priceOf(_tokenId);
202     owner = mobsterIndexToOwner[_tokenId];
203     state = mobster.state;
204     if (mobster.state==1 && now>mobster.dazedExipryTime){
205         state=0; // time expired so say they are armed
206     }
207     dazedExipryTime=mobster.dazedExipryTime;
208     nextPrice=calculateNewPrice(_tokenId);
209     level=mobster.level;
210     canSetPrice=(mobster.buyTime + setPriceCoolingPeriod)<now;
211     show=mobster.show;
212     hasWhacked=mobster.hasWhacked;
213   }
214 
215 
216   function lethalBonusAtHitsLead (uint256 _count) public onlyCLevel {
217     lethalBonusAtHitsLead = _count;
218   }
219 
220   function startSale () public onlyCLevel {
221     saleStarted = true; // no going back
222   }
223 
224   function setHitPrice (uint256 _price) public onlyCLevel {
225     hitPrice = _price;
226   }
227 
228   /// hit a mobster
229   function hitMobster(uint256 _victim  , uint256 _hitter) public payable returns (bool){
230     address mobsterOwner = mobsterIndexToOwner[_victim];
231     require(msg.sender != mobsterOwner); // it doesn't make sense, but hey
232     require(msg.sender==mobsterIndexToOwner[_hitter]); // they must be a hitter owner
233     require(saleStarted==true);
234 
235     // Godfather cannot be hit, bosses cannot be hit
236     if (msg.value>=hitPrice && _victim!=0 && _hitter!=0 && mobsters[_victim].level>1){
237         // hit mobster
238         mobsters[_victim].state=1;
239         mobsters[_victim].dazedExipryTime = now + (2 * 1 minutes);
240 
241         if(mobsters[_victim].hasWhacked==true){
242           mobsters[_victim].hasWhacked=false; // injury removes your whacking badge, you have to whack again!
243           gangBadges[SafeMath.div(mobsters[_victim].boss,16)+1]++;
244         }
245 
246         uint256 gangNumber=SafeMath.div(mobsters[_hitter].boss,16)+1;
247 
248         gangHits[gangNumber]++; // increase the hit count for this gang
249         currentHitTotal++;
250         whackingPool+=hitPrice;
251 
252         if(mobsters[_hitter].hasWhacked==false){
253           mobsters[_hitter].hasWhacked=true;
254           gangBadges[gangNumber]++;
255         }
256 
257         if  (gangHits[gangNumber]>leadingHitCount){
258             leadingHitCount=gangHits[gangNumber];
259             leadingGang=gangNumber;
260         }
261 
262         // check to see if this lead is now insurmountable and the count >20
263         bool lethalBonusTime = false;
264         for (uint256 g = 0 ; g<gangHits.length;g++){
265           if (leadingHitCount-gangHits[g]>lethalBonusAtHitsLead)
266             {
267               lethalBonusTime=true;
268             }
269         }
270 
271       // Whacking Bonus
272      if (lethalBonusTime){
273        uint256 lethalBonus = SafeMath.mul(SafeMath.div(whackingPool,120),SafeMath.div(100,gangBadges[leadingGang]+1));
274 
275          // each of the 16 members of the gang with the most hits receives an equal share of the pool
276          // GF also receives his share
277          uint256 winningMobsterIndex  = (16*(leadingGang-1))+1; // include the boss
278 
279          for (uint256 x = 1;x<totalSupply();x++){
280              if (x>=winningMobsterIndex && x<16+winningMobsterIndex && mobsters[x].hasWhacked==true){
281                 mobsterBalances[ mobsterIndexToOwner[x]]+=lethalBonus; // available for withdrawal
282              }
283              mobsters[x].hasWhacked=false; // reset this for all
284          }
285 
286          // Godfather always get's his share
287          if (mobsterIndexToOwner[0]!=address(this)){
288                mobsterBalances[mobsterIndexToOwner[0]]+=lethalBonus; // available for withdrawal
289          }
290 
291          currentHitTotal=0; // reset the counter
292          whackingPool=0; // reset this
293 
294          // need to reset the gangHits
295          for (uint256 y = 0 ; y<gangHits.length;y++){
296            gangHits[y]=0; // reset hit counters
297            gangBadges[y]=0; // remove all bagdes
298            leadingHitCount=0;
299            leadingGang=0;
300          }
301 
302      } // end if bonus time
303 
304 
305    } // end if this is a hit
306 
307 }
308 
309 
310   function implementsERC721() public pure returns (bool) {
311     return true;
312   }
313 
314   /// @dev Required for ERC-721 compliance.
315   function name() public pure returns (string) {
316     return NAME;
317   }
318 
319   /// For querying owner of token
320   /// @param _tokenId The tokenID for owner inquiry
321   /// @dev Required for ERC-721 compliance.
322   function ownerOf(uint256 _tokenId)
323     public
324     view
325     returns (address owner)
326   {
327     owner = mobsterIndexToOwner[_tokenId];
328     require(owner != address(0));
329   }
330 
331 
332   // Allows someone to send ether and obtain the token
333   function purchase(uint256 _tokenId) public payable {
334     address oldOwner = mobsterIndexToOwner[_tokenId];
335 
336     uint256 sellingPrice = priceOf(_tokenId);
337 
338     // no sales until we have started
339     require(saleStarted==true);
340 
341     // Making sure token owner is not sending to self
342     require(oldOwner != msg.sender);
343 
344     // Safety check to prevent against an unexpected 0x0 default.
345     require(_addressNotNull(msg.sender));
346 
347     // Making sure sent amount is greater than or equal to the sellingPrice
348     require(msg.value >= sellingPrice);
349 
350 
351 // Godfather when sold will raise by 17% (10% previous owner , 3.5% to contract, 3,5% to pool for mobsters)
352 // Bosses when sold will raise by 17% (10% previous owner , 3.5% to contract , 3.5% to Godfather owner)
353 // Mobsters when sold will raise by 22% (10% previous owner, 3.5% to Godfather, 3.5% to contract, 5% to their boss owner)
354 // Dealers when sold will raise by 40% (18% previous owner, 3.5% to Godfather, 3.5% to contract, 5% to their mobster , 3% to squad boss , 7% whacking pool)
355 
356     uint256 contractFee = roundIt(uint256(SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice,1000),35))); // 3.5%
357     uint256 previousOwnerPayout = 0;
358 
359      // godfather is flipped fee goes into whacking pool
360     if (_tokenId==0){
361       whackingPool+= contractFee;
362     }
363 
364 
365     // godfather and contract receive 3.5% of all sales
366     uint256 godFatherFee = 0;
367     if (_tokenId!=0){
368         godFatherFee = contractFee; // 3.5%
369     }
370 
371     uint256 superiorFee = 0;
372 
373     // mobster or dealer - so their superior get's 5%
374     if (mobsters[_tokenId].level==2 || mobsters[_tokenId].level==3){
375         superiorFee =  roundIt(uint256(SafeMath.div(mobsters[_tokenId].buyPrice,20))); // 5% goes to superior
376     }
377 
378     // dealer so 7% to whacking pool , 3% to bosses boss (mobster-->Boss) , 18% previous owner
379     if (mobsters[_tokenId].level==3){
380         whackingPool+= SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice, 100), 7); // 7% to whackingpool
381         previousOwnerPayout = roundIt(SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice, 100), 118)); // 118% to previous owner
382         uint256 bossFee = roundIt(SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice, 100), 3)); // 3% to squad boss
383         address bossAddress = mobsterIndexToOwner[mobsters[mobsters[_tokenId].boss].boss]; // bosses boss
384         if (bossAddress!=address(this)){
385             bossAddress.transfer(bossFee);
386         }
387   }else{
388         // otherwise 10% previous owner
389         previousOwnerPayout = roundIt(SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice, 100), 110)); // 110% to previous owner
390     }
391 
392     // pay the godfather if not owned by contract and not selling GF
393     if (mobsterIndexToOwner[0]!=address(this) && _tokenId!=0){
394         mobsterIndexToOwner[0].transfer(godFatherFee);
395     }
396 
397      // pay the superiorFee if not owned by the contract
398     if (_tokenId!=0 && superiorFee>0 && mobsterIndexToOwner[mobsters[_tokenId].boss]!=address(this)){
399         mobsterIndexToOwner[mobsters[_tokenId].boss].transfer(superiorFee);
400     }
401 
402 
403      mobsterIndexToPrice[_tokenId]  = calculateNewPrice(_tokenId);
404      mobsters[_tokenId].state=0;
405      mobsters[_tokenId].buyPrice=sellingPrice;
406      mobsters[_tokenId].buyTime = now;
407 
408     _transfer(oldOwner, msg.sender, _tokenId);
409 
410     // Pay previous tokenOwner if owner is not contract
411     if (oldOwner != address(this)) {
412       oldOwner.transfer(previousOwnerPayout); 
413     }
414 
415     TokenSold(_tokenId, sellingPrice, mobsterIndexToPrice[_tokenId], oldOwner, msg.sender);
416 
417     if(SafeMath.sub(msg.value, sellingPrice)>0){
418              msg.sender.transfer(SafeMath.sub(msg.value, sellingPrice)); // return any additional amount
419     }
420 
421   }
422 
423   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
424     return mobsterIndexToPrice[_tokenId];
425   }
426 
427 
428   function max(uint a, uint b) private pure returns (uint) {
429          return a > b ? a : b;
430   }
431 
432   function nextPrice(uint256 _tokenId) public view returns (uint256 nPrice) {
433     return calculateNewPrice(_tokenId);
434   }
435 
436   // allows an owner to set their own price and keep the fee structure
437   function setTokenPrice(uint256 _tokenId , uint256 _newSellPrice) public payable {
438     require(saleStarted==true);
439     require(msg.sender==mobsterIndexToOwner[_tokenId]); // they must own this mobbie and not already be deflating
440     require(msg.value>=setPriceFee); // they must own this mobbie and not already be deflating
441     require((mobsters[_tokenId].buyTime + setPriceCoolingPeriod)<now); // no setting this until some 5 minutes after
442 
443     // rules for setting own price.
444     // buy price becomes "would have been" buy price so contract rules abide
445     // GF or bosses have sell price ==117% of buy price
446     if (_tokenId==0 || mobsters[_tokenId].level==1){
447           mobsters[_tokenId].buyPrice = roundIt(SafeMath.mul(SafeMath.div(_newSellPrice, 117), 100));
448     }
449     // level 2
450     // mobsters have sell price ==122% of buy price
451    if (mobsters[_tokenId].level==2){
452      mobsters[_tokenId].buyPrice = roundIt(SafeMath.mul(SafeMath.div(_newSellPrice, 122), 100));
453     }
454     // level 3
455     // Dealrs have sell price ==140% of buy price
456    if (mobsters[_tokenId].level==3){
457      mobsters[_tokenId].buyPrice = roundIt(SafeMath.mul(SafeMath.div(_newSellPrice, 140), 100));
458     }
459 
460     mobsterIndexToPrice[_tokenId]=_newSellPrice;
461   }
462 
463 
464     function claimMobsterFunds() public {
465       if (mobsterBalances[msg.sender]==0) revert();
466       uint256 amount = mobsterBalances[msg.sender];
467       if (amount>0){
468         mobsterBalances[msg.sender] = 0;
469         msg.sender.transfer(amount);
470       }
471     }
472 
473 
474  function calculateNewPrice(uint256 _tokenId) internal view returns (uint256 price){
475    uint256 sellingPrice = priceOf(_tokenId);
476    uint256 newPrice;
477 
478    // level 0
479    // Godfather when sold will raise by 17%
480    if (_tokenId==0){
481          newPrice = roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 117), 100));
482    }
483    // level 1
484     //Bosses when sold will raise by 17%
485   if (mobsters[_tokenId].level==1 ){
486         newPrice = roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 117), 100));
487    }
488    // level 2
489    // Mobsters when sold will raise by 22%
490   if (mobsters[_tokenId].level==2){
491         newPrice= roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 122), 100));
492    }
493    // level 3
494    // Dealers will raise by 40%
495   if (mobsters[_tokenId].level==3){
496         newPrice= roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 140), 100));
497    }
498 
499    return newPrice;
500  }
501 
502   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
503   /// @param _newCEO The address of the new CEO
504   function setCEO(address _newCEO) public onlyCEO {
505     require(_newCEO != address(0));
506 
507     ceoAddress = _newCEO;
508   }
509 
510   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
511   /// @param _newCOO The address of the new COO
512   function setCOO(address _newCOO) public onlyCEO {
513     require(_newCOO != address(0));
514 
515     cooAddress = _newCOO;
516   }
517 
518   /// @dev Required for ERC-721 compliance.
519   function symbol() public pure returns (string) {
520     return SYMBOL;
521   }
522 
523   /// @notice Allow pre-approved user to take ownership of a token
524   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
525   /// @dev Required for ERC-721 compliance.
526   function takeOwnership(uint256 _tokenId) public {
527     address newOwner = msg.sender;
528     address oldOwner = mobsterIndexToOwner[_tokenId];
529 
530     // Safety check to prevent against an unexpected 0x0 default.
531     require(_addressNotNull(newOwner));
532 
533     // Making sure transfer is approved
534     require(_approved(newOwner, _tokenId));
535 
536     _transfer(oldOwner, newOwner, _tokenId);
537   }
538 
539   /// @param _owner The owner whose tokens we are interested in.
540   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
541     uint256 tokenCount = balanceOf(_owner);
542     if (tokenCount == 0) {
543         // Return an empty array
544       return new uint256[](0);
545     } else {
546       uint256[] memory result = new uint256[](tokenCount);
547       uint256 totalmobsters = totalSupply();
548       uint256 resultIndex = 0;
549 
550       uint256 mobsterId;
551       for (mobsterId = 0; mobsterId <= totalmobsters; mobsterId++) {
552         if (mobsterIndexToOwner[mobsterId] == _owner) {
553           result[resultIndex] = mobsterId;
554           resultIndex++;
555         }
556       }
557       return result;
558     }
559   }
560 
561   /// For querying totalSupply of token
562   /// @dev Required for ERC-721 compliance.
563   function totalSupply() public view returns (uint256 total) {
564     return mobsters.length;
565   }
566 
567   /// Owner initates the transfer of the token to another account
568   /// @param _to The address for the token to be transferred to.
569   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
570   /// @dev Required for ERC-721 compliance.
571   function transfer(
572     address _to,
573     uint256 _tokenId
574   ) public {
575     require(_owns(msg.sender, _tokenId));
576     require(_addressNotNull(_to));
577 
578     _transfer(msg.sender, _to, _tokenId);
579   }
580 
581   /// Third-party initiates transfer of token from address _from to address _to
582   /// @param _from The address for the token to be transferred from.
583   /// @param _to The address for the token to be transferred to.
584   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
585   /// @dev Required for ERC-721 compliance.
586   function transferFrom(
587     address _from,
588     address _to,
589     uint256 _tokenId
590   ) public {
591     require(_owns(_from, _tokenId));
592     require(_approved(_to, _tokenId));
593     require(_addressNotNull(_to));
594 
595     _transfer(_from, _to, _tokenId);
596   }
597 
598   /*** PRIVATE FUNCTIONS ***/
599   /// Safety check on _to address to prevent against an unexpected 0x0 default.
600   function _addressNotNull(address _to) private pure returns (bool) {
601     return _to != address(0);
602   }
603 
604   /// For checking approval of transfer for address _to
605   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
606     return mobsterIndexToApproved[_tokenId] == _to;
607   }
608 
609 
610   /// For creating mobsters
611   function _createMobster(string _name, address _owner, uint256 _price, uint256 _boss, uint256 _level, string _show) private {
612 
613     Mobster memory _mobster = Mobster({
614       name: _name,
615       boss: _boss,
616       state: 0,
617       dazedExipryTime: 0,
618       buyPrice: _price,
619       startingPrice: _price,
620       id: mobsters.length-1,
621       buyTime: now,
622       level: _level,
623       show: _show,
624       hasWhacked: false
625     });
626     uint256 newMobsterId = mobsters.push(_mobster) - 1;
627     mobsters[newMobsterId].id=newMobsterId;
628 
629     if (newMobsterId==0){
630        mobsters[0].hasWhacked=true; // Godfather always has his badge
631     }
632 
633     // creating new squads
634     if (newMobsterId % 16 ==0 || newMobsterId==1)
635     {
636         gangHits.length++;
637         gangBadges.length++;
638     }
639 
640 
641 
642     // It's probably never going to happen, 4 billion tokens are A LOT, but
643     // let's just be 100% sure we never let this happen.
644     require(newMobsterId == uint256(uint32(newMobsterId)));
645 
646     Birth(newMobsterId, _name, _owner);
647 
648     mobsterIndexToPrice[newMobsterId] = _price;
649 
650     // This will assign ownership, and also emit the Transfer event as
651     // per ERC721 draft
652     _transfer(address(0), _owner, newMobsterId);
653   }
654 
655   /// Check for token ownership
656   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
657     return claimant == mobsterIndexToOwner[_tokenId];
658   }
659 
660  /// withdraw , but leave whacking pool amount in - players need
661   function withdraw(uint256 amount) public onlyCLevel {
662         require(this.balance>whackingPool);
663         require(amount<=this.balance-whackingPool);
664         if (amount==0){
665             amount=this.balance-whackingPool;
666         }
667         ceoAddress.transfer(amount);
668     }
669 
670 
671   function canMakeUnrefusableOffer() public view returns (bool can){
672       return (now > mobsters[0].buyTime + 48 hours);
673   }
674 
675   /// Godfather can claim contract 48 hrs after card is purchased
676   function anOfferWeCantRefuse() public {
677      require(msg.sender==mobsterIndexToOwner[0]); // owner of Godfather
678      require(now > mobsters[0].buyTime + 48 hours); // 48 hours after purchase
679      ceoAddress = msg.sender; // now owner of contract
680      cooAddress = msg.sender; // entitled to withdraw any new contract fees
681   }
682 
683 
684   /// @dev Assigns ownership of a specific mobster to an address.
685   function _transfer(address _from, address _to, uint256 _tokenId) private {
686     // Since the number of mobsters is capped to 2^32 we can't overflow this
687     ownershipTokenCount[_to]++;
688     //transfer ownership
689     mobsterIndexToOwner[_tokenId] = _to;
690 
691     // When creating new mobsters _from is 0x0, but we can't account that address.
692     if (_from != address(0)) {
693       ownershipTokenCount[_from]--;
694       // clear any previously approved ownership exchange
695       delete mobsterIndexToApproved[_tokenId];
696     }
697 
698     // Emit the transfer event.
699     Transfer(_from, _to, _tokenId);
700   }
701 
702     // utility to round to the game precision
703     function roundIt(uint256 amount) internal constant returns (uint256)
704     {
705         // round down to correct preicision
706         uint256 result = (amount/precision)*precision;
707         return result;
708     }
709 
710 }
711 
712 
713 
714 library SafeMath {
715 
716   /**
717   * @dev Multiplies two numbers, throws on overflow.
718   */
719   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
720     if (a == 0) {
721       return 0;
722     }
723     uint256 c = a * b;
724     assert(c / a == b);
725     return c;
726   }
727 
728   /**
729   * @dev Integer division of two numbers, truncating the quotient.
730   */
731   function div(uint256 a, uint256 b) internal pure returns (uint256) {
732     // assert(b > 0); // Solidity automatically throws when dividing by 0
733     uint256 c = a / b;
734     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
735     return c;
736   }
737 
738   /**
739   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
740   */
741   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
742     assert(b <= a);
743     return a - b;
744   }
745 
746   /**
747   * @dev Adds two numbers, throws on overflow.
748   */
749   function add(uint256 a, uint256 b) internal pure returns (uint256) {
750     uint256 c = a + b;
751     assert(c >= a);
752     return c;
753   }
754 }