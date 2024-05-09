1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
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
130     constructor (address _tokenHolder, address _presaleContract) public{
131         _name = "DeFi Bids";
132         _symbol = "BIDS";
133         _decimals = 18;
134         _releaseTime = 1630713600;
135         _mint(_tokenHolder, 24300000 * 10**uint256(_decimals));
136         _mint(_presaleContract, 20700000 * 10**uint256(_decimals));
137         _mint(address(this), 5000000 * 10**uint256(_decimals));
138     }
139     
140     /**
141      * @dev Returns the name of the token.
142      */
143     function name() public view returns (string memory) {
144         return _name;
145     }
146     
147     /**
148      * @dev Returns the symbol of the token.
149      */
150     function symbol() public view returns (string memory) {
151         return _symbol;
152     }
153     
154     /**
155      * @dev Returns decimals of the token.
156      */
157     function decimals() public view returns (uint8) {
158         return _decimals;
159     }
160     
161     /**
162      * @dev Returns the amount of tokens in existence.
163      */
164     function totalSupply() public view returns (uint256) {
165         return _totalSupply;
166     }
167     
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) public view returns (uint256) {
172         return _balances[account];
173     }
174     
175     /**
176      * @return the time when the 5M BIDS are released.
177      */
178     function releaseTime() public view returns (uint256) {
179         return _releaseTime;
180     }
181     
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      *
189      * Requirements:
190      *
191      * - `recipient` cannot be the zero address.
192      * - the caller must have a balance of at least `amount`.
193      */
194     function transfer(address recipient, uint256 amount) public virtual returns (bool) {
195         _transfer(msg.sender, recipient, amount);
196         return true;
197     }
198     
199     /**
200      * @dev Owner can burn his own token.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      * 
204      */
205     function burnMyBIDS(uint256 amount) public virtual returns (bool) {
206         _burn(msg.sender, amount);
207         return true;
208     }
209     
210     /**
211      * @dev Returns the remaining number of tokens that `spender` will be
212      * allowed to spend on behalf of `owner` through {transferFrom}. This is
213      * zero by default.
214      *
215      * This value changes when {approve} or {transferFrom} are called.
216      */
217     function allowance(address owner, address spender) public view virtual returns (uint256) {
218         return _allowances[owner][spender];
219     }
220     
221     /**
222      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens..
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      * 
226      * Requirements:
227      *
228      * - `spender` cannot be the zero address.
229      */
230     function approve(address spender, uint256 amount) public virtual returns (bool) {
231         _approve(msg.sender, spender, amount);
232         return true;
233     }
234     
235     /**
236      * @dev Moves `amount` tokens from `sender` to `recipient` using the
237      * allowance mechanism. `amount` is then deducted from the caller's
238      * allowance.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      *
244      * Requirements:
245      * - `sender` and `recipient` cannot be the zero address.
246      * - `sender` must have a balance of at least `amount`.
247      * - the caller must have allowance for ``sender``'s tokens of at least
248      * `amount`.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
251         _transfer(sender, recipient, amount);
252         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
253         return true;
254     }
255     
256     /**
257      * @dev Moves tokens `amount` from `sender` to `recipient`.
258      * 
259      * Emits a {Transfer} event.
260      *
261      * Requirements:
262      *
263      * - `sender` cannot be the zero address.
264      * - `recipient` cannot be the zero address.
265      * - `sender` must have a balance of at least `amount`.
266      */
267     function _transfer(address sender, address recipient, uint256 amount) internal virtual returns(uint256) {
268         require(sender != address(0), "ERC20: transfer from the zero address");
269         require(recipient != address(0), "ERC20: transfer to the zero address");
270         
271         _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
272 
273         uint256 remainingAmount = amount;
274         if(BURN_RATE > 0){
275             uint256 burnAmount = amount.mul(BURN_RATE).div(PERCENTS_DIVIDER);
276             _burn(sender, burnAmount);
277             remainingAmount = remainingAmount.sub(burnAmount);
278 
279         }
280         
281         if(isStackingActive){
282             uint256 amountToStackPool = amount.mul(STACKING_POOL_RATE).div(PERCENTS_DIVIDER);
283             remainingAmount = remainingAmount.sub(amountToStackPool);
284             _balances[msg.sender] = _balances[msg.sender].sub(amountToStackPool, "ERC20: transfer amount exceeds balance");
285             _balances[stackingPoolAddress] = _balances[stackingPoolAddress].add(amountToStackPool);
286             emit Transfer(msg.sender, stackingPoolAddress, amountToStackPool);
287 
288         }
289 
290         _balances[sender] = _balances[sender].sub(remainingAmount, "ERC20: transfer amount exceeds balance");
291         _balances[recipient] = _balances[recipient].add(remainingAmount);
292         emit Transfer(sender, recipient, remainingAmount);
293         return remainingAmount;
294     }
295     
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
298      *
299      * This is internal function is equivalent to `approve`, and can be used to
300      * e.g. set automatic allowances for certain subsystems, etc.
301      *
302      * Emits an {Approval} event.
303      *
304      * Requirements:
305      *
306      * - `owner` cannot be the zero address.
307      * - `spender` cannot be the zero address.
308      */
309     function _approve(address owner, address spender, uint256 amount) internal virtual {
310         require(owner != address(0), "ERC20: approve from the zero address");
311         require(spender != address(0), "ERC20: approve to the zero address");
312 
313         _allowances[owner][spender] = amount;
314         emit Approval(owner, spender, amount);
315     }
316     
317     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
318      * the total supply.
319      *
320      * Emits a {Transfer} event with `from` set to the zero address.
321      *
322      * Requirements
323      *
324      * - `to` cannot be the zero address.
325      */
326     function _mint(address account, uint256 amount) internal virtual {
327         require(account != address(0), "ERC20: mint to the zero address");
328 
329         _totalSupply = _totalSupply.add(amount);
330         _balances[account] = _balances[account].add(amount);
331         emit Transfer(address(0), account, amount);
332     }
333 
334     /**
335      * @dev Destroys `amount` tokens from `account`, reducing the
336      * total supply.
337      *
338      * Emits a {Transfer} event with `to` set to the zero address.
339      *
340      * Requirements
341      *
342      * - `account` cannot be the zero address.
343      * - `account` must have at least `amount` tokens.
344      */
345     function _burn(address account, uint256 amount) internal virtual {
346         require(account != address(0), "ERC20: burn from the zero address");
347 
348         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
349         _totalSupply = _totalSupply.sub(amount);
350         emit Transfer(account, address(0), amount);
351     }
352     
353     /**
354      * @notice Transfers tokens held by timelock to beneficiary.
355      */
356     function releaseLokedBIDS() public virtual onlyOwner returns(bool){
357         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
358 
359         uint256 amount = _balances[address(this)];
360         require(amount > 0, "TokenTimelock: no tokens to release");
361 
362         _transfer(address(this), msg.sender, amount);
363         
364         return true;
365     }
366     
367     /**
368      * @dev User to perform {approve} of token and {transferFrom} in one function call.
369      *
370      *
371      * Requirements
372      *
373      * - `spender' must have implemented {receiveApproval} function.
374      */
375     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)  public returns (bool success) {
376 	    if (approve(_spender, _value)) {
377 	    	ApproveAndCallFallback(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
378 	    	return true;
379 	    }
380     }
381     
382      /**
383      * @dev Same like approveAndCall but doing both transaction in one one call.
384      *
385      *
386      * Requirements
387      *
388      * - `_to' must have implemented {tokenCallback} function.
389      */
390     function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
391 		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
392 		ApproveAndCallFallback(_to).tokenCallback(msg.sender, _transferred, _data);
393 		return true;
394 	}
395     
396     /**
397      * @dev Do bulk transfers in one transaction.
398      */
399     function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
400 		require(_receivers.length == _amounts.length);
401 		for (uint256 i = 0; i < _receivers.length; i++) {
402 			_transfer(msg.sender, _receivers[i], _amounts[i]);
403 		}
404 	}
405     
406     /**
407      * @dev Change Status of the `staking`. If this is set to true then
408      * portion of transfer amount goes to stacking pool.
409      */
410     function setStackingPoolContract(address payable _a) public onlyOwner returns (bool) { 
411         stackingPoolAddress = _a;
412         return true;
413     }
414     
415     /**
416      * @dev Change Status of the `staking`. If this is set to true then
417      * portion of transfer amount goes to stacking pool.
418      */
419     function changeStackingStatus() public virtual onlyOwner returns (bool currentStackingStatus) { 
420         if(isStackingActive){
421             isStackingActive = false;
422         } else {
423             isStackingActive = true;
424         }
425         return isStackingActive;
426     }
427     
428     /**
429      * @dev Change the `burn` ratio which is deducted while transfer.
430      * 
431      * {burnRatio_} is in multiplication of 10. For example if burnRatio_ is 1% then input will be 10.
432      */
433     function chnageTransferBurnRate(uint256 burnRatio_) public onlyOwner returns (bool) { 
434         BURN_RATE = burnRatio_;
435         return true;
436     }
437 
438 }