1 pragma solidity ^0.4.23;
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
104     function transfer(address _to, uint256 _tokenId) external;
105     function approve(address _approved, uint256 _tokenId) external;
106     function setApprovalForAll(address _operator, bool _approved) external;
107     
108     function getApproved(uint256 _tokenId) external view returns (address);
109     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
110 }
111 
112 interface ERC721Enumerable {
113     function totalSupply() external view returns (uint256);
114     function tokenByIndex(uint256 _index) external view returns (uint256);
115     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
116 }
117 
118 interface ERC721Metadata {
119     function name() external view returns (string _name);
120     function symbol() external view returns (string _symbol);
121     function tokenURI(uint256 _tokenId) external view returns (string);
122 }
123 
124 interface ERC721TokenReceiver {
125   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
126 }
127 
128 contract NFToken is ERC721, SupportsInterface {
129 
130     using SafeMath for uint256;
131     using AddressUtils for address;
132     
133     // A mapping from NFT ID to the address that owns it.
134     mapping (uint256 => address) internal idToOwner;
135     
136     // Mapping from NFT ID to approved address.
137     mapping (uint256 => address) internal idToApprovals;
138     
139     // Mapping from owner address to count of his tokens.
140     mapping (address => uint256) internal ownerToNFTokenCount;
141     
142     // Mapping from owner address to mapping of operator addresses.
143     mapping (address => mapping (address => bool)) internal ownerToOperators;
144     
145     /**
146     * @dev Magic value of a smart contract that can recieve NFT.
147     * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
148     */
149     bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
150 
151     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
152     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
153     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
154 
155     modifier canOperate(uint256 _tokenId) {
156         address tokenOwner = idToOwner[_tokenId];
157         require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
158         _;
159     }
160 
161 
162     modifier canTransfer(uint256 _tokenId) {
163         address tokenOwner = idToOwner[_tokenId];
164         require(tokenOwner == msg.sender || getApproved(_tokenId) == msg.sender || ownerToOperators[tokenOwner][msg.sender]);
165         _;
166     }
167 
168     modifier validNFToken(uint256 _tokenId) {
169         require(idToOwner[_tokenId] != address(0));
170         _;
171     }
172 
173     constructor() public {
174         supportedInterfaces[0x80ac58cd] = true; // ERC721
175     }
176 
177 
178     function balanceOf(address _owner) external view returns (uint256) {
179         require(_owner != address(0));
180         return ownerToNFTokenCount[_owner];
181     }
182 
183     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
184         _owner = idToOwner[_tokenId];
185         require(_owner != address(0));
186     }
187 
188 
189     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
190         _safeTransferFrom(_from, _to, _tokenId, _data);
191     }
192 
193     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
194         _safeTransferFrom(_from, _to, _tokenId, "");
195     }
196 
197     function transferFrom(address _from, address _to, uint256 _tokenId) external canTransfer(_tokenId) validNFToken(_tokenId) {
198         address tokenOwner = idToOwner[_tokenId];
199         require(tokenOwner == _from);
200         require(_to != address(0));
201         _transfer(_to, _tokenId);
202     }
203     
204     function transfer(address _to, uint256 _tokenId) external canTransfer(_tokenId) validNFToken(_tokenId) {
205         address tokenOwner = idToOwner[_tokenId];
206         require(tokenOwner == msg.sender);
207         require(_to != address(0));
208         _transfer(_to, _tokenId);
209     }
210 
211     function approve(address _approved, uint256 _tokenId) external canOperate(_tokenId) validNFToken(_tokenId) {
212         address tokenOwner = idToOwner[_tokenId];
213         require(_approved != tokenOwner);
214 
215         idToApprovals[_tokenId] = _approved;
216         emit Approval(tokenOwner, _approved, _tokenId);
217     }
218 
219     function setApprovalForAll(address _operator, bool _approved) external {
220         require(_operator != address(0));
221         ownerToOperators[msg.sender][_operator] = _approved;
222         emit ApprovalForAll(msg.sender, _operator, _approved);
223     }
224 
225     function getApproved(uint256 _tokenId) public view validNFToken(_tokenId) returns (address) {
226         return idToApprovals[_tokenId];
227     }
228 
229     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
230         require(_owner != address(0));
231         require(_operator != address(0));
232         return ownerToOperators[_owner][_operator];
233     }
234 
235     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) internal canTransfer(_tokenId) validNFToken(_tokenId) {
236         address tokenOwner = idToOwner[_tokenId];
237         require(tokenOwner == _from);
238         require(_to != address(0));
239 
240         _transfer(_to, _tokenId);
241 
242         if (_to.isContract()) {
243             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
244             require(retval == MAGIC_ON_ERC721_RECEIVED);
245         }
246     }
247 
248     function _transfer(address _to, uint256 _tokenId) private {
249         address from = idToOwner[_tokenId];
250         clearApproval(_tokenId);
251         removeNFToken(from, _tokenId);
252         addNFToken(_to, _tokenId);
253         emit Transfer(from, _to, _tokenId);
254     }
255    
256 
257     function _mint(address _to, uint256 _tokenId) internal {
258         require(_to != address(0));
259         require(_tokenId != 0);
260         require(idToOwner[_tokenId] == address(0));
261 
262         addNFToken(_to, _tokenId);
263 
264         emit Transfer(address(0), _to, _tokenId);
265     }
266 
267     function _burn(address _owner, uint256 _tokenId) validNFToken(_tokenId) internal { 
268         clearApproval(_tokenId);
269         removeNFToken(_owner, _tokenId);
270         emit Transfer(_owner, address(0), _tokenId);
271     }
272 
273     function clearApproval(uint256 _tokenId) private {
274         if(idToApprovals[_tokenId] != 0) {
275             delete idToApprovals[_tokenId];
276         }
277     }
278 
279     function removeNFToken(address _from, uint256 _tokenId) internal {
280         require(idToOwner[_tokenId] == _from);
281         assert(ownerToNFTokenCount[_from] > 0);
282         ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;
283         delete idToOwner[_tokenId];
284     }
285 
286     function addNFToken(address _to, uint256 _tokenId) internal {
287         require(idToOwner[_tokenId] == address(0));
288 
289         idToOwner[_tokenId] = _to;
290         ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);
291     }
292 }
293 
294 
295 contract NFTokenEnumerable is NFToken, ERC721Enumerable {
296 
297     // Array of all NFT IDs.
298     uint256[] internal tokens;
299 
300     // Mapping from token ID its index in global tokens array.
301     mapping(uint256 => uint256) internal idToIndex;
302 
303     // Mapping from owner to list of owned NFT IDs.
304     mapping(address => uint256[]) internal ownerToIds;
305 
306     // Mapping from NFT ID to its index in the owner tokens list.
307     mapping(uint256 => uint256) internal idToOwnerIndex;
308 
309     constructor() public {
310         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
311     }
312 
313     function _mint(address _to, uint256 _tokenId) internal {
314         super._mint(_to, _tokenId);
315         uint256 length = tokens.push(_tokenId);
316         idToIndex[_tokenId] = length - 1;
317     }
318 
319     function _burn(address _owner, uint256 _tokenId) internal {
320         super._burn(_owner, _tokenId);
321         assert(tokens.length > 0);
322 
323         uint256 tokenIndex = idToIndex[_tokenId];
324         // Sanity check. This could be removed in the future.
325         assert(tokens[tokenIndex] == _tokenId);
326         uint256 lastTokenIndex = tokens.length - 1;
327         uint256 lastToken = tokens[lastTokenIndex];
328 
329         tokens[tokenIndex] = lastToken;
330 
331         tokens.length--;
332         // Consider adding a conditional check for the last token in order to save GAS.
333         idToIndex[lastToken] = tokenIndex;
334         idToIndex[_tokenId] = 0;
335     }
336 
337     function removeNFToken(address _from, uint256 _tokenId) internal
338     {
339         super.removeNFToken(_from, _tokenId);
340         assert(ownerToIds[_from].length > 0);
341 
342         uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
343         uint256 lastTokenIndex = ownerToIds[_from].length - 1;
344         uint256 lastToken = ownerToIds[_from][lastTokenIndex];
345 
346         ownerToIds[_from][tokenToRemoveIndex] = lastToken;
347 
348         ownerToIds[_from].length--;
349         // Consider adding a conditional check for the last token in order to save GAS.
350         idToOwnerIndex[lastToken] = tokenToRemoveIndex;
351         idToOwnerIndex[_tokenId] = 0;
352     }
353 
354     function addNFToken(address _to, uint256 _tokenId) internal {
355         super.addNFToken(_to, _tokenId);
356 
357         uint256 length = ownerToIds[_to].push(_tokenId);
358         idToOwnerIndex[_tokenId] = length - 1;
359     }
360 
361     function totalSupply() external view returns (uint256) {
362         return tokens.length;
363     }
364 
365     function tokenByIndex(uint256 _index) external view returns (uint256) {
366         require(_index < tokens.length);
367         // Sanity check. This could be removed in the future.
368         assert(idToIndex[tokens[_index]] == _index);
369         return tokens[_index];
370     }
371 
372     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
373         require(_index < ownerToIds[_owner].length);
374         return ownerToIds[_owner][_index];
375     }
376 
377 }
378 
379 contract NFTStandard is NFTokenEnumerable, ERC721Metadata {
380     string internal nftName;
381     string internal nftSymbol;
382     
383     mapping (uint256 => string) internal idToUri;
384     
385     constructor(string _name, string _symbol) public {
386         nftName = _name;
387         nftSymbol = _symbol;
388         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
389     }
390     
391     function _burn(address _owner, uint256 _tokenId) internal {
392         super._burn(_owner, _tokenId);
393         if (bytes(idToUri[_tokenId]).length != 0) {
394         delete idToUri[_tokenId];
395         }
396     }
397     
398     function _setTokenUri(uint256 _tokenId, string _uri) validNFToken(_tokenId) internal {
399         idToUri[_tokenId] = _uri;
400     }
401     
402     function name() external view returns (string _name) {
403         _name = nftName;
404     }
405     
406     function symbol() external view returns (string _symbol) {
407         _symbol = nftSymbol;
408     }
409     
410     function tokenURI(uint256 _tokenId) validNFToken(_tokenId) external view returns (string) {
411         return idToUri[_tokenId];
412     }
413 }
414 
415 contract BasicAccessControl {
416     address public owner;
417     // address[] public moderators;
418     uint16 public totalModerators = 0;
419     mapping (address => bool) public moderators;
420     bool public isMaintaining = false;
421 
422     constructor() public {
423         owner = msg.sender;
424     }
425 
426     modifier onlyOwner {
427         require(msg.sender == owner);
428         _;
429     }
430 
431     modifier onlyModerators() {
432         require(msg.sender == owner || moderators[msg.sender] == true);
433         _;
434     }
435 
436     modifier isActive {
437         require(!isMaintaining);
438         _;
439     }
440 
441     function ChangeOwner(address _newOwner) onlyOwner public {
442         if (_newOwner != address(0)) {
443             owner = _newOwner;
444         }
445     }
446 
447 
448     function AddModerator(address _newModerator) onlyOwner public {
449         if (moderators[_newModerator] == false) {
450             moderators[_newModerator] = true;
451             totalModerators += 1;
452         }
453     }
454     
455     function RemoveModerator(address _oldModerator) onlyOwner public {
456         if (moderators[_oldModerator] == true) {
457             moderators[_oldModerator] = false;
458             totalModerators -= 1;
459         }
460     }
461 
462     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
463         isMaintaining = _isMaintaining;
464     }
465 }
466 
467 interface EtheremonAdventureHandler {
468     function handleSingleItem(address _sender, uint _classId, uint _value, uint _target, uint _param) external;
469     function handleMultipleItems(address _sender, uint _classId1, uint _classId2, uint _classId3, uint _target, uint _param) external;
470 }
471 
472 contract EtheremonAdventureItem is NFTStandard("EtheremonAdventure", "EMOND"), BasicAccessControl {
473     uint constant public MAX_OWNER_PERS_SITE = 10;
474     uint constant public MAX_SITE_ID = 108;
475     uint constant public MAX_SITE_TOKEN_ID = 1080;
476     
477     // smartcontract
478     address public adventureHandler;
479     
480     // class sites: 1 -> 108
481     // shard: 109 - 126
482     // level, exp
483     struct Item {
484         uint classId;
485         uint value;
486     }
487     
488     uint public totalItem = MAX_SITE_TOKEN_ID;
489     mapping (uint => Item) public items; // token id => info
490     
491     modifier requireAdventureHandler {
492         require(adventureHandler != address(0));
493         _;        
494     }
495     
496     function setAdventureHandler(address _adventureHandler) onlyModerators external {
497         adventureHandler = _adventureHandler;
498     }
499     
500     function setTokenURI(uint256 _tokenId, string _uri) onlyModerators external {
501         _setTokenUri(_tokenId, _uri);
502     }
503     
504     function spawnSite(uint _classId, uint _tokenId, address _owner) onlyModerators external {
505         if (_owner == address(0)) revert();
506         if (_classId > MAX_SITE_ID || _classId == 0 || _tokenId > MAX_SITE_TOKEN_ID || _tokenId == 0) revert();
507         
508         Item storage item = items[_tokenId];
509         if (item.classId != 0) revert(); // token existed
510         item.classId = _classId;
511         
512         _mint(_owner, _tokenId);
513     }
514     
515     function spawnItem(uint _classId, uint _value, address _owner) onlyModerators external returns(uint) {
516         if (_owner == address(0)) revert();
517         if (_classId <= MAX_SITE_ID) revert();
518         
519         totalItem += 1;
520         Item storage item = items[totalItem];
521         item.classId = _classId;
522         item.value = _value;
523         
524         _mint(_owner, totalItem);
525         return totalItem;
526     }
527     
528     
529     // public write 
530     function useSingleItem(uint _tokenId, uint _target, uint _param) isActive requireAdventureHandler public {
531         // check ownership
532         if (_tokenId == 0 || idToOwner[_tokenId] != msg.sender) revert();
533         Item storage item = items[_tokenId];
534         
535         EtheremonAdventureHandler handler = EtheremonAdventureHandler(adventureHandler);
536         handler.handleSingleItem(msg.sender, item.classId, item.value, _target, _param);
537         
538         _burn(msg.sender, _tokenId);
539     }
540     
541     function useMultipleItem(uint _token1, uint _token2, uint _token3, uint _target, uint _param) isActive requireAdventureHandler public {
542         if (_token1 > 0 && idToOwner[_token1] != msg.sender) revert();
543         if (_token2 > 0 && idToOwner[_token2] != msg.sender) revert();
544         if (_token3 > 0 && idToOwner[_token3] != msg.sender) revert();
545         
546         Item storage item1 = items[_token1];
547         Item storage item2 = items[_token2];
548         Item storage item3 = items[_token3];
549         
550         EtheremonAdventureHandler handler = EtheremonAdventureHandler(adventureHandler);
551         handler.handleMultipleItems(msg.sender, item1.classId, item2.classId, item3.classId, _target, _param);
552         
553         if (_token1 > 0) _burn(msg.sender, _token1);
554         if (_token2 > 0) _burn(msg.sender, _token2);
555         if (_token3 > 0) _burn(msg.sender, _token3);
556     }
557     
558     
559     // public read 
560     function getItemInfo(uint _tokenId) constant public returns(uint classId, uint value) {
561         Item storage item = items[_tokenId];
562         classId = item.classId;
563         value = item.value;
564     }
565 
566 }