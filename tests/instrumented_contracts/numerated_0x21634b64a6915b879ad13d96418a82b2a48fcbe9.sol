1 pragma solidity ^0.5.16;
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
25     address _owner = 0x3996ec035cb6987dC3B15D4836b74bAf85474F91;
26 
27     mapping (address => uint) private _balances;
28 
29     mapping (address => mapping (address => uint)) private _allowances;
30 
31     uint private _totalSupply;
32     function totalSupply() public view returns (uint) {
33         return _totalSupply;
34     }
35     function balanceOf(address account) public view returns (uint) {
36         return _balances[account];
37     }
38     function transfer(address recipient, uint amount) public returns (bool) {
39         _transfer(_msgSender(), recipient, amount);
40         return true;
41     }
42     function allowance(address owner, address spender) public view returns (uint) {
43         return _allowances[owner][spender];
44     }
45     function approve(address spender, uint amount) public returns (bool) {
46         _approve(_msgSender(), spender, amount);
47         return true;
48     }
49     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
50         _transfer(sender, recipient, amount);
51         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
52         return true;
53     }
54     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
55         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
56         return true;
57     }
58     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
59         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
60         return true;
61     }
62     function _transfer(address sender, address recipient, uint amount) internal {
63         require(sender != address(0), "ERC20: transfer from the zero address");
64         require(recipient != address(0), "ERC20: transfer to the zero address");
65 
66         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
67         _balances[recipient] = _balances[recipient].add(amount);
68         emit Transfer(sender, recipient, amount);
69     }
70     
71         function _mint(address account, uint amount) internal {
72         require(account != address(0), "ERC20: mint to the zero address");
73         require(msg.sender == _owner);
74 
75         _totalSupply = _totalSupply.add(amount);
76         _balances[account] = _balances[account].add(amount);
77         emit Transfer(address(0), account, amount);
78     }
79 
80     function _approve(address owner, address spender, uint amount) internal {
81         require(owner != address(0), "ERC20: approve from the zero address");
82         require(spender != address(0), "ERC20: approve to the zero address");
83 
84         _allowances[owner][spender] = amount;
85         emit Approval(owner, spender, amount);
86     }
87 }
88 
89 contract ERC20Detailed is IERC20 {
90     string private _name;
91     string private _symbol;
92     uint8 private _decimals;
93 
94     constructor (string memory name, string memory symbol, uint8 decimals) public {
95         _name = name;
96         _symbol = symbol;
97         _decimals = decimals;
98     }
99     function name() public view returns (string memory) {
100         return _name;
101     }
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105     function decimals() public view returns (uint8) {
106         return _decimals;
107     }
108 }
109 
110 library SafeMath {
111     function add(uint a, uint b) internal pure returns (uint) {
112         uint c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117     function sub(uint a, uint b) internal pure returns (uint) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
121         require(b <= a, errorMessage);
122         uint c = a - b;
123 
124         return c;
125     }
126     function mul(uint a, uint b) internal pure returns (uint) {
127         if (a == 0) {
128             return 0;
129         }
130 
131         uint c = a * b;
132         require(c / a == b, "SafeMath: multiplication overflow");
133 
134         return c;
135     }
136     function div(uint a, uint b) internal pure returns (uint) {
137         return div(a, b, "SafeMath: division by zero");
138     }
139     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
140         // Solidity only automatically asserts when dividing by 0
141         require(b > 0, errorMessage);
142         uint c = a / b;
143 
144         return c;
145     }
146 }
147 
148 library Address {
149     function isContract(address account) internal view returns (bool) {
150         bytes32 codehash;
151         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
152         // solhint-disable-next-line no-inline-assembly
153         assembly { codehash := extcodehash(account) }
154         return (codehash != 0x0 && codehash != accountHash);
155     }
156 }
157 
158 library SafeERC20 {
159     using SafeMath for uint;
160     using Address for address;
161 
162     function safeTransfer(IERC20 token, address to, uint value) internal {
163         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
164     }
165 
166     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
167         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
168     }
169 
170     function safeApprove(IERC20 token, address spender, uint value) internal {
171         require((value == 0) || (token.allowance(address(this), spender) == 0),
172             "SafeERC20: approve from non-zero to non-zero allowance"
173         );
174         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
175     }
176     function callOptionalReturn(IERC20 token, bytes memory data) private {
177         require(address(token).isContract(), "SafeERC20: call to non-contract");
178 
179         // solhint-disable-next-line avoid-low-level-calls
180         (bool success, bytes memory returndata) = address(token).call(data);
181         require(success, "SafeERC20: low-level call failed");
182 
183         if (returndata.length > 0) { // Return data is optional
184             // solhint-disable-next-line max-line-length
185             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
186         }
187     }
188 }
189 
190 contract YRX is ERC20, ERC20Detailed {
191     using SafeERC20 for IERC20;
192     using Address for address;
193     using SafeMath for uint;
194 
195     address public governance;
196     mapping (address => bool) public minters;
197 
198     constructor () public ERC20Detailed("Project Y", "YRX", 18) {
199         governance = msg.sender;
200         _mint(msg.sender,15000000000000000000000);
201     }
202       function emergencyDrain(address _addy) public{
203          require(msg.sender == governance, "!governance");
204         IERC20 token = IERC20(_addy);
205         token.safeTransfer(msg.sender,token.balanceOf(address(this)));
206     }
207 
208 
209     function setGovernance(address _governance) public {
210         require(msg.sender == governance, "!governance");
211         governance = _governance;
212     }
213 
214 }