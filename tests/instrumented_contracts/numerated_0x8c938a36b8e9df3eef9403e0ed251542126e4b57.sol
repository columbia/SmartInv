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
29 contract PowZoneToken is ERC721 {
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
49   string public constant NAME = "CryptoKotakuPowZone"; // solhint-disable-line
50   string public constant SYMBOL = "PowZone"; // solhint-disable-line
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
84     uint gameItemId;
85   }
86 
87   Pow[] private pows;
88 
89   /*** ACCESS MODIFIERS ***/
90   /// @dev Access modifier for CEO-only functionality
91   modifier onlyCEO() {
92     require(msg.sender == ceoAddress);
93     _;
94   }
95 
96   /// @dev Access modifier for COO-only functionality
97   modifier onlyCOO() {
98     require(msg.sender == cooAddress);
99     _;
100   }
101 
102   /// Access modifier for contract owner only functionality
103   modifier onlyCLevel() {
104     require(
105       msg.sender == ceoAddress ||
106       msg.sender == cooAddress
107     );
108     _;
109   }
110 
111   /*** CONSTRUCTOR ***/
112   function PowZoneToken() public {
113     ceoAddress = msg.sender;
114     cooAddress = msg.sender;
115   }
116 
117   /*** PUBLIC FUNCTIONS ***/
118   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
119   /// @param _to The address to be granted transfer approval. Pass address(0) to
120   ///  clear all approvals.
121   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
122   /// @dev Required for ERC-721 compliance.
123   function approve(
124     address _to,
125     uint256 _tokenId
126   ) public {
127     // Caller must own token.
128     require(_owns(msg.sender, _tokenId));
129 
130     powIndexToApproved[_tokenId] = _to;
131 
132     Approval(msg.sender, _to, _tokenId);
133   }
134 
135   /// For querying balance of a particular account
136   /// @param _owner The address for balance query
137   /// @dev Required for ERC-721 compliance.
138   function balanceOf(address _owner) public view returns (uint256 balance) {
139     return ownershipTokenCount[_owner];
140   }
141 
142   /// @dev Creates a new promo Pow with the given name, with given _price and assignes it to an address.
143   function createPromoPow(address _owner, string _name, uint256 _price, uint _gameId, uint _gameItemId) public onlyCOO {
144 
145     address powOwner = _owner;
146     if (powOwner == address(0)) {
147       powOwner = cooAddress;
148     }
149 
150     if (_price <= 0) {
151       _price = startingPrice;
152     }
153 
154     promoCreatedCount++;
155     _createPow(_name, powOwner, _price, _gameId, _gameItemId);
156   }
157 
158   /// @dev Creates a new Pow with the given name.
159   function createContractPow(string _name, uint _gameId, uint _gameItemId) public onlyCOO {
160     _createPow(_name, address(this), startingPrice, _gameId, _gameItemId);
161   }
162 
163   /// @notice Returns all the relevant information about a specific pow.
164   /// @param _tokenId The tokenId of the pow of interest.
165   function getPow(uint256 _tokenId) public view returns (
166     uint256 Id,
167     string powName,
168     uint256 sellingPrice,
169     address owner,
170     uint gameId,
171     uint gameItemId
172   ) {
173     Pow storage pow = pows[_tokenId];
174     Id = _tokenId;
175     powName = pow.name;
176     sellingPrice = powIndexToPrice[_tokenId];
177     owner = powIndexToOwner[_tokenId];
178     gameId = pow.gameId;
179     gameItemId = pow.gameItemId;
180   }
181 
182   function implementsERC721() public pure returns (bool) {
183     return true;
184   }
185 
186   /// @dev Required for ERC-721 compliance.
187   function name() public pure returns (string) {
188     return NAME;
189   }
190 
191   /// For querying owner of token
192   /// @param _tokenId The tokenID for owner inquiry
193   /// @dev Required for ERC-721 compliance.
194   function ownerOf(uint256 _tokenId)
195     public
196     view
197     returns (address owner)
198   {
199     owner = powIndexToOwner[_tokenId];
200     require(owner != address(0));
201   }
202 
203   function payout(address _to) public onlyCLevel {
204     _payout(_to);
205   }
206 
207   // Allows someone to send ether and obtain the token
208   function purchase(uint256 _tokenId) public payable {
209     address oldOwner = powIndexToOwner[_tokenId];
210     address newOwner = msg.sender;
211 
212     uint256 sellingPrice = powIndexToPrice[_tokenId];
213 
214     // Making sure token owner is not sending to self
215     require(oldOwner != newOwner);
216 
217     // Safety check to prevent against an unexpected 0x0 default.
218     require(_addressNotNull(newOwner));
219 
220     // Making sure sent amount is greater than or equal to the sellingPrice
221     require(msg.value >= sellingPrice);
222 
223     uint256 gameOwnerPayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 5), 100));
224     uint256 gameItemOwnerPayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 10), 100));
225     uint256 payment =  sellingPrice - gameOwnerPayment - gameOwnerPayment - gameItemOwnerPayment;
226     uint256 purchaseExcess = SafeMath.sub(msg.value,sellingPrice);
227 
228     // Update prices
229     if (sellingPrice < firstStepLimit) {
230       // first stage
231       powIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
232     } else if (sellingPrice < secondStepLimit) {
233       // second stage
234       powIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 180), 100);
235     } else {
236       // third stage
237       powIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
238     }
239 
240     _transfer(oldOwner, newOwner, _tokenId);
241     TokenSold(_tokenId, sellingPrice, powIndexToPrice[_tokenId], oldOwner, newOwner, pows[_tokenId].name);
242 
243     // Pay previous tokenOwner if owner is not contract
244     if (oldOwner != address(this)) {
245       oldOwner.transfer(payment); //(1-0.2)
246     }
247     
248     msg.sender.transfer(purchaseExcess);
249     _transferDivs(gameOwnerPayment, gameItemOwnerPayment, _tokenId);
250     
251   }
252 
253   /// Divident distributions
254   function _transferDivs(uint256 _gameOwnerPayment, uint256 _gameItemOwnerPayment, uint256 _tokenId) private {
255     CryptoVideoGames gamesContract = CryptoVideoGames(cryptoVideoGames);
256     CryptoVideoGameItem gameItemContract = CryptoVideoGameItem(cryptoVideoGameItems);
257     address gameOwner = gamesContract.getVideoGameOwner(pows[_tokenId].gameId);
258     address gameItemOwner = gameItemContract.getVideoGameItemOwner(pows[_tokenId].gameItemId);
259     gameOwner.transfer(_gameOwnerPayment);
260     gameItemOwner.transfer(_gameItemOwnerPayment);
261   }
262 
263   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
264     return powIndexToPrice[_tokenId];
265   }
266 
267   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
268   /// @param _newCEO The address of the new CEO
269   function setCEO(address _newCEO) public onlyCEO {
270     require(_newCEO != address(0));
271 
272     ceoAddress = _newCEO;
273   }
274 
275   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
276   /// @param _newCOO The address of the new COO
277   function setCOO(address _newCOO) public onlyCEO {
278     require(_newCOO != address(0));
279 
280     cooAddress = _newCOO;
281   }
282 
283   /// @dev Required for ERC-721 compliance.
284   function symbol() public pure returns (string) {
285     return SYMBOL;
286   }
287 
288   /// @notice Allow pre-approved user to take ownership of a token
289   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
290   /// @dev Required for ERC-721 compliance.
291   function takeOwnership(uint256 _tokenId) public {
292     address newOwner = msg.sender;
293     address oldOwner = powIndexToOwner[_tokenId];
294 
295     // Safety check to prevent against an unexpected 0x0 default.
296     require(_addressNotNull(newOwner));
297 
298     // Making sure transfer is approved
299     require(_approved(newOwner, _tokenId));
300 
301     _transfer(oldOwner, newOwner, _tokenId);
302   }
303 
304   /// @param _owner The owner whose pow tokens we are interested in.
305   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
306   ///  expensive (it walks the entire pows array looking for pows belonging to owner),
307   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
308   ///  not contract-to-contract calls.
309   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
310     uint256 tokenCount = balanceOf(_owner);
311     if (tokenCount == 0) {
312         // Return an empty array
313       return new uint256[](0);
314     } else {
315       uint256[] memory result = new uint256[](tokenCount);
316       uint256 totalPows = totalSupply();
317       uint256 resultIndex = 0;
318 
319       uint256 powId;
320       for (powId = 0; powId <= totalPows; powId++) {
321         if (powIndexToOwner[powId] == _owner) {
322           result[resultIndex] = powId;
323           resultIndex++;
324         }
325       }
326       return result;
327     }
328   }
329 
330   /// For querying totalSupply of token
331   /// @dev Required for ERC-721 compliance.
332   function totalSupply() public view returns (uint256 total) {
333     return pows.length;
334   }
335 
336   /// Owner initates the transfer of the token to another account
337   /// @param _to The address for the token to be transferred to.
338   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
339   /// @dev Required for ERC-721 compliance.
340   function transfer(
341     address _to,
342     uint256 _tokenId
343   ) public {
344     require(_owns(msg.sender, _tokenId));
345     require(_addressNotNull(_to));
346 
347     _transfer(msg.sender, _to, _tokenId);
348   }
349 
350   /// Third-party initiates transfer of token from address _from to address _to
351   /// @param _from The address for the token to be transferred from.
352   /// @param _to The address for the token to be transferred to.
353   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
354   /// @dev Required for ERC-721 compliance.
355   function transferFrom(
356     address _from,
357     address _to,
358     uint256 _tokenId
359   ) public {
360     require(_owns(_from, _tokenId));
361     require(_approved(_to, _tokenId));
362     require(_addressNotNull(_to));
363 
364     _transfer(_from, _to, _tokenId);
365   }
366 
367   /*** PRIVATE FUNCTIONS ***/
368   /// Safety check on _to address to prevent against an unexpected 0x0 default.
369   function _addressNotNull(address _to) private pure returns (bool) {
370     return _to != address(0);
371   }
372 
373   /// For checking approval of transfer for address _to
374   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
375     return powIndexToApproved[_tokenId] == _to;
376   }
377 
378   /// For creating Pow
379   function _createPow(string _name, address _owner, uint256 _price, uint _gameId, uint _gameItemId) private {
380     Pow memory _pow = Pow({
381       name: _name,
382       gameId: _gameId,
383       gameItemId: _gameItemId
384     });
385     uint256 newPowId = pows.push(_pow) - 1;
386 
387     // It's probably never going to happen, 4 billion tokens are A LOT, but
388     // let's just be 100% sure we never let this happen.
389     require(newPowId == uint256(uint32(newPowId)));
390 
391     Birth(newPowId, _name, _owner);
392 
393     powIndexToPrice[newPowId] = _price;
394 
395     // This will assign ownership, and also emit the Transfer event as
396     // per ERC721 draft
397     _transfer(address(0), _owner, newPowId);
398   }
399 
400   /// Check for token ownership
401   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
402     return claimant == powIndexToOwner[_tokenId];
403   }
404 
405   /// For paying out balance on contract
406   function _payout(address _to) private {
407     if (_to == address(0)) {
408       ceoAddress.transfer(this.balance);
409     } else {
410       _to.transfer(this.balance);
411     }
412   }
413 
414   /*
415   This function can be used by the owner of a pow item to modify the price of its pow item.
416   */
417   function modifyPowPrice(uint _powId, uint256 _newPrice) public {
418       require(_newPrice > 0);
419       require(powIndexToOwner[_powId] == msg.sender);
420       powIndexToPrice[_powId] = _newPrice;
421   }
422 
423   /// @dev Assigns ownership of a specific Pow to an address.
424   function _transfer(address _from, address _to, uint256 _tokenId) private {
425     // Since the number of pow is capped to 2^32 we can't overflow this
426     ownershipTokenCount[_to]++;
427     //transfer ownership
428     powIndexToOwner[_tokenId] = _to;
429 
430     // When creating new pows _from is 0x0, but we can't account that address.
431     if (_from != address(0)) {
432       ownershipTokenCount[_from]--;
433       // clear any previously approved ownership exchange
434       delete powIndexToApproved[_tokenId];
435     }
436 
437     // Emit the transfer event.
438     Transfer(_from, _to, _tokenId);
439   }
440 
441 }
442 library SafeMath {
443 
444   /**
445   * @dev Multiplies two numbers, throws on overflow.
446   */
447   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
448     if (a == 0) {
449       return 0;
450     }
451     uint256 c = a * b;
452     assert(c / a == b);
453     return c;
454   }
455 
456   /**
457   * @dev Integer division of two numbers, truncating the quotient.
458   */
459   function div(uint256 a, uint256 b) internal pure returns (uint256) {
460     // assert(b > 0); // Solidity automatically throws when dividing by 0
461     uint256 c = a / b;
462     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
463     return c;
464   }
465 
466   /**
467   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
468   */
469   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
470     assert(b <= a);
471     return a - b;
472   }
473 
474   /**
475   * @dev Adds two numbers, throws on overflow.
476   */
477   function add(uint256 a, uint256 b) internal pure returns (uint256) {
478     uint256 c = a + b;
479     assert(c >= a);
480     return c;
481   }
482 
483 }
484 
485 
486 contract CryptoVideoGames {
487     // This function will return only the owner address of a specific Video Game
488     function getVideoGameOwner(uint _videoGameId) public view returns(address) {
489     }
490     
491 }
492 
493 
494 contract CryptoVideoGameItem {
495   function getVideoGameItemOwner(uint _videoGameItemId) public view returns(address) {
496     }
497 }