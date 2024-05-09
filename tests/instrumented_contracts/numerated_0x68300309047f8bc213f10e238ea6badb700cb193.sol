1 //
2 //░██████╗░█████╗░██╗░░░░░██╗██████╗░██████╗░██╗░░░░░░█████╗░░█████╗░██╗░░██╗
3 //██╔════╝██╔══██╗██║░░░░░██║██╔══██╗██╔══██╗██║░░░░░██╔══██╗██╔══██╗██║░██╔╝
4 //╚█████╗░██║░░██║██║░░░░░██║██║░░██║██████╦╝██║░░░░░██║░░██║██║░░╚═╝█████═╝░
5 //░╚═══██╗██║░░██║██║░░░░░██║██║░░██║██╔══██╗██║░░░░░██║░░██║██║░░██╗██╔═██╗░
6 //██████╔╝╚█████╔╝███████╗██║██████╔╝██████╦╝███████╗╚█████╔╝╚█████╔╝██║░╚██╗
7 //╚═════╝░░╚════╝░╚══════╝╚═╝╚═════╝░╚═════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝
8 
9 
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.4;
13 
14 interface IERC20 {
15     function totalSupply() external view returns(uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address to, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer (address indexed from, address indexed to, uint value);
22     event Approval (address indexed owner, address indexed spender, uint value);
23 }
24 
25 interface IERC20Upgradeable {
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address to, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(
35         address from,
36         address to,
37         uint256 amount
38     ) external returns (bool);
39 }
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor() {
58         _setOwner(_msgSender());
59     }
60 
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     function renounceOwnership() public virtual onlyOwner {
71         _setOwner(address(0));
72     }
73 
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         _setOwner(newOwner);
77     }
78 
79     function _setOwner(address newOwner) internal {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 interface IFactory{
87         function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IRouter {
91     function factory() external pure returns (address);
92     function WETH() external pure returns (address);
93     function addTreasuryETH(
94         address token,
95         uint amountTokenDesired,
96         uint amountTokenMin,
97         uint amountETHMin,
98         address to,
99         uint deadline
100     ) external payable returns (uint amountToken, uint amountETH, uint treasury);
101 
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline) external;
108 
109     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline) external;
115 
116     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
117 
118 }
119 
120 abstract contract ReentrancyGuard {
121 
122     uint256 private constant _NOT_ENTERED = 1;
123     uint256 private constant _ENTERED = 2;
124 
125     uint256 private _status;
126 
127     constructor() {
128         _status = _NOT_ENTERED;
129     }
130 
131     modifier nonReentrant() {
132         _nonReentrantBefore();
133         _;
134         _nonReentrantAfter();
135     }
136 
137     function _nonReentrantBefore() private {
138         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
139         _status = _ENTERED;
140     }
141 
142     function _nonReentrantAfter() private {
143         _status = _NOT_ENTERED;
144     }
145 
146     function _reentrancyGuardEntered() internal view returns (bool) {
147         return _status == _ENTERED;
148     }
149 }
150 
151 library SafeMath {
152     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         unchecked {
154             uint256 c = a + b;
155             if (c < a) return (false, 0);
156             return (true, c);
157         }
158     }
159 
160     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b > a) return (false, 0);
163             return (true, a - b);
164         }
165     }
166 
167     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         unchecked {
169             if (a == 0) return (true, 0);
170             uint256 c = a * b;
171             if (c / a != b) return (false, 0);
172             return (true, c);
173         }
174     }
175 
176     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         unchecked {
178             if (b == 0) return (false, 0);
179             return (true, a / b);
180         }
181     }
182 
183     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         unchecked {
185             if (b == 0) return (false, 0);
186             return (true, a % b);
187         }
188     }
189 
190     function add(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a + b;
192     }
193 
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a - b;
196     }
197 
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         return a * b;
200     }
201 
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a / b;
204     }
205 
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a % b;
208     }
209 
210     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         unchecked {
212             require(b <= a, errorMessage);
213             return a - b;
214         }
215     }
216 
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         unchecked {
219             require(b > 0, errorMessage);
220             return a / b;
221         }
222     }
223 
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 library Address {
233     function isContract(address account) internal view returns (bool) {
234         return account.code.length > 0;
235     }
236 
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
246     }
247 
248     function functionCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, 0, errorMessage);
254     }
255 
256     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
258     }
259 
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(address(this).balance >= value, "Address: insufficient balance for call");
267         (bool success, bytes memory returndata) = target.call{value: value}(data);
268         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
269     }
270 
271     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
272         return functionStaticCall(target, data, "Address: low-level static call failed");
273     }
274 
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         (bool success, bytes memory returndata) = target.staticcall(data);
281         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
282     }
283 
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     function functionDelegateCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal returns (bytes memory) {
293         (bool success, bytes memory returndata) = target.delegatecall(data);
294         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
295     }
296 
297     function verifyCallResultFromTarget(
298         address target,
299         bool success,
300         bytes memory returndata,
301         string memory errorMessage
302     ) internal view returns (bytes memory) {
303         if (success) {
304             if (returndata.length == 0) {
305                 // only check isContract if the call was successful and the return data is empty
306                 // otherwise we already know that it was a contract
307                 require(isContract(target), "Address: call to non-contract");
308             }
309             return returndata;
310         } else {
311             _revert(returndata, errorMessage);
312         }
313     }
314 
315     function verifyCallResult(
316         bool success,
317         bytes memory returndata,
318         string memory errorMessage
319     ) internal pure returns (bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             _revert(returndata, errorMessage);
324         }
325     }
326 
327     function _revert(bytes memory returndata, string memory errorMessage) private pure {
328         // Look for revert reason and bubble it up if present
329         if (returndata.length > 0) {
330             // The easiest way to bubble the revert reason is using memory via assembly
331             /// @solidity memory-safe-assembly
332             assembly {
333                 let returndata_size := mload(returndata)
334                 revert(add(32, returndata), returndata_size)
335             }
336         } else {
337             revert(errorMessage);
338         }
339     }
340 }
341 
342 interface IERC20Permit {
343     function permit(
344         address owner,
345         address spender,
346         uint256 value,
347         uint256 deadline,
348         uint8 v,
349         bytes32 r,
350         bytes32 s
351     ) external;
352 
353     function nonces(address owner) external view returns (uint256);
354 
355     function DOMAIN_SEPARATOR() external view returns (bytes32);
356 }
357 
358 library SafeERC20 {
359     using Address for address;
360 
361     function safeTransfer(IERC20 token, address to, uint256 value) internal {
362         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
363     }
364 
365     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
366         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
367     }
368 
369     function safeApprove(IERC20 token, address spender, uint256 value) internal {
370         require(
371             (value == 0) || (token.allowance(address(this), spender) == 0),
372             "SafeERC20: approve from non-zero to non-zero allowance"
373         );
374         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
375     }
376 
377     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
378         uint256 oldAllowance = token.allowance(address(this), spender);
379         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
380     }
381 
382     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
383         unchecked {
384             uint256 oldAllowance = token.allowance(address(this), spender);
385             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
386             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
387         }
388     }
389 
390     function forceApprove(IERC20 token, address spender, uint256 value) internal {
391         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
392 
393         if (!_callOptionalReturnBool(token, approvalCall)) {
394             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
395             _callOptionalReturn(token, approvalCall);
396         }
397     }
398 
399     function safePermit(
400         IERC20Permit token,
401         address owner,
402         address spender,
403         uint256 value,
404         uint256 deadline,
405         uint8 v,
406         bytes32 r,
407         bytes32 s
408     ) internal {
409         uint256 nonceBefore = token.nonces(owner);
410         token.permit(owner, spender, value, deadline, v, r, s);
411         uint256 nonceAfter = token.nonces(owner);
412         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
413     }
414 
415     function _callOptionalReturn(IERC20 token, bytes memory data) private {
416 
417         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
418         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
419     }
420 
421     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
422         (bool success, bytes memory returndata) = address(token).call(data);
423         return
424             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
425     }
426 }   
427 
428 contract SOLIDBLOCK is IERC20, Ownable {
429 
430     mapping(address => uint256) private _rOwned;
431     mapping(address => uint256) private _tOwned;
432     mapping(address => mapping(address => uint256)) private _allowances;
433     mapping(address => bool) private _isExcludedFromFee;
434     mapping(address => bool) private _isExcludedFromMaxTransactionLimit;
435 	mapping(address => bool) private _isExcludedFromMaxWalletLimit;
436     mapping(address => bool) private _isExcluded;
437     mapping(address => bool) private _isBot;
438     mapping(address => bool) private _isPair;
439 
440     address[] private _excluded;
441     
442     bool private swapping;
443     mapping(address => bool) private _operator;
444 
445     IRouter public router;
446     address public pair;
447 
448     uint8 private constant _decimals = 18;
449     uint256 private constant MAX = ~uint256(0);
450 
451     uint256 private _tTotal = 200_000_000_000 * 10**_decimals;
452     uint256 private _rTotal = (MAX - (MAX % _tTotal));
453 
454     
455     uint256 public swapTokensAtAmount = 10_000 * 10 ** 18;
456     uint256 public maxTxAmount = 50_000_000_000 * 10**_decimals;
457     uint256 public maxWalletAmount = 1_000_000_000 * 10**_decimals;
458     
459     // Anti Dump //
460     mapping (address => uint256) public _lastTrade;
461     bool public coolDownEnabled = true;
462     uint256 public coolDownTime = 30 seconds;
463 
464     address public treasuryAddress = 0x15564669B5E6737785B0b36875fC7668Fe4CAc01;
465     address public developmentAddress = 0xF8449D6a454469732aD0c7f83d8a018d967BF588 ;
466     address constant burnAddress = 0x000000000000000000000000000000000000dEaD;
467 
468     address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
469 
470     string private constant _name = "SOLIDBLOCK";
471     string private constant _symbol = "SOLID";
472 
473     // Black List //
474     mapping (address => bool) private _isBlocked;
475 
476     // Trading
477     uint256 private _launchStartTimestamp;
478     uint256 private _launchBlockNumber;
479     bool public isTradingEnabled;
480     mapping (address => bool) private _isAllowedToTradeWhenDisabled;
481 
482     address public v1TokenAddress;
483     
484     struct Taxes {
485       uint256 rfi;
486       uint256 treasury;
487       uint256 development;
488       uint256 burn;
489     }
490 
491     Taxes public taxes = Taxes(0,40,20,0);
492 
493     struct TotFeesPaidStruct {
494         uint256 rfi;
495         uint256 treasury;
496         uint256 development;
497         uint256 burn;
498     }
499 
500     TotFeesPaidStruct public totFeesPaid;
501 
502     struct valuesFromGetValues{
503       uint256 rAmount;
504       uint256 rTransferAmount;
505       uint256 rRfi;
506       uint256 rTreasury;
507       uint256 rDevelopment;
508       uint256 rBurn;
509       uint256 tTransferAmount;
510       uint256 tRfi;
511       uint256 tTreasury;
512       uint256 tDevelopment;
513       uint256 tBurn;
514     }
515     
516     struct splitETHStruct{
517         uint256 treasury;
518         uint256 development;
519     }
520 
521     splitETHStruct private splitETH = splitETHStruct(40,10);
522 
523     struct ETHAmountStruct{
524         uint256 treasury;
525         uint256 development;
526     }
527 
528     ETHAmountStruct public ETHAmount;
529 
530     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);   
531     event BlockedAccountChange(address indexed holder, bool indexed status);
532     event FeesChanged();
533     event AllowedWhenTradingDisabledChange(address indexed account, bool isExcluded);
534     event TradingStatusChange(bool indexed newValue, bool indexed oldValue);
535     event PresaleStatusChange(bool indexed newValue, bool indexed oldValue);
536 
537     modifier lockTheSwap {
538         swapping = true;
539         _;
540         swapping = false;
541     }
542 
543     modifier addressValidation(address _addr) {
544         require(_addr != address(0), 'SOLIDBLOCK: Zero address');
545         _;
546     }
547 
548     modifier onlyOperatorOrOwner() {
549         require(_operator[msg.sender] || owner() == msg.sender, "Caller is not an operator");
550         //require(_operator == msg.sender || owner() == msg.sender, "operator: caller is not the operator or owner");
551         _;
552     }
553 
554     constructor () {
555         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
556         address _pair = IFactory(_router.factory())
557             .createPair(address(this), _router.WETH());
558 
559         router = _router;
560         pair = _pair;
561         
562         addPair(pair);
563     
564         excludeFromReward(pair);
565 
566         _rOwned[owner()] = _rTotal;
567         _isExcludedFromFee[owner()] = true;
568         _isExcludedFromFee[address(this)] = true;
569         _isExcludedFromFee[treasuryAddress] = true;
570         _isExcludedFromFee[burnAddress] = true;
571         _isExcludedFromFee[developmentAddress] = true;
572 
573         _isExcludedFromMaxTransactionLimit[address(this)] = true;
574 		_isExcludedFromMaxTransactionLimit[owner()] = true;
575         _isExcludedFromMaxTransactionLimit[_pair] = true;
576         _isExcludedFromMaxTransactionLimit[address(_router)] = true;
577 
578 		_isExcludedFromMaxWalletLimit[_pair] = true;
579 		_isExcludedFromMaxWalletLimit[address(_router)] = true;
580 		_isExcludedFromMaxWalletLimit[address(this)] = true;
581 		_isExcludedFromMaxWalletLimit[owner()] = true;
582         _isExcludedFromMaxWalletLimit[burnAddress] = true;
583 
584 
585         emit Transfer(address(0), owner(), _tTotal);
586     }
587 
588     function name() public pure returns (string memory) {
589         return _name;
590     }
591     function symbol() public pure returns (string memory) {
592         return _symbol;
593     }
594     function decimals() public pure returns (uint8) {
595         return _decimals;
596     }
597 
598     function totalSupply() public view override returns (uint256) {
599         return _tTotal;
600     }
601 
602     function balanceOf(address account) public view override returns (uint256) {
603         if (_isExcluded[account]) return _tOwned[account];
604         return tokenFromReflection(_rOwned[account]);
605     }
606 
607     function transfer(address recipient, uint256 amount) public override returns (bool) {
608         _transfer(_msgSender(), recipient, amount);
609         return true;
610     }
611 
612     function allowance(address owner, address spender) public view override returns (uint256) {
613         return _allowances[owner][spender];
614     }
615 
616     function approve(address spender, uint256 amount) public override returns (bool) {
617         _approve(_msgSender(), spender, amount);
618         return true;
619     }
620 
621     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
622         uint256 currentAllowance = _allowances[sender][_msgSender()];
623         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
624 
625         _transfer(sender, recipient, amount);
626         _approve(sender, _msgSender(), currentAllowance - amount);
627 
628         return true;
629     }
630 
631     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
633         return true;
634     }
635 
636     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
637         uint256 currentAllowance = _allowances[_msgSender()][spender];
638         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
639         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
640 
641         return true;
642     }
643 
644     function isExcludedFromReward(address account) public view returns (bool) {
645         return _isExcluded[account];
646     }
647 
648     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
649         require(rAmount <= _rTotal, "Amount must be less than total reflections");
650         uint256 currentRate =  _getRate();
651         return rAmount/currentRate;
652     }
653 
654     function excludeFromReward(address account) public onlyOwner {
655         require(!_isExcluded[account], "Account is already excluded");
656         require(_excluded.length <= 200, "Invalid length");
657         require(account != owner(), "Owner cannot be excluded");
658         if(_rOwned[account] > 0) {
659             _tOwned[account] = tokenFromReflection(_rOwned[account]);
660         }
661         _isExcluded[account] = true;
662         _excluded.push(account);
663     }
664 
665     function includeInReward(address account) external onlyOwner() {
666         require(_isExcluded[account], "Account is not excluded");
667         for (uint256 i = 0; i < _excluded.length; i++) {
668             if (_excluded[i] == account) {
669                 _excluded[i] = _excluded[_excluded.length - 1];
670                 _tOwned[account] = 0;
671                 _isExcluded[account] = false;
672                 _excluded.pop();
673                 break;
674             }
675         }
676     }
677 
678     function isOperator(address operator) public view returns (bool) {
679     return _operator[operator];
680     }
681 
682     function _setOperator(address operator_, bool hasPermission) external onlyOwner {
683     require(operator_ != address(0), "Invalid operator address");
684     _operator[operator_] = hasPermission;
685     }   
686 
687 
688     function excludeFromFee(address account) public onlyOperatorOrOwner {
689         _isExcludedFromFee[account] = true;
690     }
691 
692     function includeInFee(address account) public onlyOperatorOrOwner {
693         _isExcludedFromFee[account] = false;
694     }
695 
696 
697     function isExcludedFromFee(address account) public view returns(bool) {
698         return _isExcludedFromFee[account];
699     }
700 
701     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner{
702 		require(_isExcludedFromMaxTransactionLimit[account] != excluded, "SOLIDBLOCK: Account is already the value of 'excluded'");
703 		_isExcludedFromMaxTransactionLimit[account] = excluded;
704 	}
705 
706     function isExcludedFromMaxTransactionLimit(address account) public view returns(bool) {
707         return _isExcludedFromMaxTransactionLimit[account];
708     }
709 
710 	function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner{
711 		require(_isExcludedFromMaxWalletLimit[account] != excluded, "SOLIDBLOCK: Account is already the value of 'excluded'");
712 		_isExcludedFromMaxWalletLimit[account] = excluded;
713 	}
714 
715     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
716         return _isExcludedFromMaxWalletLimit[account];
717     }
718 
719     function setV1TokenAddress(address _v1TokenAddress) external onlyOwner {
720         v1TokenAddress = _v1TokenAddress;
721     }
722 
723     function migrate(address holder) external onlyOwner {
724         require(v1TokenAddress != address(0), "V1 token address is not set");
725         IERC20 v1Token = IERC20(v1TokenAddress);
726 
727         uint256 v1TokenBalance = v1Token.balanceOf(holder);
728         require(v1TokenBalance > 0, "Holder has no V1 tokens");
729 
730         _transfer(_msgSender(), holder, v1TokenBalance);
731     }
732 
733     function blockAccount(address account) external onlyOwner{
734 		require(!_isBlocked[account], "SOLIDBLOCK: Account is already blocked");
735 		_isBlocked[account] = true;
736 		emit BlockedAccountChange(account, true);
737 	}
738 
739 	function unblockAccount(address account) external onlyOwner{
740 		require(_isBlocked[account], "SOLIDBLOCK: Account is not blcoked");
741 		_isBlocked[account] = false;
742 		emit BlockedAccountChange(account, false);
743 	}
744 
745     function activateTrading() external onlyOwner{
746 		isTradingEnabled = true;
747         if (_launchStartTimestamp == 0) {
748             _launchStartTimestamp = block.timestamp;
749             _launchBlockNumber = block.number;
750         }
751 		emit TradingStatusChange(true, false);
752 	}
753 	function deactivateTrading() external  onlyOwner{
754 		isTradingEnabled = false;
755 		emit TradingStatusChange(false, true);
756 	}
757 	function allowTradingWhenDisabled(address account, bool allowed)  external onlyOwner{
758 		_isAllowedToTradeWhenDisabled[account] = allowed;
759 		emit AllowedWhenTradingDisabledChange(account, allowed);
760 	}
761 
762     function addPair(address _pair) public onlyOwner {
763         _isPair[_pair] = true;
764     }
765 
766     function removePair(address _pair) public onlyOwner {
767         _isPair[_pair] = false;
768     }
769 
770     function isPair(address account) public view returns(bool){
771         return _isPair[account];
772     }
773 
774     function setTaxes(uint256 _rfi, uint256 _treasury, uint256 _development, uint256 __burn) public onlyOwner {
775         taxes.rfi = _rfi;
776         taxes.treasury = _treasury;
777         taxes.development = _development;
778         taxes.burn = __burn;
779         emit FeesChanged();
780     }
781 
782     function setSplitETH(uint256 _treasury, uint256 _development) public onlyOwner {
783         splitETH.treasury = _treasury;
784         splitETH.development = _development;
785         emit FeesChanged();
786     }
787 
788     function _reflectRfi(uint256 rRfi, uint256 tRfi) private {
789         _rTotal -=rRfi;
790         totFeesPaid.rfi += tRfi;
791     }
792 
793     function _takeTreasury(uint256 rTreasury, uint256 tTreasury) private {
794         totFeesPaid.treasury += tTreasury;
795         if(_isExcluded[treasuryAddress]) _tOwned[treasuryAddress] += tTreasury;
796         _rOwned[treasuryAddress] +=rTreasury;
797     }
798     
799     function _takeDevelopment(uint256 rDevelopment, uint256 tDevelopment) private{
800         totFeesPaid.development += tDevelopment;
801         if(_isExcluded[developmentAddress]) _tOwned[developmentAddress] += tDevelopment;
802         _rOwned[developmentAddress] += rDevelopment;
803     }
804 
805     function _takeBurn(uint256 rBurn, uint256 tBurn) private {
806         totFeesPaid.burn += tBurn;
807         if(_isExcluded[developmentAddress])_tOwned[burnAddress] += tBurn;
808         _rOwned[burnAddress] += rBurn;
809     }
810 
811     function _getValues(uint256 tAmount, uint8 takeFee) private returns (valuesFromGetValues memory to_return) {
812         to_return = _getTValues(tAmount, takeFee);
813         (to_return.rAmount, to_return.rTransferAmount, to_return.rRfi, to_return.rTreasury,to_return.rDevelopment, to_return.rBurn) = _getRValues(to_return, tAmount, takeFee, _getRate());
814         return to_return;
815     }
816 
817 
818     function _getTValues(uint256 tAmount, uint8 takeFee) private returns (valuesFromGetValues memory s) {
819 
820         if(takeFee == 0) {
821           s.tTransferAmount = tAmount;
822           return s;
823         } else if(takeFee == 1){
824             s.tRfi = (tAmount*taxes.rfi)/1000;
825             s.tTreasury = (tAmount*taxes.treasury)/1000;
826             s.tDevelopment = tAmount*taxes.development/1000;
827             s.tBurn = tAmount*taxes.burn/1000;
828             ETHAmount.treasury += s.tTreasury*splitETH.treasury/taxes.treasury;
829             ETHAmount.development += s.tTreasury*splitETH.development/taxes.treasury;
830             s.tTransferAmount = tAmount-s.tRfi-s.tDevelopment-s.tTreasury-s.tBurn;
831             return s;
832         } else {
833             s.tRfi = tAmount*taxes.rfi/1000;
834             s.tBurn = tAmount*taxes.burn/1000;
835             s.tTreasury = tAmount*splitETH.development/1000;
836             ETHAmount.development += s.tTreasury;
837             s.tTransferAmount = tAmount-s.tRfi-s.tTreasury-s.tBurn;
838             return s;
839         }
840         
841     }
842 
843     function _getRValues(valuesFromGetValues memory s, uint256 tAmount, uint8 takeFee, uint256 currentRate) private pure returns (uint256 rAmount, uint256 rTransferAmount, uint256 rRfi,uint256 rTreasury,uint256 rDevelopment,uint256 rBurn) {
844         rAmount = tAmount*currentRate;
845 
846         if(takeFee == 0) {
847           return(rAmount, rAmount, 0,0,0,0);
848         }else if(takeFee == 1){
849             rRfi = s.tRfi*currentRate;
850             rTreasury = s.tTreasury*currentRate;
851             rDevelopment = s.tDevelopment*currentRate;
852             rBurn = s.tBurn*currentRate;
853             rTransferAmount =  rAmount-rRfi-rTreasury-rDevelopment-rBurn;
854             return (rAmount, rTransferAmount, rRfi,rTreasury,rDevelopment,rBurn);
855         }
856         else{
857             rRfi = s.tRfi*currentRate;
858             rDevelopment = s.tDevelopment*currentRate;
859             rBurn = s.tBurn*currentRate;
860             rTransferAmount =  rAmount-rRfi-rTreasury-rDevelopment-rBurn;
861             return (rAmount, rTransferAmount, rRfi,rTreasury,rDevelopment,rBurn);
862         }
863 
864     }
865 
866     function _getRate() private view returns(uint256) {
867         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
868         return rSupply/tSupply;
869     }
870 
871     function _getCurrentSupply() private view returns(uint256, uint256) {
872         uint256 rSupply = _rTotal;
873         uint256 tSupply = _tTotal;
874         for (uint256 i = 0; i < _excluded.length; i++) {
875             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
876             rSupply = rSupply-_rOwned[_excluded[i]];
877             tSupply = tSupply-_tOwned[_excluded[i]];
878         }
879 
880         if (rSupply < _rTotal/_tTotal) return (_rTotal, _tTotal);
881         return (rSupply, tSupply);
882     }
883 
884     function _approve(address owner, address spender, uint256 amount) private {
885         require(owner != address(0), "ERC20: approve from the zero address");
886         require(spender != address(0), "ERC20: approve to the zero address");
887         _allowances[owner][spender] = amount;
888         emit Approval(owner, spender, amount);
889     }
890 
891 
892     function _transfer(address from, address to, uint256 amount) private {
893         require(from != address(0), "ERC20: transfer from the zero address");
894         require(to != address(0), "ERC20: transfer to the zero address");
895         require(amount > 0, "Zero amount");
896         require(amount <= balanceOf(from),"Insufficient balance");
897         require(!_isBot[from] && !_isBot[to], "You are a bot");
898 
899         if(!_isAllowedToTradeWhenDisabled[from] && !_isAllowedToTradeWhenDisabled[to]) {
900 			require(isTradingEnabled, "SOLIDBLOCK: Trading is currently disabled.");
901             require(!_isBlocked[to], "SOLIDBLOCK: Account is blocked");
902 			require(!_isBlocked[from], "SOLIDBLOCK: Account is blocked");
903 			if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
904 				require(amount <= maxTxAmount, "SOLIDBLOCK: Buy amount exceeds the maxTxBuyAmount.");
905 			}
906 			if (!_isExcludedFromMaxWalletLimit[to]) {
907 				require((balanceOf(to) + amount) <= maxWalletAmount, "SOLIDBLOCK: Expected wallet amount exceeds the maxWalletAmount.");
908 
909             }
910 		}
911 
912         if (coolDownEnabled) {
913             uint256 timePassed = block.timestamp - _lastTrade[from];
914             require(timePassed > coolDownTime, "You must wait coolDownTime");
915         }
916         
917         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && !swapping) {//check this !swapping
918             if(_isPair[from] || _isPair[to]) {
919                 _tokenTransfer(from, to, amount, 1);
920             } else {
921                 _tokenTransfer(from, to, amount, 2);
922             }
923         } else {
924             _tokenTransfer(from, to, amount, 0);
925         }
926 
927         _lastTrade[from] = block.timestamp;
928         
929         if(!swapping && from != pair && to != pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
930             address[] memory path = new address[](3);
931                 path[0] = address(this);
932                 path[1] = router.WETH();
933                 path[2] = USDT;
934             uint _amount = router.getAmountsOut(balanceOf(address(this)), path)[2];
935             if(_amount >= swapTokensAtAmount) swapTokensForETH(balanceOf(address(this)));
936         }
937     }
938 
939     //this method is responsible for taking all fee, if takeFee is true
940     function _tokenTransfer(address sender, address recipient, uint256 tAmount, uint8 takeFee) private {
941 
942         valuesFromGetValues memory s = _getValues(tAmount, takeFee);
943 
944         if (_isExcluded[sender] ) {  //from excluded
945                 _tOwned[sender] = _tOwned[sender] - tAmount;
946         }
947         if (_isExcluded[recipient]) { //to excluded
948                 _tOwned[recipient] = _tOwned[recipient] + s.tTransferAmount;
949         }
950 
951         _rOwned[sender] = _rOwned[sender]-s.rAmount;
952         _rOwned[recipient] = _rOwned[recipient]+s.rTransferAmount;
953         
954         if(s.rRfi > 0 || s.tRfi > 0) _reflectRfi(s.rRfi, s.tRfi);
955         if(s.rTreasury > 0 || s.tTreasury > 0){
956             _takeTreasury(s.rTreasury, s.tTreasury);
957             emit Transfer(sender, treasuryAddress, s.tTreasury);
958         }
959         if(s.rDevelopment > 0 || s.tDevelopment > 0){
960             _takeDevelopment(s.rDevelopment, s.tDevelopment);
961             emit Transfer(sender, developmentAddress, s.tDevelopment);
962         }
963         if(s.rBurn > 0 || s.tBurn > 0){
964             _takeBurn(s.rBurn, s.tBurn);
965             emit Transfer(sender, burnAddress, s.tBurn);
966         }
967         
968         emit Transfer(sender, recipient, s.tTransferAmount);
969         
970     }
971 
972     function swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
973         // generate the uniswap pair path of token -> weth -> USDT
974         address[] memory path = new address[](3);
975             path[0] = address(this);
976             path[1] = router.WETH();
977             path[2] = USDT;
978 
979         _approve(address(this), address(router), tokenAmount);
980         // make the swap
981         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
982             tokenAmount,
983             0, // accept any amount of ETH
984             path,
985             address(this),
986             block.timestamp
987         );
988 
989         IERC20 usdt = IERC20(USDT);
990         uint256 usdtBalance = usdt.balanceOf(address(this));
991 
992         usdt.approve(address(this), usdtBalance);
993 
994         uint256 usdtTreasuryAmount = (ETHAmount.treasury * usdtBalance) / tokenAmount;
995         uint256 usdtDevelopmentAmount = (ETHAmount.development * usdtBalance) / tokenAmount;
996 
997         usdt.transfer(treasuryAddress, usdtTreasuryAmount);
998         usdt.transfer(developmentAddress, usdtDevelopmentAmount);
999 
1000         ETHAmount.treasury = 0;
1001         ETHAmount.development = 0;
1002 
1003         /*
1004         (bool success, ) = treasuryAddress.call{value: (ETHAmount.treasury * usdt.balanceOf(address(this)))/tokenAmount}("");
1005         require(success, 'ETH_TRANSFER_FAILED');
1006         ETHAmount.treasury = 0;
1007 
1008         (success, ) = developmentAddress.call{value: (ETHAmount.development * usdt.balanceOf(address(this)))/tokenAmount}("");
1009         require(success, 'ETH_TRANSFER_FAILED');
1010         ETHAmount.development = 0;
1011         */
1012     }
1013 
1014     function updateTreasuryWallet(address newWallet) external onlyOwner addressValidation(newWallet) {
1015         require(treasuryAddress != newWallet, 'SOLIDBLOCK: Wallet already set');
1016         treasuryAddress = newWallet;
1017         _isExcludedFromFee[treasuryAddress];
1018     }
1019 
1020     function updateDevelopmentWallet(address newWallet) external onlyOwner addressValidation(newWallet) {
1021         require(developmentAddress != newWallet, 'SOLIDBLOCK: Wallet already set');
1022         developmentAddress = newWallet;
1023         _isExcludedFromFee[developmentAddress];
1024     }
1025 
1026     function updateStableCoin(address _usdt) external onlyOwner addressValidation(_usdt) {
1027         require(USDT != _usdt, 'SOLIDBLOCK: Wallet already set');
1028         USDT = _usdt;
1029     }
1030 
1031     function updateMaxTxAmt(uint256 amount) external onlyOwner{
1032         require(amount >= 100);
1033         maxTxAmount = amount * 10**_decimals;
1034     }
1035 
1036     function updateMaxWalletAmt(uint256 amount) external onlyOwner{
1037         require(amount >= 100);
1038         maxWalletAmount = amount * 10**_decimals;
1039     }
1040 
1041     function updateSwapTokensAtAmount(uint256 amount) external onlyOwner{
1042         require(amount > 0);
1043         swapTokensAtAmount = amount * 10**6;
1044     }
1045 
1046     function updateCoolDownSettings(bool _enabled, uint256 _timeInSeconds) external onlyOperatorOrOwner{
1047         coolDownEnabled = _enabled;
1048         coolDownTime = _timeInSeconds * 1 seconds;
1049     }
1050 
1051     function setAntibot(address account, bool state) external onlyOwner{
1052         require(_isBot[account] != state, 'SOLIDBLOCK: Value already set');
1053         _isBot[account] = state;
1054     }
1055     
1056     function bulkAntiBot(address[] memory accounts, bool state) external onlyOwner {
1057         require(accounts.length <= 100, "SOLIDBLOCK: Invalid");
1058         for(uint256 i = 0; i < accounts.length; i++){
1059             _isBot[accounts[i]] = state;
1060         }
1061     }
1062     
1063     function updateRouterAndPair(address newRouter, address newPair) external onlyOwner {
1064         router = IRouter(newRouter);
1065         pair = newPair;
1066         addPair(pair);
1067     }
1068 
1069     function updateRouterWithoutPair(address newRouter) external onlyOwner {
1070     require(newRouter != address(0), "Invalid router address");
1071 
1072     router = IRouter(newRouter);
1073 
1074     address newPair = IFactory(router.factory()).createPair(address(this), router.WETH());
1075     require(newPair != address(0), "Failed to create new pair");
1076 
1077     pair = newPair;
1078     addPair(pair);
1079     }
1080     
1081     function isBot(address account) public view returns(bool){
1082         return _isBot[account];
1083     }
1084     
1085     function airdropTokens(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
1086         require(recipients.length == amounts.length,"Invalid size");
1087          address sender = msg.sender;
1088 
1089         for(uint256 i; i<recipients.length; i++){
1090             address recipient = recipients[i];
1091             uint256 rAmount = amounts[i]*_getRate();
1092             _rOwned[sender] = _rOwned[sender]- rAmount;
1093             _rOwned[recipient] = _rOwned[recipient] + rAmount;
1094             emit Transfer(sender, recipient, amounts[i]);
1095         }
1096     }
1097 
1098     //Use this in case ETH are sent to the contract by mistake
1099     function rescueETH(uint256 weiAmount) external onlyOwner{
1100         require(address(this).balance >= weiAmount, "insufficient ETH balance");
1101         payable(owner()).transfer(weiAmount);
1102     }
1103     
1104     // Function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
1105     // Owner cannot transfer out catecoin from this smart contract
1106     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1107         IERC20(_tokenAddr).transfer(_to, _amount);
1108     }
1109 
1110     receive() external payable {
1111     }
1112 }