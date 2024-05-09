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
16 
17     function _msgSender() internal view returns (address payable) {
18         return msg.sender;
19     }
20 }
21 contract ERC20 is Context, IERC20 {
22     using SafeMath for uint;
23 
24     mapping (address => uint) private _balances;
25 
26     mapping (address => mapping (address => uint)) private _allowances;
27 
28     uint private _totalSupply;
29     function totalSupply() public view returns (uint) {
30         return _totalSupply;
31     }
32     function balanceOf(address account) public view returns (uint) {
33         return _balances[account];
34     }
35     function transfer(address recipient, uint amount) public returns (bool) {
36         _transfer(_msgSender(), recipient, amount);
37         return true;
38     }
39     function allowance(address owner, address spender) public view returns (uint) {
40         return _allowances[owner][spender];
41     }
42     function approve(address spender, uint amount) public returns (bool) {
43         _approve(_msgSender(), spender, amount);
44         return true;
45     }
46     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
47         _transfer(sender, recipient, amount);
48         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
49         return true;
50     }
51     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
52         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
53         return true;
54     }
55     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
56         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
57         return true;
58     }
59     function _transfer(address sender, address recipient, uint amount) internal {
60         require(sender != address(0), "ERC20: transfer from the zero address");
61         require(recipient != address(0), "ERC20: transfer to the zero address");
62 
63         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
64         _balances[recipient] = _balances[recipient].add(amount);
65         emit Transfer(sender, recipient, amount);
66     }
67     function _mint(address account, uint amount) internal {
68         require(account != address(0), "ERC20: mint to the zero address");
69 
70         _totalSupply = _totalSupply.add(amount);
71         _balances[account] = _balances[account].add(amount);
72         emit Transfer(address(0), account, amount);
73     }
74     function _burn(address account, uint amount) internal {
75         require(account != address(0), "ERC20: burn from the zero address");
76 
77         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
78         _totalSupply = _totalSupply.sub(amount);
79         emit Transfer(account, address(0), amount);
80     }
81     function _approve(address owner, address spender, uint amount) internal {
82         require(owner != address(0), "ERC20: approve from the zero address");
83         require(spender != address(0), "ERC20: approve to the zero address");
84 
85         _allowances[owner][spender] = amount;
86         emit Approval(owner, spender, amount);
87     }
88 }
89 
90 contract ERC20Detailed is IERC20 {
91     string private _name;
92     string private _symbol;
93     uint8 private _decimals;
94 
95     constructor (string memory name, string memory symbol, uint8 decimals) public {
96         _name = name;
97         _symbol = symbol;
98         _decimals = decimals;
99     }
100     function name() public view returns (string memory) {
101         return _name;
102     }
103     function symbol() public view returns (string memory) {
104         return _symbol;
105     }
106     function decimals() public view returns (uint8) {
107         return _decimals;
108     }
109 }
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
140         require(b > 0, errorMessage);
141         uint c = a / b;
142 
143         return c;
144     }
145 }
146 
147 library Address {
148     function isContract(address account) internal view returns (bool) {
149         bytes32 codehash;
150         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
151         // solhint-disable-next-line no-inline-assembly
152         assembly { codehash := extcodehash(account) }
153         return (codehash != 0x0 && codehash != accountHash);
154     }
155 }
156 
157 library SafeERC20 {
158     using SafeMath for uint;
159     using Address for address;
160 
161     function safeTransfer(IERC20 token, address to, uint value) internal {
162         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
163     }
164 
165     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
166         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
167     }
168 
169     function safeApprove(IERC20 token, address spender, uint value) internal {
170         require((value == 0) || (token.allowance(address(this), spender) == 0),
171             "SafeERC20: approve from non-zero to non-zero allowance"
172         );
173         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
174     }
175     function callOptionalReturn(IERC20 token, bytes memory data) private {
176         require(address(token).isContract(), "SafeERC20: call to non-contract");
177 
178         (bool success, bytes memory returndata) = address(token).call(data);
179         require(success, "SafeERC20: low-level call failed");
180 
181         if (returndata.length > 0) { 
182             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
183         }
184     }
185 }
186 
187 contract YearnSwap is ERC20, ERC20Detailed {
188   using SafeERC20 for IERC20;
189   using Address for address;
190   using SafeMath for uint;
191   
192   
193   address public governance;
194   mapping (address => bool) public minters;
195 
196   constructor () public ERC20Detailed("YearnSwap", "YFSW", 18) {
197       governance = tx.origin;
198   }
199 
200   function mint(address account, uint256 amount) public {
201       require(minters[msg.sender], "!minter");
202       _mint(account, amount);
203   }
204   
205   function setGovernance(address _governance) public {
206       require(msg.sender == governance, "!governance");
207       governance = _governance;
208   }
209   
210   function addMinter(address _minter) public {
211       require(msg.sender == governance, "!governance");
212       minters[_minter] = true;
213   }
214   
215   function removeMinter(address _minter) public {
216       require(msg.sender == governance, "!governance");
217       minters[_minter] = false;
218   }
219 }