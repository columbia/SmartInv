1 pragma solidity ^0.4.18;
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
5 
6 contract ERC721 {
7   // Required methods
8   function totalSupply() public view returns (uint256 total);
9   function balanceOf(address _owner) public view returns (uint256 balance);
10   function ownerOf(uint256 _tokenId) public view returns (address addr);
11   function approve(address _to, uint256 _tokenId) public;
12   function takeOwnership(uint256 _tokenId) public;
13   function transfer(address _to, uint256 _tokenId) public;
14   function transferFrom(address _from, address _to, uint256 _tokenId) public;
15 
16   //Events
17   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
18   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
19 }
20 
21 contract CryptoColors is ERC721 {
22 
23   /*** EVENTS ***/
24 
25   /// @dev The Released event is fired whenever a new color is released.
26   event Released(uint256 tokenId, string name, address owner);
27 
28   /// @dev The ColorSold event is fired whenever a color is sold.
29   event ColorSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
30 
31   /// @dev Transfer event as defined in current draft of ERC721.
32   /// ownership is assigned, including initial color listings.
33   event Transfer(address from, address to, uint256 tokenId);
34 
35   /*** CONSTANTS ***/
36   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
37   string public constant NAME = "CryptoColors";
38   string public constant SYMBOL = "COLOR";
39 
40   uint256 private constant PROMO_CREATION_LIMIT = 1000000;
41   uint256 private startingPrice = 0.001 ether;
42   uint256 private firstStepLimit =  0.05 ether;
43   uint256 private secondStepLimit = 0.5 ether;
44 
45 
46   /*** STORAGE ***/
47   /// @dev A mapping from color IDs to the address that owns them. All colors have
48   ///  some valid owner address.
49   mapping (uint256 => address) public colorIndexToOwner;
50 
51   // @dev A mapping from owner address to count of tokens that address owns.
52   //  Used internally inside balanceOf() to resolve ownership count.
53   mapping (address => uint256) private ownershipTokenCount;
54 
55   /// @dev A mapping from colorIDs to an address that has been approved to call
56   ///  transferFrom(). Each color can only have one approved address for transfer
57   ///  at any time. A zero value means no approval is outstanding.
58   mapping (uint256 => address) public colorIndexToApproved;
59 
60   // @dev A mapping from colorIDs to the price of the token.
61   mapping (uint256 => uint256) private colorIndexToPrice;
62 
63   // The address of the CEO
64   address public ceoAddress;
65 
66   // Keeps track of the total promo colors released
67   uint256 public promoCreatedCount;
68 
69   /*** DATATYPES ***/
70   struct Color{
71     uint8 R;
72     uint8 G;
73     uint8 B;
74     string name;
75   }
76 
77   // Storage array of all colors. Indexed by colorId.
78   Color[] private colors;
79 
80 
81   /*** ACCESS MODIFIERS ***/
82   /// @dev Access modifier for CEO-only functionality
83   modifier onlyCEO() {
84     require(msg.sender == ceoAddress);
85     _;
86   }
87 
88   /*** CONSTRUCTOR ***/
89   function CryptoColors() public {
90     ceoAddress = msg.sender;
91   }
92 
93   /*** PUBLIC FUNCTIONS ***/
94 
95   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
96   /// @param _newCEO The address of the new CEO
97   function setCEO(address _newCEO) public onlyCEO {
98     require(_newCEO != address(0));
99 
100     ceoAddress = _newCEO;
101   }
102 
103   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
104   /// @param _to The address to be granted transfer approval. Pass address(0) to clear all approvals.
105   /// @param _tokenId The ID of the color that can be transferred if this call succeeds.
106   /// @dev Required for ERC-721 compliance.
107   function approve(address _to, uint256 _tokenId) public {
108     // Caller must own token.
109     require(_owns(msg.sender, _tokenId));
110 
111     colorIndexToApproved[_tokenId] = _to;
112     Approval(msg.sender, _to, _tokenId);
113   }
114 
115   /// For querying balance of a particular account
116   /// @param _owner The address for balance query
117   /// @dev Required for ERC-721 compliance.
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return ownershipTokenCount[_owner];
120   }
121 
122   /// @dev Creates a new color with the given name, with given _price and assignes it to an address.
123   function createPromoColor(uint256 _R, uint256 _G, uint256 _B, string _name, address _owner, uint256 _price) public onlyCEO {
124     require(promoCreatedCount < PROMO_CREATION_LIMIT);
125 
126     address colorOwner = _owner;
127     if (colorOwner == address(0)) {
128       colorOwner = ceoAddress;
129     }
130 
131     if (_price <= 0) {
132       _price = startingPrice;
133     }
134 
135     promoCreatedCount++;
136     _createColor(_R, _G, _B, _name, colorOwner, _price);
137   }
138 
139   /// @dev Creates a new color with the given name and assigns it to the contract.
140   function createContractColor(uint256 _R, uint256 _G, uint256 _B, string _name) public onlyCEO {
141     _createColor(_R, _G, _B, _name, address(this), startingPrice);
142   }
143 
144   /// @notice Returns all the relevant information about a specific color.
145   /// @param _tokenId The Id of the color of interest.
146   function getColor(uint256 _tokenId) public view returns (uint256 R, uint256 G, uint256 B, string colorName, uint256 sellingPrice, address owner) {
147     Color storage col = colors[_tokenId];
148 
149     R = col.R;
150     G = col.G;
151     B = col.B;
152     colorName = col.name;
153     sellingPrice = colorIndexToPrice[_tokenId];
154     owner = colorIndexToOwner[_tokenId];
155   }
156 
157   /// For querying owner of token
158   /// @param _tokenId The colorId for owner inquiry
159   /// @dev Required for ERC-721 compliance.
160   function ownerOf(uint256 _tokenId) public view returns (address owner) {
161     owner = colorIndexToOwner[_tokenId];
162     require(owner != address(0));
163   }
164 
165   function payout(address _to) public onlyCEO {
166     _payout(_to);
167   }
168 
169   // Allows someone to send ether and obtain the token
170   function purchase(uint256 _tokenId) public payable {
171     address oldOwner = colorIndexToOwner[_tokenId];
172     address newOwner = msg.sender;
173 
174     uint256 sellingPrice = colorIndexToPrice[_tokenId];
175 
176     // Making sure token owner is not sending to self
177     require(oldOwner != newOwner);
178 
179     // Safety check to prevent against an unexpected 0x0 default.
180     require(_addressNotNull(newOwner));
181 
182     // Making sure sent amount is greater than or equal to the sellingPrice
183     require(msg.value >= sellingPrice);
184 
185     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 93), 100));
186     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
187 
188     // Update prices
189     if (sellingPrice < firstStepLimit) {
190       // first stage
191       colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 93);
192     } else if (sellingPrice < secondStepLimit) {
193       // second stage
194       colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 93);
195     } else {
196       // third stage
197       colorIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 93);
198     }
199 
200     _transfer(oldOwner, newOwner, _tokenId);
201 
202     // Pay previous tokenOwner if owner is not contract
203     if (oldOwner != address(this)) {
204       oldOwner.transfer(payment);
205     }
206 
207     ColorSold(_tokenId, sellingPrice, colorIndexToPrice[_tokenId], oldOwner, newOwner, colors[_tokenId].name);
208 
209     msg.sender.transfer(purchaseExcess);
210   }
211 
212   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
213     return colorIndexToPrice[_tokenId];
214   }
215 
216 
217   /// @notice Allow pre-approved user to take ownership of a color
218   /// @param _tokenId The ID of the color that can be transferred if this call succeeds.
219   /// @dev Required for ERC-721 compliance.
220   function takeOwnership(uint256 _tokenId) public {
221     address newOwner = msg.sender;
222     address oldOwner = colorIndexToOwner[_tokenId];
223 
224     // Safety check to prevent against an unexpected 0x0 default.
225     require(_addressNotNull(newOwner));
226 
227     // Making sure transfer is approved
228     require(_approved(newOwner, _tokenId));
229 
230     _transfer(oldOwner, newOwner, _tokenId);
231   }
232 
233   /// @param _owner The owner whose color tokens we are interested in.
234   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
235   ///  expensive (it walks the entire colors array looking for colors belonging to owner),
236   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
237   ///  not contract-to-contract calls.
238   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
239     uint256 tokenCount = balanceOf(_owner);
240     if (tokenCount == 0) {
241         // Return an empty array
242       return new uint256[](0);
243     } else {
244       uint256[] memory result = new uint256[](tokenCount);
245       uint256 totalcolors = totalSupply();
246       uint256 resultIndex = 0;
247 
248       uint256 colorId;
249       for (colorId = 0; colorId <= totalcolors; colorId++) {
250         if (colorIndexToOwner[colorId] == _owner) {
251           result[resultIndex] = colorId;
252           resultIndex++;
253         }
254       }
255       return result;
256     }
257   }
258 
259   /// For querying totalSupply of token
260   /// @dev Required for ERC-721 compliance.
261   function totalSupply() public view returns (uint256 total) {
262     return colors.length;
263   }
264 
265   /// Owner initates the transfer of the token to another account
266   /// @param _to The address for the token to be transferred to.
267   /// @param _tokenId The ID of the color that can be transferred if this call succeeds.
268   /// @dev Required for ERC-721 compliance.
269   function transfer(address _to, uint256 _tokenId) public {
270     require(_owns(msg.sender, _tokenId));
271     require(_addressNotNull(_to));
272 
273     _transfer(msg.sender, _to, _tokenId);
274   }
275 
276   /// Third-party initiates transfer of token from address _from to address _to
277   /// @param _from The address for the token to be transferred from.
278   /// @param _to The address for the token to be transferred to.
279   /// @param _tokenId The ID of the color that can be transferred if this call succeeds.
280   /// @dev Required for ERC-721 compliance.
281   function transferFrom(address _from, address _to, uint256 _tokenId) public {
282     require(_owns(_from, _tokenId));
283     require(_approved(_to, _tokenId));
284     require(_addressNotNull(_to));
285 
286     _transfer(_from, _to, _tokenId);
287   }
288 
289   /*** PRIVATE FUNCTIONS ***/
290   /// Safety check on _to address to prevent against an unexpected 0x0 default.
291   function _addressNotNull(address _to) private pure returns (bool) {
292     return _to != address(0);
293   }
294 
295   /// For checking approval of transfer for address _to
296   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
297     return colorIndexToApproved[_tokenId] == _to;
298   }
299 
300   /// For creating color
301   function _createColor(uint256 _R, uint256 _G, uint256 _B, string _name, address _owner, uint256 _price) private {
302     require(_R == uint256(uint8(_R)));
303     require(_G == uint256(uint8(_G)));
304     require(_B == uint256(uint8(_B)));
305 
306     Color memory _color = Color({
307         R: uint8(_R),
308         G: uint8(_G),
309         B: uint8(_B),
310         name: _name
311     });
312 
313     uint256 newColorId = colors.push(_color) - 1;
314 
315     require(newColorId == uint256(uint32(newColorId)));
316 
317     Released(newColorId, _name, _owner);
318 
319     colorIndexToPrice[newColorId] = _price;
320 
321     // This will assign ownership, and also emit the Transfer event as
322     // per ERC721 draft
323     _transfer(address(0), _owner, newColorId);
324   }
325 
326   /// Check for color ownership
327   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
328     return claimant == colorIndexToOwner[_tokenId];
329   }
330 
331   /// For paying out balance on contract
332   function _payout(address _to) private {
333     if (_to == address(0)) {
334       ceoAddress.transfer(this.balance);
335     } else {
336       _to.transfer(this.balance);
337     }
338   }
339 
340   /// @dev Assigns ownership of a specific Color to an address.
341   function _transfer(address _from, address _to, uint256 _tokenId) private {
342     // Since the number of colors is capped to 2^32 we can't overflow this
343     ownershipTokenCount[_to]++;
344     //transfer ownership
345     colorIndexToOwner[_tokenId] = _to;
346 
347     // When creating new colors _from is 0x0, but we can't account that address.
348     if (_from != address(0)) {
349       ownershipTokenCount[_from]--;
350       // clear any previously approved ownership exchange
351       delete colorIndexToApproved[_tokenId];
352     }
353 
354     // Emit the transfer event.
355     Transfer(_from, _to, _tokenId);
356   }
357 }
358 
359 library SafeMath {
360 
361   /**
362   * @dev Multiplies two numbers, throws on overflow.
363   */
364   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
365     if (a == 0) {
366       return 0;
367     }
368     uint256 c = a * b;
369     assert(c / a == b);
370     return c;
371   }
372 
373   /**
374   * @dev Integer division of two numbers, truncating the quotient.
375   */
376   function div(uint256 a, uint256 b) internal pure returns (uint256) {
377     // assert(b > 0); // Solidity automatically throws when dividing by 0
378     uint256 c = a / b;
379     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
380     return c;
381   }
382 
383   /**
384   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
385   */
386   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
387     assert(b <= a);
388     return a - b;
389   }
390 }