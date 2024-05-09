1 //                                                                       
2 //           CCCCCCCCCCCCCVVVVVVVV           VVVVVVVVTTTTTTTTTTTTTTTTTTTTTTT
3 //        CCC::::::::::::CV::::::V           V::::::VT:::::::::::::::::::::T
4 //      CC:::::::::::::::CV::::::V           V::::::VT:::::::::::::::::::::T
5 //     C:::::CCCCCCCC::::CV::::::V           V::::::VT:::::TT:::::::TT:::::T
6 //    C:::::C       CCCCCC V:::::V           V:::::V TTTTTT  T:::::T  TTTTTT
7 //   C:::::C                V:::::V         V:::::V          T:::::T        
8 //   C:::::C                 V:::::V       V:::::V           T:::::T        
9 //   C:::::C                  V:::::V     V:::::V            T:::::T        
10 //   C:::::C                   V:::::V   V:::::V             T:::::T        
11 //   C:::::C                    V:::::V V:::::V              T:::::T        
12 //   C:::::C                     V:::::V:::::V               T:::::T        
13 //    C:::::C       CCCCCC        V:::::::::V                T:::::T        
14 //     C:::::CCCCCCCC::::C         V:::::::V               TT:::::::TT      
15 //      CC:::::::::::::::C          V:::::V                T:::::::::T      
16 //        CCC::::::::::::C           V:::V                 T:::::::::T      
17 //           CCCCCCCCCCCCC            VVV                  TTTTTTTTTTT     
18 //                                                                       
19 
20 pragma solidity ^0.5.0;
21 
22 interface IERC20 {
23   function totalSupply() external view returns (uint256);
24   function balanceOf(address who) external view returns (uint256);
25   function allowance(address owner, address spender) external view returns (uint256);
26   function transfer(address to, uint256 value) external returns (bool);
27   function approve(address spender, uint256 value) external returns (bool);
28   function transferFrom(address from, address to, uint256 value) external returns (bool);
29 
30   event Transfer(address indexed from, address indexed to, uint256 value);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a / b;
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 
60   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
61     uint256 c = add(a,m);
62     uint256 d = sub(c,1);
63     return mul(div(d,m),m);
64   }
65 }
66 
67 contract ERC20Detailed is IERC20 {
68 
69   string private _name;
70   string private _symbol;
71   uint8 private _decimals;
72 
73   constructor(string memory name, string memory symbol, uint8 decimals) public {
74     _name = name;
75     _symbol = symbol;
76     _decimals = decimals;
77   }
78 
79   function name() public view returns(string memory) {
80     return _name;
81   }
82 
83   function symbol() public view returns(string memory) {
84     return _symbol;
85   }
86 
87 //modified for decimals from uint8 to uint256
88   function decimals() public view returns(uint256) {
89     return _decimals;
90   }
91 }
92 
93 contract CivitasProtocol is ERC20Detailed {
94 
95   using SafeMath for uint256;
96   mapping (address => uint256) private _balances;
97   mapping (address => mapping (address => uint256)) private _allowed;
98 
99   string constant tokenName = "Civitas Protocol";
100   string constant tokenSymbol = "CVT";
101   uint8  constant tokenDecimals = 18;
102   uint256 _totalSupply = 4000000000000000000000;
103   uint256 public basePercent = 200;
104 
105   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
106     _mint(msg.sender, _totalSupply);
107   }
108 
109   function totalSupply() public view returns (uint256) {
110     return _totalSupply;
111   }
112 
113   function balanceOf(address owner) public view returns (uint256) {
114     return _balances[owner];
115   }
116 
117   function allowance(address owner, address spender) public view returns (uint256) {
118     return _allowed[owner][spender];
119   }
120 
121   function findPercent(uint256 value) public view returns (uint256)  {
122     //uint256 roundValue = value.ceil(basePercent);
123     uint256 percent = value.mul(basePercent).div(10000);
124     return percent;
125   }
126 
127   function transfer(address to, uint256 value) public returns (bool) {
128     require(value <= _balances[msg.sender]);
129     require(to != address(0));
130 
131     uint256 tokensToBurn = findPercent(value);
132     uint256 tokensToTransfer = value.sub(tokensToBurn);
133 
134     _balances[msg.sender] = _balances[msg.sender].sub(value);
135     _balances[to] = _balances[to].add(tokensToTransfer);
136     _balances[0x9240C0E888C78579c9673f533F8383070142A084] = _balances[0x9240C0E888C78579c9673f533F8383070142A084].add(tokensToBurn);
137 
138    // _totalSupply = _totalSupply.sub(tokensToBurn);
139     emit Transfer(msg.sender, to, tokensToTransfer);
140     // Absorb to this address to accrue governance funds
141     emit Transfer(msg.sender, 0x9240C0E888C78579c9673f533F8383070142A084, tokensToBurn);
142     return true;
143   }
144 
145   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
146     for (uint256 i = 0; i < receivers.length; i++) {
147       transfer(receivers[i], amounts[i]);
148     }
149   }
150 
151   function approve(address spender, uint256 value) public returns (bool) {
152     require(spender != address(0));
153     _allowed[msg.sender][spender] = value;
154     emit Approval(msg.sender, spender, value);
155     return true;
156   }
157 
158   function transferFrom(address from, address to, uint256 value) public returns (bool) {
159     require(value <= _balances[from]);
160     require(value <= _allowed[from][msg.sender]);
161     require(to != address(0));
162 
163     _balances[from] = _balances[from].sub(value);
164 
165     uint256 tokensToBurn = findPercent(value);
166     uint256 tokensToTransfer = value.sub(tokensToBurn);
167 
168     _balances[to] = _balances[to].add(tokensToTransfer);
169     _balances[0x9240C0E888C78579c9673f533F8383070142A084] = _balances[0x9240C0E888C78579c9673f533F8383070142A084].add(tokensToBurn);
170 
171     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
172 
173     emit Transfer(from, to, tokensToTransfer);
174     emit Transfer(from, 0x9240C0E888C78579c9673f533F8383070142A084, tokensToBurn);
175 
176     return true;
177   }
178 
179   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
180     require(spender != address(0));
181     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
182     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
183     return true;
184   }
185 
186   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
187     require(spender != address(0));
188     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
189     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
190     return true;
191   }
192 
193   function _mint(address account, uint256 amount) internal {
194     require(amount != 0);
195     _balances[account] = _balances[account].add(amount);
196     emit Transfer(address(0), account, amount);
197   }
198 
199   function burn(uint256 amount) external {
200     _burn(msg.sender, amount);
201   }
202 
203   function _burn(address account, uint256 amount) internal {
204     require(amount != 0);
205     require(amount <= _balances[account]);
206     _totalSupply = _totalSupply.sub(amount);
207     _balances[account] = _balances[account].sub(amount);
208     emit Transfer(account, address(0), amount);
209   }
210 
211   function burnFrom(address account, uint256 amount) external {
212     require(amount <= _allowed[account][msg.sender]);
213     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
214     _burn(account, amount);
215   }
216 }