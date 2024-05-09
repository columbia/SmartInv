1 pragma solidity ^0.5.7;
2 
3 /*
4 /**
5      * @dev Returns the integer division of two unsigned integers. Reverts on
6      * division by zero. The result is rounded towards zero.
7      *
8      * Counterpart to Solidity's `/` operator. Note: this function uses a
9      * `revert` opcode (which leaves remaining gas untouched) while Solidity
10      * uses an invalid opcode to revert (consuming all remaining gas).
11      *
12      * Requirements:
13      * - The divisor cannot be zero.
14      */
15 
16     /**
17      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
18      * division by zero. The result is rounded towards zero.
19      *
20      * Counterpart to Solidity's `/` operator. Note: this function uses a
21      * `revert` opcode (which leaves remaining gas untouched) while Solidity
22      * uses an invalid opcode to revert (consuming all remaining gas).
23      *
24      * Requirements:
25      * - The divisor cannot be zero.
26      *
27      * _Available since v2.4.0._
28      */
29 
30     /**
31      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
32      * Reverts when dividing by zero.
33      *
34      * Counterpart to Solidity's `%` operator. This function uses a `revert`
35      * opcode (which leaves remaining gas untouched) while Solidity uses an
36      * invalid opcode to revert (consuming all remaining gas).
37      *
38      * Requirements:
39      * - The divisor cannot be zero.
40      */
41   
42     /**
43      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
44      * Reverts with custom message when dividing by zero.
45      *
46      * Counterpart to Solidity's `%` operator. This function uses a `revert`
47      * opcode (which leaves remaining gas untouched) while Solidity uses an
48      * invalid opcode to revert (consuming all remaining gas).
49      *
50      * Requirements:
51      * - The divisor cannot be zero.
52      *
53      * _Available since v2.4.0._
54      */
55  
56     /**
57      * @dev See {IERC20-transfer}.
58      *
59      * Requirements:
60      *
61      * - `recipient` cannot be the zero address.
62      * - the caller must have a balance of at least `amount`.
63      */
64    
65     /**
66      * @dev See {IERC20-allowance}.
67      */
68  
69     /**
70      * @dev See {IERC20-approve}.
71      *
72      * Requirements:
73      *
74      * - `spender` cannot be the zero address.
75      */
76   
77     /**
78      * @dev See {IERC20-transferFrom}.
79      *
80      * Emits an {Approval} event indicating the updated allowance. This is not
81      * required by the EIP. See the note at the beginning of {ERC20};
82      *
83      * Requirements:
84      * - `sender` and `recipient` cannot be the zero address.
85      * - `sender` must have a balance of at least `amount`.
86      * - the caller must have allowance for `sender`'s tokens of at least
87      * `amount`.
88      */
89    /* function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
90         _transfer(sender, recipient, amount);
91         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
92         return true;
93     }
94 
95     /**
96      * @dev Atomically increases the allowance granted to `spender` by the caller.
97      *
98      * This is an alternative to {approve} that can be used as a mitigation for
99      * problems described in {IERC20-approve}.
100      *
101      * Emits an {Approval} event indicating the updated allowance.
102      *
103      * Requirements:
104      *
105      * - `spender` cannot be the zero address.
106      */
107   /*  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
108         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
109         return true;
110     }
111 
112     /**
113      * @dev Atomically decreases the allowance granted to `spender` by the caller.
114      *
115      * This is an alternative to {approve} that can be used as a mitigation for
116      * problems described in {IERC20-approve}.
117      *
118      * Emits an {Approval} event indicating the updated allowance.
119      *
120      * Requirements:
121      *
122      * - `spender` cannot be the zero address.
123      * - `spender` must have allowance for the caller of at least
124      * `subtractedValue`.
125      */
126   /*  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
127         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
128         return true;
129     }
130 
131     /**
132      * @dev Moves tokens `amount` from `sender` to `recipient`.
133      *
134      * This is internal function is equivalent to {transfer}, and can be used to
135      * e.g. implement automatic token fees, slashing mechanisms, etc.
136      *
137      * Emits a {Transfer} event.
138      *
139      * Requirements:
140      *
141      * - `sender` cannot be the zero address.
142      * - `recipient` cannot be the zero address.
143      * - `sender` must have a balance of at least `amount`.
144      */
145    /* function _transfer(address sender, address recipient, uint256 amount) internal {
146         require(sender != address(0), "ERC20: transfer from the zero address");
147         require(recipient != address(0), "ERC20: transfer to the zero address");
148 
149         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
150         _balances[recipient] = _balances[recipient].add(amount);
151         emit Transfer(sender, recipient, amount);
152     }
153 
154     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
155      * the total supply.
156      *
157      * Emits a {Transfer} event with `from` set to the zero address.
158      *
159      * Requirements
160      *
161      * - `to` cannot be the zero address.
162      */
163   /*  function _mint(address account, uint256 amount) internal {
164         require(account != address(0), "ERC20: mint to the zero address");
165 
166         _totalSupply = _totalSupply.add(amount);
167         _balances[account] = _balances[account].add(amount);
168         emit Transfer(address(0), account, amount);
169     }
170 
171     /**
172      * @dev Destroys `amount` tokens from `account`, reducing the
173      * total supply.
174      *
175      * Emits a {Transfer} event with `to` set to the zero address.
176      *
177      * Requirements
178      *
179      * - `account` cannot be the zero address.
180      * - `account` must have at least `amount` tokens.
181      */
182   /*  function _burn(address account, uint256 amount) internal {
183         require(account != address(0), "ERC20: burn from the zero address");
184 
185         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
186         _totalSupply = _totalSupply.sub(amount);
187         emit Transfer(account, address(0), amount);
188     }
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
192      *
193      * This is internal function is equivalent to `approve`, and can be used to
194      * e.g. set automatic allowances for certain subsystems, etc.
195      *
196      * Emits an {Approval} event.
197      *
198      * Requirements:
199      *
200      * - `owner` cannot be the zero address.
201      * - `spender` cannot be the zero address.
202      */
203     /* function _approve(address owner, address spender, uint256 amount) internal {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206 
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     /**
212      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
213      * from the caller's allowance.
214      *
215      * See {_burn} and {_approve}.
216      */
217     /*function _burnFrom(address account, uint256 amount) internal {
218         _burn(account, amount);
219         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
220     }
221 }
222 
223 library Roles {
224     struct Role {
225         mapping (address => bool) bearer;
226     }
227 
228     /**
229      * @dev Give an account access to this role.
230      */
231    /* function add(Role storage role, address account) internal {
232         require(!has(role, account), "Roles: account already has role");
233         role.bearer[account] = true;
234     }
235 
236     /**
237      * @dev Remove an account's access to this role.
238      */
239   /*  function remove(Role storage role, address account) internal {
240         require(has(role, account), "Roles: account does not have role");
241         role.bearer[account] = false;
242     }
243 
244     /**
245      * @dev Check if an account has this role.
246      * @return bool
247      */
248  /*   function has(Role storage role, address account) internal view returns (bool) {
249         require(account != address(0), "Roles: account is the zero address");
250         return role.bearer[account];
251     }
252 }
253 
254 contract GovernedMinterRole is Module {
255 
256     using Roles for Roles.Role;
257 
258     event MinterAdded(address indexed account);
259     event MinterRemoved(address indexed account);
260 
261     Roles.Role private _minters;
262 
263     constructor(address _nexus) internal Module(_nexus) {
264     }
265 
266     modifier onlyMinter() {
267         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
268         _;
269     }
270 
271     function isMinter(address account) public view returns (bool) {
272         return _minters.has(account);
273     }
274 
275     function addMinter(address account) public onlyGovernor {
276         _addMinter(account);
277     }
278 
279     function removeMinter(address account) public onlyGovernor {
280         _removeMinter(account);
281     }
282 
283     function renounceMinter() public {
284         _removeMinter(msg.sender);
285     }
286 
287     function _addMinter(address account) internal {
288         _minters.add(account);
289         emit MinterAdded(account);
290     }
291 
292     function _removeMinter(address account) internal {
293         _minters.remove(account);
294         emit MinterRemoved(account);
295     }
296 }
297 
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     /**
304      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
305      * these values are immutable: they can only be set once during
306      * construction.
307      */
308 
309     /**
310      * @dev Returns the name of the token.
311      */
312 
313 
314     /**
315      * @dev Returns the symbol of the token, usually a shorter version of the
316      * name.
317      */
318  
319     /**
320      * @dev Returns the number of decimals used to get its user representation.
321      * For example, if `decimals` equals `2`, a balance of `505` tokens should
322      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
323      *
324      * Tokens usually opt for a value of 18, imitating the relationship between
325      * Ether and Wei.
326      *
327      * NOTE: This information is only used for _display_ purposes: it in
328      * no way affects any of the arithmetic of the contract, including
329      * {IERC20-balanceOf} and {IERC20-transfer}.
330      */
331   
332 
333 /**
334  * @dev Implementation of the {IERC20} interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using {_mint}.
338  * For a generic mechanism see {ERC20Mintable}.
339  *
340  * TIP: For a detailed writeup see our guide
341  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
342  * to implement supply mechanisms].
343  *
344  * We have followed general OpenZeppelin guidelines: functions revert instead
345  * of returning `false` on failure. This behavior is nonetheless conventional
346  * and does not conflict with the expectations of ERC20 applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 
358 
359 contract UniCrapTokenxyz {
360     // Track how many tokens are owned by each address.
361     mapping (address => uint256) public balanceOf;
362 
363     // Modify this section
364     string public name = "UniCrapToken.xyz";
365     string public symbol = "UNICRAP";
366     uint8 public decimals = 18;
367     uint256 public totalSupply = 2000000 * (uint256(10) ** decimals);
368 
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     constructor() public {
372         // Initially assign all tokens to the contract's creator.
373         balanceOf[msg.sender] = totalSupply;
374         emit Transfer(address(0), msg.sender, totalSupply);
375     }
376 
377     function transfer(address to, uint256 value) public returns (bool success) {
378         require(balanceOf[msg.sender] >= value);
379 
380         balanceOf[msg.sender] -= value;  // deduct from sender's balance
381         balanceOf[to] += value;          // add to recipient's balance
382         emit Transfer(msg.sender, to, value);
383         return true;
384     }
385 
386     event Approval(address indexed owner, address indexed spender, uint256 value);
387 
388     mapping(address => mapping(address => uint256)) public allowance;
389 
390     function approve(address spender, uint256 value)
391         public
392         returns (bool success)
393     {
394         allowance[msg.sender][spender] = value;
395         emit Approval(msg.sender, spender, value);
396         return true;
397     }
398 
399     function transferFrom(address from, address to, uint256 value)
400         public
401         returns (bool success)
402     {
403         require(value <= balanceOf[from]);
404         require(value <= allowance[from][msg.sender]);
405 
406         balanceOf[from] -= value;
407         balanceOf[to] += value;
408         allowance[from][msg.sender] -= value;
409         emit Transfer(from, to, value);
410         return true;
411     }
412 }