1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-20
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 interface IERC20 {
8     function totalSupply() external view returns(uint256);
9 
10     function balanceOf(address who) external view returns(uint256);
11 
12     function allowance(address owner, address spender) external view returns(uint256);
13 
14     function transfer(address to, uint256 value) external returns(bool);
15 
16     function approve(address spender, uint256 value) external returns(bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns(bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns(uint256) {
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns(uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50     function ceil(uint256 a, uint256 m) internal pure returns(uint256) {
51         uint256 c = add(a, m);
52         uint256 d = sub(c, 1);
53         return mul(div(d, m), m);
54     }
55 }
56 
57 contract ERC20Detailed is IERC20 {
58 
59     string private _name;
60     string private _symbol;
61     uint8 private _decimals;
62 
63     constructor(string memory name, string memory symbol, uint8 decimals) public {
64         _name = name;
65         _symbol = symbol;
66         _decimals = decimals;
67     }
68 
69     function name() public view returns(string memory) {
70         return _name;
71     }
72 
73     function symbol() public view returns(string memory) {
74         return _symbol;
75     }
76 
77     function decimals() public view returns(uint8) {
78         return _decimals;
79     }
80 }
81 
82 contract Blockburn is ERC20Detailed {
83 
84     using SafeMath for uint256;
85     mapping(address => uint256) private _balances;
86     mapping(address => mapping(address => uint256)) private _allowed;
87 
88     string constant tokenName = "Blockburn";
89     string constant tokenSymbol = "BURN";
90     uint8 constant tokenDecimals = 18;
91     uint256 _totalSupply;
92     uint256 public basePercent = 200;
93     address admin;
94     address developers;
95     uint256 public _startTime;
96     uint256 public _burnStopAmount;
97     uint256 public _lastTokenSupply;
98     uint256 public _releaseAmountAfterTwoYears;
99     bool public _timeLockReleased;
100 
101     constructor(address _developers, address bank) public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
102         admin = msg.sender;
103         developers = _developers;
104         // give 1m tokens to admin
105         _mint(bank, 1000000 * 10**18);
106         // give 800k tokens to contract
107         _mint(address(this), 800000 * 10**18);
108         
109         _totalSupply = 2000000 * 10**18;
110 
111         _startTime = now;
112         _burnStopAmount = 0;
113         _lastTokenSupply = 1200000 * 10**18;
114         _releaseAmountAfterTwoYears = 200000 * 10**18;
115         
116         _timeLockReleased = false;
117     }
118 
119     modifier onlyAdmin() {
120         require(msg.sender == admin, "Only admin can do this");
121         _;
122     }
123 
124     function transferAdmin(address _newAdmin) public onlyAdmin {
125         require(_newAdmin != admin && _newAdmin != address(0), "Error");
126         admin = _newAdmin;
127     }
128 
129     function totalSupply() public view returns(uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address owner) public view returns(uint256) {
134         return _balances[owner];
135     }
136 
137     function allowance(address owner, address spender) public view returns(uint256) {
138         return _allowed[owner][spender];
139     }
140 
141     function findTwoPercent(uint256 value) internal view returns(uint256) {
142         uint256 roundValue = value.ceil(basePercent);
143         uint256 onePercent = roundValue.mul(basePercent).div(10000);
144         return onePercent;
145     }
146 
147     function transfer(address to, uint256 value) public returns(bool) {
148         require(value <= _balances[msg.sender]);
149         require(to != address(0));
150 
151         uint256 tokensToBurn = findTwoPercent(value);
152 
153         _balances[msg.sender] = _balances[msg.sender].sub(value);
154         _balances[to] = _balances[to].add(value);
155 
156         uint contractBalance = _balances[address(this)];
157 
158         if(contractBalance > 0) {
159             if (tokensToBurn > contractBalance)
160                 tokensToBurn = contractBalance; 
161 
162             _burn(address(this), tokensToBurn);
163         }
164 
165         emit Transfer(msg.sender, to, value);
166         return true;
167     }
168 
169     function withdraw(uint amount) public onlyAdmin {
170         address contractAddr = address(this);
171         require(amount <= _balances[contractAddr]);
172 
173         _balances[contractAddr] = _balances[contractAddr].sub(amount);
174         _balances[admin] = _balances[admin].add(amount);
175         emit Transfer(contractAddr, admin, amount);
176     }
177 
178     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
179         for (uint256 i = 0; i < receivers.length; i++) {
180             transfer(receivers[i], amounts[i]);
181         }
182     }
183 
184     function approve(address spender, uint256 value) public returns(bool) {
185         require(spender != address(0));
186         _allowed[msg.sender][spender] = value;
187         emit Approval(msg.sender, spender, value);
188         return true;
189     }
190 
191     function transferFrom(address from, address to, uint256 value) public returns(bool) {
192         require(value <= _balances[from]);
193         require(value <= _allowed[from][msg.sender]);
194         require(to != address(0));
195 
196         _balances[from] = _balances[from].sub(value);
197 
198         uint256 tokensToBurn = findTwoPercent(value);
199 
200         _balances[to] = _balances[to].add(value);
201         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
202 
203         uint contractBalance = _balances[address(this)];
204 
205         if(contractBalance > 0) {
206             if (tokensToBurn > contractBalance)
207                 tokensToBurn = contractBalance; 
208 
209             _burn(address(this), tokensToBurn);
210         }
211 
212         emit Transfer(from, to, value);
213         return true;
214     }
215 
216     function increaseAllowance(address spender, uint256 addedValue) public returns(bool) {
217         require(spender != address(0));
218         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
219         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
220         return true;
221     }
222 
223     function decreaseAllowance(address spender, uint256 subtractedValue) public returns(bool) {
224         require(spender != address(0));
225         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
226         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227         return true;
228     }
229 
230     function _mint(address account, uint256 amount) internal {
231         require(amount != 0);
232         _balances[account] = _balances[account].add(amount);
233         emit Transfer(address(0), account, amount);
234     }
235 
236     function _burn(address account, uint256 amount) internal {
237         require(amount != 0);
238         require(amount <= _balances[account]);
239         _totalSupply = _totalSupply.sub(amount);
240         _balances[account] = _balances[account].sub(amount);
241         emit Transfer(account, address(0), amount);
242     }
243 
244     function burnFrom(address account, uint256 amount) external {
245         require(amount <= _allowed[account][msg.sender]);
246         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
247         _burn(account, amount);
248     }
249 
250     function release() public {
251         require(now >= _startTime + 102 weeks, "Early for release");
252         require(!_timeLockReleased, "Timelock already released");
253         
254         _mint(developers, _releaseAmountAfterTwoYears);
255         _timeLockReleased = true;
256     }
257 }