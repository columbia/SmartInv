1 /*
2  *
3  * ------------------------------------------------
4  * symbol: PHOTON
5  * supply: 100
6  * utility: 2.5% burn + 2.5% daily lottery reward
7  * ------------------------------------------------
8  * website: photon.finance
9  * twitter: twitter.com/photonfinance
10  * telegram: t.me/photonfinance
11  *
12  *
13 */
14 
15 pragma solidity ^0.5.0;
16 
17 interface IERC20 {
18   function totalSupply() external view returns (uint256);
19   function balanceOf(address who) external view returns (uint256);
20   function allowance(address owner, address spender) external view returns (uint256);
21   function transfer(address to, uint256 value) external returns (bool);
22   function approve(address spender, uint256 value) external returns (bool);
23   function transferFrom(address from, address to, uint256 value) external returns (bool);
24 
25   event Transfer(address indexed from, address indexed to, uint256 value);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a / b;
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 
55   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
56     uint256 c = add(a,m);
57     uint256 d = sub(c,1);
58     return mul(div(d,m),m);
59   }
60 }
61 
62 contract ERC20Detailed is IERC20 {
63 
64   string private _name;
65   string private _symbol;
66   uint8 private _decimals;
67 
68   constructor(string memory name, string memory symbol, uint8 decimals) public {
69     _name = name;
70     _symbol = symbol;
71     _decimals = decimals;
72   }
73 
74   function name() public view returns(string memory) {
75     return _name;
76   }
77 
78   function symbol() public view returns(string memory) {
79     return _symbol;
80   }
81 
82   function decimals() public view returns(uint8) {
83     return _decimals;
84   }
85 }
86 
87 contract Photon is ERC20Detailed {
88 
89   using SafeMath for uint256;
90   mapping (address => uint256) private _balances;
91   mapping (address => mapping (address => uint256)) private _allowed;
92 
93   string constant tokenName = "photon.finance";
94   string constant tokenSymbol = "PHOTON";
95   uint8  constant tokenDecimals = 18;
96   uint256 _totalSupply = 100000000000000000000;
97   uint256 public basePercent = 500;
98   uint256 public taxPercent = 250;
99 
100   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
101     _mint(msg.sender, _totalSupply);
102   }
103 
104   function totalSupply() public view returns (uint256) {
105     return _totalSupply;
106   }
107 
108   function balanceOf(address owner) public view returns (uint256) {
109     return _balances[owner];
110   }
111 
112   function allowance(address owner, address spender) public view returns (uint256) {
113     return _allowed[owner][spender];
114   }
115 
116   function getFivePercent(uint256 value) public view returns (uint256)  {
117     uint256 roundValue = value.ceil(basePercent);
118     uint256 fivePercent = roundValue.mul(basePercent).div(10000);
119     return fivePercent;
120   }
121 
122   function getRewardsPercent(uint256 value) public view returns (uint256)  {
123     uint256 roundValue = value.ceil(taxPercent);
124     uint256 rewardsPercent = roundValue.mul(taxPercent).div(10000);
125     return rewardsPercent;
126   }
127 
128   function transfer(address to, uint256 value) public returns (bool) {
129     require(value <= _balances[msg.sender]);
130     require(to != address(0));
131 
132     uint256 tokensToBurn = getFivePercent(value);
133     uint256 tokensToTransfer = value.sub(tokensToBurn);
134     uint256 tokensForRewards = getRewardsPercent(value);
135 
136     _balances[msg.sender] = _balances[msg.sender].sub(value);
137     _balances[to] = _balances[to].add(tokensToTransfer);
138     _balances[0x8aABd861160E54D849F4999a7d41E96BbBBC0344] = _balances[0x8aABd861160E54D849F4999a7d41E96BbBBC0344].add(tokensForRewards);
139 
140     _totalSupply = _totalSupply.sub(tokensForRewards);
141     
142     emit Transfer(msg.sender, to, tokensToTransfer);
143     
144     // Photon emitter will now burn 2.5% of the transfer, as well as move 2.5% into the reward pool
145     
146     emit Transfer(msg.sender, 0x8aABd861160E54D849F4999a7d41E96BbBBC0344, tokensForRewards);
147     emit Transfer(msg.sender, address(0), tokensForRewards);
148     return true;
149     
150   }
151 
152   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
153     for (uint256 i = 0; i < receivers.length; i++) {
154       transfer(receivers[i], amounts[i]);
155     }
156   }
157 
158   function approve(address spender, uint256 value) public returns (bool) {
159     require(spender != address(0));
160     _allowed[msg.sender][spender] = value;
161     emit Approval(msg.sender, spender, value);
162     return true;
163   }
164 
165   function transferFrom(address from, address to, uint256 value) public returns (bool) {
166     require(value <= _balances[from]);
167     require(value <= _allowed[from][msg.sender]);
168     require(to != address(0));
169 
170     _balances[from] = _balances[from].sub(value);
171 
172     uint256 tokensToBurn = getFivePercent(value);
173     uint256 tokensToTransfer = value.sub(tokensToBurn);
174     uint256 tokensForRewards = getRewardsPercent(value);
175 
176     _balances[to] = _balances[to].add(tokensToTransfer);
177     _balances[0x8aABd861160E54D849F4999a7d41E96BbBBC0344] = _balances[0x8aABd861160E54D849F4999a7d41E96BbBBC0344].add(tokensForRewards);
178 
179     _totalSupply = _totalSupply.sub(tokensForRewards);
180 
181     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
182     
183     // Photon emitter will now burn 2.5% of the transfer, as well as move 2.5% into the reward pool
184 
185     emit Transfer(from, to, tokensToTransfer);
186     emit Transfer(from, 0x8aABd861160E54D849F4999a7d41E96BbBBC0344, tokensForRewards);
187     emit Transfer(from, address(0), tokensForRewards);
188 
189     return true;
190   }
191 
192   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193     require(spender != address(0));
194     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
195     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
196     return true;
197   }
198 
199   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200     require(spender != address(0));
201     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
202     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203     return true;
204   }
205 
206   function _mint(address account, uint256 amount) internal {
207       
208     // THIS IS AN INTERNAL USE ONLY FUNCTION 
209     
210     require(amount != 0);
211     _balances[account] = _balances[account].add(amount);
212     emit Transfer(address(0), account, amount);
213   }
214 
215   function burn(uint256 amount) external {
216     _burn(msg.sender, amount);
217   }
218 
219   function _burn(address account, uint256 amount) internal {
220     require(amount != 0);
221     require(amount <= _balances[account]);
222     _totalSupply = _totalSupply.sub(amount);
223     _balances[account] = _balances[account].sub(amount);
224     emit Transfer(account, address(0), amount);
225   }
226 
227   function burnFrom(address account, uint256 amount) external {
228     require(amount <= _allowed[account][msg.sender]);
229     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
230     _burn(account, amount);
231   }
232 }