1 pragma solidity ^0.5.0;
2  
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10  
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14  
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24  
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29  
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34  
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40  
41   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
42     uint256 c = add(a,m);
43     uint256 d = sub(c,1);
44     return mul(div(d,m),m);
45   }
46 }
47  
48 contract ERC20Detailed is IERC20 {
49  
50   uint8 private _decimals;
51   string private _name;
52   string private _symbol;
53  
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55    
56    _decimals = decimals;
57    _name = name;
58    _symbol = symbol;
59    
60   }
61  
62   function name() public view returns(string memory) {
63     return _name;
64   }
65  
66   function symbol() public view returns(string memory) {
67     return _symbol;
68   }
69  
70   function decimals() public view returns(uint8) {
71     return _decimals;
72   }
73 }
74  
75 /**end here**/
76  
77 contract Erosion is ERC20Detailed {
78  
79   using SafeMath for uint256;
80   mapping (address => uint256) private _balances;
81   mapping (address => mapping (address => uint256)) private _allowed;
82   string constant tokenName = "Erosion";
83   string constant tokenSymbol = "EROS";
84   uint8  constant tokenDecimals = 18;
85   uint256 _totalSupply = 10000000000000000000000000;
86   address constant drain = 0x3f17f1962B36e491b30A40b2405849e597Ba5FB5;
87  
88  
89  
90  
91   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
92     _mint(msg.sender, _totalSupply);
93   }
94  
95   function totalSupply() public view returns (uint256) {
96     return _totalSupply;
97   }
98  
99   function balanceOf(address owner) public view returns (uint256) {
100     return _balances[owner];
101   }
102  
103   function allowance(address owner, address spender) public view returns (uint256) {
104     return _allowed[owner][spender];
105   }
106  
107   function transfer(address to, uint256 value) public returns (bool) {
108     require(value <= _balances[msg.sender]);
109     require(to != address(0));
110  
111     uint256 erosion;
112  
113     if(value <= 10000){
114         erosion = 0;
115     } else {
116         erosion = value.div(10000);
117         _balances[drain] = _balances[drain].add(erosion);
118     }
119  
120     uint256 tokensToTransfer = value.sub(erosion);
121  
122     _balances[msg.sender] = _balances[msg.sender].sub(value);
123     _balances[to] = _balances[to].add(tokensToTransfer);
124  
125     _totalSupply = _totalSupply.sub(erosion);
126  
127     emit Transfer(msg.sender, to, tokensToTransfer);
128     emit Transfer(msg.sender, drain, erosion);
129     return true;
130   }
131  
132   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
133     for (uint256 i = 0; i < receivers.length; i++) {
134       transfer(receivers[i], amounts[i]);
135     }
136   }
137  
138   function approve(address spender, uint256 value) public returns (bool) {
139     require(spender != address(0));
140     _allowed[msg.sender][spender] = value;
141     emit Approval(msg.sender, spender, value);
142     return true;
143   }
144  
145   function transferFrom(address from, address to, uint256 value) public returns (bool) {
146     require(value <= _balances[from]);
147     require(value <= _allowed[from][msg.sender]);
148     require(to != address(0));
149  
150     _balances[from] = _balances[from].sub(value);
151  
152     uint256 erosion;
153  
154     if(value <= 10000){
155         erosion = 0;
156     } else {
157         erosion = value.div(10000);
158         _balances[drain] = _balances[drain].add(erosion);
159     }
160  
161     uint256 tokensToTransfer = value.sub(erosion);
162  
163     _balances[to] = _balances[to].add(tokensToTransfer);
164     _totalSupply = _totalSupply.sub(erosion);
165  
166     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167  
168     emit Transfer(from, to, tokensToTransfer);
169     emit Transfer(from, drain, erosion);
170  
171     return true;
172   }
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
190     _balances[account] = _balances[account].add(amount);
191    
192     emit Transfer(address(0), account, amount);
193   }
194  
195   function burn(uint256 amount) external {
196     _burn(msg.sender, amount);
197   }
198  
199   function _burn(address account, uint256 amount) internal {
200     require(amount != 0);
201     require(amount <= _balances[account]);
202     _totalSupply = _totalSupply.sub(amount);
203     _balances[account] = _balances[account].sub(amount);
204     emit Transfer(account, address(0), amount);
205   }
206  
207   function burnFrom(address account, uint256 amount) external {
208     require(amount <= _allowed[account][msg.sender]);
209     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
210     _burn(account, amount);
211   }
212 }