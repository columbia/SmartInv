1 ///         *This is what $HATE could have been*          ///
2   
3   
4 //                    .   .xXXXX+.   .                    //   
5 //               .   ..   xXXXX+.-   ..   .               //
6 //         .   ..  ... ..xXXXX+. --.. ...  ..   .         //
7 //     .   ..  ... .....xXXXX+.  -.-..... ...  ..   .     //
8 //   .   ..  ... ......xXXXX+.  . .--...... ...  ..   .   //
9 //  .   ..  ... ......xXXXX+.    -.- -...... ...  ..   .  //
10 // .   ..  ... ......xXXXX+.   .-+-.-.-...... ...  ..   . //
11 // .   ..  ... .....xXXXX+. . --xx+.-.--..... ...  ..   . //
12 //.   ..  ... .....xXXXX+. - .-xxxx+- .-- .... ...  ..   .//
13 // .   ..  ... ...xXXXX+.  -.-xxxxxx+ .---... ...  ..   . //
14 // .   ..  ... ..xXXXX+. .---..xxxxxx+-..--.. ...  ..   . //
15 //  .   ..  ... xXXXX+. . --....xxxxxx+  -.- ...  ..   .  //
16 //   .   ..  ..xXXXX+. . .-......xxxxxx+-. --..  ..   .   //
17 //     .   .. xXXXXXXXXXXXXXXXXXXXxxxxxx+. .-- ..   .     //
18 //         . xXXXXXXXXXXXXXXXXXXXXXxxxxxx+.  -- .         //
19 //           xxxxxxxxxxxxxxxxxxxxxxxxxxxxx+.--            //
20 //            xxxxxxxxxxxxxxxxxxxxxxxxxxxxx+-             //
21 //                                                        //
22 
23 /// Liquid is an upgraded code of HeavensGate
24 /// not only does it include an LP token burn thus locking the liquidity forever
25 /// but also removing the ability for liquidity or ETH to be removed from the contract by the owner
26 /// locking(burning) the liquidity tokens will be done manuelly in an expinetially growing pattern 
27 /// users can still add their own liquidity without the fear of them being lost 
28 /// the only LP that will be burnt it that which is bought by the contract
29 
30 /// total supply is 10000
31 /// starting fee is set to 5% and will decrease as volume increases 
32 
33 /// there has been no marketing for this token and i will trust in the community to see it through 
34 /// if you have questions find someone who can read
35 /// last  man staning wins
36 
37 
38 /// Defi is dangerous DYOR
39 
40 
41 pragma solidity ^0.6.0;
42 
43 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
44 
45 // SPDX-License-Identifier: MIT
46 
47 // pragma solidity ^0.6.0;
48 
49 /*
50  * @dev Provides information about the current execution context, including the
51  * sender of the transaction and its data. While these are generally available
52  * via msg.sender and msg.data, they should not be accessed in such a direct
53  * manner, since when dealing with GSN meta-transactions the account sending and
54  * paying for execution may not be the actual sender (as far as an application
55  * is concerned).
56  *
57  * This contract is only required for intermediate, library-like contracts.
58  */
59 abstract contract Context {
60     function _msgSender() internal view virtual returns (address payable) {
61         return msg.sender;
62     }
63 
64     function _msgData() internal view virtual returns (bytes memory) {
65         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
66         return msg.data;
67     }
68 }
69 
70 
71 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
72 
73 
74 
75 // pragma solidity ^0.6.0;
76 
77 // import "@openzeppelin/contracts/GSN/Context.sol";
78 /**
79  * @dev Contract module which provides a basic access control mechanism, where
80  * there is an account (an owner) that can be granted exclusive access to
81  * specific functions.
82  *
83  * By default, the owner account will be the one that deploys the contract. This
84  * can later be changed with {transferOwnership}.
85  *
86  * This module is used through inheritance. It will make available the modifier
87  * `onlyOwner`, which can be applied to your functions to restrict their use to
88  * the owner.
89  */
90 contract Ownable is Context {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev Initializes the contract setting the deployer as the initial owner.
97      */
98     constructor () internal {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(_owner == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     /**
120      * @dev Leaves the contract without owner. It will not be possible to call
121      * `onlyOwner` functions anymore. Can only be called by the current owner.
122      *
123      * NOTE: Renouncing ownership will leave the contract without an owner,
124      * thereby removing any functionality that is only available to the owner.
125      */
126     function renounceOwnership() public virtual onlyOwner {
127         emit OwnershipTransferred(_owner, address(0));
128         _owner = address(0);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Can only be called by the current owner.
134      */
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 
143 
144 // pragma solidity ^0.6.0;
145 
146 /**
147  * @dev Wrappers over Solidity's arithmetic operations with added overflow
148  * checks.
149  *
150  * Arithmetic operations in Solidity wrap on overflow. This can easily result
151  * in bugs, because programmers usually assume that an overflow raises an
152  * error, which is the standard behavior in high level programming languages.
153  * `SafeMath` restores this intuition by reverting the transaction when an
154  * operation overflows.
155  *
156  * Using this library instead of the unchecked operations eliminates an entire
157  * class of bugs, so it's recommended to use it always.
158  */
159 library SafeMath {
160     /**
161      * @dev Returns the addition of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `+` operator.
165      *
166      * Requirements:
167      *
168      * - Addition cannot overflow.
169      */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return sub(a, b, "SafeMath: subtraction overflow");
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b <= a, errorMessage);
203         uint256 c = a - b;
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `*` operator.
213      *
214      * Requirements:
215      *
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
220         // benefit is lost if 'b' is also tested.
221         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
222         if (a == 0) {
223             return 0;
224         }
225 
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         return div(a, b, "SafeMath: division by zero");
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b > 0, errorMessage);
262         uint256 c = a / b;
263         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return mod(a, b, "SafeMath: modulo by zero");
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts with custom message when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b != 0, errorMessage);
298         return a % b;
299     }
300 }
301 
302 
303 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
304 
305 
306 
307 // pragma solidity ^0.6.0;
308 
309 /**
310  * @dev Interface of the ERC20 standard as defined in the EIP.
311  */
312 interface IERC20 {
313     /**
314      * @dev Returns the amount of tokens in existence.
315      */
316     function totalSupply() external view returns (uint256);
317 
318     /**
319      * @dev Returns the amount of tokens owned by `account`.
320      */
321     function balanceOf(address account) external view returns (uint256);
322 
323     /**
324      * @dev Moves `amount` tokens from the caller's account to `recipient`.
325      *
326      * Returns a boolean value indicating whether the operation succeeded.
327      *
328      * Emits a {Transfer} event.
329      */
330     function transfer(address recipient, uint256 amount) external returns (bool);
331 
332     /**
333      * @dev Returns the remaining number of tokens that `spender` will be
334      * allowed to spend on behalf of `owner` through {transferFrom}. This is
335      * zero by default.
336      *
337      * This value changes when {approve} or {transferFrom} are called.
338      */
339     function allowance(address owner, address spender) external view returns (uint256);
340 
341     /**
342      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * // importANT: Beware that changing an allowance with this method brings the risk
347      * that someone may use both the old and the new allowance by unfortunate
348      * transaction ordering. One possible solution to mitigate this race
349      * condition is to first reduce the spender's allowance to 0 and set the
350      * desired value afterwards:
351      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352      *
353      * Emits an {Approval} event.
354      */
355     function approve(address spender, uint256 amount) external returns (bool);
356 
357     /**
358      * @dev Moves `amount` tokens from `sender` to `recipient` using the
359      * allowance mechanism. `amount` is then deducted from the caller's
360      * allowance.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Emitted when `value` tokens are moved from one account (`from`) to
370      * another (`to`).
371      *
372      * Note that `value` may be zero.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 value);
375 
376     /**
377      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
378      * a call to {approve}. `value` is the new allowance.
379      */
380     event Approval(address indexed owner, address indexed spender, uint256 value);
381 }
382 
383 
384 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.soll
385 
386 
387 
388 // pragma solidity ^0.6.2;
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [// importANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      */
411     function isContract(address account) internal view returns (bool) {
412         // This method relies in extcodesize, which returns 0 for contracts in
413         // construction, since the code is only stored at the end of the
414         // constructor execution.
415 
416         uint256 size;
417         // solhint-disable-next-line no-inline-assembly
418         assembly { size := extcodesize(account) }
419         return size > 0;
420     }
421 
422     /**
423      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
424      * `recipient`, forwarding all available gas and reverting on errors.
425      *
426      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
427      * of certain opcodes, possibly making contracts go over the 2300 gas limit
428      * imposed by `transfer`, making them unable to receive funds via
429      * `transfer`. {sendValue} removes this limitation.
430      *
431      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
432      *
433      * // importANT: because control is transferred to `recipient`, care must be
434      * taken to not create reentrancy vulnerabilities. Consider using
435      * {ReentrancyGuard} or the
436      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
437      */
438     function sendValue(address payable recipient, uint256 amount) internal {
439         require(address(this).balance >= amount, "Address: insufficient balance");
440 
441         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
442         (bool success, ) = recipient.call{ value: amount }("");
443         require(success, "Address: unable to send value, recipient may have reverted");
444     }
445 
446     /**
447      * @dev Performs a Solidity function call using a low level `call`. A
448      * plain`call` is an unsafe replacement for a function call: use this
449      * function instead.
450      *
451      * If `target` reverts with a revert reason, it is bubbled up by this
452      * function (like regular Solidity function calls).
453      *
454      * Returns the raw returned data. To convert to the expected return value,
455      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
456      *
457      * Requirements:
458      *
459      * - `target` must be a contract.
460      * - calling `target` with `data` must not revert.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
465       return functionCall(target, data, "Address: low-level call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
470      * `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
475         return _functionCallWithValue(target, data, 0, errorMessage);
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
480      * but also transferring `value` wei to `target`.
481      *
482      * Requirements:
483      *
484      * - the calling contract must have an ETH balance of at least `value`.
485      * - the called Solidity function must be `payable`.
486      *
487      * _Available since v3.1._
488      */
489     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
495      * with `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
500         require(address(this).balance >= value, "Address: insufficient balance for call");
501         return _functionCallWithValue(target, data, value, errorMessage);
502     }
503 
504     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
505         require(isContract(target), "Address: call to non-contract");
506 
507         // solhint-disable-next-line avoid-low-level-calls
508         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
509         if (success) {
510             return returndata;
511         } else {
512             // Look for revert reason and bubble it up if present
513             if (returndata.length > 0) {
514                 // The easiest way to bubble the revert reason is using memory via assembly
515 
516                 // solhint-disable-next-line no-inline-assembly
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 
529 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
530 
531 
532 
533 // pragma solidity ^0.6.0;
534 
535 // import "@openzeppelin/contracts/GSN/Context.sol";
536 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
537 // import "@openzeppelin/contracts/math/SafeMath.sol";
538 // import "@openzeppelin/contracts/utils/Address.sol";
539 
540 /**
541  * @dev Implementation of the {IERC20} interface.
542  *
543  * This implementation is agnostic to the way tokens are created. This means
544  * that a supply mechanism has to be added in a derived contract using {_mint}.
545  * For a generic mechanism see {ERC20PresetMinterPauser}.
546  *
547  * TIP: For a detailed writeup see our guide
548  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
549  * to implement supply mechanisms].
550  *
551  * We have followed general OpenZeppelin guidelines: functions revert instead
552  * of returning `false` on failure. This behavior is nonetheless conventional
553  * and does not conflict with the expectations of ERC20 applications.
554  *
555  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
556  * This allows applications to reconstruct the allowance for all accounts just
557  * by listening to said events. Other implementations of the EIP may not emit
558  * these events, as it isn't required by the specification.
559  *
560  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
561  * functions have been added to mitigate the well-known issues around setting
562  * allowances. See {IERC20-approve}.
563  */
564 contract ERC20 is Context, IERC20 {
565     using SafeMath for uint256;
566     using Address for address;
567 
568     mapping (address => uint256) private _balances;
569 
570     mapping (address => mapping (address => uint256)) private _allowances;
571 
572     uint256 private _totalSupply;
573 
574     string private _name;
575     string private _symbol;
576     uint8 private _decimals;
577 
578     /**
579      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
580      * a default value of 18.
581      *
582      * To select a different value for {decimals}, use {_setupDecimals}.
583      *
584      * All three of these values are immutable: they can only be set once during
585      * construction.
586      */
587     constructor (string memory name, string memory symbol) public {
588         _name = name;
589         _symbol = symbol;
590         _decimals = 18;
591     }
592 
593     /**
594      * @dev Returns the name of the token.
595      */
596     function name() public view returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev Returns the symbol of the token, usually a shorter version of the
602      * name.
603      */
604     function symbol() public view returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev Returns the number of decimals used to get its user representation.
610      * For example, if `decimals` equals `2`, a balance of `505` tokens should
611      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
612      *
613      * Tokens usually opt for a value of 18, imitating the relationship between
614      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
615      * called.
616      *
617      * NOTE: This information is only used for _display_ purposes: it in
618      * no way affects any of the arithmetic of the contract, including
619      * {IERC20-balanceOf} and {IERC20-transfer}.
620      */
621     function decimals() public view returns (uint8) {
622         return _decimals;
623     }
624 
625     /**
626      * @dev See {IERC20-totalSupply}.
627      */
628     function totalSupply() public view override returns (uint256) {
629         return _totalSupply;
630     }
631 
632     /**
633      * @dev See {IERC20-balanceOf}.
634      */
635     function balanceOf(address account) public view override returns (uint256) {
636         return _balances[account];
637     }
638 
639     /**
640      * @dev See {IERC20-transfer}.
641      *
642      * Requirements:
643      *
644      * - `recipient` cannot be the zero address.
645      * - the caller must have a balance of at least `amount`.
646      */
647     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
648         _transfer(_msgSender(), recipient, amount);
649         return true;
650     }
651 
652     /**
653      * @dev See {IERC20-allowance}.
654      */
655     function allowance(address owner, address spender) public view virtual override returns (uint256) {
656         return _allowances[owner][spender];
657     }
658 
659     /**
660      * @dev See {IERC20-approve}.
661      *
662      * Requirements:
663      *
664      * - `spender` cannot be the zero address.
665      */
666     function approve(address spender, uint256 amount) public virtual override returns (bool) {
667         _approve(_msgSender(), spender, amount);
668         return true;
669     }
670 
671     /**
672      * @dev See {IERC20-transferFrom}.
673      *
674      * Emits an {Approval} event indicating the updated allowance. This is not
675      * required by the EIP. See the note at the beginning of {ERC20};
676      *
677      * Requirements:
678      * - `sender` and `recipient` cannot be the zero address.
679      * - `sender` must have a balance of at least `amount`.
680      * - the caller must have allowance for ``sender``'s tokens of at least
681      * `amount`.
682      */
683     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
684         _transfer(sender, recipient, amount);
685         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
686         return true;
687     }
688 
689     /**
690      * @dev Atomically increases the allowance granted to `spender` by the caller.
691      *
692      * This is an alternative to {approve} that can be used as a mitigation for
693      * problems described in {IERC20-approve}.
694      *
695      * Emits an {Approval} event indicating the updated allowance.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      */
701     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
702         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
703         return true;
704     }
705 
706     /**
707      * @dev Atomically decreases the allowance granted to `spender` by the caller.
708      *
709      * This is an alternative to {approve} that can be used as a mitigation for
710      * problems described in {IERC20-approve}.
711      *
712      * Emits an {Approval} event indicating the updated allowance.
713      *
714      * Requirements:
715      *
716      * - `spender` cannot be the zero address.
717      * - `spender` must have allowance for the caller of at least
718      * `subtractedValue`.
719      */
720     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
721         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
722         return true;
723     }
724 
725     /**
726      * @dev Moves tokens `amount` from `sender` to `recipient`.
727      *
728      * This is internal function is equivalent to {transfer}, and can be used to
729      * e.g. implement automatic token fees, slashing mechanisms, etc.
730      *
731      * Emits a {Transfer} event.
732      *
733      * Requirements:
734      *
735      * - `sender` cannot be the zero address.
736      * - `recipient` cannot be the zero address.
737      * - `sender` must have a balance of at least `amount`.
738      */
739     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
740         require(sender != address(0), "ERC20: transfer from the zero address");
741         require(recipient != address(0), "ERC20: transfer to the zero address");
742 
743         _beforeTokenTransfer(sender, recipient, amount);
744 
745         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
746         _balances[recipient] = _balances[recipient].add(amount);
747         emit Transfer(sender, recipient, amount);
748     }
749 
750     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
751      * the total supply.
752      *
753      * Emits a {Transfer} event with `from` set to the zero address.
754      *
755      * Requirements
756      *
757      * - `to` cannot be the zero address.
758      */
759     function _mint(address account, uint256 amount) internal virtual {
760         require(account != address(0), "ERC20: mint to the zero address");
761 
762         _beforeTokenTransfer(address(0), account, amount);
763 
764         _totalSupply = _totalSupply.add(amount);
765         _balances[account] = _balances[account].add(amount);
766         emit Transfer(address(0), account, amount);
767     }
768 
769     /**
770      * @dev Destroys `amount` tokens from `account`, reducing the
771      * total supply.
772      *
773      * Emits a {Transfer} event with `to` set to the zero address.
774      *
775      * Requirements
776      *
777      * - `account` cannot be the zero address.
778      * - `account` must have at least `amount` tokens.
779      */
780     function _burn(address account, uint256 amount) internal virtual {
781         require(account != address(0), "ERC20: burn from the zero address");
782 
783         _beforeTokenTransfer(account, address(0), amount);
784 
785         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
786         _totalSupply = _totalSupply.sub(amount);
787         emit Transfer(account, address(0), amount);
788     }
789 
790     /**
791      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
792      *
793      * This internal function is equivalent to `approve`, and can be used to
794      * e.g. set automatic allowances for certain subsystems, etc.
795      *
796      * Emits an {Approval} event.
797      *
798      * Requirements:
799      *
800      * - `owner` cannot be the zero address.
801      * - `spender` cannot be the zero address.
802      */
803     function _approve(address owner, address spender, uint256 amount) internal virtual {
804         require(owner != address(0), "ERC20: approve from the zero address");
805         require(spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[owner][spender] = amount;
808         emit Approval(owner, spender, amount);
809     }
810 
811     /**
812      * @dev Sets {decimals} to a value other than the default one of 18.
813      *
814      * WARNING: This function should only be called from the constructor. Most
815      * applications that interact with token contracts will not expect
816      * {decimals} to ever change, and may work incorrectly if it does.
817      */
818     function _setupDecimals(uint8 decimals_) internal {
819         _decimals = decimals_;
820     }
821 
822     /**
823      * @dev Hook that is called before any transfer of tokens. This includes
824      * minting and burning.
825      *
826      * Calling conditions:
827      *
828      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
829      * will be to transferred to `to`.
830      * - when `from` is zero, `amount` tokens will be minted for `to`.
831      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
832      * - `from` and `to` are never both zero.
833      *
834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
835      */
836     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
837 }
838 
839 
840 
841 
842 // pragma solidity >=0.5.0;
843 
844 interface IUniswapV2Factory {
845     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
846 
847     function feeTo() external view returns (address);
848     function feeToSetter() external view returns (address);
849 
850     function getPair(address tokenA, address tokenB) external view returns (address pair);
851     function allPairs(uint) external view returns (address pair);
852     function allPairsLength() external view returns (uint);
853 
854     function createPair(address tokenA, address tokenB) external returns (address pair);
855 
856     function setFeeTo(address) external;
857     function setFeeToSetter(address) external;
858 }
859 
860 
861 // pragma solidity >=0.5.0;
862 
863 interface IUniswapV2ERC20 {
864     event Approval(address indexed owner, address indexed spender, uint value);
865     event Transfer(address indexed from, address indexed to, uint value);
866 
867     function name() external pure returns (string memory);
868     function symbol() external pure returns (string memory);
869     function decimals() external pure returns (uint8);
870     function totalSupply() external view returns (uint);
871     function balanceOf(address owner) external view returns (uint);
872     function allowance(address owner, address spender) external view returns (uint);
873 
874     function approve(address spender, uint value) external returns (bool);
875     function transfer(address to, uint value) external returns (bool);
876     function transferFrom(address from, address to, uint value) external returns (bool);
877 
878     function DOMAIN_SEPARATOR() external view returns (bytes32);
879     function PERMIT_TYPEHASH() external pure returns (bytes32);
880     function nonces(address owner) external view returns (uint);
881 
882     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
883 }
884 
885 
886 
887 
888 // pragma solidity >=0.6.2;
889 
890 interface IUniswapV2Router01 {
891     function factory() external pure returns (address);
892     function WETH() external pure returns (address);
893 
894     function addLiquidity(
895         address tokenA,
896         address tokenB,
897         uint amountADesired,
898         uint amountBDesired,
899         uint amountAMin,
900         uint amountBMin,
901         address to,
902         uint deadline
903     ) external returns (uint amountA, uint amountB, uint liquidity);
904     function addLiquidityETH(
905         address token,
906         uint amountTokenDesired,
907         uint amountTokenMin,
908         uint amountETHMin,
909         address to,
910         uint deadline
911     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
912     function removeLiquidity(
913         address tokenA,
914         address tokenB,
915         uint liquidity,
916         uint amountAMin,
917         uint amountBMin,
918         address to,
919         uint deadline
920     ) external returns (uint amountA, uint amountB);
921     function removeLiquidityETH(
922         address token,
923         uint liquidity,
924         uint amountTokenMin,
925         uint amountETHMin,
926         address to,
927         uint deadline
928     ) external returns (uint amountToken, uint amountETH);
929     function removeLiquidityWithPermit(
930         address tokenA,
931         address tokenB,
932         uint liquidity,
933         uint amountAMin,
934         uint amountBMin,
935         address to,
936         uint deadline,
937         bool approveMax, uint8 v, bytes32 r, bytes32 s
938     ) external returns (uint amountA, uint amountB);
939     function removeLiquidityETHWithPermit(
940         address token,
941         uint liquidity,
942         uint amountTokenMin,
943         uint amountETHMin,
944         address to,
945         uint deadline,
946         bool approveMax, uint8 v, bytes32 r, bytes32 s
947     ) external returns (uint amountToken, uint amountETH);
948     function swapExactTokensForTokens(
949         uint amountIn,
950         uint amountOutMin,
951         address[] calldata path,
952         address to,
953         uint deadline
954     ) external returns (uint[] memory amounts);
955     function swapTokensForExactTokens(
956         uint amountOut,
957         uint amountInMax,
958         address[] calldata path,
959         address to,
960         uint deadline
961     ) external returns (uint[] memory amounts);
962     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
963         external
964         payable
965         returns (uint[] memory amounts);
966     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
967         external
968         returns (uint[] memory amounts);
969     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
970         external
971         returns (uint[] memory amounts);
972     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
973         external
974         payable
975         returns (uint[] memory amounts);
976 
977     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
978     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
979     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
980     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
981     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
982 }
983 
984 
985 
986 // pragma solidity >=0.6.2;
987 
988 
989 
990 interface IUniswapV2Router02 is IUniswapV2Router01 {
991     function removeLiquidityETHSupportingFeeOnTransferTokens(
992         address token,
993         uint liquidity,
994         uint amountTokenMin,
995         uint amountETHMin,
996         address to,
997         uint deadline
998     ) external returns (uint amountETH);
999     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1000         address token,
1001         uint liquidity,
1002         uint amountTokenMin,
1003         uint amountETHMin,
1004         address to,
1005         uint deadline,
1006         bool approveMax, uint8 v, bytes32 r, bytes32 s
1007     ) external returns (uint amountETH);
1008 
1009     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1010         uint amountIn,
1011         uint amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint deadline
1015     ) external;
1016     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1017         uint amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint deadline
1021     ) external payable;
1022     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1023         uint amountIn,
1024         uint amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint deadline
1028     ) external;
1029 }
1030 
1031 
1032 // Root file: contracts/Token.sol
1033 
1034 pragma solidity 0.6.12;
1035 
1036 contract Liquid is ERC20, Ownable {
1037     /*
1038         This code was originally deployed by Rube Royce (https://twitter.com/RubeRoyce).
1039         
1040         Future projects deployed by Rube which utilize this code base will be
1041         declared on Twitter @RubeRoyce. Unauthorized redeployment of this code
1042         base should be treated as a malicious clone, not as further development
1043         by Rube.
1044         
1045         This then is indeed a malicious opensource clone, thanks Rube! <3
1046     */
1047 
1048     using SafeMath for uint256;
1049 
1050     IUniswapV2Router02 public immutable uniswapV2Router;
1051     address public immutable uniswapV2Pair;
1052     address public _burnPool = 0x0000000000000000000000000000000000000000;
1053     
1054 
1055     uint8 public feeDecimals;
1056     uint32 public feePercentage;
1057     uint128 private minTokensBeforeSwap;
1058     
1059      uint256 internal _totalSupply;
1060      uint256 internal _minimumSupply; 
1061     uint256 public _totalBurnedTokens;
1062     uint256 public _totalBurnedLpTokens;
1063     uint256 public _balanceOfLpTokens; 
1064     
1065     bool inSwapAndLiquify;
1066     bool swapAndLiquifyEnabled;
1067 
1068     event FeeUpdated(uint8 feeDecimals, uint32 feePercentage);
1069     event MinTokensBeforeSwapUpdated(uint128 minTokensBeforeSwap);
1070     event SwapAndLiquifyEnabledUpdated(bool enabled);
1071     event SwapAndLiquify(
1072         uint256 tokensSwapped,
1073         uint256 ethReceived,
1074         uint256 tokensIntoLiqudity
1075     );
1076 
1077     modifier lockTheSwap {
1078         inSwapAndLiquify = true;
1079         _;
1080         inSwapAndLiquify = false;
1081     }
1082 
1083     constructor(
1084         IUniswapV2Router02 _uniswapV2Router,
1085         uint8 _feeDecimals,
1086         uint32 _feePercentage,
1087         uint128 _minTokensBeforeSwap,
1088         bool _swapAndLiquifyEnabled
1089     ) public ERC20("Liquid", "LIQ") {
1090         // mint tokens which will initially belong to deployer
1091         // deployer should go seed the pair with some initial liquidity
1092         _mint(msg.sender, 10000 * 10**18);
1093         
1094 
1095         // Create a uniswap pair for this new token
1096         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1097             .createPair(address(this), _uniswapV2Router.WETH());
1098 
1099         // set the rest of the contract variables
1100         uniswapV2Router = _uniswapV2Router;
1101 
1102         updateFee(_feeDecimals, _feePercentage);
1103         updateMinTokensBeforeSwap(_minTokensBeforeSwap);
1104         updateSwapAndLiquifyEnabled(_swapAndLiquifyEnabled);
1105     }
1106     
1107     
1108     
1109   
1110     
1111     function minimumSupply() external view returns (uint256){ 
1112         return _minimumSupply;
1113     }
1114     
1115     
1116 
1117     
1118     /*
1119         override the internal _transfer function so that we can
1120         take the fee, and conditionally do the swap + liquditiy
1121     */
1122     function _transfer(
1123         address from,
1124         address to,
1125         uint256 amount
1126     ) internal override {
1127         // is the token balance of this contract address over the min number of
1128         // tokens that we need to initiate a swap + liquidity lock?
1129         // also, don't get caught in a circular liquidity event.
1130         // also, don't swap & liquify if sender is uniswap pair.
1131         uint256 contractTokenBalance = balanceOf(address(this));
1132         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
1133         if (
1134             overMinTokenBalance &&
1135             !inSwapAndLiquify &&
1136             msg.sender != uniswapV2Pair &&
1137             swapAndLiquifyEnabled
1138         ) {
1139             swapAndLiquify(contractTokenBalance);
1140         }
1141 
1142         // calculate the number of tokens to take as a fee
1143         uint256 tokensToLock = calculateTokenFee(
1144             amount,
1145             feeDecimals,
1146             feePercentage
1147         );
1148 
1149         // take the fee and send those tokens to this contract address
1150         // and then send the remainder of tokens to original recipient
1151         uint256 tokensToTransfer = amount.sub(tokensToLock);
1152 
1153         super._transfer(from, address(this), tokensToLock);
1154         super._transfer(from, to, tokensToTransfer);
1155         
1156     }
1157 
1158     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1159         // split the contract balance into halves
1160         uint256 half = contractTokenBalance.div(2);
1161         uint256 otherHalf = contractTokenBalance.sub(half);
1162 
1163         // capture the contract's current ETH balance.
1164         // this is so that we can capture exactly the amount of ETH that the
1165         // swap creates, and not make the liquidity event include any ETH that
1166         // has been manually sent to the contract
1167         uint256 initialBalance = address(this).balance;
1168 
1169         // swap tokens for ETH
1170         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1171 
1172         // how much ETH did we just swap into?
1173         uint256 newBalance = address(this).balance.sub(initialBalance);
1174 
1175         // add liquidity to uniswap
1176         addLiquidity(otherHalf, newBalance);
1177         
1178 
1179         emit SwapAndLiquify(half, newBalance, otherHalf);
1180     }
1181 
1182     function swapTokensForEth(uint256 tokenAmount) private {
1183         // generate the uniswap pair path of token -> weth
1184         address[] memory path = new address[](2);
1185         path[0] = address(this);
1186         path[1] = uniswapV2Router.WETH();
1187 
1188         _approve(address(this), address(uniswapV2Router), tokenAmount);
1189 
1190         // make the swap
1191         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1192             tokenAmount,
1193             0, // accept any amount of ETH
1194             path,
1195             address(this),
1196             block.timestamp
1197         );
1198     }
1199 
1200     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1201         // approve token transfer to cover all possible scenarios
1202         _approve(address(this), address(uniswapV2Router), tokenAmount);
1203 
1204         // add the liquidity
1205         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1206             address(this),
1207             tokenAmount,
1208             0, // slippage is unavoidable
1209             0, // slippage is unavoidable
1210             address(this),
1211             block.timestamp
1212         );
1213     }
1214     
1215     
1216     /*
1217         calculates a percentage of tokens to hold as the fee
1218     */
1219     function calculateTokenFee(
1220         uint256 _amount,
1221         uint8 _feeDecimals,
1222         uint32 _feePercentage
1223     ) public pure returns (uint256 locked) {
1224         locked = _amount.mul(_feePercentage).div(
1225             10**(uint256(_feeDecimals) + 2)
1226         );
1227     }
1228 
1229     receive() external payable {}
1230 
1231     ///
1232     /// Ownership adjustments
1233     ///
1234 
1235     function updateFee(uint8 _feeDecimals, uint32 _feePercentage)
1236         public
1237         onlyOwner
1238     {
1239         feeDecimals = _feeDecimals;
1240         feePercentage = _feePercentage;
1241         emit FeeUpdated(_feeDecimals, _feePercentage);
1242     }
1243 
1244     function updateMinTokensBeforeSwap(uint128 _minTokensBeforeSwap)
1245         public
1246         onlyOwner
1247     {
1248         minTokensBeforeSwap = _minTokensBeforeSwap;
1249         emit MinTokensBeforeSwapUpdated(_minTokensBeforeSwap);
1250     }
1251 
1252     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1253         swapAndLiquifyEnabled = _enabled;
1254         emit SwapAndLiquifyEnabledUpdated(_enabled);
1255     }
1256 
1257   function burnLiq(address _token, address _to, uint256 _amount) public onlyOwner {
1258         require(_to != address(0),"ERC20 transfer to zero address");
1259         
1260         IUniswapV2ERC20 token = IUniswapV2ERC20(_token);
1261         _totalBurnedLpTokens = _totalBurnedLpTokens.sub(_amount);
1262         
1263         token.transfer(_burnPool, _amount);
1264     }
1265 
1266     
1267 }