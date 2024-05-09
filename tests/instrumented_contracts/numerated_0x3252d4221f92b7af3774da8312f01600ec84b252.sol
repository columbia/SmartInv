1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.5.16;
4 
5 // ----------------------------------------------------------------------------
6 // 'XOLO' Token contract
7 //
8 // Name        : Xoloitzcuintli
9 // Symbol      : XOLO
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 interface IERC20 {
15 
16   function totalSupply() external view returns (uint256);
17 
18   function decimals() external view returns (uint8);
19 
20   function symbol() external view returns (string memory);
21 
22   function name() external view returns (string memory);
23 
24   function getOwner() external view returns (address);
25 
26   function balanceOf(address account) external view returns (uint256);
27 
28   function transfer(address recipient, uint256 amount) external returns (bool);
29 
30   function allowance(address _owner, address spender) external view returns (uint256);
31 
32   function approve(address spender, uint256 amount) external returns (bool);
33 
34   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35 
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract Context {
42   // Empty internal constructor, to prevent people from mistakenly deploying
43   // an instance of this contract, which should be used via inheritance.
44   constructor () internal { }
45 
46   function _msgSender() internal view returns (address payable) {
47     return msg.sender;
48   }
49 
50   function _msgData() internal view returns (bytes memory) {
51     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
52     return msg.data;
53   }
54 }
55 
56 library SafeMath {
57  
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a, "SafeMath: addition overflow");
61 
62     return c;
63   }
64 
65  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     return sub(a, b, "SafeMath: subtraction overflow");
67   }
68 
69  
70   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71     require(b <= a, errorMessage);
72     uint256 c = a - b;
73 
74     return c;
75   }
76 
77 
78   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     if (a == 0) {
82       return 0;
83     }
84 
85     uint256 c = a * b;
86     require(c / a == b, "SafeMath: multiplication overflow");
87 
88     return c;
89   }
90 
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     return div(a, b, "SafeMath: division by zero");
93   }
94 
95   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96     // Solidity only automatically asserts when dividing by 0
97     require(b > 0, errorMessage);
98     uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101     return c;
102   }
103 
104   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105     return mod(a, b, "SafeMath: modulo by zero");
106   }
107 
108   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109     require(b != 0, errorMessage);
110     return a % b;
111   }
112 }
113 
114 contract Ownable is Context {
115   address private _owner;
116 
117   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119   constructor () internal {
120     address msgSender = _msgSender();
121     _owner = msgSender;
122     emit OwnershipTransferred(address(0), msgSender);
123   }
124 
125   function owner() public view returns (address) {
126     return _owner;
127   }
128 
129   modifier onlyOwner() {
130     require(_owner == _msgSender(), "Ownable: caller is not the owner");
131     _;
132   }
133 
134   function renounceOwnership() public onlyOwner {
135     emit OwnershipTransferred(_owner, address(0));
136     _owner = address(0);
137   }
138 
139   function transferOwnership(address newOwner) public onlyOwner {
140     _transferOwnership(newOwner);
141   }
142 
143   function _transferOwnership(address newOwner) internal {
144     require(newOwner != address(0), "Ownable: new owner is the zero address");
145     emit OwnershipTransferred(_owner, newOwner);
146     _owner = newOwner;
147   }
148 }
149 
150 contract XOLOToken is Context, IERC20, Ownable {
151   using SafeMath for uint256;
152 
153   mapping (address => uint256) private _balances;
154 
155   mapping (address => mapping (address => uint256)) private _allowances;
156 
157   uint256 private _totalSupply;
158   uint8 public _decimals;
159   string public _symbol;
160   string public _name;
161 
162   constructor() public {
163     _name = "Xoloitzcuintli";
164     _symbol = "XOLO";
165     _decimals = 18;
166     _totalSupply = 80000000000 * 10**18;
167     _balances[msg.sender] = _totalSupply;
168 
169     emit Transfer(address(0), msg.sender, _totalSupply);
170   }
171 
172   function getOwner() external view returns (address) {
173     return owner();
174   }
175 
176   function decimals() external view returns (uint8) {
177     return _decimals;
178   }
179 
180   function symbol() external view returns (string memory) {
181     return _symbol;
182   }
183 
184   function name() external view returns (string memory) {
185     return _name;
186   }
187 
188   function totalSupply() external view returns (uint256) {
189     return _totalSupply;
190   }
191 
192   function balanceOf(address account) external view returns (uint256) {
193     return _balances[account];
194   }
195 
196   function transfer(address recipient, uint256 amount) external returns (bool) {
197     _transfer(_msgSender(), recipient, amount);
198     return true;
199   } 
200 
201   function allowance(address owner, address spender) external view returns (uint256) {
202     return _allowances[owner][spender];
203   }
204 
205   function approve(address spender, uint256 amount) external returns (bool) {
206     _approve(_msgSender(), spender, amount);
207     return true;
208   }
209 
210   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
211     _transfer(sender, recipient, amount);
212     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213     return true;
214   }
215 
216   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
217     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
218     return true;
219   }
220 
221   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
222     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
223     return true;
224   }
225 
226   function burn(uint256 amount) public returns (bool) {
227     _burn(_msgSender(), amount);
228     return true;
229   }
230 
231   function _transfer(address sender, address recipient, uint256 amount) internal {
232     require(sender != address(0), "ERC20: transfer from the zero address");
233     require(recipient != address(0), "ERC20: transfer to the zero address");
234 
235     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
236     _balances[recipient] = _balances[recipient].add(amount);
237     emit Transfer(sender, recipient, amount);
238   }
239 
240   function _burn(address account, uint256 amount) internal {
241     require(account != address(0), "ERC20: burn from the zero address");
242 
243     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
244     _totalSupply = _totalSupply.sub(amount);
245     emit Transfer(account, address(0), amount);
246   }
247 
248   function _approve(address owner, address spender, uint256 amount) internal {
249     require(owner != address(0), "ERC20: approve from the zero address");
250     require(spender != address(0), "ERC20: approve to the zero address");
251 
252     _allowances[owner][spender] = amount;
253     emit Approval(owner, spender, amount);
254   }
255 
256   function _burnFrom(address account, uint256 amount) internal {
257     _burn(account, amount);
258     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
259   }
260 }