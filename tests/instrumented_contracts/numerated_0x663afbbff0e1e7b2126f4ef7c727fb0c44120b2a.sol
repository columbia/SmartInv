1 pragma solidity ^0.6.0;
2 
3 contract Context {
4     constructor () internal { }
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     function approve(address spender, uint256 amount) external returns (bool);
26 
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38 
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
55         // benefit is lost if 'b' is also tested.
56         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return mod(a, b, "SafeMath: modulo by zero");
82     }
83 
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b != 0, errorMessage);
86         return a % b;
87     }
88 }
89 
90 library Address {
91     function isContract(address account) internal view returns (bool) {
92         bytes32 codehash;
93         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
94         // solhint-disable-next-line no-inline-assembly
95         assembly { codehash := extcodehash(account) }
96         return (codehash != accountHash && codehash != 0x0);
97     }
98 
99     function sendValue(address payable recipient, uint256 amount) internal {
100         require(address(this).balance >= amount, "Address: insufficient balance");
101 
102         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
103         (bool success, ) = recipient.call{ value: amount }("");
104         require(success, "Address: unable to send value, recipient may have reverted");
105     }
106 }
107 
108 contract ERC20 is Context, IERC20 {
109     using SafeMath for uint256;
110     using Address for address;
111 
112     mapping (address => uint256) private _balances;
113 
114     mapping (address => mapping (address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118     string private _name;
119     string private _symbol;
120     uint8 private _decimals;
121 
122     constructor (string memory name, string memory symbol) public {
123         _name = name;
124         _symbol = symbol;
125         _decimals = 18;
126     }
127 
128     function name() public view returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public view returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view returns (uint8) {
137         return _decimals;
138     }
139 
140     function totalSupply() public view override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view override returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount) public virtual override returns (bool) {
158         _approve(_msgSender(), spender, amount);
159         return true;
160     }
161 
162     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
163         _transfer(sender, recipient, amount);
164         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
165         return true;
166     }
167 
168     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
169         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
170         return true;
171     }
172 
173     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
175         return true;
176     }
177 
178     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
179         require(sender != address(0), "ERC20: transfer from the zero address");
180         require(recipient != address(0), "ERC20: transfer to the zero address");
181 
182         _beforeTokenTransfer(sender, recipient, amount);
183 
184         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
185         _balances[recipient] = _balances[recipient].add(amount);
186         emit Transfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191 
192         _beforeTokenTransfer(address(0), account, amount);
193 
194         _totalSupply = _totalSupply.add(amount);
195         _balances[account] = _balances[account].add(amount);
196         emit Transfer(address(0), account, amount);
197     }
198 
199     function _burn(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: burn from the zero address");
201 
202         _beforeTokenTransfer(account, address(0), amount);
203 
204         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
205         _totalSupply = _totalSupply.sub(amount);
206         emit Transfer(account, address(0), amount);
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) internal virtual {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212 
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _setupDecimals(uint8 decimals_) internal {
218         _decimals = decimals_;
219     }
220 
221     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
222 }
223 
224 contract ITTX is ERC20 {
225     constructor() ERC20("ITTX", "ITTX") public {
226         _setupDecimals(6);
227         _mint(msg.sender, 180000000000000);
228     }
229 }