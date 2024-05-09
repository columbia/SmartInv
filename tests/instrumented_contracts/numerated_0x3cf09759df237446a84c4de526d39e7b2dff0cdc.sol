1 pragma solidity ^0.4.18;
2 
3 /// Greys :3
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
29 /// And again modified from the EmojiBlockhain contract
30 contract EtherGrey is ERC721 {
31 
32   /*** EVENTS ***/
33 
34   /// @dev The Birth event is fired whenever a new grey comes into existence.
35   event Birth(uint256 tokenId, string name, address owner);
36 
37   /// @dev The TokenSold event is fired whenever a token is sold.
38   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
39 
40   /// @dev Transfer event as defined in current draft of ERC721.
41   ///  ownership is assigned, including births.
42   event Transfer(address from, address to, uint256 tokenId);
43 
44   /*** CONSTANTS ***/
45   uint256 private startingPrice = 0.001 ether;
46 
47   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
48   string public constant NAME = "EtherGreys"; // solhint-disable-line
49   string public constant SYMBOL = "EtherGrey"; // solhint-disable-line
50 
51   /*** STORAGE ***/
52 
53   /// @dev A mapping from grey IDs to the address that owns them. All greys have
54   ///  some valid owner address.
55   mapping (uint256 => address) public greyIndexToOwner;
56 
57   // @dev A mapping from owner address to count of tokens that address owns.
58   //  Used internally inside balanceOf() to resolve ownership count.
59   mapping (address => uint256) private ownershipTokenCount;
60 
61   /// @dev A mapping from GreyIDs to an address that has been approved to call
62   ///  transferFrom(). Each Grey can only have one approved address for transfer
63   ///  at any time. A zero value means no approval is outstanding.
64   mapping (uint256 => address) public greyIndexToApproved;
65 
66   // @dev A mapping from GreyIDs to the price of the token.
67   mapping (uint256 => uint256) private greyIndexToPrice;
68 
69   /// @dev A mapping from GreyIDs to the previpus price of the token. Used
70   /// to calculate price delta for payouts
71   mapping (uint256 => uint256) private greyIndexToPreviousPrice;
72 
73   // @dev A mapping from greyId to the 7 last owners.
74   mapping (uint256 => address[5]) private greyIndexToPreviousOwners;
75 
76 
77   // The addresses of the accounts (or contracts) that can execute actions within each roles.
78   address public ceoAddress;
79   address public cooAddress;
80 
81   /*** DATATYPES ***/
82   struct Grey {
83     string name;
84   }
85 
86   Grey[] private greys;
87 
88   /*** ACCESS MODIFIERS ***/
89   /// @dev Access modifier for CEO-only functionality
90   modifier onlyCEO() {
91     require(msg.sender == ceoAddress);
92     _;
93   }
94 
95   /// @dev Access modifier for COO-only functionality
96   modifier onlyCOO() {
97     require(msg.sender == cooAddress);
98     _;
99   }
100 
101   /// Access modifier for contract owner only functionality
102   modifier onlyCLevel() {
103     require(
104       msg.sender == ceoAddress ||
105       msg.sender == cooAddress
106     );
107     _;
108   }
109 
110   /*** CONSTRUCTOR ***/
111   function EtherGrey() public {
112     ceoAddress = msg.sender;
113     cooAddress = msg.sender;
114   }
115 
116   /*** PUBLIC FUNCTIONS ***/
117   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
118   /// @param _to The address to be granted transfer approval. Pass address(0) to
119   ///  clear all approvals.
120   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
121   /// @dev Required for ERC-721 compliance.
122   function approve(
123     address _to,
124     uint256 _tokenId
125   ) public {
126     // Caller must own token.
127     require(_owns(msg.sender, _tokenId));
128 
129     greyIndexToApproved[_tokenId] = _to;
130 
131     Approval(msg.sender, _to, _tokenId);
132   }
133 
134   /// For querying balance of a particular account
135   /// @param _owner The address for balance query
136   /// @dev Required for ERC-721 compliance.
137   function balanceOf(address _owner) public view returns (uint256 balance) {
138     return ownershipTokenCount[_owner];
139   }
140 
141   /// @dev Creates a new Grey with the given name.
142   function createContractGrey(string _name) public onlyCOO {
143     _createGrey(_name, address(this), startingPrice);
144   }
145 
146   /// @notice Returns all the relevant information about a specific grey.
147   /// @param _tokenId The tokenId of the grey of interest.
148   function getGrey(uint256 _tokenId) public view returns (
149     string greyName,
150     uint256 sellingPrice,
151     address owner,
152     uint256 previousPrice,
153     address[5] previousOwners
154   ) {
155     Grey storage grey = greys[_tokenId];
156     greyName = grey.name;
157     sellingPrice = greyIndexToPrice[_tokenId];
158     owner = greyIndexToOwner[_tokenId];
159     previousPrice = greyIndexToPreviousPrice[_tokenId];
160     previousOwners = greyIndexToPreviousOwners[_tokenId];
161   }
162 
163   function implementsERC721() public pure returns (bool) {
164     return true;
165   }
166 
167   /// @dev Required for ERC-721 compliance.
168   function name() public pure returns (string) {
169     return NAME;
170   }
171 
172   /// For querying owner of token
173   /// @param _tokenId The tokenID for owner inquiry
174   /// @dev Required for ERC-721 compliance.
175   function ownerOf(uint256 _tokenId)
176     public
177     view
178     returns (address owner)
179   {
180     owner = greyIndexToOwner[_tokenId];
181     require(owner != address(0));
182   }
183 
184   function payout(address _to) public onlyCLevel {
185     _payout(_to);
186   }
187 
188   // Allows someone to send ether and obtain the token
189   function purchase(uint256 _tokenId) public payable {
190     address oldOwner = greyIndexToOwner[_tokenId];
191     address newOwner = msg.sender;
192 
193     address[5] storage previousOwners = greyIndexToPreviousOwners[_tokenId];
194 
195     uint256 sellingPrice = greyIndexToPrice[_tokenId];
196     uint256 previousPrice = greyIndexToPreviousPrice[_tokenId];
197     // Making sure token owner is not sending to self
198     require(oldOwner != newOwner);
199 
200     // Safety check to prevent against an unexpected 0x0 default.
201     require(_addressNotNull(newOwner));
202 
203     // Making sure sent amount is greater than or equal to the sellingPrice
204     require(msg.value >= sellingPrice);
205 
206     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
207     uint256 ownerPayout = SafeMath.add(previousPrice, SafeMath.mul(SafeMath.div(priceDelta, 100), 40));
208     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
209 
210     greyIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
211     greyIndexToPreviousPrice[_tokenId] = sellingPrice;
212 
213     uint256 strangePrice = uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100));
214     // Pay previous tokenOwner if owner is not contract
215     // and if previous price is not 0
216     if (oldOwner != address(this)) {
217       // old owner gets entire initial payment back
218       oldOwner.transfer(ownerPayout);
219     } else {
220       strangePrice = SafeMath.add(ownerPayout, strangePrice);
221     }
222 
223     // Next distribute payout Total among previous Owners
224     for (uint i = 0; i <= 5; i++) {
225         if (previousOwners[i] != address(this)) {
226             previousOwners[i].transfer(uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100)));
227         } else {
228             strangePrice = SafeMath.add(strangePrice, uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100)));
229         }
230     }
231     ceoAddress.transfer(strangePrice);
232 
233     _transfer(oldOwner, newOwner, _tokenId);
234 
235     //TokenSold(_tokenId, sellingPrice, greyIndexToPrice[_tokenId], oldOwner, newOwner, greys[_tokenId].name);
236 
237     msg.sender.transfer(purchaseExcess);
238   }
239 
240   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
241     return greyIndexToPrice[_tokenId];
242   }
243 
244   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
245   /// @param _newCEO The address of the new CEO
246   function setCEO(address _newCEO) public onlyCEO {
247     require(_newCEO != address(0));
248 
249     ceoAddress = _newCEO;
250   }
251 
252   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
253   /// @param _newCOO The address of the new COO
254   function setCOO(address _newCOO) public onlyCEO {
255     require(_newCOO != address(0));
256     cooAddress = _newCOO;
257   }
258 
259   /// @dev Required for ERC-721 compliance.
260   function symbol() public pure returns (string) {
261     return SYMBOL;
262   }
263 
264   /// @notice Allow pre-approved user to take ownership of a token
265   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
266   /// @dev Required for ERC-721 compliance.
267   function takeOwnership(uint256 _tokenId) public {
268     address newOwner = msg.sender;
269     address oldOwner = greyIndexToOwner[_tokenId];
270 
271     // Safety check to prevent against an unexpected 0x0 default.
272     require(_addressNotNull(newOwner));
273 
274     // Making sure transfer is approved
275     require(_approved(newOwner, _tokenId));
276 
277     _transfer(oldOwner, newOwner, _tokenId);
278   }
279 
280   /// @param _owner The owner whose grey tokens we are interested in.
281   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
282   ///  expensive (it walks the entire Greys array looking for greys belonging to owner),
283   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
284   ///  not contract-to-contract calls.
285   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
286     uint256 tokenCount = balanceOf(_owner);
287     if (tokenCount == 0) {
288         // Return an empty array
289       return new uint256[](0);
290     } else {
291       uint256[] memory result = new uint256[](tokenCount);
292       uint256 totalGreys = totalSupply();
293       uint256 resultIndex = 0;
294       uint256 greyId;
295       for (greyId = 0; greyId <= totalGreys; greyId++) {
296         if (greyIndexToOwner[greyId] == _owner) {
297           result[resultIndex] = greyId;
298           resultIndex++;
299         }
300       }
301       return result;
302     }
303   }
304 
305   /// For querying totalSupply of token
306   /// @dev Required for ERC-721 compliance.
307   function totalSupply() public view returns (uint256 total) {
308     return greys.length;
309   }
310 
311   /// Owner initates the transfer of the token to another account
312   /// @param _to The address for the token to be transferred to.
313   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
314   /// @dev Required for ERC-721 compliance.
315   function transfer(
316     address _to,
317     uint256 _tokenId
318   ) public {
319     require(_owns(msg.sender, _tokenId));
320     require(_addressNotNull(_to));
321     _transfer(msg.sender, _to, _tokenId);
322   }
323 
324   /// Third-party initiates transfer of token from address _from to address _to
325   /// @param _from The address for the token to be transferred from.
326   /// @param _to The address for the token to be transferred to.
327   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
328   /// @dev Required for ERC-721 compliance.
329   function transferFrom(
330     address _from,
331     address _to,
332     uint256 _tokenId
333   ) public {
334     require(_owns(_from, _tokenId));
335     require(_approved(_to, _tokenId));
336     require(_addressNotNull(_to));
337     _transfer(_from, _to, _tokenId);
338   }
339 
340   /*** PRIVATE FUNCTIONS ***/
341   /// Safety check on _to address to prevent against an unexpected 0x0 default.
342   function _addressNotNull(address _to) private pure returns (bool) {
343     return _to != address(0);
344   }
345 
346   /// For checking approval of transfer for address _to
347   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
348     return greyIndexToApproved[_tokenId] == _to;
349   }
350 
351   /// For creating Grey
352   function _createGrey(string _name, address _owner, uint256 _price) private {
353     Grey memory _grey = Grey({
354       name: _name
355     });
356     uint256 newGreyId = greys.push(_grey) - 1;
357 
358     // It's probably never going to happen, 4 billion tokens are A LOT, but
359     // let's just be 100% sure we never let this happen.
360     require(newGreyId == uint256(uint32(newGreyId)));
361 
362     Birth(newGreyId, _name, _owner);
363 
364     greyIndexToPrice[newGreyId] = _price;
365     greyIndexToPreviousPrice[newGreyId] = 0;
366     greyIndexToPreviousOwners[newGreyId] =
367         [address(this), address(this), address(this), address(this)];
368 
369     // This will assign ownership, and also emit the Transfer event as
370     // per ERC721 draft
371     _transfer(address(0), _owner, newGreyId);
372   }
373 
374   /// Check for token ownership
375   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
376     return claimant == greyIndexToOwner[_tokenId];
377   }
378 
379   /// For paying out balance on contract
380   function _payout(address _to) private {
381     if (_to == address(0)) {
382       ceoAddress.transfer(this.balance);
383     } else {
384       _to.transfer(this.balance);
385     }
386   }
387 
388   /// @dev Assigns ownership of a specific Grey to an address.
389   function _transfer(address _from, address _to, uint256 _tokenId) private {
390     // Since the number of greys is capped to 2^32 we can't overflow this
391     ownershipTokenCount[_to]++;
392     //transfer ownership
393     greyIndexToOwner[_tokenId] = _to;
394     // When creating new greys _from is 0x0, but we can't account that address.
395     if (_from != address(0)) {
396       ownershipTokenCount[_from]--;
397       // clear any previously approved ownership exchange
398       delete greyIndexToApproved[_tokenId];
399     }
400     // Update the greyIndexToPreviousOwners
401     greyIndexToPreviousOwners[_tokenId][4]=greyIndexToPreviousOwners[_tokenId][3];
402     greyIndexToPreviousOwners[_tokenId][3]=greyIndexToPreviousOwners[_tokenId][2];
403     greyIndexToPreviousOwners[_tokenId][2]=greyIndexToPreviousOwners[_tokenId][1];
404     greyIndexToPreviousOwners[_tokenId][1]=greyIndexToPreviousOwners[_tokenId][0];
405     // the _from address for creation is 0, so instead set it to the contract address
406     if (_from != address(0)) {
407         greyIndexToPreviousOwners[_tokenId][0]=_from;
408     } else {
409         greyIndexToPreviousOwners[_tokenId][0]=address(this);
410     }
411     // Emit the transfer event.
412     Transfer(_from, _to, _tokenId);
413   }
414 }
415 library SafeMath {
416 
417   /**
418   * @dev Multiplies two numbers, throws on overflow.
419   */
420   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
421     if (a == 0) {
422       return 0;
423     }
424     uint256 c = a * b;
425     assert(c / a == b);
426     return c;
427   }
428 
429   /**
430   * @dev Integer division of two numbers, truncating the quotient.
431   */
432   function div(uint256 a, uint256 b) internal pure returns (uint256) {
433     // assert(b > 0); // Solidity automatically throws when dividing by 0
434     uint256 c = a / b;
435     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
436     return c;
437   }
438 
439   /**
440   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
441   */
442   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443     assert(b <= a);
444     return a - b;
445   }
446 
447   /**
448   * @dev Adds two numbers, throws on overflow.
449   */
450   function add(uint256 a, uint256 b) internal pure returns (uint256) {
451     uint256 c = a + b;
452     assert(c >= a);
453     return c;
454   }
455 }