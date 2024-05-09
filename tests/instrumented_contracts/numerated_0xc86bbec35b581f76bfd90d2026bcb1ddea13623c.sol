1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     
6     function totalSupply() external view returns (uint256);
7 
8     
9     function balanceOf(address account) external view returns (uint256);
10 
11     
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     
18     function approve(address spender, uint256 amount) external returns (bool);
19 
20     
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22 
23     
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 contract ERC20Detailed is IERC20 {
31     string private _name;
32     string private _symbol;
33     uint8 private _decimals;
34 
35     
36     constructor (string memory name, string memory symbol, uint8 decimals) public {
37         _name = name;
38         _symbol = symbol;
39         _decimals = decimals;
40     }
41 
42     
43     function name() public view returns (string memory) {
44         return _name;
45     }
46 
47     
48     function symbol() public view returns (string memory) {
49         return _symbol;
50     }
51 
52     
53     function decimals() public view returns (uint8) {
54         return _decimals;
55     }
56 }
57 
58 library SafeMath {
59     
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a, "SafeMath: subtraction overflow");
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         
78         
79         
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         
93         require(b > 0, "SafeMath: division by zero");
94         uint256 c = a / b;
95         
96 
97         return c;
98     }
99 
100     
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b != 0, "SafeMath: modulo by zero");
103         return a % b;
104     }
105 }
106 
107 contract ERC20 is IERC20 {
108     using SafeMath for uint256;
109 
110     mapping (address => uint256) private _balances;
111 
112     mapping (address => mapping (address => uint256)) private _allowances;
113 
114     uint256 private _totalSupply;
115 
116     
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     
122     function balanceOf(address account) public view returns (uint256) {
123         return _balances[account];
124     }
125 
126     
127     function transfer(address recipient, uint256 amount) public returns (bool) {
128         _transfer(msg.sender, recipient, amount);
129         return true;
130     }
131 
132     
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowances[owner][spender];
135     }
136 
137     
138     function approve(address spender, uint256 value) public returns (bool) {
139         _approve(msg.sender, spender, value);
140         return true;
141     }
142 
143     
144     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
145         _transfer(sender, recipient, amount);
146         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
147         return true;
148     }
149 
150     
151     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
152         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
153         return true;
154     }
155 
156     
157     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
158         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
159         return true;
160     }
161 
162     
163     function _transfer(address sender, address recipient, uint256 amount) internal {
164         require(sender != address(0), "ERC20: transfer from the zero address");
165         require(recipient != address(0), "ERC20: transfer to the zero address");
166 
167         _balances[sender] = _balances[sender].sub(amount);
168         _balances[recipient] = _balances[recipient].add(amount);
169         emit Transfer(sender, recipient, amount);
170     }
171 
172     
173     function _mint(address account, uint256 amount) internal {
174         require(account != address(0), "ERC20: mint to the zero address");
175 
176         _totalSupply = _totalSupply.add(amount);
177         _balances[account] = _balances[account].add(amount);
178         emit Transfer(address(0), account, amount);
179     }
180 
181      
182     function _burn(address account, uint256 value) internal {
183         require(account != address(0), "ERC20: burn from the zero address");
184 
185         _totalSupply = _totalSupply.sub(value);
186         _balances[account] = _balances[account].sub(value);
187         emit Transfer(account, address(0), value);
188     }
189 
190     
191     function _approve(address owner, address spender, uint256 value) internal {
192         require(owner != address(0), "ERC20: approve from the zero address");
193         require(spender != address(0), "ERC20: approve to the zero address");
194 
195         _allowances[owner][spender] = value;
196         emit Approval(owner, spender, value);
197     }
198 
199     
200     function _burnFrom(address account, uint256 amount) internal {
201         _burn(account, amount);
202         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
203     }
204 }
205 
206 contract ERC20Burnable is ERC20 {
207     
208     function burn(uint256 amount) public {
209         _burn(msg.sender, amount);
210     }
211 
212     
213     function burnFrom(address account, uint256 amount) public {
214         _burnFrom(account, amount);
215     }
216 }
217 
218 contract PACToken is ERC20Detailed, ERC20Burnable {
219   uint8 private constant DECIMALS = 18;
220   uint256 private constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(DECIMALS));
221 
222   
223   constructor() ERC20Detailed("PAC Token", "PAC", DECIMALS) public {
224       _mint(msg.sender, INITIAL_SUPPLY);
225   }
226 }