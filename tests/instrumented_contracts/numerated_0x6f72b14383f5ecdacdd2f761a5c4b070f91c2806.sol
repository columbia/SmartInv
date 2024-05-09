1 pragma solidity ^0.5.10;
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
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   function name() public view returns(string memory) {
61     return _name;
62   }
63 
64   function symbol() public view returns(string memory) {
65     return _symbol;
66   }
67 
68   function decimals() public view returns(uint8) {
69     return _decimals;
70   }
71 }
72 contract Ownable {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76     constructor () internal {
77         _owner = msg.sender;
78         emit OwnershipTransferred(address(0), _owner);
79     }
80     function owner() public view returns (address) {
81         return _owner;
82     }
83     modifier onlyOwner() {
84         require(isOwner(), "Ownable: caller is not the owner");
85         _;
86     }
87     function isOwner() public view returns (bool) {
88         return msg.sender == _owner;
89     }
90     function renounceOwnership() public onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94     function transferOwnership(address newOwner) public onlyOwner {
95         _transferOwnership(newOwner);
96     }
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 contract Melt is ERC20Detailed, Ownable {
104 
105   using SafeMath for uint256;
106   mapping (address => uint256) private _balances;
107   mapping (address => mapping (address => uint256)) private _allowed;
108 
109   string constant tokenName = "Melt";
110   string constant tokenSymbol = "MELT";
111   uint8 constant tokenDecimals = 2;
112   uint256 private _totalSupply;
113 
114   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
115     _mint(msg.sender, 1000000 * (10**uint256(tokenDecimals)));
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
130 
131   function transfer(address to, uint256 value) public returns (bool) {
132     require(value <= _balances[msg.sender]);
133     require(to != address(0));
134 
135     uint256 tokensToBurn = value.div(100);
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
148   function approve(address spender, uint256 value) public returns (bool) {
149     require(spender != address(0));
150     _allowed[msg.sender][spender] = value;
151     emit Approval(msg.sender, spender, value);
152     return true;
153   }
154 
155   function transferFrom(address from, address to, uint256 value) public returns (bool) {
156     require(value <= _balances[from]);
157     require(value <= _allowed[from][msg.sender]);
158     require(to != address(0));
159 
160     _balances[from] = _balances[from].sub(value);
161 
162     uint256 tokensToBurn = value.div(100);
163     uint256 tokensToTransfer = value.sub(tokensToBurn);
164 
165     _balances[to] = _balances[to].add(tokensToTransfer);
166     _totalSupply = _totalSupply.sub(tokensToBurn);
167 
168     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
169 
170     emit Transfer(from, to, tokensToTransfer);
171     emit Transfer(from, address(0), tokensToBurn);
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
190     function _mint(address account, uint256 amount) internal {
191         require(account != address(0), "ERC20: mint to the zero address");
192         _totalSupply = _totalSupply.add(amount);
193         _balances[account] = _balances[account].add(amount);
194         emit Transfer(address(0), account, amount);
195     }
196 
197   function burn(uint256 amount) external {
198     _burn(msg.sender, amount);
199   }
200 
201   function _burn(address account, uint256 amount) internal {
202     require(amount != 0);
203     require(amount <= _balances[account]);
204     _totalSupply = _totalSupply.sub(amount);
205     _balances[account] = _balances[account].sub(amount);
206     emit Transfer(account, address(0), amount);
207   }
208 
209   function burnFrom(address account, uint256 amount) external {
210     require(amount <= _allowed[account][msg.sender]);
211     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
212     _burn(account, amount);
213   }
214 
215   function multiTransfer(address[] memory accounts, uint256[] memory balances) public returns (bool) {
216     require(accounts.length == balances.length, "multiTransfer: accounts and balances should have same lenght");
217     for (uint256 i = 0; i < accounts.length; i++) {
218        transfer(accounts[i], balances[i]);
219     }
220   }
221   
222 }