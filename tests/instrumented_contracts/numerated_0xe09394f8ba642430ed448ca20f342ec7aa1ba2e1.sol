1 pragma solidity 0.5.0;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed from, address indexed _to);
8 
9     constructor(address _owner) public {
10         owner = _owner;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     function acceptOwnership() public {
22         require(msg.sender == newOwner);
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25         newOwner = address(0);
26     }
27 }
28 
29 contract Pausable is Owned {
30     event Pause();
31     event Unpause();
32 
33     bool public paused = false;
34 
35     modifier whenNotPaused() {
36       require(!paused);
37       _;
38     }
39 
40     modifier whenPaused() {
41       require(paused);
42       _;
43     }
44 
45     function pause() onlyOwner whenNotPaused public {
46       paused = true;
47       emit Pause();
48     }
49 
50     function unpause() onlyOwner whenPaused public {
51       paused = false;
52       emit Unpause();
53     }
54 }
55 
56 /**
57  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
58  * the optional functions; to access them see `ERC20Detailed`.
59  */
60 interface IERC20 {
61     /**
62      * @dev Returns the amount of tokens in existence.
63      */
64     function totalSupply() external view returns (uint256);
65 
66     /**
67      * @dev Returns the amount of tokens owned by `account`.
68      */
69     function balanceOf(address account) external view returns (uint256);
70 
71     /**
72      * @dev Moves `amount` tokens from the caller's account to `recipient`.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a `Transfer` event.
77      */
78     function transfer(address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Returns the remaining number of tokens that `spender` will be
82      * allowed to spend on behalf of `owner` through `transferFrom`. This is
83      * zero by default.
84      *
85      * This value changes when `approve` or `transferFrom` are called.
86      */
87     function allowance(address owner, address spender) external view returns (uint256);
88 
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * > Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an `Approval` event.
102      */
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Moves `amount` tokens from `sender` to `recipient` using the
107      * allowance mechanism. `amount` is then deducted from the caller's
108      * allowance.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a `Transfer` event.
113      */
114     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Emitted when `value` tokens are moved from one account (`from`) to
118      * another (`to`).
119      *
120      * Note that `value` may be zero.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     /**
125      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126      * a call to `approve`. `value` is the new allowance.
127      */
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
132 
133 /**
134  * @dev Wrappers over Solidity's arithmetic operations with added overflow
135  * checks.
136  *
137  * Arithmetic operations in Solidity wrap on overflow. This can easily result
138  * in bugs, because programmers usually assume that an overflow raises an
139  * error, which is the standard behavior in high level programming languages.
140  * `SafeMath` restores this intuition by reverting the transaction when an
141  * operation overflows.
142  *
143  * Using this library instead of the unchecked operations eliminates an entire
144  * class of bugs, so it's recommended to use it always.
145  */
146 library SafeMath {
147     /**
148      * @dev Returns the addition of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `+` operator.
152      *
153      * Requirements:
154      * - Addition cannot overflow.
155      */
156     function add(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a + b;
158         require(c >= a, "SafeMath: addition overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         require(b <= a, "SafeMath: subtraction overflow");
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         // Solidity only automatically asserts when dividing by 0
215         require(b > 0, "SafeMath: division by zero");
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222 
223 }
224 
225 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
226 
227 /**
228  * @dev Implementation of the `IERC20` interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using `_mint`.
232  * For a generic mechanism see `ERC20Mintable`.
233  *
234  * *For a detailed writeup see our guide [How to implement supply
235  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
236  *
237  * We have followed general OpenZeppelin guidelines: functions revert instead
238  * of returning `false` on failure. This behavior is nonetheless conventional
239  * and does not conflict with the expectations of ERC20 applications.
240  *
241  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
242  * This allows applications to reconstruct the allowance for all accounts just
243  * by listening to said events. Other implementations of the EIP may not emit
244  * these events, as it isn't required by the specification.
245  *
246  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
247  * functions have been added to mitigate the well-known issues around setting
248  * allowances. See `IERC20.approve`.
249  */
250 contract ERC20 is IERC20, Pausable {
251     using SafeMath for uint256;
252 
253     mapping (address => uint256) private _balances;
254 
255     mapping (address => mapping (address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     /**
260      * @dev See `IERC20.totalSupply`.
261      */
262     function totalSupply() public view returns (uint256) {
263         return _totalSupply;
264     }
265 
266     /**
267      * @dev See `IERC20.balanceOf`.
268      */
269     function balanceOf(address account) public view returns (uint256) {
270         return _balances[account];
271     }
272 
273 
274     /**
275      * @dev See `IERC20.allowance`.
276      */
277     function allowance(address owner, address spender) public view returns (uint256) {
278         return _allowances[owner][spender];
279     }
280 
281     /**
282      * @dev See `IERC20.approve`.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 value) public returns (bool) {
289         _approve(msg.sender, spender, value);
290         return true;
291     }
292 
293 
294     /**
295      * @dev Atomically increases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to `approve` that can be used as a mitigation for
298      * problems described in `IERC20.approve`.
299      *
300      * Emits an `Approval` event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
307         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
308         return true;
309     }
310 
311     /**
312      * @dev Atomically decreases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to `approve` that can be used as a mitigation for
315      * problems described in `IERC20.approve`.
316      *
317      * Emits an `Approval` event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      * - `spender` must have allowance for the caller of at least
323      * `subtractedValue`.
324      */
325     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
326         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Moves tokens `amount` from `sender` to `recipient`.
332      *
333      * This is internal function is equivalent to `transfer`, and can be used to
334      * e.g. implement automatic token fees, slashing mechanisms, etc.
335      *
336      * Emits a `Transfer` event.
337      *
338      * Requirements:
339      *
340      * - `sender` cannot be the zero address.
341      * - `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      */
344     function _transfer(address sender, address recipient, uint256 amount) internal {
345         require(sender != address(0), "ERC20: transfer from the zero address");
346         require(recipient != address(0), "ERC20: transfer to the zero address");
347 
348         _balances[sender] = _balances[sender].sub(amount);
349         _balances[recipient] = _balances[recipient].add(amount);
350         emit Transfer(sender, recipient, amount);
351     }
352 
353     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
354      * the total supply.
355      *
356      * Emits a `Transfer` event with `from` set to the zero address.
357      *
358      * Requirements
359      *
360      * - `to` cannot be the zero address.
361      */
362     function _mint(address account, uint256 amount) internal {
363         require(account != address(0), "ERC20: mint to the zero address");
364 
365         _totalSupply = _totalSupply.add(amount);
366         _balances[account] = _balances[account].add(amount);
367         emit Transfer(address(0), account, amount);
368     }
369 
370      /**
371      * @dev Destoys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a `Transfer` event with `to` set to the zero address.
375      *
376      * Requirements
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 value) internal {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         _totalSupply = _totalSupply.sub(value);
385         _balances[account] = _balances[account].sub(value);
386         emit Transfer(account, address(0), value);
387     }
388 
389     /**
390      * @dev See `IERC20.transferFrom`.
391      *
392      * Emits an `Approval` event indicating the updated allowance. This is not
393      * required by the EIP. See the note at the beginning of `ERC20`;
394      *
395      * Requirements:
396      * - `sender` and `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `value`.
398      * - the caller must have allowance for `sender`'s tokens of at least
399      * `amount`.
400      */
401     function _transferFrom(address sender, address recipient, uint256 amount) internal whenNotPaused returns (bool) {
402         _transfer(sender, recipient, amount);
403         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
404         return true;
405     }
406 
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
410      *
411      * This is internal function is equivalent to `approve`, and can be used to
412      * e.g. set automatic allowances for certain subsystems, etc.
413      *
414      * Emits an `Approval` event.
415      *
416      * Requirements:
417      *
418      * - `owner` cannot be the zero address.
419      * - `spender` cannot be the zero address.
420      */
421     function _approve(address owner, address spender, uint256 value) internal {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = value;
426         emit Approval(owner, spender, value);
427     }
428 
429 }
430 
431 contract FessChain is ERC20 {
432 
433     using SafeMath for uint256;
434     string  public constant name = "FESS";
435     string  public constant symbol = "FESS";
436     uint8   public constant decimals = 18;
437 
438     uint256 public tokenForSale = 600000000 ether;
439     uint256 public teamTokens = 2400000000 ether; 
440     uint256 public maintainanceTokens = 1000000000 ether ;  
441     uint256 public marketingTokens = 10000000 ether ; 
442     uint256 public airDropInIEO = 20000000 ether;  
443     uint256 public bountyInIEO = 30000000 ether;  
444     uint256 public mintingTokens = 2250000000 ether;
445     uint256 public airDropWithDapps = 3690000000 ether;
446 
447     mapping(address => bool) public marketingTokenHolder;
448     mapping(address => uint256) public marketingLockPeriodStart;
449 
450     mapping(address => bool) public teamTokenHolder;
451     mapping(address => uint256) public teamLockPeriodStart;
452     mapping(address => uint256) public teamTokenInitially;
453     mapping(address => uint256) public teamTokenSent;
454 
455     uint256 public totalReleased = 0;
456 
457     constructor(address _owner) public Owned(_owner) {
458  
459         _mint(address(this), 10000000000 ether);
460         super._transfer(address(this),owner,tokenForSale);
461         totalReleased = totalReleased.add(tokenForSale);
462 
463     }
464 
465     /**
466      * @dev See `IERC20.transfer`.
467      *
468      * Requirements:
469      *
470      * - `recipient` cannot be the zero address.
471      * - the caller must have a balance of at least `amount`.
472      */
473     function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
474 
475        if (marketingTokenHolder[msg.sender] == true)
476        { 
477         
478         require(now >= (marketingLockPeriodStart[msg.sender]).add(20736000)); // 8 months, taken 30 days in each month
479         super._transfer(msg.sender, recipient, amount);           
480 
481        }
482 
483       else 
484       {
485         super._transfer(msg.sender, recipient, amount);
486       } 
487 
488 
489         return true;
490     }
491 
492     /**
493      * @dev See `IERC20.transferFrom`.
494      *
495      * Emits an `Approval` event indicating the updated allowance. This is not
496      * required by the EIP. See the note at the beginning of `ERC20`;
497      *
498      * Requirements:
499      * - `sender` and `recipient` cannot be the zero address.
500      * - `sender` must have a balance of at least `value`.
501      * - the caller must have allowance for `sender`'s tokens of at least
502      * `amount`.
503      */
504     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused returns (bool) {
505 
506        if (marketingTokenHolder[msg.sender] == true)
507        { 
508         
509         require(now >= (marketingLockPeriodStart[msg.sender]).add(20736000),'Lock period is not completed'); // 8 months, taken 30 days in each month
510         super._transferFrom(sender, recipient, amount);           
511 
512        }
513 
514       else 
515       {
516         super._transferFrom(sender, recipient, amount);
517       } 
518 
519         return true;
520     }
521 
522 
523     /**
524     * @dev this function will send the Team tokens to given address
525     * @param _teamAddress ,address of the bounty receiver.
526     * @param _value , number of tokens to be sent.
527     */
528     function sendTeamTokens(address _teamAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
529 
530         require(teamTokens >= _value);
531         totalReleased = totalReleased.add(_value);
532         require(totalReleased <= totalSupply());
533         teamTokens = teamTokens.sub(_value);
534         teamTokenHolder[_teamAddress] = true;
535         teamTokenInitially[_teamAddress] = teamTokenInitially[_teamAddress].add((_value.mul(95)).div(100));
536         teamLockPeriodStart[_teamAddress] = now; 
537         super._transfer(address(this),_teamAddress,(_value.mul(5)).div(100));
538         return true;
539 
540    }
541 
542     /**
543     * @dev this function will send the Team tokens to given address
544     * @param _marketingAddress ,address of the bounty receiver.
545     * @param _value , number of tokens to be sent.
546     */
547     function sendMarketingTokens(address _marketingAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
548 
549         require(marketingTokens >= _value);
550         totalReleased = totalReleased.add(_value);
551         require(totalReleased <= totalSupply());
552         marketingTokens = marketingTokens.sub(_value);
553         marketingTokenHolder[_marketingAddress] = true;
554         marketingLockPeriodStart[_marketingAddress] = now;
555         super._transfer(address(this),_marketingAddress,_value);
556         return true;
557 
558    }
559 
560     
561     /**
562     * @dev this function will send the Team tokens to given address
563     * @param _maintainanceAddress ,address of the bounty receiver.
564     * @param _value , number of tokens to be sent.
565     */
566     function sendMaintainanceTokens(address _maintainanceAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
567 
568         require(maintainanceTokens >= _value);
569         totalReleased = totalReleased.add(_value);
570         require(totalReleased <= totalSupply());
571         maintainanceTokens = maintainanceTokens.sub(_value);
572         super._transfer(address(this),_maintainanceAddress,_value);
573         return true;
574 
575    }
576     
577     /**
578     * @dev this function will send the Team tokens to given address
579     * @param _airDropAddress ,address of the bounty receiver.
580     * @param _value , number of tokens to be sent.
581     */
582     function sendAirDropIEO(address _airDropAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
583 
584         require(airDropInIEO >= _value);
585         totalReleased = totalReleased.add(_value);
586         require(totalReleased <= totalSupply());
587         airDropInIEO = airDropInIEO.sub(_value);
588         super._transfer(address(this),_airDropAddress,_value);
589         return true;
590 
591    }
592 
593     /**
594     * @dev this function will send the Team tokens to given address
595     * @param _bountyAddress ,address of the bounty receiver.
596     * @param _value , number of tokens to be sent.
597     */
598     function sendBountyIEO(address _bountyAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
599 
600         require(bountyInIEO >= _value);
601         totalReleased = totalReleased.add(_value);
602         require(totalReleased <= totalSupply());
603         bountyInIEO = bountyInIEO.sub(_value);
604         super._transfer(address(this),_bountyAddress,_value);
605         return true;
606 
607    }
608 
609     
610     /**.
611     * @dev this function will send the Team tokens to given address
612     * @param _airDropWithDapps ,address of the bounty receiver.
613     * @param _value , number of tokens to be sent.
614     */
615     function sendAirDropAndBountyDapps(address _airDropWithDapps, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
616 
617         require(airDropWithDapps >= _value);
618         totalReleased = totalReleased.add(_value);
619         require(totalReleased <= totalSupply());
620         airDropWithDapps = airDropWithDapps.sub(_value);
621         super._transfer(address(this),_airDropWithDapps,_value);
622         return true;
623 
624    }
625 
626     /**
627     * @dev this function will send the Team tokens to given address
628     * @param _mintingAddress ,address of the bounty receiver.
629     * @param _value , number of tokens to be sent.
630     */
631     function sendMintingTokens(address _mintingAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
632 
633         require(mintingTokens >= _value);
634         totalReleased = totalReleased.add(_value);
635         require(totalReleased <= totalSupply());
636         mintingTokens = mintingTokens.sub(_value);
637         super._transfer(address(this),_mintingAddress,_value);
638         return true;
639 
640    }
641     
642 
643     /**
644     * @dev Destoys `amount` tokens from the caller.
645     *
646     * See `ERC20._burn`.
647     */
648     function burn(uint256 amount) external whenNotPaused{
649 
650         _burn(msg.sender, amount);
651     }
652 
653     function withdrawTeamTokens(uint256 amount) external whenNotPaused returns(bool) {
654 
655         require(teamTokenHolder[msg.sender] == true,'not a team member');
656         require(now.sub(teamLockPeriodStart[msg.sender]).div(2592000)>=3,'Lock period is not above 3 months');
657         uint256 monthsNow = now.sub(teamLockPeriodStart[msg.sender]).div(2592000);
658 
659         if(monthsNow >=3 && monthsNow < 6) 
660         {
661            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(10)).div(100),'already withdraw 10 % tokens');   
662            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
663            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender],'tokens sent is larger then initial tokens');
664            super._transfer(address(this),msg.sender,amount);      
665         } 
666 
667         else if(monthsNow >=6 && monthsNow < 9) 
668         {
669            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(20)).div(100),'already withdraw 20 % tokens');
670            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
671            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
672            super._transfer(address(this),msg.sender,amount);           
673         } 
674 
675         else if(monthsNow >=9 && monthsNow < 12) 
676         {
677            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(30)).div(100),'already withdraw 30 % tokens');
678            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
679            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
680            super._transfer(address(this),msg.sender,amount);
681         } 
682 
683         else if(monthsNow >=12 && monthsNow < 15) 
684         {
685            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(40)).div(100),'already withdraw 40 % tokens');
686            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
687            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
688            super._transfer(address(this),msg.sender,amount);           
689         } 
690 
691         else if(monthsNow >=15 && monthsNow < 18) 
692         {
693            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(50)).div(100),'already withdraw 50 % tokens');
694            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
695            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
696            super._transfer(address(this),msg.sender,amount);           
697         } 
698 
699         else if(monthsNow >=18 && monthsNow < 21) 
700         {
701            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(60)).div(100),'already withdraw 60 % tokens');
702            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
703            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
704            super._transfer(address(this),msg.sender,amount);           
705         } 
706 
707         else if(monthsNow >=21 && monthsNow < 24) 
708         {
709            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(70)).div(100),'already withdraw 70 % tokens');
710            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
711            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
712            super._transfer(address(this),msg.sender,amount);           
713         } 
714 
715         else if(monthsNow >=24 && monthsNow < 27) 
716         {
717            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(80)).div(100),'already withdraw 80 % tokens');
718            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
719            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);
720            super._transfer(address(this),msg.sender,amount);           
721         } 
722 
723         else if(monthsNow >=27 && monthsNow < 30) 
724         {
725            require(teamTokenSent[msg.sender].add(amount) <= (teamTokenInitially[msg.sender].mul(90)).div(100),'already withdraw 90 % tokens');
726            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
727            require(teamTokenSent[msg.sender] <= teamTokenInitially[msg.sender]);           
728            super._transfer(address(this),msg.sender,amount);           
729         } 
730 
731         else if(monthsNow >=30) 
732         {
733            require(teamTokenSent[msg.sender].add(amount) <= teamTokenInitially[msg.sender],'already withdraw 100 % tokens');
734            teamTokenSent[msg.sender] = teamTokenSent[msg.sender].add(amount);
735            super._transfer(address(this),msg.sender,amount);           
736         } 
737 
738     }      
739 
740 }