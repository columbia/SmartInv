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
16     // solhint-disable-previous-line no-empty-blocks
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 }
22 
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint) {
25         uint c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27 
28         return c;
29     }
30     function sub(uint a, uint b) internal pure returns (uint) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
34         require(b <= a, errorMessage);
35         uint c = a - b;
36 
37         return c;
38     }
39     function mul(uint a, uint b) internal pure returns (uint) {
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49     function div(uint a, uint b) internal pure returns (uint) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0, errorMessage);
55         uint c = a / b;
56 
57         return c;
58     }
59 }
60 
61 contract ERC20 is Context, IERC20 {
62     using SafeMath for uint;
63 
64     mapping (address => uint) internal _balances;
65 
66     mapping (address => mapping (address => uint)) private _allowances;
67 
68     uint internal totalSupply_;
69     function totalSupply() public view returns (uint) {
70         return totalSupply_;
71     }
72     function balanceOf(address account) public view returns (uint) {
73         return _balances[account];
74     }
75     function transfer(address recipient, uint amount) public returns (bool) {
76         _transfer(_msgSender(), recipient, amount);
77         return true;
78     }
79     function allowance(address owner, address spender) public view returns (uint) {
80         return _allowances[owner][spender];
81     }
82     function approve(address spender, uint amount) public returns (bool) {
83         _approve(_msgSender(), spender, amount);
84         return true;
85     }
86     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
87         _transfer(sender, recipient, amount);
88         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
89         return true;
90     }
91     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
92         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
93         return true;
94     }
95     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
96         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
97         return true;
98     }
99     function _transfer(address sender, address recipient, uint amount) internal {
100         require(sender != address(0), "ERC20: transfer from the zero address");
101         require(recipient != address(0), "ERC20: transfer to the zero address");
102 
103         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
104         _balances[recipient] = _balances[recipient].add(amount);
105         emit Transfer(sender, recipient, amount);
106     }
107     function _mint(address account, uint amount) internal {
108         require(account != address(0), "ERC20: mint to the zero address");
109 
110         totalSupply_ = totalSupply_.add(amount);
111         _balances[account] = _balances[account].add(amount);
112         emit Transfer(address(0), account, amount);
113     }
114     function _burn(address account, uint amount) internal {
115         require(account != address(0), "ERC20: burn from the zero address");
116 
117         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
118         totalSupply_ = totalSupply_.sub(amount);
119         emit Transfer(account, address(0), amount);
120     }
121     function _approve(address owner, address spender, uint amount) internal {
122         require(owner != address(0), "ERC20: approve from the zero address");
123         require(spender != address(0), "ERC20: approve to the zero address");
124 
125         _allowances[owner][spender] = amount;
126         emit Approval(owner, spender, amount);
127     }
128 }
129 
130 contract TYF is ERC20 {
131     using SafeMath for uint;
132 
133     string private _name;
134     string private _symbol;
135     uint8 private _decimals;
136 
137     address public owner;
138 
139     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address owner_) public {
140         _name = name;
141         _symbol = symbol;
142         _decimals = decimals;
143         owner = owner_;
144         totalSupply_ = totalSupply;
145         _balances[owner_] = totalSupply;
146     }
147 
148     function symbol() public view returns (string memory) {
149         return _symbol;
150     }
151 
152     function name() public view returns (string memory) {
153         return _name;
154     }
155 
156     function decimals() public view returns (uint8) {
157         return _decimals;
158     }
159 
160     function mint(address account, uint amount) public {
161         require(msg.sender == owner, "!owner");
162         _mint(account, amount);
163     }
164 
165     function setOwner(address _owner) public {
166         require(msg.sender == owner, "!owner");
167         owner = _owner;
168     }
169 }