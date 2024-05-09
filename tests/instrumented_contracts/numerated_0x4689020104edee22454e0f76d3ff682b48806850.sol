1 pragma solidity ^0.5.0;
2 
3 
4 
5 /**
6  * @title MoonFuel
7  * Function 5% burn on transfer. At 50% total supply, staking will be unlocked. New ways of burning will be implemented
8  * 
9  * Created by Rusty Shackleford
10  * Phase 1 in the Moonbois Crypto Story and game
11  */
12  
13 
14 interface IERC20 {
15   function totalSupply() external view returns (uint256);
16   function balanceOf(address who) external view returns (uint256);
17   function allowance(address owner, address spender) external view returns (uint256);
18   function transfer(address to, uint256 value) external returns (bool);
19   function approve(address spender, uint256 value) external returns (bool);
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   event Transfer(address indexed from, address indexed to, uint256 value);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a / b;
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 
52   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
53     uint256 c = add(a,m);
54     uint256 d = sub(c,1);
55     return mul(div(d,m),m);
56   }
57 }
58 
59 contract ERC20Detailed is IERC20 {
60 
61   uint8 public _Tokendecimals;
62   string public _Tokenname;
63   string public _Tokensymbol;
64 
65   constructor(string memory name, string memory symbol, uint8 decimals) public {
66    
67     _Tokendecimals = decimals;
68     _Tokenname = name;
69     _Tokensymbol = symbol;
70     
71   }
72 
73   function name() public view returns(string memory) {
74     return _Tokenname;
75   }
76 
77   function symbol() public view returns(string memory) {
78     return _Tokensymbol;
79   }
80 
81   function decimals() public view returns(uint8) {
82     return _Tokendecimals;
83   }
84 }
85 
86 /**end here**/
87 
88 contract MoonFuel is ERC20Detailed {
89 
90   using SafeMath for uint256;
91   mapping (address => uint256) public _MoonFuelTokenBalances;
92   mapping (address => mapping (address => uint256)) public _allowed;
93   string constant tokenName = "MoonFuel";
94   string constant tokenSymbol = "MOONFUEL";
95   uint8  constant tokenDecimals = 18;
96   uint256 _totalSupply = 1000000000000000000000;
97   uint256 _MoonFuelTokenBlasted = 0;
98   
99  
100   
101 
102   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
103     _mint(msg.sender, _totalSupply);
104   }
105 
106   function totalSupply() public view returns (uint256) {
107     return _totalSupply;
108   }
109 
110   function balanceOf(address owner) public view returns (uint256) {
111     return _MoonFuelTokenBalances[owner];
112   }
113 
114   function allowance(address owner, address spender) public view returns (uint256) {
115     return _allowed[owner][spender];
116   }
117 
118 
119 
120   function transfer(address to, uint256 value) public returns (bool) {
121     require(value <= _MoonFuelTokenBalances[msg.sender]);
122     require(to != address(0));
123 
124     uint256 MoonFuelBlasted = value.div(20);
125     uint256 tokensToTransfer = value.sub(MoonFuelBlasted);
126 
127     _MoonFuelTokenBalances[msg.sender] = _MoonFuelTokenBalances[msg.sender].sub(value);
128     _MoonFuelTokenBalances[to] = _MoonFuelTokenBalances[to].add(tokensToTransfer);
129 
130     _totalSupply = _totalSupply.sub(MoonFuelBlasted);
131     _MoonFuelTokenBlasted = _MoonFuelTokenBlasted.add(MoonFuelBlasted);
132 
133     emit Transfer(msg.sender, to, tokensToTransfer);
134     emit Transfer(msg.sender, address(0), MoonFuelBlasted);
135     return true;
136   }
137 
138   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
139     for (uint256 i = 0; i < receivers.length; i++) {
140       transfer(receivers[i], amounts[i]);
141     }
142   }
143 
144   function approve(address spender, uint256 value) public returns (bool) {
145     require(spender != address(0));
146     _allowed[msg.sender][spender] = value;
147     emit Approval(msg.sender, spender, value);
148     return true;
149   }
150 
151   function transferFrom(address from, address to, uint256 value) public returns (bool) {
152     require(value <= _MoonFuelTokenBalances[from]);
153     require(value <= _allowed[from][msg.sender]);
154     require(to != address(0));
155 
156     _MoonFuelTokenBalances[from] = _MoonFuelTokenBalances[from].sub(value);
157 
158     uint256 MoonFuelBlasted = value.div(20);
159     uint256 tokensToTransfer = value.sub(MoonFuelBlasted);
160 
161     _MoonFuelTokenBalances[to] = _MoonFuelTokenBalances[to].add(tokensToTransfer);
162     _totalSupply = _totalSupply.sub(MoonFuelBlasted);
163     _MoonFuelTokenBlasted = _MoonFuelTokenBlasted.add(MoonFuelBlasted);
164 
165     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
166   
167     emit Transfer(from, to, tokensToTransfer);
168     emit Transfer(from, address(0), MoonFuelBlasted);
169 
170     return true;
171   }
172   
173 
174   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
175     require(spender != address(0));
176     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
177     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178     return true;
179   }
180 
181   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
182     require(spender != address(0));
183     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
184     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
185     return true;
186   }
187 
188   function _mint(address account, uint256 amount) internal {
189     require(amount != 0);
190     _MoonFuelTokenBalances[account] = _MoonFuelTokenBalances[account].add(amount);
191     emit Transfer(address(0), account, amount);
192   }
193   
194 
195 
196   function getBurned() public view returns(uint){
197   return _MoonFuelTokenBlasted;
198 }
199 
200  
201 }