1 pragma solidity 0.5.15;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a, "SafeMath: subtraction overflow");
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the multiplication of two unsigned integers, reverting on
38      * overflow.
39      *
40      * Counterpart to Solidity's `*` operator.
41      *
42      * Requirements:
43      * - Multiplication cannot overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the integer division of two unsigned integers. Reverts on
61      * division by zero. The result is rounded towards zero.
62      *
63      * Counterpart to Solidity's `/` operator. Note: this function uses a
64      * `revert` opcode (which leaves remaining gas untouched) while Solidity
65      * uses an invalid opcode to revert (consuming all remaining gas).
66      *
67      * Requirements:
68      * - The divisor cannot be zero.
69      */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0, "SafeMath: division by zero");
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
81      * Reverts when dividing by zero.
82      *
83      * Counterpart to Solidity's `%` operator. This function uses a `revert`
84      * opcode (which leaves remaining gas untouched) while Solidity uses an
85      * invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      * - The divisor cannot be zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0, "SafeMath: modulo by zero");
92         return a % b;
93     }
94 }
95 
96 contract Owner {
97 
98     address public OwnerAddress;
99 
100     modifier isOwner(){
101         require( msg.sender == OwnerAddress);
102         _;
103     }
104 
105     function changeOwner ( address _newAddress )
106         isOwner
107         public
108         returns ( bool )
109     {
110         OwnerAddress = _newAddress;
111         return true;
112     }
113 
114 }
115 
116 contract ERC20 {
117     using SafeMath for uint256;
118 
119     string public name;
120     string public symbol;
121     string public desc;
122     uint8 public decimals;
123 
124     mapping (address => uint256) _balances;
125 
126     mapping (address => mapping (address => uint256)) _allowances;
127 
128     uint256 _totalSupply;
129 
130     /**
131      * @dev Emitted when `value` tokens are moved from one account (`from`) to
132      * another (`to`).
133      *
134      * Note that `value` may be zero.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     /**
139      * @dev Emitted when the allowance of a `spender` for an `TokenOwner` is set by
140      * a call to `approve`. `value` is the new allowance.
141      */
142     event Approval(address indexed TokenOwner, address indexed spender, uint256 value);
143 
144     /**
145      * @dev See `IERC20.totalSupply`.
146      */
147     function totalSupply() public view returns (uint256) {
148         return _totalSupply;
149     }
150 
151     /**
152      * @dev See `IERC20.balanceOf`.
153      */
154     function balanceOf(address account) public view returns (uint256) {
155         return _balances[account];
156     }
157 
158     /**
159      * @dev See `IERC20.transfer`.
160      *
161      * Requirements:
162      *
163      * - `recipient` cannot be the zero address.
164      * - the caller must have a balance of at least `amount`.
165      */
166     function transfer(address recipient, uint256 amount) public returns (bool) {
167         _transfer(msg.sender, recipient, amount);
168         return true;
169     }
170 
171     /**
172      * @dev See `IERC20.allowance`.
173      */
174     function allowance(address TokenOwner, address spender) public view returns (uint256) {
175         return _allowances[TokenOwner][spender];
176     }
177 
178     /**
179      * @dev See `IERC20.approve`.
180      *
181      * Requirements:
182      *
183      * - `spender` cannot be the zero address.
184      */
185     function approve(address spender, uint256 value) public returns (bool) {
186         _approve(msg.sender, spender, value);
187         return true;
188     }
189 
190     /**
191      * @dev See `IERC20.transferFrom`.
192      *
193      * Emits an `Approval` event indicating the updated allowance. This is not
194      * required by the EIP. See the note at the beginning of `ERC20`;
195      *
196      * Requirements:
197      * - `sender` and `recipient` cannot be the zero address.
198      * - `sender` must have a balance of at least `value`.
199      * - the caller must have allowance for `sender`'s tokens of at least
200      * `amount`.
201      */
202     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
203         require(_allowances[sender][msg.sender] >= amount, "ERC20: Not enough in deligation");
204         _transfer(sender, recipient, amount);
205         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
206         return true;
207     }
208 
209     /**
210      * @dev Atomically increases the allowance granted to `spender` by the caller.
211      *
212      * This is an alternative to `approve` that can be used as a mitigation for
213      * problems described in `IERC20.approve`.
214      *
215      * Emits an `Approval` event indicating the updated allowance.
216      *
217      * Requirements:
218      *
219      * - `spender` cannot be the zero address.
220      */
221     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
222         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
223         return true;
224     }
225 
226     /**
227      * @dev Atomically decreases the allowance granted to `spender` by the caller.
228      *
229      * This is an alternative to `approve` that can be used as a mitigation for
230      * problems described in `IERC20.approve`.
231      *
232      * Emits an `Approval` event indicating the updated allowance.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      * - `spender` must have allowance for the caller of at least
238      * `subtractedValue`.
239      */
240     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
241         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
242         return true;
243     }
244 
245     /**
246      * @dev Moves tokens `amount` from `sender` to `recipient`.
247      *
248      * This is internal function is equivalent to `transfer`, and can be used to
249      * e.g. implement automatic token fees, slashing mechanisms, etc.
250      *
251      * Emits a `Transfer` event.
252      *
253      * Requirements:
254      *
255      * - `sender` cannot be the zero address.
256      * - `recipient` cannot be the zero address.
257      * - `sender` must have a balance of at least `amount`.
258      */
259     function _transfer(address sender, address recipient, uint256 amount) internal {
260         require(sender != address(0), "ERC20: transfer from the zero address");
261         require(recipient != address(0), "ERC20: transfer to the zero address");
262         require(_balances[sender] >= amount, "ERC20: Not Enough balance");
263 
264         _balances[sender] = _balances[sender].sub(amount);
265         _balances[recipient] = _balances[recipient].add(amount);
266         emit Transfer(sender, recipient, amount);
267     }
268 
269     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
270      * the total supply.
271      *
272      * Emits a `Transfer` event with `from` set to the zero address.
273      *
274      * Requirements
275      *
276      * - `to` cannot be the zero address.
277      */
278     function _mint(address account, uint256 amount) internal {
279         require(account != address(0), "ERC20: mint to the zero address");
280 
281         _totalSupply = _totalSupply.add(amount);
282         _balances[account] = _balances[account].add(amount);
283         emit Transfer(address(0), account, amount);
284     }
285 
286     /**
287     * @dev Destroys `amount` tokens from `account`, reducing the
288     * total supply.
289     *
290     * Emits a `Transfer` event with `to` set to the zero address.
291     *
292     * Requirements
293     *
294     * - `account` cannot be the zero address.
295     * - `account` must have at least `amount` tokens.
296     */
297     function _burn(address account, uint256 value) internal {
298         require(account != address(0), "ERC20: burn from the zero address");
299 
300         _totalSupply = _totalSupply.sub(value);
301         _balances[account] = _balances[account].sub(value);
302         emit Transfer(account, address(0), value);
303     }
304 
305     /**
306      * @dev Sets `amount` as the allowance of `spender` over the `TokenOwner`s tokens.
307      *
308      * This is internal function is equivalent to `approve`, and can be used to
309      * e.g. set automatic allowances for certain subsystems, etc.
310      *
311      * Emits an `Approval` event.
312      *
313      * Requirements:
314      *
315      * - `TokenOwner` cannot be the zero address.
316      * - `spender` cannot be the zero address.
317      */
318     function _approve(address TokenOwner, address spender, uint256 value) internal {
319         require(TokenOwner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321 
322         _allowances[TokenOwner][spender] = value;
323         emit Approval(TokenOwner, spender, value);
324     }
325 
326     /**
327      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
328      * from the caller's allowance.
329      *
330      * See `_burn` and `_approve`.
331      */
332     function _burnFrom(address account, uint256 amount) internal {
333         _burn(account, amount);
334         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
335     }
336 }
337 
338 
339 contract IBTCToken is ERC20 , Owner{
340 
341     address public TAddr;
342 
343     modifier isTreasury(){
344         require(msg.sender == TAddr);
345         _;
346     }
347 
348     constructor(  )
349         public
350     {
351         name = "IBTC Blockchain";
352         symbol = "IBTC";
353         desc = "IBTC Blockchain";
354         decimals = 18;
355         OwnerAddress = msg.sender;
356     }
357 
358     function setTreasury ( address _TAddres)
359         isOwner
360         public
361         returns ( bool )
362     {
363         TAddr = _TAddres;
364         return true;
365     }
366 
367     function totalSupply() public view returns (uint256) {
368         return _totalSupply;
369     }
370 
371     function balanceOf(address account) public view returns (uint256) {
372         return _balances[account];
373     }
374 
375     function mint(address recipient, uint256 amount)
376         isTreasury
377         public
378         returns (bool result )
379     {
380         _mint( recipient , amount );
381         result = true;
382     }
383 
384     function transfer(address recipient, uint256 amount)
385         public
386         returns (bool result )
387     {
388         _transfer(msg.sender, recipient , amount );
389         result = true;
390     }
391 
392     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
393         require(_allowances[sender][msg.sender] >= amount, "ERC20: Not enough in deligation");
394         _transfer(msg.sender, recipient , amount );
395         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
396         return true;
397     }
398 
399 
400     function allowance(address TokenOwner, address spender) public view returns (uint256) {
401         return _allowances[TokenOwner][spender];
402     }
403 
404     function approve(address spender, uint256 value) public returns (bool) {
405         _approve(msg.sender, spender, value);
406         return true;
407     }
408 
409     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
410         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
411         return true;
412     }
413 
414     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
415         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
416         return true;
417     }
418 
419 }
420 
421 
422 contract Treasury_ds is Owner {
423     using SafeMath for uint256;
424 
425     bool public contractState;
426 
427     IBTCToken Token;
428 
429     address public TokenAddr;
430 
431     address payable public Owner1;
432 
433     address payable public Owner2;
434 
435     address masterAddr;
436 
437     uint256 public Rate;
438 
439     bool public enabled;
440 
441     mapping ( uint256 => LLimit ) public Levels;
442 
443     struct LLimit{
444         uint256 percent;
445         uint256 salesLimit;
446         uint256 bonus;
447     }
448 
449     uint256 public MaxLevel;
450 
451 //    Child -> Parent Mapping
452     mapping ( address => address ) public PCTree;
453 
454     mapping ( address => userData ) public userLevel;
455 
456     struct userData{
457         uint256 level;
458         uint256 sales;
459         uint256 share;
460         uint256 bonus;
461     }
462 
463     modifier isInActive(){
464         require(contractState == false);
465         _;
466     }
467 
468     modifier isActive(){
469         require(contractState == true);
470         _;
471     }
472 
473     modifier isSameLength ( uint256 _s1 , uint256 _s2 ){
474         require(_s1 == _s2);
475         _;
476     }
477 
478     modifier isVaildClaim( uint256 _amt ){
479         require( userLevel[msg.sender].share >= _amt );
480         _;
481     }
482 
483     modifier isVaildReferer( address _ref ){
484         require( userLevel[_ref].level != 0 );
485         _;
486     }
487 
488     modifier isSaleClose ( uint256 _amt ){
489         require( enabled == true );
490         _;
491     }
492 
493     modifier isValidTOwner(){
494         require(( Owner1 == msg.sender ) || (Owner2 == msg.sender));
495         _;
496     }
497 
498     event puchaseEvent( address indexed _buyer , address indexed _referer , uint256 _value , uint256 _tokens );
499 
500     event claimEvent( address indexed _buyer ,  uint256 _value , uint256 _pendingShare );
501 
502 }
503 
504 contract Treasury is Treasury_ds{
505 
506 
507     constructor( address _TAddr )
508         public
509     {
510         Token = IBTCToken( _TAddr );
511         TokenAddr = _TAddr;
512         OwnerAddress = msg.sender;
513         contractState = false;
514     }
515 
516     function setLevels( uint256[] memory _percent , uint256[] memory _salesLimit , uint256[] memory _bonus )
517         isSameLength( _salesLimit.length , _percent.length )
518         internal
519     {
520         for (uint i=0; i<_salesLimit.length; i++) {
521             Levels[i+1] = LLimit( _percent[i] ,_salesLimit[i] , _bonus[i] );
522         }
523     }
524 
525     function setAccount ( address _child , address _parent , uint256 _level , uint256 _sales , uint256 _share , uint256 _bonus , uint256 _amt )
526         isInActive
527         isOwner
528         public
529         returns ( bool )
530     {
531         userLevel[_child] = userData(_level , _sales , _share , _bonus );
532         PCTree[_child] = _parent;
533         Token.mint( _child , _amt );
534         return true;
535     }
536 
537     function setupTreasury ( uint256 _rate , uint256[] memory _percent ,uint256[] memory _salesLimit , uint256[] memory _bonus , address payable _owner1 , address payable _owner2 )
538         isInActive
539         isOwner
540         public
541         returns ( bool )
542     {
543         enabled = true;
544         Rate = _rate;
545         MaxLevel = _salesLimit.length;
546         setLevels( _percent , _salesLimit , _bonus );
547         masterAddr = address(this);
548         PCTree[masterAddr] = address(0);
549         Owner1 = _owner1;
550         Owner2 = _owner2;
551         userLevel[masterAddr].level = MaxLevel;
552         contractState = true;
553         return true;
554     }
555 
556     function calcRate ( uint256 _value )
557         public
558         view
559         returns ( uint256 )
560     {
561         return _value.mul( 10**18 ).div( Rate );
562     }
563 
564     function LoopFx ( address _addr , uint256 _token ,  uint256 _value , uint256 _shareRatio )
565         internal
566         returns ( uint256 value )
567     {
568         userLevel[ _addr ].sales = userLevel[ _addr ].sales.add( _token );
569         if( _shareRatio < Levels[ userLevel[ _addr ].level ].percent ){
570             uint256 diff = Levels[ userLevel[ _addr ].level ].percent.sub(_shareRatio);
571             userLevel[ _addr ].share = userLevel[ _addr ].share.add( _value.mul(diff).div(10000) );
572             value = Levels[ userLevel[ _addr ].level ].percent;
573         }else if( _shareRatio == Levels[ userLevel[ _addr ].level ].percent ){
574             value = Levels[ userLevel[ _addr ].level ].percent;
575         }
576         return value;
577     }
578 
579     function LevelChange ( address _addr )
580         internal
581     {
582         uint256 curLevel = userLevel[_addr ].level;
583         while( curLevel <= MaxLevel){
584             if( ( userLevel[ _addr ].sales < Levels[ curLevel ].salesLimit ) ){
585                 break;
586             }else{
587                 userLevel[_addr].bonus = userLevel[_addr].bonus.add(Levels[ curLevel ].bonus);
588                 userLevel[_addr ].level = curLevel;
589             }
590             curLevel = curLevel.add(1);
591         }
592     }
593 
594     function purchase ( address _referer )
595         isActive
596         isVaildReferer( _referer )
597         payable
598         public
599         returns ( bool )
600     {
601         address Parent;
602         uint256 cut = 0;
603         uint256 tokens = calcRate(msg.value);
604         uint256 lx = 0;
605         bool overflow = false;
606         iMint( msg.sender , tokens);
607         if( userLevel[ msg.sender ].level == 0 ){
608             userLevel[ msg.sender ].level = 1;
609         }
610         if( PCTree[msg.sender] == address(0)){
611             Parent = _referer;
612             PCTree[msg.sender] = Parent;
613         }else{
614             Parent = PCTree[msg.sender];
615         }
616         while( lx < 100 ){
617             lx = lx.add(1);
618             cut = LoopFx( Parent , tokens , msg.value , cut );
619             LevelChange( Parent );
620             if( PCTree[ Parent ] == address(0)){
621                 break;
622             }
623             Parent = PCTree[ Parent ];
624             if( lx == 100){
625                 overflow = true;
626             }
627         }
628         if( overflow ){
629             cut = LoopFx( masterAddr , tokens , msg.value , cut );
630         }
631         emit puchaseEvent( msg.sender , PCTree[msg.sender] , msg.value , tokens );
632         return true;
633     }
634 
635     function iMint ( address _addr , uint256 _value )
636         isSaleClose( _value )
637         internal
638     {
639         Token.mint( _addr , _value );
640     }
641 
642     function claim (uint256 _amt)
643         isActive
644         isVaildClaim( _amt )
645         payable
646         public
647         returns ( bool )
648     {
649         userLevel[ msg.sender ].share = userLevel[ msg.sender ].share.sub( _amt );
650         Token.mint( msg.sender , userLevel[ msg.sender ].bonus );
651         userLevel[ msg.sender ].bonus = 0;
652         msg.sender.transfer( _amt );
653         emit claimEvent( msg.sender , _amt , userLevel[ msg.sender ].share );
654         return true;
655     }
656 
657     function claimOwner ()
658         isActive
659         isValidTOwner
660         public
661         payable
662         returns ( bool )
663     {
664         uint256 _amt  = userLevel[ address(this) ].share.div(2);
665         userLevel[ address(this) ].share = 0;
666         Owner1.transfer( _amt );
667         Owner2.transfer( _amt );
668         emit claimEvent( Owner1 , _amt , userLevel[ address(this) ].share );
669         emit claimEvent( Owner2 , _amt , userLevel[ address(this) ].share );
670         return true;
671     }
672 
673     function setRate ( uint256 _rate )
674         isOwner
675         public
676         returns ( bool )
677     {
678         Rate = _rate;
679         return true;
680     }
681 
682     function enableSales ( )
683         isOwner
684         public
685         returns ( bool )
686     {
687         enabled = true;
688         return true;
689     }
690     function disableSales ( )
691         isOwner
692         public
693         returns ( bool )
694     {
695         enabled = false;
696         return true;
697     }
698 
699     function viewStatus( address _addr )
700         view
701         public
702         returns ( uint256 _level , uint256 _sales , uint256 _claim , uint256 _bonus )
703     {
704         _level = userLevel[ _addr ].level;
705         _sales = userLevel[ _addr ].sales;
706         _claim = userLevel[ _addr ].share;
707         _bonus = userLevel[ _addr ].bonus;
708     }
709 
710     function checkRef ( address _ref)
711         public
712         view
713         returns ( bool )
714     {
715         return ( userLevel[_ref].level != 0 );
716     }
717 
718 }