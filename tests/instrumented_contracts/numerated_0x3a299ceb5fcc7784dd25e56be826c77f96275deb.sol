1 pragma solidity ^0.4.18; // solhint-disable-line
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
49 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
50 contract ERC721 {
51   // Required methods
52   function approve(address _to, uint256 _tokenId) public;
53   function balanceOf(address _owner) public view returns (uint256 balance);
54   function implementsERC721() public pure returns (bool);
55   function ownerOf(uint256 _tokenId) public view returns (address addr);
56   function takeOwnership(uint256 _tokenId) public;
57   function totalSupply() public view returns (uint256 total);
58   function transferFrom(address _from, address _to, uint256 _tokenId) public;
59   function transfer(address _to, uint256 _tokenId) public;
60 
61   event Transfer(address indexed from, address indexed to, uint256 tokenId);
62   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
63 
64   // Optional
65   // function name() public view returns (string name);
66   // function symbol() public view returns (string symbol);
67   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
68   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
69 }
70 
71 
72 contract CryptoT is ERC721 {
73 
74   /*** EVENTS ***/
75 
76   /// @dev The Birth event is fired whenever a new person comes into existence.
77   event Birth(uint256 tokenId, string name, address owner);
78 
79   /// @dev The TokenSold event is fired whenever a token is sold.
80   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
81 
82   /// @dev Transfer event as defined in current draft of ERC721.
83   ///  ownership is assigned, including births.
84   event Transfer(address from, address to, uint256 tokenId);
85 
86   /*** CONSTANTS ***/
87 
88   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
89   string public constant NAME = "CryptoT"; // solhint-disable-line
90   string public constant SYMBOL = "CryptoT"; // solhint-disable-line
91 
92   uint256 private startingPrice = 1 ether;
93   uint256 private constant PROMO_CREATION_LIMIT = 50000;
94 
95   /*** STORAGE ***/
96 
97   /// @dev A mapping from person IDs to the address that owns them. All persons have
98   ///  some valid owner address.
99   mapping (uint256 => address) public teamIndexToOwner;
100 
101   // @dev A mapping from owner address to count of tokens that address owns.
102   //  Used internally inside balanceOf() to resolve ownership count.
103   mapping (address => uint256) private ownershipTokenCount;
104 
105   /// @dev A mapping from PersonIDs to an address that has been approved to call
106   ///  transferFrom(). Each Person can only have one approved address for transfer
107   ///  at any time. A zero value means no approval is outstanding.
108   mapping (uint256 => address) public teamIndexToApproved;
109 
110   // @dev A mapping from PersonIDs to the price of the token.
111   mapping (uint256 => uint256) private teamIndexToPrice;
112 
113   // The addresses of the accounts (or contracts) that can execute actions within each roles.
114   address public ceoAddress;
115   address public cooAddress;
116 
117   uint256 public promoCreatedCount = 0;
118 
119   /*** DATATYPES ***/
120   struct Team {
121     string name;
122   }
123 
124   Team[] private teams;
125 
126   /*** ACCESS MODIFIERS ***/
127   /// @dev Access modifier for CEO-only functionality
128   modifier onlyCEO() {
129     require(msg.sender == ceoAddress);
130     _;
131   }
132 
133   /// @dev Access modifier for COO-only functionality
134   modifier onlyCOO() {
135     require(msg.sender == cooAddress);
136     _;
137   }
138 
139   /// Access modifier for contract owner only functionality
140   modifier onlyCLevel() {
141     require(
142       msg.sender == ceoAddress ||
143       msg.sender == cooAddress
144     );
145     _;
146   }
147 
148   /*** CONSTRUCTOR ***/
149   function CryptoT() public {
150     ceoAddress = msg.sender;
151     cooAddress = msg.sender;
152   }
153 
154   /*** PUBLIC FUNCTIONS ***/
155   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
156   /// @param _to The address to be granted transfer approval. Pass address(0) to
157   ///  clear all approvals.
158   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
159   /// @dev Required for ERC-721 compliance.
160   function approve(
161     address _to,
162     uint256 _tokenId
163   ) public {
164     // Caller must own token.
165     require(_owns(msg.sender, _tokenId));
166 
167     teamIndexToApproved[_tokenId] = _to;
168 
169     Approval(msg.sender, _to, _tokenId);
170   }
171 
172   /// For querying balance of a particular account
173   /// @param _owner The address for balance query
174   /// @dev Required for ERC-721 compliance.
175   function balanceOf(address _owner) public view returns (uint256 balance) {
176     return ownershipTokenCount[_owner];
177   }
178 
179   /// @dev Creates a new promo Team with the given name, with given _price and assignes it to an address.
180   function createPromoTeam(address _owner, string _name, uint256 _price) public onlyCOO {
181 
182     require(promoCreatedCount < PROMO_CREATION_LIMIT);
183 
184     address teamOwner = _owner;
185 
186     if (teamOwner == address(0)) {
187       teamOwner = cooAddress;
188     }
189 
190     if (_price <= 0) {
191       _price = startingPrice;
192     }
193 
194     promoCreatedCount++;
195     _createTeam(_name, teamOwner, _price);
196 
197   }
198 
199   /// @notice Returns all the relevant information about a specific team.
200   /// @param _tokenId The tokenId of the team of interest.
201   function getTeam(uint256 _tokenId) public view returns (
202     string teamName,
203     uint256 sellingPrice,
204     address owner
205   ) {
206     Team storage team = teams[_tokenId];
207     teamName = team.name;
208     sellingPrice = teamIndexToPrice[_tokenId];
209     owner = teamIndexToOwner[_tokenId];
210   }
211 
212   function implementsERC721() public pure returns (bool) {
213     return true;
214   }
215 
216   /// @dev Required for ERC-721 compliance.
217   function name() public pure returns (string) {
218     return NAME;
219   }
220 
221   /// For querying owner of token
222   /// @param _tokenId The tokenID for owner inquiry
223   /// @dev Required for ERC-721 compliance.
224   function ownerOf(uint256 _tokenId)
225     public
226     view
227     returns (address owner)
228   {
229     owner = teamIndexToOwner[_tokenId];
230     require(owner != address(0));
231   }
232 
233   // Allows someone to send ether and obtain the token
234   function purchase(uint256 _tokenId) public payable {
235     address oldOwner = teamIndexToOwner[_tokenId];
236     address newOwner = msg.sender;
237 
238     uint256 sellingPrice = teamIndexToPrice[_tokenId];
239 
240     // Making sure token owner is not sending to self
241     require(oldOwner != newOwner);
242 
243     // Safety check to prevent against an unexpected 0x0 default.
244     require(_addressNotNull(newOwner));
245 
246     // Making sure sent amount is greater than or equal to the sellingPrice
247     require(msg.value >= sellingPrice);
248 
249     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
250 
251     teamIndexToPrice[_tokenId] = SafeMath.add(sellingPrice , 1 ether);
252 
253     _transfer(oldOwner, newOwner, _tokenId);
254 
255     // Pay previous tokenOwner if owner is not contract
256     if (oldOwner != address(this)) {
257       oldOwner.transfer(sellingPrice);
258     }
259 
260     TokenSold(_tokenId, sellingPrice, teamIndexToPrice[_tokenId], oldOwner, newOwner, teams[_tokenId].name);
261 
262     msg.sender.transfer(purchaseExcess);
263   }
264 
265   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
266     return teamIndexToPrice[_tokenId];
267   }
268 
269   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
270   /// @param _newCEO The address of the new CEO
271   function setCEO(address _newCEO) public onlyCEO {
272     require(_newCEO != address(0));
273 
274     ceoAddress = _newCEO;
275   }
276 
277   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
278   /// @param _newCOO The address of the new COO
279   function setCOO(address _newCOO) public onlyCEO {
280     require(_newCOO != address(0));
281 
282     cooAddress = _newCOO;
283   }
284 
285   /// @dev Required for ERC-721 compliance.
286   function symbol() public pure returns (string) {
287     return SYMBOL;
288   }
289 
290   /// @notice Allow pre-approved user to take ownership of a token
291   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
292   /// @dev Required for ERC-721 compliance.
293   function takeOwnership(uint256 _tokenId) public {
294     address newOwner = msg.sender;
295     address oldOwner = teamIndexToOwner[_tokenId];
296 
297     // Safety check to prevent against an unexpected 0x0 default.
298     require(_addressNotNull(newOwner));
299 
300     // Making sure transfer is approved
301     require(_approved(newOwner, _tokenId));
302 
303     _transfer(oldOwner, newOwner, _tokenId);
304   }
305 
306   /// @param _owner The owner whose celebrity tokens we are interested in.
307   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
308   ///  expensive (it walks the entire teams array looking for Team's belonging to owner),
309   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
310   ///  not contract-to-contract calls.
311   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
312     uint256 tokenCount = balanceOf(_owner);
313     if (tokenCount == 0) {
314         // Return an empty array
315       return new uint256[](0);
316     } else {
317       uint256[] memory result = new uint256[](tokenCount);
318       uint256 totalTeams = totalSupply();
319       uint256 resultIndex = 0;
320 
321       uint256 teamId;
322       for (teamId = 0; teamId <= totalTeams; teamId++) {
323         if (teamIndexToOwner[teamId] == _owner) {
324           result[resultIndex] = teamId;
325           resultIndex++;
326         }
327       }
328       return result;
329     }
330   }
331 
332   /// For querying totalSupply of token
333   /// @dev Required for ERC-721 compliance.
334   function totalSupply() public view returns (uint256 total) {
335     return teams.length;
336   }
337 
338   /// Owner initates the transfer of the token to another account
339   /// @param _to The address for the token to be transferred to.
340   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
341   /// @dev Required for ERC-721 compliance.
342   function transfer(
343     address _to,
344     uint256 _tokenId
345   ) public {
346     require(_owns(msg.sender, _tokenId));
347     require(_addressNotNull(_to));
348 
349     _transfer(msg.sender, _to, _tokenId);
350   }
351 
352   /// Third-party initiates transfer of token from address _from to address _to
353   /// @param _from The address for the token to be transferred from.
354   /// @param _to The address for the token to be transferred to.
355   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
356   /// @dev Required for ERC-721 compliance.
357   function transferFrom(
358     address _from,
359     address _to,
360     uint256 _tokenId
361   ) public {
362     require(_owns(_from, _tokenId));
363     require(_approved(_to, _tokenId));
364     require(_addressNotNull(_to));
365 
366     _transfer(_from, _to, _tokenId);
367   }
368 
369   /*** PRIVATE FUNCTIONS ***/
370   /// Safety check on _to address to prevent against an unexpected 0x0 default.
371   function _addressNotNull(address _to) private pure returns (bool) {
372     return _to != address(0);
373   }
374 
375   /// For checking approval of transfer for address _to
376   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
377     return teamIndexToApproved[_tokenId] == _to;
378   }
379 
380   /// For creating team
381   function _createTeam(string _name, address _owner, uint256 _price) private {
382 
383     Team memory _team = Team({
384       name: _name
385     });
386 
387     uint256 newTeamId = teams.push(_team) - 1;
388 
389     // It's probably never going to happen, 4 billion tokens are A LOT, but
390     // let's just be 100% sure we never let this happen.
391     require(newTeamId == uint256(uint32(newTeamId)));
392 
393     Birth(newTeamId, _name, _owner);
394 
395     teamIndexToPrice[newTeamId] = _price;
396 
397     // This will assign ownership, and also emit the Transfer event as
398     // per ERC721 draft
399     _transfer(address(0), _owner, newTeamId);
400   }
401 
402   /// Check for token ownership
403   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
404     return claimant == teamIndexToOwner[_tokenId];
405   }
406 
407   /// @dev Assigns ownership of a specific Team to an address.
408   function _transfer(address _from, address _to, uint256 _tokenId) private {
409     // Since the number of teams is capped to 2^32 we can't overflow this
410     ownershipTokenCount[_to]++;
411     //transfer ownership
412     teamIndexToOwner[_tokenId] = _to;
413 
414     // When creating new teams _from is 0x0, but we can't account that address.
415     if (_from != address(0)) {
416       ownershipTokenCount[_from]--;
417       // clear any previously approved ownership exchange
418       delete teamIndexToApproved[_tokenId];
419     }
420 
421     // Emit the transfer event.
422     Transfer(_from, _to, _tokenId);
423   }
424 }