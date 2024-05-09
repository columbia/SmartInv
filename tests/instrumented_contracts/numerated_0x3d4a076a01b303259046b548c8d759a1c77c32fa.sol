1 /*
2 
3 website: wildy.yeet.cool
4 
5                                           `````````````````                                         
6                                          ```.............```                                        
7                                     ```````.mmmmmmmmmmmmd````````                                   
8                                  `````-soyyhMMMMMMMMMMMMMyysos.`````                                
9                                  ```::oNmMMMMMMMMMMMMMMMMMMNmm/:-```                                
10                                  ```dmmMMMMMMMMMMMMMMMMMMMMMMMmmy```                                
11                                  ```dmmMMNmmmmmmmMMMmmmmmmmNMMmmy```                                
12                                  ```dmmNNo///////mmh///////sNNmmy```                                
13                                  ```dmdsy-```````dmy```````:yydmy```                                
14                                  ```dms```````...dmy..````````hmy```                                
15                                `````dms```````ommMMNmm/```````hmy````.                              
16                                ``/ssNNmyyyyyyymMMo+sMMdyyyyyyyNNmss-`.                              
17                                ``ommNNMMMMMMMMmhh.`:hhNMMMMMMMNNNdm/`.                              
18                               ```ommmmmMMMMMMMs`.....`hMMMMMMMmmmmm/``                              
19                     `````````````ommmmmmmMMMMMMNNNNNNNMMMMMNmmmmmmm:`````````````                   
20                  ``````yyyyyyys``-////ommMMN++hMMo+sMMy+oMMNmm+////.`.yyyyyyys``````                
21                  ```-:/MMMMMMMN:::::``-ssmNm``sMM.`/MM/`.NNdss.`.::::/MMMMMMMm::.```                
22                  ```ommMMMMMMMMmmmmm.````ydh``sMM-`/MM/`.mmo````:mmmmmMMMMMMMMmm/```                
23                  ```ommmmmmmMMMMMNmmdds``ymmddNMMMMMMMmddmmo``hddmmNMMMMNmmmmmmm/```                
24                  ```-////ommmmmmmNNNmms``:///:yNmmmmmNo////-``hmmNNNmmmmmmm+////.```                
25                  ````````-sssssmmNNNmmy////:``:sssssss-``/////dmmNNmmdsssss.````````                
26                        .``````.ddddddddmmmdh............-ddmmmdddddddh````````                      
27                             .``......./mmmmmdddddddddddddmmmmm-.......```                           
28                             ``````````.::::/mmNNNNNNNNmmd:::::``````````                            
29                             ``````````-+++++NmNMMMMMMMNmm+++++.`````````                            
30                             .``-------oMMMMMMMMMMMMMMMMMMMMMMM/-------```                           
31                     ``````````-NNNNNNNNMMmmmmmmmmmmmmmmmmmmNMMNNNNNNNm```````````                   
32                  ``````hhhhhhhdMMMMMNmmmmmmd::::::::::::/mmmmmmmNMMMMMhhhhhhhs``````                
33                  ```:++MMMMMMMMNNNNNmmhsssso`````````````sssssdmmNNNNNMMMMMMMN++-```                
34                  ```yMMMMMMMMMNmmdhhhho````````       ````````yhhhhdmmMMMMMMMMMM+```                
35                  ```ommMMNmmmmmmm+.....```                 ```.....smmmmmmmMMMmm/```                
36                  ```-::mmmmm+::::.```                           ```-::::ommmmd::.```                
37                  ``````ossss.```````                             ```````:ssss+``````                
38                     ```````````                                       .``````````                   
39                               `                                       ` 
40 
41 
42 */
43 
44 pragma solidity ^0.6.12;
45 /*
46  * @dev Provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with GSN meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address payable) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes memory) {
61         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
62         return msg.data;
63     }
64 }
65 
66 /**
67  * @dev Interface of the ERC20 standard as defined in the EIP.
68  */
69 interface IERC20 {
70     /**
71      * @dev Returns the amount of tokens in existence.
72      */
73     function totalSupply() external view returns (uint256);
74 
75     /**
76      * @dev Returns the amount of tokens owned by `account`.
77      */
78     function balanceOf(address account) external view returns (uint256);
79 
80     /**
81      * @dev Moves `amount` tokens from the caller's account to `recipient`.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transfer(address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Returns the remaining number of tokens that `spender` will be
91      * allowed to spend on behalf of `owner` through {transferFrom}. This is
92      * zero by default.
93      *
94      * This value changes when {approve} or {transferFrom} are called.
95      */
96     function allowance(address owner, address spender) external view returns (uint256);
97 
98     /**
99      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * IMPORTANT: Beware that changing an allowance with this method brings the risk
104      * that someone may use both the old and the new allowance by unfortunate
105      * transaction ordering. One possible solution to mitigate this race
106      * condition is to first reduce the spender's allowance to 0 and set the
107      * desired value afterwards:
108      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address spender, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Moves `amount` tokens from `sender` to `recipient` using the
116      * allowance mechanism. `amount` is then deducted from the caller's
117      * allowance.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Emitted when `value` tokens are moved from one account (`from`) to
127      * another (`to`).
128      *
129      * Note that `value` may be zero.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 value);
132 
133     /**
134      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
135      * a call to {approve}. `value` is the new allowance.
136      */
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 /**
141  * @dev Wrappers over Solidity's arithmetic operations with added overflow
142  * checks.
143  *
144  * Arithmetic operations in Solidity wrap on overflow. This can easily result
145  * in bugs, because programmers usually assume that an overflow raises an
146  * error, which is the standard behavior in high level programming languages.
147  * `SafeMath` restores this intuition by reverting the transaction when an
148  * operation overflows.
149  *
150  * Using this library instead of the unchecked operations eliminates an entire
151  * class of bugs, so it's recommended to use it always.
152  */
153 library SafeMath {
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      *
162      * - Addition cannot overflow.
163      */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return sub(a, b, "SafeMath: subtraction overflow");
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b <= a, errorMessage);
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `*` operator.
207      *
208      * Requirements:
209      *
210      * - Multiplication cannot overflow.
211      */
212     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
213         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
214         // benefit is lost if 'b' is also tested.
215         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
216         if (a == 0) {
217             return 0;
218         }
219 
220         uint256 c = a * b;
221         require(c / a == b, "SafeMath: multiplication overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         return div(a, b, "SafeMath: division by zero");
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
244      * division by zero. The result is rounded towards zero.
245      *
246      * Counterpart to Solidity's `/` operator. Note: this function uses a
247      * `revert` opcode (which leaves remaining gas untouched) while Solidity
248      * uses an invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b > 0, errorMessage);
256         uint256 c = a / b;
257         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275         return mod(a, b, "SafeMath: modulo by zero");
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * Reverts with custom message when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         require(b != 0, errorMessage);
292         return a % b;
293     }
294 }
295 
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { codehash := extcodehash(account) }
326         return (codehash != accountHash && codehash != 0x0);
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{ value: amount }("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain`call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372       return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
382         return _functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         return _functionCallWithValue(target, data, value, errorMessage);
409     }
410 
411     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 /**
436  * @title SafeERC20
437  * @dev Wrappers around ERC20 operations that throw on failure (when the token
438  * contract returns false). Tokens that return no value (and instead revert or
439  * throw on failure) are also supported, non-reverting calls are assumed to be
440  * successful.
441  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
442  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
443  */
444 library SafeERC20 {
445     using SafeMath for uint256;
446     using Address for address;
447 
448     function safeTransfer(IERC20 token, address to, uint256 value) internal {
449         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
450     }
451 
452     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
453         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
454     }
455 
456     /**
457      * @dev Deprecated. This function has issues similar to the ones found in
458      * {IERC20-approve}, and its usage is discouraged.
459      *
460      * Whenever possible, use {safeIncreaseAllowance} and
461      * {safeDecreaseAllowance} instead.
462      */
463     function safeApprove(IERC20 token, address spender, uint256 value) internal {
464         // safeApprove should only be called when setting an initial allowance,
465         // or when resetting it to zero. To increase and decrease it, use
466         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
467         // solhint-disable-next-line max-line-length
468         require((value == 0) || (token.allowance(address(this), spender) == 0),
469             "SafeERC20: approve from non-zero to non-zero allowance"
470         );
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
472     }
473 
474     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
475         uint256 newAllowance = token.allowance(address(this), spender).add(value);
476         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477     }
478 
479     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
480         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
481         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
482     }
483 
484     /**
485      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
486      * on the return value: the return value is optional (but if data is returned, it must not be false).
487      * @param token The token targeted by the call.
488      * @param data The call data (encoded using abi.encode or one of its variants).
489      */
490     function _callOptionalReturn(IERC20 token, bytes memory data) private {
491         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
492         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
493         // the target address contains contract code and also asserts for success in the low-level call.
494 
495         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
496         if (returndata.length > 0) { // Return data is optional
497             // solhint-disable-next-line max-line-length
498             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
499         }
500     }
501 }
502 
503 
504 
505 /**
506  * @dev Contract module which provides a basic access control mechanism, where
507  * there is an account (an owner) that can be granted exclusive access to
508  * specific functions.
509  *
510  * By default, the owner account will be the one that deploys the contract. This
511  * can later be changed with {transferOwnership}.
512  *
513  * This module is used through inheritance. It will make available the modifier
514  * `onlyOwner`, which can be applied to your functions to restrict their use to
515  * the owner.
516  */
517 contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     /**
523      * @dev Initializes the contract setting the deployer as the initial owner.
524      */
525     constructor () internal {
526         address msgSender = _msgSender();
527         _owner = msgSender;
528         emit OwnershipTransferred(address(0), msgSender);
529     }
530 
531     /**
532      * @dev Returns the address of the current owner.
533      */
534     function owner() public view returns (address) {
535         return _owner;
536     }
537 
538     /**
539      * @dev Throws if called by any account other than the owner.
540      */
541     modifier onlyOwner() {
542         require(_owner == _msgSender(), "Ownable: caller is not the owner");
543         _;
544     }
545 
546     /**
547      * @dev Leaves the contract without owner. It will not be possible to call
548      * `onlyOwner` functions anymore. Can only be called by the current owner.
549      *
550      * NOTE: Renouncing ownership will leave the contract without an owner,
551      * thereby removing any functionality that is only available to the owner.
552      */
553     function renounceOwnership() public virtual onlyOwner {
554         emit OwnershipTransferred(_owner, address(0));
555         _owner = address(0);
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Can only be called by the current owner.
561      */
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         emit OwnershipTransferred(_owner, newOwner);
565         _owner = newOwner;
566     }
567 }
568 
569 
570 /**
571  * @dev Implementation of the {IERC20} interface.
572  *
573  * This implementation is agnostic to the way tokens are created. This means
574  * that a supply mechanism has to be added in a derived contract using {_mint}.
575  * For a generic mechanism see {ERC20PresetMinterPauser}.
576  *
577  * TIP: For a detailed writeup see our guide
578  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
579  * to implement supply mechanisms].
580  *
581  * We have followed general OpenZeppelin guidelines: functions revert instead
582  * of returning `false` on failure. This behavior is nonetheless conventional
583  * and does not conflict with the expectations of ERC20 applications.
584  *
585  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
586  * This allows applications to reconstruct the allowance for all accounts just
587  * by listening to said events. Other implementations of the EIP may not emit
588  * these events, as it isn't required by the specification.
589  *
590  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
591  * functions have been added to mitigate the well-known issues around setting
592  * allowances. See {IERC20-approve}.
593  */
594 contract ERC20 is Context, IERC20 {
595     using SafeMath for uint256;
596     using Address for address;
597 
598     mapping (address => uint256) private _balances;
599 
600     mapping (address => mapping (address => uint256)) private _allowances;
601 
602     uint256 private _totalSupply;
603 
604     string private _name;
605     string private _symbol;
606     uint8 private _decimals;
607 
608     /**
609      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
610      * a default value of 18.
611      *
612      * To select a different value for {decimals}, use {_setupDecimals}.
613      *
614      * All three of these values are immutable: they can only be set once during
615      * construction.
616      */
617     constructor (string memory name, string memory symbol) public {
618         _name = name;
619         _symbol = symbol;
620         _decimals = 18;
621 
622     }
623 
624     /**
625      * @dev Returns the name of the token.
626      */
627     function name() public view returns (string memory) {
628         return _name;
629     }
630 
631     /**
632      * @dev Returns the symbol of the token, usually a shorter version of the
633      * name.
634      */
635     function symbol() public view returns (string memory) {
636         return _symbol;
637     }
638 
639     /**
640      * @dev Returns the number of decimals used to get its user representation.
641      * For example, if `decimals` equals `2`, a balance of `505` tokens should
642      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
643      *
644      * Tokens usually opt for a value of 18, imitating the relationship between
645      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
646      * called.
647      *
648      * NOTE: This information is only used for _display_ purposes: it in
649      * no way affects any of the arithmetic of the contract, including
650      * {IERC20-balanceOf} and {IERC20-transfer}.
651      */
652     function decimals() public view returns (uint8) {
653         return _decimals;
654     }
655     
656 
657     /**
658      * @dev See {IERC20-totalSupply}.
659      */
660     function totalSupply() public view override returns (uint256) {
661         return _totalSupply;
662     }
663 
664     /**
665      * @dev See {IERC20-balanceOf}.
666      */
667     function balanceOf(address account) public view override returns (uint256) {
668         return _balances[account];
669     }
670 
671     /**
672      * @dev See {IERC20-transfer}.
673      *
674      * Requirements:
675      *
676      * - `recipient` cannot be the zero address.
677      * - the caller must have a balance of at least `amount`.
678      */
679     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
680         _transfer(_msgSender(), recipient, amount);
681         return true;
682     }
683 
684     /**
685      * @dev See {IERC20-allowance}.
686      */
687     function allowance(address owner, address spender) public view virtual override returns (uint256) {
688         return _allowances[owner][spender];
689     }
690 
691     /**
692      * @dev See {IERC20-approve}.
693      *
694      * Requirements:
695      *
696      * - `spender` cannot be the zero address.
697      */
698     function approve(address spender, uint256 amount) public virtual override returns (bool) {
699         _approve(_msgSender(), spender, amount);
700         return true;
701     }
702 
703     /**
704      * @dev See {IERC20-transferFrom}.
705      *
706      * Emits an {Approval} event indicating the updated allowance. This is not
707      * required by the EIP. See the note at the beginning of {ERC20};
708      *
709      * Requirements:
710      * - `sender` and `recipient` cannot be the zero address.
711      * - `sender` must have a balance of at least `amount`.
712      * - the caller must have allowance for ``sender``'s tokens of at least
713      * `amount`.
714      */
715     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
716         _transfer(sender, recipient, amount);
717         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
718         return true;
719     }
720 
721     /**
722      * @dev Atomically increases the allowance granted to `spender` by the caller.
723      *
724      * This is an alternative to {approve} that can be used as a mitigation for
725      * problems described in {IERC20-approve}.
726      *
727      * Emits an {Approval} event indicating the updated allowance.
728      *
729      * Requirements:
730      *
731      * - `spender` cannot be the zero address.
732      */
733     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
734         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
735         return true;
736     }
737 
738     /**
739      * @dev Atomically decreases the allowance granted to `spender` by the caller.
740      *
741      * This is an alternative to {approve} that can be used as a mitigation for
742      * problems described in {IERC20-approve}.
743      *
744      * Emits an {Approval} event indicating the updated allowance.
745      *
746      * Requirements:
747      *
748      * - `spender` cannot be the zero address.
749      * - `spender` must have allowance for the caller of at least
750      * `subtractedValue`.
751      */
752     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
753         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
754         return true;
755     }
756 
757     /**
758      * @dev Moves tokens `amount` from `sender` to `recipient`.
759      *
760      * This is internal function is equivalent to {transfer}, and can be used to
761      * e.g. implement automatic token fees, slashing mechanisms, etc.
762      *
763      * Emits a {Transfer} event.
764      *
765      * Requirements:
766      *
767      * - `sender` cannot be the zero address.
768      * - `recipient` cannot be the zero address.
769      * - `sender` must have a balance of at least `amount`.
770      */
771     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
772         require(sender != address(0), "ERC20: transfer from the zero address");
773         require(recipient != address(0), "ERC20: transfer to the zero address");
774 
775         _beforeTokenTransfer(sender, recipient, amount);
776 
777         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
778         _balances[recipient] = _balances[recipient].add(amount);
779         emit Transfer(sender, recipient, amount);
780     }
781 
782     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
783      * the total supply.
784      *
785      * Emits a {Transfer} event with `from` set to the zero address.
786      *
787      * Requirements
788      *
789      * - `to` cannot be the zero address.
790      */
791     function _mint(address account, uint256 amount) internal virtual {
792         require(account != address(0), "ERC20: mint to the zero address");
793 
794         _beforeTokenTransfer(address(0), account, amount);
795 
796         _totalSupply = _totalSupply.add(amount);
797         _balances[account] = _balances[account].add(amount);
798         emit Transfer(address(0), account, amount);
799     }
800 
801     /**
802      * @dev Destroys `amount` tokens from `account`, reducing the
803      * total supply.
804      *
805      * Emits a {Transfer} event with `to` set to the zero address.
806      *
807      * Requirements
808      *
809      * - `account` cannot be the zero address.
810      * - `account` must have at least `amount` tokens.
811      */
812     function _burn(address account, uint256 amount) internal virtual {
813         require(account != address(0), "ERC20: burn from the zero address");
814 
815         _beforeTokenTransfer(account, address(0), amount);
816 
817         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
818         _totalSupply = _totalSupply.sub(amount);
819         emit Transfer(account, address(0), amount);
820     }
821 
822     /**
823      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
824      *
825      * This is internal function is equivalent to `approve`, and can be used to
826      * e.g. set automatic allowances for certain subsystems, etc.
827      *
828      * Emits an {Approval} event.
829      *
830      * Requirements:
831      *
832      * - `owner` cannot be the zero address.
833      * - `spender` cannot be the zero address.
834      */
835     function _approve(address owner, address spender, uint256 amount) internal virtual {
836         require(owner != address(0), "ERC20: approve from the zero address");
837         require(spender != address(0), "ERC20: approve to the zero address");
838 
839         _allowances[owner][spender] = amount;
840         emit Approval(owner, spender, amount);
841     }
842 
843     /**
844      * @dev Sets {decimals} to a value other than the default one of 18.
845      *
846      * WARNING: This function should only be called from the constructor. Most
847      * applications that interact with token contracts will not expect
848      * {decimals} to ever change, and may work incorrectly if it does.
849      */
850     function _setupDecimals(uint8 decimals_) internal {
851         _decimals = decimals_;
852     }
853 
854     /**
855      * @dev Hook that is called before any transfer of tokens. This includes
856      * minting and burning.
857      *
858      * Calling conditions:
859      *
860      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
861      * will be to transferred to `to`.
862      * - when `from` is zero, `amount` tokens will be minted for `to`.
863      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
864      * - `from` and `to` are never both zero.
865      *
866      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
867      */
868     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
869 }
870 
871 // WildyToken.
872 contract WildyToken is ERC20("Wildy", "$WILDY"), Ownable {
873 
874     uint256 public constant maxSupply = 69420666 * 10 ** 18;
875 
876     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
877     function mint(address _to, uint256 _amount) public onlyOwner {
878         _mint(_to, _amount);
879     }
880 }