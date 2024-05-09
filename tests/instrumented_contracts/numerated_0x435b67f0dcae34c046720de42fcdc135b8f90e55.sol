1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      *
42      * _Available since v2.4.0._
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      *
100      * _Available since v2.4.0._
101      */
102     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         // Solidity only automatically asserts when dividing by 0
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         return mod(a, b, "SafeMath: modulo by zero");
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts with custom message when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      *
137      * _Available since v2.4.0._
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 interface IERC20 {
146 
147     function totalSupply() external view returns (uint256);
148 
149     function balanceOf(address account) external view returns (uint256);
150 
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     function approve(address spender, uint256 amount) external returns (bool);
156 
157     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
158 
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 contract Context {
165     // Empty internal constructor, to prevent people from mistakenly deploying
166     // an instance of this contract, which should be used via inheritance.
167     constructor () internal { }
168     // solhint-disable-previous-line no-empty-blocks
169 
170     function _msgSender() internal view returns (address payable) {
171         return msg.sender;
172     }
173 
174     function _msgData() internal view returns (bytes memory) {
175         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
176         return msg.data;
177     }
178 }
179 
180 contract ERC20 is Context, IERC20 {
181     using SafeMath for uint256;
182 
183     mapping (address => uint256) private _balances;
184 
185     mapping (address => mapping (address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     /**
190      * @dev See {IERC20-totalSupply}.
191      */
192     function totalSupply() public view returns (uint256) {
193         return _totalSupply;
194     }
195     
196     function balanceOf(address account) public view returns (uint256) {
197         return _balances[account];
198     }
199     
200     function transfer(address recipient, uint256 amount) public returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204     
205     function allowance(address owner, address spender) public view returns (uint256) {
206         return _allowances[owner][spender];
207     }
208     
209     function approve(address spender, uint256 amount) public returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213     
214     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219     
220     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
222         return true;
223     }
224     
225     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
226         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
227         return true;
228     }
229     
230     function _transfer(address sender, address recipient, uint256 amount) internal {
231         require(sender != address(0), "ERC20: transfer from the zero address");
232         require(recipient != address(0), "ERC20: transfer to the zero address");
233 
234         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
235         _balances[recipient] = _balances[recipient].add(amount);
236         emit Transfer(sender, recipient, amount);
237     }
238     
239     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
240      * the total supply.
241      *
242      * Emits a {Transfer} event with `from` set to the zero address.
243      *
244      * Requirements
245      *
246      * - `to` cannot be the zero address.
247      */
248     function _mint(address account, uint256 amount) internal {
249         require(account != address(0), "ERC20: mint to the zero address");
250 
251         _totalSupply = _totalSupply.add(amount);
252         _balances[account] = _balances[account].add(amount);
253         emit Transfer(address(0), account, amount);
254     }
255 
256     function _burn(address account, uint256 amount) internal {
257         require(account != address(0), "ERC20: burn from the zero address");
258 
259         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
260         _totalSupply = _totalSupply.sub(amount);
261         emit Transfer(account, address(0), amount);
262     }
263 
264     function _approve(address owner, address spender, uint256 amount) internal {
265         require(owner != address(0), "ERC20: approve from the zero address");
266         require(spender != address(0), "ERC20: approve to the zero address");
267 
268         _allowances[owner][spender] = amount;
269         emit Approval(owner, spender, amount);
270     }
271     
272     function _burnFrom(address account, uint256 amount) internal {
273         _burn(account, amount);
274         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
275     }
276 }
277 
278 contract ERC20Detailed is IERC20 {
279     string private _name;
280     string private _symbol;
281     uint8 private _decimals;
282 
283     /**
284      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
285      * these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor (string memory name, string memory symbol, uint8 decimals) public {
289         _name = name;
290         _symbol = symbol;
291         _decimals = decimals;
292     }
293 
294     /**
295      * @dev Returns the name of the token.
296      */
297     function name() public view returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @dev Returns the symbol of the token, usually a shorter version of the
303      * name.
304      */
305     function symbol() public view returns (string memory) {
306         return _symbol;
307     }
308 
309     /**
310      * @dev Returns the number of decimals used to get its user representation.
311      * For example, if `decimals` equals `2`, a balance of `505` tokens should
312      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
313      *
314      * Tokens usually opt for a value of 18, imitating the relationship between
315      * Ether and Wei.
316      *
317      * NOTE: This information is only used for _display_ purposes: it in
318      * no way affects any of the arithmetic of the contract, including
319      * {IERC20-balanceOf} and {IERC20-transfer}.
320      */
321     function decimals() public view returns (uint8) {
322         return _decimals;
323     }
324 }
325 
326 contract BistoxExhangeToken is Context, ERC20, ERC20Detailed {
327     
328     constructor (address owner, string memory name, string memory symbol) public ERC20Detailed(name, symbol, 18) {
329         _mint(owner, 200000000 * (10 ** uint256(decimals())));
330     }
331 }