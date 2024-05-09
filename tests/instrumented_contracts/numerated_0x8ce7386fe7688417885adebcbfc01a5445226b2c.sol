1 pragma solidity 0.5.17;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26 
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30 
31         return c;
32     }
33 }
34 
35 contract Context {
36     // Empty internal constructor, to prevent people from mistakenly deploying
37     // an instance of this contract, which should be used via inheritance.
38     constructor () internal { }
39     // solhint-disable-previous-line no-empty-blocks
40 
41     function _msgSender() internal view returns (address payable) {
42         return msg.sender;
43     }
44 }
45 
46 contract ERC20Detailed is IERC20 {
47     string private _name;
48     string private _symbol;
49     uint8 private _decimals;
50 
51     constructor (string memory name, string memory symbol, uint8 decimals) public {
52         _name = name;
53         _symbol = symbol;
54         _decimals = decimals;
55     }
56 
57     function name() public view returns (string memory) {
58         return _name;
59     }
60 
61     function symbol() public view returns (string memory) {
62         return _symbol;
63     }
64 
65     function decimals() public view returns (uint8) {
66         return _decimals;
67     }
68 }
69 
70 contract ERC20 is Context, IERC20 {
71     using SafeMath for uint256;
72 
73     mapping (address => uint256) private _balances;
74     mapping (address => mapping (address => uint256)) private _allowances;
75     uint256 private _totalSupply;
76 
77 
78     function totalSupply() public view returns (uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account) public view returns (uint256) {
83         return _balances[account];
84     }
85 
86     function transfer(address recipient, uint256 amount) public returns (bool) {
87         _transfer(_msgSender(), recipient, amount);
88         return true;
89     }
90 
91     function allowance(address owner, address spender) public view returns (uint256) {
92         return _allowances[owner][spender];
93     }
94 
95     function approve(address spender, uint256 amount) public returns (bool) {
96         _approve(_msgSender(), spender, amount);
97         return true;
98     }
99 
100     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
101         _transfer(sender, recipient, amount);
102         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
103         return true;
104     }
105 
106     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
107         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
108         return true;
109     }
110 
111     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
112         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
113         return true;
114     }
115 
116     function _transfer(address sender, address recipient, uint256 amount) internal {
117         require(sender != address(0), "ERC20: transfer from the zero address");
118         require(recipient != address(0), "ERC20: transfer to the zero address");
119 
120         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
121         _balances[recipient] = _balances[recipient].add(amount);
122         emit Transfer(sender, recipient, amount);
123     }
124 
125     function _mint(address account, uint256 amount) internal {
126         require(account != address(0), "ERC20: mint to the zero address");
127 
128         _totalSupply = _totalSupply.add(amount);
129         _balances[account] = _balances[account].add(amount);
130         emit Transfer(address(0), account, amount);
131     }
132     
133     function _approve(address owner, address spender, uint256 amount) internal {
134         require(owner != address(0), "ERC20: approve from the zero address");
135         require(spender != address(0), "ERC20: approve to the zero address");
136 
137         _allowances[owner][spender] = amount;
138         emit Approval(owner, spender, amount);
139     }
140 }
141 
142 contract GaugeField is ERC20, ERC20Detailed {
143     string private constant _name = "GaugeField";
144     string private constant _symbol = "GAUF";
145     uint8 private constant _decimals = 18;
146     address private constant _teamWallet= 0xB4F53f448DeD6E3394A4EC7a8Dfce44e1a1CE404;
147 
148     uint256 internal constant _tokenUnit = 10**18;
149     uint256 internal constant _hundredMillion = 10**8;
150     uint256 internal constant _totalSupply = 5 * _hundredMillion * _tokenUnit;
151 
152     constructor() ERC20Detailed(_name, _symbol, _decimals) public {
153         _mint(_teamWallet, _totalSupply);
154     }
155 }