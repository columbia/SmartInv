1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-09
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 // ----------------------------------------------------------------------------
8 // 'ESTATERO' Token Contract
9 //
10 // Deployed to : 0x506f25E2572574108927feDfd2949640A079881B
11 // Symbol      : HNG
12 // Name        : ESTATERO
13 // Total supply: 10000000000000000000
14 // Decimals    : 8
15 //
16 // Adapted by Pedro Enrique Bravo. IT Consulting, March 2020.
17 // To (HNG) Hombres de Negocios Global, C.A.
18 // v0.5.1+commit.c8a2cb62
19 
20 // 
21 // EL TOKEN ESTATERO (HNG) está desarrollado para la comunidad de emprendedores, comerciantes, 
22 // empresarios y usuarios que tengan la visión de Tokenizar la Economía Venezolana a través del
23 // intercambio de las CriptoMonedas y los TOKENs ESTATEROS (HNG). Utilizando el Medio de Pago Digital 
24 // creado por un Venezolano y profesionales de HNG para los Venezolanos y de Venezuela para el Mundo.
25 // 
26 // Hacia la Tokenización de la Economía de Venezuela y del Mundo.
27 //---------------------------------------------------------------------------
28 
29 
30 
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
101 contract ESTATERO is ERC20Detailed {
102 
103   using SafeMath for uint256;
104   mapping (address => uint256) private _balances;
105   mapping (address => mapping (address => uint256)) private _allowed;
106 
107   string constant tokenName = "ESTATERO";
108   string constant tokenSymbol = "HNG";
109   uint8  constant tokenDecimals = 8;
110   uint256 _totalSupply = 10000000000000000000;
111 
112   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
113     _mint(msg.sender, _totalSupply);
114   }
115 
116   function totalSupply() public view returns (uint256) {
117     return _totalSupply;
118   }
119 
120   function balanceOf(address owner) public view returns (uint256) {
121     return _balances[owner];
122   }
123 
124   function allowance(address owner, address spender) public view returns (uint256) {
125     return _allowed[owner][spender];
126   }
127 
128 
129   function transfer(address to, uint256 value) public returns (bool) {
130 
131     require(value <= _balances[msg.sender]);
132     require(to != address(0));
133     
134     uint256 tokensToTransfer = value;
135 
136     _balances[msg.sender] = _balances[msg.sender].sub(value);
137     _balances[to] = _balances[to].add(tokensToTransfer);
138 
139     emit Transfer(msg.sender, to, tokensToTransfer);
140     
141     return true;
142   }
143 
144   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
145     for (uint256 i = 0; i < receivers.length; i++) {
146       transfer(receivers[i], amounts[i]);
147     }
148   }
149 
150   function approve(address spender, uint256 value) public returns (bool) {
151     require(spender != address(0));
152     _allowed[msg.sender][spender] = value;
153     emit Approval(msg.sender, spender, value);
154     return true;
155   }
156 
157   function transferFrom(address from, address to, uint256 value) public returns (bool) {
158 
159     require(value <= _balances[from]);
160     require(value <= _allowed[from][msg.sender]);
161     require(to != address(0));
162 
163     _balances[from] = _balances[from].sub(value);
164 
165     uint256 tokensToTransfer = value;
166 
167     _balances[to] = _balances[to].add(tokensToTransfer);
168 
169     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
170 
171     emit Transfer(from, to, tokensToTransfer);
172 
173     return true;
174   }
175 
176   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
177     require(spender != address(0));
178     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
179     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
180     return true;
181   }
182 
183   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
184     require(spender != address(0));
185     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
186     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
187     return true;
188   }
189 
190   function _mint(address account, uint256 amount) internal {
191     require(amount != 0);
192     _balances[account] = _balances[account].add(amount);
193     emit Transfer(address(0), account, amount);
194   }
195 
196   function burn(uint256 amount) external {
197     _burn(msg.sender, amount);
198   }
199 
200   function _burn(address account, uint256 amount) internal {
201     require(amount != 0);
202     require(amount <= _balances[account]);
203     _totalSupply = _totalSupply.sub(amount);
204     _balances[account] = _balances[account].sub(amount);
205     emit Transfer(account, address(0), amount);
206   }
207 
208   function burnFrom(address account, uint256 amount) external {
209     require(amount <= _allowed[account][msg.sender]);
210     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
211     _burn(account, amount);
212   }
213 }