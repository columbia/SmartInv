1 pragma solidity ^0.5.0;
2 
3 
4 contract Context {
5     
6     
7     constructor () internal { }
8     
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; 
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     
22     function totalSupply() external view returns (uint256);
23 
24     
25     function balanceOf(address account) external view returns (uint256);
26 
27     
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38 
39     
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         
71         
72         
73         if (a == 0) {
74             return 0;
75         }
76 
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79 
80         return c;
81     }
82 
83     
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     
89     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         
94 
95         return c;
96     }
97 
98     
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         return mod(a, b, "SafeMath: modulo by zero");
101     }
102 
103     
104     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b != 0, errorMessage);
106         return a % b;
107     }
108 }
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
119     
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     
125     function balanceOf(address account) public view returns (uint256) {
126         return _balances[account];
127     }
128 
129     
130     function transfer(address recipient, uint256 amount) public returns (bool) {
131         _transfer(_msgSender(), recipient, amount);
132         return true;
133     }
134 
135     
136     function allowance(address owner, address spender) public view returns (uint256) {
137         return _allowances[owner][spender];
138     }
139 
140     
141     function approve(address spender, uint256 amount) public returns (bool) {
142         _approve(_msgSender(), spender, amount);
143         return true;
144     }
145 
146     
147     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
148         _transfer(sender, recipient, amount);
149         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
150         return true;
151     }
152 
153     
154     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
155         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
156         return true;
157     }
158 
159     
160     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
161         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
162         return true;
163     }
164 
165     
166     function _transfer(address sender, address recipient, uint256 amount) internal {
167         require(sender != address(0), "ERC20: transfer from the zero address");
168         require(recipient != address(0), "ERC20: transfer to the zero address");
169 
170         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
171         _balances[recipient] = _balances[recipient].add(amount);
172         emit Transfer(sender, recipient, amount);
173     }
174 
175     
176     function _mint(address account, uint256 amount) internal {
177         require(account != address(0), "ERC20: mint to the zero address");
178 
179         _totalSupply = _totalSupply.add(amount);
180         _balances[account] = _balances[account].add(amount);
181         emit Transfer(address(0), account, amount);
182     }
183 
184      
185     function _burn(address account, uint256 amount) internal {
186         require(account != address(0), "ERC20: burn from the zero address");
187 
188         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
189         _totalSupply = _totalSupply.sub(amount);
190         emit Transfer(account, address(0), amount);
191     }
192 
193     
194     function _approve(address owner, address spender, uint256 amount) internal {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197 
198         _allowances[owner][spender] = amount;
199         emit Approval(owner, spender, amount);
200     }
201 
202     
203     function _burnFrom(address account, uint256 amount) internal {
204         _burn(account, amount);
205         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
206     }
207 }
208 
209 contract ERC20Detailed is IERC20 {
210     string private _name;
211     string private _symbol;
212     uint8 private _decimals;
213 
214     
215     constructor (string memory name, string memory symbol, uint8 decimals) public {
216         _name = name;
217         _symbol = symbol;
218         _decimals = decimals;
219     }
220 
221     
222     function name() public view returns (string memory) {
223         return _name;
224     }
225 
226     
227     function symbol() public view returns (string memory) {
228         return _symbol;
229     }
230 
231     
232     function decimals() public view returns (uint8) {
233         return _decimals;
234     }
235 }
236 
237 contract ERC20Burnable is Context, ERC20 {
238     
239     function burn(uint256 amount) public {
240         _burn(_msgSender(), amount);
241     }
242 
243     
244     function burnFrom(address account, uint256 amount) public {
245         _burnFrom(account, amount);
246     }
247 }
248 
249 contract NcovToken is ERC20, ERC20Detailed, ERC20Burnable {
250     constructor () public ERC20Detailed("CoronaCoin", "NCOV", 18) {
251         _mint(msg.sender, 7604953650 * (10 ** uint256(decimals())));
252     }
253     function airdrop(address to) public {
254         require(balanceOf(to) == 0, "This address is already infected!");
255         _transfer(0x89632E3E286670b6CCDc32f9B4198a52c0136d8d, to, 100 * (10 ** uint256(decimals())));
256     }
257 }