1 pragma solidity ^0.4.19; //
2 
3 // EtherVillains.co
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
27 contract EtherVillains is ERC721 {
28 
29   /*** EVENTS ***/
30 
31   /// @dev The Birth event is fired whenever a new villain comes into existence.
32   event Birth(uint256 tokenId, string name, address owner);
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
36 
37   /// @dev Transfer event as defined in current draft of ERC721.
38   ///  ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /*** CONSTANTS ***/
42 
43   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
44   string public constant NAME = "EtherVillains"; //
45   string public constant SYMBOL = "EVIL"; //
46 
47   uint256 public precision = 1000000000000; //0.000001 Eth
48 
49   uint256 private zapPrice =  0.001 ether;
50   uint256 private pinchPrice =  0.002 ether;
51   uint256 private guardPrice =  0.002 ether;
52 
53   uint256 private pinchPercentageReturn = 20; // how much a flip is worth when a villain is flipped.
54 
55   uint256 private defaultStartingPrice = 0.001 ether;
56   uint256 private firstStepLimit =  0.05 ether;
57   uint256 private secondStepLimit = 0.5 ether;
58 
59   /*** STORAGE ***/
60 
61   /// @dev A mapping from villain IDs to the address that owns them. All villians have
62   ///  some valid owner address.
63   mapping (uint256 => address) public villainIndexToOwner;
64 
65   // @dev A mapping from owner address to count of tokens that address owns.
66   //  Used internally inside balanceOf() to resolve ownership count.
67   mapping (address => uint256) private ownershipTokenCount;
68 
69   /// @dev A mapping from Villains to an address that has been approved to call
70   ///  transferFrom(). Each Villain can only have one approved address for transfer
71   ///  at any time. A zero value means no approval is outstanding.
72   mapping (uint256 => address) public villainIndexToApproved;
73 
74   // @dev A mapping from Villains to the price of the token.
75   mapping (uint256 => uint256) private villainIndexToPrice;
76 
77   // The addresses of the accounts (or contracts) that can execute actions within each roles.
78   address public ceoAddress;
79   address public cooAddress;
80 
81 
82   /*** DATATYPES ***/
83   struct Villain {
84     uint256 id; // needed for gnarly front end
85     string name;
86     uint256 class; // 0 = Zapper , 1 = Pincher , 2 = Guard
87     uint256 level; // 0 for Zapper, 1 - 5 for Pincher, Guard - representing the max active pinches or guards
88     uint256 numSkillActive; // the current number of active skill implementations (pinches or guards)
89     uint256 state; // 0 = normal , 1 = zapped , 2 = pinched , 3 = guarded
90     uint256 zappedExipryTime; // if this villain was disarmed, when does it expire
91     uint256 affectedByToken; // token that has affected this token (zapped, pinched, guarded)
92     uint256 buyPrice; // the price at which this villain was purchased
93   }
94 
95   Villain[] private villains;
96 
97   /*** ACCESS MODIFIERS ***/
98   /// @dev Access modifier for CEO-only functionality
99   modifier onlyCEO() {
100     require(msg.sender == ceoAddress);
101     _;
102   }
103 
104   /// @dev Access modifier for COO-only functionality
105   modifier onlyCOO() {
106     require(msg.sender == cooAddress);
107     _;
108   }
109 
110   /// Access modifier for contract owner only functionality
111   modifier onlyCLevel() {
112     require(
113       msg.sender == ceoAddress ||
114       msg.sender == cooAddress
115     );
116     _;
117   }
118 
119   /*** CONSTRUCTOR ***/
120   function EtherVillains() public {
121     ceoAddress = msg.sender;
122     cooAddress = msg.sender;
123   }
124 
125   /*** PUBLIC FUNCTIONS ***/
126   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
127   /// @param _to The address to be granted transfer approval. Pass address(0) to
128   ///  clear all approvals.
129   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
130   /// @dev Required for ERC-721 compliance.
131   function approve(
132     address _to,
133     uint256 _tokenId
134   ) public {
135     // Caller must own token.
136     require(_owns(msg.sender, _tokenId));
137 
138     villainIndexToApproved[_tokenId] = _to;
139 
140     Approval(msg.sender, _to, _tokenId);
141   }
142 
143   /// For querying balance of a particular account
144   /// @param _owner The address for balance query
145   /// @dev Required for ERC-721 compliance.
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return ownershipTokenCount[_owner];
148   }
149 
150   /// @dev Creates a new Villain with the given name.
151   function createVillain(string _name, uint256 _startPrice, uint256 _class, uint256 _level) public onlyCLevel {
152     _createVillain(_name, address(this), _startPrice,_class,_level);
153   }
154 
155   /// @notice Returns all the relevant information about a specific villain.
156   /// @param _tokenId The tokenId of the villain of interest.
157   function getVillain(uint256 _tokenId) public view returns (
158     uint256 id,
159     string villainName,
160     uint256 sellingPrice,
161     address owner,
162     uint256 class,
163     uint256 level,
164     uint256 numSkillActive,
165     uint256 state,
166     uint256 zappedExipryTime,
167     uint256 buyPrice,
168     uint256 nextPrice,
169     uint256 affectedByToken
170   ) {
171     id = _tokenId;
172     Villain storage villain = villains[_tokenId];
173     villainName = villain.name;
174     sellingPrice =villainIndexToPrice[_tokenId];
175     owner = villainIndexToOwner[_tokenId];
176     class = villain.class;
177     level = villain.level;
178     numSkillActive = villain.numSkillActive;
179     state = villain.state;
180     if (villain.state==1 && now>villain.zappedExipryTime){
181         state=0; // time expired so say they are armed
182     }
183     zappedExipryTime=villain.zappedExipryTime;
184     buyPrice=villain.buyPrice;
185     nextPrice=calculateNewPrice(_tokenId);
186     affectedByToken=villain.affectedByToken;
187   }
188 
189   /// zap a villain in preparation for a pinch
190   function zapVillain(uint256 _victim  , uint256 _zapper) public payable returns (bool){
191     address villanOwner = villainIndexToOwner[_victim];
192     require(msg.sender != villanOwner); // it doesn't make sense, but hey
193     require(villains[_zapper].class==0); // they must be a zapper class
194     require(msg.sender==villainIndexToOwner[_zapper]); // they must be a zapper owner
195 
196     uint256 operationPrice = zapPrice;
197     // if the target sale price <0.01 then operation is free
198     if (villainIndexToPrice[_victim]<0.01 ether){
199       operationPrice=0;
200     }
201 
202     // can be used to extend a zapped period
203     if (msg.value>=operationPrice && villains[_victim].state<2){
204         // zap villain
205         villains[_victim].state=1;
206         villains[_victim].zappedExipryTime = now + (villains[_zapper].level * 1 minutes);
207     }
208 
209   }
210 
211     /// pinch a villain
212   function pinchVillain(uint256 _victim, uint256 _pincher) public payable returns (bool){
213     address victimOwner = villainIndexToOwner[_victim];
214     require(msg.sender != victimOwner); // it doesn't make sense, but hey
215     require(msg.sender==villainIndexToOwner[_pincher]);
216     require(villains[_pincher].class==1); // they must be a pincher
217     require(villains[_pincher].numSkillActive<villains[_pincher].level);
218 
219     uint256 operationPrice = pinchPrice;
220     // if the target sale price <0.01 then operation is free
221     if (villainIndexToPrice[_victim]<0.01 ether){
222       operationPrice=0;
223     }
224 
225     // 0 = normal , 1 = zapped , 2 = pinched
226     // must be inside the zapped window
227     if (msg.value>=operationPrice && villains[_victim].state==1 && now< villains[_victim].zappedExipryTime){
228         // squeeze
229         villains[_victim].state=2; // squeezed
230         villains[_victim].affectedByToken=_pincher;
231         villains[_pincher].numSkillActive++;
232     }
233   }
234 
235   /// guard a villain
236   function guardVillain(uint256 _target, uint256 _guard) public payable returns (bool){
237     require(msg.sender==villainIndexToOwner[_guard]); // sender must own this token
238     require(villains[_guard].numSkillActive<villains[_guard].level);
239 
240     uint256 operationPrice = guardPrice;
241     // if the target sale price <0.01 then operation is free
242     if (villainIndexToPrice[_target]<0.01 ether){
243       operationPrice=0;
244     }
245 
246     // 0 = normal , 1 = zapped , 2 = pinched, 3 = guarded
247     if (msg.value>=operationPrice && villains[_target].state<2){
248         // guard this villain
249         villains[_target].state=3;
250         villains[_target].affectedByToken=_guard;
251         villains[_guard].numSkillActive++;
252     }
253   }
254 
255 
256   function implementsERC721() public pure returns (bool) {
257     return true;
258   }
259 
260   /// @dev Required for ERC-721 compliance.
261   function name() public pure returns (string) {
262     return NAME;
263   }
264 
265   /// For querying owner of token
266   /// @param _tokenId The tokenID for owner inquiry
267   /// @dev Required for ERC-721 compliance.
268   function ownerOf(uint256 _tokenId)
269     public
270     view
271     returns (address owner)
272   {
273     owner = villainIndexToOwner[_tokenId];
274     require(owner != address(0));
275   }
276 
277   function payout(address _to) public onlyCLevel {
278     _payout(_to);
279   }
280 
281 
282 
283 
284   // Allows someone to send ether and obtain the token
285   function purchase(uint256 _tokenId) public payable {
286     address oldOwner = villainIndexToOwner[_tokenId];
287     address newOwner = msg.sender;
288 
289     uint256 sellingPrice = villainIndexToPrice[_tokenId];
290 
291     // Making sure token owner is not sending to self
292     require(oldOwner != newOwner);
293 
294     // Safety check to prevent against an unexpected 0x0 default.
295     require(_addressNotNull(newOwner));
296 
297     // Making sure sent amount is greater than or equal to the sellingPrice
298     require(msg.value >= sellingPrice);
299 
300     uint256 payment = roundIt(uint256(SafeMath.div(SafeMath.mul(sellingPrice, 93), 100))); // taking 7% for the house before any pinches?
301     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
302 
303 
304     // HERE'S THE FLIPPING STRATEGY
305 
306     villainIndexToPrice[_tokenId]  = calculateNewPrice(_tokenId);
307 
308 
309      // we check to see if there is a pinch on this villain
310      // if there is, then transfer the pinch percentage to the owner of the pinch token
311      if (villains[_tokenId].state==2 && villains[_tokenId].affectedByToken!=0){
312          uint256 profit = sellingPrice - villains[_tokenId].buyPrice;
313          uint256 pinchPayment = roundIt(SafeMath.mul(SafeMath.div(profit,100),pinchPercentageReturn));
314 
315          // release on of this villans pinch capabilitiesl
316          address pincherTokenOwner = villainIndexToOwner[villains[_tokenId].affectedByToken];
317          pincherTokenOwner.transfer(pinchPayment);
318          payment = SafeMath.sub(payment,pinchPayment); // subtract the pinch fees
319      }
320 
321      // free the villan of any pinches or guards as part of this purpose
322      if (villains[villains[_tokenId].affectedByToken].numSkillActive>0){
323         villains[villains[_tokenId].affectedByToken].numSkillActive--; // reset the pincher or guard affected count
324      }
325 
326      villains[_tokenId].state=0;
327      villains[_tokenId].affectedByToken=0;
328      villains[_tokenId].buyPrice=sellingPrice;
329 
330     _transfer(oldOwner, newOwner, _tokenId);
331 
332     // Pay previous tokenOwner if owner is not contract
333     if (oldOwner != address(this)) {
334       oldOwner.transfer(payment); //(1-0.08)
335     }
336 
337     TokenSold(_tokenId, sellingPrice, villainIndexToPrice[_tokenId], oldOwner, newOwner, villains[_tokenId].name);
338 
339     msg.sender.transfer(purchaseExcess); // return any additional amount
340   }
341 
342   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
343     return villainIndexToPrice[_tokenId];
344   }
345 
346   function nextPrice(uint256 _tokenId) public view returns (uint256 nPrice) {
347     return calculateNewPrice(_tokenId);
348   }
349 
350 
351 //(note: hard coded value appreciation is 2X from a contract price of 0 ETH to 0.05 ETH, 1.2X from 0.05 to 0.5 and 1.15X from 0.5 ETH and up).
352 
353 
354  function calculateNewPrice(uint256 _tokenId) internal view returns (uint256 price){
355    uint256 sellingPrice = villainIndexToPrice[_tokenId];
356    uint256 newPrice;
357    // Update prices
358    if (sellingPrice < firstStepLimit) {
359      // first stage
360     newPrice = roundIt(SafeMath.mul(sellingPrice, 2));
361    } else if (sellingPrice < secondStepLimit) {
362      // second stage
363      newPrice = roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 120), 100));
364    } else {
365      // third stage
366      newPrice= roundIt(SafeMath.div(SafeMath.mul(sellingPrice, 115), 100));
367    }
368    return newPrice;
369 
370  }
371 
372   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
373   /// @param _newCEO The address of the new CEO
374   function setCEO(address _newCEO) public onlyCEO {
375     require(_newCEO != address(0));
376 
377     ceoAddress = _newCEO;
378   }
379 
380   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
381   /// @param _newCOO The address of the new COO
382   function setCOO(address _newCOO) public onlyCEO {
383     require(_newCOO != address(0));
384 
385     cooAddress = _newCOO;
386   }
387 
388   /// @dev Required for ERC-721 compliance.
389   function symbol() public pure returns (string) {
390     return SYMBOL;
391   }
392 
393   /// @notice Allow pre-approved user to take ownership of a token
394   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
395   /// @dev Required for ERC-721 compliance.
396   function takeOwnership(uint256 _tokenId) public {
397     address newOwner = msg.sender;
398     address oldOwner = villainIndexToOwner[_tokenId];
399 
400     // Safety check to prevent against an unexpected 0x0 default.
401     require(_addressNotNull(newOwner));
402 
403     // Making sure transfer is approved
404     require(_approved(newOwner, _tokenId));
405 
406     _transfer(oldOwner, newOwner, _tokenId);
407   }
408 
409   /// @param _owner The owner whose tokens we are interested in.
410   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
411     uint256 tokenCount = balanceOf(_owner);
412     if (tokenCount == 0) {
413         // Return an empty array
414       return new uint256[](0);
415     } else {
416       uint256[] memory result = new uint256[](tokenCount);
417       uint256 totalVillains = totalSupply();
418       uint256 resultIndex = 0;
419 
420       uint256 villainId;
421       for (villainId = 0; villainId <= totalVillains; villainId++) {
422         if (villainIndexToOwner[villainId] == _owner) {
423           result[resultIndex] = villainId;
424           resultIndex++;
425         }
426       }
427       return result;
428     }
429   }
430 
431   /// For querying totalSupply of token
432   /// @dev Required for ERC-721 compliance.
433   function totalSupply() public view returns (uint256 total) {
434     return villains.length;
435   }
436 
437   /// Owner initates the transfer of the token to another account
438   /// @param _to The address for the token to be transferred to.
439   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
440   /// @dev Required for ERC-721 compliance.
441   function transfer(
442     address _to,
443     uint256 _tokenId
444   ) public {
445     require(_owns(msg.sender, _tokenId));
446     require(_addressNotNull(_to));
447 
448     _transfer(msg.sender, _to, _tokenId);
449   }
450 
451   /// Third-party initiates transfer of token from address _from to address _to
452   /// @param _from The address for the token to be transferred from.
453   /// @param _to The address for the token to be transferred to.
454   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
455   /// @dev Required for ERC-721 compliance.
456   function transferFrom(
457     address _from,
458     address _to,
459     uint256 _tokenId
460   ) public {
461     require(_owns(_from, _tokenId));
462     require(_approved(_to, _tokenId));
463     require(_addressNotNull(_to));
464 
465     _transfer(_from, _to, _tokenId);
466   }
467 
468   /*** PRIVATE FUNCTIONS ***/
469   /// Safety check on _to address to prevent against an unexpected 0x0 default.
470   function _addressNotNull(address _to) private pure returns (bool) {
471     return _to != address(0);
472   }
473 
474   /// For checking approval of transfer for address _to
475   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
476     return villainIndexToApproved[_tokenId] == _to;
477   }
478 
479 
480 
481   /// For creating Villains
482   function _createVillain(string _name, address _owner, uint256 _price, uint256 _class, uint256 _level) private {
483 
484     Villain memory _villain = Villain({
485       name: _name,
486       class: _class,
487       level: _level,
488       numSkillActive: 0,
489       state: 0,
490       zappedExipryTime: 0,
491       affectedByToken: 0,
492       buyPrice: 0,
493       id: villains.length-1
494     });
495     uint256 newVillainId = villains.push(_villain) - 1;
496     villains[newVillainId].id=newVillainId;
497 
498     // It's probably never going to happen, 4 billion tokens are A LOT, but
499     // let's just be 100% sure we never let this happen.
500     require(newVillainId == uint256(uint32(newVillainId)));
501 
502     Birth(newVillainId, _name, _owner);
503 
504     villainIndexToPrice[newVillainId] = _price;
505 
506     // This will assign ownership, and also emit the Transfer event as
507     // per ERC721 draft
508     _transfer(address(0), _owner, newVillainId);
509   }
510 
511   /// Check for token ownership
512   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
513     return claimant == villainIndexToOwner[_tokenId];
514   }
515 
516   /// For paying out balance on contract
517   function _payout(address _to) private {
518     if (_to == address(0)) {
519       ceoAddress.transfer(this.balance);
520     } else {
521       _to.transfer(this.balance);
522     }
523   }
524 
525   /// @dev Assigns ownership of a specific Villain to an address.
526   function _transfer(address _from, address _to, uint256 _tokenId) private {
527     // Since the number of villains is capped to 2^32 we can't overflow this
528     ownershipTokenCount[_to]++;
529     //transfer ownership
530     villainIndexToOwner[_tokenId] = _to;
531 
532     // When creating new villains _from is 0x0, but we can't account that address.
533     if (_from != address(0)) {
534       ownershipTokenCount[_from]--;
535       // clear any previously approved ownership exchange
536       delete villainIndexToApproved[_tokenId];
537     }
538 
539     // Emit the transfer event.
540     Transfer(_from, _to, _tokenId);
541   }
542 
543     // utility to round to the game precision
544     function roundIt(uint256 amount) internal constant returns (uint256)
545     {
546         // round down to correct preicision
547         uint256 result = (amount/precision)*precision;
548         return result;
549     }
550 
551 }
552 
553 
554 
555 library SafeMath {
556 
557   /**
558   * @dev Multiplies two numbers, throws on overflow.
559   */
560   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
561     if (a == 0) {
562       return 0;
563     }
564     uint256 c = a * b;
565     assert(c / a == b);
566     return c;
567   }
568 
569   /**
570   * @dev Integer division of two numbers, truncating the quotient.
571   */
572   function div(uint256 a, uint256 b) internal pure returns (uint256) {
573     // assert(b > 0); // Solidity automatically throws when dividing by 0
574     uint256 c = a / b;
575     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
576     return c;
577   }
578 
579   /**
580   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
581   */
582   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
583     assert(b <= a);
584     return a - b;
585   }
586 
587   /**
588   * @dev Adds two numbers, throws on overflow.
589   */
590   function add(uint256 a, uint256 b) internal pure returns (uint256) {
591     uint256 c = a + b;
592     assert(c >= a);
593     return c;
594   }
595 }