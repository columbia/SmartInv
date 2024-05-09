1 // File: contracts/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: contracts/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: contracts/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
167      * @dev Get it via `npm install @openzeppelin/contracts@next`.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224 
225      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
226      * @dev Get it via `npm install @openzeppelin/contracts@next`.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      *
263      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
264      * @dev Get it via `npm install @openzeppelin/contracts@next`.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 // File: contracts/ERC20.sol
273 
274 pragma solidity ^0.5.0;
275 
276 
277 
278 
279 
280 contract ERC20 is Context, IERC20 {
281     using SafeMath for uint256;
282     address private _owner;
283     mapping (address => uint256) private _balances;
284     mapping (address => mapping (address => uint256)) private _allowances;
285     uint256 private _totalSupply;
286 
287     string private _name;
288     string private _symbol;
289     uint8 private _decimals;
290     
291     uint256 private _trancheOne;
292     
293     uint256 private _trancheTwo;
294     uint256 private _trancheTwoUnlock;
295     bool private _isTrancheTwoMinted;
296 
297     uint256 private _trancheThree;
298     uint256 private _trancheThreeUnlock;
299     bool private _isTrancheThreeMinted;
300 
301     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, uint256 trancheOne, uint256 trancheTwo, uint256 trancheTwoUnlock, uint256 trancheThree, uint256 trancheThreeUnlock ) public {
302         _owner = _msgSender();
303         _name = name;
304         _symbol = symbol;
305         _decimals = decimals;
306         _totalSupply = totalSupply;
307         _trancheOne = trancheOne;
308 
309         _trancheTwo = trancheTwo;
310         _trancheTwoUnlock = trancheTwoUnlock;
311         _isTrancheTwoMinted = false;
312 
313         _trancheThreeUnlock = trancheThreeUnlock;
314         _trancheThree = trancheThree;
315         _isTrancheThreeMinted = false;
316 
317         _mint(_owner, _trancheOne);
318     }
319     function name() public view returns (string memory) {
320         return _name;
321     }
322     function symbol() public view returns (string memory) {
323         return _symbol;
324     }
325     function decimals() public view returns (uint8) {
326         return _decimals;
327     }
328     function totalSupply() public view returns (uint256) {
329         return _totalSupply;
330     }
331     function balanceOf(address account) public view returns (uint256) {
332         return _balances[account];
333     }
334     function transfer(address recipient, uint256 amount) public returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338     function allowance(address owner, address spender) public view returns (uint256) {
339         return _allowances[owner][spender];
340     }
341     function approve(address spender, uint256 amount) public returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344     }
345     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
346         _transfer(sender, recipient, amount);
347         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
348         return true;
349     }
350     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
352         return true;
353     }
354     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
355         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
356         return true;
357     }
358     function mintTrancheTwo(address owner) public onlyOwner {
359         require(now < _trancheTwoUnlock, "Tranche Two Unlocks After Tranche Two Unlock Period");
360         require(_isTrancheTwoMinted == false, "Tranche Two Has Already Been Minted");
361         _mint(owner, _trancheTwo);
362         _isTrancheTwoMinted = true;
363     }
364     function mintTrancheThree(address owner) public onlyOwner {
365         require(now < _trancheThreeUnlock, "Tranche Three Unlocks After Tranche Three Unlock Period");
366         require(_isTrancheThreeMinted == false, "Tranche Three Has Already Been Minted");
367         _mint(owner, _trancheThree);
368         _isTrancheThreeMinted = true;
369     }
370     function _mint(address account, uint256 amount) internal {
371         require(account != address(0), "ERC20: mint to the zero address");
372 
373         _balances[account] = _balances[account].add(amount);
374         emit Transfer(address(0), account, amount);
375     }
376     function _transfer(address sender, address recipient, uint256 amount) internal {
377         require(sender != address(0), "ERC20: transfer from the zero address");
378         require(recipient != address(0), "ERC20: transfer to the zero address");
379 
380         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
381         _balances[recipient] = _balances[recipient].add(amount);
382         emit Transfer(sender, recipient, amount);
383     }
384     function _approve(address owner, address spender, uint256 amount) internal {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387 
388         _allowances[owner][spender] = amount;
389         emit Approval(owner, spender, amount);
390     }
391     modifier onlyOwner {
392         require(_msgSender() == _owner, "Only owner can call this function.");
393         _;
394     }
395 }