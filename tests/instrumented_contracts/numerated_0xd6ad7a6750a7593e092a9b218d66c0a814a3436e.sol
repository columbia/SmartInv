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
29 contract ERC20 is Context, IERC20 {
30     using SafeMath for uint256;
31 
32     mapping (address => uint256) _balances;
33 
34     mapping (address => mapping (address => uint256)) private _allowances;
35 
36     uint256 _totalSupply;
37     function totalSupply() public view returns (uint256) {
38         return _totalSupply;
39     }
40     function balanceOf(address account) public view returns (uint256) {
41         return _balances[account];
42     }
43     function transfer(address recipient, uint256 amount) public returns (bool) {
44         _transfer(_msgSender(), recipient, amount);
45         return true;
46     }
47     function allowance(address owner, address spender) public view returns (uint256) {
48         return _allowances[owner][spender];
49     }
50     function approve(address spender, uint256 amount) public returns (bool) {
51         _approve(_msgSender(), spender, amount);
52         return true;
53     }
54     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
55         _transfer(sender, recipient, amount);
56         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
57         return true;
58     }
59     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
60         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
61         return true;
62     }
63     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
64         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
65         return true;
66     }
67     function _transfer(address sender, address recipient, uint256 amount) internal {
68         require(sender != address(0), "ERC20: transfer from the zero address");
69         require(recipient != address(0), "ERC20: transfer to the zero address");
70 
71         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
72         _balances[recipient] = _balances[recipient].add(amount);
73         emit Transfer(sender, recipient, amount);
74     }
75     function _mint(address account, uint256 amount) internal {
76         require(account != address(0), "ERC20: mint to the zero address");
77 
78         _totalSupply = _totalSupply.add(amount);
79         _balances[account] = _balances[account].add(amount);
80         emit Transfer(address(0), account, amount);
81     }
82     function _burn(address account, uint256 amount) internal {
83         require(account != address(0), "ERC20: burn from the zero address");
84 
85         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
86         _totalSupply = _totalSupply.sub(amount);
87         emit Transfer(account, address(0), amount);
88     }
89     function _approve(address owner, address spender, uint256 amount) internal {
90         require(owner != address(0), "ERC20: approve from the zero address");
91         require(spender != address(0), "ERC20: approve to the zero address");
92 
93         _allowances[owner][spender] = amount;
94         emit Approval(owner, spender, amount);
95     }
96     function _burnFrom(address account, uint256 amount) internal {
97         _burn(account, amount);
98         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
99     }
100 }
101 
102 contract ERC20Detailed is IERC20 {
103     string private _name;
104     string private _symbol;
105     uint8 private _decimals;
106 
107     constructor (string memory name, string memory symbol, uint8 decimals) public {
108         _name = name;
109         _symbol = symbol;
110         _decimals = decimals;
111     }
112     function name() public view returns (string memory) {
113         return _name;
114     }
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118     function decimals() public view returns (uint8) {
119         return _decimals;
120     }
121 }
122 
123 contract ReentrancyGuard {
124     uint256 private _guardCounter;
125 
126     constructor () internal {
127         _guardCounter = 1;
128     }
129 
130     modifier nonReentrant() {
131         _guardCounter += 1;
132         uint256 localCounter = _guardCounter;
133         _;
134         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
135     }
136 }
137 
138 library SafeMath {
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         return div(a, b, "SafeMath: division by zero");
166     }
167     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         // Solidity only automatically asserts when dividing by 0
169         require(b > 0, errorMessage);
170         uint256 c = a / b;
171 
172         return c;
173     }
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return mod(a, b, "SafeMath: modulo by zero");
176     }
177     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b != 0, errorMessage);
179         return a % b;
180     }
181 }
182 
183 library Address {
184     function isContract(address account) internal view returns (bool) {
185         bytes32 codehash;
186         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
187         // solhint-disable-next-line no-inline-assembly
188         assembly { codehash := extcodehash(account) }
189         return (codehash != 0x0 && codehash != accountHash);
190     }
191     function toPayable(address account) internal pure returns (address payable) {
192         return address(uint160(account));
193     }
194     function sendValue(address payable recipient, uint256 amount) internal {
195         require(address(this).balance >= amount, "Address: insufficient balance");
196 
197         // solhint-disable-next-line avoid-call-value
198         (bool success, ) = recipient.call.value(amount)("");
199         require(success, "Address: unable to send value, recipient may have reverted");
200     }
201 }
202 
203 library SafeERC20 {
204     using SafeMath for uint256;
205     using Address for address;
206 
207     function safeTransfer(IERC20 token, address to, uint256 value) internal {
208         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
209     }
210 
211     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
212         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
213     }
214 
215     function safeApprove(IERC20 token, address spender, uint256 value) internal {
216         require((value == 0) || (token.allowance(address(this), spender) == 0),
217             "SafeERC20: approve from non-zero to non-zero allowance"
218         );
219         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
220     }
221 
222     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
223         uint256 newAllowance = token.allowance(address(this), spender).add(value);
224         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
225     }
226 
227     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
228         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
229         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
230     }
231     function callOptionalReturn(IERC20 token, bytes memory data) private {
232         require(address(token).isContract(), "SafeERC20: call to non-contract");
233 
234         // solhint-disable-next-line avoid-low-level-calls
235         (bool success, bytes memory returndata) = address(token).call(data);
236         require(success, "SafeERC20: low-level call failed");
237 
238         if (returndata.length > 0) { // Return data is optional
239             // solhint-disable-next-line max-line-length
240             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
241         }
242     }
243 }
244 
245 interface Compound {
246     function mint ( uint256 mintAmount ) external returns ( uint256 );
247     function redeem(uint256 redeemTokens) external returns (uint256);
248     function exchangeRateStored() external view returns (uint);
249 }
250 
251 interface Fulcrum {
252     function mint(address receiver, uint256 amount) external payable returns (uint256 mintAmount);
253     function burn(address receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
254     function assetBalanceOf(address _owner) external view returns (uint256 balance);
255 }
256 
257 interface ILendingPoolAddressesProvider {
258     function getLendingPool() external view returns (address);
259 }
260 
261 interface Aave {
262     function deposit(address _reserve, uint256 _amount, uint16 _referralCode) external;
263 }
264 
265 interface AToken {
266     function redeem(uint256 amount) external;
267 }
268 
269 interface IIEarnManager {
270     function recommend(address _token) external view returns (
271       string memory choice,
272       uint256 capr,
273       uint256 iapr,
274       uint256 aapr,
275       uint256 dapr
276     );
277 }
278 
279 contract Structs {
280     struct Val {
281         uint256 value;
282     }
283 
284     enum ActionType {
285         Deposit,   // supply tokens
286         Withdraw  // borrow tokens
287     }
288 
289     enum AssetDenomination {
290         Wei // the amount is denominated in wei
291     }
292 
293     enum AssetReference {
294         Delta // the amount is given as a delta from the current value
295     }
296 
297     struct AssetAmount {
298         bool sign; // true if positive
299         AssetDenomination denomination;
300         AssetReference ref;
301         uint256 value;
302     }
303 
304     struct ActionArgs {
305         ActionType actionType;
306         uint256 accountId;
307         AssetAmount amount;
308         uint256 primaryMarketId;
309         uint256 secondaryMarketId;
310         address otherAddress;
311         uint256 otherAccountId;
312         bytes data;
313     }
314 
315     struct Info {
316         address owner;  // The address that owns the account
317         uint256 number; // A nonce that allows a single address to control many accounts
318     }
319 
320     struct Wei {
321         bool sign; // true if positive
322         uint256 value;
323     }
324 }
325 
326 contract DyDx is Structs {
327     function getAccountWei(Info memory account, uint256 marketId) public view returns (Wei memory);
328     function operate(Info[] memory, ActionArgs[] memory) public;
329 }
330 
331 interface LendingPoolAddressesProvider {
332     function getLendingPool() external view returns (address);
333     function getLendingPoolCore() external view returns (address);
334 }
335 
336 contract yUSDC is ERC20, ERC20Detailed, ReentrancyGuard, Structs {
337   using SafeERC20 for IERC20;
338   using Address for address;
339   using SafeMath for uint256;
340 
341   uint256 public pool;
342   address public token;
343   address public compound;
344   address public fulcrum;
345   address public aave;
346   address public aaveToken;
347   address public dydx;
348   uint256 public dToken;
349   address public apr;
350 
351   enum Lender {
352       NONE,
353       DYDX,
354       COMPOUND,
355       AAVE,
356       FULCRUM
357   }
358 
359   Lender public provider = Lender.NONE;
360 
361   constructor () public ERC20Detailed("iearn USDC", "yUSDC", 6) {
362     token = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
363     apr = address(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
364     dydx = address(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
365     aave = address(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);
366     fulcrum = address(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);
367     aaveToken = address(0x9bA00D6856a4eDF4665BcA2C2309936572473B7E);
368     compound = address(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
369     dToken = 2;
370     approveToken();
371   }
372 
373   // Quick swap low gas method for pool swaps
374   function deposit(uint256 _amount)
375       external
376       nonReentrant
377   {
378       require(_amount > 0, "deposit must be greater than 0");
379       pool = _calcPoolValueInToken();
380 
381       IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
382 
383       // Calculate pool shares
384       uint256 shares = 0;
385       if (pool == 0) {
386         shares = _amount;
387         pool = _amount;
388       } else {
389         shares = (_amount.mul(_totalSupply)).div(pool);
390       }
391       pool = _calcPoolValueInToken();
392       _mint(msg.sender, shares);
393   }
394 
395   // No rebalance implementation for lower fees and faster swaps
396   function withdraw(uint256 _shares)
397       external
398       nonReentrant
399   {
400       require(_shares > 0, "withdraw must be greater than 0");
401 
402       uint256 ibalance = balanceOf(msg.sender);
403       require(_shares <= ibalance, "insufficient balance");
404 
405       // Could have over value from cTokens
406       pool = _calcPoolValueInToken();
407       // Calc to redeem before updating balances
408       uint256 r = (pool.mul(_shares)).div(_totalSupply);
409 
410 
411       _balances[msg.sender] = _balances[msg.sender].sub(_shares, "redeem amount exceeds balance");
412       _totalSupply = _totalSupply.sub(_shares);
413 
414       emit Transfer(msg.sender, address(0), _shares);
415 
416       // Check balance
417       uint256 b = IERC20(token).balanceOf(address(this));
418       if (b < r) {
419         _withdrawSome(r.sub(b));
420       }
421 
422       IERC20(token).transfer(msg.sender, r);
423       pool = _calcPoolValueInToken();
424   }
425 
426   function() external payable {
427 
428   }
429 
430   function recommend() public view returns (Lender) {
431     (,uint256 capr,uint256 iapr,uint256 aapr,uint256 dapr) = IIEarnManager(apr).recommend(token);
432     uint256 max = 0;
433     if (capr > max) {
434       max = capr;
435     }
436     if (iapr > max) {
437       max = iapr;
438     }
439     if (aapr > max) {
440       max = aapr;
441     }
442     if (dapr > max) {
443       max = dapr;
444     }
445 
446     Lender newProvider = Lender.NONE;
447     if (max == capr) {
448       newProvider = Lender.COMPOUND;
449     } else if (max == iapr) {
450       newProvider = Lender.FULCRUM;
451     } else if (max == aapr) {
452       newProvider = Lender.AAVE;
453     } else if (max == dapr) {
454       newProvider = Lender.DYDX;
455     }
456     return newProvider;
457   }
458 
459   function supplyDydx(uint256 amount) public returns(uint) {
460       Info[] memory infos = new Info[](1);
461       infos[0] = Info(address(this), 0);
462 
463       AssetAmount memory amt = AssetAmount(true, AssetDenomination.Wei, AssetReference.Delta, amount);
464       ActionArgs memory act;
465       act.actionType = ActionType.Deposit;
466       act.accountId = 0;
467       act.amount = amt;
468       act.primaryMarketId = dToken;
469       act.otherAddress = address(this);
470 
471       ActionArgs[] memory args = new ActionArgs[](1);
472       args[0] = act;
473 
474       DyDx(dydx).operate(infos, args);
475   }
476 
477   function _withdrawDydx(uint256 amount) internal {
478       Info[] memory infos = new Info[](1);
479       infos[0] = Info(address(this), 0);
480 
481       AssetAmount memory amt = AssetAmount(false, AssetDenomination.Wei, AssetReference.Delta, amount);
482       ActionArgs memory act;
483       act.actionType = ActionType.Withdraw;
484       act.accountId = 0;
485       act.amount = amt;
486       act.primaryMarketId = dToken;
487       act.otherAddress = address(this);
488 
489       ActionArgs[] memory args = new ActionArgs[](1);
490       args[0] = act;
491 
492       DyDx(dydx).operate(infos, args);
493   }
494 
495   function getAave() public view returns (address) {
496     return LendingPoolAddressesProvider(aave).getLendingPool();
497   }
498   function getAaveCore() public view returns (address) {
499     return LendingPoolAddressesProvider(aave).getLendingPoolCore();
500   }
501 
502   function approveToken() public {
503       IERC20(token).safeApprove(compound, uint(-1)); //also add to constructor
504       IERC20(token).safeApprove(dydx, uint(-1));
505       IERC20(token).safeApprove(getAaveCore(), uint(-1));
506       IERC20(token).safeApprove(fulcrum, uint(-1));
507   }
508 
509   function balance() public view returns (uint256) {
510     return IERC20(token).balanceOf(address(this));
511   }
512 
513   function balanceDydx() public view returns (uint256) {
514       Wei memory bal = DyDx(dydx).getAccountWei(Info(address(this), 0), dToken);
515       return bal.value;
516   }
517   function balanceCompound() public view returns (uint256) {
518       return IERC20(compound).balanceOf(address(this));
519   }
520   function balanceCompoundInToken() public view returns (uint256) {
521     // Mantisa 1e18 to decimals
522     uint256 b = balanceCompound();
523     if (b > 0) {
524       b = b.mul(Compound(compound).exchangeRateStored()).div(1e18);
525     }
526     return b;
527   }
528   function balanceFulcrumInToken() public view returns (uint256) {
529     uint256 b = balanceFulcrum();
530     if (b > 0) {
531       b = Fulcrum(fulcrum).assetBalanceOf(address(this));
532     }
533     return b;
534   }
535   function balanceFulcrum() public view returns (uint256) {
536     return IERC20(fulcrum).balanceOf(address(this));
537   }
538   function balanceAave() public view returns (uint256) {
539     return IERC20(aaveToken).balanceOf(address(this));
540   }
541 
542   function _balance() internal view returns (uint256) {
543     return IERC20(token).balanceOf(address(this));
544   }
545 
546   function _balanceDydx() internal view returns (uint256) {
547       Wei memory bal = DyDx(dydx).getAccountWei(Info(address(this), 0), dToken);
548       return bal.value;
549   }
550   function _balanceCompound() internal view returns (uint256) {
551       return IERC20(compound).balanceOf(address(this));
552   }
553   function _balanceCompoundInToken() internal view returns (uint256) {
554     // Mantisa 1e18 to decimals
555     uint256 b = balanceCompound();
556     if (b > 0) {
557       b = b.mul(Compound(compound).exchangeRateStored()).div(1e18);
558     }
559     return b;
560   }
561   function _balanceFulcrumInToken() internal view returns (uint256) {
562     uint256 b = balanceFulcrum();
563     if (b > 0) {
564       b = Fulcrum(fulcrum).assetBalanceOf(address(this));
565     }
566     return b;
567   }
568   function _balanceFulcrum() internal view returns (uint256) {
569     return IERC20(fulcrum).balanceOf(address(this));
570   }
571   function _balanceAave() internal view returns (uint256) {
572     return IERC20(aaveToken).balanceOf(address(this));
573   }
574 
575   function _withdrawAll() internal {
576     uint256 amount = _balanceCompound();
577     if (amount > 0) {
578       _withdrawCompound(amount);
579     }
580     amount = _balanceDydx();
581     if (amount > 0) {
582       _withdrawDydx(amount);
583     }
584     amount = _balanceFulcrum();
585     if (amount > 0) {
586       _withdrawFulcrum(amount);
587     }
588     amount = _balanceAave();
589     if (amount > 0) {
590       _withdrawAave(amount);
591     }
592   }
593 
594   function _withdrawSomeCompound(uint256 _amount) internal {
595     uint256 b = balanceCompound();
596     uint256 bT = balanceCompoundInToken();
597     require(bT >= _amount, "insufficient funds");
598     // can have unintentional rounding errors
599     uint256 amount = (b.mul(_amount)).div(bT).add(1);
600     _withdrawCompound(amount);
601   }
602 
603   // 1999999614570950845
604   function _withdrawSomeFulcrum(uint256 _amount) internal {
605     // Balance of fulcrum tokens, 1 iDAI = 1.00x DAI
606     uint256 b = balanceFulcrum(); // 1970469086655766652
607     // Balance of token in fulcrum
608     uint256 bT = balanceFulcrumInToken(); // 2000000803224344406
609     require(bT >= _amount, "insufficient funds");
610     // can have unintentional rounding errors
611     uint256 amount = (b.mul(_amount)).div(bT).add(1);
612     _withdrawFulcrum(amount);
613   }
614 
615   function _withdrawSome(uint256 _amount) internal {
616     if (provider == Lender.COMPOUND) {
617       _withdrawSomeCompound(_amount);
618     }
619     if (provider == Lender.AAVE) {
620       require(balanceAave() >= _amount, "insufficient funds");
621       _withdrawAave(_amount);
622     }
623     if (provider == Lender.DYDX) {
624       require(balanceDydx() >= _amount, "insufficient funds");
625       _withdrawDydx(_amount);
626     }
627     if (provider == Lender.FULCRUM) {
628       _withdrawSomeFulcrum(_amount);
629     }
630   }
631 
632   function rebalance() public {
633     Lender newProvider = recommend();
634 
635     if (newProvider != provider) {
636       _withdrawAll();
637     }
638 
639     if (balance() > 0) {
640       if (newProvider == Lender.DYDX) {
641         supplyDydx(balance());
642       } else if (newProvider == Lender.FULCRUM) {
643         supplyFulcrum(balance());
644       } else if (newProvider == Lender.COMPOUND) {
645         supplyCompound(balance());
646       } else if (newProvider == Lender.AAVE) {
647         supplyAave(balance());
648       }
649     }
650 
651     provider = newProvider;
652   }
653 
654   // Internal only rebalance for better gas in redeem
655   function _rebalance(Lender newProvider) internal {
656     if (_balance() > 0) {
657       if (newProvider == Lender.DYDX) {
658         supplyDydx(_balance());
659       } else if (newProvider == Lender.FULCRUM) {
660         supplyFulcrum(_balance());
661       } else if (newProvider == Lender.COMPOUND) {
662         supplyCompound(_balance());
663       } else if (newProvider == Lender.AAVE) {
664         supplyAave(_balance());
665       }
666     }
667     provider = newProvider;
668   }
669 
670   function supplyAave(uint amount) public {
671       Aave(getAave()).deposit(token, amount, 0);
672   }
673   function supplyFulcrum(uint amount) public {
674       require(Fulcrum(fulcrum).mint(address(this), amount) > 0, "FULCRUM: supply failed");
675   }
676   function supplyCompound(uint amount) public {
677       require(Compound(compound).mint(amount) == 0, "COMPOUND: supply failed");
678   }
679   function _withdrawAave(uint amount) internal {
680       AToken(aaveToken).redeem(amount);
681   }
682   function _withdrawFulcrum(uint amount) internal {
683       require(Fulcrum(fulcrum).burn(address(this), amount) > 0, "FULCRUM: withdraw failed");
684   }
685   function _withdrawCompound(uint amount) internal {
686       require(Compound(compound).redeem(amount) == 0, "COMPOUND: withdraw failed");
687   }
688 
689   function invest(uint256 _amount)
690       external
691       nonReentrant
692   {
693       require(_amount > 0, "deposit must be greater than 0");
694       pool = calcPoolValueInToken();
695 
696       IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);
697 
698       rebalance();
699 
700       // Calculate pool shares
701       uint256 shares = 0;
702       if (pool == 0) {
703         shares = _amount;
704         pool = _amount;
705       } else {
706         shares = (_amount.mul(_totalSupply)).div(pool);
707       }
708       pool = calcPoolValueInToken();
709       _mint(msg.sender, shares);
710   }
711 
712   function _calcPoolValueInToken() internal view returns (uint) {
713     return _balanceCompoundInToken()
714       .add(_balanceFulcrumInToken())
715       .add(_balanceDydx())
716       .add(_balanceAave())
717       .add(_balance());
718   }
719 
720   function calcPoolValueInToken() public view returns (uint) {
721     return balanceCompoundInToken()
722       .add(balanceFulcrumInToken())
723       .add(balanceDydx())
724       .add(balanceAave())
725       .add(balance());
726   }
727 
728   function getPricePerFullShare() public view returns (uint) {
729     uint _pool = calcPoolValueInToken();
730     return _pool.mul(1e18).div(_totalSupply);
731   }
732 
733   // Redeem any invested tokens from the pool
734   function redeem(uint256 _shares)
735       external
736       nonReentrant
737   {
738       require(_shares > 0, "withdraw must be greater than 0");
739 
740       uint256 ibalance = balanceOf(msg.sender);
741       require(_shares <= ibalance, "insufficient balance");
742 
743       // Could have over value from cTokens
744       pool = calcPoolValueInToken();
745       // Calc to redeem before updating balances
746       uint256 r = (pool.mul(_shares)).div(_totalSupply);
747 
748 
749       _balances[msg.sender] = _balances[msg.sender].sub(_shares, "redeem amount exceeds balance");
750       _totalSupply = _totalSupply.sub(_shares);
751 
752       emit Transfer(msg.sender, address(0), _shares);
753 
754       // Check ETH balance
755       uint256 b = IERC20(token).balanceOf(address(this));
756       Lender newProvider = provider;
757       if (b < r) {
758         newProvider = recommend();
759         if (newProvider != provider) {
760           _withdrawAll();
761         } else {
762           _withdrawSome(r.sub(b));
763         }
764       }
765 
766       IERC20(token).safeTransfer(msg.sender, r);
767 
768       if (newProvider != provider) {
769         _rebalance(newProvider);
770       }
771       pool = calcPoolValueInToken();
772   }
773 }