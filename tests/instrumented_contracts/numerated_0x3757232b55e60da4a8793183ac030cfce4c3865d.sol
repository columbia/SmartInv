1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/LERC20.sol
4 
5 pragma solidity ^0.8.0;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface ILosslessController {
37     function beforeTransfer(address sender, address recipient, uint256 amount) external;
38 
39     function beforeTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;
40 
41     function beforeApprove(address sender, address spender, uint256 amount) external;
42 
43     function beforeIncreaseAllowance(address msgSender, address spender, uint256 addedValue) external;
44 
45     function beforeDecreaseAllowance(address msgSender, address spender, uint256 subtractedValue) external;
46 
47     function afterApprove(address sender, address spender, uint256 amount) external;
48 
49     function afterTransfer(address sender, address recipient, uint256 amount) external;
50 
51     function afterTransferFrom(address msgSender, address sender, address recipient, uint256 amount) external;
52 
53     function afterIncreaseAllowance(address sender, address spender, uint256 addedValue) external;
54 
55     function afterDecreaseAllowance(address sender, address spender, uint256 subtractedValue) external;
56 }
57 
58 contract LERC20 is Context, IERC20 {
59     mapping (address => uint256) private _balances;
60     mapping (address => mapping (address => uint256)) private _allowances;
61     uint256 private _totalSupply;
62     string private _name;
63     string private _symbol;
64 
65     address public recoveryAdmin;
66     address private recoveryAdminCanditate;
67     bytes32 private recoveryAdminKeyHash;
68     address public admin;
69     uint256 public timelockPeriod;
70     uint256 public losslessTurnOffTimestamp;
71     bool public isLosslessTurnOffProposed;
72     bool public isLosslessOn = true;
73     ILosslessController private lossless;
74 
75     event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
76     event RecoveryAdminChangeProposed(address indexed candidate);
77     event RecoveryAdminChanged(address indexed previousAdmin, address indexed newAdmin);
78     event LosslessTurnOffProposed(uint256 turnOffDate);
79     event LosslessTurnedOff();
80     event LosslessTurnedOn();
81 
82     constructor(uint256 totalSupply_, string memory name_, string memory symbol_, address admin_, address recoveryAdmin_, uint256 timelockPeriod_, address lossless_) {
83         _name = name_;
84         _symbol = symbol_;
85         admin = admin_;
86         _mint(admin, totalSupply_);
87         recoveryAdmin = recoveryAdmin_;
88         timelockPeriod = timelockPeriod_;
89         lossless = ILosslessController(lossless_);
90     }
91 
92     // --- LOSSLESS modifiers ---
93 
94     modifier lssAprove(address spender, uint256 amount) {
95         if (isLosslessOn) {
96             lossless.beforeApprove(_msgSender(), spender, amount);
97             _;
98             lossless.afterApprove(_msgSender(), spender, amount);
99         } else {
100             _;
101         }
102     }
103 
104     modifier lssTransfer(address recipient, uint256 amount) {
105         if (isLosslessOn) {
106             lossless.beforeTransfer(_msgSender(), recipient, amount);
107             _;
108             lossless.afterTransfer(_msgSender(), recipient, amount);
109         } else {
110             _;
111         }
112     }
113 
114     modifier lssTransferFrom(address sender, address recipient, uint256 amount) {
115         if (isLosslessOn) {
116             lossless.beforeTransferFrom(_msgSender(),sender, recipient, amount);
117             _;
118             lossless.afterTransferFrom(_msgSender(), sender, recipient, amount);
119         } else {
120             _;
121         }
122     }
123 
124     modifier lssIncreaseAllowance(address spender, uint256 addedValue) {
125         if (isLosslessOn) {
126             lossless.beforeIncreaseAllowance(_msgSender(), spender, addedValue);
127             _;
128             lossless.afterIncreaseAllowance(_msgSender(), spender, addedValue);
129         } else {
130             _;
131         }
132     }
133 
134     modifier lssDecreaseAllowance(address spender, uint256 subtractedValue) {
135         if (isLosslessOn) {
136             lossless.beforeDecreaseAllowance(_msgSender(), spender, subtractedValue);
137             _;
138             lossless.afterDecreaseAllowance(_msgSender(), spender, subtractedValue);
139         } else {
140             _;
141         }
142     }
143 
144     modifier onlyRecoveryAdmin() {
145         require(_msgSender() == recoveryAdmin, "LERC20: Must be recovery admin");
146         _;
147     }
148 
149     // --- LOSSLESS management ---
150 
151     function getAdmin() external view returns (address) {
152         return admin;
153     }
154 
155     function transferOutBlacklistedFunds(address[] calldata from) external {
156         require(_msgSender() == address(lossless), "LERC20: Only lossless contract");
157         for (uint i = 0; i < from.length; i++) {
158             _transfer(from[i], address(lossless), balanceOf(from[i]));
159         }
160     }
161 
162     function setLosslessAdmin(address newAdmin) public onlyRecoveryAdmin {
163         emit AdminChanged(admin, newAdmin);
164         admin = newAdmin;
165     }
166 
167     function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) public onlyRecoveryAdmin {
168         recoveryAdminCanditate = candidate;
169         recoveryAdminKeyHash = keyHash;
170         emit RecoveryAdminChangeProposed(candidate);
171     }
172 
173     function acceptRecoveryAdminOwnership(bytes memory key) external {
174         require(_msgSender() == recoveryAdminCanditate, "LERC20: Must be canditate");
175         require(keccak256(key) == recoveryAdminKeyHash, "LERC20: Invalid key");
176         emit RecoveryAdminChanged(recoveryAdmin, recoveryAdminCanditate);
177         recoveryAdmin = recoveryAdminCanditate;
178     }
179 
180     function proposeLosslessTurnOff() public onlyRecoveryAdmin {
181         losslessTurnOffTimestamp = block.timestamp + timelockPeriod;
182         isLosslessTurnOffProposed = true;
183         emit LosslessTurnOffProposed(losslessTurnOffTimestamp);
184     }
185 
186     function executeLosslessTurnOff() public onlyRecoveryAdmin {
187         require(isLosslessTurnOffProposed, "LERC20: TurnOff not proposed");
188         require(losslessTurnOffTimestamp <= block.timestamp, "LERC20: Time lock in progress");
189         isLosslessOn = false;
190         isLosslessTurnOffProposed = false;
191         emit LosslessTurnedOff();
192     }
193 
194     function executeLosslessTurnOn() public onlyRecoveryAdmin {
195         isLosslessTurnOffProposed = false;
196         isLosslessOn = true;
197         emit LosslessTurnedOn();
198     }
199 
200     // --- ERC20 methods ---
201 
202     function name() public view virtual returns (string memory) {
203         return _name;
204     }
205 
206     function symbol() public view virtual returns (string memory) {
207         return _symbol;
208     }
209 
210     function decimals() public view virtual returns (uint8) {
211         return 18;
212     }
213 
214     function totalSupply() public view virtual override returns (uint256) {
215         return _totalSupply;
216     }
217 
218     function balanceOf(address account) public view virtual override returns (uint256) {
219         return _balances[account];
220     }
221 
222     function transfer(address recipient, uint256 amount) public virtual override lssTransfer(recipient, amount) returns (bool) {
223         _transfer(_msgSender(), recipient, amount);
224         return true;
225     }
226 
227     function allowance(address owner, address spender) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     function approve(address spender, uint256 amount) public virtual override lssAprove(spender, amount) returns (bool) {
232         require((amount == 0) || (_allowances[_msgSender()][spender] == 0), "LERC20: Cannot change non zero allowance");
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236 
237     function transferFrom(address sender, address recipient, uint256 amount) public virtual override lssTransferFrom(sender, recipient, amount) returns (bool) {
238         _transfer(sender, recipient, amount);
239 
240         uint256 currentAllowance = _allowances[sender][_msgSender()];
241         require(currentAllowance >= amount, "LERC20: transfer amount exceeds allowance");
242         _approve(sender, _msgSender(), currentAllowance - amount);
243 
244         return true;
245     }
246 
247     function increaseAllowance(address spender, uint256 addedValue) public virtual lssIncreaseAllowance(spender, addedValue) returns (bool) {
248         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
249         return true;
250     }
251 
252     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual lssDecreaseAllowance(spender, subtractedValue) returns (bool) {
253         uint256 currentAllowance = _allowances[_msgSender()][spender];
254         require(currentAllowance >= subtractedValue, "LERC20: decreased allowance below zero");
255         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
256 
257         return true;
258     }
259 
260     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
261         require(sender != address(0), "LERC20: transfer from the zero address");
262         require(recipient != address(0), "LERC20: transfer to the zero address");
263 
264         _beforeTokenTransfer(sender, recipient, amount);
265 
266         uint256 senderBalance = _balances[sender];
267         require(senderBalance >= amount, "LERC20: transfer amount exceeds balance");
268         _balances[sender] = senderBalance - amount;
269         _balances[recipient] += amount;
270 
271         emit Transfer(sender, recipient, amount);
272     }
273 
274     function _mint(address account, uint256 amount) internal virtual {
275         require(account != address(0), "LERC20: mint to the zero address");
276 
277         _totalSupply += amount;
278         _balances[account] += amount;
279         emit Transfer(address(0), account, amount);
280     }
281 
282     function _approve(address owner, address spender, uint256 amount) internal virtual {
283         require(owner != address(0), "LERC20: approve from the zero address");
284         require(spender != address(0), "LERC20: approve to the zero address");
285 
286         _allowances[owner][spender] = amount;
287         emit Approval(owner, spender, amount);
288     }
289 
290     function _burn(address account, uint256 amount) internal virtual {
291         require(account != address(0), "ERC20: burn from the zero address");
292 
293         uint256 accountBalance = _balances[account];
294         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
295         _balances[account] = accountBalance - amount;
296         _totalSupply -= amount;
297 
298         emit Transfer(account, address(0), amount);
299     }
300 
301     /**
302      * @dev Hook that is called before any transfer of tokens. This includes
303      * minting and burning.
304      *
305      * Calling conditions:
306      *
307      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
308      * will be to transferred to `to`.
309      * - when `from` is zero, `amount` tokens will be minted for `to`.
310      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
311      * - `from` and `to` are never both zero.
312      *
313      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
314      */
315     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
316 }
317 
318 // File: contracts/external/UniswapV2Library.sol
319 
320 pragma solidity ^0.8.0;
321 
322 // Exempt from the original UniswapV2Library.
323 library UniswapV2Library {
324     // returns sorted token addresses, used to handle return values from pairs sorted in this order
325     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
326         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
327         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
328         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
329     }
330 
331     // calculates the CREATE2 address for a pair without making any external calls
332     function pairFor(bytes32 initCodeHash, address factory, address tokenA, address tokenB) internal pure returns (address pair) {
333         (address token0, address token1) = sortTokens(tokenA, tokenB);
334         pair = address(uint160(uint(keccak256(abi.encodePacked(
335                 hex'ff',
336                 factory,
337                 keccak256(abi.encodePacked(token0, token1)),
338                 initCodeHash // init code hash
339             )))));
340     }
341 }
342 
343 // File: contracts/external/UniswapV3Library.sol
344 
345 pragma solidity ^0.8.0;
346 
347 /// @notice based on https://github.com/Uniswap/uniswap-v3-periphery/blob/v1.0.0/contracts/libraries/PoolAddress.sol
348 /// @notice changed compiler version and lib name.
349 
350 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
351 library UniswapV3Library {
352     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
353 
354     /// @notice The identifying key of the pool
355     struct PoolKey {
356         address token0;
357         address token1;
358         uint24 fee;
359     }
360 
361     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
362     /// @param tokenA The first token of a pool, unsorted
363     /// @param tokenB The second token of a pool, unsorted
364     /// @param fee The fee level of the pool
365     /// @return Poolkey The pool details with ordered token0 and token1 assignments
366     function getPoolKey(
367         address tokenA,
368         address tokenB,
369         uint24 fee
370     ) internal pure returns (PoolKey memory) {
371         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
372         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
373     }
374 
375     /// @notice Deterministically computes the pool address given the factory and PoolKey
376     /// @param factory The Uniswap V3 factory contract address
377     /// @param key The PoolKey
378     /// @return pool The contract address of the V3 pool
379     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
380         require(key.token0 < key.token1);
381         pool = address(
382             uint160(
383                 uint256(
384                     keccak256(
385                         abi.encodePacked(
386                             hex'ff',
387                             factory,
388                             keccak256(abi.encode(key.token0, key.token1, key.fee)),
389                             POOL_INIT_CODE_HASH
390                         )
391                     )
392                 )
393             )
394         );
395     }
396 }
397 
398 // File: contracts/IPLPS.sol
399 
400 pragma solidity ^0.8.0;
401 
402 interface IPLPS {
403     function LiquidityProtection_beforeTokenTransfer(
404         address _pool, address _from, address _to, uint _amount) external;
405     function isBlocked(address _pool, address _who) external view returns(bool);
406     function unblock(address _pool, address _who) external;
407 }
408 
409 // File: contracts/UsingLiquidityProtectionService.sol
410 
411 pragma solidity ^0.8.0;
412 
413 
414 
415 
416 abstract contract UsingLiquidityProtectionService {
417     bool private unProtected = false;
418     IPLPS private plps;
419     uint64 internal constant HUNDRED_PERCENT = 1e18;
420     bytes32 internal constant UNISWAP = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
421     bytes32 internal constant PANCAKESWAP = 0x00fb7f630766e6a796048ea87d01acd3068e8ff67d078148a3fa3f4a84f69bd5;
422     bytes32 internal constant QUICKSWAP = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
423 
424     enum UniswapVersion {
425         V2,
426         V3
427     }
428 
429     enum UniswapV3Fees {
430         _005, // 0.05%
431         _03, // 0.3%
432         _1 // 1%
433     }
434 
435     modifier onlyProtectionAdmin() {
436         protectionAdminCheck();
437         _;
438     }
439 
440     constructor (address _plps) {
441         plps = IPLPS(_plps);
442     }
443 
444     function LiquidityProtection_setLiquidityProtectionService(IPLPS _plps) external onlyProtectionAdmin() {
445         plps = _plps;
446     }
447 
448     function token_transfer(address from, address to, uint amount) internal virtual;
449     function token_balanceOf(address holder) internal view virtual returns(uint);
450     function protectionAdminCheck() internal view virtual;
451     function uniswapVariety() internal pure virtual returns(bytes32);
452     function uniswapVersion() internal pure virtual returns(UniswapVersion);
453     function uniswapFactory() internal pure virtual returns(address);
454     function counterToken() internal pure virtual returns(address) {
455         return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
456     }
457     function uniswapV3Fee() internal pure virtual returns(UniswapV3Fees) {
458         return UniswapV3Fees._03;
459     }
460     function protectionChecker() internal view virtual returns(bool) {
461         return ProtectionSwitch_manual();
462     }
463 
464     function lps() private view returns(IPLPS) {
465         return plps;
466     }
467 
468     function LiquidityProtection_beforeTokenTransfer(address _from, address _to, uint _amount) internal virtual {
469         if (protectionChecker()) {
470             if (unProtected) {
471                 return;
472             }
473             lps().LiquidityProtection_beforeTokenTransfer(getLiquidityPool(), _from, _to, _amount);
474         }
475     }
476 
477     function revokeBlocked(address[] calldata _holders, address _revokeTo) external onlyProtectionAdmin() {
478         require(protectionChecker(), 'UsingLiquidityProtectionService: protection removed');
479         unProtected = true;
480         address pool = getLiquidityPool();
481         for (uint i = 0; i < _holders.length; i++) {
482             address holder = _holders[i];
483             if (lps().isBlocked(pool, holder)) {
484                 token_transfer(holder, _revokeTo, token_balanceOf(holder));
485             }
486         }
487         unProtected = false;
488     }
489 
490     function LiquidityProtection_unblock(address[] calldata _holders) external onlyProtectionAdmin() {
491         require(protectionChecker(), 'UsingLiquidityProtectionService: protection removed');
492         address pool = getLiquidityPool();
493         for (uint i = 0; i < _holders.length; i++) {
494             lps().unblock(pool, _holders[i]);
495         }
496     }
497 
498     function disableProtection() external onlyProtectionAdmin() {
499         unProtected = true;
500     }
501 
502     function isProtected() public view returns(bool) {
503         return not(unProtected);
504     }
505 
506     function ProtectionSwitch_manual() internal view returns(bool) {
507         return isProtected();
508     }
509 
510     function ProtectionSwitch_timestamp(uint _timestamp) internal view returns(bool) {
511         return not(passed(_timestamp));
512     }
513 
514     function ProtectionSwitch_block(uint _block) internal view returns(bool) {
515         return not(blockPassed(_block));
516     }
517 
518     function blockPassed(uint _block) internal view returns(bool) {
519         return _block < block.number;
520     }
521 
522     function passed(uint _timestamp) internal view returns(bool) {
523         return _timestamp < block.timestamp;
524     }
525 
526     function not(bool _condition) internal pure returns(bool) {
527         return !_condition;
528     }
529 
530     function feeToUint24(UniswapV3Fees _fee) internal pure returns(uint24) {
531         if (_fee == UniswapV3Fees._03) return 3000;
532         if (_fee == UniswapV3Fees._005) return 500;
533         return 10000;
534     }
535 
536     function getLiquidityPool() public view returns(address) {
537         if (uniswapVersion() == UniswapVersion.V2) {
538             return UniswapV2Library.pairFor(uniswapVariety(), uniswapFactory(), address(this), counterToken());
539         }
540         require(uniswapVariety() == UNISWAP, 'LiquidityProtection: uniswapVariety() can only be UNISWAP for V3.');
541         return UniswapV3Library.computeAddress(uniswapFactory(),
542             UniswapV3Library.getPoolKey(address(this), counterToken(), feeToUint24(uniswapV3Fee())));
543     }
544 }
545 
546 // File: contracts/YDR.sol
547 
548 
549 pragma solidity ^0.8.0;
550 
551 
552 
553 contract YDR is LERC20, UsingLiquidityProtectionService(0x5C3fB8fF925996da50f03836FD8734270f5016AC) {
554     constructor(uint256 totalSupply_, address admin_, address recoveryAdmin_, uint256 timelockPeriod_, address lossless_) LERC20(totalSupply_, "YDragon", "YDR", admin_, recoveryAdmin_, timelockPeriod_, lossless_) {
555 
556     }
557 
558     modifier onlyAdmin() {
559         require(admin == _msgSender(), "YDR: caller is not the admin");
560         _;
561     }
562 
563     function burn(uint256 amount) external onlyAdmin {
564         _burn(_msgSender(), amount);
565     }
566 
567     function token_transfer(address _from, address _to, uint _amount) internal override {
568         _transfer(_from, _to, _amount); // Expose low-level token transfer function.
569     }
570     function token_balanceOf(address _holder) internal view override returns(uint) {
571         return balanceOf(_holder); // Expose balance check function.
572     }
573     function protectionAdminCheck() internal view override onlyAdmin {} // Must revert to deny access.
574     function uniswapVariety() internal pure override returns(bytes32) {
575         return UNISWAP; // UNISWAP / PANCAKESWAP / QUICKSWAP.
576     }
577     function uniswapVersion() internal pure override returns(UniswapVersion) {
578         return UniswapVersion.V3; // V2 or V3.
579     }
580     function uniswapFactory() internal pure override returns(address) {
581         return 0x1F98431c8aD98523631AE4a59f267346ea31F984; // Replace with the correct address.
582     }
583     function _beforeTokenTransfer(address _from, address _to, uint _amount) internal override {
584         super._beforeTokenTransfer(_from, _to, _amount);
585         LiquidityProtection_beforeTokenTransfer(_from, _to, _amount);
586     }
587     // All the following overrides are optional, if you want to modify default behavior.
588 
589     // How the protection gets disabled.
590     function protectionChecker() internal view override returns(bool) {
591          return ProtectionSwitch_timestamp(1630367999); // Switch off protection on Monday, August 30, 2021 11:59:59 PM GTM.
592         // return ProtectionSwitch_block(13000000); // Switch off protection on block 13000000.
593 //        return ProtectionSwitch_manual(); // Switch off protection by calling disableProtection(); from owner. Default.
594     }
595 
596     // This token will be pooled in pair with:
597     function counterToken() internal pure override returns(address) {
598         return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
599     }
600 
601 }