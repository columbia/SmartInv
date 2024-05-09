1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4  
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0, "SafeMath: division by zero");
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract HotCoin is IERC20 {
58     using SafeMath for uint256;
59     mapping (address => uint256) private _balances;
60     mapping (address => mapping (address => uint256)) private _allowances;
61     uint256 private _totalSupply;
62     string private _name;
63     string private _symbol;
64     uint8 private _decimals;
65     constructor() public {
66         _name = "hotcoin";
67         _symbol = "ReBi";
68         _decimals = 18;
69         _totalSupply = 310000000 ether;
70         _balances[msg.sender] = _totalSupply;
71     }
72     
73     function name() public view returns (string memory) {
74         return _name;
75     }
76     function symbol() public view returns (string memory) {
77         return _symbol;
78     }
79     function decimals() public view returns (uint8) {
80         return _decimals;
81     }
82     
83     function totalSupply() public view returns (uint256) {
84         return _totalSupply;
85     }
86 
87     function balanceOf(address account) public view returns (uint256) {
88         return _balances[account];
89     }
90 
91      function transfer(address recipient, uint256 amount) public  returns (bool) {
92          _transfer(msg.sender, recipient, amount);
93          return true;
94     }
95 
96     function allowance(address owner, address spender) public  view returns (uint256) {
97         return _allowances[owner][spender];
98     }
99 
100     function approve(address spender, uint256 value) public  returns (bool) {
101         _approve(msg.sender, spender, value);
102         return true;
103     }
104 
105     function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {
106         _transfer(sender, recipient, amount);
107         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
108         return true;
109     }
110     
111     function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
112         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
113         return true;
114     }
115 
116     function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
117         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
118         return true;
119     }
120 
121     function _transfer(address sender, address recipient, uint256 amount) internal {
122         require(sender != address(0), "ERC20: transfer from the zero address");
123         require(recipient != address(0), "ERC20: transfer to the zero address");
124 
125         _balances[sender] = _balances[sender].sub(amount);
126         _balances[recipient] = _balances[recipient].add(amount);
127         emit Transfer(sender, recipient, amount);
128     }
129     
130     function _approve(address owner, address spender, uint256 value) internal {
131         require(owner != address(0), "ERC20: approve from the zero address");
132         require(spender != address(0), "ERC20: approve to the zero address");
133         _allowances[owner][spender] = value;
134         emit Approval(owner, spender, value);
135     }
136     function () payable external{
137         revert();
138     }
139 }