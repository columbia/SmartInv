1 pragma solidity ^0.4.23;
2 
3 interface ERC721 /* is ERC165 */ {
4    
5     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
6 
7     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
8     
9     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
10 
11     function balanceOf(address _owner) external view returns (uint256);
12 
13     function ownerOf(uint256 _tokenId) external view returns (address);
14 
15     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) payable;
16 
17     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
18 
19     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
20 
21     function approve(address _approved, uint256 _tokenId) external payable;
22 
23     function setApprovalForAll(address _operator, bool _approved) external;
24 
25     function getApproved(uint256 _tokenId) view returns (address);
26 
27     function isApprovedForAll(address _owner, address _operator) view returns (bool);
28 }
29 
30 interface ERC165 {
31    
32     function supportsInterface(bytes4 interfaceID) external view returns (bool);
33 }
34 
35 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
36 interface ERC721TokenReceiver {
37   
38     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
39 }
40 
41 interface ERC721Metadata /* is ERC721 */ {
42     
43     function name() external view returns (string _name);
44 
45     function symbol() external view returns (string _symbol);
46 
47     function tokenURI(uint256 _tokenId) external view returns (string);
48 }
49 
50 interface ERC721Enumerable /* is ERC721 */ {
51     
52     function totalSupply() external view returns (uint256);
53 
54     function tokenByIndex(uint256 _index) external view returns (uint256);
55 
56     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
57 }
58 
59 library Strings {
60     
61   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
62   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
63       bytes memory _ba = bytes(_a);
64       bytes memory _bb = bytes(_b);
65       bytes memory _bc = bytes(_c);
66       bytes memory _bd = bytes(_d);
67       bytes memory _be = bytes(_e);
68       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
69       bytes memory babcde = bytes(abcde);
70       uint k = 0;
71       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
72       for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
73       for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
74       for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
75       for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
76       return string(babcde);
77     }
78 
79     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
80         return strConcat(_a, _b, _c, _d, "");
81     }
82 
83     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
84         return strConcat(_a, _b, _c, "", "");
85     }
86 
87     function strConcat(string _a, string _b) internal pure returns (string) {
88         return strConcat(_a, _b, "", "", "");
89     }
90 
91     function uint2str(uint i) internal pure returns (string) {
92         if (i == 0) return "0";
93         uint j = i;
94         uint len;
95         while (j != 0){
96             len++;
97             j /= 10;
98         }
99         bytes memory bstr = new bytes(len);
100         uint k = len - 1;
101         while (i != 0){
102             bstr[k--] = byte(48 + i % 10);
103             i /= 10;
104         }
105         return string(bstr);
106     }
107 }
108 
109 library AddressUtils {
110 
111   /**
112    * Returns whether the target address is a contract
113    * @dev This function will return false if invoked during the constructor of a contract,
114    * as the code is not actually created until after the constructor finishes.
115    * @param addr address to check
116    * @return whether the target address is a contract
117    */
118     function isContract(address addr) internal view returns (bool) {
119         uint256 size;
120         // XXX Currently there is no better way to check if there is a contract in an address
121         // than to check the size of the code at that address.
122         // See https://ethereum.stackexchange.com/a/14016/36603
123         // for more details about how this works.
124         // TODO Check this again before the Serenity release, because all addresses will be
125         // contracts then.
126         // solium-disable-next-line security/no-inline-assembly
127         assembly { size := extcodesize(addr) }
128         return size > 0;
129     }
130 
131 }
132 
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
139     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
140     // benefit is lost if 'b' is also tested.
141     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142     if (a == 0) {
143       return 0;
144     }
145 
146     c = a * b;
147     assert(c / a == b);
148     return c;
149   }
150 
151   /**
152   * @dev Integer division of two numbers, truncating the quotient.
153   */
154   function div(uint256 a, uint256 b) internal pure returns (uint256) {
155     // assert(b > 0); // Solidity automatically throws when dividing by 0
156     // uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158     return a / b;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
163   */
164   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165     assert(b <= a);
166     return a - b;
167   }
168 
169   /**
170   * @dev Adds two numbers, throws on overflow.
171   */
172   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
173     c = a + b;
174     assert(c >= a);
175     return c;
176   }
177 }
178 
179 contract MyTokenBadgeFootStone is ERC721, ERC165 {
180 
181     bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
182     
183     bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
184 
185     bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
186     /*
187     * 0x80ac58cd ===
188     *   bytes4(keccak256('balanceOf(address)')) ^
189     *   bytes4(keccak256('ownerOf(uint256)')) ^
190     *   bytes4(keccak256('approve(address,uint256)')) ^
191     *   bytes4(keccak256('getApproved(uint256)')) ^
192     *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
193     *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
194     *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
195     *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
196     *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
197     */
198 
199     mapping(bytes4 => bool) internal supportedInterfaces;
200 
201     mapping (uint256 => address) internal tokenOwner;
202 
203     mapping(address => uint8[]) internal ownedTokens;
204 
205     mapping (uint256 => address) internal tokenApprovals;
206 
207     mapping (address => mapping (address => bool)) internal operatorApprovals;
208 
209     uint32[] ownedTokensIndex;
210 
211     using SafeMath for uint256;
212     using AddressUtils for address;
213     using Strings for string;
214 
215     constructor() public {
216         _registerInterface(InterfaceId_ERC165);
217         _registerInterface(InterfaceId_ERC721);
218     }
219 
220     function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
221         return supportedInterfaces[_interfaceId];
222     }
223 
224     function balanceOf(address _owner) view returns (uint256){
225         return ownedTokens[_owner].length;
226     }
227 
228     function ownerOf(uint256 _tokenId) public view returns (address) {
229         address owner = tokenOwner[_tokenId];
230         require(owner != address(0));
231         return owner;
232     }
233 
234     function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool){
235         address owner = ownerOf(_tokenId);
236         // Disable solium check because of
237         // https://github.com/duaraghav8/Solium/issues/175
238         // solium-disable-next-line operator-whitespace
239         return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
240     }
241 
242     modifier canTransfer(uint256 _tokenId) {
243         require(isApprovedOrOwner(msg.sender, _tokenId));
244         _;
245     }
246 
247     function transferFrom(address _from, address _to, uint256 _tokenId) payable canTransfer(_tokenId){
248         require(_from != address(0));
249         require(_to != address(0));
250 
251         clearApproval(_from, _tokenId);
252         removeTokenFrom(_from, _tokenId);
253         addTokenTo(_to, _tokenId);
254 
255         emit Transfer(_from, _to, _tokenId);
256     }
257 
258     function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool){
259         if (!_to.isContract()) {
260             return true;
261         }
262         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
263         return (retval == ERC721_RECEIVED);
264     }
265 
266     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) payable{
267         transferFrom(_from, _to, _tokenId);
268 
269         require(checkAndCallSafeTransfer(_from, _to, _tokenId, data));
270     }
271 
272     function safeTransferFrom(address _from, address _to, uint256 _tokenId) payable{
273         safeTransferFrom(_from, _to, _tokenId, "");
274     }
275 
276     function clearApproval(address _owner, uint256 _tokenId) internal {
277         require(ownerOf(_tokenId) == _owner);
278         if (tokenApprovals[_tokenId] != address(0)) {
279             tokenApprovals[_tokenId] = address(0);
280         }
281     }
282 
283     function removeTokenFrom(address _from, uint256 _tokenId) internal {
284         require(ownerOf(_tokenId) == _from);
285         tokenOwner[_tokenId] = address(0);
286 
287 
288         uint32 tokenIndex = ownedTokensIndex[_tokenId];
289         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
290         uint8 lastToken = ownedTokens[_from][lastTokenIndex];
291 
292         ownedTokens[_from][tokenIndex] = lastToken;
293         ownedTokens[_from][lastTokenIndex] = 0;
294 
295         ownedTokens[_from].length--;
296         ownedTokensIndex[_tokenId] = 0;
297         ownedTokensIndex[lastToken] = tokenIndex;
298     }
299 
300     function addTokenTo(address _to, uint256 _tokenId) internal {
301         require(tokenOwner[_tokenId] == address(0));
302         tokenOwner[_tokenId] = _to;
303 
304         uint256 length = ownedTokens[_to].length;
305         
306         require(length == uint32(length));
307         ownedTokens[_to].push(uint8(_tokenId));
308 
309         ownedTokensIndex[_tokenId] = uint32(length);
310     }
311 
312     function approve(address _approved, uint256 _tokenId) external payable{
313         address owner = ownerOf(_tokenId);
314         require(_approved != owner);
315         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
316 
317         tokenApprovals[_tokenId] = _approved;
318         emit Approval(owner, _approved, _tokenId);
319     }
320 
321     function setApprovalForAll(address _operator, bool _approved) external{
322         require(_operator != msg.sender);
323         operatorApprovals[msg.sender][_operator] = _approved;
324         emit ApprovalForAll(msg.sender, _operator, _approved);
325     }
326 
327     function getApproved(uint256 _tokenId) public view returns (address) {
328         return tokenApprovals[_tokenId];
329     }
330 
331     function isApprovedForAll(address _owner, address _operator) public view returns (bool){
332         return operatorApprovals[_owner][_operator];
333     }
334 
335     function _registerInterface(bytes4 _interfaceId) internal {
336         require(_interfaceId != 0xffffffff);
337         supportedInterfaces[_interfaceId] = true;
338     }
339 }
340 
341 contract ManagerContract {
342   address public owner;
343 
344   constructor() public {
345     owner = msg.sender;
346   }
347 
348   modifier restricted() {
349     if (msg.sender == owner) _;
350   }
351 
352   function upgrade(address new_address) public restricted {
353     owner = new_address;
354   }
355 }
356 
357 interface MetadataConverter {
358 
359     function tokenSLogoURI() view returns (string);
360     function tokenBLogoURI() view returns (string);
361     function tokenSLogoBGURI() view returns (string);
362     function tokenBLogoBGURI() view returns (string);
363 	function tokenBGURI() view returns (string);
364 	function tokenURI(uint256 _tokenId) view returns (string);	
365 	function name(uint256 _tokenId) view returns (string);
366 }
367 
368 
369 contract GenesisBadge is MyTokenBadgeFootStone, ManagerContract, ERC721Enumerable, ERC721Metadata {
370 
371 	bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
372     /**
373     * 0x780e9d63 ===
374     *   bytes4(keccak256('totalSupply()')) ^
375     *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
376     *   bytes4(keccak256('tokenByIndex(uint256)'))
377     */
378 
379     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
380     /**
381     * 0x5b5e139f ===
382     *   bytes4(keccak256('name()')) ^
383     *   bytes4(keccak256('symbol()')) ^
384     *   bytes4(keccak256('tokenURI(uint256)'))
385     */
386 
387 	string public constant NAME = "GenesisBadge";
388     string public constant SYMBOL = "GB";
389     uint total = 50;
390     MetadataConverter metadataURIConverter;
391 
392 	constructor() public {
393         _registerInterface(InterfaceId_ERC721Enumerable);
394         _registerInterface(InterfaceId_ERC721Metadata);
395 
396         tokenOwner[0] = owner;
397         tokenOwner[1] = owner;
398         tokenOwner[2] = owner;
399         tokenOwner[3] = owner;
400         tokenOwner[4] = owner;
401         tokenOwner[5] = owner;
402         tokenOwner[6] = owner;
403         tokenOwner[7] = owner;
404         tokenOwner[8] = owner;
405         tokenOwner[9] = owner;
406         tokenOwner[10] = owner;
407         tokenOwner[11] = owner;
408         tokenOwner[12] = owner;
409         tokenOwner[13] = owner;
410         tokenOwner[14] = owner;
411         tokenOwner[15] = owner;
412         tokenOwner[16] = owner;
413         tokenOwner[17] = owner;
414         tokenOwner[18] = owner;
415         tokenOwner[19] = owner;
416         tokenOwner[20] = owner;
417         tokenOwner[21] = owner;
418         tokenOwner[22] = owner;
419         tokenOwner[23] = owner;
420         tokenOwner[24] = owner;
421         tokenOwner[25] = owner;
422         tokenOwner[26] = owner;
423         tokenOwner[27] = owner;
424         tokenOwner[28] = owner;
425         tokenOwner[29] = owner;
426         tokenOwner[30] = owner;
427         tokenOwner[31] = owner;
428         tokenOwner[32] = owner;
429         tokenOwner[33] = owner;
430         tokenOwner[34] = owner;
431         tokenOwner[35] = owner;
432         tokenOwner[36] = owner;
433         tokenOwner[37] = owner;
434         tokenOwner[38] = owner;
435         tokenOwner[39] = owner;
436         tokenOwner[40] = owner;
437         tokenOwner[41] = owner;
438         tokenOwner[42] = owner;
439         tokenOwner[43] = owner;
440         tokenOwner[44] = owner;
441         tokenOwner[45] = owner;
442         tokenOwner[46] = owner;
443         tokenOwner[47] = owner;
444         tokenOwner[48] = owner;
445         tokenOwner[49] = owner;
446 
447         ownedTokens[owner].push(uint8(0));
448         ownedTokens[owner].push(uint8(1));
449         ownedTokens[owner].push(uint8(2));
450         ownedTokens[owner].push(uint8(3));
451         ownedTokens[owner].push(uint8(4));
452         ownedTokens[owner].push(uint8(5));
453         ownedTokens[owner].push(uint8(6));
454         ownedTokens[owner].push(uint8(7));
455         ownedTokens[owner].push(uint8(8));
456         ownedTokens[owner].push(uint8(9));
457         ownedTokens[owner].push(uint8(10));
458         ownedTokens[owner].push(uint8(11));
459         ownedTokens[owner].push(uint8(12));
460         ownedTokens[owner].push(uint8(13));
461         ownedTokens[owner].push(uint8(14));
462         ownedTokens[owner].push(uint8(15));
463         ownedTokens[owner].push(uint8(16));
464         ownedTokens[owner].push(uint8(17));
465         ownedTokens[owner].push(uint8(18));
466         ownedTokens[owner].push(uint8(19));
467         ownedTokens[owner].push(uint8(20));
468         ownedTokens[owner].push(uint8(21));
469         ownedTokens[owner].push(uint8(22));
470         ownedTokens[owner].push(uint8(23));
471         ownedTokens[owner].push(uint8(24));
472         ownedTokens[owner].push(uint8(25));
473         ownedTokens[owner].push(uint8(26));
474         ownedTokens[owner].push(uint8(27));
475         ownedTokens[owner].push(uint8(28));
476         ownedTokens[owner].push(uint8(29));
477         ownedTokens[owner].push(uint8(30));
478         ownedTokens[owner].push(uint8(31));
479         ownedTokens[owner].push(uint8(32));
480         ownedTokens[owner].push(uint8(33));
481         ownedTokens[owner].push(uint8(34));
482         ownedTokens[owner].push(uint8(35));
483         ownedTokens[owner].push(uint8(36));
484         ownedTokens[owner].push(uint8(37));
485         ownedTokens[owner].push(uint8(38));
486         ownedTokens[owner].push(uint8(39));
487         ownedTokens[owner].push(uint8(40));
488         ownedTokens[owner].push(uint8(41));
489         ownedTokens[owner].push(uint8(42));
490         ownedTokens[owner].push(uint8(43));
491         ownedTokens[owner].push(uint8(44));
492         ownedTokens[owner].push(uint8(45));
493         ownedTokens[owner].push(uint8(46));
494         ownedTokens[owner].push(uint8(47));
495         ownedTokens[owner].push(uint8(48));
496         ownedTokens[owner].push(uint8(49));
497 
498 		ownedTokensIndex.push(0);
499 		ownedTokensIndex.push(1);
500 		ownedTokensIndex.push(2);
501 		ownedTokensIndex.push(3);
502 		ownedTokensIndex.push(4);
503 		ownedTokensIndex.push(5);
504 		ownedTokensIndex.push(6);
505 		ownedTokensIndex.push(7);
506 		ownedTokensIndex.push(8);
507 		ownedTokensIndex.push(9);
508 		ownedTokensIndex.push(10);
509 		ownedTokensIndex.push(11);
510 		ownedTokensIndex.push(12);
511 		ownedTokensIndex.push(13);
512 		ownedTokensIndex.push(14);
513 		ownedTokensIndex.push(15);
514 		ownedTokensIndex.push(16);
515 		ownedTokensIndex.push(17);
516 		ownedTokensIndex.push(18);
517 		ownedTokensIndex.push(19);
518 		ownedTokensIndex.push(20);
519 		ownedTokensIndex.push(21);
520 		ownedTokensIndex.push(22);
521 		ownedTokensIndex.push(23);
522 		ownedTokensIndex.push(24);
523 		ownedTokensIndex.push(25);
524 		ownedTokensIndex.push(26);
525 		ownedTokensIndex.push(27);
526 		ownedTokensIndex.push(28);
527 		ownedTokensIndex.push(29);
528 		ownedTokensIndex.push(30);
529 		ownedTokensIndex.push(31);
530         ownedTokensIndex.push(32);
531         ownedTokensIndex.push(33);
532         ownedTokensIndex.push(34);
533         ownedTokensIndex.push(35);
534         ownedTokensIndex.push(36);
535         ownedTokensIndex.push(37);
536         ownedTokensIndex.push(38);
537         ownedTokensIndex.push(39);
538         ownedTokensIndex.push(40);
539         ownedTokensIndex.push(41);
540         ownedTokensIndex.push(42);
541         ownedTokensIndex.push(43);
542         ownedTokensIndex.push(44);
543         ownedTokensIndex.push(45);
544         ownedTokensIndex.push(46);
545         ownedTokensIndex.push(47);
546         ownedTokensIndex.push(48);
547         ownedTokensIndex.push(49);
548 
549     }
550 
551     function updateURIConverter (address _URIConverter) restricted {
552     	metadataURIConverter = MetadataConverter(_URIConverter);
553     }
554 
555     function name() external view returns (string){
556     	return NAME;
557     }
558 
559     function badgeName(uint256 _tokenId) external view returns (string){
560     	return Strings.strConcat(NAME, metadataURIConverter.name(_tokenId));
561     }
562 
563     function symbol() external view returns (string){
564     	return SYMBOL;
565     }
566 
567     function tokenURI(uint256 _tokenId) external view returns (string){
568     	return metadataURIConverter.tokenURI(_tokenId);
569     }
570 
571     function tokenSLogoURI() external view returns (string){
572         return metadataURIConverter.tokenSLogoURI();
573     }
574 
575     function tokenBLogoURI() external view returns (string){
576         return metadataURIConverter.tokenBLogoURI();
577     }
578 
579     function tokenSLogoBGURI() external view returns (string){
580         return metadataURIConverter.tokenSLogoBGURI();
581     }
582 
583     function tokenBLogoBGURI() external view returns (string){
584         return metadataURIConverter.tokenBLogoBGURI();
585     }
586 
587     function tokenBGURI() external view returns (string){
588         return metadataURIConverter.tokenBGURI();
589     }
590 
591     function totalSupply() view returns (uint256){
592     	return total;
593     }
594 
595     function tokenByIndex(uint256 _index) external view returns (uint256){
596     	require(_index < totalSupply());
597         return _index;
598     }
599 
600     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
601 		require(_index < balanceOf(_owner));
602         return ownedTokens[_owner][_index];
603     }
604 }