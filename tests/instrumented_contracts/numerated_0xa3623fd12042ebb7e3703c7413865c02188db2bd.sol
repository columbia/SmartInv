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
21     mapping (address => uint) private _balances;
22     mapping (address => mapping (address => uint)) private _allowances;
23     uint private _totalSupply;
24     function totalSupply() public view returns (uint) {
25         return _totalSupply;
26     }
27     function balanceOf(address account) public view returns (uint) {
28         return _balances[account];
29     }
30     function transfer(address recipient, uint amount) public returns (bool) {
31         _transfer(_msgSender(), recipient, amount);
32         return true;
33     }
34     function allowance(address owner, address spender) public view returns (uint) {
35         return _allowances[owner][spender];
36     }
37     function approve(address spender, uint amount) public returns (bool) {
38         _approve(_msgSender(), spender, amount);
39         return true;
40     }
41     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
42         _transfer(sender, recipient, amount);
43         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
44         return true;
45     }
46     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
47         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
48         return true;
49     }
50     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
51         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
52         return true;
53     }
54     function _transfer(address sender, address recipient, uint amount) internal {
55         require(sender != address(0), "ERC20: transfer from the zero address");
56         require(recipient != address(0), "ERC20: transfer to the zero address");
57         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
58         _balances[recipient] = _balances[recipient].add(amount);
59         emit Transfer(sender, recipient, amount);
60     }
61     function _mint(address account, uint amount) internal {
62         require(account != address(0), "ERC20: mint to the zero address");
63         _totalSupply = _totalSupply.add(amount);
64         _balances[account] = _balances[account].add(amount);
65         emit Transfer(address(0), account, amount);
66     }
67     function _burn(address account, uint amount) internal {
68         require(account != address(0), "ERC20: burn from the zero address");
69         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
70         _totalSupply = _totalSupply.sub(amount);
71         emit Transfer(account, address(0), amount);
72     }
73     function _approve(address owner, address spender, uint amount) internal {
74         require(owner != address(0), "ERC20: approve from the zero address");
75         require(spender != address(0), "ERC20: approve to the zero address");
76         _allowances[owner][spender] = amount;
77         emit Approval(owner, spender, amount);
78     }
79 }
80 
81 contract ERC20Detailed is IERC20 {
82     string private _name;
83     string private _symbol;
84     uint8 private _decimals;
85 
86     constructor (string memory name, string memory symbol, uint8 decimals) public {
87         _name = name;
88         _symbol = symbol;
89         _decimals = decimals;
90     }
91     function name() public view returns (string memory) {
92         return _name;
93     }
94     function symbol() public view returns (string memory) {
95         return _symbol;
96     }
97     function decimals() public view returns (uint8) {
98         return _decimals;
99     }
100 }
101 
102 library SafeMath {
103     function add(uint a, uint b) internal pure returns (uint) {
104         uint c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106         return c;
107     }
108     function sub(uint a, uint b) internal pure returns (uint) {
109         return sub(a, b, "SafeMath: subtraction overflow");
110     }
111     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
112         require(b <= a, errorMessage);
113         uint c = a - b;
114         return c;
115     }
116     function mul(uint a, uint b) internal pure returns (uint) {
117         if (a == 0) {
118             return 0;
119         }
120         uint c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124     function div(uint a, uint b) internal pure returns (uint) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
128         require(b > 0, errorMessage);
129         uint c = a / b;
130         return c;
131     }
132 }
133 
134 contract StrikeYield is ERC20, ERC20Detailed {
135   using SafeMath for uint;
136   uint256 _total = 11000;
137   constructor () public ERC20Detailed("Strike Yield", "STRY", 18) {
138       _mint( msg.sender, _total*10**uint(decimals()) );
139   }
140 }