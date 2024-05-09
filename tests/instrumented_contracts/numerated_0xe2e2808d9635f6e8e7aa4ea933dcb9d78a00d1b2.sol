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
26 contract EtherGames is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new Game comes into existence.
31   event Birth(uint256 tokenId, string name, address owner);
32 
33   /// @dev The TokenSold event is fired whenever a token is sold.
34   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
35 
36   /// @dev Transfer event as defined in current draft of ERC721.
37   ///  ownership is assigned, including births.
38   event Transfer(address from, address to, uint256 tokenId);
39 
40   /*** CONSTANTS ***/
41 
42   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
43   string public constant NAME = "EtherGames"; // solhint-disable-line
44   string public constant SYMBOL = "GameToken"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.001 ether;
47   uint256 private firstStepLimit =  0.053613 ether;
48   uint256 private secondStepLimit = 0.564957 ether;
49 
50   /*** STORAGE ***/
51 
52   /// @dev A mapping from game IDs to the address that owns them. All games have
53   ///  some valid owner address.
54   mapping (uint256 => address) public gameIndexToOwner;
55 
56   // @dev A mapping from owner address to count of tokens that address owns.
57   //  Used internally inside balanceOf() to resolve ownership count.
58   mapping (address => uint256) private ownershipTokenCount;
59 
60   /// @dev A mapping from GameIDs to an address that has been approved to call
61   ///  transferFrom(). Each Game can only have one approved address for transfer
62   ///  at any time. A zero value means no approval is outstanding.
63   mapping (uint256 => address) public gameIndexToApproved;
64 
65   // @dev A mapping from GameIDs to the price of the token.
66   mapping (uint256 => uint256) private gameIndexToPrice;
67 
68   // The addresses of the accounts (or contracts) that can execute actions within each roles.
69   address public ceoAddress;
70   address public cooAddress;
71 
72   /*** DATATYPES ***/
73   struct Game {
74     string name;
75   }
76 
77   Game[] private games;
78 
79   /*** ACCESS MODIFIERS ***/
80   /// @dev Access modifier for CEO-only functionality
81   modifier onlyCEO() {
82     require(msg.sender == ceoAddress);
83     _;
84   }
85 
86   /// @dev Access modifier for COO-only functionality
87   modifier onlyCOO() {
88     require(msg.sender == cooAddress);
89     _;
90   }
91 
92   /// Access modifier for contract owner only functionality
93   modifier onlyCLevel() {
94     require(
95       msg.sender == ceoAddress ||
96       msg.sender == cooAddress
97     );
98     _;
99   }
100 
101   /*** CONSTRUCTOR ***/
102   function EtherGames() public {
103     ceoAddress = msg.sender;
104     cooAddress = msg.sender;
105   }
106 
107   /*** PUBLIC FUNCTIONS ***/
108   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
109   /// @param _to The address to be granted transfer approval. Pass address(0) to
110   ///  clear all approvals.
111   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
112   /// @dev Required for ERC-721 compliance.
113   function approve(
114     address _to,
115     uint256 _tokenId
116   ) public
117   {
118     // Caller must own token.
119     require(_owns(msg.sender, _tokenId));
120 
121     gameIndexToApproved[_tokenId] = _to;
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
133   /// @dev Creates a new Game with the given name.
134   function createContractGame(string _name, uint256 _price) public onlyCOO {
135     _createGame(_name, ceoAddress, _price);
136   }
137 
138   /// @notice Returns all the relevant information about a specific game.
139   /// @param _tokenId The tokenId of the game of interest.
140   function getGame(uint256 _tokenId) public view returns (
141     string gameName,
142     uint256 sellingPrice,
143     address owner
144   ) {
145     Game storage game = games[_tokenId];
146     gameName = game.name;
147     sellingPrice = gameIndexToPrice[_tokenId];
148     owner = gameIndexToOwner[_tokenId];
149   }
150 
151   function implementsERC721() public pure returns (bool) {
152     return true;
153   }
154 
155   /// @dev Required for ERC-721 compliance.
156   function name() public pure returns (string) {
157     return NAME;
158   }
159 
160   /// For querying owner of token
161   /// @param _tokenId The tokenID for owner inquiry
162   /// @dev Required for ERC-721 compliance.
163   function ownerOf(uint256 _tokenId)
164     public
165     view
166     returns (address owner)
167   {
168     owner = gameIndexToOwner[_tokenId];
169     require(owner != address(0));
170   }
171 
172   function payout(address _to) public onlyCLevel {
173     _payout(_to);
174   }
175 
176   // Allows someone to send ether and obtain the token
177   function purchase(uint256 _tokenId) public payable {
178     address oldOwner = gameIndexToOwner[_tokenId];
179     address newOwner = msg.sender;
180 
181     uint256 sellingPrice = gameIndexToPrice[_tokenId];
182 
183     // Making sure token owner is not sending to self
184     require(oldOwner != newOwner);
185 
186     // Safety check to prevent against an unexpected 0x0 default.
187     require(_addressNotNull(newOwner));
188 
189     // Making sure sent amount is greater than or equal to the sellingPrice
190     require(msg.value >= sellingPrice);
191 
192     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
193     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
194 
195     // Update prices
196     if (sellingPrice < firstStepLimit) {
197       // first stage
198       gameIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
199     } else if (sellingPrice < secondStepLimit) {
200       // second stage
201       gameIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
202     } else {
203       // third stage
204       gameIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
205     }
206 
207     _transfer(oldOwner, newOwner, _tokenId);
208 
209     // Pay previous tokenOwner if owner is not contract
210     if (oldOwner != address(this)) {
211       oldOwner.transfer(payment); //(1-0.08)
212     }
213 
214     TokenSold(_tokenId, sellingPrice, gameIndexToPrice[_tokenId], oldOwner, newOwner, games[_tokenId].name);
215 
216     msg.sender.transfer(purchaseExcess);
217   }
218 
219   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
220     return gameIndexToPrice[_tokenId];
221   }
222 
223   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
224   /// @param _newCEO The address of the new CEO
225   function setCEO(address _newCEO) public onlyCEO {
226     require(_newCEO != address(0));
227 
228     ceoAddress = _newCEO;
229   }
230 
231   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
232   /// @param _newCOO The address of the new COO
233   function setCOO(address _newCOO) public onlyCEO {
234     require(_newCOO != address(0));
235 
236     cooAddress = _newCOO;
237   }
238 
239   /// @dev Required for ERC-721 compliance.
240   function symbol() public pure returns (string) {
241     return SYMBOL;
242   }
243 
244   /// @notice Allow pre-approved user to take ownership of a token
245   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
246   /// @dev Required for ERC-721 compliance.
247   function takeOwnership(uint256 _tokenId) public {
248     address newOwner = msg.sender;
249     address oldOwner = gameIndexToOwner[_tokenId];
250 
251     // Safety check to prevent against an unexpected 0x0 default.
252     require(_addressNotNull(newOwner));
253 
254     // Making sure transfer is approved
255     require(_approved(newOwner, _tokenId));
256 
257     _transfer(oldOwner, newOwner, _tokenId);
258   }
259 
260   /// @param _owner The owner whose celebrity tokens we are interested in.
261   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
262   ///  expensive (it walks the entire Games array looking for games belonging to owner),
263   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
264   ///  not contract-to-contract calls.
265   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
266     uint256 tokenCount = balanceOf(_owner);
267     if (tokenCount == 0) {
268         // Return an empty array
269       return new uint256[](0);
270     } else {
271       uint256[] memory result = new uint256[](tokenCount);
272       uint256 totalGames = totalSupply();
273       uint256 resultIndex = 0;
274 
275       uint256 gameId;
276       for (gameId = 0; gameId <= totalGames; gameId++) {
277         if (gameIndexToOwner[gameId] == _owner) {
278           result[resultIndex] = gameId;
279           resultIndex++;
280         }
281       }
282       return result;
283     }
284   }
285 
286   /// For querying totalSupply of token
287   /// @dev Required for ERC-721 compliance.
288   function totalSupply() public view returns (uint256 total) {
289     return games.length;
290   }
291 
292   /// Owner initates the transfer of the token to another account
293   /// @param _to The address for the token to be transferred to.
294   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
295   /// @dev Required for ERC-721 compliance.
296   function transfer(
297     address _to,
298     uint256 _tokenId
299   ) public {
300     require(_owns(msg.sender, _tokenId));
301     require(_addressNotNull(_to));
302 
303     _transfer(msg.sender, _to, _tokenId);
304   }
305 
306   /// Third-party initiates transfer of token from address _from to address _to
307   /// @param _from The address for the token to be transferred from.
308   /// @param _to The address for the token to be transferred to.
309   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
310   /// @dev Required for ERC-721 compliance.
311   function transferFrom(
312     address _from,
313     address _to,
314     uint256 _tokenId
315   ) public {
316     require(_owns(_from, _tokenId));
317     require(_approved(_to, _tokenId));
318     require(_addressNotNull(_to));
319 
320     _transfer(_from, _to, _tokenId);
321   }
322 
323   /*** PRIVATE FUNCTIONS ***/
324   /// Safety check on _to address to prevent against an unexpected 0x0 default.
325   function _addressNotNull(address _to) private pure returns (bool) {
326     return _to != address(0);
327   }
328 
329   /// For checking approval of transfer for address _to
330   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
331     return gameIndexToApproved[_tokenId] == _to;
332   }
333 
334   /// For creating Game
335   function _createGame(string _name, address _owner, uint256 _price) private {
336     Game memory _game = Game({
337       name: _name
338     });
339     uint256 newGameId = games.push(_game) - 1;
340 
341     // It's probably never going to happen, 4 billion tokens are A LOT, but
342     // let's just be 100% sure we never let this happen.
343     require(newGameId == uint256(uint32(newGameId)));
344 
345     Birth(newGameId, _name, _owner);
346 
347     gameIndexToPrice[newGameId] = _price;
348 
349     // This will assign ownership, and also emit the Transfer event as
350     // per ERC721 draft
351     _transfer(address(0), _owner, newGameId);
352   }
353 
354   /// Check for token ownership
355   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
356     return claimant == gameIndexToOwner[_tokenId];
357   }
358 
359   /// For paying out balance on contract
360   function _payout(address _to) private {
361     if (_to == address(0)) {
362       ceoAddress.transfer(this.balance);
363     } else {
364       _to.transfer(this.balance);
365     }
366   }
367 
368   /// @dev Assigns ownership of a specific Game to an address.
369   function _transfer(address _from, address _to, uint256 _tokenId) private {
370     // Since the number of games is capped to 2^32 we can't overflow this
371     ownershipTokenCount[_to]++;
372     //transfer ownership
373     gameIndexToOwner[_tokenId] = _to;
374 
375     // When creating new games _from is 0x0, but we can't account that address.
376     if (_from != address(0)) {
377       ownershipTokenCount[_from]--;
378       // clear any previously approved ownership exchange
379       delete gameIndexToApproved[_tokenId];
380     }
381 
382     // Emit the transfer event.
383     Transfer(_from, _to, _tokenId);
384   }
385 }
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