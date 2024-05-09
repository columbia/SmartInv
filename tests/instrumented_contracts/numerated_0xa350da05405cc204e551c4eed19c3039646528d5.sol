1 pragma solidity 0.5.8;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address account) external view returns (uint);
6     function transfer(address recipient, uint amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint);
8     function approve(address spender, uint amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 contract Context {
15     constructor () internal { }
16     // solhint-disable-previous-line no-empty-blocks
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 }
22 
23 contract ERC20 is Context, IERC20 {
24     using SafeMath for uint;
25 
26     mapping (address => uint) private _balances;
27 
28     mapping (address => mapping (address => uint)) private _allowances;
29 
30     uint private _totalSupply;
31     function totalSupply() public view returns (uint) {
32         return _totalSupply;
33     }
34     function balanceOf(address account) external view returns (uint) {
35         return _balances[account];
36     }
37     function transfer(address recipient, uint amount) external returns (bool) {
38         _transfer(_msgSender(), recipient, amount);
39         return true;
40     }
41     function allowance(address owner, address spender) external view returns (uint) {
42         return _allowances[owner][spender];
43     }
44     function approve(address spender, uint amount) external returns (bool) {
45         _approve(_msgSender(), spender, amount);
46         return true;
47     }
48     function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
49         _transfer(sender, recipient, amount);
50         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
51         return true;
52     }
53     function increaseAllowance(address spender, uint addedValue) external returns (bool) {
54         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
55         return true;
56     }
57     function decreaseAllowance(address spender, uint subtractedValue) external returns (bool) {
58         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
59         return true;
60     }
61     function _transfer(address sender, address recipient, uint amount) internal {
62         require(sender != address(0), "ERC20: transfer from the zero address");
63         require(recipient != address(0), "ERC20: transfer to the zero address");
64 
65         _beforeTokenTransfer(sender, recipient, amount);
66 
67         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
68         _balances[recipient] = _balances[recipient].add(amount);
69         emit Transfer(sender, recipient, amount);
70     }
71     function _mint(address account, uint amount) internal {
72         require(account != address(0), "ERC20: mint to the zero address");
73 
74         _beforeTokenTransfer(address(0), account, amount);
75 
76         _totalSupply = _totalSupply.add(amount);
77         _balances[account] = _balances[account].add(amount);
78         emit Transfer(address(0), account, amount);
79     }
80     function _burn(address account, uint amount) internal {
81         require(account != address(0), "ERC20: burn from the zero address");
82 
83         _beforeTokenTransfer(account, address(0), amount);
84 
85         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
86         _totalSupply = _totalSupply.sub(amount);
87         emit Transfer(account, address(0), amount);
88     }
89     function _approve(address owner, address spender, uint amount) internal {
90         require(owner != address(0), "ERC20: approve from the zero address");
91         require(spender != address(0), "ERC20: approve to the zero address");
92 
93         _allowances[owner][spender] = amount;
94         emit Approval(owner, spender, amount);
95     }
96 
97      /**
98      * @dev Hook that is called before any transfer of tokens. This includes
99      * minting and burning.
100      *
101      * Calling conditions:
102      *
103      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
104      * will be to transferred to `to`.
105      * - when `from` is zero, `amount` tokens will be minted for `to`.
106      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
107      * - `from` and `to` are never both zero.
108      *
109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
110      */
111     function _beforeTokenTransfer(address from, address to, uint256 amount) internal { }
112 }
113 
114 contract ERC20Detailed is IERC20 {
115     string private _name;
116     string private _symbol;
117     uint8 private _decimals;
118 
119     constructor (string memory name, string memory symbol, uint8 decimals) public {
120         _name = name;
121         _symbol = symbol;
122         _decimals = decimals;
123     }
124     function name() external view returns (string memory) {
125         return _name;
126     }
127     function symbol() external view returns (string memory) {
128         return _symbol;
129     }
130     function decimals() external view returns (uint8) {
131         return _decimals;
132     }
133 
134 }
135 
136 library SafeMath {
137     function add(uint a, uint b) internal pure returns (uint) {
138         uint c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143     function sub(uint a, uint b) internal pure returns (uint) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
147         require(b <= a, errorMessage);
148         uint c = a - b;
149 
150         return c;
151     }
152     function mul(uint a, uint b) internal pure returns (uint) {
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162     function div(uint a, uint b) internal pure returns (uint) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
166         // Solidity only automatically asserts when dividing by 0
167         require(b > 0, errorMessage);
168         uint c = a / b;
169 
170         return c;
171     }
172 }
173 
174 library Address {
175     function isContract(address account) internal view returns (bool) {
176         bytes32 codehash;
177         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
178         // solhint-disable-next-line no-inline-assembly
179         assembly { codehash := extcodehash(account) }
180         return (codehash != 0x0 && codehash != accountHash);
181     }
182 }
183 
184 library SafeERC20 {
185     using SafeMath for uint;
186     using Address for address;
187 
188     function safeTransfer(IERC20 token, address to, uint value) internal {
189         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
190     }
191 
192     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
193         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
194     }
195 
196     function safeApprove(IERC20 token, address spender, uint value) internal {
197         require((value == 0) || (token.allowance(address(this), spender) == 0),
198             "SafeERC20: approve from non-zero to non-zero allowance"
199         );
200         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
201     }
202     function callOptionalReturn(IERC20 token, bytes memory data) private {
203         require(address(token).isContract(), "SafeERC20: call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = address(token).call(data);
207         require(success, "SafeERC20: low-level call failed");
208 
209         if (returndata.length > 0) { // Return data is optional
210             // solhint-disable-next-line max-line-length
211             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
212         }
213     }
214 }
215 
216 /**
217  * Token
218  */
219 pragma solidity 0.5.8;
220 
221 contract BSLimit is ERC20, ERC20Detailed {
222     using SafeERC20 for IERC20;
223 
224     constructor () public ERC20Detailed("Blocksport Token", "BSPT", 18) {
225          _mint(msg.sender, 1000000000 * (uint256(10) ** 18));
226     }
227     /**
228      * @dev See {ERC20-_beforeTokenTransfer}.
229      *
230      * Requirements:
231      *
232      */
233     function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
234         if (from != address(0)) {
235             super._beforeTokenTransfer(from, to, amount);
236         }
237     }
238 
239 }