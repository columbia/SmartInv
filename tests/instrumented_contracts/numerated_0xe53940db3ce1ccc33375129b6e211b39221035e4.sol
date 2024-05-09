1 pragma solidity ^0.5.17;
2 
3 /**
4  ********************************************************************
5  *  
6  ********************************************************************
7  * 
8 
9 *                                                
10  ********************************************************************
11  */
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint);
15     function balanceOf(address account) external view returns (uint);
16     function transfer(address recipient, uint amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint);
18     function approve(address spender, uint amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint value);
21     event Approval(address indexed owner, address indexed spender, uint value);
22 }
23 
24 contract Context {
25     constructor () internal { }
26     // solhint-disable-previous-line no-empty-blocks
27 
28     function _msgSender() internal view returns (address payable) {
29         return msg.sender;
30     }
31 }
32 
33 contract ERC20 is Context, IERC20 {
34     using SafeMath for uint;
35 
36     mapping (address => uint) private _balances;
37 
38     mapping (address => mapping (address => uint)) private _allowances;
39 
40     uint private _totalSupply;
41     function totalSupply() public view returns (uint) {
42         return _totalSupply;
43     }
44     function balanceOf(address account) public view returns (uint) {
45         return _balances[account];
46     }
47     function transfer(address recipient, uint amount) public returns (bool) {
48         _transfer(_msgSender(), recipient, amount);
49         return true;
50     }
51     function allowance(address owner, address spender) public view returns (uint) {
52         return _allowances[owner][spender];
53     }
54     function approve(address spender, uint amount) public returns (bool) {
55         _approve(_msgSender(), spender, amount);
56         return true;
57     }
58     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
59         _transfer(sender, recipient, amount);
60         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
61         return true;
62     }
63     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
64         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
65         return true;
66     }
67     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
68         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
69         return true;
70     }
71     function _transfer(address sender, address recipient, uint amount) internal {
72         require(sender != address(0), "ERC20: transfer from the zero address");
73         require(recipient != address(0), "ERC20: transfer to the zero address");
74 
75         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
76         _balances[recipient] = _balances[recipient].add(amount);
77         emit Transfer(sender, recipient, amount);
78     }
79     function _mint(address account, uint amount) internal {
80         require(account != address(0), "ERC20: mint to the zero address");
81 
82         _totalSupply = _totalSupply.add(amount);
83         _balances[account] = _balances[account].add(amount);
84         emit Transfer(address(0), account, amount);
85     }
86     function _burn(address account, uint amount) internal {
87         require(account != address(0), "ERC20: burn from the zero address");
88 
89         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
90         _totalSupply = _totalSupply.sub(amount);
91         emit Transfer(account, address(0), amount);
92     }
93     function _approve(address owner, address spender, uint amount) internal {
94         require(owner != address(0), "ERC20: approve from the zero address");
95         require(spender != address(0), "ERC20: approve to the zero address");
96 
97         _allowances[owner][spender] = amount;
98         emit Approval(owner, spender, amount);
99     }
100 }
101 
102 contract ERC20Detailed is IERC20 {
103     string private _name;
104     string private _symbol;
105     uint8 private _decimals;
106 
107     constructor (string memory name, string memory symbol, uint8 decimals) public {
108         _name = name;
109         _symbol = symbol;
110         _decimals = decimals;
111     }
112     function name() public view returns (string memory) {
113         return _name;
114     }
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118     function decimals() public view returns (uint8) {
119         return _decimals;
120     }
121 }
122 
123 library SafeMath {
124     function add(uint a, uint b) internal pure returns (uint) {
125         uint c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130     function sub(uint a, uint b) internal pure returns (uint) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
134         require(b <= a, errorMessage);
135         uint c = a - b;
136 
137         return c;
138     }
139     function mul(uint a, uint b) internal pure returns (uint) {
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149     function div(uint a, uint b) internal pure returns (uint) {
150         return div(a, b, "SafeMath: division by zero");
151     }
152     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
153         // Solidity only automatically asserts when dividing by 0
154         require(b > 0, errorMessage);
155         uint c = a / b;
156 
157         return c;
158     }
159 }
160 
161 library Address {
162     function isContract(address account) internal view returns (bool) {
163         bytes32 codehash;
164         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
165         // solhint-disable-next-line no-inline-assembly
166         assembly { codehash := extcodehash(account) }
167         return (codehash != 0x0 && codehash != accountHash);
168     }
169 }
170 
171 library SafeERC20 {
172     using SafeMath for uint;
173     using Address for address;
174 
175     function safeTransfer(IERC20 token, address to, uint value) internal {
176         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
177     }
178 
179     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
180         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
181     }
182 
183     function safeApprove(IERC20 token, address spender, uint value) internal {
184         require((value == 0) || (token.allowance(address(this), spender) == 0),
185             "SafeERC20: approve from non-zero to non-zero allowance"
186         );
187         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
188     }
189     function callOptionalReturn(IERC20 token, bytes memory data) private {
190         require(address(token).isContract(), "SafeERC20: call to non-contract");
191 
192         // solhint-disable-next-line avoid-low-level-calls
193         (bool success, bytes memory returndata) = address(token).call(data);
194         require(success, "SafeERC20: low-level call failed");
195 
196         if (returndata.length > 0) { // Return data is optional
197             // solhint-disable-next-line max-line-length
198             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
199         }
200     }
201 }
202 
203 contract Xearn is ERC20, ERC20Detailed {
204   using SafeERC20 for IERC20;
205   using Address for address;
206   using SafeMath for uint;
207 
208 
209   address public governance;
210   mapping (address => bool) public minters;
211 
212   constructor () public ERC20Detailed("xEarn Capital", "XRN", 18) {
213       governance = tx.origin;
214   }
215 
216   function mint(address account, uint256 amount) public {
217       require(minters[msg.sender], "!minter");
218       _mint(account, amount);
219   }
220 
221    function burn(address account, uint256 amount) public {
222       require(minters[msg.sender], "!minter");
223       _burn(account, amount);
224   }
225 
226   function setGovernance(address _governance) public {
227       require(msg.sender == governance, "!governance");
228       governance = _governance;
229   }
230 
231   function addMinter(address _minter) public {
232       require(msg.sender == governance, "!governance");
233       minters[_minter] = true;
234   }
235 
236   function removeMinter(address _minter) public {
237       require(msg.sender == governance, "!governance");
238       minters[_minter] = false;
239   }
240 }