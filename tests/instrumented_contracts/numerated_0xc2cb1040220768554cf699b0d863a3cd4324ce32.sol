1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract Context {
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33     constructor () internal {
34         _owner = _msgSender();
35         emit OwnershipTransferred(address(0), _owner);
36     }
37     function owner() public view returns (address) {
38         return _owner;
39     }
40     modifier onlyOwner() {
41         require(isOwner(), "Ownable: caller is not the owner");
42         _;
43     }
44     function isOwner() public view returns (bool) {
45         return _msgSender() == _owner;
46     }
47     function renounceOwnership() public onlyOwner {
48         emit OwnershipTransferred(_owner, address(0));
49         _owner = address(0);
50     }
51     function transferOwnership(address newOwner) public onlyOwner {
52         _transferOwnership(newOwner);
53     }
54     function _transferOwnership(address newOwner) internal {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         emit OwnershipTransferred(_owner, newOwner);
57         _owner = newOwner;
58     }
59 }
60 
61 contract ERC20 is Context, IERC20 {
62     using SafeMath for uint256;
63 
64     mapping (address => uint256) _balances;
65 
66     mapping (address => mapping (address => uint256)) private _allowances;
67 
68     uint256 _totalSupply;
69     function totalSupply() public view returns (uint256) {
70         return _totalSupply;
71     }
72     function balanceOf(address account) public view returns (uint256) {
73         return _balances[account];
74     }
75     function transfer(address recipient, uint256 amount) public returns (bool) {
76         _transfer(_msgSender(), recipient, amount);
77         return true;
78     }
79     function allowance(address owner, address spender) public view returns (uint256) {
80         return _allowances[owner][spender];
81     }
82     function approve(address spender, uint256 amount) public returns (bool) {
83         _approve(_msgSender(), spender, amount);
84         return true;
85     }
86     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
87         _transfer(sender, recipient, amount);
88         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
89         return true;
90     }
91     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
92         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
93         return true;
94     }
95     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
96         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
97         return true;
98     }
99     function _transfer(address sender, address recipient, uint256 amount) internal {
100         require(sender != address(0), "ERC20: transfer from the zero address");
101         require(recipient != address(0), "ERC20: transfer to the zero address");
102 
103         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
104         _balances[recipient] = _balances[recipient].add(amount);
105         emit Transfer(sender, recipient, amount);
106     }
107     function _mint(address account, uint256 amount) internal {
108         require(account != address(0), "ERC20: mint to the zero address");
109 
110         _totalSupply = _totalSupply.add(amount);
111         _balances[account] = _balances[account].add(amount);
112         emit Transfer(address(0), account, amount);
113     }
114     function _burn(address account, uint256 amount) internal {
115         require(account != address(0), "ERC20: burn from the zero address");
116 
117         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
118         _totalSupply = _totalSupply.sub(amount);
119         emit Transfer(account, address(0), amount);
120     }
121     function _approve(address owner, address spender, uint256 amount) internal {
122         require(owner != address(0), "ERC20: approve from the zero address");
123         require(spender != address(0), "ERC20: approve to the zero address");
124 
125         _allowances[owner][spender] = amount;
126         emit Approval(owner, spender, amount);
127     }
128     function _burnFrom(address account, uint256 amount) internal {
129         _burn(account, amount);
130         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
131     }
132 }
133 
134 contract ERC20Detailed is IERC20 {
135     string private _name;
136     string private _symbol;
137     uint8 private _decimals;
138 
139     constructor (string memory name, string memory symbol, uint8 decimals) public {
140         _name = name;
141         _symbol = symbol;
142         _decimals = decimals;
143     }
144     function name() public view returns (string memory) {
145         return _name;
146     }
147     function symbol() public view returns (string memory) {
148         return _symbol;
149     }
150     function decimals() public view returns (uint8) {
151         return _decimals;
152     }
153 }
154 
155 contract ReentrancyGuard {
156     uint256 private _guardCounter;
157 
158     constructor () internal {
159         _guardCounter = 1;
160     }
161 
162     modifier nonReentrant() {
163         _guardCounter += 1;
164         uint256 localCounter = _guardCounter;
165         _;
166         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
167     }
168 }
169 
170 library SafeMath {
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a, "SafeMath: addition overflow");
174 
175         return c;
176     }
177     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178         return sub(a, b, "SafeMath: subtraction overflow");
179     }
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         // Solidity only automatically asserts when dividing by 0
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203 
204         return c;
205     }
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return mod(a, b, "SafeMath: modulo by zero");
208     }
209     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b != 0, errorMessage);
211         return a % b;
212     }
213 }
214 
215 library Address {
216     function isContract(address account) internal view returns (bool) {
217         bytes32 codehash;
218         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
219         // solhint-disable-next-line no-inline-assembly
220         assembly { codehash := extcodehash(account) }
221         return (codehash != 0x0 && codehash != accountHash);
222     }
223     function toPayable(address account) internal pure returns (address payable) {
224         return address(uint160(account));
225     }
226     function sendValue(address payable recipient, uint256 amount) internal {
227         require(address(this).balance >= amount, "Address: insufficient balance");
228 
229         // solhint-disable-next-line avoid-call-value
230         (bool success, ) = recipient.call.value(amount)("");
231         require(success, "Address: unable to send value, recipient may have reverted");
232     }
233 }
234 
235 library SafeERC20 {
236     using SafeMath for uint256;
237     using Address for address;
238 
239     function safeTransfer(IERC20 token, address to, uint256 value) internal {
240         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
241     }
242 
243     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
244         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
245     }
246 
247     function safeApprove(IERC20 token, address spender, uint256 value) internal {
248         require((value == 0) || (token.allowance(address(this), spender) == 0),
249             "SafeERC20: approve from non-zero to non-zero allowance"
250         );
251         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
252     }
253 
254     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
255         uint256 newAllowance = token.allowance(address(this), spender).add(value);
256         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
257     }
258 
259     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
260         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
261         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
262     }
263     function callOptionalReturn(IERC20 token, bytes memory data) private {
264         require(address(token).isContract(), "SafeERC20: call to non-contract");
265 
266         // solhint-disable-next-line avoid-low-level-calls
267         (bool success, bytes memory returndata) = address(token).call(data);
268         require(success, "SafeERC20: low-level call failed");
269 
270         if (returndata.length > 0) { // Return data is optional
271             // solhint-disable-next-line max-line-length
272             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
273         }
274     }
275 }
276 
277 interface Compound {
278     function mint ( uint256 mintAmount ) external returns ( uint256 );
279     function redeem(uint256 redeemTokens) external returns (uint256);
280     function exchangeRateStored() external view returns (uint);
281 }
282 
283 interface Fulcrum {
284     function mint(address receiver, uint256 amount) external payable returns (uint256 mintAmount);
285     function burn(address receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
286     function assetBalanceOf(address _owner) external view returns (uint256 balance);
287 }
288 
289 interface ILendingPoolAddressesProvider {
290     function getLendingPool() external view returns (address);
291 }
292 
293 interface Aave {
294     function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;
295 }
296 
297 interface AToken {
298     function redeem(uint256 amount) external;
299 }
300 
301 interface IIEarnManager {
302     function recommend(address _token) external view returns (
303       string memory choice,
304       uint256 capr,
305       uint256 iapr,
306       uint256 aapr,
307       uint256 dapr
308     );
309 }
310 
311 contract Structs {
312     struct Val {
313         uint256 value;
314     }
315 
316     enum ActionType {
317         Deposit,   // supply tokens
318         Withdraw  // borrow tokens
319     }
320 
321     enum AssetDenomination {
322         Wei // the amount is denominated in wei
323     }
324 
325     enum AssetReference {
326         Delta // the amount is given as a delta from the current value
327     }
328 
329     struct AssetAmount {
330         bool sign; // true if positive
331         AssetDenomination denomination;
332         AssetReference ref;
333         uint256 value;
334     }
335 
336     struct ActionArgs {
337         ActionType actionType;
338         uint256 accountId;
339         AssetAmount amount;
340         uint256 primaryMarketId;
341         uint256 secondaryMarketId;
342         address otherAddress;
343         uint256 otherAccountId;
344         bytes data;
345     }
346 
347     struct Info {
348         address owner;  // The address that owns the account
349         uint256 number; // A nonce that allows a single address to control many accounts
350     }
351 
352     struct Wei {
353         bool sign; // true if positive
354         uint256 value;
355     }
356 }
357 
358 contract DyDx is Structs {
359     function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);
360     function operate(Info[] memory, ActionArgs[] memory) public;
361 }
362 
363 interface LendingPoolAddressesProvider {
364     function getLendingPool() external view returns (address);
365     function getLendingPoolCore() external view returns (address);
366 }
367 
368 contract yDAI is ERC20, ERC20Detailed, ReentrancyGuard, Structs, Ownable {
369   using SafeERC20 for IERC20;
370   using Address for address;
371   using SafeMath for uint256;
372 
373   uint256 public pool;
374   address public token;
375   address public compound;
376   address public fulcrum;
377   address public aave;
378   address public aavePool;
379   address public aaveToken;
380   address public dydx;
381   uint256 public dToken;
382   address public apr;
383   address public chai;
384 
385   enum Lender {
386       NONE,
387       DYDX,
388       COMPOUND,
389       AAVE,
390       FULCRUM
391   }
392 
393   Lender public provider = Lender.NONE;
394 
395   constructor () public ERC20Detailed("iearn DAI", "yDAI", 18) {
396     token = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
397     apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
398     dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
399     aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
400     aavePool = address(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);
401     fulcrum = address(0x493C57C4763932315A328269E1ADaD09653B9081);
402     aaveToken = address(0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d);
403     compound = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
404     chai = address(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
405     dToken = 3;
406     approveToken();
407   }
408 
409   function set_new_APR(address _new_APR) public onlyOwner {
410       apr = _new_APR;
411   }
412   function set_new_FULCRUM(address _new_FULCRUM) public onlyOwner {
413       fulcrum = _new_FULCRUM;
414   }
415   function set_new_COMPOUND(address _new_COMPOUND) public onlyOwner {
416       compound = _new_COMPOUND;
417   }
418   function set_new_DTOKEN(uint256 _new_DTOKEN) public onlyOwner {
419       dToken = _new_DTOKEN;
420   }
421   function set_new_AAVE(address _new_AAVE) public onlyOwner {
422       aave = _new_AAVE;
423   }
424   function set_new_APOOL(address _new_APOOL) public onlyOwner {
425       aavePool = _new_APOOL;
426   }
427   function set_new_ATOKEN(address _new_ATOKEN) public onlyOwner {
428       aaveToken = _new_ATOKEN;
429   }
430   function set_new_CHAI(address _new_CHAI) public onlyOwner {
431       chai = _new_CHAI;
432   }
433 
434   // Quick swap low gas method for pool swaps
435   function deposit(uint256 _amount)
436       external
437       nonReentrant
438   {
439       require(_amount > 0, "deposit must be greater than 0");
440       pool = calcPoolValueInToken();
441 
442       IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
443 
444       // Calculate pool shares
445       uint256 shares = 0;
446       if (pool == 0) {
447         shares = _amount;
448         pool = _amount;
449       } else {
450         shares = (_amount.mul(_totalSupply)).div(pool);
451       }
452       pool = calcPoolValueInToken();
453       _mint(msg.sender, shares);
454   }
455 
456   // No rebalance implementation for lower fees and faster swaps
457   function withdraw(uint256 _shares)
458       external
459       nonReentrant
460   {
461       require(_shares > 0, "withdraw must be greater than 0");
462 
463       uint256 ibalance = balanceOf(msg.sender);
464       require(_shares <= ibalance, "insufficient balance");
465 
466       // Could have over value from cTokens
467       pool = calcPoolValueInToken();
468       // Calc to redeem before updating balances
469       uint256 r = (pool.mul(_shares)).div(_totalSupply);
470 
471 
472       _balances[msg.sender] = _balances[msg.sender].sub(_shares, "redeem amount exceeds balance");
473       _totalSupply = _totalSupply.sub(_shares);
474 
475       emit Transfer(msg.sender, address(0), _shares);
476 
477       // Check balance
478       uint256 b = IERC20(token).balanceOf(address(this));
479       if (b < r) {
480         _withdrawSome(r.sub(b));
481       }
482 
483       IERC20(token).safeTransfer(msg.sender, r);
484       pool = calcPoolValueInToken();
485   }
486 
487   function recommend() public view returns (Lender) {
488     (,uint256 capr,uint256 iapr,uint256 aapr,uint256 dapr) = IIEarnManager(apr).recommend(token);
489     uint256 max = 0;
490     if (capr > max) {
491       max = capr;
492     }
493     if (iapr > max) {
494       max = iapr;
495     }
496     if (aapr > max) {
497       max = aapr;
498     }
499     if (dapr > max) {
500       max = dapr;
501     }
502 
503     Lender newProvider = Lender.NONE;
504     if (max == capr) {
505       newProvider = Lender.COMPOUND;
506     } else if (max == iapr) {
507       newProvider = Lender.FULCRUM;
508     } else if (max == aapr) {
509       newProvider = Lender.AAVE;
510     } else if (max == dapr) {
511       newProvider = Lender.DYDX;
512     }
513     return newProvider;
514   }
515 
516   function getAave() public view returns (address) {
517     return LendingPoolAddressesProvider(aave).getLendingPool();
518   }
519   function getAaveCore() public view returns (address) {
520     return LendingPoolAddressesProvider(aave).getLendingPoolCore();
521   }
522 
523   function approveToken() public {
524       IERC20(token).safeApprove(compound, uint(-1));
525       IERC20(token).safeApprove(dydx, uint(-1));
526       IERC20(token).safeApprove(getAaveCore(), uint(-1));
527       IERC20(token).safeApprove(fulcrum, uint(-1));
528   }
529 
530   function balance() public view returns (uint256) {
531     return IERC20(token).balanceOf(address(this));
532   }
533   function balanceDydxAvailable() public view returns (uint256) {
534       return IERC20(token).balanceOf(dydx);
535   }
536   function balanceDydx() public view returns (uint256) {
537       Wei memory bal = DyDx(dydx).getAccountWei(Info(address(this), 0), dToken);
538       return bal.value;
539   }
540   function balanceCompound() public view returns (uint256) {
541       return IERC20(compound).balanceOf(address(this));
542   }
543   function balanceCompoundInToken() public view returns (uint256) {
544     // Mantisa 1e18 to decimals
545     uint256 b = balanceCompound();
546     if (b > 0) {
547       b = b.mul(Compound(compound).exchangeRateStored()).div(1e18);
548     }
549     return b;
550   }
551   function balanceFulcrumAvailable() public view returns (uint256) {
552       return IERC20(chai).balanceOf(fulcrum);
553   }
554   function balanceFulcrumInToken() public view returns (uint256) {
555     uint256 b = balanceFulcrum();
556     if (b > 0) {
557       b = Fulcrum(fulcrum).assetBalanceOf(address(this));
558     }
559     return b;
560   }
561   function balanceFulcrum() public view returns (uint256) {
562     return IERC20(fulcrum).balanceOf(address(this));
563   }
564   function balanceAaveAvailable() public view returns (uint256) {
565       return IERC20(token).balanceOf(aavePool);
566   }
567   function balanceAave() public view returns (uint256) {
568     return IERC20(aaveToken).balanceOf(address(this));
569   }
570 
571   function rebalance() public {
572     Lender newProvider = recommend();
573 
574     if (newProvider != provider) {
575       _withdrawAll();
576     }
577 
578     if (balance() > 0) {
579       if (newProvider == Lender.DYDX) {
580         _supplyDydx(balance());
581       } else if (newProvider == Lender.FULCRUM) {
582         _supplyFulcrum(balance());
583       } else if (newProvider == Lender.COMPOUND) {
584         _supplyCompound(balance());
585       } else if (newProvider == Lender.AAVE) {
586         _supplyAave(balance());
587       }
588     }
589 
590     provider = newProvider;
591   }
592 
593   function _withdrawAll() internal {
594     uint256 amount = balanceCompound();
595     if (amount > 0) {
596       _withdrawSomeCompound(balanceCompoundInToken().sub(1));
597     }
598     amount = balanceDydx();
599     if (amount > 0) {
600       _withdrawDydx(balanceDydxAvailable());
601     }
602     amount = balanceFulcrum();
603     if (amount > 0) {
604       _withdrawSomeFulcrum(balanceFulcrumAvailable().sub(1));
605     }
606     amount = balanceAave();
607     if (amount > 0) {
608       _withdrawAave(balanceAaveAvailable());
609     }
610   }
611 
612   function _withdrawSomeCompound(uint256 _amount) internal {
613     uint256 b = balanceCompound();
614     uint256 bT = balanceCompoundInToken();
615     require(bT >= _amount, "insufficient funds");
616     // can have unintentional rounding errors
617     uint256 amount = (b.mul(_amount)).div(bT).add(1);
618     _withdrawCompound(amount);
619   }
620 
621   function _withdrawSomeFulcrum(uint256 _amount) internal {
622     uint256 b = balanceFulcrum();
623     uint256 bT = balanceFulcrumInToken();
624     require(bT >= _amount, "insufficient funds");
625     // can have unintentional rounding errors
626     uint256 amount = (b.mul(_amount)).div(bT).add(1);
627     _withdrawFulcrum(amount);
628   }
629 
630   function _withdrawSome(uint256 _amount) internal {
631     if (provider == Lender.COMPOUND) {
632       _withdrawSomeCompound(_amount);
633     }
634     if (provider == Lender.AAVE) {
635       require(balanceAave() >= _amount, "insufficient funds");
636       _withdrawAave(_amount);
637     }
638     if (provider == Lender.DYDX) {
639       require(balanceDydx() >= _amount, "insufficient funds");
640       _withdrawDydx(_amount);
641     }
642     if (provider == Lender.FULCRUM) {
643       _withdrawSomeFulcrum(_amount);
644     }
645   }
646 
647   function _supplyDydx(uint256 amount) internal {
648       Info[] memory infos = new Info[](1);
649       infos[0] = Info(address(this), 0);
650 
651       AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);
652       ActionArgs memory act;
653       act.actionType = ActionType.Deposit;
654       act.accountId = 0;
655       act.amount = amt;
656       act.primaryMarketId = dToken;
657       act.otherAddress = address(this);
658 
659       ActionArgs[] memory args = new ActionArgs[](1);
660       args[0] = act;
661 
662       DyDx(dydx).operate(infos, args);
663   }
664 
665   function _supplyAave(uint amount) internal {
666       Aave(getAave()).deposit(token, amount, 0);
667   }
668   function _supplyFulcrum(uint amount) internal {
669       require(Fulcrum(fulcrum).mint(address(this), amount) > 0, "FULCRUM: supply failed");
670   }
671   function _supplyCompound(uint amount) internal {
672       require(Compound(compound).mint(amount) == 0, "COMPOUND: supply failed");
673   }
674   function _withdrawAave(uint amount) internal {
675       AToken(aaveToken).redeem(amount);
676   }
677   function _withdrawFulcrum(uint amount) internal {
678       require(Fulcrum(fulcrum).burn(address(this), amount) > 0, "FULCRUM: withdraw failed");
679   }
680   function _withdrawCompound(uint amount) internal {
681       require(Compound(compound).redeem(amount) == 0, "COMPOUND: withdraw failed");
682   }
683 
684   function _withdrawDydx(uint256 amount) internal {
685       Info[] memory infos = new Info[](1);
686       infos[0] = Info(address(this), 0);
687 
688       AssetAmount memory amt = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, amount);
689       ActionArgs memory act;
690       act.actionType = ActionType.Withdraw;
691       act.accountId = 0;
692       act.amount = amt;
693       act.primaryMarketId = dToken;
694       act.otherAddress = address(this);
695 
696       ActionArgs[] memory args = new ActionArgs[](1);
697       args[0] = act;
698 
699       DyDx(dydx).operate(infos, args);
700   }
701 
702   function calcPoolValueInToken() public view returns (uint) {
703     return balanceCompoundInToken()
704       .add(balanceFulcrumInToken())
705       .add(balanceDydx())
706       .add(balanceAave())
707       .add(balance());
708   }
709 
710   function getPricePerFullShare() public view returns (uint) {
711     uint _pool = calcPoolValueInToken();
712     return _pool.mul(1e18).div(_totalSupply);
713   }
714 
715   function withdrawSomeCompound(uint256 _amount) public onlyOwner {
716     _withdrawSomeCompound(_amount);
717   }
718   function withdrawSomeFulcrum(uint256 _amount) public onlyOwner {
719     _withdrawSomeFulcrum(_amount);
720   }
721   function withdrawAave(uint amount) public onlyOwner {
722       _withdrawAave(amount);
723   }
724   function withdrawDydx(uint256 amount) public onlyOwner {
725       _withdrawDydx(amount);
726   }
727 
728   function supplyDydx(uint256 amount) public onlyOwner {
729       _supplyDydx(amount);
730   }
731   function supplyAave(uint amount) public onlyOwner {
732     _supplyAave(amount);
733   }
734   function supplyFulcrum(uint amount) public onlyOwner {
735       _supplyFulcrum(amount);
736   }
737   function supplyCompound(uint amount) public onlyOwner {
738       _supplyCompound(amount);
739   }
740 }