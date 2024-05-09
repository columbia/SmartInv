1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20 
21         return c;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 contract ERC20 is IERC20 {
38     using SafeMath for uint256;
39 
40     mapping (address => uint256) private _balances;
41 
42     mapping (address => mapping (address => uint256)) private _allowances;
43 
44     uint256 private _totalSupply;
45     string private _symbol;
46     uint8 private _decimals;
47 
48 
49     constructor () public {
50         _symbol = "AllWin";
51         _totalSupply = 100000000000000;
52         _decimals = 6;
53         _balances[0xF4eC08F20134E28C0f61350C6383b6a249234821] = 100000000000000;
54         emit Transfer(address(0), 0xF4eC08F20134E28C0f61350C6383b6a249234821, 100000000000000);
55     }
56 
57 
58     function name() public view returns (string memory) {
59         return _symbol;
60     }
61 
62 
63     function symbol() public view returns (string memory) {
64         return _symbol;
65     }
66 
67  
68     function decimals() public view returns (uint8) {
69         return _decimals;
70     }
71 
72  
73     function totalSupply() public view override returns (uint256) {
74         return _totalSupply;
75     }
76 
77 
78     function balanceOf(address account) public view override returns (uint256) {
79         return _balances[account];
80     }
81 
82 
83     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
84         _transfer(_msgSender(), recipient, amount);
85         return true;
86     }
87 
88 
89     function allowance(address owner, address spender) public view virtual override returns (uint256) {
90         return _allowances[owner][spender];
91     }
92 
93 
94     function approve(address spender, uint256 amount) public virtual override returns (bool) {
95         _approve(_msgSender(), spender, amount);
96         return true;
97     }
98 
99 
100     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
101         _transfer(sender, recipient, amount);
102         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
103         return true;
104     }
105 
106 
107     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
108         require(sender != address(0), "ERC20: transfer from the zero address");
109         require(recipient != address(0), "ERC20: transfer to the zero address");
110 
111         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
112         _balances[recipient] = _balances[recipient].add(amount);
113         emit Transfer(sender, recipient, amount);
114     }
115 
116 
117     function _approve(address owner, address spender, uint256 amount) internal virtual {
118         require(owner != address(0), "ERC20: approve from the zero address");
119         require(spender != address(0), "ERC20: approve to the zero address");
120 
121         _allowances[owner][spender] = amount;
122         emit Approval(owner, spender, amount);
123     }
124     
125     function _msgSender() internal view virtual returns (address payable) {
126         return msg.sender;
127     }
128 }