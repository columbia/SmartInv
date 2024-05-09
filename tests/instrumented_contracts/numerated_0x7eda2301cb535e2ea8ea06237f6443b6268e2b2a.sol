1 //EA 0x7EDA2301cb535e2EA8ea06237f6443b6268e2b2A  ETH Main net
2 
3 
4 pragma solidity ^0.4.25; // solhint-disable-line
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public view returns (bool);
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
27 
28 //********************************************************************
29 
30 
31 contract CharToken is ERC721 {
32   /*** EVENTS ***/
33   /// @dev The Birth event is fired whenever a new char comes into existence.
34   event Birth(uint256 tokenId, string wikiID_Name, address owner);
35   /// @dev The TokenSold event is fired whenever a token is sold.
36   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, string wikiID_Name);
37   /// @dev Transfer event as defined in current draft of ERC721.
38   ///  ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40   /// @dev Emitted when a bug is found int the contract and the contract is upgraded at a new address.
41   /// In the event this happens, the current contract is paused indefinitely
42   event ContractUpgrade(address newContract);
43   ///bonus issuance    
44   event Bonus(address to, uint256 bonus);
45 
46   /*** CONSTANTS ***/
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "CryptoChars"; // solhint-disable-line
49   string public constant SYMBOL = "CHARS"; // solhint-disable-line
50   bool private erc721Enabled = false;
51   uint256 private startingPrice = 0.005 ether;
52   uint256 private constant PROMO_CREATION_LIMIT = 50000;
53   uint256 private firstStepLimit =  0.05 ether;
54   uint256 private secondStepLimit = 0.20 ether;
55   uint256 private thirdStepLimit = 0.5 ether;
56 
57   /*** STORAGE ***/
58   /// @dev A mapping from char IDs to the address that owns them. All chars have
59   ///  some valid owner address.
60   mapping (uint256 => address) public charIndexToOwner;
61  // @dev A mapping from owner address to count of tokens that address owns.
62   //  Used internally inside balanceOf() to resolve ownership count.
63   mapping (address => uint256) private ownershipTokenCount;
64   /// @dev A mapping from CharIDs to an address that has been approved to call
65   ///  transferFrom(). Each Char can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public charIndexToApproved;
68   // @dev A mapping from CharIDs to the price of the token.
69   mapping (uint256 => uint256) private charIndexToPrice;
70   // @dev A mapping from owner address to its total number of transactions
71   mapping (address => uint256) private addressToTrxCount;
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75   address public cfoAddress;
76   uint256 public promoCreatedCount;
77   //***pack below into a struct for gas optimization    
78   //promo per each N trx is effective until date, and its frequency (every nth buy)
79   uint256 public bonusUntilDate;   
80   uint256 bonusFrequency;
81   /*** DATATYPES ***/
82   struct Char {
83     //name of the char
84     //string name;
85     //wiki pageid of char
86     string wikiID_Name; //save gas
87   }
88   Char[] private chars; 
89 
90   /*** ACCESS MODIFIERS ***/
91   /// @dev Access modifier for CEO-only functionality
92   modifier onlyCEO() {
93     require(msg.sender == ceoAddress);
94     _;
95   }
96   /// @dev Access modifier for COO-only functionality
97   modifier onlyCOO() {
98     require(msg.sender == cooAddress);
99     _;
100   }
101   /// @dev Access modifier for CFO-only functionality
102   modifier onlyCFO() {
103     require(msg.sender == cfoAddress);
104     _;
105   }
106   modifier onlyERC721() {
107     require(erc721Enabled);
108     _;
109   }
110   /// Access modifier for contract owner only functionality
111   modifier onlyCLevel() {
112     require(
113       msg.sender == ceoAddress ||
114       msg.sender == cooAddress ||
115       msg.sender == cfoAddress 
116     );
117     _;
118   }
119   /*** CONSTRUCTOR ***/
120   constructor() public {
121     ceoAddress = msg.sender;
122     cooAddress = msg.sender;
123     cfoAddress = msg.sender;
124     bonusUntilDate = now; //Bonus after Nth buy is valid until this date
125     bonusFrequency = 3; //Bonus distributed after every Nth buy
126     
127     //create genesis chars
128     createContractChar("42268616_Captain Ahab",0);
129     createContractChar("455401_Frankenstein",0);
130     createContractChar("8670724_Dracula",0);
131     createContractChar("27159_Sherlock Holmes",0);
132     createContractChar("160108_Snow White",0);
133     createContractChar("73453_Cinderella",0);
134     createContractChar("14966133_Pinocchio",0);
135     createContractChar("369427_Lemuel Gulliver",0);
136     createContractChar("26171_Robin Hood",0);
137     createContractChar("197889_Felix the Cat",0);
138     createContractChar("382164_Wizard of Oz",0);
139     createContractChar("62446_Alice",0);
140     createContractChar("8237_Don Quixote",0);
141     createContractChar("16808_King Arthur",0);
142     createContractChar("194085_Sleeping Beauty",0);
143     createContractChar("299250_Little Red Riding Hood",0);
144     createContractChar("166604_Aladdin",0);
145     createContractChar("7640956_Peter Pan",0);
146     createContractChar("927344_Ali Baba",0);
147     createContractChar("153957_Lancelot",0);
148     createContractChar("235918_Dr._Jekyll_and_Mr._Hyde",0);
149     createContractChar("157787_Captain_Nemo",0);
150     createContractChar("933085_Moby_Dick",0);
151     createContractChar("54246379_Dorian_Gray",0);
152     createContractChar("55483_Robinson_Crusoe",0);
153     createContractChar("380143_Black_Beauty",0);
154     createContractChar("6364074_Phantom_of_the_Opera",0); 
155     createContractChar("15055_Ivanhoe",0);
156     createContractChar("21491685_Tarzan",0);
157     /* */    
158   }
159 
160   /*** PUBLIC FUNCTIONS ***/
161   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
162   /// @param _to The address to be granted transfer approval. Pass address(0) to
163   ///  clear all approvals.
164   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
165   /// @dev Required for ERC-721 compliance.
166   function approve(
167     address _to,
168     uint256 _tokenId
169   ) public onlyERC721 {
170     // Caller must own token.
171     require(_owns(msg.sender, _tokenId));
172 
173     charIndexToApproved[_tokenId] = _to;
174 
175     emit Approval(msg.sender, _to, _tokenId);
176   }
177 
178   /// For querying balance of a particular account
179   /// @param _owner The address for balance query
180   /// @dev Required for ERC-721 compliance.
181   function balanceOf(address _owner) public view returns (uint256 balance) {
182     return ownershipTokenCount[_owner];
183   }
184 
185 
186   /// @dev Creates a new Char with the given name
187   function createContractChar(string _wikiID_Name, uint256 _price) public onlyCLevel {
188     require(promoCreatedCount < PROMO_CREATION_LIMIT);
189     if (_price <= 0) {
190       _price = startingPrice;
191     }
192     promoCreatedCount++;
193     _createChar(_wikiID_Name, address(this), _price);
194   }
195   /// @notice Returns all the relevant information about a specific char.
196   /// @param _tokenId The tokenId of the char of interest.
197   function getChar(uint256 _tokenId) public view returns (
198     string wikiID_Name,
199     uint256 sellingPrice,
200     address owner
201   ) {
202     Char storage char = chars[_tokenId];
203     wikiID_Name = char.wikiID_Name;
204     sellingPrice = charIndexToPrice[_tokenId];
205     owner = charIndexToOwner[_tokenId];
206   }
207   function changeWikiID_Name(uint256 _tokenId, string _wikiID_Name) public onlyCLevel {
208     require(_tokenId < chars.length);
209     chars[_tokenId].wikiID_Name = _wikiID_Name;
210   }
211   function changeBonusUntilDate(uint32 _days) public onlyCLevel {
212        bonusUntilDate = now + (_days * 1 days);
213   }
214   function changeBonusFrequency(uint32 _n) public onlyCLevel {
215        bonusFrequency = _n;
216   }
217   function overrideCharPrice(uint256 _tokenId, uint256 _price) public onlyCLevel {
218     require(_price != charIndexToPrice[_tokenId]);
219     require(_tokenId < chars.length);
220     //C level can override price for only own and contract tokens
221     require((_owns(address(this), _tokenId)) || (  _owns(msg.sender, _tokenId)) ); 
222     charIndexToPrice[_tokenId] = _price;
223   }
224   function changeCharPrice(uint256 _tokenId, uint256 _price) public {
225     require(_owns(msg.sender, _tokenId));
226     require(_tokenId < chars.length);
227     require(_price != charIndexToPrice[_tokenId]);
228     //require(_price > charIndexToPrice[_tokenId]);  //EA>should we enforce this?
229     uint256 maxPrice = SafeMath.div(SafeMath.mul(charIndexToPrice[_tokenId], 1000),100); //10x 
230     uint256 minPrice = SafeMath.div(SafeMath.mul(charIndexToPrice[_tokenId], 50),100); //half price
231     require(_price >= minPrice); 
232     require(_price <= maxPrice); 
233     charIndexToPrice[_tokenId] = _price; 
234   }
235   /* ERC721 */
236   function implementsERC721() public view returns (bool _implements) {
237     return erc721Enabled;
238   }
239   /// @dev Required for ERC-721 compliance.
240   function name() public pure returns (string) {
241     return NAME;
242   }
243   /// @dev Required for ERC-721 compliance.
244   function symbol() public pure returns (string) {
245     return SYMBOL;
246   }
247   /// For querying owner of token
248   /// @param _tokenId The tokenID for owner inquiry
249   /// @dev Required for ERC-721 compliance.
250   function ownerOf(uint256 _tokenId)
251     public
252     view
253     returns (address owner)
254   {
255     owner = charIndexToOwner[_tokenId];
256     require(owner != address(0));
257   }
258 //  function payout(address _to) public onlyCLevel {
259 //    _payout(_to);
260 //  }
261   function withdrawFunds(address _to, uint256 amount) public onlyCLevel {
262     _withdrawFunds(_to, amount);
263   }
264   // Allows someone to send ether and obtain the token
265   function purchase(uint256 _tokenId, uint256 newPrice) public payable {
266     address oldOwner = charIndexToOwner[_tokenId];
267     address newOwner = msg.sender;
268     uint256 sellingPrice = charIndexToPrice[_tokenId];
269     // Making sure token owner is not sending to self
270     require(oldOwner != newOwner);
271     // Safety check to prevent against an unexpected 0x0 default.
272     require(_addressNotNull(newOwner));
273     // Making sure sent amount is greater than or equal to the sellingPrice
274     require(msg.value >= sellingPrice);
275     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
276     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
277     // Update prices
278     if (newPrice >= sellingPrice) charIndexToPrice[_tokenId] = newPrice;
279     else {
280             if (sellingPrice < firstStepLimit) {
281               // first stage
282               charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
283             } else if (sellingPrice < secondStepLimit) {
284               // second stage
285               charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
286             } else if (sellingPrice < thirdStepLimit) {
287               // second stage
288               charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
289             } else {
290               // third stage
291               charIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 100);
292             }
293     }
294     _transfer(oldOwner, newOwner, _tokenId);
295     // Pay previous tokenOwner if owner is not contract
296     if (oldOwner != address(this)) {
297       oldOwner.transfer(payment); //(1-0.06)
298     }
299     emit TokenSold(_tokenId, sellingPrice, charIndexToPrice[_tokenId], oldOwner, newOwner,
300       chars[_tokenId].wikiID_Name);
301     msg.sender.transfer(purchaseExcess);
302     //distribute bonus if earned and promo is ongoing and every nth buy trx
303       if( (now < bonusUntilDate && (addressToTrxCount[newOwner] % bonusFrequency) == 0) ) 
304       {
305           //bonus operation here
306           uint rand = uint (keccak256(now)) % 50 ; //***earn up to 50% of 6% commissions
307           rand = rand * (sellingPrice-payment);  //***replace later. this is for test
308           _withdrawFunds(newOwner,rand);
309           emit Bonus(newOwner,rand);
310       }
311   }
312   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
313     return charIndexToPrice[_tokenId];
314   }
315   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
316   function enableERC721() public onlyCEO {
317     erc721Enabled = true;
318   }
319   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
320   /// @param _newCEO The address of the new CEO
321   function setCEO(address _newCEO) public onlyCEO {
322     require(_newCEO != address(0));
323     ceoAddress = _newCEO;
324   }
325   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
326   /// @param _newCOO The address of the new COO
327   function setCOO(address _newCOO) public onlyCOO {
328     require(_newCOO != address(0));
329     cooAddress = _newCOO;
330   }
331 /// @dev Assigns a new address to act as the CFO. Only available to the current CFO.
332   /// @param _newCFO The address of the new CFO
333   function setCFO(address _newCFO) public onlyCFO {
334     require(_newCFO != address(0));
335     cfoAddress = _newCFO;
336   }
337   
338   
339   /// @notice Allow pre-approved user to take ownership of a token
340   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
341   /// @dev Required for ERC-721 compliance.
342   function takeOwnership(uint256 _tokenId) public {
343     address newOwner = msg.sender;
344     address oldOwner = charIndexToOwner[_tokenId];
345      // Safety check to prevent against an unexpected 0x0 default.
346     require(_addressNotNull(newOwner));
347     // Making sure transfer is approved
348     require(_approved(newOwner, _tokenId));
349     _transfer(oldOwner, newOwner, _tokenId);
350   }
351   /// @param _owner The owner whose char tokens we are interested in.
352   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
353   ///  expensive (it walks the entire Chars array looking for chars belonging to owner),
354   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
355   ///  not contract-to-contract calls.
356   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
357     uint256 tokenCount = balanceOf(_owner);
358     if (tokenCount == 0) {
359         // Return an empty array
360       return new uint256[](0);
361     } else {
362       uint256[] memory result = new uint256[](tokenCount);
363       uint256 totalChars = chars.length;
364       uint256 resultIndex = 0;
365       uint256 t;
366       for (t = 0; t <= totalChars; t++) {
367         if (charIndexToOwner[t] == _owner) {
368           result[resultIndex] = t;
369           resultIndex++;
370         }
371       }
372       return result;
373     }
374   }
375   /// For querying totalSupply of token
376   /// @dev Required for ERC-721 compliance.
377   function totalSupply() public view returns (uint256 total) {
378     return chars.length;
379   }
380   /// Owner initates the transfer of the token to another account
381   /// @param _to The address for the token to be transferred to.
382   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
383   /// @dev Required for ERC-721 compliance.
384   function transfer(
385     address _to,
386     uint256 _tokenId
387   ) public onlyERC721 {
388     require(_owns(msg.sender, _tokenId));
389     require(_addressNotNull(_to));
390     _transfer(msg.sender, _to, _tokenId);
391   }
392   /// Third-party initiates transfer of token from address _from to address _to
393   /// @param _from The address for the token to be transferred from.
394   /// @param _to The address for the token to be transferred to.
395   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
396   /// @dev Required for ERC-721 compliance.
397   function transferFrom(
398     address _from,
399     address _to,
400     uint256 _tokenId
401   ) public onlyERC721 {
402     require(_owns(_from, _tokenId));
403     require(_approved(_to, _tokenId));
404     require(_addressNotNull(_to));
405     _transfer(_from, _to, _tokenId);
406   }
407   /*** PRIVATE FUNCTIONS ***/
408   /// Safety check on _to address to prevent against an unexpected 0x0 default.
409   function _addressNotNull(address _to) private pure returns (bool) {
410     return _to != address(0);
411   }
412   /// For checking approval of transfer for address _to
413   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
414     return charIndexToApproved[_tokenId] == _to;
415   }
416   /// For creating Char
417   function _createChar(string _wikiID_Name, address _owner, uint256 _price) private {
418     Char memory _char = Char({
419       wikiID_Name: _wikiID_Name
420     });
421     uint256 newCharId = chars.push(_char) - 1;
422     // It's probably never going to happen, 4 billion tokens are A LOT, but
423     // let's just be 100% sure we never let this happen.
424     require(newCharId == uint256(uint32(newCharId)));
425     emit Birth(newCharId, _wikiID_Name, _owner);
426     charIndexToPrice[newCharId] = _price;
427     // This will assign ownership, and also emit the Transfer event as
428     // per ERC721 draft
429     _transfer(address(0), _owner, newCharId);
430   }
431   /// Check for token ownership
432   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
433     return claimant == charIndexToOwner[_tokenId];
434   }
435   /// For paying out balance on contract
436 //  function _payout(address _to) private {
437 //    if (_to == address(0)) {
438 //      ceoAddress.transfer(address(this).balance);
439 //    } else {
440 //      _to.transfer(address(this).balance);
441 //    }
442 //  }
443  function _withdrawFunds(address _to, uint256 amount) private {
444     require(address(this).balance >= amount);
445     if (_to == address(0)) {
446       ceoAddress.transfer(amount);
447     } else {
448       _to.transfer(amount);
449     }
450   }
451   /// @dev Assigns ownership of a specific Char to an address.
452   function _transfer(address _from, address _to, uint256 _tokenId) private {
453     // Since the number of chars is capped to 2^32 we can't overflow this
454     ownershipTokenCount[_to]++;
455     //transfer ownership
456     charIndexToOwner[_tokenId] = _to;
457     // When creating new chars _from is 0x0, but we can't account that address.
458     if (_from != address(0)) {
459       ownershipTokenCount[_from]--;
460       // clear any previously approved ownership exchange
461       delete charIndexToApproved[_tokenId];
462     }
463     // Emit the transfer event.
464     emit Transfer(_from, _to, _tokenId);
465   //update trx count  
466   addressToTrxCount[_to]++;
467   }
468 }
469 
470 library SafeMath {
471   /**
472   * @dev Multiplies two numbers, throws on overflow.
473   */
474   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
475     if (a == 0) {
476       return 0;
477     }
478     uint256 c = a * b;
479     assert(c / a == b);
480     return c;
481   }
482   /**
483   * @dev Integer division of two numbers, truncating the quotient.
484   */
485   function div(uint256 a, uint256 b) internal pure returns (uint256) {
486     // assert(b > 0); // Solidity automatically throws when dividing by 0
487     uint256 c = a / b;
488     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
489     return c;
490   }
491   /**
492   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
493   */
494   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495     assert(b <= a);
496     return a - b;
497   }
498   /**
499   * @dev Adds two numbers, throws on overflow.
500   */
501   function add(uint256 a, uint256 b) internal pure returns (uint256) {
502     uint256 c = a + b;
503     assert(c >= a);
504     return c;
505   }
506 }