1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-07
3 */
4 
5 pragma solidity ^0.6.0;
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this;
13         return msg.data;
14     }
15 }
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
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39 
40         return c;
41     }
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49 
50         return c;
51     }
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         return mod(a, b, "SafeMath: modulo by zero");
62     }
63     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b != 0, errorMessage);
65         return a % b;
66     }
67 }
68 library Address {
69     function isContract(address account) internal view returns (bool) {
70         bytes32 codehash;
71         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
72         // solhint-disable-next-line no-inline-assembly
73         assembly { codehash := extcodehash(account) }
74         return (codehash != accountHash && codehash != 0x0);
75     }
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
80         (bool success, ) = recipient.call{ value: amount }("");
81         require(success, "Address: unable to send value, recipient may have reverted");
82     }
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
87         return _functionCallWithValue(target, data, 0, errorMessage);
88     }
89     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
91     }
92     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
93         require(address(this).balance >= value, "Address: insufficient balance for call");
94         return _functionCallWithValue(target, data, value, errorMessage);
95     }
96 
97     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
98         require(isContract(target), "Address: call to non-contract");
99 
100         // solhint-disable-next-line avoid-low-level-calls
101         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
102         if (success) {
103             return returndata;
104         } else {
105             if (returndata.length > 0) {
106                 // solhint-disable-next-line no-inline-assembly
107                 assembly {
108                     let returndata_size := mload(returndata)
109                     revert(add(32, returndata), returndata_size)
110                 }
111             } else {
112                 revert(errorMessage);
113             }
114         }
115     }
116 }
117 contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121     constructor () internal {
122         address msgSender = _msgSender();
123         _owner = msgSender;
124         emit OwnershipTransferred(address(0), msgSender);
125     }
126     function owner() public view returns (address) {
127         return _owner;
128     }
129     modifier onlyOwner() {
130         require(_owner == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133     function renounceOwnership() public virtual onlyOwner {
134         emit OwnershipTransferred(_owner, address(0));
135         _owner = address(0);
136     }
137     function transferOwnership(address newOwner) public virtual onlyOwner {
138         require(newOwner != address(0), "Ownable: new owner is the zero address");
139         emit OwnershipTransferred(_owner, newOwner);
140         _owner = newOwner;
141     }
142 }
143 
144 /*
145  * Copyright 2020 reflect.finance. ALL RIGHTS RESERVED.
146  */
147  
148 /*
149  * forked 2020 reflectreflect.finance. NO RIGHTS RESERVED.
150  */
151 
152 pragma solidity ^0.6.2;
153 
154 
155 
156 
157 
158 
159 contract RFY is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161     using Address for address;
162 
163     mapping (address => uint256) private _rOwned;
164     mapping (address => uint256) private _tOwned;
165     mapping (address => mapping (address => uint256)) private _allowances;
166 
167     mapping (address => bool) private _isExcluded;
168     address[] private _excluded;
169    
170     uint256 private constant MAX = ~uint256(0);
171     uint256 private constant _tTotal = 1 * 10**6 * 10**9;
172     uint256 private _rTotal = (MAX - (MAX % _tTotal));
173     uint256 private _tFeeTotal;
174 
175     string private _name = 'RFYIELD.FINANCE';
176     string private _symbol = 'RFY';
177     uint8 private _decimals = 9;
178     
179     uint private _transactionFee = 1;
180 
181     constructor () public {
182         _rOwned[_msgSender()] = _rTotal;
183         emit Transfer(address(0), _msgSender(), _tTotal);
184     }
185 
186     function name() public view returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public view returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public view returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public view override returns (uint256) {
199         return _tTotal;
200     }
201 
202     function balanceOf(address account) public view override returns (uint256) {
203         if (_isExcluded[account]) return _tOwned[account];
204         return tokenFromReflection(_rOwned[account]);
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
224         return true;
225     }
226 
227     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
228         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
229         return true;
230     }
231 
232     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
233         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
234         return true;
235     }
236 
237     function isExcluded(address account) public view returns (bool) {
238         return _isExcluded[account];
239     }
240 
241     function totalFees() public view returns (uint256) {
242         return _tFeeTotal;
243     }
244 
245     function reflect(uint256 tAmount) public {
246         address sender = _msgSender();
247         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
248         (uint256 rAmount,,,,) = _getValues(tAmount);
249         _rOwned[sender] = _rOwned[sender].sub(rAmount);
250         _rTotal = _rTotal.sub(rAmount);
251         _tFeeTotal = _tFeeTotal.add(tAmount);
252     }
253 
254     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
255         require(tAmount <= _tTotal, "Amount must be less than supply");
256         if (!deductTransferFee) {
257             (uint256 rAmount,,,,) = _getValues(tAmount);
258             return rAmount;
259         } else {
260             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
261             return rTransferAmount;
262         }
263     }
264 
265     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
266         require(rAmount <= _rTotal, "Amount must be less than total reflections");
267         uint256 currentRate =  _getRate();
268         return rAmount.div(currentRate);
269     }
270 
271     function excludeAccount(address account) external onlyOwner() {
272         require(!_isExcluded[account], "Account is already excluded");
273         if(_rOwned[account] > 0) {
274             _tOwned[account] = tokenFromReflection(_rOwned[account]);
275         }
276         _isExcluded[account] = true;
277         _excluded.push(account);
278     }
279 
280     function includeAccount(address account) external onlyOwner() {
281         require(_isExcluded[account], "Account is already excluded");
282         for (uint256 i = 0; i < _excluded.length; i++) {
283             if (_excluded[i] == account) {
284                 _excluded[i] = _excluded[_excluded.length - 1];
285                 _tOwned[account] = 0;
286                 _isExcluded[account] = false;
287                 _excluded.pop();
288                 break;
289             }
290         }
291     }
292 
293     function _approve(address owner, address spender, uint256 amount) private {
294         require(owner != address(0), "ERC20: approve from the zero address");
295         require(spender != address(0), "ERC20: approve to the zero address");
296 
297         _allowances[owner][spender] = amount;
298         emit Approval(owner, spender, amount);
299     }
300 
301     function _transfer(address sender, address recipient, uint256 amount) private {
302         require(sender != address(0), "ERC20: transfer from the zero address");
303         require(recipient != address(0), "ERC20: transfer to the zero address");
304         require(amount > 0, "Transfer amount must be greater than zero");
305         if (_isExcluded[sender] && !_isExcluded[recipient]) {
306             _transferFromExcluded(sender, recipient, amount);
307         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
308             _transferToExcluded(sender, recipient, amount);
309         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
310             _transferStandard(sender, recipient, amount);
311         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
312             _transferBothExcluded(sender, recipient, amount);
313         } else {
314             _transferStandard(sender, recipient, amount);
315         }
316     }
317 
318     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
319         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
320         _rOwned[sender] = _rOwned[sender].sub(rAmount);
321         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
322         _reflectFee(rFee, tFee);
323         emit Transfer(sender, recipient, tTransferAmount);
324     }
325 
326     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
327         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
328         _rOwned[sender] = _rOwned[sender].sub(rAmount);
329         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
330         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
331         _reflectFee(rFee, tFee);
332         emit Transfer(sender, recipient, tTransferAmount);
333     }
334 
335     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
336         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
337         _tOwned[sender] = _tOwned[sender].sub(tAmount);
338         _rOwned[sender] = _rOwned[sender].sub(rAmount);
339         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
340         _reflectFee(rFee, tFee);
341         emit Transfer(sender, recipient, tTransferAmount);
342     }
343 
344     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
345         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
346         _tOwned[sender] = _tOwned[sender].sub(tAmount);
347         _rOwned[sender] = _rOwned[sender].sub(rAmount);
348         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
349         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
350         _reflectFee(rFee, tFee);
351         emit Transfer(sender, recipient, tTransferAmount);
352     }
353 
354     function _reflectFee(uint256 rFee, uint256 tFee) private {
355         _rTotal = _rTotal.sub(rFee);
356         _tFeeTotal = _tFeeTotal.add(tFee);
357     }
358 
359     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
360         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, _transactionFee);
361         uint256 currentRate =  _getRate();
362         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
363         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
364     }
365     
366     function _amendFee(uint256 tFeeAmended) external onlyOwner{
367         require(tFeeAmended < 8, "Tax cannot be greater than 7 percent");
368         _transactionFee = tFeeAmended;
369     }
370 
371     function _getTValues(uint256 tAmount, uint256 _tFee) private pure returns (uint256, uint256) {
372         uint256 tFee = tAmount.mul(_tFee).div(100);
373         uint256 tTransferAmount = tAmount.sub(tFee);
374         return (tTransferAmount, tFee);
375     }
376 
377     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
378         uint256 rAmount = tAmount.mul(currentRate);
379         uint256 rFee = tFee.mul(currentRate);
380         uint256 rTransferAmount = rAmount.sub(rFee);
381         return (rAmount, rTransferAmount, rFee);
382     }
383 
384     function _getRate() private view returns(uint256) {
385         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
386         return rSupply.div(tSupply);
387     }
388     
389     function _getTransactionFee() public view returns(uint256) {
390         return _transactionFee;
391     }
392 
393 
394     function _getCurrentSupply() private view returns(uint256, uint256) {
395         uint256 rSupply = _rTotal;
396         uint256 tSupply = _tTotal;      
397         for (uint256 i = 0; i < _excluded.length; i++) {
398             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
399             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
400             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
401         }
402         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
403         return (rSupply, tSupply);
404     }
405 }