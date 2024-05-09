1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16 
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
18         require(b <= a, errorMessage);
19         uint256 c = a - b;
20 
21         return c;
22     }
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25   
26         if (a == 0) {
27             return 0;
28         }
29 
30         uint256 c = a * b;
31         require(c / a == b, "SafeMath: multiplication overflow");
32 
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39 
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43 
44         return c;
45     }
46 
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 }
56 
57 contract JILT  {
58 
59     using SafeMath for uint256;
60 
61     mapping (address => uint256) private _balances;
62     mapping (address => mapping (address => uint256)) private _allowances;
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 
66     uint256 private _totalSupply;
67     string private _name;
68     string private _symbol;
69     uint8 private _decimals;
70 
71     constructor () public {
72         _name="JILT ";
73         _symbol="JLT";
74         _decimals = 18;
75         _mint(_msgSender(), 65000000 * (10 ** uint256(decimals())));
76     }
77 
78 
79     function name() public view returns (string memory) {
80         return _name;
81     }
82 
83  
84     function symbol() public view returns (string memory) {
85         return _symbol;
86     }
87 
88     function decimals() public view returns (uint8) {
89         return _decimals;
90     }
91 
92     function totalSupply() public view returns (uint256) {
93         return _totalSupply;
94     }
95 
96     function balanceOf(address account) public view returns (uint256) {
97         return _balances[account];
98     }
99 
100     function transfer(address recipient, uint256 amount) public returns (bool) {
101         _transfer(_msgSender(), recipient, amount);
102         return true;
103     }
104 
105     function allowance(address owner, address spender) public view returns (uint256) {
106         return _allowances[owner][spender];
107     }
108 
109     function approve(address spender, uint256 amount) public returns (bool) {
110         _approve(_msgSender(), spender, amount);
111         return true;
112     }
113 
114     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
115         _transfer(sender, recipient, amount);
116         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
117         return true;
118     }
119 
120     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
121         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
122         return true;
123     }
124 
125     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
126         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
127         return true;
128     }
129 
130     function _transfer(address sender, address recipient, uint256 amount) internal {
131         require(sender != address(0), "ERC20: transfer from the zero address");
132         require(recipient != address(0), "ERC20: transfer to the zero address");
133 
134         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
135         _balances[recipient] = _balances[recipient].add(amount);
136         emit Transfer(sender, recipient, amount);
137     }
138 
139     function _mint(address account, uint256 amount) internal {
140         require(account != address(0), "ERC20: mint to the zero address");
141 
142         _totalSupply = _totalSupply.add(amount);
143         _balances[account] = _balances[account].add(amount);
144         emit Transfer(address(0), account, amount);
145     }
146 
147     function _burn(address account, uint256 amount) internal {
148         require(account != address(0), "ERC20: burn from the zero address");
149 
150         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
151         _totalSupply = _totalSupply.sub(amount);
152         emit Transfer(account, address(0), amount);
153     }
154 
155     function _approve(address owner, address spender, uint256 amount) internal {
156         require(owner != address(0), "ERC20: approve from the zero address");
157         require(spender != address(0), "ERC20: approve to the zero address");
158 
159         _allowances[owner][spender] = amount;
160         emit Approval(owner, spender, amount);
161     }
162 
163 
164     function _burnFrom(address account, uint256 amount) internal {
165         _burn(account, amount);
166         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
167     }     
168 
169     function _msgSender() internal view returns (address payable) {
170         return msg.sender;
171     }
172 
173     function _msgData() internal view returns (bytes memory) {
174         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
175         return msg.data;
176     }     
177 }