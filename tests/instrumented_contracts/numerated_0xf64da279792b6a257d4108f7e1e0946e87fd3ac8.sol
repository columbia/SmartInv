1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-26
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
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
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Interface for the optional metadata functions from the ERC20 standard.
118  *
119  * _Available since v4.1._
120  */
121 interface IERC20Metadata is IERC20 {
122     /**
123      * @dev Returns the name of the token.
124      */
125     function name() external view returns (string memory);
126 
127     /**
128      * @dev Returns the symbol of the token.
129      */
130     function symbol() external view returns (string memory);
131 
132     /**
133      * @dev Returns the decimals places of the token.
134      */
135     function decimals() external view returns (uint8);
136 }
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Implementation of the {IERC20} interface.
142  *
143  * This implementation is agnostic to the way tokens are created. This means
144  * that a supply mechanism has to be added in a derived contract using {_mint}.
145  * For a generic mechanism see {ERC20PresetMinterPauser}.
146  *
147  * TIP: For a detailed writeup see our guide
148  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
149  * to implement supply mechanisms].
150  *
151  * We have followed general OpenZeppelin Contracts guidelines: functions revert
152  * instead returning `false` on failure. This behavior is nonetheless
153  * conventional and does not conflict with the expectations of ERC20
154  * applications.
155  *
156  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
157  * This allows applications to reconstruct the allowance for all accounts just
158  * by listening to said events. Other implementations of the EIP may not emit
159  * these events, as it isn't required by the specification.
160  *
161  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
162  * functions have been added to mitigate the well-known issues around setting
163  * allowances. See {IERC20-approve}.
164  */
165 contract ERC20 is Context, IERC20, IERC20Metadata {
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171 
172     string private _name;
173     string private _symbol;
174 
175     /**
176      * @dev Sets the values for {name} and {symbol}.
177      *
178      * The default value of {decimals} is 13. To select a different value for
179      * {decimals} you should overload it.
180      *
181      * All two of these values are immutable: they can only be set once during
182      * construction.
183      */
184     constructor(string memory name_, string memory symbol_) {
185         _name = name_;
186         _symbol = symbol_;
187     }
188 
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() public view virtual override returns (string memory) {
193         return _name;
194     }
195 
196     /**
197      * @dev Returns the symbol of the token, usually a shorter version of the
198      * name.
199      */
200     function symbol() public view virtual override returns (string memory) {
201         return _symbol;
202     }
203 
204     /**
205      * @dev Returns the number of decimals used to get its user representation.
206      * For example, if `decimals` equals `2`, a balance of `505` tokens should
207      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
208      *
209      * Tokens usually opt for a value of 18, imitating the relationship between
210      * Ether and Wei. This is the value {ERC20} uses, unless this function is
211      * overridden;
212      *
213      * NOTE: This information is only used for _display_ purposes: it in
214      * no way affects any of the arithmetic of the contract, including
215      * {IERC20-balanceOf} and {IERC20-transfer}.
216      */
217     function decimals() public view virtual override returns (uint8) {
218         return 13;
219     }
220 
221     /**
222      * @dev See {IERC20-totalSupply}.
223      */
224     function totalSupply() public view virtual override returns (uint256) {
225         return _totalSupply;
226     }
227 
228     /**
229      * @dev See {IERC20-balanceOf}.
230      */
231     function balanceOf(address account) public view virtual override returns (uint256) {
232         return _balances[account];
233     }
234 
235     /**
236      * @dev See {IERC20-transfer}.
237      *
238      * Requirements:
239      *
240      * - `recipient` cannot be the zero address.
241      * - the caller must have a balance of at least `amount`.
242      */
243     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
244         _transfer(_msgSender(), recipient, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-allowance}.
250      */
251     function allowance(address owner, address spender) public view virtual override returns (uint256) {
252         return _allowances[owner][spender];
253     }
254 
255     /**
256      * @dev See {IERC20-approve}.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      */
262     function approve(address spender, uint256 amount) public virtual override returns (bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-transferFrom}.
269      *
270      * Emits an {Approval} event indicating the updated allowance. This is not
271      * required by the EIP. See the note at the beginning of {ERC20}.
272      *
273      * Requirements:
274      *
275      * - `sender` and `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `amount`.
277      * - the caller must have allowance for ``sender``'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public virtual override returns (bool) {
285         _transfer(sender, recipient, amount);
286 
287         uint256 currentAllowance = _allowances[sender][_msgSender()];
288         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
289     unchecked {
290         _approve(sender, _msgSender(), currentAllowance - amount);
291     }
292 
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
328         uint256 currentAllowance = _allowances[_msgSender()][spender];
329         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
330     unchecked {
331         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
332     }
333 
334         return true;
335     }
336 
337     /**
338      * @dev Moves `amount` of tokens from `sender` to `recipient`.
339      *
340      * This internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) internal virtual {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         _beforeTokenTransfer(sender, recipient, amount);
360 
361         uint256 senderBalance = _balances[sender];
362         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
363     unchecked {
364         _balances[sender] = senderBalance - amount;
365     }
366         _balances[recipient] += amount;
367 
368         emit Transfer(sender, recipient, amount);
369 
370         _afterTokenTransfer(sender, recipient, amount);
371     }
372 
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _beforeTokenTransfer(address(0), account, amount);
386 
387         _totalSupply += amount;
388         _balances[account] += amount;
389         emit Transfer(address(0), account, amount);
390 
391         _afterTokenTransfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         uint256 accountBalance = _balances[account];
411         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
412     unchecked {
413         _balances[account] = accountBalance - amount;
414     }
415         _totalSupply -= amount;
416 
417         emit Transfer(account, address(0), amount);
418 
419         _afterTokenTransfer(account, address(0), amount);
420     }
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(
436         address owner,
437         address spender,
438         uint256 amount
439     ) internal virtual {
440         require(owner != address(0), "ERC20: approve from the zero address");
441         require(spender != address(0), "ERC20: approve to the zero address");
442 
443         _allowances[owner][spender] = amount;
444         emit Approval(owner, spender, amount);
445     }
446 
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {}
466 
467     /**
468      * @dev Hook that is called after any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * has been transferred to `to`.
475      * - when `from` is zero, `amount` tokens have been minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _afterTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 }
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Contract module which provides a basic access control mechanism, where
492  * there is an account (an owner) that can be granted exclusive access to
493  * specific functions.
494  *
495  * By default, the owner account will be the one that deploys the contract. This
496  * can later be changed with {transferOwnership}.
497  *
498  * This module is used through inheritance. It will make available the modifier
499  * `onlyOwner`, which can be applied to your functions to restrict their use to
500  * the owner.
501  */
502 abstract contract Ownable is Context {
503     address private _owner;
504 
505     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
506 
507     /**
508      * @dev Initializes the contract setting the deployer as the initial owner.
509      */
510     constructor() {
511         _setOwner(_msgSender());
512     }
513 
514     /**
515      * @dev Returns the address of the current owner.
516      */
517     function owner() public view virtual returns (address) {
518         return _owner;
519     }
520 
521     /**
522      * @dev Throws if called by any account other than the owner.
523      */
524     modifier onlyOwner() {
525         require(owner() == _msgSender(), "Ownable: caller is not the owner");
526         _;
527     }
528 
529     /**
530      * @dev Leaves the contract without owner. It will not be possible to call
531      * `onlyOwner` functions anymore. Can only be called by the current owner.
532      *
533      * NOTE: Renouncing ownership will leave the contract without an owner,
534      * thereby removing any functionality that is only available to the owner.
535      */
536     function renounceOwnership() public virtual onlyOwner {
537         _setOwner(address(0));
538     }
539 
540     /**
541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
542      * Can only be called by the current owner.
543      */
544     function transferOwnership(address newOwner) public virtual onlyOwner {
545         require(newOwner != address(0), "Ownable: new owner is the zero address");
546         _setOwner(newOwner);
547     }
548 
549     function _setOwner(address newOwner) private {
550         address oldOwner = _owner;
551         _owner = newOwner;
552         emit OwnershipTransferred(oldOwner, newOwner);
553     }
554 }
555 
556 pragma solidity ^0.8.0;
557 
558 // contract Metabits {
559 //     function setIsStake(uint256 _tokenId, bool _isStake) external {}
560 //     }
561 
562 interface IProudLion {
563     function balanceOf(address _user) external view returns(uint256);
564     function ownerOf(uint256 _tokenId) external view returns(address);
565     function totalSupply() external view returns (uint256);
566     function transfer(address recipient, uint256 amount) external returns (bool);
567     function setIsStake(uint256 _tokenId, bool _isStake) external;
568 }
569 
570 contract Plst is ERC20("Plst", "PLS"), Ownable {
571     address public ProudLionContractAddress;
572     struct TokenData {
573         uint256 baseRate;
574         uint256 stakeTime;
575         bool isStaked;
576     }
577 
578     IProudLion public iProudLion;
579 
580     IProudLion public iErcToken;
581 
582     // Prevents new contracts from being added or changes to disbursement if permanently locked
583     bool public isLocked = false;
584     uint256 public totalStaked = 0;
585     uint256 public eventStartDate = 0;
586     uint256 public eventEndDate = 0;
587     uint256 public eventRewardPercentage = 0;
588     uint256 public tokensRewardForOmega = 500;
589     uint256 public tokensRewardForGamma = 1500;
590     uint256 public tokensRewardForDelta = 2500;
591     uint256 public tokensRewardForBeta = 6500;
592     uint256 public tokensRewardForAlpha = 15000;
593     mapping(bytes32 => uint256) public proudLionLastClaim;
594     mapping(uint256 => TokenData) public stake;
595     mapping(address => uint256[]) public userStakedToken;
596 
597     event RewardPaid(address indexed user, uint256 reward);
598 
599     constructor(address _proudLionAddress, address ercTokenAddress) {
600         ProudLionContractAddress = _proudLionAddress;
601         iProudLion = IProudLion(ProudLionContractAddress);
602         iErcToken = IProudLion(ercTokenAddress);       
603     }
604 
605     function setSpecialEvent (uint256 _startDate, uint256 _endDate, uint256 _eventRewardPercentage) public {
606         eventStartDate = _startDate;
607         eventEndDate = _endDate;
608         eventRewardPercentage = _eventRewardPercentage;
609     }
610 
611     function setRewardTokenAddress(address _address) public onlyOwner(){
612 	    ProudLionContractAddress = _address;
613         iErcToken =  IProudLion(_address);
614 	}
615 
616     function setNumberOfTokensRewardForGamma (uint256 _numberOfTokensRewardForGamma) public onlyOwner{
617         tokensRewardForGamma = _numberOfTokensRewardForGamma;
618     }
619 
620     function setNumberOfTokensRewardForAlpha (uint256 _numberOfTokensRewardForAlpha) public onlyOwner{
621         tokensRewardForAlpha = _numberOfTokensRewardForAlpha;
622     }
623 
624     function setNumberOfTokensRewardForOmega(uint256 _numberOfTokensRewardForOmega) public onlyOwner{
625         tokensRewardForOmega = _numberOfTokensRewardForOmega;
626     }
627 
628     function SetNumberOfTokensRewardForBeta(uint256 _numberOfTokensRewardForBeta) public onlyOwner{
629         tokensRewardForBeta = _numberOfTokensRewardForBeta;
630     }
631 
632     function setNumberOfTokensRewardForDelta (uint256 _numberOfTokensRewardForDelta) public onlyOwner{
633         tokensRewardForDelta = _numberOfTokensRewardForDelta;
634     }
635 
636     function stakeTokenForThirtydays(uint256[] memory _tokenId, uint256[] memory _percentage, string[] memory _type) public {
637         require(_tokenId.length == _percentage.length && _tokenId.length == _type.length);
638         uint256 extraRewardPercentage = 0;
639 
640         if(eventStartDate <= block.timestamp && eventEndDate >= block.timestamp){
641             extraRewardPercentage = eventRewardPercentage;
642         }
643 
644         for(uint i = 0; i < _tokenId.length; i++){
645         require(iProudLion.ownerOf(_tokenId[i]) == msg.sender, "Caller does not own the token being claimed for.");
646         uint256 reward = 0;
647         if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Omega")))){
648             reward = tokensRewardForOmega;
649         }
650         else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Gamma")))){
651             reward = tokensRewardForGamma;
652         }else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Delta")))){
653             reward = tokensRewardForDelta;
654         }else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Beta")))){
655             reward = tokensRewardForBeta;
656         }else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Alpha")))){
657             reward = tokensRewardForAlpha;
658         }else{
659             require(false,"Please provide a correct token type");
660         }
661 
662         if(stake[_tokenId[i]].baseRate != 0){
663             require(stake[_tokenId[i]].isStaked == false, "Token is already staked");
664         }
665 
666         userStakedToken[msg.sender].push(_tokenId[i]);
667 
668         uint256 basicReward = (_percentage[i] * reward) / 100;
669 
670         TokenData memory newTokenData;
671         newTokenData.baseRate = ((extraRewardPercentage * basicReward) / 100) + basicReward;
672         newTokenData.isStaked = true;
673         newTokenData.stakeTime = 30;
674         stake[_tokenId[i]] = newTokenData;
675 
676         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId[i]));
677         proudLionLastClaim[lastClaimKey] = block.timestamp;
678 
679         iProudLion.setIsStake(_tokenId[i], true);
680 
681         totalStaked = totalStaked + 1;
682         }
683         
684     }
685 
686     function stakeTokenForSixtydays(uint256[] memory _tokenId, uint256[] memory _percentage, string[] memory _type) public {
687         
688         require(_tokenId.length == _percentage.length && _tokenId.length == _type.length);
689 
690         uint256 extraRewardPercentage = 0;
691 
692         if(eventStartDate <= block.timestamp && eventEndDate >= block.timestamp){
693             extraRewardPercentage = eventRewardPercentage;
694         }
695 
696         for(uint i = 0; i < _tokenId.length; i++){
697         require(iProudLion.ownerOf(_tokenId[i]) == msg.sender, "Caller does not own the token being claimed for.");
698         uint256 reward = 0;
699         if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Omega")))){
700             reward = tokensRewardForOmega;
701         }
702         else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Gamma")))){
703             reward = tokensRewardForGamma;
704         }else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Delta")))){
705             reward = tokensRewardForDelta;
706         }else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Beta")))){
707             reward = tokensRewardForBeta;
708         }else if(keccak256(abi.encodePacked((_type[i]))) == keccak256(abi.encodePacked(("Alpha")))){
709             reward = tokensRewardForAlpha;
710         }else{
711             require(false,"Please provide a correct token type");
712         }
713 
714         if(stake[_tokenId[i]].baseRate != 0){
715             require(stake[_tokenId[i]].isStaked == false, "Token is already staked");
716         }
717 
718         userStakedToken[msg.sender].push(_tokenId[i]);
719 
720         uint256 basicReward = (_percentage[i] * reward) / 100;
721         uint256 extraReward = basicReward + ((10 * basicReward ) / 100);
722         TokenData memory newTokenData;
723         newTokenData.baseRate =  ((extraRewardPercentage * extraReward) / 100) + extraReward;
724         newTokenData.isStaked = true;
725         newTokenData.stakeTime = 60;
726         stake[_tokenId[i]] = newTokenData;
727 
728         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId[i]));
729         proudLionLastClaim[lastClaimKey] = block.timestamp;
730 
731         iProudLion.setIsStake(_tokenId[i], true);
732 
733         totalStaked = totalStaked + 1;
734         }
735         
736     }
737 
738     function claimReward(uint256 _proudLionTokenId) public returns (uint256) {
739         uint256 totalUnclaimedReward = 0;
740         
741         require(stake[_proudLionTokenId].isStaked == true, "Token is not stake yet");
742         require(iProudLion.ownerOf(_proudLionTokenId) == msg.sender, "Caller does not own the token being claimed for.");
743 
744         totalUnclaimedReward = computeUnclaimedReward(_proudLionTokenId);
745 
746         uint256 daysPass = totalUnclaimedReward / stake[_proudLionTokenId].baseRate;
747 
748         require(daysPass >= stake[_proudLionTokenId].stakeTime, "your time is not completed, you cannot claim token");
749 
750         iErcToken.transfer(msg.sender, totalUnclaimedReward  * 10 ** 13);
751         emit RewardPaid(msg.sender, totalUnclaimedReward);
752 
753         bytes32 lastClaimKey = keccak256(abi.encode(_proudLionTokenId));
754         proudLionLastClaim[lastClaimKey] = block.timestamp;
755 
756         return totalUnclaimedReward;
757     }
758 
759     function unStakAndClaimReward(uint256 _proudLionTokenId) public returns (uint256) {
760         uint256 totalUnclaimedReward = 0;
761         
762         require(stake[_proudLionTokenId].isStaked == true, "Token is not stake yet");
763         require(iProudLion.ownerOf(_proudLionTokenId) == msg.sender, "Caller does not own the token being claimed for.");
764 
765         totalUnclaimedReward = computeUnclaimedReward(_proudLionTokenId);
766 
767         uint256 daysPass = totalUnclaimedReward / stake[_proudLionTokenId].baseRate;
768 
769         require(daysPass >= stake[_proudLionTokenId].stakeTime, "your time is not completed, you cannot claim token");
770 
771 
772         stake[_proudLionTokenId].isStaked = false;
773 
774         iProudLion.setIsStake(_proudLionTokenId, false);
775 
776 
777         // mint the tokens and distribute to msg.sender
778         // _mint(msg.sender, totalUnclaimedReward);
779         iErcToken.transfer(msg.sender, totalUnclaimedReward  * 10 ** 13);
780         emit RewardPaid(msg.sender, totalUnclaimedReward);
781         
782         totalStaked = totalStaked - 1;
783 
784         for(uint i = 0; i < userStakedToken[msg.sender].length; i++){
785             if(userStakedToken[msg.sender][i] ==_proudLionTokenId){
786                 delete userStakedToken[msg.sender][i];
787             }
788         }
789 
790         return totalUnclaimedReward;
791     }
792 
793     function claimRewardsForProudLion(uint256[] calldata _proudLionTokenIds) public returns (uint256) {
794 
795         uint256 totalUnclaimedReward = 0;
796 
797         for(uint i = 0; i < _proudLionTokenIds.length; i++) {
798 
799             uint256 _proudLionTokenId = _proudLionTokenIds[i];
800             require(stake[_proudLionTokenId].isStaked == true, "Token is not stake yet");
801 
802 
803             require(iProudLion.ownerOf(_proudLionTokenId) == msg.sender, "Caller does not own the token being claimed for.");
804 
805             uint256 unclaimedReward = computeUnclaimedReward(_proudLionTokenId);
806             
807             uint256 daysPass = unclaimedReward / stake[_proudLionTokenId].baseRate;
808 
809             require(daysPass >= stake[_proudLionTokenId].stakeTime, "your time is not completed, you cannot claim token");
810 
811             totalUnclaimedReward = totalUnclaimedReward + unclaimedReward;
812 
813             bytes32 lastClaimKey = keccak256(abi.encode(_proudLionTokenId));
814             proudLionLastClaim[lastClaimKey] = block.timestamp;
815 
816         }
817         // mint the tokens and distribute to msg.sender
818         // _mint(msg.sender, totalUnclaimedReward);
819         iErcToken.transfer(msg.sender, totalUnclaimedReward * 10 ** 13);
820 
821         emit RewardPaid(msg.sender, totalUnclaimedReward);
822 
823         return totalUnclaimedReward;
824     }
825 
826     function unStakeAndClaimRewardsForProudLion(uint256[] calldata _proudLionTokenIds) public returns (uint256) {
827 
828         uint256 totalUnclaimedReward = 0;
829 
830         for(uint i = 0; i < _proudLionTokenIds.length; i++) {
831 
832             uint256 _proudLionTokenId = _proudLionTokenIds[i];
833             require(stake[_proudLionTokenId].isStaked == true, "Token is not stake yet");
834 
835 
836             require(iProudLion.ownerOf(_proudLionTokenId) == msg.sender, "Caller does not own the token being claimed for.");
837 
838             uint256 unclaimedReward = computeUnclaimedReward(_proudLionTokenId);
839             
840             uint256 daysPass = unclaimedReward / stake[_proudLionTokenId].baseRate;
841 
842             require(daysPass >= stake[_proudLionTokenId].stakeTime, "your time is not completed, you cannot claim token");
843 
844             totalUnclaimedReward = totalUnclaimedReward + unclaimedReward;
845 
846             stake[_proudLionTokenIds[i]].isStaked = false;
847 
848             iProudLion.setIsStake(_proudLionTokenIds[i], false);
849 
850 
851             totalStaked = totalStaked - 1;
852 
853             for(uint j = 0; j < userStakedToken[msg.sender].length; j++){
854             if(userStakedToken[msg.sender][j] ==_proudLionTokenIds[j]){
855                 delete userStakedToken[msg.sender][j];
856             }
857         }
858 
859         }
860         // mint the tokens and distribute to msg.sender
861         // _mint(msg.sender, totalUnclaimedReward);
862         iErcToken.transfer(msg.sender, totalUnclaimedReward * 10 ** 13);
863 
864         emit RewardPaid(msg.sender, totalUnclaimedReward);
865 
866         return totalUnclaimedReward;
867     }
868 
869     function getTokenStakeTime(uint256 _tokenId) public view returns (uint256, uint256) {
870 
871         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
872 
873         return (proudLionLastClaim[lastClaimKey], stake[_tokenId].stakeTime);
874     }
875 
876 
877     function permanentlyLock() public {
878         isLocked = true;
879     }
880 
881     function getUnclaimedRewardAmountForProudLion(uint256 _tokenId) public view returns (uint256) {
882         return computeUnclaimedReward(_tokenId);
883     }
884 
885     function getUnclaimedRewardsAmountForProudLion(uint256[] calldata _tokenIds) public view returns (uint256) {
886 
887         uint256 totalUnclaimedRewards = 0;
888 
889         for(uint256 i = 0; i < _tokenIds.length; i++) {
890             totalUnclaimedRewards += computeUnclaimedReward(_tokenIds[i]);
891         }
892 
893         return totalUnclaimedRewards;
894     }
895 
896     function getProudLionLastClaimedTime(uint256 _tokenId) public view returns (uint256) {
897 
898         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
899 
900         return proudLionLastClaim[lastClaimKey];
901     }
902 
903     function computeAccumulatedReward(uint256 _lastClaimDate, uint256 currentTime) internal pure returns (uint256) {
904         require(currentTime > _lastClaimDate, "Last claim date must be smaller than block timestamp");
905 
906         uint256 secondsElapsed = currentTime - _lastClaimDate;
907         uint256 accumulatedReward = secondsElapsed / 1 days;
908         //uint256 accumulatedReward = secondsElapsed / 4; //for testing
909         
910 
911         return accumulatedReward;
912     }
913     function computeUnclaimedReward(uint256 _tokenId) internal view returns (uint256) {
914 
915         // Will revert if tokenId does not exist
916         iProudLion.ownerOf(_tokenId);
917 
918         if(stake[_tokenId].isStaked == true){
919 
920         // build the hash for lastClaim based on contractAddress and tokenId
921         bytes32 lastClaimKey = keccak256(abi.encode(_tokenId));
922         uint256 lastClaimDate = proudLionLastClaim[lastClaimKey];
923 
924         // if there has been a lastClaim, compute the value since lastClaim
925         uint256 daysPass = computeAccumulatedReward(lastClaimDate, block.timestamp);
926         if(daysPass <= stake[_tokenId].stakeTime){
927             return daysPass * stake[_tokenId].baseRate;
928         }else{
929             return stake[_tokenId].stakeTime * stake[_tokenId].baseRate;
930         }     
931         }else{
932             return 0;
933         }
934     }
935     function setProudLionAddress(address _proudLionAddress) public onlyOwner(){
936 	    ProudLionContractAddress = _proudLionAddress;
937         iProudLion =  IProudLion(_proudLionAddress);
938 	}
939 }