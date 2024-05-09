1 pragma solidity ^0.5.0;
2 
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
22  * the optional functions; to access them see {ERC20Detailed}.
23  */
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 
43 library SafeMath {
44 
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81 
82         return c;
83     }
84 
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         return mod(a, b, "SafeMath: modulo by zero");
87     }
88     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b != 0, errorMessage);
90         return a % b;
91     }
92 }
93 
94 contract ERC20 is Context, IERC20 {
95     using SafeMath for uint256;
96 
97     mapping (address => uint256) private _balances;
98 
99     mapping (address => mapping (address => uint256)) private _allowances;
100 
101     uint256 private _totalSupply;
102 
103     /**
104      * @dev See {IERC20-totalSupply}.
105      */
106     function totalSupply() public view returns (uint256) {
107         return _totalSupply;
108     }
109 
110     /**
111      * @dev See {IERC20-balanceOf}.
112      */
113     function balanceOf(address account) public view returns (uint256) {
114         return _balances[account];
115     }
116 
117     /**
118      * @dev See {IERC20-transfer}.
119      *
120      * Requirements:
121      *
122      * - `recipient` cannot be the zero address.
123      * - the caller must have a balance of at least `amount`.
124      */
125     function transfer(address recipient, uint256 amount) public returns (bool) {
126         _transfer(_msgSender(), recipient, amount);
127         return true;
128     }
129 
130     /**
131      * @dev See {IERC20-allowance}.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowances[owner][spender];
135     }
136 
137     /**
138      * @dev See {IERC20-approve}.
139      *
140      * Requirements:
141      *
142      * - `spender` cannot be the zero address.
143      */
144     function approve(address spender, uint256 amount) public returns (bool) {
145         _approve(_msgSender(), spender, amount);
146         return true;
147     }
148 
149     /**
150      * @dev See {IERC20-transferFrom}.
151      *
152      * Emits an {Approval} event indicating the updated allowance. This is not
153      * required by the EIP. See the note at the beginning of {ERC20};
154      *
155      * Requirements:
156      * - `sender` and `recipient` cannot be the zero address.
157      * - `sender` must have a balance of at least `amount`.
158      * - the caller must have allowance for `sender`'s tokens of at least
159      * `amount`.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
162         _transfer(sender, recipient, amount);
163         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
164         return true;
165     }
166 
167     /**
168      * @dev Atomically increases the allowance granted to `spender` by the caller.
169      *
170      * This is an alternative to {approve} that can be used as a mitigation for
171      * problems described in {IERC20-approve}.
172      *
173      * Emits an {Approval} event indicating the updated allowance.
174      *
175      * Requirements:
176      *
177      * - `spender` cannot be the zero address.
178      */
179     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
180         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
181         return true;
182     }
183 
184     /**
185      * @dev Atomically decreases the allowance granted to `spender` by the caller.
186      *
187      * This is an alternative to {approve} that can be used as a mitigation for
188      * problems described in {IERC20-approve}.
189      *
190      * Emits an {Approval} event indicating the updated allowance.
191      *
192      * Requirements:
193      *
194      * - `spender` cannot be the zero address.
195      * - `spender` must have allowance for the caller of at least
196      * `subtractedValue`.
197      */
198     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
199         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
200         return true;
201     }
202 
203     /**
204      * @dev Moves tokens `amount` from `sender` to `recipient`.
205      *
206      * This is internal function is equivalent to {transfer}, and can be used to
207      * e.g. implement automatic token fees, slashing mechanisms, etc.
208      *
209      * Emits a {Transfer} event.
210      *
211      * Requirements:
212      *
213      * - `sender` cannot be the zero address.
214      * - `recipient` cannot be the zero address.
215      * - `sender` must have a balance of at least `amount`.
216      */
217     function _transfer(address sender, address recipient, uint256 amount) internal {
218         require(sender != address(0), "ERC20: transfer from the zero address");
219         require(recipient != address(0), "ERC20: transfer to the zero address");
220 
221         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
222         _balances[recipient] = _balances[recipient].add(amount);
223         emit Transfer(sender, recipient, amount);
224     }
225 
226     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
227      * the total supply.
228      *
229      * Emits a {Transfer} event with `from` set to the zero address.
230      *
231      * Requirements
232      *
233      * - `to` cannot be the zero address.
234      */
235     function _mint(address account, uint256 amount) internal {
236         require(account != address(0), "ERC20: mint to the zero address");
237 
238         _totalSupply = _totalSupply.add(amount);
239         _balances[account] = _balances[account].add(amount);
240         emit Transfer(address(0), account, amount);
241     }
242 
243     /**
244      * @dev Destroys `amount` tokens from `account`, reducing the
245      * total supply.
246      *
247      * Emits a {Transfer} event with `to` set to the zero address.
248      *
249      * Requirements
250      *
251      * - `account` cannot be the zero address.
252      * - `account` must have at least `amount` tokens.
253      */
254     function _burn(address account, uint256 amount) internal {
255         require(account != address(0), "ERC20: burn from the zero address");
256 
257         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
258         _totalSupply = _totalSupply.sub(amount);
259         emit Transfer(account, address(0), amount);
260     }
261 
262     /**
263      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
264      *
265      * This is internal function is equivalent to `approve`, and can be used to
266      * e.g. set automatic allowances for certain subsystems, etc.
267      *
268      * Emits an {Approval} event.
269      *
270      * Requirements:
271      *
272      * - `owner` cannot be the zero address.
273      * - `spender` cannot be the zero address.
274      */
275     function _approve(address owner, address spender, uint256 amount) internal {
276         require(owner != address(0), "ERC20: approve from the zero address");
277         require(spender != address(0), "ERC20: approve to the zero address");
278 
279         _allowances[owner][spender] = amount;
280         emit Approval(owner, spender, amount);
281     }
282 
283     /**
284      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
285      * from the caller's allowance.
286      *
287      * See {_burn} and {_approve}.
288      */
289     function _burnFrom(address account, uint256 amount) internal {
290         _burn(account, amount);
291         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
292     }
293 }
294 
295 contract ERC20Detailed is IERC20 {
296     string private _name;
297     string private _symbol;
298     uint8 private _decimals;
299 
300     /**
301      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
302      * these values are immutable: they can only be set once during
303      * construction.
304      */
305     constructor (string memory name, string memory symbol, uint8 decimals) public {
306         _name = name;
307         _symbol = symbol;
308         _decimals = decimals;
309     }
310 
311     /**
312      * @dev Returns the name of the token.
313      */
314     function name() public view returns (string memory) {
315         return _name;
316     }
317 
318     /**
319      * @dev Returns the symbol of the token, usually a shorter version of the
320      * name.
321      */
322     function symbol() public view returns (string memory) {
323         return _symbol;
324     }
325 
326     /**
327      * @dev Returns the number of decimals used to get its user representation.
328      * For example, if `decimals` equals `2`, a balance of `505` tokens should
329      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
330      *
331      * Tokens usually opt for a value of 18, imitating the relationship between
332      * Ether and Wei.
333      *
334      * NOTE: This information is only used for _display_ purposes: it in
335      * no way affects any of the arithmetic of the contract, including
336      * {IERC20-balanceOf} and {IERC20-transfer}.
337      */
338     function decimals() public view returns (uint8) {
339         return _decimals;
340     }
341 }
342 
343 contract RippleAlpha is ERC20, ERC20Detailed {
344     
345     string private _name = "Ripple Alpha";
346     string private _symbol = "XLA";
347     uint8 private _decimals = 6;
348 
349     address account = msg.sender;
350     uint256 value = 5000000000000000;
351 
352     constructor() ERC20Detailed(_name, _symbol, _decimals) public {
353         _mint(account, value);
354     }
355 }