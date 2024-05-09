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
27 contract CryptoOscarsToken is ERC721 {
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
44   string public constant NAME = "CryptoOscars"; // solhint-disable-line
45   string public constant SYMBOL = "CryptoOscarsToken"; // solhint-disable-line
46 
47   uint256 private startingPrice = 0.001 ether;
48   uint256 private constant PROMO_CREATION_LIMIT = 20000;
49 
50   /*** STORAGE ***/
51 
52   /// @dev A mapping from movie IDs to the address that owns them. All movies have
53   ///  some valid owner address.
54   mapping (uint256 => address) public movieIndexToOwner;
55 
56   // @dev A mapping from owner address to count of tokens that address owns.
57   //  Used internally inside balanceOf() to resolve ownership count.
58   mapping (address => uint256) private ownershipTokenCount;
59 
60   /// @dev A mapping from MovieIDs to an address that has been approved to call
61   ///  transferFrom(). Each Movie can only have one approved address for transfer
62   ///  at any time. A zero value means no approval is outstanding.
63   mapping (uint256 => address) public movieIndexToApproved;
64 
65   // @dev A mapping from MovieIDs to the price of the token.
66   mapping (uint256 => uint256) private movieIndexToPrice;
67 
68   // The addresses of the accounts (or contracts) that can execute actions within each roles.
69   address public ceoAddress;
70   address public cooAddress;
71 
72   uint256 public promoCreatedCount;
73 
74   /*** DATATYPES ***/
75   struct Movie {
76     string name;
77   }
78 
79   Movie[] private movies;
80 
81   /*** ACCESS MODIFIERS ***/
82   /// @dev Access modifier for CEO-only functionality
83   modifier onlyCEO() {
84     require(msg.sender == ceoAddress);
85     _;
86   }
87 
88   /// @dev Access modifier for COO-only functionality
89   modifier onlyCOO() {
90     require(msg.sender == cooAddress);
91     _;
92   }
93 
94   /// Access modifier for contract owner only functionality
95   modifier onlyCLevel() {
96     require(
97       msg.sender == ceoAddress ||
98       msg.sender == cooAddress
99     );
100     _;
101   }
102 
103   /*** CONSTRUCTOR ***/
104   function CryptoMoviesToken() public {
105     ceoAddress = msg.sender;
106     cooAddress = msg.sender;
107   }
108 
109   /*** PUBLIC FUNCTIONS ***/
110   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
111   /// @param _to The address to be granted transfer approval. Pass address(0) to
112   ///  clear all approvals.
113   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
114   /// @dev Required for ERC-721 compliance.
115   function approve(address _to, uint256 _tokenId) public {
116     // Caller must own token.
117     require(_owns(msg.sender, _tokenId));
118 
119     movieIndexToApproved[_tokenId] = _to;
120 
121     Approval(msg.sender, _to, _tokenId);
122   }
123 
124   /// For querying balance of a particular account
125   /// @param _owner The address for balance query
126   /// @dev Required for ERC-721 compliance.
127   function balanceOf(address _owner) public view returns (uint256 balance) {
128     return ownershipTokenCount[_owner];
129   }
130 
131   /// @dev Creates a new promo Movie with the given name, with given _price and assignes it to an address.
132   function createPromoMovie(address _owner, string _name, uint256 _price) public onlyCOO {
133     require(promoCreatedCount < PROMO_CREATION_LIMIT);
134 
135     address movieOwner = _owner;
136     if (movieOwner == address(0)) {
137       movieOwner = cooAddress;
138     }
139 
140     if (_price <= 0) {
141       _price = startingPrice;
142     }
143 
144     promoCreatedCount++;
145     _createMovie(_name, movieOwner, _price);
146   }
147 
148   /// @dev Creates a new Movie with the given name.
149   function createContractMovie(string _name) public onlyCOO {
150     _createMovie(_name, address(this), startingPrice);
151   }
152 
153   /// @notice Returns all the relevant information about a specific movie.
154   /// @param _tokenId The tokenId of the movie of interest.
155   function getMovie(uint256 _tokenId) public view returns (
156     string movieName,
157     uint256 sellingPrice,
158     address owner
159   ) {
160     Movie storage movie = movies[_tokenId];
161     movieName = movie.name;
162     sellingPrice = movieIndexToPrice[_tokenId];
163     owner = movieIndexToOwner[_tokenId];
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
183     owner = movieIndexToOwner[_tokenId];
184     require(owner != address(0));
185   }
186 
187   function payout(address _to) public onlyCLevel {
188     _payout(_to);
189   }
190 
191   // Allows someone to send ether and obtain the token
192   function purchase(uint256 _tokenId) public payable {
193     address oldOwner = movieIndexToOwner[_tokenId];
194     address newOwner = msg.sender;
195 
196     uint256 sellingPrice = movieIndexToPrice[_tokenId];
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
207     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 80), 100));
208     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
209 
210     // Update prices
211     movieIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 80);
212 
213     _transfer(oldOwner, newOwner, _tokenId);
214 
215     // Pay previous tokenOwner if owner is not contract
216     if (oldOwner != address(this)) {
217       oldOwner.transfer(payment);
218     }
219 
220     TokenSold(_tokenId, sellingPrice, movieIndexToPrice[_tokenId], oldOwner, newOwner, movies[_tokenId].name);
221 
222     msg.sender.transfer(purchaseExcess);
223   }
224 
225   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
226     return movieIndexToPrice[_tokenId];
227   }
228 
229   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
230   /// @param _newCEO The address of the new CEO
231   function setCEO(address _newCEO) public onlyCEO {
232     require(_newCEO != address(0));
233 
234     ceoAddress = _newCEO;
235   }
236 
237   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
238   /// @param _newCOO The address of the new COO
239   function setCOO(address _newCOO) public onlyCEO {
240     require(_newCOO != address(0));
241 
242     cooAddress = _newCOO;
243   }
244 
245   /// @dev Required for ERC-721 compliance.
246   function symbol() public pure returns (string) {
247     return SYMBOL;
248   }
249 
250   /// @notice Allow pre-approved user to take ownership of a token
251   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
252   /// @dev Required for ERC-721 compliance.
253   function takeOwnership(uint256 _tokenId) public {
254     address newOwner = msg.sender;
255     address oldOwner = movieIndexToOwner[_tokenId];
256 
257     // Safety check to prevent against an unexpected 0x0 default.
258     require(_addressNotNull(newOwner));
259 
260     // Making sure transfer is approved
261     require(_approved(newOwner, _tokenId));
262 
263     _transfer(oldOwner, newOwner, _tokenId);
264   }
265 
266   /// @param _owner The owner whose cryptomovie tokens we are interested in.
267   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
268   ///  expensive (it walks the entire Movies array looking for movies belonging to owner),
269   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
270   ///  not contract-to-contract calls.
271   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
272     uint256 tokenCount = balanceOf(_owner);
273     if (tokenCount == 0) {
274         // Return an empty array
275       return new uint256[](0);
276     } else {
277       uint256[] memory result = new uint256[](tokenCount);
278       uint256 totalMovies = totalSupply();
279       uint256 resultIndex = 0;
280 
281       uint256 movieId;
282       for (movieId = 0; movieId <= totalMovies; movieId++) {
283         if (movieIndexToOwner[movieId] == _owner) {
284           result[resultIndex] = movieId;
285           resultIndex++;
286         }
287       }
288       return result;
289     }
290   }
291 
292   /// For querying totalSupply of token
293   /// @dev Required for ERC-721 compliance.
294   function totalSupply() public view returns (uint256 total) {
295     return movies.length;
296   }
297 
298   /// Owner initates the transfer of the token to another account
299   /// @param _to The address for the token to be transferred to.
300   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
301   /// @dev Required for ERC-721 compliance.
302   function transfer(address _to, uint256 _tokenId) public {
303     require(_owns(msg.sender, _tokenId));
304     require(_addressNotNull(_to));
305 
306     _transfer(msg.sender, _to, _tokenId);
307   }
308 
309   /// Third-party initiates transfer of token from address _from to address _to
310   /// @param _from The address for the token to be transferred from.
311   /// @param _to The address for the token to be transferred to.
312   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
313   /// @dev Required for ERC-721 compliance.
314   function transferFrom(address _from, address _to, uint256 _tokenId) public {
315     require(_owns(_from, _tokenId));
316     require(_approved(_to, _tokenId));
317     require(_addressNotNull(_to));
318 
319     _transfer(_from, _to, _tokenId);
320   }
321 
322   /*** PRIVATE FUNCTIONS ***/
323   /// Safety check on _to address to prevent against an unexpected 0x0 default.
324   function _addressNotNull(address _to) private pure returns (bool) {
325     return _to != address(0);
326   }
327 
328   /// For checking approval of transfer for address _to
329   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
330     return movieIndexToApproved[_tokenId] == _to;
331   }
332 
333   /// For creating Movie
334   function _createMovie(string _name, address _owner, uint256 _price) private {
335     Movie memory _movie = Movie({
336       name: _name
337     });
338     uint256 newMovieId = movies.push(_movie) - 1;
339 
340     // It's probably never going to happen, 4 billion tokens are A LOT, but
341     // let's just be 100% sure we never let this happen.
342     require(newMovieId == uint256(uint32(newMovieId)));
343 
344     Birth(newMovieId, _name, _owner);
345 
346     movieIndexToPrice[newMovieId] = _price;
347 
348     // This will assign ownership, and also emit the Transfer event as
349     // per ERC721 draft
350     _transfer(address(0), _owner, newMovieId);
351   }
352 
353   /// Check for token ownership
354   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
355     return claimant == movieIndexToOwner[_tokenId];
356   }
357 
358   /// For paying out balance on contract
359   function _payout(address _to) private {
360     if (_to == address(0)) {
361       ceoAddress.transfer(this.balance);
362     } else {
363       _to.transfer(this.balance);
364     }
365   }
366 
367   /// @dev Assigns ownership of a specific Movie to an address.
368   function _transfer(address _from, address _to, uint256 _tokenId) private {
369     // Since the number of movies is capped to 2^32 we can't overflow this
370     ownershipTokenCount[_to]++;
371     // transfer ownership
372     movieIndexToOwner[_tokenId] = _to;
373 
374     // When creating new movies _from is 0x0, but we can't account that address.
375     if (_from != address(0)) {
376       ownershipTokenCount[_from]--;
377       // clear any previously approved ownership exchange
378       delete movieIndexToApproved[_tokenId];
379     }
380 
381     // Emit the transfer event.
382     Transfer(_from, _to, _tokenId);
383   }
384 }
385 
386 library SafeMath {
387 
388   /**
389   * @dev Multiplies two numbers, throws on overflow.
390   */
391   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
392     if (a == 0) {
393       return 0;
394     }
395     uint256 c = a * b;
396     assert(c / a == b);
397     return c;
398   }
399 
400   /**
401   * @dev Integer division of two numbers, truncating the quotient.
402   */
403   function div(uint256 a, uint256 b) internal pure returns (uint256) {
404     // assert(b > 0); // Solidity automatically throws when dividing by 0
405     uint256 c = a / b;
406     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
407     return c;
408   }
409 
410   /**
411   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
412   */
413   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
414     assert(b <= a);
415     return a - b;
416   }
417 
418   /**
419   * @dev Adds two numbers, throws on overflow.
420   */
421   function add(uint256 a, uint256 b) internal pure returns (uint256) {
422     uint256 c = a + b;
423     assert(c >= a);
424     return c;
425   }
426 }