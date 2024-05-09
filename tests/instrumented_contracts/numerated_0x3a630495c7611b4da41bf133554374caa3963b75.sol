1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 contract ERC721 {
6   // Required methods
7   function approve(address _to, uint256 _tokenId) public;
8   function balanceOf(address _owner) public view returns (uint256 balance);
9   function implementsERC721() public pure returns (bool);
10   function ownerOf(uint256 _tokenId) public view returns (address addr);
11   function takeOwnership(uint256 _tokenId) public;
12   function totalSupply() public view returns (uint256 total);
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function transfer(address _to, uint256 _tokenId) public;
15 
16   event Transfer(address indexed from, address indexed to, uint256 tokenId);
17   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 contract PornstarsInterface {
27     function ownerOf(uint256 _id) public view returns (
28         address owner
29     );
30     
31     function totalSupply() public view returns (
32         uint256 total
33     );
34 }
35 
36 contract PornSceneToken is ERC721 {
37 
38   /*** EVENTS ***/
39 
40   /// @dev The Birth event is fired whenever a new scene comes into existence.
41   event Birth(uint256 tokenId, string name, uint[] stars, address owner);
42 
43   /// @dev The TokenSold event is fired whenever a token is sold.
44   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, uint[] stars);
45 
46   /// @dev Transfer event as defined in current draft of ERC721. 
47   ///  ownership is assigned, including births.
48   event Transfer(address from, address to, uint256 tokenId);
49 
50   /*** CONSTANTS ***/
51 
52   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
53   string public constant NAME = "CryptoPornScenes"; // solhint-disable-line
54   string public constant SYMBOL = "PornSceneToken"; // solhint-disable-line
55 
56   uint256 private startingPrice = 0.001 ether;
57   uint256 private constant PROMO_CREATION_LIMIT = 10000;
58   uint256 private firstStepLimit =  0.053613 ether;
59   uint256 private secondStepLimit = 0.564957 ether;
60 
61   /*** STORAGE ***/
62 
63   /// @dev A mapping from scene IDs to the address that owns them. All scenes have
64   ///  some valid owner address.
65   mapping (uint256 => address) public sceneIndexToOwner;
66 
67   // @dev A mapping from owner address to count of tokens that address owns.
68   //  Used internally inside balanceOf() to resolve ownership count.
69   mapping (address => uint256) private ownershipTokenCount;
70 
71   /// @dev A mapping from SceneIDs to an address that has been approved to call
72   ///  transferFrom(). Each Scene can only have one approved address for transfer
73   ///  at any time. A zero value means no approval is outstanding.
74   mapping (uint256 => address) public sceneIndexToApproved;
75 
76   // @dev A mapping from SceneIDs to the price of the token.
77   mapping (uint256 => uint256) private sceneIndexToPrice;
78 
79   // The addresses of the accounts (or contracts) that can execute actions within each roles.
80   address public ceoAddress;
81   address public cooAddress;
82 
83   PornstarsInterface pornstarsContract;
84   uint currentAwardWinner = 85; //Initiat the award. Award Holder from Previous Contract
85 
86   uint256 public promoCreatedCount;
87 
88   /*** DATATYPES ***/
89   struct Scene {
90     string name;
91     uint[] stars;
92   }
93 
94   Scene[] private scenes;
95 
96   /*** ACCESS MODIFIERS ***/
97   /// @dev Access modifier for CEO-only functionality
98   modifier onlyCEO() {
99     require(msg.sender == ceoAddress);
100     _;
101   }
102 
103   /// @dev Access modifier for COO-only functionality
104   modifier onlyCOO() {
105     require(msg.sender == cooAddress);
106     _;
107   }
108 
109   /// Access modifier for contract owner only functionality
110   modifier onlyCLevel() {
111     require(
112       msg.sender == ceoAddress ||
113       msg.sender == cooAddress
114     );
115     _;
116   }
117 
118   /*** CONSTRUCTOR ***/
119   function PornSceneToken() public {
120     ceoAddress = msg.sender;
121     cooAddress = msg.sender;
122   }
123 
124   /*** PUBLIC FUNCTIONS ***/
125   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
126   /// @param _to The address to be granted transfer approval. Pass address(0) to
127   ///  clear all approvals.
128   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
129   /// @dev Required for ERC-721 compliance.
130   function approve(
131     address _to,
132     uint256 _tokenId
133   ) public {
134     // Caller must own token.
135     require(_owns(msg.sender, _tokenId));
136 
137     sceneIndexToApproved[_tokenId] = _to;
138 
139     Approval(msg.sender, _to, _tokenId);
140   }
141 
142   /// For querying balance of a particular account
143   /// @param _owner The address for balance query
144   /// @dev Required for ERC-721 compliance.
145   function balanceOf(address _owner) public view returns (uint256 balance) {
146     return ownershipTokenCount[_owner];
147   }
148   
149   function setPornstarsContractAddress(address _address) public onlyCOO {
150       pornstarsContract = PornstarsInterface(_address);
151   }
152   
153   /// @dev Creates a new promo Scene with the given name, with given _price and assignes it to an address.
154   function createPromoScene(address _owner, string _name, uint[] _stars, uint256 _price) public onlyCOO {
155     require(promoCreatedCount < PROMO_CREATION_LIMIT);
156 
157     address sceneOwner = _owner;
158     if (sceneOwner == address(0)) {
159       sceneOwner = cooAddress;
160     }
161 
162     if (_price <= 0) {
163       _price = startingPrice;
164     }
165 
166     promoCreatedCount++;
167     _createScene(_name, _stars, sceneOwner, _price);
168   }
169 
170   /// @dev Creates a new Scene with the given name.
171   function createContractScene(string _name, uint[] _stars) public onlyCOO {
172     _createScene(_name, _stars, address(this), startingPrice);
173   }
174 
175   /// @notice Returns all the relevant information about a specific scene.
176   /// @param _tokenId The tokenId of the scene of interest.
177   function getScene(uint256 _tokenId) public view returns (
178     string sceneName,
179     uint[] stars,
180     uint256 sellingPrice,
181     address owner
182   ) {
183     Scene storage scene = scenes[_tokenId];
184     sceneName = scene.name;
185     stars = scene.stars;
186     sellingPrice = sceneIndexToPrice[_tokenId];
187     owner = sceneIndexToOwner[_tokenId];
188   }
189 
190   function implementsERC721() public pure returns (bool) {
191     return true;
192   }
193 
194   /// @dev Required for ERC-721 compliance.
195   function name() public pure returns (string) {
196     return NAME;
197   }
198 
199   /// For querying owner of token
200   /// @param _tokenId The tokenID for owner inquiry
201   /// @dev Required for ERC-721 compliance.
202   function ownerOf(uint256 _tokenId)
203     public
204     view
205     returns (address owner)
206   {
207     owner = sceneIndexToOwner[_tokenId];
208     require(owner != address(0));
209   }
210 
211   function payout(address _to) public onlyCLevel {
212     _payout(_to);
213   }
214 
215   // Allows someone to send ether and obtain the token
216   function purchase(uint256 _tokenId) public payable {
217     address oldOwner = sceneIndexToOwner[_tokenId];
218     address newOwner = msg.sender;
219 
220     uint256 sellingPrice = sceneIndexToPrice[_tokenId];
221 
222     // Making sure token owner is not sending to self
223     require(oldOwner != newOwner);
224 
225     // Safety check to prevent against an unexpected 0x0 default.
226     require(_addressNotNull(newOwner));
227 
228     // Making sure sent amount is greater than or equal to the sellingPrice
229     require(msg.value >= sellingPrice);
230 
231     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 80), 100));
232     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
233     
234     // Pornstar Holder Fees
235     // Get Scene Star Length
236     Scene memory _scene = scenes[_tokenId];
237     
238     require(_scene.stars.length > 0); //Make sure have stars in the scene
239 
240     uint256 holderFee = uint256(SafeMath.div(SafeMath.div(SafeMath.mul(sellingPrice, 10), 100), _scene.stars.length));
241     uint256 awardOwnerFee = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 4), 100));
242 
243     // Update prices
244     if (sellingPrice < firstStepLimit) {
245       // first stage
246       sceneIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 80);
247     } else if (sellingPrice < secondStepLimit) {
248       // second stage
249       sceneIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 80);
250     } else {
251       // third stage
252       sceneIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 80);
253     }
254 
255     _transfer(oldOwner, newOwner, _tokenId);
256 
257     // Pay previous tokenOwner if owner is not contract
258     if (oldOwner != address(this)) {
259       oldOwner.transfer(payment); //(1-0.06)
260     }
261     
262     _paySceneStarOwners(_scene, holderFee);
263     _payAwardOwner(awardOwnerFee);
264     
265     TokenSold(_tokenId, sellingPrice, sceneIndexToPrice[_tokenId], oldOwner, newOwner, _scene.name, _scene.stars);
266 
267     msg.sender.transfer(purchaseExcess);
268   }
269   
270   function _paySceneStarOwners(Scene _scene, uint256 fee) private {
271     for (uint i = 0; i < _scene.stars.length; i++) {
272         address _pornstarOwner;
273         (_pornstarOwner) = pornstarsContract.ownerOf(_scene.stars[i]);
274         
275         if(_isGoodAddress(_pornstarOwner)) {
276             _pornstarOwner.transfer(fee);
277         }
278     }
279   }
280   
281   function _payAwardOwner(uint256 fee) private {
282     address _awardOwner;
283     (_awardOwner) = pornstarsContract.ownerOf(currentAwardWinner);
284     
285     if(_isGoodAddress(_awardOwner)) {
286         _awardOwner.transfer(fee);
287     }
288   }
289   
290   function _isGoodAddress(address _addy) private view returns (bool) {
291       if(_addy == address(pornstarsContract)) {
292           return false;
293       }
294       
295       if(_addy == address(0) || _addy == address(0x0)) {
296           return false;
297       }
298       
299       return true;
300   }
301 
302   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
303     return sceneIndexToPrice[_tokenId];
304   }
305   
306   function starsOf(uint256 _tokenId) public view returns (uint[]) {
307       return scenes[_tokenId].stars;
308   }
309   
310   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
311   /// @param _newCEO The address of the new CEO
312   function setCEO(address _newCEO) public onlyCEO {
313     require(_newCEO != address(0));
314 
315     ceoAddress = _newCEO;
316   }
317 
318   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
319   /// @param _newCOO The address of the new COO
320   function setCOO(address _newCOO) public onlyCEO {
321     require(_newCOO != address(0));
322 
323     cooAddress = _newCOO;
324   }
325 
326   /// @dev Required for ERC-721 compliance.
327   function symbol() public pure returns (string) {
328     return SYMBOL;
329   }
330 
331   /// @notice Allow pre-approved user to take ownership of a token
332   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
333   /// @dev Required for ERC-721 compliance.
334   function takeOwnership(uint256 _tokenId) public {
335     address newOwner = msg.sender;
336     address oldOwner = sceneIndexToOwner[_tokenId];
337 
338     // Safety check to prevent against an unexpected 0x0 default.
339     require(_addressNotNull(newOwner));
340 
341     // Making sure transfer is approved
342     require(_approved(newOwner, _tokenId));
343 
344     _transfer(oldOwner, newOwner, _tokenId);
345   }
346 
347   /// @param _owner The owner whose celebrity tokens we are interested in.
348   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
349   ///  expensive (it walks the entire scenes array looking for scenes belonging to owner),
350   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
351   ///  not contract-to-contract calls.
352   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
353     uint256 tokenCount = balanceOf(_owner);
354     if (tokenCount == 0) {
355         // Return an empty array
356       return new uint256[](0);
357     } else {
358       uint256[] memory result = new uint256[](tokenCount);
359       uint256 totalscenes = totalSupply();
360       uint256 resultIndex = 0;
361 
362       uint256 sceneId;
363       for (sceneId = 0; sceneId <= totalscenes; sceneId++) {
364         if (sceneIndexToOwner[sceneId] == _owner) {
365           result[resultIndex] = sceneId;
366           resultIndex++;
367         }
368       }
369       return result;
370     }
371   }
372 
373   /// For querying totalSupply of token
374   /// @dev Required for ERC-721 compliance.
375   function totalSupply() public view returns (uint256 total) {
376     return scenes.length;
377   }
378 
379   /// Owner initates the transfer of the token to another account
380   /// @param _to The address for the token to be transferred to.
381   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
382   /// @dev Required for ERC-721 compliance.
383   function transfer(
384     address _to,
385     uint256 _tokenId
386   ) public {
387     require(_owns(msg.sender, _tokenId));
388     require(_addressNotNull(_to));
389 
390     _transfer(msg.sender, _to, _tokenId);
391   }
392 
393   /// Third-party initiates transfer of token from address _from to address _to
394   /// @param _from The address for the token to be transferred from.
395   /// @param _to The address for the token to be transferred to.
396   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
397   /// @dev Required for ERC-721 compliance.
398   function transferFrom(
399     address _from,
400     address _to,
401     uint256 _tokenId
402   ) public {
403     require(_owns(_from, _tokenId));
404     require(_approved(_to, _tokenId));
405     require(_addressNotNull(_to));
406 
407     _transfer(_from, _to, _tokenId);
408   }
409 
410   /*** PRIVATE FUNCTIONS ***/
411   /// Safety check on _to address to prevent against an unexpected 0x0 default.
412   function _addressNotNull(address _to) private pure returns (bool) {
413     return _to != address(0);
414   }
415 
416   /// For checking approval of transfer for address _to
417   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
418     return sceneIndexToApproved[_tokenId] == _to;
419   }
420 
421   /// For creating Scene
422   function _createScene(string _name, uint[] _stars,address _owner, uint256 _price) private {
423     // Require Stars Exists
424     require(_stars.length > 0);
425     
426     for (uint i = 0; i < _stars.length; i++) {
427         address _pornstarOwner;
428         (_pornstarOwner) = pornstarsContract.ownerOf(_stars[i]);
429         require(_pornstarOwner != address(0) || _pornstarOwner != address(0x0));
430     }
431       
432     Scene memory _scene = Scene({
433       name: _name,
434       stars: _stars
435     });
436     uint256 newSceneId = scenes.push(_scene) - 1;
437 
438     // It's probably never going to happen, 4 billion tokens are A LOT, but
439     // let's just be 100% sure we never let this happen.
440     require(newSceneId == uint256(uint32(newSceneId)));
441 
442     Birth(newSceneId, _name, _stars, _owner);
443 
444     sceneIndexToPrice[newSceneId] = _price;
445 
446     // This will assign ownership, and also emit the Transfer event as
447     // per ERC721 draft
448     _transfer(address(0), _owner, newSceneId);
449   }
450 
451   /// Check for token ownership
452   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
453     return claimant == sceneIndexToOwner[_tokenId];
454   }
455 
456   /// For paying out balance on contract
457   function _payout(address _to) private {
458     if (_to == address(0)) {
459       ceoAddress.transfer(this.balance);
460     } else {
461       _to.transfer(this.balance);
462     }
463   }
464 
465   /// @dev Assigns ownership of a specific Scene to an address.
466   function _transfer(address _from, address _to, uint256 _tokenId) private {
467     // Since the number of scenes is capped to 2^32 we can't overflow this
468     ownershipTokenCount[_to]++;
469     //transfer ownership
470     sceneIndexToOwner[_tokenId] = _to;
471 
472     // When creating new scenes _from is 0x0, but we can't account that address.
473     if (_from != address(0)) {
474       ownershipTokenCount[_from]--;
475       // clear any previously approved ownership exchange
476       delete sceneIndexToApproved[_tokenId];
477     }
478 
479     // Emit the transfer event.
480     Transfer(_from, _to, _tokenId);
481   }
482 }
483 
484 contract CryptoPornstarAward is PornSceneToken{
485     event Award(uint256 currentAwardWinner, uint32 awardTime);
486     
487     uint nonce = 0;
488     uint cooldownTime = 60;
489     uint32 awardTime = uint32(now);
490     
491     function _triggerCooldown() internal {
492         awardTime = uint32(now + cooldownTime);
493     }
494     
495     function _isTime() internal view returns (bool) {
496         return (awardTime <= now);
497     }
498     
499     function rand(uint min, uint max) internal returns (uint) {
500         nonce++;
501         return uint(keccak256(nonce))%(min+max)-min;
502     }
503 
504     function setCooldown(uint _newCooldown) public onlyCOO {
505         require (_newCooldown > 0);
506         cooldownTime = _newCooldown;
507         _triggerCooldown();
508     } 
509     
510     function getAwardTime () public view returns (uint32) {
511         return awardTime;
512     }
513     
514     function getCooldown () public view returns (uint) {
515         return cooldownTime;
516     }
517     
518     function newAward() public onlyCOO {        
519         uint256 _totalPornstars;
520         (_totalPornstars) = pornstarsContract.totalSupply();
521         
522         require(_totalPornstars > 0);
523         require(_isTime());
524         
525         currentAwardWinner = rand(0, _totalPornstars);
526         _triggerCooldown();
527         
528         Award(currentAwardWinner, awardTime);
529     }
530     
531     function getCurrentAward() public view returns (uint){
532         return currentAwardWinner;
533     }
534   
535 }
536 
537 library SafeMath {
538 
539   /**
540   * @dev Multiplies two numbers, throws on overflow.
541   */
542   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
543     if (a == 0) {
544       return 0;
545     }
546     uint256 c = a * b;
547     assert(c / a == b);
548     return c;
549   }
550 
551   /**
552   * @dev Integer division of two numbers, truncating the quotient.
553   */
554   function div(uint256 a, uint256 b) internal pure returns (uint256) {
555     // assert(b > 0); // Solidity automatically throws when dividing by 0
556     uint256 c = a / b;
557     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
558     return c;
559   }
560 
561   /**
562   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
563   */
564   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
565     assert(b <= a);
566     return a - b;
567   }
568 
569   /**
570   * @dev Adds two numbers, throws on overflow.
571   */
572   function add(uint256 a, uint256 b) internal pure returns (uint256) {
573     uint256 c = a + b;
574     assert(c >= a);
575     return c;
576   }
577 }