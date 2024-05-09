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
25         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
52         return mod(a, b, "SafeMath: modulo by zero");
53     }
54 
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;
58     }
59 }
60 
61 contract EXNCE {
62 
63     using SafeMath for uint256;
64 
65     mapping (address => uint256) private _balances;
66     mapping (address => mapping (address => uint256)) private _allowances;
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 
70     uint256 private _totalSupply;
71     string private _name;
72     string private _symbol;
73     uint8 private _decimals;
74 
75     constructor () public {
76         _name="EXNCE";
77         _symbol="XNC";
78         _decimals = 8;
79         _mint(_msgSender(), 500000 * (10 ** uint256(decimals())));
80     }
81 
82 
83     function name() public view returns (string memory) {
84         return _name;
85     }
86 
87  
88     function symbol() public view returns (string memory) {
89         return _symbol;
90     }
91 
92     function decimals() public view returns (uint8) {
93         return _decimals;
94     }
95 
96     function totalSupply() public view returns (uint256) {
97         return _totalSupply;
98     }
99 
100     function balanceOf(address account) public view returns (uint256) {
101         return _balances[account];
102     }
103 
104     function transfer(address recipient, uint256 amount) public returns (bool) {
105         _transfer(_msgSender(), recipient, amount);
106         return true;
107     }
108 
109     function allowance(address owner, address spender) public view returns (uint256) {
110         return _allowances[owner][spender];
111     }
112 
113     function approve(address spender, uint256 amount) public returns (bool) {
114         _approve(_msgSender(), spender, amount);
115         return true;
116     }
117 
118     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
119         _transfer(sender, recipient, amount);
120         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
121         return true;
122     }
123 
124     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
125         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
126         return true;
127     }
128 
129     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
130         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
131         return true;
132     }
133 
134     function _transfer(address sender, address recipient, uint256 amount) internal {
135         require(sender != address(0), "ERC20: transfer from the zero address");
136         require(recipient != address(0), "ERC20: transfer to the zero address");
137 
138         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
139         _balances[recipient] = _balances[recipient].add(amount);
140         emit Transfer(sender, recipient, amount);
141     }
142 
143     function _mint(address account, uint256 amount) internal {
144         require(account != address(0), "ERC20: mint to the zero address");
145 
146         _totalSupply = _totalSupply.add(amount);
147         _balances[account] = _balances[account].add(amount);
148         emit Transfer(address(0), account, amount);
149     }
150 
151     function _burn(address account, uint256 amount) internal {
152         require(account != address(0), "ERC20: burn from the zero address");
153 
154         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
155         _totalSupply = _totalSupply.sub(amount);
156         emit Transfer(account, address(0), amount);
157     }
158 
159     function _approve(address owner, address spender, uint256 amount) internal {
160         require(owner != address(0), "ERC20: approve from the zero address");
161         require(spender != address(0), "ERC20: approve to the zero address");
162 
163         _allowances[owner][spender] = amount;
164         emit Approval(owner, spender, amount);
165     }
166 
167     function _burnFrom(address account, uint256 amount) internal {
168         _burn(account, amount);
169         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
170     }     
171 
172     function _msgSender() internal view returns (address payable) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view returns (bytes memory) {
177         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
178         return msg.data;
179     }     
180 }