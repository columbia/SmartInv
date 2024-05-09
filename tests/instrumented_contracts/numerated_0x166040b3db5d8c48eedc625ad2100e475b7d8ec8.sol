1 pragma solidity ^0.6.0;
2 
3 
4 /*
5 /
6 /                     ,dS$Sb,       ;$$$
7 /                   ,$$P^`^²$$,     ;$$$
8 /    $$$$$$$$$$$$$',$$;,$$$,;$$,`$$ I$$I $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
9 /  $$$$$$P"²²╩?S$';$$;,$$$$$,;$$;P';$$$',$$$$$$$$$$$$$$$$P²"`.`,`$$$P²"`.`,`$$
10 / $$$$$$';$SS#%y,;$$;_╩?$$$$$,;$$ ;$$$',$P²╩P"``"$$²"""",d$',yyyy$',d$' yyyy$$$
11 / $$$$$;;$$SP╩²²;$$;,$#y▬,"²?$ $$;$$$' ,ySSy,$$$ $$ $$$;$$$;,`²?$$,$$$;,`²?$$$$$
12 / $$SP╩ ╩"` "? ;$$; b,`^╩S$b,`+;$$$$I,$$"`"$$$$;;$$;;$$$`╩S$$$Sy,"?`╩S$$$Sy,`?$$$
13 / ,y%#S$$$²"` ;$$;         "?$, ;$$$;  `   ;$$$      $$$ ,y+`"²$$$; ,y+`"²$$$;$$$
14 / $$$$SS'    ;$$;  i_L       `?$,$$$$;     $$$$;    ;$$$$$;    ;$$$$$;    ;$$$;$$
15 / ;$$S$;.,▬y$$$;               `$$$$$$,__,$$$?$$,__,$S$$$$;    ;$$$$$;    ;$$$;$$
16 /  `²?S$$$SP²'∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙ `I$I`²S$$S²'  `²S$$S²IS$$$$,__,$$$;$$$,__,$$$;$$
17 / :       -x- ABY/ah -x-         $$;   :           ;$$I`²S$$S²''  `²S$$S²''
18 / :                              :$$   :            $$$
19 / :  / solidity. : m4ss, VAC     -:$   :            I$$;
20 / :  / design    : VAC, m4ss       ;   :            ;$$I
21 / :  / I0        : 1unacy              :
22 / :  / stack     : m4ss                :
23 / :  / counsel   : 7dlm                :
24 / :  / math      : 1unacy, 7dlm.       :
25 / :  / stratagem : 1unacy, VAC.        :
26 / :....................................:
27 */
28 
29 
30 // 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 // 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 // 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // 
402 /**
403  * @title SafeERC20
404  * @dev Wrappers around ERC20 operations that throw on failure (when the token
405  * contract returns false). Tokens that return no value (and instead revert or
406  * throw on failure) are also supported, non-reverting calls are assumed to be
407  * successful.
408  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
409  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
410  */
411 library SafeERC20 {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     function safeTransfer(IERC20 token, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
417     }
418 
419     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
421     }
422 
423     /**
424      * @dev Deprecated. This function has issues similar to the ones found in
425      * {IERC20-approve}, and its usage is discouraged.
426      *
427      * Whenever possible, use {safeIncreaseAllowance} and
428      * {safeDecreaseAllowance} instead.
429      */
430     function safeApprove(IERC20 token, address spender, uint256 value) internal {
431         // safeApprove should only be called when setting an initial allowance,
432         // or when resetting it to zero. To increase and decrease it, use
433         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
434         // solhint-disable-next-line max-line-length
435         require((value == 0) || (token.allowance(address(this), spender) == 0),
436             "SafeERC20: approve from non-zero to non-zero allowance"
437         );
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
439     }
440 
441     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
442         uint256 newAllowance = token.allowance(address(this), spender).add(value);
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
444     }
445 
446     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
447         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449     }
450 
451     /**
452      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
453      * on the return value: the return value is optional (but if data is returned, it must not be false).
454      * @param token The token targeted by the call.
455      * @param data The call data (encoded using abi.encode or one of its variants).
456      */
457     function _callOptionalReturn(IERC20 token, bytes memory data) private {
458         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
459         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
460         // the target address contains contract code and also asserts for success in the low-level call.
461 
462         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
463         if (returndata.length > 0) { // Return data is optional
464             // solhint-disable-next-line max-line-length
465             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
466         }
467     }
468 }
469 
470 // 
471 /*
472  * @dev Provides information about the current execution context, including the
473  * sender of the transaction and its data. While these are generally available
474  * via msg.sender and msg.data, they should not be accessed in such a direct
475  * manner, since when dealing with GSN meta-transactions the account sending and
476  * paying for execution may not be the actual sender (as far as an application
477  * is concerned).
478  *
479  * This contract is only required for intermediate, library-like contracts.
480  */
481 abstract contract Context {
482     function _msgSender() internal view virtual returns (address payable) {
483         return msg.sender;
484     }
485 
486     function _msgData() internal view virtual returns (bytes memory) {
487         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
488         return msg.data;
489     }
490 }
491 
492 // 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * By default, the owner account will be the one that deploys the contract. This
499  * can later be changed with {transferOwnership}.
500  *
501  * This module is used through inheritance. It will make available the modifier
502  * `onlyOwner`, which can be applied to your functions to restrict their use to
503  * the owner.
504  */
505 contract Ownable is Context {
506     address private _owner;
507 
508     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
509 
510     /**
511      * @dev Initializes the contract setting the deployer as the initial owner.
512      */
513     constructor () internal {
514         address msgSender = _msgSender();
515         _owner = msgSender;
516         emit OwnershipTransferred(address(0), msgSender);
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(_owner == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         emit OwnershipTransferred(_owner, address(0));
543         _owner = address(0);
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         emit OwnershipTransferred(_owner, newOwner);
553         _owner = newOwner;
554     }
555 }
556 
557 interface IUniswapV2Router01 {
558     function factory() external pure returns (address);
559     function WETH() external pure returns (address);
560 
561     function addLiquidity(
562         address tokenA,
563         address tokenB,
564         uint amountADesired,
565         uint amountBDesired,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline
570     ) external returns (uint amountA, uint amountB, uint liquidity);
571     function addLiquidityETH(
572         address token,
573         uint amountTokenDesired,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline
578     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
579     function removeLiquidity(
580         address tokenA,
581         address tokenB,
582         uint liquidity,
583         uint amountAMin,
584         uint amountBMin,
585         address to,
586         uint deadline
587     ) external returns (uint amountA, uint amountB);
588     function removeLiquidityETH(
589         address token,
590         uint liquidity,
591         uint amountTokenMin,
592         uint amountETHMin,
593         address to,
594         uint deadline
595     ) external returns (uint amountToken, uint amountETH);
596     function removeLiquidityWithPermit(
597         address tokenA,
598         address tokenB,
599         uint liquidity,
600         uint amountAMin,
601         uint amountBMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountA, uint amountB);
606     function removeLiquidityETHWithPermit(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountToken, uint amountETH);
615     function swapExactTokensForTokens(
616         uint amountIn,
617         uint amountOutMin,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapTokensForExactTokens(
623         uint amountOut,
624         uint amountInMax,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external returns (uint[] memory amounts);
629     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         payable
632         returns (uint[] memory amounts);
633     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
634         external
635         returns (uint[] memory amounts);
636     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
637         external
638         returns (uint[] memory amounts);
639     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
640         external
641         payable
642         returns (uint[] memory amounts);
643 
644     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
645     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
646     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
647     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
648     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
649 }
650 
651 interface IUniswapV2Router02 is IUniswapV2Router01 {
652     function removeLiquidityETHSupportingFeeOnTransferTokens(
653         address token,
654         uint liquidity,
655         uint amountTokenMin,
656         uint amountETHMin,
657         address to,
658         uint deadline
659     ) external returns (uint amountETH);
660     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
661         address token,
662         uint liquidity,
663         uint amountTokenMin,
664         uint amountETHMin,
665         address to,
666         uint deadline,
667         bool approveMax, uint8 v, bytes32 r, bytes32 s
668     ) external returns (uint amountETH);
669 
670     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external;
677     function swapExactETHForTokensSupportingFeeOnTransferTokens(
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external payable;
683     function swapExactTokensForETHSupportingFeeOnTransferTokens(
684         uint amountIn,
685         uint amountOutMin,
686         address[] calldata path,
687         address to,
688         uint deadline
689     ) external;
690 }
691 
692 
693 interface Pauses {
694 
695     function unpause() external;
696 }
697 
698 
699 contract TME is Ownable {
700     using SafeMath for uint256;
701     using SafeERC20 for IERC20;
702 
703     
704     
705     uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
706 
707     uint256 public constant HARDCAP = 3000 ether;
708 
709     // Start time  (10/30/2020 @ 12:00pm (UTC))
710     uint256 public CROWDSALE_START_TIME = 1604059200;
711 
712     // End time
713     uint256 public CROWDSALE_END_TIME = CROWDSALE_START_TIME + 2 days;
714 
715     // 1 ETH = 10 ABY
716     uint256 public constant ABY_PER_ETH = 10;
717 
718     
719 
720     // Contributions state
721     mapping(address => uint256) public contributions;
722 
723     uint256 public weiRaised;
724 
725     bool public liquidityLocked = false;
726 
727     IERC20 public abyToken;
728 
729     IUniswapV2Router02 internal uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
730 
731     event TokenPurchase(address indexed beneficiary, uint256 weiAmount, uint256 tokenAmount);
732 
733 
734 
735 
736     //abyss
737     address public abyss;
738 
739 
740 
741     constructor(IERC20 _abyToken, address _abyss) Ownable() public {
742         abyToken = _abyToken;
743         abyss = _abyss;
744     }
745 
746 
747     receive() payable external {
748         // Prevent owner from buying tokens, but allow them to add pre-sale ETH to the contract for Uniswap liquidity
749         if (owner() != msg.sender) {
750             _buyTokens(msg.sender);
751         }
752     }
753 
754     function _buyTokens(address beneficiary) internal {
755         uint256 weiToHardcap = HARDCAP.sub(weiRaised);
756         uint256 weiAmount = weiToHardcap < msg.value ? weiToHardcap : msg.value;
757 
758         _buyTokens(beneficiary, weiAmount);
759 
760         uint256 refund = msg.value.sub(weiAmount);
761         if (refund > 0) {
762             payable(beneficiary).transfer(refund);
763         }
764     }
765 
766     function _buyTokens(address beneficiary, uint256 weiAmount) internal {
767         _validatePurchase(beneficiary, weiAmount);
768 
769         // Update internal state
770         weiRaised = weiRaised.add(weiAmount);
771         contributions[beneficiary] = contributions[beneficiary].add(weiAmount);
772 
773         // Transfer tokens
774         uint256 tokenAmount = _getTokenAmount(weiAmount);
775         abyToken.safeTransfer(beneficiary, tokenAmount);
776 
777         emit TokenPurchase(beneficiary, weiAmount, tokenAmount);
778     }
779 
780     function _validatePurchase(address beneficiary, uint256 weiAmount) internal view {
781         require(beneficiary != address(0), "ABYCrowdsale: beneficiary is the zero address");
782         require(isOpen(), "ABYCrowdsale: sale did not start yet.");
783         require(!hasEnded(), "ABYCrowdsale: sale is over.");
784         require(weiAmount >= MIN_CONTRIBUTION, "ABYCrowdsale: weiAmount is smaller than min contribution.");
785         this; // solidity being solidity doing solidity things, few understand this.
786     }
787 
788     function _getTokenAmount(uint256 weiAmount) internal pure returns (uint256) {
789         return weiAmount.mul(ABY_PER_ETH);
790     }
791 
792 
793 
794 
795     function isOpen() public view returns (bool) {
796         return now >= CROWDSALE_START_TIME;
797     }
798 
799   
800     function hasEnded() public view returns (bool) {
801         return now >= CROWDSALE_END_TIME || weiRaised >= HARDCAP;
802     }
803 
804 
805 
806     function toReserve() public onlyOwner {
807 
808         require(liquidityLocked, "require lock liquidity");
809 
810 
811         address payable res1 = payable(0x28Ac2f2377406c5e03feDD8adb31B7DDb7282B3d);
812 
813         address payable res2 = payable(0x03079442eC8Ad4Fa53458336087C405525e9A75b);
814 
815 
816         address payable smallerRes = payable(0xAc842A088f31C943817BfCd0bACaeF928874771e);
817 
818 
819       
820 
821         uint256 bigResAm = (address(this).balance.mul(45)).div(100);
822 
823         res1.transfer(bigResAm);
824 
825         res2.transfer(bigResAm);
826 
827 
828         smallerRes.transfer(address(this).balance);
829 
830 
831 
832         //send aby left to deployer
833 
834         abyToken.safeTransfer(msg.sender, abyToken.balanceOf(address(this)));
835 
836 
837 
838     }
839 
840 
841     
842 
843     // Uniswap
844 
845     function addAndLockLiquidity() external {
846         require(hasEnded(), "ABYCrowdsale: can only send liquidity once hardcap is reached");
847 
848         require(!liquidityLocked, "already lock liquidity");
849 
850 
851         liquidityLocked = true;
852         
853 
854         //get 10% of the eth 
855         uint256 amountEthForUniswap = (weiRaised.mul(10)).div(100);
856 
857 
858         //get worth of aby for the amountEthForUniswap
859         uint256 amountTokensForUniswap = _getTokenAmount(amountEthForUniswap);
860 
861         //if less than 3000 ETH, get unsold token amount and send to abyss
862 
863         if (weiRaised < HARDCAP){
864 
865             uint256 amountAbyss = _getTokenAmount(HARDCAP.sub(weiRaised));
866 
867             //send to abyss
868 
869             abyToken.safeTransfer(abyss, amountAbyss);
870 
871         }
872 
873         // Unpause transfers forever
874         Pauses(address(abyToken)).unpause();
875         // Send eth and tokens in the contract to Uniswap LP
876         abyToken.approve(address(uniswapRouter), amountTokensForUniswap);
877         uniswapRouter.addLiquidityETH
878         { value: amountEthForUniswap }
879         (
880             address(abyToken),
881             amountTokensForUniswap,
882             amountTokensForUniswap,
883             amountEthForUniswap,
884             address(0), // burn address
885             now
886         );
887         
888 
889         
890 
891         
892 
893 
894     }
895 
896 
897 }