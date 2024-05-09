1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-26
3 */
4 
5 pragma solidity ^0.5.16;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint);
9     function balanceOf(address account) external view returns (uint);
10     function transfer(address recipient, uint amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint);
12     function approve(address spender, uint amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
14 	event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 
18 library SafeMath {
19     
20     function add(uint a, uint b) internal pure returns (uint) {
21         uint c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26     
27     function sub(uint a, uint b) internal pure returns (uint) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     
31     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
32         require(b <= a, errorMessage);
33         uint c = a - b;
34 
35         return c;
36     }
37     
38     function mul(uint a, uint b) internal pure returns (uint) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45 
46         return c;
47     }
48     
49     function div(uint a, uint b) internal pure returns (uint) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52     
53     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0, errorMessage);
56         uint c = a / b;
57 
58         return c;
59     }
60 }
61 
62 
63 contract Context {
64     constructor () internal { }
65     // solhint-disable-previous-line no-empty-blocks
66 
67     function _msgSender() internal view returns (address payable) {
68         return msg.sender;
69     }
70 }
71 
72 contract ERC20 is Context, IERC20 {
73     using SafeMath for uint;
74 
75     mapping (address => uint) private _balances;
76 
77     mapping (address => mapping (address => uint)) private _allowances;
78 
79     uint private _totalSupply;
80     function totalSupply() public view returns (uint) {
81         return _totalSupply;
82     }
83     
84     function balanceOf(address account) public view returns (uint) {
85         return _balances[account];
86     }
87     
88     function transfer(address recipient, uint amount) public returns (bool) {
89         _transfer(_msgSender(), recipient, amount);
90         return true;
91     }
92     
93     function allowance(address owner, address spender) public view returns (uint) {
94         return _allowances[owner][spender];
95     }
96     
97     function approve(address spender, uint amount) public returns (bool) {
98         _approve(_msgSender(), spender, amount);
99         return true;
100     }
101     
102     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
103         _transfer(sender, recipient, amount);
104         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
105         return true;
106     }
107     
108     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
109         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
110         return true;
111     }
112     
113     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
114         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
115         return true;
116     }
117     
118     function _transfer(address sender, address recipient, uint amount) internal {
119         require(sender != address(0), "ERC20: transfer from the zero address");
120         require(recipient != address(0), "ERC20: transfer to the zero address");
121 
122         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
123         _balances[recipient] = _balances[recipient].add(amount);
124         emit Transfer(sender, recipient, amount);
125     }
126     
127     function _mint(address account, uint amount) internal {
128         require(account != address(0), "ERC20: mint to the zero address");
129 
130         _totalSupply = _totalSupply.add(amount);
131         _balances[account] = _balances[account].add(amount);
132         emit Transfer(address(0), account, amount);
133     }
134     
135     function _burn(address account, uint amount) internal {
136         require(account != address(0), "ERC20: burn from the zero address");
137 
138         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
139         _totalSupply = _totalSupply.sub(amount);
140         emit Transfer(account, address(0), amount);
141     }
142     
143     function _approve(address owner, address spender, uint amount) internal {
144         require(owner != address(0), "ERC20: approve from the zero address");
145         require(spender != address(0), "ERC20: approve to the zero address");
146 
147         _allowances[owner][spender] = amount;
148         emit Approval(owner, spender, amount);
149     }
150 }
151 
152 contract ERC20Detailed is ERC20 {
153     string private _name;
154     string private _symbol;
155     uint8 private _decimals;
156 
157     constructor (string memory name, string memory symbol, uint8 decimals) public {
158         _name = name;
159         _symbol = symbol;
160         _decimals = decimals;
161     }
162     function name() public view returns (string memory) {
163         return _name;
164     }
165     function symbol() public view returns (string memory) {
166         return _symbol;
167     }
168     function decimals() public view returns (uint8) {
169         return _decimals;
170     }
171 }
172 
173 contract RoomToken is ERC20Detailed {
174   
175   constructor () public ERC20Detailed("OptionRoom Token", "ROOM", 18) {
176       // mint 100,000,000 tokens with 18 decimals and send them to token deployer
177       // mint function is internal and can not be called after deployment
178       _mint(msg.sender,100000000e18 ); 
179   }
180 
181 }