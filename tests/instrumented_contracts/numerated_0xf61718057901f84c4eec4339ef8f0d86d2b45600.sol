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
368 contract ySUSD is ERC20, ERC20Detailed, ReentrancyGuard, Ownable, Structs {
369   using SafeERC20 for IERC20;
370   using Address for address;
371   using SafeMath for uint256;
372 
373   uint256 public pool;
374   address public token;
375   address public compound;
376   address public fulcrum;
377   address public aave;
378   address public aaveToken;
379   address public dydx;
380   uint256 public dToken;
381   address public apr;
382 
383   enum Lender {
384       NONE,
385       DYDX,
386       COMPOUND,
387       AAVE,
388       FULCRUM
389   }
390 
391   Lender public provider = Lender.NONE;
392 
393   constructor () public ERC20Detailed("iearn SUSD", "ySUSD", 18) {
394     token = address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
395     apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
396     dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
397     aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
398     fulcrum = address(0x49f4592E641820e928F9919Ef4aBd92a719B4b49);
399     aaveToken = address(0x625aE63000f46200499120B906716420bd059240);
400     compound = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
401     dToken = 0;
402     approveToken();
403   }
404 
405   // Ownable setters incase of support in future for these systems
406   function set_new_APR(address _new_APR) public onlyOwner {
407       apr = _new_APR;
408   }
409   function set_new_COMPOUND(address _new_COMPOUND) public onlyOwner {
410       compound = _new_COMPOUND;
411   }
412   function set_new_DTOKEN(uint256 _new_DTOKEN) public onlyOwner {
413       dToken = _new_DTOKEN;
414   }
415 
416   // Quick swap low gas method for pool swaps
417   function deposit(uint256 _amount)
418       external
419       nonReentrant
420   {
421       require(_amount > 0, "deposit must be greater than 0");
422       pool = _calcPoolValueInToken();
423 
424       IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
425 
426       // Calculate pool shares
427       uint256 shares = 0;
428       if (pool == 0) {
429         shares = _amount;
430         pool = _amount;
431       } else {
432         shares = (_amount.mul(_totalSupply)).div(pool);
433       }
434       pool = _calcPoolValueInToken();
435       _mint(msg.sender, shares);
436   }
437 
438   // No rebalance implementation for lower fees and faster swaps
439   function withdraw(uint256 _shares)
440       external
441       nonReentrant
442   {
443       require(_shares > 0, "withdraw must be greater than 0");
444 
445       uint256 ibalance = balanceOf(msg.sender);
446       require(_shares <= ibalance, "insufficient balance");
447 
448       // Could have over value from cTokens
449       pool = _calcPoolValueInToken();
450       // Calc to redeem before updating balances
451       uint256 r = (pool.mul(_shares)).div(_totalSupply);
452 
453 
454       _balances[msg.sender] = _balances[msg.sender].sub(_shares, "redeem amount exceeds balance");
455       _totalSupply = _totalSupply.sub(_shares);
456 
457       emit Transfer(msg.sender, address(0), _shares);
458 
459       // Check balance
460       uint256 b = IERC20(token).balanceOf(address(this));
461       if (b < r) {
462         _withdrawSome(r.sub(b));
463       }
464 
465       IERC20(token).safeTransfer(msg.sender, r);
466       pool = _calcPoolValueInToken();
467   }
468 
469   function() external payable {
470 
471   }
472 
473   function recommend() public view returns (Lender) {
474     (,uint256 capr,uint256 iapr,uint256 aapr,uint256 dapr) = IIEarnManager(apr).recommend(token);
475     uint256 max = 0;
476     if (capr > max) {
477       max = capr;
478     }
479     if (iapr > max) {
480       max = iapr;
481     }
482     if (aapr > max) {
483       max = aapr;
484     }
485     if (dapr > max) {
486       max = dapr;
487     }
488 
489     Lender newProvider = Lender.NONE;
490     if (max == capr) {
491       newProvider = Lender.COMPOUND;
492     } else if (max == iapr) {
493       newProvider = Lender.FULCRUM;
494     } else if (max == aapr) {
495       newProvider = Lender.AAVE;
496     } else if (max == dapr) {
497       newProvider = Lender.DYDX;
498     }
499     return newProvider;
500   }
501 
502   function supplyDydx(uint256 amount) public returns(uint) {
503       Info[] memory infos = new Info[](1);
504       infos[0] = Info(address(this), 0);
505 
506       AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);
507       ActionArgs memory act;
508       act.actionType = ActionType.Deposit;
509       act.accountId = 0;
510       act.amount = amt;
511       act.primaryMarketId = dToken;
512       act.otherAddress = address(this);
513 
514       ActionArgs[] memory args = new ActionArgs[](1);
515       args[0] = act;
516 
517       DyDx(dydx).operate(infos, args);
518   }
519 
520   function _withdrawDydx(uint256 amount) internal {
521       Info[] memory infos = new Info[](1);
522       infos[0] = Info(address(this), 0);
523 
524       AssetAmount memory amt = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, amount);
525       ActionArgs memory act;
526       act.actionType = ActionType.Withdraw;
527       act.accountId = 0;
528       act.amount = amt;
529       act.primaryMarketId = dToken;
530       act.otherAddress = address(this);
531 
532       ActionArgs[] memory args = new ActionArgs[](1);
533       args[0] = act;
534 
535       DyDx(dydx).operate(infos, args);
536   }
537 
538   function getAave() public view returns (address) {
539     return LendingPoolAddressesProvider(aave).getLendingPool();
540   }
541   function getAaveCore() public view returns (address) {
542     return LendingPoolAddressesProvider(aave).getLendingPoolCore();
543   }
544 
545   function approveToken() public {
546       IERC20(token).safeApprove(compound, uint(-1)); //also add to constructor
547       IERC20(token).safeApprove(dydx, uint(-1));
548       IERC20(token).safeApprove(getAaveCore(), uint(-1));
549       IERC20(token).safeApprove(fulcrum, uint(-1));
550   }
551 
552   function balance() public view returns (uint256) {
553     return IERC20(token).balanceOf(address(this));
554   }
555 
556   function balanceDydx() public view returns (uint256) {
557       Wei memory bal = DyDx(dydx).getAccountWei(Info(address(this), 0), dToken);
558       return bal.value;
559   }
560   function balanceCompound() public view returns (uint256) {
561       return IERC20(compound).balanceOf(address(this));
562   }
563   function balanceCompoundInToken() public view returns (uint256) {
564     // Mantisa 1e18 to decimals
565     uint256 b = balanceCompound();
566     if (b > 0) {
567       b = b.mul(Compound(compound).exchangeRateStored()).div(1e18);
568     }
569     return b;
570   }
571   function balanceFulcrumInToken() public view returns (uint256) {
572     uint256 b = balanceFulcrum();
573     if (b > 0) {
574       b = Fulcrum(fulcrum).assetBalanceOf(address(this));
575     }
576     return b;
577   }
578   function balanceFulcrum() public view returns (uint256) {
579     return IERC20(fulcrum).balanceOf(address(this));
580   }
581   function balanceAave() public view returns (uint256) {
582     return IERC20(aaveToken).balanceOf(address(this));
583   }
584 
585   function _balance() internal view returns (uint256) {
586     return IERC20(token).balanceOf(address(this));
587   }
588 
589   function _balanceDydx() internal view returns (uint256) {
590       Wei memory bal = DyDx(dydx).getAccountWei(Info(address(this), 0), dToken);
591       return bal.value;
592   }
593   function _balanceCompound() internal view returns (uint256) {
594       return IERC20(compound).balanceOf(address(this));
595   }
596   function _balanceCompoundInToken() internal view returns (uint256) {
597     // Mantisa 1e18 to decimals
598     uint256 b = balanceCompound();
599     if (b > 0) {
600       b = b.mul(Compound(compound).exchangeRateStored()).div(1e18);
601     }
602     return b;
603   }
604   function _balanceFulcrumInToken() internal view returns (uint256) {
605     uint256 b = balanceFulcrum();
606     if (b > 0) {
607       b = Fulcrum(fulcrum).assetBalanceOf(address(this));
608     }
609     return b;
610   }
611   function _balanceFulcrum() internal view returns (uint256) {
612     return IERC20(fulcrum).balanceOf(address(this));
613   }
614   function _balanceAave() internal view returns (uint256) {
615     return IERC20(aaveToken).balanceOf(address(this));
616   }
617 
618   function _withdrawAll() internal {
619     uint256 amount = _balanceCompound();
620     if (amount > 0) {
621       _withdrawCompound(amount);
622     }
623     amount = _balanceDydx();
624     if (amount > 0) {
625       _withdrawDydx(amount);
626     }
627     amount = _balanceFulcrum();
628     if (amount > 0) {
629       _withdrawFulcrum(amount);
630     }
631     amount = _balanceAave();
632     if (amount > 0) {
633       _withdrawAave(amount);
634     }
635   }
636 
637   function _withdrawSomeCompound(uint256 _amount) internal {
638     uint256 b = balanceCompound();
639     uint256 bT = balanceCompoundInToken();
640     require(bT >= _amount, "insufficient funds");
641     // can have unintentional rounding errors
642     uint256 amount = (b.mul(_amount)).div(bT).add(1);
643     _withdrawCompound(amount);
644   }
645 
646   // 1999999614570950845
647   function _withdrawSomeFulcrum(uint256 _amount) internal {
648     // Balance of fulcrum tokens, 1 iDAI = 1.00x DAI
649     uint256 b = balanceFulcrum(); // 1970469086655766652
650     // Balance of token in fulcrum
651     uint256 bT = balanceFulcrumInToken(); // 2000000803224344406
652     require(bT >= _amount, "insufficient funds");
653     // can have unintentional rounding errors
654     uint256 amount = (b.mul(_amount)).div(bT).add(1);
655     _withdrawFulcrum(amount);
656   }
657 
658   function _withdrawSome(uint256 _amount) internal {
659     if (provider == Lender.COMPOUND) {
660       _withdrawSomeCompound(_amount);
661     }
662     if (provider == Lender.AAVE) {
663       require(balanceAave() >= _amount, "insufficient funds");
664       _withdrawAave(_amount);
665     }
666     if (provider == Lender.DYDX) {
667       require(balanceDydx() >= _amount, "insufficient funds");
668       _withdrawDydx(_amount);
669     }
670     if (provider == Lender.FULCRUM) {
671       _withdrawSomeFulcrum(_amount);
672     }
673   }
674 
675   function rebalance() public {
676     Lender newProvider = recommend();
677 
678     if (newProvider != provider) {
679       _withdrawAll();
680     }
681 
682     if (balance() > 0) {
683       if (newProvider == Lender.DYDX) {
684         supplyDydx(balance());
685       } else if (newProvider == Lender.FULCRUM) {
686         supplyFulcrum(balance());
687       } else if (newProvider == Lender.COMPOUND) {
688         supplyCompound(balance());
689       } else if (newProvider == Lender.AAVE) {
690         supplyAave(balance());
691       }
692     }
693 
694     provider = newProvider;
695   }
696 
697   // Internal only rebalance for better gas in redeem
698   function _rebalance(Lender newProvider) internal {
699     if (_balance() > 0) {
700       if (newProvider == Lender.DYDX) {
701         supplyDydx(_balance());
702       } else if (newProvider == Lender.FULCRUM) {
703         supplyFulcrum(_balance());
704       } else if (newProvider == Lender.COMPOUND) {
705         supplyCompound(_balance());
706       } else if (newProvider == Lender.AAVE) {
707         supplyAave(_balance());
708       }
709     }
710     provider = newProvider;
711   }
712 
713   function supplyAave(uint amount) public {
714       Aave(getAave()).deposit(token, amount, 0);
715   }
716   function supplyFulcrum(uint amount) public {
717       require(Fulcrum(fulcrum).mint(address(this), amount) > 0, "FULCRUM: supply failed");
718   }
719   function supplyCompound(uint amount) public {
720       require(Compound(compound).mint(amount) == 0, "COMPOUND: supply failed");
721   }
722   function _withdrawAave(uint amount) internal {
723       AToken(aaveToken).redeem(amount);
724   }
725   function _withdrawFulcrum(uint amount) internal {
726       require(Fulcrum(fulcrum).burn(address(this), amount) > 0, "FULCRUM: withdraw failed");
727   }
728   function _withdrawCompound(uint amount) internal {
729       require(Compound(compound).redeem(amount) == 0, "COMPOUND: withdraw failed");
730   }
731 
732   function _calcPoolValueInToken() internal view returns (uint) {
733     return _balanceCompoundInToken()
734       .add(_balanceFulcrumInToken())
735       .add(_balanceDydx())
736       .add(_balanceAave())
737       .add(_balance());
738   }
739 
740   function calcPoolValueInToken() public view returns (uint) {
741     return balanceCompoundInToken()
742       .add(balanceFulcrumInToken())
743       .add(balanceDydx())
744       .add(balanceAave())
745       .add(balance());
746   }
747 
748   function getPricePerFullShare() public view returns (uint) {
749     uint _pool = calcPoolValueInToken();
750     return _pool.mul(1e18).div(_totalSupply);
751   }
752 }