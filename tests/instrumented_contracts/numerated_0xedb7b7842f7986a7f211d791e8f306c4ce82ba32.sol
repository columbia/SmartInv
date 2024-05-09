1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.2;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40 
41         return c;
42     }
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50 
51         return c;
52     }
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         return mod(a, b, "SafeMath: modulo by zero");
63     }
64     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b != 0, errorMessage);
66         return a % b;
67     }
68 }
69 
70 library Address {
71     function isContract(address account) internal view returns (bool) {
72         bytes32 codehash;
73         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
74         // solhint-disable-next-line no-inline-assembly
75         assembly { codehash := extcodehash(account) }
76         return (codehash != accountHash && codehash != 0x0);
77     }
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
86       return functionCall(target, data, "Address: low-level call failed");
87     }
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return _functionCallWithValue(target, data, 0, errorMessage);
90     }
91     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
93     }
94     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
95         require(address(this).balance >= value, "Address: insufficient balance for call");
96         return _functionCallWithValue(target, data, value, errorMessage);
97     }
98 
99     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
100         require(isContract(target), "Address: call to non-contract");
101 
102         // solhint-disable-next-line avoid-low-level-calls
103         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
104         if (success) {
105             return returndata;
106         } else {
107             if (returndata.length > 0) {
108                 // solhint-disable-next-line no-inline-assembly
109                 assembly {
110                     let returndata_size := mload(returndata)
111                     revert(add(32, returndata), returndata_size)
112                 }
113             } else {
114                 revert(errorMessage);
115             }
116         }
117     }
118 }
119 
120 contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124     constructor () internal {
125         address msgSender = _msgSender();
126         _owner = msgSender;
127         emit OwnershipTransferred(address(0), msgSender);
128     }
129     function owner() public view returns (address) {
130         return _owner;
131     }
132     modifier onlyOwner() {
133         require(_owner == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136     function renounceOwnership() public virtual onlyOwner {
137         emit OwnershipTransferred(_owner, address(0));
138         _owner = address(0);
139     }
140     function transferOwnership(address newOwner) public virtual onlyOwner {
141         require(newOwner != address(0), "Ownable: new owner is the zero address");
142         emit OwnershipTransferred(_owner, newOwner);
143         _owner = newOwner;
144     }
145 }
146 
147 contract Polkazeck is Context, IERC20, Ownable {
148     using SafeMath for uint256;
149     using Address for address;
150 
151     mapping (address => uint256) private _rOwned;
152     mapping (address => uint256) private _tOwned;
153     mapping (address => mapping (address => uint256)) private _allowances;
154 
155     mapping (address => bool) private _isExcluded;
156     address[] private _excluded;
157    
158     uint256 private constant MAX = ~uint256(0);
159     uint256 private _tTotal = 162 * 10**6 * 10**18;
160     uint256 private _rTotal = (MAX - (MAX % _tTotal));
161     uint256 private _tFeeTotal;
162     uint256 public _taxFee = 30;
163     uint256 public _burnFee = 25;
164     
165     string private _name = "Polkazeck";
166     string private _symbol = "ZCK";
167     uint8 private _decimals = 18;
168 
169     address public beneficiary = address(0xd3F9c90041Aa7B3306f5bE5a2Ab6441620190722);
170 
171     uint256 private tMarketing = _tTotal.mul(20).div(100);
172     uint256 private marketingClaimCount;
173 
174     uint256 private tTeam = _tTotal.mul(10).div(100);
175     uint256 private teamClaimCount;
176     
177     uint256 private claimInterval = 7884000;
178     uint8 private claimPercent = 25;
179 
180     uint256 private marketingClaimNext;
181     uint256 private teamClaimNext;
182 
183     uint256 private tReserve = _tTotal.mul(5).div(100);
184     uint256 private reserveClaimAt;
185 
186     uint256 private tEcosystem = _tTotal.mul(175).div(1000);
187     uint256 private ecosystemClaimAt;
188 
189     constructor () public {
190         uint256 time = block.timestamp;
191         marketingClaimNext = time.add(claimInterval);
192         teamClaimNext = time.add(63070000);
193         reserveClaimAt = time.add(31540000);
194         ecosystemClaimAt = time.add(31540000);
195         
196         uint256 tLockedTotal = tMarketing.add(tTeam).add(tReserve).add(tEcosystem);
197         uint256 rLockedTotal = reflectionFromToken(tLockedTotal, false);
198         
199         _rOwned[beneficiary] = _rTotal.sub(rLockedTotal);
200         _rOwned[address(this)] = rLockedTotal;
201 
202         emit Transfer(address(0), beneficiary, _tTotal.sub(tLockedTotal));
203         emit Transfer(address(0), address(this), tLockedTotal);
204     }
205 
206     function name() public view returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public view returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public view returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public view override returns (uint256) {
219         return _tTotal;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         if (_isExcluded[account]) return _tOwned[account];
224         return tokenFromReflection(_rOwned[account]);
225     }
226 
227     function transfer(address recipient, uint256 amount) public override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender) public view override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     function approve(address spender, uint256 amount) public override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244         return true;
245     }
246 
247     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
249         return true;
250     }
251 
252     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
253         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
254         return true;
255     }
256 
257     function isExcluded(address account) public view returns (bool) {
258         return _isExcluded[account];
259     }
260 
261     function totalFees() public view returns (uint256) {
262         return _tFeeTotal;
263     }
264 
265     function reflect(uint256 tAmount) public {
266         address sender = _msgSender();
267         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
268         (uint256 rAmount,,,,,) = _getValues(tAmount);
269         _rOwned[sender] = _rOwned[sender].sub(rAmount);
270         _rTotal = _rTotal.sub(rAmount);
271         _tFeeTotal = _tFeeTotal.add(tAmount);
272     }
273 
274     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
275         require(tAmount <= _tTotal, "Amount must be less than supply");
276         if (!deductTransferFee) {
277             (uint256 rAmount,,,,,) = _getValues(tAmount);
278             return rAmount;
279         } else {
280             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
281             return rTransferAmount;
282         }
283     }
284 
285     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
286         require(rAmount <= _rTotal, "Amount must be less than total reflections");
287         uint256 currentRate =  _getRate();
288         return rAmount.div(currentRate);
289     }
290 
291     function excludeAccount(address account) external onlyOwner() {
292         require(!_isExcluded[account], "Account is already excluded");
293         if(_rOwned[account] > 0) {
294             _tOwned[account] = tokenFromReflection(_rOwned[account]);
295         }
296         _isExcluded[account] = true;
297         _excluded.push(account);
298     }
299 
300     function includeAccount(address account) external onlyOwner() {
301         require(_isExcluded[account], "Account is already excluded");
302         for (uint256 i = 0; i < _excluded.length; i++) {
303             if (_excluded[i] == account) {
304                 _excluded[i] = _excluded[_excluded.length - 1];
305                 _tOwned[account] = 0;
306                 _isExcluded[account] = false;
307                 _excluded.pop();
308                 break;
309             }
310         }
311     }
312 
313     function _approve(address owner, address spender, uint256 amount) private {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316 
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321     function _transfer(address sender, address recipient, uint256 amount) private {
322         require(sender != address(0), "ERC20: transfer from the zero address");
323         require(recipient != address(0), "ERC20: transfer to the zero address");
324         require(amount > 0, "Transfer amount must be greater than zero");
325         if (_isExcluded[sender] && !_isExcluded[recipient]) {
326             _transferFromExcluded(sender, recipient, amount);
327         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
328             _transferToExcluded(sender, recipient, amount);
329         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
330             _transferStandard(sender, recipient, amount);
331         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
332             _transferBothExcluded(sender, recipient, amount);
333         } else {
334             _transferStandard(sender, recipient, amount);
335         }
336     }
337 
338     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
339         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
340         _rOwned[sender] = _rOwned[sender].sub(rAmount);
341         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
342         _burn(sender, tBurn);       
343         _reflectFee(rFee, tFee);
344         emit Transfer(sender, recipient, tTransferAmount);
345     }
346 
347     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
348         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
349         _rOwned[sender] = _rOwned[sender].sub(rAmount);
350         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
351         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
352         _burn(sender, tBurn);           
353         _reflectFee(rFee, tFee);
354         emit Transfer(sender, recipient, tTransferAmount);
355     }
356 
357     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
358         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
359         _tOwned[sender] = _tOwned[sender].sub(tAmount);
360         _rOwned[sender] = _rOwned[sender].sub(rAmount);
361         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
362         _burn(sender, tBurn);   
363         _reflectFee(rFee, tFee);
364         emit Transfer(sender, recipient, tTransferAmount);
365     }
366 
367     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
368         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
369         _tOwned[sender] = _tOwned[sender].sub(tAmount);
370         _rOwned[sender] = _rOwned[sender].sub(rAmount);
371         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
372         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
373         _burn(sender, tBurn);
374         _reflectFee(rFee, tFee);
375         emit Transfer(sender, recipient, tTransferAmount);
376     }
377 
378     function _reflectFee(uint256 rFee, uint256 tFee) private {
379         _rTotal = _rTotal.sub(rFee);
380         _tFeeTotal = _tFeeTotal.add(tFee);
381     }
382 
383     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
384         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount);
385         uint256 currentRate =  _getRate();
386         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate, tBurn);
387         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
388     }
389 
390     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
391         uint256 tFee = tAmount.mul(_taxFee).div(1000);
392         uint256 tBurn = tAmount.mul(_burnFee).div(1000);
393         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
394         return (tTransferAmount, tFee, tBurn);
395     }
396 
397     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
398         uint256 rAmount = tAmount.mul(currentRate);
399         uint256 rFee = tFee.mul(currentRate);
400         uint256 rBurn = tBurn.mul(currentRate);
401         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
402         return (rAmount, rTransferAmount, rFee);
403     }
404 
405     function _getRate() private view returns(uint256) {
406         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
407         return rSupply.div(tSupply);
408     }
409 
410     function _getCurrentSupply() private view returns(uint256, uint256) {
411         uint256 rSupply = _rTotal;
412         uint256 tSupply = _tTotal;      
413         for (uint256 i = 0; i < _excluded.length; i++) {
414             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
415             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
416             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
417         }
418         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
419         return (rSupply, tSupply);
420     }
421 
422     function _burn(address sender, uint256 tBurn) private {
423         _tTotal = _tTotal.sub(tBurn);
424         emit Transfer(sender, address(0), tBurn);
425     }
426 
427     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
428         _taxFee = taxFee.mul(10);
429     }
430 
431     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
432         _burnFee = burnFee.mul(10);
433     }
434 
435     function releaseMarketing() public {
436         require(block.timestamp >= marketingClaimNext, "Too early");
437         require(marketingClaimCount < 4, "Claim completed");
438         marketingClaimNext = marketingClaimNext.add(claimInterval);
439         marketingClaimCount = marketingClaimCount.add(1);
440 
441         uint256 tAmount = tMarketing.mul(claimPercent).div(100);
442         uint256 rAmount = reflectionFromToken(tAmount, false);
443         _releaseLocked(address(this), beneficiary, rAmount, tAmount);
444     }
445 
446     function releaseTeam() public {
447         require(block.timestamp >= teamClaimNext, "Too early");
448         require(teamClaimCount < 4, "Claim completed");
449         teamClaimNext = teamClaimNext.add(claimInterval);
450         teamClaimCount = teamClaimCount.add(1);
451 
452         uint256 tAmount = tTeam.mul(claimPercent).div(100);
453         uint256 rAmount = reflectionFromToken(tAmount, false);
454         _releaseLocked(address(this), beneficiary, rAmount, tAmount);
455     }
456 
457     function releaseReserve() public {
458         require(tReserve > 0, "Already claimed");
459         require(block.timestamp >= reserveClaimAt, "Too early");
460         _releaseLocked(address(this), beneficiary, reflectionFromToken(tReserve, false), tReserve);
461         tReserve = 0;
462     }
463 
464     function releaseEcosystem() public {
465         require(tEcosystem > 0, "Already claimed");
466         require(block.timestamp >= ecosystemClaimAt, "Too early");
467         _releaseLocked(address(this), beneficiary, reflectionFromToken(tEcosystem, false), tEcosystem);
468         tEcosystem = 0;
469     }
470 
471     function _releaseLocked(address sender, address recipient, uint256 rAmount, uint256 tAmount) private {
472         _rOwned[sender] = _rOwned[sender].sub(rAmount);
473         _rOwned[recipient] = _rOwned[recipient].add(rAmount);
474         emit Transfer(sender, recipient, tAmount);
475     }
476 }