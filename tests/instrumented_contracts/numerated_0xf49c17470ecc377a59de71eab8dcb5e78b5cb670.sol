1 /**	 I am so confused
2      if the real monster is me
3      or what's within me
4 */
5 
6 pragma solidity ^0.5.0;
7 
8 	interface IERC20 {
9 	  function totalSupply() external view returns (uint256);
10 	  function balanceOf(address who) external view returns (uint256);
11 	  function allowance(address owner, address spender) external view returns (uint256);
12 	  function transfer(address to, uint256 value) external returns (bool);
13 	  function approve(address spender, uint256 value) external returns (bool);
14 	  function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16 	  event Transfer(address indexed from, address indexed to, uint256 value);
17 	  event Approval(address indexed owner, address indexed spender, uint256 value);
18 	}
19 
20 	library SafeMath {
21 	  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22 	    if (a == 0) {
23 	      return 0;
24 	    }
25 	    uint256 c = a * b;
26 	    assert(c / a == b);
27 	    return c;
28 	  }
29 
30 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
31 	    uint256 c = a / b;
32 	    return c;
33 	  }
34 
35 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 	    assert(b <= a);
37 	    return a - b;
38 	  }
39 
40 	  function add(uint256 a, uint256 b) internal pure returns (uint256) {
41 	    uint256 c = a + b;
42 	    assert(c >= a);
43 	    return c;
44 	  }
45 
46 	  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
47 	    uint256 c = add(a,m);
48 	    uint256 d = sub(c,1);
49 	    return mul(div(d,m),m);
50 	  }
51 	}
52 
53 	contract ERC20Detailed is IERC20 {
54 
55 	  string private _name;
56 	  string private _symbol;
57 	  uint8 private _decimals;
58 
59 	  constructor(string memory name, string memory symbol, uint8 decimals) public {
60 	    _name = name;
61 	    _symbol = symbol;
62 	    _decimals = decimals;
63 	  }
64 
65 	  function name() public view returns(string memory) {
66 	    return _name;
67 	  }
68 
69 	  function symbol() public view returns(string memory) {
70 	    return _symbol;
71 	  }
72 
73 	  function decimals() public view returns(uint8) {
74 	    return _decimals;
75 	  }
76 	}
77 
78 	contract Seppuku is ERC20Detailed {
79 
80 	  using SafeMath for uint256;
81 	  mapping (address => uint256) private _balances;
82 	  mapping (address => mapping (address => uint256)) private _allowed;
83 
84 	  string constant tokenName = "Seppuku Token";
85 	  string constant tokenSymbol = "Seppuku!";
86 	  uint8  constant tokenDecimals = 18;
87 	  uint256 _totalSupply = 6000000000e18;
88 	  uint256 public basePercent = 899;
89 
90 	  constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
91 	    _mint(msg.sender, _totalSupply);
92 	  }
93 
94 	  function totalSupply() public view returns (uint256) {
95 	    return _totalSupply;
96 	  }
97 
98 	  function balanceOf(address owner) public view returns (uint256) {
99 	    return _balances[owner];
100 	  }
101 
102 	  function allowance(address owner, address spender) public view returns (uint256) {
103 	    return _allowed[owner][spender];
104 	  }
105 
106 	  function findNinetyPercent(uint256 value) public view returns (uint256)  {
107 	    uint256 roundValue = value.ceil(basePercent);
108 	    uint256 tenPercent = roundValue.mul(basePercent).div(1000);
109 	    return tenPercent;
110 	  }
111 
112 	  function transfer(address to, uint256 value) public returns (bool) {
113 	    require(value <= _balances[msg.sender]);
114 	    require(to != address(0));
115 
116 	    uint256 tokensToBurn = findNinetyPercent(value);
117 	    uint256 tokensToTransfer = value.sub(tokensToBurn);
118 
119 	    _balances[msg.sender] = _balances[msg.sender].sub(value);
120 	    _balances[to] = _balances[to].add(tokensToTransfer);
121 
122 	    _totalSupply = _totalSupply.sub(tokensToBurn);
123 
124 	    emit Transfer(msg.sender, to, tokensToTransfer);
125 	    emit Transfer(msg.sender, address(0), tokensToBurn);
126 	    return true;
127 	  }
128 
129 	  function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
130 	    for (uint256 i = 0; i < receivers.length; i++) {
131 	      transfer(receivers[i], amounts[i]);
132 	    }
133 	  }
134 
135 	  function approve(address spender, uint256 value) public returns (bool) {
136 	    require(spender != address(0));
137 	    _allowed[msg.sender][spender] = value;
138 	    emit Approval(msg.sender, spender, value);
139 	    return true;
140 	  }
141 
142 	  function transferFrom(address from, address to, uint256 value) public returns (bool) {
143 	    require(value <= _balances[from]);
144 	    require(value <= _allowed[from][msg.sender]);
145 	    require(to != address(0));
146 
147 	    _balances[from] = _balances[from].sub(value);
148 
149 	    uint256 tokensToBurn = findNinetyPercent(value);
150 	    uint256 tokensToTransfer = value.sub(tokensToBurn);
151 
152 	    _balances[to] = _balances[to].add(tokensToTransfer);
153 	    _totalSupply = _totalSupply.sub(tokensToBurn);
154 
155 	    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
156 
157 	    emit Transfer(from, to, tokensToTransfer);
158 	    emit Transfer(from, address(0), tokensToBurn);
159 
160 	    return true;
161 	  }
162 
163 	  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
164 	    require(spender != address(0));
165 	    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
166 	    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
167 	    return true;
168 	  }
169 
170 	  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
171 	    require(spender != address(0));
172 	    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
173 	    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
174 	    return true;
175 	  }
176 
177 	  function _mint(address account, uint256 amount) internal {
178 	    require(amount != 0);
179 	    _balances[account] = _balances[account].add(amount);
180 	    emit Transfer(address(0), account, amount);
181 	  }
182 
183 	  function burn(uint256 amount) external {
184 	    _burn(msg.sender, amount);
185 	  }
186 
187 	  function _burn(address account, uint256 amount) internal {
188 	    require(amount != 0);
189 	    require(amount <= _balances[account]);
190 	    _totalSupply = _totalSupply.sub(amount);
191 	    _balances[account] = _balances[account].sub(amount);
192 	    emit Transfer(account, address(0), amount);
193 	  }
194 
195 	  function burnFrom(address account, uint256 amount) external {
196 	    require(amount <= _allowed[account][msg.sender]);
197 	    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
198 	    _burn(account, amount);
199 	  }
200 	}