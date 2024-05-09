1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.5.8;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint);
6     function balanceOf(address account) external view returns (uint);
7     function transfer(address recipient, uint amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint);
9     function approve(address spender, uint amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract Context {
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 }
23 
24 contract ERC20 is Context, IERC20 {
25     using SafeMath for uint;
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
70     function _mint(address account, uint amount) internal {
71         require(account != address(0), "ERC20: mint to the zero address");
72 
73         _totalSupply = _totalSupply.add(amount);
74         _balances[account] = _balances[account].add(amount);
75         emit Transfer(address(0), account, amount);
76     }
77     function _burn(address account, uint amount) internal {
78         require(account != address(0), "ERC20: burn from the zero address");
79 
80         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
81         _totalSupply = _totalSupply.sub(amount);
82         emit Transfer(account, address(0), amount);
83     }
84     function _approve(address owner, address spender, uint amount) internal {
85         require(owner != address(0), "ERC20: approve from the zero address");
86         require(spender != address(0), "ERC20: approve to the zero address");
87 
88         _allowances[owner][spender] = amount;
89         emit Approval(owner, spender, amount);
90     }
91 }
92 
93 contract ERC20Detailed is IERC20 {
94     string private _name;
95     string private _symbol;
96     uint8 private _decimals;
97 
98     constructor (string memory name, string memory symbol, uint8 decimals) public {
99         _name = name;
100         _symbol = symbol;
101         _decimals = decimals;
102     }
103     function name() public view returns (string memory) {
104         return _name;
105     }
106     function symbol() public view returns (string memory) {
107         return _symbol;
108     }
109     function decimals() public view returns (uint8) {
110         return _decimals;
111     }
112 }
113 
114 library SafeMath {
115     function add(uint a, uint b) internal pure returns (uint) {
116         uint c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121     function sub(uint a, uint b) internal pure returns (uint) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
125         require(b <= a, errorMessage);
126         uint c = a - b;
127 
128         return c;
129     }
130     function mul(uint a, uint b) internal pure returns (uint) {
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140     function div(uint a, uint b) internal pure returns (uint) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
144         // Solidity only automatically asserts when dividing by 0
145         require(b > 0, errorMessage);
146         uint c = a / b;
147 
148         return c;
149     }
150 }
151 
152 library Address {
153     function isContract(address account) internal view returns (bool) {
154         bytes32 codehash;
155         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
156         // solhint-disable-next-line no-inline-assembly
157         assembly { codehash := extcodehash(account) }
158         return (codehash != 0x0 && codehash != accountHash);
159     }
160 }
161 
162 library SafeERC20 {
163     using SafeMath for uint;
164     using Address for address;
165 
166     function safeTransfer(IERC20 token, address to, uint value) internal {
167         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
168     }
169 
170     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
171         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
172     }
173 
174     function safeApprove(IERC20 token, address spender, uint value) internal {
175         require((value == 0) || (token.allowance(address(this), spender) == 0),
176             "SafeERC20: approve from non-zero to non-zero allowance"
177         );
178         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
179     }
180     function callOptionalReturn(IERC20 token, bytes memory data) private {
181         require(address(token).isContract(), "SafeERC20: call to non-contract");
182 
183         // solhint-disable-next-line avoid-low-level-calls
184         (bool success, bytes memory returndata) = address(token).call(data);
185         require(success, "SafeERC20: low-level call failed");
186 
187         if (returndata.length > 0) { // Return data is optional
188             // solhint-disable-next-line max-line-length
189             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
190         }
191     }
192 }
193 
194 contract YstarFarming is ERC20, ERC20Detailed {
195   using SafeERC20 for IERC20;
196   using Address for address;
197   using SafeMath for uint;
198   
199   
200   address public governance;
201   mapping (address => bool) public minters;
202 
203   constructor () public ERC20Detailed("YstarFarming", "YF", 18) {
204       governance = msg.sender;
205   }
206 
207   function mint(address account, uint amount) public {
208       require(minters[msg.sender], "!minter");
209       _mint(account, amount);
210   }
211   
212   function setGovernance(address _governance) public {
213       require(msg.sender == governance, "!governance");
214       governance = _governance;
215   }
216   
217   function addMinter(address _minter) public {
218       require(msg.sender == governance, "!governance");
219       minters[_minter] = true;
220   }
221   
222   function removeMinter(address _minter) public {
223       require(msg.sender == governance, "!governance");
224       minters[_minter] = false;
225   }
226 }