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
25   //function tokenUri(uint256 _tokenId) public view returns (string);
26 }
27 
28 
29 contract HiPrecious is ERC721 {
30 
31   /*** EVENTS ***/
32 
33   /// @dev The Birth event is fired whenever a new precious comes into existence.
34   event Birth(uint256 tokenId, string name, address owner);
35 
36   /// @dev Transfer event as defined in current draft of ERC721.
37   ///  ownership is assigned, including births.
38   event Transfer(address from, address to, uint256 tokenId);
39 
40   /*** CONSTANTS ***/
41 
42   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
43   string public constant NAME = "HiPrecious"; // solhint-disable-line
44   string public constant SYMBOL = "HIP"; // solhint-disable-line
45 
46   /*** STORAGE ***/
47 
48   /// @dev A mapping from precious IDs to the address that owns them. All preciouses have
49   ///  some valid owner address.
50   mapping (uint256 => address) public preciousIndexToOwner;
51 
52   // @dev A mapping from owner address to count of precious that address owns.
53   //  Used internally inside balanceOf() to resolve ownership count.
54   mapping (address => uint256) private ownershipPreciousCount;
55 
56   /// @dev A mapping from HiPreciousIDs to an address that has been approved to call
57   ///  transferFrom(). Each Precious can only have one approved address for transfer
58   ///  at any time. A zero value means no approval is outstanding.
59   mapping (uint256 => address) public preciousIndexToApproved;
60 
61   // Addresses of the main roles in HiPrecious.
62   address public daVinciAddress; //CPO Product
63   address public cresusAddress;  //CFO Finance
64   
65   
66  function () public payable {} // Give the ability of receiving ether
67 
68   /*** DATATYPES ***/
69 
70   struct Precious {
71     string name;  // Edition name like 'Monroe'
72     uint256 number; //  Like 12 means #12 out of the edition.worldQuantity possible (here in the example 15)
73     uint256 editionId;  // id to find the edition in which this precious Belongs to. Stored in allEditions[precious.editionId]
74     uint256 collectionId; // id to find the collection in which this precious Belongs to. Stored in allCollections[precious.collectionId]
75     string tokenURI;
76   }
77 
78   struct Edition {
79     uint256 id;
80     string name; // Like 'Lee'
81     uint256 worldQuantity; // The number of precious composing this edition (ex: if 15 then there will never be more precious in this edition)
82     uint256[] preciousIds; // The list of precious ids which compose this edition.
83     uint256 collectionId;
84   }
85 
86   struct Collection {
87     uint256 id;
88     string name; // Like 'China'
89     uint256[] editionIds; // The list of edition ids which compose this collection Ex: allEditions.get[editionIds[0]].name = 'Lee01'dawd'
90   }
91 
92   Precious[] private allPreciouses;
93   Edition[] private allEditions;
94   Collection[] private allCollections;
95 
96   /*** ACCESS MODIFIERS ***/
97   /// @dev Access modifier for CEO-only functionality
98   modifier onlyDaVinci() {
99     require(msg.sender == daVinciAddress);
100     _;
101   }
102 
103   /// @dev Access modifier for CFO-only functionality
104   modifier onlyCresus() {
105     require(msg.sender == cresusAddress);
106     _;
107   }
108 
109   /// Access modifier for contract owner only functionality
110   modifier onlyCLevel() {
111     require(msg.sender == daVinciAddress || msg.sender == cresusAddress);
112     _;
113   }
114 
115   /*** CONSTRUCTOR ***/
116   function HiPrecious() public {
117     daVinciAddress = msg.sender;
118     cresusAddress = msg.sender;
119   }
120 
121   /*** PUBLIC FUNCTIONS ***/
122   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
123   /// @param _to The address to be granted transfer approval. Pass address(0) to
124   ///  clear all approvals.
125   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
126   /// @dev Required for ERC-721 compliance.
127   function approve(
128     address _to,
129     uint256 _tokenId
130   ) public {
131     // Caller must own token.
132     require(_owns(msg.sender, _tokenId));
133 
134     preciousIndexToApproved[_tokenId] = _to;
135 
136     emit Approval(msg.sender, _to, _tokenId);
137   }
138 
139   /// For querying balance of a particular account
140   /// @param _owner The address for balance query
141   /// @dev Required for ERC-721 compliance.
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return ownershipPreciousCount[_owner];
144   }
145 
146   /// @dev Creates a new Collection with the given name.
147   function createContractCollection(string _name) public onlyDaVinci {
148     _createCollection(_name);
149   }
150 
151   /// @dev Creates a new Edition with the given name and worldQuantity which will never be overcome.
152   function createContractEditionForCollection(string _name, uint256 _collectionId, uint256 _worldQuantity) public onlyDaVinci {
153     _createEdition(_name, _collectionId, _worldQuantity);
154   }
155   
156     /// @dev Creates a new Precious with the given name.
157   function createContractPreciousForEdition(address _to, uint256 _editionId, string _tokenURI) public onlyDaVinci {
158     _createPrecious(_to, _editionId, _tokenURI);
159   }
160 
161   /// @notice Returns all the relevant information about a specific precious.
162   /// @param _tokenId The tokenId of the precious of interest.
163   function getPrecious(uint256 _tokenId) public view returns (
164     string preciousName,
165     uint256 number,
166     uint256 editionId,
167     uint256 collectionId,
168     address owner
169   ) {
170     Precious storage precious = allPreciouses[_tokenId];
171     preciousName = precious.name;
172     number = precious.number;
173     editionId = precious.editionId;
174     collectionId = precious.collectionId;
175     owner = preciousIndexToOwner[_tokenId];
176   }
177 
178   /// @notice Returns all the relevant information about a specific edition.
179   /// @param _editionId The tokenId of the edition of interest.
180   function getEdition(uint256 _editionId) public view returns (
181     uint256 id,
182     string editionName,
183     uint256 worldQuantity,
184     uint256[] preciousIds
185   ) {
186     Edition storage edition = allEditions[_editionId-1];
187     id = edition.id;
188     editionName = edition.name;
189     worldQuantity = edition.worldQuantity;
190     preciousIds = edition.preciousIds;
191   }
192 
193   /// @notice Returns all the relevant information about a specific collection.
194   /// @param _collectionId The tokenId of the collection of interest.
195   function getCollection(uint256 _collectionId) public view returns (
196     uint256 id,
197     string collectionName,
198     uint256[] editionIds
199   ) {
200     Collection storage collection = allCollections[_collectionId-1];
201     id = collection.id;
202     collectionName = collection.name;
203     editionIds = collection.editionIds;
204   }
205 
206 
207   function implementsERC721() public pure returns (bool) {
208     return true;
209   }
210 
211   /// @dev Required for ERC-721 compliance.
212   function name() public pure returns (string) {
213     return NAME;
214   }
215 
216   /// For querying owner of token
217   /// @param _tokenId The tokenID for owner inquiry
218   /// @dev Required for ERC-721 compliance.
219   function ownerOf(uint256 _tokenId)
220     public
221     view
222     returns (address owner)
223   {
224     owner = preciousIndexToOwner[_tokenId];
225     require(owner != address(0));
226   }
227 
228   function payout(address _to) public onlyCresus {
229     _payout(_to);
230   }
231 
232   /// @dev Assigns a new address to act as the CPO. Only available to the current CPO.
233   /// @param _newDaVinci The address of the new CPO
234   function setDaVinci(address _newDaVinci) public onlyDaVinci {
235     require(_newDaVinci != address(0));
236 
237     daVinciAddress = _newDaVinci;
238   }
239 
240   /// @dev Assigns a new address to act as the CFO. Only available to the current CFO.
241   /// @param _newCresus The address of the new CFO
242   function setCresus(address _newCresus) public onlyCresus {
243     require(_newCresus != address(0));
244 
245     cresusAddress = _newCresus;
246   }
247 
248   function tokenURI(uint256 _tokenId) public view returns (string){
249       require(_tokenId<allPreciouses.length);
250       return allPreciouses[_tokenId].tokenURI;
251   }
252   
253   function setTokenURI(uint256 _tokenId, string newURI) public onlyDaVinci{
254       require(_tokenId<allPreciouses.length);
255       Precious storage precious = allPreciouses[_tokenId];
256       precious.tokenURI = newURI;
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
269     address oldOwner = preciousIndexToOwner[_tokenId];
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
280   /// @param _owner The owner whose celebrity tokens we are interested in.
281   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
282   ///  expensive (it walks the entire allPreciouses array looking for preciouses belonging to owner),
283   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
284   ///  not contract-to-contract calls.
285   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
286     uint256 tokenCount = balanceOf(_owner);
287     if (tokenCount == 0) {
288         // Return an empty array
289       return new uint256[](0);
290     } else {
291       uint256[] memory result = new uint256[](tokenCount);
292       uint256 totalPreciouses = totalSupply();
293       uint256 resultIndex = 0;
294 
295       uint256 preciousId;
296       for (preciousId = 0; preciousId <= totalPreciouses; preciousId++) {
297         if (preciousIndexToOwner[preciousId] == _owner) {
298           result[resultIndex] = preciousId;
299           resultIndex++;
300         }
301       }
302       return result;
303     }
304   }
305 
306   /// For querying totalSupply of preciouses
307   /// @dev Required for ERC-721 compliance.
308   function totalSupply() public view returns (uint256 total) {
309     return allPreciouses.length;
310   }
311 
312   /// Owner initates the transfer of the token to another account
313   /// @param _to The address for the token to be transferred to.
314   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
315   /// @dev Required for ERC-721 compliance.
316   function transfer(
317     address _to,
318     uint256 _tokenId
319   ) public {
320     require(_owns(msg.sender, _tokenId));
321     require(_addressNotNull(_to));
322 
323     _transfer(msg.sender, _to, _tokenId);
324   }
325 
326   /// Third-party initiates transfer of token from address _from to address _to
327   /// @param _from The address for the token to be transferred from.
328   /// @param _to The address for the token to be transferred to.
329   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
330   /// @dev Required for ERC-721 compliance.
331   function transferFrom(
332     address _from,
333     address _to,
334     uint256 _tokenId
335   ) public {
336     require(_owns(_from, _tokenId));
337     require(_approved(_to, _tokenId));
338     require(_addressNotNull(_to));
339 
340     _transfer(_from, _to, _tokenId);
341   }
342 
343   /*** PRIVATE FUNCTIONS ***/
344   /// Safety check on _to address to prevent against an unexpected 0x0 default.
345   function _addressNotNull(address _to) private pure returns (bool) {
346     return _to != address(0);
347   }
348 
349   /// For checking approval of transfer for address _to
350   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
351     return preciousIndexToApproved[_tokenId] == _to;
352   }
353 
354   /// For creating Collections
355   function _createCollection(string _name) private onlyDaVinci{
356     uint256 newCollectionId = allCollections.length+1;
357     uint256[] storage newEditionIds;
358     Collection memory _collection = Collection({
359       id: newCollectionId,
360       name: _name,
361       editionIds: newEditionIds
362     });
363 
364     allCollections.push(_collection);
365   }
366 
367   /// For creating Editions
368   function _createEdition(string _name, uint256 _collectionId, uint256 _worldQuantity) private onlyDaVinci{
369     Collection storage collection = allCollections[_collectionId-1]; //Would retrieve Bad instruction if not exist
370 
371     uint256 newEditionId = allEditions.length+1;
372     uint256[] storage newPreciousIds;
373 
374     Edition memory _edition = Edition({
375       id: newEditionId,
376       name: _name,
377       worldQuantity: _worldQuantity,
378       preciousIds: newPreciousIds,
379       collectionId: _collectionId
380     });
381 
382     allEditions.push(_edition);
383     collection.editionIds.push(newEditionId);
384   }
385 
386   /// For creating Precious
387   function _createPrecious(address _owner, uint256 _editionId, string _tokenURI) private onlyDaVinci{
388     Edition storage edition = allEditions[_editionId-1]; //if _editionId doesn't exist in array, exits.
389     
390     //Check if we can still print precious for that specific edition
391     require(edition.preciousIds.length < edition.worldQuantity);
392 
393     //string memory preciousName = edition.name + '_' + edition.preciousIds.length+1 + '/' + edition.worldQuantity; NOT DOABLE IN SOLIDITY
394 
395     Precious memory _precious = Precious({
396       name: edition.name,
397       number: edition.preciousIds.length+1,
398       editionId: _editionId,
399       collectionId: edition.collectionId,
400       tokenURI: _tokenURI
401     });
402 
403     uint256 newPreciousId = allPreciouses.push(_precious) - 1;
404     edition.preciousIds.push(newPreciousId);
405 
406     // It's probably never going to happen, 4 billion preciouses are A LOT, but
407     // let's just be 100% sure we never let this happen.
408     require(newPreciousId == uint256(uint32(newPreciousId)));
409 
410     emit Birth(newPreciousId, edition.name, _owner);
411 
412     // This will assign ownership, and also emit the Transfer event as
413     // per ERC721 draft
414     _transfer(address(0), _owner, newPreciousId);
415   }
416 
417   /// Check for token ownership
418   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
419     return claimant == preciousIndexToOwner[_tokenId];
420   }
421 
422   /// For paying out balance on contract
423   function _payout(address _to) private {
424     if (_to == address(0)) {
425       cresusAddress.transfer(address(this).balance);
426     } else {
427       _to.transfer(address(this).balance);
428     }
429   }
430 
431   /// @dev Assigns ownership of a specific Precious to an address.
432   function _transfer(address _from, address _to, uint256 _tokenId) private {
433     // Since the number of preciouses is capped to 2^32 we can't overflow this
434     ownershipPreciousCount[_to]++;
435     //transfer ownership
436     preciousIndexToOwner[_tokenId] = _to;
437 
438     // When creating new preciouses _from is 0x0, but we can't account that address.
439     if (_from != address(0)) {
440       ownershipPreciousCount[_from]--;
441       // clear any previously approved ownership exchange
442       delete preciousIndexToApproved[_tokenId];
443     }
444 
445     // Emit the transfer event.
446     emit Transfer(_from, _to, _tokenId);
447   }
448 }
449 library SafeMath {
450 
451   /**
452   * @dev Multiplies two numbers, throws on overflow.
453   */
454   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
455     if (a == 0) {
456       return 0;
457     }
458     uint256 c = a * b;
459     assert(c / a == b);
460     return c;
461   }
462 
463   /**
464   * @dev Integer division of two numbers, truncating the quotient.
465   */
466   function div(uint256 a, uint256 b) internal pure returns (uint256) {
467     // assert(b > 0); // Solidity automatically throws when dividing by 0
468     uint256 c = a / b;
469     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
470     return c;
471   }
472 
473   /**
474   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
475   */
476   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
477     assert(b <= a);
478     return a - b;
479   }
480 
481   /**
482   * @dev Adds two numbers, throws on overflow.
483   */
484   function add(uint256 a, uint256 b) internal pure returns (uint256) {
485     uint256 c = a + b;
486     assert(c >= a);
487     return c;
488   }
489 }