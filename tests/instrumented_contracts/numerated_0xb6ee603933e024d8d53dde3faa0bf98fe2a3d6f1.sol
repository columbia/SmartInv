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
24 
25 /*
26 * DISCLAIMER:
27 * DeFiat (the “Token”) is a utility token experiment using the ERC20 standard on 
28 * the Ethereum Blockchain (The “Blockchain"). The DeFiat website and White Paper (the “WP”) 
29 * are for illustration only and do not make the Team liable for any of their content. 
30 * The DeFiat website may evolve over time, including but not limited to, a change of URL, 
31 * change of content, adding or removing functionalities. 
32 * THERE IS NO GUARANTEE THAT THE UTILITY OF THE TOKENS OR THE PROJECT DESCRIBED IN THE 
33 * AVAILABLE INFORMATION (AS DEFINED BELOW) WILL BE DELIVERED. REGARDLESS OF THE ACQUISITION 
34 * METHOD, BY ACQUIRING THE TOKEN YOU ARE AGREEING TO HAVE NO RECOURSE, CLAIM, ACTION, 
35 * JUDGEMENT OR REMEDY AGAINST THE TEAM IF THE UTILITY OF THE TOKENS OR IF THE PROJECT 
36 * DESCRIBED IN THE AVAILABLE INFORMATION IS NOT DELIVERED OR REALISED.
37 */
38 
39 
40 /*
41 * Below are the 3 DeFiat ecosystem contracts:
42 * Defiat_Points, the loyalty token: 0x8c9d8f5cc3427f460e20f63b36992f74aa19e27d
43 * Defiat_Gov, the governance contract: 0x3aa3303877a0d1c360a9fe2693ae9f31087a1381
44 * Defiat_Token, the actual contract managing the DeFiat DFT token.
45 * Any questions regarding the code, please reach out to the team.
46 */
47 
48 //Libraries,  Interfaces and ERC20 baseline contract. SPDX-License-Identifier: MIT
49 pragma solidity ^0.6.0;
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      *
59      * - Addition cannot overflow.
60      */
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the subtraction of two unsigned integers, reverting on
70      * overflow (when the result is negative).
71      *
72      * Counterpart to Solidity's `-` operator.
73      *
74      * Requirements:
75      *
76      * - Subtraction cannot overflow.
77      */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81 
82     /**
83      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
84      * overflow (when the result is negative).
85      *
86      * Counterpart to Solidity's `-` operator.
87      *
88      * Requirements:
89      *
90      * - Subtraction cannot overflow.
91      */
92     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      *
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111         // benefit is lost if 'b' is also tested.
112         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
113         if (a == 0) {
114             return 0;
115         }
116 
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return div(a, b, "SafeMath: division by zero");
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b > 0, errorMessage);
153         uint256 c = a / b;
154         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * Reverts when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
172         return mod(a, b, "SafeMath: modulo by zero");
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * Reverts with custom message when dividing by zero.
178      *
179      * Counterpart to Solidity's `%` operator. This function uses a `revert`
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b != 0, errorMessage);
189         return a % b;
190     }
191         
192     //max and min from Zeppelin math.   
193 
194     function max(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a >= b ? a : b;
196     }
197 
198     function min(uint256 a, uint256 b) internal pure returns (uint256) {
199         return a < b ? a : b;
200     }
201 }          //Zeppelin's SafeMath
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address payable) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes memory) {
208         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
209         return msg.data;
210     }
211 } //don't use
212 /**
213  * @dev Interface of the ERC20 standard as defined in the EIP.
214  */
215 interface IERC20 {
216     /**
217      * @dev Returns the amount of tokens in existence.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns the amount of tokens owned by `account`.
223      */
224     function balanceOf(address account) external view returns (uint256);
225 
226     /**
227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transfer(address recipient, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender) external view returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Emitted when `value` tokens are moved from one account (`from`) to
273      * another (`to`).
274      *
275      * Note that `value` may be zero.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 value);
278 
279     /**
280      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
281      * a call to {approve}. `value` is the new allowance.
282      */
283     event Approval(address indexed owner, address indexed spender, uint256 value);
284 }
285 
286 contract _ERC20 is Context, IERC20 { 
287     using SafeMath for uint256;
288     //using Address for address;
289 
290     mapping (address => uint256) private _balances;
291     mapping (address => mapping (address => uint256)) private _allowances;
292 
293     uint256 private _totalSupply;
294 
295     string private _name;
296     string private _symbol;
297     uint8 private _decimals;
298 
299     /**
300      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
301      * a default value of 18.
302      *
303      * To select a different value for {decimals}, use {_setupDecimals}.
304      *
305      * All three of these values are immutable: they can only be set once during
306      * construction.
307      */
308     function _constructor(string memory name, string memory symbol) internal {
309         _name = name;
310         _symbol = symbol;
311         _decimals = 18;
312     }
313 
314 //Public Functions
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() public view returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @dev Returns the symbol of the token, usually a shorter version of the
324      * name.
325      */
326     function symbol() public view returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @dev Returns the number of decimals used to get its user representation.
332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
333      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
334      *
335      * Tokens usually opt for a value of 18, imitating the relationship between
336      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
337      * called.
338      *
339      * NOTE: This information is only used for _display_ purposes: it in
340      * no way affects any of the arithmetic of the contract, including
341      * {IERC20-balanceOf} and {IERC20-transfer}.
342      */
343     function decimals() public view returns (uint8) {
344         return _decimals;
345     }
346 
347     /**
348      * @dev See {IERC20-totalSupply}.
349      */
350     function totalSupply() public view override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     /**
355      * @dev See {IERC20-balanceOf}.
356      */
357     function balanceOf(address account) public view override returns (uint256) {
358         return _balances[account];
359     }
360 
361     /**
362      * @dev See {IERC20-transfer}.
363      *
364      * Requirements:
365      *
366      * - `recipient` cannot be the zero address.
367      * - the caller must have a balance of at least `amount`.
368      */
369     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
370         _transfer(_msgSender(), recipient, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-allowance}.
376      */
377     function allowance(address owner, address spender) public view virtual override returns (uint256) {
378         return _allowances[owner][spender];
379     }
380 
381     /**
382      * @dev See {IERC20-approve}.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      */
388     function approve(address spender, uint256 amount) public virtual override returns (bool) {
389         _approve(_msgSender(), spender, amount);
390         return true;
391     }
392 
393     /**
394      * @dev See {IERC20-transferFrom}.
395      *
396      * Emits an {Approval} event indicating the updated allowance. This is not
397      * required by the EIP. See the note at the beginning of {ERC20};
398      *
399      * Requirements:
400      * - `sender` and `recipient` cannot be the zero address.
401      * - `sender` must have a balance of at least `amount`.
402      * - the caller must have allowance for ``sender``'s tokens of at least
403      * `amount`.
404      */
405     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
406         _transfer(sender, recipient, amount);
407         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
408         return true;
409     }
410 
411     /**
412      * @dev Atomically increases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      */
423     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
425         return true;
426     }
427 
428     /**
429      * @dev Atomically decreases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      * - `spender` must have allowance for the caller of at least
440      * `subtractedValue`.
441      */
442     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
443         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
444         return true;
445     }
446 
447 
448 //Internal Functions
449     /**
450      * @dev Moves tokens `amount` from `sender` to `recipient`.
451      *
452      * This is internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `sender` cannot be the zero address.
460      * - `recipient` cannot be the zero address.
461      * - `sender` must have a balance of at least `amount`.
462      */
463     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
464         require(sender != address(0), "ERC20: transfer from the zero address");
465         require(recipient != address(0), "ERC20: transfer to the zero address");
466 
467         _beforeTokenTransfer(sender, recipient, amount);
468 
469         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
470         _balances[recipient] = _balances[recipient].add(amount);
471         emit Transfer(sender, recipient, amount);
472     }  //overriden in Defiat_Token
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements
480      *
481      * - `to` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply = _totalSupply.add(amount);
489         _balances[account] = _balances[account].add(amount);
490         emit Transfer(address(0), account, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a {Transfer} event with `to` set to the zero address.
498      *
499      * Requirements
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507         _beforeTokenTransfer(account, address(0), amount);
508 
509         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
510         _totalSupply = _totalSupply.sub(amount);
511         emit Transfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
516      *
517      * This is internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(address owner, address spender, uint256 amount) internal virtual {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Sets {decimals} to a value other than the default one of 18.
537      *
538      * WARNING: This function should only be called from the constructor. Most
539      * applications that interact with token contracts will not expect
540      * {decimals} to ever change, and may work incorrectly if it does.
541      */
542     function _setupDecimals(uint8 decimals_) internal {
543         _decimals = decimals_;
544     }
545 
546     /**
547      * @dev Hook that is called before any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * will be to transferred to `to`.
554      * - when `from` is zero, `amount` tokens will be minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
561 } 
562 
563 
564 //DeFiat Points - 2020 AUG 27
565 pragma solidity ^0.6.0;
566 contract DeFiat_Points is _ERC20{
567     
568     //global variables
569     address public deFiat_Token;                        //1 DeFiat token address 
570     mapping(address => bool) public deFiat_Gov;         //multiple governing addresses
571     
572     uint256 public txThreshold; //min tansfer to generate points
573     mapping (uint => uint256) public _discountTranches;
574     mapping (address => uint256) private _discounts; //current discount (base100)
575 
576 
577 //== modifiers ==
578     modifier onlyGovernors {
579         require(deFiat_Gov[msg.sender] == true, "Only governing contract");
580         _;
581     }
582     modifier onlyToken {
583         require(msg.sender == deFiat_Token, "Only token");
584         _;
585     }
586     
587     constructor() public { //token and governing contract
588         deFiat_Gov[msg.sender] = true; //msg.sender is the 1st governor
589         _constructor("DeFiat Points", "DFTP"); //calls the ERC20 "_constructor" to update token name
590         txThreshold = 1e18*100;//
591         setAll10DiscountTranches(
592              1e18*10,  1e18*50,  1e18*100,  1e18*500,  1e18*1000, 
593              1e18*1e10,  1e18*1e10+1,  1e18*1e10+2, 1e18*1e10+3); //60% and abovse closed at launch.
594         _discounts[msg.sender]=100;
595         //no minting. _totalSupply = 0
596     }
597 
598 //== VIEW ==
599     function viewDiscountOf(address _address) public view returns (uint256) {
600         return _discounts[_address];
601     }
602     function viewEligibilityOf(address _address) public view returns (uint256 tranche) {
603         uint256 _tranche = 0;
604         for(uint256 i=0; i<=9; i++){
605            if(balanceOf(_address) >= _discountTranches[i]) { 
606              _tranche = i;}
607            else{break;}
608         }
609         return _tranche;
610     }
611     function discountPointsNeeded(uint _tranche) public view returns (uint256 pointsNeeded) {
612         return( _discountTranches[_tranche]); //check the nb of points needed to access discount tranche
613     }
614 
615 //== SET ==
616     function updateMyDiscountOf() public returns (bool) {
617         uint256 _tranche = viewEligibilityOf(msg.sender);
618         _discounts[msg.sender] =  SafeMath.mul(10, _tranche); //update of discount base100
619         return true;
620     }  //users execute this function to upgrade a status level to the max tranche
621 
622 //== SET onlyGovernor ==
623     function setDeFiatToken(address _token) external onlyGovernors returns(address){
624         return deFiat_Token = _token;
625     }
626     function setGovernor(address _address, bool _rights) external onlyGovernors {
627         require(msg.sender != _address); //prevents self stripping of rights
628         deFiat_Gov[_address] = _rights;
629     }
630     
631     function setTxTreshold(uint _amount) external onlyGovernors {
632       txThreshold = _amount;  //base 1e18
633     } //minimum amount of tokens to generate points per transaction
634     function overrideDiscount(address _address, uint256 _newDiscount) external onlyGovernors {
635       require(_newDiscount <= 100); //100 = 100% discount
636       _discounts[_address]  = _newDiscount;
637     }
638     function overrideLoyaltyPoints(address _address, uint256 _newPoints) external onlyGovernors {
639         _burn(_address, balanceOf(_address)); //burn all points
640         _mint(_address, _newPoints); //mint new points
641     }
642     
643     function setDiscountTranches(uint _tranche, uint256 _pointsNeeded) external onlyGovernors {
644         require(_tranche <10, "max tranche is 9"); //tranche 9 = 90% discount
645         _discountTranches[_tranche] = _pointsNeeded;
646     }
647     
648     function setAll10DiscountTranches(
649             uint256 _pointsNeeded1, uint256 _pointsNeeded2, uint256 _pointsNeeded3, uint256 _pointsNeeded4, 
650             uint256 _pointsNeeded5, uint256 _pointsNeeded6, uint256 _pointsNeeded7, uint256 _pointsNeeded8, 
651             uint256 _pointsNeeded9) public onlyGovernors {
652         _discountTranches[0] = 0;
653         _discountTranches[1] = _pointsNeeded1; //10%
654         _discountTranches[2] = _pointsNeeded2; //20%
655         _discountTranches[3] = _pointsNeeded3; //30%
656         _discountTranches[4] = _pointsNeeded4; //40%
657         _discountTranches[5] = _pointsNeeded5; //50%
658         _discountTranches[6] = _pointsNeeded6; //60%
659         _discountTranches[7] = _pointsNeeded7; //70%
660         _discountTranches[8] = _pointsNeeded8; //80%
661         _discountTranches[9] = _pointsNeeded9; //90%
662     }
663     
664 //== MINT points: onlyToken ==  
665     function addPoints(address _address, uint256 _txSize, uint256 _points) external onlyToken {
666        if(_txSize >= txThreshold){ _mint(_address, _points);}
667     }
668     
669     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
670         _ERC20._transfer(sender, recipient, amount);
671         //force update discount
672         uint256 _tranche = viewEligibilityOf(msg.sender);
673         _discounts[msg.sender] =  SafeMath.mul(10, _tranche);
674         
675     }  //overriden to update discount at every points Transfer. Avoids passing tokens to get discounts.
676     
677     function burn(uint256 _amount) public returns(bool) {
678         _ERC20._burn(msg.sender,_amount);
679     }
680 } 
681 
682 
683 //DeFiat Governance v0.1 - 2020 AUG 27
684 pragma solidity ^0.6.0;
685 contract DeFiat_Gov{
686 //Governance contract for DeFiat Token.
687     address public mastermind;
688     mapping (address => uint256) private actorLevel; //governance = multi-tier level
689     
690     mapping (address => uint256) private override _balances; 
691      mapping (address => uint256) private override _allowances; 
692      
693     uint256 private burnRate; // %rate of burn at each transaction
694     uint256 private feeRate;  // %rate of fee taken at each transaction
695     address private feeDestination; //target address for fees (to support staking contracts)
696 
697     event stdEvent(address _txOrigin, uint256 _number, bytes32 _signature, string _desc);
698 
699 //== CONSTRUCTOR
700 constructor() public {
701     mastermind = msg.sender;
702     actorLevel[mastermind] = 3;
703     feeDestination = mastermind;
704     emit stdEvent(msg.sender, 3, sha256(abi.encodePacked(mastermind)), "constructor");
705 }
706 
707 //== MODIFIERS ==
708     modifier onlyMastermind {
709     require(msg.sender == mastermind, " only Mastermind");
710     _;
711     }
712     modifier onlyGovernor {
713     require(actorLevel[msg.sender] >= 2,"only Governors");
714     _;
715     }
716     modifier onlyPartner {
717     require(actorLevel[msg.sender] >= 1,"only Partners");
718     _;
719     }  //future use
720     
721 //== VIEW ==    
722     function viewActorLevelOf(address _address) public view returns (uint256) {
723         return actorLevel[_address]; //address lvl (3, 2, 1 or 0)
724     }  
725     function viewBurnRate() public view returns (uint256)  {
726         return burnRate;
727     }
728     function viewFeeRate() public view returns (uint256)  {
729         return feeRate;
730     }
731     function viewFeeDestination() public view returns (address)  {
732         return feeDestination;
733     }
734     
735 //== SET INTERNAL VARIABLES==
736 
737     function setActorLevel(address _address, uint256 _newLevel) public {
738       require(_newLevel < actorLevel[msg.sender], "Can only give rights below you");
739       actorLevel[_address] = _newLevel; //updates level -> adds or removes rights
740       emit stdEvent(_address, _newLevel, sha256(abi.encodePacked(msg.sender, _newLevel)), "Level changed");
741     }
742     
743     //MasterMind specific 
744     function removeAllRights(address _address) public onlyMastermind {
745       require(_address != mastermind);
746       actorLevel[_address] = 0; //removes all rights
747       emit stdEvent(address(_address), 0, sha256(abi.encodePacked(_address)), "Rights Revoked");
748     }
749     function killContract() public onlyMastermind {
750         selfdestruct(msg.sender); //destroys the contract if replacement needed
751     } //only Mastermind can kill contract
752     function setMastermind(address _mastermind) public onlyMastermind {
753       mastermind = _mastermind;     //Only one mastermind
754       actorLevel[_mastermind] = 3; 
755       actorLevel[msg.sender] = 2;  //new level for previous mastermind
756       emit stdEvent(tx.origin, 0, sha256(abi.encodePacked(_mastermind, mastermind)), "MasterMind Changed");
757     }     //only Mastermind can transfer his own rights
758      
759     //Governors specific
760     function changeBurnRate(uint _burnRate) public onlyGovernor {
761       require(_burnRate <=200, "20% limit"); //cannot burn more than 20%/tx
762       burnRate = _burnRate; 
763       emit stdEvent(address(msg.sender), _burnRate, sha256(abi.encodePacked(msg.sender, _burnRate)), "BurnRate Changed");
764     }     //only governors can change burnRate/tx
765     function changeFeeRate(uint _feeRate) public onlyGovernor {
766       require(_feeRate <=200, "20% limit"); //cannot take more than 20% fees/tx
767       feeRate = _feeRate;
768       emit stdEvent(address(msg.sender), _feeRate, sha256(abi.encodePacked(msg.sender, _feeRate)), "FeeRate Changed");
769     }    //only governors can change feeRate/tx
770     function setFeeDestination(address _nextDest) public onlyGovernor {
771          feeDestination = _nextDest;
772     }
773 
774 }
775 
776 
777 //DeFiat Token - 2020 AUG 27
778 pragma solidity ^0.6.0;
779 contract DeFiat_Token is _ERC20 {  //overrides the _transfer function and adds burn capabilities
780 
781     using SafeMath for uint;
782 
783 //== Variables ==
784     address private mastermind;     // token creator.
785     address public DeFiat_gov;      // contract governing the Token
786     address public DeFiat_points;   // ERC20 loyalty TOKEN
787 
788     uint256 private _totalSupply;
789     string private _name;
790     string private _symbol;
791     uint8 private _decimals;
792     
793     struct Transaction {
794         address sender;
795         address recipient;
796         uint256 burnRate;
797         uint256 feeRate;
798         address feeDestination;
799         uint256 senderDiscount;
800         uint256 recipientDiscount;
801         uint256 actualDiscount;
802     }
803     Transaction private transaction;
804         
805 //== Modifiers ==
806     modifier onlyMastermind {
807     require(msg.sender == mastermind, "only Mastermind");
808     _;
809     }
810     modifier onlyGovernor {
811     require(msg.sender == mastermind || msg.sender == DeFiat_gov, "only Governance contract");
812     _;
813     } //only Governance managing contract
814     modifier onlyPoints {
815     require(msg.sender == mastermind || msg.sender == DeFiat_points, " only Points contract");
816     _;
817     }   //only Points managing contract
818 
819 
820     
821 //== Events ==
822     event stdEvent(address _address, uint256 _number, bytes32 _signature, string _desc);
823  
824 //== Token generation ==
825     constructor (address _gov, address _points) public {  //token requires that governance and points are up and running
826         mastermind = msg.sender;
827         _constructor("DeFiat","DFT"); //calls the ERC20 _constructor
828         _mint(mastermind, 1e18 * 500000); //mint 300,000 tokens
829         
830         DeFiat_gov = _gov;      // contract governing the Token
831         DeFiat_points = _points;   // ERC20 loyalty TOKEN
832     }
833     
834 //== mastermind ==
835     function widthdrawAnyToken(address _recipient, address _ERC20address, uint256 _amount) public onlyGovernor returns (bool) {
836         IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer
837         return true;
838     } //get tokens sent by error to contract
839     function setGovernorContract(address _gov) external onlyGovernor {
840         DeFiat_gov = _gov;
841     }    // -> governance transfer
842     function setPointsContract(address _pts) external onlyGovernor {
843         DeFiat_points = _pts;
844     }      // -> new points management contract
845     function setMastermind(address _mastermind) external onlyMastermind {
846         mastermind = _mastermind; //use the 0x0 address to resign
847     } // transfered to go contract OCT 2020
848 
849 //== View variables from external contracts ==
850     function _viewFeeRate() public view returns(uint256){
851        return DeFiat_Gov(DeFiat_gov).viewFeeRate();
852     }
853     function _viewBurnRate() public view returns(uint256){
854         return DeFiat_Gov(DeFiat_gov).viewBurnRate();
855     }
856     function _viewFeeDestination() public view returns(address){
857         return DeFiat_Gov(DeFiat_gov).viewFeeDestination();
858     }
859     function _viewDiscountOf(address _address) public view returns(uint256){
860         return DeFiat_Points(DeFiat_points).viewDiscountOf(_address);
861     }
862     function _viewPointsOf(address _address) public view returns(uint256){
863         return DeFiat_Points(DeFiat_points).balanceOf(_address);
864     }
865   
866 //== override _transfer function in the ERC20Simple contract ==    
867     function updateTxStruct(address sender, address recipient) internal returns(bool){
868         transaction.sender = sender;
869         transaction.recipient = recipient;
870         transaction.burnRate = _viewBurnRate();
871         transaction.feeRate = _viewFeeRate();
872         transaction.feeDestination = _viewFeeDestination();
873         transaction.senderDiscount = _viewDiscountOf(sender);
874         transaction.recipientDiscount = _viewDiscountOf(recipient);
875         transaction.actualDiscount = SafeMath.max(transaction.senderDiscount, transaction.recipientDiscount);
876         
877          if( transaction.actualDiscount > 100){transaction.actualDiscount = 100;} //manages "forever pools"
878     
879         return true;
880     } //struct used to prevent "stack too deep" error
881     
882     function addPoints(address sender, uint256 _threshold) public {
883     DeFiat_Points(DeFiat_points).addPoints(sender, _threshold, 1e18); //Update user's loyalty points +1 = +1e18
884     }
885     
886     function _transfer(address sender, address recipient, uint256 amount) internal override { //overrides the inherited ERC20 _transfer
887         require(sender != address(0), "ERC20: transfer from the zero address");
888         require(recipient != address(0), "ERC20: transfer to the zero address");
889         
890     //load transaction Struct (gets info from external contracts)
891         updateTxStruct(sender, recipient);
892         
893     //get discounts and apply them. You get the MAX discounts of the sender x recipient. discount is base100
894         uint256 dAmount = 
895         SafeMath.div(
896             SafeMath.mul(amount, 
897                                 SafeMath.sub(100, transaction.actualDiscount))
898         ,100);     //amount discounted to calculate fees
899 
900     //Calculates burn and fees on discounted amount (burn and fees are 0.0X% ie base 10000 -> "10" = 0.1%)
901         uint _toBurn = SafeMath.div(SafeMath.mul(dAmount,transaction.burnRate),10000); 
902         uint _toFee = SafeMath.div(SafeMath.mul(dAmount,transaction.feeRate),10000); 
903         uint _amount = SafeMath.sub(amount, SafeMath.add(_toBurn,_toFee)); //calculates the remaning amount to be sent
904    
905     //transfers -> forcing _ERC20 inheritance level
906         if(_toFee > 0) {
907         _ERC20._transfer(sender, transaction.feeDestination, _toFee); //native _transfer + emit
908         } //transfer fee
909         
910         if(_toBurn > 0) {_ERC20._burn(sender,_toBurn);} //native _burn tokens from sender
911         
912         //transfer remaining amount. + emit
913         _ERC20._transfer(sender, recipient, _amount); //native _transfer + emit
914 
915         //mint loyalty points and update lastTX
916         if(sender != recipient){addPoints(sender, amount);} //uses the full amount to determine point minting
917     }
918     
919     function burn(uint256 _amount) public returns(bool) {
920         _ERC20._burn(msg.sender,_amount);
921     }
922 
923 }
924 
925 // End of code. Thanks for reading. If you had the patience and skills to read it all, send us a msg on out social media platrofms. (DeFiat 2020)