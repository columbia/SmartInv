1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-15
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.7.5;
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
19 
20 
21 contract Context {
22     constructor () public { }
23     // solhint-disable-previous-line no-empty-blocks
24 
25     function _msgSender() internal view returns (address payable) {
26         return msg.sender;
27     }
28 }
29 
30 contract ERC20 is Context, IERC20 {
31     using SafeMath for uint;
32 
33     mapping (address => uint) public _balances;
34 
35     mapping (address => mapping (address => uint)) public _allowances;
36     
37   
38   
39     uint public _totalSupply;
40  
41          
42     function totalSupply() public view override returns (uint) {
43         return _totalSupply;
44     }
45     function balanceOf(address account) public view override returns (uint) {
46         return _balances[account];
47     }
48     function transfer(address recipient, uint amount) public override  returns (bool) {
49         _transfer(_msgSender(), recipient, amount);
50         return true;
51     }
52     function allowance(address owner, address spender) public view override returns (uint) {
53         return _allowances[owner][spender];
54     }
55     function approve(address spender, uint amount) public override returns (bool) {
56         _approve(_msgSender(), spender, amount);
57         return true;
58     }
59     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
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
76         
77         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
78         _balances[recipient] = _balances[recipient].add(amount);
79         emit Transfer(sender, recipient,amount);
80         
81         
82       }
83    
84     function _approve(address owner, address spender, uint amount) internal {
85         require(owner != address(0), "ERC20: approve from the zero address");
86         require(spender != address(0), "ERC20: approve to the zero address");
87 
88         _allowances[owner][spender] = amount;
89         emit Approval(owner, spender, amount);
90     }
91 
92    
93 }
94 contract ERC20Detailed is ERC20 {
95     string private _name;
96     string private _symbol;
97     uint8 private _decimals;
98 
99     constructor (string memory name, string memory symbol, uint8 decimals) public{
100         _name = name;
101         _symbol = symbol;
102         _decimals = decimals;
103         
104     }
105     function name() public view returns (string memory) {
106         return _name;
107     }
108     function symbol() public view returns (string memory) {
109         return _symbol;
110     }
111     function decimals() public view returns (uint8) {
112         return _decimals;
113     }
114 }
115 
116 library SafeMath {
117     function add(uint a, uint b) internal pure returns (uint) {
118         uint c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123     function sub(uint a, uint b) internal pure returns (uint) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
127         require(b <= a, errorMessage);
128         uint c = a - b;
129 
130         return c;
131     }
132     function mul(uint a, uint b) internal pure returns (uint) {
133         if (a == 0) {
134             return 0;
135         }
136 
137         uint c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139 
140         return c;
141     }
142     function div(uint a, uint b) internal pure returns (uint) {
143         return div(a, b, "SafeMath: division by zero");
144     }
145     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
146         // Solidity only automatically asserts when dividing by 0
147         require(b > 0, errorMessage);
148         uint c = a / b;
149 
150         return c;
151     }
152 }
153 
154 library Address {
155     function isContract(address account) internal view returns (bool) {
156         bytes32 codehash;
157         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
158         // solhint-disable-next-line no-inline-assembly
159         assembly { codehash := extcodehash(account) }
160         return (codehash != 0x0 && codehash != accountHash);
161     }
162 }
163 
164 library SafeERC20 {
165     using SafeMath for uint;
166     using Address for address;
167 
168     function safeTransfer(IERC20 token, address to, uint value) internal {
169         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
170     }
171 
172     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
173         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
174     }
175 
176     function safeApprove(IERC20 token, address spender, uint value) internal {
177         require((value == 0) || (token.allowance(address(this), spender) == 0),
178             "SafeERC20: approve from non-zero to non-zero allowance"
179         );
180         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
181     }
182     function callOptionalReturn(IERC20 token, bytes memory data) private {
183         require(address(token).isContract(), "SafeERC20: call to non-contract");
184 
185         // solhint-disable-next-line avoid-low-level-calls
186         (bool success, bytes memory returndata) = address(token).call(data);
187         require(success, "SafeERC20: low-level call failed");
188 
189         if (returndata.length > 0) { // Return data is optional
190             // solhint-disable-next-line max-line-length
191             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
192         }
193     }
194 }
195 
196 contract CMS is ERC20, ERC20Detailed {
197   using SafeERC20 for IERC20;
198   using Address for address;
199   using SafeMath for uint;
200   
201   
202   address public ownership;
203 
204   constructor () ERC20Detailed("CryptoMoonShots", "CMS", 18) public{
205       ownership = msg.sender;
206     _totalSupply = 1250000 *(10**uint256(18));
207 	_balances[ownership] = _totalSupply;
208   }
209 
210 
211 
212 }