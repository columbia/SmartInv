1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-09
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Interface for the optional metadata functions from the ERC20 standard.
106  *
107  * _Available since v4.1._
108  */
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 abstract contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor () {
148         address msgSender = _msgSender();
149         _owner = msgSender;
150         emit OwnershipTransferred(address(0), msgSender);
151     }
152 
153     /**
154      * @dev Returns the address of the current owner.
155      */
156     function owner() public view virtual returns (address) {
157         return _owner;
158     }
159 
160     /**
161      * @dev Throws if called by any account other than the owner.
162      */
163     modifier onlyOwner() {
164         require(owner() == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions anymore. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby removing any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     /**
181      * @dev Transfers ownership of the contract to a new account (`newOwner`).
182      * Can only be called by the current owner.
183      */
184     function transferOwnership(address newOwner) public virtual onlyOwner {
185         require(newOwner != address(0), "Ownable: new owner is the zero address");
186         emit OwnershipTransferred(_owner, newOwner);
187         _owner = newOwner;
188     }
189 }
190 
191 
192 contract PekkerToken is Context, IERC20, IERC20Metadata, Ownable {
193     
194     mapping (address => uint256) private _rOwned;
195     mapping (address => uint256) private _tOwned;
196     mapping (address => mapping (address => uint256)) private _allowances;
197 
198     mapping (address => bool) private _isExcluded;
199     address[] private _excluded;
200    
201     uint256 private constant MAX = ~uint256(0);
202     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
203     uint256 private _rTotal = (MAX - (MAX % _tTotal));
204     uint256 private _tFeeTotal;
205 
206     string private _name = 'Pekker Token';
207     string private _symbol = 'PKR';
208     uint8 private _decimals = 9;
209     
210     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
211 
212     constructor () {
213         _rOwned[_msgSender()] = _rTotal;
214         emit Transfer(address(0), _msgSender(), _tTotal);
215     }
216 
217     function name() public view override returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public view override returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public view override returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public view override returns (uint256) {
230         return _tTotal;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         if (_isExcluded[account]) return _tOwned[account];
235         return tokenFromReflection(_rOwned[account]);
236     }
237 
238     function transfer(address recipient, uint256 amount) public override returns (bool) {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     function allowance(address owner, address spender) public view override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     function approve(address spender, uint256 amount) public override returns (bool) {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
253         _transfer(sender, recipient, amount);
254         require(amount <= _allowances[sender][_msgSender()], "ERC20: transfer amount exceeds allowance");
255         _approve(sender, _msgSender(), _allowances[sender][_msgSender()]- amount);
256         return true;
257     }
258 
259     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
260         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
261         return true;
262     }
263 
264     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
265         require(subtractedValue <= _allowances[_msgSender()][spender], "ERC20: decreased allowance below zero");
266         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
267         return true;
268     }
269 
270     function isExcluded(address account) public view returns (bool) {
271         return _isExcluded[account];
272     }
273 
274     function totalFees() public view returns (uint256) {
275         return _tFeeTotal;
276     }
277     
278     
279     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
280         _maxTxAmount = ((_tTotal * maxTxPercent) / 10**2);
281     }
282 
283     function reflect(uint256 tAmount) public {
284         address sender = _msgSender();
285         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
286         (uint256 rAmount,,,,) = _getValues(tAmount);
287         _rOwned[sender] = _rOwned[sender] - rAmount;
288         _rTotal = _rTotal - rAmount;
289         _tFeeTotal = _tFeeTotal + tAmount;
290     }
291 
292     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
293         require(tAmount <= _tTotal, "Amount must be less than supply");
294         if (!deductTransferFee) {
295             (uint256 rAmount,,,,) = _getValues(tAmount);
296             return rAmount;
297         } else {
298             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
299             return rTransferAmount;
300         }
301     }
302 
303     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
304         require(rAmount <= _rTotal, "Amount must be less than total reflections");
305         uint256 currentRate =  _getRate();
306         return (rAmount / currentRate);
307     }
308 
309     function excludeAccount(address account) external onlyOwner() {
310         require(!_isExcluded[account], "Account is already excluded");
311         if(_rOwned[account] > 0) {
312             _tOwned[account] = tokenFromReflection(_rOwned[account]);
313         }
314         _isExcluded[account] = true;
315         _excluded.push(account);
316     }
317 
318     function includeAccount(address account) external onlyOwner() {
319         require(_isExcluded[account], "Account is already excluded");
320         for (uint256 i = 0; i < _excluded.length; i++) {
321             if (_excluded[i] == account) {
322                 _excluded[i] = _excluded[_excluded.length - 1];
323                 _tOwned[account] = 0;
324                 _isExcluded[account] = false;
325                 _excluded.pop();
326                 break;
327             }
328         }
329     }
330 
331     function _approve(address owner, address spender, uint256 amount) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334 
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338 
339     function _transfer(address sender, address recipient, uint256 amount) private {
340         require(sender != address(0), "ERC20: transfer from the zero address");
341         require(recipient != address(0), "ERC20: transfer to the zero address");
342         require(amount > 0, "Transfer amount must be greater than zero");
343         
344         if(sender != owner() && recipient != owner()) {
345           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
346         }
347             
348         if (_isExcluded[sender] && !_isExcluded[recipient]) {
349             _transferFromExcluded(sender, recipient, amount);
350         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
351             _transferToExcluded(sender, recipient, amount);
352         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
353             _transferStandard(sender, recipient, amount);
354         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
355             _transferBothExcluded(sender, recipient, amount);
356         } else {
357             _transferStandard(sender, recipient, amount);
358         }
359     }
360 
361     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
362         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
363         _rOwned[sender] = _rOwned[sender] - rAmount;
364         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;       
365         _reflectFee(rFee, tFee);
366         emit Transfer(sender, recipient, tTransferAmount);
367     }
368 
369     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
370         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
371         _rOwned[sender] = _rOwned[sender] - rAmount;
372         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
373         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;           
374         _reflectFee(rFee, tFee);
375         emit Transfer(sender, recipient, tTransferAmount);
376     }
377 
378     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
379         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
380         _tOwned[sender] = _tOwned[sender] - tAmount;
381         _rOwned[sender] = _rOwned[sender] - rAmount;
382         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;   
383         _reflectFee(rFee, tFee);
384         emit Transfer(sender, recipient, tTransferAmount);
385     }
386 
387     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
388         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
389         _tOwned[sender] = _tOwned[sender] - tAmount;
390         _rOwned[sender] = _rOwned[sender] - rAmount;
391         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
392         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;        
393         _reflectFee(rFee, tFee);
394         emit Transfer(sender, recipient, tTransferAmount);
395     }
396 
397     function _reflectFee(uint256 rFee, uint256 tFee) private {
398         _rTotal = _rTotal - rFee;
399         _tFeeTotal = _tFeeTotal + tFee;
400     }
401 
402     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
403         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
404         uint256 currentRate =  _getRate();
405         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
406         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
407     }
408 
409     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
410         uint256 tFee = ((tAmount / 100) * 2);
411         uint256 tTransferAmount = tAmount - tFee;
412         return (tTransferAmount, tFee);
413     }
414 
415     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
416         uint256 rAmount = tAmount * currentRate;
417         uint256 rFee = tFee * currentRate;
418         uint256 rTransferAmount = rAmount - rFee;
419         return (rAmount, rTransferAmount, rFee);
420     }
421 
422     function _getRate() private view returns(uint256) {
423         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
424         return (rSupply / tSupply);
425     }
426 
427     function _getCurrentSupply() private view returns(uint256, uint256) {
428         uint256 rSupply = _rTotal;
429         uint256 tSupply = _tTotal;      
430         for (uint256 i = 0; i < _excluded.length; i++) {
431             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
432             rSupply = rSupply - _rOwned[_excluded[i]];
433             tSupply = tSupply - _tOwned[_excluded[i]];
434         }
435         if (rSupply < (_rTotal / _tTotal)) return (_rTotal, _tTotal);
436         return (rSupply, tSupply);
437     }
438 }