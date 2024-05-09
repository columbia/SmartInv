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
50   // The limit was 77, and the redeployment was for 65 emoji
51   // That's why the limit here is 142
52   uint256 private constant PROMO_CREATION_LIMIT = 142;
53   uint256 private firstStepLimit =  0.05 ether;
54   uint256 private secondStepLimit = 0.55 ether;
55 
56   /*** STORAGE ***/
57 
58   /// @dev A mapping from emoji IDs to the address that owns them. All emojis have
59   ///  some valid owner address.
60   mapping (uint256 => address) public emojiIndexToOwner;
61 
62   // @dev A mapping from owner address to count of tokens that address owns.
63   //  Used internally inside balanceOf() to resolve ownership count.
64   mapping (address => uint256) private ownershipTokenCount;
65 
66   /// @dev A mapping from EmojiIDs to an address that has been approved to call
67   ///  transferFrom(). Each Emoji can only have one approved address for transfer
68   ///  at any time. A zero value means no approval is outstanding.
69   mapping (uint256 => address) public emojiIndexToApproved;
70 
71   // @dev A mapping from EmojiIDs to the price of the token.
72   mapping (uint256 => uint256) private emojiIndexToPrice;
73   
74   /// @dev A mapping from EmojiIDs to the previpus price of the token. Used
75   /// to calculate price delta for payouts
76   mapping (uint256 => uint256) private emojiIndexToPreviousPrice;
77 
78   // MY THING
79   // @dev A mapping from emojiId to the custom message the owner set.
80   mapping (uint256 => string) private emojiIndexToCustomMessage;
81 
82   // @dev A mapping from emojiId to the 7 last owners.
83   mapping (uint256 => address[7]) private emojiIndexToPreviousOwners;
84 
85 
86   // The addresses of the accounts (or contracts) that can execute actions within each roles.
87   address public ceoAddress;
88   address public cooAddress;
89 
90   uint256 public promoCreatedCount;
91 
92   /*** DATATYPES ***/
93   struct Emoji {
94     string name;
95   }
96 
97   Emoji[] private emojis;
98 
99   /*** ACCESS MODIFIERS ***/
100   /// @dev Access modifier for CEO-only functionality
101   modifier onlyCEO() {
102     require(msg.sender == ceoAddress);
103     _;
104   }
105 
106   /// @dev Access modifier for COO-only functionality
107   modifier onlyCOO() {
108     require(msg.sender == cooAddress);
109     _;
110   }
111 
112   /// Access modifier for contract owner only functionality
113   modifier onlyCLevel() {
114     require(
115       msg.sender == ceoAddress ||
116       msg.sender == cooAddress
117     );
118     _;
119   }
120 
121   /*** CONSTRUCTOR ***/
122   function EmojiToken() public {
123     ceoAddress = msg.sender;
124     cooAddress = msg.sender;
125   }
126 
127   /*** PUBLIC FUNCTIONS ***/
128   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
129   /// @param _to The address to be granted transfer approval. Pass address(0) to
130   ///  clear all approvals.
131   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
132   /// @dev Required for ERC-721 compliance.
133   function approve(
134     address _to,
135     uint256 _tokenId
136   ) public {
137     // Caller must own token.
138     require(_owns(msg.sender, _tokenId));
139 
140     emojiIndexToApproved[_tokenId] = _to;
141 
142     Approval(msg.sender, _to, _tokenId);
143   }
144 
145   /// For querying balance of a particular account
146   /// @param _owner The address for balance query
147   /// @dev Required for ERC-721 compliance.
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return ownershipTokenCount[_owner];
150   }
151 
152   /// @dev Creates a new promo Emoji with the given name, with given _price and assignes it to an address.
153   function createPromoEmoji(address _owner, string _name, uint256 _price) public onlyCOO {
154     require(promoCreatedCount < PROMO_CREATION_LIMIT);
155 
156     address emojiOwner = _owner;
157     if (emojiOwner == address(0)) {
158       emojiOwner = cooAddress;
159     }
160 
161     if (_price <= 0) {
162       _price = startingPrice;
163     }
164 
165     promoCreatedCount++;
166     _createEmoji(_name, emojiOwner, _price);
167   }
168 
169   /// @dev Creates a new Emoji with the given name.
170   function createContractEmoji(string _name) public onlyCOO {
171     _createEmoji(_name, address(this), startingPrice);
172   }
173 
174   /// @notice Returns all the relevant information about a specific emoji.
175   /// @param _tokenId The tokenId of the emoji of interest.
176   function getEmoji(uint256 _tokenId) public view returns (
177     string emojiName,
178     uint256 sellingPrice,
179     address owner,
180     string message,
181     uint256 previousPrice,
182     address[7] previousOwners
183   ) {
184     Emoji storage emoji = emojis[_tokenId];
185     emojiName = emoji.name;
186     sellingPrice = emojiIndexToPrice[_tokenId];
187     owner = emojiIndexToOwner[_tokenId];
188     message = emojiIndexToCustomMessage[_tokenId];
189     previousPrice = emojiIndexToPreviousPrice[_tokenId];
190     previousOwners = emojiIndexToPreviousOwners[_tokenId];
191   }
192 
193   function implementsERC721() public pure returns (bool) {
194     return true;
195   }
196 
197   /// @dev Required for ERC-721 compliance.
198   function name() public pure returns (string) {
199     return NAME;
200   }
201 
202   /// For querying owner of token
203   /// @param _tokenId The tokenID for owner inquiry
204   /// @dev Required for ERC-721 compliance.
205   function ownerOf(uint256 _tokenId)
206     public
207     view
208     returns (address owner)
209   {
210     owner = emojiIndexToOwner[_tokenId];
211     require(owner != address(0));
212   }
213 
214   function payout(address _to) public onlyCLevel {
215     _payout(_to);
216   }
217 
218   // Allows owner to add short message to token
219   // Limit is based on Twitter's tweet characterlimit
220   function addMessage(uint256 _tokenId, string _message) public {
221     require(_owns(msg.sender, _tokenId));
222     require(bytes(_message).length<281);
223     emojiIndexToCustomMessage[_tokenId] = _message;
224   }
225 
226   // This function was added in order to give the ability
227   // to manually set ownership history since this had to be
228   // redeployed
229   function setOwnershipHistory(uint256 _tokenId, address[7] _previousOwners) public onlyCOO {
230     emojiIndexToPreviousOwners[_tokenId] = _previousOwners;
231   }
232 
233   // This function was added in order to give the ability
234   // to manually set the previous price since this had to 
235   // be redeployed
236   function setPreviousPrice(uint256 _tokenId, uint256 _previousPrice) public onlyCOO {
237     emojiIndexToPreviousPrice[_tokenId] = _previousPrice;
238   }
239 
240   // Allows someone to send ether and obtain the token
241   function purchase(uint256 _tokenId) public payable {
242     address oldOwner = emojiIndexToOwner[_tokenId];
243     address newOwner = msg.sender;
244     
245     address[7] storage previousOwners = emojiIndexToPreviousOwners[_tokenId];
246 
247     uint256 sellingPrice = emojiIndexToPrice[_tokenId];
248     uint256 previousPrice = emojiIndexToPreviousPrice[_tokenId];
249 
250     // Making sure token owner is not sending to self
251     require(oldOwner != newOwner);
252 
253     // Safety check to prevent against an unexpected 0x0 default.
254     require(_addressNotNull(newOwner));
255 
256     // Making sure sent amount is greater than or equal to the sellingPrice
257     require(msg.value >= sellingPrice);
258 
259     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
260     uint256 payoutTotal = uint256(SafeMath.div(SafeMath.mul(priceDelta, 90), 100));
261     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
262     // Update previous price
263     emojiIndexToPreviousPrice[_tokenId] = sellingPrice; 
264     // Update prices
265     if (sellingPrice < firstStepLimit) {
266       // first stage
267       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 90);
268     } else if (sellingPrice < secondStepLimit) {
269       // second stage
270       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 90);
271     } else {
272       // third stage
273       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 90);
274     }
275 
276     _transfer(oldOwner, newOwner, _tokenId);
277 
278     // Pay previous tokenOwner if owner is not contract
279     // and if previous price is not 0
280     if (oldOwner != address(this) && previousPrice > 0) {
281       // old owner gets entire initial payment back
282       oldOwner.transfer(previousPrice);
283     }
284     
285     // Next distribute payoutTotal among previous Owners
286     // Do not distribute if previous owner is contract.
287     // Split is: 75, 12, 6, 3, 2, 1.5, 0.5
288     if (previousOwners[0] != address(this) && payoutTotal > 0) {
289       previousOwners[0].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 75), 100)));
290     }
291     if (previousOwners[1] != address(this) && payoutTotal > 0) {
292       previousOwners[1].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 12), 100)));
293     }
294     if (previousOwners[2] != address(this) && payoutTotal > 0) {
295       previousOwners[2].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 6), 100)));
296     }
297     if (previousOwners[3] != address(this) && payoutTotal > 0) {
298       previousOwners[3].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 3), 100)));
299     }
300     if (previousOwners[4] != address(this) && payoutTotal > 0) {
301       previousOwners[4].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 2), 100)));
302     }
303     if (previousOwners[5] != address(this) && payoutTotal > 0) {
304       // divide by 1000 since percentage is 1.5
305       previousOwners[5].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 15), 1000)));
306     }
307     if (previousOwners[6] != address(this) && payoutTotal > 0) {
308       // divide by 1000 since percentage is 0.5
309       previousOwners[6].transfer(uint256(SafeMath.div(SafeMath.mul(payoutTotal, 5), 1000)));
310     }
311     
312     TokenSold(_tokenId, sellingPrice, emojiIndexToPrice[_tokenId], oldOwner, newOwner, emojis[_tokenId].name);
313 
314     msg.sender.transfer(purchaseExcess);
315   }
316 
317   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
318     return emojiIndexToPrice[_tokenId];
319   }
320 
321   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
322   /// @param _newCEO The address of the new CEO
323   function setCEO(address _newCEO) public onlyCEO {
324     require(_newCEO != address(0));
325 
326     ceoAddress = _newCEO;
327   }
328 
329   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
330   /// @param _newCOO The address of the new COO
331   function setCOO(address _newCOO) public onlyCEO {
332     require(_newCOO != address(0));
333     cooAddress = _newCOO;
334   }
335 
336   /// @dev Required for ERC-721 compliance.
337   function symbol() public pure returns (string) {
338     return SYMBOL;
339   }
340 
341   /// @notice Allow pre-approved user to take ownership of a token
342   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
343   /// @dev Required for ERC-721 compliance.
344   function takeOwnership(uint256 _tokenId) public {
345     address newOwner = msg.sender;
346     address oldOwner = emojiIndexToOwner[_tokenId];
347 
348     // Safety check to prevent against an unexpected 0x0 default.
349     require(_addressNotNull(newOwner));
350 
351     // Making sure transfer is approved
352     require(_approved(newOwner, _tokenId));
353 
354     _transfer(oldOwner, newOwner, _tokenId);
355   }
356 
357   /// @param _owner The owner whose emoji tokens we are interested in.
358   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
359   ///  expensive (it walks the entire Emojis array looking for emojis belonging to owner),
360   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
361   ///  not contract-to-contract calls.
362   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
363     uint256 tokenCount = balanceOf(_owner);
364     if (tokenCount == 0) {
365         // Return an empty array
366       return new uint256[](0);
367     } else {
368       uint256[] memory result = new uint256[](tokenCount);
369       uint256 totalEmojis = totalSupply();
370       uint256 resultIndex = 0;
371       uint256 emojiId;
372       for (emojiId = 0; emojiId <= totalEmojis; emojiId++) {
373         if (emojiIndexToOwner[emojiId] == _owner) {
374           result[resultIndex] = emojiId;
375           resultIndex++;
376         }
377       }
378       return result;
379     }
380   }
381 
382   /// For querying totalSupply of token
383   /// @dev Required for ERC-721 compliance.
384   function totalSupply() public view returns (uint256 total) {
385     return emojis.length;
386   }
387 
388   /// Owner initates the transfer of the token to another account
389   /// @param _to The address for the token to be transferred to.
390   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
391   /// @dev Required for ERC-721 compliance.
392   function transfer(
393     address _to,
394     uint256 _tokenId
395   ) public {
396     require(_owns(msg.sender, _tokenId));
397     require(_addressNotNull(_to));
398     _transfer(msg.sender, _to, _tokenId);
399   }
400 
401   /// Third-party initiates transfer of token from address _from to address _to
402   /// @param _from The address for the token to be transferred from.
403   /// @param _to The address for the token to be transferred to.
404   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
405   /// @dev Required for ERC-721 compliance.
406   function transferFrom(
407     address _from,
408     address _to,
409     uint256 _tokenId
410   ) public {
411     require(_owns(_from, _tokenId));
412     require(_approved(_to, _tokenId));
413     require(_addressNotNull(_to));
414     _transfer(_from, _to, _tokenId);
415   }
416 
417   /*** PRIVATE FUNCTIONS ***/
418   /// Safety check on _to address to prevent against an unexpected 0x0 default.
419   function _addressNotNull(address _to) private pure returns (bool) {
420     return _to != address(0);
421   }
422 
423   /// For checking approval of transfer for address _to
424   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
425     return emojiIndexToApproved[_tokenId] == _to;
426   }
427 
428   /// For creating Emoji
429   function _createEmoji(string _name, address _owner, uint256 _price) private {
430     Emoji memory _emoji = Emoji({
431       name: _name
432     });
433     uint256 newEmojiId = emojis.push(_emoji) - 1;
434 
435     // It's probably never going to happen, 4 billion tokens are A LOT, but
436     // let's just be 100% sure we never let this happen.
437     require(newEmojiId == uint256(uint32(newEmojiId)));
438 
439     Birth(newEmojiId, _name, _owner);
440 
441     emojiIndexToPrice[newEmojiId] = _price;
442     emojiIndexToPreviousPrice[newEmojiId] = 0;
443     emojiIndexToCustomMessage[newEmojiId] = 'hi';
444     emojiIndexToPreviousOwners[newEmojiId] =
445         [address(this), address(this), address(this), address(this), address(this), address(this), address(this)];
446 
447     // This will assign ownership, and also emit the Transfer event as
448     // per ERC721 draft
449     _transfer(address(0), _owner, newEmojiId);
450   }
451 
452   /// Check for token ownership
453   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
454     return claimant == emojiIndexToOwner[_tokenId];
455   }
456 
457   /// For paying out balance on contract
458   function _payout(address _to) private {
459     if (_to == address(0)) {
460       ceoAddress.transfer(this.balance);
461     } else {
462       _to.transfer(this.balance);
463     }
464   }
465 
466   /// @dev Assigns ownership of a specific Emoji to an address.
467   function _transfer(address _from, address _to, uint256 _tokenId) private {
468     // Since the number of emojis is capped to 2^32 we can't overflow this
469     ownershipTokenCount[_to]++;
470     //transfer ownership
471     emojiIndexToOwner[_tokenId] = _to;
472     // When creating new emojis _from is 0x0, but we can't account that address.
473     if (_from != address(0)) {
474       ownershipTokenCount[_from]--;
475       // clear any previously approved ownership exchange
476       delete emojiIndexToApproved[_tokenId];
477     }
478     // Update the emojiIndexToPreviousOwners
479     emojiIndexToPreviousOwners[_tokenId][6]=emojiIndexToPreviousOwners[_tokenId][5];
480     emojiIndexToPreviousOwners[_tokenId][5]=emojiIndexToPreviousOwners[_tokenId][4];
481     emojiIndexToPreviousOwners[_tokenId][4]=emojiIndexToPreviousOwners[_tokenId][3];
482     emojiIndexToPreviousOwners[_tokenId][3]=emojiIndexToPreviousOwners[_tokenId][2];
483     emojiIndexToPreviousOwners[_tokenId][2]=emojiIndexToPreviousOwners[_tokenId][1];
484     emojiIndexToPreviousOwners[_tokenId][1]=emojiIndexToPreviousOwners[_tokenId][0];
485     // the _from address for creation is 0, so instead set it to the contract address
486     if (_from != address(0)) {
487         emojiIndexToPreviousOwners[_tokenId][0]=_from;
488     } else {
489         emojiIndexToPreviousOwners[_tokenId][0]=address(this);
490     }
491     // Emit the transfer event.
492     Transfer(_from, _to, _tokenId);
493   }
494 }
495 library SafeMath {
496 
497   /**
498   * @dev Multiplies two numbers, throws on overflow.
499   */
500   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
501     if (a == 0) {
502       return 0;
503     }
504     uint256 c = a * b;
505     assert(c / a == b);
506     return c;
507   }
508 
509   /**
510   * @dev Integer division of two numbers, truncating the quotient.
511   */
512   function div(uint256 a, uint256 b) internal pure returns (uint256) {
513     // assert(b > 0); // Solidity automatically throws when dividing by 0
514     uint256 c = a / b;
515     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
516     return c;
517   }
518 
519   /**
520   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
521   */
522   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
523     assert(b <= a);
524     return a - b;
525   }
526 
527   /**
528   * @dev Adds two numbers, throws on overflow.
529   */
530   function add(uint256 a, uint256 b) internal pure returns (uint256) {
531     uint256 c = a + b;
532     assert(c >= a);
533     return c;
534   }
535 }