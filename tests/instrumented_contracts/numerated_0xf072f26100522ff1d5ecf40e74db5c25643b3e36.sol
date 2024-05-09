1 pragma solidity ^0.4.18;
2 
3 contract ERC721 {
4   // Required methods
5   function approve(address _to, uint256 _tokenId) public;
6   function balanceOf(address _owner) public view returns (uint256 balance);
7   function implementsERC721() public pure returns (bool);
8   function ownerOf(uint256 _tokenId) public view returns (address addr);
9   function takeOwnership(uint256 _tokenId) public;
10   function totalSupply() public view returns (uint256 total);
11   function transferFrom(address _from, address _to, uint256 _tokenId) public;
12   function transfer(address _to, uint256 _tokenId) public;
13 
14   event Transfer(address indexed from, address indexed to, uint256 tokenId);
15   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
16 
17 }
18 
19 
20 contract PlaceToken is ERC721 {
21 
22   /*** EVENTS ***/
23 
24   /// @dev The Birth event is fired whenever a new place comes into existence.
25   event Birth(uint256 tokenId, string name, address owner);
26 
27   /// @dev The TokenSold event is fired whenever a token is sold.
28   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
29 
30   /// @dev Transfer event as defined in current draft of ERC721.
31   ///  ownership is assigned, including births.
32   event Transfer(address from, address to, uint256 tokenId);
33 
34   /*** CONSTANTS ***/
35 
36   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
37   string public constant NAME = "CryptoPlaces";
38   string public constant SYMBOL = "PlaceToken";
39 
40   uint256 private startingPrice = 0.01 ether;
41   uint256 private firstStepLimit =  0.8 ether;
42   uint256 private secondStepLimit = 12 ether;
43 
44   /*** STORAGE ***/
45 
46   /// @dev A mapping from place IDs to the address that owns them. All places have
47   ///  some valid owner address.
48   mapping (uint256 => address) public placeIndexToOwner;
49 
50   // @dev A mapping from owner address to count of tokens that address owns.
51   //  Used internally inside balanceOf() to resolve ownership count.
52   mapping (address => uint256) private ownershipTokenCount;
53 
54   /// @dev A mapping from PlaceIDs to an address that has been approved to call
55   ///  transferFrom(). Each Place can only have one approved address for transfer
56   ///  at any time. A zero value means no approval is outstanding.
57   mapping (uint256 => address) public placeIndexToApproved;
58 
59   // @dev A mapping from PlaceIDs to the price of the token.
60   mapping (uint256 => uint256) private placeIndexToPrice;
61 
62   // The addresses of the accounts (or contracts) that can execute actions within each roles.
63   address public ceoAddress;
64 
65   /*** DATATYPES ***/
66   struct Place {
67     string name;
68     string country;
69     string owner_name;
70   }
71 
72   Place[] private places;
73 
74   modifier onlyCEO() {
75     require(msg.sender == ceoAddress);
76     _;
77   }
78 
79   function PlaceToken() public {
80     ceoAddress = msg.sender;
81   }
82 
83   /*** PUBLIC FUNCTIONS ***/
84   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
85   /// @param _to The address to be granted transfer approval. Pass address(0) to
86   ///  clear all approvals.
87   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
88   /// @dev Required for ERC-721 compliance.
89   function approve(
90     address _to,
91     uint256 _tokenId
92   ) public {
93     // Caller must own token.
94     require(_owns(msg.sender, _tokenId));
95 
96     placeIndexToApproved[_tokenId] = _to;
97 
98     Approval(msg.sender, _to, _tokenId);
99   }
100 
101   /// For querying balance of a particular account
102   /// @param _owner The address for balance query
103   /// @dev Required for ERC-721 compliance.
104   function balanceOf(address _owner) public view returns (uint256 balance) {
105     return ownershipTokenCount[_owner];
106   }
107 
108   function createContractPlace(string _name, string _country) public onlyCEO {
109     _createPlace(_name, _country, address(this), startingPrice);
110   }
111 
112   /// @notice Returns all the relevant information about a specific place.
113   /// @param _tokenId The tokenId of the place of interest.
114   function getPlace(uint256 _tokenId) public view returns (
115     string placeName,
116     string placeCountry,
117     string placeOwnerName,
118     uint256 sellingPrice,
119     address owner
120   ) {
121     Place storage place = places[_tokenId];
122     placeName = place.name;
123     placeCountry = place.country;
124     placeOwnerName = place.owner_name;
125     sellingPrice = placeIndexToPrice[_tokenId];
126     owner = placeIndexToOwner[_tokenId];
127   }
128 
129   function setStartingPrice(uint256 _newStartingPrice) public onlyCEO {
130     startingPrice = SafeMath.mul(_newStartingPrice, 1000000000000000000);
131   }
132 
133   function getStartingPrice() public view returns (uint256) {
134     return startingPrice;
135   }
136 
137   function implementsERC721() public pure returns (bool) {
138     return true;
139   }
140 
141   /// @dev Required for ERC-721 compliance.
142   function name() public pure returns (string) {
143     return NAME;
144   }
145 
146   /// For querying owner of token
147   /// @param _tokenId The tokenID for owner inquiry
148   /// @dev Required for ERC-721 compliance.
149   function ownerOf(uint256 _tokenId)
150     public
151     view
152     returns (address owner)
153   {
154     owner = placeIndexToOwner[_tokenId];
155     require(owner != address(0));
156   }
157 
158   function payout(address _to) public onlyCEO {
159     _payout(_to);
160   }
161 
162   // Allows someone to send ether and obtain the token
163   function purchase(uint256 _tokenId) public payable {
164     address oldOwner = placeIndexToOwner[_tokenId];
165     address newOwner = msg.sender;
166 
167     uint256 sellingPrice = placeIndexToPrice[_tokenId];
168 
169     // Making sure token owner is not sending to self
170     require(oldOwner != newOwner);
171 
172     // Safety check to prevent against an unexpected 0x0 default.
173     require(_addressNotNull(newOwner));
174 
175     // Making sure sent amount is greater than or equal to the sellingPrice
176     require(msg.value >= sellingPrice);
177 
178     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 90), 100));
179     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
180 
181     // Update prices
182     if (sellingPrice < firstStepLimit) {
183       // first stage
184       placeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 90);
185     } else if (sellingPrice < secondStepLimit) {
186       // second stage
187       placeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 130), 90);
188     } else {
189       // third stage
190       placeIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 90);
191     }
192 
193     _transfer(oldOwner, newOwner, _tokenId);
194 
195     // Pay previous tokenOwner if owner is not contract
196     if (oldOwner != address(this)) {
197       oldOwner.transfer(payment);
198     }
199 
200     TokenSold(_tokenId, sellingPrice, placeIndexToPrice[_tokenId], oldOwner, newOwner, places[_tokenId].name);
201 
202     msg.sender.transfer(purchaseExcess);
203   }
204 
205   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
206     return placeIndexToPrice[_tokenId];
207   }
208 
209   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
210   /// @param _newCEO The address of the new CEO
211   function setCEO(address _newCEO) public onlyCEO {
212     require(_newCEO != address(0));
213 
214     ceoAddress = _newCEO;
215   }
216 
217   /// @dev Required for ERC-721 compliance.
218   function symbol() public pure returns (string) {
219     return SYMBOL;
220   }
221 
222   /// @notice Allow pre-approved user to take ownership of a token
223   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
224   /// @dev Required for ERC-721 compliance.
225   function takeOwnership(uint256 _tokenId) public {
226     address newOwner = msg.sender;
227     address oldOwner = placeIndexToOwner[_tokenId];
228 
229     // Safety check to prevent against an unexpected 0x0 default.
230     require(_addressNotNull(newOwner));
231 
232     // Making sure transfer is approved
233     require(_approved(newOwner, _tokenId));
234 
235     _transfer(oldOwner, newOwner, _tokenId);
236   }
237 
238   /// For querying totalSupply of token
239   /// @dev Required for ERC-721 compliance.
240   function totalSupply() public view returns (uint256 total) {
241     return places.length;
242   }
243 
244   /// Owner initates the transfer of the token to another account
245   /// @param _to The address for the token to be transferred to.
246   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
247   /// @dev Required for ERC-721 compliance.
248   function transfer(
249     address _to,
250     uint256 _tokenId
251   ) public {
252     require(_owns(msg.sender, _tokenId));
253     require(_addressNotNull(_to));
254 
255     _transfer(msg.sender, _to, _tokenId);
256   }
257 
258   function setOwnerName(uint256 _tokenId, string _newName) public {
259     require(_owns(msg.sender, _tokenId));
260 
261     Place storage place = places[_tokenId];
262     place.owner_name = _newName;
263   }
264 
265   /// Third-party initiates transfer of token from address _from to address _to
266   /// @param _from The address for the token to be transferred from.
267   /// @param _to The address for the token to be transferred to.
268   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
269   /// @dev Required for ERC-721 compliance.
270   function transferFrom(
271     address _from,
272     address _to,
273     uint256 _tokenId
274   ) public {
275     require(_owns(_from, _tokenId));
276     require(_approved(_to, _tokenId));
277     require(_addressNotNull(_to));
278 
279     _transfer(_from, _to, _tokenId);
280   }
281 
282   /*** PRIVATE FUNCTIONS ***/
283   /// Safety check on _to address to prevent against an unexpected 0x0 default.
284   function _addressNotNull(address _to) private pure returns (bool) {
285     return _to != address(0);
286   }
287 
288   /// For checking approval of transfer for address _to
289   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
290     return placeIndexToApproved[_tokenId] == _to;
291   }
292 
293   /// For creating Place
294   function _createPlace(string _name, string _country, address _owner, uint256 _price) private {
295     Place memory _place = Place({
296       name: _name,
297       country: _country,
298       owner_name: "None"
299     });
300     uint256 newPlaceId = places.push(_place) - 1;
301 
302     // It's probably never going to happen, 4 billion tokens are A LOT, but
303     // let's just be 100% sure we never let this happen.
304     require(newPlaceId == uint256(uint32(newPlaceId)));
305 
306     Birth(newPlaceId, _name, _owner);
307 
308     placeIndexToPrice[newPlaceId] = _price;
309 
310     // This will assign ownership, and also emit the Transfer event as
311     // per ERC721 draft
312     _transfer(address(0), _owner, newPlaceId);
313   }
314 
315   /// Check for token ownership
316   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
317     return claimant == placeIndexToOwner[_tokenId];
318   }
319 
320   /// For paying out balance on contract
321   function _payout(address _to) private {
322     if (_to == address(0)) {
323       ceoAddress.transfer(this.balance);
324     } else {
325       _to.transfer(this.balance);
326     }
327   }
328 
329   /// @dev Assigns ownership of a specific Place to an address.
330   function _transfer(address _from, address _to, uint256 _tokenId) private {
331     // Since the number of places is capped to 2^32 we can't overflow this
332     ownershipTokenCount[_to]++;
333     //transfer ownership
334     placeIndexToOwner[_tokenId] = _to;
335 
336     // When creating new places _from is 0x0, but we can't account that address.
337     if (_from != address(0)) {
338       ownershipTokenCount[_from]--;
339       // clear any previously approved ownership exchange
340       delete placeIndexToApproved[_tokenId];
341     }
342 
343     // Emit the transfer event.
344     Transfer(_from, _to, _tokenId);
345   }
346 }
347 library SafeMath {
348 
349   /**
350   * @dev Multiplies two numbers, throws on overflow.
351   */
352   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
353     if (a == 0) {
354       return 0;
355     }
356     uint256 c = a * b;
357     assert(c / a == b);
358     return c;
359   }
360 
361   /**
362   * @dev Integer division of two numbers, truncating the quotient.
363   */
364   function div(uint256 a, uint256 b) internal pure returns (uint256) {
365     // assert(b > 0); // Solidity automatically throws when dividing by 0
366     uint256 c = a / b;
367     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
368     return c;
369   }
370 
371   /**
372   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
373   */
374   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375     assert(b <= a);
376     return a - b;
377   }
378 
379   /**
380   * @dev Adds two numbers, throws on overflow.
381   */
382   function add(uint256 a, uint256 b) internal pure returns (uint256) {
383     uint256 c = a + b;
384     assert(c >= a);
385     return c;
386   }
387 }