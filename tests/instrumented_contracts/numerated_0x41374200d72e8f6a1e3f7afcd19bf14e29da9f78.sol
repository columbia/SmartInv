1 pragma solidity ^0.5.2;
2 
3 // File: openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
45 
46 contract PauserRole {
47     using Roles for Roles.Role;
48 
49     event PauserAdded(address indexed account);
50     event PauserRemoved(address indexed account);
51 
52     Roles.Role private _pausers;
53 
54     constructor () internal {
55         _addPauser(msg.sender);
56     }
57 
58     modifier onlyPauser() {
59         require(isPauser(msg.sender));
60         _;
61     }
62 
63     function isPauser(address account) public view returns (bool) {
64         return _pausers.has(account);
65     }
66 
67     function addPauser(address account) public onlyPauser {
68         _addPauser(account);
69     }
70 
71     function renouncePauser() public {
72         _removePauser(msg.sender);
73     }
74 
75     function _addPauser(address account) internal {
76         _pausers.add(account);
77         emit PauserAdded(account);
78     }
79 
80     function _removePauser(address account) internal {
81         _pausers.remove(account);
82         emit PauserRemoved(account);
83     }
84 }
85 
86 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
87 
88 /**
89  * @title Pausable
90  * @dev Base contract which allows children to implement an emergency stop mechanism.
91  */
92 contract Pausable is PauserRole {
93     event Paused(address account);
94     event Unpaused(address account);
95 
96     bool private _paused;
97 
98     constructor () internal {
99         _paused = false;
100     }
101 
102     /**
103      * @return true if the contract is paused, false otherwise.
104      */
105     function paused() public view returns (bool) {
106         return _paused;
107     }
108 
109     /**
110      * @dev Modifier to make a function callable only when the contract is not paused.
111      */
112     modifier whenNotPaused() {
113         require(!_paused);
114         _;
115     }
116 
117     /**
118      * @dev Modifier to make a function callable only when the contract is paused.
119      */
120     modifier whenPaused() {
121         require(_paused);
122         _;
123     }
124 
125     /**
126      * @dev called by the owner to pause, triggers stopped state
127      */
128     function pause() public onlyPauser whenNotPaused {
129         _paused = true;
130         emit Paused(msg.sender);
131     }
132 
133     /**
134      * @dev called by the owner to unpause, returns to normal state
135      */
136     function unpause() public onlyPauser whenPaused {
137         _paused = false;
138         emit Unpaused(msg.sender);
139     }
140 }
141 
142 // File: contracts/FoundationOwnable.sol
143 
144 contract FoundationOwnable is Pausable {
145 
146 	address public foundation;
147 
148 	event FoundationTransferred(address oldAddr, address newAddr);
149 
150 	constructor() public {
151 		foundation = msg.sender;
152 	}
153 
154 	modifier onlyFoundation() {
155 		require(msg.sender == foundation, 'foundation required');
156 		_;
157 	}
158 
159 	function transferFoundation(address f) public onlyFoundation {
160 		require(f != address(0), 'empty address');
161 		emit FoundationTransferred(foundation, f);
162 		_removePauser(foundation);
163 		_addPauser(f);
164 		foundation = f;
165 	}
166 }
167 
168 // File: contracts/TeleportOwnable.sol
169 
170 contract TeleportOwnable {
171 
172 	address public teleport;
173 
174 	event TeleportTransferred(address oldAddr, address newAddr);
175 
176 	constructor() public {
177 		teleport = msg.sender;
178 	}
179 
180 	modifier onlyTeleport() {
181 		require(msg.sender == teleport, 'caller not teleport');
182 		_;
183 	}
184 
185 	function transferTeleport(address f) public onlyTeleport {
186 		require(f != address(0));
187 		emit TeleportTransferred(teleport, f);
188 		teleport = f;
189 	}
190 }
191 
192 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 interface IERC20 {
199     function transfer(address to, uint256 value) external returns (bool);
200 
201     function approve(address spender, uint256 value) external returns (bool);
202 
203     function transferFrom(address from, address to, uint256 value) external returns (bool);
204 
205     function totalSupply() external view returns (uint256);
206 
207     function balanceOf(address who) external view returns (uint256);
208 
209     function allowance(address owner, address spender) external view returns (uint256);
210 
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     event Approval(address indexed owner, address indexed spender, uint256 value);
214 }
215 
216 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
217 
218 /**
219  * @title SafeMath
220  * @dev Unsigned math operations with safety checks that revert on error
221  */
222 library SafeMath {
223     /**
224     * @dev Multiplies two unsigned integers, reverts on overflow.
225     */
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
228         // benefit is lost if 'b' is also tested.
229         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
230         if (a == 0) {
231             return 0;
232         }
233 
234         uint256 c = a * b;
235         require(c / a == b);
236 
237         return c;
238     }
239 
240     /**
241     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
242     */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         // Solidity only automatically asserts when dividing by 0
245         require(b > 0);
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248 
249         return c;
250     }
251 
252     /**
253     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
254     */
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b <= a);
257         uint256 c = a - b;
258 
259         return c;
260     }
261 
262     /**
263     * @dev Adds two unsigned integers, reverts on overflow.
264     */
265     function add(uint256 a, uint256 b) internal pure returns (uint256) {
266         uint256 c = a + b;
267         require(c >= a);
268 
269         return c;
270     }
271 
272     /**
273     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
274     * reverts when dividing by zero.
275     */
276     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
277         require(b != 0);
278         return a % b;
279     }
280 }
281 
282 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
283 
284 /**
285  * @title Standard ERC20 token
286  *
287  * @dev Implementation of the basic standard token.
288  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
289  * Originally based on code by FirstBlood:
290  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
291  *
292  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
293  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
294  * compliant implementations may not do it.
295  */
296 contract ERC20 is IERC20 {
297     using SafeMath for uint256;
298 
299     mapping (address => uint256) private _balances;
300 
301     mapping (address => mapping (address => uint256)) private _allowed;
302 
303     uint256 private _totalSupply;
304 
305     /**
306     * @dev Total number of tokens in existence
307     */
308     function totalSupply() public view returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313     * @dev Gets the balance of the specified address.
314     * @param owner The address to query the balance of.
315     * @return An uint256 representing the amount owned by the passed address.
316     */
317     function balanceOf(address owner) public view returns (uint256) {
318         return _balances[owner];
319     }
320 
321     /**
322      * @dev Function to check the amount of tokens that an owner allowed to a spender.
323      * @param owner address The address which owns the funds.
324      * @param spender address The address which will spend the funds.
325      * @return A uint256 specifying the amount of tokens still available for the spender.
326      */
327     function allowance(address owner, address spender) public view returns (uint256) {
328         return _allowed[owner][spender];
329     }
330 
331     /**
332     * @dev Transfer token for a specified address
333     * @param to The address to transfer to.
334     * @param value The amount to be transferred.
335     */
336     function transfer(address to, uint256 value) public returns (bool) {
337         _transfer(msg.sender, to, value);
338         return true;
339     }
340 
341     /**
342      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
343      * Beware that changing an allowance with this method brings the risk that someone may use both the old
344      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
345      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      * @param spender The address which will spend the funds.
348      * @param value The amount of tokens to be spent.
349      */
350     function approve(address spender, uint256 value) public returns (bool) {
351         require(spender != address(0));
352 
353         _allowed[msg.sender][spender] = value;
354         emit Approval(msg.sender, spender, value);
355         return true;
356     }
357 
358     /**
359      * @dev Transfer tokens from one address to another.
360      * Note that while this function emits an Approval event, this is not required as per the specification,
361      * and other compliant implementations may not emit the event.
362      * @param from address The address which you want to send tokens from
363      * @param to address The address which you want to transfer to
364      * @param value uint256 the amount of tokens to be transferred
365      */
366     function transferFrom(address from, address to, uint256 value) public returns (bool) {
367         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
368         _transfer(from, to, value);
369         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
370         return true;
371     }
372 
373     /**
374      * @dev Increase the amount of tokens that an owner allowed to a spender.
375      * approve should be called when allowed_[_spender] == 0. To increment
376      * allowed value is better to use this function to avoid 2 calls (and wait until
377      * the first transaction is mined)
378      * From MonolithDAO Token.sol
379      * Emits an Approval event.
380      * @param spender The address which will spend the funds.
381      * @param addedValue The amount of tokens to increase the allowance by.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
384         require(spender != address(0));
385 
386         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
387         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
388         return true;
389     }
390 
391     /**
392      * @dev Decrease the amount of tokens that an owner allowed to a spender.
393      * approve should be called when allowed_[_spender] == 0. To decrement
394      * allowed value is better to use this function to avoid 2 calls (and wait until
395      * the first transaction is mined)
396      * From MonolithDAO Token.sol
397      * Emits an Approval event.
398      * @param spender The address which will spend the funds.
399      * @param subtractedValue The amount of tokens to decrease the allowance by.
400      */
401     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
402         require(spender != address(0));
403 
404         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
405         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
406         return true;
407     }
408 
409     /**
410     * @dev Transfer token for a specified addresses
411     * @param from The address to transfer from.
412     * @param to The address to transfer to.
413     * @param value The amount to be transferred.
414     */
415     function _transfer(address from, address to, uint256 value) internal {
416         require(to != address(0));
417 
418         _balances[from] = _balances[from].sub(value);
419         _balances[to] = _balances[to].add(value);
420         emit Transfer(from, to, value);
421     }
422 
423     /**
424      * @dev Internal function that mints an amount of the token and assigns it to
425      * an account. This encapsulates the modification of balances such that the
426      * proper events are emitted.
427      * @param account The account that will receive the created tokens.
428      * @param value The amount that will be created.
429      */
430     function _mint(address account, uint256 value) internal {
431         require(account != address(0));
432 
433         _totalSupply = _totalSupply.add(value);
434         _balances[account] = _balances[account].add(value);
435         emit Transfer(address(0), account, value);
436     }
437 
438     /**
439      * @dev Internal function that burns an amount of the token of a given
440      * account.
441      * @param account The account whose tokens will be burnt.
442      * @param value The amount that will be burnt.
443      */
444     function _burn(address account, uint256 value) internal {
445         require(account != address(0));
446 
447         _totalSupply = _totalSupply.sub(value);
448         _balances[account] = _balances[account].sub(value);
449         emit Transfer(account, address(0), value);
450     }
451 
452     /**
453      * @dev Internal function that burns an amount of the token of a given
454      * account, deducting from the sender's allowance for said account. Uses the
455      * internal burn function.
456      * Emits an Approval event (reflecting the reduced allowance).
457      * @param account The account whose tokens will be burnt.
458      * @param value The amount that will be burnt.
459      */
460     function _burnFrom(address account, uint256 value) internal {
461         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
462         _burn(account, value);
463         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
464     }
465 }
466 
467 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
468 
469 /**
470  * @title ERC20Detailed token
471  * @dev The decimals are only for visualization purposes.
472  * All the operations are done using the smallest and indivisible token unit,
473  * just as on Ethereum all the operations are done in wei.
474  */
475 contract ERC20Detailed is IERC20 {
476     string private _name;
477     string private _symbol;
478     uint8 private _decimals;
479 
480     constructor (string memory name, string memory symbol, uint8 decimals) public {
481         _name = name;
482         _symbol = symbol;
483         _decimals = decimals;
484     }
485 
486     /**
487      * @return the name of the token.
488      */
489     function name() public view returns (string memory) {
490         return _name;
491     }
492 
493     /**
494      * @return the symbol of the token.
495      */
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     /**
501      * @return the number of decimals of the token.
502      */
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 }
507 
508 // File: contracts/PortedToken.sol
509 
510 contract PortedToken is TeleportOwnable, ERC20, ERC20Detailed{
511 
512 	constructor(string memory name, string memory symbol, uint8 decimals)
513 		public ERC20Detailed(name, symbol, decimals) {}
514 
515 	function mint(address to, uint256 value) public onlyTeleport {
516 		super._mint(to, value);
517 	}
518 
519 	function burn(address from, uint256 value) public onlyTeleport {
520 		super._burn(from, value);
521 	}
522 }
523 
524 // File: contracts/Port.sol
525 
526 // Port is a contract that sends and recieves tokens to implement token
527 // teleportation between chains.
528 //
529 // Naming convention:
530 // - token: "main" is the original token and "cloned" is the ported one on
531 //          this/another chain.
532 // - address: "addr" is the address on this chain and "alt" is the one on
533 //            another chain.
534 contract Port is FoundationOwnable {
535 	// Library
536 	using SafeMath for uint256;
537 
538 	// States
539 
540 	// Beneficiary address is the address that the remaining tokens will be
541 	// transferred to for selfdestruct.
542 	address payable public beneficiary;
543 
544 	// registeredMainTokens stores the tokens that are ported on this chain.
545 	address[] public registeredMainTokens;
546 
547 	// registeredClonedTokens stores the ported tokens created by the foundation.
548 	address[] public registeredClonedTokens;
549 
550 	// breakoutTokens is an address to address mapping that maps the currencies
551 	// to break out to the destination contract address on the destination chain.
552 	// Note that the zero address 0x0 represents the native token in this mapping.
553 	//
554 	// mapping structure
555 	//    main currency address                [this chain]
556 	// -> alt chain id of cloned token address
557 	// -> cloned token address                  [alt chain]
558 	mapping (address => mapping (uint256 => bytes)) public breakoutTokens;
559 
560 	// breakinTokens is an address to address mapping that maps the ported token
561 	// contracts on this chain to the currencies on the source chain.
562 	//
563 	// mapping structure
564 	//    cloned token address                   [this chain]
565 	// -> alt chain id of main currency address
566 	// -> main currency address                   [alt chain]
567 	mapping (address => mapping (uint256 => bytes)) public breakinTokens;
568 
569 	// proofs is an bytes to bool mapping that labels a proof is used, including
570 	// for withdrawal and mint.
571 	mapping (bytes => bool) proofs;
572 
573 	// minPortValue records the minimum allowed porting value for each currency.
574 	//
575 	// mapping structure
576 	//    main/cloned currency address [this chain]
577 	// -> chain id of main/cloned currency address
578 	// -> minimum breakout value
579 	mapping (address => mapping (uint256 => uint256)) public minPortValue;
580 
581 
582 	// Events
583 
584 	// A Deposit event is emitted when a user deposits native currency or tokens
585 	// with value into the Port contract to break out to the dest_addr as ported
586 	// token with cloned_token as address on the chain with chain_id
587 	event Deposit(
588 		uint256 indexed chain_id,        // id of the destination chain.
589 		bytes indexed cloned_token_hash,
590 		bytes indexed alt_addr_hash,
591 		address main_token,              // the source token address
592 		bytes cloned_token,              // alt token address on the destination chain.
593 		bytes alt_addr,                  // address of receiving alt token on the dest chain.
594 		uint256 value                    // value to deposit.
595 	);
596 
597 	// A Withdraw event is emitted when a user sends withdrawal transaction
598 	// with proof to the Port on the destination chain to withdraw native
599 	// currency or token with value to the dest_addr.
600 	event Withdraw(
601 		uint256 indexed chain_id,   // id of the destination chain.
602 		address indexed main_token, // the source token address on this chain.
603 		address indexed addr,       // address to withdraw to on this chain.
604 		bytes proof,                // proof on the destination chain.
605 		bytes cloned_token,         // the dest token address on alt chain.
606 		uint256 value               // value to withdraw.
607 	);
608 
609 	// A RegisterBreakout event is emitted when the foundation registers a pair
610 	// of currencies to break out to a destination chain.
611 	// Note that
612 	//   - the zero address 0x0 of main_token represents the native currency
613 	//   - cloned_token must be a PortedToken
614 	event RegisterBreakout(
615 		uint256 indexed chain_id,        // id of the destination chain.
616 		address indexed main_token,      // source token address on this chain.
617 		bytes indexed cloned_token_hash,
618 		bytes cloned_token,              // new destination address on the destination chain.
619 		bytes old_cloned_token,          // old destination address on the destination chain.
620 		uint256 minValue                 // minimum value to deposit and withdraw.
621 	);
622 
623 	// A RegisterBreakin event is emitted when the foundation registers a pair
624 	// of currencies to break in from a source chain.
625 	// Note that
626 	//   - the zero address 0x0 of main_token represents the native currency
627 	//   - cloned_token must be a PortedToken
628 	event RegisterBreakin(
629 		uint256 indexed chain_id,      // id of the source chain.
630 		address indexed cloned_token,  // destination token address on this chain.
631 		bytes indexed main_token_hash,
632 		bytes main_token,              // new source address on the source chain.
633 		bytes old_main_token,          // old source address on the source chain.
634 		uint256 minValue               // minimum value to mint and burn.
635 	);
636 
637 	// A Mint event is emitted when the foundation mints token with value to the
638 	// dest_addr as a user sends the transaction with proof on the source chain.
639 	event Mint(
640 		uint256 indexed chain_id,     // id of the source chain.
641 		address indexed cloned_token, // destination token address on this chain.
642 		address indexed addr,         // destination address to mint to.
643 		bytes proof,                  // proof of the deposit on the source chain.
644 		bytes main_token,             // the source token on alt chain.
645 		uint256 value                 // value to mint.
646 	);
647 
648 	// A Burn event is emitted when a user burns broken-in tokens to withdraw to
649 	// dest_addr on the source chain.
650 	event Burn(
651 		uint256 indexed chain_id,      // id of the source chain to burn to.
652 		bytes indexed main_token_hash,
653 		bytes indexed alt_addr_hash,
654 		address cloned_token,          // destination token on this chain.
655 		bytes main_token,              // source token on the source chain.
656 		bytes alt_addr,                // destination address on the source chain.
657 		uint256 value                  // value to burn
658 	);
659 
660 	constructor(address payable foundation_beneficiary) public {
661 		beneficiary = foundation_beneficiary;
662 	}
663 
664 	function destruct() public onlyFoundation {
665 		// transfer all tokens to beneficiary.
666 		for (uint i=0; i<registeredMainTokens.length; i++) {
667 			IERC20 token = IERC20(registeredMainTokens[i]);
668 			uint256 balance = token.balanceOf(address(this));
669 			token.transfer(beneficiary, balance);
670 		}
671 
672 		// transfer the ported tokens' control to the beneficiary
673 		for (uint i=0; i<registeredClonedTokens.length; i++) {
674 			PortedToken token = PortedToken(registeredClonedTokens[i]);
675 			token.transferTeleport(beneficiary);
676 		}
677 
678 		selfdestruct(beneficiary);
679 	}
680 
681 	modifier breakoutRegistered(uint256 chain_id, address token) {
682 		require(breakoutTokens[token][chain_id].length != 0, 'unregistered token');
683 		_;
684 	}
685 
686 	modifier breakinRegistered(uint256 chain_id, address token) {
687 		require(breakinTokens[token][chain_id].length != 0, 'unregistered token');
688 		_;
689 	}
690 
691 	modifier validAmount(uint256 chain_id, address token, uint256 value) {
692 		require(value >= minPortValue[token][chain_id], "value less than min amount");
693 		_;
694 	}
695 
696 	modifier validProof(bytes memory proof) {
697 		require(!proofs[proof], 'duplicate proof');
698 		_;
699 	}
700 
701 	function isProofUsed(bytes memory proof) view public returns (bool) {
702 		return proofs[proof];
703 	}
704 
705 	// Caller needs to send at least min value native token when called (payable).
706 	// A Deposit event will be emitted for the foundation server to mint the
707 	// corresponding wrapped tokens to the dest_addr on the destination chain.
708 	//
709 	// chain_id: The id of destination chain.
710 	// alt_addr: The address to mint to on the destination chain.
711 	// value: The value to mint.
712 	function depositNative(
713 		uint256 chain_id,
714 		bytes memory alt_addr
715 	)
716 		payable
717 		public
718 		whenNotPaused
719 		breakoutRegistered(chain_id, address(0))
720 		validAmount(chain_id, address(0), msg.value)
721 	{
722 		bytes memory cloned_token = breakoutTokens[address(0)][chain_id];
723 		emit Deposit(chain_id,
724 			cloned_token, alt_addr, // indexed bytes value hashed automatically
725 			address(0), cloned_token, alt_addr, msg.value);
726 	}
727 
728 	function () payable external {
729 		revert('not allowed to send value');
730 	}
731 
732 	// Caller needs to provide a proof of the transfer (proof).
733 	// A Deposit event will be emitted for the foundation server to mint the
734 	// corresponding wrapped tokens to the dest_addr on the destination chain.
735 	//
736 	// main_token: The token to deposit with.
737 	// chain_id: The id of destination chain.
738 	// alt_addr: The address to mint to on the destination chain.
739 	// value: The value to mint.
740 	function depositToken(
741 		address main_token,
742 		uint256 chain_id,
743 		bytes memory alt_addr,
744 		uint256 value
745 	)
746 		public
747 		whenNotPaused
748 		breakoutRegistered(chain_id, main_token)
749 		validAmount(chain_id, main_token, value)
750 	{
751 		bytes memory cloned_token = breakoutTokens[main_token][chain_id];
752 		emit Deposit(chain_id,
753 			cloned_token, alt_addr, // indexed bytes value hashed automatically
754 			main_token, cloned_token, alt_addr, value);
755 
756 		IERC20 token = IERC20(main_token);
757 		require(token.transferFrom(msg.sender, address(this), value));
758 	}
759 
760 	// Caller needs to provide a proof of the transfer (proof).
761 	//
762 	// chain_id: The alt chain where the burn proof is.
763 	// proof: The proof of the corresponding transaction on the source chain.
764 	// addr: The address to withdraw to on this chain.
765 	// value: The value to withdraw.
766 	function withdrawNative(
767 		uint256 chain_id,
768 		bytes memory proof,
769 		address payable addr,
770 		uint256 value
771 	)
772 		public
773 		whenNotPaused
774 		onlyFoundation
775 		breakoutRegistered(chain_id, address(0))
776 		validProof(proof)
777 		validAmount(chain_id, address(0), value)
778 	{
779 		bytes memory cloned_token = breakoutTokens[address(0)][chain_id];
780 		emit Withdraw(chain_id, address(0), addr, proof, cloned_token, value);
781 
782 		proofs[proof] = true;
783 
784 		addr.transfer(value);
785 	}
786 
787 	// Caller needs to provide a proof of the transfer (proof).
788 	//
789 	// chain_id: The alt chain where the burn proof is.
790 	// proof: The proof of the corresponding transaction on the destination chain.
791 	// main_token: The address of the token to mint on this chain.
792 	// addr: The address to withdraw to on this chain.
793 	// value: The value to withdraw.
794 	function withdrawToken(
795 		uint256 chain_id,
796 		bytes memory proof,
797 		address main_token,
798 		address addr,
799 		uint256 value
800 	)
801 		public
802 		whenNotPaused
803 		onlyFoundation
804 		breakoutRegistered(chain_id, main_token)
805 		validAmount(chain_id, main_token, value)
806 		validProof(proof)
807 	{
808 		bytes memory cloned_token = breakoutTokens[main_token][chain_id];
809 		emit Withdraw(chain_id, main_token, addr, proof, cloned_token, value);
810 
811 		proofs[proof] = true;
812 
813 		IERC20 token = IERC20(main_token);
814 		require(token.transfer(addr, value));
815 	}
816 
817 
818 	// Caller needs to provide the source and the destination of the mapped
819 	// token contract. The mapping will be updated if the register function is
820 	// called with a registered source address. The token is revoked if the dest
821 	// address is set to zero-length bytes.
822 	//
823 	// main_token: The address of the token on this chain.
824 	// chain_id: The id of the chain the cloned token is in.
825 	// cloned_token: The address of the token on the alt chain (dest chain).
826 	// old_cloned_token: The original address of the cloned token.
827 	// minValue: The minimum amount of each deposit/burn can transfer with.
828 	function registerBreakout(
829 		address main_token,
830 		uint256 chain_id,
831 		bytes memory old_cloned_token,
832 		bytes memory cloned_token,
833 		uint256 minValue
834 	)
835 		public
836 		whenNotPaused
837 		onlyFoundation
838 	{
839 		require(keccak256(breakoutTokens[main_token][chain_id]) == keccak256(old_cloned_token), 'wrong old dest');
840 
841 		emit RegisterBreakout(chain_id, main_token,
842 			cloned_token, // indexed bytes value is hashed automatically
843 			cloned_token, old_cloned_token, minValue);
844 
845 		breakoutTokens[main_token][chain_id] = cloned_token;
846 		minPortValue[main_token][chain_id] = minValue;
847 
848 		bool firstTimeRegistration = old_cloned_token.length == 0;
849 		if (main_token != address(0) && firstTimeRegistration) {
850 			registeredMainTokens.push(main_token);
851 		}
852 	}
853 
854 	// Caller needs to provide the source and the destination of the mapped
855 	// token contract. The mapping will be updated if the register function is
856 	// called with a registered source address. The token is revoked if the dest
857 	// address is set to zero-length bytes.
858 	//
859 	// cloned_token: The address of the token on this chain.
860 	// chain_id: The id of the chain the main token is in.
861 	// main_token: The address of the token on the alt chain (source chain).
862 	// old_main_token: The original address of the main token.
863 	// minValue: The minimum amount of each deposit/burn can transfer with.
864 	function registerBreakin(
865 		address cloned_token,
866 		uint256 chain_id,
867 		bytes memory old_main_token,
868 		bytes memory main_token,
869 		uint256 minValue
870 	)
871 		public
872 		whenNotPaused
873 		onlyFoundation
874 	{
875 		require(keccak256(breakinTokens[cloned_token][chain_id]) == keccak256(old_main_token), 'wrong old src');
876 
877 		emit RegisterBreakin(chain_id, cloned_token,
878 			main_token, // indexed bytes value is hashed automatically
879 			main_token, old_main_token, minValue);
880 
881 		breakinTokens[cloned_token][chain_id] = main_token;
882 		minPortValue[cloned_token][chain_id] = minValue;
883 
884 		bool firstTimeRegistration = old_main_token.length == 0;
885 		if (firstTimeRegistration) {
886 			registeredClonedTokens.push(cloned_token);
887 		}
888 	}
889 
890 	// Caller needs to provide the proof of the Deposit (proof), which
891 	// can be verified on the source chain with corresponding transaction.
892 	//
893 	// chain_id: The id of the chain the main token is in.
894 	// proof: The proof of the corresponding transaction on alt chain.
895 	// cloned_token: The address of the token to mint on this chain.
896 	// addr: The address to mint to on this chain.
897 	// value: The value to mint.
898 	function mint(
899 		uint256 chain_id,
900 		bytes memory proof,
901 		address cloned_token,
902 		address addr,
903 		uint256 value
904 	)
905 		public
906 		whenNotPaused
907 		onlyFoundation
908 		breakinRegistered(chain_id, cloned_token)
909 		validAmount(chain_id, cloned_token, value)
910 		validProof(proof)
911 	{
912 		bytes memory main_token = breakinTokens[cloned_token][chain_id];
913 		emit Mint(chain_id, cloned_token, addr, proof, main_token, value);
914 
915 		proofs[proof] = true;
916 
917 		PortedToken token = PortedToken(cloned_token);
918 		token.mint(addr, value);
919 	}
920 
921 	// Caller needs to provide the proof of the Burn (proof), which contains
922 	// proof matching the destination and value.
923 	//
924 	// chain_id: The id of the chain the main token is in.
925 	// cloned_token: The address of the ported token on this chain.
926 	// alt_addr: The address to withdraw to on altchain.
927 	// value: The value to withdraw.
928 	function burn(
929 		uint256 chain_id,
930 		address cloned_token,
931 		bytes memory alt_addr,
932 		uint256 value
933 	)
934 		public
935 		whenNotPaused
936 		breakinRegistered(chain_id, cloned_token)
937 		validAmount(chain_id, cloned_token, value)
938 	{
939 		bytes memory main_token = breakinTokens[cloned_token][chain_id];
940 		emit Burn(chain_id,
941 			main_token, alt_addr, // indexed value are hashed automatically
942 			cloned_token, main_token, alt_addr, value);
943 
944 		PortedToken token = PortedToken(cloned_token);
945 		token.burn(msg.sender, value);
946 	}
947 }