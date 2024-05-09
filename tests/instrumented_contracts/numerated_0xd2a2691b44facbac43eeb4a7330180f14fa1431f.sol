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
28 /// Modified from the CryptoCelebrities contract
29 contract EmojiToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new emoji comes into existence.
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
46   string public constant NAME = "EmojiBlockchain"; // solhint-disable-line
47   string public constant SYMBOL = "EmojiToken"; // solhint-disable-line
48 
49   uint256 private startingPrice = 0.001 ether;
50   uint256 private constant PROMO_CREATION_LIMIT = 77;
51   uint256 private firstStepLimit =  0.05 ether;
52   uint256 private secondStepLimit = 0.55 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from emoji IDs to the address that owns them. All emojis have
57   ///  some valid owner address.
58   mapping (uint256 => address) public emojiIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from EmojiIDs to an address that has been approved to call
65   ///  transferFrom(). Each Emoji can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public emojiIndexToApproved;
68 
69   // @dev A mapping from EmojiIDs to the price of the token.
70   mapping (uint256 => uint256) private emojiIndexToPrice;
71   
72   /// @dev A mapping from EmojiIDs to the previpus price of the token. Used
73   /// to calculate price delta for payouts
74   mapping (uint256 => uint256) private emojiIndexToPreviousPrice;
75 
76   // MY THING
77   // @dev A mapping from emojiId to the custom message the owner set.
78   mapping (uint256 => string) private emojiIndexToCustomMessage;
79 
80   // @dev A mapping from emojiId to the 7 last owners.
81   mapping (uint256 => address[7]) private emojiIndexToPreviousOwners;
82 
83 
84   // The addresses of the accounts (or contracts) that can execute actions within each roles.
85   address public ceoAddress;
86   address public cooAddress;
87 
88   uint256 public promoCreatedCount;
89 
90   /*** DATATYPES ***/
91   struct Emoji {
92     string name;
93   }
94 
95   Emoji[] private emojis;
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
120   function EmojiToken() public {
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
138     emojiIndexToApproved[_tokenId] = _to;
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
150   /// @dev Creates a new promo Emoji with the given name, with given _price and assignes it to an address.
151   function createPromoEmoji(address _owner, string _name, uint256 _price) public onlyCOO {
152     require(promoCreatedCount < PROMO_CREATION_LIMIT);
153 
154     address emojiOwner = _owner;
155     if (emojiOwner == address(0)) {
156       emojiOwner = cooAddress;
157     }
158 
159     if (_price <= 0) {
160       _price = startingPrice;
161     }
162 
163     promoCreatedCount++;
164     _createEmoji(_name, emojiOwner, _price);
165   }
166 
167   /// @dev Creates a new Emoji with the given name.
168   function createContractEmoji(string _name) public onlyCOO {
169     _createEmoji(_name, address(this), startingPrice);
170   }
171 
172   /// @notice Returns all the relevant information about a specific emoji.
173   /// @param _tokenId The tokenId of the emoji of interest.
174   function getEmoji(uint256 _tokenId) public view returns (
175     string emojiName,
176     uint256 sellingPrice,
177     address owner,
178     string message,
179     uint256 previousPrice,
180     address[7] previousOwners
181   ) {
182     Emoji storage emoji = emojis[_tokenId];
183     emojiName = emoji.name;
184     sellingPrice = emojiIndexToPrice[_tokenId];
185     owner = emojiIndexToOwner[_tokenId];
186     message = emojiIndexToCustomMessage[_tokenId];
187     previousPrice = emojiIndexToPreviousPrice[_tokenId];
188     previousOwners = emojiIndexToPreviousOwners[_tokenId];
189   }
190 
191   function implementsERC721() public pure returns (bool) {
192     return true;
193   }
194 
195   /// @dev Required for ERC-721 compliance.
196   function name() public pure returns (string) {
197     return NAME;
198   }
199 
200   /// For querying owner of token
201   /// @param _tokenId The tokenID for owner inquiry
202   /// @dev Required for ERC-721 compliance.
203   function ownerOf(uint256 _tokenId)
204     public
205     view
206     returns (address owner)
207   {
208     owner = emojiIndexToOwner[_tokenId];
209     require(owner != address(0));
210   }
211 
212   function payout(address _to) public onlyCLevel {
213     _payout(_to);
214   }
215 
216   // Allows owner to add short message to token
217   // Limit is based on Twitter's tweet characterlimit
218   function addMessage(uint256 _tokenId, string _message) public {
219     require(_owns(msg.sender, _tokenId));
220     require(bytes(_message).length<281);
221     emojiIndexToCustomMessage[_tokenId] = _message;
222   }
223 
224   // Allows someone to send ether and obtain the token
225   function purchase(uint256 _tokenId) public payable {
226     address oldOwner = emojiIndexToOwner[_tokenId];
227     address newOwner = msg.sender;
228     
229     address[7] storage previousOwners = emojiIndexToPreviousOwners[_tokenId];
230 
231     uint256 sellingPrice = emojiIndexToPrice[_tokenId];
232     uint256 previousPrice = emojiIndexToPreviousPrice[_tokenId];
233 
234     // Making sure token owner is not sending to self
235     require(oldOwner != newOwner);
236 
237     // Safety check to prevent against an unexpected 0x0 default.
238     require(_addressNotNull(newOwner));
239 
240     // Making sure sent amount is greater than or equal to the sellingPrice
241     require(msg.value >= sellingPrice);
242 
243     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
244     uint256 payoutTotal = uint256(SafeMath.div(SafeMath.mul(priceDelta, 90), 100));
245     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
246 
247     // Update prices
248     if (sellingPrice < firstStepLimit) {
249       // first stage
250       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 90);
251     } else if (sellingPrice < secondStepLimit) {
252       // second stage
253       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 90);
254     } else {
255       // third stage
256       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 90);
257     }
258 
259     _transfer(oldOwner, newOwner, _tokenId);
260 
261     // Pay previous tokenOwner if owner is not contract
262     // and if previous price is not 0
263     if (oldOwner != address(this) && previousPrice > 0) {
264       // old owner gets entire initial payment back
265       oldOwner.transfer(previousPrice);
266     }
267     
268     // Next distribute payoutTotal among previous Owners
269     // Do not distribute if previous owner is contract.
270     // Split is: 75, 12, 6, 3, 2, 1.5, 0.5
271     if (previousOwners[0] != address(this) && payoutTotal > 0) {
272       previousOwners[0].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 75), 100)));
273     }
274     if (previousOwners[1] != address(this) && payoutTotal > 0) {
275       previousOwners[1].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 12), 100)));
276     }
277     if (previousOwners[2] != address(this) && payoutTotal > 0) {
278       previousOwners[2].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 6), 100)));
279     }
280     if (previousOwners[3] != address(this) && payoutTotal > 0) {
281       previousOwners[3].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 3), 100)));
282     }
283     if (previousOwners[4] != address(this) && payoutTotal > 0) {
284       previousOwners[4].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 2), 100)));
285     }
286     if (previousOwners[5] != address(this) && payoutTotal > 0) {
287       // divide by 1000 since percentage is 1.5
288       previousOwners[5].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 15), 1000)));
289     }
290     if (previousOwners[6] != address(this) && payoutTotal > 0) {
291       // divide by 1000 since percentage is 0.5
292       previousOwners[6].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 5), 1000)));
293     }
294     
295     TokenSold(_tokenId, sellingPrice, emojiIndexToPrice[_tokenId], oldOwner, newOwner, emojis[_tokenId].name);
296 
297     msg.sender.transfer(purchaseExcess);
298   }
299 
300   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
301     return emojiIndexToPrice[_tokenId];
302   }
303 
304   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
305   /// @param _newCEO The address of the new CEO
306   function setCEO(address _newCEO) public onlyCEO {
307     require(_newCEO != address(0));
308 
309     ceoAddress = _newCEO;
310   }
311 
312   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
313   /// @param _newCOO The address of the new COO
314   function setCOO(address _newCOO) public onlyCEO {
315     require(_newCOO != address(0));
316     cooAddress = _newCOO;
317   }
318 
319   /// @dev Required for ERC-721 compliance.
320   function symbol() public pure returns (string) {
321     return SYMBOL;
322   }
323 
324   /// @notice Allow pre-approved user to take ownership of a token
325   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
326   /// @dev Required for ERC-721 compliance.
327   function takeOwnership(uint256 _tokenId) public {
328     address newOwner = msg.sender;
329     address oldOwner = emojiIndexToOwner[_tokenId];
330 
331     // Safety check to prevent against an unexpected 0x0 default.
332     require(_addressNotNull(newOwner));
333 
334     // Making sure transfer is approved
335     require(_approved(newOwner, _tokenId));
336 
337     _transfer(oldOwner, newOwner, _tokenId);
338   }
339 
340   /// @param _owner The owner whose emoji tokens we are interested in.
341   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
342   ///  expensive (it walks the entire Emojis array looking for emojis belonging to owner),
343   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
344   ///  not contract-to-contract calls.
345   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
346     uint256 tokenCount = balanceOf(_owner);
347     if (tokenCount == 0) {
348         // Return an empty array
349       return new uint256[](0);
350     } else {
351       uint256[] memory result = new uint256[](tokenCount);
352       uint256 totalEmojis = totalSupply();
353       uint256 resultIndex = 0;
354       uint256 emojiId;
355       for (emojiId = 0; emojiId <= totalEmojis; emojiId++) {
356         if (emojiIndexToOwner[emojiId] == _owner) {
357           result[resultIndex] = emojiId;
358           resultIndex++;
359         }
360       }
361       return result;
362     }
363   }
364 
365   /// For querying totalSupply of token
366   /// @dev Required for ERC-721 compliance.
367   function totalSupply() public view returns (uint256 total) {
368     return emojis.length;
369   }
370 
371   /// Owner initates the transfer of the token to another account
372   /// @param _to The address for the token to be transferred to.
373   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
374   /// @dev Required for ERC-721 compliance.
375   function transfer(
376     address _to,
377     uint256 _tokenId
378   ) public {
379     require(_owns(msg.sender, _tokenId));
380     require(_addressNotNull(_to));
381     _transfer(msg.sender, _to, _tokenId);
382   }
383 
384   /// Third-party initiates transfer of token from address _from to address _to
385   /// @param _from The address for the token to be transferred from.
386   /// @param _to The address for the token to be transferred to.
387   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
388   /// @dev Required for ERC-721 compliance.
389   function transferFrom(
390     address _from,
391     address _to,
392     uint256 _tokenId
393   ) public {
394     require(_owns(_from, _tokenId));
395     require(_approved(_to, _tokenId));
396     require(_addressNotNull(_to));
397     _transfer(_from, _to, _tokenId);
398   }
399 
400   /*** PRIVATE FUNCTIONS ***/
401   /// Safety check on _to address to prevent against an unexpected 0x0 default.
402   function _addressNotNull(address _to) private pure returns (bool) {
403     return _to != address(0);
404   }
405 
406   /// For checking approval of transfer for address _to
407   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
408     return emojiIndexToApproved[_tokenId] == _to;
409   }
410 
411   /// For creating Emoji
412   function _createEmoji(string _name, address _owner, uint256 _price) private {
413     Emoji memory _emoji = Emoji({
414       name: _name
415     });
416     uint256 newEmojiId = emojis.push(_emoji) - 1;
417 
418     // It's probably never going to happen, 4 billion tokens are A LOT, but
419     // let's just be 100% sure we never let this happen.
420     require(newEmojiId == uint256(uint32(newEmojiId)));
421 
422     Birth(newEmojiId, _name, _owner);
423 
424     emojiIndexToPrice[newEmojiId] = _price;
425     emojiIndexToPreviousPrice[newEmojiId] = 0;
426     emojiIndexToCustomMessage[newEmojiId] = 'hi';
427     emojiIndexToPreviousOwners[newEmojiId] =
428         [address(this), address(this), address(this), address(this), address(this), address(this), address(this)];
429 
430     // This will assign ownership, and also emit the Transfer event as
431     // per ERC721 draft
432     _transfer(address(0), _owner, newEmojiId);
433   }
434 
435   /// Check for token ownership
436   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
437     return claimant == emojiIndexToOwner[_tokenId];
438   }
439 
440   /// For paying out balance on contract
441   function _payout(address _to) private {
442     if (_to == address(0)) {
443       ceoAddress.transfer(this.balance);
444     } else {
445       _to.transfer(this.balance);
446     }
447   }
448 
449   /// @dev Assigns ownership of a specific Emoji to an address.
450   function _transfer(address _from, address _to, uint256 _tokenId) private {
451     // Since the number of emojis is capped to 2^32 we can't overflow this
452     ownershipTokenCount[_to]++;
453     //transfer ownership
454     emojiIndexToOwner[_tokenId] = _to;
455     // When creating new emojis _from is 0x0, but we can't account that address.
456     if (_from != address(0)) {
457       ownershipTokenCount[_from]--;
458       // clear any previously approved ownership exchange
459       delete emojiIndexToApproved[_tokenId];
460     }
461     // Update the emojiIndexToPreviousOwners
462     emojiIndexToPreviousOwners[_tokenId][6]=emojiIndexToPreviousOwners[_tokenId][5];
463     emojiIndexToPreviousOwners[_tokenId][5]=emojiIndexToPreviousOwners[_tokenId][4];
464     emojiIndexToPreviousOwners[_tokenId][4]=emojiIndexToPreviousOwners[_tokenId][3];
465     emojiIndexToPreviousOwners[_tokenId][3]=emojiIndexToPreviousOwners[_tokenId][2];
466     emojiIndexToPreviousOwners[_tokenId][2]=emojiIndexToPreviousOwners[_tokenId][1];
467     emojiIndexToPreviousOwners[_tokenId][1]=emojiIndexToPreviousOwners[_tokenId][0];
468     // the _from address for creation is 0, so instead set it to the contract address
469     if (_from != address(0)) {
470         emojiIndexToPreviousOwners[_tokenId][0]=_from;
471     } else {
472         emojiIndexToPreviousOwners[_tokenId][0]=address(this);
473     }
474     // Emit the transfer event.
475     Transfer(_from, _to, _tokenId);
476   }
477 }
478 library SafeMath {
479 
480   /**
481   * @dev Multiplies two numbers, throws on overflow.
482   */
483   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
484     if (a == 0) {
485       return 0;
486     }
487     uint256 c = a * b;
488     assert(c / a == b);
489     return c;
490   }
491 
492   /**
493   * @dev Integer division of two numbers, truncating the quotient.
494   */
495   function div(uint256 a, uint256 b) internal pure returns (uint256) {
496     // assert(b > 0); // Solidity automatically throws when dividing by 0
497     uint256 c = a / b;
498     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
499     return c;
500   }
501 
502   /**
503   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
504   */
505   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
506     assert(b <= a);
507     return a - b;
508   }
509 
510   /**
511   * @dev Adds two numbers, throws on overflow.
512   */
513   function add(uint256 a, uint256 b) internal pure returns (uint256) {
514     uint256 c = a + b;
515     assert(c >= a);
516     return c;
517   }
518 }