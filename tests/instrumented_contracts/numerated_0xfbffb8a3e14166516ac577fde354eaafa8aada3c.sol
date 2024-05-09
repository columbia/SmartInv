1 pragma solidity ^0.4.20; // solhint-disable-line
2 
3 /// @title A standard interface for non-fungible tokens.
4 /// @author Dieter Shirley <dete@axiomzen.co>
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
18 }
19 
20 /// @title ViralLo.vin, Creator token smart contract
21 /// @author Sam Morris <hi@sam.viralo.vin>
22 contract ViralLovinCreatorToken is ERC721 {
23 
24   /*** EVENTS ***/
25 
26   /// @dev The Birth event is fired whenever a new Creator is created
27   event Birth(
28       uint256 tokenId, 
29       string name, 
30       address owner, 
31       uint256 collectiblesOrdered
32     );
33 
34   /// @dev The TokenSold event is fired whenever a token is sold.
35   event TokenSold(
36       uint256 tokenId, 
37       uint256 oldPrice, 
38       uint256 newPrice, 
39       address prevOwner, 
40       address winner, 
41       string name, 
42       uint256 collectiblesOrdered
43     );
44 
45   /// @dev Transfer event as defined in current draft of ERC721. 
46   ///  ownership is assigned, including births.
47   event Transfer(address from, address to, uint256 tokenId);
48 
49   /*** CONSTANTS ***/
50 
51   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
52   string public constant NAME = "ViralLovin Creator Token"; // solhint-disable-line
53   string public constant SYMBOL = "CREATOR"; // solhint-disable-line
54 
55   uint256 private startingPrice = 0.001 ether;
56 
57   /*** STORAGE ***/
58 
59   /// @dev A mapping from Creator IDs to the address that owns them. 
60   /// All Creators have some valid owner address.
61   mapping (uint256 => address) public creatorIndexToOwner;
62 
63   /// @dev A mapping from owner address to count of tokens that address owns.
64   //  Used internally inside balanceOf() to resolve ownership count.
65   mapping (address => uint256) private ownershipTokenCount;
66 
67   /// @dev A mapping from Creator IDs to an address that has been approved to call
68   ///  transferFrom(). Each Creator can only have one approved address for transfer
69   ///  at any time. A zero value means no approval is outstanding.
70   mapping (uint256 => address) public creatorIndexToApproved;
71 
72   // @dev A mapping from creator IDs to the price of the token.
73   mapping (uint256 => uint256) private creatorIndexToPrice;
74 
75   // The addresses that can execute actions within each roles.
76   address public ceoAddress;
77   address public cooAddress;
78 
79   uint256 public creatorsCreatedCount;
80 
81   /*** DATATYPES ***/
82   struct Creator {
83     string name;
84     uint256 collectiblesOrdered;
85   }
86 
87   Creator[] private creators;
88 
89   /*** ACCESS MODIFIERS ***/
90   
91   /// @dev Access modifier for CEO-only functionality
92   modifier onlyCEO() {
93     require(msg.sender == ceoAddress);
94     _;
95   }
96 
97   /// @dev Access modifier for COO-only functionality
98   modifier onlyCOO() {
99     require(msg.sender == cooAddress);
100     _;
101   }
102 
103   /// Access modifier for contract owner only functionality
104   modifier onlyCLevel() {
105     require(
106       msg.sender == ceoAddress ||
107       msg.sender == cooAddress
108     );
109     _;
110   }
111 
112   /*** CONSTRUCTOR ***/
113   
114   function ViralLovinCreatorToken() public {
115     ceoAddress = msg.sender;
116     cooAddress = msg.sender;
117   }
118 
119   /*** PUBLIC FUNCTIONS ***/
120   
121   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
122   /// @param _to The address to be granted transfer approval. Pass address(0) to clear all approvals.
123   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
124   /// @dev Required for ERC-721 compliance.
125   function approve(address _to, uint256 _tokenId) public {
126     // Caller must own token.
127     require(_owns(msg.sender, _tokenId));
128     creatorIndexToApproved[_tokenId] = _to;
129     Approval(msg.sender, _to, _tokenId);
130   }
131 
132   /// For querying balance of a particular account
133   /// @param _owner The address for balance query
134   /// @dev Required for ERC-721 compliance.
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return ownershipTokenCount[_owner];
137   }
138 
139   /// @dev Creates a new Creator with the given name, price, and the total number of collectibles ordered then assigns to an address.
140   function createCreator(
141       address _owner, 
142       string _name, 
143       uint256 _price, 
144       uint256 _collectiblesOrdered
145     ) public onlyCOO {
146     address creatorOwner = _owner;
147     if (creatorOwner == address(0)) {
148       creatorOwner = cooAddress;
149     }
150 
151     if (_price <= 0) {
152       _price = startingPrice;
153     }
154 
155     creatorsCreatedCount++;
156     _createCreator(_name, creatorOwner, _price, _collectiblesOrdered);
157     }
158 
159   /// @notice Returns all the information about Creator token.
160   /// @param _tokenId The tokenId of the Creator token.
161   function getCreator(
162       uint256 _tokenId
163     ) public view returns (
164         string creatorName, 
165         uint256 sellingPrice, 
166         address owner, 
167         uint256 collectiblesOrdered
168     ) {
169     Creator storage creator = creators[_tokenId];
170     creatorName = creator.name;
171     collectiblesOrdered = creator.collectiblesOrdered;
172     sellingPrice = creatorIndexToPrice[_tokenId];
173     owner = creatorIndexToOwner[_tokenId];
174   }
175 
176   function implementsERC721() public pure returns (bool) {
177     return true;
178   }
179 
180   /// @dev For ERC-721 compliance.
181   function name() public pure returns (string) {
182     return NAME;
183   }
184 
185   /// For querying owner of a token
186   /// @param _tokenId The tokenID
187   /// @dev Required for ERC-721 compliance.
188   function ownerOf(uint256 _tokenId) public view returns (address owner)
189   {
190     owner = creatorIndexToOwner[_tokenId];
191     require(owner != address(0));
192   }
193 
194   /// For contract payout
195   function payout(address _to) public onlyCLevel {
196     require(_addressNotNull(_to));
197     _payout(_to);
198   }
199 
200   /// Allows someone to obtain the token
201   function purchase(uint256 _tokenId) public payable {
202     address oldOwner = creatorIndexToOwner[_tokenId];
203     address newOwner = msg.sender;
204     uint256 sellingPrice = creatorIndexToPrice[_tokenId];
205 
206     // Safety check to prevent against an unexpected 0x0 default.
207     require(_addressNotNull(newOwner));
208 
209     // Making sure sent amount is greater than or equal to the sellingPrice
210     require(msg.value >= sellingPrice);
211 
212     // Transfer contract to new owner
213     _transfer(oldOwner, newOwner, _tokenId);
214 
215     // Transfer payment to VL
216     ceoAddress.transfer(sellingPrice);
217 
218     // Emits TokenSold event
219     TokenSold(
220         _tokenId, 
221         sellingPrice, 
222         creatorIndexToPrice[_tokenId], 
223         oldOwner, 
224         newOwner, 
225         creators[_tokenId].name, 
226         creators[_tokenId].collectiblesOrdered
227     );
228   }
229 
230   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
231     return creatorIndexToPrice[_tokenId];
232   }
233 
234   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
235   /// @param _newCEO The address of the new CEO
236   function setCEO(address _newCEO) public onlyCEO {
237     require(_newCEO != address(0));
238     ceoAddress = _newCEO;
239   }
240 
241   /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
242   /// @param _newCOO The address of the new COO
243   function setCOO(address _newCOO) public onlyCEO {
244     require(_newCOO != address(0));
245     cooAddress = _newCOO;
246   }
247 
248   /// @dev For ERC-721 compliance.
249   function symbol() public pure returns (string) {
250     return SYMBOL;
251   }
252 
253   /// @notice Allow pre-approved user to take ownership of a token
254   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
255   /// @dev Required for ERC-721 compliance.
256   function takeOwnership(uint256 _tokenId) public {
257     address newOwner = msg.sender;
258     address oldOwner = creatorIndexToOwner[_tokenId];
259 
260     // Safety check to prevent against an unexpected 0x0 default.
261     require(_addressNotNull(newOwner));
262 
263     // Making sure transfer is approved
264     require(_approved(newOwner, _tokenId));
265 
266     _transfer(oldOwner, newOwner, _tokenId);
267   }
268 
269   /// @param _owner Creator tokens belonging to the owner.
270   /// @dev Expensive; not to be called by smart contract. Walks the collectibes array looking for Creator tokens belonging to owner.
271   function tokensOfOwner(
272       address _owner
273       ) public view returns(uint256[] ownerTokens) {
274     uint256 tokenCount = balanceOf(_owner);
275     if (tokenCount == 0) {
276         // Return an empty array
277       return new uint256[](0);
278     } else {
279       uint256[] memory result = new uint256[](tokenCount);
280       uint256 totalCreators = totalSupply();
281       uint256 resultIndex = 0;
282       uint256 creatorId;
283       for (creatorId = 0; creatorId <= totalCreators; creatorId++) {
284         if (creatorIndexToOwner[creatorId] == _owner) {
285           result[resultIndex] = creatorId;
286           resultIndex++;
287         }
288       }
289       return result;
290     }
291   }
292 
293   /// For querying totalSupply of token
294   /// @dev Required for ERC-721 compliance.
295   function totalSupply() public view returns (uint256 total) {
296     return creators.length;
297   }
298 
299   /// Owner initates the transfer of the token to another account
300   /// @param _to The address for the token to be transferred to.
301   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
302   /// @dev Required for ERC-721 compliance.
303   function transfer(address _to, uint256 _tokenId) public {
304     require(_owns(msg.sender, _tokenId));
305     require(_addressNotNull(_to));
306     _transfer(msg.sender, _to, _tokenId);
307   }
308 
309   /// Initiates transfer of token from address _from to address _to
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
323   
324   /// Safety check on _to address to prevent against an unexpected 0x0 default.
325   function _addressNotNull(address _to) private pure returns (bool) {
326     return _to != address(0);
327   }
328 
329   /// For checking approval of transfer for address _to
330   function _approved(
331       address _to, 
332       uint256 _tokenId
333       ) private view returns (bool) {
334     return creatorIndexToApproved[_tokenId] == _to;
335   }
336 
337   /// For creating a Creator
338   function _createCreator(
339       string _name, 
340       address _owner, 
341       uint256 _price, 
342       uint256 _collectiblesOrdered
343       ) private {
344     Creator memory _creator = Creator({
345       name: _name,
346       collectiblesOrdered: _collectiblesOrdered
347     });
348     uint256 newCreatorId = creators.push(_creator) - 1;
349 
350     require(newCreatorId == uint256(uint32(newCreatorId)));
351 
352     Birth(newCreatorId, _name, _owner, _collectiblesOrdered);
353 
354     creatorIndexToPrice[newCreatorId] = _price;
355 
356     // This will assign ownership, and also emit the Transfer event as per ERC721 draft
357     _transfer(address(0), _owner, newCreatorId);
358   }
359 
360   /// Check for token ownership
361   function _owns(
362       address claimant, 
363       uint256 _tokenId
364       ) private view returns (bool) {
365     return claimant == creatorIndexToOwner[_tokenId];
366   }
367 
368   /// For paying out the full balance of contract
369   function _payout(address _to) private {
370     if (_to == address(0)) {
371       ceoAddress.transfer(this.balance);
372     } else {
373       _to.transfer(this.balance);
374     }
375   }
376 
377   /// @dev Assigns ownership of Creator token to an address.
378   function _transfer(address _from, address _to, uint256 _tokenId) private {
379     // increment owner token count
380     ownershipTokenCount[_to]++;
381     // transfer ownership
382     creatorIndexToOwner[_tokenId] = _to;
383 
384     // When creating new creators _from is 0x0, we can't account that address.
385     if (_from != address(0)) {
386       ownershipTokenCount[_from]--;
387       // clear any previously approved ownership
388       delete creatorIndexToApproved[_tokenId];
389     }
390 
391     // Emit the transfer event.
392     Transfer(_from, _to, _tokenId);
393   }
394   
395 }