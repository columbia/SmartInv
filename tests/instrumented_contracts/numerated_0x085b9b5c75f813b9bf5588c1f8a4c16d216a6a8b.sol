1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9     function _msgData() internal view virtual returns (bytes memory) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 interface IBEP20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         return mod(a, b, "SafeMath: modulo by zero");
58     }
59     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b != 0, errorMessage);
61         return a % b;
62     }
63 }
64  
65 library Address {
66     function isContract(address account) internal view returns (bool) {
67         uint256 size;
68         assembly { size := extcodesize(account) }
69         return size > 0;
70     }
71     function sendValue(address payable recipient, uint256 amount) internal {
72         require(address(this).balance >= amount, "Address: insufficient balance");
73         (bool success, ) = recipient.call{ value: amount }("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
77       return functionCall(target, data, "Address: low-level call failed");
78     }
79     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
80         return functionCallWithValue(target, data, 0, errorMessage);
81     }
82     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
83         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
84     }
85     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
86         require(address(this).balance >= value, "Address: insufficient balance for call");
87         require(isContract(target), "Address: call to non-contract");
88         (bool success, bytes memory returndata) = target.call{ value: value }(data);
89         return _verifyCallResult(success, returndata, errorMessage);
90     }
91     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
92         return functionStaticCall(target, data, "Address: low-level static call failed");
93     }
94     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
95         require(isContract(target), "Address: static call to non-contract");
96         (bool success, bytes memory returndata) = target.staticcall(data);
97         return _verifyCallResult(success, returndata, errorMessage);
98     }
99     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
100         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
101     }
102     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
103         require(isContract(target), "Address: delegate call to non-contract");
104         (bool success, bytes memory returndata) = target.delegatecall(data);
105         return _verifyCallResult(success, returndata, errorMessage);
106     }
107     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
108         if (success) {
109             return returndata;
110         } else {
111             if (returndata.length > 0) {
112                 assembly {
113                     let returndata_size := mload(returndata)
114                     revert(add(32, returndata), returndata_size)
115                 }
116             } else {
117                 revert(errorMessage);
118             }
119         }
120     }
121 }
122 
123 contract Ownable is Context {
124     address private _owner;
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126     constructor () {
127         address msgSender = _msgSender();
128         _owner = msgSender;
129         emit OwnershipTransferred(address(0), msgSender);
130     }
131     function owner() public view returns (address) {
132         return _owner;
133     }
134     modifier onlyOwner() {
135         require(_owner == _msgSender(), "Ownable: caller is not the owner");
136         _;
137     }
138     function renounceOwnership() public virtual onlyOwner {
139         emit OwnershipTransferred(_owner, address(0));
140         _owner = address(0);
141     }
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(newOwner != address(0), "Ownable: new owner is the zero address");
144         emit OwnershipTransferred(_owner, newOwner);
145         _owner = newOwner;
146     }
147 }
148  
149 contract SHIBCHU is Context, IBEP20, Ownable {
150     using SafeMath for uint256;
151     using Address for address;
152     mapping (address => uint256) private _rOwned;
153     mapping (address => uint256) private _tOwned;
154     mapping (address => mapping (address => uint256)) private _allowances;
155     mapping (address => bool) private _isExcluded;
156     mapping (address => bool) private _isDev;
157      mapping (address => bool) private _isBurn;
158     address[] private _excluded;
159     address[] private _dev;
160     address[] private _burn;
161     string  private constant _NAME = 'Shiba Chulo';
162     string  private constant _SYMBOL = 'SHIBCHU';
163     uint8   private constant _DECIMALS = 9;
164     uint256 private constant _MAX = ~uint256(0);
165     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
166     uint256 private constant _GRANULARITY = 100;
167     uint256 private _tTotal = 1000000000000 * _DECIMALFACTOR;
168     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
169     uint256 private _tFeeTotal;
170     uint256 private _tBurnTotal;
171     uint256 private _tDevTotal;
172     uint256 private _TAX_FEE = 150; // 1.5% BACK TO HOLDERS
173     uint256 private _BURN_FEE = 200; // 2% BURNED
174     uint256 private _DEV_FEE = 150; // 1.5% TO DEV/MARKETING WALLET
175     uint256 private constant _MAX_TX_SIZE = 10000000000 * _DECIMALFACTOR;
176     uint256 private ORIG_TAX_FEE = _TAX_FEE;
177     uint256 private ORIG_BURN_FEE = _BURN_FEE;
178     uint256 private ORIG_DEV_FEE = _DEV_FEE;
179  
180     constructor () {
181         _rOwned[_msgSender()] = _rTotal;
182         emit Transfer(address(0), _msgSender(), _tTotal);
183     }
184  
185     function name() public pure returns (string memory) {
186         return _NAME;
187     }
188     function symbol() public pure returns (string memory) {
189         return _SYMBOL;
190     }
191     function decimals() public pure returns (uint8) {
192         return _DECIMALS;
193     }
194     function totalSupply() public view override returns (uint256) {
195         return _tTotal;
196     }
197     function balanceOf(address account) public view override returns (uint256) {
198         if (_isExcluded[account]) return _tOwned[account];
199         return tokenFromReflection(_rOwned[account]);
200     }
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
215         return true;
216     }
217     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
219         return true;
220     }
221     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
222         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
223         return true;
224     }
225     function isExcluded(address account) public view returns (bool) {
226         return _isExcluded[account];
227     }
228     function isDev(address account) public view returns (bool) {
229         return _isDev[account];
230     }
231     function totalFees() public view returns (uint256) {
232         return _tFeeTotal;
233     }
234     function totalBurn() public view returns (uint256) {
235         return _tBurnTotal;
236     }
237     function totalDev() public view returns (uint256) {
238         return _tDevTotal;
239     }
240     function deliver(uint256 tAmount) public {
241         address sender = _msgSender();
242         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
243         (uint256 rAmount,,,,,,) = _getValues(tAmount);
244         _rOwned[sender] = _rOwned[sender].sub(rAmount);
245         _rTotal = _rTotal.sub(rAmount);
246         _tFeeTotal = _tFeeTotal.add(tAmount);
247     }
248     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
249         require(tAmount <= _tTotal, "Amount must be less than supply");
250         if (!deductTransferFee) {
251             (uint256 rAmount,,,,,,) = _getValues(tAmount);
252             return rAmount;
253         } else {
254             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
255             return rTransferAmount;
256         }
257     }
258     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
259         require(rAmount <= _rTotal, "Amount must be less than total reflections");
260         uint256 currentRate =  _getRate();
261         return rAmount.div(currentRate);
262     }
263     function excludeAccount(address account) external onlyOwner() {
264         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude DEX router.');
265         require(!_isExcluded[account], "Account is already excluded");
266         if(_rOwned[account] > 0) {
267             _tOwned[account] = tokenFromReflection(_rOwned[account]);
268         }
269         _isExcluded[account] = true;
270         _excluded.push(account);
271     }
272     function includeAccount(address account) external onlyOwner() {
273         require(_isExcluded[account], "Account is already excluded");
274         for (uint256 i = 0; i < _excluded.length; i++) {
275             if (_excluded[i] == account) {
276                 _excluded[i] = _excluded[_excluded.length - 1];
277                 _tOwned[account] = 0;
278                 _isExcluded[account] = false;
279                 _excluded.pop();
280                 break;
281             }
282         }
283     }
284     function setAsDevAccount(address account) external onlyOwner() {
285         require(!_isDev[account], "Account is already dev account");
286         _isDev[account] = true;
287         _dev.push(account);
288     }
289     function setAsBurnAccount(address account) external onlyOwner() {
290         require(!_isBurn[account], "Account is already burning account");
291         _isBurn[account] = true;
292         _burn.push(account);
293     }
294     function _setTaxFee(uint256 taxFee) external onlyOwner() {
295         _TAX_FEE = taxFee* 100;
296     }
297     function _setBurnFee(uint256 burnFee) external onlyOwner() {
298         _BURN_FEE = burnFee* 100;
299     }
300     function _setDevFee(uint256 devFee) external onlyOwner() {
301         _DEV_FEE = devFee* 100;
302     }
303     function _approve(address owner, address spender, uint256 amount) private {
304         require(owner != address(0), "BEP20: approve from the zero address");
305         require(spender != address(0), "BEP20: approve to the zero address");
306         _allowances[owner][spender] = amount;
307         emit Approval(owner, spender, amount);
308     }
309     function _transfer(address sender, address recipient, uint256 amount) private {
310         require(sender != address(0), "BEP20: transfer from the zero address");
311         require(recipient != address(0), "BEP20: transfer to the zero address");
312         require(amount > 0, "Transfer amount must be greater than zero");
313         bool takeFee = true;
314         if (_isDev[sender] || _isDev[recipient] || _isExcluded[recipient]) {
315             takeFee = false;
316         }
317         if (!takeFee) removeAllFee();
318         if (sender != owner() && recipient != owner())
319             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
320         if (_isExcluded[sender] && !_isExcluded[recipient]) {
321             _transferFromExcluded(sender, recipient, amount);
322         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
323             _transferToExcluded(sender, recipient, amount);
324         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
325             _transferStandard(sender, recipient, amount);
326         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
327             _transferBothExcluded(sender, recipient, amount);
328         } else {
329             _transferStandard(sender, recipient, amount);
330         }
331         if (!takeFee) restoreAllFee();
332     }
333     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
334         uint256 currentRate =  _getRate();
335         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tDev) = _getValues(tAmount);
336         uint256 rBurn =  tBurn.mul(currentRate);
337         uint256 rDev = tDev.mul(currentRate);
338         _standardTransferContent(sender, recipient, rAmount, rTransferAmount);
339         _sendToDev(tDev, sender);
340         _sendToBurn(tBurn, sender);
341         _reflectFee(rFee, rBurn, rDev, tFee, tBurn, tDev);
342         emit Transfer(sender, recipient, tTransferAmount);
343     }
344     function _standardTransferContent(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
345         _rOwned[sender] = _rOwned[sender].sub(rAmount);
346         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
347     }
348     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
349         uint256 currentRate =  _getRate();
350         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tDev) = _getValues(tAmount);
351         uint256 rBurn =  tBurn.mul(currentRate);
352         uint256 rDev = tDev.mul(currentRate);
353         _excludedFromTransferContent(sender, recipient, tTransferAmount, rAmount, rTransferAmount);
354         _sendToDev(tDev, sender);
355         _sendToBurn(tBurn, sender);
356         _reflectFee(rFee, rBurn, rDev, tFee, tBurn, tDev);
357         emit Transfer(sender, recipient, tTransferAmount);
358     }
359     function _excludedFromTransferContent(address sender, address recipient, uint256 tTransferAmount, uint256 rAmount, uint256 rTransferAmount) private {
360         _rOwned[sender] = _rOwned[sender].sub(rAmount);
361         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
362         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
363     }
364     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
365         uint256 currentRate =  _getRate();
366         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tDev) = _getValues(tAmount);
367         uint256 rBurn =  tBurn.mul(currentRate);
368         uint256 rDev = tDev.mul(currentRate);
369         _excludedToTransferContent(sender, recipient, tAmount, rAmount, rTransferAmount);
370         _sendToDev(tDev, sender);
371         _sendToBurn(tBurn, sender);
372         _reflectFee(rFee, rBurn, rDev, tFee, tBurn, tDev);
373         emit Transfer(sender, recipient, tTransferAmount);
374     }
375     function _excludedToTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 rTransferAmount) private {
376         _tOwned[sender] = _tOwned[sender].sub(tAmount);
377         _rOwned[sender] = _rOwned[sender].sub(rAmount);
378         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
379     }
380     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
381         uint256 currentRate =  _getRate();
382         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tDev) = _getValues(tAmount);
383         uint256 rBurn =  tBurn.mul(currentRate);
384         uint256 rDev = tDev.mul(currentRate);
385         _bothTransferContent(sender, recipient, tAmount, rAmount, tTransferAmount, rTransferAmount);
386         _sendToDev(tDev, sender);
387         _sendToBurn(tBurn, sender);
388         _reflectFee(rFee, rBurn, rDev, tFee, tBurn, tDev);
389         emit Transfer(sender, recipient, tTransferAmount);
390     }
391     function _bothTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
392         _tOwned[sender] = _tOwned[sender].sub(tAmount);
393         _rOwned[sender] = _rOwned[sender].sub(rAmount);
394         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
395         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
396     }
397     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 rDev, uint256 tFee, uint256 tBurn, uint256 tDev) private {
398         _rTotal = _rTotal.sub(rFee).sub(rBurn).sub(rDev);
399         _tFeeTotal = _tFeeTotal.add(tFee);
400         _tBurnTotal = _tBurnTotal.add(tBurn);
401         _tDevTotal = _tDevTotal.add(tDev);
402         _tTotal = _tTotal.sub(tBurn);
403     }
404     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
405         (uint256 tFee, uint256 tBurn, uint256 tDev) = _getTBasics(tAmount, _TAX_FEE, _BURN_FEE, _DEV_FEE);
406         uint256 tTransferAmount = getTTransferAmount(tAmount, tFee, tBurn, tDev);
407         uint256 currentRate =  _getRate();
408         (uint256 rAmount, uint256 rFee) = _getRBasics(tAmount, tFee, currentRate);
409         uint256 rTransferAmount = _getRTransferAmount(rAmount, rFee, tBurn, tDev, currentRate);
410         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tDev);
411     }
412     function _getTBasics(uint256 tAmount, uint256 taxFee, uint256 burnFee, uint256 devFee) private pure returns (uint256, uint256, uint256) {
413         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
414         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
415         uint256 tDev = ((tAmount.mul(devFee)).div(_GRANULARITY)).div(100);
416         return (tFee, tBurn, tDev);
417     }
418     function getTTransferAmount(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tDev) private pure returns (uint256) {
419         return tAmount.sub(tFee).sub(tBurn).sub(tDev);
420     }
421     function _getRBasics(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256) {
422         uint256 rAmount = tAmount.mul(currentRate);
423         uint256 rFee = tFee.mul(currentRate);
424         return (rAmount, rFee);
425     }
426     function _getRTransferAmount(uint256 rAmount, uint256 rFee, uint256 tBurn, uint256 tDev, uint256 currentRate) private pure returns (uint256) {
427         uint256 rBurn = tBurn.mul(currentRate);
428         uint256 rDev = tDev.mul(currentRate);
429         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rDev);
430         return rTransferAmount;
431     }
432     function _getRate() private view returns(uint256) {
433         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
434         return rSupply.div(tSupply);
435     }
436     function _getCurrentSupply() private view returns(uint256, uint256) {
437         uint256 rSupply = _rTotal;
438         uint256 tSupply = _tTotal;
439         for (uint256 i = 0; i < _excluded.length; i++) {
440             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
441             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
442             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
443         }
444         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
445         return (rSupply, tSupply);
446     }
447     function _sendToDev(uint256 tDev, address sender) private {
448         uint256 currentRate = _getRate();
449         uint256 rDev = tDev.mul(currentRate);
450         address currentDev = _dev[0];
451         _rOwned[currentDev] = _rOwned[currentDev].add(rDev);
452         _tOwned[currentDev] = _tOwned[currentDev].add(tDev);
453         emit Transfer(sender, currentDev, tDev);
454     }
455     function _sendToBurn(uint256 tBurn, address sender) private {
456         uint256 currentRate = _getRate();
457         uint256 rBurn = tBurn.mul(currentRate);
458         address currentBurn = _burn[0];
459         _rOwned[currentBurn] = _rOwned[currentBurn].add(rBurn);
460         _tOwned[currentBurn] = _tOwned[currentBurn].add(tBurn);
461         emit Transfer(sender, currentBurn, tBurn);
462     }
463     function removeAllFee() private {
464         if(_TAX_FEE == 0 && _BURN_FEE == 0 && _DEV_FEE == 0) return;
465         ORIG_TAX_FEE = _TAX_FEE;
466         ORIG_BURN_FEE = _BURN_FEE;
467         ORIG_DEV_FEE = _DEV_FEE;
468         _TAX_FEE = 0;
469         _BURN_FEE = 0;
470         _DEV_FEE = 0;
471     }
472     function restoreAllFee() private {
473         _TAX_FEE = ORIG_TAX_FEE;
474         _BURN_FEE = ORIG_BURN_FEE;
475         _DEV_FEE = ORIG_DEV_FEE;
476     }
477     function _getTaxFee() private view returns(uint256) {
478         return _TAX_FEE;
479     }
480     function _getMaxTxAmount() private pure returns(uint256) {
481         return _MAX_TX_SIZE;
482     }
483 }