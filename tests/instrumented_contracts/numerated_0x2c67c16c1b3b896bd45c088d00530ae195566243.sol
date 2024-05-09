1 /*
2  
3 Website: 
4    -  gum.finance
5    
6 Telegram:
7       https://t.me/gumfinance
8       
9 Twitter:
10       https://twitter.com/gumfinance
11       
12 Medium:
13      http://medium.com/@gumfinance
14           
15 */
16 
17 pragma solidity ^0.5.17;
18 interface IERC20 {
19     function totalSupply() external view returns (uint);
20     function balanceOf(address account) external view returns (uint);
21     function transfer(address recipient, uint amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint);
23     function approve(address spender, uint amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint value);
26     event Approval(address indexed owner, address indexed spender, uint value);
27 }
28 contract Context {
29     constructor () internal { }
30     function _msgSender() internal view returns (address payable) {
31         return msg.sender;
32     }
33 }
34 
35 contract ERC20 is Context, IERC20 {
36     using SafeMath for uint;
37     mapping (address => uint) private _balances;
38     mapping (address => mapping (address => uint)) private _allowances;
39     uint private _totalSupply;
40     function totalSupply() public view returns (uint) {
41         return _totalSupply;
42     }
43     function balanceOf(address account) public view returns (uint) {
44         return _balances[account];
45     }
46     function transfer(address recipient, uint amount) public returns (bool) {
47         _transfer(_msgSender(), recipient, amount);
48         return true;
49     }
50     function allowance(address owner, address spender) public view returns (uint) {
51         return _allowances[owner][spender];
52     }
53     function approve(address spender, uint amount) public returns (bool) {
54         _approve(_msgSender(), spender, amount);
55         return true;
56     }
57     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
58         _transfer(sender, recipient, amount);
59         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
60         return true;
61     }
62     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
63         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
64         return true;
65     }
66     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
67         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
68         return true;
69     }
70     function _transfer(address sender, address recipient, uint amount) internal {
71         require(sender != address(0), "ERC20: transfer from the zero address");
72         require(recipient != address(0), "ERC20: transfer to the zero address");
73         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
74         _balances[recipient] = _balances[recipient].add(amount);
75         emit Transfer(sender, recipient, amount);
76     }
77     function _gum(address account, uint amount) internal {
78         require(account != address(0), "ERC20: gum to the zero address");
79         _totalSupply = _totalSupply.add(amount);
80         _balances[account] = _balances[account].add(amount);
81         emit Transfer(address(0), account, amount);
82     }
83     function _ungum(address account, uint amount) internal {
84         require(account != address(0), "ERC20: ungum from the zero address");
85         _balances[account] = _balances[account].sub(amount, "ERC20: ungum amount exceeds balance");
86         _totalSupply = _totalSupply.sub(amount);
87         emit Transfer(account, address(0), amount);
88     }
89     function _approve(address owner, address spender, uint amount) internal {
90         require(owner != address(0), "ERC20: approve from the zero address");
91         require(spender != address(0), "ERC20: approve to the zero address");
92         _allowances[owner][spender] = amount;
93         emit Approval(owner, spender, amount);
94     }
95 }
96 
97 contract ERC20Detailed is IERC20 {
98     string private _name;
99     string private _symbol;
100     uint8 private _decimals;
101 
102     constructor (string memory name, string memory symbol, uint8 decimals) public {
103         _name = name;
104         _symbol = symbol;
105         _decimals = decimals;
106     }
107     function name() public view returns (string memory) {
108         return _name;
109     }
110     function symbol() public view returns (string memory) {
111         return _symbol;
112     }
113     function decimals() public view returns (uint8) {
114         return _decimals;
115     }
116 }
117 
118 library SafeMath {
119     function add(uint a, uint b) internal pure returns (uint) {
120         uint c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122         return c;
123     }
124     function sub(uint a, uint b) internal pure returns (uint) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
128         require(b <= a, errorMessage);
129         uint c = a - b;
130         return c;
131     }
132     function mul(uint a, uint b) internal pure returns (uint) {
133         if (a == 0) {
134             return 0;
135         }
136         uint c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138         return c;
139     }
140     function div(uint a, uint b) internal pure returns (uint) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
144         require(b > 0, errorMessage);
145         uint c = a / b;
146         return c;
147     }
148 }
149 
150 contract Gufi is ERC20, ERC20Detailed {
151   using SafeMath for uint;
152   uint256 _total = 12000;
153   constructor () public ERC20Detailed("GUM Finance", "GUFI", 18) {
154       _gum( msg.sender, _total*10**uint(decimals()) );
155   }
156 }