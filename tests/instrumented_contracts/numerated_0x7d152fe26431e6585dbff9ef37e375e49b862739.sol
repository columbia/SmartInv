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
46   uint public currentGen = 0;
47 
48   /*** STORAGE ***/
49 
50   /// @dev A mapping from all stars IDs to the address that owns them. All all stars have
51   ///  some valid owner address.
52   mapping (uint256 => address) public allStarIndexToOwner;
53 
54   // @dev A mapping from owner address to count of tokens that address owns.
55   //  Used internally inside balanceOf() to resolve ownership count.
56   mapping (address => uint256) private ownershipTokenCount;
57 
58   /// @dev A mapping from allStarIDs to an address that has been approved to call
59   ///  transferFrom(). Each All Star can only have one approved address for transfer
60   ///  at any time. A zero value means no approval is outstanding.
61   mapping (uint256 => address) public allStarIndexToApproved;
62 
63   // @dev A mapping from AllStarIDs to the price of the token.
64   mapping (uint256 => uint256) private allStarIndexToPrice;
65 
66   // The addresses of the accounts (or contracts) that can execute actions within each roles.
67   address public ceo = 0x047F606fD5b2BaA5f5C6c4aB8958E45CB6B054B7;
68   address public cfo = 0xed8eFE0C11E7f13Be0B9d2CD5A675095739664d6;
69 
70   uint256 public promoCreatedCount;
71 
72   /*** DATATYPES ***/
73   struct AllStar {
74     string name;
75     uint gen;
76   }
77 
78   AllStar[] private allStars;
79 
80   /*** ACCESS MODIFIERS ***/
81   /// @dev Access modifier for owner only functionality
82   modifier onlyCeo() {
83     require(msg.sender == ceo);
84     _;
85   }
86 
87   modifier onlyManagement() {
88     require(msg.sender == ceo || msg.sender == cfo);
89     _;
90   }
91 
92   //changes the current gen of all stars by importance
93   function evolveGeneration(uint _newGen) public onlyManagement {
94     currentGen = _newGen;
95   }
96  
97   /*** CONSTRUCTOR ***/
98   // function CryptoAllStars() public {
99   //   owner = msg.sender;
100   // }
101 
102   /*** PUBLIC FUNCTIONS ***/
103   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
104   /// @param _to The address to be granted transfer approval. Pass address(0) to
105   ///  clear all approvals.
106   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
107   /// @dev Required for ERC-721 compliance.
108   function approve(
109     address _to,
110     uint256 _tokenId
111   ) public {
112     // Caller must own token.
113     require(_owns(msg.sender, _tokenId));
114 
115     allStarIndexToApproved[_tokenId] = _to;
116 
117     Approval(msg.sender, _to, _tokenId);
118   }
119 
120   /// For querying balance of a particular account
121   /// @param _owner The address for balance query
122   /// @dev Required for ERC-721 compliance.
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return ownershipTokenCount[_owner];
125   }
126 
127   /// @dev Creates a new promo AllStar with the given name, with given _price and assignes it to an address.
128   function createPromoAllStar(address _owner, string _name, uint256 _price) public onlyCeo {
129     require(promoCreatedCount < PROMO_CREATION_LIMIT);
130 
131     address allStarOwner = _owner;
132     if (allStarOwner == address(0)) {
133       allStarOwner = ceo;
134     }
135 
136     if (_price <= 0) {
137       _price = startingPrice;
138     }
139 
140     promoCreatedCount++;
141     _createAllStar(_name, allStarOwner, _price);
142   }
143 
144   /// @dev Creates a new AllStar with the given name.
145   function createContractAllStar(string _name) public onlyCeo {
146     _createAllStar(_name, msg.sender, startingPrice );
147   }
148 
149   /// @notice Returns all the relevant information about a specific AllStar.
150   /// @param _tokenId The tokenId of the All Star of interest.
151   function getAllStar(uint256 _tokenId) public view returns (
152     string allStarName,
153     uint allStarGen,
154     uint256 sellingPrice,
155     address owner
156   ) {
157     AllStar storage allStar = allStars[_tokenId];
158     allStarName = allStar.name;
159     allStarGen = allStar.gen;
160     sellingPrice = allStarIndexToPrice[_tokenId];
161     owner = allStarIndexToOwner[_tokenId];
162   }
163 
164   function implementsERC721() public pure returns (bool) {
165     return true;
166   }
167 
168   /// @dev Required for ERC-721 compliance.
169   function name() public pure returns (string) {
170     return NAME;
171   }
172 
173   /// For querying owner of token
174   /// @param _tokenId The tokenID for owner inquiry
175   /// @dev Required for ERC-721 compliance.
176   function ownerOf(uint256 _tokenId)
177     public
178     view
179     returns (address owner)
180   {
181     owner = allStarIndexToOwner[_tokenId];
182     require(owner != address(0));
183   }
184 
185   function payout() public onlyManagement {
186     _payout();
187   }
188 
189   // Allows someone to send ether and obtain the token
190   function purchase(uint256 _tokenId) public payable {
191     address oldOwner = allStarIndexToOwner[_tokenId];
192     address newOwner = msg.sender;
193 
194     uint256 sellingPrice = allStarIndexToPrice[_tokenId];
195 
196     // Making sure token owner is not sending to self
197     require(oldOwner != newOwner);
198 
199     // Safety check to prevent against an unexpected 0x0 default.
200     require(_addressNotNull(newOwner));
201 
202     // Making sure sent amount is greater than or equal to the sellingPrice
203     require(msg.value >= sellingPrice);
204 
205     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
206     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
207 
208     // Update prices
209     if (sellingPrice < firstStepLimit) {
210       // first stage
211       allStarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
212    } else {
213       // second and last stage
214       allStarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 94);
215     }
216 
217     _transfer(oldOwner, newOwner, _tokenId);
218 
219     // Pay previous tokenOwner if owner is not contract
220     if (oldOwner != address(this)) {
221       oldOwner.transfer(payment); //(1-0.06)
222     }
223 
224     TokenSold(_tokenId, sellingPrice, allStarIndexToPrice[_tokenId], oldOwner, newOwner, allStars[_tokenId].name);
225 
226     msg.sender.transfer(purchaseExcess);
227   }
228 
229   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
230     return allStarIndexToPrice[_tokenId];
231   }
232 
233   /// @dev Assigns a new address to act as the owner. Only available to the current owner.
234   /// @param _newOwner The address of the new owner
235   function setOwner(address _newOwner) public onlyCeo {
236     require(_newOwner != address(0));
237 
238     ceo = _newOwner;
239   }
240 
241    function setCFO(address _newCFO) public onlyCeo {
242     require(_newCFO != address(0));
243 
244     cfo = _newCFO;
245   }
246 
247 
248   /// @dev Required for ERC-721 compliance.
249   function symbol() public pure returns (string) {
250     return SYMBOL;
251   }
252 
253   /// @notice Allow pre-approved user to take ownership of a token
254   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
255   /// @dev Required for ERC-721 compliance.
256   function takeOwnership(uint256 _tokenId) public {
257     address newOwner = msg.sender;
258     address oldOwner = allStarIndexToOwner[_tokenId];
259 
260     // Safety check to prevent against an unexpected 0x0 default.
261     require(_addressNotNull(newOwner));
262 
263     // Making sure transfer is approved
264     require(_approved(newOwner, _tokenId));
265 
266     _transfer(oldOwner, newOwner, _tokenId);
267   }
268 
269 
270   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
271     uint256 tokenCount = balanceOf(_owner);
272     if (tokenCount == 0) {
273         // Return an empty array
274       return new uint256[](0);
275     } else {
276       uint256[] memory result = new uint256[](tokenCount);
277       uint256 totalAllStars = totalSupply();
278       uint256 resultIndex = 0;
279 
280       uint256 allStarId;
281       for (allStarId = 0; allStarId <= totalAllStars; allStarId++) {
282         if (allStarIndexToOwner[allStarId] == _owner) {
283           result[resultIndex] = allStarId;
284           resultIndex++;
285         }
286       }
287       return result;
288     }
289   }
290 
291   /// For querying totalSupply of token
292   /// @dev Required for ERC-721 compliance.
293   function totalSupply() public view returns (uint256 total) {
294     return allStars.length;
295   }
296 
297   /// Owner initates the transfer of the token to another account
298   /// @param _to The address for the token to be transferred to.
299   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
300   /// @dev Required for ERC-721 compliance.
301   function transfer(
302     address _to,
303     uint256 _tokenId
304   ) public {
305     require(_owns(msg.sender, _tokenId));
306     require(_addressNotNull(_to));
307 
308     _transfer(msg.sender, _to, _tokenId);
309   }
310 
311   /// Third-party initiates transfer of token from address _from to address _to
312   /// @param _from The address for the token to be transferred from.
313   /// @param _to The address for the token to be transferred to.
314   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
315   /// @dev Required for ERC-721 compliance.
316   function transferFrom(
317     address _from,
318     address _to,
319     uint256 _tokenId
320   ) public {
321     require(_owns(_from, _tokenId));
322     require(_approved(_to, _tokenId));
323     require(_addressNotNull(_to));
324 
325     _transfer(_from, _to, _tokenId);
326   }
327 
328   /*** PRIVATE FUNCTIONS ***/
329   /// Safety check on _to address to prevent against an unexpected 0x0 default.
330   function _addressNotNull(address _to) private pure returns (bool) {
331     return _to != address(0);
332   }
333 
334   /// For checking approval of transfer for address _to
335   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
336     return allStarIndexToApproved[_tokenId] == _to;
337   }
338 
339   /// For creating All Stars
340   function _createAllStar(string _name, address _owner, uint256 _price) private {
341     AllStar memory _allStar = AllStar({
342       name: _name,
343       gen: currentGen
344     });
345     uint256 newAllStarId = allStars.push(_allStar) - 1;
346 
347     // It's probably never going to happen, 4 billion tokens are A LOT, but
348     // let's just be 100% sure we never let this happen.
349     require(newAllStarId == uint256(uint32(newAllStarId)));
350 
351     Birth(newAllStarId, _name, _owner);
352 
353     allStarIndexToPrice[newAllStarId] = _price;
354 
355     // This will assign ownership, and also emit the Transfer event as
356     // per ERC721 draft
357     _transfer(address(0), _owner, newAllStarId);
358   }
359 
360   /// Check for token ownership
361   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
362     return claimant == allStarIndexToOwner[_tokenId];
363   }
364 
365   /// For paying out balance on contract
366   function _payout() private {
367       uint blnc = this.balance;
368       ceo.transfer(SafeMath.div(SafeMath.mul(blnc, 75), 100));
369       cfo.transfer(SafeMath.div(SafeMath.mul(blnc, 25), 100));
370     
371   }
372 
373   /// @dev Assigns ownership of a specific All Star to an address.
374   function _transfer(address _from, address _to, uint256 _tokenId) private {
375     // Since the number of all stars is capped to 2^32 we can't overflow this
376     ownershipTokenCount[_to]++;
377     //transfer ownership
378     allStarIndexToOwner[_tokenId] = _to;
379 
380     // When creating new all stars _from is 0x0, but we can't account that address.
381     if (_from != address(0)) {
382       ownershipTokenCount[_from]--;
383       // clear any previously approved ownership exchange
384       delete allStarIndexToApproved[_tokenId];
385     }
386 
387     // Emit the transfer event.
388     Transfer(_from, _to, _tokenId);
389   }
390 }
391 library SafeMath {
392 
393   /**
394   * @dev Multiplies two numbers, throws on overflow.
395   */
396   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
397     if (a == 0) {
398       return 0;
399     }
400     uint256 c = a * b;
401     assert(c / a == b);
402     return c;
403   }
404 
405   /**
406   * @dev Integer division of two numbers, truncating the quotient.
407   */
408   function div(uint256 a, uint256 b) internal pure returns (uint256) {
409     // assert(b > 0); // Solidity automatically throws when dividing by 0
410     uint256 c = a / b;
411     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
412     return c;
413   }
414 
415   /**
416   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
417   */
418   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
419     assert(b <= a);
420     return a - b;
421   }
422 
423   /**
424   * @dev Adds two numbers, throws on overflow.
425   */
426   function add(uint256 a, uint256 b) internal pure returns (uint256) {
427     uint256 c = a + b;
428     assert(c >= a);
429     return c;
430   }
431 }