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
467 contract CubegonNFT is NFTStandard("Cubegon", "CUBEGON"), BasicAccessControl {
468     struct CubegonData {
469         bytes32 hash;
470         uint mId1;
471         uint amount1;
472         uint mId2;
473         uint amount2;
474         uint mId3;
475         uint amount3;
476         uint mId4;
477         uint amount4;
478         uint energyLimit;
479     }
480     mapping (uint => CubegonData) public cubegons;
481     mapping (bytes32 => uint) public hashCubegons;
482     uint public totalCubegon = 0;
483     
484     event UpdateCubegon(address indexed _from, uint256 indexed _tokenId);
485     
486     function setTokenURI(uint256 _tokenId, string _uri) onlyModerators external {
487         _setTokenUri(_tokenId, _uri);
488     }
489     
490     function mineCubegon(address _owner, bytes32 _ch, uint _mId1, uint _amount1, uint _mId2, uint _amount2, 
491         uint _mId3, uint _amount3, uint _mId4, uint _amount4, uint _energyLimit) onlyModerators external returns(uint) {
492         if (hashCubegons[_ch] > 0) revert();
493         
494         totalCubegon += 1;
495         hashCubegons[_ch] = totalCubegon;
496         CubegonData storage cubegon = cubegons[totalCubegon];
497         cubegon.hash = _ch;
498         cubegon.mId1 = _mId1;
499         cubegon.amount1 = _amount1;
500         cubegon.mId2 = _mId2;
501         cubegon.amount2 = _amount2;
502         cubegon.mId3 = _mId3;
503         cubegon.amount3 = _amount3;
504         cubegon.mId4 = _mId4;
505         cubegon.amount4 = _amount4;
506         cubegon.energyLimit = _energyLimit;
507         _mint(_owner, totalCubegon);
508         return totalCubegon;
509     }
510     
511     function updateCubegon(address _owner, uint _tokenId, uint _energyLimit) onlyModerators external {
512         if (_tokenId == 0 || idToOwner[_tokenId] != _owner) revert();
513         CubegonData storage cubegon = cubegons[_tokenId];
514         if (cubegon.energyLimit == 0) revert();
515         cubegon.energyLimit = _energyLimit;
516     }
517     
518     function dismantleCubegon(address _owner, uint _tokenId) onlyModerators external returns(uint mId1, uint amount1, uint mId2, uint amount2,
519         uint mId3, uint amount3, uint mId4, uint amount4) {
520         if (_tokenId == 0 || idToOwner[_tokenId] != _owner) revert();
521         
522         CubegonData storage cubegon = cubegons[_tokenId];
523         cubegon.energyLimit = 0;
524         hashCubegons[cubegon.hash] = 0;
525         
526         _burn(_owner, _tokenId);
527         
528         return (cubegon.mId1, cubegon.amount1, cubegon.mId2, cubegon.amount2, cubegon.mId3, cubegon.amount3, cubegon.mId4, cubegon.amount4);
529     }
530     
531     // public
532     function getCubegonDataById(uint _tokenId) constant external returns(bytes32 hash, uint mId1, uint amount1, uint mId2, uint amount2,
533         uint mId3, uint amount3, uint mId4, uint amount4, uint energyLimit) {
534         CubegonData storage cubegon = cubegons[_tokenId];
535         hash = cubegon.hash;
536         mId1 = cubegon.mId1;
537         amount1 = cubegon.amount1;
538         mId2 = cubegon.mId2;
539         amount2 = cubegon.amount2;
540         mId3 = cubegon.mId3;
541         amount3 = cubegon.amount3;
542         mId4 = cubegon.mId4;
543         amount4 = cubegon.amount4;
544         energyLimit = cubegon.energyLimit;
545     }
546     
547     function getCubegonByHash(bytes32 _hash) constant external returns(uint tokenId, uint mId1, uint amount1, uint mId2, uint amount2,
548         uint mId3, uint amount3, uint mId4, uint amount4, uint energyLimit) {
549         tokenId = hashCubegons[_hash];
550         CubegonData storage cubegon = cubegons[tokenId];
551         mId1 = cubegon.mId1;
552         amount1 = cubegon.amount1;
553         mId2 = cubegon.mId2;
554         amount2 = cubegon.amount2;
555         mId3 = cubegon.mId3;
556         amount3 = cubegon.amount3;
557         mId4 = cubegon.mId4;
558         amount4 = cubegon.amount4;
559         energyLimit = cubegon.energyLimit;
560     }
561     
562     function getCubegonIdByHash(bytes32 _hash) constant external returns(uint) {
563         return hashCubegons[_hash];
564     }
565     
566     function getCubegonHashById(uint _tokenId) constant external returns(bytes32) {
567         if (idToOwner[_tokenId] == address(0))
568             return 0;
569         return cubegons[_tokenId].hash;
570     }
571 }