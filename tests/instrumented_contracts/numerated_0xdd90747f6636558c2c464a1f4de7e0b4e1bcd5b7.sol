1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.5.16;
4 
5 interface IERC165 {
6     function supportsInterface(bytes4 interfaceId) external view returns (bool);
7 }
8 
9 pragma solidity ^0.5.16;
10 
11 contract IERC721 is IERC165 {
12     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
13     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
14     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
15 
16     function balanceOf(address owner) public view returns (uint256 balance);
17     function ownerOf(uint256 tokenId) public view returns (address owner);
18     function approve(address to, uint256 tokenId) public;
19     function getApproved(uint256 tokenId) public view returns (address operator);
20     function setApprovalForAll(address operator, bool _approved) public;
21     function isApprovedForAll(address owner, address operator) public view returns (bool);
22     function transferFrom(address from, address to, uint256 tokenId) public;
23     function safeTransferFrom(address from, address to, uint256 tokenId) public;
24     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
25 }
26 
27 pragma solidity ^0.5.16;
28 
29 contract IERC721Receiver {
30     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
31     public returns (bytes4);
32 }
33 
34 pragma solidity ^0.5.16;
35 
36 library SafeMath {
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b);
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b > 0);
48         uint256 c = a / b;
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b <= a);
54         uint256 c = a - b;
55         return c;
56     }
57 
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 pragma solidity ^0.5.16;
71 
72 library Address {
73     function isContract(address account) internal view returns (bool) {
74         uint256 size;
75         assembly { size := extcodesize(account) }
76         return size > 0;
77     }
78 }
79 
80 pragma solidity ^0.5.16;
81 
82 contract ERC165 is IERC165 {
83     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
84     mapping(bytes4 => bool) private _supportedInterfaces;
85 
86     constructor () internal {
87         _registerInterface(_INTERFACE_ID_ERC165);
88     }
89 
90     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
91         return _supportedInterfaces[interfaceId];
92     }
93 
94     function _registerInterface(bytes4 interfaceId) internal {
95         require(interfaceId != 0xffffffff);
96         _supportedInterfaces[interfaceId] = true;
97     }
98 }
99 
100 pragma solidity ^0.5.16;
101 
102 contract ERC721 is ERC165, IERC721 {
103     using SafeMath for uint256;
104     using Address for address;
105 
106     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
107     mapping (uint256 => address) private _tokenOwner;
108     mapping (uint256 => address) private _tokenApprovals;
109     mapping (address => uint256) private _ownedTokensCount;
110     mapping (address => mapping (address => bool)) private _operatorApprovals;
111     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
112 
113     constructor () public {
114         _registerInterface(_INTERFACE_ID_ERC721);
115     }
116 
117     function balanceOf(address owner) public view returns (uint256) {
118         require(owner != address(0));
119         return _ownedTokensCount[owner];
120     }
121 
122     function ownerOf(uint256 tokenId) public view returns (address) {
123         address owner = _tokenOwner[tokenId];
124         require(owner != address(0));
125         return owner;
126     }
127 
128     function approve(address to, uint256 tokenId) public {
129         address owner = ownerOf(tokenId);
130         require(to != owner);
131         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
132 
133         _tokenApprovals[tokenId] = to;
134         emit Approval(owner, to, tokenId);
135     }
136 
137     function getApproved(uint256 tokenId) public view returns (address) {
138         require(_exists(tokenId));
139         return _tokenApprovals[tokenId];
140     }
141 
142     function setApprovalForAll(address to, bool approved) public {
143         require(to != msg.sender);
144         _operatorApprovals[msg.sender][to] = approved;
145         emit ApprovalForAll(msg.sender, to, approved);
146     }
147 
148     function isApprovedForAll(address owner, address operator) public view returns (bool) {
149         return _operatorApprovals[owner][operator];
150     }
151 
152     function transferFrom(address from, address to, uint256 tokenId) public {
153         require(_isApprovedOrOwner(msg.sender, tokenId));
154         _transferFrom(from, to, tokenId);
155     }
156 
157     function safeTransferFrom(address from, address to, uint256 tokenId) public {
158         safeTransferFrom(from, to, tokenId, "");
159     }
160 
161     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
162         transferFrom(from, to, tokenId);
163         require(_checkOnERC721Received(from, to, tokenId, _data));
164     }
165 
166     function _exists(uint256 tokenId) internal view returns (bool) {
167         address owner = _tokenOwner[tokenId];
168         return owner != address(0);
169     }
170 
171     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
172         address owner = ownerOf(tokenId);
173         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
174     }
175 
176     function _mint(address to, uint256 tokenId) internal {
177         require(to != address(0));
178         require(!_exists(tokenId));
179 
180         _tokenOwner[tokenId] = to;
181         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
182 
183         emit Transfer(address(0), to, tokenId);
184     }
185 
186     function _transferFrom(address from, address to, uint256 tokenId) internal {
187         require(ownerOf(tokenId) == from);
188         require(to != address(0));
189 
190         _clearApproval(tokenId);
191 
192         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
193         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
194         _tokenOwner[tokenId] = to;
195 
196         emit Transfer(from, to, tokenId);
197     }
198 
199     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
200         internal returns (bool)
201     {
202         if (!to.isContract()) {
203             return true;
204         }
205 
206         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
207         return (retval == _ERC721_RECEIVED);
208     }
209 
210     function _clearApproval(uint256 tokenId) private {
211         if (_tokenApprovals[tokenId] != address(0)) {
212             _tokenApprovals[tokenId] = address(0);
213         }
214     }
215 
216 }
217 
218 pragma solidity ^0.5.16;
219 
220 contract IERC721Enumerable is IERC721 {
221     function totalSupply() public view returns (uint256);
222     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
223     function tokenByIndex(uint256 index) public view returns (uint256);
224 }
225 
226 pragma solidity ^0.5.16;
227 
228 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
229 
230     mapping(address => uint256[]) private _ownedTokens;
231     mapping(uint256 => uint256) private _ownedTokensIndex;
232     uint256[] private _allTokens;
233     mapping(uint256 => uint256) private _allTokensIndex;
234     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
235 
236     constructor () public {
237         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
238     }
239 
240     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
241         require(index < balanceOf(owner));
242         return _ownedTokens[owner][index];
243     }
244 
245     function totalSupply() public view returns (uint256) {
246         return _allTokens.length;
247     }
248 
249     function tokenByIndex(uint256 index) public view returns (uint256) {
250         require(index < totalSupply());
251         return _allTokens[index];
252     }
253 
254     function _transferFrom(address from, address to, uint256 tokenId) internal {
255         super._transferFrom(from, to, tokenId);
256         _removeTokenFromOwnerEnumeration(from, tokenId);
257         _addTokenToOwnerEnumeration(to, tokenId);
258     }
259 
260     function _mint(address to, uint256 tokenId) internal {
261         super._mint(to, tokenId);
262         _addTokenToOwnerEnumeration(to, tokenId);
263         _addTokenToAllTokensEnumeration(tokenId);
264     }
265 
266     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
267         return _ownedTokens[owner];
268     }
269 
270     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
271         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
272         _ownedTokens[to].push(tokenId);
273     }
274 
275     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
276         _allTokensIndex[tokenId] = _allTokens.length;
277         _allTokens.push(tokenId);
278     }
279 
280     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
281         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
282         uint256 tokenIndex = _ownedTokensIndex[tokenId];
283 
284         if (tokenIndex != lastTokenIndex) {
285             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
286             _ownedTokens[from][tokenIndex] = lastTokenId;
287             _ownedTokensIndex[lastTokenId] = tokenIndex;
288         }
289 
290         _ownedTokens[from].length--;
291     }
292 
293     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
294 
295         uint256 lastTokenIndex = _allTokens.length.sub(1);
296         uint256 tokenIndex = _allTokensIndex[tokenId];
297         uint256 lastTokenId = _allTokens[lastTokenIndex];
298 
299         _allTokens[tokenIndex] = lastTokenId;
300         _allTokensIndex[lastTokenId] = tokenIndex;
301 
302         _allTokens.length--;
303         _allTokensIndex[tokenId] = 0;
304     }
305 }
306 
307 pragma solidity ^0.5.16;
308 
309 contract IERC721Metadata is IERC721 {
310     function name() external view returns (string memory);
311     function symbol() external view returns (string memory);
312     function tokenURI(uint256 tokenId) external view returns (string memory);
313 }
314 
315 
316 pragma solidity ^0.5.16;
317 
318 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
319 
320     string private _name;
321     string private _symbol;
322 
323     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
324 
325     constructor (string memory name, string memory symbol) public {
326         _name = name;
327         _symbol = symbol;
328         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
329     }
330 
331     function name() external view returns (string memory) {
332         return _name;
333     }
334 
335     function symbol() external view returns (string memory) {
336         return _symbol;
337     }
338 
339 }
340 
341 pragma solidity ^0.5.16;
342 
343 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
344     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
345     }
346 }
347 pragma solidity ^0.5.16;
348 
349 contract IRadicalNFT is IERC165 {
350     function round(uint256 _tokenid) external view returns (uint256 _round);
351     function price(uint256 _round) public returns (uint256 _price);
352     function getBidStartTime(uint256 tokenid)external view returns(uint64);
353     function bid(address inviterAddress, uint256 tokenid) external payable;
354 }
355 contract RadicalNFT is ERC165,IRadicalNFT {
356 
357     bytes4 private constant _INTERFACE_ID_RADICALNFT = 0x9203c74e;
358  //       bytes4(keccak256('round(uint256)')) ^
359  //       bytes4(keccak256('price(uint256)')) ^
360  //       bytes4(keccak256('getBidStartTime(uint256)')) ^
361  //       bytes4(keccak256('bid(address,uint256)'));
362 
363     constructor () public {
364         _registerInterface(_INTERFACE_ID_RADICALNFT);
365     }
366 }
367 
368 contract Ownable {
369   address public owner;
370 
371     constructor() public {
372     owner = msg.sender;
373   }
374 
375 
376   modifier onlyOwner() {
377     require(msg.sender == owner);
378     _;
379   }
380 
381   function transferOwnership(address newOwner) onlyOwner public {
382     if (newOwner != address(0)) {
383       owner = newOwner;
384     }
385   }
386 
387 }
388 
389 contract ReentrancyGuard {
390     // Booleans are more expensive than uint256 or any type that takes up a full
391     // word because each write operation emits an extra SLOAD to first read the
392     // slot's contents, replace the bits taken up by the boolean, and then write
393     // back. This is the compiler's defense against contract upgrades and
394     // pointer aliasing, and it cannot be disabled.
395 
396     // The values being non-zero value makes deployment a bit more expensive,
397     // but in exchange the refund on every call to nonReentrant will be lower in
398     // amount. Since refunds are capped to a percentage of the total
399     // transaction's gas, it is best to keep them low in cases like this one, to
400     // increase the likelihood of the full refund coming into effect.
401     uint256 private constant _NOT_ENTERED = 1;
402     uint256 private constant _ENTERED = 2;
403 
404     uint256 private _status;
405 
406     constructor ()public {
407         _status = _NOT_ENTERED;
408     }
409 
410     /**
411      * @dev Prevents a contract from calling itself, directly or indirectly.
412      * Calling a `nonReentrant` function from another `nonReentrant`
413      * function is not supported. It is possible to prevent this from happening
414      * by making the `nonReentrant` function external, and make it call a
415      * `private` function that does the actual work.
416      */
417     modifier nonReentrant() {
418         // On the first call to nonReentrant, _notEntered will be true
419         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
420 
421         // Any calls to nonReentrant after this point will fail
422         _status = _ENTERED;
423 
424         _;
425 
426         // By storing the original value once again, a refund is triggered (see
427         // https://eips.ethereum.org/EIPS/eip-2200)
428         _status = _NOT_ENTERED;
429     }
430 }
431 contract ArtistBase is Ownable,ERC721Full,RadicalNFT,ReentrancyGuard {
432     
433     using SafeMath for uint256;
434     
435     bool public paused = false;
436     address public cfoAddress;
437     address public cooAddress;
438     
439     address public bonusPoolAddress;
440     address public devPoolAddress;  
441     uint256[] private priceList;
442 
443 
444 
445     /// @dev The main art struct. 
446     struct Art {
447         uint256 id;
448         uint64 bidStartTime;
449         uint64 round;
450         //bid issue privileges
451         bool bid;
452         string ipfs;
453     }
454 
455 
456     uint256 public lastBidTime=0;
457     Art[]  arts;
458 
459     //current id 
460     uint256 curid;
461     
462     uint256 public bidInterval;
463     uint256 public defaultBidTokenId;
464     
465     modifier onlyCLevel() {
466         require(
467             msg.sender == cooAddress 
468         );
469         _;
470     }
471     modifier whenNotPaused() {
472         require(!paused);
473         _;
474     }
475 
476     /// @dev Modifier to allow actions only when the contract IS paused
477     modifier whenPaused {
478         require(paused);
479         _;
480     }
481 
482 
483     function pause() external onlyCLevel whenNotPaused {
484         paused = true;
485     }
486 
487     function unpause() public onlyCLevel whenPaused {
488         paused = false;
489     }
490 
491     function creatArt(
492         bool bidflag,
493         string calldata ipfsaddr,
494         uint64 startTime
495 
496     )
497         external
498         whenNotPaused
499         returns (uint256)
500     {
501          require(msg.sender == owner, "ERR_NOT_OWNER");
502 
503 
504         if(lastBidTime==0){
505             bidflag=false;
506         }else if((now-lastBidTime)<bidInterval){
507             bidflag=false;
508         }else{
509             if(bidflag){
510                 lastBidTime=now;
511             }
512         }
513 
514         Art memory _art = Art({
515             id: curid,
516             bidStartTime: startTime,
517             round: 0,
518             bid: bidflag,
519             ipfs: ipfsaddr
520 
521         });
522         curid = arts.push(_art) ;
523 
524         require(curid == uint256(uint32(curid)));
525 
526         _mint(owner, curid-1);
527 
528         return curid;
529     }
530     
531     function tokenURI(uint256 tokenId) external view returns (string memory) {
532         require(_exists(tokenId));
533         return arts[tokenId].ipfs;
534     }
535 
536     function checkArtBidable(uint256 tokenId) external view returns (bool) {
537         require(_exists(tokenId));
538         return arts[tokenId].bid;
539     }
540 
541     function openBidTokenAuthority() 
542         external
543         onlyCLevel
544         {
545             lastBidTime=now - bidInterval;
546         }
547 
548     function closeBidTokenAuthority() 
549         external
550         onlyCLevel
551         {
552             lastBidTime=0;
553         }
554 
555     function setBidInterval(uint256 interval) 
556         external
557         onlyCLevel
558         {
559             bidInterval=interval;
560         }
561         
562 
563     function changeArtData(uint256 tokenid,string calldata ipfs) 
564         external
565         onlyCLevel
566         {
567             require(tokenid<curid, "ERR_ARTID_TOOBIG");
568             arts[tokenid].ipfs=ipfs;
569         }
570     function editArtData(uint256 tokenid,string calldata ipfs) 
571         external
572         onlyOwner
573         {
574             require(tokenid<curid, "ERR_ARTID_TOOBIG");
575             require(arts[tokenid].bidStartTime>now,"ERR_ALREADY_START");
576             arts[tokenid].ipfs=ipfs;
577         }
578 
579     function checkBidable() view
580         external
581         returns (bool){
582         
583             if(lastBidTime==0){
584                 return false;
585             }else if((now-lastBidTime)<bidInterval){
586                 return false;
587             }else{
588                 return true;
589             }
590         
591         }
592     function getLatestTokenID() view
593         external
594         returns (uint256){
595             return curid;
596         }
597         
598     function setBidStartTime(uint256 tokenid,uint64 startTime) 
599         external
600         onlyOwner
601         {
602             require(tokenid<curid, "ERR_TOKEN_ID_ERROR");
603             require(arts[tokenid].bidStartTime>now,"ERR_ALREADY_START");
604             arts[tokenid].bidStartTime=startTime;
605         }
606     function getBidStartTime(uint256 tokenid) view
607         external
608         returns(uint64)
609         {
610             require(tokenid<curid, "ERR_TOKEN_ID_ERROR");
611             return arts[tokenid].bidStartTime;
612         }
613     function setDefaultBidId(uint256 tokenid) 
614         external
615         onlyOwner
616         {
617             require(tokenid<curid, "ERR_TOKEN_ID_ERROR");
618 
619             defaultBidTokenId=tokenid;
620         }
621         
622     function round(uint256 tokenid) view 
623         external
624         returns (uint256){
625             return arts[tokenid].round;
626         }
627 
628     event LOG_AUCTION(
629         uint256  artid,
630         uint256  lastPrice,
631         uint256  curPrice,
632         uint256  bid,
633         address  lastOwner,
634         address  buyer,
635         address  inviterAddress
636     );
637     //bid token address
638     IERC20 public bidtoken;
639     function () external
640     whenNotPaused
641      payable {
642         _bid(devPoolAddress,defaultBidTokenId);
643          
644     }
645    
646       function bid(address inviterAddress, uint256 artid) payable
647     whenNotPaused
648      public {
649         _bid(inviterAddress,artid); 
650      }
651      
652      function price(uint256 _round) public
653      returns (uint256)
654      {
655          if(_round>priceList.length){
656              uint256 lastValue=priceList[priceList.length-1];
657              for(uint256 i=priceList.length;i<_round;i++){
658                  lastValue=lastValue.mul(11).div(10);
659                  priceList.push(lastValue);
660              }
661              return lastValue;
662          }
663          return priceList[_round-1];
664      }     
665      
666      function initRoundPrice() internal
667      returns (uint256)
668      {
669          uint256 lastValue=0;
670          for(uint256 i=1;i<12;i++){
671             if(i<11){
672                 lastValue=i.mul(0.05 ether);
673             }else{
674                 lastValue=lastValue.mul(11).div(10);
675             }
676             priceList.push(lastValue);
677          }
678      }
679     
680     function _bid(address inviterAddress, uint256 artid) nonReentrant internal
681      {
682          require(artid<curid, "ERR_ARTID_TOOBIG");  
683          address lastOwner=ownerOf(artid);
684          require(lastOwner!=msg.sender, "ERR_CAN_NOT_PURCHASE_OWN_ART");       
685          require(arts[artid].bidStartTime<now,"ERR_BID_NOT_START_YET");
686          uint256 r=arts[artid].round;
687          
688          if(r==0){
689              uint256 payprice=0.05 ether;
690              require(msg.value>=payprice, "ERR_NOT_ENOUGH_MONEY");
691               msg.sender.send(msg.value.sub(payprice));
692               address(uint160(owner)).send(payprice);
693               uint256 x=0;
694               if(arts[artid].bid){
695                   x=50 ether;
696                   if(bidtoken.balanceOf(cfoAddress)>=x){
697                       bidtoken.transferFrom(cfoAddress,msg.sender,x);                  
698                   }else{
699                       x=0;
700                   }
701              }
702              arts[artid].round++;
703             _transferFrom(lastOwner, msg.sender, artid);
704 
705             emit LOG_AUCTION(artid, payprice,payprice,x,lastOwner,msg.sender,inviterAddress );
706             return;
707          }
708         uint256 curprice=price(r);
709         uint256 payprice=price(r+1);
710         require(msg.value>=payprice, "ERR_NOT_ENOUGH_MONEY");
711         
712          //refund extra money
713          msg.sender.send(msg.value-payprice);
714          
715          uint256 smoney=payprice-curprice;
716          
717          //we don't check any send process,only 2300 gas provided
718          address(uint160(owner)).send(smoney.mul(5).div(10));
719 
720          address(uint160(bonusPoolAddress)).send(smoney.mul(18).div(100));
721         
722          address(uint160(inviterAddress)).send(smoney.mul(2).div(100));
723         
724          address(uint160(lastOwner)).send(smoney.mul(30).div(100).add(curprice));
725 
726          uint256 x=0;
727          if(arts[artid].bid){
728              //r is last round
729             x=r<10?50 ether:((r+1).mul(5 ether));
730             if(bidtoken.balanceOf(cfoAddress)>=x){
731                 bidtoken.transferFrom(cfoAddress,msg.sender,x);
732             }else{
733                 x=0;
734             }
735          }
736 
737          arts[artid].round++;
738     
739           _transferFrom(lastOwner, msg.sender, artid);
740 
741         emit LOG_AUCTION(artid, curprice,payprice,x,lastOwner,msg.sender,inviterAddress );
742 
743     }
744 
745 }
746 
747 interface IERC20 {
748     function totalSupply() external view returns (uint);
749     function balanceOf(address account) external view returns (uint);
750     function transfer(address recipient, uint amount) external returns (bool);
751     function allowance(address owner, address spender) external view returns (uint);
752     function approve(address spender, uint amount) external returns (bool);
753     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
754 }
755 contract Artist is ArtistBase{
756 
757     constructor(string memory _name,string memory _symbol,address artistaddr,
758     address auditor,address _bid,address _bonusPool,address _devPool) ERC721Full(_name, _symbol) public {
759         bonusPoolAddress=_bonusPool;
760         devPoolAddress=_devPool;
761         bidtoken=IERC20(_bid);
762         curid=0;
763         owner=artistaddr;
764         cfoAddress=msg.sender;
765         cooAddress=auditor;
766         bidInterval=30 days;
767         defaultBidTokenId=0;
768         initRoundPrice();
769     }
770     function setCOO(address _newCOO) external onlyCLevel {
771         require(_newCOO != address(0));
772 
773         cooAddress = _newCOO;
774     }
775     function rescueETH(address _address) external onlyCLevel {
776         address(uint160(_address)).transfer(address(this).balance);
777   }
778  
779 }