1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         assert(c >= a);
7         return c;
8     }
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b > 0);
26         uint256 c = a / b;
27         assert(a == b * c + a % b);
28         return a / b;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 interface IERC20{
38     function name() external view returns (string memory);
39     function symbol() external view returns (string memory);
40     function decimals() external view returns (uint8);
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address owner) external view returns (uint256);
43     function transfer(address to, uint256 value) external returns (bool);
44     function transferFrom(address from, address to, uint256 value) external returns (bool);
45     function approve(address spender, uint256 value) external returns (bool);
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 contract Ownable {
53     address internal _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor () internal {
58         _owner = msg.sender;
59         emit OwnershipTransferred(address(0), _owner);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(msg.sender == _owner);
68         _;
69     }
70 
71     function transferOwnership(address newOwner) external onlyOwner {
72         require(newOwner != address(0));
73         _owner = newOwner;
74         emit OwnershipTransferred(_owner, newOwner);
75     }
76 
77     function rescueTokens(address tokenAddress, address receiver, uint256 amount) external onlyOwner {
78         IERC20 _token = IERC20(tokenAddress);
79         require(receiver != address(0));
80 
81         uint256 balance = _token.balanceOf(address(this));
82 
83         require(balance >= amount);
84 
85         assert(_token.transfer(receiver, amount));
86     }
87 }
88 
89 contract HtcToken is Ownable, IERC20 {
90     using SafeMath for uint256;
91 
92     string private  _name     = "HTC Token";
93     string private  _symbol   = "HTC";
94     uint8 private   _decimals = 3;              // 3 decimals
95     uint256 private _cap      = 940000000000;   // 0.94 billion cap, that is 940000000.000
96     uint256 private _totalSupply;
97 
98     mapping (address => bool) private _minter;
99     event Mint(address indexed to, uint256 value);
100     event MinterChanged(address account, bool state);
101 
102     mapping (address => uint256) private _balances;
103     mapping (address => mapping (address => uint256)) private _allowed;
104 
105     event Donate(address indexed account, uint256 amount);
106 
107     constructor() public {
108         _minter[msg.sender] = true;
109     }
110 
111     function () external payable {
112         emit Donate(msg.sender, msg.value);
113     }
114 
115     function name() public view returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public view returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public view returns (uint8) {
124         return _decimals;
125     }
126 
127     function cap() public view returns (uint256) {
128         return _cap;
129     }
130 
131     function totalSupply() public view returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address owner) public view returns (uint256) {
136         return _balances[owner];
137     }
138 
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowed[owner][spender];
141     }
142 
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     function approve(address spender, uint256 value) public returns (bool) {
149         _approve(msg.sender, spender, value);
150         return true;
151     }
152 
153     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
154         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
155         return true;
156     }
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
159         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
160         return true;
161     }
162 
163     function transferFrom(address from, address to, uint256 value) public returns (bool) {
164         require(_allowed[from][msg.sender] >= value);
165         _transfer(from, to, value);
166         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
167         return true;
168     }
169 
170     function _transfer(address from, address to, uint256 value) internal {
171         require(to != address(0));
172 
173         _balances[from] = _balances[from].sub(value);
174         _balances[to]   = _balances[to].add(value);
175         emit Transfer(from, to, value);
176     }
177 
178     function _approve(address owner, address spender, uint256 value) internal {
179         require(owner   != address(0));
180         require(spender != address(0));
181 
182         _allowed[owner][spender] = value;
183         emit Approval(owner, spender, value);
184     }
185 
186     modifier onlyMinter() {
187         require(_minter[msg.sender]);
188         _;
189     }
190 
191     function isMinter(address account) public view returns (bool) {
192         return _minter[account];
193     }
194 
195     function setMinterState(address account, bool state) external onlyOwner {
196         _minter[account] = state;
197         emit MinterChanged(account, state);
198     }
199 
200     function mint(address to, uint256 value) public onlyMinter returns (bool) {
201         _mint(to, value);
202         return true;
203     }
204 
205     function _mint(address account, uint256 value) internal {
206         require(_totalSupply.add(value) <= _cap);
207         require(account != address(0));
208 
209         _totalSupply       = _totalSupply.add(value);
210         _balances[account] = _balances[account].add(value);
211 
212         emit Mint(account, value);
213         emit Transfer(address(0), account, value);
214     }
215 }