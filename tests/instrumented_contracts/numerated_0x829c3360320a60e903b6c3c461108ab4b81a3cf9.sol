1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0);
19         uint256 c = a / b;
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address who) external view returns (uint256);
47     function transfer(address to, uint256 value) external returns (bool);
48     function approve(address spender, uint256 value) external returns (bool);
49     function transferFrom(address payable from, address to, uint256 value) external returns (bool);
50     function allowance(address owner, address spender) external view returns (uint256);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     event FrozenFunds(address target, bool freeze);
54     event Paused(address account);
55     event Unpaused(address account);
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 }
58 
59 contract ERC20 is IERC20 {
60 
61     using SafeMath for uint256;
62 
63     address payable private _owner;
64     string private _name;
65     string private _symbol;
66     uint8 private _decimals;
67     uint256 private _totalSupply;
68     bool private _paused;
69 
70     mapping (address => uint256) private _balances;
71 
72     mapping (address => mapping (address => uint256)) private _allowed;
73 
74     mapping (address => bool) public frozenAccount;
75 
76     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public{
77         _totalSupply = totalSupply * (10 ** uint256(decimals));
78         _name = name;
79         _symbol = symbol;
80         _decimals = decimals;
81         _balances[msg.sender] = _totalSupply;
82         _paused = false;
83         _owner = msg.sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86     
87     modifier onlyOwner() {
88         require(isOwner(), "YOUR NOT OWNER");
89         _;
90     }
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95     
96     function name() public view returns (string memory) {
97         return _name;
98     }
99 
100     function symbol() public view returns (string memory) {
101         return _symbol;
102     }
103 
104     function decimals() public view returns (uint8) {
105         return _decimals;
106     }
107 
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117     function transferOwnership(address payable newOwner) public onlyOwner {
118         _transferOwnership(newOwner);
119     }
120 
121     function _transferOwnership(address payable newOwner) internal {
122         require(newOwner != address(0),"It's not a normal approach.");
123         emit OwnershipTransferred(_owner, newOwner);
124         _owner = newOwner;
125     }
126 
127     function paused() public view returns (bool) {
128         return _paused;
129     }
130 
131     modifier whenNotPaused() {
132         require(!_paused);
133         _;
134     }
135 
136     modifier whenPaused() {
137         require(_paused,"This contract has been suspended.");
138         _;
139     }
140 
141     function pause() public onlyOwner whenNotPaused {
142         _paused = true;
143         emit Paused(msg.sender);
144     }
145 
146     function unpause() public onlyOwner whenPaused {
147         _paused = false;
148         emit Unpaused(msg.sender);
149     }
150 
151     function totalSupply() public view returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address user) public view returns (uint256) {
156         return _balances[user];
157     }
158 
159     function allowance(address user, address spender) public view returns (uint256) {
160         return _allowed[user][spender];
161     }
162 
163     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
164         require(_balances[msg.sender] >= value,"be short of balance");
165         _transfer(msg.sender, to, value);
166         return true;
167     }
168 
169     function burn(uint value) public whenNotPaused returns(bool) {
170          _burn(msg.sender, value);
171          return true;
172     }
173 
174     function approve(address spender, uint256 value) public returns (bool) {
175         _approve(msg.sender, spender, value);
176         return true;
177     }
178 
179     function transferFrom(address payable from, address to, uint256 value) public whenNotPaused returns (bool) {
180         require(_allowed[from][msg.sender] >= value,"be short of balance");
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     function mint(uint value) public whenNotPaused onlyOwner returns(bool){
187         _mint(msg.sender, value);
188         return true;
189     }
190 
191     function burnFrom(address account, uint value) public returns(bool){
192         _burnFrom(account, value);
193         return true;
194     }
195 
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
202         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
203         return true;
204     }
205 
206     function _transfer(address payable from, address to, uint256 value) internal {
207         require(to != address(0),"be not a normal approach");
208         require(to != from,"You can't send it alone.");
209         require(value <= _balances[from],"be short of balance");
210         require(!frozenAccount[from],"This account has been frozen. [Sender]");
211         require(!frozenAccount[to],"This account has been frozen. [Recipient]");
212         require(!frozenAccount[msg.sender],"This account has been frozen. [Wallet]");
213   
214         _balances[from] = _balances[from].sub(value);
215         _balances[to] = _balances[to].add(value);
216         
217         emit Transfer(from, to, value);
218     }
219 
220     function _mint(address account, uint256 value) internal {
221         require(account != address(0),"be not a normal approach");
222 
223         _totalSupply = _totalSupply.add(value);
224         _balances[account] = _balances[account].add(value);
225         emit Transfer(address(0), account, value);
226     }
227 
228     function _burn(address account, uint256 value) internal {
229         require(account != address(0),"be not a normal approach");
230         require(value <= _balances[account],"be short of balance");
231 
232         _totalSupply = _totalSupply.sub(value);
233         _balances[account] = _balances[account].sub(value);
234         emit Transfer(account, address(0), value);
235     }
236 
237     function _approve(address user, address spender, uint256 value) internal {
238         require(spender != address(0),"be not a normal approach");
239         require(user != address(0),"be not a normal approach");
240 
241         _allowed[user][spender] = value;
242         emit Approval(user, spender, value);
243     }
244 
245     function _burnFrom(address account, uint256 value) internal {
246         _burn(account, value);
247         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
248     }
249 
250     function freezeAccount(address target) onlyOwner public {
251         frozenAccount[target] = true;
252         emit FrozenFunds(target, true);
253     }
254     
255      function unfreezeAccount(address target) onlyOwner public {
256         frozenAccount[target] = false;
257         emit FrozenFunds(target, false);
258     }
259 
260     function () payable external{
261     }  
262 
263 }