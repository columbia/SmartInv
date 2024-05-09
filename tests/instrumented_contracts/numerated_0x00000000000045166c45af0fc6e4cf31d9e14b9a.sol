1 pragma solidity ^0.5.16;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address account) external view returns (uint);
6     function transfer(address recipient, uint amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint);
8     function approve(address spender, uint amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 contract Context {
15     constructor () internal { }
16 
17     function _msgSender() internal view returns (address payable) {
18         return msg.sender;
19     }
20 }
21 
22 contract ERC20 is Context, IERC20 {
23     using SafeMath for uint;
24 
25     mapping (address => uint) private _balances;
26 
27     mapping (address => mapping (address => uint)) private _allowances;
28 
29     uint private _totalSupply;
30     function totalSupply() public view returns (uint) {
31         return _totalSupply;
32     }
33     function balanceOf(address account) public view returns (uint) {
34         return _balances[account];
35     }
36     function transfer(address recipient, uint amount) public returns (bool) {
37         _transfer(_msgSender(), recipient, amount);
38         return true;
39     }
40     function allowance(address owner, address spender) public view returns (uint) {
41         return _allowances[owner][spender];
42     }
43     function approve(address spender, uint amount) public returns (bool) {
44         _approve(_msgSender(), spender, amount);
45         return true;
46     }
47     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
48         _transfer(sender, recipient, amount);
49         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
50         return true;
51     }
52     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
53         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
54         return true;
55     }
56     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
57         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
58         return true;
59     }
60     function _transfer(address sender, address recipient, uint amount) internal {
61         require(sender != address(0), "ERC20: transfer from the zero address");
62         require(recipient != address(0), "ERC20: transfer to the zero address");
63 
64         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
65         _balances[recipient] = _balances[recipient].add(amount);
66         emit Transfer(sender, recipient, amount);
67     }
68     function _mint(address account, uint amount) internal {
69         require(account != address(0), "ERC20: mint to the zero address");
70 
71         _totalSupply = _totalSupply.add(amount);
72         _balances[account] = _balances[account].add(amount);
73         emit Transfer(address(0), account, amount);
74     }
75 
76     function _approve(address owner, address spender, uint amount) internal {
77         require(owner != address(0), "ERC20: approve from the zero address");
78         require(spender != address(0), "ERC20: approve to the zero address");
79 
80         _allowances[owner][spender] = amount;
81         emit Approval(owner, spender, amount);
82     }
83 }
84 
85 contract ERC20Detailed is IERC20 {
86     string private _name;
87     string private _symbol;
88     uint8 private _decimals;
89 
90     constructor (string memory name, string memory symbol, uint8 decimals) public {
91         _name = name;
92         _symbol = symbol;
93         _decimals = decimals;
94     }
95     function name() public view returns (string memory) {
96         return _name;
97     }
98     function symbol() public view returns (string memory) {
99         return _symbol;
100     }
101     function decimals() public view returns (uint8) {
102         return _decimals;
103     }
104 }
105 
106 library SafeMath {
107     function add(uint a, uint b) internal pure returns (uint) {
108         uint c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113     function sub(uint a, uint b) internal pure returns (uint) {
114         return sub(a, b, "SafeMath: subtraction overflow");
115     }
116     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
117         require(b <= a, errorMessage);
118         uint c = a - b;
119 
120         return c;
121     }
122     function mul(uint a, uint b) internal pure returns (uint) {
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129 
130         return c;
131     }
132     function div(uint a, uint b) internal pure returns (uint) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
136         // Solidity only automatically asserts when dividing by 0
137         require(b > 0, errorMessage);
138         uint c = a / b;
139 
140         return c;
141     }
142 }
143 
144 library Address {
145     function isContract(address account) internal view returns (bool) {
146         bytes32 codehash;
147         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
148         // solhint-disable-next-line no-inline-assembly
149         assembly { codehash := extcodehash(account) }
150         return (codehash != 0x0 && codehash != accountHash);
151     }
152 }
153 
154 
155 contract BID is ERC20, ERC20Detailed {
156 
157   constructor (address _controller) public ERC20Detailed("TopBidder", "BID", 18) {
158       _mint(_controller, 100000000*1e18);
159   }
160 
161 }