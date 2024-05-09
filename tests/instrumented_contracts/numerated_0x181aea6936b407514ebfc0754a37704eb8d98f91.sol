1 pragma solidity ^0.5.0;
2 
3 contract Context {
4 
5     constructor () internal { }
6     function _msgSender() internal view returns (address payable) {
7         return msg.sender;
8     }
9     function _msgData() internal view returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC165 {
16     
17     function supportsInterface(bytes4 interfaceId) external view returns (bool);
18 }
19 
20 contract IERC721 is IERC165 {
21     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
22     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
23     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
24     function balanceOf(address owner) public view returns (uint256 balance);
25     function ownerOf(uint256 tokenId) public view returns (address owner);
26     function safeTransferFrom(address from, address to, uint256 tokenId) public;
27     function transferFrom(address from, address to, uint256 tokenId) public;
28     function approve(address to, uint256 tokenId) public;
29     function getApproved(uint256 tokenId) public view returns (address operator);
30 
31     function setApprovalForAll(address operator, bool _approved) public;
32     function isApprovedForAll(address owner, address operator) public view returns (bool);
33 
34 
35     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
36 }
37 
38 contract IERC721Receiver {
39     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
40     public returns (bytes4);
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56 
57         return c;
58     }
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         // Solidity only automatically asserts when dividing by 0
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81         return c;
82     }
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b != 0, errorMessage);
88         return a % b;
89     }
90 }
91 
92 library Address {
93     function isContract(address account) internal view returns (bool) {
94         bytes32 codehash;
95         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
96         // solhint-disable-next-line no-inline-assembly
97         assembly { codehash := extcodehash(account) }
98         return (codehash != accountHash && codehash != 0x0);
99     }
100     function toPayable(address account) internal pure returns (address payable) {
101         return address(uint160(account));
102     }
103     function sendValue(address payable recipient, uint256 amount) internal {
104         require(address(this).balance >= amount, "Address: insufficient balance");
105 
106         // solhint-disable-next-line avoid-call-value
107         (bool success, ) = recipient.call.value(amount)("");
108         require(success, "Address: unable to send value, recipient may have reverted");
109     }
110 }
111 library Counters {
112     using SafeMath for uint256;
113 
114     struct Counter {
115         uint256 _value; // default: 0
116     }
117 
118     function current(Counter storage counter) internal view returns (uint256) {
119         return counter._value;
120     }
121 
122     function increment(Counter storage counter) internal {
123         // The {SafeMath} overflow check can be skipped here, see the comment at the top
124         counter._value += 1;
125     }
126 
127     function decrement(Counter storage counter) internal {
128         counter._value = counter._value.sub(1);
129     }
130 }
131 
132 contract ERC165 is IERC165 {
133     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
134     mapping(bytes4 => bool) private _supportedInterfaces;
135 
136     constructor () internal {
137         _registerInterface(_INTERFACE_ID_ERC165);
138     }
139     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
140         return _supportedInterfaces[interfaceId];
141     }
142     function _registerInterface(bytes4 interfaceId) internal {
143         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
144         _supportedInterfaces[interfaceId] = true;
145     }
146 }
147 
148 contract ERC721 is Context, ERC165, IERC721 {
149     using SafeMath for uint256;
150     using Address for address;
151     using Counters for Counters.Counter;
152 
153     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
154     mapping (uint256 => address) private _tokenOwner;
155     mapping (uint256 => address) private _tokenApprovals;
156     mapping (address => Counters.Counter) private _ownedTokensCount;
157     mapping (address => mapping (address => bool)) private _operatorApprovals;
158     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
159 
160     constructor () public {
161         // register the supported interfaces to conform to ERC721 via ERC165
162         _registerInterface(_INTERFACE_ID_ERC721);
163     }
164     function balanceOf(address owner) public view returns (uint256) {
165         require(owner != address(0), "ERC721: balance query for the zero address");
166 
167         return _ownedTokensCount[owner].current();
168     }
169     function ownerOf(uint256 tokenId) public view returns (address) {
170         address owner = _tokenOwner[tokenId];
171         require(owner != address(0), "ERC721: owner query for nonexistent token");
172 
173         return owner;
174     }
175     function approve(address to, uint256 tokenId) public {
176         address owner = ownerOf(tokenId);
177         require(to != owner, "ERC721: approval to current owner");
178 
179         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
180             "ERC721: approve caller is not owner nor approved for all"
181         );
182 
183         _tokenApprovals[tokenId] = to;
184         emit Approval(owner, to, tokenId);
185     }
186     function getApproved(uint256 tokenId) public view returns (address) {
187         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
188 
189         return _tokenApprovals[tokenId];
190     }
191     function setApprovalForAll(address to, bool approved) public {
192         require(to != _msgSender(), "ERC721: approve to caller");
193 
194         _operatorApprovals[_msgSender()][to] = approved;
195         emit ApprovalForAll(_msgSender(), to, approved);
196     }
197     function isApprovedForAll(address owner, address operator) public view returns (bool) {
198         return _operatorApprovals[owner][operator];
199     }
200     function transferFrom(address from, address to, uint256 tokenId) public {
201         //solhint-disable-next-line max-line-length
202         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
203 
204         _transferFrom(from, to, tokenId);
205     }
206     function safeTransferFrom(address from, address to, uint256 tokenId) public {
207         safeTransferFrom(from, to, tokenId, "");
208     }
209     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
210         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
211         _safeTransferFrom(from, to, tokenId, _data);
212     }
213     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
214         _transferFrom(from, to, tokenId);
215         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
216     }
217     function _exists(uint256 tokenId) internal view returns (bool) {
218         address owner = _tokenOwner[tokenId];
219         return owner != address(0);
220     }
221     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
222         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
223         address owner = ownerOf(tokenId);
224         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
225     }
226     function _safeMint(address to, uint256 tokenId) internal {
227         _safeMint(to, tokenId, "");
228     }
229     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
230         _mint(to, tokenId);
231         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
232     }
233     function _mint(address to, uint256 tokenId) internal {
234         require(to != address(0), "ERC721: mint to the zero address");
235         require(!_exists(tokenId), "ERC721: token already minted");
236 
237         _tokenOwner[tokenId] = to;
238         _ownedTokensCount[to].increment();
239 
240         emit Transfer(address(0), to, tokenId);
241     }
242     function _burn(address owner, uint256 tokenId) internal {
243         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
244 
245         _clearApproval(tokenId);
246 
247         _ownedTokensCount[owner].decrement();
248         _tokenOwner[tokenId] = address(0);
249 
250         emit Transfer(owner, address(0), tokenId);
251     }
252     function _burn(uint256 tokenId) internal {
253         _burn(ownerOf(tokenId), tokenId);
254     }
255     function _transferFrom(address from, address to, uint256 tokenId) internal {
256         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
257         require(to != address(0), "ERC721: transfer to the zero address");
258 
259         _clearApproval(tokenId);
260 
261         _ownedTokensCount[from].decrement();
262         _ownedTokensCount[to].increment();
263 
264         _tokenOwner[tokenId] = to;
265 
266         emit Transfer(from, to, tokenId);
267     }
268     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
269         internal returns (bool)
270     {
271         if (!to.isContract()) {
272             return true;
273         }
274         // solhint-disable-next-line avoid-low-level-calls
275         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
276             IERC721Receiver(to).onERC721Received.selector,
277             _msgSender(),
278             from,
279             tokenId,
280             _data
281         ));
282         if (!success) {
283             if (returndata.length > 0) {
284                 // solhint-disable-next-line no-inline-assembly
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert("ERC721: transfer to non ERC721Receiver implementer");
291             }
292         } else {
293             bytes4 retval = abi.decode(returndata, (bytes4));
294             return (retval == _ERC721_RECEIVED);
295         }
296     }
297     function _clearApproval(uint256 tokenId) private {
298         if (_tokenApprovals[tokenId] != address(0)) {
299             _tokenApprovals[tokenId] = address(0);
300         }
301     }
302 }
303 
304 contract IERC721Enumerable is IERC721 {
305     function totalSupply() public view returns (uint256);
306     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
307 
308     function tokenByIndex(uint256 index) public view returns (uint256);
309 }
310 
311 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
312     mapping(address => uint256[]) private _ownedTokens;
313     mapping(uint256 => uint256) private _ownedTokensIndex;
314     uint256[] private _allTokens;
315     mapping(uint256 => uint256) private _allTokensIndex;
316     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
317 
318     constructor () public {
319         // register the supported interface to conform to ERC721Enumerable via ERC165
320         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
321     }
322     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
323         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
324         return _ownedTokens[owner][index];
325     }
326     function totalSupply() public view returns (uint256) {
327         return _allTokens.length;
328     }
329     function tokenByIndex(uint256 index) public view returns (uint256) {
330         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
331         return _allTokens[index];
332     }
333     function _transferFrom(address from, address to, uint256 tokenId) internal {
334         super._transferFrom(from, to, tokenId);
335 
336         _removeTokenFromOwnerEnumeration(from, tokenId);
337 
338         _addTokenToOwnerEnumeration(to, tokenId);
339     }
340     function _mint(address to, uint256 tokenId) internal {
341         super._mint(to, tokenId);
342 
343         _addTokenToOwnerEnumeration(to, tokenId);
344 
345         _addTokenToAllTokensEnumeration(tokenId);
346     }
347     function _burn(address owner, uint256 tokenId) internal {
348         super._burn(owner, tokenId);
349 
350         _removeTokenFromOwnerEnumeration(owner, tokenId);
351         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
352         _ownedTokensIndex[tokenId] = 0;
353 
354         _removeTokenFromAllTokensEnumeration(tokenId);
355     }
356     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
357         return _ownedTokens[owner];
358     }
359     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
360         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
361         _ownedTokens[to].push(tokenId);
362     }
363     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
364         _allTokensIndex[tokenId] = _allTokens.length;
365         _allTokens.push(tokenId);
366     }
367     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
368         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
369         uint256 tokenIndex = _ownedTokensIndex[tokenId];
370         if (tokenIndex != lastTokenIndex) {
371             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
372 
373             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
374             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
375         }
376         _ownedTokens[from].length--;
377     }
378     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
379         uint256 lastTokenIndex = _allTokens.length.sub(1);
380         uint256 tokenIndex = _allTokensIndex[tokenId];
381         uint256 lastTokenId = _allTokens[lastTokenIndex];
382 
383         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
384         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
385         _allTokens.length--;
386         _allTokensIndex[tokenId] = 0;
387     }
388 }
389 
390 contract IERC721Metadata is IERC721 {
391     function name() external view returns (string memory);
392     function symbol() external view returns (string memory);
393     function tokenURI(uint256 tokenId) external view returns (string memory);
394 }
395 
396 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
397     string private _name;
398     string private _symbol;
399     string private _baseURI;
400     mapping(uint256 => string) private _tokenURIs;
401     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
402 
403     constructor (string memory name, string memory symbol) public {
404         _name = name;
405         _symbol = symbol;
406 
407         // register the supported interfaces to conform to ERC721 via ERC165
408         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
409     }
410     function name() external view returns (string memory) {
411         return _name;
412     }
413     function symbol() external view returns (string memory) {
414         return _symbol;
415     }
416     function tokenURI(uint256 tokenId) external view returns (string memory) {
417         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
418 
419         string memory _tokenURI = _tokenURIs[tokenId];
420 
421         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
422         if (bytes(_tokenURI).length == 0) {
423             return "";
424         } else {
425             // abi.encodePacked is being used to concatenate strings
426             return string(abi.encodePacked(_baseURI, _tokenURI));
427         }
428     }
429     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
430         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
431         _tokenURIs[tokenId] = _tokenURI;
432     }
433     function _setBaseURI(string memory baseURI) internal {
434         _baseURI = baseURI;
435     }
436     function baseURI() external view returns (string memory) {
437         return _baseURI;
438     }
439     function _burn(address owner, uint256 tokenId) internal {
440         super._burn(owner, tokenId);
441 
442         // Clear metadata (if any)
443         if (bytes(_tokenURIs[tokenId]).length != 0) {
444             delete _tokenURIs[tokenId];
445         }
446     }
447 }
448 
449 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
450     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
451         // solhint-disable-previous-line no-empty-blocks
452     }
453 }
454 
455 interface IERC20 {
456     function totalSupply() external view returns (uint256);
457     function balanceOf(address account) external view returns (uint256);
458     function transfer(address recipient, uint256 amount) external returns (bool);
459     function allowance(address owner, address spender) external view returns (uint256);
460     function approve(address spender, uint256 amount) external returns (bool);
461     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
462     event Transfer(address indexed from, address indexed to, uint256 value);
463     event Approval(address indexed owner, address indexed spender, uint256 value);
464 }
465 
466 contract Ownable is Context {
467     address private _owner;
468 
469     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
470     constructor () internal {
471         address msgSender = _msgSender();
472         _owner = msgSender;
473         emit OwnershipTransferred(address(0), msgSender);
474     }
475     function owner() public view returns (address) {
476         return _owner;
477     }
478     modifier onlyOwner() {
479         require(isOwner(), "Ownable: caller is not the owner");
480         _;
481     }
482     function isOwner() public view returns (bool) {
483         return _msgSender() == _owner;
484     }
485     function renounceOwnership() public onlyOwner {
486         emit OwnershipTransferred(_owner, address(0));
487         _owner = address(0);
488     }
489     function transferOwnership(address newOwner) public onlyOwner {
490         _transferOwnership(newOwner);
491     }
492     function _transferOwnership(address newOwner) internal {
493         require(newOwner != address(0), "Ownable: new owner is the zero address");
494         emit OwnershipTransferred(_owner, newOwner);
495         _owner = newOwner;
496     }
497 }
498 
499 contract ReentrancyGuard {
500     bool private _notEntered;
501 
502     constructor () internal {
503         _notEntered = true;
504     }
505     modifier nonReentrant() {
506         require(_notEntered, "ReentrancyGuard: reentrant call");
507         _notEntered = false;
508 
509         _;
510 
511         // By storing the original value once again, a refund is triggered (see
512         // https://eips.ethereum.org/EIPS/eip-2200)
513         _notEntered = true;
514     }
515 }
516 
517 interface Pool1  {
518     function changeDependentContractAddress() external;
519     function makeCoverBegin(
520         address smartCAdd,
521         bytes4 coverCurr,
522         uint[] calldata coverDetails,
523         uint16 coverPeriod,
524         uint8 _v,
525         bytes32 _r,
526         bytes32 _s
527     )
528         external
529         payable;
530     function makeCoverUsingCA(
531         address smartCAdd,
532         bytes4 coverCurr,
533         uint[] calldata coverDetails,
534         uint16 coverPeriod,
535         uint8 _v,
536         bytes32 _r,
537         bytes32 _s
538     )
539         external;
540     function getWei(uint amount) external view returns(uint);
541     function sellNXMTokens(uint _amount) external  returns (bool);
542 }
543 
544 contract INXMMaster {
545     address public tokenAddress;
546     address public owner;
547     uint public pauseTime;
548     function masterInitialized() external view returns(bool);
549     function isPause() external view returns(bool check);
550     function isMember(address _add) external view returns(bool);
551     function getLatestAddress(bytes2 _contractName) external view returns(address payable contractAddress);
552 }
553 
554 interface DSValue {
555     function peek() external view returns (bytes32, bool);
556     function read() external view returns (bytes32);
557 }
558 
559 interface PoolData {
560 
561     struct ApiId {
562         bytes4 typeOf;
563         bytes4 currency;
564         uint id;
565         uint64 dateAdd;
566         uint64 dateUpd;
567     }
568 
569     struct CurrencyAssets {
570         address currAddress;
571         uint baseMin;
572         uint varMin;
573     }
574 
575     struct InvestmentAssets {
576         address currAddress;
577         bool status;
578         uint64 minHoldingPercX100;
579         uint64 maxHoldingPercX100;
580         uint8 decimals;
581     }
582 
583     struct IARankDetails {
584         bytes4 maxIACurr;
585         uint64 maxRate;
586         bytes4 minIACurr;
587         uint64 minRate;
588     }
589 
590     struct McrData {
591         uint mcrPercx100;
592         uint mcrEther;
593         uint vFull; //Pool funds
594         uint64 date;
595     }
596 
597     function setCapReached(uint val) external;
598     function getInvestmentAssetDecimals(bytes4 curr) external returns(uint8 decimal);
599     function getCurrencyAssetAddress(bytes4 curr) external view returns(address);
600     function getInvestmentAssetAddress(bytes4 curr) external view returns(address);
601     function getInvestmentAssetStatus(bytes4 curr) external view returns(bool status);
602 
603 }
604 
605 interface QuotationData {
606 
607     enum HCIDStatus { NA, kycPending, kycPass, kycFailedOrRefunded, kycPassNoCover }
608     enum CoverStatus { Active, ClaimAccepted, ClaimDenied, CoverExpired, ClaimSubmitted, Requested }
609 
610     struct Cover {
611         address payable memberAddress;
612         bytes4 currencyCode;
613         uint sumAssured;
614         uint16 coverPeriod;
615         uint validUntil;
616         address scAddress;
617         uint premiumNXM;
618     }
619 
620     struct HoldCover {
621         uint holdCoverId;
622         address payable userAddress;
623         address scAddress;
624         bytes4 coverCurr;
625         uint[] coverDetails;
626         uint16 coverPeriod;
627     }
628 
629     function getCoverLength() external returns(uint len);
630     function getAuthQuoteEngine() external returns(address _add);
631     function getAllCoversOfUser(address _add) external returns(uint[] memory allCover);
632     function getUserCoverLength(address _add) external returns(uint len);
633     function getCoverStatusNo(uint _cid) external returns(uint8);
634     function getCoverPeriod(uint _cid) external returns(uint32 cp);
635     function getCoverSumAssured(uint _cid) external returns(uint sa);
636     function getCurrencyOfCover(uint _cid) external returns(bytes4 curr);
637     function getValidityOfCover(uint _cid) external returns(uint date);
638     function getscAddressOfCover(uint _cid) external returns(uint, address);
639     function getCoverMemberAddress(uint _cid) external returns(address payable _add);
640     function getCoverPremiumNXM(uint _cid) external returns(uint _premiumNXM);
641     function getCoverDetailsByCoverID1(
642         uint _cid
643     )
644         external
645         returns (
646             uint cid,
647             address _memberAddress,
648             address _scAddress,
649             bytes4 _currencyCode,
650             uint _sumAssured,
651             uint premiumNXM
652         );
653     function getCoverDetailsByCoverID2(
654         uint _cid
655     )
656         external
657         view
658         returns (
659             uint cid,
660             uint8 status,
661             uint sumAssured,
662             uint16 coverPeriod,
663             uint validUntil
664         );
665     function getHoldedCoverDetailsByID1(
666         uint _hcid
667     )
668         external
669         view
670         returns (
671             uint hcid,
672             address scAddress,
673             bytes4 coverCurr,
674             uint16 coverPeriod
675         );
676     function getUserHoldedCoverLength(address _add) external returns (uint);
677     function getUserHoldedCoverByIndex(address _add, uint index) external returns (uint);
678     function getHoldedCoverDetailsByID2(
679         uint _hcid
680     )
681         external
682         returns (
683             uint hcid,
684             address payable memberAddress,
685             uint[] memory coverDetails
686         );
687     function getTotalSumAssuredSC(address _add, bytes4 _curr) external returns(uint amount);
688 
689 }
690 
691 contract TokenData {
692     function lockTokenTimeAfterCoverExp() external returns (uint);
693 }
694 
695 interface Claims {
696     function getClaimbyIndex(uint _claimId) external view returns (
697         uint claimId,
698         uint status,
699         int8 finalVerdict,
700         address claimOwner,
701         uint coverId
702     );
703     function submitClaim(uint coverId) external;
704 }
705 
706 contract ClaimsData {
707     function actualClaimLength() external view returns(uint);
708 }
709 
710 interface NXMToken {
711     function balanceOf(address owner) external view returns (uint256);
712     function approve(address spender, uint256 value) external returns (bool);
713 
714 }
715 
716 interface MemberRoles {
717     function switchMembership(address) external;
718 }
719 
720 contract yInsure is
721     ERC721Full("yInsureNFT", "yNFT"),
722     Ownable,
723     ReentrancyGuard {
724     
725     struct Token {
726         uint expirationTimestamp;
727         bytes4 coverCurrency;
728         uint coverAmount;
729         uint coverPrice;
730         uint coverPriceNXM;
731         uint expireTime;
732         uint generationTime;
733         uint coverId;
734         bool claimInProgress;
735         uint claimId;
736     }
737     
738     event ClaimRedeemed (
739         address receiver,
740         uint value,
741         bytes4 currency
742     );
743     
744     using SafeMath for uint;
745 
746     INXMMaster constant public nxMaster = INXMMaster(0x01BFd82675DBCc7762C84019cA518e701C0cD07e);
747     
748     enum CoverStatus {
749         Active,
750         ClaimAccepted,
751         ClaimDenied,
752         CoverExpired,
753         ClaimSubmitted,
754         Requested
755     }
756     
757     enum ClaimStatus {
758         PendingClaimAssessorVote, // 0
759         PendingClaimAssessorVoteDenied, // 1
760         PendingClaimAssessorVoteThresholdNotReachedAccept, // 2
761         PendingClaimAssessorVoteThresholdNotReachedDeny, // 3
762         PendingClaimAssessorConsensusNotReachedAccept, // 4
763         PendingClaimAssessorConsensusNotReachedDeny, // 5
764         FinalClaimAssessorVoteDenied, // 6
765         FinalClaimAssessorVoteAccepted, // 7
766         FinalClaimAssessorVoteDeniedMVAccepted, // 8
767         FinalClaimAssessorVoteDeniedMVDenied, // 9
768         FinalClaimAssessorVotAcceptedMVNoDecision, // 10
769         FinalClaimAssessorVoteDeniedMVNoDecision, // 11
770         ClaimAcceptedPayoutPending, // 12
771         ClaimAcceptedNoPayout, // 13
772         ClaimAcceptedPayoutDone // 14
773     }
774     
775     function _buyCover(
776         address coveredContractAddress,
777         bytes4 coverCurrency,
778         uint[] memory coverDetails,
779         uint16 coverPeriod,
780         uint8 _v,
781         bytes32 _r,
782         bytes32 _s
783     ) internal returns (uint coverId) {
784     
785         uint coverPrice = coverDetails[1];
786         Pool1 pool1 = Pool1(nxMaster.getLatestAddress("P1"));
787         if (coverCurrency == "ETH") {
788             pool1.makeCoverBegin.value(coverPrice)(coveredContractAddress, coverCurrency, coverDetails, coverPeriod, _v, _r, _s);
789         } else {
790             address payable pool1Address = address(uint160(address(pool1)));
791             PoolData poolData = PoolData(nxMaster.getLatestAddress("PD"));
792             IERC20 erc20 = IERC20(poolData.getCurrencyAssetAddress(coverCurrency));
793             erc20.approve(pool1Address, coverPrice);
794             pool1.makeCoverUsingCA(coveredContractAddress, coverCurrency, coverDetails, coverPeriod, _v, _r, _s);
795         }
796     
797         QuotationData quotationData = QuotationData(nxMaster.getLatestAddress("QD"));
798         // *assumes* the newly created claim is appended at the end of the list covers
799         coverId = quotationData.getCoverLength().sub(1);
800     }
801     
802     function _submitClaim(uint coverId) internal returns (uint) {
803         Claims claims = Claims(nxMaster.getLatestAddress("CL"));
804         claims.submitClaim(coverId);
805     
806         ClaimsData claimsData = ClaimsData(nxMaster.getLatestAddress("CD"));
807         uint claimId = claimsData.actualClaimLength() - 1;
808         return claimId;
809     }
810     
811     function getMemberRoles() public view returns (address) {
812         return nxMaster.getLatestAddress("MR");
813     }
814     
815     function getCover(
816         uint coverId
817     ) internal view returns (
818         uint cid,
819         uint8 status,
820         uint sumAssured,
821         uint16 coverPeriod,
822         uint validUntil
823     ) {
824         QuotationData quotationData = QuotationData(nxMaster.getLatestAddress("QD"));
825         return quotationData.getCoverDetailsByCoverID2(coverId);
826     }
827     
828     function _sellNXMTokens(uint amount) internal returns (uint ethValue) {
829         address payable pool1Address = nxMaster.getLatestAddress("P1");
830         Pool1 p1 = Pool1(pool1Address);
831     
832         NXMToken nxmToken = NXMToken(nxMaster.tokenAddress());
833     
834         ethValue = p1.getWei(amount);
835         nxmToken.approve(pool1Address, amount);
836         p1.sellNXMTokens(amount);
837     }
838     
839     function _getCurrencyAssetAddress(bytes4 currency) internal view returns (address) {
840         PoolData pd = PoolData(nxMaster.getLatestAddress("PD"));
841         return pd.getCurrencyAssetAddress(currency);
842     }
843     
844     function _getLockTokenTimeAfterCoverExpiry() internal returns (uint) {
845         TokenData tokenData = TokenData(nxMaster.getLatestAddress("TD"));
846         return tokenData.lockTokenTimeAfterCoverExp();
847     }
848     
849     function _getTokenAddress() internal view returns (address) {
850         return nxMaster.tokenAddress();
851     }
852     
853     function _payoutIsCompleted(uint claimId) internal view returns (bool) {
854         uint256 status;
855         Claims claims = Claims(nxMaster.getLatestAddress("CL"));
856         (, status, , , ) = claims.getClaimbyIndex(claimId);
857         return status == uint(ClaimStatus.FinalClaimAssessorVoteAccepted)
858             || status == uint(ClaimStatus.ClaimAcceptedPayoutDone);
859     }
860   
861     bytes4 internal constant ethCurrency = "ETH";
862     
863     uint public distributorFeePercentage;
864     uint256 internal issuedTokensCount;
865     mapping(uint256 => Token) public tokens;
866     
867     mapping(bytes4 => uint) public withdrawableTokens;
868     
869     constructor(uint _distributorFeePercentage) public {
870         distributorFeePercentage = _distributorFeePercentage;
871     }
872     
873     function switchMembership(address _newMembership) external onlyOwner {
874         NXMToken nxmToken = NXMToken(nxMaster.tokenAddress());
875         nxmToken.approve(getMemberRoles(),uint(-1));
876         MemberRoles(getMemberRoles()).switchMembership(_newMembership);
877     }
878     
879     // Arguments to be passed as coverDetails, from the quote api:
880     //    coverDetails[0] = coverAmount;
881     //    coverDetails[1] = coverPrice;
882     //    coverDetails[2] = coverPriceNXM;
883     //    coverDetails[3] = expireTime;
884     //    coverDetails[4] = generationTime;
885     function buyCover(
886         address coveredContractAddress,
887         bytes4 coverCurrency,
888         uint[] calldata coverDetails,
889         uint16 coverPeriod,
890         uint8 _v,
891         bytes32 _r,
892         bytes32 _s
893     ) external payable {
894     
895         uint coverPrice = coverDetails[1];
896         uint requiredValue = distributorFeePercentage.mul(coverPrice).div(100).add(coverPrice);
897         if (coverCurrency == "ETH") {
898             require(msg.value == requiredValue, "Incorrect value sent");
899         } else {
900             IERC20 erc20 = IERC20(_getCurrencyAssetAddress(coverCurrency));
901             require(erc20.transferFrom(msg.sender, address(this), requiredValue), "Transfer failed");
902         }
903         
904         uint coverId = _buyCover(coveredContractAddress, coverCurrency, coverDetails, coverPeriod, _v, _r, _s);
905         withdrawableTokens[coverCurrency] = withdrawableTokens[coverCurrency].add(requiredValue.sub(coverPrice));
906         
907         // mint token
908         uint256 nextTokenId = issuedTokensCount++;
909         uint expirationTimestamp = block.timestamp + _getLockTokenTimeAfterCoverExpiry() + coverPeriod * 1 days;
910         tokens[nextTokenId] = Token(expirationTimestamp,
911           coverCurrency,
912           coverDetails[0],
913           coverDetails[1],
914           coverDetails[2],
915           coverDetails[3],
916           coverDetails[4],
917           coverId, false, 0);
918         _mint(msg.sender, nextTokenId);
919     }
920     
921     function submitClaim(uint256 tokenId) external onlyTokenApprovedOrOwner(tokenId) {
922     
923         if (tokens[tokenId].claimInProgress) {
924             uint8 coverStatus;
925             (, coverStatus, , , ) = getCover(tokens[tokenId].coverId);
926             require(coverStatus == uint8(CoverStatus.ClaimDenied),
927             "Can submit another claim only if the previous one was denied.");
928         }
929         require(tokens[tokenId].expirationTimestamp > block.timestamp, "Token is expired");
930         
931         uint claimId = _submitClaim(tokens[tokenId].coverId);
932         
933         tokens[tokenId].claimInProgress = true;
934         tokens[tokenId].claimId = claimId;
935     }
936     
937     function redeemClaim(uint256 tokenId) public onlyTokenApprovedOrOwner(tokenId)  nonReentrant {
938         require(tokens[tokenId].claimInProgress, "No claim is in progress");
939         uint8 coverStatus;
940         uint sumAssured;
941         (, coverStatus, sumAssured, , ) = getCover(tokens[tokenId].coverId);
942         
943         require(coverStatus == uint8(CoverStatus.ClaimAccepted), "Claim is not accepted");
944         require(_payoutIsCompleted(tokens[tokenId].coverId), "Claim accepted but payout not completed");
945         
946         _burn(tokenId);
947         _sendAssuredSum(tokens[tokenId].coverCurrency, sumAssured);
948         emit ClaimRedeemed(msg.sender, sumAssured, tokens[tokenId].coverCurrency);
949     }
950     
951     function _sendAssuredSum(bytes4 coverCurrency, uint sumAssured) internal {
952         if (coverCurrency == ethCurrency) {
953             msg.sender.transfer(sumAssured);
954         } else {
955             IERC20 erc20 = IERC20(_getCurrencyAssetAddress(coverCurrency));
956             require(erc20.transfer(msg.sender, sumAssured), "Transfer failed");
957         }
958     }
959     
960     function getCoverStatus(uint256 tokenId) external view returns (uint8 coverStatus, bool payoutCompleted) {
961         (, coverStatus, , , ) = getCover(tokens[tokenId].coverId);
962         payoutCompleted = _payoutIsCompleted(tokenId);
963     }
964     
965     function nxmTokenApprove(address _spender, uint256 _value) public onlyOwner {
966         IERC20 nxmToken = IERC20(_getTokenAddress());
967         nxmToken.approve(_spender, _value);
968     }
969     
970     function withdrawEther(address payable _recipient, uint256 _amount) external onlyOwner nonReentrant {
971         require(withdrawableTokens[ethCurrency] >= _amount, "Not enough ETH");
972         withdrawableTokens[ethCurrency] = withdrawableTokens[ethCurrency].sub(_amount);
973         _recipient.transfer(_amount);
974     }
975     
976     function withdrawTokens(address payable _recipient, uint256 _amount, bytes4 _currency) external onlyOwner nonReentrant {
977         require(withdrawableTokens[_currency] >= _amount, "Not enough tokens");
978         withdrawableTokens[_currency] = withdrawableTokens[_currency].sub(_amount);
979     
980         IERC20 erc20 = IERC20(_getCurrencyAssetAddress(_currency));
981         require(erc20.transfer(_recipient, _amount), "Transfer failed");
982     }
983     
984     function sellNXMTokens(uint amount) external onlyOwner {
985         uint ethValue = _sellNXMTokens(amount);
986         withdrawableTokens[ethCurrency] = withdrawableTokens[ethCurrency].add(ethValue);
987     }
988     
989     modifier onlyTokenApprovedOrOwner(uint256 tokenId) {
990         require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
991         _;
992     }
993     
994     function () payable external {
995     }
996 }