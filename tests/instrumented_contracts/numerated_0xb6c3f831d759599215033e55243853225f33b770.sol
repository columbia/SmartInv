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
29 contract GameItemNew is ERC721 {
30 
31   address cryptoVideoGames = 0xdec14d8f4da25108fd0d32bf2decd9538564d069; 
32 
33   /*** EVENTS ***/
34 
35   /// @dev The Birth event is fired whenever a new Game Item comes into existence.
36   event Birth(uint256 tokenId, string name, address owner);
37 
38   /// @dev The TokenSold event is fired whenever a token is sold.
39   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
40 
41   /// @dev Transfer event as defined in current draft of ERC721. 
42   ///  ownership is assigned, including births.
43   event Transfer(address from, address to, uint256 tokenId);
44 
45   /*** CONSTANTS ***/
46 
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "CryptoKotakuGameItemNew"; // solhint-disable-line
49   string public constant SYMBOL = "GameItemNew"; // solhint-disable-line
50 
51   uint256 private startingPrice = 0.005 ether;
52 
53   /*** STORAGE ***/
54 
55   /// @dev A mapping from Game Item IDs to the address that owns them. All Game Items have
56   ///  some valid owner address.
57   mapping (uint256 => address) public gameItemIndexToOwner;
58 
59   // @dev A mapping from owner address to count of tokens that address owns.
60   //  Used internally inside balanceOf() to resolve ownership count.
61   mapping (address => uint256) private ownershipTokenCount;
62 
63   /// @dev A mapping from gameItemIDs to an address that has been approved to call
64   ///  transferFrom(). Each game Item can only have one approved address for transfer
65   ///  at any time. A zero value means no approval is outstanding.
66   mapping (uint256 => address) public gameItemIndexToApproved;
67 
68   // @dev A mapping from game Item IDs to the price of the token.
69   mapping (uint256 => uint256) private gameItemIndexToPrice;
70 
71   // The addresses of the accounts (or contracts) that can execute actions within each roles.
72   address public ceoAddress;
73   address public cooAddress;
74 
75   uint256 public promoCreatedCount;
76 
77   /*** DATATYPES ***/
78   struct GameItem {
79     string name;
80     uint gameId;
81   }
82 
83   GameItem[] private gameItems;
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
108   function GameItemNew() public {
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
126     gameItemIndexToApproved[_tokenId] = _to;
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
138   /// @dev Creates a new promo game Item with the given name, with given _price and assignes it to an address.
139   function createPromoGameItem(address _owner, string _name, uint256 _price, uint _gameId) public onlyCOO {
140 
141     address gameItemOwner = _owner;
142     if (gameItemOwner == address(0)) {
143       gameItemOwner = cooAddress;
144     }
145 
146     if (_price <= 0) {
147       _price = startingPrice;
148     }
149 
150     promoCreatedCount++;
151     _createGameItem(_name, gameItemOwner, _price, _gameId);
152   }
153 
154   /// @dev Creates a new gameItem with the given name.
155   function createContractGameItem(string _name, uint _gameId) public onlyCOO {
156     _createGameItem(_name, address(this), startingPrice, _gameId);
157   }
158 
159   /// @notice Returns all the relevant information about a specific GameItem.
160   /// @param _tokenId The tokenId of the GameItem of interest.
161   function getGameItem(uint256 _tokenId) public view returns (
162     uint256 Id,
163     string gameItemName,
164     uint256 sellingPrice,
165     address owner,
166     uint gameId
167   ) {
168     GameItem storage gameItem = gameItems[_tokenId];
169     Id = _tokenId;
170     gameItemName = gameItem.name;
171     sellingPrice = gameItemIndexToPrice[_tokenId];
172     owner = gameItemIndexToOwner[_tokenId];
173     gameId = gameItem.gameId;
174   }
175 
176   function implementsERC721() public pure returns (bool) {
177     return true;
178   }
179 
180   /// @dev Required for ERC-721 compliance.
181   function name() public pure returns (string) {
182     return NAME;
183   }
184 
185   /// For querying owner of token
186   /// @param _tokenId The tokenID for owner inquiry
187   /// @dev Required for ERC-721 compliance.
188   function ownerOf(uint256 _tokenId)
189     public
190     view
191     returns (address owner)
192   {
193     owner = gameItemIndexToOwner[_tokenId];
194     require(owner != address(0));
195   }
196 
197   function payout(address _to) public onlyCLevel {
198     _payout(_to);
199   }
200 
201   // Allows someone to send ether and obtain the token
202   function purchase(uint256 _tokenId) public payable {
203     address oldOwner = gameItemIndexToOwner[_tokenId];
204     address newOwner = msg.sender;
205 
206     uint256 sellingPrice = gameItemIndexToPrice[_tokenId];
207 
208     // Making sure token owner is not sending to self
209     require(oldOwner != newOwner);
210 
211     // Safety check to prevent against an unexpected 0x0 default.
212     require(_addressNotNull(newOwner));
213 
214     // Making sure sent amount is greater than or equal to the sellingPrice
215     require(msg.value >= sellingPrice);
216 
217     uint256 gameOwnerPayment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 10), 100));
218     uint256 devFees = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 6), 100));
219     uint256 payment =  sellingPrice - devFees - gameOwnerPayment;
220     uint256 purchaseExcess = SafeMath.sub(msg.value,sellingPrice);
221 
222    
223     gameItemIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
224     
225     _transfer(oldOwner, newOwner, _tokenId);
226     TokenSold(_tokenId, sellingPrice, gameItemIndexToPrice[_tokenId], oldOwner, newOwner, gameItems[_tokenId].name);
227 
228     // Pay previous tokenOwner if owner is not contract
229     if (oldOwner != address(this)) {
230       oldOwner.transfer(payment);
231     }
232     
233     msg.sender.transfer(purchaseExcess);
234     _transferDivs(gameOwnerPayment, _tokenId, devFees);
235     
236   }
237 
238   /// Divident distributions
239   function _transferDivs(uint256 _gameOwnerPayment, uint256 _tokenId,uint256 _devFees) private {
240     CryptoVideoGames gamesContract = CryptoVideoGames(cryptoVideoGames);
241     address gameOwner = gamesContract.getVideoGameOwner(gameItems[_tokenId].gameId);
242     gameOwner.transfer(_gameOwnerPayment);
243     ceoAddress.transfer(_devFees);
244   }
245 
246   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
247     return gameItemIndexToPrice[_tokenId];
248   }
249 
250   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
251   /// @param _newCEO The address of the new CEO
252   function setCEO(address _newCEO) public onlyCEO {
253     require(_newCEO != address(0));
254 
255     ceoAddress = _newCEO;
256   }
257 
258   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
259   /// @param _newCOO The address of the new COO
260   function setCOO(address _newCOO) public onlyCEO {
261     require(_newCOO != address(0));
262 
263     cooAddress = _newCOO;
264   }
265 
266   /// @dev Required for ERC-721 compliance.
267   function symbol() public pure returns (string) {
268     return SYMBOL;
269   }
270 
271   /// @notice Allow pre-approved user to take ownership of a token
272   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
273   /// @dev Required for ERC-721 compliance.
274   function takeOwnership(uint256 _tokenId) public {
275     address newOwner = msg.sender;
276     address oldOwner = gameItemIndexToOwner[_tokenId];
277 
278     // Safety check to prevent against an unexpected 0x0 default.
279     require(_addressNotNull(newOwner));
280 
281     // Making sure transfer is approved
282     require(_approved(newOwner, _tokenId));
283 
284     _transfer(oldOwner, newOwner, _tokenId);
285   }
286 
287   /// @param _owner The owner whose gameItem tokens we are interested in.
288   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
289   ///  expensive (it walks the entire gameItems array looking for gameItems belonging to owner),
290   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
291   ///  not contract-to-contract calls.
292   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
293     uint256 tokenCount = balanceOf(_owner);
294     if (tokenCount == 0) {
295         // Return an empty array
296       return new uint256[](0);
297     } else {
298       uint256[] memory result = new uint256[](tokenCount);
299       uint256 totalGameItems = totalSupply();
300       uint256 resultIndex = 0;
301 
302       uint256 gameItemId;
303       for (gameItemId = 0; gameItemId <= totalGameItems; gameItemId++) {
304         if (gameItemIndexToOwner[gameItemId] == _owner) {
305           result[resultIndex] = gameItemId;
306           resultIndex++;
307         }
308       }
309       return result;
310     }
311   }
312 
313   /// For querying totalSupply of token
314   /// @dev Required for ERC-721 compliance.
315   function totalSupply() public view returns (uint256 total) {
316     return gameItems.length;
317   }
318 
319   /// Owner initates the transfer of the token to another account
320   /// @param _to The address for the token to be transferred to.
321   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
322   /// @dev Required for ERC-721 compliance.
323   function transfer(
324     address _to,
325     uint256 _tokenId
326   ) public {
327     require(_owns(msg.sender, _tokenId));
328     require(_addressNotNull(_to));
329 
330     _transfer(msg.sender, _to, _tokenId);
331   }
332 
333   /// Third-party initiates transfer of token from address _from to address _to
334   /// @param _from The address for the token to be transferred from.
335   /// @param _to The address for the token to be transferred to.
336   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
337   /// @dev Required for ERC-721 compliance.
338   function transferFrom(
339     address _from,
340     address _to,
341     uint256 _tokenId
342   ) public {
343     require(_owns(_from, _tokenId));
344     require(_approved(_to, _tokenId));
345     require(_addressNotNull(_to));
346 
347     _transfer(_from, _to, _tokenId);
348   }
349 
350   /*** PRIVATE FUNCTIONS ***/
351   /// Safety check on _to address to prevent against an unexpected 0x0 default.
352   function _addressNotNull(address _to) private pure returns (bool) {
353     return _to != address(0);
354   }
355 
356   /// For checking approval of transfer for address _to
357   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
358     return gameItemIndexToApproved[_tokenId] == _to;
359   }
360 
361   /// For creating gameItem
362   function _createGameItem(string _name, address _owner, uint256 _price, uint _gameId) private {
363     GameItem memory _gameItem = GameItem({
364       name: _name,
365       gameId: _gameId
366     });
367     uint256 newGameItemId = gameItems.push(_gameItem) - 1;
368 
369     // It's probably never going to happen, 4 billion tokens are A LOT, but
370     // let's just be 100% sure we never let this happen.
371     require(newGameItemId == uint256(uint32(newGameItemId)));
372 
373     Birth(newGameItemId, _name, _owner);
374 
375     gameItemIndexToPrice[newGameItemId] = _price;
376 
377     // This will assign ownership, and also emit the Transfer event as
378     // per ERC721 draft
379     _transfer(address(0), _owner, newGameItemId);
380   }
381 
382   /// Check for token ownership
383   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
384     return claimant == gameItemIndexToOwner[_tokenId];
385   }
386 
387   /// For paying out balance on contract
388   function _payout(address _to) private {
389     if (_to == address(0)) {
390       ceoAddress.transfer(this.balance);
391     } else {
392       _to.transfer(this.balance);
393     }
394   }
395 
396   /*
397   This function can be used by the owner of a GameItem item to modify the price of its GameItem item.
398   */
399   function modifyGameItemPrice(uint _gameItemId, uint256 _newPrice) public {
400       require(_newPrice > 0);
401       require(gameItemIndexToOwner[_gameItemId] == msg.sender);
402       gameItemIndexToPrice[_gameItemId] = _newPrice;
403   }
404 
405   /// @dev Assigns ownership of a specific gameItem to an address.
406   function _transfer(address _from, address _to, uint256 _tokenId) private {
407     // Since the number of gameItem is capped to 2^32 we can't overflow this
408     ownershipTokenCount[_to]++;
409     //transfer ownership
410     gameItemIndexToOwner[_tokenId] = _to;
411 
412     // When creating new gameItems _from is 0x0, but we can't account that address.
413     if (_from != address(0)) {
414       ownershipTokenCount[_from]--;
415       // clear any previously approved ownership exchange
416       delete gameItemIndexToApproved[_tokenId];
417     }
418 
419     // Emit the transfer event.
420     Transfer(_from, _to, _tokenId);
421   }
422 
423 }
424 library SafeMath {
425 
426   /**
427   * @dev Multiplies two numbers, throws on overflow.
428   */
429   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
430     if (a == 0) {
431       return 0;
432     }
433     uint256 c = a * b;
434     assert(c / a == b);
435     return c;
436   }
437 
438   /**
439   * @dev Integer division of two numbers, truncating the quotient.
440   */
441   function div(uint256 a, uint256 b) internal pure returns (uint256) {
442     // assert(b > 0); // Solidity automatically throws when dividing by 0
443     uint256 c = a / b;
444     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
445     return c;
446   }
447 
448   /**
449   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
450   */
451   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
452     assert(b <= a);
453     return a - b;
454   }
455 
456   /**
457   * @dev Adds two numbers, throws on overflow.
458   */
459   function add(uint256 a, uint256 b) internal pure returns (uint256) {
460     uint256 c = a + b;
461     assert(c >= a);
462     return c;
463   }
464 
465 }
466 
467 
468 contract CryptoVideoGames {
469     // This function will return only the owner address of a specific Video Game
470     function getVideoGameOwner(uint _videoGameId) public view returns(address) {
471     }
472     
473 }