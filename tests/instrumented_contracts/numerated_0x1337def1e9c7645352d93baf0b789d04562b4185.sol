1 pragma solidity ^0.5.0;
2 
3 
4 
5 
6 contract Context {
7     constructor () internal { }
8     function _msgSender() internal view returns (address payable) {
9         return msg.sender;
10     }
11     function _msgData() internal view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 
18 
19 interface IERC165 {
20     function supportsInterface(bytes4 interfaceId) external view returns (bool);
21 }
22 
23 contract ERC165 is IERC165 {
24     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
25     mapping(bytes4 => bool) private _supportedInterfaces;
26 
27     constructor () internal {
28         _registerInterface(_INTERFACE_ID_ERC165);
29     }
30     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
31         return _supportedInterfaces[interfaceId];
32     }
33     function _registerInterface(bytes4 interfaceId) internal {
34         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
35         _supportedInterfaces[interfaceId] = true;
36     }
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52 
53         return c;
54     }
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57         // benefit is lost if 'b' is also tested.
58         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
59         if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 library Address {
88     function isContract(address account) internal view returns (bool) {
89         bytes32 codehash;
90         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
91         // solhint-disable-next-line no-inline-assembly
92         assembly { codehash := extcodehash(account) }
93         return (codehash != accountHash && codehash != 0x0);
94     }
95     function toPayable(address account) internal pure returns (address payable) {
96         return address(uint160(account));
97     }
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-call-value
102         (bool success, ) = recipient.call.value(amount)("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 }
106 
107 
108 contract IERC721 is IERC165 {
109     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
110     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
111     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
112     function balanceOf(address owner) public view returns (uint256 balance);
113     function ownerOf(uint256 tokenId) public view returns (address owner);
114     function safeTransferFrom(address from, address to, uint256 tokenId) public;
115     function transferFrom(address from, address to, uint256 tokenId) public;
116     function approve(address to, uint256 tokenId) public;
117     function getApproved(uint256 tokenId) public view returns (address operator);
118 
119     function setApprovalForAll(address operator, bool _approved) public;
120     function isApprovedForAll(address owner, address operator) public view returns (bool);
121 
122 
123     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
124 }
125 
126 contract IERC721Receiver {
127     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
128     public returns (bytes4);
129 }
130 
131 contract ERC721 is Context, ERC165, IERC721 {
132     using SafeMath for uint256;
133     using Address for address;
134 
135     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
136     mapping (uint256 => address) private _tokenOwner;
137     mapping (uint256 => address) private _tokenApprovals;
138     uint256 internal _totalSupply;
139 
140     /**
141      * @dev Enumerable takes care of this.
142     **/
143     //mapping (address => Counters.Counter) private _ownedTokensCount;
144     mapping (address => mapping (address => bool)) private _operatorApprovals;
145     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
146 
147     constructor () public {
148         // register the supported interfaces to conform to ERC721 via ERC165
149         _registerInterface(_INTERFACE_ID_ERC721);
150     }
151 
152     function totalSupply() public view returns (uint256) {
153       return _totalSupply;
154     }
155     
156     function ownerOf(uint256 tokenId) public view returns (address) {
157         address owner = _tokenOwner[tokenId];
158         require(owner != address(0), "ERC721: owner query for nonexistent token");
159 
160         return owner;
161     }
162     function approve(address to, uint256 tokenId) public {
163         address owner = ownerOf(tokenId);
164         require(to != owner, "ERC721: approval to current owner");
165 
166         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
167             "ERC721: approve caller is not owner nor approved for all"
168         );
169 
170         _tokenApprovals[tokenId] = to;
171         emit Approval(owner, to, tokenId);
172     }
173     function getApproved(uint256 tokenId) public view returns (address) {
174         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
175 
176         return _tokenApprovals[tokenId];
177     }
178     function setApprovalForAll(address to, bool approved) public {
179         require(to != _msgSender(), "ERC721: approve to caller");
180 
181         _operatorApprovals[_msgSender()][to] = approved;
182         emit ApprovalForAll(_msgSender(), to, approved);
183     }
184     function isApprovedForAll(address owner, address operator) public view returns (bool) {
185         return _operatorApprovals[owner][operator];
186     }
187     function transferFrom(address from, address to, uint256 tokenId) public {
188         //solhint-disable-next-line max-line-length
189         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
190 
191         _transferFrom(from, to, tokenId);
192     }
193     function safeTransferFrom(address from, address to, uint256 tokenId) public {
194         safeTransferFrom(from, to, tokenId, "");
195     }
196     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
197         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
198         _safeTransferFrom(from, to, tokenId, _data);
199     }
200     function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
201         _transferFrom(from, to, tokenId);
202         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
203     }
204     function _exists(uint256 tokenId) internal view returns (bool) {
205         address owner = _tokenOwner[tokenId];
206         return owner != address(0);
207     }
208     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
209         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
210         address owner = ownerOf(tokenId);
211         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
212     }
213     function _safeMint(address to, uint256 tokenId) internal {
214         _safeMint(to, tokenId, "");
215     }
216     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
217         _mint(to, tokenId);
218         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
219     }
220     function _mint(address to, uint256 tokenId) internal {
221         require(to != address(0), "ERC721: mint to the zero address");
222         require(!_exists(tokenId), "ERC721: token already minted");
223 
224         _tokenOwner[tokenId] = to;
225         _totalSupply = _totalSupply.add(1);
226 
227         emit Transfer(address(0), to, tokenId);
228     }
229     function _burn(address owner, uint256 tokenId) internal {
230         require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");
231 
232         _clearApproval(tokenId);
233 
234         _tokenOwner[tokenId] = address(0);
235         _totalSupply = _totalSupply.sub(1);
236 
237         emit Transfer(owner, address(0), tokenId);
238     }
239     function _burn(uint256 tokenId) internal {
240         _burn(ownerOf(tokenId), tokenId);
241     }
242     function _transferFrom(address from, address to, uint256 tokenId) internal {
243         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
244         require(to != address(0), "ERC721: transfer to the zero address");
245 
246         _clearApproval(tokenId);
247 
248         _tokenOwner[tokenId] = to;
249 
250         emit Transfer(from, to, tokenId);
251     }
252     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
253         internal returns (bool)
254     {
255         if (!to.isContract()) {
256             return true;
257         }
258         // solhint-disable-next-line avoid-low-level-calls
259         (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(
260             IERC721Receiver(to).onERC721Received.selector,
261             _msgSender(),
262             from,
263             tokenId,
264             _data
265         ));
266         if (!success) {
267             if (returndata.length > 0) {
268                 // solhint-disable-next-line no-inline-assembly
269                 assembly {
270                     let returndata_size := mload(returndata)
271                     revert(add(32, returndata), returndata_size)
272                 }
273             } else {
274                 revert("ERC721: transfer to non ERC721Receiver implementer");
275             }
276         } else {
277             bytes4 retval = abi.decode(returndata, (bytes4));
278             return (retval == _ERC721_RECEIVED);
279         }
280     }
281     function _clearApproval(uint256 tokenId) private {
282         if (_tokenApprovals[tokenId] != address(0)) {
283             _tokenApprovals[tokenId] = address(0);
284         }
285     }
286 }
287 
288 
289 
290 contract IERC721Enumerable is IERC721 {
291     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
292 }
293 
294 contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
295     mapping(address => uint256[]) private _ownedTokens;
296     mapping(uint256 => uint256) private _ownedTokensIndex;
297     /**
298      * @dev We've removed allTokens functionality.
299     **/
300     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
301 
302     constructor () public {
303         // register the supported interface to conform to ERC721Enumerable via ERC165
304         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
305     }
306     
307     /**
308      * @dev Added for arNFT (removed from ERC721 basic).
309     **/
310     function balanceOf(address owner) public view returns (uint256) {
311         require(owner != address(0), "ERC721: balance query for the zero address");
312 
313         return _ownedTokens[owner].length;
314     }
315     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
316         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
317         return _ownedTokens[owner][index];
318     }
319     function _transferFrom(address from, address to, uint256 tokenId) internal {
320         super._transferFrom(from, to, tokenId);
321 
322         _removeTokenFromOwnerEnumeration(from, tokenId);
323 
324         _addTokenToOwnerEnumeration(to, tokenId);
325     }
326     function _mint(address to, uint256 tokenId) internal {
327         super._mint(to, tokenId);
328 
329         _addTokenToOwnerEnumeration(to, tokenId);
330     }
331     function _burn(address owner, uint256 tokenId) internal {
332         super._burn(owner, tokenId);
333 
334         _removeTokenFromOwnerEnumeration(owner, tokenId);
335         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
336         _ownedTokensIndex[tokenId] = 0;
337     }
338     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
339         return _ownedTokens[owner];
340     }
341     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
342         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
343         _ownedTokens[to].push(tokenId);
344     }
345     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
346         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
347         uint256 tokenIndex = _ownedTokensIndex[tokenId];
348         if (tokenIndex != lastTokenIndex) {
349             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
350 
351             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
352             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
353         }
354         _ownedTokens[from].length--;
355     }
356 }
357 
358 
359 
360 contract IERC721Metadata is IERC721 {
361     function name() external view returns (string memory);
362     function symbol() external view returns (string memory);
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
367     string private _name;
368     string private _symbol;
369     string private _baseURI;
370     mapping(uint256 => string) private _tokenURIs;
371     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
372 
373     constructor (string memory name, string memory symbol) public {
374         _name = name;
375         _symbol = symbol;
376 
377         // register the supported interfaces to conform to ERC721 via ERC165
378         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
379     }
380     function name() external view returns (string memory) {
381         return _name;
382     }
383     function symbol() external view returns (string memory) {
384         return _symbol;
385     }
386     function tokenURI(uint256 tokenId) external view returns (string memory) {
387         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
388 
389         string memory _tokenURI = _tokenURIs[tokenId];
390 
391         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
392         if (bytes(_tokenURI).length == 0) {
393             return "";
394         } else {
395             // abi.encodePacked is being used to concatenate strings
396             return string(abi.encodePacked(_baseURI, _tokenURI));
397         }
398     }
399     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
400         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
401         _tokenURIs[tokenId] = _tokenURI;
402     }
403     function _setBaseURI(string memory baseURI) internal {
404         _baseURI = baseURI;
405     }
406     function baseURI() external view returns (string memory) {
407         return _baseURI;
408     }
409     function _burn(address owner, uint256 tokenId) internal {
410         super._burn(owner, tokenId);
411 
412         // Clear metadata (if any)
413         if (bytes(_tokenURIs[tokenId]).length != 0) {
414             delete _tokenURIs[tokenId];
415         }
416     }
417 }
418 
419 contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
420     constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
421         // solhint-disable-previous-line no-empty-blocks
422     }
423 }
424 
425 
426 contract Ownable is Context {
427     address private _owner;
428 
429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
430     constructor () internal {
431         address msgSender = _msgSender();
432         _owner = msgSender;
433         emit OwnershipTransferred(address(0), msgSender);
434     }
435     function owner() public view returns (address) {
436         return _owner;
437     }
438     modifier onlyOwner() {
439         require(isOwner(), "Ownable: caller is not the owner");
440         _;
441     }
442     function isOwner() public view returns (bool) {
443         return _msgSender() == _owner;
444     }
445     function renounceOwnership() public onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449     function transferOwnership(address newOwner) public onlyOwner {
450         _transferOwnership(newOwner);
451     }
452     function _transferOwnership(address newOwner) internal {
453         require(newOwner != address(0), "Ownable: new owner is the zero address");
454         emit OwnershipTransferred(_owner, newOwner);
455         _owner = newOwner;
456     }
457 }
458 
459 contract ReentrancyGuard {
460     bool private _notEntered;
461 
462     constructor () internal {
463         _notEntered = true;
464     }
465     modifier nonReentrant() {
466         require(_notEntered, "ReentrancyGuard: reentrant call");
467         _notEntered = false;
468 
469         _;
470 
471         // By storing the original value once again, a refund is triggered (see
472         // https://eips.ethereum.org/EIPS/eip-2200)
473         _notEntered = true;
474     }
475 }
476 // SPDX-License-Identifier: MIT
477 
478 
479 
480 interface IERC20 {
481     function totalSupply() external view returns (uint256);
482     function balanceOf(address account) external view returns (uint256);
483     function transfer(address recipient, uint256 amount) external returns (bool);
484     function allowance(address owner, address spender) external view returns (uint256);
485     function approve(address spender, uint256 amount) external returns (bool);
486     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
487     function decimals() external returns (uint8);
488     event Transfer(address indexed from, address indexed to, uint256 value);
489     event Approval(address indexed owner, address indexed spender, uint256 value);
490 }
491 
492 /**
493  * @title SafeERC20
494  * @dev Wrappers around ERC20 operations that throw on failure (when the token
495  * contract returns false). Tokens that return no value (and instead revert or
496  * throw on failure) are also supported, non-reverting calls are assumed to be
497  * successful.
498  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
499  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
500  */
501 library SafeERC20 {
502     using SafeMath for uint256;
503     using Address for address;
504 
505     function safeTransfer(IERC20 token, address to, uint256 value) internal {
506         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
507     }
508 
509     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
510         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
511     }
512 
513     function safeApprove(IERC20 token, address spender, uint256 value) internal {
514         // safeApprove should only be called when setting an initial allowance,
515         // or when resetting it to zero. To increase and decrease it, use
516         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
517         // solhint-disable-next-line max-line-length
518         // disabled require for making usages simple
519         //require((value == 0) || (token.allowance(address(this), spender) == 0),
520         //    "SafeERC20: approve from non-zero to non-zero allowance"
521         //);
522         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
523     }
524 
525     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
526         uint256 newAllowance = token.allowance(address(this), spender).add(value);
527         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
528     }
529 
530     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
532         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     /**
536      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
537      * on the return value: the return value is optional (but if data is returned, it must not be false).
538      * @param token The token targeted by the call.
539      * @param data The call data (encoded using abi.encode or one of its variants).
540      */
541     function callOptionalReturn(IERC20 token, bytes memory data) private {
542         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
543         // we're implementing it ourselves.
544 
545         // A Solidity high level call has three parts:
546         //  1. The target address is checked to verify it contains contract code
547         //  2. The call itself is made, and success asserted
548         //  3. The return value is decoded, which in turn checks the size of the returned data.
549         // solhint-disable-next-line max-line-length
550         require(address(token).isContract(), "SafeERC20: call to non-contract");
551 
552         // solhint-disable-next-line avoid-low-level-calls
553         (bool success, bytes memory returndata) = address(token).call(data);
554         require(success, "SafeERC20: low-level call failed");
555 
556         if (returndata.length > 0) { // Return data is optional
557             // solhint-disable-next-line max-line-length
558             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
559         }
560     }
561 }
562 
563 
564 interface IClaims {
565     function getClaimbyIndex(uint _claimId) external view returns (
566         uint claimId,
567         uint status,
568         int8 finalVerdict,
569         address claimOwner,
570         uint coverId
571     );
572     function submitClaim(uint coverId) external;
573 }
574 
575 interface IClaimsData {
576     function actualClaimLength() external view returns(uint);
577 }
578 
579 interface IDSValue {
580     function peek() external view returns (bytes32, bool);
581     function read() external view returns (bytes32);
582 }
583 
584 
585 interface INXMMaster {
586     function tokenAddress() external view returns(address);
587     function owner() external view returns(address);
588     function pauseTime() external view returns(uint);
589     function masterInitialized() external view returns(bool);
590     function isPause() external view returns(bool check);
591     function isMember(address _add) external view returns(bool);
592     function getLatestAddress(bytes2 _contractName) external view returns(address payable contractAddress);
593 }
594 
595 interface IMemberRoles {
596     function switchMembership(address) external;
597 }
598 
599 interface INXMToken {
600     function balanceOf(address owner) external view returns (uint256);
601     function approve(address spender, uint256 value) external returns (bool);
602 }
603 
604 interface IPool1  {
605     function changeDependentContractAddress() external;
606     function makeCoverBegin(
607         address smartCAdd,
608         bytes4 coverCurr,
609         uint[] calldata coverDetails,
610         uint16 coverPeriod,
611         uint8 _v,
612         bytes32 _r,
613         bytes32 _s
614     )
615         external
616         payable;
617     function makeCoverUsingCA(
618         address smartCAdd,
619         bytes4 coverCurr,
620         uint[] calldata coverDetails,
621         uint16 coverPeriod,
622         uint8 _v,
623         bytes32 _r,
624         bytes32 _s
625     )
626         external;
627     function getWei(uint amount) external view returns(uint);
628     function sellNXMTokens(uint _amount) external  returns (bool);
629 }
630 
631 
632 interface IPoolData {
633 
634     struct ApiId {
635         bytes4 typeOf;
636         bytes4 currency;
637         uint id;
638         uint64 dateAdd;
639         uint64 dateUpd;
640     }
641 
642     struct CurrencyAssets {
643         address currAddress;
644         uint baseMin;
645         uint varMin;
646     }
647 
648     struct InvestmentAssets {
649         address currAddress;
650         bool status;
651         uint64 minHoldingPercX100;
652         uint64 maxHoldingPercX100;
653         uint8 decimals;
654     }
655 
656     struct IARankDetails {
657         bytes4 maxIACurr;
658         uint64 maxRate;
659         bytes4 minIACurr;
660         uint64 minRate;
661     }
662 
663     struct McrData {
664         uint mcrPercx100;
665         uint mcrEther;
666         uint vFull; //Pool funds
667         uint64 date;
668     }
669 
670     function setCapReached(uint val) external;
671     function getInvestmentAssetDecimals(bytes4 curr) external returns(uint8 decimal);
672     function getCurrencyAssetAddress(bytes4 curr) external view returns(address);
673     function getInvestmentAssetAddress(bytes4 curr) external view returns(address);
674     function getInvestmentAssetStatus(bytes4 curr) external view returns(bool status);
675 }
676 
677 interface IQuotationData {
678 
679     enum HCIDStatus { NA, kycPending, kycPass, kycFailedOrRefunded, kycPassNoCover }
680     enum CoverStatus { Active, ClaimAccepted, ClaimDenied, CoverExpired, ClaimSubmitted, Requested }
681 
682     struct Cover {
683         address payable memberAddress;
684         bytes4 currencyCode;
685         uint sumAssured;
686         uint16 coverPeriod;
687         uint validUntil;
688         address scAddress;
689         uint premiumNXM;
690     }
691 
692     struct HoldCover {
693         uint holdCoverId;
694         address payable userAddress;
695         address scAddress;
696         bytes4 coverCurr;
697         uint[] coverDetails;
698         uint16 coverPeriod;
699     }
700 
701     function getCoverLength() external returns(uint len);
702     function getAuthQuoteEngine() external returns(address _add);
703     function getAllCoversOfUser(address _add) external returns(uint[] memory allCover);
704     function getUserCoverLength(address _add) external returns(uint len);
705     function getCoverStatusNo(uint _cid) external returns(uint8);
706     function getCoverPeriod(uint _cid) external returns(uint32 cp);
707     function getCoverSumAssured(uint _cid) external returns(uint sa);
708     function getCurrencyOfCover(uint _cid) external returns(bytes4 curr);
709     function getValidityOfCover(uint _cid) external returns(uint date);
710     function getscAddressOfCover(uint _cid) external returns(uint, address);
711     function getCoverMemberAddress(uint _cid) external returns(address payable _add);
712     function getCoverPremiumNXM(uint _cid) external returns(uint _premiumNXM);
713     function getCoverDetailsByCoverID1(
714         uint _cid
715     )
716         external
717         view
718         returns (
719             uint cid,
720             address _memberAddress,
721             address _scAddress,
722             bytes4 _currencyCode,
723             uint _sumAssured,
724             uint premiumNXM
725         );
726     function getCoverDetailsByCoverID2(
727         uint _cid
728     )
729         external
730         view
731         returns (
732             uint cid,
733             uint8 status,
734             uint sumAssured,
735             uint16 coverPeriod,
736             uint validUntil
737         );
738     function getHoldedCoverDetailsByID1(
739         uint _hcid
740     )
741         external
742         view
743         returns (
744             uint hcid,
745             address scAddress,
746             bytes4 coverCurr,
747             uint16 coverPeriod
748         );
749     function getUserHoldedCoverLength(address _add) external returns (uint);
750     function getUserHoldedCoverByIndex(address _add, uint index) external returns (uint);
751     function getHoldedCoverDetailsByID2(
752         uint _hcid
753     )
754         external
755         returns (
756             uint hcid,
757             address payable memberAddress,
758             uint[] memory coverDetails
759         );
760     function getTotalSumAssuredSC(address _add, bytes4 _curr) external returns(uint amount);
761 
762 }
763 
764 interface ITokenData {
765     function lockTokenTimeAfterCoverExp() external returns (uint);
766 }
767 
768 
769 interface IyInsure {
770     struct Token {
771         uint expirationTimestamp;
772         bytes4 coverCurrency;
773         uint coverAmount;
774         uint coverPrice;
775         uint coverPriceNXM;
776         uint expireTime;
777         uint generationTime;
778         uint coverId;
779         bool claimInProgress;
780         uint claimId;
781     }
782     
783     function transferFrom(address sender, address recipient, uint256 amount) external;
784     function submitClaim(uint256 tokenId) external;
785     function tokens(uint256 tokenId) external returns (uint, bytes4, uint, uint, uint, uint, uint, uint, bool, uint);
786 }
787 
788 /** 
789     @title Armor NFT
790     @dev Armor NFT allows users to purchase Nexus Mutual cover and convert it into 
791          a transferable token. It also allows users to swap their Yearn yNFT for Armor arNFT.
792     @author ArmorFi -- Robert M.C. Forster, Taek Lee
793 **/
794 contract arNFT is
795     ERC721Full("ArmorNFT", "arNFT"),
796     Ownable,
797     ReentrancyGuard {
798     
799     using SafeMath for uint;
800     using SafeERC20 for IERC20;
801     
802     bytes4 internal constant ethCurrency = "ETH";
803     
804     // cover Id => claim Id
805     mapping (uint256 => uint256) public claimIds;
806     
807     // cover Id => cover price
808     mapping (uint256 => uint256) public coverPrices;
809     
810     // cover Id => yNFT token Id.
811     // Used to route yNFT submits through their contract.
812     // if zero, it is not swapped from yInsure
813     mapping (uint256 => uint256) public swapIds;
814 
815     // Mapping ("NAME" => smart contract address) of allowed cover currencies.
816     mapping (bytes4 => address) public coverCurrencies;
817 
818     // indicates if swap for yInsure is available
819     // cannot go back to false
820     bool public swapActivated;
821 
822     // Nexus Mutual master contract.
823     INXMMaster public nxMaster;
824 
825     // yNFT contract that we're swapping tokens from.
826     IyInsure public ynft;
827 
828     // NXM token.
829     IERC20 public nxmToken;
830     
831     enum CoverStatus {
832         Active,
833         ClaimAccepted,
834         ClaimDenied,
835         CoverExpired,
836         ClaimSubmitted,
837         Requested
838     }
839     
840     enum ClaimStatus {
841         PendingClaimAssessorVote, // 0
842         PendingClaimAssessorVoteDenied, // 1
843         PendingClaimAssessorVoteThresholdNotReachedAccept, // 2
844         PendingClaimAssessorVoteThresholdNotReachedDeny, // 3
845         PendingClaimAssessorConsensusNotReachedAccept, // 4
846         PendingClaimAssessorConsensusNotReachedDeny, // 5
847         FinalClaimAssessorVoteDenied, // 6
848         FinalClaimAssessorVoteAccepted, // 7
849         FinalClaimAssessorVoteDeniedMVAccepted, // 8
850         FinalClaimAssessorVoteDeniedMVDenied, // 9
851         FinalClaimAssessorVotAcceptedMVNoDecision, // 10
852         FinalClaimAssessorVoteDeniedMVNoDecision, // 11
853         ClaimAcceptedPayoutPending, // 12
854         ClaimAcceptedNoPayout, // 13
855         ClaimAcceptedPayoutDone // 14
856     }
857 
858     event SwappedYInsure (
859         uint256 indexed yInsureTokenId,
860         uint256 indexed coverId
861     );
862 
863     event ClaimSubmitted (
864         uint256 indexed coverId,
865         uint256 indexed claimId
866     );
867     
868     event ClaimRedeemed (
869         address indexed receiver,
870         bytes4 indexed currency,
871         uint256 value
872     );
873 
874     event BuyCover (
875         uint indexed coverId,
876         address indexed buyer,
877         address indexed coveredContract,
878         bytes4 currency,
879         uint256 coverAmount,
880         uint256 coverPrice,
881         uint256 startTime,
882         uint16 coverPeriod
883     );
884 
885     
886     /**
887      * @dev Make sure only the owner of a token or someone approved to transfer it can call.
888      * @param _tokenId Id of the token being checked.
889     **/
890     modifier onlyTokenApprovedOrOwner(uint256 _tokenId) {
891         require(_isApprovedOrOwner(msg.sender, _tokenId), "Not approved or owner");
892         _;
893     }
894 
895     constructor(address _nxMaster, address _ynft, address _nxmToken) public {
896         nxMaster = INXMMaster(_nxMaster);
897         ynft = IyInsure(_ynft);
898         nxmToken = IERC20(_nxmToken);
899     }
900     
901     function () payable external {}
902     
903     // Arguments to be passed as coverDetails, from the quote api:
904     //    coverDetails[0] = coverAmount;
905     //    coverDetails[1] = coverPrice;
906     //    coverDetails[2] = coverPriceNXM;
907     //    coverDetails[3] = expireTime;
908     //    coverDetails[4] = generationTime;
909     /**
910      * @dev Main function to buy a cover.
911      * @param _coveredContractAddress Address of the protocol to buy cover for.
912      * @param _coverCurrency bytes4 currency name to buy coverage for.
913      * @param _coverPeriod Amount of time to buy cover for.
914      * @param _v , _r, _s Signature of the Nexus Mutual API.
915     **/
916     function buyCover(
917         address _coveredContractAddress,
918         bytes4 _coverCurrency,
919         uint[] calldata _coverDetails,
920         uint16 _coverPeriod,
921         uint8 _v,
922         bytes32 _r,
923         bytes32 _s
924     ) external payable {
925         uint256 coverPrice = _coverDetails[1];
926 
927         if (_coverCurrency == "ETH") {
928             require(msg.value == coverPrice, "Incorrect value sent");
929         } else {
930             IERC20 erc20 = IERC20( coverCurrencies[_coverCurrency] );
931             require(erc20 != IERC20( address(0) ), "Cover currency is not allowed.");
932 
933             require(msg.value == 0, "Eth not required when buying with erc20");
934             erc20.safeTransferFrom(msg.sender, address(this), coverPrice);
935         }
936         
937         uint256 coverId = _buyCover(_coveredContractAddress, _coverCurrency, _coverDetails, _coverPeriod, _v, _r, _s);
938         _mint(msg.sender, coverId);
939         
940         emit BuyCover(coverId, msg.sender, _coveredContractAddress, _coverCurrency, _coverDetails[0], _coverDetails[1], 
941                       block.timestamp, _coverPeriod);
942     }
943     
944     /**
945      * @dev Submit a claim for the NFT after a hack has happened on its protocol.
946      * @param _tokenId ID of the token a claim is being submitted for.
947     **/
948     function submitClaim(uint256 _tokenId) external onlyTokenApprovedOrOwner(_tokenId) {
949         // If this was a yNFT swap, we must route the submit through them.
950         if (swapIds[_tokenId] != 0) {
951             _submitYnftClaim(_tokenId);
952             return;
953         }
954         
955         (uint256 coverId, /*uint8 coverStatus*/, /*sumAssured*/, /*coverPeriod*/, /*uint256 validUntil*/) = _getCover2(_tokenId);
956 
957         uint256 claimId = _submitClaim(coverId);
958         claimIds[_tokenId] = claimId;
959         
960         emit ClaimSubmitted(coverId, claimId);
961     }
962     
963     /**
964      * @dev Redeem a claim that has been accepted and paid out.
965      * @param _tokenId Id of the token to redeem claim for.
966     **/
967     function redeemClaim(uint256 _tokenId) public onlyTokenApprovedOrOwner(_tokenId)  nonReentrant {
968         require(claimIds[_tokenId] != 0, "No claim is in progress.");
969         
970         (/*cid*/, /*memberAddress*/, /*scAddress*/, bytes4 currencyCode, /*sumAssured*/, /*premiumNXM*/) = _getCover1(_tokenId);
971         ( , /*uint8 coverStatus*/, uint256 sumAssured, , ) = _getCover2(_tokenId);
972         
973         require(_payoutIsCompleted(claimIds[_tokenId]), "Claim accepted but payout not completed");
974        
975         // this will prevent duplicate redeem 
976         _burn(_tokenId);
977         _sendAssuredSum(currencyCode, sumAssured);
978         
979         emit ClaimRedeemed(msg.sender, currencyCode, sumAssured);
980     }
981     
982     function activateSwap()
983       public
984       onlyOwner
985     {
986         require(!swapActivated, "Already Activated");
987         swapActivated = true;
988     }
989 
990     /**
991      * @dev External swap yNFT token for our own. Simple process because we do not need to create cover.
992      * @param _ynftTokenId The ID of the token on yNFT's contract.
993     **/
994     function swapYnft(uint256 _ynftTokenId)
995       public
996     {
997         require(swapActivated, "Swap is not activated yet");
998         //this does not returns bool
999         ynft.transferFrom(msg.sender, address(this), _ynftTokenId);
1000         
1001         (uint256 coverPrice, uint256 coverId, uint256 claimId) = _getCoverAndClaim(_ynftTokenId);
1002 
1003         _mint(msg.sender, coverId);
1004 
1005         swapIds[coverId] = _ynftTokenId;
1006         claimIds[coverId] = claimId;
1007         coverPrices[coverId] = coverPrice;
1008         
1009         emit SwappedYInsure(_ynftTokenId, coverId);
1010     }
1011     
1012     /**
1013      * @dev Swaps a batch of yNFT tokens for our own.
1014      * @param _tokenIds An array of the IDs of the tokens on yNFT's contract.
1015     **/
1016     function batchSwapYnft(uint256[] calldata _tokenIds)
1017       external
1018     {
1019         for (uint256 i = 0; i < _tokenIds.length; i++) {
1020             swapYnft(_tokenIds[i]);
1021         }
1022     }
1023     
1024    /**
1025      * @dev Owner can approve the contract for any new ERC20 (so we don't need to in every buy).
1026      * @param _tokenAddress Address of the ERC20 that we want approved.
1027     **/
1028     function approveToken(address _tokenAddress)
1029       external
1030     {
1031         IPool1 pool1 = IPool1(nxMaster.getLatestAddress("P1"));
1032         address payable pool1Address = address(uint160(address(pool1)));
1033         IERC20 erc20 = IERC20(_tokenAddress);
1034         erc20.safeApprove( pool1Address, uint256(-1) );
1035     }
1036     
1037     /**
1038      * @dev Getter for all token info from Nexus Mutual.
1039      * @param _tokenId of the token to get cover info for (also NXM cover ID).
1040      * @return All info from NXM about the cover.
1041     **/
1042     function getToken(uint256 _tokenId)
1043       external
1044       view
1045     returns (uint256 cid, 
1046              uint8 status, 
1047              uint256 sumAssured,
1048              uint16 coverPeriod, 
1049              uint256 validUntil, 
1050              address scAddress, 
1051              bytes4 currencyCode, 
1052              uint256 premiumNXM,
1053              uint256 coverPrice,
1054              uint256 claimId)
1055     {
1056         (/*cid*/, /*memberAddress*/, scAddress, currencyCode, /*sumAssured*/, premiumNXM) = _getCover1(_tokenId);
1057         (cid, status, sumAssured, coverPeriod, validUntil) = _getCover2(_tokenId);
1058         coverPrice = coverPrices[_tokenId];
1059         claimId = claimIds[_tokenId];
1060     }
1061     
1062     /**
1063      * @dev Get status of a cover claim.
1064      * @param _tokenId Id of the token we're checking.
1065      * @return Status of the claim being made on the token.
1066     **/
1067     function getCoverStatus(uint256 _tokenId) external view returns (uint8 coverStatus, bool payoutCompleted) {
1068         (, coverStatus, , , ) = _getCover2(_tokenId);
1069         payoutCompleted = _payoutIsCompleted(claimIds[_tokenId]);
1070     }
1071     
1072     /**
1073      * @dev Get address of the NXM Member Roles contract.
1074      * @return Address of the current Member Roles contract.
1075     **/
1076     function getMemberRoles() public view returns (address) {
1077         return nxMaster.getLatestAddress("MR");
1078     }
1079     
1080     /**
1081      * @dev Change membership to new address.
1082      * @param _newMembership Membership address to change to.
1083     **/
1084     function switchMembership(address _newMembership) external onlyOwner {
1085         nxmToken.safeApprove(getMemberRoles(),uint(-1));
1086         IMemberRoles(getMemberRoles()).switchMembership(_newMembership);
1087     }
1088     
1089     /**
1090      * @dev Internal function for buying cover--params are same as eponymous external function.
1091      * @return coverId ID of the new cover that has been bought.
1092     **/
1093     function _buyCover(
1094         address _coveredContractAddress,
1095         bytes4 _coverCurrency,
1096         uint[] memory _coverDetails,
1097         uint16 _coverPeriod,
1098         uint8 _v,
1099         bytes32 _r,
1100         bytes32 _s
1101     ) internal returns (uint256 coverId) {
1102     
1103         uint256 coverPrice = _coverDetails[1];
1104         IPool1 pool1 = IPool1(nxMaster.getLatestAddress("P1"));
1105 
1106         if (_coverCurrency == "ETH") {
1107             pool1.makeCoverBegin.value(coverPrice)(_coveredContractAddress, _coverCurrency, _coverDetails, _coverPeriod, _v, _r, _s);
1108         } else {
1109             pool1.makeCoverUsingCA(_coveredContractAddress, _coverCurrency, _coverDetails, _coverPeriod, _v, _r, _s);
1110         }
1111     
1112         IQuotationData quotationData = IQuotationData(nxMaster.getLatestAddress("QD"));
1113         // *assumes* the newly created claim is appended at the end of the list covers
1114         coverId = quotationData.getCoverLength().sub(1);
1115         
1116         // Keep track of how much was paid for this cover.
1117         coverPrices[coverId] = coverPrice;
1118     }
1119     
1120     /**
1121      * @dev Internal submit claim function.
1122      * @param _coverId on the NXM contract (same as our token ID).
1123      * @return claimId of the new claim.
1124     **/
1125     function _submitClaim(uint256 _coverId) internal returns (uint256) {
1126         IClaims claims = IClaims(nxMaster.getLatestAddress("CL"));
1127         claims.submitClaim(_coverId);
1128     
1129         IClaimsData claimsData = IClaimsData(nxMaster.getLatestAddress("CD"));
1130         uint256 claimId = claimsData.actualClaimLength() - 1;
1131         return claimId;
1132     }
1133     
1134     /**
1135      * Submits a claim through yNFT if this was a swapped token.
1136      * @param _tokenId ID of the token on the arNFT contract.
1137     **/
1138     function _submitYnftClaim(uint256 _tokenId)
1139       internal
1140     {
1141         uint256 ynftTokenId = swapIds[_tokenId];
1142         ynft.submitClaim(ynftTokenId);
1143         
1144         (/*coverPrice*/, /*coverId*/, uint256 claimId) = _getCoverAndClaim(ynftTokenId);
1145         claimIds[_tokenId] = claimId;
1146     }
1147 
1148     /**
1149      * @dev Check whether the payout of a claim has occurred.
1150      * @param _claimId ID of the claim we are checking.
1151      * @return True if claim has been paid out, false if not.
1152     **/
1153     function _payoutIsCompleted(uint256 _claimId) internal view returns (bool) {
1154         uint256 status;
1155         IClaims claims = IClaims(nxMaster.getLatestAddress("CL"));
1156         (, status, , , ) = claims.getClaimbyIndex(_claimId);
1157         return status == uint256(ClaimStatus.ClaimAcceptedPayoutDone);
1158     }
1159 
1160     /**
1161      * @dev Send tokens after a successful redeem claim.
1162      * @param _coverCurrency bytes4 of the currency being used.
1163      * @param _sumAssured The amount of the currency to send.
1164     **/
1165     function _sendAssuredSum(bytes4 _coverCurrency, uint256 _sumAssured) internal {
1166         uint256 claimReward;
1167 
1168         if (_coverCurrency == ethCurrency) {
1169             claimReward = _sumAssured * (10 ** 18);
1170             msg.sender.transfer(claimReward);
1171         } else {
1172             IERC20 erc20 = IERC20( coverCurrencies[_coverCurrency] );
1173             require (erc20 != IERC20( address(0) ), "Cover currency is not allowed.");
1174 
1175             uint256 decimals = uint256(erc20.decimals());
1176             claimReward = _sumAssured * (10 ** decimals);
1177             erc20.safeTransfer(msg.sender, claimReward);
1178         }
1179     }
1180     
1181     /**
1182      * @dev Get the cover Id and claim Id of the token from the ynft contract.
1183      * @param _ynftTokenId The Id of the token on the ynft contract.
1184     **/
1185     function _getCoverAndClaim(uint256 _ynftTokenId)
1186       internal
1187     returns (uint256 coverPrice, uint256 coverId, uint256 claimId)
1188     {
1189        ( , , , coverPrice, , , , coverId, , claimId) = ynft.tokens(_ynftTokenId);
1190     }
1191     
1192     /**
1193      * @dev Get (some) cover details from the NXM contracts.
1194      * @param _coverId ID of the cover to get--same as our token ID.
1195      * @return Details about the token.
1196     **/
1197     function _getCover1 (
1198         uint256 _coverId
1199     ) internal view returns (
1200         uint256 cid,
1201         address memberAddress,
1202         address scAddress,
1203         bytes4 currencyCode,
1204         uint256 sumAssured,
1205         uint256 premiumNXM
1206     ) {
1207         IQuotationData quotationData = IQuotationData(nxMaster.getLatestAddress("QD"));
1208         return quotationData.getCoverDetailsByCoverID1(_coverId);
1209     }
1210     
1211     /**
1212      * @dev Get the rest of the cover details from NXM contracts.
1213      * @param _coverId ID of the cover to get--same as our token ID.
1214      * @return 2nd set of details about the token.
1215     **/
1216     function _getCover2 (
1217         uint256 _coverId
1218     ) internal view returns (
1219         uint256 cid,
1220         uint8 status,
1221         uint256 sumAssured,
1222         uint16 coverPeriod,
1223         uint256 validUntil
1224     ) {
1225         IQuotationData quotationData = IQuotationData(nxMaster.getLatestAddress("QD"));
1226         return quotationData.getCoverDetailsByCoverID2(_coverId);
1227     }
1228     
1229     /**
1230      * @dev Approve an address to spend NXM tokens from the contract.
1231      * @param _spender Address to be approved.
1232      * @param _value The amount of NXM to be approved.
1233     **/
1234     function nxmTokenApprove(address _spender, uint256 _value) public onlyOwner {
1235         nxmToken.safeApprove(_spender, _value);
1236     }
1237 
1238     /**
1239      * @dev Add an allowed cover currency to the arNFT system if one is added to Nexus Mutual.
1240      * @param _coverCurrency Address of the cover currency to add.
1241     **/
1242     function addCurrency(bytes4 _coverCurrency, address _coverCurrencyAddress) public onlyOwner {
1243         require(coverCurrencies[_coverCurrency] == address(0), "Cover currency already exists.");
1244         coverCurrencies[_coverCurrency] = _coverCurrencyAddress;
1245     }
1246 
1247 }