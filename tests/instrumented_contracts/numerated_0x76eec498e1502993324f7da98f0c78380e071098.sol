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
18 }
19 
20 
21 contract MemeToken is ERC721 {
22   /*** EVENTS ***/
23   /// @dev The Birth event is fired whenever a new meme comes into existence.
24   event Birth(uint256 tokenId, uint256 metadata, string text, address owner);
25 
26   /// @dev The TokenSold event is fired whenever a meme is sold.
27   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, uint256 metadata, string text);
28 
29   /// @dev Transfer event as defined in current draft of ERC721. 
30   ///  ownership is assigned, including births.
31   event Transfer(address from, address to, uint256 tokenId);
32 
33   /*** CONSTANTS ***/
34   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
35   string public constant NAME = "CryptoMemes"; // solhint-disable-line
36   string public constant SYMBOL = "CM"; // solhint-disable-line
37 
38   uint256 private startingPrice = 0.001 ether;
39   uint256 private constant PROMO_CREATION_LIMIT = 50000;
40   uint256 private firstStepLimit =  0.05 ether;
41   uint256 private secondStepLimit = 0.5 ether;
42 
43   /*** STORAGE ***/
44   /// @dev A mapping from meme IDs to the address that owns them. All memes have
45   ///  some valid owner address.
46   mapping (uint256 => address) public memeIndexToOwner;
47 
48   // @dev A mapping from owner address to count of tokens that address owns.
49   //  Used internally inside balanceOf() to resolve ownership count.
50   mapping (address => uint256) private ownershipTokenCount;
51 
52   /// @dev A mapping from memeIDs to an address that has been approved to call
53   ///  transferFrom(). Each meme can only have one approved address for transfer
54   ///  at any time. A zero value means no approval is outstanding.
55   mapping (uint256 => address) public memeIndexToApproved;
56 
57   // @dev A mapping from memeIDs to the price of the token.
58   mapping (uint256 => uint256) private memeIndexToPrice;
59 
60   // The address of the account that can execute special actions.
61   // Not related to Dogecoin, just a normal Doge.
62   address public dogeAddress;
63   // Robot9000 address for automation.
64   // Not related to r9k, just a normal robot.
65   address public r9kAddress;
66 
67   uint256 public promoCreatedCount;
68 
69   /*** DATATYPES ***/
70   struct Meme {
71     uint256 metadata;
72     string text;
73   }
74 
75   // All your memes are belong to us.
76   Meme[] private memes;
77 
78   /*** ACCESS MODIFIERS ***/
79   /// @dev Access modifier for Doge functionality
80   modifier onlyDoge() {
81     require(msg.sender == dogeAddress);
82     _;
83   }
84 
85   /// @dev Access modifier for Robot functionality
86   modifier onlyr9k() {
87     require(msg.sender == r9kAddress);
88     _;
89   }
90 
91   /// @dev Access modifier for Doge and Robot functionality
92   modifier onlyDogeAndr9k() {
93     require(
94       msg.sender == dogeAddress ||
95       msg.sender == r9kAddress
96     );
97     _;
98   }
99 
100   /*** CONSTRUCTOR ***/
101   function MemeToken() public {
102     dogeAddress = msg.sender;
103     r9kAddress = msg.sender;
104   }
105 
106   /*** PUBLIC FUNCTIONS ***/
107   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
108   /// @param _to The address to be granted transfer approval. Pass address(0) to
109   ///  clear all approvals.
110   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
111   /// @dev Required for ERC-721 compliance.
112   function approve(
113     address _to,
114     uint256 _tokenId
115   ) public
116   {
117     // Caller must own token.
118     require(_owns(msg.sender, _tokenId));
119 
120     memeIndexToApproved[_tokenId] = _to;
121 
122     Approval(msg.sender, _to, _tokenId);
123   }
124 
125   /// For querying balance of a particular account
126   /// @param _owner The address for balance query
127   /// @dev Required for ERC-721 compliance.
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return ownershipTokenCount[_owner];
130   }
131 
132   /// @dev Creates a new promo meme with the given metadata and text, with given _price and
133   ///  assignes it to an address.
134   function createPromoMeme(address _owner, uint256 _metadata, string _text, uint256 _price) public onlyDogeAndr9k {
135     require(promoCreatedCount < PROMO_CREATION_LIMIT);
136 
137     address memeOwner = _owner;
138     if (memeOwner == address(0)) {
139       memeOwner = dogeAddress;
140     }
141 
142     if (_price <= 0) {
143       _price = startingPrice;
144     }
145 
146     promoCreatedCount++;
147     _createMeme(_metadata, _text, memeOwner, _price);
148   }
149 
150   /// @dev Creates a new user-generated meme with the given metadata and text, with given _price and
151   ///  assignes it to an address.
152   function createUserMeme(address _owner, uint256 _metadata, string _text, uint256 _price) public onlyDogeAndr9k {
153     address memeOwner = _owner;
154     if (memeOwner == address(0)) {
155       memeOwner = dogeAddress;
156     }
157 
158     if (_price <= 0) {
159       _price = startingPrice;
160     }
161 
162     _createMeme(_metadata, _text, memeOwner, _price);
163   }
164 
165   /// @dev Creates a new meme with the given name.
166   function createContractMeme(uint256 _metadata, string _text) public onlyDogeAndr9k {
167     _createMeme(_metadata, _text, address(this), startingPrice);
168   }
169 
170   /// @notice Returns all the relevant information about a specific meme.
171   /// @param _tokenId The tokenId of the meme of interest.
172   function getMeme(uint256 _tokenId) public view returns (
173     uint256 metadata,
174     string text,
175     uint256 sellingPrice,
176     address owner
177   ) {
178     Meme storage meme = memes[_tokenId];
179     metadata = meme.metadata;
180     text = meme.text;
181     sellingPrice = memeIndexToPrice[_tokenId];
182     owner = memeIndexToOwner[_tokenId];
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
202     owner = memeIndexToOwner[_tokenId];
203     require(owner != address(0));
204   }
205 
206   function payout(address _to) public onlyDoge {
207     _payout(_to);
208   }
209 
210   // Allows someone to send ether and obtain the meme
211   function purchase(uint256 _tokenId) public payable {
212     address oldOwner = memeIndexToOwner[_tokenId];
213     address newOwner = msg.sender;
214 
215     uint256 sellingPrice = memeIndexToPrice[_tokenId];
216 
217     // Making sure meme owner is not sending to self
218     require(oldOwner != newOwner);
219 
220     // Safety check to prevent against an unexpected 0x0 default.
221     require(_addressNotNull(newOwner));
222 
223     // Making sure sent amount is greater than or equal to the sellingPrice
224     require(msg.value >= sellingPrice);
225 
226     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100));
227     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
228 
229     // Update prices
230     if (sellingPrice < firstStepLimit) {
231       // first stage
232       memeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
233     } else if (sellingPrice < secondStepLimit) {
234       // second stage
235       memeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
236     } else {
237       // third stage
238       memeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
239     }
240 
241     _transfer(oldOwner, newOwner, _tokenId);
242 
243     // Pay previous tokenOwner if owner is not contract
244     if (oldOwner != address(this)) {
245       oldOwner.transfer(payment); //(1 - 0.05)
246     }
247 
248     TokenSold(_tokenId, sellingPrice, memeIndexToPrice[_tokenId], oldOwner, newOwner, memes[_tokenId].metadata, memes[_tokenId].text);
249 
250     msg.sender.transfer(purchaseExcess);
251   }
252 
253   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
254     return memeIndexToPrice[_tokenId];
255   }
256 
257   /// @dev Assigns a new address to act as Doge. Only available to the current Doge.
258   /// @param _newDoge The address of the new Doge
259   function setDoge(address _newDoge) public onlyDoge {
260     require(_newDoge != address(0));
261 
262     dogeAddress = _newDoge;
263   }
264 
265   /// @dev Assigns a new address to act as Robot. Only available to the current Doge.
266   /// @param _newRobot The address of the new Robot
267   function setRobot(address _newRobot) public onlyDoge {
268     require(_newRobot != address(0));
269 
270     r9kAddress = _newRobot;
271   }
272 
273   /// @dev Required for ERC-721 compliance.
274   function symbol() public pure returns (string) {
275     return SYMBOL;
276   }
277 
278   /// @notice Allow pre-approved user to take ownership of a meme
279   /// @param _tokenId The ID of the meme that can be transferred if this call succeeds.
280   /// @dev Required for ERC-721 compliance.
281   function takeOwnership(uint256 _tokenId) public {
282     address newOwner = msg.sender;
283     address oldOwner = memeIndexToOwner[_tokenId];
284 
285     // Safety check to prevent against an unexpected 0x0 default.
286     require(_addressNotNull(newOwner));
287 
288     // Making sure transfer is approved
289     require(_approved(newOwner, _tokenId));
290 
291     _transfer(oldOwner, newOwner, _tokenId);
292   }
293 
294   /// @param _owner The owner whose meme tokens we are interested in.
295   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
296   ///  expensive (it walks the entire memes array looking for memes belonging to owner),
297   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
298   ///  not contract-to-contract calls.
299   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
300     uint256 tokenCount = balanceOf(_owner);
301     if (tokenCount == 0) {
302         // Return an empty array
303       return new uint256[](0);
304     } else {
305       uint256[] memory result = new uint256[](tokenCount);
306       uint256 memeCount = totalSupply();
307       uint256 resultIndex = 0;
308 
309       uint256 memeId;
310       for (memeId = 0; memeId <= memeCount; memeId++) {
311         if (memeIndexToOwner[memeId] == _owner) {
312           result[resultIndex] = memeId;
313           resultIndex++;
314         }
315       }
316       return result;
317     }
318   }
319 
320   /// For querying totalSupply of token
321   /// @dev Required for ERC-721 compliance.
322   function totalSupply() public view returns (uint256 total) {
323     return memes.length;
324   }
325 
326   /// Owner initates the transfer of the meme to another account
327   /// @param _to The address for the meme to be transferred to.
328   /// @param _tokenId The ID of the meme that can be transferred if this call succeeds.
329   /// @dev Required for ERC-721 compliance.
330   function transfer(
331     address _to,
332     uint256 _tokenId
333   ) public
334   {
335     require(_owns(msg.sender, _tokenId));
336     require(_addressNotNull(_to));
337 
338     _transfer(msg.sender, _to, _tokenId);
339   }
340 
341   /// Third-party initiates transfer of token from address _from to address _to
342   /// @param _from The address for the token to be transferred from.
343   /// @param _to The address for the token to be transferred to.
344   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
345   /// @dev Required for ERC-721 compliance.
346   function transferFrom(
347     address _from,
348     address _to,
349     uint256 _tokenId
350   ) public
351   {
352     require(_owns(_from, _tokenId));
353     require(_approved(_to, _tokenId));
354     require(_addressNotNull(_to));
355 
356     _transfer(_from, _to, _tokenId);
357   }
358 
359   /*** PRIVATE FUNCTIONS ***/
360   /// Safety check on _to address to prevent against an unexpected 0x0 default.
361   function _addressNotNull(address _to) private pure returns (bool) {
362     return _to != address(0);
363   }
364 
365   /// For checking approval of transfer for address _to
366   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
367     return memeIndexToApproved[_tokenId] == _to;
368   }
369 
370   /// For creating a new meme
371   function _createMeme(uint256 _metadata, string _text, address _owner, uint256 _price) private {
372     Meme memory _meme = Meme({
373       metadata: _metadata,
374       text: _text
375     });
376     uint256 newMemeId = memes.push(_meme) - 1;
377 
378     // It's probably never going to happen, 2^64 memes are A LOT, but
379     // let's just be 100% sure we never let this happen.
380     require(newMemeId == uint256(uint64(newMemeId)));
381 
382     Birth(newMemeId, _metadata, _text, _owner);
383 
384     memeIndexToPrice[newMemeId] = _price;
385 
386     // This will assign ownership, and also emit the Transfer event as
387     // per ERC721 draft
388     _transfer(address(0), _owner, newMemeId);
389   }
390 
391   /// Check for token ownership
392   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
393     return claimant == memeIndexToOwner[_tokenId];
394   }
395 
396   /// For paying out balance on contract
397   function _payout(address _to) private {
398     if (_to == address(0)) {
399       dogeAddress.transfer(this.balance);
400     } else {
401       _to.transfer(this.balance);
402     }
403   }
404 
405   /// @dev Assigns ownership of a specific meme to an address.
406   function _transfer(address _from, address _to, uint256 _tokenId) private {
407     // Since the number of memes is capped to 2^32 we can't overflow this
408     ownershipTokenCount[_to]++;
409     //transfer ownership
410     memeIndexToOwner[_tokenId] = _to;
411 
412     // When creating new memes _from is 0x0, but we can't account that address.
413     if (_from != address(0)) {
414       ownershipTokenCount[_from]--;
415       // clear any previously approved ownership exchange
416       delete memeIndexToApproved[_tokenId];
417     }
418 
419     // Emit the transfer event.
420     Transfer(_from, _to, _tokenId);
421   }
422 }
423 library SafeMath {
424 
425   /**
426   * @dev Multiplies two numbers, throws on overflow.
427   */
428   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429     if (a == 0) {
430       return 0;
431     }
432     uint256 c = a * b;
433     assert(c / a == b);
434     return c;
435   }
436 
437   /**
438   * @dev Integer division of two numbers, truncating the quotient.
439   */
440   function div(uint256 a, uint256 b) internal pure returns (uint256) {
441     // assert(b > 0); // Solidity automatically throws when dividing by 0
442     uint256 c = a / b;
443     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
444     return c;
445   }
446 
447   /**
448   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
449   */
450   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451     assert(b <= a);
452     return a - b;
453   }
454 
455   /**
456   * @dev Adds two numbers, throws on overflow.
457   */
458   function add(uint256 a, uint256 b) internal pure returns (uint256) {
459     uint256 c = a + b;
460     assert(c >= a);
461     return c;
462   }
463 }