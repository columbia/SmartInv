1 pragma solidity ^0.4.19; //
2 
3 // MobSquads.io
4 
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
27 contract MobSquads is ERC721 {
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
44   string public constant NAME = "MobSquads"; //
45   string public constant SYMBOL = "MOBS"; //
46 
47   uint256 public precision = 1000000000000; //0.000001 Eth
48 
49   uint256 public hitPrice =  0.005 ether;
50 
51   /*** STORAGE ***/
52 
53   /// @dev A mapping from mobster IDs to the address that owns them. All villians have
54   ///  some valid owner address.
55   mapping (uint256 => address) public mobsterIndexToOwner;
56 
57   // @dev A mapping from owner address to count of tokens that address owns.
58   //  Used internally inside balanceOf() to resolve ownership count.
59   mapping (address => uint256) private ownershipTokenCount;
60 
61   /// @dev A mapping from mobsters to an address that has been approved to call
62   ///  transferFrom(). Each mobster can only have one approved address for transfer
63   ///  at any time. A zero value means no approval is outstanding.
64   mapping (uint256 => address) public mobsterIndexToApproved;
65 
66   // @dev A mapping from mobsters to the price of the token.
67   mapping (uint256 => uint256) private mobsterIndexToPrice;
68 
69   // The addresses of the accounts (or contracts) that can execute actions within each roles.
70   address public ceoAddress;
71   address public cooAddress;
72 
73   // minimum tokens before sales
74   uint256 public minimumTokensBeforeSale = 13;
75 
76   /*** DATATYPES ***/
77   struct Mobster {
78     uint256 id; // needed for gnarly front end
79     string name;
80     uint256 boss; // which gang member of
81     uint256 state; // 0 = normal , 1 = dazed
82     uint256 dazedExipryTime; // if this mobster was disarmed, when does it expire
83     uint256 buyPrice; // the price at which this mobster was bossd
84   }
85 
86   Mobster[] private mobsters;
87   uint256 public leadingGang;
88   uint256 public leadingHitCount;
89   uint256[] public gangHits;  // number of hits a gang has done
90   uint256 public currentHitTotal;
91   uint256 public lethalBonusAtHits = 200;
92 
93 
94   // @dev A mapping from mobsters to the price of the token.
95   mapping (uint256 => uint256) private bossIndexToGang;
96 
97   mapping (address => uint256) public mobsterBalances;
98 
99 
100   /*** ACCESS MODIFIERS ***/
101   /// @dev Access modifier for CEO-only functionality
102   modifier onlyCEO() {
103     require(msg.sender == ceoAddress);
104     _;
105   }
106 
107   /// @dev Access modifier for COO-only functionality
108   modifier onlyCOO() {
109     require(msg.sender == cooAddress);
110     _;
111   }
112 
113   /// Access modifier for contract owner only functionality
114   modifier onlyCLevel() {
115     require(
116       msg.sender == ceoAddress ||
117       msg.sender == cooAddress
118     );
119     _;
120   }
121 
122   /*** CONSTRUCTOR ***/
123   function MobSquads() public {
124     ceoAddress = msg.sender;
125     cooAddress = msg.sender;
126     leadingHitCount = 0;
127      gangHits.length++;
128   //  _createMobster("The Godfather",address(this),2000000000000000,0);
129   }
130 
131   /*** PUBLIC FUNCTIONS ***/
132   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
133   /// @param _to The address to be granted transfer approval. Pass address(0) to
134   ///  clear all approvals.
135   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
136   /// @dev Required for ERC-721 compliance.
137   function approve(
138     address _to,
139     uint256 _tokenId
140   ) public {
141     // Caller must own token.
142     require(_owns(msg.sender, _tokenId));
143 
144     mobsterIndexToApproved[_tokenId] = _to;
145 
146     Approval(msg.sender, _to, _tokenId);
147   }
148 
149   /// For querying balance of a particular account
150   /// @param _owner The address for balance query
151   /// @dev Required for ERC-721 compliance.
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return ownershipTokenCount[_owner];
154   }
155 
156   /// @dev Creates a new mobster with the given name.
157   function createMobster(string _name, uint256 _startPrice, uint256 _boss) public onlyCLevel {
158     _createMobster(_name, address(this), _startPrice,_boss);
159   }
160 
161   /// @notice Returns all the relevant information about a specific mobster.
162   /// @param _tokenId The tokenId of the mobster of interest.
163   function getMobster(uint256 _tokenId) public view returns (
164     uint256 id,
165     string name,
166     uint256 boss,
167     uint256 sellingPrice,
168     address owner,
169     uint256 state,
170     uint256 dazedExipryTime,
171     uint256 buyPrice,
172     uint256 nextPrice
173   ) {
174     id = _tokenId;
175     Mobster storage mobster = mobsters[_tokenId];
176     name = mobster.name;
177     boss = mobster.boss;
178     sellingPrice =mobsterIndexToPrice[_tokenId];
179     owner = mobsterIndexToOwner[_tokenId];
180     state = mobster.state;
181     if (mobster.state==1 && now>mobster.dazedExipryTime){
182         state=0; // time expired so say they are armed
183     }
184     dazedExipryTime=mobster.dazedExipryTime;
185     buyPrice=mobster.buyPrice;
186     nextPrice=calculateNewPrice(_tokenId);
187   }
188 
189 
190   function setLethalBonusAtHits (uint256 _count) public onlyCLevel {
191         lethalBonusAtHits = _count;
192     }
193 
194     function setHitPrice (uint256 _price) public onlyCLevel {
195           hitPrice = _price;
196       }
197 
198   /// hit a mobster
199   function hitMobster(uint256 _victim  , uint256 _hitter) public payable returns (bool){
200     address mobsterOwner = mobsterIndexToOwner[_victim];
201     require(msg.sender != mobsterOwner); // it doesn't make sense, but hey
202     require(msg.sender==mobsterIndexToOwner[_hitter]); // they must be a hitter owner
203 
204     // Godfather cannot be hit
205     if (msg.value>=hitPrice && _victim!=0 && _hitter!=0){
206         // zap mobster
207         mobsters[_victim].state=1;
208         mobsters[_victim].dazedExipryTime = now + (2 * 1 minutes);
209 
210         uint256 gangNumber=SafeMath.div(mobsters[_hitter].boss,6)+1;
211 
212         gangHits[gangNumber]++; // increase the hit count for this gang
213         currentHitTotal++;
214 
215         if  (gangHits[gangNumber]>leadingHitCount){
216             leadingHitCount=gangHits[gangNumber];
217             leadingGang=gangNumber;
218         }
219 
220       // Lethal Bonus Time
221      if (currentHitTotal==lethalBonusAtHits){
222        uint256 lethalBonus = SafeMath.mul(SafeMath.div(currentHitTotal * hitPrice,100),15); // 15% = 90% for mobsters/bosses
223 
224          // each of the 6 members of the gang with the most hits receives 10% of the Hit Pool
225          uint256 winningMobsterIndex  = (6*(leadingGang-1))+1; // include the boss
226          for (uint256 x = winningMobsterIndex;x<6+winningMobsterIndex;x++){
227              if(mobsterIndexToOwner[x]!=0 && mobsterIndexToOwner[x]!=address(this)){
228                          mobsterBalances[ mobsterIndexToOwner[x]]+=lethalBonus; // available for withdrawal
229               }
230          } // end for this gang
231 
232          currentHitTotal=0; // reset the counter
233 
234          // need to reset the gangHits
235          for (uint256 y = 0 ; y<gangHits.length;y++){
236            gangHits[y]=0;
237            leadingHitCount=0;
238            leadingGang=0;
239          }
240 
241      } // end if bonus time
242 
243 
244    } // end if this is a hit
245 
246 }
247 
248 
249   function implementsERC721() public pure returns (bool) {
250     return true;
251   }
252 
253   /// @dev Required for ERC-721 compliance.
254   function name() public pure returns (string) {
255     return NAME;
256   }
257 
258   /// For querying owner of token
259   /// @param _tokenId The tokenID for owner inquiry
260   /// @dev Required for ERC-721 compliance.
261   function ownerOf(uint256 _tokenId)
262     public
263     view
264     returns (address owner)
265   {
266     owner = mobsterIndexToOwner[_tokenId];
267     require(owner != address(0));
268   }
269 
270   function payout(address _to) public onlyCLevel {
271     _payout(_to);
272   }
273 
274 
275 
276   // Allows someone to send ether and obtain the token
277   function purchase(uint256 _tokenId) public payable {
278     address oldOwner = mobsterIndexToOwner[_tokenId];
279 
280     uint256 sellingPrice = mobsterIndexToPrice[_tokenId];
281     // no sales until we reach a minimum amount
282     require(totalSupply()>=minimumTokensBeforeSale);
283 
284     // Making sure token owner is not sending to self
285     require(oldOwner != msg.sender);
286 
287     // Safety check to prevent against an unexpected 0x0 default.
288     require(_addressNotNull(msg.sender));
289 
290     // Making sure sent amount is greater than or equal to the sellingPrice
291     require(msg.value >= sellingPrice);
292 
293 // Godfather when sold will raise by 17% (10% previous owner , 3.5% to contract, 3,5% to pool for mobsters)
294 // Bosses when sold will raise by 17% (10% previous owner , 3.5% to contract , 3.5% to Godfather owner)
295 // Mobsters when sold will raise by 22% (10% previous owner, 3.5% to Godfather, 3.5% to contract, 5% to their boss owner)
296     uint256 contractFee = roundIt(uint256(SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice,1000),35))); // 3.5%
297 
298      // godfather is flipped
299     if (_tokenId==0){
300         uint256 poolPayment = roundIt(uint256(SafeMath.div(contractFee,5))); // 20%
301         // each of the 5 members of the gang with the most hits receives 20% of the mobsterPool
302 
303         //leadingGang 0,1,2,3,4 = gangs
304         // leaders are  always 1,7,13,19,25 ,,,, so mobsters are (6*leadingGang)+2; -->
305         uint256 winningMobsterIndex  = (6*(leadingGang-1))+2; // boss not included in mobster payments
306         for (uint256 x = winningMobsterIndex;x<5+winningMobsterIndex;x++){
307             if(mobsterIndexToOwner[x]!=0 &&  mobsterIndexToOwner[x]!=address(this)){
308                         mobsterBalances[ mobsterIndexToOwner[x]]+=poolPayment; // available for withdrawal
309              }
310         }
311 
312         // need to reset the gangHits
313         for (uint256 y = 0 ; y<gangHits.length;y++){
314           gangHits[y]=0;
315           leadingHitCount=0;
316           leadingGang=0;
317         }
318 
319     }
320 
321 
322     // boss
323     uint256 godFatherFee = 0;
324     if (_tokenId!=0){
325         godFatherFee = contractFee; // 3.5%
326     }
327     // mobster
328     uint256 bossFee = 0;
329     if (mobsters[_tokenId].boss!=_tokenId && _tokenId!=0){
330         bossFee =  roundIt(uint256(SafeMath.div(mobsters[_tokenId].buyPrice,20))); // 5%
331     }
332     // pay the godfather if not owned by contract
333     if (godFatherFee>0 && mobsterIndexToOwner[0]!=address(this)){
334         mobsterIndexToOwner[0].transfer(godFatherFee);
335     }
336 
337      // pay the bossFee if not owned by the contract
338     if (_tokenId!=0 && bossFee>0 && mobsterIndexToOwner[mobsters[_tokenId].boss]!=address(this)){
339         mobsterIndexToOwner[mobsters[_tokenId].boss].transfer(bossFee);
340     }
341 
342      uint256 previousOwnerPayout = roundIt(SafeMath.mul(SafeMath.div(mobsters[_tokenId].buyPrice, 100), 110)); // 110% to previous owner
343 
344      mobsterIndexToPrice[_tokenId]  = calculateNewPrice(_tokenId);
345      mobsters[_tokenId].state=0;
346      mobsters[_tokenId].buyPrice=sellingPrice;
347 
348     _transfer(oldOwner, msg.sender, _tokenId);
349 
350     // Pay previous tokenOwner if owner is not contract
351     if (oldOwner != address(this)) {
352       oldOwner.transfer(previousOwnerPayout); // 110% to previous owner
353     }
354 
355     TokenSold(_tokenId, sellingPrice, mobsterIndexToPrice[_tokenId], oldOwner, msg.sender);
356 
357     if(SafeMath.sub(msg.value, sellingPrice)>0){
358              msg.sender.transfer(SafeMath.sub(msg.value, sellingPrice)); // return any additional amount
359     }
360 
361   }
362 
363   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
364     return mobsterIndexToPrice[_tokenId];
365   }
366 
367   function nextPrice(uint256 _tokenId) public view returns (uint256 nPrice) {
368     return calculateNewPrice(_tokenId);
369   }
370 
371 
372     function claimMobsterFunds() public {
373       if (mobsterBalances[msg.sender]==0) revert();
374       uint256 amount = mobsterBalances[msg.sender];
375       if (amount>0){
376         mobsterBalances[msg.sender] = 0;
377         msg.sender.transfer(amount);
378       }
379     }
380 
381 
382  function calculateNewPrice(uint256 _tokenId) internal view returns (uint256 price){
383    uint256 sellingPrice = mobsterIndexToPrice[_tokenId];
384    uint256 newPrice;
385 
386    // level 0
387    // Godfather when sold will raise by 17%
388    if (_tokenId==0){
389          newPrice = roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 117), 100));
390    }
391    // level 1
392     //Bosses when sold will raise by 17%
393   if (mobsters[_tokenId].boss==_tokenId && _tokenId!=0){
394         newPrice = roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 117), 100));
395    }
396    // level 2
397    // Mobsters when sold will raise by 22%
398   if (mobsters[_tokenId].boss!=_tokenId){
399         newPrice= roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 122), 100));
400    }
401    return newPrice;
402  }
403 
404   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
405   /// @param _newCEO The address of the new CEO
406   function setCEO(address _newCEO) public onlyCEO {
407     require(_newCEO != address(0));
408 
409     ceoAddress = _newCEO;
410   }
411 
412   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
413   /// @param _newCOO The address of the new COO
414   function setCOO(address _newCOO) public onlyCEO {
415     require(_newCOO != address(0));
416 
417     cooAddress = _newCOO;
418   }
419 
420   /// @dev Required for ERC-721 compliance.
421   function symbol() public pure returns (string) {
422     return SYMBOL;
423   }
424 
425   /// @notice Allow pre-approved user to take ownership of a token
426   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
427   /// @dev Required for ERC-721 compliance.
428   function takeOwnership(uint256 _tokenId) public {
429     address newOwner = msg.sender;
430     address oldOwner = mobsterIndexToOwner[_tokenId];
431 
432     // Safety check to prevent against an unexpected 0x0 default.
433     require(_addressNotNull(newOwner));
434 
435     // Making sure transfer is approved
436     require(_approved(newOwner, _tokenId));
437 
438     _transfer(oldOwner, newOwner, _tokenId);
439   }
440 
441   /// @param _owner The owner whose tokens we are interested in.
442   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
443     uint256 tokenCount = balanceOf(_owner);
444     if (tokenCount == 0) {
445         // Return an empty array
446       return new uint256[](0);
447     } else {
448       uint256[] memory result = new uint256[](tokenCount);
449       uint256 totalmobsters = totalSupply();
450       uint256 resultIndex = 0;
451 
452       uint256 mobsterId;
453       for (mobsterId = 0; mobsterId <= totalmobsters; mobsterId++) {
454         if (mobsterIndexToOwner[mobsterId] == _owner) {
455           result[resultIndex] = mobsterId;
456           resultIndex++;
457         }
458       }
459       return result;
460     }
461   }
462 
463   /// For querying totalSupply of token
464   /// @dev Required for ERC-721 compliance.
465   function totalSupply() public view returns (uint256 total) {
466     return mobsters.length;
467   }
468 
469   /// Owner initates the transfer of the token to another account
470   /// @param _to The address for the token to be transferred to.
471   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
472   /// @dev Required for ERC-721 compliance.
473   function transfer(
474     address _to,
475     uint256 _tokenId
476   ) public {
477     require(_owns(msg.sender, _tokenId));
478     require(_addressNotNull(_to));
479 
480     _transfer(msg.sender, _to, _tokenId);
481   }
482 
483   /// Third-party initiates transfer of token from address _from to address _to
484   /// @param _from The address for the token to be transferred from.
485   /// @param _to The address for the token to be transferred to.
486   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
487   /// @dev Required for ERC-721 compliance.
488   function transferFrom(
489     address _from,
490     address _to,
491     uint256 _tokenId
492   ) public {
493     require(_owns(_from, _tokenId));
494     require(_approved(_to, _tokenId));
495     require(_addressNotNull(_to));
496 
497     _transfer(_from, _to, _tokenId);
498   }
499 
500   /*** PRIVATE FUNCTIONS ***/
501   /// Safety check on _to address to prevent against an unexpected 0x0 default.
502   function _addressNotNull(address _to) private pure returns (bool) {
503     return _to != address(0);
504   }
505 
506   /// For checking approval of transfer for address _to
507   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
508     return mobsterIndexToApproved[_tokenId] == _to;
509   }
510 
511 
512   /// For creating mobsters
513   function _createMobster(string _name, address _owner, uint256 _price, uint256 _boss) private {
514 
515     Mobster memory _mobster = Mobster({
516       name: _name,
517       boss: _boss,
518       state: 0,
519       dazedExipryTime: 0,
520       buyPrice: _price,
521       id: mobsters.length-1
522     });
523     uint256 newMobsterId = mobsters.push(_mobster) - 1;
524     mobsters[newMobsterId].id=newMobsterId;
525 
526 
527     if (newMobsterId % 6 ==0 || newMobsterId==1)
528     {
529         gangHits.length++;
530     }
531 
532     // It's probably never going to happen, 4 billion tokens are A LOT, but
533     // let's just be 100% sure we never let this happen.
534     require(newMobsterId == uint256(uint32(newMobsterId)));
535 
536     Birth(newMobsterId, _name, _owner);
537 
538     mobsterIndexToPrice[newMobsterId] = _price;
539 
540     // This will assign ownership, and also emit the Transfer event as
541     // per ERC721 draft
542     _transfer(address(0), _owner, newMobsterId);
543   }
544 
545   /// Check for token ownership
546   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
547     return claimant == mobsterIndexToOwner[_tokenId];
548   }
549 
550   /// For paying out balance on contract
551   function _payout(address _to) private {
552     if (_to == address(0)) {
553       ceoAddress.transfer(this.balance);
554     } else {
555       _to.transfer(this.balance);
556     }
557   }
558 
559   /// @dev Assigns ownership of a specific mobster to an address.
560   function _transfer(address _from, address _to, uint256 _tokenId) private {
561     // Since the number of mobsters is capped to 2^32 we can't overflow this
562     ownershipTokenCount[_to]++;
563     //transfer ownership
564     mobsterIndexToOwner[_tokenId] = _to;
565 
566     // When creating new mobsters _from is 0x0, but we can't account that address.
567     if (_from != address(0)) {
568       ownershipTokenCount[_from]--;
569       // clear any previously approved ownership exchange
570       delete mobsterIndexToApproved[_tokenId];
571     }
572 
573     // Emit the transfer event.
574     Transfer(_from, _to, _tokenId);
575   }
576 
577     // utility to round to the game precision
578     function roundIt(uint256 amount) internal constant returns (uint256)
579     {
580         // round down to correct preicision
581         uint256 result = (amount/precision)*precision;
582         return result;
583     }
584 
585 }
586 
587 
588 
589 library SafeMath {
590 
591   /**
592   * @dev Multiplies two numbers, throws on overflow.
593   */
594   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595     if (a == 0) {
596       return 0;
597     }
598     uint256 c = a * b;
599     assert(c / a == b);
600     return c;
601   }
602 
603   /**
604   * @dev Integer division of two numbers, truncating the quotient.
605   */
606   function div(uint256 a, uint256 b) internal pure returns (uint256) {
607     // assert(b > 0); // Solidity automatically throws when dividing by 0
608     uint256 c = a / b;
609     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
610     return c;
611   }
612 
613   /**
614   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
615   */
616   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
617     assert(b <= a);
618     return a - b;
619   }
620 
621   /**
622   * @dev Adds two numbers, throws on overflow.
623   */
624   function add(uint256 a, uint256 b) internal pure returns (uint256) {
625     uint256 c = a + b;
626     assert(c >= a);
627     return c;
628   }
629 }