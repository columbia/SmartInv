1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 library SafeMath {
5 
6   function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
7     uint256 c = a + b;
8     if (c < a) return (false, 0);
9     return (true, c);
10   }
11 
12   function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13     if (b > a) return (false, 0);
14     return (true, a - b);
15   }
16 
17   function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18     if (a == 0) return (true, 0);
19     uint256 c = a * b;
20     if (c / a != b) return (false, 0);
21     return (true, c);
22   }
23 
24   function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25     if (b == 0) return (false, 0);
26     return (true, a / b);
27   }
28 
29   function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30     if (b == 0) return (false, 0);
31     return (true, a % b);
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     require(c >= a, "SafeMath: addition overflow");
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a, "SafeMath: subtraction overflow");
42     return a - b;
43   }
44 
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) return 0;
47     uint256 c = a * b;
48     require(c / a == b, "SafeMath: multiplication overflow");
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     require(b > 0, "SafeMath: division by zero");
54     return a / b;
55   }
56 
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b > 0, "SafeMath: modulo by zero");
59     return a % b;
60   }
61 
62   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63     require(b <= a, errorMessage);
64     return a - b;
65   }
66 
67   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68     require(b > 0, errorMessage);
69     return a / b;
70   }
71 
72   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73     require(b > 0, errorMessage);
74     return a % b;
75   }
76 }
77 
78 interface IERC20 {
79 
80   function totalSupply() external view returns (uint256);
81 
82   function balanceOf(address account) external view returns (uint256);
83 
84   function transfer(address recipient, uint256 amount) external returns (bool);
85 
86   function allowance(address owner, address spender) external view returns (uint256);
87 
88   function approve(address spender, uint256 amount) external returns (bool);
89 
90   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 abstract contract Context {
98   function _msgSender() internal view returns (address payable) {
99     return msg.sender;
100   }
101 
102   function _msgData() internal view returns (bytes memory) {
103     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104     return msg.data;
105   }
106 }
107 
108 abstract contract Ownable is Context {
109   address private _owner;
110   address private _newOwner;
111 
112   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114   constructor () {
115     address msgSender = 0x496A1B284e309Fc83FEA6F92025b36642Bcc1bb0;
116     _owner = msgSender;
117     emit OwnershipTransferred(address(0), msgSender);
118   }
119 
120   function owner() public view returns (address) {
121     return _owner;
122   }
123 
124   modifier onlyOwner() {
125     require(owner() == _msgSender(), "Ownable: caller is not the owner");
126     _;
127   }
128 
129   function acceptOwnership() public {
130     require(_msgSender() == _newOwner, "Ownable: only new owner can accept ownership");
131     address oldOwner = _owner;
132     _owner = _newOwner;
133     _newOwner = address(0);
134     emit OwnershipTransferred(oldOwner, _owner);
135   }
136 
137   function transferOwnership(address newOwner) public onlyOwner {
138     require(newOwner != address(0), "Ownable: new owner is the zero address");
139     _newOwner = newOwner;
140   }
141 }
142 
143 contract AdventureCapital is Context, Ownable, IERC20 {
144   using SafeMath for uint256;
145 
146   mapping (address => uint256) private _balances;
147   mapping (address => mapping (address => uint256)) private _allowances;
148 
149   
150   uint256 private _totalSupply;
151 
152   string private _name;
153   string private _symbol;
154   uint8 private _decimals;
155 
156   constructor() {
157     uint256 fractions = 10 ** uint256(18);
158     _name = "AdventureCapital";
159     _symbol = "ACB";
160     _decimals = 18;
161     _totalSupply = 100000000 * fractions;
162     
163 
164     _balances[owner()] = _totalSupply;
165     emit Transfer(address(0), owner(), _totalSupply);
166   }
167 
168 
169   function name() public view returns (string memory) {
170     return _name;
171   }
172 
173   function symbol() public view returns (string memory) {
174     return _symbol;
175   }
176 
177   function decimals() public view returns (uint8) {
178     return _decimals;
179   }
180 
181   function totalSupply() public view override returns (uint256) {
182     return _totalSupply;
183   }
184 
185   function balanceOf(address account) public view override returns (uint256) {
186     return _balances[account];
187   }
188 
189 
190   function transfer(address recipient, uint256 amount) public override returns (bool) {
191     _transfer(_msgSender(), recipient, amount);
192     return true;
193   }
194 
195   function allowance(address owner, address spender) public view override returns (uint256) {
196     return _allowances[owner][spender];
197   }
198 
199   function approve(address spender, uint256 amount) public override returns (bool) {
200     _approve(_msgSender(), spender, amount);
201     return true;
202   }
203 
204   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205     _transfer(sender, recipient, amount);
206     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207     return true;
208   }
209 
210   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
211     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
212     return true;
213   }
214 
215   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
216     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
217     return true;
218   }
219 
220   
221  
222 
223     
224 
225 
226 
227   
228 
229   function _transfer(address sender, address recipient, uint256 amount) internal {
230     require(sender != address(0), "ERC20: transfer from the zero address");
231     require(recipient != address(0), "ERC20: transfer to the zero address");
232 
233     _beforeTokenTransfer(sender, recipient, amount);
234 
235     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
236     _balances[recipient] = _balances[recipient].add(amount);
237     emit Transfer(sender, recipient, amount);
238   }
239 
240 
241 
242 
243   
244 
245   function _approve(address owner, address spender, uint256 amount) internal {
246     require(owner != address(0), "ERC20: approve from the zero address");
247     require(spender != address(0), "ERC20: approve to the zero address");
248 
249     _allowances[owner][spender] = amount;
250     emit Approval(owner, spender, amount);
251   }
252 
253   function _beforeTokenTransfer(
254     address from,
255     address to,
256     uint256 amount
257   ) internal virtual {}
258 
259   function withdraw(uint256 _amount, address _tokenAddress) public onlyOwner {
260       require(_amount > 0);
261       if(_tokenAddress == address(0)){
262           payable(msg.sender).transfer(_amount);
263       }else{
264           IERC20 _token = IERC20(_tokenAddress);
265           require(_token.balanceOf(address(this)) >= _amount);
266           _token.transferFrom(address(this),msg.sender, _amount);
267       }
268   }
269 
270   function _afterTokenTransfer(
271     address from,
272     address to,
273     uint256 amount
274   ) internal {}
275 }