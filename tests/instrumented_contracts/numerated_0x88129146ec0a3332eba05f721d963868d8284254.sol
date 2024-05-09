1 // SPDX-License-Identifier: MIT
2 
3 /**
4 * @title Utility Token of the Integrated Monetary Exchange (IMX).
5 * @author - IMX Developement Community & OpenMEV contributors.
6 * In Assoc. with Manifold Finance & SushiSwap Protocol
7 */
8 pragma solidity 0.8.0; 
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
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
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 
164 /**
165  * @dev Interface for optional metadata functions from the ERC20 standard.
166  */
167 interface IERC20Metadata is IERC20 {
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() external view returns (string memory);
172 
173     /**
174      * @dev Returns the symbol of the token.
175      */
176     function symbol() external view returns (string memory);
177 
178     /**
179      * @dev Returns the decimals places of the token.
180      */
181     function decimals() external view returns (uint8);
182 }
183 
184 contract IMX is Ownable, IERC20, IERC20Metadata {
185     mapping(address => uint256) private _balances;
186     mapping (address => bool) private _isExcludedFromFee;
187     mapping(address => mapping(address => uint256)) private _allowances;
188 
189     string constant private _name = "IMX";
190     string constant private _symbol = "IMX";
191     uint8  constant private _decimal = 18;
192     uint256 private _totalSupply = 100000000 * (10 ** _decimal); // 100 million tokens
193     uint256 constant public _taxBurn = 4;
194     uint256 constant public _taxLiquidity = 6;
195     address public teamWallet;
196     uint256 public toBurnAmount = 0;
197 
198     event teamWalletChanged(address oldWalletAddress, address newWalletAddress);
199     event feeCollected(address teamWallet, uint256 amount);
200     event excludingAddressFromFee(address account);
201     event includingAddressInFee(address account);
202 
203     modifier onlyTeamWallet() {
204         require(teamWallet == _msgSender(), "Caller is not the teamwallet");
205         _;
206     }
207 
208     /**
209      * @dev Sets the values for {name}, {symbol}, {total supply} and {decimal}.
210      * Currently teamWallet will be Owner and can be changed later
211      */
212     constructor(address _teamWallet) {
213         require(_teamWallet!=address(0), "Cannot set teamwallet as zero address");
214         _balances[_msgSender()] = _totalSupply;
215         _isExcludedFromFee[_msgSender()] = true;
216         _isExcludedFromFee[address(this)] = true;
217         _isExcludedFromFee[_teamWallet] = true;
218         teamWallet = _teamWallet;  
219         emit Transfer(address(0), _msgSender(), _totalSupply);
220     }
221     
222     /**
223      * @dev Returns Name of the token
224      */
225     function name() external view virtual override returns (string memory) {
226         return _name;
227     }
228     
229     /**
230      * @dev Returns the symbol of the token, usually a shorter version of the name.
231      */
232     function symbol() external view virtual override returns (string memory) {
233         return _symbol;
234     }
235     
236     /**
237      * @dev Returns the number of decimals used to get its user representation
238      */
239     function decimals() external view virtual override returns (uint8) {
240         return _decimal;
241     }
242     
243     /**
244      * @dev This will give the total number of tokens in existence.
245      */
246     function totalSupply() external view virtual override returns (uint256) {
247         return _totalSupply;
248     }
249     
250     /**
251      * @dev Gets the balance of the specified address.
252      */
253     function balanceOf(address account) external view virtual override returns (uint256) {
254         return _balances[account];
255     }
256     
257     /**
258      * @dev Returns collected fees of the token
259      */
260     function collectedFees() external view returns (uint256) {
261         return _balances[address(this)];
262     }
263 
264     /**
265      * @dev Transfer token to a specified address and Emits a Transfer event.
266      */
267     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271     
272     /**
273      * @dev Function to check the number of tokens that an owner allowed to a spender
274      */
275     function allowance(address owner, address spender) external view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278     
279     /**
280      * @dev Function to allow anyone to spend a token from your account and Emits an Approval event.
281      */
282     function approve(address spender, uint256 amount) external virtual override returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286     /**
287      * @dev owner can make exclude the account from paying fee on transfer
288      */
289     function excludeFromFee(address account) external onlyOwner {
290         require(account!=address(0), "Excluding for the zero address");
291         _isExcludedFromFee[account] = true;
292         emit excludingAddressFromFee(account);
293     }
294     /**
295      * @dev check if account is excluded from fee
296      */
297     function isExcludedFromFee(address account) external view returns(bool) {
298         return _isExcludedFromFee[account];
299     }
300 
301     /**
302      * @dev owner can make the account pay fee on transfer.
303      */
304     function includeInFee(address account) external onlyOwner {
305         require(account!=address(0), "Including for the zero address");
306         _isExcludedFromFee[account] = false;
307         emit includingAddressInFee(account);
308     }
309 
310     /**
311      * @dev owner can claim collected fees.
312      */
313     function collectFees() external onlyOwner {
314         uint256 fees = _balances[address(this)];
315         _transfer(address(this), teamWallet, _balances[address(this)]);
316         emit feeCollected(teamWallet, fees);
317     }
318 
319     /**
320      * @dev teamWallet can burn collected burn fees.
321      */
322     function burnCollectedFees() external onlyTeamWallet {
323         require(_balances[teamWallet] >= toBurnAmount, "Does not have the required amount of tokens to burn");
324         _transfer(teamWallet, address(0), toBurnAmount);
325         _totalSupply -= toBurnAmount;
326         toBurnAmount = 0;
327         emit feeCollected(address(0), toBurnAmount);
328     }
329 
330     /**
331      * @dev owner can update the team wallet
332      */
333     function updateTeamWallet(address _teamWallet) external onlyOwner {
334         require(_teamWallet!=address(0), "Cannot set teamwallet as zero address");
335         address oldWallet = teamWallet;
336         teamWallet =  _teamWallet;
337         _isExcludedFromFee[_teamWallet] = true;
338         _isExcludedFromFee[oldWallet] = false;
339         emit teamWalletChanged(oldWallet,_teamWallet);
340     }
341     
342     /**
343      * @dev Function to transfer allowed token from other's account
344      */
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) external virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351 
352         uint256 currentAllowance = _allowances[sender][_msgSender()];
353         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
354         unchecked {
355             _approve(sender, _msgSender(), currentAllowance - amount);
356         }
357 
358         return true;
359     }
360     
361     /**
362      * @dev Function to increase the allowance of another account
363      */
364     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
365         require(spender!=address(0), "Increasing allowance for zero address");
366         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
367         return true;
368     }
369     
370     /**
371      * @dev Function to decrease the allowance of another account
372      */
373     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
374         require(spender!=address(0), "Decreasing allowance for zero address");
375         uint256 currentAllowance = _allowances[_msgSender()][spender];
376         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
377         unchecked {
378             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
379         }
380         return true;
381     }
382     
383     function _transfer(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) internal virtual {
388         uint256 senderBalance = _balances[sender];
389         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
390         unchecked {
391             _balances[sender] = senderBalance - amount;
392         }
393         if(_isExcludedFromFee[sender]) {
394             unchecked {//condititon to exclude
395                 _balances[recipient] += amount;
396             }
397         }else{ 
398             unchecked {
399                 uint256 burnFee =  (amount * _taxBurn) / 1000;
400                 uint256 tFee = (amount * (_taxBurn + _taxLiquidity)) / 1000;
401                 amount = amount - tFee;
402                 _balances[recipient] += amount;
403                 _balances[address(this)] +=  tFee;
404                 toBurnAmount += burnFee;
405             }
406         }
407         emit Transfer(sender, recipient, amount);
408     }
409 
410     function _approve(
411         address owner,
412         address spender,
413         uint256 amount
414     ) internal virtual {
415         require(owner != address(0), "ERC20: approve from the zero address");
416         require(spender != address(0), "ERC20: approve to the zero address");
417 
418         _allowances[owner][spender] = amount;
419         emit Approval(owner, spender, amount);
420     } 
421 }