1 pragma solidity ^0.4.18;
2 
3 /// Colors :3
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
28 /// Modified from the CryptoCelebrities contract
29 /// And again modified from the EmojiBlockhain contract
30 contract EtherColor is ERC721 {
31 
32   /*** EVENTS ***/
33 
34   /// @dev The Birth event is fired whenever a new color comes into existence.
35   event Birth(uint256 tokenId, string name, address owner);
36 
37   /// @dev The TokenSold event is fired whenever a token is sold.
38   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
39 
40   /// @dev Transfer event as defined in current draft of ERC721.
41   ///  ownership is assigned, including births.
42   event Transfer(address from, address to, uint256 tokenId);
43 
44   /*** CONSTANTS ***/
45 
46   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
47   string public constant NAME = "EtherColors"; // solhint-disable-line
48   string public constant SYMBOL = "EtherColor"; // solhint-disable-line
49 
50   uint256 private startingPrice = 0.001 ether;
51   uint256 private firstStepLimit =  0.05 ether;
52   uint256 private secondStepLimit = 0.5 ether;
53 
54   /*** STORAGE ***/
55 
56   /// @dev A mapping from color IDs to the address that owns them. All colors have
57   ///  some valid owner address.
58   mapping (uint256 => address) public colorIndexToOwner;
59 
60   // @dev A mapping from owner address to count of tokens that address owns.
61   //  Used internally inside balanceOf() to resolve ownership count.
62   mapping (address => uint256) private ownershipTokenCount;
63 
64   /// @dev A mapping from ColorIDs to an address that has been approved to call
65   ///  transferFrom(). Each Color can only have one approved address for transfer
66   ///  at any time. A zero value means no approval is outstanding.
67   mapping (uint256 => address) public colorIndexToApproved;
68 
69   // @dev A mapping from ColorIDs to the price of the token.
70   mapping (uint256 => uint256) private colorIndexToPrice;
71 
72   /// @dev A mapping from ColorIDs to the previpus price of the token. Used
73   /// to calculate price delta for payouts
74   mapping (uint256 => uint256) private colorIndexToPreviousPrice;
75 
76   // @dev A mapping from colorId to the 7 last owners.
77   mapping (uint256 => address[5]) private colorIndexToPreviousOwners;
78 
79 
80   // The addresses of the accounts (or contracts) that can execute actions within each roles.
81   address public ceoAddress;
82   address public cooAddress;
83 
84   /*** DATATYPES ***/
85   struct Color {
86     string name;
87   }
88 
89   Color[] private colors;
90 
91   /*** ACCESS MODIFIERS ***/
92   /// @dev Access modifier for CEO-only functionality
93   modifier onlyCEO() {
94     require(msg.sender == ceoAddress);
95     _;
96   }
97 
98   /// @dev Access modifier for COO-only functionality
99   modifier onlyCOO() {
100     require(msg.sender == cooAddress);
101     _;
102   }
103 
104   /// Access modifier for contract owner only functionality
105   modifier onlyCLevel() {
106     require(
107       msg.sender == ceoAddress ||
108       msg.sender == cooAddress
109     );
110     _;
111   }
112 
113   /*** CONSTRUCTOR ***/
114   function EtherColor() public {
115     ceoAddress = msg.sender;
116     cooAddress = msg.sender;
117   }
118 
119   /*** PUBLIC FUNCTIONS ***/
120   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
121   /// @param _to The address to be granted transfer approval. Pass address(0) to
122   ///  clear all approvals.
123   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
124   /// @dev Required for ERC-721 compliance.
125   function approve(
126     address _to,
127     uint256 _tokenId
128   ) public {
129     // Caller must own token.
130     require(_owns(msg.sender, _tokenId));
131 
132     colorIndexToApproved[_tokenId] = _to;
133 
134     Approval(msg.sender, _to, _tokenId);
135   }
136 
137   /// For querying balance of a particular account
138   /// @param _owner The address for balance query
139   /// @dev Required for ERC-721 compliance.
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return ownershipTokenCount[_owner];
142   }
143 
144   /// @dev Creates a new Color with the given name.
145   function createContractColor(string _name) public onlyCOO {
146     _createColor(_name, address(this), startingPrice);
147   }
148 
149   /// @notice Returns all the relevant information about a specific color.
150   /// @param _tokenId The tokenId of the color of interest.
151   function getColor(uint256 _tokenId) public view returns (
152     string colorName,
153     uint256 sellingPrice,
154     address owner,
155     uint256 previousPrice,
156     address[5] previousOwners
157   ) {
158     Color storage color = colors[_tokenId];
159     colorName = color.name;
160     sellingPrice = colorIndexToPrice[_tokenId];
161     owner = colorIndexToOwner[_tokenId];
162     previousPrice = colorIndexToPreviousPrice[_tokenId];
163     previousOwners = colorIndexToPreviousOwners[_tokenId];
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
183     owner = colorIndexToOwner[_tokenId];
184     require(owner != address(0));
185   }
186 
187   function payout(address _to) public onlyCLevel {
188     _payout(_to);
189   }
190 
191   // Allows someone to send ether and obtain the token
192   function purchase(uint256 _tokenId) public payable {
193     address oldOwner = colorIndexToOwner[_tokenId];
194     address newOwner = msg.sender;
195 
196     address[5] storage previousOwners = colorIndexToPreviousOwners[_tokenId];
197 
198     uint256 sellingPrice = colorIndexToPrice[_tokenId];
199     uint256 previousPrice = colorIndexToPreviousPrice[_tokenId];
200     // Making sure token owner is not sending to self
201     require(oldOwner != newOwner);
202 
203     // Safety check to prevent against an unexpected 0x0 default.
204     require(_addressNotNull(newOwner));
205 
206     // Making sure sent amount is greater than or equal to the sellingPrice
207     require(msg.value >= sellingPrice);
208 
209     uint256 priceDelta = SafeMath.sub(sellingPrice, previousPrice);
210     uint256 ownerPayout = SafeMath.add(previousPrice, SafeMath.mul(SafeMath.div(priceDelta, 100), 49));
211     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
212 
213     // Update prices
214     if (sellingPrice < firstStepLimit) {
215       // first stage
216       colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
217     } else if (sellingPrice < secondStepLimit) {
218       // second stage
219       colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
220     } else {
221       // third stage
222       colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 125), 100);
223     }
224     colorIndexToPreviousPrice[_tokenId] = sellingPrice;
225 
226     uint256 fee_for_dev;
227     // Pay previous tokenOwner if owner is not contract
228     // and if previous price is not 0
229     if (oldOwner != address(this)) {
230       // old owner gets entire initial payment back
231       oldOwner.transfer(ownerPayout);
232       fee_for_dev = SafeMath.mul(SafeMath.div(priceDelta, 100), 1);
233     } else {
234       fee_for_dev = SafeMath.add(ownerPayout, SafeMath.mul(SafeMath.div(priceDelta, 100), 1));
235     }
236 
237     // Next distribute payout Total among previous Owners
238     for (uint i = 0; i <= 4; i++) {
239         if (previousOwners[i] != address(this)) {
240             previousOwners[i].transfer(uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100)));
241         } else {
242             fee_for_dev = SafeMath.add(fee_for_dev, uint256(SafeMath.div(SafeMath.mul(priceDelta, 10), 100)));
243         }
244     }
245     ceoAddress.transfer(fee_for_dev);
246 
247     _transfer(oldOwner, newOwner, _tokenId);
248 
249     //TokenSold(_tokenId, sellingPrice, colorIndexToPrice[_tokenId], oldOwner, newOwner, colors[_tokenId].name);
250 
251     msg.sender.transfer(purchaseExcess);
252   }
253 
254   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
255     return colorIndexToPrice[_tokenId];
256   }
257 
258   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
259   /// @param _newCEO The address of the new CEO
260   function setCEO(address _newCEO) public onlyCEO {
261     require(_newCEO != address(0));
262 
263     ceoAddress = _newCEO;
264   }
265 
266   /// @dev Assigns a new address to act as the COO. Only available to the current COO.
267   /// @param _newCOO The address of the new COO
268   function setCOO(address _newCOO) public onlyCEO {
269     require(_newCOO != address(0));
270     cooAddress = _newCOO;
271   }
272 
273   /// @dev Required for ERC-721 compliance.
274   function symbol() public pure returns (string) {
275     return SYMBOL;
276   }
277 
278   /// @notice Allow pre-approved user to take ownership of a token
279   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
280   /// @dev Required for ERC-721 compliance.
281   function takeOwnership(uint256 _tokenId) public {
282     address newOwner = msg.sender;
283     address oldOwner = colorIndexToOwner[_tokenId];
284 
285     // Safety check to prevent against an unexpected 0x0 default.
286     require(_addressNotNull(newOwner));
287 
288     // Making sure transfer is approved
289     require(_approved(newOwner, _tokenId));
290 
291     _transfer(oldOwner, newOwner, _tokenId);
292   }
293 
294   /// @param _owner The owner whose color tokens we are interested in.
295   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
296   ///  expensive (it walks the entire Colors array looking for colors belonging to owner),
297   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
298   ///  not contract-to-contract calls.
299   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
300     uint256 tokenCount = balanceOf(_owner);
301     if (tokenCount == 0) {
302         // Return an empty array
303       return new uint256[](0);
304     } else {
305       uint256[] memory result = new uint256[](tokenCount);
306       uint256 totalColors = totalSupply();
307       uint256 resultIndex = 0;
308       uint256 colorId;
309       for (colorId = 0; colorId <= totalColors; colorId++) {
310         if (colorIndexToOwner[colorId] == _owner) {
311           result[resultIndex] = colorId;
312           resultIndex++;
313         }
314       }
315       return result;
316     }
317   }
318 
319   /// For querying totalSupply of token
320   /// @dev Required for ERC-721 compliance.
321   function totalSupply() public view returns (uint256 total) {
322     return colors.length;
323   }
324 
325   /// Owner initates the transfer of the token to another account
326   /// @param _to The address for the token to be transferred to.
327   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
328   /// @dev Required for ERC-721 compliance.
329   function transfer(
330     address _to,
331     uint256 _tokenId
332   ) public {
333     require(_owns(msg.sender, _tokenId));
334     require(_addressNotNull(_to));
335     _transfer(msg.sender, _to, _tokenId);
336   }
337 
338   /// Third-party initiates transfer of token from address _from to address _to
339   /// @param _from The address for the token to be transferred from.
340   /// @param _to The address for the token to be transferred to.
341   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
342   /// @dev Required for ERC-721 compliance.
343   function transferFrom(
344     address _from,
345     address _to,
346     uint256 _tokenId
347   ) public {
348     require(_owns(_from, _tokenId));
349     require(_approved(_to, _tokenId));
350     require(_addressNotNull(_to));
351     _transfer(_from, _to, _tokenId);
352   }
353 
354   /*** PRIVATE FUNCTIONS ***/
355   /// Safety check on _to address to prevent against an unexpected 0x0 default.
356   function _addressNotNull(address _to) private pure returns (bool) {
357     return _to != address(0);
358   }
359 
360   /// For checking approval of transfer for address _to
361   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
362     return colorIndexToApproved[_tokenId] == _to;
363   }
364 
365   /// For creating Color
366   function _createColor(string _name, address _owner, uint256 _price) private {
367     Color memory _color = Color({
368       name: _name
369     });
370     uint256 newColorId = colors.push(_color) - 1;
371 
372     // It's probably never going to happen, 4 billion tokens are A LOT, but
373     // let's just be 100% sure we never let this happen.
374     require(newColorId == uint256(uint32(newColorId)));
375 
376     Birth(newColorId, _name, _owner);
377 
378     colorIndexToPrice[newColorId] = _price;
379     colorIndexToPreviousPrice[newColorId] = 0;
380     colorIndexToPreviousOwners[newColorId] =
381         [address(this), address(this), address(this), address(this), address(this)];
382 
383     // This will assign ownership, and also emit the Transfer event as
384     // per ERC721 draft
385     _transfer(address(0), _owner, newColorId);
386   }
387 
388   /// Check for token ownership
389   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
390     return claimant == colorIndexToOwner[_tokenId];
391   }
392 
393   /// For paying out balance on contract
394   function _payout(address _to) private {
395     if (_to == address(0)) {
396       ceoAddress.transfer(this.balance);
397     } else {
398       _to.transfer(this.balance);
399     }
400   }
401 
402   /// @dev Assigns ownership of a specific Color to an address.
403   function _transfer(address _from, address _to, uint256 _tokenId) private {
404     // Since the number of colors is capped to 2^32 we can't overflow this
405     ownershipTokenCount[_to]++;
406     //transfer ownership
407     colorIndexToOwner[_tokenId] = _to;
408     // When creating new colors _from is 0x0, but we can't account that address.
409     if (_from != address(0)) {
410       ownershipTokenCount[_from]--;
411       // clear any previously approved ownership exchange
412       delete colorIndexToApproved[_tokenId];
413     }
414     // Update the colorIndexToPreviousOwners
415     colorIndexToPreviousOwners[_tokenId][4]=colorIndexToPreviousOwners[_tokenId][3];
416     colorIndexToPreviousOwners[_tokenId][3]=colorIndexToPreviousOwners[_tokenId][2];
417     colorIndexToPreviousOwners[_tokenId][2]=colorIndexToPreviousOwners[_tokenId][1];
418     colorIndexToPreviousOwners[_tokenId][1]=colorIndexToPreviousOwners[_tokenId][0];
419     // the _from address for creation is 0, so instead set it to the contract address
420     if (_from != address(0)) {
421         colorIndexToPreviousOwners[_tokenId][0]=_from;
422     } else {
423         colorIndexToPreviousOwners[_tokenId][0]=address(this);
424     }
425     // Emit the transfer event.
426     Transfer(_from, _to, _tokenId);
427   }
428 }
429 library SafeMath {
430 
431   /**
432   * @dev Multiplies two numbers, throws on overflow.
433   */
434   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
435     if (a == 0) {
436       return 0;
437     }
438     uint256 c = a * b;
439     assert(c / a == b);
440     return c;
441   }
442 
443   /**
444   * @dev Integer division of two numbers, truncating the quotient.
445   */
446   function div(uint256 a, uint256 b) internal pure returns (uint256) {
447     // assert(b > 0); // Solidity automatically throws when dividing by 0
448     uint256 c = a / b;
449     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
450     return c;
451   }
452 
453   /**
454   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
455   */
456   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
457     assert(b <= a);
458     return a - b;
459   }
460 
461   /**
462   * @dev Adds two numbers, throws on overflow.
463   */
464   function add(uint256 a, uint256 b) internal pure returns (uint256) {
465     uint256 c = a + b;
466     assert(c >= a);
467     return c;
468   }
469 }