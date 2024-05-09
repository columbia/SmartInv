1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      */
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11 
12         return c;
13     }
14 
15     /**
16      * @dev Returns the subtraction of two unsigned integers, reverting on
17      * overflow (when the result is negative).
18      */
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
25      */
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the multiplication of two unsigned integers, reverting on
35      * overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the integer division of two unsigned integers. Reverts on
50      * division by zero. The result is rounded towards zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     /**
57      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
58      * division by zero. The result is rounded towards zero.
59      */
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
71      * Reverts when dividing by zero.
72      */
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return mod(a, b, "SafeMath: modulo by zero");
75     }
76 
77     /**
78      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
79      * Reverts with custom message when dividing by zero.
80      */
81     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b != 0, errorMessage);
83         return a % b;
84     }
85 }
86 
87 contract Context {
88     // Empty internal constructor, to prevent people from mistakenly deploying
89     // an instance of this contract, which should be used via inheritance.
90     constructor () internal { }
91     // solhint-disable-previous-line no-empty-blocks
92 
93     function _msgSender() internal view returns (address payable) {
94         return msg.sender;
95     }
96 }
97 
98 
99 /**
100  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
101  * the optional functions; to access them see {ERC20Detailed}.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      */
138     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
142      * another (`to`).
143      *
144      * Note that `value` may be zero.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     /**
149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
150      * a call to {approve}. `value` is the new allowance.
151      */
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  **/
159 contract ERC20 is Context, IERC20 {
160     using SafeMath for uint256;
161 
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowances;
165 
166     uint256 private _totalSupply;
167 
168     /**
169      * @dev See {IERC20-totalSupply}.
170      */
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     /**
176      * @dev See {IERC20-balanceOf}.
177      */
178     function balanceOf(address account) public view returns (uint256) {
179         return _balances[account];
180     }
181 
182     /**
183      * @dev See {IERC20-transfer}.
184      */
185     function transfer(address recipient, uint256 amount) public returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     /**
191      * @dev See {IERC20-allowance}.
192      */
193     function allowance(address owner, address spender) public view returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     /**
198      * @dev See {IERC20-approve}.
199      */
200     function approve(address spender, uint256 amount) public returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     /**
206      * @dev See {IERC20-transferFrom}.
207      */
208     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     /**
215      * @dev Atomically increases the allowance granted to `spender` by the caller.
216      */
217     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
219         return true;
220     }
221 
222     /**
223      * @dev Atomically decreases the allowance granted to `spender` by the caller.
224      */
225     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
226         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
227         return true;
228     }
229 
230     /**
231      * @dev Moves tokens `amount` from `sender` to `recipient`.
232      */
233     function _transfer(address sender, address recipient, uint256 amount) internal {
234         require(sender != address(0), "ERC20: transfer from the zero address");
235         require(recipient != address(0), "ERC20: transfer to the zero address");
236 
237         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
238         _balances[recipient] = _balances[recipient].add(amount);
239         emit Transfer(sender, recipient, amount);
240     }
241 
242     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
243      * the total supply.
244      */
245     function _mint(address account, uint256 amount) internal {
246         require(account != address(0), "ERC20: mint to the zero address");
247 
248         _totalSupply = _totalSupply.add(amount);
249         _balances[account] = _balances[account].add(amount);
250         emit Transfer(address(0), account, amount);
251     }
252 
253     /**
254      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
255      */
256     function _approve(address owner, address spender, uint256 amount) internal {
257         require(owner != address(0), "ERC20: approve from the zero address");
258         require(spender != address(0), "ERC20: approve to the zero address");
259 
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 }
264 
265 contract ERC20Detailed is Context, IERC20 {
266     string private _name;
267     string private _symbol;
268     uint8 private _decimals;
269 
270     /**
271      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
272      * these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor (string memory name, string memory symbol, uint8 decimals) public {
276         _name = name;
277         _symbol = symbol;
278         _decimals = decimals;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      */
299     function decimals() public view returns (uint8) {
300         return _decimals;
301     }
302 }
303 
304 /**
305  * @dev That contract to create "SEFA" ERC20 token
306  */
307 contract SimpleToken is Context, ERC20, ERC20Detailed {
308     constructor () public ERC20Detailed("MESEFA", "SEFA", 8) {  // func param: Name, Symbol and Decimals  
309         _mint(_msgSender(), 963000000 * (10 ** uint256(decimals())));  // func to create on account NUMBER tokken 
310     }
311 }