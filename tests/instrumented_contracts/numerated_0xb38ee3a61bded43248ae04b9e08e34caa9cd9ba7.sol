1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface AggregatorV3Interface {
5     function decimals() external view returns (uint8);
6     function description() external view returns (string memory);
7     function version() external view returns (uint256);
8     function getRoundData(uint80 _roundId) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
9     function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
10 }
11 
12 interface IERC165 {
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 
16 interface IERC721 is IERC165 {
17     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
18     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
19     function balanceOf(address owner) external view returns (uint256 balance);
20     function ownerOf(uint256 tokenId) external view returns (address owner);
21     function approve(address to, uint256 tokenId) external;
22     function setApprovalForAll(address operator, bool _approved) external;
23     function getApproved(uint256 tokenId) external view returns (address operator);
24     function isApprovedForAll(address owner, address operator) external view returns (bool);
25 }
26 
27 interface IERC721Receiver {
28     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
29 }
30 
31 interface IERC721Metadata is IERC721 {
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function tokenURI(uint256 tokenId) external view returns (string memory);
35 }
36 
37 library Address {
38     function isContract(address account) internal view returns (bool) {
39         return account.code.length > 0;
40     }
41 
42     function sendValue(address payable recipient, uint256 amount) internal {
43         require(address(this).balance >= amount, "Address: insufficient balance");
44 
45         (bool success, ) = recipient.call{value: amount}("");
46         require(success, "Address: unable to send value, recipient may have reverted");
47     }
48 
49     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
50         return functionCall(target, data, "Address: low-level call failed");
51     }
52 
53     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
54         return functionCallWithValue(target, data, 0, errorMessage);
55     }
56 
57     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
58         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
59     }
60 
61     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
62         require(address(this).balance >= value, "Address: insufficient balance for call");
63         require(isContract(target), "Address: call to non-contract");
64         (bool success, bytes memory returndata) = target.call{value: value}(data);
65         return verifyCallResult(success, returndata, errorMessage);
66     }
67 
68     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
69         return functionStaticCall(target, data, "Address: low-level static call failed");
70     }
71 
72     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
73         require(isContract(target), "Address: static call to non-contract");
74         (bool success, bytes memory returndata) = target.staticcall(data);
75         return verifyCallResult(success, returndata, errorMessage);
76     }
77 
78     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
79         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
80     }
81 
82     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
83         require(isContract(target), "Address: delegate call to non-contract");
84         (bool success, bytes memory returndata) = target.delegatecall(data);
85         return verifyCallResult(success, returndata, errorMessage);
86     }
87 
88     function verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) internal pure returns (bytes memory) {
89         if (success) {
90             return returndata;
91         } else {
92             if (returndata.length > 0) {
93                 assembly {
94                     let returndata_size := mload(returndata)
95                     revert(add(32, returndata), returndata_size)
96                 }
97             } else {
98                 revert(errorMessage);
99             }
100         }
101     }
102 }
103 
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 library Strings {
115     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
116     uint8 private constant _ADDRESS_LENGTH = 20;
117 
118     function toString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0";
121         }
122         uint256 temp = value;
123         uint256 digits;
124         while (temp != 0) {
125             digits++;
126             temp /= 10;
127         }
128         bytes memory buffer = new bytes(digits);
129         while (value != 0) {
130             digits -= 1;
131             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
132             value /= 10;
133         }
134         return string(buffer);
135     }
136 
137     function toHexString(uint256 value) internal pure returns (string memory) {
138         if (value == 0) {
139             return "0x00";
140         }
141         uint256 temp = value;
142         uint256 length = 0;
143         while (temp != 0) {
144             length++;
145             temp >>= 8;
146         }
147         return toHexString(value, length);
148     }
149 
150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
151         bytes memory buffer = new bytes(2 * length + 2);
152         buffer[0] = "0";
153         buffer[1] = "x";
154         for (uint256 i = 2 * length + 1; i > 1; --i) {
155             buffer[i] = _HEX_SYMBOLS[value & 0xf];
156             value >>= 4;
157         }
158         require(value == 0, "Strings: hex length insufficient");
159         return string(buffer);
160     }
161 
162     function toHexString(address addr) internal pure returns (string memory) {
163         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
164     }
165 }
166 
167 abstract contract ERC165 is IERC165 {
168     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
169         return interfaceId == type(IERC165).interfaceId;
170     }
171 }
172 
173 abstract contract AC {
174     address internal owner;
175     constructor(address _owner) {
176         owner = _owner;
177     }
178     modifier onlyOwner() {
179         require(isOwner(msg.sender), "!OWNER");
180         _;
181     }
182     function isOwner(address account) public view returns (bool) {
183         return account == owner;
184     }
185     function transferOwnership(address payable adr) public onlyOwner {
186         owner = adr;
187         emit OwnershipTransferred(adr);
188     }
189     event OwnershipTransferred(address owner);
190 }
191 
192 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, AC {
193     using Address for address;
194     using Strings for uint256;
195 
196     string private _name;
197 
198     string private _symbol;
199 
200     string private _base = "https://cdn.theannuity.io/";
201 
202     mapping(uint256 => address) internal _owners;
203 
204     mapping(address => uint256) internal _balances;
205 
206     mapping(uint256 => address) private _tokenApprovals;
207 
208     mapping(address => mapping(address => bool)) private _operatorApprovals;
209 
210     constructor(string memory name_, string memory symbol_, address _owner) AC(_owner) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214 
215     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
216         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
217     }
218 
219     function balanceOf(address owner) public view virtual override returns (uint256) {
220         require(owner != address(0), "ERC721: address zero is not a valid owner");
221         return _balances[owner];
222     }
223 
224     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
225         address owner = _owners[tokenId];
226         require(owner != address(0), "ERC721: owner query for nonexistent token");
227         return owner;
228     }
229 
230     function name() public view virtual override returns (string memory) {
231         return _name;
232     }
233 
234     function symbol() public view virtual override returns (string memory) {
235         return _symbol;
236     }
237 
238     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
239         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
240         string memory baseURI = _baseURI();
241         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
242     }
243 
244     function _baseURI() internal view virtual returns (string memory) {
245         return _base;
246     }
247 
248     function changeBaseURI(string memory _baseNew) external onlyOwner {
249         _base = _baseNew;
250     }
251 
252     function approve(address to, uint256 tokenId) public virtual override {
253         address owner = ERC721.ownerOf(tokenId);
254         require(to != owner, "ERC721: approval to current owner");
255         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");
256         _approve(to, tokenId);
257     }
258 
259     function getApproved(uint256 tokenId) public view virtual override returns (address) {
260         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
261         return _tokenApprovals[tokenId];
262     }
263 
264     function setApprovalForAll(address operator, bool approved) public virtual override {
265         _setApprovalForAll(_msgSender(), operator, approved);
266     }
267 
268     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
269         return _operatorApprovals[owner][operator];
270     }
271 
272     function _exists(uint256 tokenId) internal view virtual returns (bool) {
273         return _owners[tokenId] != address(0);
274     }
275 
276     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
277         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
278         address owner = ERC721.ownerOf(tokenId);
279         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
280     }
281 
282     function _safeMint(address to, uint256 tokenId) internal virtual {
283         _safeMint(to, tokenId, "");
284     }
285 
286     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
287         _mint(to, tokenId);
288         require(_checkOnERC721Received(address(0), to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
289     }
290 
291     function _mint(address to, uint256 tokenId) internal virtual {
292         require(to != address(0), "ERC721: mint to the zero address");
293         require(!_exists(tokenId), "ERC721: token already minted");
294         _balances[to] += 1;
295         _owners[tokenId] = to;
296     }
297 
298     function _approve(address to, uint256 tokenId) internal virtual {
299         _tokenApprovals[tokenId] = to;
300         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
301     }
302 
303     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
304         require(owner != operator, "ERC721: approve to caller");
305         _operatorApprovals[owner][operator] = approved;
306         emit ApprovalForAll(owner, operator, approved);
307     }
308 
309     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) internal returns (bool) {
310         if (to.isContract()) {
311             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
312                 return retval == IERC721Receiver.onERC721Received.selector;
313             } catch (bytes memory reason) {
314                 if (reason.length == 0) {
315                     revert("ERC721: transfer to non ERC721Receiver implementer");
316                 } else {
317                     assembly {
318                         revert(add(32, reason), mload(reason))
319                     }
320                 }
321             }
322         } else {
323             return true;
324         }
325     }
326 }
327 
328 library Counters {
329     struct Counter {
330         uint256 _value;
331     }
332 
333     function current(Counter storage counter) internal view returns (uint256) {
334         return counter._value;
335     }
336 
337     function increment(Counter storage counter) internal {
338         unchecked {
339             counter._value += 1;
340         }
341     }
342 
343     function decrement(Counter storage counter) internal {
344         uint256 value = counter._value;
345         require(value > 0, "Counter: decrement overflow");
346         unchecked {
347             counter._value = value - 1;
348         }
349     }
350 
351     function reset(Counter storage counter) internal {
352         counter._value = 0;
353     }
354 }
355 
356 abstract contract ERC721URIStorage is ERC721 {
357     using Strings for uint256;
358     mapping(uint256 => string) private _tokenURIs;
359 
360     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
361         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
362         string memory _tokenURI = _tokenURIs[tokenId];
363         string memory base = _baseURI();
364         if (bytes(base).length == 0) {
365             return _tokenURI;
366         }
367         if (bytes(_tokenURI).length > 0) {
368             return string(abi.encodePacked(base, _tokenURI));
369         }
370         return super.tokenURI(tokenId);
371     }
372 
373     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
374         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
375         _tokenURIs[tokenId] = _tokenURI;
376     }
377 }
378 
379 library SafeMath {
380     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
381         unchecked {
382             uint256 c = a + b;
383             if (c < a) return (false, 0);
384             return (true, c);
385         }
386     }
387     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         unchecked {
389             if (b > a) return (false, 0);
390             return (true, a - b);
391         }
392     }
393     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         unchecked {
395             if (a == 0) return (true, 0);
396             uint256 c = a * b;
397             if (c / a != b) return (false, 0);
398             return (true, c);
399         }
400     }
401     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
402         unchecked {
403             if (b == 0) return (false, 0);
404             return (true, a / b);
405         }
406     }
407     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
408         unchecked {
409             if (b == 0) return (false, 0);
410             return (true, a % b);
411         }
412     }
413     function add(uint256 a, uint256 b) internal pure returns (uint256) {
414         return a + b;
415     }
416     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
417         return a - b;
418     }
419     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
420         return a * b;
421     }
422     function div(uint256 a, uint256 b) internal pure returns (uint256) {
423         return a / b;
424     }
425     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
426         return a % b;
427     }
428     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         unchecked {
430             require(b <= a, errorMessage);
431             return a - b;
432         }
433     }
434     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
435         unchecked {
436             require(b > 0, errorMessage);
437             return a / b;
438         }
439     }
440     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
441         unchecked {
442             require(b > 0, errorMessage);
443             return a % b;
444         }
445     }
446 }
447 
448 interface IERC20 {
449     function totalSupply() external view returns (uint256);
450     function decimals() external view returns (uint8);
451     function symbol() external view returns (string memory);
452     function name() external view returns (string memory);
453     function getOwner() external view returns (address);
454     function balanceOf(address account) external view returns (uint256);
455     function transfer(address recipient, uint256 amount) external returns (bool);
456     function allowance(address _owner, address spender) external view returns (uint256);
457     function approve(address spender, uint256 amount) external returns (bool);
458     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
459     event Transfer(address indexed from, address indexed to, uint256 value);
460     event Approval(address indexed owner, address indexed spender, uint256 value);
461 }
462 
463 interface IUniswapV2Factory {
464     function createPair(address tokenA, address tokenB) external returns (address pair);
465     function getPair(address tokenA, address tokenB) external view returns (address pair);
466 }
467 
468 interface IUniswapV2Router {
469     function factory() external pure returns (address);
470     function WETH() external pure returns (address);
471     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
472     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable;
473     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
474 }
475 
476 interface INetwork {
477     function setShare(address shareholder, uint256 amount) external;
478     function deposit() external payable;
479 }
480 
481 contract Network1 is INetwork, AC {
482     using SafeMath for uint256;
483     uint256 internal constant max = 2**256 - 1;
484     address _token;
485     struct Share {
486         uint256 amount;
487         uint256 totalExcluded;
488         uint256 totalRealised;
489     }
490     IERC20 BASE;
491     IUniswapV2Router router;
492     address[] shareholders;
493     mapping (address => uint256) shareholderIndexes;
494     mapping (address => uint256) public totalRewardsDistributed;
495     mapping (address => mapping (address => uint256)) public totalRewardsToUser;
496     mapping (address => bool) public allowed;
497     mapping (address => Share) public shares;
498     uint256 public totalShares;
499     uint256 public totalDividends;
500     uint256 public totalDistributed;
501     uint256 public dividendsPerShare;
502     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
503 
504     modifier onlyToken() {
505         require(msg.sender == _token);
506         _;
507     }
508 
509     constructor (address _router, address _owner, address _weth) AC(_owner) {
510         router = _router != address(0) ? IUniswapV2Router(_router) : IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
511         _token = msg.sender;
512         allowed[_weth] = true;
513         BASE = IERC20(_weth);
514         BASE.approve(_router, max);
515     }
516 
517     receive() external payable {}
518 
519     function getClaimedDividendsTotal(address token) public view returns (uint256) {
520         return totalRewardsDistributed[token];
521     }
522 
523     function getClaimedDividends(address token, address user) public view returns (uint256) {
524         return totalRewardsToUser[token][user];
525     }
526 
527     function changeRouterVersion(address _router) external onlyOwner {
528         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(_router);
529         router = _uniswapV2Router;
530     }
531 
532     function setShare(address shareholder, uint256 amount) external override onlyToken {
533         if (amount > 0 && shares[shareholder].amount == 0) addShareholder(shareholder);
534         else if (amount == 0 && shares[shareholder].amount > 0) removeShareholder(shareholder);
535         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
536         shares[shareholder].amount = amount;
537         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
538     }
539 
540     function deposit() external payable override onlyToken {
541         uint256 amount = msg.value;
542         totalDividends = totalDividends.add(amount);
543         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
544     }
545 
546     function distributeDividend(address shareholder, address rewardAddress) internal {
547         require(allowed[rewardAddress], "Invalid reward address!");
548         if (shares[shareholder].amount == 0) {
549             return;
550         }
551         uint256 amount = getPendingDividend(shareholder);
552         if (amount > 0) {
553             totalDistributed = totalDistributed.add(amount);
554             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
555             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
556             if (rewardAddress == address(BASE)) {
557                 payable(shareholder).transfer(amount);
558                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(amount);  
559                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(amount);
560             }
561         }
562     }
563 
564     function claimDividend(address claimer, address rewardAddress) external onlyToken {
565         distributeDividend(claimer, rewardAddress);
566     }
567 
568     function getPendingDividend(address shareholder) public view returns (uint256) {
569         if (shares[shareholder].amount == 0) return 0;
570         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
571         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
572         if (shareholderTotalDividends <= shareholderTotalExcluded) return 0;
573         return shareholderTotalDividends.sub(shareholderTotalExcluded);
574     }
575 
576     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
577         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
578     }
579 
580     function addShareholder(address shareholder) internal {
581         shareholderIndexes[shareholder] = shareholders.length;
582         shareholders.push(shareholder);
583     }
584 
585     function removeShareholder(address shareholder) internal {
586         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
587         shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
588         shareholders.pop();
589     }
590 
591     function changeBASE(address _BASE) external onlyOwner {
592         BASE = IERC20(_BASE);
593     }
594 
595     function drainGas() external onlyOwner {
596         payable(msg.sender).transfer(address(this).balance);
597     }
598 
599     function drainToken(address _address, address _to) external onlyOwner {
600         IERC20(_address).transfer(_to, IERC20(_address).balanceOf(address(this)));
601     }
602 }
603 
604 contract Network2 is INetwork, AC {
605     using SafeMath for uint256;
606     uint256 internal constant max = 2**256 - 1;
607     address _token;
608     struct Share {
609         uint256 amount;
610         uint256 totalExcluded;
611         uint256 totalRealised;
612     }
613     IERC20 BASE;
614     IUniswapV2Router router;
615     address[] shareholders;
616     mapping (address => uint256) shareholderIndexes;
617     mapping (address => uint256) public totalRewardsDistributed;
618     mapping (address => mapping (address => uint256)) public totalRewardsToUser;
619     mapping (address => bool) public allowed;
620     mapping (address => Share) public shares;
621     uint256 public totalShares;
622     uint256 public totalDividends;
623     uint256 public totalDistributed;
624     uint256 public dividendsPerShare;
625     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
626 
627     modifier onlyToken() {
628         require(msg.sender == _token);
629         _;
630     }
631 
632     constructor (address _router, address _owner, address _weth) AC(_owner) {
633         router = _router != address(0) ? IUniswapV2Router(_router) : IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
634         _token = msg.sender;
635         allowed[_weth] = true;
636         BASE = IERC20(_weth);
637         BASE.approve(_router, max);
638     }
639 
640     receive() external payable {}
641 
642     function getClaimedDividendsTotal(address token) public view returns (uint256) {
643         return totalRewardsDistributed[token];
644     }
645 
646     function getClaimedDividends(address token, address user) public view returns (uint256) {
647         return totalRewardsToUser[token][user];
648     }
649 
650     function changeRouterVersion(address _router) external onlyOwner {
651         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(_router);
652         router = _uniswapV2Router;
653     }
654 
655     function setShare(address shareholder, uint256 amount) external override onlyToken {
656         if (amount > 0 && shares[shareholder].amount == 0) addShareholder(shareholder);
657         else if (amount == 0 && shares[shareholder].amount > 0) removeShareholder(shareholder);
658         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
659         shares[shareholder].amount = amount;
660         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
661     }
662 
663     function deposit() external payable override onlyToken {
664         uint256 amount = msg.value;
665         totalDividends = totalDividends.add(amount);
666         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
667     }
668 
669     function distributeDividend(address shareholder, address rewardAddress) internal {
670         require(allowed[rewardAddress], "Invalid reward address!");
671         if (shares[shareholder].amount == 0) {
672             return;
673         }
674         uint256 amount = getPendingDividend(shareholder);
675         if (amount > 0) {
676             totalDistributed = totalDistributed.add(amount);
677             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
678             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
679             if (rewardAddress == address(BASE)) {
680                 payable(shareholder).transfer(amount);
681                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(amount);  
682                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(amount);
683             }
684         }
685     }
686 
687     function claimDividend(address claimer, address rewardAddress) external onlyToken {
688         distributeDividend(claimer, rewardAddress);
689     }
690 
691     function getPendingDividend(address shareholder) public view returns (uint256) {
692         if (shares[shareholder].amount == 0) return 0;
693         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
694         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
695         if (shareholderTotalDividends <= shareholderTotalExcluded) return 0;
696         return shareholderTotalDividends.sub(shareholderTotalExcluded);
697     }
698 
699     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
700         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
701     }
702 
703     function addShareholder(address shareholder) internal {
704         shareholderIndexes[shareholder] = shareholders.length;
705         shareholders.push(shareholder);
706     }
707 
708     function removeShareholder(address shareholder) internal {
709         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
710         shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
711         shareholders.pop();
712     }
713 
714     function changeBASE(address _BASE) external onlyOwner {
715         BASE = IERC20(_BASE);
716     }
717 
718     function drainGas() external onlyOwner {
719         payable(msg.sender).transfer(address(this).balance);
720     }
721 
722     function drainToken(address _address, address _to) external onlyOwner {
723         IERC20(_address).transfer(_to, IERC20(_address).balanceOf(address(this)));
724     }
725 }
726 
727 contract Network3 is INetwork, AC {
728     using SafeMath for uint256;
729     uint256 internal constant max = 2**256 - 1;
730     address _token;
731     struct Share {
732         uint256 amount;
733         uint256 totalExcluded;
734         uint256 totalRealised;
735     }
736     IERC20 BASE;
737     IUniswapV2Router router;
738     address[] shareholders;
739     mapping (address => uint256) shareholderIndexes;
740     mapping (address => uint256) public totalRewardsDistributed;
741     mapping (address => mapping (address => uint256)) public totalRewardsToUser;
742     mapping (address => bool) public allowed;
743     mapping (address => Share) public shares;
744     uint256 public totalShares;
745     uint256 public totalDividends;
746     uint256 public totalDistributed;
747     uint256 public dividendsPerShare;
748     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
749 
750     modifier onlyToken() {
751         require(msg.sender == _token);
752         _;
753     }
754 
755     constructor (address _router, address _owner, address _weth) AC(_owner) {
756         router = _router != address(0) ? IUniswapV2Router(_router) : IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
757         _token = msg.sender;
758         allowed[_weth] = true;
759         BASE = IERC20(_weth);
760         BASE.approve(_router, max);
761     }
762 
763     receive() external payable {}
764 
765     function getClaimedDividendsTotal(address token) public view returns (uint256) {
766         return totalRewardsDistributed[token];
767     }
768 
769     function getClaimedDividends(address token, address user) public view returns (uint256) {
770         return totalRewardsToUser[token][user];
771     }
772 
773     function changeRouterVersion(address _router) external onlyOwner {
774         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(_router);
775         router = _uniswapV2Router;
776     }
777 
778     function setShare(address shareholder, uint256 amount) external override onlyToken {
779         if (amount > 0 && shares[shareholder].amount == 0) addShareholder(shareholder);
780         else if (amount == 0 && shares[shareholder].amount > 0) removeShareholder(shareholder);
781         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
782         shares[shareholder].amount = amount;
783         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
784     }
785 
786     function deposit() external payable override onlyToken {
787         uint256 amount = msg.value;
788         totalDividends = totalDividends.add(amount);
789         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
790     }
791 
792     function distributeDividend(address shareholder, address rewardAddress) internal {
793         require(allowed[rewardAddress], "Invalid reward address!");
794         if (shares[shareholder].amount == 0) {
795             return;
796         }
797         uint256 amount = getPendingDividend(shareholder);
798         if (amount > 0) {
799             totalDistributed = totalDistributed.add(amount);
800             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
801             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
802             if (rewardAddress == address(BASE)) {
803                 payable(shareholder).transfer(amount);
804                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(amount);  
805                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(amount);
806             }
807         }
808     }
809 
810     function claimDividend(address claimer, address rewardAddress) external onlyToken {
811         distributeDividend(claimer, rewardAddress);
812     }
813 
814     function getPendingDividend(address shareholder) public view returns (uint256) {
815         if (shares[shareholder].amount == 0) return 0;
816         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
817         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
818         if (shareholderTotalDividends <= shareholderTotalExcluded) return 0;
819         return shareholderTotalDividends.sub(shareholderTotalExcluded);
820     }
821 
822     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
823         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
824     }
825 
826     function addShareholder(address shareholder) internal {
827         shareholderIndexes[shareholder] = shareholders.length;
828         shareholders.push(shareholder);
829     }
830 
831     function removeShareholder(address shareholder) internal {
832         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
833         shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
834         shareholders.pop();
835     }
836 
837     function changeBASE(address _BASE) external onlyOwner {
838         BASE = IERC20(_BASE);
839     }
840 
841     function drainGas() external onlyOwner {
842         payable(msg.sender).transfer(address(this).balance);
843     }
844 
845     function drainToken(address _address, address _to) external onlyOwner {
846         IERC20(_address).transfer(_to, IERC20(_address).balanceOf(address(this)));
847     }
848 }
849 
850 contract Network4 is INetwork, AC {
851     using SafeMath for uint256;
852     uint256 internal constant max = 2**256 - 1;
853     address _token;
854     struct Share {
855         uint256 amount;
856         uint256 totalExcluded;
857         uint256 totalRealised;
858     }
859     IERC20 BASE;
860     IUniswapV2Router router;
861     address[] shareholders;
862     mapping (address => uint256) shareholderIndexes;
863     mapping (address => uint256) public totalRewardsDistributed;
864     mapping (address => mapping (address => uint256)) public totalRewardsToUser;
865     mapping (address => bool) public allowed;
866     mapping (address => Share) public shares;
867     uint256 public totalShares;
868     uint256 public totalDividends;
869     uint256 public totalDistributed;
870     uint256 public dividendsPerShare;
871     uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
872 
873     modifier onlyToken() {
874         require(msg.sender == _token);
875         _;
876     }
877 
878     constructor (address _router, address _owner, address _weth) AC(_owner) {
879         router = _router != address(0) ? IUniswapV2Router(_router) : IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
880         _token = msg.sender;
881         allowed[_weth] = true;
882         BASE = IERC20(_weth);
883         BASE.approve(_router, max);
884     }
885 
886     receive() external payable {}
887 
888     function getClaimedDividendsTotal(address token) public view returns (uint256) {
889         return totalRewardsDistributed[token];
890     }
891 
892     function getClaimedDividends(address token, address user) public view returns (uint256) {
893         return totalRewardsToUser[token][user];
894     }
895 
896     function changeRouterVersion(address _router) external onlyOwner {
897         IUniswapV2Router _uniswapV2Router = IUniswapV2Router(_router);
898         router = _uniswapV2Router;
899     }
900 
901     function setShare(address shareholder, uint256 amount) external override onlyToken {
902         if (amount > 0 && shares[shareholder].amount == 0) addShareholder(shareholder);
903         else if (amount == 0 && shares[shareholder].amount > 0) removeShareholder(shareholder);
904         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
905         shares[shareholder].amount = amount;
906         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
907     }
908 
909     function deposit() external payable override onlyToken {
910         uint256 amount = msg.value;
911         totalDividends = totalDividends.add(amount);
912         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
913     }
914 
915     function distributeDividend(address shareholder, address rewardAddress) internal {
916         require(allowed[rewardAddress], "Invalid reward address!");
917         if (shares[shareholder].amount == 0) {
918             return;
919         }
920         uint256 amount = getPendingDividend(shareholder);
921         if (amount > 0) {
922             totalDistributed = totalDistributed.add(amount);
923             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
924             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
925             if (rewardAddress == address(BASE)) {
926                 payable(shareholder).transfer(amount);
927                 totalRewardsDistributed[rewardAddress] = totalRewardsDistributed[rewardAddress].add(amount);  
928                 totalRewardsToUser[rewardAddress][shareholder] = totalRewardsToUser[rewardAddress][shareholder].add(amount);
929             }
930         }
931     }
932 
933     function claimDividend(address claimer, address rewardAddress) external onlyToken {
934         distributeDividend(claimer, rewardAddress);
935     }
936 
937     function getPendingDividend(address shareholder) public view returns (uint256) {
938         if (shares[shareholder].amount == 0) return 0;
939         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
940         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
941         if (shareholderTotalDividends <= shareholderTotalExcluded) return 0;
942         return shareholderTotalDividends.sub(shareholderTotalExcluded);
943     }
944 
945     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
946         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
947     }
948 
949     function addShareholder(address shareholder) internal {
950         shareholderIndexes[shareholder] = shareholders.length;
951         shareholders.push(shareholder);
952     }
953 
954     function removeShareholder(address shareholder) internal {
955         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length - 1];
956         shareholderIndexes[shareholders[shareholders.length - 1]] = shareholderIndexes[shareholder];
957         shareholders.pop();
958     }
959 
960     function changeBASE(address _BASE) external onlyOwner {
961         BASE = IERC20(_BASE);
962     }
963 
964     function drainGas() external onlyOwner {
965         payable(msg.sender).transfer(address(this).balance);
966     }
967 
968     function drainToken(address _address, address _to) external onlyOwner {
969         IERC20(_address).transfer(_to, IERC20(_address).balanceOf(address(this)));
970     }
971 }
972 
973 abstract contract ReentrancyGuard {
974     uint256 private constant _NOT_ENTERED = 1;
975     uint256 private constant _ENTERED = 2;
976     uint256 private _status;
977     constructor() {
978         _status = _NOT_ENTERED;
979     }
980     modifier nonReentrant() {
981         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
982         _status = _ENTERED;
983         _;
984         _status = _NOT_ENTERED;
985     }
986 }
987 
988 contract MicroValidator is AC, ERC721URIStorage, ReentrancyGuard {
989     using Counters for Counters.Counter;
990     Counters.Counter private _tokenIds;
991     address public microvAddress;
992     IERC20 microv;
993     Network1 private _network1;
994     address public network1Address;
995     Network2 private _network2;
996     address public network2Address;
997     Network3 private _network3;
998     address public network3Address;
999     Network4 private _network4;
1000     address public network4Address;
1001     address public renewals = 0xa1ed930901534A5eecCC37fE131362e3054c4a82;
1002     address public claims = 0xa1ed930901534A5eecCC37fE131362e3054c4a82;
1003     address public rewards = 0x000000000000000000000000000000000000dEaD;
1004     address public liquidity = 0x4D939977da7D0d0C3239dd0415F13a35cC1664b4;
1005     address public reserves = 0xa1ed930901534A5eecCC37fE131362e3054c4a82;
1006     address public partnerships = 0xFf20C9736ac252014800782692d867B4C70656d1;
1007     address public dead = 0x000000000000000000000000000000000000dEaD;
1008     uint256 public rate0 = 700000000000;
1009     uint256[20] public rates0 = [700000000000, 595000000000, 505750000000, 429887500000, 365404375000, 310593718750, 264004660937, 224403961797, 190743367527, 162131862398, 137812083039, 117140270583, 99569229995, 84633845496, 71938768672, 61147953371, 51975760365, 44179396311, 37552486864, 31919613834];
1010     uint256 public amount1 = 21759840000000000000;
1011     uint256 public amount2 = 135999000000000000000;
1012     uint256 public amount3 = 326397600000000000000;
1013     uint256 public amount4 = 658017561600000000000;
1014     uint256 public seconds1 = 31536000;
1015     uint256 public seconds2 = 94608000;
1016     uint256 public seconds3 = 157680000;
1017     uint256 public seconds4 = 504576000;
1018     uint256 public gracePeriod = 2628000;
1019     uint256 public gammaPeriod = 5443200;
1020     uint256 public quarter = 7884000;
1021     uint256 public month = 2628000;
1022     uint256 public maxValidatorsPerMinter = 100;
1023     address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1024     struct Validator {
1025         uint256 id;
1026         address minter;
1027         uint256 created;
1028         uint256 lastClaimMicrov;
1029         uint256 lastClaimEth;
1030         uint256 numClaimsMicrov;
1031         uint256 renewalExpiry;
1032         uint8 fuseProduct;
1033         uint256 fuseCreated;
1034         uint256 fuseUnlocks;
1035         bool fuseUnlocked;
1036     }
1037     mapping (uint256 => Validator) public validators;
1038     mapping (address => Validator[]) public validatorsByMinter;
1039     mapping (address => uint256) public numValidatorsByMinter;
1040     mapping (uint256 => uint256) public positions;
1041     AggregatorV3Interface internal priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
1042     uint256 public renewalFee = 1000 * 1000000;
1043     uint256 public claimMicrovFee = 6900 * 1000000;
1044     uint256 public claimEthFee = 639 * 1000000;
1045     uint256 public mintPrice = 10 * (10 ** 18);
1046     uint256 public rewardsFee = 6 * (10 ** 18);
1047     uint256 public liquidityFee = 10 ** 18;
1048     uint256 public reservesFee = 10 ** 18;
1049     uint256 public partnershipsFee = 10 ** 18;
1050     uint256 public deadFee = 10 ** 18;
1051 
1052     constructor(string memory _name, string memory _symbol, address _microvAddress, address _owner, address _priceFeed, address _weth) ERC721(_name, _symbol, _owner) {
1053         rewards = address(this);
1054         microvAddress = _microvAddress;
1055         microv = IERC20(microvAddress);
1056         address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1057         _network1 = new Network1(_router, _owner, _weth);
1058         network1Address = address(_network1);
1059         _network2 = new Network2(_router, _owner, _weth);
1060         network2Address = address(_network2);
1061         _network3 = new Network3(_router, _owner, _weth);
1062         network3Address = address(_network3);
1063         _network4 = new Network4(_router, _owner, _weth);
1064         network4Address = address(_network4);
1065         priceFeed = AggregatorV3Interface(_priceFeed);
1066         weth = _weth;
1067     }
1068 
1069     function createToken(uint256 _months) external payable nonReentrant returns (uint) {
1070         require(numValidatorsByMinter[msg.sender] < maxValidatorsPerMinter, "Too many validators");
1071         require(_months < 193, "Too many months");
1072         require(msg.value == getRenewalCost(_months), "Invalid value");
1073         require(microv.allowance(msg.sender, address(this)) > mintPrice, "Insufficient allowance");
1074         require(microv.balanceOf(msg.sender) > mintPrice, "Insufficient balance");
1075         bool _success = microv.transferFrom(msg.sender, address(this), mintPrice);
1076         require(_success, "Transfer unsuccessful");
1077         payable(renewals).transfer(msg.value);
1078         microv.transfer(rewards, rewardsFee);
1079         microv.transfer(liquidity, liquidityFee);
1080         microv.transfer(reserves, reservesFee);
1081         microv.transfer(partnerships, partnershipsFee);
1082         microv.transfer(dead, deadFee);
1083         uint256 _newItemId = _tokenIds.current();
1084         _tokenIds.increment();
1085         _mint(msg.sender, _newItemId);
1086         _setTokenURI(_newItemId, string(abi.encodePacked(_newItemId, ".json")));
1087         Validator memory _validator = Validator(_newItemId, msg.sender, block.timestamp, 0, 0, 0, block.timestamp + (2628000 * _months), 0, 0, 0, false);
1088         validators[_newItemId] = _validator;
1089         validatorsByMinter[msg.sender].push(_validator);
1090         positions[_newItemId] = numValidatorsByMinter[msg.sender];
1091         numValidatorsByMinter[msg.sender]++;
1092         return _newItemId;
1093     }
1094 
1095     function fuseToken(uint256 _id, uint8 _tier) external nonReentrant {
1096         require(ownerOf(_id) == msg.sender, "Invalid ownership");
1097         require(_tier == 1 || _tier == 2 || _tier == 3 || _tier == 4, "Invalid product");
1098         Validator memory _validator = validators[_id];
1099         require(_validator.fuseProduct == 0 || _validator.fuseUnlocked, "Already fused");
1100         require(_validator.renewalExpiry > block.timestamp, "Expired");
1101         uint256 _seconds = seconds1;
1102         uint256 _balance = 0;
1103         uint256 _matches = numValidatorsByMinter[msg.sender];
1104         Validator[] memory _array = validatorsByMinter[msg.sender];
1105         for (uint256 _i = 0; _i < _matches; _i++) {
1106             Validator memory _v = _array[_i];
1107             if (_v.fuseProduct == _tier && !_v.fuseUnlocked && _v.renewalExpiry > block.timestamp && _v.fuseUnlocks < block.timestamp) _balance++;
1108         }
1109         if (_tier == 1) {
1110             try _network1.setShare(msg.sender, _balance + 1) {} catch {}
1111         } else if (_tier == 2) {
1112             try _network2.setShare(msg.sender, _balance + 1) {} catch {}
1113             _seconds = seconds2;
1114         } else if (_tier == 3) {
1115             try _network3.setShare(msg.sender, _balance + 1) {} catch {}
1116             _seconds = seconds3;
1117         } else if (_tier == 4) {
1118             try _network4.setShare(msg.sender, _balance + 1) {} catch {}
1119             _seconds = seconds4;
1120         }
1121         Validator memory _validatorNew = Validator(_id, _validator.minter, _validator.created, _validator.lastClaimMicrov, 0, _validator.numClaimsMicrov, _validator.renewalExpiry, _tier, block.timestamp, block.timestamp + _seconds, false);
1122         validators[_id] = _validatorNew;
1123         validatorsByMinter[msg.sender][positions[_id]] = _validatorNew;
1124     }
1125 
1126     function renewToken(uint256 _id, uint256 _months) external payable nonReentrant {
1127         require(ownerOf(_id) == msg.sender, "Invalid ownership");
1128         require(_months < 193, "Too many months");
1129         uint256 _boost = 2628000 * _months;
1130         require(msg.value == getRenewalCost(_months), "Invalid value");
1131         Validator memory _validator = validators[_id];
1132         require(_validator.renewalExpiry + gracePeriod > block.timestamp, "Grace period expired");
1133         if (_validator.fuseProduct > 0) {
1134             require(!_validator.fuseUnlocked, "Must be unlocked");
1135             require(_validator.renewalExpiry + _boost <= _validator.fuseUnlocks + gracePeriod, "Renewing too far");
1136         }
1137         payable(renewals).transfer(msg.value);
1138         Validator memory _validatorNew = Validator(_id, _validator.minter, _validator.created, _validator.lastClaimMicrov, _validator.lastClaimEth, _validator.numClaimsMicrov, _validator.renewalExpiry + _boost, _validator.fuseProduct, _validator.fuseCreated, _validator.fuseUnlocks, false);
1139         validators[_id] = _validatorNew;
1140         validatorsByMinter[msg.sender][positions[_id]] = _validatorNew;
1141     }
1142 
1143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1144         unchecked {
1145             if (b == 0) return (false, 0);
1146             return (true, a / b);
1147         }
1148     }
1149 
1150     function claimMicrov(uint256 _id) external payable nonReentrant {
1151         require(ownerOf(_id) == msg.sender, "Invalid ownership");
1152         Validator memory _validator = validators[_id];
1153         uint8 _fuseProduct = _validator.fuseProduct;
1154         require(_fuseProduct == 0, "Must be fused");
1155         require(_validator.renewalExpiry > block.timestamp, "Expired");
1156         require(msg.value == getClaimMicrovCost(), "Invalid value");
1157         payable(claims).transfer(msg.value);
1158         (, uint256 _amount) = getPendingMicrov(_id);
1159         microv.transfer(msg.sender, _amount);
1160         Validator memory _validatorNew = Validator(_id, _validator.minter, _validator.created, block.timestamp, _validator.lastClaimEth, _validator.numClaimsMicrov + 1, _validator.renewalExpiry, _validator.fuseProduct, _validator.fuseCreated, _validator.fuseUnlocks, _validator.fuseUnlocked);
1161         validators[_id] = _validatorNew;
1162         validatorsByMinter[msg.sender][positions[_id]] = _validatorNew;
1163     }
1164 
1165     function claimEth(uint256 _id) external payable nonReentrant {
1166         require(ownerOf(_id) == msg.sender, "Invalid ownership");
1167         Validator memory _validator = validators[_id];
1168         require(_validator.fuseProduct == 1 || _validator.fuseProduct == 2 || _validator.fuseProduct == 3 || _validator.fuseProduct == 4, "Invalid product");
1169         require(_validator.renewalExpiry > block.timestamp, "Expired");
1170         require(!_validator.fuseUnlocked, "Already unlocked");
1171         if (_validator.lastClaimEth == 0) {
1172             require(_validator.lastClaimEth >= _validator.fuseCreated + quarter, "Too early");
1173         } else {
1174             require(_validator.lastClaimEth >= _validator.lastClaimEth + month, "Too early");
1175         }
1176         require(msg.value == getClaimEthCost(), "Invalid value");
1177         payable(claims).transfer(msg.value);
1178         _refresh(msg.sender, true, _validator.fuseProduct);
1179         Validator memory _validatorNew = Validator(_id, _validator.minter, _validator.created, _validator.lastClaimMicrov, block.timestamp, _validator.numClaimsMicrov, _validator.renewalExpiry, _validator.fuseProduct, _validator.fuseCreated, _validator.fuseUnlocks, _validator.fuseUnlocked);
1180         validators[_id] = _validatorNew;
1181         validatorsByMinter[msg.sender][positions[_id]] = _validatorNew;
1182     }
1183 
1184     function _refresh(address _address, bool _claim, uint8 _tier) private {
1185         uint256 _1balance = 0;
1186         uint256 _2balance = 0;
1187         uint256 _3balance = 0;
1188         uint256 _4balance = 0;
1189         uint256 _matches = numValidatorsByMinter[_address];
1190         Validator[] memory _array = validatorsByMinter[_address];
1191         for (uint256 _i = 0; _i < _matches; _i++) {
1192             if (_array[_i].fuseProduct > 0 && !_array[_i].fuseUnlocked && _array[_i].renewalExpiry > block.timestamp && _array[_i].fuseUnlocks < block.timestamp) {
1193                 uint256 _fuseProduct = _array[_i].fuseProduct;
1194                 if (_fuseProduct == 1) _1balance++;
1195                 else if (_fuseProduct == 2) _2balance++;
1196                 else if (_fuseProduct == 3) _3balance++;
1197                 else if (_fuseProduct == 4) _4balance++;
1198             }
1199         }
1200         if (_claim) {
1201             if (_tier == 1) try _network1.claimDividend(_address, weth) {} catch {}
1202             else if (_tier == 2) try _network2.claimDividend(_address, weth) {} catch {}
1203             else if (_tier == 3) try _network3.claimDividend(_address, weth) {} catch {}
1204             else if (_tier == 4) try _network4.claimDividend(_address, weth) {} catch {}
1205         }
1206         try _network1.setShare(_address, _1balance) {} catch {}
1207         try _network2.setShare(_address, _2balance) {} catch {}
1208         try _network3.setShare(_address, _3balance) {} catch {}
1209         try _network4.setShare(_address, _4balance) {} catch {}
1210     }
1211 
1212     function unlockMicrov(uint256 _id) external nonReentrant {
1213         require(ownerOf(_id) == msg.sender, "Invalid ownership");
1214         Validator memory _validator = validators[_id];
1215         require(_validator.fuseProduct == 1 || _validator.fuseProduct == 2 || _validator.fuseProduct == 3 || _validator.fuseProduct == 4, "Invalid product");
1216         require(_validator.renewalExpiry > block.timestamp, "Expired");
1217         require(_validator.fuseUnlocks >= block.timestamp, "Too early");
1218         require(!_validator.fuseUnlocked, "Already unlocked");
1219         _refresh(msg.sender, true, _validator.fuseProduct);
1220         if (_validator.fuseProduct == 1) microv.transfer(msg.sender, amount1);
1221         else if (_validator.fuseProduct == 2) microv.transfer(msg.sender, amount2);
1222         else if (_validator.fuseProduct == 3) microv.transfer(msg.sender, amount3);
1223         else if (_validator.fuseProduct == 4) microv.transfer(msg.sender, amount4);
1224         Validator memory _validatorNew = Validator(_id, _validator.minter, _validator.created, _validator.lastClaimMicrov, _validator.lastClaimEth, _validator.numClaimsMicrov, _validator.renewalExpiry, _validator.fuseProduct, _validator.fuseCreated, _validator.fuseUnlocks, true);
1225         validators[_id] = _validatorNew;
1226         validatorsByMinter[msg.sender][positions[_id]] = _validatorNew;
1227     }
1228 
1229     function slash(uint256 _id) external nonReentrant onlyOwner {
1230         Validator memory _validator = validators[_id];
1231         require(_validator.fuseProduct == 1 || _validator.fuseProduct == 2 || _validator.fuseProduct == 3 || _validator.fuseProduct == 4, "Invalid product");
1232         require(_validator.renewalExpiry + gracePeriod <= block.timestamp, "Not expired");
1233         _refresh(_validator.minter, false, 0);
1234     }
1235 
1236     function changeRatesAmounts(uint256 _rate0, uint256 _amount1, uint256 _amount2, uint256 _amount3, uint256 _amount4) external nonReentrant onlyOwner {
1237         rate0 = _rate0;
1238         amount1 = _amount1;
1239         amount2 = _amount2;
1240         amount3 = _amount3;
1241         amount4 = _amount4;
1242     }
1243 
1244     function configureMinting(uint256 _mintPrice, uint256 _rewardsFee, uint256 _liquidityFee, uint256 _reservesFee, uint256 _partnershipsFee, uint256 _deadFee) external nonReentrant onlyOwner {
1245         require(_mintPrice == _rewardsFee + _liquidityFee + _reservesFee + _partnershipsFee + _deadFee, "");
1246         mintPrice = _mintPrice;
1247         rewardsFee = _rewardsFee;
1248         liquidityFee = _liquidityFee;
1249         reservesFee = _reservesFee;
1250         partnershipsFee = _partnershipsFee;
1251         deadFee = _deadFee;
1252     }
1253 
1254     function changeRenewalFee(uint256 _renewalFee) external nonReentrant onlyOwner {
1255         renewalFee = _renewalFee;
1256     }
1257 
1258     function changeClaimMicrovFee(uint256 _claimMicrovFee) external nonReentrant onlyOwner {
1259         claimMicrovFee = _claimMicrovFee;
1260     }
1261 
1262     function changeClaimEthFee(uint256 _claimEthFee) external nonReentrant onlyOwner {
1263         claimEthFee = _claimEthFee;
1264     }
1265 
1266     function setGracePeriod(uint256 _gracePeriod) external nonReentrant onlyOwner {
1267         gracePeriod = _gracePeriod;
1268     }
1269 
1270     function setQuarter(uint256 _quarter) external nonReentrant onlyOwner {
1271         quarter = _quarter;
1272     }
1273 
1274     function setMonth(uint256 _month) external nonReentrant onlyOwner {
1275         month = _month;
1276     }
1277 
1278     function setMaxValidatorsPerMinter(uint256 _maxValidatorsPerMinter) external nonReentrant onlyOwner {
1279         maxValidatorsPerMinter = _maxValidatorsPerMinter;
1280     }
1281 
1282     function changeMicrov(address _microvAddress) external nonReentrant onlyOwner {
1283         microvAddress = _microvAddress;
1284         microv = IERC20(microvAddress);
1285     }
1286 
1287     function changeWeth(address _weth) external nonReentrant onlyOwner {
1288         weth = _weth;
1289     }
1290 
1291     function switchPriceFeed(address _priceFeed) external nonReentrant onlyOwner {
1292         priceFeed = AggregatorV3Interface(_priceFeed);
1293     }
1294 
1295     function getNetworks() external view returns (address, address, address, address) {
1296         return (network1Address, network2Address, network3Address, network4Address);
1297     }
1298 
1299     function getGracePeriod() external view returns (uint256) {
1300         return gracePeriod;
1301     }
1302 
1303     function getQuarter() external view returns (uint256) {
1304         return quarter;
1305     }
1306 
1307     function getMaxValidatorsPerMinter() external view returns (uint256) {
1308         return maxValidatorsPerMinter;
1309     }
1310 
1311     function getClaimMicrovCost() public view returns (uint256) {
1312         return (claimMicrovFee * (10 ** 18)) / uint(getLatestPrice());
1313     }
1314 
1315     function getClaimEthCost() public view returns (uint256) {
1316         return (claimEthFee * (10 ** 18)) / uint(getLatestPrice());
1317     }
1318 
1319     function getRenewalCost(uint256 _months) public view returns (uint256) {
1320         return (renewalFee * (10 ** 18)) / uint(getLatestPrice()) * _months;
1321     }
1322 
1323     function getLatestPrice() public view returns (int256) {
1324         (, int256 _price, , , ) = priceFeed.latestRoundData();
1325         return _price;
1326     }
1327 
1328     function getBlockTimestamp() external view returns (uint256) {
1329         return block.timestamp;
1330     }
1331 
1332     function getPendingMicrov(uint256 _id) public view returns (uint256, uint256) {
1333         Validator memory _validator = validators[_id];
1334         uint8 _fuseProduct = _validator.fuseProduct;
1335         require(_fuseProduct == 0, "Must be fused");
1336         uint256 _newRate = rates0[_validator.numClaimsMicrov];
1337         uint256 _amount = (block.timestamp - (_validator.numClaimsMicrov > 0 ? _validator.lastClaimMicrov : _validator.created)) * (_newRate);
1338         if (_validator.created < block.timestamp + gammaPeriod) {
1339             uint256 _seconds = (block.timestamp + gammaPeriod) - _validator.created;
1340             uint256 _percent = 100;
1341             if (_seconds >= 4838400) _percent = 900;
1342             else if (_seconds >= 4233600) _percent = 800;
1343             else if (_seconds >= 3628800) _percent = 700;
1344             else if (_seconds >= 3024000) _percent = 600;
1345             else if (_seconds >= 2419200) _percent = 500;
1346             else if (_seconds >= 1814400) _percent = 400;
1347             else if (_seconds >= 1209600) _percent = 300;
1348             else if (_seconds >= 604800) _percent = 200;
1349             uint256 _divisor = _amount * _percent;
1350             (bool _divisible, ) = tryDiv(_divisor, 10000);
1351             _amount = _amount - (_divisible ? (_divisor / 10000) : 0);
1352         }
1353         return (_newRate, _amount);
1354     }
1355 
1356     function setRecipients(address _renewals, address _claims, address _rewards, address _liquidity, address _reserves, address _partnerships, address _dead) external onlyOwner {
1357         renewals = _renewals;
1358         claims = _claims;
1359         rewards = _rewards;
1360         liquidity = _liquidity;
1361         reserves = _reserves;
1362         partnerships = _partnerships;
1363         dead = _dead;
1364     }
1365 
1366     function getValidator(uint256 _id) external view returns (Validator memory) {
1367         return validators[_id];
1368     }
1369 
1370     function getValidatorsByMinter(address _minter) external view returns (Validator[] memory) {
1371         return validatorsByMinter[_minter];
1372     }
1373 
1374     function getNumValidatorsByMinter(address _minter) external view returns (uint256) {
1375         return numValidatorsByMinter[_minter];
1376     }
1377 
1378     function drainGas() external onlyOwner {
1379         payable(msg.sender).transfer(address(this).balance);
1380     }
1381 
1382     function drainToken(address _token, address _recipient) external onlyOwner {
1383         IERC20(_token).transfer(_recipient, IERC20(_token).balanceOf(address(this)));
1384     }
1385 
1386     function deposit1() external payable onlyOwner {
1387         if (msg.value > 0) {
1388             try _network1.deposit{value: msg.value}() {} catch {}
1389         }
1390     }
1391 
1392     function deposit2() external payable onlyOwner {
1393         if (msg.value > 0) {
1394             try _network2.deposit{value: msg.value}() {} catch {}
1395         }
1396     }
1397 
1398     function deposit3() external payable onlyOwner {
1399         if (msg.value > 0) {
1400             try _network3.deposit{value: msg.value}() {} catch {}
1401         }
1402     }
1403 
1404     function deposit4() external payable onlyOwner {
1405         if (msg.value > 0) {
1406             try _network4.deposit{value: msg.value}() {} catch {}
1407         }
1408     }
1409 
1410     receive() external payable {}
1411 }
1412 
1413 contract MICROV is IERC20, AC {
1414     using SafeMath for uint256;
1415     address public BASE = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1416     address public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1417     address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
1418     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
1419     string private constant _name = "MicroValidator";
1420     string private constant _symbol = "MICROV";
1421     uint8 private constant _decimals = 18;
1422     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
1423     uint256 public maxWallet = _totalSupply;
1424     uint256 public minAmountToTriggerSwap = 0;
1425     mapping (address => uint256) private _balances;
1426     mapping (address => mapping (address => uint256)) private _allowances;
1427     mapping (address => bool) public isDisabledExempt;
1428     mapping (address => bool) public isFeeExempt;
1429     mapping (address => bool) public isMaxExempt;
1430     mapping (address => bool) public isUniswapPair;
1431     uint256 public buyFeeOp = 300;
1432     uint256 public buyFeeValidator = 0;
1433     uint256 public buyFeeTotal = 300;
1434     uint256 public sellFeeOp = 0;
1435     uint256 public sellFeeValidator = 800;
1436     uint256 public sellFeeTotal = 800;
1437     uint256 public bps = 10000;
1438     uint256 public _opTokensToSwap;
1439     uint256 public _validatorTokensToSwap;
1440     address public opFeeRecipient1 = 0xb8d7dA7E64271E274e132001F9865Ad8De5001C8;
1441     address public opFeeRecipient2 = 0x21CcABc78FC240892a54106bC7a8dC3880536347;
1442     address public opFeeRecipient3 = 0xd703f7b098262B0751c9A654eea332183D199A69;
1443     address public validatorFeeRecipient = 0x58917027C0648086f85Cd208E289095731cFDE1B;
1444     IUniswapV2Router public router;
1445     address public pair;
1446     bool public contractSellEnabled = true;
1447     uint256 public contractSellThreshold = _totalSupply / 5000;
1448     bool public mintingEnabled = true;
1449     bool public tradingEnabled = false;
1450     bool public isContractSelling = false;
1451     MicroValidator public microvalidator;
1452     address public microvalidatorAddress;
1453     bool public swapForETH = true;
1454     IERC20 public usdt = IERC20(USDT);
1455     uint256 public taxDistOp = 2700;
1456     uint256 public taxDistValidator = 7300;
1457     uint256 public taxDistBps = 10000;
1458 
1459     modifier contractSelling() {
1460         isContractSelling = true;
1461         _;
1462         isContractSelling = false;
1463     }
1464 
1465     constructor (address _priceFeed) AC(msg.sender) {
1466         address _router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1467         router = IUniswapV2Router(_router);
1468         pair = IUniswapV2Factory(router.factory()).createPair(USDT, address(this));
1469         _allowances[address(this)][address(router)] = _totalSupply;
1470         WETH = router.WETH();
1471         microvalidator = new MicroValidator("Annuity MicroValidators", "MicroValidator", address(this), msg.sender, _priceFeed, WETH);
1472         microvalidatorAddress = address(microvalidator);
1473         isDisabledExempt[msg.sender] = true;
1474         isFeeExempt[msg.sender] = true;
1475         isMaxExempt[msg.sender] = true;
1476         isDisabledExempt[microvalidatorAddress] = true;
1477         isFeeExempt[microvalidatorAddress] = true;
1478         isMaxExempt[microvalidatorAddress] = true;
1479         isDisabledExempt[address(0)] = true;
1480         isFeeExempt[address(0)] = true;
1481         isMaxExempt[address(0)] = true;
1482         isDisabledExempt[DEAD] = true;
1483         isFeeExempt[DEAD] = true;
1484         isMaxExempt[DEAD] = true;
1485         isMaxExempt[address(this)] = true;
1486         isUniswapPair[pair] = true;
1487         approve(_router, _totalSupply);
1488         approve(address(pair), _totalSupply);
1489         uint256 _toEmissions = 237000 * (10 ** _decimals);
1490         uint256 _toDeployer = _totalSupply - _toEmissions;
1491         _balances[msg.sender] = _toDeployer;
1492         emit Transfer(address(0), msg.sender, _toDeployer);
1493         _balances[microvalidatorAddress] = _toEmissions;
1494         emit Transfer(address(0), microvalidatorAddress, _toEmissions);
1495     }
1496 
1497     function mint(uint256 _amount) external onlyOwner {
1498         require(mintingEnabled, "Minting is disabled");
1499         _totalSupply += _amount;
1500         approve(address(router), _totalSupply);
1501         approve(address(pair), _totalSupply);
1502         _balances[msg.sender] += _amount;
1503         emit Transfer(address(0), msg.sender, _amount);
1504     }
1505 
1506     function burn(uint256 _amount) external onlyOwner {
1507         require(_balances[msg.sender] >= _amount);
1508         _totalSupply -= _amount;
1509         _balances[msg.sender] -= _amount;
1510         emit Transfer(msg.sender, address(0), _amount);
1511     }
1512 
1513     function approve(address spender, uint256 amount) public override returns (bool) {
1514         _allowances[msg.sender][spender] = amount;
1515         emit Approval(msg.sender, spender, amount);
1516         return true;
1517     }
1518 
1519     function approveMax(address _spender) external returns (bool) {
1520         return approve(_spender, _totalSupply);
1521     }
1522 
1523     function transfer(address recipient, uint256 amount) external override returns (bool) {
1524         return _transferFrom(msg.sender, recipient, amount);
1525     }
1526 
1527     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1528         if (_allowances[sender][msg.sender] != _totalSupply) _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
1529         return _transferFrom(sender, recipient, amount);
1530     }
1531 
1532     function _transferFrom(address _sender, address _recipient, uint256 _amount) private returns (bool) {
1533         if (isContractSelling) return _simpleTransfer(_sender, _recipient, _amount);
1534         require(tradingEnabled || isDisabledExempt[_sender], "Trading is currently disabled");
1535         address _routerAddress = address(router);
1536         bool _sell = isUniswapPair[_recipient] || _recipient == _routerAddress;
1537         if (!_sell && !isMaxExempt[_recipient]) require((_balances[_recipient] + _amount) < maxWallet, "Max wallet has been triggered");
1538         if (_sell && _amount >= minAmountToTriggerSwap) {
1539             if (!isUniswapPair[msg.sender] && !isContractSelling && contractSellEnabled && _balances[address(this)] >= contractSellThreshold) _contractSell();
1540         }
1541         _balances[_sender] = _balances[_sender].sub(_amount, "Insufficient balance");
1542         uint256 _amountAfterFees = _amount;
1543         if (((isUniswapPair[_sender] || _sender == _routerAddress) || (isUniswapPair[_recipient]|| _recipient == _routerAddress)) ? !isFeeExempt[_sender] && !isFeeExempt[_recipient] : false) _amountAfterFees = _collectFee(_sender, _recipient, _amount);
1544         _balances[_recipient] = _balances[_recipient].add(_amountAfterFees);
1545         emit Transfer(_sender, _recipient, _amountAfterFees);
1546         return true;
1547     }
1548 
1549     function _simpleTransfer(address _sender, address _recipient, uint256 _amount) private returns (bool) {
1550         _balances[_sender] = _balances[_sender].sub(_amount, "Insufficient Balance");
1551         _balances[_recipient] = _balances[_recipient].add(_amount);
1552         return true;
1553     }
1554 
1555     function _collectFee(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
1556         bool _sell = isUniswapPair[_recipient] || _recipient == address(router);
1557         uint256 _feeDividend = _sell ? sellFeeTotal : buyFeeTotal;
1558         uint256 _feeDivisor = _amount.mul(_feeDividend).div(bps);
1559         if (_feeDividend > 0) {
1560             if (_sell) {
1561                 if (sellFeeOp > 0) _opTokensToSwap += _feeDivisor * sellFeeOp / _feeDividend;
1562                 if (sellFeeValidator > 0) _validatorTokensToSwap += _feeDivisor * sellFeeValidator / _feeDividend;
1563             } else {
1564                 if (buyFeeOp > 0) _opTokensToSwap += _feeDivisor * buyFeeOp / _feeDividend;
1565                 if (buyFeeValidator > 0) _validatorTokensToSwap += _feeDivisor * buyFeeValidator / _feeDividend;
1566             }
1567         }
1568         _balances[address(this)] = _balances[address(this)].add(_feeDivisor);
1569         emit Transfer(_sender, address(this), _feeDivisor);
1570         return _amount.sub(_feeDivisor);
1571     }
1572 
1573     function _contractSell() private contractSelling {
1574         uint256 _tokensTotal = _opTokensToSwap.add(_validatorTokensToSwap);
1575         if (swapForETH) {
1576             address[] memory path = new address[](3);
1577             path[0] = address(this);
1578             path[1] = USDT;
1579             path[2] = WETH;
1580             uint256 _ethBefore = address(this).balance;
1581             router.swapExactTokensForETHSupportingFeeOnTransferTokens(balanceOf(address(this)), 0, path, address(this), block.timestamp);
1582             uint256 _ethAfter = address(this).balance.sub(_ethBefore);
1583             uint256 _ethOp = _ethAfter.mul(_opTokensToSwap).div(_tokensTotal);
1584             uint256 _ethValidator = _ethAfter.mul(_validatorTokensToSwap).div(_tokensTotal);
1585             _opTokensToSwap = 0;
1586             _validatorTokensToSwap = 0;
1587             if (_ethOp > 0) {
1588                 payable(opFeeRecipient1).transfer((_ethOp * 3400) / 10000);
1589                 payable(opFeeRecipient2).transfer((_ethOp * 3300) / 10000);
1590                 payable(opFeeRecipient3).transfer((_ethOp * 3300) / 10000);
1591             }
1592             if (_ethValidator > 0) payable(validatorFeeRecipient).transfer(_ethValidator);
1593         } else {
1594             address[] memory path = new address[](2);
1595             path[0] = address(this);
1596             path[1] = USDT;
1597             uint256 _usdtBefore = usdt.balanceOf(address(this));
1598             router.swapExactTokensForTokensSupportingFeeOnTransferTokens(balanceOf(address(this)), 0, path, address(this), block.timestamp);
1599             uint256 _usdtAfter = usdt.balanceOf(address(this)).sub(_usdtBefore);
1600             uint256 _usdtOp = _usdtAfter.mul(taxDistOp).div(taxDistBps);
1601             uint256 _usdtValidator = _usdtAfter.mul(taxDistValidator).div(taxDistBps);
1602             _opTokensToSwap = 0;
1603             _validatorTokensToSwap = 0;
1604             if (_usdtOp > 0) {
1605                 usdt.transfer(opFeeRecipient1, (_usdtOp * 3400) / 10000);
1606                 usdt.transfer(opFeeRecipient2, (_usdtOp * 3300) / 10000);
1607                 usdt.transfer(opFeeRecipient3, (_usdtOp * 3300) / 10000);
1608             }
1609             if (_usdtValidator > 0) usdt.transfer(validatorFeeRecipient, _usdtValidator);
1610         }
1611     }
1612 
1613     function changeSwapForETH(bool _swapForETH) external onlyOwner {
1614         swapForETH = _swapForETH;
1615     }
1616 
1617     function changeTaxDist(uint256 _taxDistOp, uint256 _taxDistValidator, uint256 _taxDistBps) external onlyOwner {
1618         taxDistOp = _taxDistOp;
1619         taxDistValidator = _taxDistValidator;
1620         taxDistBps = _taxDistBps;
1621     }
1622 
1623     function changeWETH(address _WETH) external onlyOwner {
1624         WETH = _WETH;
1625     }
1626 
1627     function changeUSDT(address _USDT) external onlyOwner {
1628         USDT = _USDT;
1629         usdt = IERC20(USDT);
1630     }
1631 
1632     function setMaxWallet(uint256 _maxWallet) external onlyOwner {
1633         maxWallet = _maxWallet;
1634     }
1635 
1636     function setMinAmountToTriggerSwap(uint256 _minAmountToTriggerSwap) external onlyOwner {
1637         minAmountToTriggerSwap = _minAmountToTriggerSwap;
1638     }
1639 
1640     function toggleIsDisabledExempt(address _holder, bool _exempt) external onlyOwner {
1641         isDisabledExempt[_holder] = _exempt;
1642     }
1643 
1644     function getIsDisabledExempt(address _holder) external view returns (bool) {
1645         return isDisabledExempt[_holder];
1646     }
1647 
1648     function toggleIsFeeExempt(address _holder, bool _exempt) external onlyOwner {
1649         isFeeExempt[_holder] = _exempt;
1650     }
1651 
1652     function getIsFeeExempt(address _holder) external view returns (bool) {
1653         return isFeeExempt[_holder];
1654     }
1655 
1656     function toggleIsMaxExempt(address _holder, bool _exempt) external onlyOwner {
1657         isMaxExempt[_holder] = _exempt;
1658     }
1659 
1660     function getIsMaxExempt(address _holder) external view returns (bool) {
1661         return isMaxExempt[_holder];
1662     }
1663 
1664     function toggleIsUniswapPair(address _pair, bool _isPair) external onlyOwner {
1665         isUniswapPair[_pair] = _isPair;
1666     }
1667 
1668     function getIsUniswapPair(address _pair) external view returns (bool) {
1669         return isUniswapPair[_pair];
1670     }
1671 
1672     function configureContractSelling(bool _contractSellEnabled, uint256 _contractSellThreshold) external onlyOwner {
1673         contractSellEnabled = _contractSellEnabled;
1674         contractSellThreshold = _contractSellThreshold;
1675     }
1676 
1677     function setTransferTaxes(uint256 _buyFeeOp, uint256 _buyFeeValidator, uint256 _sellFeeOp, uint256 _sellFeeValidator, uint256 _bps) external onlyOwner {
1678         buyFeeOp = _buyFeeOp;
1679         buyFeeValidator = _buyFeeValidator;
1680         buyFeeTotal = _buyFeeOp.add(_buyFeeValidator);
1681         sellFeeOp = _sellFeeOp;
1682         sellFeeValidator = _sellFeeValidator;
1683         sellFeeTotal = _sellFeeOp.add(_sellFeeValidator);
1684         bps = _bps;
1685     }
1686 
1687     function setTransferTaxRecipients(address _opFeeRecipient1, address _opFeeRecipient2, address _opFeeRecipient3, address _validatorFeeRecipient) external onlyOwner {
1688         opFeeRecipient1 = _opFeeRecipient1;
1689         opFeeRecipient2 = _opFeeRecipient2;
1690         opFeeRecipient3 = _opFeeRecipient3;
1691         validatorFeeRecipient = _validatorFeeRecipient;
1692     }
1693 
1694     function updateRouting(address _router, address _pair, address _USDT) external onlyOwner {
1695         router = IUniswapV2Router(_router);
1696         pair = _pair == address(0) ? IUniswapV2Factory(router.factory()).createPair(address(this), _USDT) : IUniswapV2Factory(router.factory()).getPair(address(this), _USDT);
1697         _allowances[address(this)][_router] = _totalSupply;
1698     }
1699 
1700     function permanentlyDisableMinting() external onlyOwner {
1701         mintingEnabled = false;
1702     }
1703 
1704     function toggleTrading(bool _enabled) external onlyOwner {
1705         tradingEnabled = _enabled;
1706     }
1707 
1708     function drainGas() external onlyOwner {
1709         payable(msg.sender).transfer(address(this).balance);
1710     }
1711 
1712     function drainToken(address _token, address _recipient) external onlyOwner {
1713         IERC20(_token).transfer(_recipient, IERC20(_token).balanceOf(address(this)));
1714     }
1715 
1716     function totalSupply() external view override returns (uint256) {
1717         return _totalSupply;
1718     }
1719 
1720     function decimals() external pure override returns (uint8) {
1721         return _decimals;
1722     }
1723 
1724     function symbol() external pure override returns (string memory) {
1725         return _symbol;
1726     }
1727 
1728     function name() external pure override returns (string memory) {
1729         return _name;
1730     }
1731 
1732     function getOwner() external view override returns (address) {
1733         return owner;
1734     }
1735 
1736     function balanceOf(address account) public view override returns (uint256) {
1737         return _balances[account];
1738     }
1739 
1740     function allowance(address holder, address spender) external view override returns (uint256) {
1741         return _allowances[holder][spender];
1742     }
1743 
1744     receive() external payable {}
1745 }