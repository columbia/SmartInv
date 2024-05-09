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
29 contract PokemonPow is ERC721 {
30 
31   address cryptoVideoGames = 0xdEc14D8f4DA25108Fd0d32Bf2DeCD9538564D069; 
32   address cryptoVideoGameItems = 0xD2606C9bC5EFE092A8925e7d6Ae2F63a84c5FDEa;
33 
34   /*** EVENTS ***/
35 
36   /// @dev The Birth event is fired whenever a new pow comes into existence.
37   event Birth(uint256 tokenId, string name, address owner);
38 
39   /// @dev The TokenSold event is fired whenever a token is sold.
40   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
41 
42   /// @dev Transfer event as defined in current draft of ERC721. 
43   ///  ownership is assigned, including births.
44   event Transfer(address from, address to, uint256 tokenId);
45 
46   /*** CONSTANTS ***/
47 
48   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
49   string public constant NAME = "CryptoKotakuPokemonPow"; // solhint-disable-line
50   string public constant SYMBOL = "PokemonPow"; // solhint-disable-line
51 
52   uint256 private startingPrice = 0.005 ether;
53   uint256 private firstStepLimit =  0.05 ether;
54   uint256 private secondStepLimit = 0.5 ether;
55 
56   /*** STORAGE ***/
57 
58   /// @dev A mapping from pow IDs to the address that owns them. All pows have
59   ///  some valid owner address.
60   mapping (uint256 => address) public powIndexToOwner;
61 
62   // @dev A mapping from owner address to count of tokens that address owns.
63   //  Used internally inside balanceOf() to resolve ownership count.
64   mapping (address => uint256) private ownershipTokenCount;
65 
66   /// @dev A mapping from PowIDs to an address that has been approved to call
67   ///  transferFrom(). Each Pow can only have one approved address for transfer
68   ///  at any time. A zero value means no approval is outstanding.
69   mapping (uint256 => address) public powIndexToApproved;
70 
71   // @dev A mapping from PowIDs to the price of the token.
72   mapping (uint256 => uint256) private powIndexToPrice;
73 
74   // The addresses of the accounts (or contracts) that can execute actions within each roles.
75   address public ceoAddress;
76   address public cooAddress;
77 
78   uint256 public promoCreatedCount;
79 
80   /*** DATATYPES ***/
81   struct Pow {
82     string name;
83     uint gameId;
84     uint gameItemId1;
85     uint gameItemId2;
86   }
87 
88   Pow[] private pows;
89 
90   /*** ACCESS MODIFIERS ***/
91   /// @dev Access modifier for CEO-only functionality
92   modifier onlyCEO() {
93     require(msg.sender == ceoAddress);
94     _;
95   }
96 
97   /// @dev Access modifier for COO-only functionality
98   modifier onlyCOO() {
99     require(msg.sender == cooAddress);
100     _;
101   }
102 
103   /// Access modifier for contract owner only functionality
104   modifier onlyCLevel() {
105     require(
106       msg.sender == ceoAddress ||
107       msg.sender == cooAddress
108     );
109     _;
110   }
111 
112   /*** CONSTRUCTOR ***/
113   function PokemonPow() public {
114     ceoAddress = msg.sender;
115     cooAddress = msg.sender;
116   }
117 
118   /*** PUBLIC FUNCTIONS ***/
119   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
120   /// @param _to The address to be granted transfer approval. Pass address(0) to
121   ///  clear all approvals.
122   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
123   /// @dev Required for ERC-721 compliance.
124   function approve(
125     address _to,
126     uint256 _tokenId
127   ) public {
128     // Caller must own token.
129     require(_owns(msg.sender, _tokenId));
130 
131     powIndexToApproved[_tokenId] = _to;
132 
133     Approval(msg.sender, _to, _tokenId);
134   }
135 
136   /// For querying balance of a particular account
137   /// @param _owner The address for balance query
138   /// @dev Required for ERC-721 compliance.
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return ownershipTokenCount[_owner];
141   }
142 
143   /// @dev Creates a new promo Pow with the given name, with given _price and assignes it to an address.
144   function createPromoPow(address _owner, string _name, uint256 _price, uint _gameId, uint _gameItemId1, uint _gameItemId2) public onlyCOO {
145 
146     address powOwner = _owner;
147     if (powOwner == address(0)) {
148       powOwner = cooAddress;
149     }
150 
151     if (_price <= 0) {
152       _price = startingPrice;
153     }
154 
155     promoCreatedCount++;
156     _createPow(_name, powOwner, _price, _gameId, _gameItemId1, _gameItemId2);
157   }
158 
159   /// @dev Creates a new Pow with the given name.
160   function createContractPow(string _name, uint _gameId, uint _gameItemId1, uint _gameItemId2) public onlyCOO {
161     _createPow(_name, address(this), startingPrice, _gameId, _gameItemId1, _gameItemId2);
162   }
163 
164   /// @notice Returns all the relevant information about a specific pow.
165   /// @param _tokenId The tokenId of the pow of interest.
166   function getPow(uint256 _tokenId) public view returns (
167     uint256 Id,
168     string powName,
169     uint256 sellingPrice,
170     address owner,
171     uint gameId,
172     uint gameItemId1,
173     uint gameItemId2
174   ) {
175     Pow storage pow = pows[_tokenId];
176     Id = _tokenId;
177     powName = pow.name;
178     sellingPrice = powIndexToPrice[_tokenId];
179     owner = powIndexToOwner[_tokenId];
180     gameId = pow.gameId;
181     gameItemId1 = pow.gameItemId1;
182     gameItemId2 = pow.gameItemId2;
183   }
184 
185   function implementsERC721() public pure returns (bool) {
186     return true;
187   }
188 
189   /// @dev Required for ERC-721 compliance.
190   function name() public pure returns (string) {
191     return NAME;
192   }
193 
194   /// For querying owner of token
195   /// @param _tokenId The tokenID for owner inquiry
196   /// @dev Required for ERC-721 compliance.
197   function ownerOf(uint256 _tokenId)
198     public
199     view
200     returns (address owner)
201   {
202     owner = powIndexToOwner[_tokenId];
203     require(owner != address(0));
204   }
205 
206   function payout(address _to) public onlyCLevel {
207     _payout(_to);
208   }
209 
210   // Allows someone to send ether and obtain the token
211   function purchase(uint256 _tokenId) public payable {
212     address oldOwner = powIndexToOwner[_tokenId];
213     address newOwner = msg.sender;
214 
215     uint256 sellingPrice = powIndexToPrice[_tokenId];
216 
217     // Making sure token owner is not sending to self
218     require(oldOwner != newOwner);
219 
220     // Safety check to prevent against an unexpected 0x0 default.
221     require(_addressNotNull(newOwner));
222 
223     // Making sure sent amount is greater than or equal to the sellingPrice
224     require(msg.value >= sellingPrice);
225 
226     uint256 gameOwnerPayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 5), 100));
227     uint256 gameItemOwnerPayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 5), 100));
228     uint256 payment =  sellingPrice - gameOwnerPayment - gameOwnerPayment - gameItemOwnerPayment - gameItemOwnerPayment;
229     uint256 purchaseExcess = SafeMath.sub(msg.value,sellingPrice);
230 
231     // Update prices
232     if (sellingPrice < firstStepLimit) {
233       // first stage
234       powIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
235     } else if (sellingPrice < secondStepLimit) {
236       // second stage
237       powIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 180), 100);
238     } else {
239       // third stage
240       powIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
241     }
242 
243     _transfer(oldOwner, newOwner, _tokenId);
244     TokenSold(_tokenId, sellingPrice, powIndexToPrice[_tokenId], oldOwner, newOwner, pows[_tokenId].name);
245 
246     // Pay previous tokenOwner if owner is not contract
247     if (oldOwner != address(this)) {
248       oldOwner.transfer(payment); //(1-0.2)
249     }
250     
251     msg.sender.transfer(purchaseExcess);
252     _transferDivs(gameOwnerPayment, gameItemOwnerPayment, _tokenId);
253     
254   }
255 
256   /// Divident distributions
257   function _transferDivs(uint256 _gameOwnerPayment, uint256 _gameItemOwnerPayment, uint256 _tokenId) private {
258     CryptoVideoGames gamesContract = CryptoVideoGames(cryptoVideoGames);
259     CryptoVideoGameItem gameItemContract = CryptoVideoGameItem(cryptoVideoGameItems);
260     address gameOwner = gamesContract.getVideoGameOwner(pows[_tokenId].gameId);
261     address gameItem1Owner = gameItemContract.getVideoGameItemOwner(pows[_tokenId].gameItemId1);
262     address gameItem2Owner = gameItemContract.getVideoGameItemOwner(pows[_tokenId].gameItemId2);
263     gameOwner.transfer(_gameOwnerPayment);
264     gameItem1Owner.transfer(_gameItemOwnerPayment);
265     gameItem2Owner.transfer(_gameItemOwnerPayment);
266   }
267 
268   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
269     return powIndexToPrice[_tokenId];
270   }
271 
272   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
273   /// @param _newCEO The address of the new CEO
274   function setCEO(address _newCEO) public onlyCEO {
275     require(_newCEO != address(0));
276 
277     ceoAddress = _newCEO;
278   }
279 
280   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
281   /// @param _newCOO The address of the new COO
282   function setCOO(address _newCOO) public onlyCEO {
283     require(_newCOO != address(0));
284 
285     cooAddress = _newCOO;
286   }
287 
288   /// @dev Required for ERC-721 compliance.
289   function symbol() public pure returns (string) {
290     return SYMBOL;
291   }
292 
293   /// @notice Allow pre-approved user to take ownership of a token
294   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
295   /// @dev Required for ERC-721 compliance.
296   function takeOwnership(uint256 _tokenId) public {
297     address newOwner = msg.sender;
298     address oldOwner = powIndexToOwner[_tokenId];
299 
300     // Safety check to prevent against an unexpected 0x0 default.
301     require(_addressNotNull(newOwner));
302 
303     // Making sure transfer is approved
304     require(_approved(newOwner, _tokenId));
305 
306     _transfer(oldOwner, newOwner, _tokenId);
307   }
308 
309   /// @param _owner The owner whose pow tokens we are interested in.
310   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
311   ///  expensive (it walks the entire pows array looking for pows belonging to owner),
312   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
313   ///  not contract-to-contract calls.
314   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
315     uint256 tokenCount = balanceOf(_owner);
316     if (tokenCount == 0) {
317         // Return an empty array
318       return new uint256[](0);
319     } else {
320       uint256[] memory result = new uint256[](tokenCount);
321       uint256 totalPows = totalSupply();
322       uint256 resultIndex = 0;
323 
324       uint256 powId;
325       for (powId = 0; powId <= totalPows; powId++) {
326         if (powIndexToOwner[powId] == _owner) {
327           result[resultIndex] = powId;
328           resultIndex++;
329         }
330       }
331       return result;
332     }
333   }
334 
335   /// For querying totalSupply of token
336   /// @dev Required for ERC-721 compliance.
337   function totalSupply() public view returns (uint256 total) {
338     return pows.length;
339   }
340 
341   /// Owner initates the transfer of the token to another account
342   /// @param _to The address for the token to be transferred to.
343   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
344   /// @dev Required for ERC-721 compliance.
345   function transfer(
346     address _to,
347     uint256 _tokenId
348   ) public {
349     require(_owns(msg.sender, _tokenId));
350     require(_addressNotNull(_to));
351 
352     _transfer(msg.sender, _to, _tokenId);
353   }
354 
355   /// Third-party initiates transfer of token from address _from to address _to
356   /// @param _from The address for the token to be transferred from.
357   /// @param _to The address for the token to be transferred to.
358   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
359   /// @dev Required for ERC-721 compliance.
360   function transferFrom(
361     address _from,
362     address _to,
363     uint256 _tokenId
364   ) public {
365     require(_owns(_from, _tokenId));
366     require(_approved(_to, _tokenId));
367     require(_addressNotNull(_to));
368 
369     _transfer(_from, _to, _tokenId);
370   }
371 
372   /*** PRIVATE FUNCTIONS ***/
373   /// Safety check on _to address to prevent against an unexpected 0x0 default.
374   function _addressNotNull(address _to) private pure returns (bool) {
375     return _to != address(0);
376   }
377 
378   /// For checking approval of transfer for address _to
379   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
380     return powIndexToApproved[_tokenId] == _to;
381   }
382 
383   /// For creating Pow
384   function _createPow(string _name, address _owner, uint256 _price, uint _gameId, uint _gameItemId1, uint _gameItemId2) private {
385     Pow memory _pow = Pow({
386       name: _name,
387       gameId: _gameId,
388       gameItemId1: _gameItemId1,
389       gameItemId2: _gameItemId2
390     });
391     uint256 newPowId = pows.push(_pow) - 1;
392 
393     // It's probably never going to happen, 4 billion tokens are A LOT, but
394     // let's just be 100% sure we never let this happen.
395     require(newPowId == uint256(uint32(newPowId)));
396 
397     Birth(newPowId, _name, _owner);
398 
399     powIndexToPrice[newPowId] = _price;
400 
401     // This will assign ownership, and also emit the Transfer event as
402     // per ERC721 draft
403     _transfer(address(0), _owner, newPowId);
404   }
405 
406   /// Check for token ownership
407   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
408     return claimant == powIndexToOwner[_tokenId];
409   }
410 
411   /// For paying out balance on contract
412   function _payout(address _to) private {
413     if (_to == address(0)) {
414       ceoAddress.transfer(this.balance);
415     } else {
416       _to.transfer(this.balance);
417     }
418   }
419 
420   /*
421   This function can be used by the owner of a pow item to modify the price of its pow item.
422   */
423   function modifyPowPrice(uint _powId, uint256 _newPrice) public {
424       require(_newPrice > 0);
425       require(powIndexToOwner[_powId] == msg.sender);
426       powIndexToPrice[_powId] = _newPrice;
427   }
428 
429   /// @dev Assigns ownership of a specific Pow to an address.
430   function _transfer(address _from, address _to, uint256 _tokenId) private {
431     // Since the number of pow is capped to 2^32 we can't overflow this
432     ownershipTokenCount[_to]++;
433     //transfer ownership
434     powIndexToOwner[_tokenId] = _to;
435 
436     // When creating new pows _from is 0x0, but we can't account that address.
437     if (_from != address(0)) {
438       ownershipTokenCount[_from]--;
439       // clear any previously approved ownership exchange
440       delete powIndexToApproved[_tokenId];
441     }
442 
443     // Emit the transfer event.
444     Transfer(_from, _to, _tokenId);
445   }
446 
447 }
448 library SafeMath {
449 
450   /**
451   * @dev Multiplies two numbers, throws on overflow.
452   */
453   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
454     if (a == 0) {
455       return 0;
456     }
457     uint256 c = a * b;
458     assert(c / a == b);
459     return c;
460   }
461 
462   /**
463   * @dev Integer division of two numbers, truncating the quotient.
464   */
465   function div(uint256 a, uint256 b) internal pure returns (uint256) {
466     // assert(b > 0); // Solidity automatically throws when dividing by 0
467     uint256 c = a / b;
468     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
469     return c;
470   }
471 
472   /**
473   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
474   */
475   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
476     assert(b <= a);
477     return a - b;
478   }
479 
480   /**
481   * @dev Adds two numbers, throws on overflow.
482   */
483   function add(uint256 a, uint256 b) internal pure returns (uint256) {
484     uint256 c = a + b;
485     assert(c >= a);
486     return c;
487   }
488 
489 }
490 
491 
492 contract CryptoVideoGames {
493     // This function will return only the owner address of a specific Video Game
494     function getVideoGameOwner(uint _videoGameId) public view returns(address) {
495     }
496     
497 }
498 
499 
500 contract CryptoVideoGameItem {
501   function getVideoGameItemOwner(uint _videoGameItemId) public view returns(address) {
502     }
503 }