1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.6.12;
3 
4 /*
5 *  Adventure.sol
6 *  TWA V1 deflationary community token smart contract
7 *  2020-09-29
8 **/
9 
10 interface IERC20 {
11   function totalSupply() external view returns (uint256);
12   function balanceOf(address who) external view returns (uint256);
13   function allowance(address owner, address spender) external view returns (uint256);
14   function transfer(address to, uint256 value) external returns (bool);
15   function approve(address spender, uint256 value) external returns (bool);
16   function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18   event Transfer(address indexed from, address indexed to, uint256 value);
19   event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a / b;
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
49     uint256 c = add(a,m);
50     uint256 d = sub(c,1);
51     return mul(div(d,m),m);
52   }
53 }
54 
55 abstract contract ERC20Detailed is IERC20 {
56 
57   string private _name;
58   string private _symbol;
59   uint8 private _decimals;
60 
61   constructor(string memory name, string memory symbol, uint8 decimals) public {
62     _name = name;
63     _symbol = symbol;
64     _decimals = decimals;
65   }
66 
67   function name() public view returns(string memory) {
68     return _name;
69   }
70 
71   function symbol() public view returns(string memory) {
72     return _symbol;
73   }
74 
75   function decimals() public view returns(uint8) {
76     return _decimals;
77   }
78 }
79 
80 contract Adventure is ERC20Detailed {
81 
82   using SafeMath for uint256;
83   mapping (address => uint256) private _balances;
84   mapping (address => mapping (address => uint256)) private _allowed;
85 
86   string constant TOKEN_NAME = "Adventure";
87   string constant TOKEN_SYMBOL = "TWA";
88   uint8  constant TOKEN_DECIMALS = 18;
89   address public twaFoundation;
90   address constant public TWA_COMMUNITY = 0x99ee7AEd55c08c5CC19CF3655439E4d8e8de4ce1;
91   address constant public TWA_MARKETING_DEV_LIQ = 0x8f012CD662fc117dc21bCbf4A52b5052BF7a4D4E;
92   uint public immutable twaFoundationLockedUntil;
93   uint256 _totalSupply = 101000000000000000000000000;
94   uint256 constant BASE_PERCENT = 100;
95 
96   constructor() public payable ERC20Detailed(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS) {
97     twaFoundation = msg.sender;
98 
99     _issue(twaFoundation, 30000000000000000000000000);
100     _issue(TWA_COMMUNITY, 55000000000000000000000000);
101     _issue(TWA_MARKETING_DEV_LIQ, 16000000000000000000000000);
102     
103     // 24 months is 63115200 seconds
104     twaFoundationLockedUntil = now + 63115200;
105   }
106 
107   function totalSupply() external override view returns (uint256) {
108     return _totalSupply;
109   }
110 
111   function balanceOf(address owner) external override view returns (uint256) {
112     return _balances[owner];
113   }
114 
115   function allowance(address owner, address spender) external override view returns (uint256) {
116     return _allowed[owner][spender];
117   }
118 
119   function cut(uint256 value) public pure returns (uint256)  {
120     uint256 roundValue = value.ceil(BASE_PERCENT);
121     uint256 cutValue = roundValue.mul(BASE_PERCENT).div(10000);
122     return cutValue;
123   }
124 
125   function transfer(address to, uint256 value) external override returns (bool) {
126     require(value <= _balances[msg.sender]);
127     require(to != address(0));
128     require(canTransact(msg.sender));
129 
130     uint256 tokensToBurn = cut(value);
131     uint256 tokensToTransfer = value.sub(tokensToBurn);
132 
133     _balances[msg.sender] = _balances[msg.sender].sub(value);
134     _balances[to] = _balances[to].add(tokensToTransfer);
135 
136     _totalSupply = _totalSupply.sub(tokensToBurn);
137 
138     emit Transfer(msg.sender, to, tokensToTransfer);
139     emit Transfer(msg.sender, address(0), tokensToBurn);
140     return true;
141   }
142 
143 
144   function approve(address spender, uint256 value) external override returns (bool) {
145     require(spender != address(0));
146     require(canTransact(msg.sender));
147     _allowed[msg.sender][spender] = value;
148     emit Approval(msg.sender, spender, value);
149     return true;
150   }
151 
152   function transferFrom(address from, address to, uint256 value) external override returns (bool) {
153     require(value <= _balances[from]);
154     require(value <= _allowed[from][msg.sender]);
155     require(to != address(0));
156     require(canTransact(from));
157 
158     _balances[from] = _balances[from].sub(value);
159 
160     uint256 tokensToBurn = cut(value);
161     uint256 tokensToTransfer = value.sub(tokensToBurn);
162 
163     _balances[to] = _balances[to].add(tokensToTransfer);
164     _totalSupply = _totalSupply.sub(tokensToBurn);
165 
166     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167 
168     emit Transfer(from, to, tokensToTransfer);
169     emit Transfer(from, address(0), tokensToBurn);
170 
171     return true;
172   }
173 
174   function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
175     require(spender != address(0));
176     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
177     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178     return true;
179   }
180 
181   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
182     require(spender != address(0));
183     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
184     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
185     return true;
186   }
187 
188   function _issue(address account, uint256 amount) internal {
189     require(amount != 0);
190     _balances[account] = _balances[account].add(amount);
191     emit Transfer(address(0), account, amount);
192   }
193 
194   function destroy(uint256 amount) external {
195     _destroy(msg.sender, amount);
196   }
197 
198   function _destroy(address account, uint256 amount) internal {
199     require(amount != 0);
200     require(amount <= _balances[account]);
201     _totalSupply = _totalSupply.sub(amount);
202     _balances[account] = _balances[account].sub(amount);
203     emit Transfer(account, address(0), amount);
204   }
205 
206   function destroyFrom(address account, uint256 amount) external {
207     require(amount <= _allowed[account][msg.sender]);
208     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
209     _destroy(account, amount);
210   }
211    
212   function canTransact(address account) public view returns (bool) {
213     if (account != twaFoundation) {
214       return true;
215     }
216     
217     if (now < twaFoundationLockedUntil) {
218       return false;
219     }
220     
221     return true;
222   }
223 }