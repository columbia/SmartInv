1 pragma solidity ^0.4.18;
2 
3 /// Pizzas :3
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
21 }
22 
23 /// Modified from the CryptoCelebrities contract And EmojiBlockhain and 50shadesETH
24 contract EtherPizza is ERC721 {
25 
26   /*** EVENTS ***/
27 
28   /// @dev The Birth event is fired whenever a new pizza comes into existence.
29   event Birth(uint256 tokenId, string name, address owner);
30 
31   /// @dev The TokenSold event is fired whenever a token is sold.
32   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
33 
34   /// @dev Transfer event as defined in current draft of ERC721.
35   ///  ownership is assigned, including births.
36   event Transfer(address from, address to, uint256 tokenId);
37 
38   /*** CONSTANTS ***/
39   uint256 private startingPrice = 0.001 ether;
40 
41   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
42   string public constant NAME = "CrypoPizzas"; // solhint-disable-line
43   string public constant SYMBOL = "CryptoPizza"; // solhint-disable-line
44 
45   /*** STORAGE ***/
46 
47   /// @dev A mapping from pizza IDs to the address that owns them. All pizzas have
48   ///  some valid owner address.
49   mapping (uint256 => address) public pizzaIndexToOwner;
50 
51   // @dev A mapping from owner address to count of tokens that address owns.
52   //  Used internally inside balanceOf() to resolve ownership count.
53   mapping (address => uint256) private ownershipTokenCount;
54 
55   /// @dev A mapping from PizzaIDs to an address that has been approved to call
56   ///  transferFrom(). Each Pizza can only have one approved address for transfer
57   ///  at any time. A zero value means no approval is outstanding.
58   mapping (uint256 => address) public pizzaIndexToApproved;
59 
60   // @dev A mapping from PizzaIDs to the price of the token.
61   mapping (uint256 => uint256) private pizzaIndexToPrice;
62 
63   /// @dev A mapping from PizzaIDs to the previpus price of the token. Used
64   /// to calculate price delta for payouts
65   mapping (uint256 => uint256) private pizzaIndexToPreviousPrice;
66 
67   // @dev A mapping from pizzaId to the 7 last owners.
68   mapping (uint256 => address[5]) private pizzaIndexToPreviousOwners;
69 
70 
71   // The addresses of the accounts (or contracts) that can execute actions within each roles.
72   address public ceoAddress;
73   address public cooAddress;
74 
75   /*** DATATYPES ***/
76   struct Pizza {
77     string name;
78   }
79 
80   Pizza[] private pizzas;
81 
82   /*** ACCESS MODIFIERS ***/
83   /// @dev Access modifier for CEO-only functionality
84   modifier onlyCEO() {
85     require(msg.sender == ceoAddress);
86     _;
87   }
88 
89   /// @dev Access modifier for COO-only functionality
90   modifier onlyCOO() {
91     require(msg.sender == cooAddress);
92     _;
93   }
94 
95   /// Access modifier for contract owner only functionality
96   modifier onlyCLevel() {
97     require(
98       msg.sender == ceoAddress ||
99       msg.sender == cooAddress
100     );
101     _;
102   }
103 
104   /*** CONSTRUCTOR ***/
105   function EtherPizza() public {
106     ceoAddress = msg.sender;
107     cooAddress = msg.sender;
108   }
109 
110   /*** PUBLIC FUNCTIONS ***/
111   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
112   /// @param _to The address to be granted transfer approval. Pass address(0) to
113   ///  clear all approvals.
114   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
115   /// @dev Required for ERC-721 compliance.
116   function approve(
117     address _to,
118     uint256 _tokenId
119   ) public {
120     // Caller must own token.
121     require(_owns(msg.sender, _tokenId));
122 
123     pizzaIndexToApproved[_tokenId] = _to;
124 
125     Approval(msg.sender, _to, _tokenId);
126   }
127 
128   /// For querying balance of a particular account
129   /// @param _owner The address for balance query
130   /// @dev Required for ERC-721 compliance.
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return ownershipTokenCount[_owner];
133   }
134 
135   /// @dev Creates a new Pizza with the given name.
136   function createContractPizza(string _name) public onlyCOO {
137     _createPizza(_name, address(this), startingPrice);
138   }
139 
140   /// @notice Returns all the relevant information about a specific pizza.
141   /// @param _tokenId The tokenId of the pizza of interest.
142   function getPizza(uint256 _tokenId) public view returns (
143     string pizzaName,
144     uint256 sellingPrice,
145     address owner,
146     uint256 previousPrice,
147     address[5] previousOwners
148   ) {
149     Pizza storage pizza = pizzas[_tokenId];
150     pizzaName = pizza.name;
151     sellingPrice = pizzaIndexToPrice[_tokenId];
152     owner = pizzaIndexToOwner[_tokenId];
153     previousPrice = pizzaIndexToPreviousPrice[_tokenId];
154     previousOwners = pizzaIndexToPreviousOwners[_tokenId];
155   }
156 
157   function implementsERC721() public pure returns (bool) {
158     return true;
159   }
160 
161   /// @dev Required for ERC-721 compliance.
162   function name() public pure returns (string) {
163     return NAME;
164   }
165 
166   /// For querying owner of token
167   /// @param _tokenId The tokenID for owner inquiry
168   /// @dev Required for ERC-721 compliance.
169   function ownerOf(uint256 _tokenId)
170     public
171     view
172     returns (address owner)
173   {
174     owner = pizzaIndexToOwner[_tokenId];
175     require(owner != address(0));
176   }
177 
178   function payout(address _to) public onlyCLevel {
179     _payout(_to);
180   }
181 
182   // Allows someone to send ether and obtain the token
183   function purchase(uint256 _tokenId) public payable {
184     address oldOwner = pizzaIndexToOwner[_tokenId];
185     address newOwner = msg.sender;
186 
187     address[5] storage previousOwners = pizzaIndexToPreviousOwners[_tokenId];
188 
189     uint256 sellingPrice = pizzaIndexToPrice[_tokenId];
190     uint256 previousPrice = pizzaIndexToPreviousPrice[_tokenId];
191     // Making sure token owner is not sending to self
192     require(oldOwner != newOwner);
193 
194     // Safety check to prevent against an unexpected 0x0 default.
195     require(_addressNotNull(newOwner));
196 
197     // Making sure sent amount is greater than or equal to the sellingPrice
198     require(msg.value >= sellingPrice);
199 
200     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
201     uint256 ownerPayout = SafeMath.add(previousPrice, SafeMath.mul(SafeMath.div(priceDelta, 100), 40));
202 
203 
204     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
205 
206     pizzaIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
207     pizzaIndexToPreviousPrice[_tokenId] = sellingPrice;
208 
209     uint256 strangePrice = uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10));
210 
211 
212     // Pay previous tokenOwner if owner is not contract
213     // and if previous price is not 0
214     if (oldOwner != address(this)) {
215       // old owner gets entire initial payment back
216       oldOwner.transfer(ownerPayout);
217     } else {
218       strangePrice = SafeMath.add(ownerPayout, strangePrice);
219     }
220 
221     // Next distribute payout Total among previous Owners
222     for (uint i = 0; i < 5; i++) {
223         if (previousOwners[i] != address(this)) {
224             previousOwners[i].transfer(uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10)));
225         } else {
226             strangePrice = SafeMath.add(strangePrice, uint256(SafeMath.mul(SafeMath.div(priceDelta, 100), 10)));
227         }
228     }
229     ceoAddress.transfer(strangePrice);
230 
231     _transfer(oldOwner, newOwner, _tokenId);
232 
233     //TokenSold(_tokenId, sellingPrice, pizzaIndexToPrice[_tokenId], oldOwner, newOwner, pizzas[_tokenId].name);
234 
235     msg.sender.transfer(purchaseExcess);
236   }
237 
238 
239 
240 
241 
242 
243   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
244     return pizzaIndexToPrice[_tokenId];
245   }
246 
247   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
248   /// @param _newCEO The address of the new CEO
249   function setCEO(address _newCEO) public onlyCEO {
250     require(_newCEO != address(0));
251 
252     ceoAddress = _newCEO;
253   }
254 
255   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
256   /// @param _newCOO The address of the new COO
257   function setCOO(address _newCOO) public onlyCEO {
258     require(_newCOO != address(0));
259     cooAddress = _newCOO;
260   }
261 
262   /// @dev Required for ERC-721 compliance.
263   function symbol() public pure returns (string) {
264     return SYMBOL;
265   }
266 
267   /// @notice Allow pre-approved user to take ownership of a token
268   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
269   /// @dev Required for ERC-721 compliance.
270   function takeOwnership(uint256 _tokenId) public {
271     address newOwner = msg.sender;
272     address oldOwner = pizzaIndexToOwner[_tokenId];
273 
274     // Safety check to prevent against an unexpected 0x0 default.
275     require(_addressNotNull(newOwner));
276 
277     // Making sure transfer is approved
278     require(_approved(newOwner, _tokenId));
279 
280     _transfer(oldOwner, newOwner, _tokenId);
281   }
282 
283   /// @param _owner The owner whose pizza tokens we are interested in.
284   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
285   ///  expensive (it walks the entire Pizzas array looking for pizzas belonging to owner),
286   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
287   ///  not contract-to-contract calls.
288   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
289     uint256 tokenCount = balanceOf(_owner);
290     if (tokenCount == 0) {
291         // Return an empty array
292       return new uint256[](0);
293     } else {
294       uint256[] memory result = new uint256[](tokenCount);
295       uint256 totalPizzas = totalSupply();
296       uint256 resultIndex = 0;
297       uint256 pizzaId;
298       for (pizzaId = 0; pizzaId <= totalPizzas; pizzaId++) {
299         if (pizzaIndexToOwner[pizzaId] == _owner) {
300           result[resultIndex] = pizzaId;
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
311     return pizzas.length;
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
324     _transfer(msg.sender, _to, _tokenId);
325   }
326 
327   /// Third-party initiates transfer of token from address _from to address _to
328   /// @param _from The address for the token to be transferred from.
329   /// @param _to The address for the token to be transferred to.
330   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
331   /// @dev Required for ERC-721 compliance.
332   function transferFrom(
333     address _from,
334     address _to,
335     uint256 _tokenId
336   ) public {
337     require(_owns(_from, _tokenId));
338     require(_approved(_to, _tokenId));
339     require(_addressNotNull(_to));
340     _transfer(_from, _to, _tokenId);
341   }
342 
343   /*** PRIVATE FUNCTIONS ***/
344   /// Safety check on _to address to prevent against an unexpected 0x0 default.
345   function _addressNotNull(address _to) private pure returns (bool) {
346     return _to != address(0);
347   }
348 
349   /// For checking approval of transfer for address _to
350   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
351     return pizzaIndexToApproved[_tokenId] == _to;
352   }
353 
354   /// For creating Pizza
355   function _createPizza(string _name, address _owner, uint256 _price) private {
356     Pizza memory _pizza = Pizza({
357       name: _name
358     });
359     uint256 newPizzaId = pizzas.push(_pizza) - 1;
360 
361     // It's probably never going to happen, 4 billion tokens are A LOT, but
362     // let's just be 100% sure we never let this happen.
363     require(newPizzaId == uint256(uint32(newPizzaId)));
364 
365     Birth(newPizzaId, _name, _owner);
366 
367     pizzaIndexToPrice[newPizzaId] = _price;
368     pizzaIndexToPreviousPrice[newPizzaId] = 0;
369     pizzaIndexToPreviousOwners[newPizzaId] =
370         [address(this), address(this), address(this), address(this)];
371 
372     // This will assign ownership, and also emit the Transfer event as
373     // per ERC721 draft
374     _transfer(address(0), _owner, newPizzaId);
375   }
376 
377   /// Check for token ownership
378   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
379     return claimant == pizzaIndexToOwner[_tokenId];
380   }
381 
382   /// For paying out balance on contract
383   function _payout(address _to) private {
384     if (_to == address(0)) {
385       ceoAddress.transfer(this.balance);
386     } else {
387       _to.transfer(this.balance);
388     }
389   }
390 
391   /// @dev Assigns ownership of a specific Pizza to an address.
392   function _transfer(address _from, address _to, uint256 _tokenId) private {
393     // Since the number of pizzas is capped to 2^32 we can't overflow this
394     ownershipTokenCount[_to]++;
395     //transfer ownership
396     pizzaIndexToOwner[_tokenId] = _to;
397     // When creating new pizzas _from is 0x0, but we can't account that address.
398     if (_from != address(0)) {
399       ownershipTokenCount[_from]--;
400       // clear any previously approved ownership exchange
401       delete pizzaIndexToApproved[_tokenId];
402     }
403     // Update the pizzaIndexToPreviousOwners
404     pizzaIndexToPreviousOwners[_tokenId][4]=pizzaIndexToPreviousOwners[_tokenId][3];
405     pizzaIndexToPreviousOwners[_tokenId][3]=pizzaIndexToPreviousOwners[_tokenId][2];
406     pizzaIndexToPreviousOwners[_tokenId][2]=pizzaIndexToPreviousOwners[_tokenId][1];
407     pizzaIndexToPreviousOwners[_tokenId][1]=pizzaIndexToPreviousOwners[_tokenId][0];
408     // the _from address for creation is 0, so instead set it to the contract address
409     if (_from != address(0)) {
410         pizzaIndexToPreviousOwners[_tokenId][0]=_from;
411     } else {
412         pizzaIndexToPreviousOwners[_tokenId][0]=address(this);
413     }
414     // Emit the transfer event.
415     Transfer(_from, _to, _tokenId);
416   }
417 }
418 
419 
420 library SafeMath {
421 
422   /**
423   * @dev Multiplies two numbers, throws on overflow.
424   */
425   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
426     if (a == 0) {
427       return 0;
428     }
429     uint256 c = a * b;
430     assert(c / a == b);
431     return c;
432   }
433 
434   /**
435   * @dev Integer division of two numbers, truncating the quotient.
436   */
437   function div(uint256 a, uint256 b) internal pure returns (uint256) {
438     // assert(b > 0); // Solidity automatically throws when dividing by 0
439     uint256 c = a / b;
440     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
441     return c;
442   }
443 
444   /**
445   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
446   */
447   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
448     assert(b <= a);
449     return a - b;
450   }
451 
452   /**
453   * @dev Adds two numbers, throws on overflow.
454   */
455   function add(uint256 a, uint256 b) internal pure returns (uint256) {
456     uint256 c = a + b;
457     assert(c >= a);
458     return c;
459   }
460 }