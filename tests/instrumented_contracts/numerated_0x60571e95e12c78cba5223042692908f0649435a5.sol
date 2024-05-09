1 pragma solidity 0.5.13;  /*
2 
3 
4 ___________________________________________________________________
5   _      _                                        ______           
6   |  |  /          /                                /              
7 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
8   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
9 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
10 
11 
12 
13   _____  _                          _____    ______      _____  __  __ ______ _____   _____    _______ ____  _  ________ _   _ 
14  |  __ \| |        /\        /\    / ____|  |  ____/\   |  __ \|  \/  |  ____|  __ \ / ____|  |__   __/ __ \| |/ /  ____| \ | |
15  | |__) | |       /  \      /  \  | (___    | |__ /  \  | |__) | \  / | |__  | |__) | (___       | | | |  | | ' /| |__  |  \| |
16  |  ___/| |      / /\ \    / /\ \  \___ \   |  __/ /\ \ |  _  /| |\/| |  __| |  _  / \___ \      | | | |  | |  < |  __| | . ` |
17  | |    | |____ / ____ \  / ____ \ ____) |  | | / ____ \| | \ \| |  | | |____| | \ \ ____) |     | | | |__| | . \| |____| |\  |
18  |_|    |______/_/    \_\/_/    \_\_____/   |_|/_/    \_\_|  \_\_|  |_|______|_|  \_\_____/      |_|  \____/|_|\_\______|_| \_|
19                                                                                                                                
20                                                                                                                                
21 
22 
23 === 'PLAAS' Token contract with following features ===
24     => ERC20 Compliance
25     => ERC777 Compliance
26     => Higher degree of control by owner - safeguard functionality
27     => SafeMath implementation 
28     => Burnable and minting 
29     => user whitelisting 
30 
31 
32 
33 ======================= Quick Stats ===================
34     => Name        : PLAAS FARMERS TOKEN
35     => Symbol      : PLAAS
36     => Total supply: 50,000,000 (50 Million)
37     => Decimals    : 18
38 
39 
40 
41 
42 -------------------------------------------------------------------
43  Copyright (c) 2019 onwards PLAAS Inc. ( https://plaas.io )
44  Contract designed with ❤ by EtherAuthority ( https://EtherAuthority.io )
45 -------------------------------------------------------------------
46 */ 
47 
48 
49 
50 
51 
52 //*******************************************************************//
53 //------------------------ SafeMath Library -------------------------//
54 //*******************************************************************//
55 
56 
57 library SafeMath {
58     /**
59      * @dev Returns the addition of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `+` operator.
63      *
64      * Requirements:
65      * - Addition cannot overflow.
66      */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a, "SafeMath: addition overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the subtraction of two unsigned integers, reverting on
76      * overflow (when the result is negative).
77      *
78      * Counterpart to Solidity's `-` operator.
79      *
80      * Requirements:
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      * - Subtraction cannot overflow.
95      *
96      * _Available since v2.4.0._
97      */
98     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      * - Multiplication cannot overflow.
113      */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b, "SafeMath: multiplication overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      *
154      * _Available since v2.4.0._
155      */
156     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         // Solidity only automatically asserts when dividing by 0
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         return mod(a, b, "SafeMath: modulo by zero");
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * Reverts with custom message when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      *
191      * _Available since v2.4.0._
192      */
193     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b != 0, errorMessage);
195         return a % b;
196     }
197 }
198 
199 
200 
201 
202 //*******************************************************************//
203 //------------------------ ERC777 Interfaces -------------------------//
204 //*******************************************************************//
205 
206 
207 interface IERC1820Registry {
208    
209     /**
210      * @dev Sets the `implementer` contract as `account`'s implementer for
211      * `interfaceHash`.
212      *
213      * `account` being the zero address is an alias for the caller's address.
214      * The zero address can also be used in `implementer` to remove an old one.
215      *
216      * See {interfaceHash} to learn how these are created.
217      *
218      * Emits an {InterfaceImplementerSet} event.
219      *
220      * Requirements:
221      *
222      * - the caller must be the current manager for `account`.
223      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
224      * end in 28 zeroes).
225      * - `implementer` must implement {IERC1820Implementer} and return true when
226      * queried for support, unless `implementer` is the caller. See
227      * {IERC1820Implementer-canImplementInterfaceForAddress}.
228      */
229     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
230 
231     /**
232      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
233      * implementer is registered, returns the zero address.
234      *
235      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
236      * zeroes), `account` will be queried for support of it.
237      *
238      * `account` being the zero address is an alias for the caller's address.
239      */
240     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
241 
242    
243 }
244 
245 
246 interface IERC777Sender {
247     /**
248      * @dev Called by an {IERC777} token contract whenever a registered holder's
249      * (`from`) tokens are about to be moved or destroyed. The type of operation
250      * is conveyed by `to` being the zero address or not.
251      *
252      * This call occurs _before_ the token contract's state is updated, so
253      * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
254      *
255      * This function may revert to prevent the operation from being executed.
256      */
257     function tokensToSend(
258         address operator,
259         address from,
260         address to,
261         uint256 amount,
262         bytes calldata userData,
263         bytes calldata operatorData
264     ) external;
265 }
266 
267 
268 
269 interface IERC777Recipient {
270     /**
271      * @dev Called by an {IERC777} token contract whenever tokens are being
272      * moved or created into a registered account (`to`). The type of operation
273      * is conveyed by `from` being the zero address or not.
274      *
275      * This call occurs _after_ the token contract's state is updated, so
276      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
277      *
278      * This function may revert to prevent the operation from being executed.
279      */
280     function tokensReceived(
281         address operator,
282         address from,
283         address to,
284         uint256 amount,
285         bytes calldata userData,
286         bytes calldata operatorData
287     ) external;
288 }
289 
290 
291 /*
292  * @dev Provides information about the current execution context, including the
293  * sender of the transaction and its data. While these are generally available
294  * via msg.sender and msg.data, they should not be accessed in such a direct
295  * manner, since when dealing with GSN meta-transactions the account sending and
296  * paying for execution may not be the actual sender (as far as an application
297  * is concerned).
298  *
299  * This contract is only required for intermediate, library-like contracts.
300  */
301 contract Context {
302     // Empty internal constructor, to prevent people from mistakenly deploying
303     // an instance of this contract, which should be used via inheritance.
304     constructor () internal { }
305     // solhint-disable-previous-line no-empty-blocks
306 
307     function _msgSender() internal view returns (address payable) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view returns (bytes memory) {
312         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
313         return msg.data;
314     }
315 }
316 
317 
318 
319 
320 //*******************************************************************//
321 //------------------ Contract to Manage Ownership -------------------//
322 //*******************************************************************//
323     
324 contract owned {
325     address payable public owner;
326     address payable internal newOwner;
327 
328     event OwnershipTransferred(address indexed _from, address indexed _to);
329 
330     constructor() public {
331         owner = msg.sender;
332     }
333 
334     modifier onlyOwner {
335         require(msg.sender == owner);
336         _;
337     }
338 
339     function transferOwnership(address payable _newOwner) external onlyOwner {
340         newOwner = _newOwner;
341     }
342 
343     //this flow is to prevent transferring ownership to wrong wallet by mistake
344     function acceptOwnership() external {
345         require(msg.sender == newOwner);
346         emit OwnershipTransferred(owner, newOwner);
347         owner = newOwner;
348         newOwner = address(0);
349     }
350 }
351  
352 
353     
354 //****************************************************************************//
355 //---------------------        MAIN CODE STARTS HERE     ---------------------//
356 //****************************************************************************//
357 
358 
359 
360 
361 /**
362  * @dev Implementation of the {IERC777} interface.
363  *
364  * This implementation is agnostic to the way tokens are created. This means
365  * that a supply mechanism has to be added in a derived contract using {_mint}.
366  *
367  * Support for ERC20 is included in this contract, as specified by the EIP: both
368  * the ERC777 and ERC20 interfaces can be safely used when interacting with it.
369  * Both {IERC777-Sent} and {IERC20-Transfer} events are emitted on token
370  * movements.
371  *
372  * Additionally, the {IERC777-granularity} value is hard-coded to `1`, meaning that there
373  * are no special restrictions in the amount of tokens that created, moved, or
374  * destroyed. This makes integration with ERC20 applications seamless.
375  */
376 contract PLAAS_FARMERS_TOKEN is owned, Context {
377     
378     using SafeMath for uint256;
379     bool public safeguard;  //putting safeguard on will halt all non-owner functions
380     
381     
382     //--- Token variables ---------------//
383     string public constant name = "PLAAS FARMERS TOKEN";
384     string public constant symbol = "PLAAS";
385     uint256 public constant decimals = 18;                          // for erc777, this MUST be 18
386     uint256 public constant maxSupply = 50000000 * (10**decimals);  // this is constant and will never change;
387     uint256 public totalSupply = maxSupply;                         // this can change as people burn their tokens
388     
389     
390     //---  EVENTS -----------------------//
391     event Transfer(address indexed from, address indexed to, uint256 value);
392 
393     event Approval(address indexed owner, address indexed spender, uint256 value);
394     
395     event Sent(address indexed operator, address indexed from, address indexed to, uint256 amount, bytes data, bytes operatorData );
396 
397     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
398 
399     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
400 
401     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
402 
403     event RevokedOperator(address indexed operator, address indexed tokenHolder);
404     
405     event FrozenAccounts(address target, bool frozen);
406     
407 
408     IERC1820Registry constant private ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
409 
410     
411     mapping(address => uint256) private _balances;
412 
413     
414     
415 
416     // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
417     // See https://github.com/ethereum/solidity/issues/4024.
418 
419     // keccak256("ERC777TokensSender")
420     bytes32 constant private TOKENS_SENDER_INTERFACE_HASH =
421         0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
422 
423     // keccak256("ERC777TokensRecipient")
424     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH =
425         0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
426 
427     // This isn't ever read from - it's only used to respond to the defaultOperators query.
428     address[] private _defaultOperatorsArray;
429 
430     // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
431     mapping(address => bool) private _defaultOperators;
432 
433     // For each account, a mapping of its operators and revoked default operators.
434     mapping(address => mapping(address => bool)) private _operators;
435     mapping(address => mapping(address => bool)) private _revokedDefaultOperators;
436 
437     // ERC20-allowances
438     mapping (address => mapping (address => uint256)) private _allowances;
439     
440     //User wallet freezing/blacklisting
441     mapping (address => bool) public frozenAccount;
442 
443     /**
444      * @dev `defaultOperators` may be an empty array.
445      */
446     constructor(
447 
448     ) public {
449         
450         //default operators is contract creator
451         _defaultOperatorsArray.push (msg.sender);
452         _defaultOperators[msg.sender] = true;
453         
454         
455         //issuing initial supply
456         _balances[msg.sender] = maxSupply;
457         emit Transfer(address(0), msg.sender, maxSupply);
458        
459 
460         // register interfaces
461         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
462         ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
463 
464     }
465 
466  
467 
468     /**
469      * @dev See {IERC777-granularity}.
470      *
471      * This implementation always returns `1`.
472      */
473     function granularity() external pure returns (uint256) {
474         return 1;
475     }
476 
477 
478 
479     /**
480      * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
481      */
482     function balanceOf(address tokenHolder) external view returns (uint256) {
483         return _balances[tokenHolder];
484     }
485 
486     /**
487      * @dev See {IERC777-send}.
488      *
489      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
490      */
491     function send(address recipient, uint256 amount, bytes calldata data) external {
492         _send(_msgSender(), _msgSender(), recipient, amount, data, "", true);
493     }
494 
495     /**
496      * @dev See {IERC20-transfer}.
497      *
498      * Unlike `send`, `recipient` is _not_ required to implement the {IERC777Recipient}
499      * interface if it is a contract.
500      *
501      * Also emits a {Sent} event.
502      */
503     function transfer(address recipient, uint256 amount) external returns (bool) {
504         require(recipient != address(0), "ERC777: transfer to the zero address");
505 
506         address from = _msgSender();
507 
508         _callTokensToSend(from, from, recipient, amount, "", "");
509 
510         _move(from, from, recipient, amount, "", "");
511 
512         _callTokensReceived(from, from, recipient, amount, "", "", false);
513 
514         return true;
515     }
516 
517     /**
518      * @dev See {IERC777-burn}.
519      *
520      * Also emits a {IERC20-Transfer} event for ERC20 compatibility.
521      */
522     function burn(uint256 amount, bytes calldata data) external {
523         _burn(_msgSender(), _msgSender(), amount, data, "");
524     }
525 
526     /**
527      * @dev See {IERC777-isOperatorFor}.
528      */
529     function isOperatorFor(
530         address operator,
531         address tokenHolder
532     ) public view returns (bool) {
533         return operator == tokenHolder ||
534             (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
535             _operators[tokenHolder][operator];
536     }
537 
538     /**
539      * @dev See {IERC777-authorizeOperator}.
540      */
541     function authorizeOperator(address operator) external {
542         require(_msgSender() != operator, "ERC777: authorizing self as operator");
543 
544         if (_defaultOperators[operator]) {
545             delete _revokedDefaultOperators[_msgSender()][operator];
546         } else {
547             _operators[_msgSender()][operator] = true;
548         }
549 
550         emit AuthorizedOperator(operator, _msgSender());
551     }
552 
553     /**
554      * @dev See {IERC777-revokeOperator}.
555      */
556     function revokeOperator(address operator) external {
557         require(operator != _msgSender(), "ERC777: revoking self as operator");
558 
559         if (_defaultOperators[operator]) {
560             _revokedDefaultOperators[_msgSender()][operator] = true;
561         } else {
562             delete _operators[_msgSender()][operator];
563         }
564 
565         emit RevokedOperator(operator, _msgSender());
566     }
567 
568     /**
569      * @dev See {IERC777-defaultOperators}.
570      */
571     function defaultOperators() external view returns (address[] memory) {
572         return _defaultOperatorsArray;
573     }
574 
575     /**
576      * @dev See {IERC777-operatorSend}.
577      *
578      * Emits {Sent} and {IERC20-Transfer} events.
579      */
580     function operatorSend(
581         address sender,
582         address recipient,
583         uint256 amount,
584         bytes calldata data,
585         bytes calldata operatorData
586     )
587     external
588     {
589         require(isOperatorFor(_msgSender(), sender), "ERC777: caller is not an operator for holder");
590         _send(_msgSender(), sender, recipient, amount, data, operatorData, true);
591     }
592 
593     /**
594      * @dev See {IERC777-operatorBurn}.
595      *
596      * Emits {Burned} and {IERC20-Transfer} events.
597      */
598     function operatorBurn(address account, uint256 amount, bytes calldata data, bytes calldata operatorData) external {
599         require(isOperatorFor(_msgSender(), account), "ERC777: caller is not an operator for holder");
600         _burn(_msgSender(), account, amount, data, operatorData);
601     }
602 
603     /**
604      * @dev See {IERC20-allowance}.
605      *
606      * Note that operator and allowance concepts are orthogonal: operators may
607      * not have allowance, and accounts with allowance may not be operators
608      * themselves.
609      */
610     function allowance(address holder, address spender) external view returns (uint256) {
611         return _allowances[holder][spender];
612     }
613 
614     /**
615      * @dev See {IERC20-approve}.
616      *
617      * Note that accounts cannot have allowance issued by their operators.
618      */
619     function approve(address spender, uint256 value) external returns (bool) {
620         address holder = _msgSender();
621         _approve(holder, spender, value);
622         return true;
623     }
624 
625    /**
626     * @dev See {IERC20-transferFrom}.
627     *
628     * Note that operator and allowance concepts are orthogonal: operators cannot
629     * call `transferFrom` (unless they have allowance), and accounts with
630     * allowance cannot call `operatorSend` (unless they are operators).
631     *
632     * Emits {Sent}, {IERC20-Transfer} and {IERC20-Approval} events.
633     */
634     function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
635         require(recipient != address(0), "ERC777: transfer to the zero address");
636         require(holder != address(0), "ERC777: transfer from the zero address");
637 
638         address spender = _msgSender();
639 
640         _callTokensToSend(spender, holder, recipient, amount, "", "");
641 
642         _move(spender, holder, recipient, amount, "", "");
643         _approve(holder, spender, _allowances[holder][spender].sub(amount, "ERC777: transfer amount exceeds allowance"));
644 
645         _callTokensReceived(spender, holder, recipient, amount, "", "", false);
646 
647         return true;
648     }
649 
650     /**
651      * @dev Creates `amount` tokens and assigns them to `account`, increasing
652      * the total supply.
653      *
654      * If a send hook is registered for `account`, the corresponding function
655      * will be called with `operator`, `data` and `operatorData`.
656      *
657      * See {IERC777Sender} and {IERC777Recipient}.
658      *
659      * Emits {Minted} and {IERC20-Transfer} events.
660      *
661      * Requirements
662      *
663      * - `account` cannot be the zero address.
664      * - if `account` is a contract, it must implement the {IERC777Recipient}
665      * interface.
666      */
667     function _mint(
668         address operator,
669         address account,
670         uint256 amount,
671         bytes memory userData,
672         bytes memory operatorData
673     )
674     internal
675     {
676         require(account != address(0), "ERC777: mint to the zero address");
677         require(totalSupply.add(amount) <= maxSupply, 'Exceeds maxSupply');
678 
679         // Update state variables
680         totalSupply = totalSupply.add(amount);
681         _balances[account] = _balances[account].add(amount);
682 
683         _callTokensReceived(operator, address(0), account, amount, userData, operatorData, true);
684 
685         emit Minted(operator, account, amount, userData, operatorData);
686         emit Transfer(address(0), account, amount);
687     }
688 
689     /**
690      * @dev Send tokens
691      * @param operator address operator requesting the transfer
692      * @param from address token holder address
693      * @param to address recipient address
694      * @param amount uint256 amount of tokens to transfer
695      * @param userData bytes extra information provided by the token holder (if any)
696      * @param operatorData bytes extra information provided by the operator (if any)
697      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
698      */
699     function _send(
700         address operator,
701         address from,
702         address to,
703         uint256 amount,
704         bytes memory userData,
705         bytes memory operatorData,
706         bool requireReceptionAck
707     )
708         private
709     {
710         require(from != address(0), "ERC777: send from the zero address");
711         require(to != address(0), "ERC777: send to the zero address");
712 
713         _callTokensToSend(operator, from, to, amount, userData, operatorData);
714 
715         _move(operator, from, to, amount, userData, operatorData);
716 
717         _callTokensReceived(operator, from, to, amount, userData, operatorData, requireReceptionAck);
718     }
719 
720     /**
721      * @dev Burn tokens
722      * @param operator address operator requesting the operation
723      * @param from address token holder address
724      * @param amount uint256 amount of tokens to burn
725      * @param data bytes extra information provided by the token holder
726      * @param operatorData bytes extra information provided by the operator (if any)
727      */
728     function _burn(
729         address operator,
730         address from,
731         uint256 amount,
732         bytes memory data,
733         bytes memory operatorData
734     )
735         internal
736     {
737         require(from != address(0), "ERC777: burn from the zero address");
738         require(!frozenAccount[from], 'blacklisted account');              // Check if sender is frozen
739         require(!safeguard, 'SafeGuard is on');     // SafeGuard checking
740 
741         _callTokensToSend(operator, from, address(0), amount, data, operatorData);
742 
743         // Update state variables
744         _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
745         totalSupply = totalSupply.sub(amount);
746 
747         emit Burned(operator, from, amount, data, operatorData);
748         emit Transfer(from, address(0), amount);
749     }
750 
751     function _move(
752         address operator,
753         address from,
754         address to,
755         uint256 amount,
756         bytes memory userData,
757         bytes memory operatorData
758     )
759         private
760     {
761         require(!frozenAccount[from], 'blacklisted account');                     // Check if sender is frozen
762         require(!frozenAccount[to], 'blacklisted account');                       // Check if recipient is frozen
763         require(!safeguard, 'SafeGuard is on');     // SafeGuard checking
764         
765         _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
766         _balances[to] = _balances[to].add(amount);
767 
768         emit Sent(operator, from, to, amount, userData, operatorData);
769         emit Transfer(from, to, amount);
770     }
771 
772     function _approve(address holder, address spender, uint256 value) private {
773         // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
774         // currently unnecessary.
775         //require(holder != address(0), "ERC777: approve from the zero address");
776         require(spender != address(0), "ERC777: approve to the zero address");
777         require(!safeguard, 'SafeGuard is on');     // SafeGuard checking
778 
779         _allowances[holder][spender] = value;
780         emit Approval(holder, spender, value);
781     }
782     
783     
784     /** 
785         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
786         * @param target Address to be frozen
787         * @param freeze either to freeze it or not
788         */
789     function freezeAccount(address target, bool freeze) onlyOwner external {
790         frozenAccount[target] = freeze;
791         emit  FrozenAccounts(target, freeze);
792     }
793     
794     /**
795         * Change safeguard status on or off
796         *
797         * When safeguard is true, then all the non-owner functions will stop working.
798         * When safeguard is false, then all the functions will resume working back again!
799         */
800     function changeSafeguardStatus() onlyOwner external{
801         if (safeguard == false){
802             safeguard = true;
803         }
804         else{
805             safeguard = false;    
806         }
807     }
808 
809     /**
810      * @dev Call from.tokensToSend() if the interface is registered
811      * @param operator address operator requesting the transfer
812      * @param from address token holder address
813      * @param to address recipient address
814      * @param amount uint256 amount of tokens to transfer
815      * @param userData bytes extra information provided by the token holder (if any)
816      * @param operatorData bytes extra information provided by the operator (if any)
817      */
818     function _callTokensToSend(
819         address operator,
820         address from,
821         address to,
822         uint256 amount,
823         bytes memory userData,
824         bytes memory operatorData
825     )
826         private
827     {
828         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
829         if (implementer != address(0)) {
830             IERC777Sender(implementer).tokensToSend(operator, from, to, amount, userData, operatorData);
831         }
832     }
833 
834     /**
835      * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
836      * tokensReceived() was not registered for the recipient
837      * @param operator address operator requesting the transfer
838      * @param from address token holder address
839      * @param to address recipient address
840      * @param amount uint256 amount of tokens to transfer
841      * @param userData bytes extra information provided by the token holder (if any)
842      * @param operatorData bytes extra information provided by the operator (if any)
843      * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
844      */
845     function _callTokensReceived(
846         address operator,
847         address from,
848         address to,
849         uint256 amount,
850         bytes memory userData,
851         bytes memory operatorData,
852         bool requireReceptionAck
853     )
854         private
855     {
856         address implementer = ERC1820_REGISTRY.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
857         if (implementer != address(0)) {
858             IERC777Recipient(implementer).tokensReceived(operator, from, to, amount, userData, operatorData);
859         } else if (requireReceptionAck) {
860             require(msg.sender == tx.origin, "ERC777: token recipient contract has no implementer for ERC777TokensRecipient");
861         }
862     }
863     
864     
865 }