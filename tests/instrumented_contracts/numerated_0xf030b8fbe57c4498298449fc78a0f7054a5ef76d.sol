1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC721 interface
5  * @dev see https://github.com/ethereum/eips/issues/721
6  */
7 contract ERC721 {
8   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
9   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
10 
11   function balanceOf(address _owner) public view returns (uint256 _balance);
12   function ownerOf(uint256 _tokenId) public view returns (address _owner);
13   function transfer(address _to, uint256 _tokenId) public;
14   function approve(address _to, uint256 _tokenId) public;
15   function takeOwnership(uint256 _tokenId) public;
16 }
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26   mapping (address => bool) public admins;
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() public {
36     owner = msg.sender;
37     admins[owner] = true;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48   
49   modifier onlyAdmin() {
50     require(admins[msg.sender]);
51     _;
52   }
53 
54   function changeAdmin(address _newAdmin, bool _approved) onlyOwner public {
55     admins[_newAdmin] = _approved;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner public {
63     require(newOwner != address(0));
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a * b;
77     assert(a == 0 || c / a == b);
78     return c;
79   }
80 
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92   
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 /**
101  * @title ERC721Token
102  * Generic implementation for the required functionality of the ERC721 standard
103  */
104 contract ArkToken is ERC721, Ownable {
105   using SafeMath for uint256;
106 
107   // Total amount of tokens
108   uint256 private totalTokens;
109   uint256 public developerCut;
110 
111   // Animal Data
112   mapping (uint256 => Animal) public arkData;
113 
114   // Mapping from token ID to owner
115   mapping (uint256 => address) private tokenOwner;
116 
117   // mom ID => baby ID
118   mapping (uint256 => uint256) public babies;
119   
120   // baby ID => parents
121   mapping (uint256 => uint256[2]) public babyMommas;
122   
123   // token ID => their baby-makin' partner
124   mapping (uint256 => uint256) public mates;
125 
126   // baby ID => sum price of mom and dad needed to make this babby
127   mapping (uint256 => uint256) public babyMakinPrice;
128 
129   // Mapping from token ID to approved address
130   mapping (uint256 => address) private tokenApprovals;
131 
132   // Mapping from owner to list of owned token IDs
133   mapping (address => uint256[]) private ownedTokens;
134 
135   // Mapping from token ID to index of the owner tokens list
136   mapping(uint256 => uint256) private ownedTokensIndex;
137 
138   // Balances from % payouts.
139   mapping (address => uint256) public birtherBalances; 
140 
141   // Events
142   event Purchase(uint256 indexed _tokenId, address indexed _buyer, address indexed _seller, uint256 _purchasePrice);
143   event Birth(address indexed _birther, uint256 indexed _mom, uint256 _dad, uint256 indexed _baby);
144 
145   // Purchasing Caps for Determining Next Pool Cut
146   uint256 private firstCap  = 0.5 ether;
147   uint256 private secondCap = 1.0 ether;
148   uint256 private thirdCap  = 1.5 ether;
149   uint256 private finalCap  = 3.0 ether;
150 
151   // Struct to store Animal Data
152   struct Animal {
153     uint256 price;         // Current price of the item.
154     uint256 lastPrice;     // Last price needed to calculate whether baby-makin' limit has made it
155     address owner;         // Current owner of the item.
156     address birther;       // Address that birthed the animal.
157     uint256 birtherPct;    // Percent that birther will get for sales. The actual percent is this / 10.
158     uint8 gender;          // Gender of this animal: 0 for male, 1 for female.
159   }
160 
161   function createToken(uint256 _tokenId, uint256 _startingPrice, uint256 _cut, address _owner, uint8 _gender) onlyAdmin() public {
162     // make sure price > 0
163     require(_startingPrice > 0);
164     // make sure token hasn't been used yet
165     require(arkData[_tokenId].price == 0);
166     
167     // create new token
168     Animal storage curAnimal = arkData[_tokenId];
169 
170     curAnimal.owner = _owner;
171     curAnimal.price = _startingPrice;
172     curAnimal.lastPrice = _startingPrice;
173     curAnimal.gender = _gender;
174     curAnimal.birther = _owner;
175     curAnimal.birtherPct = _cut;
176 
177     // mint new token
178     _mint(_owner, _tokenId);
179   }
180 
181   function createMultiple (uint256[] _itemIds, uint256[] _prices, uint256[] _cuts, address[] _owners, uint8[] _genders) onlyAdmin() external {
182     for (uint256 i = 0; i < _itemIds.length; i++) {
183       createToken(_itemIds[i], _prices[i], _cuts[i], _owners[i], _genders[i]);
184     }
185   }
186 
187   function createBaby(uint256 _dad, uint256 _mom, uint256 _baby, uint256 _price) public onlyAdmin() 
188   {
189       mates[_mom] = _dad;
190       mates[_dad] = _mom;
191       babies[_mom] = _baby;
192       babyMommas[_baby] = [_mom, _dad];
193       babyMakinPrice[_baby] = _price;
194   }
195   
196   function createBabies(uint256[] _dads, uint256[] _moms, uint256[] _babies, uint256[] _prices) external onlyAdmin() {
197       require(_moms.length == _babies.length && _babies.length == _dads.length);
198       for (uint256 i = 0; i < _moms.length; i++) {
199           createBaby(_dads[i], _moms[i], _babies[i], _prices[i]);
200       }
201   }
202 
203   /**
204   * @dev Determines next price of token
205   * @param _price uint256 ID of current price
206   */
207   function getNextPrice (uint256 _price) private view returns (uint256 _nextPrice) {
208     if (_price < firstCap) {
209       return _price.mul(150).div(95);
210     } else if (_price < secondCap) {
211       return _price.mul(135).div(96);
212     } else if (_price < thirdCap) {
213       return _price.mul(125).div(97);
214     } else if (_price < finalCap) {
215       return _price.mul(117).div(97);
216     } else {
217       return _price.mul(115).div(98);
218     }
219   }
220 
221   /**
222   * @dev Purchase animal from previous owner
223   * @param _tokenId uint256 of token
224   */
225   function buyToken(uint256 _tokenId) public 
226     payable
227     isNotContract(msg.sender)
228   {
229 
230     // get data from storage
231     Animal storage animal = arkData[_tokenId];
232     uint256 price = animal.price;
233     address oldOwner = animal.owner;
234     address newOwner = msg.sender;
235     uint256 excess = msg.value.sub(price);
236 
237     // revert checks
238     require(price > 0);
239     require(msg.value >= price);
240     require(oldOwner != msg.sender);
241     require(oldOwner != address(0) && oldOwner != address(1)); // We're gonna put unbirthed babbies at 0x1
242     
243     uint256 totalCut = price.mul(4).div(100);
244     
245     uint256 birtherCut = price.mul(animal.birtherPct).div(1000); // birtherPct is % * 10 so we / 1000
246     birtherBalances[animal.birther] = birtherBalances[animal.birther].add(birtherCut);
247     
248     uint256 devCut = totalCut.sub(birtherCut);
249     developerCut = developerCut.add(devCut);
250 
251     transferToken(oldOwner, newOwner, _tokenId);
252 
253     // raise event
254     Purchase(_tokenId, newOwner, oldOwner, price);
255 
256     // set new prices
257     animal.price = getNextPrice(price);
258     animal.lastPrice = price;
259 
260     // Transfer payment to old owner minus the developer's and birther's cut.
261     oldOwner.transfer(price.sub(totalCut));
262     // Send refund to owner if needed
263     if (excess > 0) {
264       newOwner.transfer(excess);
265     }
266     
267     checkBirth(_tokenId);
268   }
269   
270   /**
271    * @dev Check to see whether a newly purchased animal should give birth.
272    * @param _tokenId Unique ID of the newly transferred animal.
273   */
274   function checkBirth(uint256 _tokenId)
275     internal
276   {
277     uint256 mom = 0;
278     
279     // gender 0 = male, 1 = female
280     if (arkData[_tokenId].gender == 0) {
281       mom = mates[_tokenId];
282     } else {
283       mom = _tokenId;
284     }
285     
286     if (babies[mom] > 0) {
287       if (tokenOwner[mates[_tokenId]] == msg.sender) {
288         // Check if the sum price to make a baby for these mates has been passed.
289         uint256 sumPrice = arkData[_tokenId].lastPrice + arkData[mates[_tokenId]].lastPrice;
290         if (sumPrice >= babyMakinPrice[babies[mom]]) {
291           autoBirth(babies[mom]);
292           
293           Birth(msg.sender, mom, mates[mom], babies[mom]);
294           babyMakinPrice[babies[mom]] = 0;
295           babies[mom] = 0;
296           mates[mates[mom]] = 0;
297           mates[mom] = 0;
298         }
299       }
300     }
301   }
302   
303   /**
304    * @dev Internal function to birth a baby if an owner has both mom and dad.
305    * @param _baby Token ID of the baby to birth.
306   */
307   function autoBirth(uint256 _baby)
308     internal
309   {
310     Animal storage animal = arkData[_baby];
311     animal.birther = msg.sender;
312     transferToken(animal.owner, msg.sender, _baby);
313   }
314 
315   /**
316   * @dev Transfer Token from Previous Owner to New Owner
317   * @param _from previous owner address
318   * @param _to new owner address
319   * @param _tokenId uint256 ID of token
320   */
321   function transferToken(address _from, address _to, uint256 _tokenId) internal {
322     // check token exists
323     require(tokenExists(_tokenId));
324 
325     // make sure previous owner is correct
326     require(arkData[_tokenId].owner == _from);
327 
328     require(_to != address(0));
329     require(_to != address(this));
330 
331     // clear approvals linked to this token
332     clearApproval(_from, _tokenId);
333 
334     // remove token from previous owner
335     removeToken(_from, _tokenId);
336 
337     // update owner and add token to new owner
338     addToken(_to, _tokenId);
339 
340    //raise event
341     Transfer(_from, _to, _tokenId);
342   }
343 
344   /**
345   * @dev Withdraw dev's cut
346   */
347   function withdraw(uint256 _amount) public onlyAdmin() {
348     if (_amount == 0) { 
349       _amount = developerCut; 
350     }
351     developerCut = developerCut.sub(_amount);
352     owner.transfer(_amount);
353   }
354 
355   /**
356    * @dev Withdraw anyone's birther balance.
357    * @param _beneficiary The person whose balance shall be sent to them.
358   */
359   function withdrawBalance(address _beneficiary) external {
360     uint256 payout = birtherBalances[_beneficiary];
361     birtherBalances[_beneficiary] = 0;
362     _beneficiary.transfer(payout);
363   }
364 
365   /**
366    * @dev Return all relevant data for an animal.
367    * @param _tokenId Unique animal ID.
368   */
369   function getArkData (uint256 _tokenId) external view 
370   returns (address _owner, uint256 _price, uint256 _nextPrice, uint256 _mate, 
371            address _birther, uint8 _gender, uint256 _baby, uint256 _babyPrice) 
372   {
373     Animal memory animal = arkData[_tokenId];
374     uint256 baby;
375     if (animal.gender == 1) baby = babies[_tokenId];
376     else baby = babies[mates[_tokenId]];
377     
378     return (animal.owner, animal.price, getNextPrice(animal.price), mates[_tokenId], 
379             animal.birther, animal.gender, baby, babyMakinPrice[baby]);
380   }
381   
382   /**
383    * @dev Get sum price required to birth baby.
384    * @param _babyId Unique baby Id.
385   */
386   function getBabyMakinPrice(uint256 _babyId) external view
387   returns (uint256 price)
388   {
389     price = babyMakinPrice[_babyId];
390   }
391 
392   /**
393    * @dev Get the parents of a certain baby.
394    * @param _babyId Unique baby Id.
395   */
396   function getBabyMommas(uint256 _babyId) external view
397   returns (uint256[2] parents)
398   {
399     parents = babyMommas[_babyId];
400   }
401   
402   /**
403    * @dev Frontend can use this to find the birther percent for animal.
404    * @param _tokenId The unique id for the animal.
405   */
406   function getBirthCut(uint256 _tokenId) external view
407   returns (uint256 birthCut)
408   {
409     birthCut = arkData[_tokenId].birtherPct;
410   }
411 
412   /**
413    * @dev Check the birther balance of a certain address.
414    * @param _owner The address to check the balance of.
415   */
416   function checkBalance(address _owner) external view returns (uint256) {
417     return birtherBalances[_owner];
418   }
419 
420   /**
421   * @dev Determines if token exists by checking it's price
422   * @param _tokenId uint256 ID of token
423   */
424   function tokenExists (uint256 _tokenId) public view returns (bool _exists) {
425     return arkData[_tokenId].price > 0;
426   }
427 
428   /**
429   * @dev Guarantees msg.sender is owner of the given token
430   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
431   */
432   modifier onlyOwnerOf(uint256 _tokenId) {
433     require(ownerOf(_tokenId) == msg.sender);
434     _;
435   }
436 
437   /**
438   * @dev Guarantees msg.sender is not a contract
439   * @param _buyer address of person buying animal
440   */
441   modifier isNotContract(address _buyer) {
442     uint size;
443     assembly { size := extcodesize(_buyer) }
444     require(size == 0);
445     _;
446   }
447 
448 
449   /**
450   * @dev Gets the total amount of tokens stored by the contract
451   * @return uint256 representing the total amount of tokens
452   */
453   function totalSupply() public view returns (uint256) {
454     return totalTokens;
455   }
456 
457   /**
458   * @dev Gets the balance of the specified address
459   * @param _owner address to query the balance of
460   * @return uint256 representing the amount owned by the passed address
461   */
462   function balanceOf(address _owner) public view returns (uint256) {
463     return ownedTokens[_owner].length;
464   }
465 
466   /**
467   * @dev Gets the list of tokens owned by a given address
468   * @param _owner address to query the tokens of
469   * @return uint256[] representing the list of tokens owned by the passed address
470   */
471   function tokensOf(address _owner) public view returns (uint256[]) {
472     return ownedTokens[_owner];
473   }
474 
475   /**
476   * @dev Gets the owner of the specified token ID
477   * @param _tokenId uint256 ID of the token to query the owner of
478   * @return owner address currently marked as the owner of the given token ID
479   */
480   function ownerOf(uint256 _tokenId) public view returns (address) {
481     address owner = tokenOwner[_tokenId];
482     return owner;
483   }
484 
485   /**
486    * @dev Gets the approved address to take ownership of a given token ID
487    * @param _tokenId uint256 ID of the token to query the approval of
488    * @return address currently approved to take ownership of the given token ID
489    */
490   function approvedFor(uint256 _tokenId) public view returns (address) {
491     return tokenApprovals[_tokenId];
492   }
493 
494   /**
495   * @dev Transfers the ownership of a given token ID to another address
496   * @param _to address to receive the ownership of the given token ID
497   * @param _tokenId uint256 ID of the token to be transferred
498   */
499   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
500     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
501   }
502 
503   /**
504   * @dev Approves another address to claim for the ownership of the given token ID
505   * @param _to address to be approved for the given token ID
506   * @param _tokenId uint256 ID of the token to be approved
507   */
508   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
509     address owner = ownerOf(_tokenId);
510     require(_to != owner);
511     if (approvedFor(_tokenId) != 0 || _to != 0) {
512       tokenApprovals[_tokenId] = _to;
513       Approval(owner, _to, _tokenId);
514     }
515   }
516 
517   /**
518   * @dev Claims the ownership of a given token ID
519   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
520   */
521   function takeOwnership(uint256 _tokenId) public {
522     require(isApprovedFor(msg.sender, _tokenId));
523     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
524   }
525 
526   /**
527    * @dev Tells whether the msg.sender is approved for the given token ID or not
528    * This function is not private so it can be extended in further implementations like the operatable ERC721
529    * @param _owner address of the owner to query the approval of
530    * @param _tokenId uint256 ID of the token to query the approval of
531    * @return bool whether the msg.sender is approved for the given token ID or not
532    */
533   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
534     return approvedFor(_tokenId) == _owner;
535   }
536   
537   /**
538   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
539   * @param _from address which you want to send tokens from
540   * @param _to address which you want to transfer the token to
541   * @param _tokenId uint256 ID of the token to be transferred
542   */
543   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal isNotContract(_to) {
544     require(_to != address(0));
545     require(_to != ownerOf(_tokenId));
546     require(ownerOf(_tokenId) == _from);
547 
548     clearApproval(_from, _tokenId);
549     removeToken(_from, _tokenId);
550     addToken(_to, _tokenId);
551     Transfer(_from, _to, _tokenId);
552   }
553 
554   /**
555   * @dev Internal function to clear current approval of a given token ID
556   * @param _tokenId uint256 ID of the token to be transferred
557   */
558   function clearApproval(address _owner, uint256 _tokenId) private {
559     require(ownerOf(_tokenId) == _owner);
560     tokenApprovals[_tokenId] = 0;
561     Approval(_owner, 0, _tokenId);
562   }
563 
564 
565     /**
566   * @dev Mint token function
567   * @param _to The address that will own the minted token
568   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
569   */
570   function _mint(address _to, uint256 _tokenId) internal {
571     addToken(_to, _tokenId);
572     Transfer(0x0, _to, _tokenId);
573   }
574 
575   /**
576   * @dev Internal function to add a token ID to the list of a given address
577   * @param _to address representing the new owner of the given token ID
578   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
579   */
580   function addToken(address _to, uint256 _tokenId) private {
581     require(tokenOwner[_tokenId] == address(0));
582     tokenOwner[_tokenId] = _to;
583     arkData[_tokenId].owner = _to;
584     
585     uint256 length = balanceOf(_to);
586     ownedTokens[_to].push(_tokenId);
587     ownedTokensIndex[_tokenId] = length;
588     totalTokens = totalTokens.add(1);
589   }
590 
591   /**
592   * @dev Internal function to remove a token ID from the list of a given address
593   * @param _from address representing the previous owner of the given token ID
594   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
595   */
596   function removeToken(address _from, uint256 _tokenId) private {
597     require(ownerOf(_tokenId) == _from);
598 
599     uint256 tokenIndex = ownedTokensIndex[_tokenId];
600     uint256 lastTokenIndex = balanceOf(_from).sub(1);
601     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
602 
603     tokenOwner[_tokenId] = 0;
604     ownedTokens[_from][tokenIndex] = lastToken;
605     ownedTokens[_from][lastTokenIndex] = 0;
606     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
607     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
608     // the lastToken to the first position, and then dropping the element placed in the last position of the list
609 
610     ownedTokens[_from].length--;
611     ownedTokensIndex[_tokenId] = 0;
612     ownedTokensIndex[lastToken] = tokenIndex;
613     totalTokens = totalTokens.sub(1);
614   }
615 
616   function name() public pure returns (string _name) {
617     return "EthersArk Token";
618   }
619 
620   function symbol() public pure returns (string _symbol) {
621     return "EARK";
622   }
623 
624 }