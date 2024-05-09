1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 contract Context {
14   function _msgSender() internal view virtual returns (address payable) {
15     return msg.sender;
16   }
17 
18   function _msgData() internal view virtual returns (bytes memory) {
19     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20     return msg.data;
21   }
22 }
23 contract Owned {
24   address public owner;
25   address public newOwner;
26 
27   event OwnershipTransferred(address indexed _from, address indexed _to);
28 
29   constructor() public {
30     owner = msg.sender;
31   }
32 
33   modifier onlyOwner {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   function transferOwnership(address _newOwner) public onlyOwner {
39     newOwner = _newOwner;
40   }
41   function acceptOwnership() public {
42     require(msg.sender == newOwner);
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45     newOwner = address(0);
46   }
47 }
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80 
81         return c;
82     }
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         return mod(a, b, "SafeMath: modulo by zero");
85     }
86     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b != 0, errorMessage);
88         return a % b;
89     }
90 }
91 
92 contract SynLevToken is Context, IERC20, Owned {
93   using SafeMath for uint256;
94 
95   mapping (address => uint256) private _balances;
96 
97   mapping (address => mapping (address => uint256)) private _allowances;
98 
99   uint256 private _totalSupply;
100 
101   string private _name;
102   string private _symbol;
103   uint8 private _decimals;
104 
105   constructor () public {
106     _name = "SynLev";
107     _symbol = "SYN";
108     _decimals = 18;
109     _totalSupply = 100000000 * 10**18;
110     _balances[owner] = _balances[owner].add(_totalSupply);
111     emit Transfer(address(0), owner, _totalSupply);
112   }
113 
114   function name() public view returns (string memory) {
115     return _name;
116   }
117 
118   function symbol() public view returns (string memory) {
119     return _symbol;
120   }
121 
122   function decimals() public view returns (uint8) {
123     return _decimals;
124   }
125 
126   function totalSupply() public view override returns (uint256) {
127     return _totalSupply;
128   }
129 
130   function balanceOf(address account) public view override returns (uint256) {
131     return _balances[account];
132   }
133 
134   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
135     _transfer(_msgSender(), recipient, amount);
136     return true;
137   }
138 
139   function allowance(address owner, address spender) public view virtual override returns (uint256) {
140     return _allowances[owner][spender];
141   }
142 
143   function approve(address spender, uint256 amount) public virtual override returns (bool) {
144     _approve(_msgSender(), spender, amount);
145     return true;
146   }
147 
148   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
149     _transfer(sender, recipient, amount);
150     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
151     return true;
152   }
153 
154   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
155     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
156     return true;
157   }
158 
159   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
160     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
161     return true;
162   }
163 
164   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
165     require(sender != address(0), "ERC20: transfer from the zero address");
166     require(recipient != address(0), "ERC20: transfer to the zero address");
167 
168     _beforeTokenTransfer(sender, recipient, amount);
169 
170     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
171     _balances[recipient] = _balances[recipient].add(amount);
172     emit Transfer(sender, recipient, amount);
173   }
174 
175 
176   function _approve(address owner, address spender, uint256 amount) internal virtual {
177     require(owner != address(0), "ERC20: approve from the zero address");
178     require(spender != address(0), "ERC20: approve to the zero address");
179 
180     _allowances[owner][spender] = amount;
181     emit Approval(owner, spender, amount);
182   }
183 
184   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
185 }