1 pragma solidity ^0.5.0;
2 
3 import "./../../GSN/Context.sol";
4 import "./IERC20.sol";
5 import "./../../math/SafeMath.sol";
6 
7 /**
8  * @dev Implementation of the {IERC20} interface.
9  *
10  * This implementation is agnostic to the way tokens are created. This means
11  * that a supply mechanism has to be added in a derived contract using {_mint}.
12  * For a generic mechanism see {ERC20Mintable}.
13  *
14  * TIP: For a detailed writeup see our guide
15  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
16  * to implement supply mechanisms].
17  *
18  * We have followed general OpenZeppelin guidelines: functions revert instead
19  * of returning `false` on failure. This behavior is nonetheless conventional
20  * and does not conflict with the expectations of ERC20 applications.
21  *
22  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
23  * This allows applications to reconstruct the allowance for all accounts just
24  * by listening to said events. Other implementations of the EIP may not emit
25  * these events, as it isn't required by the specification.
26  *
27  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
28  * functions have been added to mitigate the well-known issues around setting
29  * allowances. See {IERC20-approve}.
30  * Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
31  */
32 contract ERC20 is Context, IERC20 {
33     using SafeMath for uint256;
34 
35     mapping (address => uint256) private _balances;
36 
37     mapping (address => mapping (address => uint256)) private _allowances;
38 
39     uint256 private _totalSupply;
40 
41     /**
42      * @dev See {IERC20-totalSupply}.
43      */
44     function totalSupply() public view returns (uint256) {
45         return _totalSupply;
46     }
47 
48     /**
49      * @dev See {IERC20-balanceOf}.
50      */
51     function balanceOf(address account) public view returns (uint256) {
52         return _balances[account];
53     }
54 
55     /**
56      * @dev See {IERC20-transfer}.
57      *
58      * Requirements:
59      *
60      * - `recipient` cannot be the zero address.
61      * - the caller must have a balance of at least `amount`.
62      */
63     function transfer(address recipient, uint256 amount) public returns (bool) {
64         _transfer(_msgSender(), recipient, amount);
65         return true;
66     }
67 
68     /**
69      * @dev See {IERC20-allowance}.
70      */
71     function allowance(address owner, address spender) public view returns (uint256) {
72         return _allowances[owner][spender];
73     }
74 
75     /**
76      * @dev See {IERC20-approve}.
77      *
78      * Requirements:
79      *
80      * - `spender` cannot be the zero address.
81      */
82     function approve(address spender, uint256 amount) public returns (bool) {
83         _approve(_msgSender(), spender, amount);
84         return true;
85     }
86 
87     /**
88      * @dev See {IERC20-transferFrom}.
89      *
90      * Emits an {Approval} event indicating the updated allowance. This is not
91      * required by the EIP. See the note at the beginning of {ERC20};
92      *
93      * Requirements:
94      * - `sender` and `recipient` cannot be the zero address.
95      * - `sender` must have a balance of at least `amount`.
96      * - the caller must have allowance for `sender`'s tokens of at least
97      * `amount`.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
100         _transfer(sender, recipient, amount);
101         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
102         return true;
103     }
104 
105     /**
106      * @dev Atomically increases the allowance granted to `spender` by the caller.
107      *
108      * This is an alternative to {approve} that can be used as a mitigation for
109      * problems described in {IERC20-approve}.
110      *
111      * Emits an {Approval} event indicating the updated allowance.
112      *
113      * Requirements:
114      *
115      * - `spender` cannot be the zero address.
116      */
117     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
118         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
119         return true;
120     }
121 
122     /**
123      * @dev Atomically decreases the allowance granted to `spender` by the caller.
124      *
125      * This is an alternative to {approve} that can be used as a mitigation for
126      * problems described in {IERC20-approve}.
127      *
128      * Emits an {Approval} event indicating the updated allowance.
129      *
130      * Requirements:
131      *
132      * - `spender` cannot be the zero address.
133      * - `spender` must have allowance for the caller of at least
134      * `subtractedValue`.
135      */
136     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
137         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
138         return true;
139     }
140 
141     /**
142      * @dev Moves tokens `amount` from `sender` to `recipient`.
143      *
144      * This is internal function is equivalent to {transfer}, and can be used to
145      * e.g. implement automatic token fees, slashing mechanisms, etc.
146      *
147      * Emits a {Transfer} event.
148      *
149      * Requirements:
150      *
151      * - `sender` cannot be the zero address.
152      * - `recipient` cannot be the zero address.
153      * - `sender` must have a balance of at least `amount`.
154      */
155     function _transfer(address sender, address recipient, uint256 amount) internal {
156         require(sender != address(0), "ERC20: transfer from the zero address");
157         require(recipient != address(0), "ERC20: transfer to the zero address");
158 
159         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
160         _balances[recipient] = _balances[recipient].add(amount);
161         emit Transfer(sender, recipient, amount);
162     }
163 
164     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
165      * the total supply.
166      *
167      * Emits a {Transfer} event with `from` set to the zero address.
168      *
169      * Requirements
170      *
171      * - `to` cannot be the zero address.
172      */
173     function _mint(address account, uint256 amount) internal {
174         require(account != address(0), "ERC20: mint to the zero address");
175 
176         _totalSupply = _totalSupply.add(amount);
177         _balances[account] = _balances[account].add(amount);
178         emit Transfer(address(0), account, amount);
179     }
180 
181     /**
182      * @dev Destroys `amount` tokens from `account`, reducing the
183      * total supply.
184      *
185      * Emits a {Transfer} event with `to` set to the zero address.
186      *
187      * Requirements
188      *
189      * - `account` cannot be the zero address.
190      * - `account` must have at least `amount` tokens.
191      */
192     function _burn(address account, uint256 amount) internal {
193         require(account != address(0), "ERC20: burn from the zero address");
194 
195         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
196         _totalSupply = _totalSupply.sub(amount);
197         emit Transfer(account, address(0), amount);
198     }
199 
200     /**
201      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
202      *
203      * This is internal function is equivalent to `approve`, and can be used to
204      * e.g. set automatic allowances for certain subsystems, etc.
205      *
206      * Emits an {Approval} event.
207      *
208      * Requirements:
209      *
210      * - `owner` cannot be the zero address.
211      * - `spender` cannot be the zero address.
212      */
213     function _approve(address owner, address spender, uint256 amount) internal {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216 
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     /**
222      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
223      * from the caller's allowance.
224      *
225      * See {_burn} and {_approve}.
226      */
227     function _burnFrom(address account, uint256 amount) internal {
228         _burn(account, amount);
229         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
230     }
231 }
