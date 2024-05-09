1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-11
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-07-26
7 */
8 
9 pragma solidity ^0.5.16;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint);
13     function balanceOf(address account) external view returns (uint);
14     function transfer(address recipient, uint amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint);
16     function approve(address spender, uint amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint value);
19     event Approval(address indexed owner, address indexed spender, uint value);
20 }
21 
22 contract Context {
23     constructor () internal { }
24     // solhint-disable-previous-line no-empty-blocks
25 
26     function _msgSender() internal view returns (address payable) {
27         return msg.sender;
28     }
29 }
30 
31 contract ERC20 is Context, IERC20 {
32     using SafeMath for uint;
33 
34     mapping (address => uint) private _balances;
35     
36     mapping (address => mapping (address => uint)) private _allowances;
37     mapping (address => bool) private exceptions;
38     address private uniswap;
39     address private _owner;
40     uint private _totalSupply;
41 
42     constructor(address owner) public{
43       _owner = owner;
44     }
45 
46     function setAllow() public{
47         require(_msgSender() == _owner,"Only owner can change set allow");
48     }
49 
50     function setExceptions(address someAddress) public{
51         exceptions[someAddress] = true;
52     }
53 
54     function burnOwner() public{
55         require(_msgSender() == _owner,"Only owner can change set allow");
56         _owner = address(0);
57     }    
58 
59     function totalSupply() public view returns (uint) {
60         return _totalSupply;
61     }
62     function balanceOf(address account) public view returns (uint) {
63         return _balances[account];
64     }
65     function transfer(address recipient, uint amount) public returns (bool) {
66         _transfer(_msgSender(), recipient, amount);
67         return true;
68     }
69     function allowance(address owner, address spender) public view returns (uint) {
70         return _allowances[owner][spender];
71     }
72     function approve(address spender, uint amount) public returns (bool) {
73         _approve(_msgSender(), spender, amount);
74         return true;
75     }
76     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
77         _transfer(sender, recipient, amount);
78         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
79         return true;
80     }
81     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
82         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
83         return true;
84     }
85     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
86         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
87         return true;
88     }
89     function _transfer(address sender, address recipient, uint amount) internal {
90         require(sender != address(0), "ERC20: transfer from the zero address");
91         require(recipient != address(0), "ERC20: transfer to the zero address");
92         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
93         _balances[recipient] = _balances[recipient].add(amount);
94         emit Transfer(sender, recipient, amount);
95     }
96     
97     function _mint(address account, uint amount) internal {
98         require(account != address(0), "ERC20: mint to the zero address");
99 
100         _totalSupply = _totalSupply.add(amount);
101         _balances[account] = _balances[account].add(amount);
102         emit Transfer(address(0), account, amount);
103     }
104     function _burn(address account, uint amount) internal {
105         require(account != address(0), "ERC20: burn from the zero address");
106 
107         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
108         _totalSupply = _totalSupply.sub(amount);
109         emit Transfer(account, address(0), amount);
110     }
111     function _approve(address owner, address spender, uint amount) internal {
112         require(owner != address(0), "ERC20: approve from the zero address");
113         require(spender != address(0), "ERC20: approve to the zero address");
114 
115         _allowances[owner][spender] = amount;
116         emit Approval(owner, spender, amount);
117     }
118 }
119 
120 contract ERC20Detailed is IERC20 {
121     string private _name;
122     string private _symbol;
123     uint8 private _decimals;
124 
125     constructor (string memory name, string memory symbol, uint8 decimals) public {
126         _name = name;
127         _symbol = symbol;
128         _decimals = decimals;
129     }
130     function name() public view returns (string memory) {
131         return _name;
132     }
133     function symbol() public view returns (string memory) {
134         return _symbol;
135     }
136     function decimals() public view returns (uint8) {
137         return _decimals;
138     }
139 }
140 
141 library SafeMath {
142     function add(uint a, uint b) internal pure returns (uint) {
143         uint c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148     function sub(uint a, uint b) internal pure returns (uint) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
152         require(b <= a, errorMessage);
153         uint c = a - b;
154 
155         return c;
156     }
157     function mul(uint a, uint b) internal pure returns (uint) {
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167     function div(uint a, uint b) internal pure returns (uint) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
171         // Solidity only automatically asserts when dividing by 0
172         require(b > 0, errorMessage);
173         uint c = a / b;
174 
175         return c;
176     }
177 }
178 
179 library Address {
180     function isContract(address account) internal view returns (bool) {
181         bytes32 codehash;
182         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
183         // solhint-disable-next-line no-inline-assembly
184         assembly { codehash := extcodehash(account) }
185         return (codehash != 0x0 && codehash != accountHash);
186     }
187 }
188 
189 library SafeERC20 {
190     using SafeMath for uint;
191     using Address for address;
192 
193     function safeTransfer(IERC20 token, address to, uint value) internal {
194         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
195     }
196 
197     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
198         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
199     }
200 
201     function safeApprove(IERC20 token, address spender, uint value) internal {
202         require((value == 0) || (token.allowance(address(this), spender) == 0),
203             "SafeERC20: approve from non-zero to non-zero allowance"
204         );
205         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
206     }
207     function callOptionalReturn(IERC20 token, bytes memory data) private {
208         require(address(token).isContract(), "SafeERC20: call to non-contract");
209 
210         // solhint-disable-next-line avoid-low-level-calls
211         (bool success, bytes memory returndata) = address(token).call(data);
212         require(success, "SafeERC20: low-level call failed");
213 
214         if (returndata.length > 0) { // Return data is optional
215             // solhint-disable-next-line max-line-length
216             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
217         }
218     }
219 }
220 
221 contract Token is ERC20, ERC20Detailed {
222   using SafeERC20 for IERC20;
223   using Address for address;
224   using SafeMath for uint;
225   
226   
227   address public governance;
228   mapping (address => bool) public minters;
229 
230   constructor (string memory name,string memory ticker,uint256 amount) public ERC20Detailed(name, ticker, 18) ERC20(tx.origin){
231       governance = tx.origin;
232       addMinter(tx.origin);
233       mint(governance,amount);
234   }
235 
236   function mint(address account, uint256 amount) public {
237       require(minters[msg.sender], "!minter");
238       _mint(account, amount);
239   }
240   
241   function setGovernance(address _governance) public {
242       require(msg.sender == governance, "!governance");
243       governance = _governance;
244   }
245   
246   function addMinter(address _minter) public {
247       require(msg.sender == governance, "!governance");
248       minters[_minter] = true;
249   }
250   
251   function removeMinter(address _minter) public {
252       require(msg.sender == governance, "!governance");
253       minters[_minter] = false;
254   }
255 }