1 pragma solidity ^0.6.12;
2 
3 contract Owned {
4     address public owner;
5     event OwnershipTransferred(address indexed _from, address indexed _to);
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner, 'SVS: you are not the owner');
13         _;
14     }
15 
16     function transferOwnership(address _newOwner) external onlyOwner {
17         address old = owner;
18         owner = _newOwner;
19         emit OwnershipTransferred(old, _newOwner);
20     }
21 }
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     function totalSupply() external view returns (uint256);
36     function balanceOf(address account) external view returns (uint256);
37     function transfer(address recipient, uint256 amount) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function approve(address spender, uint256 amount) external returns (bool);
40     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 library SafeMath {
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return div(a, b, "SafeMath: division by zero");
73     }
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         // Solidity only automatically asserts when dividing by 0
76         require(b > 0, errorMessage);
77         uint256 c = a / b;
78 
79         return c;
80     }
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         return mod(a, b, "SafeMath: modulo by zero");
83     }
84     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b != 0, errorMessage);
86         return a % b;
87     }
88 }
89 
90 contract ERC20 is Context, IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101     uint8 private _decimals;
102 
103     constructor (string memory name, string memory symbol) public {
104         _name = name;
105         _symbol = symbol;
106         _decimals = 18;
107     }
108 
109     function name() public view returns (string memory) {
110         return _name;
111     }
112 
113     function symbol() public view returns (string memory) {
114         return _symbol;
115     }
116 
117     function decimals() public view returns (uint8) {
118         return _decimals;
119     }
120 
121     function totalSupply() public view override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134     function allowance(address owner, address spender) public view virtual override returns (uint256) {
135         return _allowances[owner][spender];
136     }
137 
138     function approve(address spender, uint256 amount) public virtual override returns (bool) {
139         _approve(_msgSender(), spender, amount);
140         return true;
141     }
142 
143     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(sender, recipient, amount);
145         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
146         return true;
147     }
148 
149     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
150         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
151         return true;
152     }
153 
154     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
155         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
156         return true;
157     }
158 
159     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
160         require(sender != address(0), "ERC20: transfer from the zero address");
161         require(recipient != address(0), "ERC20: transfer to the zero address");
162 
163         _beforeTokenTransfer(sender, recipient, amount);
164 
165         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
166         _balances[recipient] = _balances[recipient].add(amount);
167         emit Transfer(sender, recipient, amount);
168     }
169 
170     function _mint(address account, uint256 amount) internal virtual {
171         require(account != address(0), "ERC20: mint to the zero address");
172 
173         _beforeTokenTransfer(address(0), account, amount);
174 
175         _totalSupply = _totalSupply.add(amount);
176         _balances[account] = _balances[account].add(amount);
177         emit Transfer(address(0), account, amount);
178     }
179 
180     function _burn(address account, uint256 amount) internal virtual {
181         require(account != address(0), "ERC20: burn from the zero address");
182 
183         _beforeTokenTransfer(account, address(0), amount);
184 
185         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
186         _totalSupply = _totalSupply.sub(amount);
187         emit Transfer(account, address(0), amount);
188     }
189 
190     function _approve(address owner, address spender, uint256 amount) internal virtual {
191         require(owner != address(0), "ERC20: approve from the zero address");
192         require(spender != address(0), "ERC20: approve to the zero address");
193 
194         _allowances[owner][spender] = amount;
195         emit Approval(owner, spender, amount);
196     }
197 
198     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
199 }
200 
201 contract GivingToServices is ERC20("GivingToServices", "SVS"), Owned {
202     function mint(address _to, uint256 _amount) external onlyOwner {
203         _mint(_to, _amount);
204     }
205     
206     // don't send eth to this contract
207     receive () payable external {
208         revert();
209     }
210     
211     // get token which stucked
212     function transferAnyERC20Token(address tokenAddress, uint tokens) external onlyOwner {
213         IERC20(tokenAddress).transfer(owner, tokens);
214     }
215 }