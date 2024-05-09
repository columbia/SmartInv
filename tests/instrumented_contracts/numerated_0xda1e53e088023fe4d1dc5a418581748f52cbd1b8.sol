1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /**
101  * @dev Interface for the optional metadata functions from the ERC20 standard.
102  *
103  * _Available since v4.1._
104  */
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor () {
144         address msgSender = _msgSender();
145         _owner = msgSender;
146         emit OwnershipTransferred(address(0), msgSender);
147     }
148 
149     /**
150      * @dev Returns the address of the current owner.
151      */
152     function owner() public view virtual returns (address) {
153         return _owner;
154     }
155 
156     /**
157      * @dev Throws if called by any account other than the owner.
158      */
159     modifier onlyOwner() {
160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
161         _;
162     }
163 
164     /**
165      * @dev Leaves the contract without owner. It will not be possible to call
166      * `onlyOwner` functions anymore. Can only be called by the current owner.
167      *
168      * NOTE: Renouncing ownership will leave the contract without an owner,
169      * thereby removing any functionality that is only available to the owner.
170      */
171     function renounceOwnership() public virtual onlyOwner {
172         emit OwnershipTransferred(_owner, address(0));
173         _owner = address(0);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Can only be called by the current owner.
179      */
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 
188 contract AidiInu is Context, IERC20, IERC20Metadata, Ownable {
189     
190     mapping (address => uint256) private _rOwned;
191     mapping (address => uint256) private _tOwned;
192     mapping (address => mapping (address => uint256)) private _allowances;
193 
194     mapping (address => bool) private _isExcluded;
195     address[] private _excluded;
196    
197     uint256 private constant MAX = ~uint256(0);
198     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
199     uint256 private _rTotal = (MAX - (MAX % _tTotal));
200     uint256 private _tFeeTotal;
201 
202     string private _name = 'Aidi Inu';
203     string private _symbol = 'AIDI';
204     uint8 private _decimals = 9;
205     
206     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
207 
208     constructor () {
209         _rOwned[_msgSender()] = _rTotal;
210         emit Transfer(address(0), _msgSender(), _tTotal);
211     }
212 
213     function name() public view override returns (string memory) {
214         return _name;
215     }
216 
217     function symbol() public view override returns (string memory) {
218         return _symbol;
219     }
220 
221     function decimals() public view override returns (uint8) {
222         return _decimals;
223     }
224 
225     function totalSupply() public view override returns (uint256) {
226         return _tTotal;
227     }
228 
229     function balanceOf(address account) public view override returns (uint256) {
230         if (_isExcluded[account]) return _tOwned[account];
231         return tokenFromReflection(_rOwned[account]);
232     }
233 
234     function transfer(address recipient, uint256 amount) public override returns (bool) {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     function allowance(address owner, address spender) public view override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(address spender, uint256 amount) public override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
249         _transfer(sender, recipient, amount);
250         require(amount <= _allowances[sender][_msgSender()], "ERC20: transfer amount exceeds allowance");
251         _approve(sender, _msgSender(), _allowances[sender][_msgSender()]- amount);
252         return true;
253     }
254 
255     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
256         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
257         return true;
258     }
259 
260     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
261         require(subtractedValue <= _allowances[_msgSender()][spender], "ERC20: decreased allowance below zero");
262         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
263         return true;
264     }
265 
266     function isExcluded(address account) public view returns (bool) {
267         return _isExcluded[account];
268     }
269 
270     function totalFees() public view returns (uint256) {
271         return _tFeeTotal;
272     }
273     
274     
275     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
276         _maxTxAmount = ((_tTotal * maxTxPercent) / 10**2);
277     }
278 
279     function reflect(uint256 tAmount) public {
280         address sender = _msgSender();
281         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
282         (uint256 rAmount,,,,) = _getValues(tAmount);
283         _rOwned[sender] = _rOwned[sender] - rAmount;
284         _rTotal = _rTotal - rAmount;
285         _tFeeTotal = _tFeeTotal + tAmount;
286     }
287 
288     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
289         require(tAmount <= _tTotal, "Amount must be less than supply");
290         if (!deductTransferFee) {
291             (uint256 rAmount,,,,) = _getValues(tAmount);
292             return rAmount;
293         } else {
294             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
295             return rTransferAmount;
296         }
297     }
298 
299     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
300         require(rAmount <= _rTotal, "Amount must be less than total reflections");
301         uint256 currentRate =  _getRate();
302         return (rAmount / currentRate);
303     }
304 
305     function excludeAccount(address account) external onlyOwner() {
306         require(!_isExcluded[account], "Account is already excluded");
307         if(_rOwned[account] > 0) {
308             _tOwned[account] = tokenFromReflection(_rOwned[account]);
309         }
310         _isExcluded[account] = true;
311         _excluded.push(account);
312     }
313 
314     function includeAccount(address account) external onlyOwner() {
315         require(_isExcluded[account], "Account is already excluded");
316         for (uint256 i = 0; i < _excluded.length; i++) {
317             if (_excluded[i] == account) {
318                 _excluded[i] = _excluded[_excluded.length - 1];
319                 _tOwned[account] = 0;
320                 _isExcluded[account] = false;
321                 _excluded.pop();
322                 break;
323             }
324         }
325     }
326 
327     function _approve(address owner, address spender, uint256 amount) private {
328         require(owner != address(0), "ERC20: approve from the zero address");
329         require(spender != address(0), "ERC20: approve to the zero address");
330 
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335     function _transfer(address sender, address recipient, uint256 amount) private {
336         require(sender != address(0), "ERC20: transfer from the zero address");
337         require(recipient != address(0), "ERC20: transfer to the zero address");
338         require(amount > 0, "Transfer amount must be greater than zero");
339         
340         if(sender != owner() && recipient != owner()) {
341           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
342         }
343             
344         if (_isExcluded[sender] && !_isExcluded[recipient]) {
345             _transferFromExcluded(sender, recipient, amount);
346         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
347             _transferToExcluded(sender, recipient, amount);
348         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
349             _transferStandard(sender, recipient, amount);
350         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
351             _transferBothExcluded(sender, recipient, amount);
352         } else {
353             _transferStandard(sender, recipient, amount);
354         }
355     }
356 
357     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
358         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
359         _rOwned[sender] = _rOwned[sender] - rAmount;
360         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;       
361         _reflectFee(rFee, tFee);
362         emit Transfer(sender, recipient, tTransferAmount);
363     }
364 
365     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
366         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
367         _rOwned[sender] = _rOwned[sender] - rAmount;
368         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
369         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;           
370         _reflectFee(rFee, tFee);
371         emit Transfer(sender, recipient, tTransferAmount);
372     }
373 
374     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
375         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
376         _tOwned[sender] = _tOwned[sender] - tAmount;
377         _rOwned[sender] = _rOwned[sender] - rAmount;
378         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;   
379         _reflectFee(rFee, tFee);
380         emit Transfer(sender, recipient, tTransferAmount);
381     }
382 
383     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
384         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
385         _tOwned[sender] = _tOwned[sender] - tAmount;
386         _rOwned[sender] = _rOwned[sender] - rAmount;
387         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
388         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;        
389         _reflectFee(rFee, tFee);
390         emit Transfer(sender, recipient, tTransferAmount);
391     }
392 
393     function _reflectFee(uint256 rFee, uint256 tFee) private {
394         _rTotal = _rTotal - rFee;
395         _tFeeTotal = _tFeeTotal + tFee;
396     }
397 
398     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
399         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
400         uint256 currentRate =  _getRate();
401         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
402         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
403     }
404 
405     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
406         uint256 tFee = ((tAmount / 100) * 2);
407         uint256 tTransferAmount = tAmount - tFee;
408         return (tTransferAmount, tFee);
409     }
410 
411     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
412         uint256 rAmount = tAmount * currentRate;
413         uint256 rFee = tFee * currentRate;
414         uint256 rTransferAmount = rAmount - rFee;
415         return (rAmount, rTransferAmount, rFee);
416     }
417 
418     function _getRate() private view returns(uint256) {
419         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
420         return (rSupply / tSupply);
421     }
422 
423     function _getCurrentSupply() private view returns(uint256, uint256) {
424         uint256 rSupply = _rTotal;
425         uint256 tSupply = _tTotal;      
426         for (uint256 i = 0; i < _excluded.length; i++) {
427             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
428             rSupply = rSupply - _rOwned[_excluded[i]];
429             tSupply = tSupply - _tOwned[_excluded[i]];
430         }
431         if (rSupply < (_rTotal / _tTotal)) return (_rTotal, _tTotal);
432         return (rSupply, tSupply);
433     }
434 }