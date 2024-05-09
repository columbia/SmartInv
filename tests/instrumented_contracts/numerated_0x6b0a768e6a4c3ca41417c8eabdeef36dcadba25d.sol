1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * Utility library of inline functions on addresses
51  */
52 library AddressUtils {
53 
54   /**
55    * Returns whether the target address is a contract
56    * @dev This function will return false if invoked during the constructor of a contract,
57    *  as the code is not actually created until after the constructor finishes.
58    * @param addr address to check
59    * @return whether the target address is a contract
60    */
61   function isContract(address addr) internal view returns (bool) {
62     uint256 size;
63     // XXX Currently there is no better way to check if there is a contract in an address
64     // than to check the size of the code at that address.
65     // See https://ethereum.stackexchange.com/a/14016/36603
66     // for more details about how this works.
67     // TODO Check this again before the Serenity release, because all addresses will be
68     // contracts then.
69     // solium-disable-next-line security/no-inline-assembly
70     assembly { size := extcodesize(addr) }
71     return size > 0;
72   }
73 
74 }
75 
76 interface ERC165 {
77     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
78 }
79 
80 contract SupportsInterface is ERC165 {
81     
82     mapping(bytes4 => bool) internal supportedInterfaces;
83 
84     constructor() public {
85         supportedInterfaces[0x01ffc9a7] = true; // ERC165
86     }
87 
88     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
89         return supportedInterfaces[_interfaceID];
90     }
91 }
92 
93 interface ERC721 {
94     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
95     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
96     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
97     
98     function balanceOf(address _owner) external view returns (uint256);
99     function ownerOf(uint256 _tokenId) external view returns (address);
100     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external;
101     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
102     
103     function transferFrom(address _from, address _to, uint256 _tokenId) external;
104     function approve(address _approved, uint256 _tokenId) external;
105     function setApprovalForAll(address _operator, bool _approved) external;
106     
107     function getApproved(uint256 _tokenId) external view returns (address);
108     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
109 }
110 
111 interface ERC721Enumerable {
112     function totalSupply() external view returns (uint256);
113     function tokenByIndex(uint256 _index) external view returns (uint256);
114     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
115 }
116 
117 interface ERC721Metadata {
118     function name() external view returns (string _name);
119     function symbol() external view returns (string _symbol);
120     function tokenURI(uint256 _tokenId) external view returns (string);
121 }
122 
123 interface ERC721TokenReceiver {
124   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
125 }
126 
127 contract NFToken is ERC721, SupportsInterface {
128 
129     using SafeMath for uint256;
130     using AddressUtils for address;
131     
132     // A mapping from NFT ID to the address that owns it.
133     mapping (uint256 => address) internal idToOwner;
134     
135     // Mapping from NFT ID to approved address.
136     mapping (uint256 => address) internal idToApprovals;
137     
138     // Mapping from owner address to count of his tokens.
139     mapping (address => uint256) internal ownerToNFTokenCount;
140     
141     // Mapping from owner address to mapping of operator addresses.
142     mapping (address => mapping (address => bool)) internal ownerToOperators;
143     
144     /**
145     * @dev Magic value of a smart contract that can recieve NFT.
146     * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
147     */
148     bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
149 
150     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
151     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
152     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
153 
154     modifier canOperate(uint256 _tokenId) {
155         address tokenOwner = idToOwner[_tokenId];
156         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
157         _;
158     }
159 
160 
161     modifier canTransfer(uint256 _tokenId) {
162         address tokenOwner = idToOwner[_tokenId];
163         require(tokenOwner == msg.sender || getApproved(_tokenId) == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
164         _;
165     }
166 
167     modifier validNFToken(uint256 _tokenId) {
168         require(idToOwner[_tokenId] != address(0));
169         _;
170     }
171 
172     constructor() public {
173         supportedInterfaces[0x80ac58cd] = true; // ERC721
174     }
175 
176 
177     function balanceOf(address _owner) external view returns (uint256) {
178         require(_owner != address(0));
179         return ownerToNFTokenCount[_owner];
180     }
181 
182     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
183         _owner = idToOwner[_tokenId];
184         require(_owner != address(0));
185     }
186 
187 
188     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
189         _safeTransferFrom(_from, _to, _tokenId, _data);
190     }
191 
192     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
193         _safeTransferFrom(_from, _to, _tokenId, "");
194     }
195 
196     function transferFrom(address _from, address _to, uint256 _tokenId) external canTransfer(_tokenId) validNFToken(_tokenId) {
197         address tokenOwner = idToOwner[_tokenId];
198         require(tokenOwner == _from);
199         require(_to != address(0));
200         _transfer(_to, _tokenId);
201     }
202 
203     function approve(address _approved, uint256 _tokenId) external canOperate(_tokenId) validNFToken(_tokenId) {
204         address tokenOwner = idToOwner[_tokenId];
205         require(_approved != tokenOwner);
206 
207         idToApprovals[_tokenId] = _approved;
208         emit Approval(tokenOwner, _approved, _tokenId);
209     }
210 
211     function setApprovalForAll(address _operator, bool _approved) external {
212         require(_operator != address(0));
213         ownerToOperators[msg.sender][_operator] = _approved;
214         emit ApprovalForAll(msg.sender, _operator, _approved);
215     }
216 
217     function getApproved(uint256 _tokenId) public view validNFToken(_tokenId) returns (address) {
218         return idToApprovals[_tokenId];
219     }
220 
221     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
222         require(_owner != address(0));
223         require(_operator != address(0));
224         return ownerToOperators[_owner][_operator];
225     }
226 
227     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) internal canTransfer(_tokenId) validNFToken(_tokenId) {
228         address tokenOwner = idToOwner[_tokenId];
229         require(tokenOwner == _from);
230         require(_to != address(0));
231 
232         _transfer(_to, _tokenId);
233 
234         if (_to.isContract()) {
235             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
236             require(retval == MAGIC_ON_ERC721_RECEIVED);
237         }
238     }
239 
240     function _transfer(address _to, uint256 _tokenId) private {
241         address from = idToOwner[_tokenId];
242         clearApproval(_tokenId);
243         removeNFToken(from, _tokenId);
244         addNFToken(_to, _tokenId);
245         emit Transfer(from, _to, _tokenId);
246     }
247    
248 
249     function _mint(address _to, uint256 _tokenId) internal {
250         require(_to != address(0));
251         require(_tokenId != 0);
252         require(idToOwner[_tokenId] == address(0));
253 
254         addNFToken(_to, _tokenId);
255 
256         emit Transfer(address(0), _to, _tokenId);
257     }
258 
259     function _burn(address _owner, uint256 _tokenId) validNFToken(_tokenId) internal { 
260         clearApproval(_tokenId);
261         removeNFToken(_owner, _tokenId);
262         emit Transfer(_owner, address(0), _tokenId);
263     }
264 
265     function clearApproval(uint256 _tokenId) private {
266         if(idToApprovals[_tokenId] != 0) {
267             delete idToApprovals[_tokenId];
268         }
269     }
270 
271     function removeNFToken(address _from, uint256 _tokenId) internal {
272         require(idToOwner[_tokenId] == _from);
273         assert(ownerToNFTokenCount[_from] > 0);
274         ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
275         delete idToOwner[_tokenId];
276     }
277 
278     function addNFToken(address _to, uint256 _tokenId) internal {
279         require(idToOwner[_tokenId] == address(0));
280 
281         idToOwner[_tokenId] = _to;
282         ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
283     }
284 }
285 
286 
287 contract NFTokenEnumerable is NFToken, ERC721Enumerable {
288 
289     // Array of all NFT IDs.
290     uint256[] internal tokens;
291 
292     // Mapping from token ID its index in global tokens array.
293     mapping(uint256 => uint256) internal idToIndex;
294 
295     // Mapping from owner to list of owned NFT IDs.
296     mapping(address => uint256[]) internal ownerToIds;
297 
298     // Mapping from NFT ID to its index in the owner tokens list.
299     mapping(uint256 => uint256) internal idToOwnerIndex;
300 
301     constructor() public {
302         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
303     }
304 
305     function _mint(address _to, uint256 _tokenId) internal {
306         super._mint(_to, _tokenId);
307         uint256 length = tokens.push(_tokenId);
308         idToIndex[_tokenId] = length - 1;
309     }
310 
311     function _burn(address _owner, uint256 _tokenId) internal {
312         super._burn(_owner, _tokenId);
313         assert(tokens.length > 0);
314 
315         uint256 tokenIndex = idToIndex[_tokenId];
316         // Sanity check. This could be removed in the future.
317         assert(tokens[tokenIndex] == _tokenId);
318         uint256 lastTokenIndex = tokens.length - 1;
319         uint256 lastToken = tokens[lastTokenIndex];
320 
321         tokens[tokenIndex] = lastToken;
322 
323         tokens.length--;
324         // Consider adding a conditional check for the last token in order to save GAS.
325         idToIndex[lastToken] = tokenIndex;
326         idToIndex[_tokenId] = 0;
327     }
328 
329     function removeNFToken(address _from, uint256 _tokenId) internal
330     {
331         super.removeNFToken(_from, _tokenId);
332         assert(ownerToIds[_from].length > 0);
333 
334         uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
335         uint256 lastTokenIndex = ownerToIds[_from].length - 1;
336         uint256 lastToken = ownerToIds[_from][lastTokenIndex];
337 
338         ownerToIds[_from][tokenToRemoveIndex] = lastToken;
339 
340         ownerToIds[_from].length--;
341         // Consider adding a conditional check for the last token in order to save GAS.
342         idToOwnerIndex[lastToken] = tokenToRemoveIndex;
343         idToOwnerIndex[_tokenId] = 0;
344     }
345 
346     function addNFToken(address _to, uint256 _tokenId) internal {
347         super.addNFToken(_to, _tokenId);
348 
349         uint256 length = ownerToIds[_to].push(_tokenId);
350         idToOwnerIndex[_tokenId] = length - 1;
351     }
352 
353     function totalSupply() external view returns (uint256) {
354         return tokens.length;
355     }
356 
357     function tokenByIndex(uint256 _index) external view returns (uint256) {
358         require(_index < tokens.length);
359         // Sanity check. This could be removed in the future.
360         assert(idToIndex[tokens[_index]] == _index);
361         return tokens[_index];
362     }
363 
364     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
365         require(_index < ownerToIds[_owner].length);
366         return ownerToIds[_owner][_index];
367     }
368 
369 }
370 
371 contract NFTStandard is NFTokenEnumerable, ERC721Metadata {
372     string internal nftName;
373     string internal nftSymbol;
374     
375     mapping (uint256 => string) internal idToUri;
376     
377     constructor(string _name, string _symbol) public {
378         nftName = _name;
379         nftSymbol = _symbol;
380         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
381     }
382     
383     function _burn(address _owner, uint256 _tokenId) internal {
384         super._burn(_owner, _tokenId);
385         if (bytes(idToUri[_tokenId]).length != 0) {
386         delete idToUri[_tokenId];
387         }
388     }
389     
390     function _setTokenUri(uint256 _tokenId, string _uri) validNFToken(_tokenId) internal {
391         idToUri[_tokenId] = _uri;
392     }
393     
394     function name() external view returns (string _name) {
395         _name = nftName;
396     }
397     
398     function symbol() external view returns (string _symbol) {
399         _symbol = nftSymbol;
400     }
401     
402     function tokenURI(uint256 _tokenId) validNFToken(_tokenId) external view returns (string) {
403         return idToUri[_tokenId];
404     }
405 }
406 
407 contract BasicAccessControl {
408     address public owner;
409     // address[] public moderators;
410     uint16 public totalModerators = 0;
411     mapping (address => bool) public moderators;
412     bool public isMaintaining = false;
413 
414     constructor() public {
415         owner = msg.sender;
416     }
417 
418     modifier onlyOwner {
419         require(msg.sender == owner);
420         _;
421     }
422 
423     modifier onlyModerators() {
424         require(msg.sender == owner || moderators[msg.sender] == true);
425         _;
426     }
427 
428     modifier isActive {
429         require(!isMaintaining);
430         _;
431     }
432 
433     function ChangeOwner(address _newOwner) onlyOwner public {
434         if (_newOwner != address(0)) {
435             owner = _newOwner;
436         }
437     }
438 
439 
440     function AddModerator(address _newModerator) onlyOwner public {
441         if (moderators[_newModerator] == false) {
442             moderators[_newModerator] = true;
443             totalModerators += 1;
444         }
445     }
446     
447     function RemoveModerator(address _oldModerator) onlyOwner public {
448         if (moderators[_oldModerator] == true) {
449             moderators[_oldModerator] = false;
450             totalModerators -= 1;
451         }
452     }
453 
454     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
455         isMaintaining = _isMaintaining;
456     }
457 }
458 
459 interface EtheremonAdventureHandler {
460     function handleSingleItem(address _sender, uint _classId, uint _value, uint _target, uint _param) external;
461     function handleMultipleItems(address _sender, uint _classId1, uint _classId2, uint _classId3, uint _target, uint _param) external;
462 }
463 
464 contract EtheremonAdventureItem is NFTStandard("EtheremonAdventure", "EMOND"), BasicAccessControl {
465     uint constant public MAX_OWNER_PERS_SITE = 10;
466     uint constant public MAX_SITE_ID = 108;
467     uint constant public MAX_SITE_TOKEN_ID = 1080;
468     
469     // smartcontract
470     address public adventureHandler;
471     
472     // class sites: 1 -> 108
473     // shard: 109 - 126
474     // level, exp
475     struct Item {
476         uint classId;
477         uint value;
478     }
479     
480     uint public totalItem = MAX_SITE_TOKEN_ID;
481     mapping (uint => uint[]) sites; // site class id => token id
482     mapping (uint => Item) items; // token id => info
483     
484     modifier requireAdventureHandler {
485         require(adventureHandler != address(0));
486         _;        
487     }
488     
489     function setAdventureHandler(address _adventureHandler) onlyModerators external {
490         adventureHandler = _adventureHandler;
491     }
492     
493     function setTokenURI(uint256 _tokenId, string _uri) onlyModerators external {
494         _setTokenUri(_tokenId, _uri);
495     }
496     
497     function spawnSite(uint _classId, uint _tokenId, address _owner) onlyModerators external {
498         if (_owner == address(0)) revert();
499         if (_classId > MAX_SITE_ID || _classId == 0 || _tokenId > MAX_SITE_TOKEN_ID || _tokenId == 0) revert();
500         
501         // can not spawn more than MAX_OWNER_PERS_SITE per site
502         uint[] storage siteIds = sites[_classId];
503         if (siteIds.length > MAX_OWNER_PERS_SITE)
504             revert();
505         
506         Item storage item = items[_tokenId];
507         if (item.classId != 0) revert(); // token existed
508         item.classId = _classId;
509         siteIds.push(_tokenId);
510         
511         _mint(_owner, _tokenId);
512     }
513     
514     function spawnItem(uint _classId, uint _value, address _owner) onlyModerators external returns(uint) {
515         if (_owner == address(0)) revert();
516         if (_classId < MAX_SITE_ID) revert();
517         
518         totalItem += 1;
519         Item storage item = items[totalItem];
520         item.classId = _classId;
521         item.value = _value;
522         
523         _mint(_owner, totalItem);
524         return totalItem;
525     }
526     
527     
528     // public write 
529     function useSingleItem(uint _tokenId, uint _target, uint _param) isActive requireAdventureHandler public {
530         // check ownership
531         if (_tokenId == 0 || idToOwner[_tokenId] != msg.sender) revert();
532         Item storage item = items[_tokenId];
533         
534         EtheremonAdventureHandler handler = EtheremonAdventureHandler(adventureHandler);
535         handler.handleSingleItem(msg.sender, item.classId, item.value, _target, _param);
536         
537         _burn(msg.sender, _tokenId);
538     }
539     
540     function useMultipleItem(uint _token1, uint _token2, uint _token3, uint _target, uint _param) isActive requireAdventureHandler public {
541         if (_token1 > 0 && idToOwner[_token1] != msg.sender) revert();
542         if (_token2 > 0 && idToOwner[_token2] != msg.sender) revert();
543         if (_token3 > 0 && idToOwner[_token3] != msg.sender) revert();
544         
545         Item storage item1 = items[_token1];
546         Item storage item2 = items[_token2];
547         Item storage item3 = items[_token3];
548         
549         EtheremonAdventureHandler handler = EtheremonAdventureHandler(adventureHandler);
550         handler.handleMultipleItems(msg.sender, item1.classId, item2.classId, item3.classId, _target, _param);
551         
552         if (_token1 > 0) _burn(msg.sender, _token1);
553         if (_token2 > 0) _burn(msg.sender, _token2);
554         if (_token3 > 0) _burn(msg.sender, _token3);
555     }
556     
557     
558     // public read 
559     function getItemInfo(uint _tokenId) constant public returns(uint classId, uint value) {
560         Item storage item = items[_tokenId];
561         classId = item.classId;
562         value = item.classId;
563     }
564     
565     function getSiteTokenId(uint _classId, uint _index) constant public returns(uint tokenId) {
566         return sites[_classId][_index];
567     }
568     
569     function getSiteTokenLength(uint _classId) constant public returns(uint length) {
570         return sites[_classId].length;
571     }
572     
573     function getSiteTokenIds(uint _classId) constant public returns(uint[]) {
574         return sites[_classId];
575     }
576 }