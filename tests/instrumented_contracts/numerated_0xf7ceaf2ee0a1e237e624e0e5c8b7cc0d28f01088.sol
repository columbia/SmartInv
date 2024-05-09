1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 /**
38  * @title Math
39  * @dev Assorted math operations
40  */
41 
42 library Math {
43   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
44     return a >= b ? a : b;
45   }
46 
47   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
48     return a < b ? a : b;
49   }
50 
51   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
56     return a < b ? a : b;
57   }
58 }
59 
60 
61 
62 
63 
64 contract MultiOwners {
65 
66     event AccessGrant(address indexed owner);
67     event AccessRevoke(address indexed owner);
68     
69     mapping(address => bool) owners;
70 
71     function MultiOwners() public {
72         owners[msg.sender] = true;
73     }
74 
75     modifier onlyOwner() { 
76         require(owners[msg.sender] == true);
77         _; 
78     }
79 
80     function isOwner() public view returns (bool) {
81         return owners[msg.sender] ? true : false;
82     }
83 
84     function grant(address _newOwner) external onlyOwner {
85         owners[_newOwner] = true;
86         AccessGrant(_newOwner);
87     }
88 
89     function revoke(address _oldOwner) external onlyOwner {
90         require(msg.sender != _oldOwner);
91         owners[_oldOwner] = false;
92         AccessRevoke(_oldOwner);
93     }
94 }
95 
96 /**
97  * @title ERC721 interface
98  * @dev see https://github.com/ethereum/eips/issues/721
99  */
100 contract ERC721 {
101   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
102   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
103 
104   function balanceOf(address _owner) public view returns (uint256 _balance);
105   function ownerOf(uint256 _tokenId) public view returns (address _owner);
106   function transfer(address _to, uint256 _tokenId) public;
107   function approve(address _to, uint256 _tokenId) public;
108   function takeOwnership(uint256 _tokenId) public;
109 }
110 
111 /**
112  * @title ERC721Token
113  * Generic implementation for the required functionality of the ERC721 standard
114  */
115 contract ERC721Token is ERC721 {
116   using SafeMath for uint256;
117 
118   // Total amount of tokens
119   uint256 internal totalTokens;
120 
121   // Mapping from token ID to owner
122   mapping (uint256 => address) private tokenOwner;
123 
124   // Mapping from token ID to approved address
125   mapping (uint256 => address) private tokenApprovals;
126 
127   // Mapping from owner to list of owned token IDs
128   mapping (address => uint256[]) private ownedTokens;
129 
130   // Mapping from token ID to index of the owner tokens list
131   mapping (uint256 => uint256) private ownedTokensIndex;
132 
133   /**
134   * @dev Guarantees msg.sender is owner of the given token
135   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
136   */
137   modifier onlyOwnerOf(uint256 _tokenId) {
138     require(ownerOf(_tokenId) == msg.sender);
139     _;
140   }
141 
142   /**
143   * @dev Gets the total amount of tokens stored by the contract
144   * @return uint256 representing the total amount of tokens
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalTokens;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address
152   * @param _owner address to query the balance of
153   * @return uint256 representing the amount owned by the passed address
154   */
155   function balanceOf(address _owner) public view returns (uint256) {
156     return ownedTokens[_owner].length;
157   }
158 
159   /**
160   * @dev Gets the list of tokens owned by a given address
161   * @param _owner address to query the tokens of
162   * @return uint256[] representing the list of tokens owned by the passed address
163   */
164   function tokensOf(address _owner) public view returns (uint256[]) {
165     return ownedTokens[_owner];
166   }
167 
168   /**
169   * @dev Gets the owner of the specified token ID
170   * @param _tokenId uint256 ID of the token to query the owner of
171   * @return owner address currently marked as the owner of the given token ID
172   */
173   function ownerOf(uint256 _tokenId) public view returns (address) {
174     address owner = tokenOwner[_tokenId];
175     require(owner != address(0));
176     return owner;
177   }
178 
179   /**
180    * @dev Gets the approved address to take ownership of a given token ID
181    * @param _tokenId uint256 ID of the token to query the approval of
182    * @return address currently approved to take ownership of the given token ID
183    */
184   function approvedFor(uint256 _tokenId) public view returns (address) {
185     return tokenApprovals[_tokenId];
186   }
187 
188   /**
189   * @dev Transfers the ownership of a given token ID to another address
190   * @param _to address to receive the ownership of the given token ID
191   * @param _tokenId uint256 ID of the token to be transferred
192   */
193   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
194     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
195   }
196 
197   /**
198   * @dev Approves another address to claim for the ownership of the given token ID
199   * @param _to address to be approved for the given token ID
200   * @param _tokenId uint256 ID of the token to be approved
201   */
202   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
203     address owner = ownerOf(_tokenId);
204     require(_to != owner);
205     if (approvedFor(_tokenId) != 0 || _to != 0) {
206       tokenApprovals[_tokenId] = _to;
207       Approval(owner, _to, _tokenId);
208     }
209   }
210 
211   /**
212   * @dev Claims the ownership of a given token ID
213   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
214   */
215   function takeOwnership(uint256 _tokenId) public {
216     require(isApprovedFor(msg.sender, _tokenId));
217     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
218   }
219 
220   /**
221   * @dev Mint token function
222   * @param _to The address that will own the minted token
223   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
224   */
225   function _mint(address _to, uint256 _tokenId) internal {
226     require(_to != address(0));
227     addToken(_to, _tokenId);
228     Transfer(0x0, _to, _tokenId);
229   }
230 
231   /**
232   * @dev Burns a specific token
233   * @param _tokenId uint256 ID of the token being burned by the msg.sender
234   */
235   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
236     if (approvedFor(_tokenId) != 0) {
237       clearApproval(msg.sender, _tokenId);
238     }
239     removeToken(msg.sender, _tokenId);
240     Transfer(msg.sender, 0x0, _tokenId);
241   }
242 
243   /**
244   * @dev Burns a specific token for a user.
245   * @param _tokenId uint256 ID of the token being burned by the msg.sender
246   */
247   function _burnFor(address _owner, uint256 _tokenId) internal {
248     if (isApprovedFor(_owner, _tokenId)) {
249       clearApproval(_owner, _tokenId);
250     }
251     removeToken(_owner, _tokenId);
252     Transfer(msg.sender, 0x0, _tokenId);
253   }
254 
255   /**
256    * @dev Tells whether the msg.sender is approved for the given token ID or not
257    * This function is not private so it can be extended in further implementations like the operatable ERC721
258    * @param _owner address of the owner to query the approval of
259    * @param _tokenId uint256 ID of the token to query the approval of
260    * @return bool whether the msg.sender is approved for the given token ID or not
261    */
262   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
263     return approvedFor(_tokenId) == _owner;
264   }
265 
266   /**
267   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
268   * @param _from address which you want to send tokens from
269   * @param _to address which you want to transfer the token to
270   * @param _tokenId uint256 ID of the token to be transferred
271   */
272   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
273     require(_to != address(0));
274     require(_to != ownerOf(_tokenId));
275     require(ownerOf(_tokenId) == _from);
276 
277     clearApproval(_from, _tokenId);
278     removeToken(_from, _tokenId);
279     addToken(_to, _tokenId);
280     Transfer(_from, _to, _tokenId);
281   }
282 
283   /**
284   * @dev Internal function to clear current approval of a given token ID
285   * @param _tokenId uint256 ID of the token to be transferred
286   */
287   function clearApproval(address _owner, uint256 _tokenId) private {
288     require(ownerOf(_tokenId) == _owner);
289     tokenApprovals[_tokenId] = 0;
290     Approval(_owner, 0, _tokenId);
291   }
292 
293   /**
294   * @dev Internal function to add a token ID to the list of a given address
295   * @param _to address representing the new owner of the given token ID
296   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
297   */
298   function addToken(address _to, uint256 _tokenId) private {
299     require(tokenOwner[_tokenId] == address(0));
300     tokenOwner[_tokenId] = _to;
301     uint256 length = balanceOf(_to);
302     ownedTokens[_to].push(_tokenId);
303     ownedTokensIndex[_tokenId] = length;
304     totalTokens = totalTokens.add(1);
305   }
306 
307   /**
308   * @dev Internal function to remove a token ID from the list of a given address
309   * @param _from address representing the previous owner of the given token ID
310   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
311   */
312   function removeToken(address _from, uint256 _tokenId) private {
313     require(ownerOf(_tokenId) == _from);
314 
315     uint256 tokenIndex = ownedTokensIndex[_tokenId];
316     uint256 lastTokenIndex = balanceOf(_from).sub(1);
317     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
318 
319     tokenOwner[_tokenId] = 0;
320     ownedTokens[_from][tokenIndex] = lastToken;
321     ownedTokens[_from][lastTokenIndex] = 0;
322     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
323     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
324     // the lastToken to the first position, and then dropping the element placed in the last position of the list
325 
326     ownedTokens[_from].length--;
327     ownedTokensIndex[_tokenId] = 0;
328     ownedTokensIndex[lastToken] = tokenIndex;
329     totalTokens = totalTokens.sub(1);
330   }
331 }
332 
333 contract Base is ERC721Token, MultiOwners {
334 
335   event NewCRLToken(address indexed owner, uint256 indexed tokenId, uint256 traits);
336   event UpdatedCRLToken(uint256 indexed UUID, uint256 indexed tokenId, uint256 traits);
337 
338   uint256 TOKEN_UUID;
339   uint256 UPGRADE_UUID;
340 
341   function _createToken(address _owner, uint256 _traits) internal {
342     // emit the creaton event
343     NewCRLToken(
344       _owner,
345       TOKEN_UUID,
346       _traits
347     );
348 
349     // This will assign ownership, and also emit the Transfer event
350     _mint(_owner, TOKEN_UUID);
351 
352     TOKEN_UUID++;
353   }
354 
355   function _updateToken(uint256 _tokenId, uint256 _traits) internal {
356     // emit the creaton event
357     UpdatedCRLToken(
358       UPGRADE_UUID,
359       _tokenId,
360       _traits
361     );
362 
363     UPGRADE_UUID++;
364   }
365 
366   // Eth balance controls
367 
368   // We can withdraw eth balance of contract.
369   function withdrawBalance() onlyOwner external {
370     require(this.balance > 0);
371 
372     msg.sender.transfer(this.balance);
373   }
374 }
375 
376 contract LootboxStore is Base {
377   // mapping between specific Lootbox contract address to price in wei
378   mapping(address => uint256) ethPricedLootboxes;
379 
380   // mapping between specific Lootbox contract address to price in NOS tokens
381   mapping(uint256 => uint256) NOSPackages;
382 
383   uint256 UUID;
384 
385   event NOSPurchased(uint256 indexed UUID, address indexed owner, uint256 indexed NOSAmtPurchased);
386 
387   function addLootbox(address _lootboxAddress, uint256 _price) external onlyOwner {
388     ethPricedLootboxes[_lootboxAddress] = _price;
389   }
390 
391   function removeLootbox(address _lootboxAddress) external onlyOwner {
392     delete ethPricedLootboxes[_lootboxAddress];
393   }
394 
395   function buyEthLootbox(address _lootboxAddress) payable external {
396     // Verify the given lootbox contract exists and they've paid enough
397     require(ethPricedLootboxes[_lootboxAddress] != 0);
398     require(msg.value >= ethPricedLootboxes[_lootboxAddress]);
399 
400     LootboxInterface(_lootboxAddress).buy(msg.sender);
401   }
402 
403   function addNOSPackage(uint256 _NOSAmt, uint256 _ethPrice) external onlyOwner {
404     NOSPackages[_NOSAmt] = _ethPrice;
405   }
406   
407   function removeNOSPackage(uint256 _NOSAmt) external onlyOwner {
408     delete NOSPackages[_NOSAmt];
409   }
410 
411   function buyNOS(uint256 _NOSAmt) payable external {
412     require(NOSPackages[_NOSAmt] != 0);
413     require(msg.value >= NOSPackages[_NOSAmt]);
414     
415     NOSPurchased(UUID, msg.sender, _NOSAmt);
416     UUID++;
417   }
418 }
419 
420 contract ExternalInterface {
421   function giveItem(address _recipient, uint256 _traits) external;
422 
423   function giveMultipleItems(address _recipient, uint256[] _traits) external;
424 
425   function giveMultipleItemsToMultipleRecipients(address[] _recipients, uint256[] _traits) external;
426 
427   function giveMultipleItemsAndDestroyMultipleItems(address _recipient, uint256[] _traits, uint256[] _tokenIds) external;
428   
429   function destroyItem(uint256 _tokenId) external;
430 
431   function destroyMultipleItems(uint256[] _tokenIds) external;
432 
433   function updateItemTraits(uint256 _tokenId, uint256 _traits) external;
434 }
435 
436 
437 contract Core is LootboxStore, ExternalInterface {
438   mapping(address => uint256) authorizedExternal;
439 
440   function addAuthorizedExternal(address _address) external onlyOwner {
441     authorizedExternal[_address] = 1;
442   }
443 
444   function removeAuthorizedExternal(address _address) external onlyOwner {
445     delete authorizedExternal[_address];
446   }
447 
448   // Verify the caller of this function is a Lootbox contract or race, or crafting, or upgrade
449   modifier onlyAuthorized() { 
450     require(ethPricedLootboxes[msg.sender] != 0 ||
451             authorizedExternal[msg.sender] != 0);
452       _; 
453   }
454 
455   function giveItem(address _recipient, uint256 _traits) onlyAuthorized external {
456     _createToken(_recipient, _traits);
457   }
458 
459   function giveMultipleItems(address _recipient, uint256[] _traits) onlyAuthorized external {
460     for (uint i = 0; i < _traits.length; ++i) {
461       _createToken(_recipient, _traits[i]);
462     }
463   }
464 
465   function giveMultipleItemsToMultipleRecipients(address[] _recipients, uint256[] _traits) onlyAuthorized external {
466     require(_recipients.length == _traits.length);
467 
468     for (uint i = 0; i < _traits.length; ++i) {
469       _createToken(_recipients[i], _traits[i]);
470     }
471   }
472 
473   function giveMultipleItemsAndDestroyMultipleItems(address _recipient, uint256[] _traits, uint256[] _tokenIds) onlyAuthorized external {
474     for (uint i = 0; i < _traits.length; ++i) {
475       _createToken(_recipient, _traits[i]);
476     }
477 
478     for (i = 0; i < _tokenIds.length; ++i) {
479       _burnFor(ownerOf(_tokenIds[i]), _tokenIds[i]);
480     }
481   }
482 
483   function destroyItem(uint256 _tokenId) onlyAuthorized external {
484     _burnFor(ownerOf(_tokenId), _tokenId);
485   }
486 
487   function destroyMultipleItems(uint256[] _tokenIds) onlyAuthorized external {
488     for (uint i = 0; i < _tokenIds.length; ++i) {
489       _burnFor(ownerOf(_tokenIds[i]), _tokenIds[i]);
490     }
491   }
492 
493   function updateItemTraits(uint256 _tokenId, uint256 _traits) onlyAuthorized external {
494     _updateToken(_tokenId, _traits);
495   }
496 }
497 
498 
499 contract LootboxInterface {
500   event LootboxPurchased(address indexed owner, uint16 displayValue);
501   
502   function buy(address _buyer) external;
503 }