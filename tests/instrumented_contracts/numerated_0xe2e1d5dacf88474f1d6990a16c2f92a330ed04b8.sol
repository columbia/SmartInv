1 pragma solidity ^0.5.16;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17 
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24 
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38 
39 
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43 
44 
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51         return c;
52     }
53 
54 
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         return mod(a, b, "SafeMath: modulo by zero");
57     }
58 
59 
60     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b != 0, errorMessage);
62         return a % b;
63     }
64 }
65 
66 
67 interface IERC20 {
68 
69     function totalSupply() external view returns (uint256);
70 
71 
72     function balanceOf(address account) external view returns (uint256);
73 
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77 
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83 
84     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89 
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 contract Context {
95 
96     constructor () internal { }
97 
98 
99     function _msgSender() internal view returns (address payable) {
100         return msg.sender;
101     }
102 
103     function _msgData() internal view returns (bytes memory) {
104         this;
105         return msg.data;
106     }
107 }
108 
109 
110 contract ERC20 is Context, IERC20 {
111     using SafeMath for uint256;
112 
113     mapping (address => uint256) private _balances;
114 
115     mapping (address => mapping (address => uint256)) private _allowances;
116 
117     uint256 private _totalSupply;
118 
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address account) public view returns (uint256) {
124         return _balances[account];
125     }
126 
127     function transfer(address recipient, uint256 amount) public returns (bool) {
128         _transfer(_msgSender(), recipient, amount);
129         return true;
130     }
131 
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowances[owner][spender];
134     }
135 
136 
137     function approve(address spender, uint256 amount) public returns (bool) {
138         _approve(_msgSender(), spender, amount);
139         return true;
140     }
141 
142     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
143         _transfer(sender, recipient, amount);
144         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
145         return true;
146     }
147 
148     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
149         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
150         return true;
151     }
152 
153     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
155         return true;
156     }
157 
158     function burn(uint256 amount) public returns (bool) {
159         _burn(_msgSender(), amount);
160         return true;
161     }
162 
163     function burnFrom(address account, uint256 amount) public returns (bool) {
164         _burnFrom(account, amount);
165         return true;
166     }
167 
168 
169     function _transfer(address sender, address recipient, uint256 amount) internal {
170         require(sender != address(0), "ERC20: transfer from the zero address");
171         require(recipient != address(0), "ERC20: transfer to the zero address");
172 
173         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
174         _balances[recipient] = _balances[recipient].add(amount);
175         emit Transfer(sender, recipient, amount);
176     }
177 
178 
179     function _mint(address account, uint256 amount) internal {
180         require(account != address(0), "ERC20: mint to the zero address");
181 
182         _totalSupply = _totalSupply.add(amount);
183         _balances[account] = _balances[account].add(amount);
184         emit Transfer(address(0), account, amount);
185     }
186 
187 
188     function _burn(address account, uint256 amount) internal {
189         require(account != address(0), "ERC20: burn from the zero address");
190 
191         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
192         _totalSupply = _totalSupply.sub(amount);
193         emit Transfer(account, address(0), amount);
194     }
195 
196     function _approve(address owner, address spender, uint256 amount) internal {
197         require(owner != address(0), "ERC20: approve from the zero address");
198         require(spender != address(0), "ERC20: approve to the zero address");
199 
200         _allowances[owner][spender] = amount;
201         emit Approval(owner, spender, amount);
202     }
203 
204 
205     function _burnFrom(address account, uint256 amount) internal {
206         _burn(account, amount);
207         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
208     }
209 }
210 
211 contract HHLContract is ERC20 {
212 
213     string public name = "HuangHeLou";
214     string public symbol = "HHL";
215     uint public decimals = 6;
216     uint public INITIAL_SUPPLY = 500000 * (10 **decimals);
217 
218     constructor() public {
219         _mint(msg.sender, INITIAL_SUPPLY);
220     }
221 }