1 pragma solidity ^0.6.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this;
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23     
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34    
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
54         
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61 
62         return c;
63     }
64   
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 
86 contract CBK is Context, IERC20 {
87     using SafeMath for uint256;
88 
89     mapping (address => uint256) private _balances;
90 
91     mapping (address => mapping (address => uint256)) private _allowances;
92 
93     uint256 private _totalSupply;
94     string private _name;
95     string private _symbol;
96     uint8 private _decimals;
97 
98     address private _owner;
99     bool public mintingFinished = false;
100 
101     modifier onlyOwner() {
102         require(msg.sender == _owner, "Only the owner is allowed to access this function.");
103         _;
104     }
105 
106     constructor () public {
107         _name = "CBK";
108         _symbol = "CBK";
109         _decimals = 18;
110         _owner = msg.sender;
111         _totalSupply = 21000000 ether;
112         _balances[msg.sender] = _totalSupply;
113     }
114 
115     function name() public view returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public view returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public view returns (uint8) {
124         return _decimals;
125     }
126 
127     function totalSupply() public view override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address account) public view override returns (uint256) {
132         return _balances[account];
133     }
134 
135     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
136         _transfer(_msgSender(), recipient, amount);
137         return true;
138     }
139 
140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
141         return _allowances[owner][spender];
142     }
143 
144     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
145         _transfer(sender, recipient, amount);
146         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
147         return true;
148     }
149 
150     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
151         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
152         return true;
153     }
154 
155     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
156         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
157         return true;
158     }
159 
160     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
161         require(sender != address(0), "ERC20: transfer from the zero address");
162         require(recipient != address(0), "ERC20: transfer to the zero address");
163 
164         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
165         _balances[recipient] = _balances[recipient].add(amount);
166         emit Transfer(sender, recipient, amount);
167     }
168     function _burn(address account, uint256 amount) internal virtual {
169         require(account != address(0), "ERC20: burn from the zero address");
170 
171         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
172         _totalSupply = _totalSupply.sub(amount);
173         emit Transfer(account, address(0), amount);
174     }
175     
176     function burn(uint256 amount) public virtual {
177         _burn(msg.sender, amount);
178     }
179 
180     function burnFrom(address account, uint256 amount) public virtual {
181         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
182 
183         _approve(account, _msgSender(), decreasedAllowance);
184         _burn(account, amount);
185     }
186 
187     function mint(address account, uint256 amount) onlyOwner public {
188         require(account != address(0), "ERC20: mint to the zero address");
189         require(!mintingFinished);
190         _totalSupply = _totalSupply.add(amount);
191         _balances[account] = _balances[account].add(amount);
192         emit Transfer(address(0), account, amount);
193     }
194 
195     function finishMinting() onlyOwner public {
196         mintingFinished = true;
197     }
198 
199     function _approve(address owner, address spender, uint256 amount) internal virtual {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202 
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function approve(address spender, uint256 amount) public virtual override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferOwnership(address newOwner) onlyOwner public {
213         _owner = newOwner;
214     }
215 }