1 /**
2  *
3  *
4  *
5  *  █████████  █████       ███  █████                         █████      ███
6  * ███░░░░░███░░███       ░░░  ░░███                         ░░███      ░░░
7  *░███    ░░░  ░███████   ████  ░███████  ████████    ██████  ░███████  ████
8  *░░█████████  ░███░░███ ░░███  ░███░░███░░███░░███  ███░░███ ░███░░███░░███
9  * ░░░░░░░░███ ░███ ░███  ░███  ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███
10  * ███    ░███ ░███ ░███  ░███  ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███ ░███
11  *░░█████████  ████ █████ █████ ████████  ████ █████░░██████  ████████  █████
12  * ░░░░░░░░░  ░░░░ ░░░░░ ░░░░░ ░░░░░░░░  ░░░░ ░░░░░  ░░░░░░  ░░░░░░░░  ░░░░░
13  *
14  *
15  */
16 
17 // Shibnobi V2
18 // Version: 20221104001
19 // Website: www.shibnobi.com
20 // Twitter: https://twitter.com/Shib_nobi (@Shib_nobi)
21 // TG: https://t.me/ShibnobiCommunity
22 // Facebook: https://www.facebook.com/Shibnobi
23 // Instagram: https://www.instagram.com/shibnobi/
24 // Medium: https://medium.com/@Shibnobi
25 // Reddit: https://www.reddit.com/r/Shibnobi/
26 // Discord: https://discord.gg/shibnobi
27 
28 pragma solidity ^0.8.17;
29 // SPDX-License-Identifier: Unlicensed
30 interface IUniswapRouter01 {
31     function factory() external pure returns (address);
32 
33     function WETH() external pure returns (address);
34 
35     function addLiquidityETH(
36         address token,
37         uint256 amountTokenDesired,
38         uint256 amountTokenMin,
39         uint256 amountETHMin,
40         address to,
41         uint256 deadline
42     )
43         external
44         payable
45         returns (
46             uint256 amountToken,
47             uint256 amountETH,
48             uint256 liquidity
49         );
50 
51     function getAmountsOut(uint256 amountIn, address[] calldata path)
52         external
53         view
54         returns (uint256[] memory amounts);
55 }
56 
57 interface IUniswapRouter02 is IUniswapRouter01 {
58 
59     function swapExactTokensForETHSupportingFeeOnTransferTokens(
60         uint256 amountIn,
61         uint256 amountOutMin,
62         address[] calldata path,
63         address to,
64         uint256 deadline
65     ) external;
66 }
67 
68 interface IFactory {
69     event PairCreated(
70         address indexed token0,
71         address indexed token1,
72         address pair,
73         uint256
74     );
75 
76     function getPair(address tokenA, address tokenB)
77         external
78         view
79         returns (address pair);
80 
81     function allPairs(uint256) external view returns (address pair);
82 
83     function createPair(address tokenA, address tokenB)
84         external
85         returns (address pair);
86 
87 }
88 
89 abstract contract Context {
90     //function _msgSender() internal view virtual returns (address payable) {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes memory) {
96         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
97         return msg.data;
98     }
99 }
100 
101 abstract contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(
105         address indexed previousOwner,
106         address indexed newOwner
107     );
108 
109     /**
110      * @dev Initializes the contract setting the deployer as the initial owner.
111      */
112     constructor() {
113         _transferOwnership(_msgSender());
114     }
115 
116     /**
117      * @dev Returns the address of the current owner.
118      */
119     function owner() public view virtual returns (address) {
120         return _owner;
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         require(owner() == _msgSender(), "Ownable: caller is not the owner");
128         _;
129     }
130 
131     /**
132      * @dev Leaves the contract without owner. It will not be possible to call
133      * `onlyOwner` functions anymore. Can only be called by the current owner.
134      *
135      * NOTE: Renouncing ownership will leave the contract without an owner,
136      * thereby removing any functionality that is only available to the owner.
137      */
138     function renounceOwnership() public virtual onlyOwner {
139         _transferOwnership(address(0));
140     }
141 
142     /**
143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
144      * Can only be called by the current owner.
145      */
146     function transferOwnership(address newOwner) public virtual onlyOwner {
147         require(
148             newOwner != address(0),
149             "Ownable: new owner is the zero address"
150         );
151         _transferOwnership(newOwner);
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Internal function without access restriction.
157      */
158     function _transferOwnership(address newOwner) internal virtual {
159         address oldOwner = _owner;
160         _owner = newOwner;
161         emit OwnershipTransferred(oldOwner, newOwner);
162     }
163 }
164 
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      *
183      * [IMPORTANT]
184      * ====
185      * You shouldn't rely on `isContract` to protect against flash loan attacks!
186      *
187      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
188      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
189      * constructor.
190      * ====
191      */
192     function isContract(address account) internal view returns (bool) {
193         // This method relies on extcodesize/address.code.length, which returns 0
194         // for contracts in construction, since the code is only stored at the end
195         // of the constructor execution.
196 
197         return account.code.length > 0;
198     }
199 
200     /**
201      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
202      * `recipient`, forwarding all available gas and reverting on errors.
203      *
204      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
205      * of certain opcodes, possibly making contracts go over the 2300 gas limit
206      * imposed by `transfer`, making them unable to receive funds via
207      * `transfer`. {sendValue} removes this limitation.
208      *
209      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
210      *
211      * IMPORTANT: because control is transferred to `recipient`, care must be
212      * taken to not create reentrancy vulnerabilities. Consider using
213      * {ReentrancyGuard} or the
214      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
215      */
216     function sendValue(address payable recipient, uint256 amount) internal {
217         require(
218             address(this).balance >= amount,
219             "Address: insufficient balance"
220         );
221 
222         (bool success, ) = recipient.call{value: amount}("");
223         require(
224             success,
225             "Address: unable to send value, recipient may have reverted"
226         );
227     }
228 
229     /**
230      * @dev Performs a Solidity function call using a low level `call`. A
231      * plain `call` is an unsafe replacement for a function call: use this
232      * function instead.
233      *
234      * If `target` reverts with a revert reason, it is bubbled up by this
235      * function (like regular Solidity function calls).
236      *
237      * Returns the raw returned data. To convert to the expected return value,
238      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
239      *
240      * Requirements:
241      *
242      * - `target` must be a contract.
243      * - calling `target` with `data` must not revert.
244      *
245      * _Available since v3.1._
246      */
247     function functionCall(address target, bytes memory data)
248         internal
249         returns (bytes memory)
250     {
251         return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, 0, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but also transferring `value` wei to `target`.
271      *
272      * Requirements:
273      *
274      * - the calling contract must have an ETH balance of at least `value`.
275      * - the called Solidity function must be `payable`.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value
283     ) internal returns (bytes memory) {
284         return
285             functionCallWithValue(
286                 target,
287                 data,
288                 value,
289                 "Address: low-level call with value failed"
290             );
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
295      * with `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(
306             address(this).balance >= value,
307             "Address: insufficient balance for call"
308         );
309         require(isContract(target), "Address: call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.call{value: value}(
312             data
313         );
314         return verifyCallResult(success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(address target, bytes memory data)
324         internal
325         view
326         returns (bytes memory)
327     {
328         return
329             functionStaticCall(
330                 target,
331                 data,
332                 "Address: low-level static call failed"
333             );
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.staticcall(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(address target, bytes memory data)
360         internal
361         returns (bytes memory)
362     {
363         return
364             functionDelegateCall(
365                 target,
366                 data,
367                 "Address: low-level delegate call failed"
368             );
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         require(isContract(target), "Address: delegate call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
390      * revert reason using the provided one.
391      *
392      * _Available since v4.3._
393      */
394     function verifyCallResult(
395         bool success,
396         bytes memory returndata,
397         string memory errorMessage
398     ) internal pure returns (bytes memory) {
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 library SafeERC20 {
418     using Address for address;
419 
420     function safeTransfer(
421         IERC20 token,
422         address to,
423         uint256 value
424     ) internal {
425         _callOptionalReturn(
426             token,
427             abi.encodeWithSelector(token.transfer.selector, to, value)
428         );
429     }
430 
431     function safeTransferFrom(
432         IERC20 token,
433         address from,
434         address to,
435         uint256 value
436     ) internal {
437         _callOptionalReturn(
438             token,
439             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
440         );
441     }
442 
443     /**
444      * @dev Deprecated. This function has issues similar to the ones found in
445      * {IERC20-approve}, and its usage is discouraged.
446      *
447      * Whenever possible, use {safeIncreaseAllowance} and
448      * {safeDecreaseAllowance} instead.
449      */
450     function safeApprove(
451         IERC20 token,
452         address spender,
453         uint256 value
454     ) internal {
455         // safeApprove should only be called when setting an initial allowance,
456         // or when resetting it to zero. To increase and decrease it, use
457         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
458         require(
459             (value == 0) || (token.allowance(address(this), spender) == 0),
460             "SafeERC20: approve from non-zero to non-zero allowance"
461         );
462         _callOptionalReturn(
463             token,
464             abi.encodeWithSelector(token.approve.selector, spender, value)
465         );
466     }
467 
468     function safeIncreaseAllowance(
469         IERC20 token,
470         address spender,
471         uint256 value
472     ) internal {
473         uint256 newAllowance = token.allowance(address(this), spender) + value;
474         _callOptionalReturn(
475             token,
476             abi.encodeWithSelector(
477                 token.approve.selector,
478                 spender,
479                 newAllowance
480             )
481         );
482     }
483 
484     function safeDecreaseAllowance(
485         IERC20 token,
486         address spender,
487         uint256 value
488     ) internal {
489         unchecked {
490             uint256 oldAllowance = token.allowance(address(this), spender);
491             require(
492                 oldAllowance >= value,
493                 "SafeERC20: decreased allowance below zero"
494             );
495             uint256 newAllowance = oldAllowance - value;
496             _callOptionalReturn(
497                 token,
498                 abi.encodeWithSelector(
499                     token.approve.selector,
500                     spender,
501                     newAllowance
502                 )
503             );
504         }
505     }
506 
507     /**
508      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
509      * on the return value: the return value is optional (but if data is returned, it must not be false).
510      * @param token The token targeted by the call.
511      * @param data The call data (encoded using abi.encode or one of its variants).
512      */
513     function _callOptionalReturn(IERC20 token, bytes memory data) private {
514         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
515         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
516         // the target address contains contract code and also asserts for success in the low-level call.
517 
518         bytes memory returndata = address(token).functionCall(
519             data,
520             "SafeERC20: low-level call failed"
521         );
522         if (returndata.length > 0) {
523             // Return data is optional
524             require(
525                 abi.decode(returndata, (bool)),
526                 "SafeERC20: ERC20 operation did not succeed"
527             );
528         }
529     }
530 }
531 
532 interface IERC20 {
533     /**
534      * @dev Emitted when `value` tokens are moved from one account (`from`) to
535      * another (`to`).
536      *
537      * Note that `value` may be zero.
538      */
539     event Transfer(address indexed from, address indexed to, uint256 value);
540 
541     /**
542      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
543      * a call to {approve}. `value` is the new allowance.
544      */
545     event Approval(
546         address indexed owner,
547         address indexed spender,
548         uint256 value
549     );
550 
551     /**
552      * @dev Returns the amount of tokens in existence.
553      */
554     function totalSupply() external view returns (uint256);
555 
556     /**
557      * @dev Returns the amount of tokens owned by `account`.
558      */
559     function balanceOf(address account) external view returns (uint256);
560 
561     /**
562      * @dev Moves `amount` tokens from the caller's account to `to`.
563      *
564      * Returns a boolean value indicating whether the operation succeeded.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transfer(address to, uint256 amount) external returns (bool);
569 
570     /**
571      * @dev Returns the remaining number of tokens that `spender` will be
572      * allowed to spend on behalf of `owner` through {transferFrom}. This is
573      * zero by default.
574      *
575      * This value changes when {approve} or {transferFrom} are called.
576      */
577     function allowance(address owner, address spender)
578         external
579         view
580         returns (uint256);
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
584      *
585      * Returns a boolean value indicating whether the operation succeeded.
586      *
587      * IMPORTANT: Beware that changing an allowance with this method brings the risk
588      * that someone may use both the old and the new allowance by unfortunate
589      * transaction ordering. One possible solution to mitigate this race
590      * condition is to first reduce the spender's allowance to 0 and set the
591      * desired value afterwards:
592      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
593      *
594      * Emits an {Approval} event.
595      */
596     function approve(address spender, uint256 amount) external returns (bool);
597 
598     /**
599      * @dev Moves `amount` tokens from `from` to `to` using the
600      * allowance mechanism. `amount` is then deducted from the caller's
601      * allowance.
602      *
603      * Returns a boolean value indicating whether the operation succeeded.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 amount
611     ) external returns (bool);
612 }
613 
614 interface IERC20Metadata is IERC20 {
615     /**
616      * @dev Returns the name of the token.
617      */
618     function name() external view returns (string memory);
619 
620     /**
621      * @dev Returns the symbol of the token.
622      */
623     function symbol() external view returns (string memory);
624 
625     /**
626      * @dev Returns the decimals places of the token.
627      */
628     function decimals() external view returns (uint8);
629 }
630 
631 contract ERC20 is Context, IERC20, IERC20Metadata {
632     mapping(address => uint256) private _balances;
633 
634     mapping(address => mapping(address => uint256)) private _allowances;
635 
636     uint256 private _totalSupply;
637 
638     string private _name;
639     string private _symbol;
640 
641     /**
642      * @dev Sets the values for {name} and {symbol}.
643      *
644      * The default value of {decimals} is 18. To select a different value for
645      * {decimals} you should overload it.
646      *
647      * All two of these values are immutable: they can only be set once during
648      * construction.
649      */
650     constructor(string memory name_, string memory symbol_) {
651         _name = name_;
652         _symbol = symbol_;
653     }
654 
655     /**
656      * @dev Returns the name of the token.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev Returns the symbol of the token, usually a shorter version of the
664      * name.
665      */
666     function symbol() public view virtual override returns (string memory) {
667         return _symbol;
668     }
669 
670     /**
671      * @dev Returns the number of decimals used to get its user representation.
672      * For example, if `decimals` equals `2`, a balance of `505` tokens should
673      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
674      *
675      * Tokens usually opt for a value of 18, imitating the relationship between
676      * Ether and Wei. This is the value {ERC20} uses, unless this function is
677      * overridden;
678      *
679      * NOTE: This information is only used for _display_ purposes: it in
680      * no way affects any of the arithmetic of the contract, including
681      * {IERC20-balanceOf} and {IERC20-transfer}.
682      */
683     function decimals() public view virtual override returns (uint8) {
684         return 18;
685     }
686 
687     /**
688      * @dev See {IERC20-totalSupply}.
689      */
690     function totalSupply() public view virtual override returns (uint256) {
691         return _totalSupply;
692     }
693 
694     /**
695      * @dev See {IERC20-balanceOf}.
696      */
697     function balanceOf(address account)
698         public
699         view
700         virtual
701         override
702         returns (uint256)
703     {
704         return _balances[account];
705     }
706 
707     /**
708      * @dev See {IERC20-transfer}.
709      *
710      * Requirements:
711      *
712      * - `to` cannot be the zero address.
713      * - the caller must have a balance of at least `amount`.
714      */
715     function transfer(address to, uint256 amount)
716         public
717         virtual
718         override
719         returns (bool)
720     {
721         _transfer(msg.sender, to, amount);
722         return true;
723     }
724 
725     /**
726      * @dev See {IERC20-allowance}.
727      */
728     function allowance(address owner, address spender)
729         public
730         view
731         virtual
732         override
733         returns (uint256)
734     {
735         return _allowances[owner][spender];
736     }
737 
738     /**
739      * @dev See {IERC20-approve}.
740      *
741      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
742      * `transferFrom`. This is semantically equivalent to an infinite approval.
743      *
744      * Requirements:
745      *
746      * - `spender` cannot be the zero address.
747      */
748     function approve(address spender, uint256 amount)
749         public
750         virtual
751         override
752         returns (bool)
753     {
754         _approve(msg.sender, spender, amount);
755         return true;
756     }
757 
758     /**
759      * @dev See {IERC20-transferFrom}.
760      *
761      * Emits an {Approval} event indicating the updated allowance. This is not
762      * required by the EIP. See the note at the beginning of {ERC20}.
763      *
764      * NOTE: Does not update the allowance if the current allowance
765      * is the maximum `uint256`.
766      *
767      * Requirements:
768      *
769      * - `from` and `to` cannot be the zero address.
770      * - `from` must have a balance of at least `amount`.
771      * - the caller must have allowance for ``from``'s tokens of at least
772      * `amount`.
773      */
774     function transferFrom(
775         address from,
776         address to,
777         uint256 amount
778     ) public virtual override returns (bool) {
779         address spender = _msgSender();
780         _spendAllowance(from, spender, amount);
781         _transfer(from, to, amount);
782         return true;
783     }
784 
785     /**
786      * @dev Atomically increases the allowance granted to `spender` by the caller.
787      *
788      * This is an alternative to {approve} that can be used as a mitigation for
789      * problems described in {IERC20-approve}.
790      *
791      * Emits an {Approval} event indicating the updated allowance.
792      *
793      * Requirements:
794      *
795      * - `spender` cannot be the zero address.
796      */
797     function increaseAllowance(address spender, uint256 addedValue)
798         public
799         virtual
800         returns (bool)
801     {
802         _approve(
803             msg.sender,
804             spender,
805             allowance(msg.sender, spender) + addedValue
806         );
807         return true;
808     }
809 
810     /**
811      * @dev Atomically decreases the allowance granted to `spender` by the caller.
812      *
813      * This is an alternative to {approve} that can be used as a mitigation for
814      * problems described in {IERC20-approve}.
815      *
816      * Emits an {Approval} event indicating the updated allowance.
817      *
818      * Requirements:
819      *
820      * - `spender` cannot be the zero address.
821      * - `spender` must have allowance for the caller of at least
822      * `subtractedValue`.
823      */
824     function decreaseAllowance(address spender, uint256 subtractedValue)
825         public
826         virtual
827         returns (bool)
828     {
829         uint256 currentAllowance = allowance(msg.sender, spender);
830         require(
831             currentAllowance >= subtractedValue,
832             "ERC20: decreased allowance below zero"
833         );
834         unchecked {
835             _approve(msg.sender, spender, currentAllowance - subtractedValue);
836         }
837 
838         return true;
839     }
840 
841     /**
842      * @dev Moves `amount` of tokens from `sender` to `recipient`.
843      *
844      * This internal function is equivalent to {transfer}, and can be used to
845      * e.g. implement automatic token fees, slashing mechanisms, etc.
846      *
847      * Emits a {Transfer} event.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `from` must have a balance of at least `amount`.
854      */
855     function _transfer(
856         address from,
857         address to,
858         uint256 amount
859     ) internal virtual {
860         require(from != address(0), "ERC20: transfer from the zero address");
861         require(to != address(0), "ERC20: transfer to the zero address");
862 
863         _beforeTokenTransfer(from, to, amount);
864 
865         uint256 fromBalance = _balances[from];
866         require(
867             fromBalance >= amount,
868             "ERC20: transfer amount exceeds balance"
869         );
870         unchecked {
871             _balances[from] = fromBalance - amount;
872         }
873         _balances[to] += amount;
874 
875         emit Transfer(from, to, amount);
876 
877         _afterTokenTransfer(from, to, amount);
878     }
879 
880     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
881      * the total supply.
882      *
883      * Emits a {Transfer} event with `from` set to the zero address.
884      *
885      * Requirements:
886      *
887      * - `account` cannot be the zero address.
888      */
889     function _mint(address account, uint256 amount) internal virtual {
890         require(account != address(0), "ERC20: mint to the zero address");
891 
892         _beforeTokenTransfer(address(0), account, amount);
893 
894         _totalSupply += amount;
895         _balances[account] += amount;
896         emit Transfer(address(0), account, amount);
897 
898         _afterTokenTransfer(address(0), account, amount);
899     }
900 
901     /**
902      * @dev Destroys `amount` tokens from `account`, reducing the
903      * total supply.
904      *
905      * Emits a {Transfer} event with `to` set to the zero address.
906      *
907      * Requirements:
908      *
909      * - `account` cannot be the zero address.
910      * - `account` must have at least `amount` tokens.
911      */
912     function _burn(address account, uint256 amount) internal virtual {
913         require(account != address(0), "ERC20: burn from the zero address");
914 
915         _beforeTokenTransfer(account, address(0), amount);
916 
917         uint256 accountBalance = _balances[account];
918         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
919         unchecked {
920             _balances[account] = accountBalance - amount;
921         }
922         _totalSupply -= amount;
923 
924         emit Transfer(account, address(0), amount);
925 
926         _afterTokenTransfer(account, address(0), amount);
927     }
928 
929     /**
930      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
931      *
932      * This internal function is equivalent to `approve`, and can be used to
933      * e.g. set automatic allowances for certain subsystems, etc.
934      *
935      * Emits an {Approval} event.
936      *
937      * Requirements:
938      *
939      * - `owner` cannot be the zero address.
940      * - `spender` cannot be the zero address.
941      */
942     function _approve(
943         address owner,
944         address spender,
945         uint256 amount
946     ) internal virtual {
947         require(owner != address(0), "ERC20: approve from the zero address");
948         require(spender != address(0), "ERC20: approve to the zero address");
949 
950         _allowances[owner][spender] = amount;
951         emit Approval(owner, spender, amount);
952     }
953 
954     /**
955      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
956      *
957      * Does not update the allowance amount in case of infinite allowance.
958      * Revert if not enough allowance is available.
959      *
960      * Might emit an {Approval} event.
961      */
962     function _spendAllowance(
963         address owner,
964         address spender,
965         uint256 amount
966     ) internal virtual {
967         uint256 currentAllowance = allowance(owner, spender);
968         if (currentAllowance != type(uint256).max) {
969             require(
970                 currentAllowance >= amount,
971                 "ERC20: insufficient allowance"
972             );
973             unchecked {
974                 _approve(owner, spender, currentAllowance - amount);
975             }
976         }
977     }
978 
979     /**
980      * @dev Hook that is called before any transfer of tokens. This includes
981      * minting and burning.
982      *
983      * Calling conditions:
984      *
985      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
986      * will be transferred to `to`.
987      * - when `from` is zero, `amount` tokens will be minted for `to`.
988      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
989      * - `from` and `to` are never both zero.
990      *
991      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
992      */
993     function _beforeTokenTransfer(
994         address from,
995         address to,
996         uint256 amount
997     ) internal virtual {}
998 
999     /**
1000      * @dev Hook that is called after any transfer of tokens. This includes
1001      * minting and burning.
1002      *
1003      * Calling conditions:
1004      *
1005      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1006      * has been transferred to `to`.
1007      * - when `from` is zero, `amount` tokens have been minted for `to`.
1008      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1009      * - `from` and `to` are never both zero.
1010      *
1011      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1012      */
1013     function _afterTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 amount
1017     ) internal virtual {}
1018 }
1019 
1020 interface IUniswapV2Pair {
1021     function getReserves()
1022         external
1023         view
1024         returns (
1025             uint112 reserve0,
1026             uint112 reserve1,
1027             uint32 blockTimestampLast
1028         );
1029 }
1030 
1031 contract Shibnobiv2 is ERC20, Ownable {
1032     address payable public marketingFeeAddress;
1033     address payable public stakingFeeAddress;
1034 
1035     uint16 constant feeDenominator = 1000;
1036     uint16 constant lpDenominator = 1000;
1037     uint16 constant maxFeeLimit = 300;
1038 
1039     bool public tradingActive;
1040 
1041     mapping(address => bool) public isExcludedFromFee;
1042 
1043     uint16 public buyBurnFee = 10;
1044     uint16 public buyLiquidityFee = 10;
1045     uint16 public buyMarketingFee = 35;
1046     uint16 public buyStakingFee = 20;
1047 
1048     uint16 public sellBurnFee = 10;
1049     uint16 public sellLiquidityFee = 20;
1050     uint16 public sellMarketingFee = 40;
1051     uint16 public sellStakingFee = 30;
1052 
1053     uint16 public transferBurnFee = 10;
1054     uint16 public transferLiquidityFee = 5;
1055     uint16 public transferMarketingFee = 5;
1056     uint16 public transferStakingFee = 20;
1057 
1058     uint256 private _liquidityTokensToSwap;
1059     uint256 private _marketingFeeTokensToSwap;
1060     uint256 private _burnFeeTokens;
1061     uint256 private _stakingFeeTokens;
1062 
1063     uint256 private lpTokens;
1064 
1065     mapping(address => bool) public automatedMarketMakerPairs;
1066     mapping(address => bool) public botWallet;
1067     address[] public botWallets;
1068     uint256 public minLpBeforeSwapping;
1069 
1070     IUniswapRouter02 public immutable uniswapRouter;
1071     address public immutable uniswapPair;
1072     address public bridgeAddress;
1073 
1074     bool inSwapAndLiquify;
1075 
1076     modifier lockTheSwap() {
1077         inSwapAndLiquify = true;
1078         _;
1079         inSwapAndLiquify = false;
1080     }
1081 
1082     constructor() ERC20("Shibnobi", "SHINJA") {
1083         _mint(msg.sender, 1e11 * 10**decimals());
1084 
1085         marketingFeeAddress = payable(
1086             0xb8F9d14060e7e73eed1e98c23a732BE11345a2dB
1087         );
1088         stakingFeeAddress = payable(0x142080A32EE52cFE573Abf0C42798D63A20da8cD);
1089 
1090         minLpBeforeSwapping = 10; // this means: 10 / 1000 = 1% of the liquidity pool is the threshold before swapping
1091 
1092         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Mainnet
1093         // address routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Mainnet
1094         uniswapRouter = IUniswapRouter02(payable(routerAddress));
1095 
1096         uniswapPair = IFactory(uniswapRouter.factory()).createPair(
1097             address(this),
1098             uniswapRouter.WETH()
1099         );
1100 
1101         isExcludedFromFee[msg.sender] = true;
1102         isExcludedFromFee[address(this)] = true;
1103         isExcludedFromFee[marketingFeeAddress] = true;
1104         isExcludedFromFee[stakingFeeAddress] = true;
1105 
1106         _limits[msg.sender].isExcluded = true;
1107         _limits[address(this)].isExcluded = true;
1108         _limits[routerAddress].isExcluded = true;
1109 
1110         // Limits Configuration
1111         globalLimit = 25 ether;
1112         globalLimitPeriod = 24 hours;
1113         limitsActive = true;
1114 
1115         _approve(msg.sender, routerAddress, ~uint256(0));
1116         _setAutomatedMarketMakerPair(uniswapPair, true);
1117         bridgeAddress = 0x4c03Cf0301F2ef59CC2687b82f982A2A01C00Ee2;
1118         isExcludedFromFee[bridgeAddress] = true;
1119         _limits[bridgeAddress].isExcluded = true;
1120         _approve(address(this), address(uniswapRouter), type(uint256).max);
1121     }
1122 
1123     function increaseRouterAllowance(address routerAddress) external onlyOwner {
1124         _approve(address(this), routerAddress, type(uint256).max);
1125     }
1126 
1127     function migrateBridge(address newAddress) external onlyOwner {
1128         require(
1129             newAddress != address(0) && !automatedMarketMakerPairs[newAddress],
1130             "Can't set this address"
1131         );
1132         bridgeAddress = newAddress;
1133         isExcludedFromFee[newAddress] = true;
1134         _limits[newAddress].isExcluded = true;
1135     }
1136 
1137     function decimals() public pure override returns (uint8) {
1138         return 9;
1139     }
1140 
1141     function addBotWallet(address wallet) external onlyOwner {
1142         require(!botWallet[wallet], "Wallet already added");
1143         botWallet[wallet] = true;
1144         botWallets.push(wallet);
1145     }
1146 
1147     function addBotWalletBulk(address[] memory wallets) external onlyOwner {
1148         for (uint256 i = 0; i < wallets.length; i++) {
1149             require(!botWallet[wallets[i]], "Wallet already added");
1150             botWallet[wallets[i]] = true;
1151             botWallets.push(wallets[i]);
1152         }
1153     }
1154 
1155     function getBotWallets() external view returns (address[] memory) {
1156         return botWallets;
1157     }
1158 
1159     function removeBotWallet(address wallet) external onlyOwner {
1160         require(botWallet[wallet], "Wallet not added");
1161         botWallet[wallet] = false;
1162         for (uint256 i = 0; i < botWallets.length; i++) {
1163             if (botWallets[i] == wallet) {
1164                 botWallets[i] = botWallets[botWallets.length - 1];
1165                 botWallets.pop();
1166                 break;
1167             }
1168         }
1169     }
1170 
1171     function burn(uint256 amount) external {
1172         _burn(msg.sender, amount);
1173     }
1174 
1175     function enableTrading() external onlyOwner {
1176         tradingActive = true;
1177     }
1178 
1179     function disableTrading() external onlyOwner {
1180         tradingActive = false;
1181     }
1182 
1183     function totalSupply() public view override returns (uint256) {
1184         return super.totalSupply() - bridgeBalance();
1185     }
1186 
1187     function balanceOf(address account) public view override returns (uint256) {
1188         if (account == bridgeAddress) return 0;
1189         return super.balanceOf(account);
1190     }
1191 
1192     function bridgeBalance() public view returns (uint256) {
1193         return super.balanceOf(bridgeAddress);
1194     }
1195 
1196     function updateMinLpBeforeSwapping(uint256 minLpBeforeSwapping_)
1197         external
1198         onlyOwner
1199     {
1200         minLpBeforeSwapping = minLpBeforeSwapping_;
1201     }
1202 
1203     function setAutomatedMarketMakerPair(address pair, bool value)
1204         external
1205         onlyOwner
1206     {
1207         require(pair != uniswapPair, "The pair cannot be removed");
1208 
1209         _setAutomatedMarketMakerPair(pair, value);
1210     }
1211 
1212     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1213         automatedMarketMakerPairs[pair] = value;
1214     }
1215 
1216     function excludeFromFee(address account) external onlyOwner {
1217         isExcludedFromFee[account] = true;
1218     }
1219 
1220     function includeInFee(address account) external onlyOwner {
1221         isExcludedFromFee[account] = false;
1222     }
1223 
1224     function updateBuyFee(
1225         uint16 _buyBurnFee,
1226         uint16 _buyLiquidityFee,
1227         uint16 _buyMarketingFee,
1228         uint16 _buyStakingFee
1229     ) external onlyOwner {
1230         buyBurnFee = _buyBurnFee;
1231         buyLiquidityFee = _buyLiquidityFee;
1232         buyMarketingFee = _buyMarketingFee;
1233         buyStakingFee = _buyStakingFee;
1234         require(
1235             _buyBurnFee +
1236                 _buyLiquidityFee +
1237                 _buyMarketingFee +
1238                 _buyStakingFee <=
1239                 maxFeeLimit,
1240             "Must keep fees below 30%"
1241         );
1242     }
1243 
1244     function updateSellFee(
1245         uint16 _sellBurnFee,
1246         uint16 _sellLiquidityFee,
1247         uint16 _sellMarketingFee,
1248         uint16 _sellStakingFee
1249     ) external onlyOwner {
1250         sellBurnFee = _sellBurnFee;
1251         sellLiquidityFee = _sellLiquidityFee;
1252         sellMarketingFee = _sellMarketingFee;
1253         sellStakingFee = _sellStakingFee;
1254         require(
1255             _sellBurnFee +
1256                 _sellLiquidityFee +
1257                 _sellMarketingFee +
1258                 _sellStakingFee <=
1259                 maxFeeLimit,
1260             "Must keep fees <= 30%"
1261         );
1262     }
1263 
1264     function updateTransferFee(
1265         uint16 _transferBurnFee,
1266         uint16 _transferLiquidityFee,
1267         uint16 _transferMarketingFee,
1268         uint16 _transferStakingfee
1269     ) external onlyOwner {
1270         transferBurnFee = _transferBurnFee;
1271         transferLiquidityFee = _transferLiquidityFee;
1272         transferMarketingFee = _transferMarketingFee;
1273         transferStakingFee = _transferStakingfee;
1274         require(
1275             _transferBurnFee +
1276                 _transferLiquidityFee +
1277                 _transferMarketingFee +
1278                 _transferStakingfee <=
1279                 maxFeeLimit,
1280             "Must keep fees <= 30%"
1281         );
1282     }
1283 
1284     function updateMarketingFeeAddress(address marketingFeeAddress_)
1285         external
1286         onlyOwner
1287     {
1288         require(marketingFeeAddress_ != address(0), "Can't set 0");
1289         marketingFeeAddress = payable(marketingFeeAddress_);
1290     }
1291 
1292     function updateStakingAddress(address stakingFeeAddress_)
1293         external
1294         onlyOwner
1295     {
1296         require(stakingFeeAddress_ != address(0), "Can't set 0");
1297         stakingFeeAddress = payable(stakingFeeAddress_);
1298     }
1299 
1300     function _transfer(
1301         address from,
1302         address to,
1303         uint256 amount
1304     ) internal override {
1305         if (!tradingActive) {
1306             require(
1307                 isExcludedFromFee[from] || isExcludedFromFee[to],
1308                 "Trading is not active yet."
1309             );
1310         }
1311         require(!botWallet[from] && !botWallet[to], "Bot wallet");
1312         checkLiquidity();
1313 
1314         if (
1315             hasLiquidity && !inSwapAndLiquify && automatedMarketMakerPairs[to]
1316         ) {
1317             uint256 contractTokenBalance = balanceOf(address(this));
1318             if (
1319                 contractTokenBalance >=
1320                 (lpTokens * minLpBeforeSwapping) / lpDenominator
1321             ) takeFee(contractTokenBalance);
1322         }
1323 
1324         uint256 _burnFee;
1325         uint256 _liquidityFee;
1326         uint256 _marketingFee;
1327         uint256 _stakingFee;
1328 
1329         if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) {
1330             // Buy
1331             if (automatedMarketMakerPairs[from]) {
1332                 _burnFee = (amount * buyBurnFee) / feeDenominator;
1333                 _liquidityFee = (amount * buyLiquidityFee) / feeDenominator;
1334                 _marketingFee = (amount * buyMarketingFee) / feeDenominator;
1335                 _stakingFee = (amount * buyStakingFee) / feeDenominator;
1336             }
1337             // Sell
1338             else if (automatedMarketMakerPairs[to]) {
1339                 _burnFee = (amount * sellBurnFee) / feeDenominator;
1340                 _liquidityFee = (amount * sellLiquidityFee) / feeDenominator;
1341                 _marketingFee = (amount * sellMarketingFee) / feeDenominator;
1342                 _stakingFee = (amount * sellStakingFee) / feeDenominator;
1343             } else {
1344                 _burnFee = (amount * transferBurnFee) / feeDenominator;
1345                 _liquidityFee =
1346                     (amount * transferLiquidityFee) /
1347                     feeDenominator;
1348                 _marketingFee =
1349                     (amount * transferMarketingFee) /
1350                     feeDenominator;
1351                 _stakingFee = (amount * transferStakingFee) / feeDenominator;
1352             }
1353 
1354             _handleLimited(
1355                 from,
1356                 to,
1357                 amount - _burnFee - _liquidityFee - _marketingFee - _stakingFee
1358             );
1359         }
1360 
1361         uint256 _transferAmount = amount -
1362             _burnFee -
1363             _liquidityFee -
1364             _marketingFee -
1365             _stakingFee;
1366         super._transfer(from, to, _transferAmount);
1367         uint256 _feeTotal = _burnFee +
1368             _liquidityFee +
1369             _marketingFee +
1370             _stakingFee;
1371         if (_feeTotal > 0) {
1372             super._transfer(from, address(this), _feeTotal);
1373             _liquidityTokensToSwap += _liquidityFee;
1374             _marketingFeeTokensToSwap += _marketingFee;
1375             _burnFeeTokens += _burnFee;
1376             _stakingFeeTokens += _stakingFee;
1377         }
1378     }
1379 
1380     function takeFee(uint256 contractBalance) private lockTheSwap {
1381         uint256 totalTokensTaken = _liquidityTokensToSwap +
1382             _marketingFeeTokensToSwap +
1383             _burnFeeTokens +
1384             _stakingFeeTokens;
1385         if (totalTokensTaken == 0 || contractBalance < totalTokensTaken) {
1386             return;
1387         }
1388 
1389         uint256 tokensForLiquidity = _liquidityTokensToSwap / 2;
1390         uint256 initialETHBalance = address(this).balance;
1391         uint256 toSwap = tokensForLiquidity +
1392             _marketingFeeTokensToSwap +
1393             _stakingFeeTokens;
1394         swapTokensForETH(toSwap);
1395         uint256 ethBalance = address(this).balance - initialETHBalance;
1396 
1397         uint256 ethForMarketing = (ethBalance * _marketingFeeTokensToSwap) /
1398             toSwap;
1399         uint256 ethForLiquidity = (ethBalance * tokensForLiquidity) / toSwap;
1400         uint256 ethForStaking = (ethBalance * _stakingFeeTokens) / toSwap;
1401 
1402         if (tokensForLiquidity > 0 && ethForLiquidity > 0) {
1403             addLiquidity(tokensForLiquidity, ethForLiquidity);
1404         }
1405         bool success;
1406 
1407         (success, ) = address(marketingFeeAddress).call{
1408             value: ethForMarketing,
1409             gas: 50000
1410         }("");
1411         (success, ) = address(stakingFeeAddress).call{
1412             value: ethForStaking,
1413             gas: 50000
1414         }("");
1415 
1416         if (_burnFeeTokens > 0) {
1417             _burn(address(this), _burnFeeTokens);
1418         }
1419 
1420         _liquidityTokensToSwap = 0;
1421         _marketingFeeTokensToSwap = 0;
1422         _burnFeeTokens = 0;
1423         _stakingFeeTokens = 0;
1424     }
1425 
1426     function swapTokensForETH(uint256 tokenAmount) private {
1427         address[] memory path = new address[](2);
1428         path[0] = address(this);
1429         path[1] = uniswapRouter.WETH();
1430         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1431             tokenAmount,
1432             0,
1433             path,
1434             address(this),
1435             block.timestamp
1436         );
1437     }
1438 
1439     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1440         uniswapRouter.addLiquidityETH{value: ethAmount}(
1441             address(this),
1442             tokenAmount,
1443             0, // slippage is unavoidable
1444             0, // slippage is unavoidable
1445             owner(),
1446             block.timestamp
1447         );
1448     }
1449 
1450     receive() external payable {}
1451 
1452     // Limits
1453     event LimitSet(address indexed user, uint256 limitETH, uint256 period);
1454 
1455     mapping(address => LimitedWallet) private _limits;
1456 
1457     uint256 public globalLimit; // limit over timeframe for all
1458     uint256 public globalLimitPeriod; // timeframe for all
1459 
1460     bool public limitsActive;
1461 
1462     bool private hasLiquidity;
1463 
1464     struct LimitedWallet {
1465         uint256[] sellAmounts;
1466         uint256[] sellTimestamps;
1467         uint256 limitPeriod; // ability to set custom values for individual wallets
1468         uint256 limitETH; // ability to set custom values for individual wallets
1469         bool isExcluded;
1470     }
1471 
1472     function setGlobalLimit(uint256 newLimit) external onlyOwner {
1473         require(newLimit >= 1 ether, "Too low");
1474         globalLimit = newLimit;
1475     }
1476 
1477     function setGlobalLimitPeriod(uint256 newPeriod) external onlyOwner {
1478         require(newPeriod <= 2 weeks, "Too long");
1479         globalLimitPeriod = newPeriod;
1480     }
1481 
1482     function setLimitsActiveStatus(bool status) external onlyOwner {
1483         limitsActive = status;
1484     }
1485 
1486     function getLimits(address _address)
1487         external
1488         view
1489         returns (LimitedWallet memory)
1490     {
1491         return _limits[_address];
1492     }
1493 
1494     function removeLimits(address[] calldata addresses) external onlyOwner {
1495         for (uint256 i; i < addresses.length; i++) {
1496             address account = addresses[i];
1497             _limits[account].limitPeriod = 0;
1498             _limits[account].limitETH = 0;
1499             emit LimitSet(account, 0, 0);
1500         }
1501     }
1502 
1503     // Set custom limits for an address. Defaults to 0, thus will use the "globalLimitPeriod" and "globalLimitETH" if we don't set them
1504     function setLimits(
1505         address[] calldata addresses,
1506         uint256[] calldata limitPeriods,
1507         uint256[] calldata limitsETH
1508     ) external onlyOwner {
1509         require(
1510             addresses.length == limitPeriods.length &&
1511                 limitPeriods.length == limitsETH.length,
1512             "Array lengths don't match"
1513         );
1514 
1515         for (uint256 i = 0; i < addresses.length; i++) {
1516             if (limitPeriods[i] == 0 && limitsETH[i] == 0) continue;
1517             _limits[addresses[i]].limitPeriod = limitPeriods[i];
1518             _limits[addresses[i]].limitETH = limitsETH[i];
1519             emit LimitSet(addresses[i], limitsETH[i], limitPeriods[i]);
1520         }
1521     }
1522 
1523     function addExcludedFromLimits(address[] calldata addresses)
1524         external
1525         onlyOwner
1526     {
1527         for (uint256 i = 0; i < addresses.length; i++) {
1528             _limits[addresses[i]].isExcluded = true;
1529         }
1530     }
1531 
1532     function removeExcludedFromLimits(address[] calldata addresses)
1533         external
1534         onlyOwner
1535     {
1536         require(addresses.length <= 500, "Array too long");
1537         for (uint256 i = 0; i < addresses.length; i++) {
1538             _limits[addresses[i]].isExcluded = false;
1539         }
1540     }
1541 
1542     // Can be used to check how much a wallet sold in their timeframe
1543     function getSoldLastPeriod(address _address)
1544         public
1545         view
1546         returns (uint256 sellAmount)
1547     {
1548         LimitedWallet memory __limits = _limits[_address];
1549         uint256 numberOfSells = __limits.sellAmounts.length;
1550 
1551         if (numberOfSells == 0) {
1552             return sellAmount;
1553         }
1554 
1555         uint256 limitPeriod = __limits.limitPeriod == 0
1556             ? globalLimitPeriod
1557             : __limits.limitPeriod;
1558         while (true) {
1559             if (numberOfSells == 0) {
1560                 break;
1561             }
1562             numberOfSells--;
1563             uint256 sellTimestamp = __limits.sellTimestamps[numberOfSells];
1564             if (block.timestamp - limitPeriod <= sellTimestamp) {
1565                 sellAmount += __limits.sellAmounts[numberOfSells];
1566             } else {
1567                 break;
1568             }
1569         }
1570     }
1571 
1572     function checkLiquidity() internal {
1573         (uint256 r1, uint256 r2, ) = IUniswapV2Pair(uniswapPair).getReserves();
1574 
1575         lpTokens = balanceOf(uniswapPair); // this is not a problem, since contract sell will get that unsynced balance as if we sold it, so we just get more ETH.
1576         hasLiquidity = r1 > 0 && r2 > 0 ? true : false;
1577     }
1578 
1579     function getETHValue(uint256 tokenAmount)
1580         public
1581         view
1582         returns (uint256 ethValue)
1583     {
1584         address[] memory path = new address[](2);
1585         path[0] = address(this);
1586         path[1] = uniswapRouter.WETH();
1587         ethValue = uniswapRouter.getAmountsOut(tokenAmount, path)[1];
1588     }
1589 
1590     // Handle private sale wallets
1591     function _handleLimited(
1592         address from,
1593         address to,
1594         uint256 taxedAmount
1595     ) private {
1596         LimitedWallet memory _from = _limits[from];
1597         if (
1598             _from.isExcluded ||
1599             _limits[to].isExcluded ||
1600             !hasLiquidity ||
1601             automatedMarketMakerPairs[from] ||
1602             inSwapAndLiquify ||
1603             (!limitsActive && _from.limitETH == 0) // if limits are disabled and the wallet doesn't have a custom limit, we don't need to check
1604         ) {
1605             return;
1606         }
1607         uint256 ethValue = getETHValue(taxedAmount);
1608         _limits[from].sellTimestamps.push(block.timestamp);
1609         _limits[from].sellAmounts.push(ethValue);
1610         uint256 soldAmountLastPeriod = getSoldLastPeriod(from);
1611 
1612         uint256 limit = _from.limitETH == 0 ? globalLimit : _from.limitETH;
1613         require(
1614             soldAmountLastPeriod <= limit,
1615             "Amount over the limit for time period"
1616         );
1617     }
1618 
1619     function withdrawETH() external onlyOwner {
1620         payable(owner()).transfer(address(this).balance);
1621     }
1622 
1623     function withdrawTokens(IERC20 tokenAddress, address walletAddress)
1624         external
1625         onlyOwner
1626     {
1627         require(
1628             walletAddress != address(0),
1629             "walletAddress can't be 0 address"
1630         );
1631         SafeERC20.safeTransfer(
1632             tokenAddress,
1633             walletAddress,
1634             tokenAddress.balanceOf(address(this))
1635         );
1636     }
1637 }