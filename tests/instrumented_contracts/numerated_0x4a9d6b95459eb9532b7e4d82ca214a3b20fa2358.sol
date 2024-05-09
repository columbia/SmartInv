1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.6;
3 
4 
5 
6 abstract contract ReentrancyGuard {
7 
8     uint256 private constant _NOT_ENTERED = 1;
9     uint256 private constant _ENTERED = 2;
10 
11     uint256 private _status;
12 
13     constructor () {
14         _status = _NOT_ENTERED;
15     }
16 
17     modifier nonReentrant() {
18 
19         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
20 
21         _status = _ENTERED;
22 
23         _;
24 
25         _status = _NOT_ENTERED;
26     }
27 }
28 
29 // ----------------------------------------------------------------------------
30 // SafeMath library
31 // ----------------------------------------------------------------------------
32 
33 
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, reverting on
37      * overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      *
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `*` operator.
88      *
89      * Requirements:
90      *
91      * - Multiplication cannot overflow.
92      */
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
95         // benefit is lost if 'b' is also tested.
96         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
97         if (a == 0) {
98             return 0;
99         }
100 
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
135     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return mod(a, b, "SafeMath: modulo by zero");
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * Reverts with custom message when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b != 0, errorMessage);
173         return a % b;
174     }
175     
176     function ceil(uint a, uint m) internal pure returns (uint r) {
177         return (a + m - 1) / m * m;
178     }
179 }
180 
181 // ----------------------------------------------------------------------------
182 // Owned contract
183 // ----------------------------------------------------------------------------
184 contract Owned {
185     address public owner;
186 
187     event OwnershipTransferred(address indexed _from, address indexed _to);
188 
189     constructor() {
190         owner = msg.sender;
191     }
192 
193     modifier onlyOwner {
194         require(msg.sender == owner);
195         _;
196     }
197 
198     function transferOwnership(address payable _newOwner) public onlyOwner {
199         require(_newOwner != address(0), "ERC20: sending to the zero address");
200         owner = _newOwner;
201         emit OwnershipTransferred(msg.sender, _newOwner);
202     }
203 }
204 
205 // ----------------------------------------------------------------------------
206 // ERC Token Standard #20 Interface
207 // ----------------------------------------------------------------------------
208 interface IERC20 {
209     function totalSupply() external view returns (uint256);
210     function balanceOf(address tokenOwner) external view returns (uint256 balance);
211     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
212     function transfer(address to, uint256 tokens) external returns (bool success);
213     function approve(address spender, uint256 tokens) external returns (bool success);
214     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
215     function burnTokens(uint256 _amount) external;
216     
217     function calculateFeesBeforeSend(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) external view returns (uint256, uint256);
222     
223     
224     event Transfer(address indexed from, address indexed to, uint256 tokens);
225     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
226 }
227 
228 interface regreward {
229     function distributeV2() external;
230 }
231 
232 interface FEGex2 {
233     function BUY(
234         address to,
235         uint minAmountOut
236     ) 
237         external payable
238         returns (uint tokenAmountOut, uint spotPriceAfter);
239 }
240 
241 // ----------------------------------------------------------------------------
242 // ERC20 Token, with the addition of symbol, name and decimals and assisted
243 // token transfers
244 // ----------------------------------------------------------------------------
245 
246 library Roles {
247     struct Role {
248         mapping (address => bool) bearer;
249     }
250 
251     function add(Role storage role, address account) internal {
252         require(!has(role, account), "Roles: account already has role");
253         role.bearer[account] = true;
254     }
255 
256     function remove(Role storage role, address account) internal {
257         require(has(role, account), "Roles: account does not have role");
258         role.bearer[account] = false;
259     }
260 
261     function has(Role storage role, address account) internal view returns (bool) {
262         require(account != address(0), "Roles: account is the zero address");
263         return role.bearer[account];
264     }
265 }
266 
267 contract WhitelistAdminRole is Owned  {
268     using Roles for Roles.Role;
269 
270     event WhitelistAdminAdded(address indexed account);
271     event WhitelistAdminRemoved(address indexed account);
272 
273     Roles.Role private _whitelistAdmins;
274 
275    constructor () {
276         _addWhitelistAdmin(msg.sender);
277     }
278     
279     modifier onlyWhitelistAdmin() {
280         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
281         _;
282     }
283 
284     function isWhitelistAdmin(address account) public view returns (bool) {
285         return _whitelistAdmins.has(account);
286     }
287     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
288         _addWhitelistAdmin(account);
289     }
290 
291     function renounceWhitelistAdmin() public {
292         _removeWhitelistAdmin(msg.sender);
293     }
294 
295     function _addWhitelistAdmin(address account) internal {
296         _whitelistAdmins.add(account);
297         emit WhitelistAdminAdded(account);
298     } 
299 
300     function _removeWhitelistAdmin(address account) internal {
301         _whitelistAdmins.remove(account);
302         emit WhitelistAdminRemoved(account);
303     }
304 }
305 
306 contract FNum is ReentrancyGuard{
307 
308     uint public constant BASE              = 10**18;
309     
310     function badd(uint a, uint b)
311         internal pure
312         returns (uint)
313     {
314         uint c = a + b;
315         require(c >= a, "ERR_ADD_OVERFLOW");
316         return c;
317     }
318 
319     function bsub(uint a, uint b)
320         internal pure
321         returns (uint)
322     {
323         (uint c, bool flag) = bsubSign(a, b);
324         require(!flag, "ERR_SUB_UNDERFLOW");
325         return c;
326     }
327 
328     function bsubSign(uint a, uint b)
329         internal pure
330         returns (uint, bool)
331     {
332         if (a >= b) {
333             return (a - b, false);
334         } else {
335             return (b - a, true);
336         }
337     }
338 
339     function bmul(uint a, uint b)
340         internal pure
341         returns (uint)
342     {
343         uint c0 = a * b;
344         require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
345         uint c1 = c0 + (BASE / 2);
346         require(c1 >= c0, "ERR_MUL_OVERFLOW");
347         uint c2 = c1 / BASE;
348         return c2;
349     }
350 
351     function bdiv(uint a, uint b)
352         internal pure
353         returns (uint)
354     {
355         require(b != 0, "ERR_DIV_ZERO");
356         uint c0 = a * BASE;
357         require(a == 0 || c0 / a == BASE, "ERR_DIV_INTERNAL"); // bmul overflow
358         uint c1 = c0 + (b / 2);
359         require(c1 >= c0, "ERR_DIV_INTERNAL"); //  badd require
360         uint c2 = c1 / b;
361         return c2;
362     }
363     
364 function btoi(uint a)
365         internal pure
366         returns (uint)
367     {
368         return a / BASE;
369     }
370 
371     function bfloor(uint a)
372         internal pure
373         returns (uint)
374     {
375         return btoi(a) * BASE;
376     }
377     
378 function bpowi(uint a, uint n)
379         internal pure
380         returns (uint)
381     {
382         uint z = n % 2 != 0 ? a : BASE;
383 
384         for (n /= 2; n != 0; n /= 2) {
385             a = bmul(a, a);
386 
387             if (n % 2 != 0) {
388                 z = bmul(z, a);
389             }
390         }
391         return z;
392     }
393 
394     function bpow(uint base, uint exp)
395         internal pure
396         returns (uint)
397     {
398 
399         uint whole  = bfloor(exp);
400         uint remain = bsub(exp, whole);
401 
402         uint wholePow = bpowi(base, btoi(whole));
403 
404         if (remain == 0) {
405             return wholePow;
406         }
407         uint BPOW_PRECISION = BASE / 10**10;
408         uint partialResult = bpowApprox(base, remain, BPOW_PRECISION);
409         return bmul(wholePow, partialResult);
410     }
411 
412     function bpowApprox(uint base, uint exp, uint precision)
413         internal pure
414         returns (uint)
415     {
416         // term 0:
417         uint a     = exp;
418         (uint x, bool xneg)  = bsubSign(base, BASE);
419         uint term = BASE;
420         uint sum   = term;
421         bool negative = false;
422 
423 
424         for (uint i = 1; term >= precision; i++) {
425             uint bigK = i * BASE;
426             (uint c, bool cneg) = bsubSign(a, bsub(bigK, BASE));
427             term = bmul(term, bmul(c, x));
428             term = bdiv(term, bigK);
429             if (term == 0) break;
430 
431             if (xneg) negative = !negative;
432             if (cneg) negative = !negative;
433             if (negative) {
434                 sum = bsub(sum, term);
435             } else {
436                 sum = badd(sum, term);
437             }
438         }
439 
440         return sum;
441     }
442 
443 
444 }
445 
446 contract FTokenBase is FNum {
447 
448     mapping(address => uint)                   internal _balance;
449     mapping(address => mapping(address=>uint)) internal _allowance;
450     uint public _totalSupply;
451 
452     event Approval(address indexed src, address indexed dst, uint amt);
453     event Transfer(address indexed src, address indexed dst, uint amt);
454 
455     function _mint(uint amt) internal {
456         _balance[address(this)] = badd(_balance[address(this)], amt);
457         _totalSupply = badd(_totalSupply, amt);
458         emit Transfer(address(0), address(this), amt);
459     }
460 
461     function _burn(uint amt) internal {
462         require(_balance[address(this)] >= amt);
463         _balance[address(this)] = bsub(_balance[address(this)], amt);
464         _totalSupply = bsub(_totalSupply, amt);
465         emit Transfer(address(this), address(0), amt);
466     }
467     
468     function _move(address src, address dst, uint amt) internal {
469         require(_balance[src] >= amt);
470         _balance[src] = bsub(_balance[src], amt);
471         _balance[dst] = badd(_balance[dst], amt);
472         emit Transfer(src, dst, amt);
473     }
474 
475     function _push(address to, uint amt) internal {
476         _move(address(this), to, amt);
477     }
478 
479     function _pull(address from, uint amt) internal {
480         _move(from, address(this), amt);
481     }
482 }
483 
484 contract FToken is FTokenBase {
485 
486     string  private _name     = "FEG Stake Shares";
487     string  private _symbol   = "FSS";
488     uint8   private _decimals = 18;
489 
490     function name() public view returns (string memory) {
491         return _name;
492     }
493 
494     function symbol() public view returns (string memory) {
495         return _symbol;
496     }
497 
498     function decimals() public view returns(uint8) {
499         return _decimals;
500     }
501 
502     function allowance(address src, address dst) external view returns (uint) {
503         return _allowance[src][dst];
504     }
505 
506     function balanceOf(address whom) external view returns (uint) {
507         return _balance[whom];
508     }
509 
510     function totalSupply() public view returns (uint) {
511         return _totalSupply;
512     }
513 
514     function approve(address dst, uint amt) external returns (bool) {
515         _allowance[msg.sender][dst] = amt;
516         emit Approval(msg.sender, dst, amt);
517         return true;
518     }
519 
520     function increaseApproval(address dst, uint amt) external returns (bool) {
521         _allowance[msg.sender][dst] = badd(_allowance[msg.sender][dst], amt);
522         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
523         return true;
524     }
525 
526     function decreaseApproval(address dst, uint amt) external returns (bool) {
527         uint oldValue = _allowance[msg.sender][dst];
528         if (amt > oldValue) {
529             _allowance[msg.sender][dst] = 0;
530         } else {
531             _allowance[msg.sender][dst] = bsub(oldValue, amt);
532         }
533         emit Approval(msg.sender, dst, _allowance[msg.sender][dst]);
534         return true;
535     }
536 
537     function transfer(address dst, uint amt) external returns (bool) {
538         _move(msg.sender, dst, amt);
539         return true;
540     }
541 
542     function transferFrom(address src, address dst, uint amt) external returns (bool) {
543         require(msg.sender == src || amt <= _allowance[src][msg.sender]);
544      
545         _move(src, dst, amt);
546         if (msg.sender != src && _allowance[src][msg.sender] != uint256(-1)) {
547             _allowance[src][msg.sender] = bsub(_allowance[src][msg.sender], amt);
548             emit Approval(msg.sender, dst, _allowance[src][msg.sender]);
549         }
550         return true;
551     }
552 }
553 
554 contract FEGstakeV2 is Owned, ReentrancyGuard, WhitelistAdminRole, FNum, FTokenBase, FToken{
555     using SafeMath for uint256;
556     
557     address public FEG   = 0x389999216860AB8E0175387A0c90E5c52522C945;
558     address public fETH  = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
559     address public USDT  = 0x979838c9C16FD365C9fE028B0bEa49B1750d86e9;
560     address public TRY   = 0xc12eCeE46ed65D970EE5C899FCC7AE133AfF9b03;
561     address public FETP  = 0xa40462266dC28dB1d570FC8F8a0F4B72B8618f7a;
562     address public BTC   = 0xe3cDB92b094a3BeF3f16103b53bECfb17A3558ad;
563     address public poolShares = address(this);
564     address public regrewardContract; //Signs The Checks
565     
566     bool public live = false;
567     bool public perform = false; //if true then distribution of rewards from the pool to stakers via the withdraw function is enabled
568     bool public perform2 = true; //if true then distribution of TX rewards from unclaimed 1 and 2 wrap's will distribute to stakers
569     bool public perform3 = true; //if true then distribution of TX rewards from unclaimed 3rd wrap's will distribute to stakers
570     uint256 public scailment = 20; // FEG has TX fee, deduct this fee to not break maths
571     
572     uint256 public totalDividends = 0;
573     uint256 public must = 3e15;
574     uint256 public scaleatize = 99;
575     uint256 private scaledRemainder = 0;
576     uint256 private scaling = uint256(10) ** 12;
577     uint public round = 1;
578     uint256 public totalDividends1 = 0;
579     uint256 private scaledRemainder1 = 0;
580     uint256 private scaling1 = uint256(10) ** 12;
581     uint public round1 = 1;
582     uint256 public totalDividends2 = 0;
583     uint256 private scaledRemainder2 = 0;
584     uint256 private scaling2 = uint256(10) ** 12;
585     uint public round2 = 1;
586     
587     mapping(address => uint) public farmTime; // When you staked
588     
589     struct USER{
590         uint256 lastDividends;
591         uint256 fromTotalDividend;
592         uint round;
593         uint256 remainder;
594         uint256 lastDividends1;
595         uint256 fromTotalDividend1;
596         uint round1;
597         uint256 remainder1;
598         uint256 lastDividends2;
599         uint256 fromTotalDividend2;
600         uint round2;
601         uint256 remainder2;
602         bool initialized;
603         bool activated;
604     } 
605     
606     address[] internal stakeholders;
607     uint public scalerize = 98;
608     uint256 public scaletor = 1e17;
609     uint256 public scaletor1 = 20e18;
610     uint256 public scaletor2 = 1e15;
611     uint256 public totalWrap; //  total unclaimed fETH rewards
612     uint256 public totalWrap1; //  total unclaimed usdt rewards
613     uint256 public totalWrap2; //  total unclaimed btc rewards
614     uint256 public totalWrapRef  = bsub(IERC20(fETH).balanceOf(address(this)), totalWrap); //total fETH reflections unclaimed
615     uint256 public totalWrapRef1 = bsub(IERC20(USDT).balanceOf(address(this)), totalWrap1); //total usdt reflections unclaimed
616     uint256 public totalWrapRef2 = bsub(IERC20(BTC).balanceOf(address(this)), totalWrap2); //total BTC reflections unclaimed
617     mapping(address => USER) stakers;
618     mapping (uint => uint256) public payouts;                   // keeps record of each payout
619     mapping (uint => uint256) public payouts1;                   // keeps record of each payout
620     mapping (uint => uint256) public payouts2;                   // keeps record of each payout
621     FEGex2 fegexpair;
622     event STAKED(address staker, uint256 tokens);
623     event ACTIVATED(address staker, uint256 cost);
624     event START(address staker, uint256 tokens);
625     event EARNED(address staker, uint256 tokens);
626     event UNSTAKED(address staker, uint256 tokens);
627     event PAYOUT(uint256 round, uint256 tokens, address sender);
628     event PAYOUT1(uint256 round, uint256 tokens, address sender);
629     event PAYOUT2(uint256 round, uint256 tokens, address sender);
630     event CLAIMEDREWARD(address staker, uint256 reward);
631     event CLAIMEDREWARD1(address staker, uint256 reward);
632     event CLAIMEDREWARD2(address staker, uint256 reward);
633     
634     constructor(){
635     fegexpair = FEGex2(FETP);
636     }
637     
638     receive() external payable {
639     }
640 
641     function changeFEGExPair(FEGex2 _fegexpair, address addy) external onlyOwner{ // Incase FEGex updates in future
642         require(address(_fegexpair) != address(0), "setting 0 to contract");
643         fegexpair = _fegexpair;
644         FETP = addy;
645     }
646     
647     function changeTRY(address _try) external onlyOwner{ // Incase TRY updates in future
648         TRY = _try;
649     }
650     
651     function changeScalerize(uint _sca) public onlyOwner{
652         require(_sca != 0, "You cannot turn off");
653         scalerize = _sca;
654     }
655     
656     function changeScalatize(uint _scm) public onlyOwner {
657         require(_scm != 0, "You cannot turn off");
658         scaleatize = _scm;
659     }
660     
661     function isStakeholder(address _address)
662        public
663        view
664        returns(bool)
665    {
666        
667        if(stakers[_address].initialized) return true;
668        else return false;
669    }
670    
671    function addStakeholder(address _stakeholder)
672        internal
673    {
674        (bool _isStakeholder) = isStakeholder(_stakeholder);
675        if(!_isStakeholder) {
676            farmTime[msg.sender] =  block.timestamp;
677            stakers[_stakeholder].initialized = true;
678        }
679    }
680    
681    // ------------------------------------------------------------------------
682     // Token holders can stake their tokens using this function
683     // @param tokens number of tokens to stake
684     // ------------------------------------------------------------------------
685 
686     function calcPoolInGivenSingleOut(
687         uint tokenBalanceOut,
688         uint tokenWeightOut,
689         uint poolSupply,
690         uint totalWeight,
691         uint tokenAmountOut,
692         uint swapFee
693     )
694         public pure
695         returns (uint poolAmountIn)
696     {
697 
698 
699         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
700         uint zar = bmul(bsub(BASE, normalizedWeight), swapFee);
701         uint tokenAmountOutBeforeSwapFee = bdiv(tokenAmountOut, bsub(BASE, zar));
702 
703         uint newTokenBalanceOut = bsub(tokenBalanceOut, tokenAmountOutBeforeSwapFee);
704         uint tokenOutRatio = bdiv(newTokenBalanceOut, tokenBalanceOut);
705 
706 
707         uint poolRatio = bpow(tokenOutRatio, normalizedWeight);
708         uint newPoolSupply = bmul(poolRatio, poolSupply);
709         uint poolAmountInAfterExitFee = bsub(poolSupply, newPoolSupply);
710 
711 
712         poolAmountIn = bdiv(poolAmountInAfterExitFee, bsub(BASE, 0));
713         return (poolAmountIn);
714     }
715     
716     function calcSingleOutGivenPoolIn(
717         uint tokenBalanceOut,
718         uint tokenWeightOut,
719         uint poolSupply,
720         uint totalWeight,
721         uint poolAmountIn,
722         uint swapFee
723     )
724         public pure
725         returns (uint tokenAmountOut)
726     {
727         uint normalizedWeight = bdiv(tokenWeightOut, totalWeight);
728 
729         uint poolAmountInAfterExitFee = bmul(poolAmountIn, bsub(BASE, 0));
730         uint newPoolSupply = bsub(poolSupply, poolAmountInAfterExitFee);
731         uint poolRatio = bdiv(newPoolSupply, poolSupply);
732 
733 
734         uint tokenOutRatio = bpow(poolRatio, bdiv(BASE, normalizedWeight));
735         uint newTokenBalanceOut = bmul(tokenOutRatio, tokenBalanceOut);
736 
737         uint tokenAmountOutBeforeSwapFee = bsub(tokenBalanceOut, newTokenBalanceOut);
738         uint zaz = bmul(bsub(BASE, normalizedWeight), swapFee);
739         tokenAmountOut = bmul(tokenAmountOutBeforeSwapFee, bsub(BASE, zaz));
740         return tokenAmountOut;
741     }
742 
743     function calcPoolOutGivenSingleIn(
744         uint tokenBalanceIn,
745         uint tokenWeightIn,
746         uint poolSupply,
747         uint totalWeight,
748         uint tokenAmountIn,
749         uint swapFee
750     )
751         public pure
752         returns (uint poolAmountOut)
753     {
754 
755         uint normalizedWeight = bdiv(tokenWeightIn, totalWeight);
756         uint zaz = bmul(bsub(BASE, normalizedWeight), swapFee);
757         uint tokenAmountInAfterFee = bmul(tokenAmountIn, bsub(BASE, zaz));
758 
759         uint newTokenBalanceIn = badd(tokenBalanceIn, tokenAmountInAfterFee);
760         uint tokenInRatio = bdiv(newTokenBalanceIn, tokenBalanceIn);
761 
762  
763         uint poolRatio = bpow(tokenInRatio, normalizedWeight);
764         uint newPoolSupply = bmul(poolRatio, poolSupply);
765         poolAmountOut = bsub(newPoolSupply, poolSupply);
766         return (poolAmountOut);
767     }
768      
769     function calcOutGivenIn(
770         uint tokenBalanceIn,
771         uint tokenWeightIn,
772         uint tokenBalanceOut,
773         uint tokenWeightOut,
774         uint tokenAmountIn,
775         uint swapFee
776     )
777         public pure
778         returns (uint tokenAmountOut, uint tokenInFee)
779     {
780         uint weightRatio = bdiv(tokenWeightIn, tokenWeightOut);
781         uint adjustedIn = bsub(BASE, swapFee);
782         adjustedIn = bmul(tokenAmountIn, adjustedIn);
783         uint y = bdiv(tokenBalanceIn, badd(tokenBalanceIn, adjustedIn));
784         uint foo = bpow(y, weightRatio);
785         uint bar = bsub(BASE, foo);
786         tokenAmountOut = bmul(tokenBalanceOut, bar);
787         tokenInFee = bsub(tokenAmountIn, adjustedIn);
788         return (tokenAmountOut, tokenInFee);
789     }
790 
791     function calcInGivenOut(
792         uint tokenBalanceIn,
793         uint tokenWeightIn,
794         uint tokenBalanceOut,
795         uint tokenWeightOut,
796         uint tokenAmountOut,
797         uint swapFee
798     )
799         public pure
800         returns (uint tokenAmountIn)
801     {
802         uint weightRatio = bdiv(tokenWeightOut, tokenWeightIn);
803         uint diff = bsub(tokenBalanceOut, tokenAmountOut);
804         uint y = bdiv(tokenBalanceOut, diff);
805         uint foo = bpow(y, weightRatio);
806         foo = bsub(foo, BASE);
807         foo = bmul(tokenBalanceIn, foo);
808         tokenAmountIn = bsub(BASE, swapFee);
809         tokenAmountIn = bdiv(foo, tokenAmountIn);
810         return (tokenAmountIn);
811     }
812 
813     function activateUserStaking() public payable{ // Activation of FEGstake costs 0.02 fETH which is automatically refunded to your wallet in the form of TRY.
814         require(msg.value == must, "You must deposit the right amount to activate");
815       
816         fegexpair.BUY{value: msg.value }(msg.sender, 100);
817         stakers[msg.sender].activated = true;
818         
819         emit ACTIVATED(msg.sender, msg.value);
820     }
821 
822     function isActivated(address staker) public view returns(bool){
823         if(stakers[staker].activated) return true;
824        else return false;
825     }
826     
827     function Start(uint256 tokens) public onlyOwner returns(uint poolAmountOut){
828         require(live == false, "Can only use once");
829         require(IERC20(FEG).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user for locking");
830         uint256 transferTxFee = (onePercent(tokens).mul(scailment)).div(10);
831         uint256 tokensToStake = (tokens.sub(transferTxFee));
832         addStakeholder(msg.sender);
833 
834         _mint(tokensToStake);
835         live = true;
836         IERC20(poolShares).transfer(msg.sender, tokensToStake);
837         IERC20(address(fETH)).approve(address(FETP), 1000000000000000000000e18);        
838     
839         emit START(msg.sender, tokensToStake);    
840         
841         return poolAmountOut;
842     }
843     
844     function STAKE(uint256 tokens) public returns(uint poolAmountOut){ 
845         require(IERC20(FEG).balanceOf(msg.sender) >= tokens, "You do not have enough FEG");
846         require(stakers[msg.sender].activated == true);
847         require(live == true);
848         uint256 transferTxFee = (onePercent(tokens).mul(scailment)).div(10);
849         uint256 tokensToStake = (tokens.sub(transferTxFee));
850         uint256 totalFEG = IERC20(FEG).balanceOf(address(this));
851         addStakeholder(msg.sender);
852         
853         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
854             uint256 owing = pendingReward(msg.sender);
855             stakers[msg.sender].remainder += owing;
856             stakers[msg.sender].lastDividends = owing;
857             stakers[msg.sender].fromTotalDividend = totalDividends;
858             stakers[msg.sender].round =  round;
859             
860             uint256 owing1 = pendingReward1(msg.sender);
861             stakers[msg.sender].remainder1 += owing1;
862             stakers[msg.sender].lastDividends1 = owing1;
863             stakers[msg.sender].fromTotalDividend1 = totalDividends1;
864             stakers[msg.sender].round1 =  round1;
865             
866             uint256 owing2 = pendingReward2(msg.sender);
867             stakers[msg.sender].remainder2 += owing2;
868             stakers[msg.sender].lastDividends2 = owing2;
869             stakers[msg.sender].fromTotalDividend2 = totalDividends2;
870             stakers[msg.sender].round2 =  round2;
871             
872         poolAmountOut = calcPoolOutGivenSingleIn(
873                             totalFEG,
874                             bmul(BASE, 25),
875                             _totalSupply,
876                             bmul(BASE, 25),
877                             tokensToStake,
878                             0
879                         );
880                         
881         require(IERC20(FEG).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user for locking");                
882         _mint(poolAmountOut);
883         IERC20(poolShares).transfer(msg.sender, poolAmountOut);
884             
885         emit STAKED(msg.sender, tokens); 
886             
887         return poolAmountOut;
888         
889     }
890 
891     
892     // ------------------------------------------------------------------------
893     // Owners can send the funds to be distributed to stakers using this function
894     // @param tokens number of tokens to distribute
895     // ------------------------------------------------------------------------
896 
897     function ADDFUNDS1(uint256 tokens) public onlyWhitelistAdmin{
898         require(IERC20(fETH).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
899         
900         uint256 tokens_ = bmul(tokens, bdiv(99, 100));
901         totalWrap = badd(totalWrap, tokens_);
902         _addPayout(tokens_);
903     }
904     
905     function ADDFUNDS2(uint256 tokens) public onlyWhitelistAdmin{
906         require(IERC20(USDT).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
907         
908         uint256 tokens_ = bmul(tokens, bdiv(99, 100));
909         totalWrap1 = badd(totalWrap1, tokens_);
910         _addPayout1(tokens_);
911     }
912     
913     function ADDFUNDS3(uint256 tokens) public onlyWhitelistAdmin{
914         require(IERC20(BTC).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
915         uint256 tokens_ = bmul(tokens, bdiv(99, 100));
916         totalWrap2 = badd(totalWrap2, tokens_);
917         _addPayout2(tokens_);
918     }
919     
920     // ------------------------------------------------------------------------
921     // Private function to register payouts
922     // ------------------------------------------------------------------------
923     function _addPayout(uint256 tokens_) private {
924          // divide the funds among the currently staked tokens
925         // scale the deposit and add the previous remainder
926         uint256 totalShares = _totalSupply;
927         uint256 available = (tokens_.mul(scaling)).add(scaledRemainder); 
928         uint256 dividendPerToken = available.div(totalShares);
929         scaledRemainder = available.mod(totalShares);
930         totalDividends = totalDividends.add(dividendPerToken);
931         payouts[round] = payouts[round - 1].add(dividendPerToken);
932         emit PAYOUT(round, tokens_, msg.sender);
933         round++;
934         
935     }
936     
937     function _addPayout1(uint256 tokens_1) private{
938         // divide the funds among the currently staked tokens
939         // scale the deposit and add the previous remainder
940         uint256 totalShares = _totalSupply;
941         uint256 available = (tokens_1.mul(scaling)).add(scaledRemainder1); 
942         uint256 dividendPerToken = available.div(totalShares);
943         scaledRemainder1 = available.mod(totalShares);
944         totalDividends1 = totalDividends1.add(dividendPerToken);
945         payouts1[round1] = payouts1[round1 - 1].add(dividendPerToken);
946         emit PAYOUT1(round1, tokens_1, msg.sender);
947         round1++;
948     }
949     
950     function _addPayout2(uint256 tokens_2) private{
951         // divide the funds among the currently staked tokens
952         // scale the deposit and add the previous remainder
953         uint256 totalShares = _totalSupply;
954         uint256 available = (tokens_2.mul(scaling)).add(scaledRemainder2); 
955         uint256 dividendPerToken = available.div(totalShares);
956         scaledRemainder2 = available.mod(totalShares);
957         totalDividends2 = totalDividends2.add(dividendPerToken);
958         payouts2[round2] = payouts2[round2 - 1].add(dividendPerToken);
959         emit PAYOUT2(round2, tokens_2, msg.sender);
960         round2++;
961     }
962     
963     // ------------------------------------------------------------------------
964     // Stakers can claim their pending rewards using this function
965     // ------------------------------------------------------------------------
966     function CLAIMREWARD() public nonReentrant{
967         
968             uint256 owing = pendingReward(msg.sender);
969         if(owing > 0){
970             owing = owing.add(stakers[msg.sender].remainder);
971             stakers[msg.sender].remainder = 0;
972         
973             require(IERC20(fETH).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
974         
975             emit CLAIMEDREWARD(msg.sender, owing);
976             totalWrap = bsub(totalWrap, owing);
977             stakers[msg.sender].lastDividends = owing; // unscaled
978             stakers[msg.sender].round = round; // update the round
979             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
980         }
981     }
982     
983     function CLAIMREWARD1() public nonReentrant {
984         
985             uint256 owing1 = pendingReward1(msg.sender);
986         if(owing1 > 0){
987             owing1 = owing1.add(stakers[msg.sender].remainder1);
988             stakers[msg.sender].remainder1 = 0;
989         
990             require(IERC20(USDT).transfer(msg.sender,owing1), "ERROR: error in sending reward from contract");
991         
992             emit CLAIMEDREWARD1(msg.sender, owing1);
993             totalWrap1 = bsub(totalWrap1, owing1);
994             stakers[msg.sender].lastDividends1 = owing1; // unscaled
995             stakers[msg.sender].round1 = round1; // update the round
996             stakers[msg.sender].fromTotalDividend1 = totalDividends1; // scaled
997         }
998     }
999     
1000     function CLAIMREWARD2() public nonReentrant {
1001       
1002             uint256 owing2 = pendingReward2(msg.sender);
1003         if(owing2 > 0){
1004             owing2 = owing2.add(stakers[msg.sender].remainder2);
1005             stakers[msg.sender].remainder2 = 0;
1006         
1007             require(IERC20(BTC).transfer(msg.sender, owing2), "ERROR: error in sending reward from contract");
1008         
1009             emit CLAIMEDREWARD2(msg.sender, owing2);
1010             totalWrap2 = bsub(totalWrap2, owing2);
1011             stakers[msg.sender].lastDividends2 = owing2; // unscaled
1012             stakers[msg.sender].round2 = round2; // update the round
1013             stakers[msg.sender].fromTotalDividend2 = totalDividends2; // scaled
1014         }
1015     }
1016     
1017     function CLAIMALLREWARD() public { 
1018         distribute12();
1019         CLAIMREWARD();
1020         CLAIMREWARD1();
1021         
1022         if(perform3==true){
1023         distribute23();    
1024         CLAIMREWARD2();   
1025         }
1026     }
1027     
1028     // ------------------------------------------------------------------------
1029     // Get the pending rewards of the staker
1030     // @param _staker the address of the staker
1031     // ------------------------------------------------------------------------    
1032 
1033     function pendingReward(address staker) private returns (uint256) {
1034         require(staker != address(0), "ERC20: sending to the zero address");
1035         uint256 yourBase = IERC20(poolShares).balanceOf(msg.sender);
1036         uint stakersRound = stakers[staker].round;
1037         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(yourBase)).div(scaling);
1038         stakers[staker].remainder += ((totalDividends.sub(payouts[stakersRound - 1])).mul(yourBase)) % scaling;
1039         return (bmul(amount, bdiv(scalerize, 100)));
1040     }
1041     
1042     function pendingReward1(address staker) private returns (uint256) {
1043         require(staker != address(0), "ERC20: sending to the zero address");
1044         uint256 yourBase = IERC20(poolShares).balanceOf(msg.sender);
1045         uint stakersRound = stakers[staker].round1;
1046         uint256 amount1 =  ((totalDividends1.sub(payouts1[stakersRound - 1])).mul(yourBase)).div(scaling);
1047         stakers[staker].remainder1 += ((totalDividends1.sub(payouts1[stakersRound - 1])).mul(yourBase)) % scaling;
1048         return (bmul(amount1, bdiv(scalerize, 100)));
1049     }
1050     
1051     function pendingReward2(address staker) private returns (uint256) {
1052         require(staker != address(0), "ERC20: sending to the zero address");
1053         uint256 yourBase = IERC20(poolShares).balanceOf(msg.sender);
1054         uint stakersRound = stakers[staker].round2;
1055         uint256 amount2 =  ((totalDividends2.sub(payouts2[stakersRound - 1])).mul(yourBase)).div(scaling);
1056         stakers[staker].remainder2 += ((totalDividends2.sub(payouts2[stakersRound - 1])).mul(yourBase)) % scaling;
1057         return (bmul(amount2, bdiv(scalerize, 100)));
1058     }
1059     
1060     function getPending1(address staker) public view returns(uint256 _pendingReward) {
1061         require(staker != address(0), "ERC20: sending to the zero address");
1062         uint256 yourBase = IERC20(poolShares).balanceOf(staker);
1063         uint stakersRound = stakers[staker].round; 
1064         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(yourBase)).div(scaling);
1065         amount += ((totalDividends.sub(payouts[stakersRound - 1])).mul(yourBase)) % scaling;
1066         return (bmul(amount.add(stakers[staker].remainder), bdiv(scalerize, 100)));
1067     }
1068     
1069     function getPending2(address staker) public view returns(uint256 _pendingReward) {
1070         require(staker != address(0), "ERC20: sending to the zero address");
1071         uint256 yourBase = IERC20(poolShares).balanceOf(staker);
1072         uint stakersRound = stakers[staker].round1;
1073         uint256 amount1 = ((totalDividends1.sub(payouts1[stakersRound - 1])).mul(yourBase)).div(scaling);
1074         amount1 += ((totalDividends1.sub(payouts1[stakersRound - 1])).mul(yourBase)) % scaling;
1075         return (bmul(amount1.add(stakers[staker].remainder1), bdiv(scalerize, 100)));
1076     }
1077     
1078     function getPending3(address staker) public view returns(uint256 _pendingReward) {
1079         require(staker != address(0), "ERC20: sending to the zero address");
1080         uint256 yourBase = IERC20(poolShares).balanceOf(staker);
1081         uint stakersRound = stakers[staker].round2;
1082         uint256 amount2 =  ((totalDividends2.sub(payouts2[stakersRound - 1])).mul(yourBase)).div(scaling);
1083         amount2 += ((totalDividends2.sub(payouts2[stakersRound - 1])).mul(yourBase)) % scaling;
1084         return (bmul(amount2.add(stakers[staker].remainder2), bdiv(scalerize, 100)));
1085     
1086     }
1087         // ------------------------------------------------------------------------
1088     // Get the FEG balance of the token holder
1089     // @param user the address of the token holder
1090     // ------------------------------------------------------------------------
1091     function userStakedFEG(address user) external view returns(uint256 StakedFEG){
1092         require(user != address(0), "ERC20: sending to the zero address");
1093         uint256 totalFEG = IERC20(FEG).balanceOf(address(this));
1094         uint256 yourStakedFEG = calcSingleOutGivenPoolIn(
1095                             totalFEG, 
1096                             bmul(BASE, 25),
1097                             _totalSupply,
1098                             bmul(BASE, 25),
1099                             IERC20(poolShares).balanceOf(address(user)),
1100                             0
1101                         );
1102         
1103         return yourStakedFEG;
1104     }
1105     
1106     // ------------------------------------------------------------------------
1107     // Stakers can un stake the staked tokens using this function
1108     // @param tokens the number of tokens to withdraw
1109     // ------------------------------------------------------------------------
1110     function WITHDRAW(address to, uint256 _tokens) external returns (uint tokenAmountOut) {
1111         uint256 totalFEG = IERC20(FEG).balanceOf(address(this));
1112         require(stakers[msg.sender].activated == true);
1113         
1114         if(perform==true) {
1115         regreward(regrewardContract).distributeV2();
1116         }
1117         
1118         CLAIMALLREWARD();
1119 
1120         uint256 tokens = calcPoolInGivenSingleOut(
1121                             totalFEG,
1122                             bmul(BASE, 25),
1123                             _totalSupply,
1124                             bmul(BASE, 25),
1125                             _tokens,
1126                             0
1127                         );
1128                         
1129         tokenAmountOut = calcSingleOutGivenPoolIn(
1130                             totalFEG, 
1131                             bmul(BASE, 25),
1132                             _totalSupply,
1133                             bmul(BASE, 25),
1134                             tokens,
1135                             0
1136                         ); 
1137         require(tokens <= IERC20(poolShares).balanceOf(msg.sender), "You don't have enough FEG");
1138         _pullPoolShare(tokens);
1139         _burn(tokens);
1140         require(IERC20(FEG).transfer(to, tokenAmountOut), "Error in un-staking tokens");
1141         
1142         emit UNSTAKED(msg.sender, tokens);
1143         
1144         return tokenAmountOut;
1145     }
1146     
1147     function _pullPoolShare(uint amount)
1148         internal
1149     {
1150         bool xfer = IERC20(poolShares).transferFrom(msg.sender, address(this), amount);
1151         require(xfer, "ERR_ERC20_FALSE");
1152     }    
1153 
1154     // ------------------------------------------------------------------------
1155     // Private function to calculate 1% percentage
1156     // ------------------------------------------------------------------------
1157     function onePercent(uint256 _tokens) private pure returns (uint256){
1158         uint256 roundValue = _tokens.ceil(100);
1159         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
1160         return onePercentofTokens;
1161     }
1162     
1163     function emergencySaveLostTokens(address to, address _token, uint256 _amt) public onlyOwner {
1164         require(_token != FEG, "Cannot remove users FEG");
1165         require(_token != fETH, "Cannot remove users fETH");
1166         require(_token != USDT, "Cannot remove users fUSDT");
1167         require(_token != BTC, "Cannot remove users fBTC");
1168         require(IERC20(_token).transfer(to, _amt), "Error in retrieving tokens");
1169         payable(owner).transfer(address(this).balance);
1170     }
1171     
1172     function changeregrewardContract(address _regrewardContract) external onlyOwner{
1173         require(address(_regrewardContract) != address(0), "setting 0 to contract");
1174         regrewardContract = _regrewardContract;
1175     }
1176    
1177     function changePerform(bool _bool) external onlyOwner{
1178         perform = _bool;
1179     }
1180 
1181     function changePerform2(bool _bool) external onlyOwner{
1182         perform2 = _bool;
1183     }
1184     
1185     function changePerform3(bool _bool) external onlyOwner{
1186         perform3 = _bool;
1187     }
1188     
1189     function changeMust(uint256 _must) external onlyOwner{
1190         require(must !=0, "Cannot set to 0");
1191         require(must <= 3e15, "Cannot set over 0.003 fETH");
1192         must = _must;
1193     }
1194     
1195     function updateBase(address _BTC, address _ETH, address _USDT) external onlyOwner{ // Incase wraps ever update
1196         BTC = _BTC;
1197         fETH = _ETH;
1198         USDT = _USDT;
1199     }
1200     
1201     function distribute12() public {
1202         if (IERC20(fETH).balanceOf(address(this)) > badd(totalWrap, scaletor))  {
1203         distributeWrap1();
1204         }
1205         
1206         if(IERC20(USDT).balanceOf(address(this)) > badd(totalWrap1, scaletor1)){
1207         distributeWrap2();
1208         }
1209     }
1210     
1211     function distribute23() public {    
1212         if(perform3==true){
1213             if(IERC20(BTC).balanceOf(address(this)) > badd(totalWrap2, scaletor2)){
1214         distributeWrap3();}
1215         }
1216     }
1217     
1218     function changeScaletor(uint256 _sca, uint256 _sca1, uint256 _sca2) public onlyOwner {
1219         require(_sca !=0 && _sca1 !=0 && _sca2 !=0, "You cannot turn off");
1220         require(_sca >= 5e17 && _sca1 >= 20e18 && _sca2 >= 1e15, "Must be over minimum");
1221         scaletor = _sca;
1222         scaletor1 = _sca1;
1223         scaletor2 = _sca2;
1224     }
1225     
1226     function distributeWrap1() internal {
1227         uint256 wrapped = bsub(IERC20(fETH).balanceOf(address(this)), totalWrap);
1228         totalWrap = badd(totalWrap, wrapped);
1229         _addPayout(wrapped);
1230     }
1231 
1232     function distributeWrap2() internal {
1233         uint256 wrapped = bsub(IERC20(USDT).balanceOf(address(this)), totalWrap1);
1234         totalWrap1 = badd(totalWrap1, wrapped);
1235         _addPayout1(wrapped);
1236     }
1237     
1238     function distributeWrap3() internal {
1239         uint256 wrapped = bsub(IERC20(BTC).balanceOf(address(this)), totalWrap2);
1240         totalWrap2 = badd(totalWrap2, wrapped);
1241         _addPayout2(wrapped);
1242     }
1243     }