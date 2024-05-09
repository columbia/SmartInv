1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     /**
29     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract ERC721 {
47 
48     // Required methods
49     function approve(address _to, uint256 _tokenId) public;
50     function balanceOf(address _owner) public view returns (uint256 balance);
51     function implementsERC721() public pure returns (bool);
52     function ownerOf(uint256 _tokenId) public view returns (address addr);
53     function takeOwnership(uint256 _tokenId) public;
54     function totalSupply() public view returns (uint256 total);
55     function transferFrom(address _from, address _to, uint256 _tokenId) public;
56     function transfer(address _to, uint256 _tokenId) public;
57 
58     event Transfer(address indexed from, address indexed to, uint256 tokenId);
59     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
60 
61     // Optional
62     // function name() public view returns (string name);
63     // function symbol() public view returns (string symbol);
64     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
65     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
66 }
67 
68 
69 contract CryptoSoccrToken is ERC721 {
70 
71     /*** EVENTS ***/
72 
73     /// @dev The Birth event is fired whenever a new player comes into existence.
74     event Birth(uint256 tokenId, string name, address owner);
75     event Snatch(uint256 tokenId, address oldOwner, address newOwner);
76 
77 /// @dev The TokenSold event is fired whenever a token is sold.
78     event TokenSold(
79         uint256 indexed tokenId,
80         uint256 oldPrice,
81         uint256 newPrice,
82         address prevOwner,
83         address indexed winner,
84         string name
85     );
86 
87     /// @dev Transfer event as defined in current draft of ERC721.
88     ///    ownership is assigned, including births.
89     event Transfer(address from, address to, uint256 tokenId);
90 
91     /*** CONSTANTS ***/
92 
93     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
94     string public constant NAME = "CryptoSoccr";
95     string public constant SYMBOL = "CryptoSoccrToken";
96 
97     uint256 private startingPrice = 0.001 ether;
98     uint256 private constant PROMO_CREATION_LIMIT = 5000;
99     uint256 private firstStepLimit =    0.053613 ether;
100     uint256 private firstStepMultiplier =    200;
101     uint256 private secondStepLimit = 0.564957 ether;
102     uint256 private secondStepMultiplier = 150;
103     uint256 private thirdStepMultiplier = 120;
104 
105     /*** STORAGE ***/
106 
107     /// @dev A mapping from player IDs to the address that owns them. All players have
108     ///    some valid owner address.
109     mapping (uint256 => address) public playerIndexToOwner;
110 
111     // @dev A mapping from owner address to count of tokens that address owns.
112     //    Used internally inside balanceOf() to resolve ownership count.
113     mapping (address => uint256) private ownershipTokenCount;
114 
115     /// @dev A mapping from PlayerIDs to an address that has been approved to call
116     ///    transferFrom(). Each Player can only have one approved address for transfer
117     ///    at any time. A zero value means no approval is outstanding.
118     mapping (uint256 => address) public playerIndexToApproved;
119 
120     // @dev A mapping from PlayerIDs to the price of the token.
121     mapping (uint256 => uint256) private playerIndexToPrice;
122 
123     // The addresses of the accounts (or contracts) that can execute actions within each roles.
124     address public ceoAddress;
125 
126     uint256 public promoCreatedCount;
127 
128     /*** DATATYPES ***/
129     struct Player {
130         string name;
131         uint256 internalPlayerId;
132     }
133 
134     Player[] private players;
135 
136     /*** ACCESS MODIFIERS ***/
137     /// @dev Access modifier for CEO-only functionality
138     modifier onlyCEO() {
139         require(msg.sender == ceoAddress);
140         _;
141     }
142 
143     /// Access modifier for contract owner only functionality
144     modifier onlyCLevel() {
145         require(msg.sender == ceoAddress);
146         _;
147     }
148 
149     /*** CONSTRUCTOR ***/
150     function CryptoSoccrToken() public {
151         ceoAddress = msg.sender;
152     }
153 
154     /*** PUBLIC FUNCTIONS ***/
155     /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
156     /// @param _to The address to be granted transfer approval. Pass address(0) to
157     ///    clear all approvals.
158     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
159     /// @dev Required for ERC-721 compliance.
160     function approve(
161         address _to,
162         uint256 _tokenId
163     ) public {
164         // Caller must own token.
165         require(_owns(msg.sender, _tokenId));
166 
167         playerIndexToApproved[_tokenId] = _to;
168 
169         Approval(msg.sender, _to, _tokenId);
170     }
171 
172     /// For querying balance of a particular account
173     /// @param _owner The address for balance query
174     /// @dev Required for ERC-721 compliance.
175     function balanceOf(address _owner) public view returns (uint256 balance) {
176         return ownershipTokenCount[_owner];
177     }
178 
179     /// @dev Creates a new promo Player with the given name, with given _price and assignes it to an address.
180     function createPromoPlayer(address _owner, string _name, uint256 _price, uint256 _internalPlayerId) public onlyCEO {
181         require(promoCreatedCount < PROMO_CREATION_LIMIT);
182 
183         address playerOwner = _owner;
184         if (playerOwner == address(0)) {
185             playerOwner = ceoAddress;
186         }
187 
188         if (_price <= 0) {
189             _price = startingPrice;
190         }
191 
192         promoCreatedCount++;
193         _createPlayer(_name, playerOwner, _price, _internalPlayerId);
194     }
195 
196     /// @dev Creates a new Player with the given name.
197     function createContractPlayer(string _name, uint256 _internalPlayerId) public onlyCEO {
198         _createPlayer(_name, address(this), startingPrice, _internalPlayerId);
199     }
200 
201     /// @notice Returns all the relevant information about a specific player.
202     /// @param _tokenId The tokenId of the player of interest.
203     function getPlayer(uint256 _tokenId) public view returns (
204         string playerName,
205         uint256 internalPlayerId,
206         uint256 sellingPrice,
207         address owner
208     ) {
209         Player storage player = players[_tokenId];
210         playerName = player.name;
211         internalPlayerId = player.internalPlayerId;
212         sellingPrice = playerIndexToPrice[_tokenId];
213         owner = playerIndexToOwner[_tokenId];
214     }
215 
216     function implementsERC721() public pure returns (bool) {
217         return true;
218     }
219 
220     /// @dev Required for ERC-721 compliance.
221     function name() public pure returns (string) {
222         return NAME;
223     }
224 
225     /// For querying owner of token
226     /// @param _tokenId The tokenID for owner inquiry
227     /// @dev Required for ERC-721 compliance.
228     function ownerOf(uint256 _tokenId)
229         public
230         view
231         returns (address owner)
232     {
233         owner = playerIndexToOwner[_tokenId];
234         require(owner != address(0));
235     }
236 
237     function payout(address _to) public onlyCLevel {
238         _payout(_to);
239     }
240 
241     // Allows someone to send ether and obtain the token
242     function purchase(uint256 _tokenId) public payable {
243         address oldOwner = playerIndexToOwner[_tokenId];
244         address newOwner = msg.sender;
245 
246         uint256 sellingPrice = playerIndexToPrice[_tokenId];
247 
248         // Making sure token owner is not sending to self
249         require(oldOwner != newOwner);
250 
251         // Safety check to prevent against an unexpected 0x0 default.
252         require(_addressNotNull(newOwner));
253 
254         // Making sure sent amount is greater than or equal to the sellingPrice
255         require(msg.value >= sellingPrice);
256 
257         uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
258         uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
259 
260         // Update prices
261         if (sellingPrice < firstStepLimit) {
262             // first stage
263             playerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, firstStepMultiplier), 94);
264         } else if (sellingPrice < secondStepLimit) {
265             // second stage
266             playerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, secondStepMultiplier), 94);
267         } else {
268             // third stage
269             playerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, thirdStepMultiplier), 94);
270         }
271 
272         _transfer(oldOwner, newOwner, _tokenId);
273         Snatch(_tokenId, oldOwner, newOwner);
274 
275         // Pay previous tokenOwner if owner is not contract
276         if (oldOwner != address(this)) {
277             oldOwner.transfer(payment); //(1-0.06)
278         }
279 
280         TokenSold(_tokenId, sellingPrice, playerIndexToPrice[_tokenId], oldOwner, newOwner, players[_tokenId].name);
281 
282         msg.sender.transfer(purchaseExcess);
283     }
284 
285     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
286         return playerIndexToPrice[_tokenId];
287     }
288 
289     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
290     /// @param _newCEO The address of the new CEO
291     function setCEO(address _newCEO) public onlyCEO {
292         require(_newCEO != address(0));
293 
294         ceoAddress = _newCEO;
295     }
296 
297     /// @dev Required for ERC-721 compliance.
298     function symbol() public pure returns (string) {
299         return SYMBOL;
300     }
301 
302     /// @notice Allow pre-approved user to take ownership of a token
303     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
304     /// @dev Required for ERC-721 compliance.
305     function takeOwnership(uint256 _tokenId) public {
306         address newOwner = msg.sender;
307         address oldOwner = playerIndexToOwner[_tokenId];
308 
309         // Safety check to prevent against an unexpected 0x0 default.
310         require(_addressNotNull(newOwner));
311 
312         // Making sure transfer is approved
313         require(_approved(newOwner, _tokenId));
314 
315         _transfer(oldOwner, newOwner, _tokenId);
316     }
317 
318     /// @param _owner The owner whose soccer player tokens we are interested in.
319     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
320     ///    expensive (it walks the entire Players array looking for players belonging to owner),
321     ///    but it also returns a dynamic array, which is only supported for web3 calls, and
322     ///    not contract-to-contract calls.
323     function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
324         uint256 tokenCount = balanceOf(_owner);
325         if (tokenCount == 0) {
326                 // Return an empty array
327             return new uint256[](0);
328         } else {
329             uint256[] memory result = new uint256[](tokenCount);
330             uint256 totalPlayers = totalSupply();
331             uint256 resultIndex = 0;
332 
333             uint256 playerId;
334             for (playerId = 0; playerId <= totalPlayers; playerId++) {
335                 if (playerIndexToOwner[playerId] == _owner) {
336                     result[resultIndex] = playerId;
337                     resultIndex++;
338                 }
339             }
340             return result;
341         }
342     }
343 
344     /// For querying totalSupply of token
345     /// @dev Required for ERC-721 compliance.
346     function totalSupply() public view returns (uint256 total) {
347         return players.length;
348     }
349 
350     /// Owner initates the transfer of the token to another account
351     /// @param _to The address for the token to be transferred to.
352     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
353     /// @dev Required for ERC-721 compliance.
354     function transfer(
355         address _to,
356         uint256 _tokenId
357     ) public {
358         require(_owns(msg.sender, _tokenId));
359         require(_addressNotNull(_to));
360 
361         _transfer(msg.sender, _to, _tokenId);
362     }
363 
364     /// Third-party initiates transfer of token from address _from to address _to
365     /// @param _from The address for the token to be transferred from.
366     /// @param _to The address for the token to be transferred to.
367     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
368     /// @dev Required for ERC-721 compliance.
369     function transferFrom(
370         address _from,
371         address _to,
372         uint256 _tokenId
373     ) public {
374         require(_owns(_from, _tokenId));
375         require(_approved(_to, _tokenId));
376         require(_addressNotNull(_to));
377 
378         _transfer(_from, _to, _tokenId);
379     }
380 
381     /*** PRIVATE FUNCTIONS ***/
382     /// Safety check on _to address to prevent against an unexpected 0x0 default.
383     function _addressNotNull(address _to) private pure returns (bool) {
384         return _to != address(0);
385     }
386 
387     /// For checking approval of transfer for address _to
388     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
389         return playerIndexToApproved[_tokenId] == _to;
390     }
391 
392     /// For creating Player
393     function _createPlayer(string _name, address _owner, uint256 _price, uint256 _internalPlayerId) private {
394         Player memory _player = Player({
395             name: _name,
396             internalPlayerId: _internalPlayerId
397         });
398         uint256 newPlayerId = players.push(_player) - 1;
399 
400         // It's probably never going to happen, 4 billion tokens are A LOT, but
401         // let's just be 100% sure we never let this happen.
402         require(newPlayerId == uint256(uint32(newPlayerId)));
403 
404         Birth(newPlayerId, _name, _owner);
405 
406         playerIndexToPrice[newPlayerId] = _price;
407 
408         // This will assign ownership, and also emit the Transfer event as
409         // per ERC721 draft
410         _transfer(address(0), _owner, newPlayerId);
411     }
412 
413     /// Check for token ownership
414     function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
415         return claimant == playerIndexToOwner[_tokenId];
416     }
417 
418     /// For paying out balance on contract
419     function _payout(address _to) private {
420         if (_to == address(0)) {
421             ceoAddress.transfer(this.balance);
422         } else {
423             _to.transfer(this.balance);
424         }
425     }
426 
427     /// @dev Assigns ownership of a specific Player to an address.
428     function _transfer(address _from, address _to, uint256 _tokenId) private {
429         // Since the number of players is capped to 2^32 we can't overflow this
430         ownershipTokenCount[_to]++;
431         //transfer ownership
432         playerIndexToOwner[_tokenId] = _to;
433 
434         // When creating new players _from is 0x0, but we can't account that address.
435         if (_from != address(0)) {
436             ownershipTokenCount[_from]--;
437             // clear any previously approved ownership exchange
438             delete playerIndexToApproved[_tokenId];
439         }
440 
441         // Emit the transfer event.
442         Transfer(_from, _to, _tokenId);
443     }
444 }