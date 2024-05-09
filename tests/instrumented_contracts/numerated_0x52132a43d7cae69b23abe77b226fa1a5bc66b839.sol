1 pragma solidity 0.5.16;
2 
3 
4 contract Owned {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnershipTransferred(address indexed from, address indexed _to);
10 
11     constructor(address _owner) public {
12         owner = _owner;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address _newOwner) external onlyOwner {
21         newOwner = _newOwner;
22     }
23     function acceptOwnership() external {
24         require(msg.sender == newOwner);
25         emit OwnershipTransferred(owner, newOwner);
26         owner = newOwner;
27         newOwner = address(0);
28     }
29 }
30 
31 contract Pausable is Owned {
32     event Pause();
33     event Unpause();
34 
35     bool public paused = false;
36 
37     modifier whenNotPaused() {
38       require(!paused);
39       _;
40     }
41 
42     modifier whenPaused() {
43       require(paused);
44       _;
45     }
46 
47     function pause() onlyOwner whenNotPaused external {
48       paused = true;
49       emit Pause();
50     }
51 
52     function unpause() onlyOwner whenPaused external {
53       paused = false;
54       emit Unpause();
55     }
56 }
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
60  * the optional functions; to access them see `ERC20Detailed`.
61  */
62 interface IERC20 {
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by `account`.
70      */
71     function balanceOf(address account) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `recipient`.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a `Transfer` event.
79      */
80     function transfer(address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Returns the remaining number of tokens that `spender` will be
84      * allowed to spend on behalf of `owner` through `transferFrom`. This is
85      * zero by default.
86      *
87      * This value changes when `approve` or `transferFrom` are called.
88      */
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * > Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an `Approval` event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `sender` to `recipient` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a `Transfer` event.
115      */
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to `approve`. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         require(b <= a, "SafeMath: subtraction overflow");
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Solidity only automatically asserts when dividing by 0
217         require(b > 0, "SafeMath: division by zero");
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224 
225 }
226 
227 /**
228  * @title SafeMathInt
229  * @dev Math operations for int256 with overflow safety checks.
230  */
231 library SafeMathInt {
232     int256 private constant MIN_INT256 = int256(1) << 255;
233     int256 private constant MAX_INT256 = ~(int256(1) << 255);
234 
235     /**
236      * @dev Multiplies two int256 variables and fails on overflow.
237      */
238     function mul(int256 a, int256 b) internal pure returns (int256) {
239         int256 c = a * b;
240 
241         // Detect overflow when multiplying MIN_INT256 with -1
242         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
243         require((b == 0) || (c / b == a));
244         return c;
245     }
246 
247     /**
248      * @dev Division of two int256 variables and fails on overflow.
249      */
250     function div(int256 a, int256 b) internal pure returns (int256) {
251         // Prevent overflow when dividing MIN_INT256 by -1
252         require(b != -1 || a != MIN_INT256);
253 
254         // Solidity already throws when dividing by 0.
255         return a / b;
256     }
257 
258     /**
259      * @dev Subtracts two int256 variables and fails on overflow.
260      */
261     function sub(int256 a, int256 b) internal pure returns (int256) {
262         int256 c = a - b;
263         require((b >= 0 && c <= a) || (b < 0 && c > a));
264         return c;
265     }
266 
267     /**
268      * @dev Adds two int256 variables and fails on overflow.
269      */
270     function add(int256 a, int256 b) internal pure returns (int256) {
271         int256 c = a + b;
272         require((b >= 0 && c >= a) || (b < 0 && c < a));
273         return c;
274     }
275 
276     /**
277      * @dev Converts to absolute value, and fails on overflow.
278      */
279     function abs(int256 a) internal pure returns (int256) {
280         require(a != MIN_INT256);
281         return a < 0 ? -a : a;
282     }
283 }
284 
285 
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
288 
289 /**
290  * @dev Implementation of the `IERC20` interface.
291  *
292  * This implementation is agnostic to the way tokens are created. This means
293  * that a supply mechanism has to be added in a derived contract using `_mint`.
294  * For a generic mechanism see `ERC20Mintable`.
295  *
296  * *For a detailed writeup see our guide [How to implement supply
297  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
298  *
299  * We have followed general OpenZeppelin guidelines: functions revert instead
300  * of returning `false` on failure. This behavior is nonetheless conventional
301  * and does not conflict with the expectations of ERC20 applications.
302  *
303  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
304  * This allows applications to reconstruct the allowance for all accounts just
305  * by listening to said events. Other implementations of the EIP may not emit
306  * these events, as it isn't required by the specification.
307  *
308  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
309  * functions have been added to mitigate the well-known issues around setting
310  * allowances. See `IERC20.approve`.
311  */
312 contract ERC20 is IERC20, Pausable {
313     using SafeMath for uint256;
314 
315     mapping (address => uint256) private _balances;
316 
317     mapping (address => mapping (address => uint256)) private _allowances;
318 
319     uint256 internal _totalSupply;
320 
321     /**
322      * @dev See `IERC20.totalSupply`.
323      */
324     function totalSupply() public view returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See `IERC20.balanceOf`.
330      */
331     function balanceOf(address account) public view returns (uint256) {
332         return _balances[account];
333     }
334 
335 
336     /**
337      * @dev See `IERC20.allowance`.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See `IERC20.approve`.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 value) public returns (bool) {
351         _approve(msg.sender, spender, value);
352         return true;
353     }
354 
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to `approve` that can be used as a mitigation for
360      * problems described in `IERC20.approve`.
361      *
362      * Emits an `Approval` event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
369         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to `approve` that can be used as a mitigation for
377      * problems described in `IERC20.approve`.
378      *
379      * Emits an `Approval` event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
388         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
389         return true;
390     }
391 
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to `transfer`, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a `Transfer` event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(address sender, address recipient, uint256 amount) internal {
407         require(sender != address(0), "ERC20: transfer from the zero address");
408         require(recipient != address(0), "ERC20: transfer to the zero address");
409 
410         _balances[sender] = _balances[sender].sub(amount);
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a `Transfer` event with `from` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `to` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _totalSupply = _totalSupply.add(amount);
428         _balances[account] = _balances[account].add(amount);
429         emit Transfer(address(0), account, amount);
430     }
431 
432     /**
433      * @dev See `IERC20.transferFrom`.
434      *
435      * Emits an `Approval` event indicating the updated allowance. This is not
436      * required by the EIP. See the note at the beginning of `ERC20`;
437      *
438      * Requirements:
439      * - `sender` and `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `value`.
441      * - the caller must have allowance for `sender`'s tokens of at least
442      * `amount`.
443      */
444     function _transferFrom(address sender, address recipient, uint256 amount) internal whenNotPaused returns (bool) {
445         _transfer(sender, recipient, amount);
446         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
447         return true;
448     }
449 
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
453      *
454      * This is internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an `Approval` event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 value) internal {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = value;
469         emit Approval(owner, spender, value);
470     }
471 
472 }
473 
474 
475 
476 contract Truample is ERC20 {
477 
478     using SafeMath for uint256;
479     using SafeMathInt for int256;
480 
481     string public constant name = "Truample";
482     string public constant symbol = "TMPL";
483     uint8  public constant decimals = 9;
484 
485     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
486     event RebaseContractInitialized(address reBaseAdress);
487 
488     address public reBaseContractAddress; 
489     modifier validRecipient(address to) {
490 
491         require(to != address(0x0));
492         require(to != address(this));
493         _;
494     }
495 
496     uint256 private constant MAX_UINT256 = ~uint256(0);
497     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 3000000*(10**uint256(decimals));
498     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
499     uint256 private constant MAX_SUPPLY = ~uint128(0); 
500 
501     uint256 private _totalSupply;
502     uint256 private _gonsPerFragment;
503     mapping(address => uint256) private _gonBalances;
504     mapping(address => mapping(address => uint256)) private _allowedFragments;
505 
506     uint256 public otcTokenSent;
507     uint256 public teamTokensSent;
508     uint256 public uniSwapLiquiditySent;
509     uint256 public futureDevelopment;
510     uint256 public ecoSystemTokens;
511 
512     mapping(address => bool) public teamTokenHolder;
513     mapping(address => uint256) public teamTokensReleased;
514     mapping(address => uint256) public teamTokensInitially;
515     mapping (address => uint256) public lockingTime;
516 
517     /**
518     * @dev this function will send the tokens to given entities
519     * @param _userAddress ,address of the token receiver.
520     * @param _value , number of tokens to be sent.
521     */
522     function sendTokens(address _userAddress, uint256 _value, uint256 _typeOfUser) external whenNotPaused onlyOwner returns (bool) {
523 
524      if(_typeOfUser == 1)
525      {
526          otcTokenSent = otcTokenSent.add(_value);
527          Ttransfer(msg.sender,_userAddress,_value);
528 
529      }else if (_typeOfUser == 2)
530      {
531          uniSwapLiquiditySent = uniSwapLiquiditySent.add(_value);
532          Ttransfer(msg.sender,_userAddress,_value);
533 
534      }else if (_typeOfUser == 3){
535          
536         futureDevelopment = futureDevelopment.add(_value);
537          Ttransfer(msg.sender,_userAddress,_value);
538         
539      } else if (_typeOfUser == 4){
540 
541         ecoSystemTokens = ecoSystemTokens.add(_value);
542          Ttransfer(msg.sender,_userAddress,_value);
543 
544      }else {
545 
546          revert();
547 
548      }
549 
550    }
551 
552     /**
553     * @dev this function will send the Team tokens to given address
554     * @param _userAddress ,address of the team receiver.
555     * @param _value , number of tokens to be sent.
556     */
557     function sendteamTokens(address _userAddress, uint256 _value) external whenNotPaused onlyOwner returns (bool) {
558 
559      teamTokenHolder[_userAddress] = true;
560      teamTokensInitially[_userAddress] = teamTokensInitially[_userAddress].add(_value);
561      lockingTime[_userAddress] = now;
562      teamTokensSent = teamTokensSent.add(_value);
563      Ttransfer(msg.sender,_userAddress,_value);
564         return true;
565 
566    }
567 
568     function getCycle(address _userAddress) public view returns (uint256){
569      
570      require(teamTokenHolder[_userAddress]);
571      uint256 cycle = now.sub(lockingTime[_userAddress]);
572     
573      if(cycle <= 1296000)
574      {
575          return 0;
576      }
577      else if (cycle > 1296000 && cycle <= 42768000)
578      {     
579     
580       uint256 secondsToHours = cycle.div(1296000);
581       return secondsToHours;
582 
583      }
584 
585     else if (cycle > 42768000)
586     {
587         return 34;
588     }
589     
590     }
591     
592     function setRebaseContractAddress(address _reBaseAddress) public onlyOwner returns (address){
593         
594         reBaseContractAddress = _reBaseAddress;
595         emit RebaseContractInitialized(reBaseContractAddress);
596         return (reBaseContractAddress);
597     } 
598 
599     function rebase(uint256 epoch, int256 supplyDelta)
600         external
601         returns (bool)
602     {
603         require(reBaseContractAddress != address(0x0), "rebase address not set yet");
604         require (msg.sender == reBaseContractAddress,"Not called by rebase contract");
605 
606         if (supplyDelta == 0) {
607             emit LogRebase(epoch, _totalSupply);
608             return true;
609         }
610 
611         if (supplyDelta < 0) {
612             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
613         } else {
614             _totalSupply = _totalSupply.add(uint256(supplyDelta));
615         }
616 
617         if (_totalSupply > MAX_SUPPLY) {
618             _totalSupply = MAX_SUPPLY;
619         }
620 
621         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
622 
623 
624         emit LogRebase(epoch, _totalSupply);
625         return true;
626     }
627 
628     constructor(address owner_) public Owned(owner_) {
629 
630         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
631         _gonBalances[owner_] = TOTAL_GONS;
632         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
633     }
634 
635     function totalSupply() public view returns (uint256) {
636         return _totalSupply;
637     }
638 
639 
640     function balanceOf(address who) public view returns (uint256) {
641         return _gonBalances[who].div(_gonsPerFragment);
642     }
643 
644     function Ttransfer(
645         address from,
646         address to,
647         uint256 value
648     ) internal validRecipient(to) returns (bool) {
649         uint256 gonValue = value.mul(_gonsPerFragment);
650 
651         _gonBalances[from] = _gonBalances[from].sub(gonValue);
652         _gonBalances[to] = _gonBalances[to].add(gonValue);
653         emit Transfer(from, to, value);
654         return true;
655     }
656 
657 
658     function allowance(address owner_, address spender)
659         public
660         view
661         returns (uint256)
662     {
663         return _allowedFragments[owner_][spender];
664     }
665 
666 
667     function TtransferFrom(
668         address from,
669         address to,
670         uint256 value
671     ) internal validRecipient(to) returns (bool) {
672         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg
673             .sender]
674             .sub(value);
675 
676         uint256 gonValue = value.mul(_gonsPerFragment);
677         _gonBalances[from] = _gonBalances[from].sub(gonValue);
678         _gonBalances[to] = _gonBalances[to].add(gonValue);
679         emit Transfer(from, to, value);
680 
681         return true;
682     }
683 
684 
685     function approve(address spender, uint256 value) public returns (bool) {
686         _allowedFragments[msg.sender][spender] = value;
687         emit Approval(msg.sender, spender, value);
688         return true;
689     }
690 
691 
692     function increaseAllowance(address spender, uint256 addedValue)
693         public
694         returns (bool)
695     {
696         _allowedFragments[msg.sender][spender] = _allowedFragments[msg
697             .sender][spender]
698             .add(addedValue);
699         emit Approval(
700             msg.sender,
701             spender,
702             _allowedFragments[msg.sender][spender]
703         );
704         return true;
705     }
706 
707 
708     function decreaseAllowance(address spender, uint256 subtractedValue)
709         public
710         returns (bool)
711     {
712         uint256 oldValue = _allowedFragments[msg.sender][spender];
713         if (subtractedValue >= oldValue) {
714             _allowedFragments[msg.sender][spender] = 0;
715         } else {
716             _allowedFragments[msg.sender][spender] = oldValue.sub(
717                 subtractedValue
718             );
719         }
720         emit Approval(
721             msg.sender,
722             spender,
723             _allowedFragments[msg.sender][spender]
724         );
725         return true;
726     }
727 
728     function transfer(address recipient, uint256 amount) public
729         whenNotPaused
730         returns (bool)
731     {
732 
733         if(teamTokenHolder[msg.sender]){
734 
735 
736            if(teamTokensReleased[msg.sender] == teamTokensInitially[msg.sender]){
737                
738             Ttransfer(msg.sender, recipient, amount);
739             return true;
740                
741            } else {
742 
743             require(now >= lockingTime[msg.sender].add(1296000),'Zero cycle is running');
744 
745             uint256 preSaleCycle = getCycle(msg.sender);
746             uint256 threePercentOfInitialFund = (teamTokensInitially[msg.sender].mul(3)).div(100);
747             
748             require(teamTokensReleased[msg.sender] != teamTokensInitially[msg.sender], 'all tokens released');
749             require(teamTokensReleased[msg.sender] != threePercentOfInitialFund.mul(preSaleCycle),'this cycle all tokens released');            
750             
751             if(teamTokensReleased[msg.sender] < threePercentOfInitialFund.mul(preSaleCycle))
752             {
753             uint256 tokenToSend = amount;
754             teamTokensReleased[msg.sender] = tokenToSend.add(teamTokensReleased[msg.sender]);
755             require(teamTokensReleased[msg.sender] <= teamTokensInitially[msg.sender],'tokens released are greater then inital tokens');
756 
757             Ttransfer(msg.sender, recipient, amount);
758             return true;
759             }
760            }
761 
762             
763             
764         }else{
765 
766             Ttransfer(msg.sender, recipient, amount);
767             return true;
768         } 
769 
770     }
771     function transferFrom(
772         address sender,
773         address recipient,
774         uint256 amount
775     ) public whenNotPaused returns (bool) {
776 
777 
778         if(teamTokenHolder[sender]){
779 
780            if(teamTokensReleased[sender] == teamTokensInitially[sender]){
781                
782             TtransferFrom(sender, recipient, amount);
783             return true;
784                
785            }else 
786 {            require(now >= lockingTime[sender].add(1296000),"zero cycle is running");
787 
788             uint256 preSaleCycle = getCycle(sender);
789             uint256 threePercentOfInitialFund = (teamTokensInitially[sender].mul(3)).div(100);
790             
791             require(teamTokensReleased[sender] != teamTokensInitially[sender]);
792             require(teamTokensReleased[sender] != threePercentOfInitialFund.mul(preSaleCycle));            
793             
794             if(teamTokensReleased[sender] < threePercentOfInitialFund.mul(preSaleCycle))
795 
796             {
797             
798             uint256 tokenToSend = amount;
799             teamTokensReleased[sender] = tokenToSend.add(teamTokensReleased[sender]);
800             require(teamTokensReleased[sender] <= teamTokensInitially[sender]);
801 
802             TtransferFrom(sender, recipient, amount);
803             return true;
804                     
805             }
806 }            
807             
808         }else{
809 
810             TtransferFrom(sender, recipient, amount);
811             return true;
812             
813         } 
814 
815     }
816 
817 }