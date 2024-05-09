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
29 contract MemeToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new meme comes into existence.
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev The TokenSold event is fired whenever a token is sold.
37   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   /// @dev Transfer event as defined in current draft of ERC721. 
40   ///  ownership is assigned, including births.
41   event Transfer(address from, address to, uint256 tokenId);
42 
43   /*** CONSTANTS ***/
44 
45   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
46   string public constant NAME = "CryptoMemes"; // solhint-disable-line
47   string public constant SYMBOL = "MemeToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 5000;
51   uint256 private firstStepLimit =  0.053613 ether;
52   uint256 private secondStepLimit = 0.564957 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from meme IDs to the address that owns them. All memes have
57   ///  some valid owner address.
58   mapping (uint256 => address) public memeIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from MemeIDs to an address that has been approved to call
65   ///  transferFrom(). Each Meme can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public memeIndexToApproved;
68 
69   // @dev A mapping from MemeIDs to the price of the token.
70   mapping (uint256 => uint256) private memeIndexToPrice;
71 
72   // The addresses of the accounts (or contracts) that can execute actions within each roles.
73   address public ceoAddress;
74   address public cooAddress;
75 
76   uint256 public promoCreatedCount;
77 
78   /*** DATATYPES ***/
79   struct Meme {
80     string name;
81   }
82 
83   struct Memes {
84     uint256 Id;
85     string memeName;
86     uint256 sellingPrice;
87     address owner;
88   }
89 
90   Meme[] private memes;
91 
92   /*** ACCESS MODIFIERS ***/
93   /// @dev Access modifier for CEO-only functionality
94   modifier onlyCEO() {
95     require(msg.sender == ceoAddress);
96     _;
97   }
98 
99   /// @dev Access modifier for COO-only functionality
100   modifier onlyCOO() {
101     require(msg.sender == cooAddress);
102     _;
103   }
104 
105   /// Access modifier for contract owner only functionality
106   modifier onlyCLevel() {
107     require(
108       msg.sender == ceoAddress ||
109       msg.sender == cooAddress
110     );
111     _;
112   }
113 
114   /*** CONSTRUCTOR ***/
115   function MemeToken() public {
116     ceoAddress = msg.sender;
117     cooAddress = msg.sender;
118   }
119 
120   /*** PUBLIC FUNCTIONS ***/
121   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
122   /// @param _to The address to be granted transfer approval. Pass address(0) to
123   ///  clear all approvals.
124   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
125   /// @dev Required for ERC-721 compliance.
126   function approve(
127     address _to,
128     uint256 _tokenId
129   ) public {
130     // Caller must own token.
131     require(_owns(msg.sender, _tokenId));
132 
133     memeIndexToApproved[_tokenId] = _to;
134 
135     Approval(msg.sender, _to, _tokenId);
136   }
137 
138   /// For querying balance of a particular account
139   /// @param _owner The address for balance query
140   /// @dev Required for ERC-721 compliance.
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return ownershipTokenCount[_owner];
143   }
144 
145   /// @dev Creates a new promo Meme with the given name, with given _price and assignes it to an address.
146   function createPromoMeme(address _owner, string _name, uint256 _price) public onlyCOO {
147     require(promoCreatedCount < PROMO_CREATION_LIMIT);
148 
149     address memeOwner = _owner;
150     if (memeOwner == address(0)) {
151       memeOwner = cooAddress;
152     }
153 
154     if (_price <= 0) {
155       _price = startingPrice;
156     }
157 
158     promoCreatedCount++;
159     _createMeme(_name, memeOwner, _price);
160   }
161 
162   /// @dev Creates a new Meme with the given name.
163   function createContractMeme(string _name) public onlyCOO {
164     _createMeme(_name, address(this), startingPrice);
165   }
166 
167   /// @notice Returns all the relevant information about a specific meme.
168   /// @param _tokenId The tokenId of the meme of interest.
169   function getMeme(uint256 _tokenId) public view returns (
170     uint256 Id,
171     string memeName,
172     uint256 sellingPrice,
173     address owner
174   ) {
175     Meme storage meme = memes[_tokenId];
176     Id = _tokenId;
177     memeName = meme.name;
178     sellingPrice = memeIndexToPrice[_tokenId];
179     owner = memeIndexToOwner[_tokenId];
180   }
181 
182   /// @notice Returns all the relevant information about a specific meme.
183   /// @param _tokenIds The tokenId of the meme of interest.
184   function getMemeSellingPrices(uint256[] _tokenIds) public view returns (
185     uint256[] sellingPrices
186   ) {
187     sellingPrices = new uint256[](_tokenIds.length);
188     for(uint i=0;i<_tokenIds.length;i++){
189       sellingPrices[i]=memeIndexToPrice[_tokenIds[i]];
190     }
191 
192   }
193 
194   function implementsERC721() public pure returns (bool) {
195     return true;
196   }
197 
198   /// @dev Required for ERC-721 compliance.
199   function name() public pure returns (string) {
200     return NAME;
201   }
202 
203   /// For querying owner of token
204   /// @param _tokenId The tokenID for owner inquiry
205   /// @dev Required for ERC-721 compliance.
206   function ownerOf(uint256 _tokenId)
207     public
208     view
209     returns (address owner)
210   {
211     owner = memeIndexToOwner[_tokenId];
212     require(owner != address(0));
213   }
214 
215   function payout(address _to) public onlyCLevel {
216     _payout(_to);
217   }
218 
219   // Allows someone to send ether and obtain the token
220   function purchase(uint256 _tokenId) public payable {
221     address oldOwner = memeIndexToOwner[_tokenId];
222     address newOwner = msg.sender;
223 
224     uint256 sellingPrice = memeIndexToPrice[_tokenId];
225 
226     // Making sure token owner is not sending to self
227     require(oldOwner != newOwner);
228 
229     // Safety check to prevent against an unexpected 0x0 default.
230     require(_addressNotNull(newOwner));
231 
232     // Making sure sent amount is greater than or equal to the sellingPrice
233     require(msg.value >= sellingPrice);
234 
235     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
236     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
237 
238     // Update prices
239     if (sellingPrice < firstStepLimit) {
240       // first stage
241       memeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
242     } else if (sellingPrice < secondStepLimit) {
243       // second stage
244       memeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
245     } else {
246       // third stage
247       memeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
248     }
249 
250     _transfer(oldOwner, newOwner, _tokenId);
251 
252     // Pay previous tokenOwner if owner is not contract
253     if (oldOwner != address(this)) {
254       oldOwner.transfer(payment); //(1-0.06)
255     }
256 
257     TokenSold(_tokenId, sellingPrice, memeIndexToPrice[_tokenId], oldOwner, newOwner, memes[_tokenId].name);
258 
259     msg.sender.transfer(purchaseExcess);
260   }
261 
262   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
263     return memeIndexToPrice[_tokenId];
264   }
265 
266   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
267   /// @param _newCEO The address of the new CEO
268   function setCEO(address _newCEO) public onlyCEO {
269     require(_newCEO != address(0));
270 
271     ceoAddress = _newCEO;
272   }
273 
274   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
275   /// @param _newCOO The address of the new COO
276   function setCOO(address _newCOO) public onlyCEO {
277     require(_newCOO != address(0));
278 
279     cooAddress = _newCOO;
280   }
281 
282   /// @dev Required for ERC-721 compliance.
283   function symbol() public pure returns (string) {
284     return SYMBOL;
285   }
286 
287   /// @notice Allow pre-approved user to take ownership of a token
288   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
289   /// @dev Required for ERC-721 compliance.
290   function takeOwnership(uint256 _tokenId) public {
291     address newOwner = msg.sender;
292     address oldOwner = memeIndexToOwner[_tokenId];
293 
294     // Safety check to prevent against an unexpected 0x0 default.
295     require(_addressNotNull(newOwner));
296 
297     // Making sure transfer is approved
298     require(_approved(newOwner, _tokenId));
299 
300     _transfer(oldOwner, newOwner, _tokenId);
301   }
302 
303   /// @param _owner The owner whose meme tokens we are interested in.
304   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
305   ///  expensive (it walks the entire Memes array looking for memes belonging to owner),
306   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
307   ///  not contract-to-contract calls.
308   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
309     uint256 tokenCount = balanceOf(_owner);
310     if (tokenCount == 0) {
311         // Return an empty array
312       return new uint256[](0);
313     } else {
314       uint256[] memory result = new uint256[](tokenCount);
315       uint256 totalMemes = totalSupply();
316       uint256 resultIndex = 0;
317 
318       uint256 memeId;
319       for (memeId = 0; memeId <= totalMemes; memeId++) {
320         if (memeIndexToOwner[memeId] == _owner) {
321           result[resultIndex] = memeId;
322           resultIndex++;
323         }
324       }
325       return result;
326     }
327   }
328 
329   /// For querying totalSupply of token
330   /// @dev Required for ERC-721 compliance.
331   function totalSupply() public view returns (uint256 total) {
332     return memes.length;
333   }
334 
335   /// Owner initates the transfer of the token to another account
336   /// @param _to The address for the token to be transferred to.
337   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
338   /// @dev Required for ERC-721 compliance.
339   function transfer(
340     address _to,
341     uint256 _tokenId
342   ) public {
343     require(_owns(msg.sender, _tokenId));
344     require(_addressNotNull(_to));
345 
346     _transfer(msg.sender, _to, _tokenId);
347   }
348 
349   /// Third-party initiates transfer of token from address _from to address _to
350   /// @param _from The address for the token to be transferred from.
351   /// @param _to The address for the token to be transferred to.
352   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
353   /// @dev Required for ERC-721 compliance.
354   function transferFrom(
355     address _from,
356     address _to,
357     uint256 _tokenId
358   ) public {
359     require(_owns(_from, _tokenId));
360     require(_approved(_to, _tokenId));
361     require(_addressNotNull(_to));
362 
363     _transfer(_from, _to, _tokenId);
364   }
365 
366   /*** PRIVATE FUNCTIONS ***/
367   /// Safety check on _to address to prevent against an unexpected 0x0 default.
368   function _addressNotNull(address _to) private pure returns (bool) {
369     return _to != address(0);
370   }
371 
372   /// For checking approval of transfer for address _to
373   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
374     return memeIndexToApproved[_tokenId] == _to;
375   }
376 
377   /// For creating Meme
378   function _createMeme(string _name, address _owner, uint256 _price) private {
379     Meme memory _meme = Meme({
380       name: _name
381     });
382     uint256 newMemeId = memes.push(_meme) - 1;
383 
384     // It's probably never going to happen, 4 billion tokens are A LOT, but
385     // let's just be 100% sure we never let this happen.
386     require(newMemeId == uint256(uint32(newMemeId)));
387 
388     Birth(newMemeId, _name, _owner);
389 
390     memeIndexToPrice[newMemeId] = _price;
391 
392     // This will assign ownership, and also emit the Transfer event as
393     // per ERC721 draft
394     _transfer(address(0), _owner, newMemeId);
395   }
396 
397   /// Check for token ownership
398   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
399     return claimant == memeIndexToOwner[_tokenId];
400   }
401 
402   /// For paying out balance on contract
403   function _payout(address _to) private {
404     if (_to == address(0)) {
405       ceoAddress.transfer(this.balance);
406     } else {
407       _to.transfer(this.balance);
408     }
409   }
410 
411   /// @dev Assigns ownership of a specific Meme to an address.
412   function _transfer(address _from, address _to, uint256 _tokenId) private {
413     // Since the number of memes is capped to 2^32 we can't overflow this
414     ownershipTokenCount[_to]++;
415     //transfer ownership
416     memeIndexToOwner[_tokenId] = _to;
417 
418     // When creating new memes _from is 0x0, but we can't account that address.
419     if (_from != address(0)) {
420       ownershipTokenCount[_from]--;
421       // clear any previously approved ownership exchange
422       delete memeIndexToApproved[_tokenId];
423     }
424 
425     // Emit the transfer event.
426     Transfer(_from, _to, _tokenId);
427   }
428 
429 }
430 library SafeMath {
431 
432   /**
433   * @dev Multiplies two numbers, throws on overflow.
434   */
435   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
436     if (a == 0) {
437       return 0;
438     }
439     uint256 c = a * b;
440     assert(c / a == b);
441     return c;
442   }
443 
444   /**
445   * @dev Integer division of two numbers, truncating the quotient.
446   */
447   function div(uint256 a, uint256 b) internal pure returns (uint256) {
448     // assert(b > 0); // Solidity automatically throws when dividing by 0
449     uint256 c = a / b;
450     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
451     return c;
452   }
453 
454   /**
455   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
456   */
457   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
458     assert(b <= a);
459     return a - b;
460   }
461 
462   /**
463   * @dev Adds two numbers, throws on overflow.
464   */
465   function add(uint256 a, uint256 b) internal pure returns (uint256) {
466     uint256 c = a + b;
467     assert(c >= a);
468     return c;
469   }
470 }