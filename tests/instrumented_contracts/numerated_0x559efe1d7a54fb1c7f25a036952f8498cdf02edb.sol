1 //with love nakamoyo55
2 
3 //SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.4;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint);
9     function balanceOf(address account) external view returns (uint);
10     function transfer(address recipient, uint amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint);
12     function approve(address spender, uint amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint) {
19         uint c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24     function sub(uint a, uint b) internal pure returns (uint) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
28         require(b <= a, errorMessage);
29         uint c = a - b;
30 
31         return c;
32     }
33     function mul(uint a, uint b) internal pure returns (uint) {
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint c = a * b;
39         require(c / a == b, "SafeMath: multiplication overflow");
40 
41         return c;
42     }
43     function div(uint a, uint b) internal pure returns (uint) {
44         return div(a, b, "SafeMath: division by zero");
45     }
46     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0, errorMessage);
49         uint c = a / b;
50 
51         return c;
52     }
53 }
54 
55 contract Context {
56     constructor () { }
57     // solhint-disable-previous-line no-empty-blocks
58 
59     function _msgSender() internal view returns (address) {
60         return msg.sender;
61     }
62 }
63 
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 }
93 
94 
95 contract ERC20 is Context, Ownable, IERC20 {
96     using SafeMath for uint;
97 
98     mapping (address => uint) internal _balances;
99 
100     mapping (address => mapping (address => uint)) internal _allowances;
101 
102     uint internal _totalSupply;
103     bool burnActive = false;
104    
105     function totalSupply() public view override returns (uint) {
106         return _totalSupply;
107     }
108     function balanceOf(address account) public view override returns (uint) {
109         return _balances[account];
110     }
111     function transfer(address recipient, uint amount) public override  returns (bool) {
112         _transfer(_msgSender(), recipient, amount);
113         return true;
114     }
115     function allowance(address towner, address spender) public view override returns (uint) {
116         return _allowances[towner][spender];
117     }
118     function approve(address spender, uint amount) public override returns (bool) {
119         _approve(_msgSender(), spender, amount);
120         return true;
121     }
122     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
123         _transfer(sender, recipient, amount);
124         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
125         return true;
126     }
127     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
128         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
129         return true;
130     }
131     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
132         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
133         return true;
134     }
135     function _transfer(address sender, address recipient, uint amount) internal{
136         require(sender != address(0), "ERC20: transfer from the zero address");
137         require(recipient != address(0), "ERC20: transfer to the zero address");
138        
139             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
140             _balances[recipient] = _balances[recipient].add(amount);
141             emit Transfer(sender, recipient, amount);
142        
143     }
144  
145     function _approve(address towner, address spender, uint amount) internal {
146         require(towner != address(0), "ERC20: approve from the zero address");
147         require(spender != address(0), "ERC20: approve to the zero address");
148 
149         _allowances[towner][spender] = amount;
150         emit Approval(towner, spender, amount);
151     }
152     
153   
154 }
155 
156 contract ERC20Detailed is ERC20 {
157     string private _name;
158     string private _symbol;
159     uint8 private _decimals;
160 
161     constructor (string memory tname, string memory tsymbol, uint8 tdecimals) {
162         _name = tname;
163         _symbol = tsymbol;
164         _decimals = tdecimals;
165         
166     }
167     function name() public view returns (string memory) {
168         return _name;
169     }
170     function symbol() public view returns (string memory) {
171         return _symbol;
172     }
173     function decimals() public view returns (uint8) {
174         return _decimals;
175     }
176 }
177 
178 
179 
180 library Address {
181     function isContract(address account) internal view returns (bool) {
182         bytes32 codehash;
183         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
184         // solhint-disable-next-line no-inline-assembly
185         assembly { codehash := extcodehash(account) }
186         return (codehash != 0x0 && codehash != accountHash);
187     }
188 }
189 
190 library SafeERC20 {
191     using SafeMath for uint;
192     using Address for address;
193 
194     function safeTransfer(IERC20 token, address to, uint value) internal {
195         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
196     }
197 
198     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
199         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
200     }
201 
202     function safeApprove(IERC20 token, address spender, uint value) internal {
203         require((value == 0) || (token.allowance(address(this), spender) == 0),
204             "SafeERC20: approve from non-zero to non-zero allowance"
205         );
206         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
207     }
208     function callOptionalReturn(IERC20 token, bytes memory data) private {
209         require(address(token).isContract(), "SafeERC20: call to non-contract");
210 
211         // solhint-disable-next-line avoid-low-level-calls
212         (bool success, bytes memory returndata) = address(token).call(data);
213         require(success, "SafeERC20: low-level call failed");
214 
215         if (returndata.length > 0) { // Return data is optional
216             // solhint-disable-next-line max-line-length
217             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
218         }
219     }
220 }
221 
222 contract DOGGToken is ERC20, ERC20Detailed {
223   using SafeERC20 for IERC20;
224   using Address for address;
225   using SafeMath for uint256;
226   
227   
228   address public _owner;
229   
230   constructor () ERC20Detailed("DOGG Token", "DOGG", 18) {
231       _owner = msg.sender;
232     _totalSupply =  4200000000 *(10**uint256(18));
233     
234 	_balances[_owner] = _totalSupply;
235   }
236 }