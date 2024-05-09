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
21 }
22 
23 contract CryptoAllStars is ERC721 {
24 
25   /*** EVENTS ***/
26 
27   /// @dev The Birth event is fired whenever a new all stars comes into existence.
28   event Birth(uint256 tokenId, string name, address owner);
29 
30   /// @dev The TokenSold event is fired whenever a token is sold.
31   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
32 
33   /// @dev Transfer event as defined in current draft of ERC721. 
34   ///  ownership is assigned, including births.
35   event Transfer(address from, address to, uint256 tokenId);
36 
37   /*** CONSTANTS ***/
38 
39   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
40   string public constant NAME = "CryptoAllStars"; // solhint-disable-line
41   string public constant SYMBOL = "AllStarToken"; // solhint-disable-line
42 
43   uint256 private startingPrice = 0.001 ether;
44   uint256 private constant PROMO_CREATION_LIMIT = 10000;
45   uint256 private firstStepLimit =  0.053613 ether;
46   uint256 private secondStepLimit = 0.564957 ether;
47 
48   uint public currentGen = 0;
49 
50   /*** STORAGE ***/
51 
52   /// @dev A mapping from all stars IDs to the address that owns them. All all stars have
53   ///  some valid owner address.
54   mapping (uint256 => address) public allStarIndexToOwner;
55 
56   // @dev A mapping from owner address to count of tokens that address owns.
57   //  Used internally inside balanceOf() to resolve ownership count.
58   mapping (address => uint256) private ownershipTokenCount;
59 
60   /// @dev A mapping from allStarIDs to an address that has been approved to call
61   ///  transferFrom(). Each All Star can only have one approved address for transfer
62   ///  at any time. A zero value means no approval is outstanding.
63   mapping (uint256 => address) public allStarIndexToApproved;
64 
65   // @dev A mapping from AllStarIDs to the price of the token.
66   mapping (uint256 => uint256) private allStarIndexToPrice;
67 
68   // The addresses of the accounts (or contracts) that can execute actions within each roles.
69   address public ceo = 0x047F606fD5b2BaA5f5C6c4aB8958E45CB6B054B7;
70   address public cfo = 0xed8eFE0C11E7f13Be0B9d2CD5A675095739664d6;
71 
72   uint256 public promoCreatedCount;
73 
74   /*** DATATYPES ***/
75   struct AllStar {
76     string name;
77     uint gen;
78   }
79 
80   AllStar[] private allStars;
81 
82   /*** ACCESS MODIFIERS ***/
83   /// @dev Access modifier for owner only functionality
84   modifier onlyCeo() {
85     require(msg.sender == ceo);
86     _;
87   }
88 
89   modifier onlyManagement() {
90     require(msg.sender == ceo || msg.sender == cfo);
91     _;
92   }
93 
94   //changes the current gen of all stars by importance
95   function evolveGeneration(uint _newGen) public onlyManagement {
96     currentGen = _newGen;
97   }
98  
99   /*** CONSTRUCTOR ***/
100   // function CryptoAllStars() public {
101   //   owner = msg.sender;
102   // }
103 
104   /*** PUBLIC FUNCTIONS ***/
105   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
106   /// @param _to The address to be granted transfer approval. Pass address(0) to
107   ///  clear all approvals.
108   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
109   /// @dev Required for ERC-721 compliance.
110   function approve(
111     address _to,
112     uint256 _tokenId
113   ) public {
114     // Caller must own token.
115     require(_owns(msg.sender, _tokenId));
116 
117     allStarIndexToApproved[_tokenId] = _to;
118 
119     Approval(msg.sender, _to, _tokenId);
120   }
121 
122   /// For querying balance of a particular account
123   /// @param _owner The address for balance query
124   /// @dev Required for ERC-721 compliance.
125   function balanceOf(address _owner) public view returns (uint256 balance) {
126     return ownershipTokenCount[_owner];
127   }
128 
129   /// @dev Creates a new promo AllStar with the given name, with given _price and assignes it to an address.
130   function createPromoAllStar(address _owner, string _name, uint256 _price) public onlyCeo {
131     require(promoCreatedCount < PROMO_CREATION_LIMIT);
132 
133     address allStarOwner = _owner;
134     if (allStarOwner == address(0)) {
135       allStarOwner = ceo;
136     }
137 
138     if (_price <= 0) {
139       _price = startingPrice;
140     }
141 
142     promoCreatedCount++;
143     _createAllStar(_name, allStarOwner, _price);
144   }
145 
146   /// @dev Creates a new AllStar with the given name.
147   function createContractAllStar(string _name) public onlyCeo {
148     _createAllStar(_name, msg.sender, startingPrice );
149   }
150 
151   /// @notice Returns all the relevant information about a specific AllStar.
152   /// @param _tokenId The tokenId of the All Star of interest.
153   function getAllStar(uint256 _tokenId) public view returns (
154     string allStarName,
155     uint allStarGen,
156     uint256 sellingPrice,
157     address owner
158   ) {
159     AllStar storage allStar = allStars[_tokenId];
160     allStarName = allStar.name;
161     allStarGen = allStar.gen;
162     sellingPrice = allStarIndexToPrice[_tokenId];
163     owner = allStarIndexToOwner[_tokenId];
164   }
165 
166   function implementsERC721() public pure returns (bool) {
167     return true;
168   }
169 
170   /// @dev Required for ERC-721 compliance.
171   function name() public pure returns (string) {
172     return NAME;
173   }
174 
175   /// For querying owner of token
176   /// @param _tokenId The tokenID for owner inquiry
177   /// @dev Required for ERC-721 compliance.
178   function ownerOf(uint256 _tokenId)
179     public
180     view
181     returns (address owner)
182   {
183     owner = allStarIndexToOwner[_tokenId];
184     require(owner != address(0));
185   }
186 
187   function payout() public onlyManagement {
188     _payout();
189   }
190 
191   // Allows someone to send ether and obtain the token
192   function purchase(uint256 _tokenId) public payable {
193     address oldOwner = allStarIndexToOwner[_tokenId];
194     address newOwner = msg.sender;
195 
196     uint256 sellingPrice = allStarIndexToPrice[_tokenId];
197 
198     // Making sure token owner is not sending to self
199     require(oldOwner != newOwner);
200 
201     // Safety check to prevent against an unexpected 0x0 default.
202     require(_addressNotNull(newOwner));
203 
204     // Making sure sent amount is greater than or equal to the sellingPrice
205     require(msg.value >= sellingPrice);
206 
207     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
208     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
209 
210       // Update prices
211     if (sellingPrice < firstStepLimit) {
212       // first stage
213       allStarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
214     } else if (sellingPrice < secondStepLimit) {
215       // second stage
216       allStarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
217     } else {
218       // third stage
219       allStarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
220     }
221 
222     _transfer(oldOwner, newOwner, _tokenId);
223 
224     // Pay previous tokenOwner if owner is not contract
225     if (oldOwner != address(this)) {
226       oldOwner.transfer(payment); //(1-0.06)
227     }
228 
229     TokenSold(_tokenId, sellingPrice, allStarIndexToPrice[_tokenId], oldOwner, newOwner, allStars[_tokenId].name);
230 
231     msg.sender.transfer(purchaseExcess);
232   }
233 
234   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
235     return allStarIndexToPrice[_tokenId];
236   }
237 
238   /// @dev Assigns a new address to act as the owner. Only available to the current owner.
239   /// @param _newOwner The address of the new owner
240   function setOwner(address _newOwner) public onlyCeo {
241     require(_newOwner != address(0));
242 
243     ceo = _newOwner;
244   }
245 
246    function setCFO(address _newCFO) public onlyCeo {
247     require(_newCFO != address(0));
248 
249     cfo = _newCFO;
250   }
251 
252 
253   /// @dev Required for ERC-721 compliance.
254   function symbol() public pure returns (string) {
255     return SYMBOL;
256   }
257 
258   /// @notice Allow pre-approved user to take ownership of a token
259   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
260   /// @dev Required for ERC-721 compliance.
261   function takeOwnership(uint256 _tokenId) public {
262     address newOwner = msg.sender;
263     address oldOwner = allStarIndexToOwner[_tokenId];
264 
265     // Safety check to prevent against an unexpected 0x0 default.
266     require(_addressNotNull(newOwner));
267 
268     // Making sure transfer is approved
269     require(_approved(newOwner, _tokenId));
270 
271     _transfer(oldOwner, newOwner, _tokenId);
272   }
273 
274 
275   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
276     uint256 tokenCount = balanceOf(_owner);
277     if (tokenCount == 0) {
278         // Return an empty array
279       return new uint256[](0);
280     } else {
281       uint256[] memory result = new uint256[](tokenCount);
282       uint256 totalAllStars = totalSupply();
283       uint256 resultIndex = 0;
284 
285       uint256 allStarId;
286       for (allStarId = 0; allStarId <= totalAllStars; allStarId++) {
287         if (allStarIndexToOwner[allStarId] == _owner) {
288           result[resultIndex] = allStarId;
289           resultIndex++;
290         }
291       }
292       return result;
293     }
294   }
295 
296   /// For querying totalSupply of token
297   /// @dev Required for ERC-721 compliance.
298   function totalSupply() public view returns (uint256 total) {
299     return allStars.length;
300   }
301 
302   /// Owner initates the transfer of the token to another account
303   /// @param _to The address for the token to be transferred to.
304   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
305   /// @dev Required for ERC-721 compliance.
306   function transfer(
307     address _to,
308     uint256 _tokenId
309   ) public {
310     require(_owns(msg.sender, _tokenId));
311     require(_addressNotNull(_to));
312 
313     _transfer(msg.sender, _to, _tokenId);
314   }
315 
316   /// Third-party initiates transfer of token from address _from to address _to
317   /// @param _from The address for the token to be transferred from.
318   /// @param _to The address for the token to be transferred to.
319   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
320   /// @dev Required for ERC-721 compliance.
321   function transferFrom(
322     address _from,
323     address _to,
324     uint256 _tokenId
325   ) public {
326     require(_owns(_from, _tokenId));
327     require(_approved(_to, _tokenId));
328     require(_addressNotNull(_to));
329 
330     _transfer(_from, _to, _tokenId);
331   }
332 
333   /*** PRIVATE FUNCTIONS ***/
334   /// Safety check on _to address to prevent against an unexpected 0x0 default.
335   function _addressNotNull(address _to) private pure returns (bool) {
336     return _to != address(0);
337   }
338 
339   /// For checking approval of transfer for address _to
340   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
341     return allStarIndexToApproved[_tokenId] == _to;
342   }
343 
344   /// For creating All Stars
345   function _createAllStar(string _name, address _owner, uint256 _price) private {
346     AllStar memory _allStar = AllStar({
347       name: _name,
348       gen: currentGen
349     });
350     uint256 newAllStarId = allStars.push(_allStar) - 1;
351 
352     // It's probably never going to happen, 4 billion tokens are A LOT, but
353     // let's just be 100% sure we never let this happen.
354     require(newAllStarId == uint256(uint32(newAllStarId)));
355 
356     Birth(newAllStarId, _name, _owner);
357 
358     allStarIndexToPrice[newAllStarId] = _price;
359 
360     // This will assign ownership, and also emit the Transfer event as
361     // per ERC721 draft
362     _transfer(address(0), _owner, newAllStarId);
363   }
364 
365   /// Check for token ownership
366   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
367     return claimant == allStarIndexToOwner[_tokenId];
368   }
369 
370   /// For paying out balance on contract
371   function _payout() private {
372       uint blnc = this.balance;
373       ceo.transfer(SafeMath.div(SafeMath.mul(blnc, 75), 100));
374       cfo.transfer(SafeMath.div(SafeMath.mul(blnc, 25), 100));
375     
376   }
377 
378   /// @dev Assigns ownership of a specific All Star to an address.
379   function _transfer(address _from, address _to, uint256 _tokenId) private {
380     // Since the number of all stars is capped to 2^32 we can't overflow this
381     ownershipTokenCount[_to]++;
382     //transfer ownership
383     allStarIndexToOwner[_tokenId] = _to;
384 
385     // When creating new all stars _from is 0x0, but we can't account that address.
386     if (_from != address(0)) {
387       ownershipTokenCount[_from]--;
388       // clear any previously approved ownership exchange
389       delete allStarIndexToApproved[_tokenId];
390     }
391 
392     // Emit the transfer event.
393     Transfer(_from, _to, _tokenId);
394   }
395 }
396 library SafeMath {
397 
398   /**
399   * @dev Multiplies two numbers, throws on overflow.
400   */
401   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
402     if (a == 0) {
403       return 0;
404     }
405     uint256 c = a * b;
406     assert(c / a == b);
407     return c;
408   }
409 
410   /**
411   * @dev Integer division of two numbers, truncating the quotient.
412   */
413   function div(uint256 a, uint256 b) internal pure returns (uint256) {
414     // assert(b > 0); // Solidity automatically throws when dividing by 0
415     uint256 c = a / b;
416     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
417     return c;
418   }
419 
420   /**
421   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
422   */
423   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
424     assert(b <= a);
425     return a - b;
426   }
427 
428   /**
429   * @dev Adds two numbers, throws on overflow.
430   */
431   function add(uint256 a, uint256 b) internal pure returns (uint256) {
432     uint256 c = a + b;
433     assert(c >= a);
434     return c;
435   }
436 }