1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-03
3 */
4 
5 // File: contracts/SafeMath.sol
6 
7 pragma solidity 0.5.15;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b <= a, "SafeMath: subtraction overflow");
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the multiplication of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `*` operator.
60      *
61      * Requirements:
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Solidity only automatically asserts when dividing by 0
91         require(b > 0, "SafeMath: division by zero");
92         uint256 c = a / b;
93         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
100      * Reverts when dividing by zero.
101      *
102      * Counterpart to Solidity's `%` operator. This function uses a `revert`
103      * opcode (which leaves remaining gas untouched) while Solidity uses an
104      * invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      * - The divisor cannot be zero.
108      */
109     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b != 0, "SafeMath: modulo by zero");
111         return a % b;
112     }
113 }
114 
115 // File: contracts/ERC20/ERC20.sol
116 
117 pragma solidity 0.5.15;
118 
119 
120 /**
121  * @dev Implementation of the `IERC20` interface.
122  *
123  * This implementation is agnostic to the way tokens are created. This means
124  * that a supply mechanism has to be added in a derived contract using `_mint`.
125  * For a generic mechanism see `ERC20Mintable`.
126  *
127  * *For a detailed writeup see our guide [How to implement supply
128  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
129  *
130  * We have followed general OpenZeppelin guidelines: functions revert instead
131  * of returning `false` on failure. This behavior is nonetheless conventional
132  * and does not conflict with the expectations of ERC20 applications.
133  *
134  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
135  * This allows applications to reconstruct the allowance for all accounts just
136  * by listening to said events. Other implementations of the EIP may not emit
137  * these events, as it isn't required by the specification.
138  *
139  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
140  * functions have been added to mitigate the well-known issues around setting
141  * allowances. See `IERC20.approve`.
142  */
143 contract ERC20 {
144     using SafeMath for uint256;
145 
146     string public name;
147     string public symbol;
148     string public desc;
149     uint8 public decimals;
150 
151     mapping (address => uint256) _balances;
152 
153     mapping (address => mapping (address => uint256)) _allowances;
154 
155     uint256 _totalSupply;
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `TokenOwner` is set by
167      * a call to `approve`. `value` is the new allowance.
168      */
169     event Approval(address indexed TokenOwner, address indexed spender, uint256 value);
170 
171     /**
172      * @dev See `IERC20.totalSupply`.
173      */
174     function totalSupply() public view returns (uint256) {
175         return _totalSupply;
176     }
177 
178     /**
179      * @dev See `IERC20.balanceOf`.
180      */
181     function balanceOf(address account) public view returns (uint256) {
182         return _balances[account];
183     }
184 
185     /**
186      * @dev See `IERC20.transfer`.
187      *
188      * Requirements:
189      *
190      * - `recipient` cannot be the zero address.
191      * - the caller must have a balance of at least `amount`.
192      */
193     function transfer(address recipient, uint256 amount) public returns (bool) {
194         _transfer(msg.sender, recipient, amount);
195         return true;
196     }
197 
198     /**
199      * @dev See `IERC20.allowance`.
200      */
201     function allowance(address TokenOwner, address spender) public view returns (uint256) {
202         return _allowances[TokenOwner][spender];
203     }
204 
205     /**
206      * @dev See `IERC20.approve`.
207      *
208      * Requirements:
209      *
210      * - `spender` cannot be the zero address.
211      */
212     function approve(address spender, uint256 value) public returns (bool) {
213         _approve(msg.sender, spender, value);
214         return true;
215     }
216 
217     /**
218      * @dev See `IERC20.transferFrom`.
219      *
220      * Emits an `Approval` event indicating the updated allowance. This is not
221      * required by the EIP. See the note at the beginning of `ERC20`;
222      *
223      * Requirements:
224      * - `sender` and `recipient` cannot be the zero address.
225      * - `sender` must have a balance of at least `value`.
226      * - the caller must have allowance for `sender`'s tokens of at least
227      * `amount`.
228      */
229     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
230         require(_allowances[sender][msg.sender] >= amount, "ERC20: Not enough in deligation");
231         _transfer(sender, recipient, amount);
232         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
233         return true;
234     }
235 
236     /**
237      * @dev Atomically increases the allowance granted to `spender` by the caller.
238      *
239      * This is an alternative to `approve` that can be used as a mitigation for
240      * problems described in `IERC20.approve`.
241      *
242      * Emits an `Approval` event indicating the updated allowance.
243      *
244      * Requirements:
245      *
246      * - `spender` cannot be the zero address.
247      */
248     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
249         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
250         return true;
251     }
252 
253     /**
254      * @dev Atomically decreases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to `approve` that can be used as a mitigation for
257      * problems described in `IERC20.approve`.
258      *
259      * Emits an `Approval` event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `spender` must have allowance for the caller of at least
265      * `subtractedValue`.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
268         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
269         return true;
270     }
271 
272     /**
273      * @dev Moves tokens `amount` from `sender` to `recipient`.
274      *
275      * This is internal function is equivalent to `transfer`, and can be used to
276      * e.g. implement automatic token fees, slashing mechanisms, etc.
277      *
278      * Emits a `Transfer` event.
279      *
280      * Requirements:
281      *
282      * - `sender` cannot be the zero address.
283      * - `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      */
286     function _transfer(address sender, address recipient, uint256 amount) internal {
287         require(sender != address(0), "ERC20: transfer from the zero address");
288         require(recipient != address(0), "ERC20: transfer to the zero address");
289         require(_balances[sender] >= amount, "ERC20: Not Enough balance");
290 
291         _balances[sender] = _balances[sender].sub(amount);
292         _balances[recipient] = _balances[recipient].add(amount);
293         emit Transfer(sender, recipient, amount);
294     }
295 
296     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
297      * the total supply.
298      *
299      * Emits a `Transfer` event with `from` set to the zero address.
300      *
301      * Requirements
302      *
303      * - `to` cannot be the zero address.
304      */
305     function _mint(address account, uint256 amount) internal {
306         require(account != address(0), "ERC20: mint to the zero address");
307 
308         _totalSupply = _totalSupply.add(amount);
309         _balances[account] = _balances[account].add(amount);
310         emit Transfer(address(0), account, amount);
311     }
312 
313     /**
314     * @dev Destroys `amount` tokens from `account`, reducing the
315     * total supply.
316     *
317     * Emits a `Transfer` event with `to` set to the zero address.
318     *
319     * Requirements
320     *
321     * - `account` cannot be the zero address.
322     * - `account` must have at least `amount` tokens.
323     */
324     function _burn(address account, uint256 value) internal {
325         require(account != address(0), "ERC20: burn from the zero address");
326 
327         _totalSupply = _totalSupply.sub(value);
328         _balances[account] = _balances[account].sub(value);
329         emit Transfer(account, address(0), value);
330     }
331 
332     /**
333      * @dev Sets `amount` as the allowance of `spender` over the `TokenOwner`s tokens.
334      *
335      * This is internal function is equivalent to `approve`, and can be used to
336      * e.g. set automatic allowances for certain subsystems, etc.
337      *
338      * Emits an `Approval` event.
339      *
340      * Requirements:
341      *
342      * - `TokenOwner` cannot be the zero address.
343      * - `spender` cannot be the zero address.
344      */
345     function _approve(address TokenOwner, address spender, uint256 value) internal {
346         require(TokenOwner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348 
349         _allowances[TokenOwner][spender] = value;
350         emit Approval(TokenOwner, spender, value);
351     }
352 
353     /**
354      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
355      * from the caller's allowance.
356      *
357      * See `_burn` and `_approve`.
358      */
359     function _burnFrom(address account, uint256 amount) internal {
360         _burn(account, amount);
361         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
362     }
363 }
364 
365 // File: contracts/governance/Owner.sol
366 
367 pragma solidity 0.5.15;
368 
369 contract Owner {
370 
371     address public OwnerAddress;
372 
373     modifier isOwner(){
374         require( msg.sender == OwnerAddress);
375         _;
376     }
377 
378     function changeOwner ( address _newAddress )
379         isOwner
380         public
381         returns ( bool )
382     {
383         OwnerAddress = _newAddress;
384         return true;
385     }
386 
387 }
388 
389 // File: contracts/token/IBTCToken.sol
390 
391 pragma solidity 0.5.15;
392 
393 
394 
395 contract IBTCToken is ERC20 , Owner{
396 
397     address public TAddr;
398 
399     modifier isTreasury(){
400         require(msg.sender == TAddr);
401         _;
402     }
403 
404     constructor(  )
405         public
406     {
407         name = "IBTC Blockchain";
408         symbol = "IBTC";
409         desc = "IBTC Blockchain";
410         decimals = 18;
411         OwnerAddress = msg.sender;
412     }
413 
414     function setTreasury ( address _TAddres )
415         isOwner
416         public
417         returns ( bool )
418     {
419         TAddr = _TAddres;
420         return true;
421     }
422 
423     function totalSupply() public view returns (uint256) {
424         return _totalSupply;
425     }
426 
427     function balanceOf(address account) public view returns (uint256) {
428         return _balances[account];
429     }
430 
431     function mint(address recipient, uint256 amount)
432         isTreasury
433         public
434         returns (bool result )
435     {
436         _mint( recipient , amount );
437         result = true;
438     }
439 
440     function transfer(address recipient, uint256 amount)
441         public
442         returns (bool result )
443     {
444         _transfer(msg.sender, recipient , amount );
445         result = true;
446     }
447 
448     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
449         require(_allowances[sender][msg.sender] >= amount, "ERC20: Not enough in deligation");
450         _transfer(msg.sender, recipient , amount );
451         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
452         return true;
453     }
454 
455 
456     function allowance(address TokenOwner, address spender) public view returns (uint256) {
457         return _allowances[TokenOwner][spender];
458     }
459 
460     function approve(address spender, uint256 value) public returns (bool) {
461         _approve(msg.sender, spender, value);
462         return true;
463     }
464 
465     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
466         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
467         return true;
468     }
469 
470     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
471         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
472         return true;
473     }
474 
475 }
476 
477 // File: contracts/treasury/Treasury_ds.sol
478 
479 pragma solidity 0.5.15;
480 
481 
482 contract Treasury_ds is Owner {
483     using SafeMath for uint256;
484 
485     bool public contractState;
486 
487     IBTCToken Token;
488 
489     address public TokenAddr;
490 
491     address payable public Owner1;
492 
493     address payable public Owner2;
494 
495     address masterAddr;
496 
497     uint256 public Rate;
498 
499     bool public enabled;
500 
501     mapping ( uint256 => LLimit ) public Levels;
502 
503     struct LLimit{
504         uint256 percent;
505         uint256 salesLimit;
506         uint256 bonus;
507     }
508 
509     uint256 public MaxLevel;
510 
511 //    Child -> Parent Mapping
512     mapping ( address => address ) public PCTree;
513 
514     mapping ( address => userData ) public userLevel;
515 
516     struct userData{
517         uint256 level;
518         uint256 sales;
519         uint256 share;
520         uint256 bonus;
521     }
522 
523     modifier isInActive(){
524         require(contractState == false);
525         _;
526     }
527 
528     modifier isActive(){
529         require(contractState == true);
530         _;
531     }
532 
533     modifier isSameLength ( uint256 _s1 , uint256 _s2 ){
534         require(_s1 == _s2);
535         _;
536     }
537 
538     modifier isVaildClaim( uint256 _amt ){
539         require( userLevel[msg.sender].share >= _amt );
540         _;
541     }
542 
543     modifier isVaildReferer( address _ref ){
544         require( userLevel[_ref].level != 0 );
545         _;
546     }
547 
548     modifier isSaleClose ( uint256 _amt ){
549         require( enabled == true );
550         _;
551     }
552 
553     modifier isValidTOwner(){
554         require(( Owner1 == msg.sender ) || (Owner2 == msg.sender));
555         _;
556     }
557 
558     event puchaseEvent( address indexed _buyer , address indexed _referer , uint256 _value , uint256 _tokens );
559 
560     event claimEvent( address indexed _buyer ,  uint256 _value , uint256 _pendingShare );
561 
562     event eventSetAccount( address indexed _child , address indexed _parent , uint256 _sales , uint256 _bonus , uint256 _level );
563 }
564 
565 // File: contracts/treasury/Treasury.sol
566 
567 pragma solidity 0.5.15;
568 
569 
570 contract Treasury is Treasury_ds{
571 
572 
573     constructor( address _TAddr )
574         public
575     {
576         Token = IBTCToken( _TAddr );
577         TokenAddr = _TAddr;
578         OwnerAddress = msg.sender;
579         contractState = false;
580     }
581 
582     function setLevels( uint256[] memory _percent , uint256[] memory _salesLimit , uint256[] memory _bonus )
583         public
584         isSameLength( _salesLimit.length , _percent.length )
585         isInActive
586         isOwner
587     {
588         MaxLevel = _salesLimit.length;
589         for (uint i=0; i<_salesLimit.length; i++) {
590             Levels[i+1] = LLimit( _percent[i] ,_salesLimit[i] , _bonus[i] );
591         }
592     }
593 
594     function setAccount ( address _child , address _parent , uint256 _sales )
595         isInActive
596         isOwner
597         public
598         returns ( bool )
599     {
600         PCTree[_child] = _parent;
601         userLevel[ _child ].sales = _sales;
602         userLevel[ _child ].level = 1;
603         for ( uint i= 1 ; i <= MaxLevel ; i++) {
604             if( Levels[i].salesLimit < _sales ){
605                 userLevel[ _child ].bonus = Levels[i].bonus;
606                 userLevel[ _child ].level = i;
607             }
608         }
609         emit eventSetAccount( _child , _parent , _sales , userLevel[ _child ].bonus , userLevel[ _child ].level );
610         return true;
611     }
612 
613     function setupTreasury ( uint256 _rate , address payable _owner1 , address payable _owner2 )
614         isInActive
615         isOwner
616         public
617         returns ( bool )
618     {
619         enabled = true;
620         Rate = _rate;
621         masterAddr = address(this);
622         PCTree[masterAddr] = address(0);
623         Owner1 = _owner1;
624         Owner2 = _owner2;
625         userLevel[masterAddr].level = MaxLevel;
626         contractState = true;
627         return true;
628     }
629 
630     function calcRate ( uint256 _value )
631         public
632         view
633         returns ( uint256 )
634     {
635         return _value.mul( 10**18 ).div( Rate );
636     }
637 
638     function LoopFx ( address _addr , uint256 _token ,  uint256 _value , uint256 _shareRatio )
639         internal
640         returns ( uint256 value )
641     {
642         userLevel[ _addr ].sales = userLevel[ _addr ].sales.add( _token );
643         if( _shareRatio < Levels[ userLevel[ _addr ].level ].percent ){
644             uint256 diff = Levels[ userLevel[ _addr ].level ].percent.sub(_shareRatio);
645             userLevel[ _addr ].share = userLevel[ _addr ].share.add( _value.mul(diff).div(10000) );
646             value = Levels[ userLevel[ _addr ].level ].percent;
647         }else if( _shareRatio == Levels[ userLevel[ _addr ].level ].percent ){
648             value = Levels[ userLevel[ _addr ].level ].percent;
649         }
650         return value;
651     }
652 
653     function LevelChange ( address _addr )
654         internal
655     {
656         uint256 curLevel = userLevel[_addr ].level;
657         while( curLevel <= MaxLevel){
658             if( ( userLevel[ _addr ].sales < Levels[ curLevel ].salesLimit ) ){
659                 break;
660             }else{
661                 userLevel[_addr].bonus = Levels[ curLevel ].bonus;
662                 userLevel[_addr ].level = curLevel;
663             }
664             curLevel = curLevel.add(1);
665         }
666     }
667 
668     function purchase ( address _referer )
669         isActive
670         isVaildReferer( _referer )
671         payable
672         public
673         returns ( bool )
674     {
675         address Parent;
676         uint256 cut = 0;
677         uint256 tokens = calcRate(msg.value);
678         uint256 lx = 0;
679         bool overflow = false;
680         iMint( msg.sender , tokens);
681         if( userLevel[ msg.sender ].level == 0 ){
682             userLevel[ msg.sender ].level = 1;
683         }
684         if( PCTree[msg.sender] == address(0)){
685             Parent = _referer;
686             PCTree[msg.sender] = Parent;
687         }else{
688             Parent = PCTree[msg.sender];
689         }
690         while( lx < 100 ){
691             lx = lx.add(1);
692             cut = LoopFx( Parent , tokens , msg.value , cut );
693             LevelChange( Parent );
694             if( PCTree[ Parent ] == address(0)){
695                 break;
696             }
697             Parent = PCTree[ Parent ];
698             if( lx == 100){
699                 overflow = true;
700             }
701         }
702         if( overflow ){
703             cut = LoopFx( masterAddr , tokens , msg.value , cut );
704         }
705         emit puchaseEvent( msg.sender , PCTree[msg.sender] , msg.value , tokens );
706         return true;
707     }
708 
709     function iMint ( address _addr , uint256 _value )
710         isSaleClose( _value )
711         internal
712     {
713         Token.mint( _addr , _value );
714     }
715 
716     function claim (uint256 _amt)
717         isActive
718         isVaildClaim( _amt )
719         payable
720         public
721         returns ( bool )
722     {
723         userLevel[ msg.sender ].share = userLevel[ msg.sender ].share.sub( _amt );
724         Token.mint( msg.sender , userLevel[ msg.sender ].bonus );
725         userLevel[ msg.sender ].bonus = 0;
726         msg.sender.transfer( _amt );
727         emit claimEvent( msg.sender , _amt , userLevel[ msg.sender ].share );
728         return true;
729     }
730 
731     function claimOwner ()
732         isActive
733         isValidTOwner
734         public
735         payable
736         returns ( bool )
737     {
738         uint256 _amt  = userLevel[ address(this) ].share.div(2);
739         userLevel[ address(this) ].share = 0;
740         Owner1.transfer( _amt );
741         Owner2.transfer( _amt );
742         emit claimEvent( Owner1 , _amt , userLevel[ address(this) ].share );
743         emit claimEvent( Owner2 , _amt , userLevel[ address(this) ].share );
744         return true;
745     }
746 
747     function setRate ( uint256 _rate )
748         isOwner
749         public
750         returns ( bool )
751     {
752         Rate = _rate;
753         return true;
754     }
755 
756     function enableSales ( )
757         isOwner
758         public
759         returns ( bool )
760     {
761         enabled = true;
762         return true;
763     }
764     function disableSales ( )
765         isOwner
766         public
767         returns ( bool )
768     {
769         enabled = false;
770         return true;
771     }
772 
773     function viewStatus( address _addr )
774         view
775         public
776         returns ( uint256 _level , uint256 _sales , uint256 _claim , uint256 _bonus )
777     {
778         _level = userLevel[ _addr ].level;
779         _sales = userLevel[ _addr ].sales;
780         _claim = userLevel[ _addr ].share;
781         _bonus = userLevel[ _addr ].bonus;
782     }
783 
784     function checkRef ( address _ref)
785         public
786         view
787         returns ( bool )
788     {
789         return ( userLevel[_ref].level != 0 );
790     }
791 
792 }