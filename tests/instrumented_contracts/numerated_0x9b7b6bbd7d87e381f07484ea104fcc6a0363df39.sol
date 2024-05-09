1 pragma solidity ^0.6.2;
2 
3 library Address {
4 
5     function isContract(address account) internal view returns (bool) {
6 
7         bytes32 codehash;
8         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
9         assembly { codehash := extcodehash(account) }
10         return (codehash != accountHash && codehash != 0x0);
11     }
12 
13     function sendValue(address payable recipient, uint256 amount) internal {
14         require(address(this).balance >= amount, "Address: insufficient balance");
15 
16         (bool success, ) = recipient.call{ value: amount }("");
17         require(success, "Address: unable to send value, recipient may have reverted");
18     }
19 
20     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
21       return functionCall(target, data, "Address: low-level call failed");
22     }
23 
24     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
25         return _functionCallWithValue(target, data, 0, errorMessage);
26     }
27 
28     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
29         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
30     }
31 
32     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
33         require(address(this).balance >= value, "Address: insufficient balance for call");
34         return _functionCallWithValue(target, data, value, errorMessage);
35     }
36 
37     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
38         require(isContract(target), "Address: call to non-contract");
39 
40         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
41         if (success) {
42             return returndata;
43         } else {
44             if (returndata.length > 0) {
45                 assembly {
46                     let returndata_size := mload(returndata)
47                     revert(add(32, returndata), returndata_size)
48                 }
49             } else {
50                 revert(errorMessage);
51             }
52         }
53     }
54 }
55 
56 pragma solidity ^0.6.0;
57 
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address payable) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes memory) {
64         this;
65         return msg.data;
66     }
67 }
68 
69 interface IERC20 {
70     
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address account) external view returns (uint256);
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78     
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 library SafeMath {
89    
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100   
101     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119   
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(a, b, "SafeMath: division by zero");
122     }
123 
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         return c;
128     }
129 
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return mod(a, b, "SafeMath: modulo by zero");
132     }
133 
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 
139     function toInt256Safe(uint256 a) internal pure returns (int256) {
140     int256 b = int256(a);
141     require(b >= 0);
142     return b;
143   }
144 }
145 
146 
147 library SignedSafeMath {
148     int256 constant private _INT256_MIN = -2**255;
149 
150     function mul(int256 a, int256 b) internal pure returns (int256) {
151         if (a == 0) {
152             return 0;
153         }
154 
155         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
156 
157         int256 c = a * b;
158         require(c / a == b, "SignedSafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     function div(int256 a, int256 b) internal pure returns (int256) {
164         require(b != 0, "SignedSafeMath: division by zero");
165         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
166 
167         int256 c = a / b;
168 
169         return c;
170     }
171 
172     function sub(int256 a, int256 b) internal pure returns (int256) {
173         int256 c = a - b;
174         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
175 
176         return c;
177     }
178 
179     function add(int256 a, int256 b) internal pure returns (int256) {
180         int256 c = a + b;
181         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
182 
183         return c; 
184     }
185 
186     function toUint256Safe(int256 a) internal pure returns (uint256) {
187         require(a >= 0);
188         return uint256(a);
189   }
190 }
191 
192 
193 contract ERC20 is Context, IERC20 {
194     using SafeMath for uint256;
195     using Address for address;
196 
197     mapping (address => uint256) private _balances;
198 
199     mapping (address => mapping (address => uint256)) private _allowances;
200 
201     uint256 private _totalSupply;
202 
203     string private _name;
204     string private _symbol;
205     uint8 private _decimals;
206     address private _owner;
207 
208     constructor () public {
209         _name = "Flama Staking Shares";
210         _symbol = "FSS";
211         _decimals = 18;
212         _owner = msg.sender;
213     }
214 
215     modifier onlyOwner() {
216     require(msg.sender == _owner);
217     _;
218     }
219 
220     function name() public view returns (string memory) {
221         return _name;
222     }
223 
224     function symbol() public view returns (string memory) {
225         return _symbol;
226     }
227 
228     function decimals() public view returns (uint8) {
229         return _decimals;
230     }
231 
232     function totalSupply() public view override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     function balanceOf(address account) public view override returns (uint256) {
237         return _balances[account];
238     }
239 
240     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     function allowance(address owner, address spender) public view virtual override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     function approve(address spender, uint256 amount) public virtual override returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
257         return true;
258     }
259 
260     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
261         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
262         return true;
263     }
264 
265     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
266         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
267         return true;
268     }
269 
270     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
271         require(sender != address(0), "ERC20: transfer from the zero address");
272         require(recipient != address(0), "ERC20: transfer to the zero address");
273 
274         _beforeTokenTransfer(sender, recipient, amount);
275 
276         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
277         _balances[recipient] = _balances[recipient].add(amount);
278         emit Transfer(sender, recipient, amount);
279     }
280 
281     function _mint(address account, uint256 amount) internal virtual {
282         require(account != address(0), "ERC20: mint to the zero address");
283 
284         _beforeTokenTransfer(address(0), account, amount);
285 
286         _totalSupply = _totalSupply.add(amount);
287         _balances[account] = _balances[account].add(amount);
288         emit Transfer(address(0), account, amount);
289     }
290 
291     function _burn(address account, uint256 amount) internal virtual {
292         require(account != address(0), "ERC20: burn from the zero address");
293 
294         _beforeTokenTransfer(account, address(0), amount);
295 
296         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
297         _totalSupply = _totalSupply.sub(amount);
298         emit Transfer(account, address(0), amount);
299     }
300 
301     function _approve(address owner, address spender, uint256 amount) internal virtual {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304 
305         _allowances[owner][spender] = amount;
306         emit Approval(owner, spender, amount);
307     }
308 
309     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
310 }
311 
312 contract StakingFlama is ERC20 {
313     
314     using SafeMath for uint256;
315     using SignedSafeMath for int256;
316 
317     address public owner;
318     IERC20 public flama;
319     IERC20 public flapp;
320     
321     uint256 constant internal multiplier = 2**64;
322     uint256 public calculatorFLAP;
323 
324     uint256 public lastFMAbalance;
325     uint256 public lastFLAPbalance;
326     uint256 public stakeFee;
327     uint256 public unstakeFee;
328     uint256 public maxFee = 100000 ether;
329     uint256 public minToStake;
330     uint256 public minToUnstake;
331     
332 	mapping(address => int256) public correctionFlapp;
333 	mapping(address => uint256) public withdrawnFLAP;
334     
335 
336     event Staked(address indexed user, uint256 amount, uint256 total);
337     event Unstaked(address indexed user, uint256 amount, uint256 total);
338     event FlappWithdrawn(address indexed user, uint256 amount);
339     event BalanceSnapshot(uint256 FMA, uint256 FLAP);
340     
341     constructor (address FMA, address FLAP) public {
342         
343         flama = IERC20(FMA);
344         flapp = IERC20(FLAP);
345         owner = msg.sender;
346         minToStake = 10000;
347         minToUnstake = 10000;
348     }
349     
350     function setLimits(uint256 _minToStake, uint256 _minToUnstake) public onlyOwner {
351         minToStake = _minToStake;
352         minToUnstake = _minToUnstake;
353     }
354     
355     function setFees(uint256 newStakeFee, uint256 newUnstakeFee) public onlyOwner {
356         require(newStakeFee <= maxFee);
357         require(newUnstakeFee <= maxFee);
358         stakeFee = newStakeFee;
359         unstakeFee = newUnstakeFee;
360     }
361     
362     function reduceMaxFee(uint256 newMaxFee) public onlyOwner {
363         require(newMaxFee < maxFee);
364         maxFee = newMaxFee;
365     }
366 
367     function stake(uint256 amount) public {
368         stakeFor(msg.sender, amount);
369     }
370     
371     function checkSupplyNotZero() internal view returns (uint256) {
372          
373         if (totalSupply() > 0) {
374             return totalSupply();
375         } else if (totalSupply() == 0) {
376             return 1;
377         }
378     }
379     
380     function stakeFor(address user, uint256 amount) internal {
381         
382         require(flama.balanceOf(user) >= amount, "Amount exceeds your FMA balance");
383         require(flapp.balanceOf(user) >= stakeFee, "Your FLAP balance can not cover the fee");
384         require(amount >= minToStake, "Less than minToStake");
385         
386        
387 
388         uint256 shares = amount.mul(checkSupplyNotZero()).div(getBalanceFLAMA()).mul(97).div(100);
389 
390         
391         require(flama.transferFrom(user, address(this), amount), "Stake required");
392         require(flapp.transferFrom(user, address(this), stakeFee), "FLAP fee required");
393 		
394 		updateRewardPerShare();
395         
396         _mint(user, shares);
397         lastFMAbalance = getBalanceFLAMA();
398 		lastFLAPbalance = getBalanceFLAPP();
399 
400         emit Staked(user, amount, totalSupply());
401         emit BalanceSnapshot(lastFMAbalance, lastFLAPbalance);
402     }
403 
404     
405     function updateRewardPerShare() internal {
406         
407         if( getBalanceFLAPP() > lastFLAPbalance) {
408         uint256 FLAPdiff = getBalanceFLAPP().sub(lastFLAPbalance);
409 		uint256 updateAmountFLAP = FLAPdiff.mul(multiplier).div(totalSupply());
410 
411 		calculatorFLAP = calculatorFLAP.add(updateAmountFLAP);
412 		}
413 
414     }
415     
416     function unstake(uint256 amount) public {
417         unstakeFor(msg.sender, amount);
418     }
419    
420     function unstakeFor(address user, uint256 amount) internal {
421         require(balanceOf(user) >= amount, "Amount exceeds your share balance");
422         require(minToUnstake <= amount, "Less than minToUnstake");
423 
424         uint256 unstakeAmount = amount.mul(getBalanceFLAMA()).div(totalSupply());
425 
426         require(flama.transfer(user, unstakeAmount));
427         withdrawDividendsFLAP();
428         _burn(user, amount);
429 
430 
431         lastFMAbalance = getBalanceFLAMA();
432 		lastFLAPbalance = getBalanceFLAPP();
433 
434         emit Unstaked(msg.sender, amount, totalSupply());
435         emit BalanceSnapshot(lastFMAbalance, lastFLAPbalance);
436 
437     }
438     
439     function getBalanceFLAMA() public view returns (uint256) {
440 
441 		return flama.balanceOf(address(this));
442 	}
443 	
444 	function getBalanceFLAPP() public view returns (uint256) {
445 
446 		return flapp.balanceOf(address(this));
447 	}
448 	
449 	function withdrawDividendsFLAP() public {
450 	    
451 	    updateRewardPerShare();
452 	    uint256 flap = withdrawableFLAPOf(msg.sender);
453 	    withdrawnFLAP[msg.sender] = withdrawnFLAP[msg.sender].add(flap);
454 	    require(flapp.transfer(msg.sender, flap));
455 	    lastFLAPbalance = getBalanceFLAPP();
456 	    emit FlappWithdrawn(msg.sender, flap);
457 	}
458 
459 	function withdrawableFLAPOf(address user) internal view returns(uint256) {
460 		return accumulativeFLAPOf(user).sub(withdrawnFLAP[user]);
461 	}
462 	
463 	function accumulativeFLAPOf(address _owner) internal view returns(uint256) {
464 		return (calculatorFLAP.mul(balanceOf(_owner)).toInt256Safe()
465 			.add(correctionFlapp[_owner]).toUint256Safe()).div(multiplier);
466 	}
467 	
468 	function _transfer(address from, address to, uint256 value) internal override {
469 		
470 		updateRewardPerShare();
471 		uint256 burnt = value.mul(3).div(100);
472 		uint256 newAmount = value.sub(burnt);
473 		_burn(from, burnt);
474 		super._transfer(from, to, newAmount);
475 		correctionFlapp[from] = correctionFlapp[from]
476 			.add( (calculatorFLAP.mul(newAmount)).toInt256Safe() );
477 		correctionFlapp[to] = correctionFlapp[to]
478 			.sub( (calculatorFLAP.mul(value)).toInt256Safe() );
479 	}
480 	
481 	function _mint(address account, uint256 value) internal override {
482 		super._mint(account, value);
483 
484 		correctionFlapp[account] = correctionFlapp[account]
485 			.sub( (calculatorFLAP.mul(value)).toInt256Safe() );
486 	}
487 	
488 	function _burn(address account, uint256 value) internal override {
489 		super._burn(account, value);
490 
491 		correctionFlapp[account] = correctionFlapp[account]
492 			.add( (calculatorFLAP.mul(value)).toInt256Safe() );
493 	}
494 }
495 
496 contract FLAPP is Context, IERC20 {
497     using SafeMath for uint256;
498     using Address for address;
499 
500     mapping (address => uint256) private _balances;
501 
502     mapping (address => mapping (address => uint256)) private _allowances;
503     
504 
505     uint256 private _totalSupply;
506     address public _owner;
507     string private _name;
508     string private _symbol;
509     uint8 private _decimals;
510     uint256 public _maxSupply;
511     
512     modifier onlyOwner() {
513         require(msg.sender == _owner, "Only the owner is allowed to access this function.");
514         _;
515     }
516 
517     constructor () public {
518         _name = "FLAPP";
519         _symbol = "FLAP";
520         _decimals = 18;
521         _owner = msg.sender;
522         _maxSupply = 500000000000000000000000000;
523     }
524     
525     
526     function newOwner(address _newOwner) public onlyOwner {
527         _owner = _newOwner;
528     }
529 
530     function name() public view returns (string memory) {
531         return _name;
532     }
533 
534     function symbol() public view returns (string memory) {
535         return _symbol;
536     }
537 
538     function decimals() public view returns (uint8) {
539         return _decimals;
540     }
541 
542     /**
543      * @dev See {IERC20-totalSupply}.
544      */
545     function totalSupply() public view override returns (uint256) {
546         return _totalSupply;
547     }
548 
549     /**
550      * @dev See {IERC20-balanceOf}.
551      */
552     function balanceOf(address account) public view override returns (uint256) {
553         return _balances[account];
554     }
555 
556     
557 
558 
559     /**
560      * @dev See {IERC20-transfer}.
561      *
562      * Requirements:
563      *
564      * - `recipient` cannot be the zero address.
565      * - the caller must have a balance of at least `amount`.
566      */
567     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
568         _transfer(_msgSender(), recipient, amount);
569         return true;
570     }
571 
572     /**
573      * @dev See {IERC20-allowance}.
574      */
575     function allowance(address owner, address spender) public view virtual override returns (uint256) {
576         return _allowances[owner][spender];
577     }
578 
579     /**
580      * @dev See {IERC20-approve}.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function approve(address spender, uint256 amount) public virtual override returns (bool) {
587         _approve(_msgSender(), spender, amount);
588         return true;
589     }
590 
591     /**
592      * @dev See {IERC20-transferFrom}.
593      *
594      * Emits an {Approval} event indicating the updated allowance. This is not
595      * required by the EIP. See the note at the beginning of {ERC20};
596      *
597      * Requirements:
598      * - `sender` and `recipient` cannot be the zero address.
599      * - `sender` must have a balance of at least `amount`.
600      * - the caller must have allowance for ``sender``'s tokens of at least
601      * `amount`.
602      */
603     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
604         _transfer(sender, recipient, amount);
605         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
606         return true;
607     }
608 
609     /**
610      * @dev Atomically increases the allowance granted to `spender` by the caller.
611      *
612      * This is an alternative to {approve} that can be used as a mitigation for
613      * problems described in {IERC20-approve}.
614      *
615      * Emits an {Approval} event indicating the updated allowance.
616      *
617      * Requirements:
618      *
619      * - `spender` cannot be the zero address.
620      */
621     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
622         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
623         return true;
624     }
625 
626     /**
627      * @dev Atomically decreases the allowance granted to `spender` by the caller.
628      *
629      * This is an alternative to {approve} that can be used as a mitigation for
630      * problems described in {IERC20-approve}.
631      *
632      * Emits an {Approval} event indicating the updated allowance.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      * - `spender` must have allowance for the caller of at least
638      * `subtractedValue`.
639      */
640     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
641         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
642         return true;
643     }
644 
645     /**
646      * @dev Moves tokens `amount` from `sender` to `recipient`.
647      *
648      * This is internal function is equivalent to {transfer}, and can be used to
649      * e.g. implement automatic token fees, slashing mechanisms, etc.
650      *
651      * Emits a {Transfer} event.
652      *
653      * Requirements:
654      *
655      * - `sender` cannot be the zero address.
656      * - `recipient` cannot be the zero address.
657      * - `sender` must have a balance of at least `amount`.
658      */
659     /*function _transfer(address sender, address recipient, uint256 amount) internal virtual {
660         require(sender != address(0), "ERC20: transfer from the zero address");
661         require(recipient != address(0), "ERC20: transfer to the zero address");
662 
663         _beforeTokenTransfer(sender, recipient, amount);
664 
665         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
666         _balances[recipient] = _balances[recipient].add(amount);
667         emit Transfer(sender, recipient, amount);
668     }
669     */
670     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
671         require(sender != address(0), "ERC20: transfer from the zero address");
672         require(recipient != address(0), "ERC20: transfer to the zero address");
673 
674         _beforeTokenTransfer(sender, recipient, amount);
675 
676         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
677         _balances[recipient] = _balances[recipient].add(amount);
678         emit Transfer(sender, recipient, amount);
679     }
680 
681 
682     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
683      * the total supply.
684      *
685      * Emits a {Transfer} event with `from` set to the zero address.
686      *
687      * Requirements
688      *
689      * - `to` cannot be the zero address.
690      */
691     function _mint(address account, uint256 amount) internal virtual {
692         require(account != address(0), "ERC20: mint to the zero address");
693         require(_totalSupply + amount <= _maxSupply);
694         _beforeTokenTransfer(address(0), account, amount);
695 
696         _totalSupply = _totalSupply.add(amount);
697         _balances[account] = _balances[account].add(amount);
698         emit Transfer(address(0), account, amount);
699     }
700 
701     /**
702      * @dev Destroys `amount` tokens from `account`, reducing the
703      * total supply.
704      *
705      * Emits a {Transfer} event with `to` set to the zero address.
706      *
707      * Requirements
708      *
709      * - `account` cannot be the zero address.
710      * - `account` must have at least `amount` tokens.
711      */
712     function _burn(address account, uint256 amount) internal virtual {
713         require(account != address(0), "ERC20: burn from the zero address");
714 
715         _beforeTokenTransfer(account, address(0), amount);
716 
717         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
718         _totalSupply = _totalSupply.sub(amount);
719         emit Transfer(account, address(0), amount);
720     }
721     
722     function burn(uint256 amount) public virtual {
723         
724         
725         _burn(msg.sender, amount);
726         
727     }
728 
729     /**
730      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
731      *
732      * This is internal function is equivalent to `approve`, and can be used to
733      * e.g. set automatic allowances for certain subsystems, etc.
734      *
735      * Emits an {Approval} event.
736      *
737      * Requirements:
738      *
739      * - `owner` cannot be the zero address.
740      * - `spender` cannot be the zero address.
741      */
742     function _approve(address owner, address spender, uint256 amount) internal virtual {
743         require(owner != address(0), "ERC20: approve from the zero address");
744         require(spender != address(0), "ERC20: approve to the zero address");
745 
746         _allowances[owner][spender] = amount;
747         emit Approval(owner, spender, amount);
748     }
749 
750 
751     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
752     
753     function mint(address[] memory holders, uint256[] memory amounts) public onlyOwner {
754         
755         
756         uint8 i = 0;
757         for (i; i < holders.length; i++) {
758             _mint(holders[i], amounts[i]);
759         }
760     }
761 }
762 
763 
764 
765 /**
766  * @dev Implementation of the {IERC20} interface.
767  *
768  * This implementation is agnostic to the way tokens are created. This means
769  * that a supply mechanism has to be added in a derived contract using {_mint}.
770  * For a generic mechanism see {ERC20PresetMinterPauser}.
771  *
772  * TIP: For a detailed writeup see our guide
773  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
774  * to implement supply mechanisms].
775  *
776  * We have followed general OpenZeppelin guidelines: functions revert instead
777  * of returning `false` on failure. This behavior is nonetheless conventional
778  * and does not conflict with the expectations of ERC20 applications.
779  *
780  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
781  * This allows applications to reconstruct the allowance for all accounts just
782  * by listening to said events. Other implementations of the EIP may not emit
783  * these events, as it isn't required by the specification.
784  *
785  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
786  * functions have been added to mitigate the well-known issues around setting
787  * allowances. See {IERC20-approve}.
788  */
789 contract Flama is Context, IERC20 {
790     using SafeMath for uint256;
791     using Address for address;
792 
793     mapping (address => uint256) private _balances;
794 
795     mapping (address => mapping (address => uint256)) private _allowances;
796     
797     event MultiMint(uint256 _totalSupply);
798 
799     uint256 private _totalSupply;
800     address public stakingAccount;
801     address public _owner;
802     string private _name;
803     string private _symbol;
804     uint8 private _decimals;
805     
806     modifier onlyOwner() {
807         require(msg.sender == _owner, "Only the owner is allowed to access this function.");
808         _;
809     }
810 
811     /**
812      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
813      * a default value of 18.
814      *
815      * To select a different value for {decimals}, use {_setupDecimals}.
816      *
817      * All three of these values are immutable: they can only be set once during
818      * construction.
819      */
820     constructor () public {
821         _name = "FLAMA";
822         _symbol = "FMA";
823         _decimals = 18;
824         _owner = msg.sender;
825     }
826     
827     function setStakingAccount(address newStakingAccount) public onlyOwner {
828         stakingAccount = newStakingAccount;
829     }
830     
831     function newOwner(address _newOwner) public onlyOwner {
832         _owner = _newOwner;
833     }
834 
835     /**
836      * @dev Returns the name of the token.
837      */
838     function name() public view returns (string memory) {
839         return _name;
840     }
841 
842     /**
843      * @dev Returns the symbol of the token, usually a shorter version of the
844      * name.
845      */
846     function symbol() public view returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev Returns the number of decimals used to get its user representation.
852      * For example, if `decimals` equals `2`, a balance of `505` tokens should
853      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
854      *
855      * Tokens usually opt for a value of 18, imitating the relationship between
856      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
857      * called.
858      *
859      * NOTE: This information is only used for _display_ purposes: it in
860      * no way affects any of the arithmetic of the contract, including
861      * {IERC20-balanceOf} and {IERC20-transfer}.
862      */
863     function decimals() public view returns (uint8) {
864         return _decimals;
865     }
866 
867     /**
868      * @dev See {IERC20-totalSupply}.
869      */
870     function totalSupply() public view override returns (uint256) {
871         return _totalSupply;
872     }
873 
874     /**
875      * @dev See {IERC20-balanceOf}.
876      */
877     function balanceOf(address account) public view override returns (uint256) {
878         return _balances[account];
879     }
880 
881     
882 
883 
884     /**
885      * @dev See {IERC20-transfer}.
886      *
887      * Requirements:
888      *
889      * - `recipient` cannot be the zero address.
890      * - the caller must have a balance of at least `amount`.
891      */
892     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
893         _transfer(_msgSender(), recipient, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-allowance}.
899      */
900     function allowance(address owner, address spender) public view virtual override returns (uint256) {
901         return _allowances[owner][spender];
902     }
903 
904     /**
905      * @dev See {IERC20-approve}.
906      *
907      * Requirements:
908      *
909      * - `spender` cannot be the zero address.
910      */
911     function approve(address spender, uint256 amount) public virtual override returns (bool) {
912         _approve(_msgSender(), spender, amount);
913         return true;
914     }
915 
916     /**
917      * @dev See {IERC20-transferFrom}.
918      *
919      * Emits an {Approval} event indicating the updated allowance. This is not
920      * required by the EIP. See the note at the beginning of {ERC20};
921      *
922      * Requirements:
923      * - `sender` and `recipient` cannot be the zero address.
924      * - `sender` must have a balance of at least `amount`.
925      * - the caller must have allowance for ``sender``'s tokens of at least
926      * `amount`.
927      */
928     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
929         _transfer(sender, recipient, amount);
930         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
931         return true;
932     }
933 
934     /**
935      * @dev Atomically increases the allowance granted to `spender` by the caller.
936      *
937      * This is an alternative to {approve} that can be used as a mitigation for
938      * problems described in {IERC20-approve}.
939      *
940      * Emits an {Approval} event indicating the updated allowance.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
947         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
948         return true;
949     }
950 
951     /**
952      * @dev Atomically decreases the allowance granted to `spender` by the caller.
953      *
954      * This is an alternative to {approve} that can be used as a mitigation for
955      * problems described in {IERC20-approve}.
956      *
957      * Emits an {Approval} event indicating the updated allowance.
958      *
959      * Requirements:
960      *
961      * - `spender` cannot be the zero address.
962      * - `spender` must have allowance for the caller of at least
963      * `subtractedValue`.
964      */
965     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
966         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
967         return true;
968     }
969 
970     /**
971      * @dev Moves tokens `amount` from `sender` to `recipient`.
972      *
973      * This is internal function is equivalent to {transfer}, and can be used to
974      * e.g. implement automatic token fees, slashing mechanisms, etc.
975      *
976      * Emits a {Transfer} event.
977      *
978      * Requirements:
979      *
980      * - `sender` cannot be the zero address.
981      * - `recipient` cannot be the zero address.
982      * - `sender` must have a balance of at least `amount`.
983      */
984     /*function _transfer(address sender, address recipient, uint256 amount) internal virtual {
985         require(sender != address(0), "ERC20: transfer from the zero address");
986         require(recipient != address(0), "ERC20: transfer to the zero address");
987 
988         _beforeTokenTransfer(sender, recipient, amount);
989 
990         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
991         _balances[recipient] = _balances[recipient].add(amount);
992         emit Transfer(sender, recipient, amount);
993     }
994     */
995     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
996         require(sender != address(0), "ERC20: transfer from the zero address");
997         require(recipient != address(0), "ERC20: transfer to the zero address");
998         
999         _beforeTokenTransfer(sender, recipient, amount);
1000         
1001         uint256 onePercent = amount.div(100);
1002         uint256 burnAmount = onePercent.mul(2);
1003         uint256 stakeAmount = onePercent.mul(1);
1004         uint256 newTransferAmount = amount.sub(burnAmount + stakeAmount);
1005         _totalSupply = _totalSupply.sub(burnAmount);
1006         
1007         _balances[sender] = _balances[sender].sub(amount);
1008         _balances[recipient] = _balances[recipient].add(newTransferAmount);
1009         _balances[stakingAccount] = _balances[stakingAccount].add(stakeAmount);
1010         emit Transfer(sender, address(0), burnAmount);
1011         emit Transfer(sender, stakingAccount, stakeAmount);
1012         emit Transfer(sender, recipient, newTransferAmount);
1013     }
1014 
1015 
1016     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1017      * the total supply.
1018      *
1019      * Emits a {Transfer} event with `from` set to the zero address.
1020      *
1021      * Requirements
1022      *
1023      * - `to` cannot be the zero address.
1024      */
1025     function _mint(address account, uint256 amount) internal virtual {
1026         require(account != address(0), "ERC20: mint to the zero address");
1027 
1028         _beforeTokenTransfer(address(0), account, amount);
1029 
1030         _totalSupply = _totalSupply.add(amount);
1031         _balances[account] = _balances[account].add(amount);
1032         emit Transfer(address(0), account, amount);
1033     }
1034 
1035     /**
1036      * @dev Destroys `amount` tokens from `account`, reducing the
1037      * total supply.
1038      *
1039      * Emits a {Transfer} event with `to` set to the zero address.
1040      *
1041      * Requirements
1042      *
1043      * - `account` cannot be the zero address.
1044      * - `account` must have at least `amount` tokens.
1045      */
1046     function _burn(address account, uint256 amount) internal virtual {
1047         require(account != address(0), "ERC20: burn from the zero address");
1048 
1049         _beforeTokenTransfer(account, address(0), amount);
1050 
1051         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1052         _totalSupply = _totalSupply.sub(amount);
1053         emit Transfer(account, address(0), amount);
1054     }
1055     
1056     function burn(uint256 amount) public virtual {
1057         
1058         
1059         _burn(msg.sender, amount);
1060         
1061     }
1062 
1063     /**
1064      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1065      *
1066      * This is internal function is equivalent to `approve`, and can be used to
1067      * e.g. set automatic allowances for certain subsystems, etc.
1068      *
1069      * Emits an {Approval} event.
1070      *
1071      * Requirements:
1072      *
1073      * - `owner` cannot be the zero address.
1074      * - `spender` cannot be the zero address.
1075      */
1076     function _approve(address owner, address spender, uint256 amount) internal virtual {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084 
1085     /**
1086      * @dev Hook that is called before any transfer of tokens. This includes
1087      * minting and burning.
1088      *
1089      * Calling conditions:
1090      *
1091      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1092      * will be to transferred to `to`.
1093      * - when `from` is zero, `amount` tokens will be minted for `to`.
1094      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1095      * - `from` and `to` are never both zero.
1096      *
1097      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1098      */
1099     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1100     
1101     function multimintToken(address[] memory holders, uint256[] memory amounts) public onlyOwner {
1102         
1103         
1104         uint8 i = 0;
1105         for (i; i < holders.length; i++) {
1106             _mint(holders[i], amounts[i]);
1107         }
1108         emit MultiMint(_totalSupply);
1109     }
1110 }