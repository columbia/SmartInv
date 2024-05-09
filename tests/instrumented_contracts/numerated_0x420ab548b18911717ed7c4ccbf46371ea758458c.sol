1 /*
2 
3 website: noodle.finance
4 
5  ███▄    █  ▒█████   ▒█████  ▓█████▄  ██▓    ▓█████        █████▒██▓ ███▄    █  ▄▄▄       ███▄    █  ▄████▄  ▓█████ 
6  ██ ▀█   █ ▒██▒  ██▒▒██▒  ██▒▒██▀ ██▌▓██▒    ▓█   ▀      ▓██   ▒▓██▒ ██ ▀█   █ ▒████▄     ██ ▀█   █ ▒██▀ ▀█  ▓█   ▀ 
7 ▓██  ▀█ ██▒▒██░  ██▒▒██░  ██▒░██   █▌▒██░    ▒███        ▒████ ░▒██▒▓██  ▀█ ██▒▒██  ▀█▄  ▓██  ▀█ ██▒▒▓█    ▄ ▒███   
8 ▓██▒  ▐▌██▒▒██   ██░▒██   ██░░▓█▄   ▌▒██░    ▒▓█  ▄      ░▓█▒  ░░██░▓██▒  ▐▌██▒░██▄▄▄▄██ ▓██▒  ▐▌██▒▒▓▓▄ ▄██▒▒▓█  ▄ 
9 ▒██░   ▓██░░ ████▓▒░░ ████▓▒░░▒████▓ ░██████▒░▒████▒ ██▓ ░▒█░   ░██░▒██░   ▓██░ ▓█   ▓██▒▒██░   ▓██░▒ ▓███▀ ░░▒████▒
10 ░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ░ ▒░▒░▒░  ▒▒▓  ▒ ░ ▒░▓  ░░░ ▒░ ░ ▒▓▒  ▒ ░   ░▓  ░ ▒░   ▒ ▒  ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░ ░▒ ▒  ░░░ ▒░ ░
11 ░ ░░   ░ ▒░  ░ ▒ ▒░   ░ ▒ ▒░  ░ ▒  ▒ ░ ░ ▒  ░ ░ ░  ░ ░▒   ░      ▒ ░░ ░░   ░ ▒░  ▒   ▒▒ ░░ ░░   ░ ▒░  ░  ▒    ░ ░  ░
12    ░   ░ ░ ░ ░ ░ ▒  ░ ░ ░ ▒   ░ ░  ░   ░ ░      ░    ░    ░ ░    ▒ ░   ░   ░ ░   ░   ▒      ░   ░ ░ ░           ░   
13          ░     ░ ░      ░ ░     ░        ░  ░   ░  ░  ░          ░           ░       ░  ░         ░ ░ ░         ░  ░
14                               ░                       ░                                             ░               
15 
16 forked from SUSHI and YUNO and Kimchi
17 
18 */
19 
20 pragma solidity ^0.6.6;
21 
22 abstract contract Context {
23     function _msgSender() internal virtual view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal virtual view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount)
52         external
53         returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender)
63         external
64         view
65         returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(
111         address indexed owner,
112         address indexed spender,
113         uint256 value
114     );
115 }
116 
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(
160         uint256 a,
161         uint256 b,
162         string memory errorMessage
163     ) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies in extcodesize, which returns 0 for contracts in
292         // construction, since the code is only stored at the end of the
293         // constructor execution.
294 
295         uint256 size;
296         // solhint-disable-next-line no-inline-assembly
297         assembly {
298             size := extcodesize(account)
299         }
300         return size > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(
321             address(this).balance >= amount,
322             "Address: insufficient balance"
323         );
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{value: amount}("");
327         require(
328             success,
329             "Address: unable to send value, recipient may have reverted"
330         );
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data)
352         internal
353         returns (bytes memory)
354     {
355         return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         return _functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value
387     ) internal returns (bytes memory) {
388         return
389             functionCallWithValue(
390                 target,
391                 data,
392                 value,
393                 "Address: low-level call with value failed"
394             );
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
399      * with `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         require(
410             address(this).balance >= value,
411             "Address: insufficient balance for call"
412         );
413         return _functionCallWithValue(target, data, value, errorMessage);
414     }
415 
416     function _functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 weiValue,
420         string memory errorMessage
421     ) private returns (bytes memory) {
422         require(isContract(target), "Address: call to non-contract");
423 
424         // solhint-disable-next-line avoid-low-level-calls
425         (bool success, bytes memory returndata) = target.call{value: weiValue}(
426             data
427         );
428         if (success) {
429             return returndata;
430         } else {
431             // Look for revert reason and bubble it up if present
432             if (returndata.length > 0) {
433                 // The easiest way to bubble the revert reason is using memory via assembly
434 
435                 // solhint-disable-next-line no-inline-assembly
436                 assembly {
437                     let returndata_size := mload(returndata)
438                     revert(add(32, returndata), returndata_size)
439                 }
440             } else {
441                 revert(errorMessage);
442             }
443         }
444     }
445 }
446 
447 /**
448  * @dev Contract module which provides a basic access control mechanism, where
449  * there is an account (an owner) that can be granted exclusive access to
450  * specific functions.
451  *
452  * By default, the owner account will be the one that deploys the contract. This
453  * can later be changed with {transferOwnership}.
454  *
455  * This module is used through inheritance. It will make available the modifier
456  * `onlyOwner`, which can be applied to your functions to restrict their use to
457  * the owner.
458  */
459 contract Ownable is Context {
460     address private _owner;
461 
462     event OwnershipTransferred(
463         address indexed previousOwner,
464         address indexed newOwner
465     );
466 
467     /**
468      * @dev Initializes the contract setting the deployer as the initial owner.
469      */
470     constructor() internal {
471         address msgSender = _msgSender();
472         _owner = msgSender;
473         emit OwnershipTransferred(address(0), msgSender);
474     }
475 
476     /**
477      * @dev Returns the address of the current owner.
478      */
479     function owner() public view returns (address) {
480         return _owner;
481     }
482 
483     /**
484      * @dev Throws if called by any account other than the owner.
485      */
486     modifier onlyOwner() {
487         require(_owner == _msgSender(), "Ownable: caller is not the owner");
488         _;
489     }
490 
491     /**
492      * @dev Leaves the contract without owner. It will not be possible to call
493      * `onlyOwner` functions anymore. Can only be called by the current owner.
494      *
495      * NOTE: Renouncing ownership will leave the contract without an owner,
496      * thereby removing any functionality that is only available to the owner.
497      */
498     function renounceOwnership() public virtual onlyOwner {
499         emit OwnershipTransferred(_owner, address(0));
500         _owner = address(0);
501     }
502 
503     /**
504      * @dev Transfers ownership of the contract to a new account (`newOwner`).
505      * Can only be called by the current owner.
506      */
507     function transferOwnership(address newOwner) public virtual onlyOwner {
508         require(
509             newOwner != address(0),
510             "Ownable: new owner is the zero address"
511         );
512         emit OwnershipTransferred(_owner, newOwner);
513         _owner = newOwner;
514     }
515 }
516 
517 /**
518  * @dev Implementation of the {IERC20} interface.
519  *
520  * This implementation is agnostic to the way tokens are created. This means
521  * that a supply mechanism has to be added in a derived contract using {_mint}.
522  * For a generic mechanism see {ERC20PresetMinterPauser}.
523  *
524  * TIP: For a detailed writeup see our guide
525  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
526  * to implement supply mechanisms].
527  *
528  * We have followed general OpenZeppelin guidelines: functions revert instead
529  * of returning `false` on failure. This behavior is nonetheless conventional
530  * and does not conflict with the expectations of ERC20 applications.
531  *
532  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
533  * This allows applications to reconstruct the allowance for all accounts just
534  * by listening to said events. Other implementations of the EIP may not emit
535  * these events, as it isn't required by the specification.
536  *
537  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
538  * functions have been added to mitigate the well-known issues around setting
539  * allowances. See {IERC20-approve}.
540  */
541 contract ERC20 is Context, IERC20 {
542     using SafeMath for uint256;
543     using Address for address;
544 
545     mapping(address => uint256) private _balances;
546 
547     mapping(address => mapping(address => uint256)) private _allowances;
548 
549     uint256 private _totalSupply;
550 
551     string private _name;
552     string private _symbol;
553     uint8 private _decimals;
554 
555     /**
556      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
557      * a default value of 18.
558      *
559      * To select a different value for {decimals}, use {_setupDecimals}.
560      *
561      * All three of these values are immutable: they can only be set once during
562      * construction.
563      */
564     constructor(string memory name, string memory symbol) public {
565         _name = name;
566         _symbol = symbol;
567         _decimals = 18;
568     }
569 
570     /**
571      * @dev Returns the name of the token.
572      */
573     function name() public view returns (string memory) {
574         return _name;
575     }
576 
577     /**
578      * @dev Returns the symbol of the token, usually a shorter version of the
579      * name.
580      */
581     function symbol() public view returns (string memory) {
582         return _symbol;
583     }
584 
585     /**
586      * @dev Returns the number of decimals used to get its user representation.
587      * For example, if `decimals` equals `2`, a balance of `505` tokens should
588      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
589      *
590      * Tokens usually opt for a value of 18, imitating the relationship between
591      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
592      * called.
593      *
594      * NOTE: This information is only used for _display_ purposes: it in
595      * no way affects any of the arithmetic of the contract, including
596      * {IERC20-balanceOf} and {IERC20-transfer}.
597      */
598     function decimals() public view returns (uint8) {
599         return _decimals;
600     }
601 
602     /**
603      * @dev See {IERC20-totalSupply}.
604      */
605     function totalSupply() public override view returns (uint256) {
606         return _totalSupply;
607     }
608 
609     /**
610      * @dev See {IERC20-balanceOf}.
611      */
612     function balanceOf(address account) public override view returns (uint256) {
613         return _balances[account];
614     }
615 
616     /**
617      * @dev See {IERC20-transfer}.
618      *
619      * Requirements:
620      *
621      * - `recipient` cannot be the zero address.
622      * - the caller must have a balance of at least `amount`.
623      */
624     function transfer(address recipient, uint256 amount)
625         public
626         virtual
627         override
628         returns (bool)
629     {
630         _transfer(_msgSender(), recipient, amount);
631         return true;
632     }
633 
634     /**
635      * @dev See {IERC20-allowance}.
636      */
637     function allowance(address owner, address spender)
638         public
639         virtual
640         override
641         view
642         returns (uint256)
643     {
644         return _allowances[owner][spender];
645     }
646 
647     /**
648      * @dev See {IERC20-approve}.
649      *
650      * Requirements:
651      *
652      * - `spender` cannot be the zero address.
653      */
654     function approve(address spender, uint256 amount)
655         public
656         virtual
657         override
658         returns (bool)
659     {
660         _approve(_msgSender(), spender, amount);
661         return true;
662     }
663 
664     /**
665      * @dev See {IERC20-transferFrom}.
666      *
667      * Emits an {Approval} event indicating the updated allowance. This is not
668      * required by the EIP. See the note at the beginning of {ERC20};
669      *
670      * Requirements:
671      * - `sender` and `recipient` cannot be the zero address.
672      * - `sender` must have a balance of at least `amount`.
673      * - the caller must have allowance for ``sender``'s tokens of at least
674      * `amount`.
675      */
676     function transferFrom(
677         address sender,
678         address recipient,
679         uint256 amount
680     ) public virtual override returns (bool) {
681         _transfer(sender, recipient, amount);
682         _approve(
683             sender,
684             _msgSender(),
685             _allowances[sender][_msgSender()].sub(
686                 amount,
687                 "ERC20: transfer amount exceeds allowance"
688             )
689         );
690         return true;
691     }
692 
693     /**
694      * @dev Atomically increases the allowance granted to `spender` by the caller.
695      *
696      * This is an alternative to {approve} that can be used as a mitigation for
697      * problems described in {IERC20-approve}.
698      *
699      * Emits an {Approval} event indicating the updated allowance.
700      *
701      * Requirements:
702      *
703      * - `spender` cannot be the zero address.
704      */
705     function increaseAllowance(address spender, uint256 addedValue)
706         public
707         virtual
708         returns (bool)
709     {
710         _approve(
711             _msgSender(),
712             spender,
713             _allowances[_msgSender()][spender].add(addedValue)
714         );
715         return true;
716     }
717 
718     /**
719      * @dev Atomically decreases the allowance granted to `spender` by the caller.
720      *
721      * This is an alternative to {approve} that can be used as a mitigation for
722      * problems described in {IERC20-approve}.
723      *
724      * Emits an {Approval} event indicating the updated allowance.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      * - `spender` must have allowance for the caller of at least
730      * `subtractedValue`.
731      */
732     function decreaseAllowance(address spender, uint256 subtractedValue)
733         public
734         virtual
735         returns (bool)
736     {
737         _approve(
738             _msgSender(),
739             spender,
740             _allowances[_msgSender()][spender].sub(
741                 subtractedValue,
742                 "ERC20: decreased allowance below zero"
743             )
744         );
745         return true;
746     }
747 
748     /**
749      * @dev Moves tokens `amount` from `sender` to `recipient`.
750      *
751      * This is internal function is equivalent to {transfer}, and can be used to
752      * e.g. implement automatic token fees, slashing mechanisms, etc.
753      *
754      * Emits a {Transfer} event.
755      *
756      * Requirements:
757      *
758      * - `sender` cannot be the zero address.
759      * - `recipient` cannot be the zero address.
760      * - `sender` must have a balance of at least `amount`.
761      */
762     function _transfer(
763         address sender,
764         address recipient,
765         uint256 amount
766     ) internal virtual {
767         require(sender != address(0), "ERC20: transfer from the zero address");
768         require(recipient != address(0), "ERC20: transfer to the zero address");
769 
770         _beforeTokenTransfer(sender, recipient, amount);
771 
772         _balances[sender] = _balances[sender].sub(
773             amount,
774             "ERC20: transfer amount exceeds balance"
775         );
776         _balances[recipient] = _balances[recipient].add(amount);
777         emit Transfer(sender, recipient, amount);
778     }
779 
780     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
781      * the total supply.
782      *
783      * Emits a {Transfer} event with `from` set to the zero address.
784      *
785      * Requirements
786      *
787      * - `to` cannot be the zero address.
788      */
789     function _mint(address account, uint256 amount) internal virtual {
790         require(account != address(0), "ERC20: mint to the zero address");
791 
792         _beforeTokenTransfer(address(0), account, amount);
793 
794         _totalSupply = _totalSupply.add(amount);
795         _balances[account] = _balances[account].add(amount);
796         emit Transfer(address(0), account, amount);
797     }
798 
799     /**
800      * @dev Destroys `amount` tokens from `account`, reducing the
801      * total supply.
802      *
803      * Emits a {Transfer} event with `to` set to the zero address.
804      *
805      * Requirements
806      *
807      * - `account` cannot be the zero address.
808      * - `account` must have at least `amount` tokens.
809      */
810     function _burn(address account, uint256 amount) internal virtual {
811         require(account != address(0), "ERC20: burn from the zero address");
812 
813         _beforeTokenTransfer(account, address(0), amount);
814 
815         _balances[account] = _balances[account].sub(
816             amount,
817             "ERC20: burn amount exceeds balance"
818         );
819         _totalSupply = _totalSupply.sub(amount);
820         emit Transfer(account, address(0), amount);
821     }
822 
823     /**
824      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
825      *
826      * This internal function is equivalent to `approve`, and can be used to
827      * e.g. set automatic allowances for certain subsystems, etc.
828      *
829      * Emits an {Approval} event.
830      *
831      * Requirements:
832      *
833      * - `owner` cannot be the zero address.
834      * - `spender` cannot be the zero address.
835      */
836     function _approve(
837         address owner,
838         address spender,
839         uint256 amount
840     ) internal virtual {
841         require(owner != address(0), "ERC20: approve from the zero address");
842         require(spender != address(0), "ERC20: approve to the zero address");
843 
844         _allowances[owner][spender] = amount;
845         emit Approval(owner, spender, amount);
846     }
847 
848     /**
849      * @dev Sets {decimals} to a value other than the default one of 18.
850      *
851      * WARNING: This function should only be called from the constructor. Most
852      * applications that interact with token contracts will not expect
853      * {decimals} to ever change, and may work incorrectly if it does.
854      */
855     function _setupDecimals(uint8 decimals_) internal {
856         _decimals = decimals_;
857     }
858 
859     /**
860      * @dev Hook that is called before any transfer of tokens. This includes
861      * minting and burning.
862      *
863      * Calling conditions:
864      *
865      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
866      * will be to transferred to `to`.
867      * - when `from` is zero, `amount` tokens will be minted for `to`.
868      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
869      * - `from` and `to` are never both zero.
870      *
871      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
872      */
873     function _beforeTokenTransfer(
874         address from,
875         address to,
876         uint256 amount
877     ) internal virtual {}
878 }
879 
880 contract NoodleToken is ERC20("NOODLE.Finance", "NOODLE"), Ownable {
881     function mint(address _to, uint256 _amount) public onlyOwner {
882         _mint(_to, _amount);
883     }
884 }