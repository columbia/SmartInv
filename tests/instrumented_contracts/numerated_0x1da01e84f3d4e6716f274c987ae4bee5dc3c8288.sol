1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @title SafeMath
6  * @notice Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20 
21     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
22         require(b <= a, errorMessage);
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29 
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43 
44 
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 
51     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
52         return mod(a, b, "SafeMath: modulo by zero");
53     }
54 
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;
58     }
59 }
60 
61 /**
62  * @title Ownership Contract
63  */
64 contract Ownable {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () internal {
70         _owner = msg.sender;
71         emit OwnershipTransferred(address(0), msg.sender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == msg.sender, "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 /**
91  * @title Interface of Token recipient contrcat
92  */
93 interface ApproveAndCallFallback { 
94     function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) external;
95     function tokenCallback(address _from, uint256 _tokens, bytes memory _data) external;
96 } 
97 
98 
99 
100 
101 /**
102  * @title BIDS TOKEN
103  */
104 contract DefiBids is Ownable {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112 
113     string private _name;
114     string private _symbol;
115     uint8 private _decimals;
116 
117     uint256 public BURN_RATE = 0;
118     uint256 constant STACKING_POOL_RATE = 10;
119 	uint256 constant public PERCENTS_DIVIDER = 1000;
120 	
121 	bool public isStackingActive = false;
122 	address payable public stackingPoolAddress;
123     
124     // timestamp when token 5M BIDS is enabled
125     uint256 private _releaseTime;
126 
127     event Transfer(address indexed from, address indexed to, uint256 value);
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129     
130     constructor (address _tokenHolder) public{
131         _name = "DefiBids";
132         _symbol = "BID";
133         _decimals = 18;
134         _releaseTime = 1630713600;
135         _mint(_tokenHolder, 45000000 * 10**uint256(_decimals));
136         _mint(address(this), 5000000 * 10**uint256(_decimals));
137     }
138     
139     /**
140      * @notice Returns the name of the token.
141      */
142     function name() public view returns (string memory) {
143         return _name;
144     }
145     
146     /**
147      * @notice Returns the symbol of the token.
148      */
149     function symbol() public view returns (string memory) {
150         return _symbol;
151     }
152     
153     /**
154      * @notice Returns decimals of the token.
155      */
156     function decimals() public view returns (uint8) {
157         return _decimals;
158     }
159     
160     /**
161      * @notice Returns the amount of tokens in existence.
162      */
163     function totalSupply() public view returns (uint256) {
164         return _totalSupply;
165     }
166     
167     /**
168      * @notice Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) public view returns (uint256) {
171         return _balances[account];
172     }
173     
174     /**
175      * @return the time when the 5M BIDS are released.
176      */
177     function releaseTime() public view returns (uint256) {
178         return _releaseTime;
179     }
180     
181     /**
182      * @notice Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      *
188      * Requirements:
189      *
190      * - `recipient` cannot be the zero address.
191      * - the caller must have a balance of at least `amount`.
192      */
193     function transfer(address recipient, uint256 amount) public virtual returns (bool) {
194         _transfer(msg.sender, recipient, amount);
195         return true;
196     }
197     
198     /**
199      * @notice Owner can burn his own token.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      * 
203      */
204     function burnMyBIDS(uint256 amount) public virtual returns (bool) {
205         _burn(msg.sender, amount);
206         return true;
207     }
208     
209     /**
210      * @notice Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through {transferFrom}. This is
212      * zero by default.
213      *
214      * This value changes when {approve} or {transferFrom} are called.
215      */
216     function allowance(address owner, address spender) public view virtual returns (uint256) {
217         return _allowances[owner][spender];
218     }
219     
220     /**
221      * @notice Sets `amount` as the allowance of `spender` over the caller's tokens..
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      * 
225      * Requirements:
226      *
227      * - `spender` cannot be the zero address.
228      */
229     function approve(address spender, uint256 amount) public virtual returns (bool) {
230         _approve(msg.sender, spender, amount);
231         return true;
232     }
233     
234     /**
235      * @notice Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      *
243      * Requirements:
244      * - `sender` and `recipient` cannot be the zero address.
245      * - `sender` must have a balance of at least `amount`.
246      * - the caller must have allowance for ``sender``'s tokens of at least
247      * `amount`.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
250         _transfer(sender, recipient, amount);
251         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
252         return true;
253     }
254     
255     /**
256      * @notice Moves tokens `amount` from `sender` to `recipient`.
257      * 
258      * Emits a {Transfer} event.
259      *
260      * Requirements:
261      *
262      * - `sender` cannot be the zero address.
263      * - `recipient` cannot be the zero address.
264      * - `sender` must have a balance of at least `amount`.
265      */
266     function _transfer(address sender, address recipient, uint256 amount) internal virtual returns(uint256) {
267         require(sender != address(0), "ERC20: transfer from the zero address");
268         require(recipient != address(0), "ERC20: transfer to the zero address");
269         
270         _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
271 
272         uint256 remainingAmount = amount;
273         if(BURN_RATE > 0){
274             uint256 burnAmount = amount.mul(BURN_RATE).div(PERCENTS_DIVIDER);
275             _burn(sender, burnAmount);
276             remainingAmount = remainingAmount.sub(burnAmount);
277         }
278         
279         if(isStackingActive){
280             uint256 amountToStackPool = amount.mul(STACKING_POOL_RATE).div(PERCENTS_DIVIDER);
281             remainingAmount = remainingAmount.sub(amountToStackPool);
282             _balances[sender] = _balances[sender].sub(amountToStackPool, "ERC20: transfer amount exceeds balance");
283             _balances[stackingPoolAddress] = _balances[stackingPoolAddress].add(amountToStackPool);
284             emit Transfer(sender, stackingPoolAddress, amountToStackPool);
285         }
286 
287         _balances[sender] = _balances[sender].sub(remainingAmount, "ERC20: transfer amount exceeds balance");
288         _balances[recipient] = _balances[recipient].add(remainingAmount);
289         emit Transfer(sender, recipient, remainingAmount);
290         return remainingAmount;
291     }
292     
293     /**
294      * @notice Sets `amount` as the allowance of `spender` over the `owner`s tokens.
295      *
296      * This is internal function is equivalent to `approve`, and can be used to
297      * e.g. set automatic allowances for certain subsystems, etc.
298      *
299      * Emits an {Approval} event.
300      *
301      * Requirements:
302      *
303      * - `owner` cannot be the zero address.
304      * - `spender` cannot be the zero address.
305      */
306     function _approve(address owner, address spender, uint256 amount) internal virtual {
307         require(owner != address(0), "ERC20: approve from the zero address");
308         require(spender != address(0), "ERC20: approve to the zero address");
309 
310         _allowances[owner][spender] = amount;
311         emit Approval(owner, spender, amount);
312     }
313     
314     /** @notice Creates `amount` tokens and assigns them to `account`, increasing
315      * the total supply.
316      *
317      * Emits a {Transfer} event with `from` set to the zero address.
318      *
319      * Requirements
320      *
321      * - `to` cannot be the zero address.
322      */
323     function _mint(address account, uint256 amount) internal virtual {
324         require(account != address(0), "ERC20: mint to the zero address");
325 
326         _totalSupply = _totalSupply.add(amount);
327         _balances[account] = _balances[account].add(amount);
328         emit Transfer(address(0), account, amount);
329     }
330 
331     /**
332      * @notice Destroys `amount` tokens from `account`, reducing the
333      * total supply.
334      *
335      * Emits a {Transfer} event with `to` set to the zero address.
336      *
337      * Requirements
338      *
339      * - `account` cannot be the zero address.
340      * - `account` must have at least `amount` tokens.
341      */
342     function _burn(address account, uint256 amount) internal virtual {
343         require(account != address(0), "ERC20: burn from the zero address");
344 
345         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
346         _totalSupply = _totalSupply.sub(amount);
347         emit Transfer(account, address(0), amount);
348     }
349     
350     /**
351      * @notice Transfers tokens held by timelock to beneficiary.
352      */
353     function releaseLokedBIDS() public virtual onlyOwner returns(bool){
354         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
355 
356         uint256 amount = _balances[address(this)];
357         require(amount > 0, "TokenTimelock: no tokens to release");
358 
359         _transfer(address(this), msg.sender, amount);
360         
361         return true;
362     }
363     
364     /**
365      * @notice User to perform {approve} of token and {transferFrom} in one function call.
366      *
367      *
368      * Requirements
369      *
370      * - `spender' must have implemented {receiveApproval} function.
371      */
372     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)  public returns (bool success) {
373 	    if (approve(_spender, _value)) {
374 	    	ApproveAndCallFallback(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
375 	    	return true;
376 	    }
377     }
378     
379      /**
380      * @notice Same like approveAndCall but doing both transaction in one one call.
381      *
382      *
383      * Requirements
384      *
385      * - `_to' must have implemented {tokenCallback} function.
386      */
387     function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
388 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
389 		ApproveAndCallFallback(_to).tokenCallback(msg.sender, _transferred, _data);
390 		return true;
391 	}
392     
393     /**
394      * @notice Do bulk transfers in one transaction.
395      */
396     function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
397 		require(_receivers.length == _amounts.length);
398 		for (uint256 i = 0; i < _receivers.length; i++) {
399 			_transfer(msg.sender, _receivers[i], _amounts[i]);
400 		}
401 	}
402     
403     /**
404      * @notice setStackingPoolContract address where staking fees will be transferred
405      */
406     function setStackingPoolContract(address payable _a) public onlyOwner returns (bool) { 
407         stackingPoolAddress = _a;
408         return true;
409     }
410     
411     /**
412      * @notice Change Status of the `staking`. If this is set to true then
413      * portion of transfer amount goes to stacking pool.
414      */
415     function changeStackingStatus() public virtual onlyOwner returns (bool currentStackingStatus) { 
416         if(isStackingActive){
417             isStackingActive = false;
418         } else {
419             isStackingActive = true;
420         }
421         return isStackingActive;
422     }
423     
424     /**
425      * @notice Change the `burn` ratio which is deducted while transfer.
426      * 
427      * {burnRatio_} is in multiplication of 10. For example if burnRatio_ is 1% then input will be 10.
428      */
429     function chnageTransferBurnRate(uint256 burnRatio_) public onlyOwner returns (bool) { 
430         BURN_RATE = burnRatio_;
431         return true;
432     }
433 
434 }