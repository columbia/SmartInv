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
27 contract CryptoMoviesToken is ERC721 {
28 
29   /*** EVENTS ***/
30 
31   /// @dev The Birth event is fired whenever a new movie comes into existence.
32   event Birth(uint256 tokenId, string name, address owner);
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
36 
37   /// @dev Transfer event as defined in current draft of ERC721.
38   ///  ownership is assigned, including births.
39   event Transfer(address from, address to, uint256 tokenId);
40 
41   /*** CONSTANTS ***/
42 
43   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
44   string public constant NAME = "CryptoMovies"; // solhint-disable-line
45   string public constant SYMBOL = "CryptoMoviesToken"; // solhint-disable-line
46 
47   uint256 private startingPrice = 0.001 ether;
48   uint256 private constant PROMO_CREATION_LIMIT = 20000;
49   uint256 private firstStepLimit =  1.2 ether;
50   uint256 private secondStepLimit = 5 ether;
51 
52   /*** STORAGE ***/
53 
54   /// @dev A mapping from movie IDs to the address that owns them. All movies have
55   ///  some valid owner address.
56   mapping (uint256 => address) public movieIndexToOwner;
57 
58   // @dev A mapping from owner address to count of tokens that address owns.
59   //  Used internally inside balanceOf() to resolve ownership count.
60   mapping (address => uint256) private ownershipTokenCount;
61 
62   /// @dev A mapping from MovieIDs to an address that has been approved to call
63   ///  transferFrom(). Each Movie can only have one approved address for transfer
64   ///  at any time. A zero value means no approval is outstanding.
65   mapping (uint256 => address) public movieIndexToApproved;
66 
67   // @dev A mapping from MovieIDs to the price of the token.
68   mapping (uint256 => uint256) private movieIndexToPrice;
69 
70   // The addresses of the accounts (or contracts) that can execute actions within each roles.
71   address public ceoAddress;
72   address public cooAddress;
73 
74   uint256 public promoCreatedCount;
75 
76   /*** DATATYPES ***/
77   struct Movie {
78     string name;
79   }
80 
81   Movie[] private movies;
82 
83   /*** ACCESS MODIFIERS ***/
84   /// @dev Access modifier for CEO-only functionality
85   modifier onlyCEO() {
86     require(msg.sender == ceoAddress);
87     _;
88   }
89 
90   /// @dev Access modifier for COO-only functionality
91   modifier onlyCOO() {
92     require(msg.sender == cooAddress);
93     _;
94   }
95 
96   /// Access modifier for contract owner only functionality
97   modifier onlyCLevel() {
98     require(
99       msg.sender == ceoAddress ||
100       msg.sender == cooAddress
101     );
102     _;
103   }
104 
105   /*** CONSTRUCTOR ***/
106   function CryptoMoviesToken() public {
107     ceoAddress = msg.sender;
108     cooAddress = msg.sender;
109   }
110 
111   /*** PUBLIC FUNCTIONS ***/
112   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
113   /// @param _to The address to be granted transfer approval. Pass address(0) to
114   ///  clear all approvals.
115   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
116   /// @dev Required for ERC-721 compliance.
117   function approve(address _to, uint256 _tokenId) public {
118     // Caller must own token.
119     require(_owns(msg.sender, _tokenId));
120 
121     movieIndexToApproved[_tokenId] = _to;
122 
123     Approval(msg.sender, _to, _tokenId);
124   }
125 
126   /// For querying balance of a particular account
127   /// @param _owner The address for balance query
128   /// @dev Required for ERC-721 compliance.
129   function balanceOf(address _owner) public view returns (uint256 balance) {
130     return ownershipTokenCount[_owner];
131   }
132 
133   /// @dev Creates a new promo Movie with the given name, with given _price and assignes it to an address.
134   function createPromoMovie(address _owner, string _name, uint256 _price) public onlyCOO {
135     require(promoCreatedCount < PROMO_CREATION_LIMIT);
136 
137     address movieOwner = _owner;
138     if (movieOwner == address(0)) {
139       movieOwner = cooAddress;
140     }
141 
142     if (_price <= 0) {
143       _price = startingPrice;
144     }
145 
146     promoCreatedCount++;
147     _createMovie(_name, movieOwner, _price);
148   }
149 
150   /// @dev Creates a new Movie with the given name.
151   function createContractMovie(string _name) public onlyCOO {
152     _createMovie(_name, address(this), startingPrice);
153   }
154 
155   /// @notice Returns all the relevant information about a specific movie.
156   /// @param _tokenId The tokenId of the movie of interest.
157   function getMovie(uint256 _tokenId) public view returns (
158     string movieName,
159     uint256 sellingPrice,
160     address owner
161   ) {
162     Movie storage movie = movies[_tokenId];
163     movieName = movie.name;
164     sellingPrice = movieIndexToPrice[_tokenId];
165     owner = movieIndexToOwner[_tokenId];
166   }
167 
168   function implementsERC721() public pure returns (bool) {
169     return true;
170   }
171 
172   /// @dev Required for ERC-721 compliance.
173   function name() public pure returns (string) {
174     return NAME;
175   }
176 
177   /// For querying owner of token
178   /// @param _tokenId The tokenID for owner inquiry
179   /// @dev Required for ERC-721 compliance.
180   function ownerOf(uint256 _tokenId)
181     public
182     view
183     returns (address owner)
184   {
185     owner = movieIndexToOwner[_tokenId];
186     require(owner != address(0));
187   }
188 
189   function payout(address _to) public onlyCLevel {
190     _payout(_to);
191   }
192 
193   // Allows someone to send ether and obtain the token
194   function purchase(uint256 _tokenId) public payable {
195     address oldOwner = movieIndexToOwner[_tokenId];
196     address newOwner = msg.sender;
197 
198     uint256 sellingPrice = movieIndexToPrice[_tokenId];
199 
200     // Making sure token owner is not sending to self
201     require(oldOwner != newOwner);
202 
203     // Safety check to prevent against an unexpected 0x0 default.
204     require(_addressNotNull(newOwner));
205 
206     // Making sure sent amount is greater than or equal to the sellingPrice
207     require(msg.value >= sellingPrice);
208 
209     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
210     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
211 
212     // Update prices
213     if (sellingPrice < firstStepLimit) {
214       // first stage
215       movieIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
216     } else if (sellingPrice < secondStepLimit) {
217       // second stage
218       movieIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 94);
219     } else {
220       // third stage
221       movieIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
222     }
223 
224     _transfer(oldOwner, newOwner, _tokenId);
225 
226     // Pay previous tokenOwner if owner is not contract
227     if (oldOwner != address(this)) {
228       oldOwner.transfer(payment); //(1-0.06)
229     }
230 
231     TokenSold(_tokenId, sellingPrice, movieIndexToPrice[_tokenId], oldOwner, newOwner, movies[_tokenId].name);
232 
233     msg.sender.transfer(purchaseExcess);
234   }
235 
236   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
237     return movieIndexToPrice[_tokenId];
238   }
239 
240   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
241   /// @param _newCEO The address of the new CEO
242   function setCEO(address _newCEO) public onlyCEO {
243     require(_newCEO != address(0));
244 
245     ceoAddress = _newCEO;
246   }
247 
248   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
249   /// @param _newCOO The address of the new COO
250   function setCOO(address _newCOO) public onlyCEO {
251     require(_newCOO != address(0));
252 
253     cooAddress = _newCOO;
254   }
255 
256   /// @dev Required for ERC-721 compliance.
257   function symbol() public pure returns (string) {
258     return SYMBOL;
259   }
260 
261   /// @notice Allow pre-approved user to take ownership of a token
262   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
263   /// @dev Required for ERC-721 compliance.
264   function takeOwnership(uint256 _tokenId) public {
265     address newOwner = msg.sender;
266     address oldOwner = movieIndexToOwner[_tokenId];
267 
268     // Safety check to prevent against an unexpected 0x0 default.
269     require(_addressNotNull(newOwner));
270 
271     // Making sure transfer is approved
272     require(_approved(newOwner, _tokenId));
273 
274     _transfer(oldOwner, newOwner, _tokenId);
275   }
276 
277   /// @param _owner The owner whose cryptomovie tokens we are interested in.
278   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
279   ///  expensive (it walks the entire Movies array looking for movies belonging to owner),
280   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
281   ///  not contract-to-contract calls.
282   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
283     uint256 tokenCount = balanceOf(_owner);
284     if (tokenCount == 0) {
285         // Return an empty array
286       return new uint256[](0);
287     } else {
288       uint256[] memory result = new uint256[](tokenCount);
289       uint256 totalMovies = totalSupply();
290       uint256 resultIndex = 0;
291 
292       uint256 movieId;
293       for (movieId = 0; movieId <= totalMovies; movieId++) {
294         if (movieIndexToOwner[movieId] == _owner) {
295           result[resultIndex] = movieId;
296           resultIndex++;
297         }
298       }
299       return result;
300     }
301   }
302 
303   /// For querying totalSupply of token
304   /// @dev Required for ERC-721 compliance.
305   function totalSupply() public view returns (uint256 total) {
306     return movies.length;
307   }
308 
309   /// Owner initates the transfer of the token to another account
310   /// @param _to The address for the token to be transferred to.
311   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
312   /// @dev Required for ERC-721 compliance.
313   function transfer(address _to, uint256 _tokenId) public {
314     require(_owns(msg.sender, _tokenId));
315     require(_addressNotNull(_to));
316 
317     _transfer(msg.sender, _to, _tokenId);
318   }
319 
320   /// Third-party initiates transfer of token from address _from to address _to
321   /// @param _from The address for the token to be transferred from.
322   /// @param _to The address for the token to be transferred to.
323   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
324   /// @dev Required for ERC-721 compliance.
325   function transferFrom(address _from, address _to, uint256 _tokenId) public {
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
341     return movieIndexToApproved[_tokenId] == _to;
342   }
343 
344   /// For creating Movie
345   function _createMovie(string _name, address _owner, uint256 _price) private {
346     Movie memory _movie = Movie({
347       name: _name
348     });
349     uint256 newMovieId = movies.push(_movie) - 1;
350 
351     // It's probably never going to happen, 4 billion tokens are A LOT, but
352     // let's just be 100% sure we never let this happen.
353     require(newMovieId == uint256(uint32(newMovieId)));
354 
355     Birth(newMovieId, _name, _owner);
356 
357     movieIndexToPrice[newMovieId] = _price;
358 
359     // This will assign ownership, and also emit the Transfer event as
360     // per ERC721 draft
361     _transfer(address(0), _owner, newMovieId);
362   }
363 
364   /// Check for token ownership
365   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
366     return claimant == movieIndexToOwner[_tokenId];
367   }
368 
369   /// For paying out balance on contract
370   function _payout(address _to) private {
371     if (_to == address(0)) {
372       ceoAddress.transfer(this.balance);
373     } else {
374       _to.transfer(this.balance);
375     }
376   }
377 
378   /// @dev Assigns ownership of a specific Movie to an address.
379   function _transfer(address _from, address _to, uint256 _tokenId) private {
380     // Since the number of movies is capped to 2^32 we can't overflow this
381     ownershipTokenCount[_to]++;
382     // transfer ownership
383     movieIndexToOwner[_tokenId] = _to;
384 
385     // When creating new movies _from is 0x0, but we can't account that address.
386     if (_from != address(0)) {
387       ownershipTokenCount[_from]--;
388       // clear any previously approved ownership exchange
389       delete movieIndexToApproved[_tokenId];
390     }
391 
392     // Emit the transfer event.
393     Transfer(_from, _to, _tokenId);
394   }
395 }
396 
397 library SafeMath {
398 
399   /**
400   * @dev Multiplies two numbers, throws on overflow.
401   */
402   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
403     if (a == 0) {
404       return 0;
405     }
406     uint256 c = a * b;
407     assert(c / a == b);
408     return c;
409   }
410 
411   /**
412   * @dev Integer division of two numbers, truncating the quotient.
413   */
414   function div(uint256 a, uint256 b) internal pure returns (uint256) {
415     // assert(b > 0); // Solidity automatically throws when dividing by 0
416     uint256 c = a / b;
417     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418     return c;
419   }
420 
421   /**
422   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
423   */
424   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
425     assert(b <= a);
426     return a - b;
427   }
428 
429   /**
430   * @dev Adds two numbers, throws on overflow.
431   */
432   function add(uint256 a, uint256 b) internal pure returns (uint256) {
433     uint256 c = a + b;
434     assert(c >= a);
435     return c;
436   }
437 }