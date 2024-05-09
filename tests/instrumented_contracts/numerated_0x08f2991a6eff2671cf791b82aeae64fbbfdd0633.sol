1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43 
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61 
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         return mod(a, b, "SafeMath: modulo by zero");
67     }
68 
69     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b != 0, errorMessage);
71         return a % b;
72     }
73 }
74 
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address payable) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this;
82         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
83         return msg.data;
84     }
85 }
86 
87 library Address {
88 
89     function isContract(address account) internal view returns (bool) {
90         bytes32 codehash;
91         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
92         assembly {codehash := extcodehash(account)}
93         return (codehash != accountHash && codehash != 0x0);
94     }
95 
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(address(this).balance >= amount, "Address: insufficient balance");
98 
99         (bool success,) = recipient.call{value : amount}("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104         return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
108         return _functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         return _functionCallWithValue(target, data, value, errorMessage);
118     }
119 
120     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
121         require(isContract(target), "Address: call to non-contract");
122 
123         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
124         if (success) {
125             return returndata;
126         } else {
127 
128             if (returndata.length > 0) {
129 
130                 assembly {
131                     let returndata_size := mload(returndata)
132                     revert(add(32, returndata), returndata_size)
133                 }
134             } else {
135                 revert(errorMessage);
136             }
137         }
138     }
139 }
140 
141 contract Ownable is Context {
142     address private _owner;
143     address private _previousOwner;
144     uint256 private _lockTime;
145 
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     constructor () internal {
149         address msgSender = _msgSender();
150         _owner = msgSender;
151         emit OwnershipTransferred(address(0), msgSender);
152     }
153 
154     function owner() public view returns (address) {
155         return _owner;
156     }
157 
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 
174     function geUnlockTime() public view returns (uint256) {
175         return _lockTime;
176     }
177 
178     function lock(uint256 time) public virtual onlyOwner {
179         _previousOwner = _owner;
180         _owner = address(0);
181         _lockTime = now + time;
182         emit OwnershipTransferred(_owner, address(0));
183     }
184 
185     function unlock() public virtual {
186         require(_previousOwner == msg.sender, "You don't have permission to unlock");
187         require(now > _lockTime, "Contract is locked until 7 days");
188         emit OwnershipTransferred(_owner, _previousOwner);
189         _owner = _previousOwner;
190     }
191 }
192 
193 contract JacyWaya is Context, IERC20, Ownable {
194     using SafeMath for uint256;
195     using Address for address;
196 
197     mapping(address => uint256) private _rOwned;
198     mapping(address => uint256) private _tOwned;
199     mapping(address => mapping(address => uint256)) private _allowances;
200     mapping(address => bool) private _isExcludedFromFee;
201 
202     mapping(address => bool) private _isExcluded;
203     address[] private _excluded;
204 
205     uint256 private constant MAX = ~uint256(0);
206     uint256 private _tTotal = 100000000000000000000000000;
207     uint256 private _rTotal = (MAX - (MAX % _tTotal));
208     uint256 private _tFeeTotal;
209 
210     string private _name = "JACYWAYA";
211     string private _symbol = "JACY";
212     uint8 private _decimals = 9;
213 
214     uint256 public _taxFee = 2;
215     uint256 private _previousTaxFee = _taxFee;
216 
217     uint256 public _liquidityFee = 0;
218     uint256 private _previousLiquidityFee = _liquidityFee;
219 
220     address public _marketingWallet = 0xae36358367B0d70987c9497E7455Fd54864F7893;
221     address public _charityWallet = 0x9139144a4690A7Dbe48f604561Ecd63606Fe001d;
222     
223     bool public swapAndLiquifyEnabled = true;
224 
225     uint256 public _maxTxAmount = 3000000000000000000000000;
226 
227 
228     constructor () public {
229         _rOwned[_msgSender()] = _rTotal;
230         _isExcludedFromFee[owner()] = true;
231         _isExcludedFromFee[_msgSender()] = true;
232         _isExcludedFromFee[_charityWallet] = true;
233         _isExcludedFromFee[_marketingWallet] = true;
234         
235         emit Transfer(address(0), _msgSender(), _tTotal);
236     }
237 
238     function name() public view returns (string memory) {
239         return _name;
240     }
241 
242     function symbol() public view returns (string memory) {
243         return _symbol;
244     }
245 
246     function decimals() public view returns (uint8) {
247         return _decimals;
248     }
249 
250     function totalSupply() public view override returns (uint256) {
251         return _tTotal;
252     }
253 
254     function balanceOf(address account) public view override returns (uint256) {
255         if (_isExcluded[account]) return _tOwned[account];
256         return tokenFromReflection(_rOwned[account]);
257     }
258 
259     function transfer(address recipient, uint256 amount) public override returns (bool) {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263 
264     function allowance(address owner, address spender) public view override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     function approve(address spender, uint256 amount) public override returns (bool) {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
274         _transfer(sender, recipient, amount);
275         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
276         return true;
277     }
278 
279     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
281         return true;
282     }
283 
284     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
285         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
286         return true;
287     }
288 
289     function isExcludedFromReward(address account) public view returns (bool) {
290         return _isExcluded[account];
291     }
292 
293     function totalFees() public view returns (uint256) {
294         return _tFeeTotal;
295     }
296 
297     function deliver(uint256 tAmount) public {
298         address sender = _msgSender();
299         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
300         (uint256 rAmount,,,,,) = _getValues(tAmount);
301         _rOwned[sender] = _rOwned[sender].sub(rAmount);
302         _rTotal = _rTotal.sub(rAmount);
303         _tFeeTotal = _tFeeTotal.add(tAmount);
304     }
305 
306     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
307         require(tAmount <= _tTotal, "Amount must be less than supply");
308         if (!deductTransferFee) {
309             (uint256 rAmount,,,,,) = _getValues(tAmount);
310             return rAmount;
311         } else {
312             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
313             return rTransferAmount;
314         }
315     }
316 
317     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
318         require(rAmount <= _rTotal, "Amount must be less than total reflections");
319         uint256 currentRate = _getRate();
320         return rAmount.div(currentRate);
321     }
322 
323     function excludeFromReward(address account) public onlyOwner() {
324 
325         require(!_isExcluded[account], "Account is already excluded");
326         if (_rOwned[account] > 0) {
327             _tOwned[account] = tokenFromReflection(_rOwned[account]);
328         }
329         _isExcluded[account] = true;
330         _excluded.push(account);
331     }
332 
333     function includeInReward(address account) external onlyOwner() {
334         require(_isExcluded[account], "Account is already excluded");
335         for (uint256 i = 0; i < _excluded.length; i++) {
336             if (_excluded[i] == account) {
337                 _excluded[i] = _excluded[_excluded.length - 1];
338                 _tOwned[account] = 0;
339                 _isExcluded[account] = false;
340                 _excluded.pop();
341                 break;
342             }
343         }
344     }
345 
346     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
347         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
348         _tOwned[sender] = _tOwned[sender].sub(tAmount);
349         _rOwned[sender] = _rOwned[sender].sub(rAmount);
350         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
351         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
352         _takeLiquidity(tLiquidity);
353         _reflectFee(rFee, tFee);
354         emit Transfer(sender, recipient, tTransferAmount);
355     }
356 
357     function excludeFromFee(address account) public onlyOwner {
358         _isExcludedFromFee[account] = true;
359     }
360 
361     function includeInFee(address account) public onlyOwner {
362         _isExcludedFromFee[account] = false;
363     }
364     
365     function multiTransfers(address[] memory addresses, uint256[] memory amounts) external onlyOwner returns (bool)  {
366         for (uint256 i = 0; i < addresses.length; i++) {
367             address recipient = addresses[i];
368             uint256 amount = amounts[i];
369             _transfer(_msgSender(), recipient, amount);
370         }
371         return true;
372     }
373 
374     function setTaxFee(uint256 taxFee) external onlyOwner {
375         _taxFee = taxFee;
376     }
377 
378     function setMaxTxPercent(uint256 maxTxAmount) external onlyOwner() {
379         _maxTxAmount = maxTxAmount;
380     }
381 
382     receive() external payable {}
383 
384     function _reflectFee(uint256 rFee, uint256 tFee) private {
385         _rTotal = _rTotal.sub(rFee);
386         _tFeeTotal = _tFeeTotal.add(tFee);
387     }
388 
389     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
390         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
391         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
392         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
393     }
394 
395     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
396         uint256 tFee = calculateTaxFee(tAmount);
397         uint256 tLiquidity = calculateLiquidityFee(tAmount);
398         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
399         return (tTransferAmount, tFee, tLiquidity);
400     }
401 
402     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
403         uint256 rAmount = tAmount.mul(currentRate);
404         uint256 rFee = tFee.mul(currentRate);
405         uint256 rLiquidity = tLiquidity.mul(currentRate);
406         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
407         return (rAmount, rTransferAmount, rFee);
408     }
409 
410     function _getRate() private view returns (uint256) {
411         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
412         return rSupply.div(tSupply);
413     }
414 
415     function _getCurrentSupply() private view returns (uint256, uint256) {
416         uint256 rSupply = _rTotal;
417         uint256 tSupply = _tTotal;
418         for (uint256 i = 0; i < _excluded.length; i++) {
419             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
420             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
421             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
422         }
423         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
424         return (rSupply, tSupply);
425     }
426 
427     function _takeLiquidity(uint256 tLiquidity) private {
428         uint256 currentRate = _getRate();
429         uint256 rLiquidity = tLiquidity.mul(currentRate);
430         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
431         if (_isExcluded[address(this)])
432             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
433     }
434 
435     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
436         return _amount.mul(_taxFee).div(10 ** 2);
437     }
438 
439     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
440         return _amount.mul(_liquidityFee).div(10 ** 2);
441     }
442 
443     function removeAllFee() private {
444         if (_taxFee == 0) return;
445 
446         _previousTaxFee = _taxFee;
447         _previousLiquidityFee = _liquidityFee;
448         
449         _taxFee = 0;
450         _liquidityFee = 0;
451     }
452 
453     function restoreAllFee() private {
454         _taxFee = _previousTaxFee;
455         _liquidityFee = _previousLiquidityFee;
456     }
457 
458     function isExcludedFromFee(address account) public view returns (bool) {
459         return _isExcludedFromFee[account];
460     }
461 
462     function _approve(address owner, address spender, uint256 amount) private {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     function _transfer(address from, address to, uint256 amount) private {
471         require(from != address(0), "ERC20: transfer from the zero address");
472         require(to != address(0), "ERC20: transfer to the zero address");
473         require(amount > 0, "Transfer amount must be greater than zero");
474         if (from != owner() && to != owner())
475             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
476 
477         bool takeFee = true;
478 
479         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
480             takeFee = false;
481         }
482         _tokenTransfer(from, to, amount, takeFee);
483         
484     }
485 
486     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
487         if (!takeFee)
488             removeAllFee();
489 
490         if (_isExcluded[sender] && !_isExcluded[recipient]) {
491             _transferFromExcluded(sender, recipient, amount);
492         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
493             _transferToExcluded(sender, recipient, amount);
494         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
495             _transferStandard(sender, recipient, amount);
496         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
497             _transferBothExcluded(sender, recipient, amount);
498         } else {
499             _transferStandard(sender, recipient, amount);
500         }
501 
502         if (!takeFee)
503             restoreAllFee();
504     }
505 
506     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
507         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
508         _rOwned[sender] = _rOwned[sender].sub(rAmount);
509         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
510         _takeLiquidity(tLiquidity);
511         _reflectFee(rFee, tFee);
512         emit Transfer(sender, recipient, tTransferAmount);
513     }
514 
515     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
516         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
517         _rOwned[sender] = _rOwned[sender].sub(rAmount);
518         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
519         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
520         _takeLiquidity(tLiquidity);
521         _reflectFee(rFee, tFee);
522         emit Transfer(sender, recipient, tTransferAmount);
523     }
524 
525     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
526         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
527         _tOwned[sender] = _tOwned[sender].sub(tAmount);
528         _rOwned[sender] = _rOwned[sender].sub(rAmount);
529         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
530         _takeLiquidity(tLiquidity);
531         _reflectFee(rFee, tFee);
532         emit Transfer(sender, recipient, tTransferAmount);
533     }
534 
535 }