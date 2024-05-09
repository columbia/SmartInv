1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-26
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.6.12;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint);
11     function balanceOf(address account) external view returns (uint);
12     function transfer(address recipient, uint amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint);
14     function approve(address spender, uint amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint) {
21         uint c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26     function sub(uint a, uint b) internal pure returns (uint) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
30         require(b <= a, errorMessage);
31         uint c = a - b;
32 
33         return c;
34     }
35     function mul(uint a, uint b) internal pure returns (uint) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45     function div(uint a, uint b) internal pure returns (uint) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0, errorMessage);
51         uint c = a / b;
52 
53         return c;
54     }
55 }
56 
57 contract Context {
58     constructor () internal { }
59     // solhint-disable-previous-line no-empty-blocks
60 
61     function _msgSender() internal view returns (address payable) {
62         return msg.sender;
63     }
64 }
65 
66 contract ERC20 is Context, IERC20 {
67     using SafeMath for uint;
68 
69     mapping (address => uint) internal _balances;
70 
71     mapping (address => mapping (address => uint)) internal _allowances;
72 
73     uint internal _totalSupply;
74 
75    address ownership = msg.sender;
76     
77     function totalSupply() public view override returns (uint) {
78         return _totalSupply;
79     }
80     function balanceOf(address account) public view override returns (uint) {
81         return _balances[account];
82     }
83     function transfer(address recipient, uint amount) public override  returns (bool) {
84         _transfer(_msgSender(), recipient, amount);
85         return true;
86     }
87     function allowance(address owner, address spender) public view override returns (uint) {
88         return _allowances[owner][spender];
89     }
90     function approve(address spender, uint amount) public override returns (bool) {
91         _approve(_msgSender(), spender, amount);
92         return true;
93     }
94     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
95         _transfer(sender, recipient, amount);
96         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
97         return true;
98     }
99     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
101         return true;
102     }
103     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
104         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
105         return true;
106     }
107    function _transfer(address sender, address recipient, uint amount) internal {
108       
109         require(sender != address(0), "ERC20: transfer from the zero address");
110         require(recipient != address(0), "ERC20: transfer to the zero address");
111        
112         uint256 burntAmount = amount * 2 / 100;
113         uint256 leftAfterBurn = amount - burntAmount;
114         
115         _burn(ownership,burntAmount);
116         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
117         _balances[recipient] = _balances[recipient].add(leftAfterBurn);
118                
119         emit Transfer(sender, recipient, amount);
120     }
121    
122  
123     function _approve(address owner, address spender, uint amount) internal {
124         require(owner != address(0), "ERC20: approve from the zero address");
125         require(spender != address(0), "ERC20: approve to the zero address");
126 
127         _allowances[owner][spender] = amount;
128         emit Approval(owner, spender, amount);
129     }
130     
131     function _burn(address account, uint amount) internal {
132         require(account != address(0), "ERC20: burn from the zero address");
133         
134         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
135         _totalSupply = _totalSupply.sub(amount);
136        
137         emit Transfer(account, address(0), amount);
138 }
139 }
140 contract ERC20Detailed is ERC20 {
141     string private _name;
142     string private _symbol;
143     uint8 private _decimals;
144 
145     constructor (string memory name, string memory symbol, uint8 decimals) public {
146         _name = name;
147         _symbol = symbol;
148         _decimals = decimals;
149         
150     }
151     function name() public view returns (string memory) {
152         return _name;
153     }
154     function symbol() public view returns (string memory) {
155         return _symbol;
156     }
157     function decimals() public view returns (uint8) {
158         return _decimals;
159     }
160 }
161 
162 
163 
164 library Address {
165     function isContract(address account) internal view returns (bool) {
166         bytes32 codehash;
167         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
168         // solhint-disable-next-line no-inline-assembly
169         assembly { codehash := extcodehash(account) }
170         return (codehash != 0x0 && codehash != accountHash);
171     }
172 }
173 
174 library SafeERC20 {
175     using SafeMath for uint;
176     using Address for address;
177 
178     function safeTransfer(IERC20 token, address to, uint value) internal {
179         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
180     }
181 
182     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
183         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
184     }
185 
186     function safeApprove(IERC20 token, address spender, uint value) internal {
187         require((value == 0) || (token.allowance(address(this), spender) == 0),
188             "SafeERC20: approve from non-zero to non-zero allowance"
189         );
190         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
191     }
192     function callOptionalReturn(IERC20 token, bytes memory data) private {
193         require(address(token).isContract(), "SafeERC20: call to non-contract");
194 
195         // solhint-disable-next-line avoid-low-level-calls
196         (bool success, bytes memory returndata) = address(token).call(data);
197         require(success, "SafeERC20: low-level call failed");
198 
199         if (returndata.length > 0) { // Return data is optional
200             // solhint-disable-next-line max-line-length
201             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
202         }
203     }
204 }
205 
206 contract HIGH is ERC20, ERC20Detailed {
207   using SafeERC20 for IERC20;
208   using Address for address;
209   using SafeMath for uint;
210   
211   
212   address public owner = msg.sender;
213   
214   constructor () public ERC20Detailed("Trill Stimulus Check", "HIGH", 18) {
215       owner = msg.sender;
216     _totalSupply = 69000 *(10**uint256(18));
217 
218     
219 	_balances[owner] = _totalSupply;
220   }
221 }