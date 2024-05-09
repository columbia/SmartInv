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
18 
19   // Optional
20   // function name() public view returns (string name);
21   // function symbol() public view returns (string symbol);
22   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 
27 contract CityToken is ERC721 {
28 
29   /*** EVENTS ***/
30 
31   /// @dev The TokenCreated event is fired whenever a new token comes into existence.
32   event TokenCreated(uint256 tokenId, string name, uint256 parentId, address owner);
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, uint256 parentId);
36 
37   /// @dev Transfer event as defined in current draft of ERC721. 
38   ///  ownership is assigned, including create event.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /*** CONSTANTS ***/
42 
43   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
44   string public constant NAME = "CryptoCities"; // solhint-disable-line
45   string public constant SYMBOL = "CityToken"; // solhint-disable-line
46 
47   uint256 private startingPrice = 0.05 ether;
48 
49   /*** STORAGE ***/
50 
51   /// @dev A mapping from token IDs to the address that owns them. All tokens have
52   ///  some valid owner address.
53   mapping (uint256 => address) public tokenIndexToOwner;
54 
55   // @dev A mapping from owner address to count of tokens that address owns.
56   //  Used internally inside balanceOf() to resolve ownership count.
57   mapping (address => uint256) private ownershipTokenCount;
58 
59   /// @dev A mapping from TokenIDs to an address that has been approved to call
60   ///  transferFrom(). Each Token can only have one approved address for transfer
61   ///  at any time. A zero value means no approval is outstanding.
62   mapping (uint256 => address) public tokenIndexToApproved;
63 
64   // @dev A mapping from TokenIDs to the price of the token.
65   mapping (uint256 => uint256) private tokenIndexToPrice;
66 
67   // The addresses of the accounts (or contracts) that can execute actions within each roles.
68   address public ceoAddress;
69   address public cooAddress;
70 
71   uint256 private tokenCreatedCount;
72 
73   /*** DATATYPES ***/
74 
75   struct Token {
76     string name;
77     uint256 parentId;
78   }
79 
80   Token[] private tokens;
81 
82   mapping(uint256 => Token) private tokenIndexToToken;
83 
84   /*** ACCESS MODIFIERS ***/
85   /// @dev Access modifier for CEO-only functionality
86   modifier onlyCEO() {
87     require(msg.sender == ceoAddress);
88     _;
89   }
90 
91   /// @dev Access modifier for COO-only functionality
92   modifier onlyCOO() {
93     require(msg.sender == cooAddress);
94     _;
95   }
96 
97   /// Access modifier for contract owner only functionality
98   modifier onlyCLevel() {
99     require(
100       msg.sender == ceoAddress ||
101       msg.sender == cooAddress
102     );
103     _;
104   }
105 
106   /*** CONSTRUCTOR ***/
107   function CityToken() public {
108     ceoAddress = msg.sender;
109     cooAddress = msg.sender;
110   }
111 
112   /*** PUBLIC FUNCTIONS ***/
113   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
114   /// @param _to The address to be granted transfer approval. Pass address(0) to
115   ///  clear all approvals.
116   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
117   /// @dev Required for ERC-721 compliance.
118   function approve(
119     address _to,
120     uint256 _tokenId
121   ) public {
122     // Caller must own token.
123     require(_owns(msg.sender, _tokenId));
124 
125     tokenIndexToApproved[_tokenId] = _to;
126 
127     Approval(msg.sender, _to, _tokenId);
128   }
129 
130   /// For querying balance of a particular account
131   /// @param _owner The address for balance query
132   /// @dev Required for ERC-721 compliance.
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return ownershipTokenCount[_owner];
135   }
136 
137   /// @dev Creates a new Token with the given name, parentId and price and assigns it to an address.
138   function createToken(uint256 _tokenId, address _owner, string _name, uint256 _parentId, uint256 _price) public onlyCOO {
139 
140     address tokenOwner = _owner;
141     if (tokenOwner == address(0)) {
142       tokenOwner = cooAddress;
143     }
144     
145     if (_price <= 0) {
146       _price = startingPrice;
147     }
148 
149     tokenCreatedCount++;
150     _createToken(_tokenId, _name, _parentId, tokenOwner, _price);
151   }
152 
153 
154   /// @notice Returns all the relevant information about a specific token.
155   /// @param _tokenId The tokenId of the token of interest.
156   function getToken(uint256 _tokenId) public view returns (
157     string tokenName,
158     uint256 parentId,
159     uint256 sellingPrice,
160     address owner
161   ) {
162     Token storage token = tokenIndexToToken[_tokenId];
163 
164     tokenName = token.name;
165     parentId = token.parentId;
166     sellingPrice = tokenIndexToPrice[_tokenId];
167     owner = tokenIndexToOwner[_tokenId];
168   }
169 
170   function implementsERC721() public pure returns (bool) {
171     return true;
172   }
173 
174   /// @dev Required for ERC-721 compliance.
175   function name() public pure returns (string) {
176     return NAME;
177   }
178 
179   /// For querying owner of token
180   /// @param _tokenId The tokenID for owner inquiry
181   /// @dev Required for ERC-721 compliance.
182   function ownerOf(uint256 _tokenId)
183     public
184     view
185     returns (address owner)
186   {
187     owner = tokenIndexToOwner[_tokenId];
188     require(owner != address(0));
189   }
190 
191   function payout(address _to) public onlyCLevel {
192     _payout(_to);
193   }
194 
195   // Alternate function to withdraw less than total balance
196   function withdrawFunds(address _to, uint256 amount) public onlyCLevel {
197     _withdrawFunds(_to, amount);
198   }
199   
200   // Allows someone to send ether and obtain the token
201   function purchase(uint256 _tokenId) public payable {
202     
203     // Token IDs above 999 are for countries
204     if (_tokenId > 999) {
205       _purchaseCountry(_tokenId);
206     }else {
207       _purchaseCity(_tokenId);
208     }
209 
210   }
211 
212   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
213     return tokenIndexToPrice[_tokenId];
214   }
215 
216   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
217   /// @param _newCEO The address of the new CEO
218   function setCEO(address _newCEO) public onlyCEO {
219     require(_newCEO != address(0));
220 
221     ceoAddress = _newCEO;
222   }
223 
224   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
225   /// @param _newCOO The address of the new COO
226   function setCOO(address _newCOO) public onlyCEO {
227     require(_newCOO != address(0));
228 
229     cooAddress = _newCOO;
230   }
231 
232   /// @dev Required for ERC-721 compliance.
233   function symbol() public pure returns (string) {
234     return SYMBOL;
235   }
236 
237   /// @notice Allow pre-approved user to take ownership of a token
238   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
239   /// @dev Required for ERC-721 compliance.
240   function takeOwnership(uint256 _tokenId) public {
241     address newOwner = msg.sender;
242     address oldOwner = tokenIndexToOwner[_tokenId];
243 
244     // Safety check to prevent against an unexpected 0x0 default.
245     require(_addressNotNull(newOwner));
246 
247     // Making sure transfer is approved
248     require(_approved(newOwner, _tokenId));
249 
250     _transfer(oldOwner, newOwner, _tokenId);
251   }
252 
253   /// @param _owner The owner whose city tokens we are interested in.
254   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
255   ///  expensive (it walks the entire Cities array looking for cities belonging to owner),
256   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
257   ///  not contract-to-contract calls.
258   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
259     uint256 tokenCount = balanceOf(_owner);
260     if (tokenCount == 0) {
261         // Return an empty array
262       return new uint256[](0);
263     } else {
264       uint256[] memory result = new uint256[](tokenCount);
265       uint256 totalTokens = totalSupply();
266       uint256 resultIndex = 0;
267 
268       uint256 tokenId;
269       for (tokenId = 0; tokenId <= totalTokens; tokenId++) {
270         if (tokenIndexToOwner[tokenId] == _owner) {
271           result[resultIndex] = tokenId;
272           resultIndex++;
273         }
274       }
275       return result;
276     }
277   }
278 
279   /// For querying totalSupply of token
280   /// @dev Required for ERC-721 compliance.
281   function totalSupply() public view returns (uint256 total) {
282     //return tokens.length;
283     // NOTE: Looks like we can't get the length of mapping data structure
284     //return tokenIndexToToken.length;
285     return tokenCreatedCount;
286   }
287 
288   /// Owner initates the transfer of the token to another account
289   /// @param _to The address for the token to be transferred to.
290   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
291   /// @dev Required for ERC-721 compliance.
292   function transfer(
293     address _to,
294     uint256 _tokenId
295   ) public {
296     require(_owns(msg.sender, _tokenId));
297     require(_addressNotNull(_to));
298 
299     _transfer(msg.sender, _to, _tokenId);
300   }
301 
302   /// Third-party initiates transfer of token from address _from to address _to
303   /// @param _from The address for the token to be transferred from.
304   /// @param _to The address for the token to be transferred to.
305   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
306   /// @dev Required for ERC-721 compliance.
307   function transferFrom(
308     address _from,
309     address _to,
310     uint256 _tokenId
311   ) public {
312     require(_owns(_from, _tokenId));
313     require(_approved(_to, _tokenId));
314     require(_addressNotNull(_to));
315 
316     _transfer(_from, _to, _tokenId);
317   }
318 
319   /*** PRIVATE FUNCTIONS ***/
320 
321   function _purchaseCity(uint256 _tokenId) private {
322 
323      address oldOwner = tokenIndexToOwner[_tokenId];
324 
325     // Using msg.sender instead of creating a new var because we have too many vars
326     //address newOwner = msg.sender;
327 
328     uint256 sellingPrice = tokenIndexToPrice[_tokenId];
329 
330     // Making sure token owner is not sending to self
331     require(oldOwner != msg.sender);
332 
333     // Safety check to prevent against an unexpected 0x0 default.
334     require(_addressNotNull(msg.sender));
335 
336     // Making sure sent amount is greater than or equal to the sellingPrice
337     require(msg.value >= sellingPrice);
338 
339     // Payment to previous owner should be 92% of sellingPrice
340     // The other 8% is the 6% dev fee (stays in contract) and 2% Country dividend (goes to Country owner)
341     // If Country does not exist yet then we add that 2% to what the previous owner gets
342     // Formula: sellingPrice * 92 / 100
343     // Same as: sellingPrice * .92 / 1
344     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
345 
346     // Get parentId of token
347     uint256 parentId = tokenIndexToToken[_tokenId].parentId;
348 
349     // Get owner address of parent
350     address ownerOfParent = tokenIndexToOwner[parentId];
351 
352     // Calculate 2% of selling price
353     uint256 paymentToOwnerOfParent = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 2), 100));
354 
355     // If we have an address for parentId
356     // If not that means parent hasn't been created yet
357     // For example the city may exist but we haven't created its country yet
358     // Parent ID must also be bigger than the 0-999 range of city ids ...
359     // ... since a city can't be a parent of another city
360     if (_addressNotNull(ownerOfParent)) {
361 
362       // Send 2% dividends to owner of parent
363       ownerOfParent.transfer(paymentToOwnerOfParent);
364       
365     } else {
366 
367       // If no parent owner then update payment to previous owner to include paymentToOwnerOfParent
368       payment = SafeMath.add(payment, paymentToOwnerOfParent);
369      
370     }
371 
372     // Get amount over purchase price they paid so that we can send it back to them
373     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
374 
375     // Update price so that when 8% is taken out (dev fee + Country dividend) ...
376     // ... the owner gets 20% over their investment
377     tokenIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
378     
379     _transfer(oldOwner, msg.sender, _tokenId);
380 
381     // Pay previous tokenOwner if owner is not contract
382     if (oldOwner != address(this)) {
383       oldOwner.transfer(payment);
384     }
385     
386     TokenSold(_tokenId, sellingPrice, tokenIndexToPrice[_tokenId], oldOwner, msg.sender, tokenIndexToToken[_tokenId].name, parentId);
387 
388     msg.sender.transfer(purchaseExcess);
389   }
390 
391   function _purchaseCountry(uint256 _tokenId) private {
392 
393     address oldOwner = tokenIndexToOwner[_tokenId];
394 
395     uint256 sellingPrice = tokenIndexToPrice[_tokenId];
396 
397     // Making sure token owner is not sending to self
398     require(oldOwner != msg.sender);
399 
400     // Safety check to prevent against an unexpected 0x0 default.
401     require(_addressNotNull(msg.sender));
402 
403     // Making sure sent amount is greater than or equal to the sellingPrice
404     require(msg.value >= sellingPrice);
405 
406     // Payment to previous owner should be 96% of sellingPrice
407     // The other 4% is the dev fee (stays in contract) 
408     // Formula: sellingPrice * 96 / 10
409     // Same as: sellingPrice * .96 / 1
410     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 96), 100));
411 
412     // Get amount over purchase price they paid so that we can send it back to them
413     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
414 
415     // Update price so that when 4% is taken out (dev fee) ...
416     // ... the owner gets 15% over their investment
417     tokenIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 96);
418     
419     _transfer(oldOwner, msg.sender, _tokenId);
420 
421     // Pay previous tokenOwner if owner is not contract
422     if (oldOwner != address(this)) {
423       oldOwner.transfer(payment);
424     }
425     
426     TokenSold(_tokenId, sellingPrice, tokenIndexToPrice[_tokenId], oldOwner, msg.sender, tokenIndexToToken[_tokenId].name, 0);
427 
428     msg.sender.transfer(purchaseExcess);
429   }
430 
431 
432   /// Safety check on _to address to prevent against an unexpected 0x0 default.
433   function _addressNotNull(address _to) private pure returns (bool) {
434     return _to != address(0);
435   }
436 
437   /// For checking approval of transfer for address _to
438   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
439     return tokenIndexToApproved[_tokenId] == _to;
440   }
441 
442 
443   /// For creating City
444   function _createToken(uint256 _tokenId, string _name, uint256 _parentId, address _owner, uint256 _price) private {
445     
446     Token memory _token = Token({
447       name: _name,
448       parentId: _parentId
449     });
450 
451     // Rather than increment we need to be able to pass in any tokenId
452     // Necessary if we are going to decide on parentIds ahead of time when creating cities ...
453     // ... and then creating the parent tokens (countries) later
454     //uint256 newTokenId = tokens.push(_token) - 1;
455     uint256 newTokenId = _tokenId;
456     tokenIndexToToken[newTokenId] = _token;
457 
458     // NOTE: Now that we don't autoincrement tokenId should we ...
459     // ... check to make sure passed _tokenId arg doesn't already exist?
460     
461     // It's probably never going to happen, 4 billion tokens are A LOT, but
462     // let's just be 100% sure we never let this happen.
463     require(newTokenId == uint256(uint32(newTokenId)));
464 
465     TokenCreated(newTokenId, _name, _parentId, _owner);
466 
467     tokenIndexToPrice[newTokenId] = _price;
468 
469     // This will assign ownership, and also emit the Transfer event as
470     // per ERC721 draft
471     _transfer(address(0), _owner, newTokenId);
472   }
473 
474   /// Check for token ownership
475   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
476     return claimant == tokenIndexToOwner[_tokenId];
477   }
478 
479   /// For paying out balance on contract
480   function _payout(address _to) private {
481     if (_to == address(0)) {
482       ceoAddress.transfer(this.balance);
483     } else {
484       _to.transfer(this.balance);
485     }
486   }
487 
488   // Alternate function to withdraw less than total balance
489   function _withdrawFunds(address _to, uint256 amount) private {
490     require(this.balance >= amount);
491     if (_to == address(0)) {
492       ceoAddress.transfer(amount);
493     } else {
494       _to.transfer(amount);
495     }
496   }
497 
498   /// @dev Assigns ownership of a specific City to an address.
499   function _transfer(address _from, address _to, uint256 _tokenId) private {
500     // Since the number of cities is capped to 2^32 we can't overflow this
501     ownershipTokenCount[_to]++;
502     //transfer ownership
503     tokenIndexToOwner[_tokenId] = _to;
504 
505     // When creating new cities _from is 0x0, but we can't account that address.
506     if (_from != address(0)) {
507       ownershipTokenCount[_from]--;
508       // clear any previously approved ownership exchange
509       delete tokenIndexToApproved[_tokenId];
510     }
511 
512     // Emit the transfer event.
513     Transfer(_from, _to, _tokenId);
514   }
515 }
516 library SafeMath {
517 
518   /**
519   * @dev Multiplies two numbers, throws on overflow.
520   */
521   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
522     if (a == 0) {
523       return 0;
524     }
525     uint256 c = a * b;
526     assert(c / a == b);
527     return c;
528   }
529 
530   /**
531   * @dev Integer division of two numbers, truncating the quotient.
532   */
533   function div(uint256 a, uint256 b) internal pure returns (uint256) {
534     // assert(b > 0); // Solidity automatically throws when dividing by 0
535     uint256 c = a / b;
536     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
537     return c;
538   }
539 
540   /**
541   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
542   */
543   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
544     assert(b <= a);
545     return a - b;
546   }
547 
548   /**
549   * @dev Adds two numbers, throws on overflow.
550   */
551   function add(uint256 a, uint256 b) internal pure returns (uint256) {
552     uint256 c = a + b;
553     assert(c >= a);
554     return c;
555   }
556 }