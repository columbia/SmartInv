1 //   _    _ _   _                __ _                            
2 //  | |  (_) | | |              / _(_)                           
3 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
4 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
5 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
6 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
7 //
8 //  DEX : the token for AlphaSwap & AlphaDex
9 //
10 //  https://www.AlphaSwap.org
11 //
12 pragma solidity ^0.5.16;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint);
16     function balanceOf(address account) external view returns (uint);
17     function transfer(address recipient, uint amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint);
19     function approve(address spender, uint amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint value);
22     event Approval(address indexed owner, address indexed spender, uint value);
23 }
24 
25 contract Context {
26     constructor () internal { }
27     // solhint-disable-previous-line no-empty-blocks
28 
29     function _msgSender() internal view returns (address payable) {
30         return msg.sender;
31     }
32 }
33 
34 contract ERC20 is Context, IERC20 {
35     using SafeMath for uint;
36 
37     mapping (address => uint) private _balances;
38 
39     mapping (address => mapping (address => uint)) private _allowances;
40 
41     uint private _totalSupply;
42     function totalSupply() public view returns (uint) {
43         return _totalSupply;
44     }
45     function balanceOf(address account) public view returns (uint) {
46         return _balances[account];
47     }
48     function transfer(address recipient, uint amount) public returns (bool) {
49         _transfer(_msgSender(), recipient, amount);
50         return true;
51     }
52     function allowance(address owner, address spender) public view returns (uint) {
53         return _allowances[owner][spender];
54     }
55     function approve(address spender, uint amount) public returns (bool) {
56         _approve(_msgSender(), spender, amount);
57         return true;
58     }
59     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
60         _transfer(sender, recipient, amount);
61         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
62         return true;
63     }
64     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
65         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
66         return true;
67     }
68     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
69         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
70         return true;
71     }
72     function _transfer(address sender, address recipient, uint amount) internal {
73         require(sender != address(0), "ERC20: transfer from the zero address");
74         require(recipient != address(0), "ERC20: transfer to the zero address");
75 
76         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
77         _balances[recipient] = _balances[recipient].add(amount);
78         emit Transfer(sender, recipient, amount);
79     }
80     function _mint(address account, uint amount) internal {
81         require(account != address(0), "ERC20: mint to the zero address");
82 
83         _totalSupply = _totalSupply.add(amount);
84         _balances[account] = _balances[account].add(amount);
85         emit Transfer(address(0), account, amount);
86     }
87     function _burn(address account, uint amount) internal {
88         require(account != address(0), "ERC20: burn from the zero address");
89 
90         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
91         _totalSupply = _totalSupply.sub(amount);
92         emit Transfer(account, address(0), amount);
93     }
94     function _approve(address owner, address spender, uint amount) internal {
95         require(owner != address(0), "ERC20: approve from the zero address");
96         require(spender != address(0), "ERC20: approve to the zero address");
97 
98         _allowances[owner][spender] = amount;
99         emit Approval(owner, spender, amount);
100     }
101 }
102 
103 contract ERC20Detailed is IERC20 {
104     string private _name;
105     string private _symbol;
106     uint8 private _decimals;
107 
108     constructor (string memory name, string memory symbol, uint8 decimals) public {
109         _name = name;
110         _symbol = symbol;
111         _decimals = decimals;
112     }
113     function name() public view returns (string memory) {
114         return _name;
115     }
116     function symbol() public view returns (string memory) {
117         return _symbol;
118     }
119     function decimals() public view returns (uint8) {
120         return _decimals;
121     }
122 }
123 
124 library SafeMath {
125     function add(uint a, uint b) internal pure returns (uint) {
126         uint c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131     function sub(uint a, uint b) internal pure returns (uint) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
135         require(b <= a, errorMessage);
136         uint c = a - b;
137 
138         return c;
139     }
140     function mul(uint a, uint b) internal pure returns (uint) {
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150     function div(uint a, uint b) internal pure returns (uint) {
151         return div(a, b, "SafeMath: division by zero");
152     }
153     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
154         // Solidity only automatically asserts when dividing by 0
155         require(b > 0, errorMessage);
156         uint c = a / b;
157 
158         return c;
159     }
160 }
161 
162 library Address {
163     function isContract(address account) internal view returns (bool) {
164         bytes32 codehash;
165         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
166         // solhint-disable-next-line no-inline-assembly
167         assembly { codehash := extcodehash(account) }
168         return (codehash != 0x0 && codehash != accountHash);
169     }
170 }
171 
172 library SafeERC20 {
173     using SafeMath for uint;
174     using Address for address;
175 
176     function safeTransfer(IERC20 token, address to, uint value) internal {
177         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
178     }
179 
180     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
181         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
182     }
183 
184     function safeApprove(IERC20 token, address spender, uint value) internal {
185         require((value == 0) || (token.allowance(address(this), spender) == 0),
186             "SafeERC20: approve from non-zero to non-zero allowance"
187         );
188         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
189     }
190     function callOptionalReturn(IERC20 token, bytes memory data) private {
191         require(address(token).isContract(), "SafeERC20: call to non-contract");
192 
193         // solhint-disable-next-line avoid-low-level-calls
194         (bool success, bytes memory returndata) = address(token).call(data);
195         require(success, "SafeERC20: low-level call failed");
196 
197         if (returndata.length > 0) { // Return data is optional
198             // solhint-disable-next-line max-line-length
199             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
200         }
201     }
202 }
203 
204 contract DEX is ERC20, ERC20Detailed {
205     using SafeERC20 for IERC20;
206     using Address for address;
207     using SafeMath for uint;
208 
209     address public governance;
210     mapping (address => bool) public minters;
211 
212     constructor () public ERC20Detailed("AlphaDex", "DEX", 18) {
213         governance = msg.sender;
214     }
215 
216     function mint(address account, uint256 amount) public {
217         require(minters[msg.sender], "!minter");
218         _mint(account, amount);
219     }
220 
221     function burn(uint256 amount) public {
222         _burn(msg.sender, amount);
223     }
224 
225     function setGovernance(address _governance) public {
226         require(msg.sender == governance, "!governance");
227         governance = _governance;
228     }
229 
230     function addMinter(address _minter) public {
231         require(msg.sender == governance, "!governance");
232         minters[_minter] = true;
233     }
234 
235     function removeMinter(address _minter) public {
236         require(msg.sender == governance, "!governance");
237         minters[_minter] = false;
238     }
239 }