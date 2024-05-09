1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34 
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         return mod(a, b, "SafeMath: modulo by zero");
63     }
64 
65     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b != 0, errorMessage);
67         return a % b;
68     }
69 }
70 
71 /**
72  * @dev Collection of functions related to the address type
73  */
74 library Address {
75     function isContract(address account) internal view returns (bool) {
76         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
77         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
78         // for accounts without code, i.e. `keccak256('')`
79         bytes32 codehash;
80         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
81         // solhint-disable-next-line no-inline-assembly
82         assembly { codehash := extcodehash(account) }
83         return (codehash != accountHash && codehash != 0x0);
84     }
85 
86 
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(address(this).balance >= amount, "Address: insufficient balance");
89 
90         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107  
108     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
109         require(address(this).balance >= value, "Address: insufficient balance for call");
110         return _functionCallWithValue(target, data, value, errorMessage);
111     }
112 
113     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
114         require(isContract(target), "Address: call to non-contract");
115 
116         // solhint-disable-next-line avoid-low-level-calls
117         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
118         if (success) {
119             return returndata;
120         } else {
121             // Look for revert reason and bubble it up if present
122             if (returndata.length > 0) {
123                 // The easiest way to bubble the revert reason is using memory via assembly
124 
125                 // solhint-disable-next-line no-inline-assembly
126                 assembly {
127                     let returndata_size := mload(returndata)
128                     revert(add(32, returndata), returndata_size)
129                 }
130             } else {
131                 revert(errorMessage);
132             }
133         }
134     }
135 }
136 
137 /*
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with GSN meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address payable) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes memory) {
153         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
154         return msg.data;
155     }
156 }
157 
158 
159 /**
160  * @dev Contract module which provides a basic access control mechanism, where
161  * there is an account (an owner) that can be granted exclusive access to
162  * specific functions.
163  *
164  * By default, the owner account will be the one that deploys the contract. This
165  * can later be changed with {transferOwnership}.
166  *
167  * This module is used through inheritance. It will make available the modifier
168  * `onlyOwner`, which can be applied to your functions to restrict their use to
169  * the owner.
170  */
171 contract Ownable is Context {
172     address private _owner;
173 
174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
175 
176     /**
177      * @dev Initializes the contract setting the deployer as the initial owner.
178      */
179     constructor () {
180         address msgSender = _msgSender();
181         _owner = msgSender;
182         emit OwnershipTransferred(address(0), msgSender);
183     }
184 
185     /**
186      * @dev Returns the address of the current owner.
187      */
188     function owner() public view returns (address) {
189         return _owner;
190     }
191 
192     /**
193      * @dev Throws if called by any account other than the owner.
194      */
195     modifier onlyOwner() {
196         require(_owner == _msgSender(), "Ownable: caller is not the owner");
197         _;
198     }
199 
200     /**
201      * @dev Leaves the contract without owner. It will not be possible to call
202      * `onlyOwner` functions anymore. Can only be called by the current owner.
203      *
204      * NOTE: Renouncing ownership will leave the contract without an owner,
205      * thereby removing any functionality that is only available to the owner.
206      */
207     function renounceOwnership() public virtual onlyOwner {
208         emit OwnershipTransferred(_owner, address(0));
209         _owner = address(0);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Can only be called by the current owner.
215      */
216     function transferOwnership(address newOwner) public virtual onlyOwner {
217         require(newOwner != address(0), "Ownable: new owner is the zero address");
218         emit OwnershipTransferred(_owner, newOwner);
219         _owner = newOwner;
220     }
221 }
222 
223 /**
224  * @dev Interface of the ERC20 standard as defined in the EIP.
225  */
226 interface IERC20 {
227     function totalSupply() external view returns (uint256);
228 
229     function balanceOf(address account) external view returns (uint256);
230 
231     function transfer(address recipient, uint256 amount) external returns (bool);
232 
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     function approve(address spender, uint256 amount) external returns (bool);
236 
237     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
238 
239     event Transfer(address indexed from, address indexed to, uint256 value);
240 
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 /**
245  * @dev Implementation of the {IERC20} interface.
246  *
247  * This implementation is agnostic to the way tokens are created. This means
248  * that a supply mechanism has to be added in a derived contract using {_mint}.
249  * For a generic mechanism see {ERC20PresetMinterPauser}.
250  *
251  * TIP: For a detailed writeup see our guide
252  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
253  * to implement supply mechanisms].
254  *
255  * We have followed general OpenZeppelin guidelines: functions revert instead
256  * of returning `false` on failure. This behavior is nonetheless conventional
257  * and does not conflict with the expectations of ERC20 applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20LtdSup is Context, IERC20 {
269     using SafeMath for uint256;
270     using Address for address;
271 
272     mapping (address => uint256) private _balances;
273 
274     mapping (address => mapping (address => uint256)) private _allowances;
275 
276     uint256 private _totalSupply;
277 
278     string private _name;
279     string private _symbol;
280     uint8 private _decimals;
281 
282     uint256 public MAX_SUPPLY = 0;
283 
284     /**
285      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
286      * a default value of 18.
287      *
288      * To select a different value for {decimals}, use {_setupDecimals}.
289      *
290      * All three of these values are immutable: they can only be set once during
291      * construction.
292      */
293     constructor (string memory name_, string memory symbol_) {
294         _name = name_;
295         _symbol = symbol_;
296         _decimals = 18;
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
321      * called.
322      *
323      * NOTE: This information is only used for _display_ purposes: it in
324      * no way affects any of the arithmetic of the contract, including
325      * {IERC20-balanceOf} and {IERC20-transfer}.
326      */
327     function decimals() public view returns (uint8) {
328         return _decimals;
329     }
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view override returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account) public view override returns (uint256) {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `recipient` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(_msgSender(), recipient, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-allowance}.
360      */
361     function allowance(address owner, address spender) public view virtual override returns (uint256) {
362         return _allowances[owner][spender];
363     }
364 
365     /**
366      * @dev See {IERC20-approve}.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 amount) public virtual override returns (bool) {
373         _approve(_msgSender(), spender, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-transferFrom}.
379      *
380      * Emits an {Approval} event indicating the updated allowance. This is not
381      * required by the EIP. See the note at the beginning of {ERC20};
382      *
383      * Requirements:
384      * - `sender` and `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``sender``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
390         _transfer(sender, recipient, amount);
391         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
427         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
428         return true;
429     }
430 
431     /**
432      * @dev Moves tokens `amount` from `sender` to `recipient`.
433      *
434      * This is internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `sender` cannot be the zero address.
442      * - `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      */
445     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
446         require(sender != address(0), "ERC20: transfer from the zero address");
447         require(recipient != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(sender, recipient, amount);
450 
451         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
452         _balances[recipient] = _balances[recipient].add(amount);
453         emit Transfer(sender, recipient, amount);
454     }
455 
456     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
457      * the total supply.
458      *
459      * Emits a {Transfer} event with `from` set to the zero address.
460      *
461      * Requirements
462      *
463      * - `to` cannot be the zero address.
464      */
465     function _mint(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: mint to the zero address");
467         require(_totalSupply.add(amount) <= MAX_SUPPLY, "ERC20: max supply overflow");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply = _totalSupply.add(amount);
472         _balances[account] = _balances[account].add(amount);
473         emit Transfer(address(0), account, amount);
474     }
475 
476     /**
477      * @dev Destroys `amount` tokens from `account`, reducing the
478      * total supply.
479      *
480      * Emits a {Transfer} event with `to` set to the zero address.
481      *
482      * Requirements
483      *
484      * - `account` cannot be the zero address.
485      * - `account` must have at least `amount` tokens.
486      */
487     function _burn(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: burn from the zero address");
489 
490         _beforeTokenTransfer(account, address(0), amount);
491 
492         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
493         _totalSupply = _totalSupply.sub(amount);
494         emit Transfer(account, address(0), amount);
495     }
496 
497     /**
498      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
499      *
500      * This is internal function is equivalent to `approve`, and can be used to
501      * e.g. set automatic allowances for certain subsystems, etc.
502      *
503      * Emits an {Approval} event.
504      *
505      * Requirements:
506      *
507      * - `owner` cannot be the zero address.
508      * - `spender` cannot be the zero address.
509      */
510     function _approve(address owner, address spender, uint256 amount) internal virtual {
511         require(owner != address(0), "ERC20: approve from the zero address");
512         require(spender != address(0), "ERC20: approve to the zero address");
513 
514         _allowances[owner][spender] = amount;
515         emit Approval(owner, spender, amount);
516     }
517 
518     /**
519      * @dev Sets {decimals} to a value other than the default one of 18.
520      *
521      * WARNING: This function should only be called from the constructor. Most
522      * applications that interact with token contracts will not expect
523      * {decimals} to ever change, and may work incorrectly if it does.
524      */
525     function _setupDecimals(uint8 decimals_) internal {
526         _decimals = decimals_;
527     }
528 
529     /**
530      * @dev Hook that is called before any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * will be to transferred to `to`.
537      * - when `from` is zero, `amount` tokens will be minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
544 
545     /**
546      * @dev setter max supply tokens
547      */
548     function _setMaxSupply(uint256 _amount) internal {
549         MAX_SUPPLY = _amount;
550     }
551 }
552 
553 
554 // GpyxToken with Governance.
555 contract GpyxToken is ERC20LtdSup, Ownable {
556     using SafeMath for uint256;
557     
558     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (GoldMiner).
559     function mint(address _to, uint256 _amount) public onlyOwner {
560         _mint(_to, _amount);
561         _moveDelegates(address(0), _delegates[_to], _amount);
562     }
563 
564     constructor(uint256 maxSupply) ERC20LtdSup("GpyxToken", "GPYX") {
565         _setMaxSupply(maxSupply);
566     }
567 
568     /// @dev A record of each accounts delegate
569     mapping (address => address) internal _delegates;
570 
571     /// @dev A checkpoint for marking number of votes from a given block
572     struct Checkpoint {
573         uint32 fromBlock;
574         uint256 votes;
575     }
576 
577     /// @dev A record of votes checkpoints for each account, by index
578     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
579 
580     /// @dev The number of checkpoints for each account
581     mapping (address => uint32) public numCheckpoints;
582 
583     /// @dev The EIP-712 typehash for the contract's domain
584     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
585 
586     /// @dev The EIP-712 typehash for the delegation struct used by the contract
587     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
588 
589     /// @dev A record of states for signing / validating signatures
590     mapping (address => uint) public nonces;
591 
592       /// @dev An event thats emitted when an account changes its delegate
593     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
594 
595     /// @dev An event thats emitted when a delegate account's vote balance changes
596     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
597 
598     /**
599      * @dev Delegate votes from `msg.sender` to `delegatee`
600      * @param delegator The address to get delegatee for
601      */
602     function delegates(address delegator)
603         external
604         view
605         returns (address)
606     {
607         return _delegates[delegator];
608     }
609 
610    /**
611     * @dev Delegate votes from `msg.sender` to `delegatee`
612     * @param delegatee The address to delegate votes to
613     */
614     function delegate(address delegatee) external {
615         return _delegate(msg.sender, delegatee);
616     }
617 
618     /**
619      * @dev Delegates votes from signatory to `delegatee`
620      * @param delegatee The address to delegate votes to
621      * @param nonce The contract state required to match the signature
622      * @param expiry The time at which to expire the signature
623      * @param v The recovery byte of the signature
624      * @param r Half of the ECDSA signature pair
625      * @param s Half of the ECDSA signature pair
626      */
627     function delegateBySig(
628         address delegatee,
629         uint nonce,
630         uint expiry,
631         uint8 v,
632         bytes32 r,
633         bytes32 s
634     )
635         external
636     {
637         bytes32 domainSeparator = keccak256(
638             abi.encode(
639                 DOMAIN_TYPEHASH,
640                 keccak256(bytes(name())),
641                 getChainId(),
642                 address(this)
643             )
644         );
645 
646         bytes32 structHash = keccak256(
647             abi.encode(
648                 DELEGATION_TYPEHASH,
649                 delegatee,
650                 nonce,
651                 expiry
652             )
653         );
654 
655         bytes32 digest = keccak256(
656             abi.encodePacked(
657                 "\x19\x01",
658                 domainSeparator,
659                 structHash
660             )
661         );
662 
663         address signatory = ecrecover(digest, v, r, s);
664         require(signatory != address(0), "GPYX::delegateBySig: invalid signature");
665         require(nonce == nonces[signatory]++, "GPYX::delegateBySig: invalid nonce");
666         require(block.timestamp <= expiry, "GPYX::delegateBySig: signature expired");
667         return _delegate(signatory, delegatee);
668     }
669 
670     /**
671      * @dev Gets the current votes balance for `account`
672      * @param account The address to get votes balance
673      * @return The number of current votes for `account`
674      */
675     function getCurrentVotes(address account)
676         external
677         view
678         returns (uint256)
679     {
680         uint32 nCheckpoints = numCheckpoints[account];
681         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
682     }
683 
684     /**
685      * @dev Determine the prior number of votes for an account as of a block number
686      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
687      * @param account The address of the account to check
688      * @param blockNumber The block number to get the vote balance at
689      * @return The number of votes the account had as of the given block
690      */
691     function getPriorVotes(address account, uint blockNumber)
692         external
693         view
694         returns (uint256)
695     {
696         require(blockNumber < block.number, "GPYX::getPriorVotes: not yet determined");
697 
698         uint32 nCheckpoints = numCheckpoints[account];
699         if (nCheckpoints == 0) {
700             return 0;
701         }
702 
703         // First check most recent balance
704         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
705             return checkpoints[account][nCheckpoints - 1].votes;
706         }
707 
708         // Next check implicit zero balance
709         if (checkpoints[account][0].fromBlock > blockNumber) {
710             return 0;
711         }
712 
713         uint32 lower = 0;
714         uint32 upper = nCheckpoints - 1;
715         while (upper > lower) {
716             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
717             Checkpoint memory cp = checkpoints[account][center];
718             if (cp.fromBlock == blockNumber) {
719                 return cp.votes;
720             } else if (cp.fromBlock < blockNumber) {
721                 lower = center;
722             } else {
723                 upper = center - 1;
724             }
725         }
726         return checkpoints[account][lower].votes;
727     }
728 
729     function _delegate(address delegator, address delegatee)
730         internal
731     {
732         address currentDelegate = _delegates[delegator];
733         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying GPYXs (not scaled);
734         _delegates[delegator] = delegatee;
735 
736         emit DelegateChanged(delegator, currentDelegate, delegatee);
737 
738         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
739     }
740 
741     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
742         if (srcRep != dstRep && amount > 0) {
743             if (srcRep != address(0)) {
744                 // decrease old representative
745                 uint32 srcRepNum = numCheckpoints[srcRep];
746                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
747                 uint256 srcRepNew = srcRepOld.sub(amount);
748                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
749             }
750 
751             if (dstRep != address(0)) {
752                 // increase new representative
753                 uint32 dstRepNum = numCheckpoints[dstRep];
754                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
755                 uint256 dstRepNew = dstRepOld.add(amount);
756                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
757             }
758         }
759     }
760 
761     function _writeCheckpoint(
762         address delegatee,
763         uint32 nCheckpoints,
764         uint256 oldVotes,
765         uint256 newVotes
766     )
767         internal
768     {
769         uint32 blockNumber = safe32(block.number, "GPYX::_writeCheckpoint: block number exceeds 32 bits");
770 
771         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
772             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
773         } else {
774             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
775             numCheckpoints[delegatee] = nCheckpoints + 1;
776         }
777 
778         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
779     }
780 
781     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
782         require(n < 2**32, errorMessage);
783         return uint32(n);
784     }
785 
786     function getChainId() internal pure returns (uint) {
787         uint256 chainId;
788         assembly { chainId := chainid() }
789         return chainId;
790     }
791 }