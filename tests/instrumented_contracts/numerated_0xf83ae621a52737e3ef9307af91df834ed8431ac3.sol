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
21 
22 contract ERC20 is Context, IERC20 {
23     using SafeMath for uint;
24 
25     mapping (address => uint) private _balances;
26 
27     mapping (address => mapping (address => uint)) private _allowances;
28 
29     uint private _totalSupply;
30     function totalSupply() public view returns (uint) {
31         return _totalSupply;
32     }
33     function balanceOf(address account) public view returns (uint) {
34         return _balances[account];
35     }
36     function transfer(address recipient, uint amount) public returns (bool) {
37         _transfer(_msgSender(), recipient, amount);
38         return true;
39     }
40     function allowance(address owner, address spender) public view returns (uint) {
41         return _allowances[owner][spender];
42     }
43     function approve(address spender, uint amount) public returns (bool) {
44         _approve(_msgSender(), spender, amount);
45         return true;
46     }
47     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
48         _transfer(sender, recipient, amount);
49         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
50         return true;
51     }
52     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
53         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
54         return true;
55     }
56     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
57         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
58         return true;
59     }
60     function _transfer(address sender, address recipient, uint amount) internal {
61         require(sender != address(0), "ERC20: transfer from the zero address");
62         require(recipient != address(0), "ERC20: transfer to the zero address");
63 
64         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
65         _balances[recipient] = _balances[recipient].add(amount);
66         emit Transfer(sender, recipient, amount);
67     }
68     function _mint(address account, uint amount) internal {
69         require(account != address(0), "ERC20: mint to the zero address");
70 
71         _totalSupply = _totalSupply.add(amount);
72         _balances[account] = _balances[account].add(amount);
73         emit Transfer(address(0), account, amount);
74     }
75     function _burn(address account, uint amount) internal {
76         require(account != address(0), "ERC20: burn from the zero address");
77 
78         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
79         _totalSupply = _totalSupply.sub(amount);
80         emit Transfer(account, address(0), amount);
81     }
82     function _approve(address owner, address spender, uint amount) internal {
83         require(owner != address(0), "ERC20: approve from the zero address");
84         require(spender != address(0), "ERC20: approve to the zero address");
85 
86         _allowances[owner][spender] = amount;
87         emit Approval(owner, spender, amount);
88     }
89 }
90 
91 contract ERC20Detailed is IERC20 {
92     string private _name;
93     string private _symbol;
94     uint8 private _decimals;
95 
96     constructor (string memory name, string memory symbol, uint8 decimals) public {
97         _name = name;
98         _symbol = symbol;
99         _decimals = decimals;
100     }
101     function name() public view returns (string memory) {
102         return _name;
103     }
104     function symbol() public view returns (string memory) {
105         return _symbol;
106     }
107     function decimals() public view returns (uint8) {
108         return _decimals;
109     }
110 }
111 
112 library SafeMath {
113     function add(uint a, uint b) internal pure returns (uint) {
114         uint c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119     function sub(uint a, uint b) internal pure returns (uint) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
123         require(b <= a, errorMessage);
124         uint c = a - b;
125 
126         return c;
127     }
128     function mul(uint a, uint b) internal pure returns (uint) {
129         if (a == 0) {
130             return 0;
131         }
132 
133         uint c = a * b;
134         require(c / a == b, "SafeMath: multiplication overflow");
135 
136         return c;
137     }
138     function div(uint a, uint b) internal pure returns (uint) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
142         // Solidity only automatically asserts when dividing by 0
143         require(b > 0, errorMessage);
144         uint c = a / b;
145 
146         return c;
147     }
148 }
149 
150 library Address {
151     function isContract(address account) internal view returns (bool) {
152         bytes32 codehash;
153         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
154         // solhint-disable-next-line no-inline-assembly
155         assembly { codehash := extcodehash(account) }
156         return (codehash != 0x0 && codehash != accountHash);
157     }
158 }
159 
160 library SafeERC20 {
161     using SafeMath for uint;
162     using Address for address;
163 
164     function safeTransfer(IERC20 token, address to, uint value) internal {
165         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
166     }
167 
168     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
169         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
170     }
171 
172     function safeApprove(IERC20 token, address spender, uint value) internal {
173         require((value == 0) || (token.allowance(address(this), spender) == 0),
174             "SafeERC20: approve from non-zero to non-zero allowance"
175         );
176         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
177     }
178     function callOptionalReturn(IERC20 token, bytes memory data) private {
179         require(address(token).isContract(), "SafeERC20: call to non-contract");
180 
181         // solhint-disable-next-line avoid-low-level-calls
182         (bool success, bytes memory returndata) = address(token).call(data);
183         require(success, "SafeERC20: low-level call failed");
184 
185         if (returndata.length > 0) { // Return data is optional
186             // solhint-disable-next-line max-line-length
187             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
188         }
189     }
190 }
191 
192 contract uvwFi is ERC20, ERC20Detailed {
193   using SafeERC20 for IERC20;
194   using Address for address;
195   using SafeMath for uint;
196   
197   address public governance;
198   mapping (address => bool) public minters;
199 
200   constructor () public ERC20Detailed("uvwFi.finance", "uvwFi", 18) {
201       governance = msg.sender;
202   }
203 
204   function mint(address account, uint amount) public {
205       require(minters[msg.sender], "!minter");
206       _mint(account, amount);
207   }
208   
209   function setGovernance(address _governance) public {
210       require(msg.sender == governance, "!governance");
211       governance = _governance;
212   }
213   
214   function addMinter(address _minter) public {
215       require(msg.sender == governance, "!governance");
216       minters[_minter] = true;
217   }
218   
219   function removeMinter(address _minter) public {
220       require(msg.sender == governance, "!governance");
221       minters[_minter] = false;
222   }
223 }