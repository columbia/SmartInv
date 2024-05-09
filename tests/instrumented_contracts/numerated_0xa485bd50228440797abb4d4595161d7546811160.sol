1 pragma solidity ^0.4.23;
2 
3 
4 contract AntiERC20Sink {
5     address public deployer;
6     constructor() public { deployer = msg.sender; }
7     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public {
8         require(msg.sender == deployer);
9         _token.transfer(_to, _amount);
10     }
11 }
12 
13 
14 library SafeMath {
15     function plus(uint256 _a, uint256 _b) internal pure returns (uint256) {
16         uint256 c = _a + _b;
17         assert(c >= _a);
18         return c;
19     }
20 
21     function plus(int256 _a, int256 _b) internal pure returns (int256) {
22         int256 c = _a + _b;
23         assert((_b >= 0 && c >= _a) || (_b < 0 && c < _a));
24         return c;
25     }
26 
27     function minus(uint256 _a, uint256 _b) internal pure returns (uint256) {
28         assert(_a >= _b);
29         return _a - _b;
30     }
31 
32     function minus(int256 _a, int256 _b) internal pure returns (int256) {
33         int256 c = _a - _b;
34         assert((_b >= 0 && c <= _a) || (_b < 0 && c > _a));
35         return c;
36     }
37 
38     function times(uint256 _a, uint256 _b) internal pure returns (uint256) {
39         if (_a == 0) {
40             return 0;
41         }
42         uint256 c = _a * _b;
43         assert(c / _a == _b);
44         return c;
45     }
46 
47     function times(int256 _a, int256 _b) internal pure returns (int256) {
48         if (_a == 0) {
49             return 0;
50         }
51         int256 c = _a * _b;
52         assert(c / _a == _b);
53         return c;
54     }
55 
56     function toInt256(uint256 _a) internal pure returns (int256) {
57         assert(_a <= 2 ** 255);
58         return int256(_a);
59     }
60 
61     function toUint256(int256 _a) internal pure returns (uint256) {
62         assert(_a >= 0);
63         return uint256(_a);
64     }
65 
66     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
67         return _a / _b;
68     }
69 
70     function div(int256 _a, int256 _b) internal pure returns (int256) {
71         return _a / _b;
72     }
73 }
74 
75 
76 /*
77     ERC20 Standard Token interface
78 */
79 contract IERC20Token {
80     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
81     function name() public constant returns (string) {}
82     function symbol() public constant returns (string) {}
83     function decimals() public constant returns (uint8) {}
84     function totalSupply() public constant returns (uint256) {}
85     function balanceOf(address _owner) public constant returns (uint256) { _owner; }
86     function allowance(address _owner, address _spender) public constant returns (uint256) { _owner; _spender; }
87 
88     function transfer(address _to, uint256 _value) public returns (bool success);
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
90     function approve(address _spender, uint256 _value) public returns (bool success);
91 }
92 
93 
94 /*
95     Owned contract interface
96 */
97 contract IOwned {
98     // this function isn't abstract since the compiler emits automatically generated getter functions as external
99     function owner() public constant returns (address) {}
100 
101     function transferOwnership(address _newOwner) public;
102     function acceptOwnership() public;
103     function setOwner(address _newOwner) public;
104 }
105 
106 
107 
108 
109 
110 contract Vault {
111     PegInstance public pegInstance;
112     address public owner;
113     uint256 public totalBorrowed;
114     uint256 public rawDebt;
115     uint256 public timestamp;
116 
117     constructor(PegInstance _pegInstance, address _owner) public {
118         pegInstance = _pegInstance;
119         owner = _owner;
120     }
121 
122     modifier authOnly() {
123         require(pegInstance.authorized(msg.sender));
124         _;
125     }
126 
127     function setOwner(address _newOwner) public authOnly {
128         owner = _newOwner;
129     }
130 
131     function setRawDebt(uint _newRawDebt) public authOnly {
132         rawDebt = _newRawDebt;
133     }
134 
135     function setTotalBorrowed(uint _totalBorrowed) public authOnly {
136         totalBorrowed = _totalBorrowed;
137     }
138 
139     function setTimestamp(uint256 _timestamp) public authOnly {
140         timestamp = _timestamp;
141     }
142 
143     function payoutPEG(address _to, uint _amount) public authOnly {
144         pegInstance.pegNetworkToken().transfer(_to, _amount);
145     }
146 
147     function burnPEG(uint _amount) public authOnly {
148         pegInstance.pegNetworkToken().destroy(address(this), _amount);
149     }
150 
151     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public authOnly {
152         _token.transfer(_to, _amount);
153     }
154 }
155 
156 contract IPegOracle {
157     function getValue() public view returns (uint256);
158 }
159 
160 
161 
162 
163 
164 
165 
166 /*
167     Smart Token interface
168 */
169 contract ISmartToken is IOwned, IERC20Token {
170     function disableTransfers(bool _disable) public;
171     function issue(address _to, uint256 _amount) public;
172     function destroy(address _from, uint256 _amount) public;
173 }
174 
175 
176 
177 
178 
179 
180 
181 
182 
183 contract PegLogic is AntiERC20Sink {
184 
185     using SafeMath for uint256;
186     using SafeMath for int256;
187     ISmartToken public pegNetworkToken;
188     PegInstance public pegInstance;
189 
190     constructor(ISmartToken _pegNetworkToken, PegInstance _pegInstance) public {
191         pegNetworkToken = _pegNetworkToken;
192         pegInstance = _pegInstance;
193     }
194 
195     modifier vaultExists(Vault _vault) {
196         require(pegInstance.vaultExists(_vault));
197         _;
198     }
199 
200     modifier authOnly() {
201         require(pegInstance.authorized(msg.sender));
202         _;
203     }
204 
205     function newVault() public returns (Vault) {
206         // pegNetworkToken.destroy(msg.sender, 1e18); charge a fee?
207         Vault vault = new Vault(pegInstance, msg.sender);
208         pegInstance.addNewVault(vault, msg.sender);
209         return vault;
210     }
211 
212     function getTotalCredit(Vault _vault) public view vaultExists(_vault) returns (int256) {
213         uint256 oraclePrice = pegInstance.oracle().getValue();
214         return (pegNetworkToken.balanceOf(_vault).times(oraclePrice).times(pegInstance.maxBorrowLTV()) / 1e12).toInt256();
215     }
216 
217     function getAvailableCredit(Vault _vault) public view returns (int256) {
218         return getTotalCredit(_vault).minus(actualDebt(_vault).toInt256());
219     }
220 
221     function borrow(Vault _vault, uint256 _amount) public vaultExists(_vault) {
222         require(_vault.owner() == msg.sender && _amount.toInt256() <= getAvailableCredit(_vault));
223         _vault.setRawDebt(_vault.rawDebt().plus(debtActualToRaw(_amount)));
224         _vault.setTotalBorrowed(_vault.totalBorrowed().plus(_amount));
225         pegInstance.debtToken().issue(msg.sender, _amount);
226         pegInstance.emitBorrow(_vault, _amount);
227     }
228 
229     function repay(Vault _vault, uint256 _amount) public vaultExists(_vault) {
230         uint amountToRepay = _amount;
231         if (actualDebt(_vault) < _amount) amountToRepay = actualDebt(_vault);
232         pegInstance.debtToken().destroy(msg.sender, amountToRepay);
233         _vault.setRawDebt(_vault.rawDebt().minus(debtActualToRaw(amountToRepay)));
234         _vault.setTotalBorrowed(_vault.totalBorrowed().minus(amountToRepay));
235         pegInstance.emitRepay(_vault, amountToRepay);
236     }
237 
238     function requiredCollateral(Vault _vault) public view vaultExists(_vault) returns (uint256) {
239         return actualDebt(_vault).times(1e12) / pegInstance.oracle().getValue() / pegInstance.maxBorrowLTV();
240     }
241 
242     function getExcessCollateral(Vault _vault) public view returns (int256) {
243         return int(pegNetworkToken.balanceOf(_vault)).minus(int(requiredCollateral(_vault)));
244     }
245 
246     function liquidate(Vault _vault) public {
247         require(actualDebt(_vault) > 0);
248         uint requiredPEG = actualDebt(_vault).times(1e12) / pegInstance.oracle().getValue() / pegInstance.liquidationRatio();
249         require(pegNetworkToken.balanceOf(_vault) < requiredPEG);
250         require(pegInstance.debtToken().balanceOf(msg.sender) >= actualDebt(_vault));
251         pegInstance.debtToken().destroy(msg.sender, actualDebt(_vault));
252         _vault.setRawDebt(0);
253         _vault.setOwner(msg.sender);
254     }
255 
256     function reportPriceToTargetValue(bool _aboveValue) public authOnly {
257         if(_aboveValue) {
258             pegInstance.setDebtScalingRate(pegInstance.debtScalingPerBlock().plus(1e8));
259             pegInstance.setDebtTokenScalingRate(pegInstance.debtTokenScalingPerBlock().plus(1e8));
260         }else{
261             pegInstance.setDebtScalingRate(pegInstance.debtScalingPerBlock().minus(1e8));
262             pegInstance.setDebtTokenScalingRate(pegInstance.debtTokenScalingPerBlock().minus(1e8));
263         }
264     }
265 
266     function debtRawToActual(uint256 _raw) public view returns(uint256) {
267         return _raw.times(1e18) / pegInstance.debtScalingFactor();
268     }
269 
270     function debtActualToRaw(uint256 _actual) public view returns(uint256) {
271         return _actual.times(pegInstance.debtScalingFactor()) / 1e18;
272     }
273 
274     function withdrawExcessCollateral(Vault _vault, address _to, uint256 _amount) public {
275         require(msg.sender == _vault.owner());
276         require(_amount.toInt256() <= getExcessCollateral(_vault));
277         _vault.payoutPEG(_to, _amount);
278         pegInstance.emitWithdraw(_vault, _amount);
279     }
280 
281     function actualDebt(Vault _vault) public view returns(uint) {
282         return debtRawToActual(_vault.rawDebt());
283     }
284 }
285 
286 
287 contract PegInstance {
288 
289     using SafeMath for uint256;
290     using SafeMath for int256;
291 
292     ISmartToken public pegNetworkToken;
293     uint8 public constant version = 0;
294     IPegOracle public oracle;
295     DebtToken public debtToken;
296     PegLogic public pegLogic;
297     address[] public vaults;
298     mapping (address => bool) public vaultExists;
299     mapping (address => bool) public authorized;
300     uint32 public liquidationRatio = 850000;
301     uint32 public maxBorrowLTV = 100000;
302 
303     uint256 public lastDebtTokenScalingFactor = 1e18;
304     uint256 public lastDebtTokenScalingRetarget;
305     int256 public debtTokenScalingPerBlock;
306 
307     uint256 public lastDebtScalingFactor = 1e18;
308     uint256 public lastDebtScalingRetarget;
309     int256 public debtScalingPerBlock;
310 
311     uint256 public amountMinted;
312 
313     event LiquidateVault(address indexed _vault);
314     event Borrow(address indexed _vault, uint256 amount);
315     event Repay(address indexed _vault, uint256 amount);
316     event Withdraw(address indexed _vault, uint256 amount);
317     event LiquidationRatioUpdate(int _old, int _new);
318     event MaxBorrowUpdate(uint32 _old, uint32 _new);
319     event DebtTokenScalingRateUpdate(int _old, int _new);
320     event DebtScalingRateUpdate(int _old, int _new);
321     event NewVault(address indexed _vault, address indexed _vaultOwner);
322     event LogicUpgrade(address _old, address _new);
323     event DebtTokenUpgrade(address _old, address _new);
324     event OracleUpgrade(address _old, address _new);
325     event Authorize(address _address, bool _auth);
326 
327     constructor(ISmartToken _pegNetworkToken) public {
328         pegNetworkToken = _pegNetworkToken;
329         authorized[msg.sender] = true;
330     }
331 
332     modifier authOnly() {
333         require(authorized[msg.sender] == true);
334         _;
335     }
336 
337     function setDebtToken(DebtToken _debtToken) public authOnly {
338         emit DebtTokenUpgrade(address(debtToken), address(_debtToken));
339         debtToken = _debtToken;
340     }
341 
342     function setOracle(IPegOracle _oracle) public authOnly {
343         emit OracleUpgrade(address(oracle), address(_oracle));
344         oracle = _oracle;
345     }
346 
347     function setPegLogic(PegLogic _pegLogic) public authOnly {
348         emit LogicUpgrade(address(pegLogic), address(_pegLogic));
349         authorized[address(_pegLogic)] = true;
350         authorized[address(pegLogic)] = false;
351         pegLogic = _pegLogic;
352     }
353 
354     function authorize(address _address, bool _auth) public authOnly {
355         emit Authorize(_address, _auth);
356         authorized[_address] = _auth;
357     }
358 
359     function setLiquidationRatio(uint32 _liquidationRatio) public authOnly {
360         emit LiquidationRatioUpdate(liquidationRatio, _liquidationRatio);
361         liquidationRatio = _liquidationRatio;
362     }
363 
364     function setMaxBorrowLTV(uint32 _maxBorrowLTV) public authOnly {
365         emit MaxBorrowUpdate(maxBorrowLTV, _maxBorrowLTV);
366         maxBorrowLTV = _maxBorrowLTV;
367     }
368 
369     function setDebtTokenScalingRate(int256 _debtTokenScalingPerBlock) public authOnly {
370         emit DebtTokenScalingRateUpdate(debtTokenScalingPerBlock, _debtTokenScalingPerBlock);
371         lastDebtTokenScalingFactor = debtTokenScalingFactor();
372         lastDebtTokenScalingRetarget = block.number;
373         debtTokenScalingPerBlock = _debtTokenScalingPerBlock;
374     }
375 
376     function setDebtScalingRate(int256 _debtScalingPerBlock) public authOnly {
377         emit DebtScalingRateUpdate(debtScalingPerBlock, _debtScalingPerBlock);
378         lastDebtScalingFactor = debtScalingFactor();
379         lastDebtScalingRetarget = block.number;
380         debtScalingPerBlock = _debtScalingPerBlock;
381     }
382 
383     function setAmountMinted(uint _amountMinted) public authOnly {
384         amountMinted = _amountMinted;
385     }
386 
387     function addNewVault(Vault _vault, address _vaultOwner) public authOnly {
388         emit NewVault(address(_vault), _vaultOwner);
389         vaults.push(_vault);
390         vaultExists[_vault] = true;
391     }
392 
393     function emitBorrow(Vault _vault, uint256 _amount) public authOnly {
394         emit Borrow(address(_vault), _amount);
395     }
396 
397     function emitRepay(Vault _vault, uint256 _amount) public authOnly {
398         emit Repay(address(_vault), _amount);
399     }
400 
401     function emitWithdraw(Vault _vault, uint256 _amount) public authOnly {
402         emit Withdraw(address(_vault), _amount);
403     }
404 
405     function emitLiquidateVault(Vault _vault) public authOnly {
406         emit LiquidateVault(address(_vault));
407     }
408 
409     function getVaults() public view returns (address[]) {
410         return vaults;
411     }
412 
413     function debtTokenScalingFactor() public view returns (uint) {
414         return uint(int(lastDebtTokenScalingFactor).plus(debtTokenScalingPerBlock.times(int(block.number.minus(lastDebtTokenScalingRetarget)))));
415     }
416 
417     function debtScalingFactor() public view returns (uint) {
418         return uint(int(lastDebtScalingFactor).plus(debtScalingPerBlock.times(int(block.number.minus(lastDebtScalingRetarget)))));
419     }
420 
421     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public authOnly {
422         _token.transfer(_to, _amount);
423     }
424 }
425 
426 
427 
428 
429 
430 contract DebtToken is IERC20Token {
431 
432     using SafeMath for uint256;
433 
434     string public name;
435     string public symbol;
436     uint8 public decimals = 18;
437 
438     PegInstance public pegInstance;
439 
440     uint256 public rawTotalSupply;
441     mapping (address => uint256) public rawBalance;
442     mapping (address => mapping (address => uint256)) public rawAllowance;
443 
444     event Transfer(address indexed from, address indexed to, uint256 amount);
445     event Approval(address indexed owner, address indexed spender, uint256 amount);
446     event Issuance(uint256 amount);
447     event Destruction(uint256 amount);
448 
449     constructor(string _name, string _symbol, PegInstance _pegInstance) public {
450         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
451         name = _name;
452         symbol = _symbol;
453         pegInstance = _pegInstance;
454     }
455 
456     modifier validAddress(address _address) {
457         require(_address != address(0));
458         _;
459     }
460 
461     modifier authOnly() {
462         require(pegInstance.authorized(msg.sender));
463         _;
464     }
465 
466     function rawToActual(uint256 _raw) public view returns(uint256) {
467         return _raw.times(1e18) / pegInstance.debtTokenScalingFactor();
468     }
469 
470     function actualToRaw(uint256 _actual) public view returns(uint256) {
471         return _actual.times(pegInstance.debtTokenScalingFactor()) / 1e18;
472     }
473 
474     function balanceOf(address _address) public view returns(uint256) {
475         return rawToActual(rawBalance[_address]);
476     }
477 
478     function totalSupply() public view returns (uint256) {
479         return rawToActual(rawTotalSupply);
480     }
481 
482     function allowance(address _owner, address _spender) public view returns (uint256) {
483         return rawToActual(rawAllowance[_owner][_spender]);
484     }
485 
486     function transfer(address _to, uint256 _amount) public validAddress(_to) returns (bool) {
487         rawBalance[msg.sender] = rawBalance[msg.sender].minus(actualToRaw(_amount));
488         rawBalance[_to] = rawBalance[_to].plus(actualToRaw(_amount));
489         emit Transfer(msg.sender, _to, _amount);
490         return true;
491     }
492 
493     function transferFrom(address _from, address _to, uint256 _amount) public validAddress(_from) validAddress(_to) returns (bool) {
494         rawAllowance[_from][msg.sender] = rawAllowance[_from][msg.sender].minus(actualToRaw(_amount));
495         rawBalance[_from] = rawBalance[_from].minus(actualToRaw(_amount));
496         rawBalance[_to] = rawBalance[_to].plus(actualToRaw(_amount));
497         emit Transfer(_from, _to, _amount);
498         return true;
499     }
500 
501     function approve(address _spender, uint256 _amount) public validAddress(_spender) returns (bool) {
502         require(_amount == 0 || rawAllowance[msg.sender][_spender] == 0);
503         rawAllowance[msg.sender][_spender] = actualToRaw(_amount);
504         emit Approval(msg.sender, _spender, _amount);
505         return true;
506     }
507 
508     function issue(address _to, uint256 _amount) public validAddress(_to) authOnly {
509         rawTotalSupply = rawTotalSupply.plus(actualToRaw(_amount));
510         rawBalance[_to] = rawBalance[_to].plus(actualToRaw(_amount));
511         emit Issuance(_amount);
512         emit Transfer(this, _to, _amount);
513     }
514 
515     function destroy(address _from, uint256 _amount) public validAddress(_from) authOnly {
516         rawBalance[_from] = rawBalance[_from].minus(actualToRaw(_amount));
517         rawTotalSupply = rawTotalSupply.minus(actualToRaw(_amount));
518         emit Transfer(_from, this, _amount);
519         emit Destruction(_amount);
520     }
521 
522     function setName(string _name) public authOnly {
523         name = _name;
524     }
525 
526     function setSymbol(string _symbol) public authOnly {
527         symbol = _symbol;
528     }
529 
530     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) validAddress(_to) public {
531         require(pegInstance.authorized(msg.sender));
532         _token.transfer(_to, _amount);
533     }
534 }