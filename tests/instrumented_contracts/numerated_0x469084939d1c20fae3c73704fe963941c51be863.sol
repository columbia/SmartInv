1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.0; 
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  */
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 /**
23  * @dev Contract module which provides a basic access control mechanism, where
24  * there is an account (an owner) that can be granted exclusive access to
25  * specific functions.
26  *
27  * By default, the owner account will be the one that deploys the contract. This
28  * can later be changed with {transferOwnership}.
29  *
30  * This module is used through inheritance. It will make available the modifier
31  * `onlyOwner`, which can be applied to your functions to restrict their use to
32  * the owner.
33  */
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev Initializes the contract setting the deployer as the initial owner.
41      */
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46     /**
47      * @dev Returns the address of the current owner.
48      */
49     function owner() public view virtual returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(owner() == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     /**
62      * @dev Leaves the contract without owner. It will not be possible to call
63      * `onlyOwner` functions anymore. Can only be called by the current owner.
64      *
65      * NOTE: Renouncing ownership will leave the contract without an owner,
66      * thereby removing any functionality that is only available to the owner.
67      */
68     function renounceOwnership() public virtual onlyOwner {
69         _transferOwnership(address(0));
70     }
71 
72     /**
73      * @dev Transfers ownership of the contract to a new account (`newOwner`).
74      * Can only be called by the current owner.
75      */
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         _transferOwnership(newOwner);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Internal function without access restriction.
84      */
85     function _transferOwnership(address newOwner) internal virtual {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 /**
93  * @dev Interface of the ERC20 standard as defined in the EIP.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) external returns (bool);
154 
155     /**
156      * @dev Emitted when `value` tokens are moved from one account (`from`) to
157      * another (`to`).
158      *
159      * Note that `value` may be zero.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     /**
164      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
165      * a call to {approve}. `value` is the new allowance.
166      */
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 
171 /**
172  * @dev Interface for the optional metadata functions from the ERC20 standard.
173  */
174 interface IERC20Metadata is IERC20 {
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() external view returns (string memory);
179 
180     /**
181      * @dev Returns the symbol of the token.
182      */
183     function symbol() external view returns (string memory);
184 
185     /**
186      * @dev Returns the decimals places of the token.
187      */
188     function decimals() external view returns (uint8);
189 }
190 /**
191  * @dev Implementation of the DGMV Token
192  *  
193  */
194 contract Envision is Ownable, IERC20, IERC20Metadata {
195     mapping(address => uint256) private _balances;
196     mapping (address => bool) private _isExcludedFromFee;
197     mapping(address => mapping(address => uint256)) private _allowances;
198 
199     string constant private _name = "Envision";
200     string constant private _symbol = "VIS";
201     uint8  constant private _decimal = 18;
202     uint256 private _totalSupply = 200000000 * (10 ** _decimal); // 200 million tokens
203     uint256 constant public _taxBurn = 2;
204     uint256 constant public _taxLiquidity = 5;
205     address public teamWallet;
206     uint256 public toBurnAmount = 0;
207 
208     event teamWalletChanged(address oldWalletAddress, address newWalletAddress);
209     event feeCollected(address teamWallet, uint256 amount);
210     event excludingAddressFromFee(address account);
211     event includingAddressInFee(address account);
212 
213     modifier onlyTeamWallet() {
214         require(teamWallet == _msgSender(), "Caller is not the teamwallet");
215         _;
216     }
217 
218     
219     /**
220      * @dev Sets the values for {name}, {symbol}, {total supply} and {decimal}.
221      * Currently teamWallet will be Owner and can be changed later
222      */
223     constructor(address _teamWallet) {
224         require(_teamWallet!=address(0), "Cannot set teamwallet as zero address");
225         _balances[_msgSender()] = _totalSupply;
226         _isExcludedFromFee[_msgSender()] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[_teamWallet] = true;
229         teamWallet = _teamWallet;  
230         emit Transfer(address(0), _msgSender(), _totalSupply);
231     }
232     
233     /**
234      * @dev Returns Name of the token
235      */
236     function name() external view virtual override returns (string memory) {
237         return _name;
238     }
239     
240     /**
241      * @dev Returns the symbol of the token, usually a shorter version of the name.
242      */
243     function symbol() external view virtual override returns (string memory) {
244         return _symbol;
245     }
246     
247     /**
248      * @dev Returns the number of decimals used to get its user representation
249      */
250     function decimals() external view virtual override returns (uint8) {
251         return _decimal;
252     }
253     
254     /**
255      * @dev This will give the total number of tokens in existence.
256      */
257     function totalSupply() external view virtual override returns (uint256) {
258         return _totalSupply;
259     }
260     
261     /**
262      * @dev Gets the balance of the specified address.
263      */
264     function balanceOf(address account) external view virtual override returns (uint256) {
265         return _balances[account];
266     }
267     
268     /**
269      * @dev Returns collected fees of the token
270      */
271     function collectedFees() external view returns (uint256) {
272         return _balances[address(this)];
273     }
274 
275     /**
276      * @dev Transfer token to a specified address and Emits a Transfer event.
277      */
278     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
279         _transfer(_msgSender(), recipient, amount);
280         return true;
281     }
282     
283     /**
284      * @dev Function to check the number of tokens that an owner allowed to a spender
285      */
286     function allowance(address owner, address spender) external view virtual override returns (uint256) {
287         return _allowances[owner][spender];
288     }
289     
290     /**
291      * @dev Function to allow anyone to spend a token from your account and Emits an Approval event.
292      */
293     function approve(address spender, uint256 amount) external virtual override returns (bool) {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297     /**
298      * @dev owner can make exclude the account from paying fee on transfer
299      */
300     function excludeFromFee(address account) external onlyOwner {
301         require(account!=address(0), "Excluding for the zero address");
302         _isExcludedFromFee[account] = true;
303         emit excludingAddressFromFee(account);
304     }
305     /**
306      * @dev check if account is excluded from fee
307      */
308     function isExcludedFromFee(address account) external view returns(bool) {
309         return _isExcludedFromFee[account];
310     }
311 
312     /**
313      * @dev owner can make the account pay fee on transfer.
314      */
315     function includeInFee(address account) external onlyOwner {
316         require(account!=address(0), "Including for the zero address");
317         _isExcludedFromFee[account] = false;
318         emit includingAddressInFee(account);
319     }
320 
321     /**
322      * @dev owner can claim collected fees.
323      */
324     function collectFees() external onlyOwner {
325         uint256 fees = _balances[address(this)];
326         _transfer(address(this), teamWallet, _balances[address(this)]);
327         emit feeCollected(teamWallet, fees);
328     }
329 
330     /**
331      * @dev teamWallet can burn collected burn fees.
332      */
333     function burnCollectedFees() external onlyTeamWallet {
334         require(_balances[teamWallet] >= toBurnAmount, "Does not have the required amount of tokens to burn");
335         _transfer(teamWallet, address(0), toBurnAmount);
336         _totalSupply -= toBurnAmount;
337         toBurnAmount = 0;
338         emit feeCollected(address(0), toBurnAmount);
339     }
340 
341     /**
342      * @dev owner can update the collection team wallet
343      */
344     function updateTeamWallet(address _teamWallet) external onlyOwner {
345         require(_teamWallet!=address(0), "Cannot set teamwallet as zero address");
346         address oldWallet = teamWallet;
347         teamWallet =  _teamWallet;
348         _isExcludedFromFee[_teamWallet] = true;
349         _isExcludedFromFee[oldWallet] = false;
350         emit teamWalletChanged(oldWallet,_teamWallet);
351     }
352     
353     /**
354      * @dev Function to transfer allowed token from other's account
355      */
356     function transferFrom(
357         address sender,
358         address recipient,
359         uint256 amount
360     ) external virtual override returns (bool) {
361         _transfer(sender, recipient, amount);
362 
363         uint256 currentAllowance = _allowances[sender][_msgSender()];
364         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
365         unchecked {
366             _approve(sender, _msgSender(), currentAllowance - amount);
367         }
368 
369         return true;
370     }
371     
372     /**
373      * @dev Function to increase the allowance of another account
374      */
375     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
376         require(spender!=address(0), "Increasing allowance for zero address");
377         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
378         return true;
379     }
380     
381     /**
382      * @dev Function to decrease the allowance of another account
383      */
384     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
385         require(spender!=address(0), "Decreasing allowance for zero address");
386         uint256 currentAllowance = _allowances[_msgSender()][spender];
387         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
388         unchecked {
389             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
390         }
391         return true;
392     }
393     
394     function _transfer(
395         address sender,
396         address recipient,
397         uint256 amount
398     ) internal virtual {
399         uint256 senderBalance = _balances[sender];
400         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
401         unchecked {
402             _balances[sender] = senderBalance - amount;
403         }
404         if(_isExcludedFromFee[sender]) {
405             unchecked {//condititon to exclude
406                 _balances[recipient] += amount;
407             }
408         }else{ 
409             unchecked {
410                 uint256 burnFee =  (amount * _taxBurn) / 1000;
411                 uint256 tFee = (amount * (_taxBurn + _taxLiquidity)) / 1000;
412                 amount = amount - tFee;
413                 _balances[recipient] += amount;
414                 _balances[address(this)] +=  tFee;
415                 toBurnAmount += burnFee;
416             }
417         }
418         emit Transfer(sender, recipient, amount);
419     }
420 
421     function _approve(
422         address owner,
423         address spender,
424         uint256 amount
425     ) internal virtual {
426         require(owner != address(0), "ERC20: approve from the zero address");
427         require(spender != address(0), "ERC20: approve to the zero address");
428 
429         _allowances[owner][spender] = amount;
430         emit Approval(owner, spender, amount);
431     } 
432 }