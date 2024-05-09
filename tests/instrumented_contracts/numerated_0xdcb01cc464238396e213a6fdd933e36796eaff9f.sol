1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 
159 pragma solidity ^0.5.0;
160 
161 /**
162  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
163  * the optional functions; to access them see {ERC20Detailed}.
164  */
165 interface IERC20 {
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Returns the remaining number of tokens that `spender` will be
187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
188      * zero by default.
189      *
190      * This value changes when {approve} or {transferFrom} are called.
191      */
192     function allowance(address owner, address spender) external view returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 value);
228 
229     /**
230      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
231      * a call to {approve}. `value` is the new allowance.
232      */
233     event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 
237 pragma solidity ^0.5.0;
238 
239 /**
240  * @title Roles
241  * @dev Library for managing addresses assigned to a Role.
242  */
243 library Roles {
244     struct Role {
245         mapping (address => bool) bearer;
246     }
247 
248     /**
249      * @dev Give an account access to this role.
250      */
251     function add(Role storage role, address account) internal {
252         require(!has(role, account), "Roles: account already has role");
253         role.bearer[account] = true;
254     }
255 
256     /**
257      * @dev Remove an account's access to this role.
258      */
259     function remove(Role storage role, address account) internal {
260         require(has(role, account), "Roles: account does not have role");
261         role.bearer[account] = false;
262     }
263 
264     /**
265      * @dev Check if an account has this role.
266      * @return bool
267      */
268     function has(Role storage role, address account) internal view returns (bool) {
269         require(account != address(0), "Roles: account is the zero address");
270         return role.bearer[account];
271     }
272 }
273 
274 // File: contracts\roles\MinterRole.sol
275 
276 pragma solidity 0.5.17;
277 
278 
279 contract MinterRole
280 {
281   using Roles for Roles.Role;
282 
283   Roles.Role private _minters;
284 
285   event MinterAdded(address indexed account);
286   event MinterRemoved(address indexed account);
287 
288 
289   modifier onlyMinter()
290   {
291     require(isMinter(msg.sender), "!minter");
292     _;
293   }
294 
295   constructor () internal
296   {
297     _minters.add(msg.sender);
298     emit MinterAdded(msg.sender);
299   }
300 
301   function isMinter(address account) public view returns (bool)
302   {
303     return _minters.has(account);
304   }
305 
306   function addMinter(address account) public onlyMinter
307   {
308     _minters.add(account);
309     emit MinterAdded(account);
310   }
311 
312   function renounceMinter() public
313   {
314     _minters.remove(msg.sender);
315     emit MinterRemoved(msg.sender);
316   }
317 }
318 
319 
320 pragma solidity 0.5.17;
321 
322 
323 contract Token is IERC20, MinterRole
324 {
325   using SafeMath for uint;
326 
327   string public name;
328   string public symbol;
329   uint8 public decimals;
330   uint public totalSupply;
331 
332   mapping(address => uint) public balanceOf;
333   mapping(address => mapping(address => uint)) public allowance;
334 
335 
336   constructor (string memory _name, string memory _symbol, uint8 _decimals) public
337   {
338     name = _name;
339     symbol = _symbol;
340     decimals = _decimals;
341 
342     _mint(msg.sender, 450000 * 1e18);
343     _mint(0xb5b93f7396af7e85353d9C4d900Ccbdbdac6a658, 75000 * 1e18);
344   }
345 
346   function transfer(address _recipient, uint _amount) public returns (bool)
347   {
348     _transfer(msg.sender, _recipient, _amount);
349 
350     return true;
351   }
352 
353   function transferFrom(address _sender, address _recipient, uint _amount) public returns (bool)
354   {
355     _transfer(_sender, _recipient, _amount);
356     _approve(_sender, msg.sender, allowance[_sender][msg.sender].sub(_amount, "ERC20: tx qty > allowance"));
357 
358     return true;
359   }
360 
361   function _transfer(address _sender, address _recipient, uint _amount) internal
362   {
363     require(_sender != address(0), "ERC20: tx from 0 addy");
364     require(_recipient != address(0), "ERC20: tx to 0 addy");
365 
366     balanceOf[_sender] = balanceOf[_sender].sub(_amount, "ERC20: tx qty > balance");
367     balanceOf[_recipient] = balanceOf[_recipient].add(_amount);
368 
369     emit Transfer(_sender, _recipient, _amount);
370   }
371 
372   function approve(address _spender, uint _amount) public returns (bool)
373   {
374     _approve(msg.sender, _spender, _amount);
375 
376     return true;
377   }
378 
379   function _approve(address _owner, address _spender, uint _amount) internal
380   {
381     require(_owner != address(0), "ERC20: approve from 0 addy");
382     require(_spender != address(0), "ERC20: approve to 0 addy");
383 
384     allowance[_owner][_spender] = _amount;
385 
386     emit Approval(_owner, _spender, _amount);
387   }
388 
389   function increaseAllowance(address _spender, uint _addedValue) public returns (bool)
390   {
391     _approve(msg.sender, _spender, allowance[msg.sender][_spender].add(_addedValue));
392 
393     return true;
394   }
395 
396   function decreaseAllowance(address _spender, uint _subtractedValue) public returns (bool)
397   {
398     _approve(msg.sender, _spender, allowance[msg.sender][_spender].sub(_subtractedValue, "ERC20: decreased allowance < 0"));
399 
400     return true;
401   }
402 
403   function mint(address _account, uint256 _amount) public onlyMinter returns (bool)
404   {
405     _mint(_account, _amount);
406     return true;
407   }
408 
409   function _mint(address _account, uint _amount) internal
410   {
411     require(_account != address(0), "ERC20: mint to 0 addy");
412 
413     totalSupply = totalSupply.add(_amount);
414     balanceOf[_account] = balanceOf[_account].add(_amount);
415 
416     emit Transfer(address(0), _account, _amount);
417   }
418 
419   function burn(uint _amount) public onlyMinter
420   {
421     _burn(msg.sender, _amount);
422   }
423 
424   function burnFrom(address _account, uint _amount) public onlyMinter
425   {
426     _burn(_account, _amount);
427     _approve(_account, msg.sender, allowance[_account][msg.sender].sub(_amount, "ERC20: burn qty > allowance"));
428   }
429 
430   function _burn(address _account, uint _amount) internal
431   {
432     require(_account != address(0), "ERC20: burn from 0 addy");
433 
434     balanceOf[_account] = balanceOf[_account].sub(_amount, "ERC20: burn qty > balance");
435     totalSupply = totalSupply.sub(_amount);
436 
437     emit Transfer(_account, address(0), _amount);
438   }
439 }