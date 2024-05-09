1 pragma solidity ^0.4.24;
2 
3 
4 interface ERC165 {
5 
6   function supportsInterface(bytes4 _interfaceId)
7     external
8     view
9     returns (bool);
10 }
11 
12 
13 
14 contract SupportsInterfaceWithLookup is ERC165 {
15   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
16 
17   mapping(bytes4 => bool) internal supportedInterfaces;
18 
19   constructor()
20     public
21   {
22     _registerInterface(InterfaceId_ERC165);
23   }
24 
25   function supportsInterface(bytes4 _interfaceId)
26     external
27     view
28     returns (bool)
29   {
30     return supportedInterfaces[_interfaceId];
31   }
32 
33   function _registerInterface(bytes4 _interfaceId)
34     internal
35   {
36     require(_interfaceId != 0xffffffff);
37     supportedInterfaces[_interfaceId] = true;
38   }
39 }
40 
41 
42 contract ERC721Basic is ERC165 {
43 
44   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
45 
46   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
47 
48   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
49 
50   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
51 
52   event Transfer(
53     address indexed _from,
54     address indexed _to,
55     uint256 indexed _tokenId
56   );
57   event Approval(
58     address indexed _owner,
59     address indexed _approved,
60     uint256 indexed _tokenId
61   );
62   event ApprovalForAll(
63     address indexed _owner,
64     address indexed _operator,
65     bool _approved
66   );
67 
68   function balanceOf(address _owner) public view returns (uint256 _balance);
69   function ownerOf(uint256 _tokenId) public view returns (address _owner);
70   function exists(uint256 _tokenId) public view returns (bool _exists);
71 
72   function approve(address _to, uint256 _tokenId) public;
73   function getApproved(uint256 _tokenId)
74     public view returns (address _operator);
75 
76   function setApprovalForAll(address _operator, bool _approved) public;
77   function isApprovedForAll(address _owner, address _operator)
78     public view returns (bool);
79 
80   function transferFrom(address _from, address _to, uint256 _tokenId) public;
81   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
82     public;
83 
84   function safeTransferFrom(
85     address _from,
86     address _to,
87     uint256 _tokenId,
88     bytes _data
89   )
90     public;
91 }
92 
93 
94 
95 contract ERC721Enumerable is ERC721Basic {
96   function totalSupply() public view returns (uint256);
97   function tokenOfOwnerByIndex(
98     address _owner,
99     uint256 _index
100   )
101     public
102     view
103     returns (uint256 _tokenId);
104 
105   function tokenByIndex(uint256 _index) public view returns (uint256);
106 }
107 
108 
109 contract ERC721Metadata is ERC721Basic {
110   function name() external view returns (string _name);
111   function symbol() external view returns (string _symbol);
112   function tokenURI(uint256 _tokenId) public view returns (string);
113 }
114 
115 
116 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
117 }
118 
119 
120 
121 
122 contract ERC721Receiver {
123 
124   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
125 
126   function onERC721Received(
127     address _operator,
128     address _from,
129     uint256 _tokenId,
130     bytes _data
131   )
132     public
133     returns(bytes4);
134 }
135 
136 
137 
138 library SafeMath {
139 
140   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
141 
142     if (a == 0) {
143       return 0;
144     }
145 
146     c = a * b;
147     assert(c / a == b);
148     return c;
149   }
150 
151   function div(uint256 a, uint256 b) internal pure returns (uint256) {
152 
153     return a / b;
154   }
155 
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
162     c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 
169 library AddressUtils {
170 
171 
172   function isContract(address addr) internal view returns (bool) {
173     uint256 size;
174     assembly { size := extcodesize(addr) }
175     return size > 0;
176   }
177 
178 }
179 
180 
181 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
182 
183   using SafeMath for uint256;
184   using AddressUtils for address;
185 
186   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
187 
188   mapping (uint256 => address) internal tokenOwner;
189   mapping (uint256 => address) internal tokenApprovals;
190   mapping (address => uint256) internal ownedTokensCount;
191   mapping (address => mapping (address => bool)) internal operatorApprovals;
192 
193   constructor()
194     public
195   {
196     _registerInterface(InterfaceId_ERC721);
197     _registerInterface(InterfaceId_ERC721Exists);
198   }
199 
200   function balanceOf(address _owner) public view returns (uint256) {
201     require(_owner != address(0));
202     return ownedTokensCount[_owner];
203   }
204 
205   function ownerOf(uint256 _tokenId) public view returns (address) {
206     address owner = tokenOwner[_tokenId];
207     require(owner != address(0));
208     return owner;
209   }
210 
211   function exists(uint256 _tokenId) public view returns (bool) {
212     address owner = tokenOwner[_tokenId];
213     return owner != address(0);
214   }
215 
216   function approve(address _to, uint256 _tokenId) public {
217     address owner = ownerOf(_tokenId);
218     require(_to != owner);
219     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
220 
221     tokenApprovals[_tokenId] = _to;
222     emit Approval(owner, _to, _tokenId);
223   }
224 
225   function getApproved(uint256 _tokenId) public view returns (address) {
226     return tokenApprovals[_tokenId];
227   }
228 
229   function setApprovalForAll(address _to, bool _approved) public {
230     require(_to != msg.sender);
231     operatorApprovals[msg.sender][_to] = _approved;
232     emit ApprovalForAll(msg.sender, _to, _approved);
233   }
234 
235   function isApprovedForAll(
236     address _owner,
237     address _operator
238   )
239     public
240     view
241     returns (bool)
242   {
243     return operatorApprovals[_owner][_operator];
244   }
245 
246   function transferFrom(
247     address _from,
248     address _to,
249     uint256 _tokenId
250   )
251     public
252   {
253     require(isApprovedOrOwner(msg.sender, _tokenId));
254     require(_from != address(0));
255     require(_to != address(0));
256 
257     clearApproval(_from, _tokenId);
258     removeTokenFrom(_from, _tokenId);
259     addTokenTo(_to, _tokenId);
260 
261     emit Transfer(_from, _to, _tokenId);
262   }
263 
264   function safeTransferFrom(
265     address _from,
266     address _to,
267     uint256 _tokenId
268   )
269     public
270   {
271     // solium-disable-next-line arg-overflow
272     safeTransferFrom(_from, _to, _tokenId, "");
273   }
274 
275   function safeTransferFrom(
276     address _from,
277     address _to,
278     uint256 _tokenId,
279     bytes _data
280   )
281     public
282   {
283     transferFrom(_from, _to, _tokenId);
284     // solium-disable-next-line arg-overflow
285     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
286   }
287 
288   function isApprovedOrOwner(
289     address _spender,
290     uint256 _tokenId
291   )
292     internal
293     view
294     returns (bool)
295   {
296     address owner = ownerOf(_tokenId);
297     return (
298       _spender == owner ||
299       getApproved(_tokenId) == _spender ||
300       isApprovedForAll(owner, _spender)
301     );
302   }
303 
304 
305   function _mint(address _to, uint256 _tokenId) internal {
306     require(_to != address(0));
307     addTokenTo(_to, _tokenId);
308     emit Transfer(address(0), _to, _tokenId);
309   }
310 
311   function _burn(address _owner, uint256 _tokenId) internal {
312     clearApproval(_owner, _tokenId);
313     removeTokenFrom(_owner, _tokenId);
314     emit Transfer(_owner, address(0), _tokenId);
315   }
316 
317   function clearApproval(address _owner, uint256 _tokenId) internal {
318     require(ownerOf(_tokenId) == _owner);
319     if (tokenApprovals[_tokenId] != address(0)) {
320       tokenApprovals[_tokenId] = address(0);
321     }
322   }
323 
324   function addTokenTo(address _to, uint256 _tokenId) internal {
325     require(tokenOwner[_tokenId] == address(0));
326     tokenOwner[_tokenId] = _to;
327     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
328   }
329 
330   function removeTokenFrom(address _from, uint256 _tokenId) internal {
331     require(ownerOf(_tokenId) == _from);
332     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
333     tokenOwner[_tokenId] = address(0);
334   }
335 
336   function checkAndCallSafeTransfer(
337     address _from,
338     address _to,
339     uint256 _tokenId,
340     bytes _data
341   )
342     internal
343     returns (bool)
344   {
345     if (!_to.isContract()) {
346       return true;
347     }
348     bytes4 retval = ERC721Receiver(_to).onERC721Received(
349       msg.sender, _from, _tokenId, _data);
350     return (retval == ERC721_RECEIVED);
351   }
352 }
353 
354 
355 
356 
357 
358 
359 
360 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
361 
362   // Token name
363   string internal name_;
364 
365   // Token symbol
366   string internal symbol_;
367 
368   // Mapping from owner to list of owned token IDs
369   mapping(address => uint256[]) internal ownedTokens;
370 
371   // Mapping from token ID to index of the owner tokens list
372   mapping(uint256 => uint256) internal ownedTokensIndex;
373 
374   // Array with all token ids, used for enumeration
375   uint256[] internal allTokens;
376 
377   // Mapping from token id to position in the allTokens array
378   mapping(uint256 => uint256) internal allTokensIndex;
379 
380   // Optional mapping for token URIs
381   mapping(uint256 => string) internal tokenURIs;
382 
383   constructor(string _name, string _symbol) public {
384     name_ = _name;
385     symbol_ = _symbol;
386 
387     // register the supported interfaces to conform to ERC721 via ERC165
388     _registerInterface(InterfaceId_ERC721Enumerable);
389     _registerInterface(InterfaceId_ERC721Metadata);
390   }
391 
392   function name() external view returns (string) {
393     return name_;
394   }
395 
396   function symbol() external view returns (string) {
397     return symbol_;
398   }
399 
400   function tokenURI(uint256 _tokenId) public view returns (string) {
401     require(exists(_tokenId));
402     return tokenURIs[_tokenId];
403   }
404 
405   function tokenOfOwnerByIndex(
406     address _owner,
407     uint256 _index
408   )
409     public
410     view
411     returns (uint256)
412   {
413     require(_index < balanceOf(_owner));
414     return ownedTokens[_owner][_index];
415   }
416 
417   function totalSupply() public view returns (uint256) {
418     return allTokens.length;
419   }
420 
421   function tokenByIndex(uint256 _index) public view returns (uint256) {
422     require(_index < totalSupply());
423     return allTokens[_index];
424   }
425 
426 
427   function _setTokenURI(uint256 _tokenId, string _uri) internal {
428     require(exists(_tokenId));
429     tokenURIs[_tokenId] = _uri;
430   }
431 
432 
433   function addTokenTo(address _to, uint256 _tokenId) internal {
434     super.addTokenTo(_to, _tokenId);
435     uint256 length = ownedTokens[_to].length;
436     ownedTokens[_to].push(_tokenId);
437     ownedTokensIndex[_tokenId] = length;
438   }
439 
440 
441   function removeTokenFrom(address _from, uint256 _tokenId) internal {
442     super.removeTokenFrom(_from, _tokenId);
443 
444     uint256 tokenIndex = ownedTokensIndex[_tokenId];
445     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
446     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
447 
448     ownedTokens[_from][tokenIndex] = lastToken;
449     ownedTokens[_from].length--; // This also deletes the contents at the last position of the array
450 
451     ownedTokensIndex[_tokenId] = 0;
452     ownedTokensIndex[lastToken] = tokenIndex;
453   }
454 
455 
456   function _mint(address _to, uint256 _tokenId) internal {
457     super._mint(_to, _tokenId);
458 
459     allTokensIndex[_tokenId] = allTokens.length;
460     allTokens.push(_tokenId);
461   }
462 
463 
464   function _burn(address _owner, uint256 _tokenId) internal {
465     super._burn(_owner, _tokenId);
466 
467     if (bytes(tokenURIs[_tokenId]).length != 0) {
468       delete tokenURIs[_tokenId];
469     }
470 
471     uint256 tokenIndex = allTokensIndex[_tokenId];
472     uint256 lastTokenIndex = allTokens.length.sub(1);
473     uint256 lastToken = allTokens[lastTokenIndex];
474 
475     allTokens[tokenIndex] = lastToken;
476     allTokens[lastTokenIndex] = 0;
477 
478     allTokens.length--;
479     allTokensIndex[_tokenId] = 0;
480     allTokensIndex[lastToken] = tokenIndex;
481   }
482 
483 }
484 
485 
486 contract LetterToken350 is ERC721Token {
487 
488   constructor() public ERC721Token("LetterToken350","LetterToken350") { }
489 
490   struct Token{
491     string GameID;
492     string FortuneCookie;
493     string Letter;
494     uint256 Amt;
495   }
496 
497   Token[] private tokens;
498 
499   
500   function create(address paid1, address paid2, address paid3, address paid4, address paid5, address paid6, address paid7, string GameID, string FortuneCookie, string Letter, string tokenuri) public payable returns (uint256 _tokenId) {
501 
502 
503     uint256  Amt=msg.value/7;
504     paid1.transfer(Amt);
505     paid2.transfer(Amt);
506     paid3.transfer(Amt);
507     paid4.transfer(Amt);
508     paid5.transfer(Amt);
509     paid6.transfer(Amt);
510     paid7.transfer(Amt);
511 
512     //Add The Token	
513     Token memory _newToken = Token({
514 	    GameID: GameID,
515         FortuneCookie: FortuneCookie,
516         Letter: Letter,
517 	    Amt: Amt
518     });
519     _tokenId = tokens.push(_newToken) - 1;
520     
521     _mint(msg.sender,_tokenId);
522     _setTokenURI(_tokenId, tokenuri);
523 
524     
525     //Emit The Token
526     emit Create(_tokenId,msg.sender,Amt,GameID,FortuneCookie,Letter,tokenuri);
527     return _tokenId;
528   }
529 
530   event Create(
531     uint _id,
532     address indexed _owner,uint256 amt, string GameID, 
533     string FortuneCookie,
534     string Letter,
535     string tokenUri
536   );
537 
538   function get(uint256 _id) public view returns (address owner,string Letter,string GameID,string FortuneCookie) {
539     return (
540     
541       tokenOwner[_id],
542       tokens[_id].Letter,
543       tokens[_id].GameID,
544       tokens[_id].FortuneCookie
545     );
546   }
547 
548   function tokensOfOwner(address _owner) public view returns(uint256[]) {
549     return ownedTokens[_owner];
550   }
551 
552 
553 
554 }