1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 abstract contract EIP712 {
5     /* solhint-disable var-name-mixedcase */
6     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
7     uint256 private immutable _CACHED_CHAIN_ID;
8     address private immutable _CACHED_THIS;
9 
10     bytes32 private immutable _HASHED_NAME;
11     bytes32 private immutable _HASHED_VERSION;
12     bytes32 private immutable _TYPE_HASH;
13 
14     /* solhint-enable var-name-mixedcase */
15     constructor(string memory name, string memory version) {
16         bytes32 hashedName = keccak256(bytes(name));
17         bytes32 hashedVersion = keccak256(bytes(version));
18         bytes32 typeHash = keccak256(
19             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
20         );
21         _HASHED_NAME = hashedName;
22         _HASHED_VERSION = hashedVersion;
23         _CACHED_CHAIN_ID = block.chainid;
24         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
25         _CACHED_THIS = address(this);
26         _TYPE_HASH = typeHash;
27     }
28 
29     /**
30      * @dev Returns the domain separator for the current chain.
31      */
32     function _domainSeparatorV4() internal view returns (bytes32) {
33         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
34             return _CACHED_DOMAIN_SEPARATOR;
35         } else {
36             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
37         }
38     }
39 
40     function _buildDomainSeparator(
41         bytes32 typeHash,
42         bytes32 nameHash,
43         bytes32 versionHash
44     ) private view returns (bytes32) {
45         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
46     }
47 
48     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
49         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
50     }
51 }
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 }
58 
59 interface IERC20 {
60     function totalSupply() external view returns (uint256);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     function decimals() external view returns (uint8);
67     function name() external view returns (string memory);
68     function symbol() external view returns (string memory);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 abstract contract Auth is Context {
74     address internal owner;
75 
76     constructor(address _owner) {
77         owner = _owner;
78     }
79 
80     /**
81      * Function modifier to require caller to be owner
82      */
83     modifier onlyOwner() {
84         require(_msgSender() == owner, "!OWNER"); _;
85     }
86 
87     /**
88      * Check if address is owner
89      */
90     function isOwner(address account) public view returns (bool) {
91         return account == owner;
92     }
93 
94     /**
95      * Transfer ownership to new address. Caller must be owner.
96      */
97     function transferOwnership(address payable adr) public onlyOwner {
98         owner = adr;
99         emit OwnershipTransferred(adr);
100     }
101 
102     event OwnershipTransferred(address owner);
103 }
104 
105 interface IUniswapV2Factory {
106     function createPair(address tokenA, address tokenB) external returns (address pair);
107 }
108 
109 interface IUniswapV2Router02 {
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint256 amountIn,
112         uint256 amountOutMin,
113         address[] calldata path,
114         address to,
115         uint256 deadline
116     ) external;
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119 }
120 
121 contract $SOCIAL is Context, IERC20, Auth, EIP712 {
122     string private constant NAME = "SocialDAO";
123     string private constant SYMBOL = "$SOCIAL";
124     uint8 private constant DECIMALS = 9;
125     mapping(address => uint256) private _rOwned;
126     
127     mapping(address => mapping(address => uint256)) private _allowances;
128     mapping(address => bool) private _isExcludedFromFee;
129     
130     uint256 private constant MAX = ~uint256(0);
131     uint256 private constant MAX_SUPPLY = 1e12 * 1e9; // 1T Supply
132     uint256 private constant R_MAX = (MAX - (MAX % MAX_SUPPLY));
133     
134     // for DAO
135     uint256 public constant AMOUNT_DAO_PERC = 20;
136     // for staking
137     uint256 public constant AMOUNT_STAKING_PERC = 10;
138     // for liquidity providers
139     uint256 public constant AMOUNT_LP_PERC = 20;
140 
141     uint256 private _tTotal = (MAX_SUPPLY/100) * (AMOUNT_DAO_PERC + AMOUNT_STAKING_PERC + AMOUNT_LP_PERC);
142     uint256 private _rTotal = (R_MAX/100) * (AMOUNT_DAO_PERC + AMOUNT_STAKING_PERC + AMOUNT_LP_PERC);
143 
144     bool private inSwap = false;
145     bool private _startTxn;
146     uint32 private _initialBlocks;
147     uint104 private swapLimit = uint104(MAX_SUPPLY / 1000);
148     uint104 private _tOwnedBurnAddress;
149 
150     uint256 private constant STAKING_BLOCKS_COUNT = 6450 * 5; //5 days
151 
152     struct Airdrop {
153         uint128 blockNo;
154         uint128 amount;
155     }
156 
157     mapping(address => Airdrop) private _airdrop;
158 
159     mapping(bytes32 => bool) private _claimedHash;
160 
161     struct FeeBreakdown {
162         uint256 tTransferAmount;
163         uint256 tMaintenance;
164         uint256 tReflection;
165     }
166     
167     struct Fee {
168         uint64 buyMaintenanceFee;
169         uint64 buyReflectionFee;
170         
171         uint64 sellMaintenanceFee;
172         uint64 sellReflectionFee;
173     }
174 
175     Fee private _buySellFee = Fee(8,2,8,2);
176     
177     address payable private _maintenanceAddress;
178     address private _csigner;
179 
180     address payable constant private BURN_ADDRESS = payable(0x000000000000000000000000000000000000dEaD);
181     
182     IUniswapV2Router02 private immutable uniswapV2Router;
183     address public immutable uniswapV2Pair;
184     
185     modifier lockTheSwap {
186         inSwap = true;
187         _;
188         inSwap = false;
189     }
190 
191     address private immutable WETH;
192 
193     bytes32 private constant AIRDROP_CALL_HASH_TYPE = keccak256("airdrop(address receiver,uint256 amount)");
194     
195     constructor(address addrDAO, address addrStaking, address addrLP, address maintainer, address signer) Auth(_msgSender()) EIP712(SYMBOL, "1") {
196         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
197         WETH = uniswapV2Router.WETH();
198         _approve(address(this), address(uniswapV2Router), MAX_SUPPLY);
199         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), WETH);
200         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), MAX);
201 
202         _maintenanceAddress = payable(maintainer);
203         
204         //Initial distribution
205         _rOwned[addrDAO] = (R_MAX/100) * AMOUNT_DAO_PERC;
206         _rOwned[addrStaking] = (R_MAX/100) * AMOUNT_STAKING_PERC;
207         _rOwned[addrLP] = (R_MAX/100) * AMOUNT_LP_PERC;
208 
209         _isExcludedFromFee[addrDAO] = true;
210         _isExcludedFromFee[addrStaking] = true;
211         _isExcludedFromFee[addrLP] = true;
212 
213         _isExcludedFromFee[address(this)] = true;
214         _isExcludedFromFee[maintainer] = true;
215 
216         _csigner = signer;
217         emit Transfer(address(0), addrDAO, MAX_SUPPLY * AMOUNT_DAO_PERC / 100);
218         emit Transfer(address(0), addrStaking, MAX_SUPPLY * AMOUNT_STAKING_PERC / 100);
219         emit Transfer(address(0), addrLP, MAX_SUPPLY * AMOUNT_LP_PERC / 100);
220     }
221 
222     function name() override external pure returns (string memory) {return NAME;}
223     function symbol() override external pure returns (string memory) {return SYMBOL;}
224     function decimals() override external pure returns (uint8) {return DECIMALS;}
225     function totalSupply() external view override returns (uint256) {return _tTotal;}
226     function balanceOf(address account) external view override returns (uint256) {return tokenFromReflection(_rOwned[account]);}
227     function transfer(address recipient, uint256 amount) external override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231     function allowance(address owner, address spender) external view override returns (uint256) {return _allowances[owner][spender];}
232     function approve(address spender, uint256 amount) external override returns (bool) {
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
237         _transfer(sender, recipient, amount);
238         uint256 currentAllowance = _allowances[sender][_msgSender()];
239         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
240         unchecked {
241             _approve(sender, _msgSender(), currentAllowance - amount);
242         }
243         return true;
244     }
245 
246     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
247         require(rAmount <= _rTotal,"Amount must be less than total reflections");
248         uint256 currentRate = _getRate();
249         return rAmount/currentRate;
250     }
251     
252     function getFee(bool initialBlocks) internal view returns (Fee memory) {
253         return initialBlocks ? Fee(99,0,99,0) : _buySellFee;
254     }
255 
256     function _approve(address owner, address spender, uint256 amount) private {
257         require(owner != address(0), "ERC20: approve from the zero address");
258         require(spender != address(0), "ERC20: approve to the zero address");
259         _allowances[owner][spender] = amount;
260         emit Approval(owner, spender, amount);
261     }
262 
263     function _transfer(address from, address to, uint256 amount) private {
264         require(from != address(0) && to != address(0), "ERC20: transfer involving the zero address");
265         require(amount > 0, "Transfer amount must be greater than zero");
266         require(_startTxn || _isExcludedFromFee[to] || _isExcludedFromFee[from], "Transfers not allowed");
267 
268         Fee memory currentFee;
269             
270         if (from == uniswapV2Pair && !_isExcludedFromFee[to]) {
271             currentFee = getFee(block.number <= _initialBlocks);
272         } else if (!inSwap && from != uniswapV2Pair && !_isExcludedFromFee[from]) { //sells, transfers (except for buys)
273             currentFee = getFee(block.number <= _initialBlocks);
274 
275             if (swapLimit > 0 && tokenFromReflection(_rOwned[address(this)]) > swapLimit) {
276                 _convertTokensForFee(swapLimit);
277             }
278             
279             uint256 contractETHBalance = address(this).balance;
280             if (contractETHBalance > 0) _distributeFee(contractETHBalance);
281         }
282 
283         _tokenTransfer(from, to, amount, currentFee);
284     }
285 
286     function _convertTokensForFee(uint256 tokenAmount) private lockTheSwap {
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = WETH;
290         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, _maintenanceAddress, block.timestamp);
291     }
292 
293     function _distributeFee(uint256 amount) private {
294         _maintenanceAddress.transfer(amount);
295     }
296 
297     function startTxn(uint32 initialBlocks) external onlyOwner {
298         require(!_startTxn && initialBlocks < 100, "Already started or block count too long");
299         _startTxn = true;
300         _initialBlocks = uint32(block.number) + initialBlocks;
301     }
302 
303     function triggerSwap(uint256 perc) external onlyOwner {
304         _convertTokensForFee(tokenFromReflection(_rOwned[address(this)]) * perc / 100);
305     }
306     
307     function collectFee() external onlyOwner {
308         _distributeFee(address(this).balance);
309     }
310 
311     function _tokenTransfer(address sender, address recipient, uint256 amount, Fee memory currentFee) private {
312         if (sender == uniswapV2Pair){
313             _transferStandardBuy(sender, recipient, amount, currentFee);
314         }
315         else {
316             _transferStandardSell(sender, recipient, amount, currentFee);
317         }
318     }
319 
320     function _transferStandardBuy(address sender, address recipient, uint256 tAmount, Fee memory currentFee) private {
321         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 tTransferAmount, uint256 rMaintenance) = _getValuesBuy(tAmount, currentFee);
322         
323         _rOwned[sender] -= rAmount;
324         _rOwned[recipient] += rTransferAmount;
325         _rOwned[address(this)] += rMaintenance;
326         _rTotal -= rReflection;
327 
328         emit Transfer(sender, recipient, tTransferAmount);
329     }
330 
331     function _transferStandardSell(address sender, address recipient, uint256 tAmount, Fee memory currentFee) private {
332         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 tTransferAmount, uint256 rMaintenance) = _getValuesSell(tAmount, currentFee);
333 
334         Airdrop memory airdrop = _airdrop[sender];
335         uint256 rOwnedSender = _rOwned[sender];
336 
337         if (airdrop.blockNo > block.number) {
338             require(rAmount <= 
339                 rOwnedSender - airdrop.amount * ((airdrop.blockNo - block.number) * (rAmount / tAmount) / STAKING_BLOCKS_COUNT), "Tokens locked for staking");
340         }
341 
342         _rOwned[sender] = rOwnedSender - rAmount;
343         _rOwned[recipient] += rTransferAmount;
344         _rOwned[address(this)] += rMaintenance;
345 
346         if (recipient == BURN_ADDRESS) {
347             _tOwnedBurnAddress += uint104(tTransferAmount);
348         }
349 
350         _rTotal -= rReflection;
351 
352         emit Transfer(sender, recipient, tTransferAmount);
353     }
354     
355     function _getValuesBuy(uint256 tAmount, Fee memory currentFee) private view returns (uint256, uint256, uint256, uint256, uint256) {
356         FeeBreakdown memory buyFees;
357         (buyFees.tTransferAmount, buyFees.tMaintenance, buyFees.tReflection) = _getTValues(tAmount, currentFee.buyMaintenanceFee, currentFee.buyReflectionFee);
358         uint256 currentRate = _getRate();
359         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 rMaintenance) = _getRValues(tAmount, buyFees.tMaintenance, buyFees.tReflection, currentRate);
360         return (rAmount, rTransferAmount, rReflection, buyFees.tTransferAmount, rMaintenance);
361     }
362 
363     function _getValuesSell(uint256 tAmount, Fee memory currentFee) private view returns (uint256, uint256, uint256, uint256, uint256) {
364         FeeBreakdown memory sellFees;
365         (sellFees.tTransferAmount, sellFees.tMaintenance, sellFees.tReflection) = _getTValues(tAmount, currentFee.sellMaintenanceFee, currentFee.sellReflectionFee);
366         uint256 currentRate = _getRate();
367         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 rMaintenance) = _getRValues(tAmount, sellFees.tMaintenance, sellFees.tReflection, currentRate);
368         return (rAmount, rTransferAmount, rReflection, sellFees.tTransferAmount, rMaintenance);
369     }
370 
371     function _getTValues(uint256 tAmount, uint256 maintenanceFee, uint256 reflectionFee) private pure returns (uint256, uint256, uint256) {
372         uint256 tMaintenance = tAmount * maintenanceFee / 100;
373         uint256 tReflection = tAmount * reflectionFee / 100;
374         uint256 tTransferAmount = tAmount - tMaintenance - tReflection;
375         return (tTransferAmount, tMaintenance, tReflection);
376     }
377 
378     function _getRValues(uint256 tAmount, uint256 tMaintenance, uint256 tReflection, uint256 currentRate) private pure returns (uint256, uint256, uint256, uint256) {
379         uint256 rAmount = tAmount * currentRate;
380         uint256 rMaintenance = tMaintenance * currentRate;
381         uint256 rReflection = tReflection * currentRate;
382         uint256 rTransferAmount = rAmount - rMaintenance - rReflection;
383         return (rAmount, rTransferAmount, rReflection, rMaintenance);
384     }
385 
386     function _getRate() private view returns (uint256) {
387         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
388         return rSupply / tSupply;
389     }
390 
391     function _getCurrentSupply() private view returns (uint256, uint256) {
392         uint256 rSupply = _rTotal;
393         uint256 tSupply = _tTotal;
394 
395         uint256 rOwnedBurnAddress = _rOwned[BURN_ADDRESS];
396         uint256 tOwnedBurnAddress = _tOwnedBurnAddress;
397 
398         if (rOwnedBurnAddress > rSupply || 
399             tOwnedBurnAddress > tSupply || 
400             (rSupply / tSupply) > (rSupply - rOwnedBurnAddress) 
401         ) return (rSupply, tSupply);
402 
403         return (rSupply - rOwnedBurnAddress, tSupply - tOwnedBurnAddress);
404     }
405 
406     function setIsExcludedFromFee(address account, bool toggle) external onlyOwner {
407         _isExcludedFromFee[account] = toggle;
408     }
409         
410     function updateSwapLimit(uint104 amount) external onlyOwner {
411         swapLimit = amount;
412     }
413     
414     function updateFeeReceiver(address payable maintenanceAddress) external onlyOwner {
415         _maintenanceAddress = maintenanceAddress;
416         _isExcludedFromFee[maintenanceAddress] = true;
417     }
418 
419     function updateSigner(address signer) external onlyOwner {
420         _csigner = signer;
421     }
422 
423     receive() external payable {}
424 
425     function updateTaxes(Fee memory fees) external onlyOwner {
426         require((fees.buyMaintenanceFee + fees.buyReflectionFee < 20) && 
427             (fees.sellMaintenanceFee + fees.sellReflectionFee < 20), "Fees must be less than 20%");
428         _buySellFee = fees;
429     }
430     
431     function recoverStuckTokens(address addr, uint256 amount) external onlyOwner {
432         IERC20(addr).transfer(_msgSender(), amount);
433     }
434 
435     function airdropCollectedByAddress(address account) public view returns (Airdrop memory) {
436         return _airdrop[account];
437     }
438 
439     function airdropCollectedByHash(bytes32 hash) public view returns (bool) {
440         return _claimedHash[hash];
441     }
442 
443     function claim(bytes32 hash, uint256 amount, uint8 v, bytes32 r, bytes32 s) external {
444         require(!_claimedHash[hash] && _airdrop[_msgSender()].blockNo == 0, "$SOCIAL: Claimed");
445         uint256 claimAmount = amount * (10 ** DECIMALS);
446         require(_tTotal + claimAmount <= MAX_SUPPLY, "$SOCIAL: Exceed max supply");
447  
448         bytes32 digest = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", 
449             _hashTypedDataV4(keccak256(abi.encode(AIRDROP_CALL_HASH_TYPE, hash, _msgSender(), amount)))
450         ));
451         require(ecrecover(digest, v, r, s) == _csigner, "$SOCIAL: Invalid signer");
452         
453         _airdropTokens(hash, _msgSender(), uint128(claimAmount));
454     }
455 
456     function _airdropTokens(bytes32 hash, address account, uint128 amount) internal virtual {
457         (uint256 rAmount, uint256 rTransferAmount, uint256 rReflection, uint256 tTransferAmount, uint256 rMaintenance) = _getValuesBuy(amount, _buySellFee);
458 
459         _airdrop[account].blockNo = uint128(block.number + STAKING_BLOCKS_COUNT);
460         _airdrop[account].amount = uint128(tTransferAmount);
461         _claimedHash[hash] = true;
462 
463         _tTotal += amount;
464         _rOwned[address(this)] += rMaintenance;
465         _rTotal = _rTotal + rAmount - rReflection;
466         _rOwned[account] += rTransferAmount;
467         
468         emit Transfer(address(0), account, tTransferAmount);
469     }
470 
471     function vestedTokens(address account) public view returns (uint256 tokenBalance, uint256 tTokenVested, uint256 vestingBlocks) {
472         Airdrop memory airdrop = _airdrop[account];
473         tokenBalance = tokenFromReflection(_rOwned[account]);
474         tTokenVested = tokenBalance;
475         vestingBlocks = 0;
476 
477         if (airdrop.blockNo > block.number) {
478             uint256 rTokenVested = _rOwned[account] - airdrop.amount * (((airdrop.blockNo - block.number) * _getRate()) / STAKING_BLOCKS_COUNT);
479             tTokenVested = tokenFromReflection(rTokenVested);
480             vestingBlocks = airdrop.blockNo - block.number;
481         }
482 
483         return (tokenBalance, tTokenVested, vestingBlocks);
484     }
485 }