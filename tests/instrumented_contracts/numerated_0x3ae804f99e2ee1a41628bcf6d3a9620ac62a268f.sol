1 pragma solidity ^0.4.24;
2 
3 library Roles {
4     struct Role {
5         mapping (address => bool) bearer;
6     }
7     function add(Role storage role, address account) internal {
8         require(account != address(0));
9         role.bearer[account] = true;
10     }
11     function remove(Role storage role, address account) internal {
12         require(account != address(0));
13         role.bearer[account] = false;
14     }
15     function has(Role storage role, address account)
16         internal
17         view
18         returns (bool)
19     {
20         require(account != address(0));
21         return role.bearer[account];
22     }
23 }
24 contract MinterRole {
25     using Roles for Roles.Role;
26 
27     event MinterAdded(address indexed account);
28     event MinterRemoved(address indexed account);
29 
30     Roles.Role private minters;
31 
32     constructor() public {
33         minters.add(msg.sender);
34     }
35 
36     modifier onlyMinter() {
37         require(isMinter(msg.sender));
38         _;
39     }
40 
41     function isMinter(address account) public view returns (bool) {
42         return minters.has(account);
43     }
44 
45     function addMinter(address account) public onlyMinter {
46         minters.add(account);
47         emit MinterAdded(account);
48     }
49 
50     function renounceMinter() public {
51         minters.remove(msg.sender);
52     }
53 
54     function _removeMinter(address account) internal {
55         minters.remove(account);
56         emit MinterRemoved(account);
57     }
58 }
59 library SafeMath {
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (a == 0) {
62         return 0;
63         }
64 
65         uint256 c = a * b;
66         require(c / a == b);
67 
68         return c;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b > 0);
73         uint256 c = a / b;
74     
75         return c;
76     }
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b <= a);
79         uint256 c = a - b;
80 
81         return c;
82     }
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a);
86 
87         return c;
88     }
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 library Address {
95     function isContract(address account) internal view returns (bool) {
96         uint256 size;
97         assembly { size := extcodesize(account) }
98         return size > 0;
99     }
100 }
101 interface IERC165 {
102     function supportsInterface(bytes4 interfaceId)
103         external
104         view
105         returns (bool);
106 }
107 contract ERC165 is IERC165 {
108     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
109     mapping(bytes4 => bool) internal _supportedInterfaces;
110     constructor()
111         public
112     {
113         _registerInterface(_InterfaceId_ERC165);
114     }
115     function supportsInterface(bytes4 interfaceId)
116         external
117         view
118         returns (bool)
119     {
120         return _supportedInterfaces[interfaceId];
121     }
122     function _registerInterface(bytes4 interfaceId)
123         internal
124     {
125         require(interfaceId != 0xffffffff);
126         _supportedInterfaces[interfaceId] = true;
127     }
128 }
129 contract IERC721 is IERC165 {
130     event Transfer(
131         address indexed from,
132         address indexed to,
133         uint256 indexed tokenId
134     );
135     event Approval(
136         address indexed owner,
137         address indexed approved,
138         uint256 indexed tokenId
139     );
140     event ApprovalForAll(
141         address indexed owner,
142         address indexed operator,
143         bool approved
144     );
145 
146     function balanceOf(address owner) public view returns (uint256 balance);
147     function ownerOf(uint256 tokenId) public view returns (address owner);
148 
149     function approve(address to, uint256 tokenId) public;
150     function getApproved(uint256 tokenId)
151         public view returns (address operator);
152 
153     function setApprovalForAll(address operator, bool _approved) public;
154     function isApprovedForAll(address owner, address operator)
155         public view returns (bool);
156 
157     function transferFrom(address from, address to, uint256 tokenId) public;
158     function safeTransferFrom(address from, address to, uint256 tokenId)
159         public;
160 
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes data
166     )
167         public;
168 }
169 contract IERC721Enumerable is IERC721 {
170     function totalSupply() public view returns (uint256);
171     function tokenOfOwnerByIndex(
172         address owner,
173         uint256 index
174     )
175         public
176         view
177         returns (uint256 tokenId);
178 
179     function tokenByIndex(uint256 index) public view returns (uint256);
180 }
181 contract IERC721Metadata is IERC721 {
182     function name() external view returns (string);
183     function symbol() external view returns (string);
184     function tokenURI(uint256 tokenId) public view returns (string);
185 }
186 contract IERC721Receiver {
187     function onERC721Received(
188         address operator,
189         address from,
190         uint256 tokenId,
191         bytes data
192     )
193         public
194         returns(bytes4);
195 }
196 contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
197 }
198 contract ERC721 is ERC165, IERC721 {
199     using SafeMath for uint256;
200     using Address for address;
201 
202     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
203 
204     mapping (uint256 => address) private _tokenOwner;
205 
206     mapping (uint256 => address) private _tokenApprovals;
207 
208     mapping (address => uint256) private _ownedTokensCount;
209 
210     mapping (address => mapping (address => bool)) private _operatorApprovals;
211 
212     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
213 
214     constructor()
215         public
216     {
217         _registerInterface(_InterfaceId_ERC721);
218     }
219 
220     function balanceOf(address owner) public view returns (uint256) {
221         require(owner != address(0));
222         return _ownedTokensCount[owner];
223     }
224 
225     function ownerOf(uint256 tokenId) public view returns (address) {
226         address owner = _tokenOwner[tokenId];
227         require(owner != address(0));
228         return owner;
229     }
230 
231     function approve(address to, uint256 tokenId) public {
232         address owner = ownerOf(tokenId);
233         require(to != owner);
234         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
235 
236         _tokenApprovals[tokenId] = to;
237         emit Approval(owner, to, tokenId);
238     }
239 
240     function getApproved(uint256 tokenId) public view returns (address) {
241         require(_exists(tokenId));
242         return _tokenApprovals[tokenId];
243     }
244 
245     function setApprovalForAll(address to, bool approved) public {
246         require(to != msg.sender);
247         _operatorApprovals[msg.sender][to] = approved;
248         emit ApprovalForAll(msg.sender, to, approved);
249     }
250 
251     function isApprovedForAll(
252         address owner,
253         address operator
254     )
255         public
256         view
257         returns (bool)
258     {
259         return _operatorApprovals[owner][operator];
260     }
261 
262     function transferFrom(
263         address from,
264         address to,
265         uint256 tokenId
266     )
267         public
268     {
269         require(_isApprovedOrOwner(msg.sender, tokenId));
270         require(to != address(0));
271 
272         _clearApproval(from, tokenId);
273         _removeTokenFrom(from, tokenId);
274         _addTokenTo(to, tokenId);
275 
276         emit Transfer(from, to, tokenId);
277     }
278 
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId
283     )
284         public
285     {
286         safeTransferFrom(from, to, tokenId, "");
287     }
288 
289     function safeTransferFrom(
290         address from,
291         address to,
292         uint256 tokenId,
293         bytes _data
294     )
295         public
296     {
297         transferFrom(from, to, tokenId);
298         require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
299     }
300 
301     function _exists(uint256 tokenId) internal view returns (bool) {
302         address owner = _tokenOwner[tokenId];
303         return owner != address(0);
304     }
305 
306     function _isApprovedOrOwner(
307         address spender,
308         uint256 tokenId
309     )
310         internal
311         view
312         returns (bool)
313     {
314         address owner = ownerOf(tokenId);
315         return (
316         spender == owner ||
317         getApproved(tokenId) == spender ||
318         isApprovedForAll(owner, spender)
319         );
320     }
321 
322     function _mint(address to, uint256 tokenId) internal {
323         require(to != address(0));
324         _addTokenTo(to, tokenId);
325         emit Transfer(address(0), to, tokenId);
326     }
327 
328     function _burn(address owner, uint256 tokenId) internal {
329         _clearApproval(owner, tokenId);
330         _removeTokenFrom(owner, tokenId);
331         emit Transfer(owner, address(0), tokenId);
332     }
333 
334     function _clearApproval(address owner, uint256 tokenId) internal {
335         require(ownerOf(tokenId) == owner);
336         if (_tokenApprovals[tokenId] != address(0)) {
337         _tokenApprovals[tokenId] = address(0);
338         }
339     }
340 
341     function _addTokenTo(address to, uint256 tokenId) internal {
342         require(_tokenOwner[tokenId] == address(0));
343         _tokenOwner[tokenId] = to;
344         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
345     }
346 
347     function _removeTokenFrom(address from, uint256 tokenId) internal {
348         require(ownerOf(tokenId) == from);
349         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
350         _tokenOwner[tokenId] = address(0);
351     }
352 
353     function _checkAndCallSafeTransfer(
354         address from,
355         address to,
356         uint256 tokenId,
357         bytes _data
358     )
359         internal
360         returns (bool)
361     {
362         if (!to.isContract()) {
363         return true;
364         }
365         bytes4 retval = IERC721Receiver(to).onERC721Received(
366         msg.sender, from, tokenId, _data);
367         return (retval == _ERC721_RECEIVED);
368     }
369 }
370 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
371     string internal _name;
372 
373     string internal _symbol;
374 
375     mapping(uint256 => string) private _tokenURIs;
376 
377     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
378 
379     constructor(string name, string symbol) public {
380         _name = name;
381         _symbol = symbol;
382 
383         _registerInterface(InterfaceId_ERC721Metadata);
384     }
385 
386     function name() external view returns (string) {
387         return _name;
388     }
389 
390     function symbol() external view returns (string) {
391         return _symbol;
392     }
393 
394     function tokenURI(uint256 tokenId) public view returns (string) {
395         require(_exists(tokenId));
396         return _tokenURIs[tokenId];
397     }
398 
399     function _setTokenURI(uint256 tokenId, string uri) internal {
400         require(_exists(tokenId));
401         _tokenURIs[tokenId] = uri;
402     }
403 
404     function _burn(address owner, uint256 tokenId) internal {
405         super._burn(owner, tokenId);
406 
407         if (bytes(_tokenURIs[tokenId]).length != 0) {
408         delete _tokenURIs[tokenId];
409         }
410     }
411 }
412 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
413     mapping(address => uint256[]) private _ownedTokens;
414 
415     mapping(uint256 => uint256) private _ownedTokensIndex;
416 
417     uint256[] private _allTokens;
418 
419     mapping(uint256 => uint256) private _allTokensIndex;
420 
421     bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
422 
423     constructor() public {
424         _registerInterface(_InterfaceId_ERC721Enumerable);
425     }
426 
427     function tokenOfOwnerByIndex(
428         address owner,
429         uint256 index
430     )
431         public
432         view
433         returns (uint256)
434     {
435         require(index < balanceOf(owner));
436         return _ownedTokens[owner][index];
437     }
438 
439     function totalSupply() public view returns (uint256) {
440         return _allTokens.length;
441     }
442 
443     function tokenByIndex(uint256 index) public view returns (uint256) {
444         require(index < totalSupply());
445         return _allTokens[index];
446     }
447 
448     function _addTokenTo(address to, uint256 tokenId) internal {
449         super._addTokenTo(to, tokenId);
450         uint256 length = _ownedTokens[to].length;
451         _ownedTokens[to].push(tokenId);
452         _ownedTokensIndex[tokenId] = length;
453     }
454 
455     function _removeTokenFrom(address from, uint256 tokenId) internal {
456         super._removeTokenFrom(from, tokenId);
457 
458         uint256 tokenIndex = _ownedTokensIndex[tokenId];
459         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
460         uint256 lastToken = _ownedTokens[from][lastTokenIndex];
461 
462         _ownedTokens[from][tokenIndex] = lastToken;
463         _ownedTokens[from].length--;
464 
465         _ownedTokensIndex[tokenId] = 0;
466         _ownedTokensIndex[lastToken] = tokenIndex;
467     }
468 
469     function _mint(address to, uint256 tokenId) internal {
470         super._mint(to, tokenId);
471 
472         _allTokensIndex[tokenId] = _allTokens.length;
473         _allTokens.push(tokenId);
474     }
475 
476     function _burn(address owner, uint256 tokenId) internal {
477         super._burn(owner, tokenId);
478 
479         uint256 tokenIndex = _allTokensIndex[tokenId];
480         uint256 lastTokenIndex = _allTokens.length.sub(1);
481         uint256 lastToken = _allTokens[lastTokenIndex];
482 
483         _allTokens[tokenIndex] = lastToken;
484         _allTokens[lastTokenIndex] = 0;
485 
486         _allTokens.length--;
487         _allTokensIndex[tokenId] = 0;
488         _allTokensIndex[lastToken] = tokenIndex;
489     }
490 }
491 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
492     constructor(string name, string symbol) ERC721Metadata(name, symbol)
493         public
494     {
495     }
496 }
497 contract ERC721Mintable is ERC721Full, MinterRole {
498     event MintingFinished();
499 
500     bool private _mintingFinished = false;
501 
502     modifier onlyBeforeMintingFinished() {
503         require(!_mintingFinished);
504         _;
505     }
506 
507     function mintingFinished() public view returns(bool) {
508         return _mintingFinished;
509     }
510 
511     function mint(
512         address to,
513         uint256 tokenId
514     )
515         public
516         onlyMinter
517         onlyBeforeMintingFinished
518         returns (bool)
519     {
520         _mint(to, tokenId);
521         return true;
522     }
523 
524     function mintWithTokenURI(
525         address to,
526         uint256 tokenId,
527         string tokenURI
528     )
529         public
530         onlyMinter
531         onlyBeforeMintingFinished
532         returns (bool)
533     {
534         mint(to, tokenId);
535         _setTokenURI(tokenId, tokenURI);
536         return true;
537     }
538 
539     function finishMinting()
540         public
541         onlyMinter
542         onlyBeforeMintingFinished
543         returns (bool)
544     {
545         _mintingFinished = true;
546         emit MintingFinished();
547         return true;
548     }
549 }
550 contract ERC721Burnable is ERC721 {
551     function burn(uint256 tokenId)
552         public
553     {
554         require(_isApprovedOrOwner(msg.sender, tokenId));
555         _burn(ownerOf(tokenId), tokenId);
556     }
557 }
558 contract ERC721Contract is ERC721Full, ERC721Mintable, ERC721Burnable {
559     constructor(string name, string symbol) public
560         ERC721Mintable()
561         ERC721Full(name, symbol)
562     {}
563 
564     function exists(uint256 tokenId) public view returns (bool) {
565         return _exists(tokenId);
566     }
567 
568     function setTokenURI(uint256 tokenId, string uri) public {
569         _setTokenURI(tokenId, uri);
570     }
571 
572     function removeTokenFrom(address from, uint256 tokenId) public {
573         _removeTokenFrom(from, tokenId);
574     }
575 }
576 contract ERC721Constructor {
577     event newERC721(address contractAddress, string name, string symbol, address owner);
578 
579     function CreateAdminERC721(string name, string symbol, address owner) public {
580         ERC721Contract ERC721Construct = new ERC721Contract(name, symbol);
581         ERC721Construct.addMinter(owner);
582         ERC721Construct.renounceMinter();
583         emit newERC721(address(ERC721Construct), name, symbol, owner);
584     }
585 }