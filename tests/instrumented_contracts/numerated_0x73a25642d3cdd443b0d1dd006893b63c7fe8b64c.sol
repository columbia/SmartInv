1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 contract ERC721 {
7   // Required methods
8   function approve(address _to, uint256 _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint256 _tokenId) public view returns (address addr);
12   function takeOwnership(uint256 _tokenId) public;
13   function transferFrom(address _from, address _to, uint256 _tokenId) public;
14   function transfer(address _to, uint256 _tokenId) public;
15   uint256 public totalSupply;
16 
17   event Transfer(address indexed from, address indexed to, uint256 tokenId);
18   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 
20   // Optional
21   // function name() public view returns (string name);
22   // function symbol() public view returns (string symbol);
23   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
24   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
25 }
26 
27 
28 contract CollectibleToken is ERC721 {
29 
30   /*** EVENTS ***/
31 
32   /// @dev The Birth event is fired whenever a new person comes into existence.
33   event Birth(uint256 tokenId, uint256 startPrice, uint256 totalSupply);
34 
35   /// @dev The TokenSold event is fired whenever a token is sold.
36   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner);
37 
38   /// @dev Transfer event as defined in current draft of ERC721. 
39   ///  ownership is assigned, including births.
40   event Transfer(address from, address to, uint256 tokenId);
41 
42   /*** CONSTANTS ***/
43 
44   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
45   string public constant NAME = "pornstars-youCollect"; // solhint-disable-line
46   string public constant SYMBOL = "PYC"; // solhint-disable-line
47   uint256 private startingPrice = 0.001 ether;
48   uint256 private constant PROMO_CREATION_LIMIT = 5000;
49   uint256 private firstStepLimit =  0.053613 ether;
50   uint256 private secondStepLimit = 0.564957 ether;
51 
52 
53   /*** STORAGE ***/
54 
55   /// @dev A mapping from person IDs to the address that owns them. All persons have
56   ///  some valid owner address.
57   mapping (uint256 => address) public personIndexToOwner;
58 
59   // @dev A mapping from owner address to count of tokens that address owns.
60   //  Used internally inside balanceOf() to resolve ownership count.
61   mapping (address => uint256) private ownershipTokenCount;
62 
63   /// @dev A mapping from PersonIDs to an address that has been approved to call
64   ///  transferFrom(). Each Person can only have one approved address for transfer
65   ///  at any time. A zero value means no approval is outstanding.
66   mapping (uint256 => address) public personIndexToApproved;
67 
68   // @dev A mapping from PersonIDs to the price of the token.
69   mapping (uint256 => uint256) private personIndexToPrice;
70 
71   // The addresses of the accounts (or contracts) that can execute actions within each roles.
72   address public ceoAddress;
73   address public cooAddress;
74 
75   uint256 public promoCreatedCount;
76 
77   /*** ACCESS MODIFIERS ***/
78   /// @dev Access modifier for CEO-only functionality
79   modifier onlyCEO() {
80     require(msg.sender == ceoAddress);
81     _;
82   }
83 
84   /// @dev Access modifier for COO-only functionality
85   modifier onlyCOO() {
86     require(msg.sender == cooAddress);
87     _;
88   }
89 
90   /// Access modifier for contract owner only functionality
91   modifier onlyCLevel() {
92     require(
93       msg.sender == ceoAddress ||
94       msg.sender == cooAddress
95     );
96     _;
97   }
98 
99   /*** CONSTRUCTOR ***/
100   function CollectibleToken() public {
101     ceoAddress = msg.sender;
102     cooAddress = msg.sender;
103   }
104 
105   /*** PUBLIC FUNCTIONS ***/
106   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
107   /// @param _to The address to be granted transfer approval. Pass address(0) to
108   ///  clear all approvals.
109   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
110   /// @dev Required for ERC-721 compliance.
111   function approve(
112     address _to,
113     uint256 _tokenId
114   ) public {
115     // Caller must own token.
116     require(_owns(msg.sender, _tokenId));
117 
118     personIndexToApproved[_tokenId] = _to;
119 
120     Approval(msg.sender, _to, _tokenId);
121   }
122 
123   /// For querying balance of a particular account
124   /// @param _owner The address for balance query
125   /// @dev Required for ERC-721 compliance.
126   function balanceOf(address _owner) public view returns (uint256 balance) {
127     return ownershipTokenCount[_owner];
128   }
129 
130   /// @dev Creates a new promo Person with the given name, with given _price and assignes it to an address.
131   function createPromoPerson(uint256 tokenId, address _owner, uint256 _price) public onlyCOO {
132     require(personIndexToOwner[tokenId]==address(0));
133     require(promoCreatedCount < PROMO_CREATION_LIMIT);
134 
135     address personOwner = _owner;
136     if (personOwner == address(0)) {
137       personOwner = cooAddress;
138     }
139 
140     if (_price <= 0) {
141       _price = startingPrice;
142     }
143 
144     promoCreatedCount++;
145     _createPerson(tokenId, _price);
146     // This will assign ownership, and also emit the Transfer event as
147     // per ERC721 draft
148     _transfer(address(0), personOwner, tokenId);
149 
150   }
151 
152   /// @notice Returns all the relevant information about a specific person.
153   /// @param _tokenId The tokenId of the person of interest.
154   function getPerson(uint256 _tokenId) public view returns (uint256 tokenId,
155     uint256 sellingPrice,
156     address owner,
157     uint256 nextSellingPrice
158   ) {
159     tokenId = _tokenId;
160     sellingPrice = personIndexToPrice[_tokenId];
161     owner = personIndexToOwner[_tokenId];
162 
163     if (sellingPrice == 0)
164       sellingPrice = startingPrice;
165     if (sellingPrice < firstStepLimit) {
166       nextSellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
167     } else if (sellingPrice < secondStepLimit) {
168       nextSellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
169     } else {
170       nextSellingPrice = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
171     }
172   }
173 
174   function implementsERC721() public pure returns (bool) {
175     return true;
176   }
177 
178   /// @dev Required for ERC-721 compliance.
179   function name() public pure returns (string) {
180     return NAME;
181   }
182 
183   /// For querying owner of token
184   /// @param _tokenId The tokenID for owner inquiry
185   /// @dev Required for ERC-721 compliance.
186   function ownerOf(uint256 _tokenId)
187     public
188     view
189     returns (address owner)
190   {
191     owner = personIndexToOwner[_tokenId];
192     require(owner != address(0));
193   }
194 
195   function payout(address _to) public onlyCLevel {
196     _payout(_to);
197   }
198 
199   // Allows someone to send ether and obtain the token
200   function purchase(uint256 _tokenId) public payable {
201     address oldOwner = personIndexToOwner[_tokenId];
202     address newOwner = msg.sender;
203 
204     uint256 sellingPrice = personIndexToPrice[_tokenId];
205     if (sellingPrice == 0) {
206       sellingPrice = startingPrice;
207       _createPerson(_tokenId, sellingPrice);
208     }
209 
210     // Safety check to prevent against an unexpected 0x0 default.
211     require(_addressNotNull(newOwner));
212 
213     // Making sure sent amount is greater than or equal to the sellingPrice
214     require(msg.value >= sellingPrice);
215 
216     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 94), 100));
217     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
218 
219     // Update prices
220     if (sellingPrice < firstStepLimit) {
221       // first stage
222       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);
223     } else if (sellingPrice < secondStepLimit) {
224       // second stage
225       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);
226     } else {
227       // third stage
228       personIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);
229     }
230 
231     _transfer(oldOwner, newOwner, _tokenId);
232 
233     // Pay previous tokenOwner if owner is not contract
234     if (oldOwner != address(this) && oldOwner != address(0)) {
235       oldOwner.transfer(payment); //(1-0.06)
236     }
237 
238     TokenSold(_tokenId, sellingPrice, personIndexToPrice[_tokenId], oldOwner, newOwner);
239 
240     msg.sender.transfer(purchaseExcess);
241   }
242 
243   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
244     price = personIndexToPrice[_tokenId];
245     if (price == 0)
246       price = startingPrice;
247   }
248 
249   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
250   /// @param _newCEO The address of the new CEO
251   function setCEO(address _newCEO) public onlyCEO {
252     require(_newCEO != address(0));
253 
254     ceoAddress = _newCEO;
255   }
256 
257   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
258   /// @param _newCOO The address of the new COO
259   function setCOO(address _newCOO) public onlyCEO {
260     require(_newCOO != address(0));
261 
262     cooAddress = _newCOO;
263   }
264 
265   /// @dev Required for ERC-721 compliance.
266   function symbol() public pure returns (string) {
267     return SYMBOL;
268   }
269 
270   /// @notice Allow pre-approved user to take ownership of a token
271   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
272   /// @dev Required for ERC-721 compliance.
273   function takeOwnership(uint256 _tokenId) public {
274     address newOwner = msg.sender;
275     address oldOwner = personIndexToOwner[_tokenId];
276 
277     // Safety check to prevent against an unexpected 0x0 default.
278     require(_addressNotNull(newOwner));
279 
280     // Making sure transfer is approved
281     require(_approved(newOwner, _tokenId));
282 
283     _transfer(oldOwner, newOwner, _tokenId);
284   }
285 
286   /// Owner initates the transfer of the token to another account
287   /// @param _to The address for the token to be transferred to.
288   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
289   /// @dev Required for ERC-721 compliance.
290   function transfer(
291     address _to,
292     uint256 _tokenId
293   ) public {
294     require(_owns(msg.sender, _tokenId));
295     require(_addressNotNull(_to));
296 
297     _transfer(msg.sender, _to, _tokenId);
298   }
299 
300   /// Third-party initiates transfer of token from address _from to address _to
301   /// @param _from The address for the token to be transferred from.
302   /// @param _to The address for the token to be transferred to.
303   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
304   /// @dev Required for ERC-721 compliance.
305   function transferFrom(
306     address _from,
307     address _to,
308     uint256 _tokenId
309   ) public {
310     require(_owns(_from, _tokenId));
311     require(_approved(_to, _tokenId));
312     require(_addressNotNull(_to));
313 
314     _transfer(_from, _to, _tokenId);
315   }
316 
317   /*** PRIVATE FUNCTIONS ***/
318   /// Safety check on _to address to prevent against an unexpected 0x0 default.
319   function _addressNotNull(address _to) private pure returns (bool) {
320     return _to != address(0);
321   }
322 
323   /// For checking approval of transfer for address _to
324   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
325     return personIndexToApproved[_tokenId] == _to;
326   }
327 
328   /// For creating Person
329   function _createPerson(uint256 tokenId, uint256 _price) private {
330     personIndexToPrice[tokenId] = _price;
331     totalSupply++;
332     Birth(tokenId, _price, totalSupply);
333   }
334 
335   /// Check for token ownership
336   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
337     return claimant == personIndexToOwner[_tokenId];
338   }
339 
340   /// For paying out balance on contract
341   function _payout(address _to) private {
342     if (_to == address(0)) {
343       ceoAddress.transfer(this.balance);
344     } else {
345       _to.transfer(this.balance);
346     }
347   }
348 
349   /// @dev Assigns ownership of a specific Person to an address.
350   function _transfer(address _from, address _to, uint256 _tokenId) private {
351     // Since the number of persons is capped to 2^32 we can't overflow this
352     ownershipTokenCount[_to]++;
353     //transfer ownership
354     personIndexToOwner[_tokenId] = _to;
355 
356     // When creating new persons _from is 0x0, but we can't account that address.
357     if (_from != address(0)) {
358       ownershipTokenCount[_from]--;
359       // clear any previously approved ownership exchange
360       delete personIndexToApproved[_tokenId];
361     }
362 
363     // Emit the transfer event.
364     Transfer(_from, _to, _tokenId);
365   }
366 }
367 library SafeMath {
368 
369   /**
370   * @dev Multiplies two numbers, throws on overflow.
371   */
372   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
373     if (a == 0) {
374       return 0;
375     }
376     uint256 c = a * b;
377     assert(c / a == b);
378     return c;
379   }
380 
381   /**
382   * @dev Integer division of two numbers, truncating the quotient.
383   */
384   function div(uint256 a, uint256 b) internal pure returns (uint256) {
385     // assert(b > 0); // Solidity automatically throws when dividing by 0
386     uint256 c = a / b;
387     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
388     return c;
389   }
390 
391   /**
392   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
393   */
394   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
395     assert(b <= a);
396     return a - b;
397   }
398 
399   /**
400   * @dev Adds two numbers, throws on overflow.
401   */
402   function add(uint256 a, uint256 b) internal pure returns (uint256) {
403     uint256 c = a + b;
404     assert(c >= a);
405     return c;
406   }
407 }