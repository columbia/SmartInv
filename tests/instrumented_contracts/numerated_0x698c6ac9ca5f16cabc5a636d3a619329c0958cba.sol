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
193 contract Saja is Context, IERC20, Ownable {
194     using SafeMath for uint256;
195     using Address for address;
196 
197     mapping(address => uint256) private _rOwned;
198     mapping(address => uint256) private _tOwned;
199     mapping(address => mapping(address => uint256)) private _allowances;
200 
201     mapping(address => bool) private _isExcludedFromFee;
202 
203     mapping(address => bool) private _isExcluded;
204     address[] private _excluded;
205 
206     uint256 private constant MAX = ~uint256(0);
207     uint256 private _tTotal = 1000000000000 * 10 ** 6 * 10 ** 9;
208     uint256 private _rTotal = (MAX - (MAX % _tTotal));
209     uint256 private _tFeeTotal;
210 
211     string private _name = "Saja";
212     string private _symbol = "Saja";
213     uint8 private _decimals = 9;
214 
215     uint256 public _taxFee = 1;
216     uint256 private _previousTaxFee = _taxFee;
217 
218     uint256 public _liquidityFee = 0;
219     uint256 private _previousLiquidityFee = _liquidityFee;
220 
221     uint256 public _marketingFee = 0;
222     uint256 private _previousMarketingFee = _marketingFee;
223 
224     uint256 public _charityFee = 0;
225     uint256 private _previousCharityFee = _charityFee;
226 
227     uint256 public _burnFee = 0;
228     uint256 private _previousBurnFee = _burnFee;
229 
230     address public _marketingWallet;
231     address public _charityWallet;
232     address public _deadAddress;
233 
234     bool public swapAndLiquifyEnabled = true;
235 
236     uint256 public _maxTxAmount = 5000000000 * 10 ** 6 * 10 ** 9;
237     uint256 private numTokensSellToAddToLiquidity = 5000000000 * 10 ** 6 * 10 ** 9;
238 
239 
240     constructor () public {
241         _rOwned[_msgSender()] = _rTotal;
242 
243         _marketingWallet = 0x9934AA2AF6604aD463afD2a9F5e0C24b84481268;
244         _charityWallet = 0x6780313D958B535BB103386919a02c835207f2a0;
245         _deadAddress = 0x000000000000000000000000000000000000dEaD;
246 
247 
248         _isExcludedFromFee[owner()] = true;
249         _isExcludedFromFee[address(this)] = true;
250 
251         emit Transfer(address(0), _msgSender(), _tTotal);
252     }
253 
254     function name() public view returns (string memory) {
255         return _name;
256     }
257 
258     function symbol() public view returns (string memory) {
259         return _symbol;
260     }
261 
262     function decimals() public view returns (uint8) {
263         return _decimals;
264     }
265 
266     function totalSupply() public view override returns (uint256) {
267         return _tTotal;
268     }
269 
270     function balanceOf(address account) public view override returns (uint256) {
271         if (_isExcluded[account]) return _tOwned[account];
272         return tokenFromReflection(_rOwned[account]);
273     }
274 
275     function transfer(address recipient, uint256 amount) public override returns (bool) {
276         _transfer(_msgSender(), recipient, amount);
277         return true;
278     }
279 
280     function allowance(address owner, address spender) public view override returns (uint256) {
281         return _allowances[owner][spender];
282     }
283 
284     function approve(address spender, uint256 amount) public override returns (bool) {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288 
289     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
292         return true;
293     }
294 
295     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
296         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
297         return true;
298     }
299 
300     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
302         return true;
303     }
304 
305     function isExcludedFromReward(address account) public view returns (bool) {
306         return _isExcluded[account];
307     }
308 
309     function totalFees() public view returns (uint256) {
310         return _tFeeTotal;
311     }
312 
313     function deliver(uint256 tAmount) public {
314         address sender = _msgSender();
315         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
316         (uint256 rAmount,,,,,) = _getValues(tAmount);
317         _rOwned[sender] = _rOwned[sender].sub(rAmount);
318         _rTotal = _rTotal.sub(rAmount);
319         _tFeeTotal = _tFeeTotal.add(tAmount);
320     }
321 
322     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
323         require(tAmount <= _tTotal, "Amount must be less than supply");
324         if (!deductTransferFee) {
325             (uint256 rAmount,,,,,) = _getValues(tAmount);
326             return rAmount;
327         } else {
328             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
329             return rTransferAmount;
330         }
331     }
332 
333     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
334         require(rAmount <= _rTotal, "Amount must be less than total reflections");
335         uint256 currentRate = _getRate();
336         return rAmount.div(currentRate);
337     }
338 
339     function excludeFromReward(address account) public onlyOwner() {
340 
341         require(!_isExcluded[account], "Account is already excluded");
342         if (_rOwned[account] > 0) {
343             _tOwned[account] = tokenFromReflection(_rOwned[account]);
344         }
345         _isExcluded[account] = true;
346         _excluded.push(account);
347     }
348 
349     function includeInReward(address account) external onlyOwner() {
350         require(_isExcluded[account], "Account is already excluded");
351         for (uint256 i = 0; i < _excluded.length; i++) {
352             if (_excluded[i] == account) {
353                 _excluded[i] = _excluded[_excluded.length - 1];
354                 _tOwned[account] = 0;
355                 _isExcluded[account] = false;
356                 _excluded.pop();
357                 break;
358             }
359         }
360     }
361 
362     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
363         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
364         _tOwned[sender] = _tOwned[sender].sub(tAmount);
365         _rOwned[sender] = _rOwned[sender].sub(rAmount);
366         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
367         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
368         _takeLiquidity(tLiquidity);
369         _reflectFee(rFee, tFee);
370         emit Transfer(sender, recipient, tTransferAmount);
371     }
372 
373     function excludeFromFee(address account) public onlyOwner {
374         _isExcludedFromFee[account] = true;
375     }
376 
377     function includeInFee(address account) public onlyOwner {
378         _isExcludedFromFee[account] = false;
379     }
380 
381     function setFees(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee, uint256 charityFee, uint256 burnFee) external onlyOwner {
382         _taxFee = taxFee;
383         _liquidityFee = liquidityFee;
384         _marketingFee = marketingFee;
385         _charityFee = charityFee;
386         _burnFee = burnFee;
387     }
388 
389     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
390         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
391             10 ** 2
392         );
393     }
394 
395     receive() external payable {}
396 
397     function _reflectFee(uint256 rFee, uint256 tFee) private {
398         _rTotal = _rTotal.sub(rFee);
399         _tFeeTotal = _tFeeTotal.add(tFee);
400     }
401 
402     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
403         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
404         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
405         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
406     }
407 
408     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
409         uint256 tFee = calculateTaxFee(tAmount);
410         uint256 tLiquidity = calculateLiquidityFee(tAmount);
411         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
412         return (tTransferAmount, tFee, tLiquidity);
413     }
414 
415     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
416         uint256 rAmount = tAmount.mul(currentRate);
417         uint256 rFee = tFee.mul(currentRate);
418         uint256 rLiquidity = tLiquidity.mul(currentRate);
419         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
420         return (rAmount, rTransferAmount, rFee);
421     }
422 
423     function _getRate() private view returns (uint256) {
424         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
425         return rSupply.div(tSupply);
426     }
427 
428     function _getCurrentSupply() private view returns (uint256, uint256) {
429         uint256 rSupply = _rTotal;
430         uint256 tSupply = _tTotal;
431         for (uint256 i = 0; i < _excluded.length; i++) {
432             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
433             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
434             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
435         }
436         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
437         return (rSupply, tSupply);
438     }
439 
440     function _takeLiquidity(uint256 tLiquidity) private {
441         uint256 currentRate = _getRate();
442         uint256 rLiquidity = tLiquidity.mul(currentRate);
443         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
444         if (_isExcluded[address(this)])
445             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
446     }
447 
448     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
449         return _amount.mul(_taxFee).div(
450             10 ** 2
451         );
452     }
453 
454     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
455         return _amount.mul(_liquidityFee).div(
456             10 ** 2
457         );
458     }
459 
460     function removeAllFee() private {
461         if (_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0 && _burnFee == 0 && _charityFee == 0) return;
462 
463         _previousTaxFee = _taxFee;
464         _previousLiquidityFee = _liquidityFee;
465         _previousMarketingFee = _marketingFee;
466         _previousCharityFee = _charityFee;
467         _previousBurnFee = _burnFee;
468 
469         _taxFee = 0;
470         _liquidityFee = 0;
471         _marketingFee = 0;
472         _charityFee = 0;
473         _burnFee = 0;
474     }
475 
476     function restoreAllFee() private {
477         _taxFee = _previousTaxFee;
478         _liquidityFee = _previousLiquidityFee;
479         _marketingFee = _previousMarketingFee;
480         _charityFee = _previousCharityFee;
481         _burnFee = _previousBurnFee;
482 
483     }
484 
485     function isExcludedFromFee(address account) public view returns (bool) {
486         return _isExcludedFromFee[account];
487     }
488 
489     function _approve(address owner, address spender, uint256 amount) private {
490         require(owner != address(0), "ERC20: approve from the zero address");
491         require(spender != address(0), "ERC20: approve to the zero address");
492 
493         _allowances[owner][spender] = amount;
494         emit Approval(owner, spender, amount);
495     }
496 
497     function _transfer(address from, address to, uint256 amount) private {
498         require(from != address(0), "ERC20: transfer from the zero address");
499         require(to != address(0), "ERC20: transfer to the zero address");
500         require(amount > 0, "Transfer amount must be greater than zero");
501         if (from != owner() && to != owner())
502             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
503 
504         uint256 contractTokenBalance = balanceOf(address(this));
505         uint256 marketingFee = amount * _marketingFee / 100;
506         uint256 burnFee = amount * _burnFee / 100;
507         uint charityFee = amount * _charityFee /100;
508 
509         if (contractTokenBalance >= _maxTxAmount)
510         {
511             contractTokenBalance = _maxTxAmount;
512         }
513 
514         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
515         if (overMinTokenBalance) {
516             contractTokenBalance = numTokensSellToAddToLiquidity;
517         }
518 
519         bool takeFee = true;
520 
521         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
522             takeFee = false;
523         }
524         if (marketingFee > 0) {
525             _tokenTransfer(from, _marketingWallet, marketingFee, takeFee);
526         }
527         if (charityFee > 0) {
528             _tokenTransfer(from, _charityWallet, charityFee, takeFee);
529         }
530         if (burnFee > 0) {
531             _tokenTransfer(from, _deadAddress, burnFee, takeFee);
532         }
533 
534         _tokenTransfer(from, to, amount .sub(marketingFee) .sub(burnFee).sub(charityFee), takeFee);
535 
536     }
537 
538     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
539         if (!takeFee)
540             removeAllFee();
541 
542         if (_isExcluded[sender] && !_isExcluded[recipient]) {
543             _transferFromExcluded(sender, recipient, amount);
544         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
545             _transferToExcluded(sender, recipient, amount);
546         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
547             _transferStandard(sender, recipient, amount);
548         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
549             _transferBothExcluded(sender, recipient, amount);
550         } else {
551             _transferStandard(sender, recipient, amount);
552         }
553 
554         if (!takeFee)
555             restoreAllFee();
556     }
557 
558     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
559         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
560         _rOwned[sender] = _rOwned[sender].sub(rAmount);
561         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
562         _takeLiquidity(tLiquidity);
563         _reflectFee(rFee, tFee);
564         emit Transfer(sender, recipient, tTransferAmount);
565     }
566 
567     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
568         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
569         _rOwned[sender] = _rOwned[sender].sub(rAmount);
570         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
571         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
572         _takeLiquidity(tLiquidity);
573         _reflectFee(rFee, tFee);
574         emit Transfer(sender, recipient, tTransferAmount);
575     }
576 
577     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
578         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
579         _tOwned[sender] = _tOwned[sender].sub(tAmount);
580         _rOwned[sender] = _rOwned[sender].sub(rAmount);
581         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
582         _takeLiquidity(tLiquidity);
583         _reflectFee(rFee, tFee);
584         emit Transfer(sender, recipient, tTransferAmount);
585     }
586 
587 }