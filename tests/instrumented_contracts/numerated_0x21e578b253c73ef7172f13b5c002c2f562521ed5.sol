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
26 contract CryptoTubers is ERC721 {
27 
28   /*** EVENTS ***/
29 
30   /// @dev The Birth event is fired whenever a new Tuber comes into existence.
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
43   string public constant NAME = "CryptoTubers"; // solhint-disable-line
44   string public constant SYMBOL = "CTUBE"; // solhint-disable-line
45 
46   uint256 private startingPrice = 0.001 ether;
47   uint256 private firstStepLimit =  0.053613 ether;
48   uint256 private secondStepLimit = 0.564957 ether;
49 
50   /*** STORAGE ***/
51 
52   /// @dev A mapping from tuber IDs to the address that owns them. All tubers have
53   ///  some valid owner address.
54   mapping (uint256 => address) public tuberIndexToOwner;
55 
56   // @dev A mapping from owner address to count of tokens that address owns.
57   //  Used internally inside balanceOf() to resolve ownership count.
58   mapping (address => uint256) private ownershipTokenCount;
59 
60   /// @dev A mapping from TuberIDs to an address that has been approved to call
61   ///  transferFrom(). Each Tuber can only have one approved address for transfer
62   ///  at any time. A zero value means no approval is outstanding.
63   mapping (uint256 => address) public tuberIndexToApproved;
64 
65   // @dev A mapping from TuberIDs to the price of the token.
66   mapping (uint256 => uint256) private tuberIndexToPrice;
67 
68   // The addresses of the accounts (or contracts) that can execute actions within each roles.
69   address public ceoAddress;
70   address public cooAddress;
71 
72   /*** DATATYPES ***/
73   struct Tuber {
74     string name;
75   }
76 
77   Tuber[] private tubers;
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
102   function CryptoTubers() public {
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
117 	{
118     // Caller must own token.
119     require(_owns(msg.sender, _tokenId));
120 
121     tuberIndexToApproved[_tokenId] = _to;
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
133   /// @dev Creates a new Tuber with the given name.
134   function createContractTuber(string _name) public onlyCLevel {
135     _createTuber(_name, address(this), startingPrice);
136   }
137 
138   /// @notice Returns all the relevant information about a specific tuber.
139   /// @param _tokenId The tokenId of the tuber of interest.
140   function getTuber(uint256 _tokenId) public view returns (
141     string tuberName,
142     uint256 sellingPrice,
143     address owner
144   ) {
145     Tuber storage tuber = tubers[_tokenId];
146     tuberName = tuber.name;
147     sellingPrice = tuberIndexToPrice[_tokenId];
148     owner = tuberIndexToOwner[_tokenId];
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
168     owner = tuberIndexToOwner[_tokenId];
169     require(owner != address(0));
170   }
171 
172   function payout(address _to) public onlyCLevel {
173     _payout(_to);
174   }
175 
176   // Allows someone to send ether and obtain the token
177   function purchase(uint256 _tokenId) public payable {
178     address oldOwner = tuberIndexToOwner[_tokenId];
179     address newOwner = msg.sender;
180 
181     uint256 sellingPrice = tuberIndexToPrice[_tokenId];
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
198       tuberIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 90);
199     } else if (sellingPrice < secondStepLimit) {
200       // second stage
201       tuberIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 90);
202     } else {
203       // third stage
204       tuberIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 90);
205     }
206 
207     _transfer(oldOwner, newOwner, _tokenId);
208 
209     // Pay previous tokenOwner if owner is not contract
210     if (oldOwner != address(this)) {
211       oldOwner.transfer(payment); //(1-0.08)
212     }
213 
214     TokenSold(_tokenId, sellingPrice, tuberIndexToPrice[_tokenId], oldOwner, newOwner, tubers[_tokenId].name);
215 
216     msg.sender.transfer(purchaseExcess);
217   }
218 
219   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
220     return tuberIndexToPrice[_tokenId];
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
249     address oldOwner = tuberIndexToOwner[_tokenId];
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
260   /// @param _owner The owner whose tuber tokens we are interested in.
261   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
262   ///  expensive (it walks the entire tubers array looking for tubers belonging to owner),
263   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
264   ///  not contract-to-contract calls.
265   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
266     uint256 tokenCount = balanceOf(_owner);
267     if (tokenCount == 0) {
268         // Return an empty array
269       return new uint256[](0);
270     } else {
271       uint256[] memory result = new uint256[](tokenCount);
272       uint256 totalTubers = totalSupply();
273       uint256 resultIndex = 0;
274 
275       uint256 tuberId;
276       for (tuberId = 0; tuberId <= totalTubers; tuberId++) {
277         if (tuberIndexToOwner[tuberId] == _owner) {
278           result[resultIndex] = tuberId;
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
289     return tubers.length;
290   }
291 
292   /// Owner initates the transfer of the token to another account
293   /// @param _to The address for the token to be transferred to.
294   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
295   /// @dev Required for ERC-721 compliance.
296   function transfer(
297     address _to,
298     uint256 _tokenId
299   ) public
300 	{
301     require(_owns(msg.sender, _tokenId));
302     require(_addressNotNull(_to));
303 
304     _transfer(msg.sender, _to, _tokenId);
305   }
306 
307   /// Third-party initiates transfer of token from address _from to address _to
308   /// @param _from The address for the token to be transferred from.
309   /// @param _to The address for the token to be transferred to.
310   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
311   /// @dev Required for ERC-721 compliance.
312   function transferFrom(
313     address _from,
314     address _to,
315     uint256 _tokenId
316   ) public
317 	{
318     require(_owns(_from, _tokenId));
319     require(_approved(_to, _tokenId));
320     require(_addressNotNull(_to));
321 
322     _transfer(_from, _to, _tokenId);
323   }
324 
325   /*** PRIVATE FUNCTIONS ***/
326   /// Safety check on _to address to prevent against an unexpected 0x0 default.
327   function _addressNotNull(address _to) private pure returns (bool) {
328     return _to != address(0);
329   }
330 
331   /// For checking approval of transfer for address _to
332   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
333     return tuberIndexToApproved[_tokenId] == _to;
334   }
335 
336   /// For creating Tubers
337   function _createTuber(string _name, address _owner, uint256 _price) private {
338     Tuber memory _tuber = Tuber({
339       name: _name
340     });
341     uint256 newTuberId = tubers.push(_tuber) - 1;
342 
343     // It's probably never going to happen, 4 billion tokens are A LOT, but
344     // let's just be 100% sure we never let this happen.
345     require(newTuberId == uint256(uint32(newTuberId)));
346 
347     Birth(newTuberId, _name, _owner);
348 
349     tuberIndexToPrice[newTuberId] = _price;
350 
351     // This will assign ownership, and also emit the Transfer event as
352     // per ERC721 draft
353     _transfer(address(0), _owner, newTuberId);
354   }
355 
356   /// Check for token ownership
357   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
358     return claimant == tuberIndexToOwner[_tokenId];
359   }
360 
361   /// For paying out balance on contract
362   function _payout(address _to) private {
363     if (_to == address(0)) {
364       ceoAddress.transfer(this.balance);
365     } else {
366       _to.transfer(this.balance);
367     }
368   }
369 
370   /// @dev Assigns ownership of a specific Tuber to an address.
371   function _transfer(address _from, address _to, uint256 _tokenId) private {
372     // Since the number of tubers is capped to 2^32 we can't overflow this
373     ownershipTokenCount[_to]++;
374     //transfer ownership
375     tuberIndexToOwner[_tokenId] = _to;
376 
377     // When creating new tubers _from is 0x0, but we can't account that address.
378     if (_from != address(0)) {
379       ownershipTokenCount[_from]--;
380       // clear any previously approved ownership exchange
381       delete tuberIndexToApproved[_tokenId];
382     }
383 
384     // Emit the transfer event.
385     Transfer(_from, _to, _tokenId);
386   }
387 }
388 library SafeMath {
389 
390   /**
391   * @dev Multiplies two numbers, throws on overflow.
392   */
393   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
394     if (a == 0) {
395       return 0;
396     }
397     uint256 c = a * b;
398     assert(c / a == b);
399     return c;
400   }
401 
402   /**
403   * @dev Integer division of two numbers, truncating the quotient.
404   */
405   function div(uint256 a, uint256 b) internal pure returns (uint256) {
406     // assert(b > 0); // Solidity automatically throws when dividing by 0
407     uint256 c = a / b;
408     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
409     return c;
410   }
411 
412   /**
413   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
414   */
415   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
416     assert(b <= a);
417     return a - b;
418   }
419 
420   /**
421   * @dev Adds two numbers, throws on overflow.
422   */
423   function add(uint256 a, uint256 b) internal pure returns (uint256) {
424     uint256 c = a + b;
425     assert(c >= a);
426     return c;
427   }
428 }