1 /**
2  *Mankind environment coin
3 */
4 
5 pragma solidity 0.5.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      *
59      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
60      * @dev Get it via `npm install @openzeppelin/contracts@next`.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      * - The divisor cannot be zero.
117      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
118      * @dev Get it via `npm install @openzeppelin/contracts@next`.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      *
155      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
156      * @dev Get it via `npm install @openzeppelin/contracts@next`.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 /**
240  * @title Standard ERC20 token
241  *
242  * @dev Implementation of the basic standard token.
243  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
244  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
245  */
246 contract KECToken is IERC20{
247   using SafeMath for uint256;
248 
249   mapping (address => uint256) private _balances;
250 
251   mapping (address => mapping (address => uint256)) private _allowed;
252   
253   mapping (address => bool) private _blacklist;
254 
255   string public name = "Mankind Environment Coin";
256   string public symbol = "KEC";
257   uint public decimals = 18;
258   uint private _totalSupply = 5000000*10**18;
259   address public owner;
260   
261   constructor (address _owner) public{
262       owner = _owner;
263       _balances[_owner] = _totalSupply;
264   }
265   
266   modifier onlyOwner() {
267       require(msg.sender == owner);
268       _;
269   }
270   
271   function addBlacklist(address account) onlyOwner() public{
272       _blacklist[account] = true;
273   }
274   
275   function removeBlacklist(address account) onlyOwner() public{
276       _blacklist[account] = false;
277   }
278   
279   function totalSupply() public view returns (uint256) {
280     return _totalSupply;
281   }
282   /**
283   * @dev Gets the balance of the specified address.
284   * @param owner The address to query the balance of.
285   * @return An uint256 representing the amount owned by the passed address.
286   */
287   function balanceOf(address owner) public view returns (uint256) {
288     return _balances[owner];
289   }
290 
291   /**
292    * @dev Function to check the amount of tokens that an owner allowed to a spender.
293    * @param owner address The address which owns the funds.
294    * @param spender address The address which will spend the funds.
295    * @return A uint256 specifying the amount of tokens still available for the spender.
296    */
297   function allowance(
298     address owner,
299     address spender
300    )
301     public
302     view
303     returns (uint256)
304   {
305     return _allowed[owner][spender];
306   }
307 
308   /**
309   * @dev Transfer token for a specified address
310   * @param to The address to transfer to.
311   * @param value The amount to be transferred.
312   */
313   function transfer(address to, uint256 value) public returns (bool) {
314     require(value <= _balances[msg.sender]);
315     require(to != address(0));
316     require(_blacklist[msg.sender] != true && _blacklist[to] != true);
317 
318     _balances[msg.sender] = _balances[msg.sender].sub(value);
319     _balances[to] = _balances[to].add(value);
320     emit Transfer(msg.sender, to, value);
321     return true;
322   }
323 
324   /**
325    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
326    * @param spender The address which will spend the funds.
327    * @param value The amount of tokens to be spent.
328    */
329   function approve(address spender, uint256 value) public returns (bool) {
330     require(spender != address(0));
331     require(_blacklist[msg.sender] != true && _blacklist[spender] != true);
332     require(value == 0 || _allowed[msg.sender][spender] == 0);
333 
334     _allowed[msg.sender][spender] = value;
335     emit Approval(msg.sender, spender, value);
336     return true;
337   }
338 
339   /**
340    * @dev Transfer tokens from one address to another
341    * @param from address The address which you want to send tokens from
342    * @param to address The address which you want to transfer to
343    * @param value uint256 the amount of tokens to be transferred
344    */
345   function transferFrom(
346     address from,
347     address to,
348     uint256 value
349   )
350     public
351     returns (bool)
352   {
353     require(value <= _balances[from]);
354     require(value <= _allowed[from][msg.sender]);
355     require(to != address(0));
356     require(_blacklist[to] != true && _blacklist[from] != true);
357 
358     _balances[from] = _balances[from].sub(value);
359     _balances[to] = _balances[to].add(value);
360     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
361     emit Transfer(from, to, value);
362     return true;
363   }
364 
365   /**
366    * @dev Increase the amount of tokens that an owner allowed to a spender.
367    * @param spender The address which will spend the funds.
368    * @param addedValue The amount of tokens to increase the allowance by.
369    */
370   function increaseAllowance(
371     address spender,
372     uint256 addedValue
373   )
374     public
375     returns (bool)
376   {
377     require(spender != address(0));
378     require(_blacklist[msg.sender] != true && _blacklist[spender] != true);
379 
380     _allowed[msg.sender][spender] = (
381       _allowed[msg.sender][spender].add(addedValue));
382     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
383     return true;
384   }
385 
386   /**
387    * @dev Decrease the amount of tokens that an owner allowed to a spender.
388    * @param spender The address which will spend the funds.
389    * @param subtractedValue The amount of tokens to decrease the allowance by.
390    */
391   function decreaseAllowance(
392     address spender,
393     uint256 subtractedValue
394   )
395     public
396     returns (bool)
397   {
398     require(spender != address(0));
399     require(_blacklist[msg.sender] != true && _blacklist[spender] != true);
400 
401     _allowed[msg.sender][spender] = (
402       _allowed[msg.sender][spender].sub(subtractedValue));
403     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
404     return true;
405   }
406 
407 }