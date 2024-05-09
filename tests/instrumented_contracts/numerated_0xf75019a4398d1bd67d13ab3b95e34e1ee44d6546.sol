1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 pragma solidity ^0.8.0;
79 
80 
81 /**
82  * @dev Interface for the optional metadata functions from the ERC20 standard.
83  *
84  * _Available since v4.1._
85  */
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /*
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address payable) {
118         return payable(msg.sender);
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
123         return msg.data;
124     }
125 }
126 
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Implementation of the {IERC20} interface.
132  *
133  * This implementation is agnostic to the way tokens are created. This means
134  * that a supply mechanism has to be added in a derived contract using {_mint}.
135  * For a generic mechanism see {ERC20PresetMinterPauser}.
136  *
137  * TIP: For a detailed writeup see our guide
138  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
139  * to implement supply mechanisms].
140  *
141  * We have followed general OpenZeppelin guidelines: functions revert instead
142  * of returning `false` on failure. This behavior is nonetheless conventional
143  * and does not conflict with the expectations of ERC20 applications.
144  *
145  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
146  * This allows applications to reconstruct the allowance for all accounts just
147  * by listening to said events. Other implementations of the EIP may not emit
148  * these events, as it isn't required by the specification.
149  *
150  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
151  * functions have been added to mitigate the well-known issues around setting
152  * allowances. See {IERC20-approve}.
153  */
154 contract ERC20 is Context, IERC20, IERC20Metadata {
155     mapping (address => uint256) private _balances;
156 
157     mapping (address => mapping (address => uint256)) private _allowances;
158 
159     uint256 private _totalSupply;
160 
161     string private _name;
162     string private _symbol;
163 
164     /**
165      * @dev Sets the values for {name} and {symbol}.
166      *
167      * The defaut value of {decimals} is 18. To select a different value for
168      * {decimals} you should overload it.
169      *
170      * All two of these values are immutable: they can only be set once during
171      * construction.
172      */
173     constructor (string memory name_, string memory symbol_) {
174         _name = name_;
175         _symbol = symbol_;
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     /**
194      * @dev Returns the number of decimals used to get its user representation.
195      * For example, if `decimals` equals `2`, a balance of `505` tokens should
196      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
197      *
198      * Tokens usually opt for a value of 18, imitating the relationship between
199      * Ether and Wei. This is the value {ERC20} uses, unless this function is
200      * overridden;
201      *
202      * NOTE: This information is only used for _display_ purposes: it in
203      * no way affects any of the arithmetic of the contract, including
204      * {IERC20-balanceOf} and {IERC20-transfer}.
205      */
206     function decimals() public view virtual override returns (uint8) {
207         return 18;
208     }
209 
210     /**
211      * @dev See {IERC20-totalSupply}.
212      */
213     function totalSupply() public view virtual override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     /**
218      * @dev See {IERC20-balanceOf}.
219      */
220     function balanceOf(address account) public view virtual override returns (uint256) {
221         return _balances[account];
222     }
223 
224     /**
225      * @dev See {IERC20-transfer}.
226      *
227      * Requirements:
228      *
229      * - `recipient` cannot be the zero address.
230      * - the caller must have a balance of at least `amount`.
231      */
232     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     /**
238      * @dev See {IERC20-allowance}.
239      */
240     function allowance(address owner, address spender) public view virtual override returns (uint256) {
241         return _allowances[owner][spender];
242     }
243 
244     /**
245      * @dev See {IERC20-approve}.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function approve(address spender, uint256 amount) public virtual override returns (bool) {
252         _approve(_msgSender(), spender, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-transferFrom}.
258      *
259      * Emits an {Approval} event indicating the updated allowance. This is not
260      * required by the EIP. See the note at the beginning of {ERC20}.
261      *
262      * Requirements:
263      *
264      * - `sender` and `recipient` cannot be the zero address.
265      * - `sender` must have a balance of at least `amount`.
266      * - the caller must have allowance for ``sender``'s tokens of at least
267      * `amount`.
268      */
269     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
270         _transfer(sender, recipient, amount);
271 
272         uint256 currentAllowance = _allowances[sender][_msgSender()];
273         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
274         _approve(sender, _msgSender(), currentAllowance - amount);
275 
276         return true;
277     }
278 
279     /**
280      * @dev Atomically increases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to {approve} that can be used as a mitigation for
283      * problems described in {IERC20-approve}.
284      *
285      * Emits an {Approval} event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
292         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
293         return true;
294     }
295 
296     /**
297      * @dev Atomically decreases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      * - `spender` must have allowance for the caller of at least
308      * `subtractedValue`.
309      */
310     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
311         uint256 currentAllowance = _allowances[_msgSender()][spender];
312         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
313         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
314 
315         return true;
316     }
317 
318     /**
319      * @dev Moves tokens `amount` from `sender` to `recipient`.
320      *
321      * This is internal function is equivalent to {transfer}, and can be used to
322      * e.g. implement automatic token fees, slashing mechanisms, etc.
323      *
324      * Emits a {Transfer} event.
325      *
326      * Requirements:
327      *
328      * - `sender` cannot be the zero address.
329      * - `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      */
332     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
333         require(sender != address(0), "ERC20: transfer from the zero address");
334         require(recipient != address(0), "ERC20: transfer to the zero address");
335 
336         _beforeTokenTransfer(sender, recipient, amount);
337 
338         uint256 senderBalance = _balances[sender];
339         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
340         _balances[sender] = senderBalance - amount;
341         _balances[recipient] += amount;
342 
343         emit Transfer(sender, recipient, amount);
344     }
345 
346     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
347      * the total supply.
348      *
349      * Emits a {Transfer} event with `from` set to the zero address.
350      *
351      * Requirements:
352      *
353      * - `to` cannot be the zero address.
354      */
355     function _mint(address account, uint256 amount) internal virtual {
356         require(account != address(0), "ERC20: mint to the zero address");
357 
358         _beforeTokenTransfer(address(0), account, amount);
359 
360         _totalSupply += amount;
361         _balances[account] += amount;
362         emit Transfer(address(0), account, amount);
363     }
364 
365     /**
366      * @dev Destroys `amount` tokens from `account`, reducing the
367      * total supply.
368      *
369      * Emits a {Transfer} event with `to` set to the zero address.
370      *
371      * Requirements:
372      *
373      * - `account` cannot be the zero address.
374      * - `account` must have at least `amount` tokens.
375      */
376     function _burn(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: burn from the zero address");
378 
379         _beforeTokenTransfer(account, address(0), amount);
380 
381         uint256 accountBalance = _balances[account];
382         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
383         _balances[account] = accountBalance - amount;
384         _totalSupply -= amount;
385 
386         emit Transfer(account, address(0), amount);
387     }
388 
389     /**
390      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
391      *
392      * This internal function is equivalent to `approve`, and can be used to
393      * e.g. set automatic allowances for certain subsystems, etc.
394      *
395      * Emits an {Approval} event.
396      *
397      * Requirements:
398      *
399      * - `owner` cannot be the zero address.
400      * - `spender` cannot be the zero address.
401      */
402     function _approve(address owner, address spender, uint256 amount) internal virtual {
403         require(owner != address(0), "ERC20: approve from the zero address");
404         require(spender != address(0), "ERC20: approve to the zero address");
405 
406         _allowances[owner][spender] = amount;
407         emit Approval(owner, spender, amount);
408     }
409 
410     /**
411      * @dev Hook that is called before any transfer of tokens. This includes
412      * minting and burning.
413      *
414      * Calling conditions:
415      *
416      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
417      * will be to transferred to `to`.
418      * - when `from` is zero, `amount` tokens will be minted for `to`.
419      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
420      * - `from` and `to` are never both zero.
421      *
422      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
423      */
424     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
425 }
426 
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Contract module which provides a basic access control mechanism, where
432  * there is an account (an owner) that can be granted exclusive access to
433  * specific functions.
434  *
435  * By default, the owner account will be the one that deploys the contract. This
436  * can later be changed with {transferOwnership}.
437  *
438  * This module is used through inheritance. It will make available the modifier
439  * `onlyOwner`, which can be applied to your functions to restrict their use to
440  * the owner.
441  */
442 abstract contract Ownable is Context {
443     address private _owner;
444 
445     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
446 
447     /**
448      * @dev Initializes the contract setting the deployer as the initial owner.
449      */
450     constructor () {
451         address msgSender = _msgSender();
452         _owner = msgSender;
453         emit OwnershipTransferred(address(0), msgSender);
454     }
455 
456     /**
457      * @dev Returns the address of the current owner.
458      */
459     function owner() public view virtual returns (address) {
460         return _owner;
461     }
462 
463     /**
464      * @dev Throws if called by any account other than the owner.
465      */
466     modifier onlyOwner() {
467         require(owner() == _msgSender(), "Ownable: caller is not the owner");
468         _;
469     }
470 
471     /**
472      * @dev Leaves the contract without owner. It will not be possible to call
473      * `onlyOwner` functions anymore. Can only be called by the current owner.
474      *
475      * NOTE: Renouncing ownership will leave the contract without an owner,
476      * thereby removing any functionality that is only available to the owner.
477      */
478     function renounceOwnership() public virtual onlyOwner {
479         emit OwnershipTransferred(_owner, address(0));
480         _owner = address(0);
481     }
482 
483     /**
484      * @dev Transfers ownership of the contract to a new account (`newOwner`).
485      * Can only be called by the current owner.
486      */
487     function transferOwnership(address newOwner) public virtual onlyOwner {
488         require(newOwner != address(0), "Ownable: new owner is the zero address");
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 
495 pragma solidity >=0.7.6;
496 
497 /**
498  * a contract must implement this interface in order to support relayed transaction.
499  * It is better to inherit the BaseRelayRecipient as its implementation.
500  */
501 abstract contract IRelayRecipient {
502 
503     /**
504      * return if the forwarder is trusted to forward relayed transactions to us.
505      * the forwarder is required to verify the sender's signature, and verify
506      * the call is not a replay.
507      */
508     function isTrustedForwarder(address forwarder) public virtual view returns(bool);
509 
510     /**
511      * return the sender of this call.
512      * if the call came through our trusted forwarder, then the real sender is appended as the last 20 bytes
513      * of the msg.data.
514      * otherwise, return `msg.sender`
515      * should be used in the contract anywhere instead of msg.sender
516      */
517     function _msgSender() internal virtual view returns (address payable);
518 
519     /**
520      * return the msg.data of this call.
521      * if the call came through our trusted forwarder, then the real sender was appended as the last 20 bytes
522      * of the msg.data - so this method will strip those 20 bytes off.
523      * otherwise (if the call was made directly and not through the forwarder), return `msg.data`
524      * should be used in the contract instead of msg.data, where this difference matters.
525      */
526     function _msgData() internal virtual view returns (bytes memory);
527 
528     function versionRecipient() external virtual view returns (string memory);
529 }
530 
531 // File: @opengsn/contracts/src/BaseRelayRecipient.sol
532 
533 // SPDX-License-Identifier: GPL-3.0-only
534 // solhint-disable no-inline-assembly
535 pragma solidity >=0.7.6;
536 
537 
538 /**
539  * A base contract to be inherited by any contract that want to receive relayed transactions
540  * A subclass must use "_msgSender()" instead of "msg.sender"
541  */
542 abstract contract BaseRelayRecipient is IRelayRecipient {
543 
544     /*
545      * Forwarder singleton we accept calls from
546      */
547     address public trustedForwarder;
548 
549     function isTrustedForwarder(address forwarder) public override view returns(bool) {
550         return forwarder == trustedForwarder;
551     }
552 
553     /**
554      * return the sender of this call.
555      * if the call came through our trusted forwarder, return the original sender.
556      * otherwise, return `msg.sender`.
557      * should be used in the contract anywhere instead of msg.sender
558      */
559     function _msgSender() internal override virtual view returns (address payable ret) {
560         if (msg.data.length >= 20 && isTrustedForwarder(msg.sender)) {
561             // At this point we know that the sender is a trusted forwarder,
562             // so we trust that the last bytes of msg.data are the verified sender address.
563             // extract sender address from the end of msg.data
564             assembly {
565                 ret := shr(96,calldataload(sub(calldatasize(),20)))
566             }
567         } else {
568             return payable(msg.sender);
569         }
570     }
571 
572     /**
573      * return the msg.data of this call.
574      * if the call came through our trusted forwarder, then the real sender was appended as the last 20 bytes
575      * of the msg.data - so this method will strip those 20 bytes off.
576      * otherwise, return `msg.data`
577      * should be used in the contract instead of msg.data, where the difference matters (e.g. when explicitly
578      * signing or hashing the
579      */
580     function _msgData() internal override virtual view returns (bytes memory ret) {
581         if (msg.data.length >= 20 && isTrustedForwarder(msg.sender)) {
582             return msg.data[0:msg.data.length-20];
583         } else {
584             return msg.data;
585         }
586     }
587 }
588 
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @title AMFEIX ERC20 swap smart contract
594  * @dev Contract based on ERC20 standard with "swap" features between BTC and AMF
595  */
596 contract AMF is ERC20, Ownable, BaseRelayRecipient {
597 
598     mapping (address => uint256) private _balances;
599 
600     uint256 private _swapRatio;
601     address private _tokenPool;
602     string private _btcPool;
603     uint256 private _minimumWithdrawal;
604 
605     string public override versionRecipient = "2.2.0";
606 
607     /**
608      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
609      * a default value of 18.
610      *
611      * All three of these values are immutable: they can only be set once during
612      * construction.
613      */
614     constructor (
615         string memory name_, 
616         string memory symbol_, 
617         address tokenPool_, 
618         string memory btcPool_
619         ) ERC20(name_,symbol_) Ownable() {
620             _swapRatio = 100000; // AMF amount for 1 BTC
621             _tokenPool = tokenPool_; // AMFEIX buffer ETH wallet address
622             _btcPool = btcPool_; // AMFEIX buffer BTC wallet address
623             _minimumWithdrawal = 1000; // AMF minimum amount for withdrawals
624     }
625 
626     /**
627      * @dev Allows contract owner to create new tokens.
628      * 
629      * @param newHolder Ethereum address of the recipient 
630      * @param amount The number of tokens the recipient will receive
631      */
632     function mint(address newHolder, uint256 amount) public virtual onlyOwner returns (uint256) {
633         _mint(newHolder, amount);
634         return amount;
635     }
636 
637     /**
638      * @dev Allows anyone to destroy its tokens.
639      *
640      * @param amount The number of tokens that sender is willing to burn from its account
641      */
642     function burn(uint256 amount) public virtual returns (bool) {
643         _burn(_msgSender(), amount);
644         return true;
645     }
646     /**
647      * @dev Returns the current AMF minimum withdrawal amount.
648      * 
649      * We need this value to prevent users from claiming BTC if the AMF amount is too small.
650      * Main reason is the BTC mining fees AMFEIX is going to pay for this transaction
651      */
652     function getMinimumWithdrawalAmount() public view virtual returns (uint256) {
653         return _minimumWithdrawal;
654     }
655 
656     /**
657      * @dev Allows contract owner to update the current AMF minimum withdrawal amount.
658      * 
659      * @param newMinimum The updated minimum amount of AMF allowed for BTC withdrawal
660      */
661     function setMinimumWithdrawalAmount(uint256 newMinimum) external virtual onlyOwner returns (bool) {
662         _minimumWithdrawal = newMinimum;
663         emit MinimumWithdrawalChanged(newMinimum);
664         return true;
665     }
666     // Emitted when AMFEIX changes the current AMF minimum withdrawal amount
667     event MinimumWithdrawalChanged (
668         uint256 indexed newMinimum
669     );
670 
671     /**
672      * @dev Returns the current swap ratio (how much AMF tokens corresponds to 1 BTC)
673      *      
674      * Initial ratio  100000 AMF : 1 BTC  (1 AMF : 1000 sat)
675      * We need this value to compute the amount of AMF to send to users when they deposited BTC at AMFEIX
676      * and to compute the amount of BTC to send to users when they claim back their BTC.
677      */
678     function getSwapRatio() public view virtual returns (uint256) {
679         return _swapRatio;
680     }
681 
682     /**
683      * @dev Allows contract owner to update the current swap ratio (AMF/BTC).
684      * 
685      * @param newRatio The updated amount of AMF tokens corresponding to 1 BTC (~10^5)
686      */
687     function setSwapRatio(uint256 newRatio) external virtual onlyOwner returns (bool) {
688         _swapRatio = newRatio;
689         emit RatioChanged(newRatio);
690         return true;
691     }
692     // Emitted when AMFEIX changes the current swap ratio
693     event RatioChanged (
694         uint256 indexed newRatio
695     );
696 
697     /**
698      * @dev Returns the current AMF token pool address held by AMFEIX.
699      */
700     function getTokenPoolAddress() public view virtual returns (address) {
701         return _tokenPool;
702     }
703 
704     /**
705      * @dev Allows contract owner to update its current AMF token pool address.
706      * 
707      * @param newAddress The updated address of the token pool
708      */
709     function setTokenPoolAddress(address newAddress) external virtual onlyOwner returns (bool) {
710         _tokenPool = newAddress;
711         emit TokenPoolAddressChanged(newAddress);
712         return true;
713     }
714     // Emitted when AMFEIX changes the current token pool address
715     event TokenPoolAddressChanged (
716         address indexed newAddress
717     );
718 
719     /**
720      * @dev Returns the current BTC pool address held by AMFEIX.
721      */
722     function getBtcPoolAddress() public view virtual returns (string memory) {
723         return _btcPool;
724     }
725 
726     /**
727      * @dev Allows contract owner to update its current BTC pool address.
728      * 
729      * @param newAddress The updated address of the BTC pool
730      */
731     function setBtcPoolAddress(string memory newAddress) external virtual onlyOwner returns (bool) {
732         _btcPool = newAddress;
733         emit BtcPoolAddressChanged(newAddress);
734         return true;
735     }
736     // Emitted when AMFEIX changes the current BTC pool address
737     event BtcPoolAddressChanged (
738         string indexed newAddress
739     );
740 
741     /**
742      * @dev Allow any customer who hold tokens to claim BTC
743      * 
744      * @param tokenAmount Amount of tokens to be exchanged (needs to be multiplied by 10^18)
745      * @param userBtcAddress BTC address on which users willing to receive payment
746      * /!\ gas cost for calling this method : 37kgas /!\
747      */
748     function claimBTC(uint256 tokenAmount, string memory userBtcAddress) public virtual returns (bool) {
749         require (tokenAmount >= _minimumWithdrawal, "current minimum withrawal is ${_minimumWithdrawal}");
750         _transfer(_msgSender(), _tokenPool, tokenAmount);
751         emit BtcToBePaid(_msgSender(), userBtcAddress, tokenAmount);
752         return true;
753     }
754     // Emitted when an user claim BTC against its tokens
755     event BtcToBePaid (
756         address indexed customer,
757         string userBtcAddress,
758         uint256 sentToken
759     );
760 
761     /**
762      * @dev Allow AMFEIX to transfer AMF to claiming users
763      * 
764      * @param tokenAmount Amount of tokens to be sent
765      * @param userAddress BTC address on which users willing to receive payment
766      * @param btcTxId ID of the AMF buying transaction on Bitcoin network
767      */
768     function payAMF(uint256 tokenAmount, address userAddress, string memory btcTxId) public virtual returns (bool) {
769         require(_msgSender() == _tokenPool, "Only AMFEIX can use this method");
770         _transfer(_msgSender(), userAddress, tokenAmount);
771         emit AmfPaid(userAddress, btcTxId, tokenAmount);
772         return true;
773     }
774     // Emitted when AMFEIX send AMF to users.
775     event AmfPaid (
776         address indexed customer,
777         string btcTxId,
778         uint256 sentToken
779     );
780 
781     // GSN compatibility
782     function _msgSender() internal override(Context, BaseRelayRecipient) view returns (address payable) {
783         return payable(BaseRelayRecipient._msgSender());
784     }
785     function _msgData() internal override(Context,BaseRelayRecipient) view returns (bytes memory ret) {
786         return BaseRelayRecipient._msgData();
787     }
788     function setForwarder(address forwarder) public onlyOwner {
789         trustedForwarder = forwarder;
790     }
791 }