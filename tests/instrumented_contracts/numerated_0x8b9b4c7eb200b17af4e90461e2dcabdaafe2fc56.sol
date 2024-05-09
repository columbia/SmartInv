1 // ----------------------------------------------------------------------------
2 // worldPF Contract
3 // Name        : worldPF
4 // Symbol      : WDPF
5 // Decimals    : 18
6 // InitialSupply : 400,000,000 WDPF
7 // ----------------------------------------------------------------------------
8 
9 pragma solidity 0.5.16;
10 
11 interface IERC20 {
12 
13   function totalSupply() external view returns (uint256);
14 
15   function decimals() external view returns (uint8);
16 
17   function symbol() external view returns (string memory);
18 
19   function name() external view returns (string memory);
20 
21   function getOwner() external view returns (address);
22 
23   function balanceOf(address account) external view returns (uint256);
24 
25   function transfer(address recipient, uint256 amount) external returns (bool);
26 
27   function allowance(address _owner, address spender) external view returns (uint256);
28 
29   function approve(address spender, uint256 amount) external returns (bool);
30 
31   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract Context {
39 
40   constructor () internal { }
41 
42   function _msgSender() internal view returns (address payable) {
43     return msg.sender;
44   }
45 
46   function _msgData() internal view returns (bytes memory) {
47     this; 
48     return msg.data;
49   }
50 }
51 
52 library SafeMath {
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     require(c >= a, "SafeMath: addition overflow");
57 
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     return sub(a, b, "SafeMath: subtraction overflow");
63   }
64 
65   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66     require(b <= a, errorMessage);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73 
74     if (a == 0) {
75       return 0;
76     }
77 
78     uint256 c = a * b;
79     require(c / a == b, "SafeMath: multiplication overflow");
80 
81     return c;
82   }
83 
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     return div(a, b, "SafeMath: division by zero");
86   }
87 
88   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89 
90     require(b > 0, errorMessage);
91     uint256 c = a / b;
92 
93     return c;
94   }
95 
96   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97     return mod(a, b, "SafeMath: modulo by zero");
98   }
99 
100   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101     require(b != 0, errorMessage);
102     return a % b;
103   }
104 }
105 
106 contract Ownable is Context {
107   address private _owner;
108 
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111   constructor () internal {
112     address msgSender = _msgSender();
113     _owner = msgSender;
114     emit OwnershipTransferred(address(0), msgSender);
115   }
116 
117   function owner() public view returns (address) {
118     return _owner;
119   }
120 
121   modifier onlyOwner() {
122     require(_owner == _msgSender(), "Ownable: caller is not the owner");
123     _;
124   }
125 
126   function renounceOwnership() public onlyOwner {
127     emit OwnershipTransferred(_owner, address(0));
128     _owner = address(0);
129   }
130 
131   function transferOwnership(address newOwner) public onlyOwner {
132     _transferOwnership(newOwner);
133   }
134 
135   function _transferOwnership(address newOwner) internal {
136     require(newOwner != address(0), "Ownable: new owner is the zero address");
137     emit OwnershipTransferred(_owner, newOwner);
138     _owner = newOwner;
139   }
140 }
141 
142 contract worldPF is Context, IERC20, Ownable {
143   using SafeMath for uint256;
144 
145   mapping (address => uint256) private _balances;
146 
147   mapping (address => mapping (address => uint256)) private _allowances;
148 
149   uint256 private _totalSupply;
150   uint8 private _decimals;
151   string private _symbol;
152   string private _name;
153 
154   constructor() public {
155     _name = "worldPF";
156     _symbol = "WDPF";
157     _decimals = 18;
158     _totalSupply = 400000000000000000000000000;
159     _balances[msg.sender] = _totalSupply;
160 
161     emit Transfer(address(0), msg.sender, _totalSupply);
162   }
163 
164   function getOwner() external view returns (address) {
165     return owner();
166   }
167 
168   function decimals() external view returns (uint8) {
169     return _decimals;
170   }
171 
172   function symbol() external view returns (string memory) {
173     return _symbol;
174   }
175 
176   function name() external view returns (string memory) {
177     return _name;
178   }
179 
180   function totalSupply() external view returns (uint256) {
181     return _totalSupply;
182   }
183 
184   function balanceOf(address account) external view returns (uint256) {
185     return _balances[account];
186   }
187 
188   function transfer(address recipient, uint256 amount) external returns (bool) {
189     _transfer(_msgSender(), recipient, amount);
190     return true;
191   }
192 
193   function allowance(address owner, address spender) external view returns (uint256) {
194     return _allowances[owner][spender];
195   }
196 
197   function approve(address spender, uint256 amount) external returns (bool) {
198     _approve(_msgSender(), spender, amount);
199     return true;
200   }
201 
202   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
203     _transfer(sender, recipient, amount);
204     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "Transfer amount exceeds allowance"));
205     return true;
206   }
207 
208   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
209     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
210     return true;
211   }
212 
213   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
214     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "Decreased allowance below zero"));
215     return true;
216   }
217 
218   function _transfer(address sender, address recipient, uint256 amount) internal {
219     require(sender != address(0), "Transfer from the zero address");
220     require(recipient != address(0), "Transfer to the zero address");
221 
222     _balances[sender] = _balances[sender].sub(amount, "Transfer amount exceeds balance");
223     _balances[recipient] = _balances[recipient].add(amount);
224     emit Transfer(sender, recipient, amount);
225   }
226 
227   function _approve(address owner, address spender, uint256 amount) internal {
228     require(owner != address(0), "Approve from the zero address");
229     require(spender != address(0), "Approve to the zero address");
230 
231     _allowances[owner][spender] = amount;
232     emit Approval(owner, spender, amount);
233   }
234 
235   function burn(uint256 amount) public onlyOwner {
236     _totalSupply = _totalSupply.sub(amount);
237     emit Transfer(_msgSender(),address(0), amount);
238   }
239   
240 }