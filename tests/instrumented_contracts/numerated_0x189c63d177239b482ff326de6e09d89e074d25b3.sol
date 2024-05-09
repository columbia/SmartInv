1 /*
2 The United Crypto System is an unique Blockchain-based system that combines three key elements:
3 UCS Gambling (Cryptocurrency Casino)
4 UCS Dapps (Game Applications)
5 UCS Bet (Sports Betting)
6 The platform will provide access to the three most popular destinations in the niche, using a single cryptocurrency and wallet.
7 The United Crypto System is an unique system, the first and only in the world, which will bring dividends to each investor (100% of net profit is subject to distribution throughout the project’s lifetime) and an additional percentage (from 3% to 150%) for each month ownership investment token. 
8 
9 The sooner you join our United Crypto System Token Sale, the more you will earn. 
10 For example, if you invest in pre-ICO or ICO, then in September after IEO you will be able to get more than 10000% of profit.
11 
12 IEO (Initial Exchange Offering) of the United Crypto System tokens is scheduled for August-September 2019. 
13 
14 Our website https://casinosinvest.com 
15 Our telegram channel https://t.me//Unitedsystem 
16 Our telegram chat https://t.me//Casinosystem
17 
18 */
19 
20 pragma solidity ^0.5.0;
21 interface IERC20 {
22     function transfer(address to, uint256 value) external returns (bool);
23 
24     function approve(address spender, uint256 value) external returns (bool);
25 
26     function transferFrom(address from, address to, uint256 value) external returns (bool);
27 
28     function totalSupply() external view returns (uint256);
29 
30     function balanceOf(address who) external view returns (uint256);
31 
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b > 0);
53         uint256 c = a / b;
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b <= a);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b != 0);
73         return a % b;
74     }
75 }
76 
77 contract ERC20 is IERC20 {
78     using SafeMath for uint256;
79 
80     mapping (address => uint256) private _balances;
81 
82     mapping (address => mapping (address => uint256)) private _allowed;
83 
84     uint256 private _totalSupply;
85 
86     function totalSupply() public view returns (uint256) {
87         return _totalSupply;
88     }
89 
90     function balanceOf(address owner) public view returns (uint256) {
91         return _balances[owner];
92     }
93 
94     function allowance(address owner, address spender) public view returns (uint256) {
95         return _allowed[owner][spender];
96     }
97 
98     function transfer(address to, uint256 value) public returns (bool) {
99         require(block.timestamp > 1564617600, "Tokens transfers are prohibited until August 1, 2019");
100 
101         _transfer(msg.sender, to, value);
102         return true;
103     }
104 
105     function approve(address spender, uint256 value) public returns (bool) {
106         require(spender != address(0));
107 
108         _allowed[msg.sender][spender] = value;
109         emit Approval(msg.sender, spender, value);
110         return true;
111     }
112 
113     function transferFrom(address from, address to, uint256 value) public returns (bool) {
114         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
115         _transfer(from, to, value);
116         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
117         return true;
118     }
119 
120     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
121         require(spender != address(0));
122 
123         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
124         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
125         return true;
126     }
127 
128     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
129         require(spender != address(0));
130 
131         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
132         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
133         return true;
134     }
135 
136     function _transfer(address from, address to, uint256 value) internal {
137         require(to != address(0));
138 
139         _balances[from] = _balances[from].sub(value);
140         _balances[to] = _balances[to].add(value);
141         emit Transfer(from, to, value);
142     }
143 
144     function _mint(address account, uint256 value) internal {
145         require(account != address(0));
146 
147         _totalSupply = _totalSupply.add(value);
148         _balances[account] = _balances[account].add(value);
149         emit Transfer(address(0), account, value);
150     }
151 
152     function _burn(address account, uint256 value) internal {
153         require(account != address(0));
154 
155         _totalSupply = _totalSupply.sub(value);
156         _balances[account] = _balances[account].sub(value);
157         emit Transfer(account, address(0), value);
158     }
159 
160     function _burnFrom(address account, uint256 value) internal {
161         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
162         _burn(account, value);
163         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
164     }
165 }
166 
167 library Roles {
168     struct Role {
169         mapping (address => bool) bearer;
170     }
171 
172     function add(Role storage role, address account) internal {
173         require(account != address(0));
174         require(!has(role, account));
175 
176         role.bearer[account] = true;
177     }
178 
179     function remove(Role storage role, address account) internal {
180         require(account != address(0));
181         require(has(role, account));
182 
183         role.bearer[account] = false;
184     }
185 
186     function has(Role storage role, address account) internal view returns (bool) {
187         require(account != address(0));
188         return role.bearer[account];
189     }
190 }
191 
192 contract MinterRole {
193     using Roles for Roles.Role;
194 
195     event MinterAdded(address indexed account);
196     event MinterRemoved(address indexed account);
197 
198     Roles.Role private _minters;
199 
200     constructor () internal {
201         _addMinter(msg.sender);
202     }
203 
204     modifier onlyMinter() {
205         require(isMinter(msg.sender));
206         _;
207     }
208 
209     function isMinter(address account) public view returns (bool) {
210         return _minters.has(account);
211     }
212 
213     function addMinter(address account) public onlyMinter {
214         _addMinter(account);
215     }
216 
217     function renounceMinter() public {
218         _removeMinter(msg.sender);
219     }
220 
221     function _addMinter(address account) internal {
222         _minters.add(account);
223         emit MinterAdded(account);
224     }
225 
226     function _removeMinter(address account) internal {
227         _minters.remove(account);
228         emit MinterRemoved(account);
229     }
230 }
231 
232 contract ERC20Mintable is ERC20, MinterRole {
233     function mint(address to, uint256 value) public onlyMinter returns (bool) {
234         _mint(to, value);
235         return true;
236     }
237 }
238 
239 contract UCS is ERC20Mintable {
240   string public constant name = "United Crypto System";
241   string public constant symbol = "UCS";
242   uint8 public constant decimals = 18;
243 }