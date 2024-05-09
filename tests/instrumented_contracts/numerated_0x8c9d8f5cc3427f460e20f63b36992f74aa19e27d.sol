1 // SPDX-License-Identifier: DeFiat 2020
2 
3 /*
4 * Copyright (c) 2020 DeFiat.net
5 *
6 * Permission is hereby granted, free of charge, to any person obtaining a copy
7 * of this software and associated documentation files (the "Software"), to deal
8 * in the Software without restriction, including without limitation the rights
9 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 * copies of the Software, and to permit persons to whom the Software is
11 * furnished to do so, subject to the following conditions:
12 *
13 * The above copyright notice and this permission notice shall be included in all
14 * copies or substantial portions of the Software.
15 *
16 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
22 */
23 
24 pragma solidity ^0.6.0;
25 
26 library SafeMath {
27     /**
28      * @dev Returns the addition of two unsigned integers, reverting on
29      * overflow.
30      *
31      * Counterpart to Solidity's `+` operator.
32      *
33      * Requirements:
34      *
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      *
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      *
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `*` operator.
80      *
81      * Requirements:
82      *
83      * - Multiplication cannot overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the integer division of two unsigned integers. Reverts on
101      * division by zero. The result is rounded towards zero.
102      *
103      * Counterpart to Solidity's `/` operator. Note: this function uses a
104      * `revert` opcode (which leaves remaining gas untouched) while Solidity
105      * uses an invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      *
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         return div(a, b, "SafeMath: division by zero");
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      *
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b != 0, errorMessage);
165         return a % b;
166     }
167         
168     //max and min from Zeppelin math.   
169 
170     function max(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a >= b ? a : b;
172     }
173 
174     function min(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a < b ? a : b;
176     }
177 }          //Zeppelin's SafeMath
178 abstract contract Context {
179     function _msgSender() internal view virtual returns (address payable) {
180         return msg.sender;
181     }
182 
183     function _msgData() internal view virtual returns (bytes memory) {
184         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
185         return msg.data;
186     }
187 } //don't use
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 contract _ERC20 is Context, IERC20 { 
263     using SafeMath for uint256;
264     //using Address for address;
265 
266     mapping (address => uint256) private _balances;
267     mapping (address => mapping (address => uint256)) private _allowances;
268 
269     uint256 private _totalSupply;
270 
271     string private _name;
272     string private _symbol;
273     uint8 private _decimals;
274 
275     /**
276      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
277      * a default value of 18.
278      *
279      * To select a different value for {decimals}, use {_setupDecimals}.
280      *
281      * All three of these values are immutable: they can only be set once during
282      * construction.
283      */
284     function _constructor(string memory name, string memory symbol) internal {
285         _name = name;
286         _symbol = symbol;
287         _decimals = 18;
288     }
289 
290 //Public Functions
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
313      * called.
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view returns (uint8) {
320         return _decimals;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `recipient` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         _approve(_msgSender(), spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20};
374      *
375      * Requirements:
376      * - `sender` and `recipient` cannot be the zero address.
377      * - `sender` must have a balance of at least `amount`.
378      * - the caller must have allowance for ``sender``'s tokens of at least
379      * `amount`.
380      */
381     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
382         _transfer(sender, recipient, amount);
383         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
384         return true;
385     }
386 
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
400         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
401         return true;
402     }
403 
404     /**
405      * @dev Atomically decreases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      * - `spender` must have allowance for the caller of at least
416      * `subtractedValue`.
417      */
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
420         return true;
421     }
422 
423 
424 //Internal Functions
425     /**
426      * @dev Moves tokens `amount` from `sender` to `recipient`.
427      *
428      * This is internal function is equivalent to {transfer}, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a {Transfer} event.
432      *
433      * Requirements:
434      *
435      * - `sender` cannot be the zero address.
436      * - `recipient` cannot be the zero address.
437      * - `sender` must have a balance of at least `amount`.
438      */
439     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(sender, recipient, amount);
444 
445         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
446         _balances[recipient] = _balances[recipient].add(amount);
447         emit Transfer(sender, recipient, amount);
448     }  //overriden in Defiat_Token
449 
450     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
451      * the total supply.
452      *
453      * Emits a {Transfer} event with `from` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `to` cannot be the zero address.
458      */
459     function _mint(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: mint to the zero address");
461 
462         _beforeTokenTransfer(address(0), account, amount);
463 
464         _totalSupply = _totalSupply.add(amount);
465         _balances[account] = _balances[account].add(amount);
466         emit Transfer(address(0), account, amount);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from `account`, reducing the
471      * total supply.
472      *
473      * Emits a {Transfer} event with `to` set to the zero address.
474      *
475      * Requirements
476      *
477      * - `account` cannot be the zero address.
478      * - `account` must have at least `amount` tokens.
479      */
480     function _burn(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: burn from the zero address");
482 
483         _beforeTokenTransfer(account, address(0), amount);
484 
485         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
486         _totalSupply = _totalSupply.sub(amount);
487         emit Transfer(account, address(0), amount);
488     }
489 
490     /**
491      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
492      *
493      * This is internal function is equivalent to `approve`, and can be used to
494      * e.g. set automatic allowances for certain subsystems, etc.
495      *
496      * Emits an {Approval} event.
497      *
498      * Requirements:
499      *
500      * - `owner` cannot be the zero address.
501      * - `spender` cannot be the zero address.
502      */
503     function _approve(address owner, address spender, uint256 amount) internal virtual {
504         require(owner != address(0), "ERC20: approve from the zero address");
505         require(spender != address(0), "ERC20: approve to the zero address");
506 
507         _allowances[owner][spender] = amount;
508         emit Approval(owner, spender, amount);
509     }
510 
511     /**
512      * @dev Sets {decimals} to a value other than the default one of 18.
513      *
514      * WARNING: This function should only be called from the constructor. Most
515      * applications that interact with token contracts will not expect
516      * {decimals} to ever change, and may work incorrectly if it does.
517      */
518     function _setupDecimals(uint8 decimals_) internal {
519         _decimals = decimals_;
520     }
521 
522     /**
523      * @dev Hook that is called before any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
529      * will be to transferred to `to`.
530      * - when `from` is zero, `amount` tokens will be minted for `to`.
531      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
535      */
536     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
537 } 
538 
539 
540 contract DeFiat_Points is _ERC20{
541     
542     //global variables
543     address public deFiat_Token;                        //1 DeFiat token address 
544     mapping(address => bool) public deFiat_Gov;         //multiple governing addresses
545     
546     uint256 public txThreshold; //min tansfer to generate points
547     mapping (uint => uint256) public _discountTranches;
548     mapping (address => uint256) private _discounts; //current discount (base100)
549 
550 
551 //== modifiers ==
552     modifier onlyGovernors {
553         require(deFiat_Gov[msg.sender] == true, "Only governing contract");
554         _;
555     }
556     modifier onlyToken {
557         require(msg.sender == deFiat_Token, "Only token");
558         _;
559     }
560     
561     constructor() public { //token and governing contract
562         deFiat_Gov[msg.sender] = true; //msg.sender is the 1st governor
563         _constructor("DeFiat Points", "DFTP"); //calls the ERC20 "_constructor" to update token name
564         txThreshold = 1e18*100;//
565         setAll10DiscountTranches(
566              1e18*10,  1e18*50,  1e18*100,  1e18*500,  1e18*1000, 
567              1e18*1e10,  1e18*1e10+1,  1e18*1e10+2, 1e18*1e10+3); //60% and abovse closed at launch.
568         _discounts[msg.sender]=100;
569         //no minting. _totalSupply = 0
570     }
571 
572 //== VIEW ==
573     function viewDiscountOf(address _address) public view returns (uint256) {
574         return _discounts[_address];
575     }
576     function viewEligibilityOf(address _address) public view returns (uint256 tranche) {
577         uint256 _tranche = 0;
578         for(uint256 i=0; i<=9; i++){
579            if(balanceOf(_address) >= _discountTranches[i]) { 
580              _tranche = i;}
581            else{break;}
582         }
583         return _tranche;
584     }
585     function discountPointsNeeded(uint _tranche) public view returns (uint256 pointsNeeded) {
586         return( _discountTranches[_tranche]); //check the nb of points needed to access discount tranche
587     }
588 
589 //== SET ==
590     function updateMyDiscountOf() public returns (bool) {
591         uint256 _tranche = viewEligibilityOf(msg.sender);
592         _discounts[msg.sender] =  SafeMath.mul(10, _tranche); //update of discount base100
593         return true;
594     }  //users execute this function to upgrade a status level to the max tranche
595 
596 //== SET onlyGovernor ==
597     function setDeFiatToken(address _token) external onlyGovernors returns(address){
598         return deFiat_Token = _token;
599     }
600     function setGovernor(address _address, bool _rights) external onlyGovernors {
601         require(msg.sender != _address); //prevents self stripping of rights
602         deFiat_Gov[_address] = _rights;
603     }
604     
605     function setTxTreshold(uint _amount) external onlyGovernors {
606       txThreshold = _amount;  //base 1e18
607     } //minimum amount of tokens to generate points per transaction
608     function overrideDiscount(address _address, uint256 _newDiscount) external onlyGovernors {
609       require(_newDiscount <= 100); //100 = 100% discount
610       _discounts[_address]  = _newDiscount;
611     }
612     function overrideLoyaltyPoints(address _address, uint256 _newPoints) external onlyGovernors {
613         _burn(_address, balanceOf(_address)); //burn all points
614         _mint(_address, _newPoints); //mint new points
615     }
616     
617     function setDiscountTranches(uint _tranche, uint256 _pointsNeeded) external onlyGovernors {
618         require(_tranche <10, "max tranche is 9"); //tranche 9 = 90% discount
619         _discountTranches[_tranche] = _pointsNeeded;
620     }
621     
622     function setAll10DiscountTranches(
623             uint256 _pointsNeeded1, uint256 _pointsNeeded2, uint256 _pointsNeeded3, uint256 _pointsNeeded4, 
624             uint256 _pointsNeeded5, uint256 _pointsNeeded6, uint256 _pointsNeeded7, uint256 _pointsNeeded8, 
625             uint256 _pointsNeeded9) public onlyGovernors {
626         _discountTranches[0] = 0;
627         _discountTranches[1] = _pointsNeeded1; //10%
628         _discountTranches[2] = _pointsNeeded2; //20%
629         _discountTranches[3] = _pointsNeeded3; //30%
630         _discountTranches[4] = _pointsNeeded4; //40%
631         _discountTranches[5] = _pointsNeeded5; //50%
632         _discountTranches[6] = _pointsNeeded6; //60%
633         _discountTranches[7] = _pointsNeeded7; //70%
634         _discountTranches[8] = _pointsNeeded8; //80%
635         _discountTranches[9] = _pointsNeeded9; //90%
636     }
637     
638 //== MINT points: onlyToken ==  
639     function addPoints(address _address, uint256 _txSize, uint256 _points) external onlyToken {
640        if(_txSize >= txThreshold){ _mint(_address, _points);}
641     }
642     
643     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
644         _ERC20._transfer(sender, recipient, amount);
645         //force update discount
646         uint256 _tranche = viewEligibilityOf(msg.sender);
647         _discounts[msg.sender] =  SafeMath.mul(10, _tranche);
648         
649     }  //overriden to update discount at every points Transfer. Avoids passing tokens to get discounts.
650     
651     function burn(uint256 _amount) public returns(bool) {
652         _ERC20._burn(msg.sender,_amount);
653     }
654 }