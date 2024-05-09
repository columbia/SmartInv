1 /*
2 Site: https://lukki.io
3 */
4 pragma solidity ^0.5.2;
5 
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library Roles {
25     struct Role {
26         mapping (address => bool) bearer;
27     }
28 
29     function add(Role storage role, address account) internal {
30         require(account != address(0));
31         require(!has(role, account));
32 
33         role.bearer[account] = true;
34     }
35 
36     function remove(Role storage role, address account) internal {
37         require(account != address(0));
38         require(has(role, account));
39 
40         role.bearer[account] = false;
41     }
42 
43     function has(Role storage role, address account) internal view returns (bool) {
44         require(account != address(0));
45         return role.bearer[account];
46     }
47 }
48 
49 
50 
51 
52 contract MinterRole {
53     using Roles for Roles.Role;
54 
55     event MinterAdded(address indexed account);
56     event MinterRemoved(address indexed account);
57 
58     Roles.Role private _minters;
59 
60     constructor () internal {
61         _addMinter(msg.sender);
62     }
63 
64     modifier onlyMinter() {
65         require(isMinter(msg.sender));
66         _;
67     }
68 
69     function isMinter(address account) public view returns (bool) {
70         return _minters.has(account);
71     }
72 
73     function addMinter(address account) public onlyMinter {
74         _addMinter(account);
75     }
76 
77     function renounceMinter() public {
78         _removeMinter(msg.sender);
79     }
80 
81     function _addMinter(address account) internal {
82         _minters.add(account);
83         emit MinterAdded(account);
84     }
85 
86     function _removeMinter(address account) internal {
87         _minters.remove(account);
88         emit MinterRemoved(account);
89     }
90 }
91 
92 
93 library SafeMath {
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b);
101 
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b > 0);
107         uint256 c = a / b;
108 
109         return c;
110     }
111 
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a);
122 
123         return c;
124     }
125 
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b != 0);
128         return a % b;
129     }
130 }
131 
132 
133 contract ERC20 is IERC20 {
134     using SafeMath for uint256;
135 
136     mapping (address => uint256) private _balances;
137 
138     mapping (address => mapping (address => uint256)) private _allowed;
139 
140     uint256 private _totalSupply;
141 
142     function totalSupply() public view returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address owner) public view returns (uint256) {
147         return _balances[owner];
148     }
149 
150     function allowance(address owner, address spender) public view returns (uint256) {
151         return _allowed[owner][spender];
152     }
153 
154     function transfer(address to, uint256 value) public returns (bool) {
155         _transfer(msg.sender, to, value);
156         return true;
157     }
158 
159     function approve(address spender, uint256 value) public returns (bool) {
160         _approve(msg.sender, spender, value);
161         return true;
162     }
163 
164     function transferFrom(address from, address to, uint256 value) public returns (bool) {
165         _transfer(from, to, value);
166         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
167         return true;
168     }
169 
170 
171     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
172         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
173         return true;
174     }
175 
176     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
177         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
178         return true;
179     }
180 
181     function _transfer(address from, address to, uint256 value) internal {
182         require(to != address(0));
183 
184         _balances[from] = _balances[from].sub(value);
185         _balances[to] = _balances[to].add(value);
186         emit Transfer(from, to, value);
187     }
188 
189     function _mint(address account, uint256 value) internal {
190         require(account != address(0));
191 
192         _totalSupply = _totalSupply.add(value);
193         _balances[account] = _balances[account].add(value);
194         emit Transfer(address(0), account, value);
195     }
196 
197     function _burn(address account, uint256 value) internal {
198         require(account != address(0));
199 
200         _totalSupply = _totalSupply.sub(value);
201         _balances[account] = _balances[account].sub(value);
202         emit Transfer(account, address(0), value);
203     }
204 
205 
206     function _approve(address owner, address spender, uint256 value) internal {
207         require(spender != address(0));
208         require(owner != address(0));
209 
210         _allowed[owner][spender] = value;
211         emit Approval(owner, spender, value);
212     }
213 
214     function _burnFrom(address account, uint256 value) internal {
215         _burn(account, value);
216         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
217     }
218 }
219 
220 
221 
222 contract ERC20Mintable is ERC20, MinterRole {
223     function mint(address to, uint256 value) public onlyMinter returns (bool) {
224         _mint(to, value);
225         return true;
226     }
227 }
228 
229 
230 contract ERC20Capped is ERC20Mintable {
231     uint256 private _cap;
232 
233     constructor (uint256 cap) public {
234         require(cap > 0);
235         _cap = cap;
236     }
237 
238     function cap() public view returns (uint256) {
239         return _cap;
240     }
241 
242     function _mint(address account, uint256 value) internal {
243         require(totalSupply().add(value) <= _cap);
244         super._mint(account, value);
245     }
246 }
247 
248 
249 
250 contract LOT is ERC20Capped {
251     constructor (uint256 cap) public ERC20Capped(cap) {
252         
253     }
254  string public constant name = "Lukki Operating Token";
255  string public constant symbol = "LOT";
256  uint8 public constant decimals = 18;
257 }