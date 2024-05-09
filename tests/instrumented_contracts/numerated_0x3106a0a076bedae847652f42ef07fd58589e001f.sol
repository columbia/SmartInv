1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File contracts/external/UniswapV2Library.sol
4 
5 // SPDX-License-Identifier: GPL-3.0
6 pragma solidity ^0.8.0;
7 
8 // Exempt from the original UniswapV2Library.
9 library UniswapV2Library {
10     // returns sorted token addresses, used to handle return values from pairs sorted in this order
11     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
12         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
13         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
14         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
15     }
16 
17     // calculates the CREATE2 address for a pair without making any external calls
18     function pairFor(bytes32 initCodeHash, address factory, address tokenA, address tokenB) internal pure returns (address pair) {
19         (address token0, address token1) = sortTokens(tokenA, tokenB);
20         pair = address(uint160(uint(keccak256(abi.encodePacked(
21                 hex'ff',
22                 factory,
23                 keccak256(abi.encodePacked(token0, token1)),
24                 initCodeHash // init code hash
25             )))));
26     }
27 }
28 
29 
30 // File contracts/external/UniswapV3Library.sol
31 
32 /// @notice based on https://github.com/Uniswap/uniswap-v3-periphery/blob/v1.0.0/contracts/libraries/PoolAddress.sol
33 /// @notice changed compiler version and lib name.
34 
35 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
36 library UniswapV3Library {
37     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
38 
39     /// @notice The identifying key of the pool
40     struct PoolKey {
41         address token0;
42         address token1;
43         uint24 fee;
44     }
45 
46     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
47     /// @param tokenA The first token of a pool, unsorted
48     /// @param tokenB The second token of a pool, unsorted
49     /// @param fee The fee level of the pool
50     /// @return Poolkey The pool details with ordered token0 and token1 assignments
51     function getPoolKey(
52         address tokenA,
53         address tokenB,
54         uint24 fee
55     ) internal pure returns (PoolKey memory) {
56         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
57         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
58     }
59 
60     /// @notice Deterministically computes the pool address given the factory and PoolKey
61     /// @param factory The Uniswap V3 factory contract address
62     /// @param key The PoolKey
63     /// @return pool The contract address of the V3 pool
64     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
65         require(key.token0 < key.token1);
66         pool = address(
67             uint160(uint256(
68                 keccak256(
69                     abi.encodePacked(
70                         hex'ff',
71                         factory,
72                         keccak256(abi.encode(key.token0, key.token1, key.fee)),
73                         POOL_INIT_CODE_HASH
74                     )
75                 )
76             ))
77         );
78     }
79 }
80 
81 
82 // File contracts/IPLPS.sol
83 
84 
85 interface IPLPS {
86     function LiquidityProtection_beforeTokenTransfer(
87         address _pool, address _from, address _to, uint _amount) external;
88     function isBlocked(address _pool, address _who) external view returns(bool);
89     function unblock(address _pool, address _who) external;
90 }
91 
92 
93 // File contracts/UsingLiquidityProtectionService.sol
94 
95 
96 abstract contract UsingLiquidityProtectionService {
97     bool private protected = true;
98     uint64 internal constant HUNDRED_PERCENT = 1e18;
99     bytes32 internal constant UNISWAP = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
100     bytes32 internal constant PANCAKESWAP = 0x00fb7f630766e6a796048ea87d01acd3068e8ff67d078148a3fa3f4a84f69bd5;
101     bytes32 internal constant QUICKSWAP = 0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;
102 
103     enum UniswapVersion {
104         V2,
105         V3
106     }
107 
108     enum UniswapV3Fees {
109         _005, // 0.05%
110         _03, // 0.3%
111         _1 // 1%
112     }
113 
114     modifier onlyProtectionAdmin() {
115         protectionAdminCheck();
116         _;
117     }
118 
119     function token_transfer(address from, address to, uint amount) internal virtual;
120     function token_balanceOf(address holder) internal view virtual returns(uint);
121     function protectionAdminCheck() internal view virtual;
122     function liquidityProtectionService() internal pure virtual returns(address);
123     function uniswapVariety() internal pure virtual returns(bytes32);
124     function uniswapVersion() internal pure virtual returns(UniswapVersion);
125     function uniswapFactory() internal pure virtual returns(address);
126     function counterToken() internal pure virtual returns(address) {
127         return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
128     }
129     function uniswapV3Fee() internal pure virtual returns(UniswapV3Fees) {
130         return UniswapV3Fees._03;
131     }
132     function protectionChecker() internal view virtual returns(bool) {
133         return ProtectionSwitch_manual();
134     }
135 
136     function lps() private pure returns(IPLPS) {
137         return IPLPS(liquidityProtectionService());
138     }
139 
140     function LiquidityProtection_beforeTokenTransfer(address _from, address _to, uint _amount) internal virtual {
141         if (protectionChecker()) {
142             if (!protected) {
143                 return;
144             }
145             lps().LiquidityProtection_beforeTokenTransfer(getLiquidityPool(), _from, _to, _amount);
146         }
147     }
148 
149     function revokeBlocked(address[] calldata _holders, address _revokeTo) external onlyProtectionAdmin() {
150         require(protectionChecker(), 'UsingLiquidityProtectionService: protection removed');
151         protected = false;
152         address pool = getLiquidityPool();
153         for (uint i = 0; i < _holders.length; i++) {
154             address holder = _holders[i];
155             if (lps().isBlocked(pool, holder)) {
156                 token_transfer(holder, _revokeTo, token_balanceOf(holder));
157             }
158         }
159         protected = true;
160     }
161 
162     function LiquidityProtection_unblock(address[] calldata _holders) external onlyProtectionAdmin() {
163         require(protectionChecker(), 'UsingLiquidityProtectionService: protection removed');
164         address pool = getLiquidityPool();
165         for (uint i = 0; i < _holders.length; i++) {
166             lps().unblock(pool, _holders[i]);
167         }
168     }
169 
170     function disableProtection() external onlyProtectionAdmin() {
171         protected = false;
172     }
173 
174     function isProtected() public view returns(bool) {
175         return protected;
176     }
177 
178     function ProtectionSwitch_manual() internal view returns(bool) {
179         return protected;
180     }
181 
182     function ProtectionSwitch_timestamp(uint _timestamp) internal view returns(bool) {
183         return not(passed(_timestamp));
184     }
185 
186     function ProtectionSwitch_block(uint _block) internal view returns(bool) {
187         return not(blockPassed(_block));
188     }
189 
190     function blockPassed(uint _block) internal view returns(bool) {
191         return _block < block.number;
192     }
193 
194     function passed(uint _timestamp) internal view returns(bool) {
195         return _timestamp < block.timestamp;
196     }
197 
198     function not(bool _condition) internal pure returns(bool) {
199         return !_condition;
200     }
201 
202     function feeToUint24(UniswapV3Fees _fee) internal pure returns(uint24) {
203         if (_fee == UniswapV3Fees._03) return 3000;
204         if (_fee == UniswapV3Fees._005) return 500;
205         return 10000;
206     }
207 
208     function getLiquidityPool() public view returns(address) {
209         if (uniswapVersion() == UniswapVersion.V2) {
210             return UniswapV2Library.pairFor(uniswapVariety(), uniswapFactory(), address(this), counterToken());
211         }
212         require(uniswapVariety() == UNISWAP, 'LiquidityProtection: uniswapVariety() can only be UNISWAP for V3.');
213         return UniswapV3Library.computeAddress(uniswapFactory(),
214             UniswapV3Library.getPoolKey(address(this), counterToken(), feeToUint24(uniswapV3Fee())));
215     }
216 }
217 
218 
219 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
220 
221 
222 /*
223  * @dev Provides information about the current execution context, including the
224  * sender of the transaction and its data. While these are generally available
225  * via msg.sender and msg.data, they should not be accessed in such a direct
226  * manner, since when dealing with meta-transactions the account sending and
227  * paying for execution may not be the actual sender (as far as an application
228  * is concerned).
229  *
230  * This contract is only required for intermediate, library-like contracts.
231  */
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address) {
234         return msg.sender;
235     }
236 
237     function _msgData() internal view virtual returns (bytes calldata) {
238         return msg.data;
239     }
240 }
241 
242 
243 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
244 
245 
246 /**
247  * @dev Contract module which provides a basic access control mechanism, where
248  * there is an account (an owner) that can be granted exclusive access to
249  * specific functions.
250  *
251  * By default, the owner account will be the one that deploys the contract. This
252  * can later be changed with {transferOwnership}.
253  *
254  * This module is used through inheritance. It will make available the modifier
255  * `onlyOwner`, which can be applied to your functions to restrict their use to
256  * the owner.
257  */
258 abstract contract Ownable is Context {
259     address private _owner;
260 
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     /**
264      * @dev Initializes the contract setting the deployer as the initial owner.
265      */
266     constructor() {
267         _setOwner(_msgSender());
268     }
269 
270     /**
271      * @dev Returns the address of the current owner.
272      */
273     function owner() public view virtual returns (address) {
274         return _owner;
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
282         _;
283     }
284 
285     /**
286      * @dev Leaves the contract without owner. It will not be possible to call
287      * `onlyOwner` functions anymore. Can only be called by the current owner.
288      *
289      * NOTE: Renouncing ownership will leave the contract without an owner,
290      * thereby removing any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public virtual onlyOwner {
293         _setOwner(address(0));
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Can only be called by the current owner.
299      */
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(newOwner != address(0), "Ownable: new owner is the zero address");
302         _setOwner(newOwner);
303     }
304 
305     function _setOwner(address newOwner) private {
306         address oldOwner = _owner;
307         _owner = newOwner;
308         emit OwnershipTransferred(oldOwner, newOwner);
309     }
310 }
311 
312 
313 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
314 
315 
316 /**
317  * @dev Interface of the ERC20 standard as defined in the EIP.
318  */
319 interface IERC20 {
320     /**
321      * @dev Returns the amount of tokens in existence.
322      */
323     function totalSupply() external view returns (uint256);
324 
325     /**
326      * @dev Returns the amount of tokens owned by `account`.
327      */
328     function balanceOf(address account) external view returns (uint256);
329 
330     /**
331      * @dev Moves `amount` tokens from the caller's account to `recipient`.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transfer(address recipient, uint256 amount) external returns (bool);
338 
339     /**
340      * @dev Returns the remaining number of tokens that `spender` will be
341      * allowed to spend on behalf of `owner` through {transferFrom}. This is
342      * zero by default.
343      *
344      * This value changes when {approve} or {transferFrom} are called.
345      */
346     function allowance(address owner, address spender) external view returns (uint256);
347 
348     /**
349      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * IMPORTANT: Beware that changing an allowance with this method brings the risk
354      * that someone may use both the old and the new allowance by unfortunate
355      * transaction ordering. One possible solution to mitigate this race
356      * condition is to first reduce the spender's allowance to 0 and set the
357      * desired value afterwards:
358      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
359      *
360      * Emits an {Approval} event.
361      */
362     function approve(address spender, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Moves `amount` tokens from `sender` to `recipient` using the
366      * allowance mechanism. `amount` is then deducted from the caller's
367      * allowance.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) external returns (bool);
378 
379     /**
380      * @dev Emitted when `value` tokens are moved from one account (`from`) to
381      * another (`to`).
382      *
383      * Note that `value` may be zero.
384      */
385     event Transfer(address indexed from, address indexed to, uint256 value);
386 
387     /**
388      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
389      * a call to {approve}. `value` is the new allowance.
390      */
391     event Approval(address indexed owner, address indexed spender, uint256 value);
392 }
393 
394 
395 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.2.0
396 
397 
398 
399 
400 
401 /**
402  * @dev Interface for the optional metadata functions from the ERC20 standard.
403  *
404  * _Available since v4.1._
405  */
406 interface IERC20Metadata is IERC20 {
407     /**
408      * @dev Returns the name of the token.
409      */
410     function name() external view returns (string memory);
411 
412     /**
413      * @dev Returns the symbol of the token.
414      */
415     function symbol() external view returns (string memory);
416 
417     /**
418      * @dev Returns the decimals places of the token.
419      */
420     function decimals() external view returns (uint8);
421 }
422 
423 
424 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.2.0
425 
426 
427 
428 /**
429  * @dev Implementation of the {IERC20} interface.
430  *
431  * This implementation is agnostic to the way tokens are created. This means
432  * that a supply mechanism has to be added in a derived contract using {_mint}.
433  * For a generic mechanism see {ERC20PresetMinterPauser}.
434  *
435  * TIP: For a detailed writeup see our guide
436  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
437  * to implement supply mechanisms].
438  *
439  * We have followed general OpenZeppelin guidelines: functions revert instead
440  * of returning `false` on failure. This behavior is nonetheless conventional
441  * and does not conflict with the expectations of ERC20 applications.
442  *
443  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
444  * This allows applications to reconstruct the allowance for all accounts just
445  * by listening to said events. Other implementations of the EIP may not emit
446  * these events, as it isn't required by the specification.
447  *
448  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
449  * functions have been added to mitigate the well-known issues around setting
450  * allowances. See {IERC20-approve}.
451  */
452 contract ERC20 is Context, IERC20, IERC20Metadata {
453     mapping(address => uint256) private _balances;
454 
455     mapping(address => mapping(address => uint256)) private _allowances;
456 
457     uint256 private _totalSupply;
458 
459     string private _name;
460     string private _symbol;
461 
462     /**
463      * @dev Sets the values for {name} and {symbol}.
464      *
465      * The default value of {decimals} is 18. To select a different value for
466      * {decimals} you should overload it.
467      *
468      * All two of these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor(string memory name_, string memory symbol_) {
472         _name = name_;
473         _symbol = symbol_;
474     }
475 
476     /**
477      * @dev Returns the name of the token.
478      */
479     function name() public view virtual override returns (string memory) {
480         return _name;
481     }
482 
483     /**
484      * @dev Returns the symbol of the token, usually a shorter version of the
485      * name.
486      */
487     function symbol() public view virtual override returns (string memory) {
488         return _symbol;
489     }
490 
491     /**
492      * @dev Returns the number of decimals used to get its user representation.
493      * For example, if `decimals` equals `2`, a balance of `505` tokens should
494      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
495      *
496      * Tokens usually opt for a value of 18, imitating the relationship between
497      * Ether and Wei. This is the value {ERC20} uses, unless this function is
498      * overridden;
499      *
500      * NOTE: This information is only used for _display_ purposes: it in
501      * no way affects any of the arithmetic of the contract, including
502      * {IERC20-balanceOf} and {IERC20-transfer}.
503      */
504     function decimals() public view virtual override returns (uint8) {
505         return 18;
506     }
507 
508     /**
509      * @dev See {IERC20-totalSupply}.
510      */
511     function totalSupply() public view virtual override returns (uint256) {
512         return _totalSupply;
513     }
514 
515     /**
516      * @dev See {IERC20-balanceOf}.
517      */
518     function balanceOf(address account) public view virtual override returns (uint256) {
519         return _balances[account];
520     }
521 
522     /**
523      * @dev See {IERC20-transfer}.
524      *
525      * Requirements:
526      *
527      * - `recipient` cannot be the zero address.
528      * - the caller must have a balance of at least `amount`.
529      */
530     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
531         _transfer(_msgSender(), recipient, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-allowance}.
537      */
538     function allowance(address owner, address spender) public view virtual override returns (uint256) {
539         return _allowances[owner][spender];
540     }
541 
542     /**
543      * @dev See {IERC20-approve}.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      */
549     function approve(address spender, uint256 amount) public virtual override returns (bool) {
550         _approve(_msgSender(), spender, amount);
551         return true;
552     }
553 
554     /**
555      * @dev See {IERC20-transferFrom}.
556      *
557      * Emits an {Approval} event indicating the updated allowance. This is not
558      * required by the EIP. See the note at the beginning of {ERC20}.
559      *
560      * Requirements:
561      *
562      * - `sender` and `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `amount`.
564      * - the caller must have allowance for ``sender``'s tokens of at least
565      * `amount`.
566      */
567     function transferFrom(
568         address sender,
569         address recipient,
570         uint256 amount
571     ) public virtual override returns (bool) {
572         _transfer(sender, recipient, amount);
573 
574         uint256 currentAllowance = _allowances[sender][_msgSender()];
575         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
576         unchecked {
577             _approve(sender, _msgSender(), currentAllowance - amount);
578         }
579 
580         return true;
581     }
582 
583     /**
584      * @dev Atomically increases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
596         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
597         return true;
598     }
599 
600     /**
601      * @dev Atomically decreases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      * - `spender` must have allowance for the caller of at least
612      * `subtractedValue`.
613      */
614     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
615         uint256 currentAllowance = _allowances[_msgSender()][spender];
616         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
617         unchecked {
618             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
619         }
620 
621         return true;
622     }
623 
624     /**
625      * @dev Moves `amount` of tokens from `sender` to `recipient`.
626      *
627      * This internal function is equivalent to {transfer}, and can be used to
628      * e.g. implement automatic token fees, slashing mechanisms, etc.
629      *
630      * Emits a {Transfer} event.
631      *
632      * Requirements:
633      *
634      * - `sender` cannot be the zero address.
635      * - `recipient` cannot be the zero address.
636      * - `sender` must have a balance of at least `amount`.
637      */
638     function _transfer(
639         address sender,
640         address recipient,
641         uint256 amount
642     ) internal virtual {
643         require(sender != address(0), "ERC20: transfer from the zero address");
644         require(recipient != address(0), "ERC20: transfer to the zero address");
645 
646         _beforeTokenTransfer(sender, recipient, amount);
647 
648         uint256 senderBalance = _balances[sender];
649         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
650         unchecked {
651             _balances[sender] = senderBalance - amount;
652         }
653         _balances[recipient] += amount;
654 
655         emit Transfer(sender, recipient, amount);
656 
657         _afterTokenTransfer(sender, recipient, amount);
658     }
659 
660     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
661      * the total supply.
662      *
663      * Emits a {Transfer} event with `from` set to the zero address.
664      *
665      * Requirements:
666      *
667      * - `account` cannot be the zero address.
668      */
669     function _mint(address account, uint256 amount) internal virtual {
670         require(account != address(0), "ERC20: mint to the zero address");
671 
672         _beforeTokenTransfer(address(0), account, amount);
673 
674         _totalSupply += amount;
675         _balances[account] += amount;
676         emit Transfer(address(0), account, amount);
677 
678         _afterTokenTransfer(address(0), account, amount);
679     }
680 
681     /**
682      * @dev Destroys `amount` tokens from `account`, reducing the
683      * total supply.
684      *
685      * Emits a {Transfer} event with `to` set to the zero address.
686      *
687      * Requirements:
688      *
689      * - `account` cannot be the zero address.
690      * - `account` must have at least `amount` tokens.
691      */
692     function _burn(address account, uint256 amount) internal virtual {
693         require(account != address(0), "ERC20: burn from the zero address");
694 
695         _beforeTokenTransfer(account, address(0), amount);
696 
697         uint256 accountBalance = _balances[account];
698         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
699         unchecked {
700             _balances[account] = accountBalance - amount;
701         }
702         _totalSupply -= amount;
703 
704         emit Transfer(account, address(0), amount);
705 
706         _afterTokenTransfer(account, address(0), amount);
707     }
708 
709     /**
710      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
711      *
712      * This internal function is equivalent to `approve`, and can be used to
713      * e.g. set automatic allowances for certain subsystems, etc.
714      *
715      * Emits an {Approval} event.
716      *
717      * Requirements:
718      *
719      * - `owner` cannot be the zero address.
720      * - `spender` cannot be the zero address.
721      */
722     function _approve(
723         address owner,
724         address spender,
725         uint256 amount
726     ) internal virtual {
727         require(owner != address(0), "ERC20: approve from the zero address");
728         require(spender != address(0), "ERC20: approve to the zero address");
729 
730         _allowances[owner][spender] = amount;
731         emit Approval(owner, spender, amount);
732     }
733 
734     /**
735      * @dev Hook that is called before any transfer of tokens. This includes
736      * minting and burning.
737      *
738      * Calling conditions:
739      *
740      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
741      * will be transferred to `to`.
742      * - when `from` is zero, `amount` tokens will be minted for `to`.
743      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
744      * - `from` and `to` are never both zero.
745      *
746      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
747      */
748     function _beforeTokenTransfer(
749         address from,
750         address to,
751         uint256 amount
752     ) internal virtual {}
753 
754     /**
755      * @dev Hook that is called after any transfer of tokens. This includes
756      * minting and burning.
757      *
758      * Calling conditions:
759      *
760      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
761      * has been transferred to `to`.
762      * - when `from` is zero, `amount` tokens have been minted for `to`.
763      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
764      * - `from` and `to` are never both zero.
765      *
766      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
767      */
768     function _afterTokenTransfer(
769         address from,
770         address to,
771         uint256 amount
772     ) internal virtual {}
773 }
774 
775 
776 // File contracts/AlkimiERC20.sol
777 
778 
779 
780 contract AlkimiExchangeToken is ERC20, Ownable, UsingLiquidityProtectionService {
781     function token_transfer(address _from, address _to, uint _amount) internal override {
782         _transfer(_from, _to, _amount); // Expose low-level token transfer function.
783     }
784     function token_balanceOf(address _holder) internal view override returns(uint) {
785         return balanceOf(_holder); // Expose balance check function.
786     }
787     function protectionAdminCheck() internal view override onlyOwner {} // Must revert to deny access.
788     function liquidityProtectionService() internal pure override returns(address) {
789         return 0xB59Dfc14D2037e3c4BF9C4FC1219f941E36De3e2;
790     }
791     function uniswapVariety() internal pure override returns(bytes32) {
792         return UNISWAP; // UNISWAP / PANCAKESWAP / QUICKSWAP.
793     }
794     function uniswapVersion() internal pure override returns(UniswapVersion) {
795         return UniswapVersion.V2; // V2 or V3.
796     }
797     function uniswapFactory() internal pure override returns(address) {
798         return 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f; // Replace with the correct address.
799     }
800     function _beforeTokenTransfer(address _from, address _to, uint _amount) internal override {
801         super._beforeTokenTransfer(_from, _to, _amount);
802         LiquidityProtection_beforeTokenTransfer(_from, _to, _amount);
803     }
804     // All the following overrides are optional, if you want to modify default behavior.
805 
806     // How the protection gets disabled.
807     function protectionChecker() internal view override returns(bool) {
808          return ProtectionSwitch_timestamp(1632873599); // Switch off protection on Friday, April 22, 2022 4:16:31 PM.
809         // return ProtectionSwitch_block(13000000); // Switch off protection on block 13000000.
810 //        return ProtectionSwitch_manual(); // Switch off protection by calling disableProtection(); from owner. Default.
811     }
812 
813     // This token will be pooled in pair with:
814     function counterToken() internal pure override returns(address) {
815         return 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // WETH
816     }
817 
818     constructor() ERC20('Alkimi Exchange', '$ADS') {
819         _mint(owner(), 250000000 * 1e18);
820     }
821 }