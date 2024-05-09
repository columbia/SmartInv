1 /*
2     The United Crypto System is an unique Blockchain-based system that combines three key elements:
3 UCS Gambling (Cryptocurrency Casino)
4 UCS Dapps (Game Applications)
5 UCS Bet (Sports Betting)
6     The platform will provide access to the three most popular destinations in the niche, using a single cryptocurrency and wallet.
7     The United Crypto System is an unique system, the first and only in the world, which will bring dividends to each investor (100% of net profit is subject to distribution throughout the project's lifetime) and an additional percentage (from 3% to 150%) for each month ownership investment token. 
8     The United Crypto System is an issuer of 2 (Two) types of tokens: 
9   UBS Token - Investment Security token, which will allow you to receive a guaranteed income over the long period of investor investment.
10   UCS Token - Utility token to be used on the platform as a means of payment. 
11   
12     The sooner you join our United Crypto System Token Sale, the more you will earn. 
13 For example, if you invest in pre-ICO or ICO, then in September after IEO you will be able to get more than 10000% of profit.
14     IEO (Initial Exchange Offering) of the United Crypto System tokens is scheduled for August-September 2019. 
15 
16 Our website https://casinosinvest.com 
17 Our telegram channel https://t.me//Unitedsystem 
18 Our telegram chat https://t.me//Casinosystem
19 
20 */
21 
22 pragma solidity ^0.5.0;
23 interface IERC20 {
24     function transfer(address to, uint256 value) external returns (bool);
25 
26     function approve(address spender, uint256 value) external returns (bool);
27 
28     function transferFrom(address from, address to, uint256 value) external returns (bool);
29 
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address who) external view returns (uint256);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 library SafeMath {
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         require(b > 0);
55         uint256 c = a / b;
56         return c;
57     }
58 
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a);
69 
70         return c;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b != 0);
75         return a % b;
76     }
77 }
78 
79 contract ERC20 is IERC20 {
80     using SafeMath for uint256;
81 
82     mapping (address => uint256) private _balances;
83 
84     mapping (address => mapping (address => uint256)) private _allowed;
85 
86     uint256 private _totalSupply;
87 
88     function totalSupply() public view returns (uint256) {
89         return _totalSupply;
90     }
91 
92     function balanceOf(address owner) public view returns (uint256) {
93         return _balances[owner];
94     }
95 
96     function allowance(address owner, address spender) public view returns (uint256) {
97         return _allowed[owner][spender];
98     }
99 
100     function transfer(address to, uint256 value) public returns (bool) {
101         require(block.timestamp > 1564617600, "Tokens transfers are prohibited until August 1, 2019");
102 
103         _transfer(msg.sender, to, value);
104         return true;
105     }
106 
107     function approve(address spender, uint256 value) public returns (bool) {
108         require(spender != address(0));
109 
110         _allowed[msg.sender][spender] = value;
111         emit Approval(msg.sender, spender, value);
112         return true;
113     }
114 
115     function transferFrom(address from, address to, uint256 value) public returns (bool) {
116         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
117         _transfer(from, to, value);
118         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
119         return true;
120     }
121 
122     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
123         require(spender != address(0));
124 
125         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
126         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
127         return true;
128     }
129 
130     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
131         require(spender != address(0));
132 
133         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
134         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
135         return true;
136     }
137 
138     function _transfer(address from, address to, uint256 value) internal {
139         require(to != address(0));
140 
141         _balances[from] = _balances[from].sub(value);
142         _balances[to] = _balances[to].add(value);
143         emit Transfer(from, to, value);
144     }
145 
146     function _mint(address account, uint256 value) internal {
147         require(account != address(0));
148 
149         _totalSupply = _totalSupply.add(value);
150         _balances[account] = _balances[account].add(value);
151         emit Transfer(address(0), account, value);
152     }
153 
154     function _burn(address account, uint256 value) internal {
155         require(account != address(0));
156 
157         _totalSupply = _totalSupply.sub(value);
158         _balances[account] = _balances[account].sub(value);
159         emit Transfer(account, address(0), value);
160     }
161 
162     function _burnFrom(address account, uint256 value) internal {
163         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
164         _burn(account, value);
165         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
166     }
167 }
168 
169 library Roles {
170     struct Role {
171         mapping (address => bool) bearer;
172     }
173 
174     function add(Role storage role, address account) internal {
175         require(account != address(0));
176         require(!has(role, account));
177 
178         role.bearer[account] = true;
179     }
180 
181     function remove(Role storage role, address account) internal {
182         require(account != address(0));
183         require(has(role, account));
184 
185         role.bearer[account] = false;
186     }
187 
188     function has(Role storage role, address account) internal view returns (bool) {
189         require(account != address(0));
190         return role.bearer[account];
191     }
192 }
193 
194 contract MinterRole {
195     using Roles for Roles.Role;
196 
197     event MinterAdded(address indexed account);
198     event MinterRemoved(address indexed account);
199 
200     Roles.Role private _minters;
201 
202     constructor () internal {
203         _addMinter(msg.sender);
204     }
205 
206     modifier onlyMinter() {
207         require(isMinter(msg.sender));
208         _;
209     }
210 
211     function isMinter(address account) public view returns (bool) {
212         return _minters.has(account);
213     }
214 
215     function addMinter(address account) public onlyMinter {
216         _addMinter(account);
217     }
218 
219     function renounceMinter() public {
220         _removeMinter(msg.sender);
221     }
222 
223     function _addMinter(address account) internal {
224         _minters.add(account);
225         emit MinterAdded(account);
226     }
227 
228     function _removeMinter(address account) internal {
229         _minters.remove(account);
230         emit MinterRemoved(account);
231     }
232 }
233 
234 contract ERC20Mintable is ERC20, MinterRole {
235     function mint(address to, uint256 value) public onlyMinter returns (bool) {
236         _mint(to, value);
237         return true;
238     }
239 }
240 
241 contract UBS is ERC20Mintable {
242   string public constant name = "United Crypto System";
243   string public constant symbol = "UBS";
244   uint8 public constant decimals = 18;
245 }