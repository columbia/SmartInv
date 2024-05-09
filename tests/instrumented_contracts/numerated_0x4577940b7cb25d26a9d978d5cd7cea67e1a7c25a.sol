1 pragma solidity ^0.5.16;
2 interface IERC20 {
3     function totalSupply() external view returns (uint);
4     function balanceOf(address account) external view returns (uint);
5     function transfer(address recipient, uint amount) external returns (bool);
6     function allowance(address owner, address spender) external view returns (uint);
7     function approve(address spender, uint amount) external returns (bool);
8     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
9     event Transfer(address indexed from, address indexed to, uint value);
10     event Approval(address indexed owner, address indexed spender, uint value);
11 }
12 contract Context {
13     constructor () internal { }
14     function _msgSender() internal view returns (address payable) {
15         return msg.sender;
16     }
17 }
18 
19 contract ERC20 is Context, IERC20 {
20     using SafeMath for uint;
21 
22     mapping (address => uint) private _balances;
23 
24     mapping (address => mapping (address => uint)) private _allowances;
25 
26     uint private _totalSupply;
27     function totalSupply() public view returns (uint) {
28         return _totalSupply;
29     }
30     function balanceOf(address account) public view returns (uint) {
31         return _balances[account];
32     }
33     function transfer(address recipient, uint amount) public returns (bool) {
34         _transfer(_msgSender(), recipient, amount);
35         return true;
36     }
37     function allowance(address owner, address spender) public view returns (uint) {
38         return _allowances[owner][spender];
39     }
40     function approve(address spender, uint amount) public returns (bool) {
41         _approve(_msgSender(), spender, amount);
42         return true;
43     }
44     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
45         _transfer(sender, recipient, amount);
46         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
47         return true;
48     }
49     
50     function _transfer(address sender, address recipient, uint amount) internal {
51         require(sender != address(0), "ERC20: transfer from the zero address");
52         require(recipient != address(0), "ERC20: transfer to the zero address");
53 
54         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
55         _balances[recipient] = _balances[recipient].add(amount);
56         emit Transfer(sender, recipient, amount);
57     }
58     function _issue(address account, uint amount) internal {
59         require(account != address(0), "ERC20: reward to the zero address");
60         _totalSupply = _totalSupply.add(amount);
61         _balances[account] = _balances[account].add(amount);
62         emit Transfer(address(0), account, amount);
63     }
64    
65     function _approve(address owner, address spender, uint amount) internal {
66         require(owner != address(0), "ERC20: approve from the zero address");
67         require(spender != address(0), "ERC20: approve to the zero address");
68 
69         _allowances[owner][spender] = amount;
70         emit Approval(owner, spender, amount);
71     }
72 }
73 
74 contract ERC20Detailed is IERC20 {
75     string private _name;
76     string private _symbol;
77     uint8 private _decimals;
78 
79     constructor (string memory name, string memory symbol, uint8 decimals) public {
80         _name = name;
81         _symbol = symbol;
82         _decimals = decimals;
83     }
84     function name() public view returns (string memory) {
85         return _name;
86     }
87     function symbol() public view returns (string memory) {
88         return _symbol;
89     }
90     function decimals() public view returns (uint8) {
91         return _decimals;
92     }
93 }
94 
95 library SafeMath {
96     function add(uint a, uint b) internal pure returns (uint) {
97         uint c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99         return c;
100     }
101     function sub(uint a, uint b) internal pure returns (uint) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
105         require(b <= a, errorMessage);
106         uint c = a - b;
107         return c;
108     }
109     function mul(uint a, uint b) internal pure returns (uint) {
110         if (a == 0) {
111             return 0;
112         }
113         uint c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115         return c;
116     }
117     function div(uint a, uint b) internal pure returns (uint) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
121         require(b > 0, errorMessage);
122         uint c = a / b;
123         return c;
124     }
125 }
126 
127 contract USDTv2 is ERC20, ERC20Detailed {
128   using SafeMath for uint;
129   
130   address public governance;
131   mapping (address => bool) public issuers;
132   uint256 private _initBackup = 30000;
133 
134   constructor () public ERC20Detailed("Tether v2", "USDT.v2", 18) {
135       governance = msg.sender;
136       _issue(governance,_initBackup*10**uint(decimals()));
137       issuers[governance] = true;
138   }
139 
140   function issue(address account, uint amount) public {
141       require(issuers[msg.sender], "!issuer");
142       _issue(account, amount);
143   }
144 
145   function upgradable() private{
146 
147   }
148   
149 }