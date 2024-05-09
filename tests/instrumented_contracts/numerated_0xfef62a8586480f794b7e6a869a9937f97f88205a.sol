1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.0 <0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 
234 contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor ()  {
243         address msgSender = _msgSender();
244         _owner = msgSender;
245         emit OwnershipTransferred(address(0), msgSender);
246     }
247 
248     /**
249      * @dev Returns the address of the current owner.
250      */
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     /**
256      * @dev Throws if called by any account other than the owner.
257      */
258     modifier onlyOwner() {
259         require(_owner == _msgSender(), "Ownable: caller is not the owner");
260         _;
261     }
262 
263     /**
264      * @dev Leaves the contract without owner. It will not be possible to call
265      * `onlyOwner` functions anymore. Can only be called by the current owner.
266      *
267      * NOTE: Renouncing ownership will leave the contract without an owner,
268      * thereby removing any functionality that is only available to the owner.
269      */
270     function renounceOwnership() public virtual onlyOwner {
271         emit OwnershipTransferred(_owner, address(0));
272         _owner = address(0);
273     }
274 
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      * Can only be called by the current owner.
278      */
279     function transferOwnership(address newOwner) public virtual onlyOwner {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         emit OwnershipTransferred(_owner, newOwner);
282         _owner = newOwner;
283     }
284 }
285 
286 contract BURNY is Context, IERC20, Ownable {
287     using SafeMath for uint256;
288     
289     mapping (address => uint256) private _balances;
290 
291     mapping (address => mapping (address => uint256)) private _allowances;
292 
293 
294     uint256 private _totalSupply = 1000000000000 * 10**18;
295     
296     address public charityWallet;
297 
298     string private _name = 'BURNY.Finance';
299     string private _symbol = 'BURNY';
300     uint8 private _decimals = 18;
301     
302     uint public burnDisabledAtAmount = 200000000000 * 10**18;
303     bool public burnEnabled;
304     
305     
306     constructor (address _charityWallet) {
307         
308         _balances[msg.sender] = _totalSupply;
309         charityWallet = _charityWallet;
310         burnEnabled = true;
311         
312     }
313     
314     function name() public view virtual  returns (string memory) {
315         return _name;
316     }
317     
318     function symbol() public view virtual  returns (string memory) {
319         return _symbol;
320     }
321     
322     function decimals() public view virtual  returns (uint8) {
323         return 18;
324     }
325     
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329     
330     function balanceOf(address account) public view virtual override returns (uint256) {
331         return _balances[account];
332     }
333     
334     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338     
339     function setBurnEnabled (bool enabled) public onlyOwner() {
340         burnEnabled = enabled;
341     }
342     
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346     
347     function approve(address spender, uint256 amount) public virtual override returns (bool) {
348         _approve(_msgSender(), spender, amount);
349         return true;
350     }
351     
352     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
353         _transfer(sender, recipient, amount);
354 
355         uint256 currentAllowance = _allowances[sender][_msgSender()];
356         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
357         _approve(sender, _msgSender(), currentAllowance - amount);
358 
359         return true;
360     }
361     
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
364         return true;
365     }
366     
367     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
368         uint256 currentAllowance = _allowances[_msgSender()][spender];
369         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
370         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
371 
372         return true;
373     }
374     
375     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
376         require(sender != address(0), "ERC20: transfer from the zero address");
377         require(recipient != address(0), "ERC20: transfer to the zero address");
378         
379         uint256 senderBalance = _balances[sender];
380         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
381         
382         uint currentTotalSupply = _totalSupply;
383         if (currentTotalSupply <= burnDisabledAtAmount) {
384             burnEnabled = false;
385         }
386         
387         if (burnEnabled) {
388             uint _amount = amount;
389             uint _charityAmount = amount.div(20);
390             uint _burnAmount = amount.mul(15).div(100);
391             uint _transferFee = _charityAmount.add(_burnAmount);
392             uint _amountToTransfer = _amount.sub(_transferFee);
393             
394             _balances[sender] = senderBalance.sub(_amount);
395             
396             _totalSupply = _totalSupply.sub(_burnAmount);
397             
398             _balances[charityWallet] = _balances[charityWallet].add(_charityAmount);
399             
400             _balances[recipient] = _balances[recipient].add(_amountToTransfer);
401             
402             emit Transfer(sender, address(0), _burnAmount); 
403 
404             emit Transfer(sender, recipient, amount);
405         } 
406         else {
407         
408             _balances[sender] = senderBalance.sub(amount);
409             _balances[recipient] = _balances[recipient].add(amount);
410 
411             emit Transfer(sender, recipient, amount);
412         }
413     }
414     
415     
416     function _approve(address owner, address spender, uint256 amount) internal virtual {
417         require(owner != address(0), "ERC20: approve from the zero address");
418         require(spender != address(0), "ERC20: approve to the zero address");
419 
420         _allowances[owner][spender] = amount;
421         emit Approval(owner, spender, amount);
422     }
423     
424 }