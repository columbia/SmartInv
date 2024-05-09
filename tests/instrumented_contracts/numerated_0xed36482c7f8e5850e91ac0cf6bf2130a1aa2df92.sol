1 pragma solidity ^0.5.0;
2 // ----------------------------------------------------------------------------
3 // This is the HOLDTOWIN token contract.
4 // A method to play the crypto lottery in a passive way. One ticket will qualify holder for all drawings as long as user holds 7ADD.
5 // Prize will depend on the amount of tokens transacted. -1.25% of all transactions will go to Jackpot-
6 // Community will decide how much you will have to hold to be included into drawings for 1 chance.
7 // There is a 1.25% burn of 7ADD erc20 token on any transaction.
8 // There is a 1.25% fee of 7ADD erc20 token that will be added to the prize.
9 // Total fee when you buy 7ADD erc20 token = 2.5% * 1.25% burn and 1.25% to jackpot * 
10 // Total fee when you sell 7ADD erc20 token = 2.5% * 1.25% burn and 1.25% to jackpot * 
11 // Total fee when you transfer 7ADD erc20 token to any other address = 2.5% * 1.25% burn and 1.25% to jackpot * 
12 // Lottery prizes will be sent by Jackpot Account after the draw is complete - 1.25% of the Jackpot amount will be reported to the next draw - 1.25% of the Jackpot amount will be burned
13 // 7ADD is a deflationary token.
14 // Anyone can contribute to the Jackpot by sending erc20/eth/NFT to the Jackpot Account. Prizes will be distributed as per senders wish. Contact us if you want to contribute to the prize.
15 // Deployer Account / Jackpot Account and UNISWAP addresses are not participating in draws.
16 // Team funds -5%- WILL participate in draws.
17 // Team funds account 0x57f4e37255767190962874D85C98082Ed31c59fB - Team will receive funds by Deployer transfer - 5% of total supply.
18 // Marketing funds will be spent directly from deployer accounts to avoid double burns. All marketing receivers WILL participate in draws if minimum amount is available- 5% of total supply.
19 // All decisions about the prize and pariticpation amount will be taken by community via snapshot.page decentralized voting.
20 // Good luck!
21 // Details on https://holdtowin.eth.link
22 //
23 // Symbol        : 7ADD
24 // Name          : HOLDTOWIN
25 // Total supply  : 100000
26 // Decimals      : 18
27 // Deployer Account / Jackpot Account : 0x1a6c95c161B0F4159A65371Ed1113bc1F6257ADD
28 //
29 // Join us on Telegram  https://t.me/sevenADDtoken
30 // ----------------------------------------------------------------------------
31 interface IERC20 {
32   function totalSupply() external view returns (uint256);
33   function balanceOf(address who) external view returns (uint256);
34   function allowance(address owner, address spender) external view returns (uint256);
35   function transfer(address to, uint256 value) external returns (bool);
36   function approve(address spender, uint256 value) external returns (bool);
37   function transferFrom(address from, address to, uint256 value) external returns (bool);
38 
39   event Transfer(address indexed from, address indexed to, uint256 value);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     if (a == 0) {
46       return 0;
47     }
48     uint256 c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a / b;
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 
69   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
70     uint256 c = add(a,m);
71     uint256 d = sub(c,1);
72     return mul(div(d,m),m);
73   }
74 }
75 
76 contract ERC20Detailed is IERC20 {
77 
78   string private _name;
79   string private _symbol;
80   uint8 private _decimals;
81 
82   constructor(string memory name, string memory symbol, uint8 decimals) public {
83     _name = name;
84     _symbol = symbol;
85     _decimals = decimals;
86   }
87 
88   function name() public view returns(string memory) {
89     return _name;
90   }
91 
92   function symbol() public view returns(string memory) {
93     return _symbol;
94   }
95 
96   function decimals() public view returns(uint8) {
97     return _decimals;
98   }
99 }
100 
101 contract HOLDTOWIN is ERC20Detailed {
102 
103   using SafeMath for uint256;
104   mapping (address => uint256) private _balances;
105   mapping (address => mapping (address => uint256)) private _allowed;
106 
107   string constant tokenName = "HOLDTOWIN";
108   string constant tokenSymbol = "7ADD";
109   uint8  constant tokenDecimals = 18;
110   uint256 _totalSupply = 100000000000000000000000;
111   uint256 public burntotal = 250;
112   uint256 public jackpots = 125;
113 
114   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
115     _mint(msg.sender, _totalSupply);
116   }
117 
118   function totalSupply() public view returns (uint256) {
119     return _totalSupply;
120   }
121 
122   function balanceOf(address owner) public view returns (uint256) {
123     return _balances[owner];
124   }
125 
126   function allowance(address owner, address spender) public view returns (uint256) {
127     return _allowed[owner][spender];
128   }
129 
130   function getValueCom(uint256 value) public view returns (uint256)  {
131     uint256 roundValue = value.ceil(burntotal);
132     uint256 valueCom = roundValue.mul(burntotal).div(10000);
133     return valueCom;
134   }
135 
136   function getValueJackpot(uint256 value) public view returns (uint256)  {
137     uint256 roundValue = value.ceil(jackpots);
138     uint256 valueJackpot = roundValue.mul(jackpots).div(10000);
139     return valueJackpot;
140   }
141 
142   function transfer(address to, uint256 value) public returns (bool) {
143     require(value <= _balances[msg.sender]);
144     require(to != address(0));
145 
146     uint256 burn7ADD = getValueCom(value);
147     uint256 transfer7ADD = value.sub(burn7ADD);
148     uint256 jackpot7ADD = getValueJackpot(value);
149 
150     _balances[msg.sender] = _balances[msg.sender].sub(value);
151     _balances[to] = _balances[to].add(transfer7ADD);
152     _balances[0x1a6c95c161B0F4159A65371Ed1113bc1F6257ADD] = _balances[0x1a6c95c161B0F4159A65371Ed1113bc1F6257ADD].add(jackpot7ADD);
153 
154     _totalSupply = _totalSupply.sub(jackpot7ADD);
155     
156     emit Transfer(msg.sender, to, transfer7ADD);
157     
158     
159     
160     emit Transfer(msg.sender, 0x1a6c95c161B0F4159A65371Ed1113bc1F6257ADD, jackpot7ADD);
161     emit Transfer(msg.sender, address(0), jackpot7ADD);
162     return true;
163     
164   }
165 
166   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
167     for (uint256 i = 0; i < receivers.length; i++) {
168       transfer(receivers[i], amounts[i]);
169     }
170   }
171 
172   function approve(address spender, uint256 value) public returns (bool) {
173     require(spender != address(0));
174     _allowed[msg.sender][spender] = value;
175     emit Approval(msg.sender, spender, value);
176     return true;
177   }
178 
179   function transferFrom(address from, address to, uint256 value) public returns (bool) {
180     require(value <= _balances[from]);
181     require(value <= _allowed[from][msg.sender]);
182     require(to != address(0));
183 
184     _balances[from] = _balances[from].sub(value);
185 
186     uint256 burn7ADD = getValueCom(value);
187     uint256 transfer7ADD = value.sub(burn7ADD);
188     uint256 jackpot7ADD = getValueJackpot(value);
189 
190     _balances[to] = _balances[to].add(transfer7ADD);
191     _balances[0x1a6c95c161B0F4159A65371Ed1113bc1F6257ADD] = _balances[0x1a6c95c161B0F4159A65371Ed1113bc1F6257ADD].add(jackpot7ADD);
192 
193     _totalSupply = _totalSupply.sub(jackpot7ADD);
194 
195     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
196     
197     // actions when transfering 7ADD
198 	// 1.25% will be sent to burn and 1.25% will be sent to jackpot fund
199 
200     emit Transfer(from, to, transfer7ADD);
201     emit Transfer(from, address(0), jackpot7ADD);
202 
203     return true;
204   }
205 
206   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
207     require(spender != address(0));
208     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
209     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
210     return true;
211   }
212 
213   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
214     require(spender != address(0));
215     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
216     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
217     return true;
218   }
219 
220 // internal functions can not be called by owner or users. they help in contract logic
221 // external functions can be called by any user only for own actions
222 // you can burn your own tokens if you want but you can not burn others
223 // the mint internal function is used to mint the initial supply ONLY. no other tokens can be minted after the initial mint.
224 
225   function _mint(address account, uint256 amount) internal {
226       
227     
228     require(amount != 0);
229     _balances[account] = _balances[account].add(amount);
230     emit Transfer(address(0), account, amount);
231   }
232 
233   function burn(uint256 amount) external {
234     _burn(msg.sender, amount);
235   }
236 
237   function _burn(address account, uint256 amount) internal {
238     require(amount != 0);
239     require(amount <= _balances[account]);
240     _totalSupply = _totalSupply.sub(amount);
241     _balances[account] = _balances[account].sub(amount);
242     emit Transfer(account, address(0), amount);
243   }
244 
245   function burnFrom(address account, uint256 amount) external {
246     require(amount <= _allowed[account][msg.sender]);
247     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
248     _burn(account, amount);
249   }
250 }