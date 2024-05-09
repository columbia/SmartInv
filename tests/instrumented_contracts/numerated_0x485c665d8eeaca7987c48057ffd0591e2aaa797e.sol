1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.10;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 contract ERC20 is Context, IERC20 {
88     mapping (address => uint256) private _balances;
89 
90     mapping (address => mapping (address => uint256)) private _allowances;
91 
92     uint256 private _totalSupply;
93 
94     string private _name;
95     string private _symbol;
96 
97     /**
98      * @dev Sets the values for {name} and {symbol}.
99      *
100      * The defaut value of {decimals} is 18. To select a different value for
101      * {decimals} you should overload it.
102      *
103      * All three of these values are immutable: they can only be set once during
104      * construction.
105      */
106     constructor (string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() public view virtual returns (string memory) {
115         return _name;
116     }
117 
118     /**
119      * @dev Returns the symbol of the token, usually a shorter version of the
120      * name.
121      */
122     function symbol() public view virtual returns (string memory) {
123         return _symbol;
124     }
125 
126     /**
127      * @dev Returns the number of decimals used to get its user representation.
128      * For example, if `decimals` equals `2`, a balance of `505` tokens should
129      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
130      *
131      * Tokens usually opt for a value of 18, imitating the relationship between
132      * Ether and Wei. This is the value {ERC20} uses, unless this function is
133      * overloaded;
134      *
135      * NOTE: This information is only used for _display_ purposes: it in
136      * no way affects any of the arithmetic of the contract, including
137      * {IERC20-balanceOf} and {IERC20-transfer}.
138      */
139     function decimals() public view virtual returns (uint8) {
140         return 18;
141     }
142 
143     /**
144      * @dev See {IERC20-totalSupply}.
145      */
146     function totalSupply() public view virtual override returns (uint256) {
147         return _totalSupply;
148     }
149 
150     /**
151      * @dev See {IERC20-balanceOf}.
152      */
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     /**
158      * @dev See {IERC20-transfer}.
159      *
160      * Requirements:
161      *
162      * - `recipient` cannot be the zero address.
163      * - the caller must have a balance of at least `amount`.
164      */
165     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     /**
171      * @dev See {IERC20-allowance}.
172      */
173     function allowance(address owner, address spender) public view virtual override returns (uint256) {
174         return _allowances[owner][spender];
175     }
176 
177     /**
178      * @dev See {IERC20-approve}.
179      *
180      * Requirements:
181      *
182      * - `spender` cannot be the zero address.
183      */
184     function approve(address spender, uint256 amount) public virtual override returns (bool) {
185         _approve(_msgSender(), spender, amount);
186         return true;
187     }
188 
189     /**
190      * @dev See {IERC20-transferFrom}.
191      *
192      * Emits an {Approval} event indicating the updated allowance. This is not
193      * required by the EIP. See the note at the beginning of {ERC20}.
194      *
195      * Requirements:
196      *
197      * - `sender` and `recipient` cannot be the zero address.
198      * - `sender` must have a balance of at least `amount`.
199      * - the caller must have allowance for ``sender``'s tokens of at least
200      * `amount`.
201      */
202     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
203         _transfer(sender, recipient, amount);
204 
205         uint256 currentAllowance = _allowances[sender][_msgSender()];
206         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
207         _approve(sender, _msgSender(), currentAllowance - amount);
208 
209         return true;
210     }
211 
212     /**
213      * @dev Atomically increases the allowance granted to `spender` by the caller.
214      *
215      * This is an alternative to {approve} that can be used as a mitigation for
216      * problems described in {IERC20-approve}.
217      *
218      * Emits an {Approval} event indicating the updated allowance.
219      *
220      * Requirements:
221      *
222      * - `spender` cannot be the zero address.
223      */
224     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
225         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
226         return true;
227     }
228 
229     /**
230      * @dev Atomically decreases the allowance granted to `spender` by the caller.
231      *
232      * This is an alternative to {approve} that can be used as a mitigation for
233      * problems described in {IERC20-approve}.
234      *
235      * Emits an {Approval} event indicating the updated allowance.
236      *
237      * Requirements:
238      *
239      * - `spender` cannot be the zero address.
240      * - `spender` must have allowance for the caller of at least
241      * `subtractedValue`.
242      */
243     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
244         uint256 currentAllowance = _allowances[_msgSender()][spender];
245         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
246         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
247 
248         return true;
249     }
250 
251     /**
252      * @dev Moves tokens `amount` from `sender` to `recipient`.
253      *
254      * This is internal function is equivalent to {transfer}, and can be used to
255      * e.g. implement automatic token fees, slashing mechanisms, etc.
256      *
257      * Emits a {Transfer} event.
258      *
259      * Requirements:
260      *
261      * - `sender` cannot be the zero address.
262      * - `recipient` cannot be the zero address.
263      * - `sender` must have a balance of at least `amount`.
264      */
265     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
266         require(sender != address(0), "ERC20: transfer from the zero address");
267         require(recipient != address(0), "ERC20: transfer to the zero address");
268 
269         _beforeTokenTransfer(sender, recipient, amount);
270 
271         uint256 senderBalance = _balances[sender];
272         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
273         _balances[sender] = senderBalance - amount;
274         _balances[recipient] += amount;
275 
276         emit Transfer(sender, recipient, amount);
277     }
278 
279     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
280      * the total supply.
281      *
282      * Emits a {Transfer} event with `from` set to the zero address.
283      *
284      * Requirements:
285      *
286      * - `to` cannot be the zero address.
287      */
288     function _mint(address account, uint256 amount) internal virtual {
289         require(account != address(0), "ERC20: mint to the zero address");
290 
291         _beforeTokenTransfer(address(0), account, amount);
292 
293         _totalSupply += amount;
294         _balances[account] += amount;
295         emit Transfer(address(0), account, amount);
296     }
297 
298     /**
299      * @dev Destroys `amount` tokens from `account`, reducing the
300      * total supply.
301      *
302      * Emits a {Transfer} event with `to` set to the zero address.
303      *
304      * Requirements:
305      *
306      * - `account` cannot be the zero address.
307      * - `account` must have at least `amount` tokens.
308      */
309     function _burn(address account, uint256 amount) internal virtual {
310         require(account != address(0), "ERC20: burn from the zero address");
311 
312         _beforeTokenTransfer(account, address(0), amount);
313 
314         uint256 accountBalance = _balances[account];
315         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
316         _balances[account] = accountBalance - amount;
317         _totalSupply -= amount;
318 
319         emit Transfer(account, address(0), amount);
320     }
321 
322     /**
323      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
324      *
325      * This internal function is equivalent to `approve`, and can be used to
326      * e.g. set automatic allowances for certain subsystems, etc.
327      *
328      * Emits an {Approval} event.
329      *
330      * Requirements:
331      *
332      * - `owner` cannot be the zero address.
333      * - `spender` cannot be the zero address.
334      */
335     function _approve(address owner, address spender, uint256 amount) internal virtual {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338 
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 
343     /**
344      * @dev Hook that is called before any transfer of tokens. This includes
345      * minting and burning.
346      *
347      * Calling conditions:
348      *
349      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
350      * will be to transferred to `to`.
351      * - when `from` is zero, `amount` tokens will be minted for `to`.
352      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
353      * - `from` and `to` are never both zero.
354      *
355      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
356      */
357     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
358 }
359 
360 
361 library SafeMath {
362   	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
363 		uint256 c = a * b;
364 		assert(a == 0 || c / a == b);
365 		return c;
366   	}
367 
368   	function div(uint256 a, uint256 b) internal pure returns (uint256) {
369 	    uint256 c = a / b;
370 		return c;
371   	}
372 
373   	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
374 		assert(b <= a);
375 		return a - b;
376   	}
377 
378   	function add(uint256 a, uint256 b) internal pure returns (uint256) {
379 		uint256 c = a + b;
380 		assert(c >= a);
381 		return c;
382 	}
383 }
384 
385 abstract contract OwnerHelper {
386   	address private _owner;
387 
388   	event OwnershipTransferred(address indexed preOwner, address indexed nextOwner);
389 
390   	modifier onlyOwner {
391 		require(msg.sender == _owner, "OwnerHelper: caller is not owner");
392 		_;
393   	}
394 
395   	constructor() {
396             _owner = msg.sender;
397   	}
398 
399        function owner() public view virtual returns (address) {
400            return _owner;
401        }
402 
403   	function transferOwnership(address newOwner) onlyOwner public {
404             require(newOwner != _owner);
405             require(newOwner != address(0x0));
406             address preOwner = _owner;
407     	    _owner = newOwner;
408     	    emit OwnershipTransferred(preOwner, newOwner);
409   	}
410 }
411 
412 contract MetaMundoToken is IERC20, OwnerHelper {
413 
414     using SafeMath for uint256;
415 
416     uint256 public constant SECONDS_IN_A_MONTH = 2_628_288;
417 
418     address public constant WALLET_TOKEN_SALE = address(0x71677dDADB4be1F2C15ae722B5665475bF7Bed7f);
419     address public constant WALLET_ECO_SYSTEM = address(0x5668b3fa2D82505c89213f7aa53CcaCcc8620e15);
420     address public constant WALLET_RnD = address(0x4ef5a9FC33B33cDEf3A866aFA1F5aF092bD9B9B5);
421     address public constant WALLET_MARKETING = address(0x9De31f65f4e32C1b157925b73ec161b8CAf3947C);
422     address public constant WALLET_TEAM_N_ADVISOR = address(0x8ac0fDdca4488Ae52ecCF50a56b67A3fE8e5Ddae);
423     address public constant WALLET_IDO = address(0xC4dC6aca12B41a2339DEb3d797834547D5A99Dac);
424     address public constant WALLET_DEV = address(0x15A1BFc48e5C90e5820edE03BBBf491930643824);
425     address public constant WALLET_STRATEGIC_PARTNERSHIP = address(0xB0AF6F69b1420b0A9a062B09f7e8fEeDd802FA27);
426 
427     uint256 public constant SUPPLY_TOKEN_SALE = 200_000_000e18;
428     uint256 public constant SUPPLY_ECO_SYSTEM = 600_000_000e18;
429     uint256 public constant SUPPLY_RnD = 400_000_000e18;
430     uint256 public constant SUPPLY_MARKETING = 200_000_000e18;
431     uint256 public constant SUPPLY_TEAM_N_ADVISOR = 200_000_000e18;
432     uint256 public constant SUPPLY_IDO = 200_000_000e18;
433     uint256 public constant SUPPLY_DEV = 100_000_000e18;
434     uint256 public constant SUPPLY_STRATEGIC_PARTNERSHIP = 100_000_000e18;
435 
436     mapping (address => uint256) private _balances;
437     mapping (address => mapping (address => uint256)) public _allowances;
438 
439     uint256 private _totalSupply;
440     string private _name;
441     string private _symbol;
442     
443     uint public _deployTime;
444     
445     constructor(string memory name_, string memory symbol_) 
446     {
447         _name = name_;
448         _symbol = symbol_;
449         _totalSupply = 2_000_000_000e18;
450         _balances[msg.sender] = _totalSupply;
451         _deployTime = block.timestamp;
452     }
453     
454     function name() public view returns (string memory) 
455     {
456         return _name;
457     }
458     
459     function symbol() public view returns (string memory) 
460     {
461         return _symbol;
462     }
463     
464     function decimals() public pure returns (uint8) 
465     {
466         return 18;
467     }
468     
469     function totalSupply() external view virtual override returns (uint256) 
470     {
471         return _totalSupply;
472     }
473 
474     function deployTime() external view returns (uint)
475     {
476         return _deployTime;
477     }
478 
479     function balanceOf(address account) external view virtual override returns (uint256) 
480     {
481         return _balances[account];
482     }
483     
484     function transfer(address recipient, uint amount) public virtual override returns (bool) 
485     {
486         _transfer(msg.sender, recipient, amount);
487         emit Transfer(msg.sender, recipient, amount);
488         return true;
489     }
490     
491     function allowance(address owner, address spender) external view override returns (uint256) 
492     {
493         return _allowances[owner][spender];
494     }
495     
496     function approve(address spender, uint amount) external virtual override returns (bool) 
497     {
498         uint256 currentAllownace = _allowances[msg.sender][spender];
499         require(currentAllownace >= amount, "ERC20: Transfer amount exceeds allowance");
500         _approve(msg.sender, spender, currentAllownace, amount);
501         return true;
502     }
503     
504     function _approve(address owner, address spender, uint256 currentAmount, uint256 amount) internal virtual 
505     {
506         require(owner != address(0), "ERC20: approve from the zero address");
507         require(spender != address(0), "ERC20: approve to the zero address");
508         require(currentAmount == _allowances[owner][spender], "ERC20: invalid currentAmount");
509         _allowances[owner][spender] = amount;
510         emit Approval(owner, spender, amount);
511     }
512 
513     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) 
514     {
515         _transfer(sender, recipient, amount);
516         emit Transfer(sender, recipient, amount);
517         uint256 currentAllowance = _allowances[sender][msg.sender];
518         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
519         _approve(sender, msg.sender, currentAllowance, currentAllowance - amount);
520         return true;
521     }
522 
523     function _transfer(address sender, address recipient, uint256 amount) internal virtual 
524     {
525         require(sender != address(0), "ERC20: transfer from the zero address");
526         require(recipient != address(0), "ERC20: transfer to the zero address");
527         require(isCanTransfer(sender, amount) == true, "TokenLock: invalid token transfer");
528         uint256 senderBalance = _balances[sender];
529         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
530         _balances[sender] = senderBalance.sub(amount);
531         _balances[recipient] = _balances[recipient].add(amount);
532     }
533     
534     function isCanTransfer(address holder, uint256 amount) public view returns (bool)
535     {
536         if(holder == WALLET_TOKEN_SALE)
537         {
538             return true;
539         }
540         // EcoSystem
541         else if(holder == WALLET_ECO_SYSTEM)
542         {
543             uint releaseTime = _deployTime;
544             if(releaseTime <= block.timestamp)
545             {
546                 // 물량의 15퍼센트만 해제된다.
547                 uint256 releasableBalance = (SUPPLY_ECO_SYSTEM / 100) * 15;
548                 
549                 // 지나간 달을 구한다.
550                 uint pastMonth = ((block.timestamp - releaseTime) / SECONDS_IN_A_MONTH) + 1;
551                 uint256 releasedBalance = pastMonth * (releasableBalance / 36);
552                 if(releasedBalance >= amount && _balances[holder] >= amount)
553                 {
554                     return true;
555                 }
556 
557                 return false;
558             }
559             // 여기 들어올일이 없지만 예외처리
560             else 
561             {
562                 return false;
563             }
564         }
565         // R&D
566         else if(holder == WALLET_RnD)
567         {
568             // 3개월 락업 이후
569             uint releaseTime = _deployTime + SECONDS_IN_A_MONTH * 3;
570             if(releaseTime <= block.timestamp)
571             {
572                 // 3개월 락업 이후 계산 하는거니까 3빼줌
573                 uint pastMonth = ((block.timestamp - releaseTime) / SECONDS_IN_A_MONTH) - 3;
574                 uint256 releasedBalance = pastMonth * (SUPPLY_RnD / 36);
575                 if(releasedBalance >= amount && _balances[holder] >= amount)
576                 {
577                     return true;
578                 }
579                 return false;
580             }
581             else 
582             {
583                 return false;
584             }            
585         }
586         // Marketing
587         else if(holder == WALLET_MARKETING)
588         {
589             // 매월 해제
590             uint releaseTime = _deployTime;
591             if(releaseTime <= block.timestamp)
592             {
593                 // 첫달 부터 해제 되니까
594                 uint pastMonth = ((block.timestamp - releaseTime) / SECONDS_IN_A_MONTH) + 1;
595                 uint256 releasedBalance = pastMonth * (SUPPLY_MARKETING / 36);
596                 if(releasedBalance >= amount && _balances[holder] >= amount)
597                 {
598                     return true;
599                 }
600                 return false;
601             }
602             else
603             {
604                 return false;
605             }
606         }
607         // Team & Advisor
608         else if(holder == WALLET_TEAM_N_ADVISOR)
609         {
610             // 5개월 동안 락
611             uint releaseTime = _deployTime + (SECONDS_IN_A_MONTH * 5);
612             if(releaseTime <= block.timestamp)
613             {
614                 // 48개월 동안 해제 단 5개월 이후니까 5를 빼줘야 함
615                 //uint pastMonth = SafeMath.div(block.timestamp - releaseTime, SECONDS_IN_A_MONTH) - 5;
616                 uint pastMonth = ((block.timestamp - releaseTime) / SECONDS_IN_A_MONTH) - 5;
617                     uint256 releasedBalance = pastMonth * (SUPPLY_TEAM_N_ADVISOR / 48);
618                     if(releasedBalance >= amount && _balances[holder] >= amount)
619                     {
620                         return true;
621                     }
622                 return false;
623             }
624             else 
625             {
626                 return false;
627             }
628         }
629         // IDO
630         else if(holder == WALLET_IDO)
631         {
632             // 발행후 바로 해제
633             uint releaseTime = _deployTime;
634             if(releaseTime <= block.timestamp)
635             {
636                 // 첫달 부터 해제니까 +1
637                 uint pastMonth = SafeMath.div(block.timestamp - releaseTime, SECONDS_IN_A_MONTH) + 1;
638                     uint256 releasedBalance = pastMonth * (SUPPLY_IDO / 48);
639                     if(releasedBalance >= amount && _balances[holder] >= amount)
640                     {
641                         return true;
642                     }
643 
644                 return false;
645             }
646             else 
647             {
648                 return false;
649             }
650         }
651         // Dev
652         else if(holder == WALLET_DEV)
653         {
654             // 발행후 바로 해제
655             uint releaseTime = _deployTime;
656             if(releaseTime <= block.timestamp)
657             {
658                 // 첫달 부터 해제니까 +1
659                 uint pastMonth = SafeMath.div(block.timestamp - releaseTime, SECONDS_IN_A_MONTH) + 1;
660                     uint256 releasedBalance = pastMonth * (SUPPLY_DEV / 36);
661                     if(releasedBalance >= amount && _balances[holder] >= amount)
662                     {
663                         return true;
664                     }
665 
666                 return false;
667             }
668             else 
669             {
670                 return false;
671             }
672         }
673         // Stategic Partnership
674         else if(holder == WALLET_STRATEGIC_PARTNERSHIP)
675         {
676             // 5개월 후 해제
677             uint releaseTime = _deployTime + (SECONDS_IN_A_MONTH * 5);
678             if(releaseTime <= block.timestamp)
679             {
680                 // 5개월 이후니까 -5
681                 uint pastMonth = SafeMath.div(block.timestamp - releaseTime, SECONDS_IN_A_MONTH) - 5;
682                     uint256 releasedBalance = pastMonth * (SUPPLY_STRATEGIC_PARTNERSHIP / 36);
683                     if(releasedBalance >= amount && _balances[holder] >= amount)
684                     {
685                         return true;
686                     }
687                 return false;
688             }
689             else 
690             {
691                 return false;
692             }
693         }
694         
695         return true;
696     }
697 }