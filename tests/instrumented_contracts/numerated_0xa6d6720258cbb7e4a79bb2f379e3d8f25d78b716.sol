1 pragma solidity ^0.5.0;
2 
3 contract Ownable {
4    address payable public owner;
5 
6    event OwnershipTransferred(address indexed _from, address indexed _to);
7 
8    constructor() public {
9        owner = 0xAEDbd7b44e2069A1BCef7F94D357C13870e2A1a4;
10    }
11 
12    modifier onlyOwner {
13        require(msg.sender == owner);
14        _;
15    }
16 
17    function transferOwnership(address payable _newOwner) public onlyOwner {
18      
19        emit OwnershipTransferred(owner, _newOwner);
20        owner = _newOwner;
21        
22    }
23 }
24 
25 /**
26  * @dev Wrappers over Solidity's arithmetic operations with added overflow
27  * checks.
28  *
29  * Arithmetic operations in Solidity wrap on overflow. This can easily result
30  * in bugs, because programmers usually assume that an overflow raises an
31  * error, which is the standard behavior in high level programming languages.
32  * `SafeMath` restores this intuition by reverting the transaction when an
33  * operation overflows.
34  *
35  * Using this library instead of the unchecked operations eliminates an entire
36  * class of bugs, so it's recommended to use it always.
37  */
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a, "SafeMath: subtraction overflow");
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0, "SafeMath: division by zero");
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         require(b != 0, "SafeMath: modulo by zero");
127         return a % b;
128     }
129 }
130 
131 contract Token is Ownable {
132     using SafeMath for uint256;
133 
134     mapping (address => uint256) private _balances;
135 
136     mapping (address => mapping (address => uint256)) private _allowances;
137 
138 
139     string private _name;
140     string private _symbol;
141     uint8 private _decimals;
142     uint256 private _totalSupply;
143 
144 
145     event Transfer(address indexed from, address indexed to, uint256 value);
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147    
148     constructor() public {
149         _name = "TOKELITE";
150         _symbol = "TKL";
151         _decimals = 18;
152         _totalSupply = 15000000;
153         _totalSupply = _totalSupply * 10 ** 18;
154         _balances[0xAEDbd7b44e2069A1BCef7F94D357C13870e2A1a4] = _totalSupply;
155         emit Transfer(address(0), 0xAEDbd7b44e2069A1BCef7F94D357C13870e2A1a4, _totalSupply);
156     }
157  
158     /**
159      * @dev Returns the name of the token.
160      */
161     function name() public view returns (string memory) {
162         return _name;
163     }
164 
165     /**
166      * @dev Returns the symbol of the token, usually a shorter version of the
167      * name.
168      */
169     function symbol() public view returns (string memory) {
170         return _symbol;
171     }
172 
173     /**
174      * @dev Returns the number of decimals used to get its user representation.
175      * For example, if `decimals` equals `2`, a balance of `505` tokens should
176      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
177      *
178      * Tokens usually opt for a value of 18, imitating the relationship between
179      * Ether and Wei.
180      *
181      * > Note that this information is only used for _display_ purposes: it in
182      * no way affects any of the arithmetic of the contract, including
183      * `IERC20.balanceOf` and `IERC20.transfer`.
184      */
185     function decimals() public view returns (uint8) {
186         return _decimals;
187     }
188  
189     /**
190      * @dev See `IERC20.totalSupply`.
191      */
192     function totalSupply() public view returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197      * @dev See `IERC20.balanceOf`.
198      */
199     function balanceOf(address account) public view returns (uint256) {
200         return _balances[account];
201     }
202 
203     /**
204      * @dev See `IERC20.transfer`.
205      *
206      * Requirements:
207      *
208      * - `recipient` cannot be the zero address.
209      * - the caller must have a balance of at least `amount`.
210      */
211     function transfer(address recipient, uint256 amount) public returns (bool) {
212         _transfer(msg.sender, recipient, amount);
213         return true;
214     }
215     
216   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
217     require(receivers.length == amounts.length); 
218     for (uint256 i = 0; i < receivers.length; i++) {
219       transfer(receivers[i], amounts[i]);
220     }
221   }
222 
223     /**
224      * @dev See `IERC20.allowance`.
225      */
226     function allowance(address owner, address spender) public view returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See `IERC20.approve`.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(address spender, uint256 value) public returns (bool) {
238         _approve(msg.sender, spender, value);
239         return true;
240     }
241 
242     /**
243      * @dev See `IERC20.transferFrom`.
244      *
245      * Emits an `Approval` event indicating the updated allowance. This is not
246      * required by the EIP. See the note at the beginning of `ERC20`;
247      *
248      * Requirements:
249      * - `sender` and `recipient` cannot be the zero address.
250      * - `sender` must have a balance of at least `value`.
251      * - the caller must have allowance for `sender`'s tokens of at least
252      * `amount`.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
257         return true;
258     }
259 
260     /**
261      * @dev Atomically increases the allowance granted to `spender` by the caller.
262      *
263      * This is an alternative to `approve` that can be used as a mitigation for
264      * problems described in `IERC20.approve`.
265      *
266      * Emits an `Approval` event indicating the updated allowance.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
273         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
274         return true;
275     }
276 
277     /**
278      * @dev Atomically decreases the allowance granted to `spender` by the caller.
279      *
280      * This is an alternative to `approve` that can be used as a mitigation for
281      * problems described in `IERC20.approve`.
282      *
283      * Emits an `Approval` event indicating the updated allowance.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      * - `spender` must have allowance for the caller of at least
289      * `subtractedValue`.
290      */
291     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
292         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
293         return true;
294     }
295     /**
296      * @dev Moves tokens `amount` from `sender` to `recipient`.
297      *
298      * This is internal function is equivalent to `transfer`, and can be used to
299      * e.g. implement automatic token fees, slashing mechanisms, etc.
300      *
301      * Emits a `Transfer` event.
302      *
303      * Requirements:
304      *
305      * - `sender` cannot be the zero address.
306      * - `recipient` cannot be the zero address.
307      * - `sender` must have a balance of at least `amount`.
308      */
309     function _transfer(address sender, address recipient, uint256 amount) internal {
310         require(sender != address(0), "ERC20: transfer from the zero address");
311         require(recipient != address(0), "ERC20: transfer to the zero address");
312 
313         _balances[sender] = _balances[sender].sub(amount);
314         _balances[recipient] = _balances[recipient].add(amount);
315         emit Transfer(sender, recipient, amount);
316     }
317 
318      /**
319      * @dev Destoys `amount` tokens from `account`, reducing the
320      * total supply.
321      *
322      * Emits a `Transfer` event with `to` set to the zero address.
323      *
324      * Requirements
325      *
326      * - `account` cannot be the zero address.
327      * - `account` must have at least `amount` tokens.
328      */
329     function _burn(address account, uint256 value) internal {
330         require(account != address(0), "ERC20: burn from the zero address");
331 
332         _totalSupply = _totalSupply.sub(value);
333         _balances[account] = _balances[account].sub(value);
334         emit Transfer(account, address(0), value);
335     }
336 
337     /**
338      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
339      *
340      * This is internal function is equivalent to `approve`, and can be used to
341      * e.g. set automatic allowances for certain subsystems, etc.
342      *
343      * Emits an `Approval` event.
344      *
345      * Requirements:
346      *
347      * - `owner` cannot be the zero address.
348      * - `spender` cannot be the zero address.
349      */
350     function _approve(address owner, address spender, uint256 value) internal {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353 
354         _allowances[owner][spender] = value;
355         emit Approval(owner, spender, value);
356     }
357 
358 }