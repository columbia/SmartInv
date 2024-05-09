1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
185 
186 
187 
188 pragma solidity ^0.8.0;
189 
190 
191 /**
192  * @dev Interface for the optional metadata functions from the ERC20 standard.
193  *
194  * _Available since v4.1._
195  */
196 interface IERC20Metadata is IERC20 {
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the symbol of the token.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the decimals places of the token.
209      */
210     function decimals() external view returns (uint8);
211 }
212 
213 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
214 
215 
216 
217 pragma solidity ^0.8.0;
218 
219 
220 
221 
222 /**
223  * @dev Implementation of the {IERC20} interface.
224  *
225  * This implementation is agnostic to the way tokens are created. This means
226  * that a supply mechanism has to be added in a derived contract using {_mint}.
227  * For a generic mechanism see {ERC20PresetMinterPauser}.
228  *
229  * TIP: For a detailed writeup see our guide
230  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
231  * to implement supply mechanisms].
232  *
233  * We have followed general OpenZeppelin Contracts guidelines: functions revert
234  * instead returning `false` on failure. This behavior is nonetheless
235  * conventional and does not conflict with the expectations of ERC20
236  * applications.
237  *
238  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
239  * This allows applications to reconstruct the allowance for all accounts just
240  * by listening to said events. Other implementations of the EIP may not emit
241  * these events, as it isn't required by the specification.
242  *
243  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
244  * functions have been added to mitigate the well-known issues around setting
245  * allowances. See {IERC20-approve}.
246  */
247 contract ERC20 is Context, IERC20, IERC20Metadata {
248     mapping(address => uint256) private _balances;
249 
250     mapping(address => mapping(address => uint256)) private _allowances;
251 
252     uint256 private _totalSupply;
253 
254     string private _name;
255     string private _symbol;
256 
257     /**
258      * @dev Sets the values for {name} and {symbol}.
259      *
260      * The default value of {decimals} is 18. To select a different value for
261      * {decimals} you should overload it.
262      *
263      * All two of these values are immutable: they can only be set once during
264      * construction.
265      */
266     constructor(string memory name_, string memory symbol_) {
267         _name = name_;
268         _symbol = symbol_;
269     }
270 
271     /**
272      * @dev Returns the name of the token.
273      */
274     function name() public view virtual override returns (string memory) {
275         return _name;
276     }
277 
278     /**
279      * @dev Returns the symbol of the token, usually a shorter version of the
280      * name.
281      */
282     function symbol() public view virtual override returns (string memory) {
283         return _symbol;
284     }
285 
286     /**
287      * @dev Returns the number of decimals used to get its user representation.
288      * For example, if `decimals` equals `2`, a balance of `505` tokens should
289      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
290      *
291      * Tokens usually opt for a value of 18, imitating the relationship between
292      * Ether and Wei. This is the value {ERC20} uses, unless this function is
293      * overridden;
294      *
295      * NOTE: This information is only used for _display_ purposes: it in
296      * no way affects any of the arithmetic of the contract, including
297      * {IERC20-balanceOf} and {IERC20-transfer}.
298      */
299     function decimals() public view virtual override returns (uint8) {
300         return 18;
301     }
302 
303     /**
304      * @dev See {IERC20-totalSupply}.
305      */
306     function totalSupply() public view virtual override returns (uint256) {
307         return _totalSupply;
308     }
309 
310     /**
311      * @dev See {IERC20-balanceOf}.
312      */
313     function balanceOf(address account) public view virtual override returns (uint256) {
314         return _balances[account];
315     }
316 
317     /**
318      * @dev See {IERC20-transfer}.
319      *
320      * Requirements:
321      *
322      * - `recipient` cannot be the zero address.
323      * - the caller must have a balance of at least `amount`.
324      */
325     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
326         _transfer(_msgSender(), recipient, amount);
327         return true;
328     }
329 
330     /**
331      * @dev See {IERC20-allowance}.
332      */
333     function allowance(address owner, address spender) public view virtual override returns (uint256) {
334         return _allowances[owner][spender];
335     }
336 
337     /**
338      * @dev See {IERC20-approve}.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      */
344     function approve(address spender, uint256 amount) public virtual override returns (bool) {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-transferFrom}.
351      *
352      * Emits an {Approval} event indicating the updated allowance. This is not
353      * required by the EIP. See the note at the beginning of {ERC20}.
354      *
355      * Requirements:
356      *
357      * - `sender` and `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      * - the caller must have allowance for ``sender``'s tokens of at least
360      * `amount`.
361      */
362     function transferFrom(
363         address sender,
364         address recipient,
365         uint256 amount
366     ) public virtual override returns (bool) {
367         _transfer(sender, recipient, amount);
368 
369         uint256 currentAllowance = _allowances[sender][_msgSender()];
370         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
371         unchecked {
372             _approve(sender, _msgSender(), currentAllowance - amount);
373         }
374 
375         return true;
376     }
377 
378     /**
379      * @dev Atomically increases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
392         return true;
393     }
394 
395     /**
396      * @dev Atomically decreases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      * - `spender` must have allowance for the caller of at least
407      * `subtractedValue`.
408      */
409     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
410         uint256 currentAllowance = _allowances[_msgSender()][spender];
411         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
412         unchecked {
413             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
414         }
415 
416         return true;
417     }
418 
419     /**
420      * @dev Moves `amount` of tokens from `sender` to `recipient`.
421      *
422      * This internal function is equivalent to {transfer}, and can be used to
423      * e.g. implement automatic token fees, slashing mechanisms, etc.
424      *
425      * Emits a {Transfer} event.
426      *
427      * Requirements:
428      *
429      * - `sender` cannot be the zero address.
430      * - `recipient` cannot be the zero address.
431      * - `sender` must have a balance of at least `amount`.
432      */
433     function _transfer(
434         address sender,
435         address recipient,
436         uint256 amount
437     ) internal virtual {
438         require(sender != address(0), "ERC20: transfer from the zero address");
439         require(recipient != address(0), "ERC20: transfer to the zero address");
440 
441         _beforeTokenTransfer(sender, recipient, amount);
442 
443         uint256 senderBalance = _balances[sender];
444         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
445         unchecked {
446             _balances[sender] = senderBalance - amount;
447         }
448         _balances[recipient] += amount;
449 
450         emit Transfer(sender, recipient, amount);
451 
452         _afterTokenTransfer(sender, recipient, amount);
453     }
454 
455     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
456      * the total supply.
457      *
458      * Emits a {Transfer} event with `from` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      */
464     function _mint(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: mint to the zero address");
466 
467         _beforeTokenTransfer(address(0), account, amount);
468 
469         _totalSupply += amount;
470         _balances[account] += amount;
471         emit Transfer(address(0), account, amount);
472 
473         _afterTokenTransfer(address(0), account, amount);
474     }
475 
476     /**
477      * @dev Destroys `amount` tokens from `account`, reducing the
478      * total supply.
479      *
480      * Emits a {Transfer} event with `to` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      * - `account` must have at least `amount` tokens.
486      */
487     function _burn(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: burn from the zero address");
489 
490         _beforeTokenTransfer(account, address(0), amount);
491 
492         uint256 accountBalance = _balances[account];
493         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
494         unchecked {
495             _balances[account] = accountBalance - amount;
496         }
497         _totalSupply -= amount;
498 
499         emit Transfer(account, address(0), amount);
500 
501         _afterTokenTransfer(account, address(0), amount);
502     }
503 
504     /**
505      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
506      *
507      * This internal function is equivalent to `approve`, and can be used to
508      * e.g. set automatic allowances for certain subsystems, etc.
509      *
510      * Emits an {Approval} event.
511      *
512      * Requirements:
513      *
514      * - `owner` cannot be the zero address.
515      * - `spender` cannot be the zero address.
516      */
517     function _approve(
518         address owner,
519         address spender,
520         uint256 amount
521     ) internal virtual {
522         require(owner != address(0), "ERC20: approve from the zero address");
523         require(spender != address(0), "ERC20: approve to the zero address");
524 
525         _allowances[owner][spender] = amount;
526         emit Approval(owner, spender, amount);
527     }
528 
529     /**
530      * @dev Hook that is called before any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * will be transferred to `to`.
537      * - when `from` is zero, `amount` tokens will be minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _beforeTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 
549     /**
550      * @dev Hook that is called after any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * has been transferred to `to`.
557      * - when `from` is zero, `amount` tokens have been minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _afterTokenTransfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {}
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
571 
572 
573 
574 pragma solidity ^0.8.0;
575 
576 
577 
578 /**
579  * @dev Extension of {ERC20} that allows token holders to destroy both their own
580  * tokens and those that they have an allowance for, in a way that can be
581  * recognized off-chain (via event analysis).
582  */
583 abstract contract ERC20Burnable is Context, ERC20 {
584     /**
585      * @dev Destroys `amount` tokens from the caller.
586      *
587      * See {ERC20-_burn}.
588      */
589     function burn(uint256 amount) public virtual {
590         _burn(_msgSender(), amount);
591     }
592 
593     /**
594      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
595      * allowance.
596      *
597      * See {ERC20-_burn} and {ERC20-allowance}.
598      *
599      * Requirements:
600      *
601      * - the caller must have allowance for ``accounts``'s tokens of at least
602      * `amount`.
603      */
604     function burnFrom(address account, uint256 amount) public virtual {
605         uint256 currentAllowance = allowance(account, _msgSender());
606         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
607         unchecked {
608             _approve(account, _msgSender(), currentAllowance - amount);
609         }
610         _burn(account, amount);
611     }
612 }
613 
614 // File: contracts/wulfzstaking.sol
615 
616 
617 pragma solidity ^0.8.4;
618 
619 
620 
621 interface IWulfzNFT {
622     function transferFrom(address _from, address _to, uint256 _tokenId) external;
623 }
624 
625 contract AWOO is ERC20Burnable, Ownable {
626     uint256 public constant MAX_SUPPLY = 200000000 * 1 ether;
627     uint256 public constant ALPHA_EMISSION_RATE = 50; // 50 per day
628     uint256 public constant WULFZ_EMISSION_RATE = 10; // 10 per day
629     uint256 public constant PUPZ_EMISSION_RATE = 5; // 5 per day
630     address public constant WULFZ_ADDRESS = 0x9712228cEeDA1E2dDdE52Cd5100B88986d1Cb49c;
631     bool public live = false;
632 
633     mapping(uint256 => uint256) internal wulfzTimeStaked;
634     mapping(uint256 => address) internal wulfzStaker;
635     mapping(address => uint256[]) internal stakerToWulfz;
636         
637     IWulfzNFT private constant _wulfzContract = IWulfzNFT(WULFZ_ADDRESS);
638 
639     constructor() ERC20("AWOO", "AWOO") {
640         _mint(msg.sender, 2100 * 1 ether);
641     }
642 
643     modifier stakingEnabled {
644         require(live, "NOT_LIVE");
645         _;
646     }
647 
648     function getStakedWulfz(address staker) public view returns (uint256[] memory) {
649         return stakerToWulfz[staker];
650     }
651     
652     function getStakedAmount(address staker) public view returns (uint256) {
653         return stakerToWulfz[staker].length;
654     }
655 
656     function getStaker(uint256 tokenId) public view returns (address) {
657         return wulfzStaker[tokenId];
658     }
659 
660     function getAllRewards(address staker) public view returns (uint256) {
661         uint256 totalRewards = 0;
662 
663         uint256[] memory wulfzTokens = stakerToWulfz[staker];
664         for (uint256 i = 0; i < wulfzTokens.length; i++) {
665             totalRewards += getReward(wulfzTokens[i]);
666         }
667 
668         return totalRewards;
669     }
670 
671     function stakeWulfzById(uint256[] calldata tokenIds) external stakingEnabled {
672         for (uint256 i = 0; i < tokenIds.length; i++) {
673             uint256 id = tokenIds[i];
674             _wulfzContract.transferFrom(msg.sender, address(this), id);
675 
676             stakerToWulfz[msg.sender].push(id);
677             wulfzTimeStaked[id] = block.timestamp;
678             wulfzStaker[id] = msg.sender;
679         }
680     }
681 
682     function unstakeWulfzByIds(uint256[] calldata tokenIds) external {
683         uint256 totalRewards = 0;
684 
685         for (uint256 i = 0; i < tokenIds.length; i++) {
686             uint256 id = tokenIds[i];
687             require(wulfzStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
688 
689             _wulfzContract.transferFrom(address(this), msg.sender, id);
690             totalRewards += getReward(id);
691 
692             removeTokenIdFromArray(stakerToWulfz[msg.sender], id);
693             wulfzStaker[id] = address(0);
694         }
695 
696         uint256 remaining = MAX_SUPPLY - totalSupply();
697         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
698     }
699 
700     function unstakeAll() external {
701         require(getStakedAmount(msg.sender) > 0, "NONE_STAKED");
702         uint256 totalRewards = 0;
703 
704         for (uint256 i = stakerToWulfz[msg.sender].length; i > 0; i--) {
705             uint256 id = stakerToWulfz[msg.sender][i - 1];
706 
707             _wulfzContract.transferFrom(address(this), msg.sender, id);
708             totalRewards += getReward(id);
709 
710             stakerToWulfz[msg.sender].pop();
711             wulfzStaker[id] = address(0);
712         }
713 
714         uint256 remaining = MAX_SUPPLY - totalSupply();
715         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
716     }
717 
718     function claimAll() external {
719         uint256 totalRewards = 0;
720 
721         uint256[] memory wulfzTokens = stakerToWulfz[msg.sender];
722         for (uint256 i = 0; i < wulfzTokens.length; i++) {
723             uint256 id = wulfzTokens[i];
724 
725             totalRewards += getReward(id);
726             wulfzTimeStaked[id] = block.timestamp;
727         }
728 
729         uint256 remaining = MAX_SUPPLY - totalSupply();
730         _mint(msg.sender, totalRewards > remaining ? remaining : totalRewards);
731     }
732 
733     function burn(address from, uint256 amount) external {
734         require(msg.sender == WULFZ_ADDRESS, "NOT_AUTHORIZED");
735 
736         _burn(from, amount);
737     }
738     
739     function toggle() external onlyOwner {
740         live = !live;
741     }
742 
743     function getReward(uint256 tokenId) internal view returns(uint256) {
744         uint256 EMISSION_RATE;
745         if (tokenId < 5601) {
746             EMISSION_RATE = WULFZ_EMISSION_RATE;
747         } else if (tokenId < 6001) {
748             EMISSION_RATE = ALPHA_EMISSION_RATE;
749         } else {
750             EMISSION_RATE = PUPZ_EMISSION_RATE;
751         }
752 
753         return (block.timestamp - wulfzTimeStaked[tokenId]) * EMISSION_RATE / 86400 * 1 ether;
754     }
755 
756     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
757         uint256 length = array.length;
758         for (uint256 i = 0; i < length; i++) {
759             if (array[i] == tokenId) {
760                 length--;
761                 if (i < length) {
762                     array[i] = array[length];
763                 }
764                 array.pop();
765                 break;
766             }
767         }
768     }
769 }