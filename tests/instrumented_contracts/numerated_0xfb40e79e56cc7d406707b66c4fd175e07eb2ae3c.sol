1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract Ownable is Context {
22     address private m_Owner;
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24     constructor () {
25         address msgSender = _msgSender();
26         m_Owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29     function owner() public view returns (address) {
30         return m_Owner;
31     }
32     function transferOwnership(address _address) public virtual onlyOwner {
33         emit OwnershipTransferred(m_Owner, _address);
34         m_Owner = _address;
35     }
36     modifier onlyOwner() {
37         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
38         _;
39     }                                                                                           
40 }
41 
42 library Address {
43     function isContract(address account) internal view returns (bool) {
44         bytes32 codehash;
45         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
46         // solhint-disable-next-line no-inline-assembly
47         assembly { codehash := extcodehash(account) }
48         return (codehash != accountHash && codehash != 0x0);
49     }
50 
51     function sendValue(address payable recipient, uint256 amount) internal {
52         require(address(this).balance >= amount, "Address: insufficient balance");
53 
54         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
55         (bool success, ) = recipient.call{ value: amount }("");
56         require(success, "Address: unable to send value, recipient may have reverted");
57     }
58 
59     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
60       return functionCall(target, data, "Address: low-level call failed");
61     }
62 
63     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
64         return _functionCallWithValue(target, data, 0, errorMessage);
65     }
66 
67     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
68         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
69     }
70 
71     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
72         require(address(this).balance >= value, "Address: insufficient balance for call");
73         return _functionCallWithValue(target, data, value, errorMessage);
74     }
75 
76     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
77         require(isContract(target), "Address: call to non-contract");
78 
79         // solhint-disable-next-line avoid-low-level-calls
80         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
81         if (success) {
82             return returndata;
83         } else {
84             // Look for revert reason and bubble it up if present
85             if (returndata.length > 0) {
86                 // The easiest way to bubble the revert reason is using memory via assembly
87 
88                 // solhint-disable-next-line no-inline-assembly
89                 assembly {
90                     let returndata_size := mload(returndata)
91                     revert(add(32, returndata), returndata_size)
92                 }
93             } else {
94                 revert(errorMessage);
95             }
96         }
97     }
98 }
99 
100 library SafeMath {
101     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
102         unchecked {
103             uint256 c = a + b;
104             if (c < a) return (false, 0);
105             return (true, c);
106         }
107     }
108 
109     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             if (b > a) return (false, 0);
112             return (true, a - b);
113         }
114     }
115 
116     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (a == 0) return (true, 0);
119             uint256 c = a * b;
120             if (c / a != b) return (false, 0);
121             return (true, c);
122         }
123     }
124 
125     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             if (b == 0) return (false, 0);
128             return (true, a / b);
129         }
130     }
131 
132     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             if (b == 0) return (false, 0);
135             return (true, a % b);
136         }
137     }
138 
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a + b;
141     }
142 
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a - b;
145     }
146 
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a * b;
149     }
150 
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a / b;
153     }
154 
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     function sub(
160         uint256 a,
161         uint256 b,
162         string memory errorMessage
163     ) internal pure returns (uint256) {
164         unchecked {
165             require(b <= a, errorMessage);
166             return a - b;
167         }
168     }
169 
170     function div(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b > 0, errorMessage);
177             return a / b;
178         }
179     }
180 
181     function mod(
182         uint256 a,
183         uint256 b,
184         string memory errorMessage
185     ) internal pure returns (uint256) {
186         unchecked {
187             require(b > 0, errorMessage);
188             return a % b;
189         }
190     }
191 }
192 
193 
194 
195 contract ROTTSCHILD is Context, IERC20, Ownable {
196     using SafeMath for uint256;
197     using Address for address;
198 
199     mapping (address => uint256) private _rOwned;
200     mapping (address => uint256) private _tOwned;
201     mapping (address => mapping (address => uint256)) private _allowances;
202 
203     mapping (address => bool) private _isExcluded;
204     address[] private _excluded;
205 
206     uint256 private constant MAX = ~uint256(0);
207     uint256 private constant _tTotal = 1000000000000 * 10**9;
208     uint256 private _rTotal = (MAX - (MAX % _tTotal));
209     uint256 private _tFeeTotal;
210 
211     string private constant _name = 'ROTTSCHILD.com';
212     string private constant _symbol = 'ROTTS';
213     uint8 private constant _decimals = 9;
214 
215     uint256 private constant _taxFee = 2;
216     mapping (address => bool) private dexPairs;
217 
218     constructor () {
219         _rOwned[_msgSender()] = _rTotal;
220         emit Transfer(address(0), _msgSender(), _tTotal);
221     }
222 
223     function name() external pure returns (string memory) {
224         return _name;
225     }
226 
227     function symbol() external pure returns (string memory) {
228         return _symbol;
229     }
230 
231     function decimals() external pure returns (uint8) {
232         return _decimals;
233     }
234 
235     function totalSupply() external pure override returns (uint256) {
236         return _tTotal;
237     }
238 
239     function balanceOf(address account) external view override returns (uint256) {
240         if (_isExcluded[account]) return _tOwned[account];
241         return tokenFromReflection(_rOwned[account]);
242     }
243 
244     function transfer(address recipient, uint256 amount) external override returns (bool) {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     function allowance(address owner, address spender) external view override returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     function approve(address spender, uint256 amount) external override returns (bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
259         _transfer(sender, recipient, amount);
260         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
261         return true;
262     }
263 
264     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
265         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
266         return true;
267     }
268 
269     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
270         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
271         return true;
272     }
273 
274     function isExcluded(address account) public view returns (bool) {
275         return _isExcluded[account];
276     }
277 
278     function totalFees() external view returns (uint256) {
279         return _tFeeTotal;
280     }
281 
282 
283     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
284         require(rAmount <= _rTotal, "Amount must be less than total reflections");
285         uint256 currentRate =  _getRate();
286         return rAmount.div(currentRate);
287     }
288 
289     function excludeAccount(address account) external onlyOwner() {
290         require(!_isExcluded[account], "Account is already excluded");
291         if(_rOwned[account] > 0) {
292             _tOwned[account] = tokenFromReflection(_rOwned[account]);
293         }
294         _isExcluded[account] = true;
295         _excluded.push(account);
296     }
297 
298     function includeAccount(address account) external onlyOwner() {
299         require(_isExcluded[account], "Account is already excluded");
300         for (uint256 i = 0; i < _excluded.length; i++) {
301             if (_excluded[i] == account) {
302                 _excluded[i] = _excluded[_excluded.length - 1];
303                 _tOwned[account] = 0;
304                 _isExcluded[account] = false;
305                 _excluded.pop();
306                 break;
307             }
308         }
309     }
310     
311     function _approve(address owner, address spender, uint256 amount) private {
312         require(owner != address(0), "ERC20: approve from the zero address");
313         require(spender != address(0), "ERC20: approve to the zero address");
314 
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319     function _transfer(address sender, address recipient, uint256 amount) private {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322         require(amount > 0, "Transfer amount must be greater than zero");
323 
324         bool transferTx = false;
325         if (!dexPairs[sender] && !dexPairs[recipient]) {
326             transferTx = true;
327         }
328         
329 
330         if (_isExcluded[sender] && !_isExcluded[recipient]) {
331             _transferFromExcluded(sender, recipient, amount, transferTx);
332         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
333             _transferToExcluded(sender, recipient, amount, transferTx);
334         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
335             _transferStandard(sender, recipient, amount, transferTx);
336         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
337             _transferBothExcluded(sender, recipient, amount, transferTx);
338         } else {
339             _transferStandard(sender, recipient, amount, transferTx);
340         }
341     }
342 
343     function _transferStandard(address sender, address recipient, uint256 tAmount, bool transferTx) private {
344         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount,transferTx);
345         _rOwned[sender] = _rOwned[sender].sub(rAmount);
346         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
347         _reflectFee(rFee, tFee);
348         emit Transfer(sender, recipient, tTransferAmount);
349     }
350 
351     function _transferToExcluded(address sender, address recipient, uint256 tAmount, bool transferTx) private {
352         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount,transferTx);
353         _rOwned[sender] = _rOwned[sender].sub(rAmount);
354         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
355         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
356         _reflectFee(rFee, tFee);
357         emit Transfer(sender, recipient, tTransferAmount);
358     }
359 
360     function _transferFromExcluded(address sender, address recipient, uint256 tAmount, bool transferTx) private {
361         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount,transferTx);
362         _tOwned[sender] = _tOwned[sender].sub(tAmount);
363         _rOwned[sender] = _rOwned[sender].sub(rAmount);
364         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
365         _reflectFee(rFee, tFee);
366         emit Transfer(sender, recipient, tTransferAmount);
367     }
368 
369     function _transferBothExcluded(address sender, address recipient, uint256 tAmount, bool transferTx) private {
370         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount,transferTx);
371         _tOwned[sender] = _tOwned[sender].sub(tAmount);
372         _rOwned[sender] = _rOwned[sender].sub(rAmount);
373         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
374         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
375         _reflectFee(rFee, tFee);
376         emit Transfer(sender, recipient, tTransferAmount);
377     }
378 
379     function _reflectFee(uint256 rFee, uint256 tFee) private {
380         _rTotal = _rTotal.sub(rFee);
381         _tFeeTotal = _tFeeTotal.add(tFee);
382     }
383 
384     function _getValues(uint256 tAmount, bool transferTx) private view returns (uint256, uint256, uint256, uint256, uint256) {
385         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, transferTx);
386         uint256 currentRate =  _getRate();
387         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
388         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
389     }
390 
391 
392     function _getTValues(uint256 tAmount, bool transferTx) private pure returns (uint256, uint256) {
393         uint256 tFee = 0;
394         if (!transferTx){
395             tFee = tAmount.mul(_taxFee).div(10**2);
396         }
397         uint256 tTransferAmount = tAmount.sub(tFee);
398         return (tTransferAmount, tFee);
399     }
400 
401     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
402         uint256 rAmount = tAmount.mul(currentRate);
403         uint256 rFee = tFee.mul(currentRate);
404         uint256 rTransferAmount = rAmount.sub(rFee);
405         return (rAmount, rTransferAmount, rFee);
406     }
407 
408     function _getRate() private view returns(uint256) {
409         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
410         return rSupply.div(tSupply);
411     }
412 
413     function _getCurrentSupply() private view returns(uint256, uint256) {
414         uint256 rSupply = _rTotal;
415         uint256 tSupply = _tTotal;
416         for (uint256 i = 0; i < _excluded.length; i++) {
417             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
418             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
419             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
420         }
421         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
422         return (rSupply, tSupply);
423     }
424 
425 
426     function isDexPair(address _pair) public view returns (bool) {
427         return dexPairs[_pair];
428     }
429 
430     function addDexPair(address _pair) external onlyOwner {
431         require(!isDexPair(_pair), "Address is already on the dex list.");
432         dexPairs[_pair] = true;
433     }
434 
435     function removeDexPair(address _pair) external onlyOwner {
436         require(isDexPair(_pair), "Address is not a member of dex list.");
437         delete dexPairs[_pair];
438     }
439 }