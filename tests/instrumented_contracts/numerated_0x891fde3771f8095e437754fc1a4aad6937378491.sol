1 /*
2 SPDX-License-Identifier: UNLICENSED
3 (c) Developed by AgroToken
4 This work is unlicensed.
5 */
6 pragma solidity 0.7.5;
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
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
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP.
166  */
167 interface IERC20 {
168     /**
169      * @dev Returns the amount of tokens in existence.
170      */
171     function totalSupply() external view returns (uint256);
172 
173     /**
174      * @dev Returns the amount of tokens owned by `account`.
175      */
176     function balanceOf(address account) external view returns (uint256);
177 
178     /**
179      * @dev Moves `amount` tokens from the caller's account to `recipient`.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transfer(address recipient, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(address owner, address spender) external view returns (uint256);
195 
196     /**
197      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * IMPORTANT: Beware that changing an allowance with this method brings the risk
202      * that someone may use both the old and the new allowance by unfortunate
203      * transaction ordering. One possible solution to mitigate this race
204      * condition is to first reduce the spender's allowance to 0 and set the
205      * desired value afterwards:
206      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207      *
208      * Emits an {Approval} event.
209      */
210     function approve(address spender, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Moves `amount` tokens from `sender` to `recipient` using the
214      * allowance mechanism. `amount` is then deducted from the caller's
215      * allowance.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Emitted when `value` tokens are moved from one account (`from`) to
225      * another (`to`).
226      *
227      * Note that `value` may be zero.
228      */
229     event Transfer(address indexed from, address indexed to, uint256 value);
230 
231     /**
232      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
233      * a call to {approve}. `value` is the new allowance.
234      */
235     event Approval(address indexed owner, address indexed spender, uint256 value);
236 }
237 
238 
239 /**
240  * @title AgroToken is token that refers to real grains
241  * AgroToken is a token admnistrated by AgroToken company 
242  * (represented by admin Ethereum address variable in this Smart Contract).
243  * AgroToken performs all administrative
244  * functions based on grain documentations and certifications in partnership
245  * with agro traders (called Grain Oracles) and in complaince with local authorities.
246  * */
247 contract AgroToken is IERC20 {
248     using SafeMath for uint256;
249 
250     //
251     // events
252     //
253     // mint/burn events
254     event Mint(address indexed _to, uint256 _amount, uint256 _newTotalSupply);
255     event Burn(address indexed _from, uint256 _amount, uint256 _newTotalSupply);
256 
257     // admin events
258     event BlockLockSet(uint256 _value);
259     event NewAdmin(address _newAdmin);
260     event NewManager(address _newManager);
261     event GrainStockChanged(
262         uint256 indexed contractId,
263         string grainCategory,
264         string grainContractInfo,
265         uint256 amount,
266         uint8 status,
267         uint256 newTotalSupplyAmount
268     );
269 
270     modifier onlyAdmin {
271         require(msg.sender == admin, "Only admin can perform this operation");
272         _;
273     }    
274 
275     modifier boardOrAdmin {
276         require(
277             msg.sender == board || msg.sender == admin,
278             "Only admin or board can perform this operation"
279         );
280         _;
281     }
282 
283     modifier blockLock(address _sender) {
284         require(
285             !isLocked() || _sender == admin,
286             "Contract is locked except for the admin"
287         );
288         _;
289     }
290 
291     struct Grain {
292         string category;
293         string contractInfo;
294         uint256 amount;
295         uint8 status;
296     }
297 
298     uint256 override public totalSupply;
299     string public name;
300     uint8 public decimals;
301     string public symbol;
302     address public admin;
303     address public board;    
304     uint256 public lockedUntilBlock;
305     uint256 public tokenizationFee;
306     uint256 public deTokenizationFee;
307     uint256 public transferFee;
308     mapping(address => uint256) public balances;
309     mapping(address => mapping(address => uint256)) public allowed;
310     Grain[] public grains;
311 
312     /**
313      * @dev Constructor
314      */
315     constructor() {
316         name = "AgroToken Corn Argentina";
317         decimals = 4;
318         symbol = "CORA";
319         lockedUntilBlock = 0;
320         admin = msg.sender;
321         board = 0xA01cD92f06f60b9fdcCCdF6280CE9A10803bA720;
322         totalSupply = 0;
323         balances[address(this)] = totalSupply;
324     }
325     
326 
327     /**
328      * @dev Add new grain contract to portfolio
329      * @param _grainCategory - Grain category
330      * @param _grainContractInfo - Grain Contract's details
331      * @param _grainAmount - amount of grain in tons
332      * @return success
333      */
334     function addNewGrainContract(        
335         string memory _grainCategory,
336         string memory _grainContractInfo,
337         uint256 _grainAmount
338     ) public onlyAdmin returns (bool success) {
339         Grain memory newGrain = Grain(
340             _grainCategory,
341             _grainContractInfo,
342             _grainAmount,
343             1
344         );
345         grains.push(newGrain);
346         _mint(address(this), _grainAmount);
347         emit GrainStockChanged(
348             grains.length-1,
349             _grainCategory,
350             _grainContractInfo,
351             _grainAmount,
352             1,
353             totalSupply
354         );
355         success = true;
356         return success;
357     }
358 
359     /**
360      * @dev Remove a contract from Portfolio
361      * @param _contractIndex - Contract Index within Portfolio
362      * @return True if success
363      */
364     function removeGrainContract(uint256 _contractIndex) public onlyAdmin returns (bool) {
365         require(
366             _contractIndex < grains.length,
367             "Invalid contract index number. Greater than total grain contracts"
368         );
369         Grain storage grain = grains[_contractIndex];
370         require(grain.status == 1, "This contract is no longer active");
371         require(_burn(address(this), grain.amount), "Could not to burn tokens");
372         grain.status = 0;
373         emit GrainStockChanged( 
374             _contractIndex,           
375             grain.category,
376             grain.contractInfo,
377             grain.amount,
378             grain.status,
379             totalSupply
380         );
381         return true;
382     }
383 
384     /**
385      * @dev Updates a Contract
386      * @param _contractIndex - Contract Index within Portfolio
387      * @param _grainCategory - Grain category
388      * @param _grainContractInfo - Grain Contract's details
389      * @param _grainAmount - amount of grain in tons
390      * @return True if success
391      */
392     function updateGrainContract(
393         uint256 _contractIndex,
394         string memory _grainCategory,
395         string memory _grainContractInfo,
396         uint256 _grainAmount
397     ) public onlyAdmin returns (bool) {
398         require(
399             _contractIndex < grains.length,
400             "Invalid contract index number. Greater than total grain contracts"
401         );
402         require(_grainAmount > 0, "Cannot set zero asset amount");
403         Grain storage grain = grains[_contractIndex];
404         require(grain.status == 1, "This contract is no longer active");
405         grain.category = _grainCategory;
406         grain.contractInfo = _grainContractInfo;
407         if (grain.amount > _grainAmount) {
408             _burn(address(this), grain.amount.sub(_grainAmount));
409         } else if (grain.amount < _grainAmount) {
410             _mint(address(this), _grainAmount.sub(grain.amount));           
411         }
412         grain.amount = _grainAmount;
413         emit GrainStockChanged(
414             _contractIndex,
415             grain.category,
416             grain.contractInfo,
417             grain.amount,
418             grain.status,
419             totalSupply
420         );
421         return true;
422     }
423 
424     /**
425      * @return Number of Grain Contracts in Portfolio
426      */
427     function totalContracts() public view returns (uint256) {
428         return grains.length;
429     }
430 
431     /**
432      * @dev ERC20 Transfer
433      * @param _to - destination address
434      * @param _value - value to transfer
435      * @return True if success
436      */
437     function transfer(address _to, uint256 _value)
438         override
439         external
440         blockLock(msg.sender)
441         returns (bool)
442     {
443         address from = (admin == msg.sender) ? address(this) : msg.sender;
444         require(
445             isTransferValid(from, _to, _value),
446             "Invalid Transfer Operation"
447         );
448         balances[from] = balances[from].sub(_value);
449         uint256 serviceAmount = 0;
450         uint256 netAmount = _value;      
451         (serviceAmount, netAmount) = calcFees(transferFee, _value); 
452         balances[_to] = balances[_to].add(netAmount);
453         balances[address(this)] = balances[address(this)].add(serviceAmount);
454         emit Transfer(from, _to, netAmount);
455         emit Transfer(from, address(this), serviceAmount);
456         return true;
457     }
458 
459 
460     /**
461      * @dev ERC20 TransferFrom
462      * @param _from - source address
463      * @param _to - destination address
464      * @param _value - value
465      * @return True if success
466      */
467     function transferFrom(address _from, address _to, uint256 _value)
468         override
469         external
470         blockLock(_from)
471         returns (bool)
472     {
473         // check sufficient allowance
474         require(
475             _value <= allowed[_from][msg.sender],
476             "Value informed is invalid"
477         );
478         require(
479             isTransferValid(_from, _to, _value),
480             "Invalid Transfer Operation"
481         );
482         // transfer tokens
483         balances[_from] = balances[_from].sub(_value);
484         uint256 serviceAmount = 0;
485         uint256 netAmount = _value;      
486         (serviceAmount, netAmount) = calcFees(transferFee, _value); 
487         balances[_to] = balances[_to].add(netAmount);
488         balances[address(this)] = balances[address(this)].add(serviceAmount);
489         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(
490             _value,
491             "Value lower than approval"
492         );
493 
494         emit Transfer(_from, _to, netAmount);
495         emit Transfer(_from, address(this), serviceAmount);
496         return true;
497     }
498 
499     /**
500      * @dev ERC20 Approve token transfers on behalf of other token owner
501      * @param _spender - destination address
502      * @param _value - value to be approved
503      * @return True if success
504      */
505     function approve(address _spender, uint256 _value)
506         override
507         external
508         blockLock(msg.sender)
509         returns (bool)
510     {
511         require(_spender != address(0), "ERC20: approve to the zero address");
512 
513         address from = (admin == msg.sender) ? address(this) : msg.sender;
514         require((_value == 0) || (allowed[from][_spender] == 0), "Allowance cannot be increased or decreased if value is different from zero");
515         allowed[from][_spender] = _value;
516         emit Approval(from, _spender, _value);
517         return true;
518     }
519 
520     /**
521      * @dev Atomically decreases the allowance granted to `spender` by the caller.
522      *
523      * This is an alternative to {approve} that can be used as a mitigation for
524      * problems described in {IERC20-approve}.
525      *
526      * Emits an {Approval} event indicating the updated allowance.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      * - `spender` must have allowance for the caller of at least
532      * `subtractedValue`.
533      */
534     function decreaseAllowance(address _spender, uint256 _subtractedValue) public virtual returns (bool) {
535         require(_spender != address(0), "ERC20: decreaseAllowance to the zero address");
536 
537         address from = (admin == msg.sender) ? address(this) : msg.sender;
538         require(allowed[from][_spender] >= _subtractedValue, "ERC20: decreased allowance below zero");
539         _approve(from, _spender, allowed[from][_spender].sub(_subtractedValue));
540 
541         return true;
542     }
543 
544     /**
545      * @dev Atomically increases the allowance granted to `spender` by the caller.
546      *
547      * This is an alternative to {approve} that can be used as a mitigation for
548      * problems described in {IERC20-approve}.
549      *
550      * Emits an {Approval} event indicating the updated allowance.
551      *
552      * Requirements:
553      *
554      * - `spender` cannot be the zero address.
555      */
556     function increaseAllowance(address _spender, uint256 _addedValue) public virtual returns (bool) {
557         require(_spender != address(0), "ERC20: decreaseAllowance to the zero address");
558 
559         address from = (admin == msg.sender) ? address(this) : msg.sender;
560         _approve(from, _spender, allowed[from][_spender].add(_addedValue));
561         return true;
562     }
563 
564     /**
565      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
566      *
567      * This internal function is equivalent to `approve`, and can be used to
568      * e.g. set automatic allowances for certain subsystems, etc.
569      *
570      * Emits an {Approval} event.
571      *
572      * Requirements:
573      *
574      * - `owner` cannot be the zero address.
575      * - `spender` cannot be the zero address.
576      */
577     function _approve(address _owner, address _spender, uint256 _amount) internal virtual {
578         require(_owner != address(0), "ERC20: approve from the zero address");
579         require(_spender != address(0), "ERC20: approve to the zero address");
580 
581         allowed[_owner][_spender] = _amount;
582         emit Approval(_owner, _spender, _amount);
583     }
584 
585     /**
586      * @dev withdraw tokens collected after receive fees 
587      * @param _to - destination address
588      * @param _value - value to transfer
589      * @return True if success
590      */
591     function withdraw(address _to, uint256 _value)
592         external
593         boardOrAdmin
594         returns (bool)
595     {
596         address from = address(this);
597         require(
598             isTransferValid(from, _to, _value),
599             "Invalid Transfer Operation"
600         );
601         balances[from] = balances[from].sub(_value);
602         balances[_to] = balances[_to].add(_value);
603         emit Transfer(from, _to, _value);
604         return true;
605     }
606 
607     /**
608      * @dev Mint new tokens. Can only be called by mana
609      * @param _to - destination address
610      * @param _value - value
611      * @return True if success
612      */
613     function _mint(address _to, uint256 _value)
614         internal
615         onlyAdmin        
616         returns (bool)
617     {
618         require(_to != address(0), "ERC20: mint to the zero address");
619         require(_to != admin, "Admin cannot mint tokens to herself");
620         uint256 serviceAmount;
621         uint256 netAmount;
622         (serviceAmount, netAmount) = calcFees(tokenizationFee, _value);
623 
624         balances[_to] = balances[_to].add(netAmount);
625         balances[address(this)] = balances[address(this)].add(serviceAmount);
626         totalSupply = totalSupply.add(_value);
627 
628         emit Mint(_to, netAmount, totalSupply);
629         emit Mint(address(this), serviceAmount, totalSupply);
630         emit Transfer(address(0), _to, netAmount);
631         emit Transfer(address(0), address(this), serviceAmount);
632 
633         return true;
634     }
635 
636     /**
637      * @dev Burn tokens
638      * @param _account - address
639      * @param _value - value
640      * @return True if success
641      */
642     function _burn(address _account, uint256 _value)
643         internal        
644         onlyAdmin
645         returns (bool)
646     {
647         require(_account != address(0), "ERC20: burn from the zero address");
648         uint256 serviceAmount;
649         uint256 netAmount;
650         (serviceAmount, netAmount) = calcFees(deTokenizationFee, _value);
651         totalSupply = totalSupply.sub(netAmount);
652         balances[_account] = balances[_account].sub(_value);
653         balances[address(this)] = balances[address(this)].add(serviceAmount);
654         emit Transfer(_account, address(0), netAmount);
655         emit Transfer(_account, address(this), serviceAmount);
656         emit Burn(_account, netAmount, totalSupply);        
657         return true;
658     }
659 
660     /**
661      * @dev Set block lock. Until that block (exclusive) transfers are disallowed
662      * @param _lockedUntilBlock - Block Number
663      * @return True if success
664      */
665     function setBlockLock(uint256 _lockedUntilBlock)
666         public
667         boardOrAdmin
668         returns (bool)
669     {
670         lockedUntilBlock = _lockedUntilBlock;
671         emit BlockLockSet(_lockedUntilBlock);
672         return true;
673     }
674 
675     /**
676      * @dev Replace current admin with new one
677      * @param _newAdmin New token admin
678      * @return True if success
679      */
680     function replaceAdmin(address _newAdmin)
681         public
682         boardOrAdmin
683         returns (bool)
684     {
685         require(_newAdmin != address(0x0), "Null address");
686         admin = _newAdmin;
687         emit NewAdmin(_newAdmin);
688         return true;
689     }
690 
691     /**
692     * @dev Change AgroToken fee values
693     * @param _feeType which fee is being changed. 1 = tokenizationFee, 2 = deTokenizationFee and 3 = transferFee
694     * @param _newAmount new fee value
695     * @return processing status
696     */
697     function changeFee(uint8 _feeType, uint256 _newAmount) external boardOrAdmin returns (bool) {
698         require(_newAmount<=2, "Invalid or exceed white paper definition");
699         require(_feeType >0 && _feeType<=3, "Invalid fee type");
700         if (_feeType == 1) {
701             tokenizationFee = _newAmount;
702         } else if (_feeType == 2) {
703             deTokenizationFee = _newAmount;
704         } else if (_feeType == 3) {
705             transferFee = _newAmount;
706         }
707         return true;
708     }
709 
710     /**
711      * @dev ERC20 balanceOf
712      * @param _owner Owner address
713      * @return True if success
714      */
715     function balanceOf(address _owner) public override view returns (uint256) {
716         return balances[_owner];
717     }
718 
719     /**
720      * @dev ERC20 allowance
721      * @param _owner Owner address
722      * @param _spender Address allowed to spend from Owner's balance
723      * @return uint256 allowance
724      */
725     function allowance(address _owner, address _spender)
726         override
727         external
728         view
729         returns (uint256)
730     {
731         return allowed[_owner][_spender];
732     }
733 
734     /**
735      * @dev Are transfers currently disallowed
736      * @return True if disallowed
737      */
738     function isLocked() public view returns (bool) {
739         return lockedUntilBlock > block.number;
740     }
741 
742     /**
743      * @dev Checks if transfer parameters are valid
744      * @param _from Source address
745      * @param _to Destination address
746      * @param _amount Amount to check
747      * @return True if valid
748      */
749     function isTransferValid(address _from, address _to, uint256 _amount)
750         public
751         view
752         returns (bool)
753     {
754         if (_from == address(0)) {
755             return false;
756         }
757 
758         if (_to == address(0) || _to == admin) {
759             return false;
760         }
761 
762         bool fromOK = true;
763         bool toOK = true;
764 
765         return
766             balances[_from] >= _amount && // sufficient balance
767             fromOK && // a seller holder within the whitelist
768             toOK; // a buyer holder within the whitelist
769     }
770 
771     /**
772     * @dev Calculates AgroToken fees over mint, burn and transfer operations
773     * @param _fee value of the fee
774     * @param _amount amount involved in the transaction
775     * @return serviceAmount value to be paid to AgroToken
776     * @return netAmount amount after fees
777     */
778     function calcFees(uint256 _fee, uint256 _amount) public pure returns(uint256 serviceAmount, uint256 netAmount ) {
779         serviceAmount = (_amount.mul(_fee)) / 100;
780         netAmount = _amount.sub(serviceAmount);
781         return (serviceAmount, netAmount);
782     }
783 }