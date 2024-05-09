1 /*
2  
3 Website: 
4    -  qqq.finance
5 */
6 
7 pragma solidity ^0.5.16;
8 interface IERC20 {
9     function totalSupply() external view returns (uint);
10     function balanceOf(address account) external view returns (uint);
11     function transfer(address recipient, uint amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint);
13     function approve(address spender, uint amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint value);
16     event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 contract Context {
19     constructor () internal { }
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 }
24 
25 contract ERC20 is Context, IERC20 {
26     using SafeMath for uint;
27     mapping (address => uint) private _balances;
28     mapping (address => mapping (address => uint)) private _allowances;
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
63         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
64         _balances[recipient] = _balances[recipient].add(amount);
65         emit Transfer(sender, recipient, amount);
66     }
67     function _mint(address account, uint amount) internal {
68         require(account != address(0), "ERC20: mint to the zero address");
69         _totalSupply = _totalSupply.add(amount);
70         _balances[account] = _balances[account].add(amount);
71         emit Transfer(address(0), account, amount);
72     }
73     function _burn(address account, uint amount) internal {
74         require(account != address(0), "ERC20: burn from the zero address");
75         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
76         _totalSupply = _totalSupply.sub(amount);
77         emit Transfer(account, address(0), amount);
78     }
79     function _approve(address owner, address spender, uint amount) internal {
80         require(owner != address(0), "ERC20: approve from the zero address");
81         require(spender != address(0), "ERC20: approve to the zero address");
82         _allowances[owner][spender] = amount;
83         emit Approval(owner, spender, amount);
84     }
85 }
86 
87 contract ERC20Detailed is IERC20 {
88     string private _name;
89     string private _symbol;
90     uint8 private _decimals;
91 
92     constructor (string memory name, string memory symbol, uint8 decimals) public {
93         _name = name;
94         _symbol = symbol;
95         _decimals = decimals;
96     }
97     function name() public view returns (string memory) {
98         return _name;
99     }
100     function symbol() public view returns (string memory) {
101         return _symbol;
102     }
103     function decimals() public view returns (uint8) {
104         return _decimals;
105     }
106 }
107 
108 library SafeMath {
109     function add(uint a, uint b) internal pure returns (uint) {
110         uint c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112         return c;
113     }
114     function sub(uint a, uint b) internal pure returns (uint) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
118         require(b <= a, errorMessage);
119         uint c = a - b;
120         return c;
121     }
122     function mul(uint a, uint b) internal pure returns (uint) {
123         if (a == 0) {
124             return 0;
125         }
126         uint c = a * b;
127         require(c / a == b, "SafeMath: multiplication overflow");
128         return c;
129     }
130     function div(uint a, uint b) internal pure returns (uint) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
134         require(b > 0, errorMessage);
135         uint c = a / b;
136         return c;
137     }
138 }
139 
140 contract qqq_farm is ERC20, ERC20Detailed {
141   using SafeMath for uint;
142   uint256 _total = 75000;
143   constructor () public ERC20Detailed("QQQ Farm", "QQQF", 18) {
144       _mint( msg.sender, _total*10**uint(decimals()) );
145   }
146 }