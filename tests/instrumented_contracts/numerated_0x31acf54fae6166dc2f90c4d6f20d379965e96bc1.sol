1 pragma solidity ^0.6.0;
2 abstract contract Context {
3     function _msgSender() internal view virtual returns (address payable) {
4         return msg.sender;
5     }
6 
7     function _msgData() internal view virtual returns (bytes memory) {
8         this;
9         return msg.data;
10     }
11 }
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
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
64 library Address {
65     function isContract(address account) internal view returns (bool) {
66         bytes32 codehash;
67         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
68         // solhint-disable-next-line no-inline-assembly
69         assembly { codehash := extcodehash(account) }
70         return (codehash != accountHash && codehash != 0x0);
71     }
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
76         (bool success, ) = recipient.call{ value: amount }("");
77         require(success, "Address: unable to send value, recipient may have reverted");
78     }
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
83         return _functionCallWithValue(target, data, 0, errorMessage);
84     }
85     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
86         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
87     }
88     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
89         require(address(this).balance >= value, "Address: insufficient balance for call");
90         return _functionCallWithValue(target, data, value, errorMessage);
91     }
92 
93     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
94         require(isContract(target), "Address: call to non-contract");
95 
96         // solhint-disable-next-line avoid-low-level-calls
97         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
98         if (success) {
99             return returndata;
100         } else {
101             if (returndata.length > 0) {
102                 // solhint-disable-next-line no-inline-assembly
103                 assembly {
104                     let returndata_size := mload(returndata)
105                     revert(add(32, returndata), returndata_size)
106                 }
107             } else {
108                 revert(errorMessage);
109             }
110         }
111     }
112 }
113 contract Ownable is Context {
114     address private _owner;
115 
116     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
117     constructor () internal {
118         address msgSender = _msgSender();
119         _owner = msgSender;
120         emit OwnershipTransferred(address(0), msgSender);
121     }
122     function owner() public view returns (address) {
123         return _owner;
124     }
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129     function renounceOwnership() public virtual onlyOwner {
130         emit OwnershipTransferred(_owner, address(0));
131         _owner = address(0);
132     }
133     function transferOwnership(address newOwner) public virtual onlyOwner {
134         require(newOwner != address(0), "Ownable: new owner is the zero address");
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 /*
141  * Copyright 2020 reflect.finance. ALL RIGHTS RESERVED.
142  */
143  
144 /*
145  * forked 2020 reflectreflect.finance. NO RIGHTS RESERVED.
146  */
147 
148 pragma solidity ^0.6.2;
149 
150 
151 
152 
153 
154 
155 contract REFLECT is Context, IERC20, Ownable {
156     using SafeMath for uint256;
157     using Address for address;
158 
159     mapping (address => uint256) private _rOwned;
160     mapping (address => uint256) private _tOwned;
161     mapping (address => mapping (address => uint256)) private _allowances;
162 
163     mapping (address => bool) private _isExcluded;
164     address[] private _excluded;
165    
166     uint256 private constant MAX = ~uint256(0);
167     uint256 private constant _tTotal = 1 * 10**6 * 10**9;
168     uint256 private _rTotal = (MAX - (MAX % _tTotal));
169     uint256 private _tFeeTotal;
170 
171     string private _name = 'reflectreflect.finance';
172     string private _symbol = 'RFII';
173     uint8 private _decimals = 9;
174 
175     constructor () public {
176         _rOwned[_msgSender()] = _rTotal;
177         emit Transfer(address(0), _msgSender(), _tTotal);
178     }
179 
180     function name() public view returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public view returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public view returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public view override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         if (_isExcluded[account]) return _tOwned[account];
198         return tokenFromReflection(_rOwned[account]);
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
222         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
223         return true;
224     }
225 
226     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
227         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
228         return true;
229     }
230 
231     function isExcluded(address account) public view returns (bool) {
232         return _isExcluded[account];
233     }
234 
235     function totalFees() public view returns (uint256) {
236         return _tFeeTotal;
237     }
238 
239     function reflect(uint256 tAmount) public {
240         address sender = _msgSender();
241         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
242         (uint256 rAmount,,,,) = _getValues(tAmount);
243         _rOwned[sender] = _rOwned[sender].sub(rAmount);
244         _rTotal = _rTotal.sub(rAmount);
245         _tFeeTotal = _tFeeTotal.add(tAmount);
246     }
247 
248     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
249         require(tAmount <= _tTotal, "Amount must be less than supply");
250         if (!deductTransferFee) {
251             (uint256 rAmount,,,,) = _getValues(tAmount);
252             return rAmount;
253         } else {
254             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
255             return rTransferAmount;
256         }
257     }
258 
259     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
260         require(rAmount <= _rTotal, "Amount must be less than total reflections");
261         uint256 currentRate =  _getRate();
262         return rAmount.div(currentRate);
263     }
264 
265     function excludeAccount(address account) external onlyOwner() {
266         require(!_isExcluded[account], "Account is already excluded");
267         if(_rOwned[account] > 0) {
268             _tOwned[account] = tokenFromReflection(_rOwned[account]);
269         }
270         _isExcluded[account] = true;
271         _excluded.push(account);
272     }
273 
274     function includeAccount(address account) external onlyOwner() {
275         require(_isExcluded[account], "Account is already excluded");
276         for (uint256 i = 0; i < _excluded.length; i++) {
277             if (_excluded[i] == account) {
278                 _excluded[i] = _excluded[_excluded.length - 1];
279                 _tOwned[account] = 0;
280                 _isExcluded[account] = false;
281                 _excluded.pop();
282                 break;
283             }
284         }
285     }
286 
287     function _approve(address owner, address spender, uint256 amount) private {
288         require(owner != address(0), "ERC20: approve from the zero address");
289         require(spender != address(0), "ERC20: approve to the zero address");
290 
291         _allowances[owner][spender] = amount;
292         emit Approval(owner, spender, amount);
293     }
294 
295     function _transfer(address sender, address recipient, uint256 amount) private {
296         require(sender != address(0), "ERC20: transfer from the zero address");
297         require(recipient != address(0), "ERC20: transfer to the zero address");
298         require(amount > 0, "Transfer amount must be greater than zero");
299         if (_isExcluded[sender] && !_isExcluded[recipient]) {
300             _transferFromExcluded(sender, recipient, amount);
301         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
302             _transferToExcluded(sender, recipient, amount);
303         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
304             _transferStandard(sender, recipient, amount);
305         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
306             _transferBothExcluded(sender, recipient, amount);
307         } else {
308             _transferStandard(sender, recipient, amount);
309         }
310     }
311 
312     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
313         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
314         _rOwned[sender] = _rOwned[sender].sub(rAmount);
315         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
316         _reflectFee(rFee, tFee);
317         emit Transfer(sender, recipient, tTransferAmount);
318     }
319 
320     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
321         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
322         _rOwned[sender] = _rOwned[sender].sub(rAmount);
323         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
324         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
325         _reflectFee(rFee, tFee);
326         emit Transfer(sender, recipient, tTransferAmount);
327     }
328 
329     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
330         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
331         _tOwned[sender] = _tOwned[sender].sub(tAmount);
332         _rOwned[sender] = _rOwned[sender].sub(rAmount);
333         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
334         _reflectFee(rFee, tFee);
335         emit Transfer(sender, recipient, tTransferAmount);
336     }
337 
338     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
339         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
340         _tOwned[sender] = _tOwned[sender].sub(tAmount);
341         _rOwned[sender] = _rOwned[sender].sub(rAmount);
342         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
343         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
344         _reflectFee(rFee, tFee);
345         emit Transfer(sender, recipient, tTransferAmount);
346     }
347 
348     function _reflectFee(uint256 rFee, uint256 tFee) private {
349         _rTotal = _rTotal.sub(rFee);
350         _tFeeTotal = _tFeeTotal.add(tFee);
351     }
352 
353     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
354         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
355         uint256 currentRate =  _getRate();
356         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
357         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
358     }
359 
360     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
361         uint256 tFee = tAmount.div(100);
362         uint256 tTransferAmount = tAmount.sub(tFee);
363         return (tTransferAmount, tFee);
364     }
365 
366     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
367         uint256 rAmount = tAmount.mul(currentRate);
368         uint256 rFee = tFee.mul(currentRate);
369         uint256 rTransferAmount = rAmount.sub(rFee);
370         return (rAmount, rTransferAmount, rFee);
371     }
372 
373     function _getRate() private view returns(uint256) {
374         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
375         return rSupply.div(tSupply);
376     }
377 
378     function _getCurrentSupply() private view returns(uint256, uint256) {
379         uint256 rSupply = _rTotal;
380         uint256 tSupply = _tTotal;      
381         for (uint256 i = 0; i < _excluded.length; i++) {
382             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
383             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
384             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
385         }
386         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
387         return (rSupply, tSupply);
388     }
389 }