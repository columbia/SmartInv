1 pragma solidity ^0.5.8;
2 
3 
4 interface ILiquidityPool {
5     
6     
7     function take(address _token, uint256 _amount) external;
8 
9     
10     
11     function deposit(address _token, uint256 _amount) external returns (uint256);
12 
13     
14     
15     function withdraw(address _token, uint256 _amount) external;
16 
17     
18     
19     
20     function isEther(address _ether) external pure returns (bool);
21 }
22 
23 interface IRebalancer {
24     
25     
26     
27     
28     
29     
30     function giveUnbalancedPosition(address _negToken, uint256 _negAmount, address _posToken, uint256 _posAmount) external payable;
31 }
32 
33 contract Context {
34     
35     
36     constructor () internal { }
37     
38 
39     function _msgSender() internal view returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view returns (bytes memory) {
44         this; 
45         return msg.data;
46     }
47 }
48 
49 contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     
55     constructor () internal {
56         _owner = _msgSender();
57         emit OwnershipTransferred(address(0), _owner);
58     }
59 
60     
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     
66     modifier onlyOwner() {
67         require(isOwner(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     
72     function isOwner() public view returns (bool) {
73         return _msgSender() == _owner;
74     }
75 
76     
77     function renounceOwnership() public onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     
83     function transferOwnership(address newOwner) public onlyOwner {
84         _transferOwnership(newOwner);
85     }
86 
87     
88     function _transferOwnership(address newOwner) internal {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 interface IERC20 {
96     
97     function totalSupply() external view returns (uint256);
98 
99     
100     function balanceOf(address account) external view returns (uint256);
101 
102     
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     
106     function allowance(address owner, address spender) external view returns (uint256);
107 
108     
109     function approve(address spender, uint256 amount) external returns (bool);
110 
111     
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 
114     
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 library SafeMath {
122     
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         
146         
147         
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return div(a, b, "SafeMath: division by zero");
161     }
162 
163     
164     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         
166         require(b > 0, errorMessage);
167         uint256 c = a / b;
168         
169 
170         return c;
171     }
172 
173     
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return mod(a, b, "SafeMath: modulo by zero");
176     }
177 
178     
179     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b != 0, errorMessage);
181         return a % b;
182     }
183 }
184 
185 contract ERC20 is Context, IERC20 {
186     using SafeMath for uint256;
187 
188     mapping (address => uint256) private _balances;
189 
190     mapping (address => mapping (address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193 
194     
195     function totalSupply() public view returns (uint256) {
196         return _totalSupply;
197     }
198 
199     
200     function balanceOf(address account) public view returns (uint256) {
201         return _balances[account];
202     }
203 
204     
205     function transfer(address recipient, uint256 amount) public returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     
211     function allowance(address owner, address spender) public view returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     
216     function approve(address spender, uint256 amount) public returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     
222     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228     
229     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
230         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
231         return true;
232     }
233 
234     
235     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
236         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
237         return true;
238     }
239 
240     
241     function _transfer(address sender, address recipient, uint256 amount) internal {
242         require(sender != address(0), "ERC20: transfer from the zero address");
243         require(recipient != address(0), "ERC20: transfer to the zero address");
244 
245         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
246         _balances[recipient] = _balances[recipient].add(amount);
247         emit Transfer(sender, recipient, amount);
248     }
249 
250     
251     function _mint(address account, uint256 amount) internal {
252         require(account != address(0), "ERC20: mint to the zero address");
253 
254         _totalSupply = _totalSupply.add(amount);
255         _balances[account] = _balances[account].add(amount);
256         emit Transfer(address(0), account, amount);
257     }
258 
259      
260     function _burn(address account, uint256 amount) internal {
261         require(account != address(0), "ERC20: burn from the zero address");
262 
263         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
264         _totalSupply = _totalSupply.sub(amount);
265         emit Transfer(account, address(0), amount);
266     }
267 
268     
269     function _approve(address owner, address spender, uint256 amount) internal {
270         require(owner != address(0), "ERC20: approve from the zero address");
271         require(spender != address(0), "ERC20: approve to the zero address");
272 
273         _allowances[owner][spender] = amount;
274         emit Approval(owner, spender, amount);
275     }
276 
277     
278     function _burnFrom(address account, uint256 amount) internal {
279         _burn(account, amount);
280         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
281     }
282 }
283 
284 library Address {
285     
286     function isContract(address account) internal view returns (bool) {
287         
288         
289         
290 
291         
292         
293         
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         
297         assembly { codehash := extcodehash(account) }
298         return (codehash != 0x0 && codehash != accountHash);
299     }
300 
301     
302     function toPayable(address account) internal pure returns (address payable) {
303         return address(uint160(account));
304     }
305 
306     
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         
311         (bool success, ) = recipient.call.value(amount)("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 }
315 
316 library SafeERC20 {
317     using SafeMath for uint256;
318     using Address for address;
319 
320     function safeTransfer(IERC20 token, address to, uint256 value) internal {
321         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
322     }
323 
324     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
325         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
326     }
327 
328     function safeApprove(IERC20 token, address spender, uint256 value) internal {
329         
330         
331         
332         
333         require((value == 0) || (token.allowance(address(this), spender) == 0),
334             "SafeERC20: approve from non-zero to non-zero allowance"
335         );
336         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
337     }
338 
339     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
340         uint256 newAllowance = token.allowance(address(this), spender).add(value);
341         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
342     }
343 
344     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
345         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
346         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
347     }
348 
349     
350     function callOptionalReturn(IERC20 token, bytes memory data) private {
351         
352         
353 
354         
355         
356         
357         
358         
359         require(address(token).isContract(), "SafeERC20: call to non-contract");
360 
361         
362         (bool success, bytes memory returndata) = address(token).call(data);
363         require(success, "SafeERC20: low-level call failed");
364 
365         if (returndata.length > 0) { 
366             
367             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
368         }
369     }
370 }
371 
372 contract CanReclaimTokens is Ownable {
373     using SafeERC20 for ERC20;
374 
375     mapping(address => bool) private recoverableTokensBlacklist;
376 
377     function blacklistRecoverableToken(address _token) public onlyOwner {
378         recoverableTokensBlacklist[_token] = true;
379     }
380 
381     
382     
383     function recoverTokens(address _token) external onlyOwner {
384         require(!recoverableTokensBlacklist[_token], "CanReclaimTokens: token is not recoverable");
385 
386         if (_token == address(0x0)) {
387             msg.sender.transfer(address(this).balance);
388         } else {
389             ERC20(_token).safeTransfer(msg.sender, ERC20(_token).balanceOf(address(this)));
390         }
391     }
392 }
393 
394 interface ComptrollerInterface {
395     
396     function isComptroller() external view returns (bool);
397 
398     
399 
400     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
401     function exitMarket(address cToken) external returns (uint);
402 
403     
404 
405     function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);
406     function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;
407 
408     function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);
409     function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
410 
411     function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);
412     function borrowVerify(address cToken, address borrower, uint borrowAmount) external;
413 
414     function repayBorrowAllowed(
415         address cToken,
416         address payer,
417         address borrower,
418         uint repayAmount) external returns (uint);
419     function repayBorrowVerify(
420         address cToken,
421         address payer,
422         address borrower,
423         uint repayAmount,
424         uint borrowerIndex) external;
425 
426     function liquidateBorrowAllowed(
427         address cTokenBorrowed,
428         address cTokenCollateral,
429         address liquidator,
430         address borrower,
431         uint repayAmount) external returns (uint);
432     function liquidateBorrowVerify(
433         address cTokenBorrowed,
434         address cTokenCollateral,
435         address liquidator,
436         address borrower,
437         uint repayAmount,
438         uint seizeTokens) external;
439 
440     function seizeAllowed(
441         address cTokenCollateral,
442         address cTokenBorrowed,
443         address liquidator,
444         address borrower,
445         uint seizeTokens) external returns (uint);
446     function seizeVerify(
447         address cTokenCollateral,
448         address cTokenBorrowed,
449         address liquidator,
450         address borrower,
451         uint seizeTokens) external;
452 
453     function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);
454     function transferVerify(address cToken, address src, address dst, uint transferTokens) external;
455 
456     
457 
458     function liquidateCalculateSeizeTokens(
459         address cTokenBorrowed,
460         address cTokenCollateral,
461         uint repayAmount) external view returns (uint, uint);
462 }
463 
464 contract ComptrollerErrorReporter {
465     enum Error {
466         NO_ERROR,
467         UNAUTHORIZED,
468         COMPTROLLER_MISMATCH,
469         INSUFFICIENT_SHORTFALL,
470         INSUFFICIENT_LIQUIDITY,
471         INVALID_CLOSE_FACTOR,
472         INVALID_COLLATERAL_FACTOR,
473         INVALID_LIQUIDATION_INCENTIVE,
474         MARKET_NOT_ENTERED, 
475         MARKET_NOT_LISTED,
476         MARKET_ALREADY_LISTED,
477         MATH_ERROR,
478         NONZERO_BORROW_BALANCE,
479         PRICE_ERROR,
480         REJECTION,
481         SNAPSHOT_ERROR,
482         TOO_MANY_ASSETS,
483         TOO_MUCH_REPAY
484     }
485 
486     enum FailureInfo {
487         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
488         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
489         EXIT_MARKET_BALANCE_OWED,
490         EXIT_MARKET_REJECTION,
491         SET_CLOSE_FACTOR_OWNER_CHECK,
492         SET_CLOSE_FACTOR_VALIDATION,
493         SET_COLLATERAL_FACTOR_OWNER_CHECK,
494         SET_COLLATERAL_FACTOR_NO_EXISTS,
495         SET_COLLATERAL_FACTOR_VALIDATION,
496         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
497         SET_IMPLEMENTATION_OWNER_CHECK,
498         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
499         SET_LIQUIDATION_INCENTIVE_VALIDATION,
500         SET_MAX_ASSETS_OWNER_CHECK,
501         SET_PENDING_ADMIN_OWNER_CHECK,
502         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
503         SET_PRICE_ORACLE_OWNER_CHECK,
504         SUPPORT_MARKET_EXISTS,
505         SUPPORT_MARKET_OWNER_CHECK,
506         SET_PAUSE_GUARDIAN_OWNER_CHECK
507     }
508 
509     
510     event Failure(uint error, uint info, uint detail);
511 
512     
513     function fail(Error err, FailureInfo info) internal returns (uint) {
514         emit Failure(uint(err), uint(info), 0);
515 
516         return uint(err);
517     }
518 
519     
520     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
521         emit Failure(uint(err), uint(info), opaqueError);
522 
523         return uint(err);
524     }
525 }
526 
527 contract TokenErrorReporter {
528     enum Error {
529         NO_ERROR,
530         UNAUTHORIZED,
531         BAD_INPUT,
532         COMPTROLLER_REJECTION,
533         COMPTROLLER_CALCULATION_ERROR,
534         INTEREST_RATE_MODEL_ERROR,
535         INVALID_ACCOUNT_PAIR,
536         INVALID_CLOSE_AMOUNT_REQUESTED,
537         INVALID_COLLATERAL_FACTOR,
538         MATH_ERROR,
539         MARKET_NOT_FRESH,
540         MARKET_NOT_LISTED,
541         TOKEN_INSUFFICIENT_ALLOWANCE,
542         TOKEN_INSUFFICIENT_BALANCE,
543         TOKEN_INSUFFICIENT_CASH,
544         TOKEN_TRANSFER_IN_FAILED,
545         TOKEN_TRANSFER_OUT_FAILED
546     }
547 
548     
549     enum FailureInfo {
550         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
551         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
552         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
553         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
554         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
555         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
556         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
557         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
558         BORROW_ACCRUE_INTEREST_FAILED,
559         BORROW_CASH_NOT_AVAILABLE,
560         BORROW_FRESHNESS_CHECK,
561         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
562         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
563         BORROW_MARKET_NOT_LISTED,
564         BORROW_COMPTROLLER_REJECTION,
565         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
566         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
567         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
568         LIQUIDATE_COMPTROLLER_REJECTION,
569         LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
570         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
571         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
572         LIQUIDATE_FRESHNESS_CHECK,
573         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
574         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
575         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED,
576         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED,
577         LIQUIDATE_SEIZE_COMPTROLLER_REJECTION,
578         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
579         LIQUIDATE_SEIZE_TOO_MUCH,
580         MINT_ACCRUE_INTEREST_FAILED,
581         MINT_COMPTROLLER_REJECTION,
582         MINT_EXCHANGE_CALCULATION_FAILED,
583         MINT_EXCHANGE_RATE_READ_FAILED,
584         MINT_FRESHNESS_CHECK,
585         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
586         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
587         MINT_TRANSFER_IN_FAILED,
588         MINT_TRANSFER_IN_NOT_POSSIBLE,
589         REDEEM_ACCRUE_INTEREST_FAILED,
590         REDEEM_COMPTROLLER_REJECTION,
591         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
592         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
593         REDEEM_EXCHANGE_RATE_READ_FAILED,
594         REDEEM_FRESHNESS_CHECK,
595         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
596         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
597         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
598         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
599         REDUCE_RESERVES_ADMIN_CHECK,
600         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
601         REDUCE_RESERVES_FRESH_CHECK,
602         REDUCE_RESERVES_VALIDATION,
603         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
604         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
605         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
606         REPAY_BORROW_COMPTROLLER_REJECTION,
607         REPAY_BORROW_FRESHNESS_CHECK,
608         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
609         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
610         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
611         SET_COLLATERAL_FACTOR_OWNER_CHECK,
612         SET_COLLATERAL_FACTOR_VALIDATION,
613         SET_COMPTROLLER_OWNER_CHECK,
614         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
615         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
616         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
617         SET_MAX_ASSETS_OWNER_CHECK,
618         SET_ORACLE_MARKET_NOT_LISTED,
619         SET_PENDING_ADMIN_OWNER_CHECK,
620         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
621         SET_RESERVE_FACTOR_ADMIN_CHECK,
622         SET_RESERVE_FACTOR_FRESH_CHECK,
623         SET_RESERVE_FACTOR_BOUNDS_CHECK,
624         TRANSFER_COMPTROLLER_REJECTION,
625         TRANSFER_NOT_ALLOWED,
626         TRANSFER_NOT_ENOUGH,
627         TRANSFER_TOO_MUCH
628     }
629 
630     
631     event Failure(uint error, uint info, uint detail);
632 
633     
634     function fail(Error err, FailureInfo info) internal returns (uint) {
635         emit Failure(uint(err), uint(info), 0);
636 
637         return uint(err);
638     }
639 
640     
641     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
642         emit Failure(uint(err), uint(info), opaqueError);
643 
644         return uint(err);
645     }
646 }
647 
648 contract CarefulMath {
649 
650     
651     enum MathError {
652         NO_ERROR,
653         DIVISION_BY_ZERO,
654         INTEGER_OVERFLOW,
655         INTEGER_UNDERFLOW
656     }
657 
658     
659     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
660         if (a == 0) {
661             return (MathError.NO_ERROR, 0);
662         }
663 
664         uint c = a * b;
665 
666         if (c / a != b) {
667             return (MathError.INTEGER_OVERFLOW, 0);
668         } else {
669             return (MathError.NO_ERROR, c);
670         }
671     }
672 
673     
674     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
675         if (b == 0) {
676             return (MathError.DIVISION_BY_ZERO, 0);
677         }
678 
679         return (MathError.NO_ERROR, a / b);
680     }
681 
682     
683     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
684         if (b <= a) {
685             return (MathError.NO_ERROR, a - b);
686         } else {
687             return (MathError.INTEGER_UNDERFLOW, 0);
688         }
689     }
690 
691     
692     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
693         uint c = a + b;
694 
695         if (c >= a) {
696             return (MathError.NO_ERROR, c);
697         } else {
698             return (MathError.INTEGER_OVERFLOW, 0);
699         }
700     }
701 
702     
703     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
704         (MathError err0, uint sum) = addUInt(a, b);
705 
706         if (err0 != MathError.NO_ERROR) {
707             return (err0, 0);
708         }
709 
710         return subUInt(sum, c);
711     }
712 }
713 
714 contract Exponential is CarefulMath {
715     uint constant expScale = 1e18;
716     uint constant halfExpScale = expScale/2;
717     uint constant mantissaOne = expScale;
718 
719     struct Exp {
720         uint mantissa;
721     }
722 
723     
724     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
725         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
726         if (err0 != MathError.NO_ERROR) {
727             return (err0, Exp({mantissa: 0}));
728         }
729 
730         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
731         if (err1 != MathError.NO_ERROR) {
732             return (err1, Exp({mantissa: 0}));
733         }
734 
735         return (MathError.NO_ERROR, Exp({mantissa: rational}));
736     }
737 
738     
739     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
740         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
741 
742         return (error, Exp({mantissa: result}));
743     }
744 
745     
746     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
747         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
748 
749         return (error, Exp({mantissa: result}));
750     }
751 
752     
753     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
754         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
755         if (err0 != MathError.NO_ERROR) {
756             return (err0, Exp({mantissa: 0}));
757         }
758 
759         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
760     }
761 
762     
763     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
764         (MathError err, Exp memory product) = mulScalar(a, scalar);
765         if (err != MathError.NO_ERROR) {
766             return (err, 0);
767         }
768 
769         return (MathError.NO_ERROR, truncate(product));
770     }
771 
772     
773     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
774         (MathError err, Exp memory product) = mulScalar(a, scalar);
775         if (err != MathError.NO_ERROR) {
776             return (err, 0);
777         }
778 
779         return addUInt(truncate(product), addend);
780     }
781 
782     
783     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
784         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
785         if (err0 != MathError.NO_ERROR) {
786             return (err0, Exp({mantissa: 0}));
787         }
788 
789         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
790     }
791 
792     
793     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
794         
795         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
796         if (err0 != MathError.NO_ERROR) {
797             return (err0, Exp({mantissa: 0}));
798         }
799         return getExp(numerator, divisor.mantissa);
800     }
801 
802     
803     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
804         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
805         if (err != MathError.NO_ERROR) {
806             return (err, 0);
807         }
808 
809         return (MathError.NO_ERROR, truncate(fraction));
810     }
811 
812     
813     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
814 
815         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
816         if (err0 != MathError.NO_ERROR) {
817             return (err0, Exp({mantissa: 0}));
818         }
819 
820         
821         
822         
823         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
824         if (err1 != MathError.NO_ERROR) {
825             return (err1, Exp({mantissa: 0}));
826         }
827 
828         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
829         
830         assert(err2 == MathError.NO_ERROR);
831 
832         return (MathError.NO_ERROR, Exp({mantissa: product}));
833     }
834 
835     
836     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
837         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
838     }
839 
840     
841     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
842         (MathError err, Exp memory ab) = mulExp(a, b);
843         if (err != MathError.NO_ERROR) {
844             return (err, ab);
845         }
846         return mulExp(ab, c);
847     }
848 
849     
850     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
851         return getExp(a.mantissa, b.mantissa);
852     }
853 
854     
855     function truncate(Exp memory exp) pure internal returns (uint) {
856         
857         return exp.mantissa / expScale;
858     }
859 
860     
861     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
862         return left.mantissa < right.mantissa;
863     }
864 
865     
866     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
867         return left.mantissa <= right.mantissa;
868     }
869 
870     
871     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
872         return left.mantissa > right.mantissa;
873     }
874 
875     
876     function isZeroExp(Exp memory value) pure internal returns (bool) {
877         return value.mantissa == 0;
878     }
879 }
880 
881 interface EIP20Interface {
882 
883     
884     function totalSupply() external view returns (uint256);
885 
886     
887     function balanceOf(address owner) external view returns (uint256 balance);
888 
889     
890     function transfer(address dst, uint256 amount) external returns (bool success);
891 
892     
893     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
894 
895     
896     function approve(address spender, uint256 amount) external returns (bool success);
897 
898     
899     function allowance(address owner, address spender) external view returns (uint256 remaining);
900 
901     event Transfer(address indexed from, address indexed to, uint256 amount);
902     event Approval(address indexed owner, address indexed spender, uint256 amount);
903 }
904 
905 interface EIP20NonStandardInterface {
906 
907     
908     function totalSupply() external view returns (uint256);
909 
910     
911     function balanceOf(address owner) external view returns (uint256 balance);
912 
913     
914     
915     
916     
917     
918 
919     
920     function transfer(address dst, uint256 amount) external;
921 
922     
923     
924     
925     
926     
927 
928     
929     function transferFrom(address src, address dst, uint256 amount) external;
930 
931     
932     function approve(address spender, uint256 amount) external returns (bool success);
933 
934     
935     function allowance(address owner, address spender) external view returns (uint256 remaining);
936 
937     event Transfer(address indexed from, address indexed to, uint256 amount);
938     event Approval(address indexed owner, address indexed spender, uint256 amount);
939 }
940 
941 contract ReentrancyGuard {
942     
943     uint256 private _guardCounter;
944 
945     constructor () internal {
946         
947         
948         _guardCounter = 1;
949     }
950 
951     
952     modifier nonReentrant() {
953         _guardCounter += 1;
954         uint256 localCounter = _guardCounter;
955         _;
956         require(localCounter == _guardCounter, "re-entered");
957     }
958 }
959 
960 interface InterestRateModel {
961     
962     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint, uint);
963 
964     
965     function isInterestRateModel() external view returns (bool);
966 }
967 
968 contract CToken is EIP20Interface, Exponential, TokenErrorReporter, ReentrancyGuard {
969     
970     bool public constant isCToken = true;
971 
972     
973     string public name;
974 
975     
976     string public symbol;
977 
978     
979     uint8 public decimals;
980 
981     
982 
983     uint internal constant borrowRateMaxMantissa = 0.0005e16;
984 
985     
986     uint internal constant reserveFactorMaxMantissa = 1e18;
987 
988     
989     address payable public admin;
990 
991     
992     address payable public pendingAdmin;
993 
994     
995     ComptrollerInterface public comptroller;
996 
997     
998     InterestRateModel public interestRateModel;
999 
1000     
1001     uint public initialExchangeRateMantissa;
1002 
1003     
1004     uint public reserveFactorMantissa;
1005 
1006     
1007     uint public accrualBlockNumber;
1008 
1009     
1010     uint public borrowIndex;
1011 
1012     
1013     uint public totalBorrows;
1014 
1015     
1016     uint public totalReserves;
1017 
1018     
1019     uint256 public totalSupply;
1020 
1021     
1022     mapping (address => uint256) internal accountTokens;
1023 
1024     
1025     mapping (address => mapping (address => uint256)) internal transferAllowances;
1026 
1027     
1028     struct BorrowSnapshot {
1029         uint principal;
1030         uint interestIndex;
1031     }
1032 
1033     
1034     mapping(address => BorrowSnapshot) internal accountBorrows;
1035 
1036 
1037     
1038 
1039     
1040     event AccrueInterest(uint interestAccumulated, uint borrowIndex, uint totalBorrows);
1041 
1042     
1043     event Mint(address minter, uint mintAmount, uint mintTokens);
1044 
1045     
1046     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
1047 
1048     
1049     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
1050 
1051     
1052     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
1053 
1054     
1055     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
1056 
1057 
1058     
1059 
1060     
1061     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
1062 
1063     
1064     event NewAdmin(address oldAdmin, address newAdmin);
1065 
1066     
1067     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
1068 
1069     
1070     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
1071 
1072     
1073     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
1074 
1075     
1076     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
1077 
1078 
1079     
1080     constructor(ComptrollerInterface comptroller_,
1081                 InterestRateModel interestRateModel_,
1082                 uint initialExchangeRateMantissa_,
1083                 string memory name_,
1084                 string memory symbol_,
1085                 uint8 decimals_,
1086                 address payable admin_) internal {
1087         
1088         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1089         require(initialExchangeRateMantissa > 0, "Initial exchange rate must be greater than zero.");
1090 
1091         
1092         admin = msg.sender;
1093         
1094         uint err = _setComptroller(comptroller_);
1095         require(err == uint(Error.NO_ERROR), "Setting comptroller failed");
1096 
1097         
1098         accrualBlockNumber = getBlockNumber();
1099         borrowIndex = mantissaOne;
1100 
1101         
1102         err = _setInterestRateModelFresh(interestRateModel_);
1103         require(err == uint(Error.NO_ERROR), "Setting interest rate model failed");
1104 
1105         name = name_;
1106         symbol = symbol_;
1107         decimals = decimals_;
1108 
1109         
1110         admin = admin_;
1111     }
1112 
1113     
1114     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1115         
1116         uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
1117         if (allowed != 0) {
1118             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
1119         }
1120 
1121         
1122         if (src == dst) {
1123             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1124         }
1125 
1126         
1127         uint startingAllowance = 0;
1128         if (spender == src) {
1129             startingAllowance = uint(-1);
1130         } else {
1131             startingAllowance = transferAllowances[src][spender];
1132         }
1133 
1134         
1135         MathError mathErr;
1136         uint allowanceNew;
1137         uint srcTokensNew;
1138         uint dstTokensNew;
1139 
1140         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1141         if (mathErr != MathError.NO_ERROR) {
1142             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1143         }
1144 
1145         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1146         if (mathErr != MathError.NO_ERROR) {
1147             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1148         }
1149 
1150         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1151         if (mathErr != MathError.NO_ERROR) {
1152             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1153         }
1154 
1155         
1156         
1157         
1158 
1159         accountTokens[src] = srcTokensNew;
1160         accountTokens[dst] = dstTokensNew;
1161 
1162         
1163         if (startingAllowance != uint(-1)) {
1164             transferAllowances[src][spender] = allowanceNew;
1165         }
1166 
1167         
1168         emit Transfer(src, dst, tokens);
1169 
1170         comptroller.transferVerify(address(this), src, dst, tokens);
1171 
1172         return uint(Error.NO_ERROR);
1173     }
1174 
1175     
1176     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1177         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1178     }
1179 
1180     
1181     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1182         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1183     }
1184 
1185     
1186     function approve(address spender, uint256 amount) external returns (bool) {
1187         address src = msg.sender;
1188         transferAllowances[src][spender] = amount;
1189         emit Approval(src, spender, amount);
1190         return true;
1191     }
1192 
1193     
1194     function allowance(address owner, address spender) external view returns (uint256) {
1195         return transferAllowances[owner][spender];
1196     }
1197 
1198     
1199     function balanceOf(address owner) external view returns (uint256) {
1200         return accountTokens[owner];
1201     }
1202 
1203     
1204     function balanceOfUnderlying(address owner) external returns (uint) {
1205         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1206         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1207         require(mErr == MathError.NO_ERROR);
1208         return balance;
1209     }
1210 
1211     
1212     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1213         uint cTokenBalance = accountTokens[account];
1214         uint borrowBalance;
1215         uint exchangeRateMantissa;
1216 
1217         MathError mErr;
1218 
1219         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1220         if (mErr != MathError.NO_ERROR) {
1221             return (uint(Error.MATH_ERROR), 0, 0, 0);
1222         }
1223 
1224         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1225         if (mErr != MathError.NO_ERROR) {
1226             return (uint(Error.MATH_ERROR), 0, 0, 0);
1227         }
1228 
1229         return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
1230     }
1231 
1232     
1233     function getBlockNumber() internal view returns (uint) {
1234         return block.number;
1235     }
1236 
1237     
1238     function borrowRatePerBlock() external view returns (uint) {
1239         (uint opaqueErr, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1240         require(opaqueErr == 0, "borrowRatePerBlock: interestRateModel.borrowRate failed"); 
1241         return borrowRateMantissa;
1242     }
1243 
1244     
1245     function supplyRatePerBlock() external view returns (uint) {
1246         
1247         uint exchangeRateMantissa = exchangeRateStored();
1248 
1249         (uint e0, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1250         require(e0 == 0, "supplyRatePerBlock: calculating borrowRate failed"); 
1251 
1252         (MathError e1, Exp memory underlying) = mulScalar(Exp({mantissa: exchangeRateMantissa}), totalSupply);
1253         require(e1 == MathError.NO_ERROR, "supplyRatePerBlock: calculating underlying failed");
1254 
1255         (MathError e2, Exp memory borrowsPer) = divScalarByExp(totalBorrows, underlying);
1256         require(e2 == MathError.NO_ERROR, "supplyRatePerBlock: calculating borrowsPer failed");
1257 
1258         (MathError e3, Exp memory oneMinusReserveFactor) = subExp(Exp({mantissa: mantissaOne}), Exp({mantissa: reserveFactorMantissa}));
1259         require(e3 == MathError.NO_ERROR, "supplyRatePerBlock: calculating oneMinusReserveFactor failed");
1260 
1261         (MathError e4, Exp memory supplyRate) = mulExp3(Exp({mantissa: borrowRateMantissa}), oneMinusReserveFactor, borrowsPer);
1262         require(e4 == MathError.NO_ERROR, "supplyRatePerBlock: calculating supplyRate failed");
1263 
1264         return supplyRate.mantissa;
1265     }
1266 
1267     
1268     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1269         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1270         return totalBorrows;
1271     }
1272 
1273     
1274     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1275         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1276         return borrowBalanceStored(account);
1277     }
1278 
1279     
1280     function borrowBalanceStored(address account) public view returns (uint) {
1281         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1282         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1283         return result;
1284     }
1285 
1286     
1287     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1288         
1289         MathError mathErr;
1290         uint principalTimesIndex;
1291         uint result;
1292 
1293         
1294         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1295 
1296         
1297         if (borrowSnapshot.principal == 0) {
1298             return (MathError.NO_ERROR, 0);
1299         }
1300 
1301         
1302         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1303         if (mathErr != MathError.NO_ERROR) {
1304             return (mathErr, 0);
1305         }
1306 
1307         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1308         if (mathErr != MathError.NO_ERROR) {
1309             return (mathErr, 0);
1310         }
1311 
1312         return (MathError.NO_ERROR, result);
1313     }
1314 
1315     
1316     function exchangeRateCurrent() public nonReentrant returns (uint) {
1317         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1318         return exchangeRateStored();
1319     }
1320 
1321     
1322     function exchangeRateStored() public view returns (uint) {
1323         (MathError err, uint result) = exchangeRateStoredInternal();
1324         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1325         return result;
1326     }
1327 
1328     
1329     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1330         if (totalSupply == 0) {
1331             
1332             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1333         } else {
1334             
1335             uint totalCash = getCashPrior();
1336             uint cashPlusBorrowsMinusReserves;
1337             Exp memory exchangeRate;
1338             MathError mathErr;
1339 
1340             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1341             if (mathErr != MathError.NO_ERROR) {
1342                 return (mathErr, 0);
1343             }
1344 
1345             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, totalSupply);
1346             if (mathErr != MathError.NO_ERROR) {
1347                 return (mathErr, 0);
1348             }
1349 
1350             return (MathError.NO_ERROR, exchangeRate.mantissa);
1351         }
1352     }
1353 
1354     
1355     function getCash() external view returns (uint) {
1356         return getCashPrior();
1357     }
1358 
1359     struct AccrueInterestLocalVars {
1360         MathError mathErr;
1361         uint opaqueErr;
1362         uint borrowRateMantissa;
1363         uint currentBlockNumber;
1364         uint blockDelta;
1365 
1366         Exp simpleInterestFactor;
1367 
1368         uint interestAccumulated;
1369         uint totalBorrowsNew;
1370         uint totalReservesNew;
1371         uint borrowIndexNew;
1372     }
1373 
1374     
1375     function accrueInterest() public returns (uint) {
1376         AccrueInterestLocalVars memory vars;
1377 
1378         
1379         (vars.opaqueErr, vars.borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1380         require(vars.borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1381         if (vars.opaqueErr != 0) {
1382             return failOpaque(Error.INTEREST_RATE_MODEL_ERROR, FailureInfo.ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, vars.opaqueErr);
1383         }
1384 
1385         
1386         vars.currentBlockNumber = getBlockNumber();
1387 
1388         
1389         (vars.mathErr, vars.blockDelta) = subUInt(vars.currentBlockNumber, accrualBlockNumber);
1390         assert(vars.mathErr == MathError.NO_ERROR); 
1391 
1392         
1393         (vars.mathErr, vars.simpleInterestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
1394         if (vars.mathErr != MathError.NO_ERROR) {
1395             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(vars.mathErr));
1396         }
1397 
1398         (vars.mathErr, vars.interestAccumulated) = mulScalarTruncate(vars.simpleInterestFactor, totalBorrows);
1399         if (vars.mathErr != MathError.NO_ERROR) {
1400             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(vars.mathErr));
1401         }
1402 
1403         (vars.mathErr, vars.totalBorrowsNew) = addUInt(vars.interestAccumulated, totalBorrows);
1404         if (vars.mathErr != MathError.NO_ERROR) {
1405             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(vars.mathErr));
1406         }
1407 
1408         (vars.mathErr, vars.totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), vars.interestAccumulated, totalReserves);
1409         if (vars.mathErr != MathError.NO_ERROR) {
1410             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(vars.mathErr));
1411         }
1412 
1413         (vars.mathErr, vars.borrowIndexNew) = mulScalarTruncateAddUInt(vars.simpleInterestFactor, borrowIndex, borrowIndex);
1414         if (vars.mathErr != MathError.NO_ERROR) {
1415             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(vars.mathErr));
1416         }
1417 
1418         
1419         
1420         
1421 
1422         
1423         accrualBlockNumber = vars.currentBlockNumber;
1424         borrowIndex = vars.borrowIndexNew;
1425         totalBorrows = vars.totalBorrowsNew;
1426         totalReserves = vars.totalReservesNew;
1427 
1428         
1429         emit AccrueInterest(vars.interestAccumulated, vars.borrowIndexNew, totalBorrows);
1430 
1431         return uint(Error.NO_ERROR);
1432     }
1433 
1434     
1435     function mintInternal(uint mintAmount) internal nonReentrant returns (uint) {
1436         uint error = accrueInterest();
1437         if (error != uint(Error.NO_ERROR)) {
1438             
1439             return fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED);
1440         }
1441         
1442         return mintFresh(msg.sender, mintAmount);
1443     }
1444 
1445     struct MintLocalVars {
1446         Error err;
1447         MathError mathErr;
1448         uint exchangeRateMantissa;
1449         uint mintTokens;
1450         uint totalSupplyNew;
1451         uint accountTokensNew;
1452     }
1453 
1454     
1455     function mintFresh(address minter, uint mintAmount) internal returns (uint) {
1456         
1457         uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
1458         if (allowed != 0) {
1459             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed);
1460         }
1461 
1462         
1463         if (accrualBlockNumber != getBlockNumber()) {
1464             return fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK);
1465         }
1466 
1467         MintLocalVars memory vars;
1468 
1469         
1470         vars.err = checkTransferIn(minter, mintAmount);
1471         if (vars.err != Error.NO_ERROR) {
1472             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_NOT_POSSIBLE);
1473         }
1474 
1475         
1476         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1477         if (vars.mathErr != MathError.NO_ERROR) {
1478             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1479         }
1480 
1481         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(mintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1482         if (vars.mathErr != MathError.NO_ERROR) {
1483             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_CALCULATION_FAILED, uint(vars.mathErr));
1484         }
1485 
1486         
1487         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1488         if (vars.mathErr != MathError.NO_ERROR) {
1489             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1490         }
1491 
1492         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1493         if (vars.mathErr != MathError.NO_ERROR) {
1494             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1495         }
1496 
1497         
1498         
1499         
1500 
1501         
1502         vars.err = doTransferIn(minter, mintAmount);
1503         if (vars.err != Error.NO_ERROR) {
1504             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_FAILED);
1505         }
1506 
1507         
1508         totalSupply = vars.totalSupplyNew;
1509         accountTokens[minter] = vars.accountTokensNew;
1510 
1511         
1512         emit Mint(minter, mintAmount, vars.mintTokens);
1513         emit Transfer(address(this), minter, vars.mintTokens);
1514 
1515         
1516         comptroller.mintVerify(address(this), minter, mintAmount, vars.mintTokens);
1517 
1518         return uint(Error.NO_ERROR);
1519     }
1520 
1521     
1522     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1523         uint error = accrueInterest();
1524         if (error != uint(Error.NO_ERROR)) {
1525             
1526             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1527         }
1528         
1529         return redeemFresh(msg.sender, redeemTokens, 0);
1530     }
1531 
1532     
1533     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1534         uint error = accrueInterest();
1535         if (error != uint(Error.NO_ERROR)) {
1536             
1537             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1538         }
1539         
1540         return redeemFresh(msg.sender, 0, redeemAmount);
1541     }
1542 
1543     struct RedeemLocalVars {
1544         Error err;
1545         MathError mathErr;
1546         uint exchangeRateMantissa;
1547         uint redeemTokens;
1548         uint redeemAmount;
1549         uint totalSupplyNew;
1550         uint accountTokensNew;
1551     }
1552 
1553     
1554     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1555         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1556 
1557         RedeemLocalVars memory vars;
1558 
1559         
1560         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1561         if (vars.mathErr != MathError.NO_ERROR) {
1562             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1563         }
1564 
1565         
1566         if (redeemTokensIn > 0) {
1567             
1568             vars.redeemTokens = redeemTokensIn;
1569 
1570             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1571             if (vars.mathErr != MathError.NO_ERROR) {
1572                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1573             }
1574         } else {
1575             
1576 
1577             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1578             if (vars.mathErr != MathError.NO_ERROR) {
1579                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1580             }
1581 
1582             vars.redeemAmount = redeemAmountIn;
1583         }
1584 
1585         
1586         uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1587         if (allowed != 0) {
1588             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
1589         }
1590 
1591         
1592         if (accrualBlockNumber != getBlockNumber()) {
1593             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1594         }
1595 
1596         
1597         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1598         if (vars.mathErr != MathError.NO_ERROR) {
1599             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1600         }
1601 
1602         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1603         if (vars.mathErr != MathError.NO_ERROR) {
1604             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1605         }
1606 
1607         
1608         if (getCashPrior() < vars.redeemAmount) {
1609             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1610         }
1611 
1612         
1613         
1614         
1615 
1616         
1617         vars.err = doTransferOut(redeemer, vars.redeemAmount);
1618         require(vars.err == Error.NO_ERROR, "redeem transfer out failed");
1619 
1620         
1621         totalSupply = vars.totalSupplyNew;
1622         accountTokens[redeemer] = vars.accountTokensNew;
1623 
1624         
1625         emit Transfer(redeemer, address(this), vars.redeemTokens);
1626         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
1627 
1628         
1629         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1630 
1631         return uint(Error.NO_ERROR);
1632     }
1633 
1634     
1635     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1636         uint error = accrueInterest();
1637         if (error != uint(Error.NO_ERROR)) {
1638             
1639             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1640         }
1641         
1642         return borrowFresh(msg.sender, borrowAmount);
1643     }
1644 
1645     struct BorrowLocalVars {
1646         Error err;
1647         MathError mathErr;
1648         uint accountBorrows;
1649         uint accountBorrowsNew;
1650         uint totalBorrowsNew;
1651     }
1652 
1653     
1654     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1655         
1656         uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
1657         if (allowed != 0) {
1658             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
1659         }
1660 
1661         
1662         if (accrualBlockNumber != getBlockNumber()) {
1663             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1664         }
1665 
1666         
1667         if (getCashPrior() < borrowAmount) {
1668             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1669         }
1670 
1671         BorrowLocalVars memory vars;
1672 
1673         
1674         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1675         if (vars.mathErr != MathError.NO_ERROR) {
1676             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1677         }
1678 
1679         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1680         if (vars.mathErr != MathError.NO_ERROR) {
1681             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1682         }
1683 
1684         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1685         if (vars.mathErr != MathError.NO_ERROR) {
1686             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1687         }
1688 
1689         
1690         
1691         
1692 
1693         
1694         vars.err = doTransferOut(borrower, borrowAmount);
1695         require(vars.err == Error.NO_ERROR, "borrow transfer out failed");
1696 
1697         
1698         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1699         accountBorrows[borrower].interestIndex = borrowIndex;
1700         totalBorrows = vars.totalBorrowsNew;
1701 
1702         
1703         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1704 
1705         
1706         comptroller.borrowVerify(address(this), borrower, borrowAmount);
1707 
1708         return uint(Error.NO_ERROR);
1709     }
1710 
1711     
1712     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint) {
1713         uint error = accrueInterest();
1714         if (error != uint(Error.NO_ERROR)) {
1715             
1716             return fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED);
1717         }
1718         
1719         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1720     }
1721 
1722     
1723     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint) {
1724         uint error = accrueInterest();
1725         if (error != uint(Error.NO_ERROR)) {
1726             
1727             return fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED);
1728         }
1729         
1730         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1731     }
1732 
1733     struct RepayBorrowLocalVars {
1734         Error err;
1735         MathError mathErr;
1736         uint repayAmount;
1737         uint borrowerIndex;
1738         uint accountBorrows;
1739         uint accountBorrowsNew;
1740         uint totalBorrowsNew;
1741     }
1742 
1743     
1744     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint) {
1745         
1746         uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
1747         if (allowed != 0) {
1748             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed);
1749         }
1750 
1751         
1752         if (accrualBlockNumber != getBlockNumber()) {
1753             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK);
1754         }
1755 
1756         RepayBorrowLocalVars memory vars;
1757 
1758         
1759         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
1760 
1761         
1762         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1763         if (vars.mathErr != MathError.NO_ERROR) {
1764             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1765         }
1766 
1767         
1768         if (repayAmount == uint(-1)) {
1769             vars.repayAmount = vars.accountBorrows;
1770         } else {
1771             vars.repayAmount = repayAmount;
1772         }
1773 
1774         
1775         vars.err = checkTransferIn(payer, vars.repayAmount);
1776         if (vars.err != Error.NO_ERROR) {
1777             return fail(vars.err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
1778         }
1779 
1780         
1781         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.repayAmount);
1782         if (vars.mathErr != MathError.NO_ERROR) {
1783             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1784         }
1785 
1786         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.repayAmount);
1787         if (vars.mathErr != MathError.NO_ERROR) {
1788             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1789         }
1790 
1791         
1792         
1793         
1794 
1795         
1796         vars.err = doTransferIn(payer, vars.repayAmount);
1797         require(vars.err == Error.NO_ERROR, "repay borrow transfer in failed");
1798 
1799         
1800         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1801         accountBorrows[borrower].interestIndex = borrowIndex;
1802         totalBorrows = vars.totalBorrowsNew;
1803 
1804         
1805         emit RepayBorrow(payer, borrower, vars.repayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1806 
1807         
1808         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.repayAmount, vars.borrowerIndex);
1809 
1810         return uint(Error.NO_ERROR);
1811     }
1812 
1813     
1814     function liquidateBorrowInternal(address borrower, uint repayAmount, CToken cTokenCollateral) internal nonReentrant returns (uint) {
1815         uint error = accrueInterest();
1816         if (error != uint(Error.NO_ERROR)) {
1817             
1818             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED);
1819         }
1820 
1821         error = cTokenCollateral.accrueInterest();
1822         if (error != uint(Error.NO_ERROR)) {
1823             
1824             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED);
1825         }
1826 
1827         
1828         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
1829     }
1830 
1831     
1832     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, CToken cTokenCollateral) internal returns (uint) {
1833         
1834         uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
1835         if (allowed != 0) {
1836             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed);
1837         }
1838 
1839         
1840         if (accrualBlockNumber != getBlockNumber()) {
1841             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK);
1842         }
1843 
1844         
1845         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
1846             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK);
1847         }
1848 
1849         
1850         if (borrower == liquidator) {
1851             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER);
1852         }
1853 
1854         
1855         if (repayAmount == 0) {
1856             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO);
1857         }
1858 
1859         
1860         if (repayAmount == uint(-1)) {
1861             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX);
1862         }
1863 
1864         
1865         (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), repayAmount);
1866         if (amountSeizeError != 0) {
1867             return failOpaque(Error.COMPTROLLER_CALCULATION_ERROR, FailureInfo.LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, amountSeizeError);
1868         }
1869 
1870         
1871         if (seizeTokens > cTokenCollateral.balanceOf(borrower)) {
1872             return fail(Error.TOKEN_INSUFFICIENT_BALANCE, FailureInfo.LIQUIDATE_SEIZE_TOO_MUCH);
1873         }
1874 
1875         
1876         uint repayBorrowError = repayBorrowFresh(liquidator, borrower, repayAmount);
1877         if (repayBorrowError != uint(Error.NO_ERROR)) {
1878             return fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED);
1879         }
1880 
1881         
1882         uint seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
1883         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
1884 
1885         
1886         emit LiquidateBorrow(liquidator, borrower, repayAmount, address(cTokenCollateral), seizeTokens);
1887 
1888         
1889         comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount, seizeTokens);
1890 
1891         return uint(Error.NO_ERROR);
1892     }
1893 
1894     
1895     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
1896         
1897         uint allowed = comptroller.seizeAllowed(address(this), msg.sender, liquidator, borrower, seizeTokens);
1898         if (allowed != 0) {
1899             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
1900         }
1901 
1902         
1903         if (borrower == liquidator) {
1904             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
1905         }
1906 
1907         MathError mathErr;
1908         uint borrowerTokensNew;
1909         uint liquidatorTokensNew;
1910 
1911         
1912         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
1913         if (mathErr != MathError.NO_ERROR) {
1914             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
1915         }
1916 
1917         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
1918         if (mathErr != MathError.NO_ERROR) {
1919             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
1920         }
1921 
1922         
1923         
1924         
1925 
1926         
1927         accountTokens[borrower] = borrowerTokensNew;
1928         accountTokens[liquidator] = liquidatorTokensNew;
1929 
1930         
1931         emit Transfer(borrower, liquidator, seizeTokens);
1932 
1933         
1934         comptroller.seizeVerify(address(this), msg.sender, liquidator, borrower, seizeTokens);
1935 
1936         return uint(Error.NO_ERROR);
1937     }
1938 
1939 
1940     
1941 
1942     
1943     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
1944         
1945         if (msg.sender != admin) {
1946             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1947         }
1948 
1949         
1950         address oldPendingAdmin = pendingAdmin;
1951 
1952         
1953         pendingAdmin = newPendingAdmin;
1954 
1955         
1956         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
1957 
1958         return uint(Error.NO_ERROR);
1959     }
1960 
1961     
1962     function _acceptAdmin() external returns (uint) {
1963         
1964         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
1965             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
1966         }
1967 
1968         
1969         address oldAdmin = admin;
1970         address oldPendingAdmin = pendingAdmin;
1971 
1972         
1973         admin = pendingAdmin;
1974 
1975         
1976         pendingAdmin = address(0);
1977 
1978         emit NewAdmin(oldAdmin, admin);
1979         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
1980 
1981         return uint(Error.NO_ERROR);
1982     }
1983 
1984     
1985     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
1986         
1987         if (msg.sender != admin) {
1988             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
1989         }
1990 
1991         ComptrollerInterface oldComptroller = comptroller;
1992         
1993         require(newComptroller.isComptroller(), "marker method returned false");
1994 
1995         
1996         comptroller = newComptroller;
1997 
1998         
1999         emit NewComptroller(oldComptroller, newComptroller);
2000 
2001         return uint(Error.NO_ERROR);
2002     }
2003 
2004     
2005     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2006         uint error = accrueInterest();
2007         if (error != uint(Error.NO_ERROR)) {
2008             
2009             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2010         }
2011         
2012         return _setReserveFactorFresh(newReserveFactorMantissa);
2013     }
2014 
2015     
2016     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2017         
2018         if (msg.sender != admin) {
2019             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2020         }
2021 
2022         
2023         if (accrualBlockNumber != getBlockNumber()) {
2024             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2025         }
2026 
2027         
2028         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2029             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2030         }
2031 
2032         uint oldReserveFactorMantissa = reserveFactorMantissa;
2033         reserveFactorMantissa = newReserveFactorMantissa;
2034 
2035         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2036 
2037         return uint(Error.NO_ERROR);
2038     }
2039 
2040     
2041     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2042         uint error = accrueInterest();
2043         if (error != uint(Error.NO_ERROR)) {
2044             
2045             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2046         }
2047         
2048         return _reduceReservesFresh(reduceAmount);
2049     }
2050 
2051     
2052     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2053         Error err;
2054         
2055         uint totalReservesNew;
2056 
2057         
2058         if (msg.sender != admin) {
2059             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2060         }
2061 
2062         
2063         if (accrualBlockNumber != getBlockNumber()) {
2064             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2065         }
2066 
2067         
2068         if (getCashPrior() < reduceAmount) {
2069             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2070         }
2071 
2072         
2073         if (reduceAmount > totalReserves) {
2074             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2075         }
2076 
2077         
2078         
2079         
2080 
2081         totalReservesNew = totalReserves - reduceAmount;
2082         
2083         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2084 
2085         
2086         totalReserves = totalReservesNew;
2087 
2088         
2089         err = doTransferOut(admin, reduceAmount);
2090         
2091         require(err == Error.NO_ERROR, "reduce reserves transfer out failed");
2092 
2093         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2094 
2095         return uint(Error.NO_ERROR);
2096     }
2097 
2098     
2099     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2100         uint error = accrueInterest();
2101         if (error != uint(Error.NO_ERROR)) {
2102             
2103             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2104         }
2105         
2106         return _setInterestRateModelFresh(newInterestRateModel);
2107     }
2108 
2109     
2110     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2111 
2112         
2113         InterestRateModel oldInterestRateModel;
2114 
2115         
2116         if (msg.sender != admin) {
2117             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2118         }
2119 
2120         
2121         if (accrualBlockNumber != getBlockNumber()) {
2122             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2123         }
2124 
2125         
2126         oldInterestRateModel = interestRateModel;
2127 
2128         
2129         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2130 
2131         
2132         interestRateModel = newInterestRateModel;
2133 
2134         
2135         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2136 
2137         return uint(Error.NO_ERROR);
2138     }
2139 
2140     
2141 
2142     
2143     function getCashPrior() internal view returns (uint);
2144 
2145     
2146     function checkTransferIn(address from, uint amount) internal view returns (Error);
2147 
2148     
2149     function doTransferIn(address from, uint amount) internal returns (Error);
2150 
2151     
2152     function doTransferOut(address payable to, uint amount) internal returns (Error);
2153 }
2154 
2155 contract CErc20 is CToken {
2156 
2157     
2158     address public underlying;
2159 
2160     
2161     constructor(address underlying_,
2162                 ComptrollerInterface comptroller_,
2163                 InterestRateModel interestRateModel_,
2164                 uint initialExchangeRateMantissa_,
2165                 string memory name_,
2166                 string memory symbol_,
2167                 uint8 decimals_,
2168                 address payable admin_) public
2169     CToken(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_, admin_) {
2170         
2171         underlying = underlying_;
2172         EIP20Interface(underlying).totalSupply(); 
2173     }
2174 
2175     
2176 
2177     
2178     function mint(uint mintAmount) external returns (uint) {
2179         return mintInternal(mintAmount);
2180     }
2181 
2182     
2183     function redeem(uint redeemTokens) external returns (uint) {
2184         return redeemInternal(redeemTokens);
2185     }
2186 
2187     
2188     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2189         return redeemUnderlyingInternal(redeemAmount);
2190     }
2191 
2192     
2193     function borrow(uint borrowAmount) external returns (uint) {
2194         return borrowInternal(borrowAmount);
2195     }
2196 
2197     
2198     function repayBorrow(uint repayAmount) external returns (uint) {
2199         return repayBorrowInternal(repayAmount);
2200     }
2201 
2202     
2203     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2204         return repayBorrowBehalfInternal(borrower, repayAmount);
2205     }
2206 
2207     
2208     function liquidateBorrow(address borrower, uint repayAmount, CToken cTokenCollateral) external returns (uint) {
2209         return liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
2210     }
2211 
2212     
2213 
2214     
2215     function getCashPrior() internal view returns (uint) {
2216         EIP20Interface token = EIP20Interface(underlying);
2217         return token.balanceOf(address(this));
2218     }
2219 
2220     
2221     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2222         EIP20Interface token = EIP20Interface(underlying);
2223 
2224         if (token.allowance(from, address(this)) < amount) {
2225             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
2226         }
2227 
2228         if (token.balanceOf(from) < amount) {
2229             return Error.TOKEN_INSUFFICIENT_BALANCE;
2230         }
2231 
2232         return Error.NO_ERROR;
2233     }
2234 
2235     
2236     function doTransferIn(address from, uint amount) internal returns (Error) {
2237         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2238         bool result;
2239 
2240         token.transferFrom(from, address(this), amount);
2241 
2242         
2243         assembly {
2244             switch returndatasize()
2245                 case 0 {                      
2246                     result := not(0)          
2247                 }
2248                 case 32 {                     
2249                     returndatacopy(0, 0, 32)
2250                     result := mload(0)        
2251                 }
2252                 default {                     
2253                     revert(0, 0)
2254                 }
2255         }
2256 
2257         if (!result) {
2258             return Error.TOKEN_TRANSFER_IN_FAILED;
2259         }
2260 
2261         return Error.NO_ERROR;
2262     }
2263 
2264     
2265     function doTransferOut(address payable to, uint amount) internal returns (Error) {
2266         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2267         bool result;
2268 
2269         token.transfer(to, amount);
2270 
2271         
2272         assembly {
2273             switch returndatasize()
2274                 case 0 {                      
2275                     result := not(0)          
2276                 }
2277                 case 32 {                     
2278                     returndatacopy(0, 0, 32)
2279                     result := mload(0)        
2280                 }
2281                 default {                     
2282                     revert(0, 0)
2283                 }
2284         }
2285 
2286         if (!result) {
2287             return Error.TOKEN_TRANSFER_OUT_FAILED;
2288         }
2289 
2290         return Error.NO_ERROR;
2291     }
2292 }
2293 
2294 contract CEther is CToken {
2295     
2296     constructor(ComptrollerInterface comptroller_,
2297                 InterestRateModel interestRateModel_,
2298                 uint initialExchangeRateMantissa_,
2299                 string memory name_,
2300                 string memory symbol_,
2301                 uint8 decimals_,
2302                 address payable admin_) public
2303     CToken(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_, admin_) {}
2304 
2305     
2306 
2307     
2308     function mint() external payable {
2309         requireNoError(mintInternal(msg.value), "mint failed");
2310     }
2311 
2312     
2313     function redeem(uint redeemTokens) external returns (uint) {
2314         return redeemInternal(redeemTokens);
2315     }
2316 
2317     
2318     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2319         return redeemUnderlyingInternal(redeemAmount);
2320     }
2321 
2322     
2323     function borrow(uint borrowAmount) external returns (uint) {
2324         return borrowInternal(borrowAmount);
2325     }
2326 
2327     
2328     function repayBorrow() external payable {
2329         requireNoError(repayBorrowInternal(msg.value), "repayBorrow failed");
2330     }
2331 
2332     
2333     function repayBorrowBehalf(address borrower) external payable {
2334         requireNoError(repayBorrowBehalfInternal(borrower, msg.value), "repayBorrowBehalf failed");
2335     }
2336 
2337     
2338     function liquidateBorrow(address borrower, CToken cTokenCollateral) external payable {
2339         requireNoError(liquidateBorrowInternal(borrower, msg.value, cTokenCollateral), "liquidateBorrow failed");
2340     }
2341 
2342     
2343     function () external payable {
2344         requireNoError(mintInternal(msg.value), "mint failed");
2345     }
2346 
2347     
2348 
2349     
2350     function getCashPrior() internal view returns (uint) {
2351         (MathError err, uint startingBalance) = subUInt(address(this).balance, msg.value);
2352         require(err == MathError.NO_ERROR);
2353         return startingBalance;
2354     }
2355 
2356     
2357     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2358         
2359         require(msg.sender == from, "sender mismatch");
2360         require(msg.value == amount, "value mismatch");
2361         return Error.NO_ERROR;
2362     }
2363 
2364     
2365     function doTransferIn(address from, uint amount) internal returns (Error) {
2366         
2367         require(msg.sender == from, "sender mismatch");
2368         require(msg.value == amount, "value mismatch");
2369         return Error.NO_ERROR;
2370     }
2371 
2372     function doTransferOut(address payable to, uint amount) internal returns (Error) {
2373         
2374         to.transfer(amount);
2375         return Error.NO_ERROR;
2376     }
2377 
2378     function requireNoError(uint errCode, string memory message) internal pure {
2379         if (errCode == uint(Error.NO_ERROR)) {
2380             return;
2381         }
2382 
2383         bytes memory fullMessage = new bytes(bytes(message).length + 5);
2384         uint i;
2385 
2386         for (i = 0; i < bytes(message).length; i++) {
2387             fullMessage[i] = bytes(message)[i];
2388         }
2389 
2390         fullMessage[i+0] = byte(uint8(32));
2391         fullMessage[i+1] = byte(uint8(40));
2392         fullMessage[i+2] = byte(uint8(48 + ( errCode / 10 )));
2393         fullMessage[i+3] = byte(uint8(48 + ( errCode % 10 )));
2394         fullMessage[i+4] = byte(uint8(41));
2395 
2396         require(errCode == uint(Error.NO_ERROR), string(fullMessage));
2397     }
2398 }
2399 
2400 library ECDSA {
2401     
2402     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2403         
2404         if (signature.length != 65) {
2405             revert("signature's length is invalid");
2406         }
2407 
2408         
2409         bytes32 r;
2410         bytes32 s;
2411         uint8 v;
2412 
2413         
2414         
2415         
2416         assembly {
2417             r := mload(add(signature, 0x20))
2418             s := mload(add(signature, 0x40))
2419             v := byte(0, mload(add(signature, 0x60)))
2420         }
2421 
2422         
2423         
2424         
2425         
2426         
2427         
2428         
2429         
2430         
2431         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2432             revert("signature's s is in the wrong range");
2433         }
2434 
2435         if (v != 27 && v != 28) {
2436             revert("signature's v is in the wrong range");
2437         }
2438 
2439         
2440         return ecrecover(hash, v, r, s);
2441     }
2442 
2443     
2444     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2445         
2446         
2447         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2448     }
2449 }
2450 
2451 contract CompoundAdapter is CanReclaimTokens {
2452     using SafeERC20 for ERC20;
2453     ILiquidityPool liquidityPool;
2454     IRebalancer rebalancer;
2455 
2456     CEther cEther;
2457     mapping (address=>CErc20) cTokens;
2458 
2459     uint256 loansNonce;
2460     mapping (bytes32=>bool) loans;
2461 
2462     event LogLiquidate(address indexed borrower, address indexed collateralToken, address indexed debtToken, uint256 debtAmount);
2463 
2464     function () external payable {
2465     }
2466 
2467     constructor(ILiquidityPool _liquidityPool, IRebalancer _rebalancer) public {
2468         liquidityPool = _liquidityPool;
2469         rebalancer = _rebalancer;
2470     }
2471 
2472     function updateLiquidityPool(ILiquidityPool _newLiquidityPool) external onlyOwner {
2473         liquidityPool = _newLiquidityPool;
2474     }
2475 
2476     function updateRebalancer(IRebalancer _newRebalancer) external onlyOwner {
2477         rebalancer = _newRebalancer;
2478     }
2479 
2480     function register(address _underlying, address _cToken) external onlyOwner {
2481         require(_underlying != address(0x0), "Underlying asset cannot be 0x0");
2482         if (liquidityPool.isEther(_underlying)) {
2483             cEther = CEther(uint256(_cToken));
2484         } else {
2485             cTokens[_underlying] = CErc20(_cToken);
2486         }
2487     }
2488 
2489     function liquidate(address _borrower, CToken _collateralToken, address _debtToken, uint256 _debtAmount) external {
2490         _liquidate(_borrower, _collateralToken, _debtToken, _debtAmount);
2491         emit LogLiquidate(_borrower, address(_collateralToken), _debtToken, _debtAmount);
2492         loans[keccak256(abi.encodePacked(_borrower, address(_collateralToken), _debtToken, _debtAmount, loansNonce))] = true;
2493         loansNonce++;
2494     }
2495 
2496     function rebalance(address _borrower, CToken _collateralToken, address _debtToken, uint256 _debtAmount, uint256 _loansNonce) internal {
2497         bytes32 loanId = keccak256(abi.encodePacked(_borrower, address(_collateralToken), _debtToken, _debtAmount, _loansNonce));
2498         require(loans[loanId], "Loan does not exist");
2499         delete(loans[loanId]);
2500         uint256 cAmount = _collateralToken.balanceOf(address(this));
2501         _collateralToken.approve(address(rebalancer), cAmount);
2502         rebalancer.giveUnbalancedPosition(_debtToken, _debtAmount, address(_collateralToken), cAmount);
2503     }
2504 
2505     function _liquidate(address _borrower, CToken cToken, address _debtToken, uint256 _debtAmount) internal {
2506         liquidityPool.take(_debtToken, _debtAmount);
2507         if (liquidityPool.isEther(_debtToken)) {
2508            cEther.liquidateBorrow.value(_debtAmount)(_borrower, cToken);
2509         } else {
2510             CErc20 cerc20 = cTokens[_debtToken];
2511             ERC20(_debtToken).safeApprove(address(cerc20), _debtAmount);
2512             require(cerc20.liquidateBorrow(_borrower, _debtAmount, cToken) == 0, "liquidation failed");
2513         }
2514     }
2515 }