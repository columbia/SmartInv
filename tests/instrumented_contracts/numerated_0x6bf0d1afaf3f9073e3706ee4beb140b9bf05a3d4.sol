1 /**
2  *Submitted for verification at Etherscan.io on 2019-02-11
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9   function balanceOf(address who) external view returns (uint256);
10   function allowance(address owner, address spender) external view returns (uint256);
11   function transfer(address to, uint256 value) external returns (bool);
12   function approve(address spender, uint256 value) external returns (bool);
13   function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
46     uint256 c = add(a,m);
47     uint256 d = sub(c,1);
48     return mul(div(d,m),m);
49   }
50 }
51 
52 contract ERC20Detailed is IERC20 {
53 
54   string private _name;
55   string private _symbol;
56   uint8 private _decimals;
57 
58   constructor(string memory name, string memory symbol, uint8 decimals) public {
59     _name = name;
60     _symbol = symbol;
61     _decimals = decimals;
62   }
63 
64   function name() public view returns(string memory) {
65     return _name;
66   }
67 
68   function symbol() public view returns(string memory) {
69     return _symbol;
70   }
71 
72   function decimals() public view returns(uint8) {
73     return _decimals;
74   }
75 }
76 
77 contract Owned {
78     address payable public owner;
79 
80     event OwnershipTransferred(address indexed _from, address indexed _to);
81 
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address payable _newOwner) public onlyOwner {
92         owner = _newOwner;
93     }
94 }
95 
96 
97 contract TransBurn is ERC20Detailed, Owned{
98 
99   using SafeMath for uint256;
100   mapping (address => uint256) private _balances;
101   mapping (address => mapping (address => uint256)) private _allowed;
102 
103   string constant tokenName = "TransBurn";
104   string constant tokenSymbol = "TRB ";
105   uint8  constant tokenDecimals = 0;
106   uint256 _totalSupply = 1000000;
107   uint256 public basePercent = 100;
108 
109   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
110     _mint( 0x744B9203F27af29F3174C90e1b7d87856cBBEd84, _totalSupply);
111   }
112 
113   function totalSupply() public view returns (uint256) {
114     return _totalSupply;
115   }
116 
117   function balanceOf(address owner) public view returns (uint256) {
118     return _balances[owner];
119   }
120 
121   function allowance(address owner, address spender) public view returns (uint256) {
122     return _allowed[owner][spender];
123   }
124 
125   function findOnePercent(uint256 value) public view returns (uint256)  {
126     uint256 roundValue = value.ceil(basePercent);
127     uint256 onePercent = roundValue.mul(basePercent).div(10000);
128     return onePercent;
129   }
130 
131   function transfer(address to, uint256 value) public returns (bool) {
132     require(value <= _balances[msg.sender]);
133     require(to != address(0));
134 
135     uint256 tokensToBurn = findOnePercent(value);
136     uint256 tokensToTransfer = value.sub(tokensToBurn);
137 
138     _balances[msg.sender] = _balances[msg.sender].sub(value);
139     _balances[to] = _balances[to].add(tokensToTransfer);
140 
141     _totalSupply = _totalSupply.sub(tokensToBurn);
142 
143     emit Transfer(msg.sender, to, tokensToTransfer);
144     emit Transfer(msg.sender, address(0), tokensToBurn);
145     return true;
146   }
147 
148   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
149     for (uint256 i = 0; i < receivers.length; i++) {
150       transfer(receivers[i], amounts[i]);
151     }
152   }
153 
154   function approve(address spender, uint256 value) public returns (bool) {
155     require(spender != address(0));
156     _allowed[msg.sender][spender] = value;
157     emit Approval(msg.sender, spender, value);
158     return true;
159   }
160 
161   function transferFrom(address from, address to, uint256 value) public returns (bool) {
162     require(value <= _balances[from]);
163     require(value <= _allowed[from][msg.sender]);
164     require(to != address(0));
165 
166     _balances[from] = _balances[from].sub(value);
167 
168     uint256 tokensToBurn = findOnePercent(value);
169     uint256 tokensToTransfer = value.sub(tokensToBurn);
170 
171     _balances[to] = _balances[to].add(tokensToTransfer);
172     _totalSupply = _totalSupply.sub(tokensToBurn);
173 
174     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
175 
176     emit Transfer(from, to, tokensToTransfer);
177     emit Transfer(from, address(0), tokensToBurn);
178 
179     return true;
180   }
181 
182   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
183     require(spender != address(0));
184     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
185     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
186     return true;
187   }
188 
189   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
190     require(spender != address(0));
191     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
192     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
193     return true;
194   }
195 
196   function _mint(address account, uint256 amount) internal {
197     require(amount != 0);
198     _balances[account] = _balances[account].add(amount);
199     emit Transfer(address(0), account, amount);
200   }
201 
202   function burn(uint256 amount) external {
203     _burn(msg.sender, amount);
204   }
205 
206   function _burn(address account, uint256 amount) internal {
207     require(amount != 0);
208     require(amount <= _balances[account]);
209     _totalSupply = _totalSupply.sub(amount);
210     _balances[account] = _balances[account].sub(amount);
211     emit Transfer(account, address(0), amount);
212   }
213 
214   function burnFrom(address account, uint256 amount) external {
215     require(amount <= _allowed[account][msg.sender]);
216     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
217     _burn(account, amount);
218   }
219 }