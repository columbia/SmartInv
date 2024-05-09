1 pragma solidity ^0.5.0;
2 interface IERC20 {
3     function totalSupply() external view returns (uint256);
4     function balanceOf(address account) external view returns (uint256);
5     function transfer(address recipient, uint256 amount) external returns (bool);
6     function allowance(address owner, address spender) external view returns (uint256);
7     function approve(address spender, uint256 amount) external returns (bool);
8     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 pragma solidity ^0.5.0;
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a, "SafeMath: subtraction overflow");
23         uint256 c = a - b;
24         return c;
25     }
26     
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b > 0, "SafeMath: division by zero");
38         uint256 c = a / b;
39         return c;
40     }
41 
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b != 0, "SafeMath: modulo by zero");
44         return a % b;
45     }
46 }
47 
48 pragma solidity ^0.5.0;
49 
50 contract ERC20 is IERC20 {
51     using SafeMath for uint256;
52     mapping (address => uint256) private _balances;
53     mapping (address => mapping (address => uint256)) private _allowances;
54     uint256 private _totalSupply;
55     function totalSupply() public view returns (uint256) {
56         return _totalSupply;
57     }
58     function balanceOf(address account) public view returns (uint256) {
59         return _balances[account];
60     }
61 
62     function transfer(address recipient, uint256 amount) public returns (bool) {
63         _transfer(msg.sender, recipient, amount);
64         return true;
65     }
66 
67     function allowance(address owner, address spender) public view returns (uint256) {
68         return _allowances[owner][spender];
69     }
70     function approve(address spender, uint256 value) public returns (bool) {
71         _approve(msg.sender, spender, value);
72         return true;
73     }
74     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
75         _transfer(sender, recipient, amount);
76         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
77         return true;
78     }
79 
80     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
81         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
82         return true;
83     }
84 
85     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
86         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
87         return true;
88     }
89     
90     function _transfer(address sender, address recipient, uint256 amount) internal {
91         require(sender != address(0), "ERC20: transfer from the zero address");
92         require(recipient != address(0), "ERC20: transfer to the zero address");
93         _balances[sender] = _balances[sender].sub(amount);
94         _balances[recipient] = _balances[recipient].add(amount);
95         emit Transfer(sender, recipient, amount);
96     }
97 
98     function _initSupply(address account, uint256 amount) internal {
99         require(account != address(0), "ERC20: supply cannot be initiatlized at zero address");
100         _totalSupply = _totalSupply.add(amount);
101         _balances[account] = _balances[account].add(amount);
102         emit Transfer(address(0), account, amount);
103     }
104 
105     function _burn(address account, uint256 value) internal {
106         require(account != address(0), "ERC20: burn from the zero address");
107         _totalSupply = _totalSupply.sub(value);
108         _balances[account] = _balances[account].sub(value);
109         emit Transfer(account, address(0), value);
110     }
111     
112     function _approve(address owner, address spender, uint256 value) internal {
113         require(owner != address(0), "ERC20: approve from the zero address");
114         require(spender != address(0), "ERC20: approve to the zero address");
115         _allowances[owner][spender] = value;
116         emit Approval(owner, spender, value);
117     }
118 
119     function _burnFrom(address account, uint256 amount) internal {
120         _burn(account, amount);
121         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
122     }
123 }
124 
125 pragma solidity ^0.5.0;
126 
127 contract STPAD is ERC20 {
128     string private _name;
129     string private _symbol;
130     uint8 private _decimals;
131     
132     constructor() public payable {
133       _name = 'StarterPad';
134       _symbol = 'STPAD';
135       _decimals = 18;
136       _initSupply(msg.sender, 1000000 * 10 ** uint(decimals()));
137     }
138     
139     function burn(uint256 value) public {
140       _burn(msg.sender, value);
141     }
142 
143     function name() public view returns (string memory) {
144       return _name;
145     }
146 
147     function symbol() public view returns (string memory) {
148       return _symbol;
149     }
150     
151     function decimals() public view returns (uint8) {
152       return _decimals;
153     }
154 }