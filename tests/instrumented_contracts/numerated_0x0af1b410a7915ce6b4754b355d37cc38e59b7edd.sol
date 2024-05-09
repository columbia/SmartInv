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
28 
29 contract AthleteToken is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev Birth event fired whenever a new athlete is created
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev TokenSold event fired whenever a token is sold
37   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
38 
39   /// @dev Transfer event as defined in ERC721. Ownership is assigned, including births.
40   event Transfer(address from, address to, uint256 tokenId);
41 
42   /*** CONSTANTS ***/
43 
44   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
45   string public constant NAME = "CryptoAthletes"; // solhint-disable-line
46   string public constant SYMBOL = "AthleteToken"; // solhint-disable-line
47 
48   uint256 private startingPrice = 0.001 ether;
49   uint256 private constant PROMO_CREATION_LIMIT = 5000;
50   uint256 private firstStepLimit = 0.05 ether;
51   uint256 private secondStepLimit = 0.5 ether;
52   uint256 private thirdStepLimit = 5 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev Map athlete IDs to owner address. All athletes have some valid owner address.
57   mapping (uint256 => address) public athleteIdToOwner;
58 
59   // @dev Map owner address to count of tokens that address owns. Used internally inside balanceOf() to resolve ownership count.
60   mapping (address => uint256) private ownershipTokenCount;
61 
62   /// @dev Map from athlete IDs to an address that has been approved to call transferFrom(). Each athlete can only have one approved address for transfer
63   ///  at any time. A zero value means no approval is outstanding.
64   mapping (uint256 => address) public athleteIdToApproved;
65 
66   // @dev Map from athlete IDs to the price of the token
67   mapping (uint256 => uint256) private athleteIdToPrice;
68 
69   // Addresses of the accounts (or contracts) that can execute actions within each roles.
70   address public roleAdminAddress;
71   address public roleEditorAddress;
72 
73   uint256 public promoCreatedCount;
74 
75   /*** DATATYPES ***/
76   struct Athlete {
77     string name;
78   }
79 
80   Athlete[] private athletes;
81 
82   /*** ACCESS MODIFIERS ***/
83   
84   /// @dev Access modifier for Admin-only
85   modifier onlyAdmin() {
86     require(msg.sender == roleAdminAddress);
87     _;
88   }
89 
90   /// @dev Access modifier for Editor-only
91   modifier onlyEditor() {
92     require(msg.sender == roleEditorAddress);
93     _;
94   }
95 
96   /// Access modifier for contract owner only
97   modifier onlyTeamLevel() {
98     require(
99       msg.sender == roleAdminAddress ||
100       msg.sender == roleEditorAddress
101     );
102     _;
103   }
104 
105   /*** CONSTRUCTOR ***/
106 
107   function AthleteToken() public {
108     roleAdminAddress = msg.sender;
109     roleEditorAddress = msg.sender;
110   }
111 
112   /*** PUBLIC FUNCTIONS ***/
113 
114   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
115   /// @param _to The address to be granted transfer approval. Pass address(0) to
116   ///  clear all approvals.
117   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
118   /// @dev Required for ERC-721 compliance.
119   function approve(
120     address _to,
121     uint256 _tokenId
122   ) public {
123     // Caller must own token.
124     require(_owns(msg.sender, _tokenId));
125 
126     athleteIdToApproved[_tokenId] = _to;
127 
128     Approval(msg.sender, _to, _tokenId);
129   }
130 
131   /// For querying balance of a particular account
132   /// @param _owner The address for balance query
133   /// @dev Required for ERC-721 compliance.
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return ownershipTokenCount[_owner];
136   }
137 
138   /// @dev Creates a new assigned athlete
139   function createAssignedAthlete(address _owner, string _name, uint256 _price) public onlyEditor {
140     require(promoCreatedCount < PROMO_CREATION_LIMIT);
141 
142     address athleteOwner = _owner;
143     if (athleteOwner == address(0)) {
144       athleteOwner = roleEditorAddress;
145     }
146 
147     if (_price <= 0) {
148       _price = startingPrice;
149     }
150 
151     promoCreatedCount++;
152     _createAthlete(_name, athleteOwner, _price);
153   }
154 
155   /// @dev Creates a new Athlete with the given name.
156   function createContractAthlete(string _name) public onlyEditor {
157     _createAthlete(_name, address(this), startingPrice);
158   }
159 
160   /// @notice Returns all the relevant information about a specific athlete.
161   /// @param _tokenId The tokenId of the athlete of interest.
162   function getAthlete(uint256 _tokenId) public view returns (
163     string athleteName,
164     uint256 sellingPrice,
165     address owner
166   ) {
167     Athlete storage athlete = athletes[_tokenId];
168     athleteName = athlete.name;
169     sellingPrice = athleteIdToPrice[_tokenId];
170     owner = athleteIdToOwner[_tokenId];
171   }
172 
173   function implementsERC721() public pure returns (bool) {
174     return true;
175   }
176 
177   /// @dev Required for ERC-721 compliance.
178   function name() public pure returns (string) {
179     return NAME;
180   }
181 
182   /// For querying owner of token
183   /// @param _tokenId The tokenID for owner inquiry
184   /// @dev Required for ERC-721 compliance.
185   function ownerOf(uint256 _tokenId)
186     public
187     view
188     returns (address owner)
189   {
190     owner = athleteIdToOwner[_tokenId];
191     require(owner != address(0));
192   }
193 
194   function payout(address _to) public onlyTeamLevel {
195     _payout(_to);
196   }
197 
198   // Allows someone to send ether and obtain the token
199   function purchase(uint256 _tokenId) public payable {
200     address oldOwner = athleteIdToOwner[_tokenId];
201     address newOwner = msg.sender;
202 
203     uint256 sellingPrice = athleteIdToPrice[_tokenId];
204 
205     // Making sure token owner is not sending to self
206     require(oldOwner != newOwner);
207 
208     // Safety check to prevent against an unexpected 0x0 default.
209     require(_addressNotNull(newOwner));
210 
211     // Making sure sent amount is greater than or equal to the sellingPrice
212     require(msg.value >= sellingPrice);
213 
214     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
215     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
216 
217     // Update prices
218     if (sellingPrice < firstStepLimit) {
219       // first stage
220       athleteIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
221     } else if (sellingPrice < secondStepLimit) {
222       // second stage
223       athleteIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
224     } else {
225       // third stage
226       athleteIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
227     }
228 
229     _transfer(oldOwner, newOwner, _tokenId);
230 
231     // Pay previous tokenOwner if owner is not contract
232     if (oldOwner != address(this)) {
233       oldOwner.transfer(payment); // (1-0.06)
234     }
235 
236     TokenSold(_tokenId, sellingPrice, athleteIdToPrice[_tokenId], oldOwner, newOwner, athletes[_tokenId].name);
237 
238     msg.sender.transfer(purchaseExcess);
239   }
240 
241   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
242     return athleteIdToPrice[_tokenId];
243   }
244 
245   /// @dev Assigns a new address to act as the Admin
246   /// @param _newAdmin The address of the new Admin
247   function setAdmin(address _newAdmin) public onlyAdmin {
248     require(_newAdmin != address(0));
249     roleAdminAddress = _newAdmin;
250   }
251 
252   /// @dev Assigns a new address to act as the Editor
253   /// @param _newEditor The address of the new Editor
254   function setEditor(address _newEditor) public onlyAdmin {
255     require(_newEditor != address(0));
256     roleEditorAddress = _newEditor;
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
269     address oldOwner = athleteIdToOwner[_tokenId];
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
280   /// @param _owner The owner whose athlete tokens we are interested in.
281   /// @dev This method MUST NEVER be called by smart contract code: It's fairly expensive 
282   ///  and returns a dynamic array, which is only supported for web3 calls, and not contract-to-contract calls.
283   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
284     uint256 tokenCount = balanceOf(_owner);
285     if (tokenCount == 0) {
286         // Return an empty array
287       return new uint256[](0);
288     } else {
289       uint256[] memory result = new uint256[](tokenCount);
290       uint256 totalAthletes = totalSupply();
291       uint256 resultIndex = 0;
292 
293       uint256 athleteId;
294       for (athleteId = 0; athleteId <= totalAthletes; athleteId++) {
295         if (athleteIdToOwner[athleteId] == _owner) {
296           result[resultIndex] = athleteId;
297           resultIndex++;
298         }
299       }
300       return result;
301     }
302   }
303 
304   /// For querying totalSupply of token
305   /// @dev Required for ERC-721 compliance.
306   function totalSupply() public view returns (uint256 total) {
307     return athletes.length;
308   }
309 
310   /// Owner initates the transfer of the token to another account
311   /// @param _to The address for the token to be transferred to.
312   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
313   /// @dev Required for ERC-721 compliance.
314   function transfer(
315     address _to,
316     uint256 _tokenId
317   ) public {
318     require(_owns(msg.sender, _tokenId));
319     require(_addressNotNull(_to));
320 
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
337 
338     _transfer(_from, _to, _tokenId);
339   }
340 
341   /*** PRIVATE FUNCTIONS ***/
342 
343   /// Safety check on _to address to prevent against an unexpected 0x0 default.
344   function _addressNotNull(address _to) private pure returns (bool) {
345     return _to != address(0);
346   }
347 
348   /// For checking approval of transfer for address _to
349   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
350     return athleteIdToApproved[_tokenId] == _to;
351   }
352 
353   /// Create athlete
354   function _createAthlete(string _name, address _owner, uint256 _price) private {
355     Athlete memory _athlete = Athlete({
356       name: _name
357     });
358     uint256 newAthleteId = athletes.push(_athlete) - 1;
359 
360     // It's probably never going to happen, 4 billion tokens are A LOT, but
361     // let's just be 100% sure we never let this happen.
362     require(newAthleteId == uint256(uint32(newAthleteId)));
363 
364     Birth(newAthleteId, _name, _owner);
365 
366     athleteIdToPrice[newAthleteId] = _price;
367 
368     // This will assign ownership, and also emit the Transfer event as
369     // per ERC721 draft
370     _transfer(address(0), _owner, newAthleteId);
371   }
372 
373   /// Check for token ownership
374   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
375     return claimant == athleteIdToOwner[_tokenId];
376   }
377 
378   /// For paying out balance on contract
379   function _payout(address _to) private {
380     if (_to == address(0)) {
381       roleAdminAddress.transfer(this.balance);
382     } else {
383       _to.transfer(this.balance);
384     }
385   }
386 
387   /// @dev Assigns ownership of a specific athlete to an address.
388   function _transfer(address _from, address _to, uint256 _tokenId) private {
389     // Since the number of athletes is capped to 2^32 we can't overflow this
390     ownershipTokenCount[_to]++;
391     //transfer ownership
392     athleteIdToOwner[_tokenId] = _to;
393 
394     // When creating new athletes _from is 0x0, but we can't account that address
395     if (_from != address(0)) {
396       ownershipTokenCount[_from]--;
397       // clear any previously approved ownership exchange
398       delete athleteIdToApproved[_tokenId];
399     }
400 
401     // Emit the transfer event.
402     Transfer(_from, _to, _tokenId);
403   }
404 }
405 
406 library SafeMath {
407 
408   /**
409   * @dev Multiplies two numbers, throws on overflow.
410   */
411   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
412     if (a == 0) {
413       return 0;
414     }
415     uint256 c = a * b;
416     assert(c / a == b);
417     return c;
418   }
419 
420   /**
421   * @dev Integer division of two numbers, truncating the quotient.
422   */
423   function div(uint256 a, uint256 b) internal pure returns (uint256) {
424     // assert(b > 0); // Solidity automatically throws when dividing by 0
425     uint256 c = a / b;
426     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
427     return c;
428   }
429 
430   /**
431   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
432   */
433   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
434     assert(b <= a);
435     return a - b;
436   }
437 
438   /**
439   * @dev Adds two numbers, throws on overflow.
440   */
441   function add(uint256 a, uint256 b) internal pure returns (uint256) {
442     uint256 c = a + b;
443     assert(c >= a);
444     return c;
445   }
446 }